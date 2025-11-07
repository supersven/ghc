#include "ffi_race_callback_c.h"
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <pthread.h>
#include <unistd.h>

// Structure to pass data to the callback thread
typedef struct {
    void (*callback)(void);
    int delay_ns;
} callback_data_t;

// Thread function that will invoke the callback after a short delay
// This creates the "C -> Haskell" callback part of the race
static void* callback_thread(void* arg) {
    callback_data_t* data = (callback_data_t*)arg;
    
    // Small random delay (0-100 microseconds)
    // This timing is critical - we want it very close to the return time
    if (data->delay_ns > 0) {
        struct timespec ts;
        ts.tv_sec = 0;
        ts.tv_nsec = data->delay_ns;
        nanosleep(&ts, NULL);
    }
    
    // Invoke the callback - this calls back into Haskell
    // and may need to create/use a task
    data->callback();
    
    free(data);
    return NULL;
}

// This function is called from Haskell with a "safe" FFI call
// Safe FFI calls suspend the Haskell task, which is the key to the race
void test_race(void (*callback)(void)) {
    static int initialized = 0;
    pthread_t thread;
    callback_data_t* data;
    int callback_delay_ns;
    int return_delay_ns;
    
    // Initialize random seed once
    if (!initialized) {
        srand(time(NULL) ^ getpid());
        initialized = 1;
    }
    
    // Generate random delays between 0-100 microseconds (0-100000 nanoseconds)
    // This creates scenarios where:
    // - callback happens before return (callback_delay < return_delay)
    //   -> callback while task is still suspended
    // - callback happens after return (callback_delay > return_delay)
    //   -> callback after task is recovered (safe, but tests the normal path)
    // - callback happens at the same time as return (callback_delay ≈ return_delay)
    //   -> RACE CONDITION: both trying to manipulate task state simultaneously
    callback_delay_ns = rand() % 100000;
    return_delay_ns = rand() % 100000;
    
    // Allocate data for the callback thread
    data = (callback_data_t*)malloc(sizeof(callback_data_t));
    if (data == NULL) {
        // If malloc fails, log and skip this iteration
        fprintf(stderr, "Warning: malloc failed in test_race\n");
        return;
    }
    data->callback = callback;
    data->delay_ns = callback_delay_ns;
    
    // Start a thread to invoke the callback after a delay
    // Using detached thread to avoid need to join
    if (pthread_create(&thread, NULL, callback_thread, data) != 0) {
        // If thread creation fails, free the allocated memory and log
        fprintf(stderr, "Warning: pthread_create failed in test_race\n");
        free(data);
        return;
    }
    pthread_detach(thread);
    
    // Wait before returning from this function
    // When we return, the Haskell RTS will call recoverSuspendedTask
    if (return_delay_ns > 0) {
        struct timespec ts;
        ts.tv_sec = 0;
        ts.tv_nsec = return_delay_ns;
        nanosleep(&ts, NULL);
    }
    
    // Return to Haskell - this triggers recoverSuspendedTask
    // The race condition can occur if the callback thread calls back into
    // Haskell (which may call suspendTask) at nearly the same time as we return
    // This can violate the assertion: ASSERT(incall->next == NULL && incall->prev == NULL)
}

#ifndef FFI_RACE_CALLBACK_H
#define FFI_RACE_CALLBACK_H

// Test function that returns at random times and invokes a callback
// at random times, with both timings very close to each other
void test_race(void (*callback)(void));

#endif // FFI_RACE_CALLBACK_H

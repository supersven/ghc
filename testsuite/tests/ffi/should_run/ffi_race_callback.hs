{-# LANGUAGE ForeignFunctionInterface #-}

-- Test to reproduce a race condition between returning from an FFI call
-- and invoking an FFI callback. This happens when both occur at nearly
-- the same time, potentially triggering the assertion at
-- rts/Schedule.c:2463: ASSERT(cap->suspended_ccalls == incall);
--
-- The scenario:
-- 1. Haskell makes a safe FFI call to C (task gets suspended)
-- 2. C calls back to Haskell via a callback (needs to use/create a task)
-- 3. C returns from the FFI call (task should be recovered)
-- If 2 and 3 happen at nearly the same time, a race condition may occur.

module Main where

import Foreign.Ptr
import Control.Monad (forever)
import System.IO
import Control.Concurrent (threadDelay)

-- Haskell callback that will be invoked from C
-- This callback does minimal work to maximize the chance of the race
callback :: IO ()
callback = return ()

-- FFI function that:
-- - Takes a callback function pointer
-- - Spawns a thread that will call the callback at a random time
-- - Returns at a random time
-- - Both times are very close to each other
foreign import ccall safe "ffi_race_callback_c.h test_race"
  test_race :: FunPtr (IO ()) -> IO ()

-- Wrapper to create a function pointer from our callback
foreign import ccall "wrapper"
  mkCallback :: IO () -> IO (FunPtr (IO ()))

main :: IO ()
main = do
  hSetBuffering stdout NoBuffering
  hSetBuffering stderr NoBuffering
  putStrLn "Starting FFI race condition reproducer..."
  putStrLn "This test runs forever. If it hits the race condition, it will abort with an assertion failure."
  putStrLn "Expected assertion: rts/Schedule.c:2463: ASSERT(cap->suspended_ccalls == incall);"
  
  -- Create function pointer for the callback
  callbackPtr <- mkCallback callback
  
  -- Run forever, repeatedly calling the C function
  -- Each iteration:
  -- 1. Makes a safe FFI call (suspends task)
  -- 2. C spawns thread to call callback at random time
  -- 3. C returns at random time (recovers task)
  -- Race occurs when callback and return happen simultaneously
  forever $ do
    test_race callbackPtr
    -- Small delay between iterations to let threads finish
    threadDelay 1000  -- 1ms

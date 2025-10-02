{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE UnliftedFFITypes #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE GHCForeignImportPrim #-}

-- Test Cmm division by zero - should fail
module Main where

import GHC.Types
import GHC.Exts
import GHC.Word
import GHC.Int

foreign import prim "testQuotInt8DivByZero" testQuotInt8DivByZero :: () -> Word#

main :: IO ()
main = do
    putStrLn "Testing Cmm div_like operations - division by zero"
    
    -- This should trigger the assertion and cause the program to exit
    let result = W# (testQuotInt8DivByZero ())
    putStrLn $ "ERROR: Should not reach here! Result: " ++ show result
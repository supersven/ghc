{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE UnliftedFFITypes #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE GHCForeignImportPrim #-}

-- Test Cmm integer overflow - should fail
module Main where

import GHC.Types
import GHC.Exts
import GHC.Word
import GHC.Int

foreign import prim "testQuotInt8Overflow" testQuotInt8Overflow :: () -> Word#

main :: IO ()
main = do
    putStrLn "Testing Cmm div_like operations - integer overflow"
    
    -- This should trigger the assertion and cause the program to exit
    let result = W# (testQuotInt8Overflow ())
    putStrLn $ "ERROR: Should not reach here! Result: " ++ show result
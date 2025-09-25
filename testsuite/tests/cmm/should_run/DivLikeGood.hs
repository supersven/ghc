{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE UnliftedFFITypes #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE GHCForeignImportPrim #-}

-- Test Cmm division operations - good cases
module Main where

import GHC.Types
import GHC.Exts
import GHC.Word
import GHC.Int

-- Good case imports
foreign import prim "testQuotInt8Good" testQuotInt8Good :: () -> Word#
foreign import prim "testRemInt8Good" testRemInt8Good :: () -> Word#
foreign import prim "testQuotWord8Good" testQuotWord8Good :: () -> Word#
foreign import prim "testRemWord8Good" testRemWord8Good :: () -> Word#
foreign import prim "testQuotInt16Good" testQuotInt16Good :: () -> Word#
foreign import prim "testRemInt16Good" testRemInt16Good :: () -> Word#

main :: IO ()
main = do
    putStrLn "Testing Cmm div_like operations - good cases"
    
    -- Test quotient operations
    let quotInt8Result = W# (testQuotInt8Good ())
    putStrLn $ "quotInt8# 42 6 = " ++ show quotInt8Result
    
    let remInt8Result = W# (testRemInt8Good ())
    putStrLn $ "remInt8# 42 6 = " ++ show remInt8Result
    
    let quotWord8Result = W# (testQuotWord8Good ())
    putStrLn $ "quotWord8# 100 10 = " ++ show quotWord8Result
    
    let remWord8Result = W# (testRemWord8Good ())
    putStrLn $ "remWord8# 100 10 = " ++ show remWord8Result
    
    let quotInt16Result = W# (testQuotInt16Good ())
    putStrLn $ "quotInt16# 1000 100 = " ++ show quotInt16Result
    
    let remInt16Result = W# (testRemInt16Good ())
    putStrLn $ "remInt16# 1000 100 = " ++ show remInt16Result
    
    putStrLn "All good cases completed successfully!"
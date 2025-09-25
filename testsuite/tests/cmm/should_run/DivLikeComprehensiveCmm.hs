{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE UnliftedFFITypes #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE GHCForeignImportPrim #-}

-- Comprehensive Cmm div_like operations test
module Main where

import GHC.Types
import GHC.Exts
import GHC.Word
import GHC.Int
import Control.Exception

-- 8-bit operations
foreign import prim "testQuotInt8" testQuotInt8 :: Int8# -> Int8# -> Word#
foreign import prim "testRemInt8" testRemInt8 :: Int8# -> Int8# -> Word#
foreign import prim "testQuotWord8" testQuotWord8 :: Word8# -> Word8# -> Word#
foreign import prim "testRemWord8" testRemWord8 :: Word8# -> Word8# -> Word#

-- 16-bit operations  
foreign import prim "testQuotInt16" testQuotInt16 :: Int16# -> Int16# -> Word#
foreign import prim "testRemInt16" testRemInt16 :: Int16# -> Int16# -> Word#

-- 32-bit operations
foreign import prim "testQuotInt32" testQuotInt32 :: Int32# -> Int32# -> Word#
foreign import prim "testRemInt32" testRemInt32 :: Int32# -> Int32# -> Word#

main :: IO ()
main = do
    putStrLn "Testing comprehensive Cmm div_like operations"
    
    -- Test good cases
    testGoodCases
    
    -- Test bad cases (should raise exceptions)
    testBadCases
    
    putStrLn "All comprehensive Cmm tests completed!"

testGoodCases :: IO ()
testGoodCases = do
    putStrLn "\n=== Good Cases ==="
    
    -- Int8 operations
    let quotResult = W# (testQuotInt8 42# 6#)
    putStrLn $ "quotInt8# 42 6 = " ++ show quotResult
    
    let remResult = W# (testRemInt8 42# 6#)
    putStrLn $ "remInt8# 42 6 = " ++ show remResult
    
    -- Word8 operations  
    let quotWordResult = W# (testQuotWord8 100## 10##)
    putStrLn $ "quotWord8# 100 10 = " ++ show quotWordResult
    
    let remWordResult = W# (testRemWord8 100## 10##)
    putStrLn $ "remWord8# 100 10 = " ++ show remWordResult
    
    -- Int16 operations
    let quotInt16Result = W# (testQuotInt16 1000# 100#)
    putStrLn $ "quotInt16# 1000 100 = " ++ show quotInt16Result
    
    let remInt16Result = W# (testRemInt16 1000# 100#)  
    putStrLn $ "remInt16# 1000 100 = " ++ show remInt16Result
    
    -- Int32 operations
    let quotInt32Result = W# (testQuotInt32 10000# 1000#)
    putStrLn $ "quotInt32# 10000 1000 = " ++ show quotInt32Result
    
    let remInt32Result = W# (testRemInt32 10000# 1000#)
    putStrLn $ "remInt32# 10000 1000 = " ++ show remInt32Result

testBadCases :: IO ()
testBadCases = do
    putStrLn "\n=== Bad Cases (should raise exceptions) ==="
    
    -- Test division by zero
    result1 <- try $ evaluate (W# (testQuotInt8 42# 0#))
    case result1 of
        Left (_ :: SomeException) -> putStrLn "✓ Int8 division by zero raised exception"
        Right val -> putStrLn $ "✗ Int8 division by zero should have failed: " ++ show val
    
    -- Test overflow  
    result2 <- try $ evaluate (W# (testQuotInt8 (-128#) (-1#)))
    case result2 of
        Left (_ :: SomeException) -> putStrLn "✓ Int8 overflow raised exception"
        Right val -> putStrLn $ "✗ Int8 overflow should have failed: " ++ show val
    
    -- Test Word division by zero
    result3 <- try $ evaluate (W# (testQuotWord8 100## 0##))
    case result3 of
        Left (_ :: SomeException) -> putStrLn "✓ Word8 division by zero raised exception"
        Right val -> putStrLn $ "✗ Word8 division by zero should have failed: " ++ show val
    
    -- Test Int16 overflow
    result4 <- try $ evaluate (W# (testQuotInt16 (-32768#) (-1#)))
    case result4 of
        Left (_ :: SomeException) -> putStrLn "✓ Int16 overflow raised exception"  
        Right val -> putStrLn $ "✗ Int16 overflow should have failed: " ++ show val
    
    -- Test Int32 overflow
    result5 <- try $ evaluate (W# (testQuotInt32 (-2147483648#) (-1#)))
    case result5 of
        Left (_ :: SomeException) -> putStrLn "✓ Int32 overflow raised exception"
        Right val -> putStrLn $ "✗ Int32 overflow should have failed: " ++ show val
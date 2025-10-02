{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}

-- | Test div_like primops exception handling
-- This test catches exceptions to verify they are properly raised
module Main where

import GHC.Exts
import GHC.Int
import GHC.Word
import GHC.Prim.Exception
import Control.Exception

main :: IO ()
main = do
    putStrLn "Testing div_like primop exception handling..."
    
    -- Test division by zero exception handling
    testDivisionByZeroHandling
    
    -- Test overflow exception handling
    testOverflowHandling
    
    -- Test Word division by zero
    testWordDivisionByZero
    
    putStrLn "All exception handling tests completed!"

testDivisionByZeroHandling :: IO ()
testDivisionByZeroHandling = do
    putStrLn "Testing Int8# division by zero exception handling"
    
    -- Test quotInt8# division by zero
    result1 <- try (evaluate (I8# (quotInt8# 42# 0#)))
    case result1 of
        Left (_ :: SomeException) -> putStrLn "  ✓ quotInt8# division by zero raised exception"
        Right val -> do
            putStrLn $ "  ✗ quotInt8# division by zero should have failed but got: " ++ show val
            error "Division by zero did not raise exception"
    
    -- Test remInt8# division by zero  
    result2 <- try (evaluate (I8# (remInt8# 42# 0#)))
    case result2 of
        Left (_ :: SomeException) -> putStrLn "  ✓ remInt8# division by zero raised exception"
        Right val -> do
            putStrLn $ "  ✗ remInt8# division by zero should have failed but got: " ++ show val
            error "Division by zero did not raise exception"
    
    -- Test quotRemInt8# division by zero
    result3 <- try (evaluate (case quotRemInt8# 42# 0# of (# q, r #) -> (I8# q, I8# r)))
    case result3 of
        Left (_ :: SomeException) -> putStrLn "  ✓ quotRemInt8# division by zero raised exception"
        Right val -> do
            putStrLn $ "  ✗ quotRemInt8# division by zero should have failed but got: " ++ show val
            error "Division by zero did not raise exception"

testOverflowHandling :: IO ()
testOverflowHandling = do
    putStrLn "Testing Int8# overflow exception handling"
    
    -- Test quotInt8# overflow (minBound / -1)
    result1 <- try (evaluate (I8# (quotInt8# (-128#) (-1#))))
    case result1 of
        Left (_ :: SomeException) -> putStrLn "  ✓ quotInt8# overflow raised exception"
        Right val -> do
            putStrLn $ "  ✗ quotInt8# overflow should have failed but got: " ++ show val
            error "Overflow did not raise exception"
    
    -- Test remInt8# overflow (minBound / -1)
    result2 <- try (evaluate (I8# (remInt8# (-128#) (-1#))))
    case result2 of
        Left (_ :: SomeException) -> putStrLn "  ✓ remInt8# overflow raised exception"
        Right val -> do
            putStrLn $ "  ✗ remInt8# overflow should have failed but got: " ++ show val
            error "Overflow did not raise exception"
    
    -- Test larger types
    -- Int16# overflow
    result3 <- try (evaluate (I16# (quotInt16# (-32768#) (-1#))))
    case result3 of
        Left (_ :: SomeException) -> putStrLn "  ✓ quotInt16# overflow raised exception"
        Right val -> do
            putStrLn $ "  ✗ quotInt16# overflow should have failed but got: " ++ show val
            error "Int16# overflow did not raise exception"

testWordDivisionByZero :: IO ()
testWordDivisionByZero = do
    putStrLn "Testing Word8# division by zero exception handling"
    
    -- Test quotWord8# division by zero
    result1 <- try (evaluate (W8# (quotWord8# 42## 0##)))
    case result1 of
        Left (_ :: SomeException) -> putStrLn "  ✓ quotWord8# division by zero raised exception"
        Right val -> do
            putStrLn $ "  ✗ quotWord8# division by zero should have failed but got: " ++ show val
            error "Word division by zero did not raise exception"
    
    -- Test remWord8# division by zero
    result2 <- try (evaluate (W8# (remWord8# 42## 0##)))
    case result2 of
        Left (_ :: SomeException) -> putStrLn "  ✓ remWord8# division by zero raised exception"
        Right val -> do
            putStrLn $ "  ✗ remWord8# division by zero should have failed but got: " ++ show val
            error "Word division by zero did not raise exception"
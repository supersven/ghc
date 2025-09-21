{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}

-- | Comprehensive test for all div_like primops 
-- Tests all integer types and operations for boundary conditions
module Main where

import GHC.Exts
import GHC.Int
import GHC.Word
import Control.Exception

main :: IO ()
main = do
    putStrLn "Comprehensive div_like primop boundary test..."
    
    -- Test all good cases first
    testAllGoodCases
    
    -- Test that bad cases properly fail
    testAllBadCases
    
    putStrLn "All comprehensive tests completed successfully!"

testAllGoodCases :: IO ()
testAllGoodCases = do
    putStrLn "\n=== Testing Good Cases ==="
    
    -- Test basic operations that should work
    testBasicOperations
    
    -- Test edge cases that should work
    testEdgeCases

testBasicOperations :: IO ()
testBasicOperations = do
    putStrLn "Testing basic operations..."
    
    -- Int8#
    checkGood "Int8# basic" (I8# (quotInt8# 42# 7#)) 6
    checkGood "Int8# rem" (I8# (remInt8# 42# 7#)) 0
    
    -- Int16#
    checkGood "Int16# basic" (I16# (quotInt16# 1000# 100#)) 10
    checkGood "Int16# rem" (I16# (remInt16# 1000# 100#)) 0
    
    -- Int32#
    checkGood "Int32# basic" (I32# (quotInt32# 10000# 100#)) 100
    checkGood "Int32# rem" (I32# (remInt32# 10000# 100#)) 0
    
    -- Int#
    checkGood "Int# basic" (I# (quotInt# 1000000# 1000#)) 1000
    checkGood "Int# rem" (I# (remInt# 1000000# 1000#)) 0
    
    -- Word8#
    checkGood "Word8# basic" (W8# (quotWord8# 200## 10##)) 20
    checkGood "Word8# rem" (W8# (remWord8# 200## 10##)) 0
    
    -- Word16#
    checkGood "Word16# basic" (W16# (quotWord16# 20000## 100##)) 200
    checkGood "Word16# rem" (W16# (remWord16# 20000## 100##)) 0
    
    -- Word32#
    checkGood "Word32# basic" (W32# (quotWord32# 200000## 1000##)) 200
    checkGood "Word32# rem" (W32# (remWord32# 200000## 1000##)) 0
    
    -- Word#
    checkGood "Word# basic" (W# (quotWord# 2000000## 1000##)) 2000
    checkGood "Word# rem" (W# (remWord# 2000000## 1000##)) 0

testEdgeCases :: IO ()
testEdgeCases = do
    putStrLn "Testing edge cases that should work..."
    
    -- Division by 1 (always safe)
    checkGood "Int8# div by 1" (I8# (quotInt8# 127# 1#)) 127
    checkGood "Int8# div maxBound by 1" (I8# (quotInt8# 127# 1#)) 127
    checkGood "Word8# div by 1" (W8# (quotWord8# 255## 1##)) 255
    
    -- Division where result is exactly representable
    checkGood "Int8# half minBound" (I8# (quotInt8# (-128#) 2#)) (-64)
    checkGood "Int16# half minBound" (I16# (quotInt16# (-32768#) 2#)) (-16384)
    
    -- Division by large numbers
    checkGood "Int8# div by large" (I8# (quotInt8# 100# 50#)) 2
    checkGood "Word8# div by large" (W8# (quotWord8# 200## 100##)) 2

testAllBadCases :: IO ()
testAllBadCases = do
    putStrLn "\n=== Testing Bad Cases (should raise exceptions) ==="
    
    -- Test division by zero for all types
    testDivisionByZeroAll
    
    -- Test overflow for signed types
    testOverflowAll

testDivisionByZeroAll :: IO ()
testDivisionByZeroAll = do
    putStrLn "Testing division by zero for all types..."
    
    -- Int8#
    checkBad "Int8# quot div by zero" (I8# (quotInt8# 42# 0#))
    checkBad "Int8# rem div by zero" (I8# (remInt8# 42# 0#))
    checkBadTuple "Int8# quotRem div by zero" (case quotRemInt8# 42# 0# of (# q, r #) -> (I8# q, I8# r))
    
    -- Int16#
    checkBad "Int16# quot div by zero" (I16# (quotInt16# 1000# 0#))
    checkBad "Int16# rem div by zero" (I16# (remInt16# 1000# 0#))
    
    -- Int32#
    checkBad "Int32# quot div by zero" (I32# (quotInt32# 10000# 0#))
    checkBad "Int32# rem div by zero" (I32# (remInt32# 10000# 0#))
    
    -- Int#
    checkBad "Int# quot div by zero" (I# (quotInt# 1000000# 0#))
    checkBad "Int# rem div by zero" (I# (remInt# 1000000# 0#))
    
    -- Word8#
    checkBad "Word8# quot div by zero" (W8# (quotWord8# 42## 0##))
    checkBad "Word8# rem div by zero" (W8# (remWord8# 42## 0##))
    
    -- Word16#
    checkBad "Word16# quot div by zero" (W16# (quotWord16# 1000## 0##))
    checkBad "Word16# rem div by zero" (W16# (remWord16# 1000## 0##))
    
    -- Word32#
    checkBad "Word32# quot div by zero" (W32# (quotWord32# 10000## 0##))
    checkBad "Word32# rem div by zero" (W32# (remWord32# 10000## 0##))
    
    -- Word#
    checkBad "Word# quot div by zero" (W# (quotWord# 1000000## 0##))
    checkBad "Word# rem div by zero" (W# (remWord# 1000000## 0##))

testOverflowAll :: IO ()
testOverflowAll = do
    putStrLn "Testing overflow for all signed types..."
    
    -- Int8# overflow (minBound / -1)
    checkBad "Int8# quot overflow" (I8# (quotInt8# (-128#) (-1#)))
    checkBad "Int8# rem overflow" (I8# (remInt8# (-128#) (-1#)))
    checkBadTuple "Int8# quotRem overflow" (case quotRemInt8# (-128#) (-1#) of (# q, r #) -> (I8# q, I8# r))
    
    -- Int16# overflow
    checkBad "Int16# quot overflow" (I16# (quotInt16# (-32768#) (-1#)))
    checkBad "Int16# rem overflow" (I16# (remInt16# (-32768#) (-1#)))
    
    -- Int32# overflow
    checkBad "Int32# quot overflow" (I32# (quotInt32# (-2147483648#) (-1#)))
    checkBad "Int32# rem overflow" (I32# (remInt32# (-2147483648#) (-1#)))

-- Helper functions
checkGood :: (Eq a, Show a) => String -> a -> a -> IO ()
checkGood desc actual expected 
    | actual == expected = putStrLn $ "  ✓ " ++ desc
    | otherwise = do
        putStrLn $ "  ✗ " ++ desc
        putStrLn $ "    Expected: " ++ show expected
        putStrLn $ "    Got:      " ++ show actual
        error $ "Good case test failed: " ++ desc

checkBad :: Show a => String -> a -> IO ()
checkBad desc expr = do
    result <- try (evaluate expr)
    case result of
        Left (_ :: SomeException) -> putStrLn $ "  ✓ " ++ desc ++ " (exception raised as expected)"
        Right val -> do
            putStrLn $ "  ✗ " ++ desc ++ " should have failed but got: " ++ show val
            error $ "Bad case test failed (no exception): " ++ desc

checkBadTuple :: Show a => String -> a -> IO ()
checkBadTuple = checkBad  -- Same implementation for tuples
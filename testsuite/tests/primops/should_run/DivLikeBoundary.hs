{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}

-- | Test div_like primops boundary conditions
-- This tests the "good cases" that should work with the new assertions
module Main where

import GHC.Exts
import GHC.Int
import GHC.Word

main :: IO ()
main = do
    putStrLn "Testing div_like primop good cases..."
    
    -- Test basic division that should work
    testInt8Good
    testInt16Good
    testInt32Good
    testIntGood
    testWord8Good
    testWord16Good
    testWord32Good
    testWordGood
    
    putStrLn "All div_like good cases passed!"

-- Test Int8# good cases
testInt8Good :: IO ()
testInt8Good = do
    putStrLn "Testing Int8# good cases"
    
    -- Normal division cases
    check "quotInt8# 42# 6#" (I8# (quotInt8# 42# 6#)) 7
    check "remInt8# 42# 6#" (I8# (remInt8# 42# 6#)) 0
    check "quotInt8# (-42#) 6#" (I8# (quotInt8# (-42#) 6#)) (-7)
    check "remInt8# (-42#) 6#" (I8# (remInt8# (-42#) 6#)) 0
    
    -- Edge cases that should work (not minBound / -1)
    check "quotInt8# 127# 1#" (I8# (quotInt8# 127# 1#)) 127
    check "quotInt8# (-127#) 1#" (I8# (quotInt8# (-127#) 1#)) (-127)
    check "quotInt8# (-128#) 2#" (I8# (quotInt8# (-128#) 2#)) (-64)
    
    -- quotRemInt8# cases
    let (# q, r #) = quotRemInt8# 42# 6#
    check "quotRemInt8# 42# 6# (quot)" (I8# q) 7
    check "quotRemInt8# 42# 6# (rem)" (I8# r) 0

-- Test Int16# good cases  
testInt16Good :: IO ()
testInt16Good = do
    putStrLn "Testing Int16# good cases"
    
    check "quotInt16# 1000# 10#" (I16# (quotInt16# 1000# 10#)) 100
    check "remInt16# 1000# 10#" (I16# (remInt16# 1000# 10#)) 0
    check "quotInt16# 32767# 1#" (I16# (quotInt16# 32767# 1#)) 32767
    check "quotInt16# (-32768#) 2#" (I16# (quotInt16# (-32768#) 2#)) (-16384)

-- Test Int32# good cases
testInt32Good :: IO ()
testInt32Good = do
    putStrLn "Testing Int32# good cases"
    
    check "quotInt32# 1000000# 1000#" (I32# (quotInt32# 1000000# 1000#)) 1000
    check "remInt32# 1000000# 1000#" (I32# (remInt32# 1000000# 1000#)) 0

-- Test Int# good cases
testIntGood :: IO ()
testIntGood = do
    putStrLn "Testing Int# good cases"
    
    check "quotInt# 1000000# 1000#" (I# (quotInt# 1000000# 1000#)) 1000
    check "remInt# 1000000# 1000#" (I# (remInt# 1000000# 1000#)) 0

-- Test Word8# good cases
testWord8Good :: IO ()
testWord8Good = do
    putStrLn "Testing Word8# good cases"
    
    check "quotWord8# 200## 10##" (W8# (quotWord8# 200## 10##)) 20
    check "remWord8# 200## 10##" (W8# (remWord8# 200## 10##)) 0
    check "quotWord8# 255## 1##" (W8# (quotWord8# 255## 1##)) 255

-- Test Word16# good cases
testWord16Good :: IO ()
testWord16Good = do
    putStrLn "Testing Word16# good cases"
    
    check "quotWord16# 10000## 100##" (W16# (quotWord16# 10000## 100##)) 100
    check "remWord16# 10000## 100##" (W16# (remWord16# 10000## 100##)) 0

-- Test Word32# good cases
testWord32Good :: IO ()
testWord32Good = do
    putStrLn "Testing Word32# good cases"
    
    check "quotWord32# 1000000## 1000##" (W32# (quotWord32# 1000000## 1000##)) 1000
    check "remWord32# 1000000## 1000##" (W32# (remWord32# 1000000## 1000##)) 0

-- Test Word# good cases
testWordGood :: IO ()
testWordGood = do
    putStrLn "Testing Word# good cases"
    
    check "quotWord# 1000000## 1000##" (W# (quotWord# 1000000## 1000##)) 1000
    check "remWord# 1000000## 1000##" (W# (remWord# 1000000## 1000##)) 0

-- Helper function to check results
check :: (Eq a, Show a) => String -> a -> a -> IO ()
check desc actual expected 
    | actual == expected = putStrLn $ "  ✓ " ++ desc
    | otherwise = do
        putStrLn $ "  ✗ " ++ desc
        putStrLn $ "    Expected: " ++ show expected
        putStrLn $ "    Got:      " ++ show actual
        error "Test failed"
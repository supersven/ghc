{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}

-- | Test div_like primops overflow cases that should trigger assertions
-- This test should fail with RaiseDivZero exceptions (for overflow)
module Main where

import GHC.Exts
import GHC.Int
import GHC.Prim.Exception
import Control.Exception

main :: IO ()
main = do
    putStrLn "Testing div_like primop overflow cases..."
    
    -- Test overflow cases (minBound / -1)
    testOverflow
    
    putStrLn "This line should not be reached!"

testOverflow :: IO ()
testOverflow = do
    putStrLn "Testing minBound / -1 overflow - should raise exception"
    
    -- This should trigger RaiseDivZeroOp due to overflow
    -- Int8# minBound is -128, and -128 / -1 would overflow
    let result = I8# (quotInt8# (-128#) (-1#))
    print result
    
    putStrLn "ERROR: Overflow did not raise exception!"
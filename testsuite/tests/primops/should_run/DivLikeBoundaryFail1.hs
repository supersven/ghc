{-# LANGUAGE MagicHash #-}
{-# LANGUAGE UnboxedTuples #-}

-- | Test div_like primops bad cases that should trigger assertions
-- This test should fail with RaiseDivZero exceptions
module Main where

import GHC.Exts
import GHC.Int
import GHC.Prim.Exception
import Control.Exception

main :: IO ()
main = do
    putStrLn "Testing div_like primop division by zero cases..."
    
    -- Test division by zero cases
    testDivisionByZero
    
    putStrLn "This line should not be reached!"

testDivisionByZero :: IO ()
testDivisionByZero = do
    putStrLn "Testing division by zero - should raise exception"
    
    -- This should trigger RaiseDivZeroOp
    let result = I8# (quotInt8# 42# 0#)
    print result
    
    putStrLn "ERROR: Division by zero did not raise exception!"
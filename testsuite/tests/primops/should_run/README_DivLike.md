# Div_like Primop Boundary Tests

This directory contains comprehensive tests for the div_like primop boundary conditions implemented in GHC. These tests verify that the runtime assertions added to prevent division by zero and integer overflow work correctly.

## Test Files

### DivLikeBoundary.hs
Tests the "good cases" that should work normally:
- Basic division operations for all integer types (Int8#, Int16#, Int32#, Int#, Word8#, Word16#, Word32#, Word#)
- Edge cases that should work (division by 1, safe divisions near boundaries)
- Expected to pass with normal execution

### DivLikeBoundaryFail1.hs
Tests division by zero cases that should fail:
- Attempts `quotInt8# 42# 0#` which should trigger RaiseDivZeroOp
- Expected to exit with code 1 (failure)

### DivLikeBoundaryFail2.hs  
Tests integer overflow cases that should fail:
- Attempts `quotInt8# (-128#) (-1#)` which would overflow
- Expected to exit with code 1 (failure)

### DivLikeBoundaryExceptions.hs
Tests proper exception handling:
- Uses `try` and `evaluate` to catch exceptions
- Verifies that division by zero raises exceptions for all types
- Verifies that overflow conditions raise exceptions for signed types
- Expected to pass by catching exceptions correctly

### DivLikeBoundaryComprehensive.hs
Comprehensive test covering all scenarios:
- Tests all good cases across all integer types
- Tests all bad cases (division by zero and overflow)
- Provides complete coverage of the div_like assertion implementation
- Expected to pass by properly handling both good and bad cases

## Implementation Coverage

These tests cover the following primops with the new boundary assertions:

**Signed Integer Operations:**
- quotInt8#, remInt8#, quotRemInt8#
- quotInt16#, remInt16#, quotRemInt16#
- quotInt32#, remInt32#, quotRemInt32#
- quotInt#, remInt#, quotRemInt#
- Int64QuotOp, Int64RemOp (when allowQuot64 is true)

**Unsigned Integer Operations:**
- quotWord8#, remWord8#, quotRemWord8#
- quotWord16#, remWord16#, quotRemWord16#
- quotWord32#, remWord32#, quotRemWord32#
- quotWord#, remWord#, quotRemWord#
- Word64QuotOp, Word64RemOp (when allowQuot64 is true)
- genericWordQuotRem2Op (double-word division)

## Assertion Logic

The tests verify two main boundary conditions:

1. **Division by Zero**: All div_like operations check that the divisor is not zero
2. **Integer Overflow**: Signed operations check for the overflow case where `dividend == minBound && divisor == -1`

When these conditions are violated, the operations call `RaiseDivZeroOp` which raises a runtime exception.

## Test Configuration

The tests are configured in `all.T`:
- Normal tests expect successful execution
- Fail tests expect `exit_code(1)` 
- Exception tests use proper exception handling to verify behavior
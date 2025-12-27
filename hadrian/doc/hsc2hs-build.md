# How `hsc2hs` is Built in GHC

This document explains how the `hsc2hs` utility is built as part of the GHC build process, including Hadrian build targets and its role in binary distributions.

## Overview

`hsc2hs` is a utility program that helps write Haskell bindings to C code. It reads an almost-Haskell source file with embedded special constructs and outputs a real Haskell file with these constructs processed based on information from C headers.

## Source Location

`hsc2hs` is maintained as a **Git submodule** in the GHC repository:

- **Submodule path**: `utils/hsc2hs`
- **Upstream repository**: `https://gitlab.haskell.org/ghc/hsc2hs.git`
- **Package definition**: Defined in `hadrian/src/Packages.hs` as a utility program

```haskell
hsc2hs = util "hsc2hs"
```

## Build Stage: Stage 0 Boot (GlobalLibs)

`hsc2hs` is built during **Stage0 with GlobalLibs**, which is a special early stage in the GHC build process:

### What is Stage0 GlobalLibs?

From `hadrian/src/Stage.hs`:

```haskell
-- Stage0 GlobalLibs is for **executables** which are built with the boot compiler
-- and boot compiler packages. For example, this was motivated by needing to
-- build hsc2hs, a build dependency of unix with just the boot toolchain.
```

### Why Stage0 GlobalLibs?

The separation of Stage0 into two modes (GlobalLibs and InTreeLibs) was created to solve a circular dependency problem:

1. **The Problem**: 
   - `bytestring` depends on `template-haskell`
   - This means many packages (including `unix` and `directory`) need to be built with Stage0
   - But `unix` depends on `hsc2hs` as a build tool
   - And `hsc2hs` depends on `directory`
   - This creates a circular dependency!

2. **The Solution**:
   - Build `hsc2hs` with the **boot compiler's libraries** (GlobalLibs) in Stage0
   - This breaks the circular dependency
   - Build other libraries with **in-tree libraries** (InTreeLibs) in Stage0

From `hadrian/src/Stage.hs`:
```haskell
-- 1. bytestring depends on template-haskell so we need to build bytestring with stage0 (and all
--    packages which depend on it). This includes unix and hence directory (which depends on unix) but
--    unix depends on hsc2hs (which depends on directory) and you get a loop in the build
--    rules if you try to build them all in the same package database.
--    The solution is to build hsc2hs with the global boot libraries in Stage0 GlobalLibs
```

### Builder Provenance

In `hadrian/src/Builder.hs`, `hsc2hs` is configured to be built at `stage0Boot`:

```haskell
builderProvenance :: Builder -> Maybe Context
builderProvenance = \case
    ...
    Hsc2Hs _         -> context stage0Boot hsc2hs
    ...
```

This means when Hadrian needs the `hsc2hs` builder, it will build it using the Stage0 GlobalLibs configuration.

## Key Components

### 1. The hsc2hs Executable

Built from the submodule source code at `utils/hsc2hs`, the executable is placed in:
```
<build_root>/stageBoot/bin/hsc2hs
```

### 2. Template File: `template-hsc.h`

`hsc2hs` requires a template file that defines how to process `.hsc` files. This is copied during the build:

**Source**: `utils/hsc2hs/data/template-hsc.h` (from the submodule)
**Destination**: `<build_root>/stage<N>/lib/template-hsc.h`

The copy rule is defined in `hadrian/src/Rules/Generate.hs`:

```haskell
prefix -/- "template-hsc.h" <~ return (pkgPath hsc2hs -/- "data")
```

This template is needed before building `hsc2hs` itself, as specified in `hadrian/src/Rules/Program.hs`:

```haskell
buildProgram :: FilePath -> Context -> [(Resource, Int)] -> Action ()
buildProgram bin ctx@(Context{..}) rs = do
  when (package == hsc2hs) $ do
    -- 'Hsc2hs' needs the @template-hsc.h@ file.
    template <- templateHscPath stage
    need [template]
```

### 3. Builder Configuration

The `hsc2hs` builder is configured with appropriate flags in `hadrian/src/Settings/Builders/Hsc2Hs.hs`, including:
- C compiler and linker paths
- Include directories (GMP, etc.)
- Architecture and OS-specific flags
- Template file location
- Cross-compilation flags (when applicable)

## Hadrian Build Targets

### Building hsc2hs

To build `hsc2hs` specifically with Hadrian, you can use:

```bash
# Build hsc2hs for Stage0
hadrian/build _build/stageBoot/bin/hsc2hs

# Or as part of stage boot packages
hadrian/build stageBoot:exe:hsc2hs
```

### Stage Boot Packages

`hsc2hs` is included in the list of Stage0 boot packages in `hadrian/src/Settings/Default.hs`:

```haskell
stageBootPackages :: Action [Package]
stageBootPackages = return
  [ lintersCommon, lintCommitMsg, lintSubmoduleRefs, lintWhitespace, lintNotes
  , hsc2hs
  , compareSizes
  , deriveConstants
  , genapply
  ...
  ]
```

### Building as Part of Full Build

When you run a standard Hadrian build:

```bash
hadrian/build
```

`hsc2hs` is automatically built as part of the Stage0 boot process before building the main compiler and libraries that depend on it.

## Role in Binary Distributions

### Inclusion in Bindist

`hsc2hs` is included in GHC binary distributions. From `hadrian/src/Rules/BinaryDist.hs`:

```haskell
| pkg `elem` [hpcBin, haddock, hp2ps, hsc2hs, ghc, ghcPkg]
```

When creating a binary distribution, Hadrian:

1. **Copies the executable** from the build directory to the bindist staging area:
   ```
   <build_root>/bindist/ghc-<version>-<arch>-<os>/bin/hsc2hs
   ```

2. **Copies the template file** to the lib directory:
   ```
   <build_root>/bindist/ghc-<version>-<arch>-<os>/lib/template-hsc.h
   ```

3. **Creates a wrapper script** (on Unix-like systems) that sets up the environment for `hsc2hs`, including proper paths to the template file and include directories.

### Wrapper Script

The wrapper script template is at `mk/hsc2hs.in`. It:
- Sets up C compiler and linker flags
- Configures the path to `template-hsc.h`
- Sets up include paths (e.g., for `HsFFI.h`)
- Handles response files (arguments from files)

The wrapper ensures that `hsc2hs` can find all necessary files regardless of where GHC is installed.

## Build Dependencies

### Prerequisites

To build `hsc2hs`:
1. A working Haskell compiler (boot compiler)
2. Boot compiler's standard libraries
3. The `hsc2hs` submodule must be initialized:
   ```bash
   git submodule update --init utils/hsc2hs
   ```

### What hsc2hs Depends On

`hsc2hs` itself has Haskell dependencies (from the boot compiler):
- `base`
- `directory`
- `process`
- `filepath`
- `containers`
- And other boot libraries

### What Depends on hsc2hs

Many GHC packages use `hsc2hs` to process `.hsc` files:
- `unix` (a core library with many FFI bindings)
- `directory` (depends on `unix`)
- `Win32` (on Windows)
- Various other packages with C FFI bindings

## Summary

1. **What**: `hsc2hs` is a utility for creating Haskell bindings to C code
2. **Where**: Maintained as a submodule at `utils/hsc2hs`
3. **When**: Built during Stage0 GlobalLibs (boot stage)
4. **Why Stage0 GlobalLibs**: To break circular dependencies with `unix` and `directory`
5. **Targets**: 
   - Direct: `hadrian/build _build/stageBoot/bin/hsc2hs`
   - Indirect: Built automatically as part of any full GHC build
6. **In Bindist**: Yes, included in all binary distributions with wrapper script
7. **Key Files**: 
   - Executable: `hsc2hs`
   - Template: `template-hsc.h`
   - Wrapper: Generated from `mk/hsc2hs.in`

## References

- User documentation: `docs/users_guide/utils.rst` (section on hsc2hs)
- Package definition: `hadrian/src/Packages.hs`
- Stage explanation: `hadrian/src/Stage.hs`
- Builder configuration: `hadrian/src/Settings/Builders/Hsc2Hs.hs`
- Binary dist rules: `hadrian/src/Rules/BinaryDist.hs`
- Template copy rule: `hadrian/src/Rules/Generate.hs`
- Program build rules: `hadrian/src/Rules/Program.hs`

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)

## [Eventual]

### Added

- support for Windows
- native Wayland support

### Removed

- `C'u8` as an alias to `CChar`

## [0.2.2] -- 2025-12-16

### Added

- enums `RGFW_keymod` and `RGFW_key` as `CUChar` aliases
    - all variants bound as constants
- `C'RGFW_bool` as `CUChar` alias. 0 is true, else is false
- new callback
    - `RGFW_keyfunc`
- various new methods in `RGFW.hsc`
    - `RGFW_window_setShouldClose`
    - `RGFW_pollEvents`
    - `RGFW_setKeyCallback`
- key callback functionallity in demo application
    - `esc` closes the window

### Changed

- modularized `hs-rgfw.cabal` for the sake of tidiness

### Deprecated

- `C'u8` as a type alias to `CChar`
    - such declarations are needed in C but not in Haskell
    - `CUChar` is the preferable type for cross-platform later

### Fixed

- correctly inherit `version` in `flake.nix`

## [0.2.1] -- 2025-12-16

### Changed

- submodule for `RGFW.h` to ensure reproducability
    - add `RGFW` as submodule
    - modify flake to copy self's submodules to the store
    - change include path of `library` in `hs-game.cabal`
    - change include path of `lib/RGFW.hsc`

### Removed

- random junk files from `lib`
    - no breaking changes, none were in any way linked

## [0.2.0] -- 2025-12-16

### Added

- example exe

### Changed

- probably everything ngl
- use SemVer instead of PVP

### Removed

- probably everything ngl

## [0.1.0.2] -- 2025-12-11

### Removed

- `scripts`
- `lib/Main.hs`

## [0.1.0.1] -- 2025-12-11

- does removing wayland but leaving the API intact count as breaking?

### Changed

- no more dependencies on wayland libraries or xkbcommon

### Removed

- any semblance of Wayland support; use wayland-satelite or something

## [0.1.0.0] -- 2025-12-10

### Removed

- `main` function and its functionality

### Changed

- migrate to Cabal; Nix still works
- now a library
    - build on Nix with `nix build`. object file is in `result/lib/hs-rgfw.so`
    - build on other platforms with `cabal build` after installing dependencies.

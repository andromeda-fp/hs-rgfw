# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)

## [Eventual]

### Added

- support for Windows
- support for actually doing anything
- autogen code

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

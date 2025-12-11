# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Eventual]

### Added

- support for Windows
- support for actually doing anything
- autogen code

## [1.0.0] -- 2025-12-10

### Removed

- `main` function and its functionality

### Changed

- migrate to Cabal; Nix still works
- now a library
    - build on Nix with `nix build`. object file is in `result/lib/hs-rgfw.so`
    - build on other platforms with `cabal build` after installing dependencies.

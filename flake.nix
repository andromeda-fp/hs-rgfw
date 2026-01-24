{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    hs-bindgen.url = "github:well-typed/hs-bindgen/fd74e8fa4216eccd67069ec9d8637b57000ffc83";
    self.submodules = true;
  };
  outputs = {
    nixpkgs,
    hs-bindgen,
    self,
    ...
  }: let
    version = "0.1.0";
    package = {
      mkDerivation,
      lib,
      base,
    }:
      mkDerivation {
        pname = "hs-rgfw";
        inherit version;
        src = ./.;
        libraryHaskellDepends = [
          base
        ];
        libraryPkgconfigDepends = [
        ];
        homepage = "https://git.mtgmonkey.net/Andromeda/hs-rgfw";
        license = lib.licenses.bsd3;
        platforms = ["x86_64-linux"];
      };
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        hs-bindgen.overlays.libclangBindings
        hs-bindgen.overlays.hsBindgen
      ];
    };
  in {
    devShells.${system} = {
      default = pkgs.mkShell {
        stdenv = pkgs.clangStdenv;
        packages = [
          pkgs.clang
          pkgs.cabal-install
          pkgs.hs-bindgen-cli
          pkgs.hsBindgenHook
        ];
        inputsFrom = [
          self.packages.${system}.default
        ];
      };
    };
    packages.${system} = {
      default = pkgs.haskellPackages.callPackage package {};
    };
  };
}

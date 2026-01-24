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
      # nix stuff
      mkDerivation,
      lib,
      # haskell deps
      base,
      c-expr-runtime,
      hs-bindgen-runtime,
      # pkgconfig deps
      libGL,
      libX11,
      libXcursor,
      libXi,
      xrandr,
      # shell deps
      hs-bindgen-cli,
    }:
      mkDerivation {
        pname = "hs-rgfw";
        inherit version;
        src = ./.;
        libraryHaskellDepends = [
          base
          c-expr-runtime
          hs-bindgen-runtime
        ];
        libraryPkgconfigDepends = [
          libGL
          libX11
          libXcursor
          libXi
          xrandr
        ];
        preBuild = ''
          set -x
          export PATH=${hs-bindgen-cli}/bin:$PATH
          ./generate.sh
          set +x
        '';
        homepage = "https://git.mtgmonkey.net/Andromeda/hs-rgfw";
        license = lib.licenses.gpl3Only;
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

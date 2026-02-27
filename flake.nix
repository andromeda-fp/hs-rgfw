{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    hs-bindgen.url = "github:well-typed/hs-bindgen";
    self.submodules = true;
  };
  outputs = {
    nixpkgs,
    hs-bindgen,
    self,
    ...
  }: let
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
          pkgs.haskellPackages.ghcide
          pkgs.haskellPackages.ormolu
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
      default =
        (pkgs.haskell.packages.ghc912.callCabal2nix "hs-rgfw" ./. {
          xi = pkgs.libxi;
          gl = pkgs.libGL;
          xcursor = pkgs.libxcursor;
          xrandr = pkgs.xrandr;
        }).overrideAttrs {
          preConfigure = ''
            export PATH=${pkgs.clang}/bin:${pkgs.hs-bindgen-cli}/bin:${pkgs.tree}/bin:$PATH
            ./generate.sh
          '';
        };
    };
  };
}

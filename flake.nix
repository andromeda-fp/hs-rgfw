{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };
  outputs = {
    nixpkgs,
    self,
    ...
  }: let
    version = "0.2.0";
    package = {
      mkDerivation,
      base,
      bindings-DSL,
      gl,
      lib,
      libGL,
      libX11,
      xcursor,
      xi,
      xrandr,
    }:
      mkDerivation {
        pname = "hs-rgfw";
        version = "0.2.0";
        src = ./.;
        libraryHaskellDepends = [
          base
          bindings-DSL
        ];
        libraryPkgconfigDepends = [
          gl
          libGL
          libX11
          xcursor
          xi
          xrandr
        ];
        homepage = "https://git.mtgmonkey.net/Andromeda/hs-rgfw";
        license = lib.licenses.bsd3;
        platforms = ["x86_64-linux"];
      };
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = {
      default = pkgs.haskellPackages.callPackage package {
        xcursor = pkgs.xorg.libXcursor;
        xi = pkgs.xorg.libXi;
      };
    };
    devShells.${system} = {
      default = pkgs.mkShell {
        packages = [
          pkgs.cabal-install
        ];
        inputsFrom = [
          self.packages.${system}.default
        ];
      };
    };
  };
}

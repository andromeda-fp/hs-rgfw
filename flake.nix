{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };
  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    debugGhcOptions = pkgs.lib.concatStringsSep " " (debugGhcFlags ++ commonGhcFlags);
    debugGhcFlags =
      [
        "-O0"
        "-Wall"
        "-Widentities"
        "-Wincomplete-record-updates"
        "-Wincomplete-uni-patterns"
        # "-Wmissing-export-lists"
        "-Wmissing-home-modules"
        "-Wpartial-fields"
        "-Wredundant-constraints"
      ]
      ++ commonGhcFlags;
    haddockOptions = pkgs.lib.concatStringsSep " " haddockFlags;
    haddockFlags = [
      "--html"
      "--odir docs"
      "--optghc=-i./src"
      "src/Game.hs"
    ];
    releaseGhcOptions = pkgs.lib.concatStringsSep " " (releaseGhcFlags ++ commonGhcFlags);
    releaseGhcFlags =
      [
        "-O2"
        "-threaded"
        "-rtsopts"
        "-with-rtsopts=-N"
        "-main-is Main"
      ]
      ++ commonGhcFlags;
    noHaddockOptions = "";
    commonGhcFlags = [
      "-i./src"
      "-threaded"
      "-rtsopts"
      "-with-rtsopts=-N"
      "-main-is Main"
    ];
    ghcPackages = p: [
    ];
    buildDeps = [
      pkgs.pkg-config
      pkgs.wayland-protocols
      pkgs.wayland-scanner

      pkgs.egl-wayland
      pkgs.libGL
      pkgs.libxkbcommon
      pkgs.wayland
      pkgs.xorg.libX11
      pkgs.xorg.libXcursor
      pkgs.xorg.libXi
      pkgs.xorg.libXrandr
    ];
  in {
    packages.${system} = {
      debug = pkgs.callPackage ./package.nix {
        ghcOptions = debugGhcOptions;
        haddockOptions = noHaddockOptions;
        inherit ghcPackages;
        inherit buildDeps;
      };
      release = pkgs.callPackage ./package.nix {
        ghcOptions = releaseGhcOptions;
        haddockOptions = noHaddockOptions;
        inherit ghcPackages;
        inherit buildDeps;
      };
      docs = pkgs.callPackage ./package.nix {
        ghcOptions = "--version";
        inherit haddockOptions;
        inherit ghcPackages;
        inherit buildDeps;
      };
      default = pkgs.callPackage ./package.nix {
        ghcOptions = releaseGhcOptions;
        inherit haddockOptions;
        inherit ghcPackages;
        inherit buildDeps;
      };
    };
  };
}

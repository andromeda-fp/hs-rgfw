{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };
  outputs = {
    nixpkgs,
    self,
    ...
  }: let
    package = {
      mkDerivation,
      base,
      gl,
      lib,
      libGL,
      libX11,
      libxkbcommon,
      wayland,
      xcursor,
      xi,
      xrandr,
    }:
      mkDerivation {
        pname = "hs-rgfw";
        version = "0.1.0.0";
        src = ./.;
        preBuild = ''
          ${lib.getExe pkgs.wayland-scanner} public-code ${pkgs.wayland-protocols}/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml ./lib/xdg-shell.c
          ${lib.getExe pkgs.wayland-scanner} public-code ${pkgs.wayland-protocols}/share/wayland-protocols/staging/xdg-toplevel-icon/xdg-toplevel-icon-v1.xml ./lib/xdg-toplevel-icon-v1.c
          ${lib.getExe pkgs.wayland-scanner} public-code ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/xdg-decoration/xdg-decoration-unstable-v1.xml ./lib/xdg-decoration-unstable-v1.c
          ${lib.getExe pkgs.wayland-scanner} public-code ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/relative-pointer/relative-pointer-unstable-v1.xml ./lib/relative-pointer-unstable-v1.c
          ${lib.getExe pkgs.wayland-scanner} public-code ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml ./lib/pointer-constraints-unstable-v1.c
          ${lib.getExe pkgs.wayland-scanner} public-code ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/xdg-output/xdg-output-unstable-v1.xml ./lib/xdg-output-unstable-v1.c
          ${lib.getExe pkgs.wayland-scanner} client-header ${pkgs.wayland-protocols}/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml ./lib/xdg-shell.h
          ${lib.getExe pkgs.wayland-scanner} client-header ${pkgs.wayland-protocols}/share/wayland-protocols/staging/xdg-toplevel-icon/xdg-toplevel-icon-v1.xml ./lib/xdg-toplevel-icon-v1.h
          ${lib.getExe pkgs.wayland-scanner} client-header ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/xdg-decoration/xdg-decoration-unstable-v1.xml ./lib/xdg-decoration-unstable-v1.h
          ${lib.getExe pkgs.wayland-scanner} client-header ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/relative-pointer/relative-pointer-unstable-v1.xml ./lib/relative-pointer-unstable-v1.h
          ${lib.getExe pkgs.wayland-scanner} client-header ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml ./lib/pointer-constraints-unstable-v1.h
          ${lib.getExe pkgs.wayland-scanner} client-header ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/xdg-output/xdg-output-unstable-v1.xml ./lib/xdg-output-unstable-v1.h
        '';
        libraryHaskellDepends = [
          base
        ];
        libraryPkgconfigDepends = [
          gl
          libGL
          libX11
          libxkbcommon
          wayland
          xcursor
          xi
          xrandr
        ];
        postInstall = ''
        '';
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

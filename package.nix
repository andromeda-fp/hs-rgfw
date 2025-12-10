{
  buildDeps,
  runtimeDeps,
  haskellPackages,
  lib,
  pkgs,
  stdenv,
  ghcOptions,
  haddockOptions,
  ghcPackages,
  ...
}:
stdenv.mkDerivation rec {
  pname = "hs-rgfw";
  version = "0.1.0";
  src = ./.;
  nativeBuildInputs =
    [
      (haskellPackages.ghcWithPackages ghcPackages)
    ]
    ++ buildDeps ++ runtimeDeps;
  buildInputs =
    [
    ]
    ++ runtimeDeps;
  configurePhase = ''
    export PKG_CONFIG_PATH=/run/current-system/sw/lib/pkgconfig

    mkdir ccode
    wayland-scanner public-code ${pkgs.wayland-protocols}/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml ./ccode/xdg-shell.c
    wayland-scanner public-code ${pkgs.wayland-protocols}/share/wayland-protocols/staging/xdg-toplevel-icon/xdg-toplevel-icon-v1.xml ./ccode/xdg-toplevel-icon-v1.c
    wayland-scanner public-code ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/xdg-decoration/xdg-decoration-unstable-v1.xml ./ccode/xdg-decoration-unstable-v1.c
    wayland-scanner public-code ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/relative-pointer/relative-pointer-unstable-v1.xml ./ccode/relative-pointer-unstable-v1.c
    wayland-scanner public-code ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml ./ccode/pointer-constraints-unstable-v1.c
    wayland-scanner public-code ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/xdg-output/xdg-output-unstable-v1.xml ./ccode/xdg-output-unstable-v1.c

    mkdir headers
    wayland-scanner client-header ${pkgs.wayland-protocols}/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml ./headers/xdg-shell.h
    wayland-scanner client-header ${pkgs.wayland-protocols}/share/wayland-protocols/staging/xdg-toplevel-icon/xdg-toplevel-icon-v1.xml ./headers/xdg-toplevel-icon-v1.h
    wayland-scanner client-header ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/xdg-decoration/xdg-decoration-unstable-v1.xml ./headers/xdg-decoration-unstable-v1.h
    wayland-scanner client-header ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/relative-pointer/relative-pointer-unstable-v1.xml ./headers/relative-pointer-unstable-v1.h
    wayland-scanner client-header ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/pointer-constraints/pointer-constraints-unstable-v1.xml ./headers/pointer-constraints-unstable-v1.h
    wayland-scanner client-header ${pkgs.wayland-protocols}/share/wayland-protocols/unstable/xdg-output/xdg-output-unstable-v1.xml ./headers/xdg-output-unstable-v1.h
  '';
  buildPhase = ''
    mkdir src/lib
    cp -r lib/* src/lib/
    cp ccode/*.c ./
    ghc ${ghcOptions} ./src/Main.hs -o ./Main $(pkg-config --cflags --libs gl wayland-client wayland-egl wayland-cursor xkbcommon x11 xcursor xrandr xi) -I./headers/ $(ls *.c)
    mkdir ./docs
    haddock ${haddockOptions}
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp ./Main $out/bin/hs-rgfw
    cp ./docs $out/docs -r
    wrapProgram "$out/bin/${meta.mainProgram}" --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
  '';

  meta = {
    homepage = "https://mtgmonkey.net";
    license = lib.licenses.bsd3;
    mainProgram = "hs-rgfw";
    platforms = ["x86_64-linux"];
  };
}

echo "# copying header..."

mkdir -p lib/include
cp rgfw/RGFW.h lib/include/RGFW.h

echo "# creating flags for hs-bindgen-cli..."

export CFLAGS=$(pkg-config --cflags x11 xcursor xrandr xi gl xrender xext xfixes)
HBC_ARGS=""

for token in $CFLAGS; do
  case "$token" in
    -I* ) HBC_ARGS="$HBC_ARGS $token" ;;
    -D* ) HBC_ARGS="$HBC_ARGS --define-macro ${token#-D}" ;;
    *   ) HBC_ARGS="$HBC_ARGS --clang-option $token" ;;
  esac
done

echo "# creating c file from header..."

# other macro definitions should be defined with ghc-options: -copt-D in *.cabal
cat > lib/RGFW.c <<EOF
#define RGFW_IMPLEMENTATION
#include "RGFW.h"
EOF

echo "# generating library RGFW.Generated..."

#  --unsafe _unsafe \
#  --pointer _pointer \
set -x
hs-bindgen-cli preprocess \
  -Ilib/include \
  --unique-id andromeda.hs-rgfw \
  --create-output-dirs \
  --overwrite-files \
  --single-file \
  --safe _safe \
  --hs-output-dir lib \
  --module RGFW.Generated \
  --define-macro=RGFW_OPENGL \
  --define-macro=RGFW_EXPORT \
  $HBC_ARGS \
  RGFW.h
set +x

echo "# generated filetree:"

tree lib

set -x
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

cat > lib/RGFW.c <<EOF
#define RGFW_IMPLEMENTATION
#define RGFW_OPENGL
#define RGFW_EXPORT
#include "RGFW.h"
EOF

echo "# creating c object file..."

clang -c lib/RGFW.c -o lib/RGFW.o $CFLAGS -Ilib/include

echo "# generating library RGFW.Generated..."

hs-bindgen-cli preprocess \
  -Ilib/include \
  --parse-from-main-header-dirs \
  --create-output-dirs \
  --overwrite-files \
  --hs-output-dir lib \
  --module RGFW.Generated \
  --define-macro=RGFW_OPENGL \
  --define-macro=RGFW_EXPORT \
  --define-macro=RGFW_IMPLEMENTATION \
  $HBC_ARGS \
  RGFW.h

echo "# file tree generated:"
tree lib

set +x

hs-bindgen-cli preprocess \
  -Irgfw \
  --create-output-dirs \
  --overwrite-files \
  --hs-output-dir lib \
  --module RGFW.Generated \
  --clang-option=-DRGFW_OPENGL \
  RGFW.h

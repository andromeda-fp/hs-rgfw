#ifndef RGFW_HS // avoid repeated imports
#define RGFW_HS

// TODO add actual include logic

#define RGFW_IMPLEMENTATION
#define RGFW_DEBUG
#define RGFW_X11
#define RGFW_WAYLAND
#define RGFW_OPENGL

#define Time X11Time // fixes namespace clash with GHC when building with Nix
#include "RGFW.h"
#undef Time

#endif RGFW_HS

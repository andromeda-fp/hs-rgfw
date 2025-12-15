{-# OPTIONS_GHC -fno-warn-unused-imports #-}
#include <bindings.dsl.h>
module RGFW where
import Foreign.Ptr
#strict_import
#include <RGFW.h>

#synonym_t u8 , CChar

#opaque_t RGFW_window

#ccall RGFW_createWindow , CString -> CInt -> CInt -> CInt -> CInt -> CUInt -> IO (Ptr <struct RGFW_window>)

#synonym_t RGFW_windowFlags , CUInt
#num RGFW_windowNoBorder
#num RGFW_windowNoResize
#num RGFW_windowAllowDND
#num RGFW_windowHideMouse
#num RGFW_windowFullscreen
#num RGFW_windowTransparent
#num RGFW_windowCenter
#num RGFW_windowRawMouse
#num RGFW_windowScaleToMonitor
#num RGFW_windowHide
#num RGFW_windowMaximize
#num RGFW_windowCenterCursor
#num RGFW_windowFloating
#num RGFW_windowFocusOnShow
#num RGFW_windowMinimize
#num RGFW_windowFocus
#num RGFW_windowOpenGL
#num RGFW_windowEGL
#num RGFW_windowedFullscreen

#ccall RGFW_window_shouldClose , Ptr <struct RGFW_window> -> IO CUChar

#ccall RGFW_window_swapBuffers_OpenGL , Ptr <struct RGFW_window> -> IO ()

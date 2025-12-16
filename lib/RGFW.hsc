{-# OPTIONS_GHC -fno-warn-unused-imports #-}
#include <bindings.dsl.h>
module RGFW where
import Foreign.Ptr
#strict_import
#include <RGFW.h>

-- | DEPRECATED, please use a CUChar instead.
#synonym_t u8 , CChar

#synonym_t RGFW_bool , CUChar

--------------------------------------------------------------------------------
-- OPAQUE TYPES
--------------------------------------------------------------------------------
#opaque_t RGFW_window

--------------------------------------------------------------------------------
-- ENUMS
--------------------------------------------------------------------------------
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

#synonym_t RGFW_keymod , CUChar
#num RGFW_modCapsLock
#num RGFW_modNumLock
#num RGFW_modControl
#num RGFW_modAlt
#num RGFW_modShift
#num RGFW_modSuper
#num RGFW_modScrollLock

#synonym_t RGFW_key , CUChar
#num RGFW_keyNULL
#num RGFW_escape
#num RGFW_backtick
#num RGFW_0
#num RGFW_1
#num RGFW_2
#num RGFW_3
#num RGFW_4
#num RGFW_5
#num RGFW_6
#num RGFW_7
#num RGFW_8
#num RGFW_9
#num RGFW_minus
#num RGFW_equals
#num RGFW_backSpace
#num RGFW_tab
#num RGFW_space
#num RGFW_a
#num RGFW_b
#num RGFW_c
#num RGFW_d
#num RGFW_e
#num RGFW_f
#num RGFW_g
#num RGFW_h
#num RGFW_i
#num RGFW_j
#num RGFW_k
#num RGFW_l
#num RGFW_m
#num RGFW_n
#num RGFW_o
#num RGFW_p
#num RGFW_q
#num RGFW_r
#num RGFW_s
#num RGFW_t
#num RGFW_u
#num RGFW_v
#num RGFW_w
#num RGFW_x
#num RGFW_y
#num RGFW_z
#num RGFW_period
#num RGFW_comma
#num RGFW_slash
#num RGFW_bracket
#num RGFW_closeBracket
#num RGFW_semicolon
#num RGFW_apostrophe
#num RGFW_backSlash
#num RGFW_return
#num RGFW_enter
#num RGFW_delete
#num RGFW_F1
#num RGFW_F2
#num RGFW_F3
#num RGFW_F4
#num RGFW_F5
#num RGFW_F6
#num RGFW_F7
#num RGFW_F8
#num RGFW_F9
#num RGFW_F10
#num RGFW_F11
#num RGFW_F12
#num RGFW_F13
#num RGFW_F14
#num RGFW_F15
#num RGFW_F16
#num RGFW_F17
#num RGFW_F18
#num RGFW_F19
#num RGFW_F20
#num RGFW_F21
#num RGFW_F22
#num RGFW_F23
#num RGFW_F24
#num RGFW_F25
#num RGFW_capsLock
#num RGFW_shiftL
#num RGFW_controlL
#num RGFW_altL
#num RGFW_superL
#num RGFW_shiftR
#num RGFW_controlR
#num RGFW_altR
#num RGFW_superR
#num RGFW_up
#num RGFW_down
#num RGFW_left
#num RGFW_right
#num RGFW_insert
#num RGFW_menu
#num RGFW_end
#num RGFW_home
#num RGFW_pageUp
#num RGFW_pageDown
#num RGFW_numLock
#num RGFW_kpSlash
#num RGFW_kpMultiply
#num RGFW_kpPlus
#num RGFW_kpMinus
#num RGFW_kpEqual
#num RGFW_kp1
#num RGFW_kp2
#num RGFW_kp3
#num RGFW_kp4
#num RGFW_kp5
#num RGFW_kp6
#num RGFW_kp7
#num RGFW_kp8
#num RGFW_kp9
#num RGFW_kp0
#num RGFW_kpPeriod
#num RGFW_kpReturn
#num RGFW_scrollLock
#num RGFW_printScreen
#num RGFW_pause
#num RGFW_world1
#num RGFW_world2
#num RGFW_keyLast

--------------------------------------------------------------------------------
-- FUNCTIONS : WINDOWING
--------------------------------------------------------------------------------
#ccall RGFW_createWindow , CString -> CInt -> CInt -> CInt -> CInt -> CUInt -> IO (Ptr <struct RGFW_window>)
#ccall RGFW_window_shouldClose , Ptr <struct RGFW_window> -> IO CUChar
#ccall RGFW_window_swapBuffers_OpenGL , Ptr <struct RGFW_window> -> IO ()
#ccall RGFW_window_setShouldClose , Ptr <struct RGFW_window> -> CUChar -> IO ()

--------------------------------------------------------------------------------
-- FUNCTIONS : EVENTS
--------------------------------------------------------------------------------
#ccall RGFW_pollEvents , IO ()
#callback RGFW_keyfunc , Ptr <struct RGFW_window> -> CUChar -> CUChar -> CUChar -> CUChar -> CUChar -> IO ()
#ccall RGFW_setKeyCallback , <RGFW_keyfunc> -> IO <RGFW_keyfunc>

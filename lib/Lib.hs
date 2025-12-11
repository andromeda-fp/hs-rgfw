{-# LANGUAGE CApiFFI #-}

module Lib where

import Data.Bits (shiftL, (.|.))
import Foreign
import Foreign.C.String
import Foreign.C.Types

--------------------------------------------------------------------------------
-- Haskell-ier abstractions
--------------------------------------------------------------------------------

data WindowFlags
  = WindowNoBorder
  | WindowNoResize
  | WindowAllowDND
  | WindowHideMouse
  | WindowFullscreen
  | WindowTransparent
  | WindowCenter
  | WindowRawMouse
  | WindowScaleToMonitor
  | WindowHide
  | WindowMaximize
  | WindowCenterCursor
  | WindowFloating
  | WindowFocusOnShow
  | WindowMinimize
  | WindowFocus
  | WindowOpenGL
  | WindowEGL
  | WindowedFullscreen

mkWindowFlags :: [WindowFlags] -> RGFWwindowFlags
mkWindowFlags [] = 0
mkWindowFlags (flag:flags) =
  let
    shift =
      case flag of
        WindowNoBorder -> 0
        WindowNoResize -> 1
        WindowAllowDND -> 2
        WindowHideMouse -> 3
        WindowFullscreen -> 4
        WindowTransparent -> 5
        WindowCenter -> 6
        WindowRawMouse -> 7
        WindowScaleToMonitor -> 8
        WindowHide -> 9
        WindowMaximize -> 10
        WindowCenterCursor -> 11
        WindowFloating -> 12
        WindowFocusOnShow -> 13
        WindowMinimize -> 14
        WindowFocus -> 15
        WindowOpenGL -> 17
        WindowEGL -> 18
        _ -> 19 -- TODO fix this silent error, implement windowedFullscreen
  in
    (shiftL 1 shift) .|. (mkWindowFlags flags)

--------------------------------------------------------------------------------
-- directly from RFGW.h
--------------------------------------------------------------------------------

-- RGFWindow 
data RGFWwindow
-- ptr
type RGFWwindowPtr = Ptr RGFWwindow
-- flags to create
type RGFWwindowFlags = Word32

type RGFWbool = CUInt

foreign import capi "RGFW_HS.h RGFW_createWindow" rgfwCreateWindow
  :: Ptr CChar
  -> CInt
  -> CInt
  -> CInt
  -> CInt
  -> RGFWwindowFlags
  -> IO RGFWwindowPtr

foreign import capi "RGFW_HS.h RGFW_window_shouldClose" rgfwWindowShouldClose
  :: RGFWwindowPtr
  -> IO RGFWbool

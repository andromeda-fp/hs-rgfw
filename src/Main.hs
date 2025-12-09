{-# LANGUAGE CApiFFI #-}

module Main (main) where

import Data.Bits (shiftL, (.|.))
import Foreign
import Foreign.C.String
import Foreign.C.Types

--------------------------------------------------------------------------------
-- main
--------------------------------------------------------------------------------

main :: IO ()
main = do
  window <- withCString "a window" (\name ->
              rgfwCreateWindow
                name
                0
                0
                800
                600
                $ mkWindowFlags 
                  [ WindowCenter
                  , WindowNoResize
                  , WindowOpenGL
                  ]
              )
  let loop = do
        putStrLn $ show window
        putStrLn
          $ show
            $ mkWindowFlags 
              [ WindowCenter
              , WindowNoResize
              , WindowOpenGL
              ]
        shouldClose <- rgfwWindowShouldClose window
        if 0 == shouldClose
        then return ()
        else loop
  loop

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

foreign import capi "lib/RGFW.h RGFW_createWindow" rgfwCreateWindow
  :: CString
  -> Int32
  -> Int32
  -> Int32
  -> Int32
  -> RGFWwindowFlags
  -> IO RGFWwindowPtr

foreign import capi "lib/RGFW.h RGFW_window_shouldClose" rgfwWindowShouldClose
  :: RGFWwindowPtr
  -> IO RGFWbool

module Main where

import RGFW.Generated
import Foreign.C.Types (CChar)
import Foreign.C.String (newCString)
import Foreign.C.ConstPtr
import Data.Bits ((.|.))

main :: IO ()
main = do

  -- disable wayland, can't be bothered
  _ <- rGFW_useWayland_safe $ RGFW_bool 0

  -- create window. This string does not need to be freed, the window stays open
  windowTitle_cstr <- newCString "window"
  let
    windowTitle_ptr = ConstPtr windowTitle_cstr
    windowFlags = RGFW_windowFlags $ fromIntegral $ RGFW_windowCenter .|. RGFW_windowNoResize .|. RGFW_windowOpenGL

  window_ptr <- rGFW_createWindow_safe
    windowTitle_ptr -- name
    100 -- x
    100 -- y
    100 -- w
    100 -- h
    windowFlags -- flags
  putDebug $ "windowFlags: " ++ (show $ unwrapU32 $ unwrapRGFW_windowFlags windowFlags)
  putDebug $ "window_ptr: " ++ (show $ window_ptr)
  putDebug "created window"
  loop 0

loop :: Int -> IO ()
loop i = loop $ i + 1

putDebug :: String -> IO ()
putDebug a = putStrLn $ "[debug] " ++ a

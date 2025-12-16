module Main (main) where

import Foreign.C.String (withCString)
import Foreign.C.Types
import Foreign.Ptr

import RGFW

--------------------------------------------------------------------------------
-- main
--------------------------------------------------------------------------------

main :: IO ()
main = do
  window <- withCString "window <3" (\name ->
    c'RGFW_createWindow 
      name
      0
      0
      800
      600
      $ sum
        [ c'RGFW_windowNoResize
        , c'RGFW_windowOpenGL
        , c'RGFW_windowedFullscreen
        ]
    )
  keyfuncPtr <- mk'RGFW_keyfunc keyfunc
  c'RGFW_setKeyCallback keyfuncPtr
  putStrLn $ show window
  let loop ctr = do
        shouldClose <- c'RGFW_window_shouldClose window
        if 0 /= shouldClose
        then return shouldClose
        else do
          c'RGFW_pollEvents
          c'RGFW_window_swapBuffers_OpenGL window
          loop $ ctr + 1
  exitCode <- loop (0 :: Integer)
  putStrLn $ show exitCode
  freeHaskellFunPtr keyfuncPtr
  return ()

type RGFW_keyfunc = Ptr C'RGFW_window -> C'RGFW_key -> CUChar -> C'RGFW_keymod -> C'RGFW_bool -> C'RGFW_bool -> IO ()

keyfunc :: RGFW_keyfunc
keyfunc window key sym mod repeat pressed = do
  if key == c'RGFW_escape && mod == 0 then do
    c'RGFW_window_setShouldClose window 1
  else
    return ()

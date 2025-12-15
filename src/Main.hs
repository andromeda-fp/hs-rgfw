module Main (main) where

import Foreign.C.String (withCString)

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
  putStrLn $ show window
  let loop ctr = do
        shouldClose <- c'RGFW_window_shouldClose window
        if 0 /= shouldClose
        then return shouldClose
        else do
          c'RGFW_window_swapBuffers_OpenGL window
          loop $ ctr + 1
  exitCode <- loop (0 :: Integer)
  putStrLn $ show exitCode
  return ()

{-# LANGUAGE MultilineStrings #-}

module Main where

import Data.Bits ((.|.))
import Foreign.C.ConstPtr
import Foreign.C.String (newCString)
import Foreign.C.Types (CChar)
import Foreign.Ptr (Ptr)
import Graphics.Rendering.OpenGL (($=))
import qualified Graphics.Rendering.OpenGL as GL
import LoadShaders
import RGFW.Generated

main :: IO ()
main = do
  putStrInfo "creating window"
  -- string not freed; window remains open
  windowTitle_cstr <- newCString "window"
  let windowTitle_ptr = ConstPtr windowTitle_cstr
      windowFlags = RGFW_windowFlags $ fromIntegral $ RGFW_windowCenter .|. RGFW_windowNoResize .|. RGFW_windowOpenGL

  window <-
    rGFW_createWindow_safe
      windowTitle_ptr -- name
      0 -- x
      0 -- y
      300 -- w
      300 -- h
      windowFlags -- flags
  putStrDebug $ "windowFlags: " ++ (show $ unwrapU32 $ unwrapRGFW_windowFlags windowFlags)
  putStrDebug $ "window: " ++ (show $ window)
  putStrInfo "initialising shaders"
  _ <- initResources
  putStrInfo "entering loop"
  loop window 0

loop :: Ptr RGFW_window -> Int -> IO ()
loop window i = do
  view
  rGFW_window_swapBuffers_OpenGL_safe window
  loop window $ i + 1

putStrDebug :: String -> IO ()
putStrDebug a = putStrLn $ "[debug]:" ++ a

putStrInfo :: String -> IO ()
putStrInfo a = putStrLn $ "[info]:" ++ a

initResources :: IO GL.Program
initResources = do
  program <-
    loadShaders
      [ ShaderInfo GL.VertexShader $ StringSource vertShader,
        ShaderInfo GL.FragmentShader $ StringSource fragShader
      ]
  GL.currentProgram $= Just program
  return program
  where
    vertShader =
      """
      #version 330 core
      layout (location = 0) in vec3 aPos;

      out vec4 vertexColor;

      void main()
      {
        gl_Position = vec4(aPos, 1.0);
        vertexColor = vec4(0.5, 0.0, 0.0, 1.0);
      }
      """
    fragShader =
      """
      #version 330 core
      out vec4 FragColor;

      in vec4 vertexColor;

      void main()
      {
        FragColor = vertexColor;
      }
      """

view :: IO ()
view = do
  GL.clearColor $= GL.Color4 1 0 1 1
  GL.clear [GL.ColorBuffer, GL.DepthBuffer]

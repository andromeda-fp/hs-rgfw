{-# LANGUAGE CApiFFI #-}

module Main (main) where

import Data.Bits (shiftL, (.|.))
import Foreign
import Foreign.C.String
import Foreign.C.Types

import Lib

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
                  [ WindowNoResize
                  , WindowOpenGL
                  , WindowFullscreen
                  ]
              )
  let loop ctr = do
        shouldClose <- rgfwWindowShouldClose window
        if 0 /= shouldClose
        then return shouldClose
        else loop $ ctr + 1
  exitCode <- loop 0
  putStrLn $ show exitCode
  return ()

module Main where

import qualified Foreign.Ptr (ToFunPtr)

import qualified RGFW.Generated as RGFW

main :: IO ()
main = do
  putStrLn "Hello World"
  window <- toFunPtr ()

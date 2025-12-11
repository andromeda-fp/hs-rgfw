{-# LANGUAGE CPP #-}

module Main (main) where

import Distribution.Simple (defaultMain)
import System.Process (callCommand)

main :: IO ()
main = do
  callCommand "./scripts/generate.sh"
  defaultMain
  callCommand "./scripts/delete-generated.sh"

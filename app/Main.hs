module Main where

-- TODO: built in git pull, don't build if no changes
-- TODO: define variables in config file

import Control.Monad (when)
import SrcUpdate.ParseFile
import SrcUpdate.RebuildConfig
import SrcUpdate.TermColor
import System.Directory (doesFileExist, getCurrentDirectory)
import System.Environment (getArgs)
import System.Exit (exitFailure, exitSuccess)
import System.Posix (getEnv)

main :: IO ()
main = do
  homeDir <- getEnv "HOME"
  args <- getArgs
  startingDir <- getCurrentDirectory

  let runner = rebuildConfig startingDir

  when (null args) $
    case homeDir of
      -- TODO: make this be ~/.config
      Just home -> runner (configFile home) >> exitSuccess
      Nothing -> putErrLn "$HOME not defined, exitting" >> exitFailure

  let providedConfig = head args
  fileExists <- doesFileExist providedConfig

  when fileExists $ do
    runner providedConfig
    exitSuccess

  putErrLn ("File " ++ providedConfig ++ " not found! exitting")
  exitFailure

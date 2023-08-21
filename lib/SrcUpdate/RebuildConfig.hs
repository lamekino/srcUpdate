module SrcUpdate.RebuildConfig where

import Control.Monad ((<=<))
import Data.Maybe (catMaybes)
import SrcUpdate.ParseFile
import SrcUpdate.TermColor
import System.Exit (ExitCode (ExitFailure, ExitSuccess))
import System.IO (hPutStrLn, stderr)
import System.Posix (changeWorkingDirectory, getWorkingDirectory)
import System.Process (spawnCommand, waitForProcess)

putErrLn :: String -> IO ()
putErrLn = hPutStrLn stderr

configFile :: FilePath -> FilePath
configFile rootPath = rootPath ++ subDirectory ++ configFileName
  where
    subDirectory = "/"
    configFileName = "build-list"

runCmd :: Command -> IO ExitCode
runCmd cmd = (putStrLn . wrapInColor') ("+ " ++ cmd) >> spawn cmd
  where
    wrapInColor' = wrapInColor FG Yellow
    spawn = waitForProcess <=< spawnCommand

runUntilFailure :: FilePath -> [Command] -> IO ()
runUntilFailure _ [] = return ()
runUntilFailure fp (cmd : remaining) = do
  exit <- runCmd cmd

  -- TODO: can i use `when` here instead?
  if exit == ExitSuccess
    then do
      runUntilFailure fp remaining
    else do
      let wrapInColor' = wrapInColor FG Red
       in (putErrLn . wrapInColor') ("!!! failed to finish build for " ++ fp)
      return ()

runInstructions :: FilePath -> BuildInstructions -> IO ()
runInstructions oldFilePath inst =
  (putStrLn . wrapInColor') ("!!! starting build for " ++ newFilePath)
    >> changeWorkingDirectory newFilePath
    >> runUntilFailure newFilePath xs
    >> changeWorkingDirectory oldFilePath
  where
    wrapInColor' = wrapInColor FG Magenta
    newFilePath = path inst
    xs = cmds inst

rebuildConfig :: FilePath -> FilePath -> IO ()
rebuildConfig cwd config =
  mapM_ (runInstructions cwd)
    . catMaybes
    . parseFile
    . lines
    =<< readFile config

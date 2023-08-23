module SrcUpdate.ParseFile where

import Data.Bifunctor (Bifunctor (second))

type Command = String

data BuildInstructions = BuildInstructions
  { path :: FilePath,
    -- TODO:
    -- vcsUpdate :: Maybe String
    -- skip :: Bool
    cmds :: [Command]
  }
  deriving (Show, Eq)

parseFile :: [String] -> [Maybe BuildInstructions]
parseFile contents =
  case span (/= "") contents of
    (match, []) ->
      [parseSection match]
    (firstMatch, remaining) ->
      parseSection firstMatch
        : parseFile (dropWhile (== "") remaining)

parseSection :: [String] -> Maybe BuildInstructions
parseSection s =
  case s of
    (('#' : ' ' : path) : cmds) ->
      Just $ BuildInstructions {path = path, cmds = cmds}
    _ -> Nothing

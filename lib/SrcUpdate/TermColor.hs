module SrcUpdate.TermColor where

data TermColorBase
  = FG
  | BG
  deriving (Show, Eq)

data TermColor
  = Black
  | Red
  | Green
  | Yellow
  | Blue
  | Magenta
  | Cyan
  | White
  deriving (Eq)

ansiCode :: TermColorBase -> TermColor -> String
ansiCode base c
  | c == Black = wrap $ code base 0
  | c == Red = wrap $ code base 1
  | c == Green = wrap $ code base 2
  | c == Yellow = wrap $ code base 3
  | c == Blue = wrap $ code base 4
  | c == Magenta = wrap $ code base 5
  | c == Cyan = wrap $ code base 6
  | c == White = wrap $ code base 7
  where
    wrap i = "\ESC[" ++ show i ++ "m"
    code FG i = 30 + i
    code BG i = 40 + i

ansiCode' :: TermColorBase -> TermColor -> String
ansiCode' base c = undefined
  where
    colorCode = [0 .. length colors]
    colors = [Black, Red, Green, Yellow, Blue, Magenta, Cyan, White]
    wrap i = "\ESC[" ++ show i ++ "m"
    code FG i = 30 + i
    code BG i = 40 + i

wrapInColor :: TermColorBase -> TermColor -> String -> String
wrapInColor base c s = ansiCode base c ++ s ++ ansiCodeReset
  where
    ansiCodeReset = "\ESC[0m"

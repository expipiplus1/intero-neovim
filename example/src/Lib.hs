module Lib
    ( someFunc
    ) where

import Data.Char (toUpper)

someFunc :: IO ()
someFunc = putStrLn "someFunc"

foo :: String -> Int
foo = length
  where
    bar = 2

repl :: IO ()
repl = do
    putStr "Enter a thing:"
    x <- getLine
    putStr (fmap toUpper x)
    repl

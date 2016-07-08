module Lib
    ( someFunc
    ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"

foo :: String -> Int
foo = length
  where
    bar = 2

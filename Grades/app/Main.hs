module Main where

import ShowGrades

main :: IO ()
main = do
  csv <- readFile "grades.csv"
  putStr $ concat [nicerKormos csv, nicerRoes csv, nicerElefthera csv, moreInfo csv]
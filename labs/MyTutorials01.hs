{-# LANGUAGE BangPatterns #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Tutorials01 where

import Data.Function

-- TASK 1
pythagoreanTriples :: Int -> [(Int, Int, Int)]
pythagoreanTriples n
  | n <= 0 = []
  | otherwise = [(a, b, c) | c <- [1 .. n], b <- [1 .. c - 1], a <- [1 .. b - 1], a ^ 2 + b ^ 2 == c ^ 2]

-- TASK 2
isPrime :: Int -> Bool
isPrime n
  | n <= 1 = False
  | n <= 3 = True
  | even n = False
  | otherwise = all (/= 0) [mod n k | k <- [2 .. s]]
  where
    s = n & fromIntegral & sqrt & floor

-- s = floor $ sqrt $ fromIntegral n
-- s = (floor . sqrt . fromIntegral) n

primeSumPairs :: [Int] -> [(Int, Int)]
primeSumPairs [] = []
primeSumPairs (x : xs) = [(x, y) | y <- xs, x < y, isPrime (x + y)] ++ primeSumPairs xs

-- TASK 3
substrings :: String -> [String]
substrings [] = [[]]
substrings [a] = [[a]]
substrings (x : xs) = [x : take n xs | n <- [0 .. (length xs)]] ++ substrings xs

-- TASK 4
divisorPairs :: [Int] -> [(Int, Int)]
divisorPairs [] = []
divisorPairs [_] = []
divisorPairs (x : xs) = [(x, y) | y <- xs, y `mod` x == 0] ++ [(y, x) | y <- xs, x `mod` y == 0] ++ divisorPairs xs

-- TASK 5
combinations :: Int -> [a] -> [[a]]
combinations 0 _ = [[]]
combinations k [] = []
combinations k (x : xs) = [x : tail | tail <- combinations (k - 1) xs] ++ combinations k xs

-- TASK 6
strictSumBang1 :: [Int] -> Int
strictSumBang1 list = go list 0
  where
    go [] n = n
    go (x : xs) n = let m = x + n in seq m go xs m

-- TASK 6`
strictSumBang2 :: [Int] -> Int
strictSumBang2 list = go list 0
  where
    go [] !n = n -- Bang forces the reduction to Normal Form
    go (x : xs) !n = go xs (x + n)

-- TASK 7
factorial :: Int -> Int
factorial n = go n 1
  where
    go 0 !acc = acc
    go 1 !acc = acc
    go m !acc = go (m - 1) (m * acc)

-- TASK 8
forceTuple :: (Int, Int) -> Int
forceTuple (x, y) = seq x (seq y (x + y))

-- TASK 9
fib1 :: Int -> [Int]
fib1 n = go n 0 1 []
  where
    go 0 _ f xs = f : xs
    go m !f1 !f2 xs = go (m - 1) f2 (f1 + f2) (f2 : xs)

-- TASK 10

main :: IO ()
main = do
  print "2"

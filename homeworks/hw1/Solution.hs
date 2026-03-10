{-# LANGUAGE BangPatterns #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

import Data.Function

-- TASK 1
isPrime :: Int -> Bool
isPrime n
  | n <= 1 = False
  | n <= 3 = True
  | even n = False
  | otherwise = 0 `notElem` [mod n k | k <- [2 .. s]]
  where
    s = n & fromIntegral & sqrt & floor

goldbachPairs :: Int -> [(Int, Int)]
goldbachPairs 2 = []
goldbachPairs n
  | even n = [(k, n - k) | k <- [2 .. div n 2], isPrime k, isPrime (n - k)]
  | otherwise = []

-- TASK 2
coprimePairs :: [Int] -> [(Int, Int)]
coprimePairs [] = []
coprimePairs [a] = []
coprimePairs (x : xs) = [(x, y) | y <- xs, y > x, gcd x y == 1] ++ coprimePairs xs

-- TASK 3
-- I don't think that is is actually much faster than previous impl
-- because we still have to do the modulus operation which is quite slow
-- compared to multiplication (~50 cycles vs ~1-3 cycles)
sieve :: [Int] -> [Int]
sieve [] = []
sieve (x : xs) = x : sieve [y | y <- xs, mod y x /= 0]

primesTo :: Int -> [Int]
primesTo n = sieve [2 .. n]

isPrime2 :: Int -> Bool
isPrime2 n
  | n < 2 = False
  | otherwise = n `elem` primesTo n

-- TASK 4
matMul :: [[Int]] -> [[Int]] -> [[Int]]
matMul a b = [[sum [a !! i !! k * b !! k !! j | k <- [0 .. length b - 1]] | j <- [0 .. (length b - 1)]] | i <- [0 .. (length a - 1)]]

-- TASK 5
permutations :: (Eq a) => Int -> [a] -> [[a]]
permutations 0 _ = []
permutations 1 list = [[x] | x <- list]
permutations n list = [x : xs | x <- list, xs <- permutations (n - 1) list, x `notElem` xs]

-- TASK 6
-- I understand that I should remove duplicates across lists
-- not in the each of the lists
merge :: (Ord a) => [a] -> [a] -> [a]
merge a b = go a b []
  where
    go [] [] !out = out
    go [] list !out = out ++ list
    go list [] !out = out ++ list
    go (x : xs) (y : ys) !out
      | x < y = out ++ [x] ++ go xs (y : ys) out
      | x > y = out ++ [y] ++ go (x : xs) ys out
      | otherwise = out ++ [x] ++ go xs ys out

hamming :: [Integer]
hamming = 1 : merge (merge ([x * 2 | x <- hamming]) ([x * 3 | x <- hamming])) [x * 5 | x <- hamming]

-- take 10 hamming - worked
-- take 10 (drop 100000 hamming) - worked :o

-- TASK 7
power :: Int -> Int -> Int
power _ 0 = 1
power 1 _ = 1
power 0 _ = 0
power b e = go b e 1
  where
    go b 0 !acc = acc
    go b e !acc = go b (e - 1) (b * acc)

-- TASK 8
listMax :: [Int] -> Int
listMax list = go list 0
  where
    go :: [Int] -> Int -> Int
    go [] !acc = acc
    go (x : xs) !acc = go xs (max x acc)

listMaxSeq :: [Int] -> Int
listMaxSeq list = go list 0
  where
    go :: [Int] -> Int -> Int
    go [] acc = acc
    go (x : xs) acc = let m = max x acc in seq m go xs m

-- TASK 9
primes :: [Int]
primes = sieve [2 ..]

isPrime3 :: Int -> Bool
isPrime3 n = go primes n
  where
    go :: [Int] -> Int -> Bool
    go (x : xs) n
      | n < x = False
      | n == x = True
      | n > x = go xs n

-- TASK 10
-- The bang before the entire tuple did not helped
-- The LSP alone said that the bang expression is redundant.
-- It has to be applied to each of the components individually.
mean1 :: [Double] -> Double
mean1 list = go list (0.0, 0.0)
  where
    go :: [Double] -> (Double, Double) -> Double
    go [] (!elemSum, !count) = elemSum / count
    go (x : xs) (!elemSum, !count) = go xs (elemSum + x, count + 1.0)

meanAndVar :: [Double] -> (Double, Double)
meanAndVar list = go list (0.0, 0.0, 0.0)
  where
    go :: [Double] -> (Double, Double, Double) -> (Double, Double)
    go [] (!elemSum, !elemSumSq, !count) = let mu = elemSum / count in seq mu (mu, (elemSumSq / count) - (mu ^ 2))
    go (x : xs) (!elemSum, !elemSumSq, !count) = go xs (elemSum + x, elemSumSq + (x ^ 2), count + 1.0)

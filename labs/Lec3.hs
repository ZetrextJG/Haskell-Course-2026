{-# LANGUAGE BangPatterns #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Lec3 where

import qualified Data.Monoid as M

-- b # a = b
--
-- foldl (#) seed [a1..an] -> ((...seed # a1) # a2) # ... # an
-- foldr (*) seed [a1..an] -> a1 * (a2 * (... (an * seed)))
--
-- foldl :: (b -> a -> b) -> b -> [a] -> b
-- foldr :: (a -> b -> b) -> b -> [a] -> b
--
--

ourFoldl :: (b -> a -> b) -> b -> [a] -> b
ourFoldl _ seed [] = seed
ourFoldl f !seed (x : xs) = ourFoldl f (f seed x) xs

ourFoldr :: (a -> b -> b) -> b -> [a] -> b
ourFoldr _ seed [] = seed
ourFoldr f seed (x : xs) = f x (ourFoldr f seed xs)

-- treeFoldr was the question on a interview


data Expr = Lit Int | Add Expr Expr | Mul Expr Expr deriving (Show)

data Frame
  = EvalRight (Int -> Int -> Int) Expr
  | ApplyOp (Int -> Int -> Int) Int

type Stack = [Frame]

evalExpr :: Expr -> Int
evalExpr expr = go expr []
  where
    go :: Expr -> Stack -> Int
    go (Lit n) [] = n
    go (Lit n) ((ApplyOp op val):stack) = go (Lit (op val n)) stack
    go (Lit n) ((EvalRight op e2):stack) = go e2 (ApplyOp op n : stack)
    go (Add e1 e2) stack = go e1 (EvalRight (+) e2 : stack)
    go (Mul e1 e2) stack = go e1 (EvalRight (*) e2 : stack)



data RoseTree a = RoseNode a [RoseTree a]

instance Show a => Show (RoseTree a) where
  show (RoseNode x list) = show x ++  " " ++ show list

instance Eq a => Eq (RoseTree a) where
  (RoseNode x xlist) == (RoseNode y ylist) = x == y &&  xlist == ylist

instance Functor RoseTree where
  fmap f (RoseNode x list) = RoseNode (f x) $ map (fmap f) list 

instance Foldable RoseTree where
  -- foldMap :: Monoid m => (a -> m) -> RoseTree a -> m
  foldMap f (RoseNode x list) = f x <> mconcat (fmap (foldMap f) list)


myMap :: (a -> b) -> [a] -> [b]
myMap f = foldl (\acc x -> acc ++ [f x]) []

foldlWithControl :: (b -> a -> Either b c) -> b -> [a] -> Either b c
foldlWithControl _ seed [] = Left seed
foldlWithControl f seed (x:xs) = case f seed x of
  Left seed' -> foldlWithControl f seed' xs
  Right cont -> Right cont


findFirstThat :: (a -> Bool) -> [a] -> Either () a
findFirstThat predicate = foldlWithControl (\_ x -> if predicate x then Right x else Left ()) ()



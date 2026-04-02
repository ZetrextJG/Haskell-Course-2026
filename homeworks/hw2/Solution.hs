{-# LANGUAGE BangPatterns #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

import Data.Function
import Data.Foldable (Foldable(toList))

data Sequence a = Empty | Single a | Append (Sequence a) (Sequence a) deriving Show

exampleSeq = Append (Single 1) (Append (Single 2) (Single 3))
exampleSeq2 = Append (Single 1) (Append Empty (Append Empty (Single 2)))

-- Task 1
instance Functor Sequence where
  fmap :: (a -> b) -> Sequence a -> Sequence b
  fmap f Empty = Empty
  fmap f (Single x) = Single (f x)
  fmap f (Append xs ys) = Append (fmap f xs) (fmap f ys)

-- Task 2
instance Foldable Sequence where
  foldMap :: Monoid m => (a -> m) -> Sequence a -> m
  foldMap f Empty = mempty
  foldMap f (Single x) = f x
  foldMap f (Append xs ys) = foldMap f xs <> foldMap f ys

-- Task 2
seqToList :: Sequence a -> [a]
seqToList = toList

seqLength :: Sequence a -> Int
seqLength = length

-- Task 3
instance Semigroup (Sequence a) where
  (<>) :: Sequence a -> Sequence a -> Sequence a
  xs <> ys = Append xs ys

instance Monoid (Sequence a) where
  mempty :: Sequence a
  mempty = Empty

-- Task 4
tailElem :: Eq a => a -> Sequence a -> Bool
tailElem t xs = go t xs []
  where
  go :: Eq a => a -> Sequence a -> [Sequence a] -> Bool
  go t Empty [] = False
  go t Empty (z:zs) = go t z zs -- Because Empty can somewhere in Append
  go t (Single y) [] = t == y
  go t (Single y) (z:zs) = (t == y) || go t z zs
  go t (Append xs ys) !zs = go t xs (ys:zs)

-- Task 5
-- I think that this is a nice solution
-- might not be optimal but we already are coding in haskell...
-- It pops from the stack only when the state machine encounters Empty
-- and uses Empty to indicate the need to check the stack
tailToList :: Sequence a -> [a]
tailToList xs = go xs [] []
  where
  go :: Sequence a -> [a] -> [Sequence a] -> [a]
  go Empty !zs [] = zs
  go Empty !zs (s:ss) = go s zs ss
  go (Single x) !zs ss = go Empty (zs ++ [x]) ss
  go (Append xs ys) !zs ss = go xs zs (ys:ss)

-- Task 5 (Again)
data Token = TNum Int | TAdd | TSub | TMul | TDiv

tailRPN :: [Token] -> Maybe Int
tailRPN ts = go Nothing ts []
  where
  go :: Maybe Token -> [Token] -> [Int] -> Maybe Int
  go Nothing [] [x] = Just x
  go Nothing [] _ = Nothing
  go Nothing (t:ts) stack = go (Just t) ts stack
  go (Just (TNum x)) ts stack = go Nothing ts (x:stack)
  go (Just TAdd) ts (x:y:zs) = go Nothing ts ((y+x):zs)
  go (Just TSub) ts (x:y:zs) = go Nothing ts ((y-x):zs)
  go (Just TMul) ts (x:y:zs) = go Nothing ts ((y*x):zs)
  go (Just TDiv) ts (x:y:zs)
    | x == 0 = Nothing 
    | otherwise = go Nothing ts ((y `div` x):zs)
  go _ _ _ = Nothing -- Any other case just goes to Nothing



-- Task 6 a
myReverseNaive :: [a] -> [a]
myReverseNaive = foldr (\x !xs -> xs ++ [x]) []

myReverse:: [a] -> [a]
myReverse = foldl (\(!xs) x -> x:xs) []
-- As we can see the foldr solutions requires us to append 
-- the elements to the accumulator at the end of the list and thus we
-- have to go thought the entire accumulator. And that is inefficient.
-- TLDR: Pushing at the end of the list is bad

-- Task 6 b
first (x, y) = x
myTakeWhileNaive :: (a -> Bool) -> [a] -> [a]
myTakeWhileNaive f arr = first (foldl go ([], True) arr)
  where
  go (!xs, False) x = (xs, False)
  go (!xs, True) x = let q = f x in if q then (xs ++ [x], True) else (xs, False)

myTakeWhile :: (a -> Bool) -> [a] -> [a]
myTakeWhile pred = foldr go [] 
  where
  go x acc = if pred x then x : acc else []

-- The foldl solutions has to go through the entire
-- input list and thus will not work on infinite lists.
-- Foldr solution discards the tail if the predicate is not true
-- and the recursive nature of the laziness in foldr makes it start evaluating
-- the equation from the left rather then the right making it possible
-- to handle infinite lists.


-- Task 6 c
decimal :: [Int] -> Int
decimal = foldl (\ acc x -> 10*acc + x) 0


-- Task 7
encode :: Eq a => [a] -> [(a, Int)]
encode = foldr go [] 
  where
  go :: Eq a => a -> [(a, Int)] -> [(a, Int)]
  go x [] = [(x, 1)]
  go x ((v, c):ys)
    | x == v = (v, c+1):ys
    | otherwise = (x, 1):(v, c):ys

decode :: [(a, Int)] -> [a]
decode = foldr go []
  where
  go :: (a, Int) -> [a] -> [a]
  go (v, c) out = replicate c v ++ out


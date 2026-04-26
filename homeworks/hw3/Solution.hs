{-# LANGUAGE BangPatterns #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

import qualified Data.Map as Map
import Data.Tuple (swap)
import Data.List (permutations)
import Control.Monad (guard)

-- Task 1
type Pos = (Int, Int)
data Dir = N | S | E | W deriving (Eq, Ord, Show)
type Maze = Map.Map Pos (Map.Map Dir Pos)

-- Example maze
-- (0,0) -- (1,0)
--   |        |
-- (0,1) -- (1, 1) -- (2, 1)
exampleMaze :: Maze
exampleMaze = Map.fromList [
  ((0, 0), Map.fromList [(E, (1, 0)), (S, (0, 1))]),
    ((1, 0), Map.fromList [(W, (0, 0)), (S, (1, 1))]),
    ((0, 1), Map.fromList [(N, (0, 0)), (E, (1, 1))]),
    ((1, 1), Map.fromList [(N, (1, 0)), (W, (0, 1)), (E, (2, 1))])
  ]

move :: Maze -> Pos -> Dir -> Maybe Pos
move maze pos dir = do
  neightors <- Map.lookup pos maze;
  Map.lookup dir neightors

followPath :: Maze -> Pos -> [Dir] -> Maybe Pos
followPath maze pos [] = Just pos
followPath maze pos (d:ds) = do
  newPos <- move maze pos d
  followPath maze newPos ds

safePath :: Maze -> Pos -> [Dir] -> Maybe [Pos]
safePath maze pos [] = Just [pos]
safePath maze pos (d:ds) = do
  newPos <- move maze pos d
  rest <- safePath maze newPos ds
  Just (pos:rest)


-- Task 2
type Key = Map.Map Char Char
exampleKey :: Key
exampleKey = Map.fromList [('a', 'b'), ('b', 'c'), ('c', 'd'), ('d', 'a')]

decrypt :: Key -> String -> Maybe String
decrypt key = traverse (`Map.lookup` key)

decryptWords :: Key -> [String] -> Maybe [String]
decryptWords key = traverse (decrypt key)


-- Task 3
type Guest = String
type Conflict = (Guest, Guest)

exampleGuests :: [Guest]
exampleGuests = ["Alice", "Bob", "Charlie"]
exampleGuests2 :: [Guest]
exampleGuests2 = ["Alice", "Bob", "Charlie", "David"]
exampleConflicts :: [Conflict]
exampleConflicts = [("Alice", "Bob")]

seatings :: [Guest] -> [Conflict] -> [[Guest]]
seatings guests conflicts = do
  let conflictMap = Map.fromList (conflicts ++ map swap conflicts);
  seating <- permutations guests
  let pairs = zip seating (tail seating ++ [head seating])
  guard (valid pairs conflictMap)
  return seating
  where 
    isPairInvalid (x, y) conflictMap = Map.member x conflictMap && Map.lookup x conflictMap == Just y
    valid pairs conflictMap = not (any (`isPairInvalid` conflictMap) pairs)


-- Task 4
data Result a = Failure String | Success a [String] deriving Show

instance Functor Result where
  fmap f (Failure msg) = Failure msg
  fmap f (Success x warnings) = Success (f x) warnings

instance Applicative Result where
  pure x = Success x []
  (Failure msg) <*> _ = Failure msg
  _ <*> (Failure msg) = Failure msg
  (Success f w1) <*> (Success g w2) = Success (f g) (w1 ++ w2)

instance Monad Result where
  return = pure
  (Failure msg) >>= _ = Failure msg
  (Success x w) >>= f = case f x of
    Failure msg -> Failure msg
    Success y w' -> Success y (w ++ w')

warn :: String -> Result ()
warn msg = Success () [msg]

failure :: String -> Result a
failure = Failure 

validateAge :: Int -> Result Int
validateAge age
  | age < 0 = failure "Age must be a non-negative integer"
  | age > 150 = warn "Age is unusually high" >> return age
  | otherwise = return age

validateAges :: [Int] -> Result [Int]
validateAges = mapM validateAge

-- Task 5

-- Writer implementation from Tutorials
newtype Writer m a = Writer {runWriter :: (a,m)} deriving (Show, Functor)

instance (Monoid m) => Applicative (Writer m) where
  pure x = Writer (x, mempty)  
  liftA2 f (Writer (x,logx)) (Writer (y,logy)) = Writer (f x y, logx <> logy)

instance (Monoid m) => Monad (Writer m) where
  Writer (x,logx) >>= f = let (y,logy) = runWriter (f x) in Writer (y,logx <> logy)  
 
tell :: m -> Writer m ()
tell message = Writer ((), message)

-- Main part of Task 5
data Expr = Lit Int | Add Expr Expr | Mul Expr Expr | Neg Expr deriving Show

exampleExpr :: Expr -- example expression: 0 + (1 * (2 + 3))
exampleExpr = Add (Lit 0) (Mul (Lit 1) (Add (Lit 2) (Lit 3)))

simplify :: Expr -> Writer [String] Expr
simplify expr = case expr of
  Lit n -> return (Lit n)  -- Monadic return
  Neg e -> do -- Negation simplifications
    se <- simplify e
    case se of
      Neg inner -> do
        tell ["Double negation: --e -> e"]
        return inner
      _ -> return (Neg se)
  Add e1 e2 -> do -- Addition simplifications
    se1 <- simplify e1
    se2 <- simplify e2
    case (se1, se2) of
      (Lit 0, _) -> do
        tell ["Add identifty: 0 + e -> e"]
        return se2
      (_, Lit 0) -> do
        tell ["Add identifty: e + 0 -> e"]
        return se1
      (Lit n1, Lit n2) -> do
        tell ["Add constant folding"]
        return (Lit (n1 + n2))
      _ -> return (Add se1 se2)
  Mul e1 e2 -> do -- Multiplication simplifications
    se1 <- simplify e1
    se2 <- simplify e2
    case (se1, se2) of
      (Lit 0, _) -> do
        tell ["Mult zero: 0 * e -> 0"]
        return (Lit 0)
      (_, Lit 0) -> do
        tell ["Mult zero: e * 0 -> 0"]
        return (Lit 0)
      (Lit 1, _) -> do
        tell ["Mult identity: 1 * e -> e"]
        return se2
      (_, Lit 1) -> do
        tell ["Mult identity: e * 1 -> e"]
        return se1
      (Lit n1, Lit n2) -> do
        tell ["Mult constant folding"]
        return (Lit (n1 * n2))
      _ -> return (Mul se1 se2)


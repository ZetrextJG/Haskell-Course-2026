import Data.Tuple (swap)

import Control.Monad (guard)

import Control.Monad.State (State, get, put, modify, execState, evalState, StateT)
import Data.Maybe (fromJust)
import qualified Data.Map as Map

-- TASK 1

data Instr = PUSH Int | POP | DUP | SWAP | ADD | MUL | NEG

execInstr :: Instr -> State [Int] ()
execInstr instr = do
  stack <- get
  case instr of 
    PUSH n -> put (n : stack)

    POP -> case stack of  
      (_:xs) -> put xs
      _ -> return ()

    DUP -> case stack of
      (x:xs) -> put (x:x:xs)
      _ -> return ()

    SWAP -> case stack of
      (x:y:xs) -> put (y:x:xs)
      _ -> return ()

    ADD -> case stack of
      (x:y:xs) -> put (x+y:xs)
      _ -> return ()

    MUL -> case stack of
      (x:y:xs) -> put (x*y:xs)
      _ -> return ()

    NEG -> case stack of
      (x:xs) -> put ((-x):xs)
      _ -> return ()

execProg :: [Instr] -> State [Int] ()
execProg [] = return ()
execProg (x:xs) = do
  execInstr x
  execProg xs

runProg :: [Instr] -> [Int]
runProg prog = execState (execProg prog) []

exampleProgram :: [Instr]
exampleProgram = [PUSH 2, PUSH 3, PUSH 5, POP, SWAP, NEG, SWAP, ADD]
-- Should be [1]


-- TASK 2

data Expr
  = Num Int
  | Var String
  | Add Expr Expr
  | Mul Expr Expr
  | Neg Expr
  | Assign String Expr   -- bind the value of the expression to the name, return that value
  | Seq  Expr Expr       -- evaluate the left, then the right; return the value of the right

eval :: Expr -> State (Map.Map String Int) Int
eval expr = do
  m <- get
  case expr of 
    Num num -> return num

    Var name -> do
      return $ fromJust (Map.lookup name m)

    Add expr1 expr2 -> do
      v1 <- eval expr1
      v2 <- eval expr2
      return $ v1 + v2

    Mul expr1 expr2 -> do
      v1 <- eval expr1
      v2 <- eval expr2
      return $ v1 * v2

    Neg expr1 -> do
      v1 <- eval expr1
      return $ -v1

    Assign name expr -> do
      v1 <- eval expr
      put $ Map.insert name v1 m
      return v1

    Seq expr1 expr2 -> do
      v1 <- eval expr1
      eval expr2

runEval :: Expr -> Int
runEval expr = evalState (eval expr) Map.empty

-- TASK 3 

-- Without cache
editDist :: String -> String -> Int
editDist str1 str2 = go (length str1) (length str2)
  where 
    go :: Int -> Int -> Int
    go 0 j = j
    go i 0 = i
    go i j =if str1!!(i-1) == str2!!(j-1)
      then go (i-1) (j-1) 
      else 1 + foldl min maxBound [go (i-1) j, go i (j-1), go (i-1) (j-1)]

-- With cache
editDistM :: String -> String -> Int -> Int -> State (Map.Map (Int, Int) Int) Int
editDistM str1 str2 i j = go i j
  where
    go :: Int -> Int -> State (Map.Map (Int, Int) Int) Int
    go 0 j = return j
    go i 0 = return i
    go i j = if str1!!(i-1) == str2!!(j-1)
        then go (i-1) (j-1)
        else do
          v1 <- cacheLookup (i-1) j
          v2 <- cacheLookup i (j-1)
          v3 <- cacheLookup (i-1) (j-1)
          return $ 1 + min (min v1 v2) v3
          where
            cacheLookup ii jj = do
              m <- get
              case Map.lookup (ii, jj) m of
                Just x -> return x
                Nothing -> do
                  v <- go ii jj
                  modify (Map.insert (ii, jj) v)
                  return v

editDistance str1 str2 = evalState (editDistM str1 str2 (length str1) (length str2)) Map.empty

-- TASK 3

data GameState = GameState {
  
};

type AdventureGame a = StateT GameState IO a





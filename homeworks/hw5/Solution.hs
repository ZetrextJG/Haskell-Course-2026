import Data.Tuple (swap)

import Control.Monad (guard)

import Control.Monad.State (State, get, put, modify, execState, evalState, StateT, MonadIO (liftIO), evalStateT)
import Data.Maybe (fromJust)
import qualified Data.Map as Map

import Routes (getRoutes)
import Events (tellEvent, resolveEvent)
import Data.IntMap (toAscList)
import Data.Char (isDigit, digitToInt)
import System.IO (hFlush, stdout)

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

-- 
-- I have decided to adapt the task a little bit
-- to make it more interesting.
--
-- The game is inspired by the path of Karl Bushby in which 
-- you are trying to go from Punta Arenas (Chile) to
-- Kingston upon Hull (England) BY FOOT.
--
-- Using `make_game.py` I have created Route.hs and Events.hs
-- which hold the game content: routes and events. 
-- The game content: events and most of the map are 
-- LLM generated to make it feasible (Also the make_game.py script).

-- This does not fit the task 1 to 1 but I argue
-- that the learning objectives are the same (or even extended).
--
-- The `make_game.py` also creates a `.kml` file
-- so that the player can load it into the Google My Maps
-- and follow the path with more visual effect. 
-- The part in haskell is text based.
--


data GameState = GameState {
   currentCity :: String,
   currentPath :: [String],
   points      :: Int,
   engery      :: Int
};

startGameState :: GameState
startGameState = GameState "Punta Arenas" []  10 20

type AdventureGame a = StateT GameState IO a

-- USER INPUT

getDiceRoll :: IO Int
getDiceRoll = do
  putStr "Input dice roll (1-6): "
  hFlush stdout
  input <- getLine
  case reads input of
    [(digit, "")]
      | digit >= 1 && digit <= 6 -> pure digit
    _ -> do
      putStrLn "Invalid input!"
      hFlush stdout
      getDiceRoll

displayGameState :: GameState -> IO ()
displayGameState gs = do
  putStrLn "GameState: "
  putStrLn $ "\tCurrent City: " ++ currentCity gs
  putStrLn $ "\tOn Path: " ++ show (currentPath gs)
  putStrLn $ "\tPoints: " ++ show (points gs) ++ " Energy: " ++ show (engery gs)
  hFlush stdout
  return ()

showRouteOptions :: [[String]] -> Int -> IO ()
showRouteOptions [] _ = pure ()
showRouteOptions (r:rs) i = do
  putStrLn $ "\t" ++ show i ++  ") -> " ++ show r
  showRouteOptions rs (i+1)

getPlayerNextRouteChoice :: String -> IO [String]
getPlayerNextRouteChoice ccity = do
    let choices = getRoutes ccity

    putStrLn $ "You are at the cross-roads in " ++ ccity ++ "."
    putStrLn "Your options are: "
    showRouteOptions choices 1

    let n = length choices
    putStrLn "Enter the number of your choice: "
    hFlush stdout
    input <- getLine
    case reads input of
      [(choiceIndex, "")]
        | choiceIndex >= 1 && choiceIndex <= n ->
            pure $ choices !! (choiceIndex - 1)
      _ -> do
        putStrLn "Invalid choice, try again."
        hFlush stdout
        getPlayerNextRouteChoice ccity


-- GAME LOGIC 

showDiff :: Int -> String
showDiff p
  | p >= 0  = "+" ++ show p 
  | p < 0  = show p

handleLocation :: AdventureGame Bool
handleLocation = do
  state <- get
  let city = currentCity state
  case tellEvent city of
    Just text -> do
      liftIO $ displayGameState state
      liftIO $ putStrLn "There is an event in this city!"
      liftIO $ putStrLn text
      liftIO $ hFlush stdout

      roll <- liftIO getDiceRoll
      liftIO $ putStrLn "\n"
      let (after_text, pts_diff, eng_diff) = resolveEvent city roll
      liftIO $ putStrLn after_text
      liftIO $ putStrLn $ "Points: " ++ showDiff pts_diff ++ "  Energy: " ++ showDiff eng_diff 

      modify (\s ->
        s { points = points s + pts_diff
          , engery = engery s + eng_diff
          })
      return $ city == "Kingston upon Hull"

    Nothing -> do
      liftIO $ putStrLn "No events in this city."
      return False


playTurn :: AdventureGame Bool
playTurn = do
  liftIO $ putStrLn "\n=====================================\n"
  done <- handleLocation -- Handle in city events 
  if done then -- If True we are done
    return True
  else do
    state <- get
    case currentPath state of 
      (x:xs) -> do -- If on path go to next city
        liftIO $ putStrLn $ "Your next destimation: " ++ x
        modify (\s -> s { 
          currentCity = x,
          currentPath = xs
        })
        return False
      [] -> do
        let coreCity = currentCity state
        (nextCity:restPath) <- liftIO $ getPlayerNextRouteChoice coreCity
        liftIO $ putStrLn $ "Your next destimation: " ++ nextCity
        modify (\s -> s { 
          currentCity = nextCity,
          currentPath = restPath
        })
        return False

playGame = do
  done <- playTurn
  state <- get
  let pts = points state
  let ngr = engery state

  if (ngr <= 0) || done
    then do
      liftIO $ putStrLn "GAME OVER!!!"
      liftIO $ displayGameState state
      liftIO $ hFlush stdout
    else playGame

main :: IO ()
main = do
  putStrLn "=== THE CORE EXPEDITION ==="
  putStrLn "You begin your journey in Punta Arenas."
  putStrLn "Travel north, survive city events, and reach Kingston upon Hull."
  putStrLn "Good luck."
  putStrLn ""
  evalStateT playGame startGameState

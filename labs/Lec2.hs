{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Lec2 where

newtype Point = Point (Double, Double)

data Shape
  = Rectangle Point Point
  | Circle Point Double
  | Square Double
  | ShapePoint Point

volume :: Shape -> Double
volume (ShapePoint _) = 0
volume (Rectangle (Point (x1, y1)) (Point (x2, y2))) = abs (x2 - x1) * abs (y2 - y1)
volume (Circle (Point (_, _)) r) = pi * r ^ 2
volume (Square r) = r ^ 2

sh = ShapePoint (Point (1, 2))

-- Type classes (aka trait in Rust, interface in Java, protocol in Swift)
--
-- Semigroup  (S, <>)
--    - Associative binary operation <>: S -> S -> S
--      such that (a <> b) <> c == a <> (b <> c) for all a, b, c in S
-- Monoid     (S, <>, unit (mempty))
--    - A semigroup (S, <>) with an identity element unit (mempty) such that:
--    -  - unit <> a == a <> unit == a for all a in S
--    For example: Natural number with addition and 0, or Natural number with multiplication and 1,
--    of a list with concatenation and empty list, etc.
-- Functor  (F, fmap)
--    - If your type is parametric ([a], Maybe a, Either a b)
--    than it can be a functor if you can define fmap :: (a -> b) -> F a -> F b
-- Show a => a -> String
-- Eq a => a -> a -> Bool
--
-- Syntax:
-- instance (Show a) => Show (Shape a) where
--    show (ShapePoint p) = "ShapePoint " ++ show p
--
-- instance Functor (Shape) where
--   fmap f (ShapePoint p) = ShapePoint (fmap f p)
--
--  Syntactic sugar
-- `fmap length someList` <=> `length <$> someList`
--
-- WE CAN OVERWRITE LANGUAGE SYNTAX LIKE THIS BY OURSELF
--
--

data GenericList a = E | Con a (GenericList a) deriving (Show, Eq)

instance Functor GenericList where
  fmap _ E = E
  fmap f (Con x xs) = Con (f x) (fmap f xs)

main :: IO ()
main = do
  print $ "The volume of the shape is: " ++ show (volume sh)

module Sec1 where

-- https://liquid.kosmikus.org/01-intro.html

-- * Introduction

i1 :: Int
i1 = 3 -- doesn't compile if you replace with a non int

-- ** refinement types

-- | set comprehension notation refines the haskell type sig
i2 :: Int
{-@ i2 :: { i : Int | i >= 3 } @-}
i2 = 4

i3 :: Int
{-@ i3 :: { i : Int | i >= 3 } @-}
i3 = 2 -- this gets flagged by LH
{-@ ignore i3 @-}

-- ** type synonyms

{-@ type GE3  = { i : Int | i >= 3 } @-}
{-@ type GE N = { i : Int | i >= N } @-}

-- type var must be capital
-- lowercase is used for haskell things, uppercase for LH things

i4 :: Int
{-@ i4 :: GE3 @-}
i4 = 4

i5 :: Int
{-@ i5 :: GE 3 @-}
i5 = 3

-- LH prelude defines Nat
--
x0 :: Int
x0 = 2
{-@ x0 :: Nat @-}

x1 :: Int
x1 = -2
{-@ x1 :: Nat @-}
{-@ ignore x1 @-}

-- ** refinement types must refine

i6 :: Int
{-@ i6 :: { i : Int | i == 6 } @-}
i6 = 6

-- i6x :: Integer
-- i6x = 6
-- {-@ ignore i6x @-}
-- {-@ i6x :: { i : Int | i == 6 } @-}

-- ** one expression can have many types

-- | "all of these work, but we have to choose one"
{-@ i7 :: { i : Int | i == 6 } @-}
-- {-@ i7 :: { i : Int | i >= 0 } @-}
-- {-@ i7 :: { i : Int | i <= 10 } @-}
-- {-@ i7 :: { i : Int | i >= 0 && i <= 10 } @-}
-- {-@ i7 :: Int @-}
i7 :: Int
i7 = 6

-- ** refinement types and functions

i8 :: Int
{-@ i8 :: { i : Int | i == 3 } @-}
i8 = 1 + 2

plus :: Int -> Int -> Int
{-@ plus :: a:Int -> b:Int -> { i : Int | i == a + b } @-}
plus = (+)
-- this is a *dependent type*

i9 :: Int
{-@ i9 :: { i : Int | i == 3 } @-}
i9 = 2 `plus` 1

-- ** preconditions and postconditions

pre :: Int -> Int -> Int
{-@ pre :: i:Nat -> { j:Int | j >= 2 * i } -> Int @-}
pre i j = j - i - i

post :: Int -> Int
{-@ post :: i:Int -> { j:Int | j >= 3*i } @-}
post i = 3 * i

combine :: Int -> Int
{-@ combine :: Nat -> Int @-}
combine i = pre i (post i)

-- ** integer arithmetic

double :: Int -> Int
{-@ double :: x:Int -> { i:Int | i == 2*x } @-}
double x = x + x

dist :: Int -> Int -> Int -> Int
{-@ dist :: x:Int -> y:Int -> z:Int -> {i:Int | i == x*z + y*z } @-}
dist x y z = (x + y) * z

-- ** exercises

-- | 1 give refined type to abs
abs :: Int -> Int
abs x
    | x < 0 = - x
    | otherwise = x
{-@ abs :: x:Int -> { y:Int | y >= 0 } @-}

-- | 2 fix the signature so that ... restricted to suitable nats
-- {-@ sub :: Nat -> Nat -> Nat @-}
sub :: Int -> Int -> Int
sub i j = i - j
{-@ sub :: i:Nat -> {j:Nat | i>=j} -> Nat @-}

-- | 3 add a sig .. the sum of the two comps of result is equal to the arg
halve :: Int -> (Int, Int)
halve i = (j, j + r)
  where
    j = i `div` 2
    r = i `mod` 2
{-@ halve :: i:Int -> {t:(Int,Int) | i == fst t + snd t} @-}

halve' :: Int -> (Int, Int)
halve' i = (j, j + r)
  where
    j = i `quot` 2
    r = i `rem` 2
-- {-@ halve' :: i:Int -> {t:(Int,Int) | i == fst t + snd t} @-}

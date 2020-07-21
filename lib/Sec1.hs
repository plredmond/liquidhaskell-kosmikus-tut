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
-- I6x = 6
-- {-@ ignore i6x @-}
-- {-@ i6x :: { i : Int | i == 6 } @-}

-- ** one expression can have many types (not anymore?)

-- {-@ i7 :: { i : Int | i == 6 } @-}
-- {-@ i7 :: { i : Int | i >= 0 } @-}
-- {-@ i7 :: { i : Int | i <= 10 } @-}
-- {-@ i7 :: { i : Int | i >= 0 && i <= 10 } @-}
-- {-@ i7 :: Int @-}
-- i7 :: Int
-- i7 = 6

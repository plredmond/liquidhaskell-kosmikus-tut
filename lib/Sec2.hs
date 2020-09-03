{-# LANGUAGE QuasiQuotes #-}
module Sec2 where

import LiquidHaskell
import Prelude hiding (length, map, repeat, take, drop)

-- https://liquid.kosmikus.org/02-lists.html

-- * Lists

-- ** own list type (for learning)

data List a
    = a ::: List a
    | Nil
infixr 5 :::

list1 :: List Int
list1 = 1 ::: 2 ::: 3 ::: Nil

list2 :: List Int
{-@ list2 :: List Nat @-}
list2 = 1 ::: 2 ::: 3 ::: Nil

list3 :: List Int
{-@ list3 :: List Nat @-}
list3 = -1 ::: 2 ::: 3 ::: Nil
[lq| ignore list3 |]

-- ** termination

length :: List a -> Int
{-@ length :: List a -> Nat @-}
length Nil = 0
length (_ ::: xs) = 1 + length xs

-- ** measures

-- ?? no need to measure length ??

-- ** mapping

map _ Nil = Nil
map f (x ::: xs) = f x ::: map f xs
-- can you add a type signature that captures that map doesn't change the
-- length?
[lq| map :: (a -> b) -> xs:List a -> {ys:List b | length xs == length ys} |]
--XX Illegal type specification for `Sec2.map`
--XX Unbound symbol Sec2.length --- perhaps you meant: Sec2.Nil, Sec2.::: ?

-- need to measure length to use it here..  "a measure is a single arg function
-- with one case per constructor; can be lifted ... and used in refinements"
[lq| measure length |]

-- ** interleaving two lists

interleave Nil ys = ys
interleave xs Nil = xs
interleave (x:::xs) ys = x ::: interleave ys xs
--XX Termination Error

-- need to define own termination measure
--[lq| interleave :: xs:List a -> ys:List a -> List a / [length xs + length ys] |]

-- can you further refine the type signature such that we track the length of
-- the resulting list?
[lq| interleave
    :: xs:List a
    -> ys:List a
    -> {zs:List a | length zs == length xs + length ys}
    / [length xs + length ys]
|]

-- ** disabling termination checking

repeat x = x ::: repeat x
--XX Termination Error
[lq| lazy repeat |] -- disable termination checking
[lq| repeat :: a -> List a |]

-- ** totality

[lq| head :: {xs:List a | length xs > 0} -> a |]
head (x:::_) = x
head _ = error "head: empty list" -- avoid an incomplete-pattern-cases warning

-- ** impossible cases

[lq| impossible :: {s:String | False} -> a |]
impossible msg = error msg
-- since the precondition cannot be satisfied, LH verifies that it cannot be
-- reached

tail (_:::xs) = xs
tail Nil = impossible "tail: empty list"
[lq| tail :: {xs:List a | length xs > 0} -> List a |]

-- * exercises
[lq| type Nat = {n:Int | 0 <= n} |]

-- why does this not typecheck? can you fix?
--[lq| take :: i:Nat -> List a -> {ys:List a | length ys == i} |]
take _ Nil = Nil
take 0 _ = Nil
take i (x:::xs) = x ::: take (i-1) xs
--[lq| take :: i:Nat -> (xs:List a} -> {ys:List a | length ys == i} |]
[lq| take
    :: i:Nat
    -> xs:List a
    -> {ys:List a |
        i <= length xs && i == length ys || length xs == length ys
    }
|]

-- refinement type for drop
drop _ Nil = Nil
drop 0 xs = xs
drop i (_:::xs) = drop (i-1) xs
[lq| drop
    :: i:Nat
    -> xs:List a
    -> {ys:List a |
        i <= length xs && length xs - i == length ys || 0 == length ys
    }
|]

-- refinement type for sublist
sublist offset size = take size . drop offset
[lq| sublist
    :: offset:Nat
    -> size:Nat
    -> input:List a
    -> {output:List a |
        offset + size <= length input && size == length output || TODO
    }
|]

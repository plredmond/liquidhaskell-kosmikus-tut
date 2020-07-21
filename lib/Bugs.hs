module Bugs where

-- * errors which don't report properly

{-
-- | A typo in a name results in a "does not refine" error.
--
-- GHCID cannot see the error.
--
-- Additionally, this error cannot be ignored
exa :: Bool
{-@ exa :: bool @-}
{-@ ignore exa @-}
exa = True
-}

{-
-- | A type mismatch results in a "does not refine" error
--
-- GHCID can see it!
--
-- Additionally, this error cannot be ignored
exb :: Integer
{-@ exb :: Int @-}
{-@ ignore exb @-}
exb = 3
-}

{-
-- | A duplicate specification results in a "multiple specifications for" error
--
-- GHCID cannot see the error.
--
-- Additionally, this error cannot be ignored
exc :: Int
{-@ exc :: { x:Int | x >   3 } @-}
{-@ exc :: { x:Int | x < 100 } @-}
{-@ ignore exc @-}
exc = 5
-}

-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Haskell Variant
-- Author: Gavin Walters
-- Created: 2026-03-06
--
-- Description:
-- Linear Sequential Runtime System
--
-- Workflow:
-- Data -> Constraints -> Cells -> Threads -> Engine
-------------------------------------------------------------------------------

module Main where

import RCA.Engine (giveDefault, tryRunEngine)

-------------------------------------------------------------------------------
-- Runtime Engine
-------------------------------------------------------------------------------

main :: IO ()
main = do
  let engine = giveDefault
  tryRunEngine engine

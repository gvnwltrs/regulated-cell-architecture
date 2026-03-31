-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Haskell Variant
-- Cell
--
-- Each cell can access the system context/data but cannot modify it.
-- Only the engine has authority to modify state.
-- Each cell HAS-A task.
-------------------------------------------------------------------------------

module RCA.Cell where

import RCA.Data (DataPlane)

-- Status: MUTABLE
numCells :: Int
numCells = 2

-------------------------------------------------------------------------------
-- (1) Cell Data
-------------------------------------------------------------------------------

-- Status: MUTABLE
data CellData
  = CellNone
  | CellByte Int
  -- Add cell data types here
  deriving (Show)

-------------------------------------------------------------------------------
-- (2) Tasks
-------------------------------------------------------------------------------

-- Status: MUTABLE
data Task
  = TaskDefault
  | TaskDoubleValue
  -- Add tasks here
  deriving (Show)

-- Status: MUTABLE
taskAccess :: Task -> DataPlane -> CellData -> CellData
taskAccess TaskDefault _ctx _handoff =
  CellByte 0x2A  -- 42

taskAccess TaskDoubleValue _ctx handoff =
  case handoff of
    CellByte x -> CellByte (x + x)  -- 84
    _          -> handoff

-- Add task procedures here

-------------------------------------------------------------------------------
-- (3) Cell
-------------------------------------------------------------------------------

-- Status: FREEZE
data Cell = Cell
  { cellId   :: Int
  , cellTask :: Task
  } deriving (Show)

cellExecute :: Cell -> DataPlane -> CellData -> CellData
cellExecute cell ctx handoff = taskAccess (cellTask cell) ctx handoff

cellDefaults :: [Cell]
cellDefaults = [ Cell { cellId = i, cellTask = TaskDefault } | i <- [0 .. numCells - 1] ]

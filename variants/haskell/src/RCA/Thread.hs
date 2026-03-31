-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Haskell Variant
-- Thread
-------------------------------------------------------------------------------

module RCA.Thread where

import RCA.Data
import RCA.Cell

-------------------------------------------------------------------------------
-- (1) Threads
-------------------------------------------------------------------------------

-- Status: MUTABLE
numThreads :: Int
numThreads = 1

-- Status: MUTABLE
executionThreshold :: Double
executionThreshold = 1.0  -- Units in ms

-- Status: MUTABLE
data Effect = Effect
  { efxActivity :: ActivityInfo
  , efxHandoff  :: CellData
  , efxFinished :: Bool
  } deriving (Show)

-- Status: MUTABLE
data ProgramThread = ProgramThread
  { ptCounter :: Int
  , ptTasks   :: [Cell]
  , ptHandoff :: CellData
  } deriving (Show)

taskName :: Task -> String
taskName TaskDefault     = "Default"
taskName TaskDoubleValue = "DoubleValue"

buildTasks :: Maybe Int -> Maybe [Cell] -> Maybe CellData -> ProgramThread
buildTasks mctr mtsks mho = ProgramThread
  { ptCounter = maybe 0 id mctr
  , ptTasks   = maybe cellDefaults id mtsks
  , ptHandoff = maybe CellNone id mho
  }

isFinished :: ProgramThread -> Bool
isFinished pt = ptCounter pt >= length (ptTasks pt)

step :: ProgramThread -> DataPlane -> (ProgramThread, Effect)
step pt ctx =
  let currentCell = ptTasks pt !! ptCounter pt
      activity    = ActivityInfo { actDescription = taskName (cellTask currentCell) }
      -- Handoff transfer: take current, pass to cell, store result back
      newHandoff  = cellExecute currentCell ctx (ptHandoff pt)
      pt'         = pt { ptCounter = ptCounter pt + 1
                       , ptHandoff = newHandoff
                       }
      finished    = isFinished pt'
      effect      = Effect
                       { efxActivity = activity
                       , efxHandoff  = newHandoff
                       , efxFinished = finished
                       }
  in (pt', effect)

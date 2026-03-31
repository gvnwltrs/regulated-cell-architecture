-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Haskell Variant
-- Control Plane
-------------------------------------------------------------------------------

module RCA.Control where

-------------------------------------------------------------------------------
-- (1) States
-------------------------------------------------------------------------------

-- Status: FREEZE
data State = Init | Idle | Running | Halt | Failure | Shutdown
  deriving (Show, Eq)

-------------------------------------------------------------------------------
-- (2) Modes
-------------------------------------------------------------------------------

-- Status: MUTABLE
data Mode = ModeNone | Debug
  deriving (Show, Eq)

-------------------------------------------------------------------------------
-- (3) Events
-------------------------------------------------------------------------------

-- Status: MUTABLE
data Event = EventNone
  deriving (Show, Eq)

-------------------------------------------------------------------------------
-- Control Plane
-------------------------------------------------------------------------------

-- Status: FREEZE
data ControlPlane = ControlPlane
  { cpState :: State
  , cpMode  :: Mode
  , cpEvent :: Event
  } deriving (Show)

defaultControlPlane :: ControlPlane
defaultControlPlane = ControlPlane
  { cpState = Init
  , cpMode  = Debug
  , cpEvent = EventNone
  }

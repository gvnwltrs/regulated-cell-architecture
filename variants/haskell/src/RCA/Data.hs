-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Haskell Variant
-- Data Plane
--
-- Establish data endpoints.
-- Establish & confirm complete data.
-------------------------------------------------------------------------------

module RCA.Data where

-------------------------------------------------------------------------------
-- Apex data models
-------------------------------------------------------------------------------

-- Status: MUTABLE
data ConfigData = ConfigNone
  deriving (Show)

-- Status: MUTABLE
data ReadData = ReadNone
  deriving (Show)

-- Status: MUTABLE
data WriteData = WriteNone
  deriving (Show)

-- Status: MUTABLE
data PerfData = PerfNone
  deriving (Show)

-- Status: MUTABLE
data LogData
  = LogNone
  | LogSession { logEntry :: String, logDate :: String }
  deriving (Show)

-- Status: FREEZE
data CellInfo = CellInfo
  { cellCount :: Int
  } deriving (Show)

-- Status: FREEZE
data ActivityInfo = ActivityInfo
  { actDescription :: String
  } deriving (Show)

-- Status: FREEZE
data DisplayInfo = DisplayInfo
  { dispTitle  :: String
  , dispBody   :: String
  , dispStatus :: String
  } deriving (Show)

-- Status: FREEZE
data SystemData = SystemData
  { sysDescription :: String
  } deriving (Show)

-------------------------------------------------------------------------------
-- Data Plane
-------------------------------------------------------------------------------

-- Status: FREEZE
data DataPlane = DataPlane
  { dpConfig   :: ConfigData      -- Init state: initialization & configuration
  , dpReadIO   :: ReadData        -- Running state: import data
  , dpWriteIO  :: WriteData       -- Running state: export data
  , dpPerf     :: PerfData        -- Running state: system information
  , dpLogs     :: LogData         -- Running/Failure/Shutdown: event logs
  , dpCells    :: CellInfo        -- Running state: cell metadata
  , dpActivity :: ActivityInfo    -- Running state: current task details
  , dpDisplay  :: DisplayInfo     -- Running state: terminal/display output
  } deriving (Show)

-------------------------------------------------------------------------------
-- Defaults
-------------------------------------------------------------------------------

defaultActivityInfo :: ActivityInfo
defaultActivityInfo = ActivityInfo { actDescription = "" }

defaultDisplayInfo :: DisplayInfo
defaultDisplayInfo = DisplayInfo { dispTitle = "", dispBody = "", dispStatus = "" }

defaultSystemData :: SystemData
defaultSystemData = SystemData { sysDescription = "" }

defaultDataPlane :: Int -> DataPlane
defaultDataPlane n = DataPlane
  { dpConfig   = ConfigNone
  , dpReadIO   = ReadNone
  , dpWriteIO  = WriteNone
  , dpPerf     = PerfNone
  , dpLogs     = LogNone
  , dpCells    = CellInfo { cellCount = n }
  , dpActivity = defaultActivityInfo
  , dpDisplay  = defaultDisplayInfo
  }

-------------------------------------------------------------------------------
-- Add custom data models here
-------------------------------------------------------------------------------

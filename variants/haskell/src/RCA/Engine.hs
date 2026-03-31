-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Haskell Variant
-- Engine
--
-- Micro-kernel space (Loop Engine privilege only):
-- Apply returned outputs to ctx.
-------------------------------------------------------------------------------

module RCA.Engine where

import RCA.Data
import RCA.Control
import RCA.Cell
import RCA.Thread

-------------------------------------------------------------------------------
-- Status printing helpers
-------------------------------------------------------------------------------

stateName :: State -> String
stateName Init     = "Init"
stateName Idle     = "Idle"
stateName Running  = "Running"
stateName Halt     = "Halt"
stateName Failure  = "Failure"
stateName Shutdown = "Shutdown"

modeName :: Mode -> String
modeName ModeNone = "None"
modeName Debug    = "Debug"

printControl :: ControlPlane -> IO ()
printControl ctl = do
  putStrLn "  Control:"
  putStrLn $ "    state: " ++ stateName (cpState ctl)
  putStrLn $ "    mode:  " ++ modeName (cpMode ctl)

printDataPlane :: DataPlane -> IO ()
printDataPlane dp = do
  putStrLn "  Data:"
  putStrLn $ "    cells.count: " ++ show (cellCount (dpCells dp))
  putStrLn $ "    activity:    \"" ++ actDescription (dpActivity dp) ++ "\""

printCellData :: CellData -> IO ()
printCellData cd = do
  putStrLn "  Effect:"
  case cd of
    CellNone   -> putStrLn "    None"
    CellByte v -> putStrLn $ "    Byte(" ++ show v ++ ")"

-------------------------------------------------------------------------------
-- (1) Engine
-------------------------------------------------------------------------------

-- Status: FREEZE
data Engine = Engine
  { engCtx :: DataPlane
  , engCtl :: ControlPlane
  , engSys :: SystemData
  } deriving (Show)

giveDefault :: Engine
giveDefault = Engine
  { engCtx = defaultDataPlane numCells
  , engCtl = defaultControlPlane
  , engSys = defaultSystemData
  }

printInitStatus :: Engine -> IO ()
printInitStatus e = do
  putStrLn ""
  putStrLn ">>>"
  printControl (engCtl e)
  putStrLn ""
  printDataPlane (engCtx e)
  putStrLn ""

printRunningStatus :: Engine -> CellData -> IO ()
printRunningStatus e efx = do
  putStrLn ""
  putStrLn ">>>"
  printControl (engCtl e)
  putStrLn ""
  printCellData efx
  putStrLn ""
  printDataPlane (engCtx e)
  putStrLn "<<<"

printShutdownStatus :: Engine -> IO ()
printShutdownStatus e = do
  putStrLn ""
  putStrLn ">>>"
  printControl (engCtl e)
  putStrLn ""
  printDataPlane (engCtx e)
  putStrLn ""

-------------------------------------------------------------------------------
-- Engine run
-------------------------------------------------------------------------------

tryRunEngine :: Engine -> IO ()
tryRunEngine engine = do
  printInitStatus engine

  let currentThread = buildTasks
        Nothing
        (Just [ Cell { cellId = 0, cellTask = TaskDefault }
              , Cell { cellId = 1, cellTask = TaskDoubleValue }
              ])
        Nothing

  let e1 = engine { engCtl = (engCtl engine) { cpState = Halt } }
  printInitStatus e1

  let e2 = e1 { engCtl = (engCtl e1) { cpState = Idle } }
  printInitStatus e2

  let e3 = e2 { engCtl = (engCtl e2) { cpState = Running } }
  printInitStatus e3

  engineLoop e3 currentThread

engineLoop :: Engine -> ProgramThread -> IO ()
engineLoop engine thread =
  case cpState (engCtl engine) of
    Running ->
      let (thread', effect) = step thread (engCtx engine)
          engine' = engine { engCtx = (engCtx engine)
                               { dpActivity = efxActivity effect } }
      in do
        if cpMode (engCtl engine') == Debug
          then printRunningStatus engine' (efxHandoff effect)
          else return ()

        if efxFinished effect
          then do
            let engineFinal = engine'
                  { engCtl = (engCtl engine') { cpState = Shutdown }
                  , engCtx = (engCtx engine') { dpActivity = defaultActivityInfo }
                  }
            printShutdownStatus engineFinal
          else engineLoop engine' thread'

    _ -> do
      let engineFinal = engine
            { engCtl = (engCtl engine) { cpState = Shutdown } }
      printShutdownStatus engineFinal

-------------------------------------------------------------------------------
-- (2) Add custom engine functions here
-------------------------------------------------------------------------------

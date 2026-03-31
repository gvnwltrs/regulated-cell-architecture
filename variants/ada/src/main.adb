-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Ada Variant
-- Author: Gavin Walters
-- Created: 2026-03-06
--
-- Description:
-- Linear Sequential Runtime System
--
-- Workflow:
-- Data -> Constraints -> Cells -> Threads -> Engine
-------------------------------------------------------------------------------

with RCA.Engine; use RCA.Engine;

-------------------------------------------------------------------------------
-- Runtime Engine
-------------------------------------------------------------------------------

procedure Main is
   E : Engine_Type := Give_Default;
begin
   Try_Run_Engine (E);
end Main;

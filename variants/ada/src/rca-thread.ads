-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Ada Variant
-- Thread
-------------------------------------------------------------------------------

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with RCA.Data;    use RCA.Data;
with RCA.Cell;    use RCA.Cell;

package RCA.Thread is

   ---------------------------------------------------------------------------
   -- (1) Threads
   ---------------------------------------------------------------------------

   -- Status: MUTABLE
   Num_Threads : constant Natural := 1;

   -- Status: MUTABLE
   Execution_Threshold : constant Float := 1.0;  -- Units in ms

   -- Status: MUTABLE
   type Effect is record
      Activity : Activity_Info;
      Handoff  : Cell_Data;
      Finished : Boolean := False;
   end record;

   -- Status: MUTABLE
   type Program_Thread is record
      Counter : Natural    := 0;
      Tasks   : Cell_Array := Cell_Defaults;
      Handoff : Cell_Data  := (Tag => Cell_None);
   end record;

   function Build_Tasks
     (Ctr  : Natural    := 0;
      Tsks : Cell_Array := Cell_Defaults;
      Ho   : Cell_Data  := (Tag => Cell_None)) return Program_Thread;

   procedure Step
     (PT     : in out Program_Thread;
      Ctx    : in Data_Plane;
      Result : out Effect);

   function Is_Finished (PT : Program_Thread) return Boolean;

end RCA.Thread;

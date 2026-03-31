-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Ada Variant
-- Engine
--
-- Micro-kernel space (Loop Engine privilege only):
-- Apply returned outputs to ctx.
-------------------------------------------------------------------------------

with RCA.Data;    use RCA.Data;
with RCA.Control; use RCA.Control;
with RCA.Cell;    use RCA.Cell;
with RCA.Thread;  use RCA.Thread;

package RCA.Engine is

   ---------------------------------------------------------------------------
   -- (1) Engine
   ---------------------------------------------------------------------------

   -- Status: FREEZE
   type Engine_Type is record
      Ctx : Data_Plane;
      Ctl : Control_Plane;
      Sys : System_Data;
   end record;

   function Give_Default return Engine_Type;

   procedure Print_Init_Status (E : in Engine_Type);
   procedure Print_Running_Status (E : in Engine_Type; Efx : in Cell_Data);
   procedure Print_Shutdown_Status (E : in Engine_Type);

   procedure Try_Run_Engine (E : in out Engine_Type);

   ---------------------------------------------------------------------------
   -- (2) Add custom engine subprograms here
   ---------------------------------------------------------------------------

end RCA.Engine;

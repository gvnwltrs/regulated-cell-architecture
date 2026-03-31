-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Ada Variant
-- Cell
--
-- Each cell can access the system context/data but cannot modify it.
-- Only the engine has authority to modify state.
-- Each cell HAS-A task.
-------------------------------------------------------------------------------

with RCA.Data; use RCA.Data;

package RCA.Cell is

   -- Status: MUTABLE
   Num_Cells : constant Natural := 2;

   ---------------------------------------------------------------------------
   -- (1) Cell Data
   ---------------------------------------------------------------------------

   -- Status: MUTABLE
   type Cell_Data_Tag is (Cell_None, Cell_Byte);
   -- Add cell data types here

   type Cell_Data (Tag : Cell_Data_Tag := Cell_None) is record
      case Tag is
         when Cell_None => null;
         when Cell_Byte => Value : Natural := 0;
      end case;
   end record;

   ---------------------------------------------------------------------------
   -- (2) Tasks
   ---------------------------------------------------------------------------

   -- Status: MUTABLE
   type Task_Kind is (Task_Default, Task_Double_Value);
   -- Add tasks here

   function Task_Access
     (The_Task : Task_Kind;
      Ctx      : in Data_Plane;
      Handoff  : Cell_Data) return Cell_Data;

   ---------------------------------------------------------------------------
   -- (3) Cell
   ---------------------------------------------------------------------------

   -- Status: FREEZE
   type Cell_Type is record
      Id       : Natural   := 0;
      The_Task : Task_Kind := Task_Default;
   end record;

   type Cell_Array is array (0 .. Num_Cells - 1) of Cell_Type;

   function Execute
     (C       : in out Cell_Type;
      Ctx     : in Data_Plane;
      Handoff : Cell_Data) return Cell_Data;

   function Cell_Defaults return Cell_Array;

end RCA.Cell;

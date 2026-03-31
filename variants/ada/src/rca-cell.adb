-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Ada Variant
-- Cell Implementation
-------------------------------------------------------------------------------

package body RCA.Cell is

   function Cell_Defaults return Cell_Array is
      Result : Cell_Array;
   begin
      for I in Result'Range loop
         Result (I) := (Id => I, The_Task => Task_Default);
      end loop;
      return Result;
   end Cell_Defaults;

   function Execute
     (C       : in out Cell_Type;
      Ctx     : in Data_Plane;
      Handoff : Cell_Data) return Cell_Data
   is
   begin
      return Task_Access (C.The_Task, Ctx, Handoff);
   end Execute;

   ---------------------------------------------------------------------------
   -- Task Procedures
   ---------------------------------------------------------------------------

   -- Status: MUTABLE
   function Task_Access
     (The_Task : Task_Kind;
      Ctx      : in Data_Plane;
      Handoff  : Cell_Data) return Cell_Data
   is
      pragma Unreferenced (Ctx);
   begin
      case The_Task is

         when Task_Default =>
            return (Tag => Cell_Byte, Value => 16#2A#);  -- 42

         when Task_Double_Value =>
            if Handoff.Tag = Cell_Byte then
               return (Tag => Cell_Byte, Value => Handoff.Value + Handoff.Value);  -- 84
            else
               return Handoff;
            end if;

         -- Add task procedures here

      end case;
   end Task_Access;

end RCA.Cell;

-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Ada Variant
-- Thread Implementation
-------------------------------------------------------------------------------

package body RCA.Thread is

   function Task_Name (T : Task_Kind) return String is
   begin
      case T is
         when Task_Default      => return "Default";
         when Task_Double_Value => return "DoubleValue";
      end case;
   end Task_Name;

   function Build_Tasks
     (Ctr  : Natural    := 0;
      Tsks : Cell_Array := Cell_Defaults;
      Ho   : Cell_Data  := (Tag => Cell_None)) return Program_Thread
   is
   begin
      return (Counter => Ctr,
              Tasks   => Tsks,
              Handoff => Ho);
   end Build_Tasks;

   function Is_Finished (PT : Program_Thread) return Boolean is
   begin
      return PT.Counter >= Num_Cells;
   end Is_Finished;

   procedure Step
     (PT     : in out Program_Thread;
      Ctx    : in Data_Plane;
      Result : out Effect)
   is
      Handoff_Transfer : Cell_Data;
   begin
      Result.Activity := (Description =>
         To_Unbounded_String (Task_Name (PT.Tasks (PT.Counter).The_Task)));

      -- Handoff transfer: take current, pass to cell, store result back
      Handoff_Transfer := PT.Handoff;
      PT.Handoff := (Tag => Cell_None);

      PT.Handoff := Execute (PT.Tasks (PT.Counter), Ctx, Handoff_Transfer);
      PT.Counter := PT.Counter + 1;

      Result.Handoff  := PT.Handoff;
      Result.Finished := Is_Finished (PT);
   end Step;

end RCA.Thread;

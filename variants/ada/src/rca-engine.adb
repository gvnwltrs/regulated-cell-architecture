-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Ada Variant
-- Engine Implementation
-------------------------------------------------------------------------------

with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body RCA.Engine is

   ---------------------------------------------------------------------------
   -- Status printing helpers
   ---------------------------------------------------------------------------

   function State_Name (S : State) return String is
   begin
      case S is
         when Init     => return "Init";
         when Idle     => return "Idle";
         when Running  => return "Running";
         when Halt     => return "Halt";
         when Failure  => return "Failure";
         when Shutdown => return "Shutdown";
      end case;
   end State_Name;

   function Mode_Name (M : RCA.Control.Mode) return String is
   begin
      case M is
         when Mode_None => return "None";
         when Debug     => return "Debug";
      end case;
   end Mode_Name;

   procedure Print_Control (Ctl : in Control_Plane) is
   begin
      Put_Line ("  Control:");
      Put_Line ("    state: " & State_Name (Ctl.Current_State));
      Put_Line ("    mode:  " & Mode_Name (Ctl.Current_Mode));
   end Print_Control;

   procedure Print_Data (DP : in Data_Plane) is
   begin
      Put_Line ("  Data:");
      Put_Line ("    cells.count: " & Natural'Image (DP.Cells.Count));
      Put_Line ("    activity:    """ & To_String (DP.Activity.Description) & """");
   end Print_Data;

   procedure Print_Cell_Data (CD : in Cell_Data) is
   begin
      Put_Line ("  Effect:");
      case CD.Tag is
         when Cell_None =>
            Put_Line ("    None");
         when Cell_Byte =>
            Put_Line ("    Byte(" & Natural'Image (CD.Value) & ")");
      end case;
   end Print_Cell_Data;

   ---------------------------------------------------------------------------
   -- Default
   ---------------------------------------------------------------------------

   function Give_Default return Engine_Type is
      E : Engine_Type;
   begin
      E.Ctx.Cells.Count := Num_Cells;
      return E;
   end Give_Default;

   ---------------------------------------------------------------------------
   -- Status accessors
   ---------------------------------------------------------------------------

   procedure Print_Init_Status (E : in Engine_Type) is
   begin
      New_Line;
      Put_Line (">>>");
      Print_Control (E.Ctl);
      New_Line;
      Print_Data (E.Ctx);
      New_Line;
   end Print_Init_Status;

   procedure Print_Running_Status (E : in Engine_Type; Efx : in Cell_Data) is
   begin
      New_Line;
      Put_Line (">>>");
      Print_Control (E.Ctl);
      New_Line;
      Print_Cell_Data (Efx);
      New_Line;
      Print_Data (E.Ctx);
      Put_Line ("<<<");
   end Print_Running_Status;

   procedure Print_Shutdown_Status (E : in Engine_Type) is
   begin
      New_Line;
      Put_Line (">>>");
      Print_Control (E.Ctl);
      New_Line;
      Print_Data (E.Ctx);
      New_Line;
   end Print_Shutdown_Status;

   ---------------------------------------------------------------------------
   -- Engine run
   ---------------------------------------------------------------------------

   procedure Try_Run_Engine (E : in out Engine_Type) is
      Current_Thread : Program_Thread;
      Efx            : Effect;
   begin
      Print_Init_Status (E);

      Current_Thread := Build_Tasks
        (Tsks => (0 => (Id => 0, The_Task => Task_Default),
                  1 => (Id => 1, The_Task => Task_Double_Value)));

      E.Ctl.Current_State := Halt;
      Print_Init_Status (E);

      E.Ctl.Current_State := Idle;
      Print_Init_Status (E);

      E.Ctl.Current_State := Running;
      Print_Init_Status (E);

      loop
         case E.Ctl.Current_State is

            when Running =>
               Step (Current_Thread, E.Ctx, Efx);
               E.Ctx.Activity := Efx.Activity;

               if E.Ctl.Current_Mode = Debug then
                  Print_Running_Status (E, Efx.Handoff);
               end if;

               if Efx.Finished then
                  E.Ctl.Current_State := Shutdown;
                  E.Ctx.Activity := (Description => Null_Unbounded_String);
                  Print_Shutdown_Status (E);
                  return;
               end if;

            when others =>
               E.Ctl.Current_State := Shutdown;
               Print_Shutdown_Status (E);
               return;

         end case;
      end loop;
   end Try_Run_Engine;

   ---------------------------------------------------------------------------
   -- (2) Add custom engine implementations here
   ---------------------------------------------------------------------------

end RCA.Engine;

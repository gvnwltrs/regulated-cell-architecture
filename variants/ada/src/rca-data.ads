-------------------------------------------------------------------------------
-- Regulated Cell Architecture (RCA) - Ada Variant
-- Data Plane
--
-- Establish data endpoints.
-- Establish & confirm complete data.
-------------------------------------------------------------------------------

with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package RCA.Data is

   ---------------------------------------------------------------------------
   -- Apex data models
   ---------------------------------------------------------------------------

   -- Status: MUTABLE
   type Config_Data is (Config_None);

   -- Status: MUTABLE
   type Read_Data is (Read_None);

   -- Status: MUTABLE
   type Write_Data is (Write_None);

   -- Status: MUTABLE
   type Perf_Data is (Perf_None);

   -- Status: MUTABLE
   type Log_Data_Tag is (Log_None, Log_Session);

   type Log_Data (Tag : Log_Data_Tag := Log_None) is record
      case Tag is
         when Log_None    => null;
         when Log_Session =>
            Entry_Text : Unbounded_String;
            Date       : Unbounded_String;
      end case;
   end record;

   -- Status: FREEZE
   type Cell_Info is record
      Count : Natural := 0;
   end record;

   -- Status: FREEZE
   type Activity_Info is record
      Description : Unbounded_String := Null_Unbounded_String;
   end record;

   -- Status: FREEZE
   type Display_Info is record
      Title  : Unbounded_String := Null_Unbounded_String;
      Content : Unbounded_String := Null_Unbounded_String;
      Status : Unbounded_String := Null_Unbounded_String;
   end record;

   -- Status: FREEZE
   type System_Data is record
      Description : Unbounded_String := Null_Unbounded_String;
   end record;

   ---------------------------------------------------------------------------
   -- Data Plane
   ---------------------------------------------------------------------------

   -- Status: FREEZE
   type Data_Plane is record
      Config   : Config_Data   := Config_None;    -- Init state
      Read_IO  : Read_Data     := Read_None;      -- Running state: import
      Write_IO : Write_Data    := Write_None;     -- Running state: export
      Perf     : Perf_Data     := Perf_None;      -- Running state: system info
      Logs     : Log_Data      := (Tag => Log_None);
      Cells    : Cell_Info     := (Count => 0);
      Activity : Activity_Info := (Description => Null_Unbounded_String);
      Display  : Display_Info  := (others => Null_Unbounded_String);
   end record;

   ---------------------------------------------------------------------------
   -- Add custom data models here
   ---------------------------------------------------------------------------

end RCA.Data;

///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Java Variant
// Data Plane
//
// Establish data endpoints.
// Establish & confirm complete data.
///////////////////////////////////////////////////////////////////////////////

package rca;

///////////////////////////////////////////////////////////////////////////////
// Apex data models
///////////////////////////////////////////////////////////////////////////////

// Status: MUTABLE
enum ConfigData { NONE }

// Status: MUTABLE
enum ReadData { NONE }

// Status: MUTABLE
enum WriteData { NONE }

// Status: MUTABLE
enum PerfData { NONE }

// Status: MUTABLE
enum LogDataTag { NONE, SESSION }

// Status: FREEZE
record CellInfo(int count) {
    static CellInfo defaults() { return new CellInfo(0); }
}

// Status: FREEZE
record ActivityInfo(String description) {
    static ActivityInfo defaults() { return new ActivityInfo(""); }
}

// Status: FREEZE
record DisplayInfo(String title, String body, String status) {
    static DisplayInfo defaults() { return new DisplayInfo("", "", ""); }
}

// Status: FREEZE
record SystemData(String description) {
    static SystemData defaults() { return new SystemData(""); }
}

///////////////////////////////////////////////////////////////////////////////
// Data Plane
///////////////////////////////////////////////////////////////////////////////

// Status: FREEZE
public class Data {
    ConfigData config;
    ReadData readIO;
    WriteData writeIO;
    PerfData perf;
    LogDataTag logs;
    CellInfo cells;
    ActivityInfo activity;
    DisplayInfo display;

    Data(int numCells) {
        this.config   = ConfigData.NONE;
        this.readIO   = ReadData.NONE;
        this.writeIO  = WriteData.NONE;
        this.perf     = PerfData.NONE;
        this.logs     = LogDataTag.NONE;
        this.cells    = new CellInfo(numCells);
        this.activity = ActivityInfo.defaults();
        this.display  = DisplayInfo.defaults();
    }

    ///////////////////////////////////////////////////////////////////////////
    // Add custom data models here
    ///////////////////////////////////////////////////////////////////////////
}

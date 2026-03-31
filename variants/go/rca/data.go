///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Go Variant
// Data Plane
//
// Establish data endpoints.
// Establish & confirm complete data.
///////////////////////////////////////////////////////////////////////////////

package rca

///////////////////////////////////////////////////////////////////////////////
// Apex data models
///////////////////////////////////////////////////////////////////////////////

// Status: MUTABLE
type ConfigData int

const ConfigNone ConfigData = iota

// Status: MUTABLE
type ReadData int

const ReadNone ReadData = iota

// Status: MUTABLE
type WriteData int

const WriteNone WriteData = iota

// Status: MUTABLE
type PerfData int

const PerfNone PerfData = iota

// Status: MUTABLE
type LogData int

const LogNone LogData = iota

// Status: FREEZE
type CellInfo struct {
	Count int
}

// Status: FREEZE
type ActivityInfo struct {
	Description string
}

// Status: FREEZE
type DisplayInfo struct {
	Title  string
	Body   string
	Status string
}

// Status: FREEZE
type SystemData struct {
	Description string
}

///////////////////////////////////////////////////////////////////////////////
// Data Plane
///////////////////////////////////////////////////////////////////////////////

// Status: FREEZE
type DataPlane struct {
	Config  ConfigData   // Init state: initialization & configuration
	ReadIO  ReadData     // Running state: import data
	WriteIO WriteData    // Running state: export data
	Perf    PerfData     // Running state: system information
	Logs    LogData      // Running/Failure/Shutdown: event logs
	Cells   CellInfo     // Running state: cell metadata
	Activity ActivityInfo // Running state: current task details
	Display DisplayInfo  // Running state: terminal/display output
}

func DefaultDataPlane(numCells int) DataPlane {
	return DataPlane{
		Config:  ConfigNone,
		ReadIO:  ReadNone,
		WriteIO: WriteNone,
		Perf:    PerfNone,
		Logs:    LogNone,
		Cells:   CellInfo{Count: numCells},
	}
}

///////////////////////////////////////////////////////////////////////////////
// Add custom data models here
///////////////////////////////////////////////////////////////////////////////

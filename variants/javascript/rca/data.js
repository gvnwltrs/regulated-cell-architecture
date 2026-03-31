///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - JavaScript Variant
// Data Plane
//
// Establish data endpoints.
// Establish & confirm complete data.
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Apex data models
///////////////////////////////////////////////////////////////////////////////

// Status: FREEZE
function createCellInfo(count = 0) {
  return { count };
}

// Status: FREEZE
function createActivityInfo(description = "") {
  return { description };
}

// Status: FREEZE
function createDisplayInfo(title = "", body = "", status = "") {
  return { title, body, status };
}

// Status: FREEZE
function createSystemData(description = "") {
  return { description };
}

///////////////////////////////////////////////////////////////////////////////
// Data Plane
///////////////////////////////////////////////////////////////////////////////

// Status: FREEZE
function createDataPlane(numCells = 0) {
  return {
    config:   "none",       // Init state: initialization & configuration
    readIO:   "none",       // Running state: import data
    writeIO:  "none",       // Running state: export data
    perf:     "none",       // Running state: system information
    logs:     "none",       // Running/Failure/Shutdown: event logs
    cells:    createCellInfo(numCells),   // Running state: cell metadata
    activity: createActivityInfo(),       // Running state: current task details
    display:  createDisplayInfo(),        // Running state: terminal/display output
  };
}

///////////////////////////////////////////////////////////////////////////////
// Add custom data models here
///////////////////////////////////////////////////////////////////////////////

module.exports = {
  createCellInfo,
  createActivityInfo,
  createDisplayInfo,
  createSystemData,
  createDataPlane,
};

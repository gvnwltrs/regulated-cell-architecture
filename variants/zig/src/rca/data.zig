///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Zig Variant
// Data Plane
//
// Establish data endpoints.
// Establish & confirm complete data.
///////////////////////////////////////////////////////////////////////////////

const std = @import("std");

// *****************************************************************************
// Apex data models
// *****************************************************************************

// Status: MUTABLE
pub const ConfigData = enum { none };

// Status: MUTABLE
pub const ReadData = enum { none };

// Status: MUTABLE
pub const WriteData = enum { none };

// Status: MUTABLE
pub const PerfData = enum { none };

// Status: MUTABLE
pub const LogData = union(enum) {
    none,
    session: struct {
        entry: []const u8,
        date: []const u8,
    },
};

// Status: FREEZE
pub const CellInfo = struct {
    count: usize = 0,
};

// Status: FREEZE
pub const ActivityInfo = struct {
    description: []const u8 = "",
};

// Status: FREEZE
pub const DisplayInfo = struct {
    title: []const u8 = "",
    body: []const u8 = "",
    status: []const u8 = "",
};

// Status: FREEZE
pub const SystemData = struct {
    description: []const u8 = "",
};

// *****************************************************************************
// Data Plane
// *****************************************************************************

// Status: FREEZE
pub const DataPlane = struct {
    config: ConfigData = .none, // Init state: initialization & configuration
    read_io: ReadData = .none, // Running state: import data
    write_io: WriteData = .none, // Running state: export data
    perf: PerfData = .none, // Running state: system information
    logs: LogData = .none, // Running/Failure/Shutdown: event logs
    cells: CellInfo = .{}, // Running state: cell metadata
    activity: ActivityInfo = .{}, // Running state: current task details
    display: DisplayInfo = .{}, // Running state: terminal/display output
};

// *****************************************************************************
// Add custom data models here
// *****************************************************************************

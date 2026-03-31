///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Zig Variant
// Cell
//
// Each cell can access the system context/data but cannot modify it.
// Only the engine has authority to modify state.
// Each cell HAS-A task.
///////////////////////////////////////////////////////////////////////////////

const data = @import("data.zig");
const DataPlane = data.DataPlane;

// Status: MUTABLE
pub const CELLS: usize = 2;

// *****************************************************************************
// (1) Cell Data
// *****************************************************************************

// Status: MUTABLE
pub const CellData = union(enum) {
    none,
    byte: u8,
    // Add cell data types here
};

// *****************************************************************************
// (2) Tasks
// *****************************************************************************

// Status: MUTABLE
pub const Task = enum {
    default,
    double_value,
    // Add tasks here
};

// Status: MUTABLE
pub fn taskAccess(task: Task, ctx: *const DataPlane, handoff: CellData) CellData {
    _ = ctx;

    return switch (task) {
        .default => CellData{ .byte = 0x2A }, // 42

        .double_value => switch (handoff) {
            .byte => |val| CellData{ .byte = val +% val }, // 84
            else => handoff,
        },

        // Add task procedures here
    };
}

// *****************************************************************************
// (3) Cell
// *****************************************************************************

// Status: FREEZE
pub const Cell = struct {
    id: usize,
    task: Task,

    pub fn execute(self: *Cell, ctx: *const DataPlane, handoff: CellData) CellData {
        return taskAccess(self.task, ctx, handoff);
    }
};

pub fn cellDefaults() [CELLS]Cell {
    var cells: [CELLS]Cell = undefined;
    for (0..CELLS) |i| {
        cells[i] = .{ .id = i, .task = .default };
    }
    return cells;
}

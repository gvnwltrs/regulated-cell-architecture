///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Zig Variant
// Thread
///////////////////////////////////////////////////////////////////////////////

const data = @import("data.zig");
const cell_mod = @import("cell.zig");

const DataPlane = data.DataPlane;
const ActivityInfo = data.ActivityInfo;
const Cell = cell_mod.Cell;
const CellData = cell_mod.CellData;
const CELLS = cell_mod.CELLS;
const cellDefaults = cell_mod.cellDefaults;

// *****************************************************************************
// (1) Threads
// *****************************************************************************

// Status: MUTABLE
pub const THREADS: usize = 1;

// Status: MUTABLE
pub const EXECUTION_THRESHOLD: f64 = 1.0; // Units in ms

// Status: MUTABLE
pub const Effect = struct {
    activity: ActivityInfo,
    handoff: *const CellData,
    finished: bool,
};

fn taskName(task: cell_mod.Task) []const u8 {
    return switch (task) {
        .default => "Default",
        .double_value => "DoubleValue",
    };
}

// Status: MUTABLE
pub const ProgramThread = struct {
    counter: usize = 0,
    tasks: [CELLS]Cell = cellDefaults(),
    handoff: CellData = .none,

    pub fn buildTasks(tasks: ?[CELLS]Cell, ho: ?CellData) ProgramThread {
        return .{
            .counter = 0,
            .tasks = tasks orelse cellDefaults(),
            .handoff = ho orelse .none,
        };
    }

    pub fn isFinished(self: *const ProgramThread) bool {
        return self.counter >= CELLS;
    }

    pub fn step(self: *ProgramThread, ctx: *const DataPlane) Effect {
        const activity = ActivityInfo{
            .description = taskName(self.tasks[self.counter].task),
        };

        // Handoff transfer: take current, pass to cell, store result back
        const handoff_transfer = self.handoff;
        self.handoff = .none;

        self.handoff = self.tasks[self.counter].execute(ctx, handoff_transfer);
        self.counter += 1;

        const finished = self.isFinished();

        return .{
            .activity = activity,
            .handoff = &self.handoff,
            .finished = finished,
        };
    }
};

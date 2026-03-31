///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Zig Variant
// Engine
//
// Micro-kernel space (Loop Engine privilege only):
// Apply returned outputs to ctx.
///////////////////////////////////////////////////////////////////////////////

const std = @import("std");
const data = @import("data.zig");
const control = @import("control.zig");
const cell_mod = @import("cell.zig");
const thread_mod = @import("thread.zig");

const DataPlane = data.DataPlane;
const ActivityInfo = data.ActivityInfo;
const SystemData = data.SystemData;
const ControlPlane = control.ControlPlane;
const State = control.State;
const Mode = control.Mode;
const Cell = cell_mod.Cell;
const CellData = cell_mod.CellData;
const CELLS = cell_mod.CELLS;
const ProgramThread = thread_mod.ProgramThread;

const print = std.debug.print;

// *****************************************************************************
// Status printing helpers
// *****************************************************************************

fn stateName(s: State) []const u8 {
    return switch (s) {
        .init => "Init",
        .idle => "Idle",
        .running => "Running",
        .halt => "Halt",
        .failure => "Failure",
        .shutdown => "Shutdown",
    };
}

fn modeName(m: Mode) []const u8 {
    return switch (m) {
        .none => "None",
        .debug => "Debug",
    };
}

fn printControl(ctl: *const ControlPlane) void {
    print("  Control:\n", .{});
    print("    state: {s}\n", .{stateName(ctl.state)});
    print("    mode:  {s}\n", .{modeName(ctl.mode)});
}

fn printData(dp: *const DataPlane) void {
    print("  Data:\n", .{});
    print("    cells.count: {d}\n", .{dp.cells.count});
    print("    activity:    \"{s}\"\n", .{dp.activity.description});
}

fn printCellData(cd: *const CellData) void {
    print("  Effect:\n", .{});
    switch (cd.*) {
        .none => print("    None\n", .{}),
        .byte => |val| print("    Byte({d})\n", .{val}),
    }
}

// *****************************************************************************
// (1) Engine
// *****************************************************************************

// Status: FREEZE
pub const Engine = struct {
    ctx: DataPlane = .{},
    ctl: ControlPlane = .{},
    sys: SystemData = .{},

    pub fn giveDefault() Engine {
        return .{
            .ctx = .{ .cells = .{ .count = CELLS } },
            .ctl = .{},
            .sys = .{},
        };
    }

    pub fn printInitStatus(self: *const Engine) void {
        print("\n>>>\n", .{});
        printControl(&self.ctl);
        print("\n", .{});
        printData(&self.ctx);
        print("\n", .{});
    }

    pub fn printRunningStatus(self: *const Engine, efx: *const CellData) void {
        print("\n>>>\n", .{});
        printControl(&self.ctl);
        print("\n", .{});
        printCellData(efx);
        print("\n", .{});
        printData(&self.ctx);
        print("<<<\n", .{});
    }

    pub fn printShutdownStatus(self: *const Engine) void {
        print("\n>>>\n", .{});
        printControl(&self.ctl);
        print("\n", .{});
        printData(&self.ctx);
        print("\n", .{});
    }

    pub fn tryRunEngine(self: *Engine) !void {
        self.printInitStatus();

        var current_thread = ProgramThread.buildTasks(
            [CELLS]Cell{
                .{ .id = 0, .task = .default },
                .{ .id = 1, .task = .double_value },
            },
            null,
        );

        self.ctl.state = .halt;
        self.printInitStatus();

        self.ctl.state = .idle;
        self.printInitStatus();

        self.ctl.state = .running;
        self.printInitStatus();

        while (true) {
            switch (self.ctl.state) {
                .running => {
                    const effect = current_thread.step(&self.ctx);
                    self.ctx.activity = effect.activity;

                    if (self.ctl.mode == .debug) {
                        self.printRunningStatus(effect.handoff);
                    }

                    if (effect.finished) {
                        self.ctl.state = .shutdown;
                        self.ctx.activity = .{};
                        self.printShutdownStatus();
                        return;
                    }
                },
                else => {
                    self.ctl.state = .shutdown;
                    self.printShutdownStatus();
                    return;
                },
            }
        }
    }

    // *************************************************************************
    // (2) Add custom engine functions here
    // *************************************************************************
};

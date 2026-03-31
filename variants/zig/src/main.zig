///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Zig Variant
// Author: Gavin Walters
// Created: 2026-03-06
//
// Description:
// Linear Sequential Runtime System
//
// Workflow:
// Data -> Constraints -> Cells -> Threads -> Engine
///////////////////////////////////////////////////////////////////////////////

const engine_mod = @import("rca/engine.zig");
const Engine = engine_mod.Engine;

// *****************************************************************************
// Runtime Engine
// *****************************************************************************

pub fn main() !void {
    var engine = Engine.giveDefault();
    try engine.tryRunEngine();
}

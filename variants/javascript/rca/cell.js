///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - JavaScript Variant
// Cell
//
// Each cell can access the system context/data but cannot modify it.
// Only the engine has authority to modify state.
// Each cell HAS-A task.
///////////////////////////////////////////////////////////////////////////////

// Status: MUTABLE
const NUM_CELLS = 2;

///////////////////////////////////////////////////////////////////////////////
// (1) Cell Data
///////////////////////////////////////////////////////////////////////////////

// Status: MUTABLE
function cellNone() {
  return { tag: "none" };
}

function cellByte(value) {
  return { tag: "byte", value };
}

// Add cell data types here

///////////////////////////////////////////////////////////////////////////////
// (2) Tasks
///////////////////////////////////////////////////////////////////////////////

const Task = Object.freeze({
  DEFAULT:      "Default",
  DOUBLE_VALUE: "DoubleValue",
  // Add tasks here
});

// Status: MUTABLE
function taskAccess(task, ctx, handoff) {
  switch (task) {
    case Task.DEFAULT:
      return cellByte(0x2A); // 42

    case Task.DOUBLE_VALUE:
      if (handoff.tag === "byte") {
        return cellByte((handoff.value + handoff.value) & 0xFF); // 84
      }
      return handoff;

    // Add task procedures here

    default:
      return handoff;
  }
}

///////////////////////////////////////////////////////////////////////////////
// (3) Cell
///////////////////////////////////////////////////////////////////////////////

// Status: FREEZE
function createCell(id, task) {
  return { id, task };
}

function cellExecute(cell, ctx, handoff) {
  return taskAccess(cell.task, ctx, handoff);
}

function cellDefaults() {
  const cells = [];
  for (let i = 0; i < NUM_CELLS; i++) {
    cells.push(createCell(i, Task.DEFAULT));
  }
  return cells;
}

module.exports = {
  NUM_CELLS,
  cellNone,
  cellByte,
  Task,
  taskAccess,
  createCell,
  cellExecute,
  cellDefaults,
};

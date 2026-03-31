///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - JavaScript Variant
// Thread
///////////////////////////////////////////////////////////////////////////////

const { createActivityInfo } = require("./data");
const { NUM_CELLS, cellNone, cellExecute, cellDefaults } = require("./cell");

///////////////////////////////////////////////////////////////////////////////
// (1) Threads
///////////////////////////////////////////////////////////////////////////////

// Status: MUTABLE
const NUM_THREADS = 1;

// Status: MUTABLE
const EXECUTION_THRESHOLD = 1.0; // Units in ms

// Status: MUTABLE
function createProgramThread(tasks, handoff) {
  return {
    counter: 0,
    tasks:   tasks || cellDefaults(),
    handoff: handoff || cellNone(),
  };
}

function buildTasks(tasks, handoff) {
  return createProgramThread(tasks, handoff);
}

function isFinished(pt) {
  return pt.counter >= pt.tasks.length;
}

function step(pt, ctx) {
  const activity = createActivityInfo(pt.tasks[pt.counter].task);

  // Handoff transfer: take current, pass to cell, store result back
  const handoffTransfer = pt.handoff;
  pt.handoff = cellNone();

  pt.handoff = cellExecute(pt.tasks[pt.counter], ctx, handoffTransfer);
  pt.counter++;

  const finished = isFinished(pt);

  return {
    activity,
    handoff: pt.handoff,
    finished,
  };
}

module.exports = {
  NUM_THREADS,
  EXECUTION_THRESHOLD,
  createProgramThread,
  buildTasks,
  isFinished,
  step,
};

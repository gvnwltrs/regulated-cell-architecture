///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - JavaScript Variant
// Engine
//
// Micro-kernel space (Loop Engine privilege only):
// Apply returned outputs to ctx.
///////////////////////////////////////////////////////////////////////////////

const { createDataPlane, createActivityInfo, createSystemData } = require("./data");
const { State, Mode, createControlPlane } = require("./control");
const { NUM_CELLS, createCell, Task } = require("./cell");
const { buildTasks, step } = require("./thread");

///////////////////////////////////////////////////////////////////////////////
// Status printing helpers
///////////////////////////////////////////////////////////////////////////////

function printControl(ctl) {
  console.log("  Control:");
  console.log(`    state: ${ctl.state}`);
  console.log(`    mode:  ${ctl.mode}`);
}

function printData(dp) {
  console.log("  Data:");
  console.log(`    cells.count: ${dp.cells.count}`);
  console.log(`    activity:    "${dp.activity.description}"`);
}

function printCellData(cd) {
  console.log("  Effect:");
  switch (cd.tag) {
    case "none":
      console.log("    None");
      break;
    case "byte":
      console.log(`    Byte(${cd.value})`);
      break;
  }
}

///////////////////////////////////////////////////////////////////////////////
// (1) Engine
///////////////////////////////////////////////////////////////////////////////

// Status: FREEZE
function giveDefault() {
  return {
    ctx: createDataPlane(NUM_CELLS),
    ctl: createControlPlane(),
    sys: createSystemData(),
  };
}

function printInitStatus(engine) {
  console.log("\n>>>");
  printControl(engine.ctl);
  console.log("");
  printData(engine.ctx);
  console.log("");
}

function printRunningStatus(engine, efx) {
  console.log("\n>>>");
  printControl(engine.ctl);
  console.log("");
  printCellData(efx);
  console.log("");
  printData(engine.ctx);
  console.log("<<<");
}

function printShutdownStatus(engine) {
  console.log("\n>>>");
  printControl(engine.ctl);
  console.log("");
  printData(engine.ctx);
  console.log("");
}

///////////////////////////////////////////////////////////////////////////////
// Engine run
///////////////////////////////////////////////////////////////////////////////

function tryRunEngine(engine) {
  printInitStatus(engine);

  const currentThread = buildTasks([
    createCell(0, Task.DEFAULT),
    createCell(1, Task.DOUBLE_VALUE),
  ]);

  engine.ctl.state = State.HALT;
  printInitStatus(engine);

  engine.ctl.state = State.IDLE;
  printInitStatus(engine);

  engine.ctl.state = State.RUNNING;
  printInitStatus(engine);

  for (;;) {
    switch (engine.ctl.state) {
      case State.RUNNING: {
        const effect = step(currentThread, engine.ctx);
        engine.ctx.activity = effect.activity;

        if (engine.ctl.mode === Mode.DEBUG) {
          printRunningStatus(engine, effect.handoff);
        }

        if (effect.finished) {
          engine.ctl.state = State.SHUTDOWN;
          engine.ctx.activity = createActivityInfo();
          printShutdownStatus(engine);
          return 0;
        }
        break;
      }

      default: {
        engine.ctl.state = State.SHUTDOWN;
        printShutdownStatus(engine);
        return 0;
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////
// (2) Add custom engine functions here
///////////////////////////////////////////////////////////////////////////////

module.exports = {
  giveDefault,
  tryRunEngine,
};

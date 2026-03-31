"""
Regulated Cell Architecture (RCA) - Python Variant
Engine

Micro-kernel space (Loop Engine privilege only):
Apply returned outputs to ctx.
"""

from __future__ import annotations
from dataclasses import dataclass, field

from .data import DataPlane, ActivityInfo, SystemData
from .control import ControlPlane, State, Mode
from .cell import Cell, CellData, CellNone, CellByte, Task, CELLS
from .thread import ProgramThread


###############################################################################
# Status printing helpers
###############################################################################

def _state_name(s: State) -> str:
    return s.name.capitalize()


def _mode_name(m: Mode) -> str:
    return m.name.capitalize()


def _print_control(ctl: ControlPlane) -> None:
    print(f"  Control:")
    print(f"    state: {_state_name(ctl.state)}")
    print(f"    mode:  {_mode_name(ctl.mode)}")


def _print_data(dp: DataPlane) -> None:
    print(f"  Data:")
    print(f"    cells.count: {dp.cells.count}")
    print(f"    activity:    \"{dp.activity.description}\"")


def _print_cell_data(cd: CellData) -> None:
    print(f"  Effect:")
    if isinstance(cd, CellNone):
        print(f"    None")
    elif isinstance(cd, CellByte):
        print(f"    Byte({cd.value})")


###############################################################################
# (1) Engine
###############################################################################

# Status: FREEZE
@dataclass
class Engine:
    ctx: DataPlane = field(default_factory=DataPlane)
    ctl: ControlPlane = field(default_factory=ControlPlane)
    sys: SystemData = field(default_factory=SystemData)

    @staticmethod
    def give_default() -> Engine:
        engine = Engine()
        engine.ctx.cells.count = CELLS
        return engine

    def print_init_status(self) -> None:
        print(f"\n>>>")
        _print_control(self.ctl)
        print()
        _print_data(self.ctx)
        print()

    def print_running_status(self, efx: CellData) -> None:
        print(f"\n>>>")
        _print_control(self.ctl)
        print()
        _print_cell_data(efx)
        print()
        _print_data(self.ctx)
        print(f"<<<")

    def print_shutdown_status(self) -> None:
        print(f"\n>>>")
        _print_control(self.ctl)
        print()
        _print_data(self.ctx)
        print()

    def try_run_engine(self) -> int:
        self.print_init_status()

        current_thread = ProgramThread.build_tasks(
            tsks=[
                Cell(id=0, task=Task.DEFAULT),
                Cell(id=1, task=Task.DOUBLE_VALUE),
            ],
        )

        self.ctl.state = State.HALT
        self.print_init_status()

        self.ctl.state = State.IDLE
        self.print_init_status()

        self.ctl.state = State.RUNNING
        self.print_init_status()

        while True:
            if self.ctl.state == State.RUNNING:
                effect = current_thread.step(self.ctx)
                self.ctx.activity = effect.activity

                if self.ctl.mode == Mode.DEBUG:
                    self.print_running_status(effect.handoff)

                if effect.finished:
                    self.ctl.state = State.SHUTDOWN
                    self.ctx.activity = ActivityInfo()
                    self.print_shutdown_status()
                    return 0

            else:
                self.ctl.state = State.SHUTDOWN
                self.print_shutdown_status()
                return 0


###############################################################################
# (2) Add custom engine classes/functions here
###############################################################################

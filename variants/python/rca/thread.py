"""
Regulated Cell Architecture (RCA) - Python Variant
Thread
"""

from __future__ import annotations
from dataclasses import dataclass, field

from .data import DataPlane, ActivityInfo
from .cell import Cell, CellData, CellNone, CELLS, cell_defaults


###############################################################################
# (1) Threads
###############################################################################

# Status: MUTABLE
THREADS: int = 1

# Status: MUTABLE
EXECUTION_THRESHOLD: float = 1.0  # Units in ms


# Status: MUTABLE
@dataclass
class Effect:
    activity: ActivityInfo
    handoff: CellData
    finished: bool


# Status: MUTABLE
@dataclass
class ProgramThread:
    counter: int = 0
    tasks: list[Cell] = field(default_factory=cell_defaults)
    handoff: CellData = field(default_factory=CellNone)

    @staticmethod
    def build_tasks(
        ctr: int | None = None,
        tsks: list[Cell] | None = None,
        ho: CellData | None = None,
    ) -> ProgramThread:
        return ProgramThread(
            counter=ctr if ctr is not None else 0,
            tasks=tsks if tsks is not None else cell_defaults(),
            handoff=ho if ho is not None else CellNone(),
        )

    def is_finished(self) -> bool:
        return self.counter >= len(self.tasks)

    def step(self, ctx: DataPlane) -> Effect:
        _task_names = {
            "DEFAULT": "Default",
            "DOUBLE_VALUE": "DoubleValue",
        }
        activity = ActivityInfo(description=_task_names.get(self.tasks[self.counter].task.name, self.tasks[self.counter].task.name))

        # Handoff transfer: take current, pass to cell, store result back
        handoff_transfer = self.handoff
        self.handoff = CellNone()

        self.handoff = self.tasks[self.counter].execute(ctx, handoff_transfer)
        self.counter += 1

        finished = self.is_finished()

        return Effect(
            activity=activity,
            handoff=self.handoff,
            finished=finished,
        )

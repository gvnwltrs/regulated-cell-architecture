"""
Regulated Cell Architecture (RCA) - Python Variant
Cell

Each cell can access the system context/data but cannot modify it.
Only the engine has authority to modify state.
Each cell HAS-A task.
"""

from __future__ import annotations
from dataclasses import dataclass
from enum import Enum, auto
from typing import Union

from .data import DataPlane


# Status: MUTABLE
CELLS: int = 2


###############################################################################
# (1) Cell Data
###############################################################################

# Status: MUTABLE
@dataclass
class CellNone:
    pass


@dataclass
class CellByte:
    value: int

# Add cell data types here

CellData = Union[CellNone, CellByte]


###############################################################################
# (2) Tasks
###############################################################################

# Status: MUTABLE
class Task(Enum):
    DEFAULT = auto()
    DOUBLE_VALUE = auto()
    # Add tasks here


# Status: MUTABLE
def task_access(task: Task, ctx: DataPlane, handoff: CellData) -> CellData:
    if task == Task.DEFAULT:
        return CellByte(value=0x2A)  # 42

    elif task == Task.DOUBLE_VALUE:
        if isinstance(handoff, CellByte):
            return CellByte(value=handoff.value + handoff.value)  # 84
        return handoff

    # Add task procedures here

    return handoff


###############################################################################
# (3) Cell
###############################################################################

# Status: FREEZE
@dataclass
class Cell:
    id: int
    task: Task

    def execute(self, ctx: DataPlane, handoff: CellData) -> CellData:
        return task_access(self.task, ctx, handoff)


def cell_defaults() -> list[Cell]:
    return [Cell(id=i, task=Task.DEFAULT) for i in range(CELLS)]

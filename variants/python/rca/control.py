"""
Regulated Cell Architecture (RCA) - Python Variant
Control Plane
"""

from __future__ import annotations
from dataclasses import dataclass
from enum import Enum, auto


###############################################################################
# (1) States
###############################################################################

# Status: FREEZE
class State(Enum):
    INIT = auto()
    IDLE = auto()
    RUNNING = auto()
    HALT = auto()
    FAILURE = auto()
    SHUTDOWN = auto()


###############################################################################
# (2) Modes
###############################################################################

# Status: MUTABLE
class Mode(Enum):
    NONE = auto()
    DEBUG = auto()


###############################################################################
# (3) Events
###############################################################################

# Status: MUTABLE
class Event(Enum):
    NONE = auto()


###############################################################################
# Control Plane
###############################################################################

# Status: FREEZE
@dataclass
class ControlPlane:
    state: State = State.INIT
    mode: Mode = Mode.DEBUG
    event: Event = Event.NONE

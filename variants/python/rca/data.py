"""
Regulated Cell Architecture (RCA) - Python Variant
Data Plane

Establish data endpoints.
Establish & confirm complete data.
"""

from __future__ import annotations
from dataclasses import dataclass, field
from enum import Enum, auto


###############################################################################
# Apex data models
###############################################################################

# Status: MUTABLE
class ConfigData(Enum):
    NONE = auto()


# Status: MUTABLE
class ReadData(Enum):
    NONE = auto()


# Status: MUTABLE
class WriteData(Enum):
    NONE = auto()


# Status: MUTABLE
class PerfData(Enum):
    NONE = auto()


# Status: MUTABLE
class LogData(Enum):
    NONE = auto()
    SESSION = auto()


# Status: FREEZE
@dataclass
class CellInfo:
    count: int = 0


# Status: FREEZE
@dataclass
class ActivityInfo:
    description: str = ""


# Status: FREEZE
@dataclass
class DisplayInfo:
    title: str = ""
    body: str = ""
    status: str = ""


# Status: FREEZE
@dataclass
class SystemData:
    description: str = ""


###############################################################################
# Data Plane
###############################################################################

# Status: FREEZE
@dataclass
class DataPlane:
    config: ConfigData = ConfigData.NONE          # Init state: initialization & configuration
    read_io: ReadData = ReadData.NONE             # Running state: import data
    write_io: WriteData = WriteData.NONE          # Running state: export data
    perf: PerfData = PerfData.NONE                # Running state: system information
    logs: LogData = LogData.NONE                  # Running/Failure/Shutdown: event logs
    cells: CellInfo = field(default_factory=CellInfo)        # Running state: cell metadata
    activity: ActivityInfo = field(default_factory=ActivityInfo)  # Running state: current task details
    display: DisplayInfo = field(default_factory=DisplayInfo)    # Running state: terminal/display output


###############################################################################
# Add custom data models here
###############################################################################

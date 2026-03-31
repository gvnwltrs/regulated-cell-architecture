"""
Regulated Cell Architecture (RCA) - Python Variant
Author: Gavin Walters
Created: 2026-03-06

Description:
Linear Sequential Runtime System

Workflow:
Data -> Constraints -> Cells -> Threads -> Engine
"""

import sys
from rca import Engine


###############################################################################
# Runtime Engine
###############################################################################

def main() -> int:
    engine = Engine.give_default()
    return engine.try_run_engine()


if __name__ == "__main__":
    sys.exit(main())

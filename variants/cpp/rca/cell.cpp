/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C++ Variant
 * Cell Implementation
 ******************************************************************************/

#include "cell.hpp"

namespace rca {

std::array<Cell, CELLS> cell_defaults() {
    std::array<Cell, CELLS> cells;
    for (std::size_t i = 0; i < CELLS; ++i) {
        cells[i] = Cell{i, Task::Default};
    }
    return cells;
}

CellData Cell::execute(const DataPlane &ctx, CellData handoff) {
    return task_access(task, ctx, std::move(handoff));
}

/*******************************************************************************
 * Task Procedures
 ******************************************************************************/

/* Status: MUTABLE */
CellData task_access(Task task, const DataPlane &ctx, CellData handoff) {
    (void)ctx;

    switch (task) {

        case Task::Default: {
            return CellByte{0x2A}; // 42
        }

        case Task::DoubleValue: {
            if (auto *b = std::get_if<CellByte>(&handoff)) {
                return CellByte{static_cast<std::uint8_t>(b->value + b->value)}; // 84
            }
            return handoff;
        }

        /* Add task procedures here */

    }

    return handoff;
}

} // namespace rca

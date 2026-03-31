/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C++ Variant
 * Cell
 *
 * Each cell can access the system context/data but cannot modify it.
 * Only the engine has authority to modify state.
 * Each cell HAS-A task.
 ******************************************************************************/

#ifndef RCA_CELL_HPP
#define RCA_CELL_HPP

#include <array>
#include <cstddef>
#include <cstdint>
#include <stdexcept>
#include <variant>

#include "data.hpp"

namespace rca {

/* Status: MUTABLE */
inline constexpr std::size_t CELLS = 2;

/*******************************************************************************
 * (1) Cell Data
 ******************************************************************************/

/* Status: MUTABLE */
struct CellNone {};

struct CellByte {
    std::uint8_t value;
};

/* Add cell data types here */

using CellData = std::variant<CellNone, CellByte>;

/*******************************************************************************
 * (2) Tasks
 ******************************************************************************/

/* Status: MUTABLE */
enum class Task {
    Default,
    DoubleValue,
    /* Add tasks here */
};

CellData task_access(Task task, const DataPlane &ctx, CellData handoff);

/*******************************************************************************
 * (3) Cell
 ******************************************************************************/

/* Status: FREEZE */
struct Cell {
    std::size_t id;
    Task        task;

    CellData execute(const DataPlane &ctx, CellData handoff);
};

std::array<Cell, CELLS> cell_defaults();

} // namespace rca

#endif /* RCA_CELL_HPP */

/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C++ Variant
 * Thread
 ******************************************************************************/

#ifndef RCA_THREAD_HPP
#define RCA_THREAD_HPP

#include <array>
#include <optional>

#include "data.hpp"
#include "cell.hpp"

namespace rca {

/*******************************************************************************
 * (1) Threads
 ******************************************************************************/

/* Status: MUTABLE */
inline constexpr std::size_t THREADS = 1;

/* Status: MUTABLE */
inline constexpr double EXECUTION_THRESHOLD = 1.0; // Units in ms

/* Status: MUTABLE */
struct Effect {
    ActivityInfo    activity;
    const CellData *handoff;
    bool            finished;
};

/* Status: MUTABLE */
class ProgramThread {
public:
    static ProgramThread build_tasks(
        std::optional<std::size_t> ctr = std::nullopt,
        std::optional<std::array<Cell, CELLS>> tsks = std::nullopt,
        std::optional<CellData> ho = std::nullopt
    );

    Effect step(const DataPlane &ctx);
    bool   is_finished() const;
    const CellData &access_handoff() const;

private:
    std::size_t              counter_{0};
    std::array<Cell, CELLS>  tasks_;
    CellData                 handoff_{CellNone{}};
};

} // namespace rca

#endif /* RCA_THREAD_HPP */

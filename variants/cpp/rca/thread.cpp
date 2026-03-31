/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C++ Variant
 * Thread Implementation
 ******************************************************************************/

#include "thread.hpp"
#include <sstream>
#include <utility>

namespace rca {

static const char *task_name(Task t) {
    switch (t) {
        case Task::Default:     return "Default";
        case Task::DoubleValue: return "DoubleValue";
    }
    return "Unknown";
}

ProgramThread ProgramThread::build_tasks(
    std::optional<std::size_t> ctr,
    std::optional<std::array<Cell, CELLS>> tsks,
    std::optional<CellData> ho
) {
    ProgramThread pt;
    pt.counter_ = ctr.value_or(0);
    pt.tasks_   = tsks.value_or(cell_defaults());
    pt.handoff_ = ho.value_or(CellNone{});
    return pt;
}

bool ProgramThread::is_finished() const {
    return counter_ >= tasks_.size();
}

const CellData &ProgramThread::access_handoff() const {
    return handoff_;
}

Effect ProgramThread::step(const DataPlane &ctx) {
    ActivityInfo activity;
    activity.description = task_name(tasks_[counter_].task);

    // Handoff transfer: take current, pass to cell, store result back
    CellData handoff_transfer = std::exchange(handoff_, CellNone{});

    handoff_ = tasks_[counter_].execute(ctx, std::move(handoff_transfer));
    counter_++;

    bool finished = is_finished();

    return Effect{
        std::move(activity),
        &handoff_,
        finished,
    };
}

} // namespace rca

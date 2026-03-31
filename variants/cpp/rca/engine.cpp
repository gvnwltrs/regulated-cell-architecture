/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C++ Variant
 * Engine Implementation
 ******************************************************************************/

#include "engine.hpp"
#include <iostream>

namespace rca {

/*******************************************************************************
 * Status printing helpers
 ******************************************************************************/

static const char *state_name(State s) {
    switch (s) {
        case State::Init:     return "Init";
        case State::Idle:     return "Idle";
        case State::Running:  return "Running";
        case State::Halt:     return "Halt";
        case State::Failure:  return "Failure";
        case State::Shutdown: return "Shutdown";
    }
    return "Unknown";
}

static const char *mode_name(Mode m) {
    switch (m) {
        case Mode::None:  return "None";
        case Mode::Debug: return "Debug";
    }
    return "Unknown";
}

static void print_control(const ControlPlane &ctl) {
    std::cout << "  Control:\n";
    std::cout << "    state: " << state_name(ctl.state) << "\n";
    std::cout << "    mode:  " << mode_name(ctl.mode) << "\n";
}

static void print_data(const DataPlane &dp) {
    std::cout << "  Data:\n";
    std::cout << "    cells.count: " << dp.cells.count << "\n";
    std::cout << "    activity:    \"" << dp.activity.description << "\"\n";
}

static void print_cell_data(const CellData &cd) {
    std::cout << "  Effect:\n";
    if (std::holds_alternative<CellNone>(cd)) {
        std::cout << "    None\n";
    } else if (auto *b = std::get_if<CellByte>(&cd)) {
        std::cout << "    Byte(" << static_cast<int>(b->value) << ")\n";
    }
}

/*******************************************************************************
 * Default
 ******************************************************************************/

Engine Engine::give_default() {
    Engine e;
    e.ctx.cells.count = CELLS;
    return e;
}

/*******************************************************************************
 * Status accessors
 ******************************************************************************/

void Engine::print_init_status() const {
    std::cout << "\n>>>\n";
    print_control(ctl);
    std::cout << "\n";
    print_data(ctx);
    std::cout << "\n";
}

void Engine::print_running_status(const CellData &efx) const {
    std::cout << "\n>>>\n";
    print_control(ctl);
    std::cout << "\n";
    print_cell_data(efx);
    std::cout << "\n";
    print_data(ctx);
    std::cout << "<<<\n";
}

void Engine::print_shutdown_status() const {
    std::cout << "\n>>>\n";
    print_control(ctl);
    std::cout << "\n";
    print_data(ctx);
    std::cout << "\n";
}

/*******************************************************************************
 * Engine run
 ******************************************************************************/

int Engine::try_run_engine() {
    print_init_status();

    auto current_thread = ProgramThread::build_tasks(
        std::nullopt,
        std::array<Cell, CELLS>{{
            {0, Task::Default},
            {1, Task::DoubleValue},
        }},
        std::nullopt
    );

    ctl.state = State::Halt;
    print_init_status();

    ctl.state = State::Idle;
    print_init_status();

    ctl.state = State::Running;
    print_init_status();

    for (;;) {
        switch (ctl.state) {

            case State::Running: {
                auto effect = current_thread.step(ctx);
                ctx.activity = effect.activity;

                if (ctl.mode == Mode::Debug) {
                    print_running_status(*effect.handoff);
                }

                if (effect.finished) {
                    ctl.state = State::Shutdown;
                    ctx.activity = ActivityInfo{};
                    print_shutdown_status();
                    return 0;
                }
                break;
            }

            default: {
                ctl.state = State::Shutdown;
                print_shutdown_status();
                return 0;
            }
        }
    }
}

/*******************************************************************************
 * (2) Add custom engine implementations here
 ******************************************************************************/

} // namespace rca

/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C++ Variant
 * Engine
 *
 * Micro-kernel space (Loop Engine privilege only):
 * Apply returned outputs to ctx.
 ******************************************************************************/

#ifndef RCA_ENGINE_HPP
#define RCA_ENGINE_HPP

#include "data.hpp"
#include "control.hpp"
#include "cell.hpp"
#include "thread.hpp"

namespace rca {

/*******************************************************************************
 * (1) Engine
 ******************************************************************************/

/* Status: FREEZE */
class Engine {
public:
    static Engine give_default();

    void print_init_status() const;
    void print_running_status(const CellData &efx) const;
    void print_shutdown_status() const;

    int try_run_engine();

    DataPlane    ctx;
    ControlPlane ctl;
    SystemData   sys;
};

/*******************************************************************************
 * (2) Add custom engine classes/functions here
 ******************************************************************************/

} // namespace rca

#endif /* RCA_ENGINE_HPP */

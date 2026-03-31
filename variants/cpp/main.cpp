/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C++ Variant
 * Author: Gavin Walters
 * Created: 2026-03-06
 *
 * Description:
 * Linear Sequential Runtime System
 *
 * Workflow:
 * Data -> Constraints -> Cells -> Threads -> Engine
 ******************************************************************************/

#include "rca/engine.hpp"

/*******************************************************************************
 * Runtime Engine
 ******************************************************************************/

int main() {
    auto engine = rca::Engine::give_default();
    return engine.try_run_engine();
}

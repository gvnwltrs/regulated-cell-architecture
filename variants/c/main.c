/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C Variant
 * Author: Gavin Walters
 * Created: 2026-03-06
 *
 * Description:
 * Linear Sequential Runtime System
 *
 * Workflow:
 * Data -> Constraints -> Cells -> Threads -> Engine
 ******************************************************************************/

#include "rca/engine.h"

/*******************************************************************************
 * Runtime Engine
 ******************************************************************************/

int main(void) {
    Engine engine;
    engine_default(&engine);
    return engine_run(&engine);
}

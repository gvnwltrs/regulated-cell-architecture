/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C Variant
 * Engine
 *
 * Micro-kernel space (Loop Engine privilege only):
 * Apply returned outputs to ctx.
 ******************************************************************************/

#ifndef RCA_ENGINE_H
#define RCA_ENGINE_H

#include "data.h"
#include "control.h"
#include "cell.h"
#include "thread.h"

/*******************************************************************************
 * (1) Engine
 ******************************************************************************/

/* Status: FREEZE */
typedef struct {
    DataPlane    ctx;
    ControlPlane ctl;
    SystemData   sys;
} Engine;

void engine_default(Engine *engine);
void engine_print_init_status(const Engine *engine);
void engine_print_running_status(const Engine *engine, const CellData *efx);
void engine_print_shutdown_status(const Engine *engine);

/* Returns 0 on success, -1 on error */
int engine_run(Engine *engine);

/*******************************************************************************
 * (2) Add custom engine functions here
 ******************************************************************************/

#endif /* RCA_ENGINE_H */

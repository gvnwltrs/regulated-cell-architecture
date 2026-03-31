/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C Variant
 * Engine Implementation
 ******************************************************************************/

#include "engine.h"
#include <stdio.h>
#include <string.h>

/*******************************************************************************
 * Status printing helpers
 ******************************************************************************/

static const char *state_name(State s) {
    switch (s) {
        case STATE_INIT:     return "Init";
        case STATE_IDLE:     return "Idle";
        case STATE_RUNNING:  return "Running";
        case STATE_HALT:     return "Halt";
        case STATE_FAILURE:  return "Failure";
        case STATE_SHUTDOWN: return "Shutdown";
    }
    return "Unknown";
}

static const char *mode_name(Mode m) {
    switch (m) {
        case MODE_NONE:  return "None";
        case MODE_DEBUG: return "Debug";
    }
    return "Unknown";
}

static void print_control(const ControlPlane *ctl) {
    printf("  Control:\n");
    printf("    state: %s\n", state_name(ctl->state));
    printf("    mode:  %s\n", mode_name(ctl->mode));
}

static void print_data(const DataPlane *dp) {
    printf("  Data:\n");
    printf("    cells.count: %zu\n", dp->cells.count);
    printf("    activity:    \"%s\"\n", dp->activity.description);
}

static void print_cell_data(const CellData *cd) {
    printf("  Effect:\n");
    switch (cd->tag) {
        case CELL_DATA_NONE:
            printf("    None\n");
            break;
        case CELL_DATA_BYTE:
            printf("    Byte(%u)\n", cd->byte_val);
            break;
    }
}

/*******************************************************************************
 * Default
 ******************************************************************************/

void engine_default(Engine *engine) {
    data_plane_default(&engine->ctx);
    engine->ctx.cells.count = CELLS;
    control_plane_default(&engine->ctl);
    system_data_default(&engine->sys);
}

/*******************************************************************************
 * Status accessors
 ******************************************************************************/

void engine_print_init_status(const Engine *engine) {
    printf("\n>>>\n");
    print_control(&engine->ctl);
    printf("\n");
    print_data(&engine->ctx);
    printf("\n");
}

void engine_print_running_status(const Engine *engine, const CellData *efx) {
    printf("\n>>>\n");
    print_control(&engine->ctl);
    printf("\n");
    print_cell_data(efx);
    printf("\n");
    print_data(&engine->ctx);
    printf("<<<\n");
}

void engine_print_shutdown_status(const Engine *engine) {
    printf("\n>>>\n");
    print_control(&engine->ctl);
    printf("\n");
    print_data(&engine->ctx);
    printf("\n");
}

/*******************************************************************************
 * Engine run
 ******************************************************************************/

int engine_run(Engine *engine) {
    engine_print_init_status(engine);

    Cell tasks[CELLS] = {
        { .id = 0, .task = TASK_DEFAULT },
        { .id = 1, .task = TASK_DOUBLE_VALUE },
    };

    ProgramThread current_thread;
    program_thread_build(&current_thread, tasks, NULL);

    engine->ctl.state = STATE_HALT;
    engine_print_init_status(engine);

    engine->ctl.state = STATE_IDLE;
    engine_print_init_status(engine);

    engine->ctl.state = STATE_RUNNING;
    engine_print_init_status(engine);

    for (;;) {
        switch (engine->ctl.state) {

            case STATE_RUNNING: {
                Effect effect;
                int rc = program_thread_step(&current_thread, &engine->ctx, &effect);
                if (rc != 0) {
                    return rc;
                }

                engine->ctx.activity = effect.activity;

                if (engine->ctl.mode == MODE_DEBUG) {
                    engine_print_running_status(engine, effect.handoff);
                }

                if (effect.finished) {
                    engine->ctl.state = STATE_SHUTDOWN;
                    activity_info_default(&engine->ctx.activity);
                    engine_print_shutdown_status(engine);
                    return 0;
                }
                break;
            }

            default: {
                engine->ctl.state = STATE_SHUTDOWN;
                engine_print_shutdown_status(engine);
                return 0;
            }
        }
    }
}

/*******************************************************************************
 * (2) Add custom engine implementations here
 ******************************************************************************/

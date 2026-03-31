/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C Variant
 * Thread Implementation
 ******************************************************************************/

#include "thread.h"
#include <stdio.h>
#include <string.h>

static const char *task_name(Task t) {
    switch (t) {
        case TASK_DEFAULT:      return "Default";
        case TASK_DOUBLE_VALUE: return "DoubleValue";
    }
    return "Unknown";
}

void program_thread_build(ProgramThread *pt, const Cell *tasks, const CellData *handoff) {
    pt->counter = 0;

    if (tasks) {
        memcpy(pt->tasks, tasks, sizeof(Cell) * CELLS);
    } else {
        cell_defaults(pt->tasks);
    }

    if (handoff) {
        pt->handoff = *handoff;
    } else {
        cell_data_default(&pt->handoff);
    }
}

bool program_thread_is_finished(const ProgramThread *pt) {
    return pt->counter >= CELLS;
}

int program_thread_step(ProgramThread *pt, const DataPlane *ctx, Effect *effect) {
    /* Build activity description */
    snprintf(effect->activity.description, sizeof(effect->activity.description),
             "%s", task_name(pt->tasks[pt->counter].task));

    /* Handoff transfer: take current handoff, pass to cell, store result back */
    CellData handoff_transfer = pt->handoff;
    cell_data_default(&pt->handoff);

    int rc = cell_execute(&pt->tasks[pt->counter], ctx, handoff_transfer, &pt->handoff);
    if (rc != 0) {
        return rc;
    }

    pt->counter++;

    effect->finished = program_thread_is_finished(pt);
    effect->handoff  = &pt->handoff;

    return 0;
}

/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C Variant
 * Thread
 ******************************************************************************/

#ifndef RCA_THREAD_H
#define RCA_THREAD_H

#include <stdbool.h>
#include "data.h"
#include "cell.h"

/*******************************************************************************
 * (1) Threads
 ******************************************************************************/

/* Status: MUTABLE */
#define THREADS 1

/* Status: MUTABLE */
#define EXECUTION_THRESHOLD 1.0  /* Units in ms */

/* Status: MUTABLE */
typedef struct {
    ActivityInfo activity;
    const CellData *handoff;
    bool finished;
} Effect;

/* Status: MUTABLE */
typedef struct {
    size_t   counter;
    Cell     tasks[CELLS];
    CellData handoff;
} ProgramThread;

void program_thread_build(ProgramThread *pt, const Cell *tasks, const CellData *handoff);

/* Returns 0 on success, -1 on error */
int program_thread_step(ProgramThread *pt, const DataPlane *ctx, Effect *effect);

bool program_thread_is_finished(const ProgramThread *pt);

#endif /* RCA_THREAD_H */

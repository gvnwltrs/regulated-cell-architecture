/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C Variant
 * Cell
 *
 * Each cell can access the system context/data but cannot modify it.
 * Only the engine has authority to modify state.
 * Each cell HAS-A task.
 ******************************************************************************/

#ifndef RCA_CELL_H
#define RCA_CELL_H

#include <stddef.h>
#include <stdint.h>
#include "data.h"

/* Status: MUTABLE */
#define CELLS 2

/*******************************************************************************
 * (1) Cell Data
 ******************************************************************************/

/* Status: MUTABLE */
typedef enum {
    CELL_DATA_NONE,
    CELL_DATA_BYTE,
    /* Add cell data types here */
} CellDataTag;

typedef struct {
    CellDataTag tag;
    union {
        uint8_t byte_val;
    };
} CellData;

/*******************************************************************************
 * (2) Tasks
 ******************************************************************************/

/* Status: MUTABLE */
typedef enum {
    TASK_DEFAULT,
    TASK_DOUBLE_VALUE,
    /* Add tasks here */
} Task;

/*******************************************************************************
 * (3) Cell
 ******************************************************************************/

/* Status: FREEZE */
typedef struct {
    size_t id;
    Task   task;
} Cell;

void cell_data_default(CellData *cd);
void cell_defaults(Cell cells[CELLS]);

/* Returns 0 on success, -1 on error */
int cell_execute(Cell *cell, const DataPlane *ctx, CellData handoff, CellData *out);

/* Returns 0 on success, -1 on error */
int task_access(Task task, const DataPlane *ctx, CellData handoff, CellData *out);

/* Add task procedures here */

#endif /* RCA_CELL_H */

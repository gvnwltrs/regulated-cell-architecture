/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C Variant
 * Cell Implementation
 ******************************************************************************/

#include "cell.h"

void cell_data_default(CellData *cd) {
    cd->tag = CELL_DATA_NONE;
    cd->byte_val = 0;
}

void cell_defaults(Cell cells[CELLS]) {
    for (size_t i = 0; i < CELLS; i++) {
        cells[i].id   = i;
        cells[i].task = TASK_DEFAULT;
    }
}

int cell_execute(Cell *cell, const DataPlane *ctx, CellData handoff, CellData *out) {
    return task_access(cell->task, ctx, handoff, out);
}

/*******************************************************************************
 * Task Procedures
 ******************************************************************************/

/* Status: MUTABLE */
int task_access(Task task, const DataPlane *ctx, CellData handoff, CellData *out) {
    (void)ctx;

    switch (task) {

        case TASK_DEFAULT: {
            out->tag = CELL_DATA_BYTE;
            out->byte_val = 0x2A; /* 42 */
            return 0;
        }

        case TASK_DOUBLE_VALUE: {
            if (handoff.tag == CELL_DATA_BYTE) {
                out->tag = CELL_DATA_BYTE;
                out->byte_val = handoff.byte_val + handoff.byte_val; /* 84 */
            } else {
                *out = handoff;
            }
            return 0;
        }

        /* Add task procedures here */

    }

    *out = handoff;
    return 0;
}

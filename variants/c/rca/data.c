/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C Variant
 * Data Plane Implementation
 ******************************************************************************/

#include "data.h"
#include <string.h>

void activity_info_default(ActivityInfo *ai) {
    memset(ai->description, 0, sizeof(ai->description));
}

void display_info_default(DisplayInfo *di) {
    memset(di, 0, sizeof(*di));
}

void system_data_default(SystemData *sd) {
    memset(sd->description, 0, sizeof(sd->description));
}

void data_plane_default(DataPlane *dp) {
    dp->config   = CONFIG_DATA_NONE;
    dp->read_io  = READ_DATA_NONE;
    dp->write_io = WRITE_DATA_NONE;
    dp->perf     = PERF_DATA_NONE;
    dp->logs.tag = LOG_DATA_NONE;
    memset(dp->logs.entry, 0, sizeof(dp->logs.entry));
    memset(dp->logs.date, 0, sizeof(dp->logs.date));
    dp->cells.count = 0;
    activity_info_default(&dp->activity);
    display_info_default(&dp->display);
}

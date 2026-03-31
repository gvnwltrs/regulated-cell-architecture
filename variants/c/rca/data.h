/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C Variant
 * Data Plane
 *
 * Establish data endpoints.
 * Establish & confirm complete data.
 ******************************************************************************/

#ifndef RCA_DATA_H
#define RCA_DATA_H

#include <stddef.h>
#include <stdint.h>

/*******************************************************************************
 * Apex data models
 ******************************************************************************/

/* Status: MUTABLE */
typedef enum {
    CONFIG_DATA_NONE,
} ConfigData;

/* Status: MUTABLE */
typedef enum {
    READ_DATA_NONE,
} ReadData;

/* Status: MUTABLE */
typedef enum {
    WRITE_DATA_NONE,
} WriteData;

/* Status: MUTABLE */
typedef enum {
    PERF_DATA_NONE,
} PerfData;

/* Status: MUTABLE */
typedef enum {
    LOG_DATA_NONE,
    LOG_DATA_SESSION,
} LogDataTag;

typedef struct {
    LogDataTag tag;
    /* Valid when tag == LOG_DATA_SESSION */
    char entry[256];
    char date[64];
} LogData;

/* Status: FREEZE */
typedef struct {
    size_t count;
} CellInfo;

/* Status: FREEZE */
typedef struct {
    char description[256];
} ActivityInfo;

/* Status: FREEZE */
typedef struct {
    char title[256];
    char body[256];
    char status[256];
} DisplayInfo;

/* Status: FREEZE */
typedef struct {
    char description[256];
} SystemData;

/*******************************************************************************
 * Data Plane
 ******************************************************************************/

/* Status: FREEZE */
typedef struct {
    ConfigData config;      /* Init state: initialization & configuration */
    ReadData   read_io;     /* Running state: import data */
    WriteData  write_io;    /* Running state: export data */
    PerfData   perf;        /* Running state: system information */
    LogData    logs;        /* Running/Failure/Shutdown: event logs */
    CellInfo   cells;       /* Running state: cell metadata */
    ActivityInfo activity;  /* Running state: current task details */
    DisplayInfo  display;   /* Running state: terminal/display output */
} DataPlane;

/*******************************************************************************
 * Defaults
 ******************************************************************************/

void data_plane_default(DataPlane *dp);
void activity_info_default(ActivityInfo *ai);
void display_info_default(DisplayInfo *di);
void system_data_default(SystemData *sd);

/*******************************************************************************
 * Add custom data models here
 ******************************************************************************/

#endif /* RCA_DATA_H */

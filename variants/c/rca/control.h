/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C Variant
 * Control Plane
 ******************************************************************************/

#ifndef RCA_CONTROL_H
#define RCA_CONTROL_H

/*******************************************************************************
 * (1) States
 ******************************************************************************/

/* Status: FREEZE */
typedef enum {
    STATE_INIT,
    STATE_IDLE,
    STATE_RUNNING,
    STATE_HALT,
    STATE_FAILURE,
    STATE_SHUTDOWN,
} State;

/*******************************************************************************
 * (2) Modes
 ******************************************************************************/

/* Status: MUTABLE */
typedef enum {
    MODE_NONE,
    MODE_DEBUG,
} Mode;

/*******************************************************************************
 * (3) Events
 ******************************************************************************/

/* Status: MUTABLE */
typedef enum {
    EVENT_NONE,
} Event;

/*******************************************************************************
 * Control Plane
 ******************************************************************************/

/* Status: FREEZE */
typedef struct {
    State state;
    Mode  mode;
    Event event;
} ControlPlane;

void control_plane_default(ControlPlane *cp);

#endif /* RCA_CONTROL_H */

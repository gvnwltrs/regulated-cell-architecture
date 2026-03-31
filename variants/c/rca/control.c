/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C Variant
 * Control Plane Implementation
 ******************************************************************************/

#include "control.h"

void control_plane_default(ControlPlane *cp) {
    cp->state = STATE_INIT;
    cp->mode  = MODE_DEBUG;
    cp->event = EVENT_NONE;
}

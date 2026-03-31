///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Java Variant
// Thread
///////////////////////////////////////////////////////////////////////////////

package rca;

///////////////////////////////////////////////////////////////////////////////
// (1) Threads
///////////////////////////////////////////////////////////////////////////////

// Status: MUTABLE
record Effect(ActivityInfo activity, CellData handoff, boolean finished) {}

// Status: MUTABLE
public class RcaThread {

    static final int NUM_THREADS = 1;
    static final double EXECUTION_THRESHOLD = 1.0; // Units in ms

    int counter;
    Cell[] tasks;
    CellData handoff;

    RcaThread(Cell[] tasks, CellData handoff) {
        this.counter = 0;
        this.tasks   = tasks != null ? tasks : Cell.defaults();
        this.handoff = handoff != null ? handoff : new CellData.None();
    }

    static RcaThread buildTasks(Cell[] tasks, CellData handoff) {
        return new RcaThread(tasks, handoff);
    }

    boolean isFinished() {
        return counter >= tasks.length;
    }

    Effect step(Data ctx) {
        var activity = new ActivityInfo(tasks[counter].task.displayName());

        // Handoff transfer: take current, pass to cell, store result back
        CellData handoffTransfer = this.handoff;
        this.handoff = new CellData.None();

        this.handoff = tasks[counter].execute(ctx, handoffTransfer);
        counter++;

        boolean finished = isFinished();

        return new Effect(activity, this.handoff, finished);
    }
}

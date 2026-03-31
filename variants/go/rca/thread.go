///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Go Variant
// Thread
///////////////////////////////////////////////////////////////////////////////

package rca

///////////////////////////////////////////////////////////////////////////////
// (1) Threads
///////////////////////////////////////////////////////////////////////////////

// Status: MUTABLE
const NumThreads = 1

// Status: MUTABLE
const ExecutionThreshold = 1.0 // Units in ms

// Status: MUTABLE
type Effect struct {
	Activity ActivityInfo
	Handoff  CellData
	Finished bool
}

// Status: MUTABLE
type ProgramThread struct {
	Counter int
	Tasks   [NumCells]Cell
	Handoff CellData
}

func BuildTasks(tasks *[NumCells]Cell, handoff *CellData) ProgramThread {
	pt := ProgramThread{}

	if tasks != nil {
		pt.Tasks = *tasks
	} else {
		pt.Tasks = CellDefaults()
	}

	if handoff != nil {
		pt.Handoff = *handoff
	} else {
		pt.Handoff = CellNone()
	}

	return pt
}

func (pt *ProgramThread) IsFinished() bool {
	return pt.Counter >= len(pt.Tasks)
}

func (pt *ProgramThread) Step(ctx *DataPlane) Effect {
	activity := ActivityInfo{
		Description: pt.Tasks[pt.Counter].Task.String(),
	}

	// Handoff transfer: take current, pass to cell, store result back
	handoffTransfer := pt.Handoff
	pt.Handoff = CellNone()

	pt.Handoff = pt.Tasks[pt.Counter].Execute(ctx, handoffTransfer)
	pt.Counter++

	finished := pt.IsFinished()

	return Effect{
		Activity: activity,
		Handoff:  pt.Handoff,
		Finished: finished,
	}
}

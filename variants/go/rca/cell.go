///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Go Variant
// Cell
//
// Each cell can access the system context/data but cannot modify it.
// Only the engine has authority to modify state.
// Each cell HAS-A task.
///////////////////////////////////////////////////////////////////////////////

package rca

// Status: MUTABLE
const NumCells = 2

///////////////////////////////////////////////////////////////////////////////
// (1) Cell Data
///////////////////////////////////////////////////////////////////////////////

// Status: MUTABLE
type CellDataTag int

const (
	CellDataNone CellDataTag = iota
	CellDataByte
	// Add cell data types here
)

type CellData struct {
	Tag   CellDataTag
	Value uint8
}

func CellNone() CellData {
	return CellData{Tag: CellDataNone}
}

func CellByte(value uint8) CellData {
	return CellData{Tag: CellDataByte, Value: value}
}

///////////////////////////////////////////////////////////////////////////////
// (2) Tasks
///////////////////////////////////////////////////////////////////////////////

// Status: MUTABLE
type Task int

const (
	TaskDefault Task = iota
	TaskDoubleValue
	// Add tasks here
)

func (t Task) String() string {
	switch t {
	case TaskDefault:
		return "Default"
	case TaskDoubleValue:
		return "DoubleValue"
	}
	return "Unknown"
}

// Status: MUTABLE
func TaskAccess(task Task, ctx *DataPlane, handoff CellData) CellData {
	switch task {

	case TaskDefault:
		return CellByte(0x2A) // 42

	case TaskDoubleValue:
		if handoff.Tag == CellDataByte {
			return CellByte(handoff.Value + handoff.Value) // 84
		}
		return handoff

	// Add task procedures here

	}

	return handoff
}

///////////////////////////////////////////////////////////////////////////////
// (3) Cell
///////////////////////////////////////////////////////////////////////////////

// Status: FREEZE
type Cell struct {
	ID   int
	Task Task
}

func (c *Cell) Execute(ctx *DataPlane, handoff CellData) CellData {
	return TaskAccess(c.Task, ctx, handoff)
}

func CellDefaults() [NumCells]Cell {
	var cells [NumCells]Cell
	for i := 0; i < NumCells; i++ {
		cells[i] = Cell{ID: i, Task: TaskDefault}
	}
	return cells
}

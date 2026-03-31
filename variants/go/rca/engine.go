///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Go Variant
// Engine
//
// Micro-kernel space (Loop Engine privilege only):
// Apply returned outputs to ctx.
///////////////////////////////////////////////////////////////////////////////

package rca

import "fmt"

///////////////////////////////////////////////////////////////////////////////
// Status printing helpers
///////////////////////////////////////////////////////////////////////////////

func printControl(ctl *ControlPlane) {
	fmt.Println("  Control:")
	fmt.Printf("    state: %s\n", ctl.State)
	fmt.Printf("    mode:  %s\n", ctl.Mode)
}

func printData(dp *DataPlane) {
	fmt.Println("  Data:")
	fmt.Printf("    cells.count: %d\n", dp.Cells.Count)
	fmt.Printf("    activity:    \"%s\"\n", dp.Activity.Description)
}

func printCellData(cd *CellData) {
	fmt.Println("  Effect:")
	switch cd.Tag {
	case CellDataNone:
		fmt.Println("    None")
	case CellDataByte:
		fmt.Printf("    Byte(%d)\n", cd.Value)
	}
}

///////////////////////////////////////////////////////////////////////////////
// (1) Engine
///////////////////////////////////////////////////////////////////////////////

// Status: FREEZE
type Engine struct {
	Ctx DataPlane
	Ctl ControlPlane
	Sys SystemData
}

func GiveDefault() Engine {
	return Engine{
		Ctx: DefaultDataPlane(NumCells),
		Ctl: DefaultControlPlane(),
	}
}

func (e *Engine) PrintInitStatus() {
	fmt.Println("\n>>>")
	printControl(&e.Ctl)
	fmt.Println()
	printData(&e.Ctx)
	fmt.Println()
}

func (e *Engine) PrintRunningStatus(efx *CellData) {
	fmt.Println("\n>>>")
	printControl(&e.Ctl)
	fmt.Println()
	printCellData(efx)
	fmt.Println()
	printData(&e.Ctx)
	fmt.Println("<<<")
}

func (e *Engine) PrintShutdownStatus() {
	fmt.Println("\n>>>")
	printControl(&e.Ctl)
	fmt.Println()
	printData(&e.Ctx)
	fmt.Println()
}

///////////////////////////////////////////////////////////////////////////////
// Engine run
///////////////////////////////////////////////////////////////////////////////

func (e *Engine) TryRunEngine() int {
	e.PrintInitStatus()

	tasks := [NumCells]Cell{
		{ID: 0, Task: TaskDefault},
		{ID: 1, Task: TaskDoubleValue},
	}
	currentThread := BuildTasks(&tasks, nil)

	e.Ctl.State = StateHalt
	e.PrintInitStatus()

	e.Ctl.State = StateIdle
	e.PrintInitStatus()

	e.Ctl.State = StateRunning
	e.PrintInitStatus()

	for {
		switch e.Ctl.State {
		case StateRunning:
			effect := currentThread.Step(&e.Ctx)
			e.Ctx.Activity = effect.Activity

			if e.Ctl.Mode == ModeDebug {
				e.PrintRunningStatus(&effect.Handoff)
			}

			if effect.Finished {
				e.Ctl.State = StateShutdown
				e.Ctx.Activity = ActivityInfo{}
				e.PrintShutdownStatus()
				return 0
			}

		default:
			e.Ctl.State = StateShutdown
			e.PrintShutdownStatus()
			return 0
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// (2) Add custom engine functions here
///////////////////////////////////////////////////////////////////////////////

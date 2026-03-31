///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Java Variant
// Cell
//
// Each cell can access the system context/data but cannot modify it.
// Only the engine has authority to modify state.
// Each cell HAS-A task.
///////////////////////////////////////////////////////////////////////////////

package rca;

///////////////////////////////////////////////////////////////////////////////
// (1) Cell Data
///////////////////////////////////////////////////////////////////////////////

// Status: MUTABLE
sealed interface CellData {
    record None() implements CellData {}
    record Byte(int value) implements CellData {}
    // Add cell data types here
}

///////////////////////////////////////////////////////////////////////////////
// (2) Tasks
///////////////////////////////////////////////////////////////////////////////

// Status: MUTABLE
enum Task {
    DEFAULT, DOUBLE_VALUE;
    // Add tasks here

    String displayName() {
        return switch (this) {
            case DEFAULT      -> "Default";
            case DOUBLE_VALUE -> "DoubleValue";
        };
    }

    // Status: MUTABLE
    CellData access(Data ctx, CellData handoff) {
        return switch (this) {
            case DEFAULT -> new CellData.Byte(0x2A); // 42

            case DOUBLE_VALUE -> {
                if (handoff instanceof CellData.Byte b) {
                    yield new CellData.Byte((b.value() + b.value()) & 0xFF); // 84
                }
                yield handoff;
            }

            // Add task procedures here
        };
    }
}

///////////////////////////////////////////////////////////////////////////////
// (3) Cell
///////////////////////////////////////////////////////////////////////////////

// Status: FREEZE
public class Cell {

    static final int NUM_CELLS = 2;

    final int id;
    final Task task;

    Cell(int id, Task task) {
        this.id = id;
        this.task = task;
    }

    CellData execute(Data ctx, CellData handoff) {
        return task.access(ctx, handoff);
    }

    static Cell[] defaults() {
        Cell[] cells = new Cell[NUM_CELLS];
        for (int i = 0; i < NUM_CELLS; i++) {
            cells[i] = new Cell(i, Task.DEFAULT);
        }
        return cells;
    }
}

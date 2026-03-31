///////////////////////////////////////////////////////////////////////////////
// Regulated Cell Architecture (RCA) - Java Variant
// Engine
//
// Micro-kernel space (Loop Engine privilege only):
// Apply returned outputs to ctx.
///////////////////////////////////////////////////////////////////////////////

package rca;

///////////////////////////////////////////////////////////////////////////////
// Status printing helpers
///////////////////////////////////////////////////////////////////////////////

class Printer {
    static void printControl(Control ctl) {
        System.out.println("  Control:");
        System.out.println("    state: " + ctl.state.displayName());
        System.out.println("    mode:  " + ctl.mode.displayName());
    }

    static void printData(Data dp) {
        System.out.println("  Data:");
        System.out.println("    cells.count: " + dp.cells.count());
        System.out.println("    activity:    \"" + dp.activity.description() + "\"");
    }

    static void printCellData(CellData cd) {
        System.out.println("  Effect:");
        switch (cd) {
            case CellData.None n   -> System.out.println("    None");
            case CellData.Byte b   -> System.out.println("    Byte(" + b.value() + ")");
        }
    }
}

///////////////////////////////////////////////////////////////////////////////
// (1) Engine
///////////////////////////////////////////////////////////////////////////////

// Status: FREEZE
public class Engine {

    Data ctx;
    Control ctl;
    SystemData sys;

    Engine(Data ctx, Control ctl, SystemData sys) {
        this.ctx = ctx;
        this.ctl = ctl;
        this.sys = sys;
    }

    public static Engine giveDefault() {
        return new Engine(
            new Data(Cell.NUM_CELLS),
            new Control(),
            SystemData.defaults()
        );
    }

    void printInitStatus() {
        System.out.println("\n>>>");
        Printer.printControl(ctl);
        System.out.println();
        Printer.printData(ctx);
        System.out.println();
    }

    void printRunningStatus(CellData efx) {
        System.out.println("\n>>>");
        Printer.printControl(ctl);
        System.out.println();
        Printer.printCellData(efx);
        System.out.println();
        Printer.printData(ctx);
        System.out.println("<<<");
    }

    void printShutdownStatus() {
        System.out.println("\n>>>");
        Printer.printControl(ctl);
        System.out.println();
        Printer.printData(ctx);
        System.out.println();
    }

    ///////////////////////////////////////////////////////////////////////////
    // Engine run
    ///////////////////////////////////////////////////////////////////////////

    public int tryRunEngine() {
        printInitStatus();

        var currentThread = RcaThread.buildTasks(
            new Cell[] {
                new Cell(0, Task.DEFAULT),
                new Cell(1, Task.DOUBLE_VALUE),
            },
            null
        );

        ctl.state = State.HALT;
        printInitStatus();

        ctl.state = State.IDLE;
        printInitStatus();

        ctl.state = State.RUNNING;
        printInitStatus();

        while (true) {
            switch (ctl.state) {
                case RUNNING -> {
                    var effect = currentThread.step(ctx);
                    ctx.activity = effect.activity();

                    if (ctl.mode == Mode.DEBUG) {
                        printRunningStatus(effect.handoff());
                    }

                    if (effect.finished()) {
                        ctl.state = State.SHUTDOWN;
                        ctx.activity = ActivityInfo.defaults();
                        printShutdownStatus();
                        return 0;
                    }
                }

                default -> {
                    ctl.state = State.SHUTDOWN;
                    printShutdownStatus();
                    return 0;
                }
            }
        }
    }

    ///////////////////////////////////////////////////////////////////////////
    // (2) Add custom engine methods here
    ///////////////////////////////////////////////////////////////////////////
}

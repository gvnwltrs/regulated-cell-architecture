/*******************************************************************************
 * Regulated Cell Architecture (RCA) - C++ Variant
 * Data Plane
 *
 * Establish data endpoints.
 * Establish & confirm complete data.
 ******************************************************************************/

#ifndef RCA_DATA_HPP
#define RCA_DATA_HPP

#include <cstddef>
#include <cstdint>
#include <string>
#include <variant>

/*******************************************************************************
 * Apex data models
 ******************************************************************************/

namespace rca {

/* Status: MUTABLE */
enum class ConfigData { None };

/* Status: MUTABLE */
enum class ReadData { None };

/* Status: MUTABLE */
enum class WriteData { None };

/* Status: MUTABLE */
enum class PerfData { None };

/* Status: MUTABLE */
struct LogNone {};

struct LogSession {
    std::string entry;
    std::string date;
};

using LogData = std::variant<LogNone, LogSession>;

/* Status: FREEZE */
struct CellInfo {
    std::size_t count{0};
};

/* Status: FREEZE */
struct ActivityInfo {
    std::string description;
};

/* Status: FREEZE */
struct DisplayInfo {
    std::string title;
    std::string body;
    std::string status;
};

/* Status: FREEZE */
struct SystemData {
    std::string description;
};

/*******************************************************************************
 * Data Plane
 ******************************************************************************/

/* Status: FREEZE */
struct DataPlane {
    ConfigData   config{ConfigData::None};      /* Init state: initialization & configuration */
    ReadData     read_io{ReadData::None};        /* Running state: import data */
    WriteData    write_io{WriteData::None};      /* Running state: export data */
    PerfData     perf{PerfData::None};           /* Running state: system information */
    LogData      logs{LogNone{}};                /* Running/Failure/Shutdown: event logs */
    CellInfo     cells;                          /* Running state: cell metadata */
    ActivityInfo activity;                       /* Running state: current task details */
    DisplayInfo  display;                        /* Running state: terminal/display output */
};

} // namespace rca

#endif /* RCA_DATA_HPP */

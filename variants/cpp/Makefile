CXX     = g++
CXXFLAGS = -Wall -Wextra -Wpedantic -std=c++17
TARGET  = rca_run

SRCS = main.cpp \
       rca/cell.cpp \
       rca/thread.cpp \
       rca/engine.cpp

OBJS = $(SRCS:.cpp=.o)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

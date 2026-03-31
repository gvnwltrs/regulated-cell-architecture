CC      = gcc
CFLAGS  = -Wall -Wextra -Wpedantic -std=c17
TARGET  = rca_run

SRCS = main.c \
       rca/data.c \
       rca/control.c \
       rca/cell.c \
       rca/thread.c \
       rca/engine.c

OBJS = $(SRCS:.c=.o)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)

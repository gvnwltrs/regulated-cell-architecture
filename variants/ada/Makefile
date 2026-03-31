TARGET = main

.PHONY: all clean

all: $(TARGET)

$(TARGET):
	mkdir -p obj
	gprbuild -P rca.gpr

clean:
	gprclean -P rca.gpr
	rm -rf obj

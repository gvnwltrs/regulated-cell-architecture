TARGET = rca_run

.PHONY: all clean run

all: $(TARGET)

$(TARGET):
	sbcl --noinform --non-interactive \
		--load main.lisp \
		--eval '(sb-ext:save-lisp-and-die "$(TARGET)" :toplevel #'"'"'main :executable t)'

run:
	sbcl --script main.lisp

clean:
	rm -f $(TARGET)

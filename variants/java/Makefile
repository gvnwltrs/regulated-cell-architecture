TARGET = Main

.PHONY: all clean run

all:
	javac -d out Main.java rca/*.java

run: all
	java -cp out Main

clean:
	rm -rf out

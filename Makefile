CC=gcc
ARGS=-O3

bin/analyze: src/analyze.c
	@mkdir -p bin
	$(CC) $(ARGS) -o bin/analyze src/analyze.c

setup:
	sudo apt install picocom
	sudo usermod -a -G dialout ${USER}
	@echo Log out and log back in for the changes to take effect.

run: bin/analyze
	picocom -b 115200 -r -l /dev/ttyUSB1 | bin/analyze

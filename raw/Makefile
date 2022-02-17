# An example that uses the Program Repository toolchain to build a simple
# "hello world example that does not use the standard libraries.
.PHONY: all
all: a.out
.PHONY: clean
clean:
	-rm -f main.o start.o a.out
.PHONY: distclean
distclean: clean
	-rm -f clang.db

a.out: main.o start.o
	rld -o $@ $^

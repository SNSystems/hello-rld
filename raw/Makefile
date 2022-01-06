CFLAGS = -O0 -target x86_64-pc-linux-gnu-repo

TICKETS = start.o main.o

.PHONY: all
all: a.out
.PHONY: clean
clean:
	-rm -f $(TICKETS) a.out
.PHONY: distclean
distclean: clean
	-rm -f clang.db

main.c: syscall.h
start.c: syscall.h

a.out: $(TICKETS)
	rld -o $@ $^

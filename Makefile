CFLAGS = -O0 -target x86_64-pc-linux-gnu-repo

%.o: %.c
	$(CC) -o $@ -c $(CFLAGS) $<

TICKETS = start.o main.o

.PHONY: all
all: a.out

.PHONY: clean
clean:
	-rm -f $(TICKETS) a.out
.PHONY: realclean
realclean: clean
	-rm -f clang.db

main.c: syscall.h
start.c: syscall.h

a.out: $(TICKETS)
	rld -o $@ $^

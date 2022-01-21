CFLAGS =                                  \
	-target x86_64-pc-linux-musl-repo \
	-O0

.PHONY: all
all:
	$(MAKE) clang.db
	$(MAKE) a.out

.PHONY: clean
clean:
	-rm -f main.o a.out

.PHONY: distclean
distclean: clean
	-rm -f clang.db

# Merge the repo containing the standard libraries. Ultimately, this
# will be automatic and incremental.
clang.db: /usr/lib/stdlib.repo
	cp $< $@

a.out: main.o
	$(CC) -o $@ -target x86_64-pc-linux-musl-repo main.o

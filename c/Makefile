MUSL = /usr/local/musl
# TODO: the target should be musl rather than gnu.
CFLAGS =                                 \
	-target x86_64-pc-linux-gnu-repo \
	-O0                              \
	-nostdinc                        \
	-isystem $(MUSL)/include

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

CRTI = $(MUSL)/lib/crt1.t $(MUSL)/lib/crt1_asm.t $(MUSL)/lib/crti.t
CRTN = $(MUSL)/lib/crtn.t

a.out: main.o
	../rld -o $@ $(CRTI) main.o $(MUSL)/lib/libc_repo.a $(CRTN)

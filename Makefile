MUSL = ./musl

CC = clang
CFLAGS = \
	-O0 \
	-target x86_64-pc-linux-gnu-repo \
	-nostdinc \
	-isystem "$(MUSL)/include"

%.o: %.c
	REPOFILE=clang.db $(CC) -o $@ -c $(CFLAGS) $<

TICKETS = main.o

.PHONY: all
all:
	$(MAKE) clang.db
	$(MAKE) a.out

.PHONY: clean
clean:
	-rm -f $(TICKETS) a.out
.PHONY: distclean
distclean: clean
	-rm -f musl.json clang.db

musl.json: $(MUSL)/lib/clang.db
	pstore-export $< > $@

clang.db: musl.json
	-rm -f $@
	pstore-import $@ $<

LIBC = \
	$(MUSL)/lib/libc_repo/__environ.t         \
	$(MUSL)/lib/libc_repo/__errno_location.t  \
	$(MUSL)/lib/libc_repo/__fpclassifyl.t     \
	$(MUSL)/lib/libc_repo/__init_tls.t        \
	$(MUSL)/lib/libc_repo/__lctrans.t         \
	$(MUSL)/lib/libc_repo/__libc_start_main.t \
	$(MUSL)/lib/libc_repo/__lock.t            \
	$(MUSL)/lib/libc_repo/__lockfile.t        \
	$(MUSL)/lib/libc_repo/__set_thread_area.t \
	$(MUSL)/lib/libc_repo/__signbitl.t        \
	$(MUSL)/lib/libc_repo/__stdio_close.t     \
	$(MUSL)/lib/libc_repo/__stdio_exit.t      \
	$(MUSL)/lib/libc_repo/__stdio_seek.t      \
	$(MUSL)/lib/libc_repo/__stdio_write.t     \
	$(MUSL)/lib/libc_repo/__stdout_write.t    \
	$(MUSL)/lib/libc_repo/__towrite.t         \
	$(MUSL)/lib/libc_repo/default_attr.t      \
	$(MUSL)/lib/libc_repo/defsysinfo.t        \
	$(MUSL)/lib/libc_repo/exit.t              \
	$(MUSL)/lib/libc_repo/frexpl.t            \
	$(MUSL)/lib/libc_repo/fwrite.t            \
	$(MUSL)/lib/libc_repo/libc.t              \
	$(MUSL)/lib/libc_repo/lseek.t             \
	$(MUSL)/lib/libc_repo/memchr.t            \
	$(MUSL)/lib/libc_repo/memcpy.t            \
	$(MUSL)/lib/libc_repo/memset.t            \
	$(MUSL)/lib/libc_repo/ofl.t               \
	$(MUSL)/lib/libc_repo/printf.t            \
	$(MUSL)/lib/libc_repo/stdout.t            \
	$(MUSL)/lib/libc_repo/strerror.t          \
	$(MUSL)/lib/libc_repo/strnlen.t           \
	$(MUSL)/lib/libc_repo/syscall_ret.t       \
	$(MUSL)/lib/libc_repo/vfprintf.t          \
	$(MUSL)/lib/libc_repo/wcrtomb.t           \
	$(MUSL)/lib/libc_repo/wctomb.t

a.out: $(TICKETS)
	rld -o $@ $(MUSL)/lib/crt1.t $(MUSL)/lib/crt1_asm.t $(MUSL)/lib/crti.t $^ $(LIBC) $(MUSL)/lib/crtn.t

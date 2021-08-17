MUSL = ./musl
CFLAGS =  -O0 -nostdinc -isystem "$(MUSL)/include"
TICKETS = main.o

%.o: %.c
	REPOFILE=clang.db $(CC) -o $@ -c $(CFLAGS) $<

.PHONY: all
all:
	$(MAKE) clang.db
	$(MAKE) a.out

.PHONY: clean
clean:
	-rm -f $(TICKETS) a.out

.PHONY: distclean
distclean: clean
	-rm -f clang.db

clang.db: $(MUSL)/lib/musl-prepo.json
	-rm -f $@
	pstore-import $@ $<

LIBC_T_DIR = $(MUSL)/lib/libc_repo
# libc ticket files
LIBC = \
	$(LIBC_T_DIR)/_Exit.t             \
	$(LIBC_T_DIR)/__environ.t         \
	$(LIBC_T_DIR)/__errno_location.t  \
	$(LIBC_T_DIR)/__fpclassifyl.t     \
	$(LIBC_T_DIR)/__init_tls.t        \
	$(LIBC_T_DIR)/__lctrans.t         \
	$(LIBC_T_DIR)/__libc_start_main.t \
	$(LIBC_T_DIR)/__lock.t            \
	$(LIBC_T_DIR)/__lockfile.t        \
	$(LIBC_T_DIR)/__set_thread_area.t \
	$(LIBC_T_DIR)/__signbitl.t        \
	$(LIBC_T_DIR)/__stdio_close.t     \
	$(LIBC_T_DIR)/__stdio_exit.t      \
	$(LIBC_T_DIR)/__stdio_seek.t      \
	$(LIBC_T_DIR)/__stdio_write.t     \
	$(LIBC_T_DIR)/__stdout_write.t    \
	$(LIBC_T_DIR)/__towrite.t         \
	$(LIBC_T_DIR)/default_attr.t      \
	$(LIBC_T_DIR)/defsysinfo.t        \
	$(LIBC_T_DIR)/exit.t              \
	$(LIBC_T_DIR)/frexpl.t            \
	$(LIBC_T_DIR)/fwrite.t            \
	$(LIBC_T_DIR)/libc.t              \
	$(LIBC_T_DIR)/lseek.t             \
	$(LIBC_T_DIR)/memchr.t            \
	$(LIBC_T_DIR)/memcpy.t            \
	$(LIBC_T_DIR)/memset.t            \
	$(LIBC_T_DIR)/ofl.t               \
	$(LIBC_T_DIR)/printf.t            \
	$(LIBC_T_DIR)/stdout.t            \
	$(LIBC_T_DIR)/strerror.t          \
	$(LIBC_T_DIR)/strnlen.t           \
	$(LIBC_T_DIR)/syscall_ret.t       \
	$(LIBC_T_DIR)/vfprintf.t          \
	$(LIBC_T_DIR)/wcrtomb.t           \
	$(LIBC_T_DIR)/wctomb.t
CRTI = $(MUSL)/lib/crt1.t $(MUSL)/lib/crt1_asm.t $(MUSL)/lib/crti.t
CRTN = $(MUSL)/lib/crtn.t

a.out: $(TICKETS)
	rld -o $@ $(CRTI) $^ $(LIBC) $(CRTN)


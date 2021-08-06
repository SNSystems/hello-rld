MUSL = ./musl
LIBC_T_DIR = $(MUSL)/lib/libc_repo
CFLAGS =  -O0 -nostdinc -isystem "$(MUSL)/include"
TICKETS = main.o

%.t: %.c
	REPOFILE=clang.db $(CC) -o $@ -c $(CFLAGS) $<

.PHONY: all
all:
	$(MAKE) clang.db
	$(MAKE) a.out
.PHONY: clean
clean:
	-rm -f $(TICKETS) $(OBJECTS) rld.out
.PHONY: distclean
distclean: clean
	-rm -f clang.db

clang.db: $(MUSL)/lib/musl-prepo.json
	-rm -f $@
	pstore-import $@ $<

# libc tickets/objects
LIBC_FILES = \
	_Exit             \
	__environ         \
	__errno_location  \
	__fpclassifyl     \
	__init_tls        \
	__lctrans         \
	__libc_start_main \
	__lock            \
	__lockfile        \
	__set_thread_area \
	__signbitl        \
	__stdio_close     \
	__stdio_exit      \
	__stdio_seek      \
	__stdio_write     \
	__stdout_write    \
	__towrite         \
	default_attr      \
	defsysinfo        \
	exit              \
	frexpl            \
	fwrite            \
	libc              \
	lseek             \
	memchr            \
	memcpy            \
	memset            \
	ofl               \
	printf            \
	stdout            \
	strerror          \
	strnlen           \
	syscall_ret       \
	vfprintf          \
	wcrtomb           \
	wctomb

# Make the list of libc object/ticket files. In each case we take the list of
# names in $(LIBC_FILES) and stitch the correct path (LIBC_T_DIR or LIBC_TO_DIR)
# to the start and the correct extention (.t or .t.elf) to the end.
LIBC_T  = $(patsubst %,$(LIBC_T_DIR)/%.t,$(LIBC_FILES))

a.out: $(TICKETS)
	rld -o $@ $(MUSL)/lib/crt1.t $(MUSL)/lib/crt1_asm.t $(MUSL)/lib/crti.t $^ $(LIBC_T) $(MUSL)/lib/crtn.t

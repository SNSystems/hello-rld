MUSL = ./musl
LIBC_T_DIR = $(MUSL)/lib/libc_repo
LIBC_TO_DIR = $(MUSL)/lib/libc_elf

CC = clang
CFLAGS = \
	-O0 \
	-target x86_64-pc-linux-gnu-repo \
	-nostdinc \
	-isystem "$(MUSL)/include"

%.t: %.c
	REPOFILE=clang.db $(CC) -o $@ -c $(CFLAGS) $<
%.t.o: %.t
	REPOFILE=clang.db repo2obj -o $@ $<

TICKETS = main.t
OBJECTS = $(TICKETS:.t=.t.o)

.PHONY: all
all:
	$(MAKE) clang.db
	$(MAKE) a.out #ld.out

.PHONY: clean
clean:
	-rm -f $(TICKETS) $(OBJECTS) rld.out ld.out
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
LIBC_TO = $(patsubst %,$(LIBC_TO_DIR)/%.t.elf,$(LIBC_FILES))

a.out: $(TICKETS)
	rld -o $@ $(MUSL)/lib/crt1.t $(MUSL)/lib/crt1_asm.t $(MUSL)/lib/crti.t $^ $(LIBC_T) $(MUSL)/lib/crtn.t
ld.out: $(OBJECTS)
	ld -o $@ $(MUSL)/lib/crt1.t.o $(MUSL)/lib/crt1_asm.t.o $(MUSL)/lib/crti.t.o $^ $(LIBC_TO) $(MUSL)/lib/crtn.t.o

#eof

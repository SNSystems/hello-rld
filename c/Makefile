MUSL = /usr/local/musl
# TODO: the target should be musl rather than gnu.
CFLAGS =                                 \
	-target x86_64-pc-linux-gnu-repo \
	-O0                              \
	-nostdinc                        \
	-isystem $(MUSL)/include
LIBC_DIR = libc

.PHONY: all
all:
	$(MAKE) clang.db
	$(MAKE) a.out

.PHONY: clean
clean:
	-rm -f main.o libc.response a.out
	-rm -fr $(LIBC_DIR)

.PHONY: distclean
distclean: clean
	-rm -f clang.db

# Merge the repo containing the standard libraries. Ultimately, this
# will be automatic and incremental.
clang.db: /usr/lib/stdlib.repo
	cp $< $@

# libc ticket files
LIBC = \
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
	atexit            \
	default_attr      \
	defsysinfo        \
	exit              \
	frexpl            \
	fwrite            \
	libc              \
	libc_calloc       \
	lite_malloc       \
	lseek             \
	memchr            \
	memcpy            \
	memset            \
	mmap              \
	ofl               \
	printf            \
	replaced          \
	stdout            \
	strerror          \
	strnlen           \
	syscall_ret       \
	vfprintf          \
	wcrtomb           \
	wctomb

# Stitch LIBC_DIR/ on the front and .t on the end of each name in LIBC.
LIBC_FILES = $(LIBC:%=$(LIBC_DIR)/%.t)

# Turn the list of files into a list of wildcards we can use to express that
# one rule produces multiple targets.
LIBC_TARGETS = $(subst .t,%t,$(LIBC_FILES))

# Unpack libc. This will be unnecessary once rld understands static archives.
$(LIBC_TARGETS): $(MUSL)/lib/libc_repo.a
	mkdir -p $(LIBC_DIR)
	ar --output=$(LIBC_DIR) x $<
# Create a response file which can be used to link the libc tickets.
libc.response: $(LIBC_FILES)
	echo $^ > $@

CRTI = $(MUSL)/lib/crt1.t $(MUSL)/lib/crt1_asm.t $(MUSL)/lib/crti.t
CRTN = $(MUSL)/lib/crtn.t

a.out: main.o libc.response
	rld -o $@ $(CRTI) main.o @libc.response $(CRTN)

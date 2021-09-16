MUSL = /usr/local/musl
CFLAGS =  -O0 -nostdinc -isystem $(MUSL)/include
CXX = c++
CXXFLAGS = $(CFLAGS) -fno-exceptions
TICKETS = main.o crtbegin.o

%.o: %.c
	$(CC) -o $@ -c $(CFLAGS) $<
%.o: %.cpp
	$(CXX) -o $@ -c $(CXXFLAGS) $<

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

LIBC_DIR = /hello-rld/libc
# libc ticket files
LIBC = \
	$(LIBC_DIR)/_Exit.t             \
	$(LIBC_DIR)/__environ.t         \
	$(LIBC_DIR)/__errno_location.t  \
	$(LIBC_DIR)/__fpclassifyl.t     \
	$(LIBC_DIR)/__init_tls.t        \
	$(LIBC_DIR)/__lctrans.t         \
	$(LIBC_DIR)/__libc_start_main.t \
	$(LIBC_DIR)/__lock.t            \
	$(LIBC_DIR)/__lockfile.t        \
	$(LIBC_DIR)/__set_thread_area.t \
	$(LIBC_DIR)/__signbitl.t        \
	$(LIBC_DIR)/__stdio_close.t     \
	$(LIBC_DIR)/__stdio_exit.t      \
	$(LIBC_DIR)/__stdio_seek.t      \
	$(LIBC_DIR)/__stdio_write.t     \
	$(LIBC_DIR)/__stdout_write.t    \
	$(LIBC_DIR)/__towrite.t         \
	$(LIBC_DIR)/atexit.t            \
	$(LIBC_DIR)/default_attr.t      \
	$(LIBC_DIR)/defsysinfo.t        \
	$(LIBC_DIR)/exit.t              \
	$(LIBC_DIR)/frexpl.t            \
	$(LIBC_DIR)/fwrite.t            \
	$(LIBC_DIR)/libc.t              \
	$(LIBC_DIR)/libc_calloc.t       \
	$(LIBC_DIR)/lite_malloc.t       \
	$(LIBC_DIR)/lseek.t             \
	$(LIBC_DIR)/memchr.t            \
	$(LIBC_DIR)/memcpy.t            \
	$(LIBC_DIR)/memset.t            \
	$(LIBC_DIR)/mmap.t              \
	$(LIBC_DIR)/ofl.t               \
	$(LIBC_DIR)/printf.t            \
	$(LIBC_DIR)/replaced.t          \
	$(LIBC_DIR)/stdout.t            \
	$(LIBC_DIR)/strerror.t          \
	$(LIBC_DIR)/strnlen.t           \
	$(LIBC_DIR)/syscall_ret.t       \
	$(LIBC_DIR)/vfprintf.t          \
	$(LIBC_DIR)/wcrtomb.t           \
	$(LIBC_DIR)/wctomb.t
CRTI = $(MUSL)/lib/crt1.t $(MUSL)/lib/crt1_asm.t $(MUSL)/lib/crti.t
CRTN = $(MUSL)/lib/crtn.t

a.out: $(TICKETS)
	rld -o $@ $(CRTI) $^ $(LIBC) $(CRTN)


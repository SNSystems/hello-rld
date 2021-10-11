#
# A makefile for the C++ iostreams version of the "hello world" demo.
# This will become a lot simpler once static libraries and auto-merge features
# are implemented in rld.
#
############################
#
# The easiest way to find a lot of undefined symbols. The basic technique is
# documented on the prepo wiki at [1]. This variation is faster if you need to
# do a lot of it:
#
# 1. Build the names table. This is a text file containing the names of all
#    defined symbols and their corresponding ticket file.
#
#   'aw' gawk program:
#
#       #!/bin/gawk -f
#       begin { file = "" }
#       match($0, /(.+): [[:xdigit:]]+/, arr) { printf("%s\t%s\n", file, arr[1]) }
#       /^[^:]+$/ { file = $0 }
#
#   find . -type f -print -exec repo-fragments {} \; | ./aw > names.txt
#
# 2. Make.
#
#   make 2> out.txt ; sed -e '/make/d' -e 's/Undefined symbol: //g' out.txt > out2.txt
#   for f in $(cat out2.txt); do gawk "\$2==\"$f\" { print \$1 }" names.txt ; done | sort | uniq
#
# [1] https://github.com/SNSystems/llvm-project-prepo/wiki/Exploring-a-Program-Repository#repo-fragments

MUSL = /usr/local/musl
# TODO: the target should be musl rather than gnu.
CFLAGS = \
	-target x86_64-pc-linux-gnu-repo \
	-O3 \
	-nostdinc \
	-isystem /usr/include/c++/v1 \
	-isystem $(MUSL)/include

CXX = c++
CXXFLAGS = $(CFLAGS) -fno-exceptions -fno-rtti
TICKETS = main.o

%.o: %.c
	$(CC) -o $@ -c $(CFLAGS) $<
%.o: %.cpp
	$(CXX) -o $@ -c $(CXXFLAGS) $<

.PHONY: all
all:
	$(MAKE) clang.db
	$(MAKE) hello

.PHONY: clean
clean:
	-rm -f $(TICKETS) hello

LIBC_DIR      = lib/c
LIBCXXABI_DIR = lib/cxxabi
LIBCXX_DIR    = lib/cxx

.PHONY: distclean
distclean: clean
	-rm -f clang.db
	-rm -fr lib

# Start with the repo containing the standard libraries. Ultimately, this
# will be automatic and incremental.
clang.db: /usr/lib/stdlib.repo
	cp $< $@

# libc ticket files
LIBC = \
	_Exit                      \
        __ctype_get_mb_cur_max     \
        __environ                  \
	__errno_location           \
	__fpclassifyl              \
	__init_tls                 \
	__lctrans                  \
	__libc_start_main          \
	__lock                     \
	__lockfile                 \
	__map_file                 \
	__mo_lookup                \
	__month_to_secs            \
	__overflow                 \
	__set_thread_area          \
	__signbitl                 \
	__stdio_close              \
	__stdio_exit               \
	__stdio_read               \
	__stdio_seek               \
	__stdio_write              \
	__stdout_write             \
	__syscall_cp               \
	__timedwait                \
	__tm_to_secs               \
	__toread                   \
	__towrite                  \
	__tz                       \
	__uflow                    \
	__wait                     \
	__year_to_secs             \
	abort                      \
	abort_lock                 \
	aligned_alloc              \
	atexit                     \
	bcmp                       \
	block                      \
	bsearch                    \
	btowc                      \
	c_locale                   \
	catclose                   \
	catgets                    \
	catopen                    \
	clock_gettime              \
	clock_nanosleep            \
	copysignl                  \
	default_attr               \
	defsysinfo                 \
	exit                       \
	fabsl                      \
	fflush                     \
	floatscan                  \
	fmodl                      \
	fprintf                    \
	fputc                      \
	fputwc                     \
	free                       \
	freelocale                 \
	frexpl                     \
	fwide                      \
	fwrite                     \
	getc                       \
	getenv                     \
	getrlimit                  \
	internal                   \
	intscan                    \
	isblank                    \
	isdigit                    \
	islower                    \
	isupper                    \
	iswalpha                   \
	iswblank                   \
	iswcntrl                   \
	iswdigit                   \
	iswlower                   \
	iswprint                   \
	iswpunct                   \
	iswspace                   \
	iswupper                   \
	iswxdigit                  \
	isxdigit                   \
	langinfo                   \
	libc                       \
	libc_calloc                \
	lite_malloc                \
	locale_map                 \
	localeconv                 \
	lseek                      \
	madvise                    \
	malloc                     \
	mbrlen                     \
	mbrtowc                    \
	mbsinit                    \
	mbsnrtowcs                 \
	mbsrtowcs                  \
	mbtowc                     \
	memchr                     \
	memcmp                     \
	memcpy                     \
	memmove                    \
	memset                     \
	mmap                       \
	mprotect                   \
	mremap                     \
	munmap                     \
	nanosleep                  \
	newlocale                  \
	ngfree                     \
	ngrealloc                  \
	ofl                        \
	posix_memalign             \
	printf                     \
	pthread_cond_broadcast     \
	pthread_cond_destroy       \
	pthread_cond_signal        \
	pthread_cond_timedwait     \
	pthread_cond_wait          \
	pthread_detach             \
	pthread_equal              \
	pthread_getspecific        \
	pthread_join               \
	pthread_key_create         \
	pthread_mutex_destroy      \
	pthread_mutex_init         \
	pthread_mutex_lock         \
	pthread_mutex_timedlock    \
	pthread_mutex_trylock      \
	pthread_mutex_unlock       \
	pthread_mutexattr_destroy  \
	pthread_mutexattr_init     \
	pthread_mutexattr_settype  \
	pthread_rwlock_rdlock      \
	pthread_rwlock_timedrdlock \
	pthread_rwlock_timedwrlock \
	pthread_rwlock_tryrdlock   \
	pthread_rwlock_trywrlock   \
	pthread_rwlock_unlock      \
	pthread_rwlock_wrlock      \
	pthread_self               \
	pthread_setcancelstate     \
	pthread_setspecific        \
	pthread_testcancel         \
	raise                      \
	realloc                    \
	replaced                   \
	scalbn                     \
	scalbnl                    \
	sched_yield                \
	setlocale                  \
	shgetc                     \
	snprintf                   \
	sscanf                     \
	stderr                     \
	stdin                      \
	stdout                     \
	stpcpy                     \
	strchr                     \
	strchrnul                  \
	strcmp                     \
	strcoll                    \
	strcpy                     \
	strcspn                    \
	strerror                   \
	strerror_r                 \
	strftime                   \
	strlen                     \
	strncmp                    \
	strnlen                    \
	strtod                     \
	strtol                     \
	strxfrm                    \
	swprintf                   \
	syscall                    \
	syscall_ret                \
	sysconf                    \
	sysinfo                    \
	tolower                    \
	toupper                    \
	towctrans                  \
	ungetc                     \
	uselocale                  \
	vasprintf                  \
	vdso                       \
	vfprintf                   \
	vfscanf                    \
	vfwprintf                  \
	vmlock                     \
	vsnprintf                  \
	vsscanf                    \
	vswprintf                  \
	wcrtomb                    \
	wcschr                     \
	wcscmp                     \
	wcscoll                    \
	wcslen                     \
	wcsnlen                    \
	wcsnrtombs                 \
	wcstod                     \
	wcstol                     \
	wcsxfrm                    \
	wctob                      \
	wctomb                     \
	wmemchr                    \
	wmemcmp                    \
	wmemcpy                    \
	wmemmove                   \
	wmemset

LIBCXXABI = \
	abort_message        \
	cxa_default_handlers \
	cxa_guard            \
	cxa_handlers         \
	cxa_noexception      \
	cxa_virtual          \
	stdlib_exception     \
	stdlib_stdexcept

LIBCXX = \
	charconv                      \
	condition_variable            \
	condition_variable_destructor \
	exception                     \
	ios                           \
	iostream                      \
	future                        \
	locale                        \
	memory                        \
	mutex                         \
	mutex_destructor              \
	new                           \
	stdexcept                     \
	string                        \
	system_error                  \
	thread                        \
	vector

# Stitch LIBC_DIR/ on the front and .t on the end of each name in LIBC.
LIBC_FILES = $(LIBC:%=$(LIBC_DIR)/%.t)

# Stitch LIBCXXABI_DIR/ on the front and .cpp.o on the end of each name in LIBCXXABI.
LIBCXXABI_FILES = $(LIBCXXABI:%=$(LIBCXXABI_DIR)/%.cpp.o)

# Stitch LIBCXX_DIR/ on the front and .cpp.o on the end of each name in LIBCXX.
LIBCXX_FILES = $(LIBCXX:%=$(LIBCXX_DIR)/%.cpp.o)

# Unpack libc, libc++abi, and libcxx. This will be unnecessary once rld
# understands static archives.
$(LIBC_FILES): $(MUSL)/lib/libc_repo.a
	mkdir -p $(LIBC_DIR)
	ar --output=$(LIBC_DIR) x $<

$(LIBCXXABI_FILES): /usr/lib/libc++abi.a
	mkdir -p $(LIBCXXABI_DIR)
	ar --output=$(LIBCXXABI_DIR) x $<

$(LIBCXX_FILES): /usr/lib/libc++.a
	mkdir -p $(LIBCXX_DIR)
	ar --output=$(LIBCXX_DIR) x $<

CRTBEGIN = /usr/lib/linux/clang_rt.crtbegin-x86_64.o
CRTEND = /usr/lib/linux/clang_rt.crtend-x86_64.o
CRTI = $(MUSL)/lib/crt1.t $(MUSL)/lib/crt1_asm.t $(MUSL)/lib/crti.t
CRTN = $(MUSL)/lib/crtn.t

hello: $(TICKETS) $(LIBC_FILES) $(LIBCXXABI_FILES) $(LIBCXX_FILES)
	rld -o $@ $(CRTBEGIN) $(CRTI) $^ $(CRTN) $(CRTEND)

# A debugging helper. Use 'make print-X' to display the value of variable X.
print-%: ; @echo $*=$($*)

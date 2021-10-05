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
	-O0 \
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
	$(MAKE) a.out

.PHONY: clean
clean:
	-rm -f $(TICKETS) a.out

LIBC_DIR      = lib/c
LIBCXXABI_DIR = lib/cxxabi
LIBCXX_DIR    = lib/cxx

.PHONY: distclean
distclean: clean
	-rm -f clang.db
	-rm -fr lib

# Merge the repo containing the standard libraries. Ultimately, this
# will be automatic and incremental.
clang.db: /usr/lib/stdlib.repo
	cp $< $@

# libc ticket files
LIBC = \
	$(LIBC_DIR)/_Exit.t                      \
	$(LIBC_DIR)/__ctype_get_mb_cur_max.t     \
	$(LIBC_DIR)/__environ.t                  \
	$(LIBC_DIR)/__errno_location.t           \
	$(LIBC_DIR)/__fpclassifyl.t              \
	$(LIBC_DIR)/__init_tls.t                 \
	$(LIBC_DIR)/__lctrans.t                  \
	$(LIBC_DIR)/__libc_start_main.t          \
	$(LIBC_DIR)/__lock.t                     \
	$(LIBC_DIR)/__lockfile.t                 \
	$(LIBC_DIR)/__map_file.t                 \
	$(LIBC_DIR)/__mo_lookup.t                \
	$(LIBC_DIR)/__month_to_secs.t            \
	$(LIBC_DIR)/__overflow.t                 \
	$(LIBC_DIR)/__set_thread_area.t          \
	$(LIBC_DIR)/__signbitl.t                 \
	$(LIBC_DIR)/__stdio_close.t              \
	$(LIBC_DIR)/__stdio_exit.t               \
	$(LIBC_DIR)/__stdio_read.t               \
	$(LIBC_DIR)/__stdio_seek.t               \
	$(LIBC_DIR)/__stdio_write.t              \
	$(LIBC_DIR)/__stdout_write.t             \
	$(LIBC_DIR)/__syscall_cp.t               \
	$(LIBC_DIR)/__timedwait.t                \
	$(LIBC_DIR)/__tm_to_secs.t               \
	$(LIBC_DIR)/__toread.t                   \
	$(LIBC_DIR)/__towrite.t                  \
	$(LIBC_DIR)/__tz.t                       \
	$(LIBC_DIR)/__uflow.t                    \
	$(LIBC_DIR)/__wait.t                     \
	$(LIBC_DIR)/__year_to_secs.t             \
	$(LIBC_DIR)/abort.t                      \
	$(LIBC_DIR)/abort_lock.t                 \
	$(LIBC_DIR)/aligned_alloc.t              \
	$(LIBC_DIR)/atexit.t                     \
	$(LIBC_DIR)/bcmp.t                       \
	$(LIBC_DIR)/block.t                      \
	$(LIBC_DIR)/bsearch.t                    \
	$(LIBC_DIR)/btowc.t                      \
	$(LIBC_DIR)/c_locale.t                   \
	$(LIBC_DIR)/catclose.t                   \
	$(LIBC_DIR)/catgets.t                    \
	$(LIBC_DIR)/catopen.t                    \
	$(LIBC_DIR)/clock_gettime.t              \
	$(LIBC_DIR)/clock_nanosleep.t            \
	$(LIBC_DIR)/copysignl.t                  \
	$(LIBC_DIR)/default_attr.t               \
	$(LIBC_DIR)/defsysinfo.t                 \
	$(LIBC_DIR)/exit.t                       \
	$(LIBC_DIR)/fabsl.t                      \
	$(LIBC_DIR)/fflush.t                     \
	$(LIBC_DIR)/floatscan.t                  \
	$(LIBC_DIR)/fmodl.t                      \
	$(LIBC_DIR)/fprintf.t                    \
	$(LIBC_DIR)/fputc.t                      \
	$(LIBC_DIR)/fputwc.t                     \
	$(LIBC_DIR)/free.t                       \
	$(LIBC_DIR)/freelocale.t                 \
	$(LIBC_DIR)/frexpl.t                     \
	$(LIBC_DIR)/fwide.t                      \
	$(LIBC_DIR)/fwrite.t                     \
	$(LIBC_DIR)/getc.t                       \
	$(LIBC_DIR)/getenv.t                     \
	$(LIBC_DIR)/getrlimit.t                  \
	$(LIBC_DIR)/internal.t                   \
	$(LIBC_DIR)/intscan.t                    \
	$(LIBC_DIR)/isblank.t                    \
	$(LIBC_DIR)/isdigit.t                    \
	$(LIBC_DIR)/islower.t                    \
	$(LIBC_DIR)/isupper.t                    \
	$(LIBC_DIR)/iswalpha.t                   \
	$(LIBC_DIR)/iswblank.t                   \
	$(LIBC_DIR)/iswcntrl.t                   \
	$(LIBC_DIR)/iswdigit.t                   \
	$(LIBC_DIR)/iswlower.t                   \
	$(LIBC_DIR)/iswprint.t                   \
	$(LIBC_DIR)/iswpunct.t                   \
	$(LIBC_DIR)/iswspace.t                   \
	$(LIBC_DIR)/iswupper.t                   \
	$(LIBC_DIR)/iswxdigit.t                  \
	$(LIBC_DIR)/isxdigit.t                   \
	$(LIBC_DIR)/langinfo.t                   \
	$(LIBC_DIR)/libc.t                       \
	$(LIBC_DIR)/libc_calloc.t                \
	$(LIBC_DIR)/lite_malloc.t                \
	$(LIBC_DIR)/locale_map.t                 \
	$(LIBC_DIR)/localeconv.t                 \
	$(LIBC_DIR)/lseek.t                      \
	$(LIBC_DIR)/madvise.t                    \
	$(LIBC_DIR)/malloc.t                     \
	$(LIBC_DIR)/mbrlen.t                     \
	$(LIBC_DIR)/mbrtowc.t                    \
	$(LIBC_DIR)/mbsinit.t                    \
	$(LIBC_DIR)/mbsnrtowcs.t                 \
	$(LIBC_DIR)/mbsrtowcs.t                  \
	$(LIBC_DIR)/mbtowc.t                     \
	$(LIBC_DIR)/memchr.t                     \
	$(LIBC_DIR)/memcmp.t                     \
	$(LIBC_DIR)/memcpy.t                     \
	$(LIBC_DIR)/memmove.t                    \
	$(LIBC_DIR)/memset.t                     \
	$(LIBC_DIR)/mmap.t                       \
	$(LIBC_DIR)/mprotect.t                   \
	$(LIBC_DIR)/munmap.t                     \
	$(LIBC_DIR)/nanosleep.t                  \
	$(LIBC_DIR)/newlocale.t                  \
	$(LIBC_DIR)/ofl.t                        \
	$(LIBC_DIR)/posix_memalign.t             \
	$(LIBC_DIR)/printf.t                     \
	$(LIBC_DIR)/pthread_cond_broadcast.t     \
	$(LIBC_DIR)/pthread_cond_destroy.t       \
	$(LIBC_DIR)/pthread_cond_signal.t        \
	$(LIBC_DIR)/pthread_cond_timedwait.t     \
	$(LIBC_DIR)/pthread_cond_wait.t          \
	$(LIBC_DIR)/pthread_detach.t             \
	$(LIBC_DIR)/pthread_equal.t              \
	$(LIBC_DIR)/pthread_getspecific.t        \
	$(LIBC_DIR)/pthread_join.t               \
	$(LIBC_DIR)/pthread_key_create.t         \
	$(LIBC_DIR)/pthread_mutex_destroy.t      \
	$(LIBC_DIR)/pthread_mutex_init.t         \
	$(LIBC_DIR)/pthread_mutex_lock.t         \
	$(LIBC_DIR)/pthread_mutex_timedlock.t    \
	$(LIBC_DIR)/pthread_mutex_trylock.t      \
	$(LIBC_DIR)/pthread_mutex_unlock.t       \
	$(LIBC_DIR)/pthread_mutexattr_destroy.t  \
	$(LIBC_DIR)/pthread_mutexattr_init.t     \
	$(LIBC_DIR)/pthread_mutexattr_settype.t  \
	$(LIBC_DIR)/pthread_rwlock_rdlock.t      \
	$(LIBC_DIR)/pthread_rwlock_timedrdlock.t \
	$(LIBC_DIR)/pthread_rwlock_timedwrlock.t \
	$(LIBC_DIR)/pthread_rwlock_tryrdlock.t   \
	$(LIBC_DIR)/pthread_rwlock_trywrlock.t   \
	$(LIBC_DIR)/pthread_rwlock_unlock.t      \
	$(LIBC_DIR)/pthread_rwlock_wrlock.t      \
	$(LIBC_DIR)/pthread_self.t               \
	$(LIBC_DIR)/pthread_setcancelstate.t     \
	$(LIBC_DIR)/pthread_setspecific.t        \
	$(LIBC_DIR)/pthread_testcancel.t         \
	$(LIBC_DIR)/raise.t                      \
	$(LIBC_DIR)/realloc.t                    \
	$(LIBC_DIR)/replaced.t                   \
	$(LIBC_DIR)/scalbn.t                     \
	$(LIBC_DIR)/scalbnl.t                    \
	$(LIBC_DIR)/sched_yield.t                \
	$(LIBC_DIR)/setlocale.t                  \
	$(LIBC_DIR)/shgetc.t                     \
	$(LIBC_DIR)/snprintf.t                   \
	$(LIBC_DIR)/sscanf.t                     \
	$(LIBC_DIR)/stderr.t                     \
	$(LIBC_DIR)/stdin.t                      \
	$(LIBC_DIR)/stdout.t                     \
	$(LIBC_DIR)/stpcpy.t                     \
	$(LIBC_DIR)/strchr.t                     \
	$(LIBC_DIR)/strchrnul.t                  \
	$(LIBC_DIR)/strcmp.t                     \
	$(LIBC_DIR)/strcoll.t                    \
	$(LIBC_DIR)/strcpy.t                     \
	$(LIBC_DIR)/strcspn.t                    \
	$(LIBC_DIR)/strerror.t                   \
	$(LIBC_DIR)/strerror_r.t                 \
	$(LIBC_DIR)/strftime.t                   \
	$(LIBC_DIR)/strlen.t                     \
	$(LIBC_DIR)/strncmp.t                    \
	$(LIBC_DIR)/strnlen.t                    \
	$(LIBC_DIR)/strtod.t                     \
	$(LIBC_DIR)/strtol.t                     \
	$(LIBC_DIR)/strxfrm.t                    \
	$(LIBC_DIR)/swprintf.t                   \
	$(LIBC_DIR)/syscall.t                    \
	$(LIBC_DIR)/syscall_ret.t                \
	$(LIBC_DIR)/sysconf.t                    \
	$(LIBC_DIR)/sysinfo.t                    \
	$(LIBC_DIR)/tolower.t                    \
	$(LIBC_DIR)/toupper.t                    \
	$(LIBC_DIR)/towctrans.t                  \
	$(LIBC_DIR)/ungetc.t                     \
	$(LIBC_DIR)/uselocale.t                  \
	$(LIBC_DIR)/vasprintf.t                  \
	$(LIBC_DIR)/vdso.t                       \
	$(LIBC_DIR)/vfprintf.t                   \
	$(LIBC_DIR)/vfscanf.t                    \
	$(LIBC_DIR)/vfwprintf.t                  \
	$(LIBC_DIR)/vmlock.t                     \
	$(LIBC_DIR)/vsnprintf.t                  \
	$(LIBC_DIR)/vsscanf.t                    \
	$(LIBC_DIR)/vswprintf.t                  \
	$(LIBC_DIR)/wcrtomb.t                    \
	$(LIBC_DIR)/wcschr.t                     \
	$(LIBC_DIR)/wcscmp.t                     \
	$(LIBC_DIR)/wcscoll.t                    \
	$(LIBC_DIR)/wcslen.t                     \
	$(LIBC_DIR)/wcsnlen.t                    \
	$(LIBC_DIR)/wcsnrtombs.t                 \
	$(LIBC_DIR)/wcstod.t                     \
	$(LIBC_DIR)/wcstol.t                     \
	$(LIBC_DIR)/wcsxfrm.t                    \
	$(LIBC_DIR)/wctob.t                      \
	$(LIBC_DIR)/wctomb.t                     \
	$(LIBC_DIR)/wmemchr.t                    \
	$(LIBC_DIR)/wmemcmp.t                    \
	$(LIBC_DIR)/wmemcpy.t                    \
	$(LIBC_DIR)/wmemmove.t                   \
	$(LIBC_DIR)/wmemset.t

LIBCXXABI = \
	$(LIBCXXABI_DIR)/abort_message.cpp.o        \
	$(LIBCXXABI_DIR)/cxa_default_handlers.cpp.o \
	$(LIBCXXABI_DIR)/cxa_guard.cpp.o            \
	$(LIBCXXABI_DIR)/cxa_handlers.cpp.o         \
	$(LIBCXXABI_DIR)/cxa_noexception.cpp.o      \
	$(LIBCXXABI_DIR)/cxa_virtual.cpp.o          \
	$(LIBCXXABI_DIR)/stdlib_exception.cpp.o     \
	$(LIBCXXABI_DIR)/stdlib_stdexcept.cpp.o

LIBCXX = \
	$(LIBCXX_DIR)/charconv.cpp.o                      \
	$(LIBCXX_DIR)/condition_variable.cpp.o            \
	$(LIBCXX_DIR)/condition_variable_destructor.cpp.o \
	$(LIBCXX_DIR)/exception.cpp.o                     \
	$(LIBCXX_DIR)/ios.cpp.o                           \
	$(LIBCXX_DIR)/iostream.cpp.o                      \
	$(LIBCXX_DIR)/future.cpp.o                        \
	$(LIBCXX_DIR)/locale.cpp.o                        \
	$(LIBCXX_DIR)/memory.cpp.o                        \
	$(LIBCXX_DIR)/mutex.cpp.o                         \
	$(LIBCXX_DIR)/mutex_destructor.cpp.o              \
	$(LIBCXX_DIR)/new.cpp.o                           \
	$(LIBCXX_DIR)/stdexcept.cpp.o                     \
	$(LIBCXX_DIR)/string.cpp.o                        \
	$(LIBCXX_DIR)/system_error.cpp.o                  \
	$(LIBCXX_DIR)/thread.cpp.o                        \
	$(LIBCXX_DIR)/vector.cpp.o

# Unpack libc, libc++abi, and libcxx. This will be unnecessary once rld
# understands static archives.
$(LIBC): $(MUSL)/lib/libc_repo.a
	mkdir -p $(LIBC_DIR)
	ar --output=$(LIBC_DIR) x $<

$(LIBCXXABI): /usr/lib/libc++abi.a
	mkdir -p $(LIBCXXABI_DIR)
	ar --output=$(LIBCXXABI_DIR) x $<

$(LIBCXX): /usr/lib/libc++.a
	mkdir -p $(LIBCXX_DIR)
	ar --output=$(LIBCXX_DIR) x $<

CRTBEGIN = /usr/lib/linux/clang_rt.crtbegin-x86_64.o
CRTEND = /usr/lib/linux/clang_rt.crtend-x86_64.o
CRTI = $(MUSL)/lib/crt1.t $(MUSL)/lib/crt1_asm.t $(MUSL)/lib/crti.t
CRTN = $(MUSL)/lib/crtn.t

a.out: $(TICKETS) $(LIBC) $(LIBCXXABI) $(LIBCXX)
	rld -o $@ $(CRTBEGIN) $(CRTI) $^ $(CRTN) $(CRTEND)

#
# A makefile for the C++ iostreams version of the "hello world" demo.
# This will become a lot simpler once auto-merge features are implemented in
# rld.
#

# The directory in which musl libc is installed.
MUSL = /usr/local/musl

CXX = c++
CXXFLAGS = \
	-target x86_64-pc-linux-gnu-repo \
	-fno-exceptions                  \
	-fno-rtti                        \
	-O0                              \
	-nostdinc                        \
	-isystem /usr/include/c++/v1     \
	-isystem $(MUSL)/include

.PHONY: all
all:
	$(MAKE) clang.db
	$(MAKE) hello

.PHONY: clean
clean:
	-rm -f hello.o hello

.PHONY: distclean
distclean: clean
	-rm -f clang.db

# Start with the repo containing the standard libraries. Ultimately, this
# will be automatic and incremental.
clang.db: /usr/lib/stdlib.repo
	cp $< $@

CRTBEGIN = /usr/lib/linux/clang_rt.crtbegin-x86_64.o
CRTEND = /usr/lib/linux/clang_rt.crtend-x86_64.o
CRT1 = $(MUSL)/lib/crt1.t $(MUSL)/lib/crt1_asm.t

hello: hello.o
	rld -o $@ $(CRTBEGIN) $(CRT1) $^ $(MUSL)/lib/libc_repo.a /usr/lib/libc++abi.a /usr/lib/libc++.a $(CRTEND)

#
# A makefile for the C++ iostreams version of the "hello world" demo.
# This will become a lot simpler once auto-merge features are implemented in
# rld.
#

CXX = c++
CXXFLAGS = \
	-target x86_64-pc-linux-musl-repo \
	-fno-exceptions                   \
	-fno-rtti                         \
	-O0

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

hello: hello.o
	$(CXX) -o $@ -target x86_64-pc-linux-musl-repo $^

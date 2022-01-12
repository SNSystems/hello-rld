#
# A makefile for the C++ iostreams version of the "hello world" demo.
# This will become a lot simpler once auto-merge features are implemented in
# rld.
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
	-rm -fr lib
	-rm -f libcxxabi.response libcxx.response

.PHONY: distclean
distclean: clean
	-rm -f clang.db

LIBCXXABI_DIR = lib/cxxabi
LIBCXX_DIR    = lib/cxx



# Start with the repo containing the standard libraries. Ultimately, this
# will be automatic and incremental.
clang.db: /usr/lib/stdlib.repo
	cp $< $@

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

# Stitch LIBCXXABI_DIR/ on the front and .cpp.o on the end of each name in LIBCXXABI.
LIBCXXABI_FILES = $(LIBCXXABI:%=$(LIBCXXABI_DIR)/%.cpp.o)
# As for LIBC_TARGETS, turn the list of files into a list of wildcards.
LIBCXXABI_TARGETS = $(subst .cpp.o,.cpp%o,$(LIBCXXABI_FILES))

# Stitch LIBCXX_DIR/ on the front and .cpp.o on the end of each name in LIBCXX.
LIBCXX_FILES = $(LIBCXX:%=$(LIBCXX_DIR)/%.cpp.o)
LIBCXX_TARGETS = $(subst .cpp.o,.cpp%o,$(LIBCXX_FILES))

$(LIBCXXABI_TARGETS): /usr/lib/libc++abi.a
	mkdir -p $(LIBCXXABI_DIR)
	ar --output=$(LIBCXXABI_DIR) x $<
libcxxabi.response: $(LIBCXXABI_FILES)
	echo $^ > $@

$(LIBCXX_TARGETS): /usr/lib/libc++.a
	mkdir -p $(LIBCXX_DIR)
	ar --output=$(LIBCXX_DIR) x $<
libcxx.response: $(LIBCXX_FILES)
	echo $^ > $@

CRTBEGIN = /usr/lib/linux/clang_rt.crtbegin-x86_64.o
CRTEND = /usr/lib/linux/clang_rt.crtend-x86_64.o
CRT1 = $(MUSL)/lib/crt1.t $(MUSL)/lib/crt1_asm.t

hello: hello.o libcxxabi.response libcxx.response
	rld -o $@ $(CRTBEGIN) $(CRT1) hello.o $(MUSL)/lib/libc_repo.a @libcxxabi.response @libcxx.response $(CRTEND)

# A debugging helper. Use 'make print-X' to display the value of variable X.
print-%: ; @echo $*=$($*)

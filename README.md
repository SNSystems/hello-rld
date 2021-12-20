# Hello, (Wo)rld

[![Build](https://github.com/SNSystems/hello-rld/actions/workflows/build.yaml/badge.svg)](https://github.com/SNSystems/hello-rld/actions/workflows/build.yaml)

A newborn linker emerges blinking into the sunlight. It looks about cautiously before saying its first words to greet the dawn. “Hello, World.”

Almost the simplest possible program, but the traditional starting point and one that can be linked directly from a program repository without the need for traditional object files. It exclusively uses the program repository aware [compiler (clang)](https://github.com/SNSystems/llvm-project-prepo) and [linker (rld)](https://github.com/SNSystems/llvm-project-prepo/tree/master/rld) to create an “end-to-end” solution.

By far the easiest way to share in the glory of these demos is to use the [llvm-prepo docker container](https://hub.docker.com/r/sndevelopment/llvm-prepo) which has all of the tools you need pre-installed.

## Hello, Bonjour, Ciao

There are three different versions of the hello-world program at three different stages along the evolutionary ladder.

1. The simplest version is in [raw/](raw/). 

    It uses direct Linux system calls to do its work and has no other dependencies. From the point of view of the linker, this is the simplest. It will only ever run on Linux, though.
    
2. The C example is in [c/](c/).

   This uses the printf() function from the C standard library. It also goes further and prints other information to show that the library is being linked correctly.
   
3.  The C++ example is in [cxx/](cxx/).

    This example uses the C++ iostreams library to do its work.

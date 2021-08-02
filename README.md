# Hello, (Wo)rld

A newborn linker emerges blinking into the sunlight. It looks about cautiously before saying its first words to greet the dawn. “Hello, World.”

Almost the simplest possible program, but the traditional starting point and one that can be linked directly from a program repository without the need for traditional object files. It exclusively uses the program repository aware [compiler (clang)](https://github.com/SNSystems/llvm-project-prepo) and [linker (rld)](https://github.com/SNSystems/llvm-project-prepo/tree/master/rld) to create an “end-to-end” solution.

By far the easiest way to share in the glory of this application is to use the [llvm-prepo docker container](https://hub.docker.com/r/paulhuggett/llvm-prepo) which has all of the tools you need pre-installed.

## Hello Docker

Clone this repository and start the docker container. The freshly cloned code is mapped to the path `/hello-rld` inside the container.

~~~bash
git clone https://github.com/SNSystems/hello-rld.git
docker pull paulhuggett/llvm-prepo:latest
docker run --rm --tty --interactive -v $(pwd)/hello-rld:/hello-rld paulhuggett/llvm-prepo
~~~

(If you use a non bash-like shell, replace `$(pwd)` in the second of these commands with the path of your current working directory.)

Build the program and run it:

~~~bash
cd /hello-rld
make
./a.out
~~~

You will be met with the traditional cheery greeting.

### Example Session

Here’s an example session:

~~~
paul@ubuntu:~$ git clone https://github.com/SNSystems/hello-rld.git
Cloning into 'hello-rld'...

paul@ubuntu:~$ docker run --rm --tty --interactive -v $(pwd)/hello-rld:/hello-rld paulhuggett/llvm-prepo
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

prepo@4904255ad380:~$ cd /hello-rld

prepo@4904255ad380:/hello$ make
cc -o start.o -c -O0 -target x86_64-pc-linux-gnu-repo start.c
cc -o main.o -c -O0 -target x86_64-pc-linux-gnu-repo main.c
rld -o a.out start.o main.o

prepo@4904255ad380:/hello$ ./a.out
Hello, World
~~~

Hurrah!

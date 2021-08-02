# Hello, (Wo)rld

Stepping up the complexity considerably, here’s a version of hello-rld that incorporates the full might of the musl libc standard library.


## Hello Docker

### 1. Start the Container

Clone this repository and start the docker container. The freshly cloned code is mapped to the path `/hello-rld` inside the container.

~~~bash
git clone --recursive -b musl-work https://github.com/SNSystems/hello-rld.git
docker pull paulhuggett/llvm-prepo:latest
docker run --rm --tty --interactive -v $(pwd)/hello-rld:/hello-rld paulhuggett/llvm-prepo
~~~

(If you use a non bash-like shell, replace `$(pwd)` in the second of these commands with the path of your current working directory.)

### 2. Build the Standard C Library

Now we need to build the standard library:

~~~bash
cd /hello-rld/musl-prepo
./configure --disable-shared --prefix=/hello-rld/musl
make install-headers install-ticket-libs
~~~

### 3. Extract the Ticket Files

rld doesn’t yet support static archives, so extract all of the ticket files into a new directory:

~~~bash
cd /hello-rld/musl/lib
mkdir libc_repo
ar -x --output libc_repo libc_repo.a
~~~

### 4. Hello!

Finally, build the program and run it:

~~~bash
cd /hello-rld
make
./a.out
~~~

You will be met with the traditional cheery greeting.

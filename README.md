# Hello, (Wo)rld

Stepping up the complexity considerably, here’s a version of hello-rld that incorporates the full might of the musl libc standard library.

## Build instructions

~~~bash
git clone --recursive -b musl-work https://github.com/paulhuggett/hello-rld/
cd hello-rld

docker pull paulhuggett/llvm-prepo:latest
docker run --rm --tty --interactive -v $(pwd):/hello-rld paulhuggett/llvm-prepo:latest

cd /hello-rld/musl-prepo
./configure --disable-shared --prefix=/hello-rld/musl
make install-headers install-ticket-libs

cd /hello-rld/musl/lib
mkdir libc_repo; ar -x --output libc_repo libc_repo.a

cd /hello-rld
make
~~~

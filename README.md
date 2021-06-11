# Hello, (Wo)rld

Stepping up the complexity considerably, here’s work-in-progress on a version of hello-rld that incorporates the full might of the musl libc standard library.

## Build instructions

~~~bash
git clone --recursive -b musl-work https://github.com/paulhuggett/hello-rld/
cd hello-rld

docker pull paulhuggett/llvm-prepo:latest
docker run --rm --tty --interactive -v $(pwd):/hello-rld paulhuggett/llvm-prepo:latest

sudo apt-get update
sudo apt-get -y install python

cd /hello-rld/musl-prepo
./configure --disable-shared --prefix=/hello-rld/musl
make
make install

cd /hello-rld/musl
mkdir libc_repo
cd libc_repo
ar -x ../libc_repo.a

cd /hello-rld
make
~~~

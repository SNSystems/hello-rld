# Hello, (Wo)rld

Almost the simplest possible program, but the traditional starting point and one that can be successfully linked directly from a program database without the need for traditional object files.

By far the easiest way to share in the glory of this application is to use the llvm-prepo docker container.

## Hello Docker

Clone this repository and start the docker container:

~~~bash
git clone https://github.com/paulhuggett/hello-rld.git
docker run --rm --tty --interactive -v $(pwd)/hello-rld:/hello-rld paulhuggett/llvm-prepo
~~~

With the docker container running, we need to install make:

~~~bash
sudo apt-get update && sudo apt-get install -y --no-install-recommends make
~~~

Finally, build the program and run it!

~~~bash
cd /hello-rld
make
./a.out
~~~

You will be met with the traditional cheery greeting.

### Example Session

Here’s an example session transcript:

~~~
paul@ubuntu:~$ git clone https://github.com/paulhuggett/hello-rld.git
Cloning into 'hello-rld'...
remote: Enumerating objects: 6, done.
remote: Counting objects: 100% (6/6), done.
remote: Compressing objects: 100% (6/6), done.
remote: Total 6 (delta 0), reused 6 (delta 0), pack-reused 0
Unpacking objects: 100% (6/6), 1.03 KiB | 1.03 MiB/s, done.

paul@ubuntu:~$ docker run --rm --tty --interactive -v ~/hello-rld:/hello-rld paulhuggett/llvm-prepo
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

prepo@4904255ad380:~$ sudo apt-get update && sudo apt-get install -y --no-install-recommends make
[sudo] password for prepo: 
Get:1 http://archive.ubuntu.com/ubuntu focal InRelease [265 kB]
...
Preparing to unpack .../make_4.2.1-1.2_amd64.deb ...
Unpacking make (4.2.1-1.2) ...
Setting up make (4.2.1-1.2) ...

prepo@4904255ad380:~$ cd /hello-rld

prepo@4904255ad380:/hello$ make
cc -o start.o -c -O0 -target x86_64-pc-linux-gnu-repo start.c
cc -o main.o -c -O0 -target x86_64-pc-linux-gnu-repo main.c
rld -o a.out start.o main.o

prepo@4904255ad380:/hello$ ./a.out
Hello, World
~~~

Hurrah.

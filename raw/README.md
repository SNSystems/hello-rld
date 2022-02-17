## Hello Docker

Clone this repository and start the docker container. The freshly cloned code is mapped to the path `/hello-rld` inside the container.

~~~bash
git clone https://github.com/SNSystems/hello-rld.git
docker pull sndevelopment/llvm-prepo:latest
docker run --rm --tty --interactive -v $(pwd)/hello-rld:/hello-rld sndevelopment/llvm-prepo:latest
~~~

(If you use a non bash-like shell, replace `$(pwd)` in the second of these commands with the path of your current working directory.)

Build the program and run it:

~~~bash
cd /hello-rld/raw
make
./a.out
~~~

You will be met with the traditional cheery greeting.

### Example Session

Here’s an example session:

~~~
paul@ubuntu:~$ git clone https://github.com/SNSystems/hello-rld.git
Cloning into 'hello-rld'...

paul@ubuntu:~$ docker run --rm --tty --interactive -v $(pwd)/hello-rld:/hello-rld sndevelopment/llvm-prepo
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

prepo@4904255ad380:~$ cd /hello-rld

prepo@4904255ad380:/hello$ make
cc -o start.o -c start.c
cc -o main.o -c main.c
rld -o a.out start.o main.o

prepo@4904255ad380:/hello$ ./a.out
Hello, World
~~~

Hurrah!

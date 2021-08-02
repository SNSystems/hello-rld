# Hello, (Wo)rld

Stepping up the complexity considerably, here’s a version of hello-rld that incorporates the full might of the musl libc standard library.


## Hello Docker

1. Clone the repository
    ~~~bash
    git clone --recursive -b musl-work https://github.com/SNSystems/hello-rld.git
    ~~~
1. Start the container. The freshly cloned code is mapped to the path `/hello-rld` inside the container.
    ~~~bash
    docker pull paulhuggett/llvm-prepo:latest
    docker run --rm --tty --interactive -v $(pwd)/hello-rld:/hello-rld paulhuggett/llvm-prepo:latest
    ~~~
    (If you use a non bash-like shell, replace `$(pwd)` in the third of these commands with the path of your current working directory.)
1. Build the Standard C Library:
    ~~~bash
    cd /hello-rld/musl-prepo
    ./configure --disable-shared --prefix=/hello-rld/musl
    make install-headers install-ticket-libs
    ~~~
1. Extract the Ticket Files. rld doesn’t yet support static archives, so extract all of the ticket files into a new directory:
    ~~~bash
    cd /hello-rld/musl/lib
    mkdir libc_repo
    ar -x --output libc_repo libc_repo.a
    ~~~
1. Hello! Finally, we can build the program and run it:
    ~~~bash
    cd /hello-rld
    make
    ./a.out
    ~~~

    You will be met with the traditional cheery greeting.

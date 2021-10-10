# Hello, (Wo)rld

Hard core. We’re now going for a full C++ implementation which uses iostreams to do its IO.


## Hello Docker

1. Clone the repository

    ~~~bash
    git clone -b libcxx https://github.com/SNSystems/hello-rld.git
    ~~~

1. Start the container. The freshly cloned code is mapped to the path `/home/prepo/hello-rld`.

    ~~~bash
    docker pull paulhuggett/llvm-prepo:latest
    docker run --rm --tty --interactive                  \
               -v $(pwd)/hello-rld:/home/prepo/hello-rld \
               paulhuggett/llvm-prepo:latest
    ~~~

    (If you use a non bash-like shell, replace `$(pwd)` in the second of these commands with the path of your current working directory.)

1. Build the program and run it:

    ~~~bash
    cd /hello-rld
    make
    ./a.out
    ~~~
    
    You will be met with the traditional cheery greeting.

#include "syscall.h"

static void write(char const * buf, unsigned long long size) {
    // %rax | System call | %rdi            | %rsi             | %rdx
    // 1    | sys_write   | unsgined int fd | const char * buf | size_t count
    int fd = 1;
    long long ret; // write return value
    asm volatile (
        "syscall"
        : "=a" (ret)
        //                 EDI      RSI       RDX
        : "0"(__NR_write), "D"(fd), "S"(buf), "d"(size)
        : "rcx", "r11", "memory"
    );
}

int main () {
    char const buf[] = "Hello, World\n";
    unsigned long long const size = sizeof (buf) - 1;
    write (buf, size);
    return 0;
}


#include "syscall.h"
extern int main();
void _start () {
    int exit_status = main ();
    long long ret;
    asm volatile (
      "syscall"
      : "=a" (ret)
      : "0" (__NR_exit), "D"(exit_status));
}

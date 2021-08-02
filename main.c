#include <stdio.h>

int main (int argc, char * argv[], char * envp[]) {
    for (int ctr = 0 ; ctr < argc; ++ctr) {
        printf("%d: %s\n", ctr, argv[ctr]);
    }
    while (*envp) {
        printf("%s\n", *(envp++));
    }
}


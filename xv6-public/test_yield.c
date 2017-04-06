#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    uint pid, i;
    pid = fork();

    if (pid == 0) {
        /* child*/
        for (;;) {
            printf(1, "Child\n");
            my_yield();
        }
    } else if (pid > 0) {
        /** parent */
        for(;;) {
            printf(1, "Parent\n");
            my_yield();
        }
    } else {
        printf(1, "fork() error\nTerminate the program.\n");
        exit();
    }
    /** parent process should wait till child is terminated */
    wait();

    exit();
}

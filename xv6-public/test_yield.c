#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    uint pid, i, count = 100;
    pid = fork();

    if (pid == 0) {
        /* child*/
        for (i = 0; i < count; ++i) {
            printf(1, "Child\n");
            sys_yield();
        }
    } else if (pid > 0) {
        /** parent */
        for (i = 0; i < count; ++i) {
            printf(1, "Parent\n");
            sys_yield();
        }
    } else {
        printf(1, "fork() error\nTerminate the program.\n");
        exit();
    }
    /** parent process should wait till child is terminated */
    wait();

    exit();
}
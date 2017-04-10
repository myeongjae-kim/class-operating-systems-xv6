#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    uint pid, i, j, count = 100;
    pid = fork();

    if (pid == 0) {
        /* child*/
        for (i = 0; i < count; ++i) {
            printf(1, "Child. getlev(): %d.\n", getlev());
            for (j = 0; j < 50000000; ++j) {
              
            }
        }
        printf(1, "\n");
    } else if (pid > 0) {
        /** parent */
        for (i = 0; i < count; ++i) {
            printf(1, "Parent. getlev(): %d.\n", getlev());
            for (j = 0; j < 50000000; ++j) {
              
            }
        }
    } else {
        printf(1, "fork() error\nTerminate the program.\n");
        exit();
    }
    /** parent process should wait till child is terminated */
    wait();

    exit();
}

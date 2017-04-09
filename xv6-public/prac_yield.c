#include "types.h"
#include "defs.h"

// Design Document 1-1-2-3.
int
sys_yield(void)
{
    yield();
    /** cprintf("my_yield() is called\n"); */
    return 0;
}

//Wrapper
int
sys_sys_yield(void)
{
    return sys_yield();
}

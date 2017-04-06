#include "types.h"
#include "defs.h"

int
my_yield(void)
{
    yield();
    /** cprintf("my_yield() is called\n"); */
    return 0;
}

//Wrapper
int
sys_my_yield(void)
{
    return my_yield();
}

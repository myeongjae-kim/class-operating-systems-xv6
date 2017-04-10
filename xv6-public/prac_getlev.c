#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"

// Design Document 1-1-2-3.
int
getlev(void)
{
    return proc->level_of_MLFQ;
}

//Wrapper
int
sys_getlev(void)
{
    return getlev();
}

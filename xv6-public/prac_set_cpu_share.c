#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

extern int get_sum_cpu_share(void);
extern int set_sum_cpu_share(int sum_cpu_share);

int
set_cpu_share(int required) 
{
  int cpu_share_already_set;
  int desired_sum_cpu_share; // a variable indicating a value when set_cpu_share() succeeds

  // function argument is not valid
  if ( ! (1 <= required && required <= 80) ) 
    goto exception;

  cpu_share_already_set = proc->cpu_share;
  desired_sum_cpu_share = get_sum_cpu_share() - cpu_share_already_set + required;

  // If a required cpu share is too much.
  if (set_sum_cpu_share(desired_sum_cpu_share) < 0 )
    goto exception;

  // It is okay to set cpu_share
  proc->cpu_share = required;
  proc->stride = NSTRIDE / required;

#ifdef MJ_DEBUGGING
  cprintf("set_cpu_share(%d): cpu_share has been set\n", required);
  cprintf("set_cpu_share(%d): proc->cpu_share: %d, proc->stride: %d, ptable->sum_cpu_share: %d\n"
      , required, required, proc->stride, desired_sum_cpu_share);
#endif

  return 0;

exception:
#ifdef MJ_DEBUGGING
  cprintf("set_cpu_share(%d): exception has occurred\n", required);
#endif

  return -1;
}

int
sys_set_cpu_share(void) 
{
  int required;
  //Decode argument using argint

  if (argint(0, &required) < 0) {
    return -1;
  }

  return set_cpu_share(required);
}

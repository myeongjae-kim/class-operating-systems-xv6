#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"
/** #include "stat.h" */
/** #include "user.h" */

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

extern int get_time_quantum(); // in proc.c: return time quantums of each queue.
extern int priority_boost(void); // in proc.c: move every process to the highest queue

extern int get_MLFQ_tick_used(void);          // in proc.c
extern void increase_MLFQ_tick_used(void);    // in proc.c

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  SETGATE(idt[T_USER_INT], 1, SEG_KCODE<<3, vectors[T_USER_INT], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

// below strcmp() is in 'ulib.c'.
// I declared it as a static function so it could be used only in this file.
/** static int
  * strcmp(const char *p, const char *q)
  * {
  *   while(*p && *p == *q)
  *     p++, q++;
  *   return (uchar)*p - (uchar)*q;
  * } */

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
  }

  if(tf->trapno == T_USER_INT){
      cprintf("user interrupt 128 called!\n");
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.



  // Design Document 1-1-2-5. Priority boost
  if (get_MLFQ_tick_used() >= 100) {
#ifdef MJ_DEBUGGING
    cprintf("\n\n*** Priority Boost ***\n\n");
#endif
    priority_boost();
  }


  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
    // Design Document 1-1-2-2.
    proc->tick_used++;
    proc->time_quantum_used++;

    if(proc->cpu_share == 0) {
      increase_MLFQ_tick_used();
    }

#ifdef MJ_DEBUGGING
    cprintf("\n\
          Timer interrupt has been occured. 'ticks' is increased.\n\
          pid: %d\n\
          tf->trapno: %d\n\
          system ticks:%d\n\
          MLFQ_tick_used: %d\n\
          tick_used: %d\n\
          time_quantum_used: %d\n",proc->pid, tf->trapno, ticks,get_MLFQ_tick_used() ,proc->tick_used, proc->time_quantum_used);
#endif

    // yield if it uses whole time quantum
    if(proc->time_quantum_used >= get_time_quantum()) {
      
#ifdef MJ_DEBUGGING
      cprintf("**********************************\n");
      cprintf("    Full of the time quantum\n");
      cprintf("            Yield!\n");
      cprintf("**********************************\n");
#endif
      

      // Design Document 1-1-2-5. Moving a process to the lower level
      if (proc->level_of_MLFQ < NMLFQ - 1) {
        proc->level_of_MLFQ++;
      }

      // Design Document 1-1-2-2
      proc->time_quantum_used = 0;
      yield();
    }
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}

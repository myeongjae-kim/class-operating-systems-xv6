#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;

  // Design Document 1-1-2-4.
  struct proc proc[NPROC];
  int MLFQ_time_quantum[NMLFQ];
  int MLFQ_tick_used;

  // Design Document 1-2-2-3.
  struct proc* stride_queue[NSTRIDE_QUEUE]; // Index will be used from 1 to 64.
  int stride_queue_size;
  int stride_time_quantum;

  int sum_cpu_share;
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);


static void stride_queue_heapify_up(int stride_idx);
static void stride_queue_heapify_down(int stride_idx);


// getters and setters
int
get_time_quantum() 
{
  if(proc && proc->cpu_share != 0) {
    // the stride time_quantum
    return (int)(ptable.stride_time_quantum * (proc->cpu_share * 0.01));
  } else {
    return ptable.MLFQ_time_quantum[proc->level_of_MLFQ];
  }
}

// Design Document 1-1-2-4
int get_MLFQ_tick_used(void)
{
  return ptable.MLFQ_tick_used;
}

void initialize_MLFQ_tick_used(void)
{
  ptable.MLFQ_tick_used = 0;
}

void increase_MLFQ_tick_used(void)
{
  ptable.MLFQ_tick_used++;
}


void
pinit(void)
{
  // Design Document 1-1-2-4. Initializing the time_quantum array.
  int queue_level;
  int default_ticks = 5;
  initlock(&ptable.lock, "ptable");

  //initializing time quantum
  ptable.stride_time_quantum = 0;
  for (queue_level = 0; queue_level < NMLFQ; ++queue_level) {
      ptable.MLFQ_time_quantum[queue_level] = default_ticks;
      ptable.stride_time_quantum += default_ticks;
      default_ticks *= 2;
  }
  // Design Document 1-2-2-3.
  // the stride_time_quantum is an average of MLFQ_time_quantum array
  ptable.stride_time_quantum /= NMLFQ;

  // Design Document 1-2-2-3.
  // initializing ptable variables.
  ptable.sum_cpu_share = 0;
  memset(ptable.stride_queue, 0, sizeof(ptable.stride_queue));
  ptable.stride_queue_size = 0;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  // Design Document 1-1-2-2.
  // initializing values used in MLFQ.
  np->tick_used = 0;
  np->level_of_MLFQ = 0;
  np->time_quantum_used = 0;

  // Design Document 1-2-2-2.
  // Initializing cpu_share
  np->cpu_share = 0;
  np->stride = 0;
  np->stride_count = 0;

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *p;
  int fd;
  int stride_idx;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // delete a process in stride queue
  if (proc->cpu_share != 0) {
    int heapify_up;

#ifdef MJ_DEBUGGING
    cprintf("stirde_queue process exit()\n");
#endif

    // subtract cpu_share from sum_cpu_share
    ptable.sum_cpu_share -= proc->cpu_share;

    // find where it is in the stride queue
    for (stride_idx = 1; stride_idx < NSTRIDE_QUEUE; ++stride_idx) {
      if (ptable.stride_queue[stride_idx] == proc) {
        break;
      }
    }

    if (stride_idx == NSTRIDE_QUEUE) {
      panic("exit(): a process is not in the stride scheduler");
    }

    // delete a process from a heap
    ptable.stride_queue[stride_idx] = ptable.stride_queue[ptable.stride_queue_size];
    ptable.stride_queue[ptable.stride_queue_size--] = 0;

    // do heapify
    if (stride_idx == 1) {
      //heapify_down
      heapify_up = 0;
    } else {
      //select heapify_up or down
      heapify_up = ptable.stride_queue[stride_idx]->stride_count 
                   < ptable.stride_queue[stride_idx / 2]->stride_count 
                   ? 1 : 0;
    }

    if (ptable.stride_queue_size == 0 || ptable.stride_queue_size == 1) {
      //do nothing
    } else {
      // increase key
      if (heapify_up) {
        stride_queue_heapify_down(stride_idx);
      } else {
        stride_queue_heapify_up(stride_idx);
      }
    }



  }

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;

        // Design document 1-1-2-2 and 1-2-2-2.
        p->tick_used = 0;
        p->time_quantum_used= 0;
        p->level_of_MLFQ = 0;
        p->cpu_share = 0;
        p->stride = 0;
        p->stride_count= 0;

        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
void stride_queue_heapify_up(int stride_idx) {
  struct proc* target_proc = ptable.stride_queue[stride_idx];
  while (stride_idx != 1) {
    // if child is smaller than parent
    if (ptable.stride_queue[stride_idx] < ptable.stride_queue[stride_idx / 2]) {
      ptable.stride_queue[stride_idx] = ptable.stride_queue[stride_idx / 2];
      stride_idx /= 2;
      
    // parent is smaller than child
    } else {
      break;
    }
  }
  // locate a process to right position
  ptable.stride_queue[stride_idx] = target_proc;

}

void stride_queue_heapify_down(int stride_idx) {
  struct proc* p = ptable.stride_queue[stride_idx];

  while(stride_idx <= ptable.stride_queue_size) {
    if (ptable.stride_queue[stride_idx * 2] 
        && ptable.stride_queue[stride_idx * 2 + 1]) {
      // two childen

      // get smaller one among children
      stride_idx = ptable.stride_queue[stride_idx * 2]->stride_count 
                    > ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
                    ? stride_idx * 2 : stride_idx * 2 + 1;

      // if children's minimum is smaller than parent, swap
      if (ptable.stride_queue[stride_idx]->stride_count < p->stride_count) {
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
      } else {
        stride_idx /= 2;
        //stride_idx is the place the current process should go.
        break;
      }

    } else if (ptable.stride_queue[stride_idx * 2]) {
      // only left child (== the last element)
      stride_idx *= 2;
      // if left child's value is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count) {
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
      } else {
        stride_idx /= 2;
      }
      break;
    } else {
      // no child
      // do nothing. it will escape the loop.
      break;
    }
  }
  
  // current process' place
  ptable.stride_queue[stride_idx] = p;

}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;

  // Design Document 1-1-2-5
  int queue_level;
  
  // Design Document 1-2-2-5
  unsigned int queue_selector;
  unsigned long randstate = 1;
  int stride_is_selceted;
  int choose_algorithm;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    choose_algorithm = 1;

    for (queue_level = 0; queue_level < NMLFQ; ++queue_level) {
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        // back up MLFQ pointer for removing side effect of the stride algorithm.
        struct proc* p_mlfq = p;
        // Design Document 1-2-2-5. Choosing the stride queue or MLFQ
        if(choose_algorithm) {
          randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
          queue_selector = randstate % 100;

          if (queue_selector < ptable.sum_cpu_share) {
            // The stride queue is seleceted.
            stride_is_selceted = 1;
          } else {
            // MLFQ is seleceted
            stride_is_selceted = 0;
          }
        } else {
          // choose_algorithm == 0
          // do nothing. keep finding a process in MLFQ
        }

        // Design document 1-1-2-5. Finding a process to be run
        if(stride_is_selceted) {
          // Find a process in the stride queue
          
#ifdef MJ_DEBUGGING
          cprintf("\n\n ** The stride queue is selceted. **\n");
          cprintf    (" **       sum_cpu_share:  %d      **\n", ptable.sum_cpu_share);
          cprintf    (" **       queue_selector: %d      **\n\n", queue_selector);
#endif

          //TODO: Implement priority queue. 
          //      Elements are indices of a proc structure array.
          //      Key value is proc->stride_count.

          // Increase key
          p = ptable.stride_queue[1];
          p->stride_count += p->stride;
          stride_queue_heapify_down(1);

        } else {
          // Find a process in MLFQ 
          // skip a process whose value of cpu_share is not zero which is in the stride_queue


          // skip processes in the stride queue
          if(p->state == RUNNABLE && p->cpu_share == 0 && p->level_of_MLFQ <= queue_level) {
            // A process to be run has been found!
            choose_algorithm = 1;
          } else {
            // A process to be run has not been found. Keep finding.
            choose_algorithm = 0;
            continue;
          }
        }
        
        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.
        proc = p;
        switchuvm(p);
        p->state = RUNNING;
        swtch(&cpu->scheduler, p->context); // 이걸 call하면 sched 함수 안에서 return한다? 프로세스 진행.
        switchkvm();
        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0;

        if(stride_is_selceted) {
          p = p_mlfq;
          p--;
        }
      }
    }
    release(&ptable.lock);
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");

  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler); // sched는 한 타임에 return되는게 아니다. 자고 있다가, 깨워지면 다시 시작한다.
  // swtch가 return되는 곳은 scheduler안에서다. scheduler 진행
  
  // 이거맞나? TODO 
  if(proc) {
    proc->time_quantum_used = 0;
  }

  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
  sched(); 
  release(&ptable.lock);
}
// Wrapper
int
sys_yield(void) {
  yield();
  return 0;
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// Design Document 1-1-2-5. priority_boost()
void
priority_boost(void) {
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    p->level_of_MLFQ = 0;
    p->tick_used = 0;
    //
    // Design Docuemtn 1-1-2-2. Reinitializing time_quantum_used
    p->time_quantum_used = 0;
  }
}

// Design Document 1-1-2-4
int
set_cpu_share(int required) 
{
  int cpu_share_already_set;
  int desired_sum_cpu_share; // a variable indicating a value when set_cpu_share() succeeds
  const int MIN_CPU_SHARE = 1;
  const int MAX_CPU_SHARE = 80;
  int is_new;
  int idx;

  // function argument is not valid
  if ( ! (MIN_CPU_SHARE <= required && required <= MAX_CPU_SHARE) ) 
    goto exception;

  cpu_share_already_set = proc->cpu_share;

  if (cpu_share_already_set == 0) {
    is_new = 1;
  } else {
    is_new = 0;
  }

  desired_sum_cpu_share = ptable.sum_cpu_share - cpu_share_already_set + required;

  // If a required cpu share is too much.
  if (desired_sum_cpu_share > MAX_CPU_SHARE )
    goto exception;

  // It is okay to set cpu_share
  ptable.sum_cpu_share = desired_sum_cpu_share;
  proc->cpu_share = required;
  proc->stride = NSTRIDE / required;

  if(is_new) {
    // Priority Queue Push
    // We do not need to check whether the stride queue is full because process cannot be generated more than 64

    // new process's stride_count should be minimum stride_count in queue for preventing schuelder from being monopolized.
    if(ptable.stride_queue[1]) {
      proc->stride_count = ptable.stride_queue[1]->stride_count;
    }

    // Heapify
    idx = ++ptable.stride_queue_size;
    while(idx != 1) {
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
      idx /= 2;
    }
    ptable.stride_queue[idx] = proc;
  } else {
    // if a process is already in the stride queue,
    // do nothing.
  }


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

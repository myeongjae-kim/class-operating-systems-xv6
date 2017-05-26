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
  
  // Design Document 1-1-2-4. variables used in scheduler()
  int queue_level_at_most;
  int min_of_run_proc_level;

  // Design Document 1-2-2-3.
  struct proc* stride_queue[NSTRIDE_QUEUE]; // Index will be used from 1 to 64.
  int sum_cpu_share;
  int stride_queue_size;
  int stride_time_quantum;
  int stride_tick_used;

} ptable;

static struct proc *initproc;

int nextpid = 1;

extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

static void stride_queue_heapify_up(int stride_idx);
static void stride_queue_heapify_down(int stride_idx);

// Design Document 2-1-2-3
int next_thread_id = 1;
struct spinlock thread_lock;
char pgdir_ref[NPROC];
int pgdir_ref_next_idx = 0;


// Design Dcoument 2-1-2-4
void
check_pgdir_counter_and_call_freevm(struct proc* p) {
#ifdef THREAD_DEBUGGING
  cprintf("(check_pgdir_count...) ** p->name:%s, p->tid:%d, pgdir_ref[p->pgdir_ref_idx]:%d\n", p->name, p->tid, pgdir_ref[p->pgdir_ref_idx]);
#endif
  if (p->pgdir_ref_idx == -1) {
    // This is a case in booting
    freevm(p->pgdir);
  } else if (pgdir_ref[p->pgdir_ref_idx] <= 1) {
    // Just only one process was using pgdir.
    // Free it.
    acquire(&thread_lock);
    pgdir_ref[p->pgdir_ref_idx] = 0;
    release(&thread_lock);
    freevm(p->pgdir);


  } else {
    // There is a thread using a same addres space.
    // Do not free it.
    // Referencing counter should be decreased.
    acquire(&thread_lock);
    pgdir_ref[p->pgdir_ref_idx]--;
    release(&thread_lock);
  }
}

void
allocate_new_pgdir_idx(struct proc* p) {
  int i;
  acquire(&thread_lock);

  // find a counter to use
  for (i = 0; i < NPROC; ++i) {
    if (pgdir_ref[pgdir_ref_next_idx] == 0) {
      p->pgdir_ref_idx = pgdir_ref_next_idx++;
      pgdir_ref_next_idx %= NPROC;
      pgdir_ref[p->pgdir_ref_idx] = 1;
      break;
    } else {
      pgdir_ref_next_idx++;
      pgdir_ref_next_idx %= NPROC;
    }
  }

  //TODO: Do not panic. Just sleep until a counter is available
  if (i == NPROC) {
    panic("(allocate_new_pgdir_idx): pgdir referencing counter allocation is failed.\n");
  }

  release(&thread_lock);
}


// getters and setters
int
get_time_quantum() 
{
  if(proc && proc->cpu_share != 0){
    return ptable.stride_time_quantum;
  }else{
    return ptable.MLFQ_time_quantum[proc->level_of_MLFQ];
  }
}

// Design Document 1-1-2-4
int
get_MLFQ_tick_used(void)
{
  return ptable.MLFQ_tick_used;
}

void
increase_MLFQ_tick_used(void)
{
  ptable.MLFQ_tick_used++;
#ifdef STRIRDE_DEBUGGING
  cprintf("\rMLFQ_tick_used: %d", ptable.MLFQ_tick_used);
#endif
}

void
increase_stride_tick_used(void)
{
  ptable.stride_tick_used++;
#ifdef STRIRDE_DEBUGGING
  cprintf("\rstride_tick_used: %d", ptable.stride_tick_used);
#endif
}


void
pinit(void)
{
  // Design Document 1-1-2-4. Initializing the time_quantum array.
  int queue_level;
  int default_ticks = 5;
  initlock(&ptable.lock, "ptable");
  initlock(&thread_lock, "thread");

  // Initializing ptable variables.
  // Design Document 1-2-2-3.
  // Initializing time quantum
  for(queue_level = 0; queue_level < NMLFQ; ++queue_level){
      ptable.MLFQ_time_quantum[queue_level] = default_ticks;
      default_ticks *= 2;
  }
  ptable.MLFQ_tick_used = 0;

  ptable.queue_level_at_most = NMLFQ - 1;
  ptable.min_of_run_proc_level = NMLFQ - 1;

  memset(ptable.stride_queue, 0, sizeof(ptable.stride_queue));
  ptable.sum_cpu_share = 0;
  ptable.stride_queue_size = 0;
  ptable.stride_time_quantum = 1; // It could be changed by designer.
  ptable.stride_tick_used = 0;

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

#ifdef THREAD_DEBUGGING
  cprintf("(allocproc) error: Proc queue is full!\n");
#endif

  
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  
  // Design Document 1-1-2-2.
  // initializing values used in MLFQ.
  p->tick_used = 0;
  p->level_of_MLFQ = 0;
  p->time_quantum_used = 0;

  // Design Document 1-2-2-2.
  // Initializing cpu_share
  p->cpu_share = 0;
  p->stride = 0;
  p->stride_count = 0;

  // Design Document 2-1-2-2
  // Related with threads.
  p->tid = 0;
  p->pgdir_ref_idx = -1;
  p->thread_return = 0;
  
  // Design Document 2-2-2-2
  // Related with threads.
  p->num_of_threads = 0;
  p->proc_forked_in_thread = 0;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;

#ifdef THREAD_DEBUGGING
    cprintf("(allocproc) error: kalloc() is failed.\n");
#endif
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

#ifdef THREAD_DEBUGGING
  cprintf("(growproc) pname:%s, pid:%d, tid:%d arg:%d\n", proc->name, proc->pid, proc->tid, n);
#endif



  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

int
fork_master_thread(struct proc* t) {
  // Make a new process but use same address space with already generated thread.

  int i, pid;
  struct proc *np;
  struct proc *old_master_thread = t->parent;

#ifdef THREAD_DEBUGGING
  cprintf("(fork_master_thread) old_master_thread pid:%d, tid:%d\n", old_master_thread->pid, old_master_thread->tid);
#endif

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // use same pid with the thread
  np->pid = t->pid;

  // Copy process state from the thread.
  np->pgdir = old_master_thread->pgdir;
  np->sz = old_master_thread->sz;

  // np's parent should be an old master thread.
  np->parent = old_master_thread;
  // Change the thread's master thread to new master thread.
  t->parent = np;
  // A fork() calling thread should know the new process' address to wait a new thread.
  proc->proc_forked_in_thread = np;

#ifdef THREAD_DEBUGGING
  cprintf("(fork_master_thread) after changing parnet. np is a new process. t is a new thread.\n");
  cprintf("(fork_master_thread) np:%p, np->pid:%d, np->tid:%d, np->parent:%p, np->parent->pid:%d, np->parent->tid:%d\n", np, np->pid, np->tid, np->parent, np->parent->pid, np->parent->tid);
  cprintf("(fork_master_thread) t:%p, t->pid:%d, t->tid:%d, t->parent:%p, t->parent->pid:%d, t->parent->tid:%d\n", t, t->pid, t->tid, t->parent, t->parent->pid, t->parent->tid);
#endif

  *np->tf = *old_master_thread->tf;

  // use same counter with the thread.
  np->pgdir_ref_idx = t->pgdir_ref_idx;
  // increase the pgdir counter and num_of_threads.
  acquire(&thread_lock);
  pgdir_ref[np->pgdir_ref_idx]++;
  np->num_of_threads++;
  release(&thread_lock);

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(t->ofile[i])
      t->ofile[i] = filedup(t->ofile[i]);
  np->cwd = idup(t->cwd);

  safestrcpy(np->name, t->name, sizeof(t->name));

  pid = np->pid;

  acquire(&ptable.lock);

  // same state with old master thread
  np->state = old_master_thread->state;

  release(&ptable.lock);

  return pid;

}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  if (proc->tid != 0) {
    cprintf("(fork) fork() is called in a thread. This is not yet implemented.\n");
    return -1;
  }

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

  // new pgdir is generated. allocate a counter to np
  allocate_new_pgdir_idx(np);

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));

  pid = np->pid;

  // when a thread calls fork()
  // current proc is a thread.
  if (proc->tid != 0) {
#ifdef THREAD_DEBUGGING
    cprintf("** (fork) a thread calls fork(). **\n");
#endif
    /** panic("a thread calls fork().\n"); */

    np->tid = next_thread_id++;

    // np's parent is old master thread temporarily.
    // In the end of the code, np's parent will be a new process(master thread).
    cprintf("** (fork) a thread's pid:%d, tid:%d **\n", proc->pid, proc->tid);
    cprintf("** (fork) a thread's parent's pid:%d, tid:%d **\n", proc->parent->pid, proc->parent->tid);
    np->parent = proc->parent;

    if(fork_master_thread(np) == -1) {
      panic("creating a new master thread is failed.");
    }

  }

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  //Design Document 1-1-2-5. A new process is generated.

  release(&ptable.lock);

  return pid;
}

void stride_queue_delete() {
  int stride_idx;
  int heapify_up;

#ifdef MJ_DEBUGGING
  cprintf("stirde_queue process exit()\n");
#endif

  // subtract cpu_share from sum_cpu_share
  ptable.sum_cpu_share -= proc->cpu_share;

  // find where it is in the stride queue
  for(stride_idx = 1; stride_idx < NSTRIDE_QUEUE; ++stride_idx){
    if(ptable.stride_queue[stride_idx] == proc){
      break;
    }
  }

  if(stride_idx == NSTRIDE_QUEUE){
    panic("exit(): a process is not in the stride scheduler");
  }

  // delete a process from the heap
  ptable.stride_queue[stride_idx] = ptable.stride_queue[ptable.stride_queue_size];
  ptable.stride_queue[ptable.stride_queue_size--] = 0;

  // do heapify
  if(stride_idx == 1){
    //heapify_down
    heapify_up = 0;
  }else{
    //select heapify_up or down
    heapify_up = ptable.stride_queue[stride_idx]->stride_count 
                 < ptable.stride_queue[stride_idx / 2]->stride_count 
                 ? 1 : 0;
  }

  if(ptable.stride_queue_size == 0 || ptable.stride_queue_size == 1){
    //do nothing
  }else{
    // increase key
    if(heapify_up){
      stride_queue_heapify_down(stride_idx);
    }else{
      stride_queue_heapify_up(stride_idx);
    }
  }

}

// Design Document 
void
common_exit(struct proc* proc)
{
  struct proc *p;
  int fd;

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
  if(proc->cpu_share != 0){
    stride_queue_delete();
  }

  // Parent might be sleeping in wait().
#ifdef THREAD_DEBUGGING
  cprintf("(common_exit) wakeup1 pname:%s, chan:%p, pid:%d, tid:%d\n", proc->parent->name, proc->parent, proc->parent->pid, proc->parent->tid);
#endif
  wakeup1(proc->parent);
#ifdef THREAD_DEBUGGING
  cprintf("(common_exit) proc->parent->state:%d\n", proc->parent->state);
#endif

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }
  proc->state = ZOMBIE;
}


int thread_join(thread_t , void **);
int clear_proc(struct proc *);
void remove_thread_stack(struct proc *);

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  if(proc == initproc)
    panic("init exiting");

  // a process without threads calls exit()
  if (proc->tid == 0 && proc->num_of_threads == 0) {
#ifdef THREAD_DEBUGGING
    cprintf(" ** A process without threads calls exit() **\n");
    cprintf(" ** pname:%s, pid:%d, tid:%d **\n", proc->name, proc->pid, proc->tid);
#endif
    common_exit(proc);

    // Jump into the scheduler, never to return.
    sched();
    panic("zombie exit");

  // a process(master thread) with threads calls exit()
  } else if (proc->tid == 0 && proc->num_of_threads != 0) {
    struct proc *p;
#ifdef THREAD_DEBUGGING
    cprintf(" ** A process with threads calls exit() **\n");
    cprintf(" ** pname:%s, pid:%d, tid:%d **\n", proc->name, proc->pid, proc->tid);
#endif
    // remove threads, and remove the master thread next.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      int tid;
      if (p->pid == proc->pid && p->tid != 0) {
        tid = p->tid;
#ifdef THREAD_DEBUGGING
        cprintf(" ** pid: %d, tid:%d **\n", p->pid, p->tid);
#endif
        common_exit(p);
        release(&ptable.lock);

        // clear resources
        thread_join(tid, (void**)0);
      }
    }
    // remove the master thread;
    common_exit(proc);

    // Jump into the scheduler, never to return.
    sched();
    panic("zombie exit");
    

  // a thread(not mastser thread) calls exit()
  } else if (proc->tid != 0 && proc->num_of_threads == 0) {
    struct proc* master_thread = proc->parent;
    struct proc *p;
#ifdef THREAD_DEBUGGING
    cprintf(" ** A thread(not master thread) calls exit() **\n");
    cprintf(" ** pname:%s, pid:%d, tid:%d **\n", proc->name, proc->pid, proc->tid);
#endif

    // 1. remove threads without a exit() calling thread and a master thread.
    // 2. remove the master thread;
    // 3. remove an exit() calling thread's resource.
    
    // 1. remove threads without a exit() calling thread and a master thread.
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if (p->pid == proc->pid && p->tid != 0 && p != proc) {
#ifdef THREAD_DEBUGGING
        cprintf(" ** pid: %d, tid:%d **\n", p->pid, p->tid);
#endif

        acquire(&ptable.lock);
        // clear resources
        remove_thread_stack(p);
        release(&ptable.lock);

        common_exit(p);
        clear_proc(p);
        release(&ptable.lock);
      }
    }

    // 2. remove the master thread;
    //    It is a process so remove_thread_stack() does not need to be called.
#ifdef THREAD_DEBUGGING
    cprintf("(exit, a thread) master thread's parent adr:%p, pid:%d, tid:%d\n", master_thread->parent, master_thread->parent->pid, master_thread->parent->tid);
#endif
    common_exit(master_thread);
    release(&ptable.lock);


    // 3. remove an exit() calling thread's resource.
    // clear thread stack resource
    acquire(&ptable.lock);
    remove_thread_stack(proc);
    release(&ptable.lock);
    // remove current proc
#ifdef THREAD_DEBUGGING
    cprintf("(exit, a thread) exit() calling thread tries to exit.\n");
    cprintf("(exit, a thread) its chan:%p, chan's pid:%d, chan's tid:%d.\n", proc->parent, proc->parent->pid, proc->parent->tid);
#endif
    /** proc->parent = chan_backup; */
#ifdef THREAD_DEBUGGING
    cprintf("(exit, a thread) chan_resotred. proc->parent:%p\n", proc->parent);
#endif
    common_exit(proc);

    //FIXME: remove resources of exit() calling thread.
    //but allocproc() reinitialize the resources so it is not a problem.
    proc->state = UNUSED;
    // Jump into the scheduler, never to return.
    sched();
    panic("zombie exit");



    
  // prohibited case. panic!
  } else {
    panic("panic in exit(). tid != 0 && num_of_threads != 0. Wrong case.");
  }



#ifdef THREAD_DEBUGGING
    cprintf(" ** The exit() case is not handled. Do default exit() **\n");
    cprintf(" ** pname:%s, pid:%d, tid:%d **\n", proc->name, proc->pid, proc->tid);
#endif
  common_exit(proc);

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Design document 2-1-2-4
int
clear_proc(struct proc *p) {
  int pid;
  // Found one.
  pid = p->pid;
  kfree(p->kstack);
  p->kstack = 0;

  /** freevm(p->pgdir); */
  check_pgdir_counter_and_call_freevm(p);

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

  // Design Document 2-1-2-2
  p->tid = 0;
  p->pgdir_ref_idx = -1;
  p->thread_return = 0;
  p->num_of_threads = 0;
  p->proc_forked_in_thread = 0;

  p->state = UNUSED;
  return pid;
}

int
wait_normal(void) {
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      // We can find a hint of kernel memory leakage when we add a condition like below
      if(p->parent != proc || p->tid != 0)
      /** if(p->parent != proc) */
        continue;

#ifdef THREAD_DEBUGGING
      if (p->tid != 0) {
        cprintf("Thread is cleared in wait(), not in thread_join()\n");
        cprintf("** print debugging information **\n");
        cprintf("pname:%s, pid:%d, tid:%d, pgidr_ref_idx:%d\n", p->name, p->pid, p->tid, p->pgdir_ref_idx);
      }
#endif

      havekids = 1;
      if(p->state == ZOMBIE){
        pid = clear_proc(p);
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

  return 0;
}

int
wait_thread(void) {
  struct proc *p;
  int havekids, pid;

#ifdef THREAD_DEBUGGING
  cprintf("(wait_thread) wait() is called in a thread. pid of waiting thread:%d\n", proc->proc_forked_in_thread->pid);
#endif

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      // We can find a hint of kernel memory leakage when we add a condition like below
      if(p->parent != proc->proc_forked_in_thread) // thread resource is removed in thread_join
        continue;


      havekids = 1;
      // clean the resource
      if(p->state == ZOMBIE){
#ifdef THREAD_DEBUGGING
        cprintf("(wait_thread) a forked thread is removed\n.");
#endif
        pid = clear_proc(p);
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
#ifdef THREAD_DEBUGGING
      cprintf("(wait_thread) return -1. havekids:%d, proc->killed:%d, panem:%s, pid:%d, tid:%d\n", havekids, proc->killed, proc->name, proc->pid, proc->tid);
#endif
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
#ifdef THREAD_DEBUGGING
    cprintf("(wait_thread) go to sleep. proc->name:%s, proc->pid:%d, proc->tid:%d is waiting. chan(proc_forked_in_thread):%p\n", proc->name, proc->pid, proc->tid, proc->proc_forked_in_thread);
#endif
    sleep(proc->proc_forked_in_thread, &ptable.lock);

#ifdef THREAD_DEBUGGING
    cprintf("(wait_thread) I wake up!. proc->name:%s, proc->pid:%d, proc->tid:%d is waiting. chan:%p\n", proc->name, proc->pid, proc->tid, proc);
#endif
  }
  return 0;
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  if (proc->tid == 0) {
    // a process calls wait().
    return wait_normal();
  } else {
    // a thread calls wait().
    return wait_thread();
  }
}
void
stride_queue_heapify_up(int stride_idx) 
{
  struct proc* target_proc = ptable.stride_queue[stride_idx];
  while(stride_idx != 1){
    // if child is smaller than parent
    if(ptable.stride_queue[stride_idx] < ptable.stride_queue[stride_idx / 2]){
      ptable.stride_queue[stride_idx] = ptable.stride_queue[stride_idx / 2];
      stride_idx /= 2;
      
    // parent is smaller than child
    }else{
      break;
    }
  }
  // locate a process to right position
  ptable.stride_queue[stride_idx] = target_proc;

}

void
stride_queue_heapify_down(int stride_idx) 
{
  struct proc* p = ptable.stride_queue[stride_idx];

  while(stride_idx * 2 < NPROC // If stride_idx indicates that it is leaf node, break the loop
      && stride_idx <= ptable.stride_queue_size){
    if(ptable.stride_queue[stride_idx * 2] 
        && ptable.stride_queue[stride_idx * 2 + 1]){
      // two childen

      // get smaller one among children
      stride_idx = ptable.stride_queue[stride_idx * 2]->stride_count 
                    < ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
                    ? stride_idx * 2 : stride_idx * 2 + 1;

      // if children's minimum is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
      }else{
        stride_idx /= 2;
        //stride_idx is the place the current process should go.
        break;
      }

    }else if(ptable.stride_queue[stride_idx * 2]){
      // only left child (== the last element)
      stride_idx *= 2;
      // if left child's value is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
      }else{
        stride_idx /= 2;
      }
      break;
    }else{
      // no child
      // do nothing. it will escape the loop.
      break;
    }
  }
  
  // current process' place
  ptable.stride_queue[stride_idx] = p;

}

int
find_idx_of_stride_to_run(void) 
{
  struct proc* proc_to_be_run;
  int i;
  
  // From the start to the end of stride queue
  int stride_find_idx = 1;
  while(stride_find_idx <= ptable.stride_queue_size){
    if(ptable.stride_queue[stride_find_idx]->state == RUNNABLE){
      // Found
      // Increase stride count of current process and heapify.
      proc_to_be_run = ptable.stride_queue[stride_find_idx];
      proc_to_be_run->stride_count += proc_to_be_run->stride;
      stride_queue_heapify_down(stride_find_idx);

      // End finding. Go to run selected process.
      break;
    }else{
      // Not found
      // select between children whose stirde_value is smaller
      int left_child = stride_find_idx * 2;
      int right_child = stride_find_idx * 2 + 1;
      enum {NO_CHILD, LEFT_ONLY, BOTH} child_status;

      if(right_child <= ptable.stride_queue_size){
        child_status = BOTH;
      }else if(left_child > ptable.stride_queue_size){
        child_status = NO_CHILD;
      }else{
        child_status = LEFT_ONLY;
      }

      // Check children's existence.
      switch(child_status){
        case BOTH:
          // Left and right children is exist.
          if(ptable.stride_queue[left_child]->stride_count
              < ptable.stride_queue[right_child]->stride_count){
            // left is smaller
            stride_find_idx = left_child;
          }else{
            // right is smaller
            stride_find_idx = right_child;
          }
          break;

        case LEFT_ONLY:
          // Only left child is exist
          stride_find_idx = left_child;
          break;

        case NO_CHILD:
          // NO_CHILD
          // End the loop. Make index bigger than stride_queue_size
          stride_find_idx = ptable.stride_queue_size + 1;
          break;
        default:
          panic("error in find_idx_of_stride_to_run().");
          break;
      }
    }
  }

  // A process is not found. Find any runnable process in stride queue.
  if(stride_find_idx >= ptable.stride_queue_size + 1){
    for(i = 1; i <= ptable.stride_queue_size; ++i){
      if(ptable.stride_queue[i]->state == RUNNABLE){
        stride_find_idx = i;
        break;
      }
    }
  }else{
    // do nothing. process is found.
  }

  // return value is larger than size when no process is runnable in stride.
  // exception handling code is in scheduler()
  return stride_find_idx;
}

int
select_stride_or_MLFQ()
{
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
  queue_selector = randstate % 100;

  if(queue_selector < ptable.sum_cpu_share){
    // The stride queue is selected.
    return 1;
  }else{
    // MLFQ is selected
    return 0;;
  }
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
  
  // Design Document 1-2-2-5
  int choosing_stride_or_MLFQ;
  int stride_is_selected = 0;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    // choose the stride queue or MLFQ
    choosing_stride_or_MLFQ = 1;

    // When while loop is end, there are only processes of last level of queue.
    ptable.queue_level_at_most = NMLFQ - 1; // last level
    while(ptable.queue_level_at_most < NMLFQ){

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        // Design Document 1-2-2-5. Choosing the stride queue or MLFQ
        if(ptable.sum_cpu_share == 0){
          // No process is in stride. Run only processes in MLFQ.
          stride_is_selected = 0;
          choosing_stride_or_MLFQ = 0;
        }else if(choosing_stride_or_MLFQ){
          // If the stride queue is selceted, the value of 'stride_is_selected' will be 1.
          // If not, zero.
          stride_is_selected = select_stride_or_MLFQ();
        }else{
          // choosing_stride_or_MLFQ == 0
          // do nothing. keep finding a process in MLFQ
        }

        // Design document 1-1-2-5. Finding a process to be run
        if(stride_is_selected){
          // The stride queue is selceted.
          
          int stride_idx_to_be_run;
          // Find a process whose state is RUNNABLE in the stride queue
          stride_idx_to_be_run = find_idx_of_stride_to_run();

          // Check whether process is found or not.
          if(stride_idx_to_be_run <= ptable.stride_queue_size){
            // Process is found. Go to run found process
            p = ptable.stride_queue[stride_idx_to_be_run];
          }else{
            // No process to be run in stride_queue. go to MLFQ
            stride_is_selected = 0;
            choosing_stride_or_MLFQ = 0;
            continue;
          }
        }else{
          // The MLFQ is selected. Find a process in MLFQ.
          // A process can be run whose priority is equal or higher than ptable.queue_level_at_most.
          
          // Skip a process whose value of cpu_share is not zero, 
          //  which means that the process is in the stride_queue, not in the MLFQ.
          if(p->state == RUNNABLE 
              && p->cpu_share == 0 
              && p->level_of_MLFQ <= ptable.queue_level_at_most){
            // A process to be run has been found!
            // Minimum level of run processes should be ptable.queue_level_at_most for next scheduling.
            ptable.queue_level_at_most = p->level_of_MLFQ < ptable.queue_level_at_most ? p->level_of_MLFQ : ptable.queue_level_at_most;
            ptable.min_of_run_proc_level = ptable.queue_level_at_most;

          }else{
            // A process to be run has not been found. Keep finding it in MLFQ.
            choosing_stride_or_MLFQ = 0;
            continue;
          }
        }
        // A proces to be run is found.
        // Below codes are used in both the stride and MLFQ.
        
        // back up MLFQ pointer for removing side effect of the stride algorithm.
        struct proc* p_mlfq = p;

        // MLFQ should use at least one tick when any processes are in the stride queue
        int before_MLFQ_used_tick;

        // Switch to chosen process. It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.

#ifdef STRIDE_DEBUGGING
        // Below codes show current context before changing context.
        cprintf("ContChange. ");
        cprintf("stride_is_selected:%d, ", stride_is_selected);
        cprintf("proc_name:%s, ", p->name);
        cprintf("proc_id:%d, ", p->pid);
        cprintf("MLFQ_tick:%d, ", ptable.MLFQ_tick_used,p->level_of_MLFQ);
        cprintf("level:%d, ", p->level_of_MLFQ);
        cprintf("stride_tick:%d, ", ptable.stride_tick_used);
        cprintf("cpu_share:%d, ", p->cpu_share);
        cprintf("sum_cpu_share: %d, ", ptable.sum_cpu_share);
        cprintf("stride:%d, ", p->stride);
        cprintf("stride_count:%d\n", p->stride_count);
        /** cprintf("ContChange. stride_is_selected:%d, proc_name:%s, proc_id:%d, MLFQ_tick:%d, level:%d, stride_tick:%d, cpu_share:%d, sum_cpu_share: %d, stride:%d, stride_count:%d\n", stride_is_selected, p->name, p->pid, ptable.MLFQ_tick_used,p->level_of_MLFQ , ptable.stride_tick_used, p->cpu_share, ptable.sum_cpu_share, p->stride, p->stride_count); */
#endif
#ifdef THREAD_DEBUGGING
        /** {
          *   int i;
          *   cprintf("** pgdir_ref status **\n");
          *   for (i = 0; i < NPROC; ++i) {
          *     if (pgdir_ref[i] >= 2) {
          *       cprintf("pgdir_ref[%d]: %d, pgdir_ref_next_idx:%d\n", i, pgdir_ref[i], pgdir_ref_next_idx);
          *     }
          *   }
          * } */
#endif
#ifdef THREAD_DEBUGGING
        {
          int i;
          int print_head = 1;
          for (i = 0; i < NPROC; ++i) {
            if (ptable.proc[i].num_of_threads >= 1) {
              if (print_head) {
                cprintf("** num_of_threads status **\n");
                print_head = 0;
              }
              cprintf("ptable.proc[%d], num_of_threads :%d\n", i, ptable.proc[i].num_of_threads);
            }
          }
        }
#endif
        proc = p;
        switchuvm(p);
        p->state = RUNNING;

        // Back up MLFQ tick for check whether a process in MLFQ uses at least one tick.
        // I did not use 'if', so in this code is executed in stride algorithm, but it does not make problem.
        before_MLFQ_used_tick = ptable.MLFQ_tick_used;

        swtch(&cpu->scheduler, p->context); // This function returns in sched().
        switchkvm();
        // Process is done running for now.
        // It should have changed its p->state before coming back.

        // Check MLFQ_tick_used only in follow conditions are satisfied:
        // 1) Current queue is MLFQ                     (stride_is_selected == 0)
        // 2) Current process is runnable               (p->state == RUNNING)
        // 3) Any processes are in the stride queue     (ptable.sum_cpu_share != 0)
        // 4) The process running now is in MLFQ        (p->cpu_share == 0)
        if(stride_is_selected == 0
            && ptable.sum_cpu_share != 0 
            && p->state == RUNNABLE 
            && p->cpu_share == 0 
            && ptable.MLFQ_tick_used == before_MLFQ_used_tick)
        {
          // When these conditions are satisfied, 
          // it means that current process are in MLFQ and it does not use at least one tick.
          
          // To make the process use one tick, re-run current process:
          // 1) Do not consider choosing between the MLFQ of the stride.
          choosing_stride_or_MLFQ = 0;

          // 2) To re-run current process, decrease pointer's value. 
          //    It will be increased in 'for' statement, so current process will be re-selected.
          p--;
        }else{
          choosing_stride_or_MLFQ = 1;
        }

        proc = 0;

        if(stride_is_selected){
          // To remove the side effect of stride algorithm, restore the process pointer and decrase it.
          // It will be increased in 'for' statement, so the status of MLFQ is same.
          p = p_mlfq;
          p--;
        }
      }

      if(ptable.min_of_run_proc_level == NMLFQ - 1)  {
        // 1) no process run. Increase queue level.
        // 2) processes are only in queue of last level. Break the while loop
        ptable.queue_level_at_most++;
      }else{
        // run a queue of same level again.
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
  if(proc){
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
sys_yield(void){
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

  if(first){
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
priority_boost(void){
  struct proc *p;
  
  /** cprintf("[do boosting!]\n"); */

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    p->level_of_MLFQ = 0;
    p->tick_used = 0;
    //
    // Design Docuemtn 1-1-2-2. Reinitializing time_quantum_used
    p->time_quantum_used = 0;


    ptable.MLFQ_tick_used = 0;
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

  if (proc->tid != 0 || proc->num_of_threads != 0) {
    cprintf("(set_cpu_share) set_cpu_share() is called in a thread. This is not yet implemented.\n");
    return -1;
  }

  // function argument is not valid
  if( ! (MIN_CPU_SHARE <= required && required <= MAX_CPU_SHARE) ) 
    goto exception;
  
  // Check whether a process is already in the stride queue
  cpu_share_already_set = proc->cpu_share;
  if(cpu_share_already_set == 0){
    is_new = 1;
  }else{
    is_new = 0;
  }

  desired_sum_cpu_share = ptable.sum_cpu_share - cpu_share_already_set + required;
  // If a required cpu share is too much, an exception occurs.
  if(desired_sum_cpu_share > MAX_CPU_SHARE )
    goto exception;

  // It is okay to set cpu_share
  ptable.sum_cpu_share = desired_sum_cpu_share;
  proc->cpu_share = required;
  proc->stride = NSTRIDE / required;

  if(is_new){
    // Priority Queue Push
    // We do not need to check whether the stride queue is full because process cannot be generated more than 64

    // new process's stride_count should be minimum of a stride_count in the queue for preventing schuelder from being monopolized.
    if(ptable.stride_queue[1]){
      proc->stride_count = ptable.stride_queue[1]->stride_count;
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
    while(idx != 1){
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
      idx /= 2;
    }
    ptable.stride_queue[idx] = proc;
  }else{
    // if a process is already in the stride queue,
    // do nothing.
  }
  return 0;

exception:
  return -1;
}

int
sys_set_cpu_share(void) 
{
  int required;
  //Decode argument using argint
  if(argint(0, &required) < 0){
    return -1;
  }

  return set_cpu_share(required);
}

int
thread_create(thread_t * thread, void * (*start_routine)(void *), void *arg)
{
  // fork() and exec() is combined.
  int i;
  struct proc *np;
  void** arg_ptr;

  // Allocate process.
  // thread. new stack is needed
  if((np = allocproc()) == 0){
#ifdef THREAD_DEBUGGING
    cprintf("(thread_create) error: allocproc()\n");
#endif
    return -1;
  }

  // add thread information
  np->pid = proc->pid;
  np->tid = next_thread_id++;
  *thread = np->tid;

  // Shallow copy pgdir
  np->pgdir = proc->pgdir; // same address space
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // increase pgdir_ref counter
  np->pgdir_ref_idx= proc->pgdir_ref_idx;
  acquire(&thread_lock);
  pgdir_ref[np->pgdir_ref_idx]++;
  release(&thread_lock);

  // Clear %eax so that pthread_create returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));

  // allocate a new stack
  acquire(&thread_lock);
  np->sz = proc->sz;
  np->sz = PGROUNDUP(np->sz);
  if((np->sz = allocuvm(np->pgdir, np->sz, np->sz + 2*PGSIZE)) == 0) {
#ifdef THREAD_DEBUGGING
    cprintf("(thread_create) error: allocuvm()\n");
    cprintf("** debugging information **\n");
    cprintf("  proc->sz:%d\n", proc->sz);
    // how to decrease parent process's sz?
#endif
    return -1;
  }
  clearpteu(np->pgdir, (char*)(np->sz - 2*PGSIZE));

#ifdef THREAD_DEBUGGING
  cprintf("(thread_create) pname:%s, pid:%d, tid:%d, proc->sz:%d, np->sz:%d\n", proc->name, proc->pid, proc->tid, proc->sz, np->sz);
#endif

  // there should be a space for sbkr(). 2*PGSIZE
  proc->sz = np->sz + 2*PGSIZE;

  // increase the counter of master threads
  if (proc->tid == 0) {
    proc->num_of_threads++;
  } else {
    proc->parent->num_of_threads++;
  }
  release(&thread_lock);

  // edit return address to run desiganted function
  np->tf->eip = (uint)start_routine; // run a rountine.
  np->tf->esp = np->sz - 8;

  arg_ptr = (void**)(np->tf->esp);
  *arg_ptr = (void*)0xDEADDEAD; // fake return address

  arg_ptr = (void**)(np->tf->esp + 4);
  *arg_ptr = arg; // argument

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  //Design Document 1-1-2-5. A new process is generated.

  release(&ptable.lock);

  return 0;
}


int
sys_thread_create(void)
{
  thread_t * thread;
  void * (*start_routine)(void *);
  void * arg;

  if(argptr(0, (char**)&thread, sizeof(thread)) < 0){
    return -1;
  }
  if(argptr(1, (char**)&start_routine, sizeof(start_routine)) < 0){
    return -1;
  }
  if(argptr(2, (char**)&arg, sizeof(arg)) < 0){
    return -1;
  }

  return thread_create(thread, start_routine, arg);
}

void
thread_exit(void *retval)
{
  struct proc *p;
  int fd;

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
  // save a return value in proc
  proc->thread_return = retval;

  // delete a process in stride queue
  if(proc->cpu_share != 0){
    stride_queue_delete();
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

  return;
}

int
sys_thread_exit(void)
{
  void *retval;
  if(argptr(0, (char**)&retval, sizeof(retval)) < 0){
    return -1;
  }

  thread_exit(retval);
  return 0;
}

void
remove_thread_stack(struct proc* p) {
  if (p == 0) {
    panic("p should not be a zero.\n");
  }

  if (pgdir_ref[p->pgdir_ref_idx] > 1) {
    int newsz;
#ifdef THREAD_DEBUGGING
    /** cprintf("** deallocuvm to free thread stack. **\n"); */
#endif
    // if deallocated sz is smaller than parent's sz, update it.
    // But here is still a problem.
    // For example, there are two thread.
    // First thread is deallocated, and two thread are added.
    // Then the fourth thread will use a same stack with second one.
    // How can I solve this?
    newsz = deallocuvm(p->pgdir, p->sz, p->sz - 2*PGSIZE);
    p->parent->sz = newsz < p->parent->sz ? newsz : p->parent->sz;
  }
  acquire(&thread_lock);
  // the master thread should wait until all of its threads die.
  p->parent->num_of_threads--;
  release(&thread_lock);
}

int
thread_join(thread_t thread, void **retval)
{
  struct proc *p;
  int havekids;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc || p->tid != thread)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        *retval = p->thread_return;

        // when pgdir is not freed, we should call deallocuvm to remove thread stack.
        remove_thread_stack(p);
        clear_proc(p);


        release(&ptable.lock);
        return 0;
      }
    }

    // No point waiting if we don't have any threads.
    if(!havekids || proc->killed){
#ifdef THREAD_DEBUGGING
      cprintf("(thread_join) thread resources is not cleared.\n");
#endif
      release(&ptable.lock);
      return -1;
    }

    // Wait for threads to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }

  return 0;
}

int
sys_thread_join(void)
{
  thread_t thread;
  void **retval;

  if(argint(0, (int*)&thread) < 0){
    return -1;
  }
  if(argptr(1, (char**)&retval, sizeof(retval)) < 0){
    return -1;
  }

  return thread_join(thread, retval);
}

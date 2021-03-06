// Per-CPU state
struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?

  // Cpu-local storage variables; see below
  struct cpu *cpu;
  struct proc *proc;           // The currently-running process.
};

extern struct cpu cpus[NCPU];
extern int ncpu;

// Per-CPU variables, holding pointers to the
// current cpu and to the current process.
// The asm suffix tells gcc to use "%gs:0" to refer to cpu
// and "%gs:4" to refer to proc.  seginit sets up the
// %gs segment register so that %gs refers to the memory
// holding those two variables in the local cpu's struct cpu.
// This is similar to how thread-local variables are implemented
// in thread libraries such as Linux pthreads.
extern struct cpu *cpu asm("%gs:0");       // &cpus[cpunum()]
extern struct proc *proc asm("%gs:4");     // cpus[cpunum()].proc

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)

  // Design Document 1-1-2-2
  int tick_used;               // It is increased at every tick. Reinitialized in priority_boost()
  int time_quantum_used;       // It is increased at every tick. Reinitialized in yield()
  int level_of_MLFQ;           // level of MLFQ a process belong to. Default is zero.

  // Design Document 1-2-2-2
  int cpu_share;               // If it is zero, MLFQ. If it is not zero, stride queue.
  int stride;                  // It means a stride a process can pass
  int stride_count;            // Sum of passed strides.

  // Design Document 2-1-2-3
  thread_t tid;                // thread id
  int pgdir_ref_idx;           // page table reference counter idx
  void* thread_return;         // a variable used to return in thread

  // Design Document 2-2-2-3
  int num_of_threads;          // only a master thread has its value which is not zero.
                               // (tid == 0 && num_of_threads == 0) -> a process
                               // (tid == 0 && num_of_threads != 0) -> a master thread
                               // (tid != 0 && num_of_threads == 0) -> a thread
                               // (tid != 0 && num_of_threads != 0) -> no existing case

  struct proc* proc_forked_in_thread; // it is used in wait() to wait a new generatd thread.
  int original_cpu_share;      // This is the sum of cpu_shares of threads.
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap

#include "types.h"
#include "stat.h"
#include "user.h"
/** 
  * int
  * main(int argc, char *argv[])
  * {
  *     printf(1, "My pid is %d\n", getpid());
  *     printf(1, "My ppid is %d\n", getppid());
  *     exit();
  * } */

/** int
  * main(int argc, char *argv[]) {
  *     __asm__("int $128");
  *     exit();
  * } */


/** // num_of_threads counter test
  * #define N_THREAD 10
  * void* infinite_thread(void *arg) {
  *   printf(1, " ** I am a %dth infinite thread. ** \n", (int)arg);
  *   while(1);
  *   thread_exit(0);
  * }
  *
  * void* finite_thread(void *arg) {
  *   printf(1, " ** I am a %dth finite thread. ** \n", (int)arg);
  *   thread_exit(0);
  * }
  *
  * void* exit_calling_thread(void *arg) {
  *   printf(1, " **** I am a thread calling exit()!! ****\n");
  *   printf(1, " **** My pid:%d, tid:%d, ****\n", getpid(), gettid());
  *   exit();
  * }
  *
  * int
  * main(int argc, char *argv[])
  * {
  *   thread_t inf_tids[N_THREAD];
  *   thread_t f_tids[N_THREAD];
  *   thread_t exit_tid;
  *   int i;
  *   for (i = 0; i < N_THREAD; ++i) {
  *     thread_create(&inf_tids[i], infinite_thread, (void*)i);
  *   }
  *   for (i = 0; i < N_THREAD; ++i) {
  *     thread_create(&f_tids[i], finite_thread, (void*)i);
  *   }
  *
  *   for (i = 0; i < N_THREAD; ++i) {
  *     thread_join(f_tids[i], (void**)0);
  *     printf(1, "f_tids[%d] is end.\n", i);
  *   }
  *
  *   thread_create(&exit_tid, exit_calling_thread, (void*)0);
  *
  *   while(1);
  *   exit();
  *
  *   for (i = 0; i < N_THREAD; ++i) {
  *     thread_join(inf_tids[i], (void**)0);
  *     printf(1, "inf_tids[%d] is end.\n", i);
  *   }
  *
  *
  *   exit();
  * } */




#define N_THREAD 1
void* infinite_thread(void *arg) {
  printf(1, " ** I am a %dth infinite thread. ** \n", (int)arg);
  while(1);
  thread_exit(0);
}

void* finite_thread(void *arg) {
  printf(1, " ** I am a %dth finite thread. ** \n", (int)arg);
  thread_exit(0);
}

void* fork_calling_thread(void *arg) {
  int pid;
  if ((pid = fork()) == -1){
    printf(1, "panic at fork in forktest\n");
    exit();
  } else if (pid == 0){
    printf(1, "child\n");
    exit();
  } else{
    printf(1, "parent\n");
    if (wait() == -1){
      printf(1, "panic at wait in forktest\n");
      exit();
    }
    printf(1, "parent wait() end\n");
  }
  thread_exit(0);
}

void* exit_calling_thread(void *arg) {
  printf(1, " **** I am a thread calling exit()!! ****\n");
  printf(1, " **** My pid:%d, tid:%d, ****\n", getpid(), gettid());
  exit();
}

int
main(int argc, char *argv[])
{
  /** thread_t inf_tids[N_THREAD]; */
  thread_t f_tids[N_THREAD];
  /** thread_t exit_tid; */
  int i;
  for (i = 0; i < N_THREAD; ++i) {
    thread_create(&f_tids[i], fork_calling_thread, (void*)i);
  }

  for (i = 0; i < N_THREAD; ++i) {
    thread_join(f_tids[i], (void**)0);
    printf(1, "f_tids[%d] is end.\n", i);
  }
  
  exit();
}

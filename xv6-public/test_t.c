#include "types.h"
#include "stat.h"
#include "user.h"

static volatile int counter = 0;

void *
mythread(void *arg)
{
  int i;

  printf(1, "%s: begin\n", (char *) arg);
  for (i = 0; i < 1e7; ++i) {
    counter = counter + 1;
  }
  printf(1, "%s: done\n", (char *) arg);

  thread_exit(0);
}

void * 
disturbing(void *arg)
{
  int j, k, l;
  int temp;
  l = k = j = -210000000;
  temp = l + k + j;
  temp++;
  for (j = 0; j < 1e7; ++j) {
    k = k + 1;
  }
  thread_exit(0);
}

int
main(int argc, char *argv[])
{
  thread_t p1;
  thread_t p2;
  thread_t p3;
  thread_t p4;
  thread_t p5;
  
  printf(1, "main: begin (counter = %d)\n", counter);
  thread_create(&p1, mythread, "A");
  thread_create(&p3, disturbing, 0);
  thread_create(&p2, mythread, "B");
  thread_create(&p4, disturbing, 0);
  thread_create(&p5, disturbing, 0);

  thread_join(p1, 0);
  thread_join(p3, 0);
  thread_join(p2, 0);
  thread_join(p4, 0);
  thread_join(p5, 0);
  printf(1, "main: done with both (counter = %d)\n", counter);
  exit();
}

/** void * start_routine(void * arg) {
  *   int i;
  *   int n = (int)arg;
  *
  *   for (i = 0; i < 2; ++i) {
  *     printf(0, "** Thread. I am running!, arg:%d, pid:%d, tid:%d, ppid:%d **\n", n, getpid(),gettid(), getppid());
  *   }
  *
  *   thread_exit(0);
  *   return (void*)0xEFEFEFEF;
  * }
  *
  * int
  * main(int argc, char *argv[])
  * {
  *   thread_t thread = 200;
  *   int a = 10000;
  *   int* return_value = 0;
  *
  *   printf(1, "(main)a:%d\n", a);
  *
  *   thread_create(&thread, start_routine, (void*)a);
  *   thread_join(thread, (void**)&return_value);
  *
  *   printf(1, "(main)start_routine: %p\n", start_routine);
  *   printf(1, "(main)return_value: %d\n", return_value);
  *   printf(1, "(main)ppid: %d, pid: %d\n", getppid(), getpid());
  *
  *   printf(1, "(main)a:%d\n", a);
  *
  *   exit();
  * } */

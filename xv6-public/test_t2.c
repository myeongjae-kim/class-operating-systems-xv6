#include "types.h"
#include "stat.h"
#include "user.h"

void * start_routine(void * arg) {
  int i;
  int n = (int)arg;

  for (i = 0; i < 2; ++i) {
    printf(0, "** Thread. I am running!, arg:%d, pid:%d, tid:%d, ppid:%d **\n", n, getpid(),gettid(), getppid());
  }

  thread_exit(0);
  return (void*)0xEFEFEFEF;
}

int
main(int argc, char *argv[])
{
  thread_t thread = 200;
  int a = 10000;
  int* return_value = 0;

  printf(1, "(main)a:%d\n", a);

  thread_create(&thread, start_routine, (void*)a);
  thread_join(thread, (void**)&return_value);

  printf(1, "(main)start_routine: %p\n", start_routine);
  printf(1, "(main)return_value: %d\n", return_value);
  printf(1, "(main)ppid: %d, pid: %d\n", getppid(), getpid());

  printf(1, "(main)a:%d\n", a);

  exit();
}

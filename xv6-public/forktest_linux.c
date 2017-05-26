#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>
#include <sys/wait.h>
#include <sys/types.h>

#define NUM_THREAD 10
#define NTEST 15

int forktest(void);

int (*testfunc[NTEST])(void) = {
  forktest,
};

char *testname[NTEST] = {
  "forktest",
};

int gcnt;
int gpipe[2];

int
main(int argc, char *argv[])
{
  int i;
  int ret;
  int pid;
  int start = 0;
  int end = NTEST-1;
  if (argc >= 2)
    start = atoi(argv[1]);
  if (argc >= 3)
    end = atoi(argv[2]);

  for (i = start; i <= end; i++){
    printf("%d. %s start\n", i, testname[i]);
    if (pipe(gpipe) < 0){
      printf("pipe panic\n");
      exit(0);
    }
    ret = 0;

    if ((pid = fork()) < 0){
      printf("fork panic\n");
      exit(0);
    }
    if (pid == 0){
      close(gpipe[0]);
      ret = testfunc[i]();
      write(gpipe[1], (char*)&ret, sizeof(ret));
      close(gpipe[1]);
      exit(0);
    } else{
      close(gpipe[1]);
      if (wait(0) == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
        printf("%d. %s panic\n", i, testname[i]);
        exit(0);
      }
      close(gpipe[0]);
    }
    printf("%d. %s finish\n", i, testname[i]);
    sleep(100);
  }
  exit(0);
}


void*
forkthreadmain(void *arg)
{
  int pid;
  if ((pid = fork()) == -1){
    printf( "panic at fork in forktest\n");
    exit(0);
  } else if (pid == 0){
    printf( "child pid:%d, tid:%x, parent pid:%d\n",getpid(), (int)pthread_self(), getppid());
    exit(0);
  } else{
    printf( "parent pid:%d, tid:%x\n", getpid(), (int)pthread_self());
    if (wait(0) == -1){
      printf( "panic at wait in forktest\n");
      exit(0);
    }
  }
  pthread_exit(0);
}

int
forktest(void)
{
  pthread_t threads[NUM_THREAD];
  int i;
  void *retval;

  for (i = 0; i < NUM_THREAD; i++){
    if (pthread_create(&threads[i], NULL, forkthreadmain, (void*)0) != 0){
      printf( "panic at pthread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (pthread_join(threads[i], &retval) != 0){
      printf( "panic at pthread_join\n");
      return -1;
    }
  }
  return 0;
}

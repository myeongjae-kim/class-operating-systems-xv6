#include <stdio.h>
#include <pthread.h>

#define NUM_THREAD      10
#define NUM_INCREASE    1000000

int cnt_global = 0;


void *ThreadFunc(void *arg) {
    int i;
    long cnt_local = 0;

    for (i = 0; i < NUM_INCREASE; i++) {
        /* Fill Here */
      cnt_global++;
      cnt_local++;
    }

    return (void *)cnt_local; // == pthread_exit((void *) cnt_local);
}

int main(int argc, const char *argv[])
{
    int i;
    pthread_t threads[NUM_THREAD];

    for (i = 0; i < NUM_THREAD; i++) {
        pthread_create(&threads[i], NULL, ThreadFunc, NULL);
    }

    long ret;
    for (i = 0; i < NUM_THREAD; i++) {
        /* Fill Here */
        pthread_join(threads[i], (void**)&ret);
        printf("thread %lu, local count: %ld\n", threads[i], (long)ret);
    }

    printf("global count: %d\n", cnt_global);
    
    return 0;
}

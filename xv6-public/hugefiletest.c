#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

#define ITER 1024

int
main(int argc, char *argv[])
{
  int fd, i, j; 
  int r;
  int total;
  char *path = (argc > 1) ? argv[1] : "hugefile";
  char data[512];
  char buf[512];

  printf(1, "hugefiletest starting\n");
  const int sz = sizeof(data);
  for (i = 0; i < sz; i++) {
      data[i] = i % 128;
  }

  printf(1, "1. create test\n");
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < ITER; i++){
    if (i % 100 == 0){
      printf(1, "%d bytes written\n", i * 512);
    }
    if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
      printf(1, "write returned %d : failed\n", r);
      exit();
    }
  }
  printf(1, "%d bytes written\n", ITER * 512);
  close(fd);

  printf(1, "2. read test\n");
  fd = open(path, O_RDONLY);
  for (i = 0; i < ITER; i++){
    if (i % 100 == 0){
      printf(1, "%d bytes read\n", i * 512);
    }
    if ((r = read(fd, buf, sizeof(data))) != sizeof(data)){
      printf(1, "read returned %d : failed\n", r);
      exit();
    }
    for (j = 0; j < sz; j++) {
      if (buf[j] != data[j]) {
        printf(1, "data inconsistency detected\n");
        exit();
      }
    }
  }
  printf(1, "%d bytes read\n", ITER* 512);
  close(fd);

  printf(1, "3. stress test\n");
  total = 0;
  for (i = 0; i < 20; i++) {
    printf(1, "stress test...%d \n", i);
    if(unlink(path) < 0){
      printf(1, "rm: %s failed to delete\n", path);
      exit();
    }
    printf(1, "unlin() success.\n");
    
    fd = open(path, O_CREATE | O_RDWR);
      for(j = 0; j < ITER; j++){
        if (j % 100 == 0){
          printf(1, "%d bytes totally written\n", total);
        }
        if ((r = write(fd, data, sizeof(data))) != sizeof(data)){
          printf(1, "write returned %d : failed\n", r);
          exit();
        }
        total += sizeof(data);
      }
      printf(1, "%d bytes written\n", total);
    close(fd);
  }

  exit();
}

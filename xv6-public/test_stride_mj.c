#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
  int i, j;

  printf(1, "set_cpu_share(0): return: %d\n", set_cpu_share(0));
  printf(1, "set_cpu_share(81): return: %d\n", set_cpu_share(81));
  printf(1, "set_cpu_share(50): return: %d\n", set_cpu_share(50));
  printf(1, "set_cpu_share(80): return: %d\n", set_cpu_share(80));

  for (i = 0; i < 1000; ++i) {
    for (j = 0; j < 500000000; ++j) {
      printf(0, "0");
    }
  }
  exit();
}

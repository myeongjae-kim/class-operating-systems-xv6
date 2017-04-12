#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
  int i;

  printf(1, "set_cpu_share(0): return: %d\n", set_cpu_share(0));
  printf(1, "set_cpu_share(81): return: %d\n", set_cpu_share(81));
  printf(1, "set_cpu_share(50): return: %d\n", set_cpu_share(50));
  printf(1, "set_cpu_share(80): return: %d\n", set_cpu_share(80));

  for (i = 0; i < 1; ++i) {
    printf(0, "0");
  }
  exit();
}

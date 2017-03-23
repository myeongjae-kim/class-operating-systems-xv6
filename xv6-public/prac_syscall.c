#include "types.h"
#include "defs.h"

int
my_syscall(char *str) 
{
    cprintf("%s\n", str);
    return 0xABCDABCD;
}

int
sys_my_syscall(void) 
{
    char *str;
    if (argstr(0, &str) < 0) // wrapper 함수. 커널 내부에 reference가 호출 되고, argument가 user영역에 있는지 체크해주는 함수.
        return -1;
    return my_syscall(str);
}

# Context switch
#
#   void swtch(struct context **old, struct context *new);
#   old는 call by reference. new는 call by value다.
# 
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax # esp는 return address를 가리키고 있다(old). 아직 스택에 아무것도 push가 안됐으므로, return address를 가리킨다.
  movl 8(%esp), %edx # new

  # Save old callee-save registers
  # 아래 push하는 레지스터들은 convention에 따른다.
  # eip는 push하지 않는다. esp를 그냥 eip로 삼겠다는 것.
  pushl %ebp
  pushl %ebx
  pushl %esi
  pushl %edi

  # Switch stacks
  movl %esp, (%eax) # esp의 값을 eax가 가리키고 있는 주소에 넣는다. eax는 old. old가 edi를 가리키게 된다. 즉 old는 old context를 가리키게 된다.
  movl %edx, %esp # edx는 new가 있다. esp에 edx를 넣는다는 것은 새로운 스택을 쓰겠다는 것. 여기서 하나씩 뺴면 new context의 값을 cpu register에 넣는다.

  # Load new callee-save registers
  popl %edi
  popl %esi
  popl %ebx
  popl %ebp
  ret # eip를 빼는 것. ret는 call과 쌍이다. call에서 return address를 넣는다. 맞나? ret를 실행함으로써 eip를 리턴한다? 뺀다?


_test_stride_mj:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  int i;

  printf(1, "set_cpu_share(0): return: %d\n", set_cpu_share(0));
   9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10:	e8 8d 03 00 00       	call   3a2 <set_cpu_share>
  15:	c7 44 24 04 d8 07 00 	movl   $0x7d8,0x4(%esp)
  1c:	00 
  1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  24:	89 44 24 08          	mov    %eax,0x8(%esp)
  28:	e8 43 04 00 00       	call   470 <printf>
  printf(1, "set_cpu_share(81): return: %d\n", set_cpu_share(81));
  2d:	c7 04 24 51 00 00 00 	movl   $0x51,(%esp)
  34:	e8 69 03 00 00       	call   3a2 <set_cpu_share>
  39:	c7 44 24 04 f8 07 00 	movl   $0x7f8,0x4(%esp)
  40:	00 
  41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  48:	89 44 24 08          	mov    %eax,0x8(%esp)
  4c:	e8 1f 04 00 00       	call   470 <printf>
  printf(1, "set_cpu_share(50): return: %d\n", set_cpu_share(50));
  51:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
  58:	e8 45 03 00 00       	call   3a2 <set_cpu_share>
  5d:	c7 44 24 04 18 08 00 	movl   $0x818,0x4(%esp)
  64:	00 
  65:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  70:	e8 fb 03 00 00       	call   470 <printf>
  printf(1, "set_cpu_share(80): return: %d\n", set_cpu_share(80));
  75:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  7c:	e8 21 03 00 00       	call   3a2 <set_cpu_share>
  81:	c7 44 24 04 38 08 00 	movl   $0x838,0x4(%esp)
  88:	00 
  89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  90:	89 44 24 08          	mov    %eax,0x8(%esp)
  94:	e8 d7 03 00 00       	call   470 <printf>

  for (i = 0; i < 1; ++i) {
    printf(0, "0");
  99:	c7 44 24 04 f6 07 00 	movl   $0x7f6,0x4(%esp)
  a0:	00 
  a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a8:	e8 c3 03 00 00       	call   470 <printf>
  }
  exit();
  ad:	e8 30 02 00 00       	call   2e2 <exit>
  b2:	66 90                	xchg   %ax,%ax
  b4:	66 90                	xchg   %ax,%ax
  b6:	66 90                	xchg   %ax,%ax
  b8:	66 90                	xchg   %ax,%ax
  ba:	66 90                	xchg   %ax,%ax
  bc:	66 90                	xchg   %ax,%ax
  be:	66 90                	xchg   %ax,%ax

000000c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 45 08             	mov    0x8(%ebp),%eax
  c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  c9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ca:	89 c2                	mov    %eax,%edx
  cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  d0:	83 c1 01             	add    $0x1,%ecx
  d3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  d7:	83 c2 01             	add    $0x1,%edx
  da:	84 db                	test   %bl,%bl
  dc:	88 5a ff             	mov    %bl,-0x1(%edx)
  df:	75 ef                	jne    d0 <strcpy+0x10>
    ;
  return os;
}
  e1:	5b                   	pop    %ebx
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    
  e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 55 08             	mov    0x8(%ebp),%edx
  f6:	53                   	push   %ebx
  f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  fa:	0f b6 02             	movzbl (%edx),%eax
  fd:	84 c0                	test   %al,%al
  ff:	74 2d                	je     12e <strcmp+0x3e>
 101:	0f b6 19             	movzbl (%ecx),%ebx
 104:	38 d8                	cmp    %bl,%al
 106:	74 0e                	je     116 <strcmp+0x26>
 108:	eb 2b                	jmp    135 <strcmp+0x45>
 10a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 110:	38 c8                	cmp    %cl,%al
 112:	75 15                	jne    129 <strcmp+0x39>
    p++, q++;
 114:	89 d9                	mov    %ebx,%ecx
 116:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 119:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 11c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 11f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 123:	84 c0                	test   %al,%al
 125:	75 e9                	jne    110 <strcmp+0x20>
 127:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 129:	29 c8                	sub    %ecx,%eax
}
 12b:	5b                   	pop    %ebx
 12c:	5d                   	pop    %ebp
 12d:	c3                   	ret    
 12e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 131:	31 c0                	xor    %eax,%eax
 133:	eb f4                	jmp    129 <strcmp+0x39>
 135:	0f b6 cb             	movzbl %bl,%ecx
 138:	eb ef                	jmp    129 <strcmp+0x39>
 13a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000140 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 146:	80 39 00             	cmpb   $0x0,(%ecx)
 149:	74 12                	je     15d <strlen+0x1d>
 14b:	31 d2                	xor    %edx,%edx
 14d:	8d 76 00             	lea    0x0(%esi),%esi
 150:	83 c2 01             	add    $0x1,%edx
 153:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 157:	89 d0                	mov    %edx,%eax
 159:	75 f5                	jne    150 <strlen+0x10>
    ;
  return n;
}
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 15d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    
 161:	eb 0d                	jmp    170 <memset>
 163:	90                   	nop
 164:	90                   	nop
 165:	90                   	nop
 166:	90                   	nop
 167:	90                   	nop
 168:	90                   	nop
 169:	90                   	nop
 16a:	90                   	nop
 16b:	90                   	nop
 16c:	90                   	nop
 16d:	90                   	nop
 16e:	90                   	nop
 16f:	90                   	nop

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 55 08             	mov    0x8(%ebp),%edx
 176:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	89 d7                	mov    %edx,%edi
 17f:	fc                   	cld    
 180:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 182:	89 d0                	mov    %edx,%eax
 184:	5f                   	pop    %edi
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    
 187:	89 f6                	mov    %esi,%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	53                   	push   %ebx
 197:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 19a:	0f b6 18             	movzbl (%eax),%ebx
 19d:	84 db                	test   %bl,%bl
 19f:	74 1d                	je     1be <strchr+0x2e>
    if(*s == c)
 1a1:	38 d3                	cmp    %dl,%bl
 1a3:	89 d1                	mov    %edx,%ecx
 1a5:	75 0d                	jne    1b4 <strchr+0x24>
 1a7:	eb 17                	jmp    1c0 <strchr+0x30>
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1b0:	38 ca                	cmp    %cl,%dl
 1b2:	74 0c                	je     1c0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1b4:	83 c0 01             	add    $0x1,%eax
 1b7:	0f b6 10             	movzbl (%eax),%edx
 1ba:	84 d2                	test   %dl,%dl
 1bc:	75 f2                	jne    1b0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 1be:	31 c0                	xor    %eax,%eax
}
 1c0:	5b                   	pop    %ebx
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    
 1c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 1d7:	53                   	push   %ebx
 1d8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1db:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1de:	eb 31                	jmp    211 <gets+0x41>
    cc = read(0, &c, 1);
 1e0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1e7:	00 
 1e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1f3:	e8 02 01 00 00       	call   2fa <read>
    if(cc < 1)
 1f8:	85 c0                	test   %eax,%eax
 1fa:	7e 1d                	jle    219 <gets+0x49>
      break;
    buf[i++] = c;
 1fc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 200:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 202:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 205:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 207:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 20b:	74 0c                	je     219 <gets+0x49>
 20d:	3c 0a                	cmp    $0xa,%al
 20f:	74 08                	je     219 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 211:	8d 5e 01             	lea    0x1(%esi),%ebx
 214:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 217:	7c c7                	jl     1e0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 220:	83 c4 2c             	add    $0x2c,%esp
 223:	5b                   	pop    %ebx
 224:	5e                   	pop    %esi
 225:	5f                   	pop    %edi
 226:	5d                   	pop    %ebp
 227:	c3                   	ret    
 228:	90                   	nop
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000230 <stat>:

int
stat(char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	56                   	push   %esi
 234:	53                   	push   %ebx
 235:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 242:	00 
 243:	89 04 24             	mov    %eax,(%esp)
 246:	e8 d7 00 00 00       	call   322 <open>
  if(fd < 0)
 24b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 24f:	78 27                	js     278 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 251:	8b 45 0c             	mov    0xc(%ebp),%eax
 254:	89 1c 24             	mov    %ebx,(%esp)
 257:	89 44 24 04          	mov    %eax,0x4(%esp)
 25b:	e8 da 00 00 00       	call   33a <fstat>
  close(fd);
 260:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 263:	89 c6                	mov    %eax,%esi
  close(fd);
 265:	e8 a0 00 00 00       	call   30a <close>
  return r;
 26a:	89 f0                	mov    %esi,%eax
}
 26c:	83 c4 10             	add    $0x10,%esp
 26f:	5b                   	pop    %ebx
 270:	5e                   	pop    %esi
 271:	5d                   	pop    %ebp
 272:	c3                   	ret    
 273:	90                   	nop
 274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 27d:	eb ed                	jmp    26c <stat+0x3c>
 27f:	90                   	nop

00000280 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 4d 08             	mov    0x8(%ebp),%ecx
 286:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	0f be 11             	movsbl (%ecx),%edx
 28a:	8d 42 d0             	lea    -0x30(%edx),%eax
 28d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 28f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 294:	77 17                	ja     2ad <atoi+0x2d>
 296:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 298:	83 c1 01             	add    $0x1,%ecx
 29b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 29e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a2:	0f be 11             	movsbl (%ecx),%edx
 2a5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2a8:	80 fb 09             	cmp    $0x9,%bl
 2ab:	76 eb                	jbe    298 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 2ad:	5b                   	pop    %ebx
 2ae:	5d                   	pop    %ebp
 2af:	c3                   	ret    

000002b0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	56                   	push   %esi
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	53                   	push   %ebx
 2ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2bd:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c0:	85 db                	test   %ebx,%ebx
 2c2:	7e 12                	jle    2d6 <memmove+0x26>
 2c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2cf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d2:	39 da                	cmp    %ebx,%edx
 2d4:	75 f2                	jne    2c8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 2d6:	5b                   	pop    %ebx
 2d7:	5e                   	pop    %esi
 2d8:	5d                   	pop    %ebp
 2d9:	c3                   	ret    

000002da <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2da:	b8 01 00 00 00       	mov    $0x1,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <exit>:
SYSCALL(exit)
 2e2:	b8 02 00 00 00       	mov    $0x2,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <wait>:
SYSCALL(wait)
 2ea:	b8 03 00 00 00       	mov    $0x3,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <pipe>:
SYSCALL(pipe)
 2f2:	b8 04 00 00 00       	mov    $0x4,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <read>:
SYSCALL(read)
 2fa:	b8 05 00 00 00       	mov    $0x5,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <write>:
SYSCALL(write)
 302:	b8 10 00 00 00       	mov    $0x10,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <close>:
SYSCALL(close)
 30a:	b8 15 00 00 00       	mov    $0x15,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <kill>:
SYSCALL(kill)
 312:	b8 06 00 00 00       	mov    $0x6,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <exec>:
SYSCALL(exec)
 31a:	b8 07 00 00 00       	mov    $0x7,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <open>:
SYSCALL(open)
 322:	b8 0f 00 00 00       	mov    $0xf,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <mknod>:
SYSCALL(mknod)
 32a:	b8 11 00 00 00       	mov    $0x11,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <unlink>:
SYSCALL(unlink)
 332:	b8 12 00 00 00       	mov    $0x12,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <fstat>:
SYSCALL(fstat)
 33a:	b8 08 00 00 00       	mov    $0x8,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <link>:
SYSCALL(link)
 342:	b8 13 00 00 00       	mov    $0x13,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <mkdir>:
SYSCALL(mkdir)
 34a:	b8 14 00 00 00       	mov    $0x14,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <chdir>:
SYSCALL(chdir)
 352:	b8 09 00 00 00       	mov    $0x9,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <dup>:
SYSCALL(dup)
 35a:	b8 0a 00 00 00       	mov    $0xa,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <getpid>:
SYSCALL(getpid)
 362:	b8 0b 00 00 00       	mov    $0xb,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <sbrk>:
SYSCALL(sbrk)
 36a:	b8 0c 00 00 00       	mov    $0xc,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <sleep>:
SYSCALL(sleep)
 372:	b8 0d 00 00 00       	mov    $0xd,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <uptime>:
SYSCALL(uptime)
 37a:	b8 0e 00 00 00       	mov    $0xe,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <my_syscall>:
SYSCALL(my_syscall)
 382:	b8 16 00 00 00       	mov    $0x16,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <getppid>:
SYSCALL(getppid)
 38a:	b8 17 00 00 00       	mov    $0x17,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <yield>:
SYSCALL(yield)
 392:	b8 18 00 00 00       	mov    $0x18,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <getlev>:
SYSCALL(getlev)
 39a:	b8 19 00 00 00       	mov    $0x19,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <set_cpu_share>:
SYSCALL(set_cpu_share)
 3a2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <thread_create>:
SYSCALL(thread_create)
 3aa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <thread_exit>:
SYSCALL(thread_exit)
 3b2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <thread_join>:
SYSCALL(thread_join)
 3ba:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <gettid>:
SYSCALL(gettid)
 3c2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    
 3ca:	66 90                	xchg   %ax,%ax
 3cc:	66 90                	xchg   %ax,%ax
 3ce:	66 90                	xchg   %ax,%ax

000003d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	89 c6                	mov    %eax,%esi
 3d7:	53                   	push   %ebx
 3d8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3db:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3de:	85 db                	test   %ebx,%ebx
 3e0:	74 09                	je     3eb <printint+0x1b>
 3e2:	89 d0                	mov    %edx,%eax
 3e4:	c1 e8 1f             	shr    $0x1f,%eax
 3e7:	84 c0                	test   %al,%al
 3e9:	75 75                	jne    460 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3eb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ed:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3f4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3f7:	31 ff                	xor    %edi,%edi
 3f9:	89 ce                	mov    %ecx,%esi
 3fb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3fe:	eb 02                	jmp    402 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 400:	89 cf                	mov    %ecx,%edi
 402:	31 d2                	xor    %edx,%edx
 404:	f7 f6                	div    %esi
 406:	8d 4f 01             	lea    0x1(%edi),%ecx
 409:	0f b6 92 5f 08 00 00 	movzbl 0x85f(%edx),%edx
  }while((x /= base) != 0);
 410:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 412:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 415:	75 e9                	jne    400 <printint+0x30>
  if(neg)
 417:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 41a:	89 c8                	mov    %ecx,%eax
 41c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 41f:	85 d2                	test   %edx,%edx
 421:	74 08                	je     42b <printint+0x5b>
    buf[i++] = '-';
 423:	8d 4f 02             	lea    0x2(%edi),%ecx
 426:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 42b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 42e:	66 90                	xchg   %ax,%ax
 430:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 435:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 438:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 43f:	00 
 440:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 444:	89 34 24             	mov    %esi,(%esp)
 447:	88 45 d7             	mov    %al,-0x29(%ebp)
 44a:	e8 b3 fe ff ff       	call   302 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 44f:	83 ff ff             	cmp    $0xffffffff,%edi
 452:	75 dc                	jne    430 <printint+0x60>
    putc(fd, buf[i]);
}
 454:	83 c4 4c             	add    $0x4c,%esp
 457:	5b                   	pop    %ebx
 458:	5e                   	pop    %esi
 459:	5f                   	pop    %edi
 45a:	5d                   	pop    %ebp
 45b:	c3                   	ret    
 45c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 460:	89 d0                	mov    %edx,%eax
 462:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 464:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 46b:	eb 87                	jmp    3f4 <printint+0x24>
 46d:	8d 76 00             	lea    0x0(%esi),%esi

00000470 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 474:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 476:	56                   	push   %esi
 477:	53                   	push   %ebx
 478:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 47b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 47e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 481:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 484:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 487:	0f b6 13             	movzbl (%ebx),%edx
 48a:	83 c3 01             	add    $0x1,%ebx
 48d:	84 d2                	test   %dl,%dl
 48f:	75 39                	jne    4ca <printf+0x5a>
 491:	e9 c2 00 00 00       	jmp    558 <printf+0xe8>
 496:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 498:	83 fa 25             	cmp    $0x25,%edx
 49b:	0f 84 bf 00 00 00    	je     560 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4ab:	00 
 4ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4b3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4b6:	e8 47 fe ff ff       	call   302 <write>
 4bb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4be:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4c2:	84 d2                	test   %dl,%dl
 4c4:	0f 84 8e 00 00 00    	je     558 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 4ca:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4cc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 4cf:	74 c7                	je     498 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d1:	83 ff 25             	cmp    $0x25,%edi
 4d4:	75 e5                	jne    4bb <printf+0x4b>
      if(c == 'd'){
 4d6:	83 fa 64             	cmp    $0x64,%edx
 4d9:	0f 84 31 01 00 00    	je     610 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4df:	25 f7 00 00 00       	and    $0xf7,%eax
 4e4:	83 f8 70             	cmp    $0x70,%eax
 4e7:	0f 84 83 00 00 00    	je     570 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4ed:	83 fa 73             	cmp    $0x73,%edx
 4f0:	0f 84 a2 00 00 00    	je     598 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4f6:	83 fa 63             	cmp    $0x63,%edx
 4f9:	0f 84 35 01 00 00    	je     634 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ff:	83 fa 25             	cmp    $0x25,%edx
 502:	0f 84 e0 00 00 00    	je     5e8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 508:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 50b:	83 c3 01             	add    $0x1,%ebx
 50e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 515:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 516:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 518:	89 44 24 04          	mov    %eax,0x4(%esp)
 51c:	89 34 24             	mov    %esi,(%esp)
 51f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 522:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 526:	e8 d7 fd ff ff       	call   302 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 52b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 52e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 531:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 538:	00 
 539:	89 44 24 04          	mov    %eax,0x4(%esp)
 53d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 540:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 543:	e8 ba fd ff ff       	call   302 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 548:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 54c:	84 d2                	test   %dl,%dl
 54e:	0f 85 76 ff ff ff    	jne    4ca <printf+0x5a>
 554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 558:	83 c4 3c             	add    $0x3c,%esp
 55b:	5b                   	pop    %ebx
 55c:	5e                   	pop    %esi
 55d:	5f                   	pop    %edi
 55e:	5d                   	pop    %ebp
 55f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 560:	bf 25 00 00 00       	mov    $0x25,%edi
 565:	e9 51 ff ff ff       	jmp    4bb <printf+0x4b>
 56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 570:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 573:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 578:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 57a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 581:	8b 10                	mov    (%eax),%edx
 583:	89 f0                	mov    %esi,%eax
 585:	e8 46 fe ff ff       	call   3d0 <printint>
        ap++;
 58a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 58e:	e9 28 ff ff ff       	jmp    4bb <printf+0x4b>
 593:	90                   	nop
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 598:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 59b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 59f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 5a1:	b8 58 08 00 00       	mov    $0x858,%eax
 5a6:	85 ff                	test   %edi,%edi
 5a8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 5ab:	0f b6 07             	movzbl (%edi),%eax
 5ae:	84 c0                	test   %al,%al
 5b0:	74 2a                	je     5dc <printf+0x16c>
 5b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5b8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5bb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 5be:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5c8:	00 
 5c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cd:	89 34 24             	mov    %esi,(%esp)
 5d0:	e8 2d fd ff ff       	call   302 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d5:	0f b6 07             	movzbl (%edi),%eax
 5d8:	84 c0                	test   %al,%al
 5da:	75 dc                	jne    5b8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5dc:	31 ff                	xor    %edi,%edi
 5de:	e9 d8 fe ff ff       	jmp    4bb <printf+0x4b>
 5e3:	90                   	nop
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5e8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5eb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5f4:	00 
 5f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f9:	89 34 24             	mov    %esi,(%esp)
 5fc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 600:	e8 fd fc ff ff       	call   302 <write>
 605:	e9 b1 fe ff ff       	jmp    4bb <printf+0x4b>
 60a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 610:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 613:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 618:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 61b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 622:	8b 10                	mov    (%eax),%edx
 624:	89 f0                	mov    %esi,%eax
 626:	e8 a5 fd ff ff       	call   3d0 <printint>
        ap++;
 62b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 62f:	e9 87 fe ff ff       	jmp    4bb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 634:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 637:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 639:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 63b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 642:	00 
 643:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 646:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 649:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 64c:	89 44 24 04          	mov    %eax,0x4(%esp)
 650:	e8 ad fc ff ff       	call   302 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 655:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 659:	e9 5d fe ff ff       	jmp    4bb <printf+0x4b>
 65e:	66 90                	xchg   %ax,%ax

00000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 661:	a1 d4 0a 00 00       	mov    0xad4,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 666:	89 e5                	mov    %esp,%ebp
 668:	57                   	push   %edi
 669:	56                   	push   %esi
 66a:	53                   	push   %ebx
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 670:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 673:	39 d0                	cmp    %edx,%eax
 675:	72 11                	jb     688 <free+0x28>
 677:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 678:	39 c8                	cmp    %ecx,%eax
 67a:	72 04                	jb     680 <free+0x20>
 67c:	39 ca                	cmp    %ecx,%edx
 67e:	72 10                	jb     690 <free+0x30>
 680:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 682:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 684:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 686:	73 f0                	jae    678 <free+0x18>
 688:	39 ca                	cmp    %ecx,%edx
 68a:	72 04                	jb     690 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68c:	39 c8                	cmp    %ecx,%eax
 68e:	72 f0                	jb     680 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 690:	8b 73 fc             	mov    -0x4(%ebx),%esi
 693:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 696:	39 cf                	cmp    %ecx,%edi
 698:	74 1e                	je     6b8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 69a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 69d:	8b 48 04             	mov    0x4(%eax),%ecx
 6a0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6a3:	39 f2                	cmp    %esi,%edx
 6a5:	74 28                	je     6cf <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6a7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a9:	a3 d4 0a 00 00       	mov    %eax,0xad4
}
 6ae:	5b                   	pop    %ebx
 6af:	5e                   	pop    %esi
 6b0:	5f                   	pop    %edi
 6b1:	5d                   	pop    %ebp
 6b2:	c3                   	ret    
 6b3:	90                   	nop
 6b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6b8:	03 71 04             	add    0x4(%ecx),%esi
 6bb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6be:	8b 08                	mov    (%eax),%ecx
 6c0:	8b 09                	mov    (%ecx),%ecx
 6c2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6c5:	8b 48 04             	mov    0x4(%eax),%ecx
 6c8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6cb:	39 f2                	cmp    %esi,%edx
 6cd:	75 d8                	jne    6a7 <free+0x47>
    p->s.size += bp->s.size;
 6cf:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6d2:	a3 d4 0a 00 00       	mov    %eax,0xad4
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6d7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6da:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6dd:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6df:	5b                   	pop    %ebx
 6e0:	5e                   	pop    %esi
 6e1:	5f                   	pop    %edi
 6e2:	5d                   	pop    %ebp
 6e3:	c3                   	ret    
 6e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000006f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
 6f6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6fc:	8b 1d d4 0a 00 00    	mov    0xad4,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 702:	8d 48 07             	lea    0x7(%eax),%ecx
 705:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 708:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 70a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 70d:	0f 84 9b 00 00 00    	je     7ae <malloc+0xbe>
 713:	8b 13                	mov    (%ebx),%edx
 715:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 718:	39 fe                	cmp    %edi,%esi
 71a:	76 64                	jbe    780 <malloc+0x90>
 71c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 723:	bb 00 80 00 00       	mov    $0x8000,%ebx
 728:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 72b:	eb 0e                	jmp    73b <malloc+0x4b>
 72d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 730:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 732:	8b 78 04             	mov    0x4(%eax),%edi
 735:	39 fe                	cmp    %edi,%esi
 737:	76 4f                	jbe    788 <malloc+0x98>
 739:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 73b:	3b 15 d4 0a 00 00    	cmp    0xad4,%edx
 741:	75 ed                	jne    730 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 746:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 74c:	bf 00 10 00 00       	mov    $0x1000,%edi
 751:	0f 43 fe             	cmovae %esi,%edi
 754:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 757:	89 04 24             	mov    %eax,(%esp)
 75a:	e8 0b fc ff ff       	call   36a <sbrk>
  if(p == (char*)-1)
 75f:	83 f8 ff             	cmp    $0xffffffff,%eax
 762:	74 18                	je     77c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 764:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 767:	83 c0 08             	add    $0x8,%eax
 76a:	89 04 24             	mov    %eax,(%esp)
 76d:	e8 ee fe ff ff       	call   660 <free>
  return freep;
 772:	8b 15 d4 0a 00 00    	mov    0xad4,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 778:	85 d2                	test   %edx,%edx
 77a:	75 b4                	jne    730 <malloc+0x40>
        return 0;
 77c:	31 c0                	xor    %eax,%eax
 77e:	eb 20                	jmp    7a0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 780:	89 d0                	mov    %edx,%eax
 782:	89 da                	mov    %ebx,%edx
 784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 788:	39 fe                	cmp    %edi,%esi
 78a:	74 1c                	je     7a8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 78c:	29 f7                	sub    %esi,%edi
 78e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 791:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 794:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 797:	89 15 d4 0a 00 00    	mov    %edx,0xad4
      return (void*)(p + 1);
 79d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7a0:	83 c4 1c             	add    $0x1c,%esp
 7a3:	5b                   	pop    %ebx
 7a4:	5e                   	pop    %esi
 7a5:	5f                   	pop    %edi
 7a6:	5d                   	pop    %ebp
 7a7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7a8:	8b 08                	mov    (%eax),%ecx
 7aa:	89 0a                	mov    %ecx,(%edx)
 7ac:	eb e9                	jmp    797 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7ae:	c7 05 d4 0a 00 00 d8 	movl   $0xad8,0xad4
 7b5:	0a 00 00 
    base.s.size = 0;
 7b8:	ba d8 0a 00 00       	mov    $0xad8,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7bd:	c7 05 d8 0a 00 00 d8 	movl   $0xad8,0xad8
 7c4:	0a 00 00 
    base.s.size = 0;
 7c7:	c7 05 dc 0a 00 00 00 	movl   $0x0,0xadc
 7ce:	00 00 00 
 7d1:	e9 46 ff ff ff       	jmp    71c <malloc+0x2c>

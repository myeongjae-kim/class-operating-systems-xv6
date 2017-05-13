
_test_t2:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return (void*)0xEFEFEFEF;
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 20             	sub    $0x20,%esp
  thread_t thread = 200;
  int a = 10000;
  int* return_value = 0;

  printf(1, "(main)a:%d\n", a);
   a:	c7 44 24 08 10 27 00 	movl   $0x2710,0x8(%esp)
  11:	00 
  12:	c7 44 24 04 b8 08 00 	movl   $0x8b8,0x4(%esp)
  19:	00 
  1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
}

int
main(int argc, char *argv[])
{
  thread_t thread = 200;
  21:	c7 44 24 18 c8 00 00 	movl   $0xc8,0x18(%esp)
  28:	00 
  int a = 10000;
  int* return_value = 0;
  29:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  30:	00 

  printf(1, "(main)a:%d\n", a);
  31:	e8 da 04 00 00       	call   510 <printf>

  thread_create(&thread, start_routine, (void*)a);
  36:	8d 44 24 18          	lea    0x18(%esp),%eax
  3a:	c7 44 24 08 10 27 00 	movl   $0x2710,0x8(%esp)
  41:	00 
  42:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  49:	00 
  4a:	89 04 24             	mov    %eax,(%esp)
  4d:	e8 f8 03 00 00       	call   44a <thread_create>
  thread_join(thread, (void**)&return_value);
  52:	8d 44 24 1c          	lea    0x1c(%esp),%eax
  56:	89 44 24 04          	mov    %eax,0x4(%esp)
  5a:	8b 44 24 18          	mov    0x18(%esp),%eax
  5e:	89 04 24             	mov    %eax,(%esp)
  61:	e8 f4 03 00 00       	call   45a <thread_join>

  printf(1, "(main)start_routine: %p\n", start_routine);
  66:	c7 44 24 08 f0 00 00 	movl   $0xf0,0x8(%esp)
  6d:	00 
  6e:	c7 44 24 04 c4 08 00 	movl   $0x8c4,0x4(%esp)
  75:	00 
  76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7d:	e8 8e 04 00 00       	call   510 <printf>
  printf(1, "(main)return_value: %d\n", return_value);
  82:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  86:	c7 44 24 04 dd 08 00 	movl   $0x8dd,0x4(%esp)
  8d:	00 
  8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  95:	89 44 24 08          	mov    %eax,0x8(%esp)
  99:	e8 72 04 00 00       	call   510 <printf>
  printf(1, "(main)ppid: %d, pid: %d\n", getppid(), getpid());
  9e:	e8 5f 03 00 00       	call   402 <getpid>
  a3:	89 c3                	mov    %eax,%ebx
  a5:	e8 80 03 00 00       	call   42a <getppid>
  aa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  ae:	c7 44 24 04 f5 08 00 	movl   $0x8f5,0x4(%esp)
  b5:	00 
  b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  c1:	e8 4a 04 00 00       	call   510 <printf>

  printf(1, "(main)a:%d\n", a);
  c6:	c7 44 24 08 10 27 00 	movl   $0x2710,0x8(%esp)
  cd:	00 
  ce:	c7 44 24 04 b8 08 00 	movl   $0x8b8,0x4(%esp)
  d5:	00 
  d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  dd:	e8 2e 04 00 00       	call   510 <printf>

  exit();
  e2:	e8 9b 02 00 00       	call   382 <exit>
  e7:	66 90                	xchg   %ax,%ax
  e9:	66 90                	xchg   %ax,%ax
  eb:	66 90                	xchg   %ax,%ax
  ed:	66 90                	xchg   %ax,%ax
  ef:	90                   	nop

000000f0 <start_routine>:
#include "types.h"
#include "stat.h"
#include "user.h"

void * start_routine(void * arg) {
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
  f4:	56                   	push   %esi
  f5:	53                   	push   %ebx
  int i;
  int n = (int)arg;
  f6:	bb 02 00 00 00       	mov    $0x2,%ebx
#include "types.h"
#include "stat.h"
#include "user.h"

void * start_routine(void * arg) {
  fb:	83 ec 2c             	sub    $0x2c,%esp
  int i;
  int n = (int)arg;

  for (i = 0; i < 2; ++i) {
    printf(0, "** Thread. I am running!, arg:%d, pid:%d, tid:%d, ppid:%d **\n", n, getpid(),gettid(), getppid());
  fe:	e8 27 03 00 00       	call   42a <getppid>
 103:	89 c7                	mov    %eax,%edi
 105:	e8 58 03 00 00       	call   462 <gettid>
 10a:	89 c6                	mov    %eax,%esi
 10c:	e8 f1 02 00 00       	call   402 <getpid>
 111:	89 7c 24 14          	mov    %edi,0x14(%esp)
 115:	89 74 24 10          	mov    %esi,0x10(%esp)
 119:	c7 44 24 04 78 08 00 	movl   $0x878,0x4(%esp)
 120:	00 
 121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 128:	89 44 24 0c          	mov    %eax,0xc(%esp)
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	89 44 24 08          	mov    %eax,0x8(%esp)
 133:	e8 d8 03 00 00       	call   510 <printf>

void * start_routine(void * arg) {
  int i;
  int n = (int)arg;

  for (i = 0; i < 2; ++i) {
 138:	83 eb 01             	sub    $0x1,%ebx
 13b:	75 c1                	jne    fe <start_routine+0xe>
    printf(0, "** Thread. I am running!, arg:%d, pid:%d, tid:%d, ppid:%d **\n", n, getpid(),gettid(), getppid());
  }

  thread_exit(0);
 13d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 144:	e8 09 03 00 00       	call   452 <thread_exit>
  return (void*)0xEFEFEFEF;
}
 149:	83 c4 2c             	add    $0x2c,%esp
 14c:	b8 ef ef ef ef       	mov    $0xefefefef,%eax
 151:	5b                   	pop    %ebx
 152:	5e                   	pop    %esi
 153:	5f                   	pop    %edi
 154:	5d                   	pop    %ebp
 155:	c3                   	ret    
 156:	66 90                	xchg   %ax,%ax
 158:	66 90                	xchg   %ax,%ax
 15a:	66 90                	xchg   %ax,%ax
 15c:	66 90                	xchg   %ax,%ax
 15e:	66 90                	xchg   %ax,%ax

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 169:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16a:	89 c2                	mov    %eax,%edx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 170:	83 c1 01             	add    $0x1,%ecx
 173:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 177:	83 c2 01             	add    $0x1,%edx
 17a:	84 db                	test   %bl,%bl
 17c:	88 5a ff             	mov    %bl,-0x1(%edx)
 17f:	75 ef                	jne    170 <strcpy+0x10>
    ;
  return os;
}
 181:	5b                   	pop    %ebx
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
 184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 18a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 55 08             	mov    0x8(%ebp),%edx
 196:	53                   	push   %ebx
 197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 19a:	0f b6 02             	movzbl (%edx),%eax
 19d:	84 c0                	test   %al,%al
 19f:	74 2d                	je     1ce <strcmp+0x3e>
 1a1:	0f b6 19             	movzbl (%ecx),%ebx
 1a4:	38 d8                	cmp    %bl,%al
 1a6:	74 0e                	je     1b6 <strcmp+0x26>
 1a8:	eb 2b                	jmp    1d5 <strcmp+0x45>
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b0:	38 c8                	cmp    %cl,%al
 1b2:	75 15                	jne    1c9 <strcmp+0x39>
    p++, q++;
 1b4:	89 d9                	mov    %ebx,%ecx
 1b6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1b9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1bc:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1bf:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 1c3:	84 c0                	test   %al,%al
 1c5:	75 e9                	jne    1b0 <strcmp+0x20>
 1c7:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c9:	29 c8                	sub    %ecx,%eax
}
 1cb:	5b                   	pop    %ebx
 1cc:	5d                   	pop    %ebp
 1cd:	c3                   	ret    
 1ce:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1d1:	31 c0                	xor    %eax,%eax
 1d3:	eb f4                	jmp    1c9 <strcmp+0x39>
 1d5:	0f b6 cb             	movzbl %bl,%ecx
 1d8:	eb ef                	jmp    1c9 <strcmp+0x39>
 1da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001e0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1e6:	80 39 00             	cmpb   $0x0,(%ecx)
 1e9:	74 12                	je     1fd <strlen+0x1d>
 1eb:	31 d2                	xor    %edx,%edx
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
 1f0:	83 c2 01             	add    $0x1,%edx
 1f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1f7:	89 d0                	mov    %edx,%eax
 1f9:	75 f5                	jne    1f0 <strlen+0x10>
    ;
  return n;
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 1fd:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    
 201:	eb 0d                	jmp    210 <memset>
 203:	90                   	nop
 204:	90                   	nop
 205:	90                   	nop
 206:	90                   	nop
 207:	90                   	nop
 208:	90                   	nop
 209:	90                   	nop
 20a:	90                   	nop
 20b:	90                   	nop
 20c:	90                   	nop
 20d:	90                   	nop
 20e:	90                   	nop
 20f:	90                   	nop

00000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 55 08             	mov    0x8(%ebp),%edx
 216:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 217:	8b 4d 10             	mov    0x10(%ebp),%ecx
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 d7                	mov    %edx,%edi
 21f:	fc                   	cld    
 220:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 222:	89 d0                	mov    %edx,%eax
 224:	5f                   	pop    %edi
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <strchr>:

char*
strchr(const char *s, char c)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	53                   	push   %ebx
 237:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 23a:	0f b6 18             	movzbl (%eax),%ebx
 23d:	84 db                	test   %bl,%bl
 23f:	74 1d                	je     25e <strchr+0x2e>
    if(*s == c)
 241:	38 d3                	cmp    %dl,%bl
 243:	89 d1                	mov    %edx,%ecx
 245:	75 0d                	jne    254 <strchr+0x24>
 247:	eb 17                	jmp    260 <strchr+0x30>
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 250:	38 ca                	cmp    %cl,%dl
 252:	74 0c                	je     260 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 254:	83 c0 01             	add    $0x1,%eax
 257:	0f b6 10             	movzbl (%eax),%edx
 25a:	84 d2                	test   %dl,%dl
 25c:	75 f2                	jne    250 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 25e:	31 c0                	xor    %eax,%eax
}
 260:	5b                   	pop    %ebx
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <gets>:

char*
gets(char *buf, int max)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 275:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 277:	53                   	push   %ebx
 278:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 27b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27e:	eb 31                	jmp    2b1 <gets+0x41>
    cc = read(0, &c, 1);
 280:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 287:	00 
 288:	89 7c 24 04          	mov    %edi,0x4(%esp)
 28c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 293:	e8 02 01 00 00       	call   39a <read>
    if(cc < 1)
 298:	85 c0                	test   %eax,%eax
 29a:	7e 1d                	jle    2b9 <gets+0x49>
      break;
    buf[i++] = c;
 29c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a0:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 2a2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 2a5:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 2a7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2ab:	74 0c                	je     2b9 <gets+0x49>
 2ad:	3c 0a                	cmp    $0xa,%al
 2af:	74 08                	je     2b9 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b1:	8d 5e 01             	lea    0x1(%esi),%ebx
 2b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2b7:	7c c7                	jl     280 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2c0:	83 c4 2c             	add    $0x2c,%esp
 2c3:	5b                   	pop    %ebx
 2c4:	5e                   	pop    %esi
 2c5:	5f                   	pop    %edi
 2c6:	5d                   	pop    %ebp
 2c7:	c3                   	ret    
 2c8:	90                   	nop
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002d0 <stat>:

int
stat(char *n, struct stat *st)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	56                   	push   %esi
 2d4:	53                   	push   %ebx
 2d5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2e2:	00 
 2e3:	89 04 24             	mov    %eax,(%esp)
 2e6:	e8 d7 00 00 00       	call   3c2 <open>
  if(fd < 0)
 2eb:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ed:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2ef:	78 27                	js     318 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f4:	89 1c 24             	mov    %ebx,(%esp)
 2f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fb:	e8 da 00 00 00       	call   3da <fstat>
  close(fd);
 300:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 303:	89 c6                	mov    %eax,%esi
  close(fd);
 305:	e8 a0 00 00 00       	call   3aa <close>
  return r;
 30a:	89 f0                	mov    %esi,%eax
}
 30c:	83 c4 10             	add    $0x10,%esp
 30f:	5b                   	pop    %ebx
 310:	5e                   	pop    %esi
 311:	5d                   	pop    %ebp
 312:	c3                   	ret    
 313:	90                   	nop
 314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 31d:	eb ed                	jmp    30c <stat+0x3c>
 31f:	90                   	nop

00000320 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	8b 4d 08             	mov    0x8(%ebp),%ecx
 326:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 327:	0f be 11             	movsbl (%ecx),%edx
 32a:	8d 42 d0             	lea    -0x30(%edx),%eax
 32d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 334:	77 17                	ja     34d <atoi+0x2d>
 336:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 338:	83 c1 01             	add    $0x1,%ecx
 33b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 33e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 342:	0f be 11             	movsbl (%ecx),%edx
 345:	8d 5a d0             	lea    -0x30(%edx),%ebx
 348:	80 fb 09             	cmp    $0x9,%bl
 34b:	76 eb                	jbe    338 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 34d:	5b                   	pop    %ebx
 34e:	5d                   	pop    %ebp
 34f:	c3                   	ret    

00000350 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 350:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 351:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 353:	89 e5                	mov    %esp,%ebp
 355:	56                   	push   %esi
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	53                   	push   %ebx
 35a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 35d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 360:	85 db                	test   %ebx,%ebx
 362:	7e 12                	jle    376 <memmove+0x26>
 364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 368:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 36c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 36f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 372:	39 da                	cmp    %ebx,%edx
 374:	75 f2                	jne    368 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 376:	5b                   	pop    %ebx
 377:	5e                   	pop    %esi
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    

0000037a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37a:	b8 01 00 00 00       	mov    $0x1,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <exit>:
SYSCALL(exit)
 382:	b8 02 00 00 00       	mov    $0x2,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <wait>:
SYSCALL(wait)
 38a:	b8 03 00 00 00       	mov    $0x3,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <pipe>:
SYSCALL(pipe)
 392:	b8 04 00 00 00       	mov    $0x4,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <read>:
SYSCALL(read)
 39a:	b8 05 00 00 00       	mov    $0x5,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <write>:
SYSCALL(write)
 3a2:	b8 10 00 00 00       	mov    $0x10,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <close>:
SYSCALL(close)
 3aa:	b8 15 00 00 00       	mov    $0x15,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <kill>:
SYSCALL(kill)
 3b2:	b8 06 00 00 00       	mov    $0x6,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <exec>:
SYSCALL(exec)
 3ba:	b8 07 00 00 00       	mov    $0x7,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <open>:
SYSCALL(open)
 3c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <mknod>:
SYSCALL(mknod)
 3ca:	b8 11 00 00 00       	mov    $0x11,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <unlink>:
SYSCALL(unlink)
 3d2:	b8 12 00 00 00       	mov    $0x12,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <fstat>:
SYSCALL(fstat)
 3da:	b8 08 00 00 00       	mov    $0x8,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <link>:
SYSCALL(link)
 3e2:	b8 13 00 00 00       	mov    $0x13,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <mkdir>:
SYSCALL(mkdir)
 3ea:	b8 14 00 00 00       	mov    $0x14,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <chdir>:
SYSCALL(chdir)
 3f2:	b8 09 00 00 00       	mov    $0x9,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <dup>:
SYSCALL(dup)
 3fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <getpid>:
SYSCALL(getpid)
 402:	b8 0b 00 00 00       	mov    $0xb,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <sbrk>:
SYSCALL(sbrk)
 40a:	b8 0c 00 00 00       	mov    $0xc,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <sleep>:
SYSCALL(sleep)
 412:	b8 0d 00 00 00       	mov    $0xd,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <uptime>:
SYSCALL(uptime)
 41a:	b8 0e 00 00 00       	mov    $0xe,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <my_syscall>:
SYSCALL(my_syscall)
 422:	b8 16 00 00 00       	mov    $0x16,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <getppid>:
SYSCALL(getppid)
 42a:	b8 17 00 00 00       	mov    $0x17,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <yield>:
SYSCALL(yield)
 432:	b8 18 00 00 00       	mov    $0x18,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <getlev>:
SYSCALL(getlev)
 43a:	b8 19 00 00 00       	mov    $0x19,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <set_cpu_share>:
SYSCALL(set_cpu_share)
 442:	b8 1a 00 00 00       	mov    $0x1a,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <thread_create>:
SYSCALL(thread_create)
 44a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <thread_exit>:
SYSCALL(thread_exit)
 452:	b8 1c 00 00 00       	mov    $0x1c,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <thread_join>:
SYSCALL(thread_join)
 45a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <gettid>:
SYSCALL(gettid)
 462:	b8 1e 00 00 00       	mov    $0x1e,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    
 46a:	66 90                	xchg   %ax,%ax
 46c:	66 90                	xchg   %ax,%ax
 46e:	66 90                	xchg   %ax,%ax

00000470 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	89 c6                	mov    %eax,%esi
 477:	53                   	push   %ebx
 478:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 47b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 47e:	85 db                	test   %ebx,%ebx
 480:	74 09                	je     48b <printint+0x1b>
 482:	89 d0                	mov    %edx,%eax
 484:	c1 e8 1f             	shr    $0x1f,%eax
 487:	84 c0                	test   %al,%al
 489:	75 75                	jne    500 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 48b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 48d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 494:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 497:	31 ff                	xor    %edi,%edi
 499:	89 ce                	mov    %ecx,%esi
 49b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 49e:	eb 02                	jmp    4a2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 4a0:	89 cf                	mov    %ecx,%edi
 4a2:	31 d2                	xor    %edx,%edx
 4a4:	f7 f6                	div    %esi
 4a6:	8d 4f 01             	lea    0x1(%edi),%ecx
 4a9:	0f b6 92 15 09 00 00 	movzbl 0x915(%edx),%edx
  }while((x /= base) != 0);
 4b0:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 4b2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 4b5:	75 e9                	jne    4a0 <printint+0x30>
  if(neg)
 4b7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 4ba:	89 c8                	mov    %ecx,%eax
 4bc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 4bf:	85 d2                	test   %edx,%edx
 4c1:	74 08                	je     4cb <printint+0x5b>
    buf[i++] = '-';
 4c3:	8d 4f 02             	lea    0x2(%edi),%ecx
 4c6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 4cb:	8d 79 ff             	lea    -0x1(%ecx),%edi
 4ce:	66 90                	xchg   %ax,%ax
 4d0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 4d5:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4df:	00 
 4e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 4e4:	89 34 24             	mov    %esi,(%esp)
 4e7:	88 45 d7             	mov    %al,-0x29(%ebp)
 4ea:	e8 b3 fe ff ff       	call   3a2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ef:	83 ff ff             	cmp    $0xffffffff,%edi
 4f2:	75 dc                	jne    4d0 <printint+0x60>
    putc(fd, buf[i]);
}
 4f4:	83 c4 4c             	add    $0x4c,%esp
 4f7:	5b                   	pop    %ebx
 4f8:	5e                   	pop    %esi
 4f9:	5f                   	pop    %edi
 4fa:	5d                   	pop    %ebp
 4fb:	c3                   	ret    
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 500:	89 d0                	mov    %edx,%eax
 502:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 504:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 50b:	eb 87                	jmp    494 <printint+0x24>
 50d:	8d 76 00             	lea    0x0(%esi),%esi

00000510 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 514:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 516:	56                   	push   %esi
 517:	53                   	push   %ebx
 518:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 51b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 51e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 521:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 524:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 527:	0f b6 13             	movzbl (%ebx),%edx
 52a:	83 c3 01             	add    $0x1,%ebx
 52d:	84 d2                	test   %dl,%dl
 52f:	75 39                	jne    56a <printf+0x5a>
 531:	e9 c2 00 00 00       	jmp    5f8 <printf+0xe8>
 536:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 538:	83 fa 25             	cmp    $0x25,%edx
 53b:	0f 84 bf 00 00 00    	je     600 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 541:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 544:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 54b:	00 
 54c:	89 44 24 04          	mov    %eax,0x4(%esp)
 550:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 553:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 556:	e8 47 fe ff ff       	call   3a2 <write>
 55b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 55e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 562:	84 d2                	test   %dl,%dl
 564:	0f 84 8e 00 00 00    	je     5f8 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 56a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 56c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 56f:	74 c7                	je     538 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 571:	83 ff 25             	cmp    $0x25,%edi
 574:	75 e5                	jne    55b <printf+0x4b>
      if(c == 'd'){
 576:	83 fa 64             	cmp    $0x64,%edx
 579:	0f 84 31 01 00 00    	je     6b0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 57f:	25 f7 00 00 00       	and    $0xf7,%eax
 584:	83 f8 70             	cmp    $0x70,%eax
 587:	0f 84 83 00 00 00    	je     610 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 58d:	83 fa 73             	cmp    $0x73,%edx
 590:	0f 84 a2 00 00 00    	je     638 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 596:	83 fa 63             	cmp    $0x63,%edx
 599:	0f 84 35 01 00 00    	je     6d4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 59f:	83 fa 25             	cmp    $0x25,%edx
 5a2:	0f 84 e0 00 00 00    	je     688 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5ab:	83 c3 01             	add    $0x1,%ebx
 5ae:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5b5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b6:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bc:	89 34 24             	mov    %esi,(%esp)
 5bf:	89 55 d0             	mov    %edx,-0x30(%ebp)
 5c2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 5c6:	e8 d7 fd ff ff       	call   3a2 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ce:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d8:	00 
 5d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5dd:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 5e0:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5e3:	e8 ba fd ff ff       	call   3a2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 5ec:	84 d2                	test   %dl,%dl
 5ee:	0f 85 76 ff ff ff    	jne    56a <printf+0x5a>
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5f8:	83 c4 3c             	add    $0x3c,%esp
 5fb:	5b                   	pop    %ebx
 5fc:	5e                   	pop    %esi
 5fd:	5f                   	pop    %edi
 5fe:	5d                   	pop    %ebp
 5ff:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 600:	bf 25 00 00 00       	mov    $0x25,%edi
 605:	e9 51 ff ff ff       	jmp    55b <printf+0x4b>
 60a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 610:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 613:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 618:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 61a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 621:	8b 10                	mov    (%eax),%edx
 623:	89 f0                	mov    %esi,%eax
 625:	e8 46 fe ff ff       	call   470 <printint>
        ap++;
 62a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 62e:	e9 28 ff ff ff       	jmp    55b <printf+0x4b>
 633:	90                   	nop
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 638:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 63b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 63f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 641:	b8 0e 09 00 00       	mov    $0x90e,%eax
 646:	85 ff                	test   %edi,%edi
 648:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 64b:	0f b6 07             	movzbl (%edi),%eax
 64e:	84 c0                	test   %al,%al
 650:	74 2a                	je     67c <printf+0x16c>
 652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 658:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 65b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 65e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 661:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 668:	00 
 669:	89 44 24 04          	mov    %eax,0x4(%esp)
 66d:	89 34 24             	mov    %esi,(%esp)
 670:	e8 2d fd ff ff       	call   3a2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 675:	0f b6 07             	movzbl (%edi),%eax
 678:	84 c0                	test   %al,%al
 67a:	75 dc                	jne    658 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 67c:	31 ff                	xor    %edi,%edi
 67e:	e9 d8 fe ff ff       	jmp    55b <printf+0x4b>
 683:	90                   	nop
 684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 688:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 68b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 68d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 694:	00 
 695:	89 44 24 04          	mov    %eax,0x4(%esp)
 699:	89 34 24             	mov    %esi,(%esp)
 69c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 6a0:	e8 fd fc ff ff       	call   3a2 <write>
 6a5:	e9 b1 fe ff ff       	jmp    55b <printf+0x4b>
 6aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6b8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6c2:	8b 10                	mov    (%eax),%edx
 6c4:	89 f0                	mov    %esi,%eax
 6c6:	e8 a5 fd ff ff       	call   470 <printint>
        ap++;
 6cb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6cf:	e9 87 fe ff ff       	jmp    55b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6d7:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6d9:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6e2:	00 
 6e3:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 6e6:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6e9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f0:	e8 ad fc ff ff       	call   3a2 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 6f5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6f9:	e9 5d fe ff ff       	jmp    55b <printf+0x4b>
 6fe:	66 90                	xchg   %ax,%ax

00000700 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 700:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	a1 b8 0b 00 00       	mov    0xbb8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 706:	89 e5                	mov    %esp,%ebp
 708:	57                   	push   %edi
 709:	56                   	push   %esi
 70a:	53                   	push   %ebx
 70b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 710:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 713:	39 d0                	cmp    %edx,%eax
 715:	72 11                	jb     728 <free+0x28>
 717:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 718:	39 c8                	cmp    %ecx,%eax
 71a:	72 04                	jb     720 <free+0x20>
 71c:	39 ca                	cmp    %ecx,%edx
 71e:	72 10                	jb     730 <free+0x30>
 720:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 722:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 724:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 726:	73 f0                	jae    718 <free+0x18>
 728:	39 ca                	cmp    %ecx,%edx
 72a:	72 04                	jb     730 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72c:	39 c8                	cmp    %ecx,%eax
 72e:	72 f0                	jb     720 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 730:	8b 73 fc             	mov    -0x4(%ebx),%esi
 733:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 736:	39 cf                	cmp    %ecx,%edi
 738:	74 1e                	je     758 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 73a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 73d:	8b 48 04             	mov    0x4(%eax),%ecx
 740:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 743:	39 f2                	cmp    %esi,%edx
 745:	74 28                	je     76f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 747:	89 10                	mov    %edx,(%eax)
  freep = p;
 749:	a3 b8 0b 00 00       	mov    %eax,0xbb8
}
 74e:	5b                   	pop    %ebx
 74f:	5e                   	pop    %esi
 750:	5f                   	pop    %edi
 751:	5d                   	pop    %ebp
 752:	c3                   	ret    
 753:	90                   	nop
 754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 758:	03 71 04             	add    0x4(%ecx),%esi
 75b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 75e:	8b 08                	mov    (%eax),%ecx
 760:	8b 09                	mov    (%ecx),%ecx
 762:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 765:	8b 48 04             	mov    0x4(%eax),%ecx
 768:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 76b:	39 f2                	cmp    %esi,%edx
 76d:	75 d8                	jne    747 <free+0x47>
    p->s.size += bp->s.size;
 76f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 772:	a3 b8 0b 00 00       	mov    %eax,0xbb8
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 777:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 77a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 77d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 77f:	5b                   	pop    %ebx
 780:	5e                   	pop    %esi
 781:	5f                   	pop    %edi
 782:	5d                   	pop    %ebp
 783:	c3                   	ret    
 784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 78a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000790 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	57                   	push   %edi
 794:	56                   	push   %esi
 795:	53                   	push   %ebx
 796:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 799:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 79c:	8b 1d b8 0b 00 00    	mov    0xbb8,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a2:	8d 48 07             	lea    0x7(%eax),%ecx
 7a5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 7a8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7aa:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 7ad:	0f 84 9b 00 00 00    	je     84e <malloc+0xbe>
 7b3:	8b 13                	mov    (%ebx),%edx
 7b5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7b8:	39 fe                	cmp    %edi,%esi
 7ba:	76 64                	jbe    820 <malloc+0x90>
 7bc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 7c3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 7c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 7cb:	eb 0e                	jmp    7db <malloc+0x4b>
 7cd:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7d2:	8b 78 04             	mov    0x4(%eax),%edi
 7d5:	39 fe                	cmp    %edi,%esi
 7d7:	76 4f                	jbe    828 <malloc+0x98>
 7d9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7db:	3b 15 b8 0b 00 00    	cmp    0xbb8,%edx
 7e1:	75 ed                	jne    7d0 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 7e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7ec:	bf 00 10 00 00       	mov    $0x1000,%edi
 7f1:	0f 43 fe             	cmovae %esi,%edi
 7f4:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 7f7:	89 04 24             	mov    %eax,(%esp)
 7fa:	e8 0b fc ff ff       	call   40a <sbrk>
  if(p == (char*)-1)
 7ff:	83 f8 ff             	cmp    $0xffffffff,%eax
 802:	74 18                	je     81c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 804:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 807:	83 c0 08             	add    $0x8,%eax
 80a:	89 04 24             	mov    %eax,(%esp)
 80d:	e8 ee fe ff ff       	call   700 <free>
  return freep;
 812:	8b 15 b8 0b 00 00    	mov    0xbb8,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 818:	85 d2                	test   %edx,%edx
 81a:	75 b4                	jne    7d0 <malloc+0x40>
        return 0;
 81c:	31 c0                	xor    %eax,%eax
 81e:	eb 20                	jmp    840 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 820:	89 d0                	mov    %edx,%eax
 822:	89 da                	mov    %ebx,%edx
 824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 828:	39 fe                	cmp    %edi,%esi
 82a:	74 1c                	je     848 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 82c:	29 f7                	sub    %esi,%edi
 82e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 831:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 834:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 837:	89 15 b8 0b 00 00    	mov    %edx,0xbb8
      return (void*)(p + 1);
 83d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 840:	83 c4 1c             	add    $0x1c,%esp
 843:	5b                   	pop    %ebx
 844:	5e                   	pop    %esi
 845:	5f                   	pop    %edi
 846:	5d                   	pop    %ebp
 847:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 848:	8b 08                	mov    (%eax),%ecx
 84a:	89 0a                	mov    %ecx,(%edx)
 84c:	eb e9                	jmp    837 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 84e:	c7 05 b8 0b 00 00 bc 	movl   $0xbbc,0xbb8
 855:	0b 00 00 
    base.s.size = 0;
 858:	ba bc 0b 00 00       	mov    $0xbbc,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 85d:	c7 05 bc 0b 00 00 bc 	movl   $0xbbc,0xbbc
 864:	0b 00 00 
    base.s.size = 0;
 867:	c7 05 c0 0b 00 00 00 	movl   $0x0,0xbc0
 86e:	00 00 00 
 871:	e9 46 ff ff ff       	jmp    7bc <malloc+0x2c>

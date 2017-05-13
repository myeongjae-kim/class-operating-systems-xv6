
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
  thread_t thread2 = 200;
  int a = 10000;
  int* return_value = 0;

  printf(1, "(main)a:%d\n", a);
   a:	c7 44 24 08 10 27 00 	movl   $0x2710,0x8(%esp)
  11:	00 

  thread_create(&thread, start_routine, (void*)a);
  thread_create(&thread2, start_routine, (void*)a);
  thread_join(thread, (void**)&return_value);
  12:	8d 5c 24 1c          	lea    0x1c(%esp),%ebx
  thread_t thread = 200;
  thread_t thread2 = 200;
  int a = 10000;
  int* return_value = 0;

  printf(1, "(main)a:%d\n", a);
  16:	c7 44 24 04 08 09 00 	movl   $0x908,0x4(%esp)
  1d:	00 
  1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
}

int
main(int argc, char *argv[])
{
  thread_t thread = 200;
  25:	c7 44 24 14 c8 00 00 	movl   $0xc8,0x14(%esp)
  2c:	00 
  thread_t thread2 = 200;
  2d:	c7 44 24 18 c8 00 00 	movl   $0xc8,0x18(%esp)
  34:	00 
  int a = 10000;
  int* return_value = 0;
  35:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  3c:	00 

  printf(1, "(main)a:%d\n", a);
  3d:	e8 1e 05 00 00       	call   560 <printf>

  thread_create(&thread, start_routine, (void*)a);
  42:	8d 44 24 14          	lea    0x14(%esp),%eax
  46:	c7 44 24 08 10 27 00 	movl   $0x2710,0x8(%esp)
  4d:	00 
  4e:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  55:	00 
  56:	89 04 24             	mov    %eax,(%esp)
  59:	e8 3c 04 00 00       	call   49a <thread_create>
  thread_create(&thread2, start_routine, (void*)a);
  5e:	8d 44 24 18          	lea    0x18(%esp),%eax
  62:	c7 44 24 08 10 27 00 	movl   $0x2710,0x8(%esp)
  69:	00 
  6a:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  71:	00 
  72:	89 04 24             	mov    %eax,(%esp)
  75:	e8 20 04 00 00       	call   49a <thread_create>
  thread_join(thread, (void**)&return_value);
  7a:	8b 44 24 14          	mov    0x14(%esp),%eax
  7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  82:	89 04 24             	mov    %eax,(%esp)
  85:	e8 20 04 00 00       	call   4aa <thread_join>
  printf(1, "(main)join1 return_value: %d\n", return_value);
  8a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  8e:	c7 44 24 04 14 09 00 	movl   $0x914,0x4(%esp)
  95:	00 
  96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  a1:	e8 ba 04 00 00       	call   560 <printf>
  thread_join(thread2, (void**)&return_value);
  a6:	8b 44 24 18          	mov    0x18(%esp),%eax
  aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ae:	89 04 24             	mov    %eax,(%esp)
  b1:	e8 f4 03 00 00       	call   4aa <thread_join>
  printf(1, "(main)join2 return_value: %d\n", return_value);
  b6:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  ba:	c7 44 24 04 32 09 00 	movl   $0x932,0x4(%esp)
  c1:	00 
  c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  cd:	e8 8e 04 00 00       	call   560 <printf>

  printf(1, "(main)start_routine: %p\n", start_routine);
  d2:	c7 44 24 08 40 01 00 	movl   $0x140,0x8(%esp)
  d9:	00 
  da:	c7 44 24 04 50 09 00 	movl   $0x950,0x4(%esp)
  e1:	00 
  e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e9:	e8 72 04 00 00       	call   560 <printf>
  printf(1, "(main)ppid: %d, pid: %d\n", getppid(), getpid());
  ee:	e8 5f 03 00 00       	call   452 <getpid>
  f3:	89 c3                	mov    %eax,%ebx
  f5:	e8 80 03 00 00       	call   47a <getppid>
  fa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  fe:	c7 44 24 04 69 09 00 	movl   $0x969,0x4(%esp)
 105:	00 
 106:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 10d:	89 44 24 08          	mov    %eax,0x8(%esp)
 111:	e8 4a 04 00 00       	call   560 <printf>

  printf(1, "(main)a:%d\n", a);
 116:	c7 44 24 08 10 27 00 	movl   $0x2710,0x8(%esp)
 11d:	00 
 11e:	c7 44 24 04 08 09 00 	movl   $0x908,0x4(%esp)
 125:	00 
 126:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 12d:	e8 2e 04 00 00       	call   560 <printf>
    for (i = 0; i < 210000000; ++i) {
      
    }
  }

  exit();
 132:	e8 9b 02 00 00       	call   3d2 <exit>
 137:	66 90                	xchg   %ax,%ax
 139:	66 90                	xchg   %ax,%ax
 13b:	66 90                	xchg   %ax,%ax
 13d:	66 90                	xchg   %ax,%ax
 13f:	90                   	nop

00000140 <start_routine>:
#include "types.h"
#include "stat.h"
#include "user.h"

void * start_routine(void * arg) {
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	56                   	push   %esi
 145:	53                   	push   %ebx
  int i;
  int n = (int)arg;
 146:	bb 02 00 00 00       	mov    $0x2,%ebx
#include "types.h"
#include "stat.h"
#include "user.h"

void * start_routine(void * arg) {
 14b:	83 ec 2c             	sub    $0x2c,%esp
  int i;
  int n = (int)arg;

  for (i = 0; i < 2; ++i) {
    printf(0, "** Thread. I am running!, arg:%d, pid:%d, tid:%d, ppid:%d **\n", n, getpid(),gettid(), getppid());
 14e:	e8 27 03 00 00       	call   47a <getppid>
 153:	89 c7                	mov    %eax,%edi
 155:	e8 58 03 00 00       	call   4b2 <gettid>
 15a:	89 c6                	mov    %eax,%esi
 15c:	e8 f1 02 00 00       	call   452 <getpid>
 161:	89 7c 24 14          	mov    %edi,0x14(%esp)
 165:	89 74 24 10          	mov    %esi,0x10(%esp)
 169:	c7 44 24 04 c8 08 00 	movl   $0x8c8,0x4(%esp)
 170:	00 
 171:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 178:	89 44 24 0c          	mov    %eax,0xc(%esp)
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	89 44 24 08          	mov    %eax,0x8(%esp)
 183:	e8 d8 03 00 00       	call   560 <printf>

void * start_routine(void * arg) {
  int i;
  int n = (int)arg;

  for (i = 0; i < 2; ++i) {
 188:	83 eb 01             	sub    $0x1,%ebx
 18b:	75 c1                	jne    14e <start_routine+0xe>
    printf(0, "** Thread. I am running!, arg:%d, pid:%d, tid:%d, ppid:%d **\n", n, getpid(),gettid(), getppid());
  }

  thread_exit((void*)999);
 18d:	c7 04 24 e7 03 00 00 	movl   $0x3e7,(%esp)
 194:	e8 09 03 00 00       	call   4a2 <thread_exit>
  return (void*)0xEFEFEFEF;
}
 199:	83 c4 2c             	add    $0x2c,%esp
 19c:	b8 ef ef ef ef       	mov    $0xefefefef,%eax
 1a1:	5b                   	pop    %ebx
 1a2:	5e                   	pop    %esi
 1a3:	5f                   	pop    %edi
 1a4:	5d                   	pop    %ebp
 1a5:	c3                   	ret    
 1a6:	66 90                	xchg   %ax,%ax
 1a8:	66 90                	xchg   %ax,%ax
 1aa:	66 90                	xchg   %ax,%ax
 1ac:	66 90                	xchg   %ax,%ax
 1ae:	66 90                	xchg   %ax,%ax

000001b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1b9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ba:	89 c2                	mov    %eax,%edx
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1c0:	83 c1 01             	add    $0x1,%ecx
 1c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1c7:	83 c2 01             	add    $0x1,%edx
 1ca:	84 db                	test   %bl,%bl
 1cc:	88 5a ff             	mov    %bl,-0x1(%edx)
 1cf:	75 ef                	jne    1c0 <strcpy+0x10>
    ;
  return os;
}
 1d1:	5b                   	pop    %ebx
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    
 1d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 55 08             	mov    0x8(%ebp),%edx
 1e6:	53                   	push   %ebx
 1e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1ea:	0f b6 02             	movzbl (%edx),%eax
 1ed:	84 c0                	test   %al,%al
 1ef:	74 2d                	je     21e <strcmp+0x3e>
 1f1:	0f b6 19             	movzbl (%ecx),%ebx
 1f4:	38 d8                	cmp    %bl,%al
 1f6:	74 0e                	je     206 <strcmp+0x26>
 1f8:	eb 2b                	jmp    225 <strcmp+0x45>
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 200:	38 c8                	cmp    %cl,%al
 202:	75 15                	jne    219 <strcmp+0x39>
    p++, q++;
 204:	89 d9                	mov    %ebx,%ecx
 206:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 209:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 20c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 20f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 213:	84 c0                	test   %al,%al
 215:	75 e9                	jne    200 <strcmp+0x20>
 217:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 219:	29 c8                	sub    %ecx,%eax
}
 21b:	5b                   	pop    %ebx
 21c:	5d                   	pop    %ebp
 21d:	c3                   	ret    
 21e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 221:	31 c0                	xor    %eax,%eax
 223:	eb f4                	jmp    219 <strcmp+0x39>
 225:	0f b6 cb             	movzbl %bl,%ecx
 228:	eb ef                	jmp    219 <strcmp+0x39>
 22a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000230 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 236:	80 39 00             	cmpb   $0x0,(%ecx)
 239:	74 12                	je     24d <strlen+0x1d>
 23b:	31 d2                	xor    %edx,%edx
 23d:	8d 76 00             	lea    0x0(%esi),%esi
 240:	83 c2 01             	add    $0x1,%edx
 243:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 247:	89 d0                	mov    %edx,%eax
 249:	75 f5                	jne    240 <strlen+0x10>
    ;
  return n;
}
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 24d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    
 251:	eb 0d                	jmp    260 <memset>
 253:	90                   	nop
 254:	90                   	nop
 255:	90                   	nop
 256:	90                   	nop
 257:	90                   	nop
 258:	90                   	nop
 259:	90                   	nop
 25a:	90                   	nop
 25b:	90                   	nop
 25c:	90                   	nop
 25d:	90                   	nop
 25e:	90                   	nop
 25f:	90                   	nop

00000260 <memset>:

void*
memset(void *dst, int c, uint n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	8b 55 08             	mov    0x8(%ebp),%edx
 266:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 267:	8b 4d 10             	mov    0x10(%ebp),%ecx
 26a:	8b 45 0c             	mov    0xc(%ebp),%eax
 26d:	89 d7                	mov    %edx,%edi
 26f:	fc                   	cld    
 270:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 272:	89 d0                	mov    %edx,%eax
 274:	5f                   	pop    %edi
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
 277:	89 f6                	mov    %esi,%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <strchr>:

char*
strchr(const char *s, char c)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	53                   	push   %ebx
 287:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 28a:	0f b6 18             	movzbl (%eax),%ebx
 28d:	84 db                	test   %bl,%bl
 28f:	74 1d                	je     2ae <strchr+0x2e>
    if(*s == c)
 291:	38 d3                	cmp    %dl,%bl
 293:	89 d1                	mov    %edx,%ecx
 295:	75 0d                	jne    2a4 <strchr+0x24>
 297:	eb 17                	jmp    2b0 <strchr+0x30>
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2a0:	38 ca                	cmp    %cl,%dl
 2a2:	74 0c                	je     2b0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2a4:	83 c0 01             	add    $0x1,%eax
 2a7:	0f b6 10             	movzbl (%eax),%edx
 2aa:	84 d2                	test   %dl,%dl
 2ac:	75 f2                	jne    2a0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 2ae:	31 c0                	xor    %eax,%eax
}
 2b0:	5b                   	pop    %ebx
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    
 2b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <gets>:

char*
gets(char *buf, int max)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 2c7:	53                   	push   %ebx
 2c8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2cb:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ce:	eb 31                	jmp    301 <gets+0x41>
    cc = read(0, &c, 1);
 2d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2d7:	00 
 2d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 2dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2e3:	e8 02 01 00 00       	call   3ea <read>
    if(cc < 1)
 2e8:	85 c0                	test   %eax,%eax
 2ea:	7e 1d                	jle    309 <gets+0x49>
      break;
    buf[i++] = c;
 2ec:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f0:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 2f2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 2f5:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 2f7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2fb:	74 0c                	je     309 <gets+0x49>
 2fd:	3c 0a                	cmp    $0xa,%al
 2ff:	74 08                	je     309 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 301:	8d 5e 01             	lea    0x1(%esi),%ebx
 304:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 307:	7c c7                	jl     2d0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 309:	8b 45 08             	mov    0x8(%ebp),%eax
 30c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 310:	83 c4 2c             	add    $0x2c,%esp
 313:	5b                   	pop    %ebx
 314:	5e                   	pop    %esi
 315:	5f                   	pop    %edi
 316:	5d                   	pop    %ebp
 317:	c3                   	ret    
 318:	90                   	nop
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000320 <stat>:

int
stat(char *n, struct stat *st)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	56                   	push   %esi
 324:	53                   	push   %ebx
 325:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 332:	00 
 333:	89 04 24             	mov    %eax,(%esp)
 336:	e8 d7 00 00 00       	call   412 <open>
  if(fd < 0)
 33b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 33f:	78 27                	js     368 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	89 1c 24             	mov    %ebx,(%esp)
 347:	89 44 24 04          	mov    %eax,0x4(%esp)
 34b:	e8 da 00 00 00       	call   42a <fstat>
  close(fd);
 350:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 353:	89 c6                	mov    %eax,%esi
  close(fd);
 355:	e8 a0 00 00 00       	call   3fa <close>
  return r;
 35a:	89 f0                	mov    %esi,%eax
}
 35c:	83 c4 10             	add    $0x10,%esp
 35f:	5b                   	pop    %ebx
 360:	5e                   	pop    %esi
 361:	5d                   	pop    %ebp
 362:	c3                   	ret    
 363:	90                   	nop
 364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 36d:	eb ed                	jmp    35c <stat+0x3c>
 36f:	90                   	nop

00000370 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	8b 4d 08             	mov    0x8(%ebp),%ecx
 376:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 377:	0f be 11             	movsbl (%ecx),%edx
 37a:	8d 42 d0             	lea    -0x30(%edx),%eax
 37d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 37f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 384:	77 17                	ja     39d <atoi+0x2d>
 386:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 388:	83 c1 01             	add    $0x1,%ecx
 38b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 38e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 392:	0f be 11             	movsbl (%ecx),%edx
 395:	8d 5a d0             	lea    -0x30(%edx),%ebx
 398:	80 fb 09             	cmp    $0x9,%bl
 39b:	76 eb                	jbe    388 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 39d:	5b                   	pop    %ebx
 39e:	5d                   	pop    %ebp
 39f:	c3                   	ret    

000003a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3a0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3a1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	56                   	push   %esi
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	53                   	push   %ebx
 3aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ad:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3b0:	85 db                	test   %ebx,%ebx
 3b2:	7e 12                	jle    3c6 <memmove+0x26>
 3b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 3b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3bf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3c2:	39 da                	cmp    %ebx,%edx
 3c4:	75 f2                	jne    3b8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 3c6:	5b                   	pop    %ebx
 3c7:	5e                   	pop    %esi
 3c8:	5d                   	pop    %ebp
 3c9:	c3                   	ret    

000003ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ca:	b8 01 00 00 00       	mov    $0x1,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <exit>:
SYSCALL(exit)
 3d2:	b8 02 00 00 00       	mov    $0x2,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <wait>:
SYSCALL(wait)
 3da:	b8 03 00 00 00       	mov    $0x3,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <pipe>:
SYSCALL(pipe)
 3e2:	b8 04 00 00 00       	mov    $0x4,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <read>:
SYSCALL(read)
 3ea:	b8 05 00 00 00       	mov    $0x5,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <write>:
SYSCALL(write)
 3f2:	b8 10 00 00 00       	mov    $0x10,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <close>:
SYSCALL(close)
 3fa:	b8 15 00 00 00       	mov    $0x15,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <kill>:
SYSCALL(kill)
 402:	b8 06 00 00 00       	mov    $0x6,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <exec>:
SYSCALL(exec)
 40a:	b8 07 00 00 00       	mov    $0x7,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <open>:
SYSCALL(open)
 412:	b8 0f 00 00 00       	mov    $0xf,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <mknod>:
SYSCALL(mknod)
 41a:	b8 11 00 00 00       	mov    $0x11,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <unlink>:
SYSCALL(unlink)
 422:	b8 12 00 00 00       	mov    $0x12,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <fstat>:
SYSCALL(fstat)
 42a:	b8 08 00 00 00       	mov    $0x8,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <link>:
SYSCALL(link)
 432:	b8 13 00 00 00       	mov    $0x13,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <mkdir>:
SYSCALL(mkdir)
 43a:	b8 14 00 00 00       	mov    $0x14,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <chdir>:
SYSCALL(chdir)
 442:	b8 09 00 00 00       	mov    $0x9,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <dup>:
SYSCALL(dup)
 44a:	b8 0a 00 00 00       	mov    $0xa,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <getpid>:
SYSCALL(getpid)
 452:	b8 0b 00 00 00       	mov    $0xb,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <sbrk>:
SYSCALL(sbrk)
 45a:	b8 0c 00 00 00       	mov    $0xc,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <sleep>:
SYSCALL(sleep)
 462:	b8 0d 00 00 00       	mov    $0xd,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <uptime>:
SYSCALL(uptime)
 46a:	b8 0e 00 00 00       	mov    $0xe,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <my_syscall>:
SYSCALL(my_syscall)
 472:	b8 16 00 00 00       	mov    $0x16,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <getppid>:
SYSCALL(getppid)
 47a:	b8 17 00 00 00       	mov    $0x17,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <yield>:
SYSCALL(yield)
 482:	b8 18 00 00 00       	mov    $0x18,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <getlev>:
SYSCALL(getlev)
 48a:	b8 19 00 00 00       	mov    $0x19,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <set_cpu_share>:
SYSCALL(set_cpu_share)
 492:	b8 1a 00 00 00       	mov    $0x1a,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <thread_create>:
SYSCALL(thread_create)
 49a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <thread_exit>:
SYSCALL(thread_exit)
 4a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <thread_join>:
SYSCALL(thread_join)
 4aa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <gettid>:
SYSCALL(gettid)
 4b2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    
 4ba:	66 90                	xchg   %ax,%ax
 4bc:	66 90                	xchg   %ax,%ax
 4be:	66 90                	xchg   %ax,%ax

000004c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	89 c6                	mov    %eax,%esi
 4c7:	53                   	push   %ebx
 4c8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4ce:	85 db                	test   %ebx,%ebx
 4d0:	74 09                	je     4db <printint+0x1b>
 4d2:	89 d0                	mov    %edx,%eax
 4d4:	c1 e8 1f             	shr    $0x1f,%eax
 4d7:	84 c0                	test   %al,%al
 4d9:	75 75                	jne    550 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4db:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4dd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4e4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4e7:	31 ff                	xor    %edi,%edi
 4e9:	89 ce                	mov    %ecx,%esi
 4eb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 4ee:	eb 02                	jmp    4f2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 4f0:	89 cf                	mov    %ecx,%edi
 4f2:	31 d2                	xor    %edx,%edx
 4f4:	f7 f6                	div    %esi
 4f6:	8d 4f 01             	lea    0x1(%edi),%ecx
 4f9:	0f b6 92 89 09 00 00 	movzbl 0x989(%edx),%edx
  }while((x /= base) != 0);
 500:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 502:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 505:	75 e9                	jne    4f0 <printint+0x30>
  if(neg)
 507:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 50a:	89 c8                	mov    %ecx,%eax
 50c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 50f:	85 d2                	test   %edx,%edx
 511:	74 08                	je     51b <printint+0x5b>
    buf[i++] = '-';
 513:	8d 4f 02             	lea    0x2(%edi),%ecx
 516:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 51b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 51e:	66 90                	xchg   %ax,%ax
 520:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 525:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 528:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 52f:	00 
 530:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 534:	89 34 24             	mov    %esi,(%esp)
 537:	88 45 d7             	mov    %al,-0x29(%ebp)
 53a:	e8 b3 fe ff ff       	call   3f2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 53f:	83 ff ff             	cmp    $0xffffffff,%edi
 542:	75 dc                	jne    520 <printint+0x60>
    putc(fd, buf[i]);
}
 544:	83 c4 4c             	add    $0x4c,%esp
 547:	5b                   	pop    %ebx
 548:	5e                   	pop    %esi
 549:	5f                   	pop    %edi
 54a:	5d                   	pop    %ebp
 54b:	c3                   	ret    
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 550:	89 d0                	mov    %edx,%eax
 552:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 554:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 55b:	eb 87                	jmp    4e4 <printint+0x24>
 55d:	8d 76 00             	lea    0x0(%esi),%esi

00000560 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 564:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 566:	56                   	push   %esi
 567:	53                   	push   %ebx
 568:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 56b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 56e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 571:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 574:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 577:	0f b6 13             	movzbl (%ebx),%edx
 57a:	83 c3 01             	add    $0x1,%ebx
 57d:	84 d2                	test   %dl,%dl
 57f:	75 39                	jne    5ba <printf+0x5a>
 581:	e9 c2 00 00 00       	jmp    648 <printf+0xe8>
 586:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 588:	83 fa 25             	cmp    $0x25,%edx
 58b:	0f 84 bf 00 00 00    	je     650 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 591:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 594:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 59b:	00 
 59c:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5a3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a6:	e8 47 fe ff ff       	call   3f2 <write>
 5ab:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ae:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 5b2:	84 d2                	test   %dl,%dl
 5b4:	0f 84 8e 00 00 00    	je     648 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 5ba:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 5bc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 5bf:	74 c7                	je     588 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5c1:	83 ff 25             	cmp    $0x25,%edi
 5c4:	75 e5                	jne    5ab <printf+0x4b>
      if(c == 'd'){
 5c6:	83 fa 64             	cmp    $0x64,%edx
 5c9:	0f 84 31 01 00 00    	je     700 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5cf:	25 f7 00 00 00       	and    $0xf7,%eax
 5d4:	83 f8 70             	cmp    $0x70,%eax
 5d7:	0f 84 83 00 00 00    	je     660 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5dd:	83 fa 73             	cmp    $0x73,%edx
 5e0:	0f 84 a2 00 00 00    	je     688 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e6:	83 fa 63             	cmp    $0x63,%edx
 5e9:	0f 84 35 01 00 00    	je     724 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5ef:	83 fa 25             	cmp    $0x25,%edx
 5f2:	0f 84 e0 00 00 00    	je     6d8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5fb:	83 c3 01             	add    $0x1,%ebx
 5fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 605:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 606:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 608:	89 44 24 04          	mov    %eax,0x4(%esp)
 60c:	89 34 24             	mov    %esi,(%esp)
 60f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 612:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 616:	e8 d7 fd ff ff       	call   3f2 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 61b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 61e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 621:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 628:	00 
 629:	89 44 24 04          	mov    %eax,0x4(%esp)
 62d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 630:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 633:	e8 ba fd ff ff       	call   3f2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 638:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 63c:	84 d2                	test   %dl,%dl
 63e:	0f 85 76 ff ff ff    	jne    5ba <printf+0x5a>
 644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 648:	83 c4 3c             	add    $0x3c,%esp
 64b:	5b                   	pop    %ebx
 64c:	5e                   	pop    %esi
 64d:	5f                   	pop    %edi
 64e:	5d                   	pop    %ebp
 64f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 650:	bf 25 00 00 00       	mov    $0x25,%edi
 655:	e9 51 ff ff ff       	jmp    5ab <printf+0x4b>
 65a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 660:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 663:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 668:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 66a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 671:	8b 10                	mov    (%eax),%edx
 673:	89 f0                	mov    %esi,%eax
 675:	e8 46 fe ff ff       	call   4c0 <printint>
        ap++;
 67a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 67e:	e9 28 ff ff ff       	jmp    5ab <printf+0x4b>
 683:	90                   	nop
 684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 688:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 68b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 68f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 691:	b8 82 09 00 00       	mov    $0x982,%eax
 696:	85 ff                	test   %edi,%edi
 698:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 69b:	0f b6 07             	movzbl (%edi),%eax
 69e:	84 c0                	test   %al,%al
 6a0:	74 2a                	je     6cc <printf+0x16c>
 6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6ab:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 6ae:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6b8:	00 
 6b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bd:	89 34 24             	mov    %esi,(%esp)
 6c0:	e8 2d fd ff ff       	call   3f2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c5:	0f b6 07             	movzbl (%edi),%eax
 6c8:	84 c0                	test   %al,%al
 6ca:	75 dc                	jne    6a8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6cc:	31 ff                	xor    %edi,%edi
 6ce:	e9 d8 fe ff ff       	jmp    5ab <printf+0x4b>
 6d3:	90                   	nop
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6d8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6db:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6dd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6e4:	00 
 6e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e9:	89 34 24             	mov    %esi,(%esp)
 6ec:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 6f0:	e8 fd fc ff ff       	call   3f2 <write>
 6f5:	e9 b1 fe ff ff       	jmp    5ab <printf+0x4b>
 6fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 700:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 703:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 708:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 70b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 712:	8b 10                	mov    (%eax),%edx
 714:	89 f0                	mov    %esi,%eax
 716:	e8 a5 fd ff ff       	call   4c0 <printint>
        ap++;
 71b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 71f:	e9 87 fe ff ff       	jmp    5ab <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 724:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 727:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 729:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 72b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 732:	00 
 733:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 736:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 739:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 73c:	89 44 24 04          	mov    %eax,0x4(%esp)
 740:	e8 ad fc ff ff       	call   3f2 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 745:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 749:	e9 5d fe ff ff       	jmp    5ab <printf+0x4b>
 74e:	66 90                	xchg   %ax,%ax

00000750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 750:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 751:	a1 2c 0c 00 00       	mov    0xc2c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 756:	89 e5                	mov    %esp,%ebp
 758:	57                   	push   %edi
 759:	56                   	push   %esi
 75a:	53                   	push   %ebx
 75b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 760:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 763:	39 d0                	cmp    %edx,%eax
 765:	72 11                	jb     778 <free+0x28>
 767:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 768:	39 c8                	cmp    %ecx,%eax
 76a:	72 04                	jb     770 <free+0x20>
 76c:	39 ca                	cmp    %ecx,%edx
 76e:	72 10                	jb     780 <free+0x30>
 770:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 774:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	73 f0                	jae    768 <free+0x18>
 778:	39 ca                	cmp    %ecx,%edx
 77a:	72 04                	jb     780 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77c:	39 c8                	cmp    %ecx,%eax
 77e:	72 f0                	jb     770 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 780:	8b 73 fc             	mov    -0x4(%ebx),%esi
 783:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 786:	39 cf                	cmp    %ecx,%edi
 788:	74 1e                	je     7a8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 78a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 78d:	8b 48 04             	mov    0x4(%eax),%ecx
 790:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 793:	39 f2                	cmp    %esi,%edx
 795:	74 28                	je     7bf <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 797:	89 10                	mov    %edx,(%eax)
  freep = p;
 799:	a3 2c 0c 00 00       	mov    %eax,0xc2c
}
 79e:	5b                   	pop    %ebx
 79f:	5e                   	pop    %esi
 7a0:	5f                   	pop    %edi
 7a1:	5d                   	pop    %ebp
 7a2:	c3                   	ret    
 7a3:	90                   	nop
 7a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7a8:	03 71 04             	add    0x4(%ecx),%esi
 7ab:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ae:	8b 08                	mov    (%eax),%ecx
 7b0:	8b 09                	mov    (%ecx),%ecx
 7b2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7b5:	8b 48 04             	mov    0x4(%eax),%ecx
 7b8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 7bb:	39 f2                	cmp    %esi,%edx
 7bd:	75 d8                	jne    797 <free+0x47>
    p->s.size += bp->s.size;
 7bf:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 7c2:	a3 2c 0c 00 00       	mov    %eax,0xc2c
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ca:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7cd:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7cf:	5b                   	pop    %ebx
 7d0:	5e                   	pop    %esi
 7d1:	5f                   	pop    %edi
 7d2:	5d                   	pop    %ebp
 7d3:	c3                   	ret    
 7d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000007e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	56                   	push   %esi
 7e5:	53                   	push   %ebx
 7e6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7ec:	8b 1d 2c 0c 00 00    	mov    0xc2c,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f2:	8d 48 07             	lea    0x7(%eax),%ecx
 7f5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 7f8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fa:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 7fd:	0f 84 9b 00 00 00    	je     89e <malloc+0xbe>
 803:	8b 13                	mov    (%ebx),%edx
 805:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 808:	39 fe                	cmp    %edi,%esi
 80a:	76 64                	jbe    870 <malloc+0x90>
 80c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 813:	bb 00 80 00 00       	mov    $0x8000,%ebx
 818:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 81b:	eb 0e                	jmp    82b <malloc+0x4b>
 81d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 820:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 822:	8b 78 04             	mov    0x4(%eax),%edi
 825:	39 fe                	cmp    %edi,%esi
 827:	76 4f                	jbe    878 <malloc+0x98>
 829:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82b:	3b 15 2c 0c 00 00    	cmp    0xc2c,%edx
 831:	75 ed                	jne    820 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 836:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 83c:	bf 00 10 00 00       	mov    $0x1000,%edi
 841:	0f 43 fe             	cmovae %esi,%edi
 844:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 847:	89 04 24             	mov    %eax,(%esp)
 84a:	e8 0b fc ff ff       	call   45a <sbrk>
  if(p == (char*)-1)
 84f:	83 f8 ff             	cmp    $0xffffffff,%eax
 852:	74 18                	je     86c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 854:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 857:	83 c0 08             	add    $0x8,%eax
 85a:	89 04 24             	mov    %eax,(%esp)
 85d:	e8 ee fe ff ff       	call   750 <free>
  return freep;
 862:	8b 15 2c 0c 00 00    	mov    0xc2c,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 868:	85 d2                	test   %edx,%edx
 86a:	75 b4                	jne    820 <malloc+0x40>
        return 0;
 86c:	31 c0                	xor    %eax,%eax
 86e:	eb 20                	jmp    890 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 870:	89 d0                	mov    %edx,%eax
 872:	89 da                	mov    %ebx,%edx
 874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 878:	39 fe                	cmp    %edi,%esi
 87a:	74 1c                	je     898 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 87c:	29 f7                	sub    %esi,%edi
 87e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 881:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 884:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 887:	89 15 2c 0c 00 00    	mov    %edx,0xc2c
      return (void*)(p + 1);
 88d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 890:	83 c4 1c             	add    $0x1c,%esp
 893:	5b                   	pop    %ebx
 894:	5e                   	pop    %esi
 895:	5f                   	pop    %edi
 896:	5d                   	pop    %ebp
 897:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 898:	8b 08                	mov    (%eax),%ecx
 89a:	89 0a                	mov    %ecx,(%edx)
 89c:	eb e9                	jmp    887 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 89e:	c7 05 2c 0c 00 00 30 	movl   $0xc30,0xc2c
 8a5:	0c 00 00 
    base.s.size = 0;
 8a8:	ba 30 0c 00 00       	mov    $0xc30,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8ad:	c7 05 30 0c 00 00 30 	movl   $0xc30,0xc30
 8b4:	0c 00 00 
    base.s.size = 0;
 8b7:	c7 05 34 0c 00 00 00 	movl   $0x0,0xc34
 8be:	00 00 00 
 8c1:	e9 46 ff ff ff       	jmp    80c <malloc+0x2c>

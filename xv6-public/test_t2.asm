
_test_t2:     file format elf32-i386


Disassembly of section .text:

00000000 <start_routine>:
#include "types.h"
#include "stat.h"
#include "user.h"

void * start_routine(void * arg) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	83 ec 30             	sub    $0x30,%esp
  int i;
  int n = (int)arg;
   8:	8b 45 08             	mov    0x8(%ebp),%eax
   b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for (i = 0; i < 2; ++i) {
   e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  15:	eb 3e                	jmp    55 <start_routine+0x55>
    printf(0, "** Thread. I am running!, arg:%d, pid:%d, tid:%d, ppid:%d **\n", n, getpid(),gettid(), getppid());
  17:	e8 b7 04 00 00       	call   4d3 <getppid>
  1c:	89 c6                	mov    %eax,%esi
  1e:	e8 e8 04 00 00       	call   50b <gettid>
  23:	89 c3                	mov    %eax,%ebx
  25:	e8 81 04 00 00       	call   4ab <getpid>
  2a:	89 74 24 14          	mov    %esi,0x14(%esp)
  2e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  32:	89 44 24 0c          	mov    %eax,0xc(%esp)
  36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  39:	89 44 24 08          	mov    %eax,0x8(%esp)
  3d:	c7 44 24 04 c0 09 00 	movl   $0x9c0,0x4(%esp)
  44:	00 
  45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  4c:	e8 a2 05 00 00       	call   5f3 <printf>

void * start_routine(void * arg) {
  int i;
  int n = (int)arg;

  for (i = 0; i < 2; ++i) {
  51:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  55:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  59:	7e bc                	jle    17 <start_routine+0x17>
    printf(0, "** Thread. I am running!, arg:%d, pid:%d, tid:%d, ppid:%d **\n", n, getpid(),gettid(), getppid());
  }

  thread_exit((void*)999);
  5b:	c7 04 24 e7 03 00 00 	movl   $0x3e7,(%esp)
  62:	e8 94 04 00 00       	call   4fb <thread_exit>

00000067 <main>:
  return (void*)0xEFEFEFEF;
}

int
main(int argc, char *argv[])
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	53                   	push   %ebx
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 30             	sub    $0x30,%esp
  thread_t thread = 200;
  71:	c7 44 24 24 c8 00 00 	movl   $0xc8,0x24(%esp)
  78:	00 
  thread_t thread2 = 200;
  79:	c7 44 24 20 c8 00 00 	movl   $0xc8,0x20(%esp)
  80:	00 
  int a = 10000;
  81:	c7 44 24 28 10 27 00 	movl   $0x2710,0x28(%esp)
  88:	00 
  int* return_value = 0;
  89:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  90:	00 

  printf(1, "(main)a:%d\n", a);
  91:	8b 44 24 28          	mov    0x28(%esp),%eax
  95:	89 44 24 08          	mov    %eax,0x8(%esp)
  99:	c7 44 24 04 fe 09 00 	movl   $0x9fe,0x4(%esp)
  a0:	00 
  a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a8:	e8 46 05 00 00       	call   5f3 <printf>

  thread_create(&thread, start_routine, (void*)a);
  ad:	8b 44 24 28          	mov    0x28(%esp),%eax
  b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  bc:	00 
  bd:	8d 44 24 24          	lea    0x24(%esp),%eax
  c1:	89 04 24             	mov    %eax,(%esp)
  c4:	e8 2a 04 00 00       	call   4f3 <thread_create>
  thread_create(&thread2, start_routine, (void*)a);
  c9:	8b 44 24 28          	mov    0x28(%esp),%eax
  cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  d8:	00 
  d9:	8d 44 24 20          	lea    0x20(%esp),%eax
  dd:	89 04 24             	mov    %eax,(%esp)
  e0:	e8 0e 04 00 00       	call   4f3 <thread_create>
  thread_join(thread, (void**)&return_value);
  e5:	8b 44 24 24          	mov    0x24(%esp),%eax
  e9:	8d 54 24 1c          	lea    0x1c(%esp),%edx
  ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  f1:	89 04 24             	mov    %eax,(%esp)
  f4:	e8 0a 04 00 00       	call   503 <thread_join>
  printf(1, "(main)join1 return_value: %d\n", return_value);
  f9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  fd:	89 44 24 08          	mov    %eax,0x8(%esp)
 101:	c7 44 24 04 0a 0a 00 	movl   $0xa0a,0x4(%esp)
 108:	00 
 109:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 110:	e8 de 04 00 00       	call   5f3 <printf>
  thread_join(thread2, (void**)&return_value);
 115:	8b 44 24 20          	mov    0x20(%esp),%eax
 119:	8d 54 24 1c          	lea    0x1c(%esp),%edx
 11d:	89 54 24 04          	mov    %edx,0x4(%esp)
 121:	89 04 24             	mov    %eax,(%esp)
 124:	e8 da 03 00 00       	call   503 <thread_join>
  printf(1, "(main)join2 return_value: %d\n", return_value);
 129:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 12d:	89 44 24 08          	mov    %eax,0x8(%esp)
 131:	c7 44 24 04 28 0a 00 	movl   $0xa28,0x4(%esp)
 138:	00 
 139:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 140:	e8 ae 04 00 00       	call   5f3 <printf>

  printf(1, "(main)start_routine: %p\n", start_routine);
 145:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 14c:	00 
 14d:	c7 44 24 04 46 0a 00 	movl   $0xa46,0x4(%esp)
 154:	00 
 155:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15c:	e8 92 04 00 00       	call   5f3 <printf>
  printf(1, "(main)ppid: %d, pid: %d\n", getppid(), getpid());
 161:	e8 45 03 00 00       	call   4ab <getpid>
 166:	89 c3                	mov    %eax,%ebx
 168:	e8 66 03 00 00       	call   4d3 <getppid>
 16d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 171:	89 44 24 08          	mov    %eax,0x8(%esp)
 175:	c7 44 24 04 5f 0a 00 	movl   $0xa5f,0x4(%esp)
 17c:	00 
 17d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 184:	e8 6a 04 00 00       	call   5f3 <printf>

  printf(1, "(main)a:%d\n", a);
 189:	8b 44 24 28          	mov    0x28(%esp),%eax
 18d:	89 44 24 08          	mov    %eax,0x8(%esp)
 191:	c7 44 24 04 fe 09 00 	movl   $0x9fe,0x4(%esp)
 198:	00 
 199:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1a0:	e8 4e 04 00 00       	call   5f3 <printf>

  {
    int i;
    for (i = 0; i < 210000000; ++i) {
 1a5:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
 1ac:	00 
 1ad:	eb 05                	jmp    1b4 <main+0x14d>
 1af:	83 44 24 2c 01       	addl   $0x1,0x2c(%esp)
 1b4:	81 7c 24 2c 7f 58 84 	cmpl   $0xc84587f,0x2c(%esp)
 1bb:	0c 
 1bc:	7e f1                	jle    1af <main+0x148>
      
    }
  }

  exit();
 1be:	e8 68 02 00 00       	call   42b <exit>

000001c3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1c3:	55                   	push   %ebp
 1c4:	89 e5                	mov    %esp,%ebp
 1c6:	57                   	push   %edi
 1c7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1cb:	8b 55 10             	mov    0x10(%ebp),%edx
 1ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d1:	89 cb                	mov    %ecx,%ebx
 1d3:	89 df                	mov    %ebx,%edi
 1d5:	89 d1                	mov    %edx,%ecx
 1d7:	fc                   	cld    
 1d8:	f3 aa                	rep stos %al,%es:(%edi)
 1da:	89 ca                	mov    %ecx,%edx
 1dc:	89 fb                	mov    %edi,%ebx
 1de:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1e1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1e4:	5b                   	pop    %ebx
 1e5:	5f                   	pop    %edi
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    

000001e8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1f4:	90                   	nop
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	8d 50 01             	lea    0x1(%eax),%edx
 1fb:	89 55 08             	mov    %edx,0x8(%ebp)
 1fe:	8b 55 0c             	mov    0xc(%ebp),%edx
 201:	8d 4a 01             	lea    0x1(%edx),%ecx
 204:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 207:	0f b6 12             	movzbl (%edx),%edx
 20a:	88 10                	mov    %dl,(%eax)
 20c:	0f b6 00             	movzbl (%eax),%eax
 20f:	84 c0                	test   %al,%al
 211:	75 e2                	jne    1f5 <strcpy+0xd>
    ;
  return os;
 213:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 21b:	eb 08                	jmp    225 <strcmp+0xd>
    p++, q++;
 21d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 221:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	84 c0                	test   %al,%al
 22d:	74 10                	je     23f <strcmp+0x27>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 10             	movzbl (%eax),%edx
 235:	8b 45 0c             	mov    0xc(%ebp),%eax
 238:	0f b6 00             	movzbl (%eax),%eax
 23b:	38 c2                	cmp    %al,%dl
 23d:	74 de                	je     21d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	0f b6 00             	movzbl (%eax),%eax
 245:	0f b6 d0             	movzbl %al,%edx
 248:	8b 45 0c             	mov    0xc(%ebp),%eax
 24b:	0f b6 00             	movzbl (%eax),%eax
 24e:	0f b6 c0             	movzbl %al,%eax
 251:	29 c2                	sub    %eax,%edx
 253:	89 d0                	mov    %edx,%eax
}
 255:	5d                   	pop    %ebp
 256:	c3                   	ret    

00000257 <strlen>:

uint
strlen(char *s)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 25d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 264:	eb 04                	jmp    26a <strlen+0x13>
 266:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 26a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	01 d0                	add    %edx,%eax
 272:	0f b6 00             	movzbl (%eax),%eax
 275:	84 c0                	test   %al,%al
 277:	75 ed                	jne    266 <strlen+0xf>
    ;
  return n;
 279:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27c:	c9                   	leave  
 27d:	c3                   	ret    

0000027e <memset>:

void*
memset(void *dst, int c, uint n)
{
 27e:	55                   	push   %ebp
 27f:	89 e5                	mov    %esp,%ebp
 281:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 284:	8b 45 10             	mov    0x10(%ebp),%eax
 287:	89 44 24 08          	mov    %eax,0x8(%esp)
 28b:	8b 45 0c             	mov    0xc(%ebp),%eax
 28e:	89 44 24 04          	mov    %eax,0x4(%esp)
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	89 04 24             	mov    %eax,(%esp)
 298:	e8 26 ff ff ff       	call   1c3 <stosb>
  return dst;
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <strchr>:

char*
strchr(const char *s, char c)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 04             	sub    $0x4,%esp
 2a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ab:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ae:	eb 14                	jmp    2c4 <strchr+0x22>
    if(*s == c)
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	0f b6 00             	movzbl (%eax),%eax
 2b6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b9:	75 05                	jne    2c0 <strchr+0x1e>
      return (char*)s;
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	eb 13                	jmp    2d3 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	0f b6 00             	movzbl (%eax),%eax
 2ca:	84 c0                	test   %al,%al
 2cc:	75 e2                	jne    2b0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <gets>:

char*
gets(char *buf, int max)
{
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp
 2d8:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2e2:	eb 4c                	jmp    330 <gets+0x5b>
    cc = read(0, &c, 1);
 2e4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2eb:	00 
 2ec:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2fa:	e8 44 01 00 00       	call   443 <read>
 2ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 302:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 306:	7f 02                	jg     30a <gets+0x35>
      break;
 308:	eb 31                	jmp    33b <gets+0x66>
    buf[i++] = c;
 30a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30d:	8d 50 01             	lea    0x1(%eax),%edx
 310:	89 55 f4             	mov    %edx,-0xc(%ebp)
 313:	89 c2                	mov    %eax,%edx
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	01 c2                	add    %eax,%edx
 31a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 320:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 324:	3c 0a                	cmp    $0xa,%al
 326:	74 13                	je     33b <gets+0x66>
 328:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32c:	3c 0d                	cmp    $0xd,%al
 32e:	74 0b                	je     33b <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 330:	8b 45 f4             	mov    -0xc(%ebp),%eax
 333:	83 c0 01             	add    $0x1,%eax
 336:	3b 45 0c             	cmp    0xc(%ebp),%eax
 339:	7c a9                	jl     2e4 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 33b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	01 d0                	add    %edx,%eax
 343:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 346:	8b 45 08             	mov    0x8(%ebp),%eax
}
 349:	c9                   	leave  
 34a:	c3                   	ret    

0000034b <stat>:

int
stat(char *n, struct stat *st)
{
 34b:	55                   	push   %ebp
 34c:	89 e5                	mov    %esp,%ebp
 34e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 351:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 358:	00 
 359:	8b 45 08             	mov    0x8(%ebp),%eax
 35c:	89 04 24             	mov    %eax,(%esp)
 35f:	e8 07 01 00 00       	call   46b <open>
 364:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 367:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 36b:	79 07                	jns    374 <stat+0x29>
    return -1;
 36d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 372:	eb 23                	jmp    397 <stat+0x4c>
  r = fstat(fd, st);
 374:	8b 45 0c             	mov    0xc(%ebp),%eax
 377:	89 44 24 04          	mov    %eax,0x4(%esp)
 37b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37e:	89 04 24             	mov    %eax,(%esp)
 381:	e8 fd 00 00 00       	call   483 <fstat>
 386:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 389:	8b 45 f4             	mov    -0xc(%ebp),%eax
 38c:	89 04 24             	mov    %eax,(%esp)
 38f:	e8 bf 00 00 00       	call   453 <close>
  return r;
 394:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 397:	c9                   	leave  
 398:	c3                   	ret    

00000399 <atoi>:

int
atoi(const char *s)
{
 399:	55                   	push   %ebp
 39a:	89 e5                	mov    %esp,%ebp
 39c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 39f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a6:	eb 25                	jmp    3cd <atoi+0x34>
    n = n*10 + *s++ - '0';
 3a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ab:	89 d0                	mov    %edx,%eax
 3ad:	c1 e0 02             	shl    $0x2,%eax
 3b0:	01 d0                	add    %edx,%eax
 3b2:	01 c0                	add    %eax,%eax
 3b4:	89 c1                	mov    %eax,%ecx
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	8d 50 01             	lea    0x1(%eax),%edx
 3bc:	89 55 08             	mov    %edx,0x8(%ebp)
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	0f be c0             	movsbl %al,%eax
 3c5:	01 c8                	add    %ecx,%eax
 3c7:	83 e8 30             	sub    $0x30,%eax
 3ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
 3d0:	0f b6 00             	movzbl (%eax),%eax
 3d3:	3c 2f                	cmp    $0x2f,%al
 3d5:	7e 0a                	jle    3e1 <atoi+0x48>
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	3c 39                	cmp    $0x39,%al
 3df:	7e c7                	jle    3a8 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e4:	c9                   	leave  
 3e5:	c3                   	ret    

000003e6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 3ec:	8b 45 08             	mov    0x8(%ebp),%eax
 3ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3f8:	eb 17                	jmp    411 <memmove+0x2b>
    *dst++ = *src++;
 3fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fd:	8d 50 01             	lea    0x1(%eax),%edx
 400:	89 55 fc             	mov    %edx,-0x4(%ebp)
 403:	8b 55 f8             	mov    -0x8(%ebp),%edx
 406:	8d 4a 01             	lea    0x1(%edx),%ecx
 409:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 40c:	0f b6 12             	movzbl (%edx),%edx
 40f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 411:	8b 45 10             	mov    0x10(%ebp),%eax
 414:	8d 50 ff             	lea    -0x1(%eax),%edx
 417:	89 55 10             	mov    %edx,0x10(%ebp)
 41a:	85 c0                	test   %eax,%eax
 41c:	7f dc                	jg     3fa <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 41e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 421:	c9                   	leave  
 422:	c3                   	ret    

00000423 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 423:	b8 01 00 00 00       	mov    $0x1,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <exit>:
SYSCALL(exit)
 42b:	b8 02 00 00 00       	mov    $0x2,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <wait>:
SYSCALL(wait)
 433:	b8 03 00 00 00       	mov    $0x3,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <pipe>:
SYSCALL(pipe)
 43b:	b8 04 00 00 00       	mov    $0x4,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <read>:
SYSCALL(read)
 443:	b8 05 00 00 00       	mov    $0x5,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <write>:
SYSCALL(write)
 44b:	b8 10 00 00 00       	mov    $0x10,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <close>:
SYSCALL(close)
 453:	b8 15 00 00 00       	mov    $0x15,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <kill>:
SYSCALL(kill)
 45b:	b8 06 00 00 00       	mov    $0x6,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <exec>:
SYSCALL(exec)
 463:	b8 07 00 00 00       	mov    $0x7,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <open>:
SYSCALL(open)
 46b:	b8 0f 00 00 00       	mov    $0xf,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <mknod>:
SYSCALL(mknod)
 473:	b8 11 00 00 00       	mov    $0x11,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <unlink>:
SYSCALL(unlink)
 47b:	b8 12 00 00 00       	mov    $0x12,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <fstat>:
SYSCALL(fstat)
 483:	b8 08 00 00 00       	mov    $0x8,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <link>:
SYSCALL(link)
 48b:	b8 13 00 00 00       	mov    $0x13,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <mkdir>:
SYSCALL(mkdir)
 493:	b8 14 00 00 00       	mov    $0x14,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <chdir>:
SYSCALL(chdir)
 49b:	b8 09 00 00 00       	mov    $0x9,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <dup>:
SYSCALL(dup)
 4a3:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <getpid>:
SYSCALL(getpid)
 4ab:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <sbrk>:
SYSCALL(sbrk)
 4b3:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <sleep>:
SYSCALL(sleep)
 4bb:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <uptime>:
SYSCALL(uptime)
 4c3:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <my_syscall>:
SYSCALL(my_syscall)
 4cb:	b8 16 00 00 00       	mov    $0x16,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <getppid>:
SYSCALL(getppid)
 4d3:	b8 17 00 00 00       	mov    $0x17,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <yield>:
SYSCALL(yield)
 4db:	b8 18 00 00 00       	mov    $0x18,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <getlev>:
SYSCALL(getlev)
 4e3:	b8 19 00 00 00       	mov    $0x19,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <set_cpu_share>:
SYSCALL(set_cpu_share)
 4eb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <thread_create>:
SYSCALL(thread_create)
 4f3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <thread_exit>:
SYSCALL(thread_exit)
 4fb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <thread_join>:
SYSCALL(thread_join)
 503:	b8 1d 00 00 00       	mov    $0x1d,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <gettid>:
SYSCALL(gettid)
 50b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 513:	55                   	push   %ebp
 514:	89 e5                	mov    %esp,%ebp
 516:	83 ec 18             	sub    $0x18,%esp
 519:	8b 45 0c             	mov    0xc(%ebp),%eax
 51c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 51f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 526:	00 
 527:	8d 45 f4             	lea    -0xc(%ebp),%eax
 52a:	89 44 24 04          	mov    %eax,0x4(%esp)
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	89 04 24             	mov    %eax,(%esp)
 534:	e8 12 ff ff ff       	call   44b <write>
}
 539:	c9                   	leave  
 53a:	c3                   	ret    

0000053b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 53b:	55                   	push   %ebp
 53c:	89 e5                	mov    %esp,%ebp
 53e:	56                   	push   %esi
 53f:	53                   	push   %ebx
 540:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 543:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 54a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 54e:	74 17                	je     567 <printint+0x2c>
 550:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 554:	79 11                	jns    567 <printint+0x2c>
    neg = 1;
 556:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 55d:	8b 45 0c             	mov    0xc(%ebp),%eax
 560:	f7 d8                	neg    %eax
 562:	89 45 ec             	mov    %eax,-0x14(%ebp)
 565:	eb 06                	jmp    56d <printint+0x32>
  } else {
    x = xx;
 567:	8b 45 0c             	mov    0xc(%ebp),%eax
 56a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 56d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 574:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 577:	8d 41 01             	lea    0x1(%ecx),%eax
 57a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 57d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 580:	8b 45 ec             	mov    -0x14(%ebp),%eax
 583:	ba 00 00 00 00       	mov    $0x0,%edx
 588:	f7 f3                	div    %ebx
 58a:	89 d0                	mov    %edx,%eax
 58c:	0f b6 80 e4 0c 00 00 	movzbl 0xce4(%eax),%eax
 593:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 597:	8b 75 10             	mov    0x10(%ebp),%esi
 59a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59d:	ba 00 00 00 00       	mov    $0x0,%edx
 5a2:	f7 f6                	div    %esi
 5a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ab:	75 c7                	jne    574 <printint+0x39>
  if(neg)
 5ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5b1:	74 10                	je     5c3 <printint+0x88>
    buf[i++] = '-';
 5b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b6:	8d 50 01             	lea    0x1(%eax),%edx
 5b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5bc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5c1:	eb 1f                	jmp    5e2 <printint+0xa7>
 5c3:	eb 1d                	jmp    5e2 <printint+0xa7>
    putc(fd, buf[i]);
 5c5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cb:	01 d0                	add    %edx,%eax
 5cd:	0f b6 00             	movzbl (%eax),%eax
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	89 04 24             	mov    %eax,(%esp)
 5dd:	e8 31 ff ff ff       	call   513 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5e2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ea:	79 d9                	jns    5c5 <printint+0x8a>
    putc(fd, buf[i]);
}
 5ec:	83 c4 30             	add    $0x30,%esp
 5ef:	5b                   	pop    %ebx
 5f0:	5e                   	pop    %esi
 5f1:	5d                   	pop    %ebp
 5f2:	c3                   	ret    

000005f3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5f3:	55                   	push   %ebp
 5f4:	89 e5                	mov    %esp,%ebp
 5f6:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5f9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 600:	8d 45 0c             	lea    0xc(%ebp),%eax
 603:	83 c0 04             	add    $0x4,%eax
 606:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 609:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 610:	e9 7c 01 00 00       	jmp    791 <printf+0x19e>
    c = fmt[i] & 0xff;
 615:	8b 55 0c             	mov    0xc(%ebp),%edx
 618:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61b:	01 d0                	add    %edx,%eax
 61d:	0f b6 00             	movzbl (%eax),%eax
 620:	0f be c0             	movsbl %al,%eax
 623:	25 ff 00 00 00       	and    $0xff,%eax
 628:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 62b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 62f:	75 2c                	jne    65d <printf+0x6a>
      if(c == '%'){
 631:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 635:	75 0c                	jne    643 <printf+0x50>
        state = '%';
 637:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 63e:	e9 4a 01 00 00       	jmp    78d <printf+0x19a>
      } else {
        putc(fd, c);
 643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 646:	0f be c0             	movsbl %al,%eax
 649:	89 44 24 04          	mov    %eax,0x4(%esp)
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	89 04 24             	mov    %eax,(%esp)
 653:	e8 bb fe ff ff       	call   513 <putc>
 658:	e9 30 01 00 00       	jmp    78d <printf+0x19a>
      }
    } else if(state == '%'){
 65d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 661:	0f 85 26 01 00 00    	jne    78d <printf+0x19a>
      if(c == 'd'){
 667:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 66b:	75 2d                	jne    69a <printf+0xa7>
        printint(fd, *ap, 10, 1);
 66d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 679:	00 
 67a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 681:	00 
 682:	89 44 24 04          	mov    %eax,0x4(%esp)
 686:	8b 45 08             	mov    0x8(%ebp),%eax
 689:	89 04 24             	mov    %eax,(%esp)
 68c:	e8 aa fe ff ff       	call   53b <printint>
        ap++;
 691:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 695:	e9 ec 00 00 00       	jmp    786 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 69a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 69e:	74 06                	je     6a6 <printf+0xb3>
 6a0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6a4:	75 2d                	jne    6d3 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a9:	8b 00                	mov    (%eax),%eax
 6ab:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6b2:	00 
 6b3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6ba:	00 
 6bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bf:	8b 45 08             	mov    0x8(%ebp),%eax
 6c2:	89 04 24             	mov    %eax,(%esp)
 6c5:	e8 71 fe ff ff       	call   53b <printint>
        ap++;
 6ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ce:	e9 b3 00 00 00       	jmp    786 <printf+0x193>
      } else if(c == 's'){
 6d3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6d7:	75 45                	jne    71e <printf+0x12b>
        s = (char*)*ap;
 6d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6dc:	8b 00                	mov    (%eax),%eax
 6de:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e9:	75 09                	jne    6f4 <printf+0x101>
          s = "(null)";
 6eb:	c7 45 f4 78 0a 00 00 	movl   $0xa78,-0xc(%ebp)
        while(*s != 0){
 6f2:	eb 1e                	jmp    712 <printf+0x11f>
 6f4:	eb 1c                	jmp    712 <printf+0x11f>
          putc(fd, *s);
 6f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f9:	0f b6 00             	movzbl (%eax),%eax
 6fc:	0f be c0             	movsbl %al,%eax
 6ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	89 04 24             	mov    %eax,(%esp)
 709:	e8 05 fe ff ff       	call   513 <putc>
          s++;
 70e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 712:	8b 45 f4             	mov    -0xc(%ebp),%eax
 715:	0f b6 00             	movzbl (%eax),%eax
 718:	84 c0                	test   %al,%al
 71a:	75 da                	jne    6f6 <printf+0x103>
 71c:	eb 68                	jmp    786 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 71e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 722:	75 1d                	jne    741 <printf+0x14e>
        putc(fd, *ap);
 724:	8b 45 e8             	mov    -0x18(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	0f be c0             	movsbl %al,%eax
 72c:	89 44 24 04          	mov    %eax,0x4(%esp)
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	89 04 24             	mov    %eax,(%esp)
 736:	e8 d8 fd ff ff       	call   513 <putc>
        ap++;
 73b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73f:	eb 45                	jmp    786 <printf+0x193>
      } else if(c == '%'){
 741:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 745:	75 17                	jne    75e <printf+0x16b>
        putc(fd, c);
 747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 74a:	0f be c0             	movsbl %al,%eax
 74d:	89 44 24 04          	mov    %eax,0x4(%esp)
 751:	8b 45 08             	mov    0x8(%ebp),%eax
 754:	89 04 24             	mov    %eax,(%esp)
 757:	e8 b7 fd ff ff       	call   513 <putc>
 75c:	eb 28                	jmp    786 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 75e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 765:	00 
 766:	8b 45 08             	mov    0x8(%ebp),%eax
 769:	89 04 24             	mov    %eax,(%esp)
 76c:	e8 a2 fd ff ff       	call   513 <putc>
        putc(fd, c);
 771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 774:	0f be c0             	movsbl %al,%eax
 777:	89 44 24 04          	mov    %eax,0x4(%esp)
 77b:	8b 45 08             	mov    0x8(%ebp),%eax
 77e:	89 04 24             	mov    %eax,(%esp)
 781:	e8 8d fd ff ff       	call   513 <putc>
      }
      state = 0;
 786:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 78d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 791:	8b 55 0c             	mov    0xc(%ebp),%edx
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	01 d0                	add    %edx,%eax
 799:	0f b6 00             	movzbl (%eax),%eax
 79c:	84 c0                	test   %al,%al
 79e:	0f 85 71 fe ff ff    	jne    615 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7a4:	c9                   	leave  
 7a5:	c3                   	ret    

000007a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a6:	55                   	push   %ebp
 7a7:	89 e5                	mov    %esp,%ebp
 7a9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	83 e8 08             	sub    $0x8,%eax
 7b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b5:	a1 00 0d 00 00       	mov    0xd00,%eax
 7ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7bd:	eb 24                	jmp    7e3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	8b 00                	mov    (%eax),%eax
 7c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c7:	77 12                	ja     7db <free+0x35>
 7c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7cf:	77 24                	ja     7f5 <free+0x4f>
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d9:	77 1a                	ja     7f5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	8b 00                	mov    (%eax),%eax
 7e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e9:	76 d4                	jbe    7bf <free+0x19>
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	8b 00                	mov    (%eax),%eax
 7f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f3:	76 ca                	jbe    7bf <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	8b 40 04             	mov    0x4(%eax),%eax
 7fb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 802:	8b 45 f8             	mov    -0x8(%ebp),%eax
 805:	01 c2                	add    %eax,%edx
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	8b 00                	mov    (%eax),%eax
 80c:	39 c2                	cmp    %eax,%edx
 80e:	75 24                	jne    834 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 810:	8b 45 f8             	mov    -0x8(%ebp),%eax
 813:	8b 50 04             	mov    0x4(%eax),%edx
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	8b 00                	mov    (%eax),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	01 c2                	add    %eax,%edx
 820:	8b 45 f8             	mov    -0x8(%ebp),%eax
 823:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 826:	8b 45 fc             	mov    -0x4(%ebp),%eax
 829:	8b 00                	mov    (%eax),%eax
 82b:	8b 10                	mov    (%eax),%edx
 82d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 830:	89 10                	mov    %edx,(%eax)
 832:	eb 0a                	jmp    83e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	8b 10                	mov    (%eax),%edx
 839:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 841:	8b 40 04             	mov    0x4(%eax),%eax
 844:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 84b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84e:	01 d0                	add    %edx,%eax
 850:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 853:	75 20                	jne    875 <free+0xcf>
    p->s.size += bp->s.size;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 50 04             	mov    0x4(%eax),%edx
 85b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85e:	8b 40 04             	mov    0x4(%eax),%eax
 861:	01 c2                	add    %eax,%edx
 863:	8b 45 fc             	mov    -0x4(%ebp),%eax
 866:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 869:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86c:	8b 10                	mov    (%eax),%edx
 86e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 871:	89 10                	mov    %edx,(%eax)
 873:	eb 08                	jmp    87d <free+0xd7>
  } else
    p->s.ptr = bp;
 875:	8b 45 fc             	mov    -0x4(%ebp),%eax
 878:	8b 55 f8             	mov    -0x8(%ebp),%edx
 87b:	89 10                	mov    %edx,(%eax)
  freep = p;
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	a3 00 0d 00 00       	mov    %eax,0xd00
}
 885:	c9                   	leave  
 886:	c3                   	ret    

00000887 <morecore>:

static Header*
morecore(uint nu)
{
 887:	55                   	push   %ebp
 888:	89 e5                	mov    %esp,%ebp
 88a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 88d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 894:	77 07                	ja     89d <morecore+0x16>
    nu = 4096;
 896:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 89d:	8b 45 08             	mov    0x8(%ebp),%eax
 8a0:	c1 e0 03             	shl    $0x3,%eax
 8a3:	89 04 24             	mov    %eax,(%esp)
 8a6:	e8 08 fc ff ff       	call   4b3 <sbrk>
 8ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8ae:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8b2:	75 07                	jne    8bb <morecore+0x34>
    return 0;
 8b4:	b8 00 00 00 00       	mov    $0x0,%eax
 8b9:	eb 22                	jmp    8dd <morecore+0x56>
  hp = (Header*)p;
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c4:	8b 55 08             	mov    0x8(%ebp),%edx
 8c7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cd:	83 c0 08             	add    $0x8,%eax
 8d0:	89 04 24             	mov    %eax,(%esp)
 8d3:	e8 ce fe ff ff       	call   7a6 <free>
  return freep;
 8d8:	a1 00 0d 00 00       	mov    0xd00,%eax
}
 8dd:	c9                   	leave  
 8de:	c3                   	ret    

000008df <malloc>:

void*
malloc(uint nbytes)
{
 8df:	55                   	push   %ebp
 8e0:	89 e5                	mov    %esp,%ebp
 8e2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e5:	8b 45 08             	mov    0x8(%ebp),%eax
 8e8:	83 c0 07             	add    $0x7,%eax
 8eb:	c1 e8 03             	shr    $0x3,%eax
 8ee:	83 c0 01             	add    $0x1,%eax
 8f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8f4:	a1 00 0d 00 00       	mov    0xd00,%eax
 8f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 900:	75 23                	jne    925 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 902:	c7 45 f0 f8 0c 00 00 	movl   $0xcf8,-0x10(%ebp)
 909:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90c:	a3 00 0d 00 00       	mov    %eax,0xd00
 911:	a1 00 0d 00 00       	mov    0xd00,%eax
 916:	a3 f8 0c 00 00       	mov    %eax,0xcf8
    base.s.size = 0;
 91b:	c7 05 fc 0c 00 00 00 	movl   $0x0,0xcfc
 922:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 925:	8b 45 f0             	mov    -0x10(%ebp),%eax
 928:	8b 00                	mov    (%eax),%eax
 92a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 92d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 930:	8b 40 04             	mov    0x4(%eax),%eax
 933:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 936:	72 4d                	jb     985 <malloc+0xa6>
      if(p->s.size == nunits)
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	8b 40 04             	mov    0x4(%eax),%eax
 93e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 941:	75 0c                	jne    94f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	8b 10                	mov    (%eax),%edx
 948:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94b:	89 10                	mov    %edx,(%eax)
 94d:	eb 26                	jmp    975 <malloc+0x96>
      else {
        p->s.size -= nunits;
 94f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 952:	8b 40 04             	mov    0x4(%eax),%eax
 955:	2b 45 ec             	sub    -0x14(%ebp),%eax
 958:	89 c2                	mov    %eax,%edx
 95a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 960:	8b 45 f4             	mov    -0xc(%ebp),%eax
 963:	8b 40 04             	mov    0x4(%eax),%eax
 966:	c1 e0 03             	shl    $0x3,%eax
 969:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 96c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 972:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 975:	8b 45 f0             	mov    -0x10(%ebp),%eax
 978:	a3 00 0d 00 00       	mov    %eax,0xd00
      return (void*)(p + 1);
 97d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 980:	83 c0 08             	add    $0x8,%eax
 983:	eb 38                	jmp    9bd <malloc+0xde>
    }
    if(p == freep)
 985:	a1 00 0d 00 00       	mov    0xd00,%eax
 98a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 98d:	75 1b                	jne    9aa <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 98f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 992:	89 04 24             	mov    %eax,(%esp)
 995:	e8 ed fe ff ff       	call   887 <morecore>
 99a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 99d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a1:	75 07                	jne    9aa <malloc+0xcb>
        return 0;
 9a3:	b8 00 00 00 00       	mov    $0x0,%eax
 9a8:	eb 13                	jmp    9bd <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b3:	8b 00                	mov    (%eax),%eax
 9b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9b8:	e9 70 ff ff ff       	jmp    92d <malloc+0x4e>
}
 9bd:	c9                   	leave  
 9be:	c3                   	ret    

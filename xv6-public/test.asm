
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  *     exit();
  * } */

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
    __asm__("int $128");
   6:	cd 80                	int    $0x80
    exit();
   8:	e8 68 02 00 00       	call   275 <exit>

0000000d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
   d:	55                   	push   %ebp
   e:	89 e5                	mov    %esp,%ebp
  10:	57                   	push   %edi
  11:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  12:	8b 4d 08             	mov    0x8(%ebp),%ecx
  15:	8b 55 10             	mov    0x10(%ebp),%edx
  18:	8b 45 0c             	mov    0xc(%ebp),%eax
  1b:	89 cb                	mov    %ecx,%ebx
  1d:	89 df                	mov    %ebx,%edi
  1f:	89 d1                	mov    %edx,%ecx
  21:	fc                   	cld    
  22:	f3 aa                	rep stos %al,%es:(%edi)
  24:	89 ca                	mov    %ecx,%edx
  26:	89 fb                	mov    %edi,%ebx
  28:	89 5d 08             	mov    %ebx,0x8(%ebp)
  2b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  2e:	5b                   	pop    %ebx
  2f:	5f                   	pop    %edi
  30:	5d                   	pop    %ebp
  31:	c3                   	ret    

00000032 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  32:	55                   	push   %ebp
  33:	89 e5                	mov    %esp,%ebp
  35:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  38:	8b 45 08             	mov    0x8(%ebp),%eax
  3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  3e:	90                   	nop
  3f:	8b 45 08             	mov    0x8(%ebp),%eax
  42:	8d 50 01             	lea    0x1(%eax),%edx
  45:	89 55 08             	mov    %edx,0x8(%ebp)
  48:	8b 55 0c             	mov    0xc(%ebp),%edx
  4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  4e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  51:	0f b6 12             	movzbl (%edx),%edx
  54:	88 10                	mov    %dl,(%eax)
  56:	0f b6 00             	movzbl (%eax),%eax
  59:	84 c0                	test   %al,%al
  5b:	75 e2                	jne    3f <strcpy+0xd>
    ;
  return os;
  5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  60:	c9                   	leave  
  61:	c3                   	ret    

00000062 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  62:	55                   	push   %ebp
  63:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  65:	eb 08                	jmp    6f <strcmp+0xd>
    p++, q++;
  67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  6b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  6f:	8b 45 08             	mov    0x8(%ebp),%eax
  72:	0f b6 00             	movzbl (%eax),%eax
  75:	84 c0                	test   %al,%al
  77:	74 10                	je     89 <strcmp+0x27>
  79:	8b 45 08             	mov    0x8(%ebp),%eax
  7c:	0f b6 10             	movzbl (%eax),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	0f b6 00             	movzbl (%eax),%eax
  85:	38 c2                	cmp    %al,%dl
  87:	74 de                	je     67 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  89:	8b 45 08             	mov    0x8(%ebp),%eax
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	0f b6 d0             	movzbl %al,%edx
  92:	8b 45 0c             	mov    0xc(%ebp),%eax
  95:	0f b6 00             	movzbl (%eax),%eax
  98:	0f b6 c0             	movzbl %al,%eax
  9b:	29 c2                	sub    %eax,%edx
  9d:	89 d0                	mov    %edx,%eax
}
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strlen>:

uint
strlen(char *s)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ae:	eb 04                	jmp    b4 <strlen+0x13>
  b0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  b7:	8b 45 08             	mov    0x8(%ebp),%eax
  ba:	01 d0                	add    %edx,%eax
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 ed                	jne    b0 <strlen+0xf>
    ;
  return n;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  ce:	8b 45 10             	mov    0x10(%ebp),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	89 04 24             	mov    %eax,(%esp)
  e2:	e8 26 ff ff ff       	call   d <stosb>
  return dst;
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  ea:	c9                   	leave  
  eb:	c3                   	ret    

000000ec <strchr>:

char*
strchr(const char *s, char c)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	83 ec 04             	sub    $0x4,%esp
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
  f8:	eb 14                	jmp    10e <strchr+0x22>
    if(*s == c)
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	3a 45 fc             	cmp    -0x4(%ebp),%al
 103:	75 05                	jne    10a <strchr+0x1e>
      return (char*)s;
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	eb 13                	jmp    11d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 10a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	0f b6 00             	movzbl (%eax),%eax
 114:	84 c0                	test   %al,%al
 116:	75 e2                	jne    fa <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 118:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11d:	c9                   	leave  
 11e:	c3                   	ret    

0000011f <gets>:

char*
gets(char *buf, int max)
{
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 125:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 12c:	eb 4c                	jmp    17a <gets+0x5b>
    cc = read(0, &c, 1);
 12e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 135:	00 
 136:	8d 45 ef             	lea    -0x11(%ebp),%eax
 139:	89 44 24 04          	mov    %eax,0x4(%esp)
 13d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 144:	e8 44 01 00 00       	call   28d <read>
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	7f 02                	jg     154 <gets+0x35>
      break;
 152:	eb 31                	jmp    185 <gets+0x66>
    buf[i++] = c;
 154:	8b 45 f4             	mov    -0xc(%ebp),%eax
 157:	8d 50 01             	lea    0x1(%eax),%edx
 15a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 15d:	89 c2                	mov    %eax,%edx
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	01 c2                	add    %eax,%edx
 164:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 168:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 16a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16e:	3c 0a                	cmp    $0xa,%al
 170:	74 13                	je     185 <gets+0x66>
 172:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 176:	3c 0d                	cmp    $0xd,%al
 178:	74 0b                	je     185 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17d:	83 c0 01             	add    $0x1,%eax
 180:	3b 45 0c             	cmp    0xc(%ebp),%eax
 183:	7c a9                	jl     12e <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 185:	8b 55 f4             	mov    -0xc(%ebp),%edx
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	01 d0                	add    %edx,%eax
 18d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 190:	8b 45 08             	mov    0x8(%ebp),%eax
}
 193:	c9                   	leave  
 194:	c3                   	ret    

00000195 <stat>:

int
stat(char *n, struct stat *st)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a2:	00 
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	89 04 24             	mov    %eax,(%esp)
 1a9:	e8 07 01 00 00       	call   2b5 <open>
 1ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b5:	79 07                	jns    1be <stat+0x29>
    return -1;
 1b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1bc:	eb 23                	jmp    1e1 <stat+0x4c>
  r = fstat(fd, st);
 1be:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	89 04 24             	mov    %eax,(%esp)
 1cb:	e8 fd 00 00 00       	call   2cd <fstat>
 1d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d6:	89 04 24             	mov    %eax,(%esp)
 1d9:	e8 bf 00 00 00       	call   29d <close>
  return r;
 1de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e1:	c9                   	leave  
 1e2:	c3                   	ret    

000001e3 <atoi>:

int
atoi(const char *s)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f0:	eb 25                	jmp    217 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f5:	89 d0                	mov    %edx,%eax
 1f7:	c1 e0 02             	shl    $0x2,%eax
 1fa:	01 d0                	add    %edx,%eax
 1fc:	01 c0                	add    %eax,%eax
 1fe:	89 c1                	mov    %eax,%ecx
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	8d 50 01             	lea    0x1(%eax),%edx
 206:	89 55 08             	mov    %edx,0x8(%ebp)
 209:	0f b6 00             	movzbl (%eax),%eax
 20c:	0f be c0             	movsbl %al,%eax
 20f:	01 c8                	add    %ecx,%eax
 211:	83 e8 30             	sub    $0x30,%eax
 214:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	0f b6 00             	movzbl (%eax),%eax
 21d:	3c 2f                	cmp    $0x2f,%al
 21f:	7e 0a                	jle    22b <atoi+0x48>
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	0f b6 00             	movzbl (%eax),%eax
 227:	3c 39                	cmp    $0x39,%al
 229:	7e c7                	jle    1f2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 22b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22e:	c9                   	leave  
 22f:	c3                   	ret    

00000230 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 23c:	8b 45 0c             	mov    0xc(%ebp),%eax
 23f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 242:	eb 17                	jmp    25b <memmove+0x2b>
    *dst++ = *src++;
 244:	8b 45 fc             	mov    -0x4(%ebp),%eax
 247:	8d 50 01             	lea    0x1(%eax),%edx
 24a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 24d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 250:	8d 4a 01             	lea    0x1(%edx),%ecx
 253:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 256:	0f b6 12             	movzbl (%edx),%edx
 259:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25b:	8b 45 10             	mov    0x10(%ebp),%eax
 25e:	8d 50 ff             	lea    -0x1(%eax),%edx
 261:	89 55 10             	mov    %edx,0x10(%ebp)
 264:	85 c0                	test   %eax,%eax
 266:	7f dc                	jg     244 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 268:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26b:	c9                   	leave  
 26c:	c3                   	ret    

0000026d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26d:	b8 01 00 00 00       	mov    $0x1,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <exit>:
SYSCALL(exit)
 275:	b8 02 00 00 00       	mov    $0x2,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <wait>:
SYSCALL(wait)
 27d:	b8 03 00 00 00       	mov    $0x3,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <pipe>:
SYSCALL(pipe)
 285:	b8 04 00 00 00       	mov    $0x4,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <read>:
SYSCALL(read)
 28d:	b8 05 00 00 00       	mov    $0x5,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <write>:
SYSCALL(write)
 295:	b8 10 00 00 00       	mov    $0x10,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <close>:
SYSCALL(close)
 29d:	b8 15 00 00 00       	mov    $0x15,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <kill>:
SYSCALL(kill)
 2a5:	b8 06 00 00 00       	mov    $0x6,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <exec>:
SYSCALL(exec)
 2ad:	b8 07 00 00 00       	mov    $0x7,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <open>:
SYSCALL(open)
 2b5:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <mknod>:
SYSCALL(mknod)
 2bd:	b8 11 00 00 00       	mov    $0x11,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <unlink>:
SYSCALL(unlink)
 2c5:	b8 12 00 00 00       	mov    $0x12,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <fstat>:
SYSCALL(fstat)
 2cd:	b8 08 00 00 00       	mov    $0x8,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <link>:
SYSCALL(link)
 2d5:	b8 13 00 00 00       	mov    $0x13,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <mkdir>:
SYSCALL(mkdir)
 2dd:	b8 14 00 00 00       	mov    $0x14,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <chdir>:
SYSCALL(chdir)
 2e5:	b8 09 00 00 00       	mov    $0x9,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <dup>:
SYSCALL(dup)
 2ed:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <getpid>:
SYSCALL(getpid)
 2f5:	b8 0b 00 00 00       	mov    $0xb,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <sbrk>:
SYSCALL(sbrk)
 2fd:	b8 0c 00 00 00       	mov    $0xc,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <sleep>:
SYSCALL(sleep)
 305:	b8 0d 00 00 00       	mov    $0xd,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <uptime>:
SYSCALL(uptime)
 30d:	b8 0e 00 00 00       	mov    $0xe,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <my_syscall>:
SYSCALL(my_syscall)
 315:	b8 16 00 00 00       	mov    $0x16,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <getppid>:
SYSCALL(getppid)
 31d:	b8 17 00 00 00       	mov    $0x17,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <yield>:
SYSCALL(yield)
 325:	b8 18 00 00 00       	mov    $0x18,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <getlev>:
SYSCALL(getlev)
 32d:	b8 19 00 00 00       	mov    $0x19,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <set_cpu_share>:
SYSCALL(set_cpu_share)
 335:	b8 1a 00 00 00       	mov    $0x1a,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <thread_create>:
SYSCALL(thread_create)
 33d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <thread_exit>:
SYSCALL(thread_exit)
 345:	b8 1c 00 00 00       	mov    $0x1c,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <thread_join>:
SYSCALL(thread_join)
 34d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <gettid>:
SYSCALL(gettid)
 355:	b8 1e 00 00 00       	mov    $0x1e,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
 360:	83 ec 18             	sub    $0x18,%esp
 363:	8b 45 0c             	mov    0xc(%ebp),%eax
 366:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 369:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 370:	00 
 371:	8d 45 f4             	lea    -0xc(%ebp),%eax
 374:	89 44 24 04          	mov    %eax,0x4(%esp)
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	89 04 24             	mov    %eax,(%esp)
 37e:	e8 12 ff ff ff       	call   295 <write>
}
 383:	c9                   	leave  
 384:	c3                   	ret    

00000385 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 385:	55                   	push   %ebp
 386:	89 e5                	mov    %esp,%ebp
 388:	56                   	push   %esi
 389:	53                   	push   %ebx
 38a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 394:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 398:	74 17                	je     3b1 <printint+0x2c>
 39a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 39e:	79 11                	jns    3b1 <printint+0x2c>
    neg = 1;
 3a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3aa:	f7 d8                	neg    %eax
 3ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3af:	eb 06                	jmp    3b7 <printint+0x32>
  } else {
    x = xx;
 3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c1:	8d 41 01             	lea    0x1(%ecx),%eax
 3c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cd:	ba 00 00 00 00       	mov    $0x0,%edx
 3d2:	f7 f3                	div    %ebx
 3d4:	89 d0                	mov    %edx,%eax
 3d6:	0f b6 80 54 0a 00 00 	movzbl 0xa54(%eax),%eax
 3dd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e1:	8b 75 10             	mov    0x10(%ebp),%esi
 3e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e7:	ba 00 00 00 00       	mov    $0x0,%edx
 3ec:	f7 f6                	div    %esi
 3ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f5:	75 c7                	jne    3be <printint+0x39>
  if(neg)
 3f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3fb:	74 10                	je     40d <printint+0x88>
    buf[i++] = '-';
 3fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 400:	8d 50 01             	lea    0x1(%eax),%edx
 403:	89 55 f4             	mov    %edx,-0xc(%ebp)
 406:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 40b:	eb 1f                	jmp    42c <printint+0xa7>
 40d:	eb 1d                	jmp    42c <printint+0xa7>
    putc(fd, buf[i]);
 40f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 412:	8b 45 f4             	mov    -0xc(%ebp),%eax
 415:	01 d0                	add    %edx,%eax
 417:	0f b6 00             	movzbl (%eax),%eax
 41a:	0f be c0             	movsbl %al,%eax
 41d:	89 44 24 04          	mov    %eax,0x4(%esp)
 421:	8b 45 08             	mov    0x8(%ebp),%eax
 424:	89 04 24             	mov    %eax,(%esp)
 427:	e8 31 ff ff ff       	call   35d <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 42c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 434:	79 d9                	jns    40f <printint+0x8a>
    putc(fd, buf[i]);
}
 436:	83 c4 30             	add    $0x30,%esp
 439:	5b                   	pop    %ebx
 43a:	5e                   	pop    %esi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    

0000043d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43d:	55                   	push   %ebp
 43e:	89 e5                	mov    %esp,%ebp
 440:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 443:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 44a:	8d 45 0c             	lea    0xc(%ebp),%eax
 44d:	83 c0 04             	add    $0x4,%eax
 450:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 453:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 45a:	e9 7c 01 00 00       	jmp    5db <printf+0x19e>
    c = fmt[i] & 0xff;
 45f:	8b 55 0c             	mov    0xc(%ebp),%edx
 462:	8b 45 f0             	mov    -0x10(%ebp),%eax
 465:	01 d0                	add    %edx,%eax
 467:	0f b6 00             	movzbl (%eax),%eax
 46a:	0f be c0             	movsbl %al,%eax
 46d:	25 ff 00 00 00       	and    $0xff,%eax
 472:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 475:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 479:	75 2c                	jne    4a7 <printf+0x6a>
      if(c == '%'){
 47b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47f:	75 0c                	jne    48d <printf+0x50>
        state = '%';
 481:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 488:	e9 4a 01 00 00       	jmp    5d7 <printf+0x19a>
      } else {
        putc(fd, c);
 48d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 490:	0f be c0             	movsbl %al,%eax
 493:	89 44 24 04          	mov    %eax,0x4(%esp)
 497:	8b 45 08             	mov    0x8(%ebp),%eax
 49a:	89 04 24             	mov    %eax,(%esp)
 49d:	e8 bb fe ff ff       	call   35d <putc>
 4a2:	e9 30 01 00 00       	jmp    5d7 <printf+0x19a>
      }
    } else if(state == '%'){
 4a7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ab:	0f 85 26 01 00 00    	jne    5d7 <printf+0x19a>
      if(c == 'd'){
 4b1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b5:	75 2d                	jne    4e4 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ba:	8b 00                	mov    (%eax),%eax
 4bc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4c3:	00 
 4c4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4cb:	00 
 4cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d0:	8b 45 08             	mov    0x8(%ebp),%eax
 4d3:	89 04 24             	mov    %eax,(%esp)
 4d6:	e8 aa fe ff ff       	call   385 <printint>
        ap++;
 4db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4df:	e9 ec 00 00 00       	jmp    5d0 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 4e4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e8:	74 06                	je     4f0 <printf+0xb3>
 4ea:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ee:	75 2d                	jne    51d <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f3:	8b 00                	mov    (%eax),%eax
 4f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4fc:	00 
 4fd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 504:	00 
 505:	89 44 24 04          	mov    %eax,0x4(%esp)
 509:	8b 45 08             	mov    0x8(%ebp),%eax
 50c:	89 04 24             	mov    %eax,(%esp)
 50f:	e8 71 fe ff ff       	call   385 <printint>
        ap++;
 514:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 518:	e9 b3 00 00 00       	jmp    5d0 <printf+0x193>
      } else if(c == 's'){
 51d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 521:	75 45                	jne    568 <printf+0x12b>
        s = (char*)*ap;
 523:	8b 45 e8             	mov    -0x18(%ebp),%eax
 526:	8b 00                	mov    (%eax),%eax
 528:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 52b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 533:	75 09                	jne    53e <printf+0x101>
          s = "(null)";
 535:	c7 45 f4 09 08 00 00 	movl   $0x809,-0xc(%ebp)
        while(*s != 0){
 53c:	eb 1e                	jmp    55c <printf+0x11f>
 53e:	eb 1c                	jmp    55c <printf+0x11f>
          putc(fd, *s);
 540:	8b 45 f4             	mov    -0xc(%ebp),%eax
 543:	0f b6 00             	movzbl (%eax),%eax
 546:	0f be c0             	movsbl %al,%eax
 549:	89 44 24 04          	mov    %eax,0x4(%esp)
 54d:	8b 45 08             	mov    0x8(%ebp),%eax
 550:	89 04 24             	mov    %eax,(%esp)
 553:	e8 05 fe ff ff       	call   35d <putc>
          s++;
 558:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 55c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55f:	0f b6 00             	movzbl (%eax),%eax
 562:	84 c0                	test   %al,%al
 564:	75 da                	jne    540 <printf+0x103>
 566:	eb 68                	jmp    5d0 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 568:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 56c:	75 1d                	jne    58b <printf+0x14e>
        putc(fd, *ap);
 56e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 571:	8b 00                	mov    (%eax),%eax
 573:	0f be c0             	movsbl %al,%eax
 576:	89 44 24 04          	mov    %eax,0x4(%esp)
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	89 04 24             	mov    %eax,(%esp)
 580:	e8 d8 fd ff ff       	call   35d <putc>
        ap++;
 585:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 589:	eb 45                	jmp    5d0 <printf+0x193>
      } else if(c == '%'){
 58b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58f:	75 17                	jne    5a8 <printf+0x16b>
        putc(fd, c);
 591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 594:	0f be c0             	movsbl %al,%eax
 597:	89 44 24 04          	mov    %eax,0x4(%esp)
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
 59e:	89 04 24             	mov    %eax,(%esp)
 5a1:	e8 b7 fd ff ff       	call   35d <putc>
 5a6:	eb 28                	jmp    5d0 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5af:	00 
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
 5b3:	89 04 24             	mov    %eax,(%esp)
 5b6:	e8 a2 fd ff ff       	call   35d <putc>
        putc(fd, c);
 5bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	89 04 24             	mov    %eax,(%esp)
 5cb:	e8 8d fd ff ff       	call   35d <putc>
      }
      state = 0;
 5d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5db:	8b 55 0c             	mov    0xc(%ebp),%edx
 5de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e1:	01 d0                	add    %edx,%eax
 5e3:	0f b6 00             	movzbl (%eax),%eax
 5e6:	84 c0                	test   %al,%al
 5e8:	0f 85 71 fe ff ff    	jne    45f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5ee:	c9                   	leave  
 5ef:	c3                   	ret    

000005f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
 5f9:	83 e8 08             	sub    $0x8,%eax
 5fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ff:	a1 70 0a 00 00       	mov    0xa70,%eax
 604:	89 45 fc             	mov    %eax,-0x4(%ebp)
 607:	eb 24                	jmp    62d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 609:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60c:	8b 00                	mov    (%eax),%eax
 60e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 611:	77 12                	ja     625 <free+0x35>
 613:	8b 45 f8             	mov    -0x8(%ebp),%eax
 616:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 619:	77 24                	ja     63f <free+0x4f>
 61b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61e:	8b 00                	mov    (%eax),%eax
 620:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 623:	77 1a                	ja     63f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 625:	8b 45 fc             	mov    -0x4(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 630:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 633:	76 d4                	jbe    609 <free+0x19>
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63d:	76 ca                	jbe    609 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 63f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 642:	8b 40 04             	mov    0x4(%eax),%eax
 645:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64f:	01 c2                	add    %eax,%edx
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	39 c2                	cmp    %eax,%edx
 658:	75 24                	jne    67e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	8b 50 04             	mov    0x4(%eax),%edx
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	8b 00                	mov    (%eax),%eax
 665:	8b 40 04             	mov    0x4(%eax),%eax
 668:	01 c2                	add    %eax,%edx
 66a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	8b 10                	mov    (%eax),%edx
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	89 10                	mov    %edx,(%eax)
 67c:	eb 0a                	jmp    688 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 10                	mov    (%eax),%edx
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 40 04             	mov    0x4(%eax),%eax
 68e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	01 d0                	add    %edx,%eax
 69a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69d:	75 20                	jne    6bf <free+0xcf>
    p->s.size += bp->s.size;
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 50 04             	mov    0x4(%eax),%edx
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	8b 40 04             	mov    0x4(%eax),%eax
 6ab:	01 c2                	add    %eax,%edx
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	8b 10                	mov    (%eax),%edx
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	89 10                	mov    %edx,(%eax)
 6bd:	eb 08                	jmp    6c7 <free+0xd7>
  } else
    p->s.ptr = bp;
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c5:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	a3 70 0a 00 00       	mov    %eax,0xa70
}
 6cf:	c9                   	leave  
 6d0:	c3                   	ret    

000006d1 <morecore>:

static Header*
morecore(uint nu)
{
 6d1:	55                   	push   %ebp
 6d2:	89 e5                	mov    %esp,%ebp
 6d4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6de:	77 07                	ja     6e7 <morecore+0x16>
    nu = 4096;
 6e0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ea:	c1 e0 03             	shl    $0x3,%eax
 6ed:	89 04 24             	mov    %eax,(%esp)
 6f0:	e8 08 fc ff ff       	call   2fd <sbrk>
 6f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6fc:	75 07                	jne    705 <morecore+0x34>
    return 0;
 6fe:	b8 00 00 00 00       	mov    $0x0,%eax
 703:	eb 22                	jmp    727 <morecore+0x56>
  hp = (Header*)p;
 705:	8b 45 f4             	mov    -0xc(%ebp),%eax
 708:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 70b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70e:	8b 55 08             	mov    0x8(%ebp),%edx
 711:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 714:	8b 45 f0             	mov    -0x10(%ebp),%eax
 717:	83 c0 08             	add    $0x8,%eax
 71a:	89 04 24             	mov    %eax,(%esp)
 71d:	e8 ce fe ff ff       	call   5f0 <free>
  return freep;
 722:	a1 70 0a 00 00       	mov    0xa70,%eax
}
 727:	c9                   	leave  
 728:	c3                   	ret    

00000729 <malloc>:

void*
malloc(uint nbytes)
{
 729:	55                   	push   %ebp
 72a:	89 e5                	mov    %esp,%ebp
 72c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72f:	8b 45 08             	mov    0x8(%ebp),%eax
 732:	83 c0 07             	add    $0x7,%eax
 735:	c1 e8 03             	shr    $0x3,%eax
 738:	83 c0 01             	add    $0x1,%eax
 73b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 73e:	a1 70 0a 00 00       	mov    0xa70,%eax
 743:	89 45 f0             	mov    %eax,-0x10(%ebp)
 746:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74a:	75 23                	jne    76f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 74c:	c7 45 f0 68 0a 00 00 	movl   $0xa68,-0x10(%ebp)
 753:	8b 45 f0             	mov    -0x10(%ebp),%eax
 756:	a3 70 0a 00 00       	mov    %eax,0xa70
 75b:	a1 70 0a 00 00       	mov    0xa70,%eax
 760:	a3 68 0a 00 00       	mov    %eax,0xa68
    base.s.size = 0;
 765:	c7 05 6c 0a 00 00 00 	movl   $0x0,0xa6c
 76c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 772:	8b 00                	mov    (%eax),%eax
 774:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	8b 40 04             	mov    0x4(%eax),%eax
 77d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 780:	72 4d                	jb     7cf <malloc+0xa6>
      if(p->s.size == nunits)
 782:	8b 45 f4             	mov    -0xc(%ebp),%eax
 785:	8b 40 04             	mov    0x4(%eax),%eax
 788:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78b:	75 0c                	jne    799 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	8b 10                	mov    (%eax),%edx
 792:	8b 45 f0             	mov    -0x10(%ebp),%eax
 795:	89 10                	mov    %edx,(%eax)
 797:	eb 26                	jmp    7bf <malloc+0x96>
      else {
        p->s.size -= nunits;
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a2:	89 c2                	mov    %eax,%edx
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	8b 40 04             	mov    0x4(%eax),%eax
 7b0:	c1 e0 03             	shl    $0x3,%eax
 7b3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7bc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c2:	a3 70 0a 00 00       	mov    %eax,0xa70
      return (void*)(p + 1);
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	83 c0 08             	add    $0x8,%eax
 7cd:	eb 38                	jmp    807 <malloc+0xde>
    }
    if(p == freep)
 7cf:	a1 70 0a 00 00       	mov    0xa70,%eax
 7d4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d7:	75 1b                	jne    7f4 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7dc:	89 04 24             	mov    %eax,(%esp)
 7df:	e8 ed fe ff ff       	call   6d1 <morecore>
 7e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7eb:	75 07                	jne    7f4 <malloc+0xcb>
        return 0;
 7ed:	b8 00 00 00 00       	mov    $0x0,%eax
 7f2:	eb 13                	jmp    807 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	8b 00                	mov    (%eax),%eax
 7ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 802:	e9 70 ff ff ff       	jmp    777 <malloc+0x4e>
}
 807:	c9                   	leave  
 808:	c3                   	ret    

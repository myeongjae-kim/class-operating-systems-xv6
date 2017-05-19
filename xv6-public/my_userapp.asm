
_my_userapp:     file format elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
    char *buf = "Hello xv6!";
   9:	c7 44 24 1c 3e 08 00 	movl   $0x83e,0x1c(%esp)
  10:	00 
    int ret_val;
    ret_val = my_syscall(buf);
  11:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  15:	89 04 24             	mov    %eax,(%esp)
  18:	e8 2d 03 00 00       	call   34a <my_syscall>
  1d:	89 44 24 18          	mov    %eax,0x18(%esp)
    printf(1, "Return value : 0x%x\n", ret_val);
  21:	8b 44 24 18          	mov    0x18(%esp),%eax
  25:	89 44 24 08          	mov    %eax,0x8(%esp)
  29:	c7 44 24 04 49 08 00 	movl   $0x849,0x4(%esp)
  30:	00 
  31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  38:	e8 35 04 00 00       	call   472 <printf>
    exit();
  3d:	e8 68 02 00 00       	call   2aa <exit>

00000042 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  42:	55                   	push   %ebp
  43:	89 e5                	mov    %esp,%ebp
  45:	57                   	push   %edi
  46:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  4a:	8b 55 10             	mov    0x10(%ebp),%edx
  4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  50:	89 cb                	mov    %ecx,%ebx
  52:	89 df                	mov    %ebx,%edi
  54:	89 d1                	mov    %edx,%ecx
  56:	fc                   	cld    
  57:	f3 aa                	rep stos %al,%es:(%edi)
  59:	89 ca                	mov    %ecx,%edx
  5b:	89 fb                	mov    %edi,%ebx
  5d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  60:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  63:	5b                   	pop    %ebx
  64:	5f                   	pop    %edi
  65:	5d                   	pop    %ebp
  66:	c3                   	ret    

00000067 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  6d:	8b 45 08             	mov    0x8(%ebp),%eax
  70:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  73:	90                   	nop
  74:	8b 45 08             	mov    0x8(%ebp),%eax
  77:	8d 50 01             	lea    0x1(%eax),%edx
  7a:	89 55 08             	mov    %edx,0x8(%ebp)
  7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  80:	8d 4a 01             	lea    0x1(%edx),%ecx
  83:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  86:	0f b6 12             	movzbl (%edx),%edx
  89:	88 10                	mov    %dl,(%eax)
  8b:	0f b6 00             	movzbl (%eax),%eax
  8e:	84 c0                	test   %al,%al
  90:	75 e2                	jne    74 <strcpy+0xd>
    ;
  return os;
  92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  95:	c9                   	leave  
  96:	c3                   	ret    

00000097 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  97:	55                   	push   %ebp
  98:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  9a:	eb 08                	jmp    a4 <strcmp+0xd>
    p++, q++;
  9c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	84 c0                	test   %al,%al
  ac:	74 10                	je     be <strcmp+0x27>
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	0f b6 10             	movzbl (%eax),%edx
  b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  b7:	0f b6 00             	movzbl (%eax),%eax
  ba:	38 c2                	cmp    %al,%dl
  bc:	74 de                	je     9c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  be:	8b 45 08             	mov    0x8(%ebp),%eax
  c1:	0f b6 00             	movzbl (%eax),%eax
  c4:	0f b6 d0             	movzbl %al,%edx
  c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ca:	0f b6 00             	movzbl (%eax),%eax
  cd:	0f b6 c0             	movzbl %al,%eax
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
}
  d4:	5d                   	pop    %ebp
  d5:	c3                   	ret    

000000d6 <strlen>:

uint
strlen(char *s)
{
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  d9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e3:	eb 04                	jmp    e9 <strlen+0x13>
  e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	01 d0                	add    %edx,%eax
  f1:	0f b6 00             	movzbl (%eax),%eax
  f4:	84 c0                	test   %al,%al
  f6:	75 ed                	jne    e5 <strlen+0xf>
    ;
  return n;
  f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <memset>:

void*
memset(void *dst, int c, uint n)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 103:	8b 45 10             	mov    0x10(%ebp),%eax
 106:	89 44 24 08          	mov    %eax,0x8(%esp)
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 44 24 04          	mov    %eax,0x4(%esp)
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	89 04 24             	mov    %eax,(%esp)
 117:	e8 26 ff ff ff       	call   42 <stosb>
  return dst;
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <strchr>:

char*
strchr(const char *s, char c)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	83 ec 04             	sub    $0x4,%esp
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 12d:	eb 14                	jmp    143 <strchr+0x22>
    if(*s == c)
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	3a 45 fc             	cmp    -0x4(%ebp),%al
 138:	75 05                	jne    13f <strchr+0x1e>
      return (char*)s;
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	eb 13                	jmp    152 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 13f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	0f b6 00             	movzbl (%eax),%eax
 149:	84 c0                	test   %al,%al
 14b:	75 e2                	jne    12f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 14d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <gets>:

char*
gets(char *buf, int max)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 161:	eb 4c                	jmp    1af <gets+0x5b>
    cc = read(0, &c, 1);
 163:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 16a:	00 
 16b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 16e:	89 44 24 04          	mov    %eax,0x4(%esp)
 172:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 179:	e8 44 01 00 00       	call   2c2 <read>
 17e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 181:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 185:	7f 02                	jg     189 <gets+0x35>
      break;
 187:	eb 31                	jmp    1ba <gets+0x66>
    buf[i++] = c;
 189:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18c:	8d 50 01             	lea    0x1(%eax),%edx
 18f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 192:	89 c2                	mov    %eax,%edx
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	01 c2                	add    %eax,%edx
 199:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 19f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a3:	3c 0a                	cmp    $0xa,%al
 1a5:	74 13                	je     1ba <gets+0x66>
 1a7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ab:	3c 0d                	cmp    $0xd,%al
 1ad:	74 0b                	je     1ba <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b2:	83 c0 01             	add    $0x1,%eax
 1b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1b8:	7c a9                	jl     163 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
 1c0:	01 d0                	add    %edx,%eax
 1c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c8:	c9                   	leave  
 1c9:	c3                   	ret    

000001ca <stat>:

int
stat(char *n, struct stat *st)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1d7:	00 
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	89 04 24             	mov    %eax,(%esp)
 1de:	e8 07 01 00 00       	call   2ea <open>
 1e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ea:	79 07                	jns    1f3 <stat+0x29>
    return -1;
 1ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1f1:	eb 23                	jmp    216 <stat+0x4c>
  r = fstat(fd, st);
 1f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fd:	89 04 24             	mov    %eax,(%esp)
 200:	e8 fd 00 00 00       	call   302 <fstat>
 205:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 208:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20b:	89 04 24             	mov    %eax,(%esp)
 20e:	e8 bf 00 00 00       	call   2d2 <close>
  return r;
 213:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <atoi>:

int
atoi(const char *s)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 21e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 225:	eb 25                	jmp    24c <atoi+0x34>
    n = n*10 + *s++ - '0';
 227:	8b 55 fc             	mov    -0x4(%ebp),%edx
 22a:	89 d0                	mov    %edx,%eax
 22c:	c1 e0 02             	shl    $0x2,%eax
 22f:	01 d0                	add    %edx,%eax
 231:	01 c0                	add    %eax,%eax
 233:	89 c1                	mov    %eax,%ecx
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 08             	mov    %edx,0x8(%ebp)
 23e:	0f b6 00             	movzbl (%eax),%eax
 241:	0f be c0             	movsbl %al,%eax
 244:	01 c8                	add    %ecx,%eax
 246:	83 e8 30             	sub    $0x30,%eax
 249:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	0f b6 00             	movzbl (%eax),%eax
 252:	3c 2f                	cmp    $0x2f,%al
 254:	7e 0a                	jle    260 <atoi+0x48>
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	3c 39                	cmp    $0x39,%al
 25e:	7e c7                	jle    227 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 271:	8b 45 0c             	mov    0xc(%ebp),%eax
 274:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 277:	eb 17                	jmp    290 <memmove+0x2b>
    *dst++ = *src++;
 279:	8b 45 fc             	mov    -0x4(%ebp),%eax
 27c:	8d 50 01             	lea    0x1(%eax),%edx
 27f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 282:	8b 55 f8             	mov    -0x8(%ebp),%edx
 285:	8d 4a 01             	lea    0x1(%edx),%ecx
 288:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 28b:	0f b6 12             	movzbl (%edx),%edx
 28e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 290:	8b 45 10             	mov    0x10(%ebp),%eax
 293:	8d 50 ff             	lea    -0x1(%eax),%edx
 296:	89 55 10             	mov    %edx,0x10(%ebp)
 299:	85 c0                	test   %eax,%eax
 29b:	7f dc                	jg     279 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a2:	b8 01 00 00 00       	mov    $0x1,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <exit>:
SYSCALL(exit)
 2aa:	b8 02 00 00 00       	mov    $0x2,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <wait>:
SYSCALL(wait)
 2b2:	b8 03 00 00 00       	mov    $0x3,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <pipe>:
SYSCALL(pipe)
 2ba:	b8 04 00 00 00       	mov    $0x4,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <read>:
SYSCALL(read)
 2c2:	b8 05 00 00 00       	mov    $0x5,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <write>:
SYSCALL(write)
 2ca:	b8 10 00 00 00       	mov    $0x10,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <close>:
SYSCALL(close)
 2d2:	b8 15 00 00 00       	mov    $0x15,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <kill>:
SYSCALL(kill)
 2da:	b8 06 00 00 00       	mov    $0x6,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <exec>:
SYSCALL(exec)
 2e2:	b8 07 00 00 00       	mov    $0x7,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <open>:
SYSCALL(open)
 2ea:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <mknod>:
SYSCALL(mknod)
 2f2:	b8 11 00 00 00       	mov    $0x11,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <unlink>:
SYSCALL(unlink)
 2fa:	b8 12 00 00 00       	mov    $0x12,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <fstat>:
SYSCALL(fstat)
 302:	b8 08 00 00 00       	mov    $0x8,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <link>:
SYSCALL(link)
 30a:	b8 13 00 00 00       	mov    $0x13,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <mkdir>:
SYSCALL(mkdir)
 312:	b8 14 00 00 00       	mov    $0x14,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <chdir>:
SYSCALL(chdir)
 31a:	b8 09 00 00 00       	mov    $0x9,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <dup>:
SYSCALL(dup)
 322:	b8 0a 00 00 00       	mov    $0xa,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <getpid>:
SYSCALL(getpid)
 32a:	b8 0b 00 00 00       	mov    $0xb,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <sbrk>:
SYSCALL(sbrk)
 332:	b8 0c 00 00 00       	mov    $0xc,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sleep>:
SYSCALL(sleep)
 33a:	b8 0d 00 00 00       	mov    $0xd,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <uptime>:
SYSCALL(uptime)
 342:	b8 0e 00 00 00       	mov    $0xe,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <my_syscall>:
SYSCALL(my_syscall)
 34a:	b8 16 00 00 00       	mov    $0x16,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <getppid>:
SYSCALL(getppid)
 352:	b8 17 00 00 00       	mov    $0x17,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <yield>:
SYSCALL(yield)
 35a:	b8 18 00 00 00       	mov    $0x18,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <getlev>:
SYSCALL(getlev)
 362:	b8 19 00 00 00       	mov    $0x19,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <set_cpu_share>:
SYSCALL(set_cpu_share)
 36a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <thread_create>:
SYSCALL(thread_create)
 372:	b8 1b 00 00 00       	mov    $0x1b,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <thread_exit>:
SYSCALL(thread_exit)
 37a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <thread_join>:
SYSCALL(thread_join)
 382:	b8 1d 00 00 00       	mov    $0x1d,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <gettid>:
SYSCALL(gettid)
 38a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp
 395:	83 ec 18             	sub    $0x18,%esp
 398:	8b 45 0c             	mov    0xc(%ebp),%eax
 39b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 39e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3a5:	00 
 3a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
 3b0:	89 04 24             	mov    %eax,(%esp)
 3b3:	e8 12 ff ff ff       	call   2ca <write>
}
 3b8:	c9                   	leave  
 3b9:	c3                   	ret    

000003ba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ba:	55                   	push   %ebp
 3bb:	89 e5                	mov    %esp,%ebp
 3bd:	56                   	push   %esi
 3be:	53                   	push   %ebx
 3bf:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3cd:	74 17                	je     3e6 <printint+0x2c>
 3cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d3:	79 11                	jns    3e6 <printint+0x2c>
    neg = 1;
 3d5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3df:	f7 d8                	neg    %eax
 3e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e4:	eb 06                	jmp    3ec <printint+0x32>
  } else {
    x = xx;
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3f6:	8d 41 01             	lea    0x1(%ecx),%eax
 3f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 402:	ba 00 00 00 00       	mov    $0x0,%edx
 407:	f7 f3                	div    %ebx
 409:	89 d0                	mov    %edx,%eax
 40b:	0f b6 80 ac 0a 00 00 	movzbl 0xaac(%eax),%eax
 412:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 416:	8b 75 10             	mov    0x10(%ebp),%esi
 419:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41c:	ba 00 00 00 00       	mov    $0x0,%edx
 421:	f7 f6                	div    %esi
 423:	89 45 ec             	mov    %eax,-0x14(%ebp)
 426:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42a:	75 c7                	jne    3f3 <printint+0x39>
  if(neg)
 42c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 430:	74 10                	je     442 <printint+0x88>
    buf[i++] = '-';
 432:	8b 45 f4             	mov    -0xc(%ebp),%eax
 435:	8d 50 01             	lea    0x1(%eax),%edx
 438:	89 55 f4             	mov    %edx,-0xc(%ebp)
 43b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 440:	eb 1f                	jmp    461 <printint+0xa7>
 442:	eb 1d                	jmp    461 <printint+0xa7>
    putc(fd, buf[i]);
 444:	8d 55 dc             	lea    -0x24(%ebp),%edx
 447:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44a:	01 d0                	add    %edx,%eax
 44c:	0f b6 00             	movzbl (%eax),%eax
 44f:	0f be c0             	movsbl %al,%eax
 452:	89 44 24 04          	mov    %eax,0x4(%esp)
 456:	8b 45 08             	mov    0x8(%ebp),%eax
 459:	89 04 24             	mov    %eax,(%esp)
 45c:	e8 31 ff ff ff       	call   392 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 461:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 465:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 469:	79 d9                	jns    444 <printint+0x8a>
    putc(fd, buf[i]);
}
 46b:	83 c4 30             	add    $0x30,%esp
 46e:	5b                   	pop    %ebx
 46f:	5e                   	pop    %esi
 470:	5d                   	pop    %ebp
 471:	c3                   	ret    

00000472 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 472:	55                   	push   %ebp
 473:	89 e5                	mov    %esp,%ebp
 475:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 478:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 47f:	8d 45 0c             	lea    0xc(%ebp),%eax
 482:	83 c0 04             	add    $0x4,%eax
 485:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 488:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 48f:	e9 7c 01 00 00       	jmp    610 <printf+0x19e>
    c = fmt[i] & 0xff;
 494:	8b 55 0c             	mov    0xc(%ebp),%edx
 497:	8b 45 f0             	mov    -0x10(%ebp),%eax
 49a:	01 d0                	add    %edx,%eax
 49c:	0f b6 00             	movzbl (%eax),%eax
 49f:	0f be c0             	movsbl %al,%eax
 4a2:	25 ff 00 00 00       	and    $0xff,%eax
 4a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ae:	75 2c                	jne    4dc <printf+0x6a>
      if(c == '%'){
 4b0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b4:	75 0c                	jne    4c2 <printf+0x50>
        state = '%';
 4b6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4bd:	e9 4a 01 00 00       	jmp    60c <printf+0x19a>
      } else {
        putc(fd, c);
 4c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c5:	0f be c0             	movsbl %al,%eax
 4c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cc:	8b 45 08             	mov    0x8(%ebp),%eax
 4cf:	89 04 24             	mov    %eax,(%esp)
 4d2:	e8 bb fe ff ff       	call   392 <putc>
 4d7:	e9 30 01 00 00       	jmp    60c <printf+0x19a>
      }
    } else if(state == '%'){
 4dc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e0:	0f 85 26 01 00 00    	jne    60c <printf+0x19a>
      if(c == 'd'){
 4e6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ea:	75 2d                	jne    519 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ef:	8b 00                	mov    (%eax),%eax
 4f1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f8:	00 
 4f9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 500:	00 
 501:	89 44 24 04          	mov    %eax,0x4(%esp)
 505:	8b 45 08             	mov    0x8(%ebp),%eax
 508:	89 04 24             	mov    %eax,(%esp)
 50b:	e8 aa fe ff ff       	call   3ba <printint>
        ap++;
 510:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 514:	e9 ec 00 00 00       	jmp    605 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 519:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51d:	74 06                	je     525 <printf+0xb3>
 51f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 523:	75 2d                	jne    552 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 525:	8b 45 e8             	mov    -0x18(%ebp),%eax
 528:	8b 00                	mov    (%eax),%eax
 52a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 531:	00 
 532:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 539:	00 
 53a:	89 44 24 04          	mov    %eax,0x4(%esp)
 53e:	8b 45 08             	mov    0x8(%ebp),%eax
 541:	89 04 24             	mov    %eax,(%esp)
 544:	e8 71 fe ff ff       	call   3ba <printint>
        ap++;
 549:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54d:	e9 b3 00 00 00       	jmp    605 <printf+0x193>
      } else if(c == 's'){
 552:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 556:	75 45                	jne    59d <printf+0x12b>
        s = (char*)*ap;
 558:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55b:	8b 00                	mov    (%eax),%eax
 55d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 564:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 568:	75 09                	jne    573 <printf+0x101>
          s = "(null)";
 56a:	c7 45 f4 5e 08 00 00 	movl   $0x85e,-0xc(%ebp)
        while(*s != 0){
 571:	eb 1e                	jmp    591 <printf+0x11f>
 573:	eb 1c                	jmp    591 <printf+0x11f>
          putc(fd, *s);
 575:	8b 45 f4             	mov    -0xc(%ebp),%eax
 578:	0f b6 00             	movzbl (%eax),%eax
 57b:	0f be c0             	movsbl %al,%eax
 57e:	89 44 24 04          	mov    %eax,0x4(%esp)
 582:	8b 45 08             	mov    0x8(%ebp),%eax
 585:	89 04 24             	mov    %eax,(%esp)
 588:	e8 05 fe ff ff       	call   392 <putc>
          s++;
 58d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 591:	8b 45 f4             	mov    -0xc(%ebp),%eax
 594:	0f b6 00             	movzbl (%eax),%eax
 597:	84 c0                	test   %al,%al
 599:	75 da                	jne    575 <printf+0x103>
 59b:	eb 68                	jmp    605 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a1:	75 1d                	jne    5c0 <printf+0x14e>
        putc(fd, *ap);
 5a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a6:	8b 00                	mov    (%eax),%eax
 5a8:	0f be c0             	movsbl %al,%eax
 5ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 5af:	8b 45 08             	mov    0x8(%ebp),%eax
 5b2:	89 04 24             	mov    %eax,(%esp)
 5b5:	e8 d8 fd ff ff       	call   392 <putc>
        ap++;
 5ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5be:	eb 45                	jmp    605 <printf+0x193>
      } else if(c == '%'){
 5c0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c4:	75 17                	jne    5dd <printf+0x16b>
        putc(fd, c);
 5c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c9:	0f be c0             	movsbl %al,%eax
 5cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	89 04 24             	mov    %eax,(%esp)
 5d6:	e8 b7 fd ff ff       	call   392 <putc>
 5db:	eb 28                	jmp    605 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5dd:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5e4:	00 
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	89 04 24             	mov    %eax,(%esp)
 5eb:	e8 a2 fd ff ff       	call   392 <putc>
        putc(fd, c);
 5f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f3:	0f be c0             	movsbl %al,%eax
 5f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fa:	8b 45 08             	mov    0x8(%ebp),%eax
 5fd:	89 04 24             	mov    %eax,(%esp)
 600:	e8 8d fd ff ff       	call   392 <putc>
      }
      state = 0;
 605:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 60c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 610:	8b 55 0c             	mov    0xc(%ebp),%edx
 613:	8b 45 f0             	mov    -0x10(%ebp),%eax
 616:	01 d0                	add    %edx,%eax
 618:	0f b6 00             	movzbl (%eax),%eax
 61b:	84 c0                	test   %al,%al
 61d:	0f 85 71 fe ff ff    	jne    494 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 623:	c9                   	leave  
 624:	c3                   	ret    

00000625 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 625:	55                   	push   %ebp
 626:	89 e5                	mov    %esp,%ebp
 628:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 62b:	8b 45 08             	mov    0x8(%ebp),%eax
 62e:	83 e8 08             	sub    $0x8,%eax
 631:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 634:	a1 c8 0a 00 00       	mov    0xac8,%eax
 639:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63c:	eb 24                	jmp    662 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 641:	8b 00                	mov    (%eax),%eax
 643:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 646:	77 12                	ja     65a <free+0x35>
 648:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64e:	77 24                	ja     674 <free+0x4f>
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 00                	mov    (%eax),%eax
 655:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 658:	77 1a                	ja     674 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 668:	76 d4                	jbe    63e <free+0x19>
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 672:	76 ca                	jbe    63e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	8b 40 04             	mov    0x4(%eax),%eax
 67a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	01 c2                	add    %eax,%edx
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	39 c2                	cmp    %eax,%edx
 68d:	75 24                	jne    6b3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	8b 50 04             	mov    0x4(%eax),%edx
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	8b 00                	mov    (%eax),%eax
 69a:	8b 40 04             	mov    0x4(%eax),%eax
 69d:	01 c2                	add    %eax,%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 00                	mov    (%eax),%eax
 6aa:	8b 10                	mov    (%eax),%edx
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	89 10                	mov    %edx,(%eax)
 6b1:	eb 0a                	jmp    6bd <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 10                	mov    (%eax),%edx
 6b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bb:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 40 04             	mov    0x4(%eax),%eax
 6c3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	01 d0                	add    %edx,%eax
 6cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d2:	75 20                	jne    6f4 <free+0xcf>
    p->s.size += bp->s.size;
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 50 04             	mov    0x4(%eax),%edx
 6da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dd:	8b 40 04             	mov    0x4(%eax),%eax
 6e0:	01 c2                	add    %eax,%edx
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6eb:	8b 10                	mov    (%eax),%edx
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	89 10                	mov    %edx,(%eax)
 6f2:	eb 08                	jmp    6fc <free+0xd7>
  } else
    p->s.ptr = bp;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6fa:	89 10                	mov    %edx,(%eax)
  freep = p;
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	a3 c8 0a 00 00       	mov    %eax,0xac8
}
 704:	c9                   	leave  
 705:	c3                   	ret    

00000706 <morecore>:

static Header*
morecore(uint nu)
{
 706:	55                   	push   %ebp
 707:	89 e5                	mov    %esp,%ebp
 709:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 70c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 713:	77 07                	ja     71c <morecore+0x16>
    nu = 4096;
 715:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 71c:	8b 45 08             	mov    0x8(%ebp),%eax
 71f:	c1 e0 03             	shl    $0x3,%eax
 722:	89 04 24             	mov    %eax,(%esp)
 725:	e8 08 fc ff ff       	call   332 <sbrk>
 72a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 72d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 731:	75 07                	jne    73a <morecore+0x34>
    return 0;
 733:	b8 00 00 00 00       	mov    $0x0,%eax
 738:	eb 22                	jmp    75c <morecore+0x56>
  hp = (Header*)p;
 73a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 740:	8b 45 f0             	mov    -0x10(%ebp),%eax
 743:	8b 55 08             	mov    0x8(%ebp),%edx
 746:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 749:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74c:	83 c0 08             	add    $0x8,%eax
 74f:	89 04 24             	mov    %eax,(%esp)
 752:	e8 ce fe ff ff       	call   625 <free>
  return freep;
 757:	a1 c8 0a 00 00       	mov    0xac8,%eax
}
 75c:	c9                   	leave  
 75d:	c3                   	ret    

0000075e <malloc>:

void*
malloc(uint nbytes)
{
 75e:	55                   	push   %ebp
 75f:	89 e5                	mov    %esp,%ebp
 761:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 764:	8b 45 08             	mov    0x8(%ebp),%eax
 767:	83 c0 07             	add    $0x7,%eax
 76a:	c1 e8 03             	shr    $0x3,%eax
 76d:	83 c0 01             	add    $0x1,%eax
 770:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 773:	a1 c8 0a 00 00       	mov    0xac8,%eax
 778:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 77f:	75 23                	jne    7a4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 781:	c7 45 f0 c0 0a 00 00 	movl   $0xac0,-0x10(%ebp)
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	a3 c8 0a 00 00       	mov    %eax,0xac8
 790:	a1 c8 0a 00 00       	mov    0xac8,%eax
 795:	a3 c0 0a 00 00       	mov    %eax,0xac0
    base.s.size = 0;
 79a:	c7 05 c4 0a 00 00 00 	movl   $0x0,0xac4
 7a1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b5:	72 4d                	jb     804 <malloc+0xa6>
      if(p->s.size == nunits)
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	8b 40 04             	mov    0x4(%eax),%eax
 7bd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c0:	75 0c                	jne    7ce <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8b 10                	mov    (%eax),%edx
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	89 10                	mov    %edx,(%eax)
 7cc:	eb 26                	jmp    7f4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	8b 40 04             	mov    0x4(%eax),%eax
 7d4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7d7:	89 c2                	mov    %eax,%edx
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8b 40 04             	mov    0x4(%eax),%eax
 7e5:	c1 e0 03             	shl    $0x3,%eax
 7e8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	a3 c8 0a 00 00       	mov    %eax,0xac8
      return (void*)(p + 1);
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	83 c0 08             	add    $0x8,%eax
 802:	eb 38                	jmp    83c <malloc+0xde>
    }
    if(p == freep)
 804:	a1 c8 0a 00 00       	mov    0xac8,%eax
 809:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80c:	75 1b                	jne    829 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 80e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 811:	89 04 24             	mov    %eax,(%esp)
 814:	e8 ed fe ff ff       	call   706 <morecore>
 819:	89 45 f4             	mov    %eax,-0xc(%ebp)
 81c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 820:	75 07                	jne    829 <malloc+0xcb>
        return 0;
 822:	b8 00 00 00 00       	mov    $0x0,%eax
 827:	eb 13                	jmp    83c <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	8b 00                	mov    (%eax),%eax
 834:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 837:	e9 70 ff ff ff       	jmp    7ac <malloc+0x4e>
}
 83c:	c9                   	leave  
 83d:	c3                   	ret    

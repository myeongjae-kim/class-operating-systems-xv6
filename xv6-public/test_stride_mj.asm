
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
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  printf(1, "set_cpu_share(0): return: %d\n", set_cpu_share(0));
   9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10:	e8 db 03 00 00       	call   3f0 <set_cpu_share>
  15:	89 44 24 08          	mov    %eax,0x8(%esp)
  19:	c7 44 24 04 c4 08 00 	movl   $0x8c4,0x4(%esp)
  20:	00 
  21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  28:	e8 cb 04 00 00       	call   4f8 <printf>
  printf(1, "set_cpu_share(81): return: %d\n", set_cpu_share(81));
  2d:	c7 04 24 51 00 00 00 	movl   $0x51,(%esp)
  34:	e8 b7 03 00 00       	call   3f0 <set_cpu_share>
  39:	89 44 24 08          	mov    %eax,0x8(%esp)
  3d:	c7 44 24 04 e4 08 00 	movl   $0x8e4,0x4(%esp)
  44:	00 
  45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4c:	e8 a7 04 00 00       	call   4f8 <printf>
  printf(1, "set_cpu_share(50): return: %d\n", set_cpu_share(50));
  51:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
  58:	e8 93 03 00 00       	call   3f0 <set_cpu_share>
  5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  61:	c7 44 24 04 04 09 00 	movl   $0x904,0x4(%esp)
  68:	00 
  69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  70:	e8 83 04 00 00       	call   4f8 <printf>
  printf(1, "set_cpu_share(80): return: %d\n", set_cpu_share(80));
  75:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  7c:	e8 6f 03 00 00       	call   3f0 <set_cpu_share>
  81:	89 44 24 08          	mov    %eax,0x8(%esp)
  85:	c7 44 24 04 24 09 00 	movl   $0x924,0x4(%esp)
  8c:	00 
  8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  94:	e8 5f 04 00 00       	call   4f8 <printf>

  for (i = 0; i < 1; ++i) {
  99:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  a0:	00 
  a1:	eb 19                	jmp    bc <main+0xbc>
    printf(0, "0");
  a3:	c7 44 24 04 43 09 00 	movl   $0x943,0x4(%esp)
  aa:	00 
  ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  b2:	e8 41 04 00 00       	call   4f8 <printf>
  printf(1, "set_cpu_share(0): return: %d\n", set_cpu_share(0));
  printf(1, "set_cpu_share(81): return: %d\n", set_cpu_share(81));
  printf(1, "set_cpu_share(50): return: %d\n", set_cpu_share(50));
  printf(1, "set_cpu_share(80): return: %d\n", set_cpu_share(80));

  for (i = 0; i < 1; ++i) {
  b7:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  bc:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  c1:	7e e0                	jle    a3 <main+0xa3>
    printf(0, "0");
  }
  exit();
  c3:	e8 68 02 00 00       	call   330 <exit>

000000c8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	57                   	push   %edi
  cc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  d0:	8b 55 10             	mov    0x10(%ebp),%edx
  d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  d6:	89 cb                	mov    %ecx,%ebx
  d8:	89 df                	mov    %ebx,%edi
  da:	89 d1                	mov    %edx,%ecx
  dc:	fc                   	cld    
  dd:	f3 aa                	rep stos %al,%es:(%edi)
  df:	89 ca                	mov    %ecx,%edx
  e1:	89 fb                	mov    %edi,%ebx
  e3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  e6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  e9:	5b                   	pop    %ebx
  ea:	5f                   	pop    %edi
  eb:	5d                   	pop    %ebp
  ec:	c3                   	ret    

000000ed <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  ed:	55                   	push   %ebp
  ee:	89 e5                	mov    %esp,%ebp
  f0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  f9:	90                   	nop
  fa:	8b 45 08             	mov    0x8(%ebp),%eax
  fd:	8d 50 01             	lea    0x1(%eax),%edx
 100:	89 55 08             	mov    %edx,0x8(%ebp)
 103:	8b 55 0c             	mov    0xc(%ebp),%edx
 106:	8d 4a 01             	lea    0x1(%edx),%ecx
 109:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 10c:	0f b6 12             	movzbl (%edx),%edx
 10f:	88 10                	mov    %dl,(%eax)
 111:	0f b6 00             	movzbl (%eax),%eax
 114:	84 c0                	test   %al,%al
 116:	75 e2                	jne    fa <strcpy+0xd>
    ;
  return os;
 118:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11b:	c9                   	leave  
 11c:	c3                   	ret    

0000011d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 120:	eb 08                	jmp    12a <strcmp+0xd>
    p++, q++;
 122:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 126:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
 12d:	0f b6 00             	movzbl (%eax),%eax
 130:	84 c0                	test   %al,%al
 132:	74 10                	je     144 <strcmp+0x27>
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	0f b6 10             	movzbl (%eax),%edx
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	0f b6 00             	movzbl (%eax),%eax
 140:	38 c2                	cmp    %al,%dl
 142:	74 de                	je     122 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	0f b6 00             	movzbl (%eax),%eax
 14a:	0f b6 d0             	movzbl %al,%edx
 14d:	8b 45 0c             	mov    0xc(%ebp),%eax
 150:	0f b6 00             	movzbl (%eax),%eax
 153:	0f b6 c0             	movzbl %al,%eax
 156:	29 c2                	sub    %eax,%edx
 158:	89 d0                	mov    %edx,%eax
}
 15a:	5d                   	pop    %ebp
 15b:	c3                   	ret    

0000015c <strlen>:

uint
strlen(char *s)
{
 15c:	55                   	push   %ebp
 15d:	89 e5                	mov    %esp,%ebp
 15f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 162:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 169:	eb 04                	jmp    16f <strlen+0x13>
 16b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 16f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	01 d0                	add    %edx,%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	84 c0                	test   %al,%al
 17c:	75 ed                	jne    16b <strlen+0xf>
    ;
  return n;
 17e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 181:	c9                   	leave  
 182:	c3                   	ret    

00000183 <memset>:

void*
memset(void *dst, int c, uint n)
{
 183:	55                   	push   %ebp
 184:	89 e5                	mov    %esp,%ebp
 186:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 189:	8b 45 10             	mov    0x10(%ebp),%eax
 18c:	89 44 24 08          	mov    %eax,0x8(%esp)
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	89 44 24 04          	mov    %eax,0x4(%esp)
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	89 04 24             	mov    %eax,(%esp)
 19d:	e8 26 ff ff ff       	call   c8 <stosb>
  return dst;
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a5:	c9                   	leave  
 1a6:	c3                   	ret    

000001a7 <strchr>:

char*
strchr(const char *s, char c)
{
 1a7:	55                   	push   %ebp
 1a8:	89 e5                	mov    %esp,%ebp
 1aa:	83 ec 04             	sub    $0x4,%esp
 1ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b3:	eb 14                	jmp    1c9 <strchr+0x22>
    if(*s == c)
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1be:	75 05                	jne    1c5 <strchr+0x1e>
      return (char*)s;
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	eb 13                	jmp    1d8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c9:	8b 45 08             	mov    0x8(%ebp),%eax
 1cc:	0f b6 00             	movzbl (%eax),%eax
 1cf:	84 c0                	test   %al,%al
 1d1:	75 e2                	jne    1b5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1d8:	c9                   	leave  
 1d9:	c3                   	ret    

000001da <gets>:

char*
gets(char *buf, int max)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e7:	eb 4c                	jmp    235 <gets+0x5b>
    cc = read(0, &c, 1);
 1e9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1f0:	00 
 1f1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1ff:	e8 44 01 00 00       	call   348 <read>
 204:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 207:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 20b:	7f 02                	jg     20f <gets+0x35>
      break;
 20d:	eb 31                	jmp    240 <gets+0x66>
    buf[i++] = c;
 20f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 212:	8d 50 01             	lea    0x1(%eax),%edx
 215:	89 55 f4             	mov    %edx,-0xc(%ebp)
 218:	89 c2                	mov    %eax,%edx
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	01 c2                	add    %eax,%edx
 21f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 223:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 225:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 229:	3c 0a                	cmp    $0xa,%al
 22b:	74 13                	je     240 <gets+0x66>
 22d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 231:	3c 0d                	cmp    $0xd,%al
 233:	74 0b                	je     240 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	83 c0 01             	add    $0x1,%eax
 23b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 23e:	7c a9                	jl     1e9 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 240:	8b 55 f4             	mov    -0xc(%ebp),%edx
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	01 d0                	add    %edx,%eax
 248:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <stat>:

int
stat(char *n, struct stat *st)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 256:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 25d:	00 
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	89 04 24             	mov    %eax,(%esp)
 264:	e8 07 01 00 00       	call   370 <open>
 269:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 26c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 270:	79 07                	jns    279 <stat+0x29>
    return -1;
 272:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 277:	eb 23                	jmp    29c <stat+0x4c>
  r = fstat(fd, st);
 279:	8b 45 0c             	mov    0xc(%ebp),%eax
 27c:	89 44 24 04          	mov    %eax,0x4(%esp)
 280:	8b 45 f4             	mov    -0xc(%ebp),%eax
 283:	89 04 24             	mov    %eax,(%esp)
 286:	e8 fd 00 00 00       	call   388 <fstat>
 28b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 28e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 291:	89 04 24             	mov    %eax,(%esp)
 294:	e8 bf 00 00 00       	call   358 <close>
  return r;
 299:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 29c:	c9                   	leave  
 29d:	c3                   	ret    

0000029e <atoi>:

int
atoi(const char *s)
{
 29e:	55                   	push   %ebp
 29f:	89 e5                	mov    %esp,%ebp
 2a1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ab:	eb 25                	jmp    2d2 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b0:	89 d0                	mov    %edx,%eax
 2b2:	c1 e0 02             	shl    $0x2,%eax
 2b5:	01 d0                	add    %edx,%eax
 2b7:	01 c0                	add    %eax,%eax
 2b9:	89 c1                	mov    %eax,%ecx
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	8d 50 01             	lea    0x1(%eax),%edx
 2c1:	89 55 08             	mov    %edx,0x8(%ebp)
 2c4:	0f b6 00             	movzbl (%eax),%eax
 2c7:	0f be c0             	movsbl %al,%eax
 2ca:	01 c8                	add    %ecx,%eax
 2cc:	83 e8 30             	sub    $0x30,%eax
 2cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	0f b6 00             	movzbl (%eax),%eax
 2d8:	3c 2f                	cmp    $0x2f,%al
 2da:	7e 0a                	jle    2e6 <atoi+0x48>
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	0f b6 00             	movzbl (%eax),%eax
 2e2:	3c 39                	cmp    $0x39,%al
 2e4:	7e c7                	jle    2ad <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2e9:	c9                   	leave  
 2ea:	c3                   	ret    

000002eb <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
 2ee:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2fd:	eb 17                	jmp    316 <memmove+0x2b>
    *dst++ = *src++;
 2ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 302:	8d 50 01             	lea    0x1(%eax),%edx
 305:	89 55 fc             	mov    %edx,-0x4(%ebp)
 308:	8b 55 f8             	mov    -0x8(%ebp),%edx
 30b:	8d 4a 01             	lea    0x1(%edx),%ecx
 30e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 311:	0f b6 12             	movzbl (%edx),%edx
 314:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 316:	8b 45 10             	mov    0x10(%ebp),%eax
 319:	8d 50 ff             	lea    -0x1(%eax),%edx
 31c:	89 55 10             	mov    %edx,0x10(%ebp)
 31f:	85 c0                	test   %eax,%eax
 321:	7f dc                	jg     2ff <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 323:	8b 45 08             	mov    0x8(%ebp),%eax
}
 326:	c9                   	leave  
 327:	c3                   	ret    

00000328 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 328:	b8 01 00 00 00       	mov    $0x1,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <exit>:
SYSCALL(exit)
 330:	b8 02 00 00 00       	mov    $0x2,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <wait>:
SYSCALL(wait)
 338:	b8 03 00 00 00       	mov    $0x3,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <pipe>:
SYSCALL(pipe)
 340:	b8 04 00 00 00       	mov    $0x4,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <read>:
SYSCALL(read)
 348:	b8 05 00 00 00       	mov    $0x5,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <write>:
SYSCALL(write)
 350:	b8 10 00 00 00       	mov    $0x10,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <close>:
SYSCALL(close)
 358:	b8 15 00 00 00       	mov    $0x15,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <kill>:
SYSCALL(kill)
 360:	b8 06 00 00 00       	mov    $0x6,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <exec>:
SYSCALL(exec)
 368:	b8 07 00 00 00       	mov    $0x7,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <open>:
SYSCALL(open)
 370:	b8 0f 00 00 00       	mov    $0xf,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <mknod>:
SYSCALL(mknod)
 378:	b8 11 00 00 00       	mov    $0x11,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <unlink>:
SYSCALL(unlink)
 380:	b8 12 00 00 00       	mov    $0x12,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <fstat>:
SYSCALL(fstat)
 388:	b8 08 00 00 00       	mov    $0x8,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <link>:
SYSCALL(link)
 390:	b8 13 00 00 00       	mov    $0x13,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <mkdir>:
SYSCALL(mkdir)
 398:	b8 14 00 00 00       	mov    $0x14,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <chdir>:
SYSCALL(chdir)
 3a0:	b8 09 00 00 00       	mov    $0x9,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <dup>:
SYSCALL(dup)
 3a8:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <getpid>:
SYSCALL(getpid)
 3b0:	b8 0b 00 00 00       	mov    $0xb,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <sbrk>:
SYSCALL(sbrk)
 3b8:	b8 0c 00 00 00       	mov    $0xc,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <sleep>:
SYSCALL(sleep)
 3c0:	b8 0d 00 00 00       	mov    $0xd,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <uptime>:
SYSCALL(uptime)
 3c8:	b8 0e 00 00 00       	mov    $0xe,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <my_syscall>:
SYSCALL(my_syscall)
 3d0:	b8 16 00 00 00       	mov    $0x16,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <getppid>:
SYSCALL(getppid)
 3d8:	b8 17 00 00 00       	mov    $0x17,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <yield>:
SYSCALL(yield)
 3e0:	b8 18 00 00 00       	mov    $0x18,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <getlev>:
SYSCALL(getlev)
 3e8:	b8 19 00 00 00       	mov    $0x19,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <set_cpu_share>:
SYSCALL(set_cpu_share)
 3f0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <thread_create>:
SYSCALL(thread_create)
 3f8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <thread_exit>:
SYSCALL(thread_exit)
 400:	b8 1c 00 00 00       	mov    $0x1c,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <thread_join>:
SYSCALL(thread_join)
 408:	b8 1d 00 00 00       	mov    $0x1d,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <gettid>:
SYSCALL(gettid)
 410:	b8 1e 00 00 00       	mov    $0x1e,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 18             	sub    $0x18,%esp
 41e:	8b 45 0c             	mov    0xc(%ebp),%eax
 421:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 424:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 42b:	00 
 42c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 42f:	89 44 24 04          	mov    %eax,0x4(%esp)
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	89 04 24             	mov    %eax,(%esp)
 439:	e8 12 ff ff ff       	call   350 <write>
}
 43e:	c9                   	leave  
 43f:	c3                   	ret    

00000440 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	56                   	push   %esi
 444:	53                   	push   %ebx
 445:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 448:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 44f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 453:	74 17                	je     46c <printint+0x2c>
 455:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 459:	79 11                	jns    46c <printint+0x2c>
    neg = 1;
 45b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 462:	8b 45 0c             	mov    0xc(%ebp),%eax
 465:	f7 d8                	neg    %eax
 467:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46a:	eb 06                	jmp    472 <printint+0x32>
  } else {
    x = xx;
 46c:	8b 45 0c             	mov    0xc(%ebp),%eax
 46f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 472:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 479:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 47c:	8d 41 01             	lea    0x1(%ecx),%eax
 47f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 482:	8b 5d 10             	mov    0x10(%ebp),%ebx
 485:	8b 45 ec             	mov    -0x14(%ebp),%eax
 488:	ba 00 00 00 00       	mov    $0x0,%edx
 48d:	f7 f3                	div    %ebx
 48f:	89 d0                	mov    %edx,%eax
 491:	0f b6 80 90 0b 00 00 	movzbl 0xb90(%eax),%eax
 498:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 49c:	8b 75 10             	mov    0x10(%ebp),%esi
 49f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a2:	ba 00 00 00 00       	mov    $0x0,%edx
 4a7:	f7 f6                	div    %esi
 4a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b0:	75 c7                	jne    479 <printint+0x39>
  if(neg)
 4b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b6:	74 10                	je     4c8 <printint+0x88>
    buf[i++] = '-';
 4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bb:	8d 50 01             	lea    0x1(%eax),%edx
 4be:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4c6:	eb 1f                	jmp    4e7 <printint+0xa7>
 4c8:	eb 1d                	jmp    4e7 <printint+0xa7>
    putc(fd, buf[i]);
 4ca:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d0:	01 d0                	add    %edx,%eax
 4d2:	0f b6 00             	movzbl (%eax),%eax
 4d5:	0f be c0             	movsbl %al,%eax
 4d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4dc:	8b 45 08             	mov    0x8(%ebp),%eax
 4df:	89 04 24             	mov    %eax,(%esp)
 4e2:	e8 31 ff ff ff       	call   418 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4e7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ef:	79 d9                	jns    4ca <printint+0x8a>
    putc(fd, buf[i]);
}
 4f1:	83 c4 30             	add    $0x30,%esp
 4f4:	5b                   	pop    %ebx
 4f5:	5e                   	pop    %esi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    

000004f8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f8:	55                   	push   %ebp
 4f9:	89 e5                	mov    %esp,%ebp
 4fb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 505:	8d 45 0c             	lea    0xc(%ebp),%eax
 508:	83 c0 04             	add    $0x4,%eax
 50b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 50e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 515:	e9 7c 01 00 00       	jmp    696 <printf+0x19e>
    c = fmt[i] & 0xff;
 51a:	8b 55 0c             	mov    0xc(%ebp),%edx
 51d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 520:	01 d0                	add    %edx,%eax
 522:	0f b6 00             	movzbl (%eax),%eax
 525:	0f be c0             	movsbl %al,%eax
 528:	25 ff 00 00 00       	and    $0xff,%eax
 52d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 530:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 534:	75 2c                	jne    562 <printf+0x6a>
      if(c == '%'){
 536:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53a:	75 0c                	jne    548 <printf+0x50>
        state = '%';
 53c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 543:	e9 4a 01 00 00       	jmp    692 <printf+0x19a>
      } else {
        putc(fd, c);
 548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54b:	0f be c0             	movsbl %al,%eax
 54e:	89 44 24 04          	mov    %eax,0x4(%esp)
 552:	8b 45 08             	mov    0x8(%ebp),%eax
 555:	89 04 24             	mov    %eax,(%esp)
 558:	e8 bb fe ff ff       	call   418 <putc>
 55d:	e9 30 01 00 00       	jmp    692 <printf+0x19a>
      }
    } else if(state == '%'){
 562:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 566:	0f 85 26 01 00 00    	jne    692 <printf+0x19a>
      if(c == 'd'){
 56c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 570:	75 2d                	jne    59f <printf+0xa7>
        printint(fd, *ap, 10, 1);
 572:	8b 45 e8             	mov    -0x18(%ebp),%eax
 575:	8b 00                	mov    (%eax),%eax
 577:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 57e:	00 
 57f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 586:	00 
 587:	89 44 24 04          	mov    %eax,0x4(%esp)
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	89 04 24             	mov    %eax,(%esp)
 591:	e8 aa fe ff ff       	call   440 <printint>
        ap++;
 596:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59a:	e9 ec 00 00 00       	jmp    68b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 59f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a3:	74 06                	je     5ab <printf+0xb3>
 5a5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a9:	75 2d                	jne    5d8 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ae:	8b 00                	mov    (%eax),%eax
 5b0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5b7:	00 
 5b8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5bf:	00 
 5c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	89 04 24             	mov    %eax,(%esp)
 5ca:	e8 71 fe ff ff       	call   440 <printint>
        ap++;
 5cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d3:	e9 b3 00 00 00       	jmp    68b <printf+0x193>
      } else if(c == 's'){
 5d8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5dc:	75 45                	jne    623 <printf+0x12b>
        s = (char*)*ap;
 5de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e1:	8b 00                	mov    (%eax),%eax
 5e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ee:	75 09                	jne    5f9 <printf+0x101>
          s = "(null)";
 5f0:	c7 45 f4 45 09 00 00 	movl   $0x945,-0xc(%ebp)
        while(*s != 0){
 5f7:	eb 1e                	jmp    617 <printf+0x11f>
 5f9:	eb 1c                	jmp    617 <printf+0x11f>
          putc(fd, *s);
 5fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fe:	0f b6 00             	movzbl (%eax),%eax
 601:	0f be c0             	movsbl %al,%eax
 604:	89 44 24 04          	mov    %eax,0x4(%esp)
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	89 04 24             	mov    %eax,(%esp)
 60e:	e8 05 fe ff ff       	call   418 <putc>
          s++;
 613:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 617:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61a:	0f b6 00             	movzbl (%eax),%eax
 61d:	84 c0                	test   %al,%al
 61f:	75 da                	jne    5fb <printf+0x103>
 621:	eb 68                	jmp    68b <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 623:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 627:	75 1d                	jne    646 <printf+0x14e>
        putc(fd, *ap);
 629:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	0f be c0             	movsbl %al,%eax
 631:	89 44 24 04          	mov    %eax,0x4(%esp)
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	89 04 24             	mov    %eax,(%esp)
 63b:	e8 d8 fd ff ff       	call   418 <putc>
        ap++;
 640:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 644:	eb 45                	jmp    68b <printf+0x193>
      } else if(c == '%'){
 646:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64a:	75 17                	jne    663 <printf+0x16b>
        putc(fd, c);
 64c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 64f:	0f be c0             	movsbl %al,%eax
 652:	89 44 24 04          	mov    %eax,0x4(%esp)
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	89 04 24             	mov    %eax,(%esp)
 65c:	e8 b7 fd ff ff       	call   418 <putc>
 661:	eb 28                	jmp    68b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 663:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 66a:	00 
 66b:	8b 45 08             	mov    0x8(%ebp),%eax
 66e:	89 04 24             	mov    %eax,(%esp)
 671:	e8 a2 fd ff ff       	call   418 <putc>
        putc(fd, c);
 676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 679:	0f be c0             	movsbl %al,%eax
 67c:	89 44 24 04          	mov    %eax,0x4(%esp)
 680:	8b 45 08             	mov    0x8(%ebp),%eax
 683:	89 04 24             	mov    %eax,(%esp)
 686:	e8 8d fd ff ff       	call   418 <putc>
      }
      state = 0;
 68b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 692:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 696:	8b 55 0c             	mov    0xc(%ebp),%edx
 699:	8b 45 f0             	mov    -0x10(%ebp),%eax
 69c:	01 d0                	add    %edx,%eax
 69e:	0f b6 00             	movzbl (%eax),%eax
 6a1:	84 c0                	test   %al,%al
 6a3:	0f 85 71 fe ff ff    	jne    51a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6a9:	c9                   	leave  
 6aa:	c3                   	ret    

000006ab <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ab:	55                   	push   %ebp
 6ac:	89 e5                	mov    %esp,%ebp
 6ae:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b1:	8b 45 08             	mov    0x8(%ebp),%eax
 6b4:	83 e8 08             	sub    $0x8,%eax
 6b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ba:	a1 ac 0b 00 00       	mov    0xbac,%eax
 6bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c2:	eb 24                	jmp    6e8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 00                	mov    (%eax),%eax
 6c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cc:	77 12                	ja     6e0 <free+0x35>
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d4:	77 24                	ja     6fa <free+0x4f>
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6de:	77 1a                	ja     6fa <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ee:	76 d4                	jbe    6c4 <free+0x19>
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 00                	mov    (%eax),%eax
 6f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f8:	76 ca                	jbe    6c4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	8b 40 04             	mov    0x4(%eax),%eax
 700:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	01 c2                	add    %eax,%edx
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 00                	mov    (%eax),%eax
 711:	39 c2                	cmp    %eax,%edx
 713:	75 24                	jne    739 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 715:	8b 45 f8             	mov    -0x8(%ebp),%eax
 718:	8b 50 04             	mov    0x4(%eax),%edx
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	8b 40 04             	mov    0x4(%eax),%eax
 723:	01 c2                	add    %eax,%edx
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	8b 00                	mov    (%eax),%eax
 730:	8b 10                	mov    (%eax),%edx
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	89 10                	mov    %edx,(%eax)
 737:	eb 0a                	jmp    743 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 10                	mov    (%eax),%edx
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 40 04             	mov    0x4(%eax),%eax
 749:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	01 d0                	add    %edx,%eax
 755:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 758:	75 20                	jne    77a <free+0xcf>
    p->s.size += bp->s.size;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 50 04             	mov    0x4(%eax),%edx
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	8b 40 04             	mov    0x4(%eax),%eax
 766:	01 c2                	add    %eax,%edx
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	8b 10                	mov    (%eax),%edx
 773:	8b 45 fc             	mov    -0x4(%ebp),%eax
 776:	89 10                	mov    %edx,(%eax)
 778:	eb 08                	jmp    782 <free+0xd7>
  } else
    p->s.ptr = bp;
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 780:	89 10                	mov    %edx,(%eax)
  freep = p;
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	a3 ac 0b 00 00       	mov    %eax,0xbac
}
 78a:	c9                   	leave  
 78b:	c3                   	ret    

0000078c <morecore>:

static Header*
morecore(uint nu)
{
 78c:	55                   	push   %ebp
 78d:	89 e5                	mov    %esp,%ebp
 78f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 792:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 799:	77 07                	ja     7a2 <morecore+0x16>
    nu = 4096;
 79b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a2:	8b 45 08             	mov    0x8(%ebp),%eax
 7a5:	c1 e0 03             	shl    $0x3,%eax
 7a8:	89 04 24             	mov    %eax,(%esp)
 7ab:	e8 08 fc ff ff       	call   3b8 <sbrk>
 7b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7b3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7b7:	75 07                	jne    7c0 <morecore+0x34>
    return 0;
 7b9:	b8 00 00 00 00       	mov    $0x0,%eax
 7be:	eb 22                	jmp    7e2 <morecore+0x56>
  hp = (Header*)p;
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c9:	8b 55 08             	mov    0x8(%ebp),%edx
 7cc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d2:	83 c0 08             	add    $0x8,%eax
 7d5:	89 04 24             	mov    %eax,(%esp)
 7d8:	e8 ce fe ff ff       	call   6ab <free>
  return freep;
 7dd:	a1 ac 0b 00 00       	mov    0xbac,%eax
}
 7e2:	c9                   	leave  
 7e3:	c3                   	ret    

000007e4 <malloc>:

void*
malloc(uint nbytes)
{
 7e4:	55                   	push   %ebp
 7e5:	89 e5                	mov    %esp,%ebp
 7e7:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ea:	8b 45 08             	mov    0x8(%ebp),%eax
 7ed:	83 c0 07             	add    $0x7,%eax
 7f0:	c1 e8 03             	shr    $0x3,%eax
 7f3:	83 c0 01             	add    $0x1,%eax
 7f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7f9:	a1 ac 0b 00 00       	mov    0xbac,%eax
 7fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
 801:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 805:	75 23                	jne    82a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 807:	c7 45 f0 a4 0b 00 00 	movl   $0xba4,-0x10(%ebp)
 80e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 811:	a3 ac 0b 00 00       	mov    %eax,0xbac
 816:	a1 ac 0b 00 00       	mov    0xbac,%eax
 81b:	a3 a4 0b 00 00       	mov    %eax,0xba4
    base.s.size = 0;
 820:	c7 05 a8 0b 00 00 00 	movl   $0x0,0xba8
 827:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82d:	8b 00                	mov    (%eax),%eax
 82f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 832:	8b 45 f4             	mov    -0xc(%ebp),%eax
 835:	8b 40 04             	mov    0x4(%eax),%eax
 838:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 83b:	72 4d                	jb     88a <malloc+0xa6>
      if(p->s.size == nunits)
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	8b 40 04             	mov    0x4(%eax),%eax
 843:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 846:	75 0c                	jne    854 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	8b 10                	mov    (%eax),%edx
 84d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 850:	89 10                	mov    %edx,(%eax)
 852:	eb 26                	jmp    87a <malloc+0x96>
      else {
        p->s.size -= nunits;
 854:	8b 45 f4             	mov    -0xc(%ebp),%eax
 857:	8b 40 04             	mov    0x4(%eax),%eax
 85a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 85d:	89 c2                	mov    %eax,%edx
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	8b 40 04             	mov    0x4(%eax),%eax
 86b:	c1 e0 03             	shl    $0x3,%eax
 86e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	8b 55 ec             	mov    -0x14(%ebp),%edx
 877:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 87a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87d:	a3 ac 0b 00 00       	mov    %eax,0xbac
      return (void*)(p + 1);
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	83 c0 08             	add    $0x8,%eax
 888:	eb 38                	jmp    8c2 <malloc+0xde>
    }
    if(p == freep)
 88a:	a1 ac 0b 00 00       	mov    0xbac,%eax
 88f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 892:	75 1b                	jne    8af <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 894:	8b 45 ec             	mov    -0x14(%ebp),%eax
 897:	89 04 24             	mov    %eax,(%esp)
 89a:	e8 ed fe ff ff       	call   78c <morecore>
 89f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a6:	75 07                	jne    8af <malloc+0xcb>
        return 0;
 8a8:	b8 00 00 00 00       	mov    $0x0,%eax
 8ad:	eb 13                	jmp    8c2 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	8b 00                	mov    (%eax),%eax
 8ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8bd:	e9 70 ff ff ff       	jmp    832 <malloc+0x4e>
}
 8c2:	c9                   	leave  
 8c3:	c3                   	ret    

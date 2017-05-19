
_test_mlfq_mj:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
    uint pid, i, j, count = 100;
   9:	c7 44 24 14 64 00 00 	movl   $0x64,0x14(%esp)
  10:	00 
    pid = fork();
  11:	e8 4b 03 00 00       	call   361 <fork>
  16:	89 44 24 10          	mov    %eax,0x10(%esp)

    if (pid == 0) {
  1a:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  1f:	75 65                	jne    86 <main+0x86>
        /* child*/
        for (i = 0; i < count; ++i) {
  21:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  28:	00 
  29:	eb 3b                	jmp    66 <main+0x66>
            printf(1, "Child. getlev(): %d.\n", getlev());
  2b:	e8 f1 03 00 00       	call   421 <getlev>
  30:	89 44 24 08          	mov    %eax,0x8(%esp)
  34:	c7 44 24 04 00 09 00 	movl   $0x900,0x4(%esp)
  3b:	00 
  3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  43:	e8 e9 04 00 00       	call   531 <printf>
            for (j = 0; j < 50000000; ++j) {
  48:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  4f:	00 
  50:	eb 05                	jmp    57 <main+0x57>
  52:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
  57:	81 7c 24 18 7f f0 fa 	cmpl   $0x2faf07f,0x18(%esp)
  5e:	02 
  5f:	76 f1                	jbe    52 <main+0x52>
    uint pid, i, j, count = 100;
    pid = fork();

    if (pid == 0) {
        /* child*/
        for (i = 0; i < count; ++i) {
  61:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  66:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  6a:	3b 44 24 14          	cmp    0x14(%esp),%eax
  6e:	72 bb                	jb     2b <main+0x2b>
            printf(1, "Child. getlev(): %d.\n", getlev());
            for (j = 0; j < 50000000; ++j) {
              
            }
        }
        printf(1, "\n");
  70:	c7 44 24 04 16 09 00 	movl   $0x916,0x4(%esp)
  77:	00 
  78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7f:	e8 ad 04 00 00       	call   531 <printf>
  84:	eb 71                	jmp    f7 <main+0xf7>
    } else if (pid > 0) {
  86:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  8b:	74 51                	je     de <main+0xde>
        /** parent */
        for (i = 0; i < count; ++i) {
  8d:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  94:	00 
  95:	eb 3b                	jmp    d2 <main+0xd2>
            printf(1, "Parent. getlev(): %d.\n", getlev());
  97:	e8 85 03 00 00       	call   421 <getlev>
  9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  a0:	c7 44 24 04 18 09 00 	movl   $0x918,0x4(%esp)
  a7:	00 
  a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  af:	e8 7d 04 00 00       	call   531 <printf>
            for (j = 0; j < 50000000; ++j) {
  b4:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  bb:	00 
  bc:	eb 05                	jmp    c3 <main+0xc3>
  be:	83 44 24 18 01       	addl   $0x1,0x18(%esp)
  c3:	81 7c 24 18 7f f0 fa 	cmpl   $0x2faf07f,0x18(%esp)
  ca:	02 
  cb:	76 f1                	jbe    be <main+0xbe>
            }
        }
        printf(1, "\n");
    } else if (pid > 0) {
        /** parent */
        for (i = 0; i < count; ++i) {
  cd:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  d2:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  d6:	3b 44 24 14          	cmp    0x14(%esp),%eax
  da:	72 bb                	jb     97 <main+0x97>
  dc:	eb 19                	jmp    f7 <main+0xf7>
            for (j = 0; j < 50000000; ++j) {
              
            }
        }
    } else {
        printf(1, "fork() error\nTerminate the program.\n");
  de:	c7 44 24 04 30 09 00 	movl   $0x930,0x4(%esp)
  e5:	00 
  e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ed:	e8 3f 04 00 00       	call   531 <printf>
        exit();
  f2:	e8 72 02 00 00       	call   369 <exit>
    }
    /** parent process should wait till child is terminated */
    wait();
  f7:	e8 75 02 00 00       	call   371 <wait>

    exit();
  fc:	e8 68 02 00 00       	call   369 <exit>

00000101 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	57                   	push   %edi
 105:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 10             	mov    0x10(%ebp),%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	89 cb                	mov    %ecx,%ebx
 111:	89 df                	mov    %ebx,%edi
 113:	89 d1                	mov    %edx,%ecx
 115:	fc                   	cld    
 116:	f3 aa                	rep stos %al,%es:(%edi)
 118:	89 ca                	mov    %ecx,%edx
 11a:	89 fb                	mov    %edi,%ebx
 11c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 122:	5b                   	pop    %ebx
 123:	5f                   	pop    %edi
 124:	5d                   	pop    %ebp
 125:	c3                   	ret    

00000126 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 126:	55                   	push   %ebp
 127:	89 e5                	mov    %esp,%ebp
 129:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 132:	90                   	nop
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	8d 50 01             	lea    0x1(%eax),%edx
 139:	89 55 08             	mov    %edx,0x8(%ebp)
 13c:	8b 55 0c             	mov    0xc(%ebp),%edx
 13f:	8d 4a 01             	lea    0x1(%edx),%ecx
 142:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 145:	0f b6 12             	movzbl (%edx),%edx
 148:	88 10                	mov    %dl,(%eax)
 14a:	0f b6 00             	movzbl (%eax),%eax
 14d:	84 c0                	test   %al,%al
 14f:	75 e2                	jne    133 <strcpy+0xd>
    ;
  return os;
 151:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 154:	c9                   	leave  
 155:	c3                   	ret    

00000156 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 156:	55                   	push   %ebp
 157:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 159:	eb 08                	jmp    163 <strcmp+0xd>
    p++, q++;
 15b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	0f b6 00             	movzbl (%eax),%eax
 169:	84 c0                	test   %al,%al
 16b:	74 10                	je     17d <strcmp+0x27>
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	0f b6 10             	movzbl (%eax),%edx
 173:	8b 45 0c             	mov    0xc(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	38 c2                	cmp    %al,%dl
 17b:	74 de                	je     15b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	0f b6 00             	movzbl (%eax),%eax
 183:	0f b6 d0             	movzbl %al,%edx
 186:	8b 45 0c             	mov    0xc(%ebp),%eax
 189:	0f b6 00             	movzbl (%eax),%eax
 18c:	0f b6 c0             	movzbl %al,%eax
 18f:	29 c2                	sub    %eax,%edx
 191:	89 d0                	mov    %edx,%eax
}
 193:	5d                   	pop    %ebp
 194:	c3                   	ret    

00000195 <strlen>:

uint
strlen(char *s)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a2:	eb 04                	jmp    1a8 <strlen+0x13>
 1a4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ab:	8b 45 08             	mov    0x8(%ebp),%eax
 1ae:	01 d0                	add    %edx,%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	84 c0                	test   %al,%al
 1b5:	75 ed                	jne    1a4 <strlen+0xf>
    ;
  return n;
 1b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ba:	c9                   	leave  
 1bb:	c3                   	ret    

000001bc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1c2:	8b 45 10             	mov    0x10(%ebp),%eax
 1c5:	89 44 24 08          	mov    %eax,0x8(%esp)
 1c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	89 04 24             	mov    %eax,(%esp)
 1d6:	e8 26 ff ff ff       	call   101 <stosb>
  return dst;
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1de:	c9                   	leave  
 1df:	c3                   	ret    

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	83 ec 04             	sub    $0x4,%esp
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ec:	eb 14                	jmp    202 <strchr+0x22>
    if(*s == c)
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	0f b6 00             	movzbl (%eax),%eax
 1f4:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1f7:	75 05                	jne    1fe <strchr+0x1e>
      return (char*)s;
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	eb 13                	jmp    211 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	0f b6 00             	movzbl (%eax),%eax
 208:	84 c0                	test   %al,%al
 20a:	75 e2                	jne    1ee <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 20c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <gets>:

char*
gets(char *buf, int max)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
 216:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 219:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 220:	eb 4c                	jmp    26e <gets+0x5b>
    cc = read(0, &c, 1);
 222:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 229:	00 
 22a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22d:	89 44 24 04          	mov    %eax,0x4(%esp)
 231:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 238:	e8 44 01 00 00       	call   381 <read>
 23d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 244:	7f 02                	jg     248 <gets+0x35>
      break;
 246:	eb 31                	jmp    279 <gets+0x66>
    buf[i++] = c;
 248:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24b:	8d 50 01             	lea    0x1(%eax),%edx
 24e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 251:	89 c2                	mov    %eax,%edx
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	01 c2                	add    %eax,%edx
 258:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 25e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 262:	3c 0a                	cmp    $0xa,%al
 264:	74 13                	je     279 <gets+0x66>
 266:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26a:	3c 0d                	cmp    $0xd,%al
 26c:	74 0b                	je     279 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 271:	83 c0 01             	add    $0x1,%eax
 274:	3b 45 0c             	cmp    0xc(%ebp),%eax
 277:	7c a9                	jl     222 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 279:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	01 d0                	add    %edx,%eax
 281:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 284:	8b 45 08             	mov    0x8(%ebp),%eax
}
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <stat>:

int
stat(char *n, struct stat *st)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 296:	00 
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 07 01 00 00       	call   3a9 <open>
 2a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a9:	79 07                	jns    2b2 <stat+0x29>
    return -1;
 2ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b0:	eb 23                	jmp    2d5 <stat+0x4c>
  r = fstat(fd, st);
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bc:	89 04 24             	mov    %eax,(%esp)
 2bf:	e8 fd 00 00 00       	call   3c1 <fstat>
 2c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ca:	89 04 24             	mov    %eax,(%esp)
 2cd:	e8 bf 00 00 00       	call   391 <close>
  return r;
 2d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d5:	c9                   	leave  
 2d6:	c3                   	ret    

000002d7 <atoi>:

int
atoi(const char *s)
{
 2d7:	55                   	push   %ebp
 2d8:	89 e5                	mov    %esp,%ebp
 2da:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e4:	eb 25                	jmp    30b <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e9:	89 d0                	mov    %edx,%eax
 2eb:	c1 e0 02             	shl    $0x2,%eax
 2ee:	01 d0                	add    %edx,%eax
 2f0:	01 c0                	add    %eax,%eax
 2f2:	89 c1                	mov    %eax,%ecx
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	8d 50 01             	lea    0x1(%eax),%edx
 2fa:	89 55 08             	mov    %edx,0x8(%ebp)
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	0f be c0             	movsbl %al,%eax
 303:	01 c8                	add    %ecx,%eax
 305:	83 e8 30             	sub    $0x30,%eax
 308:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	3c 2f                	cmp    $0x2f,%al
 313:	7e 0a                	jle    31f <atoi+0x48>
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	0f b6 00             	movzbl (%eax),%eax
 31b:	3c 39                	cmp    $0x39,%al
 31d:	7e c7                	jle    2e6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 31f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 322:	c9                   	leave  
 323:	c3                   	ret    

00000324 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 330:	8b 45 0c             	mov    0xc(%ebp),%eax
 333:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 336:	eb 17                	jmp    34f <memmove+0x2b>
    *dst++ = *src++;
 338:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33b:	8d 50 01             	lea    0x1(%eax),%edx
 33e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 341:	8b 55 f8             	mov    -0x8(%ebp),%edx
 344:	8d 4a 01             	lea    0x1(%edx),%ecx
 347:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 34a:	0f b6 12             	movzbl (%edx),%edx
 34d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 34f:	8b 45 10             	mov    0x10(%ebp),%eax
 352:	8d 50 ff             	lea    -0x1(%eax),%edx
 355:	89 55 10             	mov    %edx,0x10(%ebp)
 358:	85 c0                	test   %eax,%eax
 35a:	7f dc                	jg     338 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35f:	c9                   	leave  
 360:	c3                   	ret    

00000361 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 361:	b8 01 00 00 00       	mov    $0x1,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <exit>:
SYSCALL(exit)
 369:	b8 02 00 00 00       	mov    $0x2,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <wait>:
SYSCALL(wait)
 371:	b8 03 00 00 00       	mov    $0x3,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <pipe>:
SYSCALL(pipe)
 379:	b8 04 00 00 00       	mov    $0x4,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <read>:
SYSCALL(read)
 381:	b8 05 00 00 00       	mov    $0x5,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <write>:
SYSCALL(write)
 389:	b8 10 00 00 00       	mov    $0x10,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <close>:
SYSCALL(close)
 391:	b8 15 00 00 00       	mov    $0x15,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <kill>:
SYSCALL(kill)
 399:	b8 06 00 00 00       	mov    $0x6,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <exec>:
SYSCALL(exec)
 3a1:	b8 07 00 00 00       	mov    $0x7,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <open>:
SYSCALL(open)
 3a9:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <mknod>:
SYSCALL(mknod)
 3b1:	b8 11 00 00 00       	mov    $0x11,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <unlink>:
SYSCALL(unlink)
 3b9:	b8 12 00 00 00       	mov    $0x12,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <fstat>:
SYSCALL(fstat)
 3c1:	b8 08 00 00 00       	mov    $0x8,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <link>:
SYSCALL(link)
 3c9:	b8 13 00 00 00       	mov    $0x13,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <mkdir>:
SYSCALL(mkdir)
 3d1:	b8 14 00 00 00       	mov    $0x14,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <chdir>:
SYSCALL(chdir)
 3d9:	b8 09 00 00 00       	mov    $0x9,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <dup>:
SYSCALL(dup)
 3e1:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <getpid>:
SYSCALL(getpid)
 3e9:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <sbrk>:
SYSCALL(sbrk)
 3f1:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <sleep>:
SYSCALL(sleep)
 3f9:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <uptime>:
SYSCALL(uptime)
 401:	b8 0e 00 00 00       	mov    $0xe,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <my_syscall>:
SYSCALL(my_syscall)
 409:	b8 16 00 00 00       	mov    $0x16,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <getppid>:
SYSCALL(getppid)
 411:	b8 17 00 00 00       	mov    $0x17,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <yield>:
SYSCALL(yield)
 419:	b8 18 00 00 00       	mov    $0x18,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <getlev>:
SYSCALL(getlev)
 421:	b8 19 00 00 00       	mov    $0x19,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <set_cpu_share>:
SYSCALL(set_cpu_share)
 429:	b8 1a 00 00 00       	mov    $0x1a,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <thread_create>:
SYSCALL(thread_create)
 431:	b8 1b 00 00 00       	mov    $0x1b,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <thread_exit>:
SYSCALL(thread_exit)
 439:	b8 1c 00 00 00       	mov    $0x1c,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <thread_join>:
SYSCALL(thread_join)
 441:	b8 1d 00 00 00       	mov    $0x1d,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <gettid>:
SYSCALL(gettid)
 449:	b8 1e 00 00 00       	mov    $0x1e,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 451:	55                   	push   %ebp
 452:	89 e5                	mov    %esp,%ebp
 454:	83 ec 18             	sub    $0x18,%esp
 457:	8b 45 0c             	mov    0xc(%ebp),%eax
 45a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 45d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 464:	00 
 465:	8d 45 f4             	lea    -0xc(%ebp),%eax
 468:	89 44 24 04          	mov    %eax,0x4(%esp)
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
 46f:	89 04 24             	mov    %eax,(%esp)
 472:	e8 12 ff ff ff       	call   389 <write>
}
 477:	c9                   	leave  
 478:	c3                   	ret    

00000479 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 479:	55                   	push   %ebp
 47a:	89 e5                	mov    %esp,%ebp
 47c:	56                   	push   %esi
 47d:	53                   	push   %ebx
 47e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 481:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 488:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 48c:	74 17                	je     4a5 <printint+0x2c>
 48e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 492:	79 11                	jns    4a5 <printint+0x2c>
    neg = 1;
 494:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 49b:	8b 45 0c             	mov    0xc(%ebp),%eax
 49e:	f7 d8                	neg    %eax
 4a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a3:	eb 06                	jmp    4ab <printint+0x32>
  } else {
    x = xx;
 4a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4b5:	8d 41 01             	lea    0x1(%ecx),%eax
 4b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c1:	ba 00 00 00 00       	mov    $0x0,%edx
 4c6:	f7 f3                	div    %ebx
 4c8:	89 d0                	mov    %edx,%eax
 4ca:	0f b6 80 a0 0b 00 00 	movzbl 0xba0(%eax),%eax
 4d1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4d5:	8b 75 10             	mov    0x10(%ebp),%esi
 4d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4db:	ba 00 00 00 00       	mov    $0x0,%edx
 4e0:	f7 f6                	div    %esi
 4e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e9:	75 c7                	jne    4b2 <printint+0x39>
  if(neg)
 4eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ef:	74 10                	je     501 <printint+0x88>
    buf[i++] = '-';
 4f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f4:	8d 50 01             	lea    0x1(%eax),%edx
 4f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4fa:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4ff:	eb 1f                	jmp    520 <printint+0xa7>
 501:	eb 1d                	jmp    520 <printint+0xa7>
    putc(fd, buf[i]);
 503:	8d 55 dc             	lea    -0x24(%ebp),%edx
 506:	8b 45 f4             	mov    -0xc(%ebp),%eax
 509:	01 d0                	add    %edx,%eax
 50b:	0f b6 00             	movzbl (%eax),%eax
 50e:	0f be c0             	movsbl %al,%eax
 511:	89 44 24 04          	mov    %eax,0x4(%esp)
 515:	8b 45 08             	mov    0x8(%ebp),%eax
 518:	89 04 24             	mov    %eax,(%esp)
 51b:	e8 31 ff ff ff       	call   451 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 520:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 528:	79 d9                	jns    503 <printint+0x8a>
    putc(fd, buf[i]);
}
 52a:	83 c4 30             	add    $0x30,%esp
 52d:	5b                   	pop    %ebx
 52e:	5e                   	pop    %esi
 52f:	5d                   	pop    %ebp
 530:	c3                   	ret    

00000531 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 531:	55                   	push   %ebp
 532:	89 e5                	mov    %esp,%ebp
 534:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 537:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 53e:	8d 45 0c             	lea    0xc(%ebp),%eax
 541:	83 c0 04             	add    $0x4,%eax
 544:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 547:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 54e:	e9 7c 01 00 00       	jmp    6cf <printf+0x19e>
    c = fmt[i] & 0xff;
 553:	8b 55 0c             	mov    0xc(%ebp),%edx
 556:	8b 45 f0             	mov    -0x10(%ebp),%eax
 559:	01 d0                	add    %edx,%eax
 55b:	0f b6 00             	movzbl (%eax),%eax
 55e:	0f be c0             	movsbl %al,%eax
 561:	25 ff 00 00 00       	and    $0xff,%eax
 566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 569:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56d:	75 2c                	jne    59b <printf+0x6a>
      if(c == '%'){
 56f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 573:	75 0c                	jne    581 <printf+0x50>
        state = '%';
 575:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 57c:	e9 4a 01 00 00       	jmp    6cb <printf+0x19a>
      } else {
        putc(fd, c);
 581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 584:	0f be c0             	movsbl %al,%eax
 587:	89 44 24 04          	mov    %eax,0x4(%esp)
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	89 04 24             	mov    %eax,(%esp)
 591:	e8 bb fe ff ff       	call   451 <putc>
 596:	e9 30 01 00 00       	jmp    6cb <printf+0x19a>
      }
    } else if(state == '%'){
 59b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 59f:	0f 85 26 01 00 00    	jne    6cb <printf+0x19a>
      if(c == 'd'){
 5a5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5a9:	75 2d                	jne    5d8 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ae:	8b 00                	mov    (%eax),%eax
 5b0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5b7:	00 
 5b8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5bf:	00 
 5c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	89 04 24             	mov    %eax,(%esp)
 5ca:	e8 aa fe ff ff       	call   479 <printint>
        ap++;
 5cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d3:	e9 ec 00 00 00       	jmp    6c4 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5d8:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5dc:	74 06                	je     5e4 <printf+0xb3>
 5de:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e2:	75 2d                	jne    611 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e7:	8b 00                	mov    (%eax),%eax
 5e9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5f0:	00 
 5f1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5f8:	00 
 5f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fd:	8b 45 08             	mov    0x8(%ebp),%eax
 600:	89 04 24             	mov    %eax,(%esp)
 603:	e8 71 fe ff ff       	call   479 <printint>
        ap++;
 608:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60c:	e9 b3 00 00 00       	jmp    6c4 <printf+0x193>
      } else if(c == 's'){
 611:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 615:	75 45                	jne    65c <printf+0x12b>
        s = (char*)*ap;
 617:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61a:	8b 00                	mov    (%eax),%eax
 61c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 61f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 623:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 627:	75 09                	jne    632 <printf+0x101>
          s = "(null)";
 629:	c7 45 f4 55 09 00 00 	movl   $0x955,-0xc(%ebp)
        while(*s != 0){
 630:	eb 1e                	jmp    650 <printf+0x11f>
 632:	eb 1c                	jmp    650 <printf+0x11f>
          putc(fd, *s);
 634:	8b 45 f4             	mov    -0xc(%ebp),%eax
 637:	0f b6 00             	movzbl (%eax),%eax
 63a:	0f be c0             	movsbl %al,%eax
 63d:	89 44 24 04          	mov    %eax,0x4(%esp)
 641:	8b 45 08             	mov    0x8(%ebp),%eax
 644:	89 04 24             	mov    %eax,(%esp)
 647:	e8 05 fe ff ff       	call   451 <putc>
          s++;
 64c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 650:	8b 45 f4             	mov    -0xc(%ebp),%eax
 653:	0f b6 00             	movzbl (%eax),%eax
 656:	84 c0                	test   %al,%al
 658:	75 da                	jne    634 <printf+0x103>
 65a:	eb 68                	jmp    6c4 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 65c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 660:	75 1d                	jne    67f <printf+0x14e>
        putc(fd, *ap);
 662:	8b 45 e8             	mov    -0x18(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	0f be c0             	movsbl %al,%eax
 66a:	89 44 24 04          	mov    %eax,0x4(%esp)
 66e:	8b 45 08             	mov    0x8(%ebp),%eax
 671:	89 04 24             	mov    %eax,(%esp)
 674:	e8 d8 fd ff ff       	call   451 <putc>
        ap++;
 679:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67d:	eb 45                	jmp    6c4 <printf+0x193>
      } else if(c == '%'){
 67f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 683:	75 17                	jne    69c <printf+0x16b>
        putc(fd, c);
 685:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 688:	0f be c0             	movsbl %al,%eax
 68b:	89 44 24 04          	mov    %eax,0x4(%esp)
 68f:	8b 45 08             	mov    0x8(%ebp),%eax
 692:	89 04 24             	mov    %eax,(%esp)
 695:	e8 b7 fd ff ff       	call   451 <putc>
 69a:	eb 28                	jmp    6c4 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 69c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6a3:	00 
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	89 04 24             	mov    %eax,(%esp)
 6aa:	e8 a2 fd ff ff       	call   451 <putc>
        putc(fd, c);
 6af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b2:	0f be c0             	movsbl %al,%eax
 6b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
 6bc:	89 04 24             	mov    %eax,(%esp)
 6bf:	e8 8d fd ff ff       	call   451 <putc>
      }
      state = 0;
 6c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6cb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6cf:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d5:	01 d0                	add    %edx,%eax
 6d7:	0f b6 00             	movzbl (%eax),%eax
 6da:	84 c0                	test   %al,%al
 6dc:	0f 85 71 fe ff ff    	jne    553 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6e2:	c9                   	leave  
 6e3:	c3                   	ret    

000006e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ea:	8b 45 08             	mov    0x8(%ebp),%eax
 6ed:	83 e8 08             	sub    $0x8,%eax
 6f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f3:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 6f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6fb:	eb 24                	jmp    721 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 705:	77 12                	ja     719 <free+0x35>
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70d:	77 24                	ja     733 <free+0x4f>
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 717:	77 1a                	ja     733 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 721:	8b 45 f8             	mov    -0x8(%ebp),%eax
 724:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 727:	76 d4                	jbe    6fd <free+0x19>
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 00                	mov    (%eax),%eax
 72e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 731:	76 ca                	jbe    6fd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	8b 40 04             	mov    0x4(%eax),%eax
 739:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 740:	8b 45 f8             	mov    -0x8(%ebp),%eax
 743:	01 c2                	add    %eax,%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 00                	mov    (%eax),%eax
 74a:	39 c2                	cmp    %eax,%edx
 74c:	75 24                	jne    772 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 751:	8b 50 04             	mov    0x4(%eax),%edx
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	8b 40 04             	mov    0x4(%eax),%eax
 75c:	01 c2                	add    %eax,%edx
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 00                	mov    (%eax),%eax
 769:	8b 10                	mov    (%eax),%edx
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	89 10                	mov    %edx,(%eax)
 770:	eb 0a                	jmp    77c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 10                	mov    (%eax),%edx
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	8b 40 04             	mov    0x4(%eax),%eax
 782:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	01 d0                	add    %edx,%eax
 78e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 791:	75 20                	jne    7b3 <free+0xcf>
    p->s.size += bp->s.size;
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 50 04             	mov    0x4(%eax),%edx
 799:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	01 c2                	add    %eax,%edx
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	8b 10                	mov    (%eax),%edx
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	89 10                	mov    %edx,(%eax)
 7b1:	eb 08                	jmp    7bb <free+0xd7>
  } else
    p->s.ptr = bp;
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b9:	89 10                	mov    %edx,(%eax)
  freep = p;
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	a3 bc 0b 00 00       	mov    %eax,0xbbc
}
 7c3:	c9                   	leave  
 7c4:	c3                   	ret    

000007c5 <morecore>:

static Header*
morecore(uint nu)
{
 7c5:	55                   	push   %ebp
 7c6:	89 e5                	mov    %esp,%ebp
 7c8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7cb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7d2:	77 07                	ja     7db <morecore+0x16>
    nu = 4096;
 7d4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7db:	8b 45 08             	mov    0x8(%ebp),%eax
 7de:	c1 e0 03             	shl    $0x3,%eax
 7e1:	89 04 24             	mov    %eax,(%esp)
 7e4:	e8 08 fc ff ff       	call   3f1 <sbrk>
 7e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ec:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7f0:	75 07                	jne    7f9 <morecore+0x34>
    return 0;
 7f2:	b8 00 00 00 00       	mov    $0x0,%eax
 7f7:	eb 22                	jmp    81b <morecore+0x56>
  hp = (Header*)p;
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 802:	8b 55 08             	mov    0x8(%ebp),%edx
 805:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 808:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80b:	83 c0 08             	add    $0x8,%eax
 80e:	89 04 24             	mov    %eax,(%esp)
 811:	e8 ce fe ff ff       	call   6e4 <free>
  return freep;
 816:	a1 bc 0b 00 00       	mov    0xbbc,%eax
}
 81b:	c9                   	leave  
 81c:	c3                   	ret    

0000081d <malloc>:

void*
malloc(uint nbytes)
{
 81d:	55                   	push   %ebp
 81e:	89 e5                	mov    %esp,%ebp
 820:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 823:	8b 45 08             	mov    0x8(%ebp),%eax
 826:	83 c0 07             	add    $0x7,%eax
 829:	c1 e8 03             	shr    $0x3,%eax
 82c:	83 c0 01             	add    $0x1,%eax
 82f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 832:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 837:	89 45 f0             	mov    %eax,-0x10(%ebp)
 83a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 83e:	75 23                	jne    863 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 840:	c7 45 f0 b4 0b 00 00 	movl   $0xbb4,-0x10(%ebp)
 847:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84a:	a3 bc 0b 00 00       	mov    %eax,0xbbc
 84f:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 854:	a3 b4 0b 00 00       	mov    %eax,0xbb4
    base.s.size = 0;
 859:	c7 05 b8 0b 00 00 00 	movl   $0x0,0xbb8
 860:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 863:	8b 45 f0             	mov    -0x10(%ebp),%eax
 866:	8b 00                	mov    (%eax),%eax
 868:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8b 40 04             	mov    0x4(%eax),%eax
 871:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 874:	72 4d                	jb     8c3 <malloc+0xa6>
      if(p->s.size == nunits)
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	8b 40 04             	mov    0x4(%eax),%eax
 87c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87f:	75 0c                	jne    88d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	8b 10                	mov    (%eax),%edx
 886:	8b 45 f0             	mov    -0x10(%ebp),%eax
 889:	89 10                	mov    %edx,(%eax)
 88b:	eb 26                	jmp    8b3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	8b 40 04             	mov    0x4(%eax),%eax
 893:	2b 45 ec             	sub    -0x14(%ebp),%eax
 896:	89 c2                	mov    %eax,%edx
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 89e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a1:	8b 40 04             	mov    0x4(%eax),%eax
 8a4:	c1 e0 03             	shl    $0x3,%eax
 8a7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8b0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b6:	a3 bc 0b 00 00       	mov    %eax,0xbbc
      return (void*)(p + 1);
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	83 c0 08             	add    $0x8,%eax
 8c1:	eb 38                	jmp    8fb <malloc+0xde>
    }
    if(p == freep)
 8c3:	a1 bc 0b 00 00       	mov    0xbbc,%eax
 8c8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8cb:	75 1b                	jne    8e8 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d0:	89 04 24             	mov    %eax,(%esp)
 8d3:	e8 ed fe ff ff       	call   7c5 <morecore>
 8d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8df:	75 07                	jne    8e8 <malloc+0xcb>
        return 0;
 8e1:	b8 00 00 00 00       	mov    $0x0,%eax
 8e6:	eb 13                	jmp    8fb <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f1:	8b 00                	mov    (%eax),%eax
 8f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f6:	e9 70 ff ff ff       	jmp    86b <malloc+0x4e>
}
 8fb:	c9                   	leave  
 8fc:	c3                   	ret    

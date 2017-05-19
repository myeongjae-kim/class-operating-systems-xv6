
_test_stride:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define LIFETIME        1000        // (ticks)
#define COUNT_PERIOD    1000000     // (iteration)

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 30             	sub    $0x30,%esp
  uint i;
  int cnt = 0;
   9:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  10:	00 
  int cpu_share;
  uint start_tick;
  uint curr_tick;

  if (argc < 2) {
  11:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  15:	7f 19                	jg     30 <main+0x30>
    printf(1, "usage: sched_test_stride cpu_share(%)\n");
  17:	c7 44 24 04 e8 08 00 	movl   $0x8e8,0x4(%esp)
  1e:	00 
  1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  26:	e8 ee 04 00 00       	call   519 <printf>
    exit();
  2b:	e8 21 03 00 00       	call   351 <exit>
  }

  cpu_share = atoi(argv[1]);
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 04 24             	mov    %eax,(%esp)
  3b:	e8 7f 02 00 00       	call   2bf <atoi>
  40:	89 44 24 24          	mov    %eax,0x24(%esp)

  // Register this process to the Stride scheduler
  if (set_cpu_share(cpu_share) < 0) {
  44:	8b 44 24 24          	mov    0x24(%esp),%eax
  48:	89 04 24             	mov    %eax,(%esp)
  4b:	e8 c1 03 00 00       	call   411 <set_cpu_share>
  50:	85 c0                	test   %eax,%eax
  52:	79 19                	jns    6d <main+0x6d>
    printf(1, "cannot set cpu share\n");
  54:	c7 44 24 04 0f 09 00 	movl   $0x90f,0x4(%esp)
  5b:	00 
  5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  63:	e8 b1 04 00 00       	call   519 <printf>
    exit();
  68:	e8 e4 02 00 00       	call   351 <exit>
  }

  // Get start time
  start_tick = uptime();
  6d:	e8 77 03 00 00       	call   3e9 <uptime>
  72:	89 44 24 20          	mov    %eax,0x20(%esp)

  i = 0;
  76:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  7d:	00 
  while (1) {
    i++;
  7e:	83 44 24 2c 01       	addl   $0x1,0x2c(%esp)

    // Prevent code optimization
    __sync_synchronize();
  83:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

    if (i == COUNT_PERIOD) {
  88:	81 7c 24 2c 40 42 0f 	cmpl   $0xf4240,0x2c(%esp)
  8f:	00 
  90:	75 55                	jne    e7 <main+0xe7>
      cnt++;
  92:	83 44 24 28 01       	addl   $0x1,0x28(%esp)

      // Get current time
      curr_tick = uptime();
  97:	e8 4d 03 00 00       	call   3e9 <uptime>
  9c:	89 44 24 1c          	mov    %eax,0x1c(%esp)

      if (curr_tick - start_tick > LIFETIME) {
  a0:	8b 44 24 20          	mov    0x20(%esp),%eax
  a4:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  a8:	29 c2                	sub    %eax,%edx
  aa:	89 d0                	mov    %edx,%eax
  ac:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  b1:	76 2a                	jbe    dd <main+0xdd>
        // Terminate process
        printf(1, "STRIDE(%d%%), cnt: %d\n", cpu_share, cnt);
  b3:	8b 44 24 28          	mov    0x28(%esp),%eax
  b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  bb:	8b 44 24 24          	mov    0x24(%esp),%eax
  bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  c3:	c7 44 24 04 25 09 00 	movl   $0x925,0x4(%esp)
  ca:	00 
  cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d2:	e8 42 04 00 00       	call   519 <printf>
        break;
  d7:	90                   	nop
      }
      i = 0;
    }
  }

  exit();
  d8:	e8 74 02 00 00       	call   351 <exit>
      if (curr_tick - start_tick > LIFETIME) {
        // Terminate process
        printf(1, "STRIDE(%d%%), cnt: %d\n", cpu_share, cnt);
        break;
      }
      i = 0;
  dd:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  e4:	00 
    }
  }
  e5:	eb 97                	jmp    7e <main+0x7e>
  e7:	eb 95                	jmp    7e <main+0x7e>

000000e9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  ec:	57                   	push   %edi
  ed:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f1:	8b 55 10             	mov    0x10(%ebp),%edx
  f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  f7:	89 cb                	mov    %ecx,%ebx
  f9:	89 df                	mov    %ebx,%edi
  fb:	89 d1                	mov    %edx,%ecx
  fd:	fc                   	cld    
  fe:	f3 aa                	rep stos %al,%es:(%edi)
 100:	89 ca                	mov    %ecx,%edx
 102:	89 fb                	mov    %edi,%ebx
 104:	89 5d 08             	mov    %ebx,0x8(%ebp)
 107:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 10a:	5b                   	pop    %ebx
 10b:	5f                   	pop    %edi
 10c:	5d                   	pop    %ebp
 10d:	c3                   	ret    

0000010e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 10e:	55                   	push   %ebp
 10f:	89 e5                	mov    %esp,%ebp
 111:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 11a:	90                   	nop
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	8d 50 01             	lea    0x1(%eax),%edx
 121:	89 55 08             	mov    %edx,0x8(%ebp)
 124:	8b 55 0c             	mov    0xc(%ebp),%edx
 127:	8d 4a 01             	lea    0x1(%edx),%ecx
 12a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 12d:	0f b6 12             	movzbl (%edx),%edx
 130:	88 10                	mov    %dl,(%eax)
 132:	0f b6 00             	movzbl (%eax),%eax
 135:	84 c0                	test   %al,%al
 137:	75 e2                	jne    11b <strcpy+0xd>
    ;
  return os;
 139:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13c:	c9                   	leave  
 13d:	c3                   	ret    

0000013e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 141:	eb 08                	jmp    14b <strcmp+0xd>
    p++, q++;
 143:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 147:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	0f b6 00             	movzbl (%eax),%eax
 151:	84 c0                	test   %al,%al
 153:	74 10                	je     165 <strcmp+0x27>
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 10             	movzbl (%eax),%edx
 15b:	8b 45 0c             	mov    0xc(%ebp),%eax
 15e:	0f b6 00             	movzbl (%eax),%eax
 161:	38 c2                	cmp    %al,%dl
 163:	74 de                	je     143 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	0f b6 00             	movzbl (%eax),%eax
 16b:	0f b6 d0             	movzbl %al,%edx
 16e:	8b 45 0c             	mov    0xc(%ebp),%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	0f b6 c0             	movzbl %al,%eax
 177:	29 c2                	sub    %eax,%edx
 179:	89 d0                	mov    %edx,%eax
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    

0000017d <strlen>:

uint
strlen(char *s)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 183:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 18a:	eb 04                	jmp    190 <strlen+0x13>
 18c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 190:	8b 55 fc             	mov    -0x4(%ebp),%edx
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	01 d0                	add    %edx,%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	84 c0                	test   %al,%al
 19d:	75 ed                	jne    18c <strlen+0xf>
    ;
  return n;
 19f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1aa:	8b 45 10             	mov    0x10(%ebp),%eax
 1ad:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	89 04 24             	mov    %eax,(%esp)
 1be:	e8 26 ff ff ff       	call   e9 <stosb>
  return dst;
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c6:	c9                   	leave  
 1c7:	c3                   	ret    

000001c8 <strchr>:

char*
strchr(const char *s, char c)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	83 ec 04             	sub    $0x4,%esp
 1ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1d4:	eb 14                	jmp    1ea <strchr+0x22>
    if(*s == c)
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	0f b6 00             	movzbl (%eax),%eax
 1dc:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1df:	75 05                	jne    1e6 <strchr+0x1e>
      return (char*)s;
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	eb 13                	jmp    1f9 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	0f b6 00             	movzbl (%eax),%eax
 1f0:	84 c0                	test   %al,%al
 1f2:	75 e2                	jne    1d6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <gets>:

char*
gets(char *buf, int max)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 201:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 208:	eb 4c                	jmp    256 <gets+0x5b>
    cc = read(0, &c, 1);
 20a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 211:	00 
 212:	8d 45 ef             	lea    -0x11(%ebp),%eax
 215:	89 44 24 04          	mov    %eax,0x4(%esp)
 219:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 220:	e8 44 01 00 00       	call   369 <read>
 225:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 228:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 22c:	7f 02                	jg     230 <gets+0x35>
      break;
 22e:	eb 31                	jmp    261 <gets+0x66>
    buf[i++] = c;
 230:	8b 45 f4             	mov    -0xc(%ebp),%eax
 233:	8d 50 01             	lea    0x1(%eax),%edx
 236:	89 55 f4             	mov    %edx,-0xc(%ebp)
 239:	89 c2                	mov    %eax,%edx
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	01 c2                	add    %eax,%edx
 240:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 244:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 246:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24a:	3c 0a                	cmp    $0xa,%al
 24c:	74 13                	je     261 <gets+0x66>
 24e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 252:	3c 0d                	cmp    $0xd,%al
 254:	74 0b                	je     261 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 256:	8b 45 f4             	mov    -0xc(%ebp),%eax
 259:	83 c0 01             	add    $0x1,%eax
 25c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 25f:	7c a9                	jl     20a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 261:	8b 55 f4             	mov    -0xc(%ebp),%edx
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	01 d0                	add    %edx,%eax
 269:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26f:	c9                   	leave  
 270:	c3                   	ret    

00000271 <stat>:

int
stat(char *n, struct stat *st)
{
 271:	55                   	push   %ebp
 272:	89 e5                	mov    %esp,%ebp
 274:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 277:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 27e:	00 
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	89 04 24             	mov    %eax,(%esp)
 285:	e8 07 01 00 00       	call   391 <open>
 28a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 28d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 291:	79 07                	jns    29a <stat+0x29>
    return -1;
 293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 298:	eb 23                	jmp    2bd <stat+0x4c>
  r = fstat(fd, st);
 29a:	8b 45 0c             	mov    0xc(%ebp),%eax
 29d:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a4:	89 04 24             	mov    %eax,(%esp)
 2a7:	e8 fd 00 00 00       	call   3a9 <fstat>
 2ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b2:	89 04 24             	mov    %eax,(%esp)
 2b5:	e8 bf 00 00 00       	call   379 <close>
  return r;
 2ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2bd:	c9                   	leave  
 2be:	c3                   	ret    

000002bf <atoi>:

int
atoi(const char *s)
{
 2bf:	55                   	push   %ebp
 2c0:	89 e5                	mov    %esp,%ebp
 2c2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2cc:	eb 25                	jmp    2f3 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d1:	89 d0                	mov    %edx,%eax
 2d3:	c1 e0 02             	shl    $0x2,%eax
 2d6:	01 d0                	add    %edx,%eax
 2d8:	01 c0                	add    %eax,%eax
 2da:	89 c1                	mov    %eax,%ecx
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	8d 50 01             	lea    0x1(%eax),%edx
 2e2:	89 55 08             	mov    %edx,0x8(%ebp)
 2e5:	0f b6 00             	movzbl (%eax),%eax
 2e8:	0f be c0             	movsbl %al,%eax
 2eb:	01 c8                	add    %ecx,%eax
 2ed:	83 e8 30             	sub    $0x30,%eax
 2f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	0f b6 00             	movzbl (%eax),%eax
 2f9:	3c 2f                	cmp    $0x2f,%al
 2fb:	7e 0a                	jle    307 <atoi+0x48>
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	0f b6 00             	movzbl (%eax),%eax
 303:	3c 39                	cmp    $0x39,%al
 305:	7e c7                	jle    2ce <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 307:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 30a:	c9                   	leave  
 30b:	c3                   	ret    

0000030c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 30c:	55                   	push   %ebp
 30d:	89 e5                	mov    %esp,%ebp
 30f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 318:	8b 45 0c             	mov    0xc(%ebp),%eax
 31b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 31e:	eb 17                	jmp    337 <memmove+0x2b>
    *dst++ = *src++;
 320:	8b 45 fc             	mov    -0x4(%ebp),%eax
 323:	8d 50 01             	lea    0x1(%eax),%edx
 326:	89 55 fc             	mov    %edx,-0x4(%ebp)
 329:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32c:	8d 4a 01             	lea    0x1(%edx),%ecx
 32f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 332:	0f b6 12             	movzbl (%edx),%edx
 335:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 337:	8b 45 10             	mov    0x10(%ebp),%eax
 33a:	8d 50 ff             	lea    -0x1(%eax),%edx
 33d:	89 55 10             	mov    %edx,0x10(%ebp)
 340:	85 c0                	test   %eax,%eax
 342:	7f dc                	jg     320 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 344:	8b 45 08             	mov    0x8(%ebp),%eax
}
 347:	c9                   	leave  
 348:	c3                   	ret    

00000349 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 349:	b8 01 00 00 00       	mov    $0x1,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <exit>:
SYSCALL(exit)
 351:	b8 02 00 00 00       	mov    $0x2,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <wait>:
SYSCALL(wait)
 359:	b8 03 00 00 00       	mov    $0x3,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <pipe>:
SYSCALL(pipe)
 361:	b8 04 00 00 00       	mov    $0x4,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <read>:
SYSCALL(read)
 369:	b8 05 00 00 00       	mov    $0x5,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <write>:
SYSCALL(write)
 371:	b8 10 00 00 00       	mov    $0x10,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <close>:
SYSCALL(close)
 379:	b8 15 00 00 00       	mov    $0x15,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <kill>:
SYSCALL(kill)
 381:	b8 06 00 00 00       	mov    $0x6,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <exec>:
SYSCALL(exec)
 389:	b8 07 00 00 00       	mov    $0x7,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <open>:
SYSCALL(open)
 391:	b8 0f 00 00 00       	mov    $0xf,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <mknod>:
SYSCALL(mknod)
 399:	b8 11 00 00 00       	mov    $0x11,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <unlink>:
SYSCALL(unlink)
 3a1:	b8 12 00 00 00       	mov    $0x12,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <fstat>:
SYSCALL(fstat)
 3a9:	b8 08 00 00 00       	mov    $0x8,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <link>:
SYSCALL(link)
 3b1:	b8 13 00 00 00       	mov    $0x13,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <mkdir>:
SYSCALL(mkdir)
 3b9:	b8 14 00 00 00       	mov    $0x14,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <chdir>:
SYSCALL(chdir)
 3c1:	b8 09 00 00 00       	mov    $0x9,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <dup>:
SYSCALL(dup)
 3c9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <getpid>:
SYSCALL(getpid)
 3d1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <sbrk>:
SYSCALL(sbrk)
 3d9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <sleep>:
SYSCALL(sleep)
 3e1:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <uptime>:
SYSCALL(uptime)
 3e9:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <my_syscall>:
SYSCALL(my_syscall)
 3f1:	b8 16 00 00 00       	mov    $0x16,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <getppid>:
SYSCALL(getppid)
 3f9:	b8 17 00 00 00       	mov    $0x17,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <yield>:
SYSCALL(yield)
 401:	b8 18 00 00 00       	mov    $0x18,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <getlev>:
SYSCALL(getlev)
 409:	b8 19 00 00 00       	mov    $0x19,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <set_cpu_share>:
SYSCALL(set_cpu_share)
 411:	b8 1a 00 00 00       	mov    $0x1a,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <thread_create>:
SYSCALL(thread_create)
 419:	b8 1b 00 00 00       	mov    $0x1b,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <thread_exit>:
SYSCALL(thread_exit)
 421:	b8 1c 00 00 00       	mov    $0x1c,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <thread_join>:
SYSCALL(thread_join)
 429:	b8 1d 00 00 00       	mov    $0x1d,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <gettid>:
SYSCALL(gettid)
 431:	b8 1e 00 00 00       	mov    $0x1e,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 439:	55                   	push   %ebp
 43a:	89 e5                	mov    %esp,%ebp
 43c:	83 ec 18             	sub    $0x18,%esp
 43f:	8b 45 0c             	mov    0xc(%ebp),%eax
 442:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 445:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 44c:	00 
 44d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 450:	89 44 24 04          	mov    %eax,0x4(%esp)
 454:	8b 45 08             	mov    0x8(%ebp),%eax
 457:	89 04 24             	mov    %eax,(%esp)
 45a:	e8 12 ff ff ff       	call   371 <write>
}
 45f:	c9                   	leave  
 460:	c3                   	ret    

00000461 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	56                   	push   %esi
 465:	53                   	push   %ebx
 466:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 469:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 470:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 474:	74 17                	je     48d <printint+0x2c>
 476:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 47a:	79 11                	jns    48d <printint+0x2c>
    neg = 1;
 47c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 483:	8b 45 0c             	mov    0xc(%ebp),%eax
 486:	f7 d8                	neg    %eax
 488:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48b:	eb 06                	jmp    493 <printint+0x32>
  } else {
    x = xx;
 48d:	8b 45 0c             	mov    0xc(%ebp),%eax
 490:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 493:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 49a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 49d:	8d 41 01             	lea    0x1(%ecx),%eax
 4a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a9:	ba 00 00 00 00       	mov    $0x0,%edx
 4ae:	f7 f3                	div    %ebx
 4b0:	89 d0                	mov    %edx,%eax
 4b2:	0f b6 80 88 0b 00 00 	movzbl 0xb88(%eax),%eax
 4b9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4bd:	8b 75 10             	mov    0x10(%ebp),%esi
 4c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c3:	ba 00 00 00 00       	mov    $0x0,%edx
 4c8:	f7 f6                	div    %esi
 4ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d1:	75 c7                	jne    49a <printint+0x39>
  if(neg)
 4d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d7:	74 10                	je     4e9 <printint+0x88>
    buf[i++] = '-';
 4d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4dc:	8d 50 01             	lea    0x1(%eax),%edx
 4df:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4e2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4e7:	eb 1f                	jmp    508 <printint+0xa7>
 4e9:	eb 1d                	jmp    508 <printint+0xa7>
    putc(fd, buf[i]);
 4eb:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f1:	01 d0                	add    %edx,%eax
 4f3:	0f b6 00             	movzbl (%eax),%eax
 4f6:	0f be c0             	movsbl %al,%eax
 4f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fd:	8b 45 08             	mov    0x8(%ebp),%eax
 500:	89 04 24             	mov    %eax,(%esp)
 503:	e8 31 ff ff ff       	call   439 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 508:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 50c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 510:	79 d9                	jns    4eb <printint+0x8a>
    putc(fd, buf[i]);
}
 512:	83 c4 30             	add    $0x30,%esp
 515:	5b                   	pop    %ebx
 516:	5e                   	pop    %esi
 517:	5d                   	pop    %ebp
 518:	c3                   	ret    

00000519 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 519:	55                   	push   %ebp
 51a:	89 e5                	mov    %esp,%ebp
 51c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 51f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 526:	8d 45 0c             	lea    0xc(%ebp),%eax
 529:	83 c0 04             	add    $0x4,%eax
 52c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 52f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 536:	e9 7c 01 00 00       	jmp    6b7 <printf+0x19e>
    c = fmt[i] & 0xff;
 53b:	8b 55 0c             	mov    0xc(%ebp),%edx
 53e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 541:	01 d0                	add    %edx,%eax
 543:	0f b6 00             	movzbl (%eax),%eax
 546:	0f be c0             	movsbl %al,%eax
 549:	25 ff 00 00 00       	and    $0xff,%eax
 54e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 551:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 555:	75 2c                	jne    583 <printf+0x6a>
      if(c == '%'){
 557:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 55b:	75 0c                	jne    569 <printf+0x50>
        state = '%';
 55d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 564:	e9 4a 01 00 00       	jmp    6b3 <printf+0x19a>
      } else {
        putc(fd, c);
 569:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56c:	0f be c0             	movsbl %al,%eax
 56f:	89 44 24 04          	mov    %eax,0x4(%esp)
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	89 04 24             	mov    %eax,(%esp)
 579:	e8 bb fe ff ff       	call   439 <putc>
 57e:	e9 30 01 00 00       	jmp    6b3 <printf+0x19a>
      }
    } else if(state == '%'){
 583:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 587:	0f 85 26 01 00 00    	jne    6b3 <printf+0x19a>
      if(c == 'd'){
 58d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 591:	75 2d                	jne    5c0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 593:	8b 45 e8             	mov    -0x18(%ebp),%eax
 596:	8b 00                	mov    (%eax),%eax
 598:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 59f:	00 
 5a0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5a7:	00 
 5a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ac:	8b 45 08             	mov    0x8(%ebp),%eax
 5af:	89 04 24             	mov    %eax,(%esp)
 5b2:	e8 aa fe ff ff       	call   461 <printint>
        ap++;
 5b7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bb:	e9 ec 00 00 00       	jmp    6ac <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5c0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5c4:	74 06                	je     5cc <printf+0xb3>
 5c6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ca:	75 2d                	jne    5f9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cf:	8b 00                	mov    (%eax),%eax
 5d1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5d8:	00 
 5d9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5e0:	00 
 5e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	89 04 24             	mov    %eax,(%esp)
 5eb:	e8 71 fe ff ff       	call   461 <printint>
        ap++;
 5f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f4:	e9 b3 00 00 00       	jmp    6ac <printf+0x193>
      } else if(c == 's'){
 5f9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5fd:	75 45                	jne    644 <printf+0x12b>
        s = (char*)*ap;
 5ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 602:	8b 00                	mov    (%eax),%eax
 604:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 607:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 60b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60f:	75 09                	jne    61a <printf+0x101>
          s = "(null)";
 611:	c7 45 f4 3c 09 00 00 	movl   $0x93c,-0xc(%ebp)
        while(*s != 0){
 618:	eb 1e                	jmp    638 <printf+0x11f>
 61a:	eb 1c                	jmp    638 <printf+0x11f>
          putc(fd, *s);
 61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61f:	0f b6 00             	movzbl (%eax),%eax
 622:	0f be c0             	movsbl %al,%eax
 625:	89 44 24 04          	mov    %eax,0x4(%esp)
 629:	8b 45 08             	mov    0x8(%ebp),%eax
 62c:	89 04 24             	mov    %eax,(%esp)
 62f:	e8 05 fe ff ff       	call   439 <putc>
          s++;
 634:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 638:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63b:	0f b6 00             	movzbl (%eax),%eax
 63e:	84 c0                	test   %al,%al
 640:	75 da                	jne    61c <printf+0x103>
 642:	eb 68                	jmp    6ac <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 644:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 648:	75 1d                	jne    667 <printf+0x14e>
        putc(fd, *ap);
 64a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	0f be c0             	movsbl %al,%eax
 652:	89 44 24 04          	mov    %eax,0x4(%esp)
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	89 04 24             	mov    %eax,(%esp)
 65c:	e8 d8 fd ff ff       	call   439 <putc>
        ap++;
 661:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 665:	eb 45                	jmp    6ac <printf+0x193>
      } else if(c == '%'){
 667:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66b:	75 17                	jne    684 <printf+0x16b>
        putc(fd, c);
 66d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 670:	0f be c0             	movsbl %al,%eax
 673:	89 44 24 04          	mov    %eax,0x4(%esp)
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	89 04 24             	mov    %eax,(%esp)
 67d:	e8 b7 fd ff ff       	call   439 <putc>
 682:	eb 28                	jmp    6ac <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 684:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 68b:	00 
 68c:	8b 45 08             	mov    0x8(%ebp),%eax
 68f:	89 04 24             	mov    %eax,(%esp)
 692:	e8 a2 fd ff ff       	call   439 <putc>
        putc(fd, c);
 697:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69a:	0f be c0             	movsbl %al,%eax
 69d:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a1:	8b 45 08             	mov    0x8(%ebp),%eax
 6a4:	89 04 24             	mov    %eax,(%esp)
 6a7:	e8 8d fd ff ff       	call   439 <putc>
      }
      state = 0;
 6ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6b7:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bd:	01 d0                	add    %edx,%eax
 6bf:	0f b6 00             	movzbl (%eax),%eax
 6c2:	84 c0                	test   %al,%al
 6c4:	0f 85 71 fe ff ff    	jne    53b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6ca:	c9                   	leave  
 6cb:	c3                   	ret    

000006cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d2:	8b 45 08             	mov    0x8(%ebp),%eax
 6d5:	83 e8 08             	sub    $0x8,%eax
 6d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6db:	a1 a4 0b 00 00       	mov    0xba4,%eax
 6e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e3:	eb 24                	jmp    709 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ed:	77 12                	ja     701 <free+0x35>
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f5:	77 24                	ja     71b <free+0x4f>
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ff:	77 1a                	ja     71b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	89 45 fc             	mov    %eax,-0x4(%ebp)
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70f:	76 d4                	jbe    6e5 <free+0x19>
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 719:	76 ca                	jbe    6e5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	01 c2                	add    %eax,%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	39 c2                	cmp    %eax,%edx
 734:	75 24                	jne    75a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	8b 50 04             	mov    0x4(%eax),%edx
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	8b 40 04             	mov    0x4(%eax),%eax
 744:	01 c2                	add    %eax,%edx
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	8b 10                	mov    (%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	89 10                	mov    %edx,(%eax)
 758:	eb 0a                	jmp    764 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 10                	mov    (%eax),%edx
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 40 04             	mov    0x4(%eax),%eax
 76a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	01 d0                	add    %edx,%eax
 776:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 779:	75 20                	jne    79b <free+0xcf>
    p->s.size += bp->s.size;
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 50 04             	mov    0x4(%eax),%edx
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	01 c2                	add    %eax,%edx
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 08                	jmp    7a3 <free+0xd7>
  } else
    p->s.ptr = bp;
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	a3 a4 0b 00 00       	mov    %eax,0xba4
}
 7ab:	c9                   	leave  
 7ac:	c3                   	ret    

000007ad <morecore>:

static Header*
morecore(uint nu)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7ba:	77 07                	ja     7c3 <morecore+0x16>
    nu = 4096;
 7bc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	c1 e0 03             	shl    $0x3,%eax
 7c9:	89 04 24             	mov    %eax,(%esp)
 7cc:	e8 08 fc ff ff       	call   3d9 <sbrk>
 7d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7d8:	75 07                	jne    7e1 <morecore+0x34>
    return 0;
 7da:	b8 00 00 00 00       	mov    $0x0,%eax
 7df:	eb 22                	jmp    803 <morecore+0x56>
  hp = (Header*)p;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ea:	8b 55 08             	mov    0x8(%ebp),%edx
 7ed:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	83 c0 08             	add    $0x8,%eax
 7f6:	89 04 24             	mov    %eax,(%esp)
 7f9:	e8 ce fe ff ff       	call   6cc <free>
  return freep;
 7fe:	a1 a4 0b 00 00       	mov    0xba4,%eax
}
 803:	c9                   	leave  
 804:	c3                   	ret    

00000805 <malloc>:

void*
malloc(uint nbytes)
{
 805:	55                   	push   %ebp
 806:	89 e5                	mov    %esp,%ebp
 808:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80b:	8b 45 08             	mov    0x8(%ebp),%eax
 80e:	83 c0 07             	add    $0x7,%eax
 811:	c1 e8 03             	shr    $0x3,%eax
 814:	83 c0 01             	add    $0x1,%eax
 817:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 81a:	a1 a4 0b 00 00       	mov    0xba4,%eax
 81f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 822:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 826:	75 23                	jne    84b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 828:	c7 45 f0 9c 0b 00 00 	movl   $0xb9c,-0x10(%ebp)
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	a3 a4 0b 00 00       	mov    %eax,0xba4
 837:	a1 a4 0b 00 00       	mov    0xba4,%eax
 83c:	a3 9c 0b 00 00       	mov    %eax,0xb9c
    base.s.size = 0;
 841:	c7 05 a0 0b 00 00 00 	movl   $0x0,0xba0
 848:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84e:	8b 00                	mov    (%eax),%eax
 850:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 40 04             	mov    0x4(%eax),%eax
 859:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85c:	72 4d                	jb     8ab <malloc+0xa6>
      if(p->s.size == nunits)
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	8b 40 04             	mov    0x4(%eax),%eax
 864:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 867:	75 0c                	jne    875 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 10                	mov    (%eax),%edx
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	89 10                	mov    %edx,(%eax)
 873:	eb 26                	jmp    89b <malloc+0x96>
      else {
        p->s.size -= nunits;
 875:	8b 45 f4             	mov    -0xc(%ebp),%eax
 878:	8b 40 04             	mov    0x4(%eax),%eax
 87b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 87e:	89 c2                	mov    %eax,%edx
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	8b 40 04             	mov    0x4(%eax),%eax
 88c:	c1 e0 03             	shl    $0x3,%eax
 88f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	8b 55 ec             	mov    -0x14(%ebp),%edx
 898:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 89b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89e:	a3 a4 0b 00 00       	mov    %eax,0xba4
      return (void*)(p + 1);
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	83 c0 08             	add    $0x8,%eax
 8a9:	eb 38                	jmp    8e3 <malloc+0xde>
    }
    if(p == freep)
 8ab:	a1 a4 0b 00 00       	mov    0xba4,%eax
 8b0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b3:	75 1b                	jne    8d0 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8b8:	89 04 24             	mov    %eax,(%esp)
 8bb:	e8 ed fe ff ff       	call   7ad <morecore>
 8c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c7:	75 07                	jne    8d0 <malloc+0xcb>
        return 0;
 8c9:	b8 00 00 00 00       	mov    $0x0,%eax
 8ce:	eb 13                	jmp    8e3 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8de:	e9 70 ff ff ff       	jmp    853 <malloc+0x4e>
}
 8e3:	c9                   	leave  
 8e4:	c3                   	ret    

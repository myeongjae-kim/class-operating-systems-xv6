
_test_mlfq:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// Number of level(priority) of MLFQ scheduler
#define MLFQ_LEVEL      3

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 40             	sub    $0x40,%esp
    uint i;
    int cnt_level[MLFQ_LEVEL] = {0, 0, 0};
   a:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  11:	00 
  12:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  19:	00 
  1a:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
  21:	00 
    int do_yield;
    int curr_mlfq_level;

    if (argc < 2) {
  22:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  26:	7f 19                	jg     41 <main+0x41>
        printf(1, "usage: sched_test_mlfq do_yield_or_not(0|1)\n");
  28:	c7 44 24 04 0c 09 00 	movl   $0x90c,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 04 05 00 00       	call   540 <printf>
        exit();
  3c:	e8 37 03 00 00       	call   378 <exit>
    }

    do_yield = atoi(argv[1]);
  41:	8b 45 0c             	mov    0xc(%ebp),%eax
  44:	83 c0 04             	add    $0x4,%eax
  47:	8b 00                	mov    (%eax),%eax
  49:	89 04 24             	mov    %eax,(%esp)
  4c:	e8 95 02 00 00       	call   2e6 <atoi>
  51:	89 44 24 38          	mov    %eax,0x38(%esp)

    i = 0;
  55:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%esp)
  5c:	00 
    while (1) {
        i++;
  5d:	83 44 24 3c 01       	addl   $0x1,0x3c(%esp)
        
        // Prevent code optimization
        __sync_synchronize();
  62:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

        if (i % YIELD_PERIOD == 0) {
  67:	8b 4c 24 3c          	mov    0x3c(%esp),%ecx
  6b:	ba 59 17 b7 d1       	mov    $0xd1b71759,%edx
  70:	89 c8                	mov    %ecx,%eax
  72:	f7 e2                	mul    %edx
  74:	89 d0                	mov    %edx,%eax
  76:	c1 e8 0d             	shr    $0xd,%eax
  79:	69 c0 10 27 00 00    	imul   $0x2710,%eax,%eax
  7f:	29 c1                	sub    %eax,%ecx
  81:	89 c8                	mov    %ecx,%eax
  83:	85 c0                	test   %eax,%eax
  85:	0f 85 80 00 00 00    	jne    10b <main+0x10b>
            // Get current MLFQ level(priority) of this process
            curr_mlfq_level = getlev();
  8b:	e8 a0 03 00 00       	call   430 <getlev>
  90:	89 44 24 34          	mov    %eax,0x34(%esp)
            cnt_level[curr_mlfq_level]++;
  94:	8b 44 24 34          	mov    0x34(%esp),%eax
  98:	8b 44 84 28          	mov    0x28(%esp,%eax,4),%eax
  9c:	8d 50 01             	lea    0x1(%eax),%edx
  9f:	8b 44 24 34          	mov    0x34(%esp),%eax
  a3:	89 54 84 28          	mov    %edx,0x28(%esp,%eax,4)

            if (i > LIFETIME) {
  a7:	81 7c 24 3c 00 c2 eb 	cmpl   $0xbebc200,0x3c(%esp)
  ae:	0b 
  af:	76 49                	jbe    fa <main+0xfa>
                printf(1, "MLFQ(%s), lev[0]: %d, lev[1]: %d, lev[2]: %d\n",
  b1:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  b5:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
  b9:	8b 54 24 28          	mov    0x28(%esp),%edx
  bd:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
  c2:	75 07                	jne    cb <main+0xcb>
  c4:	b8 39 09 00 00       	mov    $0x939,%eax
  c9:	eb 05                	jmp    d0 <main+0xd0>
  cb:	b8 41 09 00 00       	mov    $0x941,%eax
  d0:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  d4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  d8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  e0:	c7 44 24 04 48 09 00 	movl   $0x948,0x4(%esp)
  e7:	00 
  e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ef:	e8 4c 04 00 00       	call   540 <printf>
                        do_yield==0 ? "compute" : "yield",
                        cnt_level[0], cnt_level[1], cnt_level[2]);
                break;
  f4:	90                   	nop
                yield();
            }
        }
    }

    exit();
  f5:	e8 7e 02 00 00       	call   378 <exit>
                        do_yield==0 ? "compute" : "yield",
                        cnt_level[0], cnt_level[1], cnt_level[2]);
                break;
            }

            if (do_yield) {
  fa:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
  ff:	74 0a                	je     10b <main+0x10b>
                // Yield process itself, not by timer interrupt
                yield();
 101:	e8 22 03 00 00       	call   428 <yield>
            }
        }
    }
 106:	e9 52 ff ff ff       	jmp    5d <main+0x5d>
 10b:	e9 4d ff ff ff       	jmp    5d <main+0x5d>

00000110 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 115:	8b 4d 08             	mov    0x8(%ebp),%ecx
 118:	8b 55 10             	mov    0x10(%ebp),%edx
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	89 cb                	mov    %ecx,%ebx
 120:	89 df                	mov    %ebx,%edi
 122:	89 d1                	mov    %edx,%ecx
 124:	fc                   	cld    
 125:	f3 aa                	rep stos %al,%es:(%edi)
 127:	89 ca                	mov    %ecx,%edx
 129:	89 fb                	mov    %edi,%ebx
 12b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	8d 50 01             	lea    0x1(%eax),%edx
 148:	89 55 08             	mov    %edx,0x8(%ebp)
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 4a 01             	lea    0x1(%edx),%ecx
 151:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c0             	movzbl %al,%eax
 19e:	29 c2                	sub    %eax,%edx
 1a0:	89 d0                	mov    %edx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
 1ce:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d1:	8b 45 10             	mov    0x10(%ebp),%eax
 1d4:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	89 44 24 04          	mov    %eax,0x4(%esp)
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	89 04 24             	mov    %eax,(%esp)
 1e5:	e8 26 ff ff ff       	call   110 <stosb>
  return dst;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <strchr>:

char*
strchr(const char *s, char c)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 04             	sub    $0x4,%esp
 1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fb:	eb 14                	jmp    211 <strchr+0x22>
    if(*s == c)
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	0f b6 00             	movzbl (%eax),%eax
 203:	3a 45 fc             	cmp    -0x4(%ebp),%al
 206:	75 05                	jne    20d <strchr+0x1e>
      return (char*)s;
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	eb 13                	jmp    220 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 20d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	0f b6 00             	movzbl (%eax),%eax
 217:	84 c0                	test   %al,%al
 219:	75 e2                	jne    1fd <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 220:	c9                   	leave  
 221:	c3                   	ret    

00000222 <gets>:

char*
gets(char *buf, int max)
{
 222:	55                   	push   %ebp
 223:	89 e5                	mov    %esp,%ebp
 225:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22f:	eb 4c                	jmp    27d <gets+0x5b>
    cc = read(0, &c, 1);
 231:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 238:	00 
 239:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23c:	89 44 24 04          	mov    %eax,0x4(%esp)
 240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 247:	e8 44 01 00 00       	call   390 <read>
 24c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 253:	7f 02                	jg     257 <gets+0x35>
      break;
 255:	eb 31                	jmp    288 <gets+0x66>
    buf[i++] = c;
 257:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25a:	8d 50 01             	lea    0x1(%eax),%edx
 25d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 260:	89 c2                	mov    %eax,%edx
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	01 c2                	add    %eax,%edx
 267:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 26d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 271:	3c 0a                	cmp    $0xa,%al
 273:	74 13                	je     288 <gets+0x66>
 275:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 279:	3c 0d                	cmp    $0xd,%al
 27b:	74 0b                	je     288 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 280:	83 c0 01             	add    $0x1,%eax
 283:	3b 45 0c             	cmp    0xc(%ebp),%eax
 286:	7c a9                	jl     231 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 288:	8b 55 f4             	mov    -0xc(%ebp),%edx
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	01 d0                	add    %edx,%eax
 290:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 293:	8b 45 08             	mov    0x8(%ebp),%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <stat>:

int
stat(char *n, struct stat *st)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a5:	00 
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	89 04 24             	mov    %eax,(%esp)
 2ac:	e8 07 01 00 00       	call   3b8 <open>
 2b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b8:	79 07                	jns    2c1 <stat+0x29>
    return -1;
 2ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2bf:	eb 23                	jmp    2e4 <stat+0x4c>
  r = fstat(fd, st);
 2c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cb:	89 04 24             	mov    %eax,(%esp)
 2ce:	e8 fd 00 00 00       	call   3d0 <fstat>
 2d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d9:	89 04 24             	mov    %eax,(%esp)
 2dc:	e8 bf 00 00 00       	call   3a0 <close>
  return r;
 2e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <atoi>:

int
atoi(const char *s)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f3:	eb 25                	jmp    31a <atoi+0x34>
    n = n*10 + *s++ - '0';
 2f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f8:	89 d0                	mov    %edx,%eax
 2fa:	c1 e0 02             	shl    $0x2,%eax
 2fd:	01 d0                	add    %edx,%eax
 2ff:	01 c0                	add    %eax,%eax
 301:	89 c1                	mov    %eax,%ecx
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	8d 50 01             	lea    0x1(%eax),%edx
 309:	89 55 08             	mov    %edx,0x8(%ebp)
 30c:	0f b6 00             	movzbl (%eax),%eax
 30f:	0f be c0             	movsbl %al,%eax
 312:	01 c8                	add    %ecx,%eax
 314:	83 e8 30             	sub    $0x30,%eax
 317:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
 31d:	0f b6 00             	movzbl (%eax),%eax
 320:	3c 2f                	cmp    $0x2f,%al
 322:	7e 0a                	jle    32e <atoi+0x48>
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	0f b6 00             	movzbl (%eax),%eax
 32a:	3c 39                	cmp    $0x39,%al
 32c:	7e c7                	jle    2f5 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 32e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 331:	c9                   	leave  
 332:	c3                   	ret    

00000333 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 333:	55                   	push   %ebp
 334:	89 e5                	mov    %esp,%ebp
 336:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 339:	8b 45 08             	mov    0x8(%ebp),%eax
 33c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 33f:	8b 45 0c             	mov    0xc(%ebp),%eax
 342:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 345:	eb 17                	jmp    35e <memmove+0x2b>
    *dst++ = *src++;
 347:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34a:	8d 50 01             	lea    0x1(%eax),%edx
 34d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 350:	8b 55 f8             	mov    -0x8(%ebp),%edx
 353:	8d 4a 01             	lea    0x1(%edx),%ecx
 356:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 359:	0f b6 12             	movzbl (%edx),%edx
 35c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35e:	8b 45 10             	mov    0x10(%ebp),%eax
 361:	8d 50 ff             	lea    -0x1(%eax),%edx
 364:	89 55 10             	mov    %edx,0x10(%ebp)
 367:	85 c0                	test   %eax,%eax
 369:	7f dc                	jg     347 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36e:	c9                   	leave  
 36f:	c3                   	ret    

00000370 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 370:	b8 01 00 00 00       	mov    $0x1,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <exit>:
SYSCALL(exit)
 378:	b8 02 00 00 00       	mov    $0x2,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <wait>:
SYSCALL(wait)
 380:	b8 03 00 00 00       	mov    $0x3,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <pipe>:
SYSCALL(pipe)
 388:	b8 04 00 00 00       	mov    $0x4,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <read>:
SYSCALL(read)
 390:	b8 05 00 00 00       	mov    $0x5,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <write>:
SYSCALL(write)
 398:	b8 10 00 00 00       	mov    $0x10,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <close>:
SYSCALL(close)
 3a0:	b8 15 00 00 00       	mov    $0x15,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <kill>:
SYSCALL(kill)
 3a8:	b8 06 00 00 00       	mov    $0x6,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <exec>:
SYSCALL(exec)
 3b0:	b8 07 00 00 00       	mov    $0x7,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <open>:
SYSCALL(open)
 3b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mknod>:
SYSCALL(mknod)
 3c0:	b8 11 00 00 00       	mov    $0x11,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <unlink>:
SYSCALL(unlink)
 3c8:	b8 12 00 00 00       	mov    $0x12,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <fstat>:
SYSCALL(fstat)
 3d0:	b8 08 00 00 00       	mov    $0x8,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <link>:
SYSCALL(link)
 3d8:	b8 13 00 00 00       	mov    $0x13,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <mkdir>:
SYSCALL(mkdir)
 3e0:	b8 14 00 00 00       	mov    $0x14,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <chdir>:
SYSCALL(chdir)
 3e8:	b8 09 00 00 00       	mov    $0x9,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <dup>:
SYSCALL(dup)
 3f0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <getpid>:
SYSCALL(getpid)
 3f8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <sbrk>:
SYSCALL(sbrk)
 400:	b8 0c 00 00 00       	mov    $0xc,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <sleep>:
SYSCALL(sleep)
 408:	b8 0d 00 00 00       	mov    $0xd,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <uptime>:
SYSCALL(uptime)
 410:	b8 0e 00 00 00       	mov    $0xe,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <my_syscall>:
SYSCALL(my_syscall)
 418:	b8 16 00 00 00       	mov    $0x16,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <getppid>:
SYSCALL(getppid)
 420:	b8 17 00 00 00       	mov    $0x17,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <yield>:
SYSCALL(yield)
 428:	b8 18 00 00 00       	mov    $0x18,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <getlev>:
SYSCALL(getlev)
 430:	b8 19 00 00 00       	mov    $0x19,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <set_cpu_share>:
SYSCALL(set_cpu_share)
 438:	b8 1a 00 00 00       	mov    $0x1a,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <thread_create>:
SYSCALL(thread_create)
 440:	b8 1b 00 00 00       	mov    $0x1b,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <thread_exit>:
SYSCALL(thread_exit)
 448:	b8 1c 00 00 00       	mov    $0x1c,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <thread_join>:
SYSCALL(thread_join)
 450:	b8 1d 00 00 00       	mov    $0x1d,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <gettid>:
SYSCALL(gettid)
 458:	b8 1e 00 00 00       	mov    $0x1e,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	83 ec 18             	sub    $0x18,%esp
 466:	8b 45 0c             	mov    0xc(%ebp),%eax
 469:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 46c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 473:	00 
 474:	8d 45 f4             	lea    -0xc(%ebp),%eax
 477:	89 44 24 04          	mov    %eax,0x4(%esp)
 47b:	8b 45 08             	mov    0x8(%ebp),%eax
 47e:	89 04 24             	mov    %eax,(%esp)
 481:	e8 12 ff ff ff       	call   398 <write>
}
 486:	c9                   	leave  
 487:	c3                   	ret    

00000488 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 488:	55                   	push   %ebp
 489:	89 e5                	mov    %esp,%ebp
 48b:	56                   	push   %esi
 48c:	53                   	push   %ebx
 48d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 490:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 497:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 49b:	74 17                	je     4b4 <printint+0x2c>
 49d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a1:	79 11                	jns    4b4 <printint+0x2c>
    neg = 1;
 4a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ad:	f7 d8                	neg    %eax
 4af:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b2:	eb 06                	jmp    4ba <printint+0x32>
  } else {
    x = xx;
 4b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4c4:	8d 41 01             	lea    0x1(%ecx),%eax
 4c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d0:	ba 00 00 00 00       	mov    $0x0,%edx
 4d5:	f7 f3                	div    %ebx
 4d7:	89 d0                	mov    %edx,%eax
 4d9:	0f b6 80 c4 0b 00 00 	movzbl 0xbc4(%eax),%eax
 4e0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4e4:	8b 75 10             	mov    0x10(%ebp),%esi
 4e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ea:	ba 00 00 00 00       	mov    $0x0,%edx
 4ef:	f7 f6                	div    %esi
 4f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f8:	75 c7                	jne    4c1 <printint+0x39>
  if(neg)
 4fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fe:	74 10                	je     510 <printint+0x88>
    buf[i++] = '-';
 500:	8b 45 f4             	mov    -0xc(%ebp),%eax
 503:	8d 50 01             	lea    0x1(%eax),%edx
 506:	89 55 f4             	mov    %edx,-0xc(%ebp)
 509:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 50e:	eb 1f                	jmp    52f <printint+0xa7>
 510:	eb 1d                	jmp    52f <printint+0xa7>
    putc(fd, buf[i]);
 512:	8d 55 dc             	lea    -0x24(%ebp),%edx
 515:	8b 45 f4             	mov    -0xc(%ebp),%eax
 518:	01 d0                	add    %edx,%eax
 51a:	0f b6 00             	movzbl (%eax),%eax
 51d:	0f be c0             	movsbl %al,%eax
 520:	89 44 24 04          	mov    %eax,0x4(%esp)
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	89 04 24             	mov    %eax,(%esp)
 52a:	e8 31 ff ff ff       	call   460 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 52f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 537:	79 d9                	jns    512 <printint+0x8a>
    putc(fd, buf[i]);
}
 539:	83 c4 30             	add    $0x30,%esp
 53c:	5b                   	pop    %ebx
 53d:	5e                   	pop    %esi
 53e:	5d                   	pop    %ebp
 53f:	c3                   	ret    

00000540 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 546:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 54d:	8d 45 0c             	lea    0xc(%ebp),%eax
 550:	83 c0 04             	add    $0x4,%eax
 553:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 556:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 55d:	e9 7c 01 00 00       	jmp    6de <printf+0x19e>
    c = fmt[i] & 0xff;
 562:	8b 55 0c             	mov    0xc(%ebp),%edx
 565:	8b 45 f0             	mov    -0x10(%ebp),%eax
 568:	01 d0                	add    %edx,%eax
 56a:	0f b6 00             	movzbl (%eax),%eax
 56d:	0f be c0             	movsbl %al,%eax
 570:	25 ff 00 00 00       	and    $0xff,%eax
 575:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 578:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 57c:	75 2c                	jne    5aa <printf+0x6a>
      if(c == '%'){
 57e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 582:	75 0c                	jne    590 <printf+0x50>
        state = '%';
 584:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 58b:	e9 4a 01 00 00       	jmp    6da <printf+0x19a>
      } else {
        putc(fd, c);
 590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 593:	0f be c0             	movsbl %al,%eax
 596:	89 44 24 04          	mov    %eax,0x4(%esp)
 59a:	8b 45 08             	mov    0x8(%ebp),%eax
 59d:	89 04 24             	mov    %eax,(%esp)
 5a0:	e8 bb fe ff ff       	call   460 <putc>
 5a5:	e9 30 01 00 00       	jmp    6da <printf+0x19a>
      }
    } else if(state == '%'){
 5aa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ae:	0f 85 26 01 00 00    	jne    6da <printf+0x19a>
      if(c == 'd'){
 5b4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b8:	75 2d                	jne    5e7 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bd:	8b 00                	mov    (%eax),%eax
 5bf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5c6:	00 
 5c7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5ce:	00 
 5cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	89 04 24             	mov    %eax,(%esp)
 5d9:	e8 aa fe ff ff       	call   488 <printint>
        ap++;
 5de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e2:	e9 ec 00 00 00       	jmp    6d3 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5e7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5eb:	74 06                	je     5f3 <printf+0xb3>
 5ed:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5f1:	75 2d                	jne    620 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f6:	8b 00                	mov    (%eax),%eax
 5f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5ff:	00 
 600:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 607:	00 
 608:	89 44 24 04          	mov    %eax,0x4(%esp)
 60c:	8b 45 08             	mov    0x8(%ebp),%eax
 60f:	89 04 24             	mov    %eax,(%esp)
 612:	e8 71 fe ff ff       	call   488 <printint>
        ap++;
 617:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61b:	e9 b3 00 00 00       	jmp    6d3 <printf+0x193>
      } else if(c == 's'){
 620:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 624:	75 45                	jne    66b <printf+0x12b>
        s = (char*)*ap;
 626:	8b 45 e8             	mov    -0x18(%ebp),%eax
 629:	8b 00                	mov    (%eax),%eax
 62b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 62e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 632:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 636:	75 09                	jne    641 <printf+0x101>
          s = "(null)";
 638:	c7 45 f4 76 09 00 00 	movl   $0x976,-0xc(%ebp)
        while(*s != 0){
 63f:	eb 1e                	jmp    65f <printf+0x11f>
 641:	eb 1c                	jmp    65f <printf+0x11f>
          putc(fd, *s);
 643:	8b 45 f4             	mov    -0xc(%ebp),%eax
 646:	0f b6 00             	movzbl (%eax),%eax
 649:	0f be c0             	movsbl %al,%eax
 64c:	89 44 24 04          	mov    %eax,0x4(%esp)
 650:	8b 45 08             	mov    0x8(%ebp),%eax
 653:	89 04 24             	mov    %eax,(%esp)
 656:	e8 05 fe ff ff       	call   460 <putc>
          s++;
 65b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 65f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 662:	0f b6 00             	movzbl (%eax),%eax
 665:	84 c0                	test   %al,%al
 667:	75 da                	jne    643 <printf+0x103>
 669:	eb 68                	jmp    6d3 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 66f:	75 1d                	jne    68e <printf+0x14e>
        putc(fd, *ap);
 671:	8b 45 e8             	mov    -0x18(%ebp),%eax
 674:	8b 00                	mov    (%eax),%eax
 676:	0f be c0             	movsbl %al,%eax
 679:	89 44 24 04          	mov    %eax,0x4(%esp)
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	89 04 24             	mov    %eax,(%esp)
 683:	e8 d8 fd ff ff       	call   460 <putc>
        ap++;
 688:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68c:	eb 45                	jmp    6d3 <printf+0x193>
      } else if(c == '%'){
 68e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 692:	75 17                	jne    6ab <printf+0x16b>
        putc(fd, c);
 694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 697:	0f be c0             	movsbl %al,%eax
 69a:	89 44 24 04          	mov    %eax,0x4(%esp)
 69e:	8b 45 08             	mov    0x8(%ebp),%eax
 6a1:	89 04 24             	mov    %eax,(%esp)
 6a4:	e8 b7 fd ff ff       	call   460 <putc>
 6a9:	eb 28                	jmp    6d3 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ab:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6b2:	00 
 6b3:	8b 45 08             	mov    0x8(%ebp),%eax
 6b6:	89 04 24             	mov    %eax,(%esp)
 6b9:	e8 a2 fd ff ff       	call   460 <putc>
        putc(fd, c);
 6be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c1:	0f be c0             	movsbl %al,%eax
 6c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c8:	8b 45 08             	mov    0x8(%ebp),%eax
 6cb:	89 04 24             	mov    %eax,(%esp)
 6ce:	e8 8d fd ff ff       	call   460 <putc>
      }
      state = 0;
 6d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6de:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e4:	01 d0                	add    %edx,%eax
 6e6:	0f b6 00             	movzbl (%eax),%eax
 6e9:	84 c0                	test   %al,%al
 6eb:	0f 85 71 fe ff ff    	jne    562 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f1:	c9                   	leave  
 6f2:	c3                   	ret    

000006f3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f3:	55                   	push   %ebp
 6f4:	89 e5                	mov    %esp,%ebp
 6f6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
 6fc:	83 e8 08             	sub    $0x8,%eax
 6ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 702:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 707:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70a:	eb 24                	jmp    730 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 00                	mov    (%eax),%eax
 711:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 714:	77 12                	ja     728 <free+0x35>
 716:	8b 45 f8             	mov    -0x8(%ebp),%eax
 719:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71c:	77 24                	ja     742 <free+0x4f>
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 00                	mov    (%eax),%eax
 723:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 726:	77 1a                	ja     742 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 730:	8b 45 f8             	mov    -0x8(%ebp),%eax
 733:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 736:	76 d4                	jbe    70c <free+0x19>
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	8b 00                	mov    (%eax),%eax
 73d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 740:	76 ca                	jbe    70c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 742:	8b 45 f8             	mov    -0x8(%ebp),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	01 c2                	add    %eax,%edx
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	39 c2                	cmp    %eax,%edx
 75b:	75 24                	jne    781 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	8b 50 04             	mov    0x4(%eax),%edx
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 00                	mov    (%eax),%eax
 768:	8b 40 04             	mov    0x4(%eax),%eax
 76b:	01 c2                	add    %eax,%edx
 76d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 770:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 773:	8b 45 fc             	mov    -0x4(%ebp),%eax
 776:	8b 00                	mov    (%eax),%eax
 778:	8b 10                	mov    (%eax),%edx
 77a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77d:	89 10                	mov    %edx,(%eax)
 77f:	eb 0a                	jmp    78b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 10                	mov    (%eax),%edx
 786:	8b 45 f8             	mov    -0x8(%ebp),%eax
 789:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 40 04             	mov    0x4(%eax),%eax
 791:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	01 d0                	add    %edx,%eax
 79d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a0:	75 20                	jne    7c2 <free+0xcf>
    p->s.size += bp->s.size;
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	8b 50 04             	mov    0x4(%eax),%edx
 7a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ab:	8b 40 04             	mov    0x4(%eax),%eax
 7ae:	01 c2                	add    %eax,%edx
 7b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b9:	8b 10                	mov    (%eax),%edx
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	89 10                	mov    %edx,(%eax)
 7c0:	eb 08                	jmp    7ca <free+0xd7>
  } else
    p->s.ptr = bp;
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c8:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cd:	a3 e0 0b 00 00       	mov    %eax,0xbe0
}
 7d2:	c9                   	leave  
 7d3:	c3                   	ret    

000007d4 <morecore>:

static Header*
morecore(uint nu)
{
 7d4:	55                   	push   %ebp
 7d5:	89 e5                	mov    %esp,%ebp
 7d7:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7da:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7e1:	77 07                	ja     7ea <morecore+0x16>
    nu = 4096;
 7e3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ea:	8b 45 08             	mov    0x8(%ebp),%eax
 7ed:	c1 e0 03             	shl    $0x3,%eax
 7f0:	89 04 24             	mov    %eax,(%esp)
 7f3:	e8 08 fc ff ff       	call   400 <sbrk>
 7f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7fb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ff:	75 07                	jne    808 <morecore+0x34>
    return 0;
 801:	b8 00 00 00 00       	mov    $0x0,%eax
 806:	eb 22                	jmp    82a <morecore+0x56>
  hp = (Header*)p;
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 80e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 811:	8b 55 08             	mov    0x8(%ebp),%edx
 814:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 817:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81a:	83 c0 08             	add    $0x8,%eax
 81d:	89 04 24             	mov    %eax,(%esp)
 820:	e8 ce fe ff ff       	call   6f3 <free>
  return freep;
 825:	a1 e0 0b 00 00       	mov    0xbe0,%eax
}
 82a:	c9                   	leave  
 82b:	c3                   	ret    

0000082c <malloc>:

void*
malloc(uint nbytes)
{
 82c:	55                   	push   %ebp
 82d:	89 e5                	mov    %esp,%ebp
 82f:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 832:	8b 45 08             	mov    0x8(%ebp),%eax
 835:	83 c0 07             	add    $0x7,%eax
 838:	c1 e8 03             	shr    $0x3,%eax
 83b:	83 c0 01             	add    $0x1,%eax
 83e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 841:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 846:	89 45 f0             	mov    %eax,-0x10(%ebp)
 849:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 84d:	75 23                	jne    872 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 84f:	c7 45 f0 d8 0b 00 00 	movl   $0xbd8,-0x10(%ebp)
 856:	8b 45 f0             	mov    -0x10(%ebp),%eax
 859:	a3 e0 0b 00 00       	mov    %eax,0xbe0
 85e:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 863:	a3 d8 0b 00 00       	mov    %eax,0xbd8
    base.s.size = 0;
 868:	c7 05 dc 0b 00 00 00 	movl   $0x0,0xbdc
 86f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 872:	8b 45 f0             	mov    -0x10(%ebp),%eax
 875:	8b 00                	mov    (%eax),%eax
 877:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	8b 40 04             	mov    0x4(%eax),%eax
 880:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 883:	72 4d                	jb     8d2 <malloc+0xa6>
      if(p->s.size == nunits)
 885:	8b 45 f4             	mov    -0xc(%ebp),%eax
 888:	8b 40 04             	mov    0x4(%eax),%eax
 88b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 88e:	75 0c                	jne    89c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	8b 10                	mov    (%eax),%edx
 895:	8b 45 f0             	mov    -0x10(%ebp),%eax
 898:	89 10                	mov    %edx,(%eax)
 89a:	eb 26                	jmp    8c2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89f:	8b 40 04             	mov    0x4(%eax),%eax
 8a2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8a5:	89 c2                	mov    %eax,%edx
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	8b 40 04             	mov    0x4(%eax),%eax
 8b3:	c1 e0 03             	shl    $0x3,%eax
 8b6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8bf:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c5:	a3 e0 0b 00 00       	mov    %eax,0xbe0
      return (void*)(p + 1);
 8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cd:	83 c0 08             	add    $0x8,%eax
 8d0:	eb 38                	jmp    90a <malloc+0xde>
    }
    if(p == freep)
 8d2:	a1 e0 0b 00 00       	mov    0xbe0,%eax
 8d7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8da:	75 1b                	jne    8f7 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8df:	89 04 24             	mov    %eax,(%esp)
 8e2:	e8 ed fe ff ff       	call   7d4 <morecore>
 8e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ee:	75 07                	jne    8f7 <malloc+0xcb>
        return 0;
 8f0:	b8 00 00 00 00       	mov    $0x0,%eax
 8f5:	eb 13                	jmp    90a <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	8b 00                	mov    (%eax),%eax
 902:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 905:	e9 70 ff ff ff       	jmp    87a <malloc+0x4e>
}
 90a:	c9                   	leave  
 90b:	c3                   	ret    

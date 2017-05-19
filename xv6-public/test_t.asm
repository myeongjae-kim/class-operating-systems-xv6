
_test_t:     file format elf32-i386


Disassembly of section .text:

00000000 <mythread>:

static volatile int counter = 0;

void *
mythread(void *arg)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(1, "%s: begin\n", (char *) arg);
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	89 44 24 08          	mov    %eax,0x8(%esp)
   d:	c7 44 24 04 00 0a 00 	movl   $0xa00,0x4(%esp)
  14:	00 
  15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1c:	e8 11 06 00 00       	call   632 <printf>
  for (i = 0; i < 1e7; ++i) {
  21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  28:	eb 11                	jmp    3b <mythread+0x3b>
    counter = counter + 1;
  2a:	a1 00 0d 00 00       	mov    0xd00,%eax
  2f:	83 c0 01             	add    $0x1,%eax
  32:	a3 00 0d 00 00       	mov    %eax,0xd00
mythread(void *arg)
{
  int i;

  printf(1, "%s: begin\n", (char *) arg);
  for (i = 0; i < 1e7; ++i) {
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  3b:	db 45 f4             	fildl  -0xc(%ebp)
  3e:	dd 05 60 0a 00 00    	fldl   0xa60
  44:	df e9                	fucomip %st(1),%st
  46:	dd d8                	fstp   %st(0)
  48:	77 e0                	ja     2a <mythread+0x2a>
    counter = counter + 1;
  }
  printf(1, "%s: done\n", (char *) arg);
  4a:	8b 45 08             	mov    0x8(%ebp),%eax
  4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  51:	c7 44 24 04 0b 0a 00 	movl   $0xa0b,0x4(%esp)
  58:	00 
  59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  60:	e8 cd 05 00 00       	call   632 <printf>

  thread_exit(0);
  65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  6c:	e8 c9 04 00 00       	call   53a <thread_exit>

00000071 <disturbing>:
}

void * 
disturbing(void *arg)
{
  71:	55                   	push   %ebp
  72:	89 e5                	mov    %esp,%ebp
  74:	83 ec 28             	sub    $0x28,%esp
  int j, k, l;
  int temp;
  l = k = j = -210000000;
  77:	c7 45 f4 80 a7 7b f3 	movl   $0xf37ba780,-0xc(%ebp)
  7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  temp = l + k + j;
  8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  90:	01 c2                	add    %eax,%edx
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	01 d0                	add    %edx,%eax
  97:	89 45 e8             	mov    %eax,-0x18(%ebp)
  temp++;
  9a:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  for (j = 0; j < 1e7; ++j) {
  9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  a5:	eb 08                	jmp    af <disturbing+0x3e>
    k = k + 1;
  a7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  int j, k, l;
  int temp;
  l = k = j = -210000000;
  temp = l + k + j;
  temp++;
  for (j = 0; j < 1e7; ++j) {
  ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  af:	db 45 f4             	fildl  -0xc(%ebp)
  b2:	dd 05 60 0a 00 00    	fldl   0xa60
  b8:	df e9                	fucomip %st(1),%st
  ba:	dd d8                	fstp   %st(0)
  bc:	77 e9                	ja     a7 <disturbing+0x36>
    k = k + 1;
  }
  thread_exit(0);
  be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  c5:	e8 70 04 00 00       	call   53a <thread_exit>

000000ca <main>:
}

int
main(int argc, char *argv[])
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  cd:	83 e4 f0             	and    $0xfffffff0,%esp
  d0:	83 ec 30             	sub    $0x30,%esp
  thread_t p2;
  thread_t p3;
  thread_t p4;
  thread_t p5;
  
  printf(1, "main: begin (counter = %d)\n", counter);
  d3:	a1 00 0d 00 00       	mov    0xd00,%eax
  d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  dc:	c7 44 24 04 15 0a 00 	movl   $0xa15,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  eb:	e8 42 05 00 00       	call   632 <printf>
  thread_create(&p1, mythread, "A");
  f0:	c7 44 24 08 31 0a 00 	movl   $0xa31,0x8(%esp)
  f7:	00 
  f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ff:	00 
 100:	8d 44 24 2c          	lea    0x2c(%esp),%eax
 104:	89 04 24             	mov    %eax,(%esp)
 107:	e8 26 04 00 00       	call   532 <thread_create>
  thread_create(&p3, disturbing, 0);
 10c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 113:	00 
 114:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
 11b:	00 
 11c:	8d 44 24 24          	lea    0x24(%esp),%eax
 120:	89 04 24             	mov    %eax,(%esp)
 123:	e8 0a 04 00 00       	call   532 <thread_create>
  thread_create(&p2, mythread, "B");
 128:	c7 44 24 08 33 0a 00 	movl   $0xa33,0x8(%esp)
 12f:	00 
 130:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 137:	00 
 138:	8d 44 24 28          	lea    0x28(%esp),%eax
 13c:	89 04 24             	mov    %eax,(%esp)
 13f:	e8 ee 03 00 00       	call   532 <thread_create>
  thread_create(&p4, disturbing, 0);
 144:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 14b:	00 
 14c:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
 153:	00 
 154:	8d 44 24 20          	lea    0x20(%esp),%eax
 158:	89 04 24             	mov    %eax,(%esp)
 15b:	e8 d2 03 00 00       	call   532 <thread_create>
  thread_create(&p5, disturbing, 0);
 160:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 167:	00 
 168:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
 16f:	00 
 170:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 174:	89 04 24             	mov    %eax,(%esp)
 177:	e8 b6 03 00 00       	call   532 <thread_create>

  thread_join(p1, 0);
 17c:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 180:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 187:	00 
 188:	89 04 24             	mov    %eax,(%esp)
 18b:	e8 b2 03 00 00       	call   542 <thread_join>
  thread_join(p3, 0);
 190:	8b 44 24 24          	mov    0x24(%esp),%eax
 194:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 19b:	00 
 19c:	89 04 24             	mov    %eax,(%esp)
 19f:	e8 9e 03 00 00       	call   542 <thread_join>
  thread_join(p2, 0);
 1a4:	8b 44 24 28          	mov    0x28(%esp),%eax
 1a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1af:	00 
 1b0:	89 04 24             	mov    %eax,(%esp)
 1b3:	e8 8a 03 00 00       	call   542 <thread_join>
  thread_join(p4, 0);
 1b8:	8b 44 24 20          	mov    0x20(%esp),%eax
 1bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1c3:	00 
 1c4:	89 04 24             	mov    %eax,(%esp)
 1c7:	e8 76 03 00 00       	call   542 <thread_join>
  thread_join(p5, 0);
 1cc:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1d7:	00 
 1d8:	89 04 24             	mov    %eax,(%esp)
 1db:	e8 62 03 00 00       	call   542 <thread_join>
  printf(1, "main: done with both (counter = %d)\n", counter);
 1e0:	a1 00 0d 00 00       	mov    0xd00,%eax
 1e5:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e9:	c7 44 24 04 38 0a 00 	movl   $0xa38,0x4(%esp)
 1f0:	00 
 1f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1f8:	e8 35 04 00 00       	call   632 <printf>
  exit();
 1fd:	e8 68 02 00 00       	call   46a <exit>

00000202 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	57                   	push   %edi
 206:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 207:	8b 4d 08             	mov    0x8(%ebp),%ecx
 20a:	8b 55 10             	mov    0x10(%ebp),%edx
 20d:	8b 45 0c             	mov    0xc(%ebp),%eax
 210:	89 cb                	mov    %ecx,%ebx
 212:	89 df                	mov    %ebx,%edi
 214:	89 d1                	mov    %edx,%ecx
 216:	fc                   	cld    
 217:	f3 aa                	rep stos %al,%es:(%edi)
 219:	89 ca                	mov    %ecx,%edx
 21b:	89 fb                	mov    %edi,%ebx
 21d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 220:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 223:	5b                   	pop    %ebx
 224:	5f                   	pop    %edi
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    

00000227 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
 22a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 233:	90                   	nop
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	8d 50 01             	lea    0x1(%eax),%edx
 23a:	89 55 08             	mov    %edx,0x8(%ebp)
 23d:	8b 55 0c             	mov    0xc(%ebp),%edx
 240:	8d 4a 01             	lea    0x1(%edx),%ecx
 243:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 246:	0f b6 12             	movzbl (%edx),%edx
 249:	88 10                	mov    %dl,(%eax)
 24b:	0f b6 00             	movzbl (%eax),%eax
 24e:	84 c0                	test   %al,%al
 250:	75 e2                	jne    234 <strcpy+0xd>
    ;
  return os;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 25a:	eb 08                	jmp    264 <strcmp+0xd>
    p++, q++;
 25c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 260:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	0f b6 00             	movzbl (%eax),%eax
 26a:	84 c0                	test   %al,%al
 26c:	74 10                	je     27e <strcmp+0x27>
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	0f b6 10             	movzbl (%eax),%edx
 274:	8b 45 0c             	mov    0xc(%ebp),%eax
 277:	0f b6 00             	movzbl (%eax),%eax
 27a:	38 c2                	cmp    %al,%dl
 27c:	74 de                	je     25c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	0f b6 00             	movzbl (%eax),%eax
 284:	0f b6 d0             	movzbl %al,%edx
 287:	8b 45 0c             	mov    0xc(%ebp),%eax
 28a:	0f b6 00             	movzbl (%eax),%eax
 28d:	0f b6 c0             	movzbl %al,%eax
 290:	29 c2                	sub    %eax,%edx
 292:	89 d0                	mov    %edx,%eax
}
 294:	5d                   	pop    %ebp
 295:	c3                   	ret    

00000296 <strlen>:

uint
strlen(char *s)
{
 296:	55                   	push   %ebp
 297:	89 e5                	mov    %esp,%ebp
 299:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 29c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2a3:	eb 04                	jmp    2a9 <strlen+0x13>
 2a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	01 d0                	add    %edx,%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	84 c0                	test   %al,%al
 2b6:	75 ed                	jne    2a5 <strlen+0xf>
    ;
  return n;
 2b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    

000002bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
 2c0:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2c3:	8b 45 10             	mov    0x10(%ebp),%eax
 2c6:	89 44 24 08          	mov    %eax,0x8(%esp)
 2ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	89 04 24             	mov    %eax,(%esp)
 2d7:	e8 26 ff ff ff       	call   202 <stosb>
  return dst;
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2df:	c9                   	leave  
 2e0:	c3                   	ret    

000002e1 <strchr>:

char*
strchr(const char *s, char c)
{
 2e1:	55                   	push   %ebp
 2e2:	89 e5                	mov    %esp,%ebp
 2e4:	83 ec 04             	sub    $0x4,%esp
 2e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ea:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ed:	eb 14                	jmp    303 <strchr+0x22>
    if(*s == c)
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	0f b6 00             	movzbl (%eax),%eax
 2f5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2f8:	75 05                	jne    2ff <strchr+0x1e>
      return (char*)s;
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	eb 13                	jmp    312 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	0f b6 00             	movzbl (%eax),%eax
 309:	84 c0                	test   %al,%al
 30b:	75 e2                	jne    2ef <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 30d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 312:	c9                   	leave  
 313:	c3                   	ret    

00000314 <gets>:

char*
gets(char *buf, int max)
{
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 31a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 321:	eb 4c                	jmp    36f <gets+0x5b>
    cc = read(0, &c, 1);
 323:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 32a:	00 
 32b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 32e:	89 44 24 04          	mov    %eax,0x4(%esp)
 332:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 339:	e8 44 01 00 00       	call   482 <read>
 33e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 341:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 345:	7f 02                	jg     349 <gets+0x35>
      break;
 347:	eb 31                	jmp    37a <gets+0x66>
    buf[i++] = c;
 349:	8b 45 f4             	mov    -0xc(%ebp),%eax
 34c:	8d 50 01             	lea    0x1(%eax),%edx
 34f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 352:	89 c2                	mov    %eax,%edx
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	01 c2                	add    %eax,%edx
 359:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 35d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 35f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 363:	3c 0a                	cmp    $0xa,%al
 365:	74 13                	je     37a <gets+0x66>
 367:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 36b:	3c 0d                	cmp    $0xd,%al
 36d:	74 0b                	je     37a <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 36f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 372:	83 c0 01             	add    $0x1,%eax
 375:	3b 45 0c             	cmp    0xc(%ebp),%eax
 378:	7c a9                	jl     323 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 37a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	01 d0                	add    %edx,%eax
 382:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 385:	8b 45 08             	mov    0x8(%ebp),%eax
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <stat>:

int
stat(char *n, struct stat *st)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 390:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 397:	00 
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	89 04 24             	mov    %eax,(%esp)
 39e:	e8 07 01 00 00       	call   4aa <open>
 3a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3aa:	79 07                	jns    3b3 <stat+0x29>
    return -1;
 3ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3b1:	eb 23                	jmp    3d6 <stat+0x4c>
  r = fstat(fd, st);
 3b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3bd:	89 04 24             	mov    %eax,(%esp)
 3c0:	e8 fd 00 00 00       	call   4c2 <fstat>
 3c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3cb:	89 04 24             	mov    %eax,(%esp)
 3ce:	e8 bf 00 00 00       	call   492 <close>
  return r;
 3d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3d6:	c9                   	leave  
 3d7:	c3                   	ret    

000003d8 <atoi>:

int
atoi(const char *s)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3e5:	eb 25                	jmp    40c <atoi+0x34>
    n = n*10 + *s++ - '0';
 3e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ea:	89 d0                	mov    %edx,%eax
 3ec:	c1 e0 02             	shl    $0x2,%eax
 3ef:	01 d0                	add    %edx,%eax
 3f1:	01 c0                	add    %eax,%eax
 3f3:	89 c1                	mov    %eax,%ecx
 3f5:	8b 45 08             	mov    0x8(%ebp),%eax
 3f8:	8d 50 01             	lea    0x1(%eax),%edx
 3fb:	89 55 08             	mov    %edx,0x8(%ebp)
 3fe:	0f b6 00             	movzbl (%eax),%eax
 401:	0f be c0             	movsbl %al,%eax
 404:	01 c8                	add    %ecx,%eax
 406:	83 e8 30             	sub    $0x30,%eax
 409:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
 40f:	0f b6 00             	movzbl (%eax),%eax
 412:	3c 2f                	cmp    $0x2f,%al
 414:	7e 0a                	jle    420 <atoi+0x48>
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	0f b6 00             	movzbl (%eax),%eax
 41c:	3c 39                	cmp    $0x39,%al
 41e:	7e c7                	jle    3e7 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 420:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 423:	c9                   	leave  
 424:	c3                   	ret    

00000425 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 425:	55                   	push   %ebp
 426:	89 e5                	mov    %esp,%ebp
 428:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 431:	8b 45 0c             	mov    0xc(%ebp),%eax
 434:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 437:	eb 17                	jmp    450 <memmove+0x2b>
    *dst++ = *src++;
 439:	8b 45 fc             	mov    -0x4(%ebp),%eax
 43c:	8d 50 01             	lea    0x1(%eax),%edx
 43f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 442:	8b 55 f8             	mov    -0x8(%ebp),%edx
 445:	8d 4a 01             	lea    0x1(%edx),%ecx
 448:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 44b:	0f b6 12             	movzbl (%edx),%edx
 44e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 450:	8b 45 10             	mov    0x10(%ebp),%eax
 453:	8d 50 ff             	lea    -0x1(%eax),%edx
 456:	89 55 10             	mov    %edx,0x10(%ebp)
 459:	85 c0                	test   %eax,%eax
 45b:	7f dc                	jg     439 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 460:	c9                   	leave  
 461:	c3                   	ret    

00000462 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 462:	b8 01 00 00 00       	mov    $0x1,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <exit>:
SYSCALL(exit)
 46a:	b8 02 00 00 00       	mov    $0x2,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <wait>:
SYSCALL(wait)
 472:	b8 03 00 00 00       	mov    $0x3,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <pipe>:
SYSCALL(pipe)
 47a:	b8 04 00 00 00       	mov    $0x4,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <read>:
SYSCALL(read)
 482:	b8 05 00 00 00       	mov    $0x5,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <write>:
SYSCALL(write)
 48a:	b8 10 00 00 00       	mov    $0x10,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <close>:
SYSCALL(close)
 492:	b8 15 00 00 00       	mov    $0x15,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <kill>:
SYSCALL(kill)
 49a:	b8 06 00 00 00       	mov    $0x6,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <exec>:
SYSCALL(exec)
 4a2:	b8 07 00 00 00       	mov    $0x7,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <open>:
SYSCALL(open)
 4aa:	b8 0f 00 00 00       	mov    $0xf,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <mknod>:
SYSCALL(mknod)
 4b2:	b8 11 00 00 00       	mov    $0x11,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <unlink>:
SYSCALL(unlink)
 4ba:	b8 12 00 00 00       	mov    $0x12,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <fstat>:
SYSCALL(fstat)
 4c2:	b8 08 00 00 00       	mov    $0x8,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <link>:
SYSCALL(link)
 4ca:	b8 13 00 00 00       	mov    $0x13,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <mkdir>:
SYSCALL(mkdir)
 4d2:	b8 14 00 00 00       	mov    $0x14,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <chdir>:
SYSCALL(chdir)
 4da:	b8 09 00 00 00       	mov    $0x9,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <dup>:
SYSCALL(dup)
 4e2:	b8 0a 00 00 00       	mov    $0xa,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <getpid>:
SYSCALL(getpid)
 4ea:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <sbrk>:
SYSCALL(sbrk)
 4f2:	b8 0c 00 00 00       	mov    $0xc,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <sleep>:
SYSCALL(sleep)
 4fa:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <uptime>:
SYSCALL(uptime)
 502:	b8 0e 00 00 00       	mov    $0xe,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <my_syscall>:
SYSCALL(my_syscall)
 50a:	b8 16 00 00 00       	mov    $0x16,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <getppid>:
SYSCALL(getppid)
 512:	b8 17 00 00 00       	mov    $0x17,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <yield>:
SYSCALL(yield)
 51a:	b8 18 00 00 00       	mov    $0x18,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <getlev>:
SYSCALL(getlev)
 522:	b8 19 00 00 00       	mov    $0x19,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <set_cpu_share>:
SYSCALL(set_cpu_share)
 52a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <thread_create>:
SYSCALL(thread_create)
 532:	b8 1b 00 00 00       	mov    $0x1b,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <thread_exit>:
SYSCALL(thread_exit)
 53a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <thread_join>:
SYSCALL(thread_join)
 542:	b8 1d 00 00 00       	mov    $0x1d,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <gettid>:
SYSCALL(gettid)
 54a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 552:	55                   	push   %ebp
 553:	89 e5                	mov    %esp,%ebp
 555:	83 ec 18             	sub    $0x18,%esp
 558:	8b 45 0c             	mov    0xc(%ebp),%eax
 55b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 55e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 565:	00 
 566:	8d 45 f4             	lea    -0xc(%ebp),%eax
 569:	89 44 24 04          	mov    %eax,0x4(%esp)
 56d:	8b 45 08             	mov    0x8(%ebp),%eax
 570:	89 04 24             	mov    %eax,(%esp)
 573:	e8 12 ff ff ff       	call   48a <write>
}
 578:	c9                   	leave  
 579:	c3                   	ret    

0000057a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57a:	55                   	push   %ebp
 57b:	89 e5                	mov    %esp,%ebp
 57d:	56                   	push   %esi
 57e:	53                   	push   %ebx
 57f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 582:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 589:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 58d:	74 17                	je     5a6 <printint+0x2c>
 58f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 593:	79 11                	jns    5a6 <printint+0x2c>
    neg = 1;
 595:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 59c:	8b 45 0c             	mov    0xc(%ebp),%eax
 59f:	f7 d8                	neg    %eax
 5a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a4:	eb 06                	jmp    5ac <printint+0x32>
  } else {
    x = xx;
 5a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5b6:	8d 41 01             	lea    0x1(%ecx),%eax
 5b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c2:	ba 00 00 00 00       	mov    $0x0,%edx
 5c7:	f7 f3                	div    %ebx
 5c9:	89 d0                	mov    %edx,%eax
 5cb:	0f b6 80 ec 0c 00 00 	movzbl 0xcec(%eax),%eax
 5d2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5d6:	8b 75 10             	mov    0x10(%ebp),%esi
 5d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5dc:	ba 00 00 00 00       	mov    $0x0,%edx
 5e1:	f7 f6                	div    %esi
 5e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ea:	75 c7                	jne    5b3 <printint+0x39>
  if(neg)
 5ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5f0:	74 10                	je     602 <printint+0x88>
    buf[i++] = '-';
 5f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f5:	8d 50 01             	lea    0x1(%eax),%edx
 5f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5fb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 600:	eb 1f                	jmp    621 <printint+0xa7>
 602:	eb 1d                	jmp    621 <printint+0xa7>
    putc(fd, buf[i]);
 604:	8d 55 dc             	lea    -0x24(%ebp),%edx
 607:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60a:	01 d0                	add    %edx,%eax
 60c:	0f b6 00             	movzbl (%eax),%eax
 60f:	0f be c0             	movsbl %al,%eax
 612:	89 44 24 04          	mov    %eax,0x4(%esp)
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	89 04 24             	mov    %eax,(%esp)
 61c:	e8 31 ff ff ff       	call   552 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 621:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 629:	79 d9                	jns    604 <printint+0x8a>
    putc(fd, buf[i]);
}
 62b:	83 c4 30             	add    $0x30,%esp
 62e:	5b                   	pop    %ebx
 62f:	5e                   	pop    %esi
 630:	5d                   	pop    %ebp
 631:	c3                   	ret    

00000632 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 632:	55                   	push   %ebp
 633:	89 e5                	mov    %esp,%ebp
 635:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 638:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 63f:	8d 45 0c             	lea    0xc(%ebp),%eax
 642:	83 c0 04             	add    $0x4,%eax
 645:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 648:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 64f:	e9 7c 01 00 00       	jmp    7d0 <printf+0x19e>
    c = fmt[i] & 0xff;
 654:	8b 55 0c             	mov    0xc(%ebp),%edx
 657:	8b 45 f0             	mov    -0x10(%ebp),%eax
 65a:	01 d0                	add    %edx,%eax
 65c:	0f b6 00             	movzbl (%eax),%eax
 65f:	0f be c0             	movsbl %al,%eax
 662:	25 ff 00 00 00       	and    $0xff,%eax
 667:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 66a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 66e:	75 2c                	jne    69c <printf+0x6a>
      if(c == '%'){
 670:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 674:	75 0c                	jne    682 <printf+0x50>
        state = '%';
 676:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 67d:	e9 4a 01 00 00       	jmp    7cc <printf+0x19a>
      } else {
        putc(fd, c);
 682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 685:	0f be c0             	movsbl %al,%eax
 688:	89 44 24 04          	mov    %eax,0x4(%esp)
 68c:	8b 45 08             	mov    0x8(%ebp),%eax
 68f:	89 04 24             	mov    %eax,(%esp)
 692:	e8 bb fe ff ff       	call   552 <putc>
 697:	e9 30 01 00 00       	jmp    7cc <printf+0x19a>
      }
    } else if(state == '%'){
 69c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6a0:	0f 85 26 01 00 00    	jne    7cc <printf+0x19a>
      if(c == 'd'){
 6a6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6aa:	75 2d                	jne    6d9 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 6ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6b8:	00 
 6b9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6c0:	00 
 6c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	89 04 24             	mov    %eax,(%esp)
 6cb:	e8 aa fe ff ff       	call   57a <printint>
        ap++;
 6d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d4:	e9 ec 00 00 00       	jmp    7c5 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 6d9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6dd:	74 06                	je     6e5 <printf+0xb3>
 6df:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6e3:	75 2d                	jne    712 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6f1:	00 
 6f2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6f9:	00 
 6fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fe:	8b 45 08             	mov    0x8(%ebp),%eax
 701:	89 04 24             	mov    %eax,(%esp)
 704:	e8 71 fe ff ff       	call   57a <printint>
        ap++;
 709:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 70d:	e9 b3 00 00 00       	jmp    7c5 <printf+0x193>
      } else if(c == 's'){
 712:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 716:	75 45                	jne    75d <printf+0x12b>
        s = (char*)*ap;
 718:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 720:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 724:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 728:	75 09                	jne    733 <printf+0x101>
          s = "(null)";
 72a:	c7 45 f4 68 0a 00 00 	movl   $0xa68,-0xc(%ebp)
        while(*s != 0){
 731:	eb 1e                	jmp    751 <printf+0x11f>
 733:	eb 1c                	jmp    751 <printf+0x11f>
          putc(fd, *s);
 735:	8b 45 f4             	mov    -0xc(%ebp),%eax
 738:	0f b6 00             	movzbl (%eax),%eax
 73b:	0f be c0             	movsbl %al,%eax
 73e:	89 44 24 04          	mov    %eax,0x4(%esp)
 742:	8b 45 08             	mov    0x8(%ebp),%eax
 745:	89 04 24             	mov    %eax,(%esp)
 748:	e8 05 fe ff ff       	call   552 <putc>
          s++;
 74d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 751:	8b 45 f4             	mov    -0xc(%ebp),%eax
 754:	0f b6 00             	movzbl (%eax),%eax
 757:	84 c0                	test   %al,%al
 759:	75 da                	jne    735 <printf+0x103>
 75b:	eb 68                	jmp    7c5 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 75d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 761:	75 1d                	jne    780 <printf+0x14e>
        putc(fd, *ap);
 763:	8b 45 e8             	mov    -0x18(%ebp),%eax
 766:	8b 00                	mov    (%eax),%eax
 768:	0f be c0             	movsbl %al,%eax
 76b:	89 44 24 04          	mov    %eax,0x4(%esp)
 76f:	8b 45 08             	mov    0x8(%ebp),%eax
 772:	89 04 24             	mov    %eax,(%esp)
 775:	e8 d8 fd ff ff       	call   552 <putc>
        ap++;
 77a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 77e:	eb 45                	jmp    7c5 <printf+0x193>
      } else if(c == '%'){
 780:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 784:	75 17                	jne    79d <printf+0x16b>
        putc(fd, c);
 786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 789:	0f be c0             	movsbl %al,%eax
 78c:	89 44 24 04          	mov    %eax,0x4(%esp)
 790:	8b 45 08             	mov    0x8(%ebp),%eax
 793:	89 04 24             	mov    %eax,(%esp)
 796:	e8 b7 fd ff ff       	call   552 <putc>
 79b:	eb 28                	jmp    7c5 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 79d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7a4:	00 
 7a5:	8b 45 08             	mov    0x8(%ebp),%eax
 7a8:	89 04 24             	mov    %eax,(%esp)
 7ab:	e8 a2 fd ff ff       	call   552 <putc>
        putc(fd, c);
 7b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b3:	0f be c0             	movsbl %al,%eax
 7b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ba:	8b 45 08             	mov    0x8(%ebp),%eax
 7bd:	89 04 24             	mov    %eax,(%esp)
 7c0:	e8 8d fd ff ff       	call   552 <putc>
      }
      state = 0;
 7c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7cc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7d0:	8b 55 0c             	mov    0xc(%ebp),%edx
 7d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d6:	01 d0                	add    %edx,%eax
 7d8:	0f b6 00             	movzbl (%eax),%eax
 7db:	84 c0                	test   %al,%al
 7dd:	0f 85 71 fe ff ff    	jne    654 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7e3:	c9                   	leave  
 7e4:	c3                   	ret    

000007e5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e5:	55                   	push   %ebp
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	83 e8 08             	sub    $0x8,%eax
 7f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 7f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7fc:	eb 24                	jmp    822 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 801:	8b 00                	mov    (%eax),%eax
 803:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 806:	77 12                	ja     81a <free+0x35>
 808:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 80e:	77 24                	ja     834 <free+0x4f>
 810:	8b 45 fc             	mov    -0x4(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 818:	77 1a                	ja     834 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 822:	8b 45 f8             	mov    -0x8(%ebp),%eax
 825:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 828:	76 d4                	jbe    7fe <free+0x19>
 82a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82d:	8b 00                	mov    (%eax),%eax
 82f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 832:	76 ca                	jbe    7fe <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 834:	8b 45 f8             	mov    -0x8(%ebp),%eax
 837:	8b 40 04             	mov    0x4(%eax),%eax
 83a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 841:	8b 45 f8             	mov    -0x8(%ebp),%eax
 844:	01 c2                	add    %eax,%edx
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	8b 00                	mov    (%eax),%eax
 84b:	39 c2                	cmp    %eax,%edx
 84d:	75 24                	jne    873 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 84f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 852:	8b 50 04             	mov    0x4(%eax),%edx
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 00                	mov    (%eax),%eax
 85a:	8b 40 04             	mov    0x4(%eax),%eax
 85d:	01 c2                	add    %eax,%edx
 85f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 862:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
 868:	8b 00                	mov    (%eax),%eax
 86a:	8b 10                	mov    (%eax),%edx
 86c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86f:	89 10                	mov    %edx,(%eax)
 871:	eb 0a                	jmp    87d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	8b 10                	mov    (%eax),%edx
 878:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	8b 40 04             	mov    0x4(%eax),%eax
 883:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 88a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88d:	01 d0                	add    %edx,%eax
 88f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 892:	75 20                	jne    8b4 <free+0xcf>
    p->s.size += bp->s.size;
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	8b 50 04             	mov    0x4(%eax),%edx
 89a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89d:	8b 40 04             	mov    0x4(%eax),%eax
 8a0:	01 c2                	add    %eax,%edx
 8a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ab:	8b 10                	mov    (%eax),%edx
 8ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b0:	89 10                	mov    %edx,(%eax)
 8b2:	eb 08                	jmp    8bc <free+0xd7>
  } else
    p->s.ptr = bp;
 8b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8ba:	89 10                	mov    %edx,(%eax)
  freep = p;
 8bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bf:	a3 0c 0d 00 00       	mov    %eax,0xd0c
}
 8c4:	c9                   	leave  
 8c5:	c3                   	ret    

000008c6 <morecore>:

static Header*
morecore(uint nu)
{
 8c6:	55                   	push   %ebp
 8c7:	89 e5                	mov    %esp,%ebp
 8c9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8cc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8d3:	77 07                	ja     8dc <morecore+0x16>
    nu = 4096;
 8d5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8dc:	8b 45 08             	mov    0x8(%ebp),%eax
 8df:	c1 e0 03             	shl    $0x3,%eax
 8e2:	89 04 24             	mov    %eax,(%esp)
 8e5:	e8 08 fc ff ff       	call   4f2 <sbrk>
 8ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8ed:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8f1:	75 07                	jne    8fa <morecore+0x34>
    return 0;
 8f3:	b8 00 00 00 00       	mov    $0x0,%eax
 8f8:	eb 22                	jmp    91c <morecore+0x56>
  hp = (Header*)p;
 8fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 900:	8b 45 f0             	mov    -0x10(%ebp),%eax
 903:	8b 55 08             	mov    0x8(%ebp),%edx
 906:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 909:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90c:	83 c0 08             	add    $0x8,%eax
 90f:	89 04 24             	mov    %eax,(%esp)
 912:	e8 ce fe ff ff       	call   7e5 <free>
  return freep;
 917:	a1 0c 0d 00 00       	mov    0xd0c,%eax
}
 91c:	c9                   	leave  
 91d:	c3                   	ret    

0000091e <malloc>:

void*
malloc(uint nbytes)
{
 91e:	55                   	push   %ebp
 91f:	89 e5                	mov    %esp,%ebp
 921:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 924:	8b 45 08             	mov    0x8(%ebp),%eax
 927:	83 c0 07             	add    $0x7,%eax
 92a:	c1 e8 03             	shr    $0x3,%eax
 92d:	83 c0 01             	add    $0x1,%eax
 930:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 933:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 938:	89 45 f0             	mov    %eax,-0x10(%ebp)
 93b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 93f:	75 23                	jne    964 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 941:	c7 45 f0 04 0d 00 00 	movl   $0xd04,-0x10(%ebp)
 948:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94b:	a3 0c 0d 00 00       	mov    %eax,0xd0c
 950:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 955:	a3 04 0d 00 00       	mov    %eax,0xd04
    base.s.size = 0;
 95a:	c7 05 08 0d 00 00 00 	movl   $0x0,0xd08
 961:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 964:	8b 45 f0             	mov    -0x10(%ebp),%eax
 967:	8b 00                	mov    (%eax),%eax
 969:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 96c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96f:	8b 40 04             	mov    0x4(%eax),%eax
 972:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 975:	72 4d                	jb     9c4 <malloc+0xa6>
      if(p->s.size == nunits)
 977:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97a:	8b 40 04             	mov    0x4(%eax),%eax
 97d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 980:	75 0c                	jne    98e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 982:	8b 45 f4             	mov    -0xc(%ebp),%eax
 985:	8b 10                	mov    (%eax),%edx
 987:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98a:	89 10                	mov    %edx,(%eax)
 98c:	eb 26                	jmp    9b4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 98e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 991:	8b 40 04             	mov    0x4(%eax),%eax
 994:	2b 45 ec             	sub    -0x14(%ebp),%eax
 997:	89 c2                	mov    %eax,%edx
 999:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 99f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a2:	8b 40 04             	mov    0x4(%eax),%eax
 9a5:	c1 e0 03             	shl    $0x3,%eax
 9a8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9b1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b7:	a3 0c 0d 00 00       	mov    %eax,0xd0c
      return (void*)(p + 1);
 9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bf:	83 c0 08             	add    $0x8,%eax
 9c2:	eb 38                	jmp    9fc <malloc+0xde>
    }
    if(p == freep)
 9c4:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 9c9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9cc:	75 1b                	jne    9e9 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9d1:	89 04 24             	mov    %eax,(%esp)
 9d4:	e8 ed fe ff ff       	call   8c6 <morecore>
 9d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9e0:	75 07                	jne    9e9 <malloc+0xcb>
        return 0;
 9e2:	b8 00 00 00 00       	mov    $0x0,%eax
 9e7:	eb 13                	jmp    9fc <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f2:	8b 00                	mov    (%eax),%eax
 9f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9f7:	e9 70 ff ff ff       	jmp    96c <malloc+0x4e>
}
 9fc:	c9                   	leave  
 9fd:	c3                   	ret    

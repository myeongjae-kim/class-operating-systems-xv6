
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   6:	eb 39                	jmp    41 <cat+0x41>
    if (write(1, buf, n) != n) {
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 20 0c 00 	movl   $0xc20,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 a0 03 00 00       	call   3c3 <write>
  23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  26:	74 19                	je     41 <cat+0x41>
      printf(1, "cat: write error\n");
  28:	c7 44 24 04 37 09 00 	movl   $0x937,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 2f 05 00 00       	call   56b <printf>
      exit();
  3c:	e8 62 03 00 00       	call   3a3 <exit>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  41:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  48:	00 
  49:	c7 44 24 04 20 0c 00 	movl   $0xc20,0x4(%esp)
  50:	00 
  51:	8b 45 08             	mov    0x8(%ebp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 5f 03 00 00       	call   3bb <read>
  5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  63:	7f a3                	jg     8 <cat+0x8>
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
      exit();
    }
  }
  if(n < 0){
  65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  69:	79 19                	jns    84 <cat+0x84>
    printf(1, "cat: read error\n");
  6b:	c7 44 24 04 49 09 00 	movl   $0x949,0x4(%esp)
  72:	00 
  73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7a:	e8 ec 04 00 00       	call   56b <printf>
    exit();
  7f:	e8 1f 03 00 00       	call   3a3 <exit>
  }
}
  84:	c9                   	leave  
  85:	c3                   	ret    

00000086 <main>:

int
main(int argc, char *argv[])
{
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	83 e4 f0             	and    $0xfffffff0,%esp
  8c:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  8f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  93:	7f 11                	jg     a6 <main+0x20>
    cat(0);
  95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  9c:	e8 5f ff ff ff       	call   0 <cat>
    exit();
  a1:	e8 fd 02 00 00       	call   3a3 <exit>
  }

  for(i = 1; i < argc; i++){
  a6:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  ad:	00 
  ae:	eb 79                	jmp    129 <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  b0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  be:	01 d0                	add    %edx,%eax
  c0:	8b 00                	mov    (%eax),%eax
  c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c9:	00 
  ca:	89 04 24             	mov    %eax,(%esp)
  cd:	e8 11 03 00 00       	call   3e3 <open>
  d2:	89 44 24 18          	mov    %eax,0x18(%esp)
  d6:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  db:	79 2f                	jns    10c <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  dd:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  eb:	01 d0                	add    %edx,%eax
  ed:	8b 00                	mov    (%eax),%eax
  ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  f3:	c7 44 24 04 5a 09 00 	movl   $0x95a,0x4(%esp)
  fa:	00 
  fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 102:	e8 64 04 00 00       	call   56b <printf>
      exit();
 107:	e8 97 02 00 00       	call   3a3 <exit>
    }
    cat(fd);
 10c:	8b 44 24 18          	mov    0x18(%esp),%eax
 110:	89 04 24             	mov    %eax,(%esp)
 113:	e8 e8 fe ff ff       	call   0 <cat>
    close(fd);
 118:	8b 44 24 18          	mov    0x18(%esp),%eax
 11c:	89 04 24             	mov    %eax,(%esp)
 11f:	e8 a7 02 00 00       	call   3cb <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 124:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 129:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 12d:	3b 45 08             	cmp    0x8(%ebp),%eax
 130:	0f 8c 7a ff ff ff    	jl     b0 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 136:	e8 68 02 00 00       	call   3a3 <exit>

0000013b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	57                   	push   %edi
 13f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 140:	8b 4d 08             	mov    0x8(%ebp),%ecx
 143:	8b 55 10             	mov    0x10(%ebp),%edx
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	89 cb                	mov    %ecx,%ebx
 14b:	89 df                	mov    %ebx,%edi
 14d:	89 d1                	mov    %edx,%ecx
 14f:	fc                   	cld    
 150:	f3 aa                	rep stos %al,%es:(%edi)
 152:	89 ca                	mov    %ecx,%edx
 154:	89 fb                	mov    %edi,%ebx
 156:	89 5d 08             	mov    %ebx,0x8(%ebp)
 159:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 15c:	5b                   	pop    %ebx
 15d:	5f                   	pop    %edi
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 16c:	90                   	nop
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	8d 50 01             	lea    0x1(%eax),%edx
 173:	89 55 08             	mov    %edx,0x8(%ebp)
 176:	8b 55 0c             	mov    0xc(%ebp),%edx
 179:	8d 4a 01             	lea    0x1(%edx),%ecx
 17c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 17f:	0f b6 12             	movzbl (%edx),%edx
 182:	88 10                	mov    %dl,(%eax)
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	84 c0                	test   %al,%al
 189:	75 e2                	jne    16d <strcpy+0xd>
    ;
  return os;
 18b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18e:	c9                   	leave  
 18f:	c3                   	ret    

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 193:	eb 08                	jmp    19d <strcmp+0xd>
    p++, q++;
 195:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 199:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
 1a0:	0f b6 00             	movzbl (%eax),%eax
 1a3:	84 c0                	test   %al,%al
 1a5:	74 10                	je     1b7 <strcmp+0x27>
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 10             	movzbl (%eax),%edx
 1ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	38 c2                	cmp    %al,%dl
 1b5:	74 de                	je     195 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	0f b6 00             	movzbl (%eax),%eax
 1bd:	0f b6 d0             	movzbl %al,%edx
 1c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c3:	0f b6 00             	movzbl (%eax),%eax
 1c6:	0f b6 c0             	movzbl %al,%eax
 1c9:	29 c2                	sub    %eax,%edx
 1cb:	89 d0                	mov    %edx,%eax
}
 1cd:	5d                   	pop    %ebp
 1ce:	c3                   	ret    

000001cf <strlen>:

uint
strlen(char *s)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1dc:	eb 04                	jmp    1e2 <strlen+0x13>
 1de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	01 d0                	add    %edx,%eax
 1ea:	0f b6 00             	movzbl (%eax),%eax
 1ed:	84 c0                	test   %al,%al
 1ef:	75 ed                	jne    1de <strlen+0xf>
    ;
  return n;
 1f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f4:	c9                   	leave  
 1f5:	c3                   	ret    

000001f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1fc:	8b 45 10             	mov    0x10(%ebp),%eax
 1ff:	89 44 24 08          	mov    %eax,0x8(%esp)
 203:	8b 45 0c             	mov    0xc(%ebp),%eax
 206:	89 44 24 04          	mov    %eax,0x4(%esp)
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	89 04 24             	mov    %eax,(%esp)
 210:	e8 26 ff ff ff       	call   13b <stosb>
  return dst;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
}
 218:	c9                   	leave  
 219:	c3                   	ret    

0000021a <strchr>:

char*
strchr(const char *s, char c)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	83 ec 04             	sub    $0x4,%esp
 220:	8b 45 0c             	mov    0xc(%ebp),%eax
 223:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 226:	eb 14                	jmp    23c <strchr+0x22>
    if(*s == c)
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	0f b6 00             	movzbl (%eax),%eax
 22e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 231:	75 05                	jne    238 <strchr+0x1e>
      return (char*)s;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	eb 13                	jmp    24b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 238:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	0f b6 00             	movzbl (%eax),%eax
 242:	84 c0                	test   %al,%al
 244:	75 e2                	jne    228 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 246:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24b:	c9                   	leave  
 24c:	c3                   	ret    

0000024d <gets>:

char*
gets(char *buf, int max)
{
 24d:	55                   	push   %ebp
 24e:	89 e5                	mov    %esp,%ebp
 250:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 253:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 25a:	eb 4c                	jmp    2a8 <gets+0x5b>
    cc = read(0, &c, 1);
 25c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 263:	00 
 264:	8d 45 ef             	lea    -0x11(%ebp),%eax
 267:	89 44 24 04          	mov    %eax,0x4(%esp)
 26b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 272:	e8 44 01 00 00       	call   3bb <read>
 277:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 27a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27e:	7f 02                	jg     282 <gets+0x35>
      break;
 280:	eb 31                	jmp    2b3 <gets+0x66>
    buf[i++] = c;
 282:	8b 45 f4             	mov    -0xc(%ebp),%eax
 285:	8d 50 01             	lea    0x1(%eax),%edx
 288:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28b:	89 c2                	mov    %eax,%edx
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	01 c2                	add    %eax,%edx
 292:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 296:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 298:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29c:	3c 0a                	cmp    $0xa,%al
 29e:	74 13                	je     2b3 <gets+0x66>
 2a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a4:	3c 0d                	cmp    $0xd,%al
 2a6:	74 0b                	je     2b3 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ab:	83 c0 01             	add    $0x1,%eax
 2ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b1:	7c a9                	jl     25c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	01 d0                	add    %edx,%eax
 2bb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <stat>:

int
stat(char *n, struct stat *st)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2d0:	00 
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	89 04 24             	mov    %eax,(%esp)
 2d7:	e8 07 01 00 00       	call   3e3 <open>
 2dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e3:	79 07                	jns    2ec <stat+0x29>
    return -1;
 2e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ea:	eb 23                	jmp    30f <stat+0x4c>
  r = fstat(fd, st);
 2ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f6:	89 04 24             	mov    %eax,(%esp)
 2f9:	e8 fd 00 00 00       	call   3fb <fstat>
 2fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 301:	8b 45 f4             	mov    -0xc(%ebp),%eax
 304:	89 04 24             	mov    %eax,(%esp)
 307:	e8 bf 00 00 00       	call   3cb <close>
  return r;
 30c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 30f:	c9                   	leave  
 310:	c3                   	ret    

00000311 <atoi>:

int
atoi(const char *s)
{
 311:	55                   	push   %ebp
 312:	89 e5                	mov    %esp,%ebp
 314:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 317:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31e:	eb 25                	jmp    345 <atoi+0x34>
    n = n*10 + *s++ - '0';
 320:	8b 55 fc             	mov    -0x4(%ebp),%edx
 323:	89 d0                	mov    %edx,%eax
 325:	c1 e0 02             	shl    $0x2,%eax
 328:	01 d0                	add    %edx,%eax
 32a:	01 c0                	add    %eax,%eax
 32c:	89 c1                	mov    %eax,%ecx
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	8d 50 01             	lea    0x1(%eax),%edx
 334:	89 55 08             	mov    %edx,0x8(%ebp)
 337:	0f b6 00             	movzbl (%eax),%eax
 33a:	0f be c0             	movsbl %al,%eax
 33d:	01 c8                	add    %ecx,%eax
 33f:	83 e8 30             	sub    $0x30,%eax
 342:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 345:	8b 45 08             	mov    0x8(%ebp),%eax
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	3c 2f                	cmp    $0x2f,%al
 34d:	7e 0a                	jle    359 <atoi+0x48>
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	0f b6 00             	movzbl (%eax),%eax
 355:	3c 39                	cmp    $0x39,%al
 357:	7e c7                	jle    320 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 359:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 370:	eb 17                	jmp    389 <memmove+0x2b>
    *dst++ = *src++;
 372:	8b 45 fc             	mov    -0x4(%ebp),%eax
 375:	8d 50 01             	lea    0x1(%eax),%edx
 378:	89 55 fc             	mov    %edx,-0x4(%ebp)
 37b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37e:	8d 4a 01             	lea    0x1(%edx),%ecx
 381:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 384:	0f b6 12             	movzbl (%edx),%edx
 387:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 389:	8b 45 10             	mov    0x10(%ebp),%eax
 38c:	8d 50 ff             	lea    -0x1(%eax),%edx
 38f:	89 55 10             	mov    %edx,0x10(%ebp)
 392:	85 c0                	test   %eax,%eax
 394:	7f dc                	jg     372 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 396:	8b 45 08             	mov    0x8(%ebp),%eax
}
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 39b:	b8 01 00 00 00       	mov    $0x1,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <exit>:
SYSCALL(exit)
 3a3:	b8 02 00 00 00       	mov    $0x2,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <wait>:
SYSCALL(wait)
 3ab:	b8 03 00 00 00       	mov    $0x3,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <pipe>:
SYSCALL(pipe)
 3b3:	b8 04 00 00 00       	mov    $0x4,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <read>:
SYSCALL(read)
 3bb:	b8 05 00 00 00       	mov    $0x5,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <write>:
SYSCALL(write)
 3c3:	b8 10 00 00 00       	mov    $0x10,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <close>:
SYSCALL(close)
 3cb:	b8 15 00 00 00       	mov    $0x15,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <kill>:
SYSCALL(kill)
 3d3:	b8 06 00 00 00       	mov    $0x6,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <exec>:
SYSCALL(exec)
 3db:	b8 07 00 00 00       	mov    $0x7,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <open>:
SYSCALL(open)
 3e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <mknod>:
SYSCALL(mknod)
 3eb:	b8 11 00 00 00       	mov    $0x11,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <unlink>:
SYSCALL(unlink)
 3f3:	b8 12 00 00 00       	mov    $0x12,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <fstat>:
SYSCALL(fstat)
 3fb:	b8 08 00 00 00       	mov    $0x8,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <link>:
SYSCALL(link)
 403:	b8 13 00 00 00       	mov    $0x13,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <mkdir>:
SYSCALL(mkdir)
 40b:	b8 14 00 00 00       	mov    $0x14,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <chdir>:
SYSCALL(chdir)
 413:	b8 09 00 00 00       	mov    $0x9,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <dup>:
SYSCALL(dup)
 41b:	b8 0a 00 00 00       	mov    $0xa,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <getpid>:
SYSCALL(getpid)
 423:	b8 0b 00 00 00       	mov    $0xb,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <sbrk>:
SYSCALL(sbrk)
 42b:	b8 0c 00 00 00       	mov    $0xc,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <sleep>:
SYSCALL(sleep)
 433:	b8 0d 00 00 00       	mov    $0xd,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <uptime>:
SYSCALL(uptime)
 43b:	b8 0e 00 00 00       	mov    $0xe,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <my_syscall>:
SYSCALL(my_syscall)
 443:	b8 16 00 00 00       	mov    $0x16,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <getppid>:
SYSCALL(getppid)
 44b:	b8 17 00 00 00       	mov    $0x17,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <yield>:
SYSCALL(yield)
 453:	b8 18 00 00 00       	mov    $0x18,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <getlev>:
SYSCALL(getlev)
 45b:	b8 19 00 00 00       	mov    $0x19,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <set_cpu_share>:
SYSCALL(set_cpu_share)
 463:	b8 1a 00 00 00       	mov    $0x1a,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <thread_create>:
SYSCALL(thread_create)
 46b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <thread_exit>:
SYSCALL(thread_exit)
 473:	b8 1c 00 00 00       	mov    $0x1c,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <thread_join>:
SYSCALL(thread_join)
 47b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <gettid>:
SYSCALL(gettid)
 483:	b8 1e 00 00 00       	mov    $0x1e,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 48b:	55                   	push   %ebp
 48c:	89 e5                	mov    %esp,%ebp
 48e:	83 ec 18             	sub    $0x18,%esp
 491:	8b 45 0c             	mov    0xc(%ebp),%eax
 494:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 497:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 49e:	00 
 49f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a6:	8b 45 08             	mov    0x8(%ebp),%eax
 4a9:	89 04 24             	mov    %eax,(%esp)
 4ac:	e8 12 ff ff ff       	call   3c3 <write>
}
 4b1:	c9                   	leave  
 4b2:	c3                   	ret    

000004b3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b3:	55                   	push   %ebp
 4b4:	89 e5                	mov    %esp,%ebp
 4b6:	56                   	push   %esi
 4b7:	53                   	push   %ebx
 4b8:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4c2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4c6:	74 17                	je     4df <printint+0x2c>
 4c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4cc:	79 11                	jns    4df <printint+0x2c>
    neg = 1;
 4ce:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d8:	f7 d8                	neg    %eax
 4da:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4dd:	eb 06                	jmp    4e5 <printint+0x32>
  } else {
    x = xx;
 4df:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ec:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4ef:	8d 41 01             	lea    0x1(%ecx),%eax
 4f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4fb:	ba 00 00 00 00       	mov    $0x0,%edx
 500:	f7 f3                	div    %ebx
 502:	89 d0                	mov    %edx,%eax
 504:	0f b6 80 dc 0b 00 00 	movzbl 0xbdc(%eax),%eax
 50b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 50f:	8b 75 10             	mov    0x10(%ebp),%esi
 512:	8b 45 ec             	mov    -0x14(%ebp),%eax
 515:	ba 00 00 00 00       	mov    $0x0,%edx
 51a:	f7 f6                	div    %esi
 51c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 51f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 523:	75 c7                	jne    4ec <printint+0x39>
  if(neg)
 525:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 529:	74 10                	je     53b <printint+0x88>
    buf[i++] = '-';
 52b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52e:	8d 50 01             	lea    0x1(%eax),%edx
 531:	89 55 f4             	mov    %edx,-0xc(%ebp)
 534:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 539:	eb 1f                	jmp    55a <printint+0xa7>
 53b:	eb 1d                	jmp    55a <printint+0xa7>
    putc(fd, buf[i]);
 53d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 540:	8b 45 f4             	mov    -0xc(%ebp),%eax
 543:	01 d0                	add    %edx,%eax
 545:	0f b6 00             	movzbl (%eax),%eax
 548:	0f be c0             	movsbl %al,%eax
 54b:	89 44 24 04          	mov    %eax,0x4(%esp)
 54f:	8b 45 08             	mov    0x8(%ebp),%eax
 552:	89 04 24             	mov    %eax,(%esp)
 555:	e8 31 ff ff ff       	call   48b <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 55a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 55e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 562:	79 d9                	jns    53d <printint+0x8a>
    putc(fd, buf[i]);
}
 564:	83 c4 30             	add    $0x30,%esp
 567:	5b                   	pop    %ebx
 568:	5e                   	pop    %esi
 569:	5d                   	pop    %ebp
 56a:	c3                   	ret    

0000056b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 56b:	55                   	push   %ebp
 56c:	89 e5                	mov    %esp,%ebp
 56e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 571:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 578:	8d 45 0c             	lea    0xc(%ebp),%eax
 57b:	83 c0 04             	add    $0x4,%eax
 57e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 581:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 588:	e9 7c 01 00 00       	jmp    709 <printf+0x19e>
    c = fmt[i] & 0xff;
 58d:	8b 55 0c             	mov    0xc(%ebp),%edx
 590:	8b 45 f0             	mov    -0x10(%ebp),%eax
 593:	01 d0                	add    %edx,%eax
 595:	0f b6 00             	movzbl (%eax),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	25 ff 00 00 00       	and    $0xff,%eax
 5a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a7:	75 2c                	jne    5d5 <printf+0x6a>
      if(c == '%'){
 5a9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ad:	75 0c                	jne    5bb <printf+0x50>
        state = '%';
 5af:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5b6:	e9 4a 01 00 00       	jmp    705 <printf+0x19a>
      } else {
        putc(fd, c);
 5bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	89 04 24             	mov    %eax,(%esp)
 5cb:	e8 bb fe ff ff       	call   48b <putc>
 5d0:	e9 30 01 00 00       	jmp    705 <printf+0x19a>
      }
    } else if(state == '%'){
 5d5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5d9:	0f 85 26 01 00 00    	jne    705 <printf+0x19a>
      if(c == 'd'){
 5df:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5e3:	75 2d                	jne    612 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5f1:	00 
 5f2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5f9:	00 
 5fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fe:	8b 45 08             	mov    0x8(%ebp),%eax
 601:	89 04 24             	mov    %eax,(%esp)
 604:	e8 aa fe ff ff       	call   4b3 <printint>
        ap++;
 609:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60d:	e9 ec 00 00 00       	jmp    6fe <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 612:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 616:	74 06                	je     61e <printf+0xb3>
 618:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 61c:	75 2d                	jne    64b <printf+0xe0>
        printint(fd, *ap, 16, 0);
 61e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 62a:	00 
 62b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 632:	00 
 633:	89 44 24 04          	mov    %eax,0x4(%esp)
 637:	8b 45 08             	mov    0x8(%ebp),%eax
 63a:	89 04 24             	mov    %eax,(%esp)
 63d:	e8 71 fe ff ff       	call   4b3 <printint>
        ap++;
 642:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 646:	e9 b3 00 00 00       	jmp    6fe <printf+0x193>
      } else if(c == 's'){
 64b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 64f:	75 45                	jne    696 <printf+0x12b>
        s = (char*)*ap;
 651:	8b 45 e8             	mov    -0x18(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 659:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 65d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 661:	75 09                	jne    66c <printf+0x101>
          s = "(null)";
 663:	c7 45 f4 6f 09 00 00 	movl   $0x96f,-0xc(%ebp)
        while(*s != 0){
 66a:	eb 1e                	jmp    68a <printf+0x11f>
 66c:	eb 1c                	jmp    68a <printf+0x11f>
          putc(fd, *s);
 66e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 671:	0f b6 00             	movzbl (%eax),%eax
 674:	0f be c0             	movsbl %al,%eax
 677:	89 44 24 04          	mov    %eax,0x4(%esp)
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	89 04 24             	mov    %eax,(%esp)
 681:	e8 05 fe ff ff       	call   48b <putc>
          s++;
 686:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 68a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68d:	0f b6 00             	movzbl (%eax),%eax
 690:	84 c0                	test   %al,%al
 692:	75 da                	jne    66e <printf+0x103>
 694:	eb 68                	jmp    6fe <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 696:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 69a:	75 1d                	jne    6b9 <printf+0x14e>
        putc(fd, *ap);
 69c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	0f be c0             	movsbl %al,%eax
 6a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a8:	8b 45 08             	mov    0x8(%ebp),%eax
 6ab:	89 04 24             	mov    %eax,(%esp)
 6ae:	e8 d8 fd ff ff       	call   48b <putc>
        ap++;
 6b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b7:	eb 45                	jmp    6fe <printf+0x193>
      } else if(c == '%'){
 6b9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6bd:	75 17                	jne    6d6 <printf+0x16b>
        putc(fd, c);
 6bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c2:	0f be c0             	movsbl %al,%eax
 6c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	89 04 24             	mov    %eax,(%esp)
 6cf:	e8 b7 fd ff ff       	call   48b <putc>
 6d4:	eb 28                	jmp    6fe <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6d6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6dd:	00 
 6de:	8b 45 08             	mov    0x8(%ebp),%eax
 6e1:	89 04 24             	mov    %eax,(%esp)
 6e4:	e8 a2 fd ff ff       	call   48b <putc>
        putc(fd, c);
 6e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ec:	0f be c0             	movsbl %al,%eax
 6ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f3:	8b 45 08             	mov    0x8(%ebp),%eax
 6f6:	89 04 24             	mov    %eax,(%esp)
 6f9:	e8 8d fd ff ff       	call   48b <putc>
      }
      state = 0;
 6fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 705:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 709:	8b 55 0c             	mov    0xc(%ebp),%edx
 70c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70f:	01 d0                	add    %edx,%eax
 711:	0f b6 00             	movzbl (%eax),%eax
 714:	84 c0                	test   %al,%al
 716:	0f 85 71 fe ff ff    	jne    58d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 71c:	c9                   	leave  
 71d:	c3                   	ret    

0000071e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71e:	55                   	push   %ebp
 71f:	89 e5                	mov    %esp,%ebp
 721:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	83 e8 08             	sub    $0x8,%eax
 72a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72d:	a1 08 0c 00 00       	mov    0xc08,%eax
 732:	89 45 fc             	mov    %eax,-0x4(%ebp)
 735:	eb 24                	jmp    75b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 00                	mov    (%eax),%eax
 73c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73f:	77 12                	ja     753 <free+0x35>
 741:	8b 45 f8             	mov    -0x8(%ebp),%eax
 744:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 747:	77 24                	ja     76d <free+0x4f>
 749:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 751:	77 1a                	ja     76d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	8b 00                	mov    (%eax),%eax
 758:	89 45 fc             	mov    %eax,-0x4(%ebp)
 75b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 761:	76 d4                	jbe    737 <free+0x19>
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 00                	mov    (%eax),%eax
 768:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76b:	76 ca                	jbe    737 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 76d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 770:	8b 40 04             	mov    0x4(%eax),%eax
 773:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77d:	01 c2                	add    %eax,%edx
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 00                	mov    (%eax),%eax
 784:	39 c2                	cmp    %eax,%edx
 786:	75 24                	jne    7ac <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 788:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78b:	8b 50 04             	mov    0x4(%eax),%edx
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	8b 00                	mov    (%eax),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	01 c2                	add    %eax,%edx
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 79e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a1:	8b 00                	mov    (%eax),%eax
 7a3:	8b 10                	mov    (%eax),%edx
 7a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a8:	89 10                	mov    %edx,(%eax)
 7aa:	eb 0a                	jmp    7b6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	8b 10                	mov    (%eax),%edx
 7b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	8b 40 04             	mov    0x4(%eax),%eax
 7bc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	01 d0                	add    %edx,%eax
 7c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cb:	75 20                	jne    7ed <free+0xcf>
    p->s.size += bp->s.size;
 7cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d0:	8b 50 04             	mov    0x4(%eax),%edx
 7d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d6:	8b 40 04             	mov    0x4(%eax),%eax
 7d9:	01 c2                	add    %eax,%edx
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e4:	8b 10                	mov    (%eax),%edx
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	89 10                	mov    %edx,(%eax)
 7eb:	eb 08                	jmp    7f5 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7f3:	89 10                	mov    %edx,(%eax)
  freep = p;
 7f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f8:	a3 08 0c 00 00       	mov    %eax,0xc08
}
 7fd:	c9                   	leave  
 7fe:	c3                   	ret    

000007ff <morecore>:

static Header*
morecore(uint nu)
{
 7ff:	55                   	push   %ebp
 800:	89 e5                	mov    %esp,%ebp
 802:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 805:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 80c:	77 07                	ja     815 <morecore+0x16>
    nu = 4096;
 80e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 815:	8b 45 08             	mov    0x8(%ebp),%eax
 818:	c1 e0 03             	shl    $0x3,%eax
 81b:	89 04 24             	mov    %eax,(%esp)
 81e:	e8 08 fc ff ff       	call   42b <sbrk>
 823:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 826:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 82a:	75 07                	jne    833 <morecore+0x34>
    return 0;
 82c:	b8 00 00 00 00       	mov    $0x0,%eax
 831:	eb 22                	jmp    855 <morecore+0x56>
  hp = (Header*)p;
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 839:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83c:	8b 55 08             	mov    0x8(%ebp),%edx
 83f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 845:	83 c0 08             	add    $0x8,%eax
 848:	89 04 24             	mov    %eax,(%esp)
 84b:	e8 ce fe ff ff       	call   71e <free>
  return freep;
 850:	a1 08 0c 00 00       	mov    0xc08,%eax
}
 855:	c9                   	leave  
 856:	c3                   	ret    

00000857 <malloc>:

void*
malloc(uint nbytes)
{
 857:	55                   	push   %ebp
 858:	89 e5                	mov    %esp,%ebp
 85a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85d:	8b 45 08             	mov    0x8(%ebp),%eax
 860:	83 c0 07             	add    $0x7,%eax
 863:	c1 e8 03             	shr    $0x3,%eax
 866:	83 c0 01             	add    $0x1,%eax
 869:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 86c:	a1 08 0c 00 00       	mov    0xc08,%eax
 871:	89 45 f0             	mov    %eax,-0x10(%ebp)
 874:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 878:	75 23                	jne    89d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 87a:	c7 45 f0 00 0c 00 00 	movl   $0xc00,-0x10(%ebp)
 881:	8b 45 f0             	mov    -0x10(%ebp),%eax
 884:	a3 08 0c 00 00       	mov    %eax,0xc08
 889:	a1 08 0c 00 00       	mov    0xc08,%eax
 88e:	a3 00 0c 00 00       	mov    %eax,0xc00
    base.s.size = 0;
 893:	c7 05 04 0c 00 00 00 	movl   $0x0,0xc04
 89a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a0:	8b 00                	mov    (%eax),%eax
 8a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	8b 40 04             	mov    0x4(%eax),%eax
 8ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ae:	72 4d                	jb     8fd <malloc+0xa6>
      if(p->s.size == nunits)
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	8b 40 04             	mov    0x4(%eax),%eax
 8b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b9:	75 0c                	jne    8c7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8b 10                	mov    (%eax),%edx
 8c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c3:	89 10                	mov    %edx,(%eax)
 8c5:	eb 26                	jmp    8ed <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ca:	8b 40 04             	mov    0x4(%eax),%eax
 8cd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8d0:	89 c2                	mov    %eax,%edx
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 40 04             	mov    0x4(%eax),%eax
 8de:	c1 e0 03             	shl    $0x3,%eax
 8e1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ea:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f0:	a3 08 0c 00 00       	mov    %eax,0xc08
      return (void*)(p + 1);
 8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f8:	83 c0 08             	add    $0x8,%eax
 8fb:	eb 38                	jmp    935 <malloc+0xde>
    }
    if(p == freep)
 8fd:	a1 08 0c 00 00       	mov    0xc08,%eax
 902:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 905:	75 1b                	jne    922 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 907:	8b 45 ec             	mov    -0x14(%ebp),%eax
 90a:	89 04 24             	mov    %eax,(%esp)
 90d:	e8 ed fe ff ff       	call   7ff <morecore>
 912:	89 45 f4             	mov    %eax,-0xc(%ebp)
 915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 919:	75 07                	jne    922 <malloc+0xcb>
        return 0;
 91b:	b8 00 00 00 00       	mov    $0x0,%eax
 920:	eb 13                	jmp    935 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 922:	8b 45 f4             	mov    -0xc(%ebp),%eax
 925:	89 45 f0             	mov    %eax,-0x10(%ebp)
 928:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92b:	8b 00                	mov    (%eax),%eax
 92d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 930:	e9 70 ff ff ff       	jmp    8a5 <malloc+0x4e>
}
 935:	c9                   	leave  
 936:	c3                   	ret    

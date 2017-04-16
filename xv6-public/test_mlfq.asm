
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
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 30             	sub    $0x30,%esp
    uint i;
    int cnt_level[MLFQ_LEVEL] = {0, 0, 0};
    int do_yield;
    int curr_mlfq_level;

    if (argc < 2) {
   c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)

int
main(int argc, char *argv[])
{
    uint i;
    int cnt_level[MLFQ_LEVEL] = {0, 0, 0};
  10:	c7 44 24 24 00 00 00 	movl   $0x0,0x24(%esp)
  17:	00 
  18:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  1f:	00 
  20:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  27:	00 
    int do_yield;
    int curr_mlfq_level;

    if (argc < 2) {
  28:	0f 8e 9e 00 00 00    	jle    cc <main+0xcc>
        printf(1, "usage: sched_test_mlfq do_yield_or_not(0|1)\n");
        exit();
    }

    do_yield = atoi(argv[1]);
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax

    i = 0;
    while (1) {
        i++;
  31:	bb 01 00 00 00       	mov    $0x1,%ebx
        
        // Prevent code optimization
        __sync_synchronize();

        if (i % YIELD_PERIOD == 0) {
  36:	be 59 17 b7 d1       	mov    $0xd1b71759,%esi
    if (argc < 2) {
        printf(1, "usage: sched_test_mlfq do_yield_or_not(0|1)\n");
        exit();
    }

    do_yield = atoi(argv[1]);
  3b:	8b 40 04             	mov    0x4(%eax),%eax
  3e:	89 04 24             	mov    %eax,(%esp)
  41:	e8 6a 02 00 00       	call   2b0 <atoi>
    i = 0;
    while (1) {
        i++;
        
        // Prevent code optimization
        __sync_synchronize();
  46:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    if (argc < 2) {
        printf(1, "usage: sched_test_mlfq do_yield_or_not(0|1)\n");
        exit();
    }

    do_yield = atoi(argv[1]);
  4b:	89 c7                	mov    %eax,%edi
  4d:	8d 76 00             	lea    0x0(%esi),%esi

    i = 0;
    while (1) {
        i++;
  50:	83 c3 01             	add    $0x1,%ebx
        
        // Prevent code optimization
        __sync_synchronize();

        if (i % YIELD_PERIOD == 0) {
  53:	89 d8                	mov    %ebx,%eax
  55:	f7 e6                	mul    %esi
    i = 0;
    while (1) {
        i++;
        
        // Prevent code optimization
        __sync_synchronize();
  57:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

        if (i % YIELD_PERIOD == 0) {
  5c:	c1 ea 0d             	shr    $0xd,%edx
  5f:	69 d2 10 27 00 00    	imul   $0x2710,%edx,%edx
  65:	39 d3                	cmp    %edx,%ebx
  67:	75 e7                	jne    50 <main+0x50>
            // Get current MLFQ level(priority) of this process
            curr_mlfq_level = getlev();
  69:	e8 5c 03 00 00       	call   3ca <getlev>
            cnt_level[curr_mlfq_level]++;
  6e:	83 44 84 24 01       	addl   $0x1,0x24(%esp,%eax,4)

            if (i > LIFETIME) {
  73:	81 fb 00 c2 eb 0b    	cmp    $0xbebc200,%ebx
  79:	77 0d                	ja     88 <main+0x88>
                        do_yield==0 ? "compute" : "yield",
                        cnt_level[0], cnt_level[1], cnt_level[2]);
                break;
            }

            if (do_yield) {
  7b:	85 ff                	test   %edi,%edi
  7d:	74 d1                	je     50 <main+0x50>
                // Yield process itself, not by timer interrupt
                yield();
  7f:	e8 3e 03 00 00       	call   3c2 <yield>
  84:	eb ca                	jmp    50 <main+0x50>
  86:	66 90                	xchg   %ax,%ax
            // Get current MLFQ level(priority) of this process
            curr_mlfq_level = getlev();
            cnt_level[curr_mlfq_level]++;

            if (i > LIFETIME) {
                printf(1, "MLFQ(%s), lev[0]: %d, lev[1]: %d, lev[2]: %d\n",
  88:	85 ff                	test   %edi,%edi
  8a:	ba f0 07 00 00       	mov    $0x7f0,%edx
  8f:	b8 e8 07 00 00       	mov    $0x7e8,%eax
  94:	0f 45 c2             	cmovne %edx,%eax
  97:	8b 54 24 2c          	mov    0x2c(%esp),%edx
  9b:	89 44 24 08          	mov    %eax,0x8(%esp)
  9f:	c7 44 24 04 28 08 00 	movl   $0x828,0x4(%esp)
  a6:	00 
  a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ae:	89 54 24 14          	mov    %edx,0x14(%esp)
  b2:	8b 54 24 28          	mov    0x28(%esp),%edx
  b6:	89 54 24 10          	mov    %edx,0x10(%esp)
  ba:	8b 54 24 24          	mov    0x24(%esp),%edx
  be:	89 54 24 0c          	mov    %edx,0xc(%esp)
  c2:	e8 b9 03 00 00       	call   480 <printf>
                yield();
            }
        }
    }

    exit();
  c7:	e8 46 02 00 00       	call   312 <exit>
    int cnt_level[MLFQ_LEVEL] = {0, 0, 0};
    int do_yield;
    int curr_mlfq_level;

    if (argc < 2) {
        printf(1, "usage: sched_test_mlfq do_yield_or_not(0|1)\n");
  cc:	c7 44 24 04 f8 07 00 	movl   $0x7f8,0x4(%esp)
  d3:	00 
  d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  db:	e8 a0 03 00 00       	call   480 <printf>
        exit();
  e0:	e8 2d 02 00 00       	call   312 <exit>
  e5:	66 90                	xchg   %ax,%ax
  e7:	66 90                	xchg   %ax,%ax
  e9:	66 90                	xchg   %ax,%ax
  eb:	66 90                	xchg   %ax,%ax
  ed:	66 90                	xchg   %ax,%ax
  ef:	90                   	nop

000000f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  f9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fa:	89 c2                	mov    %eax,%edx
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 100:	83 c1 01             	add    $0x1,%ecx
 103:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 107:	83 c2 01             	add    $0x1,%edx
 10a:	84 db                	test   %bl,%bl
 10c:	88 5a ff             	mov    %bl,-0x1(%edx)
 10f:	75 ef                	jne    100 <strcpy+0x10>
    ;
  return os;
}
 111:	5b                   	pop    %ebx
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    
 114:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 11a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000120 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 55 08             	mov    0x8(%ebp),%edx
 126:	53                   	push   %ebx
 127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 12a:	0f b6 02             	movzbl (%edx),%eax
 12d:	84 c0                	test   %al,%al
 12f:	74 2d                	je     15e <strcmp+0x3e>
 131:	0f b6 19             	movzbl (%ecx),%ebx
 134:	38 d8                	cmp    %bl,%al
 136:	74 0e                	je     146 <strcmp+0x26>
 138:	eb 2b                	jmp    165 <strcmp+0x45>
 13a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 140:	38 c8                	cmp    %cl,%al
 142:	75 15                	jne    159 <strcmp+0x39>
    p++, q++;
 144:	89 d9                	mov    %ebx,%ecx
 146:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 149:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 14c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 14f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 153:	84 c0                	test   %al,%al
 155:	75 e9                	jne    140 <strcmp+0x20>
 157:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 159:	29 c8                	sub    %ecx,%eax
}
 15b:	5b                   	pop    %ebx
 15c:	5d                   	pop    %ebp
 15d:	c3                   	ret    
 15e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 161:	31 c0                	xor    %eax,%eax
 163:	eb f4                	jmp    159 <strcmp+0x39>
 165:	0f b6 cb             	movzbl %bl,%ecx
 168:	eb ef                	jmp    159 <strcmp+0x39>
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000170 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 176:	80 39 00             	cmpb   $0x0,(%ecx)
 179:	74 12                	je     18d <strlen+0x1d>
 17b:	31 d2                	xor    %edx,%edx
 17d:	8d 76 00             	lea    0x0(%esi),%esi
 180:	83 c2 01             	add    $0x1,%edx
 183:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 187:	89 d0                	mov    %edx,%eax
 189:	75 f5                	jne    180 <strlen+0x10>
    ;
  return n;
}
 18b:	5d                   	pop    %ebp
 18c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 18d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 18f:	5d                   	pop    %ebp
 190:	c3                   	ret    
 191:	eb 0d                	jmp    1a0 <memset>
 193:	90                   	nop
 194:	90                   	nop
 195:	90                   	nop
 196:	90                   	nop
 197:	90                   	nop
 198:	90                   	nop
 199:	90                   	nop
 19a:	90                   	nop
 19b:	90                   	nop
 19c:	90                   	nop
 19d:	90                   	nop
 19e:	90                   	nop
 19f:	90                   	nop

000001a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 55 08             	mov    0x8(%ebp),%edx
 1a6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ad:	89 d7                	mov    %edx,%edi
 1af:	fc                   	cld    
 1b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1b2:	89 d0                	mov    %edx,%eax
 1b4:	5f                   	pop    %edi
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	89 f6                	mov    %esi,%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <strchr>:

char*
strchr(const char *s, char c)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	53                   	push   %ebx
 1c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 1ca:	0f b6 18             	movzbl (%eax),%ebx
 1cd:	84 db                	test   %bl,%bl
 1cf:	74 1d                	je     1ee <strchr+0x2e>
    if(*s == c)
 1d1:	38 d3                	cmp    %dl,%bl
 1d3:	89 d1                	mov    %edx,%ecx
 1d5:	75 0d                	jne    1e4 <strchr+0x24>
 1d7:	eb 17                	jmp    1f0 <strchr+0x30>
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1e0:	38 ca                	cmp    %cl,%dl
 1e2:	74 0c                	je     1f0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e4:	83 c0 01             	add    $0x1,%eax
 1e7:	0f b6 10             	movzbl (%eax),%edx
 1ea:	84 d2                	test   %dl,%dl
 1ec:	75 f2                	jne    1e0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 1ee:	31 c0                	xor    %eax,%eax
}
 1f0:	5b                   	pop    %ebx
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    
 1f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 205:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 207:	53                   	push   %ebx
 208:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 20b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	eb 31                	jmp    241 <gets+0x41>
    cc = read(0, &c, 1);
 210:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 217:	00 
 218:	89 7c 24 04          	mov    %edi,0x4(%esp)
 21c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 223:	e8 02 01 00 00       	call   32a <read>
    if(cc < 1)
 228:	85 c0                	test   %eax,%eax
 22a:	7e 1d                	jle    249 <gets+0x49>
      break;
    buf[i++] = c;
 22c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 232:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 235:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 237:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 23b:	74 0c                	je     249 <gets+0x49>
 23d:	3c 0a                	cmp    $0xa,%al
 23f:	74 08                	je     249 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 241:	8d 5e 01             	lea    0x1(%esi),%ebx
 244:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 247:	7c c7                	jl     210 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 249:	8b 45 08             	mov    0x8(%ebp),%eax
 24c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 250:	83 c4 2c             	add    $0x2c,%esp
 253:	5b                   	pop    %ebx
 254:	5e                   	pop    %esi
 255:	5f                   	pop    %edi
 256:	5d                   	pop    %ebp
 257:	c3                   	ret    
 258:	90                   	nop
 259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000260 <stat>:

int
stat(char *n, struct stat *st)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	53                   	push   %ebx
 265:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 272:	00 
 273:	89 04 24             	mov    %eax,(%esp)
 276:	e8 d7 00 00 00       	call   352 <open>
  if(fd < 0)
 27b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 27f:	78 27                	js     2a8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 281:	8b 45 0c             	mov    0xc(%ebp),%eax
 284:	89 1c 24             	mov    %ebx,(%esp)
 287:	89 44 24 04          	mov    %eax,0x4(%esp)
 28b:	e8 da 00 00 00       	call   36a <fstat>
  close(fd);
 290:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 293:	89 c6                	mov    %eax,%esi
  close(fd);
 295:	e8 a0 00 00 00       	call   33a <close>
  return r;
 29a:	89 f0                	mov    %esi,%eax
}
 29c:	83 c4 10             	add    $0x10,%esp
 29f:	5b                   	pop    %ebx
 2a0:	5e                   	pop    %esi
 2a1:	5d                   	pop    %ebp
 2a2:	c3                   	ret    
 2a3:	90                   	nop
 2a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 2a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ad:	eb ed                	jmp    29c <stat+0x3c>
 2af:	90                   	nop

000002b0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2b6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b7:	0f be 11             	movsbl (%ecx),%edx
 2ba:	8d 42 d0             	lea    -0x30(%edx),%eax
 2bd:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2c4:	77 17                	ja     2dd <atoi+0x2d>
 2c6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2c8:	83 c1 01             	add    $0x1,%ecx
 2cb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2ce:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d2:	0f be 11             	movsbl (%ecx),%edx
 2d5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2d8:	80 fb 09             	cmp    $0x9,%bl
 2db:	76 eb                	jbe    2c8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 2dd:	5b                   	pop    %ebx
 2de:	5d                   	pop    %ebp
 2df:	c3                   	ret    

000002e0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	56                   	push   %esi
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	53                   	push   %ebx
 2ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2ed:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f0:	85 db                	test   %ebx,%ebx
 2f2:	7e 12                	jle    306 <memmove+0x26>
 2f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2f8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2ff:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 302:	39 da                	cmp    %ebx,%edx
 304:	75 f2                	jne    2f8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 306:	5b                   	pop    %ebx
 307:	5e                   	pop    %esi
 308:	5d                   	pop    %ebp
 309:	c3                   	ret    

0000030a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 30a:	b8 01 00 00 00       	mov    $0x1,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <exit>:
SYSCALL(exit)
 312:	b8 02 00 00 00       	mov    $0x2,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <wait>:
SYSCALL(wait)
 31a:	b8 03 00 00 00       	mov    $0x3,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <pipe>:
SYSCALL(pipe)
 322:	b8 04 00 00 00       	mov    $0x4,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <read>:
SYSCALL(read)
 32a:	b8 05 00 00 00       	mov    $0x5,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <write>:
SYSCALL(write)
 332:	b8 10 00 00 00       	mov    $0x10,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <close>:
SYSCALL(close)
 33a:	b8 15 00 00 00       	mov    $0x15,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <kill>:
SYSCALL(kill)
 342:	b8 06 00 00 00       	mov    $0x6,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <exec>:
SYSCALL(exec)
 34a:	b8 07 00 00 00       	mov    $0x7,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <open>:
SYSCALL(open)
 352:	b8 0f 00 00 00       	mov    $0xf,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <mknod>:
SYSCALL(mknod)
 35a:	b8 11 00 00 00       	mov    $0x11,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <unlink>:
SYSCALL(unlink)
 362:	b8 12 00 00 00       	mov    $0x12,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <fstat>:
SYSCALL(fstat)
 36a:	b8 08 00 00 00       	mov    $0x8,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <link>:
SYSCALL(link)
 372:	b8 13 00 00 00       	mov    $0x13,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <mkdir>:
SYSCALL(mkdir)
 37a:	b8 14 00 00 00       	mov    $0x14,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <chdir>:
SYSCALL(chdir)
 382:	b8 09 00 00 00       	mov    $0x9,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <dup>:
SYSCALL(dup)
 38a:	b8 0a 00 00 00       	mov    $0xa,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <getpid>:
SYSCALL(getpid)
 392:	b8 0b 00 00 00       	mov    $0xb,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <sbrk>:
SYSCALL(sbrk)
 39a:	b8 0c 00 00 00       	mov    $0xc,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <sleep>:
SYSCALL(sleep)
 3a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <uptime>:
SYSCALL(uptime)
 3aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <my_syscall>:
SYSCALL(my_syscall)
 3b2:	b8 16 00 00 00       	mov    $0x16,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <getppid>:
SYSCALL(getppid)
 3ba:	b8 17 00 00 00       	mov    $0x17,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <yield>:
SYSCALL(yield)
 3c2:	b8 18 00 00 00       	mov    $0x18,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <getlev>:
SYSCALL(getlev)
 3ca:	b8 19 00 00 00       	mov    $0x19,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <set_cpu_share>:
SYSCALL(set_cpu_share)
 3d2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    
 3da:	66 90                	xchg   %ax,%ax
 3dc:	66 90                	xchg   %ax,%ax
 3de:	66 90                	xchg   %ax,%ax

000003e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	89 c6                	mov    %eax,%esi
 3e7:	53                   	push   %ebx
 3e8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3ee:	85 db                	test   %ebx,%ebx
 3f0:	74 09                	je     3fb <printint+0x1b>
 3f2:	89 d0                	mov    %edx,%eax
 3f4:	c1 e8 1f             	shr    $0x1f,%eax
 3f7:	84 c0                	test   %al,%al
 3f9:	75 75                	jne    470 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3fb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3fd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 404:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 407:	31 ff                	xor    %edi,%edi
 409:	89 ce                	mov    %ecx,%esi
 40b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 40e:	eb 02                	jmp    412 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 410:	89 cf                	mov    %ecx,%edi
 412:	31 d2                	xor    %edx,%edx
 414:	f7 f6                	div    %esi
 416:	8d 4f 01             	lea    0x1(%edi),%ecx
 419:	0f b6 92 5f 08 00 00 	movzbl 0x85f(%edx),%edx
  }while((x /= base) != 0);
 420:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 422:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 425:	75 e9                	jne    410 <printint+0x30>
  if(neg)
 427:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 42a:	89 c8                	mov    %ecx,%eax
 42c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 42f:	85 d2                	test   %edx,%edx
 431:	74 08                	je     43b <printint+0x5b>
    buf[i++] = '-';
 433:	8d 4f 02             	lea    0x2(%edi),%ecx
 436:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 43b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 43e:	66 90                	xchg   %ax,%ax
 440:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 445:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 448:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 44f:	00 
 450:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 454:	89 34 24             	mov    %esi,(%esp)
 457:	88 45 d7             	mov    %al,-0x29(%ebp)
 45a:	e8 d3 fe ff ff       	call   332 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 45f:	83 ff ff             	cmp    $0xffffffff,%edi
 462:	75 dc                	jne    440 <printint+0x60>
    putc(fd, buf[i]);
}
 464:	83 c4 4c             	add    $0x4c,%esp
 467:	5b                   	pop    %ebx
 468:	5e                   	pop    %esi
 469:	5f                   	pop    %edi
 46a:	5d                   	pop    %ebp
 46b:	c3                   	ret    
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 470:	89 d0                	mov    %edx,%eax
 472:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 474:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 47b:	eb 87                	jmp    404 <printint+0x24>
 47d:	8d 76 00             	lea    0x0(%esi),%esi

00000480 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 484:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 486:	56                   	push   %esi
 487:	53                   	push   %ebx
 488:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 48b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 48e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 491:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 494:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 497:	0f b6 13             	movzbl (%ebx),%edx
 49a:	83 c3 01             	add    $0x1,%ebx
 49d:	84 d2                	test   %dl,%dl
 49f:	75 39                	jne    4da <printf+0x5a>
 4a1:	e9 c2 00 00 00       	jmp    568 <printf+0xe8>
 4a6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4a8:	83 fa 25             	cmp    $0x25,%edx
 4ab:	0f 84 bf 00 00 00    	je     570 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4b1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4bb:	00 
 4bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4c3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4c6:	e8 67 fe ff ff       	call   332 <write>
 4cb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4ce:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4d2:	84 d2                	test   %dl,%dl
 4d4:	0f 84 8e 00 00 00    	je     568 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 4da:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4dc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 4df:	74 c7                	je     4a8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e1:	83 ff 25             	cmp    $0x25,%edi
 4e4:	75 e5                	jne    4cb <printf+0x4b>
      if(c == 'd'){
 4e6:	83 fa 64             	cmp    $0x64,%edx
 4e9:	0f 84 31 01 00 00    	je     620 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4ef:	25 f7 00 00 00       	and    $0xf7,%eax
 4f4:	83 f8 70             	cmp    $0x70,%eax
 4f7:	0f 84 83 00 00 00    	je     580 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4fd:	83 fa 73             	cmp    $0x73,%edx
 500:	0f 84 a2 00 00 00    	je     5a8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 506:	83 fa 63             	cmp    $0x63,%edx
 509:	0f 84 35 01 00 00    	je     644 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 50f:	83 fa 25             	cmp    $0x25,%edx
 512:	0f 84 e0 00 00 00    	je     5f8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 518:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 51b:	83 c3 01             	add    $0x1,%ebx
 51e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 525:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 526:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 528:	89 44 24 04          	mov    %eax,0x4(%esp)
 52c:	89 34 24             	mov    %esi,(%esp)
 52f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 532:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 536:	e8 f7 fd ff ff       	call   332 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 53b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 53e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 541:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 548:	00 
 549:	89 44 24 04          	mov    %eax,0x4(%esp)
 54d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 550:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 553:	e8 da fd ff ff       	call   332 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 558:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 55c:	84 d2                	test   %dl,%dl
 55e:	0f 85 76 ff ff ff    	jne    4da <printf+0x5a>
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 568:	83 c4 3c             	add    $0x3c,%esp
 56b:	5b                   	pop    %ebx
 56c:	5e                   	pop    %esi
 56d:	5f                   	pop    %edi
 56e:	5d                   	pop    %ebp
 56f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 570:	bf 25 00 00 00       	mov    $0x25,%edi
 575:	e9 51 ff ff ff       	jmp    4cb <printf+0x4b>
 57a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 583:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 588:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 58a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 591:	8b 10                	mov    (%eax),%edx
 593:	89 f0                	mov    %esi,%eax
 595:	e8 46 fe ff ff       	call   3e0 <printint>
        ap++;
 59a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 59e:	e9 28 ff ff ff       	jmp    4cb <printf+0x4b>
 5a3:	90                   	nop
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 5a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 5ab:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5af:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 5b1:	b8 58 08 00 00       	mov    $0x858,%eax
 5b6:	85 ff                	test   %edi,%edi
 5b8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 5bb:	0f b6 07             	movzbl (%edi),%eax
 5be:	84 c0                	test   %al,%al
 5c0:	74 2a                	je     5ec <printf+0x16c>
 5c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5c8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5cb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 5ce:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d8:	00 
 5d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5dd:	89 34 24             	mov    %esi,(%esp)
 5e0:	e8 4d fd ff ff       	call   332 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e5:	0f b6 07             	movzbl (%edi),%eax
 5e8:	84 c0                	test   %al,%al
 5ea:	75 dc                	jne    5c8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ec:	31 ff                	xor    %edi,%edi
 5ee:	e9 d8 fe ff ff       	jmp    4cb <printf+0x4b>
 5f3:	90                   	nop
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5fb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 604:	00 
 605:	89 44 24 04          	mov    %eax,0x4(%esp)
 609:	89 34 24             	mov    %esi,(%esp)
 60c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 610:	e8 1d fd ff ff       	call   332 <write>
 615:	e9 b1 fe ff ff       	jmp    4cb <printf+0x4b>
 61a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 620:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 623:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 628:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 62b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 632:	8b 10                	mov    (%eax),%edx
 634:	89 f0                	mov    %esi,%eax
 636:	e8 a5 fd ff ff       	call   3e0 <printint>
        ap++;
 63b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 63f:	e9 87 fe ff ff       	jmp    4cb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 644:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 647:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 649:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 652:	00 
 653:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 656:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 659:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 65c:	89 44 24 04          	mov    %eax,0x4(%esp)
 660:	e8 cd fc ff ff       	call   332 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 665:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 669:	e9 5d fe ff ff       	jmp    4cb <printf+0x4b>
 66e:	66 90                	xchg   %ax,%ax

00000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	a1 d8 0a 00 00       	mov    0xad8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 676:	89 e5                	mov    %esp,%ebp
 678:	57                   	push   %edi
 679:	56                   	push   %esi
 67a:	53                   	push   %ebx
 67b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 680:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 683:	39 d0                	cmp    %edx,%eax
 685:	72 11                	jb     698 <free+0x28>
 687:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 688:	39 c8                	cmp    %ecx,%eax
 68a:	72 04                	jb     690 <free+0x20>
 68c:	39 ca                	cmp    %ecx,%edx
 68e:	72 10                	jb     6a0 <free+0x30>
 690:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 692:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 694:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 696:	73 f0                	jae    688 <free+0x18>
 698:	39 ca                	cmp    %ecx,%edx
 69a:	72 04                	jb     6a0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69c:	39 c8                	cmp    %ecx,%eax
 69e:	72 f0                	jb     690 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6a3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 6a6:	39 cf                	cmp    %ecx,%edi
 6a8:	74 1e                	je     6c8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6aa:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ad:	8b 48 04             	mov    0x4(%eax),%ecx
 6b0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6b3:	39 f2                	cmp    %esi,%edx
 6b5:	74 28                	je     6df <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6b7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b9:	a3 d8 0a 00 00       	mov    %eax,0xad8
}
 6be:	5b                   	pop    %ebx
 6bf:	5e                   	pop    %esi
 6c0:	5f                   	pop    %edi
 6c1:	5d                   	pop    %ebp
 6c2:	c3                   	ret    
 6c3:	90                   	nop
 6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6c8:	03 71 04             	add    0x4(%ecx),%esi
 6cb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ce:	8b 08                	mov    (%eax),%ecx
 6d0:	8b 09                	mov    (%ecx),%ecx
 6d2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6d5:	8b 48 04             	mov    0x4(%eax),%ecx
 6d8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6db:	39 f2                	cmp    %esi,%edx
 6dd:	75 d8                	jne    6b7 <free+0x47>
    p->s.size += bp->s.size;
 6df:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6e2:	a3 d8 0a 00 00       	mov    %eax,0xad8
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6e7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ea:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6ed:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6ef:	5b                   	pop    %ebx
 6f0:	5e                   	pop    %esi
 6f1:	5f                   	pop    %edi
 6f2:	5d                   	pop    %ebp
 6f3:	c3                   	ret    
 6f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000700 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	53                   	push   %ebx
 706:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 709:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 70c:	8b 1d d8 0a 00 00    	mov    0xad8,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 712:	8d 48 07             	lea    0x7(%eax),%ecx
 715:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 718:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 71d:	0f 84 9b 00 00 00    	je     7be <malloc+0xbe>
 723:	8b 13                	mov    (%ebx),%edx
 725:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 728:	39 fe                	cmp    %edi,%esi
 72a:	76 64                	jbe    790 <malloc+0x90>
 72c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 733:	bb 00 80 00 00       	mov    $0x8000,%ebx
 738:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 73b:	eb 0e                	jmp    74b <malloc+0x4b>
 73d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 740:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 742:	8b 78 04             	mov    0x4(%eax),%edi
 745:	39 fe                	cmp    %edi,%esi
 747:	76 4f                	jbe    798 <malloc+0x98>
 749:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 74b:	3b 15 d8 0a 00 00    	cmp    0xad8,%edx
 751:	75 ed                	jne    740 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 756:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 75c:	bf 00 10 00 00       	mov    $0x1000,%edi
 761:	0f 43 fe             	cmovae %esi,%edi
 764:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 767:	89 04 24             	mov    %eax,(%esp)
 76a:	e8 2b fc ff ff       	call   39a <sbrk>
  if(p == (char*)-1)
 76f:	83 f8 ff             	cmp    $0xffffffff,%eax
 772:	74 18                	je     78c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 774:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 777:	83 c0 08             	add    $0x8,%eax
 77a:	89 04 24             	mov    %eax,(%esp)
 77d:	e8 ee fe ff ff       	call   670 <free>
  return freep;
 782:	8b 15 d8 0a 00 00    	mov    0xad8,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 788:	85 d2                	test   %edx,%edx
 78a:	75 b4                	jne    740 <malloc+0x40>
        return 0;
 78c:	31 c0                	xor    %eax,%eax
 78e:	eb 20                	jmp    7b0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 790:	89 d0                	mov    %edx,%eax
 792:	89 da                	mov    %ebx,%edx
 794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 798:	39 fe                	cmp    %edi,%esi
 79a:	74 1c                	je     7b8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 79c:	29 f7                	sub    %esi,%edi
 79e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 7a1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 7a4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 7a7:	89 15 d8 0a 00 00    	mov    %edx,0xad8
      return (void*)(p + 1);
 7ad:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b0:	83 c4 1c             	add    $0x1c,%esp
 7b3:	5b                   	pop    %ebx
 7b4:	5e                   	pop    %esi
 7b5:	5f                   	pop    %edi
 7b6:	5d                   	pop    %ebp
 7b7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7b8:	8b 08                	mov    (%eax),%ecx
 7ba:	89 0a                	mov    %ecx,(%edx)
 7bc:	eb e9                	jmp    7a7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7be:	c7 05 d8 0a 00 00 dc 	movl   $0xadc,0xad8
 7c5:	0a 00 00 
    base.s.size = 0;
 7c8:	ba dc 0a 00 00       	mov    $0xadc,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7cd:	c7 05 dc 0a 00 00 dc 	movl   $0xadc,0xadc
 7d4:	0a 00 00 
    base.s.size = 0;
 7d7:	c7 05 e0 0a 00 00 00 	movl   $0x0,0xae0
 7de:	00 00 00 
 7e1:	e9 46 ff ff ff       	jmp    72c <malloc+0x2c>


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
  8a:	ba 10 08 00 00       	mov    $0x810,%edx
  8f:	b8 08 08 00 00       	mov    $0x808,%eax
  94:	0f 45 c2             	cmovne %edx,%eax
  97:	8b 54 24 2c          	mov    0x2c(%esp),%edx
  9b:	89 44 24 08          	mov    %eax,0x8(%esp)
  9f:	c7 44 24 04 48 08 00 	movl   $0x848,0x4(%esp)
  a6:	00 
  a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ae:	89 54 24 14          	mov    %edx,0x14(%esp)
  b2:	8b 54 24 28          	mov    0x28(%esp),%edx
  b6:	89 54 24 10          	mov    %edx,0x10(%esp)
  ba:	8b 54 24 24          	mov    0x24(%esp),%edx
  be:	89 54 24 0c          	mov    %edx,0xc(%esp)
  c2:	e8 d9 03 00 00       	call   4a0 <printf>
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
  cc:	c7 44 24 04 18 08 00 	movl   $0x818,0x4(%esp)
  d3:	00 
  d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  db:	e8 c0 03 00 00       	call   4a0 <printf>
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

000003da <thread_create>:
SYSCALL(thread_create)
 3da:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <thread_exit>:
SYSCALL(thread_exit)
 3e2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <thread_join>:
SYSCALL(thread_join)
 3ea:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <gettid>:
SYSCALL(gettid)
 3f2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    
 3fa:	66 90                	xchg   %ax,%ax
 3fc:	66 90                	xchg   %ax,%ax
 3fe:	66 90                	xchg   %ax,%ax

00000400 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	89 c6                	mov    %eax,%esi
 407:	53                   	push   %ebx
 408:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 40e:	85 db                	test   %ebx,%ebx
 410:	74 09                	je     41b <printint+0x1b>
 412:	89 d0                	mov    %edx,%eax
 414:	c1 e8 1f             	shr    $0x1f,%eax
 417:	84 c0                	test   %al,%al
 419:	75 75                	jne    490 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 41b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 41d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 424:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 427:	31 ff                	xor    %edi,%edi
 429:	89 ce                	mov    %ecx,%esi
 42b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 42e:	eb 02                	jmp    432 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 430:	89 cf                	mov    %ecx,%edi
 432:	31 d2                	xor    %edx,%edx
 434:	f7 f6                	div    %esi
 436:	8d 4f 01             	lea    0x1(%edi),%ecx
 439:	0f b6 92 7f 08 00 00 	movzbl 0x87f(%edx),%edx
  }while((x /= base) != 0);
 440:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 442:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 445:	75 e9                	jne    430 <printint+0x30>
  if(neg)
 447:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 44a:	89 c8                	mov    %ecx,%eax
 44c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 44f:	85 d2                	test   %edx,%edx
 451:	74 08                	je     45b <printint+0x5b>
    buf[i++] = '-';
 453:	8d 4f 02             	lea    0x2(%edi),%ecx
 456:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 45b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 45e:	66 90                	xchg   %ax,%ax
 460:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 465:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 468:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 46f:	00 
 470:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 474:	89 34 24             	mov    %esi,(%esp)
 477:	88 45 d7             	mov    %al,-0x29(%ebp)
 47a:	e8 b3 fe ff ff       	call   332 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 47f:	83 ff ff             	cmp    $0xffffffff,%edi
 482:	75 dc                	jne    460 <printint+0x60>
    putc(fd, buf[i]);
}
 484:	83 c4 4c             	add    $0x4c,%esp
 487:	5b                   	pop    %ebx
 488:	5e                   	pop    %esi
 489:	5f                   	pop    %edi
 48a:	5d                   	pop    %ebp
 48b:	c3                   	ret    
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 490:	89 d0                	mov    %edx,%eax
 492:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 494:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 49b:	eb 87                	jmp    424 <printint+0x24>
 49d:	8d 76 00             	lea    0x0(%esi),%esi

000004a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4a4:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a6:	56                   	push   %esi
 4a7:	53                   	push   %ebx
 4a8:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4ae:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b1:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 4b7:	0f b6 13             	movzbl (%ebx),%edx
 4ba:	83 c3 01             	add    $0x1,%ebx
 4bd:	84 d2                	test   %dl,%dl
 4bf:	75 39                	jne    4fa <printf+0x5a>
 4c1:	e9 c2 00 00 00       	jmp    588 <printf+0xe8>
 4c6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4c8:	83 fa 25             	cmp    $0x25,%edx
 4cb:	0f 84 bf 00 00 00    	je     590 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4d1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4db:	00 
 4dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4e3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4e6:	e8 47 fe ff ff       	call   332 <write>
 4eb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4ee:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4f2:	84 d2                	test   %dl,%dl
 4f4:	0f 84 8e 00 00 00    	je     588 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 4fa:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4fc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 4ff:	74 c7                	je     4c8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 501:	83 ff 25             	cmp    $0x25,%edi
 504:	75 e5                	jne    4eb <printf+0x4b>
      if(c == 'd'){
 506:	83 fa 64             	cmp    $0x64,%edx
 509:	0f 84 31 01 00 00    	je     640 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 50f:	25 f7 00 00 00       	and    $0xf7,%eax
 514:	83 f8 70             	cmp    $0x70,%eax
 517:	0f 84 83 00 00 00    	je     5a0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 51d:	83 fa 73             	cmp    $0x73,%edx
 520:	0f 84 a2 00 00 00    	je     5c8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 526:	83 fa 63             	cmp    $0x63,%edx
 529:	0f 84 35 01 00 00    	je     664 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 52f:	83 fa 25             	cmp    $0x25,%edx
 532:	0f 84 e0 00 00 00    	je     618 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 538:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 53b:	83 c3 01             	add    $0x1,%ebx
 53e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 545:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 546:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 548:	89 44 24 04          	mov    %eax,0x4(%esp)
 54c:	89 34 24             	mov    %esi,(%esp)
 54f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 552:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 556:	e8 d7 fd ff ff       	call   332 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 55b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 55e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 561:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 568:	00 
 569:	89 44 24 04          	mov    %eax,0x4(%esp)
 56d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 570:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 573:	e8 ba fd ff ff       	call   332 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 578:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 57c:	84 d2                	test   %dl,%dl
 57e:	0f 85 76 ff ff ff    	jne    4fa <printf+0x5a>
 584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 588:	83 c4 3c             	add    $0x3c,%esp
 58b:	5b                   	pop    %ebx
 58c:	5e                   	pop    %esi
 58d:	5f                   	pop    %edi
 58e:	5d                   	pop    %ebp
 58f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 590:	bf 25 00 00 00       	mov    $0x25,%edi
 595:	e9 51 ff ff ff       	jmp    4eb <printf+0x4b>
 59a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5a3:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5a8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 5aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5b1:	8b 10                	mov    (%eax),%edx
 5b3:	89 f0                	mov    %esi,%eax
 5b5:	e8 46 fe ff ff       	call   400 <printint>
        ap++;
 5ba:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5be:	e9 28 ff ff ff       	jmp    4eb <printf+0x4b>
 5c3:	90                   	nop
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 5c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 5cb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 5cf:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 5d1:	b8 78 08 00 00       	mov    $0x878,%eax
 5d6:	85 ff                	test   %edi,%edi
 5d8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 5db:	0f b6 07             	movzbl (%edi),%eax
 5de:	84 c0                	test   %al,%al
 5e0:	74 2a                	je     60c <printf+0x16c>
 5e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5e8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5eb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 5ee:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5f8:	00 
 5f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fd:	89 34 24             	mov    %esi,(%esp)
 600:	e8 2d fd ff ff       	call   332 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 605:	0f b6 07             	movzbl (%edi),%eax
 608:	84 c0                	test   %al,%al
 60a:	75 dc                	jne    5e8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 60c:	31 ff                	xor    %edi,%edi
 60e:	e9 d8 fe ff ff       	jmp    4eb <printf+0x4b>
 613:	90                   	nop
 614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 618:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 61b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 61d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 624:	00 
 625:	89 44 24 04          	mov    %eax,0x4(%esp)
 629:	89 34 24             	mov    %esi,(%esp)
 62c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 630:	e8 fd fc ff ff       	call   332 <write>
 635:	e9 b1 fe ff ff       	jmp    4eb <printf+0x4b>
 63a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 640:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 643:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 648:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 64b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 652:	8b 10                	mov    (%eax),%edx
 654:	89 f0                	mov    %esi,%eax
 656:	e8 a5 fd ff ff       	call   400 <printint>
        ap++;
 65b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 65f:	e9 87 fe ff ff       	jmp    4eb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 664:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 667:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 669:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 66b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 672:	00 
 673:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 676:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 679:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 67c:	89 44 24 04          	mov    %eax,0x4(%esp)
 680:	e8 ad fc ff ff       	call   332 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 685:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 689:	e9 5d fe ff ff       	jmp    4eb <printf+0x4b>
 68e:	66 90                	xchg   %ax,%ax

00000690 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 690:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 691:	a1 f8 0a 00 00       	mov    0xaf8,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 696:	89 e5                	mov    %esp,%ebp
 698:	57                   	push   %edi
 699:	56                   	push   %esi
 69a:	53                   	push   %ebx
 69b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a3:	39 d0                	cmp    %edx,%eax
 6a5:	72 11                	jb     6b8 <free+0x28>
 6a7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a8:	39 c8                	cmp    %ecx,%eax
 6aa:	72 04                	jb     6b0 <free+0x20>
 6ac:	39 ca                	cmp    %ecx,%edx
 6ae:	72 10                	jb     6c0 <free+0x30>
 6b0:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b4:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b6:	73 f0                	jae    6a8 <free+0x18>
 6b8:	39 ca                	cmp    %ecx,%edx
 6ba:	72 04                	jb     6c0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6bc:	39 c8                	cmp    %ecx,%eax
 6be:	72 f0                	jb     6b0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6c0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6c3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 6c6:	39 cf                	cmp    %ecx,%edi
 6c8:	74 1e                	je     6e8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6ca:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6cd:	8b 48 04             	mov    0x4(%eax),%ecx
 6d0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6d3:	39 f2                	cmp    %esi,%edx
 6d5:	74 28                	je     6ff <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6d7:	89 10                	mov    %edx,(%eax)
  freep = p;
 6d9:	a3 f8 0a 00 00       	mov    %eax,0xaf8
}
 6de:	5b                   	pop    %ebx
 6df:	5e                   	pop    %esi
 6e0:	5f                   	pop    %edi
 6e1:	5d                   	pop    %ebp
 6e2:	c3                   	ret    
 6e3:	90                   	nop
 6e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6e8:	03 71 04             	add    0x4(%ecx),%esi
 6eb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ee:	8b 08                	mov    (%eax),%ecx
 6f0:	8b 09                	mov    (%ecx),%ecx
 6f2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6f5:	8b 48 04             	mov    0x4(%eax),%ecx
 6f8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6fb:	39 f2                	cmp    %esi,%edx
 6fd:	75 d8                	jne    6d7 <free+0x47>
    p->s.size += bp->s.size;
 6ff:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 702:	a3 f8 0a 00 00       	mov    %eax,0xaf8
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 707:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 70a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 70d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 70f:	5b                   	pop    %ebx
 710:	5e                   	pop    %esi
 711:	5f                   	pop    %edi
 712:	5d                   	pop    %ebp
 713:	c3                   	ret    
 714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 71a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000720 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	53                   	push   %ebx
 726:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 729:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 72c:	8b 1d f8 0a 00 00    	mov    0xaf8,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 732:	8d 48 07             	lea    0x7(%eax),%ecx
 735:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 738:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 73a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 73d:	0f 84 9b 00 00 00    	je     7de <malloc+0xbe>
 743:	8b 13                	mov    (%ebx),%edx
 745:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 748:	39 fe                	cmp    %edi,%esi
 74a:	76 64                	jbe    7b0 <malloc+0x90>
 74c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 753:	bb 00 80 00 00       	mov    $0x8000,%ebx
 758:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 75b:	eb 0e                	jmp    76b <malloc+0x4b>
 75d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 760:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 762:	8b 78 04             	mov    0x4(%eax),%edi
 765:	39 fe                	cmp    %edi,%esi
 767:	76 4f                	jbe    7b8 <malloc+0x98>
 769:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 76b:	3b 15 f8 0a 00 00    	cmp    0xaf8,%edx
 771:	75 ed                	jne    760 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 776:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 77c:	bf 00 10 00 00       	mov    $0x1000,%edi
 781:	0f 43 fe             	cmovae %esi,%edi
 784:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 787:	89 04 24             	mov    %eax,(%esp)
 78a:	e8 0b fc ff ff       	call   39a <sbrk>
  if(p == (char*)-1)
 78f:	83 f8 ff             	cmp    $0xffffffff,%eax
 792:	74 18                	je     7ac <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 794:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 797:	83 c0 08             	add    $0x8,%eax
 79a:	89 04 24             	mov    %eax,(%esp)
 79d:	e8 ee fe ff ff       	call   690 <free>
  return freep;
 7a2:	8b 15 f8 0a 00 00    	mov    0xaf8,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 7a8:	85 d2                	test   %edx,%edx
 7aa:	75 b4                	jne    760 <malloc+0x40>
        return 0;
 7ac:	31 c0                	xor    %eax,%eax
 7ae:	eb 20                	jmp    7d0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7b0:	89 d0                	mov    %edx,%eax
 7b2:	89 da                	mov    %ebx,%edx
 7b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 7b8:	39 fe                	cmp    %edi,%esi
 7ba:	74 1c                	je     7d8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7bc:	29 f7                	sub    %esi,%edi
 7be:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 7c1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 7c4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 7c7:	89 15 f8 0a 00 00    	mov    %edx,0xaf8
      return (void*)(p + 1);
 7cd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7d0:	83 c4 1c             	add    $0x1c,%esp
 7d3:	5b                   	pop    %ebx
 7d4:	5e                   	pop    %esi
 7d5:	5f                   	pop    %edi
 7d6:	5d                   	pop    %ebp
 7d7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 7d8:	8b 08                	mov    (%eax),%ecx
 7da:	89 0a                	mov    %ecx,(%edx)
 7dc:	eb e9                	jmp    7c7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7de:	c7 05 f8 0a 00 00 fc 	movl   $0xafc,0xaf8
 7e5:	0a 00 00 
    base.s.size = 0;
 7e8:	ba fc 0a 00 00       	mov    $0xafc,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7ed:	c7 05 fc 0a 00 00 fc 	movl   $0xafc,0xafc
 7f4:	0a 00 00 
    base.s.size = 0;
 7f7:	c7 05 00 0b 00 00 00 	movl   $0x0,0xb00
 7fe:	00 00 00 
 801:	e9 46 ff ff ff       	jmp    74c <malloc+0x2c>

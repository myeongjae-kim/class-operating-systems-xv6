
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
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 10             	sub    $0x10,%esp
  int cnt = 0;
  int cpu_share;
  uint start_tick;
  uint curr_tick;

  if (argc < 2) {
   c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  10:	7e 6a                	jle    7c <main+0x7c>
    printf(1, "usage: sched_test_stride cpu_share(%)\n");
    exit();
  }

  cpu_share = atoi(argv[1]);
  12:	8b 45 0c             	mov    0xc(%ebp),%eax
  15:	8b 40 04             	mov    0x4(%eax),%eax
  18:	89 04 24             	mov    %eax,(%esp)
  1b:	e8 50 02 00 00       	call   270 <atoi>

  // Register this process to the Stride scheduler
  if (set_cpu_share(cpu_share) < 0) {
  20:	89 04 24             	mov    %eax,(%esp)
  if (argc < 2) {
    printf(1, "usage: sched_test_stride cpu_share(%)\n");
    exit();
  }

  cpu_share = atoi(argv[1]);
  23:	89 c7                	mov    %eax,%edi

  // Register this process to the Stride scheduler
  if (set_cpu_share(cpu_share) < 0) {
  25:	e8 68 03 00 00       	call   392 <set_cpu_share>
  2a:	85 c0                	test   %eax,%eax
  2c:	78 67                	js     95 <main+0x95>
    printf(1, "cannot set cpu share\n");
    exit();
  }

  // Get start time
  start_tick = uptime();
  2e:	e8 37 03 00 00       	call   36a <uptime>

int
main(int argc, char *argv[])
{
  uint i;
  int cnt = 0;
  33:	31 db                	xor    %ebx,%ebx
    printf(1, "cannot set cpu share\n");
    exit();
  }

  // Get start time
  start_tick = uptime();
  35:	89 c6                	mov    %eax,%esi

int
main(int argc, char *argv[])
{
  uint i;
  int cnt = 0;
  37:	b8 40 42 0f 00       	mov    $0xf4240,%eax
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  i = 0;
  while (1) {
    i++;

    // Prevent code optimization
    __sync_synchronize();
  40:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

    if (i == COUNT_PERIOD) {
  45:	83 e8 01             	sub    $0x1,%eax
  48:	75 f6                	jne    40 <main+0x40>
      cnt++;

      // Get current time
      curr_tick = uptime();
  4a:	e8 1b 03 00 00       	call   36a <uptime>

    // Prevent code optimization
    __sync_synchronize();

    if (i == COUNT_PERIOD) {
      cnt++;
  4f:	83 c3 01             	add    $0x1,%ebx

      // Get current time
      curr_tick = uptime();

      if (curr_tick - start_tick > LIFETIME) {
  52:	29 f0                	sub    %esi,%eax
  54:	3d e8 03 00 00       	cmp    $0x3e8,%eax
  59:	76 dc                	jbe    37 <main+0x37>
        // Terminate process
        printf(1, "STRIDE(%d%%), cnt: %d\n", cpu_share, cnt);
  5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  5f:	89 7c 24 08          	mov    %edi,0x8(%esp)
  63:	c7 44 24 04 06 08 00 	movl   $0x806,0x4(%esp)
  6a:	00 
  6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  72:	e8 e9 03 00 00       	call   460 <printf>
      }
      i = 0;
    }
  }

  exit();
  77:	e8 56 02 00 00       	call   2d2 <exit>
  int cpu_share;
  uint start_tick;
  uint curr_tick;

  if (argc < 2) {
    printf(1, "usage: sched_test_stride cpu_share(%)\n");
  7c:	c7 44 24 04 c8 07 00 	movl   $0x7c8,0x4(%esp)
  83:	00 
  84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8b:	e8 d0 03 00 00       	call   460 <printf>
    exit();
  90:	e8 3d 02 00 00       	call   2d2 <exit>

  cpu_share = atoi(argv[1]);

  // Register this process to the Stride scheduler
  if (set_cpu_share(cpu_share) < 0) {
    printf(1, "cannot set cpu share\n");
  95:	c7 44 24 04 f0 07 00 	movl   $0x7f0,0x4(%esp)
  9c:	00 
  9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a4:	e8 b7 03 00 00       	call   460 <printf>
    exit();
  a9:	e8 24 02 00 00       	call   2d2 <exit>
  ae:	66 90                	xchg   %ax,%ax

000000b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	8b 45 08             	mov    0x8(%ebp),%eax
  b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  b9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ba:	89 c2                	mov    %eax,%edx
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  c0:	83 c1 01             	add    $0x1,%ecx
  c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  c7:	83 c2 01             	add    $0x1,%edx
  ca:	84 db                	test   %bl,%bl
  cc:	88 5a ff             	mov    %bl,-0x1(%edx)
  cf:	75 ef                	jne    c0 <strcpy+0x10>
    ;
  return os;
}
  d1:	5b                   	pop    %ebx
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    
  d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 55 08             	mov    0x8(%ebp),%edx
  e6:	53                   	push   %ebx
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ea:	0f b6 02             	movzbl (%edx),%eax
  ed:	84 c0                	test   %al,%al
  ef:	74 2d                	je     11e <strcmp+0x3e>
  f1:	0f b6 19             	movzbl (%ecx),%ebx
  f4:	38 d8                	cmp    %bl,%al
  f6:	74 0e                	je     106 <strcmp+0x26>
  f8:	eb 2b                	jmp    125 <strcmp+0x45>
  fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 100:	38 c8                	cmp    %cl,%al
 102:	75 15                	jne    119 <strcmp+0x39>
    p++, q++;
 104:	89 d9                	mov    %ebx,%ecx
 106:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 109:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 10c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 10f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 113:	84 c0                	test   %al,%al
 115:	75 e9                	jne    100 <strcmp+0x20>
 117:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 119:	29 c8                	sub    %ecx,%eax
}
 11b:	5b                   	pop    %ebx
 11c:	5d                   	pop    %ebp
 11d:	c3                   	ret    
 11e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 121:	31 c0                	xor    %eax,%eax
 123:	eb f4                	jmp    119 <strcmp+0x39>
 125:	0f b6 cb             	movzbl %bl,%ecx
 128:	eb ef                	jmp    119 <strcmp+0x39>
 12a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000130 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 136:	80 39 00             	cmpb   $0x0,(%ecx)
 139:	74 12                	je     14d <strlen+0x1d>
 13b:	31 d2                	xor    %edx,%edx
 13d:	8d 76 00             	lea    0x0(%esi),%esi
 140:	83 c2 01             	add    $0x1,%edx
 143:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 147:	89 d0                	mov    %edx,%eax
 149:	75 f5                	jne    140 <strlen+0x10>
    ;
  return n;
}
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 14d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    
 151:	eb 0d                	jmp    160 <memset>
 153:	90                   	nop
 154:	90                   	nop
 155:	90                   	nop
 156:	90                   	nop
 157:	90                   	nop
 158:	90                   	nop
 159:	90                   	nop
 15a:	90                   	nop
 15b:	90                   	nop
 15c:	90                   	nop
 15d:	90                   	nop
 15e:	90                   	nop
 15f:	90                   	nop

00000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 55 08             	mov    0x8(%ebp),%edx
 166:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 167:	8b 4d 10             	mov    0x10(%ebp),%ecx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	89 d7                	mov    %edx,%edi
 16f:	fc                   	cld    
 170:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 172:	89 d0                	mov    %edx,%eax
 174:	5f                   	pop    %edi
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	89 f6                	mov    %esi,%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	53                   	push   %ebx
 187:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 18a:	0f b6 18             	movzbl (%eax),%ebx
 18d:	84 db                	test   %bl,%bl
 18f:	74 1d                	je     1ae <strchr+0x2e>
    if(*s == c)
 191:	38 d3                	cmp    %dl,%bl
 193:	89 d1                	mov    %edx,%ecx
 195:	75 0d                	jne    1a4 <strchr+0x24>
 197:	eb 17                	jmp    1b0 <strchr+0x30>
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1a0:	38 ca                	cmp    %cl,%dl
 1a2:	74 0c                	je     1b0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1a4:	83 c0 01             	add    $0x1,%eax
 1a7:	0f b6 10             	movzbl (%eax),%edx
 1aa:	84 d2                	test   %dl,%dl
 1ac:	75 f2                	jne    1a0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 1ae:	31 c0                	xor    %eax,%eax
}
 1b0:	5b                   	pop    %ebx
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    
 1b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <gets>:

char*
gets(char *buf, int max)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 1c7:	53                   	push   %ebx
 1c8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1cb:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	eb 31                	jmp    201 <gets+0x41>
    cc = read(0, &c, 1);
 1d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1d7:	00 
 1d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1e3:	e8 02 01 00 00       	call   2ea <read>
    if(cc < 1)
 1e8:	85 c0                	test   %eax,%eax
 1ea:	7e 1d                	jle    209 <gets+0x49>
      break;
    buf[i++] = c;
 1ec:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f0:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 1f2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 1f5:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 1f7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1fb:	74 0c                	je     209 <gets+0x49>
 1fd:	3c 0a                	cmp    $0xa,%al
 1ff:	74 08                	je     209 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 201:	8d 5e 01             	lea    0x1(%esi),%ebx
 204:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 207:	7c c7                	jl     1d0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 210:	83 c4 2c             	add    $0x2c,%esp
 213:	5b                   	pop    %ebx
 214:	5e                   	pop    %esi
 215:	5f                   	pop    %edi
 216:	5d                   	pop    %ebp
 217:	c3                   	ret    
 218:	90                   	nop
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000220 <stat>:

int
stat(char *n, struct stat *st)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
 225:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 232:	00 
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 d7 00 00 00       	call   312 <open>
  if(fd < 0)
 23b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 23d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 23f:	78 27                	js     268 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 241:	8b 45 0c             	mov    0xc(%ebp),%eax
 244:	89 1c 24             	mov    %ebx,(%esp)
 247:	89 44 24 04          	mov    %eax,0x4(%esp)
 24b:	e8 da 00 00 00       	call   32a <fstat>
  close(fd);
 250:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 253:	89 c6                	mov    %eax,%esi
  close(fd);
 255:	e8 a0 00 00 00       	call   2fa <close>
  return r;
 25a:	89 f0                	mov    %esi,%eax
}
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	5b                   	pop    %ebx
 260:	5e                   	pop    %esi
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	90                   	nop
 264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 26d:	eb ed                	jmp    25c <stat+0x3c>
 26f:	90                   	nop

00000270 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 4d 08             	mov    0x8(%ebp),%ecx
 276:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 277:	0f be 11             	movsbl (%ecx),%edx
 27a:	8d 42 d0             	lea    -0x30(%edx),%eax
 27d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 27f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 284:	77 17                	ja     29d <atoi+0x2d>
 286:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 288:	83 c1 01             	add    $0x1,%ecx
 28b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 28e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 292:	0f be 11             	movsbl (%ecx),%edx
 295:	8d 5a d0             	lea    -0x30(%edx),%ebx
 298:	80 fb 09             	cmp    $0x9,%bl
 29b:	76 eb                	jbe    288 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 29d:	5b                   	pop    %ebx
 29e:	5d                   	pop    %ebp
 29f:	c3                   	ret    

000002a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	56                   	push   %esi
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	53                   	push   %ebx
 2aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2ad:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b0:	85 db                	test   %ebx,%ebx
 2b2:	7e 12                	jle    2c6 <memmove+0x26>
 2b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2bf:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c2:	39 da                	cmp    %ebx,%edx
 2c4:	75 f2                	jne    2b8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5d                   	pop    %ebp
 2c9:	c3                   	ret    

000002ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ca:	b8 01 00 00 00       	mov    $0x1,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <exit>:
SYSCALL(exit)
 2d2:	b8 02 00 00 00       	mov    $0x2,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <wait>:
SYSCALL(wait)
 2da:	b8 03 00 00 00       	mov    $0x3,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <pipe>:
SYSCALL(pipe)
 2e2:	b8 04 00 00 00       	mov    $0x4,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <read>:
SYSCALL(read)
 2ea:	b8 05 00 00 00       	mov    $0x5,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <write>:
SYSCALL(write)
 2f2:	b8 10 00 00 00       	mov    $0x10,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <close>:
SYSCALL(close)
 2fa:	b8 15 00 00 00       	mov    $0x15,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <kill>:
SYSCALL(kill)
 302:	b8 06 00 00 00       	mov    $0x6,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <exec>:
SYSCALL(exec)
 30a:	b8 07 00 00 00       	mov    $0x7,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <open>:
SYSCALL(open)
 312:	b8 0f 00 00 00       	mov    $0xf,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <mknod>:
SYSCALL(mknod)
 31a:	b8 11 00 00 00       	mov    $0x11,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <unlink>:
SYSCALL(unlink)
 322:	b8 12 00 00 00       	mov    $0x12,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <fstat>:
SYSCALL(fstat)
 32a:	b8 08 00 00 00       	mov    $0x8,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <link>:
SYSCALL(link)
 332:	b8 13 00 00 00       	mov    $0x13,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <mkdir>:
SYSCALL(mkdir)
 33a:	b8 14 00 00 00       	mov    $0x14,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <chdir>:
SYSCALL(chdir)
 342:	b8 09 00 00 00       	mov    $0x9,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <dup>:
SYSCALL(dup)
 34a:	b8 0a 00 00 00       	mov    $0xa,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <getpid>:
SYSCALL(getpid)
 352:	b8 0b 00 00 00       	mov    $0xb,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <sbrk>:
SYSCALL(sbrk)
 35a:	b8 0c 00 00 00       	mov    $0xc,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <sleep>:
SYSCALL(sleep)
 362:	b8 0d 00 00 00       	mov    $0xd,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <uptime>:
SYSCALL(uptime)
 36a:	b8 0e 00 00 00       	mov    $0xe,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <my_syscall>:
SYSCALL(my_syscall)
 372:	b8 16 00 00 00       	mov    $0x16,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <getppid>:
SYSCALL(getppid)
 37a:	b8 17 00 00 00       	mov    $0x17,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <yield>:
SYSCALL(yield)
 382:	b8 18 00 00 00       	mov    $0x18,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <getlev>:
SYSCALL(getlev)
 38a:	b8 19 00 00 00       	mov    $0x19,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <set_cpu_share>:
SYSCALL(set_cpu_share)
 392:	b8 1a 00 00 00       	mov    $0x1a,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <thread_create>:
SYSCALL(thread_create)
 39a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <thread_exit>:
SYSCALL(thread_exit)
 3a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <thread_join>:
SYSCALL(thread_join)
 3aa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <gettid>:
SYSCALL(gettid)
 3b2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    
 3ba:	66 90                	xchg   %ax,%ax
 3bc:	66 90                	xchg   %ax,%ax
 3be:	66 90                	xchg   %ax,%ax

000003c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	56                   	push   %esi
 3c5:	89 c6                	mov    %eax,%esi
 3c7:	53                   	push   %ebx
 3c8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3ce:	85 db                	test   %ebx,%ebx
 3d0:	74 09                	je     3db <printint+0x1b>
 3d2:	89 d0                	mov    %edx,%eax
 3d4:	c1 e8 1f             	shr    $0x1f,%eax
 3d7:	84 c0                	test   %al,%al
 3d9:	75 75                	jne    450 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3db:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3dd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3e4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3e7:	31 ff                	xor    %edi,%edi
 3e9:	89 ce                	mov    %ecx,%esi
 3eb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3ee:	eb 02                	jmp    3f2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 3f0:	89 cf                	mov    %ecx,%edi
 3f2:	31 d2                	xor    %edx,%edx
 3f4:	f7 f6                	div    %esi
 3f6:	8d 4f 01             	lea    0x1(%edi),%ecx
 3f9:	0f b6 92 24 08 00 00 	movzbl 0x824(%edx),%edx
  }while((x /= base) != 0);
 400:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 402:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 405:	75 e9                	jne    3f0 <printint+0x30>
  if(neg)
 407:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 40a:	89 c8                	mov    %ecx,%eax
 40c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 40f:	85 d2                	test   %edx,%edx
 411:	74 08                	je     41b <printint+0x5b>
    buf[i++] = '-';
 413:	8d 4f 02             	lea    0x2(%edi),%ecx
 416:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 41b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 41e:	66 90                	xchg   %ax,%ax
 420:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 425:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 428:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 42f:	00 
 430:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 434:	89 34 24             	mov    %esi,(%esp)
 437:	88 45 d7             	mov    %al,-0x29(%ebp)
 43a:	e8 b3 fe ff ff       	call   2f2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 43f:	83 ff ff             	cmp    $0xffffffff,%edi
 442:	75 dc                	jne    420 <printint+0x60>
    putc(fd, buf[i]);
}
 444:	83 c4 4c             	add    $0x4c,%esp
 447:	5b                   	pop    %ebx
 448:	5e                   	pop    %esi
 449:	5f                   	pop    %edi
 44a:	5d                   	pop    %ebp
 44b:	c3                   	ret    
 44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 450:	89 d0                	mov    %edx,%eax
 452:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 454:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 45b:	eb 87                	jmp    3e4 <printint+0x24>
 45d:	8d 76 00             	lea    0x0(%esi),%esi

00000460 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 464:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 466:	56                   	push   %esi
 467:	53                   	push   %ebx
 468:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 46b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 46e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 471:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 474:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 477:	0f b6 13             	movzbl (%ebx),%edx
 47a:	83 c3 01             	add    $0x1,%ebx
 47d:	84 d2                	test   %dl,%dl
 47f:	75 39                	jne    4ba <printf+0x5a>
 481:	e9 c2 00 00 00       	jmp    548 <printf+0xe8>
 486:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 488:	83 fa 25             	cmp    $0x25,%edx
 48b:	0f 84 bf 00 00 00    	je     550 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 491:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 494:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 49b:	00 
 49c:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4a3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a6:	e8 47 fe ff ff       	call   2f2 <write>
 4ab:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4ae:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4b2:	84 d2                	test   %dl,%dl
 4b4:	0f 84 8e 00 00 00    	je     548 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 4ba:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4bc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 4bf:	74 c7                	je     488 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c1:	83 ff 25             	cmp    $0x25,%edi
 4c4:	75 e5                	jne    4ab <printf+0x4b>
      if(c == 'd'){
 4c6:	83 fa 64             	cmp    $0x64,%edx
 4c9:	0f 84 31 01 00 00    	je     600 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4cf:	25 f7 00 00 00       	and    $0xf7,%eax
 4d4:	83 f8 70             	cmp    $0x70,%eax
 4d7:	0f 84 83 00 00 00    	je     560 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4dd:	83 fa 73             	cmp    $0x73,%edx
 4e0:	0f 84 a2 00 00 00    	je     588 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4e6:	83 fa 63             	cmp    $0x63,%edx
 4e9:	0f 84 35 01 00 00    	je     624 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ef:	83 fa 25             	cmp    $0x25,%edx
 4f2:	0f 84 e0 00 00 00    	je     5d8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4fb:	83 c3 01             	add    $0x1,%ebx
 4fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 505:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 506:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 508:	89 44 24 04          	mov    %eax,0x4(%esp)
 50c:	89 34 24             	mov    %esi,(%esp)
 50f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 512:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 516:	e8 d7 fd ff ff       	call   2f2 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 51b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 51e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 521:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 528:	00 
 529:	89 44 24 04          	mov    %eax,0x4(%esp)
 52d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 530:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 533:	e8 ba fd ff ff       	call   2f2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 538:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 53c:	84 d2                	test   %dl,%dl
 53e:	0f 85 76 ff ff ff    	jne    4ba <printf+0x5a>
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 548:	83 c4 3c             	add    $0x3c,%esp
 54b:	5b                   	pop    %ebx
 54c:	5e                   	pop    %esi
 54d:	5f                   	pop    %edi
 54e:	5d                   	pop    %ebp
 54f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 550:	bf 25 00 00 00       	mov    $0x25,%edi
 555:	e9 51 ff ff ff       	jmp    4ab <printf+0x4b>
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 560:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 563:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 568:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 56a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 571:	8b 10                	mov    (%eax),%edx
 573:	89 f0                	mov    %esi,%eax
 575:	e8 46 fe ff ff       	call   3c0 <printint>
        ap++;
 57a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 57e:	e9 28 ff ff ff       	jmp    4ab <printf+0x4b>
 583:	90                   	nop
 584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 58b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 58f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 591:	b8 1d 08 00 00       	mov    $0x81d,%eax
 596:	85 ff                	test   %edi,%edi
 598:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 59b:	0f b6 07             	movzbl (%edi),%eax
 59e:	84 c0                	test   %al,%al
 5a0:	74 2a                	je     5cc <printf+0x16c>
 5a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5a8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ab:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 5ae:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5b8:	00 
 5b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bd:	89 34 24             	mov    %esi,(%esp)
 5c0:	e8 2d fd ff ff       	call   2f2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5c5:	0f b6 07             	movzbl (%edi),%eax
 5c8:	84 c0                	test   %al,%al
 5ca:	75 dc                	jne    5a8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5cc:	31 ff                	xor    %edi,%edi
 5ce:	e9 d8 fe ff ff       	jmp    4ab <printf+0x4b>
 5d3:	90                   	nop
 5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5db:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5dd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5e4:	00 
 5e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e9:	89 34 24             	mov    %esi,(%esp)
 5ec:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 5f0:	e8 fd fc ff ff       	call   2f2 <write>
 5f5:	e9 b1 fe ff ff       	jmp    4ab <printf+0x4b>
 5fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 600:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 603:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 608:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 60b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 612:	8b 10                	mov    (%eax),%edx
 614:	89 f0                	mov    %esi,%eax
 616:	e8 a5 fd ff ff       	call   3c0 <printint>
        ap++;
 61b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 61f:	e9 87 fe ff ff       	jmp    4ab <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 624:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 627:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 629:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 62b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 632:	00 
 633:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 636:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 639:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 63c:	89 44 24 04          	mov    %eax,0x4(%esp)
 640:	e8 ad fc ff ff       	call   2f2 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 645:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 649:	e9 5d fe ff ff       	jmp    4ab <printf+0x4b>
 64e:	66 90                	xchg   %ax,%ax

00000650 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 650:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	a1 a0 0a 00 00       	mov    0xaa0,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 656:	89 e5                	mov    %esp,%ebp
 658:	57                   	push   %edi
 659:	56                   	push   %esi
 65a:	53                   	push   %ebx
 65b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 660:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 663:	39 d0                	cmp    %edx,%eax
 665:	72 11                	jb     678 <free+0x28>
 667:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 668:	39 c8                	cmp    %ecx,%eax
 66a:	72 04                	jb     670 <free+0x20>
 66c:	39 ca                	cmp    %ecx,%edx
 66e:	72 10                	jb     680 <free+0x30>
 670:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 672:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 674:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 676:	73 f0                	jae    668 <free+0x18>
 678:	39 ca                	cmp    %ecx,%edx
 67a:	72 04                	jb     680 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67c:	39 c8                	cmp    %ecx,%eax
 67e:	72 f0                	jb     670 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 680:	8b 73 fc             	mov    -0x4(%ebx),%esi
 683:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 686:	39 cf                	cmp    %ecx,%edi
 688:	74 1e                	je     6a8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 68a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 68d:	8b 48 04             	mov    0x4(%eax),%ecx
 690:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 693:	39 f2                	cmp    %esi,%edx
 695:	74 28                	je     6bf <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 697:	89 10                	mov    %edx,(%eax)
  freep = p;
 699:	a3 a0 0a 00 00       	mov    %eax,0xaa0
}
 69e:	5b                   	pop    %ebx
 69f:	5e                   	pop    %esi
 6a0:	5f                   	pop    %edi
 6a1:	5d                   	pop    %ebp
 6a2:	c3                   	ret    
 6a3:	90                   	nop
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6a8:	03 71 04             	add    0x4(%ecx),%esi
 6ab:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ae:	8b 08                	mov    (%eax),%ecx
 6b0:	8b 09                	mov    (%ecx),%ecx
 6b2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6b5:	8b 48 04             	mov    0x4(%eax),%ecx
 6b8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6bb:	39 f2                	cmp    %esi,%edx
 6bd:	75 d8                	jne    697 <free+0x47>
    p->s.size += bp->s.size;
 6bf:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6c2:	a3 a0 0a 00 00       	mov    %eax,0xaa0
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ca:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6cd:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6cf:	5b                   	pop    %ebx
 6d0:	5e                   	pop    %esi
 6d1:	5f                   	pop    %edi
 6d2:	5d                   	pop    %ebp
 6d3:	c3                   	ret    
 6d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000006e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ec:	8b 1d a0 0a 00 00    	mov    0xaa0,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f2:	8d 48 07             	lea    0x7(%eax),%ecx
 6f5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 6f8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6fa:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 6fd:	0f 84 9b 00 00 00    	je     79e <malloc+0xbe>
 703:	8b 13                	mov    (%ebx),%edx
 705:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 708:	39 fe                	cmp    %edi,%esi
 70a:	76 64                	jbe    770 <malloc+0x90>
 70c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 713:	bb 00 80 00 00       	mov    $0x8000,%ebx
 718:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 71b:	eb 0e                	jmp    72b <malloc+0x4b>
 71d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 720:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 722:	8b 78 04             	mov    0x4(%eax),%edi
 725:	39 fe                	cmp    %edi,%esi
 727:	76 4f                	jbe    778 <malloc+0x98>
 729:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 72b:	3b 15 a0 0a 00 00    	cmp    0xaa0,%edx
 731:	75 ed                	jne    720 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 736:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 73c:	bf 00 10 00 00       	mov    $0x1000,%edi
 741:	0f 43 fe             	cmovae %esi,%edi
 744:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 747:	89 04 24             	mov    %eax,(%esp)
 74a:	e8 0b fc ff ff       	call   35a <sbrk>
  if(p == (char*)-1)
 74f:	83 f8 ff             	cmp    $0xffffffff,%eax
 752:	74 18                	je     76c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 754:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 757:	83 c0 08             	add    $0x8,%eax
 75a:	89 04 24             	mov    %eax,(%esp)
 75d:	e8 ee fe ff ff       	call   650 <free>
  return freep;
 762:	8b 15 a0 0a 00 00    	mov    0xaa0,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 768:	85 d2                	test   %edx,%edx
 76a:	75 b4                	jne    720 <malloc+0x40>
        return 0;
 76c:	31 c0                	xor    %eax,%eax
 76e:	eb 20                	jmp    790 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 770:	89 d0                	mov    %edx,%eax
 772:	89 da                	mov    %ebx,%edx
 774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 778:	39 fe                	cmp    %edi,%esi
 77a:	74 1c                	je     798 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 77c:	29 f7                	sub    %esi,%edi
 77e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 781:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 784:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 787:	89 15 a0 0a 00 00    	mov    %edx,0xaa0
      return (void*)(p + 1);
 78d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 790:	83 c4 1c             	add    $0x1c,%esp
 793:	5b                   	pop    %ebx
 794:	5e                   	pop    %esi
 795:	5f                   	pop    %edi
 796:	5d                   	pop    %ebp
 797:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 798:	8b 08                	mov    (%eax),%ecx
 79a:	89 0a                	mov    %ecx,(%edx)
 79c:	eb e9                	jmp    787 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 79e:	c7 05 a0 0a 00 00 a4 	movl   $0xaa4,0xaa0
 7a5:	0a 00 00 
    base.s.size = 0;
 7a8:	ba a4 0a 00 00       	mov    $0xaa4,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 7ad:	c7 05 a4 0a 00 00 a4 	movl   $0xaa4,0xaa4
 7b4:	0a 00 00 
    base.s.size = 0;
 7b7:	c7 05 a8 0a 00 00 00 	movl   $0x0,0xaa8
 7be:	00 00 00 
 7c1:	e9 46 ff ff ff       	jmp    70c <malloc+0x2c>

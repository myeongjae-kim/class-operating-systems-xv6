
_threadtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  "stresstest",
};

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	83 ec 20             	sub    $0x20,%esp
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;
  int ret;
  int pid;
  int start = 0;
  int end = NTEST-1;
  if (argc >= 2)
   f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  13:	0f 8e 2e 01 00 00    	jle    147 <main+0x147>
    start = atoi(argv[1]);
  19:	8b 47 04             	mov    0x4(%edi),%eax
{
  int i;
  int ret;
  int pid;
  int start = 0;
  int end = NTEST-1;
  1c:	be 04 00 00 00       	mov    $0x4,%esi
  if (argc >= 2)
    start = atoi(argv[1]);
  21:	89 04 24             	mov    %eax,(%esp)
  24:	e8 77 09 00 00       	call   9a0 <atoi>
  if (argc >= 3)
  29:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  int ret;
  int pid;
  int start = 0;
  int end = NTEST-1;
  if (argc >= 2)
    start = atoi(argv[1]);
  2d:	89 c3                	mov    %eax,%ebx
  if (argc >= 3)
  2f:	74 0d                	je     3e <main+0x3e>
    end = atoi(argv[2]);
  31:	8b 47 08             	mov    0x8(%edi),%eax
  34:	89 04 24             	mov    %eax,(%esp)
  37:	e8 64 09 00 00       	call   9a0 <atoi>
  3c:	89 c6                	mov    %eax,%esi

  for (i = start; i <= end; i++){
  3e:	39 de                	cmp    %ebx,%esi
  40:	0f 8c fc 00 00 00    	jl     142 <main+0x142>
      write(gpipe[1], (char*)&ret, sizeof(ret));
      close(gpipe[1]);
      exit();
    } else{
      close(gpipe[1]);
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
  46:	8d 7c 24 1c          	lea    0x1c(%esp),%edi
  4a:	e9 a8 00 00 00       	jmp    f7 <main+0xf7>
  4f:	90                   	nop
    printf(1,"%d. %s start\n", i, testname[i]);
    if (pipe(gpipe) < 0){
      printf(1,"pipe panic\n");
      exit();
    }
    ret = 0;
  50:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  57:	00 

    if ((pid = fork()) < 0){
  58:	e8 9d 09 00 00       	call   9fa <fork>
  5d:	85 c0                	test   %eax,%eax
  5f:	0f 88 16 01 00 00    	js     17b <main+0x17b>
      printf(1,"fork panic\n");
      exit();
    }
    if (pid == 0){
  65:	0f 84 29 01 00 00    	je     194 <main+0x194>
      ret = testfunc[i]();
      write(gpipe[1], (char*)&ret, sizeof(ret));
      close(gpipe[1]);
      exit();
    } else{
      close(gpipe[1]);
  6b:	a1 c0 14 00 00       	mov    0x14c0,%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 b2 09 00 00       	call   a2a <close>
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
  78:	e8 8d 09 00 00       	call   a0a <wait>
  7d:	83 f8 ff             	cmp    $0xffffffff,%eax
  80:	0f 84 cd 00 00 00    	je     153 <main+0x153>
  86:	a1 bc 14 00 00       	mov    0x14bc,%eax
  8b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  92:	00 
  93:	89 7c 24 04          	mov    %edi,0x4(%esp)
  97:	89 04 24             	mov    %eax,(%esp)
  9a:	e8 7b 09 00 00       	call   a1a <read>
  9f:	83 f8 ff             	cmp    $0xffffffff,%eax
  a2:	0f 84 ab 00 00 00    	je     153 <main+0x153>
  a8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  ac:	85 c0                	test   %eax,%eax
  ae:	0f 85 9f 00 00 00    	jne    153 <main+0x153>
        printf(1,"%d. %s panic\n", i, testname[i]);
        exit();
      }
      close(gpipe[0]);
  b4:	a1 bc 14 00 00       	mov    0x14bc,%eax
  b9:	89 04 24             	mov    %eax,(%esp)
  bc:	e8 69 09 00 00       	call   a2a <close>
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
  c1:	8b 04 9d 84 14 00 00 	mov    0x1484(,%ebx,4),%eax
  c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if (argc >= 2)
    start = atoi(argv[1]);
  if (argc >= 3)
    end = atoi(argv[2]);

  for (i = start; i <= end; i++){
  cc:	83 c3 01             	add    $0x1,%ebx
        printf(1,"%d. %s panic\n", i, testname[i]);
        exit();
      }
      close(gpipe[0]);
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
  cf:	c7 44 24 04 81 0f 00 	movl   $0xf81,0x4(%esp)
  d6:	00 
  d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e2:	e8 a9 0a 00 00       	call   b90 <printf>
    sleep(100);
  e7:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  ee:	e8 9f 09 00 00       	call   a92 <sleep>
  if (argc >= 2)
    start = atoi(argv[1]);
  if (argc >= 3)
    end = atoi(argv[2]);

  for (i = start; i <= end; i++){
  f3:	39 f3                	cmp    %esi,%ebx
  f5:	7f 4b                	jg     142 <main+0x142>
    printf(1,"%d. %s start\n", i, testname[i]);
  f7:	8b 04 9d 84 14 00 00 	mov    0x1484(,%ebx,4),%eax
  fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 102:	c7 44 24 04 4d 0f 00 	movl   $0xf4d,0x4(%esp)
 109:	00 
 10a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 111:	89 44 24 0c          	mov    %eax,0xc(%esp)
 115:	e8 76 0a 00 00       	call   b90 <printf>
    if (pipe(gpipe) < 0){
 11a:	c7 04 24 bc 14 00 00 	movl   $0x14bc,(%esp)
 121:	e8 ec 08 00 00       	call   a12 <pipe>
 126:	85 c0                	test   %eax,%eax
 128:	0f 89 22 ff ff ff    	jns    50 <main+0x50>
      printf(1,"pipe panic\n");
 12e:	c7 44 24 04 5b 0f 00 	movl   $0xf5b,0x4(%esp)
 135:	00 
 136:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13d:	e8 4e 0a 00 00       	call   b90 <printf>
      exit();
 142:	e8 bb 08 00 00       	call   a02 <exit>
{
  int i;
  int ret;
  int pid;
  int start = 0;
  int end = NTEST-1;
 147:	be 04 00 00 00       	mov    $0x4,%esi
main(int argc, char *argv[])
{
  int i;
  int ret;
  int pid;
  int start = 0;
 14c:	31 db                	xor    %ebx,%ebx
 14e:	e9 f3 fe ff ff       	jmp    46 <main+0x46>
      close(gpipe[1]);
      exit();
    } else{
      close(gpipe[1]);
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
        printf(1,"%d. %s panic\n", i, testname[i]);
 153:	8b 04 9d 84 14 00 00 	mov    0x1484(,%ebx,4),%eax
 15a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 15e:	c7 44 24 04 73 0f 00 	movl   $0xf73,0x4(%esp)
 165:	00 
 166:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 16d:	89 44 24 0c          	mov    %eax,0xc(%esp)
 171:	e8 1a 0a 00 00       	call   b90 <printf>
        exit();
 176:	e8 87 08 00 00       	call   a02 <exit>
      exit();
    }
    ret = 0;

    if ((pid = fork()) < 0){
      printf(1,"fork panic\n");
 17b:	c7 44 24 04 67 0f 00 	movl   $0xf67,0x4(%esp)
 182:	00 
 183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18a:	e8 01 0a 00 00       	call   b90 <printf>
      exit();
 18f:	e8 6e 08 00 00       	call   a02 <exit>
    }
    if (pid == 0){
      close(gpipe[0]);
 194:	a1 bc 14 00 00       	mov    0x14bc,%eax
 199:	89 04 24             	mov    %eax,(%esp)
 19c:	e8 89 08 00 00       	call   a2a <close>
      ret = testfunc[i]();
 1a1:	ff 14 9d 98 14 00 00 	call   *0x1498(,%ebx,4)
      write(gpipe[1], (char*)&ret, sizeof(ret));
 1a8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 1af:	00 
      printf(1,"fork panic\n");
      exit();
    }
    if (pid == 0){
      close(gpipe[0]);
      ret = testfunc[i]();
 1b0:	89 44 24 1c          	mov    %eax,0x1c(%esp)
      write(gpipe[1], (char*)&ret, sizeof(ret));
 1b4:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 1b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1bc:	a1 c0 14 00 00       	mov    0x14c0,%eax
 1c1:	89 04 24             	mov    %eax,(%esp)
 1c4:	e8 59 08 00 00       	call   a22 <write>
      close(gpipe[1]);
 1c9:	a1 c0 14 00 00       	mov    0x14c0,%eax
 1ce:	89 04 24             	mov    %eax,(%esp)
 1d1:	e8 54 08 00 00       	call   a2a <close>
      exit();
 1d6:	e8 27 08 00 00       	call   a02 <exit>
 1db:	66 90                	xchg   %ax,%ax
 1dd:	66 90                	xchg   %ax,%ax
 1df:	90                   	nop

000001e0 <basicthreadmain>:
}

// ============================================================================
void*
basicthreadmain(void *arg)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
  int tid = (int) arg;
  int i;
  for (i = 0; i < 100000000; i++){
    if (i % 20000000 == 0){
 1e4:	bf 6b ca 5f 6b       	mov    $0x6b5fca6b,%edi
}

// ============================================================================
void*
basicthreadmain(void *arg)
{
 1e9:	56                   	push   %esi
 1ea:	53                   	push   %ebx
  int tid = (int) arg;
  int i;
  for (i = 0; i < 100000000; i++){
 1eb:	31 db                	xor    %ebx,%ebx
}

// ============================================================================
void*
basicthreadmain(void *arg)
{
 1ed:	83 ec 1c             	sub    $0x1c,%esp
 1f0:	8b 75 08             	mov    0x8(%ebp),%esi
 1f3:	eb 0e                	jmp    203 <basicthreadmain+0x23>
 1f5:	8d 76 00             	lea    0x0(%esi),%esi
  int tid = (int) arg;
  int i;
  for (i = 0; i < 100000000; i++){
 1f8:	83 c3 01             	add    $0x1,%ebx
 1fb:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
 201:	74 3b                	je     23e <basicthreadmain+0x5e>
    if (i % 20000000 == 0){
 203:	89 d8                	mov    %ebx,%eax
 205:	f7 ef                	imul   %edi
 207:	89 d8                	mov    %ebx,%eax
 209:	c1 f8 1f             	sar    $0x1f,%eax
 20c:	c1 fa 17             	sar    $0x17,%edx
 20f:	29 c2                	sub    %eax,%edx
 211:	69 d2 00 2d 31 01    	imul   $0x1312d00,%edx,%edx
 217:	39 d3                	cmp    %edx,%ebx
 219:	75 dd                	jne    1f8 <basicthreadmain+0x18>
      printf(1, "%d", tid);
 21b:	89 74 24 08          	mov    %esi,0x8(%esp)
void*
basicthreadmain(void *arg)
{
  int tid = (int) arg;
  int i;
  for (i = 0; i < 100000000; i++){
 21f:	83 c3 01             	add    $0x1,%ebx
    if (i % 20000000 == 0){
      printf(1, "%d", tid);
 222:	c7 44 24 04 f8 0e 00 	movl   $0xef8,0x4(%esp)
 229:	00 
 22a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 231:	e8 5a 09 00 00       	call   b90 <printf>
void*
basicthreadmain(void *arg)
{
  int tid = (int) arg;
  int i;
  for (i = 0; i < 100000000; i++){
 236:	81 fb 00 e1 f5 05    	cmp    $0x5f5e100,%ebx
 23c:	75 c5                	jne    203 <basicthreadmain+0x23>
    if (i % 20000000 == 0){
      printf(1, "%d", tid);
    }
  }
  thread_exit((void *)(tid+1));
 23e:	83 c6 01             	add    $0x1,%esi
 241:	89 34 24             	mov    %esi,(%esp)
 244:	e8 89 08 00 00       	call   ad2 <thread_exit>
  return 0;
}
 249:	83 c4 1c             	add    $0x1c,%esp
 24c:	31 c0                	xor    %eax,%eax
 24e:	5b                   	pop    %ebx
 24f:	5e                   	pop    %esi
 250:	5f                   	pop    %edi
 251:	5d                   	pop    %ebp
 252:	c3                   	ret    
 253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000260 <jointhreadmain>:

// ============================================================================

void*
jointhreadmain(void *arg)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 ec 18             	sub    $0x18,%esp
  int val = (int)arg;
  sleep(200);
 266:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
 26d:	e8 20 08 00 00       	call   a92 <sleep>
  printf(1, "thread_exit...\n");
 272:	c7 44 24 04 fb 0e 00 	movl   $0xefb,0x4(%esp)
 279:	00 
 27a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 281:	e8 0a 09 00 00       	call   b90 <printf>
  thread_exit((void *)(val*2));
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	01 c0                	add    %eax,%eax
 28b:	89 04 24             	mov    %eax,(%esp)
 28e:	e8 3f 08 00 00       	call   ad2 <thread_exit>
  return 0;
}
 293:	31 c0                	xor    %eax,%eax
 295:	c9                   	leave  
 296:	c3                   	ret    
 297:	89 f6                	mov    %esi,%esi
 299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002a0 <stressthreadmain>:

// ============================================================================

void*
stressthreadmain(void *arg)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 18             	sub    $0x18,%esp
  thread_exit(0);
 2a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2ad:	e8 20 08 00 00       	call   ad2 <thread_exit>
  return 0;
}
 2b2:	31 c0                	xor    %eax,%eax
 2b4:	c9                   	leave  
 2b5:	c3                   	ret    
 2b6:	8d 76 00             	lea    0x0(%esi),%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <racingthreadmain>:
// ============================================================================
void nop(){ }

void*
racingthreadmain(void *arg)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	83 ec 18             	sub    $0x18,%esp
    tmp = gcnt;
    tmp++;
    nop();
    gcnt = tmp;
  }
  thread_exit((void *)(tid+1));
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	81 05 b8 14 00 00 80 	addl   $0x989680,0x14b8
 2d0:	96 98 00 
 2d3:	83 c0 01             	add    $0x1,%eax
 2d6:	89 04 24             	mov    %eax,(%esp)
 2d9:	e8 f4 07 00 00       	call   ad2 <thread_exit>
  return 0;
}
 2de:	31 c0                	xor    %eax,%eax
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    
 2e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <racingtest>:

int
racingtest(void)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	56                   	push   %esi
 2f4:	53                   	push   %ebx
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  gcnt = 0;
  
  for (i = 0; i < NUM_THREAD; i++){
 2f5:	31 db                	xor    %ebx,%ebx
  return 0;
}

int
racingtest(void)
{
 2f7:	83 ec 50             	sub    $0x50,%esp
 2fa:	8d 75 d0             	lea    -0x30(%ebp),%esi
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  gcnt = 0;
 2fd:	c7 05 b8 14 00 00 00 	movl   $0x0,0x14b8
 304:	00 00 00 
 307:	90                   	nop
  
  for (i = 0; i < NUM_THREAD; i++){
    printf(1, "(racingtest): thread_create nunber: %d\n", i);
 308:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 30c:	c7 44 24 04 c4 0f 00 	movl   $0xfc4,0x4(%esp)
 313:	00 
 314:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 31b:	e8 70 08 00 00       	call   b90 <printf>
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
 320:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 324:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
 32b:	00 
 32c:	89 34 24             	mov    %esi,(%esp)
 32f:	e8 96 07 00 00       	call   aca <thread_create>
 334:	85 c0                	test   %eax,%eax
 336:	75 68                	jne    3a0 <racingtest+0xb0>
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  gcnt = 0;
  
  for (i = 0; i < NUM_THREAD; i++){
 338:	83 c3 01             	add    $0x1,%ebx
 33b:	83 c6 04             	add    $0x4,%esi
 33e:	83 fb 0a             	cmp    $0xa,%ebx
 341:	75 c5                	jne    308 <racingtest+0x18>
 343:	30 db                	xor    %bl,%bl
 345:	8d 75 cc             	lea    -0x34(%ebp),%esi
 348:	eb 08                	jmp    352 <racingtest+0x62>
 34a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
 350:	89 d3                	mov    %edx,%ebx
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 352:	8b 44 9d d0          	mov    -0x30(%ebp,%ebx,4),%eax
 356:	89 74 24 04          	mov    %esi,0x4(%esp)
 35a:	89 04 24             	mov    %eax,(%esp)
 35d:	e8 78 07 00 00       	call   ada <thread_join>
 362:	85 c0                	test   %eax,%eax
 364:	75 5a                	jne    3c0 <racingtest+0xd0>
 366:	8b 55 cc             	mov    -0x34(%ebp),%edx
 369:	83 c3 01             	add    $0x1,%ebx
 36c:	39 da                	cmp    %ebx,%edx
 36e:	75 53                	jne    3c3 <racingtest+0xd3>
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
 370:	83 fa 0a             	cmp    $0xa,%edx
 373:	75 db                	jne    350 <racingtest+0x60>
      printf(1, "panic at thread_join\n");
      printf(1, "desired retval: %d, real retval: %d\n", i+1, (int)retval);
      return -1;
    }
  }
  printf(1,"%d\n", gcnt);
 375:	8b 15 b8 14 00 00    	mov    0x14b8,%edx
 37b:	c7 44 24 04 39 0f 00 	movl   $0xf39,0x4(%esp)
 382:	00 
 383:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 38a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 38d:	89 54 24 08          	mov    %edx,0x8(%esp)
 391:	e8 fa 07 00 00       	call   b90 <printf>
 396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  return 0;
}
 399:	83 c4 50             	add    $0x50,%esp
 39c:	5b                   	pop    %ebx
 39d:	5e                   	pop    %esi
 39e:	5d                   	pop    %ebp
 39f:	c3                   	ret    
  gcnt = 0;
  
  for (i = 0; i < NUM_THREAD; i++){
    printf(1, "(racingtest): thread_create nunber: %d\n", i);
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
 3a0:	c7 44 24 04 0b 0f 00 	movl   $0xf0b,0x4(%esp)
 3a7:	00 
 3a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3af:	e8 dc 07 00 00       	call   b90 <printf>
      return -1;
    }
  }
  printf(1,"%d\n", gcnt);
  return 0;
}
 3b4:	83 c4 50             	add    $0x50,%esp
  
  for (i = 0; i < NUM_THREAD; i++){
    printf(1, "(racingtest): thread_create nunber: %d\n", i);
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
 3b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"%d\n", gcnt);
  return 0;
}
 3bc:	5b                   	pop    %ebx
 3bd:	5e                   	pop    %esi
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret    
 3c0:	83 c3 01             	add    $0x1,%ebx
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
 3c3:	c7 44 24 04 23 0f 00 	movl   $0xf23,0x4(%esp)
 3ca:	00 
 3cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3d2:	e8 b9 07 00 00       	call   b90 <printf>
      printf(1, "desired retval: %d, real retval: %d\n", i+1, (int)retval);
 3d7:	8b 45 cc             	mov    -0x34(%ebp),%eax
 3da:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 3de:	c7 44 24 04 ec 0f 00 	movl   $0xfec,0x4(%esp)
 3e5:	00 
 3e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
 3f1:	e8 9a 07 00 00       	call   b90 <printf>
      return -1;
    }
  }
  printf(1,"%d\n", gcnt);
  return 0;
}
 3f6:	83 c4 50             	add    $0x50,%esp
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
      printf(1, "desired retval: %d, real retval: %d\n", i+1, (int)retval);
      return -1;
 3f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
  }
  printf(1,"%d\n", gcnt);
  return 0;
}
 3fe:	5b                   	pop    %ebx
 3ff:	5e                   	pop    %esi
 400:	5d                   	pop    %ebp
 401:	c3                   	ret    
 402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000410 <jointest2>:
  return 0;
}

int
jointest2(void)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	56                   	push   %esi
 414:	53                   	push   %ebx
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
 415:	bb 01 00 00 00       	mov    $0x1,%ebx
  return 0;
}

int
jointest2(void)
{
 41a:	83 ec 40             	sub    $0x40,%esp
 41d:	8d 75 d0             	lea    -0x30(%ebp),%esi
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
 420:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 424:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
 42b:	00 
 42c:	89 34 24             	mov    %esi,(%esp)
 42f:	e8 96 06 00 00       	call   aca <thread_create>
 434:	85 c0                	test   %eax,%eax
 436:	75 78                	jne    4b0 <jointest2+0xa0>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
 438:	83 c3 01             	add    $0x1,%ebx
 43b:	83 c6 04             	add    $0x4,%esi
 43e:	83 fb 0b             	cmp    $0xb,%ebx
 441:	75 dd                	jne    420 <jointest2+0x10>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  sleep(500);
 443:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  printf(1, "thread_join!!!\n");
 44a:	b3 02                	mov    $0x2,%bl
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  sleep(500);
 44c:	e8 41 06 00 00       	call   a92 <sleep>
 451:	8d 75 cc             	lea    -0x34(%ebp),%esi
  printf(1, "thread_join!!!\n");
 454:	c7 44 24 04 3d 0f 00 	movl   $0xf3d,0x4(%esp)
 45b:	00 
 45c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 463:	e8 28 07 00 00       	call   b90 <printf>
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 468:	8b 44 5d cc          	mov    -0x34(%ebp,%ebx,2),%eax
 46c:	89 74 24 04          	mov    %esi,0x4(%esp)
 470:	89 04 24             	mov    %eax,(%esp)
 473:	e8 62 06 00 00       	call   ada <thread_join>
 478:	85 c0                	test   %eax,%eax
 47a:	75 54                	jne    4d0 <jointest2+0xc0>
 47c:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
 47f:	75 4f                	jne    4d0 <jointest2+0xc0>
 481:	83 c3 02             	add    $0x2,%ebx
      return -1;
    }
  }
  sleep(500);
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
 484:	83 fb 16             	cmp    $0x16,%ebx
 487:	75 df                	jne    468 <jointest2+0x58>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
 489:	c7 44 24 04 4b 0f 00 	movl   $0xf4b,0x4(%esp)
 490:	00 
 491:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 498:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 49b:	e8 f0 06 00 00       	call   b90 <printf>
 4a0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  return 0;
}
 4a3:	83 c4 40             	add    $0x40,%esp
 4a6:	5b                   	pop    %ebx
 4a7:	5e                   	pop    %esi
 4a8:	5d                   	pop    %ebp
 4a9:	c3                   	ret    
 4aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
      printf(1, "panic at thread_create\n");
 4b0:	c7 44 24 04 0b 0f 00 	movl   $0xf0b,0x4(%esp)
 4b7:	00 
 4b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4bf:	e8 cc 06 00 00       	call   b90 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
 4c4:	83 c4 40             	add    $0x40,%esp
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
 4c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
 4cc:	5b                   	pop    %ebx
 4cd:	5e                   	pop    %esi
 4ce:	5d                   	pop    %ebp
 4cf:	c3                   	ret    
  }
  sleep(500);
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
 4d0:	c7 44 24 04 23 0f 00 	movl   $0xf23,0x4(%esp)
 4d7:	00 
 4d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4df:	e8 ac 06 00 00       	call   b90 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
 4e4:	83 c4 40             	add    $0x40,%esp
  sleep(500);
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
      return -1;
 4e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
  }
  printf(1,"\n");
  return 0;
}
 4ec:	5b                   	pop    %ebx
 4ed:	5e                   	pop    %esi
 4ee:	5d                   	pop    %ebp
 4ef:	c3                   	ret    

000004f0 <basictest>:
  return 0;
}

int
basictest(void)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	56                   	push   %esi
 4f4:	53                   	push   %ebx
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
 4f5:	31 db                	xor    %ebx,%ebx
  return 0;
}

int
basictest(void)
{
 4f7:	83 ec 40             	sub    $0x40,%esp
 4fa:	8d 75 d0             	lea    -0x30(%ebp),%esi
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
 500:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 504:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
 50b:	00 
 50c:	89 34 24             	mov    %esi,(%esp)
 50f:	e8 b6 05 00 00       	call   aca <thread_create>
 514:	85 c0                	test   %eax,%eax
 516:	75 60                	jne    578 <basictest+0x88>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
 518:	83 c3 01             	add    $0x1,%ebx
 51b:	83 c6 04             	add    $0x4,%esi
 51e:	83 fb 0a             	cmp    $0xa,%ebx
 521:	75 dd                	jne    500 <basictest+0x10>
 523:	30 db                	xor    %bl,%bl
 525:	8d 75 cc             	lea    -0x34(%ebp),%esi
 528:	eb 08                	jmp    532 <basictest+0x42>
 52a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
 530:	89 d3                	mov    %edx,%ebx
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 532:	8b 44 9d d0          	mov    -0x30(%ebp,%ebx,4),%eax
 536:	89 74 24 04          	mov    %esi,0x4(%esp)
 53a:	89 04 24             	mov    %eax,(%esp)
 53d:	e8 98 05 00 00       	call   ada <thread_join>
 542:	85 c0                	test   %eax,%eax
 544:	75 52                	jne    598 <basictest+0xa8>
 546:	8b 55 cc             	mov    -0x34(%ebp),%edx
 549:	83 c3 01             	add    $0x1,%ebx
 54c:	39 da                	cmp    %ebx,%edx
 54e:	75 48                	jne    598 <basictest+0xa8>
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
 550:	83 fa 0a             	cmp    $0xa,%edx
 553:	75 db                	jne    530 <basictest+0x40>
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
 555:	c7 44 24 04 4b 0f 00 	movl   $0xf4b,0x4(%esp)
 55c:	00 
 55d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 564:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 567:	e8 24 06 00 00       	call   b90 <printf>
 56c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  return 0;
}
 56f:	83 c4 40             	add    $0x40,%esp
 572:	5b                   	pop    %ebx
 573:	5e                   	pop    %esi
 574:	5d                   	pop    %ebp
 575:	c3                   	ret    
 576:	66 90                	xchg   %ax,%ax
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
 578:	c7 44 24 04 0b 0f 00 	movl   $0xf0b,0x4(%esp)
 57f:	00 
 580:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 587:	e8 04 06 00 00       	call   b90 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
 58c:	83 c4 40             	add    $0x40,%esp
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
 58f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
 594:	5b                   	pop    %ebx
 595:	5e                   	pop    %esi
 596:	5d                   	pop    %ebp
 597:	c3                   	ret    
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
 598:	c7 44 24 04 23 0f 00 	movl   $0xf23,0x4(%esp)
 59f:	00 
 5a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5a7:	e8 e4 05 00 00       	call   b90 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
 5ac:	83 c4 40             	add    $0x40,%esp
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
 5af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
 5b4:	5b                   	pop    %ebx
 5b5:	5e                   	pop    %esi
 5b6:	5d                   	pop    %ebp
 5b7:	c3                   	ret    
 5b8:	90                   	nop
 5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005c0 <jointest1>:
  return 0;
}

int
jointest1(void)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	56                   	push   %esi
 5c4:	53                   	push   %ebx
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
 5c5:	bb 01 00 00 00       	mov    $0x1,%ebx
  return 0;
}

int
jointest1(void)
{
 5ca:	83 ec 40             	sub    $0x40,%esp
 5cd:	8d 75 d0             	lea    -0x30(%ebp),%esi
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
 5d0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 5d4:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
 5db:	00 
 5dc:	89 34 24             	mov    %esi,(%esp)
 5df:	e8 e6 04 00 00       	call   aca <thread_create>
 5e4:	85 c0                	test   %eax,%eax
 5e6:	75 70                	jne    658 <jointest1+0x98>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
 5e8:	83 c3 01             	add    $0x1,%ebx
 5eb:	83 c6 04             	add    $0x4,%esi
 5ee:	83 fb 0b             	cmp    $0xb,%ebx
 5f1:	75 dd                	jne    5d0 <jointest1+0x10>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  printf(1, "thread_join!!!\n");
 5f3:	c7 44 24 04 3d 0f 00 	movl   $0xf3d,0x4(%esp)
 5fa:	00 
 5fb:	b3 02                	mov    $0x2,%bl
 5fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 604:	8d 75 cc             	lea    -0x34(%ebp),%esi
 607:	e8 84 05 00 00       	call   b90 <printf>
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 610:	8b 44 5d cc          	mov    -0x34(%ebp,%ebx,2),%eax
 614:	89 74 24 04          	mov    %esi,0x4(%esp)
 618:	89 04 24             	mov    %eax,(%esp)
 61b:	e8 ba 04 00 00       	call   ada <thread_join>
 620:	85 c0                	test   %eax,%eax
 622:	75 54                	jne    678 <jointest1+0xb8>
 624:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
 627:	75 4f                	jne    678 <jointest1+0xb8>
 629:	83 c3 02             	add    $0x2,%ebx
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
 62c:	83 fb 16             	cmp    $0x16,%ebx
 62f:	75 df                	jne    610 <jointest1+0x50>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
 631:	c7 44 24 04 4b 0f 00 	movl   $0xf4b,0x4(%esp)
 638:	00 
 639:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 640:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 643:	e8 48 05 00 00       	call   b90 <printf>
 648:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  return 0;
}
 64b:	83 c4 40             	add    $0x40,%esp
 64e:	5b                   	pop    %ebx
 64f:	5e                   	pop    %esi
 650:	5d                   	pop    %ebp
 651:	c3                   	ret    
 652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
 658:	c7 44 24 04 0b 0f 00 	movl   $0xf0b,0x4(%esp)
 65f:	00 
 660:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 667:	e8 24 05 00 00       	call   b90 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
 66c:	83 c4 40             	add    $0x40,%esp
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
 66f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
 674:	5b                   	pop    %ebx
 675:	5e                   	pop    %esi
 676:	5d                   	pop    %ebp
 677:	c3                   	ret    
    }
  }
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
 678:	c7 44 24 04 23 0f 00 	movl   $0xf23,0x4(%esp)
 67f:	00 
 680:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 687:	e8 04 05 00 00       	call   b90 <printf>
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
 68c:	83 c4 40             	add    $0x40,%esp
    }
  }
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
 68f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
    }
  }
  printf(1,"\n");
  return 0;
}
 694:	5b                   	pop    %ebx
 695:	5e                   	pop    %esi
 696:	5d                   	pop    %ebp
 697:	c3                   	ret    
 698:	90                   	nop
 699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000006a0 <stresstest>:
  return 0;
}

int
stresstest(void)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 4c             	sub    $0x4c,%esp
 6a9:	8d 5d bc             	lea    -0x44(%ebp),%ebx
  const int nstress = 35000;
  thread_t threads[NUM_THREAD];
  int i, n;
  void *retval;

  for (n = 1; n <= nstress; n++){
 6ac:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
 6b3:	8d 75 c0             	lea    -0x40(%ebp),%esi
 6b6:	31 ff                	xor    %edi,%edi
    if (n % 1000 == 0)
      printf(1, "%d\n", n);
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
 6b8:	89 7c 24 08          	mov    %edi,0x8(%esp)
 6bc:	c7 44 24 04 a0 02 00 	movl   $0x2a0,0x4(%esp)
 6c3:	00 
 6c4:	89 34 24             	mov    %esi,(%esp)
 6c7:	e8 fe 03 00 00       	call   aca <thread_create>
 6cc:	85 c0                	test   %eax,%eax
 6ce:	0f 85 8c 00 00 00    	jne    760 <stresstest+0xc0>
  void *retval;

  for (n = 1; n <= nstress; n++){
    if (n % 1000 == 0)
      printf(1, "%d\n", n);
    for (i = 0; i < NUM_THREAD; i++){
 6d4:	83 c7 01             	add    $0x1,%edi
 6d7:	83 c6 04             	add    $0x4,%esi
 6da:	83 ff 0a             	cmp    $0xa,%edi
 6dd:	75 d9                	jne    6b8 <stresstest+0x18>
 6df:	8d 7d c0             	lea    -0x40(%ebp),%edi
 6e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
 6e8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 6ec:	8b 07                	mov    (%edi),%eax
 6ee:	89 04 24             	mov    %eax,(%esp)
 6f1:	e8 e4 03 00 00       	call   ada <thread_join>
 6f6:	85 c0                	test   %eax,%eax
 6f8:	0f 85 8a 00 00 00    	jne    788 <stresstest+0xe8>
 6fe:	83 c7 04             	add    $0x4,%edi
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
 701:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 704:	39 cf                	cmp    %ecx,%edi
 706:	75 e0                	jne    6e8 <stresstest+0x48>
  const int nstress = 35000;
  thread_t threads[NUM_THREAD];
  int i, n;
  void *retval;

  for (n = 1; n <= nstress; n++){
 708:	83 45 b4 01          	addl   $0x1,-0x4c(%ebp)
 70c:	81 7d b4 b9 88 00 00 	cmpl   $0x88b9,-0x4c(%ebp)
 713:	0f 84 90 00 00 00    	je     7a9 <stresstest+0x109>
    if (n % 1000 == 0)
 719:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 71c:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 721:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
 724:	f7 ea                	imul   %edx
 726:	89 c8                	mov    %ecx,%eax
 728:	c1 f8 1f             	sar    $0x1f,%eax
 72b:	c1 fa 06             	sar    $0x6,%edx
 72e:	29 c2                	sub    %eax,%edx
 730:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
 736:	39 d1                	cmp    %edx,%ecx
 738:	0f 85 75 ff ff ff    	jne    6b3 <stresstest+0x13>
      printf(1, "%d\n", n);
 73e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 742:	c7 44 24 04 39 0f 00 	movl   $0xf39,0x4(%esp)
 749:	00 
 74a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 751:	e8 3a 04 00 00       	call   b90 <printf>
 756:	e9 58 ff ff ff       	jmp    6b3 <stresstest+0x13>
 75b:	90                   	nop
 75c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
 760:	c7 44 24 04 0b 0f 00 	movl   $0xf0b,0x4(%esp)
 767:	00 
 768:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 76f:	e8 1c 04 00 00       	call   b90 <printf>
        return -1;
 774:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      }
    }
  }
  printf(1, "\n");
  return 0;
}
 779:	83 c4 4c             	add    $0x4c,%esp
 77c:	5b                   	pop    %ebx
 77d:	5e                   	pop    %esi
 77e:	5f                   	pop    %edi
 77f:	5d                   	pop    %ebp
 780:	c3                   	ret    
 781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
        printf(1, "panic at thread_join\n");
 788:	c7 44 24 04 23 0f 00 	movl   $0xf23,0x4(%esp)
 78f:	00 
 790:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 797:	e8 f4 03 00 00       	call   b90 <printf>
      }
    }
  }
  printf(1, "\n");
  return 0;
}
 79c:	83 c4 4c             	add    $0x4c,%esp
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
      if (thread_join(threads[i], &retval) != 0){
        printf(1, "panic at thread_join\n");
        return -1;
 79f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      }
    }
  }
  printf(1, "\n");
  return 0;
}
 7a4:	5b                   	pop    %ebx
 7a5:	5e                   	pop    %esi
 7a6:	5f                   	pop    %edi
 7a7:	5d                   	pop    %ebp
 7a8:	c3                   	ret    
        printf(1, "panic at thread_join\n");
        return -1;
      }
    }
  }
  printf(1, "\n");
 7a9:	c7 44 24 04 4b 0f 00 	movl   $0xf4b,0x4(%esp)
 7b0:	00 
 7b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 7b8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 7bb:	e8 d0 03 00 00       	call   b90 <printf>
 7c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
 7c3:	eb b4                	jmp    779 <stresstest+0xd9>
 7c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007d0 <nop>:
  }
  exit();
}

// ============================================================================
void nop(){ }
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	5d                   	pop    %ebp
 7d4:	c3                   	ret    
 7d5:	66 90                	xchg   %ax,%ax
 7d7:	66 90                	xchg   %ax,%ax
 7d9:	66 90                	xchg   %ax,%ax
 7db:	66 90                	xchg   %ax,%ax
 7dd:	66 90                	xchg   %ax,%ax
 7df:	90                   	nop

000007e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	8b 45 08             	mov    0x8(%ebp),%eax
 7e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 7e9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 7ea:	89 c2                	mov    %eax,%edx
 7ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7f0:	83 c1 01             	add    $0x1,%ecx
 7f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 7f7:	83 c2 01             	add    $0x1,%edx
 7fa:	84 db                	test   %bl,%bl
 7fc:	88 5a ff             	mov    %bl,-0x1(%edx)
 7ff:	75 ef                	jne    7f0 <strcpy+0x10>
    ;
  return os;
}
 801:	5b                   	pop    %ebx
 802:	5d                   	pop    %ebp
 803:	c3                   	ret    
 804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 80a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000810 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 810:	55                   	push   %ebp
 811:	89 e5                	mov    %esp,%ebp
 813:	8b 55 08             	mov    0x8(%ebp),%edx
 816:	53                   	push   %ebx
 817:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 81a:	0f b6 02             	movzbl (%edx),%eax
 81d:	84 c0                	test   %al,%al
 81f:	74 2d                	je     84e <strcmp+0x3e>
 821:	0f b6 19             	movzbl (%ecx),%ebx
 824:	38 d8                	cmp    %bl,%al
 826:	74 0e                	je     836 <strcmp+0x26>
 828:	eb 2b                	jmp    855 <strcmp+0x45>
 82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 830:	38 c8                	cmp    %cl,%al
 832:	75 15                	jne    849 <strcmp+0x39>
    p++, q++;
 834:	89 d9                	mov    %ebx,%ecx
 836:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 839:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 83c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 83f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 843:	84 c0                	test   %al,%al
 845:	75 e9                	jne    830 <strcmp+0x20>
 847:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 849:	29 c8                	sub    %ecx,%eax
}
 84b:	5b                   	pop    %ebx
 84c:	5d                   	pop    %ebp
 84d:	c3                   	ret    
 84e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 851:	31 c0                	xor    %eax,%eax
 853:	eb f4                	jmp    849 <strcmp+0x39>
 855:	0f b6 cb             	movzbl %bl,%ecx
 858:	eb ef                	jmp    849 <strcmp+0x39>
 85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000860 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 866:	80 39 00             	cmpb   $0x0,(%ecx)
 869:	74 12                	je     87d <strlen+0x1d>
 86b:	31 d2                	xor    %edx,%edx
 86d:	8d 76 00             	lea    0x0(%esi),%esi
 870:	83 c2 01             	add    $0x1,%edx
 873:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 877:	89 d0                	mov    %edx,%eax
 879:	75 f5                	jne    870 <strlen+0x10>
    ;
  return n;
}
 87b:	5d                   	pop    %ebp
 87c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 87d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 87f:	5d                   	pop    %ebp
 880:	c3                   	ret    
 881:	eb 0d                	jmp    890 <memset>
 883:	90                   	nop
 884:	90                   	nop
 885:	90                   	nop
 886:	90                   	nop
 887:	90                   	nop
 888:	90                   	nop
 889:	90                   	nop
 88a:	90                   	nop
 88b:	90                   	nop
 88c:	90                   	nop
 88d:	90                   	nop
 88e:	90                   	nop
 88f:	90                   	nop

00000890 <memset>:

void*
memset(void *dst, int c, uint n)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	8b 55 08             	mov    0x8(%ebp),%edx
 896:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 897:	8b 4d 10             	mov    0x10(%ebp),%ecx
 89a:	8b 45 0c             	mov    0xc(%ebp),%eax
 89d:	89 d7                	mov    %edx,%edi
 89f:	fc                   	cld    
 8a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 8a2:	89 d0                	mov    %edx,%eax
 8a4:	5f                   	pop    %edi
 8a5:	5d                   	pop    %ebp
 8a6:	c3                   	ret    
 8a7:	89 f6                	mov    %esi,%esi
 8a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008b0 <strchr>:

char*
strchr(const char *s, char c)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	8b 45 08             	mov    0x8(%ebp),%eax
 8b6:	53                   	push   %ebx
 8b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 8ba:	0f b6 18             	movzbl (%eax),%ebx
 8bd:	84 db                	test   %bl,%bl
 8bf:	74 1d                	je     8de <strchr+0x2e>
    if(*s == c)
 8c1:	38 d3                	cmp    %dl,%bl
 8c3:	89 d1                	mov    %edx,%ecx
 8c5:	75 0d                	jne    8d4 <strchr+0x24>
 8c7:	eb 17                	jmp    8e0 <strchr+0x30>
 8c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8d0:	38 ca                	cmp    %cl,%dl
 8d2:	74 0c                	je     8e0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 8d4:	83 c0 01             	add    $0x1,%eax
 8d7:	0f b6 10             	movzbl (%eax),%edx
 8da:	84 d2                	test   %dl,%dl
 8dc:	75 f2                	jne    8d0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 8de:	31 c0                	xor    %eax,%eax
}
 8e0:	5b                   	pop    %ebx
 8e1:	5d                   	pop    %ebp
 8e2:	c3                   	ret    
 8e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008f0 <gets>:

char*
gets(char *buf, int max)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	57                   	push   %edi
 8f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8f5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 8f7:	53                   	push   %ebx
 8f8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 8fb:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8fe:	eb 31                	jmp    931 <gets+0x41>
    cc = read(0, &c, 1);
 900:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 907:	00 
 908:	89 7c 24 04          	mov    %edi,0x4(%esp)
 90c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 913:	e8 02 01 00 00       	call   a1a <read>
    if(cc < 1)
 918:	85 c0                	test   %eax,%eax
 91a:	7e 1d                	jle    939 <gets+0x49>
      break;
    buf[i++] = c;
 91c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 920:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 922:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 925:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 927:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 92b:	74 0c                	je     939 <gets+0x49>
 92d:	3c 0a                	cmp    $0xa,%al
 92f:	74 08                	je     939 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 931:	8d 5e 01             	lea    0x1(%esi),%ebx
 934:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 937:	7c c7                	jl     900 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 939:	8b 45 08             	mov    0x8(%ebp),%eax
 93c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 940:	83 c4 2c             	add    $0x2c,%esp
 943:	5b                   	pop    %ebx
 944:	5e                   	pop    %esi
 945:	5f                   	pop    %edi
 946:	5d                   	pop    %ebp
 947:	c3                   	ret    
 948:	90                   	nop
 949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000950 <stat>:

int
stat(char *n, struct stat *st)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	56                   	push   %esi
 954:	53                   	push   %ebx
 955:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 958:	8b 45 08             	mov    0x8(%ebp),%eax
 95b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 962:	00 
 963:	89 04 24             	mov    %eax,(%esp)
 966:	e8 d7 00 00 00       	call   a42 <open>
  if(fd < 0)
 96b:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 96d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 96f:	78 27                	js     998 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 971:	8b 45 0c             	mov    0xc(%ebp),%eax
 974:	89 1c 24             	mov    %ebx,(%esp)
 977:	89 44 24 04          	mov    %eax,0x4(%esp)
 97b:	e8 da 00 00 00       	call   a5a <fstat>
  close(fd);
 980:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 983:	89 c6                	mov    %eax,%esi
  close(fd);
 985:	e8 a0 00 00 00       	call   a2a <close>
  return r;
 98a:	89 f0                	mov    %esi,%eax
}
 98c:	83 c4 10             	add    $0x10,%esp
 98f:	5b                   	pop    %ebx
 990:	5e                   	pop    %esi
 991:	5d                   	pop    %ebp
 992:	c3                   	ret    
 993:	90                   	nop
 994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 99d:	eb ed                	jmp    98c <stat+0x3c>
 99f:	90                   	nop

000009a0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 9a6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 9a7:	0f be 11             	movsbl (%ecx),%edx
 9aa:	8d 42 d0             	lea    -0x30(%edx),%eax
 9ad:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 9af:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 9b4:	77 17                	ja     9cd <atoi+0x2d>
 9b6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 9b8:	83 c1 01             	add    $0x1,%ecx
 9bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 9be:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 9c2:	0f be 11             	movsbl (%ecx),%edx
 9c5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 9c8:	80 fb 09             	cmp    $0x9,%bl
 9cb:	76 eb                	jbe    9b8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 9cd:	5b                   	pop    %ebx
 9ce:	5d                   	pop    %ebp
 9cf:	c3                   	ret    

000009d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 9d0:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 9d1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
 9d3:	89 e5                	mov    %esp,%ebp
 9d5:	56                   	push   %esi
 9d6:	8b 45 08             	mov    0x8(%ebp),%eax
 9d9:	53                   	push   %ebx
 9da:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 9e0:	85 db                	test   %ebx,%ebx
 9e2:	7e 12                	jle    9f6 <memmove+0x26>
 9e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 9e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 9ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 9ef:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 9f2:	39 da                	cmp    %ebx,%edx
 9f4:	75 f2                	jne    9e8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 9f6:	5b                   	pop    %ebx
 9f7:	5e                   	pop    %esi
 9f8:	5d                   	pop    %ebp
 9f9:	c3                   	ret    

000009fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 9fa:	b8 01 00 00 00       	mov    $0x1,%eax
 9ff:	cd 40                	int    $0x40
 a01:	c3                   	ret    

00000a02 <exit>:
SYSCALL(exit)
 a02:	b8 02 00 00 00       	mov    $0x2,%eax
 a07:	cd 40                	int    $0x40
 a09:	c3                   	ret    

00000a0a <wait>:
SYSCALL(wait)
 a0a:	b8 03 00 00 00       	mov    $0x3,%eax
 a0f:	cd 40                	int    $0x40
 a11:	c3                   	ret    

00000a12 <pipe>:
SYSCALL(pipe)
 a12:	b8 04 00 00 00       	mov    $0x4,%eax
 a17:	cd 40                	int    $0x40
 a19:	c3                   	ret    

00000a1a <read>:
SYSCALL(read)
 a1a:	b8 05 00 00 00       	mov    $0x5,%eax
 a1f:	cd 40                	int    $0x40
 a21:	c3                   	ret    

00000a22 <write>:
SYSCALL(write)
 a22:	b8 10 00 00 00       	mov    $0x10,%eax
 a27:	cd 40                	int    $0x40
 a29:	c3                   	ret    

00000a2a <close>:
SYSCALL(close)
 a2a:	b8 15 00 00 00       	mov    $0x15,%eax
 a2f:	cd 40                	int    $0x40
 a31:	c3                   	ret    

00000a32 <kill>:
SYSCALL(kill)
 a32:	b8 06 00 00 00       	mov    $0x6,%eax
 a37:	cd 40                	int    $0x40
 a39:	c3                   	ret    

00000a3a <exec>:
SYSCALL(exec)
 a3a:	b8 07 00 00 00       	mov    $0x7,%eax
 a3f:	cd 40                	int    $0x40
 a41:	c3                   	ret    

00000a42 <open>:
SYSCALL(open)
 a42:	b8 0f 00 00 00       	mov    $0xf,%eax
 a47:	cd 40                	int    $0x40
 a49:	c3                   	ret    

00000a4a <mknod>:
SYSCALL(mknod)
 a4a:	b8 11 00 00 00       	mov    $0x11,%eax
 a4f:	cd 40                	int    $0x40
 a51:	c3                   	ret    

00000a52 <unlink>:
SYSCALL(unlink)
 a52:	b8 12 00 00 00       	mov    $0x12,%eax
 a57:	cd 40                	int    $0x40
 a59:	c3                   	ret    

00000a5a <fstat>:
SYSCALL(fstat)
 a5a:	b8 08 00 00 00       	mov    $0x8,%eax
 a5f:	cd 40                	int    $0x40
 a61:	c3                   	ret    

00000a62 <link>:
SYSCALL(link)
 a62:	b8 13 00 00 00       	mov    $0x13,%eax
 a67:	cd 40                	int    $0x40
 a69:	c3                   	ret    

00000a6a <mkdir>:
SYSCALL(mkdir)
 a6a:	b8 14 00 00 00       	mov    $0x14,%eax
 a6f:	cd 40                	int    $0x40
 a71:	c3                   	ret    

00000a72 <chdir>:
SYSCALL(chdir)
 a72:	b8 09 00 00 00       	mov    $0x9,%eax
 a77:	cd 40                	int    $0x40
 a79:	c3                   	ret    

00000a7a <dup>:
SYSCALL(dup)
 a7a:	b8 0a 00 00 00       	mov    $0xa,%eax
 a7f:	cd 40                	int    $0x40
 a81:	c3                   	ret    

00000a82 <getpid>:
SYSCALL(getpid)
 a82:	b8 0b 00 00 00       	mov    $0xb,%eax
 a87:	cd 40                	int    $0x40
 a89:	c3                   	ret    

00000a8a <sbrk>:
SYSCALL(sbrk)
 a8a:	b8 0c 00 00 00       	mov    $0xc,%eax
 a8f:	cd 40                	int    $0x40
 a91:	c3                   	ret    

00000a92 <sleep>:
SYSCALL(sleep)
 a92:	b8 0d 00 00 00       	mov    $0xd,%eax
 a97:	cd 40                	int    $0x40
 a99:	c3                   	ret    

00000a9a <uptime>:
SYSCALL(uptime)
 a9a:	b8 0e 00 00 00       	mov    $0xe,%eax
 a9f:	cd 40                	int    $0x40
 aa1:	c3                   	ret    

00000aa2 <my_syscall>:
SYSCALL(my_syscall)
 aa2:	b8 16 00 00 00       	mov    $0x16,%eax
 aa7:	cd 40                	int    $0x40
 aa9:	c3                   	ret    

00000aaa <getppid>:
SYSCALL(getppid)
 aaa:	b8 17 00 00 00       	mov    $0x17,%eax
 aaf:	cd 40                	int    $0x40
 ab1:	c3                   	ret    

00000ab2 <yield>:
SYSCALL(yield)
 ab2:	b8 18 00 00 00       	mov    $0x18,%eax
 ab7:	cd 40                	int    $0x40
 ab9:	c3                   	ret    

00000aba <getlev>:
SYSCALL(getlev)
 aba:	b8 19 00 00 00       	mov    $0x19,%eax
 abf:	cd 40                	int    $0x40
 ac1:	c3                   	ret    

00000ac2 <set_cpu_share>:
SYSCALL(set_cpu_share)
 ac2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 ac7:	cd 40                	int    $0x40
 ac9:	c3                   	ret    

00000aca <thread_create>:
SYSCALL(thread_create)
 aca:	b8 1b 00 00 00       	mov    $0x1b,%eax
 acf:	cd 40                	int    $0x40
 ad1:	c3                   	ret    

00000ad2 <thread_exit>:
SYSCALL(thread_exit)
 ad2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 ad7:	cd 40                	int    $0x40
 ad9:	c3                   	ret    

00000ada <thread_join>:
SYSCALL(thread_join)
 ada:	b8 1d 00 00 00       	mov    $0x1d,%eax
 adf:	cd 40                	int    $0x40
 ae1:	c3                   	ret    

00000ae2 <gettid>:
SYSCALL(gettid)
 ae2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 ae7:	cd 40                	int    $0x40
 ae9:	c3                   	ret    
 aea:	66 90                	xchg   %ax,%ax
 aec:	66 90                	xchg   %ax,%ax
 aee:	66 90                	xchg   %ax,%ax

00000af0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 af0:	55                   	push   %ebp
 af1:	89 e5                	mov    %esp,%ebp
 af3:	57                   	push   %edi
 af4:	56                   	push   %esi
 af5:	89 c6                	mov    %eax,%esi
 af7:	53                   	push   %ebx
 af8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 afb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 afe:	85 db                	test   %ebx,%ebx
 b00:	74 09                	je     b0b <printint+0x1b>
 b02:	89 d0                	mov    %edx,%eax
 b04:	c1 e8 1f             	shr    $0x1f,%eax
 b07:	84 c0                	test   %al,%al
 b09:	75 75                	jne    b80 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 b0b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 b0d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 b14:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 b17:	31 ff                	xor    %edi,%edi
 b19:	89 ce                	mov    %ecx,%esi
 b1b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 b1e:	eb 02                	jmp    b22 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 b20:	89 cf                	mov    %ecx,%edi
 b22:	31 d2                	xor    %edx,%edx
 b24:	f7 f6                	div    %esi
 b26:	8d 4f 01             	lea    0x1(%edi),%ecx
 b29:	0f b6 92 1b 10 00 00 	movzbl 0x101b(%edx),%edx
  }while((x /= base) != 0);
 b30:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 b32:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 b35:	75 e9                	jne    b20 <printint+0x30>
  if(neg)
 b37:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 b3a:	89 c8                	mov    %ecx,%eax
 b3c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 b3f:	85 d2                	test   %edx,%edx
 b41:	74 08                	je     b4b <printint+0x5b>
    buf[i++] = '-';
 b43:	8d 4f 02             	lea    0x2(%edi),%ecx
 b46:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 b4b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 b4e:	66 90                	xchg   %ax,%ax
 b50:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 b55:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 b58:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 b5f:	00 
 b60:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 b64:	89 34 24             	mov    %esi,(%esp)
 b67:	88 45 d7             	mov    %al,-0x29(%ebp)
 b6a:	e8 b3 fe ff ff       	call   a22 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 b6f:	83 ff ff             	cmp    $0xffffffff,%edi
 b72:	75 dc                	jne    b50 <printint+0x60>
    putc(fd, buf[i]);
}
 b74:	83 c4 4c             	add    $0x4c,%esp
 b77:	5b                   	pop    %ebx
 b78:	5e                   	pop    %esi
 b79:	5f                   	pop    %edi
 b7a:	5d                   	pop    %ebp
 b7b:	c3                   	ret    
 b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 b80:	89 d0                	mov    %edx,%eax
 b82:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 b84:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 b8b:	eb 87                	jmp    b14 <printint+0x24>
 b8d:	8d 76 00             	lea    0x0(%esi),%esi

00000b90 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b90:	55                   	push   %ebp
 b91:	89 e5                	mov    %esp,%ebp
 b93:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b94:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b96:	56                   	push   %esi
 b97:	53                   	push   %ebx
 b98:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 b9e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 ba1:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 ba4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 ba7:	0f b6 13             	movzbl (%ebx),%edx
 baa:	83 c3 01             	add    $0x1,%ebx
 bad:	84 d2                	test   %dl,%dl
 baf:	75 39                	jne    bea <printf+0x5a>
 bb1:	e9 c2 00 00 00       	jmp    c78 <printf+0xe8>
 bb6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 bb8:	83 fa 25             	cmp    $0x25,%edx
 bbb:	0f 84 bf 00 00 00    	je     c80 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 bc1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 bc4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 bcb:	00 
 bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
 bd0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 bd3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 bd6:	e8 47 fe ff ff       	call   a22 <write>
 bdb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 bde:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 be2:	84 d2                	test   %dl,%dl
 be4:	0f 84 8e 00 00 00    	je     c78 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 bea:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 bec:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 bef:	74 c7                	je     bb8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 bf1:	83 ff 25             	cmp    $0x25,%edi
 bf4:	75 e5                	jne    bdb <printf+0x4b>
      if(c == 'd'){
 bf6:	83 fa 64             	cmp    $0x64,%edx
 bf9:	0f 84 31 01 00 00    	je     d30 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 bff:	25 f7 00 00 00       	and    $0xf7,%eax
 c04:	83 f8 70             	cmp    $0x70,%eax
 c07:	0f 84 83 00 00 00    	je     c90 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 c0d:	83 fa 73             	cmp    $0x73,%edx
 c10:	0f 84 a2 00 00 00    	je     cb8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 c16:	83 fa 63             	cmp    $0x63,%edx
 c19:	0f 84 35 01 00 00    	je     d54 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 c1f:	83 fa 25             	cmp    $0x25,%edx
 c22:	0f 84 e0 00 00 00    	je     d08 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c28:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 c2b:	83 c3 01             	add    $0x1,%ebx
 c2e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 c35:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 c36:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c38:	89 44 24 04          	mov    %eax,0x4(%esp)
 c3c:	89 34 24             	mov    %esi,(%esp)
 c3f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 c42:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 c46:	e8 d7 fd ff ff       	call   a22 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 c4b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c4e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 c51:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 c58:	00 
 c59:	89 44 24 04          	mov    %eax,0x4(%esp)
 c5d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 c60:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 c63:	e8 ba fd ff ff       	call   a22 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c68:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 c6c:	84 d2                	test   %dl,%dl
 c6e:	0f 85 76 ff ff ff    	jne    bea <printf+0x5a>
 c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 c78:	83 c4 3c             	add    $0x3c,%esp
 c7b:	5b                   	pop    %ebx
 c7c:	5e                   	pop    %esi
 c7d:	5f                   	pop    %edi
 c7e:	5d                   	pop    %ebp
 c7f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 c80:	bf 25 00 00 00       	mov    $0x25,%edi
 c85:	e9 51 ff ff ff       	jmp    bdb <printf+0x4b>
 c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 c90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 c93:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 c98:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 c9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 ca1:	8b 10                	mov    (%eax),%edx
 ca3:	89 f0                	mov    %esi,%eax
 ca5:	e8 46 fe ff ff       	call   af0 <printint>
        ap++;
 caa:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 cae:	e9 28 ff ff ff       	jmp    bdb <printf+0x4b>
 cb3:	90                   	nop
 cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 cb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 cbb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 cbf:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 cc1:	b8 14 10 00 00       	mov    $0x1014,%eax
 cc6:	85 ff                	test   %edi,%edi
 cc8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 ccb:	0f b6 07             	movzbl (%edi),%eax
 cce:	84 c0                	test   %al,%al
 cd0:	74 2a                	je     cfc <printf+0x16c>
 cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 cd8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 cdb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 cde:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 ce1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 ce8:	00 
 ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
 ced:	89 34 24             	mov    %esi,(%esp)
 cf0:	e8 2d fd ff ff       	call   a22 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 cf5:	0f b6 07             	movzbl (%edi),%eax
 cf8:	84 c0                	test   %al,%al
 cfa:	75 dc                	jne    cd8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 cfc:	31 ff                	xor    %edi,%edi
 cfe:	e9 d8 fe ff ff       	jmp    bdb <printf+0x4b>
 d03:	90                   	nop
 d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d08:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 d0b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d0d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 d14:	00 
 d15:	89 44 24 04          	mov    %eax,0x4(%esp)
 d19:	89 34 24             	mov    %esi,(%esp)
 d1c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 d20:	e8 fd fc ff ff       	call   a22 <write>
 d25:	e9 b1 fe ff ff       	jmp    bdb <printf+0x4b>
 d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 d30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 d33:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 d38:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 d3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 d42:	8b 10                	mov    (%eax),%edx
 d44:	89 f0                	mov    %esi,%eax
 d46:	e8 a5 fd ff ff       	call   af0 <printint>
        ap++;
 d4b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 d4f:	e9 87 fe ff ff       	jmp    bdb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 d54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 d57:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 d59:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d5b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 d62:	00 
 d63:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 d66:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 d69:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
 d70:	e8 ad fc ff ff       	call   a22 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 d75:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 d79:	e9 5d fe ff ff       	jmp    bdb <printf+0x4b>
 d7e:	66 90                	xchg   %ax,%ax

00000d80 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d80:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d81:	a1 ac 14 00 00       	mov    0x14ac,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 d86:	89 e5                	mov    %esp,%ebp
 d88:	57                   	push   %edi
 d89:	56                   	push   %esi
 d8a:	53                   	push   %ebx
 d8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d8e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d90:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d93:	39 d0                	cmp    %edx,%eax
 d95:	72 11                	jb     da8 <free+0x28>
 d97:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d98:	39 c8                	cmp    %ecx,%eax
 d9a:	72 04                	jb     da0 <free+0x20>
 d9c:	39 ca                	cmp    %ecx,%edx
 d9e:	72 10                	jb     db0 <free+0x30>
 da0:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 da2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 da4:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 da6:	73 f0                	jae    d98 <free+0x18>
 da8:	39 ca                	cmp    %ecx,%edx
 daa:	72 04                	jb     db0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 dac:	39 c8                	cmp    %ecx,%eax
 dae:	72 f0                	jb     da0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 db0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 db3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 db6:	39 cf                	cmp    %ecx,%edi
 db8:	74 1e                	je     dd8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 dba:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 dbd:	8b 48 04             	mov    0x4(%eax),%ecx
 dc0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 dc3:	39 f2                	cmp    %esi,%edx
 dc5:	74 28                	je     def <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 dc7:	89 10                	mov    %edx,(%eax)
  freep = p;
 dc9:	a3 ac 14 00 00       	mov    %eax,0x14ac
}
 dce:	5b                   	pop    %ebx
 dcf:	5e                   	pop    %esi
 dd0:	5f                   	pop    %edi
 dd1:	5d                   	pop    %ebp
 dd2:	c3                   	ret    
 dd3:	90                   	nop
 dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 dd8:	03 71 04             	add    0x4(%ecx),%esi
 ddb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 dde:	8b 08                	mov    (%eax),%ecx
 de0:	8b 09                	mov    (%ecx),%ecx
 de2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 de5:	8b 48 04             	mov    0x4(%eax),%ecx
 de8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 deb:	39 f2                	cmp    %esi,%edx
 ded:	75 d8                	jne    dc7 <free+0x47>
    p->s.size += bp->s.size;
 def:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 df2:	a3 ac 14 00 00       	mov    %eax,0x14ac
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 df7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 dfa:	8b 53 f8             	mov    -0x8(%ebx),%edx
 dfd:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 dff:	5b                   	pop    %ebx
 e00:	5e                   	pop    %esi
 e01:	5f                   	pop    %edi
 e02:	5d                   	pop    %ebp
 e03:	c3                   	ret    
 e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000e10 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 e10:	55                   	push   %ebp
 e11:	89 e5                	mov    %esp,%ebp
 e13:	57                   	push   %edi
 e14:	56                   	push   %esi
 e15:	53                   	push   %ebx
 e16:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e19:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 e1c:	8b 1d ac 14 00 00    	mov    0x14ac,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e22:	8d 48 07             	lea    0x7(%eax),%ecx
 e25:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 e28:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e2a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 e2d:	0f 84 9b 00 00 00    	je     ece <malloc+0xbe>
 e33:	8b 13                	mov    (%ebx),%edx
 e35:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 e38:	39 fe                	cmp    %edi,%esi
 e3a:	76 64                	jbe    ea0 <malloc+0x90>
 e3c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 e43:	bb 00 80 00 00       	mov    $0x8000,%ebx
 e48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 e4b:	eb 0e                	jmp    e5b <malloc+0x4b>
 e4d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e50:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 e52:	8b 78 04             	mov    0x4(%eax),%edi
 e55:	39 fe                	cmp    %edi,%esi
 e57:	76 4f                	jbe    ea8 <malloc+0x98>
 e59:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 e5b:	3b 15 ac 14 00 00    	cmp    0x14ac,%edx
 e61:	75 ed                	jne    e50 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 e66:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 e6c:	bf 00 10 00 00       	mov    $0x1000,%edi
 e71:	0f 43 fe             	cmovae %esi,%edi
 e74:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 e77:	89 04 24             	mov    %eax,(%esp)
 e7a:	e8 0b fc ff ff       	call   a8a <sbrk>
  if(p == (char*)-1)
 e7f:	83 f8 ff             	cmp    $0xffffffff,%eax
 e82:	74 18                	je     e9c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 e84:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 e87:	83 c0 08             	add    $0x8,%eax
 e8a:	89 04 24             	mov    %eax,(%esp)
 e8d:	e8 ee fe ff ff       	call   d80 <free>
  return freep;
 e92:	8b 15 ac 14 00 00    	mov    0x14ac,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 e98:	85 d2                	test   %edx,%edx
 e9a:	75 b4                	jne    e50 <malloc+0x40>
        return 0;
 e9c:	31 c0                	xor    %eax,%eax
 e9e:	eb 20                	jmp    ec0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 ea0:	89 d0                	mov    %edx,%eax
 ea2:	89 da                	mov    %ebx,%edx
 ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 ea8:	39 fe                	cmp    %edi,%esi
 eaa:	74 1c                	je     ec8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 eac:	29 f7                	sub    %esi,%edi
 eae:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 eb1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 eb4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 eb7:	89 15 ac 14 00 00    	mov    %edx,0x14ac
      return (void*)(p + 1);
 ebd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ec0:	83 c4 1c             	add    $0x1c,%esp
 ec3:	5b                   	pop    %ebx
 ec4:	5e                   	pop    %esi
 ec5:	5f                   	pop    %edi
 ec6:	5d                   	pop    %ebp
 ec7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 ec8:	8b 08                	mov    (%eax),%ecx
 eca:	89 0a                	mov    %ecx,(%edx)
 ecc:	eb e9                	jmp    eb7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 ece:	c7 05 ac 14 00 00 b0 	movl   $0x14b0,0x14ac
 ed5:	14 00 00 
    base.s.size = 0;
 ed8:	ba b0 14 00 00       	mov    $0x14b0,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 edd:	c7 05 b0 14 00 00 b0 	movl   $0x14b0,0x14b0
 ee4:	14 00 00 
    base.s.size = 0;
 ee7:	c7 05 b4 14 00 00 00 	movl   $0x0,0x14b4
 eee:	00 00 00 
 ef1:	e9 46 ff ff ff       	jmp    e3c <malloc+0x2c>

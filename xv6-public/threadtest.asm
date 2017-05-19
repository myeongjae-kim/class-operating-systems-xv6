
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
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 30             	sub    $0x30,%esp
  int i;
  int ret;
  int pid;
  int start = 0;
   9:	c7 44 24 28 00 00 00 	movl   $0x0,0x28(%esp)
  10:	00 
  int end = NTEST-1;
  11:	c7 44 24 24 04 00 00 	movl   $0x4,0x24(%esp)
  18:	00 
  if (argc >= 2)
  19:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  1d:	7e 14                	jle    33 <main+0x33>
    start = atoi(argv[1]);
  1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  22:	83 c0 04             	add    $0x4,%eax
  25:	8b 00                	mov    (%eax),%eax
  27:	89 04 24             	mov    %eax,(%esp)
  2a:	e8 54 09 00 00       	call   983 <atoi>
  2f:	89 44 24 28          	mov    %eax,0x28(%esp)
  if (argc >= 3)
  33:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  37:	7e 14                	jle    4d <main+0x4d>
    end = atoi(argv[2]);
  39:	8b 45 0c             	mov    0xc(%ebp),%eax
  3c:	83 c0 08             	add    $0x8,%eax
  3f:	8b 00                	mov    (%eax),%eax
  41:	89 04 24             	mov    %eax,(%esp)
  44:	e8 3a 09 00 00       	call   983 <atoi>
  49:	89 44 24 24          	mov    %eax,0x24(%esp)

  for (i = start; i <= end; i++){
  4d:	8b 44 24 28          	mov    0x28(%esp),%eax
  51:	89 44 24 2c          	mov    %eax,0x2c(%esp)
  55:	e9 93 01 00 00       	jmp    1ed <main+0x1ed>
    printf(1,"%d. %s start\n", i, testname[i]);
  5a:	8b 44 24 2c          	mov    0x2c(%esp),%eax
  5e:	8b 04 85 08 14 00 00 	mov    0x1408(,%eax,4),%eax
  65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  69:	8b 44 24 2c          	mov    0x2c(%esp),%eax
  6d:	89 44 24 08          	mov    %eax,0x8(%esp)
  71:	c7 44 24 04 dd 0f 00 	movl   $0xfdd,0x4(%esp)
  78:	00 
  79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80:	e8 58 0b 00 00       	call   bdd <printf>
    if (pipe(gpipe) < 0){
  85:	c7 04 24 40 14 00 00 	movl   $0x1440,(%esp)
  8c:	e8 94 09 00 00       	call   a25 <pipe>
  91:	85 c0                	test   %eax,%eax
  93:	79 19                	jns    ae <main+0xae>
      printf(1,"pipe panic\n");
  95:	c7 44 24 04 eb 0f 00 	movl   $0xfeb,0x4(%esp)
  9c:	00 
  9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a4:	e8 34 0b 00 00       	call   bdd <printf>
      exit();
  a9:	e8 67 09 00 00       	call   a15 <exit>
    }
    ret = 0;
  ae:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  b5:	00 

    if ((pid = fork()) < 0){
  b6:	e8 52 09 00 00       	call   a0d <fork>
  bb:	89 44 24 20          	mov    %eax,0x20(%esp)
  bf:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
  c4:	79 19                	jns    df <main+0xdf>
      printf(1,"fork panic\n");
  c6:	c7 44 24 04 f7 0f 00 	movl   $0xff7,0x4(%esp)
  cd:	00 
  ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d5:	e8 03 0b 00 00       	call   bdd <printf>
      exit();
  da:	e8 36 09 00 00       	call   a15 <exit>
    }
    if (pid == 0){
  df:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
  e4:	75 4d                	jne    133 <main+0x133>
      close(gpipe[0]);
  e6:	a1 40 14 00 00       	mov    0x1440,%eax
  eb:	89 04 24             	mov    %eax,(%esp)
  ee:	e8 4a 09 00 00       	call   a3d <close>
      ret = testfunc[i]();
  f3:	8b 44 24 2c          	mov    0x2c(%esp),%eax
  f7:	8b 04 85 f4 13 00 00 	mov    0x13f4(,%eax,4),%eax
  fe:	ff d0                	call   *%eax
 100:	89 44 24 1c          	mov    %eax,0x1c(%esp)
      write(gpipe[1], (char*)&ret, sizeof(ret));
 104:	a1 44 14 00 00       	mov    0x1444,%eax
 109:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 110:	00 
 111:	8d 54 24 1c          	lea    0x1c(%esp),%edx
 115:	89 54 24 04          	mov    %edx,0x4(%esp)
 119:	89 04 24             	mov    %eax,(%esp)
 11c:	e8 14 09 00 00       	call   a35 <write>
      close(gpipe[1]);
 121:	a1 44 14 00 00       	mov    0x1444,%eax
 126:	89 04 24             	mov    %eax,(%esp)
 129:	e8 0f 09 00 00       	call   a3d <close>
      exit();
 12e:	e8 e2 08 00 00       	call   a15 <exit>
    } else{
      close(gpipe[1]);
 133:	a1 44 14 00 00       	mov    0x1444,%eax
 138:	89 04 24             	mov    %eax,(%esp)
 13b:	e8 fd 08 00 00       	call   a3d <close>
      if (wait() == -1 || read(gpipe[0], (char*)&ret, sizeof(ret)) == -1 || ret != 0){
 140:	e8 d8 08 00 00       	call   a1d <wait>
 145:	83 f8 ff             	cmp    $0xffffffff,%eax
 148:	74 2a                	je     174 <main+0x174>
 14a:	a1 40 14 00 00       	mov    0x1440,%eax
 14f:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 156:	00 
 157:	8d 54 24 1c          	lea    0x1c(%esp),%edx
 15b:	89 54 24 04          	mov    %edx,0x4(%esp)
 15f:	89 04 24             	mov    %eax,(%esp)
 162:	e8 c6 08 00 00       	call   a2d <read>
 167:	83 f8 ff             	cmp    $0xffffffff,%eax
 16a:	74 08                	je     174 <main+0x174>
 16c:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 170:	85 c0                	test   %eax,%eax
 172:	74 30                	je     1a4 <main+0x1a4>
        printf(1,"%d. %s panic\n", i, testname[i]);
 174:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 178:	8b 04 85 08 14 00 00 	mov    0x1408(,%eax,4),%eax
 17f:	89 44 24 0c          	mov    %eax,0xc(%esp)
 183:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 187:	89 44 24 08          	mov    %eax,0x8(%esp)
 18b:	c7 44 24 04 03 10 00 	movl   $0x1003,0x4(%esp)
 192:	00 
 193:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 19a:	e8 3e 0a 00 00       	call   bdd <printf>
        exit();
 19f:	e8 71 08 00 00       	call   a15 <exit>
      }
      close(gpipe[0]);
 1a4:	a1 40 14 00 00       	mov    0x1440,%eax
 1a9:	89 04 24             	mov    %eax,(%esp)
 1ac:	e8 8c 08 00 00       	call   a3d <close>
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
 1b1:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 1b5:	8b 04 85 08 14 00 00 	mov    0x1408(,%eax,4),%eax
 1bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
 1c0:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 1c4:	89 44 24 08          	mov    %eax,0x8(%esp)
 1c8:	c7 44 24 04 11 10 00 	movl   $0x1011,0x4(%esp)
 1cf:	00 
 1d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d7:	e8 01 0a 00 00       	call   bdd <printf>
    sleep(100);
 1dc:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 1e3:	e8 bd 08 00 00       	call   aa5 <sleep>
  if (argc >= 2)
    start = atoi(argv[1]);
  if (argc >= 3)
    end = atoi(argv[2]);

  for (i = start; i <= end; i++){
 1e8:	83 44 24 2c 01       	addl   $0x1,0x2c(%esp)
 1ed:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 1f1:	3b 44 24 24          	cmp    0x24(%esp),%eax
 1f5:	0f 8e 5f fe ff ff    	jle    5a <main+0x5a>
      close(gpipe[0]);
    }
    printf(1,"%d. %s finish\n", i, testname[i]);
    sleep(100);
  }
  exit();
 1fb:	e8 15 08 00 00       	call   a15 <exit>

00000200 <nop>:
}

// ============================================================================
void nop(){ }
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	5d                   	pop    %ebp
 204:	c3                   	ret    

00000205 <racingthreadmain>:

void*
racingthreadmain(void *arg)
{
 205:	55                   	push   %ebp
 206:	89 e5                	mov    %esp,%ebp
 208:	83 ec 28             	sub    $0x28,%esp
  int tid = (int) arg;
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  //int j;
  int tmp;
  for (i = 0; i < 10000000; i++){
 211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 218:	eb 1d                	jmp    237 <racingthreadmain+0x32>
    tmp = gcnt;
 21a:	a1 3c 14 00 00       	mov    0x143c,%eax
 21f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    tmp++;
 222:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    nop();
 226:	e8 d5 ff ff ff       	call   200 <nop>
    gcnt = tmp;
 22b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 22e:	a3 3c 14 00 00       	mov    %eax,0x143c
{
  int tid = (int) arg;
  int i;
  //int j;
  int tmp;
  for (i = 0; i < 10000000; i++){
 233:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 237:	81 7d f4 7f 96 98 00 	cmpl   $0x98967f,-0xc(%ebp)
 23e:	7e da                	jle    21a <racingthreadmain+0x15>
    tmp = gcnt;
    tmp++;
    nop();
    gcnt = tmp;
  }
  thread_exit((void *)(tid+1));
 240:	8b 45 f0             	mov    -0x10(%ebp),%eax
 243:	83 c0 01             	add    $0x1,%eax
 246:	89 04 24             	mov    %eax,(%esp)
 249:	e8 97 08 00 00       	call   ae5 <thread_exit>

0000024e <racingtest>:
}

int
racingtest(void)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  gcnt = 0;
 254:	c7 05 3c 14 00 00 00 	movl   $0x0,0x143c
 25b:	00 00 00 
  
  for (i = 0; i < NUM_THREAD; i++){
 25e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 265:	eb 48                	jmp    2af <racingtest+0x61>
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
 267:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26a:	8d 55 cc             	lea    -0x34(%ebp),%edx
 26d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 270:	c1 e1 02             	shl    $0x2,%ecx
 273:	01 ca                	add    %ecx,%edx
 275:	89 44 24 08          	mov    %eax,0x8(%esp)
 279:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
 280:	00 
 281:	89 14 24             	mov    %edx,(%esp)
 284:	e8 54 08 00 00       	call   add <thread_create>
 289:	85 c0                	test   %eax,%eax
 28b:	74 1e                	je     2ab <racingtest+0x5d>
      printf(1, "panic at thread_create\n");
 28d:	c7 44 24 04 20 10 00 	movl   $0x1020,0x4(%esp)
 294:	00 
 295:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 29c:	e8 3c 09 00 00       	call   bdd <printf>
      return -1;
 2a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a6:	e9 81 00 00 00       	jmp    32c <racingtest+0xde>
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  gcnt = 0;
  
  for (i = 0; i < NUM_THREAD; i++){
 2ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 2af:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 2b3:	7e b2                	jle    267 <racingtest+0x19>
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
 2b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2bc:	eb 46                	jmp    304 <racingtest+0xb6>
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 2be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c1:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
 2c5:	8d 55 c8             	lea    -0x38(%ebp),%edx
 2c8:	89 54 24 04          	mov    %edx,0x4(%esp)
 2cc:	89 04 24             	mov    %eax,(%esp)
 2cf:	e8 19 08 00 00       	call   aed <thread_join>
 2d4:	85 c0                	test   %eax,%eax
 2d6:	75 0d                	jne    2e5 <racingtest+0x97>
 2d8:	8b 45 c8             	mov    -0x38(%ebp),%eax
 2db:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2de:	83 c2 01             	add    $0x1,%edx
 2e1:	39 d0                	cmp    %edx,%eax
 2e3:	74 1b                	je     300 <racingtest+0xb2>
      printf(1, "panic at thread_join\n");
 2e5:	c7 44 24 04 38 10 00 	movl   $0x1038,0x4(%esp)
 2ec:	00 
 2ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2f4:	e8 e4 08 00 00       	call   bdd <printf>
      return -1;
 2f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2fe:	eb 2c                	jmp    32c <racingtest+0xde>
    if (thread_create(&threads[i], racingthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
 300:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 304:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 308:	7e b4                	jle    2be <racingtest+0x70>
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"%d\n", gcnt);
 30a:	a1 3c 14 00 00       	mov    0x143c,%eax
 30f:	89 44 24 08          	mov    %eax,0x8(%esp)
 313:	c7 44 24 04 4e 10 00 	movl   $0x104e,0x4(%esp)
 31a:	00 
 31b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 322:	e8 b6 08 00 00       	call   bdd <printf>
  return 0;
 327:	b8 00 00 00 00       	mov    $0x0,%eax
}
 32c:	c9                   	leave  
 32d:	c3                   	ret    

0000032e <basicthreadmain>:

// ============================================================================
void*
basicthreadmain(void *arg)
{
 32e:	55                   	push   %ebp
 32f:	89 e5                	mov    %esp,%ebp
 331:	83 ec 28             	sub    $0x28,%esp
  int tid = (int) arg;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i;
  for (i = 0; i < 100000000; i++){
 33a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 341:	eb 45                	jmp    388 <basicthreadmain+0x5a>
    if (i % 20000000 == 0){
 343:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 346:	ba 6b ca 5f 6b       	mov    $0x6b5fca6b,%edx
 34b:	89 c8                	mov    %ecx,%eax
 34d:	f7 ea                	imul   %edx
 34f:	c1 fa 17             	sar    $0x17,%edx
 352:	89 c8                	mov    %ecx,%eax
 354:	c1 f8 1f             	sar    $0x1f,%eax
 357:	29 c2                	sub    %eax,%edx
 359:	89 d0                	mov    %edx,%eax
 35b:	69 c0 00 2d 31 01    	imul   $0x1312d00,%eax,%eax
 361:	29 c1                	sub    %eax,%ecx
 363:	89 c8                	mov    %ecx,%eax
 365:	85 c0                	test   %eax,%eax
 367:	75 1b                	jne    384 <basicthreadmain+0x56>
      printf(1, "%d", tid);
 369:	8b 45 f0             	mov    -0x10(%ebp),%eax
 36c:	89 44 24 08          	mov    %eax,0x8(%esp)
 370:	c7 44 24 04 52 10 00 	movl   $0x1052,0x4(%esp)
 377:	00 
 378:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 37f:	e8 59 08 00 00       	call   bdd <printf>
void*
basicthreadmain(void *arg)
{
  int tid = (int) arg;
  int i;
  for (i = 0; i < 100000000; i++){
 384:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 388:	81 7d f4 ff e0 f5 05 	cmpl   $0x5f5e0ff,-0xc(%ebp)
 38f:	7e b2                	jle    343 <basicthreadmain+0x15>
    if (i % 20000000 == 0){
      printf(1, "%d", tid);
    }
  }
  thread_exit((void *)(tid+1));
 391:	8b 45 f0             	mov    -0x10(%ebp),%eax
 394:	83 c0 01             	add    $0x1,%eax
 397:	89 04 24             	mov    %eax,(%esp)
 39a:	e8 46 07 00 00       	call   ae5 <thread_exit>

0000039f <basictest>:
}

int
basictest(void)
{
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
 3a2:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
 3a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3ac:	eb 45                	jmp    3f3 <basictest+0x54>
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
 3ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b1:	8d 55 cc             	lea    -0x34(%ebp),%edx
 3b4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3b7:	c1 e1 02             	shl    $0x2,%ecx
 3ba:	01 ca                	add    %ecx,%edx
 3bc:	89 44 24 08          	mov    %eax,0x8(%esp)
 3c0:	c7 44 24 04 2e 03 00 	movl   $0x32e,0x4(%esp)
 3c7:	00 
 3c8:	89 14 24             	mov    %edx,(%esp)
 3cb:	e8 0d 07 00 00       	call   add <thread_create>
 3d0:	85 c0                	test   %eax,%eax
 3d2:	74 1b                	je     3ef <basictest+0x50>
      printf(1, "panic at thread_create\n");
 3d4:	c7 44 24 04 20 10 00 	movl   $0x1020,0x4(%esp)
 3db:	00 
 3dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3e3:	e8 f5 07 00 00       	call   bdd <printf>
      return -1;
 3e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ed:	eb 78                	jmp    467 <basictest+0xc8>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 0; i < NUM_THREAD; i++){
 3ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 3f3:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 3f7:	7e b5                	jle    3ae <basictest+0xf>
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
 3f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 400:	eb 46                	jmp    448 <basictest+0xa9>
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
 402:	8b 45 f4             	mov    -0xc(%ebp),%eax
 405:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
 409:	8d 55 c8             	lea    -0x38(%ebp),%edx
 40c:	89 54 24 04          	mov    %edx,0x4(%esp)
 410:	89 04 24             	mov    %eax,(%esp)
 413:	e8 d5 06 00 00       	call   aed <thread_join>
 418:	85 c0                	test   %eax,%eax
 41a:	75 0d                	jne    429 <basictest+0x8a>
 41c:	8b 45 c8             	mov    -0x38(%ebp),%eax
 41f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 422:	83 c2 01             	add    $0x1,%edx
 425:	39 d0                	cmp    %edx,%eax
 427:	74 1b                	je     444 <basictest+0xa5>
      printf(1, "panic at thread_join\n");
 429:	c7 44 24 04 38 10 00 	movl   $0x1038,0x4(%esp)
 430:	00 
 431:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 438:	e8 a0 07 00 00       	call   bdd <printf>
      return -1;
 43d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 442:	eb 23                	jmp    467 <basictest+0xc8>
    if (thread_create(&threads[i], basicthreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  for (i = 0; i < NUM_THREAD; i++){
 444:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 448:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 44c:	7e b4                	jle    402 <basictest+0x63>
    if (thread_join(threads[i], &retval) != 0 || (int)retval != i+1){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
 44e:	c7 44 24 04 55 10 00 	movl   $0x1055,0x4(%esp)
 455:	00 
 456:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 45d:	e8 7b 07 00 00       	call   bdd <printf>
  return 0;
 462:	b8 00 00 00 00       	mov    $0x0,%eax
}
 467:	c9                   	leave  
 468:	c3                   	ret    

00000469 <jointhreadmain>:

// ============================================================================

void*
jointhreadmain(void *arg)
{
 469:	55                   	push   %ebp
 46a:	89 e5                	mov    %esp,%ebp
 46c:	83 ec 28             	sub    $0x28,%esp
  int val = (int)arg;
 46f:	8b 45 08             	mov    0x8(%ebp),%eax
 472:	89 45 f4             	mov    %eax,-0xc(%ebp)
  sleep(200);
 475:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
 47c:	e8 24 06 00 00       	call   aa5 <sleep>
  printf(1, "thread_exit...\n");
 481:	c7 44 24 04 57 10 00 	movl   $0x1057,0x4(%esp)
 488:	00 
 489:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 490:	e8 48 07 00 00       	call   bdd <printf>
  thread_exit((void *)(val*2));
 495:	8b 45 f4             	mov    -0xc(%ebp),%eax
 498:	01 c0                	add    %eax,%eax
 49a:	89 04 24             	mov    %eax,(%esp)
 49d:	e8 43 06 00 00       	call   ae5 <thread_exit>

000004a2 <jointest1>:
}

int
jointest1(void)
{
 4a2:	55                   	push   %ebp
 4a3:	89 e5                	mov    %esp,%ebp
 4a5:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
 4a8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 4af:	eb 4b                	jmp    4fc <jointest1+0x5a>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
 4b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b7:	8d 4a ff             	lea    -0x1(%edx),%ecx
 4ba:	8d 55 cc             	lea    -0x34(%ebp),%edx
 4bd:	c1 e1 02             	shl    $0x2,%ecx
 4c0:	01 ca                	add    %ecx,%edx
 4c2:	89 44 24 08          	mov    %eax,0x8(%esp)
 4c6:	c7 44 24 04 69 04 00 	movl   $0x469,0x4(%esp)
 4cd:	00 
 4ce:	89 14 24             	mov    %edx,(%esp)
 4d1:	e8 07 06 00 00       	call   add <thread_create>
 4d6:	85 c0                	test   %eax,%eax
 4d8:	74 1e                	je     4f8 <jointest1+0x56>
      printf(1, "panic at thread_create\n");
 4da:	c7 44 24 04 20 10 00 	movl   $0x1020,0x4(%esp)
 4e1:	00 
 4e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4e9:	e8 ef 06 00 00       	call   bdd <printf>
      return -1;
 4ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4f3:	e9 8e 00 00 00       	jmp    586 <jointest1+0xe4>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
 4f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 4fc:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
 500:	7e af                	jle    4b1 <jointest1+0xf>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)i) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  printf(1, "thread_join!!!\n");
 502:	c7 44 24 04 67 10 00 	movl   $0x1067,0x4(%esp)
 509:	00 
 50a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 511:	e8 c7 06 00 00       	call   bdd <printf>
  for (i = 1; i <= NUM_THREAD; i++){
 516:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 51d:	eb 48                	jmp    567 <jointest1+0xc5>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 51f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 522:	83 e8 01             	sub    $0x1,%eax
 525:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
 529:	8d 55 c8             	lea    -0x38(%ebp),%edx
 52c:	89 54 24 04          	mov    %edx,0x4(%esp)
 530:	89 04 24             	mov    %eax,(%esp)
 533:	e8 b5 05 00 00       	call   aed <thread_join>
 538:	85 c0                	test   %eax,%eax
 53a:	75 0c                	jne    548 <jointest1+0xa6>
 53c:	8b 45 c8             	mov    -0x38(%ebp),%eax
 53f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 542:	01 d2                	add    %edx,%edx
 544:	39 d0                	cmp    %edx,%eax
 546:	74 1b                	je     563 <jointest1+0xc1>
      printf(1, "panic at thread_join\n");
 548:	c7 44 24 04 38 10 00 	movl   $0x1038,0x4(%esp)
 54f:	00 
 550:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 557:	e8 81 06 00 00       	call   bdd <printf>
      return -1;
 55c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 561:	eb 23                	jmp    586 <jointest1+0xe4>
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
 563:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 567:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
 56b:	7e b2                	jle    51f <jointest1+0x7d>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
 56d:	c7 44 24 04 55 10 00 	movl   $0x1055,0x4(%esp)
 574:	00 
 575:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 57c:	e8 5c 06 00 00       	call   bdd <printf>
  return 0;
 581:	b8 00 00 00 00       	mov    $0x0,%eax
}
 586:	c9                   	leave  
 587:	c3                   	ret    

00000588 <jointest2>:

int
jointest2(void)
{
 588:	55                   	push   %ebp
 589:	89 e5                	mov    %esp,%ebp
 58b:	83 ec 48             	sub    $0x48,%esp
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
 58e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 595:	eb 4b                	jmp    5e2 <jointest2+0x5a>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
 597:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 59d:	8d 4a ff             	lea    -0x1(%edx),%ecx
 5a0:	8d 55 cc             	lea    -0x34(%ebp),%edx
 5a3:	c1 e1 02             	shl    $0x2,%ecx
 5a6:	01 ca                	add    %ecx,%edx
 5a8:	89 44 24 08          	mov    %eax,0x8(%esp)
 5ac:	c7 44 24 04 69 04 00 	movl   $0x469,0x4(%esp)
 5b3:	00 
 5b4:	89 14 24             	mov    %edx,(%esp)
 5b7:	e8 21 05 00 00       	call   add <thread_create>
 5bc:	85 c0                	test   %eax,%eax
 5be:	74 1e                	je     5de <jointest2+0x56>
      printf(1, "panic at thread_create\n");
 5c0:	c7 44 24 04 20 10 00 	movl   $0x1020,0x4(%esp)
 5c7:	00 
 5c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5cf:	e8 09 06 00 00       	call   bdd <printf>
      return -1;
 5d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5d9:	e9 9a 00 00 00       	jmp    678 <jointest2+0xf0>
{
  thread_t threads[NUM_THREAD];
  int i;
  void *retval;
  
  for (i = 1; i <= NUM_THREAD; i++){
 5de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 5e2:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
 5e6:	7e af                	jle    597 <jointest2+0xf>
    if (thread_create(&threads[i-1], jointhreadmain, (void*)(i)) != 0){
      printf(1, "panic at thread_create\n");
      return -1;
    }
  }
  sleep(500);
 5e8:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
 5ef:	e8 b1 04 00 00       	call   aa5 <sleep>
  printf(1, "thread_join!!!\n");
 5f4:	c7 44 24 04 67 10 00 	movl   $0x1067,0x4(%esp)
 5fb:	00 
 5fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 603:	e8 d5 05 00 00       	call   bdd <printf>
  for (i = 1; i <= NUM_THREAD; i++){
 608:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 60f:	eb 48                	jmp    659 <jointest2+0xd1>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
 611:	8b 45 f4             	mov    -0xc(%ebp),%eax
 614:	83 e8 01             	sub    $0x1,%eax
 617:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
 61b:	8d 55 c8             	lea    -0x38(%ebp),%edx
 61e:	89 54 24 04          	mov    %edx,0x4(%esp)
 622:	89 04 24             	mov    %eax,(%esp)
 625:	e8 c3 04 00 00       	call   aed <thread_join>
 62a:	85 c0                	test   %eax,%eax
 62c:	75 0c                	jne    63a <jointest2+0xb2>
 62e:	8b 45 c8             	mov    -0x38(%ebp),%eax
 631:	8b 55 f4             	mov    -0xc(%ebp),%edx
 634:	01 d2                	add    %edx,%edx
 636:	39 d0                	cmp    %edx,%eax
 638:	74 1b                	je     655 <jointest2+0xcd>
      printf(1, "panic at thread_join\n");
 63a:	c7 44 24 04 38 10 00 	movl   $0x1038,0x4(%esp)
 641:	00 
 642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 649:	e8 8f 05 00 00       	call   bdd <printf>
      return -1;
 64e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 653:	eb 23                	jmp    678 <jointest2+0xf0>
      return -1;
    }
  }
  sleep(500);
  printf(1, "thread_join!!!\n");
  for (i = 1; i <= NUM_THREAD; i++){
 655:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 659:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
 65d:	7e b2                	jle    611 <jointest2+0x89>
    if (thread_join(threads[i-1], &retval) != 0 || (int)retval != i * 2 ){
      printf(1, "panic at thread_join\n");
      return -1;
    }
  }
  printf(1,"\n");
 65f:	c7 44 24 04 55 10 00 	movl   $0x1055,0x4(%esp)
 666:	00 
 667:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 66e:	e8 6a 05 00 00       	call   bdd <printf>
  return 0;
 673:	b8 00 00 00 00       	mov    $0x0,%eax
}
 678:	c9                   	leave  
 679:	c3                   	ret    

0000067a <stressthreadmain>:

// ============================================================================

void*
stressthreadmain(void *arg)
{
 67a:	55                   	push   %ebp
 67b:	89 e5                	mov    %esp,%ebp
 67d:	83 ec 18             	sub    $0x18,%esp
  thread_exit(0);
 680:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 687:	e8 59 04 00 00       	call   ae5 <thread_exit>

0000068c <stresstest>:
}

int
stresstest(void)
{
 68c:	55                   	push   %ebp
 68d:	89 e5                	mov    %esp,%ebp
 68f:	83 ec 58             	sub    $0x58,%esp
  const int nstress = 35000;
 692:	c7 45 ec b8 88 00 00 	movl   $0x88b8,-0x14(%ebp)
  thread_t threads[NUM_THREAD];
  int i, n;
  void *retval;

  for (n = 1; n <= nstress; n++){
 699:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
 6a0:	e9 e1 00 00 00       	jmp    786 <stresstest+0xfa>
    if (n % 1000 == 0)
 6a5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 6a8:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 6ad:	89 c8                	mov    %ecx,%eax
 6af:	f7 ea                	imul   %edx
 6b1:	c1 fa 06             	sar    $0x6,%edx
 6b4:	89 c8                	mov    %ecx,%eax
 6b6:	c1 f8 1f             	sar    $0x1f,%eax
 6b9:	29 c2                	sub    %eax,%edx
 6bb:	89 d0                	mov    %edx,%eax
 6bd:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 6c3:	29 c1                	sub    %eax,%ecx
 6c5:	89 c8                	mov    %ecx,%eax
 6c7:	85 c0                	test   %eax,%eax
 6c9:	75 1b                	jne    6e6 <stresstest+0x5a>
      printf(1, "%d\n", n);
 6cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ce:	89 44 24 08          	mov    %eax,0x8(%esp)
 6d2:	c7 44 24 04 4e 10 00 	movl   $0x104e,0x4(%esp)
 6d9:	00 
 6da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6e1:	e8 f7 04 00 00       	call   bdd <printf>
    for (i = 0; i < NUM_THREAD; i++){
 6e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6ed:	eb 45                	jmp    734 <stresstest+0xa8>
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
 6ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f2:	8d 55 c4             	lea    -0x3c(%ebp),%edx
 6f5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6f8:	c1 e1 02             	shl    $0x2,%ecx
 6fb:	01 ca                	add    %ecx,%edx
 6fd:	89 44 24 08          	mov    %eax,0x8(%esp)
 701:	c7 44 24 04 7a 06 00 	movl   $0x67a,0x4(%esp)
 708:	00 
 709:	89 14 24             	mov    %edx,(%esp)
 70c:	e8 cc 03 00 00       	call   add <thread_create>
 711:	85 c0                	test   %eax,%eax
 713:	74 1b                	je     730 <stresstest+0xa4>
        printf(1, "panic at thread_create\n");
 715:	c7 44 24 04 20 10 00 	movl   $0x1020,0x4(%esp)
 71c:	00 
 71d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 724:	e8 b4 04 00 00       	call   bdd <printf>
        return -1;
 729:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 72e:	eb 7b                	jmp    7ab <stresstest+0x11f>
  void *retval;

  for (n = 1; n <= nstress; n++){
    if (n % 1000 == 0)
      printf(1, "%d\n", n);
    for (i = 0; i < NUM_THREAD; i++){
 730:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 734:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 738:	7e b5                	jle    6ef <stresstest+0x63>
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
 73a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 741:	eb 39                	jmp    77c <stresstest+0xf0>
      if (thread_join(threads[i], &retval) != 0){
 743:	8b 45 f4             	mov    -0xc(%ebp),%eax
 746:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
 74a:	8d 55 c0             	lea    -0x40(%ebp),%edx
 74d:	89 54 24 04          	mov    %edx,0x4(%esp)
 751:	89 04 24             	mov    %eax,(%esp)
 754:	e8 94 03 00 00       	call   aed <thread_join>
 759:	85 c0                	test   %eax,%eax
 75b:	74 1b                	je     778 <stresstest+0xec>
        printf(1, "panic at thread_join\n");
 75d:	c7 44 24 04 38 10 00 	movl   $0x1038,0x4(%esp)
 764:	00 
 765:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 76c:	e8 6c 04 00 00       	call   bdd <printf>
        return -1;
 771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 776:	eb 33                	jmp    7ab <stresstest+0x11f>
      if (thread_create(&threads[i], stressthreadmain, (void*)i) != 0){
        printf(1, "panic at thread_create\n");
        return -1;
      }
    }
    for (i = 0; i < NUM_THREAD; i++){
 778:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 77c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 780:	7e c1                	jle    743 <stresstest+0xb7>
  const int nstress = 35000;
  thread_t threads[NUM_THREAD];
  int i, n;
  void *retval;

  for (n = 1; n <= nstress; n++){
 782:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 786:	8b 45 f0             	mov    -0x10(%ebp),%eax
 789:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78c:	0f 8e 13 ff ff ff    	jle    6a5 <stresstest+0x19>
        printf(1, "panic at thread_join\n");
        return -1;
      }
    }
  }
  printf(1, "\n");
 792:	c7 44 24 04 55 10 00 	movl   $0x1055,0x4(%esp)
 799:	00 
 79a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 7a1:	e8 37 04 00 00       	call   bdd <printf>
  return 0;
 7a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 7ab:	c9                   	leave  
 7ac:	c3                   	ret    

000007ad <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	57                   	push   %edi
 7b1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 7b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 7b5:	8b 55 10             	mov    0x10(%ebp),%edx
 7b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 7bb:	89 cb                	mov    %ecx,%ebx
 7bd:	89 df                	mov    %ebx,%edi
 7bf:	89 d1                	mov    %edx,%ecx
 7c1:	fc                   	cld    
 7c2:	f3 aa                	rep stos %al,%es:(%edi)
 7c4:	89 ca                	mov    %ecx,%edx
 7c6:	89 fb                	mov    %edi,%ebx
 7c8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 7cb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 7ce:	5b                   	pop    %ebx
 7cf:	5f                   	pop    %edi
 7d0:	5d                   	pop    %ebp
 7d1:	c3                   	ret    

000007d2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 7d2:	55                   	push   %ebp
 7d3:	89 e5                	mov    %esp,%ebp
 7d5:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
 7db:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 7de:	90                   	nop
 7df:	8b 45 08             	mov    0x8(%ebp),%eax
 7e2:	8d 50 01             	lea    0x1(%eax),%edx
 7e5:	89 55 08             	mov    %edx,0x8(%ebp)
 7e8:	8b 55 0c             	mov    0xc(%ebp),%edx
 7eb:	8d 4a 01             	lea    0x1(%edx),%ecx
 7ee:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 7f1:	0f b6 12             	movzbl (%edx),%edx
 7f4:	88 10                	mov    %dl,(%eax)
 7f6:	0f b6 00             	movzbl (%eax),%eax
 7f9:	84 c0                	test   %al,%al
 7fb:	75 e2                	jne    7df <strcpy+0xd>
    ;
  return os;
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 800:	c9                   	leave  
 801:	c3                   	ret    

00000802 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 802:	55                   	push   %ebp
 803:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 805:	eb 08                	jmp    80f <strcmp+0xd>
    p++, q++;
 807:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 80b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 80f:	8b 45 08             	mov    0x8(%ebp),%eax
 812:	0f b6 00             	movzbl (%eax),%eax
 815:	84 c0                	test   %al,%al
 817:	74 10                	je     829 <strcmp+0x27>
 819:	8b 45 08             	mov    0x8(%ebp),%eax
 81c:	0f b6 10             	movzbl (%eax),%edx
 81f:	8b 45 0c             	mov    0xc(%ebp),%eax
 822:	0f b6 00             	movzbl (%eax),%eax
 825:	38 c2                	cmp    %al,%dl
 827:	74 de                	je     807 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 829:	8b 45 08             	mov    0x8(%ebp),%eax
 82c:	0f b6 00             	movzbl (%eax),%eax
 82f:	0f b6 d0             	movzbl %al,%edx
 832:	8b 45 0c             	mov    0xc(%ebp),%eax
 835:	0f b6 00             	movzbl (%eax),%eax
 838:	0f b6 c0             	movzbl %al,%eax
 83b:	29 c2                	sub    %eax,%edx
 83d:	89 d0                	mov    %edx,%eax
}
 83f:	5d                   	pop    %ebp
 840:	c3                   	ret    

00000841 <strlen>:

uint
strlen(char *s)
{
 841:	55                   	push   %ebp
 842:	89 e5                	mov    %esp,%ebp
 844:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 847:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 84e:	eb 04                	jmp    854 <strlen+0x13>
 850:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 854:	8b 55 fc             	mov    -0x4(%ebp),%edx
 857:	8b 45 08             	mov    0x8(%ebp),%eax
 85a:	01 d0                	add    %edx,%eax
 85c:	0f b6 00             	movzbl (%eax),%eax
 85f:	84 c0                	test   %al,%al
 861:	75 ed                	jne    850 <strlen+0xf>
    ;
  return n;
 863:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 866:	c9                   	leave  
 867:	c3                   	ret    

00000868 <memset>:

void*
memset(void *dst, int c, uint n)
{
 868:	55                   	push   %ebp
 869:	89 e5                	mov    %esp,%ebp
 86b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 86e:	8b 45 10             	mov    0x10(%ebp),%eax
 871:	89 44 24 08          	mov    %eax,0x8(%esp)
 875:	8b 45 0c             	mov    0xc(%ebp),%eax
 878:	89 44 24 04          	mov    %eax,0x4(%esp)
 87c:	8b 45 08             	mov    0x8(%ebp),%eax
 87f:	89 04 24             	mov    %eax,(%esp)
 882:	e8 26 ff ff ff       	call   7ad <stosb>
  return dst;
 887:	8b 45 08             	mov    0x8(%ebp),%eax
}
 88a:	c9                   	leave  
 88b:	c3                   	ret    

0000088c <strchr>:

char*
strchr(const char *s, char c)
{
 88c:	55                   	push   %ebp
 88d:	89 e5                	mov    %esp,%ebp
 88f:	83 ec 04             	sub    $0x4,%esp
 892:	8b 45 0c             	mov    0xc(%ebp),%eax
 895:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 898:	eb 14                	jmp    8ae <strchr+0x22>
    if(*s == c)
 89a:	8b 45 08             	mov    0x8(%ebp),%eax
 89d:	0f b6 00             	movzbl (%eax),%eax
 8a0:	3a 45 fc             	cmp    -0x4(%ebp),%al
 8a3:	75 05                	jne    8aa <strchr+0x1e>
      return (char*)s;
 8a5:	8b 45 08             	mov    0x8(%ebp),%eax
 8a8:	eb 13                	jmp    8bd <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 8aa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 8ae:	8b 45 08             	mov    0x8(%ebp),%eax
 8b1:	0f b6 00             	movzbl (%eax),%eax
 8b4:	84 c0                	test   %al,%al
 8b6:	75 e2                	jne    89a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 8b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 8bd:	c9                   	leave  
 8be:	c3                   	ret    

000008bf <gets>:

char*
gets(char *buf, int max)
{
 8bf:	55                   	push   %ebp
 8c0:	89 e5                	mov    %esp,%ebp
 8c2:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8cc:	eb 4c                	jmp    91a <gets+0x5b>
    cc = read(0, &c, 1);
 8ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8d5:	00 
 8d6:	8d 45 ef             	lea    -0x11(%ebp),%eax
 8d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 8dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8e4:	e8 44 01 00 00       	call   a2d <read>
 8e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 8ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8f0:	7f 02                	jg     8f4 <gets+0x35>
      break;
 8f2:	eb 31                	jmp    925 <gets+0x66>
    buf[i++] = c;
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	8d 50 01             	lea    0x1(%eax),%edx
 8fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8fd:	89 c2                	mov    %eax,%edx
 8ff:	8b 45 08             	mov    0x8(%ebp),%eax
 902:	01 c2                	add    %eax,%edx
 904:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 908:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 90a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 90e:	3c 0a                	cmp    $0xa,%al
 910:	74 13                	je     925 <gets+0x66>
 912:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 916:	3c 0d                	cmp    $0xd,%al
 918:	74 0b                	je     925 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	83 c0 01             	add    $0x1,%eax
 920:	3b 45 0c             	cmp    0xc(%ebp),%eax
 923:	7c a9                	jl     8ce <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 925:	8b 55 f4             	mov    -0xc(%ebp),%edx
 928:	8b 45 08             	mov    0x8(%ebp),%eax
 92b:	01 d0                	add    %edx,%eax
 92d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 930:	8b 45 08             	mov    0x8(%ebp),%eax
}
 933:	c9                   	leave  
 934:	c3                   	ret    

00000935 <stat>:

int
stat(char *n, struct stat *st)
{
 935:	55                   	push   %ebp
 936:	89 e5                	mov    %esp,%ebp
 938:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 93b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 942:	00 
 943:	8b 45 08             	mov    0x8(%ebp),%eax
 946:	89 04 24             	mov    %eax,(%esp)
 949:	e8 07 01 00 00       	call   a55 <open>
 94e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 955:	79 07                	jns    95e <stat+0x29>
    return -1;
 957:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 95c:	eb 23                	jmp    981 <stat+0x4c>
  r = fstat(fd, st);
 95e:	8b 45 0c             	mov    0xc(%ebp),%eax
 961:	89 44 24 04          	mov    %eax,0x4(%esp)
 965:	8b 45 f4             	mov    -0xc(%ebp),%eax
 968:	89 04 24             	mov    %eax,(%esp)
 96b:	e8 fd 00 00 00       	call   a6d <fstat>
 970:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 973:	8b 45 f4             	mov    -0xc(%ebp),%eax
 976:	89 04 24             	mov    %eax,(%esp)
 979:	e8 bf 00 00 00       	call   a3d <close>
  return r;
 97e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 981:	c9                   	leave  
 982:	c3                   	ret    

00000983 <atoi>:

int
atoi(const char *s)
{
 983:	55                   	push   %ebp
 984:	89 e5                	mov    %esp,%ebp
 986:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 989:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 990:	eb 25                	jmp    9b7 <atoi+0x34>
    n = n*10 + *s++ - '0';
 992:	8b 55 fc             	mov    -0x4(%ebp),%edx
 995:	89 d0                	mov    %edx,%eax
 997:	c1 e0 02             	shl    $0x2,%eax
 99a:	01 d0                	add    %edx,%eax
 99c:	01 c0                	add    %eax,%eax
 99e:	89 c1                	mov    %eax,%ecx
 9a0:	8b 45 08             	mov    0x8(%ebp),%eax
 9a3:	8d 50 01             	lea    0x1(%eax),%edx
 9a6:	89 55 08             	mov    %edx,0x8(%ebp)
 9a9:	0f b6 00             	movzbl (%eax),%eax
 9ac:	0f be c0             	movsbl %al,%eax
 9af:	01 c8                	add    %ecx,%eax
 9b1:	83 e8 30             	sub    $0x30,%eax
 9b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 9b7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ba:	0f b6 00             	movzbl (%eax),%eax
 9bd:	3c 2f                	cmp    $0x2f,%al
 9bf:	7e 0a                	jle    9cb <atoi+0x48>
 9c1:	8b 45 08             	mov    0x8(%ebp),%eax
 9c4:	0f b6 00             	movzbl (%eax),%eax
 9c7:	3c 39                	cmp    $0x39,%al
 9c9:	7e c7                	jle    992 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 9cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 9ce:	c9                   	leave  
 9cf:	c3                   	ret    

000009d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 9d0:	55                   	push   %ebp
 9d1:	89 e5                	mov    %esp,%ebp
 9d3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 9d6:	8b 45 08             	mov    0x8(%ebp),%eax
 9d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 9dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 9df:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 9e2:	eb 17                	jmp    9fb <memmove+0x2b>
    *dst++ = *src++;
 9e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e7:	8d 50 01             	lea    0x1(%eax),%edx
 9ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
 9ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9f0:	8d 4a 01             	lea    0x1(%edx),%ecx
 9f3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 9f6:	0f b6 12             	movzbl (%edx),%edx
 9f9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 9fb:	8b 45 10             	mov    0x10(%ebp),%eax
 9fe:	8d 50 ff             	lea    -0x1(%eax),%edx
 a01:	89 55 10             	mov    %edx,0x10(%ebp)
 a04:	85 c0                	test   %eax,%eax
 a06:	7f dc                	jg     9e4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 a08:	8b 45 08             	mov    0x8(%ebp),%eax
}
 a0b:	c9                   	leave  
 a0c:	c3                   	ret    

00000a0d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 a0d:	b8 01 00 00 00       	mov    $0x1,%eax
 a12:	cd 40                	int    $0x40
 a14:	c3                   	ret    

00000a15 <exit>:
SYSCALL(exit)
 a15:	b8 02 00 00 00       	mov    $0x2,%eax
 a1a:	cd 40                	int    $0x40
 a1c:	c3                   	ret    

00000a1d <wait>:
SYSCALL(wait)
 a1d:	b8 03 00 00 00       	mov    $0x3,%eax
 a22:	cd 40                	int    $0x40
 a24:	c3                   	ret    

00000a25 <pipe>:
SYSCALL(pipe)
 a25:	b8 04 00 00 00       	mov    $0x4,%eax
 a2a:	cd 40                	int    $0x40
 a2c:	c3                   	ret    

00000a2d <read>:
SYSCALL(read)
 a2d:	b8 05 00 00 00       	mov    $0x5,%eax
 a32:	cd 40                	int    $0x40
 a34:	c3                   	ret    

00000a35 <write>:
SYSCALL(write)
 a35:	b8 10 00 00 00       	mov    $0x10,%eax
 a3a:	cd 40                	int    $0x40
 a3c:	c3                   	ret    

00000a3d <close>:
SYSCALL(close)
 a3d:	b8 15 00 00 00       	mov    $0x15,%eax
 a42:	cd 40                	int    $0x40
 a44:	c3                   	ret    

00000a45 <kill>:
SYSCALL(kill)
 a45:	b8 06 00 00 00       	mov    $0x6,%eax
 a4a:	cd 40                	int    $0x40
 a4c:	c3                   	ret    

00000a4d <exec>:
SYSCALL(exec)
 a4d:	b8 07 00 00 00       	mov    $0x7,%eax
 a52:	cd 40                	int    $0x40
 a54:	c3                   	ret    

00000a55 <open>:
SYSCALL(open)
 a55:	b8 0f 00 00 00       	mov    $0xf,%eax
 a5a:	cd 40                	int    $0x40
 a5c:	c3                   	ret    

00000a5d <mknod>:
SYSCALL(mknod)
 a5d:	b8 11 00 00 00       	mov    $0x11,%eax
 a62:	cd 40                	int    $0x40
 a64:	c3                   	ret    

00000a65 <unlink>:
SYSCALL(unlink)
 a65:	b8 12 00 00 00       	mov    $0x12,%eax
 a6a:	cd 40                	int    $0x40
 a6c:	c3                   	ret    

00000a6d <fstat>:
SYSCALL(fstat)
 a6d:	b8 08 00 00 00       	mov    $0x8,%eax
 a72:	cd 40                	int    $0x40
 a74:	c3                   	ret    

00000a75 <link>:
SYSCALL(link)
 a75:	b8 13 00 00 00       	mov    $0x13,%eax
 a7a:	cd 40                	int    $0x40
 a7c:	c3                   	ret    

00000a7d <mkdir>:
SYSCALL(mkdir)
 a7d:	b8 14 00 00 00       	mov    $0x14,%eax
 a82:	cd 40                	int    $0x40
 a84:	c3                   	ret    

00000a85 <chdir>:
SYSCALL(chdir)
 a85:	b8 09 00 00 00       	mov    $0x9,%eax
 a8a:	cd 40                	int    $0x40
 a8c:	c3                   	ret    

00000a8d <dup>:
SYSCALL(dup)
 a8d:	b8 0a 00 00 00       	mov    $0xa,%eax
 a92:	cd 40                	int    $0x40
 a94:	c3                   	ret    

00000a95 <getpid>:
SYSCALL(getpid)
 a95:	b8 0b 00 00 00       	mov    $0xb,%eax
 a9a:	cd 40                	int    $0x40
 a9c:	c3                   	ret    

00000a9d <sbrk>:
SYSCALL(sbrk)
 a9d:	b8 0c 00 00 00       	mov    $0xc,%eax
 aa2:	cd 40                	int    $0x40
 aa4:	c3                   	ret    

00000aa5 <sleep>:
SYSCALL(sleep)
 aa5:	b8 0d 00 00 00       	mov    $0xd,%eax
 aaa:	cd 40                	int    $0x40
 aac:	c3                   	ret    

00000aad <uptime>:
SYSCALL(uptime)
 aad:	b8 0e 00 00 00       	mov    $0xe,%eax
 ab2:	cd 40                	int    $0x40
 ab4:	c3                   	ret    

00000ab5 <my_syscall>:
SYSCALL(my_syscall)
 ab5:	b8 16 00 00 00       	mov    $0x16,%eax
 aba:	cd 40                	int    $0x40
 abc:	c3                   	ret    

00000abd <getppid>:
SYSCALL(getppid)
 abd:	b8 17 00 00 00       	mov    $0x17,%eax
 ac2:	cd 40                	int    $0x40
 ac4:	c3                   	ret    

00000ac5 <yield>:
SYSCALL(yield)
 ac5:	b8 18 00 00 00       	mov    $0x18,%eax
 aca:	cd 40                	int    $0x40
 acc:	c3                   	ret    

00000acd <getlev>:
SYSCALL(getlev)
 acd:	b8 19 00 00 00       	mov    $0x19,%eax
 ad2:	cd 40                	int    $0x40
 ad4:	c3                   	ret    

00000ad5 <set_cpu_share>:
SYSCALL(set_cpu_share)
 ad5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 ada:	cd 40                	int    $0x40
 adc:	c3                   	ret    

00000add <thread_create>:
SYSCALL(thread_create)
 add:	b8 1b 00 00 00       	mov    $0x1b,%eax
 ae2:	cd 40                	int    $0x40
 ae4:	c3                   	ret    

00000ae5 <thread_exit>:
SYSCALL(thread_exit)
 ae5:	b8 1c 00 00 00       	mov    $0x1c,%eax
 aea:	cd 40                	int    $0x40
 aec:	c3                   	ret    

00000aed <thread_join>:
SYSCALL(thread_join)
 aed:	b8 1d 00 00 00       	mov    $0x1d,%eax
 af2:	cd 40                	int    $0x40
 af4:	c3                   	ret    

00000af5 <gettid>:
SYSCALL(gettid)
 af5:	b8 1e 00 00 00       	mov    $0x1e,%eax
 afa:	cd 40                	int    $0x40
 afc:	c3                   	ret    

00000afd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 afd:	55                   	push   %ebp
 afe:	89 e5                	mov    %esp,%ebp
 b00:	83 ec 18             	sub    $0x18,%esp
 b03:	8b 45 0c             	mov    0xc(%ebp),%eax
 b06:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 b09:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 b10:	00 
 b11:	8d 45 f4             	lea    -0xc(%ebp),%eax
 b14:	89 44 24 04          	mov    %eax,0x4(%esp)
 b18:	8b 45 08             	mov    0x8(%ebp),%eax
 b1b:	89 04 24             	mov    %eax,(%esp)
 b1e:	e8 12 ff ff ff       	call   a35 <write>
}
 b23:	c9                   	leave  
 b24:	c3                   	ret    

00000b25 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 b25:	55                   	push   %ebp
 b26:	89 e5                	mov    %esp,%ebp
 b28:	56                   	push   %esi
 b29:	53                   	push   %ebx
 b2a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 b2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 b34:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 b38:	74 17                	je     b51 <printint+0x2c>
 b3a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 b3e:	79 11                	jns    b51 <printint+0x2c>
    neg = 1;
 b40:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 b47:	8b 45 0c             	mov    0xc(%ebp),%eax
 b4a:	f7 d8                	neg    %eax
 b4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 b4f:	eb 06                	jmp    b57 <printint+0x32>
  } else {
    x = xx;
 b51:	8b 45 0c             	mov    0xc(%ebp),%eax
 b54:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 b57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 b5e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 b61:	8d 41 01             	lea    0x1(%ecx),%eax
 b64:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b67:	8b 5d 10             	mov    0x10(%ebp),%ebx
 b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b6d:	ba 00 00 00 00       	mov    $0x0,%edx
 b72:	f7 f3                	div    %ebx
 b74:	89 d0                	mov    %edx,%eax
 b76:	0f b6 80 1c 14 00 00 	movzbl 0x141c(%eax),%eax
 b7d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 b81:	8b 75 10             	mov    0x10(%ebp),%esi
 b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b87:	ba 00 00 00 00       	mov    $0x0,%edx
 b8c:	f7 f6                	div    %esi
 b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 b91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b95:	75 c7                	jne    b5e <printint+0x39>
  if(neg)
 b97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b9b:	74 10                	je     bad <printint+0x88>
    buf[i++] = '-';
 b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba0:	8d 50 01             	lea    0x1(%eax),%edx
 ba3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 ba6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 bab:	eb 1f                	jmp    bcc <printint+0xa7>
 bad:	eb 1d                	jmp    bcc <printint+0xa7>
    putc(fd, buf[i]);
 baf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb5:	01 d0                	add    %edx,%eax
 bb7:	0f b6 00             	movzbl (%eax),%eax
 bba:	0f be c0             	movsbl %al,%eax
 bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
 bc1:	8b 45 08             	mov    0x8(%ebp),%eax
 bc4:	89 04 24             	mov    %eax,(%esp)
 bc7:	e8 31 ff ff ff       	call   afd <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 bcc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 bd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bd4:	79 d9                	jns    baf <printint+0x8a>
    putc(fd, buf[i]);
}
 bd6:	83 c4 30             	add    $0x30,%esp
 bd9:	5b                   	pop    %ebx
 bda:	5e                   	pop    %esi
 bdb:	5d                   	pop    %ebp
 bdc:	c3                   	ret    

00000bdd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 bdd:	55                   	push   %ebp
 bde:	89 e5                	mov    %esp,%ebp
 be0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 be3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 bea:	8d 45 0c             	lea    0xc(%ebp),%eax
 bed:	83 c0 04             	add    $0x4,%eax
 bf0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 bf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 bfa:	e9 7c 01 00 00       	jmp    d7b <printf+0x19e>
    c = fmt[i] & 0xff;
 bff:	8b 55 0c             	mov    0xc(%ebp),%edx
 c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c05:	01 d0                	add    %edx,%eax
 c07:	0f b6 00             	movzbl (%eax),%eax
 c0a:	0f be c0             	movsbl %al,%eax
 c0d:	25 ff 00 00 00       	and    $0xff,%eax
 c12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 c15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 c19:	75 2c                	jne    c47 <printf+0x6a>
      if(c == '%'){
 c1b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c1f:	75 0c                	jne    c2d <printf+0x50>
        state = '%';
 c21:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 c28:	e9 4a 01 00 00       	jmp    d77 <printf+0x19a>
      } else {
        putc(fd, c);
 c2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c30:	0f be c0             	movsbl %al,%eax
 c33:	89 44 24 04          	mov    %eax,0x4(%esp)
 c37:	8b 45 08             	mov    0x8(%ebp),%eax
 c3a:	89 04 24             	mov    %eax,(%esp)
 c3d:	e8 bb fe ff ff       	call   afd <putc>
 c42:	e9 30 01 00 00       	jmp    d77 <printf+0x19a>
      }
    } else if(state == '%'){
 c47:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 c4b:	0f 85 26 01 00 00    	jne    d77 <printf+0x19a>
      if(c == 'd'){
 c51:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 c55:	75 2d                	jne    c84 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 c57:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c5a:	8b 00                	mov    (%eax),%eax
 c5c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 c63:	00 
 c64:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 c6b:	00 
 c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
 c70:	8b 45 08             	mov    0x8(%ebp),%eax
 c73:	89 04 24             	mov    %eax,(%esp)
 c76:	e8 aa fe ff ff       	call   b25 <printint>
        ap++;
 c7b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c7f:	e9 ec 00 00 00       	jmp    d70 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 c84:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 c88:	74 06                	je     c90 <printf+0xb3>
 c8a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 c8e:	75 2d                	jne    cbd <printf+0xe0>
        printint(fd, *ap, 16, 0);
 c90:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c93:	8b 00                	mov    (%eax),%eax
 c95:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 c9c:	00 
 c9d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 ca4:	00 
 ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
 ca9:	8b 45 08             	mov    0x8(%ebp),%eax
 cac:	89 04 24             	mov    %eax,(%esp)
 caf:	e8 71 fe ff ff       	call   b25 <printint>
        ap++;
 cb4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 cb8:	e9 b3 00 00 00       	jmp    d70 <printf+0x193>
      } else if(c == 's'){
 cbd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 cc1:	75 45                	jne    d08 <printf+0x12b>
        s = (char*)*ap;
 cc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 cc6:	8b 00                	mov    (%eax),%eax
 cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 ccb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 cd3:	75 09                	jne    cde <printf+0x101>
          s = "(null)";
 cd5:	c7 45 f4 77 10 00 00 	movl   $0x1077,-0xc(%ebp)
        while(*s != 0){
 cdc:	eb 1e                	jmp    cfc <printf+0x11f>
 cde:	eb 1c                	jmp    cfc <printf+0x11f>
          putc(fd, *s);
 ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ce3:	0f b6 00             	movzbl (%eax),%eax
 ce6:	0f be c0             	movsbl %al,%eax
 ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
 ced:	8b 45 08             	mov    0x8(%ebp),%eax
 cf0:	89 04 24             	mov    %eax,(%esp)
 cf3:	e8 05 fe ff ff       	call   afd <putc>
          s++;
 cf8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cff:	0f b6 00             	movzbl (%eax),%eax
 d02:	84 c0                	test   %al,%al
 d04:	75 da                	jne    ce0 <printf+0x103>
 d06:	eb 68                	jmp    d70 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 d08:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 d0c:	75 1d                	jne    d2b <printf+0x14e>
        putc(fd, *ap);
 d0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 d11:	8b 00                	mov    (%eax),%eax
 d13:	0f be c0             	movsbl %al,%eax
 d16:	89 44 24 04          	mov    %eax,0x4(%esp)
 d1a:	8b 45 08             	mov    0x8(%ebp),%eax
 d1d:	89 04 24             	mov    %eax,(%esp)
 d20:	e8 d8 fd ff ff       	call   afd <putc>
        ap++;
 d25:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 d29:	eb 45                	jmp    d70 <printf+0x193>
      } else if(c == '%'){
 d2b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 d2f:	75 17                	jne    d48 <printf+0x16b>
        putc(fd, c);
 d31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 d34:	0f be c0             	movsbl %al,%eax
 d37:	89 44 24 04          	mov    %eax,0x4(%esp)
 d3b:	8b 45 08             	mov    0x8(%ebp),%eax
 d3e:	89 04 24             	mov    %eax,(%esp)
 d41:	e8 b7 fd ff ff       	call   afd <putc>
 d46:	eb 28                	jmp    d70 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 d48:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 d4f:	00 
 d50:	8b 45 08             	mov    0x8(%ebp),%eax
 d53:	89 04 24             	mov    %eax,(%esp)
 d56:	e8 a2 fd ff ff       	call   afd <putc>
        putc(fd, c);
 d5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 d5e:	0f be c0             	movsbl %al,%eax
 d61:	89 44 24 04          	mov    %eax,0x4(%esp)
 d65:	8b 45 08             	mov    0x8(%ebp),%eax
 d68:	89 04 24             	mov    %eax,(%esp)
 d6b:	e8 8d fd ff ff       	call   afd <putc>
      }
      state = 0;
 d70:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 d77:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
 d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d81:	01 d0                	add    %edx,%eax
 d83:	0f b6 00             	movzbl (%eax),%eax
 d86:	84 c0                	test   %al,%al
 d88:	0f 85 71 fe ff ff    	jne    bff <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 d8e:	c9                   	leave  
 d8f:	c3                   	ret    

00000d90 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d90:	55                   	push   %ebp
 d91:	89 e5                	mov    %esp,%ebp
 d93:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d96:	8b 45 08             	mov    0x8(%ebp),%eax
 d99:	83 e8 08             	sub    $0x8,%eax
 d9c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d9f:	a1 38 14 00 00       	mov    0x1438,%eax
 da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 da7:	eb 24                	jmp    dcd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dac:	8b 00                	mov    (%eax),%eax
 dae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 db1:	77 12                	ja     dc5 <free+0x35>
 db3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 db6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 db9:	77 24                	ja     ddf <free+0x4f>
 dbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dbe:	8b 00                	mov    (%eax),%eax
 dc0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 dc3:	77 1a                	ja     ddf <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 dc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dc8:	8b 00                	mov    (%eax),%eax
 dca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dd0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 dd3:	76 d4                	jbe    da9 <free+0x19>
 dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dd8:	8b 00                	mov    (%eax),%eax
 dda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ddd:	76 ca                	jbe    da9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 de2:	8b 40 04             	mov    0x4(%eax),%eax
 de5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 dec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 def:	01 c2                	add    %eax,%edx
 df1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 df4:	8b 00                	mov    (%eax),%eax
 df6:	39 c2                	cmp    %eax,%edx
 df8:	75 24                	jne    e1e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 dfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dfd:	8b 50 04             	mov    0x4(%eax),%edx
 e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e03:	8b 00                	mov    (%eax),%eax
 e05:	8b 40 04             	mov    0x4(%eax),%eax
 e08:	01 c2                	add    %eax,%edx
 e0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e0d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e13:	8b 00                	mov    (%eax),%eax
 e15:	8b 10                	mov    (%eax),%edx
 e17:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e1a:	89 10                	mov    %edx,(%eax)
 e1c:	eb 0a                	jmp    e28 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 e1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e21:	8b 10                	mov    (%eax),%edx
 e23:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e26:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e2b:	8b 40 04             	mov    0x4(%eax),%eax
 e2e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e38:	01 d0                	add    %edx,%eax
 e3a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 e3d:	75 20                	jne    e5f <free+0xcf>
    p->s.size += bp->s.size;
 e3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e42:	8b 50 04             	mov    0x4(%eax),%edx
 e45:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e48:	8b 40 04             	mov    0x4(%eax),%eax
 e4b:	01 c2                	add    %eax,%edx
 e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e50:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 e53:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e56:	8b 10                	mov    (%eax),%edx
 e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e5b:	89 10                	mov    %edx,(%eax)
 e5d:	eb 08                	jmp    e67 <free+0xd7>
  } else
    p->s.ptr = bp;
 e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e62:	8b 55 f8             	mov    -0x8(%ebp),%edx
 e65:	89 10                	mov    %edx,(%eax)
  freep = p;
 e67:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e6a:	a3 38 14 00 00       	mov    %eax,0x1438
}
 e6f:	c9                   	leave  
 e70:	c3                   	ret    

00000e71 <morecore>:

static Header*
morecore(uint nu)
{
 e71:	55                   	push   %ebp
 e72:	89 e5                	mov    %esp,%ebp
 e74:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 e77:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 e7e:	77 07                	ja     e87 <morecore+0x16>
    nu = 4096;
 e80:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 e87:	8b 45 08             	mov    0x8(%ebp),%eax
 e8a:	c1 e0 03             	shl    $0x3,%eax
 e8d:	89 04 24             	mov    %eax,(%esp)
 e90:	e8 08 fc ff ff       	call   a9d <sbrk>
 e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 e98:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 e9c:	75 07                	jne    ea5 <morecore+0x34>
    return 0;
 e9e:	b8 00 00 00 00       	mov    $0x0,%eax
 ea3:	eb 22                	jmp    ec7 <morecore+0x56>
  hp = (Header*)p;
 ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 eae:	8b 55 08             	mov    0x8(%ebp),%edx
 eb1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 eb7:	83 c0 08             	add    $0x8,%eax
 eba:	89 04 24             	mov    %eax,(%esp)
 ebd:	e8 ce fe ff ff       	call   d90 <free>
  return freep;
 ec2:	a1 38 14 00 00       	mov    0x1438,%eax
}
 ec7:	c9                   	leave  
 ec8:	c3                   	ret    

00000ec9 <malloc>:

void*
malloc(uint nbytes)
{
 ec9:	55                   	push   %ebp
 eca:	89 e5                	mov    %esp,%ebp
 ecc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ecf:	8b 45 08             	mov    0x8(%ebp),%eax
 ed2:	83 c0 07             	add    $0x7,%eax
 ed5:	c1 e8 03             	shr    $0x3,%eax
 ed8:	83 c0 01             	add    $0x1,%eax
 edb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ede:	a1 38 14 00 00       	mov    0x1438,%eax
 ee3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ee6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 eea:	75 23                	jne    f0f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 eec:	c7 45 f0 30 14 00 00 	movl   $0x1430,-0x10(%ebp)
 ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ef6:	a3 38 14 00 00       	mov    %eax,0x1438
 efb:	a1 38 14 00 00       	mov    0x1438,%eax
 f00:	a3 30 14 00 00       	mov    %eax,0x1430
    base.s.size = 0;
 f05:	c7 05 34 14 00 00 00 	movl   $0x0,0x1434
 f0c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f12:	8b 00                	mov    (%eax),%eax
 f14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f1a:	8b 40 04             	mov    0x4(%eax),%eax
 f1d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 f20:	72 4d                	jb     f6f <malloc+0xa6>
      if(p->s.size == nunits)
 f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f25:	8b 40 04             	mov    0x4(%eax),%eax
 f28:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 f2b:	75 0c                	jne    f39 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f30:	8b 10                	mov    (%eax),%edx
 f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f35:	89 10                	mov    %edx,(%eax)
 f37:	eb 26                	jmp    f5f <malloc+0x96>
      else {
        p->s.size -= nunits;
 f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f3c:	8b 40 04             	mov    0x4(%eax),%eax
 f3f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 f42:	89 c2                	mov    %eax,%edx
 f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f47:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f4d:	8b 40 04             	mov    0x4(%eax),%eax
 f50:	c1 e0 03             	shl    $0x3,%eax
 f53:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f59:	8b 55 ec             	mov    -0x14(%ebp),%edx
 f5c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f62:	a3 38 14 00 00       	mov    %eax,0x1438
      return (void*)(p + 1);
 f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f6a:	83 c0 08             	add    $0x8,%eax
 f6d:	eb 38                	jmp    fa7 <malloc+0xde>
    }
    if(p == freep)
 f6f:	a1 38 14 00 00       	mov    0x1438,%eax
 f74:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 f77:	75 1b                	jne    f94 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
 f7c:	89 04 24             	mov    %eax,(%esp)
 f7f:	e8 ed fe ff ff       	call   e71 <morecore>
 f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
 f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 f8b:	75 07                	jne    f94 <malloc+0xcb>
        return 0;
 f8d:	b8 00 00 00 00       	mov    $0x0,%eax
 f92:	eb 13                	jmp    fa7 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
 f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f9d:	8b 00                	mov    (%eax),%eax
 f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 fa2:	e9 70 ff ff ff       	jmp    f17 <malloc+0x4e>
}
 fa7:	c9                   	leave  
 fa8:	c3                   	ret    

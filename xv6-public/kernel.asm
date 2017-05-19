
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 e6 10 80       	mov    $0x8010e670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 94 38 10 80       	mov    $0x80103894,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 c8 99 10 	movl   $0x801099c8,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
80100049:	e8 a1 61 00 00       	call   801061ef <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 cc 2d 11 80 7c 	movl   $0x80112d7c,0x80112dcc
80100055:	2d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 d0 2d 11 80 7c 	movl   $0x80112d7c,0x80112dd0
8010005f:	2d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 e6 10 80 	movl   $0x8010e6b4,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 d0 2d 11 80    	mov    0x80112dd0,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 7c 2d 11 80 	movl   $0x80112d7c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 cf 99 10 	movl   $0x801099cf,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 1b 60 00 00       	call   801060b2 <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 d0 2d 11 80       	mov    0x80112dd0,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 d0 2d 11 80       	mov    %eax,0x80112dd0

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 7c 2d 11 80 	cmpl   $0x80112d7c,-0xc(%ebp)
801000b8:	72 b1                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ba:	c9                   	leave  
801000bb:	c3                   	ret    

801000bc <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000bc:	55                   	push   %ebp
801000bd:	89 e5                	mov    %esp,%ebp
801000bf:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c2:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
801000c9:	e8 42 61 00 00       	call   80106210 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 d0 2d 11 80       	mov    0x80112dd0,%eax
801000d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d6:	eb 50                	jmp    80100128 <bget+0x6c>
    if(b->dev == dev && b->blockno == blockno){
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 04             	mov    0x4(%eax),%eax
801000de:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e1:	75 3c                	jne    8010011f <bget+0x63>
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 40 08             	mov    0x8(%eax),%eax
801000e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000ec:	75 31                	jne    8010011f <bget+0x63>
      b->refcnt++;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 40 4c             	mov    0x4c(%eax),%eax
801000f4:	8d 50 01             	lea    0x1(%eax),%edx
801000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fa:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
801000fd:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
80100104:	e8 6e 61 00 00       	call   80106277 <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 d5 5f 00 00       	call   801060ec <acquiresleep>
      return b;
80100117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011a:	e9 94 00 00 00       	jmp    801001b3 <bget+0xf7>
  struct buf *b;

  acquire(&bcache.lock);

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100122:	8b 40 54             	mov    0x54(%eax),%eax
80100125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100128:	81 7d f4 7c 2d 11 80 	cmpl   $0x80112d7c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 cc 2d 11 80       	mov    0x80112dcc,%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	eb 63                	jmp    8010019e <bget+0xe2>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100141:	85 c0                	test   %eax,%eax
80100143:	75 50                	jne    80100195 <bget+0xd9>
80100145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100148:	8b 00                	mov    (%eax),%eax
8010014a:	83 e0 04             	and    $0x4,%eax
8010014d:	85 c0                	test   %eax,%eax
8010014f:	75 44                	jne    80100195 <bget+0xd9>
      b->dev = dev;
80100151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100154:	8b 55 08             	mov    0x8(%ebp),%edx
80100157:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100160:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
8010017d:	e8 f5 60 00 00       	call   80106277 <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 5c 5f 00 00       	call   801060ec <acquiresleep>
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1e                	jmp    801001b3 <bget+0xf7>
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 50             	mov    0x50(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 7c 2d 11 80 	cmpl   $0x80112d7c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 d6 99 10 80 	movl   $0x801099d6,(%esp)
801001ae:	e8 af 03 00 00       	call   80100562 <panic>
}
801001b3:	c9                   	leave  
801001b4:	c3                   	ret    

801001b5 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801001be:	89 44 24 04          	mov    %eax,0x4(%esp)
801001c2:	8b 45 08             	mov    0x8(%ebp),%eax
801001c5:	89 04 24             	mov    %eax,(%esp)
801001c8:	e8 ef fe ff ff       	call   801000bc <bget>
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0b                	jne    801001e7 <bread+0x32>
    iderw(b);
801001dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001df:	89 04 24             	mov    %eax,(%esp)
801001e2:	e8 21 27 00 00       	call   80102908 <iderw>
  }
  return b;
801001e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ea:	c9                   	leave  
801001eb:	c3                   	ret    

801001ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001ec:	55                   	push   %ebp
801001ed:	89 e5                	mov    %esp,%ebp
801001ef:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
801001f2:	8b 45 08             	mov    0x8(%ebp),%eax
801001f5:	83 c0 0c             	add    $0xc,%eax
801001f8:	89 04 24             	mov    %eax,(%esp)
801001fb:	e8 8a 5f 00 00       	call   8010618a <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 e7 99 10 80 	movl   $0x801099e7,(%esp)
8010020b:	e8 52 03 00 00       	call   80100562 <panic>
  b->flags |= B_DIRTY;
80100210:	8b 45 08             	mov    0x8(%ebp),%eax
80100213:	8b 00                	mov    (%eax),%eax
80100215:	83 c8 04             	or     $0x4,%eax
80100218:	89 c2                	mov    %eax,%edx
8010021a:	8b 45 08             	mov    0x8(%ebp),%eax
8010021d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021f:	8b 45 08             	mov    0x8(%ebp),%eax
80100222:	89 04 24             	mov    %eax,(%esp)
80100225:	e8 de 26 00 00       	call   80102908 <iderw>
}
8010022a:	c9                   	leave  
8010022b:	c3                   	ret    

8010022c <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022c:	55                   	push   %ebp
8010022d:	89 e5                	mov    %esp,%ebp
8010022f:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
80100232:	8b 45 08             	mov    0x8(%ebp),%eax
80100235:	83 c0 0c             	add    $0xc,%eax
80100238:	89 04 24             	mov    %eax,(%esp)
8010023b:	e8 4a 5f 00 00       	call   8010618a <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 ee 99 10 80 	movl   $0x801099ee,(%esp)
8010024b:	e8 12 03 00 00       	call   80100562 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 ea 5e 00 00       	call   80106148 <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
80100265:	e8 a6 5f 00 00       	call   80106210 <acquire>
  b->refcnt--;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 40 4c             	mov    0x4c(%eax),%eax
80100270:	8d 50 ff             	lea    -0x1(%eax),%edx
80100273:	8b 45 08             	mov    0x8(%ebp),%eax
80100276:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010027f:	85 c0                	test   %eax,%eax
80100281:	75 47                	jne    801002ca <brelse+0x9e>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100283:	8b 45 08             	mov    0x8(%ebp),%eax
80100286:	8b 40 54             	mov    0x54(%eax),%eax
80100289:	8b 55 08             	mov    0x8(%ebp),%edx
8010028c:	8b 52 50             	mov    0x50(%edx),%edx
8010028f:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	8b 40 50             	mov    0x50(%eax),%eax
80100298:	8b 55 08             	mov    0x8(%ebp),%edx
8010029b:	8b 52 54             	mov    0x54(%edx),%edx
8010029e:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002a1:	8b 15 d0 2d 11 80    	mov    0x80112dd0,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 7c 2d 11 80 	movl   $0x80112d7c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 d0 2d 11 80       	mov    0x80112dd0,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 d0 2d 11 80       	mov    %eax,0x80112dd0
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 80 e6 10 80 	movl   $0x8010e680,(%esp)
801002d1:	e8 a1 5f 00 00       	call   80106277 <release>
}
801002d6:	c9                   	leave  
801002d7:	c3                   	ret    

801002d8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 14             	sub    $0x14,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e9:	89 c2                	mov    %eax,%edx
801002eb:	ec                   	in     (%dx),%al
801002ec:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ef:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002f3:	c9                   	leave  
801002f4:	c3                   	ret    

801002f5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f5:	55                   	push   %ebp
801002f6:	89 e5                	mov    %esp,%ebp
801002f8:	83 ec 08             	sub    $0x8,%esp
801002fb:	8b 55 08             	mov    0x8(%ebp),%edx
801002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100301:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100305:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100308:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010030c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100310:	ee                   	out    %al,(%dx)
}
80100311:	c9                   	leave  
80100312:	c3                   	ret    

80100313 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100313:	55                   	push   %ebp
80100314:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100316:	fa                   	cli    
}
80100317:	5d                   	pop    %ebp
80100318:	c3                   	ret    

80100319 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100319:	55                   	push   %ebp
8010031a:	89 e5                	mov    %esp,%ebp
8010031c:	56                   	push   %esi
8010031d:	53                   	push   %ebx
8010031e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100321:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100325:	74 1c                	je     80100343 <printint+0x2a>
80100327:	8b 45 08             	mov    0x8(%ebp),%eax
8010032a:	c1 e8 1f             	shr    $0x1f,%eax
8010032d:	0f b6 c0             	movzbl %al,%eax
80100330:	89 45 10             	mov    %eax,0x10(%ebp)
80100333:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100337:	74 0a                	je     80100343 <printint+0x2a>
    x = -xx;
80100339:	8b 45 08             	mov    0x8(%ebp),%eax
8010033c:	f7 d8                	neg    %eax
8010033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100341:	eb 06                	jmp    80100349 <printint+0x30>
  else
    x = xx;
80100343:	8b 45 08             	mov    0x8(%ebp),%eax
80100346:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100350:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100353:	8d 41 01             	lea    0x1(%ecx),%eax
80100356:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010035c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035f:	ba 00 00 00 00       	mov    $0x0,%edx
80100364:	f7 f3                	div    %ebx
80100366:	89 d0                	mov    %edx,%eax
80100368:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
8010036f:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100373:	8b 75 0c             	mov    0xc(%ebp),%esi
80100376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100379:	ba 00 00 00 00       	mov    $0x0,%edx
8010037e:	f7 f6                	div    %esi
80100380:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100387:	75 c7                	jne    80100350 <printint+0x37>

  if(sign)
80100389:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038d:	74 10                	je     8010039f <printint+0x86>
    buf[i++] = '-';
8010038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100392:	8d 50 01             	lea    0x1(%eax),%edx
80100395:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100398:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039d:	eb 18                	jmp    801003b7 <printint+0x9e>
8010039f:	eb 16                	jmp    801003b7 <printint+0x9e>
    consputc(buf[i]);
801003a1:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a7:	01 d0                	add    %edx,%eax
801003a9:	0f b6 00             	movzbl (%eax),%eax
801003ac:	0f be c0             	movsbl %al,%eax
801003af:	89 04 24             	mov    %eax,(%esp)
801003b2:	e8 dc 03 00 00       	call   80100793 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003bf:	79 e0                	jns    801003a1 <printint+0x88>
    consputc(buf[i]);
}
801003c1:	83 c4 30             	add    $0x30,%esp
801003c4:	5b                   	pop    %ebx
801003c5:	5e                   	pop    %esi
801003c6:	5d                   	pop    %ebp
801003c7:	c3                   	ret    

801003c8 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c8:	55                   	push   %ebp
801003c9:	89 e5                	mov    %esp,%ebp
801003cb:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003ce:	a1 14 d6 10 80       	mov    0x8010d614,%eax
801003d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003da:	74 0c                	je     801003e8 <cprintf+0x20>
    acquire(&cons.lock);
801003dc:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
801003e3:	e8 28 5e 00 00       	call   80106210 <acquire>

  if (fmt == 0)
801003e8:	8b 45 08             	mov    0x8(%ebp),%eax
801003eb:	85 c0                	test   %eax,%eax
801003ed:	75 0c                	jne    801003fb <cprintf+0x33>
    panic("null fmt");
801003ef:	c7 04 24 f5 99 10 80 	movl   $0x801099f5,(%esp)
801003f6:	e8 67 01 00 00       	call   80100562 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fb:	8d 45 0c             	lea    0xc(%ebp),%eax
801003fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100408:	e9 21 01 00 00       	jmp    8010052e <cprintf+0x166>
    if(c != '%'){
8010040d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100411:	74 10                	je     80100423 <cprintf+0x5b>
      consputc(c);
80100413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100416:	89 04 24             	mov    %eax,(%esp)
80100419:	e8 75 03 00 00       	call   80100793 <consputc>
      continue;
8010041e:	e9 07 01 00 00       	jmp    8010052a <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
80100423:	8b 55 08             	mov    0x8(%ebp),%edx
80100426:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010042a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042d:	01 d0                	add    %edx,%eax
8010042f:	0f b6 00             	movzbl (%eax),%eax
80100432:	0f be c0             	movsbl %al,%eax
80100435:	25 ff 00 00 00       	and    $0xff,%eax
8010043a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100441:	75 05                	jne    80100448 <cprintf+0x80>
      break;
80100443:	e9 06 01 00 00       	jmp    8010054e <cprintf+0x186>
    switch(c){
80100448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044b:	83 f8 70             	cmp    $0x70,%eax
8010044e:	74 4f                	je     8010049f <cprintf+0xd7>
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	7f 13                	jg     80100468 <cprintf+0xa0>
80100455:	83 f8 25             	cmp    $0x25,%eax
80100458:	0f 84 a6 00 00 00    	je     80100504 <cprintf+0x13c>
8010045e:	83 f8 64             	cmp    $0x64,%eax
80100461:	74 14                	je     80100477 <cprintf+0xaf>
80100463:	e9 aa 00 00 00       	jmp    80100512 <cprintf+0x14a>
80100468:	83 f8 73             	cmp    $0x73,%eax
8010046b:	74 57                	je     801004c4 <cprintf+0xfc>
8010046d:	83 f8 78             	cmp    $0x78,%eax
80100470:	74 2d                	je     8010049f <cprintf+0xd7>
80100472:	e9 9b 00 00 00       	jmp    80100512 <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 7f fe ff ff       	call   80100319 <printint>
      break;
8010049a:	e9 8b 00 00 00       	jmp    8010052a <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004a2:	8d 50 04             	lea    0x4(%eax),%edx
801004a5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a8:	8b 00                	mov    (%eax),%eax
801004aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801004b1:	00 
801004b2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801004b9:	00 
801004ba:	89 04 24             	mov    %eax,(%esp)
801004bd:	e8 57 fe ff ff       	call   80100319 <printint>
      break;
801004c2:	eb 66                	jmp    8010052a <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
801004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c7:	8d 50 04             	lea    0x4(%eax),%edx
801004ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004cd:	8b 00                	mov    (%eax),%eax
801004cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004d6:	75 09                	jne    801004e1 <cprintf+0x119>
        s = "(null)";
801004d8:	c7 45 ec fe 99 10 80 	movl   $0x801099fe,-0x14(%ebp)
      for(; *s; s++)
801004df:	eb 17                	jmp    801004f8 <cprintf+0x130>
801004e1:	eb 15                	jmp    801004f8 <cprintf+0x130>
        consputc(*s);
801004e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004e6:	0f b6 00             	movzbl (%eax),%eax
801004e9:	0f be c0             	movsbl %al,%eax
801004ec:	89 04 24             	mov    %eax,(%esp)
801004ef:	e8 9f 02 00 00       	call   80100793 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004f4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004fb:	0f b6 00             	movzbl (%eax),%eax
801004fe:	84 c0                	test   %al,%al
80100500:	75 e1                	jne    801004e3 <cprintf+0x11b>
        consputc(*s);
      break;
80100502:	eb 26                	jmp    8010052a <cprintf+0x162>
    case '%':
      consputc('%');
80100504:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
8010050b:	e8 83 02 00 00       	call   80100793 <consputc>
      break;
80100510:	eb 18                	jmp    8010052a <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100512:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
80100519:	e8 75 02 00 00       	call   80100793 <consputc>
      consputc(c);
8010051e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100521:	89 04 24             	mov    %eax,(%esp)
80100524:	e8 6a 02 00 00       	call   80100793 <consputc>
      break;
80100529:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010052a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052e:	8b 55 08             	mov    0x8(%ebp),%edx
80100531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100534:	01 d0                	add    %edx,%eax
80100536:	0f b6 00             	movzbl (%eax),%eax
80100539:	0f be c0             	movsbl %al,%eax
8010053c:	25 ff 00 00 00       	and    $0xff,%eax
80100541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100544:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100548:	0f 85 bf fe ff ff    	jne    8010040d <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
8010054e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100552:	74 0c                	je     80100560 <cprintf+0x198>
    release(&cons.lock);
80100554:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010055b:	e8 17 5d 00 00       	call   80106277 <release>
}
80100560:	c9                   	leave  
80100561:	c3                   	ret    

80100562 <panic>:

void
panic(char *s)
{
80100562:	55                   	push   %ebp
80100563:	89 e5                	mov    %esp,%ebp
80100565:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];

  cli();
80100568:	e8 a6 fd ff ff       	call   80100313 <cli>
  cons.locking = 0;
8010056d:	c7 05 14 d6 10 80 00 	movl   $0x0,0x8010d614
80100574:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100577:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010057d:	0f b6 00             	movzbl (%eax),%eax
80100580:	0f b6 c0             	movzbl %al,%eax
80100583:	89 44 24 04          	mov    %eax,0x4(%esp)
80100587:	c7 04 24 05 9a 10 80 	movl   $0x80109a05,(%esp)
8010058e:	e8 35 fe ff ff       	call   801003c8 <cprintf>
  cprintf(s);
80100593:	8b 45 08             	mov    0x8(%ebp),%eax
80100596:	89 04 24             	mov    %eax,(%esp)
80100599:	e8 2a fe ff ff       	call   801003c8 <cprintf>
  cprintf("\n");
8010059e:	c7 04 24 21 9a 10 80 	movl   $0x80109a21,(%esp)
801005a5:	e8 1e fe ff ff       	call   801003c8 <cprintf>
  getcallerpcs(&s, pcs);
801005aa:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801005b1:	8d 45 08             	lea    0x8(%ebp),%eax
801005b4:	89 04 24             	mov    %eax,(%esp)
801005b7:	e8 08 5d 00 00       	call   801062c4 <getcallerpcs>
  for(i=0; i<10; i++)
801005bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005c3:	eb 1b                	jmp    801005e0 <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005c8:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801005d0:	c7 04 24 23 9a 10 80 	movl   $0x80109a23,(%esp)
801005d7:	e8 ec fd ff ff       	call   801003c8 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005e0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005e4:	7e df                	jle    801005c5 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005e6:	c7 05 c0 d5 10 80 01 	movl   $0x1,0x8010d5c0
801005ed:	00 00 00 
  for(;;)
    ;
801005f0:	eb fe                	jmp    801005f0 <panic+0x8e>

801005f2 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005f2:	55                   	push   %ebp
801005f3:	89 e5                	mov    %esp,%ebp
801005f5:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005f8:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005ff:	00 
80100600:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100607:	e8 e9 fc ff ff       	call   801002f5 <outb>
  pos = inb(CRTPORT+1) << 8;
8010060c:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100613:	e8 c0 fc ff ff       	call   801002d8 <inb>
80100618:	0f b6 c0             	movzbl %al,%eax
8010061b:	c1 e0 08             	shl    $0x8,%eax
8010061e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100621:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100628:	00 
80100629:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100630:	e8 c0 fc ff ff       	call   801002f5 <outb>
  pos |= inb(CRTPORT+1);
80100635:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010063c:	e8 97 fc ff ff       	call   801002d8 <inb>
80100641:	0f b6 c0             	movzbl %al,%eax
80100644:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100647:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010064b:	75 30                	jne    8010067d <cgaputc+0x8b>
    pos += 80 - pos%80;
8010064d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100650:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100655:	89 c8                	mov    %ecx,%eax
80100657:	f7 ea                	imul   %edx
80100659:	c1 fa 05             	sar    $0x5,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	c1 f8 1f             	sar    $0x1f,%eax
80100661:	29 c2                	sub    %eax,%edx
80100663:	89 d0                	mov    %edx,%eax
80100665:	c1 e0 02             	shl    $0x2,%eax
80100668:	01 d0                	add    %edx,%eax
8010066a:	c1 e0 04             	shl    $0x4,%eax
8010066d:	29 c1                	sub    %eax,%ecx
8010066f:	89 ca                	mov    %ecx,%edx
80100671:	b8 50 00 00 00       	mov    $0x50,%eax
80100676:	29 d0                	sub    %edx,%eax
80100678:	01 45 f4             	add    %eax,-0xc(%ebp)
8010067b:	eb 35                	jmp    801006b2 <cgaputc+0xc0>
  else if(c == BACKSPACE){
8010067d:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100684:	75 0c                	jne    80100692 <cgaputc+0xa0>
    if(pos > 0) --pos;
80100686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010068a:	7e 26                	jle    801006b2 <cgaputc+0xc0>
8010068c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100690:	eb 20                	jmp    801006b2 <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100692:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
80100698:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010069b:	8d 50 01             	lea    0x1(%eax),%edx
8010069e:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a1:	01 c0                	add    %eax,%eax
801006a3:	8d 14 01             	lea    (%ecx,%eax,1),%edx
801006a6:	8b 45 08             	mov    0x8(%ebp),%eax
801006a9:	0f b6 c0             	movzbl %al,%eax
801006ac:	80 cc 07             	or     $0x7,%ah
801006af:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
801006b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006b6:	78 09                	js     801006c1 <cgaputc+0xcf>
801006b8:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006bf:	7e 0c                	jle    801006cd <cgaputc+0xdb>
    panic("pos under/overflow");
801006c1:	c7 04 24 27 9a 10 80 	movl   $0x80109a27,(%esp)
801006c8:	e8 95 fe ff ff       	call   80100562 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006cd:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006d4:	7e 53                	jle    80100729 <cgaputc+0x137>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006d6:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e1:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006e6:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006ed:	00 
801006ee:	89 54 24 04          	mov    %edx,0x4(%esp)
801006f2:	89 04 24             	mov    %eax,(%esp)
801006f5:	e8 4e 5e 00 00       	call   80106548 <memmove>
    pos -= 80;
801006fa:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006fe:	b8 80 07 00 00       	mov    $0x780,%eax
80100703:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100706:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100709:	a1 00 b0 10 80       	mov    0x8010b000,%eax
8010070e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100711:	01 c9                	add    %ecx,%ecx
80100713:	01 c8                	add    %ecx,%eax
80100715:	89 54 24 08          	mov    %edx,0x8(%esp)
80100719:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100720:	00 
80100721:	89 04 24             	mov    %eax,(%esp)
80100724:	e8 50 5d 00 00       	call   80106479 <memset>
  }

  outb(CRTPORT, 14);
80100729:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100730:	00 
80100731:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100738:	e8 b8 fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos>>8);
8010073d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100740:	c1 f8 08             	sar    $0x8,%eax
80100743:	0f b6 c0             	movzbl %al,%eax
80100746:	89 44 24 04          	mov    %eax,0x4(%esp)
8010074a:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100751:	e8 9f fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT, 15);
80100756:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010075d:	00 
8010075e:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100765:	e8 8b fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos);
8010076a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076d:	0f b6 c0             	movzbl %al,%eax
80100770:	89 44 24 04          	mov    %eax,0x4(%esp)
80100774:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010077b:	e8 75 fb ff ff       	call   801002f5 <outb>
  crt[pos] = ' ' | 0x0700;
80100780:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100785:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100788:	01 d2                	add    %edx,%edx
8010078a:	01 d0                	add    %edx,%eax
8010078c:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100791:	c9                   	leave  
80100792:	c3                   	ret    

80100793 <consputc>:

void
consputc(int c)
{
80100793:	55                   	push   %ebp
80100794:	89 e5                	mov    %esp,%ebp
80100796:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100799:	a1 c0 d5 10 80       	mov    0x8010d5c0,%eax
8010079e:	85 c0                	test   %eax,%eax
801007a0:	74 07                	je     801007a9 <consputc+0x16>
    cli();
801007a2:	e8 6c fb ff ff       	call   80100313 <cli>
    for(;;)
      ;
801007a7:	eb fe                	jmp    801007a7 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a9:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007b0:	75 26                	jne    801007d8 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007b9:	e8 b3 77 00 00       	call   80107f71 <uartputc>
801007be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801007c5:	e8 a7 77 00 00       	call   80107f71 <uartputc>
801007ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007d1:	e8 9b 77 00 00       	call   80107f71 <uartputc>
801007d6:	eb 0b                	jmp    801007e3 <consputc+0x50>
  } else
    uartputc(c);
801007d8:	8b 45 08             	mov    0x8(%ebp),%eax
801007db:	89 04 24             	mov    %eax,(%esp)
801007de:	e8 8e 77 00 00       	call   80107f71 <uartputc>
  cgaputc(c);
801007e3:	8b 45 08             	mov    0x8(%ebp),%eax
801007e6:	89 04 24             	mov    %eax,(%esp)
801007e9:	e8 04 fe ff ff       	call   801005f2 <cgaputc>
}
801007ee:	c9                   	leave  
801007ef:	c3                   	ret    

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007fd:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100804:	e8 07 5a 00 00       	call   80106210 <acquire>
  while((c = getc()) >= 0){
80100809:	e9 39 01 00 00       	jmp    80100947 <consoleintr+0x157>
    switch(c){
8010080e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100811:	83 f8 10             	cmp    $0x10,%eax
80100814:	74 1e                	je     80100834 <consoleintr+0x44>
80100816:	83 f8 10             	cmp    $0x10,%eax
80100819:	7f 0a                	jg     80100825 <consoleintr+0x35>
8010081b:	83 f8 08             	cmp    $0x8,%eax
8010081e:	74 66                	je     80100886 <consoleintr+0x96>
80100820:	e9 93 00 00 00       	jmp    801008b8 <consoleintr+0xc8>
80100825:	83 f8 15             	cmp    $0x15,%eax
80100828:	74 31                	je     8010085b <consoleintr+0x6b>
8010082a:	83 f8 7f             	cmp    $0x7f,%eax
8010082d:	74 57                	je     80100886 <consoleintr+0x96>
8010082f:	e9 84 00 00 00       	jmp    801008b8 <consoleintr+0xc8>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100834:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010083b:	e9 07 01 00 00       	jmp    80100947 <consoleintr+0x157>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100840:	a1 68 30 11 80       	mov    0x80113068,%eax
80100845:	83 e8 01             	sub    $0x1,%eax
80100848:	a3 68 30 11 80       	mov    %eax,0x80113068
        consputc(BACKSPACE);
8010084d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100854:	e8 3a ff ff ff       	call   80100793 <consputc>
80100859:	eb 01                	jmp    8010085c <consoleintr+0x6c>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010085b:	90                   	nop
8010085c:	8b 15 68 30 11 80    	mov    0x80113068,%edx
80100862:	a1 64 30 11 80       	mov    0x80113064,%eax
80100867:	39 c2                	cmp    %eax,%edx
80100869:	74 16                	je     80100881 <consoleintr+0x91>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010086b:	a1 68 30 11 80       	mov    0x80113068,%eax
80100870:	83 e8 01             	sub    $0x1,%eax
80100873:	83 e0 7f             	and    $0x7f,%eax
80100876:	0f b6 80 e0 2f 11 80 	movzbl -0x7feed020(%eax),%eax
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010087d:	3c 0a                	cmp    $0xa,%al
8010087f:	75 bf                	jne    80100840 <consoleintr+0x50>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100881:	e9 c1 00 00 00       	jmp    80100947 <consoleintr+0x157>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100886:	8b 15 68 30 11 80    	mov    0x80113068,%edx
8010088c:	a1 64 30 11 80       	mov    0x80113064,%eax
80100891:	39 c2                	cmp    %eax,%edx
80100893:	74 1e                	je     801008b3 <consoleintr+0xc3>
        input.e--;
80100895:	a1 68 30 11 80       	mov    0x80113068,%eax
8010089a:	83 e8 01             	sub    $0x1,%eax
8010089d:	a3 68 30 11 80       	mov    %eax,0x80113068
        consputc(BACKSPACE);
801008a2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008a9:	e8 e5 fe ff ff       	call   80100793 <consputc>
      }
      break;
801008ae:	e9 94 00 00 00       	jmp    80100947 <consoleintr+0x157>
801008b3:	e9 8f 00 00 00       	jmp    80100947 <consoleintr+0x157>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008bc:	0f 84 84 00 00 00    	je     80100946 <consoleintr+0x156>
801008c2:	8b 15 68 30 11 80    	mov    0x80113068,%edx
801008c8:	a1 60 30 11 80       	mov    0x80113060,%eax
801008cd:	29 c2                	sub    %eax,%edx
801008cf:	89 d0                	mov    %edx,%eax
801008d1:	83 f8 7f             	cmp    $0x7f,%eax
801008d4:	77 70                	ja     80100946 <consoleintr+0x156>
        c = (c == '\r') ? '\n' : c;
801008d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008da:	74 05                	je     801008e1 <consoleintr+0xf1>
801008dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008df:	eb 05                	jmp    801008e6 <consoleintr+0xf6>
801008e1:	b8 0a 00 00 00       	mov    $0xa,%eax
801008e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008e9:	a1 68 30 11 80       	mov    0x80113068,%eax
801008ee:	8d 50 01             	lea    0x1(%eax),%edx
801008f1:	89 15 68 30 11 80    	mov    %edx,0x80113068
801008f7:	83 e0 7f             	and    $0x7f,%eax
801008fa:	89 c2                	mov    %eax,%edx
801008fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008ff:	88 82 e0 2f 11 80    	mov    %al,-0x7feed020(%edx)
        consputc(c);
80100905:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100908:	89 04 24             	mov    %eax,(%esp)
8010090b:	e8 83 fe ff ff       	call   80100793 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100910:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100914:	74 18                	je     8010092e <consoleintr+0x13e>
80100916:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
8010091a:	74 12                	je     8010092e <consoleintr+0x13e>
8010091c:	a1 68 30 11 80       	mov    0x80113068,%eax
80100921:	8b 15 60 30 11 80    	mov    0x80113060,%edx
80100927:	83 ea 80             	sub    $0xffffff80,%edx
8010092a:	39 d0                	cmp    %edx,%eax
8010092c:	75 18                	jne    80100946 <consoleintr+0x156>
          input.w = input.e;
8010092e:	a1 68 30 11 80       	mov    0x80113068,%eax
80100933:	a3 64 30 11 80       	mov    %eax,0x80113064
          wakeup(&input.r);
80100938:	c7 04 24 60 30 11 80 	movl   $0x80113060,(%esp)
8010093f:	e8 d8 4d 00 00       	call   8010571c <wakeup>
        }
      }
      break;
80100944:	eb 00                	jmp    80100946 <consoleintr+0x156>
80100946:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100947:	8b 45 08             	mov    0x8(%ebp),%eax
8010094a:	ff d0                	call   *%eax
8010094c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010094f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100953:	0f 89 b5 fe ff ff    	jns    8010080e <consoleintr+0x1e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100959:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100960:	e8 12 59 00 00       	call   80106277 <release>
  if(doprocdump) {
80100965:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100969:	74 05                	je     80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
8010096b:	e8 52 4e 00 00       	call   801057c2 <procdump>
  }
}
80100970:	c9                   	leave  
80100971:	c3                   	ret    

80100972 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100972:	55                   	push   %ebp
80100973:	89 e5                	mov    %esp,%ebp
80100975:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100978:	8b 45 08             	mov    0x8(%ebp),%eax
8010097b:	89 04 24             	mov    %eax,(%esp)
8010097e:	e8 74 11 00 00       	call   80101af7 <iunlock>
  target = n;
80100983:	8b 45 10             	mov    0x10(%ebp),%eax
80100986:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100989:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100990:	e8 7b 58 00 00       	call   80106210 <acquire>
  while(n > 0){
80100995:	e9 aa 00 00 00       	jmp    80100a44 <consoleread+0xd2>
    while(input.r == input.w){
8010099a:	eb 42                	jmp    801009de <consoleread+0x6c>
      if(proc->killed){
8010099c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009a2:	8b 40 24             	mov    0x24(%eax),%eax
801009a5:	85 c0                	test   %eax,%eax
801009a7:	74 21                	je     801009ca <consoleread+0x58>
        release(&cons.lock);
801009a9:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
801009b0:	e8 c2 58 00 00       	call   80106277 <release>
        ilock(ip);
801009b5:	8b 45 08             	mov    0x8(%ebp),%eax
801009b8:	89 04 24             	mov    %eax,(%esp)
801009bb:	e8 20 10 00 00       	call   801019e0 <ilock>
        return -1;
801009c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009c5:	e9 a5 00 00 00       	jmp    80100a6f <consoleread+0xfd>
      }
      sleep(&input.r, &cons.lock);
801009ca:	c7 44 24 04 e0 d5 10 	movl   $0x8010d5e0,0x4(%esp)
801009d1:	80 
801009d2:	c7 04 24 60 30 11 80 	movl   $0x80113060,(%esp)
801009d9:	e8 62 4c 00 00       	call   80105640 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801009de:	8b 15 60 30 11 80    	mov    0x80113060,%edx
801009e4:	a1 64 30 11 80       	mov    0x80113064,%eax
801009e9:	39 c2                	cmp    %eax,%edx
801009eb:	74 af                	je     8010099c <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009ed:	a1 60 30 11 80       	mov    0x80113060,%eax
801009f2:	8d 50 01             	lea    0x1(%eax),%edx
801009f5:	89 15 60 30 11 80    	mov    %edx,0x80113060
801009fb:	83 e0 7f             	and    $0x7f,%eax
801009fe:	0f b6 80 e0 2f 11 80 	movzbl -0x7feed020(%eax),%eax
80100a05:	0f be c0             	movsbl %al,%eax
80100a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a0b:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a0f:	75 19                	jne    80100a2a <consoleread+0xb8>
      if(n < target){
80100a11:	8b 45 10             	mov    0x10(%ebp),%eax
80100a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a17:	73 0f                	jae    80100a28 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a19:	a1 60 30 11 80       	mov    0x80113060,%eax
80100a1e:	83 e8 01             	sub    $0x1,%eax
80100a21:	a3 60 30 11 80       	mov    %eax,0x80113060
      }
      break;
80100a26:	eb 26                	jmp    80100a4e <consoleread+0xdc>
80100a28:	eb 24                	jmp    80100a4e <consoleread+0xdc>
    }
    *dst++ = c;
80100a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a2d:	8d 50 01             	lea    0x1(%eax),%edx
80100a30:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a33:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a36:	88 10                	mov    %dl,(%eax)
    --n;
80100a38:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a3c:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a40:	75 02                	jne    80100a44 <consoleread+0xd2>
      break;
80100a42:	eb 0a                	jmp    80100a4e <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a44:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a48:	0f 8f 4c ff ff ff    	jg     8010099a <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100a4e:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100a55:	e8 1d 58 00 00       	call   80106277 <release>
  ilock(ip);
80100a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80100a5d:	89 04 24             	mov    %eax,(%esp)
80100a60:	e8 7b 0f 00 00       	call   801019e0 <ilock>

  return target - n;
80100a65:	8b 45 10             	mov    0x10(%ebp),%eax
80100a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a6b:	29 c2                	sub    %eax,%edx
80100a6d:	89 d0                	mov    %edx,%eax
}
80100a6f:	c9                   	leave  
80100a70:	c3                   	ret    

80100a71 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a71:	55                   	push   %ebp
80100a72:	89 e5                	mov    %esp,%ebp
80100a74:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a77:	8b 45 08             	mov    0x8(%ebp),%eax
80100a7a:	89 04 24             	mov    %eax,(%esp)
80100a7d:	e8 75 10 00 00       	call   80101af7 <iunlock>
  acquire(&cons.lock);
80100a82:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100a89:	e8 82 57 00 00       	call   80106210 <acquire>
  for(i = 0; i < n; i++)
80100a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a95:	eb 1d                	jmp    80100ab4 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a9d:	01 d0                	add    %edx,%eax
80100a9f:	0f b6 00             	movzbl (%eax),%eax
80100aa2:	0f be c0             	movsbl %al,%eax
80100aa5:	0f b6 c0             	movzbl %al,%eax
80100aa8:	89 04 24             	mov    %eax,(%esp)
80100aab:	e8 e3 fc ff ff       	call   80100793 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100ab0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ab7:	3b 45 10             	cmp    0x10(%ebp),%eax
80100aba:	7c db                	jl     80100a97 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100abc:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100ac3:	e8 af 57 00 00       	call   80106277 <release>
  ilock(ip);
80100ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80100acb:	89 04 24             	mov    %eax,(%esp)
80100ace:	e8 0d 0f 00 00       	call   801019e0 <ilock>

  return n;
80100ad3:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ad6:	c9                   	leave  
80100ad7:	c3                   	ret    

80100ad8 <consoleinit>:

void
consoleinit(void)
{
80100ad8:	55                   	push   %ebp
80100ad9:	89 e5                	mov    %esp,%ebp
80100adb:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100ade:	c7 44 24 04 3a 9a 10 	movl   $0x80109a3a,0x4(%esp)
80100ae5:	80 
80100ae6:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80100aed:	e8 fd 56 00 00       	call   801061ef <initlock>

  devsw[CONSOLE].write = consolewrite;
80100af2:	c7 05 2c 3a 11 80 71 	movl   $0x80100a71,0x80113a2c
80100af9:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100afc:	c7 05 28 3a 11 80 72 	movl   $0x80100972,0x80113a28
80100b03:	09 10 80 
  cons.locking = 1;
80100b06:	c7 05 14 d6 10 80 01 	movl   $0x1,0x8010d614
80100b0d:	00 00 00 

  picenable(IRQ_KBD);
80100b10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b17:	e8 3d 33 00 00       	call   80103e59 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100b1c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100b23:	00 
80100b24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b2b:	e8 9a 1f 00 00       	call   80102aca <ioapicenable>
}
80100b30:	c9                   	leave  
80100b31:	c3                   	ret    

80100b32 <exec>:
extern int pgdir_ref_next_idx;


int
exec(char *path, char **argv)
{
80100b32:	55                   	push   %ebp
80100b33:	89 e5                	mov    %esp,%ebp
80100b35:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b3b:	e8 67 2a 00 00       	call   801035a7 <begin_op>

  if((ip = namei(path)) == 0){
80100b40:	8b 45 08             	mov    0x8(%ebp),%eax
80100b43:	89 04 24             	mov    %eax,(%esp)
80100b46:	e8 bd 19 00 00       	call   80102508 <namei>
80100b4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b4e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b52:	75 0f                	jne    80100b63 <exec+0x31>
    end_op();
80100b54:	e8 d2 2a 00 00       	call   8010362b <end_op>
    return -1;
80100b59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b5e:	e9 87 04 00 00       	jmp    80100fea <exec+0x4b8>
  }
  ilock(ip);
80100b63:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b66:	89 04 24             	mov    %eax,(%esp)
80100b69:	e8 72 0e 00 00       	call   801019e0 <ilock>
  pgdir = 0;
80100b6e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b75:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b7c:	00 
80100b7d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b84:	00 
80100b85:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b92:	89 04 24             	mov    %eax,(%esp)
80100b95:	e8 d0 12 00 00       	call   80101e6a <readi>
80100b9a:	83 f8 34             	cmp    $0x34,%eax
80100b9d:	74 05                	je     80100ba4 <exec+0x72>
    goto bad;
80100b9f:	e9 1a 04 00 00       	jmp    80100fbe <exec+0x48c>
  if(elf.magic != ELF_MAGIC)
80100ba4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100baa:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100baf:	74 05                	je     80100bb6 <exec+0x84>
    goto bad;
80100bb1:	e9 08 04 00 00       	jmp    80100fbe <exec+0x48c>

  if((pgdir = setupkvm()) == 0)
80100bb6:	e8 e7 84 00 00       	call   801090a2 <setupkvm>
80100bbb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bbe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bc2:	75 05                	jne    80100bc9 <exec+0x97>
    goto bad;
80100bc4:	e9 f5 03 00 00       	jmp    80100fbe <exec+0x48c>

  // Load program into memory.
  sz = 0;
80100bc9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bd7:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100be0:	e9 fc 00 00 00       	jmp    80100ce1 <exec+0x1af>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100be8:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bef:	00 
80100bf0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bf4:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c01:	89 04 24             	mov    %eax,(%esp)
80100c04:	e8 61 12 00 00       	call   80101e6a <readi>
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	74 05                	je     80100c13 <exec+0xe1>
      goto bad;
80100c0e:	e9 ab 03 00 00       	jmp    80100fbe <exec+0x48c>
    if(ph.type != ELF_PROG_LOAD)
80100c13:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c19:	83 f8 01             	cmp    $0x1,%eax
80100c1c:	74 05                	je     80100c23 <exec+0xf1>
      continue;
80100c1e:	e9 b1 00 00 00       	jmp    80100cd4 <exec+0x1a2>
    if(ph.memsz < ph.filesz)
80100c23:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c29:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c2f:	39 c2                	cmp    %eax,%edx
80100c31:	73 05                	jae    80100c38 <exec+0x106>
      goto bad;
80100c33:	e9 86 03 00 00       	jmp    80100fbe <exec+0x48c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c38:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c3e:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c44:	01 c2                	add    %eax,%edx
80100c46:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c4c:	39 c2                	cmp    %eax,%edx
80100c4e:	73 05                	jae    80100c55 <exec+0x123>
      goto bad;
80100c50:	e9 69 03 00 00       	jmp    80100fbe <exec+0x48c>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c55:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c5b:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c61:	01 d0                	add    %edx,%eax
80100c63:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c67:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c71:	89 04 24             	mov    %eax,(%esp)
80100c74:	e8 f4 87 00 00       	call   8010946d <allocuvm>
80100c79:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c7c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c80:	75 05                	jne    80100c87 <exec+0x155>
      goto bad;
80100c82:	e9 37 03 00 00       	jmp    80100fbe <exec+0x48c>
    if(ph.vaddr % PGSIZE != 0)
80100c87:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c8d:	25 ff 0f 00 00       	and    $0xfff,%eax
80100c92:	85 c0                	test   %eax,%eax
80100c94:	74 05                	je     80100c9b <exec+0x169>
      goto bad;
80100c96:	e9 23 03 00 00       	jmp    80100fbe <exec+0x48c>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c9b:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100ca1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ca7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100cad:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100cb1:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100cb5:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100cb8:	89 54 24 08          	mov    %edx,0x8(%esp)
80100cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cc3:	89 04 24             	mov    %eax,(%esp)
80100cc6:	e8 bf 86 00 00       	call   8010938a <loaduvm>
80100ccb:	85 c0                	test   %eax,%eax
80100ccd:	79 05                	jns    80100cd4 <exec+0x1a2>
      goto bad;
80100ccf:	e9 ea 02 00 00       	jmp    80100fbe <exec+0x48c>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cd4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cdb:	83 c0 20             	add    $0x20,%eax
80100cde:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ce1:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100ce8:	0f b7 c0             	movzwl %ax,%eax
80100ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cee:	0f 8f f1 fe ff ff    	jg     80100be5 <exec+0xb3>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cf4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cf7:	89 04 24             	mov    %eax,(%esp)
80100cfa:	e8 d0 0e 00 00       	call   80101bcf <iunlockput>
  end_op();
80100cff:	e8 27 29 00 00       	call   8010362b <end_op>
  ip = 0;
80100d04:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0e:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d18:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d1e:	05 00 20 00 00       	add    $0x2000,%eax
80100d23:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d31:	89 04 24             	mov    %eax,(%esp)
80100d34:	e8 34 87 00 00       	call   8010946d <allocuvm>
80100d39:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d40:	75 05                	jne    80100d47 <exec+0x215>
    goto bad;
80100d42:	e9 77 02 00 00       	jmp    80100fbe <exec+0x48c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d47:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4a:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d56:	89 04 24             	mov    %eax,(%esp)
80100d59:	e8 82 89 00 00       	call   801096e0 <clearpteu>
  sp = sz;
80100d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d61:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d6b:	e9 9a 00 00 00       	jmp    80100e0a <exec+0x2d8>
    if(argc >= MAXARG)
80100d70:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d74:	76 05                	jbe    80100d7b <exec+0x249>
      goto bad;
80100d76:	e9 43 02 00 00       	jmp    80100fbe <exec+0x48c>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d85:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d88:	01 d0                	add    %edx,%eax
80100d8a:	8b 00                	mov    (%eax),%eax
80100d8c:	89 04 24             	mov    %eax,(%esp)
80100d8f:	e8 4f 59 00 00       	call   801066e3 <strlen>
80100d94:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d97:	29 c2                	sub    %eax,%edx
80100d99:	89 d0                	mov    %edx,%eax
80100d9b:	83 e8 01             	sub    $0x1,%eax
80100d9e:	83 e0 fc             	and    $0xfffffffc,%eax
80100da1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dae:	8b 45 0c             	mov    0xc(%ebp),%eax
80100db1:	01 d0                	add    %edx,%eax
80100db3:	8b 00                	mov    (%eax),%eax
80100db5:	89 04 24             	mov    %eax,(%esp)
80100db8:	e8 26 59 00 00       	call   801066e3 <strlen>
80100dbd:	83 c0 01             	add    $0x1,%eax
80100dc0:	89 c2                	mov    %eax,%edx
80100dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dcf:	01 c8                	add    %ecx,%eax
80100dd1:	8b 00                	mov    (%eax),%eax
80100dd3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100dd7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ddb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dde:	89 44 24 04          	mov    %eax,0x4(%esp)
80100de2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100de5:	89 04 24             	mov    %eax,(%esp)
80100de8:	e8 ab 8a 00 00       	call   80109898 <copyout>
80100ded:	85 c0                	test   %eax,%eax
80100def:	79 05                	jns    80100df6 <exec+0x2c4>
      goto bad;
80100df1:	e9 c8 01 00 00       	jmp    80100fbe <exec+0x48c>
    ustack[3+argc] = sp;
80100df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df9:	8d 50 03             	lea    0x3(%eax),%edx
80100dfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dff:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e06:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e14:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e17:	01 d0                	add    %edx,%eax
80100e19:	8b 00                	mov    (%eax),%eax
80100e1b:	85 c0                	test   %eax,%eax
80100e1d:	0f 85 4d ff ff ff    	jne    80100d70 <exec+0x23e>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e26:	83 c0 03             	add    $0x3,%eax
80100e29:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e30:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e34:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e3b:	ff ff ff 
  ustack[1] = argc;
80100e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e41:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	83 c0 01             	add    $0x1,%eax
80100e4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e57:	29 d0                	sub    %edx,%eax
80100e59:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e62:	83 c0 04             	add    $0x4,%eax
80100e65:	c1 e0 02             	shl    $0x2,%eax
80100e68:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6e:	83 c0 04             	add    $0x4,%eax
80100e71:	c1 e0 02             	shl    $0x2,%eax
80100e74:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e78:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e82:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e85:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e8c:	89 04 24             	mov    %eax,(%esp)
80100e8f:	e8 04 8a 00 00       	call   80109898 <copyout>
80100e94:	85 c0                	test   %eax,%eax
80100e96:	79 05                	jns    80100e9d <exec+0x36b>
    goto bad;
80100e98:	e9 21 01 00 00       	jmp    80100fbe <exec+0x48c>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80100ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ea9:	eb 17                	jmp    80100ec2 <exec+0x390>
    if(*s == '/')
80100eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eae:	0f b6 00             	movzbl (%eax),%eax
80100eb1:	3c 2f                	cmp    $0x2f,%al
80100eb3:	75 09                	jne    80100ebe <exec+0x38c>
      last = s+1;
80100eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb8:	83 c0 01             	add    $0x1,%eax
80100ebb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ebe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ec5:	0f b6 00             	movzbl (%eax),%eax
80100ec8:	84 c0                	test   %al,%al
80100eca:	75 df                	jne    80100eab <exec+0x379>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100ecc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed2:	8d 50 6c             	lea    0x6c(%eax),%edx
80100ed5:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100edc:	00 
80100edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ee4:	89 14 24             	mov    %edx,(%esp)
80100ee7:	e8 ad 57 00 00       	call   80106699 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef2:	8b 40 04             	mov    0x4(%eax),%eax
80100ef5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ef8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100efe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f01:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f0d:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f15:	8b 40 18             	mov    0x18(%eax),%eax
80100f18:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f1e:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f27:	8b 40 18             	mov    0x18(%eax),%eax
80100f2a:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f2d:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f36:	89 04 24             	mov    %eax,(%esp)
80100f39:	e8 30 82 00 00       	call   8010916e <switchuvm>

  if (proc->pgdir_ref_idx == -1) {
80100f3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f44:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80100f4a:	83 f8 ff             	cmp    $0xffffffff,%eax
80100f4d:	75 0d                	jne    80100f5c <exec+0x42a>
    // This is a case in booting
    freevm(oldpgdir);
80100f4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f52:	89 04 24             	mov    %eax,(%esp)
80100f55:	e8 ef 86 00 00       	call   80109649 <freevm>
80100f5a:	eb 4d                	jmp    80100fa9 <exec+0x477>
  } else if (pgdir_ref[proc->pgdir_ref_idx] <= 1) {
80100f5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f62:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80100f68:	0f b6 80 80 5e 11 80 	movzbl -0x7feea180(%eax),%eax
80100f6f:	3c 01                	cmp    $0x1,%al
80100f71:	7f 36                	jg     80100fa9 <exec+0x477>
    // Just only one process was using pgdir.
    // Free it.
    acquire(&thread_lock);
80100f73:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
80100f7a:	e8 91 52 00 00       	call   80106210 <acquire>
    pgdir_ref[proc->pgdir_ref_idx] = 0;
80100f7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f85:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80100f8b:	c6 80 80 5e 11 80 00 	movb   $0x0,-0x7feea180(%eax)
    release(&thread_lock);
80100f92:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
80100f99:	e8 d9 52 00 00       	call   80106277 <release>
    freevm(oldpgdir);
80100f9e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100fa1:	89 04 24             	mov    %eax,(%esp)
80100fa4:	e8 a0 86 00 00       	call   80109649 <freevm>
  } else {
    // There is a thread using a same addres space.
    // Do not free it.
  }

  allocate_new_pgdir_idx(proc);
80100fa9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100faf:	89 04 24             	mov    %eax,(%esp)
80100fb2:	e8 7d 34 00 00       	call   80104434 <allocate_new_pgdir_idx>

  return 0;
80100fb7:	b8 00 00 00 00       	mov    $0x0,%eax
80100fbc:	eb 2c                	jmp    80100fea <exec+0x4b8>

 bad:
  if(pgdir)
80100fbe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fc2:	74 0b                	je     80100fcf <exec+0x49d>
    freevm(pgdir);
80100fc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100fc7:	89 04 24             	mov    %eax,(%esp)
80100fca:	e8 7a 86 00 00       	call   80109649 <freevm>
  if(ip){
80100fcf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100fd3:	74 10                	je     80100fe5 <exec+0x4b3>
    iunlockput(ip);
80100fd5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100fd8:	89 04 24             	mov    %eax,(%esp)
80100fdb:	e8 ef 0b 00 00       	call   80101bcf <iunlockput>
    end_op();
80100fe0:	e8 46 26 00 00       	call   8010362b <end_op>
  }
  return -1;
80100fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fea:	c9                   	leave  
80100feb:	c3                   	ret    

80100fec <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fec:	55                   	push   %ebp
80100fed:	89 e5                	mov    %esp,%ebp
80100fef:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100ff2:	c7 44 24 04 42 9a 10 	movl   $0x80109a42,0x4(%esp)
80100ff9:	80 
80100ffa:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80101001:	e8 e9 51 00 00       	call   801061ef <initlock>
}
80101006:	c9                   	leave  
80101007:	c3                   	ret    

80101008 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101008:	55                   	push   %ebp
80101009:	89 e5                	mov    %esp,%ebp
8010100b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
8010100e:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80101015:	e8 f6 51 00 00       	call   80106210 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010101a:	c7 45 f4 b4 30 11 80 	movl   $0x801130b4,-0xc(%ebp)
80101021:	eb 29                	jmp    8010104c <filealloc+0x44>
    if(f->ref == 0){
80101023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101026:	8b 40 04             	mov    0x4(%eax),%eax
80101029:	85 c0                	test   %eax,%eax
8010102b:	75 1b                	jne    80101048 <filealloc+0x40>
      f->ref = 1;
8010102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101030:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101037:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
8010103e:	e8 34 52 00 00       	call   80106277 <release>
      return f;
80101043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101046:	eb 1e                	jmp    80101066 <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101048:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010104c:	81 7d f4 14 3a 11 80 	cmpl   $0x80113a14,-0xc(%ebp)
80101053:	72 ce                	jb     80101023 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101055:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
8010105c:	e8 16 52 00 00       	call   80106277 <release>
  return 0;
80101061:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101066:	c9                   	leave  
80101067:	c3                   	ret    

80101068 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101068:	55                   	push   %ebp
80101069:	89 e5                	mov    %esp,%ebp
8010106b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
8010106e:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80101075:	e8 96 51 00 00       	call   80106210 <acquire>
  if(f->ref < 1)
8010107a:	8b 45 08             	mov    0x8(%ebp),%eax
8010107d:	8b 40 04             	mov    0x4(%eax),%eax
80101080:	85 c0                	test   %eax,%eax
80101082:	7f 0c                	jg     80101090 <filedup+0x28>
    panic("filedup");
80101084:	c7 04 24 49 9a 10 80 	movl   $0x80109a49,(%esp)
8010108b:	e8 d2 f4 ff ff       	call   80100562 <panic>
  f->ref++;
80101090:	8b 45 08             	mov    0x8(%ebp),%eax
80101093:	8b 40 04             	mov    0x4(%eax),%eax
80101096:	8d 50 01             	lea    0x1(%eax),%edx
80101099:	8b 45 08             	mov    0x8(%ebp),%eax
8010109c:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010109f:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
801010a6:	e8 cc 51 00 00       	call   80106277 <release>
  return f;
801010ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010ae:	c9                   	leave  
801010af:	c3                   	ret    

801010b0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
801010b6:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
801010bd:	e8 4e 51 00 00       	call   80106210 <acquire>
  if(f->ref < 1)
801010c2:	8b 45 08             	mov    0x8(%ebp),%eax
801010c5:	8b 40 04             	mov    0x4(%eax),%eax
801010c8:	85 c0                	test   %eax,%eax
801010ca:	7f 0c                	jg     801010d8 <fileclose+0x28>
    panic("fileclose");
801010cc:	c7 04 24 51 9a 10 80 	movl   $0x80109a51,(%esp)
801010d3:	e8 8a f4 ff ff       	call   80100562 <panic>
  if(--f->ref > 0){
801010d8:	8b 45 08             	mov    0x8(%ebp),%eax
801010db:	8b 40 04             	mov    0x4(%eax),%eax
801010de:	8d 50 ff             	lea    -0x1(%eax),%edx
801010e1:	8b 45 08             	mov    0x8(%ebp),%eax
801010e4:	89 50 04             	mov    %edx,0x4(%eax)
801010e7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ea:	8b 40 04             	mov    0x4(%eax),%eax
801010ed:	85 c0                	test   %eax,%eax
801010ef:	7e 11                	jle    80101102 <fileclose+0x52>
    release(&ftable.lock);
801010f1:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
801010f8:	e8 7a 51 00 00       	call   80106277 <release>
801010fd:	e9 82 00 00 00       	jmp    80101184 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101102:	8b 45 08             	mov    0x8(%ebp),%eax
80101105:	8b 10                	mov    (%eax),%edx
80101107:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010110a:	8b 50 04             	mov    0x4(%eax),%edx
8010110d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101110:	8b 50 08             	mov    0x8(%eax),%edx
80101113:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101116:	8b 50 0c             	mov    0xc(%eax),%edx
80101119:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010111c:	8b 50 10             	mov    0x10(%eax),%edx
8010111f:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101122:	8b 40 14             	mov    0x14(%eax),%eax
80101125:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101128:	8b 45 08             	mov    0x8(%ebp),%eax
8010112b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101132:	8b 45 08             	mov    0x8(%ebp),%eax
80101135:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010113b:	c7 04 24 80 30 11 80 	movl   $0x80113080,(%esp)
80101142:	e8 30 51 00 00       	call   80106277 <release>

  if(ff.type == FD_PIPE)
80101147:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010114a:	83 f8 01             	cmp    $0x1,%eax
8010114d:	75 18                	jne    80101167 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
8010114f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101153:	0f be d0             	movsbl %al,%edx
80101156:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101159:	89 54 24 04          	mov    %edx,0x4(%esp)
8010115d:	89 04 24             	mov    %eax,(%esp)
80101160:	e8 a4 2f 00 00       	call   80104109 <pipeclose>
80101165:	eb 1d                	jmp    80101184 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
80101167:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010116a:	83 f8 02             	cmp    $0x2,%eax
8010116d:	75 15                	jne    80101184 <fileclose+0xd4>
    begin_op();
8010116f:	e8 33 24 00 00       	call   801035a7 <begin_op>
    iput(ff.ip);
80101174:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101177:	89 04 24             	mov    %eax,(%esp)
8010117a:	e8 bc 09 00 00       	call   80101b3b <iput>
    end_op();
8010117f:	e8 a7 24 00 00       	call   8010362b <end_op>
  }
}
80101184:	c9                   	leave  
80101185:	c3                   	ret    

80101186 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101186:	55                   	push   %ebp
80101187:	89 e5                	mov    %esp,%ebp
80101189:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
8010118c:	8b 45 08             	mov    0x8(%ebp),%eax
8010118f:	8b 00                	mov    (%eax),%eax
80101191:	83 f8 02             	cmp    $0x2,%eax
80101194:	75 38                	jne    801011ce <filestat+0x48>
    ilock(f->ip);
80101196:	8b 45 08             	mov    0x8(%ebp),%eax
80101199:	8b 40 10             	mov    0x10(%eax),%eax
8010119c:	89 04 24             	mov    %eax,(%esp)
8010119f:	e8 3c 08 00 00       	call   801019e0 <ilock>
    stati(f->ip, st);
801011a4:	8b 45 08             	mov    0x8(%ebp),%eax
801011a7:	8b 40 10             	mov    0x10(%eax),%eax
801011aa:	8b 55 0c             	mov    0xc(%ebp),%edx
801011ad:	89 54 24 04          	mov    %edx,0x4(%esp)
801011b1:	89 04 24             	mov    %eax,(%esp)
801011b4:	e8 6c 0c 00 00       	call   80101e25 <stati>
    iunlock(f->ip);
801011b9:	8b 45 08             	mov    0x8(%ebp),%eax
801011bc:	8b 40 10             	mov    0x10(%eax),%eax
801011bf:	89 04 24             	mov    %eax,(%esp)
801011c2:	e8 30 09 00 00       	call   80101af7 <iunlock>
    return 0;
801011c7:	b8 00 00 00 00       	mov    $0x0,%eax
801011cc:	eb 05                	jmp    801011d3 <filestat+0x4d>
  }
  return -1;
801011ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011d3:	c9                   	leave  
801011d4:	c3                   	ret    

801011d5 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011d5:	55                   	push   %ebp
801011d6:	89 e5                	mov    %esp,%ebp
801011d8:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801011db:	8b 45 08             	mov    0x8(%ebp),%eax
801011de:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011e2:	84 c0                	test   %al,%al
801011e4:	75 0a                	jne    801011f0 <fileread+0x1b>
    return -1;
801011e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011eb:	e9 9f 00 00 00       	jmp    8010128f <fileread+0xba>
  if(f->type == FD_PIPE)
801011f0:	8b 45 08             	mov    0x8(%ebp),%eax
801011f3:	8b 00                	mov    (%eax),%eax
801011f5:	83 f8 01             	cmp    $0x1,%eax
801011f8:	75 1e                	jne    80101218 <fileread+0x43>
    return piperead(f->pipe, addr, n);
801011fa:	8b 45 08             	mov    0x8(%ebp),%eax
801011fd:	8b 40 0c             	mov    0xc(%eax),%eax
80101200:	8b 55 10             	mov    0x10(%ebp),%edx
80101203:	89 54 24 08          	mov    %edx,0x8(%esp)
80101207:	8b 55 0c             	mov    0xc(%ebp),%edx
8010120a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010120e:	89 04 24             	mov    %eax,(%esp)
80101211:	e8 74 30 00 00       	call   8010428a <piperead>
80101216:	eb 77                	jmp    8010128f <fileread+0xba>
  if(f->type == FD_INODE){
80101218:	8b 45 08             	mov    0x8(%ebp),%eax
8010121b:	8b 00                	mov    (%eax),%eax
8010121d:	83 f8 02             	cmp    $0x2,%eax
80101220:	75 61                	jne    80101283 <fileread+0xae>
    ilock(f->ip);
80101222:	8b 45 08             	mov    0x8(%ebp),%eax
80101225:	8b 40 10             	mov    0x10(%eax),%eax
80101228:	89 04 24             	mov    %eax,(%esp)
8010122b:	e8 b0 07 00 00       	call   801019e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101230:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101233:	8b 45 08             	mov    0x8(%ebp),%eax
80101236:	8b 50 14             	mov    0x14(%eax),%edx
80101239:	8b 45 08             	mov    0x8(%ebp),%eax
8010123c:	8b 40 10             	mov    0x10(%eax),%eax
8010123f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101243:	89 54 24 08          	mov    %edx,0x8(%esp)
80101247:	8b 55 0c             	mov    0xc(%ebp),%edx
8010124a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010124e:	89 04 24             	mov    %eax,(%esp)
80101251:	e8 14 0c 00 00       	call   80101e6a <readi>
80101256:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010125d:	7e 11                	jle    80101270 <fileread+0x9b>
      f->off += r;
8010125f:	8b 45 08             	mov    0x8(%ebp),%eax
80101262:	8b 50 14             	mov    0x14(%eax),%edx
80101265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101268:	01 c2                	add    %eax,%edx
8010126a:	8b 45 08             	mov    0x8(%ebp),%eax
8010126d:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101270:	8b 45 08             	mov    0x8(%ebp),%eax
80101273:	8b 40 10             	mov    0x10(%eax),%eax
80101276:	89 04 24             	mov    %eax,(%esp)
80101279:	e8 79 08 00 00       	call   80101af7 <iunlock>
    return r;
8010127e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101281:	eb 0c                	jmp    8010128f <fileread+0xba>
  }
  panic("fileread");
80101283:	c7 04 24 5b 9a 10 80 	movl   $0x80109a5b,(%esp)
8010128a:	e8 d3 f2 ff ff       	call   80100562 <panic>
}
8010128f:	c9                   	leave  
80101290:	c3                   	ret    

80101291 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101291:	55                   	push   %ebp
80101292:	89 e5                	mov    %esp,%ebp
80101294:	53                   	push   %ebx
80101295:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
80101298:	8b 45 08             	mov    0x8(%ebp),%eax
8010129b:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010129f:	84 c0                	test   %al,%al
801012a1:	75 0a                	jne    801012ad <filewrite+0x1c>
    return -1;
801012a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012a8:	e9 20 01 00 00       	jmp    801013cd <filewrite+0x13c>
  if(f->type == FD_PIPE)
801012ad:	8b 45 08             	mov    0x8(%ebp),%eax
801012b0:	8b 00                	mov    (%eax),%eax
801012b2:	83 f8 01             	cmp    $0x1,%eax
801012b5:	75 21                	jne    801012d8 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801012b7:	8b 45 08             	mov    0x8(%ebp),%eax
801012ba:	8b 40 0c             	mov    0xc(%eax),%eax
801012bd:	8b 55 10             	mov    0x10(%ebp),%edx
801012c0:	89 54 24 08          	mov    %edx,0x8(%esp)
801012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
801012c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801012cb:	89 04 24             	mov    %eax,(%esp)
801012ce:	e8 c8 2e 00 00       	call   8010419b <pipewrite>
801012d3:	e9 f5 00 00 00       	jmp    801013cd <filewrite+0x13c>
  if(f->type == FD_INODE){
801012d8:	8b 45 08             	mov    0x8(%ebp),%eax
801012db:	8b 00                	mov    (%eax),%eax
801012dd:	83 f8 02             	cmp    $0x2,%eax
801012e0:	0f 85 db 00 00 00    	jne    801013c1 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801012e6:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012f4:	e9 a8 00 00 00       	jmp    801013a1 <filewrite+0x110>
      int n1 = n - i;
801012f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012fc:	8b 55 10             	mov    0x10(%ebp),%edx
801012ff:	29 c2                	sub    %eax,%edx
80101301:	89 d0                	mov    %edx,%eax
80101303:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101306:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101309:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010130c:	7e 06                	jle    80101314 <filewrite+0x83>
        n1 = max;
8010130e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101311:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101314:	e8 8e 22 00 00       	call   801035a7 <begin_op>
      ilock(f->ip);
80101319:	8b 45 08             	mov    0x8(%ebp),%eax
8010131c:	8b 40 10             	mov    0x10(%eax),%eax
8010131f:	89 04 24             	mov    %eax,(%esp)
80101322:	e8 b9 06 00 00       	call   801019e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101327:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010132a:	8b 45 08             	mov    0x8(%ebp),%eax
8010132d:	8b 50 14             	mov    0x14(%eax),%edx
80101330:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101333:	8b 45 0c             	mov    0xc(%ebp),%eax
80101336:	01 c3                	add    %eax,%ebx
80101338:	8b 45 08             	mov    0x8(%ebp),%eax
8010133b:	8b 40 10             	mov    0x10(%eax),%eax
8010133e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101342:	89 54 24 08          	mov    %edx,0x8(%esp)
80101346:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010134a:	89 04 24             	mov    %eax,(%esp)
8010134d:	e8 7c 0c 00 00       	call   80101fce <writei>
80101352:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101355:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101359:	7e 11                	jle    8010136c <filewrite+0xdb>
        f->off += r;
8010135b:	8b 45 08             	mov    0x8(%ebp),%eax
8010135e:	8b 50 14             	mov    0x14(%eax),%edx
80101361:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101364:	01 c2                	add    %eax,%edx
80101366:	8b 45 08             	mov    0x8(%ebp),%eax
80101369:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010136c:	8b 45 08             	mov    0x8(%ebp),%eax
8010136f:	8b 40 10             	mov    0x10(%eax),%eax
80101372:	89 04 24             	mov    %eax,(%esp)
80101375:	e8 7d 07 00 00       	call   80101af7 <iunlock>
      end_op();
8010137a:	e8 ac 22 00 00       	call   8010362b <end_op>

      if(r < 0)
8010137f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101383:	79 02                	jns    80101387 <filewrite+0xf6>
        break;
80101385:	eb 26                	jmp    801013ad <filewrite+0x11c>
      if(r != n1)
80101387:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010138a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010138d:	74 0c                	je     8010139b <filewrite+0x10a>
        panic("short filewrite");
8010138f:	c7 04 24 64 9a 10 80 	movl   $0x80109a64,(%esp)
80101396:	e8 c7 f1 ff ff       	call   80100562 <panic>
      i += r;
8010139b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010139e:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a4:	3b 45 10             	cmp    0x10(%ebp),%eax
801013a7:	0f 8c 4c ff ff ff    	jl     801012f9 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801013ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b0:	3b 45 10             	cmp    0x10(%ebp),%eax
801013b3:	75 05                	jne    801013ba <filewrite+0x129>
801013b5:	8b 45 10             	mov    0x10(%ebp),%eax
801013b8:	eb 05                	jmp    801013bf <filewrite+0x12e>
801013ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013bf:	eb 0c                	jmp    801013cd <filewrite+0x13c>
  }
  panic("filewrite");
801013c1:	c7 04 24 74 9a 10 80 	movl   $0x80109a74,(%esp)
801013c8:	e8 95 f1 ff ff       	call   80100562 <panic>
}
801013cd:	83 c4 24             	add    $0x24,%esp
801013d0:	5b                   	pop    %ebx
801013d1:	5d                   	pop    %ebp
801013d2:	c3                   	ret    

801013d3 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013d3:	55                   	push   %ebp
801013d4:	89 e5                	mov    %esp,%ebp
801013d6:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013d9:	8b 45 08             	mov    0x8(%ebp),%eax
801013dc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013e3:	00 
801013e4:	89 04 24             	mov    %eax,(%esp)
801013e7:	e8 c9 ed ff ff       	call   801001b5 <bread>
801013ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f2:	83 c0 5c             	add    $0x5c,%eax
801013f5:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013fc:	00 
801013fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80101401:	8b 45 0c             	mov    0xc(%ebp),%eax
80101404:	89 04 24             	mov    %eax,(%esp)
80101407:	e8 3c 51 00 00       	call   80106548 <memmove>
  brelse(bp);
8010140c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010140f:	89 04 24             	mov    %eax,(%esp)
80101412:	e8 15 ee ff ff       	call   8010022c <brelse>
}
80101417:	c9                   	leave  
80101418:	c3                   	ret    

80101419 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101419:	55                   	push   %ebp
8010141a:	89 e5                	mov    %esp,%ebp
8010141c:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
8010141f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101422:	8b 45 08             	mov    0x8(%ebp),%eax
80101425:	89 54 24 04          	mov    %edx,0x4(%esp)
80101429:	89 04 24             	mov    %eax,(%esp)
8010142c:	e8 84 ed ff ff       	call   801001b5 <bread>
80101431:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101434:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101437:	83 c0 5c             	add    $0x5c,%eax
8010143a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101441:	00 
80101442:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101449:	00 
8010144a:	89 04 24             	mov    %eax,(%esp)
8010144d:	e8 27 50 00 00       	call   80106479 <memset>
  log_write(bp);
80101452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101455:	89 04 24             	mov    %eax,(%esp)
80101458:	e8 55 23 00 00       	call   801037b2 <log_write>
  brelse(bp);
8010145d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101460:	89 04 24             	mov    %eax,(%esp)
80101463:	e8 c4 ed ff ff       	call   8010022c <brelse>
}
80101468:	c9                   	leave  
80101469:	c3                   	ret    

8010146a <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010146a:	55                   	push   %ebp
8010146b:	89 e5                	mov    %esp,%ebp
8010146d:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101470:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101477:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010147e:	e9 07 01 00 00       	jmp    8010158a <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
80101483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101486:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010148c:	85 c0                	test   %eax,%eax
8010148e:	0f 48 c2             	cmovs  %edx,%eax
80101491:	c1 f8 0c             	sar    $0xc,%eax
80101494:	89 c2                	mov    %eax,%edx
80101496:	a1 98 3a 11 80       	mov    0x80113a98,%eax
8010149b:	01 d0                	add    %edx,%eax
8010149d:	89 44 24 04          	mov    %eax,0x4(%esp)
801014a1:	8b 45 08             	mov    0x8(%ebp),%eax
801014a4:	89 04 24             	mov    %eax,(%esp)
801014a7:	e8 09 ed ff ff       	call   801001b5 <bread>
801014ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801014b6:	e9 9d 00 00 00       	jmp    80101558 <balloc+0xee>
      m = 1 << (bi % 8);
801014bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014be:	99                   	cltd   
801014bf:	c1 ea 1d             	shr    $0x1d,%edx
801014c2:	01 d0                	add    %edx,%eax
801014c4:	83 e0 07             	and    $0x7,%eax
801014c7:	29 d0                	sub    %edx,%eax
801014c9:	ba 01 00 00 00       	mov    $0x1,%edx
801014ce:	89 c1                	mov    %eax,%ecx
801014d0:	d3 e2                	shl    %cl,%edx
801014d2:	89 d0                	mov    %edx,%eax
801014d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014da:	8d 50 07             	lea    0x7(%eax),%edx
801014dd:	85 c0                	test   %eax,%eax
801014df:	0f 48 c2             	cmovs  %edx,%eax
801014e2:	c1 f8 03             	sar    $0x3,%eax
801014e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014e8:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
801014ed:	0f b6 c0             	movzbl %al,%eax
801014f0:	23 45 e8             	and    -0x18(%ebp),%eax
801014f3:	85 c0                	test   %eax,%eax
801014f5:	75 5d                	jne    80101554 <balloc+0xea>
        bp->data[bi/8] |= m;  // Mark block in use.
801014f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014fa:	8d 50 07             	lea    0x7(%eax),%edx
801014fd:	85 c0                	test   %eax,%eax
801014ff:	0f 48 c2             	cmovs  %edx,%eax
80101502:	c1 f8 03             	sar    $0x3,%eax
80101505:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101508:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010150d:	89 d1                	mov    %edx,%ecx
8010150f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101512:	09 ca                	or     %ecx,%edx
80101514:	89 d1                	mov    %edx,%ecx
80101516:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101519:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
8010151d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101520:	89 04 24             	mov    %eax,(%esp)
80101523:	e8 8a 22 00 00       	call   801037b2 <log_write>
        brelse(bp);
80101528:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010152b:	89 04 24             	mov    %eax,(%esp)
8010152e:	e8 f9 ec ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
80101533:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101536:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101539:	01 c2                	add    %eax,%edx
8010153b:	8b 45 08             	mov    0x8(%ebp),%eax
8010153e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101542:	89 04 24             	mov    %eax,(%esp)
80101545:	e8 cf fe ff ff       	call   80101419 <bzero>
        return b + bi;
8010154a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101550:	01 d0                	add    %edx,%eax
80101552:	eb 52                	jmp    801015a6 <balloc+0x13c>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101554:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101558:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010155f:	7f 17                	jg     80101578 <balloc+0x10e>
80101561:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101564:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101567:	01 d0                	add    %edx,%eax
80101569:	89 c2                	mov    %eax,%edx
8010156b:	a1 80 3a 11 80       	mov    0x80113a80,%eax
80101570:	39 c2                	cmp    %eax,%edx
80101572:	0f 82 43 ff ff ff    	jb     801014bb <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101578:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010157b:	89 04 24             	mov    %eax,(%esp)
8010157e:	e8 a9 ec ff ff       	call   8010022c <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101583:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010158a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010158d:	a1 80 3a 11 80       	mov    0x80113a80,%eax
80101592:	39 c2                	cmp    %eax,%edx
80101594:	0f 82 e9 fe ff ff    	jb     80101483 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010159a:	c7 04 24 80 9a 10 80 	movl   $0x80109a80,(%esp)
801015a1:	e8 bc ef ff ff       	call   80100562 <panic>
}
801015a6:	c9                   	leave  
801015a7:	c3                   	ret    

801015a8 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801015a8:	55                   	push   %ebp
801015a9:	89 e5                	mov    %esp,%ebp
801015ab:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801015ae:	c7 44 24 04 80 3a 11 	movl   $0x80113a80,0x4(%esp)
801015b5:	80 
801015b6:	8b 45 08             	mov    0x8(%ebp),%eax
801015b9:	89 04 24             	mov    %eax,(%esp)
801015bc:	e8 12 fe ff ff       	call   801013d3 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801015c4:	c1 e8 0c             	shr    $0xc,%eax
801015c7:	89 c2                	mov    %eax,%edx
801015c9:	a1 98 3a 11 80       	mov    0x80113a98,%eax
801015ce:	01 c2                	add    %eax,%edx
801015d0:	8b 45 08             	mov    0x8(%ebp),%eax
801015d3:	89 54 24 04          	mov    %edx,0x4(%esp)
801015d7:	89 04 24             	mov    %eax,(%esp)
801015da:	e8 d6 eb ff ff       	call   801001b5 <bread>
801015df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801015e5:	25 ff 0f 00 00       	and    $0xfff,%eax
801015ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f0:	99                   	cltd   
801015f1:	c1 ea 1d             	shr    $0x1d,%edx
801015f4:	01 d0                	add    %edx,%eax
801015f6:	83 e0 07             	and    $0x7,%eax
801015f9:	29 d0                	sub    %edx,%eax
801015fb:	ba 01 00 00 00       	mov    $0x1,%edx
80101600:	89 c1                	mov    %eax,%ecx
80101602:	d3 e2                	shl    %cl,%edx
80101604:	89 d0                	mov    %edx,%eax
80101606:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101609:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010160c:	8d 50 07             	lea    0x7(%eax),%edx
8010160f:	85 c0                	test   %eax,%eax
80101611:	0f 48 c2             	cmovs  %edx,%eax
80101614:	c1 f8 03             	sar    $0x3,%eax
80101617:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010161a:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
8010161f:	0f b6 c0             	movzbl %al,%eax
80101622:	23 45 ec             	and    -0x14(%ebp),%eax
80101625:	85 c0                	test   %eax,%eax
80101627:	75 0c                	jne    80101635 <bfree+0x8d>
    panic("freeing free block");
80101629:	c7 04 24 96 9a 10 80 	movl   $0x80109a96,(%esp)
80101630:	e8 2d ef ff ff       	call   80100562 <panic>
  bp->data[bi/8] &= ~m;
80101635:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101638:	8d 50 07             	lea    0x7(%eax),%edx
8010163b:	85 c0                	test   %eax,%eax
8010163d:	0f 48 c2             	cmovs  %edx,%eax
80101640:	c1 f8 03             	sar    $0x3,%eax
80101643:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101646:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010164b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010164e:	f7 d1                	not    %ecx
80101650:	21 ca                	and    %ecx,%edx
80101652:	89 d1                	mov    %edx,%ecx
80101654:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101657:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
8010165b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010165e:	89 04 24             	mov    %eax,(%esp)
80101661:	e8 4c 21 00 00       	call   801037b2 <log_write>
  brelse(bp);
80101666:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101669:	89 04 24             	mov    %eax,(%esp)
8010166c:	e8 bb eb ff ff       	call   8010022c <brelse>
}
80101671:	c9                   	leave  
80101672:	c3                   	ret    

80101673 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101673:	55                   	push   %ebp
80101674:	89 e5                	mov    %esp,%ebp
80101676:	57                   	push   %edi
80101677:	56                   	push   %esi
80101678:	53                   	push   %ebx
80101679:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
8010167c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
80101683:	c7 44 24 04 a9 9a 10 	movl   $0x80109aa9,0x4(%esp)
8010168a:	80 
8010168b:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101692:	e8 58 4b 00 00       	call   801061ef <initlock>
  for(i = 0; i < NINODE; i++) {
80101697:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010169e:	eb 2c                	jmp    801016cc <iinit+0x59>
    initsleeplock(&icache.inode[i].lock, "inode");
801016a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016a3:	89 d0                	mov    %edx,%eax
801016a5:	c1 e0 03             	shl    $0x3,%eax
801016a8:	01 d0                	add    %edx,%eax
801016aa:	c1 e0 04             	shl    $0x4,%eax
801016ad:	83 c0 30             	add    $0x30,%eax
801016b0:	05 a0 3a 11 80       	add    $0x80113aa0,%eax
801016b5:	83 c0 10             	add    $0x10,%eax
801016b8:	c7 44 24 04 b0 9a 10 	movl   $0x80109ab0,0x4(%esp)
801016bf:	80 
801016c0:	89 04 24             	mov    %eax,(%esp)
801016c3:	e8 ea 49 00 00       	call   801060b2 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801016c8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801016cc:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
801016d0:	7e ce                	jle    801016a0 <iinit+0x2d>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
801016d2:	c7 44 24 04 80 3a 11 	movl   $0x80113a80,0x4(%esp)
801016d9:	80 
801016da:	8b 45 08             	mov    0x8(%ebp),%eax
801016dd:	89 04 24             	mov    %eax,(%esp)
801016e0:	e8 ee fc ff ff       	call   801013d3 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016e5:	a1 98 3a 11 80       	mov    0x80113a98,%eax
801016ea:	8b 3d 94 3a 11 80    	mov    0x80113a94,%edi
801016f0:	8b 35 90 3a 11 80    	mov    0x80113a90,%esi
801016f6:	8b 1d 8c 3a 11 80    	mov    0x80113a8c,%ebx
801016fc:	8b 0d 88 3a 11 80    	mov    0x80113a88,%ecx
80101702:	8b 15 84 3a 11 80    	mov    0x80113a84,%edx
80101708:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010170b:	8b 15 80 3a 11 80    	mov    0x80113a80,%edx
80101711:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101715:	89 7c 24 18          	mov    %edi,0x18(%esp)
80101719:	89 74 24 14          	mov    %esi,0x14(%esp)
8010171d:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101721:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101725:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101728:	89 44 24 08          	mov    %eax,0x8(%esp)
8010172c:	89 d0                	mov    %edx,%eax
8010172e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101732:	c7 04 24 b8 9a 10 80 	movl   $0x80109ab8,(%esp)
80101739:	e8 8a ec ff ff       	call   801003c8 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010173e:	83 c4 4c             	add    $0x4c,%esp
80101741:	5b                   	pop    %ebx
80101742:	5e                   	pop    %esi
80101743:	5f                   	pop    %edi
80101744:	5d                   	pop    %ebp
80101745:	c3                   	ret    

80101746 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101746:	55                   	push   %ebp
80101747:	89 e5                	mov    %esp,%ebp
80101749:	83 ec 28             	sub    $0x28,%esp
8010174c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010174f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101753:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010175a:	e9 9e 00 00 00       	jmp    801017fd <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
8010175f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101762:	c1 e8 03             	shr    $0x3,%eax
80101765:	89 c2                	mov    %eax,%edx
80101767:	a1 94 3a 11 80       	mov    0x80113a94,%eax
8010176c:	01 d0                	add    %edx,%eax
8010176e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101772:	8b 45 08             	mov    0x8(%ebp),%eax
80101775:	89 04 24             	mov    %eax,(%esp)
80101778:	e8 38 ea ff ff       	call   801001b5 <bread>
8010177d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101780:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101783:	8d 50 5c             	lea    0x5c(%eax),%edx
80101786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101789:	83 e0 07             	and    $0x7,%eax
8010178c:	c1 e0 06             	shl    $0x6,%eax
8010178f:	01 d0                	add    %edx,%eax
80101791:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101794:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101797:	0f b7 00             	movzwl (%eax),%eax
8010179a:	66 85 c0             	test   %ax,%ax
8010179d:	75 4f                	jne    801017ee <ialloc+0xa8>
      memset(dip, 0, sizeof(*dip));
8010179f:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801017a6:	00 
801017a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801017ae:	00 
801017af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017b2:	89 04 24             	mov    %eax,(%esp)
801017b5:	e8 bf 4c 00 00       	call   80106479 <memset>
      dip->type = type;
801017ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017bd:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017c1:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c7:	89 04 24             	mov    %eax,(%esp)
801017ca:	e8 e3 1f 00 00       	call   801037b2 <log_write>
      brelse(bp);
801017cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d2:	89 04 24             	mov    %eax,(%esp)
801017d5:	e8 52 ea ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
801017da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801017e1:	8b 45 08             	mov    0x8(%ebp),%eax
801017e4:	89 04 24             	mov    %eax,(%esp)
801017e7:	e8 ed 00 00 00       	call   801018d9 <iget>
801017ec:	eb 2b                	jmp    80101819 <ialloc+0xd3>
    }
    brelse(bp);
801017ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f1:	89 04 24             	mov    %eax,(%esp)
801017f4:	e8 33 ea ff ff       	call   8010022c <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801017f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801017fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101800:	a1 88 3a 11 80       	mov    0x80113a88,%eax
80101805:	39 c2                	cmp    %eax,%edx
80101807:	0f 82 52 ff ff ff    	jb     8010175f <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010180d:	c7 04 24 0b 9b 10 80 	movl   $0x80109b0b,(%esp)
80101814:	e8 49 ed ff ff       	call   80100562 <panic>
}
80101819:	c9                   	leave  
8010181a:	c3                   	ret    

8010181b <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010181b:	55                   	push   %ebp
8010181c:	89 e5                	mov    %esp,%ebp
8010181e:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101821:	8b 45 08             	mov    0x8(%ebp),%eax
80101824:	8b 40 04             	mov    0x4(%eax),%eax
80101827:	c1 e8 03             	shr    $0x3,%eax
8010182a:	89 c2                	mov    %eax,%edx
8010182c:	a1 94 3a 11 80       	mov    0x80113a94,%eax
80101831:	01 c2                	add    %eax,%edx
80101833:	8b 45 08             	mov    0x8(%ebp),%eax
80101836:	8b 00                	mov    (%eax),%eax
80101838:	89 54 24 04          	mov    %edx,0x4(%esp)
8010183c:	89 04 24             	mov    %eax,(%esp)
8010183f:	e8 71 e9 ff ff       	call   801001b5 <bread>
80101844:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101847:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184a:	8d 50 5c             	lea    0x5c(%eax),%edx
8010184d:	8b 45 08             	mov    0x8(%ebp),%eax
80101850:	8b 40 04             	mov    0x4(%eax),%eax
80101853:	83 e0 07             	and    $0x7,%eax
80101856:	c1 e0 06             	shl    $0x6,%eax
80101859:	01 d0                	add    %edx,%eax
8010185b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010185e:	8b 45 08             	mov    0x8(%ebp),%eax
80101861:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101865:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101868:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010186b:	8b 45 08             	mov    0x8(%ebp),%eax
8010186e:	0f b7 50 52          	movzwl 0x52(%eax),%edx
80101872:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101875:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101879:	8b 45 08             	mov    0x8(%ebp),%eax
8010187c:	0f b7 50 54          	movzwl 0x54(%eax),%edx
80101880:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101883:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101887:	8b 45 08             	mov    0x8(%ebp),%eax
8010188a:	0f b7 50 56          	movzwl 0x56(%eax),%edx
8010188e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101891:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101895:	8b 45 08             	mov    0x8(%ebp),%eax
80101898:	8b 50 58             	mov    0x58(%eax),%edx
8010189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189e:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018a1:	8b 45 08             	mov    0x8(%ebp),%eax
801018a4:	8d 50 5c             	lea    0x5c(%eax),%edx
801018a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018aa:	83 c0 0c             	add    $0xc,%eax
801018ad:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801018b4:	00 
801018b5:	89 54 24 04          	mov    %edx,0x4(%esp)
801018b9:	89 04 24             	mov    %eax,(%esp)
801018bc:	e8 87 4c 00 00       	call   80106548 <memmove>
  log_write(bp);
801018c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c4:	89 04 24             	mov    %eax,(%esp)
801018c7:	e8 e6 1e 00 00       	call   801037b2 <log_write>
  brelse(bp);
801018cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018cf:	89 04 24             	mov    %eax,(%esp)
801018d2:	e8 55 e9 ff ff       	call   8010022c <brelse>
}
801018d7:	c9                   	leave  
801018d8:	c3                   	ret    

801018d9 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018d9:	55                   	push   %ebp
801018da:	89 e5                	mov    %esp,%ebp
801018dc:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018df:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
801018e6:	e8 25 49 00 00       	call   80106210 <acquire>

  // Is the inode already cached?
  empty = 0;
801018eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018f2:	c7 45 f4 d4 3a 11 80 	movl   $0x80113ad4,-0xc(%ebp)
801018f9:	eb 5c                	jmp    80101957 <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018fe:	8b 40 08             	mov    0x8(%eax),%eax
80101901:	85 c0                	test   %eax,%eax
80101903:	7e 35                	jle    8010193a <iget+0x61>
80101905:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101908:	8b 00                	mov    (%eax),%eax
8010190a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010190d:	75 2b                	jne    8010193a <iget+0x61>
8010190f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101912:	8b 40 04             	mov    0x4(%eax),%eax
80101915:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101918:	75 20                	jne    8010193a <iget+0x61>
      ip->ref++;
8010191a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191d:	8b 40 08             	mov    0x8(%eax),%eax
80101920:	8d 50 01             	lea    0x1(%eax),%edx
80101923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101926:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101929:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101930:	e8 42 49 00 00       	call   80106277 <release>
      return ip;
80101935:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101938:	eb 72                	jmp    801019ac <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010193a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010193e:	75 10                	jne    80101950 <iget+0x77>
80101940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101943:	8b 40 08             	mov    0x8(%eax),%eax
80101946:	85 c0                	test   %eax,%eax
80101948:	75 06                	jne    80101950 <iget+0x77>
      empty = ip;
8010194a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010194d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101950:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80101957:	81 7d f4 f4 56 11 80 	cmpl   $0x801156f4,-0xc(%ebp)
8010195e:	72 9b                	jb     801018fb <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101960:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101964:	75 0c                	jne    80101972 <iget+0x99>
    panic("iget: no inodes");
80101966:	c7 04 24 1d 9b 10 80 	movl   $0x80109b1d,(%esp)
8010196d:	e8 f0 eb ff ff       	call   80100562 <panic>

  ip = empty;
80101972:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101975:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101978:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197b:	8b 55 08             	mov    0x8(%ebp),%edx
8010197e:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101980:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101983:	8b 55 0c             	mov    0xc(%ebp),%edx
80101986:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010198c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101993:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101996:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
8010199d:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
801019a4:	e8 ce 48 00 00       	call   80106277 <release>

  return ip;
801019a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019ac:	c9                   	leave  
801019ad:	c3                   	ret    

801019ae <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019ae:	55                   	push   %ebp
801019af:	89 e5                	mov    %esp,%ebp
801019b1:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
801019b4:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
801019bb:	e8 50 48 00 00       	call   80106210 <acquire>
  ip->ref++;
801019c0:	8b 45 08             	mov    0x8(%ebp),%eax
801019c3:	8b 40 08             	mov    0x8(%eax),%eax
801019c6:	8d 50 01             	lea    0x1(%eax),%edx
801019c9:	8b 45 08             	mov    0x8(%ebp),%eax
801019cc:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019cf:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
801019d6:	e8 9c 48 00 00       	call   80106277 <release>
  return ip;
801019db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801019de:	c9                   	leave  
801019df:	c3                   	ret    

801019e0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801019e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019ea:	74 0a                	je     801019f6 <ilock+0x16>
801019ec:	8b 45 08             	mov    0x8(%ebp),%eax
801019ef:	8b 40 08             	mov    0x8(%eax),%eax
801019f2:	85 c0                	test   %eax,%eax
801019f4:	7f 0c                	jg     80101a02 <ilock+0x22>
    panic("ilock");
801019f6:	c7 04 24 2d 9b 10 80 	movl   $0x80109b2d,(%esp)
801019fd:	e8 60 eb ff ff       	call   80100562 <panic>

  acquiresleep(&ip->lock);
80101a02:	8b 45 08             	mov    0x8(%ebp),%eax
80101a05:	83 c0 0c             	add    $0xc,%eax
80101a08:	89 04 24             	mov    %eax,(%esp)
80101a0b:	e8 dc 46 00 00       	call   801060ec <acquiresleep>

  if(!(ip->flags & I_VALID)){
80101a10:	8b 45 08             	mov    0x8(%ebp),%eax
80101a13:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a16:	83 e0 02             	and    $0x2,%eax
80101a19:	85 c0                	test   %eax,%eax
80101a1b:	0f 85 d4 00 00 00    	jne    80101af5 <ilock+0x115>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a21:	8b 45 08             	mov    0x8(%ebp),%eax
80101a24:	8b 40 04             	mov    0x4(%eax),%eax
80101a27:	c1 e8 03             	shr    $0x3,%eax
80101a2a:	89 c2                	mov    %eax,%edx
80101a2c:	a1 94 3a 11 80       	mov    0x80113a94,%eax
80101a31:	01 c2                	add    %eax,%edx
80101a33:	8b 45 08             	mov    0x8(%ebp),%eax
80101a36:	8b 00                	mov    (%eax),%eax
80101a38:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a3c:	89 04 24             	mov    %eax,(%esp)
80101a3f:	e8 71 e7 ff ff       	call   801001b5 <bread>
80101a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a4a:	8d 50 5c             	lea    0x5c(%eax),%edx
80101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a50:	8b 40 04             	mov    0x4(%eax),%eax
80101a53:	83 e0 07             	and    $0x7,%eax
80101a56:	c1 e0 06             	shl    $0x6,%eax
80101a59:	01 d0                	add    %edx,%eax
80101a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a61:	0f b7 10             	movzwl (%eax),%edx
80101a64:	8b 45 08             	mov    0x8(%ebp),%eax
80101a67:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
80101a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a6e:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a72:	8b 45 08             	mov    0x8(%ebp),%eax
80101a75:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
80101a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a7c:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a8a:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a91:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a98:	8b 50 08             	mov    0x8(%eax),%edx
80101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9e:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aa4:	8d 50 0c             	lea    0xc(%eax),%edx
80101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aaa:	83 c0 5c             	add    $0x5c,%eax
80101aad:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101ab4:	00 
80101ab5:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ab9:	89 04 24             	mov    %eax,(%esp)
80101abc:	e8 87 4a 00 00       	call   80106548 <memmove>
    brelse(bp);
80101ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ac4:	89 04 24             	mov    %eax,(%esp)
80101ac7:	e8 60 e7 ff ff       	call   8010022c <brelse>
    ip->flags |= I_VALID;
80101acc:	8b 45 08             	mov    0x8(%ebp),%eax
80101acf:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ad2:	83 c8 02             	or     $0x2,%eax
80101ad5:	89 c2                	mov    %eax,%edx
80101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ada:	89 50 4c             	mov    %edx,0x4c(%eax)
    if(ip->type == 0)
80101add:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae0:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101ae4:	66 85 c0             	test   %ax,%ax
80101ae7:	75 0c                	jne    80101af5 <ilock+0x115>
      panic("ilock: no type");
80101ae9:	c7 04 24 33 9b 10 80 	movl   $0x80109b33,(%esp)
80101af0:	e8 6d ea ff ff       	call   80100562 <panic>
  }
}
80101af5:	c9                   	leave  
80101af6:	c3                   	ret    

80101af7 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101af7:	55                   	push   %ebp
80101af8:	89 e5                	mov    %esp,%ebp
80101afa:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101afd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b01:	74 1c                	je     80101b1f <iunlock+0x28>
80101b03:	8b 45 08             	mov    0x8(%ebp),%eax
80101b06:	83 c0 0c             	add    $0xc,%eax
80101b09:	89 04 24             	mov    %eax,(%esp)
80101b0c:	e8 79 46 00 00       	call   8010618a <holdingsleep>
80101b11:	85 c0                	test   %eax,%eax
80101b13:	74 0a                	je     80101b1f <iunlock+0x28>
80101b15:	8b 45 08             	mov    0x8(%ebp),%eax
80101b18:	8b 40 08             	mov    0x8(%eax),%eax
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	7f 0c                	jg     80101b2b <iunlock+0x34>
    panic("iunlock");
80101b1f:	c7 04 24 42 9b 10 80 	movl   $0x80109b42,(%esp)
80101b26:	e8 37 ea ff ff       	call   80100562 <panic>

  releasesleep(&ip->lock);
80101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2e:	83 c0 0c             	add    $0xc,%eax
80101b31:	89 04 24             	mov    %eax,(%esp)
80101b34:	e8 0f 46 00 00       	call   80106148 <releasesleep>
}
80101b39:	c9                   	leave  
80101b3a:	c3                   	ret    

80101b3b <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b3b:	55                   	push   %ebp
80101b3c:	89 e5                	mov    %esp,%ebp
80101b3e:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101b41:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101b48:	e8 c3 46 00 00       	call   80106210 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b50:	8b 40 08             	mov    0x8(%eax),%eax
80101b53:	83 f8 01             	cmp    $0x1,%eax
80101b56:	75 5a                	jne    80101bb2 <iput+0x77>
80101b58:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5b:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b5e:	83 e0 02             	and    $0x2,%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 4d                	je     80101bb2 <iput+0x77>
80101b65:	8b 45 08             	mov    0x8(%ebp),%eax
80101b68:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101b6c:	66 85 c0             	test   %ax,%ax
80101b6f:	75 41                	jne    80101bb2 <iput+0x77>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
80101b71:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101b78:	e8 fa 46 00 00       	call   80106277 <release>
    itrunc(ip);
80101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b80:	89 04 24             	mov    %eax,(%esp)
80101b83:	e8 78 01 00 00       	call   80101d00 <itrunc>
    ip->type = 0;
80101b88:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8b:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
    iupdate(ip);
80101b91:	8b 45 08             	mov    0x8(%ebp),%eax
80101b94:	89 04 24             	mov    %eax,(%esp)
80101b97:	e8 7f fc ff ff       	call   8010181b <iupdate>
    acquire(&icache.lock);
80101b9c:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101ba3:	e8 68 46 00 00       	call   80106210 <acquire>
    ip->flags = 0;
80101ba8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bab:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }
  ip->ref--;
80101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb5:	8b 40 08             	mov    0x8(%eax),%eax
80101bb8:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbe:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bc1:	c7 04 24 a0 3a 11 80 	movl   $0x80113aa0,(%esp)
80101bc8:	e8 aa 46 00 00       	call   80106277 <release>
}
80101bcd:	c9                   	leave  
80101bce:	c3                   	ret    

80101bcf <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101bcf:	55                   	push   %ebp
80101bd0:	89 e5                	mov    %esp,%ebp
80101bd2:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd8:	89 04 24             	mov    %eax,(%esp)
80101bdb:	e8 17 ff ff ff       	call   80101af7 <iunlock>
  iput(ip);
80101be0:	8b 45 08             	mov    0x8(%ebp),%eax
80101be3:	89 04 24             	mov    %eax,(%esp)
80101be6:	e8 50 ff ff ff       	call   80101b3b <iput>
}
80101beb:	c9                   	leave  
80101bec:	c3                   	ret    

80101bed <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101bed:	55                   	push   %ebp
80101bee:	89 e5                	mov    %esp,%ebp
80101bf0:	53                   	push   %ebx
80101bf1:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101bf4:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101bf8:	77 3e                	ja     80101c38 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101bfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c00:	83 c2 14             	add    $0x14,%edx
80101c03:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c0e:	75 20                	jne    80101c30 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c10:	8b 45 08             	mov    0x8(%ebp),%eax
80101c13:	8b 00                	mov    (%eax),%eax
80101c15:	89 04 24             	mov    %eax,(%esp)
80101c18:	e8 4d f8 ff ff       	call   8010146a <balloc>
80101c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c20:	8b 45 08             	mov    0x8(%ebp),%eax
80101c23:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c26:	8d 4a 14             	lea    0x14(%edx),%ecx
80101c29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c2c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c33:	e9 c2 00 00 00       	jmp    80101cfa <bmap+0x10d>
  }
  bn -= NDIRECT;
80101c38:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c3c:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c40:	0f 87 a8 00 00 00    	ja     80101cee <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c46:	8b 45 08             	mov    0x8(%ebp),%eax
80101c49:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c56:	75 1c                	jne    80101c74 <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c58:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5b:	8b 00                	mov    (%eax),%eax
80101c5d:	89 04 24             	mov    %eax,(%esp)
80101c60:	e8 05 f8 ff ff       	call   8010146a <balloc>
80101c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c68:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c6e:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101c74:	8b 45 08             	mov    0x8(%ebp),%eax
80101c77:	8b 00                	mov    (%eax),%eax
80101c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c7c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c80:	89 04 24             	mov    %eax,(%esp)
80101c83:	e8 2d e5 ff ff       	call   801001b5 <bread>
80101c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c8e:	83 c0 5c             	add    $0x5c,%eax
80101c91:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c94:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c97:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ca1:	01 d0                	add    %edx,%eax
80101ca3:	8b 00                	mov    (%eax),%eax
80101ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cac:	75 30                	jne    80101cde <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101cae:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cb1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cbb:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101cbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc1:	8b 00                	mov    (%eax),%eax
80101cc3:	89 04 24             	mov    %eax,(%esp)
80101cc6:	e8 9f f7 ff ff       	call   8010146a <balloc>
80101ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cd1:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd6:	89 04 24             	mov    %eax,(%esp)
80101cd9:	e8 d4 1a 00 00       	call   801037b2 <log_write>
    }
    brelse(bp);
80101cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ce1:	89 04 24             	mov    %eax,(%esp)
80101ce4:	e8 43 e5 ff ff       	call   8010022c <brelse>
    return addr;
80101ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cec:	eb 0c                	jmp    80101cfa <bmap+0x10d>
  }

  panic("bmap: out of range");
80101cee:	c7 04 24 4a 9b 10 80 	movl   $0x80109b4a,(%esp)
80101cf5:	e8 68 e8 ff ff       	call   80100562 <panic>
}
80101cfa:	83 c4 24             	add    $0x24,%esp
80101cfd:	5b                   	pop    %ebx
80101cfe:	5d                   	pop    %ebp
80101cff:	c3                   	ret    

80101d00 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d0d:	eb 44                	jmp    80101d53 <itrunc+0x53>
    if(ip->addrs[i]){
80101d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d12:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d15:	83 c2 14             	add    $0x14,%edx
80101d18:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d1c:	85 c0                	test   %eax,%eax
80101d1e:	74 2f                	je     80101d4f <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101d20:	8b 45 08             	mov    0x8(%ebp),%eax
80101d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d26:	83 c2 14             	add    $0x14,%edx
80101d29:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101d2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d30:	8b 00                	mov    (%eax),%eax
80101d32:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d36:	89 04 24             	mov    %eax,(%esp)
80101d39:	e8 6a f8 ff ff       	call   801015a8 <bfree>
      ip->addrs[i] = 0;
80101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d44:	83 c2 14             	add    $0x14,%edx
80101d47:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d4e:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d4f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d53:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d57:	7e b6                	jle    80101d0f <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
80101d59:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5c:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101d62:	85 c0                	test   %eax,%eax
80101d64:	0f 84 a4 00 00 00    	je     80101e0e <itrunc+0x10e>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6d:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101d73:	8b 45 08             	mov    0x8(%ebp),%eax
80101d76:	8b 00                	mov    (%eax),%eax
80101d78:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d7c:	89 04 24             	mov    %eax,(%esp)
80101d7f:	e8 31 e4 ff ff       	call   801001b5 <bread>
80101d84:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d8a:	83 c0 5c             	add    $0x5c,%eax
80101d8d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d90:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d97:	eb 3b                	jmp    80101dd4 <itrunc+0xd4>
      if(a[j])
80101d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d9c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101da6:	01 d0                	add    %edx,%eax
80101da8:	8b 00                	mov    (%eax),%eax
80101daa:	85 c0                	test   %eax,%eax
80101dac:	74 22                	je     80101dd0 <itrunc+0xd0>
        bfree(ip->dev, a[j]);
80101dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101db1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101db8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dbb:	01 d0                	add    %edx,%eax
80101dbd:	8b 10                	mov    (%eax),%edx
80101dbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc2:	8b 00                	mov    (%eax),%eax
80101dc4:	89 54 24 04          	mov    %edx,0x4(%esp)
80101dc8:	89 04 24             	mov    %eax,(%esp)
80101dcb:	e8 d8 f7 ff ff       	call   801015a8 <bfree>
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101dd0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dd7:	83 f8 7f             	cmp    $0x7f,%eax
80101dda:	76 bd                	jbe    80101d99 <itrunc+0x99>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101ddc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ddf:	89 04 24             	mov    %eax,(%esp)
80101de2:	e8 45 e4 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101de7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dea:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101df0:	8b 45 08             	mov    0x8(%ebp),%eax
80101df3:	8b 00                	mov    (%eax),%eax
80101df5:	89 54 24 04          	mov    %edx,0x4(%esp)
80101df9:	89 04 24             	mov    %eax,(%esp)
80101dfc:	e8 a7 f7 ff ff       	call   801015a8 <bfree>
    ip->addrs[NDIRECT] = 0;
80101e01:	8b 45 08             	mov    0x8(%ebp),%eax
80101e04:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101e0b:	00 00 00 
  }

  ip->size = 0;
80101e0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e11:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101e18:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1b:	89 04 24             	mov    %eax,(%esp)
80101e1e:	e8 f8 f9 ff ff       	call   8010181b <iupdate>
}
80101e23:	c9                   	leave  
80101e24:	c3                   	ret    

80101e25 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e25:	55                   	push   %ebp
80101e26:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e28:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2b:	8b 00                	mov    (%eax),%eax
80101e2d:	89 c2                	mov    %eax,%edx
80101e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e32:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e35:	8b 45 08             	mov    0x8(%ebp),%eax
80101e38:	8b 50 04             	mov    0x4(%eax),%edx
80101e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3e:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e41:	8b 45 08             	mov    0x8(%ebp),%eax
80101e44:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101e48:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e4b:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e51:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101e55:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e58:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5f:	8b 50 58             	mov    0x58(%eax),%edx
80101e62:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e65:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e68:	5d                   	pop    %ebp
80101e69:	c3                   	ret    

80101e6a <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e6a:	55                   	push   %ebp
80101e6b:	89 e5                	mov    %esp,%ebp
80101e6d:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e70:	8b 45 08             	mov    0x8(%ebp),%eax
80101e73:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101e77:	66 83 f8 03          	cmp    $0x3,%ax
80101e7b:	75 60                	jne    80101edd <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e80:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e84:	66 85 c0             	test   %ax,%ax
80101e87:	78 20                	js     80101ea9 <readi+0x3f>
80101e89:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8c:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e90:	66 83 f8 09          	cmp    $0x9,%ax
80101e94:	7f 13                	jg     80101ea9 <readi+0x3f>
80101e96:	8b 45 08             	mov    0x8(%ebp),%eax
80101e99:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e9d:	98                   	cwtl   
80101e9e:	8b 04 c5 20 3a 11 80 	mov    -0x7feec5e0(,%eax,8),%eax
80101ea5:	85 c0                	test   %eax,%eax
80101ea7:	75 0a                	jne    80101eb3 <readi+0x49>
      return -1;
80101ea9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eae:	e9 19 01 00 00       	jmp    80101fcc <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101eb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb6:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101eba:	98                   	cwtl   
80101ebb:	8b 04 c5 20 3a 11 80 	mov    -0x7feec5e0(,%eax,8),%eax
80101ec2:	8b 55 14             	mov    0x14(%ebp),%edx
80101ec5:	89 54 24 08          	mov    %edx,0x8(%esp)
80101ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ecc:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ed0:	8b 55 08             	mov    0x8(%ebp),%edx
80101ed3:	89 14 24             	mov    %edx,(%esp)
80101ed6:	ff d0                	call   *%eax
80101ed8:	e9 ef 00 00 00       	jmp    80101fcc <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101edd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee0:	8b 40 58             	mov    0x58(%eax),%eax
80101ee3:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ee6:	72 0d                	jb     80101ef5 <readi+0x8b>
80101ee8:	8b 45 14             	mov    0x14(%ebp),%eax
80101eeb:	8b 55 10             	mov    0x10(%ebp),%edx
80101eee:	01 d0                	add    %edx,%eax
80101ef0:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ef3:	73 0a                	jae    80101eff <readi+0x95>
    return -1;
80101ef5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101efa:	e9 cd 00 00 00       	jmp    80101fcc <readi+0x162>
  if(off + n > ip->size)
80101eff:	8b 45 14             	mov    0x14(%ebp),%eax
80101f02:	8b 55 10             	mov    0x10(%ebp),%edx
80101f05:	01 c2                	add    %eax,%edx
80101f07:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0a:	8b 40 58             	mov    0x58(%eax),%eax
80101f0d:	39 c2                	cmp    %eax,%edx
80101f0f:	76 0c                	jbe    80101f1d <readi+0xb3>
    n = ip->size - off;
80101f11:	8b 45 08             	mov    0x8(%ebp),%eax
80101f14:	8b 40 58             	mov    0x58(%eax),%eax
80101f17:	2b 45 10             	sub    0x10(%ebp),%eax
80101f1a:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f24:	e9 94 00 00 00       	jmp    80101fbd <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f29:	8b 45 10             	mov    0x10(%ebp),%eax
80101f2c:	c1 e8 09             	shr    $0x9,%eax
80101f2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f33:	8b 45 08             	mov    0x8(%ebp),%eax
80101f36:	89 04 24             	mov    %eax,(%esp)
80101f39:	e8 af fc ff ff       	call   80101bed <bmap>
80101f3e:	8b 55 08             	mov    0x8(%ebp),%edx
80101f41:	8b 12                	mov    (%edx),%edx
80101f43:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f47:	89 14 24             	mov    %edx,(%esp)
80101f4a:	e8 66 e2 ff ff       	call   801001b5 <bread>
80101f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f52:	8b 45 10             	mov    0x10(%ebp),%eax
80101f55:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f5a:	89 c2                	mov    %eax,%edx
80101f5c:	b8 00 02 00 00       	mov    $0x200,%eax
80101f61:	29 d0                	sub    %edx,%eax
80101f63:	89 c2                	mov    %eax,%edx
80101f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f68:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101f6b:	29 c1                	sub    %eax,%ecx
80101f6d:	89 c8                	mov    %ecx,%eax
80101f6f:	39 c2                	cmp    %eax,%edx
80101f71:	0f 46 c2             	cmovbe %edx,%eax
80101f74:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101f77:	8b 45 10             	mov    0x10(%ebp),%eax
80101f7a:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f7f:	8d 50 50             	lea    0x50(%eax),%edx
80101f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f85:	01 d0                	add    %edx,%eax
80101f87:	8d 50 0c             	lea    0xc(%eax),%edx
80101f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f8d:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f91:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f95:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f98:	89 04 24             	mov    %eax,(%esp)
80101f9b:	e8 a8 45 00 00       	call   80106548 <memmove>
    brelse(bp);
80101fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fa3:	89 04 24             	mov    %eax,(%esp)
80101fa6:	e8 81 e2 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fae:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fb4:	01 45 10             	add    %eax,0x10(%ebp)
80101fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fba:	01 45 0c             	add    %eax,0xc(%ebp)
80101fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fc0:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fc3:	0f 82 60 ff ff ff    	jb     80101f29 <readi+0xbf>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101fc9:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fcc:	c9                   	leave  
80101fcd:	c3                   	ret    

80101fce <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101fce:	55                   	push   %ebp
80101fcf:	89 e5                	mov    %esp,%ebp
80101fd1:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fd4:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd7:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101fdb:	66 83 f8 03          	cmp    $0x3,%ax
80101fdf:	75 60                	jne    80102041 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fe1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe4:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101fe8:	66 85 c0             	test   %ax,%ax
80101feb:	78 20                	js     8010200d <writei+0x3f>
80101fed:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff0:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101ff4:	66 83 f8 09          	cmp    $0x9,%ax
80101ff8:	7f 13                	jg     8010200d <writei+0x3f>
80101ffa:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffd:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80102001:	98                   	cwtl   
80102002:	8b 04 c5 24 3a 11 80 	mov    -0x7feec5dc(,%eax,8),%eax
80102009:	85 c0                	test   %eax,%eax
8010200b:	75 0a                	jne    80102017 <writei+0x49>
      return -1;
8010200d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102012:	e9 44 01 00 00       	jmp    8010215b <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80102017:	8b 45 08             	mov    0x8(%ebp),%eax
8010201a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010201e:	98                   	cwtl   
8010201f:	8b 04 c5 24 3a 11 80 	mov    -0x7feec5dc(,%eax,8),%eax
80102026:	8b 55 14             	mov    0x14(%ebp),%edx
80102029:	89 54 24 08          	mov    %edx,0x8(%esp)
8010202d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102030:	89 54 24 04          	mov    %edx,0x4(%esp)
80102034:	8b 55 08             	mov    0x8(%ebp),%edx
80102037:	89 14 24             	mov    %edx,(%esp)
8010203a:	ff d0                	call   *%eax
8010203c:	e9 1a 01 00 00       	jmp    8010215b <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80102041:	8b 45 08             	mov    0x8(%ebp),%eax
80102044:	8b 40 58             	mov    0x58(%eax),%eax
80102047:	3b 45 10             	cmp    0x10(%ebp),%eax
8010204a:	72 0d                	jb     80102059 <writei+0x8b>
8010204c:	8b 45 14             	mov    0x14(%ebp),%eax
8010204f:	8b 55 10             	mov    0x10(%ebp),%edx
80102052:	01 d0                	add    %edx,%eax
80102054:	3b 45 10             	cmp    0x10(%ebp),%eax
80102057:	73 0a                	jae    80102063 <writei+0x95>
    return -1;
80102059:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010205e:	e9 f8 00 00 00       	jmp    8010215b <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80102063:	8b 45 14             	mov    0x14(%ebp),%eax
80102066:	8b 55 10             	mov    0x10(%ebp),%edx
80102069:	01 d0                	add    %edx,%eax
8010206b:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102070:	76 0a                	jbe    8010207c <writei+0xae>
    return -1;
80102072:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102077:	e9 df 00 00 00       	jmp    8010215b <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010207c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102083:	e9 9f 00 00 00       	jmp    80102127 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102088:	8b 45 10             	mov    0x10(%ebp),%eax
8010208b:	c1 e8 09             	shr    $0x9,%eax
8010208e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102092:	8b 45 08             	mov    0x8(%ebp),%eax
80102095:	89 04 24             	mov    %eax,(%esp)
80102098:	e8 50 fb ff ff       	call   80101bed <bmap>
8010209d:	8b 55 08             	mov    0x8(%ebp),%edx
801020a0:	8b 12                	mov    (%edx),%edx
801020a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801020a6:	89 14 24             	mov    %edx,(%esp)
801020a9:	e8 07 e1 ff ff       	call   801001b5 <bread>
801020ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020b1:	8b 45 10             	mov    0x10(%ebp),%eax
801020b4:	25 ff 01 00 00       	and    $0x1ff,%eax
801020b9:	89 c2                	mov    %eax,%edx
801020bb:	b8 00 02 00 00       	mov    $0x200,%eax
801020c0:	29 d0                	sub    %edx,%eax
801020c2:	89 c2                	mov    %eax,%edx
801020c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020c7:	8b 4d 14             	mov    0x14(%ebp),%ecx
801020ca:	29 c1                	sub    %eax,%ecx
801020cc:	89 c8                	mov    %ecx,%eax
801020ce:	39 c2                	cmp    %eax,%edx
801020d0:	0f 46 c2             	cmovbe %edx,%eax
801020d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020d6:	8b 45 10             	mov    0x10(%ebp),%eax
801020d9:	25 ff 01 00 00       	and    $0x1ff,%eax
801020de:	8d 50 50             	lea    0x50(%eax),%edx
801020e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020e4:	01 d0                	add    %edx,%eax
801020e6:	8d 50 0c             	lea    0xc(%eax),%edx
801020e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020ec:	89 44 24 08          	mov    %eax,0x8(%esp)
801020f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801020f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801020f7:	89 14 24             	mov    %edx,(%esp)
801020fa:	e8 49 44 00 00       	call   80106548 <memmove>
    log_write(bp);
801020ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102102:	89 04 24             	mov    %eax,(%esp)
80102105:	e8 a8 16 00 00       	call   801037b2 <log_write>
    brelse(bp);
8010210a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010210d:	89 04 24             	mov    %eax,(%esp)
80102110:	e8 17 e1 ff ff       	call   8010022c <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102115:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102118:	01 45 f4             	add    %eax,-0xc(%ebp)
8010211b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010211e:	01 45 10             	add    %eax,0x10(%ebp)
80102121:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102124:	01 45 0c             	add    %eax,0xc(%ebp)
80102127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010212a:	3b 45 14             	cmp    0x14(%ebp),%eax
8010212d:	0f 82 55 ff ff ff    	jb     80102088 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102133:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102137:	74 1f                	je     80102158 <writei+0x18a>
80102139:	8b 45 08             	mov    0x8(%ebp),%eax
8010213c:	8b 40 58             	mov    0x58(%eax),%eax
8010213f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102142:	73 14                	jae    80102158 <writei+0x18a>
    ip->size = off;
80102144:	8b 45 08             	mov    0x8(%ebp),%eax
80102147:	8b 55 10             	mov    0x10(%ebp),%edx
8010214a:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
8010214d:	8b 45 08             	mov    0x8(%ebp),%eax
80102150:	89 04 24             	mov    %eax,(%esp)
80102153:	e8 c3 f6 ff ff       	call   8010181b <iupdate>
  }
  return n;
80102158:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010215b:	c9                   	leave  
8010215c:	c3                   	ret    

8010215d <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010215d:	55                   	push   %ebp
8010215e:	89 e5                	mov    %esp,%ebp
80102160:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102163:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010216a:	00 
8010216b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010216e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102172:	8b 45 08             	mov    0x8(%ebp),%eax
80102175:	89 04 24             	mov    %eax,(%esp)
80102178:	e8 6e 44 00 00       	call   801065eb <strncmp>
}
8010217d:	c9                   	leave  
8010217e:	c3                   	ret    

8010217f <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010217f:	55                   	push   %ebp
80102180:	89 e5                	mov    %esp,%ebp
80102182:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102185:	8b 45 08             	mov    0x8(%ebp),%eax
80102188:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010218c:	66 83 f8 01          	cmp    $0x1,%ax
80102190:	74 0c                	je     8010219e <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102192:	c7 04 24 5d 9b 10 80 	movl   $0x80109b5d,(%esp)
80102199:	e8 c4 e3 ff ff       	call   80100562 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010219e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021a5:	e9 88 00 00 00       	jmp    80102232 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021aa:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021b1:	00 
801021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801021b9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801021c0:	8b 45 08             	mov    0x8(%ebp),%eax
801021c3:	89 04 24             	mov    %eax,(%esp)
801021c6:	e8 9f fc ff ff       	call   80101e6a <readi>
801021cb:	83 f8 10             	cmp    $0x10,%eax
801021ce:	74 0c                	je     801021dc <dirlookup+0x5d>
      panic("dirlink read");
801021d0:	c7 04 24 6f 9b 10 80 	movl   $0x80109b6f,(%esp)
801021d7:	e8 86 e3 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
801021dc:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021e0:	66 85 c0             	test   %ax,%ax
801021e3:	75 02                	jne    801021e7 <dirlookup+0x68>
      continue;
801021e5:	eb 47                	jmp    8010222e <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
801021e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021ea:	83 c0 02             	add    $0x2,%eax
801021ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801021f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801021f4:	89 04 24             	mov    %eax,(%esp)
801021f7:	e8 61 ff ff ff       	call   8010215d <namecmp>
801021fc:	85 c0                	test   %eax,%eax
801021fe:	75 2e                	jne    8010222e <dirlookup+0xaf>
      // entry matches path element
      if(poff)
80102200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102204:	74 08                	je     8010220e <dirlookup+0x8f>
        *poff = off;
80102206:	8b 45 10             	mov    0x10(%ebp),%eax
80102209:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010220c:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010220e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102212:	0f b7 c0             	movzwl %ax,%eax
80102215:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102218:	8b 45 08             	mov    0x8(%ebp),%eax
8010221b:	8b 00                	mov    (%eax),%eax
8010221d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102220:	89 54 24 04          	mov    %edx,0x4(%esp)
80102224:	89 04 24             	mov    %eax,(%esp)
80102227:	e8 ad f6 ff ff       	call   801018d9 <iget>
8010222c:	eb 18                	jmp    80102246 <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010222e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102232:	8b 45 08             	mov    0x8(%ebp),%eax
80102235:	8b 40 58             	mov    0x58(%eax),%eax
80102238:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010223b:	0f 87 69 ff ff ff    	ja     801021aa <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102241:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102246:	c9                   	leave  
80102247:	c3                   	ret    

80102248 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102248:	55                   	push   %ebp
80102249:	89 e5                	mov    %esp,%ebp
8010224b:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010224e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102255:	00 
80102256:	8b 45 0c             	mov    0xc(%ebp),%eax
80102259:	89 44 24 04          	mov    %eax,0x4(%esp)
8010225d:	8b 45 08             	mov    0x8(%ebp),%eax
80102260:	89 04 24             	mov    %eax,(%esp)
80102263:	e8 17 ff ff ff       	call   8010217f <dirlookup>
80102268:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010226b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010226f:	74 15                	je     80102286 <dirlink+0x3e>
    iput(ip);
80102271:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102274:	89 04 24             	mov    %eax,(%esp)
80102277:	e8 bf f8 ff ff       	call   80101b3b <iput>
    return -1;
8010227c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102281:	e9 b7 00 00 00       	jmp    8010233d <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102286:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010228d:	eb 46                	jmp    801022d5 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102292:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102299:	00 
8010229a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010229e:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801022a5:	8b 45 08             	mov    0x8(%ebp),%eax
801022a8:	89 04 24             	mov    %eax,(%esp)
801022ab:	e8 ba fb ff ff       	call   80101e6a <readi>
801022b0:	83 f8 10             	cmp    $0x10,%eax
801022b3:	74 0c                	je     801022c1 <dirlink+0x79>
      panic("dirlink read");
801022b5:	c7 04 24 6f 9b 10 80 	movl   $0x80109b6f,(%esp)
801022bc:	e8 a1 e2 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
801022c1:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022c5:	66 85 c0             	test   %ax,%ax
801022c8:	75 02                	jne    801022cc <dirlink+0x84>
      break;
801022ca:	eb 16                	jmp    801022e2 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022cf:	83 c0 10             	add    $0x10,%eax
801022d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022d8:	8b 45 08             	mov    0x8(%ebp),%eax
801022db:	8b 40 58             	mov    0x58(%eax),%eax
801022de:	39 c2                	cmp    %eax,%edx
801022e0:	72 ad                	jb     8010228f <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801022e2:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022e9:	00 
801022ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801022f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022f4:	83 c0 02             	add    $0x2,%eax
801022f7:	89 04 24             	mov    %eax,(%esp)
801022fa:	e8 42 43 00 00       	call   80106641 <strncpy>
  de.inum = inum;
801022ff:	8b 45 10             	mov    0x10(%ebp),%eax
80102302:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102309:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102310:	00 
80102311:	89 44 24 08          	mov    %eax,0x8(%esp)
80102315:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102318:	89 44 24 04          	mov    %eax,0x4(%esp)
8010231c:	8b 45 08             	mov    0x8(%ebp),%eax
8010231f:	89 04 24             	mov    %eax,(%esp)
80102322:	e8 a7 fc ff ff       	call   80101fce <writei>
80102327:	83 f8 10             	cmp    $0x10,%eax
8010232a:	74 0c                	je     80102338 <dirlink+0xf0>
    panic("dirlink");
8010232c:	c7 04 24 7c 9b 10 80 	movl   $0x80109b7c,(%esp)
80102333:	e8 2a e2 ff ff       	call   80100562 <panic>

  return 0;
80102338:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010233d:	c9                   	leave  
8010233e:	c3                   	ret    

8010233f <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010233f:	55                   	push   %ebp
80102340:	89 e5                	mov    %esp,%ebp
80102342:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102345:	eb 04                	jmp    8010234b <skipelem+0xc>
    path++;
80102347:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010234b:	8b 45 08             	mov    0x8(%ebp),%eax
8010234e:	0f b6 00             	movzbl (%eax),%eax
80102351:	3c 2f                	cmp    $0x2f,%al
80102353:	74 f2                	je     80102347 <skipelem+0x8>
    path++;
  if(*path == 0)
80102355:	8b 45 08             	mov    0x8(%ebp),%eax
80102358:	0f b6 00             	movzbl (%eax),%eax
8010235b:	84 c0                	test   %al,%al
8010235d:	75 0a                	jne    80102369 <skipelem+0x2a>
    return 0;
8010235f:	b8 00 00 00 00       	mov    $0x0,%eax
80102364:	e9 86 00 00 00       	jmp    801023ef <skipelem+0xb0>
  s = path;
80102369:	8b 45 08             	mov    0x8(%ebp),%eax
8010236c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010236f:	eb 04                	jmp    80102375 <skipelem+0x36>
    path++;
80102371:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102375:	8b 45 08             	mov    0x8(%ebp),%eax
80102378:	0f b6 00             	movzbl (%eax),%eax
8010237b:	3c 2f                	cmp    $0x2f,%al
8010237d:	74 0a                	je     80102389 <skipelem+0x4a>
8010237f:	8b 45 08             	mov    0x8(%ebp),%eax
80102382:	0f b6 00             	movzbl (%eax),%eax
80102385:	84 c0                	test   %al,%al
80102387:	75 e8                	jne    80102371 <skipelem+0x32>
    path++;
  len = path - s;
80102389:	8b 55 08             	mov    0x8(%ebp),%edx
8010238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010238f:	29 c2                	sub    %eax,%edx
80102391:	89 d0                	mov    %edx,%eax
80102393:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102396:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010239a:	7e 1c                	jle    801023b8 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
8010239c:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801023a3:	00 
801023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801023ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801023ae:	89 04 24             	mov    %eax,(%esp)
801023b1:	e8 92 41 00 00       	call   80106548 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801023b6:	eb 2a                	jmp    801023e2 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801023b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023bb:	89 44 24 08          	mov    %eax,0x8(%esp)
801023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801023c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801023c9:	89 04 24             	mov    %eax,(%esp)
801023cc:	e8 77 41 00 00       	call   80106548 <memmove>
    name[len] = 0;
801023d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801023d7:	01 d0                	add    %edx,%eax
801023d9:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023dc:	eb 04                	jmp    801023e2 <skipelem+0xa3>
    path++;
801023de:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801023e2:	8b 45 08             	mov    0x8(%ebp),%eax
801023e5:	0f b6 00             	movzbl (%eax),%eax
801023e8:	3c 2f                	cmp    $0x2f,%al
801023ea:	74 f2                	je     801023de <skipelem+0x9f>
    path++;
  return path;
801023ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023ef:	c9                   	leave  
801023f0:	c3                   	ret    

801023f1 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023f1:	55                   	push   %ebp
801023f2:	89 e5                	mov    %esp,%ebp
801023f4:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023f7:	8b 45 08             	mov    0x8(%ebp),%eax
801023fa:	0f b6 00             	movzbl (%eax),%eax
801023fd:	3c 2f                	cmp    $0x2f,%al
801023ff:	75 1c                	jne    8010241d <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102401:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102408:	00 
80102409:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102410:	e8 c4 f4 ff ff       	call   801018d9 <iget>
80102415:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102418:	e9 af 00 00 00       	jmp    801024cc <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010241d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102423:	8b 40 68             	mov    0x68(%eax),%eax
80102426:	89 04 24             	mov    %eax,(%esp)
80102429:	e8 80 f5 ff ff       	call   801019ae <idup>
8010242e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102431:	e9 96 00 00 00       	jmp    801024cc <namex+0xdb>
    ilock(ip);
80102436:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102439:	89 04 24             	mov    %eax,(%esp)
8010243c:	e8 9f f5 ff ff       	call   801019e0 <ilock>
    if(ip->type != T_DIR){
80102441:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102444:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80102448:	66 83 f8 01          	cmp    $0x1,%ax
8010244c:	74 15                	je     80102463 <namex+0x72>
      iunlockput(ip);
8010244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102451:	89 04 24             	mov    %eax,(%esp)
80102454:	e8 76 f7 ff ff       	call   80101bcf <iunlockput>
      return 0;
80102459:	b8 00 00 00 00       	mov    $0x0,%eax
8010245e:	e9 a3 00 00 00       	jmp    80102506 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
80102463:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102467:	74 1d                	je     80102486 <namex+0x95>
80102469:	8b 45 08             	mov    0x8(%ebp),%eax
8010246c:	0f b6 00             	movzbl (%eax),%eax
8010246f:	84 c0                	test   %al,%al
80102471:	75 13                	jne    80102486 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
80102473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102476:	89 04 24             	mov    %eax,(%esp)
80102479:	e8 79 f6 ff ff       	call   80101af7 <iunlock>
      return ip;
8010247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102481:	e9 80 00 00 00       	jmp    80102506 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102486:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010248d:	00 
8010248e:	8b 45 10             	mov    0x10(%ebp),%eax
80102491:	89 44 24 04          	mov    %eax,0x4(%esp)
80102495:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102498:	89 04 24             	mov    %eax,(%esp)
8010249b:	e8 df fc ff ff       	call   8010217f <dirlookup>
801024a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024a7:	75 12                	jne    801024bb <namex+0xca>
      iunlockput(ip);
801024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024ac:	89 04 24             	mov    %eax,(%esp)
801024af:	e8 1b f7 ff ff       	call   80101bcf <iunlockput>
      return 0;
801024b4:	b8 00 00 00 00       	mov    $0x0,%eax
801024b9:	eb 4b                	jmp    80102506 <namex+0x115>
    }
    iunlockput(ip);
801024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024be:	89 04 24             	mov    %eax,(%esp)
801024c1:	e8 09 f7 ff ff       	call   80101bcf <iunlockput>
    ip = next;
801024c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801024cc:	8b 45 10             	mov    0x10(%ebp),%eax
801024cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801024d3:	8b 45 08             	mov    0x8(%ebp),%eax
801024d6:	89 04 24             	mov    %eax,(%esp)
801024d9:	e8 61 fe ff ff       	call   8010233f <skipelem>
801024de:	89 45 08             	mov    %eax,0x8(%ebp)
801024e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024e5:	0f 85 4b ff ff ff    	jne    80102436 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801024eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024ef:	74 12                	je     80102503 <namex+0x112>
    iput(ip);
801024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024f4:	89 04 24             	mov    %eax,(%esp)
801024f7:	e8 3f f6 ff ff       	call   80101b3b <iput>
    return 0;
801024fc:	b8 00 00 00 00       	mov    $0x0,%eax
80102501:	eb 03                	jmp    80102506 <namex+0x115>
  }
  return ip;
80102503:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102506:	c9                   	leave  
80102507:	c3                   	ret    

80102508 <namei>:

struct inode*
namei(char *path)
{
80102508:	55                   	push   %ebp
80102509:	89 e5                	mov    %esp,%ebp
8010250b:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010250e:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102511:	89 44 24 08          	mov    %eax,0x8(%esp)
80102515:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010251c:	00 
8010251d:	8b 45 08             	mov    0x8(%ebp),%eax
80102520:	89 04 24             	mov    %eax,(%esp)
80102523:	e8 c9 fe ff ff       	call   801023f1 <namex>
}
80102528:	c9                   	leave  
80102529:	c3                   	ret    

8010252a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010252a:	55                   	push   %ebp
8010252b:	89 e5                	mov    %esp,%ebp
8010252d:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102530:	8b 45 0c             	mov    0xc(%ebp),%eax
80102533:	89 44 24 08          	mov    %eax,0x8(%esp)
80102537:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010253e:	00 
8010253f:	8b 45 08             	mov    0x8(%ebp),%eax
80102542:	89 04 24             	mov    %eax,(%esp)
80102545:	e8 a7 fe ff ff       	call   801023f1 <namex>
}
8010254a:	c9                   	leave  
8010254b:	c3                   	ret    

8010254c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010254c:	55                   	push   %ebp
8010254d:	89 e5                	mov    %esp,%ebp
8010254f:	83 ec 14             	sub    $0x14,%esp
80102552:	8b 45 08             	mov    0x8(%ebp),%eax
80102555:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102559:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010255d:	89 c2                	mov    %eax,%edx
8010255f:	ec                   	in     (%dx),%al
80102560:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102563:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102567:	c9                   	leave  
80102568:	c3                   	ret    

80102569 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102569:	55                   	push   %ebp
8010256a:	89 e5                	mov    %esp,%ebp
8010256c:	57                   	push   %edi
8010256d:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010256e:	8b 55 08             	mov    0x8(%ebp),%edx
80102571:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102574:	8b 45 10             	mov    0x10(%ebp),%eax
80102577:	89 cb                	mov    %ecx,%ebx
80102579:	89 df                	mov    %ebx,%edi
8010257b:	89 c1                	mov    %eax,%ecx
8010257d:	fc                   	cld    
8010257e:	f3 6d                	rep insl (%dx),%es:(%edi)
80102580:	89 c8                	mov    %ecx,%eax
80102582:	89 fb                	mov    %edi,%ebx
80102584:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102587:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010258a:	5b                   	pop    %ebx
8010258b:	5f                   	pop    %edi
8010258c:	5d                   	pop    %ebp
8010258d:	c3                   	ret    

8010258e <outb>:

static inline void
outb(ushort port, uchar data)
{
8010258e:	55                   	push   %ebp
8010258f:	89 e5                	mov    %esp,%ebp
80102591:	83 ec 08             	sub    $0x8,%esp
80102594:	8b 55 08             	mov    0x8(%ebp),%edx
80102597:	8b 45 0c             	mov    0xc(%ebp),%eax
8010259a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010259e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025a1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025a5:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025a9:	ee                   	out    %al,(%dx)
}
801025aa:	c9                   	leave  
801025ab:	c3                   	ret    

801025ac <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801025ac:	55                   	push   %ebp
801025ad:	89 e5                	mov    %esp,%ebp
801025af:	56                   	push   %esi
801025b0:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025b1:	8b 55 08             	mov    0x8(%ebp),%edx
801025b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025b7:	8b 45 10             	mov    0x10(%ebp),%eax
801025ba:	89 cb                	mov    %ecx,%ebx
801025bc:	89 de                	mov    %ebx,%esi
801025be:	89 c1                	mov    %eax,%ecx
801025c0:	fc                   	cld    
801025c1:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025c3:	89 c8                	mov    %ecx,%eax
801025c5:	89 f3                	mov    %esi,%ebx
801025c7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025ca:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801025cd:	5b                   	pop    %ebx
801025ce:	5e                   	pop    %esi
801025cf:	5d                   	pop    %ebp
801025d0:	c3                   	ret    

801025d1 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801025d1:	55                   	push   %ebp
801025d2:	89 e5                	mov    %esp,%ebp
801025d4:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025d7:	90                   	nop
801025d8:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025df:	e8 68 ff ff ff       	call   8010254c <inb>
801025e4:	0f b6 c0             	movzbl %al,%eax
801025e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
801025ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025ed:	25 c0 00 00 00       	and    $0xc0,%eax
801025f2:	83 f8 40             	cmp    $0x40,%eax
801025f5:	75 e1                	jne    801025d8 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025fb:	74 11                	je     8010260e <idewait+0x3d>
801025fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102600:	83 e0 21             	and    $0x21,%eax
80102603:	85 c0                	test   %eax,%eax
80102605:	74 07                	je     8010260e <idewait+0x3d>
    return -1;
80102607:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010260c:	eb 05                	jmp    80102613 <idewait+0x42>
  return 0;
8010260e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102613:	c9                   	leave  
80102614:	c3                   	ret    

80102615 <ideinit>:

void
ideinit(void)
{
80102615:	55                   	push   %ebp
80102616:	89 e5                	mov    %esp,%ebp
80102618:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010261b:	c7 44 24 04 84 9b 10 	movl   $0x80109b84,0x4(%esp)
80102622:	80 
80102623:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
8010262a:	e8 c0 3b 00 00       	call   801061ef <initlock>
  picenable(IRQ_IDE);
8010262f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102636:	e8 1e 18 00 00       	call   80103e59 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010263b:	a1 20 5e 11 80       	mov    0x80115e20,%eax
80102640:	83 e8 01             	sub    $0x1,%eax
80102643:	89 44 24 04          	mov    %eax,0x4(%esp)
80102647:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010264e:	e8 77 04 00 00       	call   80102aca <ioapicenable>
  idewait(0);
80102653:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010265a:	e8 72 ff ff ff       	call   801025d1 <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010265f:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102666:	00 
80102667:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010266e:	e8 1b ff ff ff       	call   8010258e <outb>
  for(i=0; i<1000; i++){
80102673:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010267a:	eb 20                	jmp    8010269c <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010267c:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102683:	e8 c4 fe ff ff       	call   8010254c <inb>
80102688:	84 c0                	test   %al,%al
8010268a:	74 0c                	je     80102698 <ideinit+0x83>
      havedisk1 = 1;
8010268c:	c7 05 58 d6 10 80 01 	movl   $0x1,0x8010d658
80102693:	00 00 00 
      break;
80102696:	eb 0d                	jmp    801026a5 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102698:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010269c:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026a3:	7e d7                	jle    8010267c <ideinit+0x67>
      break;
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026a5:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801026ac:	00 
801026ad:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026b4:	e8 d5 fe ff ff       	call   8010258e <outb>
}
801026b9:	c9                   	leave  
801026ba:	c3                   	ret    

801026bb <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026bb:	55                   	push   %ebp
801026bc:	89 e5                	mov    %esp,%ebp
801026be:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
801026c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026c5:	75 0c                	jne    801026d3 <idestart+0x18>
    panic("idestart");
801026c7:	c7 04 24 88 9b 10 80 	movl   $0x80109b88,(%esp)
801026ce:	e8 8f de ff ff       	call   80100562 <panic>
  if(b->blockno >= FSSIZE)
801026d3:	8b 45 08             	mov    0x8(%ebp),%eax
801026d6:	8b 40 08             	mov    0x8(%eax),%eax
801026d9:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801026de:	76 0c                	jbe    801026ec <idestart+0x31>
    panic("incorrect blockno");
801026e0:	c7 04 24 91 9b 10 80 	movl   $0x80109b91,(%esp)
801026e7:	e8 76 de ff ff       	call   80100562 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801026ec:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801026f3:	8b 45 08             	mov    0x8(%ebp),%eax
801026f6:	8b 50 08             	mov    0x8(%eax),%edx
801026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026fc:	0f af c2             	imul   %edx,%eax
801026ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
80102702:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102706:	75 07                	jne    8010270f <idestart+0x54>
80102708:	b8 20 00 00 00       	mov    $0x20,%eax
8010270d:	eb 05                	jmp    80102714 <idestart+0x59>
8010270f:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102714:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102717:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010271b:	75 07                	jne    80102724 <idestart+0x69>
8010271d:	b8 30 00 00 00       	mov    $0x30,%eax
80102722:	eb 05                	jmp    80102729 <idestart+0x6e>
80102724:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102729:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
8010272c:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102730:	7e 0c                	jle    8010273e <idestart+0x83>
80102732:	c7 04 24 88 9b 10 80 	movl   $0x80109b88,(%esp)
80102739:	e8 24 de ff ff       	call   80100562 <panic>

  idewait(0);
8010273e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102745:	e8 87 fe ff ff       	call   801025d1 <idewait>
  outb(0x3f6, 0);  // generate interrupt
8010274a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102751:	00 
80102752:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102759:	e8 30 fe ff ff       	call   8010258e <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
8010275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102761:	0f b6 c0             	movzbl %al,%eax
80102764:	89 44 24 04          	mov    %eax,0x4(%esp)
80102768:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
8010276f:	e8 1a fe ff ff       	call   8010258e <outb>
  outb(0x1f3, sector & 0xff);
80102774:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102777:	0f b6 c0             	movzbl %al,%eax
8010277a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010277e:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102785:	e8 04 fe ff ff       	call   8010258e <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
8010278a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010278d:	c1 f8 08             	sar    $0x8,%eax
80102790:	0f b6 c0             	movzbl %al,%eax
80102793:	89 44 24 04          	mov    %eax,0x4(%esp)
80102797:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010279e:	e8 eb fd ff ff       	call   8010258e <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
801027a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027a6:	c1 f8 10             	sar    $0x10,%eax
801027a9:	0f b6 c0             	movzbl %al,%eax
801027ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801027b0:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
801027b7:	e8 d2 fd ff ff       	call   8010258e <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027bc:	8b 45 08             	mov    0x8(%ebp),%eax
801027bf:	8b 40 04             	mov    0x4(%eax),%eax
801027c2:	83 e0 01             	and    $0x1,%eax
801027c5:	c1 e0 04             	shl    $0x4,%eax
801027c8:	89 c2                	mov    %eax,%edx
801027ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027cd:	c1 f8 18             	sar    $0x18,%eax
801027d0:	83 e0 0f             	and    $0xf,%eax
801027d3:	09 d0                	or     %edx,%eax
801027d5:	83 c8 e0             	or     $0xffffffe0,%eax
801027d8:	0f b6 c0             	movzbl %al,%eax
801027db:	89 44 24 04          	mov    %eax,0x4(%esp)
801027df:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801027e6:	e8 a3 fd ff ff       	call   8010258e <outb>
  if(b->flags & B_DIRTY){
801027eb:	8b 45 08             	mov    0x8(%ebp),%eax
801027ee:	8b 00                	mov    (%eax),%eax
801027f0:	83 e0 04             	and    $0x4,%eax
801027f3:	85 c0                	test   %eax,%eax
801027f5:	74 36                	je     8010282d <idestart+0x172>
    outb(0x1f7, write_cmd);
801027f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801027fa:	0f b6 c0             	movzbl %al,%eax
801027fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102801:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102808:	e8 81 fd ff ff       	call   8010258e <outb>
    outsl(0x1f0, b->data, BSIZE/4);
8010280d:	8b 45 08             	mov    0x8(%ebp),%eax
80102810:	83 c0 5c             	add    $0x5c,%eax
80102813:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010281a:	00 
8010281b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010281f:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102826:	e8 81 fd ff ff       	call   801025ac <outsl>
8010282b:	eb 16                	jmp    80102843 <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
8010282d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102830:	0f b6 c0             	movzbl %al,%eax
80102833:	89 44 24 04          	mov    %eax,0x4(%esp)
80102837:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010283e:	e8 4b fd ff ff       	call   8010258e <outb>
  }
}
80102843:	c9                   	leave  
80102844:	c3                   	ret    

80102845 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102845:	55                   	push   %ebp
80102846:	89 e5                	mov    %esp,%ebp
80102848:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010284b:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
80102852:	e8 b9 39 00 00       	call   80106210 <acquire>
  if((b = idequeue) == 0){
80102857:	a1 54 d6 10 80       	mov    0x8010d654,%eax
8010285c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010285f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102863:	75 11                	jne    80102876 <ideintr+0x31>
    release(&idelock);
80102865:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
8010286c:	e8 06 3a 00 00       	call   80106277 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102871:	e9 90 00 00 00       	jmp    80102906 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102879:	8b 40 58             	mov    0x58(%eax),%eax
8010287c:	a3 54 d6 10 80       	mov    %eax,0x8010d654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102884:	8b 00                	mov    (%eax),%eax
80102886:	83 e0 04             	and    $0x4,%eax
80102889:	85 c0                	test   %eax,%eax
8010288b:	75 2e                	jne    801028bb <ideintr+0x76>
8010288d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102894:	e8 38 fd ff ff       	call   801025d1 <idewait>
80102899:	85 c0                	test   %eax,%eax
8010289b:	78 1e                	js     801028bb <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
8010289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028a0:	83 c0 5c             	add    $0x5c,%eax
801028a3:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801028aa:	00 
801028ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801028af:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801028b6:	e8 ae fc ff ff       	call   80102569 <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028be:	8b 00                	mov    (%eax),%eax
801028c0:	83 c8 02             	or     $0x2,%eax
801028c3:	89 c2                	mov    %eax,%edx
801028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028c8:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028cd:	8b 00                	mov    (%eax),%eax
801028cf:	83 e0 fb             	and    $0xfffffffb,%eax
801028d2:	89 c2                	mov    %eax,%edx
801028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d7:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028dc:	89 04 24             	mov    %eax,(%esp)
801028df:	e8 38 2e 00 00       	call   8010571c <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801028e4:	a1 54 d6 10 80       	mov    0x8010d654,%eax
801028e9:	85 c0                	test   %eax,%eax
801028eb:	74 0d                	je     801028fa <ideintr+0xb5>
    idestart(idequeue);
801028ed:	a1 54 d6 10 80       	mov    0x8010d654,%eax
801028f2:	89 04 24             	mov    %eax,(%esp)
801028f5:	e8 c1 fd ff ff       	call   801026bb <idestart>

  release(&idelock);
801028fa:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
80102901:	e8 71 39 00 00       	call   80106277 <release>
}
80102906:	c9                   	leave  
80102907:	c3                   	ret    

80102908 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102908:	55                   	push   %ebp
80102909:	89 e5                	mov    %esp,%ebp
8010290b:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010290e:	8b 45 08             	mov    0x8(%ebp),%eax
80102911:	83 c0 0c             	add    $0xc,%eax
80102914:	89 04 24             	mov    %eax,(%esp)
80102917:	e8 6e 38 00 00       	call   8010618a <holdingsleep>
8010291c:	85 c0                	test   %eax,%eax
8010291e:	75 0c                	jne    8010292c <iderw+0x24>
    panic("iderw: buf not locked");
80102920:	c7 04 24 a3 9b 10 80 	movl   $0x80109ba3,(%esp)
80102927:	e8 36 dc ff ff       	call   80100562 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010292c:	8b 45 08             	mov    0x8(%ebp),%eax
8010292f:	8b 00                	mov    (%eax),%eax
80102931:	83 e0 06             	and    $0x6,%eax
80102934:	83 f8 02             	cmp    $0x2,%eax
80102937:	75 0c                	jne    80102945 <iderw+0x3d>
    panic("iderw: nothing to do");
80102939:	c7 04 24 b9 9b 10 80 	movl   $0x80109bb9,(%esp)
80102940:	e8 1d dc ff ff       	call   80100562 <panic>
  if(b->dev != 0 && !havedisk1)
80102945:	8b 45 08             	mov    0x8(%ebp),%eax
80102948:	8b 40 04             	mov    0x4(%eax),%eax
8010294b:	85 c0                	test   %eax,%eax
8010294d:	74 15                	je     80102964 <iderw+0x5c>
8010294f:	a1 58 d6 10 80       	mov    0x8010d658,%eax
80102954:	85 c0                	test   %eax,%eax
80102956:	75 0c                	jne    80102964 <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
80102958:	c7 04 24 ce 9b 10 80 	movl   $0x80109bce,(%esp)
8010295f:	e8 fe db ff ff       	call   80100562 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102964:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
8010296b:	e8 a0 38 00 00       	call   80106210 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102970:	8b 45 08             	mov    0x8(%ebp),%eax
80102973:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010297a:	c7 45 f4 54 d6 10 80 	movl   $0x8010d654,-0xc(%ebp)
80102981:	eb 0b                	jmp    8010298e <iderw+0x86>
80102983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102986:	8b 00                	mov    (%eax),%eax
80102988:	83 c0 58             	add    $0x58,%eax
8010298b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102991:	8b 00                	mov    (%eax),%eax
80102993:	85 c0                	test   %eax,%eax
80102995:	75 ec                	jne    80102983 <iderw+0x7b>
    ;
  *pp = b;
80102997:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010299a:	8b 55 08             	mov    0x8(%ebp),%edx
8010299d:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010299f:	a1 54 d6 10 80       	mov    0x8010d654,%eax
801029a4:	3b 45 08             	cmp    0x8(%ebp),%eax
801029a7:	75 0d                	jne    801029b6 <iderw+0xae>
    idestart(b);
801029a9:	8b 45 08             	mov    0x8(%ebp),%eax
801029ac:	89 04 24             	mov    %eax,(%esp)
801029af:	e8 07 fd ff ff       	call   801026bb <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029b4:	eb 15                	jmp    801029cb <iderw+0xc3>
801029b6:	eb 13                	jmp    801029cb <iderw+0xc3>
    sleep(b, &idelock);
801029b8:	c7 44 24 04 20 d6 10 	movl   $0x8010d620,0x4(%esp)
801029bf:	80 
801029c0:	8b 45 08             	mov    0x8(%ebp),%eax
801029c3:	89 04 24             	mov    %eax,(%esp)
801029c6:	e8 75 2c 00 00       	call   80105640 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029cb:	8b 45 08             	mov    0x8(%ebp),%eax
801029ce:	8b 00                	mov    (%eax),%eax
801029d0:	83 e0 06             	and    $0x6,%eax
801029d3:	83 f8 02             	cmp    $0x2,%eax
801029d6:	75 e0                	jne    801029b8 <iderw+0xb0>
    sleep(b, &idelock);
  }

  release(&idelock);
801029d8:	c7 04 24 20 d6 10 80 	movl   $0x8010d620,(%esp)
801029df:	e8 93 38 00 00       	call   80106277 <release>
}
801029e4:	c9                   	leave  
801029e5:	c3                   	ret    

801029e6 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801029e6:	55                   	push   %ebp
801029e7:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029e9:	a1 f4 56 11 80       	mov    0x801156f4,%eax
801029ee:	8b 55 08             	mov    0x8(%ebp),%edx
801029f1:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801029f3:	a1 f4 56 11 80       	mov    0x801156f4,%eax
801029f8:	8b 40 10             	mov    0x10(%eax),%eax
}
801029fb:	5d                   	pop    %ebp
801029fc:	c3                   	ret    

801029fd <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801029fd:	55                   	push   %ebp
801029fe:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a00:	a1 f4 56 11 80       	mov    0x801156f4,%eax
80102a05:	8b 55 08             	mov    0x8(%ebp),%edx
80102a08:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a0a:	a1 f4 56 11 80       	mov    0x801156f4,%eax
80102a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a12:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a15:	5d                   	pop    %ebp
80102a16:	c3                   	ret    

80102a17 <ioapicinit>:

void
ioapicinit(void)
{
80102a17:	55                   	push   %ebp
80102a18:	89 e5                	mov    %esp,%ebp
80102a1a:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102a1d:	a1 24 58 11 80       	mov    0x80115824,%eax
80102a22:	85 c0                	test   %eax,%eax
80102a24:	75 05                	jne    80102a2b <ioapicinit+0x14>
    return;
80102a26:	e9 9d 00 00 00       	jmp    80102ac8 <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a2b:	c7 05 f4 56 11 80 00 	movl   $0xfec00000,0x801156f4
80102a32:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102a3c:	e8 a5 ff ff ff       	call   801029e6 <ioapicread>
80102a41:	c1 e8 10             	shr    $0x10,%eax
80102a44:	25 ff 00 00 00       	and    $0xff,%eax
80102a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102a53:	e8 8e ff ff ff       	call   801029e6 <ioapicread>
80102a58:	c1 e8 18             	shr    $0x18,%eax
80102a5b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a5e:	0f b6 05 20 58 11 80 	movzbl 0x80115820,%eax
80102a65:	0f b6 c0             	movzbl %al,%eax
80102a68:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a6b:	74 0c                	je     80102a79 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a6d:	c7 04 24 ec 9b 10 80 	movl   $0x80109bec,(%esp)
80102a74:	e8 4f d9 ff ff       	call   801003c8 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a80:	eb 3e                	jmp    80102ac0 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a85:	83 c0 20             	add    $0x20,%eax
80102a88:	0d 00 00 01 00       	or     $0x10000,%eax
80102a8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102a90:	83 c2 08             	add    $0x8,%edx
80102a93:	01 d2                	add    %edx,%edx
80102a95:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a99:	89 14 24             	mov    %edx,(%esp)
80102a9c:	e8 5c ff ff ff       	call   801029fd <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa4:	83 c0 08             	add    $0x8,%eax
80102aa7:	01 c0                	add    %eax,%eax
80102aa9:	83 c0 01             	add    $0x1,%eax
80102aac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ab3:	00 
80102ab4:	89 04 24             	mov    %eax,(%esp)
80102ab7:	e8 41 ff ff ff       	call   801029fd <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102abc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102ac6:	7e ba                	jle    80102a82 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102ac8:	c9                   	leave  
80102ac9:	c3                   	ret    

80102aca <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102aca:	55                   	push   %ebp
80102acb:	89 e5                	mov    %esp,%ebp
80102acd:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102ad0:	a1 24 58 11 80       	mov    0x80115824,%eax
80102ad5:	85 c0                	test   %eax,%eax
80102ad7:	75 02                	jne    80102adb <ioapicenable+0x11>
    return;
80102ad9:	eb 37                	jmp    80102b12 <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102adb:	8b 45 08             	mov    0x8(%ebp),%eax
80102ade:	83 c0 20             	add    $0x20,%eax
80102ae1:	8b 55 08             	mov    0x8(%ebp),%edx
80102ae4:	83 c2 08             	add    $0x8,%edx
80102ae7:	01 d2                	add    %edx,%edx
80102ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aed:	89 14 24             	mov    %edx,(%esp)
80102af0:	e8 08 ff ff ff       	call   801029fd <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102af5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102af8:	c1 e0 18             	shl    $0x18,%eax
80102afb:	8b 55 08             	mov    0x8(%ebp),%edx
80102afe:	83 c2 08             	add    $0x8,%edx
80102b01:	01 d2                	add    %edx,%edx
80102b03:	83 c2 01             	add    $0x1,%edx
80102b06:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b0a:	89 14 24             	mov    %edx,(%esp)
80102b0d:	e8 eb fe ff ff       	call   801029fd <ioapicwrite>
}
80102b12:	c9                   	leave  
80102b13:	c3                   	ret    

80102b14 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b14:	55                   	push   %ebp
80102b15:	89 e5                	mov    %esp,%ebp
80102b17:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102b1a:	c7 44 24 04 1e 9c 10 	movl   $0x80109c1e,0x4(%esp)
80102b21:	80 
80102b22:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
80102b29:	e8 c1 36 00 00       	call   801061ef <initlock>
  kmem.use_lock = 0;
80102b2e:	c7 05 34 57 11 80 00 	movl   $0x0,0x80115734
80102b35:	00 00 00 
  freerange(vstart, vend);
80102b38:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b3f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b42:	89 04 24             	mov    %eax,(%esp)
80102b45:	e8 26 00 00 00       	call   80102b70 <freerange>
}
80102b4a:	c9                   	leave  
80102b4b:	c3                   	ret    

80102b4c <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b4c:	55                   	push   %ebp
80102b4d:	89 e5                	mov    %esp,%ebp
80102b4f:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102b52:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b55:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b59:	8b 45 08             	mov    0x8(%ebp),%eax
80102b5c:	89 04 24             	mov    %eax,(%esp)
80102b5f:	e8 0c 00 00 00       	call   80102b70 <freerange>
  kmem.use_lock = 1;
80102b64:	c7 05 34 57 11 80 01 	movl   $0x1,0x80115734
80102b6b:	00 00 00 
}
80102b6e:	c9                   	leave  
80102b6f:	c3                   	ret    

80102b70 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b76:	8b 45 08             	mov    0x8(%ebp),%eax
80102b79:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b7e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b86:	eb 12                	jmp    80102b9a <freerange+0x2a>
    kfree(p);
80102b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b8b:	89 04 24             	mov    %eax,(%esp)
80102b8e:	e8 16 00 00 00       	call   80102ba9 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b93:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b9d:	05 00 10 00 00       	add    $0x1000,%eax
80102ba2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102ba5:	76 e1                	jbe    80102b88 <freerange+0x18>
    kfree(p);
}
80102ba7:	c9                   	leave  
80102ba8:	c3                   	ret    

80102ba9 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ba9:	55                   	push   %ebp
80102baa:	89 e5                	mov    %esp,%ebp
80102bac:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102baf:	8b 45 08             	mov    0x8(%ebp),%eax
80102bb2:	25 ff 0f 00 00       	and    $0xfff,%eax
80102bb7:	85 c0                	test   %eax,%eax
80102bb9:	75 18                	jne    80102bd3 <kfree+0x2a>
80102bbb:	81 7d 08 68 90 11 80 	cmpl   $0x80119068,0x8(%ebp)
80102bc2:	72 0f                	jb     80102bd3 <kfree+0x2a>
80102bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80102bc7:	05 00 00 00 80       	add    $0x80000000,%eax
80102bcc:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bd1:	76 0c                	jbe    80102bdf <kfree+0x36>
    panic("kfree");
80102bd3:	c7 04 24 23 9c 10 80 	movl   $0x80109c23,(%esp)
80102bda:	e8 83 d9 ff ff       	call   80100562 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bdf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102be6:	00 
80102be7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102bee:	00 
80102bef:	8b 45 08             	mov    0x8(%ebp),%eax
80102bf2:	89 04 24             	mov    %eax,(%esp)
80102bf5:	e8 7f 38 00 00       	call   80106479 <memset>

  if(kmem.use_lock)
80102bfa:	a1 34 57 11 80       	mov    0x80115734,%eax
80102bff:	85 c0                	test   %eax,%eax
80102c01:	74 0c                	je     80102c0f <kfree+0x66>
    acquire(&kmem.lock);
80102c03:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
80102c0a:	e8 01 36 00 00       	call   80106210 <acquire>
  r = (struct run*)v;
80102c0f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c15:	8b 15 38 57 11 80    	mov    0x80115738,%edx
80102c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c1e:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c23:	a3 38 57 11 80       	mov    %eax,0x80115738
  if(kmem.use_lock)
80102c28:	a1 34 57 11 80       	mov    0x80115734,%eax
80102c2d:	85 c0                	test   %eax,%eax
80102c2f:	74 0c                	je     80102c3d <kfree+0x94>
    release(&kmem.lock);
80102c31:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
80102c38:	e8 3a 36 00 00       	call   80106277 <release>
}
80102c3d:	c9                   	leave  
80102c3e:	c3                   	ret    

80102c3f <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c3f:	55                   	push   %ebp
80102c40:	89 e5                	mov    %esp,%ebp
80102c42:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102c45:	a1 34 57 11 80       	mov    0x80115734,%eax
80102c4a:	85 c0                	test   %eax,%eax
80102c4c:	74 0c                	je     80102c5a <kalloc+0x1b>
    acquire(&kmem.lock);
80102c4e:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
80102c55:	e8 b6 35 00 00       	call   80106210 <acquire>
  r = kmem.freelist;
80102c5a:	a1 38 57 11 80       	mov    0x80115738,%eax
80102c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c66:	74 0a                	je     80102c72 <kalloc+0x33>
    kmem.freelist = r->next;
80102c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6b:	8b 00                	mov    (%eax),%eax
80102c6d:	a3 38 57 11 80       	mov    %eax,0x80115738
  if(kmem.use_lock)
80102c72:	a1 34 57 11 80       	mov    0x80115734,%eax
80102c77:	85 c0                	test   %eax,%eax
80102c79:	74 0c                	je     80102c87 <kalloc+0x48>
    release(&kmem.lock);
80102c7b:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)
80102c82:	e8 f0 35 00 00       	call   80106277 <release>
  if(r == 0) {
    cprintf("(kalloc) error: kernel memory is full.\n");
  }
#endif

  return (char*)r;
80102c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c8a:	c9                   	leave  
80102c8b:	c3                   	ret    

80102c8c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c8c:	55                   	push   %ebp
80102c8d:	89 e5                	mov    %esp,%ebp
80102c8f:	83 ec 14             	sub    $0x14,%esp
80102c92:	8b 45 08             	mov    0x8(%ebp),%eax
80102c95:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c99:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c9d:	89 c2                	mov    %eax,%edx
80102c9f:	ec                   	in     (%dx),%al
80102ca0:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ca3:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ca7:	c9                   	leave  
80102ca8:	c3                   	ret    

80102ca9 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102ca9:	55                   	push   %ebp
80102caa:	89 e5                	mov    %esp,%ebp
80102cac:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102caf:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102cb6:	e8 d1 ff ff ff       	call   80102c8c <inb>
80102cbb:	0f b6 c0             	movzbl %al,%eax
80102cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc4:	83 e0 01             	and    $0x1,%eax
80102cc7:	85 c0                	test   %eax,%eax
80102cc9:	75 0a                	jne    80102cd5 <kbdgetc+0x2c>
    return -1;
80102ccb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102cd0:	e9 25 01 00 00       	jmp    80102dfa <kbdgetc+0x151>
  data = inb(KBDATAP);
80102cd5:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102cdc:	e8 ab ff ff ff       	call   80102c8c <inb>
80102ce1:	0f b6 c0             	movzbl %al,%eax
80102ce4:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102ce7:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102cee:	75 17                	jne    80102d07 <kbdgetc+0x5e>
    shift |= E0ESC;
80102cf0:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102cf5:	83 c8 40             	or     $0x40,%eax
80102cf8:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102cfd:	b8 00 00 00 00       	mov    $0x0,%eax
80102d02:	e9 f3 00 00 00       	jmp    80102dfa <kbdgetc+0x151>
  } else if(data & 0x80){
80102d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d0a:	25 80 00 00 00       	and    $0x80,%eax
80102d0f:	85 c0                	test   %eax,%eax
80102d11:	74 45                	je     80102d58 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d13:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102d18:	83 e0 40             	and    $0x40,%eax
80102d1b:	85 c0                	test   %eax,%eax
80102d1d:	75 08                	jne    80102d27 <kbdgetc+0x7e>
80102d1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d22:	83 e0 7f             	and    $0x7f,%eax
80102d25:	eb 03                	jmp    80102d2a <kbdgetc+0x81>
80102d27:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d30:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102d35:	0f b6 00             	movzbl (%eax),%eax
80102d38:	83 c8 40             	or     $0x40,%eax
80102d3b:	0f b6 c0             	movzbl %al,%eax
80102d3e:	f7 d0                	not    %eax
80102d40:	89 c2                	mov    %eax,%edx
80102d42:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102d47:	21 d0                	and    %edx,%eax
80102d49:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102d4e:	b8 00 00 00 00       	mov    $0x0,%eax
80102d53:	e9 a2 00 00 00       	jmp    80102dfa <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102d58:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102d5d:	83 e0 40             	and    $0x40,%eax
80102d60:	85 c0                	test   %eax,%eax
80102d62:	74 14                	je     80102d78 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d64:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d6b:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102d70:	83 e0 bf             	and    $0xffffffbf,%eax
80102d73:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  }

  shift |= shiftcode[data];
80102d78:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d7b:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102d80:	0f b6 00             	movzbl (%eax),%eax
80102d83:	0f b6 d0             	movzbl %al,%edx
80102d86:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102d8b:	09 d0                	or     %edx,%eax
80102d8d:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  shift ^= togglecode[data];
80102d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d95:	05 20 b1 10 80       	add    $0x8010b120,%eax
80102d9a:	0f b6 00             	movzbl (%eax),%eax
80102d9d:	0f b6 d0             	movzbl %al,%edx
80102da0:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102da5:	31 d0                	xor    %edx,%eax
80102da7:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102dac:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102db1:	83 e0 03             	and    $0x3,%eax
80102db4:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80102dbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dbe:	01 d0                	add    %edx,%eax
80102dc0:	0f b6 00             	movzbl (%eax),%eax
80102dc3:	0f b6 c0             	movzbl %al,%eax
80102dc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102dc9:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102dce:	83 e0 08             	and    $0x8,%eax
80102dd1:	85 c0                	test   %eax,%eax
80102dd3:	74 22                	je     80102df7 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102dd5:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102dd9:	76 0c                	jbe    80102de7 <kbdgetc+0x13e>
80102ddb:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102ddf:	77 06                	ja     80102de7 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102de1:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102de5:	eb 10                	jmp    80102df7 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102de7:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102deb:	76 0a                	jbe    80102df7 <kbdgetc+0x14e>
80102ded:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102df1:	77 04                	ja     80102df7 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102df3:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102dfa:	c9                   	leave  
80102dfb:	c3                   	ret    

80102dfc <kbdintr>:

void
kbdintr(void)
{
80102dfc:	55                   	push   %ebp
80102dfd:	89 e5                	mov    %esp,%ebp
80102dff:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102e02:	c7 04 24 a9 2c 10 80 	movl   $0x80102ca9,(%esp)
80102e09:	e8 e2 d9 ff ff       	call   801007f0 <consoleintr>
}
80102e0e:	c9                   	leave  
80102e0f:	c3                   	ret    

80102e10 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	83 ec 14             	sub    $0x14,%esp
80102e16:	8b 45 08             	mov    0x8(%ebp),%eax
80102e19:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e1d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e21:	89 c2                	mov    %eax,%edx
80102e23:	ec                   	in     (%dx),%al
80102e24:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e27:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e2b:	c9                   	leave  
80102e2c:	c3                   	ret    

80102e2d <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102e2d:	55                   	push   %ebp
80102e2e:	89 e5                	mov    %esp,%ebp
80102e30:	83 ec 08             	sub    $0x8,%esp
80102e33:	8b 55 08             	mov    0x8(%ebp),%edx
80102e36:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e39:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102e3d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e40:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e44:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e48:	ee                   	out    %al,(%dx)
}
80102e49:	c9                   	leave  
80102e4a:	c3                   	ret    

80102e4b <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102e4b:	55                   	push   %ebp
80102e4c:	89 e5                	mov    %esp,%ebp
80102e4e:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e51:	9c                   	pushf  
80102e52:	58                   	pop    %eax
80102e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102e59:	c9                   	leave  
80102e5a:	c3                   	ret    

80102e5b <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e5b:	55                   	push   %ebp
80102e5c:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e5e:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80102e63:	8b 55 08             	mov    0x8(%ebp),%edx
80102e66:	c1 e2 02             	shl    $0x2,%edx
80102e69:	01 c2                	add    %eax,%edx
80102e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e6e:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e70:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80102e75:	83 c0 20             	add    $0x20,%eax
80102e78:	8b 00                	mov    (%eax),%eax
}
80102e7a:	5d                   	pop    %ebp
80102e7b:	c3                   	ret    

80102e7c <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e7c:	55                   	push   %ebp
80102e7d:	89 e5                	mov    %esp,%ebp
80102e7f:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80102e82:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80102e87:	85 c0                	test   %eax,%eax
80102e89:	75 05                	jne    80102e90 <lapicinit+0x14>
    return;
80102e8b:	e9 43 01 00 00       	jmp    80102fd3 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e90:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102e97:	00 
80102e98:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102e9f:	e8 b7 ff ff ff       	call   80102e5b <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102ea4:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102eab:	00 
80102eac:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102eb3:	e8 a3 ff ff ff       	call   80102e5b <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102eb8:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102ebf:	00 
80102ec0:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102ec7:	e8 8f ff ff ff       	call   80102e5b <lapicw>
  lapicw(TICR, 10000000);
80102ecc:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102ed3:	00 
80102ed4:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102edb:	e8 7b ff ff ff       	call   80102e5b <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102ee0:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102ee7:	00 
80102ee8:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102eef:	e8 67 ff ff ff       	call   80102e5b <lapicw>
  lapicw(LINT1, MASKED);
80102ef4:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102efb:	00 
80102efc:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102f03:	e8 53 ff ff ff       	call   80102e5b <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f08:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80102f0d:	83 c0 30             	add    $0x30,%eax
80102f10:	8b 00                	mov    (%eax),%eax
80102f12:	c1 e8 10             	shr    $0x10,%eax
80102f15:	0f b6 c0             	movzbl %al,%eax
80102f18:	83 f8 03             	cmp    $0x3,%eax
80102f1b:	76 14                	jbe    80102f31 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102f1d:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102f24:	00 
80102f25:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102f2c:	e8 2a ff ff ff       	call   80102e5b <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f31:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102f38:	00 
80102f39:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102f40:	e8 16 ff ff ff       	call   80102e5b <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f4c:	00 
80102f4d:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102f54:	e8 02 ff ff ff       	call   80102e5b <lapicw>
  lapicw(ESR, 0);
80102f59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f60:	00 
80102f61:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102f68:	e8 ee fe ff ff       	call   80102e5b <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f6d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f74:	00 
80102f75:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f7c:	e8 da fe ff ff       	call   80102e5b <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f81:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f88:	00 
80102f89:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f90:	e8 c6 fe ff ff       	call   80102e5b <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f95:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102f9c:	00 
80102f9d:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fa4:	e8 b2 fe ff ff       	call   80102e5b <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102fa9:	90                   	nop
80102faa:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80102faf:	05 00 03 00 00       	add    $0x300,%eax
80102fb4:	8b 00                	mov    (%eax),%eax
80102fb6:	25 00 10 00 00       	and    $0x1000,%eax
80102fbb:	85 c0                	test   %eax,%eax
80102fbd:	75 eb                	jne    80102faa <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102fbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102fc6:	00 
80102fc7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102fce:	e8 88 fe ff ff       	call   80102e5b <lapicw>
}
80102fd3:	c9                   	leave  
80102fd4:	c3                   	ret    

80102fd5 <cpunum>:

int
cpunum(void)
{
80102fd5:	55                   	push   %ebp
80102fd6:	89 e5                	mov    %esp,%ebp
80102fd8:	83 ec 28             	sub    $0x28,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102fdb:	e8 6b fe ff ff       	call   80102e4b <readeflags>
80102fe0:	25 00 02 00 00       	and    $0x200,%eax
80102fe5:	85 c0                	test   %eax,%eax
80102fe7:	74 25                	je     8010300e <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102fe9:	a1 60 d6 10 80       	mov    0x8010d660,%eax
80102fee:	8d 50 01             	lea    0x1(%eax),%edx
80102ff1:	89 15 60 d6 10 80    	mov    %edx,0x8010d660
80102ff7:	85 c0                	test   %eax,%eax
80102ff9:	75 13                	jne    8010300e <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ffb:	8b 45 04             	mov    0x4(%ebp),%eax
80102ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
80103002:	c7 04 24 2c 9c 10 80 	movl   $0x80109c2c,(%esp)
80103009:	e8 ba d3 ff ff       	call   801003c8 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010300e:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80103013:	85 c0                	test   %eax,%eax
80103015:	75 07                	jne    8010301e <cpunum+0x49>
    return 0;
80103017:	b8 00 00 00 00       	mov    $0x0,%eax
8010301c:	eb 51                	jmp    8010306f <cpunum+0x9a>

  apicid = lapic[ID] >> 24;
8010301e:	a1 3c 57 11 80       	mov    0x8011573c,%eax
80103023:	83 c0 20             	add    $0x20,%eax
80103026:	8b 00                	mov    (%eax),%eax
80103028:	c1 e8 18             	shr    $0x18,%eax
8010302b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < ncpu; ++i) {
8010302e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103035:	eb 22                	jmp    80103059 <cpunum+0x84>
    if (cpus[i].apicid == apicid)
80103037:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010303a:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103040:	05 40 58 11 80       	add    $0x80115840,%eax
80103045:	0f b6 00             	movzbl (%eax),%eax
80103048:	0f b6 c0             	movzbl %al,%eax
8010304b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010304e:	75 05                	jne    80103055 <cpunum+0x80>
      return i;
80103050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103053:	eb 1a                	jmp    8010306f <cpunum+0x9a>

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
80103055:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103059:	a1 20 5e 11 80       	mov    0x80115e20,%eax
8010305e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103061:	7c d4                	jl     80103037 <cpunum+0x62>
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80103063:	c7 04 24 58 9c 10 80 	movl   $0x80109c58,(%esp)
8010306a:	e8 f3 d4 ff ff       	call   80100562 <panic>
}
8010306f:	c9                   	leave  
80103070:	c3                   	ret    

80103071 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103071:	55                   	push   %ebp
80103072:	89 e5                	mov    %esp,%ebp
80103074:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80103077:	a1 3c 57 11 80       	mov    0x8011573c,%eax
8010307c:	85 c0                	test   %eax,%eax
8010307e:	74 14                	je     80103094 <lapiceoi+0x23>
    lapicw(EOI, 0);
80103080:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103087:	00 
80103088:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
8010308f:	e8 c7 fd ff ff       	call   80102e5b <lapicw>
}
80103094:	c9                   	leave  
80103095:	c3                   	ret    

80103096 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103096:	55                   	push   %ebp
80103097:	89 e5                	mov    %esp,%ebp
}
80103099:	5d                   	pop    %ebp
8010309a:	c3                   	ret    

8010309b <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010309b:	55                   	push   %ebp
8010309c:	89 e5                	mov    %esp,%ebp
8010309e:	83 ec 1c             	sub    $0x1c,%esp
801030a1:	8b 45 08             	mov    0x8(%ebp),%eax
801030a4:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801030a7:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801030ae:	00 
801030af:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801030b6:	e8 72 fd ff ff       	call   80102e2d <outb>
  outb(CMOS_PORT+1, 0x0A);
801030bb:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
801030c2:	00 
801030c3:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801030ca:	e8 5e fd ff ff       	call   80102e2d <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801030cf:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801030d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030d9:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801030de:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030e1:	8d 50 02             	lea    0x2(%eax),%edx
801030e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801030e7:	c1 e8 04             	shr    $0x4,%eax
801030ea:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801030ed:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030f1:	c1 e0 18             	shl    $0x18,%eax
801030f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801030f8:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
801030ff:	e8 57 fd ff ff       	call   80102e5b <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103104:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
8010310b:	00 
8010310c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103113:	e8 43 fd ff ff       	call   80102e5b <lapicw>
  microdelay(200);
80103118:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010311f:	e8 72 ff ff ff       	call   80103096 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103124:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
8010312b:	00 
8010312c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103133:	e8 23 fd ff ff       	call   80102e5b <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103138:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010313f:	e8 52 ff ff ff       	call   80103096 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010314b:	eb 40                	jmp    8010318d <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
8010314d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103151:	c1 e0 18             	shl    $0x18,%eax
80103154:	89 44 24 04          	mov    %eax,0x4(%esp)
80103158:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010315f:	e8 f7 fc ff ff       	call   80102e5b <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103164:	8b 45 0c             	mov    0xc(%ebp),%eax
80103167:	c1 e8 0c             	shr    $0xc,%eax
8010316a:	80 cc 06             	or     $0x6,%ah
8010316d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103171:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103178:	e8 de fc ff ff       	call   80102e5b <lapicw>
    microdelay(200);
8010317d:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103184:	e8 0d ff ff ff       	call   80103096 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103189:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010318d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103191:	7e ba                	jle    8010314d <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103193:	c9                   	leave  
80103194:	c3                   	ret    

80103195 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103195:	55                   	push   %ebp
80103196:	89 e5                	mov    %esp,%ebp
80103198:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
8010319b:	8b 45 08             	mov    0x8(%ebp),%eax
8010319e:	0f b6 c0             	movzbl %al,%eax
801031a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801031a5:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
801031ac:	e8 7c fc ff ff       	call   80102e2d <outb>
  microdelay(200);
801031b1:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
801031b8:	e8 d9 fe ff ff       	call   80103096 <microdelay>

  return inb(CMOS_RETURN);
801031bd:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801031c4:	e8 47 fc ff ff       	call   80102e10 <inb>
801031c9:	0f b6 c0             	movzbl %al,%eax
}
801031cc:	c9                   	leave  
801031cd:	c3                   	ret    

801031ce <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801031ce:	55                   	push   %ebp
801031cf:	89 e5                	mov    %esp,%ebp
801031d1:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
801031d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801031db:	e8 b5 ff ff ff       	call   80103195 <cmos_read>
801031e0:	8b 55 08             	mov    0x8(%ebp),%edx
801031e3:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801031e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801031ec:	e8 a4 ff ff ff       	call   80103195 <cmos_read>
801031f1:	8b 55 08             	mov    0x8(%ebp),%edx
801031f4:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801031f7:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801031fe:	e8 92 ff ff ff       	call   80103195 <cmos_read>
80103203:	8b 55 08             	mov    0x8(%ebp),%edx
80103206:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
80103209:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
80103210:	e8 80 ff ff ff       	call   80103195 <cmos_read>
80103215:	8b 55 08             	mov    0x8(%ebp),%edx
80103218:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010321b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103222:	e8 6e ff ff ff       	call   80103195 <cmos_read>
80103227:	8b 55 08             	mov    0x8(%ebp),%edx
8010322a:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010322d:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
80103234:	e8 5c ff ff ff       	call   80103195 <cmos_read>
80103239:	8b 55 08             	mov    0x8(%ebp),%edx
8010323c:	89 42 14             	mov    %eax,0x14(%edx)
}
8010323f:	c9                   	leave  
80103240:	c3                   	ret    

80103241 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103241:	55                   	push   %ebp
80103242:	89 e5                	mov    %esp,%ebp
80103244:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103247:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
8010324e:	e8 42 ff ff ff       	call   80103195 <cmos_read>
80103253:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103256:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103259:	83 e0 04             	and    $0x4,%eax
8010325c:	85 c0                	test   %eax,%eax
8010325e:	0f 94 c0             	sete   %al
80103261:	0f b6 c0             	movzbl %al,%eax
80103264:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80103267:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010326a:	89 04 24             	mov    %eax,(%esp)
8010326d:	e8 5c ff ff ff       	call   801031ce <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103272:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80103279:	e8 17 ff ff ff       	call   80103195 <cmos_read>
8010327e:	25 80 00 00 00       	and    $0x80,%eax
80103283:	85 c0                	test   %eax,%eax
80103285:	74 02                	je     80103289 <cmostime+0x48>
        continue;
80103287:	eb 36                	jmp    801032bf <cmostime+0x7e>
    fill_rtcdate(&t2);
80103289:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010328c:	89 04 24             	mov    %eax,(%esp)
8010328f:	e8 3a ff ff ff       	call   801031ce <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103294:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010329b:	00 
8010329c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010329f:	89 44 24 04          	mov    %eax,0x4(%esp)
801032a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801032a6:	89 04 24             	mov    %eax,(%esp)
801032a9:	e8 42 32 00 00       	call   801064f0 <memcmp>
801032ae:	85 c0                	test   %eax,%eax
801032b0:	75 0d                	jne    801032bf <cmostime+0x7e>
      break;
801032b2:	90                   	nop
  }

  // convert
  if(bcd) {
801032b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801032b7:	0f 84 ac 00 00 00    	je     80103369 <cmostime+0x128>
801032bd:	eb 02                	jmp    801032c1 <cmostime+0x80>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801032bf:	eb a6                	jmp    80103267 <cmostime+0x26>

  // convert
  if(bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032c4:	c1 e8 04             	shr    $0x4,%eax
801032c7:	89 c2                	mov    %eax,%edx
801032c9:	89 d0                	mov    %edx,%eax
801032cb:	c1 e0 02             	shl    $0x2,%eax
801032ce:	01 d0                	add    %edx,%eax
801032d0:	01 c0                	add    %eax,%eax
801032d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032d5:	83 e2 0f             	and    $0xf,%edx
801032d8:	01 d0                	add    %edx,%eax
801032da:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801032dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032e0:	c1 e8 04             	shr    $0x4,%eax
801032e3:	89 c2                	mov    %eax,%edx
801032e5:	89 d0                	mov    %edx,%eax
801032e7:	c1 e0 02             	shl    $0x2,%eax
801032ea:	01 d0                	add    %edx,%eax
801032ec:	01 c0                	add    %eax,%eax
801032ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032f1:	83 e2 0f             	and    $0xf,%edx
801032f4:	01 d0                	add    %edx,%eax
801032f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801032f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032fc:	c1 e8 04             	shr    $0x4,%eax
801032ff:	89 c2                	mov    %eax,%edx
80103301:	89 d0                	mov    %edx,%eax
80103303:	c1 e0 02             	shl    $0x2,%eax
80103306:	01 d0                	add    %edx,%eax
80103308:	01 c0                	add    %eax,%eax
8010330a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010330d:	83 e2 0f             	and    $0xf,%edx
80103310:	01 d0                	add    %edx,%eax
80103312:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103318:	c1 e8 04             	shr    $0x4,%eax
8010331b:	89 c2                	mov    %eax,%edx
8010331d:	89 d0                	mov    %edx,%eax
8010331f:	c1 e0 02             	shl    $0x2,%eax
80103322:	01 d0                	add    %edx,%eax
80103324:	01 c0                	add    %eax,%eax
80103326:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103329:	83 e2 0f             	and    $0xf,%edx
8010332c:	01 d0                	add    %edx,%eax
8010332e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103331:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103334:	c1 e8 04             	shr    $0x4,%eax
80103337:	89 c2                	mov    %eax,%edx
80103339:	89 d0                	mov    %edx,%eax
8010333b:	c1 e0 02             	shl    $0x2,%eax
8010333e:	01 d0                	add    %edx,%eax
80103340:	01 c0                	add    %eax,%eax
80103342:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103345:	83 e2 0f             	and    $0xf,%edx
80103348:	01 d0                	add    %edx,%eax
8010334a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010334d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103350:	c1 e8 04             	shr    $0x4,%eax
80103353:	89 c2                	mov    %eax,%edx
80103355:	89 d0                	mov    %edx,%eax
80103357:	c1 e0 02             	shl    $0x2,%eax
8010335a:	01 d0                	add    %edx,%eax
8010335c:	01 c0                	add    %eax,%eax
8010335e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103361:	83 e2 0f             	and    $0xf,%edx
80103364:	01 d0                	add    %edx,%eax
80103366:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103369:	8b 45 08             	mov    0x8(%ebp),%eax
8010336c:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010336f:	89 10                	mov    %edx,(%eax)
80103371:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103374:	89 50 04             	mov    %edx,0x4(%eax)
80103377:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010337a:	89 50 08             	mov    %edx,0x8(%eax)
8010337d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103380:	89 50 0c             	mov    %edx,0xc(%eax)
80103383:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103386:	89 50 10             	mov    %edx,0x10(%eax)
80103389:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010338c:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010338f:	8b 45 08             	mov    0x8(%ebp),%eax
80103392:	8b 40 14             	mov    0x14(%eax),%eax
80103395:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010339b:	8b 45 08             	mov    0x8(%ebp),%eax
8010339e:	89 50 14             	mov    %edx,0x14(%eax)
}
801033a1:	c9                   	leave  
801033a2:	c3                   	ret    

801033a3 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801033a3:	55                   	push   %ebp
801033a4:	89 e5                	mov    %esp,%ebp
801033a6:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801033a9:	c7 44 24 04 68 9c 10 	movl   $0x80109c68,0x4(%esp)
801033b0:	80 
801033b1:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
801033b8:	e8 32 2e 00 00       	call   801061ef <initlock>
  readsb(dev, &sb);
801033bd:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801033c4:	8b 45 08             	mov    0x8(%ebp),%eax
801033c7:	89 04 24             	mov    %eax,(%esp)
801033ca:	e8 04 e0 ff ff       	call   801013d3 <readsb>
  log.start = sb.logstart;
801033cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033d2:	a3 74 57 11 80       	mov    %eax,0x80115774
  log.size = sb.nlog;
801033d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801033da:	a3 78 57 11 80       	mov    %eax,0x80115778
  log.dev = dev;
801033df:	8b 45 08             	mov    0x8(%ebp),%eax
801033e2:	a3 84 57 11 80       	mov    %eax,0x80115784
  recover_from_log();
801033e7:	e8 9a 01 00 00       	call   80103586 <recover_from_log>
}
801033ec:	c9                   	leave  
801033ed:	c3                   	ret    

801033ee <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801033ee:	55                   	push   %ebp
801033ef:	89 e5                	mov    %esp,%ebp
801033f1:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033fb:	e9 8c 00 00 00       	jmp    8010348c <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103400:	8b 15 74 57 11 80    	mov    0x80115774,%edx
80103406:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103409:	01 d0                	add    %edx,%eax
8010340b:	83 c0 01             	add    $0x1,%eax
8010340e:	89 c2                	mov    %eax,%edx
80103410:	a1 84 57 11 80       	mov    0x80115784,%eax
80103415:	89 54 24 04          	mov    %edx,0x4(%esp)
80103419:	89 04 24             	mov    %eax,(%esp)
8010341c:	e8 94 cd ff ff       	call   801001b5 <bread>
80103421:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103424:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103427:	83 c0 10             	add    $0x10,%eax
8010342a:	8b 04 85 4c 57 11 80 	mov    -0x7feea8b4(,%eax,4),%eax
80103431:	89 c2                	mov    %eax,%edx
80103433:	a1 84 57 11 80       	mov    0x80115784,%eax
80103438:	89 54 24 04          	mov    %edx,0x4(%esp)
8010343c:	89 04 24             	mov    %eax,(%esp)
8010343f:	e8 71 cd ff ff       	call   801001b5 <bread>
80103444:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103447:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010344a:	8d 50 5c             	lea    0x5c(%eax),%edx
8010344d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103450:	83 c0 5c             	add    $0x5c,%eax
80103453:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010345a:	00 
8010345b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010345f:	89 04 24             	mov    %eax,(%esp)
80103462:	e8 e1 30 00 00       	call   80106548 <memmove>
    bwrite(dbuf);  // write dst to disk
80103467:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010346a:	89 04 24             	mov    %eax,(%esp)
8010346d:	e8 7a cd ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
80103472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103475:	89 04 24             	mov    %eax,(%esp)
80103478:	e8 af cd ff ff       	call   8010022c <brelse>
    brelse(dbuf);
8010347d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103480:	89 04 24             	mov    %eax,(%esp)
80103483:	e8 a4 cd ff ff       	call   8010022c <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103488:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010348c:	a1 88 57 11 80       	mov    0x80115788,%eax
80103491:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103494:	0f 8f 66 ff ff ff    	jg     80103400 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
8010349a:	c9                   	leave  
8010349b:	c3                   	ret    

8010349c <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010349c:	55                   	push   %ebp
8010349d:	89 e5                	mov    %esp,%ebp
8010349f:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801034a2:	a1 74 57 11 80       	mov    0x80115774,%eax
801034a7:	89 c2                	mov    %eax,%edx
801034a9:	a1 84 57 11 80       	mov    0x80115784,%eax
801034ae:	89 54 24 04          	mov    %edx,0x4(%esp)
801034b2:	89 04 24             	mov    %eax,(%esp)
801034b5:	e8 fb cc ff ff       	call   801001b5 <bread>
801034ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801034bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034c0:	83 c0 5c             	add    $0x5c,%eax
801034c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801034c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034c9:	8b 00                	mov    (%eax),%eax
801034cb:	a3 88 57 11 80       	mov    %eax,0x80115788
  for (i = 0; i < log.lh.n; i++) {
801034d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034d7:	eb 1b                	jmp    801034f4 <read_head+0x58>
    log.lh.block[i] = lh->block[i];
801034d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034df:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801034e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034e6:	83 c2 10             	add    $0x10,%edx
801034e9:	89 04 95 4c 57 11 80 	mov    %eax,-0x7feea8b4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801034f0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034f4:	a1 88 57 11 80       	mov    0x80115788,%eax
801034f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034fc:	7f db                	jg     801034d9 <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801034fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103501:	89 04 24             	mov    %eax,(%esp)
80103504:	e8 23 cd ff ff       	call   8010022c <brelse>
}
80103509:	c9                   	leave  
8010350a:	c3                   	ret    

8010350b <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010350b:	55                   	push   %ebp
8010350c:	89 e5                	mov    %esp,%ebp
8010350e:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103511:	a1 74 57 11 80       	mov    0x80115774,%eax
80103516:	89 c2                	mov    %eax,%edx
80103518:	a1 84 57 11 80       	mov    0x80115784,%eax
8010351d:	89 54 24 04          	mov    %edx,0x4(%esp)
80103521:	89 04 24             	mov    %eax,(%esp)
80103524:	e8 8c cc ff ff       	call   801001b5 <bread>
80103529:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010352c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010352f:	83 c0 5c             	add    $0x5c,%eax
80103532:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103535:	8b 15 88 57 11 80    	mov    0x80115788,%edx
8010353b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010353e:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103540:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103547:	eb 1b                	jmp    80103564 <write_head+0x59>
    hb->block[i] = log.lh.block[i];
80103549:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010354c:	83 c0 10             	add    $0x10,%eax
8010354f:	8b 0c 85 4c 57 11 80 	mov    -0x7feea8b4(,%eax,4),%ecx
80103556:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103559:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010355c:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103560:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103564:	a1 88 57 11 80       	mov    0x80115788,%eax
80103569:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010356c:	7f db                	jg     80103549 <write_head+0x3e>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
8010356e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103571:	89 04 24             	mov    %eax,(%esp)
80103574:	e8 73 cc ff ff       	call   801001ec <bwrite>
  brelse(buf);
80103579:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010357c:	89 04 24             	mov    %eax,(%esp)
8010357f:	e8 a8 cc ff ff       	call   8010022c <brelse>
}
80103584:	c9                   	leave  
80103585:	c3                   	ret    

80103586 <recover_from_log>:

static void
recover_from_log(void)
{
80103586:	55                   	push   %ebp
80103587:	89 e5                	mov    %esp,%ebp
80103589:	83 ec 08             	sub    $0x8,%esp
  read_head();
8010358c:	e8 0b ff ff ff       	call   8010349c <read_head>
  install_trans(); // if committed, copy from log to disk
80103591:	e8 58 fe ff ff       	call   801033ee <install_trans>
  log.lh.n = 0;
80103596:	c7 05 88 57 11 80 00 	movl   $0x0,0x80115788
8010359d:	00 00 00 
  write_head(); // clear the log
801035a0:	e8 66 ff ff ff       	call   8010350b <write_head>
}
801035a5:	c9                   	leave  
801035a6:	c3                   	ret    

801035a7 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801035a7:	55                   	push   %ebp
801035a8:	89 e5                	mov    %esp,%ebp
801035aa:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801035ad:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
801035b4:	e8 57 2c 00 00       	call   80106210 <acquire>
  while(1){
    if(log.committing){
801035b9:	a1 80 57 11 80       	mov    0x80115780,%eax
801035be:	85 c0                	test   %eax,%eax
801035c0:	74 16                	je     801035d8 <begin_op+0x31>
      sleep(&log, &log.lock);
801035c2:	c7 44 24 04 40 57 11 	movl   $0x80115740,0x4(%esp)
801035c9:	80 
801035ca:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
801035d1:	e8 6a 20 00 00       	call   80105640 <sleep>
801035d6:	eb 4f                	jmp    80103627 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801035d8:	8b 0d 88 57 11 80    	mov    0x80115788,%ecx
801035de:	a1 7c 57 11 80       	mov    0x8011577c,%eax
801035e3:	8d 50 01             	lea    0x1(%eax),%edx
801035e6:	89 d0                	mov    %edx,%eax
801035e8:	c1 e0 02             	shl    $0x2,%eax
801035eb:	01 d0                	add    %edx,%eax
801035ed:	01 c0                	add    %eax,%eax
801035ef:	01 c8                	add    %ecx,%eax
801035f1:	83 f8 1e             	cmp    $0x1e,%eax
801035f4:	7e 16                	jle    8010360c <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801035f6:	c7 44 24 04 40 57 11 	movl   $0x80115740,0x4(%esp)
801035fd:	80 
801035fe:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103605:	e8 36 20 00 00       	call   80105640 <sleep>
8010360a:	eb 1b                	jmp    80103627 <begin_op+0x80>
    } else {
      log.outstanding += 1;
8010360c:	a1 7c 57 11 80       	mov    0x8011577c,%eax
80103611:	83 c0 01             	add    $0x1,%eax
80103614:	a3 7c 57 11 80       	mov    %eax,0x8011577c
      release(&log.lock);
80103619:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103620:	e8 52 2c 00 00       	call   80106277 <release>
      break;
80103625:	eb 02                	jmp    80103629 <begin_op+0x82>
    }
  }
80103627:	eb 90                	jmp    801035b9 <begin_op+0x12>
}
80103629:	c9                   	leave  
8010362a:	c3                   	ret    

8010362b <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010362b:	55                   	push   %ebp
8010362c:	89 e5                	mov    %esp,%ebp
8010362e:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
80103631:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103638:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
8010363f:	e8 cc 2b 00 00       	call   80106210 <acquire>
  log.outstanding -= 1;
80103644:	a1 7c 57 11 80       	mov    0x8011577c,%eax
80103649:	83 e8 01             	sub    $0x1,%eax
8010364c:	a3 7c 57 11 80       	mov    %eax,0x8011577c
  if(log.committing)
80103651:	a1 80 57 11 80       	mov    0x80115780,%eax
80103656:	85 c0                	test   %eax,%eax
80103658:	74 0c                	je     80103666 <end_op+0x3b>
    panic("log.committing");
8010365a:	c7 04 24 6c 9c 10 80 	movl   $0x80109c6c,(%esp)
80103661:	e8 fc ce ff ff       	call   80100562 <panic>
  if(log.outstanding == 0){
80103666:	a1 7c 57 11 80       	mov    0x8011577c,%eax
8010366b:	85 c0                	test   %eax,%eax
8010366d:	75 13                	jne    80103682 <end_op+0x57>
    do_commit = 1;
8010366f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103676:	c7 05 80 57 11 80 01 	movl   $0x1,0x80115780
8010367d:	00 00 00 
80103680:	eb 0c                	jmp    8010368e <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103682:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103689:	e8 8e 20 00 00       	call   8010571c <wakeup>
  }
  release(&log.lock);
8010368e:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103695:	e8 dd 2b 00 00       	call   80106277 <release>

  if(do_commit){
8010369a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010369e:	74 33                	je     801036d3 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801036a0:	e8 de 00 00 00       	call   80103783 <commit>
    acquire(&log.lock);
801036a5:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
801036ac:	e8 5f 2b 00 00       	call   80106210 <acquire>
    log.committing = 0;
801036b1:	c7 05 80 57 11 80 00 	movl   $0x0,0x80115780
801036b8:	00 00 00 
    wakeup(&log);
801036bb:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
801036c2:	e8 55 20 00 00       	call   8010571c <wakeup>
    release(&log.lock);
801036c7:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
801036ce:	e8 a4 2b 00 00       	call   80106277 <release>
  }
}
801036d3:	c9                   	leave  
801036d4:	c3                   	ret    

801036d5 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801036d5:	55                   	push   %ebp
801036d6:	89 e5                	mov    %esp,%ebp
801036d8:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036e2:	e9 8c 00 00 00       	jmp    80103773 <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036e7:	8b 15 74 57 11 80    	mov    0x80115774,%edx
801036ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036f0:	01 d0                	add    %edx,%eax
801036f2:	83 c0 01             	add    $0x1,%eax
801036f5:	89 c2                	mov    %eax,%edx
801036f7:	a1 84 57 11 80       	mov    0x80115784,%eax
801036fc:	89 54 24 04          	mov    %edx,0x4(%esp)
80103700:	89 04 24             	mov    %eax,(%esp)
80103703:	e8 ad ca ff ff       	call   801001b5 <bread>
80103708:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010370b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010370e:	83 c0 10             	add    $0x10,%eax
80103711:	8b 04 85 4c 57 11 80 	mov    -0x7feea8b4(,%eax,4),%eax
80103718:	89 c2                	mov    %eax,%edx
8010371a:	a1 84 57 11 80       	mov    0x80115784,%eax
8010371f:	89 54 24 04          	mov    %edx,0x4(%esp)
80103723:	89 04 24             	mov    %eax,(%esp)
80103726:	e8 8a ca ff ff       	call   801001b5 <bread>
8010372b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010372e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103731:	8d 50 5c             	lea    0x5c(%eax),%edx
80103734:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103737:	83 c0 5c             	add    $0x5c,%eax
8010373a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103741:	00 
80103742:	89 54 24 04          	mov    %edx,0x4(%esp)
80103746:	89 04 24             	mov    %eax,(%esp)
80103749:	e8 fa 2d 00 00       	call   80106548 <memmove>
    bwrite(to);  // write the log
8010374e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103751:	89 04 24             	mov    %eax,(%esp)
80103754:	e8 93 ca ff ff       	call   801001ec <bwrite>
    brelse(from);
80103759:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010375c:	89 04 24             	mov    %eax,(%esp)
8010375f:	e8 c8 ca ff ff       	call   8010022c <brelse>
    brelse(to);
80103764:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103767:	89 04 24             	mov    %eax,(%esp)
8010376a:	e8 bd ca ff ff       	call   8010022c <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010376f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103773:	a1 88 57 11 80       	mov    0x80115788,%eax
80103778:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010377b:	0f 8f 66 ff ff ff    	jg     801036e7 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}
80103781:	c9                   	leave  
80103782:	c3                   	ret    

80103783 <commit>:

static void
commit()
{
80103783:	55                   	push   %ebp
80103784:	89 e5                	mov    %esp,%ebp
80103786:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103789:	a1 88 57 11 80       	mov    0x80115788,%eax
8010378e:	85 c0                	test   %eax,%eax
80103790:	7e 1e                	jle    801037b0 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103792:	e8 3e ff ff ff       	call   801036d5 <write_log>
    write_head();    // Write header to disk -- the real commit
80103797:	e8 6f fd ff ff       	call   8010350b <write_head>
    install_trans(); // Now install writes to home locations
8010379c:	e8 4d fc ff ff       	call   801033ee <install_trans>
    log.lh.n = 0;
801037a1:	c7 05 88 57 11 80 00 	movl   $0x0,0x80115788
801037a8:	00 00 00 
    write_head();    // Erase the transaction from the log
801037ab:	e8 5b fd ff ff       	call   8010350b <write_head>
  }
}
801037b0:	c9                   	leave  
801037b1:	c3                   	ret    

801037b2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037b2:	55                   	push   %ebp
801037b3:	89 e5                	mov    %esp,%ebp
801037b5:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037b8:	a1 88 57 11 80       	mov    0x80115788,%eax
801037bd:	83 f8 1d             	cmp    $0x1d,%eax
801037c0:	7f 12                	jg     801037d4 <log_write+0x22>
801037c2:	a1 88 57 11 80       	mov    0x80115788,%eax
801037c7:	8b 15 78 57 11 80    	mov    0x80115778,%edx
801037cd:	83 ea 01             	sub    $0x1,%edx
801037d0:	39 d0                	cmp    %edx,%eax
801037d2:	7c 0c                	jl     801037e0 <log_write+0x2e>
    panic("too big a transaction");
801037d4:	c7 04 24 7b 9c 10 80 	movl   $0x80109c7b,(%esp)
801037db:	e8 82 cd ff ff       	call   80100562 <panic>
  if (log.outstanding < 1)
801037e0:	a1 7c 57 11 80       	mov    0x8011577c,%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	7f 0c                	jg     801037f5 <log_write+0x43>
    panic("log_write outside of trans");
801037e9:	c7 04 24 91 9c 10 80 	movl   $0x80109c91,(%esp)
801037f0:	e8 6d cd ff ff       	call   80100562 <panic>

  acquire(&log.lock);
801037f5:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
801037fc:	e8 0f 2a 00 00       	call   80106210 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103801:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103808:	eb 1f                	jmp    80103829 <log_write+0x77>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010380a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010380d:	83 c0 10             	add    $0x10,%eax
80103810:	8b 04 85 4c 57 11 80 	mov    -0x7feea8b4(,%eax,4),%eax
80103817:	89 c2                	mov    %eax,%edx
80103819:	8b 45 08             	mov    0x8(%ebp),%eax
8010381c:	8b 40 08             	mov    0x8(%eax),%eax
8010381f:	39 c2                	cmp    %eax,%edx
80103821:	75 02                	jne    80103825 <log_write+0x73>
      break;
80103823:	eb 0e                	jmp    80103833 <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103825:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103829:	a1 88 57 11 80       	mov    0x80115788,%eax
8010382e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103831:	7f d7                	jg     8010380a <log_write+0x58>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103833:	8b 45 08             	mov    0x8(%ebp),%eax
80103836:	8b 40 08             	mov    0x8(%eax),%eax
80103839:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010383c:	83 c2 10             	add    $0x10,%edx
8010383f:	89 04 95 4c 57 11 80 	mov    %eax,-0x7feea8b4(,%edx,4)
  if (i == log.lh.n)
80103846:	a1 88 57 11 80       	mov    0x80115788,%eax
8010384b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010384e:	75 0d                	jne    8010385d <log_write+0xab>
    log.lh.n++;
80103850:	a1 88 57 11 80       	mov    0x80115788,%eax
80103855:	83 c0 01             	add    $0x1,%eax
80103858:	a3 88 57 11 80       	mov    %eax,0x80115788
  b->flags |= B_DIRTY; // prevent eviction
8010385d:	8b 45 08             	mov    0x8(%ebp),%eax
80103860:	8b 00                	mov    (%eax),%eax
80103862:	83 c8 04             	or     $0x4,%eax
80103865:	89 c2                	mov    %eax,%edx
80103867:	8b 45 08             	mov    0x8(%ebp),%eax
8010386a:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010386c:	c7 04 24 40 57 11 80 	movl   $0x80115740,(%esp)
80103873:	e8 ff 29 00 00       	call   80106277 <release>
}
80103878:	c9                   	leave  
80103879:	c3                   	ret    

8010387a <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010387a:	55                   	push   %ebp
8010387b:	89 e5                	mov    %esp,%ebp
8010387d:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103880:	8b 55 08             	mov    0x8(%ebp),%edx
80103883:	8b 45 0c             	mov    0xc(%ebp),%eax
80103886:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103889:	f0 87 02             	lock xchg %eax,(%edx)
8010388c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010388f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103892:	c9                   	leave  
80103893:	c3                   	ret    

80103894 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103894:	55                   	push   %ebp
80103895:	89 e5                	mov    %esp,%ebp
80103897:	83 e4 f0             	and    $0xfffffff0,%esp
8010389a:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010389d:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801038a4:	80 
801038a5:	c7 04 24 68 90 11 80 	movl   $0x80119068,(%esp)
801038ac:	e8 63 f2 ff ff       	call   80102b14 <kinit1>
  kvmalloc();      // kernel page table
801038b1:	e8 87 58 00 00       	call   8010913d <kvmalloc>
  mpinit();        // detect other processors
801038b6:	e8 f1 03 00 00       	call   80103cac <mpinit>
  lapicinit();     // interrupt controller
801038bb:	e8 bc f5 ff ff       	call   80102e7c <lapicinit>
  seginit();       // segment descriptors
801038c0:	e8 33 52 00 00       	call   80108af8 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
801038c5:	e8 0b f7 ff ff       	call   80102fd5 <cpunum>
801038ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801038ce:	c7 04 24 ac 9c 10 80 	movl   $0x80109cac,(%esp)
801038d5:	e8 ee ca ff ff       	call   801003c8 <cprintf>
  picinit();       // another interrupt controller
801038da:	e8 a8 05 00 00       	call   80103e87 <picinit>
  ioapicinit();    // another interrupt controller
801038df:	e8 33 f1 ff ff       	call   80102a17 <ioapicinit>
  consoleinit();   // console hardware
801038e4:	e8 ef d1 ff ff       	call   80100ad8 <consoleinit>
  uartinit();      // serial port
801038e9:	e8 73 45 00 00       	call   80107e61 <uartinit>
  pinit();         // process table
801038ee:	e8 62 0c 00 00       	call   80104555 <pinit>
  tvinit();        // trap vectors
801038f3:	e8 ec 3f 00 00       	call   801078e4 <tvinit>
  binit();         // buffer cache
801038f8:	e8 37 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801038fd:	e8 ea d6 ff ff       	call   80100fec <fileinit>
  ideinit();       // disk
80103902:	e8 0e ed ff ff       	call   80102615 <ideinit>
  if(!ismp)
80103907:	a1 24 58 11 80       	mov    0x80115824,%eax
8010390c:	85 c0                	test   %eax,%eax
8010390e:	75 05                	jne    80103915 <main+0x81>
    timerinit();   // uniprocessor timer
80103910:	e8 1a 3f 00 00       	call   8010782f <timerinit>
  startothers();   // start other processors
80103915:	e8 78 00 00 00       	call   80103992 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
8010391a:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80103921:	8e 
80103922:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103929:	e8 1e f2 ff ff       	call   80102b4c <kinit2>
  userinit();      // first user process
8010392e:	e8 4f 0e 00 00       	call   80104782 <userinit>
  mpmain();        // finish this processor's setup
80103933:	e8 1a 00 00 00       	call   80103952 <mpmain>

80103938 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103938:	55                   	push   %ebp
80103939:	89 e5                	mov    %esp,%ebp
8010393b:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010393e:	e8 11 58 00 00       	call   80109154 <switchkvm>
  seginit();
80103943:	e8 b0 51 00 00       	call   80108af8 <seginit>
  lapicinit();
80103948:	e8 2f f5 ff ff       	call   80102e7c <lapicinit>
  mpmain();
8010394d:	e8 00 00 00 00       	call   80103952 <mpmain>

80103952 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103952:	55                   	push   %ebp
80103953:	89 e5                	mov    %esp,%ebp
80103955:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80103958:	e8 78 f6 ff ff       	call   80102fd5 <cpunum>
8010395d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103961:	c7 04 24 c3 9c 10 80 	movl   $0x80109cc3,(%esp)
80103968:	e8 5b ca ff ff       	call   801003c8 <cprintf>
  idtinit();       // load idt register
8010396d:	e8 62 41 00 00       	call   80107ad4 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103972:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103978:	05 a8 00 00 00       	add    $0xa8,%eax
8010397d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103984:	00 
80103985:	89 04 24             	mov    %eax,(%esp)
80103988:	e8 ed fe ff ff       	call   8010387a <xchg>
  scheduler();     // start running processes
8010398d:	e8 57 19 00 00       	call   801052e9 <scheduler>

80103992 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103992:	55                   	push   %ebp
80103993:	89 e5                	mov    %esp,%ebp
80103995:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103998:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010399f:	b8 8a 00 00 00       	mov    $0x8a,%eax
801039a4:	89 44 24 08          	mov    %eax,0x8(%esp)
801039a8:	c7 44 24 04 2c d5 10 	movl   $0x8010d52c,0x4(%esp)
801039af:	80 
801039b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039b3:	89 04 24             	mov    %eax,(%esp)
801039b6:	e8 8d 2b 00 00       	call   80106548 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801039bb:	c7 45 f4 40 58 11 80 	movl   $0x80115840,-0xc(%ebp)
801039c2:	e9 81 00 00 00       	jmp    80103a48 <startothers+0xb6>
    if(c == cpus+cpunum())  // We've started already.
801039c7:	e8 09 f6 ff ff       	call   80102fd5 <cpunum>
801039cc:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039d2:	05 40 58 11 80       	add    $0x80115840,%eax
801039d7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039da:	75 02                	jne    801039de <startothers+0x4c>
      continue;
801039dc:	eb 63                	jmp    80103a41 <startothers+0xaf>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801039de:	e8 5c f2 ff ff       	call   80102c3f <kalloc>
801039e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801039e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039e9:	83 e8 04             	sub    $0x4,%eax
801039ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
801039ef:	81 c2 00 10 00 00    	add    $0x1000,%edx
801039f5:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801039f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039fa:	83 e8 08             	sub    $0x8,%eax
801039fd:	c7 00 38 39 10 80    	movl   $0x80103938,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a06:	8d 50 f4             	lea    -0xc(%eax),%edx
80103a09:	b8 00 c0 10 80       	mov    $0x8010c000,%eax
80103a0e:	05 00 00 00 80       	add    $0x80000000,%eax
80103a13:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
80103a15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a18:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80103a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a21:	0f b6 00             	movzbl (%eax),%eax
80103a24:	0f b6 c0             	movzbl %al,%eax
80103a27:	89 54 24 04          	mov    %edx,0x4(%esp)
80103a2b:	89 04 24             	mov    %eax,(%esp)
80103a2e:	e8 68 f6 ff ff       	call   8010309b <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103a33:	90                   	nop
80103a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a37:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103a3d:	85 c0                	test   %eax,%eax
80103a3f:	74 f3                	je     80103a34 <startothers+0xa2>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103a41:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103a48:	a1 20 5e 11 80       	mov    0x80115e20,%eax
80103a4d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a53:	05 40 58 11 80       	add    $0x80115840,%eax
80103a58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a5b:	0f 87 66 ff ff ff    	ja     801039c7 <startothers+0x35>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103a61:	c9                   	leave  
80103a62:	c3                   	ret    

80103a63 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103a63:	55                   	push   %ebp
80103a64:	89 e5                	mov    %esp,%ebp
80103a66:	83 ec 14             	sub    $0x14,%esp
80103a69:	8b 45 08             	mov    0x8(%ebp),%eax
80103a6c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a70:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a74:	89 c2                	mov    %eax,%edx
80103a76:	ec                   	in     (%dx),%al
80103a77:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a7a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a7e:	c9                   	leave  
80103a7f:	c3                   	ret    

80103a80 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	83 ec 08             	sub    $0x8,%esp
80103a86:	8b 55 08             	mov    0x8(%ebp),%edx
80103a89:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a8c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a90:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a93:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a97:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a9b:	ee                   	out    %al,(%dx)
}
80103a9c:	c9                   	leave  
80103a9d:	c3                   	ret    

80103a9e <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103a9e:	55                   	push   %ebp
80103a9f:	89 e5                	mov    %esp,%ebp
80103aa1:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
80103aa4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103aab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103ab2:	eb 15                	jmp    80103ac9 <sum+0x2b>
    sum += addr[i];
80103ab4:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80103aba:	01 d0                	add    %edx,%eax
80103abc:	0f b6 00             	movzbl (%eax),%eax
80103abf:	0f b6 c0             	movzbl %al,%eax
80103ac2:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103ac5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103ac9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103acc:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103acf:	7c e3                	jl     80103ab4 <sum+0x16>
    sum += addr[i];
  return sum;
80103ad1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103ad4:	c9                   	leave  
80103ad5:	c3                   	ret    

80103ad6 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103ad6:	55                   	push   %ebp
80103ad7:	89 e5                	mov    %esp,%ebp
80103ad9:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103adc:	8b 45 08             	mov    0x8(%ebp),%eax
80103adf:	05 00 00 00 80       	add    $0x80000000,%eax
80103ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
80103aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aed:	01 d0                	add    %edx,%eax
80103aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103af8:	eb 3f                	jmp    80103b39 <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103afa:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b01:	00 
80103b02:	c7 44 24 04 d4 9c 10 	movl   $0x80109cd4,0x4(%esp)
80103b09:	80 
80103b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b0d:	89 04 24             	mov    %eax,(%esp)
80103b10:	e8 db 29 00 00       	call   801064f0 <memcmp>
80103b15:	85 c0                	test   %eax,%eax
80103b17:	75 1c                	jne    80103b35 <mpsearch1+0x5f>
80103b19:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103b20:	00 
80103b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b24:	89 04 24             	mov    %eax,(%esp)
80103b27:	e8 72 ff ff ff       	call   80103a9e <sum>
80103b2c:	84 c0                	test   %al,%al
80103b2e:	75 05                	jne    80103b35 <mpsearch1+0x5f>
      return (struct mp*)p;
80103b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b33:	eb 11                	jmp    80103b46 <mpsearch1+0x70>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103b35:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b3c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103b3f:	72 b9                	jb     80103afa <mpsearch1+0x24>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103b41:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103b46:	c9                   	leave  
80103b47:	c3                   	ret    

80103b48 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103b48:	55                   	push   %ebp
80103b49:	89 e5                	mov    %esp,%ebp
80103b4b:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b4e:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b58:	83 c0 0f             	add    $0xf,%eax
80103b5b:	0f b6 00             	movzbl (%eax),%eax
80103b5e:	0f b6 c0             	movzbl %al,%eax
80103b61:	c1 e0 08             	shl    $0x8,%eax
80103b64:	89 c2                	mov    %eax,%edx
80103b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b69:	83 c0 0e             	add    $0xe,%eax
80103b6c:	0f b6 00             	movzbl (%eax),%eax
80103b6f:	0f b6 c0             	movzbl %al,%eax
80103b72:	09 d0                	or     %edx,%eax
80103b74:	c1 e0 04             	shl    $0x4,%eax
80103b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b7e:	74 21                	je     80103ba1 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b80:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103b87:	00 
80103b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b8b:	89 04 24             	mov    %eax,(%esp)
80103b8e:	e8 43 ff ff ff       	call   80103ad6 <mpsearch1>
80103b93:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b9a:	74 50                	je     80103bec <mpsearch+0xa4>
      return mp;
80103b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b9f:	eb 5f                	jmp    80103c00 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba4:	83 c0 14             	add    $0x14,%eax
80103ba7:	0f b6 00             	movzbl (%eax),%eax
80103baa:	0f b6 c0             	movzbl %al,%eax
80103bad:	c1 e0 08             	shl    $0x8,%eax
80103bb0:	89 c2                	mov    %eax,%edx
80103bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb5:	83 c0 13             	add    $0x13,%eax
80103bb8:	0f b6 00             	movzbl (%eax),%eax
80103bbb:	0f b6 c0             	movzbl %al,%eax
80103bbe:	09 d0                	or     %edx,%eax
80103bc0:	c1 e0 0a             	shl    $0xa,%eax
80103bc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bc9:	2d 00 04 00 00       	sub    $0x400,%eax
80103bce:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103bd5:	00 
80103bd6:	89 04 24             	mov    %eax,(%esp)
80103bd9:	e8 f8 fe ff ff       	call   80103ad6 <mpsearch1>
80103bde:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103be1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103be5:	74 05                	je     80103bec <mpsearch+0xa4>
      return mp;
80103be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bea:	eb 14                	jmp    80103c00 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103bec:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103bf3:	00 
80103bf4:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103bfb:	e8 d6 fe ff ff       	call   80103ad6 <mpsearch1>
}
80103c00:	c9                   	leave  
80103c01:	c3                   	ret    

80103c02 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103c02:	55                   	push   %ebp
80103c03:	89 e5                	mov    %esp,%ebp
80103c05:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c08:	e8 3b ff ff ff       	call   80103b48 <mpsearch>
80103c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c14:	74 0a                	je     80103c20 <mpconfig+0x1e>
80103c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c19:	8b 40 04             	mov    0x4(%eax),%eax
80103c1c:	85 c0                	test   %eax,%eax
80103c1e:	75 0a                	jne    80103c2a <mpconfig+0x28>
    return 0;
80103c20:	b8 00 00 00 00       	mov    $0x0,%eax
80103c25:	e9 80 00 00 00       	jmp    80103caa <mpconfig+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2d:	8b 40 04             	mov    0x4(%eax),%eax
80103c30:	05 00 00 00 80       	add    $0x80000000,%eax
80103c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c38:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103c3f:	00 
80103c40:	c7 44 24 04 d9 9c 10 	movl   $0x80109cd9,0x4(%esp)
80103c47:	80 
80103c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c4b:	89 04 24             	mov    %eax,(%esp)
80103c4e:	e8 9d 28 00 00       	call   801064f0 <memcmp>
80103c53:	85 c0                	test   %eax,%eax
80103c55:	74 07                	je     80103c5e <mpconfig+0x5c>
    return 0;
80103c57:	b8 00 00 00 00       	mov    $0x0,%eax
80103c5c:	eb 4c                	jmp    80103caa <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
80103c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c61:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c65:	3c 01                	cmp    $0x1,%al
80103c67:	74 12                	je     80103c7b <mpconfig+0x79>
80103c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c6c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c70:	3c 04                	cmp    $0x4,%al
80103c72:	74 07                	je     80103c7b <mpconfig+0x79>
    return 0;
80103c74:	b8 00 00 00 00       	mov    $0x0,%eax
80103c79:	eb 2f                	jmp    80103caa <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c7e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c82:	0f b7 c0             	movzwl %ax,%eax
80103c85:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c8c:	89 04 24             	mov    %eax,(%esp)
80103c8f:	e8 0a fe ff ff       	call   80103a9e <sum>
80103c94:	84 c0                	test   %al,%al
80103c96:	74 07                	je     80103c9f <mpconfig+0x9d>
    return 0;
80103c98:	b8 00 00 00 00       	mov    $0x0,%eax
80103c9d:	eb 0b                	jmp    80103caa <mpconfig+0xa8>
  *pmp = mp;
80103c9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103ca2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103ca5:	89 10                	mov    %edx,(%eax)
  return conf;
80103ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103caa:	c9                   	leave  
80103cab:	c3                   	ret    

80103cac <mpinit>:

void
mpinit(void)
{
80103cac:	55                   	push   %ebp
80103cad:	89 e5                	mov    %esp,%ebp
80103caf:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103cb2:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103cb5:	89 04 24             	mov    %eax,(%esp)
80103cb8:	e8 45 ff ff ff       	call   80103c02 <mpconfig>
80103cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103cc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103cc4:	75 05                	jne    80103ccb <mpinit+0x1f>
    return;
80103cc6:	e9 23 01 00 00       	jmp    80103dee <mpinit+0x142>
  ismp = 1;
80103ccb:	c7 05 24 58 11 80 01 	movl   $0x1,0x80115824
80103cd2:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd8:	8b 40 24             	mov    0x24(%eax),%eax
80103cdb:	a3 3c 57 11 80       	mov    %eax,0x8011573c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce3:	83 c0 2c             	add    $0x2c,%eax
80103ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cec:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103cf0:	0f b7 d0             	movzwl %ax,%edx
80103cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf6:	01 d0                	add    %edx,%eax
80103cf8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cfb:	eb 7e                	jmp    80103d7b <mpinit+0xcf>
    switch(*p){
80103cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d00:	0f b6 00             	movzbl (%eax),%eax
80103d03:	0f b6 c0             	movzbl %al,%eax
80103d06:	83 f8 04             	cmp    $0x4,%eax
80103d09:	77 65                	ja     80103d70 <mpinit+0xc4>
80103d0b:	8b 04 85 e0 9c 10 80 	mov    -0x7fef6320(,%eax,4),%eax
80103d12:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d17:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu < NCPU) {
80103d1a:	a1 20 5e 11 80       	mov    0x80115e20,%eax
80103d1f:	83 f8 07             	cmp    $0x7,%eax
80103d22:	7f 28                	jg     80103d4c <mpinit+0xa0>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103d24:	8b 15 20 5e 11 80    	mov    0x80115e20,%edx
80103d2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d2d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d31:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103d37:	81 c2 40 58 11 80    	add    $0x80115840,%edx
80103d3d:	88 02                	mov    %al,(%edx)
        ncpu++;
80103d3f:	a1 20 5e 11 80       	mov    0x80115e20,%eax
80103d44:	83 c0 01             	add    $0x1,%eax
80103d47:	a3 20 5e 11 80       	mov    %eax,0x80115e20
      }
      p += sizeof(struct mpproc);
80103d4c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103d50:	eb 29                	jmp    80103d7b <mpinit+0xcf>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d5b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d5f:	a2 20 58 11 80       	mov    %al,0x80115820
      p += sizeof(struct mpioapic);
80103d64:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d68:	eb 11                	jmp    80103d7b <mpinit+0xcf>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d6a:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103d6e:	eb 0b                	jmp    80103d7b <mpinit+0xcf>
    default:
      ismp = 0;
80103d70:	c7 05 24 58 11 80 00 	movl   $0x0,0x80115824
80103d77:	00 00 00 
      break;
80103d7a:	90                   	nop

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d7e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d81:	0f 82 76 ff ff ff    	jb     80103cfd <mpinit+0x51>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103d87:	a1 24 58 11 80       	mov    0x80115824,%eax
80103d8c:	85 c0                	test   %eax,%eax
80103d8e:	75 1d                	jne    80103dad <mpinit+0x101>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103d90:	c7 05 20 5e 11 80 01 	movl   $0x1,0x80115e20
80103d97:	00 00 00 
    lapic = 0;
80103d9a:	c7 05 3c 57 11 80 00 	movl   $0x0,0x8011573c
80103da1:	00 00 00 
    ioapicid = 0;
80103da4:	c6 05 20 58 11 80 00 	movb   $0x0,0x80115820
    return;
80103dab:	eb 41                	jmp    80103dee <mpinit+0x142>
  }

  if(mp->imcrp){
80103dad:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103db0:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103db4:	84 c0                	test   %al,%al
80103db6:	74 36                	je     80103dee <mpinit+0x142>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103db8:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103dbf:	00 
80103dc0:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103dc7:	e8 b4 fc ff ff       	call   80103a80 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103dcc:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103dd3:	e8 8b fc ff ff       	call   80103a63 <inb>
80103dd8:	83 c8 01             	or     $0x1,%eax
80103ddb:	0f b6 c0             	movzbl %al,%eax
80103dde:	89 44 24 04          	mov    %eax,0x4(%esp)
80103de2:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103de9:	e8 92 fc ff ff       	call   80103a80 <outb>
  }
}
80103dee:	c9                   	leave  
80103def:	c3                   	ret    

80103df0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	83 ec 08             	sub    $0x8,%esp
80103df6:	8b 55 08             	mov    0x8(%ebp),%edx
80103df9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dfc:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e00:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e03:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e07:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e0b:	ee                   	out    %al,(%dx)
}
80103e0c:	c9                   	leave  
80103e0d:	c3                   	ret    

80103e0e <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e0e:	55                   	push   %ebp
80103e0f:	89 e5                	mov    %esp,%ebp
80103e11:	83 ec 0c             	sub    $0xc,%esp
80103e14:	8b 45 08             	mov    0x8(%ebp),%eax
80103e17:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e1b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e1f:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80103e25:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e29:	0f b6 c0             	movzbl %al,%eax
80103e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e30:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e37:	e8 b4 ff ff ff       	call   80103df0 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103e3c:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e40:	66 c1 e8 08          	shr    $0x8,%ax
80103e44:	0f b6 c0             	movzbl %al,%eax
80103e47:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e4b:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e52:	e8 99 ff ff ff       	call   80103df0 <outb>
}
80103e57:	c9                   	leave  
80103e58:	c3                   	ret    

80103e59 <picenable>:

void
picenable(int irq)
{
80103e59:	55                   	push   %ebp
80103e5a:	89 e5                	mov    %esp,%ebp
80103e5c:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e62:	ba 01 00 00 00       	mov    $0x1,%edx
80103e67:	89 c1                	mov    %eax,%ecx
80103e69:	d3 e2                	shl    %cl,%edx
80103e6b:	89 d0                	mov    %edx,%eax
80103e6d:	f7 d0                	not    %eax
80103e6f:	89 c2                	mov    %eax,%edx
80103e71:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80103e78:	21 d0                	and    %edx,%eax
80103e7a:	0f b7 c0             	movzwl %ax,%eax
80103e7d:	89 04 24             	mov    %eax,(%esp)
80103e80:	e8 89 ff ff ff       	call   80103e0e <picsetmask>
}
80103e85:	c9                   	leave  
80103e86:	c3                   	ret    

80103e87 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103e87:	55                   	push   %ebp
80103e88:	89 e5                	mov    %esp,%ebp
80103e8a:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103e8d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e94:	00 
80103e95:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e9c:	e8 4f ff ff ff       	call   80103df0 <outb>
  outb(IO_PIC2+1, 0xFF);
80103ea1:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ea8:	00 
80103ea9:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103eb0:	e8 3b ff ff ff       	call   80103df0 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103eb5:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103ebc:	00 
80103ebd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ec4:	e8 27 ff ff ff       	call   80103df0 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103ec9:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103ed0:	00 
80103ed1:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ed8:	e8 13 ff ff ff       	call   80103df0 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103edd:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103ee4:	00 
80103ee5:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103eec:	e8 ff fe ff ff       	call   80103df0 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103ef1:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103ef8:	00 
80103ef9:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103f00:	e8 eb fe ff ff       	call   80103df0 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f05:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103f0c:	00 
80103f0d:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f14:	e8 d7 fe ff ff       	call   80103df0 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f19:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103f20:	00 
80103f21:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f28:	e8 c3 fe ff ff       	call   80103df0 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f2d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103f34:	00 
80103f35:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f3c:	e8 af fe ff ff       	call   80103df0 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f41:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103f48:	00 
80103f49:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103f50:	e8 9b fe ff ff       	call   80103df0 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f55:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f5c:	00 
80103f5d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f64:	e8 87 fe ff ff       	call   80103df0 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f69:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f70:	00 
80103f71:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f78:	e8 73 fe ff ff       	call   80103df0 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103f7d:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f84:	00 
80103f85:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f8c:	e8 5f fe ff ff       	call   80103df0 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103f91:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f98:	00 
80103f99:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103fa0:	e8 4b fe ff ff       	call   80103df0 <outb>

  if(irqmask != 0xFFFF)
80103fa5:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80103fac:	66 83 f8 ff          	cmp    $0xffff,%ax
80103fb0:	74 12                	je     80103fc4 <picinit+0x13d>
    picsetmask(irqmask);
80103fb2:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80103fb9:	0f b7 c0             	movzwl %ax,%eax
80103fbc:	89 04 24             	mov    %eax,(%esp)
80103fbf:	e8 4a fe ff ff       	call   80103e0e <picsetmask>
}
80103fc4:	c9                   	leave  
80103fc5:	c3                   	ret    

80103fc6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fc6:	55                   	push   %ebp
80103fc7:	89 e5                	mov    %esp,%ebp
80103fc9:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103fcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fdf:	8b 10                	mov    (%eax),%edx
80103fe1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe4:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103fe6:	e8 1d d0 ff ff       	call   80101008 <filealloc>
80103feb:	8b 55 08             	mov    0x8(%ebp),%edx
80103fee:	89 02                	mov    %eax,(%edx)
80103ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff3:	8b 00                	mov    (%eax),%eax
80103ff5:	85 c0                	test   %eax,%eax
80103ff7:	0f 84 c8 00 00 00    	je     801040c5 <pipealloc+0xff>
80103ffd:	e8 06 d0 ff ff       	call   80101008 <filealloc>
80104002:	8b 55 0c             	mov    0xc(%ebp),%edx
80104005:	89 02                	mov    %eax,(%edx)
80104007:	8b 45 0c             	mov    0xc(%ebp),%eax
8010400a:	8b 00                	mov    (%eax),%eax
8010400c:	85 c0                	test   %eax,%eax
8010400e:	0f 84 b1 00 00 00    	je     801040c5 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104014:	e8 26 ec ff ff       	call   80102c3f <kalloc>
80104019:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010401c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104020:	75 05                	jne    80104027 <pipealloc+0x61>
    goto bad;
80104022:	e9 9e 00 00 00       	jmp    801040c5 <pipealloc+0xff>
  p->readopen = 1;
80104027:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010402a:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104031:	00 00 00 
  p->writeopen = 1;
80104034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104037:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010403e:	00 00 00 
  p->nwrite = 0;
80104041:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104044:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010404b:	00 00 00 
  p->nread = 0;
8010404e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104051:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104058:	00 00 00 
  initlock(&p->lock, "pipe");
8010405b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405e:	c7 44 24 04 f4 9c 10 	movl   $0x80109cf4,0x4(%esp)
80104065:	80 
80104066:	89 04 24             	mov    %eax,(%esp)
80104069:	e8 81 21 00 00       	call   801061ef <initlock>
  (*f0)->type = FD_PIPE;
8010406e:	8b 45 08             	mov    0x8(%ebp),%eax
80104071:	8b 00                	mov    (%eax),%eax
80104073:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104079:	8b 45 08             	mov    0x8(%ebp),%eax
8010407c:	8b 00                	mov    (%eax),%eax
8010407e:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104082:	8b 45 08             	mov    0x8(%ebp),%eax
80104085:	8b 00                	mov    (%eax),%eax
80104087:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010408b:	8b 45 08             	mov    0x8(%ebp),%eax
8010408e:	8b 00                	mov    (%eax),%eax
80104090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104093:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104096:	8b 45 0c             	mov    0xc(%ebp),%eax
80104099:	8b 00                	mov    (%eax),%eax
8010409b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a4:	8b 00                	mov    (%eax),%eax
801040a6:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ad:	8b 00                	mov    (%eax),%eax
801040af:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b6:	8b 00                	mov    (%eax),%eax
801040b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040bb:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040be:	b8 00 00 00 00       	mov    $0x0,%eax
801040c3:	eb 42                	jmp    80104107 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
801040c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040c9:	74 0b                	je     801040d6 <pipealloc+0x110>
    kfree((char*)p);
801040cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ce:	89 04 24             	mov    %eax,(%esp)
801040d1:	e8 d3 ea ff ff       	call   80102ba9 <kfree>
  if(*f0)
801040d6:	8b 45 08             	mov    0x8(%ebp),%eax
801040d9:	8b 00                	mov    (%eax),%eax
801040db:	85 c0                	test   %eax,%eax
801040dd:	74 0d                	je     801040ec <pipealloc+0x126>
    fileclose(*f0);
801040df:	8b 45 08             	mov    0x8(%ebp),%eax
801040e2:	8b 00                	mov    (%eax),%eax
801040e4:	89 04 24             	mov    %eax,(%esp)
801040e7:	e8 c4 cf ff ff       	call   801010b0 <fileclose>
  if(*f1)
801040ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ef:	8b 00                	mov    (%eax),%eax
801040f1:	85 c0                	test   %eax,%eax
801040f3:	74 0d                	je     80104102 <pipealloc+0x13c>
    fileclose(*f1);
801040f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f8:	8b 00                	mov    (%eax),%eax
801040fa:	89 04 24             	mov    %eax,(%esp)
801040fd:	e8 ae cf ff ff       	call   801010b0 <fileclose>
  return -1;
80104102:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104107:	c9                   	leave  
80104108:	c3                   	ret    

80104109 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104109:	55                   	push   %ebp
8010410a:	89 e5                	mov    %esp,%ebp
8010410c:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
8010410f:	8b 45 08             	mov    0x8(%ebp),%eax
80104112:	89 04 24             	mov    %eax,(%esp)
80104115:	e8 f6 20 00 00       	call   80106210 <acquire>
  if(writable){
8010411a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010411e:	74 1f                	je     8010413f <pipeclose+0x36>
    p->writeopen = 0;
80104120:	8b 45 08             	mov    0x8(%ebp),%eax
80104123:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010412a:	00 00 00 
    wakeup(&p->nread);
8010412d:	8b 45 08             	mov    0x8(%ebp),%eax
80104130:	05 34 02 00 00       	add    $0x234,%eax
80104135:	89 04 24             	mov    %eax,(%esp)
80104138:	e8 df 15 00 00       	call   8010571c <wakeup>
8010413d:	eb 1d                	jmp    8010415c <pipeclose+0x53>
  } else {
    p->readopen = 0;
8010413f:	8b 45 08             	mov    0x8(%ebp),%eax
80104142:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104149:	00 00 00 
    wakeup(&p->nwrite);
8010414c:	8b 45 08             	mov    0x8(%ebp),%eax
8010414f:	05 38 02 00 00       	add    $0x238,%eax
80104154:	89 04 24             	mov    %eax,(%esp)
80104157:	e8 c0 15 00 00       	call   8010571c <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010415c:	8b 45 08             	mov    0x8(%ebp),%eax
8010415f:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104165:	85 c0                	test   %eax,%eax
80104167:	75 25                	jne    8010418e <pipeclose+0x85>
80104169:	8b 45 08             	mov    0x8(%ebp),%eax
8010416c:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104172:	85 c0                	test   %eax,%eax
80104174:	75 18                	jne    8010418e <pipeclose+0x85>
    release(&p->lock);
80104176:	8b 45 08             	mov    0x8(%ebp),%eax
80104179:	89 04 24             	mov    %eax,(%esp)
8010417c:	e8 f6 20 00 00       	call   80106277 <release>
    kfree((char*)p);
80104181:	8b 45 08             	mov    0x8(%ebp),%eax
80104184:	89 04 24             	mov    %eax,(%esp)
80104187:	e8 1d ea ff ff       	call   80102ba9 <kfree>
8010418c:	eb 0b                	jmp    80104199 <pipeclose+0x90>
  } else
    release(&p->lock);
8010418e:	8b 45 08             	mov    0x8(%ebp),%eax
80104191:	89 04 24             	mov    %eax,(%esp)
80104194:	e8 de 20 00 00       	call   80106277 <release>
}
80104199:	c9                   	leave  
8010419a:	c3                   	ret    

8010419b <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010419b:	55                   	push   %ebp
8010419c:	89 e5                	mov    %esp,%ebp
8010419e:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
801041a1:	8b 45 08             	mov    0x8(%ebp),%eax
801041a4:	89 04 24             	mov    %eax,(%esp)
801041a7:	e8 64 20 00 00       	call   80106210 <acquire>
  for(i = 0; i < n; i++){
801041ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041b3:	e9 a6 00 00 00       	jmp    8010425e <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801041b8:	eb 57                	jmp    80104211 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
801041ba:	8b 45 08             	mov    0x8(%ebp),%eax
801041bd:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041c3:	85 c0                	test   %eax,%eax
801041c5:	74 0d                	je     801041d4 <pipewrite+0x39>
801041c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041cd:	8b 40 24             	mov    0x24(%eax),%eax
801041d0:	85 c0                	test   %eax,%eax
801041d2:	74 15                	je     801041e9 <pipewrite+0x4e>
        release(&p->lock);
801041d4:	8b 45 08             	mov    0x8(%ebp),%eax
801041d7:	89 04 24             	mov    %eax,(%esp)
801041da:	e8 98 20 00 00       	call   80106277 <release>
        return -1;
801041df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041e4:	e9 9f 00 00 00       	jmp    80104288 <pipewrite+0xed>
      }
      wakeup(&p->nread);
801041e9:	8b 45 08             	mov    0x8(%ebp),%eax
801041ec:	05 34 02 00 00       	add    $0x234,%eax
801041f1:	89 04 24             	mov    %eax,(%esp)
801041f4:	e8 23 15 00 00       	call   8010571c <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801041f9:	8b 45 08             	mov    0x8(%ebp),%eax
801041fc:	8b 55 08             	mov    0x8(%ebp),%edx
801041ff:	81 c2 38 02 00 00    	add    $0x238,%edx
80104205:	89 44 24 04          	mov    %eax,0x4(%esp)
80104209:	89 14 24             	mov    %edx,(%esp)
8010420c:	e8 2f 14 00 00       	call   80105640 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104211:	8b 45 08             	mov    0x8(%ebp),%eax
80104214:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010421a:	8b 45 08             	mov    0x8(%ebp),%eax
8010421d:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104223:	05 00 02 00 00       	add    $0x200,%eax
80104228:	39 c2                	cmp    %eax,%edx
8010422a:	74 8e                	je     801041ba <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010422c:	8b 45 08             	mov    0x8(%ebp),%eax
8010422f:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104235:	8d 48 01             	lea    0x1(%eax),%ecx
80104238:	8b 55 08             	mov    0x8(%ebp),%edx
8010423b:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104241:	25 ff 01 00 00       	and    $0x1ff,%eax
80104246:	89 c1                	mov    %eax,%ecx
80104248:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010424b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010424e:	01 d0                	add    %edx,%eax
80104250:	0f b6 10             	movzbl (%eax),%edx
80104253:	8b 45 08             	mov    0x8(%ebp),%eax
80104256:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010425a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010425e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104261:	3b 45 10             	cmp    0x10(%ebp),%eax
80104264:	0f 8c 4e ff ff ff    	jl     801041b8 <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010426a:	8b 45 08             	mov    0x8(%ebp),%eax
8010426d:	05 34 02 00 00       	add    $0x234,%eax
80104272:	89 04 24             	mov    %eax,(%esp)
80104275:	e8 a2 14 00 00       	call   8010571c <wakeup>
  release(&p->lock);
8010427a:	8b 45 08             	mov    0x8(%ebp),%eax
8010427d:	89 04 24             	mov    %eax,(%esp)
80104280:	e8 f2 1f 00 00       	call   80106277 <release>
  return n;
80104285:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104288:	c9                   	leave  
80104289:	c3                   	ret    

8010428a <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010428a:	55                   	push   %ebp
8010428b:	89 e5                	mov    %esp,%ebp
8010428d:	53                   	push   %ebx
8010428e:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104291:	8b 45 08             	mov    0x8(%ebp),%eax
80104294:	89 04 24             	mov    %eax,(%esp)
80104297:	e8 74 1f 00 00       	call   80106210 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010429c:	eb 3a                	jmp    801042d8 <piperead+0x4e>
    if(proc->killed){
8010429e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042a4:	8b 40 24             	mov    0x24(%eax),%eax
801042a7:	85 c0                	test   %eax,%eax
801042a9:	74 15                	je     801042c0 <piperead+0x36>
      release(&p->lock);
801042ab:	8b 45 08             	mov    0x8(%ebp),%eax
801042ae:	89 04 24             	mov    %eax,(%esp)
801042b1:	e8 c1 1f 00 00       	call   80106277 <release>
      return -1;
801042b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042bb:	e9 b5 00 00 00       	jmp    80104375 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801042c0:	8b 45 08             	mov    0x8(%ebp),%eax
801042c3:	8b 55 08             	mov    0x8(%ebp),%edx
801042c6:	81 c2 34 02 00 00    	add    $0x234,%edx
801042cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801042d0:	89 14 24             	mov    %edx,(%esp)
801042d3:	e8 68 13 00 00       	call   80105640 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042d8:	8b 45 08             	mov    0x8(%ebp),%eax
801042db:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042e1:	8b 45 08             	mov    0x8(%ebp),%eax
801042e4:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042ea:	39 c2                	cmp    %eax,%edx
801042ec:	75 0d                	jne    801042fb <piperead+0x71>
801042ee:	8b 45 08             	mov    0x8(%ebp),%eax
801042f1:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042f7:	85 c0                	test   %eax,%eax
801042f9:	75 a3                	jne    8010429e <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104302:	eb 4b                	jmp    8010434f <piperead+0xc5>
    if(p->nread == p->nwrite)
80104304:	8b 45 08             	mov    0x8(%ebp),%eax
80104307:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010430d:	8b 45 08             	mov    0x8(%ebp),%eax
80104310:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104316:	39 c2                	cmp    %eax,%edx
80104318:	75 02                	jne    8010431c <piperead+0x92>
      break;
8010431a:	eb 3b                	jmp    80104357 <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010431c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010431f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104322:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104325:	8b 45 08             	mov    0x8(%ebp),%eax
80104328:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010432e:	8d 48 01             	lea    0x1(%eax),%ecx
80104331:	8b 55 08             	mov    0x8(%ebp),%edx
80104334:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010433a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010433f:	89 c2                	mov    %eax,%edx
80104341:	8b 45 08             	mov    0x8(%ebp),%eax
80104344:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104349:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010434b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010434f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104352:	3b 45 10             	cmp    0x10(%ebp),%eax
80104355:	7c ad                	jl     80104304 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104357:	8b 45 08             	mov    0x8(%ebp),%eax
8010435a:	05 38 02 00 00       	add    $0x238,%eax
8010435f:	89 04 24             	mov    %eax,(%esp)
80104362:	e8 b5 13 00 00       	call   8010571c <wakeup>
  release(&p->lock);
80104367:	8b 45 08             	mov    0x8(%ebp),%eax
8010436a:	89 04 24             	mov    %eax,(%esp)
8010436d:	e8 05 1f 00 00       	call   80106277 <release>
  return i;
80104372:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104375:	83 c4 24             	add    $0x24,%esp
80104378:	5b                   	pop    %ebx
80104379:	5d                   	pop    %ebp
8010437a:	c3                   	ret    

8010437b <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010437b:	55                   	push   %ebp
8010437c:	89 e5                	mov    %esp,%ebp
8010437e:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104381:	9c                   	pushf  
80104382:	58                   	pop    %eax
80104383:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104386:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104389:	c9                   	leave  
8010438a:	c3                   	ret    

8010438b <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010438b:	55                   	push   %ebp
8010438c:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010438e:	fb                   	sti    
}
8010438f:	5d                   	pop    %ebp
80104390:	c3                   	ret    

80104391 <check_pgdir_counter_and_call_freevm>:
int pgdir_ref_next_idx = 0;


// Design Dcoument 2-1-2-4
void
check_pgdir_counter_and_call_freevm(struct proc* p) {
80104391:	55                   	push   %ebp
80104392:	89 e5                	mov    %esp,%ebp
80104394:	83 ec 18             	sub    $0x18,%esp
  if (p->pgdir_ref_idx == -1) {
80104397:	8b 45 08             	mov    0x8(%ebp),%eax
8010439a:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801043a0:	83 f8 ff             	cmp    $0xffffffff,%eax
801043a3:	75 10                	jne    801043b5 <check_pgdir_counter_and_call_freevm+0x24>
    // This is a case in booting
    freevm(p->pgdir);
801043a5:	8b 45 08             	mov    0x8(%ebp),%eax
801043a8:	8b 40 04             	mov    0x4(%eax),%eax
801043ab:	89 04 24             	mov    %eax,(%esp)
801043ae:	e8 96 52 00 00       	call   80109649 <freevm>
801043b3:	eb 7d                	jmp    80104432 <check_pgdir_counter_and_call_freevm+0xa1>
  } else if (pgdir_ref[p->pgdir_ref_idx] <= 1) {
801043b5:	8b 45 08             	mov    0x8(%ebp),%eax
801043b8:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801043be:	0f b6 80 80 5e 11 80 	movzbl -0x7feea180(%eax),%eax
801043c5:	3c 01                	cmp    $0x1,%al
801043c7:	7f 38                	jg     80104401 <check_pgdir_counter_and_call_freevm+0x70>
    // Just only one process was using pgdir.
    // Free it.
    acquire(&thread_lock);
801043c9:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
801043d0:	e8 3b 1e 00 00       	call   80106210 <acquire>
    pgdir_ref[p->pgdir_ref_idx] = 0;
801043d5:	8b 45 08             	mov    0x8(%ebp),%eax
801043d8:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801043de:	c6 80 80 5e 11 80 00 	movb   $0x0,-0x7feea180(%eax)
    release(&thread_lock);
801043e5:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
801043ec:	e8 86 1e 00 00       	call   80106277 <release>
    freevm(p->pgdir);
801043f1:	8b 45 08             	mov    0x8(%ebp),%eax
801043f4:	8b 40 04             	mov    0x4(%eax),%eax
801043f7:	89 04 24             	mov    %eax,(%esp)
801043fa:	e8 4a 52 00 00       	call   80109649 <freevm>
801043ff:	eb 31                	jmp    80104432 <check_pgdir_counter_and_call_freevm+0xa1>
  } else {
    // There is a thread using a same addres space.
    // Do not free it.
    // Referencing counter should be decreased.
    acquire(&thread_lock);
80104401:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
80104408:	e8 03 1e 00 00       	call   80106210 <acquire>
    pgdir_ref[p->pgdir_ref_idx]--;
8010440d:	8b 45 08             	mov    0x8(%ebp),%eax
80104410:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104416:	0f b6 90 80 5e 11 80 	movzbl -0x7feea180(%eax),%edx
8010441d:	83 ea 01             	sub    $0x1,%edx
80104420:	88 90 80 5e 11 80    	mov    %dl,-0x7feea180(%eax)
    release(&thread_lock);
80104426:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
8010442d:	e8 45 1e 00 00       	call   80106277 <release>
  }
}
80104432:	c9                   	leave  
80104433:	c3                   	ret    

80104434 <allocate_new_pgdir_idx>:

void
allocate_new_pgdir_idx(struct proc* p) {
80104434:	55                   	push   %ebp
80104435:	89 e5                	mov    %esp,%ebp
80104437:	83 ec 28             	sub    $0x28,%esp
  int i;
  acquire(&thread_lock);
8010443a:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
80104441:	e8 ca 1d 00 00       	call   80106210 <acquire>

  // find a counter to use
  for (i = 0; i < NPROC; ++i) {
80104446:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010444d:	eb 74                	jmp    801044c3 <allocate_new_pgdir_idx+0x8f>
    if (pgdir_ref[pgdir_ref_next_idx] == 0) {
8010444f:	a1 64 d6 10 80       	mov    0x8010d664,%eax
80104454:	0f b6 80 80 5e 11 80 	movzbl -0x7feea180(%eax),%eax
8010445b:	84 c0                	test   %al,%al
8010445d:	75 3e                	jne    8010449d <allocate_new_pgdir_idx+0x69>
      p->pgdir_ref_idx = pgdir_ref_next_idx++;
8010445f:	a1 64 d6 10 80       	mov    0x8010d664,%eax
80104464:	8d 50 01             	lea    0x1(%eax),%edx
80104467:	89 15 64 d6 10 80    	mov    %edx,0x8010d664
8010446d:	8b 55 08             	mov    0x8(%ebp),%edx
80104470:	89 82 98 00 00 00    	mov    %eax,0x98(%edx)
      pgdir_ref_next_idx %= NPROC;
80104476:	a1 64 d6 10 80       	mov    0x8010d664,%eax
8010447b:	99                   	cltd   
8010447c:	c1 ea 1a             	shr    $0x1a,%edx
8010447f:	01 d0                	add    %edx,%eax
80104481:	83 e0 3f             	and    $0x3f,%eax
80104484:	29 d0                	sub    %edx,%eax
80104486:	a3 64 d6 10 80       	mov    %eax,0x8010d664
      pgdir_ref[p->pgdir_ref_idx] = 1;
8010448b:	8b 45 08             	mov    0x8(%ebp),%eax
8010448e:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104494:	c6 80 80 5e 11 80 01 	movb   $0x1,-0x7feea180(%eax)
      break;
8010449b:	eb 2c                	jmp    801044c9 <allocate_new_pgdir_idx+0x95>
    } else {
      pgdir_ref_next_idx++;
8010449d:	a1 64 d6 10 80       	mov    0x8010d664,%eax
801044a2:	83 c0 01             	add    $0x1,%eax
801044a5:	a3 64 d6 10 80       	mov    %eax,0x8010d664
      pgdir_ref_next_idx %= NPROC;
801044aa:	a1 64 d6 10 80       	mov    0x8010d664,%eax
801044af:	99                   	cltd   
801044b0:	c1 ea 1a             	shr    $0x1a,%edx
801044b3:	01 d0                	add    %edx,%eax
801044b5:	83 e0 3f             	and    $0x3f,%eax
801044b8:	29 d0                	sub    %edx,%eax
801044ba:	a3 64 d6 10 80       	mov    %eax,0x8010d664
allocate_new_pgdir_idx(struct proc* p) {
  int i;
  acquire(&thread_lock);

  // find a counter to use
  for (i = 0; i < NPROC; ++i) {
801044bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044c3:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801044c7:	7e 86                	jle    8010444f <allocate_new_pgdir_idx+0x1b>
      pgdir_ref_next_idx %= NPROC;
    }
  }

  //TODO: Do not panic. Just sleep until a counter is available
  if (i == NPROC) {
801044c9:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
801044cd:	75 0c                	jne    801044db <allocate_new_pgdir_idx+0xa7>
    panic("(allocate_new_pgdir_idx): pgdir referencing counter allocation is failed.\n");
801044cf:	c7 04 24 fc 9c 10 80 	movl   $0x80109cfc,(%esp)
801044d6:	e8 87 c0 ff ff       	call   80100562 <panic>
  }

  release(&thread_lock);
801044db:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
801044e2:	e8 90 1d 00 00       	call   80106277 <release>
}
801044e7:	c9                   	leave  
801044e8:	c3                   	ret    

801044e9 <get_time_quantum>:


// getters and setters
int
get_time_quantum() 
{
801044e9:	55                   	push   %ebp
801044ea:	89 e5                	mov    %esp,%ebp
  if(proc && proc->cpu_share != 0){
801044ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044f2:	85 c0                	test   %eax,%eax
801044f4:	74 17                	je     8010450d <get_time_quantum+0x24>
801044f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044fc:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104502:	85 c0                	test   %eax,%eax
80104504:	74 07                	je     8010450d <get_time_quantum+0x24>
    return ptable.stride_time_quantum;
80104506:	a1 18 88 11 80       	mov    0x80118818,%eax
8010450b:	eb 18                	jmp    80104525 <get_time_quantum+0x3c>
  }else{
    return ptable.MLFQ_time_quantum[proc->level_of_MLFQ];
8010450d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104513:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104519:	05 0c 0a 00 00       	add    $0xa0c,%eax
8010451e:	8b 04 85 c4 5e 11 80 	mov    -0x7feea13c(,%eax,4),%eax
  }
}
80104525:	5d                   	pop    %ebp
80104526:	c3                   	ret    

80104527 <get_MLFQ_tick_used>:

// Design Document 1-1-2-4
int
get_MLFQ_tick_used(void)
{
80104527:	55                   	push   %ebp
80104528:	89 e5                	mov    %esp,%ebp
  return ptable.MLFQ_tick_used;
8010452a:	a1 00 87 11 80       	mov    0x80118700,%eax
}
8010452f:	5d                   	pop    %ebp
80104530:	c3                   	ret    

80104531 <increase_MLFQ_tick_used>:

void
increase_MLFQ_tick_used(void)
{
80104531:	55                   	push   %ebp
80104532:	89 e5                	mov    %esp,%ebp
  ptable.MLFQ_tick_used++;
80104534:	a1 00 87 11 80       	mov    0x80118700,%eax
80104539:	83 c0 01             	add    $0x1,%eax
8010453c:	a3 00 87 11 80       	mov    %eax,0x80118700
#ifdef STRIRDE_DEBUGGING
  cprintf("\rMLFQ_tick_used: %d", ptable.MLFQ_tick_used);
#endif
}
80104541:	5d                   	pop    %ebp
80104542:	c3                   	ret    

80104543 <increase_stride_tick_used>:

void
increase_stride_tick_used(void)
{
80104543:	55                   	push   %ebp
80104544:	89 e5                	mov    %esp,%ebp
  ptable.stride_tick_used++;
80104546:	a1 1c 88 11 80       	mov    0x8011881c,%eax
8010454b:	83 c0 01             	add    $0x1,%eax
8010454e:	a3 1c 88 11 80       	mov    %eax,0x8011881c
#ifdef STRIRDE_DEBUGGING
  cprintf("\rstride_tick_used: %d", ptable.stride_tick_used);
#endif
}
80104553:	5d                   	pop    %ebp
80104554:	c3                   	ret    

80104555 <pinit>:


void
pinit(void)
{
80104555:	55                   	push   %ebp
80104556:	89 e5                	mov    %esp,%ebp
80104558:	83 ec 28             	sub    $0x28,%esp
  // Design Document 1-1-2-4. Initializing the time_quantum array.
  int queue_level;
  int default_ticks = 5;
8010455b:	c7 45 f0 05 00 00 00 	movl   $0x5,-0x10(%ebp)
  initlock(&ptable.lock, "ptable");
80104562:	c7 44 24 04 47 9d 10 	movl   $0x80109d47,0x4(%esp)
80104569:	80 
8010456a:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80104571:	e8 79 1c 00 00       	call   801061ef <initlock>

  // Initializing ptable variables.
  // Design Document 1-2-2-3.
  // Initializing time quantum
  for(queue_level = 0; queue_level < NMLFQ; ++queue_level){
80104576:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010457d:	eb 1a                	jmp    80104599 <pinit+0x44>
      ptable.MLFQ_time_quantum[queue_level] = default_ticks;
8010457f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104582:	8d 90 0c 0a 00 00    	lea    0xa0c(%eax),%edx
80104588:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010458b:	89 04 95 c4 5e 11 80 	mov    %eax,-0x7feea13c(,%edx,4)
      default_ticks *= 2;
80104592:	d1 65 f0             	shll   -0x10(%ebp)
  initlock(&ptable.lock, "ptable");

  // Initializing ptable variables.
  // Design Document 1-2-2-3.
  // Initializing time quantum
  for(queue_level = 0; queue_level < NMLFQ; ++queue_level){
80104595:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104599:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
8010459d:	7e e0                	jle    8010457f <pinit+0x2a>
      ptable.MLFQ_time_quantum[queue_level] = default_ticks;
      default_ticks *= 2;
  }
  ptable.MLFQ_tick_used = 0;
8010459f:	c7 05 00 87 11 80 00 	movl   $0x0,0x80118700
801045a6:	00 00 00 

  ptable.queue_level_at_most = NMLFQ - 1;
801045a9:	c7 05 04 87 11 80 02 	movl   $0x2,0x80118704
801045b0:	00 00 00 
  ptable.min_of_run_proc_level = NMLFQ - 1;
801045b3:	c7 05 08 87 11 80 02 	movl   $0x2,0x80118708
801045ba:	00 00 00 

  memset(ptable.stride_queue, 0, sizeof(ptable.stride_queue));
801045bd:	c7 44 24 08 04 01 00 	movl   $0x104,0x8(%esp)
801045c4:	00 
801045c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801045cc:	00 
801045cd:	c7 04 24 0c 87 11 80 	movl   $0x8011870c,(%esp)
801045d4:	e8 a0 1e 00 00       	call   80106479 <memset>
  ptable.sum_cpu_share = 0;
801045d9:	c7 05 10 88 11 80 00 	movl   $0x0,0x80118810
801045e0:	00 00 00 
  ptable.stride_queue_size = 0;
801045e3:	c7 05 14 88 11 80 00 	movl   $0x0,0x80118814
801045ea:	00 00 00 
  ptable.stride_time_quantum = 1; // It could be changed by designer.
801045ed:	c7 05 18 88 11 80 01 	movl   $0x1,0x80118818
801045f4:	00 00 00 
  ptable.stride_tick_used = 0;
801045f7:	c7 05 1c 88 11 80 00 	movl   $0x0,0x8011881c
801045fe:	00 00 00 

}
80104601:	c9                   	leave  
80104602:	c3                   	ret    

80104603 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104603:	55                   	push   %ebp
80104604:	89 e5                	mov    %esp,%ebp
80104606:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104609:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80104610:	e8 fb 1b 00 00       	call   80106210 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104615:	c7 45 f4 f4 5e 11 80 	movl   $0x80115ef4,-0xc(%ebp)
8010461c:	e9 c9 00 00 00       	jmp    801046ea <allocproc+0xe7>
    if(p->state == UNUSED)
80104621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104624:	8b 40 0c             	mov    0xc(%eax),%eax
80104627:	85 c0                	test   %eax,%eax
80104629:	0f 85 b4 00 00 00    	jne    801046e3 <allocproc+0xe0>
      goto found;
8010462f:	90                   	nop

  
  return 0;

found:
  p->state = EMBRYO;
80104630:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104633:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010463a:	a1 04 d0 10 80       	mov    0x8010d004,%eax
8010463f:	8d 50 01             	lea    0x1(%eax),%edx
80104642:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
80104648:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010464b:	89 42 10             	mov    %eax,0x10(%edx)
  
  // Design Document 1-1-2-2.
  // initializing values used in MLFQ.
  p->tick_used = 0;
8010464e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104651:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  p->level_of_MLFQ = 0;
80104658:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104662:	00 00 00 
  p->time_quantum_used = 0;
80104665:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104668:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010466f:	00 00 00 

  // Design Document 1-2-2-2.
  // Initializing cpu_share
  p->cpu_share = 0;
80104672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104675:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010467c:	00 00 00 
  p->stride = 0;
8010467f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104682:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104689:	00 00 00 
  p->stride_count = 0;
8010468c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104696:	00 00 00 

  // Design Document 2-1-2-2
  // Related with threads.
  p->tid = 0;
80104699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010469c:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
801046a3:	00 00 00 
  p->pgdir_ref_idx = -1;
801046a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a9:	c7 80 98 00 00 00 ff 	movl   $0xffffffff,0x98(%eax)
801046b0:	ff ff ff 
  p->thread_return = 0;
801046b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b6:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%eax)
801046bd:	00 00 00 

  release(&ptable.lock);
801046c0:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
801046c7:	e8 ab 1b 00 00       	call   80106277 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801046cc:	e8 6e e5 ff ff       	call   80102c3f <kalloc>
801046d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046d4:	89 42 08             	mov    %eax,0x8(%edx)
801046d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046da:	8b 40 08             	mov    0x8(%eax),%eax
801046dd:	85 c0                	test   %eax,%eax
801046df:	75 3a                	jne    8010471b <allocproc+0x118>
801046e1:	eb 27                	jmp    8010470a <allocproc+0x107>
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046e3:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
801046ea:	81 7d f4 f4 86 11 80 	cmpl   $0x801186f4,-0xc(%ebp)
801046f1:	0f 82 2a ff ff ff    	jb     80104621 <allocproc+0x1e>
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801046f7:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
801046fe:	e8 74 1b 00 00       	call   80106277 <release>
#ifdef THREAD_DEBUGGING
  cprintf("(allocproc) error: Proc queue is full!\n");
#endif

  
  return 0;
80104703:	b8 00 00 00 00       	mov    $0x0,%eax
80104708:	eb 76                	jmp    80104780 <allocproc+0x17d>

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010470a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)

#ifdef THREAD_DEBUGGING
    cprintf("(allocproc) error: kalloc() is failed.\n");
#endif
    return 0;
80104714:	b8 00 00 00 00       	mov    $0x0,%eax
80104719:	eb 65                	jmp    80104780 <allocproc+0x17d>
  }
  sp = p->kstack + KSTACKSIZE;
8010471b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471e:	8b 40 08             	mov    0x8(%eax),%eax
80104721:	05 00 10 00 00       	add    $0x1000,%eax
80104726:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104729:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010472d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104730:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104733:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104736:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010473a:	ba 9f 78 10 80       	mov    $0x8010789f,%edx
8010473f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104742:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104744:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010474e:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104754:	8b 40 1c             	mov    0x1c(%eax),%eax
80104757:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010475e:	00 
8010475f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104766:	00 
80104767:	89 04 24             	mov    %eax,(%esp)
8010476a:	e8 0a 1d 00 00       	call   80106479 <memset>
  p->context->eip = (uint)forkret;
8010476f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104772:	8b 40 1c             	mov    0x1c(%eax),%eax
80104775:	ba 01 56 10 80       	mov    $0x80105601,%edx
8010477a:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
8010477d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104780:	c9                   	leave  
80104781:	c3                   	ret    

80104782 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104782:	55                   	push   %ebp
80104783:	89 e5                	mov    %esp,%ebp
80104785:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104788:	e8 76 fe ff ff       	call   80104603 <allocproc>
8010478d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80104790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104793:	a3 68 d6 10 80       	mov    %eax,0x8010d668
  if((p->pgdir = setupkvm()) == 0)
80104798:	e8 05 49 00 00       	call   801090a2 <setupkvm>
8010479d:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047a0:	89 42 04             	mov    %eax,0x4(%edx)
801047a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a6:	8b 40 04             	mov    0x4(%eax),%eax
801047a9:	85 c0                	test   %eax,%eax
801047ab:	75 0c                	jne    801047b9 <userinit+0x37>
    panic("userinit: out of memory?");
801047ad:	c7 04 24 4e 9d 10 80 	movl   $0x80109d4e,(%esp)
801047b4:	e8 a9 bd ff ff       	call   80100562 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047b9:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c1:	8b 40 04             	mov    0x4(%eax),%eax
801047c4:	89 54 24 08          	mov    %edx,0x8(%esp)
801047c8:	c7 44 24 04 00 d5 10 	movl   $0x8010d500,0x4(%esp)
801047cf:	80 
801047d0:	89 04 24             	mov    %eax,(%esp)
801047d3:	e8 2a 4b 00 00       	call   80109302 <inituvm>
  p->sz = PGSIZE;
801047d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047db:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801047e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e4:	8b 40 18             	mov    0x18(%eax),%eax
801047e7:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801047ee:	00 
801047ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801047f6:	00 
801047f7:	89 04 24             	mov    %eax,(%esp)
801047fa:	e8 7a 1c 00 00       	call   80106479 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801047ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104802:	8b 40 18             	mov    0x18(%eax),%eax
80104805:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010480b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480e:	8b 40 18             	mov    0x18(%eax),%eax
80104811:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104817:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481a:	8b 40 18             	mov    0x18(%eax),%eax
8010481d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104820:	8b 52 18             	mov    0x18(%edx),%edx
80104823:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104827:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010482b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482e:	8b 40 18             	mov    0x18(%eax),%eax
80104831:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104834:	8b 52 18             	mov    0x18(%edx),%edx
80104837:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010483b:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010483f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104842:	8b 40 18             	mov    0x18(%eax),%eax
80104845:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010484c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484f:	8b 40 18             	mov    0x18(%eax),%eax
80104852:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104859:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485c:	8b 40 18             	mov    0x18(%eax),%eax
8010485f:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104869:	83 c0 6c             	add    $0x6c,%eax
8010486c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104873:	00 
80104874:	c7 44 24 04 67 9d 10 	movl   $0x80109d67,0x4(%esp)
8010487b:	80 
8010487c:	89 04 24             	mov    %eax,(%esp)
8010487f:	e8 15 1e 00 00       	call   80106699 <safestrcpy>
  p->cwd = namei("/");
80104884:	c7 04 24 70 9d 10 80 	movl   $0x80109d70,(%esp)
8010488b:	e8 78 dc ff ff       	call   80102508 <namei>
80104890:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104893:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80104896:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
8010489d:	e8 6e 19 00 00       	call   80106210 <acquire>

  p->state = RUNNABLE;
801048a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801048ac:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
801048b3:	e8 bf 19 00 00       	call   80106277 <release>
}
801048b8:	c9                   	leave  
801048b9:	c3                   	ret    

801048ba <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801048ba:	55                   	push   %ebp
801048bb:	89 e5                	mov    %esp,%ebp
801048bd:	83 ec 28             	sub    $0x28,%esp
  uint sz;

  sz = proc->sz;
801048c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c6:	8b 00                	mov    (%eax),%eax
801048c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801048cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801048cf:	7e 34                	jle    80104905 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801048d1:	8b 55 08             	mov    0x8(%ebp),%edx
801048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d7:	01 c2                	add    %eax,%edx
801048d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048df:	8b 40 04             	mov    0x4(%eax),%eax
801048e2:	89 54 24 08          	mov    %edx,0x8(%esp)
801048e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048e9:	89 54 24 04          	mov    %edx,0x4(%esp)
801048ed:	89 04 24             	mov    %eax,(%esp)
801048f0:	e8 78 4b 00 00       	call   8010946d <allocuvm>
801048f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048fc:	75 41                	jne    8010493f <growproc+0x85>
      return -1;
801048fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104903:	eb 58                	jmp    8010495d <growproc+0xa3>
  }else if(n < 0){
80104905:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104909:	79 34                	jns    8010493f <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010490b:	8b 55 08             	mov    0x8(%ebp),%edx
8010490e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104911:	01 c2                	add    %eax,%edx
80104913:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104919:	8b 40 04             	mov    0x4(%eax),%eax
8010491c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104920:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104923:	89 54 24 04          	mov    %edx,0x4(%esp)
80104927:	89 04 24             	mov    %eax,(%esp)
8010492a:	e8 54 4c 00 00       	call   80109583 <deallocuvm>
8010492f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104932:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104936:	75 07                	jne    8010493f <growproc+0x85>
      return -1;
80104938:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010493d:	eb 1e                	jmp    8010495d <growproc+0xa3>
  }
  proc->sz = sz;
8010493f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104945:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104948:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010494a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104950:	89 04 24             	mov    %eax,(%esp)
80104953:	e8 16 48 00 00       	call   8010916e <switchuvm>
  return 0;
80104958:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010495d:	c9                   	leave  
8010495e:	c3                   	ret    

8010495f <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010495f:	55                   	push   %ebp
80104960:	89 e5                	mov    %esp,%ebp
80104962:	57                   	push   %edi
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
80104965:	83 ec 2c             	sub    $0x2c,%esp
  // TODO: 'stressfs' is failed because of handling a opened file.
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80104968:	e8 96 fc ff ff       	call   80104603 <allocproc>
8010496d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104970:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104974:	75 0a                	jne    80104980 <fork+0x21>
    return -1;
80104976:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010497b:	e9 5d 01 00 00       	jmp    80104add <fork+0x17e>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104980:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104986:	8b 10                	mov    (%eax),%edx
80104988:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010498e:	8b 40 04             	mov    0x4(%eax),%eax
80104991:	89 54 24 04          	mov    %edx,0x4(%esp)
80104995:	89 04 24             	mov    %eax,(%esp)
80104998:	e8 89 4d 00 00       	call   80109726 <copyuvm>
8010499d:	8b 55 e0             	mov    -0x20(%ebp),%edx
801049a0:	89 42 04             	mov    %eax,0x4(%edx)
801049a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049a6:	8b 40 04             	mov    0x4(%eax),%eax
801049a9:	85 c0                	test   %eax,%eax
801049ab:	75 2c                	jne    801049d9 <fork+0x7a>
    kfree(np->kstack);
801049ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049b0:	8b 40 08             	mov    0x8(%eax),%eax
801049b3:	89 04 24             	mov    %eax,(%esp)
801049b6:	e8 ee e1 ff ff       	call   80102ba9 <kfree>
    np->kstack = 0;
801049bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801049c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801049cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049d4:	e9 04 01 00 00       	jmp    80104add <fork+0x17e>
  }
  np->sz = proc->sz;
801049d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049df:	8b 10                	mov    (%eax),%edx
801049e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049e4:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801049e6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049f0:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801049f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049f6:	8b 50 18             	mov    0x18(%eax),%edx
801049f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ff:	8b 40 18             	mov    0x18(%eax),%eax
80104a02:	89 c3                	mov    %eax,%ebx
80104a04:	b8 13 00 00 00       	mov    $0x13,%eax
80104a09:	89 d7                	mov    %edx,%edi
80104a0b:	89 de                	mov    %ebx,%esi
80104a0d:	89 c1                	mov    %eax,%ecx
80104a0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // new pgdir is generated. allocate a counter to np
  allocate_new_pgdir_idx(np);
80104a11:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a14:	89 04 24             	mov    %eax,(%esp)
80104a17:	e8 18 fa ff ff       	call   80104434 <allocate_new_pgdir_idx>

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104a1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a1f:	8b 40 18             	mov    0x18(%eax),%eax
80104a22:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104a29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104a30:	eb 3d                	jmp    80104a6f <fork+0x110>
    if(proc->ofile[i])
80104a32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a3b:	83 c2 08             	add    $0x8,%edx
80104a3e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a42:	85 c0                	test   %eax,%eax
80104a44:	74 25                	je     80104a6b <fork+0x10c>
      np->ofile[i] = filedup(proc->ofile[i]);
80104a46:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a4f:	83 c2 08             	add    $0x8,%edx
80104a52:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a56:	89 04 24             	mov    %eax,(%esp)
80104a59:	e8 0a c6 ff ff       	call   80101068 <filedup>
80104a5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104a61:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104a64:	83 c1 08             	add    $0x8,%ecx
80104a67:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  allocate_new_pgdir_idx(np);

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104a6b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104a6f:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104a73:	7e bd                	jle    80104a32 <fork+0xd3>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104a75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7b:	8b 40 68             	mov    0x68(%eax),%eax
80104a7e:	89 04 24             	mov    %eax,(%esp)
80104a81:	e8 28 cf ff ff       	call   801019ae <idup>
80104a86:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104a89:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104a8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a92:	8d 50 6c             	lea    0x6c(%eax),%edx
80104a95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a98:	83 c0 6c             	add    $0x6c,%eax
80104a9b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104aa2:	00 
80104aa3:	89 54 24 04          	mov    %edx,0x4(%esp)
80104aa7:	89 04 24             	mov    %eax,(%esp)
80104aaa:	e8 ea 1b 00 00       	call   80106699 <safestrcpy>

  pid = np->pid;
80104aaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ab2:	8b 40 10             	mov    0x10(%eax),%eax
80104ab5:	89 45 dc             	mov    %eax,-0x24(%ebp)

  acquire(&ptable.lock);
80104ab8:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80104abf:	e8 4c 17 00 00       	call   80106210 <acquire>

  np->state = RUNNABLE;
80104ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ac7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  //Design Document 1-1-2-5. A new process is generated.

  release(&ptable.lock);
80104ace:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80104ad5:	e8 9d 17 00 00       	call   80106277 <release>

  return pid;
80104ada:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104add:	83 c4 2c             	add    $0x2c,%esp
80104ae0:	5b                   	pop    %ebx
80104ae1:	5e                   	pop    %esi
80104ae2:	5f                   	pop    %edi
80104ae3:	5d                   	pop    %ebp
80104ae4:	c3                   	ret    

80104ae5 <stride_queue_delete>:

void stride_queue_delete() {
80104ae5:	55                   	push   %ebp
80104ae6:	89 e5                	mov    %esp,%ebp
80104ae8:	83 ec 28             	sub    $0x28,%esp
#ifdef MJ_DEBUGGING
  cprintf("stirde_queue process exit()\n");
#endif

  // subtract cpu_share from sum_cpu_share
  ptable.sum_cpu_share -= proc->cpu_share;
80104aeb:	8b 15 10 88 11 80    	mov    0x80118810,%edx
80104af1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af7:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104afd:	29 c2                	sub    %eax,%edx
80104aff:	89 d0                	mov    %edx,%eax
80104b01:	a3 10 88 11 80       	mov    %eax,0x80118810

  // find where it is in the stride queue
  for(stride_idx = 1; stride_idx < NSTRIDE_QUEUE; ++stride_idx){
80104b06:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80104b0d:	eb 1f                	jmp    80104b2e <stride_queue_delete+0x49>
    if(ptable.stride_queue[stride_idx] == proc){
80104b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b12:	05 10 0a 00 00       	add    $0xa10,%eax
80104b17:	8b 14 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%edx
80104b1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b24:	39 c2                	cmp    %eax,%edx
80104b26:	75 02                	jne    80104b2a <stride_queue_delete+0x45>
      break;
80104b28:	eb 0a                	jmp    80104b34 <stride_queue_delete+0x4f>

  // subtract cpu_share from sum_cpu_share
  ptable.sum_cpu_share -= proc->cpu_share;

  // find where it is in the stride queue
  for(stride_idx = 1; stride_idx < NSTRIDE_QUEUE; ++stride_idx){
80104b2a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104b2e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
80104b32:	7e db                	jle    80104b0f <stride_queue_delete+0x2a>
    if(ptable.stride_queue[stride_idx] == proc){
      break;
    }
  }

  if(stride_idx == NSTRIDE_QUEUE){
80104b34:	83 7d f4 41          	cmpl   $0x41,-0xc(%ebp)
80104b38:	75 0c                	jne    80104b46 <stride_queue_delete+0x61>
    panic("exit(): a process is not in the stride scheduler");
80104b3a:	c7 04 24 74 9d 10 80 	movl   $0x80109d74,(%esp)
80104b41:	e8 1c ba ff ff       	call   80100562 <panic>
  }

  // delete a process from the heap
  ptable.stride_queue[stride_idx] = ptable.stride_queue[ptable.stride_queue_size];
80104b46:	a1 14 88 11 80       	mov    0x80118814,%eax
80104b4b:	05 10 0a 00 00       	add    $0xa10,%eax
80104b50:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80104b57:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b5a:	81 c2 10 0a 00 00    	add    $0xa10,%edx
80104b60:	89 04 95 cc 5e 11 80 	mov    %eax,-0x7feea134(,%edx,4)
  ptable.stride_queue[ptable.stride_queue_size--] = 0;
80104b67:	a1 14 88 11 80       	mov    0x80118814,%eax
80104b6c:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b6f:	89 15 14 88 11 80    	mov    %edx,0x80118814
80104b75:	05 10 0a 00 00       	add    $0xa10,%eax
80104b7a:	c7 04 85 cc 5e 11 80 	movl   $0x0,-0x7feea134(,%eax,4)
80104b81:	00 00 00 00 

  // do heapify
  if(stride_idx == 1){
80104b85:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80104b89:	75 09                	jne    80104b94 <stride_queue_delete+0xaf>
    //heapify_down
    heapify_up = 0;
80104b8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104b92:	eb 3e                	jmp    80104bd2 <stride_queue_delete+0xed>
  }else{
    //select heapify_up or down
    heapify_up = ptable.stride_queue[stride_idx]->stride_count 
80104b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b97:	05 10 0a 00 00       	add    $0xa10,%eax
80104b9c:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80104ba3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
                 < ptable.stride_queue[stride_idx / 2]->stride_count 
80104ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bac:	89 c1                	mov    %eax,%ecx
80104bae:	c1 e9 1f             	shr    $0x1f,%ecx
80104bb1:	01 c8                	add    %ecx,%eax
80104bb3:	d1 f8                	sar    %eax
80104bb5:	05 10 0a 00 00       	add    $0xa10,%eax
80104bba:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80104bc1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
                 ? 1 : 0;
80104bc7:	39 c2                	cmp    %eax,%edx
80104bc9:	0f 9c c0             	setl   %al
  if(stride_idx == 1){
    //heapify_down
    heapify_up = 0;
  }else{
    //select heapify_up or down
    heapify_up = ptable.stride_queue[stride_idx]->stride_count 
80104bcc:	0f b6 c0             	movzbl %al,%eax
80104bcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
                 < ptable.stride_queue[stride_idx / 2]->stride_count 
                 ? 1 : 0;
  }

  if(ptable.stride_queue_size == 0 || ptable.stride_queue_size == 1){
80104bd2:	a1 14 88 11 80       	mov    0x80118814,%eax
80104bd7:	85 c0                	test   %eax,%eax
80104bd9:	74 28                	je     80104c03 <stride_queue_delete+0x11e>
80104bdb:	a1 14 88 11 80       	mov    0x80118814,%eax
80104be0:	83 f8 01             	cmp    $0x1,%eax
80104be3:	74 1e                	je     80104c03 <stride_queue_delete+0x11e>
    //do nothing
  }else{
    // increase key
    if(heapify_up){
80104be5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104be9:	74 0d                	je     80104bf8 <stride_queue_delete+0x113>
      stride_queue_heapify_down(stride_idx);
80104beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bee:	89 04 24             	mov    %eax,(%esp)
80104bf1:	e8 81 03 00 00       	call   80104f77 <stride_queue_heapify_down>
80104bf6:	eb 0b                	jmp    80104c03 <stride_queue_delete+0x11e>
    }else{
      stride_queue_heapify_up(stride_idx);
80104bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bfb:	89 04 24             	mov    %eax,(%esp)
80104bfe:	e8 d9 02 00 00       	call   80104edc <stride_queue_heapify_up>
    }
  }

}
80104c03:	c9                   	leave  
80104c04:	c3                   	ret    

80104c05 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104c05:	55                   	push   %ebp
80104c06:	89 e5                	mov    %esp,%ebp
80104c08:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104c0b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c12:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104c17:	39 c2                	cmp    %eax,%edx
80104c19:	75 0c                	jne    80104c27 <exit+0x22>
    panic("init exiting");
80104c1b:	c7 04 24 a5 9d 10 80 	movl   $0x80109da5,(%esp)
80104c22:	e8 3b b9 ff ff       	call   80100562 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c27:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c2e:	eb 44                	jmp    80104c74 <exit+0x6f>
    if(proc->ofile[fd]){
80104c30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c36:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c39:	83 c2 08             	add    $0x8,%edx
80104c3c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c40:	85 c0                	test   %eax,%eax
80104c42:	74 2c                	je     80104c70 <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104c44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c4d:	83 c2 08             	add    $0x8,%edx
80104c50:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c54:	89 04 24             	mov    %eax,(%esp)
80104c57:	e8 54 c4 ff ff       	call   801010b0 <fileclose>
      proc->ofile[fd] = 0;
80104c5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c62:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c65:	83 c2 08             	add    $0x8,%edx
80104c68:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104c6f:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c70:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104c74:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104c78:	7e b6                	jle    80104c30 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104c7a:	e8 28 e9 ff ff       	call   801035a7 <begin_op>
  iput(proc->cwd);
80104c7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c85:	8b 40 68             	mov    0x68(%eax),%eax
80104c88:	89 04 24             	mov    %eax,(%esp)
80104c8b:	e8 ab ce ff ff       	call   80101b3b <iput>
  end_op();
80104c90:	e8 96 e9 ff ff       	call   8010362b <end_op>
  proc->cwd = 0;
80104c95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c9b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104ca2:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80104ca9:	e8 62 15 00 00       	call   80106210 <acquire>

  // delete a process in stride queue
  if(proc->cpu_share != 0){
80104cae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cb4:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104cba:	85 c0                	test   %eax,%eax
80104cbc:	74 05                	je     80104cc3 <exit+0xbe>
    stride_queue_delete();
80104cbe:	e8 22 fe ff ff       	call   80104ae5 <stride_queue_delete>
  }

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104cc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc9:	8b 40 14             	mov    0x14(%eax),%eax
80104ccc:	89 04 24             	mov    %eax,(%esp)
80104ccf:	e8 07 0a 00 00       	call   801056db <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cd4:	c7 45 f4 f4 5e 11 80 	movl   $0x80115ef4,-0xc(%ebp)
80104cdb:	eb 3b                	jmp    80104d18 <exit+0x113>
    if(p->parent == proc){
80104cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce0:	8b 50 14             	mov    0x14(%eax),%edx
80104ce3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ce9:	39 c2                	cmp    %eax,%edx
80104ceb:	75 24                	jne    80104d11 <exit+0x10c>
      p->parent = initproc;
80104ced:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf6:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cfc:	8b 40 0c             	mov    0xc(%eax),%eax
80104cff:	83 f8 05             	cmp    $0x5,%eax
80104d02:	75 0d                	jne    80104d11 <exit+0x10c>
        wakeup1(initproc);
80104d04:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104d09:	89 04 24             	mov    %eax,(%esp)
80104d0c:	e8 ca 09 00 00       	call   801056db <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d11:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104d18:	81 7d f4 f4 86 11 80 	cmpl   $0x801186f4,-0xc(%ebp)
80104d1f:	72 bc                	jb     80104cdd <exit+0xd8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104d21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d27:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104d2e:	e8 be 07 00 00       	call   801054f1 <sched>
  panic("zombie exit");
80104d33:	c7 04 24 b2 9d 10 80 	movl   $0x80109db2,(%esp)
80104d3a:	e8 23 b8 ff ff       	call   80100562 <panic>

80104d3f <clear_proc>:
}

// Design document 2-1-2-4
int
clear_proc(struct proc *p) {
80104d3f:	55                   	push   %ebp
80104d40:	89 e5                	mov    %esp,%ebp
80104d42:	83 ec 28             	sub    $0x28,%esp
  int pid;
  // Found one.
  pid = p->pid;
80104d45:	8b 45 08             	mov    0x8(%ebp),%eax
80104d48:	8b 40 10             	mov    0x10(%eax),%eax
80104d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  kfree(p->kstack);
80104d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d51:	8b 40 08             	mov    0x8(%eax),%eax
80104d54:	89 04 24             	mov    %eax,(%esp)
80104d57:	e8 4d de ff ff       	call   80102ba9 <kfree>
  p->kstack = 0;
80104d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80104d5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

  /** freevm(p->pgdir); */
  check_pgdir_counter_and_call_freevm(p);
80104d66:	8b 45 08             	mov    0x8(%ebp),%eax
80104d69:	89 04 24             	mov    %eax,(%esp)
80104d6c:	e8 20 f6 ff ff       	call   80104391 <check_pgdir_counter_and_call_freevm>

  p->pid = 0;
80104d71:	8b 45 08             	mov    0x8(%ebp),%eax
80104d74:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  p->parent = 0;
80104d7b:	8b 45 08             	mov    0x8(%ebp),%eax
80104d7e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->name[0] = 0;
80104d85:	8b 45 08             	mov    0x8(%ebp),%eax
80104d88:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
  p->killed = 0;
80104d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80104d8f:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)

  // Design document 1-1-2-2 and 1-2-2-2.
  p->tick_used = 0;
80104d96:	8b 45 08             	mov    0x8(%ebp),%eax
80104d99:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
  p->time_quantum_used= 0;
80104da0:	8b 45 08             	mov    0x8(%ebp),%eax
80104da3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104daa:	00 00 00 
  p->level_of_MLFQ = 0;
80104dad:	8b 45 08             	mov    0x8(%ebp),%eax
80104db0:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104db7:	00 00 00 
  p->cpu_share = 0;
80104dba:	8b 45 08             	mov    0x8(%ebp),%eax
80104dbd:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104dc4:	00 00 00 
  p->stride = 0;
80104dc7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dca:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104dd1:	00 00 00 
  p->stride_count= 0;
80104dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd7:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104dde:	00 00 00 

  // Design Document 2-1-2-2
  p->tid = 0;
80104de1:	8b 45 08             	mov    0x8(%ebp),%eax
80104de4:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104deb:	00 00 00 
  p->pgdir_ref_idx = -1;
80104dee:	8b 45 08             	mov    0x8(%ebp),%eax
80104df1:	c7 80 98 00 00 00 ff 	movl   $0xffffffff,0x98(%eax)
80104df8:	ff ff ff 
  p->thread_return = 0;
80104dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80104dfe:	c7 80 9c 00 00 00 00 	movl   $0x0,0x9c(%eax)
80104e05:	00 00 00 

  p->state = UNUSED;
80104e08:	8b 45 08             	mov    0x8(%ebp),%eax
80104e0b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  return pid;
80104e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104e15:	c9                   	leave  
80104e16:	c3                   	ret    

80104e17 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104e17:	55                   	push   %ebp
80104e18:	89 e5                	mov    %esp,%ebp
80104e1a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104e1d:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80104e24:	e8 e7 13 00 00       	call   80106210 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104e29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e30:	c7 45 f4 f4 5e 11 80 	movl   $0x80115ef4,-0xc(%ebp)
80104e37:	eb 57                	jmp    80104e90 <wait+0x79>
      // We can find a hint of kernel memory leakage when we add a condition like below
      if(p->parent != proc || p->tid != 0)
80104e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e3c:	8b 50 14             	mov    0x14(%eax),%edx
80104e3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e45:	39 c2                	cmp    %eax,%edx
80104e47:	75 0d                	jne    80104e56 <wait+0x3f>
80104e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e4c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104e52:	85 c0                	test   %eax,%eax
80104e54:	74 02                	je     80104e58 <wait+0x41>
      /** if(p->parent != proc) */
        continue;
80104e56:	eb 31                	jmp    80104e89 <wait+0x72>
      }
#endif



      havekids = 1;
80104e58:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e62:	8b 40 0c             	mov    0xc(%eax),%eax
80104e65:	83 f8 05             	cmp    $0x5,%eax
80104e68:	75 1f                	jne    80104e89 <wait+0x72>
        pid = clear_proc(p);
80104e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e6d:	89 04 24             	mov    %eax,(%esp)
80104e70:	e8 ca fe ff ff       	call   80104d3f <clear_proc>
80104e75:	89 45 ec             	mov    %eax,-0x14(%ebp)
        release(&ptable.lock);
80104e78:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80104e7f:	e8 f3 13 00 00       	call   80106277 <release>
        return pid;
80104e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e87:	eb 51                	jmp    80104eda <wait+0xc3>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e89:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104e90:	81 7d f4 f4 86 11 80 	cmpl   $0x801186f4,-0xc(%ebp)
80104e97:	72 a0                	jb     80104e39 <wait+0x22>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104e99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104e9d:	74 0d                	je     80104eac <wait+0x95>
80104e9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ea5:	8b 40 24             	mov    0x24(%eax),%eax
80104ea8:	85 c0                	test   %eax,%eax
80104eaa:	74 13                	je     80104ebf <wait+0xa8>
      release(&ptable.lock);
80104eac:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80104eb3:	e8 bf 13 00 00       	call   80106277 <release>
      return -1;
80104eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ebd:	eb 1b                	jmp    80104eda <wait+0xc3>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104ebf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ec5:	c7 44 24 04 c0 5e 11 	movl   $0x80115ec0,0x4(%esp)
80104ecc:	80 
80104ecd:	89 04 24             	mov    %eax,(%esp)
80104ed0:	e8 6b 07 00 00       	call   80105640 <sleep>
  }
80104ed5:	e9 4f ff ff ff       	jmp    80104e29 <wait+0x12>
}
80104eda:	c9                   	leave  
80104edb:	c3                   	ret    

80104edc <stride_queue_heapify_up>:
void
stride_queue_heapify_up(int stride_idx) 
{
80104edc:	55                   	push   %ebp
80104edd:	89 e5                	mov    %esp,%ebp
80104edf:	83 ec 10             	sub    $0x10,%esp
  struct proc* target_proc = ptable.stride_queue[stride_idx];
80104ee2:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee5:	05 10 0a 00 00       	add    $0xa10,%eax
80104eea:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80104ef1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(stride_idx != 1){
80104ef4:	eb 66                	jmp    80104f5c <stride_queue_heapify_up+0x80>
    // if child is smaller than parent
    if(ptable.stride_queue[stride_idx] < ptable.stride_queue[stride_idx / 2]){
80104ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef9:	05 10 0a 00 00       	add    $0xa10,%eax
80104efe:	8b 14 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%edx
80104f05:	8b 45 08             	mov    0x8(%ebp),%eax
80104f08:	89 c1                	mov    %eax,%ecx
80104f0a:	c1 e9 1f             	shr    $0x1f,%ecx
80104f0d:	01 c8                	add    %ecx,%eax
80104f0f:	d1 f8                	sar    %eax
80104f11:	05 10 0a 00 00       	add    $0xa10,%eax
80104f16:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80104f1d:	39 c2                	cmp    %eax,%edx
80104f1f:	73 39                	jae    80104f5a <stride_queue_heapify_up+0x7e>
      ptable.stride_queue[stride_idx] = ptable.stride_queue[stride_idx / 2];
80104f21:	8b 45 08             	mov    0x8(%ebp),%eax
80104f24:	89 c2                	mov    %eax,%edx
80104f26:	c1 ea 1f             	shr    $0x1f,%edx
80104f29:	01 d0                	add    %edx,%eax
80104f2b:	d1 f8                	sar    %eax
80104f2d:	05 10 0a 00 00       	add    $0xa10,%eax
80104f32:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80104f39:	8b 55 08             	mov    0x8(%ebp),%edx
80104f3c:	81 c2 10 0a 00 00    	add    $0xa10,%edx
80104f42:	89 04 95 cc 5e 11 80 	mov    %eax,-0x7feea134(,%edx,4)
      stride_idx /= 2;
80104f49:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4c:	89 c2                	mov    %eax,%edx
80104f4e:	c1 ea 1f             	shr    $0x1f,%edx
80104f51:	01 d0                	add    %edx,%eax
80104f53:	d1 f8                	sar    %eax
80104f55:	89 45 08             	mov    %eax,0x8(%ebp)
80104f58:	eb 02                	jmp    80104f5c <stride_queue_heapify_up+0x80>
      
    // parent is smaller than child
    }else{
      break;
80104f5a:	eb 06                	jmp    80104f62 <stride_queue_heapify_up+0x86>
}
void
stride_queue_heapify_up(int stride_idx) 
{
  struct proc* target_proc = ptable.stride_queue[stride_idx];
  while(stride_idx != 1){
80104f5c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
80104f60:	75 94                	jne    80104ef6 <stride_queue_heapify_up+0x1a>
    }else{
      break;
    }
  }
  // locate a process to right position
  ptable.stride_queue[stride_idx] = target_proc;
80104f62:	8b 45 08             	mov    0x8(%ebp),%eax
80104f65:	8d 90 10 0a 00 00    	lea    0xa10(%eax),%edx
80104f6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f6e:	89 04 95 cc 5e 11 80 	mov    %eax,-0x7feea134(,%edx,4)

}
80104f75:	c9                   	leave  
80104f76:	c3                   	ret    

80104f77 <stride_queue_heapify_down>:

void
stride_queue_heapify_down(int stride_idx) 
{
80104f77:	55                   	push   %ebp
80104f78:	89 e5                	mov    %esp,%ebp
80104f7a:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = ptable.stride_queue[stride_idx];
80104f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f80:	05 10 0a 00 00       	add    $0xa10,%eax
80104f85:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80104f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)

  while(stride_idx * 2 < NPROC // If stride_idx indicates that it is leaf node, break the loop
80104f8f:	e9 5a 01 00 00       	jmp    801050ee <stride_queue_heapify_down+0x177>
      && stride_idx <= ptable.stride_queue_size){
    if(ptable.stride_queue[stride_idx * 2] 
80104f94:	8b 45 08             	mov    0x8(%ebp),%eax
80104f97:	01 c0                	add    %eax,%eax
80104f99:	05 10 0a 00 00       	add    $0xa10,%eax
80104f9e:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80104fa5:	85 c0                	test   %eax,%eax
80104fa7:	0f 84 c8 00 00 00    	je     80105075 <stride_queue_heapify_down+0xfe>
        && ptable.stride_queue[stride_idx * 2 + 1]){
80104fad:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb0:	01 c0                	add    %eax,%eax
80104fb2:	83 c0 01             	add    $0x1,%eax
80104fb5:	05 10 0a 00 00       	add    $0xa10,%eax
80104fba:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80104fc1:	85 c0                	test   %eax,%eax
80104fc3:	0f 84 ac 00 00 00    	je     80105075 <stride_queue_heapify_down+0xfe>
      // two childen

      // get smaller one among children
      stride_idx = ptable.stride_queue[stride_idx * 2]->stride_count 
80104fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80104fcc:	01 c0                	add    %eax,%eax
80104fce:	05 10 0a 00 00       	add    $0xa10,%eax
80104fd3:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80104fda:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
                    < ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
80104fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe3:	01 c0                	add    %eax,%eax
80104fe5:	83 c0 01             	add    $0x1,%eax
80104fe8:	05 10 0a 00 00       	add    $0xa10,%eax
80104fed:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80104ff4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
                    ? stride_idx * 2 : stride_idx * 2 + 1;
80104ffa:	39 c2                	cmp    %eax,%edx
80104ffc:	7d 07                	jge    80105005 <stride_queue_heapify_down+0x8e>
80104ffe:	8b 45 08             	mov    0x8(%ebp),%eax
80105001:	01 c0                	add    %eax,%eax
80105003:	eb 08                	jmp    8010500d <stride_queue_heapify_down+0x96>
80105005:	8b 45 08             	mov    0x8(%ebp),%eax
80105008:	01 c0                	add    %eax,%eax
8010500a:	83 c0 01             	add    $0x1,%eax
    if(ptable.stride_queue[stride_idx * 2] 
        && ptable.stride_queue[stride_idx * 2 + 1]){
      // two childen

      // get smaller one among children
      stride_idx = ptable.stride_queue[stride_idx * 2]->stride_count 
8010500d:	89 45 08             	mov    %eax,0x8(%ebp)
                    < ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
                    ? stride_idx * 2 : stride_idx * 2 + 1;

      // if children's minimum is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
80105010:	8b 45 08             	mov    0x8(%ebp),%eax
80105013:	05 10 0a 00 00       	add    $0xa10,%eax
80105018:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
8010501f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105025:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105028:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010502e:	39 c2                	cmp    %eax,%edx
80105030:	7d 2f                	jge    80105061 <stride_queue_heapify_down+0xea>
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
80105032:	8b 45 08             	mov    0x8(%ebp),%eax
80105035:	89 c2                	mov    %eax,%edx
80105037:	c1 ea 1f             	shr    $0x1f,%edx
8010503a:	01 d0                	add    %edx,%eax
8010503c:	d1 f8                	sar    %eax
8010503e:	89 c2                	mov    %eax,%edx
80105040:	8b 45 08             	mov    0x8(%ebp),%eax
80105043:	05 10 0a 00 00       	add    $0xa10,%eax
80105048:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
8010504f:	81 c2 10 0a 00 00    	add    $0xa10,%edx
80105055:	89 04 95 cc 5e 11 80 	mov    %eax,-0x7feea134(,%edx,4)
      stride_idx = ptable.stride_queue[stride_idx * 2]->stride_count 
                    < ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
                    ? stride_idx * 2 : stride_idx * 2 + 1;

      // if children's minimum is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
8010505c:	e9 8d 00 00 00       	jmp    801050ee <stride_queue_heapify_down+0x177>
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
      }else{
        stride_idx /= 2;
80105061:	8b 45 08             	mov    0x8(%ebp),%eax
80105064:	89 c2                	mov    %eax,%edx
80105066:	c1 ea 1f             	shr    $0x1f,%edx
80105069:	01 d0                	add    %edx,%eax
8010506b:	d1 f8                	sar    %eax
8010506d:	89 45 08             	mov    %eax,0x8(%ebp)
        //stride_idx is the place the current process should go.
        break;
80105070:	e9 91 00 00 00       	jmp    80105106 <stride_queue_heapify_down+0x18f>
      }

    }else if(ptable.stride_queue[stride_idx * 2]){
80105075:	8b 45 08             	mov    0x8(%ebp),%eax
80105078:	01 c0                	add    %eax,%eax
8010507a:	05 10 0a 00 00       	add    $0xa10,%eax
8010507f:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80105086:	85 c0                	test   %eax,%eax
80105088:	74 62                	je     801050ec <stride_queue_heapify_down+0x175>
      // only left child (== the last element)
      stride_idx *= 2;
8010508a:	d1 65 08             	shll   0x8(%ebp)
      // if left child's value is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
8010508d:	8b 45 08             	mov    0x8(%ebp),%eax
80105090:	05 10 0a 00 00       	add    $0xa10,%eax
80105095:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
8010509c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801050a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050a5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801050ab:	39 c2                	cmp    %eax,%edx
801050ad:	7d 2c                	jge    801050db <stride_queue_heapify_down+0x164>
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
801050af:	8b 45 08             	mov    0x8(%ebp),%eax
801050b2:	89 c2                	mov    %eax,%edx
801050b4:	c1 ea 1f             	shr    $0x1f,%edx
801050b7:	01 d0                	add    %edx,%eax
801050b9:	d1 f8                	sar    %eax
801050bb:	89 c2                	mov    %eax,%edx
801050bd:	8b 45 08             	mov    0x8(%ebp),%eax
801050c0:	05 10 0a 00 00       	add    $0xa10,%eax
801050c5:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
801050cc:	81 c2 10 0a 00 00    	add    $0xa10,%edx
801050d2:	89 04 95 cc 5e 11 80 	mov    %eax,-0x7feea134(,%edx,4)
      }else{
        stride_idx /= 2;
      }
      break;
801050d9:	eb 2b                	jmp    80105106 <stride_queue_heapify_down+0x18f>
      stride_idx *= 2;
      // if left child's value is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
      }else{
        stride_idx /= 2;
801050db:	8b 45 08             	mov    0x8(%ebp),%eax
801050de:	89 c2                	mov    %eax,%edx
801050e0:	c1 ea 1f             	shr    $0x1f,%edx
801050e3:	01 d0                	add    %edx,%eax
801050e5:	d1 f8                	sar    %eax
801050e7:	89 45 08             	mov    %eax,0x8(%ebp)
      }
      break;
801050ea:	eb 1a                	jmp    80105106 <stride_queue_heapify_down+0x18f>
    }else{
      // no child
      // do nothing. it will escape the loop.
      break;
801050ec:	eb 18                	jmp    80105106 <stride_queue_heapify_down+0x18f>
void
stride_queue_heapify_down(int stride_idx) 
{
  struct proc* p = ptable.stride_queue[stride_idx];

  while(stride_idx * 2 < NPROC // If stride_idx indicates that it is leaf node, break the loop
801050ee:	8b 45 08             	mov    0x8(%ebp),%eax
801050f1:	01 c0                	add    %eax,%eax
801050f3:	83 f8 3f             	cmp    $0x3f,%eax
801050f6:	7f 0e                	jg     80105106 <stride_queue_heapify_down+0x18f>
      && stride_idx <= ptable.stride_queue_size){
801050f8:	a1 14 88 11 80       	mov    0x80118814,%eax
801050fd:	3b 45 08             	cmp    0x8(%ebp),%eax
80105100:	0f 8d 8e fe ff ff    	jge    80104f94 <stride_queue_heapify_down+0x1d>
      break;
    }
  }
  
  // current process' place
  ptable.stride_queue[stride_idx] = p;
80105106:	8b 45 08             	mov    0x8(%ebp),%eax
80105109:	8d 90 10 0a 00 00    	lea    0xa10(%eax),%edx
8010510f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105112:	89 04 95 cc 5e 11 80 	mov    %eax,-0x7feea134(,%edx,4)

}
80105119:	c9                   	leave  
8010511a:	c3                   	ret    

8010511b <find_idx_of_stride_to_run>:

int
find_idx_of_stride_to_run(void) 
{
8010511b:	55                   	push   %ebp
8010511c:	89 e5                	mov    %esp,%ebp
8010511e:	83 ec 38             	sub    $0x38,%esp
  struct proc* proc_to_be_run;
  int i;
  
  // From the start to the end of stride queue
  int stride_find_idx = 1;
80105121:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  while(stride_find_idx <= ptable.stride_queue_size){
80105128:	e9 07 01 00 00       	jmp    80105234 <find_idx_of_stride_to_run+0x119>
    if(ptable.stride_queue[stride_find_idx]->state == RUNNABLE){
8010512d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105130:	05 10 0a 00 00       	add    $0xa10,%eax
80105135:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
8010513c:	8b 40 0c             	mov    0xc(%eax),%eax
8010513f:	83 f8 03             	cmp    $0x3,%eax
80105142:	75 3f                	jne    80105183 <find_idx_of_stride_to_run+0x68>
      // Found
      // Increase stride count of current process and heapify.
      proc_to_be_run = ptable.stride_queue[stride_find_idx];
80105144:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105147:	05 10 0a 00 00       	add    $0xa10,%eax
8010514c:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80105153:	89 45 e8             	mov    %eax,-0x18(%ebp)
      proc_to_be_run->stride_count += proc_to_be_run->stride;
80105156:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105159:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
8010515f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105162:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80105168:	01 c2                	add    %eax,%edx
8010516a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010516d:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
      stride_queue_heapify_down(stride_find_idx);
80105173:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105176:	89 04 24             	mov    %eax,(%esp)
80105179:	e8 f9 fd ff ff       	call   80104f77 <stride_queue_heapify_down>

      // End finding. Go to run selected process.
      break;
8010517e:	e9 bf 00 00 00       	jmp    80105242 <find_idx_of_stride_to_run+0x127>
    }else{
      // Not found
      // select between children whose stirde_value is smaller
      int left_child = stride_find_idx * 2;
80105183:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105186:	01 c0                	add    %eax,%eax
80105188:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      int right_child = stride_find_idx * 2 + 1;
8010518b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010518e:	01 c0                	add    %eax,%eax
80105190:	83 c0 01             	add    $0x1,%eax
80105193:	89 45 e0             	mov    %eax,-0x20(%ebp)
      enum {NO_CHILD, LEFT_ONLY, BOTH} child_status;

      if(right_child <= ptable.stride_queue_size){
80105196:	a1 14 88 11 80       	mov    0x80118814,%eax
8010519b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010519e:	7c 09                	jl     801051a9 <find_idx_of_stride_to_run+0x8e>
        child_status = BOTH;
801051a0:	c7 45 ec 02 00 00 00 	movl   $0x2,-0x14(%ebp)
801051a7:	eb 1a                	jmp    801051c3 <find_idx_of_stride_to_run+0xa8>
      }else if(left_child > ptable.stride_queue_size){
801051a9:	a1 14 88 11 80       	mov    0x80118814,%eax
801051ae:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
801051b1:	7d 09                	jge    801051bc <find_idx_of_stride_to_run+0xa1>
        child_status = NO_CHILD;
801051b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801051ba:	eb 07                	jmp    801051c3 <find_idx_of_stride_to_run+0xa8>
      }else{
        child_status = LEFT_ONLY;
801051bc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
      }

      // Check children's existence.
      switch(child_status){
801051c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051c6:	83 f8 01             	cmp    $0x1,%eax
801051c9:	74 48                	je     80105213 <find_idx_of_stride_to_run+0xf8>
801051cb:	83 f8 01             	cmp    $0x1,%eax
801051ce:	72 4b                	jb     8010521b <find_idx_of_stride_to_run+0x100>
801051d0:	83 f8 02             	cmp    $0x2,%eax
801051d3:	75 53                	jne    80105228 <find_idx_of_stride_to_run+0x10d>
        case BOTH:
          // Left and right children is exist.
          if(ptable.stride_queue[left_child]->stride_count
801051d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051d8:	05 10 0a 00 00       	add    $0xa10,%eax
801051dd:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
801051e4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
              < ptable.stride_queue[right_child]->stride_count){
801051ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051ed:	05 10 0a 00 00       	add    $0xa10,%eax
801051f2:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
801051f9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax

      // Check children's existence.
      switch(child_status){
        case BOTH:
          // Left and right children is exist.
          if(ptable.stride_queue[left_child]->stride_count
801051ff:	39 c2                	cmp    %eax,%edx
80105201:	7d 08                	jge    8010520b <find_idx_of_stride_to_run+0xf0>
              < ptable.stride_queue[right_child]->stride_count){
            // left is smaller
            stride_find_idx = left_child;
80105203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105206:	89 45 f0             	mov    %eax,-0x10(%ebp)
          }else{
            // right is smaller
            stride_find_idx = right_child;
          }
          break;
80105209:	eb 29                	jmp    80105234 <find_idx_of_stride_to_run+0x119>
              < ptable.stride_queue[right_child]->stride_count){
            // left is smaller
            stride_find_idx = left_child;
          }else{
            // right is smaller
            stride_find_idx = right_child;
8010520b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010520e:	89 45 f0             	mov    %eax,-0x10(%ebp)
          }
          break;
80105211:	eb 21                	jmp    80105234 <find_idx_of_stride_to_run+0x119>

        case LEFT_ONLY:
          // Only left child is exist
          stride_find_idx = left_child;
80105213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105216:	89 45 f0             	mov    %eax,-0x10(%ebp)
          break;
80105219:	eb 19                	jmp    80105234 <find_idx_of_stride_to_run+0x119>

        case NO_CHILD:
          // NO_CHILD
          // End the loop. Make index bigger than stride_queue_size
          stride_find_idx = ptable.stride_queue_size + 1;
8010521b:	a1 14 88 11 80       	mov    0x80118814,%eax
80105220:	83 c0 01             	add    $0x1,%eax
80105223:	89 45 f0             	mov    %eax,-0x10(%ebp)
          break;
80105226:	eb 0c                	jmp    80105234 <find_idx_of_stride_to_run+0x119>
        default:
          panic("error in find_idx_of_stride_to_run().");
80105228:	c7 04 24 c0 9d 10 80 	movl   $0x80109dc0,(%esp)
8010522f:	e8 2e b3 ff ff       	call   80100562 <panic>
  struct proc* proc_to_be_run;
  int i;
  
  // From the start to the end of stride queue
  int stride_find_idx = 1;
  while(stride_find_idx <= ptable.stride_queue_size){
80105234:	a1 14 88 11 80       	mov    0x80118814,%eax
80105239:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010523c:	0f 8d eb fe ff ff    	jge    8010512d <find_idx_of_stride_to_run+0x12>
      }
    }
  }

  // A process is not found. Find any runnable process in stride queue.
  if(stride_find_idx >= ptable.stride_queue_size + 1){
80105242:	a1 14 88 11 80       	mov    0x80118814,%eax
80105247:	83 c0 01             	add    $0x1,%eax
8010524a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010524d:	7f 37                	jg     80105286 <find_idx_of_stride_to_run+0x16b>
    for(i = 1; i <= ptable.stride_queue_size; ++i){
8010524f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80105256:	eb 24                	jmp    8010527c <find_idx_of_stride_to_run+0x161>
      if(ptable.stride_queue[i]->state == RUNNABLE){
80105258:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010525b:	05 10 0a 00 00       	add    $0xa10,%eax
80105260:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80105267:	8b 40 0c             	mov    0xc(%eax),%eax
8010526a:	83 f8 03             	cmp    $0x3,%eax
8010526d:	75 09                	jne    80105278 <find_idx_of_stride_to_run+0x15d>
        stride_find_idx = i;
8010526f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105272:	89 45 f0             	mov    %eax,-0x10(%ebp)
        break;
80105275:	90                   	nop
80105276:	eb 0e                	jmp    80105286 <find_idx_of_stride_to_run+0x16b>
    }
  }

  // A process is not found. Find any runnable process in stride queue.
  if(stride_find_idx >= ptable.stride_queue_size + 1){
    for(i = 1; i <= ptable.stride_queue_size; ++i){
80105278:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010527c:	a1 14 88 11 80       	mov    0x80118814,%eax
80105281:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105284:	7d d2                	jge    80105258 <find_idx_of_stride_to_run+0x13d>
    // do nothing. process is found.
  }

  // return value is larger than size when no process is runnable in stride.
  // exception handling code is in scheduler()
  return stride_find_idx;
80105286:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105289:	c9                   	leave  
8010528a:	c3                   	ret    

8010528b <select_stride_or_MLFQ>:

int
select_stride_or_MLFQ()
{
8010528b:	55                   	push   %ebp
8010528c:	89 e5                	mov    %esp,%ebp
8010528e:	83 ec 10             	sub    $0x10,%esp
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80105291:	a1 0c d0 10 80       	mov    0x8010d00c,%eax
80105296:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
8010529c:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
801052a1:	a3 0c d0 10 80       	mov    %eax,0x8010d00c
  queue_selector = randstate % 100;
801052a6:	8b 0d 0c d0 10 80    	mov    0x8010d00c,%ecx
801052ac:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801052b1:	89 c8                	mov    %ecx,%eax
801052b3:	f7 ea                	imul   %edx
801052b5:	c1 fa 05             	sar    $0x5,%edx
801052b8:	89 c8                	mov    %ecx,%eax
801052ba:	c1 f8 1f             	sar    $0x1f,%eax
801052bd:	29 c2                	sub    %eax,%edx
801052bf:	89 d0                	mov    %edx,%eax
801052c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
801052c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052c7:	6b c0 64             	imul   $0x64,%eax,%eax
801052ca:	29 c1                	sub    %eax,%ecx
801052cc:	89 c8                	mov    %ecx,%eax
801052ce:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(queue_selector < ptable.sum_cpu_share){
801052d1:	a1 10 88 11 80       	mov    0x80118810,%eax
801052d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
801052d9:	7e 07                	jle    801052e2 <select_stride_or_MLFQ+0x57>
    // The stride queue is selected.
    return 1;
801052db:	b8 01 00 00 00       	mov    $0x1,%eax
801052e0:	eb 05                	jmp    801052e7 <select_stride_or_MLFQ+0x5c>
  }else{
    // MLFQ is selected
    return 0;;
801052e2:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
801052e7:	c9                   	leave  
801052e8:	c3                   	ret    

801052e9 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801052e9:	55                   	push   %ebp
801052ea:	89 e5                	mov    %esp,%ebp
801052ec:	83 ec 38             	sub    $0x38,%esp
  struct proc *p;
  
  // Design Document 1-2-2-5
  int choosing_stride_or_MLFQ;
  int stride_is_selected = 0;
801052ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  for(;;){
    // Enable interrupts on this processor.
    sti();
801052f6:	e8 90 f0 ff ff       	call   8010438b <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801052fb:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80105302:	e8 09 0f 00 00       	call   80106210 <acquire>

    // choose the stride queue or MLFQ
    choosing_stride_or_MLFQ = 1;
80105307:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

    // When while loop is end, there are only processes of last level of queue.
    ptable.queue_level_at_most = NMLFQ - 1; // last level
8010530e:	c7 05 04 87 11 80 02 	movl   $0x2,0x80118704
80105315:	00 00 00 
    while(ptable.queue_level_at_most < NMLFQ){
80105318:	e9 b5 01 00 00       	jmp    801054d2 <scheduler+0x1e9>

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;
8010531d:	c7 05 08 87 11 80 02 	movl   $0x2,0x80118708
80105324:	00 00 00 

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105327:	c7 45 f4 f4 5e 11 80 	movl   $0x80115ef4,-0xc(%ebp)
8010532e:	e9 7b 01 00 00       	jmp    801054ae <scheduler+0x1c5>
        // Design Document 1-2-2-5. Choosing the stride queue or MLFQ
        if(ptable.sum_cpu_share == 0){
80105333:	a1 10 88 11 80       	mov    0x80118810,%eax
80105338:	85 c0                	test   %eax,%eax
8010533a:	75 10                	jne    8010534c <scheduler+0x63>
          // No process is in stride. Run only processes in MLFQ.
          stride_is_selected = 0;
8010533c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
          choosing_stride_or_MLFQ = 0;
80105343:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010534a:	eb 0e                	jmp    8010535a <scheduler+0x71>
        }else if(choosing_stride_or_MLFQ){
8010534c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105350:	74 08                	je     8010535a <scheduler+0x71>
          // If the stride queue is selceted, the value of 'stride_is_selected' will be 1.
          // If not, zero.
          stride_is_selected = select_stride_or_MLFQ();
80105352:	e8 34 ff ff ff       	call   8010528b <select_stride_or_MLFQ>
80105357:	89 45 ec             	mov    %eax,-0x14(%ebp)
          // choosing_stride_or_MLFQ == 0
          // do nothing. keep finding a process in MLFQ
        }

        // Design document 1-1-2-5. Finding a process to be run
        if(stride_is_selected){
8010535a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010535e:	74 39                	je     80105399 <scheduler+0xb0>
          // The stride queue is selceted.
          
          int stride_idx_to_be_run;
          // Find a process whose state is RUNNABLE in the stride queue
          stride_idx_to_be_run = find_idx_of_stride_to_run();
80105360:	e8 b6 fd ff ff       	call   8010511b <find_idx_of_stride_to_run>
80105365:	89 45 e8             	mov    %eax,-0x18(%ebp)

          // Check whether process is found or not.
          if(stride_idx_to_be_run <= ptable.stride_queue_size){
80105368:	a1 14 88 11 80       	mov    0x80118814,%eax
8010536d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80105370:	7c 14                	jl     80105386 <scheduler+0x9d>
            // Process is found. Go to run found process
            p = ptable.stride_queue[stride_idx_to_be_run];
80105372:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105375:	05 10 0a 00 00       	add    $0xa10,%eax
8010537a:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80105381:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105384:	eb 6e                	jmp    801053f4 <scheduler+0x10b>
          }else{
            // No process to be run in stride_queue. go to MLFQ
            stride_is_selected = 0;
80105386:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
            choosing_stride_or_MLFQ = 0;
8010538d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
            continue;
80105394:	e9 0e 01 00 00       	jmp    801054a7 <scheduler+0x1be>
          // The MLFQ is selected. Find a process in MLFQ.
          // A process can be run whose priority is equal or higher than ptable.queue_level_at_most.
          
          // Skip a process whose value of cpu_share is not zero, 
          //  which means that the process is in the stride_queue, not in the MLFQ.
          if(p->state == RUNNABLE 
80105399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010539c:	8b 40 0c             	mov    0xc(%eax),%eax
8010539f:	83 f8 03             	cmp    $0x3,%eax
801053a2:	75 44                	jne    801053e8 <scheduler+0xff>
              && p->cpu_share == 0 
801053a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a7:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801053ad:	85 c0                	test   %eax,%eax
801053af:	75 37                	jne    801053e8 <scheduler+0xff>
              && p->level_of_MLFQ <= ptable.queue_level_at_most){
801053b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b4:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
801053ba:	a1 04 87 11 80       	mov    0x80118704,%eax
801053bf:	39 c2                	cmp    %eax,%edx
801053c1:	7f 25                	jg     801053e8 <scheduler+0xff>
            // A process to be run has been found!
            // Minimum level of run processes should be ptable.queue_level_at_most for next scheduling.
            ptable.queue_level_at_most = p->level_of_MLFQ < ptable.queue_level_at_most ? p->level_of_MLFQ : ptable.queue_level_at_most;
801053c3:	8b 15 04 87 11 80    	mov    0x80118704,%edx
801053c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053cc:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801053d2:	39 c2                	cmp    %eax,%edx
801053d4:	0f 4e c2             	cmovle %edx,%eax
801053d7:	a3 04 87 11 80       	mov    %eax,0x80118704
            ptable.min_of_run_proc_level = ptable.queue_level_at_most;
801053dc:	a1 04 87 11 80       	mov    0x80118704,%eax
801053e1:	a3 08 87 11 80       	mov    %eax,0x80118708
801053e6:	eb 0c                	jmp    801053f4 <scheduler+0x10b>

          }else{
            // A process to be run has not been found. Keep finding it in MLFQ.
            choosing_stride_or_MLFQ = 0;
801053e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
            continue;
801053ef:	e9 b3 00 00 00       	jmp    801054a7 <scheduler+0x1be>
        }
        // A proces to be run is found.
        // Below codes are used in both the stride and MLFQ.
        
        // back up MLFQ pointer for removing side effect of the stride algorithm.
        struct proc* p_mlfq = p;
801053f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          *       cprintf("pgdir_ref[%d]: %d, pgdir_ref_next_idx:%d\n", i, pgdir_ref[i], pgdir_ref_next_idx);
          *     }
          *   }
          * } */
#endif
        proc = p;
801053fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053fd:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
        switchuvm(p);
80105403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105406:	89 04 24             	mov    %eax,(%esp)
80105409:	e8 60 3d 00 00       	call   8010916e <switchuvm>
        p->state = RUNNING;
8010540e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105411:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

        // Back up MLFQ tick for check whether a process in MLFQ uses at least one tick.
        // I did not use 'if', so in this code is executed in stride algorithm, but it does not make problem.
        before_MLFQ_used_tick = ptable.MLFQ_tick_used;
80105418:	a1 00 87 11 80       	mov    0x80118700,%eax
8010541d:	89 45 e0             	mov    %eax,-0x20(%ebp)

        swtch(&cpu->scheduler, p->context); // This function returns in sched().
80105420:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105423:	8b 40 1c             	mov    0x1c(%eax),%eax
80105426:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010542d:	83 c2 04             	add    $0x4,%edx
80105430:	89 44 24 04          	mov    %eax,0x4(%esp)
80105434:	89 14 24             	mov    %edx,(%esp)
80105437:	e8 ce 12 00 00       	call   8010670a <swtch>
        switchkvm();
8010543c:	e8 13 3d 00 00       	call   80109154 <switchkvm>
        // Check MLFQ_tick_used only in follow conditions are satisfied:
        // 1) Current queue is MLFQ                     (stride_is_selected == 0)
        // 2) Current process is runnable               (p->state == RUNNING)
        // 3) Any processes are in the stride queue     (ptable.sum_cpu_share != 0)
        // 4) The process running now is in MLFQ        (p->cpu_share == 0)
        if(stride_is_selected == 0
80105441:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105445:	75 3b                	jne    80105482 <scheduler+0x199>
            && ptable.sum_cpu_share != 0 
80105447:	a1 10 88 11 80       	mov    0x80118810,%eax
8010544c:	85 c0                	test   %eax,%eax
8010544e:	74 32                	je     80105482 <scheduler+0x199>
            && p->state == RUNNABLE 
80105450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105453:	8b 40 0c             	mov    0xc(%eax),%eax
80105456:	83 f8 03             	cmp    $0x3,%eax
80105459:	75 27                	jne    80105482 <scheduler+0x199>
            && p->cpu_share == 0 
8010545b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010545e:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105464:	85 c0                	test   %eax,%eax
80105466:	75 1a                	jne    80105482 <scheduler+0x199>
            && ptable.MLFQ_tick_used == before_MLFQ_used_tick)
80105468:	a1 00 87 11 80       	mov    0x80118700,%eax
8010546d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80105470:	75 10                	jne    80105482 <scheduler+0x199>
          // When these conditions are satisfied, 
          // it means that current process are in MLFQ and it does not use at least one tick.
          
          // To make the process use one tick, re-run current process:
          // 1) Do not consider choosing between the MLFQ of the stride.
          choosing_stride_or_MLFQ = 0;
80105472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

          // 2) To re-run current process, decrease pointer's value. 
          //    It will be increased in 'for' statement, so current process will be re-selected.
          p--;
80105479:	81 6d f4 a0 00 00 00 	subl   $0xa0,-0xc(%ebp)
80105480:	eb 07                	jmp    80105489 <scheduler+0x1a0>
        }else{
          choosing_stride_or_MLFQ = 1;
80105482:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        }

        proc = 0;
80105489:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80105490:	00 00 00 00 

        if(stride_is_selected){
80105494:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105498:	74 0d                	je     801054a7 <scheduler+0x1be>
          // To remove the side effect of stride algorithm, restore the process pointer and decrase it.
          // It will be increased in 'for' statement, so the status of MLFQ is same.
          p = p_mlfq;
8010549a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010549d:	89 45 f4             	mov    %eax,-0xc(%ebp)
          p--;
801054a0:	81 6d f4 a0 00 00 00 	subl   $0xa0,-0xc(%ebp)
    while(ptable.queue_level_at_most < NMLFQ){

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801054a7:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
801054ae:	81 7d f4 f4 86 11 80 	cmpl   $0x801186f4,-0xc(%ebp)
801054b5:	0f 82 78 fe ff ff    	jb     80105333 <scheduler+0x4a>
          p = p_mlfq;
          p--;
        }
      }

      if(ptable.min_of_run_proc_level == NMLFQ - 1)  {
801054bb:	a1 08 87 11 80       	mov    0x80118708,%eax
801054c0:	83 f8 02             	cmp    $0x2,%eax
801054c3:	75 0d                	jne    801054d2 <scheduler+0x1e9>
        // 1) no process run. Increase queue level.
        // 2) processes are only in queue of last level. Break the while loop
        ptable.queue_level_at_most++;
801054c5:	a1 04 87 11 80       	mov    0x80118704,%eax
801054ca:	83 c0 01             	add    $0x1,%eax
801054cd:	a3 04 87 11 80       	mov    %eax,0x80118704
    // choose the stride queue or MLFQ
    choosing_stride_or_MLFQ = 1;

    // When while loop is end, there are only processes of last level of queue.
    ptable.queue_level_at_most = NMLFQ - 1; // last level
    while(ptable.queue_level_at_most < NMLFQ){
801054d2:	a1 04 87 11 80       	mov    0x80118704,%eax
801054d7:	83 f8 02             	cmp    $0x2,%eax
801054da:	0f 8e 3d fe ff ff    	jle    8010531d <scheduler+0x34>
        ptable.queue_level_at_most++;
      }else{
        // run a queue of same level again.
      }
    }
    release(&ptable.lock);
801054e0:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
801054e7:	e8 8b 0d 00 00       	call   80106277 <release>
  }
801054ec:	e9 05 fe ff ff       	jmp    801052f6 <scheduler+0xd>

801054f1 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801054f1:	55                   	push   %ebp
801054f2:	89 e5                	mov    %esp,%ebp
801054f4:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801054f7:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
801054fe:	e8 3a 0e 00 00       	call   8010633d <holding>
80105503:	85 c0                	test   %eax,%eax
80105505:	75 0c                	jne    80105513 <sched+0x22>
    panic("sched ptable.lock");
80105507:	c7 04 24 e6 9d 10 80 	movl   $0x80109de6,(%esp)
8010550e:	e8 4f b0 ff ff       	call   80100562 <panic>
  if(cpu->ncli != 1)
80105513:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105519:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010551f:	83 f8 01             	cmp    $0x1,%eax
80105522:	74 0c                	je     80105530 <sched+0x3f>
    panic("sched locks");
80105524:	c7 04 24 f8 9d 10 80 	movl   $0x80109df8,(%esp)
8010552b:	e8 32 b0 ff ff       	call   80100562 <panic>
  if(proc->state == RUNNING)
80105530:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105536:	8b 40 0c             	mov    0xc(%eax),%eax
80105539:	83 f8 04             	cmp    $0x4,%eax
8010553c:	75 0c                	jne    8010554a <sched+0x59>
    panic("sched running");
8010553e:	c7 04 24 04 9e 10 80 	movl   $0x80109e04,(%esp)
80105545:	e8 18 b0 ff ff       	call   80100562 <panic>
  if(readeflags()&FL_IF)
8010554a:	e8 2c ee ff ff       	call   8010437b <readeflags>
8010554f:	25 00 02 00 00       	and    $0x200,%eax
80105554:	85 c0                	test   %eax,%eax
80105556:	74 0c                	je     80105564 <sched+0x73>
    panic("sched interruptible");
80105558:	c7 04 24 12 9e 10 80 	movl   $0x80109e12,(%esp)
8010555f:	e8 fe af ff ff       	call   80100562 <panic>

  intena = cpu->intena;
80105564:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010556a:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105570:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler); // sched는 한 타임에 return되는게 아니다. 자고 있다가, 깨워지면 다시 시작한다.
80105573:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105579:	8b 40 04             	mov    0x4(%eax),%eax
8010557c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105583:	83 c2 1c             	add    $0x1c,%edx
80105586:	89 44 24 04          	mov    %eax,0x4(%esp)
8010558a:	89 14 24             	mov    %edx,(%esp)
8010558d:	e8 78 11 00 00       	call   8010670a <swtch>
  // swtch가 return되는 곳은 scheduler안에서다. scheduler 진행
  
  // 이거맞나? TODO 
  if(proc){
80105592:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105598:	85 c0                	test   %eax,%eax
8010559a:	74 10                	je     801055ac <sched+0xbb>
    proc->time_quantum_used = 0;
8010559c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055a2:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801055a9:	00 00 00 
  }

  cpu->intena = intena;
801055ac:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055b5:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801055bb:	c9                   	leave  
801055bc:	c3                   	ret    

801055bd <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
801055bd:	55                   	push   %ebp
801055be:	89 e5                	mov    %esp,%ebp
801055c0:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801055c3:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
801055ca:	e8 41 0c 00 00       	call   80106210 <acquire>
  proc->state = RUNNABLE;
801055cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched(); 
801055dc:	e8 10 ff ff ff       	call   801054f1 <sched>
  release(&ptable.lock);
801055e1:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
801055e8:	e8 8a 0c 00 00       	call   80106277 <release>
}
801055ed:	c9                   	leave  
801055ee:	c3                   	ret    

801055ef <sys_yield>:
// Wrapper
int
sys_yield(void){
801055ef:	55                   	push   %ebp
801055f0:	89 e5                	mov    %esp,%ebp
801055f2:	83 ec 08             	sub    $0x8,%esp
  yield();
801055f5:	e8 c3 ff ff ff       	call   801055bd <yield>
  return 0;
801055fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055ff:	c9                   	leave  
80105600:	c3                   	ret    

80105601 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105601:	55                   	push   %ebp
80105602:	89 e5                	mov    %esp,%ebp
80105604:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105607:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
8010560e:	e8 64 0c 00 00       	call   80106277 <release>

  if(first){
80105613:	a1 10 d0 10 80       	mov    0x8010d010,%eax
80105618:	85 c0                	test   %eax,%eax
8010561a:	74 22                	je     8010563e <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
8010561c:	c7 05 10 d0 10 80 00 	movl   $0x0,0x8010d010
80105623:	00 00 00 
    iinit(ROOTDEV);
80105626:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010562d:	e8 41 c0 ff ff       	call   80101673 <iinit>
    initlog(ROOTDEV);
80105632:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105639:	e8 65 dd ff ff       	call   801033a3 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010563e:	c9                   	leave  
8010563f:	c3                   	ret    

80105640 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80105646:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010564c:	85 c0                	test   %eax,%eax
8010564e:	75 0c                	jne    8010565c <sleep+0x1c>
    panic("sleep");
80105650:	c7 04 24 26 9e 10 80 	movl   $0x80109e26,(%esp)
80105657:	e8 06 af ff ff       	call   80100562 <panic>

  if(lk == 0)
8010565c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105660:	75 0c                	jne    8010566e <sleep+0x2e>
    panic("sleep without lk");
80105662:	c7 04 24 2c 9e 10 80 	movl   $0x80109e2c,(%esp)
80105669:	e8 f4 ae ff ff       	call   80100562 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010566e:	81 7d 0c c0 5e 11 80 	cmpl   $0x80115ec0,0xc(%ebp)
80105675:	74 17                	je     8010568e <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80105677:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
8010567e:	e8 8d 0b 00 00       	call   80106210 <acquire>
    release(lk);
80105683:	8b 45 0c             	mov    0xc(%ebp),%eax
80105686:	89 04 24             	mov    %eax,(%esp)
80105689:	e8 e9 0b 00 00       	call   80106277 <release>
  }

  // Go to sleep.
  proc->chan = chan;
8010568e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105694:	8b 55 08             	mov    0x8(%ebp),%edx
80105697:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
8010569a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056a0:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801056a7:	e8 45 fe ff ff       	call   801054f1 <sched>

  // Tidy up.
  proc->chan = 0;
801056ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056b2:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
801056b9:	81 7d 0c c0 5e 11 80 	cmpl   $0x80115ec0,0xc(%ebp)
801056c0:	74 17                	je     801056d9 <sleep+0x99>
    release(&ptable.lock);
801056c2:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
801056c9:	e8 a9 0b 00 00       	call   80106277 <release>
    acquire(lk);
801056ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801056d1:	89 04 24             	mov    %eax,(%esp)
801056d4:	e8 37 0b 00 00       	call   80106210 <acquire>
  }
}
801056d9:	c9                   	leave  
801056da:	c3                   	ret    

801056db <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801056db:	55                   	push   %ebp
801056dc:	89 e5                	mov    %esp,%ebp
801056de:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801056e1:	c7 45 fc f4 5e 11 80 	movl   $0x80115ef4,-0x4(%ebp)
801056e8:	eb 27                	jmp    80105711 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
801056ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056ed:	8b 40 0c             	mov    0xc(%eax),%eax
801056f0:	83 f8 02             	cmp    $0x2,%eax
801056f3:	75 15                	jne    8010570a <wakeup1+0x2f>
801056f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056f8:	8b 40 20             	mov    0x20(%eax),%eax
801056fb:	3b 45 08             	cmp    0x8(%ebp),%eax
801056fe:	75 0a                	jne    8010570a <wakeup1+0x2f>
      p->state = RUNNABLE;
80105700:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105703:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010570a:	81 45 fc a0 00 00 00 	addl   $0xa0,-0x4(%ebp)
80105711:	81 7d fc f4 86 11 80 	cmpl   $0x801186f4,-0x4(%ebp)
80105718:	72 d0                	jb     801056ea <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
8010571a:	c9                   	leave  
8010571b:	c3                   	ret    

8010571c <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010571c:	55                   	push   %ebp
8010571d:	89 e5                	mov    %esp,%ebp
8010571f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105722:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80105729:	e8 e2 0a 00 00       	call   80106210 <acquire>
  wakeup1(chan);
8010572e:	8b 45 08             	mov    0x8(%ebp),%eax
80105731:	89 04 24             	mov    %eax,(%esp)
80105734:	e8 a2 ff ff ff       	call   801056db <wakeup1>
  release(&ptable.lock);
80105739:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80105740:	e8 32 0b 00 00       	call   80106277 <release>
}
80105745:	c9                   	leave  
80105746:	c3                   	ret    

80105747 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105747:	55                   	push   %ebp
80105748:	89 e5                	mov    %esp,%ebp
8010574a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
8010574d:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80105754:	e8 b7 0a 00 00       	call   80106210 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105759:	c7 45 f4 f4 5e 11 80 	movl   $0x80115ef4,-0xc(%ebp)
80105760:	eb 44                	jmp    801057a6 <kill+0x5f>
    if(p->pid == pid){
80105762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105765:	8b 40 10             	mov    0x10(%eax),%eax
80105768:	3b 45 08             	cmp    0x8(%ebp),%eax
8010576b:	75 32                	jne    8010579f <kill+0x58>
      p->killed = 1;
8010576d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105770:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010577a:	8b 40 0c             	mov    0xc(%eax),%eax
8010577d:	83 f8 02             	cmp    $0x2,%eax
80105780:	75 0a                	jne    8010578c <kill+0x45>
        p->state = RUNNABLE;
80105782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105785:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010578c:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80105793:	e8 df 0a 00 00       	call   80106277 <release>
      return 0;
80105798:	b8 00 00 00 00       	mov    $0x0,%eax
8010579d:	eb 21                	jmp    801057c0 <kill+0x79>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010579f:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
801057a6:	81 7d f4 f4 86 11 80 	cmpl   $0x801186f4,-0xc(%ebp)
801057ad:	72 b3                	jb     80105762 <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801057af:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
801057b6:	e8 bc 0a 00 00       	call   80106277 <release>
  return -1;
801057bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057c0:	c9                   	leave  
801057c1:	c3                   	ret    

801057c2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801057c2:	55                   	push   %ebp
801057c3:	89 e5                	mov    %esp,%ebp
801057c5:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801057c8:	c7 45 f0 f4 5e 11 80 	movl   $0x80115ef4,-0x10(%ebp)
801057cf:	e9 d9 00 00 00       	jmp    801058ad <procdump+0xeb>
    if(p->state == UNUSED)
801057d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d7:	8b 40 0c             	mov    0xc(%eax),%eax
801057da:	85 c0                	test   %eax,%eax
801057dc:	75 05                	jne    801057e3 <procdump+0x21>
      continue;
801057de:	e9 c3 00 00 00       	jmp    801058a6 <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801057e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057e6:	8b 40 0c             	mov    0xc(%eax),%eax
801057e9:	83 f8 05             	cmp    $0x5,%eax
801057ec:	77 23                	ja     80105811 <procdump+0x4f>
801057ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057f1:	8b 40 0c             	mov    0xc(%eax),%eax
801057f4:	8b 04 85 14 d0 10 80 	mov    -0x7fef2fec(,%eax,4),%eax
801057fb:	85 c0                	test   %eax,%eax
801057fd:	74 12                	je     80105811 <procdump+0x4f>
      state = states[p->state];
801057ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105802:	8b 40 0c             	mov    0xc(%eax),%eax
80105805:	8b 04 85 14 d0 10 80 	mov    -0x7fef2fec(,%eax,4),%eax
8010580c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010580f:	eb 07                	jmp    80105818 <procdump+0x56>
    else
      state = "???";
80105811:	c7 45 ec 3d 9e 10 80 	movl   $0x80109e3d,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105818:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010581b:	8d 50 6c             	lea    0x6c(%eax),%edx
8010581e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105821:	8b 40 10             	mov    0x10(%eax),%eax
80105824:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105828:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010582b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010582f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105833:	c7 04 24 41 9e 10 80 	movl   $0x80109e41,(%esp)
8010583a:	e8 89 ab ff ff       	call   801003c8 <cprintf>
    if(p->state == SLEEPING){
8010583f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105842:	8b 40 0c             	mov    0xc(%eax),%eax
80105845:	83 f8 02             	cmp    $0x2,%eax
80105848:	75 50                	jne    8010589a <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010584a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010584d:	8b 40 1c             	mov    0x1c(%eax),%eax
80105850:	8b 40 0c             	mov    0xc(%eax),%eax
80105853:	83 c0 08             	add    $0x8,%eax
80105856:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80105859:	89 54 24 04          	mov    %edx,0x4(%esp)
8010585d:	89 04 24             	mov    %eax,(%esp)
80105860:	e8 5f 0a 00 00       	call   801062c4 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80105865:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010586c:	eb 1b                	jmp    80105889 <procdump+0xc7>
        cprintf(" %p", pc[i]);
8010586e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105871:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105875:	89 44 24 04          	mov    %eax,0x4(%esp)
80105879:	c7 04 24 4a 9e 10 80 	movl   $0x80109e4a,(%esp)
80105880:	e8 43 ab ff ff       	call   801003c8 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105885:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105889:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010588d:	7f 0b                	jg     8010589a <procdump+0xd8>
8010588f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105892:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105896:	85 c0                	test   %eax,%eax
80105898:	75 d4                	jne    8010586e <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
8010589a:	c7 04 24 4e 9e 10 80 	movl   $0x80109e4e,(%esp)
801058a1:	e8 22 ab ff ff       	call   801003c8 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801058a6:	81 45 f0 a0 00 00 00 	addl   $0xa0,-0x10(%ebp)
801058ad:	81 7d f0 f4 86 11 80 	cmpl   $0x801186f4,-0x10(%ebp)
801058b4:	0f 82 1a ff ff ff    	jb     801057d4 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801058ba:	c9                   	leave  
801058bb:	c3                   	ret    

801058bc <priority_boost>:

// Design Document 1-1-2-5. priority_boost()
void
priority_boost(void){
801058bc:	55                   	push   %ebp
801058bd:	89 e5                	mov    %esp,%ebp
801058bf:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  
  /** cprintf("[do boosting!]\n"); */

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801058c2:	c7 45 fc f4 5e 11 80 	movl   $0x80115ef4,-0x4(%ebp)
801058c9:	eb 35                	jmp    80105900 <priority_boost+0x44>
    p->level_of_MLFQ = 0;
801058cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058ce:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801058d5:	00 00 00 
    p->tick_used = 0;
801058d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058db:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
    //
    // Design Docuemtn 1-1-2-2. Reinitializing time_quantum_used
    p->time_quantum_used = 0;
801058e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058e5:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801058ec:	00 00 00 


    ptable.MLFQ_tick_used = 0;
801058ef:	c7 05 00 87 11 80 00 	movl   $0x0,0x80118700
801058f6:	00 00 00 
priority_boost(void){
  struct proc *p;
  
  /** cprintf("[do boosting!]\n"); */

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801058f9:	81 45 fc a0 00 00 00 	addl   $0xa0,-0x4(%ebp)
80105900:	81 7d fc f4 86 11 80 	cmpl   $0x801186f4,-0x4(%ebp)
80105907:	72 c2                	jb     801058cb <priority_boost+0xf>
    p->time_quantum_used = 0;


    ptable.MLFQ_tick_used = 0;
  }
}
80105909:	c9                   	leave  
8010590a:	c3                   	ret    

8010590b <set_cpu_share>:

// Design Document 1-1-2-4
int
set_cpu_share(int required) 
{
8010590b:	55                   	push   %ebp
8010590c:	89 e5                	mov    %esp,%ebp
8010590e:	83 ec 20             	sub    $0x20,%esp
  int cpu_share_already_set;
  int desired_sum_cpu_share; // a variable indicating a value when set_cpu_share() succeeds
  const int MIN_CPU_SHARE = 1;
80105911:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  const int MAX_CPU_SHARE = 80;
80105918:	c7 45 f0 50 00 00 00 	movl   $0x50,-0x10(%ebp)
  int is_new;
  int idx;

  // function argument is not valid
  if( ! (MIN_CPU_SHARE <= required && required <= MAX_CPU_SHARE) ) 
8010591f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105922:	3b 45 08             	cmp    0x8(%ebp),%eax
80105925:	0f 8f 19 01 00 00    	jg     80105a44 <set_cpu_share+0x139>
8010592b:	8b 45 08             	mov    0x8(%ebp),%eax
8010592e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80105931:	0f 8f 0d 01 00 00    	jg     80105a44 <set_cpu_share+0x139>
    goto exception;
  
  // Check whether a process is already in the stride queue
  cpu_share_already_set = proc->cpu_share;
80105937:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010593d:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105943:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(cpu_share_already_set == 0){
80105946:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010594a:	75 09                	jne    80105955 <set_cpu_share+0x4a>
    is_new = 1;
8010594c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
80105953:	eb 07                	jmp    8010595c <set_cpu_share+0x51>
  }else{
    is_new = 0;
80105955:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  }

  desired_sum_cpu_share = ptable.sum_cpu_share - cpu_share_already_set + required;
8010595c:	a1 10 88 11 80       	mov    0x80118810,%eax
80105961:	2b 45 ec             	sub    -0x14(%ebp),%eax
80105964:	89 c2                	mov    %eax,%edx
80105966:	8b 45 08             	mov    0x8(%ebp),%eax
80105969:	01 d0                	add    %edx,%eax
8010596b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  // If a required cpu share is too much, an exception occurs.
  if(desired_sum_cpu_share > MAX_CPU_SHARE )
8010596e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105971:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80105974:	7e 05                	jle    8010597b <set_cpu_share+0x70>
    goto exception;
80105976:	e9 c9 00 00 00       	jmp    80105a44 <set_cpu_share+0x139>

  // It is okay to set cpu_share
  ptable.sum_cpu_share = desired_sum_cpu_share;
8010597b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010597e:	a3 10 88 11 80       	mov    %eax,0x80118810
  proc->cpu_share = required;
80105983:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105989:	8b 55 08             	mov    0x8(%ebp),%edx
8010598c:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  proc->stride = NSTRIDE / required;
80105992:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80105999:	b8 10 27 00 00       	mov    $0x2710,%eax
8010599e:	99                   	cltd   
8010599f:	f7 7d 08             	idivl  0x8(%ebp)
801059a2:	89 81 8c 00 00 00    	mov    %eax,0x8c(%ecx)

  if(is_new){
801059a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801059ac:	0f 84 8b 00 00 00    	je     80105a3d <set_cpu_share+0x132>
    // Priority Queue Push
    // We do not need to check whether the stride queue is full because process cannot be generated more than 64

    // new process's stride_count should be minimum of a stride_count in the queue for preventing schuelder from being monopolized.
    if(ptable.stride_queue[1]){
801059b2:	a1 10 87 11 80       	mov    0x80118710,%eax
801059b7:	85 c0                	test   %eax,%eax
801059b9:	74 18                	je     801059d3 <set_cpu_share+0xc8>
      proc->stride_count = ptable.stride_queue[1]->stride_count;
801059bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059c1:	8b 15 10 87 11 80    	mov    0x80118710,%edx
801059c7:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
801059cd:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
801059d3:	a1 14 88 11 80       	mov    0x80118814,%eax
801059d8:	83 c0 01             	add    $0x1,%eax
801059db:	a3 14 88 11 80       	mov    %eax,0x80118814
801059e0:	a1 14 88 11 80       	mov    0x80118814,%eax
801059e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while(idx != 1){
801059e8:	eb 37                	jmp    80105a21 <set_cpu_share+0x116>
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
801059ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
801059ed:	89 c2                	mov    %eax,%edx
801059ef:	c1 ea 1f             	shr    $0x1f,%edx
801059f2:	01 d0                	add    %edx,%eax
801059f4:	d1 f8                	sar    %eax
801059f6:	05 10 0a 00 00       	add    $0xa10,%eax
801059fb:	8b 04 85 cc 5e 11 80 	mov    -0x7feea134(,%eax,4),%eax
80105a02:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105a05:	81 c2 10 0a 00 00    	add    $0xa10,%edx
80105a0b:	89 04 95 cc 5e 11 80 	mov    %eax,-0x7feea134(,%edx,4)
      idx /= 2;
80105a12:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105a15:	89 c2                	mov    %eax,%edx
80105a17:	c1 ea 1f             	shr    $0x1f,%edx
80105a1a:	01 d0                	add    %edx,%eax
80105a1c:	d1 f8                	sar    %eax
80105a1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
      proc->stride_count = ptable.stride_queue[1]->stride_count;
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
    while(idx != 1){
80105a21:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
80105a25:	75 c3                	jne    801059ea <set_cpu_share+0xdf>
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
      idx /= 2;
    }
    ptable.stride_queue[idx] = proc;
80105a27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a2d:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105a30:	81 c2 10 0a 00 00    	add    $0xa10,%edx
80105a36:	89 04 95 cc 5e 11 80 	mov    %eax,-0x7feea134(,%edx,4)
  }else{
    // if a process is already in the stride queue,
    // do nothing.
  }
  return 0;
80105a3d:	b8 00 00 00 00       	mov    $0x0,%eax
80105a42:	eb 05                	jmp    80105a49 <set_cpu_share+0x13e>

exception:
  return -1;
80105a44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a49:	c9                   	leave  
80105a4a:	c3                   	ret    

80105a4b <sys_set_cpu_share>:

int
sys_set_cpu_share(void) 
{
80105a4b:	55                   	push   %ebp
80105a4c:	89 e5                	mov    %esp,%ebp
80105a4e:	83 ec 28             	sub    $0x28,%esp
  int required;
  //Decode argument using argint
  if(argint(0, &required) < 0){
80105a51:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a54:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a5f:	e8 57 0d 00 00       	call   801067bb <argint>
80105a64:	85 c0                	test   %eax,%eax
80105a66:	79 07                	jns    80105a6f <sys_set_cpu_share+0x24>
    return -1;
80105a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6d:	eb 0b                	jmp    80105a7a <sys_set_cpu_share+0x2f>
  }

  return set_cpu_share(required);
80105a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a72:	89 04 24             	mov    %eax,(%esp)
80105a75:	e8 91 fe ff ff       	call   8010590b <set_cpu_share>
}
80105a7a:	c9                   	leave  
80105a7b:	c3                   	ret    

80105a7c <thread_create>:

int
thread_create(thread_t * thread, void * (*start_routine)(void *), void *arg)
{
80105a7c:	55                   	push   %ebp
80105a7d:	89 e5                	mov    %esp,%ebp
80105a7f:	57                   	push   %edi
80105a80:	56                   	push   %esi
80105a81:	53                   	push   %ebx
80105a82:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *np;
  void** arg_ptr;

  // Allocate process.
  // thread. new stack is needed
  if((np = allocproc()) == 0){
80105a85:	e8 79 eb ff ff       	call   80104603 <allocproc>
80105a8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80105a91:	75 0a                	jne    80105a9d <thread_create+0x21>
#ifdef THREAD_DEBUGGING
    cprintf("(thread_create) error: allocproc()\n");
#endif
    return -1;
80105a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a98:	e9 5f 02 00 00       	jmp    80105cfc <thread_create+0x280>
  }

  // add thread information
  np->pid = proc->pid;
80105a9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105aa3:	8b 50 10             	mov    0x10(%eax),%edx
80105aa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105aa9:	89 50 10             	mov    %edx,0x10(%eax)
  np->tid = next_thread_id++;
80105aac:	a1 08 d0 10 80       	mov    0x8010d008,%eax
80105ab1:	8d 50 01             	lea    0x1(%eax),%edx
80105ab4:	89 15 08 d0 10 80    	mov    %edx,0x8010d008
80105aba:	89 c2                	mov    %eax,%edx
80105abc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105abf:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  *thread = np->tid;
80105ac5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ac8:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105ace:	8b 45 08             	mov    0x8(%ebp),%eax
80105ad1:	89 10                	mov    %edx,(%eax)

  // Shallow copy pgdir
  np->pgdir = proc->pgdir; // same address space
80105ad3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ad9:	8b 50 04             	mov    0x4(%eax),%edx
80105adc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105adf:	89 50 04             	mov    %edx,0x4(%eax)
  np->sz = proc->sz;
80105ae2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ae8:	8b 10                	mov    (%eax),%edx
80105aea:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105aed:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80105aef:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105af6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105af9:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80105afc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105aff:	8b 50 18             	mov    0x18(%eax),%edx
80105b02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b08:	8b 40 18             	mov    0x18(%eax),%eax
80105b0b:	89 c3                	mov    %eax,%ebx
80105b0d:	b8 13 00 00 00       	mov    $0x13,%eax
80105b12:	89 d7                	mov    %edx,%edi
80105b14:	89 de                	mov    %ebx,%esi
80105b16:	89 c1                	mov    %eax,%ecx
80105b18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // increase pgdir_ref counter
  np->pgdir_ref_idx= proc->pgdir_ref_idx;
80105b1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b20:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80105b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b29:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  acquire(&thread_lock);
80105b2f:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
80105b36:	e8 d5 06 00 00       	call   80106210 <acquire>
  pgdir_ref[np->pgdir_ref_idx]++;
80105b3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b3e:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105b44:	0f b6 90 80 5e 11 80 	movzbl -0x7feea180(%eax),%edx
80105b4b:	83 c2 01             	add    $0x1,%edx
80105b4e:	88 90 80 5e 11 80    	mov    %dl,-0x7feea180(%eax)
  release(&thread_lock);
80105b54:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
80105b5b:	e8 17 07 00 00       	call   80106277 <release>

  // Clear %eax so that pthread_create returns 0 in the child.
  np->tf->eax = 0;
80105b60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b63:	8b 40 18             	mov    0x18(%eax),%eax
80105b66:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80105b6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105b74:	eb 3d                	jmp    80105bb3 <thread_create+0x137>
    if(proc->ofile[i])
80105b76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b7c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105b7f:	83 c2 08             	add    $0x8,%edx
80105b82:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b86:	85 c0                	test   %eax,%eax
80105b88:	74 25                	je     80105baf <thread_create+0x133>
      np->ofile[i] = filedup(proc->ofile[i]);
80105b8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105b93:	83 c2 08             	add    $0x8,%edx
80105b96:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b9a:	89 04 24             	mov    %eax,(%esp)
80105b9d:	e8 c6 b4 ff ff       	call   80101068 <filedup>
80105ba2:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105ba5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ba8:	83 c1 08             	add    $0x8,%ecx
80105bab:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  release(&thread_lock);

  // Clear %eax so that pthread_create returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80105baf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80105bb3:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80105bb7:	7e bd                	jle    80105b76 <thread_create+0xfa>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80105bb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bbf:	8b 40 68             	mov    0x68(%eax),%eax
80105bc2:	89 04 24             	mov    %eax,(%esp)
80105bc5:	e8 e4 bd ff ff       	call   801019ae <idup>
80105bca:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105bcd:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80105bd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bd6:	8d 50 6c             	lea    0x6c(%eax),%edx
80105bd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105bdc:	83 c0 6c             	add    $0x6c,%eax
80105bdf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105be6:	00 
80105be7:	89 54 24 04          	mov    %edx,0x4(%esp)
80105beb:	89 04 24             	mov    %eax,(%esp)
80105bee:	e8 a6 0a 00 00       	call   80106699 <safestrcpy>

  // allocate a new stack
  np->sz = PGROUNDUP(np->sz);
80105bf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105bf6:	8b 00                	mov    (%eax),%eax
80105bf8:	05 ff 0f 00 00       	add    $0xfff,%eax
80105bfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105c02:	89 c2                	mov    %eax,%edx
80105c04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c07:	89 10                	mov    %edx,(%eax)
  if((np->sz = allocuvm(np->pgdir, np->sz, np->sz + 2*PGSIZE)) == 0) {
80105c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c0c:	8b 00                	mov    (%eax),%eax
80105c0e:	8d 88 00 20 00 00    	lea    0x2000(%eax),%ecx
80105c14:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c17:	8b 10                	mov    (%eax),%edx
80105c19:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c1c:	8b 40 04             	mov    0x4(%eax),%eax
80105c1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105c23:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c27:	89 04 24             	mov    %eax,(%esp)
80105c2a:	e8 3e 38 00 00       	call   8010946d <allocuvm>
80105c2f:	89 c2                	mov    %eax,%edx
80105c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c34:	89 10                	mov    %edx,(%eax)
80105c36:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c39:	8b 00                	mov    (%eax),%eax
80105c3b:	85 c0                	test   %eax,%eax
80105c3d:	75 0a                	jne    80105c49 <thread_create+0x1cd>
    cprintf("(thread_create) error: allocuvm()\n");
    cprintf("** debugging information **\n");
    cprintf("  proc->sz:%d\n", proc->sz);
    // how to decrease parent process's sz?
#endif
    return -1;
80105c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c44:	e9 b3 00 00 00       	jmp    80105cfc <thread_create+0x280>
  }
  clearpteu(np->pgdir, (char*)(np->sz - 2*PGSIZE));
80105c49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c4c:	8b 00                	mov    (%eax),%eax
80105c4e:	2d 00 20 00 00       	sub    $0x2000,%eax
80105c53:	89 c2                	mov    %eax,%edx
80105c55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c58:	8b 40 04             	mov    0x4(%eax),%eax
80105c5b:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c5f:	89 04 24             	mov    %eax,(%esp)
80105c62:	e8 79 3a 00 00       	call   801096e0 <clearpteu>

  acquire(&thread_lock);
80105c67:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
80105c6e:	e8 9d 05 00 00       	call   80106210 <acquire>
  proc->sz = np->sz;
80105c73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c79:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105c7c:	8b 12                	mov    (%edx),%edx
80105c7e:	89 10                	mov    %edx,(%eax)
  // how to decrease parent process's sz?
  release(&thread_lock);
80105c80:	c7 04 24 40 5e 11 80 	movl   $0x80115e40,(%esp)
80105c87:	e8 eb 05 00 00       	call   80106277 <release>

  // edit return address to run desiganted function
  np->tf->eip = (uint)start_routine; // run a rountine.
80105c8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c8f:	8b 40 18             	mov    0x18(%eax),%eax
80105c92:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c95:	89 50 38             	mov    %edx,0x38(%eax)
  np->tf->esp = np->sz - 8;
80105c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105c9b:	8b 40 18             	mov    0x18(%eax),%eax
80105c9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105ca1:	8b 12                	mov    (%edx),%edx
80105ca3:	83 ea 08             	sub    $0x8,%edx
80105ca6:	89 50 44             	mov    %edx,0x44(%eax)

  arg_ptr = (void**)(np->tf->esp);
80105ca9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cac:	8b 40 18             	mov    0x18(%eax),%eax
80105caf:	8b 40 44             	mov    0x44(%eax),%eax
80105cb2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  *arg_ptr = (void*)0xDEADDEAD; // fake return address
80105cb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cb8:	c7 00 ad de ad de    	movl   $0xdeaddead,(%eax)

  arg_ptr = (void**)(np->tf->esp + 4);
80105cbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cc1:	8b 40 18             	mov    0x18(%eax),%eax
80105cc4:	8b 40 44             	mov    0x44(%eax),%eax
80105cc7:	83 c0 04             	add    $0x4,%eax
80105cca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  *arg_ptr = arg; // argument
80105ccd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cd0:	8b 55 10             	mov    0x10(%ebp),%edx
80105cd3:	89 10                	mov    %edx,(%eax)

  acquire(&ptable.lock);
80105cd5:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80105cdc:	e8 2f 05 00 00       	call   80106210 <acquire>

  np->state = RUNNABLE;
80105ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105ce4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  //Design Document 1-1-2-5. A new process is generated.

  release(&ptable.lock);
80105ceb:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80105cf2:	e8 80 05 00 00       	call   80106277 <release>

  return 0;
80105cf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cfc:	83 c4 2c             	add    $0x2c,%esp
80105cff:	5b                   	pop    %ebx
80105d00:	5e                   	pop    %esi
80105d01:	5f                   	pop    %edi
80105d02:	5d                   	pop    %ebp
80105d03:	c3                   	ret    

80105d04 <sys_thread_create>:


int
sys_thread_create(void)
{
80105d04:	55                   	push   %ebp
80105d05:	89 e5                	mov    %esp,%ebp
80105d07:	83 ec 28             	sub    $0x28,%esp
  thread_t * thread;
  void * (*start_routine)(void *);
  void * arg;

  if(argptr(0, (char**)&thread, sizeof(thread)) < 0){
80105d0a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105d11:	00 
80105d12:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d15:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d20:	e8 c4 0a 00 00       	call   801067e9 <argptr>
80105d25:	85 c0                	test   %eax,%eax
80105d27:	79 07                	jns    80105d30 <sys_thread_create+0x2c>
    return -1;
80105d29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2e:	eb 65                	jmp    80105d95 <sys_thread_create+0x91>
  }
  if(argptr(1, (char**)&start_routine, sizeof(start_routine)) < 0){
80105d30:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105d37:	00 
80105d38:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d46:	e8 9e 0a 00 00       	call   801067e9 <argptr>
80105d4b:	85 c0                	test   %eax,%eax
80105d4d:	79 07                	jns    80105d56 <sys_thread_create+0x52>
    return -1;
80105d4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d54:	eb 3f                	jmp    80105d95 <sys_thread_create+0x91>
  }
  if(argptr(2, (char**)&arg, sizeof(arg)) < 0){
80105d56:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105d5d:	00 
80105d5e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d61:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d65:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105d6c:	e8 78 0a 00 00       	call   801067e9 <argptr>
80105d71:	85 c0                	test   %eax,%eax
80105d73:	79 07                	jns    80105d7c <sys_thread_create+0x78>
    return -1;
80105d75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d7a:	eb 19                	jmp    80105d95 <sys_thread_create+0x91>
  }

  return thread_create(thread, start_routine, arg);
80105d7c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80105d7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d85:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105d89:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d8d:	89 04 24             	mov    %eax,(%esp)
80105d90:	e8 e7 fc ff ff       	call   80105a7c <thread_create>
}
80105d95:	c9                   	leave  
80105d96:	c3                   	ret    

80105d97 <thread_exit>:

void
thread_exit(void *retval)
{
80105d97:	55                   	push   %ebp
80105d98:	89 e5                	mov    %esp,%ebp
80105d9a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80105d9d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105da4:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80105da9:	39 c2                	cmp    %eax,%edx
80105dab:	75 0c                	jne    80105db9 <thread_exit+0x22>
    panic("init exiting");
80105dad:	c7 04 24 a5 9d 10 80 	movl   $0x80109da5,(%esp)
80105db4:	e8 a9 a7 ff ff       	call   80100562 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80105db9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105dc0:	eb 44                	jmp    80105e06 <thread_exit+0x6f>
    if(proc->ofile[fd]){
80105dc2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105dcb:	83 c2 08             	add    $0x8,%edx
80105dce:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105dd2:	85 c0                	test   %eax,%eax
80105dd4:	74 2c                	je     80105e02 <thread_exit+0x6b>
      fileclose(proc->ofile[fd]);
80105dd6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ddc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ddf:	83 c2 08             	add    $0x8,%edx
80105de2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105de6:	89 04 24             	mov    %eax,(%esp)
80105de9:	e8 c2 b2 ff ff       	call   801010b0 <fileclose>
      proc->ofile[fd] = 0;
80105dee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105df4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105df7:	83 c2 08             	add    $0x8,%edx
80105dfa:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105e01:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80105e02:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105e06:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80105e0a:	7e b6                	jle    80105dc2 <thread_exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80105e0c:	e8 96 d7 ff ff       	call   801035a7 <begin_op>
  iput(proc->cwd);
80105e11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e17:	8b 40 68             	mov    0x68(%eax),%eax
80105e1a:	89 04 24             	mov    %eax,(%esp)
80105e1d:	e8 19 bd ff ff       	call   80101b3b <iput>
  end_op();
80105e22:	e8 04 d8 ff ff       	call   8010362b <end_op>
  proc->cwd = 0;
80105e27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e2d:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80105e34:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80105e3b:	e8 d0 03 00 00       	call   80106210 <acquire>
  // save a return value in proc
  proc->thread_return = retval;
80105e40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e46:	8b 55 08             	mov    0x8(%ebp),%edx
80105e49:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)

  // delete a process in stride queue
  if(proc->cpu_share != 0){
80105e4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e55:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105e5b:	85 c0                	test   %eax,%eax
80105e5d:	74 05                	je     80105e64 <thread_exit+0xcd>
    stride_queue_delete();
80105e5f:	e8 81 ec ff ff       	call   80104ae5 <stride_queue_delete>
  }

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80105e64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e6a:	8b 40 14             	mov    0x14(%eax),%eax
80105e6d:	89 04 24             	mov    %eax,(%esp)
80105e70:	e8 66 f8 ff ff       	call   801056db <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105e75:	c7 45 f4 f4 5e 11 80 	movl   $0x80115ef4,-0xc(%ebp)
80105e7c:	eb 3b                	jmp    80105eb9 <thread_exit+0x122>
    if(p->parent == proc){
80105e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e81:	8b 50 14             	mov    0x14(%eax),%edx
80105e84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e8a:	39 c2                	cmp    %eax,%edx
80105e8c:	75 24                	jne    80105eb2 <thread_exit+0x11b>
      p->parent = initproc;
80105e8e:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80105e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e97:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80105e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e9d:	8b 40 0c             	mov    0xc(%eax),%eax
80105ea0:	83 f8 05             	cmp    $0x5,%eax
80105ea3:	75 0d                	jne    80105eb2 <thread_exit+0x11b>
        wakeup1(initproc);
80105ea5:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80105eaa:	89 04 24             	mov    %eax,(%esp)
80105ead:	e8 29 f8 ff ff       	call   801056db <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105eb2:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80105eb9:	81 7d f4 f4 86 11 80 	cmpl   $0x801186f4,-0xc(%ebp)
80105ec0:	72 bc                	jb     80105e7e <thread_exit+0xe7>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80105ec2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ec8:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80105ecf:	e8 1d f6 ff ff       	call   801054f1 <sched>
  panic("zombie exit");
80105ed4:	c7 04 24 b2 9d 10 80 	movl   $0x80109db2,(%esp)
80105edb:	e8 82 a6 ff ff       	call   80100562 <panic>

80105ee0 <sys_thread_exit>:
  return;
}

int
sys_thread_exit(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 28             	sub    $0x28,%esp
  void *retval;
  if(argptr(0, (char**)&retval, sizeof(retval)) < 0){
80105ee6:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105eed:	00 
80105eee:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ef1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ef5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105efc:	e8 e8 08 00 00       	call   801067e9 <argptr>
80105f01:	85 c0                	test   %eax,%eax
80105f03:	79 07                	jns    80105f0c <sys_thread_exit+0x2c>
    return -1;
80105f05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f0a:	eb 10                	jmp    80105f1c <sys_thread_exit+0x3c>
  }

  thread_exit(retval);
80105f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f0f:	89 04 24             	mov    %eax,(%esp)
80105f12:	e8 80 fe ff ff       	call   80105d97 <thread_exit>
  return 0;
80105f17:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f1c:	c9                   	leave  
80105f1d:	c3                   	ret    

80105f1e <thread_join>:

int
thread_join(thread_t thread, void **retval)
{
80105f1e:	55                   	push   %ebp
80105f1f:	89 e5                	mov    %esp,%ebp
80105f21:	83 ec 28             	sub    $0x28,%esp
  // TODO
  struct proc *p;
  int havekids;

  acquire(&ptable.lock);
80105f24:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80105f2b:	e8 e0 02 00 00       	call   80106210 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80105f30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105f37:	c7 45 f4 f4 5e 11 80 	movl   $0x80115ef4,-0xc(%ebp)
80105f3e:	e9 c1 00 00 00       	jmp    80106004 <thread_join+0xe6>
      if(p->parent != proc || p->tid != thread)
80105f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f46:	8b 50 14             	mov    0x14(%eax),%edx
80105f49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f4f:	39 c2                	cmp    %eax,%edx
80105f51:	75 0e                	jne    80105f61 <thread_join+0x43>
80105f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f56:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105f5c:	3b 45 08             	cmp    0x8(%ebp),%eax
80105f5f:	74 05                	je     80105f66 <thread_join+0x48>
        continue;
80105f61:	e9 97 00 00 00       	jmp    80105ffd <thread_join+0xdf>
      havekids = 1;
80105f66:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80105f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f70:	8b 40 0c             	mov    0xc(%eax),%eax
80105f73:	83 f8 05             	cmp    $0x5,%eax
80105f76:	0f 85 81 00 00 00    	jne    80105ffd <thread_join+0xdf>
        *retval = p->thread_return;
80105f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f7f:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
80105f85:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f88:	89 10                	mov    %edx,(%eax)

        // when pgdir is not freed, we should call deallocuvm to remove thread stack.
        if (pgdir_ref[p->pgdir_ref_idx] > 1) {
80105f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f8d:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105f93:	0f b6 80 80 5e 11 80 	movzbl -0x7feea180(%eax),%eax
80105f9a:	3c 01                	cmp    $0x1,%al
80105f9c:	7e 41                	jle    80105fdf <thread_join+0xc1>
          // But here is still a problem.
          // For example, there are two thread.
          // First thread is deallocated, and two thread are added.
          // Then the fourth thread will use a same stack with second one.
          // How can I solve this?
          newsz = deallocuvm(p->pgdir, p->sz, p->sz - 2*PGSIZE);
80105f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fa1:	8b 00                	mov    (%eax),%eax
80105fa3:	8d 88 00 e0 ff ff    	lea    -0x2000(%eax),%ecx
80105fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fac:	8b 10                	mov    (%eax),%edx
80105fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb1:	8b 40 04             	mov    0x4(%eax),%eax
80105fb4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105fb8:	89 54 24 04          	mov    %edx,0x4(%esp)
80105fbc:	89 04 24             	mov    %eax,(%esp)
80105fbf:	e8 bf 35 00 00       	call   80109583 <deallocuvm>
80105fc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
          p->parent->sz = newsz < p->parent->sz ? newsz : p->parent->sz;
80105fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fca:	8b 48 14             	mov    0x14(%eax),%ecx
80105fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fd0:	8b 40 14             	mov    0x14(%eax),%eax
80105fd3:	8b 10                	mov    (%eax),%edx
80105fd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105fd8:	39 c2                	cmp    %eax,%edx
80105fda:	0f 46 c2             	cmovbe %edx,%eax
80105fdd:	89 01                	mov    %eax,(%ecx)
        }
        clear_proc(p);
80105fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe2:	89 04 24             	mov    %eax,(%esp)
80105fe5:	e8 55 ed ff ff       	call   80104d3f <clear_proc>

        release(&ptable.lock);
80105fea:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
80105ff1:	e8 81 02 00 00       	call   80106277 <release>
        return 0;
80105ff6:	b8 00 00 00 00       	mov    $0x0,%eax
80105ffb:	eb 55                	jmp    80106052 <thread_join+0x134>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105ffd:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80106004:	81 7d f4 f4 86 11 80 	cmpl   $0x801186f4,-0xc(%ebp)
8010600b:	0f 82 32 ff ff ff    	jb     80105f43 <thread_join+0x25>
        return 0;
      }
    }

    // No point waiting if we don't have any threads.
    if(!havekids || proc->killed){
80106011:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106015:	74 0d                	je     80106024 <thread_join+0x106>
80106017:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010601d:	8b 40 24             	mov    0x24(%eax),%eax
80106020:	85 c0                	test   %eax,%eax
80106022:	74 13                	je     80106037 <thread_join+0x119>
      release(&ptable.lock);
80106024:	c7 04 24 c0 5e 11 80 	movl   $0x80115ec0,(%esp)
8010602b:	e8 47 02 00 00       	call   80106277 <release>
      return -1;
80106030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106035:	eb 1b                	jmp    80106052 <thread_join+0x134>
    }

    // Wait for threads to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80106037:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010603d:	c7 44 24 04 c0 5e 11 	movl   $0x80115ec0,0x4(%esp)
80106044:	80 
80106045:	89 04 24             	mov    %eax,(%esp)
80106048:	e8 f3 f5 ff ff       	call   80105640 <sleep>
  }
8010604d:	e9 de fe ff ff       	jmp    80105f30 <thread_join+0x12>

  return 0;
}
80106052:	c9                   	leave  
80106053:	c3                   	ret    

80106054 <sys_thread_join>:

int
sys_thread_join(void)
{
80106054:	55                   	push   %ebp
80106055:	89 e5                	mov    %esp,%ebp
80106057:	83 ec 28             	sub    $0x28,%esp
  thread_t thread;
  void **retval;

  if(argint(0, (int*)&thread) < 0){
8010605a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010605d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106061:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106068:	e8 4e 07 00 00       	call   801067bb <argint>
8010606d:	85 c0                	test   %eax,%eax
8010606f:	79 07                	jns    80106078 <sys_thread_join+0x24>
    return -1;
80106071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106076:	eb 38                	jmp    801060b0 <sys_thread_join+0x5c>
  }
  if(argptr(1, (char**)&retval, sizeof(retval)) < 0){
80106078:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010607f:	00 
80106080:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106083:	89 44 24 04          	mov    %eax,0x4(%esp)
80106087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010608e:	e8 56 07 00 00       	call   801067e9 <argptr>
80106093:	85 c0                	test   %eax,%eax
80106095:	79 07                	jns    8010609e <sys_thread_join+0x4a>
    return -1;
80106097:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010609c:	eb 12                	jmp    801060b0 <sys_thread_join+0x5c>
  }

  return thread_join(thread, retval);
8010609e:	8b 55 f0             	mov    -0x10(%ebp),%edx
801060a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a4:	89 54 24 04          	mov    %edx,0x4(%esp)
801060a8:	89 04 24             	mov    %eax,(%esp)
801060ab:	e8 6e fe ff ff       	call   80105f1e <thread_join>
}
801060b0:	c9                   	leave  
801060b1:	c3                   	ret    

801060b2 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801060b2:	55                   	push   %ebp
801060b3:	89 e5                	mov    %esp,%ebp
801060b5:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
801060b8:	8b 45 08             	mov    0x8(%ebp),%eax
801060bb:	83 c0 04             	add    $0x4,%eax
801060be:	c7 44 24 04 7a 9e 10 	movl   $0x80109e7a,0x4(%esp)
801060c5:	80 
801060c6:	89 04 24             	mov    %eax,(%esp)
801060c9:	e8 21 01 00 00       	call   801061ef <initlock>
  lk->name = name;
801060ce:	8b 45 08             	mov    0x8(%ebp),%eax
801060d1:	8b 55 0c             	mov    0xc(%ebp),%edx
801060d4:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
801060d7:	8b 45 08             	mov    0x8(%ebp),%eax
801060da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
801060e0:	8b 45 08             	mov    0x8(%ebp),%eax
801060e3:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
801060ea:	c9                   	leave  
801060eb:	c3                   	ret    

801060ec <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801060ec:	55                   	push   %ebp
801060ed:	89 e5                	mov    %esp,%ebp
801060ef:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
801060f2:	8b 45 08             	mov    0x8(%ebp),%eax
801060f5:	83 c0 04             	add    $0x4,%eax
801060f8:	89 04 24             	mov    %eax,(%esp)
801060fb:	e8 10 01 00 00       	call   80106210 <acquire>
  while (lk->locked) {
80106100:	eb 15                	jmp    80106117 <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80106102:	8b 45 08             	mov    0x8(%ebp),%eax
80106105:	83 c0 04             	add    $0x4,%eax
80106108:	89 44 24 04          	mov    %eax,0x4(%esp)
8010610c:	8b 45 08             	mov    0x8(%ebp),%eax
8010610f:	89 04 24             	mov    %eax,(%esp)
80106112:	e8 29 f5 ff ff       	call   80105640 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80106117:	8b 45 08             	mov    0x8(%ebp),%eax
8010611a:	8b 00                	mov    (%eax),%eax
8010611c:	85 c0                	test   %eax,%eax
8010611e:	75 e2                	jne    80106102 <acquiresleep+0x16>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80106120:	8b 45 08             	mov    0x8(%ebp),%eax
80106123:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = proc->pid;
80106129:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010612f:	8b 50 10             	mov    0x10(%eax),%edx
80106132:	8b 45 08             	mov    0x8(%ebp),%eax
80106135:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80106138:	8b 45 08             	mov    0x8(%ebp),%eax
8010613b:	83 c0 04             	add    $0x4,%eax
8010613e:	89 04 24             	mov    %eax,(%esp)
80106141:	e8 31 01 00 00       	call   80106277 <release>
}
80106146:	c9                   	leave  
80106147:	c3                   	ret    

80106148 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80106148:	55                   	push   %ebp
80106149:	89 e5                	mov    %esp,%ebp
8010614b:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
8010614e:	8b 45 08             	mov    0x8(%ebp),%eax
80106151:	83 c0 04             	add    $0x4,%eax
80106154:	89 04 24             	mov    %eax,(%esp)
80106157:	e8 b4 00 00 00       	call   80106210 <acquire>
  lk->locked = 0;
8010615c:	8b 45 08             	mov    0x8(%ebp),%eax
8010615f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80106165:	8b 45 08             	mov    0x8(%ebp),%eax
80106168:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
8010616f:	8b 45 08             	mov    0x8(%ebp),%eax
80106172:	89 04 24             	mov    %eax,(%esp)
80106175:	e8 a2 f5 ff ff       	call   8010571c <wakeup>
  release(&lk->lk);
8010617a:	8b 45 08             	mov    0x8(%ebp),%eax
8010617d:	83 c0 04             	add    $0x4,%eax
80106180:	89 04 24             	mov    %eax,(%esp)
80106183:	e8 ef 00 00 00       	call   80106277 <release>
}
80106188:	c9                   	leave  
80106189:	c3                   	ret    

8010618a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
8010618a:	55                   	push   %ebp
8010618b:	89 e5                	mov    %esp,%ebp
8010618d:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
80106190:	8b 45 08             	mov    0x8(%ebp),%eax
80106193:	83 c0 04             	add    $0x4,%eax
80106196:	89 04 24             	mov    %eax,(%esp)
80106199:	e8 72 00 00 00       	call   80106210 <acquire>
  r = lk->locked;
8010619e:	8b 45 08             	mov    0x8(%ebp),%eax
801061a1:	8b 00                	mov    (%eax),%eax
801061a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
801061a6:	8b 45 08             	mov    0x8(%ebp),%eax
801061a9:	83 c0 04             	add    $0x4,%eax
801061ac:	89 04 24             	mov    %eax,(%esp)
801061af:	e8 c3 00 00 00       	call   80106277 <release>
  return r;
801061b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801061b7:	c9                   	leave  
801061b8:	c3                   	ret    

801061b9 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801061b9:	55                   	push   %ebp
801061ba:	89 e5                	mov    %esp,%ebp
801061bc:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801061bf:	9c                   	pushf  
801061c0:	58                   	pop    %eax
801061c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801061c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801061c7:	c9                   	leave  
801061c8:	c3                   	ret    

801061c9 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801061c9:	55                   	push   %ebp
801061ca:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801061cc:	fa                   	cli    
}
801061cd:	5d                   	pop    %ebp
801061ce:	c3                   	ret    

801061cf <sti>:

static inline void
sti(void)
{
801061cf:	55                   	push   %ebp
801061d0:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801061d2:	fb                   	sti    
}
801061d3:	5d                   	pop    %ebp
801061d4:	c3                   	ret    

801061d5 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801061d5:	55                   	push   %ebp
801061d6:	89 e5                	mov    %esp,%ebp
801061d8:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801061db:	8b 55 08             	mov    0x8(%ebp),%edx
801061de:	8b 45 0c             	mov    0xc(%ebp),%eax
801061e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801061e4:	f0 87 02             	lock xchg %eax,(%edx)
801061e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801061ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801061ed:	c9                   	leave  
801061ee:	c3                   	ret    

801061ef <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801061ef:	55                   	push   %ebp
801061f0:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801061f2:	8b 45 08             	mov    0x8(%ebp),%eax
801061f5:	8b 55 0c             	mov    0xc(%ebp),%edx
801061f8:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801061fb:	8b 45 08             	mov    0x8(%ebp),%eax
801061fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106204:	8b 45 08             	mov    0x8(%ebp),%eax
80106207:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010620e:	5d                   	pop    %ebp
8010620f:	c3                   	ret    

80106210 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106216:	e8 4c 01 00 00       	call   80106367 <pushcli>
  if(holding(lk))
8010621b:	8b 45 08             	mov    0x8(%ebp),%eax
8010621e:	89 04 24             	mov    %eax,(%esp)
80106221:	e8 17 01 00 00       	call   8010633d <holding>
80106226:	85 c0                	test   %eax,%eax
80106228:	74 0c                	je     80106236 <acquire+0x26>
    panic("acquire");
8010622a:	c7 04 24 85 9e 10 80 	movl   $0x80109e85,(%esp)
80106231:	e8 2c a3 ff ff       	call   80100562 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80106236:	90                   	nop
80106237:	8b 45 08             	mov    0x8(%ebp),%eax
8010623a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106241:	00 
80106242:	89 04 24             	mov    %eax,(%esp)
80106245:	e8 8b ff ff ff       	call   801061d5 <xchg>
8010624a:	85 c0                	test   %eax,%eax
8010624c:	75 e9                	jne    80106237 <acquire+0x27>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010624e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80106253:	8b 45 08             	mov    0x8(%ebp),%eax
80106256:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010625d:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80106260:	8b 45 08             	mov    0x8(%ebp),%eax
80106263:	83 c0 0c             	add    $0xc,%eax
80106266:	89 44 24 04          	mov    %eax,0x4(%esp)
8010626a:	8d 45 08             	lea    0x8(%ebp),%eax
8010626d:	89 04 24             	mov    %eax,(%esp)
80106270:	e8 4f 00 00 00       	call   801062c4 <getcallerpcs>
}
80106275:	c9                   	leave  
80106276:	c3                   	ret    

80106277 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80106277:	55                   	push   %ebp
80106278:	89 e5                	mov    %esp,%ebp
8010627a:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
8010627d:	8b 45 08             	mov    0x8(%ebp),%eax
80106280:	89 04 24             	mov    %eax,(%esp)
80106283:	e8 b5 00 00 00       	call   8010633d <holding>
80106288:	85 c0                	test   %eax,%eax
8010628a:	75 0c                	jne    80106298 <release+0x21>
    panic("release");
8010628c:	c7 04 24 8d 9e 10 80 	movl   $0x80109e8d,(%esp)
80106293:	e8 ca a2 ff ff       	call   80100562 <panic>

  lk->pcs[0] = 0;
80106298:	8b 45 08             	mov    0x8(%ebp),%eax
8010629b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801062a2:	8b 45 08             	mov    0x8(%ebp),%eax
801062a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801062ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801062b1:	8b 45 08             	mov    0x8(%ebp),%eax
801062b4:	8b 55 08             	mov    0x8(%ebp),%edx
801062b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
801062bd:	e8 fb 00 00 00       	call   801063bd <popcli>
}
801062c2:	c9                   	leave  
801062c3:	c3                   	ret    

801062c4 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801062c4:	55                   	push   %ebp
801062c5:	89 e5                	mov    %esp,%ebp
801062c7:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801062ca:	8b 45 08             	mov    0x8(%ebp),%eax
801062cd:	83 e8 08             	sub    $0x8,%eax
801062d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801062d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801062da:	eb 38                	jmp    80106314 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801062dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801062e0:	74 38                	je     8010631a <getcallerpcs+0x56>
801062e2:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801062e9:	76 2f                	jbe    8010631a <getcallerpcs+0x56>
801062eb:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801062ef:	74 29                	je     8010631a <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
801062f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801062f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801062fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801062fe:	01 c2                	add    %eax,%edx
80106300:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106303:	8b 40 04             	mov    0x4(%eax),%eax
80106306:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80106308:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010630b:	8b 00                	mov    (%eax),%eax
8010630d:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106310:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106314:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106318:	7e c2                	jle    801062dc <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010631a:	eb 19                	jmp    80106335 <getcallerpcs+0x71>
    pcs[i] = 0;
8010631c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010631f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106326:	8b 45 0c             	mov    0xc(%ebp),%eax
80106329:	01 d0                	add    %edx,%eax
8010632b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106331:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106335:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106339:	7e e1                	jle    8010631c <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010633b:	c9                   	leave  
8010633c:	c3                   	ret    

8010633d <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010633d:	55                   	push   %ebp
8010633e:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106340:	8b 45 08             	mov    0x8(%ebp),%eax
80106343:	8b 00                	mov    (%eax),%eax
80106345:	85 c0                	test   %eax,%eax
80106347:	74 17                	je     80106360 <holding+0x23>
80106349:	8b 45 08             	mov    0x8(%ebp),%eax
8010634c:	8b 50 08             	mov    0x8(%eax),%edx
8010634f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106355:	39 c2                	cmp    %eax,%edx
80106357:	75 07                	jne    80106360 <holding+0x23>
80106359:	b8 01 00 00 00       	mov    $0x1,%eax
8010635e:	eb 05                	jmp    80106365 <holding+0x28>
80106360:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106365:	5d                   	pop    %ebp
80106366:	c3                   	ret    

80106367 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80106367:	55                   	push   %ebp
80106368:	89 e5                	mov    %esp,%ebp
8010636a:	83 ec 10             	sub    $0x10,%esp
  int eflags;

  eflags = readeflags();
8010636d:	e8 47 fe ff ff       	call   801061b9 <readeflags>
80106372:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80106375:	e8 4f fe ff ff       	call   801061c9 <cli>
  if(cpu->ncli == 0)
8010637a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106380:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106386:	85 c0                	test   %eax,%eax
80106388:	75 15                	jne    8010639f <pushcli+0x38>
    cpu->intena = eflags & FL_IF;
8010638a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106390:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106393:	81 e2 00 02 00 00    	and    $0x200,%edx
80106399:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
  cpu->ncli += 1;
8010639f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801063a5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801063ac:	8b 92 ac 00 00 00    	mov    0xac(%edx),%edx
801063b2:	83 c2 01             	add    $0x1,%edx
801063b5:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
801063bb:	c9                   	leave  
801063bc:	c3                   	ret    

801063bd <popcli>:

void
popcli(void)
{
801063bd:	55                   	push   %ebp
801063be:	89 e5                	mov    %esp,%ebp
801063c0:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801063c3:	e8 f1 fd ff ff       	call   801061b9 <readeflags>
801063c8:	25 00 02 00 00       	and    $0x200,%eax
801063cd:	85 c0                	test   %eax,%eax
801063cf:	74 0c                	je     801063dd <popcli+0x20>
    panic("popcli - interruptible");
801063d1:	c7 04 24 95 9e 10 80 	movl   $0x80109e95,(%esp)
801063d8:	e8 85 a1 ff ff       	call   80100562 <panic>
  if(--cpu->ncli < 0)
801063dd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801063e3:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801063e9:	83 ea 01             	sub    $0x1,%edx
801063ec:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801063f2:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801063f8:	85 c0                	test   %eax,%eax
801063fa:	79 0c                	jns    80106408 <popcli+0x4b>
    panic("popcli");
801063fc:	c7 04 24 ac 9e 10 80 	movl   $0x80109eac,(%esp)
80106403:	e8 5a a1 ff ff       	call   80100562 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106408:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010640e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106414:	85 c0                	test   %eax,%eax
80106416:	75 15                	jne    8010642d <popcli+0x70>
80106418:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010641e:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106424:	85 c0                	test   %eax,%eax
80106426:	74 05                	je     8010642d <popcli+0x70>
    sti();
80106428:	e8 a2 fd ff ff       	call   801061cf <sti>
}
8010642d:	c9                   	leave  
8010642e:	c3                   	ret    

8010642f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010642f:	55                   	push   %ebp
80106430:	89 e5                	mov    %esp,%ebp
80106432:	57                   	push   %edi
80106433:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106434:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106437:	8b 55 10             	mov    0x10(%ebp),%edx
8010643a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010643d:	89 cb                	mov    %ecx,%ebx
8010643f:	89 df                	mov    %ebx,%edi
80106441:	89 d1                	mov    %edx,%ecx
80106443:	fc                   	cld    
80106444:	f3 aa                	rep stos %al,%es:(%edi)
80106446:	89 ca                	mov    %ecx,%edx
80106448:	89 fb                	mov    %edi,%ebx
8010644a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010644d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106450:	5b                   	pop    %ebx
80106451:	5f                   	pop    %edi
80106452:	5d                   	pop    %ebp
80106453:	c3                   	ret    

80106454 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106454:	55                   	push   %ebp
80106455:	89 e5                	mov    %esp,%ebp
80106457:	57                   	push   %edi
80106458:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106459:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010645c:	8b 55 10             	mov    0x10(%ebp),%edx
8010645f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106462:	89 cb                	mov    %ecx,%ebx
80106464:	89 df                	mov    %ebx,%edi
80106466:	89 d1                	mov    %edx,%ecx
80106468:	fc                   	cld    
80106469:	f3 ab                	rep stos %eax,%es:(%edi)
8010646b:	89 ca                	mov    %ecx,%edx
8010646d:	89 fb                	mov    %edi,%ebx
8010646f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106472:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106475:	5b                   	pop    %ebx
80106476:	5f                   	pop    %edi
80106477:	5d                   	pop    %ebp
80106478:	c3                   	ret    

80106479 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106479:	55                   	push   %ebp
8010647a:	89 e5                	mov    %esp,%ebp
8010647c:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
8010647f:	8b 45 08             	mov    0x8(%ebp),%eax
80106482:	83 e0 03             	and    $0x3,%eax
80106485:	85 c0                	test   %eax,%eax
80106487:	75 49                	jne    801064d2 <memset+0x59>
80106489:	8b 45 10             	mov    0x10(%ebp),%eax
8010648c:	83 e0 03             	and    $0x3,%eax
8010648f:	85 c0                	test   %eax,%eax
80106491:	75 3f                	jne    801064d2 <memset+0x59>
    c &= 0xFF;
80106493:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010649a:	8b 45 10             	mov    0x10(%ebp),%eax
8010649d:	c1 e8 02             	shr    $0x2,%eax
801064a0:	89 c2                	mov    %eax,%edx
801064a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801064a5:	c1 e0 18             	shl    $0x18,%eax
801064a8:	89 c1                	mov    %eax,%ecx
801064aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801064ad:	c1 e0 10             	shl    $0x10,%eax
801064b0:	09 c1                	or     %eax,%ecx
801064b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801064b5:	c1 e0 08             	shl    $0x8,%eax
801064b8:	09 c8                	or     %ecx,%eax
801064ba:	0b 45 0c             	or     0xc(%ebp),%eax
801064bd:	89 54 24 08          	mov    %edx,0x8(%esp)
801064c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801064c5:	8b 45 08             	mov    0x8(%ebp),%eax
801064c8:	89 04 24             	mov    %eax,(%esp)
801064cb:	e8 84 ff ff ff       	call   80106454 <stosl>
801064d0:	eb 19                	jmp    801064eb <memset+0x72>
  } else
    stosb(dst, c, n);
801064d2:	8b 45 10             	mov    0x10(%ebp),%eax
801064d5:	89 44 24 08          	mov    %eax,0x8(%esp)
801064d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801064dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801064e0:	8b 45 08             	mov    0x8(%ebp),%eax
801064e3:	89 04 24             	mov    %eax,(%esp)
801064e6:	e8 44 ff ff ff       	call   8010642f <stosb>
  return dst;
801064eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801064ee:	c9                   	leave  
801064ef:	c3                   	ret    

801064f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
801064f6:	8b 45 08             	mov    0x8(%ebp),%eax
801064f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801064fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801064ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106502:	eb 30                	jmp    80106534 <memcmp+0x44>
    if(*s1 != *s2)
80106504:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106507:	0f b6 10             	movzbl (%eax),%edx
8010650a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010650d:	0f b6 00             	movzbl (%eax),%eax
80106510:	38 c2                	cmp    %al,%dl
80106512:	74 18                	je     8010652c <memcmp+0x3c>
      return *s1 - *s2;
80106514:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106517:	0f b6 00             	movzbl (%eax),%eax
8010651a:	0f b6 d0             	movzbl %al,%edx
8010651d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106520:	0f b6 00             	movzbl (%eax),%eax
80106523:	0f b6 c0             	movzbl %al,%eax
80106526:	29 c2                	sub    %eax,%edx
80106528:	89 d0                	mov    %edx,%eax
8010652a:	eb 1a                	jmp    80106546 <memcmp+0x56>
    s1++, s2++;
8010652c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106530:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106534:	8b 45 10             	mov    0x10(%ebp),%eax
80106537:	8d 50 ff             	lea    -0x1(%eax),%edx
8010653a:	89 55 10             	mov    %edx,0x10(%ebp)
8010653d:	85 c0                	test   %eax,%eax
8010653f:	75 c3                	jne    80106504 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106541:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106546:	c9                   	leave  
80106547:	c3                   	ret    

80106548 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106548:	55                   	push   %ebp
80106549:	89 e5                	mov    %esp,%ebp
8010654b:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010654e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106551:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106554:	8b 45 08             	mov    0x8(%ebp),%eax
80106557:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010655a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010655d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106560:	73 3d                	jae    8010659f <memmove+0x57>
80106562:	8b 45 10             	mov    0x10(%ebp),%eax
80106565:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106568:	01 d0                	add    %edx,%eax
8010656a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010656d:	76 30                	jbe    8010659f <memmove+0x57>
    s += n;
8010656f:	8b 45 10             	mov    0x10(%ebp),%eax
80106572:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106575:	8b 45 10             	mov    0x10(%ebp),%eax
80106578:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010657b:	eb 13                	jmp    80106590 <memmove+0x48>
      *--d = *--s;
8010657d:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106581:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106585:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106588:	0f b6 10             	movzbl (%eax),%edx
8010658b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010658e:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106590:	8b 45 10             	mov    0x10(%ebp),%eax
80106593:	8d 50 ff             	lea    -0x1(%eax),%edx
80106596:	89 55 10             	mov    %edx,0x10(%ebp)
80106599:	85 c0                	test   %eax,%eax
8010659b:	75 e0                	jne    8010657d <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010659d:	eb 26                	jmp    801065c5 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010659f:	eb 17                	jmp    801065b8 <memmove+0x70>
      *d++ = *s++;
801065a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801065a4:	8d 50 01             	lea    0x1(%eax),%edx
801065a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
801065aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
801065ad:	8d 4a 01             	lea    0x1(%edx),%ecx
801065b0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801065b3:	0f b6 12             	movzbl (%edx),%edx
801065b6:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801065b8:	8b 45 10             	mov    0x10(%ebp),%eax
801065bb:	8d 50 ff             	lea    -0x1(%eax),%edx
801065be:	89 55 10             	mov    %edx,0x10(%ebp)
801065c1:	85 c0                	test   %eax,%eax
801065c3:	75 dc                	jne    801065a1 <memmove+0x59>
      *d++ = *s++;

  return dst;
801065c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
801065c8:	c9                   	leave  
801065c9:	c3                   	ret    

801065ca <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801065ca:	55                   	push   %ebp
801065cb:	89 e5                	mov    %esp,%ebp
801065cd:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801065d0:	8b 45 10             	mov    0x10(%ebp),%eax
801065d3:	89 44 24 08          	mov    %eax,0x8(%esp)
801065d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801065da:	89 44 24 04          	mov    %eax,0x4(%esp)
801065de:	8b 45 08             	mov    0x8(%ebp),%eax
801065e1:	89 04 24             	mov    %eax,(%esp)
801065e4:	e8 5f ff ff ff       	call   80106548 <memmove>
}
801065e9:	c9                   	leave  
801065ea:	c3                   	ret    

801065eb <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801065eb:	55                   	push   %ebp
801065ec:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801065ee:	eb 0c                	jmp    801065fc <strncmp+0x11>
    n--, p++, q++;
801065f0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801065f4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801065f8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801065fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106600:	74 1a                	je     8010661c <strncmp+0x31>
80106602:	8b 45 08             	mov    0x8(%ebp),%eax
80106605:	0f b6 00             	movzbl (%eax),%eax
80106608:	84 c0                	test   %al,%al
8010660a:	74 10                	je     8010661c <strncmp+0x31>
8010660c:	8b 45 08             	mov    0x8(%ebp),%eax
8010660f:	0f b6 10             	movzbl (%eax),%edx
80106612:	8b 45 0c             	mov    0xc(%ebp),%eax
80106615:	0f b6 00             	movzbl (%eax),%eax
80106618:	38 c2                	cmp    %al,%dl
8010661a:	74 d4                	je     801065f0 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010661c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106620:	75 07                	jne    80106629 <strncmp+0x3e>
    return 0;
80106622:	b8 00 00 00 00       	mov    $0x0,%eax
80106627:	eb 16                	jmp    8010663f <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106629:	8b 45 08             	mov    0x8(%ebp),%eax
8010662c:	0f b6 00             	movzbl (%eax),%eax
8010662f:	0f b6 d0             	movzbl %al,%edx
80106632:	8b 45 0c             	mov    0xc(%ebp),%eax
80106635:	0f b6 00             	movzbl (%eax),%eax
80106638:	0f b6 c0             	movzbl %al,%eax
8010663b:	29 c2                	sub    %eax,%edx
8010663d:	89 d0                	mov    %edx,%eax
}
8010663f:	5d                   	pop    %ebp
80106640:	c3                   	ret    

80106641 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106641:	55                   	push   %ebp
80106642:	89 e5                	mov    %esp,%ebp
80106644:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80106647:	8b 45 08             	mov    0x8(%ebp),%eax
8010664a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010664d:	90                   	nop
8010664e:	8b 45 10             	mov    0x10(%ebp),%eax
80106651:	8d 50 ff             	lea    -0x1(%eax),%edx
80106654:	89 55 10             	mov    %edx,0x10(%ebp)
80106657:	85 c0                	test   %eax,%eax
80106659:	7e 1e                	jle    80106679 <strncpy+0x38>
8010665b:	8b 45 08             	mov    0x8(%ebp),%eax
8010665e:	8d 50 01             	lea    0x1(%eax),%edx
80106661:	89 55 08             	mov    %edx,0x8(%ebp)
80106664:	8b 55 0c             	mov    0xc(%ebp),%edx
80106667:	8d 4a 01             	lea    0x1(%edx),%ecx
8010666a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010666d:	0f b6 12             	movzbl (%edx),%edx
80106670:	88 10                	mov    %dl,(%eax)
80106672:	0f b6 00             	movzbl (%eax),%eax
80106675:	84 c0                	test   %al,%al
80106677:	75 d5                	jne    8010664e <strncpy+0xd>
    ;
  while(n-- > 0)
80106679:	eb 0c                	jmp    80106687 <strncpy+0x46>
    *s++ = 0;
8010667b:	8b 45 08             	mov    0x8(%ebp),%eax
8010667e:	8d 50 01             	lea    0x1(%eax),%edx
80106681:	89 55 08             	mov    %edx,0x8(%ebp)
80106684:	c6 00 00             	movb   $0x0,(%eax)
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106687:	8b 45 10             	mov    0x10(%ebp),%eax
8010668a:	8d 50 ff             	lea    -0x1(%eax),%edx
8010668d:	89 55 10             	mov    %edx,0x10(%ebp)
80106690:	85 c0                	test   %eax,%eax
80106692:	7f e7                	jg     8010667b <strncpy+0x3a>
    *s++ = 0;
  return os;
80106694:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106697:	c9                   	leave  
80106698:	c3                   	ret    

80106699 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106699:	55                   	push   %ebp
8010669a:	89 e5                	mov    %esp,%ebp
8010669c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
8010669f:	8b 45 08             	mov    0x8(%ebp),%eax
801066a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801066a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801066a9:	7f 05                	jg     801066b0 <safestrcpy+0x17>
    return os;
801066ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801066ae:	eb 31                	jmp    801066e1 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801066b0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801066b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801066b8:	7e 1e                	jle    801066d8 <safestrcpy+0x3f>
801066ba:	8b 45 08             	mov    0x8(%ebp),%eax
801066bd:	8d 50 01             	lea    0x1(%eax),%edx
801066c0:	89 55 08             	mov    %edx,0x8(%ebp)
801066c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801066c6:	8d 4a 01             	lea    0x1(%edx),%ecx
801066c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801066cc:	0f b6 12             	movzbl (%edx),%edx
801066cf:	88 10                	mov    %dl,(%eax)
801066d1:	0f b6 00             	movzbl (%eax),%eax
801066d4:	84 c0                	test   %al,%al
801066d6:	75 d8                	jne    801066b0 <safestrcpy+0x17>
    ;
  *s = 0;
801066d8:	8b 45 08             	mov    0x8(%ebp),%eax
801066db:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801066de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801066e1:	c9                   	leave  
801066e2:	c3                   	ret    

801066e3 <strlen>:

int
strlen(const char *s)
{
801066e3:	55                   	push   %ebp
801066e4:	89 e5                	mov    %esp,%ebp
801066e6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801066e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801066f0:	eb 04                	jmp    801066f6 <strlen+0x13>
801066f2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801066f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801066f9:	8b 45 08             	mov    0x8(%ebp),%eax
801066fc:	01 d0                	add    %edx,%eax
801066fe:	0f b6 00             	movzbl (%eax),%eax
80106701:	84 c0                	test   %al,%al
80106703:	75 ed                	jne    801066f2 <strlen+0xf>
    ;
  return n;
80106705:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106708:	c9                   	leave  
80106709:	c3                   	ret    

8010670a <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax # esp는 return address를 가리키고 있다(old). 아직 스택에 아무것도 push가 안됐으므로, return address를 가리킨다.
8010670a:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx # new
8010670e:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  # 아래 push하는 레지스터들은 convention에 따른다.
  # eip는 push하지 않는다. esp를 그냥 eip로 삼겠다는 것.
  pushl %ebp
80106712:	55                   	push   %ebp
  pushl %ebx
80106713:	53                   	push   %ebx
  pushl %esi
80106714:	56                   	push   %esi
  pushl %edi
80106715:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax) # esp의 값을 eax가 가리키고 있는 주소에 넣는다. eax는 old. old가 edi를 가리키게 된다. 즉 old는 old context를 가리키게 된다.
80106716:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp # edx는 new가 있다. esp에 edx를 넣는다는 것은 새로운 스택을 쓰겠다는 것. 여기서 하나씩 뺴면 new context의 값을 cpu register에 넣는다.
80106718:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010671a:	5f                   	pop    %edi
  popl %esi
8010671b:	5e                   	pop    %esi
  popl %ebx
8010671c:	5b                   	pop    %ebx
  popl %ebp
8010671d:	5d                   	pop    %ebp
  ret # eip를 빼는 것. ret는 call과 쌍이다. call에서 return address를 넣는다. 맞나? ret를 실행함으로써 eip를 리턴한다? 뺀다?
8010671e:	c3                   	ret    

8010671f <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010671f:	55                   	push   %ebp
80106720:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106722:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106728:	8b 00                	mov    (%eax),%eax
8010672a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010672d:	76 12                	jbe    80106741 <fetchint+0x22>
8010672f:	8b 45 08             	mov    0x8(%ebp),%eax
80106732:	8d 50 04             	lea    0x4(%eax),%edx
80106735:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010673b:	8b 00                	mov    (%eax),%eax
8010673d:	39 c2                	cmp    %eax,%edx
8010673f:	76 07                	jbe    80106748 <fetchint+0x29>
    return -1;
80106741:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106746:	eb 0f                	jmp    80106757 <fetchint+0x38>
  *ip = *(int*)(addr);
80106748:	8b 45 08             	mov    0x8(%ebp),%eax
8010674b:	8b 10                	mov    (%eax),%edx
8010674d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106750:	89 10                	mov    %edx,(%eax)
  return 0;
80106752:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106757:	5d                   	pop    %ebp
80106758:	c3                   	ret    

80106759 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106759:	55                   	push   %ebp
8010675a:	89 e5                	mov    %esp,%ebp
8010675c:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010675f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106765:	8b 00                	mov    (%eax),%eax
80106767:	3b 45 08             	cmp    0x8(%ebp),%eax
8010676a:	77 07                	ja     80106773 <fetchstr+0x1a>
    return -1;
8010676c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106771:	eb 46                	jmp    801067b9 <fetchstr+0x60>
  *pp = (char*)addr;
80106773:	8b 55 08             	mov    0x8(%ebp),%edx
80106776:	8b 45 0c             	mov    0xc(%ebp),%eax
80106779:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010677b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106781:	8b 00                	mov    (%eax),%eax
80106783:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106786:	8b 45 0c             	mov    0xc(%ebp),%eax
80106789:	8b 00                	mov    (%eax),%eax
8010678b:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010678e:	eb 1c                	jmp    801067ac <fetchstr+0x53>
    if(*s == 0)
80106790:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106793:	0f b6 00             	movzbl (%eax),%eax
80106796:	84 c0                	test   %al,%al
80106798:	75 0e                	jne    801067a8 <fetchstr+0x4f>
      return s - *pp;
8010679a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010679d:	8b 45 0c             	mov    0xc(%ebp),%eax
801067a0:	8b 00                	mov    (%eax),%eax
801067a2:	29 c2                	sub    %eax,%edx
801067a4:	89 d0                	mov    %edx,%eax
801067a6:	eb 11                	jmp    801067b9 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801067a8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801067ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
801067af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801067b2:	72 dc                	jb     80106790 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801067b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067b9:	c9                   	leave  
801067ba:	c3                   	ret    

801067bb <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801067bb:	55                   	push   %ebp
801067bc:	89 e5                	mov    %esp,%ebp
801067be:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801067c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067c7:	8b 40 18             	mov    0x18(%eax),%eax
801067ca:	8b 50 44             	mov    0x44(%eax),%edx
801067cd:	8b 45 08             	mov    0x8(%ebp),%eax
801067d0:	c1 e0 02             	shl    $0x2,%eax
801067d3:	01 d0                	add    %edx,%eax
801067d5:	8d 50 04             	lea    0x4(%eax),%edx
801067d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801067db:	89 44 24 04          	mov    %eax,0x4(%esp)
801067df:	89 14 24             	mov    %edx,(%esp)
801067e2:	e8 38 ff ff ff       	call   8010671f <fetchint>
}
801067e7:	c9                   	leave  
801067e8:	c3                   	ret    

801067e9 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801067e9:	55                   	push   %ebp
801067ea:	89 e5                	mov    %esp,%ebp
801067ec:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(argint(n, &i) < 0)
801067ef:	8d 45 fc             	lea    -0x4(%ebp),%eax
801067f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801067f6:	8b 45 08             	mov    0x8(%ebp),%eax
801067f9:	89 04 24             	mov    %eax,(%esp)
801067fc:	e8 ba ff ff ff       	call   801067bb <argint>
80106801:	85 c0                	test   %eax,%eax
80106803:	79 07                	jns    8010680c <argptr+0x23>
    return -1;
80106805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010680a:	eb 43                	jmp    8010684f <argptr+0x66>
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
8010680c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106810:	78 27                	js     80106839 <argptr+0x50>
80106812:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106815:	89 c2                	mov    %eax,%edx
80106817:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010681d:	8b 00                	mov    (%eax),%eax
8010681f:	39 c2                	cmp    %eax,%edx
80106821:	73 16                	jae    80106839 <argptr+0x50>
80106823:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106826:	89 c2                	mov    %eax,%edx
80106828:	8b 45 10             	mov    0x10(%ebp),%eax
8010682b:	01 c2                	add    %eax,%edx
8010682d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106833:	8b 00                	mov    (%eax),%eax
80106835:	39 c2                	cmp    %eax,%edx
80106837:	76 07                	jbe    80106840 <argptr+0x57>
    return -1;
80106839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010683e:	eb 0f                	jmp    8010684f <argptr+0x66>
  *pp = (char*)i;
80106840:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106843:	89 c2                	mov    %eax,%edx
80106845:	8b 45 0c             	mov    0xc(%ebp),%eax
80106848:	89 10                	mov    %edx,(%eax)
  return 0;
8010684a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010684f:	c9                   	leave  
80106850:	c3                   	ret    

80106851 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106851:	55                   	push   %ebp
80106852:	89 e5                	mov    %esp,%ebp
80106854:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106857:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010685a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010685e:	8b 45 08             	mov    0x8(%ebp),%eax
80106861:	89 04 24             	mov    %eax,(%esp)
80106864:	e8 52 ff ff ff       	call   801067bb <argint>
80106869:	85 c0                	test   %eax,%eax
8010686b:	79 07                	jns    80106874 <argstr+0x23>
    return -1;
8010686d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106872:	eb 12                	jmp    80106886 <argstr+0x35>
  return fetchstr(addr, pp);
80106874:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106877:	8b 55 0c             	mov    0xc(%ebp),%edx
8010687a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010687e:	89 04 24             	mov    %eax,(%esp)
80106881:	e8 d3 fe ff ff       	call   80106759 <fetchstr>
}
80106886:	c9                   	leave  
80106887:	c3                   	ret    

80106888 <syscall>:
[SYS_gettid]  sys_gettid,
};

void
syscall(void)
{
80106888:	55                   	push   %ebp
80106889:	89 e5                	mov    %esp,%ebp
8010688b:	53                   	push   %ebx
8010688c:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
8010688f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106895:	8b 40 18             	mov    0x18(%eax),%eax
80106898:	8b 40 1c             	mov    0x1c(%eax),%eax
8010689b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010689e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068a2:	7e 30                	jle    801068d4 <syscall+0x4c>
801068a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a7:	83 f8 1e             	cmp    $0x1e,%eax
801068aa:	77 28                	ja     801068d4 <syscall+0x4c>
801068ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068af:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801068b6:	85 c0                	test   %eax,%eax
801068b8:	74 1a                	je     801068d4 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801068ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068c0:	8b 58 18             	mov    0x18(%eax),%ebx
801068c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c6:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801068cd:	ff d0                	call   *%eax
801068cf:	89 43 1c             	mov    %eax,0x1c(%ebx)
801068d2:	eb 3d                	jmp    80106911 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801068d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068da:	8d 48 6c             	lea    0x6c(%eax),%ecx
801068dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801068e3:	8b 40 10             	mov    0x10(%eax),%eax
801068e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801068e9:	89 54 24 0c          	mov    %edx,0xc(%esp)
801068ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801068f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801068f5:	c7 04 24 b3 9e 10 80 	movl   $0x80109eb3,(%esp)
801068fc:	e8 c7 9a ff ff       	call   801003c8 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106901:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106907:	8b 40 18             	mov    0x18(%eax),%eax
8010690a:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106911:	83 c4 24             	add    $0x24,%esp
80106914:	5b                   	pop    %ebx
80106915:	5d                   	pop    %ebp
80106916:	c3                   	ret    

80106917 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106917:	55                   	push   %ebp
80106918:	89 e5                	mov    %esp,%ebp
8010691a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010691d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106920:	89 44 24 04          	mov    %eax,0x4(%esp)
80106924:	8b 45 08             	mov    0x8(%ebp),%eax
80106927:	89 04 24             	mov    %eax,(%esp)
8010692a:	e8 8c fe ff ff       	call   801067bb <argint>
8010692f:	85 c0                	test   %eax,%eax
80106931:	79 07                	jns    8010693a <argfd+0x23>
    return -1;
80106933:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106938:	eb 50                	jmp    8010698a <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010693a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010693d:	85 c0                	test   %eax,%eax
8010693f:	78 21                	js     80106962 <argfd+0x4b>
80106941:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106944:	83 f8 0f             	cmp    $0xf,%eax
80106947:	7f 19                	jg     80106962 <argfd+0x4b>
80106949:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010694f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106952:	83 c2 08             	add    $0x8,%edx
80106955:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106959:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010695c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106960:	75 07                	jne    80106969 <argfd+0x52>
    return -1;
80106962:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106967:	eb 21                	jmp    8010698a <argfd+0x73>
  if(pfd)
80106969:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010696d:	74 08                	je     80106977 <argfd+0x60>
    *pfd = fd;
8010696f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106972:	8b 45 0c             	mov    0xc(%ebp),%eax
80106975:	89 10                	mov    %edx,(%eax)
  if(pf)
80106977:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010697b:	74 08                	je     80106985 <argfd+0x6e>
    *pf = f;
8010697d:	8b 45 10             	mov    0x10(%ebp),%eax
80106980:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106983:	89 10                	mov    %edx,(%eax)
  return 0;
80106985:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010698a:	c9                   	leave  
8010698b:	c3                   	ret    

8010698c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010698c:	55                   	push   %ebp
8010698d:	89 e5                	mov    %esp,%ebp
8010698f:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106992:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106999:	eb 30                	jmp    801069cb <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
8010699b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069a4:	83 c2 08             	add    $0x8,%edx
801069a7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801069ab:	85 c0                	test   %eax,%eax
801069ad:	75 18                	jne    801069c7 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801069af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069b8:	8d 4a 08             	lea    0x8(%edx),%ecx
801069bb:	8b 55 08             	mov    0x8(%ebp),%edx
801069be:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801069c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069c5:	eb 0f                	jmp    801069d6 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801069c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801069cb:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801069cf:	7e ca                	jle    8010699b <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801069d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069d6:	c9                   	leave  
801069d7:	c3                   	ret    

801069d8 <sys_dup>:

int
sys_dup(void)
{
801069d8:	55                   	push   %ebp
801069d9:	89 e5                	mov    %esp,%ebp
801069db:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801069de:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069e1:	89 44 24 08          	mov    %eax,0x8(%esp)
801069e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069ec:	00 
801069ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069f4:	e8 1e ff ff ff       	call   80106917 <argfd>
801069f9:	85 c0                	test   %eax,%eax
801069fb:	79 07                	jns    80106a04 <sys_dup+0x2c>
    return -1;
801069fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a02:	eb 29                	jmp    80106a2d <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a07:	89 04 24             	mov    %eax,(%esp)
80106a0a:	e8 7d ff ff ff       	call   8010698c <fdalloc>
80106a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a16:	79 07                	jns    80106a1f <sys_dup+0x47>
    return -1;
80106a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a1d:	eb 0e                	jmp    80106a2d <sys_dup+0x55>
  filedup(f);
80106a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a22:	89 04 24             	mov    %eax,(%esp)
80106a25:	e8 3e a6 ff ff       	call   80101068 <filedup>
  return fd;
80106a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106a2d:	c9                   	leave  
80106a2e:	c3                   	ret    

80106a2f <sys_read>:

int
sys_read(void)
{
80106a2f:	55                   	push   %ebp
80106a30:	89 e5                	mov    %esp,%ebp
80106a32:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106a35:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a38:	89 44 24 08          	mov    %eax,0x8(%esp)
80106a3c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a43:	00 
80106a44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a4b:	e8 c7 fe ff ff       	call   80106917 <argfd>
80106a50:	85 c0                	test   %eax,%eax
80106a52:	78 35                	js     80106a89 <sys_read+0x5a>
80106a54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a57:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a5b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106a62:	e8 54 fd ff ff       	call   801067bb <argint>
80106a67:	85 c0                	test   %eax,%eax
80106a69:	78 1e                	js     80106a89 <sys_read+0x5a>
80106a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a6e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106a72:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a75:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a80:	e8 64 fd ff ff       	call   801067e9 <argptr>
80106a85:	85 c0                	test   %eax,%eax
80106a87:	79 07                	jns    80106a90 <sys_read+0x61>
    return -1;
80106a89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a8e:	eb 19                	jmp    80106aa9 <sys_read+0x7a>
  return fileread(f, p, n);
80106a90:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106a93:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a99:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106a9d:	89 54 24 04          	mov    %edx,0x4(%esp)
80106aa1:	89 04 24             	mov    %eax,(%esp)
80106aa4:	e8 2c a7 ff ff       	call   801011d5 <fileread>
}
80106aa9:	c9                   	leave  
80106aaa:	c3                   	ret    

80106aab <sys_write>:

int
sys_write(void)
{
80106aab:	55                   	push   %ebp
80106aac:	89 e5                	mov    %esp,%ebp
80106aae:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106ab1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ab4:	89 44 24 08          	mov    %eax,0x8(%esp)
80106ab8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106abf:	00 
80106ac0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ac7:	e8 4b fe ff ff       	call   80106917 <argfd>
80106acc:	85 c0                	test   %eax,%eax
80106ace:	78 35                	js     80106b05 <sys_write+0x5a>
80106ad0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ad7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106ade:	e8 d8 fc ff ff       	call   801067bb <argint>
80106ae3:	85 c0                	test   %eax,%eax
80106ae5:	78 1e                	js     80106b05 <sys_write+0x5a>
80106ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106aea:	89 44 24 08          	mov    %eax,0x8(%esp)
80106aee:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106af1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106af5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106afc:	e8 e8 fc ff ff       	call   801067e9 <argptr>
80106b01:	85 c0                	test   %eax,%eax
80106b03:	79 07                	jns    80106b0c <sys_write+0x61>
    return -1;
80106b05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b0a:	eb 19                	jmp    80106b25 <sys_write+0x7a>
  return filewrite(f, p, n);
80106b0c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106b0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b15:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106b19:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b1d:	89 04 24             	mov    %eax,(%esp)
80106b20:	e8 6c a7 ff ff       	call   80101291 <filewrite>
}
80106b25:	c9                   	leave  
80106b26:	c3                   	ret    

80106b27 <sys_close>:

int
sys_close(void)
{
80106b27:	55                   	push   %ebp
80106b28:	89 e5                	mov    %esp,%ebp
80106b2a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80106b2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b30:	89 44 24 08          	mov    %eax,0x8(%esp)
80106b34:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b37:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b42:	e8 d0 fd ff ff       	call   80106917 <argfd>
80106b47:	85 c0                	test   %eax,%eax
80106b49:	79 07                	jns    80106b52 <sys_close+0x2b>
    return -1;
80106b4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b50:	eb 24                	jmp    80106b76 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80106b52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b58:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b5b:	83 c2 08             	add    $0x8,%edx
80106b5e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106b65:	00 
  fileclose(f);
80106b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b69:	89 04 24             	mov    %eax,(%esp)
80106b6c:	e8 3f a5 ff ff       	call   801010b0 <fileclose>
  return 0;
80106b71:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b76:	c9                   	leave  
80106b77:	c3                   	ret    

80106b78 <sys_fstat>:

int
sys_fstat(void)
{
80106b78:	55                   	push   %ebp
80106b79:	89 e5                	mov    %esp,%ebp
80106b7b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106b7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b81:	89 44 24 08          	mov    %eax,0x8(%esp)
80106b85:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b8c:	00 
80106b8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b94:	e8 7e fd ff ff       	call   80106917 <argfd>
80106b99:	85 c0                	test   %eax,%eax
80106b9b:	78 1f                	js     80106bbc <sys_fstat+0x44>
80106b9d:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80106ba4:	00 
80106ba5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106bb3:	e8 31 fc ff ff       	call   801067e9 <argptr>
80106bb8:	85 c0                	test   %eax,%eax
80106bba:	79 07                	jns    80106bc3 <sys_fstat+0x4b>
    return -1;
80106bbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bc1:	eb 12                	jmp    80106bd5 <sys_fstat+0x5d>
  return filestat(f, st);
80106bc3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bc9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106bcd:	89 04 24             	mov    %eax,(%esp)
80106bd0:	e8 b1 a5 ff ff       	call   80101186 <filestat>
}
80106bd5:	c9                   	leave  
80106bd6:	c3                   	ret    

80106bd7 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106bd7:	55                   	push   %ebp
80106bd8:	89 e5                	mov    %esp,%ebp
80106bda:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106bdd:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106be0:	89 44 24 04          	mov    %eax,0x4(%esp)
80106be4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106beb:	e8 61 fc ff ff       	call   80106851 <argstr>
80106bf0:	85 c0                	test   %eax,%eax
80106bf2:	78 17                	js     80106c0b <sys_link+0x34>
80106bf4:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bfb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106c02:	e8 4a fc ff ff       	call   80106851 <argstr>
80106c07:	85 c0                	test   %eax,%eax
80106c09:	79 0a                	jns    80106c15 <sys_link+0x3e>
    return -1;
80106c0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c10:	e9 42 01 00 00       	jmp    80106d57 <sys_link+0x180>

  begin_op();
80106c15:	e8 8d c9 ff ff       	call   801035a7 <begin_op>
  if((ip = namei(old)) == 0){
80106c1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106c1d:	89 04 24             	mov    %eax,(%esp)
80106c20:	e8 e3 b8 ff ff       	call   80102508 <namei>
80106c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106c2c:	75 0f                	jne    80106c3d <sys_link+0x66>
    end_op();
80106c2e:	e8 f8 c9 ff ff       	call   8010362b <end_op>
    return -1;
80106c33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c38:	e9 1a 01 00 00       	jmp    80106d57 <sys_link+0x180>
  }

  ilock(ip);
80106c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c40:	89 04 24             	mov    %eax,(%esp)
80106c43:	e8 98 ad ff ff       	call   801019e0 <ilock>
  if(ip->type == T_DIR){
80106c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c4b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106c4f:	66 83 f8 01          	cmp    $0x1,%ax
80106c53:	75 1a                	jne    80106c6f <sys_link+0x98>
    iunlockput(ip);
80106c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c58:	89 04 24             	mov    %eax,(%esp)
80106c5b:	e8 6f af ff ff       	call   80101bcf <iunlockput>
    end_op();
80106c60:	e8 c6 c9 ff ff       	call   8010362b <end_op>
    return -1;
80106c65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c6a:	e9 e8 00 00 00       	jmp    80106d57 <sys_link+0x180>
  }

  ip->nlink++;
80106c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c72:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106c76:	8d 50 01             	lea    0x1(%eax),%edx
80106c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c7c:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c83:	89 04 24             	mov    %eax,(%esp)
80106c86:	e8 90 ab ff ff       	call   8010181b <iupdate>
  iunlock(ip);
80106c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c8e:	89 04 24             	mov    %eax,(%esp)
80106c91:	e8 61 ae ff ff       	call   80101af7 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80106c96:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106c99:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106c9c:	89 54 24 04          	mov    %edx,0x4(%esp)
80106ca0:	89 04 24             	mov    %eax,(%esp)
80106ca3:	e8 82 b8 ff ff       	call   8010252a <nameiparent>
80106ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106cab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106caf:	75 02                	jne    80106cb3 <sys_link+0xdc>
    goto bad;
80106cb1:	eb 68                	jmp    80106d1b <sys_link+0x144>
  ilock(dp);
80106cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cb6:	89 04 24             	mov    %eax,(%esp)
80106cb9:	e8 22 ad ff ff       	call   801019e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cc1:	8b 10                	mov    (%eax),%edx
80106cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cc6:	8b 00                	mov    (%eax),%eax
80106cc8:	39 c2                	cmp    %eax,%edx
80106cca:	75 20                	jne    80106cec <sys_link+0x115>
80106ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ccf:	8b 40 04             	mov    0x4(%eax),%eax
80106cd2:	89 44 24 08          	mov    %eax,0x8(%esp)
80106cd6:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ce0:	89 04 24             	mov    %eax,(%esp)
80106ce3:	e8 60 b5 ff ff       	call   80102248 <dirlink>
80106ce8:	85 c0                	test   %eax,%eax
80106cea:	79 0d                	jns    80106cf9 <sys_link+0x122>
    iunlockput(dp);
80106cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cef:	89 04 24             	mov    %eax,(%esp)
80106cf2:	e8 d8 ae ff ff       	call   80101bcf <iunlockput>
    goto bad;
80106cf7:	eb 22                	jmp    80106d1b <sys_link+0x144>
  }
  iunlockput(dp);
80106cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106cfc:	89 04 24             	mov    %eax,(%esp)
80106cff:	e8 cb ae ff ff       	call   80101bcf <iunlockput>
  iput(ip);
80106d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d07:	89 04 24             	mov    %eax,(%esp)
80106d0a:	e8 2c ae ff ff       	call   80101b3b <iput>

  end_op();
80106d0f:	e8 17 c9 ff ff       	call   8010362b <end_op>

  return 0;
80106d14:	b8 00 00 00 00       	mov    $0x0,%eax
80106d19:	eb 3c                	jmp    80106d57 <sys_link+0x180>

bad:
  ilock(ip);
80106d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d1e:	89 04 24             	mov    %eax,(%esp)
80106d21:	e8 ba ac ff ff       	call   801019e0 <ilock>
  ip->nlink--;
80106d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d29:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106d2d:	8d 50 ff             	lea    -0x1(%eax),%edx
80106d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d33:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d3a:	89 04 24             	mov    %eax,(%esp)
80106d3d:	e8 d9 aa ff ff       	call   8010181b <iupdate>
  iunlockput(ip);
80106d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d45:	89 04 24             	mov    %eax,(%esp)
80106d48:	e8 82 ae ff ff       	call   80101bcf <iunlockput>
  end_op();
80106d4d:	e8 d9 c8 ff ff       	call   8010362b <end_op>
  return -1;
80106d52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d57:	c9                   	leave  
80106d58:	c3                   	ret    

80106d59 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106d59:	55                   	push   %ebp
80106d5a:	89 e5                	mov    %esp,%ebp
80106d5c:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106d5f:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106d66:	eb 4b                	jmp    80106db3 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d6b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106d72:	00 
80106d73:	89 44 24 08          	mov    %eax,0x8(%esp)
80106d77:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106d7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80106d81:	89 04 24             	mov    %eax,(%esp)
80106d84:	e8 e1 b0 ff ff       	call   80101e6a <readi>
80106d89:	83 f8 10             	cmp    $0x10,%eax
80106d8c:	74 0c                	je     80106d9a <isdirempty+0x41>
      panic("isdirempty: readi");
80106d8e:	c7 04 24 cf 9e 10 80 	movl   $0x80109ecf,(%esp)
80106d95:	e8 c8 97 ff ff       	call   80100562 <panic>
    if(de.inum != 0)
80106d9a:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106d9e:	66 85 c0             	test   %ax,%ax
80106da1:	74 07                	je     80106daa <isdirempty+0x51>
      return 0;
80106da3:	b8 00 00 00 00       	mov    $0x0,%eax
80106da8:	eb 1b                	jmp    80106dc5 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dad:	83 c0 10             	add    $0x10,%eax
80106db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106db3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106db6:	8b 45 08             	mov    0x8(%ebp),%eax
80106db9:	8b 40 58             	mov    0x58(%eax),%eax
80106dbc:	39 c2                	cmp    %eax,%edx
80106dbe:	72 a8                	jb     80106d68 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106dc0:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106dc5:	c9                   	leave  
80106dc6:	c3                   	ret    

80106dc7 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106dc7:	55                   	push   %ebp
80106dc8:	89 e5                	mov    %esp,%ebp
80106dca:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106dcd:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
80106dd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ddb:	e8 71 fa ff ff       	call   80106851 <argstr>
80106de0:	85 c0                	test   %eax,%eax
80106de2:	79 0a                	jns    80106dee <sys_unlink+0x27>
    return -1;
80106de4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106de9:	e9 af 01 00 00       	jmp    80106f9d <sys_unlink+0x1d6>

  begin_op();
80106dee:	e8 b4 c7 ff ff       	call   801035a7 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106df3:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106df6:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106df9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106dfd:	89 04 24             	mov    %eax,(%esp)
80106e00:	e8 25 b7 ff ff       	call   8010252a <nameiparent>
80106e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106e08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106e0c:	75 0f                	jne    80106e1d <sys_unlink+0x56>
    end_op();
80106e0e:	e8 18 c8 ff ff       	call   8010362b <end_op>
    return -1;
80106e13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e18:	e9 80 01 00 00       	jmp    80106f9d <sys_unlink+0x1d6>
  }

  ilock(dp);
80106e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e20:	89 04 24             	mov    %eax,(%esp)
80106e23:	e8 b8 ab ff ff       	call   801019e0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106e28:	c7 44 24 04 e1 9e 10 	movl   $0x80109ee1,0x4(%esp)
80106e2f:	80 
80106e30:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106e33:	89 04 24             	mov    %eax,(%esp)
80106e36:	e8 22 b3 ff ff       	call   8010215d <namecmp>
80106e3b:	85 c0                	test   %eax,%eax
80106e3d:	0f 84 45 01 00 00    	je     80106f88 <sys_unlink+0x1c1>
80106e43:	c7 44 24 04 e3 9e 10 	movl   $0x80109ee3,0x4(%esp)
80106e4a:	80 
80106e4b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106e4e:	89 04 24             	mov    %eax,(%esp)
80106e51:	e8 07 b3 ff ff       	call   8010215d <namecmp>
80106e56:	85 c0                	test   %eax,%eax
80106e58:	0f 84 2a 01 00 00    	je     80106f88 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106e5e:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106e61:	89 44 24 08          	mov    %eax,0x8(%esp)
80106e65:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106e68:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e6f:	89 04 24             	mov    %eax,(%esp)
80106e72:	e8 08 b3 ff ff       	call   8010217f <dirlookup>
80106e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106e7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106e7e:	75 05                	jne    80106e85 <sys_unlink+0xbe>
    goto bad;
80106e80:	e9 03 01 00 00       	jmp    80106f88 <sys_unlink+0x1c1>
  ilock(ip);
80106e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e88:	89 04 24             	mov    %eax,(%esp)
80106e8b:	e8 50 ab ff ff       	call   801019e0 <ilock>

  if(ip->nlink < 1)
80106e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e93:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106e97:	66 85 c0             	test   %ax,%ax
80106e9a:	7f 0c                	jg     80106ea8 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80106e9c:	c7 04 24 e6 9e 10 80 	movl   $0x80109ee6,(%esp)
80106ea3:	e8 ba 96 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106eab:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106eaf:	66 83 f8 01          	cmp    $0x1,%ax
80106eb3:	75 1f                	jne    80106ed4 <sys_unlink+0x10d>
80106eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106eb8:	89 04 24             	mov    %eax,(%esp)
80106ebb:	e8 99 fe ff ff       	call   80106d59 <isdirempty>
80106ec0:	85 c0                	test   %eax,%eax
80106ec2:	75 10                	jne    80106ed4 <sys_unlink+0x10d>
    iunlockput(ip);
80106ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ec7:	89 04 24             	mov    %eax,(%esp)
80106eca:	e8 00 ad ff ff       	call   80101bcf <iunlockput>
    goto bad;
80106ecf:	e9 b4 00 00 00       	jmp    80106f88 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80106ed4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80106edb:	00 
80106edc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ee3:	00 
80106ee4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106ee7:	89 04 24             	mov    %eax,(%esp)
80106eea:	e8 8a f5 ff ff       	call   80106479 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106eef:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106ef2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106ef9:	00 
80106efa:	89 44 24 08          	mov    %eax,0x8(%esp)
80106efe:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106f01:	89 44 24 04          	mov    %eax,0x4(%esp)
80106f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f08:	89 04 24             	mov    %eax,(%esp)
80106f0b:	e8 be b0 ff ff       	call   80101fce <writei>
80106f10:	83 f8 10             	cmp    $0x10,%eax
80106f13:	74 0c                	je     80106f21 <sys_unlink+0x15a>
    panic("unlink: writei");
80106f15:	c7 04 24 f8 9e 10 80 	movl   $0x80109ef8,(%esp)
80106f1c:	e8 41 96 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR){
80106f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f24:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106f28:	66 83 f8 01          	cmp    $0x1,%ax
80106f2c:	75 1c                	jne    80106f4a <sys_unlink+0x183>
    dp->nlink--;
80106f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f31:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106f35:	8d 50 ff             	lea    -0x1(%eax),%edx
80106f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f3b:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80106f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f42:	89 04 24             	mov    %eax,(%esp)
80106f45:	e8 d1 a8 ff ff       	call   8010181b <iupdate>
  }
  iunlockput(dp);
80106f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f4d:	89 04 24             	mov    %eax,(%esp)
80106f50:	e8 7a ac ff ff       	call   80101bcf <iunlockput>

  ip->nlink--;
80106f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f58:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80106f5c:	8d 50 ff             	lea    -0x1(%eax),%edx
80106f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f62:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80106f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f69:	89 04 24             	mov    %eax,(%esp)
80106f6c:	e8 aa a8 ff ff       	call   8010181b <iupdate>
  iunlockput(ip);
80106f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f74:	89 04 24             	mov    %eax,(%esp)
80106f77:	e8 53 ac ff ff       	call   80101bcf <iunlockput>

  end_op();
80106f7c:	e8 aa c6 ff ff       	call   8010362b <end_op>

  return 0;
80106f81:	b8 00 00 00 00       	mov    $0x0,%eax
80106f86:	eb 15                	jmp    80106f9d <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80106f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f8b:	89 04 24             	mov    %eax,(%esp)
80106f8e:	e8 3c ac ff ff       	call   80101bcf <iunlockput>
  end_op();
80106f93:	e8 93 c6 ff ff       	call   8010362b <end_op>
  return -1;
80106f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f9d:	c9                   	leave  
80106f9e:	c3                   	ret    

80106f9f <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106f9f:	55                   	push   %ebp
80106fa0:	89 e5                	mov    %esp,%ebp
80106fa2:	83 ec 48             	sub    $0x48,%esp
80106fa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fa8:	8b 55 10             	mov    0x10(%ebp),%edx
80106fab:	8b 45 14             	mov    0x14(%ebp),%eax
80106fae:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106fb2:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106fb6:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106fba:	8d 45 de             	lea    -0x22(%ebp),%eax
80106fbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80106fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc4:	89 04 24             	mov    %eax,(%esp)
80106fc7:	e8 5e b5 ff ff       	call   8010252a <nameiparent>
80106fcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106fd3:	75 0a                	jne    80106fdf <create+0x40>
    return 0;
80106fd5:	b8 00 00 00 00       	mov    $0x0,%eax
80106fda:	e9 7e 01 00 00       	jmp    8010715d <create+0x1be>
  ilock(dp);
80106fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fe2:	89 04 24             	mov    %eax,(%esp)
80106fe5:	e8 f6 a9 ff ff       	call   801019e0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80106fea:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106fed:	89 44 24 08          	mov    %eax,0x8(%esp)
80106ff1:	8d 45 de             	lea    -0x22(%ebp),%eax
80106ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ffb:	89 04 24             	mov    %eax,(%esp)
80106ffe:	e8 7c b1 ff ff       	call   8010217f <dirlookup>
80107003:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107006:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010700a:	74 47                	je     80107053 <create+0xb4>
    iunlockput(dp);
8010700c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010700f:	89 04 24             	mov    %eax,(%esp)
80107012:	e8 b8 ab ff ff       	call   80101bcf <iunlockput>
    ilock(ip);
80107017:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010701a:	89 04 24             	mov    %eax,(%esp)
8010701d:	e8 be a9 ff ff       	call   801019e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80107022:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80107027:	75 15                	jne    8010703e <create+0x9f>
80107029:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010702c:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80107030:	66 83 f8 02          	cmp    $0x2,%ax
80107034:	75 08                	jne    8010703e <create+0x9f>
      return ip;
80107036:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107039:	e9 1f 01 00 00       	jmp    8010715d <create+0x1be>
    iunlockput(ip);
8010703e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107041:	89 04 24             	mov    %eax,(%esp)
80107044:	e8 86 ab ff ff       	call   80101bcf <iunlockput>
    return 0;
80107049:	b8 00 00 00 00       	mov    $0x0,%eax
8010704e:	e9 0a 01 00 00       	jmp    8010715d <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80107053:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80107057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010705a:	8b 00                	mov    (%eax),%eax
8010705c:	89 54 24 04          	mov    %edx,0x4(%esp)
80107060:	89 04 24             	mov    %eax,(%esp)
80107063:	e8 de a6 ff ff       	call   80101746 <ialloc>
80107068:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010706b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010706f:	75 0c                	jne    8010707d <create+0xde>
    panic("create: ialloc");
80107071:	c7 04 24 07 9f 10 80 	movl   $0x80109f07,(%esp)
80107078:	e8 e5 94 ff ff       	call   80100562 <panic>

  ilock(ip);
8010707d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107080:	89 04 24             	mov    %eax,(%esp)
80107083:	e8 58 a9 ff ff       	call   801019e0 <ilock>
  ip->major = major;
80107088:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010708b:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010708f:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80107093:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107096:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
8010709a:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
8010709e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070a1:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
801070a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070aa:	89 04 24             	mov    %eax,(%esp)
801070ad:	e8 69 a7 ff ff       	call   8010181b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801070b2:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801070b7:	75 6a                	jne    80107123 <create+0x184>
    dp->nlink++;  // for ".."
801070b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070bc:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801070c0:	8d 50 01             	lea    0x1(%eax),%edx
801070c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070c6:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801070ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070cd:	89 04 24             	mov    %eax,(%esp)
801070d0:	e8 46 a7 ff ff       	call   8010181b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801070d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070d8:	8b 40 04             	mov    0x4(%eax),%eax
801070db:	89 44 24 08          	mov    %eax,0x8(%esp)
801070df:	c7 44 24 04 e1 9e 10 	movl   $0x80109ee1,0x4(%esp)
801070e6:	80 
801070e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070ea:	89 04 24             	mov    %eax,(%esp)
801070ed:	e8 56 b1 ff ff       	call   80102248 <dirlink>
801070f2:	85 c0                	test   %eax,%eax
801070f4:	78 21                	js     80107117 <create+0x178>
801070f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070f9:	8b 40 04             	mov    0x4(%eax),%eax
801070fc:	89 44 24 08          	mov    %eax,0x8(%esp)
80107100:	c7 44 24 04 e3 9e 10 	movl   $0x80109ee3,0x4(%esp)
80107107:	80 
80107108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010710b:	89 04 24             	mov    %eax,(%esp)
8010710e:	e8 35 b1 ff ff       	call   80102248 <dirlink>
80107113:	85 c0                	test   %eax,%eax
80107115:	79 0c                	jns    80107123 <create+0x184>
      panic("create dots");
80107117:	c7 04 24 16 9f 10 80 	movl   $0x80109f16,(%esp)
8010711e:	e8 3f 94 ff ff       	call   80100562 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80107123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107126:	8b 40 04             	mov    0x4(%eax),%eax
80107129:	89 44 24 08          	mov    %eax,0x8(%esp)
8010712d:	8d 45 de             	lea    -0x22(%ebp),%eax
80107130:	89 44 24 04          	mov    %eax,0x4(%esp)
80107134:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107137:	89 04 24             	mov    %eax,(%esp)
8010713a:	e8 09 b1 ff ff       	call   80102248 <dirlink>
8010713f:	85 c0                	test   %eax,%eax
80107141:	79 0c                	jns    8010714f <create+0x1b0>
    panic("create: dirlink");
80107143:	c7 04 24 22 9f 10 80 	movl   $0x80109f22,(%esp)
8010714a:	e8 13 94 ff ff       	call   80100562 <panic>

  iunlockput(dp);
8010714f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107152:	89 04 24             	mov    %eax,(%esp)
80107155:	e8 75 aa ff ff       	call   80101bcf <iunlockput>

  return ip;
8010715a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010715d:	c9                   	leave  
8010715e:	c3                   	ret    

8010715f <sys_open>:

int
sys_open(void)
{
8010715f:	55                   	push   %ebp
80107160:	89 e5                	mov    %esp,%ebp
80107162:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107165:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107168:	89 44 24 04          	mov    %eax,0x4(%esp)
8010716c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107173:	e8 d9 f6 ff ff       	call   80106851 <argstr>
80107178:	85 c0                	test   %eax,%eax
8010717a:	78 17                	js     80107193 <sys_open+0x34>
8010717c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010717f:	89 44 24 04          	mov    %eax,0x4(%esp)
80107183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010718a:	e8 2c f6 ff ff       	call   801067bb <argint>
8010718f:	85 c0                	test   %eax,%eax
80107191:	79 0a                	jns    8010719d <sys_open+0x3e>
    return -1;
80107193:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107198:	e9 5c 01 00 00       	jmp    801072f9 <sys_open+0x19a>

  begin_op();
8010719d:	e8 05 c4 ff ff       	call   801035a7 <begin_op>

  if(omode & O_CREATE){
801071a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071a5:	25 00 02 00 00       	and    $0x200,%eax
801071aa:	85 c0                	test   %eax,%eax
801071ac:	74 3b                	je     801071e9 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
801071ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
801071b1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801071b8:	00 
801071b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801071c0:	00 
801071c1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
801071c8:	00 
801071c9:	89 04 24             	mov    %eax,(%esp)
801071cc:	e8 ce fd ff ff       	call   80106f9f <create>
801071d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801071d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801071d8:	75 6b                	jne    80107245 <sys_open+0xe6>
      end_op();
801071da:	e8 4c c4 ff ff       	call   8010362b <end_op>
      return -1;
801071df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071e4:	e9 10 01 00 00       	jmp    801072f9 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
801071e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801071ec:	89 04 24             	mov    %eax,(%esp)
801071ef:	e8 14 b3 ff ff       	call   80102508 <namei>
801071f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801071f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801071fb:	75 0f                	jne    8010720c <sys_open+0xad>
      end_op();
801071fd:	e8 29 c4 ff ff       	call   8010362b <end_op>
      return -1;
80107202:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107207:	e9 ed 00 00 00       	jmp    801072f9 <sys_open+0x19a>
    }
    ilock(ip);
8010720c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010720f:	89 04 24             	mov    %eax,(%esp)
80107212:	e8 c9 a7 ff ff       	call   801019e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80107217:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010721a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010721e:	66 83 f8 01          	cmp    $0x1,%ax
80107222:	75 21                	jne    80107245 <sys_open+0xe6>
80107224:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107227:	85 c0                	test   %eax,%eax
80107229:	74 1a                	je     80107245 <sys_open+0xe6>
      iunlockput(ip);
8010722b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010722e:	89 04 24             	mov    %eax,(%esp)
80107231:	e8 99 a9 ff ff       	call   80101bcf <iunlockput>
      end_op();
80107236:	e8 f0 c3 ff ff       	call   8010362b <end_op>
      return -1;
8010723b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107240:	e9 b4 00 00 00       	jmp    801072f9 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80107245:	e8 be 9d ff ff       	call   80101008 <filealloc>
8010724a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010724d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107251:	74 14                	je     80107267 <sys_open+0x108>
80107253:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107256:	89 04 24             	mov    %eax,(%esp)
80107259:	e8 2e f7 ff ff       	call   8010698c <fdalloc>
8010725e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107261:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107265:	79 28                	jns    8010728f <sys_open+0x130>
    if(f)
80107267:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010726b:	74 0b                	je     80107278 <sys_open+0x119>
      fileclose(f);
8010726d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107270:	89 04 24             	mov    %eax,(%esp)
80107273:	e8 38 9e ff ff       	call   801010b0 <fileclose>
    iunlockput(ip);
80107278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010727b:	89 04 24             	mov    %eax,(%esp)
8010727e:	e8 4c a9 ff ff       	call   80101bcf <iunlockput>
    end_op();
80107283:	e8 a3 c3 ff ff       	call   8010362b <end_op>
    return -1;
80107288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010728d:	eb 6a                	jmp    801072f9 <sys_open+0x19a>
  }
  iunlock(ip);
8010728f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107292:	89 04 24             	mov    %eax,(%esp)
80107295:	e8 5d a8 ff ff       	call   80101af7 <iunlock>
  end_op();
8010729a:	e8 8c c3 ff ff       	call   8010362b <end_op>

  f->type = FD_INODE;
8010729f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072a2:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801072a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801072ae:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801072b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072b4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801072bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072be:	83 e0 01             	and    $0x1,%eax
801072c1:	85 c0                	test   %eax,%eax
801072c3:	0f 94 c0             	sete   %al
801072c6:	89 c2                	mov    %eax,%edx
801072c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072cb:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801072ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072d1:	83 e0 01             	and    $0x1,%eax
801072d4:	85 c0                	test   %eax,%eax
801072d6:	75 0a                	jne    801072e2 <sys_open+0x183>
801072d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072db:	83 e0 02             	and    $0x2,%eax
801072de:	85 c0                	test   %eax,%eax
801072e0:	74 07                	je     801072e9 <sys_open+0x18a>
801072e2:	b8 01 00 00 00       	mov    $0x1,%eax
801072e7:	eb 05                	jmp    801072ee <sys_open+0x18f>
801072e9:	b8 00 00 00 00       	mov    $0x0,%eax
801072ee:	89 c2                	mov    %eax,%edx
801072f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072f3:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801072f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801072f9:	c9                   	leave  
801072fa:	c3                   	ret    

801072fb <sys_mkdir>:

int
sys_mkdir(void)
{
801072fb:	55                   	push   %ebp
801072fc:	89 e5                	mov    %esp,%ebp
801072fe:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107301:	e8 a1 c2 ff ff       	call   801035a7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80107306:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107309:	89 44 24 04          	mov    %eax,0x4(%esp)
8010730d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107314:	e8 38 f5 ff ff       	call   80106851 <argstr>
80107319:	85 c0                	test   %eax,%eax
8010731b:	78 2c                	js     80107349 <sys_mkdir+0x4e>
8010731d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107320:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80107327:	00 
80107328:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010732f:	00 
80107330:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80107337:	00 
80107338:	89 04 24             	mov    %eax,(%esp)
8010733b:	e8 5f fc ff ff       	call   80106f9f <create>
80107340:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107343:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107347:	75 0c                	jne    80107355 <sys_mkdir+0x5a>
    end_op();
80107349:	e8 dd c2 ff ff       	call   8010362b <end_op>
    return -1;
8010734e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107353:	eb 15                	jmp    8010736a <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80107355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107358:	89 04 24             	mov    %eax,(%esp)
8010735b:	e8 6f a8 ff ff       	call   80101bcf <iunlockput>
  end_op();
80107360:	e8 c6 c2 ff ff       	call   8010362b <end_op>
  return 0;
80107365:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010736a:	c9                   	leave  
8010736b:	c3                   	ret    

8010736c <sys_mknod>:

int
sys_mknod(void)
{
8010736c:	55                   	push   %ebp
8010736d:	89 e5                	mov    %esp,%ebp
8010736f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80107372:	e8 30 c2 ff ff       	call   801035a7 <begin_op>
  if((argstr(0, &path)) < 0 ||
80107377:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010737a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010737e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107385:	e8 c7 f4 ff ff       	call   80106851 <argstr>
8010738a:	85 c0                	test   %eax,%eax
8010738c:	78 5e                	js     801073ec <sys_mknod+0x80>
     argint(1, &major) < 0 ||
8010738e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107391:	89 44 24 04          	mov    %eax,0x4(%esp)
80107395:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010739c:	e8 1a f4 ff ff       	call   801067bb <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801073a1:	85 c0                	test   %eax,%eax
801073a3:	78 47                	js     801073ec <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801073a5:	8d 45 e8             	lea    -0x18(%ebp),%eax
801073a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801073ac:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801073b3:	e8 03 f4 ff ff       	call   801067bb <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801073b8:	85 c0                	test   %eax,%eax
801073ba:	78 30                	js     801073ec <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801073bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801073bf:	0f bf c8             	movswl %ax,%ecx
801073c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801073c5:	0f bf d0             	movswl %ax,%edx
801073c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801073cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801073cf:	89 54 24 08          	mov    %edx,0x8(%esp)
801073d3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801073da:	00 
801073db:	89 04 24             	mov    %eax,(%esp)
801073de:	e8 bc fb ff ff       	call   80106f9f <create>
801073e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073ea:	75 0c                	jne    801073f8 <sys_mknod+0x8c>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801073ec:	e8 3a c2 ff ff       	call   8010362b <end_op>
    return -1;
801073f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073f6:	eb 15                	jmp    8010740d <sys_mknod+0xa1>
  }
  iunlockput(ip);
801073f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073fb:	89 04 24             	mov    %eax,(%esp)
801073fe:	e8 cc a7 ff ff       	call   80101bcf <iunlockput>
  end_op();
80107403:	e8 23 c2 ff ff       	call   8010362b <end_op>
  return 0;
80107408:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010740d:	c9                   	leave  
8010740e:	c3                   	ret    

8010740f <sys_chdir>:

int
sys_chdir(void)
{
8010740f:	55                   	push   %ebp
80107410:	89 e5                	mov    %esp,%ebp
80107412:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107415:	e8 8d c1 ff ff       	call   801035a7 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010741a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010741d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107421:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107428:	e8 24 f4 ff ff       	call   80106851 <argstr>
8010742d:	85 c0                	test   %eax,%eax
8010742f:	78 14                	js     80107445 <sys_chdir+0x36>
80107431:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107434:	89 04 24             	mov    %eax,(%esp)
80107437:	e8 cc b0 ff ff       	call   80102508 <namei>
8010743c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010743f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107443:	75 0c                	jne    80107451 <sys_chdir+0x42>
    end_op();
80107445:	e8 e1 c1 ff ff       	call   8010362b <end_op>
    return -1;
8010744a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010744f:	eb 61                	jmp    801074b2 <sys_chdir+0xa3>
  }
  ilock(ip);
80107451:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107454:	89 04 24             	mov    %eax,(%esp)
80107457:	e8 84 a5 ff ff       	call   801019e0 <ilock>
  if(ip->type != T_DIR){
8010745c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010745f:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80107463:	66 83 f8 01          	cmp    $0x1,%ax
80107467:	74 17                	je     80107480 <sys_chdir+0x71>
    iunlockput(ip);
80107469:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010746c:	89 04 24             	mov    %eax,(%esp)
8010746f:	e8 5b a7 ff ff       	call   80101bcf <iunlockput>
    end_op();
80107474:	e8 b2 c1 ff ff       	call   8010362b <end_op>
    return -1;
80107479:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010747e:	eb 32                	jmp    801074b2 <sys_chdir+0xa3>
  }
  iunlock(ip);
80107480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107483:	89 04 24             	mov    %eax,(%esp)
80107486:	e8 6c a6 ff ff       	call   80101af7 <iunlock>
  iput(proc->cwd);
8010748b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107491:	8b 40 68             	mov    0x68(%eax),%eax
80107494:	89 04 24             	mov    %eax,(%esp)
80107497:	e8 9f a6 ff ff       	call   80101b3b <iput>
  end_op();
8010749c:	e8 8a c1 ff ff       	call   8010362b <end_op>
  proc->cwd = ip;
801074a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801074a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801074aa:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801074ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
801074b2:	c9                   	leave  
801074b3:	c3                   	ret    

801074b4 <sys_exec>:

int
sys_exec(void)
{
801074b4:	55                   	push   %ebp
801074b5:	89 e5                	mov    %esp,%ebp
801074b7:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801074bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801074c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801074c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801074cb:	e8 81 f3 ff ff       	call   80106851 <argstr>
801074d0:	85 c0                	test   %eax,%eax
801074d2:	78 1a                	js     801074ee <sys_exec+0x3a>
801074d4:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801074da:	89 44 24 04          	mov    %eax,0x4(%esp)
801074de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801074e5:	e8 d1 f2 ff ff       	call   801067bb <argint>
801074ea:	85 c0                	test   %eax,%eax
801074ec:	79 0a                	jns    801074f8 <sys_exec+0x44>
    return -1;
801074ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074f3:	e9 c8 00 00 00       	jmp    801075c0 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
801074f8:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801074ff:	00 
80107500:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107507:	00 
80107508:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010750e:	89 04 24             	mov    %eax,(%esp)
80107511:	e8 63 ef ff ff       	call   80106479 <memset>
  for(i=0;; i++){
80107516:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010751d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107520:	83 f8 1f             	cmp    $0x1f,%eax
80107523:	76 0a                	jbe    8010752f <sys_exec+0x7b>
      return -1;
80107525:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010752a:	e9 91 00 00 00       	jmp    801075c0 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010752f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107532:	c1 e0 02             	shl    $0x2,%eax
80107535:	89 c2                	mov    %eax,%edx
80107537:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010753d:	01 c2                	add    %eax,%edx
8010753f:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107545:	89 44 24 04          	mov    %eax,0x4(%esp)
80107549:	89 14 24             	mov    %edx,(%esp)
8010754c:	e8 ce f1 ff ff       	call   8010671f <fetchint>
80107551:	85 c0                	test   %eax,%eax
80107553:	79 07                	jns    8010755c <sys_exec+0xa8>
      return -1;
80107555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010755a:	eb 64                	jmp    801075c0 <sys_exec+0x10c>
    if(uarg == 0){
8010755c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107562:	85 c0                	test   %eax,%eax
80107564:	75 26                	jne    8010758c <sys_exec+0xd8>
      argv[i] = 0;
80107566:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107569:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107570:	00 00 00 00 
      break;
80107574:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107575:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107578:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010757e:	89 54 24 04          	mov    %edx,0x4(%esp)
80107582:	89 04 24             	mov    %eax,(%esp)
80107585:	e8 a8 95 ff ff       	call   80100b32 <exec>
8010758a:	eb 34                	jmp    801075c0 <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010758c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107592:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107595:	c1 e2 02             	shl    $0x2,%edx
80107598:	01 c2                	add    %eax,%edx
8010759a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801075a0:	89 54 24 04          	mov    %edx,0x4(%esp)
801075a4:	89 04 24             	mov    %eax,(%esp)
801075a7:	e8 ad f1 ff ff       	call   80106759 <fetchstr>
801075ac:	85 c0                	test   %eax,%eax
801075ae:	79 07                	jns    801075b7 <sys_exec+0x103>
      return -1;
801075b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075b5:	eb 09                	jmp    801075c0 <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801075b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801075bb:	e9 5d ff ff ff       	jmp    8010751d <sys_exec+0x69>
  return exec(path, argv);
}
801075c0:	c9                   	leave  
801075c1:	c3                   	ret    

801075c2 <sys_pipe>:

int
sys_pipe(void)
{
801075c2:	55                   	push   %ebp
801075c3:	89 e5                	mov    %esp,%ebp
801075c5:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801075c8:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801075cf:	00 
801075d0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801075d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801075d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801075de:	e8 06 f2 ff ff       	call   801067e9 <argptr>
801075e3:	85 c0                	test   %eax,%eax
801075e5:	79 0a                	jns    801075f1 <sys_pipe+0x2f>
    return -1;
801075e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075ec:	e9 9b 00 00 00       	jmp    8010768c <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
801075f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801075f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801075f8:	8d 45 e8             	lea    -0x18(%ebp),%eax
801075fb:	89 04 24             	mov    %eax,(%esp)
801075fe:	e8 c3 c9 ff ff       	call   80103fc6 <pipealloc>
80107603:	85 c0                	test   %eax,%eax
80107605:	79 07                	jns    8010760e <sys_pipe+0x4c>
    return -1;
80107607:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010760c:	eb 7e                	jmp    8010768c <sys_pipe+0xca>
  fd0 = -1;
8010760e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107615:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107618:	89 04 24             	mov    %eax,(%esp)
8010761b:	e8 6c f3 ff ff       	call   8010698c <fdalloc>
80107620:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107623:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107627:	78 14                	js     8010763d <sys_pipe+0x7b>
80107629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010762c:	89 04 24             	mov    %eax,(%esp)
8010762f:	e8 58 f3 ff ff       	call   8010698c <fdalloc>
80107634:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107637:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010763b:	79 37                	jns    80107674 <sys_pipe+0xb2>
    if(fd0 >= 0)
8010763d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107641:	78 14                	js     80107657 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80107643:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107649:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010764c:	83 c2 08             	add    $0x8,%edx
8010764f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107656:	00 
    fileclose(rf);
80107657:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010765a:	89 04 24             	mov    %eax,(%esp)
8010765d:	e8 4e 9a ff ff       	call   801010b0 <fileclose>
    fileclose(wf);
80107662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107665:	89 04 24             	mov    %eax,(%esp)
80107668:	e8 43 9a ff ff       	call   801010b0 <fileclose>
    return -1;
8010766d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107672:	eb 18                	jmp    8010768c <sys_pipe+0xca>
  }
  fd[0] = fd0;
80107674:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107677:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010767a:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010767c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010767f:	8d 50 04             	lea    0x4(%eax),%edx
80107682:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107685:	89 02                	mov    %eax,(%edx)
  return 0;
80107687:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010768c:	c9                   	leave  
8010768d:	c3                   	ret    

8010768e <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010768e:	55                   	push   %ebp
8010768f:	89 e5                	mov    %esp,%ebp
80107691:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107694:	e8 c6 d2 ff ff       	call   8010495f <fork>
}
80107699:	c9                   	leave  
8010769a:	c3                   	ret    

8010769b <sys_exit>:

int
sys_exit(void)
{
8010769b:	55                   	push   %ebp
8010769c:	89 e5                	mov    %esp,%ebp
8010769e:	83 ec 08             	sub    $0x8,%esp
  exit();
801076a1:	e8 5f d5 ff ff       	call   80104c05 <exit>
  return 0;  // not reached
801076a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076ab:	c9                   	leave  
801076ac:	c3                   	ret    

801076ad <sys_wait>:

int
sys_wait(void)
{
801076ad:	55                   	push   %ebp
801076ae:	89 e5                	mov    %esp,%ebp
801076b0:	83 ec 08             	sub    $0x8,%esp
  return wait();
801076b3:	e8 5f d7 ff ff       	call   80104e17 <wait>
}
801076b8:	c9                   	leave  
801076b9:	c3                   	ret    

801076ba <sys_kill>:

int
sys_kill(void)
{
801076ba:	55                   	push   %ebp
801076bb:	89 e5                	mov    %esp,%ebp
801076bd:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801076c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801076c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801076c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801076ce:	e8 e8 f0 ff ff       	call   801067bb <argint>
801076d3:	85 c0                	test   %eax,%eax
801076d5:	79 07                	jns    801076de <sys_kill+0x24>
    return -1;
801076d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076dc:	eb 0b                	jmp    801076e9 <sys_kill+0x2f>
  return kill(pid);
801076de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e1:	89 04 24             	mov    %eax,(%esp)
801076e4:	e8 5e e0 ff ff       	call   80105747 <kill>
}
801076e9:	c9                   	leave  
801076ea:	c3                   	ret    

801076eb <sys_getpid>:

int
sys_getpid(void)
{
801076eb:	55                   	push   %ebp
801076ec:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801076ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076f4:	8b 40 10             	mov    0x10(%eax),%eax
}
801076f7:	5d                   	pop    %ebp
801076f8:	c3                   	ret    

801076f9 <sys_gettid>:

// Design Document 2-1-2-2
int
sys_gettid(void)
{
801076f9:	55                   	push   %ebp
801076fa:	89 e5                	mov    %esp,%ebp
  return proc->tid;
801076fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107702:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
}
80107708:	5d                   	pop    %ebp
80107709:	c3                   	ret    

8010770a <sys_sbrk>:

int
sys_sbrk(void)
{
8010770a:	55                   	push   %ebp
8010770b:	89 e5                	mov    %esp,%ebp
8010770d:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107710:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107713:	89 44 24 04          	mov    %eax,0x4(%esp)
80107717:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010771e:	e8 98 f0 ff ff       	call   801067bb <argint>
80107723:	85 c0                	test   %eax,%eax
80107725:	79 07                	jns    8010772e <sys_sbrk+0x24>
    return -1;
80107727:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010772c:	eb 24                	jmp    80107752 <sys_sbrk+0x48>
  addr = proc->sz;
8010772e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107734:	8b 00                	mov    (%eax),%eax
80107736:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107739:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010773c:	89 04 24             	mov    %eax,(%esp)
8010773f:	e8 76 d1 ff ff       	call   801048ba <growproc>
80107744:	85 c0                	test   %eax,%eax
80107746:	79 07                	jns    8010774f <sys_sbrk+0x45>
    return -1;
80107748:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010774d:	eb 03                	jmp    80107752 <sys_sbrk+0x48>
  return addr;
8010774f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107752:	c9                   	leave  
80107753:	c3                   	ret    

80107754 <sys_sleep>:

int
sys_sleep(void)
{
80107754:	55                   	push   %ebp
80107755:	89 e5                	mov    %esp,%ebp
80107757:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010775a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010775d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107761:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107768:	e8 4e f0 ff ff       	call   801067bb <argint>
8010776d:	85 c0                	test   %eax,%eax
8010776f:	79 07                	jns    80107778 <sys_sleep+0x24>
    return -1;
80107771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107776:	eb 6c                	jmp    801077e4 <sys_sleep+0x90>
  acquire(&tickslock);
80107778:	c7 04 24 20 88 11 80 	movl   $0x80118820,(%esp)
8010777f:	e8 8c ea ff ff       	call   80106210 <acquire>
  ticks0 = ticks;
80107784:	a1 60 90 11 80       	mov    0x80119060,%eax
80107789:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010778c:	eb 34                	jmp    801077c2 <sys_sleep+0x6e>
    if(proc->killed){
8010778e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107794:	8b 40 24             	mov    0x24(%eax),%eax
80107797:	85 c0                	test   %eax,%eax
80107799:	74 13                	je     801077ae <sys_sleep+0x5a>
      release(&tickslock);
8010779b:	c7 04 24 20 88 11 80 	movl   $0x80118820,(%esp)
801077a2:	e8 d0 ea ff ff       	call   80106277 <release>
      return -1;
801077a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077ac:	eb 36                	jmp    801077e4 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
801077ae:	c7 44 24 04 20 88 11 	movl   $0x80118820,0x4(%esp)
801077b5:	80 
801077b6:	c7 04 24 60 90 11 80 	movl   $0x80119060,(%esp)
801077bd:	e8 7e de ff ff       	call   80105640 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801077c2:	a1 60 90 11 80       	mov    0x80119060,%eax
801077c7:	2b 45 f4             	sub    -0xc(%ebp),%eax
801077ca:	89 c2                	mov    %eax,%edx
801077cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077cf:	39 c2                	cmp    %eax,%edx
801077d1:	72 bb                	jb     8010778e <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801077d3:	c7 04 24 20 88 11 80 	movl   $0x80118820,(%esp)
801077da:	e8 98 ea ff ff       	call   80106277 <release>
  return 0;
801077df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801077e4:	c9                   	leave  
801077e5:	c3                   	ret    

801077e6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801077e6:	55                   	push   %ebp
801077e7:	89 e5                	mov    %esp,%ebp
801077e9:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
801077ec:	c7 04 24 20 88 11 80 	movl   $0x80118820,(%esp)
801077f3:	e8 18 ea ff ff       	call   80106210 <acquire>
  xticks = ticks;
801077f8:	a1 60 90 11 80       	mov    0x80119060,%eax
801077fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80107800:	c7 04 24 20 88 11 80 	movl   $0x80118820,(%esp)
80107807:	e8 6b ea ff ff       	call   80106277 <release>
  return xticks;
8010780c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010780f:	c9                   	leave  
80107810:	c3                   	ret    

80107811 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107811:	55                   	push   %ebp
80107812:	89 e5                	mov    %esp,%ebp
80107814:	83 ec 08             	sub    $0x8,%esp
80107817:	8b 55 08             	mov    0x8(%ebp),%edx
8010781a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010781d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107821:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107824:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107828:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010782c:	ee                   	out    %al,(%dx)
}
8010782d:	c9                   	leave  
8010782e:	c3                   	ret    

8010782f <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010782f:	55                   	push   %ebp
80107830:	89 e5                	mov    %esp,%ebp
80107832:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107835:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
8010783c:	00 
8010783d:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80107844:	e8 c8 ff ff ff       	call   80107811 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80107849:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80107850:	00 
80107851:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80107858:	e8 b4 ff ff ff       	call   80107811 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
8010785d:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80107864:	00 
80107865:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
8010786c:	e8 a0 ff ff ff       	call   80107811 <outb>
  picenable(IRQ_TIMER);
80107871:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107878:	e8 dc c5 ff ff       	call   80103e59 <picenable>
}
8010787d:	c9                   	leave  
8010787e:	c3                   	ret    

8010787f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010787f:	1e                   	push   %ds
  pushl %es
80107880:	06                   	push   %es
  pushl %fs
80107881:	0f a0                	push   %fs
  pushl %gs
80107883:	0f a8                	push   %gs
  pushal
80107885:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107886:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010788a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010788c:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010788e:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107892:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107894:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107896:	54                   	push   %esp
  call trap
80107897:	e8 54 02 00 00       	call   80107af0 <trap>
  addl $4, %esp
8010789c:	83 c4 04             	add    $0x4,%esp

8010789f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010789f:	61                   	popa   
  popl %gs
801078a0:	0f a9                	pop    %gs
  popl %fs
801078a2:	0f a1                	pop    %fs
  popl %es
801078a4:	07                   	pop    %es
  popl %ds
801078a5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801078a6:	83 c4 08             	add    $0x8,%esp
  iret
801078a9:	cf                   	iret   

801078aa <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801078aa:	55                   	push   %ebp
801078ab:	89 e5                	mov    %esp,%ebp
801078ad:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801078b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801078b3:	83 e8 01             	sub    $0x1,%eax
801078b6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801078ba:	8b 45 08             	mov    0x8(%ebp),%eax
801078bd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801078c1:	8b 45 08             	mov    0x8(%ebp),%eax
801078c4:	c1 e8 10             	shr    $0x10,%eax
801078c7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801078cb:	8d 45 fa             	lea    -0x6(%ebp),%eax
801078ce:	0f 01 18             	lidtl  (%eax)
}
801078d1:	c9                   	leave  
801078d2:	c3                   	ret    

801078d3 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801078d3:	55                   	push   %ebp
801078d4:	89 e5                	mov    %esp,%ebp
801078d6:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801078d9:	0f 20 d0             	mov    %cr2,%eax
801078dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801078df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801078e2:	c9                   	leave  
801078e3:	c3                   	ret    

801078e4 <tvinit>:
extern void increase_MLFQ_tick_used(void);    // in proc.c
extern void increase_stride_tick_used(void);  // in proc.c

void
tvinit(void)
{
801078e4:	55                   	push   %ebp
801078e5:	89 e5                	mov    %esp,%ebp
801078e7:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801078ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801078f1:	e9 c3 00 00 00       	jmp    801079b9 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801078f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f9:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
80107900:	89 c2                	mov    %eax,%edx
80107902:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107905:	66 89 14 c5 60 88 11 	mov    %dx,-0x7fee77a0(,%eax,8)
8010790c:	80 
8010790d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107910:	66 c7 04 c5 62 88 11 	movw   $0x8,-0x7fee779e(,%eax,8)
80107917:	80 08 00 
8010791a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791d:	0f b6 14 c5 64 88 11 	movzbl -0x7fee779c(,%eax,8),%edx
80107924:	80 
80107925:	83 e2 e0             	and    $0xffffffe0,%edx
80107928:	88 14 c5 64 88 11 80 	mov    %dl,-0x7fee779c(,%eax,8)
8010792f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107932:	0f b6 14 c5 64 88 11 	movzbl -0x7fee779c(,%eax,8),%edx
80107939:	80 
8010793a:	83 e2 1f             	and    $0x1f,%edx
8010793d:	88 14 c5 64 88 11 80 	mov    %dl,-0x7fee779c(,%eax,8)
80107944:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107947:	0f b6 14 c5 65 88 11 	movzbl -0x7fee779b(,%eax,8),%edx
8010794e:	80 
8010794f:	83 e2 f0             	and    $0xfffffff0,%edx
80107952:	83 ca 0e             	or     $0xe,%edx
80107955:	88 14 c5 65 88 11 80 	mov    %dl,-0x7fee779b(,%eax,8)
8010795c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010795f:	0f b6 14 c5 65 88 11 	movzbl -0x7fee779b(,%eax,8),%edx
80107966:	80 
80107967:	83 e2 ef             	and    $0xffffffef,%edx
8010796a:	88 14 c5 65 88 11 80 	mov    %dl,-0x7fee779b(,%eax,8)
80107971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107974:	0f b6 14 c5 65 88 11 	movzbl -0x7fee779b(,%eax,8),%edx
8010797b:	80 
8010797c:	83 e2 9f             	and    $0xffffff9f,%edx
8010797f:	88 14 c5 65 88 11 80 	mov    %dl,-0x7fee779b(,%eax,8)
80107986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107989:	0f b6 14 c5 65 88 11 	movzbl -0x7fee779b(,%eax,8),%edx
80107990:	80 
80107991:	83 ca 80             	or     $0xffffff80,%edx
80107994:	88 14 c5 65 88 11 80 	mov    %dl,-0x7fee779b(,%eax,8)
8010799b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799e:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
801079a5:	c1 e8 10             	shr    $0x10,%eax
801079a8:	89 c2                	mov    %eax,%edx
801079aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ad:	66 89 14 c5 66 88 11 	mov    %dx,-0x7fee779a(,%eax,8)
801079b4:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801079b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801079b9:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801079c0:	0f 8e 30 ff ff ff    	jle    801078f6 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801079c6:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
801079cb:	66 a3 60 8a 11 80    	mov    %ax,0x80118a60
801079d1:	66 c7 05 62 8a 11 80 	movw   $0x8,0x80118a62
801079d8:	08 00 
801079da:	0f b6 05 64 8a 11 80 	movzbl 0x80118a64,%eax
801079e1:	83 e0 e0             	and    $0xffffffe0,%eax
801079e4:	a2 64 8a 11 80       	mov    %al,0x80118a64
801079e9:	0f b6 05 64 8a 11 80 	movzbl 0x80118a64,%eax
801079f0:	83 e0 1f             	and    $0x1f,%eax
801079f3:	a2 64 8a 11 80       	mov    %al,0x80118a64
801079f8:	0f b6 05 65 8a 11 80 	movzbl 0x80118a65,%eax
801079ff:	83 c8 0f             	or     $0xf,%eax
80107a02:	a2 65 8a 11 80       	mov    %al,0x80118a65
80107a07:	0f b6 05 65 8a 11 80 	movzbl 0x80118a65,%eax
80107a0e:	83 e0 ef             	and    $0xffffffef,%eax
80107a11:	a2 65 8a 11 80       	mov    %al,0x80118a65
80107a16:	0f b6 05 65 8a 11 80 	movzbl 0x80118a65,%eax
80107a1d:	83 c8 60             	or     $0x60,%eax
80107a20:	a2 65 8a 11 80       	mov    %al,0x80118a65
80107a25:	0f b6 05 65 8a 11 80 	movzbl 0x80118a65,%eax
80107a2c:	83 c8 80             	or     $0xffffff80,%eax
80107a2f:	a2 65 8a 11 80       	mov    %al,0x80118a65
80107a34:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80107a39:	c1 e8 10             	shr    $0x10,%eax
80107a3c:	66 a3 66 8a 11 80    	mov    %ax,0x80118a66
  SETGATE(idt[T_USER_INT], 1, SEG_KCODE<<3, vectors[T_USER_INT], DPL_USER);
80107a42:	a1 bc d2 10 80       	mov    0x8010d2bc,%eax
80107a47:	66 a3 60 8c 11 80    	mov    %ax,0x80118c60
80107a4d:	66 c7 05 62 8c 11 80 	movw   $0x8,0x80118c62
80107a54:	08 00 
80107a56:	0f b6 05 64 8c 11 80 	movzbl 0x80118c64,%eax
80107a5d:	83 e0 e0             	and    $0xffffffe0,%eax
80107a60:	a2 64 8c 11 80       	mov    %al,0x80118c64
80107a65:	0f b6 05 64 8c 11 80 	movzbl 0x80118c64,%eax
80107a6c:	83 e0 1f             	and    $0x1f,%eax
80107a6f:	a2 64 8c 11 80       	mov    %al,0x80118c64
80107a74:	0f b6 05 65 8c 11 80 	movzbl 0x80118c65,%eax
80107a7b:	83 c8 0f             	or     $0xf,%eax
80107a7e:	a2 65 8c 11 80       	mov    %al,0x80118c65
80107a83:	0f b6 05 65 8c 11 80 	movzbl 0x80118c65,%eax
80107a8a:	83 e0 ef             	and    $0xffffffef,%eax
80107a8d:	a2 65 8c 11 80       	mov    %al,0x80118c65
80107a92:	0f b6 05 65 8c 11 80 	movzbl 0x80118c65,%eax
80107a99:	83 c8 60             	or     $0x60,%eax
80107a9c:	a2 65 8c 11 80       	mov    %al,0x80118c65
80107aa1:	0f b6 05 65 8c 11 80 	movzbl 0x80118c65,%eax
80107aa8:	83 c8 80             	or     $0xffffff80,%eax
80107aab:	a2 65 8c 11 80       	mov    %al,0x80118c65
80107ab0:	a1 bc d2 10 80       	mov    0x8010d2bc,%eax
80107ab5:	c1 e8 10             	shr    $0x10,%eax
80107ab8:	66 a3 66 8c 11 80    	mov    %ax,0x80118c66

  initlock(&tickslock, "time");
80107abe:	c7 44 24 04 34 9f 10 	movl   $0x80109f34,0x4(%esp)
80107ac5:	80 
80107ac6:	c7 04 24 20 88 11 80 	movl   $0x80118820,(%esp)
80107acd:	e8 1d e7 ff ff       	call   801061ef <initlock>
}
80107ad2:	c9                   	leave  
80107ad3:	c3                   	ret    

80107ad4 <idtinit>:

void
idtinit(void)
{
80107ad4:	55                   	push   %ebp
80107ad5:	89 e5                	mov    %esp,%ebp
80107ad7:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80107ada:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80107ae1:	00 
80107ae2:	c7 04 24 60 88 11 80 	movl   $0x80118860,(%esp)
80107ae9:	e8 bc fd ff ff       	call   801078aa <lidt>
}
80107aee:	c9                   	leave  
80107aef:	c3                   	ret    

80107af0 <trap>:
  * } */

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	57                   	push   %edi
80107af4:	56                   	push   %esi
80107af5:	53                   	push   %ebx
80107af6:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80107af9:	8b 45 08             	mov    0x8(%ebp),%eax
80107afc:	8b 40 30             	mov    0x30(%eax),%eax
80107aff:	83 f8 40             	cmp    $0x40,%eax
80107b02:	75 3f                	jne    80107b43 <trap+0x53>
    if(proc->killed)
80107b04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b0a:	8b 40 24             	mov    0x24(%eax),%eax
80107b0d:	85 c0                	test   %eax,%eax
80107b0f:	74 05                	je     80107b16 <trap+0x26>
      exit();
80107b11:	e8 ef d0 ff ff       	call   80104c05 <exit>
    proc->tf = tf;
80107b16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b1c:	8b 55 08             	mov    0x8(%ebp),%edx
80107b1f:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107b22:	e8 61 ed ff ff       	call   80106888 <syscall>
    if(proc->killed)
80107b27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b2d:	8b 40 24             	mov    0x24(%eax),%eax
80107b30:	85 c0                	test   %eax,%eax
80107b32:	74 0a                	je     80107b3e <trap+0x4e>
      exit();
80107b34:	e8 cc d0 ff ff       	call   80104c05 <exit>
    return;
80107b39:	e9 e0 02 00 00       	jmp    80107e1e <trap+0x32e>
80107b3e:	e9 db 02 00 00       	jmp    80107e1e <trap+0x32e>
  }

  if(tf->trapno == T_USER_INT){
80107b43:	8b 45 08             	mov    0x8(%ebp),%eax
80107b46:	8b 40 30             	mov    0x30(%eax),%eax
80107b49:	3d 80 00 00 00       	cmp    $0x80,%eax
80107b4e:	75 16                	jne    80107b66 <trap+0x76>
      cprintf("user interrupt 128 called!\n");
80107b50:	c7 04 24 39 9f 10 80 	movl   $0x80109f39,(%esp)
80107b57:	e8 6c 88 ff ff       	call   801003c8 <cprintf>
      exit();
80107b5c:	e8 a4 d0 ff ff       	call   80104c05 <exit>
    return;
80107b61:	e9 b8 02 00 00       	jmp    80107e1e <trap+0x32e>
  }

  switch(tf->trapno){
80107b66:	8b 45 08             	mov    0x8(%ebp),%eax
80107b69:	8b 40 30             	mov    0x30(%eax),%eax
80107b6c:	83 e8 20             	sub    $0x20,%eax
80107b6f:	83 f8 1f             	cmp    $0x1f,%eax
80107b72:	0f 87 b1 00 00 00    	ja     80107c29 <trap+0x139>
80107b78:	8b 04 85 f8 9f 10 80 	mov    -0x7fef6008(,%eax,4),%eax
80107b7f:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80107b81:	e8 4f b4 ff ff       	call   80102fd5 <cpunum>
80107b86:	85 c0                	test   %eax,%eax
80107b88:	75 31                	jne    80107bbb <trap+0xcb>
      acquire(&tickslock);
80107b8a:	c7 04 24 20 88 11 80 	movl   $0x80118820,(%esp)
80107b91:	e8 7a e6 ff ff       	call   80106210 <acquire>
      ticks++;
80107b96:	a1 60 90 11 80       	mov    0x80119060,%eax
80107b9b:	83 c0 01             	add    $0x1,%eax
80107b9e:	a3 60 90 11 80       	mov    %eax,0x80119060
      wakeup(&ticks);
80107ba3:	c7 04 24 60 90 11 80 	movl   $0x80119060,(%esp)
80107baa:	e8 6d db ff ff       	call   8010571c <wakeup>
      release(&tickslock);
80107baf:	c7 04 24 20 88 11 80 	movl   $0x80118820,(%esp)
80107bb6:	e8 bc e6 ff ff       	call   80106277 <release>
    }
    lapiceoi();
80107bbb:	e8 b1 b4 ff ff       	call   80103071 <lapiceoi>
    break;
80107bc0:	e9 2f 01 00 00       	jmp    80107cf4 <trap+0x204>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107bc5:	e8 7b ac ff ff       	call   80102845 <ideintr>
    lapiceoi();
80107bca:	e8 a2 b4 ff ff       	call   80103071 <lapiceoi>
    break;
80107bcf:	e9 20 01 00 00       	jmp    80107cf4 <trap+0x204>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107bd4:	e8 23 b2 ff ff       	call   80102dfc <kbdintr>
    lapiceoi();
80107bd9:	e8 93 b4 ff ff       	call   80103071 <lapiceoi>
    break;
80107bde:	e9 11 01 00 00       	jmp    80107cf4 <trap+0x204>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107be3:	e8 2b 04 00 00       	call   80108013 <uartintr>
    lapiceoi();
80107be8:	e8 84 b4 ff ff       	call   80103071 <lapiceoi>
    break;
80107bed:	e9 02 01 00 00       	jmp    80107cf4 <trap+0x204>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107bf2:	8b 45 08             	mov    0x8(%ebp),%eax
80107bf5:	8b 70 38             	mov    0x38(%eax),%esi
            cpunum(), tf->cs, tf->eip);
80107bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80107bfb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107bff:	0f b7 d8             	movzwl %ax,%ebx
80107c02:	e8 ce b3 ff ff       	call   80102fd5 <cpunum>
80107c07:	89 74 24 0c          	mov    %esi,0xc(%esp)
80107c0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c13:	c7 04 24 58 9f 10 80 	movl   $0x80109f58,(%esp)
80107c1a:	e8 a9 87 ff ff       	call   801003c8 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80107c1f:	e8 4d b4 ff ff       	call   80103071 <lapiceoi>
    break;
80107c24:	e9 cb 00 00 00       	jmp    80107cf4 <trap+0x204>

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107c29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c2f:	85 c0                	test   %eax,%eax
80107c31:	74 11                	je     80107c44 <trap+0x154>
80107c33:	8b 45 08             	mov    0x8(%ebp),%eax
80107c36:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107c3a:	0f b7 c0             	movzwl %ax,%eax
80107c3d:	83 e0 03             	and    $0x3,%eax
80107c40:	85 c0                	test   %eax,%eax
80107c42:	75 40                	jne    80107c84 <trap+0x194>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107c44:	e8 8a fc ff ff       	call   801078d3 <rcr2>
80107c49:	89 c3                	mov    %eax,%ebx
80107c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c4e:	8b 70 38             	mov    0x38(%eax),%esi
80107c51:	e8 7f b3 ff ff       	call   80102fd5 <cpunum>
80107c56:	8b 55 08             	mov    0x8(%ebp),%edx
80107c59:	8b 52 30             	mov    0x30(%edx),%edx
80107c5c:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107c60:	89 74 24 0c          	mov    %esi,0xc(%esp)
80107c64:	89 44 24 08          	mov    %eax,0x8(%esp)
80107c68:	89 54 24 04          	mov    %edx,0x4(%esp)
80107c6c:	c7 04 24 7c 9f 10 80 	movl   $0x80109f7c,(%esp)
80107c73:	e8 50 87 ff ff       	call   801003c8 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80107c78:	c7 04 24 ae 9f 10 80 	movl   $0x80109fae,(%esp)
80107c7f:	e8 de 88 ff ff       	call   80100562 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107c84:	e8 4a fc ff ff       	call   801078d3 <rcr2>
80107c89:	89 c3                	mov    %eax,%ebx
80107c8b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c8e:	8b 78 38             	mov    0x38(%eax),%edi
80107c91:	e8 3f b3 ff ff       	call   80102fd5 <cpunum>
80107c96:	89 c2                	mov    %eax,%edx
80107c98:	8b 45 08             	mov    0x8(%ebp),%eax
80107c9b:	8b 70 34             	mov    0x34(%eax),%esi
80107c9e:	8b 45 08             	mov    0x8(%ebp),%eax
80107ca1:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80107ca4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107caa:	83 c0 6c             	add    $0x6c,%eax
80107cad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107cb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107cb6:	8b 40 10             	mov    0x10(%eax),%eax
80107cb9:	89 5c 24 1c          	mov    %ebx,0x1c(%esp)
80107cbd:	89 7c 24 18          	mov    %edi,0x18(%esp)
80107cc1:	89 54 24 14          	mov    %edx,0x14(%esp)
80107cc5:	89 74 24 10          	mov    %esi,0x10(%esp)
80107cc9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107ccd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107cd0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80107cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cd8:	c7 04 24 b4 9f 10 80 	movl   $0x80109fb4,(%esp)
80107cdf:	e8 e4 86 ff ff       	call   801003c8 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
80107ce4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cea:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107cf1:	eb 01                	jmp    80107cf4 <trap+0x204>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107cf3:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107cf4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cfa:	85 c0                	test   %eax,%eax
80107cfc:	74 24                	je     80107d22 <trap+0x232>
80107cfe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d04:	8b 40 24             	mov    0x24(%eax),%eax
80107d07:	85 c0                	test   %eax,%eax
80107d09:	74 17                	je     80107d22 <trap+0x232>
80107d0b:	8b 45 08             	mov    0x8(%ebp),%eax
80107d0e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107d12:	0f b7 c0             	movzwl %ax,%eax
80107d15:	83 e0 03             	and    $0x3,%eax
80107d18:	83 f8 03             	cmp    $0x3,%eax
80107d1b:	75 05                	jne    80107d22 <trap+0x232>
    exit();
80107d1d:	e8 e3 ce ff ff       	call   80104c05 <exit>
  // If interrupts were on while locks held, would need to check nlock.



  // Design Document 1-1-2-5. Priority boost
  if(get_MLFQ_tick_used() >= 100){
80107d22:	e8 00 c8 ff ff       	call   80104527 <get_MLFQ_tick_used>
80107d27:	83 f8 63             	cmp    $0x63,%eax
80107d2a:	7e 05                	jle    80107d31 <trap+0x241>
#ifdef MJ_DEBUGGING
    cprintf("\n\n*** Priority Boost ***\n\n");
#endif
    priority_boost();
80107d2c:	e8 8b db ff ff       	call   801058bc <priority_boost>
  }


  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80107d31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d37:	85 c0                	test   %eax,%eax
80107d39:	0f 84 b1 00 00 00    	je     80107df0 <trap+0x300>
80107d3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d45:	8b 40 0c             	mov    0xc(%eax),%eax
80107d48:	83 f8 04             	cmp    $0x4,%eax
80107d4b:	0f 85 9f 00 00 00    	jne    80107df0 <trap+0x300>
80107d51:	8b 45 08             	mov    0x8(%ebp),%eax
80107d54:	8b 40 30             	mov    0x30(%eax),%eax
80107d57:	83 f8 20             	cmp    $0x20,%eax
80107d5a:	0f 85 90 00 00 00    	jne    80107df0 <trap+0x300>
    // Design Document 1-1-2-2.
    proc->tick_used++;
80107d60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d66:	8b 50 7c             	mov    0x7c(%eax),%edx
80107d69:	83 c2 01             	add    $0x1,%edx
80107d6c:	89 50 7c             	mov    %edx,0x7c(%eax)
    proc->time_quantum_used++;
80107d6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d75:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80107d7b:	83 c2 01             	add    $0x1,%edx
80107d7e:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)

    if(proc->cpu_share == 0){
80107d84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d8a:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80107d90:	85 c0                	test   %eax,%eax
80107d92:	75 07                	jne    80107d9b <trap+0x2ab>
      increase_MLFQ_tick_used();
80107d94:	e8 98 c7 ff ff       	call   80104531 <increase_MLFQ_tick_used>
80107d99:	eb 05                	jmp    80107da0 <trap+0x2b0>
    }else{
      increase_stride_tick_used();
80107d9b:	e8 a3 c7 ff ff       	call   80104543 <increase_stride_tick_used>
          tick_used: %d\n\
          time_quantum_used: %d\n",proc->pid, tf->trapno, ticks,get_MLFQ_tick_used() ,proc->tick_used, proc->time_quantum_used);
#endif

    // yield if it uses whole time quantum
    if(proc->time_quantum_used >= get_time_quantum()){
80107da0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107da6:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
80107dac:	e8 38 c7 ff ff       	call   801044e9 <get_time_quantum>
80107db1:	39 c3                	cmp    %eax,%ebx
80107db3:	7c 3b                	jl     80107df0 <trap+0x300>
      cprintf("**********************************\n");
#endif
      

      // Design Document 1-1-2-5. Moving a process to the lower level
      if(proc->level_of_MLFQ < NMLFQ - 1){
80107db5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107dbb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80107dc1:	83 f8 01             	cmp    $0x1,%eax
80107dc4:	7f 15                	jg     80107ddb <trap+0x2eb>
        proc->level_of_MLFQ++;
80107dc6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107dcc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80107dd2:	83 c2 01             	add    $0x1,%edx
80107dd5:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
      }

      // Design Document 1-1-2-2
      proc->time_quantum_used = 0;
80107ddb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107de1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80107de8:	00 00 00 
      yield();
80107deb:	e8 cd d7 ff ff       	call   801055bd <yield>
    }
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107df0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107df6:	85 c0                	test   %eax,%eax
80107df8:	74 24                	je     80107e1e <trap+0x32e>
80107dfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e00:	8b 40 24             	mov    0x24(%eax),%eax
80107e03:	85 c0                	test   %eax,%eax
80107e05:	74 17                	je     80107e1e <trap+0x32e>
80107e07:	8b 45 08             	mov    0x8(%ebp),%eax
80107e0a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107e0e:	0f b7 c0             	movzwl %ax,%eax
80107e11:	83 e0 03             	and    $0x3,%eax
80107e14:	83 f8 03             	cmp    $0x3,%eax
80107e17:	75 05                	jne    80107e1e <trap+0x32e>
    exit();
80107e19:	e8 e7 cd ff ff       	call   80104c05 <exit>
}
80107e1e:	83 c4 3c             	add    $0x3c,%esp
80107e21:	5b                   	pop    %ebx
80107e22:	5e                   	pop    %esi
80107e23:	5f                   	pop    %edi
80107e24:	5d                   	pop    %ebp
80107e25:	c3                   	ret    

80107e26 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107e26:	55                   	push   %ebp
80107e27:	89 e5                	mov    %esp,%ebp
80107e29:	83 ec 14             	sub    $0x14,%esp
80107e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80107e2f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107e33:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107e37:	89 c2                	mov    %eax,%edx
80107e39:	ec                   	in     (%dx),%al
80107e3a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107e3d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107e41:	c9                   	leave  
80107e42:	c3                   	ret    

80107e43 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107e43:	55                   	push   %ebp
80107e44:	89 e5                	mov    %esp,%ebp
80107e46:	83 ec 08             	sub    $0x8,%esp
80107e49:	8b 55 08             	mov    0x8(%ebp),%edx
80107e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e4f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107e53:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107e56:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107e5a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107e5e:	ee                   	out    %al,(%dx)
}
80107e5f:	c9                   	leave  
80107e60:	c3                   	ret    

80107e61 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107e61:	55                   	push   %ebp
80107e62:	89 e5                	mov    %esp,%ebp
80107e64:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107e67:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107e6e:	00 
80107e6f:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107e76:	e8 c8 ff ff ff       	call   80107e43 <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107e7b:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80107e82:	00 
80107e83:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107e8a:	e8 b4 ff ff ff       	call   80107e43 <outb>
  outb(COM1+0, 115200/9600);
80107e8f:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80107e96:	00 
80107e97:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107e9e:	e8 a0 ff ff ff       	call   80107e43 <outb>
  outb(COM1+1, 0);
80107ea3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107eaa:	00 
80107eab:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107eb2:	e8 8c ff ff ff       	call   80107e43 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107eb7:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80107ebe:	00 
80107ebf:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107ec6:	e8 78 ff ff ff       	call   80107e43 <outb>
  outb(COM1+4, 0);
80107ecb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ed2:	00 
80107ed3:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107eda:	e8 64 ff ff ff       	call   80107e43 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107edf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80107ee6:	00 
80107ee7:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107eee:	e8 50 ff ff ff       	call   80107e43 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107ef3:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107efa:	e8 27 ff ff ff       	call   80107e26 <inb>
80107eff:	3c ff                	cmp    $0xff,%al
80107f01:	75 02                	jne    80107f05 <uartinit+0xa4>
    return;
80107f03:	eb 6a                	jmp    80107f6f <uartinit+0x10e>
  uart = 1;
80107f05:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
80107f0c:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107f0f:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107f16:	e8 0b ff ff ff       	call   80107e26 <inb>
  inb(COM1+0);
80107f1b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107f22:	e8 ff fe ff ff       	call   80107e26 <inb>
  picenable(IRQ_COM1);
80107f27:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107f2e:	e8 26 bf ff ff       	call   80103e59 <picenable>
  ioapicenable(IRQ_COM1, 0);
80107f33:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107f3a:	00 
80107f3b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107f42:	e8 83 ab ff ff       	call   80102aca <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107f47:	c7 45 f4 78 a0 10 80 	movl   $0x8010a078,-0xc(%ebp)
80107f4e:	eb 15                	jmp    80107f65 <uartinit+0x104>
    uartputc(*p);
80107f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f53:	0f b6 00             	movzbl (%eax),%eax
80107f56:	0f be c0             	movsbl %al,%eax
80107f59:	89 04 24             	mov    %eax,(%esp)
80107f5c:	e8 10 00 00 00       	call   80107f71 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107f61:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f68:	0f b6 00             	movzbl (%eax),%eax
80107f6b:	84 c0                	test   %al,%al
80107f6d:	75 e1                	jne    80107f50 <uartinit+0xef>
    uartputc(*p);
}
80107f6f:	c9                   	leave  
80107f70:	c3                   	ret    

80107f71 <uartputc>:

void
uartputc(int c)
{
80107f71:	55                   	push   %ebp
80107f72:	89 e5                	mov    %esp,%ebp
80107f74:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80107f77:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80107f7c:	85 c0                	test   %eax,%eax
80107f7e:	75 02                	jne    80107f82 <uartputc+0x11>
    return;
80107f80:	eb 4b                	jmp    80107fcd <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107f82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f89:	eb 10                	jmp    80107f9b <uartputc+0x2a>
    microdelay(10);
80107f8b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80107f92:	e8 ff b0 ff ff       	call   80103096 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107f97:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107f9b:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107f9f:	7f 16                	jg     80107fb7 <uartputc+0x46>
80107fa1:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107fa8:	e8 79 fe ff ff       	call   80107e26 <inb>
80107fad:	0f b6 c0             	movzbl %al,%eax
80107fb0:	83 e0 20             	and    $0x20,%eax
80107fb3:	85 c0                	test   %eax,%eax
80107fb5:	74 d4                	je     80107f8b <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80107fb7:	8b 45 08             	mov    0x8(%ebp),%eax
80107fba:	0f b6 c0             	movzbl %al,%eax
80107fbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fc1:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107fc8:	e8 76 fe ff ff       	call   80107e43 <outb>
}
80107fcd:	c9                   	leave  
80107fce:	c3                   	ret    

80107fcf <uartgetc>:

static int
uartgetc(void)
{
80107fcf:	55                   	push   %ebp
80107fd0:	89 e5                	mov    %esp,%ebp
80107fd2:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80107fd5:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80107fda:	85 c0                	test   %eax,%eax
80107fdc:	75 07                	jne    80107fe5 <uartgetc+0x16>
    return -1;
80107fde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fe3:	eb 2c                	jmp    80108011 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80107fe5:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107fec:	e8 35 fe ff ff       	call   80107e26 <inb>
80107ff1:	0f b6 c0             	movzbl %al,%eax
80107ff4:	83 e0 01             	and    $0x1,%eax
80107ff7:	85 c0                	test   %eax,%eax
80107ff9:	75 07                	jne    80108002 <uartgetc+0x33>
    return -1;
80107ffb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108000:	eb 0f                	jmp    80108011 <uartgetc+0x42>
  return inb(COM1+0);
80108002:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80108009:	e8 18 fe ff ff       	call   80107e26 <inb>
8010800e:	0f b6 c0             	movzbl %al,%eax
}
80108011:	c9                   	leave  
80108012:	c3                   	ret    

80108013 <uartintr>:

void
uartintr(void)
{
80108013:	55                   	push   %ebp
80108014:	89 e5                	mov    %esp,%ebp
80108016:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80108019:	c7 04 24 cf 7f 10 80 	movl   $0x80107fcf,(%esp)
80108020:	e8 cb 87 ff ff       	call   801007f0 <consoleintr>
}
80108025:	c9                   	leave  
80108026:	c3                   	ret    

80108027 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80108027:	6a 00                	push   $0x0
  pushl $0
80108029:	6a 00                	push   $0x0
  jmp alltraps
8010802b:	e9 4f f8 ff ff       	jmp    8010787f <alltraps>

80108030 <vector1>:
.globl vector1
vector1:
  pushl $0
80108030:	6a 00                	push   $0x0
  pushl $1
80108032:	6a 01                	push   $0x1
  jmp alltraps
80108034:	e9 46 f8 ff ff       	jmp    8010787f <alltraps>

80108039 <vector2>:
.globl vector2
vector2:
  pushl $0
80108039:	6a 00                	push   $0x0
  pushl $2
8010803b:	6a 02                	push   $0x2
  jmp alltraps
8010803d:	e9 3d f8 ff ff       	jmp    8010787f <alltraps>

80108042 <vector3>:
.globl vector3
vector3:
  pushl $0
80108042:	6a 00                	push   $0x0
  pushl $3
80108044:	6a 03                	push   $0x3
  jmp alltraps
80108046:	e9 34 f8 ff ff       	jmp    8010787f <alltraps>

8010804b <vector4>:
.globl vector4
vector4:
  pushl $0
8010804b:	6a 00                	push   $0x0
  pushl $4
8010804d:	6a 04                	push   $0x4
  jmp alltraps
8010804f:	e9 2b f8 ff ff       	jmp    8010787f <alltraps>

80108054 <vector5>:
.globl vector5
vector5:
  pushl $0
80108054:	6a 00                	push   $0x0
  pushl $5
80108056:	6a 05                	push   $0x5
  jmp alltraps
80108058:	e9 22 f8 ff ff       	jmp    8010787f <alltraps>

8010805d <vector6>:
.globl vector6
vector6:
  pushl $0
8010805d:	6a 00                	push   $0x0
  pushl $6
8010805f:	6a 06                	push   $0x6
  jmp alltraps
80108061:	e9 19 f8 ff ff       	jmp    8010787f <alltraps>

80108066 <vector7>:
.globl vector7
vector7:
  pushl $0
80108066:	6a 00                	push   $0x0
  pushl $7
80108068:	6a 07                	push   $0x7
  jmp alltraps
8010806a:	e9 10 f8 ff ff       	jmp    8010787f <alltraps>

8010806f <vector8>:
.globl vector8
vector8:
  pushl $8
8010806f:	6a 08                	push   $0x8
  jmp alltraps
80108071:	e9 09 f8 ff ff       	jmp    8010787f <alltraps>

80108076 <vector9>:
.globl vector9
vector9:
  pushl $0
80108076:	6a 00                	push   $0x0
  pushl $9
80108078:	6a 09                	push   $0x9
  jmp alltraps
8010807a:	e9 00 f8 ff ff       	jmp    8010787f <alltraps>

8010807f <vector10>:
.globl vector10
vector10:
  pushl $10
8010807f:	6a 0a                	push   $0xa
  jmp alltraps
80108081:	e9 f9 f7 ff ff       	jmp    8010787f <alltraps>

80108086 <vector11>:
.globl vector11
vector11:
  pushl $11
80108086:	6a 0b                	push   $0xb
  jmp alltraps
80108088:	e9 f2 f7 ff ff       	jmp    8010787f <alltraps>

8010808d <vector12>:
.globl vector12
vector12:
  pushl $12
8010808d:	6a 0c                	push   $0xc
  jmp alltraps
8010808f:	e9 eb f7 ff ff       	jmp    8010787f <alltraps>

80108094 <vector13>:
.globl vector13
vector13:
  pushl $13
80108094:	6a 0d                	push   $0xd
  jmp alltraps
80108096:	e9 e4 f7 ff ff       	jmp    8010787f <alltraps>

8010809b <vector14>:
.globl vector14
vector14:
  pushl $14
8010809b:	6a 0e                	push   $0xe
  jmp alltraps
8010809d:	e9 dd f7 ff ff       	jmp    8010787f <alltraps>

801080a2 <vector15>:
.globl vector15
vector15:
  pushl $0
801080a2:	6a 00                	push   $0x0
  pushl $15
801080a4:	6a 0f                	push   $0xf
  jmp alltraps
801080a6:	e9 d4 f7 ff ff       	jmp    8010787f <alltraps>

801080ab <vector16>:
.globl vector16
vector16:
  pushl $0
801080ab:	6a 00                	push   $0x0
  pushl $16
801080ad:	6a 10                	push   $0x10
  jmp alltraps
801080af:	e9 cb f7 ff ff       	jmp    8010787f <alltraps>

801080b4 <vector17>:
.globl vector17
vector17:
  pushl $17
801080b4:	6a 11                	push   $0x11
  jmp alltraps
801080b6:	e9 c4 f7 ff ff       	jmp    8010787f <alltraps>

801080bb <vector18>:
.globl vector18
vector18:
  pushl $0
801080bb:	6a 00                	push   $0x0
  pushl $18
801080bd:	6a 12                	push   $0x12
  jmp alltraps
801080bf:	e9 bb f7 ff ff       	jmp    8010787f <alltraps>

801080c4 <vector19>:
.globl vector19
vector19:
  pushl $0
801080c4:	6a 00                	push   $0x0
  pushl $19
801080c6:	6a 13                	push   $0x13
  jmp alltraps
801080c8:	e9 b2 f7 ff ff       	jmp    8010787f <alltraps>

801080cd <vector20>:
.globl vector20
vector20:
  pushl $0
801080cd:	6a 00                	push   $0x0
  pushl $20
801080cf:	6a 14                	push   $0x14
  jmp alltraps
801080d1:	e9 a9 f7 ff ff       	jmp    8010787f <alltraps>

801080d6 <vector21>:
.globl vector21
vector21:
  pushl $0
801080d6:	6a 00                	push   $0x0
  pushl $21
801080d8:	6a 15                	push   $0x15
  jmp alltraps
801080da:	e9 a0 f7 ff ff       	jmp    8010787f <alltraps>

801080df <vector22>:
.globl vector22
vector22:
  pushl $0
801080df:	6a 00                	push   $0x0
  pushl $22
801080e1:	6a 16                	push   $0x16
  jmp alltraps
801080e3:	e9 97 f7 ff ff       	jmp    8010787f <alltraps>

801080e8 <vector23>:
.globl vector23
vector23:
  pushl $0
801080e8:	6a 00                	push   $0x0
  pushl $23
801080ea:	6a 17                	push   $0x17
  jmp alltraps
801080ec:	e9 8e f7 ff ff       	jmp    8010787f <alltraps>

801080f1 <vector24>:
.globl vector24
vector24:
  pushl $0
801080f1:	6a 00                	push   $0x0
  pushl $24
801080f3:	6a 18                	push   $0x18
  jmp alltraps
801080f5:	e9 85 f7 ff ff       	jmp    8010787f <alltraps>

801080fa <vector25>:
.globl vector25
vector25:
  pushl $0
801080fa:	6a 00                	push   $0x0
  pushl $25
801080fc:	6a 19                	push   $0x19
  jmp alltraps
801080fe:	e9 7c f7 ff ff       	jmp    8010787f <alltraps>

80108103 <vector26>:
.globl vector26
vector26:
  pushl $0
80108103:	6a 00                	push   $0x0
  pushl $26
80108105:	6a 1a                	push   $0x1a
  jmp alltraps
80108107:	e9 73 f7 ff ff       	jmp    8010787f <alltraps>

8010810c <vector27>:
.globl vector27
vector27:
  pushl $0
8010810c:	6a 00                	push   $0x0
  pushl $27
8010810e:	6a 1b                	push   $0x1b
  jmp alltraps
80108110:	e9 6a f7 ff ff       	jmp    8010787f <alltraps>

80108115 <vector28>:
.globl vector28
vector28:
  pushl $0
80108115:	6a 00                	push   $0x0
  pushl $28
80108117:	6a 1c                	push   $0x1c
  jmp alltraps
80108119:	e9 61 f7 ff ff       	jmp    8010787f <alltraps>

8010811e <vector29>:
.globl vector29
vector29:
  pushl $0
8010811e:	6a 00                	push   $0x0
  pushl $29
80108120:	6a 1d                	push   $0x1d
  jmp alltraps
80108122:	e9 58 f7 ff ff       	jmp    8010787f <alltraps>

80108127 <vector30>:
.globl vector30
vector30:
  pushl $0
80108127:	6a 00                	push   $0x0
  pushl $30
80108129:	6a 1e                	push   $0x1e
  jmp alltraps
8010812b:	e9 4f f7 ff ff       	jmp    8010787f <alltraps>

80108130 <vector31>:
.globl vector31
vector31:
  pushl $0
80108130:	6a 00                	push   $0x0
  pushl $31
80108132:	6a 1f                	push   $0x1f
  jmp alltraps
80108134:	e9 46 f7 ff ff       	jmp    8010787f <alltraps>

80108139 <vector32>:
.globl vector32
vector32:
  pushl $0
80108139:	6a 00                	push   $0x0
  pushl $32
8010813b:	6a 20                	push   $0x20
  jmp alltraps
8010813d:	e9 3d f7 ff ff       	jmp    8010787f <alltraps>

80108142 <vector33>:
.globl vector33
vector33:
  pushl $0
80108142:	6a 00                	push   $0x0
  pushl $33
80108144:	6a 21                	push   $0x21
  jmp alltraps
80108146:	e9 34 f7 ff ff       	jmp    8010787f <alltraps>

8010814b <vector34>:
.globl vector34
vector34:
  pushl $0
8010814b:	6a 00                	push   $0x0
  pushl $34
8010814d:	6a 22                	push   $0x22
  jmp alltraps
8010814f:	e9 2b f7 ff ff       	jmp    8010787f <alltraps>

80108154 <vector35>:
.globl vector35
vector35:
  pushl $0
80108154:	6a 00                	push   $0x0
  pushl $35
80108156:	6a 23                	push   $0x23
  jmp alltraps
80108158:	e9 22 f7 ff ff       	jmp    8010787f <alltraps>

8010815d <vector36>:
.globl vector36
vector36:
  pushl $0
8010815d:	6a 00                	push   $0x0
  pushl $36
8010815f:	6a 24                	push   $0x24
  jmp alltraps
80108161:	e9 19 f7 ff ff       	jmp    8010787f <alltraps>

80108166 <vector37>:
.globl vector37
vector37:
  pushl $0
80108166:	6a 00                	push   $0x0
  pushl $37
80108168:	6a 25                	push   $0x25
  jmp alltraps
8010816a:	e9 10 f7 ff ff       	jmp    8010787f <alltraps>

8010816f <vector38>:
.globl vector38
vector38:
  pushl $0
8010816f:	6a 00                	push   $0x0
  pushl $38
80108171:	6a 26                	push   $0x26
  jmp alltraps
80108173:	e9 07 f7 ff ff       	jmp    8010787f <alltraps>

80108178 <vector39>:
.globl vector39
vector39:
  pushl $0
80108178:	6a 00                	push   $0x0
  pushl $39
8010817a:	6a 27                	push   $0x27
  jmp alltraps
8010817c:	e9 fe f6 ff ff       	jmp    8010787f <alltraps>

80108181 <vector40>:
.globl vector40
vector40:
  pushl $0
80108181:	6a 00                	push   $0x0
  pushl $40
80108183:	6a 28                	push   $0x28
  jmp alltraps
80108185:	e9 f5 f6 ff ff       	jmp    8010787f <alltraps>

8010818a <vector41>:
.globl vector41
vector41:
  pushl $0
8010818a:	6a 00                	push   $0x0
  pushl $41
8010818c:	6a 29                	push   $0x29
  jmp alltraps
8010818e:	e9 ec f6 ff ff       	jmp    8010787f <alltraps>

80108193 <vector42>:
.globl vector42
vector42:
  pushl $0
80108193:	6a 00                	push   $0x0
  pushl $42
80108195:	6a 2a                	push   $0x2a
  jmp alltraps
80108197:	e9 e3 f6 ff ff       	jmp    8010787f <alltraps>

8010819c <vector43>:
.globl vector43
vector43:
  pushl $0
8010819c:	6a 00                	push   $0x0
  pushl $43
8010819e:	6a 2b                	push   $0x2b
  jmp alltraps
801081a0:	e9 da f6 ff ff       	jmp    8010787f <alltraps>

801081a5 <vector44>:
.globl vector44
vector44:
  pushl $0
801081a5:	6a 00                	push   $0x0
  pushl $44
801081a7:	6a 2c                	push   $0x2c
  jmp alltraps
801081a9:	e9 d1 f6 ff ff       	jmp    8010787f <alltraps>

801081ae <vector45>:
.globl vector45
vector45:
  pushl $0
801081ae:	6a 00                	push   $0x0
  pushl $45
801081b0:	6a 2d                	push   $0x2d
  jmp alltraps
801081b2:	e9 c8 f6 ff ff       	jmp    8010787f <alltraps>

801081b7 <vector46>:
.globl vector46
vector46:
  pushl $0
801081b7:	6a 00                	push   $0x0
  pushl $46
801081b9:	6a 2e                	push   $0x2e
  jmp alltraps
801081bb:	e9 bf f6 ff ff       	jmp    8010787f <alltraps>

801081c0 <vector47>:
.globl vector47
vector47:
  pushl $0
801081c0:	6a 00                	push   $0x0
  pushl $47
801081c2:	6a 2f                	push   $0x2f
  jmp alltraps
801081c4:	e9 b6 f6 ff ff       	jmp    8010787f <alltraps>

801081c9 <vector48>:
.globl vector48
vector48:
  pushl $0
801081c9:	6a 00                	push   $0x0
  pushl $48
801081cb:	6a 30                	push   $0x30
  jmp alltraps
801081cd:	e9 ad f6 ff ff       	jmp    8010787f <alltraps>

801081d2 <vector49>:
.globl vector49
vector49:
  pushl $0
801081d2:	6a 00                	push   $0x0
  pushl $49
801081d4:	6a 31                	push   $0x31
  jmp alltraps
801081d6:	e9 a4 f6 ff ff       	jmp    8010787f <alltraps>

801081db <vector50>:
.globl vector50
vector50:
  pushl $0
801081db:	6a 00                	push   $0x0
  pushl $50
801081dd:	6a 32                	push   $0x32
  jmp alltraps
801081df:	e9 9b f6 ff ff       	jmp    8010787f <alltraps>

801081e4 <vector51>:
.globl vector51
vector51:
  pushl $0
801081e4:	6a 00                	push   $0x0
  pushl $51
801081e6:	6a 33                	push   $0x33
  jmp alltraps
801081e8:	e9 92 f6 ff ff       	jmp    8010787f <alltraps>

801081ed <vector52>:
.globl vector52
vector52:
  pushl $0
801081ed:	6a 00                	push   $0x0
  pushl $52
801081ef:	6a 34                	push   $0x34
  jmp alltraps
801081f1:	e9 89 f6 ff ff       	jmp    8010787f <alltraps>

801081f6 <vector53>:
.globl vector53
vector53:
  pushl $0
801081f6:	6a 00                	push   $0x0
  pushl $53
801081f8:	6a 35                	push   $0x35
  jmp alltraps
801081fa:	e9 80 f6 ff ff       	jmp    8010787f <alltraps>

801081ff <vector54>:
.globl vector54
vector54:
  pushl $0
801081ff:	6a 00                	push   $0x0
  pushl $54
80108201:	6a 36                	push   $0x36
  jmp alltraps
80108203:	e9 77 f6 ff ff       	jmp    8010787f <alltraps>

80108208 <vector55>:
.globl vector55
vector55:
  pushl $0
80108208:	6a 00                	push   $0x0
  pushl $55
8010820a:	6a 37                	push   $0x37
  jmp alltraps
8010820c:	e9 6e f6 ff ff       	jmp    8010787f <alltraps>

80108211 <vector56>:
.globl vector56
vector56:
  pushl $0
80108211:	6a 00                	push   $0x0
  pushl $56
80108213:	6a 38                	push   $0x38
  jmp alltraps
80108215:	e9 65 f6 ff ff       	jmp    8010787f <alltraps>

8010821a <vector57>:
.globl vector57
vector57:
  pushl $0
8010821a:	6a 00                	push   $0x0
  pushl $57
8010821c:	6a 39                	push   $0x39
  jmp alltraps
8010821e:	e9 5c f6 ff ff       	jmp    8010787f <alltraps>

80108223 <vector58>:
.globl vector58
vector58:
  pushl $0
80108223:	6a 00                	push   $0x0
  pushl $58
80108225:	6a 3a                	push   $0x3a
  jmp alltraps
80108227:	e9 53 f6 ff ff       	jmp    8010787f <alltraps>

8010822c <vector59>:
.globl vector59
vector59:
  pushl $0
8010822c:	6a 00                	push   $0x0
  pushl $59
8010822e:	6a 3b                	push   $0x3b
  jmp alltraps
80108230:	e9 4a f6 ff ff       	jmp    8010787f <alltraps>

80108235 <vector60>:
.globl vector60
vector60:
  pushl $0
80108235:	6a 00                	push   $0x0
  pushl $60
80108237:	6a 3c                	push   $0x3c
  jmp alltraps
80108239:	e9 41 f6 ff ff       	jmp    8010787f <alltraps>

8010823e <vector61>:
.globl vector61
vector61:
  pushl $0
8010823e:	6a 00                	push   $0x0
  pushl $61
80108240:	6a 3d                	push   $0x3d
  jmp alltraps
80108242:	e9 38 f6 ff ff       	jmp    8010787f <alltraps>

80108247 <vector62>:
.globl vector62
vector62:
  pushl $0
80108247:	6a 00                	push   $0x0
  pushl $62
80108249:	6a 3e                	push   $0x3e
  jmp alltraps
8010824b:	e9 2f f6 ff ff       	jmp    8010787f <alltraps>

80108250 <vector63>:
.globl vector63
vector63:
  pushl $0
80108250:	6a 00                	push   $0x0
  pushl $63
80108252:	6a 3f                	push   $0x3f
  jmp alltraps
80108254:	e9 26 f6 ff ff       	jmp    8010787f <alltraps>

80108259 <vector64>:
.globl vector64
vector64:
  pushl $0
80108259:	6a 00                	push   $0x0
  pushl $64
8010825b:	6a 40                	push   $0x40
  jmp alltraps
8010825d:	e9 1d f6 ff ff       	jmp    8010787f <alltraps>

80108262 <vector65>:
.globl vector65
vector65:
  pushl $0
80108262:	6a 00                	push   $0x0
  pushl $65
80108264:	6a 41                	push   $0x41
  jmp alltraps
80108266:	e9 14 f6 ff ff       	jmp    8010787f <alltraps>

8010826b <vector66>:
.globl vector66
vector66:
  pushl $0
8010826b:	6a 00                	push   $0x0
  pushl $66
8010826d:	6a 42                	push   $0x42
  jmp alltraps
8010826f:	e9 0b f6 ff ff       	jmp    8010787f <alltraps>

80108274 <vector67>:
.globl vector67
vector67:
  pushl $0
80108274:	6a 00                	push   $0x0
  pushl $67
80108276:	6a 43                	push   $0x43
  jmp alltraps
80108278:	e9 02 f6 ff ff       	jmp    8010787f <alltraps>

8010827d <vector68>:
.globl vector68
vector68:
  pushl $0
8010827d:	6a 00                	push   $0x0
  pushl $68
8010827f:	6a 44                	push   $0x44
  jmp alltraps
80108281:	e9 f9 f5 ff ff       	jmp    8010787f <alltraps>

80108286 <vector69>:
.globl vector69
vector69:
  pushl $0
80108286:	6a 00                	push   $0x0
  pushl $69
80108288:	6a 45                	push   $0x45
  jmp alltraps
8010828a:	e9 f0 f5 ff ff       	jmp    8010787f <alltraps>

8010828f <vector70>:
.globl vector70
vector70:
  pushl $0
8010828f:	6a 00                	push   $0x0
  pushl $70
80108291:	6a 46                	push   $0x46
  jmp alltraps
80108293:	e9 e7 f5 ff ff       	jmp    8010787f <alltraps>

80108298 <vector71>:
.globl vector71
vector71:
  pushl $0
80108298:	6a 00                	push   $0x0
  pushl $71
8010829a:	6a 47                	push   $0x47
  jmp alltraps
8010829c:	e9 de f5 ff ff       	jmp    8010787f <alltraps>

801082a1 <vector72>:
.globl vector72
vector72:
  pushl $0
801082a1:	6a 00                	push   $0x0
  pushl $72
801082a3:	6a 48                	push   $0x48
  jmp alltraps
801082a5:	e9 d5 f5 ff ff       	jmp    8010787f <alltraps>

801082aa <vector73>:
.globl vector73
vector73:
  pushl $0
801082aa:	6a 00                	push   $0x0
  pushl $73
801082ac:	6a 49                	push   $0x49
  jmp alltraps
801082ae:	e9 cc f5 ff ff       	jmp    8010787f <alltraps>

801082b3 <vector74>:
.globl vector74
vector74:
  pushl $0
801082b3:	6a 00                	push   $0x0
  pushl $74
801082b5:	6a 4a                	push   $0x4a
  jmp alltraps
801082b7:	e9 c3 f5 ff ff       	jmp    8010787f <alltraps>

801082bc <vector75>:
.globl vector75
vector75:
  pushl $0
801082bc:	6a 00                	push   $0x0
  pushl $75
801082be:	6a 4b                	push   $0x4b
  jmp alltraps
801082c0:	e9 ba f5 ff ff       	jmp    8010787f <alltraps>

801082c5 <vector76>:
.globl vector76
vector76:
  pushl $0
801082c5:	6a 00                	push   $0x0
  pushl $76
801082c7:	6a 4c                	push   $0x4c
  jmp alltraps
801082c9:	e9 b1 f5 ff ff       	jmp    8010787f <alltraps>

801082ce <vector77>:
.globl vector77
vector77:
  pushl $0
801082ce:	6a 00                	push   $0x0
  pushl $77
801082d0:	6a 4d                	push   $0x4d
  jmp alltraps
801082d2:	e9 a8 f5 ff ff       	jmp    8010787f <alltraps>

801082d7 <vector78>:
.globl vector78
vector78:
  pushl $0
801082d7:	6a 00                	push   $0x0
  pushl $78
801082d9:	6a 4e                	push   $0x4e
  jmp alltraps
801082db:	e9 9f f5 ff ff       	jmp    8010787f <alltraps>

801082e0 <vector79>:
.globl vector79
vector79:
  pushl $0
801082e0:	6a 00                	push   $0x0
  pushl $79
801082e2:	6a 4f                	push   $0x4f
  jmp alltraps
801082e4:	e9 96 f5 ff ff       	jmp    8010787f <alltraps>

801082e9 <vector80>:
.globl vector80
vector80:
  pushl $0
801082e9:	6a 00                	push   $0x0
  pushl $80
801082eb:	6a 50                	push   $0x50
  jmp alltraps
801082ed:	e9 8d f5 ff ff       	jmp    8010787f <alltraps>

801082f2 <vector81>:
.globl vector81
vector81:
  pushl $0
801082f2:	6a 00                	push   $0x0
  pushl $81
801082f4:	6a 51                	push   $0x51
  jmp alltraps
801082f6:	e9 84 f5 ff ff       	jmp    8010787f <alltraps>

801082fb <vector82>:
.globl vector82
vector82:
  pushl $0
801082fb:	6a 00                	push   $0x0
  pushl $82
801082fd:	6a 52                	push   $0x52
  jmp alltraps
801082ff:	e9 7b f5 ff ff       	jmp    8010787f <alltraps>

80108304 <vector83>:
.globl vector83
vector83:
  pushl $0
80108304:	6a 00                	push   $0x0
  pushl $83
80108306:	6a 53                	push   $0x53
  jmp alltraps
80108308:	e9 72 f5 ff ff       	jmp    8010787f <alltraps>

8010830d <vector84>:
.globl vector84
vector84:
  pushl $0
8010830d:	6a 00                	push   $0x0
  pushl $84
8010830f:	6a 54                	push   $0x54
  jmp alltraps
80108311:	e9 69 f5 ff ff       	jmp    8010787f <alltraps>

80108316 <vector85>:
.globl vector85
vector85:
  pushl $0
80108316:	6a 00                	push   $0x0
  pushl $85
80108318:	6a 55                	push   $0x55
  jmp alltraps
8010831a:	e9 60 f5 ff ff       	jmp    8010787f <alltraps>

8010831f <vector86>:
.globl vector86
vector86:
  pushl $0
8010831f:	6a 00                	push   $0x0
  pushl $86
80108321:	6a 56                	push   $0x56
  jmp alltraps
80108323:	e9 57 f5 ff ff       	jmp    8010787f <alltraps>

80108328 <vector87>:
.globl vector87
vector87:
  pushl $0
80108328:	6a 00                	push   $0x0
  pushl $87
8010832a:	6a 57                	push   $0x57
  jmp alltraps
8010832c:	e9 4e f5 ff ff       	jmp    8010787f <alltraps>

80108331 <vector88>:
.globl vector88
vector88:
  pushl $0
80108331:	6a 00                	push   $0x0
  pushl $88
80108333:	6a 58                	push   $0x58
  jmp alltraps
80108335:	e9 45 f5 ff ff       	jmp    8010787f <alltraps>

8010833a <vector89>:
.globl vector89
vector89:
  pushl $0
8010833a:	6a 00                	push   $0x0
  pushl $89
8010833c:	6a 59                	push   $0x59
  jmp alltraps
8010833e:	e9 3c f5 ff ff       	jmp    8010787f <alltraps>

80108343 <vector90>:
.globl vector90
vector90:
  pushl $0
80108343:	6a 00                	push   $0x0
  pushl $90
80108345:	6a 5a                	push   $0x5a
  jmp alltraps
80108347:	e9 33 f5 ff ff       	jmp    8010787f <alltraps>

8010834c <vector91>:
.globl vector91
vector91:
  pushl $0
8010834c:	6a 00                	push   $0x0
  pushl $91
8010834e:	6a 5b                	push   $0x5b
  jmp alltraps
80108350:	e9 2a f5 ff ff       	jmp    8010787f <alltraps>

80108355 <vector92>:
.globl vector92
vector92:
  pushl $0
80108355:	6a 00                	push   $0x0
  pushl $92
80108357:	6a 5c                	push   $0x5c
  jmp alltraps
80108359:	e9 21 f5 ff ff       	jmp    8010787f <alltraps>

8010835e <vector93>:
.globl vector93
vector93:
  pushl $0
8010835e:	6a 00                	push   $0x0
  pushl $93
80108360:	6a 5d                	push   $0x5d
  jmp alltraps
80108362:	e9 18 f5 ff ff       	jmp    8010787f <alltraps>

80108367 <vector94>:
.globl vector94
vector94:
  pushl $0
80108367:	6a 00                	push   $0x0
  pushl $94
80108369:	6a 5e                	push   $0x5e
  jmp alltraps
8010836b:	e9 0f f5 ff ff       	jmp    8010787f <alltraps>

80108370 <vector95>:
.globl vector95
vector95:
  pushl $0
80108370:	6a 00                	push   $0x0
  pushl $95
80108372:	6a 5f                	push   $0x5f
  jmp alltraps
80108374:	e9 06 f5 ff ff       	jmp    8010787f <alltraps>

80108379 <vector96>:
.globl vector96
vector96:
  pushl $0
80108379:	6a 00                	push   $0x0
  pushl $96
8010837b:	6a 60                	push   $0x60
  jmp alltraps
8010837d:	e9 fd f4 ff ff       	jmp    8010787f <alltraps>

80108382 <vector97>:
.globl vector97
vector97:
  pushl $0
80108382:	6a 00                	push   $0x0
  pushl $97
80108384:	6a 61                	push   $0x61
  jmp alltraps
80108386:	e9 f4 f4 ff ff       	jmp    8010787f <alltraps>

8010838b <vector98>:
.globl vector98
vector98:
  pushl $0
8010838b:	6a 00                	push   $0x0
  pushl $98
8010838d:	6a 62                	push   $0x62
  jmp alltraps
8010838f:	e9 eb f4 ff ff       	jmp    8010787f <alltraps>

80108394 <vector99>:
.globl vector99
vector99:
  pushl $0
80108394:	6a 00                	push   $0x0
  pushl $99
80108396:	6a 63                	push   $0x63
  jmp alltraps
80108398:	e9 e2 f4 ff ff       	jmp    8010787f <alltraps>

8010839d <vector100>:
.globl vector100
vector100:
  pushl $0
8010839d:	6a 00                	push   $0x0
  pushl $100
8010839f:	6a 64                	push   $0x64
  jmp alltraps
801083a1:	e9 d9 f4 ff ff       	jmp    8010787f <alltraps>

801083a6 <vector101>:
.globl vector101
vector101:
  pushl $0
801083a6:	6a 00                	push   $0x0
  pushl $101
801083a8:	6a 65                	push   $0x65
  jmp alltraps
801083aa:	e9 d0 f4 ff ff       	jmp    8010787f <alltraps>

801083af <vector102>:
.globl vector102
vector102:
  pushl $0
801083af:	6a 00                	push   $0x0
  pushl $102
801083b1:	6a 66                	push   $0x66
  jmp alltraps
801083b3:	e9 c7 f4 ff ff       	jmp    8010787f <alltraps>

801083b8 <vector103>:
.globl vector103
vector103:
  pushl $0
801083b8:	6a 00                	push   $0x0
  pushl $103
801083ba:	6a 67                	push   $0x67
  jmp alltraps
801083bc:	e9 be f4 ff ff       	jmp    8010787f <alltraps>

801083c1 <vector104>:
.globl vector104
vector104:
  pushl $0
801083c1:	6a 00                	push   $0x0
  pushl $104
801083c3:	6a 68                	push   $0x68
  jmp alltraps
801083c5:	e9 b5 f4 ff ff       	jmp    8010787f <alltraps>

801083ca <vector105>:
.globl vector105
vector105:
  pushl $0
801083ca:	6a 00                	push   $0x0
  pushl $105
801083cc:	6a 69                	push   $0x69
  jmp alltraps
801083ce:	e9 ac f4 ff ff       	jmp    8010787f <alltraps>

801083d3 <vector106>:
.globl vector106
vector106:
  pushl $0
801083d3:	6a 00                	push   $0x0
  pushl $106
801083d5:	6a 6a                	push   $0x6a
  jmp alltraps
801083d7:	e9 a3 f4 ff ff       	jmp    8010787f <alltraps>

801083dc <vector107>:
.globl vector107
vector107:
  pushl $0
801083dc:	6a 00                	push   $0x0
  pushl $107
801083de:	6a 6b                	push   $0x6b
  jmp alltraps
801083e0:	e9 9a f4 ff ff       	jmp    8010787f <alltraps>

801083e5 <vector108>:
.globl vector108
vector108:
  pushl $0
801083e5:	6a 00                	push   $0x0
  pushl $108
801083e7:	6a 6c                	push   $0x6c
  jmp alltraps
801083e9:	e9 91 f4 ff ff       	jmp    8010787f <alltraps>

801083ee <vector109>:
.globl vector109
vector109:
  pushl $0
801083ee:	6a 00                	push   $0x0
  pushl $109
801083f0:	6a 6d                	push   $0x6d
  jmp alltraps
801083f2:	e9 88 f4 ff ff       	jmp    8010787f <alltraps>

801083f7 <vector110>:
.globl vector110
vector110:
  pushl $0
801083f7:	6a 00                	push   $0x0
  pushl $110
801083f9:	6a 6e                	push   $0x6e
  jmp alltraps
801083fb:	e9 7f f4 ff ff       	jmp    8010787f <alltraps>

80108400 <vector111>:
.globl vector111
vector111:
  pushl $0
80108400:	6a 00                	push   $0x0
  pushl $111
80108402:	6a 6f                	push   $0x6f
  jmp alltraps
80108404:	e9 76 f4 ff ff       	jmp    8010787f <alltraps>

80108409 <vector112>:
.globl vector112
vector112:
  pushl $0
80108409:	6a 00                	push   $0x0
  pushl $112
8010840b:	6a 70                	push   $0x70
  jmp alltraps
8010840d:	e9 6d f4 ff ff       	jmp    8010787f <alltraps>

80108412 <vector113>:
.globl vector113
vector113:
  pushl $0
80108412:	6a 00                	push   $0x0
  pushl $113
80108414:	6a 71                	push   $0x71
  jmp alltraps
80108416:	e9 64 f4 ff ff       	jmp    8010787f <alltraps>

8010841b <vector114>:
.globl vector114
vector114:
  pushl $0
8010841b:	6a 00                	push   $0x0
  pushl $114
8010841d:	6a 72                	push   $0x72
  jmp alltraps
8010841f:	e9 5b f4 ff ff       	jmp    8010787f <alltraps>

80108424 <vector115>:
.globl vector115
vector115:
  pushl $0
80108424:	6a 00                	push   $0x0
  pushl $115
80108426:	6a 73                	push   $0x73
  jmp alltraps
80108428:	e9 52 f4 ff ff       	jmp    8010787f <alltraps>

8010842d <vector116>:
.globl vector116
vector116:
  pushl $0
8010842d:	6a 00                	push   $0x0
  pushl $116
8010842f:	6a 74                	push   $0x74
  jmp alltraps
80108431:	e9 49 f4 ff ff       	jmp    8010787f <alltraps>

80108436 <vector117>:
.globl vector117
vector117:
  pushl $0
80108436:	6a 00                	push   $0x0
  pushl $117
80108438:	6a 75                	push   $0x75
  jmp alltraps
8010843a:	e9 40 f4 ff ff       	jmp    8010787f <alltraps>

8010843f <vector118>:
.globl vector118
vector118:
  pushl $0
8010843f:	6a 00                	push   $0x0
  pushl $118
80108441:	6a 76                	push   $0x76
  jmp alltraps
80108443:	e9 37 f4 ff ff       	jmp    8010787f <alltraps>

80108448 <vector119>:
.globl vector119
vector119:
  pushl $0
80108448:	6a 00                	push   $0x0
  pushl $119
8010844a:	6a 77                	push   $0x77
  jmp alltraps
8010844c:	e9 2e f4 ff ff       	jmp    8010787f <alltraps>

80108451 <vector120>:
.globl vector120
vector120:
  pushl $0
80108451:	6a 00                	push   $0x0
  pushl $120
80108453:	6a 78                	push   $0x78
  jmp alltraps
80108455:	e9 25 f4 ff ff       	jmp    8010787f <alltraps>

8010845a <vector121>:
.globl vector121
vector121:
  pushl $0
8010845a:	6a 00                	push   $0x0
  pushl $121
8010845c:	6a 79                	push   $0x79
  jmp alltraps
8010845e:	e9 1c f4 ff ff       	jmp    8010787f <alltraps>

80108463 <vector122>:
.globl vector122
vector122:
  pushl $0
80108463:	6a 00                	push   $0x0
  pushl $122
80108465:	6a 7a                	push   $0x7a
  jmp alltraps
80108467:	e9 13 f4 ff ff       	jmp    8010787f <alltraps>

8010846c <vector123>:
.globl vector123
vector123:
  pushl $0
8010846c:	6a 00                	push   $0x0
  pushl $123
8010846e:	6a 7b                	push   $0x7b
  jmp alltraps
80108470:	e9 0a f4 ff ff       	jmp    8010787f <alltraps>

80108475 <vector124>:
.globl vector124
vector124:
  pushl $0
80108475:	6a 00                	push   $0x0
  pushl $124
80108477:	6a 7c                	push   $0x7c
  jmp alltraps
80108479:	e9 01 f4 ff ff       	jmp    8010787f <alltraps>

8010847e <vector125>:
.globl vector125
vector125:
  pushl $0
8010847e:	6a 00                	push   $0x0
  pushl $125
80108480:	6a 7d                	push   $0x7d
  jmp alltraps
80108482:	e9 f8 f3 ff ff       	jmp    8010787f <alltraps>

80108487 <vector126>:
.globl vector126
vector126:
  pushl $0
80108487:	6a 00                	push   $0x0
  pushl $126
80108489:	6a 7e                	push   $0x7e
  jmp alltraps
8010848b:	e9 ef f3 ff ff       	jmp    8010787f <alltraps>

80108490 <vector127>:
.globl vector127
vector127:
  pushl $0
80108490:	6a 00                	push   $0x0
  pushl $127
80108492:	6a 7f                	push   $0x7f
  jmp alltraps
80108494:	e9 e6 f3 ff ff       	jmp    8010787f <alltraps>

80108499 <vector128>:
.globl vector128
vector128:
  pushl $0
80108499:	6a 00                	push   $0x0
  pushl $128
8010849b:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801084a0:	e9 da f3 ff ff       	jmp    8010787f <alltraps>

801084a5 <vector129>:
.globl vector129
vector129:
  pushl $0
801084a5:	6a 00                	push   $0x0
  pushl $129
801084a7:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801084ac:	e9 ce f3 ff ff       	jmp    8010787f <alltraps>

801084b1 <vector130>:
.globl vector130
vector130:
  pushl $0
801084b1:	6a 00                	push   $0x0
  pushl $130
801084b3:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801084b8:	e9 c2 f3 ff ff       	jmp    8010787f <alltraps>

801084bd <vector131>:
.globl vector131
vector131:
  pushl $0
801084bd:	6a 00                	push   $0x0
  pushl $131
801084bf:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801084c4:	e9 b6 f3 ff ff       	jmp    8010787f <alltraps>

801084c9 <vector132>:
.globl vector132
vector132:
  pushl $0
801084c9:	6a 00                	push   $0x0
  pushl $132
801084cb:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801084d0:	e9 aa f3 ff ff       	jmp    8010787f <alltraps>

801084d5 <vector133>:
.globl vector133
vector133:
  pushl $0
801084d5:	6a 00                	push   $0x0
  pushl $133
801084d7:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801084dc:	e9 9e f3 ff ff       	jmp    8010787f <alltraps>

801084e1 <vector134>:
.globl vector134
vector134:
  pushl $0
801084e1:	6a 00                	push   $0x0
  pushl $134
801084e3:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801084e8:	e9 92 f3 ff ff       	jmp    8010787f <alltraps>

801084ed <vector135>:
.globl vector135
vector135:
  pushl $0
801084ed:	6a 00                	push   $0x0
  pushl $135
801084ef:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801084f4:	e9 86 f3 ff ff       	jmp    8010787f <alltraps>

801084f9 <vector136>:
.globl vector136
vector136:
  pushl $0
801084f9:	6a 00                	push   $0x0
  pushl $136
801084fb:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108500:	e9 7a f3 ff ff       	jmp    8010787f <alltraps>

80108505 <vector137>:
.globl vector137
vector137:
  pushl $0
80108505:	6a 00                	push   $0x0
  pushl $137
80108507:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010850c:	e9 6e f3 ff ff       	jmp    8010787f <alltraps>

80108511 <vector138>:
.globl vector138
vector138:
  pushl $0
80108511:	6a 00                	push   $0x0
  pushl $138
80108513:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108518:	e9 62 f3 ff ff       	jmp    8010787f <alltraps>

8010851d <vector139>:
.globl vector139
vector139:
  pushl $0
8010851d:	6a 00                	push   $0x0
  pushl $139
8010851f:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108524:	e9 56 f3 ff ff       	jmp    8010787f <alltraps>

80108529 <vector140>:
.globl vector140
vector140:
  pushl $0
80108529:	6a 00                	push   $0x0
  pushl $140
8010852b:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108530:	e9 4a f3 ff ff       	jmp    8010787f <alltraps>

80108535 <vector141>:
.globl vector141
vector141:
  pushl $0
80108535:	6a 00                	push   $0x0
  pushl $141
80108537:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010853c:	e9 3e f3 ff ff       	jmp    8010787f <alltraps>

80108541 <vector142>:
.globl vector142
vector142:
  pushl $0
80108541:	6a 00                	push   $0x0
  pushl $142
80108543:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108548:	e9 32 f3 ff ff       	jmp    8010787f <alltraps>

8010854d <vector143>:
.globl vector143
vector143:
  pushl $0
8010854d:	6a 00                	push   $0x0
  pushl $143
8010854f:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108554:	e9 26 f3 ff ff       	jmp    8010787f <alltraps>

80108559 <vector144>:
.globl vector144
vector144:
  pushl $0
80108559:	6a 00                	push   $0x0
  pushl $144
8010855b:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108560:	e9 1a f3 ff ff       	jmp    8010787f <alltraps>

80108565 <vector145>:
.globl vector145
vector145:
  pushl $0
80108565:	6a 00                	push   $0x0
  pushl $145
80108567:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010856c:	e9 0e f3 ff ff       	jmp    8010787f <alltraps>

80108571 <vector146>:
.globl vector146
vector146:
  pushl $0
80108571:	6a 00                	push   $0x0
  pushl $146
80108573:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108578:	e9 02 f3 ff ff       	jmp    8010787f <alltraps>

8010857d <vector147>:
.globl vector147
vector147:
  pushl $0
8010857d:	6a 00                	push   $0x0
  pushl $147
8010857f:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108584:	e9 f6 f2 ff ff       	jmp    8010787f <alltraps>

80108589 <vector148>:
.globl vector148
vector148:
  pushl $0
80108589:	6a 00                	push   $0x0
  pushl $148
8010858b:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108590:	e9 ea f2 ff ff       	jmp    8010787f <alltraps>

80108595 <vector149>:
.globl vector149
vector149:
  pushl $0
80108595:	6a 00                	push   $0x0
  pushl $149
80108597:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010859c:	e9 de f2 ff ff       	jmp    8010787f <alltraps>

801085a1 <vector150>:
.globl vector150
vector150:
  pushl $0
801085a1:	6a 00                	push   $0x0
  pushl $150
801085a3:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801085a8:	e9 d2 f2 ff ff       	jmp    8010787f <alltraps>

801085ad <vector151>:
.globl vector151
vector151:
  pushl $0
801085ad:	6a 00                	push   $0x0
  pushl $151
801085af:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801085b4:	e9 c6 f2 ff ff       	jmp    8010787f <alltraps>

801085b9 <vector152>:
.globl vector152
vector152:
  pushl $0
801085b9:	6a 00                	push   $0x0
  pushl $152
801085bb:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801085c0:	e9 ba f2 ff ff       	jmp    8010787f <alltraps>

801085c5 <vector153>:
.globl vector153
vector153:
  pushl $0
801085c5:	6a 00                	push   $0x0
  pushl $153
801085c7:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801085cc:	e9 ae f2 ff ff       	jmp    8010787f <alltraps>

801085d1 <vector154>:
.globl vector154
vector154:
  pushl $0
801085d1:	6a 00                	push   $0x0
  pushl $154
801085d3:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801085d8:	e9 a2 f2 ff ff       	jmp    8010787f <alltraps>

801085dd <vector155>:
.globl vector155
vector155:
  pushl $0
801085dd:	6a 00                	push   $0x0
  pushl $155
801085df:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801085e4:	e9 96 f2 ff ff       	jmp    8010787f <alltraps>

801085e9 <vector156>:
.globl vector156
vector156:
  pushl $0
801085e9:	6a 00                	push   $0x0
  pushl $156
801085eb:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801085f0:	e9 8a f2 ff ff       	jmp    8010787f <alltraps>

801085f5 <vector157>:
.globl vector157
vector157:
  pushl $0
801085f5:	6a 00                	push   $0x0
  pushl $157
801085f7:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801085fc:	e9 7e f2 ff ff       	jmp    8010787f <alltraps>

80108601 <vector158>:
.globl vector158
vector158:
  pushl $0
80108601:	6a 00                	push   $0x0
  pushl $158
80108603:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108608:	e9 72 f2 ff ff       	jmp    8010787f <alltraps>

8010860d <vector159>:
.globl vector159
vector159:
  pushl $0
8010860d:	6a 00                	push   $0x0
  pushl $159
8010860f:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108614:	e9 66 f2 ff ff       	jmp    8010787f <alltraps>

80108619 <vector160>:
.globl vector160
vector160:
  pushl $0
80108619:	6a 00                	push   $0x0
  pushl $160
8010861b:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108620:	e9 5a f2 ff ff       	jmp    8010787f <alltraps>

80108625 <vector161>:
.globl vector161
vector161:
  pushl $0
80108625:	6a 00                	push   $0x0
  pushl $161
80108627:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010862c:	e9 4e f2 ff ff       	jmp    8010787f <alltraps>

80108631 <vector162>:
.globl vector162
vector162:
  pushl $0
80108631:	6a 00                	push   $0x0
  pushl $162
80108633:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108638:	e9 42 f2 ff ff       	jmp    8010787f <alltraps>

8010863d <vector163>:
.globl vector163
vector163:
  pushl $0
8010863d:	6a 00                	push   $0x0
  pushl $163
8010863f:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108644:	e9 36 f2 ff ff       	jmp    8010787f <alltraps>

80108649 <vector164>:
.globl vector164
vector164:
  pushl $0
80108649:	6a 00                	push   $0x0
  pushl $164
8010864b:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108650:	e9 2a f2 ff ff       	jmp    8010787f <alltraps>

80108655 <vector165>:
.globl vector165
vector165:
  pushl $0
80108655:	6a 00                	push   $0x0
  pushl $165
80108657:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010865c:	e9 1e f2 ff ff       	jmp    8010787f <alltraps>

80108661 <vector166>:
.globl vector166
vector166:
  pushl $0
80108661:	6a 00                	push   $0x0
  pushl $166
80108663:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108668:	e9 12 f2 ff ff       	jmp    8010787f <alltraps>

8010866d <vector167>:
.globl vector167
vector167:
  pushl $0
8010866d:	6a 00                	push   $0x0
  pushl $167
8010866f:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108674:	e9 06 f2 ff ff       	jmp    8010787f <alltraps>

80108679 <vector168>:
.globl vector168
vector168:
  pushl $0
80108679:	6a 00                	push   $0x0
  pushl $168
8010867b:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108680:	e9 fa f1 ff ff       	jmp    8010787f <alltraps>

80108685 <vector169>:
.globl vector169
vector169:
  pushl $0
80108685:	6a 00                	push   $0x0
  pushl $169
80108687:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010868c:	e9 ee f1 ff ff       	jmp    8010787f <alltraps>

80108691 <vector170>:
.globl vector170
vector170:
  pushl $0
80108691:	6a 00                	push   $0x0
  pushl $170
80108693:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108698:	e9 e2 f1 ff ff       	jmp    8010787f <alltraps>

8010869d <vector171>:
.globl vector171
vector171:
  pushl $0
8010869d:	6a 00                	push   $0x0
  pushl $171
8010869f:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801086a4:	e9 d6 f1 ff ff       	jmp    8010787f <alltraps>

801086a9 <vector172>:
.globl vector172
vector172:
  pushl $0
801086a9:	6a 00                	push   $0x0
  pushl $172
801086ab:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801086b0:	e9 ca f1 ff ff       	jmp    8010787f <alltraps>

801086b5 <vector173>:
.globl vector173
vector173:
  pushl $0
801086b5:	6a 00                	push   $0x0
  pushl $173
801086b7:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801086bc:	e9 be f1 ff ff       	jmp    8010787f <alltraps>

801086c1 <vector174>:
.globl vector174
vector174:
  pushl $0
801086c1:	6a 00                	push   $0x0
  pushl $174
801086c3:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801086c8:	e9 b2 f1 ff ff       	jmp    8010787f <alltraps>

801086cd <vector175>:
.globl vector175
vector175:
  pushl $0
801086cd:	6a 00                	push   $0x0
  pushl $175
801086cf:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801086d4:	e9 a6 f1 ff ff       	jmp    8010787f <alltraps>

801086d9 <vector176>:
.globl vector176
vector176:
  pushl $0
801086d9:	6a 00                	push   $0x0
  pushl $176
801086db:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801086e0:	e9 9a f1 ff ff       	jmp    8010787f <alltraps>

801086e5 <vector177>:
.globl vector177
vector177:
  pushl $0
801086e5:	6a 00                	push   $0x0
  pushl $177
801086e7:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801086ec:	e9 8e f1 ff ff       	jmp    8010787f <alltraps>

801086f1 <vector178>:
.globl vector178
vector178:
  pushl $0
801086f1:	6a 00                	push   $0x0
  pushl $178
801086f3:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801086f8:	e9 82 f1 ff ff       	jmp    8010787f <alltraps>

801086fd <vector179>:
.globl vector179
vector179:
  pushl $0
801086fd:	6a 00                	push   $0x0
  pushl $179
801086ff:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108704:	e9 76 f1 ff ff       	jmp    8010787f <alltraps>

80108709 <vector180>:
.globl vector180
vector180:
  pushl $0
80108709:	6a 00                	push   $0x0
  pushl $180
8010870b:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108710:	e9 6a f1 ff ff       	jmp    8010787f <alltraps>

80108715 <vector181>:
.globl vector181
vector181:
  pushl $0
80108715:	6a 00                	push   $0x0
  pushl $181
80108717:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010871c:	e9 5e f1 ff ff       	jmp    8010787f <alltraps>

80108721 <vector182>:
.globl vector182
vector182:
  pushl $0
80108721:	6a 00                	push   $0x0
  pushl $182
80108723:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108728:	e9 52 f1 ff ff       	jmp    8010787f <alltraps>

8010872d <vector183>:
.globl vector183
vector183:
  pushl $0
8010872d:	6a 00                	push   $0x0
  pushl $183
8010872f:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108734:	e9 46 f1 ff ff       	jmp    8010787f <alltraps>

80108739 <vector184>:
.globl vector184
vector184:
  pushl $0
80108739:	6a 00                	push   $0x0
  pushl $184
8010873b:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108740:	e9 3a f1 ff ff       	jmp    8010787f <alltraps>

80108745 <vector185>:
.globl vector185
vector185:
  pushl $0
80108745:	6a 00                	push   $0x0
  pushl $185
80108747:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010874c:	e9 2e f1 ff ff       	jmp    8010787f <alltraps>

80108751 <vector186>:
.globl vector186
vector186:
  pushl $0
80108751:	6a 00                	push   $0x0
  pushl $186
80108753:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108758:	e9 22 f1 ff ff       	jmp    8010787f <alltraps>

8010875d <vector187>:
.globl vector187
vector187:
  pushl $0
8010875d:	6a 00                	push   $0x0
  pushl $187
8010875f:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108764:	e9 16 f1 ff ff       	jmp    8010787f <alltraps>

80108769 <vector188>:
.globl vector188
vector188:
  pushl $0
80108769:	6a 00                	push   $0x0
  pushl $188
8010876b:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108770:	e9 0a f1 ff ff       	jmp    8010787f <alltraps>

80108775 <vector189>:
.globl vector189
vector189:
  pushl $0
80108775:	6a 00                	push   $0x0
  pushl $189
80108777:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010877c:	e9 fe f0 ff ff       	jmp    8010787f <alltraps>

80108781 <vector190>:
.globl vector190
vector190:
  pushl $0
80108781:	6a 00                	push   $0x0
  pushl $190
80108783:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108788:	e9 f2 f0 ff ff       	jmp    8010787f <alltraps>

8010878d <vector191>:
.globl vector191
vector191:
  pushl $0
8010878d:	6a 00                	push   $0x0
  pushl $191
8010878f:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108794:	e9 e6 f0 ff ff       	jmp    8010787f <alltraps>

80108799 <vector192>:
.globl vector192
vector192:
  pushl $0
80108799:	6a 00                	push   $0x0
  pushl $192
8010879b:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801087a0:	e9 da f0 ff ff       	jmp    8010787f <alltraps>

801087a5 <vector193>:
.globl vector193
vector193:
  pushl $0
801087a5:	6a 00                	push   $0x0
  pushl $193
801087a7:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801087ac:	e9 ce f0 ff ff       	jmp    8010787f <alltraps>

801087b1 <vector194>:
.globl vector194
vector194:
  pushl $0
801087b1:	6a 00                	push   $0x0
  pushl $194
801087b3:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801087b8:	e9 c2 f0 ff ff       	jmp    8010787f <alltraps>

801087bd <vector195>:
.globl vector195
vector195:
  pushl $0
801087bd:	6a 00                	push   $0x0
  pushl $195
801087bf:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801087c4:	e9 b6 f0 ff ff       	jmp    8010787f <alltraps>

801087c9 <vector196>:
.globl vector196
vector196:
  pushl $0
801087c9:	6a 00                	push   $0x0
  pushl $196
801087cb:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801087d0:	e9 aa f0 ff ff       	jmp    8010787f <alltraps>

801087d5 <vector197>:
.globl vector197
vector197:
  pushl $0
801087d5:	6a 00                	push   $0x0
  pushl $197
801087d7:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801087dc:	e9 9e f0 ff ff       	jmp    8010787f <alltraps>

801087e1 <vector198>:
.globl vector198
vector198:
  pushl $0
801087e1:	6a 00                	push   $0x0
  pushl $198
801087e3:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801087e8:	e9 92 f0 ff ff       	jmp    8010787f <alltraps>

801087ed <vector199>:
.globl vector199
vector199:
  pushl $0
801087ed:	6a 00                	push   $0x0
  pushl $199
801087ef:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801087f4:	e9 86 f0 ff ff       	jmp    8010787f <alltraps>

801087f9 <vector200>:
.globl vector200
vector200:
  pushl $0
801087f9:	6a 00                	push   $0x0
  pushl $200
801087fb:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108800:	e9 7a f0 ff ff       	jmp    8010787f <alltraps>

80108805 <vector201>:
.globl vector201
vector201:
  pushl $0
80108805:	6a 00                	push   $0x0
  pushl $201
80108807:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010880c:	e9 6e f0 ff ff       	jmp    8010787f <alltraps>

80108811 <vector202>:
.globl vector202
vector202:
  pushl $0
80108811:	6a 00                	push   $0x0
  pushl $202
80108813:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108818:	e9 62 f0 ff ff       	jmp    8010787f <alltraps>

8010881d <vector203>:
.globl vector203
vector203:
  pushl $0
8010881d:	6a 00                	push   $0x0
  pushl $203
8010881f:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108824:	e9 56 f0 ff ff       	jmp    8010787f <alltraps>

80108829 <vector204>:
.globl vector204
vector204:
  pushl $0
80108829:	6a 00                	push   $0x0
  pushl $204
8010882b:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108830:	e9 4a f0 ff ff       	jmp    8010787f <alltraps>

80108835 <vector205>:
.globl vector205
vector205:
  pushl $0
80108835:	6a 00                	push   $0x0
  pushl $205
80108837:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010883c:	e9 3e f0 ff ff       	jmp    8010787f <alltraps>

80108841 <vector206>:
.globl vector206
vector206:
  pushl $0
80108841:	6a 00                	push   $0x0
  pushl $206
80108843:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108848:	e9 32 f0 ff ff       	jmp    8010787f <alltraps>

8010884d <vector207>:
.globl vector207
vector207:
  pushl $0
8010884d:	6a 00                	push   $0x0
  pushl $207
8010884f:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108854:	e9 26 f0 ff ff       	jmp    8010787f <alltraps>

80108859 <vector208>:
.globl vector208
vector208:
  pushl $0
80108859:	6a 00                	push   $0x0
  pushl $208
8010885b:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108860:	e9 1a f0 ff ff       	jmp    8010787f <alltraps>

80108865 <vector209>:
.globl vector209
vector209:
  pushl $0
80108865:	6a 00                	push   $0x0
  pushl $209
80108867:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010886c:	e9 0e f0 ff ff       	jmp    8010787f <alltraps>

80108871 <vector210>:
.globl vector210
vector210:
  pushl $0
80108871:	6a 00                	push   $0x0
  pushl $210
80108873:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108878:	e9 02 f0 ff ff       	jmp    8010787f <alltraps>

8010887d <vector211>:
.globl vector211
vector211:
  pushl $0
8010887d:	6a 00                	push   $0x0
  pushl $211
8010887f:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108884:	e9 f6 ef ff ff       	jmp    8010787f <alltraps>

80108889 <vector212>:
.globl vector212
vector212:
  pushl $0
80108889:	6a 00                	push   $0x0
  pushl $212
8010888b:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108890:	e9 ea ef ff ff       	jmp    8010787f <alltraps>

80108895 <vector213>:
.globl vector213
vector213:
  pushl $0
80108895:	6a 00                	push   $0x0
  pushl $213
80108897:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010889c:	e9 de ef ff ff       	jmp    8010787f <alltraps>

801088a1 <vector214>:
.globl vector214
vector214:
  pushl $0
801088a1:	6a 00                	push   $0x0
  pushl $214
801088a3:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801088a8:	e9 d2 ef ff ff       	jmp    8010787f <alltraps>

801088ad <vector215>:
.globl vector215
vector215:
  pushl $0
801088ad:	6a 00                	push   $0x0
  pushl $215
801088af:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801088b4:	e9 c6 ef ff ff       	jmp    8010787f <alltraps>

801088b9 <vector216>:
.globl vector216
vector216:
  pushl $0
801088b9:	6a 00                	push   $0x0
  pushl $216
801088bb:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801088c0:	e9 ba ef ff ff       	jmp    8010787f <alltraps>

801088c5 <vector217>:
.globl vector217
vector217:
  pushl $0
801088c5:	6a 00                	push   $0x0
  pushl $217
801088c7:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801088cc:	e9 ae ef ff ff       	jmp    8010787f <alltraps>

801088d1 <vector218>:
.globl vector218
vector218:
  pushl $0
801088d1:	6a 00                	push   $0x0
  pushl $218
801088d3:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801088d8:	e9 a2 ef ff ff       	jmp    8010787f <alltraps>

801088dd <vector219>:
.globl vector219
vector219:
  pushl $0
801088dd:	6a 00                	push   $0x0
  pushl $219
801088df:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801088e4:	e9 96 ef ff ff       	jmp    8010787f <alltraps>

801088e9 <vector220>:
.globl vector220
vector220:
  pushl $0
801088e9:	6a 00                	push   $0x0
  pushl $220
801088eb:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801088f0:	e9 8a ef ff ff       	jmp    8010787f <alltraps>

801088f5 <vector221>:
.globl vector221
vector221:
  pushl $0
801088f5:	6a 00                	push   $0x0
  pushl $221
801088f7:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801088fc:	e9 7e ef ff ff       	jmp    8010787f <alltraps>

80108901 <vector222>:
.globl vector222
vector222:
  pushl $0
80108901:	6a 00                	push   $0x0
  pushl $222
80108903:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108908:	e9 72 ef ff ff       	jmp    8010787f <alltraps>

8010890d <vector223>:
.globl vector223
vector223:
  pushl $0
8010890d:	6a 00                	push   $0x0
  pushl $223
8010890f:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108914:	e9 66 ef ff ff       	jmp    8010787f <alltraps>

80108919 <vector224>:
.globl vector224
vector224:
  pushl $0
80108919:	6a 00                	push   $0x0
  pushl $224
8010891b:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108920:	e9 5a ef ff ff       	jmp    8010787f <alltraps>

80108925 <vector225>:
.globl vector225
vector225:
  pushl $0
80108925:	6a 00                	push   $0x0
  pushl $225
80108927:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010892c:	e9 4e ef ff ff       	jmp    8010787f <alltraps>

80108931 <vector226>:
.globl vector226
vector226:
  pushl $0
80108931:	6a 00                	push   $0x0
  pushl $226
80108933:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108938:	e9 42 ef ff ff       	jmp    8010787f <alltraps>

8010893d <vector227>:
.globl vector227
vector227:
  pushl $0
8010893d:	6a 00                	push   $0x0
  pushl $227
8010893f:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108944:	e9 36 ef ff ff       	jmp    8010787f <alltraps>

80108949 <vector228>:
.globl vector228
vector228:
  pushl $0
80108949:	6a 00                	push   $0x0
  pushl $228
8010894b:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108950:	e9 2a ef ff ff       	jmp    8010787f <alltraps>

80108955 <vector229>:
.globl vector229
vector229:
  pushl $0
80108955:	6a 00                	push   $0x0
  pushl $229
80108957:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010895c:	e9 1e ef ff ff       	jmp    8010787f <alltraps>

80108961 <vector230>:
.globl vector230
vector230:
  pushl $0
80108961:	6a 00                	push   $0x0
  pushl $230
80108963:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108968:	e9 12 ef ff ff       	jmp    8010787f <alltraps>

8010896d <vector231>:
.globl vector231
vector231:
  pushl $0
8010896d:	6a 00                	push   $0x0
  pushl $231
8010896f:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108974:	e9 06 ef ff ff       	jmp    8010787f <alltraps>

80108979 <vector232>:
.globl vector232
vector232:
  pushl $0
80108979:	6a 00                	push   $0x0
  pushl $232
8010897b:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108980:	e9 fa ee ff ff       	jmp    8010787f <alltraps>

80108985 <vector233>:
.globl vector233
vector233:
  pushl $0
80108985:	6a 00                	push   $0x0
  pushl $233
80108987:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010898c:	e9 ee ee ff ff       	jmp    8010787f <alltraps>

80108991 <vector234>:
.globl vector234
vector234:
  pushl $0
80108991:	6a 00                	push   $0x0
  pushl $234
80108993:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80108998:	e9 e2 ee ff ff       	jmp    8010787f <alltraps>

8010899d <vector235>:
.globl vector235
vector235:
  pushl $0
8010899d:	6a 00                	push   $0x0
  pushl $235
8010899f:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801089a4:	e9 d6 ee ff ff       	jmp    8010787f <alltraps>

801089a9 <vector236>:
.globl vector236
vector236:
  pushl $0
801089a9:	6a 00                	push   $0x0
  pushl $236
801089ab:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801089b0:	e9 ca ee ff ff       	jmp    8010787f <alltraps>

801089b5 <vector237>:
.globl vector237
vector237:
  pushl $0
801089b5:	6a 00                	push   $0x0
  pushl $237
801089b7:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801089bc:	e9 be ee ff ff       	jmp    8010787f <alltraps>

801089c1 <vector238>:
.globl vector238
vector238:
  pushl $0
801089c1:	6a 00                	push   $0x0
  pushl $238
801089c3:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801089c8:	e9 b2 ee ff ff       	jmp    8010787f <alltraps>

801089cd <vector239>:
.globl vector239
vector239:
  pushl $0
801089cd:	6a 00                	push   $0x0
  pushl $239
801089cf:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801089d4:	e9 a6 ee ff ff       	jmp    8010787f <alltraps>

801089d9 <vector240>:
.globl vector240
vector240:
  pushl $0
801089d9:	6a 00                	push   $0x0
  pushl $240
801089db:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801089e0:	e9 9a ee ff ff       	jmp    8010787f <alltraps>

801089e5 <vector241>:
.globl vector241
vector241:
  pushl $0
801089e5:	6a 00                	push   $0x0
  pushl $241
801089e7:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801089ec:	e9 8e ee ff ff       	jmp    8010787f <alltraps>

801089f1 <vector242>:
.globl vector242
vector242:
  pushl $0
801089f1:	6a 00                	push   $0x0
  pushl $242
801089f3:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801089f8:	e9 82 ee ff ff       	jmp    8010787f <alltraps>

801089fd <vector243>:
.globl vector243
vector243:
  pushl $0
801089fd:	6a 00                	push   $0x0
  pushl $243
801089ff:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108a04:	e9 76 ee ff ff       	jmp    8010787f <alltraps>

80108a09 <vector244>:
.globl vector244
vector244:
  pushl $0
80108a09:	6a 00                	push   $0x0
  pushl $244
80108a0b:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108a10:	e9 6a ee ff ff       	jmp    8010787f <alltraps>

80108a15 <vector245>:
.globl vector245
vector245:
  pushl $0
80108a15:	6a 00                	push   $0x0
  pushl $245
80108a17:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108a1c:	e9 5e ee ff ff       	jmp    8010787f <alltraps>

80108a21 <vector246>:
.globl vector246
vector246:
  pushl $0
80108a21:	6a 00                	push   $0x0
  pushl $246
80108a23:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108a28:	e9 52 ee ff ff       	jmp    8010787f <alltraps>

80108a2d <vector247>:
.globl vector247
vector247:
  pushl $0
80108a2d:	6a 00                	push   $0x0
  pushl $247
80108a2f:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108a34:	e9 46 ee ff ff       	jmp    8010787f <alltraps>

80108a39 <vector248>:
.globl vector248
vector248:
  pushl $0
80108a39:	6a 00                	push   $0x0
  pushl $248
80108a3b:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108a40:	e9 3a ee ff ff       	jmp    8010787f <alltraps>

80108a45 <vector249>:
.globl vector249
vector249:
  pushl $0
80108a45:	6a 00                	push   $0x0
  pushl $249
80108a47:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108a4c:	e9 2e ee ff ff       	jmp    8010787f <alltraps>

80108a51 <vector250>:
.globl vector250
vector250:
  pushl $0
80108a51:	6a 00                	push   $0x0
  pushl $250
80108a53:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108a58:	e9 22 ee ff ff       	jmp    8010787f <alltraps>

80108a5d <vector251>:
.globl vector251
vector251:
  pushl $0
80108a5d:	6a 00                	push   $0x0
  pushl $251
80108a5f:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108a64:	e9 16 ee ff ff       	jmp    8010787f <alltraps>

80108a69 <vector252>:
.globl vector252
vector252:
  pushl $0
80108a69:	6a 00                	push   $0x0
  pushl $252
80108a6b:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108a70:	e9 0a ee ff ff       	jmp    8010787f <alltraps>

80108a75 <vector253>:
.globl vector253
vector253:
  pushl $0
80108a75:	6a 00                	push   $0x0
  pushl $253
80108a77:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80108a7c:	e9 fe ed ff ff       	jmp    8010787f <alltraps>

80108a81 <vector254>:
.globl vector254
vector254:
  pushl $0
80108a81:	6a 00                	push   $0x0
  pushl $254
80108a83:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108a88:	e9 f2 ed ff ff       	jmp    8010787f <alltraps>

80108a8d <vector255>:
.globl vector255
vector255:
  pushl $0
80108a8d:	6a 00                	push   $0x0
  pushl $255
80108a8f:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108a94:	e9 e6 ed ff ff       	jmp    8010787f <alltraps>

80108a99 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80108a99:	55                   	push   %ebp
80108a9a:	89 e5                	mov    %esp,%ebp
80108a9c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108aa2:	83 e8 01             	sub    $0x1,%eax
80108aa5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80108aac:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80108ab3:	c1 e8 10             	shr    $0x10,%eax
80108ab6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108aba:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108abd:	0f 01 10             	lgdtl  (%eax)
}
80108ac0:	c9                   	leave  
80108ac1:	c3                   	ret    

80108ac2 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108ac2:	55                   	push   %ebp
80108ac3:	89 e5                	mov    %esp,%ebp
80108ac5:	83 ec 04             	sub    $0x4,%esp
80108ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80108acb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108acf:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108ad3:	0f 00 d8             	ltr    %ax
}
80108ad6:	c9                   	leave  
80108ad7:	c3                   	ret    

80108ad8 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108ad8:	55                   	push   %ebp
80108ad9:	89 e5                	mov    %esp,%ebp
80108adb:	83 ec 04             	sub    $0x4,%esp
80108ade:	8b 45 08             	mov    0x8(%ebp),%eax
80108ae1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108ae5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108ae9:	8e e8                	mov    %eax,%gs
}
80108aeb:	c9                   	leave  
80108aec:	c3                   	ret    

80108aed <lcr3>:
  return val;
}

static inline void
lcr3(uint val)
{
80108aed:	55                   	push   %ebp
80108aee:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108af0:	8b 45 08             	mov    0x8(%ebp),%eax
80108af3:	0f 22 d8             	mov    %eax,%cr3
}
80108af6:	5d                   	pop    %ebp
80108af7:	c3                   	ret    

80108af8 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108af8:	55                   	push   %ebp
80108af9:	89 e5                	mov    %esp,%ebp
80108afb:	53                   	push   %ebx
80108afc:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108aff:	e8 d1 a4 ff ff       	call   80102fd5 <cpunum>
80108b04:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108b0a:	05 40 58 11 80       	add    $0x80115840,%eax
80108b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b15:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b1e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b27:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b2e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108b32:	83 e2 f0             	and    $0xfffffff0,%edx
80108b35:	83 ca 0a             	or     $0xa,%edx
80108b38:	88 50 7d             	mov    %dl,0x7d(%eax)
80108b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108b42:	83 ca 10             	or     $0x10,%edx
80108b45:	88 50 7d             	mov    %dl,0x7d(%eax)
80108b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b4b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108b4f:	83 e2 9f             	and    $0xffffff9f,%edx
80108b52:	88 50 7d             	mov    %dl,0x7d(%eax)
80108b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b58:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108b5c:	83 ca 80             	or     $0xffffff80,%edx
80108b5f:	88 50 7d             	mov    %dl,0x7d(%eax)
80108b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b65:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108b69:	83 ca 0f             	or     $0xf,%edx
80108b6c:	88 50 7e             	mov    %dl,0x7e(%eax)
80108b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b72:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108b76:	83 e2 ef             	and    $0xffffffef,%edx
80108b79:	88 50 7e             	mov    %dl,0x7e(%eax)
80108b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b7f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108b83:	83 e2 df             	and    $0xffffffdf,%edx
80108b86:	88 50 7e             	mov    %dl,0x7e(%eax)
80108b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b8c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108b90:	83 ca 40             	or     $0x40,%edx
80108b93:	88 50 7e             	mov    %dl,0x7e(%eax)
80108b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b99:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108b9d:	83 ca 80             	or     $0xffffff80,%edx
80108ba0:	88 50 7e             	mov    %dl,0x7e(%eax)
80108ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ba6:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bad:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108bb4:	ff ff 
80108bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bb9:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108bc0:	00 00 
80108bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc5:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bcf:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108bd6:	83 e2 f0             	and    $0xfffffff0,%edx
80108bd9:	83 ca 02             	or     $0x2,%edx
80108bdc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108bec:	83 ca 10             	or     $0x10,%edx
80108bef:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bf8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108bff:	83 e2 9f             	and    $0xffffff9f,%edx
80108c02:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c0b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108c12:	83 ca 80             	or     $0xffffff80,%edx
80108c15:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c1e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108c25:	83 ca 0f             	or     $0xf,%edx
80108c28:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c31:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108c38:	83 e2 ef             	and    $0xffffffef,%edx
80108c3b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c44:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108c4b:	83 e2 df             	and    $0xffffffdf,%edx
80108c4e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c57:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108c5e:	83 ca 40             	or     $0x40,%edx
80108c61:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c6a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108c71:	83 ca 80             	or     $0xffffff80,%edx
80108c74:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c7d:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c87:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108c8e:	ff ff 
80108c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c93:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108c9a:	00 00 
80108c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9f:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ca9:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108cb0:	83 e2 f0             	and    $0xfffffff0,%edx
80108cb3:	83 ca 0a             	or     $0xa,%edx
80108cb6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cbf:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108cc6:	83 ca 10             	or     $0x10,%edx
80108cc9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108cd9:	83 ca 60             	or     $0x60,%edx
80108cdc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108cec:	83 ca 80             	or     $0xffffff80,%edx
80108cef:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cf8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108cff:	83 ca 0f             	or     $0xf,%edx
80108d02:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d0b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108d12:	83 e2 ef             	and    $0xffffffef,%edx
80108d15:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d1e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108d25:	83 e2 df             	and    $0xffffffdf,%edx
80108d28:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d31:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108d38:	83 ca 40             	or     $0x40,%edx
80108d3b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d44:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108d4b:	83 ca 80             	or     $0xffffff80,%edx
80108d4e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d57:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d61:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108d68:	ff ff 
80108d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d6d:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108d74:	00 00 
80108d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d79:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d83:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108d8a:	83 e2 f0             	and    $0xfffffff0,%edx
80108d8d:	83 ca 02             	or     $0x2,%edx
80108d90:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d99:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108da0:	83 ca 10             	or     $0x10,%edx
80108da3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dac:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108db3:	83 ca 60             	or     $0x60,%edx
80108db6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dbf:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108dc6:	83 ca 80             	or     $0xffffff80,%edx
80108dc9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dd2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108dd9:	83 ca 0f             	or     $0xf,%edx
80108ddc:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108dec:	83 e2 ef             	and    $0xffffffef,%edx
80108def:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108df8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108dff:	83 e2 df             	and    $0xffffffdf,%edx
80108e02:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e0b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108e12:	83 ca 40             	or     $0x40,%edx
80108e15:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e1e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108e25:	83 ca 80             	or     $0xffffff80,%edx
80108e28:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e31:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e3b:	05 b4 00 00 00       	add    $0xb4,%eax
80108e40:	89 c3                	mov    %eax,%ebx
80108e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e45:	05 b4 00 00 00       	add    $0xb4,%eax
80108e4a:	c1 e8 10             	shr    $0x10,%eax
80108e4d:	89 c1                	mov    %eax,%ecx
80108e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e52:	05 b4 00 00 00       	add    $0xb4,%eax
80108e57:	c1 e8 18             	shr    $0x18,%eax
80108e5a:	89 c2                	mov    %eax,%edx
80108e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e5f:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108e66:	00 00 
80108e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e6b:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e75:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80108e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e7e:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108e85:	83 e1 f0             	and    $0xfffffff0,%ecx
80108e88:	83 c9 02             	or     $0x2,%ecx
80108e8b:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e94:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108e9b:	83 c9 10             	or     $0x10,%ecx
80108e9e:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ea7:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108eae:	83 e1 9f             	and    $0xffffff9f,%ecx
80108eb1:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eba:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80108ec1:	83 c9 80             	or     $0xffffff80,%ecx
80108ec4:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ecd:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108ed4:	83 e1 f0             	and    $0xfffffff0,%ecx
80108ed7:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ee0:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108ee7:	83 e1 ef             	and    $0xffffffef,%ecx
80108eea:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ef3:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108efa:	83 e1 df             	and    $0xffffffdf,%ecx
80108efd:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f06:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108f0d:	83 c9 40             	or     $0x40,%ecx
80108f10:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f19:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108f20:	83 c9 80             	or     $0xffffff80,%ecx
80108f23:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f2c:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f35:	83 c0 70             	add    $0x70,%eax
80108f38:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80108f3f:	00 
80108f40:	89 04 24             	mov    %eax,(%esp)
80108f43:	e8 51 fb ff ff       	call   80108a99 <lgdt>
  loadgs(SEG_KCPU << 3);
80108f48:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80108f4f:	e8 84 fb ff ff       	call   80108ad8 <loadgs>

  // Initialize cpu-local storage.
  cpu = c;
80108f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f57:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108f5d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108f64:	00 00 00 00 
}
80108f68:	83 c4 24             	add    $0x24,%esp
80108f6b:	5b                   	pop    %ebx
80108f6c:	5d                   	pop    %ebp
80108f6d:	c3                   	ret    

80108f6e <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108f6e:	55                   	push   %ebp
80108f6f:	89 e5                	mov    %esp,%ebp
80108f71:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108f74:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f77:	c1 e8 16             	shr    $0x16,%eax
80108f7a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108f81:	8b 45 08             	mov    0x8(%ebp),%eax
80108f84:	01 d0                	add    %edx,%eax
80108f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f8c:	8b 00                	mov    (%eax),%eax
80108f8e:	83 e0 01             	and    $0x1,%eax
80108f91:	85 c0                	test   %eax,%eax
80108f93:	74 14                	je     80108fa9 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f98:	8b 00                	mov    (%eax),%eax
80108f9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f9f:	05 00 00 00 80       	add    $0x80000000,%eax
80108fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108fa7:	eb 48                	jmp    80108ff1 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108fa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108fad:	74 0e                	je     80108fbd <walkpgdir+0x4f>
80108faf:	e8 8b 9c ff ff       	call   80102c3f <kalloc>
80108fb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108fb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108fbb:	75 07                	jne    80108fc4 <walkpgdir+0x56>
      return 0;
80108fbd:	b8 00 00 00 00       	mov    $0x0,%eax
80108fc2:	eb 44                	jmp    80109008 <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108fc4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108fcb:	00 
80108fcc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108fd3:	00 
80108fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fd7:	89 04 24             	mov    %eax,(%esp)
80108fda:	e8 9a d4 ff ff       	call   80106479 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80108fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fe2:	05 00 00 00 80       	add    $0x80000000,%eax
80108fe7:	83 c8 07             	or     $0x7,%eax
80108fea:	89 c2                	mov    %eax,%edx
80108fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fef:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ff4:	c1 e8 0c             	shr    $0xc,%eax
80108ff7:	25 ff 03 00 00       	and    $0x3ff,%eax
80108ffc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109006:	01 d0                	add    %edx,%eax
}
80109008:	c9                   	leave  
80109009:	c3                   	ret    

8010900a <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010900a:	55                   	push   %ebp
8010900b:	89 e5                	mov    %esp,%ebp
8010900d:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80109010:	8b 45 0c             	mov    0xc(%ebp),%eax
80109013:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109018:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010901b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010901e:	8b 45 10             	mov    0x10(%ebp),%eax
80109021:	01 d0                	add    %edx,%eax
80109023:	83 e8 01             	sub    $0x1,%eax
80109026:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010902b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010902e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80109035:	00 
80109036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109039:	89 44 24 04          	mov    %eax,0x4(%esp)
8010903d:	8b 45 08             	mov    0x8(%ebp),%eax
80109040:	89 04 24             	mov    %eax,(%esp)
80109043:	e8 26 ff ff ff       	call   80108f6e <walkpgdir>
80109048:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010904b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010904f:	75 07                	jne    80109058 <mappages+0x4e>
      return -1;
80109051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109056:	eb 48                	jmp    801090a0 <mappages+0x96>
    if(*pte & PTE_P)
80109058:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010905b:	8b 00                	mov    (%eax),%eax
8010905d:	83 e0 01             	and    $0x1,%eax
80109060:	85 c0                	test   %eax,%eax
80109062:	74 0c                	je     80109070 <mappages+0x66>
      panic("remap");
80109064:	c7 04 24 80 a0 10 80 	movl   $0x8010a080,(%esp)
8010906b:	e8 f2 74 ff ff       	call   80100562 <panic>
    *pte = pa | perm | PTE_P;
80109070:	8b 45 18             	mov    0x18(%ebp),%eax
80109073:	0b 45 14             	or     0x14(%ebp),%eax
80109076:	83 c8 01             	or     $0x1,%eax
80109079:	89 c2                	mov    %eax,%edx
8010907b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010907e:	89 10                	mov    %edx,(%eax)
    if(a == last)
80109080:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109083:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109086:	75 08                	jne    80109090 <mappages+0x86>
      break;
80109088:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80109089:	b8 00 00 00 00       	mov    $0x0,%eax
8010908e:	eb 10                	jmp    801090a0 <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80109090:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109097:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010909e:	eb 8e                	jmp    8010902e <mappages+0x24>
  return 0;
}
801090a0:	c9                   	leave  
801090a1:	c3                   	ret    

801090a2 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801090a2:	55                   	push   %ebp
801090a3:	89 e5                	mov    %esp,%ebp
801090a5:	53                   	push   %ebx
801090a6:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801090a9:	e8 91 9b ff ff       	call   80102c3f <kalloc>
801090ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
801090b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801090b5:	75 07                	jne    801090be <setupkvm+0x1c>
    return 0;
801090b7:	b8 00 00 00 00       	mov    $0x0,%eax
801090bc:	eb 79                	jmp    80109137 <setupkvm+0x95>
  memset(pgdir, 0, PGSIZE);
801090be:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801090c5:	00 
801090c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801090cd:	00 
801090ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090d1:	89 04 24             	mov    %eax,(%esp)
801090d4:	e8 a0 d3 ff ff       	call   80106479 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801090d9:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
801090e0:	eb 49                	jmp    8010912b <setupkvm+0x89>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801090e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090e5:	8b 48 0c             	mov    0xc(%eax),%ecx
801090e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090eb:	8b 50 04             	mov    0x4(%eax),%edx
801090ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090f1:	8b 58 08             	mov    0x8(%eax),%ebx
801090f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090f7:	8b 40 04             	mov    0x4(%eax),%eax
801090fa:	29 c3                	sub    %eax,%ebx
801090fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090ff:	8b 00                	mov    (%eax),%eax
80109101:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80109105:	89 54 24 0c          	mov    %edx,0xc(%esp)
80109109:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010910d:	89 44 24 04          	mov    %eax,0x4(%esp)
80109111:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109114:	89 04 24             	mov    %eax,(%esp)
80109117:	e8 ee fe ff ff       	call   8010900a <mappages>
8010911c:	85 c0                	test   %eax,%eax
8010911e:	79 07                	jns    80109127 <setupkvm+0x85>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80109120:	b8 00 00 00 00       	mov    $0x0,%eax
80109125:	eb 10                	jmp    80109137 <setupkvm+0x95>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109127:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010912b:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
80109132:	72 ae                	jb     801090e2 <setupkvm+0x40>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109134:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109137:	83 c4 34             	add    $0x34,%esp
8010913a:	5b                   	pop    %ebx
8010913b:	5d                   	pop    %ebp
8010913c:	c3                   	ret    

8010913d <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010913d:	55                   	push   %ebp
8010913e:	89 e5                	mov    %esp,%ebp
80109140:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109143:	e8 5a ff ff ff       	call   801090a2 <setupkvm>
80109148:	a3 64 90 11 80       	mov    %eax,0x80119064
  switchkvm();
8010914d:	e8 02 00 00 00       	call   80109154 <switchkvm>
}
80109152:	c9                   	leave  
80109153:	c3                   	ret    

80109154 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109154:	55                   	push   %ebp
80109155:	89 e5                	mov    %esp,%ebp
80109157:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010915a:	a1 64 90 11 80       	mov    0x80119064,%eax
8010915f:	05 00 00 00 80       	add    $0x80000000,%eax
80109164:	89 04 24             	mov    %eax,(%esp)
80109167:	e8 81 f9 ff ff       	call   80108aed <lcr3>
}
8010916c:	c9                   	leave  
8010916d:	c3                   	ret    

8010916e <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010916e:	55                   	push   %ebp
8010916f:	89 e5                	mov    %esp,%ebp
80109171:	53                   	push   %ebx
80109172:	83 ec 14             	sub    $0x14,%esp
  if(p == 0)
80109175:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109179:	75 0c                	jne    80109187 <switchuvm+0x19>
    panic("switchuvm: no process");
8010917b:	c7 04 24 86 a0 10 80 	movl   $0x8010a086,(%esp)
80109182:	e8 db 73 ff ff       	call   80100562 <panic>
  if(p->kstack == 0)
80109187:	8b 45 08             	mov    0x8(%ebp),%eax
8010918a:	8b 40 08             	mov    0x8(%eax),%eax
8010918d:	85 c0                	test   %eax,%eax
8010918f:	75 0c                	jne    8010919d <switchuvm+0x2f>
    panic("switchuvm: no kstack");
80109191:	c7 04 24 9c a0 10 80 	movl   $0x8010a09c,(%esp)
80109198:	e8 c5 73 ff ff       	call   80100562 <panic>
  if(p->pgdir == 0)
8010919d:	8b 45 08             	mov    0x8(%ebp),%eax
801091a0:	8b 40 04             	mov    0x4(%eax),%eax
801091a3:	85 c0                	test   %eax,%eax
801091a5:	75 0c                	jne    801091b3 <switchuvm+0x45>
    panic("switchuvm: no pgdir");
801091a7:	c7 04 24 b1 a0 10 80 	movl   $0x8010a0b1,(%esp)
801091ae:	e8 af 73 ff ff       	call   80100562 <panic>

  pushcli();
801091b3:	e8 af d1 ff ff       	call   80106367 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801091b8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801091be:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801091c5:	83 c2 08             	add    $0x8,%edx
801091c8:	89 d3                	mov    %edx,%ebx
801091ca:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801091d1:	83 c2 08             	add    $0x8,%edx
801091d4:	c1 ea 10             	shr    $0x10,%edx
801091d7:	89 d1                	mov    %edx,%ecx
801091d9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801091e0:	83 c2 08             	add    $0x8,%edx
801091e3:	c1 ea 18             	shr    $0x18,%edx
801091e6:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801091ed:	67 00 
801091ef:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
801091f6:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801091fc:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80109203:	83 e1 f0             	and    $0xfffffff0,%ecx
80109206:	83 c9 09             	or     $0x9,%ecx
80109209:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010920f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80109216:	83 c9 10             	or     $0x10,%ecx
80109219:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010921f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80109226:	83 e1 9f             	and    $0xffffff9f,%ecx
80109229:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010922f:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80109236:	83 c9 80             	or     $0xffffff80,%ecx
80109239:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
8010923f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80109246:	83 e1 f0             	and    $0xfffffff0,%ecx
80109249:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010924f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80109256:	83 e1 ef             	and    $0xffffffef,%ecx
80109259:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010925f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80109266:	83 e1 df             	and    $0xffffffdf,%ecx
80109269:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010926f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80109276:	83 c9 40             	or     $0x40,%ecx
80109279:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010927f:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80109286:	83 e1 7f             	and    $0x7f,%ecx
80109289:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
8010928f:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80109295:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010929b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801092a2:	83 e2 ef             	and    $0xffffffef,%edx
801092a5:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801092ab:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801092b1:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801092b7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801092bd:	8b 55 08             	mov    0x8(%ebp),%edx
801092c0:	8b 52 08             	mov    0x8(%edx),%edx
801092c3:	81 c2 00 10 00 00    	add    $0x1000,%edx
801092c9:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
801092cc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801092d2:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
801092d8:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801092df:	e8 de f7 ff ff       	call   80108ac2 <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
801092e4:	8b 45 08             	mov    0x8(%ebp),%eax
801092e7:	8b 40 04             	mov    0x4(%eax),%eax
801092ea:	05 00 00 00 80       	add    $0x80000000,%eax
801092ef:	89 04 24             	mov    %eax,(%esp)
801092f2:	e8 f6 f7 ff ff       	call   80108aed <lcr3>
  popcli();
801092f7:	e8 c1 d0 ff ff       	call   801063bd <popcli>
}
801092fc:	83 c4 14             	add    $0x14,%esp
801092ff:	5b                   	pop    %ebx
80109300:	5d                   	pop    %ebp
80109301:	c3                   	ret    

80109302 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109302:	55                   	push   %ebp
80109303:	89 e5                	mov    %esp,%ebp
80109305:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80109308:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010930f:	76 0c                	jbe    8010931d <inituvm+0x1b>
    panic("inituvm: more than a page");
80109311:	c7 04 24 c5 a0 10 80 	movl   $0x8010a0c5,(%esp)
80109318:	e8 45 72 ff ff       	call   80100562 <panic>
  mem = kalloc();
8010931d:	e8 1d 99 ff ff       	call   80102c3f <kalloc>
80109322:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80109325:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010932c:	00 
8010932d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80109334:	00 
80109335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109338:	89 04 24             	mov    %eax,(%esp)
8010933b:	e8 39 d1 ff ff       	call   80106479 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80109340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109343:	05 00 00 00 80       	add    $0x80000000,%eax
80109348:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010934f:	00 
80109350:	89 44 24 0c          	mov    %eax,0xc(%esp)
80109354:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010935b:	00 
8010935c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80109363:	00 
80109364:	8b 45 08             	mov    0x8(%ebp),%eax
80109367:	89 04 24             	mov    %eax,(%esp)
8010936a:	e8 9b fc ff ff       	call   8010900a <mappages>
  memmove(mem, init, sz);
8010936f:	8b 45 10             	mov    0x10(%ebp),%eax
80109372:	89 44 24 08          	mov    %eax,0x8(%esp)
80109376:	8b 45 0c             	mov    0xc(%ebp),%eax
80109379:	89 44 24 04          	mov    %eax,0x4(%esp)
8010937d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109380:	89 04 24             	mov    %eax,(%esp)
80109383:	e8 c0 d1 ff ff       	call   80106548 <memmove>
}
80109388:	c9                   	leave  
80109389:	c3                   	ret    

8010938a <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010938a:	55                   	push   %ebp
8010938b:	89 e5                	mov    %esp,%ebp
8010938d:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109390:	8b 45 0c             	mov    0xc(%ebp),%eax
80109393:	25 ff 0f 00 00       	and    $0xfff,%eax
80109398:	85 c0                	test   %eax,%eax
8010939a:	74 0c                	je     801093a8 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
8010939c:	c7 04 24 e0 a0 10 80 	movl   $0x8010a0e0,(%esp)
801093a3:	e8 ba 71 ff ff       	call   80100562 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801093a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801093af:	e9 a6 00 00 00       	jmp    8010945a <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801093b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801093ba:	01 d0                	add    %edx,%eax
801093bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801093c3:	00 
801093c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801093c8:	8b 45 08             	mov    0x8(%ebp),%eax
801093cb:	89 04 24             	mov    %eax,(%esp)
801093ce:	e8 9b fb ff ff       	call   80108f6e <walkpgdir>
801093d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801093d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801093da:	75 0c                	jne    801093e8 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
801093dc:	c7 04 24 03 a1 10 80 	movl   $0x8010a103,(%esp)
801093e3:	e8 7a 71 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
801093e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801093eb:	8b 00                	mov    (%eax),%eax
801093ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801093f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801093f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093f8:	8b 55 18             	mov    0x18(%ebp),%edx
801093fb:	29 c2                	sub    %eax,%edx
801093fd:	89 d0                	mov    %edx,%eax
801093ff:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109404:	77 0f                	ja     80109415 <loaduvm+0x8b>
      n = sz - i;
80109406:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109409:	8b 55 18             	mov    0x18(%ebp),%edx
8010940c:	29 c2                	sub    %eax,%edx
8010940e:	89 d0                	mov    %edx,%eax
80109410:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109413:	eb 07                	jmp    8010941c <loaduvm+0x92>
    else
      n = PGSIZE;
80109415:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010941c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010941f:	8b 55 14             	mov    0x14(%ebp),%edx
80109422:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80109425:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109428:	05 00 00 00 80       	add    $0x80000000,%eax
8010942d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80109430:	89 54 24 0c          	mov    %edx,0xc(%esp)
80109434:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80109438:	89 44 24 04          	mov    %eax,0x4(%esp)
8010943c:	8b 45 10             	mov    0x10(%ebp),%eax
8010943f:	89 04 24             	mov    %eax,(%esp)
80109442:	e8 23 8a ff ff       	call   80101e6a <readi>
80109447:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010944a:	74 07                	je     80109453 <loaduvm+0xc9>
      return -1;
8010944c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109451:	eb 18                	jmp    8010946b <loaduvm+0xe1>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109453:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010945a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010945d:	3b 45 18             	cmp    0x18(%ebp),%eax
80109460:	0f 82 4e ff ff ff    	jb     801093b4 <loaduvm+0x2a>
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109466:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010946b:	c9                   	leave  
8010946c:	c3                   	ret    

8010946d <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010946d:	55                   	push   %ebp
8010946e:	89 e5                	mov    %esp,%ebp
80109470:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109473:	8b 45 10             	mov    0x10(%ebp),%eax
80109476:	85 c0                	test   %eax,%eax
80109478:	79 0a                	jns    80109484 <allocuvm+0x17>
    return 0;
8010947a:	b8 00 00 00 00       	mov    $0x0,%eax
8010947f:	e9 fd 00 00 00       	jmp    80109581 <allocuvm+0x114>
  if(newsz < oldsz)
80109484:	8b 45 10             	mov    0x10(%ebp),%eax
80109487:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010948a:	73 08                	jae    80109494 <allocuvm+0x27>
    return oldsz;
8010948c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010948f:	e9 ed 00 00 00       	jmp    80109581 <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
80109494:	8b 45 0c             	mov    0xc(%ebp),%eax
80109497:	05 ff 0f 00 00       	add    $0xfff,%eax
8010949c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801094a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801094a4:	e9 c9 00 00 00       	jmp    80109572 <allocuvm+0x105>
    mem = kalloc();
801094a9:	e8 91 97 ff ff       	call   80102c3f <kalloc>
801094ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801094b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801094b5:	75 2f                	jne    801094e6 <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
801094b7:	c7 04 24 21 a1 10 80 	movl   $0x8010a121,(%esp)
801094be:	e8 05 6f ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801094c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801094c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801094ca:	8b 45 10             	mov    0x10(%ebp),%eax
801094cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801094d1:	8b 45 08             	mov    0x8(%ebp),%eax
801094d4:	89 04 24             	mov    %eax,(%esp)
801094d7:	e8 a7 00 00 00       	call   80109583 <deallocuvm>
      return 0;
801094dc:	b8 00 00 00 00       	mov    $0x0,%eax
801094e1:	e9 9b 00 00 00       	jmp    80109581 <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
801094e6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801094ed:	00 
801094ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801094f5:	00 
801094f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094f9:	89 04 24             	mov    %eax,(%esp)
801094fc:	e8 78 cf ff ff       	call   80106479 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80109501:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109504:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
8010950a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010950d:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80109514:	00 
80109515:	89 54 24 0c          	mov    %edx,0xc(%esp)
80109519:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80109520:	00 
80109521:	89 44 24 04          	mov    %eax,0x4(%esp)
80109525:	8b 45 08             	mov    0x8(%ebp),%eax
80109528:	89 04 24             	mov    %eax,(%esp)
8010952b:	e8 da fa ff ff       	call   8010900a <mappages>
80109530:	85 c0                	test   %eax,%eax
80109532:	79 37                	jns    8010956b <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
80109534:	c7 04 24 39 a1 10 80 	movl   $0x8010a139,(%esp)
8010953b:	e8 88 6e ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80109540:	8b 45 0c             	mov    0xc(%ebp),%eax
80109543:	89 44 24 08          	mov    %eax,0x8(%esp)
80109547:	8b 45 10             	mov    0x10(%ebp),%eax
8010954a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010954e:	8b 45 08             	mov    0x8(%ebp),%eax
80109551:	89 04 24             	mov    %eax,(%esp)
80109554:	e8 2a 00 00 00       	call   80109583 <deallocuvm>
      kfree(mem);
80109559:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010955c:	89 04 24             	mov    %eax,(%esp)
8010955f:	e8 45 96 ff ff       	call   80102ba9 <kfree>
      return 0;
80109564:	b8 00 00 00 00       	mov    $0x0,%eax
80109569:	eb 16                	jmp    80109581 <allocuvm+0x114>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
8010956b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109575:	3b 45 10             	cmp    0x10(%ebp),%eax
80109578:	0f 82 2b ff ff ff    	jb     801094a9 <allocuvm+0x3c>
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
8010957e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109581:	c9                   	leave  
80109582:	c3                   	ret    

80109583 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109583:	55                   	push   %ebp
80109584:	89 e5                	mov    %esp,%ebp
80109586:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109589:	8b 45 10             	mov    0x10(%ebp),%eax
8010958c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010958f:	72 08                	jb     80109599 <deallocuvm+0x16>
    return oldsz;
80109591:	8b 45 0c             	mov    0xc(%ebp),%eax
80109594:	e9 ae 00 00 00       	jmp    80109647 <deallocuvm+0xc4>

  a = PGROUNDUP(newsz);
80109599:	8b 45 10             	mov    0x10(%ebp),%eax
8010959c:	05 ff 0f 00 00       	add    $0xfff,%eax
801095a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801095a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801095a9:	e9 8a 00 00 00       	jmp    80109638 <deallocuvm+0xb5>
    pte = walkpgdir(pgdir, (char*)a, 0);
801095ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095b1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801095b8:	00 
801095b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801095bd:	8b 45 08             	mov    0x8(%ebp),%eax
801095c0:	89 04 24             	mov    %eax,(%esp)
801095c3:	e8 a6 f9 ff ff       	call   80108f6e <walkpgdir>
801095c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801095cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801095cf:	75 16                	jne    801095e7 <deallocuvm+0x64>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801095d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095d4:	c1 e8 16             	shr    $0x16,%eax
801095d7:	83 c0 01             	add    $0x1,%eax
801095da:	c1 e0 16             	shl    $0x16,%eax
801095dd:	2d 00 10 00 00       	sub    $0x1000,%eax
801095e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801095e5:	eb 4a                	jmp    80109631 <deallocuvm+0xae>
    else if((*pte & PTE_P) != 0){
801095e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801095ea:	8b 00                	mov    (%eax),%eax
801095ec:	83 e0 01             	and    $0x1,%eax
801095ef:	85 c0                	test   %eax,%eax
801095f1:	74 3e                	je     80109631 <deallocuvm+0xae>
      pa = PTE_ADDR(*pte);
801095f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801095f6:	8b 00                	mov    (%eax),%eax
801095f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801095fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109600:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109604:	75 0c                	jne    80109612 <deallocuvm+0x8f>
        panic("kfree");
80109606:	c7 04 24 55 a1 10 80 	movl   $0x8010a155,(%esp)
8010960d:	e8 50 6f ff ff       	call   80100562 <panic>
      char *v = P2V(pa);
80109612:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109615:	05 00 00 00 80       	add    $0x80000000,%eax
8010961a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010961d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109620:	89 04 24             	mov    %eax,(%esp)
80109623:	e8 81 95 ff ff       	call   80102ba9 <kfree>
      *pte = 0;
80109628:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010962b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109631:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010963b:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010963e:	0f 82 6a ff ff ff    	jb     801095ae <deallocuvm+0x2b>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109644:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109647:	c9                   	leave  
80109648:	c3                   	ret    

80109649 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109649:	55                   	push   %ebp
8010964a:	89 e5                	mov    %esp,%ebp
8010964c:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
8010964f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109653:	75 0c                	jne    80109661 <freevm+0x18>
    panic("freevm: no pgdir");
80109655:	c7 04 24 5b a1 10 80 	movl   $0x8010a15b,(%esp)
8010965c:	e8 01 6f ff ff       	call   80100562 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109661:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80109668:	00 
80109669:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80109670:	80 
80109671:	8b 45 08             	mov    0x8(%ebp),%eax
80109674:	89 04 24             	mov    %eax,(%esp)
80109677:	e8 07 ff ff ff       	call   80109583 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010967c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109683:	eb 45                	jmp    801096ca <freevm+0x81>
    if(pgdir[i] & PTE_P){
80109685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109688:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010968f:	8b 45 08             	mov    0x8(%ebp),%eax
80109692:	01 d0                	add    %edx,%eax
80109694:	8b 00                	mov    (%eax),%eax
80109696:	83 e0 01             	and    $0x1,%eax
80109699:	85 c0                	test   %eax,%eax
8010969b:	74 29                	je     801096c6 <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010969d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801096a7:	8b 45 08             	mov    0x8(%ebp),%eax
801096aa:	01 d0                	add    %edx,%eax
801096ac:	8b 00                	mov    (%eax),%eax
801096ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096b3:	05 00 00 00 80       	add    $0x80000000,%eax
801096b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801096bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096be:	89 04 24             	mov    %eax,(%esp)
801096c1:	e8 e3 94 ff ff       	call   80102ba9 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801096c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801096ca:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801096d1:	76 b2                	jbe    80109685 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801096d3:	8b 45 08             	mov    0x8(%ebp),%eax
801096d6:	89 04 24             	mov    %eax,(%esp)
801096d9:	e8 cb 94 ff ff       	call   80102ba9 <kfree>
}
801096de:	c9                   	leave  
801096df:	c3                   	ret    

801096e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801096e0:	55                   	push   %ebp
801096e1:	89 e5                	mov    %esp,%ebp
801096e3:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801096e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801096ed:	00 
801096ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801096f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801096f5:	8b 45 08             	mov    0x8(%ebp),%eax
801096f8:	89 04 24             	mov    %eax,(%esp)
801096fb:	e8 6e f8 ff ff       	call   80108f6e <walkpgdir>
80109700:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109707:	75 0c                	jne    80109715 <clearpteu+0x35>
    panic("clearpteu");
80109709:	c7 04 24 6c a1 10 80 	movl   $0x8010a16c,(%esp)
80109710:	e8 4d 6e ff ff       	call   80100562 <panic>
  *pte &= ~PTE_U;
80109715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109718:	8b 00                	mov    (%eax),%eax
8010971a:	83 e0 fb             	and    $0xfffffffb,%eax
8010971d:	89 c2                	mov    %eax,%edx
8010971f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109722:	89 10                	mov    %edx,(%eax)
}
80109724:	c9                   	leave  
80109725:	c3                   	ret    

80109726 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109726:	55                   	push   %ebp
80109727:	89 e5                	mov    %esp,%ebp
80109729:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010972c:	e8 71 f9 ff ff       	call   801090a2 <setupkvm>
80109731:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109738:	75 0a                	jne    80109744 <copyuvm+0x1e>
    return 0;
8010973a:	b8 00 00 00 00       	mov    $0x0,%eax
8010973f:	e9 f8 00 00 00       	jmp    8010983c <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
80109744:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010974b:	e9 cb 00 00 00       	jmp    8010981b <copyuvm+0xf5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109753:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010975a:	00 
8010975b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010975f:	8b 45 08             	mov    0x8(%ebp),%eax
80109762:	89 04 24             	mov    %eax,(%esp)
80109765:	e8 04 f8 ff ff       	call   80108f6e <walkpgdir>
8010976a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010976d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109771:	75 0c                	jne    8010977f <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80109773:	c7 04 24 76 a1 10 80 	movl   $0x8010a176,(%esp)
8010977a:	e8 e3 6d ff ff       	call   80100562 <panic>
    if(!(*pte & PTE_P))
8010977f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109782:	8b 00                	mov    (%eax),%eax
80109784:	83 e0 01             	and    $0x1,%eax
80109787:	85 c0                	test   %eax,%eax
80109789:	75 0c                	jne    80109797 <copyuvm+0x71>
      panic("copyuvm: page not present");
8010978b:	c7 04 24 90 a1 10 80 	movl   $0x8010a190,(%esp)
80109792:	e8 cb 6d ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
80109797:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010979a:	8b 00                	mov    (%eax),%eax
8010979c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801097a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801097a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801097a7:	8b 00                	mov    (%eax),%eax
801097a9:	25 ff 0f 00 00       	and    $0xfff,%eax
801097ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801097b1:	e8 89 94 ff ff       	call   80102c3f <kalloc>
801097b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801097b9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801097bd:	75 02                	jne    801097c1 <copyuvm+0x9b>
      goto bad;
801097bf:	eb 6b                	jmp    8010982c <copyuvm+0x106>
    memmove(mem, (char*)P2V(pa), PGSIZE);
801097c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801097c4:	05 00 00 00 80       	add    $0x80000000,%eax
801097c9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801097d0:	00 
801097d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801097d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801097d8:	89 04 24             	mov    %eax,(%esp)
801097db:	e8 68 cd ff ff       	call   80106548 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801097e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801097e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801097e6:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801097ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097ef:	89 54 24 10          	mov    %edx,0x10(%esp)
801097f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801097f7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801097fe:	00 
801097ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80109803:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109806:	89 04 24             	mov    %eax,(%esp)
80109809:	e8 fc f7 ff ff       	call   8010900a <mappages>
8010980e:	85 c0                	test   %eax,%eax
80109810:	79 02                	jns    80109814 <copyuvm+0xee>
      goto bad;
80109812:	eb 18                	jmp    8010982c <copyuvm+0x106>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109814:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010981b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010981e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109821:	0f 82 29 ff ff ff    	jb     80109750 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;
80109827:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010982a:	eb 10                	jmp    8010983c <copyuvm+0x116>

bad:
  freevm(d);
8010982c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010982f:	89 04 24             	mov    %eax,(%esp)
80109832:	e8 12 fe ff ff       	call   80109649 <freevm>
  return 0;
80109837:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010983c:	c9                   	leave  
8010983d:	c3                   	ret    

8010983e <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010983e:	55                   	push   %ebp
8010983f:	89 e5                	mov    %esp,%ebp
80109841:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109844:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010984b:	00 
8010984c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010984f:	89 44 24 04          	mov    %eax,0x4(%esp)
80109853:	8b 45 08             	mov    0x8(%ebp),%eax
80109856:	89 04 24             	mov    %eax,(%esp)
80109859:	e8 10 f7 ff ff       	call   80108f6e <walkpgdir>
8010985e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109864:	8b 00                	mov    (%eax),%eax
80109866:	83 e0 01             	and    $0x1,%eax
80109869:	85 c0                	test   %eax,%eax
8010986b:	75 07                	jne    80109874 <uva2ka+0x36>
    return 0;
8010986d:	b8 00 00 00 00       	mov    $0x0,%eax
80109872:	eb 22                	jmp    80109896 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109874:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109877:	8b 00                	mov    (%eax),%eax
80109879:	83 e0 04             	and    $0x4,%eax
8010987c:	85 c0                	test   %eax,%eax
8010987e:	75 07                	jne    80109887 <uva2ka+0x49>
    return 0;
80109880:	b8 00 00 00 00       	mov    $0x0,%eax
80109885:	eb 0f                	jmp    80109896 <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
80109887:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010988a:	8b 00                	mov    (%eax),%eax
8010988c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109891:	05 00 00 00 80       	add    $0x80000000,%eax
}
80109896:	c9                   	leave  
80109897:	c3                   	ret    

80109898 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109898:	55                   	push   %ebp
80109899:	89 e5                	mov    %esp,%ebp
8010989b:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010989e:	8b 45 10             	mov    0x10(%ebp),%eax
801098a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801098a4:	e9 87 00 00 00       	jmp    80109930 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
801098a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801098ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801098b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801098b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801098bb:	8b 45 08             	mov    0x8(%ebp),%eax
801098be:	89 04 24             	mov    %eax,(%esp)
801098c1:	e8 78 ff ff ff       	call   8010983e <uva2ka>
801098c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801098c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801098cd:	75 07                	jne    801098d6 <copyout+0x3e>
      return -1;
801098cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801098d4:	eb 69                	jmp    8010993f <copyout+0xa7>
    n = PGSIZE - (va - va0);
801098d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801098d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801098dc:	29 c2                	sub    %eax,%edx
801098de:	89 d0                	mov    %edx,%eax
801098e0:	05 00 10 00 00       	add    $0x1000,%eax
801098e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801098e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801098eb:	3b 45 14             	cmp    0x14(%ebp),%eax
801098ee:	76 06                	jbe    801098f6 <copyout+0x5e>
      n = len;
801098f0:	8b 45 14             	mov    0x14(%ebp),%eax
801098f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801098f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801098f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801098fc:	29 c2                	sub    %eax,%edx
801098fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109901:	01 c2                	add    %eax,%edx
80109903:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109906:	89 44 24 08          	mov    %eax,0x8(%esp)
8010990a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010990d:	89 44 24 04          	mov    %eax,0x4(%esp)
80109911:	89 14 24             	mov    %edx,(%esp)
80109914:	e8 2f cc ff ff       	call   80106548 <memmove>
    len -= n;
80109919:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010991c:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010991f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109922:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109925:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109928:	05 00 10 00 00       	add    $0x1000,%eax
8010992d:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109930:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109934:	0f 85 6f ff ff ff    	jne    801098a9 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010993a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010993f:	c9                   	leave  
80109940:	c3                   	ret    

80109941 <my_syscall>:
#include "types.h"
#include "defs.h"

int
my_syscall(char *str) 
{
80109941:	55                   	push   %ebp
80109942:	89 e5                	mov    %esp,%ebp
80109944:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s\n", str);
80109947:	8b 45 08             	mov    0x8(%ebp),%eax
8010994a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010994e:	c7 04 24 aa a1 10 80 	movl   $0x8010a1aa,(%esp)
80109955:	e8 6e 6a ff ff       	call   801003c8 <cprintf>
    return 0xABCDABCD;
8010995a:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
}
8010995f:	c9                   	leave  
80109960:	c3                   	ret    

80109961 <sys_my_syscall>:

int
sys_my_syscall(void) 
{
80109961:	55                   	push   %ebp
80109962:	89 e5                	mov    %esp,%ebp
80109964:	83 ec 28             	sub    $0x28,%esp
    char *str;
    if (argstr(0, &str) < 0) // wrapper 함수. 커널 내부에 reference가 호출 되고, argument가 user영역에 있는지 체크해주는 함수.
80109967:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010996a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010996e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80109975:	e8 d7 ce ff ff       	call   80106851 <argstr>
8010997a:	85 c0                	test   %eax,%eax
8010997c:	79 07                	jns    80109985 <sys_my_syscall+0x24>
        return -1;
8010997e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109983:	eb 0b                	jmp    80109990 <sys_my_syscall+0x2f>
    return my_syscall(str);
80109985:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109988:	89 04 24             	mov    %eax,(%esp)
8010998b:	e8 b1 ff ff ff       	call   80109941 <my_syscall>
}
80109990:	c9                   	leave  
80109991:	c3                   	ret    

80109992 <getppid>:
#include "x86.h"
#include "syscall.h"

int
getppid(void)
{
80109992:	55                   	push   %ebp
80109993:	89 e5                	mov    %esp,%ebp
    return proc->parent->pid;
80109995:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010999b:	8b 40 14             	mov    0x14(%eax),%eax
8010999e:	8b 40 10             	mov    0x10(%eax),%eax
}
801099a1:	5d                   	pop    %ebp
801099a2:	c3                   	ret    

801099a3 <sys_getppid>:

//Wrapper for getppid
int
sys_getppid(void)
{
801099a3:	55                   	push   %ebp
801099a4:	89 e5                	mov    %esp,%ebp
    return getppid();
801099a6:	e8 e7 ff ff ff       	call   80109992 <getppid>
}
801099ab:	5d                   	pop    %ebp
801099ac:	c3                   	ret    

801099ad <getlev>:
#include "proc.h"

// Design Document 1-1-2-3.
int
getlev(void)
{
801099ad:	55                   	push   %ebp
801099ae:	89 e5                	mov    %esp,%ebp
    return proc->level_of_MLFQ;
801099b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801099b6:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
801099bc:	5d                   	pop    %ebp
801099bd:	c3                   	ret    

801099be <sys_getlev>:

//Wrapper
int
sys_getlev(void)
{
801099be:	55                   	push   %ebp
801099bf:	89 e5                	mov    %esp,%ebp
    return getlev();
801099c1:	e8 e7 ff ff ff       	call   801099ad <getlev>
}
801099c6:	5d                   	pop    %ebp
801099c7:	c3                   	ret    

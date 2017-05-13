
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 c0 78 10 	movl   $0x801078c0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010005b:	e8 d0 4a 00 00       	call   80104b30 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
8010006c:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
80100076:	0c 11 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 c7 78 10 	movl   $0x801078c7,0x4(%esp)
8010009b:	80 
8010009c:	e8 7f 49 00 00       	call   80104a20 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 30 0d 11 80       	mov    0x80110d30,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 c5 4a 00 00       	call   80104bb0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000f1:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle some unused buffer and clean buffer
  // "clean" because B_DIRTY and not locked means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100161:	e8 7a 4b 00 00       	call   80104ce0 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 ef 48 00 00       	call   80104a60 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 e2 1f 00 00       	call   80102160 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 ce 78 10 80 	movl   $0x801078ce,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 4b 49 00 00       	call   80104b00 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 97 1f 00 00       	jmp    80102160 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 df 78 10 80 	movl   $0x801078df,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 0a 49 00 00       	call   80104b00 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 be 48 00 00       	call   80104ac0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100209:	e8 a2 49 00 00       	call   80104bb0 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 30 0d 11 80       	mov    0x80110d30,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 8b 4a 00 00       	jmp    80104ce0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 e6 78 10 80 	movl   $0x801078e6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 49 15 00 00       	call   801017d0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028e:	e8 1d 49 00 00       	call   80104bb0 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 26                	jmp    801002c9 <consoleread+0x59>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(proc->killed){
801002a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002ae:	8b 40 24             	mov    0x24(%eax),%eax
801002b1:	85 c0                	test   %eax,%eax
801002b3:	75 73                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b5:	c7 44 24 04 20 b5 10 	movl   $0x8010b520,0x4(%esp)
801002bc:	80 
801002bd:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801002c4:	e8 27 41 00 00       	call   801043f0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c9:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002ce:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002d4:	74 d2                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d6:	8d 50 01             	lea    0x1(%eax),%edx
801002d9:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
801002df:	89 c2                	mov    %eax,%edx
801002e1:	83 e2 7f             	and    $0x7f,%edx
801002e4:	0f b6 8a 40 0f 11 80 	movzbl -0x7feef0c0(%edx),%ecx
801002eb:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ee:	83 fa 04             	cmp    $0x4,%edx
801002f1:	74 56                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f3:	83 c6 01             	add    $0x1,%esi
    --n;
801002f6:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f9:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fc:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002ff:	74 52                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100301:	85 db                	test   %ebx,%ebx
80100303:	75 c4                	jne    801002c9 <consoleread+0x59>
80100305:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100308:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010030f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100312:	e8 c9 49 00 00       	call   80104ce0 <release>
  ilock(ip);
80100317:	89 3c 24             	mov    %edi,(%esp)
8010031a:	e8 e1 13 00 00       	call   80101700 <ilock>
8010031f:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100322:	eb 1d                	jmp    80100341 <consoleread+0xd1>
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(proc->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010032f:	e8 ac 49 00 00       	call   80104ce0 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 c4 13 00 00       	call   80101700 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ae                	jmp    80100308 <consoleread+0x98>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb aa                	jmp    80100308 <consoleread+0x98>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100369:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
8010036f:	8d 5d d0             	lea    -0x30(%ebp),%ebx
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100372:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100379:	00 00 00 
8010037c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010037f:	0f b6 00             	movzbl (%eax),%eax
80100382:	c7 04 24 ed 78 10 80 	movl   $0x801078ed,(%esp)
80100389:	89 44 24 04          	mov    %eax,0x4(%esp)
8010038d:	e8 be 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
80100392:	8b 45 08             	mov    0x8(%ebp),%eax
80100395:	89 04 24             	mov    %eax,(%esp)
80100398:	e8 b3 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
8010039d:	c7 04 24 e6 7d 10 80 	movl   $0x80107de6,(%esp)
801003a4:	e8 a7 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a9:	8d 45 08             	lea    0x8(%ebp),%eax
801003ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003b0:	89 04 24             	mov    %eax,(%esp)
801003b3:	e8 98 47 00 00       	call   80104b50 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 09 79 10 80 	movl   $0x80107909,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 02 5f 00 00       	call   80106310 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 52 5e 00 00       	call   80106310 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 46 5e 00 00       	call   80106310 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 3a 5e 00 00       	call   80106310 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 cf 48 00 00       	call   80104dd0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 12 48 00 00       	call   80104d30 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 0d 79 10 80 	movl   $0x8010790d,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 38 79 10 80 	movzbl -0x7fef86c8(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 c9 11 00 00       	call   801017d0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010060e:	e8 9d 45 00 00       	call   80104bb0 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100636:	e8 a5 46 00 00       	call   80104ce0 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 ba 10 00 00       	call   80101700 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801006f3:	e8 e8 45 00 00       	call   80104ce0 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 20 79 10 80       	mov    $0x80107920,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100797:	e8 14 44 00 00       	call   80104bb0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 27 79 10 80 	movl   $0x80107927,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801007c5:	e8 e6 43 00 00       	call   80104bb0 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801007f7:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100827:	e8 b4 44 00 00       	call   80104ce0 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d c0 0f 11 80    	mov    0x80110fc0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
801008b2:	e8 39 3d 00 00       	call   801045f0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008c5:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008ec:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 b4 3d 00 00       	jmp    801046e0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 30 79 10 	movl   $0x80107930,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100965:	e8 c6 41 00 00       	call   80104b30 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
8010096a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100971:	c7 05 8c 19 11 80 f0 	movl   $0x801005f0,0x8011198c
80100978:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010097b:	c7 05 88 19 11 80 70 	movl   $0x80100270,0x80111988
80100982:	02 10 80 
  cons.locking = 1;
80100985:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
8010098c:	00 00 00 

  picenable(IRQ_KBD);
8010098f:	e8 ac 28 00 00       	call   80103240 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010099b:	00 
8010099c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801009a3:	e8 48 19 00 00       	call   801022f0 <ioapicenable>
}
801009a8:	c9                   	leave  
801009a9:	c3                   	ret    
801009aa:	66 90                	xchg   %ax,%ax
801009ac:	66 90                	xchg   %ax,%ax
801009ae:	66 90                	xchg   %ax,%ax

801009b0 <exec>:
extern int pgdir_ref_next_idx;


int
exec(char *path, char **argv)
{
801009b0:	55                   	push   %ebp
801009b1:	89 e5                	mov    %esp,%ebp
801009b3:	57                   	push   %edi
801009b4:	56                   	push   %esi
801009b5:	53                   	push   %ebx
801009b6:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009bc:	e8 0f 22 00 00       	call   80102bd0 <begin_op>

  if((ip = namei(path)) == 0){
801009c1:	8b 45 08             	mov    0x8(%ebp),%eax
801009c4:	89 04 24             	mov    %eax,(%esp)
801009c7:	e8 64 15 00 00       	call   80101f30 <namei>
801009cc:	85 c0                	test   %eax,%eax
801009ce:	89 c3                	mov    %eax,%ebx
801009d0:	74 37                	je     80100a09 <exec+0x59>
    end_op();
    return -1;
  }
  ilock(ip);
801009d2:	89 04 24             	mov    %eax,(%esp)
801009d5:	e8 26 0d 00 00       	call   80101700 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009da:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009e0:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e7:	00 
801009e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ef:	00 
801009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f4:	89 1c 24             	mov    %ebx,(%esp)
801009f7:	e8 94 0f 00 00       	call   80101990 <readi>
801009fc:	83 f8 34             	cmp    $0x34,%eax
801009ff:	74 1f                	je     80100a20 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a01:	89 1c 24             	mov    %ebx,(%esp)
80100a04:	e8 37 0f 00 00       	call   80101940 <iunlockput>
    end_op();
80100a09:	e8 32 22 00 00       	call   80102c40 <end_op>
  }
  return -1;
80100a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a13:	81 c4 1c 01 00 00    	add    $0x11c,%esp
80100a19:	5b                   	pop    %ebx
80100a1a:	5e                   	pop    %esi
80100a1b:	5f                   	pop    %edi
80100a1c:	5d                   	pop    %ebp
80100a1d:	c3                   	ret    
80100a1e:	66 90                	xchg   %ax,%ax
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d5                	jne    80100a01 <exec+0x51>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 5f 67 00 00       	call   80107190 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a39:	74 c6                	je     80100a01 <exec+0x51>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a49:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x183>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xc5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x183>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 fd 0e 00 00       	call   80101990 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x170>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x170>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x170>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 89 69 00 00       	call   80107460 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x170>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x170>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 88 68 00 00       	call   801073a0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xb0>

  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 42 6a 00 00       	call   80107570 <freevm>
80100b2e:	e9 ce fe ff ff       	jmp    80100a01 <exec+0x51>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 05 0e 00 00       	call   80101940 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 fb 20 00 00       	call   80102c40 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b45:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 ef 68 00 00       	call   80107460 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b79:	75 18                	jne    80100b93 <exec+0x1e3>

  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b7b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 e7 69 00 00       	call   80107570 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 80 fe ff ff       	jmp    80100a13 <exec+0x63>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b93:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100b99:	89 d8                	mov    %ebx,%eax
80100b9b:	2d 00 20 00 00       	sub    $0x2000,%eax
80100ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ba4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100baa:	89 04 24             	mov    %eax,(%esp)
80100bad:	e8 3e 6a 00 00       	call   801075f0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb5:	8b 00                	mov    (%eax),%eax
80100bb7:	85 c0                	test   %eax,%eax
80100bb9:	0f 84 bb 01 00 00    	je     80100d7a <exec+0x3ca>
80100bbf:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100bc2:	31 f6                	xor    %esi,%esi
80100bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bc7:	89 f2                	mov    %esi,%edx
80100bc9:	89 fe                	mov    %edi,%esi
80100bcb:	89 d7                	mov    %edx,%edi
80100bcd:	83 c1 04             	add    $0x4,%ecx
80100bd0:	eb 0e                	jmp    80100be0 <exec+0x230>
80100bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100bd8:	83 c1 04             	add    $0x4,%ecx
    if(argc >= MAXARG)
80100bdb:	83 ff 20             	cmp    $0x20,%edi
80100bde:	74 9b                	je     80100b7b <exec+0x1cb>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100be0:	89 04 24             	mov    %eax,(%esp)
80100be3:	89 8d f0 fe ff ff    	mov    %ecx,-0x110(%ebp)
80100be9:	e8 62 43 00 00       	call   80104f50 <strlen>
80100bee:	f7 d0                	not    %eax
80100bf0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bf2:	8b 06                	mov    (%esi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bf7:	89 04 24             	mov    %eax,(%esp)
80100bfa:	e8 51 43 00 00       	call   80104f50 <strlen>
80100bff:	83 c0 01             	add    $0x1,%eax
80100c02:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c06:	8b 06                	mov    (%esi),%eax
80100c08:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c10:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c16:	89 04 24             	mov    %eax,(%esp)
80100c19:	e8 32 6b 00 00       	call   80107750 <copyout>
80100c1e:	85 c0                	test   %eax,%eax
80100c20:	0f 88 55 ff ff ff    	js     80100b7b <exec+0x1cb>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c26:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c2c:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c32:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c39:	83 c7 01             	add    $0x1,%edi
80100c3c:	8b 01                	mov    (%ecx),%eax
80100c3e:	89 ce                	mov    %ecx,%esi
80100c40:	85 c0                	test   %eax,%eax
80100c42:	75 94                	jne    80100bd8 <exec+0x228>
80100c44:	89 fe                	mov    %edi,%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c46:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c4d:	89 d9                	mov    %ebx,%ecx
80100c4f:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c51:	83 c0 0c             	add    $0xc,%eax
80100c54:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c56:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c5a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c60:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c68:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c6f:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c73:	89 04 24             	mov    %eax,(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c76:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c7d:	ff ff ff 
  ustack[1] = argc;
80100c80:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c86:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c8c:	e8 bf 6a 00 00       	call   80107750 <copyout>
80100c91:	85 c0                	test   %eax,%eax
80100c93:	0f 88 e2 fe ff ff    	js     80100b7b <exec+0x1cb>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c99:	8b 45 08             	mov    0x8(%ebp),%eax
80100c9c:	0f b6 10             	movzbl (%eax),%edx
80100c9f:	84 d2                	test   %dl,%dl
80100ca1:	74 19                	je     80100cbc <exec+0x30c>
80100ca3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100ca6:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100ca9:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cac:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100caf:	0f 44 c8             	cmove  %eax,%ecx
80100cb2:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb5:	84 d2                	test   %dl,%dl
80100cb7:	75 f0                	jne    80100ca9 <exec+0x2f9>
80100cb9:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80100cbf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cc6:	00 
80100cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ccb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cd1:	83 c0 6c             	add    $0x6c,%eax
80100cd4:	89 04 24             	mov    %eax,(%esp)
80100cd7:	e8 34 42 00 00       	call   80104f10 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cdc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100ce2:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ce8:	8b 70 04             	mov    0x4(%eax),%esi
  proc->pgdir = pgdir;
80100ceb:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
80100cee:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100cf4:	89 08                	mov    %ecx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100cf6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cfc:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d02:	8b 50 18             	mov    0x18(%eax),%edx
80100d05:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100d08:	8b 50 18             	mov    0x18(%eax),%edx
80100d0b:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100d0e:	89 04 24             	mov    %eax,(%esp)
80100d11:	e8 3a 65 00 00       	call   80107250 <switchuvm>

  if (proc->pgdir_ref_idx == -1) {
80100d16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d1c:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80100d22:	83 fa ff             	cmp    $0xffffffff,%edx
80100d25:	74 43                	je     80100d6a <exec+0x3ba>
    // This is a case in booting
    freevm(oldpgdir);
  } else if (pgdir_ref[proc->pgdir_ref_idx] <= 1) {
80100d27:	80 ba e0 3d 11 80 01 	cmpb   $0x1,-0x7feec220(%edx)
80100d2e:	7e 0f                	jle    80100d3f <exec+0x38f>
  } else {
    // There is a thread using a same addres space.
    // Do not free it.
  }

  allocate_new_pgdir_idx(proc);
80100d30:	89 04 24             	mov    %eax,(%esp)
80100d33:	e8 08 2c 00 00       	call   80103940 <allocate_new_pgdir_idx>

  return 0;
80100d38:	31 c0                	xor    %eax,%eax
80100d3a:	e9 d4 fc ff ff       	jmp    80100a13 <exec+0x63>
    // This is a case in booting
    freevm(oldpgdir);
  } else if (pgdir_ref[proc->pgdir_ref_idx] <= 1) {
    // Just only one process was using pgdir.
    // Free it.
    acquire(&thread_lock);
80100d3f:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80100d46:	e8 65 3e 00 00       	call   80104bb0 <acquire>
    pgdir_ref[proc->pgdir_ref_idx] = 0;
80100d4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d51:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
    release(&thread_lock);
80100d57:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
    freevm(oldpgdir);
  } else if (pgdir_ref[proc->pgdir_ref_idx] <= 1) {
    // Just only one process was using pgdir.
    // Free it.
    acquire(&thread_lock);
    pgdir_ref[proc->pgdir_ref_idx] = 0;
80100d5e:	c6 80 e0 3d 11 80 00 	movb   $0x0,-0x7feec220(%eax)
    release(&thread_lock);
80100d65:	e8 76 3f 00 00       	call   80104ce0 <release>
    freevm(oldpgdir);
80100d6a:	89 34 24             	mov    %esi,(%esp)
80100d6d:	e8 fe 67 00 00       	call   80107570 <freevm>
80100d72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100d78:	eb b6                	jmp    80100d30 <exec+0x380>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d7a:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100d80:	31 f6                	xor    %esi,%esi
80100d82:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d88:	e9 b9 fe ff ff       	jmp    80100c46 <exec+0x296>
80100d8d:	66 90                	xchg   %ax,%ax
80100d8f:	90                   	nop

80100d90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d96:	c7 44 24 04 49 79 10 	movl   $0x80107949,0x4(%esp)
80100d9d:	80 
80100d9e:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100da5:	e8 86 3d 00 00       	call   80104b30 <initlock>
}
80100daa:	c9                   	leave  
80100dab:	c3                   	ret    
80100dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100db0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db4:	bb 14 10 11 80       	mov    $0x80111014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100db9:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100dbc:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100dc3:	e8 e8 3d 00 00       	call   80104bb0 <acquire>
80100dc8:	eb 11                	jmp    80100ddb <filealloc+0x2b>
80100dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd0:	83 c3 18             	add    $0x18,%ebx
80100dd3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
80100dd9:	74 25                	je     80100e00 <filealloc+0x50>
    if(f->ref == 0){
80100ddb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	75 ee                	jne    80100dd0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100de2:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100de9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100df0:	e8 eb 3e 00 00       	call   80104ce0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100df5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100df8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dfa:	5b                   	pop    %ebx
80100dfb:	5d                   	pop    %ebp
80100dfc:	c3                   	ret    
80100dfd:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100e00:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100e07:	e8 d4 3e 00 00       	call   80104ce0 <release>
  return 0;
}
80100e0c:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100e0f:	31 c0                	xor    %eax,%eax
}
80100e11:	5b                   	pop    %ebx
80100e12:	5d                   	pop    %ebp
80100e13:	c3                   	ret    
80100e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100e20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
80100e24:	83 ec 14             	sub    $0x14,%esp
80100e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e2a:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100e31:	e8 7a 3d 00 00       	call   80104bb0 <acquire>
  if(f->ref < 1)
80100e36:	8b 43 04             	mov    0x4(%ebx),%eax
80100e39:	85 c0                	test   %eax,%eax
80100e3b:	7e 1a                	jle    80100e57 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e3d:	83 c0 01             	add    $0x1,%eax
80100e40:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e43:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100e4a:	e8 91 3e 00 00       	call   80104ce0 <release>
  return f;
}
80100e4f:	83 c4 14             	add    $0x14,%esp
80100e52:	89 d8                	mov    %ebx,%eax
80100e54:	5b                   	pop    %ebx
80100e55:	5d                   	pop    %ebp
80100e56:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e57:	c7 04 24 50 79 10 80 	movl   $0x80107950,(%esp)
80100e5e:	e8 fd f4 ff ff       	call   80100360 <panic>
80100e63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e70 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	57                   	push   %edi
80100e74:	56                   	push   %esi
80100e75:	53                   	push   %ebx
80100e76:	83 ec 1c             	sub    $0x1c,%esp
80100e79:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e7c:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100e83:	e8 28 3d 00 00       	call   80104bb0 <acquire>
  if(f->ref < 1)
80100e88:	8b 57 04             	mov    0x4(%edi),%edx
80100e8b:	85 d2                	test   %edx,%edx
80100e8d:	0f 8e 89 00 00 00    	jle    80100f1c <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e93:	83 ea 01             	sub    $0x1,%edx
80100e96:	85 d2                	test   %edx,%edx
80100e98:	89 57 04             	mov    %edx,0x4(%edi)
80100e9b:	74 13                	je     80100eb0 <fileclose+0x40>
    release(&ftable.lock);
80100e9d:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ea4:	83 c4 1c             	add    $0x1c,%esp
80100ea7:	5b                   	pop    %ebx
80100ea8:	5e                   	pop    %esi
80100ea9:	5f                   	pop    %edi
80100eaa:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100eab:	e9 30 3e 00 00       	jmp    80104ce0 <release>
    return;
  }
  ff = *f;
80100eb0:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100eb4:	8b 37                	mov    (%edi),%esi
80100eb6:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100eb9:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ebf:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ec2:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ec5:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ecc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ecf:	e8 0c 3e 00 00       	call   80104ce0 <release>

  if(ff.type == FD_PIPE)
80100ed4:	83 fe 01             	cmp    $0x1,%esi
80100ed7:	74 0f                	je     80100ee8 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ed9:	83 fe 02             	cmp    $0x2,%esi
80100edc:	74 22                	je     80100f00 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ede:	83 c4 1c             	add    $0x1c,%esp
80100ee1:	5b                   	pop    %ebx
80100ee2:	5e                   	pop    %esi
80100ee3:	5f                   	pop    %edi
80100ee4:	5d                   	pop    %ebp
80100ee5:	c3                   	ret    
80100ee6:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ee8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eec:	89 1c 24             	mov    %ebx,(%esp)
80100eef:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ef3:	e8 f8 24 00 00       	call   801033f0 <pipeclose>
80100ef8:	eb e4                	jmp    80100ede <fileclose+0x6e>
80100efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100f00:	e8 cb 1c 00 00       	call   80102bd0 <begin_op>
    iput(ff.ip);
80100f05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f08:	89 04 24             	mov    %eax,(%esp)
80100f0b:	e8 00 09 00 00       	call   80101810 <iput>
    end_op();
  }
}
80100f10:	83 c4 1c             	add    $0x1c,%esp
80100f13:	5b                   	pop    %ebx
80100f14:	5e                   	pop    %esi
80100f15:	5f                   	pop    %edi
80100f16:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100f17:	e9 24 1d 00 00       	jmp    80102c40 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100f1c:	c7 04 24 58 79 10 80 	movl   $0x80107958,(%esp)
80100f23:	e8 38 f4 ff ff       	call   80100360 <panic>
80100f28:	90                   	nop
80100f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 14             	sub    $0x14,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f3a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f3d:	75 31                	jne    80100f70 <filestat+0x40>
    ilock(f->ip);
80100f3f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f42:	89 04 24             	mov    %eax,(%esp)
80100f45:	e8 b6 07 00 00       	call   80101700 <ilock>
    stati(f->ip, st);
80100f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
80100f54:	89 04 24             	mov    %eax,(%esp)
80100f57:	e8 04 0a 00 00       	call   80101960 <stati>
    iunlock(f->ip);
80100f5c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f5f:	89 04 24             	mov    %eax,(%esp)
80100f62:	e8 69 08 00 00       	call   801017d0 <iunlock>
    return 0;
  }
  return -1;
}
80100f67:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f6a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f6c:	5b                   	pop    %ebx
80100f6d:	5d                   	pop    %ebp
80100f6e:	c3                   	ret    
80100f6f:	90                   	nop
80100f70:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f78:	5b                   	pop    %ebx
80100f79:	5d                   	pop    %ebp
80100f7a:	c3                   	ret    
80100f7b:	90                   	nop
80100f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f80 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 1c             	sub    $0x1c,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f8f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f92:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f96:	74 68                	je     80101000 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f98:	8b 03                	mov    (%ebx),%eax
80100f9a:	83 f8 01             	cmp    $0x1,%eax
80100f9d:	74 49                	je     80100fe8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f9f:	83 f8 02             	cmp    $0x2,%eax
80100fa2:	75 63                	jne    80101007 <fileread+0x87>
    ilock(f->ip);
80100fa4:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa7:	89 04 24             	mov    %eax,(%esp)
80100faa:	e8 51 07 00 00       	call   80101700 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100faf:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100fb3:	8b 43 14             	mov    0x14(%ebx),%eax
80100fb6:	89 74 24 04          	mov    %esi,0x4(%esp)
80100fba:	89 44 24 08          	mov    %eax,0x8(%esp)
80100fbe:	8b 43 10             	mov    0x10(%ebx),%eax
80100fc1:	89 04 24             	mov    %eax,(%esp)
80100fc4:	e8 c7 09 00 00       	call   80101990 <readi>
80100fc9:	85 c0                	test   %eax,%eax
80100fcb:	89 c6                	mov    %eax,%esi
80100fcd:	7e 03                	jle    80100fd2 <fileread+0x52>
      f->off += r;
80100fcf:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fd2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fd5:	89 04 24             	mov    %eax,(%esp)
80100fd8:	e8 f3 07 00 00       	call   801017d0 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fdd:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fdf:	83 c4 1c             	add    $0x1c,%esp
80100fe2:	5b                   	pop    %ebx
80100fe3:	5e                   	pop    %esi
80100fe4:	5f                   	pop    %edi
80100fe5:	5d                   	pop    %ebp
80100fe6:	c3                   	ret    
80100fe7:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fe8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100feb:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fee:	83 c4 1c             	add    $0x1c,%esp
80100ff1:	5b                   	pop    %ebx
80100ff2:	5e                   	pop    %esi
80100ff3:	5f                   	pop    %edi
80100ff4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100ff5:	e9 a6 25 00 00       	jmp    801035a0 <piperead>
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80101000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101005:	eb d8                	jmp    80100fdf <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80101007:	c7 04 24 62 79 10 80 	movl   $0x80107962,(%esp)
8010100e:	e8 4d f3 ff ff       	call   80100360 <panic>
80101013:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101020 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 2c             	sub    $0x2c,%esp
80101029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010102c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010102f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101032:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101035:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010103c:	0f 84 ae 00 00 00    	je     801010f0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101042:	8b 07                	mov    (%edi),%eax
80101044:	83 f8 01             	cmp    $0x1,%eax
80101047:	0f 84 c2 00 00 00    	je     8010110f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104d:	83 f8 02             	cmp    $0x2,%eax
80101050:	0f 85 d7 00 00 00    	jne    8010112d <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101059:	31 db                	xor    %ebx,%ebx
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 31                	jg     80101090 <filewrite+0x70>
8010105f:	e9 9c 00 00 00       	jmp    80101100 <filewrite+0xe0>
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101068:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010106b:	01 47 14             	add    %eax,0x14(%edi)
8010106e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101071:	89 0c 24             	mov    %ecx,(%esp)
80101074:	e8 57 07 00 00       	call   801017d0 <iunlock>
      end_op();
80101079:	e8 c2 1b 00 00       	call   80102c40 <end_op>
8010107e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101081:	39 f0                	cmp    %esi,%eax
80101083:	0f 85 98 00 00 00    	jne    80101121 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101089:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010108b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010108e:	7e 70                	jle    80101100 <filewrite+0xe0>
      int n1 = n - i;
80101090:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101093:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101098:	29 de                	sub    %ebx,%esi
8010109a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
801010a0:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
801010a3:	e8 28 1b 00 00       	call   80102bd0 <begin_op>
      ilock(f->ip);
801010a8:	8b 47 10             	mov    0x10(%edi),%eax
801010ab:	89 04 24             	mov    %eax,(%esp)
801010ae:	e8 4d 06 00 00       	call   80101700 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010b3:	89 74 24 0c          	mov    %esi,0xc(%esp)
801010b7:	8b 47 14             	mov    0x14(%edi),%eax
801010ba:	89 44 24 08          	mov    %eax,0x8(%esp)
801010be:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010c1:	01 d8                	add    %ebx,%eax
801010c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801010c7:	8b 47 10             	mov    0x10(%edi),%eax
801010ca:	89 04 24             	mov    %eax,(%esp)
801010cd:	e8 be 09 00 00       	call   80101a90 <writei>
801010d2:	85 c0                	test   %eax,%eax
801010d4:	7f 92                	jg     80101068 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801010d6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010dc:	89 0c 24             	mov    %ecx,(%esp)
801010df:	e8 ec 06 00 00       	call   801017d0 <iunlock>
      end_op();
801010e4:	e8 57 1b 00 00       	call   80102c40 <end_op>

      if(r < 0)
801010e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ec:	85 c0                	test   %eax,%eax
801010ee:	74 91                	je     80101081 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010f0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010f8:	5b                   	pop    %ebx
801010f9:	5e                   	pop    %esi
801010fa:	5f                   	pop    %edi
801010fb:	5d                   	pop    %ebp
801010fc:	c3                   	ret    
801010fd:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101100:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80101103:	89 d8                	mov    %ebx,%eax
80101105:	75 e9                	jne    801010f0 <filewrite+0xd0>
  }
  panic("filewrite");
}
80101107:	83 c4 2c             	add    $0x2c,%esp
8010110a:	5b                   	pop    %ebx
8010110b:	5e                   	pop    %esi
8010110c:	5f                   	pop    %edi
8010110d:	5d                   	pop    %ebp
8010110e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010110f:	8b 47 0c             	mov    0xc(%edi),%eax
80101112:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101115:	83 c4 2c             	add    $0x2c,%esp
80101118:	5b                   	pop    %ebx
80101119:	5e                   	pop    %esi
8010111a:	5f                   	pop    %edi
8010111b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010111c:	e9 5f 23 00 00       	jmp    80103480 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101121:	c7 04 24 6b 79 10 80 	movl   $0x8010796b,(%esp)
80101128:	e8 33 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010112d:	c7 04 24 71 79 10 80 	movl   $0x80107971,(%esp)
80101134:	e8 27 f2 ff ff       	call   80100360 <panic>
80101139:	66 90                	xchg   %ax,%ax
8010113b:	66 90                	xchg   %ax,%ax
8010113d:	66 90                	xchg   %ax,%ax
8010113f:	90                   	nop

80101140 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 2c             	sub    $0x2c,%esp
80101149:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010114c:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101151:	85 c0                	test   %eax,%eax
80101153:	0f 84 8c 00 00 00    	je     801011e5 <balloc+0xa5>
80101159:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101160:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101163:	89 f0                	mov    %esi,%eax
80101165:	c1 f8 0c             	sar    $0xc,%eax
80101168:	03 05 f8 19 11 80    	add    0x801119f8,%eax
8010116e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101172:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101175:	89 04 24             	mov    %eax,(%esp)
80101178:	e8 53 ef ff ff       	call   801000d0 <bread>
8010117d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101180:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101185:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101188:	31 c0                	xor    %eax,%eax
8010118a:	eb 33                	jmp    801011bf <balloc+0x7f>
8010118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101190:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101193:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101195:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101197:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010119a:	83 e1 07             	and    $0x7,%ecx
8010119d:	bf 01 00 00 00       	mov    $0x1,%edi
801011a2:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011a4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011a9:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ab:	0f b6 fb             	movzbl %bl,%edi
801011ae:	85 cf                	test   %ecx,%edi
801011b0:	74 46                	je     801011f8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011b2:	83 c0 01             	add    $0x1,%eax
801011b5:	83 c6 01             	add    $0x1,%esi
801011b8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011bd:	74 05                	je     801011c4 <balloc+0x84>
801011bf:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011c2:	72 cc                	jb     80101190 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011c7:	89 04 24             	mov    %eax,(%esp)
801011ca:	e8 11 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011cf:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011d9:	3b 05 e0 19 11 80    	cmp    0x801119e0,%eax
801011df:	0f 82 7b ff ff ff    	jb     80101160 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011e5:	c7 04 24 7b 79 10 80 	movl   $0x8010797b,(%esp)
801011ec:	e8 6f f1 ff ff       	call   80100360 <panic>
801011f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011f8:	09 d9                	or     %ebx,%ecx
801011fa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011fd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101201:	89 1c 24             	mov    %ebx,(%esp)
80101204:	e8 67 1b 00 00       	call   80102d70 <log_write>
        brelse(bp);
80101209:	89 1c 24             	mov    %ebx,(%esp)
8010120c:	e8 cf ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101211:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101214:	89 74 24 04          	mov    %esi,0x4(%esp)
80101218:	89 04 24             	mov    %eax,(%esp)
8010121b:	e8 b0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101220:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101227:	00 
80101228:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010122f:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
80101230:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101232:	8d 40 5c             	lea    0x5c(%eax),%eax
80101235:	89 04 24             	mov    %eax,(%esp)
80101238:	e8 f3 3a 00 00       	call   80104d30 <memset>
  log_write(bp);
8010123d:	89 1c 24             	mov    %ebx,(%esp)
80101240:	e8 2b 1b 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101245:	89 1c 24             	mov    %ebx,(%esp)
80101248:	e8 93 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010124d:	83 c4 2c             	add    $0x2c,%esp
80101250:	89 f0                	mov    %esi,%eax
80101252:	5b                   	pop    %ebx
80101253:	5e                   	pop    %esi
80101254:	5f                   	pop    %edi
80101255:	5d                   	pop    %ebp
80101256:	c3                   	ret    
80101257:	89 f6                	mov    %esi,%esi
80101259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101260 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	89 c7                	mov    %eax,%edi
80101266:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101267:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101269:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010126f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101272:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101279:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010127c:	e8 2f 39 00 00       	call   80104bb0 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101281:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101284:	eb 14                	jmp    8010129a <iget+0x3a>
80101286:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 f6                	test   %esi,%esi
8010128a:	74 3c                	je     801012c8 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101292:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
80101298:	74 46                	je     801012e0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010129a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010129d:	85 c9                	test   %ecx,%ecx
8010129f:	7e e7                	jle    80101288 <iget+0x28>
801012a1:	39 3b                	cmp    %edi,(%ebx)
801012a3:	75 e3                	jne    80101288 <iget+0x28>
801012a5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012a8:	75 de                	jne    80101288 <iget+0x28>
      ip->ref++;
801012aa:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012ad:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012af:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012b6:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012b9:	e8 22 3a 00 00       	call   80104ce0 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
801012be:	83 c4 1c             	add    $0x1c,%esp
801012c1:	89 f0                	mov    %esi,%eax
801012c3:	5b                   	pop    %ebx
801012c4:	5e                   	pop    %esi
801012c5:	5f                   	pop    %edi
801012c6:	5d                   	pop    %ebp
801012c7:	c3                   	ret    
801012c8:	85 c9                	test   %ecx,%ecx
801012ca:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012cd:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012d3:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801012d9:	75 bf                	jne    8010129a <iget+0x3a>
801012db:	90                   	nop
801012dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012e0:	85 f6                	test   %esi,%esi
801012e2:	74 29                	je     8010130d <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012e4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012e6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012e9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801012f0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012f7:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801012fe:	e8 dd 39 00 00       	call   80104ce0 <release>

  return ip;
}
80101303:	83 c4 1c             	add    $0x1c,%esp
80101306:	89 f0                	mov    %esi,%eax
80101308:	5b                   	pop    %ebx
80101309:	5e                   	pop    %esi
8010130a:	5f                   	pop    %edi
8010130b:	5d                   	pop    %ebp
8010130c:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
8010130d:	c7 04 24 91 79 10 80 	movl   $0x80107991,(%esp)
80101314:	e8 47 f0 ff ff       	call   80100360 <panic>
80101319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101320 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
80101324:	56                   	push   %esi
80101325:	53                   	push   %ebx
80101326:	89 c3                	mov    %eax,%ebx
80101328:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010132b:	83 fa 0b             	cmp    $0xb,%edx
8010132e:	77 18                	ja     80101348 <bmap+0x28>
80101330:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101333:	8b 46 5c             	mov    0x5c(%esi),%eax
80101336:	85 c0                	test   %eax,%eax
80101338:	74 66                	je     801013a0 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010133a:	83 c4 1c             	add    $0x1c,%esp
8010133d:	5b                   	pop    %ebx
8010133e:	5e                   	pop    %esi
8010133f:	5f                   	pop    %edi
80101340:	5d                   	pop    %ebp
80101341:	c3                   	ret    
80101342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101348:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
8010134b:	83 fe 7f             	cmp    $0x7f,%esi
8010134e:	77 77                	ja     801013c7 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101350:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101356:	85 c0                	test   %eax,%eax
80101358:	74 5e                	je     801013b8 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010135a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010135e:	8b 03                	mov    (%ebx),%eax
80101360:	89 04 24             	mov    %eax,(%esp)
80101363:	e8 68 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101368:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010136c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010136e:	8b 32                	mov    (%edx),%esi
80101370:	85 f6                	test   %esi,%esi
80101372:	75 19                	jne    8010138d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101374:	8b 03                	mov    (%ebx),%eax
80101376:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101379:	e8 c2 fd ff ff       	call   80101140 <balloc>
8010137e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101381:	89 02                	mov    %eax,(%edx)
80101383:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101385:	89 3c 24             	mov    %edi,(%esp)
80101388:	e8 e3 19 00 00       	call   80102d70 <log_write>
    }
    brelse(bp);
8010138d:	89 3c 24             	mov    %edi,(%esp)
80101390:	e8 4b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101395:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101398:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010139a:	5b                   	pop    %ebx
8010139b:	5e                   	pop    %esi
8010139c:	5f                   	pop    %edi
8010139d:	5d                   	pop    %ebp
8010139e:	c3                   	ret    
8010139f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013a0:	8b 03                	mov    (%ebx),%eax
801013a2:	e8 99 fd ff ff       	call   80101140 <balloc>
801013a7:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013aa:	83 c4 1c             	add    $0x1c,%esp
801013ad:	5b                   	pop    %ebx
801013ae:	5e                   	pop    %esi
801013af:	5f                   	pop    %edi
801013b0:	5d                   	pop    %ebp
801013b1:	c3                   	ret    
801013b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013b8:	8b 03                	mov    (%ebx),%eax
801013ba:	e8 81 fd ff ff       	call   80101140 <balloc>
801013bf:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801013c5:	eb 93                	jmp    8010135a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801013c7:	c7 04 24 a1 79 10 80 	movl   $0x801079a1,(%esp)
801013ce:	e8 8d ef ff ff       	call   80100360 <panic>
801013d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013e0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	56                   	push   %esi
801013e4:	53                   	push   %ebx
801013e5:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013e8:	8b 45 08             	mov    0x8(%ebp),%eax
801013eb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013f2:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013f3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013f6:	89 04 24             	mov    %eax,(%esp)
801013f9:	e8 d2 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013fe:	89 34 24             	mov    %esi,(%esp)
80101401:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101408:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
80101409:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010140b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010140e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101412:	e8 b9 39 00 00       	call   80104dd0 <memmove>
  brelse(bp);
80101417:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010141a:	83 c4 10             	add    $0x10,%esp
8010141d:	5b                   	pop    %ebx
8010141e:	5e                   	pop    %esi
8010141f:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101420:	e9 bb ed ff ff       	jmp    801001e0 <brelse>
80101425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101430 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	89 d7                	mov    %edx,%edi
80101436:	56                   	push   %esi
80101437:	53                   	push   %ebx
80101438:	89 c3                	mov    %eax,%ebx
8010143a:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010143d:	89 04 24             	mov    %eax,(%esp)
80101440:	c7 44 24 04 e0 19 11 	movl   $0x801119e0,0x4(%esp)
80101447:	80 
80101448:	e8 93 ff ff ff       	call   801013e0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010144d:	89 fa                	mov    %edi,%edx
8010144f:	c1 ea 0c             	shr    $0xc,%edx
80101452:	03 15 f8 19 11 80    	add    0x801119f8,%edx
80101458:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010145b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101460:	89 54 24 04          	mov    %edx,0x4(%esp)
80101464:	e8 67 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101469:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010146b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101471:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101473:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101476:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101479:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010147b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010147d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101482:	0f b6 c8             	movzbl %al,%ecx
80101485:	85 d9                	test   %ebx,%ecx
80101487:	74 20                	je     801014a9 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101489:	f7 d3                	not    %ebx
8010148b:	21 c3                	and    %eax,%ebx
8010148d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101491:	89 34 24             	mov    %esi,(%esp)
80101494:	e8 d7 18 00 00       	call   80102d70 <log_write>
  brelse(bp);
80101499:	89 34 24             	mov    %esi,(%esp)
8010149c:	e8 3f ed ff ff       	call   801001e0 <brelse>
}
801014a1:	83 c4 1c             	add    $0x1c,%esp
801014a4:	5b                   	pop    %ebx
801014a5:	5e                   	pop    %esi
801014a6:	5f                   	pop    %edi
801014a7:	5d                   	pop    %ebp
801014a8:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
801014a9:	c7 04 24 b4 79 10 80 	movl   $0x801079b4,(%esp)
801014b0:	e8 ab ee ff ff       	call   80100360 <panic>
801014b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014c0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	53                   	push   %ebx
801014c4:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
801014c9:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801014cc:	c7 44 24 04 c7 79 10 	movl   $0x801079c7,0x4(%esp)
801014d3:	80 
801014d4:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801014db:	e8 50 36 00 00       	call   80104b30 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	89 1c 24             	mov    %ebx,(%esp)
801014e3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014e9:	c7 44 24 04 ce 79 10 	movl   $0x801079ce,0x4(%esp)
801014f0:	80 
801014f1:	e8 2a 35 00 00       	call   80104a20 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014f6:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014fc:	75 e2                	jne    801014e0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
801014fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101501:	c7 44 24 04 e0 19 11 	movl   $0x801119e0,0x4(%esp)
80101508:	80 
80101509:	89 04 24             	mov    %eax,(%esp)
8010150c:	e8 cf fe ff ff       	call   801013e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101511:	a1 f8 19 11 80       	mov    0x801119f8,%eax
80101516:	c7 04 24 24 7a 10 80 	movl   $0x80107a24,(%esp)
8010151d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101521:	a1 f4 19 11 80       	mov    0x801119f4,%eax
80101526:	89 44 24 18          	mov    %eax,0x18(%esp)
8010152a:	a1 f0 19 11 80       	mov    0x801119f0,%eax
8010152f:	89 44 24 14          	mov    %eax,0x14(%esp)
80101533:	a1 ec 19 11 80       	mov    0x801119ec,%eax
80101538:	89 44 24 10          	mov    %eax,0x10(%esp)
8010153c:	a1 e8 19 11 80       	mov    0x801119e8,%eax
80101541:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101545:	a1 e4 19 11 80       	mov    0x801119e4,%eax
8010154a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010154e:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101553:	89 44 24 04          	mov    %eax,0x4(%esp)
80101557:	e8 f4 f0 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010155c:	83 c4 24             	add    $0x24,%esp
8010155f:	5b                   	pop    %ebx
80101560:	5d                   	pop    %ebp
80101561:	c3                   	ret    
80101562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101570 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	57                   	push   %edi
80101574:	56                   	push   %esi
80101575:	53                   	push   %ebx
80101576:	83 ec 2c             	sub    $0x2c,%esp
80101579:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010157c:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101583:	8b 7d 08             	mov    0x8(%ebp),%edi
80101586:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101589:	0f 86 a2 00 00 00    	jbe    80101631 <ialloc+0xc1>
8010158f:	be 01 00 00 00       	mov    $0x1,%esi
80101594:	bb 01 00 00 00       	mov    $0x1,%ebx
80101599:	eb 1a                	jmp    801015b5 <ialloc+0x45>
8010159b:	90                   	nop
8010159c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015a0:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015a3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015a6:	e8 35 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015ab:	89 de                	mov    %ebx,%esi
801015ad:	3b 1d e8 19 11 80    	cmp    0x801119e8,%ebx
801015b3:	73 7c                	jae    80101631 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
801015b5:	89 f0                	mov    %esi,%eax
801015b7:	c1 e8 03             	shr    $0x3,%eax
801015ba:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801015c0:	89 3c 24             	mov    %edi,(%esp)
801015c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
801015cc:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
801015ce:	89 f0                	mov    %esi,%eax
801015d0:	83 e0 07             	and    $0x7,%eax
801015d3:	c1 e0 06             	shl    $0x6,%eax
801015d6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015da:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015de:	75 c0                	jne    801015a0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015e0:	89 0c 24             	mov    %ecx,(%esp)
801015e3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015ea:	00 
801015eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015f2:	00 
801015f3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015f9:	e8 32 37 00 00       	call   80104d30 <memset>
      dip->type = type;
801015fe:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
80101602:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
80101605:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
80101608:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
8010160b:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010160e:	89 14 24             	mov    %edx,(%esp)
80101611:	e8 5a 17 00 00       	call   80102d70 <log_write>
      brelse(bp);
80101616:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101619:	89 14 24             	mov    %edx,(%esp)
8010161c:	e8 bf eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101621:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101624:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101626:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101627:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101629:	5e                   	pop    %esi
8010162a:	5f                   	pop    %edi
8010162b:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010162c:	e9 2f fc ff ff       	jmp    80101260 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101631:	c7 04 24 d4 79 10 80 	movl   $0x801079d4,(%esp)
80101638:	e8 23 ed ff ff       	call   80100360 <panic>
8010163d:	8d 76 00             	lea    0x0(%esi),%esi

80101640 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	56                   	push   %esi
80101644:	53                   	push   %ebx
80101645:	83 ec 10             	sub    $0x10,%esp
80101648:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010164b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010164e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101651:	c1 e8 03             	shr    $0x3,%eax
80101654:	03 05 f4 19 11 80    	add    0x801119f4,%eax
8010165a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010165e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101661:	89 04 24             	mov    %eax,(%esp)
80101664:	e8 67 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101669:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010166c:	83 e2 07             	and    $0x7,%edx
8010166f:	c1 e2 06             	shl    $0x6,%edx
80101672:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101676:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101678:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010167c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010167f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101683:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101687:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010168b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010168f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101693:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101697:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010169b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010169e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016a1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801016a5:	89 14 24             	mov    %edx,(%esp)
801016a8:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801016af:	00 
801016b0:	e8 1b 37 00 00       	call   80104dd0 <memmove>
  log_write(bp);
801016b5:	89 34 24             	mov    %esi,(%esp)
801016b8:	e8 b3 16 00 00       	call   80102d70 <log_write>
  brelse(bp);
801016bd:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016c0:	83 c4 10             	add    $0x10,%esp
801016c3:	5b                   	pop    %ebx
801016c4:	5e                   	pop    %esi
801016c5:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801016c6:	e9 15 eb ff ff       	jmp    801001e0 <brelse>
801016cb:	90                   	nop
801016cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016d0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	53                   	push   %ebx
801016d4:	83 ec 14             	sub    $0x14,%esp
801016d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016da:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801016e1:	e8 ca 34 00 00       	call   80104bb0 <acquire>
  ip->ref++;
801016e6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016ea:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801016f1:	e8 ea 35 00 00       	call   80104ce0 <release>
  return ip;
}
801016f6:	83 c4 14             	add    $0x14,%esp
801016f9:	89 d8                	mov    %ebx,%eax
801016fb:	5b                   	pop    %ebx
801016fc:	5d                   	pop    %ebp
801016fd:	c3                   	ret    
801016fe:	66 90                	xchg   %ax,%ax

80101700 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	56                   	push   %esi
80101704:	53                   	push   %ebx
80101705:	83 ec 10             	sub    $0x10,%esp
80101708:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010170b:	85 db                	test   %ebx,%ebx
8010170d:	0f 84 b0 00 00 00    	je     801017c3 <ilock+0xc3>
80101713:	8b 43 08             	mov    0x8(%ebx),%eax
80101716:	85 c0                	test   %eax,%eax
80101718:	0f 8e a5 00 00 00    	jle    801017c3 <ilock+0xc3>
    panic("ilock");

  acquiresleep(&ip->lock);
8010171e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101721:	89 04 24             	mov    %eax,(%esp)
80101724:	e8 37 33 00 00       	call   80104a60 <acquiresleep>

  if(!(ip->flags & I_VALID)){
80101729:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
8010172d:	74 09                	je     80101738 <ilock+0x38>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
8010172f:	83 c4 10             	add    $0x10,%esp
80101732:	5b                   	pop    %ebx
80101733:	5e                   	pop    %esi
80101734:	5d                   	pop    %ebp
80101735:	c3                   	ret    
80101736:	66 90                	xchg   %ax,%ax
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101738:	8b 43 04             	mov    0x4(%ebx),%eax
8010173b:	c1 e8 03             	shr    $0x3,%eax
8010173e:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101744:	89 44 24 04          	mov    %eax,0x4(%esp)
80101748:	8b 03                	mov    (%ebx),%eax
8010174a:	89 04 24             	mov    %eax,(%esp)
8010174d:	e8 7e e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101752:	8b 53 04             	mov    0x4(%ebx),%edx
80101755:	83 e2 07             	and    $0x7,%edx
80101758:	c1 e2 06             	shl    $0x6,%edx
8010175b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010175f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101761:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101764:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101767:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010176b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010176f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101773:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101777:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010177b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010177f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101783:	8b 42 fc             	mov    -0x4(%edx),%eax
80101786:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101789:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010178c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101790:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101797:	00 
80101798:	89 04 24             	mov    %eax,(%esp)
8010179b:	e8 30 36 00 00       	call   80104dd0 <memmove>
    brelse(bp);
801017a0:	89 34 24             	mov    %esi,(%esp)
801017a3:	e8 38 ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
801017a8:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
801017ac:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801017b1:	0f 85 78 ff ff ff    	jne    8010172f <ilock+0x2f>
      panic("ilock: no type");
801017b7:	c7 04 24 ec 79 10 80 	movl   $0x801079ec,(%esp)
801017be:	e8 9d eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801017c3:	c7 04 24 e6 79 10 80 	movl   $0x801079e6,(%esp)
801017ca:	e8 91 eb ff ff       	call   80100360 <panic>
801017cf:	90                   	nop

801017d0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	56                   	push   %esi
801017d4:	53                   	push   %ebx
801017d5:	83 ec 10             	sub    $0x10,%esp
801017d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017db:	85 db                	test   %ebx,%ebx
801017dd:	74 24                	je     80101803 <iunlock+0x33>
801017df:	8d 73 0c             	lea    0xc(%ebx),%esi
801017e2:	89 34 24             	mov    %esi,(%esp)
801017e5:	e8 16 33 00 00       	call   80104b00 <holdingsleep>
801017ea:	85 c0                	test   %eax,%eax
801017ec:	74 15                	je     80101803 <iunlock+0x33>
801017ee:	8b 43 08             	mov    0x8(%ebx),%eax
801017f1:	85 c0                	test   %eax,%eax
801017f3:	7e 0e                	jle    80101803 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017f5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017f8:	83 c4 10             	add    $0x10,%esp
801017fb:	5b                   	pop    %ebx
801017fc:	5e                   	pop    %esi
801017fd:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017fe:	e9 bd 32 00 00       	jmp    80104ac0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101803:	c7 04 24 fb 79 10 80 	movl   $0x801079fb,(%esp)
8010180a:	e8 51 eb ff ff       	call   80100360 <panic>
8010180f:	90                   	nop

80101810 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	57                   	push   %edi
80101814:	56                   	push   %esi
80101815:	53                   	push   %ebx
80101816:	83 ec 1c             	sub    $0x1c,%esp
80101819:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010181c:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101823:	e8 88 33 00 00       	call   80104bb0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101828:	8b 46 08             	mov    0x8(%esi),%eax
8010182b:	83 f8 01             	cmp    $0x1,%eax
8010182e:	74 20                	je     80101850 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
80101830:	83 e8 01             	sub    $0x1,%eax
80101833:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101836:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
8010183d:	83 c4 1c             	add    $0x1c,%esp
80101840:	5b                   	pop    %ebx
80101841:	5e                   	pop    %esi
80101842:	5f                   	pop    %edi
80101843:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
80101844:	e9 97 34 00 00       	jmp    80104ce0 <release>
80101849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101850:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
80101854:	74 da                	je     80101830 <iput+0x20>
80101856:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
8010185b:	75 d3                	jne    80101830 <iput+0x20>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
8010185d:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101864:	89 f3                	mov    %esi,%ebx
80101866:	e8 75 34 00 00       	call   80104ce0 <release>
8010186b:	8d 7e 30             	lea    0x30(%esi),%edi
8010186e:	eb 07                	jmp    80101877 <iput+0x67>
80101870:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101873:	39 fb                	cmp    %edi,%ebx
80101875:	74 19                	je     80101890 <iput+0x80>
    if(ip->addrs[i]){
80101877:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010187a:	85 d2                	test   %edx,%edx
8010187c:	74 f2                	je     80101870 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
8010187e:	8b 06                	mov    (%esi),%eax
80101880:	e8 ab fb ff ff       	call   80101430 <bfree>
      ip->addrs[i] = 0;
80101885:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010188c:	eb e2                	jmp    80101870 <iput+0x60>
8010188e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101890:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101896:	85 c0                	test   %eax,%eax
80101898:	75 3e                	jne    801018d8 <iput+0xc8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010189a:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018a1:	89 34 24             	mov    %esi,(%esp)
801018a4:	e8 97 fd ff ff       	call   80101640 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
801018a9:	31 c0                	xor    %eax,%eax
801018ab:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
801018af:	89 34 24             	mov    %esi,(%esp)
801018b2:	e8 89 fd ff ff       	call   80101640 <iupdate>
    acquire(&icache.lock);
801018b7:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801018be:	e8 ed 32 00 00       	call   80104bb0 <acquire>
801018c3:	8b 46 08             	mov    0x8(%esi),%eax
    ip->flags = 0;
801018c6:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018cd:	e9 5e ff ff ff       	jmp    80101830 <iput+0x20>
801018d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018dc:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018de:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e0:	89 04 24             	mov    %eax,(%esp)
801018e3:	e8 e8 e7 ff ff       	call   801000d0 <bread>
801018e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018eb:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
801018ee:	31 c0                	xor    %eax,%eax
801018f0:	eb 13                	jmp    80101905 <iput+0xf5>
801018f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018f8:	83 c3 01             	add    $0x1,%ebx
801018fb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101901:	89 d8                	mov    %ebx,%eax
80101903:	74 10                	je     80101915 <iput+0x105>
      if(a[j])
80101905:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101908:	85 d2                	test   %edx,%edx
8010190a:	74 ec                	je     801018f8 <iput+0xe8>
        bfree(ip->dev, a[j]);
8010190c:	8b 06                	mov    (%esi),%eax
8010190e:	e8 1d fb ff ff       	call   80101430 <bfree>
80101913:	eb e3                	jmp    801018f8 <iput+0xe8>
    }
    brelse(bp);
80101915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101918:	89 04 24             	mov    %eax,(%esp)
8010191b:	e8 c0 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101920:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101926:	8b 06                	mov    (%esi),%eax
80101928:	e8 03 fb ff ff       	call   80101430 <bfree>
    ip->addrs[NDIRECT] = 0;
8010192d:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101934:	00 00 00 
80101937:	e9 5e ff ff ff       	jmp    8010189a <iput+0x8a>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	53                   	push   %ebx
80101944:	83 ec 14             	sub    $0x14,%esp
80101947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010194a:	89 1c 24             	mov    %ebx,(%esp)
8010194d:	e8 7e fe ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101952:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101955:	83 c4 14             	add    $0x14,%esp
80101958:	5b                   	pop    %ebx
80101959:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010195a:	e9 b1 fe ff ff       	jmp    80101810 <iput>
8010195f:	90                   	nop

80101960 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	8b 55 08             	mov    0x8(%ebp),%edx
80101966:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101969:	8b 0a                	mov    (%edx),%ecx
8010196b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010196e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101971:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101974:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101978:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010197b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010197f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101983:	8b 52 58             	mov    0x58(%edx),%edx
80101986:	89 50 10             	mov    %edx,0x10(%eax)
}
80101989:	5d                   	pop    %ebp
8010198a:	c3                   	ret    
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	57                   	push   %edi
80101994:	56                   	push   %esi
80101995:	53                   	push   %ebx
80101996:	83 ec 2c             	sub    $0x2c,%esp
80101999:	8b 45 0c             	mov    0xc(%ebp),%eax
8010199c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010199f:	8b 75 10             	mov    0x10(%ebp),%esi
801019a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019a5:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a8:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019b0:	0f 84 aa 00 00 00    	je     80101a60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019b6:	8b 47 58             	mov    0x58(%edi),%eax
801019b9:	39 f0                	cmp    %esi,%eax
801019bb:	0f 82 c7 00 00 00    	jb     80101a88 <readi+0xf8>
801019c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019c4:	89 da                	mov    %ebx,%edx
801019c6:	01 f2                	add    %esi,%edx
801019c8:	0f 82 ba 00 00 00    	jb     80101a88 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ce:	89 c1                	mov    %eax,%ecx
801019d0:	29 f1                	sub    %esi,%ecx
801019d2:	39 d0                	cmp    %edx,%eax
801019d4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d7:	31 c0                	xor    %eax,%eax
801019d9:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019db:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019de:	74 70                	je     80101a50 <readi+0xc0>
801019e0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019e3:	89 c7                	mov    %eax,%edi
801019e5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019eb:	89 f2                	mov    %esi,%edx
801019ed:	c1 ea 09             	shr    $0x9,%edx
801019f0:	89 d8                	mov    %ebx,%eax
801019f2:	e8 29 f9 ff ff       	call   80101320 <bmap>
801019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019fb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019fd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a02:	89 04 24             	mov    %eax,(%esp)
80101a05:	e8 c6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a0d:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a0f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a11:	89 f0                	mov    %esi,%eax
80101a13:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a18:	29 c3                	sub    %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a1a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1e:	39 cb                	cmp    %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a20:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a27:	0f 47 d9             	cmova  %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a2a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a2e:	01 df                	add    %ebx,%edi
80101a30:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
80101a32:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a35:	89 04 24             	mov    %eax,(%esp)
80101a38:	e8 93 33 00 00       	call   80104dd0 <memmove>
    brelse(bp);
80101a3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a40:	89 14 24             	mov    %edx,(%esp)
80101a43:	e8 98 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a48:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a4b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a4e:	77 98                	ja     801019e8 <readi+0x58>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a53:	83 c4 2c             	add    $0x2c,%esp
80101a56:	5b                   	pop    %ebx
80101a57:	5e                   	pop    %esi
80101a58:	5f                   	pop    %edi
80101a59:	5d                   	pop    %ebp
80101a5a:	c3                   	ret    
80101a5b:	90                   	nop
80101a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a60:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a64:	66 83 f8 09          	cmp    $0x9,%ax
80101a68:	77 1e                	ja     80101a88 <readi+0xf8>
80101a6a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101a71:	85 c0                	test   %eax,%eax
80101a73:	74 13                	je     80101a88 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a75:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a78:	89 75 10             	mov    %esi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a7b:	83 c4 2c             	add    $0x2c,%esp
80101a7e:	5b                   	pop    %ebx
80101a7f:	5e                   	pop    %esi
80101a80:	5f                   	pop    %edi
80101a81:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a82:	ff e0                	jmp    *%eax
80101a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a8d:	eb c4                	jmp    80101a53 <readi+0xc3>
80101a8f:	90                   	nop

80101a90 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 2c             	sub    $0x2c,%esp
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a9f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101aa7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aaa:	8b 75 10             	mov    0x10(%ebp),%esi
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab3:	0f 84 b7 00 00 00    	je     80101b70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	39 70 58             	cmp    %esi,0x58(%eax)
80101abf:	0f 82 e3 00 00 00    	jb     80101ba8 <writei+0x118>
80101ac5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ac8:	89 c8                	mov    %ecx,%eax
80101aca:	01 f0                	add    %esi,%eax
80101acc:	0f 82 d6 00 00 00    	jb     80101ba8 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ad2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ad7:	0f 87 cb 00 00 00    	ja     80101ba8 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101add:	85 c9                	test   %ecx,%ecx
80101adf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ae6:	74 77                	je     80101b5f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aeb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aed:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af2:	c1 ea 09             	shr    $0x9,%edx
80101af5:	89 f8                	mov    %edi,%eax
80101af7:	e8 24 f8 ff ff       	call   80101320 <bmap>
80101afc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b00:	8b 07                	mov    (%edi),%eax
80101b02:	89 04 24             	mov    %eax,(%esp)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b0d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b10:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b13:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b15:	89 f0                	mov    %esi,%eax
80101b17:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1c:	29 c3                	sub    %eax,%ebx
80101b1e:	39 cb                	cmp    %ecx,%ebx
80101b20:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b27:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b29:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b2d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b31:	89 04 24             	mov    %eax,(%esp)
80101b34:	e8 97 32 00 00       	call   80104dd0 <memmove>
    log_write(bp);
80101b39:	89 3c 24             	mov    %edi,(%esp)
80101b3c:	e8 2f 12 00 00       	call   80102d70 <log_write>
    brelse(bp);
80101b41:	89 3c 24             	mov    %edi,(%esp)
80101b44:	e8 97 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b49:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b4f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b52:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b55:	77 91                	ja     80101ae8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b57:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b5d:	72 39                	jb     80101b98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b62:	83 c4 2c             	add    $0x2c,%esp
80101b65:	5b                   	pop    %ebx
80101b66:	5e                   	pop    %esi
80101b67:	5f                   	pop    %edi
80101b68:	5d                   	pop    %ebp
80101b69:	c3                   	ret    
80101b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 2e                	ja     80101ba8 <writei+0x118>
80101b7a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 23                	je     80101ba8 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b85:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b88:	83 c4 2c             	add    $0x2c,%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b8f:	ff e0                	jmp    *%eax
80101b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b9b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b9e:	89 04 24             	mov    %eax,(%esp)
80101ba1:	e8 9a fa ff ff       	call   80101640 <iupdate>
80101ba6:	eb b7                	jmp    80101b5f <writei+0xcf>
  }
  return n;
}
80101ba8:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101bb0:	5b                   	pop    %ebx
80101bb1:	5e                   	pop    %esi
80101bb2:	5f                   	pop    %edi
80101bb3:	5d                   	pop    %ebp
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bc9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bd0:	00 
80101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd8:	89 04 24             	mov    %eax,(%esp)
80101bdb:	e8 70 32 00 00       	call   80104e50 <strncmp>
}
80101be0:	c9                   	leave  
80101be1:	c3                   	ret    
80101be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 2c             	sub    $0x2c,%esp
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c01:	0f 85 97 00 00 00    	jne    80101c9e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c07:	8b 53 58             	mov    0x58(%ebx),%edx
80101c0a:	31 ff                	xor    %edi,%edi
80101c0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c0f:	85 d2                	test   %edx,%edx
80101c11:	75 0d                	jne    80101c20 <dirlookup+0x30>
80101c13:	eb 73                	jmp    80101c88 <dirlookup+0x98>
80101c15:	8d 76 00             	lea    0x0(%esi),%esi
80101c18:	83 c7 10             	add    $0x10,%edi
80101c1b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c1e:	76 68                	jbe    80101c88 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c20:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c27:	00 
80101c28:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c2c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c30:	89 1c 24             	mov    %ebx,(%esp)
80101c33:	e8 58 fd ff ff       	call   80101990 <readi>
80101c38:	83 f8 10             	cmp    $0x10,%eax
80101c3b:	75 55                	jne    80101c92 <dirlookup+0xa2>
      panic("dirlink read");
    if(de.inum == 0)
80101c3d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c42:	74 d4                	je     80101c18 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c4e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c55:	00 
80101c56:	89 04 24             	mov    %eax,(%esp)
80101c59:	e8 f2 31 00 00       	call   80104e50 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c5e:	85 c0                	test   %eax,%eax
80101c60:	75 b6                	jne    80101c18 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c62:	8b 45 10             	mov    0x10(%ebp),%eax
80101c65:	85 c0                	test   %eax,%eax
80101c67:	74 05                	je     80101c6e <dirlookup+0x7e>
        *poff = off;
80101c69:	8b 45 10             	mov    0x10(%ebp),%eax
80101c6c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c6e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c72:	8b 03                	mov    (%ebx),%eax
80101c74:	e8 e7 f5 ff ff       	call   80101260 <iget>
    }
  }

  return 0;
}
80101c79:	83 c4 2c             	add    $0x2c,%esp
80101c7c:	5b                   	pop    %ebx
80101c7d:	5e                   	pop    %esi
80101c7e:	5f                   	pop    %edi
80101c7f:	5d                   	pop    %ebp
80101c80:	c3                   	ret    
80101c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c88:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c8b:	31 c0                	xor    %eax,%eax
}
80101c8d:	5b                   	pop    %ebx
80101c8e:	5e                   	pop    %esi
80101c8f:	5f                   	pop    %edi
80101c90:	5d                   	pop    %ebp
80101c91:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101c92:	c7 04 24 15 7a 10 80 	movl   $0x80107a15,(%esp)
80101c99:	e8 c2 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c9e:	c7 04 24 03 7a 10 80 	movl   $0x80107a03,(%esp)
80101ca5:	e8 b6 e6 ff ff       	call   80100360 <panic>
80101caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cb0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	57                   	push   %edi
80101cb4:	89 cf                	mov    %ecx,%edi
80101cb6:	56                   	push   %esi
80101cb7:	53                   	push   %ebx
80101cb8:	89 c3                	mov    %eax,%ebx
80101cba:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cbd:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101cc3:	0f 84 51 01 00 00    	je     80101e1a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101cc9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101ccf:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cd2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101cd9:	e8 d2 2e 00 00       	call   80104bb0 <acquire>
  ip->ref++;
80101cde:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ce2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101ce9:	e8 f2 2f 00 00       	call   80104ce0 <release>
80101cee:	eb 03                	jmp    80101cf3 <namex+0x43>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cf0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cf3:	0f b6 03             	movzbl (%ebx),%eax
80101cf6:	3c 2f                	cmp    $0x2f,%al
80101cf8:	74 f6                	je     80101cf0 <namex+0x40>
    path++;
  if(*path == 0)
80101cfa:	84 c0                	test   %al,%al
80101cfc:	0f 84 ed 00 00 00    	je     80101def <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d02:	0f b6 03             	movzbl (%ebx),%eax
80101d05:	89 da                	mov    %ebx,%edx
80101d07:	84 c0                	test   %al,%al
80101d09:	0f 84 b1 00 00 00    	je     80101dc0 <namex+0x110>
80101d0f:	3c 2f                	cmp    $0x2f,%al
80101d11:	75 0f                	jne    80101d22 <namex+0x72>
80101d13:	e9 a8 00 00 00       	jmp    80101dc0 <namex+0x110>
80101d18:	3c 2f                	cmp    $0x2f,%al
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d20:	74 0a                	je     80101d2c <namex+0x7c>
    path++;
80101d22:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d25:	0f b6 02             	movzbl (%edx),%eax
80101d28:	84 c0                	test   %al,%al
80101d2a:	75 ec                	jne    80101d18 <namex+0x68>
80101d2c:	89 d1                	mov    %edx,%ecx
80101d2e:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d30:	83 f9 0d             	cmp    $0xd,%ecx
80101d33:	0f 8e 8f 00 00 00    	jle    80101dc8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d39:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d3d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d44:	00 
80101d45:	89 3c 24             	mov    %edi,(%esp)
80101d48:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d4b:	e8 80 30 00 00       	call   80104dd0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d53:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d55:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d58:	75 0e                	jne    80101d68 <namex+0xb8>
80101d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d60:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d63:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d66:	74 f8                	je     80101d60 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d68:	89 34 24             	mov    %esi,(%esp)
80101d6b:	e8 90 f9 ff ff       	call   80101700 <ilock>
    if(ip->type != T_DIR){
80101d70:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d75:	0f 85 85 00 00 00    	jne    80101e00 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d7e:	85 d2                	test   %edx,%edx
80101d80:	74 09                	je     80101d8b <namex+0xdb>
80101d82:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d85:	0f 84 a5 00 00 00    	je     80101e30 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d92:	00 
80101d93:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d97:	89 34 24             	mov    %esi,(%esp)
80101d9a:	e8 51 fe ff ff       	call   80101bf0 <dirlookup>
80101d9f:	85 c0                	test   %eax,%eax
80101da1:	74 5d                	je     80101e00 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101da3:	89 34 24             	mov    %esi,(%esp)
80101da6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101da9:	e8 22 fa ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101dae:	89 34 24             	mov    %esi,(%esp)
80101db1:	e8 5a fa ff ff       	call   80101810 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101db9:	89 c6                	mov    %eax,%esi
80101dbb:	e9 33 ff ff ff       	jmp    80101cf3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101dc0:	31 c9                	xor    %ecx,%ecx
80101dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101dc8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dcc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101dd0:	89 3c 24             	mov    %edi,(%esp)
80101dd3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dd6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dd9:	e8 f2 2f 00 00       	call   80104dd0 <memmove>
    name[len] = 0;
80101dde:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101de1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101de4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101de8:	89 d3                	mov    %edx,%ebx
80101dea:	e9 66 ff ff ff       	jmp    80101d55 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101def:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101df2:	85 c0                	test   %eax,%eax
80101df4:	75 4c                	jne    80101e42 <namex+0x192>
80101df6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101df8:	83 c4 2c             	add    $0x2c,%esp
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5f                   	pop    %edi
80101dfe:	5d                   	pop    %ebp
80101dff:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e00:	89 34 24             	mov    %esi,(%esp)
80101e03:	e8 c8 f9 ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101e08:	89 34 24             	mov    %esi,(%esp)
80101e0b:	e8 00 fa ff ff       	call   80101810 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e10:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e13:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e15:	5b                   	pop    %ebx
80101e16:	5e                   	pop    %esi
80101e17:	5f                   	pop    %edi
80101e18:	5d                   	pop    %ebp
80101e19:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e1a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e1f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e24:	e8 37 f4 ff ff       	call   80101260 <iget>
80101e29:	89 c6                	mov    %eax,%esi
80101e2b:	e9 c3 fe ff ff       	jmp    80101cf3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e30:	89 34 24             	mov    %esi,(%esp)
80101e33:	e8 98 f9 ff ff       	call   801017d0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e38:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e3b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e3d:	5b                   	pop    %ebx
80101e3e:	5e                   	pop    %esi
80101e3f:	5f                   	pop    %edi
80101e40:	5d                   	pop    %ebp
80101e41:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e42:	89 34 24             	mov    %esi,(%esp)
80101e45:	e8 c6 f9 ff ff       	call   80101810 <iput>
    return 0;
80101e4a:	31 c0                	xor    %eax,%eax
80101e4c:	eb aa                	jmp    80101df8 <namex+0x148>
80101e4e:	66 90                	xchg   %ax,%ax

80101e50 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 2c             	sub    $0x2c,%esp
80101e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e66:	00 
80101e67:	89 1c 24             	mov    %ebx,(%esp)
80101e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e6e:	e8 7d fd ff ff       	call   80101bf0 <dirlookup>
80101e73:	85 c0                	test   %eax,%eax
80101e75:	0f 85 8b 00 00 00    	jne    80101f06 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e7b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e7e:	31 ff                	xor    %edi,%edi
80101e80:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e83:	85 c0                	test   %eax,%eax
80101e85:	75 13                	jne    80101e9a <dirlink+0x4a>
80101e87:	eb 35                	jmp    80101ebe <dirlink+0x6e>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8d 57 10             	lea    0x10(%edi),%edx
80101e93:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e96:	89 d7                	mov    %edx,%edi
80101e98:	76 24                	jbe    80101ebe <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ea1:	00 
80101ea2:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ea6:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eaa:	89 1c 24             	mov    %ebx,(%esp)
80101ead:	e8 de fa ff ff       	call   80101990 <readi>
80101eb2:	83 f8 10             	cmp    $0x10,%eax
80101eb5:	75 5e                	jne    80101f15 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101eb7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ebc:	75 d2                	jne    80101e90 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ec8:	00 
80101ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ecd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ed0:	89 04 24             	mov    %eax,(%esp)
80101ed3:	e8 e8 2f 00 00       	call   80104ec0 <strncpy>
  de.inum = inum;
80101ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101edb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ee2:	00 
80101ee3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ee7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eeb:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101eee:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ef2:	e8 99 fb ff ff       	call   80101a90 <writei>
80101ef7:	83 f8 10             	cmp    $0x10,%eax
80101efa:	75 25                	jne    80101f21 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101efc:	31 c0                	xor    %eax,%eax
}
80101efe:	83 c4 2c             	add    $0x2c,%esp
80101f01:	5b                   	pop    %ebx
80101f02:	5e                   	pop    %esi
80101f03:	5f                   	pop    %edi
80101f04:	5d                   	pop    %ebp
80101f05:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f06:	89 04 24             	mov    %eax,(%esp)
80101f09:	e8 02 f9 ff ff       	call   80101810 <iput>
    return -1;
80101f0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f13:	eb e9                	jmp    80101efe <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f15:	c7 04 24 15 7a 10 80 	movl   $0x80107a15,(%esp)
80101f1c:	e8 3f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f21:	c7 04 24 82 80 10 80 	movl   $0x80108082,(%esp)
80101f28:	e8 33 e4 ff ff       	call   80100360 <panic>
80101f2d:	8d 76 00             	lea    0x0(%esi),%esi

80101f30 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f30:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f31:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f33:	89 e5                	mov    %esp,%ebp
80101f35:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f38:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f3e:	e8 6d fd ff ff       	call   80101cb0 <namex>
}
80101f43:	c9                   	leave  
80101f44:	c3                   	ret    
80101f45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f50 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f50:	55                   	push   %ebp
  return namex(path, 1, name);
80101f51:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f56:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f5e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f5f:	e9 4c fd ff ff       	jmp    80101cb0 <namex>
80101f64:	66 90                	xchg   %ax,%ax
80101f66:	66 90                	xchg   %ax,%ax
80101f68:	66 90                	xchg   %ax,%ax
80101f6a:	66 90                	xchg   %ax,%ax
80101f6c:	66 90                	xchg   %ax,%ax
80101f6e:	66 90                	xchg   %ax,%ax

80101f70 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	56                   	push   %esi
80101f74:	89 c6                	mov    %eax,%esi
80101f76:	53                   	push   %ebx
80101f77:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f7a:	85 c0                	test   %eax,%eax
80101f7c:	0f 84 99 00 00 00    	je     8010201b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f82:	8b 48 08             	mov    0x8(%eax),%ecx
80101f85:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f8b:	0f 87 7e 00 00 00    	ja     8010200f <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f91:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f96:	66 90                	xchg   %ax,%ax
80101f98:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f99:	83 e0 c0             	and    $0xffffffc0,%eax
80101f9c:	3c 40                	cmp    $0x40,%al
80101f9e:	75 f8                	jne    80101f98 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fa0:	31 db                	xor    %ebx,%ebx
80101fa2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fa7:	89 d8                	mov    %ebx,%eax
80101fa9:	ee                   	out    %al,(%dx)
80101faa:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101faf:	b8 01 00 00 00       	mov    $0x1,%eax
80101fb4:	ee                   	out    %al,(%dx)
80101fb5:	0f b6 c1             	movzbl %cl,%eax
80101fb8:	b2 f3                	mov    $0xf3,%dl
80101fba:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fbb:	89 c8                	mov    %ecx,%eax
80101fbd:	b2 f4                	mov    $0xf4,%dl
80101fbf:	c1 f8 08             	sar    $0x8,%eax
80101fc2:	ee                   	out    %al,(%dx)
80101fc3:	b2 f5                	mov    $0xf5,%dl
80101fc5:	89 d8                	mov    %ebx,%eax
80101fc7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fc8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fcc:	b2 f6                	mov    $0xf6,%dl
80101fce:	83 e0 01             	and    $0x1,%eax
80101fd1:	c1 e0 04             	shl    $0x4,%eax
80101fd4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fd7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fd8:	f6 06 04             	testb  $0x4,(%esi)
80101fdb:	75 13                	jne    80101ff0 <idestart+0x80>
80101fdd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fe2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fe7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
80101fef:	90                   	nop
80101ff0:	b2 f7                	mov    $0xf7,%dl
80101ff2:	b8 30 00 00 00       	mov    $0x30,%eax
80101ff7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101ff8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101ffd:	83 c6 5c             	add    $0x5c,%esi
80102000:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102005:	fc                   	cld    
80102006:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102008:	83 c4 10             	add    $0x10,%esp
8010200b:	5b                   	pop    %ebx
8010200c:	5e                   	pop    %esi
8010200d:	5d                   	pop    %ebp
8010200e:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010200f:	c7 04 24 80 7a 10 80 	movl   $0x80107a80,(%esp)
80102016:	e8 45 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010201b:	c7 04 24 77 7a 10 80 	movl   $0x80107a77,(%esp)
80102022:	e8 39 e3 ff ff       	call   80100360 <panic>
80102027:	89 f6                	mov    %esi,%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102036:	c7 44 24 04 92 7a 10 	movl   $0x80107a92,0x4(%esp)
8010203d:	80 
8010203e:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102045:	e8 e6 2a 00 00       	call   80104b30 <initlock>
  picenable(IRQ_IDE);
8010204a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102051:	e8 ea 11 00 00       	call   80103240 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102056:	a1 80 3d 11 80       	mov    0x80113d80,%eax
8010205b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102062:	83 e8 01             	sub    $0x1,%eax
80102065:	89 44 24 04          	mov    %eax,0x4(%esp)
80102069:	e8 82 02 00 00       	call   801022f0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010206e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102073:	90                   	nop
80102074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102078:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102079:	83 e0 c0             	and    $0xffffffc0,%eax
8010207c:	3c 40                	cmp    $0x40,%al
8010207e:	75 f8                	jne    80102078 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102080:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102085:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010208a:	ee                   	out    %al,(%dx)
8010208b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102090:	b2 f7                	mov    $0xf7,%dl
80102092:	eb 09                	jmp    8010209d <ideinit+0x6d>
80102094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102098:	83 e9 01             	sub    $0x1,%ecx
8010209b:	74 0f                	je     801020ac <ideinit+0x7c>
8010209d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010209e:	84 c0                	test   %al,%al
801020a0:	74 f6                	je     80102098 <ideinit+0x68>
      havedisk1 = 1;
801020a2:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801020a9:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ac:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020b1:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020b6:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801020b7:	c9                   	leave  
801020b8:	c3                   	ret    
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020c0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020c9:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
801020d0:	e8 db 2a 00 00       	call   80104bb0 <acquire>
  if((b = idequeue) == 0){
801020d5:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020db:	85 db                	test   %ebx,%ebx
801020dd:	74 30                	je     8010210f <ideintr+0x4f>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
801020df:	8b 43 58             	mov    0x58(%ebx),%eax
801020e2:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020e7:	8b 33                	mov    (%ebx),%esi
801020e9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020ef:	74 37                	je     80102128 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020f1:	83 e6 fb             	and    $0xfffffffb,%esi
801020f4:	83 ce 02             	or     $0x2,%esi
801020f7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020f9:	89 1c 24             	mov    %ebx,(%esp)
801020fc:	e8 ef 24 00 00       	call   801045f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102101:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102106:	85 c0                	test   %eax,%eax
80102108:	74 05                	je     8010210f <ideintr+0x4f>
    idestart(idequeue);
8010210a:	e8 61 fe ff ff       	call   80101f70 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
8010210f:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102116:	e8 c5 2b 00 00       	call   80104ce0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
8010211b:	83 c4 1c             	add    $0x1c,%esp
8010211e:	5b                   	pop    %ebx
8010211f:	5e                   	pop    %esi
80102120:	5f                   	pop    %edi
80102121:	5d                   	pop    %ebp
80102122:	c3                   	ret    
80102123:	90                   	nop
80102124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102128:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010212d:	8d 76 00             	lea    0x0(%esi),%esi
80102130:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102131:	89 c1                	mov    %eax,%ecx
80102133:	83 e1 c0             	and    $0xffffffc0,%ecx
80102136:	80 f9 40             	cmp    $0x40,%cl
80102139:	75 f5                	jne    80102130 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010213b:	a8 21                	test   $0x21,%al
8010213d:	75 b2                	jne    801020f1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010213f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102142:	b9 80 00 00 00       	mov    $0x80,%ecx
80102147:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010214c:	fc                   	cld    
8010214d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010214f:	8b 33                	mov    (%ebx),%esi
80102151:	eb 9e                	jmp    801020f1 <ideintr+0x31>
80102153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102160 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	53                   	push   %ebx
80102164:	83 ec 14             	sub    $0x14,%esp
80102167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010216a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010216d:	89 04 24             	mov    %eax,(%esp)
80102170:	e8 8b 29 00 00       	call   80104b00 <holdingsleep>
80102175:	85 c0                	test   %eax,%eax
80102177:	0f 84 9e 00 00 00    	je     8010221b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010217d:	8b 03                	mov    (%ebx),%eax
8010217f:	83 e0 06             	and    $0x6,%eax
80102182:	83 f8 02             	cmp    $0x2,%eax
80102185:	0f 84 a8 00 00 00    	je     80102233 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010218b:	8b 53 04             	mov    0x4(%ebx),%edx
8010218e:	85 d2                	test   %edx,%edx
80102190:	74 0d                	je     8010219f <iderw+0x3f>
80102192:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102197:	85 c0                	test   %eax,%eax
80102199:	0f 84 88 00 00 00    	je     80102227 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010219f:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
801021a6:	e8 05 2a 00 00       	call   80104bb0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ab:	a1 64 b5 10 80       	mov    0x8010b564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801021b0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021b7:	85 c0                	test   %eax,%eax
801021b9:	75 07                	jne    801021c2 <iderw+0x62>
801021bb:	eb 4e                	jmp    8010220b <iderw+0xab>
801021bd:	8d 76 00             	lea    0x0(%esi),%esi
801021c0:	89 d0                	mov    %edx,%eax
801021c2:	8b 50 58             	mov    0x58(%eax),%edx
801021c5:	85 d2                	test   %edx,%edx
801021c7:	75 f7                	jne    801021c0 <iderw+0x60>
801021c9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021cc:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021ce:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801021d4:	74 3c                	je     80102212 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021d6:	8b 03                	mov    (%ebx),%eax
801021d8:	83 e0 06             	and    $0x6,%eax
801021db:	83 f8 02             	cmp    $0x2,%eax
801021de:	74 1a                	je     801021fa <iderw+0x9a>
    sleep(b, &idelock);
801021e0:	c7 44 24 04 80 b5 10 	movl   $0x8010b580,0x4(%esp)
801021e7:	80 
801021e8:	89 1c 24             	mov    %ebx,(%esp)
801021eb:	e8 00 22 00 00       	call   801043f0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021f0:	8b 13                	mov    (%ebx),%edx
801021f2:	83 e2 06             	and    $0x6,%edx
801021f5:	83 fa 02             	cmp    $0x2,%edx
801021f8:	75 e6                	jne    801021e0 <iderw+0x80>
    sleep(b, &idelock);
  }

  release(&idelock);
801021fa:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102201:	83 c4 14             	add    $0x14,%esp
80102204:	5b                   	pop    %ebx
80102205:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
80102206:	e9 d5 2a 00 00       	jmp    80104ce0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010220b:	b8 64 b5 10 80       	mov    $0x8010b564,%eax
80102210:	eb ba                	jmp    801021cc <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102212:	89 d8                	mov    %ebx,%eax
80102214:	e8 57 fd ff ff       	call   80101f70 <idestart>
80102219:	eb bb                	jmp    801021d6 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010221b:	c7 04 24 96 7a 10 80 	movl   $0x80107a96,(%esp)
80102222:	e8 39 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102227:	c7 04 24 c1 7a 10 80 	movl   $0x80107ac1,(%esp)
8010222e:	e8 2d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102233:	c7 04 24 ac 7a 10 80 	movl   $0x80107aac,(%esp)
8010223a:	e8 21 e1 ff ff       	call   80100360 <panic>
8010223f:	90                   	nop

80102240 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
80102240:	a1 84 37 11 80       	mov    0x80113784,%eax
80102245:	85 c0                	test   %eax,%eax
80102247:	0f 84 9b 00 00 00    	je     801022e8 <ioapicinit+0xa8>
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010224d:	55                   	push   %ebp
8010224e:	89 e5                	mov    %esp,%ebp
80102250:	56                   	push   %esi
80102251:	53                   	push   %ebx
80102252:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102255:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
8010225c:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010225f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102266:	00 00 00 
  return ioapic->data;
80102269:	8b 15 54 36 11 80    	mov    0x80113654,%edx
8010226f:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102272:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102278:	8b 1d 54 36 11 80    	mov    0x80113654,%ebx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010227e:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102285:	c1 e8 10             	shr    $0x10,%eax
80102288:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010228b:	8b 43 10             	mov    0x10(%ebx),%eax
  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
8010228e:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102291:	39 c2                	cmp    %eax,%edx
80102293:	74 12                	je     801022a7 <ioapicinit+0x67>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102295:	c7 04 24 e0 7a 10 80 	movl   $0x80107ae0,(%esp)
8010229c:	e8 af e3 ff ff       	call   80100650 <cprintf>
801022a1:	8b 1d 54 36 11 80    	mov    0x80113654,%ebx
801022a7:	ba 10 00 00 00       	mov    $0x10,%edx
801022ac:	31 c0                	xor    %eax,%eax
801022ae:	eb 02                	jmp    801022b2 <ioapicinit+0x72>
801022b0:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b2:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
801022b4:	8b 1d 54 36 11 80    	mov    0x80113654,%ebx
801022ba:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022bd:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022c3:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022c6:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022c9:	8d 4a 01             	lea    0x1(%edx),%ecx
801022cc:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022cf:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022d1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022d7:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022d9:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022e0:	7d ce                	jge    801022b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022e2:	83 c4 10             	add    $0x10,%esp
801022e5:	5b                   	pop    %ebx
801022e6:	5e                   	pop    %esi
801022e7:	5d                   	pop    %ebp
801022e8:	f3 c3                	repz ret 
801022ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801022f0:	8b 15 84 37 11 80    	mov    0x80113784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022f6:	55                   	push   %ebp
801022f7:	89 e5                	mov    %esp,%ebp
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801022fc:	85 d2                	test   %edx,%edx
801022fe:	74 29                	je     80102329 <ioapicenable+0x39>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102300:	8d 48 20             	lea    0x20(%eax),%ecx
80102303:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102307:	a1 54 36 11 80       	mov    0x80113654,%eax
8010230c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010230e:	a1 54 36 11 80       	mov    0x80113654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102313:	83 c2 01             	add    $0x1,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102316:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010231c:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010231e:	a1 54 36 11 80       	mov    0x80113654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102323:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102326:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102329:	5d                   	pop    %ebp
8010232a:	c3                   	ret    
8010232b:	66 90                	xchg   %ax,%ax
8010232d:	66 90                	xchg   %ax,%ax
8010232f:	90                   	nop

80102330 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	53                   	push   %ebx
80102334:	83 ec 14             	sub    $0x14,%esp
80102337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010233a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102340:	75 7c                	jne    801023be <kfree+0x8e>
80102342:	81 fb c8 6e 11 80    	cmp    $0x80116ec8,%ebx
80102348:	72 74                	jb     801023be <kfree+0x8e>
8010234a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102350:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102355:	77 67                	ja     801023be <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102357:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010235e:	00 
8010235f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102366:	00 
80102367:	89 1c 24             	mov    %ebx,(%esp)
8010236a:	e8 c1 29 00 00       	call   80104d30 <memset>

  if(kmem.use_lock)
8010236f:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102375:	85 d2                	test   %edx,%edx
80102377:	75 37                	jne    801023b0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102379:	a1 98 36 11 80       	mov    0x80113698,%eax
8010237e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102380:	a1 94 36 11 80       	mov    0x80113694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102385:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
8010238b:	85 c0                	test   %eax,%eax
8010238d:	75 09                	jne    80102398 <kfree+0x68>
    release(&kmem.lock);
}
8010238f:	83 c4 14             	add    $0x14,%esp
80102392:	5b                   	pop    %ebx
80102393:	5d                   	pop    %ebp
80102394:	c3                   	ret    
80102395:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102398:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
8010239f:	83 c4 14             	add    $0x14,%esp
801023a2:	5b                   	pop    %ebx
801023a3:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801023a4:	e9 37 29 00 00       	jmp    80104ce0 <release>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801023b0:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
801023b7:	e8 f4 27 00 00       	call   80104bb0 <acquire>
801023bc:	eb bb                	jmp    80102379 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801023be:	c7 04 24 12 7b 10 80 	movl   $0x80107b12,(%esp)
801023c5:	e8 96 df ff ff       	call   80100360 <panic>
801023ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023d0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023de:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023e4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ea:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023f0:	39 de                	cmp    %ebx,%esi
801023f2:	73 08                	jae    801023fc <freerange+0x2c>
801023f4:	eb 18                	jmp    8010240e <freerange+0x3e>
801023f6:	66 90                	xchg   %ax,%ax
801023f8:	89 da                	mov    %ebx,%edx
801023fa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023fc:	89 14 24             	mov    %edx,(%esp)
801023ff:	e8 2c ff ff ff       	call   80102330 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102404:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010240a:	39 f0                	cmp    %esi,%eax
8010240c:	76 ea                	jbe    801023f8 <freerange+0x28>
    kfree(p);
}
8010240e:	83 c4 10             	add    $0x10,%esp
80102411:	5b                   	pop    %ebx
80102412:	5e                   	pop    %esi
80102413:	5d                   	pop    %ebp
80102414:	c3                   	ret    
80102415:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102420 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	56                   	push   %esi
80102424:	53                   	push   %ebx
80102425:	83 ec 10             	sub    $0x10,%esp
80102428:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010242b:	c7 44 24 04 18 7b 10 	movl   $0x80107b18,0x4(%esp)
80102432:	80 
80102433:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
8010243a:	e8 f1 26 00 00       	call   80104b30 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010243f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102442:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102449:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102452:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102458:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010245e:	39 de                	cmp    %ebx,%esi
80102460:	73 0a                	jae    8010246c <kinit1+0x4c>
80102462:	eb 1a                	jmp    8010247e <kinit1+0x5e>
80102464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102468:	89 da                	mov    %ebx,%edx
8010246a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010246c:	89 14 24             	mov    %edx,(%esp)
8010246f:	e8 bc fe ff ff       	call   80102330 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102474:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010247a:	39 c6                	cmp    %eax,%esi
8010247c:	73 ea                	jae    80102468 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010247e:	83 c4 10             	add    $0x10,%esp
80102481:	5b                   	pop    %ebx
80102482:	5e                   	pop    %esi
80102483:	5d                   	pop    %ebp
80102484:	c3                   	ret    
80102485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
80102494:	53                   	push   %ebx
80102495:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102498:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010249b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010249e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801024a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024aa:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024b0:	39 de                	cmp    %ebx,%esi
801024b2:	73 08                	jae    801024bc <kinit2+0x2c>
801024b4:	eb 18                	jmp    801024ce <kinit2+0x3e>
801024b6:	66 90                	xchg   %ax,%ax
801024b8:	89 da                	mov    %ebx,%edx
801024ba:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024bc:	89 14 24             	mov    %edx,(%esp)
801024bf:	e8 6c fe ff ff       	call   80102330 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024ca:	39 c6                	cmp    %eax,%esi
801024cc:	73 ea                	jae    801024b8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801024ce:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
801024d5:	00 00 00 
}
801024d8:	83 c4 10             	add    $0x10,%esp
801024db:	5b                   	pop    %ebx
801024dc:	5e                   	pop    %esi
801024dd:	5d                   	pop    %ebp
801024de:	c3                   	ret    
801024df:	90                   	nop

801024e0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024e7:	a1 94 36 11 80       	mov    0x80113694,%eax
801024ec:	85 c0                	test   %eax,%eax
801024ee:	75 30                	jne    80102520 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024f0:	8b 1d 98 36 11 80    	mov    0x80113698,%ebx
  if(r)
801024f6:	85 db                	test   %ebx,%ebx
801024f8:	74 08                	je     80102502 <kalloc+0x22>
    kmem.freelist = r->next;
801024fa:	8b 13                	mov    (%ebx),%edx
801024fc:	89 15 98 36 11 80    	mov    %edx,0x80113698
  if(kmem.use_lock)
80102502:	85 c0                	test   %eax,%eax
80102504:	74 0c                	je     80102512 <kalloc+0x32>
    release(&kmem.lock);
80102506:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
8010250d:	e8 ce 27 00 00       	call   80104ce0 <release>
  return (char*)r;
}
80102512:	83 c4 14             	add    $0x14,%esp
80102515:	89 d8                	mov    %ebx,%eax
80102517:	5b                   	pop    %ebx
80102518:	5d                   	pop    %ebp
80102519:	c3                   	ret    
8010251a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102520:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
80102527:	e8 84 26 00 00       	call   80104bb0 <acquire>
8010252c:	a1 94 36 11 80       	mov    0x80113694,%eax
80102531:	eb bd                	jmp    801024f0 <kalloc+0x10>
80102533:	66 90                	xchg   %ax,%ax
80102535:	66 90                	xchg   %ax,%ax
80102537:	66 90                	xchg   %ax,%ax
80102539:	66 90                	xchg   %ax,%ax
8010253b:	66 90                	xchg   %ax,%ax
8010253d:	66 90                	xchg   %ax,%ax
8010253f:	90                   	nop

80102540 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102540:	ba 64 00 00 00       	mov    $0x64,%edx
80102545:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102546:	a8 01                	test   $0x1,%al
80102548:	0f 84 ba 00 00 00    	je     80102608 <kbdgetc+0xc8>
8010254e:	b2 60                	mov    $0x60,%dl
80102550:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102551:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102554:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010255a:	0f 84 88 00 00 00    	je     801025e8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102560:	84 c0                	test   %al,%al
80102562:	79 2c                	jns    80102590 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102564:	8b 15 b4 b5 10 80    	mov    0x8010b5b4,%edx
8010256a:	f6 c2 40             	test   $0x40,%dl
8010256d:	75 05                	jne    80102574 <kbdgetc+0x34>
8010256f:	89 c1                	mov    %eax,%ecx
80102571:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102574:	0f b6 81 40 7c 10 80 	movzbl -0x7fef83c0(%ecx),%eax
8010257b:	83 c8 40             	or     $0x40,%eax
8010257e:	0f b6 c0             	movzbl %al,%eax
80102581:	f7 d0                	not    %eax
80102583:	21 d0                	and    %edx,%eax
80102585:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010258a:	31 c0                	xor    %eax,%eax
8010258c:	c3                   	ret    
8010258d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	53                   	push   %ebx
80102594:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010259a:	f6 c3 40             	test   $0x40,%bl
8010259d:	74 09                	je     801025a8 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010259f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025a2:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025a5:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025a8:	0f b6 91 40 7c 10 80 	movzbl -0x7fef83c0(%ecx),%edx
  shift ^= togglecode[data];
801025af:	0f b6 81 40 7b 10 80 	movzbl -0x7fef84c0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
801025b6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025b8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025ba:	89 d0                	mov    %edx,%eax
801025bc:	83 e0 03             	and    $0x3,%eax
801025bf:	8b 04 85 20 7b 10 80 	mov    -0x7fef84e0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801025c6:	89 15 b4 b5 10 80    	mov    %edx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
801025cc:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801025cf:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025d3:	74 0b                	je     801025e0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025d5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025d8:	83 fa 19             	cmp    $0x19,%edx
801025db:	77 1b                	ja     801025f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025dd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025e0:	5b                   	pop    %ebx
801025e1:	5d                   	pop    %ebp
801025e2:	c3                   	ret    
801025e3:	90                   	nop
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025e8:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
    return 0;
801025ef:	31 c0                	xor    %eax,%eax
801025f1:	c3                   	ret    
801025f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025fb:	8d 50 20             	lea    0x20(%eax),%edx
801025fe:	83 f9 19             	cmp    $0x19,%ecx
80102601:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
80102604:	eb da                	jmp    801025e0 <kbdgetc+0xa0>
80102606:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010260d:	c3                   	ret    
8010260e:	66 90                	xchg   %ax,%ax

80102610 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102616:	c7 04 24 40 25 10 80 	movl   $0x80102540,(%esp)
8010261d:	e8 8e e1 ff ff       	call   801007b0 <consoleintr>
}
80102622:	c9                   	leave  
80102623:	c3                   	ret    
80102624:	66 90                	xchg   %ax,%ax
80102626:	66 90                	xchg   %ax,%ax
80102628:	66 90                	xchg   %ax,%ax
8010262a:	66 90                	xchg   %ax,%ax
8010262c:	66 90                	xchg   %ax,%ax
8010262e:	66 90                	xchg   %ax,%ax

80102630 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102630:	55                   	push   %ebp
80102631:	89 c1                	mov    %eax,%ecx
80102633:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102635:	ba 70 00 00 00       	mov    $0x70,%edx
8010263a:	53                   	push   %ebx
8010263b:	31 c0                	xor    %eax,%eax
8010263d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010263e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102643:	89 da                	mov    %ebx,%edx
80102645:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102646:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102649:	b2 70                	mov    $0x70,%dl
8010264b:	89 01                	mov    %eax,(%ecx)
8010264d:	b8 02 00 00 00       	mov    $0x2,%eax
80102652:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102653:	89 da                	mov    %ebx,%edx
80102655:	ec                   	in     (%dx),%al
80102656:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102659:	b2 70                	mov    $0x70,%dl
8010265b:	89 41 04             	mov    %eax,0x4(%ecx)
8010265e:	b8 04 00 00 00       	mov    $0x4,%eax
80102663:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102664:	89 da                	mov    %ebx,%edx
80102666:	ec                   	in     (%dx),%al
80102667:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010266a:	b2 70                	mov    $0x70,%dl
8010266c:	89 41 08             	mov    %eax,0x8(%ecx)
8010266f:	b8 07 00 00 00       	mov    $0x7,%eax
80102674:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102675:	89 da                	mov    %ebx,%edx
80102677:	ec                   	in     (%dx),%al
80102678:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010267b:	b2 70                	mov    $0x70,%dl
8010267d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102680:	b8 08 00 00 00       	mov    $0x8,%eax
80102685:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102686:	89 da                	mov    %ebx,%edx
80102688:	ec                   	in     (%dx),%al
80102689:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010268c:	b2 70                	mov    $0x70,%dl
8010268e:	89 41 10             	mov    %eax,0x10(%ecx)
80102691:	b8 09 00 00 00       	mov    $0x9,%eax
80102696:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102697:	89 da                	mov    %ebx,%edx
80102699:	ec                   	in     (%dx),%al
8010269a:	0f b6 d8             	movzbl %al,%ebx
8010269d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
801026a0:	5b                   	pop    %ebx
801026a1:	5d                   	pop    %ebp
801026a2:	c3                   	ret    
801026a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026b0 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
801026b0:	a1 9c 36 11 80       	mov    0x8011369c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
801026b5:	55                   	push   %ebp
801026b6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026b8:	85 c0                	test   %eax,%eax
801026ba:	0f 84 c0 00 00 00    	je     80102780 <lapicinit+0xd0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026c7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026cd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026da:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026e1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ee:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026f1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026fb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026fe:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102701:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102708:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010270b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010270e:	8b 50 30             	mov    0x30(%eax),%edx
80102711:	c1 ea 10             	shr    $0x10,%edx
80102714:	80 fa 03             	cmp    $0x3,%dl
80102717:	77 6f                	ja     80102788 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102719:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102720:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102723:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102726:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010272d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102730:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102733:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010273a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102740:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102747:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010274d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102754:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102757:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010275a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102761:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102764:	8b 50 20             	mov    0x20(%eax),%edx
80102767:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102768:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010276e:	80 e6 10             	and    $0x10,%dh
80102771:	75 f5                	jne    80102768 <lapicinit+0xb8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102773:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010277a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010277d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102780:	5d                   	pop    %ebp
80102781:	c3                   	ret    
80102782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102788:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010278f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102792:	8b 50 20             	mov    0x20(%eax),%edx
80102795:	eb 82                	jmp    80102719 <lapicinit+0x69>
80102797:	89 f6                	mov    %esi,%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	56                   	push   %esi
801027a4:	53                   	push   %ebx
801027a5:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801027a8:	9c                   	pushf  
801027a9:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801027aa:	f6 c4 02             	test   $0x2,%ah
801027ad:	74 12                	je     801027c1 <cpunum+0x21>
    static int n;
    if(n++ == 0)
801027af:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
801027b4:	8d 50 01             	lea    0x1(%eax),%edx
801027b7:	85 c0                	test   %eax,%eax
801027b9:	89 15 b8 b5 10 80    	mov    %edx,0x8010b5b8
801027bf:	74 4a                	je     8010280b <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
801027c1:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801027c6:	85 c0                	test   %eax,%eax
801027c8:	74 5d                	je     80102827 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
801027ca:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
801027cd:	8b 35 80 3d 11 80    	mov    0x80113d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
801027d3:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
801027d6:	85 f6                	test   %esi,%esi
801027d8:	7e 56                	jle    80102830 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027da:	0f b6 05 a0 37 11 80 	movzbl 0x801137a0,%eax
801027e1:	39 d8                	cmp    %ebx,%eax
801027e3:	74 42                	je     80102827 <cpunum+0x87>
801027e5:	ba 5c 38 11 80       	mov    $0x8011385c,%edx

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
801027ea:	31 c0                	xor    %eax,%eax
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027f0:	83 c0 01             	add    $0x1,%eax
801027f3:	39 f0                	cmp    %esi,%eax
801027f5:	74 39                	je     80102830 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027f7:	0f b6 0a             	movzbl (%edx),%ecx
801027fa:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102800:	39 d9                	cmp    %ebx,%ecx
80102802:	75 ec                	jne    801027f0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102804:	83 c4 10             	add    $0x10,%esp
80102807:	5b                   	pop    %ebx
80102808:	5e                   	pop    %esi
80102809:	5d                   	pop    %ebp
8010280a:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
8010280b:	8b 45 04             	mov    0x4(%ebp),%eax
8010280e:	c7 04 24 40 7d 10 80 	movl   $0x80107d40,(%esp)
80102815:	89 44 24 04          	mov    %eax,0x4(%esp)
80102819:	e8 32 de ff ff       	call   80100650 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010281e:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102823:	85 c0                	test   %eax,%eax
80102825:	75 a3                	jne    801027ca <cpunum+0x2a>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102827:	83 c4 10             	add    $0x10,%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010282a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010282c:	5b                   	pop    %ebx
8010282d:	5e                   	pop    %esi
8010282e:	5d                   	pop    %ebp
8010282f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102830:	c7 04 24 6c 7d 10 80 	movl   $0x80107d6c,(%esp)
80102837:	e8 24 db ff ff       	call   80100360 <panic>
8010283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102840 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102840:	a1 9c 36 11 80       	mov    0x8011369c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102845:	55                   	push   %ebp
80102846:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102848:	85 c0                	test   %eax,%eax
8010284a:	74 0d                	je     80102859 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010284c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102853:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102856:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102859:	5d                   	pop    %ebp
8010285a:	c3                   	ret    
8010285b:	90                   	nop
8010285c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102860 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
}
80102863:	5d                   	pop    %ebp
80102864:	c3                   	ret    
80102865:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102870 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102870:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102871:	ba 70 00 00 00       	mov    $0x70,%edx
80102876:	89 e5                	mov    %esp,%ebp
80102878:	b8 0f 00 00 00       	mov    $0xf,%eax
8010287d:	53                   	push   %ebx
8010287e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102881:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102884:	ee                   	out    %al,(%dx)
80102885:	b8 0a 00 00 00       	mov    $0xa,%eax
8010288a:	b2 71                	mov    $0x71,%dl
8010288c:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010288d:	31 c0                	xor    %eax,%eax
8010288f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102895:	89 d8                	mov    %ebx,%eax
80102897:	c1 e8 04             	shr    $0x4,%eax
8010289a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028a0:	a1 9c 36 11 80       	mov    0x8011369c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801028a5:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028a8:	c1 eb 0c             	shr    $0xc,%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ab:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028b1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028b4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028bb:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028be:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028c1:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028c8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028cb:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ce:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028d4:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028d7:	89 da                	mov    %ebx,%edx
801028d9:	80 ce 06             	or     $0x6,%dh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028dc:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028e2:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028e5:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028eb:	8b 48 20             	mov    0x20(%eax),%ecx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ee:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028f4:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801028f7:	5b                   	pop    %ebx
801028f8:	5d                   	pop    %ebp
801028f9:	c3                   	ret    
801028fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102900 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102900:	55                   	push   %ebp
80102901:	ba 70 00 00 00       	mov    $0x70,%edx
80102906:	89 e5                	mov    %esp,%ebp
80102908:	b8 0b 00 00 00       	mov    $0xb,%eax
8010290d:	57                   	push   %edi
8010290e:	56                   	push   %esi
8010290f:	53                   	push   %ebx
80102910:	83 ec 4c             	sub    $0x4c,%esp
80102913:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102914:	b2 71                	mov    $0x71,%dl
80102916:	ec                   	in     (%dx),%al
80102917:	88 45 b7             	mov    %al,-0x49(%ebp)
8010291a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010291d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102921:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102928:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010292d:	89 d8                	mov    %ebx,%eax
8010292f:	e8 fc fc ff ff       	call   80102630 <fill_rtcdate>
80102934:	b8 0a 00 00 00       	mov    $0xa,%eax
80102939:	89 f2                	mov    %esi,%edx
8010293b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293c:	ba 71 00 00 00       	mov    $0x71,%edx
80102941:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102942:	84 c0                	test   %al,%al
80102944:	78 e7                	js     8010292d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102946:	89 f8                	mov    %edi,%eax
80102948:	e8 e3 fc ff ff       	call   80102630 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010294d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102954:	00 
80102955:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102959:	89 1c 24             	mov    %ebx,(%esp)
8010295c:	e8 1f 24 00 00       	call   80104d80 <memcmp>
80102961:	85 c0                	test   %eax,%eax
80102963:	75 c3                	jne    80102928 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102965:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102969:	75 78                	jne    801029e3 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010296b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010296e:	89 c2                	mov    %eax,%edx
80102970:	83 e0 0f             	and    $0xf,%eax
80102973:	c1 ea 04             	shr    $0x4,%edx
80102976:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102979:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010297f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102982:	89 c2                	mov    %eax,%edx
80102984:	83 e0 0f             	and    $0xf,%eax
80102987:	c1 ea 04             	shr    $0x4,%edx
8010298a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102990:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102993:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102996:	89 c2                	mov    %eax,%edx
80102998:	83 e0 0f             	and    $0xf,%eax
8010299b:	c1 ea 04             	shr    $0x4,%edx
8010299e:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029aa:	89 c2                	mov    %eax,%edx
801029ac:	83 e0 0f             	and    $0xf,%eax
801029af:	c1 ea 04             	shr    $0x4,%edx
801029b2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029bb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029be:	89 c2                	mov    %eax,%edx
801029c0:	83 e0 0f             	and    $0xf,%eax
801029c3:	c1 ea 04             	shr    $0x4,%edx
801029c6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029cf:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029d2:	89 c2                	mov    %eax,%edx
801029d4:	83 e0 0f             	and    $0xf,%eax
801029d7:	c1 ea 04             	shr    $0x4,%edx
801029da:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029dd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029e0:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
801029e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029e9:	89 01                	mov    %eax,(%ecx)
801029eb:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029ee:	89 41 04             	mov    %eax,0x4(%ecx)
801029f1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029f4:	89 41 08             	mov    %eax,0x8(%ecx)
801029f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029fa:	89 41 0c             	mov    %eax,0xc(%ecx)
801029fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a00:	89 41 10             	mov    %eax,0x10(%ecx)
80102a03:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a06:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102a09:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102a10:	83 c4 4c             	add    $0x4c,%esp
80102a13:	5b                   	pop    %ebx
80102a14:	5e                   	pop    %esi
80102a15:	5f                   	pop    %edi
80102a16:	5d                   	pop    %ebp
80102a17:	c3                   	ret    
80102a18:	66 90                	xchg   %ax,%ax
80102a1a:	66 90                	xchg   %ax,%ax
80102a1c:	66 90                	xchg   %ax,%ax
80102a1e:	66 90                	xchg   %ax,%ax

80102a20 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	57                   	push   %edi
80102a24:	56                   	push   %esi
80102a25:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a26:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a28:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a2b:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80102a30:	85 c0                	test   %eax,%eax
80102a32:	7e 78                	jle    80102aac <install_trans+0x8c>
80102a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a38:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102a3d:	01 d8                	add    %ebx,%eax
80102a3f:	83 c0 01             	add    $0x1,%eax
80102a42:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a46:	a1 e4 36 11 80       	mov    0x801136e4,%eax
80102a4b:	89 04 24             	mov    %eax,(%esp)
80102a4e:	e8 7d d6 ff ff       	call   801000d0 <bread>
80102a53:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a55:	8b 04 9d ec 36 11 80 	mov    -0x7feec914(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a5c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a63:	a1 e4 36 11 80       	mov    0x801136e4,%eax
80102a68:	89 04 24             	mov    %eax,(%esp)
80102a6b:	e8 60 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a70:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a77:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a78:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a7a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a81:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a84:	89 04 24             	mov    %eax,(%esp)
80102a87:	e8 44 23 00 00       	call   80104dd0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a8c:	89 34 24             	mov    %esi,(%esp)
80102a8f:	e8 0c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a94:	89 3c 24             	mov    %edi,(%esp)
80102a97:	e8 44 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a9c:	89 34 24             	mov    %esi,(%esp)
80102a9f:	e8 3c d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102aa4:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102aaa:	7f 8c                	jg     80102a38 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102aac:	83 c4 1c             	add    $0x1c,%esp
80102aaf:	5b                   	pop    %ebx
80102ab0:	5e                   	pop    %esi
80102ab1:	5f                   	pop    %edi
80102ab2:	5d                   	pop    %ebp
80102ab3:	c3                   	ret    
80102ab4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102aba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102ac0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	57                   	push   %edi
80102ac4:	56                   	push   %esi
80102ac5:	53                   	push   %ebx
80102ac6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ac9:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102ace:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ad2:	a1 e4 36 11 80       	mov    0x801136e4,%eax
80102ad7:	89 04 24             	mov    %eax,(%esp)
80102ada:	e8 f1 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102adf:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ae5:	31 d2                	xor    %edx,%edx
80102ae7:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ae9:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102aeb:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102aee:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102af1:	7e 17                	jle    80102b0a <write_head+0x4a>
80102af3:	90                   	nop
80102af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102af8:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
80102aff:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b03:	83 c2 01             	add    $0x1,%edx
80102b06:	39 da                	cmp    %ebx,%edx
80102b08:	75 ee                	jne    80102af8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102b0a:	89 3c 24             	mov    %edi,(%esp)
80102b0d:	e8 8e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b12:	89 3c 24             	mov    %edi,(%esp)
80102b15:	e8 c6 d6 ff ff       	call   801001e0 <brelse>
}
80102b1a:	83 c4 1c             	add    $0x1c,%esp
80102b1d:	5b                   	pop    %ebx
80102b1e:	5e                   	pop    %esi
80102b1f:	5f                   	pop    %edi
80102b20:	5d                   	pop    %ebp
80102b21:	c3                   	ret    
80102b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b30 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	56                   	push   %esi
80102b34:	53                   	push   %ebx
80102b35:	83 ec 30             	sub    $0x30,%esp
80102b38:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b3b:	c7 44 24 04 7c 7d 10 	movl   $0x80107d7c,0x4(%esp)
80102b42:	80 
80102b43:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102b4a:	e8 e1 1f 00 00       	call   80104b30 <initlock>
  readsb(dev, &sb);
80102b4f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b52:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b56:	89 1c 24             	mov    %ebx,(%esp)
80102b59:	e8 82 e8 ff ff       	call   801013e0 <readsb>
  log.start = sb.logstart;
80102b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b61:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b64:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b67:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b6d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b71:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b77:	a3 d4 36 11 80       	mov    %eax,0x801136d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b7c:	e8 4f d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b81:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b83:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b86:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b89:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b8b:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102b91:	7e 17                	jle    80102baa <initlog+0x7a>
80102b93:	90                   	nop
80102b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b98:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b9c:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ba3:	83 c2 01             	add    $0x1,%edx
80102ba6:	39 da                	cmp    %ebx,%edx
80102ba8:	75 ee                	jne    80102b98 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102baa:	89 04 24             	mov    %eax,(%esp)
80102bad:	e8 2e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bb2:	e8 69 fe ff ff       	call   80102a20 <install_trans>
  log.lh.n = 0;
80102bb7:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102bbe:	00 00 00 
  write_head(); // clear the log
80102bc1:	e8 fa fe ff ff       	call   80102ac0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102bc6:	83 c4 30             	add    $0x30,%esp
80102bc9:	5b                   	pop    %ebx
80102bca:	5e                   	pop    %esi
80102bcb:	5d                   	pop    %ebp
80102bcc:	c3                   	ret    
80102bcd:	8d 76 00             	lea    0x0(%esi),%esi

80102bd0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102bd6:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102bdd:	e8 ce 1f 00 00       	call   80104bb0 <acquire>
80102be2:	eb 18                	jmp    80102bfc <begin_op+0x2c>
80102be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102be8:	c7 44 24 04 a0 36 11 	movl   $0x801136a0,0x4(%esp)
80102bef:	80 
80102bf0:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102bf7:	e8 f4 17 00 00       	call   801043f0 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bfc:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102c01:	85 c0                	test   %eax,%eax
80102c03:	75 e3                	jne    80102be8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c05:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102c0a:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102c10:	83 c0 01             	add    $0x1,%eax
80102c13:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c16:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c19:	83 fa 1e             	cmp    $0x1e,%edx
80102c1c:	7f ca                	jg     80102be8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c1e:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c25:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102c2a:	e8 b1 20 00 00       	call   80104ce0 <release>
      break;
    }
  }
}
80102c2f:	c9                   	leave  
80102c30:	c3                   	ret    
80102c31:	eb 0d                	jmp    80102c40 <end_op>
80102c33:	90                   	nop
80102c34:	90                   	nop
80102c35:	90                   	nop
80102c36:	90                   	nop
80102c37:	90                   	nop
80102c38:	90                   	nop
80102c39:	90                   	nop
80102c3a:	90                   	nop
80102c3b:	90                   	nop
80102c3c:	90                   	nop
80102c3d:	90                   	nop
80102c3e:	90                   	nop
80102c3f:	90                   	nop

80102c40 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	57                   	push   %edi
80102c44:	56                   	push   %esi
80102c45:	53                   	push   %ebx
80102c46:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c49:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102c50:	e8 5b 1f 00 00       	call   80104bb0 <acquire>
  log.outstanding -= 1;
80102c55:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102c5a:	8b 15 e0 36 11 80    	mov    0x801136e0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c60:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c63:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c65:	a3 dc 36 11 80       	mov    %eax,0x801136dc
  if(log.committing)
80102c6a:	0f 85 f3 00 00 00    	jne    80102d63 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c70:	85 c0                	test   %eax,%eax
80102c72:	0f 85 cb 00 00 00    	jne    80102d43 <end_op+0x103>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c78:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c7f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c81:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102c88:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c8b:	e8 50 20 00 00       	call   80104ce0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c90:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80102c95:	85 c0                	test   %eax,%eax
80102c97:	0f 8e 90 00 00 00    	jle    80102d2d <end_op+0xed>
80102c9d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ca0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102ca5:	01 d8                	add    %ebx,%eax
80102ca7:	83 c0 01             	add    $0x1,%eax
80102caa:	89 44 24 04          	mov    %eax,0x4(%esp)
80102cae:	a1 e4 36 11 80       	mov    0x801136e4,%eax
80102cb3:	89 04 24             	mov    %eax,(%esp)
80102cb6:	e8 15 d4 ff ff       	call   801000d0 <bread>
80102cbb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cbd:	8b 04 9d ec 36 11 80 	mov    -0x7feec914(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cc4:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ccb:	a1 e4 36 11 80       	mov    0x801136e4,%eax
80102cd0:	89 04 24             	mov    %eax,(%esp)
80102cd3:	e8 f8 d3 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102cd8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102cdf:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ce0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ce2:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ce9:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cec:	89 04 24             	mov    %eax,(%esp)
80102cef:	e8 dc 20 00 00       	call   80104dd0 <memmove>
    bwrite(to);  // write the log
80102cf4:	89 34 24             	mov    %esi,(%esp)
80102cf7:	e8 a4 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cfc:	89 3c 24             	mov    %edi,(%esp)
80102cff:	e8 dc d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d04:	89 34 24             	mov    %esi,(%esp)
80102d07:	e8 d4 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d0c:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102d12:	7c 8c                	jl     80102ca0 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d14:	e8 a7 fd ff ff       	call   80102ac0 <write_head>
    install_trans(); // Now install writes to home locations
80102d19:	e8 02 fd ff ff       	call   80102a20 <install_trans>
    log.lh.n = 0;
80102d1e:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102d25:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d28:	e8 93 fd ff ff       	call   80102ac0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d2d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d34:	e8 77 1e 00 00       	call   80104bb0 <acquire>
    log.committing = 0;
80102d39:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102d40:	00 00 00 
    wakeup(&log);
80102d43:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d4a:	e8 a1 18 00 00       	call   801045f0 <wakeup>
    release(&log.lock);
80102d4f:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d56:	e8 85 1f 00 00       	call   80104ce0 <release>
  }
}
80102d5b:	83 c4 1c             	add    $0x1c,%esp
80102d5e:	5b                   	pop    %ebx
80102d5f:	5e                   	pop    %esi
80102d60:	5f                   	pop    %edi
80102d61:	5d                   	pop    %ebp
80102d62:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d63:	c7 04 24 80 7d 10 80 	movl   $0x80107d80,(%esp)
80102d6a:	e8 f1 d5 ff ff       	call   80100360 <panic>
80102d6f:	90                   	nop

80102d70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d77:	a1 e8 36 11 80       	mov    0x801136e8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d7f:	83 f8 1d             	cmp    $0x1d,%eax
80102d82:	0f 8f 98 00 00 00    	jg     80102e20 <log_write+0xb0>
80102d88:	8b 0d d8 36 11 80    	mov    0x801136d8,%ecx
80102d8e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d91:	39 d0                	cmp    %edx,%eax
80102d93:	0f 8d 87 00 00 00    	jge    80102e20 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d99:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 86 00 00 00    	jle    80102e2c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102da6:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102dad:	e8 fe 1d 00 00       	call   80104bb0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102db2:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102db8:	83 fa 00             	cmp    $0x0,%edx
80102dbb:	7e 54                	jle    80102e11 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dbd:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102dc0:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dc2:	39 0d ec 36 11 80    	cmp    %ecx,0x801136ec
80102dc8:	75 0f                	jne    80102dd9 <log_write+0x69>
80102dca:	eb 3c                	jmp    80102e08 <log_write+0x98>
80102dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dd0:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 d0                	cmp    %edx,%eax
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102de0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102de7:	83 c2 01             	add    $0x1,%edx
80102dea:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80102df0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102df3:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102dfa:	83 c4 14             	add    $0x14,%esp
80102dfd:	5b                   	pop    %ebx
80102dfe:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dff:	e9 dc 1e 00 00       	jmp    80104ce0 <release>
80102e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e08:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
80102e0f:	eb df                	jmp    80102df0 <log_write+0x80>
80102e11:	8b 43 08             	mov    0x8(%ebx),%eax
80102e14:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102e19:	75 d5                	jne    80102df0 <log_write+0x80>
80102e1b:	eb ca                	jmp    80102de7 <log_write+0x77>
80102e1d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e20:	c7 04 24 8f 7d 10 80 	movl   $0x80107d8f,(%esp)
80102e27:	e8 34 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e2c:	c7 04 24 a5 7d 10 80 	movl   $0x80107da5,(%esp)
80102e33:	e8 28 d5 ff ff       	call   80100360 <panic>
80102e38:	66 90                	xchg   %ax,%ax
80102e3a:	66 90                	xchg   %ax,%ax
80102e3c:	66 90                	xchg   %ax,%ax
80102e3e:	66 90                	xchg   %ax,%ax

80102e40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102e46:	e8 55 f9 ff ff       	call   801027a0 <cpunum>
80102e4b:	c7 04 24 c0 7d 10 80 	movl   $0x80107dc0,(%esp)
80102e52:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e56:	e8 f5 d7 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e5b:	e8 50 31 00 00       	call   80105fb0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e60:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e67:	b8 01 00 00 00       	mov    $0x1,%eax
80102e6c:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102e73:	e8 c8 0f 00 00       	call   80103e40 <scheduler>
80102e78:	90                   	nop
80102e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e80 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e86:	e8 a5 43 00 00       	call   80107230 <switchkvm>
  seginit();
80102e8b:	e8 c0 41 00 00       	call   80107050 <seginit>
  lapicinit();
80102e90:	e8 1b f8 ff ff       	call   801026b0 <lapicinit>
  mpmain();
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	53                   	push   %ebx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eaa:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102eb1:	80 
80102eb2:	c7 04 24 c8 6e 11 80 	movl   $0x80116ec8,(%esp)
80102eb9:	e8 62 f5 ff ff       	call   80102420 <kinit1>
  kvmalloc();      // kernel page table
80102ebe:	e8 4d 43 00 00       	call   80107210 <kvmalloc>
  mpinit();        // detect other processors
80102ec3:	e8 a8 01 00 00       	call   80103070 <mpinit>
  lapicinit();     // interrupt controller
80102ec8:	e8 e3 f7 ff ff       	call   801026b0 <lapicinit>
80102ecd:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102ed0:	e8 7b 41 00 00       	call   80107050 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102ed5:	e8 c6 f8 ff ff       	call   801027a0 <cpunum>
80102eda:	c7 04 24 d1 7d 10 80 	movl   $0x80107dd1,(%esp)
80102ee1:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ee5:	e8 66 d7 ff ff       	call   80100650 <cprintf>
  picinit();       // another interrupt controller
80102eea:	e8 81 03 00 00       	call   80103270 <picinit>
  ioapicinit();    // another interrupt controller
80102eef:	e8 4c f3 ff ff       	call   80102240 <ioapicinit>
  consoleinit();   // console hardware
80102ef4:	e8 57 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102ef9:	e8 62 34 00 00       	call   80106360 <uartinit>
80102efe:	66 90                	xchg   %ax,%ax
  pinit();         // process table
80102f00:	e8 eb 0a 00 00       	call   801039f0 <pinit>
  tvinit();        // trap vectors
80102f05:	e8 d6 2f 00 00       	call   80105ee0 <tvinit>
  binit();         // buffer cache
80102f0a:	e8 31 d1 ff ff       	call   80100040 <binit>
80102f0f:	90                   	nop
  fileinit();      // file table
80102f10:	e8 7b de ff ff       	call   80100d90 <fileinit>
  ideinit();       // disk
80102f15:	e8 16 f1 ff ff       	call   80102030 <ideinit>
  if(!ismp)
80102f1a:	a1 84 37 11 80       	mov    0x80113784,%eax
80102f1f:	85 c0                	test   %eax,%eax
80102f21:	0f 84 ca 00 00 00    	je     80102ff1 <main+0x151>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f27:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102f2e:	00 

  for(c = cpus; c < cpus+ncpu; c++){
80102f2f:	bb a0 37 11 80       	mov    $0x801137a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f34:	c7 44 24 04 8c b4 10 	movl   $0x8010b48c,0x4(%esp)
80102f3b:	80 
80102f3c:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102f43:	e8 88 1e 00 00       	call   80104dd0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f48:	69 05 80 3d 11 80 bc 	imul   $0xbc,0x80113d80,%eax
80102f4f:	00 00 00 
80102f52:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f57:	39 d8                	cmp    %ebx,%eax
80102f59:	76 78                	jbe    80102fd3 <main+0x133>
80102f5b:	90                   	nop
80102f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80102f60:	e8 3b f8 ff ff       	call   801027a0 <cpunum>
80102f65:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f6b:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f70:	39 c3                	cmp    %eax,%ebx
80102f72:	74 46                	je     80102fba <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f74:	e8 67 f5 ff ff       	call   801024e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f79:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f80:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f83:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f8a:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f8d:	05 00 10 00 00       	add    $0x1000,%eax
80102f92:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f97:	0f b6 03             	movzbl (%ebx),%eax
80102f9a:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102fa1:	00 
80102fa2:	89 04 24             	mov    %eax,(%esp)
80102fa5:	e8 c6 f8 ff ff       	call   80102870 <lapicstartap>
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fb0:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	74 f6                	je     80102fb0 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102fba:	69 05 80 3d 11 80 bc 	imul   $0xbc,0x80113d80,%eax
80102fc1:	00 00 00 
80102fc4:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102fca:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102fcf:	39 c3                	cmp    %eax,%ebx
80102fd1:	72 8d                	jb     80102f60 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fd3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102fda:	8e 
80102fdb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102fe2:	e8 a9 f4 ff ff       	call   80102490 <kinit2>
  userinit();      // first user process
80102fe7:	e8 a4 0a 00 00       	call   80103a90 <userinit>
  mpmain();        // finish this processor's setup
80102fec:	e8 4f fe ff ff       	call   80102e40 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80102ff1:	e8 8a 2e 00 00       	call   80105e80 <timerinit>
80102ff6:	e9 2c ff ff ff       	jmp    80102f27 <main+0x87>
80102ffb:	66 90                	xchg   %ax,%ax
80102ffd:	66 90                	xchg   %ax,%ax
80102fff:	90                   	nop

80103000 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103004:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010300a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010300b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010300e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103011:	39 de                	cmp    %ebx,%esi
80103013:	73 3c                	jae    80103051 <mpsearch1+0x51>
80103015:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103018:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010301f:	00 
80103020:	c7 44 24 04 e8 7d 10 	movl   $0x80107de8,0x4(%esp)
80103027:	80 
80103028:	89 34 24             	mov    %esi,(%esp)
8010302b:	e8 50 1d 00 00       	call   80104d80 <memcmp>
80103030:	85 c0                	test   %eax,%eax
80103032:	75 16                	jne    8010304a <mpsearch1+0x4a>
80103034:	31 c9                	xor    %ecx,%ecx
80103036:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103038:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010303c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010303f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103041:	83 fa 10             	cmp    $0x10,%edx
80103044:	75 f2                	jne    80103038 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103046:	84 c9                	test   %cl,%cl
80103048:	74 10                	je     8010305a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
8010304a:	83 c6 10             	add    $0x10,%esi
8010304d:	39 f3                	cmp    %esi,%ebx
8010304f:	77 c7                	ja     80103018 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103051:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103054:	31 c0                	xor    %eax,%eax
}
80103056:	5b                   	pop    %ebx
80103057:	5e                   	pop    %esi
80103058:	5d                   	pop    %ebp
80103059:	c3                   	ret    
8010305a:	83 c4 10             	add    $0x10,%esp
8010305d:	89 f0                	mov    %esi,%eax
8010305f:	5b                   	pop    %ebx
80103060:	5e                   	pop    %esi
80103061:	5d                   	pop    %ebp
80103062:	c3                   	ret    
80103063:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103070 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	57                   	push   %edi
80103074:	56                   	push   %esi
80103075:	53                   	push   %ebx
80103076:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103079:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103080:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103087:	c1 e0 08             	shl    $0x8,%eax
8010308a:	09 d0                	or     %edx,%eax
8010308c:	c1 e0 04             	shl    $0x4,%eax
8010308f:	85 c0                	test   %eax,%eax
80103091:	75 1b                	jne    801030ae <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103093:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010309a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030a1:	c1 e0 08             	shl    $0x8,%eax
801030a4:	09 d0                	or     %edx,%eax
801030a6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030a9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801030ae:	ba 00 04 00 00       	mov    $0x400,%edx
801030b3:	e8 48 ff ff ff       	call   80103000 <mpsearch1>
801030b8:	85 c0                	test   %eax,%eax
801030ba:	89 c7                	mov    %eax,%edi
801030bc:	0f 84 4e 01 00 00    	je     80103210 <mpinit+0x1a0>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030c2:	8b 77 04             	mov    0x4(%edi),%esi
801030c5:	85 f6                	test   %esi,%esi
801030c7:	0f 84 ce 00 00 00    	je     8010319b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030cd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801030d3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801030da:	00 
801030db:	c7 44 24 04 ed 7d 10 	movl   $0x80107ded,0x4(%esp)
801030e2:	80 
801030e3:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801030e9:	e8 92 1c 00 00       	call   80104d80 <memcmp>
801030ee:	85 c0                	test   %eax,%eax
801030f0:	0f 85 a5 00 00 00    	jne    8010319b <mpinit+0x12b>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801030f6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801030fd:	3c 04                	cmp    $0x4,%al
801030ff:	0f 85 29 01 00 00    	jne    8010322e <mpinit+0x1be>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103105:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010310c:	85 c0                	test   %eax,%eax
8010310e:	74 1d                	je     8010312d <mpinit+0xbd>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103110:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103112:	31 d2                	xor    %edx,%edx
80103114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103118:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010311f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103120:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103123:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103125:	39 d0                	cmp    %edx,%eax
80103127:	7f ef                	jg     80103118 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103129:	84 c9                	test   %cl,%cl
8010312b:	75 6e                	jne    8010319b <mpinit+0x12b>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010312d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103130:	85 db                	test   %ebx,%ebx
80103132:	74 67                	je     8010319b <mpinit+0x12b>
    return;
  ismp = 1;
80103134:	c7 05 84 37 11 80 01 	movl   $0x1,0x80113784
8010313b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010313e:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103144:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103149:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
80103150:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103156:	01 d9                	add    %ebx,%ecx
80103158:	39 c8                	cmp    %ecx,%eax
8010315a:	0f 83 90 00 00 00    	jae    801031f0 <mpinit+0x180>
    switch(*p){
80103160:	80 38 04             	cmpb   $0x4,(%eax)
80103163:	77 7b                	ja     801031e0 <mpinit+0x170>
80103165:	0f b6 10             	movzbl (%eax),%edx
80103168:	ff 24 95 f4 7d 10 80 	jmp    *-0x7fef820c(,%edx,4)
8010316f:	90                   	nop
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103170:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103173:	39 c1                	cmp    %eax,%ecx
80103175:	77 e9                	ja     80103160 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103177:	a1 84 37 11 80       	mov    0x80113784,%eax
8010317c:	85 c0                	test   %eax,%eax
8010317e:	75 70                	jne    801031f0 <mpinit+0x180>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103180:	c7 05 80 3d 11 80 01 	movl   $0x1,0x80113d80
80103187:	00 00 00 
    lapic = 0;
8010318a:	c7 05 9c 36 11 80 00 	movl   $0x0,0x8011369c
80103191:	00 00 00 
    ioapicid = 0;
80103194:	c6 05 80 37 11 80 00 	movb   $0x0,0x80113780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010319b:	83 c4 1c             	add    $0x1c,%esp
8010319e:	5b                   	pop    %ebx
8010319f:	5e                   	pop    %esi
801031a0:	5f                   	pop    %edi
801031a1:	5d                   	pop    %ebp
801031a2:	c3                   	ret    
801031a3:	90                   	nop
801031a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801031a8:	8b 15 80 3d 11 80    	mov    0x80113d80,%edx
801031ae:	83 fa 07             	cmp    $0x7,%edx
801031b1:	7f 17                	jg     801031ca <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031b3:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
801031b7:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
        ncpu++;
801031bd:	83 05 80 3d 11 80 01 	addl   $0x1,0x80113d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031c4:	88 9a a0 37 11 80    	mov    %bl,-0x7feec860(%edx)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801031ca:	83 c0 14             	add    $0x14,%eax
      continue;
801031cd:	eb a4                	jmp    80103173 <mpinit+0x103>
801031cf:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031d0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031d4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801031d7:	88 15 80 37 11 80    	mov    %dl,0x80113780
      p += sizeof(struct mpioapic);
      continue;
801031dd:	eb 94                	jmp    80103173 <mpinit+0x103>
801031df:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031e0:	c7 05 84 37 11 80 00 	movl   $0x0,0x80113784
801031e7:	00 00 00 
      break;
801031ea:	eb 87                	jmp    80103173 <mpinit+0x103>
801031ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
801031f0:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801031f4:	74 a5                	je     8010319b <mpinit+0x12b>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031f6:	ba 22 00 00 00       	mov    $0x22,%edx
801031fb:	b8 70 00 00 00       	mov    $0x70,%eax
80103200:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103201:	b2 23                	mov    $0x23,%dl
80103203:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103204:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103207:	ee                   	out    %al,(%dx)
  }
}
80103208:	83 c4 1c             	add    $0x1c,%esp
8010320b:	5b                   	pop    %ebx
8010320c:	5e                   	pop    %esi
8010320d:	5f                   	pop    %edi
8010320e:	5d                   	pop    %ebp
8010320f:	c3                   	ret    
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103210:	ba 00 00 01 00       	mov    $0x10000,%edx
80103215:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010321a:	e8 e1 fd ff ff       	call   80103000 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010321f:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103221:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103223:	0f 85 99 fe ff ff    	jne    801030c2 <mpinit+0x52>
80103229:	e9 6d ff ff ff       	jmp    8010319b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
8010322e:	3c 01                	cmp    $0x1,%al
80103230:	0f 84 cf fe ff ff    	je     80103105 <mpinit+0x95>
80103236:	e9 60 ff ff ff       	jmp    8010319b <mpinit+0x12b>
8010323b:	66 90                	xchg   %ax,%ax
8010323d:	66 90                	xchg   %ax,%ax
8010323f:	90                   	nop

80103240 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103240:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103241:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103246:	89 e5                	mov    %esp,%ebp
80103248:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
8010324d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103250:	d3 c0                	rol    %cl,%eax
80103252:	66 23 05 00 b0 10 80 	and    0x8010b000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103259:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
8010325f:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
80103260:	66 c1 e8 08          	shr    $0x8,%ax
80103264:	b2 a1                	mov    $0xa1,%dl
80103266:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
80103267:	5d                   	pop    %ebp
80103268:	c3                   	ret    
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103270 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103270:	55                   	push   %ebp
80103271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103276:	89 e5                	mov    %esp,%ebp
80103278:	57                   	push   %edi
80103279:	56                   	push   %esi
8010327a:	53                   	push   %ebx
8010327b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103280:	89 da                	mov    %ebx,%edx
80103282:	ee                   	out    %al,(%dx)
80103283:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103288:	89 ca                	mov    %ecx,%edx
8010328a:	ee                   	out    %al,(%dx)
8010328b:	bf 11 00 00 00       	mov    $0x11,%edi
80103290:	be 20 00 00 00       	mov    $0x20,%esi
80103295:	89 f8                	mov    %edi,%eax
80103297:	89 f2                	mov    %esi,%edx
80103299:	ee                   	out    %al,(%dx)
8010329a:	b8 20 00 00 00       	mov    $0x20,%eax
8010329f:	89 da                	mov    %ebx,%edx
801032a1:	ee                   	out    %al,(%dx)
801032a2:	b8 04 00 00 00       	mov    $0x4,%eax
801032a7:	ee                   	out    %al,(%dx)
801032a8:	b8 03 00 00 00       	mov    $0x3,%eax
801032ad:	ee                   	out    %al,(%dx)
801032ae:	b3 a0                	mov    $0xa0,%bl
801032b0:	89 f8                	mov    %edi,%eax
801032b2:	89 da                	mov    %ebx,%edx
801032b4:	ee                   	out    %al,(%dx)
801032b5:	b8 28 00 00 00       	mov    $0x28,%eax
801032ba:	89 ca                	mov    %ecx,%edx
801032bc:	ee                   	out    %al,(%dx)
801032bd:	b8 02 00 00 00       	mov    $0x2,%eax
801032c2:	ee                   	out    %al,(%dx)
801032c3:	b8 03 00 00 00       	mov    $0x3,%eax
801032c8:	ee                   	out    %al,(%dx)
801032c9:	bf 68 00 00 00       	mov    $0x68,%edi
801032ce:	89 f2                	mov    %esi,%edx
801032d0:	89 f8                	mov    %edi,%eax
801032d2:	ee                   	out    %al,(%dx)
801032d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
801032d8:	89 c8                	mov    %ecx,%eax
801032da:	ee                   	out    %al,(%dx)
801032db:	89 f8                	mov    %edi,%eax
801032dd:	89 da                	mov    %ebx,%edx
801032df:	ee                   	out    %al,(%dx)
801032e0:	89 c8                	mov    %ecx,%eax
801032e2:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
801032e3:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
801032ea:	66 83 f8 ff          	cmp    $0xffff,%ax
801032ee:	74 0a                	je     801032fa <picinit+0x8a>
801032f0:	b2 21                	mov    $0x21,%dl
801032f2:	ee                   	out    %al,(%dx)
static void
picsetmask(ushort mask)
{
  irqmask = mask;
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
801032f3:	66 c1 e8 08          	shr    $0x8,%ax
801032f7:	b2 a1                	mov    $0xa1,%dl
801032f9:	ee                   	out    %al,(%dx)
  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    picsetmask(irqmask);
}
801032fa:	5b                   	pop    %ebx
801032fb:	5e                   	pop    %esi
801032fc:	5f                   	pop    %edi
801032fd:	5d                   	pop    %ebp
801032fe:	c3                   	ret    
801032ff:	90                   	nop

80103300 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	53                   	push   %ebx
80103306:	83 ec 1c             	sub    $0x1c,%esp
80103309:	8b 75 08             	mov    0x8(%ebp),%esi
8010330c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010330f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103315:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010331b:	e8 90 da ff ff       	call   80100db0 <filealloc>
80103320:	85 c0                	test   %eax,%eax
80103322:	89 06                	mov    %eax,(%esi)
80103324:	0f 84 a4 00 00 00    	je     801033ce <pipealloc+0xce>
8010332a:	e8 81 da ff ff       	call   80100db0 <filealloc>
8010332f:	85 c0                	test   %eax,%eax
80103331:	89 03                	mov    %eax,(%ebx)
80103333:	0f 84 87 00 00 00    	je     801033c0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103339:	e8 a2 f1 ff ff       	call   801024e0 <kalloc>
8010333e:	85 c0                	test   %eax,%eax
80103340:	89 c7                	mov    %eax,%edi
80103342:	74 7c                	je     801033c0 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
80103344:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010334b:	00 00 00 
  p->writeopen = 1;
8010334e:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103355:	00 00 00 
  p->nwrite = 0;
80103358:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010335f:	00 00 00 
  p->nread = 0;
80103362:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103369:	00 00 00 
  initlock(&p->lock, "pipe");
8010336c:	89 04 24             	mov    %eax,(%esp)
8010336f:	c7 44 24 04 08 7e 10 	movl   $0x80107e08,0x4(%esp)
80103376:	80 
80103377:	e8 b4 17 00 00       	call   80104b30 <initlock>
  (*f0)->type = FD_PIPE;
8010337c:	8b 06                	mov    (%esi),%eax
8010337e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103384:	8b 06                	mov    (%esi),%eax
80103386:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010338a:	8b 06                	mov    (%esi),%eax
8010338c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103390:	8b 06                	mov    (%esi),%eax
80103392:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103395:	8b 03                	mov    (%ebx),%eax
80103397:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010339d:	8b 03                	mov    (%ebx),%eax
8010339f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033a3:	8b 03                	mov    (%ebx),%eax
801033a5:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033a9:	8b 03                	mov    (%ebx),%eax
  return 0;
801033ab:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
801033ad:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033b0:	83 c4 1c             	add    $0x1c,%esp
801033b3:	89 d8                	mov    %ebx,%eax
801033b5:	5b                   	pop    %ebx
801033b6:	5e                   	pop    %esi
801033b7:	5f                   	pop    %edi
801033b8:	5d                   	pop    %ebp
801033b9:	c3                   	ret    
801033ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801033c0:	8b 06                	mov    (%esi),%eax
801033c2:	85 c0                	test   %eax,%eax
801033c4:	74 08                	je     801033ce <pipealloc+0xce>
    fileclose(*f0);
801033c6:	89 04 24             	mov    %eax,(%esp)
801033c9:	e8 a2 da ff ff       	call   80100e70 <fileclose>
  if(*f1)
801033ce:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
801033d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
801033d5:	85 c0                	test   %eax,%eax
801033d7:	74 d7                	je     801033b0 <pipealloc+0xb0>
    fileclose(*f1);
801033d9:	89 04 24             	mov    %eax,(%esp)
801033dc:	e8 8f da ff ff       	call   80100e70 <fileclose>
  return -1;
}
801033e1:	83 c4 1c             	add    $0x1c,%esp
801033e4:	89 d8                	mov    %ebx,%eax
801033e6:	5b                   	pop    %ebx
801033e7:	5e                   	pop    %esi
801033e8:	5f                   	pop    %edi
801033e9:	5d                   	pop    %ebp
801033ea:	c3                   	ret    
801033eb:	90                   	nop
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	56                   	push   %esi
801033f4:	53                   	push   %ebx
801033f5:	83 ec 10             	sub    $0x10,%esp
801033f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033fe:	89 1c 24             	mov    %ebx,(%esp)
80103401:	e8 aa 17 00 00       	call   80104bb0 <acquire>
  if(writable){
80103406:	85 f6                	test   %esi,%esi
80103408:	74 3e                	je     80103448 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010340a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103410:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103417:	00 00 00 
    wakeup(&p->nread);
8010341a:	89 04 24             	mov    %eax,(%esp)
8010341d:	e8 ce 11 00 00       	call   801045f0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103422:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103428:	85 d2                	test   %edx,%edx
8010342a:	75 0a                	jne    80103436 <pipeclose+0x46>
8010342c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103432:	85 c0                	test   %eax,%eax
80103434:	74 32                	je     80103468 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103436:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103439:	83 c4 10             	add    $0x10,%esp
8010343c:	5b                   	pop    %ebx
8010343d:	5e                   	pop    %esi
8010343e:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010343f:	e9 9c 18 00 00       	jmp    80104ce0 <release>
80103444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103448:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
8010344e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103455:	00 00 00 
    wakeup(&p->nwrite);
80103458:	89 04 24             	mov    %eax,(%esp)
8010345b:	e8 90 11 00 00       	call   801045f0 <wakeup>
80103460:	eb c0                	jmp    80103422 <pipeclose+0x32>
80103462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103468:	89 1c 24             	mov    %ebx,(%esp)
8010346b:	e8 70 18 00 00       	call   80104ce0 <release>
    kfree((char*)p);
80103470:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103473:	83 c4 10             	add    $0x10,%esp
80103476:	5b                   	pop    %ebx
80103477:	5e                   	pop    %esi
80103478:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103479:	e9 b2 ee ff ff       	jmp    80102330 <kfree>
8010347e:	66 90                	xchg   %ax,%ax

80103480 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 1c             	sub    $0x1c,%esp
80103489:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010348c:	89 3c 24             	mov    %edi,(%esp)
8010348f:	e8 1c 17 00 00       	call   80104bb0 <acquire>
  for(i = 0; i < n; i++){
80103494:	8b 45 10             	mov    0x10(%ebp),%eax
80103497:	85 c0                	test   %eax,%eax
80103499:	0f 8e c2 00 00 00    	jle    80103561 <pipewrite+0xe1>
8010349f:	8b 45 0c             	mov    0xc(%ebp),%eax
801034a2:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
801034a8:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
801034ae:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
801034b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034b7:	03 45 10             	add    0x10(%ebp),%eax
801034ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034bd:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801034c3:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801034c9:	39 d1                	cmp    %edx,%ecx
801034cb:	0f 85 c4 00 00 00    	jne    80103595 <pipewrite+0x115>
      if(p->readopen == 0 || proc->killed){
801034d1:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
801034d7:	85 d2                	test   %edx,%edx
801034d9:	0f 84 a1 00 00 00    	je     80103580 <pipewrite+0x100>
801034df:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801034e6:	8b 42 24             	mov    0x24(%edx),%eax
801034e9:	85 c0                	test   %eax,%eax
801034eb:	74 22                	je     8010350f <pipewrite+0x8f>
801034ed:	e9 8e 00 00 00       	jmp    80103580 <pipewrite+0x100>
801034f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034f8:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
801034fe:	85 c0                	test   %eax,%eax
80103500:	74 7e                	je     80103580 <pipewrite+0x100>
80103502:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103508:	8b 48 24             	mov    0x24(%eax),%ecx
8010350b:	85 c9                	test   %ecx,%ecx
8010350d:	75 71                	jne    80103580 <pipewrite+0x100>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010350f:	89 34 24             	mov    %esi,(%esp)
80103512:	e8 d9 10 00 00       	call   801045f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103517:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010351b:	89 1c 24             	mov    %ebx,(%esp)
8010351e:	e8 cd 0e 00 00       	call   801043f0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103523:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103529:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
8010352f:	05 00 02 00 00       	add    $0x200,%eax
80103534:	39 c2                	cmp    %eax,%edx
80103536:	74 c0                	je     801034f8 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010353b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010353e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103544:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
8010354a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010354e:	0f b6 00             	movzbl (%eax),%eax
80103551:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103558:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010355b:	0f 85 5c ff ff ff    	jne    801034bd <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103561:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
80103567:	89 14 24             	mov    %edx,(%esp)
8010356a:	e8 81 10 00 00       	call   801045f0 <wakeup>
  release(&p->lock);
8010356f:	89 3c 24             	mov    %edi,(%esp)
80103572:	e8 69 17 00 00       	call   80104ce0 <release>
  return n;
80103577:	8b 45 10             	mov    0x10(%ebp),%eax
8010357a:	eb 11                	jmp    8010358d <pipewrite+0x10d>
8010357c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103580:	89 3c 24             	mov    %edi,(%esp)
80103583:	e8 58 17 00 00       	call   80104ce0 <release>
        return -1;
80103588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010358d:	83 c4 1c             	add    $0x1c,%esp
80103590:	5b                   	pop    %ebx
80103591:	5e                   	pop    %esi
80103592:	5f                   	pop    %edi
80103593:	5d                   	pop    %ebp
80103594:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103595:	89 ca                	mov    %ecx,%edx
80103597:	eb 9f                	jmp    80103538 <pipewrite+0xb8>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035a0 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	57                   	push   %edi
801035a4:	56                   	push   %esi
801035a5:	53                   	push   %ebx
801035a6:	83 ec 1c             	sub    $0x1c,%esp
801035a9:	8b 75 08             	mov    0x8(%ebp),%esi
801035ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801035af:	89 34 24             	mov    %esi,(%esp)
801035b2:	e8 f9 15 00 00       	call   80104bb0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035b7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801035bd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801035c3:	75 5b                	jne    80103620 <piperead+0x80>
801035c5:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801035cb:	85 db                	test   %ebx,%ebx
801035cd:	74 51                	je     80103620 <piperead+0x80>
801035cf:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035d5:	eb 25                	jmp    801035fc <piperead+0x5c>
801035d7:	90                   	nop
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035d8:	89 74 24 04          	mov    %esi,0x4(%esp)
801035dc:	89 1c 24             	mov    %ebx,(%esp)
801035df:	e8 0c 0e 00 00       	call   801043f0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035e4:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801035ea:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801035f0:	75 2e                	jne    80103620 <piperead+0x80>
801035f2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035f8:	85 d2                	test   %edx,%edx
801035fa:	74 24                	je     80103620 <piperead+0x80>
    if(proc->killed){
801035fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103602:	8b 48 24             	mov    0x24(%eax),%ecx
80103605:	85 c9                	test   %ecx,%ecx
80103607:	74 cf                	je     801035d8 <piperead+0x38>
      release(&p->lock);
80103609:	89 34 24             	mov    %esi,(%esp)
8010360c:	e8 cf 16 00 00       	call   80104ce0 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103611:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
80103614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103619:	5b                   	pop    %ebx
8010361a:	5e                   	pop    %esi
8010361b:	5f                   	pop    %edi
8010361c:	5d                   	pop    %ebp
8010361d:	c3                   	ret    
8010361e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103620:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103623:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103625:	85 d2                	test   %edx,%edx
80103627:	7f 2b                	jg     80103654 <piperead+0xb4>
80103629:	eb 31                	jmp    8010365c <piperead+0xbc>
8010362b:	90                   	nop
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103630:	8d 48 01             	lea    0x1(%eax),%ecx
80103633:	25 ff 01 00 00       	and    $0x1ff,%eax
80103638:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010363e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103643:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103646:	83 c3 01             	add    $0x1,%ebx
80103649:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010364c:	74 0e                	je     8010365c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010364e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103654:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010365a:	75 d4                	jne    80103630 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010365c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103662:	89 04 24             	mov    %eax,(%esp)
80103665:	e8 86 0f 00 00       	call   801045f0 <wakeup>
  release(&p->lock);
8010366a:	89 34 24             	mov    %esi,(%esp)
8010366d:	e8 6e 16 00 00       	call   80104ce0 <release>
  return i;
}
80103672:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103675:	89 d8                	mov    %ebx,%eax
}
80103677:	5b                   	pop    %ebx
80103678:	5e                   	pop    %esi
80103679:	5f                   	pop    %edi
8010367a:	5d                   	pop    %ebp
8010367b:	c3                   	ret    
8010367c:	66 90                	xchg   %ax,%ax
8010367e:	66 90                	xchg   %ax,%ax

80103680 <stride_queue_heapify_down>:

}

void
stride_queue_heapify_down(int stride_idx) 
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	57                   	push   %edi
80103684:	56                   	push   %esi
80103685:	53                   	push   %ebx
  struct proc* p = ptable.stride_queue[stride_idx];

  while(stride_idx * 2 < NPROC // If stride_idx indicates that it is leaf node, break the loop
80103686:	8d 14 00             	lea    (%eax,%eax,1),%edx

}

void
stride_queue_heapify_down(int stride_idx) 
{
80103689:	83 ec 04             	sub    $0x4,%esp
  struct proc* p = ptable.stride_queue[stride_idx];
8010368c:	8d b0 d0 09 00 00    	lea    0x9d0(%eax),%esi

  while(stride_idx * 2 < NPROC // If stride_idx indicates that it is leaf node, break the loop
80103692:	83 fa 3f             	cmp    $0x3f,%edx
}

void
stride_queue_heapify_down(int stride_idx) 
{
  struct proc* p = ptable.stride_queue[stride_idx];
80103695:	8b 3c b5 2c 3e 11 80 	mov    -0x7feec1d4(,%esi,4),%edi

  while(stride_idx * 2 < NPROC // If stride_idx indicates that it is leaf node, break the loop
8010369c:	7f 72                	jg     80103710 <stride_queue_heapify_down+0x90>
      && stride_idx <= ptable.stride_queue_size){
8010369e:	8b 1d 74 66 11 80    	mov    0x80116674,%ebx
801036a4:	39 d8                	cmp    %ebx,%eax
801036a6:	89 5d f0             	mov    %ebx,-0x10(%ebp)
801036a9:	7e 5a                	jle    80103705 <stride_queue_heapify_down+0x85>
801036ab:	eb 63                	jmp    80103710 <stride_queue_heapify_down+0x90>
801036ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(ptable.stride_queue[stride_idx * 2] 
        && ptable.stride_queue[stride_idx * 2 + 1]){
801036b0:	8b 1c 95 70 65 11 80 	mov    -0x7fee9a90(,%edx,4),%ebx
801036b7:	8d 42 01             	lea    0x1(%edx),%eax
801036ba:	85 db                	test   %ebx,%ebx
801036bc:	74 62                	je     80103720 <stride_queue_heapify_down+0xa0>
      // two childen

      // get smaller one among children
      stride_idx = ptable.stride_queue[stride_idx * 2]->stride_count 
                    < ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
                    ? stride_idx * 2 : stride_idx * 2 + 1;
801036be:	8b b3 90 00 00 00    	mov    0x90(%ebx),%esi
801036c4:	39 b1 90 00 00 00    	cmp    %esi,0x90(%ecx)

      // if children's minimum is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
801036ca:	8b 9f 90 00 00 00    	mov    0x90(%edi),%ebx
      // two childen

      // get smaller one among children
      stride_idx = ptable.stride_queue[stride_idx * 2]->stride_count 
                    < ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
                    ? stride_idx * 2 : stride_idx * 2 + 1;
801036d0:	0f 4c c2             	cmovl  %edx,%eax

      // if children's minimum is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
801036d3:	8d b0 d0 09 00 00    	lea    0x9d0(%eax),%esi
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
801036d9:	89 c2                	mov    %eax,%edx
      stride_idx = ptable.stride_queue[stride_idx * 2]->stride_count 
                    < ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
                    ? stride_idx * 2 : stride_idx * 2 + 1;

      // if children's minimum is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
801036db:	8b 0c b5 2c 3e 11 80 	mov    -0x7feec1d4(,%esi,4),%ecx
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
801036e2:	c1 ea 1f             	shr    $0x1f,%edx
      stride_idx = ptable.stride_queue[stride_idx * 2]->stride_count 
                    < ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
                    ? stride_idx * 2 : stride_idx * 2 + 1;

      // if children's minimum is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
801036e5:	39 99 90 00 00 00    	cmp    %ebx,0x90(%ecx)
801036eb:	7d 63                	jge    80103750 <stride_queue_heapify_down+0xd0>
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
801036ed:	01 c2                	add    %eax,%edx
801036ef:	d1 fa                	sar    %edx
801036f1:	89 0c 95 6c 65 11 80 	mov    %ecx,-0x7fee9a94(,%edx,4)
void
stride_queue_heapify_down(int stride_idx) 
{
  struct proc* p = ptable.stride_queue[stride_idx];

  while(stride_idx * 2 < NPROC // If stride_idx indicates that it is leaf node, break the loop
801036f8:	8d 14 00             	lea    (%eax,%eax,1),%edx
801036fb:	83 fa 3f             	cmp    $0x3f,%edx
801036fe:	7f 10                	jg     80103710 <stride_queue_heapify_down+0x90>
      && stride_idx <= ptable.stride_queue_size){
80103700:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103703:	7f 0b                	jg     80103710 <stride_queue_heapify_down+0x90>
    if(ptable.stride_queue[stride_idx * 2] 
80103705:	8b 0c 95 6c 65 11 80 	mov    -0x7fee9a94(,%edx,4),%ecx
8010370c:	85 c9                	test   %ecx,%ecx
8010370e:	75 a0                	jne    801036b0 <stride_queue_heapify_down+0x30>
      break;
    }
  }
  
  // current process' place
  ptable.stride_queue[stride_idx] = p;
80103710:	89 3c b5 2c 3e 11 80 	mov    %edi,-0x7feec1d4(,%esi,4)

}
80103717:	83 c4 04             	add    $0x4,%esp
8010371a:	5b                   	pop    %ebx
8010371b:	5e                   	pop    %esi
8010371c:	5f                   	pop    %edi
8010371d:	5d                   	pop    %ebp
8010371e:	c3                   	ret    
8010371f:	90                   	nop

    }else if(ptable.stride_queue[stride_idx * 2]){
      // only left child (== the last element)
      stride_idx *= 2;
      // if left child's value is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
80103720:	8b 87 90 00 00 00    	mov    0x90(%edi),%eax
80103726:	39 81 90 00 00 00    	cmp    %eax,0x90(%ecx)
8010372c:	7d e2                	jge    80103710 <stride_queue_heapify_down+0x90>
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
8010372e:	89 0c b5 2c 3e 11 80 	mov    %ecx,-0x7feec1d4(,%esi,4)
80103735:	8d b2 d0 09 00 00    	lea    0x9d0(%edx),%esi
      break;
    }
  }
  
  // current process' place
  ptable.stride_queue[stride_idx] = p;
8010373b:	89 3c b5 2c 3e 11 80 	mov    %edi,-0x7feec1d4(,%esi,4)

}
80103742:	83 c4 04             	add    $0x4,%esp
80103745:	5b                   	pop    %ebx
80103746:	5e                   	pop    %esi
80103747:	5f                   	pop    %edi
80103748:	5d                   	pop    %ebp
80103749:	c3                   	ret    
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

      // if children's minimum is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count){
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
      }else{
        stride_idx /= 2;
80103750:	01 d0                	add    %edx,%eax
80103752:	d1 f8                	sar    %eax
80103754:	8d b0 d0 09 00 00    	lea    0x9d0(%eax),%esi
      break;
    }
  }
  
  // current process' place
  ptable.stride_queue[stride_idx] = p;
8010375a:	89 3c b5 2c 3e 11 80 	mov    %edi,-0x7feec1d4(,%esi,4)

}
80103761:	83 c4 04             	add    $0x4,%esp
80103764:	5b                   	pop    %ebx
80103765:	5e                   	pop    %esi
80103766:	5f                   	pop    %edi
80103767:	5d                   	pop    %ebp
80103768:	c3                   	ret    
80103769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103770 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103774:	bb 54 3e 11 80       	mov    $0x80113e54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103779:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010377c:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103783:	e8 28 14 00 00       	call   80104bb0 <acquire>
80103788:	eb 18                	jmp    801037a2 <allocproc+0x32>
8010378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103790:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103796:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
8010379c:	0f 84 c6 00 00 00    	je     80103868 <allocproc+0xf8>
    if(p->state == UNUSED)
801037a2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037a5:	85 c0                	test   %eax,%eax
801037a7:	75 e7                	jne    80103790 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037a9:	a1 10 b0 10 80       	mov    0x8010b010,%eax
  // Design Document 2-1-2-2
  // Related with threads.
  p->tid = 0;
  p->pgdir_ref_idx = -1;

  release(&ptable.lock);
801037ae:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801037b5:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
  
  // Design Document 1-1-2-2.
  // initializing values used in MLFQ.
  p->tick_used = 0;
801037bc:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037c3:	8d 50 01             	lea    0x1(%eax),%edx
801037c6:	89 15 10 b0 10 80    	mov    %edx,0x8010b010
801037cc:	89 43 10             	mov    %eax,0x10(%ebx)
  
  // Design Document 1-1-2-2.
  // initializing values used in MLFQ.
  p->tick_used = 0;
  p->level_of_MLFQ = 0;
801037cf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801037d6:	00 00 00 
  p->time_quantum_used = 0;
801037d9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801037e0:	00 00 00 

  // Design Document 1-2-2-2.
  // Initializing cpu_share
  p->cpu_share = 0;
801037e3:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
801037ea:	00 00 00 
  p->stride = 0;
801037ed:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801037f4:	00 00 00 
  p->stride_count = 0;
801037f7:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
801037fe:	00 00 00 

  // Design Document 2-1-2-2
  // Related with threads.
  p->tid = 0;
80103801:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
80103808:	00 00 00 
  p->pgdir_ref_idx = -1;
8010380b:	c7 83 98 00 00 00 ff 	movl   $0xffffffff,0x98(%ebx)
80103812:	ff ff ff 

  release(&ptable.lock);
80103815:	e8 c6 14 00 00       	call   80104ce0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010381a:	e8 c1 ec ff ff       	call   801024e0 <kalloc>
8010381f:	85 c0                	test   %eax,%eax
80103821:	89 43 08             	mov    %eax,0x8(%ebx)
80103824:	74 56                	je     8010387c <allocproc+0x10c>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103826:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010382c:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103831:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103834:	c7 40 14 cd 5e 10 80 	movl   $0x80105ecd,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010383b:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103842:	00 
80103843:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010384a:	00 
8010384b:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010384e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103851:	e8 da 14 00 00       	call   80104d30 <memset>
  p->context->eip = (uint)forkret;
80103856:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103859:	c7 40 10 90 38 10 80 	movl   $0x80103890,0x10(%eax)

  return p;
80103860:	89 d8                	mov    %ebx,%eax
}
80103862:	83 c4 14             	add    $0x14,%esp
80103865:	5b                   	pop    %ebx
80103866:	5d                   	pop    %ebp
80103867:	c3                   	ret    

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103868:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
8010386f:	e8 6c 14 00 00       	call   80104ce0 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103874:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
80103877:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103879:	5b                   	pop    %ebx
8010387a:	5d                   	pop    %ebp
8010387b:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010387c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103883:	eb dd                	jmp    80103862 <allocproc+0xf2>
80103885:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103890 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103896:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
8010389d:	e8 3e 14 00 00       	call   80104ce0 <release>

  if(first){
801038a2:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801038a7:	85 c0                	test   %eax,%eax
801038a9:	75 05                	jne    801038b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ab:	c9                   	leave  
801038ac:	c3                   	ret    
801038ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(first){
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801038b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if(first){
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801038b7:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
801038be:	00 00 00 
    iinit(ROOTDEV);
801038c1:	e8 fa db ff ff       	call   801014c0 <iinit>
    initlog(ROOTDEV);
801038c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038cd:	e8 5e f2 ff ff       	call   80102b30 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038d2:	c9                   	leave  
801038d3:	c3                   	ret    
801038d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038e0 <check_pgdir_counter_and_call_freevm>:
int pgdir_ref_next_idx = 0;


// Design Dcoument 2-1-2-4
void
check_pgdir_counter_and_call_freevm(struct proc* p) {
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	53                   	push   %ebx
801038e4:	83 ec 14             	sub    $0x14,%esp
801038e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (p->pgdir_ref_idx == -1) {
801038ea:	8b 83 98 00 00 00    	mov    0x98(%ebx),%eax
801038f0:	83 f8 ff             	cmp    $0xffffffff,%eax
801038f3:	74 38                	je     8010392d <check_pgdir_counter_and_call_freevm+0x4d>
    // This is a case in booting
    freevm(p->pgdir);
  } else if (pgdir_ref[p->pgdir_ref_idx] <= 1) {
801038f5:	80 b8 e0 3d 11 80 01 	cmpb   $0x1,-0x7feec220(%eax)
801038fc:	7e 0a                	jle    80103908 <check_pgdir_counter_and_call_freevm+0x28>
    freevm(p->pgdir);
  } else {
    // There is a thread using a same addres space.
    // Do not free it.
  }
}
801038fe:	83 c4 14             	add    $0x14,%esp
80103901:	5b                   	pop    %ebx
80103902:	5d                   	pop    %ebp
80103903:	c3                   	ret    
80103904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    // This is a case in booting
    freevm(p->pgdir);
  } else if (pgdir_ref[p->pgdir_ref_idx] <= 1) {
    // Just only one process was using pgdir.
    // Free it.
    acquire(&thread_lock);
80103908:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010390f:	e8 9c 12 00 00       	call   80104bb0 <acquire>
    pgdir_ref[p->pgdir_ref_idx] = 0;
80103914:	8b 83 98 00 00 00    	mov    0x98(%ebx),%eax
    release(&thread_lock);
8010391a:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
    freevm(p->pgdir);
  } else if (pgdir_ref[p->pgdir_ref_idx] <= 1) {
    // Just only one process was using pgdir.
    // Free it.
    acquire(&thread_lock);
    pgdir_ref[p->pgdir_ref_idx] = 0;
80103921:	c6 80 e0 3d 11 80 00 	movb   $0x0,-0x7feec220(%eax)
    release(&thread_lock);
80103928:	e8 b3 13 00 00       	call   80104ce0 <release>
    freevm(p->pgdir);
8010392d:	8b 43 04             	mov    0x4(%ebx),%eax
80103930:	89 45 08             	mov    %eax,0x8(%ebp)
  } else {
    // There is a thread using a same addres space.
    // Do not free it.
  }
}
80103933:	83 c4 14             	add    $0x14,%esp
80103936:	5b                   	pop    %ebx
80103937:	5d                   	pop    %ebp
    // Just only one process was using pgdir.
    // Free it.
    acquire(&thread_lock);
    pgdir_ref[p->pgdir_ref_idx] = 0;
    release(&thread_lock);
    freevm(p->pgdir);
80103938:	e9 33 3c 00 00       	jmp    80107570 <freevm>
8010393d:	8d 76 00             	lea    0x0(%esi),%esi

80103940 <allocate_new_pgdir_idx>:
    // Do not free it.
  }
}

void
allocate_new_pgdir_idx(struct proc* p) {
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	53                   	push   %ebx
80103944:	83 ec 14             	sub    $0x14,%esp
80103947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&thread_lock);
8010394a:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80103951:	e8 5a 12 00 00       	call   80104bb0 <acquire>
  p->pgdir_ref_idx = pgdir_ref_next_idx++;
80103956:	8b 0d bc b5 10 80    	mov    0x8010b5bc,%ecx
8010395c:	8d 41 01             	lea    0x1(%ecx),%eax
  pgdir_ref_next_idx %= NPROC;
8010395f:	99                   	cltd   
80103960:	c1 ea 1a             	shr    $0x1a,%edx
80103963:	01 d0                	add    %edx,%eax
80103965:	83 e0 3f             	and    $0x3f,%eax
80103968:	29 d0                	sub    %edx,%eax
}

void
allocate_new_pgdir_idx(struct proc* p) {
  acquire(&thread_lock);
  p->pgdir_ref_idx = pgdir_ref_next_idx++;
8010396a:	89 8b 98 00 00 00    	mov    %ecx,0x98(%ebx)
  pgdir_ref_next_idx %= NPROC;
80103970:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
  pgdir_ref[p->pgdir_ref_idx] = 1;
  release(&thread_lock);
80103975:	c7 45 08 a0 3d 11 80 	movl   $0x80113da0,0x8(%ebp)
void
allocate_new_pgdir_idx(struct proc* p) {
  acquire(&thread_lock);
  p->pgdir_ref_idx = pgdir_ref_next_idx++;
  pgdir_ref_next_idx %= NPROC;
  pgdir_ref[p->pgdir_ref_idx] = 1;
8010397c:	c6 81 e0 3d 11 80 01 	movb   $0x1,-0x7feec220(%ecx)
  release(&thread_lock);
}
80103983:	83 c4 14             	add    $0x14,%esp
80103986:	5b                   	pop    %ebx
80103987:	5d                   	pop    %ebp
allocate_new_pgdir_idx(struct proc* p) {
  acquire(&thread_lock);
  p->pgdir_ref_idx = pgdir_ref_next_idx++;
  pgdir_ref_next_idx %= NPROC;
  pgdir_ref[p->pgdir_ref_idx] = 1;
  release(&thread_lock);
80103988:	e9 53 13 00 00       	jmp    80104ce0 <release>
8010398d:	8d 76 00             	lea    0x0(%esi),%esi

80103990 <get_time_quantum>:

// getters and setters
int
get_time_quantum() 
{
  if(proc && proc->cpu_share != 0){
80103990:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax


// getters and setters
int
get_time_quantum() 
{
80103996:	55                   	push   %ebp
80103997:	89 e5                	mov    %esp,%ebp
  if(proc && proc->cpu_share != 0){
80103999:	85 c0                	test   %eax,%eax
8010399b:	74 0a                	je     801039a7 <get_time_quantum+0x17>
8010399d:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
801039a3:	85 d2                	test   %edx,%edx
801039a5:	75 11                	jne    801039b8 <get_time_quantum+0x28>
    return ptable.stride_time_quantum;
  }else{
    return ptable.MLFQ_time_quantum[proc->level_of_MLFQ];
801039a7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  }
}
801039ad:	5d                   	pop    %ebp
get_time_quantum() 
{
  if(proc && proc->cpu_share != 0){
    return ptable.stride_time_quantum;
  }else{
    return ptable.MLFQ_time_quantum[proc->level_of_MLFQ];
801039ae:	8b 04 85 54 65 11 80 	mov    -0x7fee9aac(,%eax,4),%eax
  }
}
801039b5:	c3                   	ret    
801039b6:	66 90                	xchg   %ax,%ax
// getters and setters
int
get_time_quantum() 
{
  if(proc && proc->cpu_share != 0){
    return ptable.stride_time_quantum;
801039b8:	a1 78 66 11 80       	mov    0x80116678,%eax
  }else{
    return ptable.MLFQ_time_quantum[proc->level_of_MLFQ];
  }
}
801039bd:	5d                   	pop    %ebp
801039be:	c3                   	ret    
801039bf:	90                   	nop

801039c0 <get_MLFQ_tick_used>:

// Design Document 1-1-2-4
int
get_MLFQ_tick_used(void)
{
801039c0:	55                   	push   %ebp
  return ptable.MLFQ_tick_used;
}
801039c1:	a1 60 65 11 80       	mov    0x80116560,%eax
}

// Design Document 1-1-2-4
int
get_MLFQ_tick_used(void)
{
801039c6:	89 e5                	mov    %esp,%ebp
  return ptable.MLFQ_tick_used;
}
801039c8:	5d                   	pop    %ebp
801039c9:	c3                   	ret    
801039ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039d0 <increase_MLFQ_tick_used>:

void
increase_MLFQ_tick_used(void)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
  ptable.MLFQ_tick_used++;
801039d3:	83 05 60 65 11 80 01 	addl   $0x1,0x80116560
#ifdef STRIRDE_DEBUGGING
  cprintf("\rMLFQ_tick_used: %d", ptable.MLFQ_tick_used);
#endif
}
801039da:	5d                   	pop    %ebp
801039db:	c3                   	ret    
801039dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039e0 <increase_stride_tick_used>:

void
increase_stride_tick_used(void)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
  ptable.stride_tick_used++;
801039e3:	83 05 7c 66 11 80 01 	addl   $0x1,0x8011667c
#ifdef STRIRDE_DEBUGGING
  cprintf("\rstride_tick_used: %d", ptable.stride_tick_used);
#endif
}
801039ea:	5d                   	pop    %ebp
801039eb:	c3                   	ret    
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039f0 <pinit>:


void
pinit(void)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	83 ec 18             	sub    $0x18,%esp
  // Design Document 1-1-2-4. Initializing the time_quantum array.
  int queue_level;
  int default_ticks = 5;
  initlock(&ptable.lock, "ptable");
801039f6:	c7 44 24 04 0d 7e 10 	movl   $0x80107e0d,0x4(%esp)
801039fd:	80 
801039fe:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103a05:	e8 26 11 00 00       	call   80104b30 <initlock>
  ptable.MLFQ_tick_used = 0;

  ptable.queue_level_at_most = NMLFQ - 1;
  ptable.min_of_run_proc_level = NMLFQ - 1;

  memset(ptable.stride_queue, 0, sizeof(ptable.stride_queue));
80103a0a:	c7 44 24 08 04 01 00 	movl   $0x104,0x8(%esp)
80103a11:	00 
80103a12:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103a19:	00 
80103a1a:	c7 04 24 6c 65 11 80 	movl   $0x8011656c,(%esp)

  // Initializing ptable variables.
  // Design Document 1-2-2-3.
  // Initializing time quantum
  for(queue_level = 0; queue_level < NMLFQ; ++queue_level){
      ptable.MLFQ_time_quantum[queue_level] = default_ticks;
80103a21:	c7 05 54 65 11 80 05 	movl   $0x5,0x80116554
80103a28:	00 00 00 
80103a2b:	c7 05 58 65 11 80 0a 	movl   $0xa,0x80116558
80103a32:	00 00 00 
80103a35:	c7 05 5c 65 11 80 14 	movl   $0x14,0x8011655c
80103a3c:	00 00 00 
      default_ticks *= 2;
  }
  ptable.MLFQ_tick_used = 0;
80103a3f:	c7 05 60 65 11 80 00 	movl   $0x0,0x80116560
80103a46:	00 00 00 

  ptable.queue_level_at_most = NMLFQ - 1;
80103a49:	c7 05 64 65 11 80 02 	movl   $0x2,0x80116564
80103a50:	00 00 00 
  ptable.min_of_run_proc_level = NMLFQ - 1;
80103a53:	c7 05 68 65 11 80 02 	movl   $0x2,0x80116568
80103a5a:	00 00 00 

  memset(ptable.stride_queue, 0, sizeof(ptable.stride_queue));
80103a5d:	e8 ce 12 00 00       	call   80104d30 <memset>
  ptable.sum_cpu_share = 0;
80103a62:	c7 05 70 66 11 80 00 	movl   $0x0,0x80116670
80103a69:	00 00 00 
  ptable.stride_queue_size = 0;
80103a6c:	c7 05 74 66 11 80 00 	movl   $0x0,0x80116674
80103a73:	00 00 00 
  ptable.stride_time_quantum = 1; // It could be changed by designer.
80103a76:	c7 05 78 66 11 80 01 	movl   $0x1,0x80116678
80103a7d:	00 00 00 
  ptable.stride_tick_used = 0;
80103a80:	c7 05 7c 66 11 80 00 	movl   $0x0,0x8011667c
80103a87:	00 00 00 

}
80103a8a:	c9                   	leave  
80103a8b:	c3                   	ret    
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a90 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	53                   	push   %ebx
80103a94:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103a97:	e8 d4 fc ff ff       	call   80103770 <allocproc>
80103a9c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103a9e:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
  if((p->pgdir = setupkvm()) == 0)
80103aa3:	e8 e8 36 00 00       	call   80107190 <setupkvm>
80103aa8:	85 c0                	test   %eax,%eax
80103aaa:	89 43 04             	mov    %eax,0x4(%ebx)
80103aad:	0f 84 d4 00 00 00    	je     80103b87 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ab3:	89 04 24             	mov    %eax,(%esp)
80103ab6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
80103abd:	00 
80103abe:	c7 44 24 04 60 b4 10 	movl   $0x8010b460,0x4(%esp)
80103ac5:	80 
80103ac6:	e8 55 38 00 00       	call   80107320 <inituvm>
  p->sz = PGSIZE;
80103acb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ad1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103ad8:	00 
80103ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103ae0:	00 
80103ae1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae4:	89 04 24             	mov    %eax,(%esp)
80103ae7:	e8 44 12 00 00       	call   80104d30 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aec:	8b 43 18             	mov    0x18(%ebx),%eax
80103aef:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103af4:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103af9:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103afd:	8b 43 18             	mov    0x18(%ebx),%eax
80103b00:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b04:	8b 43 18             	mov    0x18(%ebx),%eax
80103b07:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b0b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b12:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b16:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b1a:	8b 43 18             	mov    0x18(%ebx),%eax
80103b1d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b24:	8b 43 18             	mov    0x18(%ebx),%eax
80103b27:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b2e:	8b 43 18             	mov    0x18(%ebx),%eax
80103b31:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b38:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b3b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103b42:	00 
80103b43:	c7 44 24 04 2d 7e 10 	movl   $0x80107e2d,0x4(%esp)
80103b4a:	80 
80103b4b:	89 04 24             	mov    %eax,(%esp)
80103b4e:	e8 bd 13 00 00       	call   80104f10 <safestrcpy>
  p->cwd = namei("/");
80103b53:	c7 04 24 36 7e 10 80 	movl   $0x80107e36,(%esp)
80103b5a:	e8 d1 e3 ff ff       	call   80101f30 <namei>
80103b5f:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103b62:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103b69:	e8 42 10 00 00       	call   80104bb0 <acquire>

  p->state = RUNNABLE;
80103b6e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103b75:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103b7c:	e8 5f 11 00 00       	call   80104ce0 <release>
}
80103b81:	83 c4 14             	add    $0x14,%esp
80103b84:	5b                   	pop    %ebx
80103b85:	5d                   	pop    %ebp
80103b86:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103b87:	c7 04 24 14 7e 10 80 	movl   $0x80107e14,(%esp)
80103b8e:	e8 cd c7 ff ff       	call   80100360 <panic>
80103b93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ba0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
80103ba6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103bad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
80103bb0:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103bb2:	83 f9 00             	cmp    $0x0,%ecx
80103bb5:	7e 39                	jle    80103bf0 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103bb7:	01 c1                	add    %eax,%ecx
80103bb9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80103bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bc1:	8b 42 04             	mov    0x4(%edx),%eax
80103bc4:	89 04 24             	mov    %eax,(%esp)
80103bc7:	e8 94 38 00 00       	call   80107460 <allocuvm>
80103bcc:	85 c0                	test   %eax,%eax
80103bce:	74 40                	je     80103c10 <growproc+0x70>
80103bd0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  }else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
80103bd7:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103bd9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103bdf:	89 04 24             	mov    %eax,(%esp)
80103be2:	e8 69 36 00 00       	call   80107250 <switchuvm>
  return 0;
80103be7:	31 c0                	xor    %eax,%eax
}
80103be9:	c9                   	leave  
80103bea:	c3                   	ret    
80103beb:	90                   	nop
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }else if(n < 0){
80103bf0:	74 e5                	je     80103bd7 <growproc+0x37>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103bf2:	01 c1                	add    %eax,%ecx
80103bf4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80103bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bfc:	8b 42 04             	mov    0x4(%edx),%eax
80103bff:	89 04 24             	mov    %eax,(%esp)
80103c02:	e8 49 39 00 00       	call   80107550 <deallocuvm>
80103c07:	85 c0                	test   %eax,%eax
80103c09:	75 c5                	jne    80103bd0 <growproc+0x30>
80103c0b:	90                   	nop
80103c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103c15:	c9                   	leave  
80103c16:	c3                   	ret    
80103c17:	89 f6                	mov    %esi,%esi
80103c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c20 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	57                   	push   %edi
80103c24:	56                   	push   %esi
80103c25:	53                   	push   %ebx
80103c26:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103c29:	e8 42 fb ff ff       	call   80103770 <allocproc>
80103c2e:	85 c0                	test   %eax,%eax
80103c30:	89 c3                	mov    %eax,%ebx
80103c32:	0f 84 dd 00 00 00    	je     80103d15 <fork+0xf5>
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103c38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c3e:	8b 10                	mov    (%eax),%edx
80103c40:	89 54 24 04          	mov    %edx,0x4(%esp)
80103c44:	8b 40 04             	mov    0x4(%eax),%eax
80103c47:	89 04 24             	mov    %eax,(%esp)
80103c4a:	e8 d1 39 00 00       	call   80107620 <copyuvm>
80103c4f:	85 c0                	test   %eax,%eax
80103c51:	89 43 04             	mov    %eax,0x4(%ebx)
80103c54:	0f 84 c2 00 00 00    	je     80103d1c <fork+0xfc>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103c5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103c60:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c65:	8b 7b 18             	mov    0x18(%ebx),%edi
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103c68:	8b 00                	mov    (%eax),%eax
80103c6a:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103c6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103c72:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103c75:	8b 70 18             	mov    0x18(%eax),%esi
80103c78:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  allocate_new_pgdir_idx(np);

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103c7a:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // new pgdir is generated. allocate a counter to np
  allocate_new_pgdir_idx(np);
80103c7c:	89 1c 24             	mov    %ebx,(%esp)
80103c7f:	e8 bc fc ff ff       	call   80103940 <allocate_new_pgdir_idx>

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103c84:	8b 43 18             	mov    0x18(%ebx),%eax
80103c87:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c8e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103c95:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103c98:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103c9c:	85 c0                	test   %eax,%eax
80103c9e:	74 13                	je     80103cb3 <fork+0x93>
      np->ofile[i] = filedup(proc->ofile[i]);
80103ca0:	89 04 24             	mov    %eax,(%esp)
80103ca3:	e8 78 d1 ff ff       	call   80100e20 <filedup>
80103ca8:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103cac:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  allocate_new_pgdir_idx(np);

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103cb3:	83 c6 01             	add    $0x1,%esi
80103cb6:	83 fe 10             	cmp    $0x10,%esi
80103cb9:	75 dd                	jne    80103c98 <fork+0x78>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103cbb:	8b 42 68             	mov    0x68(%edx),%eax
80103cbe:	89 04 24             	mov    %eax,(%esp)
80103cc1:	e8 0a da ff ff       	call   801016d0 <idup>
80103cc6:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103cc9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ccf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103cd6:	00 
80103cd7:	83 c0 6c             	add    $0x6c,%eax
80103cda:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cde:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ce1:	89 04 24             	mov    %eax,(%esp)
80103ce4:	e8 27 12 00 00       	call   80104f10 <safestrcpy>

  pid = np->pid;
80103ce9:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103cec:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103cf3:	e8 b8 0e 00 00       	call   80104bb0 <acquire>

  np->state = RUNNABLE;
80103cf8:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  //Design Document 1-1-2-5. A new process is generated.

  release(&ptable.lock);
80103cff:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103d06:	e8 d5 0f 00 00       	call   80104ce0 <release>

  return pid;
80103d0b:	89 f0                	mov    %esi,%eax
}
80103d0d:	83 c4 1c             	add    $0x1c,%esp
80103d10:	5b                   	pop    %ebx
80103d11:	5e                   	pop    %esi
80103d12:	5f                   	pop    %edi
80103d13:	5d                   	pop    %ebp
80103d14:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103d15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d1a:	eb f1                	jmp    80103d0d <fork+0xed>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103d1c:	8b 43 08             	mov    0x8(%ebx),%eax
80103d1f:	89 04 24             	mov    %eax,(%esp)
80103d22:	e8 09 e6 ff ff       	call   80102330 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103d27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103d2c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103d33:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d3a:	eb d1                	jmp    80103d0d <fork+0xed>
80103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d40 <find_idx_of_stride_to_run>:

}

int
find_idx_of_stride_to_run(void) 
{
80103d40:	a1 74 66 11 80       	mov    0x80116674,%eax
80103d45:	55                   	push   %ebp
80103d46:	89 e5                	mov    %esp,%ebp
80103d48:	57                   	push   %edi
80103d49:	56                   	push   %esi
80103d4a:	53                   	push   %ebx
  struct proc* proc_to_be_run;
  int i;
  
  // From the start to the end of stride queue
  int stride_find_idx = 1;
80103d4b:	bb 01 00 00 00       	mov    $0x1,%ebx
          break;

        case NO_CHILD:
          // NO_CHILD
          // End the loop. Make index bigger than stride_queue_size
          stride_find_idx = ptable.stride_queue_size + 1;
80103d50:	8d 70 01             	lea    0x1(%eax),%esi
  struct proc* proc_to_be_run;
  int i;
  
  // From the start to the end of stride queue
  int stride_find_idx = 1;
  while(stride_find_idx <= ptable.stride_queue_size){
80103d53:	39 c3                	cmp    %eax,%ebx
80103d55:	7f 1f                	jg     80103d76 <find_idx_of_stride_to_run+0x36>
    if(ptable.stride_queue[stride_find_idx]->state == RUNNABLE){
80103d57:	8b 14 9d 6c 65 11 80 	mov    -0x7fee9a94(,%ebx,4),%edx
80103d5e:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103d62:	74 6c                	je     80103dd0 <find_idx_of_stride_to_run+0x90>
      // End finding. Go to run selected process.
      break;
    }else{
      // Not found
      // select between children whose stirde_value is smaller
      int left_child = stride_find_idx * 2;
80103d64:	01 db                	add    %ebx,%ebx
      int right_child = stride_find_idx * 2 + 1;
80103d66:	8d 53 01             	lea    0x1(%ebx),%edx
      enum {NO_CHILD, LEFT_ONLY, BOTH} child_status;

      if(right_child <= ptable.stride_queue_size){
80103d69:	39 c2                	cmp    %eax,%edx
80103d6b:	7e 43                	jle    80103db0 <find_idx_of_stride_to_run+0x70>
          break;

        case NO_CHILD:
          // NO_CHILD
          // End the loop. Make index bigger than stride_queue_size
          stride_find_idx = ptable.stride_queue_size + 1;
80103d6d:	39 c3                	cmp    %eax,%ebx
80103d6f:	0f 4f de             	cmovg  %esi,%ebx
  struct proc* proc_to_be_run;
  int i;
  
  // From the start to the end of stride queue
  int stride_find_idx = 1;
  while(stride_find_idx <= ptable.stride_queue_size){
80103d72:	39 c3                	cmp    %eax,%ebx
80103d74:	7e e1                	jle    80103d57 <find_idx_of_stride_to_run+0x17>
    }
  }

  // A process is not found. Find any runnable process in stride queue.
  if(stride_find_idx >= ptable.stride_queue_size + 1){
    for(i = 1; i <= ptable.stride_queue_size; ++i){
80103d76:	85 c0                	test   %eax,%eax
80103d78:	7e 2a                	jle    80103da4 <find_idx_of_stride_to_run+0x64>
      if(ptable.stride_queue[i]->state == RUNNABLE){
80103d7a:	8b 15 70 65 11 80    	mov    0x80116570,%edx
80103d80:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103d84:	74 6e                	je     80103df4 <find_idx_of_stride_to_run+0xb4>
80103d86:	ba 01 00 00 00       	mov    $0x1,%edx
80103d8b:	eb 10                	jmp    80103d9d <find_idx_of_stride_to_run+0x5d>
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
80103d90:	8b 0c 95 6c 65 11 80 	mov    -0x7fee9a94(,%edx,4),%ecx
80103d97:	83 79 0c 03          	cmpl   $0x3,0xc(%ecx)
80103d9b:	74 53                	je     80103df0 <find_idx_of_stride_to_run+0xb0>
    }
  }

  // A process is not found. Find any runnable process in stride queue.
  if(stride_find_idx >= ptable.stride_queue_size + 1){
    for(i = 1; i <= ptable.stride_queue_size; ++i){
80103d9d:	83 c2 01             	add    $0x1,%edx
80103da0:	39 c2                	cmp    %eax,%edx
80103da2:	7e ec                	jle    80103d90 <find_idx_of_stride_to_run+0x50>
  }

  // return value is larger than size when no process is runnable in stride.
  // exception handling code is in scheduler()
  return stride_find_idx;
}
80103da4:	89 d8                	mov    %ebx,%eax
80103da6:	5b                   	pop    %ebx
80103da7:	5e                   	pop    %esi
80103da8:	5f                   	pop    %edi
80103da9:	5d                   	pop    %ebp
80103daa:	c3                   	ret    
80103dab:	90                   	nop
80103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      // Check children's existence.
      switch(child_status){
        case BOTH:
          // Left and right children is exist.
          if(ptable.stride_queue[left_child]->stride_count
              < ptable.stride_queue[right_child]->stride_count){
80103db0:	8b 0c 9d 70 65 11 80 	mov    -0x7fee9a90(,%ebx,4),%ecx
80103db7:	8b 3c 9d 6c 65 11 80 	mov    -0x7fee9a94(,%ebx,4),%edi
80103dbe:	8b 89 90 00 00 00    	mov    0x90(%ecx),%ecx
80103dc4:	39 8f 90 00 00 00    	cmp    %ecx,0x90(%edi)
80103dca:	0f 4d da             	cmovge %edx,%ebx
80103dcd:	eb 84                	jmp    80103d53 <find_idx_of_stride_to_run+0x13>
80103dcf:	90                   	nop
  while(stride_find_idx <= ptable.stride_queue_size){
    if(ptable.stride_queue[stride_find_idx]->state == RUNNABLE){
      // Found
      // Increase stride count of current process and heapify.
      proc_to_be_run = ptable.stride_queue[stride_find_idx];
      proc_to_be_run->stride_count += proc_to_be_run->stride;
80103dd0:	8b 82 8c 00 00 00    	mov    0x8c(%edx),%eax
80103dd6:	01 82 90 00 00 00    	add    %eax,0x90(%edx)
      stride_queue_heapify_down(stride_find_idx);
80103ddc:	89 d8                	mov    %ebx,%eax
80103dde:	e8 9d f8 ff ff       	call   80103680 <stride_queue_heapify_down>
      }
    }
  }

  // A process is not found. Find any runnable process in stride queue.
  if(stride_find_idx >= ptable.stride_queue_size + 1){
80103de3:	a1 74 66 11 80       	mov    0x80116674,%eax
80103de8:	39 d8                	cmp    %ebx,%eax
80103dea:	7d b8                	jge    80103da4 <find_idx_of_stride_to_run+0x64>
80103dec:	eb 88                	jmp    80103d76 <find_idx_of_stride_to_run+0x36>
80103dee:	66 90                	xchg   %ax,%ax
    for(i = 1; i <= ptable.stride_queue_size; ++i){
80103df0:	89 d3                	mov    %edx,%ebx
80103df2:	eb b0                	jmp    80103da4 <find_idx_of_stride_to_run+0x64>
      if(ptable.stride_queue[i]->state == RUNNABLE){
80103df4:	bb 01 00 00 00       	mov    $0x1,%ebx
80103df9:	eb a9                	jmp    80103da4 <find_idx_of_stride_to_run+0x64>
80103dfb:	90                   	nop
80103dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e00 <select_stride_or_MLFQ>:
int
select_stride_or_MLFQ()
{
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80103e00:	69 0d 08 b0 10 80 0d 	imul   $0x19660d,0x8010b008,%ecx
80103e07:	66 19 00 
  queue_selector = randstate % 100;
80103e0a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  return stride_find_idx;
}

int
select_stride_or_MLFQ()
{
80103e0f:	55                   	push   %ebp
80103e10:	89 e5                	mov    %esp,%ebp
    return 1;
  }else{
    // MLFQ is selected
    return 0;;
  }
}
80103e12:	5d                   	pop    %ebp
int
select_stride_or_MLFQ()
{
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80103e13:	81 c1 5f f3 6e 3c    	add    $0x3c6ef35f,%ecx
  queue_selector = randstate % 100;
80103e19:	89 c8                	mov    %ecx,%eax
80103e1b:	f7 ea                	imul   %edx
80103e1d:	89 c8                	mov    %ecx,%eax
80103e1f:	c1 f8 1f             	sar    $0x1f,%eax
int
select_stride_or_MLFQ()
{
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80103e22:	89 0d 08 b0 10 80    	mov    %ecx,0x8010b008
  queue_selector = randstate % 100;
80103e28:	c1 fa 05             	sar    $0x5,%edx
80103e2b:	29 c2                	sub    %eax,%edx

  if(queue_selector < ptable.sum_cpu_share){
80103e2d:	31 c0                	xor    %eax,%eax
select_stride_or_MLFQ()
{
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
  queue_selector = randstate % 100;
80103e2f:	6b d2 64             	imul   $0x64,%edx,%edx
80103e32:	29 d1                	sub    %edx,%ecx

  if(queue_selector < ptable.sum_cpu_share){
80103e34:	3b 0d 70 66 11 80    	cmp    0x80116670,%ecx
80103e3a:	0f 9c c0             	setl   %al
    return 1;
  }else{
    // MLFQ is selected
    return 0;;
  }
}
80103e3d:	c3                   	ret    
80103e3e:	66 90                	xchg   %ax,%ax

80103e40 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
  struct proc *p;
  
  // Design Document 1-2-2-5
  int choosing_stride_or_MLFQ;
  int stride_is_selected = 0;
80103e45:	31 f6                	xor    %esi,%esi
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103e47:	53                   	push   %ebx
80103e48:	83 ec 1c             	sub    $0x1c,%esp
}

static inline void
sti(void)
{
  asm volatile("sti");
80103e4b:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103e4c:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103e53:	e8 58 0d 00 00       	call   80104bb0 <acquire>

    // choose the stride queue or MLFQ
    choosing_stride_or_MLFQ = 1;
80103e58:	b8 01 00 00 00       	mov    $0x1,%eax

    // When while loop is end, there are only processes of last level of queue.
    ptable.queue_level_at_most = NMLFQ - 1; // last level
80103e5d:	c7 05 64 65 11 80 02 	movl   $0x2,0x80116564
80103e64:	00 00 00 
    while(ptable.queue_level_at_most < NMLFQ){

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;
80103e67:	c7 05 68 65 11 80 02 	movl   $0x2,0x80116568
80103e6e:	00 00 00 

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e71:	bb 54 3e 11 80       	mov    $0x80113e54,%ebx
80103e76:	66 90                	xchg   %ax,%ax
        // Design Document 1-2-2-5. Choosing the stride queue or MLFQ
        if(ptable.sum_cpu_share == 0){
80103e78:	8b 0d 70 66 11 80    	mov    0x80116670,%ecx
80103e7e:	85 c9                	test   %ecx,%ecx
80103e80:	0f 84 52 01 00 00    	je     80103fd8 <scheduler+0x198>
          // No process is in stride. Run only processes in MLFQ.
          stride_is_selected = 0;
          choosing_stride_or_MLFQ = 0;
        }else if(choosing_stride_or_MLFQ){
80103e86:	85 c0                	test   %eax,%eax
80103e88:	0f 84 42 01 00 00    	je     80103fd0 <scheduler+0x190>
int
select_stride_or_MLFQ()
{
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80103e8e:	69 35 08 b0 10 80 0d 	imul   $0x19660d,0x8010b008,%esi
80103e95:	66 19 00 
  queue_selector = randstate % 100;
80103e98:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
int
select_stride_or_MLFQ()
{
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80103e9d:	81 c6 5f f3 6e 3c    	add    $0x3c6ef35f,%esi
  queue_selector = randstate % 100;
80103ea3:	f7 ee                	imul   %esi
80103ea5:	89 f0                	mov    %esi,%eax
80103ea7:	c1 f8 1f             	sar    $0x1f,%eax
int
select_stride_or_MLFQ()
{
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80103eaa:	89 35 08 b0 10 80    	mov    %esi,0x8010b008
  queue_selector = randstate % 100;
80103eb0:	c1 fa 05             	sar    $0x5,%edx
80103eb3:	29 c2                	sub    %eax,%edx
80103eb5:	6b d2 64             	imul   $0x64,%edx,%edx
80103eb8:	29 d6                	sub    %edx,%esi

  if(queue_selector < ptable.sum_cpu_share){
80103eba:	39 f1                	cmp    %esi,%ecx
80103ebc:	0f 8e 16 01 00 00    	jle    80103fd8 <scheduler+0x198>
    // The stride queue is selected.
    return 1;
80103ec2:	be 01 00 00 00       	mov    $0x1,%esi
        if(stride_is_selected){
          // The stride queue is selceted.
          
          int stride_idx_to_be_run;
          // Find a process whose state is RUNNABLE in the stride queue
          stride_idx_to_be_run = find_idx_of_stride_to_run();
80103ec7:	e8 74 fe ff ff       	call   80103d40 <find_idx_of_stride_to_run>

          // Check whether process is found or not.
          if(stride_idx_to_be_run <= ptable.stride_queue_size){
80103ecc:	3b 05 74 66 11 80    	cmp    0x80116674,%eax
80103ed2:	0f 8f 70 01 00 00    	jg     80104048 <scheduler+0x208>
            // Process is found. Go to run found process
            p = ptable.stride_queue[stride_idx_to_be_run];
80103ed8:	8b 1c 85 6c 65 11 80 	mov    -0x7fee9a94(,%eax,4),%ebx
        /** cprintf("ContChange. stride_is_selected:%d, proc_name:%s, proc_id:%d, MLFQ_tick:%d, level:%d, stride_tick:%d, cpu_share:%d, sum_cpu_share: %d, stride:%d, stride_count:%d\n", stride_is_selected, p->name, p->pid, ptable.MLFQ_tick_used,p->level_of_MLFQ , ptable.stride_tick_used, p->cpu_share, ptable.sum_cpu_share, p->stride, p->stride_count); */
#endif
#ifdef THREAD_DEBUGGING
        {
          int i;
          cprintf("** pgdir_ref status **\n");
80103edf:	c7 04 24 38 7e 10 80 	movl   $0x80107e38,(%esp)
          for (i = 0; i < NPROC; ++i) {
80103ee6:	31 ff                	xor    %edi,%edi
        /** cprintf("ContChange. stride_is_selected:%d, proc_name:%s, proc_id:%d, MLFQ_tick:%d, level:%d, stride_tick:%d, cpu_share:%d, sum_cpu_share: %d, stride:%d, stride_count:%d\n", stride_is_selected, p->name, p->pid, ptable.MLFQ_tick_used,p->level_of_MLFQ , ptable.stride_tick_used, p->cpu_share, ptable.sum_cpu_share, p->stride, p->stride_count); */
#endif
#ifdef THREAD_DEBUGGING
        {
          int i;
          cprintf("** pgdir_ref status **\n");
80103ee8:	e8 63 c7 ff ff       	call   80100650 <cprintf>
80103eed:	eb 09                	jmp    80103ef8 <scheduler+0xb8>
80103eef:	90                   	nop
          for (i = 0; i < NPROC; ++i) {
80103ef0:	83 c7 01             	add    $0x1,%edi
80103ef3:	83 ff 40             	cmp    $0x40,%edi
80103ef6:	74 31                	je     80103f29 <scheduler+0xe9>
            if (pgdir_ref[i] != 0) {
80103ef8:	0f be 87 e0 3d 11 80 	movsbl -0x7feec220(%edi),%eax
80103eff:	84 c0                	test   %al,%al
80103f01:	74 ed                	je     80103ef0 <scheduler+0xb0>
              cprintf("pgdir_ref[%d]: %d, pgdir_ref_next_idx:%d\n", i, pgdir_ref[i], pgdir_ref_next_idx);
80103f03:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80103f09:	89 7c 24 04          	mov    %edi,0x4(%esp)
#endif
#ifdef THREAD_DEBUGGING
        {
          int i;
          cprintf("** pgdir_ref status **\n");
          for (i = 0; i < NPROC; ++i) {
80103f0d:	83 c7 01             	add    $0x1,%edi
            if (pgdir_ref[i] != 0) {
              cprintf("pgdir_ref[%d]: %d, pgdir_ref_next_idx:%d\n", i, pgdir_ref[i], pgdir_ref_next_idx);
80103f10:	89 44 24 08          	mov    %eax,0x8(%esp)
80103f14:	c7 04 24 08 7f 10 80 	movl   $0x80107f08,(%esp)
80103f1b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80103f1f:	e8 2c c7 ff ff       	call   80100650 <cprintf>
#endif
#ifdef THREAD_DEBUGGING
        {
          int i;
          cprintf("** pgdir_ref status **\n");
          for (i = 0; i < NPROC; ++i) {
80103f24:	83 ff 40             	cmp    $0x40,%edi
80103f27:	75 cf                	jne    80103ef8 <scheduler+0xb8>
          }
        }
        
#endif
        proc = p;
        switchuvm(p);
80103f29:	89 1c 24             	mov    %ebx,(%esp)
            }
          }
        }
        
#endif
        proc = p;
80103f2c:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
        switchuvm(p);
80103f33:	e8 18 33 00 00       	call   80107250 <switchuvm>

        // Back up MLFQ tick for check whether a process in MLFQ uses at least one tick.
        // I did not use 'if', so in this code is executed in stride algorithm, but it does not make problem.
        before_MLFQ_used_tick = ptable.MLFQ_tick_used;

        swtch(&cpu->scheduler, p->context); // This function returns in sched().
80103f38:	8b 43 1c             	mov    0x1c(%ebx),%eax
        }
        
#endif
        proc = p;
        switchuvm(p);
        p->state = RUNNING;
80103f3b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)

        // Back up MLFQ tick for check whether a process in MLFQ uses at least one tick.
        // I did not use 'if', so in this code is executed in stride algorithm, but it does not make problem.
        before_MLFQ_used_tick = ptable.MLFQ_tick_used;
80103f42:	8b 3d 60 65 11 80    	mov    0x80116560,%edi

        swtch(&cpu->scheduler, p->context); // This function returns in sched().
80103f48:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f4c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103f52:	83 c0 04             	add    $0x4,%eax
80103f55:	89 04 24             	mov    %eax,(%esp)
80103f58:	e8 0e 10 00 00       	call   80104f6b <swtch>
        switchkvm();
80103f5d:	e8 ce 32 00 00       	call   80107230 <switchkvm>
        // Check MLFQ_tick_used only in follow conditions are satisfied:
        // 1) Current queue is MLFQ                     (stride_is_selected == 0)
        // 2) Current process is runnable               (p->state == RUNNING)
        // 3) Any processes are in the stride queue     (ptable.sum_cpu_share != 0)
        // 4) The process running now is in MLFQ        (p->cpu_share == 0)
        if(stride_is_selected == 0
80103f62:	85 f6                	test   %esi,%esi
80103f64:	0f 85 e4 00 00 00    	jne    8010404e <scheduler+0x20e>
            && ptable.sum_cpu_share != 0 
80103f6a:	8b 0d 70 66 11 80    	mov    0x80116670,%ecx

          // 2) To re-run current process, decrease pointer's value. 
          //    It will be increased in 'for' statement, so current process will be re-selected.
          p--;
        }else{
          choosing_stride_or_MLFQ = 1;
80103f70:	b8 01 00 00 00       	mov    $0x1,%eax
        // 1) Current queue is MLFQ                     (stride_is_selected == 0)
        // 2) Current process is runnable               (p->state == RUNNING)
        // 3) Any processes are in the stride queue     (ptable.sum_cpu_share != 0)
        // 4) The process running now is in MLFQ        (p->cpu_share == 0)
        if(stride_is_selected == 0
            && ptable.sum_cpu_share != 0 
80103f75:	85 c9                	test   %ecx,%ecx
80103f77:	74 0a                	je     80103f83 <scheduler+0x143>
            && p->state == RUNNABLE 
80103f79:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f7d:	0f 84 ed 00 00 00    	je     80104070 <scheduler+0x230>
    while(ptable.queue_level_at_most < NMLFQ){

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f83:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103f89:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
          p--;
        }else{
          choosing_stride_or_MLFQ = 1;
        }

        proc = 0;
80103f8f:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103f96:	00 00 00 00 
    while(ptable.queue_level_at_most < NMLFQ){

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9a:	0f 82 d8 fe ff ff    	jb     80103e78 <scheduler+0x38>
          p = p_mlfq;
          p--;
        }
      }

      if(ptable.min_of_run_proc_level == NMLFQ - 1)  {
80103fa0:	83 3d 68 65 11 80 02 	cmpl   $0x2,0x80116568
80103fa7:	8b 15 64 65 11 80    	mov    0x80116564,%edx
80103fad:	74 54                	je     80104003 <scheduler+0x1c3>
    // choose the stride queue or MLFQ
    choosing_stride_or_MLFQ = 1;

    // When while loop is end, there are only processes of last level of queue.
    ptable.queue_level_at_most = NMLFQ - 1; // last level
    while(ptable.queue_level_at_most < NMLFQ){
80103faf:	83 fa 02             	cmp    $0x2,%edx
80103fb2:	0f 8e af fe ff ff    	jle    80103e67 <scheduler+0x27>
        ptable.queue_level_at_most++;
      }else{
        // run a queue of same level again.
      }
    }
    release(&ptable.lock);
80103fb8:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80103fbf:	e8 1c 0d 00 00       	call   80104ce0 <release>
  }
80103fc4:	e9 82 fe ff ff       	jmp    80103e4b <scheduler+0xb>
80103fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          // choosing_stride_or_MLFQ == 0
          // do nothing. keep finding a process in MLFQ
        }

        // Design document 1-1-2-5. Finding a process to be run
        if(stride_is_selected){
80103fd0:	85 f6                	test   %esi,%esi
80103fd2:	0f 85 ef fe ff ff    	jne    80103ec7 <scheduler+0x87>
80103fd8:	31 f6                	xor    %esi,%esi
            ptable.queue_level_at_most = p->level_of_MLFQ < ptable.queue_level_at_most ? p->level_of_MLFQ : ptable.queue_level_at_most;
            ptable.min_of_run_proc_level = ptable.queue_level_at_most;

          }else{
            // A process to be run has not been found. Keep finding it in MLFQ.
            choosing_stride_or_MLFQ = 0;
80103fda:	31 c0                	xor    %eax,%eax
          // The MLFQ is selected. Find a process in MLFQ.
          // A process can be run whose priority is equal or higher than ptable.queue_level_at_most.
          
          // Skip a process whose value of cpu_share is not zero, 
          //  which means that the process is in the stride_queue, not in the MLFQ.
          if(p->state == RUNNABLE 
80103fdc:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103fe0:	74 36                	je     80104018 <scheduler+0x1d8>
    while(ptable.queue_level_at_most < NMLFQ){

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe2:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103fe8:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80103fee:	0f 82 84 fe ff ff    	jb     80103e78 <scheduler+0x38>
          p = p_mlfq;
          p--;
        }
      }

      if(ptable.min_of_run_proc_level == NMLFQ - 1)  {
80103ff4:	83 3d 68 65 11 80 02 	cmpl   $0x2,0x80116568
80103ffb:	8b 15 64 65 11 80    	mov    0x80116564,%edx
80104001:	75 ac                	jne    80103faf <scheduler+0x16f>
        // 1) no process run. Increase queue level.
        // 2) processes are only in queue of last level. Break the while loop
        ptable.queue_level_at_most++;
80104003:	8b 0d 64 65 11 80    	mov    0x80116564,%ecx
80104009:	8d 51 01             	lea    0x1(%ecx),%edx
8010400c:	89 15 64 65 11 80    	mov    %edx,0x80116564
80104012:	eb 9b                	jmp    80103faf <scheduler+0x16f>
80104014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          // A process can be run whose priority is equal or higher than ptable.queue_level_at_most.
          
          // Skip a process whose value of cpu_share is not zero, 
          //  which means that the process is in the stride_queue, not in the MLFQ.
          if(p->state == RUNNABLE 
              && p->cpu_share == 0 
80104018:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
8010401e:	85 ff                	test   %edi,%edi
80104020:	75 c0                	jne    80103fe2 <scheduler+0x1a2>
              && p->level_of_MLFQ <= ptable.queue_level_at_most){
80104022:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80104028:	8b 0d 64 65 11 80    	mov    0x80116564,%ecx
8010402e:	39 ca                	cmp    %ecx,%edx
80104030:	7f 37                	jg     80104069 <scheduler+0x229>
            // A process to be run has been found!
            // Minimum level of run processes should be ptable.queue_level_at_most for next scheduling.
            ptable.queue_level_at_most = p->level_of_MLFQ < ptable.queue_level_at_most ? p->level_of_MLFQ : ptable.queue_level_at_most;
80104032:	39 d1                	cmp    %edx,%ecx
80104034:	0f 4e d1             	cmovle %ecx,%edx
80104037:	89 15 64 65 11 80    	mov    %edx,0x80116564
            ptable.min_of_run_proc_level = ptable.queue_level_at_most;
8010403d:	89 15 68 65 11 80    	mov    %edx,0x80116568
80104043:	e9 97 fe ff ff       	jmp    80103edf <scheduler+0x9f>
          if(stride_idx_to_be_run <= ptable.stride_queue_size){
            // Process is found. Go to run found process
            p = ptable.stride_queue[stride_idx_to_be_run];
          }else{
            // No process to be run in stride_queue. go to MLFQ
            stride_is_selected = 0;
80104048:	31 f6                	xor    %esi,%esi
            choosing_stride_or_MLFQ = 0;
8010404a:	31 c0                	xor    %eax,%eax
8010404c:	eb 94                	jmp    80103fe2 <scheduler+0x1a2>
          p--;
        }else{
          choosing_stride_or_MLFQ = 1;
        }

        proc = 0;
8010404e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104055:	00 00 00 00 

        if(stride_is_selected){
          // To remove the side effect of stride algorithm, restore the process pointer and decrase it.
          // It will be increased in 'for' statement, so the status of MLFQ is same.
          p = p_mlfq;
          p--;
80104059:	81 eb 9c 00 00 00    	sub    $0x9c,%ebx

          // 2) To re-run current process, decrease pointer's value. 
          //    It will be increased in 'for' statement, so current process will be re-selected.
          p--;
        }else{
          choosing_stride_or_MLFQ = 1;
8010405f:	b8 01 00 00 00       	mov    $0x1,%eax
80104064:	e9 79 ff ff ff       	jmp    80103fe2 <scheduler+0x1a2>
80104069:	89 c6                	mov    %eax,%esi
8010406b:	e9 72 ff ff ff       	jmp    80103fe2 <scheduler+0x1a2>
        // 3) Any processes are in the stride queue     (ptable.sum_cpu_share != 0)
        // 4) The process running now is in MLFQ        (p->cpu_share == 0)
        if(stride_is_selected == 0
            && ptable.sum_cpu_share != 0 
            && p->state == RUNNABLE 
            && p->cpu_share == 0 
80104070:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
80104076:	85 d2                	test   %edx,%edx
80104078:	0f 85 05 ff ff ff    	jne    80103f83 <scheduler+0x143>
            && ptable.MLFQ_tick_used == before_MLFQ_used_tick)
8010407e:	39 3d 60 65 11 80    	cmp    %edi,0x80116560
80104084:	0f 85 f9 fe ff ff    	jne    80103f83 <scheduler+0x143>
          // 1) Do not consider choosing between the MLFQ of the stride.
          choosing_stride_or_MLFQ = 0;

          // 2) To re-run current process, decrease pointer's value. 
          //    It will be increased in 'for' statement, so current process will be re-selected.
          p--;
8010408a:	81 eb 9c 00 00 00    	sub    $0x9c,%ebx
          // When these conditions are satisfied, 
          // it means that current process are in MLFQ and it does not use at least one tick.
          
          // To make the process use one tick, re-run current process:
          // 1) Do not consider choosing between the MLFQ of the stride.
          choosing_stride_or_MLFQ = 0;
80104090:	30 c0                	xor    %al,%al

          // 2) To re-run current process, decrease pointer's value. 
          //    It will be increased in 'for' statement, so current process will be re-selected.
          p--;
80104092:	e9 ec fe ff ff       	jmp    80103f83 <scheduler+0x143>
80104097:	89 f6                	mov    %esi,%esi
80104099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040a0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
801040a7:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
801040ae:	e8 8d 0b 00 00       	call   80104c40 <holding>
801040b3:	85 c0                	test   %eax,%eax
801040b5:	74 61                	je     80104118 <sched+0x78>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
801040b7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801040bd:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
801040c4:	75 76                	jne    8010413c <sched+0x9c>
    panic("sched locks");
  if(proc->state == RUNNING)
801040c6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801040cd:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
801040d1:	74 5d                	je     80104130 <sched+0x90>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040d3:	9c                   	pushf  
801040d4:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
801040d5:	80 e5 02             	and    $0x2,%ch
801040d8:	75 4a                	jne    80104124 <sched+0x84>
    panic("sched interruptible");

  intena = cpu->intena;
801040da:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler); // sched는 한 타임에 return되는게 아니다. 자고 있다가, 깨워지면 다시 시작한다.
801040e0:	83 c2 1c             	add    $0x1c,%edx
801040e3:	8b 40 04             	mov    0x4(%eax),%eax
801040e6:	89 14 24             	mov    %edx,(%esp)
801040e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801040ed:	e8 79 0e 00 00       	call   80104f6b <swtch>
  // swtch가 return되는 곳은 scheduler안에서다. scheduler 진행
  
  // 이거맞나? TODO 
  if(proc){
801040f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801040f8:	85 c0                	test   %eax,%eax
801040fa:	74 0a                	je     80104106 <sched+0x66>
    proc->time_quantum_used = 0;
801040fc:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104103:	00 00 00 
  }

  cpu->intena = intena;
80104106:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010410c:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80104112:	83 c4 14             	add    $0x14,%esp
80104115:	5b                   	pop    %ebx
80104116:	5d                   	pop    %ebp
80104117:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80104118:	c7 04 24 50 7e 10 80 	movl   $0x80107e50,(%esp)
8010411f:	e8 3c c2 ff ff       	call   80100360 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80104124:	c7 04 24 7c 7e 10 80 	movl   $0x80107e7c,(%esp)
8010412b:	e8 30 c2 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80104130:	c7 04 24 6e 7e 10 80 	movl   $0x80107e6e,(%esp)
80104137:	e8 24 c2 ff ff       	call   80100360 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
8010413c:	c7 04 24 62 7e 10 80 	movl   $0x80107e62,(%esp)
80104143:	e8 18 c2 ff ff       	call   80100360 <panic>
80104148:	90                   	nop
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104150 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	57                   	push   %edi
80104154:	56                   	push   %esi
80104155:	53                   	push   %ebx
  struct proc *p;
  int fd;
  int stride_idx;

  if(proc == initproc)
80104156:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104158:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  int fd;
  int stride_idx;

  if(proc == initproc)
8010415b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104162:	3b 15 c0 b5 10 80    	cmp    0x8010b5c0,%edx
80104168:	0f 84 0f 02 00 00    	je     8010437d <exit+0x22d>
8010416e:	66 90                	xchg   %ax,%ax
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80104170:	8d 73 08             	lea    0x8(%ebx),%esi
80104173:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80104177:	85 c0                	test   %eax,%eax
80104179:	74 17                	je     80104192 <exit+0x42>
      fileclose(proc->ofile[fd]);
8010417b:	89 04 24             	mov    %eax,(%esp)
8010417e:	e8 ed cc ff ff       	call   80100e70 <fileclose>
      proc->ofile[fd] = 0;
80104183:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010418a:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80104191:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104192:	83 c3 01             	add    $0x1,%ebx
80104195:	83 fb 10             	cmp    $0x10,%ebx
80104198:	75 d6                	jne    80104170 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
8010419a:	e8 31 ea ff ff       	call   80102bd0 <begin_op>
  iput(proc->cwd);
8010419f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041a5:	8b 40 68             	mov    0x68(%eax),%eax
801041a8:	89 04 24             	mov    %eax,(%esp)
801041ab:	e8 60 d6 ff ff       	call   80101810 <iput>
  end_op();
801041b0:	e8 8b ea ff ff       	call   80102c40 <end_op>
  proc->cwd = 0;
801041b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801041bb:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801041c2:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
801041c9:	e8 e2 09 00 00       	call   80104bb0 <acquire>

  // delete a process in stride queue
  if(proc->cpu_share != 0){
801041ce:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801041d5:	8b 82 88 00 00 00    	mov    0x88(%edx),%eax
801041db:	85 c0                	test   %eax,%eax
801041dd:	0f 84 db 00 00 00    	je     801042be <exit+0x16e>
#ifdef MJ_DEBUGGING
    cprintf("stirde_queue process exit()\n");
#endif

    // subtract cpu_share from sum_cpu_share
    ptable.sum_cpu_share -= proc->cpu_share;
801041e3:	29 05 70 66 11 80    	sub    %eax,0x80116670

    // find where it is in the stride queue
    for(stride_idx = 1; stride_idx < NSTRIDE_QUEUE; ++stride_idx){
801041e9:	b8 01 00 00 00       	mov    $0x1,%eax
801041ee:	eb 0c                	jmp    801041fc <exit+0xac>
801041f0:	83 c0 01             	add    $0x1,%eax
801041f3:	83 f8 41             	cmp    $0x41,%eax
801041f6:	0f 84 64 01 00 00    	je     80104360 <exit+0x210>
      if(ptable.stride_queue[stride_idx] == proc){
801041fc:	3b 14 85 6c 65 11 80 	cmp    -0x7fee9a94(,%eax,4),%edx
80104203:	75 eb                	jne    801041f0 <exit+0xa0>
    if(stride_idx == NSTRIDE_QUEUE){
      panic("exit(): a process is not in the stride scheduler");
    }

    // delete a process from the heap
    ptable.stride_queue[stride_idx] = ptable.stride_queue[ptable.stride_queue_size];
80104205:	8b 1d 74 66 11 80    	mov    0x80116674,%ebx
8010420b:	8d b0 d0 09 00 00    	lea    0x9d0(%eax),%esi
    ptable.stride_queue[ptable.stride_queue_size--] = 0;

    // do heapify
    if(stride_idx == 1){
80104211:	83 f8 01             	cmp    $0x1,%eax
    if(stride_idx == NSTRIDE_QUEUE){
      panic("exit(): a process is not in the stride scheduler");
    }

    // delete a process from the heap
    ptable.stride_queue[stride_idx] = ptable.stride_queue[ptable.stride_queue_size];
80104214:	8d 8b d0 09 00 00    	lea    0x9d0(%ebx),%ecx
8010421a:	8b 3c 8d 2c 3e 11 80 	mov    -0x7feec1d4(,%ecx,4),%edi
80104221:	89 3c b5 2c 3e 11 80 	mov    %edi,-0x7feec1d4(,%esi,4)
    ptable.stride_queue[ptable.stride_queue_size--] = 0;
80104228:	8d 7b ff             	lea    -0x1(%ebx),%edi
8010422b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010422e:	89 3d 74 66 11 80    	mov    %edi,0x80116674
80104234:	c7 04 8d 2c 3e 11 80 	movl   $0x0,-0x7feec1d4(,%ecx,4)
8010423b:	00 00 00 00 

    // do heapify
    if(stride_idx == 1){
8010423f:	0f 84 44 01 00 00    	je     80104389 <exit+0x239>
      //heapify_down
      heapify_up = 0;
    }else{
      //select heapify_up or down
      heapify_up = ptable.stride_queue[stride_idx]->stride_count 
80104245:	8b 3c b5 2c 3e 11 80 	mov    -0x7feec1d4(,%esi,4),%edi
8010424c:	8b 8f 90 00 00 00    	mov    0x90(%edi),%ecx
80104252:	89 4d e0             	mov    %ecx,-0x20(%ebp)
                   < ptable.stride_queue[stride_idx / 2]->stride_count 
80104255:	89 c1                	mov    %eax,%ecx
80104257:	d1 f9                	sar    %ecx
80104259:	89 4d dc             	mov    %ecx,-0x24(%ebp)
8010425c:	8b 0c 8d 6c 65 11 80 	mov    -0x7fee9a94(,%ecx,4),%ecx
                   ? 1 : 0;
    }

    if(ptable.stride_queue_size == 0 || ptable.stride_queue_size == 1){
80104263:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
      //heapify_down
      heapify_up = 0;
    }else{
      //select heapify_up or down
      heapify_up = ptable.stride_queue[stride_idx]->stride_count 
                   < ptable.stride_queue[stride_idx / 2]->stride_count 
80104267:	8b 99 90 00 00 00    	mov    0x90(%ecx),%ebx
                   ? 1 : 0;
    }

    if(ptable.stride_queue_size == 0 || ptable.stride_queue_size == 1){
8010426d:	76 4f                	jbe    801042be <exit+0x16e>
      //do nothing
    }else{
      // increase key
      if(heapify_up){
8010426f:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
80104272:	0f 8c f4 00 00 00    	jl     8010436c <exit+0x21c>
stride_queue_heapify_up(int stride_idx) 
{
  struct proc* target_proc = ptable.stride_queue[stride_idx];
  while(stride_idx != 1){
    // if child is smaller than parent
    if(ptable.stride_queue[stride_idx] < ptable.stride_queue[stride_idx / 2]){
80104278:	39 cf                	cmp    %ecx,%edi
8010427a:	73 3b                	jae    801042b7 <exit+0x167>
8010427c:	89 c6                	mov    %eax,%esi
8010427e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104281:	eb 23                	jmp    801042a6 <exit+0x156>
80104283:	90                   	nop
80104284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104288:	89 c3                	mov    %eax,%ebx
8010428a:	d1 fb                	sar    %ebx
8010428c:	8b 0c 9d 6c 65 11 80 	mov    -0x7fee9a94(,%ebx,4),%ecx
80104293:	8d b0 d0 09 00 00    	lea    0x9d0(%eax),%esi
80104299:	39 0c b5 2c 3e 11 80 	cmp    %ecx,-0x7feec1d4(,%esi,4)
801042a0:	73 15                	jae    801042b7 <exit+0x167>
801042a2:	89 c6                	mov    %eax,%esi
801042a4:	89 d8                	mov    %ebx,%eax
}
void
stride_queue_heapify_up(int stride_idx) 
{
  struct proc* target_proc = ptable.stride_queue[stride_idx];
  while(stride_idx != 1){
801042a6:	83 f8 01             	cmp    $0x1,%eax
    // if child is smaller than parent
    if(ptable.stride_queue[stride_idx] < ptable.stride_queue[stride_idx / 2]){
      ptable.stride_queue[stride_idx] = ptable.stride_queue[stride_idx / 2];
801042a9:	89 0c b5 6c 65 11 80 	mov    %ecx,-0x7fee9a94(,%esi,4)
}
void
stride_queue_heapify_up(int stride_idx) 
{
  struct proc* target_proc = ptable.stride_queue[stride_idx];
  while(stride_idx != 1){
801042b0:	75 d6                	jne    80104288 <exit+0x138>
801042b2:	be d1 09 00 00       	mov    $0x9d1,%esi
    }else{
      break;
    }
  }
  // locate a process to right position
  ptable.stride_queue[stride_idx] = target_proc;
801042b7:	89 3c b5 2c 3e 11 80 	mov    %edi,-0x7feec1d4(,%esi,4)
      }
    }
  }

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801042be:	8b 4a 14             	mov    0x14(%edx),%ecx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042c1:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
801042c6:	eb 0c                	jmp    801042d4 <exit+0x184>
801042c8:	05 9c 00 00 00       	add    $0x9c,%eax
801042cd:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801042d2:	74 1e                	je     801042f2 <exit+0x1a2>
    if(p->state == SLEEPING && p->chan == chan)
801042d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042d8:	75 ee                	jne    801042c8 <exit+0x178>
801042da:	3b 48 20             	cmp    0x20(%eax),%ecx
801042dd:	75 e9                	jne    801042c8 <exit+0x178>
      p->state = RUNNABLE;
801042df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042e6:	05 9c 00 00 00       	add    $0x9c,%eax
801042eb:	3d 54 65 11 80       	cmp    $0x80116554,%eax
801042f0:	75 e2                	jne    801042d4 <exit+0x184>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
801042f2:	8b 1d c0 b5 10 80    	mov    0x8010b5c0,%ebx
801042f8:	b9 54 3e 11 80       	mov    $0x80113e54,%ecx
801042fd:	eb 0f                	jmp    8010430e <exit+0x1be>
801042ff:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104300:	81 c1 9c 00 00 00    	add    $0x9c,%ecx
80104306:	81 f9 54 65 11 80    	cmp    $0x80116554,%ecx
8010430c:	74 3a                	je     80104348 <exit+0x1f8>
    if(p->parent == proc){
8010430e:	3b 51 14             	cmp    0x14(%ecx),%edx
80104311:	75 ed                	jne    80104300 <exit+0x1b0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80104313:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80104317:	89 59 14             	mov    %ebx,0x14(%ecx)
      if(p->state == ZOMBIE)
8010431a:	75 e4                	jne    80104300 <exit+0x1b0>
8010431c:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
80104321:	eb 11                	jmp    80104334 <exit+0x1e4>
80104323:	90                   	nop
80104324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104328:	05 9c 00 00 00       	add    $0x9c,%eax
8010432d:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104332:	74 cc                	je     80104300 <exit+0x1b0>
    if(p->state == SLEEPING && p->chan == chan)
80104334:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104338:	75 ee                	jne    80104328 <exit+0x1d8>
8010433a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010433d:	75 e9                	jne    80104328 <exit+0x1d8>
      p->state = RUNNABLE;
8010433f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104346:	eb e0                	jmp    80104328 <exit+0x1d8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104348:	c7 42 0c 05 00 00 00 	movl   $0x5,0xc(%edx)
  sched();
8010434f:	e8 4c fd ff ff       	call   801040a0 <sched>
  panic("zombie exit");
80104354:	c7 04 24 9d 7e 10 80 	movl   $0x80107e9d,(%esp)
8010435b:	e8 00 c0 ff ff       	call   80100360 <panic>
        break;
      }
    }

    if(stride_idx == NSTRIDE_QUEUE){
      panic("exit(): a process is not in the stride scheduler");
80104360:	c7 04 24 34 7f 10 80 	movl   $0x80107f34,(%esp)
80104367:	e8 f4 bf ff ff       	call   80100360 <panic>
    if(ptable.stride_queue_size == 0 || ptable.stride_queue_size == 1){
      //do nothing
    }else{
      // increase key
      if(heapify_up){
        stride_queue_heapify_down(stride_idx);
8010436c:	e8 0f f3 ff ff       	call   80103680 <stride_queue_heapify_down>
80104371:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104378:	e9 41 ff ff ff       	jmp    801042be <exit+0x16e>
  struct proc *p;
  int fd;
  int stride_idx;

  if(proc == initproc)
    panic("init exiting");
8010437d:	c7 04 24 90 7e 10 80 	movl   $0x80107e90,(%esp)
80104384:	e8 d7 bf ff ff       	call   80100360 <panic>
      heapify_up = ptable.stride_queue[stride_idx]->stride_count 
                   < ptable.stride_queue[stride_idx / 2]->stride_count 
                   ? 1 : 0;
    }

    if(ptable.stride_queue_size == 0 || ptable.stride_queue_size == 1){
80104389:	83 ff 01             	cmp    $0x1,%edi
8010438c:	0f 86 2c ff ff ff    	jbe    801042be <exit+0x16e>
  }
}
void
stride_queue_heapify_up(int stride_idx) 
{
  struct proc* target_proc = ptable.stride_queue[stride_idx];
80104392:	8b 3d 70 65 11 80    	mov    0x80116570,%edi
80104398:	e9 1a ff ff ff       	jmp    801042b7 <exit+0x167>
8010439d:	8d 76 00             	lea    0x0(%esi),%esi

801043a0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801043a6:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
801043ad:	e8 fe 07 00 00       	call   80104bb0 <acquire>
  proc->state = RUNNABLE;
801043b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043b8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched(); 
801043bf:	e8 dc fc ff ff       	call   801040a0 <sched>
  release(&ptable.lock);
801043c4:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
801043cb:	e8 10 09 00 00       	call   80104ce0 <release>
}
801043d0:	c9                   	leave  
801043d1:	c3                   	ret    
801043d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <sys_yield>:
// Wrapper
int
sys_yield(void){
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	83 ec 08             	sub    $0x8,%esp
  yield();
801043e6:	e8 b5 ff ff ff       	call   801043a0 <yield>
  return 0;
}
801043eb:	31 c0                	xor    %eax,%eax
801043ed:	c9                   	leave  
801043ee:	c3                   	ret    
801043ef:	90                   	nop

801043f0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
801043f5:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
801043f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801043fe:	8b 75 08             	mov    0x8(%ebp),%esi
80104401:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80104404:	85 c0                	test   %eax,%eax
80104406:	0f 84 8b 00 00 00    	je     80104497 <sleep+0xa7>
    panic("sleep");

  if(lk == 0)
8010440c:	85 db                	test   %ebx,%ebx
8010440e:	74 7b                	je     8010448b <sleep+0x9b>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104410:	81 fb 20 3e 11 80    	cmp    $0x80113e20,%ebx
80104416:	74 50                	je     80104468 <sleep+0x78>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104418:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
8010441f:	e8 8c 07 00 00       	call   80104bb0 <acquire>
    release(lk);
80104424:	89 1c 24             	mov    %ebx,(%esp)
80104427:	e8 b4 08 00 00       	call   80104ce0 <release>
  }

  // Go to sleep.
  proc->chan = chan;
8010442c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104432:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80104435:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
8010443c:	e8 5f fc ff ff       	call   801040a0 <sched>

  // Tidy up.
  proc->chan = 0;
80104441:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104447:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
8010444e:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80104455:	e8 86 08 00 00       	call   80104ce0 <release>
    acquire(lk);
8010445a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
8010445d:	83 c4 10             	add    $0x10,%esp
80104460:	5b                   	pop    %ebx
80104461:	5e                   	pop    %esi
80104462:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80104463:	e9 48 07 00 00       	jmp    80104bb0 <acquire>
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80104468:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
8010446b:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104472:	e8 29 fc ff ff       	call   801040a0 <sched>

  // Tidy up.
  proc->chan = 0;
80104477:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010447d:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80104484:	83 c4 10             	add    $0x10,%esp
80104487:	5b                   	pop    %ebx
80104488:	5e                   	pop    %esi
80104489:	5d                   	pop    %ebp
8010448a:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
8010448b:	c7 04 24 af 7e 10 80 	movl   $0x80107eaf,(%esp)
80104492:	e8 c9 be ff ff       	call   80100360 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80104497:	c7 04 24 a9 7e 10 80 	movl   $0x80107ea9,(%esp)
8010449e:	e8 bd be ff ff       	call   80100360 <panic>
801044a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044b0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
801044b5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801044b8:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
801044bf:	e8 ec 06 00 00       	call   80104bb0 <acquire>
801044c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801044ca:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044cc:	bb 54 3e 11 80       	mov    $0x80113e54,%ebx
801044d1:	eb 13                	jmp    801044e6 <wait+0x36>
801044d3:	90                   	nop
801044d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044d8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801044de:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
801044e4:	74 22                	je     80104508 <wait+0x58>
      if(p->parent != proc)
801044e6:	39 43 14             	cmp    %eax,0x14(%ebx)
801044e9:	75 ed                	jne    801044d8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
801044eb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801044ef:	74 3c                	je     8010452d <wait+0x7d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044f1:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
801044f7:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044fc:	81 fb 54 65 11 80    	cmp    $0x80116554,%ebx
80104502:	75 e2                	jne    801044e6 <wait+0x36>
80104504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104508:	85 d2                	test   %edx,%edx
8010450a:	0f 84 bc 00 00 00    	je     801045cc <wait+0x11c>
80104510:	8b 50 24             	mov    0x24(%eax),%edx
80104513:	85 d2                	test   %edx,%edx
80104515:	0f 85 b1 00 00 00    	jne    801045cc <wait+0x11c>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
8010451b:	c7 44 24 04 20 3e 11 	movl   $0x80113e20,0x4(%esp)
80104522:	80 
80104523:	89 04 24             	mov    %eax,(%esp)
80104526:	e8 c5 fe ff ff       	call   801043f0 <sleep>
  }
8010452b:	eb 97                	jmp    801044c4 <wait+0x14>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
8010452d:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80104530:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104533:	89 04 24             	mov    %eax,(%esp)
80104536:	e8 f5 dd ff ff       	call   80102330 <kfree>
        p->kstack = 0;


        /** freevm(p->pgdir); */
        check_pgdir_counter_and_call_freevm(p);
8010453b:	89 1c 24             	mov    %ebx,(%esp)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
8010453e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)


        /** freevm(p->pgdir); */
        check_pgdir_counter_and_call_freevm(p);
80104545:	e8 96 f3 ff ff       	call   801038e0 <check_pgdir_counter_and_call_freevm>
        // Design Document 2-1-2-2
        p->tid = 0;
        p->pgdir_ref_idx = -1;

        p->state = UNUSED;
        release(&ptable.lock);
8010454a:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)

        /** freevm(p->pgdir); */
        check_pgdir_counter_and_call_freevm(p);


        p->pid = 0;
80104551:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104558:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010455f:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104563:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)

        // Design document 1-1-2-2 and 1-2-2-2.
        p->tick_used = 0;
8010456a:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        p->time_quantum_used= 0;
80104571:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104578:	00 00 00 
        p->level_of_MLFQ = 0;
8010457b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104582:	00 00 00 
        p->cpu_share = 0;
80104585:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
8010458c:	00 00 00 
        p->stride = 0;
8010458f:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80104596:	00 00 00 
        p->stride_count= 0;
80104599:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
801045a0:	00 00 00 

        // Design Document 2-1-2-2
        p->tid = 0;
801045a3:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801045aa:	00 00 00 
        p->pgdir_ref_idx = -1;
801045ad:	c7 83 98 00 00 00 ff 	movl   $0xffffffff,0x98(%ebx)
801045b4:	ff ff ff 

        p->state = UNUSED;
801045b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801045be:	e8 1d 07 00 00       	call   80104ce0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801045c3:	83 c4 10             	add    $0x10,%esp
        p->tid = 0;
        p->pgdir_ref_idx = -1;

        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
801045c6:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801045c8:	5b                   	pop    %ebx
801045c9:	5e                   	pop    %esi
801045ca:	5d                   	pop    %ebp
801045cb:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
801045cc:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
801045d3:	e8 08 07 00 00       	call   80104ce0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801045d8:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
801045db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801045e0:	5b                   	pop    %ebx
801045e1:	5e                   	pop    %esi
801045e2:	5d                   	pop    %ebp
801045e3:	c3                   	ret    
801045e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801045f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 14             	sub    $0x14,%esp
801045f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801045fa:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80104601:	e8 aa 05 00 00       	call   80104bb0 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104606:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
8010460b:	eb 0f                	jmp    8010461c <wakeup+0x2c>
8010460d:	8d 76 00             	lea    0x0(%esi),%esi
80104610:	05 9c 00 00 00       	add    $0x9c,%eax
80104615:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010461a:	74 24                	je     80104640 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
8010461c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104620:	75 ee                	jne    80104610 <wakeup+0x20>
80104622:	3b 58 20             	cmp    0x20(%eax),%ebx
80104625:	75 e9                	jne    80104610 <wakeup+0x20>
      p->state = RUNNABLE;
80104627:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010462e:	05 9c 00 00 00       	add    $0x9c,%eax
80104633:	3d 54 65 11 80       	cmp    $0x80116554,%eax
80104638:	75 e2                	jne    8010461c <wakeup+0x2c>
8010463a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104640:	c7 45 08 20 3e 11 80 	movl   $0x80113e20,0x8(%ebp)
}
80104647:	83 c4 14             	add    $0x14,%esp
8010464a:	5b                   	pop    %ebx
8010464b:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010464c:	e9 8f 06 00 00       	jmp    80104ce0 <release>
80104651:	eb 0d                	jmp    80104660 <kill>
80104653:	90                   	nop
80104654:	90                   	nop
80104655:	90                   	nop
80104656:	90                   	nop
80104657:	90                   	nop
80104658:	90                   	nop
80104659:	90                   	nop
8010465a:	90                   	nop
8010465b:	90                   	nop
8010465c:	90                   	nop
8010465d:	90                   	nop
8010465e:	90                   	nop
8010465f:	90                   	nop

80104660 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 14             	sub    $0x14,%esp
80104667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010466a:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
80104671:	e8 3a 05 00 00       	call   80104bb0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104676:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
8010467b:	eb 0f                	jmp    8010468c <kill+0x2c>
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
80104680:	05 9c 00 00 00       	add    $0x9c,%eax
80104685:	3d 54 65 11 80       	cmp    $0x80116554,%eax
8010468a:	74 3c                	je     801046c8 <kill+0x68>
    if(p->pid == pid){
8010468c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010468f:	75 ef                	jne    80104680 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104691:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104695:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010469c:	74 1a                	je     801046b8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010469e:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
801046a5:	e8 36 06 00 00       	call   80104ce0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801046aa:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
801046ad:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801046af:	5b                   	pop    %ebx
801046b0:	5d                   	pop    %ebp
801046b1:	c3                   	ret    
801046b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801046b8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046bf:	eb dd                	jmp    8010469e <kill+0x3e>
801046c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801046c8:	c7 04 24 20 3e 11 80 	movl   $0x80113e20,(%esp)
801046cf:	e8 0c 06 00 00       	call   80104ce0 <release>
  return -1;
}
801046d4:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
801046d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046dc:	5b                   	pop    %ebx
801046dd:	5d                   	pop    %ebp
801046de:	c3                   	ret    
801046df:	90                   	nop

801046e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	57                   	push   %edi
801046e4:	56                   	push   %esi
801046e5:	53                   	push   %ebx
801046e6:	bb c0 3e 11 80       	mov    $0x80113ec0,%ebx
801046eb:	83 ec 4c             	sub    $0x4c,%esp
801046ee:	8d 75 e8             	lea    -0x18(%ebp),%esi
801046f1:	eb 23                	jmp    80104716 <procdump+0x36>
801046f3:	90                   	nop
801046f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801046f8:	c7 04 24 e6 7d 10 80 	movl   $0x80107de6,(%esp)
801046ff:	e8 4c bf ff ff       	call   80100650 <cprintf>
80104704:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010470a:	81 fb c0 65 11 80    	cmp    $0x801165c0,%ebx
80104710:	0f 84 8a 00 00 00    	je     801047a0 <procdump+0xc0>
    if(p->state == UNUSED)
80104716:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104719:	85 c0                	test   %eax,%eax
8010471b:	74 e7                	je     80104704 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010471d:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104720:	ba c0 7e 10 80       	mov    $0x80107ec0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104725:	77 11                	ja     80104738 <procdump+0x58>
80104727:	8b 14 85 68 7f 10 80 	mov    -0x7fef8098(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010472e:	b8 c0 7e 10 80       	mov    $0x80107ec0,%eax
80104733:	85 d2                	test   %edx,%edx
80104735:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104738:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010473b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010473f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104743:	c7 04 24 c4 7e 10 80 	movl   $0x80107ec4,(%esp)
8010474a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010474e:	e8 fd be ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80104753:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104757:	75 9f                	jne    801046f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104759:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010475c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104760:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104763:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104766:	8b 40 0c             	mov    0xc(%eax),%eax
80104769:	83 c0 08             	add    $0x8,%eax
8010476c:	89 04 24             	mov    %eax,(%esp)
8010476f:	e8 dc 03 00 00       	call   80104b50 <getcallerpcs>
80104774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104778:	8b 17                	mov    (%edi),%edx
8010477a:	85 d2                	test   %edx,%edx
8010477c:	0f 84 76 ff ff ff    	je     801046f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104782:	89 54 24 04          	mov    %edx,0x4(%esp)
80104786:	83 c7 04             	add    $0x4,%edi
80104789:	c7 04 24 09 79 10 80 	movl   $0x80107909,(%esp)
80104790:	e8 bb be ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104795:	39 f7                	cmp    %esi,%edi
80104797:	75 df                	jne    80104778 <procdump+0x98>
80104799:	e9 5a ff ff ff       	jmp    801046f8 <procdump+0x18>
8010479e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801047a0:	83 c4 4c             	add    $0x4c,%esp
801047a3:	5b                   	pop    %ebx
801047a4:	5e                   	pop    %esi
801047a5:	5f                   	pop    %edi
801047a6:	5d                   	pop    %ebp
801047a7:	c3                   	ret    
801047a8:	90                   	nop
801047a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047b0 <priority_boost>:

// Design Document 1-1-2-5. priority_boost()
void
priority_boost(void){
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  
  cprintf("[do boosting!]\n");
801047b6:	c7 04 24 cd 7e 10 80 	movl   $0x80107ecd,(%esp)
801047bd:	e8 8e be ff ff       	call   80100650 <cprintf>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047c2:	b8 54 3e 11 80       	mov    $0x80113e54,%eax
801047c7:	90                   	nop
    p->level_of_MLFQ = 0;
801047c8:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801047cf:	00 00 00 
priority_boost(void){
  struct proc *p;
  
  cprintf("[do boosting!]\n");

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047d2:	05 9c 00 00 00       	add    $0x9c,%eax
    p->level_of_MLFQ = 0;
    p->tick_used = 0;
801047d7:	c7 40 e0 00 00 00 00 	movl   $0x0,-0x20(%eax)
    //
    // Design Docuemtn 1-1-2-2. Reinitializing time_quantum_used
    p->time_quantum_used = 0;
801047de:	c7 40 e4 00 00 00 00 	movl   $0x0,-0x1c(%eax)
priority_boost(void){
  struct proc *p;
  
  cprintf("[do boosting!]\n");

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047e5:	3d 54 65 11 80       	cmp    $0x80116554,%eax
    //
    // Design Docuemtn 1-1-2-2. Reinitializing time_quantum_used
    p->time_quantum_used = 0;


    ptable.MLFQ_tick_used = 0;
801047ea:	c7 05 60 65 11 80 00 	movl   $0x0,0x80116560
801047f1:	00 00 00 
priority_boost(void){
  struct proc *p;
  
  cprintf("[do boosting!]\n");

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047f4:	75 d2                	jne    801047c8 <priority_boost+0x18>
    p->time_quantum_used = 0;


    ptable.MLFQ_tick_used = 0;
  }
}
801047f6:	c9                   	leave  
801047f7:	c3                   	ret    
801047f8:	90                   	nop
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104800 <set_cpu_share>:

// Design Document 1-1-2-4
int
set_cpu_share(int required) 
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104806:	56                   	push   %esi
80104807:	53                   	push   %ebx
  const int MAX_CPU_SHARE = 80;
  int is_new;
  int idx;

  // function argument is not valid
  if( ! (MIN_CPU_SHARE <= required && required <= MAX_CPU_SHARE) ) 
80104808:	8d 41 ff             	lea    -0x1(%ecx),%eax
8010480b:	83 f8 4f             	cmp    $0x4f,%eax
8010480e:	0f 87 9c 00 00 00    	ja     801048b0 <set_cpu_share+0xb0>
    goto exception;
  
  // Check whether a process is already in the stride queue
  cpu_share_already_set = proc->cpu_share;
80104814:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
    is_new = 1;
  }else{
    is_new = 0;
  }

  desired_sum_cpu_share = ptable.sum_cpu_share - cpu_share_already_set + required;
8010481b:	89 c8                	mov    %ecx,%eax
  // function argument is not valid
  if( ! (MIN_CPU_SHARE <= required && required <= MAX_CPU_SHARE) ) 
    goto exception;
  
  // Check whether a process is already in the stride queue
  cpu_share_already_set = proc->cpu_share;
8010481d:	8b b3 88 00 00 00    	mov    0x88(%ebx),%esi
    is_new = 1;
  }else{
    is_new = 0;
  }

  desired_sum_cpu_share = ptable.sum_cpu_share - cpu_share_already_set + required;
80104823:	29 f0                	sub    %esi,%eax
80104825:	03 05 70 66 11 80    	add    0x80116670,%eax
  // If a required cpu share is too much, an exception occurs.
  if(desired_sum_cpu_share > MAX_CPU_SHARE )
8010482b:	83 f8 50             	cmp    $0x50,%eax
8010482e:	0f 8f 7c 00 00 00    	jg     801048b0 <set_cpu_share+0xb0>
    goto exception;

  // It is okay to set cpu_share
  ptable.sum_cpu_share = desired_sum_cpu_share;
80104834:	a3 70 66 11 80       	mov    %eax,0x80116670
  proc->cpu_share = required;
  proc->stride = NSTRIDE / required;
80104839:	b8 10 27 00 00       	mov    $0x2710,%eax
8010483e:	99                   	cltd   
8010483f:	f7 f9                	idiv   %ecx
  if(desired_sum_cpu_share > MAX_CPU_SHARE )
    goto exception;

  // It is okay to set cpu_share
  ptable.sum_cpu_share = desired_sum_cpu_share;
  proc->cpu_share = required;
80104841:	89 8b 88 00 00 00    	mov    %ecx,0x88(%ebx)
  proc->stride = NSTRIDE / required;
80104847:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
    ptable.stride_queue[idx] = proc;
  }else{
    // if a process is already in the stride queue,
    // do nothing.
  }
  return 0;
8010484d:	31 c0                	xor    %eax,%eax
  // It is okay to set cpu_share
  ptable.sum_cpu_share = desired_sum_cpu_share;
  proc->cpu_share = required;
  proc->stride = NSTRIDE / required;

  if(is_new){
8010484f:	85 f6                	test   %esi,%esi
80104851:	75 53                	jne    801048a6 <set_cpu_share+0xa6>
    // Priority Queue Push
    // We do not need to check whether the stride queue is full because process cannot be generated more than 64

    // new process's stride_count should be minimum of a stride_count in the queue for preventing schuelder from being monopolized.
    if(ptable.stride_queue[1]){
80104853:	a1 70 65 11 80       	mov    0x80116570,%eax
80104858:	85 c0                	test   %eax,%eax
8010485a:	74 0c                	je     80104868 <set_cpu_share+0x68>
      proc->stride_count = ptable.stride_queue[1]->stride_count;
8010485c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104862:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
80104868:	a1 74 66 11 80       	mov    0x80116674,%eax
8010486d:	8d 50 01             	lea    0x1(%eax),%edx
    while(idx != 1){
80104870:	83 fa 01             	cmp    $0x1,%edx
    if(ptable.stride_queue[1]){
      proc->stride_count = ptable.stride_queue[1]->stride_count;
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
80104873:	89 15 74 66 11 80    	mov    %edx,0x80116674
    while(idx != 1){
80104879:	75 07                	jne    80104882 <set_cpu_share+0x82>
8010487b:	eb 21                	jmp    8010489e <set_cpu_share+0x9e>
8010487d:	8d 76 00             	lea    0x0(%esi),%esi
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
      idx /= 2;
80104880:	89 c2                	mov    %eax,%edx
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
    while(idx != 1){
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
80104882:	89 d0                	mov    %edx,%eax
80104884:	c1 e8 1f             	shr    $0x1f,%eax
80104887:	01 d0                	add    %edx,%eax
80104889:	d1 f8                	sar    %eax
8010488b:	8b 0c 85 6c 65 11 80 	mov    -0x7fee9a94(,%eax,4),%ecx
      proc->stride_count = ptable.stride_queue[1]->stride_count;
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
    while(idx != 1){
80104892:	83 f8 01             	cmp    $0x1,%eax
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
80104895:	89 0c 95 6c 65 11 80 	mov    %ecx,-0x7fee9a94(,%edx,4)
      proc->stride_count = ptable.stride_queue[1]->stride_count;
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
    while(idx != 1){
8010489c:	75 e2                	jne    80104880 <set_cpu_share+0x80>
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
      idx /= 2;
    }
    ptable.stride_queue[idx] = proc;
8010489e:	89 1d 70 65 11 80    	mov    %ebx,0x80116570
  }else{
    // if a process is already in the stride queue,
    // do nothing.
  }
  return 0;
801048a4:	31 c0                	xor    %eax,%eax

exception:
  return -1;
}
801048a6:	5b                   	pop    %ebx
801048a7:	5e                   	pop    %esi
801048a8:	5d                   	pop    %ebp
801048a9:	c3                   	ret    
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    // do nothing.
  }
  return 0;

exception:
  return -1;
801048b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048b5:	eb ef                	jmp    801048a6 <set_cpu_share+0xa6>
801048b7:	89 f6                	mov    %esi,%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048c0 <sys_set_cpu_share>:
}

int
sys_set_cpu_share(void) 
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	83 ec 28             	sub    $0x28,%esp
  int required;
  //Decode argument using argint

  if(argint(0, &required) < 0){
801048c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801048cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048d4:	e8 27 07 00 00       	call   80105000 <argint>
801048d9:	85 c0                	test   %eax,%eax
801048db:	78 13                	js     801048f0 <sys_set_cpu_share+0x30>
    return -1;
  }

  return set_cpu_share(required);
801048dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e0:	89 04 24             	mov    %eax,(%esp)
801048e3:	e8 18 ff ff ff       	call   80104800 <set_cpu_share>
}
801048e8:	c9                   	leave  
801048e9:	c3                   	ret    
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int required;
  //Decode argument using argint

  if(argint(0, &required) < 0){
    return -1;
801048f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  return set_cpu_share(required);
}
801048f5:	c9                   	leave  
801048f6:	c3                   	ret    
801048f7:	89 f6                	mov    %esi,%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104900 <thread_create>:

int
thread_create(thread_t * thread, void * (*start_routine)(void *), void *arg)
{
80104900:	55                   	push   %ebp
  return 0;
}
80104901:	31 c0                	xor    %eax,%eax
  return set_cpu_share(required);
}

int
thread_create(thread_t * thread, void * (*start_routine)(void *), void *arg)
{
80104903:	89 e5                	mov    %esp,%ebp
  return 0;
}
80104905:	5d                   	pop    %ebp
80104906:	c3                   	ret    
80104907:	89 f6                	mov    %esi,%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104910 <sys_thread_create>:

int
sys_thread_create(void)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	83 ec 28             	sub    $0x28,%esp
  thread_t * thread;
  void * (*start_routine)(void *);
  void * arg;

  if(argptr(0, (char**)&thread, sizeof(thread)) < 0){
80104916:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104919:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80104920:	00 
80104921:	89 44 24 04          	mov    %eax,0x4(%esp)
80104925:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010492c:	e8 0f 07 00 00       	call   80105040 <argptr>
80104931:	85 c0                	test   %eax,%eax
80104933:	78 43                	js     80104978 <sys_thread_create+0x68>
    return -1;
  }
  if(argptr(1, (char**)&start_routine, sizeof(start_routine)) < 0){
80104935:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104938:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010493f:	00 
80104940:	89 44 24 04          	mov    %eax,0x4(%esp)
80104944:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010494b:	e8 f0 06 00 00       	call   80105040 <argptr>
80104950:	85 c0                	test   %eax,%eax
80104952:	78 24                	js     80104978 <sys_thread_create+0x68>
    return -1;
  }
  if(argptr(2, (char**)&arg, sizeof(arg)) < 0){
80104954:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104957:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010495e:	00 
8010495f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104963:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010496a:	e8 d1 06 00 00       	call   80105040 <argptr>
    return -1;
  }

  return thread_create(thread, start_routine, arg);
}
8010496f:	c9                   	leave  
    return -1;
  }
  if(argptr(1, (char**)&start_routine, sizeof(start_routine)) < 0){
    return -1;
  }
  if(argptr(2, (char**)&arg, sizeof(arg)) < 0){
80104970:	c1 f8 1f             	sar    $0x1f,%eax
    return -1;
  }

  return thread_create(thread, start_routine, arg);
}
80104973:	c3                   	ret    
80104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  thread_t * thread;
  void * (*start_routine)(void *);
  void * arg;

  if(argptr(0, (char**)&thread, sizeof(thread)) < 0){
    return -1;
80104978:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(argptr(2, (char**)&arg, sizeof(arg)) < 0){
    return -1;
  }

  return thread_create(thread, start_routine, arg);
}
8010497d:	c9                   	leave  
8010497e:	c3                   	ret    
8010497f:	90                   	nop

80104980 <thread_exit>:



void
thread_exit(void *retval)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
  return;
}
80104983:	5d                   	pop    %ebp
80104984:	c3                   	ret    
80104985:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104990 <sys_thread_exit>:

int
sys_thread_exit(void)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	83 ec 28             	sub    $0x28,%esp
  void *retval;
  if(argptr(0, (char**)&retval, sizeof(retval)) < 0){
80104996:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104999:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801049a0:	00 
801049a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801049a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049ac:	e8 8f 06 00 00       	call   80105040 <argptr>
    return -1;
  }

  thread_exit(retval);
  return 0;
}
801049b1:	c9                   	leave  

int
sys_thread_exit(void)
{
  void *retval;
  if(argptr(0, (char**)&retval, sizeof(retval)) < 0){
801049b2:	c1 f8 1f             	sar    $0x1f,%eax
    return -1;
  }

  thread_exit(retval);
  return 0;
}
801049b5:	c3                   	ret    
801049b6:	8d 76 00             	lea    0x0(%esi),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <thread_join>:

int
thread_join(thread_t thread, void **retval)
{
801049c0:	55                   	push   %ebp
  return 0;
}
801049c1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
thread_join(thread_t thread, void **retval)
{
801049c3:	89 e5                	mov    %esp,%ebp
  return 0;
}
801049c5:	5d                   	pop    %ebp
801049c6:	c3                   	ret    
801049c7:	89 f6                	mov    %esi,%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049d0 <sys_thread_join>:

int
sys_thread_join(void)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	83 ec 28             	sub    $0x28,%esp
  thread_t thread;
  void **retval;

  if(argint(0, (int*)&thread) < 0){
801049d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801049dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049e4:	e8 17 06 00 00       	call   80105000 <argint>
801049e9:	85 c0                	test   %eax,%eax
801049eb:	78 23                	js     80104a10 <sys_thread_join+0x40>
    return -1;
  }
  if(argptr(1, (char**)&retval, sizeof(retval)) < 0){
801049ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049f0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801049f7:	00 
801049f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801049fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a03:	e8 38 06 00 00       	call   80105040 <argptr>
    return -1;
  }

  return thread_join(thread, retval);
}
80104a08:	c9                   	leave  
  void **retval;

  if(argint(0, (int*)&thread) < 0){
    return -1;
  }
  if(argptr(1, (char**)&retval, sizeof(retval)) < 0){
80104a09:	c1 f8 1f             	sar    $0x1f,%eax
    return -1;
  }

  return thread_join(thread, retval);
}
80104a0c:	c3                   	ret    
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi
{
  thread_t thread;
  void **retval;

  if(argint(0, (int*)&thread) < 0){
    return -1;
80104a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(argptr(1, (char**)&retval, sizeof(retval)) < 0){
    return -1;
  }

  return thread_join(thread, retval);
}
80104a15:	c9                   	leave  
80104a16:	c3                   	ret    
80104a17:	66 90                	xchg   %ax,%ax
80104a19:	66 90                	xchg   %ax,%ax
80104a1b:	66 90                	xchg   %ax,%ax
80104a1d:	66 90                	xchg   %ax,%ax
80104a1f:	90                   	nop

80104a20 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	53                   	push   %ebx
80104a24:	83 ec 14             	sub    $0x14,%esp
80104a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a2a:	c7 44 24 04 80 7f 10 	movl   $0x80107f80,0x4(%esp)
80104a31:	80 
80104a32:	8d 43 04             	lea    0x4(%ebx),%eax
80104a35:	89 04 24             	mov    %eax,(%esp)
80104a38:	e8 f3 00 00 00       	call   80104b30 <initlock>
  lk->name = name;
80104a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104a40:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a46:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80104a4d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104a50:	83 c4 14             	add    $0x14,%esp
80104a53:	5b                   	pop    %ebx
80104a54:	5d                   	pop    %ebp
80104a55:	c3                   	ret    
80104a56:	8d 76 00             	lea    0x0(%esi),%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a60 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	53                   	push   %ebx
80104a65:	83 ec 10             	sub    $0x10,%esp
80104a68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a6b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a6e:	89 34 24             	mov    %esi,(%esp)
80104a71:	e8 3a 01 00 00       	call   80104bb0 <acquire>
  while (lk->locked) {
80104a76:	8b 13                	mov    (%ebx),%edx
80104a78:	85 d2                	test   %edx,%edx
80104a7a:	74 16                	je     80104a92 <acquiresleep+0x32>
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104a80:	89 74 24 04          	mov    %esi,0x4(%esp)
80104a84:	89 1c 24             	mov    %ebx,(%esp)
80104a87:	e8 64 f9 ff ff       	call   801043f0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104a8c:	8b 03                	mov    (%ebx),%eax
80104a8e:	85 c0                	test   %eax,%eax
80104a90:	75 ee                	jne    80104a80 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104a92:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
80104a98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a9e:	8b 40 10             	mov    0x10(%eax),%eax
80104aa1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104aa4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104aa7:	83 c4 10             	add    $0x10,%esp
80104aaa:	5b                   	pop    %ebx
80104aab:	5e                   	pop    %esi
80104aac:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
80104aad:	e9 2e 02 00 00       	jmp    80104ce0 <release>
80104ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	83 ec 10             	sub    $0x10,%esp
80104ac8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104acb:	8d 73 04             	lea    0x4(%ebx),%esi
80104ace:	89 34 24             	mov    %esi,(%esp)
80104ad1:	e8 da 00 00 00       	call   80104bb0 <acquire>
  lk->locked = 0;
80104ad6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104adc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ae3:	89 1c 24             	mov    %ebx,(%esp)
80104ae6:	e8 05 fb ff ff       	call   801045f0 <wakeup>
  release(&lk->lk);
80104aeb:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104aee:	83 c4 10             	add    $0x10,%esp
80104af1:	5b                   	pop    %ebx
80104af2:	5e                   	pop    %esi
80104af3:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104af4:	e9 e7 01 00 00       	jmp    80104ce0 <release>
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b00 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
80104b05:	83 ec 10             	sub    $0x10,%esp
80104b08:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104b0b:	8d 73 04             	lea    0x4(%ebx),%esi
80104b0e:	89 34 24             	mov    %esi,(%esp)
80104b11:	e8 9a 00 00 00       	call   80104bb0 <acquire>
  r = lk->locked;
80104b16:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104b18:	89 34 24             	mov    %esi,(%esp)
80104b1b:	e8 c0 01 00 00       	call   80104ce0 <release>
  return r;
}
80104b20:	83 c4 10             	add    $0x10,%esp
80104b23:	89 d8                	mov    %ebx,%eax
80104b25:	5b                   	pop    %ebx
80104b26:	5e                   	pop    %esi
80104b27:	5d                   	pop    %ebp
80104b28:	c3                   	ret    
80104b29:	66 90                	xchg   %ax,%ax
80104b2b:	66 90                	xchg   %ax,%ax
80104b2d:	66 90                	xchg   %ax,%ax
80104b2f:	90                   	nop

80104b30 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80104b3f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104b42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b49:	5d                   	pop    %ebp
80104b4a:	c3                   	ret    
80104b4b:	90                   	nop
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b50 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104b53:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104b59:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104b5a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104b5d:	31 c0                	xor    %eax,%eax
80104b5f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b60:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104b66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b6c:	77 1a                	ja     80104b88 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b6e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104b71:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b74:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104b77:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b79:	83 f8 0a             	cmp    $0xa,%eax
80104b7c:	75 e2                	jne    80104b60 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b7e:	5b                   	pop    %ebx
80104b7f:	5d                   	pop    %ebp
80104b80:	c3                   	ret    
80104b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104b88:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b8f:	83 c0 01             	add    $0x1,%eax
80104b92:	83 f8 0a             	cmp    $0xa,%eax
80104b95:	74 e7                	je     80104b7e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104b97:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104b9e:	83 c0 01             	add    $0x1,%eax
80104ba1:	83 f8 0a             	cmp    $0xa,%eax
80104ba4:	75 e2                	jne    80104b88 <getcallerpcs+0x38>
80104ba6:	eb d6                	jmp    80104b7e <getcallerpcs+0x2e>
80104ba8:	90                   	nop
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104bb0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	83 ec 18             	sub    $0x18,%esp
80104bb6:	9c                   	pushf  
80104bb7:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104bb8:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104bb9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bbf:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104bc5:	85 d2                	test   %edx,%edx
80104bc7:	75 0c                	jne    80104bd5 <acquire+0x25>
    cpu->intena = eflags & FL_IF;
80104bc9:	81 e1 00 02 00 00    	and    $0x200,%ecx
80104bcf:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
80104bd5:	83 c2 01             	add    $0x1,%edx
80104bd8:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
80104bde:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104be1:	8b 0a                	mov    (%edx),%ecx
80104be3:	85 c9                	test   %ecx,%ecx
80104be5:	74 05                	je     80104bec <acquire+0x3c>
80104be7:	3b 42 08             	cmp    0x8(%edx),%eax
80104bea:	74 3e                	je     80104c2a <acquire+0x7a>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104bec:	b9 01 00 00 00       	mov    $0x1,%ecx
80104bf1:	eb 08                	jmp    80104bfb <acquire+0x4b>
80104bf3:	90                   	nop
80104bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bf8:	8b 55 08             	mov    0x8(%ebp),%edx
80104bfb:	89 c8                	mov    %ecx,%eax
80104bfd:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104c00:	85 c0                	test   %eax,%eax
80104c02:	75 f4                	jne    80104bf8 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104c04:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104c09:	8b 45 08             	mov    0x8(%ebp),%eax
80104c0c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  getcallerpcs(&lk, lk->pcs);
80104c13:	83 c0 0c             	add    $0xc,%eax
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104c16:	89 50 fc             	mov    %edx,-0x4(%eax)
  getcallerpcs(&lk, lk->pcs);
80104c19:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c1d:	8d 45 08             	lea    0x8(%ebp),%eax
80104c20:	89 04 24             	mov    %eax,(%esp)
80104c23:	e8 28 ff ff ff       	call   80104b50 <getcallerpcs>
}
80104c28:	c9                   	leave  
80104c29:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104c2a:	c7 04 24 8b 7f 10 80 	movl   $0x80107f8b,(%esp)
80104c31:	e8 2a b7 ff ff       	call   80100360 <panic>
80104c36:	8d 76 00             	lea    0x0(%esi),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c40 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104c40:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
80104c41:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104c43:	89 e5                	mov    %esp,%ebp
80104c45:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104c48:	8b 0a                	mov    (%edx),%ecx
80104c4a:	85 c9                	test   %ecx,%ecx
80104c4c:	74 0f                	je     80104c5d <holding+0x1d>
80104c4e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c54:	39 42 08             	cmp    %eax,0x8(%edx)
80104c57:	0f 94 c0             	sete   %al
80104c5a:	0f b6 c0             	movzbl %al,%eax
}
80104c5d:	5d                   	pop    %ebp
80104c5e:	c3                   	ret    
80104c5f:	90                   	nop

80104c60 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c63:	9c                   	pushf  
80104c64:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104c65:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104c66:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c6c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104c72:	85 d2                	test   %edx,%edx
80104c74:	75 0c                	jne    80104c82 <pushcli+0x22>
    cpu->intena = eflags & FL_IF;
80104c76:	81 e1 00 02 00 00    	and    $0x200,%ecx
80104c7c:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
80104c82:	83 c2 01             	add    $0x1,%edx
80104c85:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
80104c8b:	5d                   	pop    %ebp
80104c8c:	c3                   	ret    
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi

80104c90 <popcli>:

void
popcli(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c96:	9c                   	pushf  
80104c97:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c98:	f6 c4 02             	test   $0x2,%ah
80104c9b:	75 34                	jne    80104cd1 <popcli+0x41>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
80104c9d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ca3:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
80104ca9:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104cac:	85 d2                	test   %edx,%edx
80104cae:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104cb4:	78 0f                	js     80104cc5 <popcli+0x35>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
80104cb6:	75 0b                	jne    80104cc3 <popcli+0x33>
80104cb8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104cbe:	85 c0                	test   %eax,%eax
80104cc0:	74 01                	je     80104cc3 <popcli+0x33>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104cc2:	fb                   	sti    
    sti();
}
80104cc3:	c9                   	leave  
80104cc4:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
80104cc5:	c7 04 24 aa 7f 10 80 	movl   $0x80107faa,(%esp)
80104ccc:	e8 8f b6 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104cd1:	c7 04 24 93 7f 10 80 	movl   $0x80107f93,(%esp)
80104cd8:	e8 83 b6 ff ff       	call   80100360 <panic>
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi

80104ce0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	83 ec 18             	sub    $0x18,%esp
80104ce6:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104ce9:	8b 10                	mov    (%eax),%edx
80104ceb:	85 d2                	test   %edx,%edx
80104ced:	74 0c                	je     80104cfb <release+0x1b>
80104cef:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104cf6:	39 50 08             	cmp    %edx,0x8(%eax)
80104cf9:	74 0d                	je     80104d08 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104cfb:	c7 04 24 b1 7f 10 80 	movl   $0x80107fb1,(%esp)
80104d02:	e8 59 b6 ff ff       	call   80100360 <panic>
80104d07:	90                   	nop

  lk->pcs[0] = 0;
80104d08:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104d0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104d16:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80104d21:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104d22:	e9 69 ff ff ff       	jmp    80104c90 <popcli>
80104d27:	66 90                	xchg   %ax,%ax
80104d29:	66 90                	xchg   %ax,%ax
80104d2b:	66 90                	xchg   %ax,%ax
80104d2d:	66 90                	xchg   %ax,%ax
80104d2f:	90                   	nop

80104d30 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	8b 55 08             	mov    0x8(%ebp),%edx
80104d36:	57                   	push   %edi
80104d37:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d3a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
80104d3b:	f6 c2 03             	test   $0x3,%dl
80104d3e:	75 05                	jne    80104d45 <memset+0x15>
80104d40:	f6 c1 03             	test   $0x3,%cl
80104d43:	74 13                	je     80104d58 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104d45:	89 d7                	mov    %edx,%edi
80104d47:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d4a:	fc                   	cld    
80104d4b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d4d:	5b                   	pop    %ebx
80104d4e:	89 d0                	mov    %edx,%eax
80104d50:	5f                   	pop    %edi
80104d51:	5d                   	pop    %ebp
80104d52:	c3                   	ret    
80104d53:	90                   	nop
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104d58:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d5c:	c1 e9 02             	shr    $0x2,%ecx
80104d5f:	89 f8                	mov    %edi,%eax
80104d61:	89 fb                	mov    %edi,%ebx
80104d63:	c1 e0 18             	shl    $0x18,%eax
80104d66:	c1 e3 10             	shl    $0x10,%ebx
80104d69:	09 d8                	or     %ebx,%eax
80104d6b:	09 f8                	or     %edi,%eax
80104d6d:	c1 e7 08             	shl    $0x8,%edi
80104d70:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104d72:	89 d7                	mov    %edx,%edi
80104d74:	fc                   	cld    
80104d75:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104d77:	5b                   	pop    %ebx
80104d78:	89 d0                	mov    %edx,%eax
80104d7a:	5f                   	pop    %edi
80104d7b:	5d                   	pop    %ebp
80104d7c:	c3                   	ret    
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi

80104d80 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	8b 45 10             	mov    0x10(%ebp),%eax
80104d86:	57                   	push   %edi
80104d87:	56                   	push   %esi
80104d88:	8b 75 0c             	mov    0xc(%ebp),%esi
80104d8b:	53                   	push   %ebx
80104d8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d8f:	85 c0                	test   %eax,%eax
80104d91:	8d 78 ff             	lea    -0x1(%eax),%edi
80104d94:	74 26                	je     80104dbc <memcmp+0x3c>
    if(*s1 != *s2)
80104d96:	0f b6 03             	movzbl (%ebx),%eax
80104d99:	31 d2                	xor    %edx,%edx
80104d9b:	0f b6 0e             	movzbl (%esi),%ecx
80104d9e:	38 c8                	cmp    %cl,%al
80104da0:	74 16                	je     80104db8 <memcmp+0x38>
80104da2:	eb 24                	jmp    80104dc8 <memcmp+0x48>
80104da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104da8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
80104dad:	83 c2 01             	add    $0x1,%edx
80104db0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104db4:	38 c8                	cmp    %cl,%al
80104db6:	75 10                	jne    80104dc8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104db8:	39 fa                	cmp    %edi,%edx
80104dba:	75 ec                	jne    80104da8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104dbc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104dbd:	31 c0                	xor    %eax,%eax
}
80104dbf:	5e                   	pop    %esi
80104dc0:	5f                   	pop    %edi
80104dc1:	5d                   	pop    %ebp
80104dc2:	c3                   	ret    
80104dc3:	90                   	nop
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dc8:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104dc9:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104dcb:	5e                   	pop    %esi
80104dcc:	5f                   	pop    %edi
80104dcd:	5d                   	pop    %ebp
80104dce:	c3                   	ret    
80104dcf:	90                   	nop

80104dd0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd7:	56                   	push   %esi
80104dd8:	8b 75 0c             	mov    0xc(%ebp),%esi
80104ddb:	53                   	push   %ebx
80104ddc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ddf:	39 c6                	cmp    %eax,%esi
80104de1:	73 35                	jae    80104e18 <memmove+0x48>
80104de3:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104de6:	39 c8                	cmp    %ecx,%eax
80104de8:	73 2e                	jae    80104e18 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
80104dea:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
80104dec:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
80104def:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104df2:	74 1b                	je     80104e0f <memmove+0x3f>
80104df4:	f7 db                	neg    %ebx
80104df6:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104df9:	01 fb                	add    %edi,%ebx
80104dfb:	90                   	nop
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104e00:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104e04:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104e07:	83 ea 01             	sub    $0x1,%edx
80104e0a:	83 fa ff             	cmp    $0xffffffff,%edx
80104e0d:	75 f1                	jne    80104e00 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e0f:	5b                   	pop    %ebx
80104e10:	5e                   	pop    %esi
80104e11:	5f                   	pop    %edi
80104e12:	5d                   	pop    %ebp
80104e13:	c3                   	ret    
80104e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e18:	31 d2                	xor    %edx,%edx
80104e1a:	85 db                	test   %ebx,%ebx
80104e1c:	74 f1                	je     80104e0f <memmove+0x3f>
80104e1e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104e20:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104e24:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104e27:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104e2a:	39 da                	cmp    %ebx,%edx
80104e2c:	75 f2                	jne    80104e20 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104e2e:	5b                   	pop    %ebx
80104e2f:	5e                   	pop    %esi
80104e30:	5f                   	pop    %edi
80104e31:	5d                   	pop    %ebp
80104e32:	c3                   	ret    
80104e33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104e43:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104e44:	e9 87 ff ff ff       	jmp    80104dd0 <memmove>
80104e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e50 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	8b 75 10             	mov    0x10(%ebp),%esi
80104e57:	53                   	push   %ebx
80104e58:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e5b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
80104e5e:	85 f6                	test   %esi,%esi
80104e60:	74 30                	je     80104e92 <strncmp+0x42>
80104e62:	0f b6 01             	movzbl (%ecx),%eax
80104e65:	84 c0                	test   %al,%al
80104e67:	74 2f                	je     80104e98 <strncmp+0x48>
80104e69:	0f b6 13             	movzbl (%ebx),%edx
80104e6c:	38 d0                	cmp    %dl,%al
80104e6e:	75 46                	jne    80104eb6 <strncmp+0x66>
80104e70:	8d 51 01             	lea    0x1(%ecx),%edx
80104e73:	01 ce                	add    %ecx,%esi
80104e75:	eb 14                	jmp    80104e8b <strncmp+0x3b>
80104e77:	90                   	nop
80104e78:	0f b6 02             	movzbl (%edx),%eax
80104e7b:	84 c0                	test   %al,%al
80104e7d:	74 31                	je     80104eb0 <strncmp+0x60>
80104e7f:	0f b6 19             	movzbl (%ecx),%ebx
80104e82:	83 c2 01             	add    $0x1,%edx
80104e85:	38 d8                	cmp    %bl,%al
80104e87:	75 17                	jne    80104ea0 <strncmp+0x50>
    n--, p++, q++;
80104e89:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104e8b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
80104e8d:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104e90:	75 e6                	jne    80104e78 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e92:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104e93:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104e95:	5e                   	pop    %esi
80104e96:	5d                   	pop    %ebp
80104e97:	c3                   	ret    
80104e98:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104e9b:	31 c0                	xor    %eax,%eax
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ea0:	0f b6 d3             	movzbl %bl,%edx
80104ea3:	29 d0                	sub    %edx,%eax
}
80104ea5:	5b                   	pop    %ebx
80104ea6:	5e                   	pop    %esi
80104ea7:	5d                   	pop    %ebp
80104ea8:	c3                   	ret    
80104ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eb0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104eb4:	eb ea                	jmp    80104ea0 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104eb6:	89 d3                	mov    %edx,%ebx
80104eb8:	eb e6                	jmp    80104ea0 <strncmp+0x50>
80104eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ec0 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ec6:	56                   	push   %esi
80104ec7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eca:	53                   	push   %ebx
80104ecb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ece:	89 c2                	mov    %eax,%edx
80104ed0:	eb 19                	jmp    80104eeb <strncpy+0x2b>
80104ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ed8:	83 c3 01             	add    $0x1,%ebx
80104edb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104edf:	83 c2 01             	add    $0x1,%edx
80104ee2:	84 c9                	test   %cl,%cl
80104ee4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ee7:	74 09                	je     80104ef2 <strncpy+0x32>
80104ee9:	89 f1                	mov    %esi,%ecx
80104eeb:	85 c9                	test   %ecx,%ecx
80104eed:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104ef0:	7f e6                	jg     80104ed8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ef2:	31 c9                	xor    %ecx,%ecx
80104ef4:	85 f6                	test   %esi,%esi
80104ef6:	7e 0f                	jle    80104f07 <strncpy+0x47>
    *s++ = 0;
80104ef8:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104efc:	89 f3                	mov    %esi,%ebx
80104efe:	83 c1 01             	add    $0x1,%ecx
80104f01:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104f03:	85 db                	test   %ebx,%ebx
80104f05:	7f f1                	jg     80104ef8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104f07:	5b                   	pop    %ebx
80104f08:	5e                   	pop    %esi
80104f09:	5d                   	pop    %ebp
80104f0a:	c3                   	ret    
80104f0b:	90                   	nop
80104f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f16:	56                   	push   %esi
80104f17:	8b 45 08             	mov    0x8(%ebp),%eax
80104f1a:	53                   	push   %ebx
80104f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104f1e:	85 c9                	test   %ecx,%ecx
80104f20:	7e 26                	jle    80104f48 <safestrcpy+0x38>
80104f22:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104f26:	89 c1                	mov    %eax,%ecx
80104f28:	eb 17                	jmp    80104f41 <safestrcpy+0x31>
80104f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f30:	83 c2 01             	add    $0x1,%edx
80104f33:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104f37:	83 c1 01             	add    $0x1,%ecx
80104f3a:	84 db                	test   %bl,%bl
80104f3c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104f3f:	74 04                	je     80104f45 <safestrcpy+0x35>
80104f41:	39 f2                	cmp    %esi,%edx
80104f43:	75 eb                	jne    80104f30 <safestrcpy+0x20>
    ;
  *s = 0;
80104f45:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104f48:	5b                   	pop    %ebx
80104f49:	5e                   	pop    %esi
80104f4a:	5d                   	pop    %ebp
80104f4b:	c3                   	ret    
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f50 <strlen>:

int
strlen(const char *s)
{
80104f50:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f51:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104f53:	89 e5                	mov    %esp,%ebp
80104f55:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104f58:	80 3a 00             	cmpb   $0x0,(%edx)
80104f5b:	74 0c                	je     80104f69 <strlen+0x19>
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
80104f60:	83 c0 01             	add    $0x1,%eax
80104f63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f67:	75 f7                	jne    80104f60 <strlen+0x10>
    ;
  return n;
}
80104f69:	5d                   	pop    %ebp
80104f6a:	c3                   	ret    

80104f6b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax # esp는 return address를 가리키고 있다(old). 아직 스택에 아무것도 push가 안됐으므로, return address를 가리킨다.
80104f6b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx # new
80104f6f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  # 아래 push하는 레지스터들은 convention에 따른다.
  # eip는 push하지 않는다. esp를 그냥 eip로 삼겠다는 것.
  pushl %ebp
80104f73:	55                   	push   %ebp
  pushl %ebx
80104f74:	53                   	push   %ebx
  pushl %esi
80104f75:	56                   	push   %esi
  pushl %edi
80104f76:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax) # esp의 값을 eax가 가리키고 있는 주소에 넣는다. eax는 old. old가 edi를 가리키게 된다. 즉 old는 old context를 가리키게 된다.
80104f77:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp # edx는 new가 있다. esp에 edx를 넣는다는 것은 새로운 스택을 쓰겠다는 것. 여기서 하나씩 뺴면 new context의 값을 cpu register에 넣는다.
80104f79:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104f7b:	5f                   	pop    %edi
  popl %esi
80104f7c:	5e                   	pop    %esi
  popl %ebx
80104f7d:	5b                   	pop    %ebx
  popl %ebp
80104f7e:	5d                   	pop    %ebp
  ret # eip를 빼는 것. ret는 call과 쌍이다. call에서 return address를 넣는다. 맞나? ret를 실행함으로써 eip를 리턴한다? 뺀다?
80104f7f:	c3                   	ret    

80104f80 <fetchint>:

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104f80:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f87:	55                   	push   %ebp
80104f88:	89 e5                	mov    %esp,%ebp
80104f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
80104f8d:	8b 12                	mov    (%edx),%edx
80104f8f:	39 c2                	cmp    %eax,%edx
80104f91:	76 15                	jbe    80104fa8 <fetchint+0x28>
80104f93:	8d 48 04             	lea    0x4(%eax),%ecx
80104f96:	39 ca                	cmp    %ecx,%edx
80104f98:	72 0e                	jb     80104fa8 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
80104f9a:	8b 10                	mov    (%eax),%edx
80104f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f9f:	89 10                	mov    %edx,(%eax)
  return 0;
80104fa1:	31 c0                	xor    %eax,%eax
}
80104fa3:	5d                   	pop    %ebp
80104fa4:	c3                   	ret    
80104fa5:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
80104fad:	5d                   	pop    %ebp
80104fae:	c3                   	ret    
80104faf:	90                   	nop

80104fb0 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104fb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104fb6:	55                   	push   %ebp
80104fb7:	89 e5                	mov    %esp,%ebp
80104fb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
80104fbc:	39 08                	cmp    %ecx,(%eax)
80104fbe:	76 2c                	jbe    80104fec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fc3:	89 c8                	mov    %ecx,%eax
80104fc5:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104fc7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104fce:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104fd0:	39 d1                	cmp    %edx,%ecx
80104fd2:	73 18                	jae    80104fec <fetchstr+0x3c>
    if(*s == 0)
80104fd4:	80 39 00             	cmpb   $0x0,(%ecx)
80104fd7:	75 0c                	jne    80104fe5 <fetchstr+0x35>
80104fd9:	eb 1d                	jmp    80104ff8 <fetchstr+0x48>
80104fdb:	90                   	nop
80104fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fe0:	80 38 00             	cmpb   $0x0,(%eax)
80104fe3:	74 13                	je     80104ff8 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104fe5:	83 c0 01             	add    $0x1,%eax
80104fe8:	39 c2                	cmp    %eax,%edx
80104fea:	77 f4                	ja     80104fe0 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
80104fec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104ff1:	5d                   	pop    %ebp
80104ff2:	c3                   	ret    
80104ff3:	90                   	nop
80104ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104ff8:	29 c8                	sub    %ecx,%eax
  return -1;
}
80104ffa:	5d                   	pop    %ebp
80104ffb:	c3                   	ret    
80104ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105000 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105000:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105007:	55                   	push   %ebp
80105008:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010500a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010500d:	8b 42 18             	mov    0x18(%edx),%eax

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80105010:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105012:	8b 40 44             	mov    0x44(%eax),%eax
80105015:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80105018:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010501b:	39 d1                	cmp    %edx,%ecx
8010501d:	73 19                	jae    80105038 <argint+0x38>
8010501f:	8d 48 08             	lea    0x8(%eax),%ecx
80105022:	39 ca                	cmp    %ecx,%edx
80105024:	72 12                	jb     80105038 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80105026:	8b 50 04             	mov    0x4(%eax),%edx
80105029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010502c:	89 10                	mov    %edx,(%eax)
  return 0;
8010502e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80105030:	5d                   	pop    %ebp
80105031:	c3                   	ret    
80105032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80105038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
8010503d:	5d                   	pop    %ebp
8010503e:	c3                   	ret    
8010503f:	90                   	nop

80105040 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105040:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105046:	55                   	push   %ebp
80105047:	89 e5                	mov    %esp,%ebp
80105049:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010504a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010504d:	8b 50 18             	mov    0x18(%eax),%edx
80105050:	8b 52 44             	mov    0x44(%edx),%edx
80105053:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80105056:	8b 10                	mov    (%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
80105058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010505d:	8d 59 04             	lea    0x4(%ecx),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80105060:	39 d3                	cmp    %edx,%ebx
80105062:	73 25                	jae    80105089 <argptr+0x49>
80105064:	8d 59 08             	lea    0x8(%ecx),%ebx
80105067:	39 da                	cmp    %ebx,%edx
80105069:	72 1e                	jb     80105089 <argptr+0x49>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
8010506b:	8b 5d 10             	mov    0x10(%ebp),%ebx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
8010506e:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80105071:	85 db                	test   %ebx,%ebx
80105073:	78 14                	js     80105089 <argptr+0x49>
80105075:	39 d1                	cmp    %edx,%ecx
80105077:	73 10                	jae    80105089 <argptr+0x49>
80105079:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010507c:	01 cb                	add    %ecx,%ebx
8010507e:	39 d3                	cmp    %edx,%ebx
80105080:	77 07                	ja     80105089 <argptr+0x49>
    return -1;
  *pp = (char*)i;
80105082:	8b 45 0c             	mov    0xc(%ebp),%eax
80105085:	89 08                	mov    %ecx,(%eax)
  return 0;
80105087:	31 c0                	xor    %eax,%eax
}
80105089:	5b                   	pop    %ebx
8010508a:	5d                   	pop    %ebp
8010508b:	c3                   	ret    
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105090 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105090:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105096:	55                   	push   %ebp
80105097:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105099:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010509c:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010509f:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801050a1:	8b 52 44             	mov    0x44(%edx),%edx
801050a4:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
801050a7:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801050aa:	39 c1                	cmp    %eax,%ecx
801050ac:	73 07                	jae    801050b5 <argstr+0x25>
801050ae:	8d 4a 08             	lea    0x8(%edx),%ecx
801050b1:	39 c8                	cmp    %ecx,%eax
801050b3:	73 0b                	jae    801050c0 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801050b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801050ba:	5d                   	pop    %ebp
801050bb:	c3                   	ret    
801050bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801050c0:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801050c3:	39 c1                	cmp    %eax,%ecx
801050c5:	73 ee                	jae    801050b5 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
801050c7:	8b 55 0c             	mov    0xc(%ebp),%edx
801050ca:	89 c8                	mov    %ecx,%eax
801050cc:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801050ce:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801050d5:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
801050d7:	39 d1                	cmp    %edx,%ecx
801050d9:	73 da                	jae    801050b5 <argstr+0x25>
    if(*s == 0)
801050db:	80 39 00             	cmpb   $0x0,(%ecx)
801050de:	75 12                	jne    801050f2 <argstr+0x62>
801050e0:	eb 1e                	jmp    80105100 <argstr+0x70>
801050e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050e8:	80 38 00             	cmpb   $0x0,(%eax)
801050eb:	90                   	nop
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050f0:	74 0e                	je     80105100 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801050f2:	83 c0 01             	add    $0x1,%eax
801050f5:	39 c2                	cmp    %eax,%edx
801050f7:	77 ef                	ja     801050e8 <argstr+0x58>
801050f9:	eb ba                	jmp    801050b5 <argstr+0x25>
801050fb:	90                   	nop
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
80105100:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105102:	5d                   	pop    %ebp
80105103:	c3                   	ret    
80105104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010510a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105110 <syscall>:
[SYS_gettid]  sys_gettid,
};

void
syscall(void)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	53                   	push   %ebx
80105114:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105117:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010511e:	8b 5a 18             	mov    0x18(%edx),%ebx
80105121:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105124:	8d 48 ff             	lea    -0x1(%eax),%ecx
80105127:	83 f9 1d             	cmp    $0x1d,%ecx
8010512a:	77 1c                	ja     80105148 <syscall+0x38>
8010512c:	8b 0c 85 e0 7f 10 80 	mov    -0x7fef8020(,%eax,4),%ecx
80105133:	85 c9                	test   %ecx,%ecx
80105135:	74 11                	je     80105148 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80105137:	ff d1                	call   *%ecx
80105139:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
8010513c:	83 c4 14             	add    $0x14,%esp
8010513f:	5b                   	pop    %ebx
80105140:	5d                   	pop    %ebp
80105141:	c3                   	ret    
80105142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105148:	89 44 24 0c          	mov    %eax,0xc(%esp)
            proc->pid, proc->name, num);
8010514c:	8d 42 6c             	lea    0x6c(%edx),%eax
8010514f:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105153:	8b 42 10             	mov    0x10(%edx),%eax
80105156:	c7 04 24 b9 7f 10 80 	movl   $0x80107fb9,(%esp)
8010515d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105161:	e8 ea b4 ff ff       	call   80100650 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105166:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010516c:	8b 40 18             	mov    0x18(%eax),%eax
8010516f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105176:	83 c4 14             	add    $0x14,%esp
80105179:	5b                   	pop    %ebx
8010517a:	5d                   	pop    %ebp
8010517b:	c3                   	ret    
8010517c:	66 90                	xchg   %ax,%ax
8010517e:	66 90                	xchg   %ax,%ax

80105180 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	57                   	push   %edi
80105184:	56                   	push   %esi
80105185:	53                   	push   %ebx
80105186:	83 ec 4c             	sub    $0x4c,%esp
80105189:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010518c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010518f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80105192:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105196:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105199:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010519c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010519f:	e8 ac cd ff ff       	call   80101f50 <nameiparent>
801051a4:	85 c0                	test   %eax,%eax
801051a6:	89 c7                	mov    %eax,%edi
801051a8:	0f 84 da 00 00 00    	je     80105288 <create+0x108>
    return 0;
  ilock(dp);
801051ae:	89 04 24             	mov    %eax,(%esp)
801051b1:	e8 4a c5 ff ff       	call   80101700 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801051b6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801051b9:	89 44 24 08          	mov    %eax,0x8(%esp)
801051bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801051c1:	89 3c 24             	mov    %edi,(%esp)
801051c4:	e8 27 ca ff ff       	call   80101bf0 <dirlookup>
801051c9:	85 c0                	test   %eax,%eax
801051cb:	89 c6                	mov    %eax,%esi
801051cd:	74 41                	je     80105210 <create+0x90>
    iunlockput(dp);
801051cf:	89 3c 24             	mov    %edi,(%esp)
801051d2:	e8 69 c7 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
801051d7:	89 34 24             	mov    %esi,(%esp)
801051da:	e8 21 c5 ff ff       	call   80101700 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051df:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801051e4:	75 12                	jne    801051f8 <create+0x78>
801051e6:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801051eb:	89 f0                	mov    %esi,%eax
801051ed:	75 09                	jne    801051f8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051ef:	83 c4 4c             	add    $0x4c,%esp
801051f2:	5b                   	pop    %ebx
801051f3:	5e                   	pop    %esi
801051f4:	5f                   	pop    %edi
801051f5:	5d                   	pop    %ebp
801051f6:	c3                   	ret    
801051f7:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801051f8:	89 34 24             	mov    %esi,(%esp)
801051fb:	e8 40 c7 ff ff       	call   80101940 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105200:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80105203:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105205:	5b                   	pop    %ebx
80105206:	5e                   	pop    %esi
80105207:	5f                   	pop    %edi
80105208:	5d                   	pop    %ebp
80105209:	c3                   	ret    
8010520a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105210:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105214:	89 44 24 04          	mov    %eax,0x4(%esp)
80105218:	8b 07                	mov    (%edi),%eax
8010521a:	89 04 24             	mov    %eax,(%esp)
8010521d:	e8 4e c3 ff ff       	call   80101570 <ialloc>
80105222:	85 c0                	test   %eax,%eax
80105224:	89 c6                	mov    %eax,%esi
80105226:	0f 84 bf 00 00 00    	je     801052eb <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
8010522c:	89 04 24             	mov    %eax,(%esp)
8010522f:	e8 cc c4 ff ff       	call   80101700 <ilock>
  ip->major = major;
80105234:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105238:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010523c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105240:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105244:	b8 01 00 00 00       	mov    $0x1,%eax
80105249:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010524d:	89 34 24             	mov    %esi,(%esp)
80105250:	e8 eb c3 ff ff       	call   80101640 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105255:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010525a:	74 34                	je     80105290 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010525c:	8b 46 04             	mov    0x4(%esi),%eax
8010525f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105263:	89 3c 24             	mov    %edi,(%esp)
80105266:	89 44 24 08          	mov    %eax,0x8(%esp)
8010526a:	e8 e1 cb ff ff       	call   80101e50 <dirlink>
8010526f:	85 c0                	test   %eax,%eax
80105271:	78 6c                	js     801052df <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80105273:	89 3c 24             	mov    %edi,(%esp)
80105276:	e8 c5 c6 ff ff       	call   80101940 <iunlockput>

  return ip;
}
8010527b:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
8010527e:	89 f0                	mov    %esi,%eax
}
80105280:	5b                   	pop    %ebx
80105281:	5e                   	pop    %esi
80105282:	5f                   	pop    %edi
80105283:	5d                   	pop    %ebp
80105284:	c3                   	ret    
80105285:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105288:	31 c0                	xor    %eax,%eax
8010528a:	e9 60 ff ff ff       	jmp    801051ef <create+0x6f>
8010528f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105290:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105295:	89 3c 24             	mov    %edi,(%esp)
80105298:	e8 a3 c3 ff ff       	call   80101640 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010529d:	8b 46 04             	mov    0x4(%esi),%eax
801052a0:	c7 44 24 04 78 80 10 	movl   $0x80108078,0x4(%esp)
801052a7:	80 
801052a8:	89 34 24             	mov    %esi,(%esp)
801052ab:	89 44 24 08          	mov    %eax,0x8(%esp)
801052af:	e8 9c cb ff ff       	call   80101e50 <dirlink>
801052b4:	85 c0                	test   %eax,%eax
801052b6:	78 1b                	js     801052d3 <create+0x153>
801052b8:	8b 47 04             	mov    0x4(%edi),%eax
801052bb:	c7 44 24 04 77 80 10 	movl   $0x80108077,0x4(%esp)
801052c2:	80 
801052c3:	89 34 24             	mov    %esi,(%esp)
801052c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801052ca:	e8 81 cb ff ff       	call   80101e50 <dirlink>
801052cf:	85 c0                	test   %eax,%eax
801052d1:	79 89                	jns    8010525c <create+0xdc>
      panic("create dots");
801052d3:	c7 04 24 6b 80 10 80 	movl   $0x8010806b,(%esp)
801052da:	e8 81 b0 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801052df:	c7 04 24 7a 80 10 80 	movl   $0x8010807a,(%esp)
801052e6:	e8 75 b0 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801052eb:	c7 04 24 5c 80 10 80 	movl   $0x8010805c,(%esp)
801052f2:	e8 69 b0 ff ff       	call   80100360 <panic>
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	56                   	push   %esi
80105304:	89 c6                	mov    %eax,%esi
80105306:	53                   	push   %ebx
80105307:	89 d3                	mov    %edx,%ebx
80105309:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010530c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010530f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105313:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010531a:	e8 e1 fc ff ff       	call   80105000 <argint>
8010531f:	85 c0                	test   %eax,%eax
80105321:	78 35                	js     80105358 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105323:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105326:	83 f9 0f             	cmp    $0xf,%ecx
80105329:	77 2d                	ja     80105358 <argfd.constprop.0+0x58>
8010532b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105331:	8b 44 88 28          	mov    0x28(%eax,%ecx,4),%eax
80105335:	85 c0                	test   %eax,%eax
80105337:	74 1f                	je     80105358 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80105339:	85 f6                	test   %esi,%esi
8010533b:	74 02                	je     8010533f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010533d:	89 0e                	mov    %ecx,(%esi)
  if(pf)
8010533f:	85 db                	test   %ebx,%ebx
80105341:	74 0d                	je     80105350 <argfd.constprop.0+0x50>
    *pf = f;
80105343:	89 03                	mov    %eax,(%ebx)
  return 0;
80105345:	31 c0                	xor    %eax,%eax
}
80105347:	83 c4 20             	add    $0x20,%esp
8010534a:	5b                   	pop    %ebx
8010534b:	5e                   	pop    %esi
8010534c:	5d                   	pop    %ebp
8010534d:	c3                   	ret    
8010534e:	66 90                	xchg   %ax,%ax
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105350:	31 c0                	xor    %eax,%eax
80105352:	eb f3                	jmp    80105347 <argfd.constprop.0+0x47>
80105354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535d:	eb e8                	jmp    80105347 <argfd.constprop.0+0x47>
8010535f:	90                   	nop

80105360 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105360:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105361:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105363:	89 e5                	mov    %esp,%ebp
80105365:	53                   	push   %ebx
80105366:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105369:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010536c:	e8 8f ff ff ff       	call   80105300 <argfd.constprop.0>
80105371:	85 c0                	test   %eax,%eax
80105373:	78 1b                	js     80105390 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105375:	8b 55 f4             	mov    -0xc(%ebp),%edx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105378:	31 db                	xor    %ebx,%ebx
8010537a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    if(proc->ofile[fd] == 0){
80105380:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80105384:	85 c9                	test   %ecx,%ecx
80105386:	74 18                	je     801053a0 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105388:	83 c3 01             	add    $0x1,%ebx
8010538b:	83 fb 10             	cmp    $0x10,%ebx
8010538e:	75 f0                	jne    80105380 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105390:	83 c4 24             	add    $0x24,%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105398:	5b                   	pop    %ebx
80105399:	5d                   	pop    %ebp
8010539a:	c3                   	ret    
8010539b:	90                   	nop
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801053a0:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
801053a4:	89 14 24             	mov    %edx,(%esp)
801053a7:	e8 74 ba ff ff       	call   80100e20 <filedup>
  return fd;
}
801053ac:	83 c4 24             	add    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
801053af:	89 d8                	mov    %ebx,%eax
}
801053b1:	5b                   	pop    %ebx
801053b2:	5d                   	pop    %ebp
801053b3:	c3                   	ret    
801053b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801053c0 <sys_read>:

int
sys_read(void)
{
801053c0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053c1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
801053c3:	89 e5                	mov    %esp,%ebp
801053c5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053cb:	e8 30 ff ff ff       	call   80105300 <argfd.constprop.0>
801053d0:	85 c0                	test   %eax,%eax
801053d2:	78 54                	js     80105428 <sys_read+0x68>
801053d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801053db:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801053e2:	e8 19 fc ff ff       	call   80105000 <argint>
801053e7:	85 c0                	test   %eax,%eax
801053e9:	78 3d                	js     80105428 <sys_read+0x68>
801053eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801053f5:	89 44 24 08          	mov    %eax,0x8(%esp)
801053f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105400:	e8 3b fc ff ff       	call   80105040 <argptr>
80105405:	85 c0                	test   %eax,%eax
80105407:	78 1f                	js     80105428 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80105409:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010540c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105410:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105413:	89 44 24 04          	mov    %eax,0x4(%esp)
80105417:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010541a:	89 04 24             	mov    %eax,(%esp)
8010541d:	e8 5e bb ff ff       	call   80100f80 <fileread>
}
80105422:	c9                   	leave  
80105423:	c3                   	ret    
80105424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
8010542d:	c9                   	leave  
8010542e:	c3                   	ret    
8010542f:	90                   	nop

80105430 <sys_write>:

int
sys_write(void)
{
80105430:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105431:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105433:	89 e5                	mov    %esp,%ebp
80105435:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105438:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010543b:	e8 c0 fe ff ff       	call   80105300 <argfd.constprop.0>
80105440:	85 c0                	test   %eax,%eax
80105442:	78 54                	js     80105498 <sys_write+0x68>
80105444:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105447:	89 44 24 04          	mov    %eax,0x4(%esp)
8010544b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105452:	e8 a9 fb ff ff       	call   80105000 <argint>
80105457:	85 c0                	test   %eax,%eax
80105459:	78 3d                	js     80105498 <sys_write+0x68>
8010545b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010545e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105465:	89 44 24 08          	mov    %eax,0x8(%esp)
80105469:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010546c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105470:	e8 cb fb ff ff       	call   80105040 <argptr>
80105475:	85 c0                	test   %eax,%eax
80105477:	78 1f                	js     80105498 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80105479:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010547c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105483:	89 44 24 04          	mov    %eax,0x4(%esp)
80105487:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010548a:	89 04 24             	mov    %eax,(%esp)
8010548d:	e8 8e bb ff ff       	call   80101020 <filewrite>
}
80105492:	c9                   	leave  
80105493:	c3                   	ret    
80105494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
8010549d:	c9                   	leave  
8010549e:	c3                   	ret    
8010549f:	90                   	nop

801054a0 <sys_close>:

int
sys_close(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801054a6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801054a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054ac:	e8 4f fe ff ff       	call   80105300 <argfd.constprop.0>
801054b1:	85 c0                	test   %eax,%eax
801054b3:	78 23                	js     801054d8 <sys_close+0x38>
    return -1;
  proc->ofile[fd] = 0;
801054b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054be:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801054c5:	00 
  fileclose(f);
801054c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c9:	89 04 24             	mov    %eax,(%esp)
801054cc:	e8 9f b9 ff ff       	call   80100e70 <fileclose>
  return 0;
801054d1:	31 c0                	xor    %eax,%eax
}
801054d3:	c9                   	leave  
801054d4:	c3                   	ret    
801054d5:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
801054d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
801054dd:	c9                   	leave  
801054de:	c3                   	ret    
801054df:	90                   	nop

801054e0 <sys_fstat>:

int
sys_fstat(void)
{
801054e0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054e1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801054e3:	89 e5                	mov    %esp,%ebp
801054e5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054e8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801054eb:	e8 10 fe ff ff       	call   80105300 <argfd.constprop.0>
801054f0:	85 c0                	test   %eax,%eax
801054f2:	78 34                	js     80105528 <sys_fstat+0x48>
801054f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801054fe:	00 
801054ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80105503:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010550a:	e8 31 fb ff ff       	call   80105040 <argptr>
8010550f:	85 c0                	test   %eax,%eax
80105511:	78 15                	js     80105528 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80105513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105516:	89 44 24 04          	mov    %eax,0x4(%esp)
8010551a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010551d:	89 04 24             	mov    %eax,(%esp)
80105520:	e8 0b ba ff ff       	call   80100f30 <filestat>
}
80105525:	c9                   	leave  
80105526:	c3                   	ret    
80105527:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
8010552d:	c9                   	leave  
8010552e:	c3                   	ret    
8010552f:	90                   	nop

80105530 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
80105535:	53                   	push   %ebx
80105536:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105539:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010553c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105540:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105547:	e8 44 fb ff ff       	call   80105090 <argstr>
8010554c:	85 c0                	test   %eax,%eax
8010554e:	0f 88 e6 00 00 00    	js     8010563a <sys_link+0x10a>
80105554:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105557:	89 44 24 04          	mov    %eax,0x4(%esp)
8010555b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105562:	e8 29 fb ff ff       	call   80105090 <argstr>
80105567:	85 c0                	test   %eax,%eax
80105569:	0f 88 cb 00 00 00    	js     8010563a <sys_link+0x10a>
    return -1;

  begin_op();
8010556f:	e8 5c d6 ff ff       	call   80102bd0 <begin_op>
  if((ip = namei(old)) == 0){
80105574:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105577:	89 04 24             	mov    %eax,(%esp)
8010557a:	e8 b1 c9 ff ff       	call   80101f30 <namei>
8010557f:	85 c0                	test   %eax,%eax
80105581:	89 c3                	mov    %eax,%ebx
80105583:	0f 84 ac 00 00 00    	je     80105635 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80105589:	89 04 24             	mov    %eax,(%esp)
8010558c:	e8 6f c1 ff ff       	call   80101700 <ilock>
  if(ip->type == T_DIR){
80105591:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105596:	0f 84 91 00 00 00    	je     8010562d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010559c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801055a1:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801055a4:	89 1c 24             	mov    %ebx,(%esp)
801055a7:	e8 94 c0 ff ff       	call   80101640 <iupdate>
  iunlock(ip);
801055ac:	89 1c 24             	mov    %ebx,(%esp)
801055af:	e8 1c c2 ff ff       	call   801017d0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801055b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
801055b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
801055bb:	89 04 24             	mov    %eax,(%esp)
801055be:	e8 8d c9 ff ff       	call   80101f50 <nameiparent>
801055c3:	85 c0                	test   %eax,%eax
801055c5:	89 c6                	mov    %eax,%esi
801055c7:	74 4f                	je     80105618 <sys_link+0xe8>
    goto bad;
  ilock(dp);
801055c9:	89 04 24             	mov    %eax,(%esp)
801055cc:	e8 2f c1 ff ff       	call   80101700 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801055d1:	8b 03                	mov    (%ebx),%eax
801055d3:	39 06                	cmp    %eax,(%esi)
801055d5:	75 39                	jne    80105610 <sys_link+0xe0>
801055d7:	8b 43 04             	mov    0x4(%ebx),%eax
801055da:	89 7c 24 04          	mov    %edi,0x4(%esp)
801055de:	89 34 24             	mov    %esi,(%esp)
801055e1:	89 44 24 08          	mov    %eax,0x8(%esp)
801055e5:	e8 66 c8 ff ff       	call   80101e50 <dirlink>
801055ea:	85 c0                	test   %eax,%eax
801055ec:	78 22                	js     80105610 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801055ee:	89 34 24             	mov    %esi,(%esp)
801055f1:	e8 4a c3 ff ff       	call   80101940 <iunlockput>
  iput(ip);
801055f6:	89 1c 24             	mov    %ebx,(%esp)
801055f9:	e8 12 c2 ff ff       	call   80101810 <iput>

  end_op();
801055fe:	e8 3d d6 ff ff       	call   80102c40 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105603:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80105606:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105608:	5b                   	pop    %ebx
80105609:	5e                   	pop    %esi
8010560a:	5f                   	pop    %edi
8010560b:	5d                   	pop    %ebp
8010560c:	c3                   	ret    
8010560d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105610:	89 34 24             	mov    %esi,(%esp)
80105613:	e8 28 c3 ff ff       	call   80101940 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80105618:	89 1c 24             	mov    %ebx,(%esp)
8010561b:	e8 e0 c0 ff ff       	call   80101700 <ilock>
  ip->nlink--;
80105620:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105625:	89 1c 24             	mov    %ebx,(%esp)
80105628:	e8 13 c0 ff ff       	call   80101640 <iupdate>
  iunlockput(ip);
8010562d:	89 1c 24             	mov    %ebx,(%esp)
80105630:	e8 0b c3 ff ff       	call   80101940 <iunlockput>
  end_op();
80105635:	e8 06 d6 ff ff       	call   80102c40 <end_op>
  return -1;
}
8010563a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010563d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105642:	5b                   	pop    %ebx
80105643:	5e                   	pop    %esi
80105644:	5f                   	pop    %edi
80105645:	5d                   	pop    %ebp
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105650 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	57                   	push   %edi
80105654:	56                   	push   %esi
80105655:	53                   	push   %ebx
80105656:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105659:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010565c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105667:	e8 24 fa ff ff       	call   80105090 <argstr>
8010566c:	85 c0                	test   %eax,%eax
8010566e:	0f 88 76 01 00 00    	js     801057ea <sys_unlink+0x19a>
    return -1;

  begin_op();
80105674:	e8 57 d5 ff ff       	call   80102bd0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105679:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010567c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010567f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105683:	89 04 24             	mov    %eax,(%esp)
80105686:	e8 c5 c8 ff ff       	call   80101f50 <nameiparent>
8010568b:	85 c0                	test   %eax,%eax
8010568d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105690:	0f 84 4f 01 00 00    	je     801057e5 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80105696:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105699:	89 34 24             	mov    %esi,(%esp)
8010569c:	e8 5f c0 ff ff       	call   80101700 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056a1:	c7 44 24 04 78 80 10 	movl   $0x80108078,0x4(%esp)
801056a8:	80 
801056a9:	89 1c 24             	mov    %ebx,(%esp)
801056ac:	e8 0f c5 ff ff       	call   80101bc0 <namecmp>
801056b1:	85 c0                	test   %eax,%eax
801056b3:	0f 84 21 01 00 00    	je     801057da <sys_unlink+0x18a>
801056b9:	c7 44 24 04 77 80 10 	movl   $0x80108077,0x4(%esp)
801056c0:	80 
801056c1:	89 1c 24             	mov    %ebx,(%esp)
801056c4:	e8 f7 c4 ff ff       	call   80101bc0 <namecmp>
801056c9:	85 c0                	test   %eax,%eax
801056cb:	0f 84 09 01 00 00    	je     801057da <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801056d1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801056d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801056d8:	89 44 24 08          	mov    %eax,0x8(%esp)
801056dc:	89 34 24             	mov    %esi,(%esp)
801056df:	e8 0c c5 ff ff       	call   80101bf0 <dirlookup>
801056e4:	85 c0                	test   %eax,%eax
801056e6:	89 c3                	mov    %eax,%ebx
801056e8:	0f 84 ec 00 00 00    	je     801057da <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
801056ee:	89 04 24             	mov    %eax,(%esp)
801056f1:	e8 0a c0 ff ff       	call   80101700 <ilock>

  if(ip->nlink < 1)
801056f6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801056fb:	0f 8e 24 01 00 00    	jle    80105825 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105701:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105706:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105709:	74 7d                	je     80105788 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010570b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105712:	00 
80105713:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010571a:	00 
8010571b:	89 34 24             	mov    %esi,(%esp)
8010571e:	e8 0d f6 ff ff       	call   80104d30 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105723:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105726:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010572d:	00 
8010572e:	89 74 24 04          	mov    %esi,0x4(%esp)
80105732:	89 44 24 08          	mov    %eax,0x8(%esp)
80105736:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105739:	89 04 24             	mov    %eax,(%esp)
8010573c:	e8 4f c3 ff ff       	call   80101a90 <writei>
80105741:	83 f8 10             	cmp    $0x10,%eax
80105744:	0f 85 cf 00 00 00    	jne    80105819 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010574a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010574f:	0f 84 a3 00 00 00    	je     801057f8 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105755:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105758:	89 04 24             	mov    %eax,(%esp)
8010575b:	e8 e0 c1 ff ff       	call   80101940 <iunlockput>

  ip->nlink--;
80105760:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105765:	89 1c 24             	mov    %ebx,(%esp)
80105768:	e8 d3 be ff ff       	call   80101640 <iupdate>
  iunlockput(ip);
8010576d:	89 1c 24             	mov    %ebx,(%esp)
80105770:	e8 cb c1 ff ff       	call   80101940 <iunlockput>

  end_op();
80105775:	e8 c6 d4 ff ff       	call   80102c40 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010577a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
8010577d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010577f:	5b                   	pop    %ebx
80105780:	5e                   	pop    %esi
80105781:	5f                   	pop    %edi
80105782:	5d                   	pop    %ebp
80105783:	c3                   	ret    
80105784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105788:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
8010578c:	0f 86 79 ff ff ff    	jbe    8010570b <sys_unlink+0xbb>
80105792:	bf 20 00 00 00       	mov    $0x20,%edi
80105797:	eb 15                	jmp    801057ae <sys_unlink+0x15e>
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057a0:	8d 57 10             	lea    0x10(%edi),%edx
801057a3:	3b 53 58             	cmp    0x58(%ebx),%edx
801057a6:	0f 83 5f ff ff ff    	jae    8010570b <sys_unlink+0xbb>
801057ac:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057ae:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801057b5:	00 
801057b6:	89 7c 24 08          	mov    %edi,0x8(%esp)
801057ba:	89 74 24 04          	mov    %esi,0x4(%esp)
801057be:	89 1c 24             	mov    %ebx,(%esp)
801057c1:	e8 ca c1 ff ff       	call   80101990 <readi>
801057c6:	83 f8 10             	cmp    $0x10,%eax
801057c9:	75 42                	jne    8010580d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
801057cb:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057d0:	74 ce                	je     801057a0 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
801057d2:	89 1c 24             	mov    %ebx,(%esp)
801057d5:	e8 66 c1 ff ff       	call   80101940 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
801057da:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801057dd:	89 04 24             	mov    %eax,(%esp)
801057e0:	e8 5b c1 ff ff       	call   80101940 <iunlockput>
  end_op();
801057e5:	e8 56 d4 ff ff       	call   80102c40 <end_op>
  return -1;
}
801057ea:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
801057ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057f2:	5b                   	pop    %ebx
801057f3:	5e                   	pop    %esi
801057f4:	5f                   	pop    %edi
801057f5:	5d                   	pop    %ebp
801057f6:	c3                   	ret    
801057f7:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801057f8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801057fb:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105800:	89 04 24             	mov    %eax,(%esp)
80105803:	e8 38 be ff ff       	call   80101640 <iupdate>
80105808:	e9 48 ff ff ff       	jmp    80105755 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010580d:	c7 04 24 9c 80 10 80 	movl   $0x8010809c,(%esp)
80105814:	e8 47 ab ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105819:	c7 04 24 ae 80 10 80 	movl   $0x801080ae,(%esp)
80105820:	e8 3b ab ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105825:	c7 04 24 8a 80 10 80 	movl   $0x8010808a,(%esp)
8010582c:	e8 2f ab ff ff       	call   80100360 <panic>
80105831:	eb 0d                	jmp    80105840 <sys_open>
80105833:	90                   	nop
80105834:	90                   	nop
80105835:	90                   	nop
80105836:	90                   	nop
80105837:	90                   	nop
80105838:	90                   	nop
80105839:	90                   	nop
8010583a:	90                   	nop
8010583b:	90                   	nop
8010583c:	90                   	nop
8010583d:	90                   	nop
8010583e:	90                   	nop
8010583f:	90                   	nop

80105840 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	57                   	push   %edi
80105844:	56                   	push   %esi
80105845:	53                   	push   %ebx
80105846:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105849:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010584c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105850:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105857:	e8 34 f8 ff ff       	call   80105090 <argstr>
8010585c:	85 c0                	test   %eax,%eax
8010585e:	0f 88 81 00 00 00    	js     801058e5 <sys_open+0xa5>
80105864:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105867:	89 44 24 04          	mov    %eax,0x4(%esp)
8010586b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105872:	e8 89 f7 ff ff       	call   80105000 <argint>
80105877:	85 c0                	test   %eax,%eax
80105879:	78 6a                	js     801058e5 <sys_open+0xa5>
    return -1;

  begin_op();
8010587b:	e8 50 d3 ff ff       	call   80102bd0 <begin_op>

  if(omode & O_CREATE){
80105880:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105884:	75 72                	jne    801058f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105886:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105889:	89 04 24             	mov    %eax,(%esp)
8010588c:	e8 9f c6 ff ff       	call   80101f30 <namei>
80105891:	85 c0                	test   %eax,%eax
80105893:	89 c7                	mov    %eax,%edi
80105895:	74 49                	je     801058e0 <sys_open+0xa0>
      end_op();
      return -1;
    }
    ilock(ip);
80105897:	89 04 24             	mov    %eax,(%esp)
8010589a:	e8 61 be ff ff       	call   80101700 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010589f:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
801058a4:	0f 84 ae 00 00 00    	je     80105958 <sys_open+0x118>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058aa:	e8 01 b5 ff ff       	call   80100db0 <filealloc>
801058af:	85 c0                	test   %eax,%eax
801058b1:	89 c6                	mov    %eax,%esi
801058b3:	74 23                	je     801058d8 <sys_open+0x98>
801058b5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801058bc:	31 db                	xor    %ebx,%ebx
801058be:	66 90                	xchg   %ax,%ax
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801058c0:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
801058c4:	85 c0                	test   %eax,%eax
801058c6:	74 50                	je     80105918 <sys_open+0xd8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801058c8:	83 c3 01             	add    $0x1,%ebx
801058cb:	83 fb 10             	cmp    $0x10,%ebx
801058ce:	75 f0                	jne    801058c0 <sys_open+0x80>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801058d0:	89 34 24             	mov    %esi,(%esp)
801058d3:	e8 98 b5 ff ff       	call   80100e70 <fileclose>
    iunlockput(ip);
801058d8:	89 3c 24             	mov    %edi,(%esp)
801058db:	e8 60 c0 ff ff       	call   80101940 <iunlockput>
    end_op();
801058e0:	e8 5b d3 ff ff       	call   80102c40 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801058e5:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801058e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801058ed:	5b                   	pop    %ebx
801058ee:	5e                   	pop    %esi
801058ef:	5f                   	pop    %edi
801058f0:	5d                   	pop    %ebp
801058f1:	c3                   	ret    
801058f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801058f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801058fb:	31 c9                	xor    %ecx,%ecx
801058fd:	ba 02 00 00 00       	mov    $0x2,%edx
80105902:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105909:	e8 72 f8 ff ff       	call   80105180 <create>
    if(ip == 0){
8010590e:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105910:	89 c7                	mov    %eax,%edi
    if(ip == 0){
80105912:	75 96                	jne    801058aa <sys_open+0x6a>
80105914:	eb ca                	jmp    801058e0 <sys_open+0xa0>
80105916:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105918:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010591c:	89 3c 24             	mov    %edi,(%esp)
8010591f:	e8 ac be ff ff       	call   801017d0 <iunlock>
  end_op();
80105924:	e8 17 d3 ff ff       	call   80102c40 <end_op>

  f->type = FD_INODE;
80105929:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010592f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105932:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80105935:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
8010593c:	89 d0                	mov    %edx,%eax
8010593e:	83 e0 01             	and    $0x1,%eax
80105941:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105944:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105947:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
8010594a:	89 d8                	mov    %ebx,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010594c:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
80105950:	83 c4 2c             	add    $0x2c,%esp
80105953:	5b                   	pop    %ebx
80105954:	5e                   	pop    %esi
80105955:	5f                   	pop    %edi
80105956:	5d                   	pop    %ebp
80105957:	c3                   	ret    
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105958:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010595b:	85 d2                	test   %edx,%edx
8010595d:	0f 84 47 ff ff ff    	je     801058aa <sys_open+0x6a>
80105963:	e9 70 ff ff ff       	jmp    801058d8 <sys_open+0x98>
80105968:	90                   	nop
80105969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105970 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105976:	e8 55 d2 ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010597b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010597e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105982:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105989:	e8 02 f7 ff ff       	call   80105090 <argstr>
8010598e:	85 c0                	test   %eax,%eax
80105990:	78 2e                	js     801059c0 <sys_mkdir+0x50>
80105992:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105995:	31 c9                	xor    %ecx,%ecx
80105997:	ba 01 00 00 00       	mov    $0x1,%edx
8010599c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059a3:	e8 d8 f7 ff ff       	call   80105180 <create>
801059a8:	85 c0                	test   %eax,%eax
801059aa:	74 14                	je     801059c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059ac:	89 04 24             	mov    %eax,(%esp)
801059af:	e8 8c bf ff ff       	call   80101940 <iunlockput>
  end_op();
801059b4:	e8 87 d2 ff ff       	call   80102c40 <end_op>
  return 0;
801059b9:	31 c0                	xor    %eax,%eax
}
801059bb:	c9                   	leave  
801059bc:	c3                   	ret    
801059bd:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801059c0:	e8 7b d2 ff ff       	call   80102c40 <end_op>
    return -1;
801059c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801059ca:	c9                   	leave  
801059cb:	c3                   	ret    
801059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_mknod>:

int
sys_mknod(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059d6:	e8 f5 d1 ff ff       	call   80102bd0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801059db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059de:	89 44 24 04          	mov    %eax,0x4(%esp)
801059e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059e9:	e8 a2 f6 ff ff       	call   80105090 <argstr>
801059ee:	85 c0                	test   %eax,%eax
801059f0:	78 5e                	js     80105a50 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801059f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801059f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a00:	e8 fb f5 ff ff       	call   80105000 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105a05:	85 c0                	test   %eax,%eax
80105a07:	78 47                	js     80105a50 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105a09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a10:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105a17:	e8 e4 f5 ff ff       	call   80105000 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105a1c:	85 c0                	test   %eax,%eax
80105a1e:	78 30                	js     80105a50 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a20:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105a24:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a29:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105a2d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a33:	e8 48 f7 ff ff       	call   80105180 <create>
80105a38:	85 c0                	test   %eax,%eax
80105a3a:	74 14                	je     80105a50 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a3c:	89 04 24             	mov    %eax,(%esp)
80105a3f:	e8 fc be ff ff       	call   80101940 <iunlockput>
  end_op();
80105a44:	e8 f7 d1 ff ff       	call   80102c40 <end_op>
  return 0;
80105a49:	31 c0                	xor    %eax,%eax
}
80105a4b:	c9                   	leave  
80105a4c:	c3                   	ret    
80105a4d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105a50:	e8 eb d1 ff ff       	call   80102c40 <end_op>
    return -1;
80105a55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105a5a:	c9                   	leave  
80105a5b:	c3                   	ret    
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_chdir>:

int
sys_chdir(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	53                   	push   %ebx
80105a64:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a67:	e8 64 d1 ff ff       	call   80102bd0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a7a:	e8 11 f6 ff ff       	call   80105090 <argstr>
80105a7f:	85 c0                	test   %eax,%eax
80105a81:	78 5a                	js     80105add <sys_chdir+0x7d>
80105a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a86:	89 04 24             	mov    %eax,(%esp)
80105a89:	e8 a2 c4 ff ff       	call   80101f30 <namei>
80105a8e:	85 c0                	test   %eax,%eax
80105a90:	89 c3                	mov    %eax,%ebx
80105a92:	74 49                	je     80105add <sys_chdir+0x7d>
    end_op();
    return -1;
  }
  ilock(ip);
80105a94:	89 04 24             	mov    %eax,(%esp)
80105a97:	e8 64 bc ff ff       	call   80101700 <ilock>
  if(ip->type != T_DIR){
80105a9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105aa1:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
80105aa4:	75 32                	jne    80105ad8 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105aa6:	e8 25 bd ff ff       	call   801017d0 <iunlock>
  iput(proc->cwd);
80105aab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ab1:	8b 40 68             	mov    0x68(%eax),%eax
80105ab4:	89 04 24             	mov    %eax,(%esp)
80105ab7:	e8 54 bd ff ff       	call   80101810 <iput>
  end_op();
80105abc:	e8 7f d1 ff ff       	call   80102c40 <end_op>
  proc->cwd = ip;
80105ac1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ac7:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
}
80105aca:	83 c4 24             	add    $0x24,%esp
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
80105acd:	31 c0                	xor    %eax,%eax
}
80105acf:	5b                   	pop    %ebx
80105ad0:	5d                   	pop    %ebp
80105ad1:	c3                   	ret    
80105ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105ad8:	e8 63 be ff ff       	call   80101940 <iunlockput>
    end_op();
80105add:	e8 5e d1 ff ff       	call   80102c40 <end_op>
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
80105ae2:	83 c4 24             	add    $0x24,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
80105ae5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
80105aea:	5b                   	pop    %ebx
80105aeb:	5d                   	pop    %ebp
80105aec:	c3                   	ret    
80105aed:	8d 76 00             	lea    0x0(%esi),%esi

80105af0 <sys_exec>:

int
sys_exec(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	57                   	push   %edi
80105af4:	56                   	push   %esi
80105af5:	53                   	push   %ebx
80105af6:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105afc:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105b02:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b0d:	e8 7e f5 ff ff       	call   80105090 <argstr>
80105b12:	85 c0                	test   %eax,%eax
80105b14:	0f 88 84 00 00 00    	js     80105b9e <sys_exec+0xae>
80105b1a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b20:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b2b:	e8 d0 f4 ff ff       	call   80105000 <argint>
80105b30:	85 c0                	test   %eax,%eax
80105b32:	78 6a                	js     80105b9e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b34:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105b3a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b3c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105b43:	00 
80105b44:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105b4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b51:	00 
80105b52:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b58:	89 04 24             	mov    %eax,(%esp)
80105b5b:	e8 d0 f1 ff ff       	call   80104d30 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b60:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b66:	89 7c 24 04          	mov    %edi,0x4(%esp)
80105b6a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105b6d:	89 04 24             	mov    %eax,(%esp)
80105b70:	e8 0b f4 ff ff       	call   80104f80 <fetchint>
80105b75:	85 c0                	test   %eax,%eax
80105b77:	78 25                	js     80105b9e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105b79:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105b7f:	85 c0                	test   %eax,%eax
80105b81:	74 2d                	je     80105bb0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105b83:	89 74 24 04          	mov    %esi,0x4(%esp)
80105b87:	89 04 24             	mov    %eax,(%esp)
80105b8a:	e8 21 f4 ff ff       	call   80104fb0 <fetchstr>
80105b8f:	85 c0                	test   %eax,%eax
80105b91:	78 0b                	js     80105b9e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105b93:	83 c3 01             	add    $0x1,%ebx
80105b96:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105b99:	83 fb 20             	cmp    $0x20,%ebx
80105b9c:	75 c2                	jne    80105b60 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105b9e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105ba9:	5b                   	pop    %ebx
80105baa:	5e                   	pop    %esi
80105bab:	5f                   	pop    %edi
80105bac:	5d                   	pop    %ebp
80105bad:	c3                   	ret    
80105bae:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105bb0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bba:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105bc0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105bc7:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105bcb:	89 04 24             	mov    %eax,(%esp)
80105bce:	e8 dd ad ff ff       	call   801009b0 <exec>
}
80105bd3:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105bd9:	5b                   	pop    %ebx
80105bda:	5e                   	pop    %esi
80105bdb:	5f                   	pop    %edi
80105bdc:	5d                   	pop    %ebp
80105bdd:	c3                   	ret    
80105bde:	66 90                	xchg   %ax,%ax

80105be0 <sys_pipe>:

int
sys_pipe(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	57                   	push   %edi
80105be4:	56                   	push   %esi
80105be5:	53                   	push   %ebx
80105be6:	83 ec 2c             	sub    $0x2c,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105be9:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105bec:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105bf3:	00 
80105bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bf8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105bff:	e8 3c f4 ff ff       	call   80105040 <argptr>
80105c04:	85 c0                	test   %eax,%eax
80105c06:	78 7a                	js     80105c82 <sys_pipe+0xa2>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c08:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c0f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c12:	89 04 24             	mov    %eax,(%esp)
80105c15:	e8 e6 d6 ff ff       	call   80103300 <pipealloc>
80105c1a:	85 c0                	test   %eax,%eax
80105c1c:	78 64                	js     80105c82 <sys_pipe+0xa2>
80105c1e:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c25:	31 c0                	xor    %eax,%eax
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c27:	8b 5d e0             	mov    -0x20(%ebp),%ebx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105c2a:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105c2e:	85 d2                	test   %edx,%edx
80105c30:	74 16                	je     80105c48 <sys_pipe+0x68>
80105c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c38:	83 c0 01             	add    $0x1,%eax
80105c3b:	83 f8 10             	cmp    $0x10,%eax
80105c3e:	74 2f                	je     80105c6f <sys_pipe+0x8f>
    if(proc->ofile[fd] == 0){
80105c40:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105c44:	85 d2                	test   %edx,%edx
80105c46:	75 f0                	jne    80105c38 <sys_pipe+0x58>
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c48:	8b 7d e4             	mov    -0x1c(%ebp),%edi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105c4b:	8d 70 08             	lea    0x8(%eax),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c4e:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105c50:	89 5c b1 08          	mov    %ebx,0x8(%ecx,%esi,4)
80105c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105c58:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
80105c5d:	74 31                	je     80105c90 <sys_pipe+0xb0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c5f:	83 c2 01             	add    $0x1,%edx
80105c62:	83 fa 10             	cmp    $0x10,%edx
80105c65:	75 f1                	jne    80105c58 <sys_pipe+0x78>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
80105c67:	c7 44 b1 08 00 00 00 	movl   $0x0,0x8(%ecx,%esi,4)
80105c6e:	00 
    fileclose(rf);
80105c6f:	89 1c 24             	mov    %ebx,(%esp)
80105c72:	e8 f9 b1 ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c7a:	89 04 24             	mov    %eax,(%esp)
80105c7d:	e8 ee b1 ff ff       	call   80100e70 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105c82:	83 c4 2c             	add    $0x2c,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105c85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105c8a:	5b                   	pop    %ebx
80105c8b:	5e                   	pop    %esi
80105c8c:	5f                   	pop    %edi
80105c8d:	5d                   	pop    %ebp
80105c8e:	c3                   	ret    
80105c8f:	90                   	nop
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105c90:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105c94:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105c97:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80105c99:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c9c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105c9f:	83 c4 2c             	add    $0x2c,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105ca2:	31 c0                	xor    %eax,%eax
}
80105ca4:	5b                   	pop    %ebx
80105ca5:	5e                   	pop    %esi
80105ca6:	5f                   	pop    %edi
80105ca7:	5d                   	pop    %ebp
80105ca8:	c3                   	ret    
80105ca9:	66 90                	xchg   %ax,%ax
80105cab:	66 90                	xchg   %ax,%ax
80105cad:	66 90                	xchg   %ax,%ax
80105caf:	90                   	nop

80105cb0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105cb3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105cb4:	e9 67 df ff ff       	jmp    80103c20 <fork>
80105cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cc0 <sys_exit>:
}

int
sys_exit(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105cc6:	e8 85 e4 ff ff       	call   80104150 <exit>
  return 0;  // not reached
}
80105ccb:	31 c0                	xor    %eax,%eax
80105ccd:	c9                   	leave  
80105cce:	c3                   	ret    
80105ccf:	90                   	nop

80105cd0 <sys_wait>:

int
sys_wait(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105cd3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105cd4:	e9 d7 e7 ff ff       	jmp    801044b0 <wait>
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <sys_kill>:
}

int
sys_kill(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ced:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cf4:	e8 07 f3 ff ff       	call   80105000 <argint>
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	78 13                	js     80105d10 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d00:	89 04 24             	mov    %eax,(%esp)
80105d03:	e8 58 e9 ff ff       	call   80104660 <kill>
}
80105d08:	c9                   	leave  
80105d09:	c3                   	ret    
80105d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d20 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105d20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105d26:	55                   	push   %ebp
80105d27:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
80105d29:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
80105d2a:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d2d:	c3                   	ret    
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <sys_gettid>:

// Design Document 2-1-2-2
int
sys_gettid(void)
{
  return proc->tid;
80105d30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
}

// Design Document 2-1-2-2
int
sys_gettid(void)
{
80105d36:	55                   	push   %ebp
80105d37:	89 e5                	mov    %esp,%ebp
  return proc->tid;
}
80105d39:	5d                   	pop    %ebp

// Design Document 2-1-2-2
int
sys_gettid(void)
{
  return proc->tid;
80105d3a:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
}
80105d40:	c3                   	ret    
80105d41:	eb 0d                	jmp    80105d50 <sys_sbrk>
80105d43:	90                   	nop
80105d44:	90                   	nop
80105d45:	90                   	nop
80105d46:	90                   	nop
80105d47:	90                   	nop
80105d48:	90                   	nop
80105d49:	90                   	nop
80105d4a:	90                   	nop
80105d4b:	90                   	nop
80105d4c:	90                   	nop
80105d4d:	90                   	nop
80105d4e:	90                   	nop
80105d4f:	90                   	nop

80105d50 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	53                   	push   %ebx
80105d54:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d65:	e8 96 f2 ff ff       	call   80105000 <argint>
80105d6a:	85 c0                	test   %eax,%eax
80105d6c:	78 22                	js     80105d90 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
80105d6e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
80105d74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
80105d77:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d79:	89 14 24             	mov    %edx,(%esp)
80105d7c:	e8 1f de ff ff       	call   80103ba0 <growproc>
80105d81:	85 c0                	test   %eax,%eax
80105d83:	78 0b                	js     80105d90 <sys_sbrk+0x40>
    return -1;
  return addr;
80105d85:	89 d8                	mov    %ebx,%eax
}
80105d87:	83 c4 24             	add    $0x24,%esp
80105d8a:	5b                   	pop    %ebx
80105d8b:	5d                   	pop    %ebp
80105d8c:	c3                   	ret    
80105d8d:	8d 76 00             	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d95:	eb f0                	jmp    80105d87 <sys_sbrk+0x37>
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	53                   	push   %ebx
80105da4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105da7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105daa:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105db5:	e8 46 f2 ff ff       	call   80105000 <argint>
80105dba:	85 c0                	test   %eax,%eax
80105dbc:	78 7e                	js     80105e3c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
80105dbe:	c7 04 24 80 66 11 80 	movl   $0x80116680,(%esp)
80105dc5:	e8 e6 ed ff ff       	call   80104bb0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105dca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105dcd:	8b 1d c0 6e 11 80    	mov    0x80116ec0,%ebx
  while(ticks - ticks0 < n){
80105dd3:	85 d2                	test   %edx,%edx
80105dd5:	75 29                	jne    80105e00 <sys_sleep+0x60>
80105dd7:	eb 4f                	jmp    80105e28 <sys_sleep+0x88>
80105dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105de0:	c7 44 24 04 80 66 11 	movl   $0x80116680,0x4(%esp)
80105de7:	80 
80105de8:	c7 04 24 c0 6e 11 80 	movl   $0x80116ec0,(%esp)
80105def:	e8 fc e5 ff ff       	call   801043f0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105df4:	a1 c0 6e 11 80       	mov    0x80116ec0,%eax
80105df9:	29 d8                	sub    %ebx,%eax
80105dfb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105dfe:	73 28                	jae    80105e28 <sys_sleep+0x88>
    if(proc->killed){
80105e00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e06:	8b 40 24             	mov    0x24(%eax),%eax
80105e09:	85 c0                	test   %eax,%eax
80105e0b:	74 d3                	je     80105de0 <sys_sleep+0x40>
      release(&tickslock);
80105e0d:	c7 04 24 80 66 11 80 	movl   $0x80116680,(%esp)
80105e14:	e8 c7 ee ff ff       	call   80104ce0 <release>
      return -1;
80105e19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105e1e:	83 c4 24             	add    $0x24,%esp
80105e21:	5b                   	pop    %ebx
80105e22:	5d                   	pop    %ebp
80105e23:	c3                   	ret    
80105e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105e28:	c7 04 24 80 66 11 80 	movl   $0x80116680,(%esp)
80105e2f:	e8 ac ee ff ff       	call   80104ce0 <release>
  return 0;
}
80105e34:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105e37:	31 c0                	xor    %eax,%eax
}
80105e39:	5b                   	pop    %ebx
80105e3a:	5d                   	pop    %ebp
80105e3b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105e3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e41:	eb db                	jmp    80105e1e <sys_sleep+0x7e>
80105e43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e50 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	53                   	push   %ebx
80105e54:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105e57:	c7 04 24 80 66 11 80 	movl   $0x80116680,(%esp)
80105e5e:	e8 4d ed ff ff       	call   80104bb0 <acquire>
  xticks = ticks;
80105e63:	8b 1d c0 6e 11 80    	mov    0x80116ec0,%ebx
  release(&tickslock);
80105e69:	c7 04 24 80 66 11 80 	movl   $0x80116680,(%esp)
80105e70:	e8 6b ee ff ff       	call   80104ce0 <release>
  return xticks;
}
80105e75:	83 c4 14             	add    $0x14,%esp
80105e78:	89 d8                	mov    %ebx,%eax
80105e7a:	5b                   	pop    %ebx
80105e7b:	5d                   	pop    %ebp
80105e7c:	c3                   	ret    
80105e7d:	66 90                	xchg   %ax,%ax
80105e7f:	90                   	nop

80105e80 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105e80:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e81:	ba 43 00 00 00       	mov    $0x43,%edx
80105e86:	89 e5                	mov    %esp,%ebp
80105e88:	b8 34 00 00 00       	mov    $0x34,%eax
80105e8d:	83 ec 18             	sub    $0x18,%esp
80105e90:	ee                   	out    %al,(%dx)
80105e91:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
80105e96:	b2 40                	mov    $0x40,%dl
80105e98:	ee                   	out    %al,(%dx)
80105e99:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105e9e:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105e9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ea6:	e8 95 d3 ff ff       	call   80103240 <picenable>
}
80105eab:	c9                   	leave  
80105eac:	c3                   	ret    

80105ead <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105ead:	1e                   	push   %ds
  pushl %es
80105eae:	06                   	push   %es
  pushl %fs
80105eaf:	0f a0                	push   %fs
  pushl %gs
80105eb1:	0f a8                	push   %gs
  pushal
80105eb3:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105eb4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105eb8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105eba:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80105ebc:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105ec0:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105ec2:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ec4:	54                   	push   %esp
  call trap
80105ec5:	e8 16 01 00 00       	call   80105fe0 <trap>
  addl $4, %esp
80105eca:	83 c4 04             	add    $0x4,%esp

80105ecd <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ecd:	61                   	popa   
  popl %gs
80105ece:	0f a9                	pop    %gs
  popl %fs
80105ed0:	0f a1                	pop    %fs
  popl %es
80105ed2:	07                   	pop    %es
  popl %ds
80105ed3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ed4:	83 c4 08             	add    $0x8,%esp
  iret
80105ed7:	cf                   	iret   
80105ed8:	66 90                	xchg   %ax,%ax
80105eda:	66 90                	xchg   %ax,%ax
80105edc:	66 90                	xchg   %ax,%ax
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105ee0:	31 c0                	xor    %eax,%eax
80105ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ee8:	8b 14 85 14 b0 10 80 	mov    -0x7fef4fec(,%eax,4),%edx
80105eef:	b9 08 00 00 00       	mov    $0x8,%ecx
80105ef4:	66 89 0c c5 c2 66 11 	mov    %cx,-0x7fee993e(,%eax,8)
80105efb:	80 
80105efc:	c6 04 c5 c4 66 11 80 	movb   $0x0,-0x7fee993c(,%eax,8)
80105f03:	00 
80105f04:	c6 04 c5 c5 66 11 80 	movb   $0x8e,-0x7fee993b(,%eax,8)
80105f0b:	8e 
80105f0c:	66 89 14 c5 c0 66 11 	mov    %dx,-0x7fee9940(,%eax,8)
80105f13:	80 
80105f14:	c1 ea 10             	shr    $0x10,%edx
80105f17:	66 89 14 c5 c6 66 11 	mov    %dx,-0x7fee993a(,%eax,8)
80105f1e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105f1f:	83 c0 01             	add    $0x1,%eax
80105f22:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f27:	75 bf                	jne    80105ee8 <tvinit+0x8>
extern void increase_MLFQ_tick_used(void);    // in proc.c
extern void increase_stride_tick_used(void);  // in proc.c

void
tvinit(void)
{
80105f29:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f2a:	ba 08 00 00 00       	mov    $0x8,%edx
extern void increase_MLFQ_tick_used(void);    // in proc.c
extern void increase_stride_tick_used(void);  // in proc.c

void
tvinit(void)
{
80105f2f:	89 e5                	mov    %esp,%ebp
80105f31:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f34:	a1 14 b1 10 80       	mov    0x8010b114,%eax
  SETGATE(idt[T_USER_INT], 1, SEG_KCODE<<3, vectors[T_USER_INT], DPL_USER);
80105f39:	b9 08 00 00 00       	mov    $0x8,%ecx

  initlock(&tickslock, "time");
80105f3e:	c7 44 24 04 bd 80 10 	movl   $0x801080bd,0x4(%esp)
80105f45:	80 
80105f46:	c7 04 24 80 66 11 80 	movl   $0x80116680,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f4d:	66 a3 c0 68 11 80    	mov    %ax,0x801168c0
80105f53:	c1 e8 10             	shr    $0x10,%eax
80105f56:	66 a3 c6 68 11 80    	mov    %ax,0x801168c6
  SETGATE(idt[T_USER_INT], 1, SEG_KCODE<<3, vectors[T_USER_INT], DPL_USER);
80105f5c:	a1 14 b2 10 80       	mov    0x8010b214,%eax
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f61:	66 89 15 c2 68 11 80 	mov    %dx,0x801168c2
80105f68:	c6 05 c4 68 11 80 00 	movb   $0x0,0x801168c4
80105f6f:	c6 05 c5 68 11 80 ef 	movb   $0xef,0x801168c5
  SETGATE(idt[T_USER_INT], 1, SEG_KCODE<<3, vectors[T_USER_INT], DPL_USER);
80105f76:	66 a3 c0 6a 11 80    	mov    %ax,0x80116ac0
80105f7c:	c1 e8 10             	shr    $0x10,%eax
80105f7f:	66 89 0d c2 6a 11 80 	mov    %cx,0x80116ac2
80105f86:	c6 05 c4 6a 11 80 00 	movb   $0x0,0x80116ac4
80105f8d:	c6 05 c5 6a 11 80 ef 	movb   $0xef,0x80116ac5
80105f94:	66 a3 c6 6a 11 80    	mov    %ax,0x80116ac6

  initlock(&tickslock, "time");
80105f9a:	e8 91 eb ff ff       	call   80104b30 <initlock>
}
80105f9f:	c9                   	leave  
80105fa0:	c3                   	ret    
80105fa1:	eb 0d                	jmp    80105fb0 <idtinit>
80105fa3:	90                   	nop
80105fa4:	90                   	nop
80105fa5:	90                   	nop
80105fa6:	90                   	nop
80105fa7:	90                   	nop
80105fa8:	90                   	nop
80105fa9:	90                   	nop
80105faa:	90                   	nop
80105fab:	90                   	nop
80105fac:	90                   	nop
80105fad:	90                   	nop
80105fae:	90                   	nop
80105faf:	90                   	nop

80105fb0 <idtinit>:

void
idtinit(void)
{
80105fb0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105fb1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105fb6:	89 e5                	mov    %esp,%ebp
80105fb8:	83 ec 10             	sub    $0x10,%esp
80105fbb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105fbf:	b8 c0 66 11 80       	mov    $0x801166c0,%eax
80105fc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fc8:	c1 e8 10             	shr    $0x10,%eax
80105fcb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105fcf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fd2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105fd5:	c9                   	leave  
80105fd6:	c3                   	ret    
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fe0 <trap>:
  * } */

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	57                   	push   %edi
80105fe4:	56                   	push   %esi
80105fe5:	53                   	push   %ebx
80105fe6:	83 ec 2c             	sub    $0x2c,%esp
80105fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105fec:	8b 43 30             	mov    0x30(%ebx),%eax
80105fef:	83 f8 40             	cmp    $0x40,%eax
80105ff2:	74 1c                	je     80106010 <trap+0x30>
    if(proc->killed)
      exit();
    return;
  }

  if(tf->trapno == T_USER_INT){
80105ff4:	3d 80 00 00 00       	cmp    $0x80,%eax
80105ff9:	74 45                	je     80106040 <trap+0x60>
      cprintf("user interrupt 128 called!\n");
      exit();
    return;
  }

  switch(tf->trapno){
80105ffb:	83 e8 20             	sub    $0x20,%eax
80105ffe:	83 f8 1f             	cmp    $0x1f,%eax
80106001:	0f 87 49 01 00 00    	ja     80106150 <trap+0x170>
80106007:	ff 24 85 80 81 10 80 	jmp    *-0x7fef7e80(,%eax,4)
8010600e:	66 90                	xchg   %ax,%ax
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80106010:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106016:	8b 50 24             	mov    0x24(%eax),%edx
80106019:	85 d2                	test   %edx,%edx
8010601b:	0f 85 1f 01 00 00    	jne    80106140 <trap+0x160>
      exit();
    proc->tf = tf;
80106021:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106024:	e8 e7 f0 ff ff       	call   80105110 <syscall>
    if(proc->killed)
80106029:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010602f:	8b 78 24             	mov    0x24(%eax),%edi
80106032:	85 ff                	test   %edi,%edi
80106034:	75 16                	jne    8010604c <trap+0x6c>
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106036:	83 c4 2c             	add    $0x2c,%esp
80106039:	5b                   	pop    %ebx
8010603a:	5e                   	pop    %esi
8010603b:	5f                   	pop    %edi
8010603c:	5d                   	pop    %ebp
8010603d:	c3                   	ret    
8010603e:	66 90                	xchg   %ax,%ax
      exit();
    return;
  }

  if(tf->trapno == T_USER_INT){
      cprintf("user interrupt 128 called!\n");
80106040:	c7 04 24 c2 80 10 80 	movl   $0x801080c2,(%esp)
80106047:	e8 04 a6 ff ff       	call   80100650 <cprintf>
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010604c:	83 c4 2c             	add    $0x2c,%esp
8010604f:	5b                   	pop    %ebx
80106050:	5e                   	pop    %esi
80106051:	5f                   	pop    %edi
80106052:	5d                   	pop    %ebp
    return;
  }

  if(tf->trapno == T_USER_INT){
      cprintf("user interrupt 128 called!\n");
      exit();
80106053:	e9 f8 e0 ff ff       	jmp    80104150 <exit>
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80106058:	e8 43 c7 ff ff       	call   801027a0 <cpunum>
8010605d:	85 c0                	test   %eax,%eax
8010605f:	0f 84 fb 01 00 00    	je     80106260 <trap+0x280>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80106065:	e8 d6 c7 ff ff       	call   80102840 <lapiceoi>
8010606a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106070:	85 c0                	test   %eax,%eax
80106072:	74 0b                	je     8010607f <trap+0x9f>
80106074:	8b 48 24             	mov    0x24(%eax),%ecx
80106077:	85 c9                	test   %ecx,%ecx
80106079:	0f 85 3d 01 00 00    	jne    801061bc <trap+0x1dc>
  // If interrupts were on while locks held, would need to check nlock.



  // Design Document 1-1-2-5. Priority boost
  if(get_MLFQ_tick_used() >= 100){
8010607f:	e8 3c d9 ff ff       	call   801039c0 <get_MLFQ_tick_used>
80106084:	83 f8 63             	cmp    $0x63,%eax
80106087:	0f 8f 4b 01 00 00    	jg     801061d8 <trap+0x1f8>
#endif
    priority_boost();
  }


  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
8010608d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106093:	85 c0                	test   %eax,%eax
80106095:	74 9f                	je     80106036 <trap+0x56>
80106097:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010609b:	0f 84 4f 01 00 00    	je     801061f0 <trap+0x210>
      yield();
    }
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801060a1:	8b 40 24             	mov    0x24(%eax),%eax
801060a4:	85 c0                	test   %eax,%eax
801060a6:	74 8e                	je     80106036 <trap+0x56>
801060a8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801060ac:	83 e0 03             	and    $0x3,%eax
801060af:	66 83 f8 03          	cmp    $0x3,%ax
801060b3:	74 97                	je     8010604c <trap+0x6c>
    exit();
}
801060b5:	83 c4 2c             	add    $0x2c,%esp
801060b8:	5b                   	pop    %ebx
801060b9:	5e                   	pop    %esi
801060ba:	5f                   	pop    %edi
801060bb:	5d                   	pop    %ebp
801060bc:	c3                   	ret    
801060bd:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801060c0:	e8 4b c5 ff ff       	call   80102610 <kbdintr>
    lapiceoi();
801060c5:	e8 76 c7 ff ff       	call   80102840 <lapiceoi>
801060ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
801060d0:	eb 9e                	jmp    80106070 <trap+0x90>
801060d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801060d8:	e8 33 03 00 00       	call   80106410 <uartintr>
    lapiceoi();
801060dd:	e8 5e c7 ff ff       	call   80102840 <lapiceoi>
801060e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
801060e8:	eb 86                	jmp    80106070 <trap+0x90>
801060ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060f0:	8b 7b 38             	mov    0x38(%ebx),%edi
801060f3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801060f7:	e8 a4 c6 ff ff       	call   801027a0 <cpunum>
801060fc:	c7 04 24 e4 80 10 80 	movl   $0x801080e4,(%esp)
80106103:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106107:	89 74 24 08          	mov    %esi,0x8(%esp)
8010610b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010610f:	e8 3c a5 ff ff       	call   80100650 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80106114:	e8 27 c7 ff ff       	call   80102840 <lapiceoi>
80106119:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
8010611f:	e9 4c ff ff ff       	jmp    80106070 <trap+0x90>
80106124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106128:	e8 93 bf ff ff       	call   801020c0 <ideintr>
    lapiceoi();
8010612d:	e8 0e c7 ff ff       	call   80102840 <lapiceoi>
80106132:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80106138:	e9 33 ff ff ff       	jmp    80106070 <trap+0x90>
8010613d:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80106140:	e8 0b e0 ff ff       	call   80104150 <exit>
80106145:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010614b:	e9 d1 fe ff ff       	jmp    80106021 <trap+0x41>
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106150:	65 8b 35 04 00 00 00 	mov    %gs:0x4,%esi
80106157:	85 f6                	test   %esi,%esi
80106159:	0f 84 46 01 00 00    	je     801062a5 <trap+0x2c5>
8010615f:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106163:	0f 84 3c 01 00 00    	je     801062a5 <trap+0x2c5>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106169:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010616c:	8b 73 38             	mov    0x38(%ebx),%esi
8010616f:	e8 2c c6 ff ff       	call   801027a0 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80106174:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010617b:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
8010617f:	89 74 24 18          	mov    %esi,0x18(%esp)
80106183:	89 44 24 14          	mov    %eax,0x14(%esp)
80106187:	8b 43 34             	mov    0x34(%ebx),%eax
8010618a:	89 44 24 10          	mov    %eax,0x10(%esp)
8010618e:	8b 43 30             	mov    0x30(%ebx),%eax
80106191:	89 44 24 0c          	mov    %eax,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80106195:	8d 42 6c             	lea    0x6c(%edx),%eax
80106198:	89 44 24 08          	mov    %eax,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010619c:	8b 42 10             	mov    0x10(%edx),%eax
8010619f:	c7 04 24 3c 81 10 80 	movl   $0x8010813c,(%esp)
801061a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801061aa:	e8 a1 a4 ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
801061af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061b5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801061bc:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801061c0:	83 e0 03             	and    $0x3,%eax
801061c3:	66 83 f8 03          	cmp    $0x3,%ax
801061c7:	0f 85 b2 fe ff ff    	jne    8010607f <trap+0x9f>
    exit();
801061cd:	e8 7e df ff ff       	call   80104150 <exit>
801061d2:	e9 a8 fe ff ff       	jmp    8010607f <trap+0x9f>
801061d7:	90                   	nop
801061d8:	90                   	nop
801061d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  // Design Document 1-1-2-5. Priority boost
  if(get_MLFQ_tick_used() >= 100){
#ifdef MJ_DEBUGGING
    cprintf("\n\n*** Priority Boost ***\n\n");
#endif
    priority_boost();
801061e0:	e8 cb e5 ff ff       	call   801047b0 <priority_boost>
801061e5:	e9 a3 fe ff ff       	jmp    8010608d <trap+0xad>
801061ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }


  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
801061f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801061f4:	0f 85 a7 fe ff ff    	jne    801060a1 <trap+0xc1>
    // Design Document 1-1-2-2.
    proc->tick_used++;
    proc->time_quantum_used++;

    if(proc->cpu_share == 0){
801061fa:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
  }


  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
    // Design Document 1-1-2-2.
    proc->tick_used++;
80106200:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
    proc->time_quantum_used++;
80106204:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)

    if(proc->cpu_share == 0){
8010620b:	85 d2                	test   %edx,%edx
8010620d:	0f 85 7d 00 00 00    	jne    80106290 <trap+0x2b0>
      increase_MLFQ_tick_used();
80106213:	e8 b8 d7 ff ff       	call   801039d0 <increase_MLFQ_tick_used>
          tick_used: %d\n\
          time_quantum_used: %d\n",proc->pid, tf->trapno, ticks,get_MLFQ_tick_used() ,proc->tick_used, proc->time_quantum_used);
#endif

    // yield if it uses whole time quantum
    if(proc->time_quantum_used >= get_time_quantum()){
80106218:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010621e:	8b b0 80 00 00 00    	mov    0x80(%eax),%esi
80106224:	e8 67 d7 ff ff       	call   80103990 <get_time_quantum>
80106229:	39 c6                	cmp    %eax,%esi
8010622b:	7c 20                	jl     8010624d <trap+0x26d>
      cprintf("**********************************\n");
#endif
      

      // Design Document 1-1-2-5. Moving a process to the lower level
      if(proc->level_of_MLFQ < NMLFQ - 1){
8010622d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106233:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80106239:	83 fa 01             	cmp    $0x1,%edx
8010623c:	7e 5c                	jle    8010629a <trap+0x2ba>
        proc->level_of_MLFQ++;
      }

      // Design Document 1-1-2-2
      proc->time_quantum_used = 0;
8010623e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80106245:	00 00 00 
      yield();
80106248:	e8 53 e1 ff ff       	call   801043a0 <yield>
    }
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010624d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106253:	85 c0                	test   %eax,%eax
80106255:	0f 85 46 fe ff ff    	jne    801060a1 <trap+0xc1>
8010625b:	e9 d6 fd ff ff       	jmp    80106036 <trap+0x56>
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80106260:	c7 04 24 80 66 11 80 	movl   $0x80116680,(%esp)
80106267:	e8 44 e9 ff ff       	call   80104bb0 <acquire>
      ticks++;
      wakeup(&ticks);
8010626c:	c7 04 24 c0 6e 11 80 	movl   $0x80116ec0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80106273:	83 05 c0 6e 11 80 01 	addl   $0x1,0x80116ec0
      wakeup(&ticks);
8010627a:	e8 71 e3 ff ff       	call   801045f0 <wakeup>
      release(&tickslock);
8010627f:	c7 04 24 80 66 11 80 	movl   $0x80116680,(%esp)
80106286:	e8 55 ea ff ff       	call   80104ce0 <release>
8010628b:	e9 d5 fd ff ff       	jmp    80106065 <trap+0x85>
    proc->time_quantum_used++;

    if(proc->cpu_share == 0){
      increase_MLFQ_tick_used();
    }else{
      increase_stride_tick_used();
80106290:	e8 4b d7 ff ff       	call   801039e0 <increase_stride_tick_used>
80106295:	e9 7e ff ff ff       	jmp    80106218 <trap+0x238>
#endif
      

      // Design Document 1-1-2-5. Moving a process to the lower level
      if(proc->level_of_MLFQ < NMLFQ - 1){
        proc->level_of_MLFQ++;
8010629a:	83 c2 01             	add    $0x1,%edx
8010629d:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
801062a3:	eb 99                	jmp    8010623e <trap+0x25e>
801062a5:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062a8:	8b 73 38             	mov    0x38(%ebx),%esi
801062ab:	e8 f0 c4 ff ff       	call   801027a0 <cpunum>
801062b0:	89 7c 24 10          	mov    %edi,0x10(%esp)
801062b4:	89 74 24 0c          	mov    %esi,0xc(%esp)
801062b8:	89 44 24 08          	mov    %eax,0x8(%esp)
801062bc:	8b 43 30             	mov    0x30(%ebx),%eax
801062bf:	c7 04 24 08 81 10 80 	movl   $0x80108108,(%esp)
801062c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801062ca:	e8 81 a3 ff ff       	call   80100650 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
801062cf:	c7 04 24 de 80 10 80 	movl   $0x801080de,(%esp)
801062d6:	e8 85 a0 ff ff       	call   80100360 <panic>
801062db:	66 90                	xchg   %ax,%ax
801062dd:	66 90                	xchg   %ax,%ax
801062df:	90                   	nop

801062e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801062e0:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801062e5:	55                   	push   %ebp
801062e6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801062e8:	85 c0                	test   %eax,%eax
801062ea:	74 14                	je     80106300 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062ec:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062f1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801062f2:	a8 01                	test   $0x1,%al
801062f4:	74 0a                	je     80106300 <uartgetc+0x20>
801062f6:	b2 f8                	mov    $0xf8,%dl
801062f8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801062f9:	0f b6 c0             	movzbl %al,%eax
}
801062fc:	5d                   	pop    %ebp
801062fd:	c3                   	ret    
801062fe:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80106305:	5d                   	pop    %ebp
80106306:	c3                   	ret    
80106307:	89 f6                	mov    %esi,%esi
80106309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106310 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106310:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
80106315:	85 c0                	test   %eax,%eax
80106317:	74 3f                	je     80106358 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80106319:	55                   	push   %ebp
8010631a:	89 e5                	mov    %esp,%ebp
8010631c:	56                   	push   %esi
8010631d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106322:	53                   	push   %ebx
  int i;

  if(!uart)
80106323:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80106328:	83 ec 10             	sub    $0x10,%esp
8010632b:	eb 14                	jmp    80106341 <uartputc+0x31>
8010632d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106330:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106337:	e8 24 c5 ff ff       	call   80102860 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010633c:	83 eb 01             	sub    $0x1,%ebx
8010633f:	74 07                	je     80106348 <uartputc+0x38>
80106341:	89 f2                	mov    %esi,%edx
80106343:	ec                   	in     (%dx),%al
80106344:	a8 20                	test   $0x20,%al
80106346:	74 e8                	je     80106330 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80106348:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010634c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106351:	ee                   	out    %al,(%dx)
}
80106352:	83 c4 10             	add    $0x10,%esp
80106355:	5b                   	pop    %ebx
80106356:	5e                   	pop    %esi
80106357:	5d                   	pop    %ebp
80106358:	f3 c3                	repz ret 
8010635a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106360 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106360:	55                   	push   %ebp
80106361:	31 c9                	xor    %ecx,%ecx
80106363:	89 e5                	mov    %esp,%ebp
80106365:	89 c8                	mov    %ecx,%eax
80106367:	57                   	push   %edi
80106368:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010636d:	56                   	push   %esi
8010636e:	89 fa                	mov    %edi,%edx
80106370:	53                   	push   %ebx
80106371:	83 ec 1c             	sub    $0x1c,%esp
80106374:	ee                   	out    %al,(%dx)
80106375:	be fb 03 00 00       	mov    $0x3fb,%esi
8010637a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010637f:	89 f2                	mov    %esi,%edx
80106381:	ee                   	out    %al,(%dx)
80106382:	b8 0c 00 00 00       	mov    $0xc,%eax
80106387:	b2 f8                	mov    $0xf8,%dl
80106389:	ee                   	out    %al,(%dx)
8010638a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010638f:	89 c8                	mov    %ecx,%eax
80106391:	89 da                	mov    %ebx,%edx
80106393:	ee                   	out    %al,(%dx)
80106394:	b8 03 00 00 00       	mov    $0x3,%eax
80106399:	89 f2                	mov    %esi,%edx
8010639b:	ee                   	out    %al,(%dx)
8010639c:	b2 fc                	mov    $0xfc,%dl
8010639e:	89 c8                	mov    %ecx,%eax
801063a0:	ee                   	out    %al,(%dx)
801063a1:	b8 01 00 00 00       	mov    $0x1,%eax
801063a6:	89 da                	mov    %ebx,%edx
801063a8:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063a9:	b2 fd                	mov    $0xfd,%dl
801063ab:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801063ac:	3c ff                	cmp    $0xff,%al
801063ae:	74 52                	je     80106402 <uartinit+0xa2>
    return;
  uart = 1;
801063b0:	c7 05 c4 b5 10 80 01 	movl   $0x1,0x8010b5c4
801063b7:	00 00 00 
801063ba:	89 fa                	mov    %edi,%edx
801063bc:	ec                   	in     (%dx),%al
801063bd:	b2 f8                	mov    $0xf8,%dl
801063bf:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
801063c0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801063c7:	bb 00 82 10 80       	mov    $0x80108200,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
801063cc:	e8 6f ce ff ff       	call   80103240 <picenable>
  ioapicenable(IRQ_COM1, 0);
801063d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801063d8:	00 
801063d9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801063e0:	e8 0b bf ff ff       	call   801022f0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801063e5:	b8 78 00 00 00       	mov    $0x78,%eax
801063ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc(*p);
801063f0:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801063f3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
801063f6:	e8 15 ff ff ff       	call   80106310 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801063fb:	0f be 03             	movsbl (%ebx),%eax
801063fe:	84 c0                	test   %al,%al
80106400:	75 ee                	jne    801063f0 <uartinit+0x90>
    uartputc(*p);
}
80106402:	83 c4 1c             	add    $0x1c,%esp
80106405:	5b                   	pop    %ebx
80106406:	5e                   	pop    %esi
80106407:	5f                   	pop    %edi
80106408:	5d                   	pop    %ebp
80106409:	c3                   	ret    
8010640a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106410 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106416:	c7 04 24 e0 62 10 80 	movl   $0x801062e0,(%esp)
8010641d:	e8 8e a3 ff ff       	call   801007b0 <consoleintr>
}
80106422:	c9                   	leave  
80106423:	c3                   	ret    

80106424 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $0
80106426:	6a 00                	push   $0x0
  jmp alltraps
80106428:	e9 80 fa ff ff       	jmp    80105ead <alltraps>

8010642d <vector1>:
.globl vector1
vector1:
  pushl $0
8010642d:	6a 00                	push   $0x0
  pushl $1
8010642f:	6a 01                	push   $0x1
  jmp alltraps
80106431:	e9 77 fa ff ff       	jmp    80105ead <alltraps>

80106436 <vector2>:
.globl vector2
vector2:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $2
80106438:	6a 02                	push   $0x2
  jmp alltraps
8010643a:	e9 6e fa ff ff       	jmp    80105ead <alltraps>

8010643f <vector3>:
.globl vector3
vector3:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $3
80106441:	6a 03                	push   $0x3
  jmp alltraps
80106443:	e9 65 fa ff ff       	jmp    80105ead <alltraps>

80106448 <vector4>:
.globl vector4
vector4:
  pushl $0
80106448:	6a 00                	push   $0x0
  pushl $4
8010644a:	6a 04                	push   $0x4
  jmp alltraps
8010644c:	e9 5c fa ff ff       	jmp    80105ead <alltraps>

80106451 <vector5>:
.globl vector5
vector5:
  pushl $0
80106451:	6a 00                	push   $0x0
  pushl $5
80106453:	6a 05                	push   $0x5
  jmp alltraps
80106455:	e9 53 fa ff ff       	jmp    80105ead <alltraps>

8010645a <vector6>:
.globl vector6
vector6:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $6
8010645c:	6a 06                	push   $0x6
  jmp alltraps
8010645e:	e9 4a fa ff ff       	jmp    80105ead <alltraps>

80106463 <vector7>:
.globl vector7
vector7:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $7
80106465:	6a 07                	push   $0x7
  jmp alltraps
80106467:	e9 41 fa ff ff       	jmp    80105ead <alltraps>

8010646c <vector8>:
.globl vector8
vector8:
  pushl $8
8010646c:	6a 08                	push   $0x8
  jmp alltraps
8010646e:	e9 3a fa ff ff       	jmp    80105ead <alltraps>

80106473 <vector9>:
.globl vector9
vector9:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $9
80106475:	6a 09                	push   $0x9
  jmp alltraps
80106477:	e9 31 fa ff ff       	jmp    80105ead <alltraps>

8010647c <vector10>:
.globl vector10
vector10:
  pushl $10
8010647c:	6a 0a                	push   $0xa
  jmp alltraps
8010647e:	e9 2a fa ff ff       	jmp    80105ead <alltraps>

80106483 <vector11>:
.globl vector11
vector11:
  pushl $11
80106483:	6a 0b                	push   $0xb
  jmp alltraps
80106485:	e9 23 fa ff ff       	jmp    80105ead <alltraps>

8010648a <vector12>:
.globl vector12
vector12:
  pushl $12
8010648a:	6a 0c                	push   $0xc
  jmp alltraps
8010648c:	e9 1c fa ff ff       	jmp    80105ead <alltraps>

80106491 <vector13>:
.globl vector13
vector13:
  pushl $13
80106491:	6a 0d                	push   $0xd
  jmp alltraps
80106493:	e9 15 fa ff ff       	jmp    80105ead <alltraps>

80106498 <vector14>:
.globl vector14
vector14:
  pushl $14
80106498:	6a 0e                	push   $0xe
  jmp alltraps
8010649a:	e9 0e fa ff ff       	jmp    80105ead <alltraps>

8010649f <vector15>:
.globl vector15
vector15:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $15
801064a1:	6a 0f                	push   $0xf
  jmp alltraps
801064a3:	e9 05 fa ff ff       	jmp    80105ead <alltraps>

801064a8 <vector16>:
.globl vector16
vector16:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $16
801064aa:	6a 10                	push   $0x10
  jmp alltraps
801064ac:	e9 fc f9 ff ff       	jmp    80105ead <alltraps>

801064b1 <vector17>:
.globl vector17
vector17:
  pushl $17
801064b1:	6a 11                	push   $0x11
  jmp alltraps
801064b3:	e9 f5 f9 ff ff       	jmp    80105ead <alltraps>

801064b8 <vector18>:
.globl vector18
vector18:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $18
801064ba:	6a 12                	push   $0x12
  jmp alltraps
801064bc:	e9 ec f9 ff ff       	jmp    80105ead <alltraps>

801064c1 <vector19>:
.globl vector19
vector19:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $19
801064c3:	6a 13                	push   $0x13
  jmp alltraps
801064c5:	e9 e3 f9 ff ff       	jmp    80105ead <alltraps>

801064ca <vector20>:
.globl vector20
vector20:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $20
801064cc:	6a 14                	push   $0x14
  jmp alltraps
801064ce:	e9 da f9 ff ff       	jmp    80105ead <alltraps>

801064d3 <vector21>:
.globl vector21
vector21:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $21
801064d5:	6a 15                	push   $0x15
  jmp alltraps
801064d7:	e9 d1 f9 ff ff       	jmp    80105ead <alltraps>

801064dc <vector22>:
.globl vector22
vector22:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $22
801064de:	6a 16                	push   $0x16
  jmp alltraps
801064e0:	e9 c8 f9 ff ff       	jmp    80105ead <alltraps>

801064e5 <vector23>:
.globl vector23
vector23:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $23
801064e7:	6a 17                	push   $0x17
  jmp alltraps
801064e9:	e9 bf f9 ff ff       	jmp    80105ead <alltraps>

801064ee <vector24>:
.globl vector24
vector24:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $24
801064f0:	6a 18                	push   $0x18
  jmp alltraps
801064f2:	e9 b6 f9 ff ff       	jmp    80105ead <alltraps>

801064f7 <vector25>:
.globl vector25
vector25:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $25
801064f9:	6a 19                	push   $0x19
  jmp alltraps
801064fb:	e9 ad f9 ff ff       	jmp    80105ead <alltraps>

80106500 <vector26>:
.globl vector26
vector26:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $26
80106502:	6a 1a                	push   $0x1a
  jmp alltraps
80106504:	e9 a4 f9 ff ff       	jmp    80105ead <alltraps>

80106509 <vector27>:
.globl vector27
vector27:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $27
8010650b:	6a 1b                	push   $0x1b
  jmp alltraps
8010650d:	e9 9b f9 ff ff       	jmp    80105ead <alltraps>

80106512 <vector28>:
.globl vector28
vector28:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $28
80106514:	6a 1c                	push   $0x1c
  jmp alltraps
80106516:	e9 92 f9 ff ff       	jmp    80105ead <alltraps>

8010651b <vector29>:
.globl vector29
vector29:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $29
8010651d:	6a 1d                	push   $0x1d
  jmp alltraps
8010651f:	e9 89 f9 ff ff       	jmp    80105ead <alltraps>

80106524 <vector30>:
.globl vector30
vector30:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $30
80106526:	6a 1e                	push   $0x1e
  jmp alltraps
80106528:	e9 80 f9 ff ff       	jmp    80105ead <alltraps>

8010652d <vector31>:
.globl vector31
vector31:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $31
8010652f:	6a 1f                	push   $0x1f
  jmp alltraps
80106531:	e9 77 f9 ff ff       	jmp    80105ead <alltraps>

80106536 <vector32>:
.globl vector32
vector32:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $32
80106538:	6a 20                	push   $0x20
  jmp alltraps
8010653a:	e9 6e f9 ff ff       	jmp    80105ead <alltraps>

8010653f <vector33>:
.globl vector33
vector33:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $33
80106541:	6a 21                	push   $0x21
  jmp alltraps
80106543:	e9 65 f9 ff ff       	jmp    80105ead <alltraps>

80106548 <vector34>:
.globl vector34
vector34:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $34
8010654a:	6a 22                	push   $0x22
  jmp alltraps
8010654c:	e9 5c f9 ff ff       	jmp    80105ead <alltraps>

80106551 <vector35>:
.globl vector35
vector35:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $35
80106553:	6a 23                	push   $0x23
  jmp alltraps
80106555:	e9 53 f9 ff ff       	jmp    80105ead <alltraps>

8010655a <vector36>:
.globl vector36
vector36:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $36
8010655c:	6a 24                	push   $0x24
  jmp alltraps
8010655e:	e9 4a f9 ff ff       	jmp    80105ead <alltraps>

80106563 <vector37>:
.globl vector37
vector37:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $37
80106565:	6a 25                	push   $0x25
  jmp alltraps
80106567:	e9 41 f9 ff ff       	jmp    80105ead <alltraps>

8010656c <vector38>:
.globl vector38
vector38:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $38
8010656e:	6a 26                	push   $0x26
  jmp alltraps
80106570:	e9 38 f9 ff ff       	jmp    80105ead <alltraps>

80106575 <vector39>:
.globl vector39
vector39:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $39
80106577:	6a 27                	push   $0x27
  jmp alltraps
80106579:	e9 2f f9 ff ff       	jmp    80105ead <alltraps>

8010657e <vector40>:
.globl vector40
vector40:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $40
80106580:	6a 28                	push   $0x28
  jmp alltraps
80106582:	e9 26 f9 ff ff       	jmp    80105ead <alltraps>

80106587 <vector41>:
.globl vector41
vector41:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $41
80106589:	6a 29                	push   $0x29
  jmp alltraps
8010658b:	e9 1d f9 ff ff       	jmp    80105ead <alltraps>

80106590 <vector42>:
.globl vector42
vector42:
  pushl $0
80106590:	6a 00                	push   $0x0
  pushl $42
80106592:	6a 2a                	push   $0x2a
  jmp alltraps
80106594:	e9 14 f9 ff ff       	jmp    80105ead <alltraps>

80106599 <vector43>:
.globl vector43
vector43:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $43
8010659b:	6a 2b                	push   $0x2b
  jmp alltraps
8010659d:	e9 0b f9 ff ff       	jmp    80105ead <alltraps>

801065a2 <vector44>:
.globl vector44
vector44:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $44
801065a4:	6a 2c                	push   $0x2c
  jmp alltraps
801065a6:	e9 02 f9 ff ff       	jmp    80105ead <alltraps>

801065ab <vector45>:
.globl vector45
vector45:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $45
801065ad:	6a 2d                	push   $0x2d
  jmp alltraps
801065af:	e9 f9 f8 ff ff       	jmp    80105ead <alltraps>

801065b4 <vector46>:
.globl vector46
vector46:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $46
801065b6:	6a 2e                	push   $0x2e
  jmp alltraps
801065b8:	e9 f0 f8 ff ff       	jmp    80105ead <alltraps>

801065bd <vector47>:
.globl vector47
vector47:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $47
801065bf:	6a 2f                	push   $0x2f
  jmp alltraps
801065c1:	e9 e7 f8 ff ff       	jmp    80105ead <alltraps>

801065c6 <vector48>:
.globl vector48
vector48:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $48
801065c8:	6a 30                	push   $0x30
  jmp alltraps
801065ca:	e9 de f8 ff ff       	jmp    80105ead <alltraps>

801065cf <vector49>:
.globl vector49
vector49:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $49
801065d1:	6a 31                	push   $0x31
  jmp alltraps
801065d3:	e9 d5 f8 ff ff       	jmp    80105ead <alltraps>

801065d8 <vector50>:
.globl vector50
vector50:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $50
801065da:	6a 32                	push   $0x32
  jmp alltraps
801065dc:	e9 cc f8 ff ff       	jmp    80105ead <alltraps>

801065e1 <vector51>:
.globl vector51
vector51:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $51
801065e3:	6a 33                	push   $0x33
  jmp alltraps
801065e5:	e9 c3 f8 ff ff       	jmp    80105ead <alltraps>

801065ea <vector52>:
.globl vector52
vector52:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $52
801065ec:	6a 34                	push   $0x34
  jmp alltraps
801065ee:	e9 ba f8 ff ff       	jmp    80105ead <alltraps>

801065f3 <vector53>:
.globl vector53
vector53:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $53
801065f5:	6a 35                	push   $0x35
  jmp alltraps
801065f7:	e9 b1 f8 ff ff       	jmp    80105ead <alltraps>

801065fc <vector54>:
.globl vector54
vector54:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $54
801065fe:	6a 36                	push   $0x36
  jmp alltraps
80106600:	e9 a8 f8 ff ff       	jmp    80105ead <alltraps>

80106605 <vector55>:
.globl vector55
vector55:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $55
80106607:	6a 37                	push   $0x37
  jmp alltraps
80106609:	e9 9f f8 ff ff       	jmp    80105ead <alltraps>

8010660e <vector56>:
.globl vector56
vector56:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $56
80106610:	6a 38                	push   $0x38
  jmp alltraps
80106612:	e9 96 f8 ff ff       	jmp    80105ead <alltraps>

80106617 <vector57>:
.globl vector57
vector57:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $57
80106619:	6a 39                	push   $0x39
  jmp alltraps
8010661b:	e9 8d f8 ff ff       	jmp    80105ead <alltraps>

80106620 <vector58>:
.globl vector58
vector58:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $58
80106622:	6a 3a                	push   $0x3a
  jmp alltraps
80106624:	e9 84 f8 ff ff       	jmp    80105ead <alltraps>

80106629 <vector59>:
.globl vector59
vector59:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $59
8010662b:	6a 3b                	push   $0x3b
  jmp alltraps
8010662d:	e9 7b f8 ff ff       	jmp    80105ead <alltraps>

80106632 <vector60>:
.globl vector60
vector60:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $60
80106634:	6a 3c                	push   $0x3c
  jmp alltraps
80106636:	e9 72 f8 ff ff       	jmp    80105ead <alltraps>

8010663b <vector61>:
.globl vector61
vector61:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $61
8010663d:	6a 3d                	push   $0x3d
  jmp alltraps
8010663f:	e9 69 f8 ff ff       	jmp    80105ead <alltraps>

80106644 <vector62>:
.globl vector62
vector62:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $62
80106646:	6a 3e                	push   $0x3e
  jmp alltraps
80106648:	e9 60 f8 ff ff       	jmp    80105ead <alltraps>

8010664d <vector63>:
.globl vector63
vector63:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $63
8010664f:	6a 3f                	push   $0x3f
  jmp alltraps
80106651:	e9 57 f8 ff ff       	jmp    80105ead <alltraps>

80106656 <vector64>:
.globl vector64
vector64:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $64
80106658:	6a 40                	push   $0x40
  jmp alltraps
8010665a:	e9 4e f8 ff ff       	jmp    80105ead <alltraps>

8010665f <vector65>:
.globl vector65
vector65:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $65
80106661:	6a 41                	push   $0x41
  jmp alltraps
80106663:	e9 45 f8 ff ff       	jmp    80105ead <alltraps>

80106668 <vector66>:
.globl vector66
vector66:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $66
8010666a:	6a 42                	push   $0x42
  jmp alltraps
8010666c:	e9 3c f8 ff ff       	jmp    80105ead <alltraps>

80106671 <vector67>:
.globl vector67
vector67:
  pushl $0
80106671:	6a 00                	push   $0x0
  pushl $67
80106673:	6a 43                	push   $0x43
  jmp alltraps
80106675:	e9 33 f8 ff ff       	jmp    80105ead <alltraps>

8010667a <vector68>:
.globl vector68
vector68:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $68
8010667c:	6a 44                	push   $0x44
  jmp alltraps
8010667e:	e9 2a f8 ff ff       	jmp    80105ead <alltraps>

80106683 <vector69>:
.globl vector69
vector69:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $69
80106685:	6a 45                	push   $0x45
  jmp alltraps
80106687:	e9 21 f8 ff ff       	jmp    80105ead <alltraps>

8010668c <vector70>:
.globl vector70
vector70:
  pushl $0
8010668c:	6a 00                	push   $0x0
  pushl $70
8010668e:	6a 46                	push   $0x46
  jmp alltraps
80106690:	e9 18 f8 ff ff       	jmp    80105ead <alltraps>

80106695 <vector71>:
.globl vector71
vector71:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $71
80106697:	6a 47                	push   $0x47
  jmp alltraps
80106699:	e9 0f f8 ff ff       	jmp    80105ead <alltraps>

8010669e <vector72>:
.globl vector72
vector72:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $72
801066a0:	6a 48                	push   $0x48
  jmp alltraps
801066a2:	e9 06 f8 ff ff       	jmp    80105ead <alltraps>

801066a7 <vector73>:
.globl vector73
vector73:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $73
801066a9:	6a 49                	push   $0x49
  jmp alltraps
801066ab:	e9 fd f7 ff ff       	jmp    80105ead <alltraps>

801066b0 <vector74>:
.globl vector74
vector74:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $74
801066b2:	6a 4a                	push   $0x4a
  jmp alltraps
801066b4:	e9 f4 f7 ff ff       	jmp    80105ead <alltraps>

801066b9 <vector75>:
.globl vector75
vector75:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $75
801066bb:	6a 4b                	push   $0x4b
  jmp alltraps
801066bd:	e9 eb f7 ff ff       	jmp    80105ead <alltraps>

801066c2 <vector76>:
.globl vector76
vector76:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $76
801066c4:	6a 4c                	push   $0x4c
  jmp alltraps
801066c6:	e9 e2 f7 ff ff       	jmp    80105ead <alltraps>

801066cb <vector77>:
.globl vector77
vector77:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $77
801066cd:	6a 4d                	push   $0x4d
  jmp alltraps
801066cf:	e9 d9 f7 ff ff       	jmp    80105ead <alltraps>

801066d4 <vector78>:
.globl vector78
vector78:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $78
801066d6:	6a 4e                	push   $0x4e
  jmp alltraps
801066d8:	e9 d0 f7 ff ff       	jmp    80105ead <alltraps>

801066dd <vector79>:
.globl vector79
vector79:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $79
801066df:	6a 4f                	push   $0x4f
  jmp alltraps
801066e1:	e9 c7 f7 ff ff       	jmp    80105ead <alltraps>

801066e6 <vector80>:
.globl vector80
vector80:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $80
801066e8:	6a 50                	push   $0x50
  jmp alltraps
801066ea:	e9 be f7 ff ff       	jmp    80105ead <alltraps>

801066ef <vector81>:
.globl vector81
vector81:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $81
801066f1:	6a 51                	push   $0x51
  jmp alltraps
801066f3:	e9 b5 f7 ff ff       	jmp    80105ead <alltraps>

801066f8 <vector82>:
.globl vector82
vector82:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $82
801066fa:	6a 52                	push   $0x52
  jmp alltraps
801066fc:	e9 ac f7 ff ff       	jmp    80105ead <alltraps>

80106701 <vector83>:
.globl vector83
vector83:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $83
80106703:	6a 53                	push   $0x53
  jmp alltraps
80106705:	e9 a3 f7 ff ff       	jmp    80105ead <alltraps>

8010670a <vector84>:
.globl vector84
vector84:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $84
8010670c:	6a 54                	push   $0x54
  jmp alltraps
8010670e:	e9 9a f7 ff ff       	jmp    80105ead <alltraps>

80106713 <vector85>:
.globl vector85
vector85:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $85
80106715:	6a 55                	push   $0x55
  jmp alltraps
80106717:	e9 91 f7 ff ff       	jmp    80105ead <alltraps>

8010671c <vector86>:
.globl vector86
vector86:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $86
8010671e:	6a 56                	push   $0x56
  jmp alltraps
80106720:	e9 88 f7 ff ff       	jmp    80105ead <alltraps>

80106725 <vector87>:
.globl vector87
vector87:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $87
80106727:	6a 57                	push   $0x57
  jmp alltraps
80106729:	e9 7f f7 ff ff       	jmp    80105ead <alltraps>

8010672e <vector88>:
.globl vector88
vector88:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $88
80106730:	6a 58                	push   $0x58
  jmp alltraps
80106732:	e9 76 f7 ff ff       	jmp    80105ead <alltraps>

80106737 <vector89>:
.globl vector89
vector89:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $89
80106739:	6a 59                	push   $0x59
  jmp alltraps
8010673b:	e9 6d f7 ff ff       	jmp    80105ead <alltraps>

80106740 <vector90>:
.globl vector90
vector90:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $90
80106742:	6a 5a                	push   $0x5a
  jmp alltraps
80106744:	e9 64 f7 ff ff       	jmp    80105ead <alltraps>

80106749 <vector91>:
.globl vector91
vector91:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $91
8010674b:	6a 5b                	push   $0x5b
  jmp alltraps
8010674d:	e9 5b f7 ff ff       	jmp    80105ead <alltraps>

80106752 <vector92>:
.globl vector92
vector92:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $92
80106754:	6a 5c                	push   $0x5c
  jmp alltraps
80106756:	e9 52 f7 ff ff       	jmp    80105ead <alltraps>

8010675b <vector93>:
.globl vector93
vector93:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $93
8010675d:	6a 5d                	push   $0x5d
  jmp alltraps
8010675f:	e9 49 f7 ff ff       	jmp    80105ead <alltraps>

80106764 <vector94>:
.globl vector94
vector94:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $94
80106766:	6a 5e                	push   $0x5e
  jmp alltraps
80106768:	e9 40 f7 ff ff       	jmp    80105ead <alltraps>

8010676d <vector95>:
.globl vector95
vector95:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $95
8010676f:	6a 5f                	push   $0x5f
  jmp alltraps
80106771:	e9 37 f7 ff ff       	jmp    80105ead <alltraps>

80106776 <vector96>:
.globl vector96
vector96:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $96
80106778:	6a 60                	push   $0x60
  jmp alltraps
8010677a:	e9 2e f7 ff ff       	jmp    80105ead <alltraps>

8010677f <vector97>:
.globl vector97
vector97:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $97
80106781:	6a 61                	push   $0x61
  jmp alltraps
80106783:	e9 25 f7 ff ff       	jmp    80105ead <alltraps>

80106788 <vector98>:
.globl vector98
vector98:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $98
8010678a:	6a 62                	push   $0x62
  jmp alltraps
8010678c:	e9 1c f7 ff ff       	jmp    80105ead <alltraps>

80106791 <vector99>:
.globl vector99
vector99:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $99
80106793:	6a 63                	push   $0x63
  jmp alltraps
80106795:	e9 13 f7 ff ff       	jmp    80105ead <alltraps>

8010679a <vector100>:
.globl vector100
vector100:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $100
8010679c:	6a 64                	push   $0x64
  jmp alltraps
8010679e:	e9 0a f7 ff ff       	jmp    80105ead <alltraps>

801067a3 <vector101>:
.globl vector101
vector101:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $101
801067a5:	6a 65                	push   $0x65
  jmp alltraps
801067a7:	e9 01 f7 ff ff       	jmp    80105ead <alltraps>

801067ac <vector102>:
.globl vector102
vector102:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $102
801067ae:	6a 66                	push   $0x66
  jmp alltraps
801067b0:	e9 f8 f6 ff ff       	jmp    80105ead <alltraps>

801067b5 <vector103>:
.globl vector103
vector103:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $103
801067b7:	6a 67                	push   $0x67
  jmp alltraps
801067b9:	e9 ef f6 ff ff       	jmp    80105ead <alltraps>

801067be <vector104>:
.globl vector104
vector104:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $104
801067c0:	6a 68                	push   $0x68
  jmp alltraps
801067c2:	e9 e6 f6 ff ff       	jmp    80105ead <alltraps>

801067c7 <vector105>:
.globl vector105
vector105:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $105
801067c9:	6a 69                	push   $0x69
  jmp alltraps
801067cb:	e9 dd f6 ff ff       	jmp    80105ead <alltraps>

801067d0 <vector106>:
.globl vector106
vector106:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $106
801067d2:	6a 6a                	push   $0x6a
  jmp alltraps
801067d4:	e9 d4 f6 ff ff       	jmp    80105ead <alltraps>

801067d9 <vector107>:
.globl vector107
vector107:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $107
801067db:	6a 6b                	push   $0x6b
  jmp alltraps
801067dd:	e9 cb f6 ff ff       	jmp    80105ead <alltraps>

801067e2 <vector108>:
.globl vector108
vector108:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $108
801067e4:	6a 6c                	push   $0x6c
  jmp alltraps
801067e6:	e9 c2 f6 ff ff       	jmp    80105ead <alltraps>

801067eb <vector109>:
.globl vector109
vector109:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $109
801067ed:	6a 6d                	push   $0x6d
  jmp alltraps
801067ef:	e9 b9 f6 ff ff       	jmp    80105ead <alltraps>

801067f4 <vector110>:
.globl vector110
vector110:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $110
801067f6:	6a 6e                	push   $0x6e
  jmp alltraps
801067f8:	e9 b0 f6 ff ff       	jmp    80105ead <alltraps>

801067fd <vector111>:
.globl vector111
vector111:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $111
801067ff:	6a 6f                	push   $0x6f
  jmp alltraps
80106801:	e9 a7 f6 ff ff       	jmp    80105ead <alltraps>

80106806 <vector112>:
.globl vector112
vector112:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $112
80106808:	6a 70                	push   $0x70
  jmp alltraps
8010680a:	e9 9e f6 ff ff       	jmp    80105ead <alltraps>

8010680f <vector113>:
.globl vector113
vector113:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $113
80106811:	6a 71                	push   $0x71
  jmp alltraps
80106813:	e9 95 f6 ff ff       	jmp    80105ead <alltraps>

80106818 <vector114>:
.globl vector114
vector114:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $114
8010681a:	6a 72                	push   $0x72
  jmp alltraps
8010681c:	e9 8c f6 ff ff       	jmp    80105ead <alltraps>

80106821 <vector115>:
.globl vector115
vector115:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $115
80106823:	6a 73                	push   $0x73
  jmp alltraps
80106825:	e9 83 f6 ff ff       	jmp    80105ead <alltraps>

8010682a <vector116>:
.globl vector116
vector116:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $116
8010682c:	6a 74                	push   $0x74
  jmp alltraps
8010682e:	e9 7a f6 ff ff       	jmp    80105ead <alltraps>

80106833 <vector117>:
.globl vector117
vector117:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $117
80106835:	6a 75                	push   $0x75
  jmp alltraps
80106837:	e9 71 f6 ff ff       	jmp    80105ead <alltraps>

8010683c <vector118>:
.globl vector118
vector118:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $118
8010683e:	6a 76                	push   $0x76
  jmp alltraps
80106840:	e9 68 f6 ff ff       	jmp    80105ead <alltraps>

80106845 <vector119>:
.globl vector119
vector119:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $119
80106847:	6a 77                	push   $0x77
  jmp alltraps
80106849:	e9 5f f6 ff ff       	jmp    80105ead <alltraps>

8010684e <vector120>:
.globl vector120
vector120:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $120
80106850:	6a 78                	push   $0x78
  jmp alltraps
80106852:	e9 56 f6 ff ff       	jmp    80105ead <alltraps>

80106857 <vector121>:
.globl vector121
vector121:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $121
80106859:	6a 79                	push   $0x79
  jmp alltraps
8010685b:	e9 4d f6 ff ff       	jmp    80105ead <alltraps>

80106860 <vector122>:
.globl vector122
vector122:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $122
80106862:	6a 7a                	push   $0x7a
  jmp alltraps
80106864:	e9 44 f6 ff ff       	jmp    80105ead <alltraps>

80106869 <vector123>:
.globl vector123
vector123:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $123
8010686b:	6a 7b                	push   $0x7b
  jmp alltraps
8010686d:	e9 3b f6 ff ff       	jmp    80105ead <alltraps>

80106872 <vector124>:
.globl vector124
vector124:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $124
80106874:	6a 7c                	push   $0x7c
  jmp alltraps
80106876:	e9 32 f6 ff ff       	jmp    80105ead <alltraps>

8010687b <vector125>:
.globl vector125
vector125:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $125
8010687d:	6a 7d                	push   $0x7d
  jmp alltraps
8010687f:	e9 29 f6 ff ff       	jmp    80105ead <alltraps>

80106884 <vector126>:
.globl vector126
vector126:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $126
80106886:	6a 7e                	push   $0x7e
  jmp alltraps
80106888:	e9 20 f6 ff ff       	jmp    80105ead <alltraps>

8010688d <vector127>:
.globl vector127
vector127:
  pushl $0
8010688d:	6a 00                	push   $0x0
  pushl $127
8010688f:	6a 7f                	push   $0x7f
  jmp alltraps
80106891:	e9 17 f6 ff ff       	jmp    80105ead <alltraps>

80106896 <vector128>:
.globl vector128
vector128:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $128
80106898:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010689d:	e9 0b f6 ff ff       	jmp    80105ead <alltraps>

801068a2 <vector129>:
.globl vector129
vector129:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $129
801068a4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068a9:	e9 ff f5 ff ff       	jmp    80105ead <alltraps>

801068ae <vector130>:
.globl vector130
vector130:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $130
801068b0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068b5:	e9 f3 f5 ff ff       	jmp    80105ead <alltraps>

801068ba <vector131>:
.globl vector131
vector131:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $131
801068bc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068c1:	e9 e7 f5 ff ff       	jmp    80105ead <alltraps>

801068c6 <vector132>:
.globl vector132
vector132:
  pushl $0
801068c6:	6a 00                	push   $0x0
  pushl $132
801068c8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068cd:	e9 db f5 ff ff       	jmp    80105ead <alltraps>

801068d2 <vector133>:
.globl vector133
vector133:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $133
801068d4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068d9:	e9 cf f5 ff ff       	jmp    80105ead <alltraps>

801068de <vector134>:
.globl vector134
vector134:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $134
801068e0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068e5:	e9 c3 f5 ff ff       	jmp    80105ead <alltraps>

801068ea <vector135>:
.globl vector135
vector135:
  pushl $0
801068ea:	6a 00                	push   $0x0
  pushl $135
801068ec:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068f1:	e9 b7 f5 ff ff       	jmp    80105ead <alltraps>

801068f6 <vector136>:
.globl vector136
vector136:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $136
801068f8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068fd:	e9 ab f5 ff ff       	jmp    80105ead <alltraps>

80106902 <vector137>:
.globl vector137
vector137:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $137
80106904:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106909:	e9 9f f5 ff ff       	jmp    80105ead <alltraps>

8010690e <vector138>:
.globl vector138
vector138:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $138
80106910:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106915:	e9 93 f5 ff ff       	jmp    80105ead <alltraps>

8010691a <vector139>:
.globl vector139
vector139:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $139
8010691c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106921:	e9 87 f5 ff ff       	jmp    80105ead <alltraps>

80106926 <vector140>:
.globl vector140
vector140:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $140
80106928:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010692d:	e9 7b f5 ff ff       	jmp    80105ead <alltraps>

80106932 <vector141>:
.globl vector141
vector141:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $141
80106934:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106939:	e9 6f f5 ff ff       	jmp    80105ead <alltraps>

8010693e <vector142>:
.globl vector142
vector142:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $142
80106940:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106945:	e9 63 f5 ff ff       	jmp    80105ead <alltraps>

8010694a <vector143>:
.globl vector143
vector143:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $143
8010694c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106951:	e9 57 f5 ff ff       	jmp    80105ead <alltraps>

80106956 <vector144>:
.globl vector144
vector144:
  pushl $0
80106956:	6a 00                	push   $0x0
  pushl $144
80106958:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010695d:	e9 4b f5 ff ff       	jmp    80105ead <alltraps>

80106962 <vector145>:
.globl vector145
vector145:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $145
80106964:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106969:	e9 3f f5 ff ff       	jmp    80105ead <alltraps>

8010696e <vector146>:
.globl vector146
vector146:
  pushl $0
8010696e:	6a 00                	push   $0x0
  pushl $146
80106970:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106975:	e9 33 f5 ff ff       	jmp    80105ead <alltraps>

8010697a <vector147>:
.globl vector147
vector147:
  pushl $0
8010697a:	6a 00                	push   $0x0
  pushl $147
8010697c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106981:	e9 27 f5 ff ff       	jmp    80105ead <alltraps>

80106986 <vector148>:
.globl vector148
vector148:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $148
80106988:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010698d:	e9 1b f5 ff ff       	jmp    80105ead <alltraps>

80106992 <vector149>:
.globl vector149
vector149:
  pushl $0
80106992:	6a 00                	push   $0x0
  pushl $149
80106994:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106999:	e9 0f f5 ff ff       	jmp    80105ead <alltraps>

8010699e <vector150>:
.globl vector150
vector150:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $150
801069a0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069a5:	e9 03 f5 ff ff       	jmp    80105ead <alltraps>

801069aa <vector151>:
.globl vector151
vector151:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $151
801069ac:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069b1:	e9 f7 f4 ff ff       	jmp    80105ead <alltraps>

801069b6 <vector152>:
.globl vector152
vector152:
  pushl $0
801069b6:	6a 00                	push   $0x0
  pushl $152
801069b8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069bd:	e9 eb f4 ff ff       	jmp    80105ead <alltraps>

801069c2 <vector153>:
.globl vector153
vector153:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $153
801069c4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069c9:	e9 df f4 ff ff       	jmp    80105ead <alltraps>

801069ce <vector154>:
.globl vector154
vector154:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $154
801069d0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069d5:	e9 d3 f4 ff ff       	jmp    80105ead <alltraps>

801069da <vector155>:
.globl vector155
vector155:
  pushl $0
801069da:	6a 00                	push   $0x0
  pushl $155
801069dc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069e1:	e9 c7 f4 ff ff       	jmp    80105ead <alltraps>

801069e6 <vector156>:
.globl vector156
vector156:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $156
801069e8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069ed:	e9 bb f4 ff ff       	jmp    80105ead <alltraps>

801069f2 <vector157>:
.globl vector157
vector157:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $157
801069f4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069f9:	e9 af f4 ff ff       	jmp    80105ead <alltraps>

801069fe <vector158>:
.globl vector158
vector158:
  pushl $0
801069fe:	6a 00                	push   $0x0
  pushl $158
80106a00:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a05:	e9 a3 f4 ff ff       	jmp    80105ead <alltraps>

80106a0a <vector159>:
.globl vector159
vector159:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $159
80106a0c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a11:	e9 97 f4 ff ff       	jmp    80105ead <alltraps>

80106a16 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $160
80106a18:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a1d:	e9 8b f4 ff ff       	jmp    80105ead <alltraps>

80106a22 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a22:	6a 00                	push   $0x0
  pushl $161
80106a24:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a29:	e9 7f f4 ff ff       	jmp    80105ead <alltraps>

80106a2e <vector162>:
.globl vector162
vector162:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $162
80106a30:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a35:	e9 73 f4 ff ff       	jmp    80105ead <alltraps>

80106a3a <vector163>:
.globl vector163
vector163:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $163
80106a3c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a41:	e9 67 f4 ff ff       	jmp    80105ead <alltraps>

80106a46 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a46:	6a 00                	push   $0x0
  pushl $164
80106a48:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a4d:	e9 5b f4 ff ff       	jmp    80105ead <alltraps>

80106a52 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $165
80106a54:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a59:	e9 4f f4 ff ff       	jmp    80105ead <alltraps>

80106a5e <vector166>:
.globl vector166
vector166:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $166
80106a60:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a65:	e9 43 f4 ff ff       	jmp    80105ead <alltraps>

80106a6a <vector167>:
.globl vector167
vector167:
  pushl $0
80106a6a:	6a 00                	push   $0x0
  pushl $167
80106a6c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a71:	e9 37 f4 ff ff       	jmp    80105ead <alltraps>

80106a76 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a76:	6a 00                	push   $0x0
  pushl $168
80106a78:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a7d:	e9 2b f4 ff ff       	jmp    80105ead <alltraps>

80106a82 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a82:	6a 00                	push   $0x0
  pushl $169
80106a84:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a89:	e9 1f f4 ff ff       	jmp    80105ead <alltraps>

80106a8e <vector170>:
.globl vector170
vector170:
  pushl $0
80106a8e:	6a 00                	push   $0x0
  pushl $170
80106a90:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a95:	e9 13 f4 ff ff       	jmp    80105ead <alltraps>

80106a9a <vector171>:
.globl vector171
vector171:
  pushl $0
80106a9a:	6a 00                	push   $0x0
  pushl $171
80106a9c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106aa1:	e9 07 f4 ff ff       	jmp    80105ead <alltraps>

80106aa6 <vector172>:
.globl vector172
vector172:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $172
80106aa8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106aad:	e9 fb f3 ff ff       	jmp    80105ead <alltraps>

80106ab2 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ab2:	6a 00                	push   $0x0
  pushl $173
80106ab4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106ab9:	e9 ef f3 ff ff       	jmp    80105ead <alltraps>

80106abe <vector174>:
.globl vector174
vector174:
  pushl $0
80106abe:	6a 00                	push   $0x0
  pushl $174
80106ac0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ac5:	e9 e3 f3 ff ff       	jmp    80105ead <alltraps>

80106aca <vector175>:
.globl vector175
vector175:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $175
80106acc:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ad1:	e9 d7 f3 ff ff       	jmp    80105ead <alltraps>

80106ad6 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ad6:	6a 00                	push   $0x0
  pushl $176
80106ad8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106add:	e9 cb f3 ff ff       	jmp    80105ead <alltraps>

80106ae2 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $177
80106ae4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106ae9:	e9 bf f3 ff ff       	jmp    80105ead <alltraps>

80106aee <vector178>:
.globl vector178
vector178:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $178
80106af0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106af5:	e9 b3 f3 ff ff       	jmp    80105ead <alltraps>

80106afa <vector179>:
.globl vector179
vector179:
  pushl $0
80106afa:	6a 00                	push   $0x0
  pushl $179
80106afc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b01:	e9 a7 f3 ff ff       	jmp    80105ead <alltraps>

80106b06 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $180
80106b08:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b0d:	e9 9b f3 ff ff       	jmp    80105ead <alltraps>

80106b12 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $181
80106b14:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b19:	e9 8f f3 ff ff       	jmp    80105ead <alltraps>

80106b1e <vector182>:
.globl vector182
vector182:
  pushl $0
80106b1e:	6a 00                	push   $0x0
  pushl $182
80106b20:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b25:	e9 83 f3 ff ff       	jmp    80105ead <alltraps>

80106b2a <vector183>:
.globl vector183
vector183:
  pushl $0
80106b2a:	6a 00                	push   $0x0
  pushl $183
80106b2c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b31:	e9 77 f3 ff ff       	jmp    80105ead <alltraps>

80106b36 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b36:	6a 00                	push   $0x0
  pushl $184
80106b38:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b3d:	e9 6b f3 ff ff       	jmp    80105ead <alltraps>

80106b42 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b42:	6a 00                	push   $0x0
  pushl $185
80106b44:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b49:	e9 5f f3 ff ff       	jmp    80105ead <alltraps>

80106b4e <vector186>:
.globl vector186
vector186:
  pushl $0
80106b4e:	6a 00                	push   $0x0
  pushl $186
80106b50:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b55:	e9 53 f3 ff ff       	jmp    80105ead <alltraps>

80106b5a <vector187>:
.globl vector187
vector187:
  pushl $0
80106b5a:	6a 00                	push   $0x0
  pushl $187
80106b5c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b61:	e9 47 f3 ff ff       	jmp    80105ead <alltraps>

80106b66 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b66:	6a 00                	push   $0x0
  pushl $188
80106b68:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b6d:	e9 3b f3 ff ff       	jmp    80105ead <alltraps>

80106b72 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b72:	6a 00                	push   $0x0
  pushl $189
80106b74:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b79:	e9 2f f3 ff ff       	jmp    80105ead <alltraps>

80106b7e <vector190>:
.globl vector190
vector190:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $190
80106b80:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b85:	e9 23 f3 ff ff       	jmp    80105ead <alltraps>

80106b8a <vector191>:
.globl vector191
vector191:
  pushl $0
80106b8a:	6a 00                	push   $0x0
  pushl $191
80106b8c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b91:	e9 17 f3 ff ff       	jmp    80105ead <alltraps>

80106b96 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b96:	6a 00                	push   $0x0
  pushl $192
80106b98:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b9d:	e9 0b f3 ff ff       	jmp    80105ead <alltraps>

80106ba2 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $193
80106ba4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106ba9:	e9 ff f2 ff ff       	jmp    80105ead <alltraps>

80106bae <vector194>:
.globl vector194
vector194:
  pushl $0
80106bae:	6a 00                	push   $0x0
  pushl $194
80106bb0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106bb5:	e9 f3 f2 ff ff       	jmp    80105ead <alltraps>

80106bba <vector195>:
.globl vector195
vector195:
  pushl $0
80106bba:	6a 00                	push   $0x0
  pushl $195
80106bbc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106bc1:	e9 e7 f2 ff ff       	jmp    80105ead <alltraps>

80106bc6 <vector196>:
.globl vector196
vector196:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $196
80106bc8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bcd:	e9 db f2 ff ff       	jmp    80105ead <alltraps>

80106bd2 <vector197>:
.globl vector197
vector197:
  pushl $0
80106bd2:	6a 00                	push   $0x0
  pushl $197
80106bd4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bd9:	e9 cf f2 ff ff       	jmp    80105ead <alltraps>

80106bde <vector198>:
.globl vector198
vector198:
  pushl $0
80106bde:	6a 00                	push   $0x0
  pushl $198
80106be0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106be5:	e9 c3 f2 ff ff       	jmp    80105ead <alltraps>

80106bea <vector199>:
.globl vector199
vector199:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $199
80106bec:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bf1:	e9 b7 f2 ff ff       	jmp    80105ead <alltraps>

80106bf6 <vector200>:
.globl vector200
vector200:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $200
80106bf8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bfd:	e9 ab f2 ff ff       	jmp    80105ead <alltraps>

80106c02 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $201
80106c04:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c09:	e9 9f f2 ff ff       	jmp    80105ead <alltraps>

80106c0e <vector202>:
.globl vector202
vector202:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $202
80106c10:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c15:	e9 93 f2 ff ff       	jmp    80105ead <alltraps>

80106c1a <vector203>:
.globl vector203
vector203:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $203
80106c1c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c21:	e9 87 f2 ff ff       	jmp    80105ead <alltraps>

80106c26 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c26:	6a 00                	push   $0x0
  pushl $204
80106c28:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c2d:	e9 7b f2 ff ff       	jmp    80105ead <alltraps>

80106c32 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $205
80106c34:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c39:	e9 6f f2 ff ff       	jmp    80105ead <alltraps>

80106c3e <vector206>:
.globl vector206
vector206:
  pushl $0
80106c3e:	6a 00                	push   $0x0
  pushl $206
80106c40:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c45:	e9 63 f2 ff ff       	jmp    80105ead <alltraps>

80106c4a <vector207>:
.globl vector207
vector207:
  pushl $0
80106c4a:	6a 00                	push   $0x0
  pushl $207
80106c4c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c51:	e9 57 f2 ff ff       	jmp    80105ead <alltraps>

80106c56 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $208
80106c58:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c5d:	e9 4b f2 ff ff       	jmp    80105ead <alltraps>

80106c62 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c62:	6a 00                	push   $0x0
  pushl $209
80106c64:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c69:	e9 3f f2 ff ff       	jmp    80105ead <alltraps>

80106c6e <vector210>:
.globl vector210
vector210:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $210
80106c70:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c75:	e9 33 f2 ff ff       	jmp    80105ead <alltraps>

80106c7a <vector211>:
.globl vector211
vector211:
  pushl $0
80106c7a:	6a 00                	push   $0x0
  pushl $211
80106c7c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c81:	e9 27 f2 ff ff       	jmp    80105ead <alltraps>

80106c86 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c86:	6a 00                	push   $0x0
  pushl $212
80106c88:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c8d:	e9 1b f2 ff ff       	jmp    80105ead <alltraps>

80106c92 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $213
80106c94:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c99:	e9 0f f2 ff ff       	jmp    80105ead <alltraps>

80106c9e <vector214>:
.globl vector214
vector214:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $214
80106ca0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ca5:	e9 03 f2 ff ff       	jmp    80105ead <alltraps>

80106caa <vector215>:
.globl vector215
vector215:
  pushl $0
80106caa:	6a 00                	push   $0x0
  pushl $215
80106cac:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106cb1:	e9 f7 f1 ff ff       	jmp    80105ead <alltraps>

80106cb6 <vector216>:
.globl vector216
vector216:
  pushl $0
80106cb6:	6a 00                	push   $0x0
  pushl $216
80106cb8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106cbd:	e9 eb f1 ff ff       	jmp    80105ead <alltraps>

80106cc2 <vector217>:
.globl vector217
vector217:
  pushl $0
80106cc2:	6a 00                	push   $0x0
  pushl $217
80106cc4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cc9:	e9 df f1 ff ff       	jmp    80105ead <alltraps>

80106cce <vector218>:
.globl vector218
vector218:
  pushl $0
80106cce:	6a 00                	push   $0x0
  pushl $218
80106cd0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106cd5:	e9 d3 f1 ff ff       	jmp    80105ead <alltraps>

80106cda <vector219>:
.globl vector219
vector219:
  pushl $0
80106cda:	6a 00                	push   $0x0
  pushl $219
80106cdc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ce1:	e9 c7 f1 ff ff       	jmp    80105ead <alltraps>

80106ce6 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ce6:	6a 00                	push   $0x0
  pushl $220
80106ce8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ced:	e9 bb f1 ff ff       	jmp    80105ead <alltraps>

80106cf2 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cf2:	6a 00                	push   $0x0
  pushl $221
80106cf4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cf9:	e9 af f1 ff ff       	jmp    80105ead <alltraps>

80106cfe <vector222>:
.globl vector222
vector222:
  pushl $0
80106cfe:	6a 00                	push   $0x0
  pushl $222
80106d00:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d05:	e9 a3 f1 ff ff       	jmp    80105ead <alltraps>

80106d0a <vector223>:
.globl vector223
vector223:
  pushl $0
80106d0a:	6a 00                	push   $0x0
  pushl $223
80106d0c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d11:	e9 97 f1 ff ff       	jmp    80105ead <alltraps>

80106d16 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d16:	6a 00                	push   $0x0
  pushl $224
80106d18:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d1d:	e9 8b f1 ff ff       	jmp    80105ead <alltraps>

80106d22 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d22:	6a 00                	push   $0x0
  pushl $225
80106d24:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d29:	e9 7f f1 ff ff       	jmp    80105ead <alltraps>

80106d2e <vector226>:
.globl vector226
vector226:
  pushl $0
80106d2e:	6a 00                	push   $0x0
  pushl $226
80106d30:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d35:	e9 73 f1 ff ff       	jmp    80105ead <alltraps>

80106d3a <vector227>:
.globl vector227
vector227:
  pushl $0
80106d3a:	6a 00                	push   $0x0
  pushl $227
80106d3c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d41:	e9 67 f1 ff ff       	jmp    80105ead <alltraps>

80106d46 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $228
80106d48:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d4d:	e9 5b f1 ff ff       	jmp    80105ead <alltraps>

80106d52 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d52:	6a 00                	push   $0x0
  pushl $229
80106d54:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d59:	e9 4f f1 ff ff       	jmp    80105ead <alltraps>

80106d5e <vector230>:
.globl vector230
vector230:
  pushl $0
80106d5e:	6a 00                	push   $0x0
  pushl $230
80106d60:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d65:	e9 43 f1 ff ff       	jmp    80105ead <alltraps>

80106d6a <vector231>:
.globl vector231
vector231:
  pushl $0
80106d6a:	6a 00                	push   $0x0
  pushl $231
80106d6c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d71:	e9 37 f1 ff ff       	jmp    80105ead <alltraps>

80106d76 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d76:	6a 00                	push   $0x0
  pushl $232
80106d78:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d7d:	e9 2b f1 ff ff       	jmp    80105ead <alltraps>

80106d82 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d82:	6a 00                	push   $0x0
  pushl $233
80106d84:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d89:	e9 1f f1 ff ff       	jmp    80105ead <alltraps>

80106d8e <vector234>:
.globl vector234
vector234:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $234
80106d90:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d95:	e9 13 f1 ff ff       	jmp    80105ead <alltraps>

80106d9a <vector235>:
.globl vector235
vector235:
  pushl $0
80106d9a:	6a 00                	push   $0x0
  pushl $235
80106d9c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106da1:	e9 07 f1 ff ff       	jmp    80105ead <alltraps>

80106da6 <vector236>:
.globl vector236
vector236:
  pushl $0
80106da6:	6a 00                	push   $0x0
  pushl $236
80106da8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106dad:	e9 fb f0 ff ff       	jmp    80105ead <alltraps>

80106db2 <vector237>:
.globl vector237
vector237:
  pushl $0
80106db2:	6a 00                	push   $0x0
  pushl $237
80106db4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106db9:	e9 ef f0 ff ff       	jmp    80105ead <alltraps>

80106dbe <vector238>:
.globl vector238
vector238:
  pushl $0
80106dbe:	6a 00                	push   $0x0
  pushl $238
80106dc0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106dc5:	e9 e3 f0 ff ff       	jmp    80105ead <alltraps>

80106dca <vector239>:
.globl vector239
vector239:
  pushl $0
80106dca:	6a 00                	push   $0x0
  pushl $239
80106dcc:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106dd1:	e9 d7 f0 ff ff       	jmp    80105ead <alltraps>

80106dd6 <vector240>:
.globl vector240
vector240:
  pushl $0
80106dd6:	6a 00                	push   $0x0
  pushl $240
80106dd8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ddd:	e9 cb f0 ff ff       	jmp    80105ead <alltraps>

80106de2 <vector241>:
.globl vector241
vector241:
  pushl $0
80106de2:	6a 00                	push   $0x0
  pushl $241
80106de4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106de9:	e9 bf f0 ff ff       	jmp    80105ead <alltraps>

80106dee <vector242>:
.globl vector242
vector242:
  pushl $0
80106dee:	6a 00                	push   $0x0
  pushl $242
80106df0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106df5:	e9 b3 f0 ff ff       	jmp    80105ead <alltraps>

80106dfa <vector243>:
.globl vector243
vector243:
  pushl $0
80106dfa:	6a 00                	push   $0x0
  pushl $243
80106dfc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e01:	e9 a7 f0 ff ff       	jmp    80105ead <alltraps>

80106e06 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e06:	6a 00                	push   $0x0
  pushl $244
80106e08:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e0d:	e9 9b f0 ff ff       	jmp    80105ead <alltraps>

80106e12 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e12:	6a 00                	push   $0x0
  pushl $245
80106e14:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e19:	e9 8f f0 ff ff       	jmp    80105ead <alltraps>

80106e1e <vector246>:
.globl vector246
vector246:
  pushl $0
80106e1e:	6a 00                	push   $0x0
  pushl $246
80106e20:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e25:	e9 83 f0 ff ff       	jmp    80105ead <alltraps>

80106e2a <vector247>:
.globl vector247
vector247:
  pushl $0
80106e2a:	6a 00                	push   $0x0
  pushl $247
80106e2c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e31:	e9 77 f0 ff ff       	jmp    80105ead <alltraps>

80106e36 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $248
80106e38:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e3d:	e9 6b f0 ff ff       	jmp    80105ead <alltraps>

80106e42 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e42:	6a 00                	push   $0x0
  pushl $249
80106e44:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e49:	e9 5f f0 ff ff       	jmp    80105ead <alltraps>

80106e4e <vector250>:
.globl vector250
vector250:
  pushl $0
80106e4e:	6a 00                	push   $0x0
  pushl $250
80106e50:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e55:	e9 53 f0 ff ff       	jmp    80105ead <alltraps>

80106e5a <vector251>:
.globl vector251
vector251:
  pushl $0
80106e5a:	6a 00                	push   $0x0
  pushl $251
80106e5c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e61:	e9 47 f0 ff ff       	jmp    80105ead <alltraps>

80106e66 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e66:	6a 00                	push   $0x0
  pushl $252
80106e68:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e6d:	e9 3b f0 ff ff       	jmp    80105ead <alltraps>

80106e72 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e72:	6a 00                	push   $0x0
  pushl $253
80106e74:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e79:	e9 2f f0 ff ff       	jmp    80105ead <alltraps>

80106e7e <vector254>:
.globl vector254
vector254:
  pushl $0
80106e7e:	6a 00                	push   $0x0
  pushl $254
80106e80:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e85:	e9 23 f0 ff ff       	jmp    80105ead <alltraps>

80106e8a <vector255>:
.globl vector255
vector255:
  pushl $0
80106e8a:	6a 00                	push   $0x0
  pushl $255
80106e8c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e91:	e9 17 f0 ff ff       	jmp    80105ead <alltraps>
80106e96:	66 90                	xchg   %ax,%ax
80106e98:	66 90                	xchg   %ax,%ax
80106e9a:	66 90                	xchg   %ax,%ax
80106e9c:	66 90                	xchg   %ax,%ax
80106e9e:	66 90                	xchg   %ax,%ax

80106ea0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ea7:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106eaa:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106eab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106eae:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106eb1:	8b 1f                	mov    (%edi),%ebx
80106eb3:	f6 c3 01             	test   $0x1,%bl
80106eb6:	74 28                	je     80106ee0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106eb8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106ebe:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ec4:	c1 ee 0a             	shr    $0xa,%esi
}
80106ec7:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106eca:	89 f2                	mov    %esi,%edx
80106ecc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ed2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106ed5:	5b                   	pop    %ebx
80106ed6:	5e                   	pop    %esi
80106ed7:	5f                   	pop    %edi
80106ed8:	5d                   	pop    %ebp
80106ed9:	c3                   	ret    
80106eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ee0:	85 c9                	test   %ecx,%ecx
80106ee2:	74 34                	je     80106f18 <walkpgdir+0x78>
80106ee4:	e8 f7 b5 ff ff       	call   801024e0 <kalloc>
80106ee9:	85 c0                	test   %eax,%eax
80106eeb:	89 c3                	mov    %eax,%ebx
80106eed:	74 29                	je     80106f18 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106eef:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106ef6:	00 
80106ef7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106efe:	00 
80106eff:	89 04 24             	mov    %eax,(%esp)
80106f02:	e8 29 de ff ff       	call   80104d30 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f07:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f0d:	83 c8 07             	or     $0x7,%eax
80106f10:	89 07                	mov    %eax,(%edi)
80106f12:	eb b0                	jmp    80106ec4 <walkpgdir+0x24>
80106f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
80106f18:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106f1b:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106f1d:	5b                   	pop    %ebx
80106f1e:	5e                   	pop    %esi
80106f1f:	5f                   	pop    %edi
80106f20:	5d                   	pop    %ebp
80106f21:	c3                   	ret    
80106f22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f30 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106f36:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f38:	83 ec 1c             	sub    $0x1c,%esp
80106f3b:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106f3e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f44:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f47:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f4b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f4e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f52:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106f59:	29 df                	sub    %ebx,%edi
80106f5b:	eb 18                	jmp    80106f75 <mappages+0x45>
80106f5d:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106f60:	f6 00 01             	testb  $0x1,(%eax)
80106f63:	75 3d                	jne    80106fa2 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f65:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106f68:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f6b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106f6d:	74 29                	je     80106f98 <mappages+0x68>
      break;
    a += PGSIZE;
80106f6f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f78:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f7d:	89 da                	mov    %ebx,%edx
80106f7f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106f82:	e8 19 ff ff ff       	call   80106ea0 <walkpgdir>
80106f87:	85 c0                	test   %eax,%eax
80106f89:	75 d5                	jne    80106f60 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106f8b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106f8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106f93:	5b                   	pop    %ebx
80106f94:	5e                   	pop    %esi
80106f95:	5f                   	pop    %edi
80106f96:	5d                   	pop    %ebp
80106f97:	c3                   	ret    
80106f98:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106f9b:	31 c0                	xor    %eax,%eax
}
80106f9d:	5b                   	pop    %ebx
80106f9e:	5e                   	pop    %esi
80106f9f:	5f                   	pop    %edi
80106fa0:	5d                   	pop    %ebp
80106fa1:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106fa2:	c7 04 24 08 82 10 80 	movl   $0x80108208,(%esp)
80106fa9:	e8 b2 93 ff ff       	call   80100360 <panic>
80106fae:	66 90                	xchg   %ax,%ax

80106fb0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	57                   	push   %edi
80106fb4:	89 c7                	mov    %eax,%edi
80106fb6:	56                   	push   %esi
80106fb7:	89 d6                	mov    %edx,%esi
80106fb9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106fba:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fc0:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106fc3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106fc9:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fcb:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106fce:	72 3b                	jb     8010700b <deallocuvm.part.0+0x5b>
80106fd0:	eb 5e                	jmp    80107030 <deallocuvm.part.0+0x80>
80106fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106fd8:	8b 10                	mov    (%eax),%edx
80106fda:	f6 c2 01             	test   $0x1,%dl
80106fdd:	74 22                	je     80107001 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106fdf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106fe5:	74 54                	je     8010703b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106fe7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106fed:	89 14 24             	mov    %edx,(%esp)
80106ff0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ff3:	e8 38 b3 ff ff       	call   80102330 <kfree>
      *pte = 0;
80106ff8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ffb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107001:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107007:	39 f3                	cmp    %esi,%ebx
80107009:	73 25                	jae    80107030 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010700b:	31 c9                	xor    %ecx,%ecx
8010700d:	89 da                	mov    %ebx,%edx
8010700f:	89 f8                	mov    %edi,%eax
80107011:	e8 8a fe ff ff       	call   80106ea0 <walkpgdir>
    if(!pte)
80107016:	85 c0                	test   %eax,%eax
80107018:	75 be                	jne    80106fd8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010701a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107020:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107026:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010702c:	39 f3                	cmp    %esi,%ebx
8010702e:	72 db                	jb     8010700b <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107030:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107033:	83 c4 1c             	add    $0x1c,%esp
80107036:	5b                   	pop    %ebx
80107037:	5e                   	pop    %esi
80107038:	5f                   	pop    %edi
80107039:	5d                   	pop    %ebp
8010703a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010703b:	c7 04 24 12 7b 10 80 	movl   $0x80107b12,(%esp)
80107042:	e8 19 93 ff ff       	call   80100360 <panic>
80107047:	89 f6                	mov    %esi,%esi
80107049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107050 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107056:	e8 45 b7 ff ff       	call   801027a0 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010705b:	31 c9                	xor    %ecx,%ecx
8010705d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107062:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107068:	05 a0 37 11 80       	add    $0x801137a0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010706d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107071:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107076:	66 89 48 7a          	mov    %cx,0x7a(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010707a:	31 c9                	xor    %ecx,%ecx
8010707c:	66 89 90 80 00 00 00 	mov    %dx,0x80(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107083:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107088:	66 89 88 82 00 00 00 	mov    %cx,0x82(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010708f:	31 c9                	xor    %ecx,%ecx
80107091:	66 89 90 90 00 00 00 	mov    %dx,0x90(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107098:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010709d:	66 89 88 92 00 00 00 	mov    %cx,0x92(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070a4:	31 c9                	xor    %ecx,%ecx
801070a6:	66 89 90 98 00 00 00 	mov    %dx,0x98(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801070ad:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801070b3:	66 89 88 9a 00 00 00 	mov    %cx,0x9a(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801070ba:	31 c9                	xor    %ecx,%ecx
801070bc:	66 89 88 88 00 00 00 	mov    %cx,0x88(%eax)
801070c3:	89 d1                	mov    %edx,%ecx
801070c5:	c1 e9 10             	shr    $0x10,%ecx
801070c8:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
801070cf:	c1 ea 18             	shr    $0x18,%edx
801070d2:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801070d8:	b9 37 00 00 00       	mov    $0x37,%ecx
801070dd:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801070e3:	8d 50 70             	lea    0x70(%eax),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070e6:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
801070ea:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070ee:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
801070f5:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070fc:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
80107103:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010710a:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
80107111:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107118:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
8010711f:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
80107126:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
8010712a:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
8010712e:	c1 ea 10             	shr    $0x10,%edx
80107131:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107135:	8d 55 f2             	lea    -0xe(%ebp),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107138:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010713c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107140:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107147:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010714e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107155:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010715c:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107163:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
8010716a:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
8010716d:	ba 18 00 00 00       	mov    $0x18,%edx
80107172:	8e ea                	mov    %edx,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80107174:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010717b:	00 00 00 00 

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
8010717f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
}
80107185:	c9                   	leave  
80107186:	c3                   	ret    
80107187:	89 f6                	mov    %esi,%esi
80107189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107190 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	56                   	push   %esi
80107194:	53                   	push   %ebx
80107195:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107198:	e8 43 b3 ff ff       	call   801024e0 <kalloc>
8010719d:	85 c0                	test   %eax,%eax
8010719f:	89 c6                	mov    %eax,%esi
801071a1:	74 55                	je     801071f8 <setupkvm+0x68>
    return 0;
  memset(pgdir, 0, PGSIZE);
801071a3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801071aa:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071ab:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801071b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801071b7:	00 
801071b8:	89 04 24             	mov    %eax,(%esp)
801071bb:	e8 70 db ff ff       	call   80104d30 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071c0:	8b 53 0c             	mov    0xc(%ebx),%edx
801071c3:	8b 43 04             	mov    0x4(%ebx),%eax
801071c6:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071c9:	89 54 24 04          	mov    %edx,0x4(%esp)
801071cd:	8b 13                	mov    (%ebx),%edx
801071cf:	89 04 24             	mov    %eax,(%esp)
801071d2:	29 c1                	sub    %eax,%ecx
801071d4:	89 f0                	mov    %esi,%eax
801071d6:	e8 55 fd ff ff       	call   80106f30 <mappages>
801071db:	85 c0                	test   %eax,%eax
801071dd:	78 19                	js     801071f8 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071df:	83 c3 10             	add    $0x10,%ebx
801071e2:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801071e8:	72 d6                	jb     801071c0 <setupkvm+0x30>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801071ea:	83 c4 10             	add    $0x10,%esp
801071ed:	89 f0                	mov    %esi,%eax
801071ef:	5b                   	pop    %ebx
801071f0:	5e                   	pop    %esi
801071f1:	5d                   	pop    %ebp
801071f2:	c3                   	ret    
801071f3:	90                   	nop
801071f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071f8:	83 c4 10             	add    $0x10,%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801071fb:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801071fd:	5b                   	pop    %ebx
801071fe:	5e                   	pop    %esi
801071ff:	5d                   	pop    %ebp
80107200:	c3                   	ret    
80107201:	eb 0d                	jmp    80107210 <kvmalloc>
80107203:	90                   	nop
80107204:	90                   	nop
80107205:	90                   	nop
80107206:	90                   	nop
80107207:	90                   	nop
80107208:	90                   	nop
80107209:	90                   	nop
8010720a:	90                   	nop
8010720b:	90                   	nop
8010720c:	90                   	nop
8010720d:	90                   	nop
8010720e:	90                   	nop
8010720f:	90                   	nop

80107210 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107216:	e8 75 ff ff ff       	call   80107190 <setupkvm>
8010721b:	a3 c4 6e 11 80       	mov    %eax,0x80116ec4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107220:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107225:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80107228:	c9                   	leave  
80107229:	c3                   	ret    
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107230 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107230:	a1 c4 6e 11 80       	mov    0x80116ec4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107235:	55                   	push   %ebp
80107236:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107238:	05 00 00 00 80       	add    $0x80000000,%eax
8010723d:	0f 22 d8             	mov    %eax,%cr3
}
80107240:	5d                   	pop    %ebp
80107241:	c3                   	ret    
80107242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107250 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	53                   	push   %ebx
80107254:	83 ec 14             	sub    $0x14,%esp
80107257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010725a:	85 db                	test   %ebx,%ebx
8010725c:	0f 84 94 00 00 00    	je     801072f6 <switchuvm+0xa6>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107262:	8b 43 08             	mov    0x8(%ebx),%eax
80107265:	85 c0                	test   %eax,%eax
80107267:	0f 84 a1 00 00 00    	je     8010730e <switchuvm+0xbe>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010726d:	8b 43 04             	mov    0x4(%ebx),%eax
80107270:	85 c0                	test   %eax,%eax
80107272:	0f 84 8a 00 00 00    	je     80107302 <switchuvm+0xb2>
    panic("switchuvm: no pgdir");

  pushcli();
80107278:	e8 e3 d9 ff ff       	call   80104c60 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010727d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107283:	b9 67 00 00 00       	mov    $0x67,%ecx
80107288:	8d 50 08             	lea    0x8(%eax),%edx
8010728b:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80107292:	89 d1                	mov    %edx,%ecx
80107294:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
8010729b:	c1 ea 18             	shr    $0x18,%edx
8010729e:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
801072a4:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
801072a7:	ba 10 00 00 00       	mov    $0x10,%edx
801072ac:	66 89 50 10          	mov    %dx,0x10(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801072b0:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
801072b6:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801072bd:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072c4:	8b 4b 08             	mov    0x8(%ebx),%ecx
801072c7:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
801072cd:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072d2:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
801072d5:	66 89 48 6e          	mov    %cx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801072d9:	b8 30 00 00 00       	mov    $0x30,%eax
801072de:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801072e1:	8b 43 04             	mov    0x4(%ebx),%eax
801072e4:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072e9:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
801072ec:	83 c4 14             	add    $0x14,%esp
801072ef:	5b                   	pop    %ebx
801072f0:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801072f1:	e9 9a d9 ff ff       	jmp    80104c90 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801072f6:	c7 04 24 0e 82 10 80 	movl   $0x8010820e,(%esp)
801072fd:	e8 5e 90 ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80107302:	c7 04 24 39 82 10 80 	movl   $0x80108239,(%esp)
80107309:	e8 52 90 ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010730e:	c7 04 24 24 82 10 80 	movl   $0x80108224,(%esp)
80107315:	e8 46 90 ff ff       	call   80100360 <panic>
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107320 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 1c             	sub    $0x1c,%esp
80107329:	8b 75 10             	mov    0x10(%ebp),%esi
8010732c:	8b 45 08             	mov    0x8(%ebp),%eax
8010732f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107332:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107338:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010733b:	77 54                	ja     80107391 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
8010733d:	e8 9e b1 ff ff       	call   801024e0 <kalloc>
  memset(mem, 0, PGSIZE);
80107342:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107349:	00 
8010734a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107351:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107352:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107354:	89 04 24             	mov    %eax,(%esp)
80107357:	e8 d4 d9 ff ff       	call   80104d30 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010735c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107362:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107367:	89 04 24             	mov    %eax,(%esp)
8010736a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010736d:	31 d2                	xor    %edx,%edx
8010736f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80107376:	00 
80107377:	e8 b4 fb ff ff       	call   80106f30 <mappages>
  memmove(mem, init, sz);
8010737c:	89 75 10             	mov    %esi,0x10(%ebp)
8010737f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107382:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107385:	83 c4 1c             	add    $0x1c,%esp
80107388:	5b                   	pop    %ebx
80107389:	5e                   	pop    %esi
8010738a:	5f                   	pop    %edi
8010738b:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
8010738c:	e9 3f da ff ff       	jmp    80104dd0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107391:	c7 04 24 4d 82 10 80 	movl   $0x8010824d,(%esp)
80107398:	e8 c3 8f ff ff       	call   80100360 <panic>
8010739d:	8d 76 00             	lea    0x0(%esi),%esi

801073a0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	57                   	push   %edi
801073a4:	56                   	push   %esi
801073a5:	53                   	push   %ebx
801073a6:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801073a9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801073b0:	0f 85 98 00 00 00    	jne    8010744e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801073b6:	8b 75 18             	mov    0x18(%ebp),%esi
801073b9:	31 db                	xor    %ebx,%ebx
801073bb:	85 f6                	test   %esi,%esi
801073bd:	75 1a                	jne    801073d9 <loaduvm+0x39>
801073bf:	eb 77                	jmp    80107438 <loaduvm+0x98>
801073c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073ce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801073d4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801073d7:	76 5f                	jbe    80107438 <loaduvm+0x98>
801073d9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801073dc:	31 c9                	xor    %ecx,%ecx
801073de:	8b 45 08             	mov    0x8(%ebp),%eax
801073e1:	01 da                	add    %ebx,%edx
801073e3:	e8 b8 fa ff ff       	call   80106ea0 <walkpgdir>
801073e8:	85 c0                	test   %eax,%eax
801073ea:	74 56                	je     80107442 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801073ec:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
801073ee:	bf 00 10 00 00       	mov    $0x1000,%edi
801073f3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801073f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
801073fb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80107401:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107404:	05 00 00 00 80       	add    $0x80000000,%eax
80107409:	89 44 24 04          	mov    %eax,0x4(%esp)
8010740d:	8b 45 10             	mov    0x10(%ebp),%eax
80107410:	01 d9                	add    %ebx,%ecx
80107412:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80107416:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010741a:	89 04 24             	mov    %eax,(%esp)
8010741d:	e8 6e a5 ff ff       	call   80101990 <readi>
80107422:	39 f8                	cmp    %edi,%eax
80107424:	74 a2                	je     801073c8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107426:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010742e:	5b                   	pop    %ebx
8010742f:	5e                   	pop    %esi
80107430:	5f                   	pop    %edi
80107431:	5d                   	pop    %ebp
80107432:	c3                   	ret    
80107433:	90                   	nop
80107434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107438:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010743b:	31 c0                	xor    %eax,%eax
}
8010743d:	5b                   	pop    %ebx
8010743e:	5e                   	pop    %esi
8010743f:	5f                   	pop    %edi
80107440:	5d                   	pop    %ebp
80107441:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80107442:	c7 04 24 67 82 10 80 	movl   $0x80108267,(%esp)
80107449:	e8 12 8f ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
8010744e:	c7 04 24 08 83 10 80 	movl   $0x80108308,(%esp)
80107455:	e8 06 8f ff ff       	call   80100360 <panic>
8010745a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107460 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	57                   	push   %edi
80107464:	56                   	push   %esi
80107465:	53                   	push   %ebx
80107466:	83 ec 1c             	sub    $0x1c,%esp
80107469:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010746c:	85 ff                	test   %edi,%edi
8010746e:	0f 88 7e 00 00 00    	js     801074f2 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80107474:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107477:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010747a:	72 78                	jb     801074f4 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
8010747c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107482:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107488:	39 df                	cmp    %ebx,%edi
8010748a:	77 4a                	ja     801074d6 <allocuvm+0x76>
8010748c:	eb 72                	jmp    80107500 <allocuvm+0xa0>
8010748e:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107490:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107497:	00 
80107498:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010749f:	00 
801074a0:	89 04 24             	mov    %eax,(%esp)
801074a3:	e8 88 d8 ff ff       	call   80104d30 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801074a8:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801074ae:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074b3:	89 04 24             	mov    %eax,(%esp)
801074b6:	8b 45 08             	mov    0x8(%ebp),%eax
801074b9:	89 da                	mov    %ebx,%edx
801074bb:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801074c2:	00 
801074c3:	e8 68 fa ff ff       	call   80106f30 <mappages>
801074c8:	85 c0                	test   %eax,%eax
801074ca:	78 44                	js     80107510 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801074cc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074d2:	39 df                	cmp    %ebx,%edi
801074d4:	76 2a                	jbe    80107500 <allocuvm+0xa0>
    mem = kalloc();
801074d6:	e8 05 b0 ff ff       	call   801024e0 <kalloc>
    if(mem == 0){
801074db:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
801074dd:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801074df:	75 af                	jne    80107490 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
801074e1:	c7 04 24 85 82 10 80 	movl   $0x80108285,(%esp)
801074e8:	e8 63 91 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801074ed:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801074f0:	77 48                	ja     8010753a <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
801074f2:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
801074f4:	83 c4 1c             	add    $0x1c,%esp
801074f7:	5b                   	pop    %ebx
801074f8:	5e                   	pop    %esi
801074f9:	5f                   	pop    %edi
801074fa:	5d                   	pop    %ebp
801074fb:	c3                   	ret    
801074fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107500:	83 c4 1c             	add    $0x1c,%esp
80107503:	89 f8                	mov    %edi,%eax
80107505:	5b                   	pop    %ebx
80107506:	5e                   	pop    %esi
80107507:	5f                   	pop    %edi
80107508:	5d                   	pop    %ebp
80107509:	c3                   	ret    
8010750a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107510:	c7 04 24 9d 82 10 80 	movl   $0x8010829d,(%esp)
80107517:	e8 34 91 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010751c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010751f:	76 0d                	jbe    8010752e <allocuvm+0xce>
80107521:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107524:	89 fa                	mov    %edi,%edx
80107526:	8b 45 08             	mov    0x8(%ebp),%eax
80107529:	e8 82 fa ff ff       	call   80106fb0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
8010752e:	89 34 24             	mov    %esi,(%esp)
80107531:	e8 fa ad ff ff       	call   80102330 <kfree>
      return 0;
80107536:	31 c0                	xor    %eax,%eax
80107538:	eb ba                	jmp    801074f4 <allocuvm+0x94>
8010753a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010753d:	89 fa                	mov    %edi,%edx
8010753f:	8b 45 08             	mov    0x8(%ebp),%eax
80107542:	e8 69 fa ff ff       	call   80106fb0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107547:	31 c0                	xor    %eax,%eax
80107549:	eb a9                	jmp    801074f4 <allocuvm+0x94>
8010754b:	90                   	nop
8010754c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107550 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	8b 55 0c             	mov    0xc(%ebp),%edx
80107556:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107559:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010755c:	39 d1                	cmp    %edx,%ecx
8010755e:	73 08                	jae    80107568 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107560:	5d                   	pop    %ebp
80107561:	e9 4a fa ff ff       	jmp    80106fb0 <deallocuvm.part.0>
80107566:	66 90                	xchg   %ax,%ax
80107568:	89 d0                	mov    %edx,%eax
8010756a:	5d                   	pop    %ebp
8010756b:	c3                   	ret    
8010756c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107570 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	56                   	push   %esi
80107574:	53                   	push   %ebx
80107575:	83 ec 10             	sub    $0x10,%esp
80107578:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010757b:	85 f6                	test   %esi,%esi
8010757d:	74 59                	je     801075d8 <freevm+0x68>
8010757f:	31 c9                	xor    %ecx,%ecx
80107581:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107586:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107588:	31 db                	xor    %ebx,%ebx
8010758a:	e8 21 fa ff ff       	call   80106fb0 <deallocuvm.part.0>
8010758f:	eb 12                	jmp    801075a3 <freevm+0x33>
80107591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107598:	83 c3 01             	add    $0x1,%ebx
8010759b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801075a1:	74 27                	je     801075ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801075a3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
801075a6:	f6 c2 01             	test   $0x1,%dl
801075a9:	74 ed                	je     80107598 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801075ab:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801075b1:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
801075b4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801075ba:	89 14 24             	mov    %edx,(%esp)
801075bd:	e8 6e ad ff ff       	call   80102330 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801075c2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801075c8:	75 d9                	jne    801075a3 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801075ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801075cd:	83 c4 10             	add    $0x10,%esp
801075d0:	5b                   	pop    %ebx
801075d1:	5e                   	pop    %esi
801075d2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801075d3:	e9 58 ad ff ff       	jmp    80102330 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801075d8:	c7 04 24 b9 82 10 80 	movl   $0x801082b9,(%esp)
801075df:	e8 7c 8d ff ff       	call   80100360 <panic>
801075e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801075f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075f1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075f3:	89 e5                	mov    %esp,%ebp
801075f5:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801075fb:	8b 45 08             	mov    0x8(%ebp),%eax
801075fe:	e8 9d f8 ff ff       	call   80106ea0 <walkpgdir>
  if(pte == 0)
80107603:	85 c0                	test   %eax,%eax
80107605:	74 05                	je     8010760c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107607:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010760a:	c9                   	leave  
8010760b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010760c:	c7 04 24 ca 82 10 80 	movl   $0x801082ca,(%esp)
80107613:	e8 48 8d ff ff       	call   80100360 <panic>
80107618:	90                   	nop
80107619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107620 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	56                   	push   %esi
80107625:	53                   	push   %ebx
80107626:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107629:	e8 62 fb ff ff       	call   80107190 <setupkvm>
8010762e:	85 c0                	test   %eax,%eax
80107630:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107633:	0f 84 b2 00 00 00    	je     801076eb <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107639:	8b 45 0c             	mov    0xc(%ebp),%eax
8010763c:	85 c0                	test   %eax,%eax
8010763e:	0f 84 9c 00 00 00    	je     801076e0 <copyuvm+0xc0>
80107644:	31 db                	xor    %ebx,%ebx
80107646:	eb 48                	jmp    80107690 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107648:	81 c7 00 00 00 80    	add    $0x80000000,%edi
8010764e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107655:	00 
80107656:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010765a:	89 04 24             	mov    %eax,(%esp)
8010765d:	e8 6e d7 ff ff       	call   80104dd0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107665:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
8010766b:	89 14 24             	mov    %edx,(%esp)
8010766e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107673:	89 da                	mov    %ebx,%edx
80107675:	89 44 24 04          	mov    %eax,0x4(%esp)
80107679:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010767c:	e8 af f8 ff ff       	call   80106f30 <mappages>
80107681:	85 c0                	test   %eax,%eax
80107683:	78 41                	js     801076c6 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107685:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010768b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
8010768e:	76 50                	jbe    801076e0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107690:	8b 45 08             	mov    0x8(%ebp),%eax
80107693:	31 c9                	xor    %ecx,%ecx
80107695:	89 da                	mov    %ebx,%edx
80107697:	e8 04 f8 ff ff       	call   80106ea0 <walkpgdir>
8010769c:	85 c0                	test   %eax,%eax
8010769e:	74 5b                	je     801076fb <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801076a0:	8b 30                	mov    (%eax),%esi
801076a2:	f7 c6 01 00 00 00    	test   $0x1,%esi
801076a8:	74 45                	je     801076ef <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801076aa:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
801076ac:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
801076b2:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801076b5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
801076bb:	e8 20 ae ff ff       	call   801024e0 <kalloc>
801076c0:	85 c0                	test   %eax,%eax
801076c2:	89 c6                	mov    %eax,%esi
801076c4:	75 82                	jne    80107648 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801076c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076c9:	89 04 24             	mov    %eax,(%esp)
801076cc:	e8 9f fe ff ff       	call   80107570 <freevm>
  return 0;
801076d1:	31 c0                	xor    %eax,%eax
}
801076d3:	83 c4 2c             	add    $0x2c,%esp
801076d6:	5b                   	pop    %ebx
801076d7:	5e                   	pop    %esi
801076d8:	5f                   	pop    %edi
801076d9:	5d                   	pop    %ebp
801076da:	c3                   	ret    
801076db:	90                   	nop
801076dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076e3:	83 c4 2c             	add    $0x2c,%esp
801076e6:	5b                   	pop    %ebx
801076e7:	5e                   	pop    %esi
801076e8:	5f                   	pop    %edi
801076e9:	5d                   	pop    %ebp
801076ea:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801076eb:	31 c0                	xor    %eax,%eax
801076ed:	eb e4                	jmp    801076d3 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801076ef:	c7 04 24 ee 82 10 80 	movl   $0x801082ee,(%esp)
801076f6:	e8 65 8c ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801076fb:	c7 04 24 d4 82 10 80 	movl   $0x801082d4,(%esp)
80107702:	e8 59 8c ff ff       	call   80100360 <panic>
80107707:	89 f6                	mov    %esi,%esi
80107709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107710 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107710:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107711:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107713:	89 e5                	mov    %esp,%ebp
80107715:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107718:	8b 55 0c             	mov    0xc(%ebp),%edx
8010771b:	8b 45 08             	mov    0x8(%ebp),%eax
8010771e:	e8 7d f7 ff ff       	call   80106ea0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107723:	8b 00                	mov    (%eax),%eax
80107725:	89 c2                	mov    %eax,%edx
80107727:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
8010772a:	83 fa 05             	cmp    $0x5,%edx
8010772d:	75 11                	jne    80107740 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010772f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107734:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107739:	c9                   	leave  
8010773a:	c3                   	ret    
8010773b:	90                   	nop
8010773c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107740:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107742:	c9                   	leave  
80107743:	c3                   	ret    
80107744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010774a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107750 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	57                   	push   %edi
80107754:	56                   	push   %esi
80107755:	53                   	push   %ebx
80107756:	83 ec 1c             	sub    $0x1c,%esp
80107759:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010775c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010775f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107762:	85 db                	test   %ebx,%ebx
80107764:	75 3a                	jne    801077a0 <copyout+0x50>
80107766:	eb 68                	jmp    801077d0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107768:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010776b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010776d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107771:	29 ca                	sub    %ecx,%edx
80107773:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107779:	39 da                	cmp    %ebx,%edx
8010777b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010777e:	29 f1                	sub    %esi,%ecx
80107780:	01 c8                	add    %ecx,%eax
80107782:	89 54 24 08          	mov    %edx,0x8(%esp)
80107786:	89 04 24             	mov    %eax,(%esp)
80107789:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010778c:	e8 3f d6 ff ff       	call   80104dd0 <memmove>
    len -= n;
    buf += n;
80107791:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107794:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
8010779a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010779c:	29 d3                	sub    %edx,%ebx
8010779e:	74 30                	je     801077d0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
801077a0:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801077a3:	89 ce                	mov    %ecx,%esi
801077a5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801077ab:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801077af:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801077b2:	89 04 24             	mov    %eax,(%esp)
801077b5:	e8 56 ff ff ff       	call   80107710 <uva2ka>
    if(pa0 == 0)
801077ba:	85 c0                	test   %eax,%eax
801077bc:	75 aa                	jne    80107768 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801077be:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801077c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801077c6:	5b                   	pop    %ebx
801077c7:	5e                   	pop    %esi
801077c8:	5f                   	pop    %edi
801077c9:	5d                   	pop    %ebp
801077ca:	c3                   	ret    
801077cb:	90                   	nop
801077cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077d0:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801077d3:	31 c0                	xor    %eax,%eax
}
801077d5:	5b                   	pop    %ebx
801077d6:	5e                   	pop    %esi
801077d7:	5f                   	pop    %edi
801077d8:	5d                   	pop    %ebp
801077d9:	c3                   	ret    
801077da:	66 90                	xchg   %ax,%ax
801077dc:	66 90                	xchg   %ax,%ax
801077de:	66 90                	xchg   %ax,%ax

801077e0 <my_syscall>:
#include "types.h"
#include "defs.h"

int
my_syscall(char *str) 
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s\n", str);
801077e6:	8b 45 08             	mov    0x8(%ebp),%eax
801077e9:	c7 04 24 2c 83 10 80 	movl   $0x8010832c,(%esp)
801077f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801077f4:	e8 57 8e ff ff       	call   80100650 <cprintf>
    return 0xABCDABCD;
}
801077f9:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
801077fe:	c9                   	leave  
801077ff:	c3                   	ret    

80107800 <sys_my_syscall>:

int
sys_my_syscall(void) 
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	83 ec 28             	sub    $0x28,%esp
    char *str;
    if (argstr(0, &str) < 0) // wrapper 함수. 커널 내부에 reference가 호출 되고, argument가 user영역에 있는지 체크해주는 함수.
80107806:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107809:	89 44 24 04          	mov    %eax,0x4(%esp)
8010780d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107814:	e8 77 d8 ff ff       	call   80105090 <argstr>
        return -1;
80107819:	ba ff ff ff ff       	mov    $0xffffffff,%edx

int
sys_my_syscall(void) 
{
    char *str;
    if (argstr(0, &str) < 0) // wrapper 함수. 커널 내부에 reference가 호출 되고, argument가 user영역에 있는지 체크해주는 함수.
8010781e:	85 c0                	test   %eax,%eax
80107820:	78 18                	js     8010783a <sys_my_syscall+0x3a>
#include "defs.h"

int
my_syscall(char *str) 
{
    cprintf("%s\n", str);
80107822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107825:	c7 04 24 2c 83 10 80 	movl   $0x8010832c,(%esp)
8010782c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107830:	e8 1b 8e ff ff       	call   80100650 <cprintf>
sys_my_syscall(void) 
{
    char *str;
    if (argstr(0, &str) < 0) // wrapper 함수. 커널 내부에 reference가 호출 되고, argument가 user영역에 있는지 체크해주는 함수.
        return -1;
    return my_syscall(str);
80107835:	ba cd ab cd ab       	mov    $0xabcdabcd,%edx
}
8010783a:	89 d0                	mov    %edx,%eax
8010783c:	c9                   	leave  
8010783d:	c3                   	ret    
8010783e:	66 90                	xchg   %ax,%ax

80107840 <getppid>:
#include "syscall.h"

int
getppid(void)
{
    return proc->parent->pid;
80107840:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
#include "x86.h"
#include "syscall.h"

int
getppid(void)
{
80107846:	55                   	push   %ebp
80107847:	89 e5                	mov    %esp,%ebp
    return proc->parent->pid;
}
80107849:	5d                   	pop    %ebp
#include "syscall.h"

int
getppid(void)
{
    return proc->parent->pid;
8010784a:	8b 40 14             	mov    0x14(%eax),%eax
8010784d:	8b 40 10             	mov    0x10(%eax),%eax
}
80107850:	c3                   	ret    
80107851:	eb 0d                	jmp    80107860 <sys_getppid>
80107853:	90                   	nop
80107854:	90                   	nop
80107855:	90                   	nop
80107856:	90                   	nop
80107857:	90                   	nop
80107858:	90                   	nop
80107859:	90                   	nop
8010785a:	90                   	nop
8010785b:	90                   	nop
8010785c:	90                   	nop
8010785d:	90                   	nop
8010785e:	90                   	nop
8010785f:	90                   	nop

80107860 <sys_getppid>:
#include "syscall.h"

int
getppid(void)
{
    return proc->parent->pid;
80107860:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
}

//Wrapper for getppid
int
sys_getppid(void)
{
80107866:	55                   	push   %ebp
80107867:	89 e5                	mov    %esp,%ebp
    return getppid();
}
80107869:	5d                   	pop    %ebp
#include "syscall.h"

int
getppid(void)
{
    return proc->parent->pid;
8010786a:	8b 40 14             	mov    0x14(%eax),%eax

//Wrapper for getppid
int
sys_getppid(void)
{
    return getppid();
8010786d:	8b 40 10             	mov    0x10(%eax),%eax
}
80107870:	c3                   	ret    
80107871:	66 90                	xchg   %ax,%ax
80107873:	66 90                	xchg   %ax,%ax
80107875:	66 90                	xchg   %ax,%ax
80107877:	66 90                	xchg   %ax,%ax
80107879:	66 90                	xchg   %ax,%ax
8010787b:	66 90                	xchg   %ax,%ax
8010787d:	66 90                	xchg   %ax,%ax
8010787f:	90                   	nop

80107880 <getlev>:

// Design Document 1-1-2-3.
int
getlev(void)
{
    return proc->level_of_MLFQ;
80107880:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
#include "proc.h"

// Design Document 1-1-2-3.
int
getlev(void)
{
80107886:	55                   	push   %ebp
80107887:	89 e5                	mov    %esp,%ebp
    return proc->level_of_MLFQ;
}
80107889:	5d                   	pop    %ebp

// Design Document 1-1-2-3.
int
getlev(void)
{
    return proc->level_of_MLFQ;
8010788a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80107890:	c3                   	ret    
80107891:	eb 0d                	jmp    801078a0 <sys_getlev>
80107893:	90                   	nop
80107894:	90                   	nop
80107895:	90                   	nop
80107896:	90                   	nop
80107897:	90                   	nop
80107898:	90                   	nop
80107899:	90                   	nop
8010789a:	90                   	nop
8010789b:	90                   	nop
8010789c:	90                   	nop
8010789d:	90                   	nop
8010789e:	90                   	nop
8010789f:	90                   	nop

801078a0 <sys_getlev>:

// Design Document 1-1-2-3.
int
getlev(void)
{
    return proc->level_of_MLFQ;
801078a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
}

//Wrapper
int
sys_getlev(void)
{
801078a6:	55                   	push   %ebp
801078a7:	89 e5                	mov    %esp,%ebp
    return getlev();
}
801078a9:	5d                   	pop    %ebp

//Wrapper
int
sys_getlev(void)
{
    return getlev();
801078aa:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
801078b0:	c3                   	ret    

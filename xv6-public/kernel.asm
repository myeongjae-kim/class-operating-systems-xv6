
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
8010002d:	b8 50 2e 10 80       	mov    $0x80102e50,%eax
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
8010004c:	c7 44 24 04 e0 75 10 	movl   $0x801075e0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010005b:	e8 10 48 00 00       	call   80104870 <initlock>

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
80100094:	c7 44 24 04 e7 75 10 	movl   $0x801075e7,0x4(%esp)
8010009b:	80 
8010009c:	e8 bf 46 00 00       	call   80104760 <initsleeplock>
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
801000e6:	e8 05 48 00 00       	call   801048f0 <acquire>

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
80100161:	e8 ba 48 00 00       	call   80104a20 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 2f 46 00 00       	call   801047a0 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 92 1f 00 00       	call   80102110 <iderw>
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
80100188:	c7 04 24 ee 75 10 80 	movl   $0x801075ee,(%esp)
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
801001b0:	e8 8b 46 00 00       	call   80104840 <holdingsleep>
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
801001c4:	e9 47 1f 00 00       	jmp    80102110 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 ff 75 10 80 	movl   $0x801075ff,(%esp)
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
801001f1:	e8 4a 46 00 00       	call   80104840 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 fe 45 00 00       	call   80104800 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100209:	e8 e2 46 00 00       	call   801048f0 <acquire>
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
80100250:	e9 cb 47 00 00       	jmp    80104a20 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 06 76 10 80 	movl   $0x80107606,(%esp)
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
80100282:	e8 f9 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028e:	e8 5d 46 00 00       	call   801048f0 <acquire>
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
801002c4:	e8 97 3f 00 00       	call   80104260 <sleep>

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
80100312:	e8 09 47 00 00       	call   80104a20 <release>
  ilock(ip);
80100317:	89 3c 24             	mov    %edi,(%esp)
8010031a:	e8 91 13 00 00       	call   801016b0 <ilock>
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
8010032f:	e8 ec 46 00 00       	call   80104a20 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 74 13 00 00       	call   801016b0 <ilock>
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
80100382:	c7 04 24 0d 76 10 80 	movl   $0x8010760d,(%esp)
80100389:	89 44 24 04          	mov    %eax,0x4(%esp)
8010038d:	e8 be 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
80100392:	8b 45 08             	mov    0x8(%ebp),%eax
80100395:	89 04 24             	mov    %eax,(%esp)
80100398:	e8 b3 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
8010039d:	c7 04 24 06 7b 10 80 	movl   $0x80107b06,(%esp)
801003a4:	e8 a7 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a9:	8d 45 08             	lea    0x8(%ebp),%eax
801003ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003b0:	89 04 24             	mov    %eax,(%esp)
801003b3:	e8 d8 44 00 00       	call   80104890 <getcallerpcs>
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 29 76 10 80 	movl   $0x80107629,(%esp)
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
80100409:	e8 22 5c 00 00       	call   80106030 <uartputc>
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
801004b9:	e8 72 5b 00 00       	call   80106030 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 66 5b 00 00       	call   80106030 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 5a 5b 00 00       	call   80106030 <uartputc>
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
801004fc:	e8 0f 46 00 00       	call   80104b10 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 52 45 00 00       	call   80104a70 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 2d 76 10 80 	movl   $0x8010762d,(%esp)
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
80100599:	0f b6 92 58 76 10 80 	movzbl -0x7fef89a8(%edx),%edx
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
80100602:	e8 79 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010060e:	e8 dd 42 00 00       	call   801048f0 <acquire>
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
80100636:	e8 e5 43 00 00       	call   80104a20 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 6a 10 00 00       	call   801016b0 <ilock>

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
801006f3:	e8 28 43 00 00       	call   80104a20 <release>
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
80100760:	b8 40 76 10 80       	mov    $0x80107640,%eax
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
80100797:	e8 54 41 00 00       	call   801048f0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 47 76 10 80 	movl   $0x80107647,(%esp)
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
801007c5:	e8 26 41 00 00       	call   801048f0 <acquire>
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
80100827:	e8 f4 41 00 00       	call   80104a20 <release>
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
801008b2:	e8 99 3b 00 00       	call   80104450 <wakeup>
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
80100927:	e9 14 3c 00 00       	jmp    80104540 <procdump>
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
80100956:	c7 44 24 04 50 76 10 	movl   $0x80107650,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
80100965:	e8 06 3f 00 00       	call   80104870 <initlock>

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
8010098f:	e8 5c 28 00 00       	call   801031f0 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010099b:	00 
8010099c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801009a3:	e8 f8 18 00 00       	call   801022a0 <ioapicenable>
}
801009a8:	c9                   	leave  
801009a9:	c3                   	ret    
801009aa:	66 90                	xchg   %ax,%ax
801009ac:	66 90                	xchg   %ax,%ax
801009ae:	66 90                	xchg   %ax,%ax

801009b0 <exec>:
#include "x86.h"
#include "elf.h"

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
801009bc:	e8 bf 21 00 00       	call   80102b80 <begin_op>

  if((ip = namei(path)) == 0){
801009c1:	8b 45 08             	mov    0x8(%ebp),%eax
801009c4:	89 04 24             	mov    %eax,(%esp)
801009c7:	e8 14 15 00 00       	call   80101ee0 <namei>
801009cc:	85 c0                	test   %eax,%eax
801009ce:	89 c3                	mov    %eax,%ebx
801009d0:	74 37                	je     80100a09 <exec+0x59>
    end_op();
    return -1;
  }
  ilock(ip);
801009d2:	89 04 24             	mov    %eax,(%esp)
801009d5:	e8 d6 0c 00 00       	call   801016b0 <ilock>
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
801009f7:	e8 44 0f 00 00       	call   80101940 <readi>
801009fc:	83 f8 34             	cmp    $0x34,%eax
801009ff:	74 1f                	je     80100a20 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a01:	89 1c 24             	mov    %ebx,(%esp)
80100a04:	e8 e7 0e 00 00       	call   801018f0 <iunlockput>
    end_op();
80100a09:	e8 e2 21 00 00       	call   80102bf0 <end_op>
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
80100a2c:	e8 7f 64 00 00       	call   80106eb0 <setupkvm>
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
80100a8e:	e8 ad 0e 00 00       	call   80101940 <readi>
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
80100ad2:	e8 a9 66 00 00       	call   80107180 <allocuvm>
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
80100b13:	e8 a8 65 00 00       	call   801070c0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xb0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 62 67 00 00       	call   80107290 <freevm>
80100b2e:	e9 ce fe ff ff       	jmp    80100a01 <exec+0x51>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 b5 0d 00 00       	call   801018f0 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 ab 20 00 00       	call   80102bf0 <end_op>
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
80100b6c:	e8 0f 66 00 00       	call   80107180 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b79:	75 18                	jne    80100b93 <exec+0x1e3>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b7b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 07 67 00 00       	call   80107290 <freevm>
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
80100bad:	e8 5e 67 00 00       	call   80107310 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb5:	8b 00                	mov    (%eax),%eax
80100bb7:	85 c0                	test   %eax,%eax
80100bb9:	0f 84 66 01 00 00    	je     80100d25 <exec+0x375>
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
80100be9:	e8 a2 40 00 00       	call   80104c90 <strlen>
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
80100bfa:	e8 91 40 00 00       	call   80104c90 <strlen>
80100bff:	83 c0 01             	add    $0x1,%eax
80100c02:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c06:	8b 06                	mov    (%esi),%eax
80100c08:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c10:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c16:	89 04 24             	mov    %eax,(%esp)
80100c19:	e8 52 68 00 00       	call   80107470 <copyout>
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
80100c8c:	e8 df 67 00 00       	call   80107470 <copyout>
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
80100cd7:	e8 74 3f 00 00       	call   80104c50 <safestrcpy>

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
80100d11:	e8 5a 62 00 00       	call   80106f70 <switchuvm>
  freevm(oldpgdir);
80100d16:	89 34 24             	mov    %esi,(%esp)
80100d19:	e8 72 65 00 00       	call   80107290 <freevm>
  return 0;
80100d1e:	31 c0                	xor    %eax,%eax
80100d20:	e9 ee fc ff ff       	jmp    80100a13 <exec+0x63>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d25:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100d2b:	31 f6                	xor    %esi,%esi
80100d2d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d33:	e9 0e ff ff ff       	jmp    80100c46 <exec+0x296>
80100d38:	66 90                	xchg   %ax,%ax
80100d3a:	66 90                	xchg   %ax,%ax
80100d3c:	66 90                	xchg   %ax,%ax
80100d3e:	66 90                	xchg   %ax,%ax

80100d40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d46:	c7 44 24 04 69 76 10 	movl   $0x80107669,0x4(%esp)
80100d4d:	80 
80100d4e:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100d55:	e8 16 3b 00 00       	call   80104870 <initlock>
}
80100d5a:	c9                   	leave  
80100d5b:	c3                   	ret    
80100d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d64:	bb 14 10 11 80       	mov    $0x80111014,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d69:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d6c:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100d73:	e8 78 3b 00 00       	call   801048f0 <acquire>
80100d78:	eb 11                	jmp    80100d8b <filealloc+0x2b>
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d80:	83 c3 18             	add    $0x18,%ebx
80100d83:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
80100d89:	74 25                	je     80100db0 <filealloc+0x50>
    if(f->ref == 0){
80100d8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d8e:	85 c0                	test   %eax,%eax
80100d90:	75 ee                	jne    80100d80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d92:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d99:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100da0:	e8 7b 3c 00 00       	call   80104a20 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100da5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100da8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100daa:	5b                   	pop    %ebx
80100dab:	5d                   	pop    %ebp
80100dac:	c3                   	ret    
80100dad:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100db0:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100db7:	e8 64 3c 00 00       	call   80104a20 <release>
  return 0;
}
80100dbc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dbf:	31 c0                	xor    %eax,%eax
}
80100dc1:	5b                   	pop    %ebx
80100dc2:	5d                   	pop    %ebp
80100dc3:	c3                   	ret    
80100dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100dd0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	53                   	push   %ebx
80100dd4:	83 ec 14             	sub    $0x14,%esp
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dda:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100de1:	e8 0a 3b 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80100de6:	8b 43 04             	mov    0x4(%ebx),%eax
80100de9:	85 c0                	test   %eax,%eax
80100deb:	7e 1a                	jle    80100e07 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100ded:	83 c0 01             	add    $0x1,%eax
80100df0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100df3:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100dfa:	e8 21 3c 00 00       	call   80104a20 <release>
  return f;
}
80100dff:	83 c4 14             	add    $0x14,%esp
80100e02:	89 d8                	mov    %ebx,%eax
80100e04:	5b                   	pop    %ebx
80100e05:	5d                   	pop    %ebp
80100e06:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e07:	c7 04 24 70 76 10 80 	movl   $0x80107670,(%esp)
80100e0e:	e8 4d f5 ff ff       	call   80100360 <panic>
80100e13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e20 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	57                   	push   %edi
80100e24:	56                   	push   %esi
80100e25:	53                   	push   %ebx
80100e26:	83 ec 1c             	sub    $0x1c,%esp
80100e29:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e2c:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80100e33:	e8 b8 3a 00 00       	call   801048f0 <acquire>
  if(f->ref < 1)
80100e38:	8b 57 04             	mov    0x4(%edi),%edx
80100e3b:	85 d2                	test   %edx,%edx
80100e3d:	0f 8e 89 00 00 00    	jle    80100ecc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e43:	83 ea 01             	sub    $0x1,%edx
80100e46:	85 d2                	test   %edx,%edx
80100e48:	89 57 04             	mov    %edx,0x4(%edi)
80100e4b:	74 13                	je     80100e60 <fileclose+0x40>
    release(&ftable.lock);
80100e4d:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e54:	83 c4 1c             	add    $0x1c,%esp
80100e57:	5b                   	pop    %ebx
80100e58:	5e                   	pop    %esi
80100e59:	5f                   	pop    %edi
80100e5a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e5b:	e9 c0 3b 00 00       	jmp    80104a20 <release>
    return;
  }
  ff = *f;
80100e60:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e64:	8b 37                	mov    (%edi),%esi
80100e66:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e69:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e6f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e72:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e75:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7f:	e8 9c 3b 00 00       	call   80104a20 <release>

  if(ff.type == FD_PIPE)
80100e84:	83 fe 01             	cmp    $0x1,%esi
80100e87:	74 0f                	je     80100e98 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e89:	83 fe 02             	cmp    $0x2,%esi
80100e8c:	74 22                	je     80100eb0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e8e:	83 c4 1c             	add    $0x1c,%esp
80100e91:	5b                   	pop    %ebx
80100e92:	5e                   	pop    %esi
80100e93:	5f                   	pop    %edi
80100e94:	5d                   	pop    %ebp
80100e95:	c3                   	ret    
80100e96:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e98:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e9c:	89 1c 24             	mov    %ebx,(%esp)
80100e9f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ea3:	e8 f8 24 00 00       	call   801033a0 <pipeclose>
80100ea8:	eb e4                	jmp    80100e8e <fileclose+0x6e>
80100eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100eb0:	e8 cb 1c 00 00       	call   80102b80 <begin_op>
    iput(ff.ip);
80100eb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100eb8:	89 04 24             	mov    %eax,(%esp)
80100ebb:	e8 00 09 00 00       	call   801017c0 <iput>
    end_op();
  }
}
80100ec0:	83 c4 1c             	add    $0x1c,%esp
80100ec3:	5b                   	pop    %ebx
80100ec4:	5e                   	pop    %esi
80100ec5:	5f                   	pop    %edi
80100ec6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ec7:	e9 24 1d 00 00       	jmp    80102bf0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ecc:	c7 04 24 78 76 10 80 	movl   $0x80107678,(%esp)
80100ed3:	e8 88 f4 ff ff       	call   80100360 <panic>
80100ed8:	90                   	nop
80100ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 14             	sub    $0x14,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eed:	75 31                	jne    80100f20 <filestat+0x40>
    ilock(f->ip);
80100eef:	8b 43 10             	mov    0x10(%ebx),%eax
80100ef2:	89 04 24             	mov    %eax,(%esp)
80100ef5:	e8 b6 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100efa:	8b 45 0c             	mov    0xc(%ebp),%eax
80100efd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
80100f04:	89 04 24             	mov    %eax,(%esp)
80100f07:	e8 04 0a 00 00       	call   80101910 <stati>
    iunlock(f->ip);
80100f0c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f0f:	89 04 24             	mov    %eax,(%esp)
80100f12:	e8 69 08 00 00       	call   80101780 <iunlock>
    return 0;
  }
  return -1;
}
80100f17:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f1a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f1c:	5b                   	pop    %ebx
80100f1d:	5d                   	pop    %ebp
80100f1e:	c3                   	ret    
80100f1f:	90                   	nop
80100f20:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f28:	5b                   	pop    %ebx
80100f29:	5d                   	pop    %ebp
80100f2a:	c3                   	ret    
80100f2b:	90                   	nop
80100f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f30 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	57                   	push   %edi
80100f34:	56                   	push   %esi
80100f35:	53                   	push   %ebx
80100f36:	83 ec 1c             	sub    $0x1c,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f46:	74 68                	je     80100fb0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f48:	8b 03                	mov    (%ebx),%eax
80100f4a:	83 f8 01             	cmp    $0x1,%eax
80100f4d:	74 49                	je     80100f98 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f4f:	83 f8 02             	cmp    $0x2,%eax
80100f52:	75 63                	jne    80100fb7 <fileread+0x87>
    ilock(f->ip);
80100f54:	8b 43 10             	mov    0x10(%ebx),%eax
80100f57:	89 04 24             	mov    %eax,(%esp)
80100f5a:	e8 51 07 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f63:	8b 43 14             	mov    0x14(%ebx),%eax
80100f66:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f6a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f6e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f71:	89 04 24             	mov    %eax,(%esp)
80100f74:	e8 c7 09 00 00       	call   80101940 <readi>
80100f79:	85 c0                	test   %eax,%eax
80100f7b:	89 c6                	mov    %eax,%esi
80100f7d:	7e 03                	jle    80100f82 <fileread+0x52>
      f->off += r;
80100f7f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f82:	8b 43 10             	mov    0x10(%ebx),%eax
80100f85:	89 04 24             	mov    %eax,(%esp)
80100f88:	e8 f3 07 00 00       	call   80101780 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f8f:	83 c4 1c             	add    $0x1c,%esp
80100f92:	5b                   	pop    %ebx
80100f93:	5e                   	pop    %esi
80100f94:	5f                   	pop    %edi
80100f95:	5d                   	pop    %ebp
80100f96:	c3                   	ret    
80100f97:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f98:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f9b:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f9e:	83 c4 1c             	add    $0x1c,%esp
80100fa1:	5b                   	pop    %ebx
80100fa2:	5e                   	pop    %esi
80100fa3:	5f                   	pop    %edi
80100fa4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa5:	e9 a6 25 00 00       	jmp    80103550 <piperead>
80100faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fb5:	eb d8                	jmp    80100f8f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fb7:	c7 04 24 82 76 10 80 	movl   $0x80107682,(%esp)
80100fbe:	e8 9d f3 ff ff       	call   80100360 <panic>
80100fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fd0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 2c             	sub    $0x2c,%esp
80100fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fdc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fdf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fe2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fe5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fec:	0f 84 ae 00 00 00    	je     801010a0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100ff2:	8b 07                	mov    (%edi),%eax
80100ff4:	83 f8 01             	cmp    $0x1,%eax
80100ff7:	0f 84 c2 00 00 00    	je     801010bf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100ffd:	83 f8 02             	cmp    $0x2,%eax
80101000:	0f 85 d7 00 00 00    	jne    801010dd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101009:	31 db                	xor    %ebx,%ebx
8010100b:	85 c0                	test   %eax,%eax
8010100d:	7f 31                	jg     80101040 <filewrite+0x70>
8010100f:	e9 9c 00 00 00       	jmp    801010b0 <filewrite+0xe0>
80101014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101018:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010101b:	01 47 14             	add    %eax,0x14(%edi)
8010101e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101021:	89 0c 24             	mov    %ecx,(%esp)
80101024:	e8 57 07 00 00       	call   80101780 <iunlock>
      end_op();
80101029:	e8 c2 1b 00 00       	call   80102bf0 <end_op>
8010102e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101031:	39 f0                	cmp    %esi,%eax
80101033:	0f 85 98 00 00 00    	jne    801010d1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101039:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010103b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010103e:	7e 70                	jle    801010b0 <filewrite+0xe0>
      int n1 = n - i;
80101040:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101043:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101048:	29 de                	sub    %ebx,%esi
8010104a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101050:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101053:	e8 28 1b 00 00       	call   80102b80 <begin_op>
      ilock(f->ip);
80101058:	8b 47 10             	mov    0x10(%edi),%eax
8010105b:	89 04 24             	mov    %eax,(%esp)
8010105e:	e8 4d 06 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101063:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101067:	8b 47 14             	mov    0x14(%edi),%eax
8010106a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010106e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101071:	01 d8                	add    %ebx,%eax
80101073:	89 44 24 04          	mov    %eax,0x4(%esp)
80101077:	8b 47 10             	mov    0x10(%edi),%eax
8010107a:	89 04 24             	mov    %eax,(%esp)
8010107d:	e8 be 09 00 00       	call   80101a40 <writei>
80101082:	85 c0                	test   %eax,%eax
80101084:	7f 92                	jg     80101018 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101086:	8b 4f 10             	mov    0x10(%edi),%ecx
80101089:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010108c:	89 0c 24             	mov    %ecx,(%esp)
8010108f:	e8 ec 06 00 00       	call   80101780 <iunlock>
      end_op();
80101094:	e8 57 1b 00 00       	call   80102bf0 <end_op>

      if(r < 0)
80101099:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109c:	85 c0                	test   %eax,%eax
8010109e:	74 91                	je     80101031 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a8:	5b                   	pop    %ebx
801010a9:	5e                   	pop    %esi
801010aa:	5f                   	pop    %edi
801010ab:	5d                   	pop    %ebp
801010ac:	c3                   	ret    
801010ad:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010b0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010b3:	89 d8                	mov    %ebx,%eax
801010b5:	75 e9                	jne    801010a0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010b7:	83 c4 2c             	add    $0x2c,%esp
801010ba:	5b                   	pop    %ebx
801010bb:	5e                   	pop    %esi
801010bc:	5f                   	pop    %edi
801010bd:	5d                   	pop    %ebp
801010be:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bf:	8b 47 0c             	mov    0xc(%edi),%eax
801010c2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c5:	83 c4 2c             	add    $0x2c,%esp
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cc:	e9 5f 23 00 00       	jmp    80103430 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010d1:	c7 04 24 8b 76 10 80 	movl   $0x8010768b,(%esp)
801010d8:	e8 83 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010dd:	c7 04 24 91 76 10 80 	movl   $0x80107691,(%esp)
801010e4:	e8 77 f2 ff ff       	call   80100360 <panic>
801010e9:	66 90                	xchg   %ax,%ax
801010eb:	66 90                	xchg   %ax,%ax
801010ed:	66 90                	xchg   %ax,%ax
801010ef:	90                   	nop

801010f0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	57                   	push   %edi
801010f4:	56                   	push   %esi
801010f5:	53                   	push   %ebx
801010f6:	83 ec 2c             	sub    $0x2c,%esp
801010f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010fc:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101101:	85 c0                	test   %eax,%eax
80101103:	0f 84 8c 00 00 00    	je     80101195 <balloc+0xa5>
80101109:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101110:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101113:	89 f0                	mov    %esi,%eax
80101115:	c1 f8 0c             	sar    $0xc,%eax
80101118:	03 05 f8 19 11 80    	add    0x801119f8,%eax
8010111e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101122:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101125:	89 04 24             	mov    %eax,(%esp)
80101128:	e8 a3 ef ff ff       	call   801000d0 <bread>
8010112d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101130:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101135:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101138:	31 c0                	xor    %eax,%eax
8010113a:	eb 33                	jmp    8010116f <balloc+0x7f>
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101140:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101143:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101145:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101147:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010114a:	83 e1 07             	and    $0x7,%ecx
8010114d:	bf 01 00 00 00       	mov    $0x1,%edi
80101152:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101154:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101159:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115b:	0f b6 fb             	movzbl %bl,%edi
8010115e:	85 cf                	test   %ecx,%edi
80101160:	74 46                	je     801011a8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101162:	83 c0 01             	add    $0x1,%eax
80101165:	83 c6 01             	add    $0x1,%esi
80101168:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010116d:	74 05                	je     80101174 <balloc+0x84>
8010116f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101172:	72 cc                	jb     80101140 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101177:	89 04 24             	mov    %eax,(%esp)
8010117a:	e8 61 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010117f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101186:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101189:	3b 05 e0 19 11 80    	cmp    0x801119e0,%eax
8010118f:	0f 82 7b ff ff ff    	jb     80101110 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101195:	c7 04 24 9b 76 10 80 	movl   $0x8010769b,(%esp)
8010119c:	e8 bf f1 ff ff       	call   80100360 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011a8:	09 d9                	or     %ebx,%ecx
801011aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011ad:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011b1:	89 1c 24             	mov    %ebx,(%esp)
801011b4:	e8 67 1b 00 00       	call   80102d20 <log_write>
        brelse(bp);
801011b9:	89 1c 24             	mov    %ebx,(%esp)
801011bc:	e8 1f f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011c4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011c8:	89 04 24             	mov    %eax,(%esp)
801011cb:	e8 00 ef ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011d0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011d7:	00 
801011d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011df:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011e0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011e5:	89 04 24             	mov    %eax,(%esp)
801011e8:	e8 83 38 00 00       	call   80104a70 <memset>
  log_write(bp);
801011ed:	89 1c 24             	mov    %ebx,(%esp)
801011f0:	e8 2b 1b 00 00       	call   80102d20 <log_write>
  brelse(bp);
801011f5:	89 1c 24             	mov    %ebx,(%esp)
801011f8:	e8 e3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fd:	83 c4 2c             	add    $0x2c,%esp
80101200:	89 f0                	mov    %esi,%eax
80101202:	5b                   	pop    %ebx
80101203:	5e                   	pop    %esi
80101204:	5f                   	pop    %edi
80101205:	5d                   	pop    %ebp
80101206:	c3                   	ret    
80101207:	89 f6                	mov    %esi,%esi
80101209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	89 c7                	mov    %eax,%edi
80101216:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101217:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101219:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101222:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101229:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010122c:	e8 bf 36 00 00       	call   801048f0 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101231:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101234:	eb 14                	jmp    8010124a <iget+0x3a>
80101236:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101238:	85 f6                	test   %esi,%esi
8010123a:	74 3c                	je     80101278 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010123c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101242:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
80101248:	74 46                	je     80101290 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010124a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010124d:	85 c9                	test   %ecx,%ecx
8010124f:	7e e7                	jle    80101238 <iget+0x28>
80101251:	39 3b                	cmp    %edi,(%ebx)
80101253:	75 e3                	jne    80101238 <iget+0x28>
80101255:	39 53 04             	cmp    %edx,0x4(%ebx)
80101258:	75 de                	jne    80101238 <iget+0x28>
      ip->ref++;
8010125a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010125d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010125f:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101266:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101269:	e8 b2 37 00 00       	call   80104a20 <release>
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
8010126e:	83 c4 1c             	add    $0x1c,%esp
80101271:	89 f0                	mov    %esi,%eax
80101273:	5b                   	pop    %ebx
80101274:	5e                   	pop    %esi
80101275:	5f                   	pop    %edi
80101276:	5d                   	pop    %ebp
80101277:	c3                   	ret    
80101278:	85 c9                	test   %ecx,%ecx
8010127a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010127d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101283:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
80101289:	75 bf                	jne    8010124a <iget+0x3a>
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101290:	85 f6                	test   %esi,%esi
80101292:	74 29                	je     801012bd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101294:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101296:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101299:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
801012a0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012a7:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801012ae:	e8 6d 37 00 00       	call   80104a20 <release>

  return ip;
}
801012b3:	83 c4 1c             	add    $0x1c,%esp
801012b6:	89 f0                	mov    %esi,%eax
801012b8:	5b                   	pop    %ebx
801012b9:	5e                   	pop    %esi
801012ba:	5f                   	pop    %edi
801012bb:	5d                   	pop    %ebp
801012bc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012bd:	c7 04 24 b1 76 10 80 	movl   $0x801076b1,(%esp)
801012c4:	e8 97 f0 ff ff       	call   80100360 <panic>
801012c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012d0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c3                	mov    %eax,%ebx
801012d8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012db:	83 fa 0b             	cmp    $0xb,%edx
801012de:	77 18                	ja     801012f8 <bmap+0x28>
801012e0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012e3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012e6:	85 c0                	test   %eax,%eax
801012e8:	74 66                	je     80101350 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012ea:	83 c4 1c             	add    $0x1c,%esp
801012ed:	5b                   	pop    %ebx
801012ee:	5e                   	pop    %esi
801012ef:	5f                   	pop    %edi
801012f0:	5d                   	pop    %ebp
801012f1:	c3                   	ret    
801012f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012f8:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
801012fb:	83 fe 7f             	cmp    $0x7f,%esi
801012fe:	77 77                	ja     80101377 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101300:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101306:	85 c0                	test   %eax,%eax
80101308:	74 5e                	je     80101368 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010130a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010130e:	8b 03                	mov    (%ebx),%eax
80101310:	89 04 24             	mov    %eax,(%esp)
80101313:	e8 b8 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101318:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010131e:	8b 32                	mov    (%edx),%esi
80101320:	85 f6                	test   %esi,%esi
80101322:	75 19                	jne    8010133d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101324:	8b 03                	mov    (%ebx),%eax
80101326:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101329:	e8 c2 fd ff ff       	call   801010f0 <balloc>
8010132e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101331:	89 02                	mov    %eax,(%edx)
80101333:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101335:	89 3c 24             	mov    %edi,(%esp)
80101338:	e8 e3 19 00 00       	call   80102d20 <log_write>
    }
    brelse(bp);
8010133d:	89 3c 24             	mov    %edi,(%esp)
80101340:	e8 9b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101345:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101348:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
8010134f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101350:	8b 03                	mov    (%ebx),%eax
80101352:	e8 99 fd ff ff       	call   801010f0 <balloc>
80101357:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	83 c4 1c             	add    $0x1c,%esp
8010135d:	5b                   	pop    %ebx
8010135e:	5e                   	pop    %esi
8010135f:	5f                   	pop    %edi
80101360:	5d                   	pop    %ebp
80101361:	c3                   	ret    
80101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101368:	8b 03                	mov    (%ebx),%eax
8010136a:	e8 81 fd ff ff       	call   801010f0 <balloc>
8010136f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101375:	eb 93                	jmp    8010130a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101377:	c7 04 24 c1 76 10 80 	movl   $0x801076c1,(%esp)
8010137e:	e8 dd ef ff ff       	call   80100360 <panic>
80101383:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101390 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	56                   	push   %esi
80101394:	53                   	push   %ebx
80101395:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101398:	8b 45 08             	mov    0x8(%ebp),%eax
8010139b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013a2:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013a6:	89 04 24             	mov    %eax,(%esp)
801013a9:	e8 22 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013ae:	89 34 24             	mov    %esi,(%esp)
801013b1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013b8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013b9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013bb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013be:	89 44 24 04          	mov    %eax,0x4(%esp)
801013c2:	e8 49 37 00 00       	call   80104b10 <memmove>
  brelse(bp);
801013c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013ca:	83 c4 10             	add    $0x10,%esp
801013cd:	5b                   	pop    %ebx
801013ce:	5e                   	pop    %esi
801013cf:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013d0:	e9 0b ee ff ff       	jmp    801001e0 <brelse>
801013d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	57                   	push   %edi
801013e4:	89 d7                	mov    %edx,%edi
801013e6:	56                   	push   %esi
801013e7:	53                   	push   %ebx
801013e8:	89 c3                	mov    %eax,%ebx
801013ea:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013ed:	89 04 24             	mov    %eax,(%esp)
801013f0:	c7 44 24 04 e0 19 11 	movl   $0x801119e0,0x4(%esp)
801013f7:	80 
801013f8:	e8 93 ff ff ff       	call   80101390 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013fd:	89 fa                	mov    %edi,%edx
801013ff:	c1 ea 0c             	shr    $0xc,%edx
80101402:	03 15 f8 19 11 80    	add    0x801119f8,%edx
80101408:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010140b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101410:	89 54 24 04          	mov    %edx,0x4(%esp)
80101414:	e8 b7 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101419:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010141b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101421:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101423:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101426:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101429:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010142b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010142d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101432:	0f b6 c8             	movzbl %al,%ecx
80101435:	85 d9                	test   %ebx,%ecx
80101437:	74 20                	je     80101459 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101439:	f7 d3                	not    %ebx
8010143b:	21 c3                	and    %eax,%ebx
8010143d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101441:	89 34 24             	mov    %esi,(%esp)
80101444:	e8 d7 18 00 00       	call   80102d20 <log_write>
  brelse(bp);
80101449:	89 34 24             	mov    %esi,(%esp)
8010144c:	e8 8f ed ff ff       	call   801001e0 <brelse>
}
80101451:	83 c4 1c             	add    $0x1c,%esp
80101454:	5b                   	pop    %ebx
80101455:	5e                   	pop    %esi
80101456:	5f                   	pop    %edi
80101457:	5d                   	pop    %ebp
80101458:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101459:	c7 04 24 d4 76 10 80 	movl   $0x801076d4,(%esp)
80101460:	e8 fb ee ff ff       	call   80100360 <panic>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
80101479:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	c7 44 24 04 e7 76 10 	movl   $0x801076e7,0x4(%esp)
80101483:	80 
80101484:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010148b:	e8 e0 33 00 00       	call   80104870 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	89 1c 24             	mov    %ebx,(%esp)
80101493:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101499:	c7 44 24 04 ee 76 10 	movl   $0x801076ee,0x4(%esp)
801014a0:	80 
801014a1:	e8 ba 32 00 00       	call   80104760 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a6:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014ac:	75 e2                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }
  
  readsb(dev, &sb);
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	c7 44 24 04 e0 19 11 	movl   $0x801119e0,0x4(%esp)
801014b8:	80 
801014b9:	89 04 24             	mov    %eax,(%esp)
801014bc:	e8 cf fe ff ff       	call   80101390 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014c1:	a1 f8 19 11 80       	mov    0x801119f8,%eax
801014c6:	c7 04 24 44 77 10 80 	movl   $0x80107744,(%esp)
801014cd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014d1:	a1 f4 19 11 80       	mov    0x801119f4,%eax
801014d6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014da:	a1 f0 19 11 80       	mov    0x801119f0,%eax
801014df:	89 44 24 14          	mov    %eax,0x14(%esp)
801014e3:	a1 ec 19 11 80       	mov    0x801119ec,%eax
801014e8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014ec:	a1 e8 19 11 80       	mov    0x801119e8,%eax
801014f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014f5:	a1 e4 19 11 80       	mov    0x801119e4,%eax
801014fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801014fe:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101503:	89 44 24 04          	mov    %eax,0x4(%esp)
80101507:	e8 44 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010150c:	83 c4 24             	add    $0x24,%esp
8010150f:	5b                   	pop    %ebx
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
80101512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101520 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 2c             	sub    $0x2c,%esp
80101529:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010152c:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101533:	8b 7d 08             	mov    0x8(%ebp),%edi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 a2 00 00 00    	jbe    801015e1 <ialloc+0xc1>
8010153f:	be 01 00 00 00       	mov    $0x1,%esi
80101544:	bb 01 00 00 00       	mov    $0x1,%ebx
80101549:	eb 1a                	jmp    80101565 <ialloc+0x45>
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101550:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101556:	e8 85 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010155b:	89 de                	mov    %ebx,%esi
8010155d:	3b 1d e8 19 11 80    	cmp    0x801119e8,%ebx
80101563:	73 7c                	jae    801015e1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101565:	89 f0                	mov    %esi,%eax
80101567:	c1 e8 03             	shr    $0x3,%eax
8010156a:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101570:	89 3c 24             	mov    %edi,(%esp)
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 f0                	mov    %esi,%eax
80101580:	83 e0 07             	and    $0x7,%eax
80101583:	c1 e0 06             	shl    $0x6,%eax
80101586:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010158e:	75 c0                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101590:	89 0c 24             	mov    %ecx,(%esp)
80101593:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010159a:	00 
8010159b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015a2:	00 
801015a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	e8 c2 34 00 00       	call   80104a70 <memset>
      dip->type = type;
801015ae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015bb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015be:	89 14 24             	mov    %edx,(%esp)
801015c1:	e8 5a 17 00 00       	call   80102d20 <log_write>
      brelse(bp);
801015c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015c9:	89 14 24             	mov    %edx,(%esp)
801015cc:	e8 0f ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015d7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015d9:	5e                   	pop    %esi
801015da:	5f                   	pop    %edi
801015db:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015dc:	e9 2f fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015e1:	c7 04 24 f4 76 10 80 	movl   $0x801076f4,(%esp)
801015e8:	e8 73 ed ff ff       	call   80100360 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	83 ec 10             	sub    $0x10,%esp
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fe:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 f4 19 11 80    	add    0x801119f4,%eax
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 b7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101619:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010161c:	83 e2 07             	and    $0x7,%edx
8010161f:	c1 e2 06             	shl    $0x6,%edx
80101622:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101626:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101628:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010162f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101633:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101637:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010163b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010163f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101643:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101647:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010164b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010164e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101651:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101655:	89 14 24             	mov    %edx,(%esp)
80101658:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010165f:	00 
80101660:	e8 ab 34 00 00       	call   80104b10 <memmove>
  log_write(bp);
80101665:	89 34 24             	mov    %esi,(%esp)
80101668:	e8 b3 16 00 00       	call   80102d20 <log_write>
  brelse(bp);
8010166d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101670:	83 c4 10             	add    $0x10,%esp
80101673:	5b                   	pop    %ebx
80101674:	5e                   	pop    %esi
80101675:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101676:	e9 65 eb ff ff       	jmp    801001e0 <brelse>
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 14             	sub    $0x14,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101691:	e8 5a 32 00 00       	call   801048f0 <acquire>
  ip->ref++;
80101696:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010169a:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801016a1:	e8 7a 33 00 00       	call   80104a20 <release>
  return ip;
}
801016a6:	83 c4 14             	add    $0x14,%esp
801016a9:	89 d8                	mov    %ebx,%eax
801016ab:	5b                   	pop    %ebx
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax

801016b0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 10             	sub    $0x10,%esp
801016b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016bb:	85 db                	test   %ebx,%ebx
801016bd:	0f 84 b0 00 00 00    	je     80101773 <ilock+0xc3>
801016c3:	8b 43 08             	mov    0x8(%ebx),%eax
801016c6:	85 c0                	test   %eax,%eax
801016c8:	0f 8e a5 00 00 00    	jle    80101773 <ilock+0xc3>
    panic("ilock");

  acquiresleep(&ip->lock);
801016ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 c7 30 00 00       	call   801047a0 <acquiresleep>

  if(!(ip->flags & I_VALID)){
801016d9:	f6 43 4c 02          	testb  $0x2,0x4c(%ebx)
801016dd:	74 09                	je     801016e8 <ilock+0x38>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016df:	83 c4 10             	add    $0x10,%esp
801016e2:	5b                   	pop    %ebx
801016e3:	5e                   	pop    %esi
801016e4:	5d                   	pop    %ebp
801016e5:	c3                   	ret    
801016e6:	66 90                	xchg   %ax,%ax
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
801016eb:	c1 e8 03             	shr    $0x3,%eax
801016ee:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016f8:	8b 03                	mov    (%ebx),%eax
801016fa:	89 04 24             	mov    %eax,(%esp)
801016fd:	e8 ce e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101702:	8b 53 04             	mov    0x4(%ebx),%edx
80101705:	83 e2 07             	and    $0x7,%edx
80101708:	c1 e2 06             	shl    $0x6,%edx
8010170b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101711:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101714:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101717:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010171b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010171f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101723:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101727:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010172b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010172f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101733:	8b 42 fc             	mov    -0x4(%edx),%eax
80101736:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101739:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010173c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101740:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101747:	00 
80101748:	89 04 24             	mov    %eax,(%esp)
8010174b:	e8 c0 33 00 00       	call   80104b10 <memmove>
    brelse(bp);
80101750:	89 34 24             	mov    %esi,(%esp)
80101753:	e8 88 ea ff ff       	call   801001e0 <brelse>
    ip->flags |= I_VALID;
80101758:	83 4b 4c 02          	orl    $0x2,0x4c(%ebx)
    if(ip->type == 0)
8010175c:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101761:	0f 85 78 ff ff ff    	jne    801016df <ilock+0x2f>
      panic("ilock: no type");
80101767:	c7 04 24 0c 77 10 80 	movl   $0x8010770c,(%esp)
8010176e:	e8 ed eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101773:	c7 04 24 06 77 10 80 	movl   $0x80107706,(%esp)
8010177a:	e8 e1 eb ff ff       	call   80100360 <panic>
8010177f:	90                   	nop

80101780 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010178b:	85 db                	test   %ebx,%ebx
8010178d:	74 24                	je     801017b3 <iunlock+0x33>
8010178f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101792:	89 34 24             	mov    %esi,(%esp)
80101795:	e8 a6 30 00 00       	call   80104840 <holdingsleep>
8010179a:	85 c0                	test   %eax,%eax
8010179c:	74 15                	je     801017b3 <iunlock+0x33>
8010179e:	8b 43 08             	mov    0x8(%ebx),%eax
801017a1:	85 c0                	test   %eax,%eax
801017a3:	7e 0e                	jle    801017b3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017a5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	5b                   	pop    %ebx
801017ac:	5e                   	pop    %esi
801017ad:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ae:	e9 4d 30 00 00       	jmp    80104800 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017b3:	c7 04 24 1b 77 10 80 	movl   $0x8010771b,(%esp)
801017ba:	e8 a1 eb ff ff       	call   80100360 <panic>
801017bf:	90                   	nop

801017c0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 1c             	sub    $0x1c,%esp
801017c9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
801017cc:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801017d3:	e8 18 31 00 00       	call   801048f0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
801017d8:	8b 46 08             	mov    0x8(%esi),%eax
801017db:	83 f8 01             	cmp    $0x1,%eax
801017de:	74 20                	je     80101800 <iput+0x40>
    ip->type = 0;
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
801017e0:	83 e8 01             	sub    $0x1,%eax
801017e3:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
801017e6:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
801017ed:	83 c4 1c             	add    $0x1c,%esp
801017f0:	5b                   	pop    %ebx
801017f1:	5e                   	pop    %esi
801017f2:	5f                   	pop    %edi
801017f3:	5d                   	pop    %ebp
    iupdate(ip);
    acquire(&icache.lock);
    ip->flags = 0;
  }
  ip->ref--;
  release(&icache.lock);
801017f4:	e9 27 32 00 00       	jmp    80104a20 <release>
801017f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
// case it has to free the inode.
void
iput(struct inode *ip)
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101800:	f6 46 4c 02          	testb  $0x2,0x4c(%esi)
80101804:	74 da                	je     801017e0 <iput+0x20>
80101806:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
8010180b:	75 d3                	jne    801017e0 <iput+0x20>
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
8010180d:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101814:	89 f3                	mov    %esi,%ebx
80101816:	e8 05 32 00 00       	call   80104a20 <release>
8010181b:	8d 7e 30             	lea    0x30(%esi),%edi
8010181e:	eb 07                	jmp    80101827 <iput+0x67>
80101820:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101823:	39 fb                	cmp    %edi,%ebx
80101825:	74 19                	je     80101840 <iput+0x80>
    if(ip->addrs[i]){
80101827:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010182a:	85 d2                	test   %edx,%edx
8010182c:	74 f2                	je     80101820 <iput+0x60>
      bfree(ip->dev, ip->addrs[i]);
8010182e:	8b 06                	mov    (%esi),%eax
80101830:	e8 ab fb ff ff       	call   801013e0 <bfree>
      ip->addrs[i] = 0;
80101835:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010183c:	eb e2                	jmp    80101820 <iput+0x60>
8010183e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101840:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101846:	85 c0                	test   %eax,%eax
80101848:	75 3e                	jne    80101888 <iput+0xc8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010184a:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101851:	89 34 24             	mov    %esi,(%esp)
80101854:	e8 97 fd ff ff       	call   801015f0 <iupdate>
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
80101859:	31 c0                	xor    %eax,%eax
8010185b:	66 89 46 50          	mov    %ax,0x50(%esi)
    iupdate(ip);
8010185f:	89 34 24             	mov    %esi,(%esp)
80101862:	e8 89 fd ff ff       	call   801015f0 <iupdate>
    acquire(&icache.lock);
80101867:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010186e:	e8 7d 30 00 00       	call   801048f0 <acquire>
80101873:	8b 46 08             	mov    0x8(%esi),%eax
    ip->flags = 0;
80101876:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010187d:	e9 5e ff ff ff       	jmp    801017e0 <iput+0x20>
80101882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101888:	89 44 24 04          	mov    %eax,0x4(%esp)
8010188c:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010188e:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	89 04 24             	mov    %eax,(%esp)
80101893:	e8 38 e8 ff ff       	call   801000d0 <bread>
80101898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010189b:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010189e:	31 c0                	xor    %eax,%eax
801018a0:	eb 13                	jmp    801018b5 <iput+0xf5>
801018a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018a8:	83 c3 01             	add    $0x1,%ebx
801018ab:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018b1:	89 d8                	mov    %ebx,%eax
801018b3:	74 10                	je     801018c5 <iput+0x105>
      if(a[j])
801018b5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018b8:	85 d2                	test   %edx,%edx
801018ba:	74 ec                	je     801018a8 <iput+0xe8>
        bfree(ip->dev, a[j]);
801018bc:	8b 06                	mov    (%esi),%eax
801018be:	e8 1d fb ff ff       	call   801013e0 <bfree>
801018c3:	eb e3                	jmp    801018a8 <iput+0xe8>
    }
    brelse(bp);
801018c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018c8:	89 04 24             	mov    %eax,(%esp)
801018cb:	e8 10 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018d0:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018d6:	8b 06                	mov    (%esi),%eax
801018d8:	e8 03 fb ff ff       	call   801013e0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018dd:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018e4:	00 00 00 
801018e7:	e9 5e ff ff ff       	jmp    8010184a <iput+0x8a>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 14             	sub    $0x14,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018fa:	89 1c 24             	mov    %ebx,(%esp)
801018fd:	e8 7e fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101902:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101905:	83 c4 14             	add    $0x14,%esp
80101908:	5b                   	pop    %ebx
80101909:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010190a:	e9 b1 fe ff ff       	jmp    801017c0 <iput>
8010190f:	90                   	nop

80101910 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	8b 55 08             	mov    0x8(%ebp),%edx
80101916:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101919:	8b 0a                	mov    (%edx),%ecx
8010191b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010191e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101921:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101924:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101928:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010192b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010192f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101933:	8b 52 58             	mov    0x58(%edx),%edx
80101936:	89 50 10             	mov    %edx,0x10(%eax)
}
80101939:	5d                   	pop    %ebp
8010193a:	c3                   	ret    
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 2c             	sub    $0x2c,%esp
80101949:	8b 45 0c             	mov    0xc(%ebp),%eax
8010194c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010194f:	8b 75 10             	mov    0x10(%ebp),%esi
80101952:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101955:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101958:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010195d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101960:	0f 84 aa 00 00 00    	je     80101a10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101966:	8b 47 58             	mov    0x58(%edi),%eax
80101969:	39 f0                	cmp    %esi,%eax
8010196b:	0f 82 c7 00 00 00    	jb     80101a38 <readi+0xf8>
80101971:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101974:	89 da                	mov    %ebx,%edx
80101976:	01 f2                	add    %esi,%edx
80101978:	0f 82 ba 00 00 00    	jb     80101a38 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010197e:	89 c1                	mov    %eax,%ecx
80101980:	29 f1                	sub    %esi,%ecx
80101982:	39 d0                	cmp    %edx,%eax
80101984:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101987:	31 c0                	xor    %eax,%eax
80101989:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010198b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010198e:	74 70                	je     80101a00 <readi+0xc0>
80101990:	89 7d d8             	mov    %edi,-0x28(%ebp)
80101993:	89 c7                	mov    %eax,%edi
80101995:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101998:	8b 5d d8             	mov    -0x28(%ebp),%ebx
8010199b:	89 f2                	mov    %esi,%edx
8010199d:	c1 ea 09             	shr    $0x9,%edx
801019a0:	89 d8                	mov    %ebx,%eax
801019a2:	e8 29 f9 ff ff       	call   801012d0 <bmap>
801019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019ab:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019ad:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b2:	89 04 24             	mov    %eax,(%esp)
801019b5:	e8 16 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019bd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019bf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019c1:	89 f0                	mov    %esi,%eax
801019c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019c8:	29 c3                	sub    %eax,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019ca:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019ce:	39 cb                	cmp    %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019d7:	0f 47 d9             	cmova  %ecx,%ebx
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019da:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019de:	01 df                	add    %ebx,%edi
801019e0:	01 de                	add    %ebx,%esi
    for (int j = 0; j < min(m, 10); j++) {
      cprintf("%x ", bp->data[off%BSIZE+j]);
    }
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
801019e2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019e5:	89 04 24             	mov    %eax,(%esp)
801019e8:	e8 23 31 00 00       	call   80104b10 <memmove>
    brelse(bp);
801019ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019f0:	89 14 24             	mov    %edx,(%esp)
801019f3:	e8 e8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019fb:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019fe:	77 98                	ja     80101998 <readi+0x58>
    cprintf("\n");
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a03:	83 c4 2c             	add    $0x2c,%esp
80101a06:	5b                   	pop    %ebx
80101a07:	5e                   	pop    %esi
80101a08:	5f                   	pop    %edi
80101a09:	5d                   	pop    %ebp
80101a0a:	c3                   	ret    
80101a0b:	90                   	nop
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a10:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a14:	66 83 f8 09          	cmp    $0x9,%ax
80101a18:	77 1e                	ja     80101a38 <readi+0xf8>
80101a1a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101a21:	85 c0                	test   %eax,%eax
80101a23:	74 13                	je     80101a38 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a25:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a28:	89 75 10             	mov    %esi,0x10(%ebp)
    */
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a2b:	83 c4 2c             	add    $0x2c,%esp
80101a2e:	5b                   	pop    %ebx
80101a2f:	5e                   	pop    %esi
80101a30:	5f                   	pop    %edi
80101a31:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a32:	ff e0                	jmp    *%eax
80101a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a3d:	eb c4                	jmp    80101a03 <readi+0xc3>
80101a3f:	90                   	nop

80101a40 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	57                   	push   %edi
80101a44:	56                   	push   %esi
80101a45:	53                   	push   %ebx
80101a46:	83 ec 2c             	sub    $0x2c,%esp
80101a49:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a4f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a5a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a60:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a63:	0f 84 b7 00 00 00    	je     80101b20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a6f:	0f 82 e3 00 00 00    	jb     80101b58 <writei+0x118>
80101a75:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a78:	89 c8                	mov    %ecx,%eax
80101a7a:	01 f0                	add    %esi,%eax
80101a7c:	0f 82 d6 00 00 00    	jb     80101b58 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a82:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a87:	0f 87 cb 00 00 00    	ja     80101b58 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a8d:	85 c9                	test   %ecx,%ecx
80101a8f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a96:	74 77                	je     80101b0f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a98:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a9b:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a9d:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa2:	c1 ea 09             	shr    $0x9,%edx
80101aa5:	89 f8                	mov    %edi,%eax
80101aa7:	e8 24 f8 ff ff       	call   801012d0 <bmap>
80101aac:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ab0:	8b 07                	mov    (%edi),%eax
80101ab2:	89 04 24             	mov    %eax,(%esp)
80101ab5:	e8 16 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aba:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101abd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ac0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac5:	89 f0                	mov    %esi,%eax
80101ac7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101acc:	29 c3                	sub    %eax,%ebx
80101ace:	39 cb                	cmp    %ecx,%ebx
80101ad0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ad3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad7:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ad9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101add:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101ae1:	89 04 24             	mov    %eax,(%esp)
80101ae4:	e8 27 30 00 00       	call   80104b10 <memmove>
    log_write(bp);
80101ae9:	89 3c 24             	mov    %edi,(%esp)
80101aec:	e8 2f 12 00 00       	call   80102d20 <log_write>
    brelse(bp);
80101af1:	89 3c 24             	mov    %edi,(%esp)
80101af4:	e8 e7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101aff:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b02:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b05:	77 91                	ja     80101a98 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b07:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b0d:	72 39                	jb     80101b48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b12:	83 c4 2c             	add    $0x2c,%esp
80101b15:	5b                   	pop    %ebx
80101b16:	5e                   	pop    %esi
80101b17:	5f                   	pop    %edi
80101b18:	5d                   	pop    %ebp
80101b19:	c3                   	ret    
80101b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b24:	66 83 f8 09          	cmp    $0x9,%ax
80101b28:	77 2e                	ja     80101b58 <writei+0x118>
80101b2a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101b31:	85 c0                	test   %eax,%eax
80101b33:	74 23                	je     80101b58 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b35:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b38:	83 c4 2c             	add    $0x2c,%esp
80101b3b:	5b                   	pop    %ebx
80101b3c:	5e                   	pop    %esi
80101b3d:	5f                   	pop    %edi
80101b3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b3f:	ff e0                	jmp    *%eax
80101b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b4e:	89 04 24             	mov    %eax,(%esp)
80101b51:	e8 9a fa ff ff       	call   801015f0 <iupdate>
80101b56:	eb b7                	jmp    80101b0f <writei+0xcf>
  }
  return n;
}
80101b58:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b60:	5b                   	pop    %ebx
80101b61:	5e                   	pop    %esi
80101b62:	5f                   	pop    %edi
80101b63:	5d                   	pop    %ebp
80101b64:	c3                   	ret    
80101b65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b79:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b80:	00 
80101b81:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b85:	8b 45 08             	mov    0x8(%ebp),%eax
80101b88:	89 04 24             	mov    %eax,(%esp)
80101b8b:	e8 00 30 00 00       	call   80104b90 <strncmp>
}
80101b90:	c9                   	leave  
80101b91:	c3                   	ret    
80101b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 2c             	sub    $0x2c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 97 00 00 00    	jne    80101c4e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 73                	jmp    80101c38 <dirlookup+0x98>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 68                	jbe    80101c38 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bd7:	00 
80101bd8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bdc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101be0:	89 1c 24             	mov    %ebx,(%esp)
80101be3:	e8 58 fd ff ff       	call   80101940 <readi>
80101be8:	83 f8 10             	cmp    $0x10,%eax
80101beb:	75 55                	jne    80101c42 <dirlookup+0xa2>
      panic("dirlink read");
    if(de.inum == 0)
80101bed:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bf2:	74 d4                	je     80101bc8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bf4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bfe:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c05:	00 
80101c06:	89 04 24             	mov    %eax,(%esp)
80101c09:	e8 82 2f 00 00       	call   80104b90 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c0e:	85 c0                	test   %eax,%eax
80101c10:	75 b6                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c12:	8b 45 10             	mov    0x10(%ebp),%eax
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 05                	je     80101c1e <dirlookup+0x7e>
        *poff = off;
80101c19:	8b 45 10             	mov    0x10(%ebp),%eax
80101c1c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c1e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c22:	8b 03                	mov    (%ebx),%eax
80101c24:	e8 e7 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c29:	83 c4 2c             	add    $0x2c,%esp
80101c2c:	5b                   	pop    %ebx
80101c2d:	5e                   	pop    %esi
80101c2e:	5f                   	pop    %edi
80101c2f:	5d                   	pop    %ebp
80101c30:	c3                   	ret    
80101c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c38:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c3b:	31 c0                	xor    %eax,%eax
}
80101c3d:	5b                   	pop    %ebx
80101c3e:	5e                   	pop    %esi
80101c3f:	5f                   	pop    %edi
80101c40:	5d                   	pop    %ebp
80101c41:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101c42:	c7 04 24 35 77 10 80 	movl   $0x80107735,(%esp)
80101c49:	e8 12 e7 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c4e:	c7 04 24 23 77 10 80 	movl   $0x80107723,(%esp)
80101c55:	e8 06 e7 ff ff       	call   80100360 <panic>
80101c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c60 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	89 cf                	mov    %ecx,%edi
80101c66:	56                   	push   %esi
80101c67:	53                   	push   %ebx
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c73:	0f 84 51 01 00 00    	je     80101dca <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101c7f:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c82:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101c89:	e8 62 2c 00 00       	call   801048f0 <acquire>
  ip->ref++;
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c92:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101c99:	e8 82 2d 00 00       	call   80104a20 <release>
80101c9e:	eb 03                	jmp    80101ca3 <namex+0x43>
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101ca0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101ca3:	0f b6 03             	movzbl (%ebx),%eax
80101ca6:	3c 2f                	cmp    $0x2f,%al
80101ca8:	74 f6                	je     80101ca0 <namex+0x40>
    path++;
  if(*path == 0)
80101caa:	84 c0                	test   %al,%al
80101cac:	0f 84 ed 00 00 00    	je     80101d9f <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cb2:	0f b6 03             	movzbl (%ebx),%eax
80101cb5:	89 da                	mov    %ebx,%edx
80101cb7:	84 c0                	test   %al,%al
80101cb9:	0f 84 b1 00 00 00    	je     80101d70 <namex+0x110>
80101cbf:	3c 2f                	cmp    $0x2f,%al
80101cc1:	75 0f                	jne    80101cd2 <namex+0x72>
80101cc3:	e9 a8 00 00 00       	jmp    80101d70 <namex+0x110>
80101cc8:	3c 2f                	cmp    $0x2f,%al
80101cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cd0:	74 0a                	je     80101cdc <namex+0x7c>
    path++;
80101cd2:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cd5:	0f b6 02             	movzbl (%edx),%eax
80101cd8:	84 c0                	test   %al,%al
80101cda:	75 ec                	jne    80101cc8 <namex+0x68>
80101cdc:	89 d1                	mov    %edx,%ecx
80101cde:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101ce0:	83 f9 0d             	cmp    $0xd,%ecx
80101ce3:	0f 8e 8f 00 00 00    	jle    80101d78 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101ce9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101ced:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101cf4:	00 
80101cf5:	89 3c 24             	mov    %edi,(%esp)
80101cf8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cfb:	e8 10 2e 00 00       	call   80104b10 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d00:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d03:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d05:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d08:	75 0e                	jne    80101d18 <namex+0xb8>
80101d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d10:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d18:	89 34 24             	mov    %esi,(%esp)
80101d1b:	e8 90 f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d20:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d25:	0f 85 85 00 00 00    	jne    80101db0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d2e:	85 d2                	test   %edx,%edx
80101d30:	74 09                	je     80101d3b <namex+0xdb>
80101d32:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d35:	0f 84 a5 00 00 00    	je     80101de0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d42:	00 
80101d43:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d47:	89 34 24             	mov    %esi,(%esp)
80101d4a:	e8 51 fe ff ff       	call   80101ba0 <dirlookup>
80101d4f:	85 c0                	test   %eax,%eax
80101d51:	74 5d                	je     80101db0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d53:	89 34 24             	mov    %esi,(%esp)
80101d56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d59:	e8 22 fa ff ff       	call   80101780 <iunlock>
  iput(ip);
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 5a fa ff ff       	call   801017c0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	89 c6                	mov    %eax,%esi
80101d6b:	e9 33 ff ff ff       	jmp    80101ca3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d70:	31 c9                	xor    %ecx,%ecx
80101d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d78:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d7c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d80:	89 3c 24             	mov    %edi,(%esp)
80101d83:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d86:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d89:	e8 82 2d 00 00       	call   80104b10 <memmove>
    name[len] = 0;
80101d8e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d91:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d94:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d98:	89 d3                	mov    %edx,%ebx
80101d9a:	e9 66 ff ff ff       	jmp    80101d05 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101da2:	85 c0                	test   %eax,%eax
80101da4:	75 4c                	jne    80101df2 <namex+0x192>
80101da6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101da8:	83 c4 2c             	add    $0x2c,%esp
80101dab:	5b                   	pop    %ebx
80101dac:	5e                   	pop    %esi
80101dad:	5f                   	pop    %edi
80101dae:	5d                   	pop    %ebp
80101daf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101db0:	89 34 24             	mov    %esi,(%esp)
80101db3:	e8 c8 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101db8:	89 34 24             	mov    %esi,(%esp)
80101dbb:	e8 00 fa ff ff       	call   801017c0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dc3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc5:	5b                   	pop    %ebx
80101dc6:	5e                   	pop    %esi
80101dc7:	5f                   	pop    %edi
80101dc8:	5d                   	pop    %ebp
80101dc9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dca:	ba 01 00 00 00       	mov    $0x1,%edx
80101dcf:	b8 01 00 00 00       	mov    $0x1,%eax
80101dd4:	e8 37 f4 ff ff       	call   80101210 <iget>
80101dd9:	89 c6                	mov    %eax,%esi
80101ddb:	e9 c3 fe ff ff       	jmp    80101ca3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 98 f9 ff ff       	call   80101780 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de8:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101deb:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ded:	5b                   	pop    %ebx
80101dee:	5e                   	pop    %esi
80101def:	5f                   	pop    %edi
80101df0:	5d                   	pop    %ebp
80101df1:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101df2:	89 34 24             	mov    %esi,(%esp)
80101df5:	e8 c6 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101dfa:	31 c0                	xor    %eax,%eax
80101dfc:	eb aa                	jmp    80101da8 <namex+0x148>
80101dfe:	66 90                	xchg   %ax,%ax

80101e00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 2c             	sub    $0x2c,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e16:	00 
80101e17:	89 1c 24             	mov    %ebx,(%esp)
80101e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e1e:	e8 7d fd ff ff       	call   80101ba0 <dirlookup>
80101e23:	85 c0                	test   %eax,%eax
80101e25:	0f 85 8b 00 00 00    	jne    80101eb6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e2b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e2e:	31 ff                	xor    %edi,%edi
80101e30:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e33:	85 c0                	test   %eax,%eax
80101e35:	75 13                	jne    80101e4a <dirlink+0x4a>
80101e37:	eb 35                	jmp    80101e6e <dirlink+0x6e>
80101e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e40:	8d 57 10             	lea    0x10(%edi),%edx
80101e43:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e46:	89 d7                	mov    %edx,%edi
80101e48:	76 24                	jbe    80101e6e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e4a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e51:	00 
80101e52:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e56:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e5a:	89 1c 24             	mov    %ebx,(%esp)
80101e5d:	e8 de fa ff ff       	call   80101940 <readi>
80101e62:	83 f8 10             	cmp    $0x10,%eax
80101e65:	75 5e                	jne    80101ec5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e67:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6c:	75 d2                	jne    80101e40 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e71:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e78:	00 
80101e79:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e7d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e80:	89 04 24             	mov    %eax,(%esp)
80101e83:	e8 78 2d 00 00       	call   80104c00 <strncpy>
  de.inum = inum;
80101e88:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e8b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e92:	00 
80101e93:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e97:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e9b:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e9e:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ea2:	e8 99 fb ff ff       	call   80101a40 <writei>
80101ea7:	83 f8 10             	cmp    $0x10,%eax
80101eaa:	75 25                	jne    80101ed1 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101eac:	31 c0                	xor    %eax,%eax
}
80101eae:	83 c4 2c             	add    $0x2c,%esp
80101eb1:	5b                   	pop    %ebx
80101eb2:	5e                   	pop    %esi
80101eb3:	5f                   	pop    %edi
80101eb4:	5d                   	pop    %ebp
80101eb5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101eb6:	89 04 24             	mov    %eax,(%esp)
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec3:	eb e9                	jmp    80101eae <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ec5:	c7 04 24 35 77 10 80 	movl   $0x80107735,(%esp)
80101ecc:	e8 8f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ed1:	c7 04 24 52 7d 10 80 	movl   $0x80107d52,(%esp)
80101ed8:	e8 83 e4 ff ff       	call   80100360 <panic>
80101edd:	8d 76 00             	lea    0x0(%esi),%esi

80101ee0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ee0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
}
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f00:	55                   	push   %ebp
  return namex(path, 1, name);
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f06:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f0e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	56                   	push   %esi
80101f24:	89 c6                	mov    %eax,%esi
80101f26:	53                   	push   %ebx
80101f27:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f2a:	85 c0                	test   %eax,%eax
80101f2c:	0f 84 99 00 00 00    	je     80101fcb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f32:	8b 48 08             	mov    0x8(%eax),%ecx
80101f35:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f3b:	0f 87 7e 00 00 00    	ja     80101fbf <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f41:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f49:	83 e0 c0             	and    $0xffffffc0,%eax
80101f4c:	3c 40                	cmp    $0x40,%al
80101f4e:	75 f8                	jne    80101f48 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f50:	31 db                	xor    %ebx,%ebx
80101f52:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f57:	89 d8                	mov    %ebx,%eax
80101f59:	ee                   	out    %al,(%dx)
80101f5a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f5f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f64:	ee                   	out    %al,(%dx)
80101f65:	0f b6 c1             	movzbl %cl,%eax
80101f68:	b2 f3                	mov    $0xf3,%dl
80101f6a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f6b:	89 c8                	mov    %ecx,%eax
80101f6d:	b2 f4                	mov    $0xf4,%dl
80101f6f:	c1 f8 08             	sar    $0x8,%eax
80101f72:	ee                   	out    %al,(%dx)
80101f73:	b2 f5                	mov    $0xf5,%dl
80101f75:	89 d8                	mov    %ebx,%eax
80101f77:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f78:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f7c:	b2 f6                	mov    $0xf6,%dl
80101f7e:	83 e0 01             	and    $0x1,%eax
80101f81:	c1 e0 04             	shl    $0x4,%eax
80101f84:	83 c8 e0             	or     $0xffffffe0,%eax
80101f87:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f88:	f6 06 04             	testb  $0x4,(%esi)
80101f8b:	75 13                	jne    80101fa0 <idestart+0x80>
80101f8d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f92:	b8 20 00 00 00       	mov    $0x20,%eax
80101f97:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f98:	83 c4 10             	add    $0x10,%esp
80101f9b:	5b                   	pop    %ebx
80101f9c:	5e                   	pop    %esi
80101f9d:	5d                   	pop    %ebp
80101f9e:	c3                   	ret    
80101f9f:	90                   	nop
80101fa0:	b2 f7                	mov    $0xf7,%dl
80101fa2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fa7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fa8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fad:	83 c6 5c             	add    $0x5c,%esi
80101fb0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fb5:	fc                   	cld    
80101fb6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5d                   	pop    %ebp
80101fbe:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fbf:	c7 04 24 a0 77 10 80 	movl   $0x801077a0,(%esp)
80101fc6:	e8 95 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fcb:	c7 04 24 97 77 10 80 	movl   $0x80107797,(%esp)
80101fd2:	e8 89 e3 ff ff       	call   80100360 <panic>
80101fd7:	89 f6                	mov    %esi,%esi
80101fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fe0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80101fe6:	c7 44 24 04 b2 77 10 	movl   $0x801077b2,0x4(%esp)
80101fed:	80 
80101fee:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80101ff5:	e8 76 28 00 00       	call   80104870 <initlock>
  picenable(IRQ_IDE);
80101ffa:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102001:	e8 ea 11 00 00       	call   801031f0 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102006:	a1 80 3d 11 80       	mov    0x80113d80,%eax
8010200b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102012:	83 e8 01             	sub    $0x1,%eax
80102015:	89 44 24 04          	mov    %eax,0x4(%esp)
80102019:	e8 82 02 00 00       	call   801022a0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010201e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102023:	90                   	nop
80102024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102028:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102029:	83 e0 c0             	and    $0xffffffc0,%eax
8010202c:	3c 40                	cmp    $0x40,%al
8010202e:	75 f8                	jne    80102028 <ideinit+0x48>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102030:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102035:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203a:	ee                   	out    %al,(%dx)
8010203b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102040:	b2 f7                	mov    $0xf7,%dl
80102042:	eb 09                	jmp    8010204d <ideinit+0x6d>
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102048:	83 e9 01             	sub    $0x1,%ecx
8010204b:	74 0f                	je     8010205c <ideinit+0x7c>
8010204d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010204e:	84 c0                	test   %al,%al
80102050:	74 f6                	je     80102048 <ideinit+0x68>
      havedisk1 = 1;
80102052:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102059:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010205c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102061:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102066:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102079:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102080:	e8 6b 28 00 00       	call   801048f0 <acquire>
  if((b = idequeue) == 0){
80102085:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010208b:	85 db                	test   %ebx,%ebx
8010208d:	74 30                	je     801020bf <ideintr+0x4f>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
8010208f:	8b 43 58             	mov    0x58(%ebx),%eax
80102092:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102097:	8b 33                	mov    (%ebx),%esi
80102099:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010209f:	74 37                	je     801020d8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020a1:	83 e6 fb             	and    $0xfffffffb,%esi
801020a4:	83 ce 02             	or     $0x2,%esi
801020a7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020a9:	89 1c 24             	mov    %ebx,(%esp)
801020ac:	e8 9f 23 00 00       	call   80104450 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020b1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801020b6:	85 c0                	test   %eax,%eax
801020b8:	74 05                	je     801020bf <ideintr+0x4f>
    idestart(idequeue);
801020ba:	e8 61 fe ff ff       	call   80101f20 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
801020bf:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
801020c6:	e8 55 29 00 00       	call   80104a20 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020cb:	83 c4 1c             	add    $0x1c,%esp
801020ce:	5b                   	pop    %ebx
801020cf:	5e                   	pop    %esi
801020d0:	5f                   	pop    %edi
801020d1:	5d                   	pop    %ebp
801020d2:	c3                   	ret    
801020d3:	90                   	nop
801020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020dd:	8d 76 00             	lea    0x0(%esi),%esi
801020e0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c1                	mov    %eax,%ecx
801020e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020e6:	80 f9 40             	cmp    $0x40,%cl
801020e9:	75 f5                	jne    801020e0 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020eb:	a8 21                	test   $0x21,%al
801020ed:	75 b2                	jne    801020a1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fc:	fc                   	cld    
801020fd:	f3 6d                	rep insl (%dx),%es:(%edi)
801020ff:	8b 33                	mov    (%ebx),%esi
80102101:	eb 9e                	jmp    801020a1 <ideintr+0x31>
80102103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102110 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
80102114:	83 ec 14             	sub    $0x14,%esp
80102117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010211a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010211d:	89 04 24             	mov    %eax,(%esp)
80102120:	e8 1b 27 00 00       	call   80104840 <holdingsleep>
80102125:	85 c0                	test   %eax,%eax
80102127:	0f 84 9e 00 00 00    	je     801021cb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010212d:	8b 03                	mov    (%ebx),%eax
8010212f:	83 e0 06             	and    $0x6,%eax
80102132:	83 f8 02             	cmp    $0x2,%eax
80102135:	0f 84 a8 00 00 00    	je     801021e3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010213b:	8b 53 04             	mov    0x4(%ebx),%edx
8010213e:	85 d2                	test   %edx,%edx
80102140:	74 0d                	je     8010214f <iderw+0x3f>
80102142:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102147:	85 c0                	test   %eax,%eax
80102149:	0f 84 88 00 00 00    	je     801021d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010214f:	c7 04 24 80 b5 10 80 	movl   $0x8010b580,(%esp)
80102156:	e8 95 27 00 00       	call   801048f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010215b:	a1 64 b5 10 80       	mov    0x8010b564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102160:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102167:	85 c0                	test   %eax,%eax
80102169:	75 07                	jne    80102172 <iderw+0x62>
8010216b:	eb 4e                	jmp    801021bb <iderw+0xab>
8010216d:	8d 76 00             	lea    0x0(%esi),%esi
80102170:	89 d0                	mov    %edx,%eax
80102172:	8b 50 58             	mov    0x58(%eax),%edx
80102175:	85 d2                	test   %edx,%edx
80102177:	75 f7                	jne    80102170 <iderw+0x60>
80102179:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010217c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010217e:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80102184:	74 3c                	je     801021c2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102186:	8b 03                	mov    (%ebx),%eax
80102188:	83 e0 06             	and    $0x6,%eax
8010218b:	83 f8 02             	cmp    $0x2,%eax
8010218e:	74 1a                	je     801021aa <iderw+0x9a>
    sleep(b, &idelock);
80102190:	c7 44 24 04 80 b5 10 	movl   $0x8010b580,0x4(%esp)
80102197:	80 
80102198:	89 1c 24             	mov    %ebx,(%esp)
8010219b:	e8 c0 20 00 00       	call   80104260 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a0:	8b 13                	mov    (%ebx),%edx
801021a2:	83 e2 06             	and    $0x6,%edx
801021a5:	83 fa 02             	cmp    $0x2,%edx
801021a8:	75 e6                	jne    80102190 <iderw+0x80>
    sleep(b, &idelock);
  }

  release(&idelock);
801021aa:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021b1:	83 c4 14             	add    $0x14,%esp
801021b4:	5b                   	pop    %ebx
801021b5:	5d                   	pop    %ebp
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
801021b6:	e9 65 28 00 00       	jmp    80104a20 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bb:	b8 64 b5 10 80       	mov    $0x8010b564,%eax
801021c0:	eb ba                	jmp    8010217c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021c2:	89 d8                	mov    %ebx,%eax
801021c4:	e8 57 fd ff ff       	call   80101f20 <idestart>
801021c9:	eb bb                	jmp    80102186 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021cb:	c7 04 24 b6 77 10 80 	movl   $0x801077b6,(%esp)
801021d2:	e8 89 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021d7:	c7 04 24 e1 77 10 80 	movl   $0x801077e1,(%esp)
801021de:	e8 7d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021e3:	c7 04 24 cc 77 10 80 	movl   $0x801077cc,(%esp)
801021ea:	e8 71 e1 ff ff       	call   80100360 <panic>
801021ef:	90                   	nop

801021f0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801021f0:	a1 84 37 11 80       	mov    0x80113784,%eax
801021f5:	85 c0                	test   %eax,%eax
801021f7:	0f 84 9b 00 00 00    	je     80102298 <ioapicinit+0xa8>
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fd:	55                   	push   %ebp
801021fe:	89 e5                	mov    %esp,%ebp
80102200:	56                   	push   %esi
80102201:	53                   	push   %ebx
80102202:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102205:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
8010220c:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010220f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102216:	00 00 00 
  return ioapic->data;
80102219:	8b 15 54 36 11 80    	mov    0x80113654,%edx
8010221f:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102222:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102228:	8b 1d 54 36 11 80    	mov    0x80113654,%ebx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010222e:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102235:	c1 e8 10             	shr    $0x10,%eax
80102238:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010223b:	8b 43 10             	mov    0x10(%ebx),%eax
  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
8010223e:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102241:	39 c2                	cmp    %eax,%edx
80102243:	74 12                	je     80102257 <ioapicinit+0x67>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102245:	c7 04 24 00 78 10 80 	movl   $0x80107800,(%esp)
8010224c:	e8 ff e3 ff ff       	call   80100650 <cprintf>
80102251:	8b 1d 54 36 11 80    	mov    0x80113654,%ebx
80102257:	ba 10 00 00 00       	mov    $0x10,%edx
8010225c:	31 c0                	xor    %eax,%eax
8010225e:	eb 02                	jmp    80102262 <ioapicinit+0x72>
80102260:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102262:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
80102264:	8b 1d 54 36 11 80    	mov    0x80113654,%ebx
8010226a:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010226d:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102273:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102276:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102279:	8d 4a 01             	lea    0x1(%edx),%ecx
8010227c:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227f:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102281:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102287:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102289:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102290:	7d ce                	jge    80102260 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102292:	83 c4 10             	add    $0x10,%esp
80102295:	5b                   	pop    %ebx
80102296:	5e                   	pop    %esi
80102297:	5d                   	pop    %ebp
80102298:	f3 c3                	repz ret 
8010229a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
801022a0:	8b 15 84 37 11 80    	mov    0x80113784,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022a6:	55                   	push   %ebp
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
801022ac:	85 d2                	test   %edx,%edx
801022ae:	74 29                	je     801022d9 <ioapicenable+0x39>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022b0:	8d 48 20             	lea    0x20(%eax),%ecx
801022b3:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b7:	a1 54 36 11 80       	mov    0x80113654,%eax
801022bc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801022be:	a1 54 36 11 80       	mov    0x80113654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c3:	83 c2 01             	add    $0x1,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022c6:	89 48 10             	mov    %ecx,0x10(%eax)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022cc:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801022ce:	a1 54 36 11 80       	mov    0x80113654,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d3:	c1 e1 18             	shl    $0x18,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022d6:	89 48 10             	mov    %ecx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022d9:	5d                   	pop    %ebp
801022da:	c3                   	ret    
801022db:	66 90                	xchg   %ax,%ax
801022dd:	66 90                	xchg   %ax,%ax
801022df:	90                   	nop

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 14             	sub    $0x14,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 7c                	jne    8010236e <kfree+0x8e>
801022f2:	81 fb 48 6c 11 80    	cmp    $0x80116c48,%ebx
801022f8:	72 74                	jb     8010236e <kfree+0x8e>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 67                	ja     8010236e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010230e:	00 
8010230f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102316:	00 
80102317:	89 1c 24             	mov    %ebx,(%esp)
8010231a:	e8 51 27 00 00       	call   80104a70 <memset>

  if(kmem.use_lock)
8010231f:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102325:	85 d2                	test   %edx,%edx
80102327:	75 37                	jne    80102360 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102329:	a1 98 36 11 80       	mov    0x80113698,%eax
8010232e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102330:	a1 94 36 11 80       	mov    0x80113694,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102335:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
8010233b:	85 c0                	test   %eax,%eax
8010233d:	75 09                	jne    80102348 <kfree+0x68>
    release(&kmem.lock);
}
8010233f:	83 c4 14             	add    $0x14,%esp
80102342:	5b                   	pop    %ebx
80102343:	5d                   	pop    %ebp
80102344:	c3                   	ret    
80102345:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102348:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102354:	e9 c7 26 00 00       	jmp    80104a20 <release>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
80102367:	e8 84 25 00 00       	call   801048f0 <acquire>
8010236c:	eb bb                	jmp    80102329 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010236e:	c7 04 24 32 78 10 80 	movl   $0x80107832,(%esp)
80102375:	e8 e6 df ff ff       	call   80100360 <panic>
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102380 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102388:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010238b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102394:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023a0:	39 de                	cmp    %ebx,%esi
801023a2:	73 08                	jae    801023ac <freerange+0x2c>
801023a4:	eb 18                	jmp    801023be <freerange+0x3e>
801023a6:	66 90                	xchg   %ax,%ax
801023a8:	89 da                	mov    %ebx,%edx
801023aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ac:	89 14 24             	mov    %edx,(%esp)
801023af:	e8 2c ff ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ba:	39 f0                	cmp    %esi,%eax
801023bc:	76 ea                	jbe    801023a8 <freerange+0x28>
    kfree(p);
}
801023be:	83 c4 10             	add    $0x10,%esp
801023c1:	5b                   	pop    %ebx
801023c2:	5e                   	pop    %esi
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	83 ec 10             	sub    $0x10,%esp
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023db:	c7 44 24 04 38 78 10 	movl   $0x80107838,0x4(%esp)
801023e2:	80 
801023e3:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
801023ea:	e8 81 24 00 00       	call   80104870 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023f2:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
801023f9:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102402:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102408:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010240e:	39 de                	cmp    %ebx,%esi
80102410:	73 0a                	jae    8010241c <kinit1+0x4c>
80102412:	eb 1a                	jmp    8010242e <kinit1+0x5e>
80102414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102418:	89 da                	mov    %ebx,%edx
8010241a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010241c:	89 14 24             	mov    %edx,(%esp)
8010241f:	e8 bc fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102424:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010242a:	39 c6                	cmp    %eax,%esi
8010242c:	73 ea                	jae    80102418 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010242e:	83 c4 10             	add    $0x10,%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret    
80102435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010244b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102454:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 08                	jae    8010246c <kinit2+0x2c>
80102464:	eb 18                	jmp    8010247e <kinit2+0x3e>
80102466:	66 90                	xchg   %ax,%ax
80102468:	89 da                	mov    %ebx,%edx
8010246a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010246c:	89 14 24             	mov    %edx,(%esp)
8010246f:	e8 6c fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102474:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010247a:	39 c6                	cmp    %eax,%esi
8010247c:	73 ea                	jae    80102468 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010247e:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
80102485:	00 00 00 
}
80102488:	83 c4 10             	add    $0x10,%esp
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5d                   	pop    %ebp
8010248e:	c3                   	ret    
8010248f:	90                   	nop

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 94 36 11 80       	mov    0x80113694,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d 98 36 11 80    	mov    0x80113698,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 08                	je     801024b2 <kalloc+0x22>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 98 36 11 80    	mov    %edx,0x80113698
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 0c                	je     801024c2 <kalloc+0x32>
    release(&kmem.lock);
801024b6:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
801024bd:	e8 5e 25 00 00       	call   80104a20 <release>
  return (char*)r;
}
801024c2:	83 c4 14             	add    $0x14,%esp
801024c5:	89 d8                	mov    %ebx,%eax
801024c7:	5b                   	pop    %ebx
801024c8:	5d                   	pop    %ebp
801024c9:	c3                   	ret    
801024ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024d0:	c7 04 24 60 36 11 80 	movl   $0x80113660,(%esp)
801024d7:	e8 14 24 00 00       	call   801048f0 <acquire>
801024dc:	a1 94 36 11 80       	mov    0x80113694,%eax
801024e1:	eb bd                	jmp    801024a0 <kalloc+0x10>
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f0:	ba 64 00 00 00       	mov    $0x64,%edx
801024f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f6:	a8 01                	test   $0x1,%al
801024f8:	0f 84 ba 00 00 00    	je     801025b8 <kbdgetc+0xc8>
801024fe:	b2 60                	mov    $0x60,%dl
80102500:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102501:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102504:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010250a:	0f 84 88 00 00 00    	je     80102598 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102510:	84 c0                	test   %al,%al
80102512:	79 2c                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 15 b4 b5 10 80    	mov    0x8010b5b4,%edx
8010251a:	f6 c2 40             	test   $0x40,%dl
8010251d:	75 05                	jne    80102524 <kbdgetc+0x34>
8010251f:	89 c1                	mov    %eax,%ecx
80102521:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102524:	0f b6 81 60 79 10 80 	movzbl -0x7fef86a0(%ecx),%eax
8010252b:	83 c8 40             	or     $0x40,%eax
8010252e:	0f b6 c0             	movzbl %al,%eax
80102531:	f7 d0                	not    %eax
80102533:	21 d0                	and    %edx,%eax
80102535:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010253a:	31 c0                	xor    %eax,%eax
8010253c:	c3                   	ret    
8010253d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010254a:	f6 c3 40             	test   $0x40,%bl
8010254d:	74 09                	je     80102558 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102552:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102555:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102558:	0f b6 91 60 79 10 80 	movzbl -0x7fef86a0(%ecx),%edx
  shift ^= togglecode[data];
8010255f:	0f b6 81 60 78 10 80 	movzbl -0x7fef87a0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102566:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102568:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010256a:	89 d0                	mov    %edx,%eax
8010256c:	83 e0 03             	and    $0x3,%eax
8010256f:	8b 04 85 40 78 10 80 	mov    -0x7fef87c0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102576:	89 15 b4 b5 10 80    	mov    %edx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010257c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010257f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102583:	74 0b                	je     80102590 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102585:	8d 50 9f             	lea    -0x61(%eax),%edx
80102588:	83 fa 19             	cmp    $0x19,%edx
8010258b:	77 1b                	ja     801025a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010258d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102590:	5b                   	pop    %ebx
80102591:	5d                   	pop    %ebp
80102592:	c3                   	ret    
80102593:	90                   	nop
80102594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102598:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
    return 0;
8010259f:	31 c0                	xor    %eax,%eax
801025a1:	c3                   	ret    
801025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025ab:	8d 50 20             	lea    0x20(%eax),%edx
801025ae:	83 f9 19             	cmp    $0x19,%ecx
801025b1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025b4:	eb da                	jmp    80102590 <kbdgetc+0xa0>
801025b6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax

801025c0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025c6:	c7 04 24 f0 24 10 80 	movl   $0x801024f0,(%esp)
801025cd:	e8 de e1 ff ff       	call   801007b0 <consoleintr>
}
801025d2:	c9                   	leave  
801025d3:	c3                   	ret    
801025d4:	66 90                	xchg   %ax,%ax
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801025e0:	55                   	push   %ebp
801025e1:	89 c1                	mov    %eax,%ecx
801025e3:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e5:	ba 70 00 00 00       	mov    $0x70,%edx
801025ea:	53                   	push   %ebx
801025eb:	31 c0                	xor    %eax,%eax
801025ed:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ee:	bb 71 00 00 00       	mov    $0x71,%ebx
801025f3:	89 da                	mov    %ebx,%edx
801025f5:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801025f6:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f9:	b2 70                	mov    $0x70,%dl
801025fb:	89 01                	mov    %eax,(%ecx)
801025fd:	b8 02 00 00 00       	mov    $0x2,%eax
80102602:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
80102606:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 41 04             	mov    %eax,0x4(%ecx)
8010260e:	b8 04 00 00 00       	mov    $0x4,%eax
80102613:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102614:	89 da                	mov    %ebx,%edx
80102616:	ec                   	in     (%dx),%al
80102617:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010261a:	b2 70                	mov    $0x70,%dl
8010261c:	89 41 08             	mov    %eax,0x8(%ecx)
8010261f:	b8 07 00 00 00       	mov    $0x7,%eax
80102624:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102625:	89 da                	mov    %ebx,%edx
80102627:	ec                   	in     (%dx),%al
80102628:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262b:	b2 70                	mov    $0x70,%dl
8010262d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102630:	b8 08 00 00 00       	mov    $0x8,%eax
80102635:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102636:	89 da                	mov    %ebx,%edx
80102638:	ec                   	in     (%dx),%al
80102639:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263c:	b2 70                	mov    $0x70,%dl
8010263e:	89 41 10             	mov    %eax,0x10(%ecx)
80102641:	b8 09 00 00 00       	mov    $0x9,%eax
80102646:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102647:	89 da                	mov    %ebx,%edx
80102649:	ec                   	in     (%dx),%al
8010264a:	0f b6 d8             	movzbl %al,%ebx
8010264d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102650:	5b                   	pop    %ebx
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret    
80102653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
80102660:	a1 9c 36 11 80       	mov    0x8011369c,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 c0 00 00 00    	je     80102730 <lapicinit+0xd0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102670:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102677:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102691:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102697:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010269e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026a1:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ae:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026be:	8b 50 30             	mov    0x30(%eax),%edx
801026c1:	c1 ea 10             	shr    $0x10,%edx
801026c4:	80 fa 03             	cmp    $0x3,%dl
801026c7:	77 6f                	ja     80102738 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102711:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
80102717:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102718:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010271e:	80 e6 10             	and    $0x10,%dh
80102721:	75 f5                	jne    80102718 <lapicinit+0xb8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102723:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102730:	5d                   	pop    %ebp
80102731:	c3                   	ret    
80102732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102738:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010273f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102742:	8b 50 20             	mov    0x20(%eax),%edx
80102745:	eb 82                	jmp    801026c9 <lapicinit+0x69>
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	56                   	push   %esi
80102754:	53                   	push   %ebx
80102755:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102758:	9c                   	pushf  
80102759:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
8010275a:	f6 c4 02             	test   $0x2,%ah
8010275d:	74 12                	je     80102771 <cpunum+0x21>
    static int n;
    if(n++ == 0)
8010275f:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80102764:	8d 50 01             	lea    0x1(%eax),%edx
80102767:	85 c0                	test   %eax,%eax
80102769:	89 15 b8 b5 10 80    	mov    %edx,0x8010b5b8
8010276f:	74 4a                	je     801027bb <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
80102771:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102776:	85 c0                	test   %eax,%eax
80102778:	74 5d                	je     801027d7 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
8010277a:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010277d:	8b 35 80 3d 11 80    	mov    0x80113d80,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102783:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102786:	85 f6                	test   %esi,%esi
80102788:	7e 56                	jle    801027e0 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
8010278a:	0f b6 05 a0 37 11 80 	movzbl 0x801137a0,%eax
80102791:	39 d8                	cmp    %ebx,%eax
80102793:	74 42                	je     801027d7 <cpunum+0x87>
80102795:	ba 5c 38 11 80       	mov    $0x8011385c,%edx

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
8010279a:	31 c0                	xor    %eax,%eax
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a0:	83 c0 01             	add    $0x1,%eax
801027a3:	39 f0                	cmp    %esi,%eax
801027a5:	74 39                	je     801027e0 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
801027a7:	0f b6 0a             	movzbl (%edx),%ecx
801027aa:	81 c2 bc 00 00 00    	add    $0xbc,%edx
801027b0:	39 d9                	cmp    %ebx,%ecx
801027b2:	75 ec                	jne    801027a0 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
801027b4:	83 c4 10             	add    $0x10,%esp
801027b7:	5b                   	pop    %ebx
801027b8:	5e                   	pop    %esi
801027b9:	5d                   	pop    %ebp
801027ba:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
801027bb:	8b 45 04             	mov    0x4(%ebp),%eax
801027be:	c7 04 24 60 7a 10 80 	movl   $0x80107a60,(%esp)
801027c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801027c9:	e8 82 de ff ff       	call   80100650 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
801027ce:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801027d3:	85 c0                	test   %eax,%eax
801027d5:	75 a3                	jne    8010277a <cpunum+0x2a>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801027d7:	83 c4 10             	add    $0x10,%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
801027da:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
801027dc:	5b                   	pop    %ebx
801027dd:	5e                   	pop    %esi
801027de:	5d                   	pop    %ebp
801027df:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
801027e0:	c7 04 24 8c 7a 10 80 	movl   $0x80107a8c,(%esp)
801027e7:	e8 74 db ff ff       	call   80100360 <panic>
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027f0:	a1 9c 36 11 80       	mov    0x8011369c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801027f5:	55                   	push   %ebp
801027f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027f8:	85 c0                	test   %eax,%eax
801027fa:	74 0d                	je     80102809 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102803:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102806:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102809:	5d                   	pop    %ebp
8010280a:	c3                   	ret    
8010280b:	90                   	nop
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102810 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
}
80102813:	5d                   	pop    %ebp
80102814:	c3                   	ret    
80102815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102820 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102820:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102821:	ba 70 00 00 00       	mov    $0x70,%edx
80102826:	89 e5                	mov    %esp,%ebp
80102828:	b8 0f 00 00 00       	mov    $0xf,%eax
8010282d:	53                   	push   %ebx
8010282e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102831:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80102834:	ee                   	out    %al,(%dx)
80102835:	b8 0a 00 00 00       	mov    $0xa,%eax
8010283a:	b2 71                	mov    $0x71,%dl
8010283c:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
8010283d:	31 c0                	xor    %eax,%eax
8010283f:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102845:	89 d8                	mov    %ebx,%eax
80102847:	c1 e8 04             	shr    $0x4,%eax
8010284a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102850:	a1 9c 36 11 80       	mov    0x8011369c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102855:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102858:	c1 eb 0c             	shr    $0xc,%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010285b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102861:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102864:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010286b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102871:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102878:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287b:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010287e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102887:	89 da                	mov    %ebx,%edx
80102889:	80 ce 06             	or     $0x6,%dh
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010288c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102892:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102895:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 48 20             	mov    0x20(%eax),%ecx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010289e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801028a7:	5b                   	pop    %ebx
801028a8:	5d                   	pop    %ebp
801028a9:	c3                   	ret    
801028aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028b0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028b0:	55                   	push   %ebp
801028b1:	ba 70 00 00 00       	mov    $0x70,%edx
801028b6:	89 e5                	mov    %esp,%ebp
801028b8:	b8 0b 00 00 00       	mov    $0xb,%eax
801028bd:	57                   	push   %edi
801028be:	56                   	push   %esi
801028bf:	53                   	push   %ebx
801028c0:	83 ec 4c             	sub    $0x4c,%esp
801028c3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c4:	b2 71                	mov    $0x71,%dl
801028c6:	ec                   	in     (%dx),%al
801028c7:	88 45 b7             	mov    %al,-0x49(%ebp)
801028ca:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801028cd:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
801028d1:	8d 7d d0             	lea    -0x30(%ebp),%edi
801028d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d8:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801028dd:	89 d8                	mov    %ebx,%eax
801028df:	e8 fc fc ff ff       	call   801025e0 <fill_rtcdate>
801028e4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028e9:	89 f2                	mov    %esi,%edx
801028eb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ec:	ba 71 00 00 00       	mov    $0x71,%edx
801028f1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028f2:	84 c0                	test   %al,%al
801028f4:	78 e7                	js     801028dd <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028f6:	89 f8                	mov    %edi,%eax
801028f8:	e8 e3 fc ff ff       	call   801025e0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028fd:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102904:	00 
80102905:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102909:	89 1c 24             	mov    %ebx,(%esp)
8010290c:	e8 af 21 00 00       	call   80104ac0 <memcmp>
80102911:	85 c0                	test   %eax,%eax
80102913:	75 c3                	jne    801028d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102915:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102919:	75 78                	jne    80102993 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010291b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010291e:	89 c2                	mov    %eax,%edx
80102920:	83 e0 0f             	and    $0xf,%eax
80102923:	c1 ea 04             	shr    $0x4,%edx
80102926:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102929:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010292f:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102932:	89 c2                	mov    %eax,%edx
80102934:	83 e0 0f             	and    $0xf,%eax
80102937:	c1 ea 04             	shr    $0x4,%edx
8010293a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010293d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102940:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102943:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102946:	89 c2                	mov    %eax,%edx
80102948:	83 e0 0f             	and    $0xf,%eax
8010294b:	c1 ea 04             	shr    $0x4,%edx
8010294e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102951:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102954:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102957:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010295a:	89 c2                	mov    %eax,%edx
8010295c:	83 e0 0f             	and    $0xf,%eax
8010295f:	c1 ea 04             	shr    $0x4,%edx
80102962:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102965:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102968:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010296b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010296e:	89 c2                	mov    %eax,%edx
80102970:	83 e0 0f             	and    $0xf,%eax
80102973:	c1 ea 04             	shr    $0x4,%edx
80102976:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102979:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010297f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102982:	89 c2                	mov    %eax,%edx
80102984:	83 e0 0f             	and    $0xf,%eax
80102987:	c1 ea 04             	shr    $0x4,%edx
8010298a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010298d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102990:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102993:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102996:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102999:	89 01                	mov    %eax,(%ecx)
8010299b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010299e:	89 41 04             	mov    %eax,0x4(%ecx)
801029a1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029a4:	89 41 08             	mov    %eax,0x8(%ecx)
801029a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029aa:	89 41 0c             	mov    %eax,0xc(%ecx)
801029ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b0:	89 41 10             	mov    %eax,0x10(%ecx)
801029b3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b6:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
801029b9:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
801029c0:	83 c4 4c             	add    $0x4c,%esp
801029c3:	5b                   	pop    %ebx
801029c4:	5e                   	pop    %esi
801029c5:	5f                   	pop    %edi
801029c6:	5d                   	pop    %ebp
801029c7:	c3                   	ret    
801029c8:	66 90                	xchg   %ax,%ax
801029ca:	66 90                	xchg   %ax,%ax
801029cc:	66 90                	xchg   %ax,%ax
801029ce:	66 90                	xchg   %ax,%ax

801029d0 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	57                   	push   %edi
801029d4:	56                   	push   %esi
801029d5:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029d6:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029d8:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029db:	a1 e8 36 11 80       	mov    0x801136e8,%eax
801029e0:	85 c0                	test   %eax,%eax
801029e2:	7e 78                	jle    80102a5c <install_trans+0x8c>
801029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029e8:	a1 d4 36 11 80       	mov    0x801136d4,%eax
801029ed:	01 d8                	add    %ebx,%eax
801029ef:	83 c0 01             	add    $0x1,%eax
801029f2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f6:	a1 e4 36 11 80       	mov    0x801136e4,%eax
801029fb:	89 04 24             	mov    %eax,(%esp)
801029fe:	e8 cd d6 ff ff       	call   801000d0 <bread>
80102a03:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a05:	8b 04 9d ec 36 11 80 	mov    -0x7feec914(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a0c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a13:	a1 e4 36 11 80       	mov    0x801136e4,%eax
80102a18:	89 04 24             	mov    %eax,(%esp)
80102a1b:	e8 b0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a20:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102a27:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a28:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a2a:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a31:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a34:	89 04 24             	mov    %eax,(%esp)
80102a37:	e8 d4 20 00 00       	call   80104b10 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a3c:	89 34 24             	mov    %esi,(%esp)
80102a3f:	e8 5c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a44:	89 3c 24             	mov    %edi,(%esp)
80102a47:	e8 94 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a4c:	89 34 24             	mov    %esi,(%esp)
80102a4f:	e8 8c d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a54:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102a5a:	7f 8c                	jg     801029e8 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a5c:	83 c4 1c             	add    $0x1c,%esp
80102a5f:	5b                   	pop    %ebx
80102a60:	5e                   	pop    %esi
80102a61:	5f                   	pop    %edi
80102a62:	5d                   	pop    %ebp
80102a63:	c3                   	ret    
80102a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	57                   	push   %edi
80102a74:	56                   	push   %esi
80102a75:	53                   	push   %ebx
80102a76:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a79:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102a7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a82:	a1 e4 36 11 80       	mov    0x801136e4,%eax
80102a87:	89 04 24             	mov    %eax,(%esp)
80102a8a:	e8 41 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a8f:	8b 1d e8 36 11 80    	mov    0x801136e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a95:	31 d2                	xor    %edx,%edx
80102a97:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a99:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a9b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a9e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102aa1:	7e 17                	jle    80102aba <write_head+0x4a>
80102aa3:	90                   	nop
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102aa8:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
80102aaf:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ab3:	83 c2 01             	add    $0x1,%edx
80102ab6:	39 da                	cmp    %ebx,%edx
80102ab8:	75 ee                	jne    80102aa8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102aba:	89 3c 24             	mov    %edi,(%esp)
80102abd:	e8 de d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102ac2:	89 3c 24             	mov    %edi,(%esp)
80102ac5:	e8 16 d7 ff ff       	call   801001e0 <brelse>
}
80102aca:	83 c4 1c             	add    $0x1c,%esp
80102acd:	5b                   	pop    %ebx
80102ace:	5e                   	pop    %esi
80102acf:	5f                   	pop    %edi
80102ad0:	5d                   	pop    %ebp
80102ad1:	c3                   	ret    
80102ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ae0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
80102ae5:	83 ec 30             	sub    $0x30,%esp
80102ae8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aeb:	c7 44 24 04 9c 7a 10 	movl   $0x80107a9c,0x4(%esp)
80102af2:	80 
80102af3:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102afa:	e8 71 1d 00 00       	call   80104870 <initlock>
  readsb(dev, &sb);
80102aff:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b02:	89 44 24 04          	mov    %eax,0x4(%esp)
80102b06:	89 1c 24             	mov    %ebx,(%esp)
80102b09:	e8 82 e8 ff ff       	call   80101390 <readsb>
  log.start = sb.logstart;
80102b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102b11:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b14:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b17:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b1d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b21:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b27:	a3 d4 36 11 80       	mov    %eax,0x801136d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b2c:	e8 9f d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b31:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b33:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102b36:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102b39:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b3b:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102b41:	7e 17                	jle    80102b5a <initlog+0x7a>
80102b43:	90                   	nop
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b48:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b4c:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b53:	83 c2 01             	add    $0x1,%edx
80102b56:	39 da                	cmp    %ebx,%edx
80102b58:	75 ee                	jne    80102b48 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b5a:	89 04 24             	mov    %eax,(%esp)
80102b5d:	e8 7e d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b62:	e8 69 fe ff ff       	call   801029d0 <install_trans>
  log.lh.n = 0;
80102b67:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102b6e:	00 00 00 
  write_head(); // clear the log
80102b71:	e8 fa fe ff ff       	call   80102a70 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b76:	83 c4 30             	add    $0x30,%esp
80102b79:	5b                   	pop    %ebx
80102b7a:	5e                   	pop    %esi
80102b7b:	5d                   	pop    %ebp
80102b7c:	c3                   	ret    
80102b7d:	8d 76 00             	lea    0x0(%esi),%esi

80102b80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b86:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102b8d:	e8 5e 1d 00 00       	call   801048f0 <acquire>
80102b92:	eb 18                	jmp    80102bac <begin_op+0x2c>
80102b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b98:	c7 44 24 04 a0 36 11 	movl   $0x801136a0,0x4(%esp)
80102b9f:	80 
80102ba0:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102ba7:	e8 b4 16 00 00       	call   80104260 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bac:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102bb1:	85 c0                	test   %eax,%eax
80102bb3:	75 e3                	jne    80102b98 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102bb5:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102bba:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102bc0:	83 c0 01             	add    $0x1,%eax
80102bc3:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bc6:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bc9:	83 fa 1e             	cmp    $0x1e,%edx
80102bcc:	7f ca                	jg     80102b98 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bce:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102bd5:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102bda:	e8 41 1e 00 00       	call   80104a20 <release>
      break;
    }
  }
}
80102bdf:	c9                   	leave  
80102be0:	c3                   	ret    
80102be1:	eb 0d                	jmp    80102bf0 <end_op>
80102be3:	90                   	nop
80102be4:	90                   	nop
80102be5:	90                   	nop
80102be6:	90                   	nop
80102be7:	90                   	nop
80102be8:	90                   	nop
80102be9:	90                   	nop
80102bea:	90                   	nop
80102beb:	90                   	nop
80102bec:	90                   	nop
80102bed:	90                   	nop
80102bee:	90                   	nop
80102bef:	90                   	nop

80102bf0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	57                   	push   %edi
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bf9:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102c00:	e8 eb 1c 00 00       	call   801048f0 <acquire>
  log.outstanding -= 1;
80102c05:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102c0a:	8b 15 e0 36 11 80    	mov    0x801136e0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c10:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c13:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c15:	a3 dc 36 11 80       	mov    %eax,0x801136dc
  if(log.committing)
80102c1a:	0f 85 f3 00 00 00    	jne    80102d13 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102c20:	85 c0                	test   %eax,%eax
80102c22:	0f 85 cb 00 00 00    	jne    80102cf3 <end_op+0x103>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c28:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c2f:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c31:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102c38:	00 00 00 
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c3b:	e8 e0 1d 00 00       	call   80104a20 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c40:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80102c45:	85 c0                	test   %eax,%eax
80102c47:	0f 8e 90 00 00 00    	jle    80102cdd <end_op+0xed>
80102c4d:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c50:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102c55:	01 d8                	add    %ebx,%eax
80102c57:	83 c0 01             	add    $0x1,%eax
80102c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c5e:	a1 e4 36 11 80       	mov    0x801136e4,%eax
80102c63:	89 04 24             	mov    %eax,(%esp)
80102c66:	e8 65 d4 ff ff       	call   801000d0 <bread>
80102c6b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c6d:	8b 04 9d ec 36 11 80 	mov    -0x7feec914(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c74:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c77:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c7b:	a1 e4 36 11 80       	mov    0x801136e4,%eax
80102c80:	89 04 24             	mov    %eax,(%esp)
80102c83:	e8 48 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c88:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c8f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c90:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c92:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c95:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c99:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c9c:	89 04 24             	mov    %eax,(%esp)
80102c9f:	e8 6c 1e 00 00       	call   80104b10 <memmove>
    bwrite(to);  // write the log
80102ca4:	89 34 24             	mov    %esi,(%esp)
80102ca7:	e8 f4 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cac:	89 3c 24             	mov    %edi,(%esp)
80102caf:	e8 2c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cb4:	89 34 24             	mov    %esi,(%esp)
80102cb7:	e8 24 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cbc:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102cc2:	7c 8c                	jl     80102c50 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cc4:	e8 a7 fd ff ff       	call   80102a70 <write_head>
    install_trans(); // Now install writes to home locations
80102cc9:	e8 02 fd ff ff       	call   801029d0 <install_trans>
    log.lh.n = 0;
80102cce:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102cd5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102cd8:	e8 93 fd ff ff       	call   80102a70 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cdd:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102ce4:	e8 07 1c 00 00       	call   801048f0 <acquire>
    log.committing = 0;
80102ce9:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102cf0:	00 00 00 
    wakeup(&log);
80102cf3:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102cfa:	e8 51 17 00 00       	call   80104450 <wakeup>
    release(&log.lock);
80102cff:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d06:	e8 15 1d 00 00       	call   80104a20 <release>
  }
}
80102d0b:	83 c4 1c             	add    $0x1c,%esp
80102d0e:	5b                   	pop    %ebx
80102d0f:	5e                   	pop    %esi
80102d10:	5f                   	pop    %edi
80102d11:	5d                   	pop    %ebp
80102d12:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d13:	c7 04 24 a0 7a 10 80 	movl   $0x80107aa0,(%esp)
80102d1a:	e8 41 d6 ff ff       	call   80100360 <panic>
80102d1f:	90                   	nop

80102d20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d27:	a1 e8 36 11 80       	mov    0x801136e8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d2f:	83 f8 1d             	cmp    $0x1d,%eax
80102d32:	0f 8f 98 00 00 00    	jg     80102dd0 <log_write+0xb0>
80102d38:	8b 0d d8 36 11 80    	mov    0x801136d8,%ecx
80102d3e:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d41:	39 d0                	cmp    %edx,%eax
80102d43:	0f 8d 87 00 00 00    	jge    80102dd0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d49:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102d4e:	85 c0                	test   %eax,%eax
80102d50:	0f 8e 86 00 00 00    	jle    80102ddc <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d56:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102d5d:	e8 8e 1b 00 00       	call   801048f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d62:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102d68:	83 fa 00             	cmp    $0x0,%edx
80102d6b:	7e 54                	jle    80102dc1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d6d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d70:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d72:	39 0d ec 36 11 80    	cmp    %ecx,0x801136ec
80102d78:	75 0f                	jne    80102d89 <log_write+0x69>
80102d7a:	eb 3c                	jmp    80102db8 <log_write+0x98>
80102d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d80:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80102d87:	74 2f                	je     80102db8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	39 d0                	cmp    %edx,%eax
80102d8e:	75 f0                	jne    80102d80 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d90:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d97:	83 c2 01             	add    $0x1,%edx
80102d9a:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80102da0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102da3:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102daa:	83 c4 14             	add    $0x14,%esp
80102dad:	5b                   	pop    %ebx
80102dae:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102daf:	e9 6c 1c 00 00       	jmp    80104a20 <release>
80102db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102db8:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
80102dbf:	eb df                	jmp    80102da0 <log_write+0x80>
80102dc1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dc4:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102dc9:	75 d5                	jne    80102da0 <log_write+0x80>
80102dcb:	eb ca                	jmp    80102d97 <log_write+0x77>
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102dd0:	c7 04 24 af 7a 10 80 	movl   $0x80107aaf,(%esp)
80102dd7:	e8 84 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ddc:	c7 04 24 c5 7a 10 80 	movl   $0x80107ac5,(%esp)
80102de3:	e8 78 d5 ff ff       	call   80100360 <panic>
80102de8:	66 90                	xchg   %ax,%ax
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102df6:	e8 55 f9 ff ff       	call   80102750 <cpunum>
80102dfb:	c7 04 24 e0 7a 10 80 	movl   $0x80107ae0,(%esp)
80102e02:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e06:	e8 45 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102e0b:	e8 c0 2e 00 00       	call   80105cd0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e10:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e17:	b8 01 00 00 00       	mov    $0x1,%eax
80102e1c:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102e23:	e8 b8 0e 00 00       	call   80103ce0 <scheduler>
80102e28:	90                   	nop
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e30 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e36:	e8 15 41 00 00       	call   80106f50 <switchkvm>
  seginit();
80102e3b:	e8 30 3f 00 00       	call   80106d70 <seginit>
  lapicinit();
80102e40:	e8 1b f8 ff ff       	call   80102660 <lapicinit>
  mpmain();
80102e45:	e8 a6 ff ff ff       	call   80102df0 <mpmain>
80102e4a:	66 90                	xchg   %ax,%ax
80102e4c:	66 90                	xchg   %ax,%ax
80102e4e:	66 90                	xchg   %ax,%ax

80102e50 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 e4 f0             	and    $0xfffffff0,%esp
80102e57:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e5a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e61:	80 
80102e62:	c7 04 24 48 6c 11 80 	movl   $0x80116c48,(%esp)
80102e69:	e8 62 f5 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102e6e:	e8 bd 40 00 00       	call   80106f30 <kvmalloc>
  mpinit();        // detect other processors
80102e73:	e8 a8 01 00 00       	call   80103020 <mpinit>
  lapicinit();     // interrupt controller
80102e78:	e8 e3 f7 ff ff       	call   80102660 <lapicinit>
80102e7d:	8d 76 00             	lea    0x0(%esi),%esi
  seginit();       // segment descriptors
80102e80:	e8 eb 3e 00 00       	call   80106d70 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102e85:	e8 c6 f8 ff ff       	call   80102750 <cpunum>
80102e8a:	c7 04 24 f1 7a 10 80 	movl   $0x80107af1,(%esp)
80102e91:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e95:	e8 b6 d7 ff ff       	call   80100650 <cprintf>
  picinit();       // another interrupt controller
80102e9a:	e8 81 03 00 00       	call   80103220 <picinit>
  ioapicinit();    // another interrupt controller
80102e9f:	e8 4c f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102ea4:	e8 a7 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102ea9:	e8 d2 31 00 00       	call   80106080 <uartinit>
80102eae:	66 90                	xchg   %ax,%ax
  pinit();         // process table
80102eb0:	e8 db 09 00 00       	call   80103890 <pinit>
  tvinit();        // trap vectors
80102eb5:	e8 46 2d 00 00       	call   80105c00 <tvinit>
  binit();         // buffer cache
80102eba:	e8 81 d1 ff ff       	call   80100040 <binit>
80102ebf:	90                   	nop
  fileinit();      // file table
80102ec0:	e8 7b de ff ff       	call   80100d40 <fileinit>
  ideinit();       // disk
80102ec5:	e8 16 f1 ff ff       	call   80101fe0 <ideinit>
  if(!ismp)
80102eca:	a1 84 37 11 80       	mov    0x80113784,%eax
80102ecf:	85 c0                	test   %eax,%eax
80102ed1:	0f 84 ca 00 00 00    	je     80102fa1 <main+0x151>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ed7:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102ede:	00 

  for(c = cpus; c < cpus+ncpu; c++){
80102edf:	bb a0 37 11 80       	mov    $0x801137a0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ee4:	c7 44 24 04 8c b4 10 	movl   $0x8010b48c,0x4(%esp)
80102eeb:	80 
80102eec:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102ef3:	e8 18 1c 00 00       	call   80104b10 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ef8:	69 05 80 3d 11 80 bc 	imul   $0xbc,0x80113d80,%eax
80102eff:	00 00 00 
80102f02:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f07:	39 d8                	cmp    %ebx,%eax
80102f09:	76 78                	jbe    80102f83 <main+0x133>
80102f0b:	90                   	nop
80102f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == cpus+cpunum())  // We've started already.
80102f10:	e8 3b f8 ff ff       	call   80102750 <cpunum>
80102f15:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f1b:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f20:	39 c3                	cmp    %eax,%ebx
80102f22:	74 46                	je     80102f6a <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f24:	e8 67 f5 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102f29:	c7 05 f8 6f 00 80 30 	movl   $0x80102e30,0x80006ff8
80102f30:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f33:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f3a:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f3d:	05 00 10 00 00       	add    $0x1000,%eax
80102f42:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f47:	0f b6 03             	movzbl (%ebx),%eax
80102f4a:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102f51:	00 
80102f52:	89 04 24             	mov    %eax,(%esp)
80102f55:	e8 c6 f8 ff ff       	call   80102820 <lapicstartap>
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f60:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102f66:	85 c0                	test   %eax,%eax
80102f68:	74 f6                	je     80102f60 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f6a:	69 05 80 3d 11 80 bc 	imul   $0xbc,0x80113d80,%eax
80102f71:	00 00 00 
80102f74:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102f7a:	05 a0 37 11 80       	add    $0x801137a0,%eax
80102f7f:	39 c3                	cmp    %eax,%ebx
80102f81:	72 8d                	jb     80102f10 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f83:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f8a:	8e 
80102f8b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f92:	e8 a9 f4 ff ff       	call   80102440 <kinit2>
  userinit();      // first user process
80102f97:	e8 94 09 00 00       	call   80103930 <userinit>
  mpmain();        // finish this processor's setup
80102f9c:	e8 4f fe ff ff       	call   80102df0 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80102fa1:	e8 fa 2b 00 00       	call   80105ba0 <timerinit>
80102fa6:	e9 2c ff ff ff       	jmp    80102ed7 <main+0x87>
80102fab:	66 90                	xchg   %ax,%ax
80102fad:	66 90                	xchg   %ax,%ax
80102faf:	90                   	nop

80102fb0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fb4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fba:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102fbb:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fbe:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fc1:	39 de                	cmp    %ebx,%esi
80102fc3:	73 3c                	jae    80103001 <mpsearch1+0x51>
80102fc5:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fc8:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fcf:	00 
80102fd0:	c7 44 24 04 08 7b 10 	movl   $0x80107b08,0x4(%esp)
80102fd7:	80 
80102fd8:	89 34 24             	mov    %esi,(%esp)
80102fdb:	e8 e0 1a 00 00       	call   80104ac0 <memcmp>
80102fe0:	85 c0                	test   %eax,%eax
80102fe2:	75 16                	jne    80102ffa <mpsearch1+0x4a>
80102fe4:	31 c9                	xor    %ecx,%ecx
80102fe6:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fe8:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fec:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102fef:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102ff1:	83 fa 10             	cmp    $0x10,%edx
80102ff4:	75 f2                	jne    80102fe8 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ff6:	84 c9                	test   %cl,%cl
80102ff8:	74 10                	je     8010300a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102ffa:	83 c6 10             	add    $0x10,%esi
80102ffd:	39 f3                	cmp    %esi,%ebx
80102fff:	77 c7                	ja     80102fc8 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80103001:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103004:	31 c0                	xor    %eax,%eax
}
80103006:	5b                   	pop    %ebx
80103007:	5e                   	pop    %esi
80103008:	5d                   	pop    %ebp
80103009:	c3                   	ret    
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	89 f0                	mov    %esi,%eax
8010300f:	5b                   	pop    %ebx
80103010:	5e                   	pop    %esi
80103011:	5d                   	pop    %ebp
80103012:	c3                   	ret    
80103013:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103020 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	57                   	push   %edi
80103024:	56                   	push   %esi
80103025:	53                   	push   %ebx
80103026:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103029:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103030:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103037:	c1 e0 08             	shl    $0x8,%eax
8010303a:	09 d0                	or     %edx,%eax
8010303c:	c1 e0 04             	shl    $0x4,%eax
8010303f:	85 c0                	test   %eax,%eax
80103041:	75 1b                	jne    8010305e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103043:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010304a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103051:	c1 e0 08             	shl    $0x8,%eax
80103054:	09 d0                	or     %edx,%eax
80103056:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103059:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010305e:	ba 00 04 00 00       	mov    $0x400,%edx
80103063:	e8 48 ff ff ff       	call   80102fb0 <mpsearch1>
80103068:	85 c0                	test   %eax,%eax
8010306a:	89 c7                	mov    %eax,%edi
8010306c:	0f 84 4e 01 00 00    	je     801031c0 <mpinit+0x1a0>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103072:	8b 77 04             	mov    0x4(%edi),%esi
80103075:	85 f6                	test   %esi,%esi
80103077:	0f 84 ce 00 00 00    	je     8010314b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010307d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103083:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010308a:	00 
8010308b:	c7 44 24 04 0d 7b 10 	movl   $0x80107b0d,0x4(%esp)
80103092:	80 
80103093:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103096:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103099:	e8 22 1a 00 00       	call   80104ac0 <memcmp>
8010309e:	85 c0                	test   %eax,%eax
801030a0:	0f 85 a5 00 00 00    	jne    8010314b <mpinit+0x12b>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801030a6:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801030ad:	3c 04                	cmp    $0x4,%al
801030af:	0f 85 29 01 00 00    	jne    801031de <mpinit+0x1be>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030b5:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030bc:	85 c0                	test   %eax,%eax
801030be:	74 1d                	je     801030dd <mpinit+0xbd>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
801030c0:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
801030c2:	31 d2                	xor    %edx,%edx
801030c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030c8:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
801030cf:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030d0:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801030d3:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030d5:	39 d0                	cmp    %edx,%eax
801030d7:	7f ef                	jg     801030c8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030d9:	84 c9                	test   %cl,%cl
801030db:	75 6e                	jne    8010314b <mpinit+0x12b>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801030e0:	85 db                	test   %ebx,%ebx
801030e2:	74 67                	je     8010314b <mpinit+0x12b>
    return;
  ismp = 1;
801030e4:	c7 05 84 37 11 80 01 	movl   $0x1,0x80113784
801030eb:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801030ee:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801030f4:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030f9:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
80103100:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103106:	01 d9                	add    %ebx,%ecx
80103108:	39 c8                	cmp    %ecx,%eax
8010310a:	0f 83 90 00 00 00    	jae    801031a0 <mpinit+0x180>
    switch(*p){
80103110:	80 38 04             	cmpb   $0x4,(%eax)
80103113:	77 7b                	ja     80103190 <mpinit+0x170>
80103115:	0f b6 10             	movzbl (%eax),%edx
80103118:	ff 24 95 14 7b 10 80 	jmp    *-0x7fef84ec(,%edx,4)
8010311f:	90                   	nop
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103120:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103123:	39 c1                	cmp    %eax,%ecx
80103125:	77 e9                	ja     80103110 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
80103127:	a1 84 37 11 80       	mov    0x80113784,%eax
8010312c:	85 c0                	test   %eax,%eax
8010312e:	75 70                	jne    801031a0 <mpinit+0x180>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103130:	c7 05 80 3d 11 80 01 	movl   $0x1,0x80113d80
80103137:	00 00 00 
    lapic = 0;
8010313a:	c7 05 9c 36 11 80 00 	movl   $0x0,0x8011369c
80103141:	00 00 00 
    ioapicid = 0;
80103144:	c6 05 80 37 11 80 00 	movb   $0x0,0x80113780
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010314b:	83 c4 1c             	add    $0x1c,%esp
8010314e:	5b                   	pop    %ebx
8010314f:	5e                   	pop    %esi
80103150:	5f                   	pop    %edi
80103151:	5d                   	pop    %ebp
80103152:	c3                   	ret    
80103153:	90                   	nop
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103158:	8b 15 80 3d 11 80    	mov    0x80113d80,%edx
8010315e:	83 fa 07             	cmp    $0x7,%edx
80103161:	7f 17                	jg     8010317a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103163:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
80103167:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
        ncpu++;
8010316d:	83 05 80 3d 11 80 01 	addl   $0x1,0x80113d80
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103174:	88 9a a0 37 11 80    	mov    %bl,-0x7feec860(%edx)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010317a:	83 c0 14             	add    $0x14,%eax
      continue;
8010317d:	eb a4                	jmp    80103123 <mpinit+0x103>
8010317f:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103180:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103184:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103187:	88 15 80 37 11 80    	mov    %dl,0x80113780
      p += sizeof(struct mpioapic);
      continue;
8010318d:	eb 94                	jmp    80103123 <mpinit+0x103>
8010318f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103190:	c7 05 84 37 11 80 00 	movl   $0x0,0x80113784
80103197:	00 00 00 
      break;
8010319a:	eb 87                	jmp    80103123 <mpinit+0x103>
8010319c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
801031a0:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801031a4:	74 a5                	je     8010314b <mpinit+0x12b>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a6:	ba 22 00 00 00       	mov    $0x22,%edx
801031ab:	b8 70 00 00 00       	mov    $0x70,%eax
801031b0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b1:	b2 23                	mov    $0x23,%dl
801031b3:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031b4:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031b7:	ee                   	out    %al,(%dx)
  }
}
801031b8:	83 c4 1c             	add    $0x1c,%esp
801031bb:	5b                   	pop    %ebx
801031bc:	5e                   	pop    %esi
801031bd:	5f                   	pop    %edi
801031be:	5d                   	pop    %ebp
801031bf:	c3                   	ret    
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031ca:	e8 e1 fd ff ff       	call   80102fb0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031cf:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801031d1:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031d3:	0f 85 99 fe ff ff    	jne    80103072 <mpinit+0x52>
801031d9:	e9 6d ff ff ff       	jmp    8010314b <mpinit+0x12b>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
801031de:	3c 01                	cmp    $0x1,%al
801031e0:	0f 84 cf fe ff ff    	je     801030b5 <mpinit+0x95>
801031e6:	e9 60 ff ff ff       	jmp    8010314b <mpinit+0x12b>
801031eb:	66 90                	xchg   %ax,%ax
801031ed:	66 90                	xchg   %ax,%ax
801031ef:	90                   	nop

801031f0 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801031f0:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
801031f1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
801031f6:	89 e5                	mov    %esp,%ebp
801031f8:	ba 21 00 00 00       	mov    $0x21,%edx
  picsetmask(irqmask & ~(1<<irq));
801031fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103200:	d3 c0                	rol    %cl,%eax
80103202:	66 23 05 00 b0 10 80 	and    0x8010b000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
80103209:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
8010320f:	ee                   	out    %al,(%dx)
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
80103210:	66 c1 e8 08          	shr    $0x8,%ax
80103214:	b2 a1                	mov    $0xa1,%dl
80103216:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
80103217:	5d                   	pop    %ebp
80103218:	c3                   	ret    
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103220 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103220:	55                   	push   %ebp
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	89 e5                	mov    %esp,%ebp
80103228:	57                   	push   %edi
80103229:	56                   	push   %esi
8010322a:	53                   	push   %ebx
8010322b:	bb 21 00 00 00       	mov    $0x21,%ebx
80103230:	89 da                	mov    %ebx,%edx
80103232:	ee                   	out    %al,(%dx)
80103233:	b9 a1 00 00 00       	mov    $0xa1,%ecx
80103238:	89 ca                	mov    %ecx,%edx
8010323a:	ee                   	out    %al,(%dx)
8010323b:	bf 11 00 00 00       	mov    $0x11,%edi
80103240:	be 20 00 00 00       	mov    $0x20,%esi
80103245:	89 f8                	mov    %edi,%eax
80103247:	89 f2                	mov    %esi,%edx
80103249:	ee                   	out    %al,(%dx)
8010324a:	b8 20 00 00 00       	mov    $0x20,%eax
8010324f:	89 da                	mov    %ebx,%edx
80103251:	ee                   	out    %al,(%dx)
80103252:	b8 04 00 00 00       	mov    $0x4,%eax
80103257:	ee                   	out    %al,(%dx)
80103258:	b8 03 00 00 00       	mov    $0x3,%eax
8010325d:	ee                   	out    %al,(%dx)
8010325e:	b3 a0                	mov    $0xa0,%bl
80103260:	89 f8                	mov    %edi,%eax
80103262:	89 da                	mov    %ebx,%edx
80103264:	ee                   	out    %al,(%dx)
80103265:	b8 28 00 00 00       	mov    $0x28,%eax
8010326a:	89 ca                	mov    %ecx,%edx
8010326c:	ee                   	out    %al,(%dx)
8010326d:	b8 02 00 00 00       	mov    $0x2,%eax
80103272:	ee                   	out    %al,(%dx)
80103273:	b8 03 00 00 00       	mov    $0x3,%eax
80103278:	ee                   	out    %al,(%dx)
80103279:	bf 68 00 00 00       	mov    $0x68,%edi
8010327e:	89 f2                	mov    %esi,%edx
80103280:	89 f8                	mov    %edi,%eax
80103282:	ee                   	out    %al,(%dx)
80103283:	b9 0a 00 00 00       	mov    $0xa,%ecx
80103288:	89 c8                	mov    %ecx,%eax
8010328a:	ee                   	out    %al,(%dx)
8010328b:	89 f8                	mov    %edi,%eax
8010328d:	89 da                	mov    %ebx,%edx
8010328f:	ee                   	out    %al,(%dx)
80103290:	89 c8                	mov    %ecx,%eax
80103292:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103293:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
8010329a:	66 83 f8 ff          	cmp    $0xffff,%ax
8010329e:	74 0a                	je     801032aa <picinit+0x8a>
801032a0:	b2 21                	mov    $0x21,%dl
801032a2:	ee                   	out    %al,(%dx)
static void
picsetmask(ushort mask)
{
  irqmask = mask;
  outb(IO_PIC1+1, mask);
  outb(IO_PIC2+1, mask >> 8);
801032a3:	66 c1 e8 08          	shr    $0x8,%ax
801032a7:	b2 a1                	mov    $0xa1,%dl
801032a9:	ee                   	out    %al,(%dx)
  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
    picsetmask(irqmask);
}
801032aa:	5b                   	pop    %ebx
801032ab:	5e                   	pop    %esi
801032ac:	5f                   	pop    %edi
801032ad:	5d                   	pop    %ebp
801032ae:	c3                   	ret    
801032af:	90                   	nop

801032b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	57                   	push   %edi
801032b4:	56                   	push   %esi
801032b5:	53                   	push   %ebx
801032b6:	83 ec 1c             	sub    $0x1c,%esp
801032b9:	8b 75 08             	mov    0x8(%ebp),%esi
801032bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801032c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032cb:	e8 90 da ff ff       	call   80100d60 <filealloc>
801032d0:	85 c0                	test   %eax,%eax
801032d2:	89 06                	mov    %eax,(%esi)
801032d4:	0f 84 a4 00 00 00    	je     8010337e <pipealloc+0xce>
801032da:	e8 81 da ff ff       	call   80100d60 <filealloc>
801032df:	85 c0                	test   %eax,%eax
801032e1:	89 03                	mov    %eax,(%ebx)
801032e3:	0f 84 87 00 00 00    	je     80103370 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032e9:	e8 a2 f1 ff ff       	call   80102490 <kalloc>
801032ee:	85 c0                	test   %eax,%eax
801032f0:	89 c7                	mov    %eax,%edi
801032f2:	74 7c                	je     80103370 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801032f4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032fb:	00 00 00 
  p->writeopen = 1;
801032fe:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103305:	00 00 00 
  p->nwrite = 0;
80103308:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010330f:	00 00 00 
  p->nread = 0;
80103312:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103319:	00 00 00 
  initlock(&p->lock, "pipe");
8010331c:	89 04 24             	mov    %eax,(%esp)
8010331f:	c7 44 24 04 28 7b 10 	movl   $0x80107b28,0x4(%esp)
80103326:	80 
80103327:	e8 44 15 00 00       	call   80104870 <initlock>
  (*f0)->type = FD_PIPE;
8010332c:	8b 06                	mov    (%esi),%eax
8010332e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103334:	8b 06                	mov    (%esi),%eax
80103336:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010333a:	8b 06                	mov    (%esi),%eax
8010333c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103340:	8b 06                	mov    (%esi),%eax
80103342:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103345:	8b 03                	mov    (%ebx),%eax
80103347:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010334d:	8b 03                	mov    (%ebx),%eax
8010334f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103353:	8b 03                	mov    (%ebx),%eax
80103355:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103359:	8b 03                	mov    (%ebx),%eax
  return 0;
8010335b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010335d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103360:	83 c4 1c             	add    $0x1c,%esp
80103363:	89 d8                	mov    %ebx,%eax
80103365:	5b                   	pop    %ebx
80103366:	5e                   	pop    %esi
80103367:	5f                   	pop    %edi
80103368:	5d                   	pop    %ebp
80103369:	c3                   	ret    
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103370:	8b 06                	mov    (%esi),%eax
80103372:	85 c0                	test   %eax,%eax
80103374:	74 08                	je     8010337e <pipealloc+0xce>
    fileclose(*f0);
80103376:	89 04 24             	mov    %eax,(%esp)
80103379:	e8 a2 da ff ff       	call   80100e20 <fileclose>
  if(*f1)
8010337e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103380:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103385:	85 c0                	test   %eax,%eax
80103387:	74 d7                	je     80103360 <pipealloc+0xb0>
    fileclose(*f1);
80103389:	89 04 24             	mov    %eax,(%esp)
8010338c:	e8 8f da ff ff       	call   80100e20 <fileclose>
  return -1;
}
80103391:	83 c4 1c             	add    $0x1c,%esp
80103394:	89 d8                	mov    %ebx,%eax
80103396:	5b                   	pop    %ebx
80103397:	5e                   	pop    %esi
80103398:	5f                   	pop    %edi
80103399:	5d                   	pop    %ebp
8010339a:	c3                   	ret    
8010339b:	90                   	nop
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	56                   	push   %esi
801033a4:	53                   	push   %ebx
801033a5:	83 ec 10             	sub    $0x10,%esp
801033a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033ae:	89 1c 24             	mov    %ebx,(%esp)
801033b1:	e8 3a 15 00 00       	call   801048f0 <acquire>
  if(writable){
801033b6:	85 f6                	test   %esi,%esi
801033b8:	74 3e                	je     801033f8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801033ba:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801033c0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033c7:	00 00 00 
    wakeup(&p->nread);
801033ca:	89 04 24             	mov    %eax,(%esp)
801033cd:	e8 7e 10 00 00       	call   80104450 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033d2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033d8:	85 d2                	test   %edx,%edx
801033da:	75 0a                	jne    801033e6 <pipeclose+0x46>
801033dc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033e2:	85 c0                	test   %eax,%eax
801033e4:	74 32                	je     80103418 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033e9:	83 c4 10             	add    $0x10,%esp
801033ec:	5b                   	pop    %ebx
801033ed:	5e                   	pop    %esi
801033ee:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033ef:	e9 2c 16 00 00       	jmp    80104a20 <release>
801033f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801033f8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801033fe:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103405:	00 00 00 
    wakeup(&p->nwrite);
80103408:	89 04 24             	mov    %eax,(%esp)
8010340b:	e8 40 10 00 00       	call   80104450 <wakeup>
80103410:	eb c0                	jmp    801033d2 <pipeclose+0x32>
80103412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103418:	89 1c 24             	mov    %ebx,(%esp)
8010341b:	e8 00 16 00 00       	call   80104a20 <release>
    kfree((char*)p);
80103420:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
80103423:	83 c4 10             	add    $0x10,%esp
80103426:	5b                   	pop    %ebx
80103427:	5e                   	pop    %esi
80103428:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103429:	e9 b2 ee ff ff       	jmp    801022e0 <kfree>
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 1c             	sub    $0x1c,%esp
80103439:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010343c:	89 3c 24             	mov    %edi,(%esp)
8010343f:	e8 ac 14 00 00       	call   801048f0 <acquire>
  for(i = 0; i < n; i++){
80103444:	8b 45 10             	mov    0x10(%ebp),%eax
80103447:	85 c0                	test   %eax,%eax
80103449:	0f 8e c2 00 00 00    	jle    80103511 <pipewrite+0xe1>
8010344f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103452:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
80103458:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
8010345e:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103467:	03 45 10             	add    0x10(%ebp),%eax
8010346a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010346d:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103473:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
80103479:	39 d1                	cmp    %edx,%ecx
8010347b:	0f 85 c4 00 00 00    	jne    80103545 <pipewrite+0x115>
      if(p->readopen == 0 || proc->killed){
80103481:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103487:	85 d2                	test   %edx,%edx
80103489:	0f 84 a1 00 00 00    	je     80103530 <pipewrite+0x100>
8010348f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103496:	8b 42 24             	mov    0x24(%edx),%eax
80103499:	85 c0                	test   %eax,%eax
8010349b:	74 22                	je     801034bf <pipewrite+0x8f>
8010349d:	e9 8e 00 00 00       	jmp    80103530 <pipewrite+0x100>
801034a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034a8:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
801034ae:	85 c0                	test   %eax,%eax
801034b0:	74 7e                	je     80103530 <pipewrite+0x100>
801034b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801034b8:	8b 48 24             	mov    0x24(%eax),%ecx
801034bb:	85 c9                	test   %ecx,%ecx
801034bd:	75 71                	jne    80103530 <pipewrite+0x100>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034bf:	89 34 24             	mov    %esi,(%esp)
801034c2:	e8 89 0f 00 00       	call   80104450 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
801034cb:	89 1c 24             	mov    %ebx,(%esp)
801034ce:	e8 8d 0d 00 00       	call   80104260 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034d3:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801034d9:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801034df:	05 00 02 00 00       	add    $0x200,%eax
801034e4:	39 c2                	cmp    %eax,%edx
801034e6:	74 c0                	je     801034a8 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034eb:	8d 4a 01             	lea    0x1(%edx),%ecx
801034ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034f4:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801034fa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801034fe:	0f b6 00             	movzbl (%eax),%eax
80103501:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103508:	3b 45 e0             	cmp    -0x20(%ebp),%eax
8010350b:	0f 85 5c ff ff ff    	jne    8010346d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103511:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
80103517:	89 14 24             	mov    %edx,(%esp)
8010351a:	e8 31 0f 00 00       	call   80104450 <wakeup>
  release(&p->lock);
8010351f:	89 3c 24             	mov    %edi,(%esp)
80103522:	e8 f9 14 00 00       	call   80104a20 <release>
  return n;
80103527:	8b 45 10             	mov    0x10(%ebp),%eax
8010352a:	eb 11                	jmp    8010353d <pipewrite+0x10d>
8010352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103530:	89 3c 24             	mov    %edi,(%esp)
80103533:	e8 e8 14 00 00       	call   80104a20 <release>
        return -1;
80103538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010353d:	83 c4 1c             	add    $0x1c,%esp
80103540:	5b                   	pop    %ebx
80103541:	5e                   	pop    %esi
80103542:	5f                   	pop    %edi
80103543:	5d                   	pop    %ebp
80103544:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103545:	89 ca                	mov    %ecx,%edx
80103547:	eb 9f                	jmp    801034e8 <pipewrite+0xb8>
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103550 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	57                   	push   %edi
80103554:	56                   	push   %esi
80103555:	53                   	push   %ebx
80103556:	83 ec 1c             	sub    $0x1c,%esp
80103559:	8b 75 08             	mov    0x8(%ebp),%esi
8010355c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010355f:	89 34 24             	mov    %esi,(%esp)
80103562:	e8 89 13 00 00       	call   801048f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103567:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010356d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103573:	75 5b                	jne    801035d0 <piperead+0x80>
80103575:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010357b:	85 db                	test   %ebx,%ebx
8010357d:	74 51                	je     801035d0 <piperead+0x80>
8010357f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103585:	eb 25                	jmp    801035ac <piperead+0x5c>
80103587:	90                   	nop
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103588:	89 74 24 04          	mov    %esi,0x4(%esp)
8010358c:	89 1c 24             	mov    %ebx,(%esp)
8010358f:	e8 cc 0c 00 00       	call   80104260 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103594:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010359a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801035a0:	75 2e                	jne    801035d0 <piperead+0x80>
801035a2:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a8:	85 d2                	test   %edx,%edx
801035aa:	74 24                	je     801035d0 <piperead+0x80>
    if(proc->killed){
801035ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801035b2:	8b 48 24             	mov    0x24(%eax),%ecx
801035b5:	85 c9                	test   %ecx,%ecx
801035b7:	74 cf                	je     80103588 <piperead+0x38>
      release(&p->lock);
801035b9:	89 34 24             	mov    %esi,(%esp)
801035bc:	e8 5f 14 00 00       	call   80104a20 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c1:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801035c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c9:	5b                   	pop    %ebx
801035ca:	5e                   	pop    %esi
801035cb:	5f                   	pop    %edi
801035cc:	5d                   	pop    %ebp
801035cd:	c3                   	ret    
801035ce:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d0:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
801035d3:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d5:	85 d2                	test   %edx,%edx
801035d7:	7f 2b                	jg     80103604 <piperead+0xb4>
801035d9:	eb 31                	jmp    8010360c <piperead+0xbc>
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035e0:	8d 48 01             	lea    0x1(%eax),%ecx
801035e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801035e8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801035ee:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801035f3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f6:	83 c3 01             	add    $0x1,%ebx
801035f9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801035fc:	74 0e                	je     8010360c <piperead+0xbc>
    if(p->nread == p->nwrite)
801035fe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103604:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010360a:	75 d4                	jne    801035e0 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010360c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103612:	89 04 24             	mov    %eax,(%esp)
80103615:	e8 36 0e 00 00       	call   80104450 <wakeup>
  release(&p->lock);
8010361a:	89 34 24             	mov    %esi,(%esp)
8010361d:	e8 fe 13 00 00       	call   80104a20 <release>
  return i;
}
80103622:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
80103625:	89 d8                	mov    %ebx,%eax
}
80103627:	5b                   	pop    %ebx
80103628:	5e                   	pop    %esi
80103629:	5f                   	pop    %edi
8010362a:	5d                   	pop    %ebp
8010362b:	c3                   	ret    
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <stride_queue_heapify_down>:
  // locate a process to right position
  ptable.stride_queue[stride_idx] = target_proc;

}

void stride_queue_heapify_down(int stride_idx) {
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 04             	sub    $0x4,%esp
  struct proc* p = ptable.stride_queue[stride_idx];

  while(stride_idx <= ptable.stride_queue_size) {
80103639:	8b 1d f4 63 11 80    	mov    0x801163f4,%ebx
  ptable.stride_queue[stride_idx] = target_proc;

}

void stride_queue_heapify_down(int stride_idx) {
  struct proc* p = ptable.stride_queue[stride_idx];
8010363f:	8d b0 50 09 00 00    	lea    0x950(%eax),%esi
80103645:	8b 3c b5 ac 3d 11 80 	mov    -0x7feec254(,%esi,4),%edi

  while(stride_idx <= ptable.stride_queue_size) {
8010364c:	39 d8                	cmp    %ebx,%eax
8010364e:	89 5d f0             	mov    %ebx,-0x10(%ebp)
80103651:	0f 8f 87 00 00 00    	jg     801036de <stride_queue_heapify_down+0xae>
    if (ptable.stride_queue[stride_idx * 2] 
80103657:	01 c0                	add    %eax,%eax
80103659:	8b 0c 85 ec 62 11 80 	mov    -0x7fee9d14(,%eax,4),%ecx
80103660:	85 c9                	test   %ecx,%ecx
80103662:	75 51                	jne    801036b5 <stride_queue_heapify_down+0x85>
80103664:	eb 78                	jmp    801036de <stride_queue_heapify_down+0xae>
80103666:	66 90                	xchg   %ax,%ax
      // two childen

      // get smaller one among children
      stride_idx = ptable.stride_queue[stride_idx * 2]->stride_count 
                    < ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
                    ? stride_idx * 2 : stride_idx * 2 + 1;
80103668:	8b b3 90 00 00 00    	mov    0x90(%ebx),%esi
8010366e:	39 b1 90 00 00 00    	cmp    %esi,0x90(%ecx)
80103674:	0f 4c d0             	cmovl  %eax,%edx

      // if children's minimum is smaller than parent, swap
      if (ptable.stride_queue[stride_idx]->stride_count < p->stride_count) {
80103677:	8b 87 90 00 00 00    	mov    0x90(%edi),%eax
8010367d:	8d b2 50 09 00 00    	lea    0x950(%edx),%esi
80103683:	8b 0c b5 ac 3d 11 80 	mov    -0x7feec254(,%esi,4),%ecx
8010368a:	39 81 90 00 00 00    	cmp    %eax,0x90(%ecx)
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
80103690:	89 d0                	mov    %edx,%eax
      stride_idx = ptable.stride_queue[stride_idx * 2]->stride_count 
                    < ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
                    ? stride_idx * 2 : stride_idx * 2 + 1;

      // if children's minimum is smaller than parent, swap
      if (ptable.stride_queue[stride_idx]->stride_count < p->stride_count) {
80103692:	7d 5c                	jge    801036f0 <stride_queue_heapify_down+0xc0>
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
80103694:	c1 e8 1f             	shr    $0x1f,%eax
80103697:	01 d0                	add    %edx,%eax
80103699:	d1 f8                	sar    %eax
}

void stride_queue_heapify_down(int stride_idx) {
  struct proc* p = ptable.stride_queue[stride_idx];

  while(stride_idx <= ptable.stride_queue_size) {
8010369b:	3b 55 f0             	cmp    -0x10(%ebp),%edx
                    < ptable.stride_queue[stride_idx * 2 + 1]->stride_count 
                    ? stride_idx * 2 : stride_idx * 2 + 1;

      // if children's minimum is smaller than parent, swap
      if (ptable.stride_queue[stride_idx]->stride_count < p->stride_count) {
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
8010369e:	89 0c 85 ec 62 11 80 	mov    %ecx,-0x7fee9d14(,%eax,4)
}

void stride_queue_heapify_down(int stride_idx) {
  struct proc* p = ptable.stride_queue[stride_idx];

  while(stride_idx <= ptable.stride_queue_size) {
801036a5:	7f 37                	jg     801036de <stride_queue_heapify_down+0xae>
    if (ptable.stride_queue[stride_idx * 2] 
801036a7:	8d 04 12             	lea    (%edx,%edx,1),%eax
801036aa:	8b 0c 85 ec 62 11 80 	mov    -0x7fee9d14(,%eax,4),%ecx
801036b1:	85 c9                	test   %ecx,%ecx
801036b3:	74 29                	je     801036de <stride_queue_heapify_down+0xae>
        && ptable.stride_queue[stride_idx * 2 + 1]) {
801036b5:	8b 1c 85 f0 62 11 80 	mov    -0x7fee9d10(,%eax,4),%ebx
801036bc:	8d 50 01             	lea    0x1(%eax),%edx
801036bf:	85 db                	test   %ebx,%ebx
801036c1:	75 a5                	jne    80103668 <stride_queue_heapify_down+0x38>

    } else if (ptable.stride_queue[stride_idx * 2]) {
      // only left child (== the last element)
      stride_idx *= 2;
      // if left child's value is smaller than parent, swap
      if(ptable.stride_queue[stride_idx]->stride_count < p->stride_count) {
801036c3:	8b 9f 90 00 00 00    	mov    0x90(%edi),%ebx
801036c9:	39 99 90 00 00 00    	cmp    %ebx,0x90(%ecx)
801036cf:	7d 0d                	jge    801036de <stride_queue_heapify_down+0xae>
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
801036d1:	89 0c b5 ac 3d 11 80 	mov    %ecx,-0x7feec254(,%esi,4)
801036d8:	8d b0 50 09 00 00    	lea    0x950(%eax),%esi
      break;
    }
  }
  
  // current process' place
  ptable.stride_queue[stride_idx] = p;
801036de:	89 3c b5 ac 3d 11 80 	mov    %edi,-0x7feec254(,%esi,4)

}
801036e5:	83 c4 04             	add    $0x4,%esp
801036e8:	5b                   	pop    %ebx
801036e9:	5e                   	pop    %esi
801036ea:	5f                   	pop    %edi
801036eb:	5d                   	pop    %ebp
801036ec:	c3                   	ret    
801036ed:	8d 76 00             	lea    0x0(%esi),%esi

      // if children's minimum is smaller than parent, swap
      if (ptable.stride_queue[stride_idx]->stride_count < p->stride_count) {
        ptable.stride_queue[stride_idx / 2] = ptable.stride_queue[stride_idx];
      } else {
        stride_idx /= 2;
801036f0:	c1 e8 1f             	shr    $0x1f,%eax
801036f3:	01 c2                	add    %eax,%edx
801036f5:	d1 fa                	sar    %edx
801036f7:	8d b2 50 09 00 00    	lea    0x950(%edx),%esi
      break;
    }
  }
  
  // current process' place
  ptable.stride_queue[stride_idx] = p;
801036fd:	89 3c b5 ac 3d 11 80 	mov    %edi,-0x7feec254(,%esi,4)

}
80103704:	83 c4 04             	add    $0x4,%esp
80103707:	5b                   	pop    %ebx
80103708:	5e                   	pop    %esi
80103709:	5f                   	pop    %edi
8010370a:	5d                   	pop    %ebp
8010370b:	c3                   	ret    
8010370c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103710 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103714:	bb d4 3d 11 80       	mov    $0x80113dd4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103719:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010371c:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80103723:	e8 c8 11 00 00       	call   801048f0 <acquire>
80103728:	eb 14                	jmp    8010373e <allocproc+0x2e>
8010372a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103730:	81 c3 94 00 00 00    	add    $0x94,%ebx
80103736:	81 fb d4 62 11 80    	cmp    $0x801162d4,%ebx
8010373c:	74 7a                	je     801037b8 <allocproc+0xa8>
    if(p->state == UNUSED)
8010373e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103741:	85 c0                	test   %eax,%eax
80103743:	75 eb                	jne    80103730 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103745:	a1 0c b0 10 80       	mov    0x8010b00c,%eax

  release(&ptable.lock);
8010374a:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103751:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103758:	8d 50 01             	lea    0x1(%eax),%edx
8010375b:	89 15 0c b0 10 80    	mov    %edx,0x8010b00c
80103761:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103764:	e8 b7 12 00 00       	call   80104a20 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103769:	e8 22 ed ff ff       	call   80102490 <kalloc>
8010376e:	85 c0                	test   %eax,%eax
80103770:	89 43 08             	mov    %eax,0x8(%ebx)
80103773:	74 57                	je     801037cc <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103775:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010377b:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103780:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103783:	c7 40 14 ed 5b 10 80 	movl   $0x80105bed,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010378a:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103791:	00 
80103792:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103799:	00 
8010379a:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010379d:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037a0:	e8 cb 12 00 00       	call   80104a70 <memset>
  p->context->eip = (uint)forkret;
801037a5:	8b 43 1c             	mov    0x1c(%ebx),%eax
801037a8:	c7 40 10 e0 37 10 80 	movl   $0x801037e0,0x10(%eax)

  return p;
801037af:	89 d8                	mov    %ebx,%eax
}
801037b1:	83 c4 14             	add    $0x14,%esp
801037b4:	5b                   	pop    %ebx
801037b5:	5d                   	pop    %ebp
801037b6:	c3                   	ret    
801037b7:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801037b8:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801037bf:	e8 5c 12 00 00       	call   80104a20 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801037c4:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
801037c7:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801037c9:	5b                   	pop    %ebx
801037ca:	5d                   	pop    %ebp
801037cb:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801037cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801037d3:	eb dc                	jmp    801037b1 <allocproc+0xa1>
801037d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801037e6:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801037ed:	e8 2e 12 00 00       	call   80104a20 <release>

  if (first) {
801037f2:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801037f7:	85 c0                	test   %eax,%eax
801037f9:	75 05                	jne    80103800 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037fb:	c9                   	leave  
801037fc:	c3                   	ret    
801037fd:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103800:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103807:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
8010380e:	00 00 00 
    iinit(ROOTDEV);
80103811:	e8 5a dc ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
80103816:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010381d:	e8 be f2 ff ff       	call   80102ae0 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103822:	c9                   	leave  
80103823:	c3                   	ret    
80103824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010382a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103830 <get_time_quantum>:

// getters and setters
int
get_time_quantum() 
{
  if(proc && proc->cpu_share != 0) {
80103830:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax


// getters and setters
int
get_time_quantum() 
{
80103836:	55                   	push   %ebp
80103837:	89 e5                	mov    %esp,%ebp
  if(proc && proc->cpu_share != 0) {
80103839:	85 c0                	test   %eax,%eax
8010383b:	74 0a                	je     80103847 <get_time_quantum+0x17>
8010383d:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80103843:	85 d2                	test   %edx,%edx
80103845:	75 11                	jne    80103858 <get_time_quantum+0x28>
    return ptable.stride_time_quantum;
  } else {
    return ptable.MLFQ_time_quantum[proc->level_of_MLFQ];
80103847:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  }
}
8010384d:	5d                   	pop    %ebp
get_time_quantum() 
{
  if(proc && proc->cpu_share != 0) {
    return ptable.stride_time_quantum;
  } else {
    return ptable.MLFQ_time_quantum[proc->level_of_MLFQ];
8010384e:	8b 04 85 d4 62 11 80 	mov    -0x7fee9d2c(,%eax,4),%eax
  }
}
80103855:	c3                   	ret    
80103856:	66 90                	xchg   %ax,%ax
// getters and setters
int
get_time_quantum() 
{
  if(proc && proc->cpu_share != 0) {
    return ptable.stride_time_quantum;
80103858:	a1 f8 63 11 80       	mov    0x801163f8,%eax
  } else {
    return ptable.MLFQ_time_quantum[proc->level_of_MLFQ];
  }
}
8010385d:	5d                   	pop    %ebp
8010385e:	c3                   	ret    
8010385f:	90                   	nop

80103860 <get_MLFQ_tick_used>:

// Design Document 1-1-2-4
int get_MLFQ_tick_used(void)
{
80103860:	55                   	push   %ebp
  return ptable.MLFQ_tick_used;
}
80103861:	a1 e0 62 11 80       	mov    0x801162e0,%eax
  }
}

// Design Document 1-1-2-4
int get_MLFQ_tick_used(void)
{
80103866:	89 e5                	mov    %esp,%ebp
  return ptable.MLFQ_tick_used;
}
80103868:	5d                   	pop    %ebp
80103869:	c3                   	ret    
8010386a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103870 <increase_MLFQ_tick_used>:

void increase_MLFQ_tick_used(void)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
  ptable.MLFQ_tick_used++;
80103873:	83 05 e0 62 11 80 01 	addl   $0x1,0x801162e0
#ifdef STRIRDE_DEBUGGING
  cprintf("\rMLFQ_tick_used: %d", ptable.MLFQ_tick_used);
#endif
}
8010387a:	5d                   	pop    %ebp
8010387b:	c3                   	ret    
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103880 <increase_stride_tick_used>:

void increase_stride_tick_used(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
  ptable.stride_tick_used++;
80103883:	83 05 fc 63 11 80 01 	addl   $0x1,0x801163fc
#ifdef STRIRDE_DEBUGGING
  cprintf("\rstride_tick_used: %d", ptable.stride_tick_used);
#endif
}
8010388a:	5d                   	pop    %ebp
8010388b:	c3                   	ret    
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103890 <pinit>:


void
pinit(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 18             	sub    $0x18,%esp
  // Design Document 1-1-2-4. Initializing the time_quantum array.
  int queue_level;
  int default_ticks = 5;
  initlock(&ptable.lock, "ptable");
80103896:	c7 44 24 04 2d 7b 10 	movl   $0x80107b2d,0x4(%esp)
8010389d:	80 
8010389e:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801038a5:	e8 c6 0f 00 00       	call   80104870 <initlock>
  ptable.MLFQ_tick_used = 0;

  ptable.queue_level_at_most = NMLFQ - 1;
  ptable.min_of_run_proc_level = NMLFQ - 1;

  memset(ptable.stride_queue, 0, sizeof(ptable.stride_queue));
801038aa:	c7 44 24 08 04 01 00 	movl   $0x104,0x8(%esp)
801038b1:	00 
801038b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801038b9:	00 
801038ba:	c7 04 24 ec 62 11 80 	movl   $0x801162ec,(%esp)

  // Initializing ptable variables.
  // Design Document 1-2-2-3.
  // Initializing time quantum
  for (queue_level = 0; queue_level < NMLFQ; ++queue_level) {
      ptable.MLFQ_time_quantum[queue_level] = default_ticks;
801038c1:	c7 05 d4 62 11 80 05 	movl   $0x5,0x801162d4
801038c8:	00 00 00 
801038cb:	c7 05 d8 62 11 80 0a 	movl   $0xa,0x801162d8
801038d2:	00 00 00 
801038d5:	c7 05 dc 62 11 80 14 	movl   $0x14,0x801162dc
801038dc:	00 00 00 
      default_ticks *= 2;
  }
  ptable.MLFQ_tick_used = 0;
801038df:	c7 05 e0 62 11 80 00 	movl   $0x0,0x801162e0
801038e6:	00 00 00 

  ptable.queue_level_at_most = NMLFQ - 1;
801038e9:	c7 05 e4 62 11 80 02 	movl   $0x2,0x801162e4
801038f0:	00 00 00 
  ptable.min_of_run_proc_level = NMLFQ - 1;
801038f3:	c7 05 e8 62 11 80 02 	movl   $0x2,0x801162e8
801038fa:	00 00 00 

  memset(ptable.stride_queue, 0, sizeof(ptable.stride_queue));
801038fd:	e8 6e 11 00 00       	call   80104a70 <memset>
  ptable.sum_cpu_share = 0;
80103902:	c7 05 f0 63 11 80 00 	movl   $0x0,0x801163f0
80103909:	00 00 00 
  ptable.stride_queue_size = 0;
8010390c:	c7 05 f4 63 11 80 00 	movl   $0x0,0x801163f4
80103913:	00 00 00 
  ptable.stride_time_quantum = 1; // It could be changed by designer.
80103916:	c7 05 f8 63 11 80 01 	movl   $0x1,0x801163f8
8010391d:	00 00 00 
  ptable.stride_tick_used = 0;
80103920:	c7 05 fc 63 11 80 00 	movl   $0x0,0x801163fc
80103927:	00 00 00 

}
8010392a:	c9                   	leave  
8010392b:	c3                   	ret    
8010392c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103930 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	53                   	push   %ebx
80103934:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103937:	e8 d4 fd ff ff       	call   80103710 <allocproc>
8010393c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010393e:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
  if((p->pgdir = setupkvm()) == 0)
80103943:	e8 68 35 00 00       	call   80106eb0 <setupkvm>
80103948:	85 c0                	test   %eax,%eax
8010394a:	89 43 04             	mov    %eax,0x4(%ebx)
8010394d:	0f 84 d4 00 00 00    	je     80103a27 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103953:	89 04 24             	mov    %eax,(%esp)
80103956:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010395d:	00 
8010395e:	c7 44 24 04 60 b4 10 	movl   $0x8010b460,0x4(%esp)
80103965:	80 
80103966:	e8 d5 36 00 00       	call   80107040 <inituvm>
  p->sz = PGSIZE;
8010396b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103971:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103978:	00 
80103979:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103980:	00 
80103981:	8b 43 18             	mov    0x18(%ebx),%eax
80103984:	89 04 24             	mov    %eax,(%esp)
80103987:	e8 e4 10 00 00       	call   80104a70 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010398c:	8b 43 18             	mov    0x18(%ebx),%eax
8010398f:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103994:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103999:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010399d:	8b 43 18             	mov    0x18(%ebx),%eax
801039a0:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039a4:	8b 43 18             	mov    0x18(%ebx),%eax
801039a7:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039ab:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039af:	8b 43 18             	mov    0x18(%ebx),%eax
801039b2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039b6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039ba:	8b 43 18             	mov    0x18(%ebx),%eax
801039bd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039c4:	8b 43 18             	mov    0x18(%ebx),%eax
801039c7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039ce:	8b 43 18             	mov    0x18(%ebx),%eax
801039d1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801039d8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039db:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801039e2:	00 
801039e3:	c7 44 24 04 4d 7b 10 	movl   $0x80107b4d,0x4(%esp)
801039ea:	80 
801039eb:	89 04 24             	mov    %eax,(%esp)
801039ee:	e8 5d 12 00 00       	call   80104c50 <safestrcpy>
  p->cwd = namei("/");
801039f3:	c7 04 24 56 7b 10 80 	movl   $0x80107b56,(%esp)
801039fa:	e8 e1 e4 ff ff       	call   80101ee0 <namei>
801039ff:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103a02:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80103a09:	e8 e2 0e 00 00       	call   801048f0 <acquire>

  p->state = RUNNABLE;
80103a0e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103a15:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80103a1c:	e8 ff 0f 00 00       	call   80104a20 <release>
}
80103a21:	83 c4 14             	add    $0x14,%esp
80103a24:	5b                   	pop    %ebx
80103a25:	5d                   	pop    %ebp
80103a26:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103a27:	c7 04 24 34 7b 10 80 	movl   $0x80107b34,(%esp)
80103a2e:	e8 2d c9 ff ff       	call   80100360 <panic>
80103a33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a40 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
80103a46:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103a4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
80103a50:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103a52:	83 f9 00             	cmp    $0x0,%ecx
80103a55:	7e 39                	jle    80103a90 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103a57:	01 c1                	add    %eax,%ecx
80103a59:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80103a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a61:	8b 42 04             	mov    0x4(%edx),%eax
80103a64:	89 04 24             	mov    %eax,(%esp)
80103a67:	e8 14 37 00 00       	call   80107180 <allocuvm>
80103a6c:	85 c0                	test   %eax,%eax
80103a6e:	74 40                	je     80103ab0 <growproc+0x70>
80103a70:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
80103a77:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103a79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a7f:	89 04 24             	mov    %eax,(%esp)
80103a82:	e8 e9 34 00 00       	call   80106f70 <switchuvm>
  return 0;
80103a87:	31 c0                	xor    %eax,%eax
}
80103a89:	c9                   	leave  
80103a8a:	c3                   	ret    
80103a8b:	90                   	nop
80103a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103a90:	74 e5                	je     80103a77 <growproc+0x37>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103a92:	01 c1                	add    %eax,%ecx
80103a94:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80103a98:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a9c:	8b 42 04             	mov    0x4(%edx),%eax
80103a9f:	89 04 24             	mov    %eax,(%esp)
80103aa2:	e8 c9 37 00 00       	call   80107270 <deallocuvm>
80103aa7:	85 c0                	test   %eax,%eax
80103aa9:	75 c5                	jne    80103a70 <growproc+0x30>
80103aab:	90                   	nop
80103aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103ab5:	c9                   	leave  
80103ab6:	c3                   	ret    
80103ab7:	89 f6                	mov    %esi,%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ac0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	57                   	push   %edi
80103ac4:	56                   	push   %esi
80103ac5:	53                   	push   %ebx
80103ac6:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
80103ac9:	e8 42 fc ff ff       	call   80103710 <allocproc>
80103ace:	85 c0                	test   %eax,%eax
80103ad0:	89 c3                	mov    %eax,%ebx
80103ad2:	0f 84 0e 01 00 00    	je     80103be6 <fork+0x126>
    return -1;
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103ad8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ade:	8b 10                	mov    (%eax),%edx
80103ae0:	89 54 24 04          	mov    %edx,0x4(%esp)
80103ae4:	8b 40 04             	mov    0x4(%eax),%eax
80103ae7:	89 04 24             	mov    %eax,(%esp)
80103aea:	e8 51 38 00 00       	call   80107340 <copyuvm>
80103aef:	85 c0                	test   %eax,%eax
80103af1:	89 43 04             	mov    %eax,0x4(%ebx)
80103af4:	0f 84 f3 00 00 00    	je     80103bed <fork+0x12d>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103afa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103b00:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b05:	8b 7b 18             	mov    0x18(%ebx),%edi
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
80103b08:	8b 00                	mov    (%eax),%eax
80103b0a:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103b0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b12:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103b15:	8b 70 18             	mov    0x18(%eax),%esi
80103b18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103b1a:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103b1c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b1f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103b26:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103b30:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103b34:	85 c0                	test   %eax,%eax
80103b36:	74 13                	je     80103b4b <fork+0x8b>
      np->ofile[i] = filedup(proc->ofile[i]);
80103b38:	89 04 24             	mov    %eax,(%esp)
80103b3b:	e8 90 d2 ff ff       	call   80100dd0 <filedup>
80103b40:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103b44:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103b4b:	83 c6 01             	add    $0x1,%esi
80103b4e:	83 fe 10             	cmp    $0x10,%esi
80103b51:	75 dd                	jne    80103b30 <fork+0x70>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103b53:	8b 42 68             	mov    0x68(%edx),%eax
80103b56:	89 04 24             	mov    %eax,(%esp)
80103b59:	e8 22 db ff ff       	call   80101680 <idup>
80103b5e:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103b61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b67:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103b6e:	00 
80103b6f:	83 c0 6c             	add    $0x6c,%eax
80103b72:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b76:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b79:	89 04 24             	mov    %eax,(%esp)
80103b7c:	e8 cf 10 00 00       	call   80104c50 <safestrcpy>

  pid = np->pid;
80103b81:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103b84:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80103b8b:	e8 60 0d 00 00       	call   801048f0 <acquire>

  // Design Document 1-1-2-2.
  // initializing values used in MLFQ.
  np->tick_used = 0;
80103b90:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  np->level_of_MLFQ = 0;
80103b97:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103b9e:	00 00 00 
  np->time_quantum_used = 0;
80103ba1:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103ba8:	00 00 00 

  // Design Document 1-2-2-2.
  // Initializing cpu_share
  np->cpu_share = 0;
80103bab:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103bb2:	00 00 00 
  np->stride = 0;
80103bb5:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103bbc:	00 00 00 
  np->stride_count = 0;
80103bbf:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103bc6:	00 00 00 

  np->state = RUNNABLE;
80103bc9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  //Design Document 1-1-2-5. A new process is generated.
  /** ptable.min_of_run_proc_level = 0; */
  /** ptable.queue_level_at_most = 0; */

  release(&ptable.lock);
80103bd0:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80103bd7:	e8 44 0e 00 00       	call   80104a20 <release>

  return pid;
80103bdc:	89 f0                	mov    %esi,%eax
}
80103bde:	83 c4 1c             	add    $0x1c,%esp
80103be1:	5b                   	pop    %ebx
80103be2:	5e                   	pop    %esi
80103be3:	5f                   	pop    %edi
80103be4:	5d                   	pop    %ebp
80103be5:	c3                   	ret    
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103be6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103beb:	eb f1                	jmp    80103bde <fork+0x11e>
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103bed:	8b 43 08             	mov    0x8(%ebx),%eax
80103bf0:	89 04 24             	mov    %eax,(%esp)
80103bf3:	e8 e8 e6 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
80103bf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103bfd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c04:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c0b:	eb d1                	jmp    80103bde <fork+0x11e>
80103c0d:	8d 76 00             	lea    0x0(%esi),%esi

80103c10 <find_idx_of_stride_to_run>:
  // current process' place
  ptable.stride_queue[stride_idx] = p;

}

int find_idx_of_stride_to_run(void) {
80103c10:	a1 f4 63 11 80       	mov    0x801163f4,%eax
80103c15:	55                   	push   %ebp
80103c16:	89 e5                	mov    %esp,%ebp
80103c18:	57                   	push   %edi
80103c19:	56                   	push   %esi
80103c1a:	53                   	push   %ebx
  struct proc* proc_to_be_run;
  
  // From the start to the end of stride queue
  int stride_find_idx = 1;
80103c1b:	bb 01 00 00 00       	mov    $0x1,%ebx
        stride_find_idx = left_child;

      } else {
        // NO_CHILD
        // End the loop. Make index bigger than stride_queue_size
        stride_find_idx = ptable.stride_queue_size + 1;
80103c20:	8d 70 01             	lea    0x1(%eax),%esi
80103c23:	90                   	nop
80103c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int find_idx_of_stride_to_run(void) {
  struct proc* proc_to_be_run;
  
  // From the start to the end of stride queue
  int stride_find_idx = 1;
  while (stride_find_idx <= ptable.stride_queue_size) {
80103c28:	39 c3                	cmp    %eax,%ebx
80103c2a:	7f 1f                	jg     80103c4b <find_idx_of_stride_to_run+0x3b>
    if (ptable.stride_queue[stride_find_idx]->state == RUNNABLE) {
80103c2c:	8b 14 9d ec 62 11 80 	mov    -0x7fee9d14(,%ebx,4),%edx
80103c33:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80103c37:	74 3f                	je     80103c78 <find_idx_of_stride_to_run+0x68>
      // End finding. Go to run selected process.
      break;
    } else {
      // Not found
      // select between children whose stirde_value is smaller
      int left_child = stride_find_idx * 2;
80103c39:	01 db                	add    %ebx,%ebx
      int right_child = stride_find_idx * 2 + 1;
80103c3b:	8d 53 01             	lea    0x1(%ebx),%edx
      enum {NO_CHILD, LEFT_ONLY, BOTH} child_status;

      if (right_child <= ptable.stride_queue_size) {
80103c3e:	39 c2                	cmp    %eax,%edx
80103c40:	7e 16                	jle    80103c58 <find_idx_of_stride_to_run+0x48>
        stride_find_idx = left_child;

      } else {
        // NO_CHILD
        // End the loop. Make index bigger than stride_queue_size
        stride_find_idx = ptable.stride_queue_size + 1;
80103c42:	39 c3                	cmp    %eax,%ebx
80103c44:	0f 4f de             	cmovg  %esi,%ebx
int find_idx_of_stride_to_run(void) {
  struct proc* proc_to_be_run;
  
  // From the start to the end of stride queue
  int stride_find_idx = 1;
  while (stride_find_idx <= ptable.stride_queue_size) {
80103c47:	39 c3                	cmp    %eax,%ebx
80103c49:	7e e1                	jle    80103c2c <find_idx_of_stride_to_run+0x1c>
      }
    }
  }

  return stride_find_idx;
}
80103c4b:	89 d8                	mov    %ebx,%eax
80103c4d:	5b                   	pop    %ebx
80103c4e:	5e                   	pop    %esi
80103c4f:	5f                   	pop    %edi
80103c50:	5d                   	pop    %ebp
80103c51:	c3                   	ret    
80103c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

      // Check children's existence.
      if (child_status == BOTH) {
        // Left and right children is exist.
        if (ptable.stride_queue[left_child]->stride_count
            < ptable.stride_queue[right_child]->stride_count) {
80103c58:	8b 0c 9d f0 62 11 80 	mov    -0x7fee9d10(,%ebx,4),%ecx
80103c5f:	8b 3c 9d ec 62 11 80 	mov    -0x7fee9d14(,%ebx,4),%edi
80103c66:	8b 89 90 00 00 00    	mov    0x90(%ecx),%ecx
80103c6c:	39 8f 90 00 00 00    	cmp    %ecx,0x90(%edi)
80103c72:	0f 4d da             	cmovge %edx,%ebx
80103c75:	eb b1                	jmp    80103c28 <find_idx_of_stride_to_run+0x18>
80103c77:	90                   	nop
  while (stride_find_idx <= ptable.stride_queue_size) {
    if (ptable.stride_queue[stride_find_idx]->state == RUNNABLE) {
      // Found
      // Increase stride count of current process and heapify.
      proc_to_be_run = ptable.stride_queue[stride_find_idx];
      proc_to_be_run->stride_count += proc_to_be_run->stride;
80103c78:	8b 82 8c 00 00 00    	mov    0x8c(%edx),%eax
80103c7e:	01 82 90 00 00 00    	add    %eax,0x90(%edx)
      stride_queue_heapify_down(stride_find_idx);
80103c84:	89 d8                	mov    %ebx,%eax
80103c86:	e8 a5 f9 ff ff       	call   80103630 <stride_queue_heapify_down>
      }
    }
  }

  return stride_find_idx;
}
80103c8b:	89 d8                	mov    %ebx,%eax
80103c8d:	5b                   	pop    %ebx
80103c8e:	5e                   	pop    %esi
80103c8f:	5f                   	pop    %edi
80103c90:	5d                   	pop    %ebp
80103c91:	c3                   	ret    
80103c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ca0 <select_stride_or_MLFQ>:

int select_stride_or_MLFQ() {
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80103ca0:	69 0d 08 b0 10 80 0d 	imul   $0x19660d,0x8010b008,%ecx
80103ca7:	66 19 00 
  queue_selector = randstate % 100;
80103caa:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  }

  return stride_find_idx;
}

int select_stride_or_MLFQ() {
80103caf:	55                   	push   %ebp
80103cb0:	89 e5                	mov    %esp,%ebp
    return 1;
  } else {
    // MLFQ is selected
    return 0;;
  }
}
80103cb2:	5d                   	pop    %ebp
}

int select_stride_or_MLFQ() {
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80103cb3:	81 c1 5f f3 6e 3c    	add    $0x3c6ef35f,%ecx
  queue_selector = randstate % 100;
80103cb9:	89 c8                	mov    %ecx,%eax
80103cbb:	f7 ea                	imul   %edx
80103cbd:	89 c8                	mov    %ecx,%eax
80103cbf:	c1 f8 1f             	sar    $0x1f,%eax
}

int select_stride_or_MLFQ() {
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80103cc2:	89 0d 08 b0 10 80    	mov    %ecx,0x8010b008
  queue_selector = randstate % 100;
80103cc8:	c1 fa 05             	sar    $0x5,%edx
80103ccb:	29 c2                	sub    %eax,%edx

  if (queue_selector < ptable.sum_cpu_share) {
80103ccd:	31 c0                	xor    %eax,%eax

int select_stride_or_MLFQ() {
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
  queue_selector = randstate % 100;
80103ccf:	6b d2 64             	imul   $0x64,%edx,%edx
80103cd2:	29 d1                	sub    %edx,%ecx

  if (queue_selector < ptable.sum_cpu_share) {
80103cd4:	3b 0d f0 63 11 80    	cmp    0x801163f0,%ecx
80103cda:	0f 9c c0             	setl   %al
    return 1;
  } else {
    // MLFQ is selected
    return 0;;
  }
}
80103cdd:	c3                   	ret    
80103cde:	66 90                	xchg   %ax,%ax

80103ce0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	57                   	push   %edi
  struct proc *p;
  
  // Design Document 1-2-2-5
  int choosing_stride_or_MLFQ;
  int stride_is_selected = 0;
80103ce4:	31 ff                	xor    %edi,%edi
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103ce6:	56                   	push   %esi

int select_stride_or_MLFQ() {
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
  queue_selector = randstate % 100;
80103ce7:	be 1f 85 eb 51       	mov    $0x51eb851f,%esi
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103cec:	53                   	push   %ebx
80103ced:	83 ec 1c             	sub    $0x1c,%esp
}

static inline void
sti(void)
{
  asm volatile("sti");
80103cf0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103cf1:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80103cf8:	e8 f3 0b 00 00       	call   801048f0 <acquire>

    // choose the stride queue or MLFQ
    choosing_stride_or_MLFQ = 1;
80103cfd:	b8 01 00 00 00       	mov    $0x1,%eax

    // When while loop is end, there are only processes of last level of queue.
    ptable.queue_level_at_most = NMLFQ - 1; // last level
80103d02:	c7 05 e4 62 11 80 02 	movl   $0x2,0x801162e4
80103d09:	00 00 00 
80103d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(ptable.queue_level_at_most < NMLFQ) {

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;
80103d10:	c7 05 e8 62 11 80 02 	movl   $0x2,0x801162e8
80103d17:	00 00 00 

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d1a:	bb d4 3d 11 80       	mov    $0x80113dd4,%ebx
80103d1f:	e9 be 00 00 00       	jmp    80103de2 <scheduler+0x102>
80103d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        // Design Document 1-2-2-5. Choosing the stride queue or MLFQ
        if(ptable.sum_cpu_share != 0 && choosing_stride_or_MLFQ) {
80103d28:	85 c0                	test   %eax,%eax
80103d2a:	0f 84 c0 00 00 00    	je     80103df0 <scheduler+0x110>
}

int select_stride_or_MLFQ() {
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80103d30:	69 3d 08 b0 10 80 0d 	imul   $0x19660d,0x8010b008,%edi
80103d37:	66 19 00 
80103d3a:	81 c7 5f f3 6e 3c    	add    $0x3c6ef35f,%edi
  queue_selector = randstate % 100;
80103d40:	89 f8                	mov    %edi,%eax
80103d42:	f7 ee                	imul   %esi
80103d44:	89 f8                	mov    %edi,%eax
80103d46:	c1 f8 1f             	sar    $0x1f,%eax
}

int select_stride_or_MLFQ() {
  static int randstate = 1;
  int queue_selector;
  randstate = randstate * 1664525 + 1013904223; // in usertests.c : rand() of xv6
80103d49:	89 3d 08 b0 10 80    	mov    %edi,0x8010b008
  queue_selector = randstate % 100;
80103d4f:	c1 fa 05             	sar    $0x5,%edx
80103d52:	29 c2                	sub    %eax,%edx
80103d54:	6b d2 64             	imul   $0x64,%edx,%edx
80103d57:	29 d7                	sub    %edx,%edi

  if (queue_selector < ptable.sum_cpu_share) {
80103d59:	39 f9                	cmp    %edi,%ecx
80103d5b:	0f 8e 97 00 00 00    	jle    80103df8 <scheduler+0x118>
        if(stride_is_selected) {
          // The stride queue is selceted.
          
          int stride_idx_to_be_run;
          // Find a process whose state is RUNNABLE in the stride queue
          stride_idx_to_be_run = find_idx_of_stride_to_run();
80103d61:	e8 aa fe ff ff       	call   80103c10 <find_idx_of_stride_to_run>

          // Check whether process is found or not.
          if (stride_idx_to_be_run <= ptable.stride_queue_size) {
80103d66:	3b 05 f4 63 11 80    	cmp    0x801163f4,%eax
80103d6c:	0f 8f 5e 01 00 00    	jg     80103ed0 <scheduler+0x1f0>
            // Process is found. Go to run found process
            p = ptable.stride_queue[stride_idx_to_be_run];
80103d72:	8b 1c 85 ec 62 11 80 	mov    -0x7fee9d14(,%eax,4),%ebx

        if(stride_is_selected) {
          // To remove the side effect of stride algorithm, restore the process pointer and decrase it.
          // It will be increased in 'for' statement, so the status of MLFQ is same.
          p = p_mlfq;
          p--;
80103d79:	bf 01 00 00 00       	mov    $0x1,%edi
        cprintf("stride:%d, ", p->stride);
        cprintf("stride_count:%d\n", p->stride_count);
        /** cprintf("ContChange. stride_is_selected:%d, proc_name:%s, proc_id:%d, MLFQ_tick:%d, level:%d, stride_tick:%d, cpu_share:%d, sum_cpu_share: %d, stride:%d, stride_count:%d\n", stride_is_selected, p->name, p->pid, ptable.MLFQ_tick_used,p->level_of_MLFQ , ptable.stride_tick_used, p->cpu_share, ptable.sum_cpu_share, p->stride, p->stride_count); */
#endif
        proc = p;
        switchuvm(p);
80103d7e:	89 1c 24             	mov    %ebx,(%esp)
        cprintf("sum_cpu_share: %d, ", ptable.sum_cpu_share);
        cprintf("stride:%d, ", p->stride);
        cprintf("stride_count:%d\n", p->stride_count);
        /** cprintf("ContChange. stride_is_selected:%d, proc_name:%s, proc_id:%d, MLFQ_tick:%d, level:%d, stride_tick:%d, cpu_share:%d, sum_cpu_share: %d, stride:%d, stride_count:%d\n", stride_is_selected, p->name, p->pid, ptable.MLFQ_tick_used,p->level_of_MLFQ , ptable.stride_tick_used, p->cpu_share, ptable.sum_cpu_share, p->stride, p->stride_count); */
#endif
        proc = p;
80103d81:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4

        if(stride_is_selected) {
          // To remove the side effect of stride algorithm, restore the process pointer and decrase it.
          // It will be increased in 'for' statement, so the status of MLFQ is same.
          p = p_mlfq;
          p--;
80103d88:	81 eb 94 00 00 00    	sub    $0x94,%ebx
        cprintf("stride:%d, ", p->stride);
        cprintf("stride_count:%d\n", p->stride_count);
        /** cprintf("ContChange. stride_is_selected:%d, proc_name:%s, proc_id:%d, MLFQ_tick:%d, level:%d, stride_tick:%d, cpu_share:%d, sum_cpu_share: %d, stride:%d, stride_count:%d\n", stride_is_selected, p->name, p->pid, ptable.MLFQ_tick_used,p->level_of_MLFQ , ptable.stride_tick_used, p->cpu_share, ptable.sum_cpu_share, p->stride, p->stride_count); */
#endif
        proc = p;
        switchuvm(p);
80103d8e:	e8 dd 31 00 00       	call   80106f70 <switchuvm>

        // Back up MLFQ tick for check whether a process in MLFQ uses at least one tick.
        // I did not use 'if', so in this code is executed in stride algorithm, but it does not make problem.
        before_MLFQ_used_tick = ptable.MLFQ_tick_used;

        swtch(&cpu->scheduler, p->context); // This function returns in sched().
80103d93:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
        cprintf("stride_count:%d\n", p->stride_count);
        /** cprintf("ContChange. stride_is_selected:%d, proc_name:%s, proc_id:%d, MLFQ_tick:%d, level:%d, stride_tick:%d, cpu_share:%d, sum_cpu_share: %d, stride:%d, stride_count:%d\n", stride_is_selected, p->name, p->pid, ptable.MLFQ_tick_used,p->level_of_MLFQ , ptable.stride_tick_used, p->cpu_share, ptable.sum_cpu_share, p->stride, p->stride_count); */
#endif
        proc = p;
        switchuvm(p);
        p->state = RUNNING;
80103d99:	c7 83 a0 00 00 00 04 	movl   $0x4,0xa0(%ebx)
80103da0:	00 00 00 

        // Back up MLFQ tick for check whether a process in MLFQ uses at least one tick.
        // I did not use 'if', so in this code is executed in stride algorithm, but it does not make problem.
        before_MLFQ_used_tick = ptable.MLFQ_tick_used;

        swtch(&cpu->scheduler, p->context); // This function returns in sched().
80103da3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103da7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103dad:	83 c0 04             	add    $0x4,%eax
80103db0:	89 04 24             	mov    %eax,(%esp)
80103db3:	e8 f3 0e 00 00       	call   80104cab <swtch>
        switchkvm();
80103db8:	e8 93 31 00 00       	call   80106f50 <switchkvm>

          // 2) To re-run current process, decrease pointer's value. 
          //    It will be increased in 'for' statement, so current process will be re-selected.
          p--;
        } else {
          choosing_stride_or_MLFQ = 1;
80103dbd:	b8 01 00 00 00       	mov    $0x1,%eax
        }

        proc = 0;
80103dc2:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103dc9:	00 00 00 00 
80103dcd:	8d 76 00             	lea    0x0(%esi),%esi
    while(ptable.queue_level_at_most < NMLFQ) {

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dd0:	81 c3 94 00 00 00    	add    $0x94,%ebx
80103dd6:	81 fb d4 62 11 80    	cmp    $0x801162d4,%ebx
80103ddc:	0f 83 be 00 00 00    	jae    80103ea0 <scheduler+0x1c0>
        // Design Document 1-2-2-5. Choosing the stride queue or MLFQ
        if(ptable.sum_cpu_share != 0 && choosing_stride_or_MLFQ) {
80103de2:	8b 0d f0 63 11 80    	mov    0x801163f0,%ecx
80103de8:	85 c9                	test   %ecx,%ecx
80103dea:	0f 85 38 ff ff ff    	jne    80103d28 <scheduler+0x48>
          // choosing_stride_or_MLFQ == 0
          // do nothing. keep finding a process in MLFQ
        }

        // Design document 1-1-2-5. Finding a process to be run
        if(stride_is_selected) {
80103df0:	85 ff                	test   %edi,%edi
80103df2:	0f 85 69 ff ff ff    	jne    80103d61 <scheduler+0x81>
80103df8:	31 ff                	xor    %edi,%edi
            ptable.queue_level_at_most = p->level_of_MLFQ < ptable.queue_level_at_most ? p->level_of_MLFQ : ptable.queue_level_at_most;
            ptable.min_of_run_proc_level = ptable.queue_level_at_most;

          } else {
            // A process to be run has not been found. Keep finding it in MLFQ.
            choosing_stride_or_MLFQ = 0;
80103dfa:	31 c0                	xor    %eax,%eax
          // The MLFQ is selected. Find a process in MLFQ.
          // A process can be run whose priority is equal or higher than ptable.queue_level_at_most.
          
          // Skip a process whose value of cpu_share is not zero, 
          //  which means that the process is in the stride_queue, not in the MLFQ.
          if(p->state == RUNNABLE 
80103dfc:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e00:	75 ce                	jne    80103dd0 <scheduler+0xf0>
              && p->cpu_share == 0 
80103e02:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
80103e08:	85 d2                	test   %edx,%edx
80103e0a:	75 c4                	jne    80103dd0 <scheduler+0xf0>
              && p->level_of_MLFQ <= ptable.queue_level_at_most) {
80103e0c:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80103e12:	8b 0d e4 62 11 80    	mov    0x801162e4,%ecx
80103e18:	39 ca                	cmp    %ecx,%edx
80103e1a:	7f b4                	jg     80103dd0 <scheduler+0xf0>
            // A process to be run has been found!
            // Minimum level of run processes should be ptable.queue_level_at_most for next scheduling.
            ptable.queue_level_at_most = p->level_of_MLFQ < ptable.queue_level_at_most ? p->level_of_MLFQ : ptable.queue_level_at_most;
80103e1c:	39 d1                	cmp    %edx,%ecx
80103e1e:	0f 4e d1             	cmovle %ecx,%edx
        cprintf("stride:%d, ", p->stride);
        cprintf("stride_count:%d\n", p->stride_count);
        /** cprintf("ContChange. stride_is_selected:%d, proc_name:%s, proc_id:%d, MLFQ_tick:%d, level:%d, stride_tick:%d, cpu_share:%d, sum_cpu_share: %d, stride:%d, stride_count:%d\n", stride_is_selected, p->name, p->pid, ptable.MLFQ_tick_used,p->level_of_MLFQ , ptable.stride_tick_used, p->cpu_share, ptable.sum_cpu_share, p->stride, p->stride_count); */
#endif
        proc = p;
        switchuvm(p);
80103e21:	89 1c 24             	mov    %ebx,(%esp)
          if(p->state == RUNNABLE 
              && p->cpu_share == 0 
              && p->level_of_MLFQ <= ptable.queue_level_at_most) {
            // A process to be run has been found!
            // Minimum level of run processes should be ptable.queue_level_at_most for next scheduling.
            ptable.queue_level_at_most = p->level_of_MLFQ < ptable.queue_level_at_most ? p->level_of_MLFQ : ptable.queue_level_at_most;
80103e24:	89 15 e4 62 11 80    	mov    %edx,0x801162e4
            ptable.min_of_run_proc_level = ptable.queue_level_at_most;
80103e2a:	89 15 e8 62 11 80    	mov    %edx,0x801162e8
        cprintf("sum_cpu_share: %d, ", ptable.sum_cpu_share);
        cprintf("stride:%d, ", p->stride);
        cprintf("stride_count:%d\n", p->stride_count);
        /** cprintf("ContChange. stride_is_selected:%d, proc_name:%s, proc_id:%d, MLFQ_tick:%d, level:%d, stride_tick:%d, cpu_share:%d, sum_cpu_share: %d, stride:%d, stride_count:%d\n", stride_is_selected, p->name, p->pid, ptable.MLFQ_tick_used,p->level_of_MLFQ , ptable.stride_tick_used, p->cpu_share, ptable.sum_cpu_share, p->stride, p->stride_count); */
#endif
        proc = p;
80103e30:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
        switchuvm(p);
80103e37:	e8 34 31 00 00       	call   80106f70 <switchuvm>

        // Back up MLFQ tick for check whether a process in MLFQ uses at least one tick.
        // I did not use 'if', so in this code is executed in stride algorithm, but it does not make problem.
        before_MLFQ_used_tick = ptable.MLFQ_tick_used;

        swtch(&cpu->scheduler, p->context); // This function returns in sched().
80103e3c:	8b 43 1c             	mov    0x1c(%ebx),%eax
        cprintf("stride_count:%d\n", p->stride_count);
        /** cprintf("ContChange. stride_is_selected:%d, proc_name:%s, proc_id:%d, MLFQ_tick:%d, level:%d, stride_tick:%d, cpu_share:%d, sum_cpu_share: %d, stride:%d, stride_count:%d\n", stride_is_selected, p->name, p->pid, ptable.MLFQ_tick_used,p->level_of_MLFQ , ptable.stride_tick_used, p->cpu_share, ptable.sum_cpu_share, p->stride, p->stride_count); */
#endif
        proc = p;
        switchuvm(p);
        p->state = RUNNING;
80103e3f:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)

        // Back up MLFQ tick for check whether a process in MLFQ uses at least one tick.
        // I did not use 'if', so in this code is executed in stride algorithm, but it does not make problem.
        before_MLFQ_used_tick = ptable.MLFQ_tick_used;
80103e46:	8b 3d e0 62 11 80    	mov    0x801162e0,%edi

        swtch(&cpu->scheduler, p->context); // This function returns in sched().
80103e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e50:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103e56:	83 c0 04             	add    $0x4,%eax
80103e59:	89 04 24             	mov    %eax,(%esp)
80103e5c:	e8 4a 0e 00 00       	call   80104cab <swtch>
        switchkvm();
80103e61:	e8 ea 30 00 00       	call   80106f50 <switchkvm>
        // 1) Current queue is MLFQ                     (stride_is_selected == 0)
        // 2) Current process is runnable               (p->state == RUNNING)
        // 3) Any processes are in the stride queue     (ptable.sum_cpu_share != 0)
        // 4) The process running now is in MLFQ        (p->cpu_share == 0)
        if(stride_is_selected == 0
            && ptable.sum_cpu_share != 0 
80103e66:	8b 0d f0 63 11 80    	mov    0x801163f0,%ecx

          // 2) To re-run current process, decrease pointer's value. 
          //    It will be increased in 'for' statement, so current process will be re-selected.
          p--;
        } else {
          choosing_stride_or_MLFQ = 1;
80103e6c:	b8 01 00 00 00       	mov    $0x1,%eax
        // 1) Current queue is MLFQ                     (stride_is_selected == 0)
        // 2) Current process is runnable               (p->state == RUNNING)
        // 3) Any processes are in the stride queue     (ptable.sum_cpu_share != 0)
        // 4) The process running now is in MLFQ        (p->cpu_share == 0)
        if(stride_is_selected == 0
            && ptable.sum_cpu_share != 0 
80103e71:	85 c9                	test   %ecx,%ecx
80103e73:	74 06                	je     80103e7b <scheduler+0x19b>
            && p->state == RUNNABLE 
80103e75:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e79:	74 65                	je     80103ee0 <scheduler+0x200>
    while(ptable.queue_level_at_most < NMLFQ) {

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e7b:	81 c3 94 00 00 00    	add    $0x94,%ebx
          p--;
        } else {
          choosing_stride_or_MLFQ = 1;
        }

        proc = 0;
80103e81:	31 ff                	xor    %edi,%edi
    while(ptable.queue_level_at_most < NMLFQ) {

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e83:	81 fb d4 62 11 80    	cmp    $0x801162d4,%ebx
          p--;
        } else {
          choosing_stride_or_MLFQ = 1;
        }

        proc = 0;
80103e89:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103e90:	00 00 00 00 
    while(ptable.queue_level_at_most < NMLFQ) {

      //initialize it before traversing the proc array
      ptable.min_of_run_proc_level = NMLFQ - 1;

      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e94:	0f 82 48 ff ff ff    	jb     80103de2 <scheduler+0x102>
80103e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          p = p_mlfq;
          p--;
        }
      }

      if(ptable.min_of_run_proc_level == NMLFQ - 1)  {
80103ea0:	83 3d e8 62 11 80 02 	cmpl   $0x2,0x801162e8
        // 1) no process run. Increase queue level.
        // 2) processes are only in queue of last level. Break the while loop
        ptable.queue_level_at_most++;
80103ea7:	8b 15 e4 62 11 80    	mov    0x801162e4,%edx
          p = p_mlfq;
          p--;
        }
      }

      if(ptable.min_of_run_proc_level == NMLFQ - 1)  {
80103ead:	74 51                	je     80103f00 <scheduler+0x220>
    // choose the stride queue or MLFQ
    choosing_stride_or_MLFQ = 1;

    // When while loop is end, there are only processes of last level of queue.
    ptable.queue_level_at_most = NMLFQ - 1; // last level
    while(ptable.queue_level_at_most < NMLFQ) {
80103eaf:	83 fa 02             	cmp    $0x2,%edx
80103eb2:	0f 8e 58 fe ff ff    	jle    80103d10 <scheduler+0x30>
        ptable.queue_level_at_most++;
      } else {
        // run a queue of same level again.
      }
    }
    release(&ptable.lock);
80103eb8:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80103ebf:	e8 5c 0b 00 00       	call   80104a20 <release>
  }
80103ec4:	e9 27 fe ff ff       	jmp    80103cf0 <scheduler+0x10>
80103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          if (stride_idx_to_be_run <= ptable.stride_queue_size) {
            // Process is found. Go to run found process
            p = ptable.stride_queue[stride_idx_to_be_run];
          } else {
            // No process to be run in stride_queue. go to MLFQ
            stride_is_selected = 0;
80103ed0:	31 ff                	xor    %edi,%edi
            choosing_stride_or_MLFQ = 0;
80103ed2:	31 c0                	xor    %eax,%eax
80103ed4:	e9 f7 fe ff ff       	jmp    80103dd0 <scheduler+0xf0>
80103ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        // 3) Any processes are in the stride queue     (ptable.sum_cpu_share != 0)
        // 4) The process running now is in MLFQ        (p->cpu_share == 0)
        if(stride_is_selected == 0
            && ptable.sum_cpu_share != 0 
            && p->state == RUNNABLE 
            && p->cpu_share == 0 
80103ee0:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
80103ee6:	85 d2                	test   %edx,%edx
80103ee8:	75 91                	jne    80103e7b <scheduler+0x19b>
            && ptable.MLFQ_tick_used == before_MLFQ_used_tick)
80103eea:	39 3d e0 62 11 80    	cmp    %edi,0x801162e0
80103ef0:	75 89                	jne    80103e7b <scheduler+0x19b>
          // 1) Do not consider choosing between the MLFQ of the stride.
          choosing_stride_or_MLFQ = 0;

          // 2) To re-run current process, decrease pointer's value. 
          //    It will be increased in 'for' statement, so current process will be re-selected.
          p--;
80103ef2:	81 eb 94 00 00 00    	sub    $0x94,%ebx
          // When these conditions are satisfied, 
          // it means that current process are in MLFQ and it does not use at least one tick.
          
          // To make the process use one tick, re-run current process:
          // 1) Do not consider choosing between the MLFQ of the stride.
          choosing_stride_or_MLFQ = 0;
80103ef8:	30 c0                	xor    %al,%al

          // 2) To re-run current process, decrease pointer's value. 
          //    It will be increased in 'for' statement, so current process will be re-selected.
          p--;
80103efa:	e9 7c ff ff ff       	jmp    80103e7b <scheduler+0x19b>
80103eff:	90                   	nop
      }

      if(ptable.min_of_run_proc_level == NMLFQ - 1)  {
        // 1) no process run. Increase queue level.
        // 2) processes are only in queue of last level. Break the while loop
        ptable.queue_level_at_most++;
80103f00:	83 c2 01             	add    $0x1,%edx
80103f03:	89 15 e4 62 11 80    	mov    %edx,0x801162e4
80103f09:	eb a4                	jmp    80103eaf <scheduler+0x1cf>
80103f0b:	90                   	nop
80103f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f10 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80103f17:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80103f1e:	e8 5d 0a 00 00       	call   80104980 <holding>
80103f23:	85 c0                	test   %eax,%eax
80103f25:	74 61                	je     80103f88 <sched+0x78>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103f27:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103f2d:	83 b8 ac 00 00 00 01 	cmpl   $0x1,0xac(%eax)
80103f34:	75 76                	jne    80103fac <sched+0x9c>
    panic("sched locks");
  if(proc->state == RUNNING)
80103f36:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103f3d:	83 7a 0c 04          	cmpl   $0x4,0xc(%edx)
80103f41:	74 5d                	je     80103fa0 <sched+0x90>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f43:	9c                   	pushf  
80103f44:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103f45:	80 e5 02             	and    $0x2,%ch
80103f48:	75 4a                	jne    80103f94 <sched+0x84>
    panic("sched interruptible");

  intena = cpu->intena;
80103f4a:	8b 98 b0 00 00 00    	mov    0xb0(%eax),%ebx
  swtch(&proc->context, cpu->scheduler); // sched는 한 타임에 return되는게 아니다. 자고 있다가, 깨워지면 다시 시작한다.
80103f50:	83 c2 1c             	add    $0x1c,%edx
80103f53:	8b 40 04             	mov    0x4(%eax),%eax
80103f56:	89 14 24             	mov    %edx,(%esp)
80103f59:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f5d:	e8 49 0d 00 00       	call   80104cab <swtch>
  // swtch가 return되는 곳은 scheduler안에서다. scheduler 진행
  
  // 이거맞나? TODO 
  if(proc) {
80103f62:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f68:	85 c0                	test   %eax,%eax
80103f6a:	74 0a                	je     80103f76 <sched+0x66>
    proc->time_quantum_used = 0;
80103f6c:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103f73:	00 00 00 
  }

  cpu->intena = intena;
80103f76:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103f7c:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103f82:	83 c4 14             	add    $0x14,%esp
80103f85:	5b                   	pop    %ebx
80103f86:	5d                   	pop    %ebp
80103f87:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103f88:	c7 04 24 58 7b 10 80 	movl   $0x80107b58,(%esp)
80103f8f:	e8 cc c3 ff ff       	call   80100360 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103f94:	c7 04 24 84 7b 10 80 	movl   $0x80107b84,(%esp)
80103f9b:	e8 c0 c3 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103fa0:	c7 04 24 76 7b 10 80 	movl   $0x80107b76,(%esp)
80103fa7:	e8 b4 c3 ff ff       	call   80100360 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103fac:	c7 04 24 6a 7b 10 80 	movl   $0x80107b6a,(%esp)
80103fb3:	e8 a8 c3 ff ff       	call   80100360 <panic>
80103fb8:	90                   	nop
80103fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fc0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	57                   	push   %edi
80103fc4:	56                   	push   %esi
80103fc5:	53                   	push   %ebx
  struct proc *p;
  int fd;
  int stride_idx;

  if(proc == initproc)
80103fc6:	31 db                	xor    %ebx,%ebx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103fc8:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  int fd;
  int stride_idx;

  if(proc == initproc)
80103fcb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103fd2:	3b 15 bc b5 10 80    	cmp    0x8010b5bc,%edx
80103fd8:	0f 84 0f 02 00 00    	je     801041ed <exit+0x22d>
80103fde:	66 90                	xchg   %ax,%ax
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103fe0:	8d 73 08             	lea    0x8(%ebx),%esi
80103fe3:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103fe7:	85 c0                	test   %eax,%eax
80103fe9:	74 17                	je     80104002 <exit+0x42>
      fileclose(proc->ofile[fd]);
80103feb:	89 04 24             	mov    %eax,(%esp)
80103fee:	e8 2d ce ff ff       	call   80100e20 <fileclose>
      proc->ofile[fd] = 0;
80103ff3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103ffa:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80104001:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104002:	83 c3 01             	add    $0x1,%ebx
80104005:	83 fb 10             	cmp    $0x10,%ebx
80104008:	75 d6                	jne    80103fe0 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
8010400a:	e8 71 eb ff ff       	call   80102b80 <begin_op>
  iput(proc->cwd);
8010400f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104015:	8b 40 68             	mov    0x68(%eax),%eax
80104018:	89 04 24             	mov    %eax,(%esp)
8010401b:	e8 a0 d7 ff ff       	call   801017c0 <iput>
  end_op();
80104020:	e8 cb eb ff ff       	call   80102bf0 <end_op>
  proc->cwd = 0;
80104025:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010402b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104032:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104039:	e8 b2 08 00 00       	call   801048f0 <acquire>

  // delete a process in stride queue
  if (proc->cpu_share != 0) {
8010403e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104045:	8b 82 88 00 00 00    	mov    0x88(%edx),%eax
8010404b:	85 c0                	test   %eax,%eax
8010404d:	0f 84 db 00 00 00    	je     8010412e <exit+0x16e>
#ifdef MJ_DEBUGGING
    cprintf("stirde_queue process exit()\n");
#endif

    // subtract cpu_share from sum_cpu_share
    ptable.sum_cpu_share -= proc->cpu_share;
80104053:	29 05 f0 63 11 80    	sub    %eax,0x801163f0

    // find where it is in the stride queue
    for (stride_idx = 1; stride_idx < NSTRIDE_QUEUE; ++stride_idx) {
80104059:	b8 01 00 00 00       	mov    $0x1,%eax
8010405e:	eb 0c                	jmp    8010406c <exit+0xac>
80104060:	83 c0 01             	add    $0x1,%eax
80104063:	83 f8 41             	cmp    $0x41,%eax
80104066:	0f 84 64 01 00 00    	je     801041d0 <exit+0x210>
      if (ptable.stride_queue[stride_idx] == proc) {
8010406c:	3b 14 85 ec 62 11 80 	cmp    -0x7fee9d14(,%eax,4),%edx
80104073:	75 eb                	jne    80104060 <exit+0xa0>
    if (stride_idx == NSTRIDE_QUEUE) {
      panic("exit(): a process is not in the stride scheduler");
    }

    // delete a process from the heap
    ptable.stride_queue[stride_idx] = ptable.stride_queue[ptable.stride_queue_size];
80104075:	8b 1d f4 63 11 80    	mov    0x801163f4,%ebx
8010407b:	8d b0 50 09 00 00    	lea    0x950(%eax),%esi
    ptable.stride_queue[ptable.stride_queue_size--] = 0;

    // do heapify
    if (stride_idx == 1) {
80104081:	83 f8 01             	cmp    $0x1,%eax
    if (stride_idx == NSTRIDE_QUEUE) {
      panic("exit(): a process is not in the stride scheduler");
    }

    // delete a process from the heap
    ptable.stride_queue[stride_idx] = ptable.stride_queue[ptable.stride_queue_size];
80104084:	8d 8b 50 09 00 00    	lea    0x950(%ebx),%ecx
8010408a:	8b 3c 8d ac 3d 11 80 	mov    -0x7feec254(,%ecx,4),%edi
80104091:	89 3c b5 ac 3d 11 80 	mov    %edi,-0x7feec254(,%esi,4)
    ptable.stride_queue[ptable.stride_queue_size--] = 0;
80104098:	8d 7b ff             	lea    -0x1(%ebx),%edi
8010409b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010409e:	89 3d f4 63 11 80    	mov    %edi,0x801163f4
801040a4:	c7 04 8d ac 3d 11 80 	movl   $0x0,-0x7feec254(,%ecx,4)
801040ab:	00 00 00 00 

    // do heapify
    if (stride_idx == 1) {
801040af:	0f 84 44 01 00 00    	je     801041f9 <exit+0x239>
      //heapify_down
      heapify_up = 0;
    } else {
      //select heapify_up or down
      heapify_up = ptable.stride_queue[stride_idx]->stride_count 
801040b5:	8b 3c b5 ac 3d 11 80 	mov    -0x7feec254(,%esi,4),%edi
801040bc:	8b 8f 90 00 00 00    	mov    0x90(%edi),%ecx
801040c2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
                   < ptable.stride_queue[stride_idx / 2]->stride_count 
801040c5:	89 c1                	mov    %eax,%ecx
801040c7:	d1 f9                	sar    %ecx
801040c9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
801040cc:	8b 0c 8d ec 62 11 80 	mov    -0x7fee9d14(,%ecx,4),%ecx
                   ? 1 : 0;
    }

    if (ptable.stride_queue_size == 0 || ptable.stride_queue_size == 1) {
801040d3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
      //heapify_down
      heapify_up = 0;
    } else {
      //select heapify_up or down
      heapify_up = ptable.stride_queue[stride_idx]->stride_count 
                   < ptable.stride_queue[stride_idx / 2]->stride_count 
801040d7:	8b 99 90 00 00 00    	mov    0x90(%ecx),%ebx
                   ? 1 : 0;
    }

    if (ptable.stride_queue_size == 0 || ptable.stride_queue_size == 1) {
801040dd:	76 4f                	jbe    8010412e <exit+0x16e>
      //do nothing
    } else {
      // increase key
      if (heapify_up) {
801040df:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
801040e2:	0f 8c f4 00 00 00    	jl     801041dc <exit+0x21c>
}
void stride_queue_heapify_up(int stride_idx) {
  struct proc* target_proc = ptable.stride_queue[stride_idx];
  while (stride_idx != 1) {
    // if child is smaller than parent
    if (ptable.stride_queue[stride_idx] < ptable.stride_queue[stride_idx / 2]) {
801040e8:	39 cf                	cmp    %ecx,%edi
801040ea:	73 3b                	jae    80104127 <exit+0x167>
801040ec:	89 c6                	mov    %eax,%esi
801040ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
801040f1:	eb 23                	jmp    80104116 <exit+0x156>
801040f3:	90                   	nop
801040f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040f8:	89 c3                	mov    %eax,%ebx
801040fa:	d1 fb                	sar    %ebx
801040fc:	8b 0c 9d ec 62 11 80 	mov    -0x7fee9d14(,%ebx,4),%ecx
80104103:	8d b0 50 09 00 00    	lea    0x950(%eax),%esi
80104109:	39 0c b5 ac 3d 11 80 	cmp    %ecx,-0x7feec254(,%esi,4)
80104110:	73 15                	jae    80104127 <exit+0x167>
80104112:	89 c6                	mov    %eax,%esi
80104114:	89 d8                	mov    %ebx,%eax
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
void stride_queue_heapify_up(int stride_idx) {
  struct proc* target_proc = ptable.stride_queue[stride_idx];
  while (stride_idx != 1) {
80104116:	83 f8 01             	cmp    $0x1,%eax
    // if child is smaller than parent
    if (ptable.stride_queue[stride_idx] < ptable.stride_queue[stride_idx / 2]) {
      ptable.stride_queue[stride_idx] = ptable.stride_queue[stride_idx / 2];
80104119:	89 0c b5 ec 62 11 80 	mov    %ecx,-0x7fee9d14(,%esi,4)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
void stride_queue_heapify_up(int stride_idx) {
  struct proc* target_proc = ptable.stride_queue[stride_idx];
  while (stride_idx != 1) {
80104120:	75 d6                	jne    801040f8 <exit+0x138>
80104122:	be 51 09 00 00       	mov    $0x951,%esi
    } else {
      break;
    }
  }
  // locate a process to right position
  ptable.stride_queue[stride_idx] = target_proc;
80104127:	89 3c b5 ac 3d 11 80 	mov    %edi,-0x7feec254(,%esi,4)
      }
    }
  }

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
8010412e:	8b 4a 14             	mov    0x14(%edx),%ecx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104131:	b8 d4 3d 11 80       	mov    $0x80113dd4,%eax
80104136:	eb 0c                	jmp    80104144 <exit+0x184>
80104138:	05 94 00 00 00       	add    $0x94,%eax
8010413d:	3d d4 62 11 80       	cmp    $0x801162d4,%eax
80104142:	74 1e                	je     80104162 <exit+0x1a2>
    if(p->state == SLEEPING && p->chan == chan)
80104144:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104148:	75 ee                	jne    80104138 <exit+0x178>
8010414a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010414d:	75 e9                	jne    80104138 <exit+0x178>
      p->state = RUNNABLE;
8010414f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104156:	05 94 00 00 00       	add    $0x94,%eax
8010415b:	3d d4 62 11 80       	cmp    $0x801162d4,%eax
80104160:	75 e2                	jne    80104144 <exit+0x184>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80104162:	8b 1d bc b5 10 80    	mov    0x8010b5bc,%ebx
80104168:	b9 d4 3d 11 80       	mov    $0x80113dd4,%ecx
8010416d:	eb 0f                	jmp    8010417e <exit+0x1be>
8010416f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104170:	81 c1 94 00 00 00    	add    $0x94,%ecx
80104176:	81 f9 d4 62 11 80    	cmp    $0x801162d4,%ecx
8010417c:	74 3a                	je     801041b8 <exit+0x1f8>
    if(p->parent == proc){
8010417e:	3b 51 14             	cmp    0x14(%ecx),%edx
80104181:	75 ed                	jne    80104170 <exit+0x1b0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80104183:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80104187:	89 59 14             	mov    %ebx,0x14(%ecx)
      if(p->state == ZOMBIE)
8010418a:	75 e4                	jne    80104170 <exit+0x1b0>
8010418c:	b8 d4 3d 11 80       	mov    $0x80113dd4,%eax
80104191:	eb 11                	jmp    801041a4 <exit+0x1e4>
80104193:	90                   	nop
80104194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104198:	05 94 00 00 00       	add    $0x94,%eax
8010419d:	3d d4 62 11 80       	cmp    $0x801162d4,%eax
801041a2:	74 cc                	je     80104170 <exit+0x1b0>
    if(p->state == SLEEPING && p->chan == chan)
801041a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041a8:	75 ee                	jne    80104198 <exit+0x1d8>
801041aa:	3b 58 20             	cmp    0x20(%eax),%ebx
801041ad:	75 e9                	jne    80104198 <exit+0x1d8>
      p->state = RUNNABLE;
801041af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041b6:	eb e0                	jmp    80104198 <exit+0x1d8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801041b8:	c7 42 0c 05 00 00 00 	movl   $0x5,0xc(%edx)
  sched();
801041bf:	e8 4c fd ff ff       	call   80103f10 <sched>
  panic("zombie exit");
801041c4:	c7 04 24 a5 7b 10 80 	movl   $0x80107ba5,(%esp)
801041cb:	e8 90 c1 ff ff       	call   80100360 <panic>
        break;
      }
    }

    if (stride_idx == NSTRIDE_QUEUE) {
      panic("exit(): a process is not in the stride scheduler");
801041d0:	c7 04 24 10 7c 10 80 	movl   $0x80107c10,(%esp)
801041d7:	e8 84 c1 ff ff       	call   80100360 <panic>
    if (ptable.stride_queue_size == 0 || ptable.stride_queue_size == 1) {
      //do nothing
    } else {
      // increase key
      if (heapify_up) {
        stride_queue_heapify_down(stride_idx);
801041dc:	e8 4f f4 ff ff       	call   80103630 <stride_queue_heapify_down>
801041e1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801041e8:	e9 41 ff ff ff       	jmp    8010412e <exit+0x16e>
  struct proc *p;
  int fd;
  int stride_idx;

  if(proc == initproc)
    panic("init exiting");
801041ed:	c7 04 24 98 7b 10 80 	movl   $0x80107b98,(%esp)
801041f4:	e8 67 c1 ff ff       	call   80100360 <panic>
      heapify_up = ptable.stride_queue[stride_idx]->stride_count 
                   < ptable.stride_queue[stride_idx / 2]->stride_count 
                   ? 1 : 0;
    }

    if (ptable.stride_queue_size == 0 || ptable.stride_queue_size == 1) {
801041f9:	83 ff 01             	cmp    $0x1,%edi
801041fc:	0f 86 2c ff ff ff    	jbe    8010412e <exit+0x16e>
    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
void stride_queue_heapify_up(int stride_idx) {
  struct proc* target_proc = ptable.stride_queue[stride_idx];
80104202:	8b 3d f0 62 11 80    	mov    0x801162f0,%edi
80104208:	e9 1a ff ff ff       	jmp    80104127 <exit+0x167>
8010420d:	8d 76 00             	lea    0x0(%esi),%esi

80104210 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104216:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010421d:	e8 ce 06 00 00       	call   801048f0 <acquire>
  proc->state = RUNNABLE;
80104222:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104228:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched(); 
8010422f:	e8 dc fc ff ff       	call   80103f10 <sched>
  release(&ptable.lock);
80104234:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010423b:	e8 e0 07 00 00       	call   80104a20 <release>
}
80104240:	c9                   	leave  
80104241:	c3                   	ret    
80104242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <sys_yield>:
// Wrapper
int
sys_yield(void) {
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	83 ec 08             	sub    $0x8,%esp
  yield();
80104256:	e8 b5 ff ff ff       	call   80104210 <yield>
  return 0;
}
8010425b:	31 c0                	xor    %eax,%eax
8010425d:	c9                   	leave  
8010425e:	c3                   	ret    
8010425f:	90                   	nop

80104260 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	56                   	push   %esi
80104264:	53                   	push   %ebx
80104265:	83 ec 10             	sub    $0x10,%esp
  if(proc == 0)
80104268:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
8010426e:	8b 75 08             	mov    0x8(%ebp),%esi
80104271:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80104274:	85 c0                	test   %eax,%eax
80104276:	0f 84 8b 00 00 00    	je     80104307 <sleep+0xa7>
    panic("sleep");

  if(lk == 0)
8010427c:	85 db                	test   %ebx,%ebx
8010427e:	74 7b                	je     801042fb <sleep+0x9b>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104280:	81 fb a0 3d 11 80    	cmp    $0x80113da0,%ebx
80104286:	74 50                	je     801042d8 <sleep+0x78>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104288:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010428f:	e8 5c 06 00 00       	call   801048f0 <acquire>
    release(lk);
80104294:	89 1c 24             	mov    %ebx,(%esp)
80104297:	e8 84 07 00 00       	call   80104a20 <release>
  }

  // Go to sleep.
  proc->chan = chan;
8010429c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042a2:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
801042a5:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801042ac:	e8 5f fc ff ff       	call   80103f10 <sched>

  // Tidy up.
  proc->chan = 0;
801042b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042b7:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
801042be:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801042c5:	e8 56 07 00 00       	call   80104a20 <release>
    acquire(lk);
801042ca:	89 5d 08             	mov    %ebx,0x8(%ebp)
  }
}
801042cd:	83 c4 10             	add    $0x10,%esp
801042d0:	5b                   	pop    %ebx
801042d1:	5e                   	pop    %esi
801042d2:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
801042d3:	e9 18 06 00 00       	jmp    801048f0 <acquire>
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
801042d8:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
801042db:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
801042e2:	e8 29 fc ff ff       	call   80103f10 <sched>

  // Tidy up.
  proc->chan = 0;
801042e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042ed:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
801042f4:	83 c4 10             	add    $0x10,%esp
801042f7:	5b                   	pop    %ebx
801042f8:	5e                   	pop    %esi
801042f9:	5d                   	pop    %ebp
801042fa:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
801042fb:	c7 04 24 b7 7b 10 80 	movl   $0x80107bb7,(%esp)
80104302:	e8 59 c0 ff ff       	call   80100360 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80104307:	c7 04 24 b1 7b 10 80 	movl   $0x80107bb1,(%esp)
8010430e:	e8 4d c0 ff ff       	call   80100360 <panic>
80104313:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104320 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	56                   	push   %esi
80104324:	53                   	push   %ebx
80104325:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104328:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010432f:	e8 bc 05 00 00       	call   801048f0 <acquire>
80104334:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010433a:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010433c:	bb d4 3d 11 80       	mov    $0x80113dd4,%ebx
80104341:	eb 13                	jmp    80104356 <wait+0x36>
80104343:	90                   	nop
80104344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104348:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010434e:	81 fb d4 62 11 80    	cmp    $0x801162d4,%ebx
80104354:	74 22                	je     80104378 <wait+0x58>
      if(p->parent != proc)
80104356:	39 43 14             	cmp    %eax,0x14(%ebx)
80104359:	75 ed                	jne    80104348 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010435b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010435f:	74 3c                	je     8010439d <wait+0x7d>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104361:	81 c3 94 00 00 00    	add    $0x94,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80104367:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010436c:	81 fb d4 62 11 80    	cmp    $0x801162d4,%ebx
80104372:	75 e2                	jne    80104356 <wait+0x36>
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104378:	85 d2                	test   %edx,%edx
8010437a:	0f 84 ab 00 00 00    	je     8010442b <wait+0x10b>
80104380:	8b 50 24             	mov    0x24(%eax),%edx
80104383:	85 d2                	test   %edx,%edx
80104385:	0f 85 a0 00 00 00    	jne    8010442b <wait+0x10b>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
8010438b:	c7 44 24 04 a0 3d 11 	movl   $0x80113da0,0x4(%esp)
80104392:	80 
80104393:	89 04 24             	mov    %eax,(%esp)
80104396:	e8 c5 fe ff ff       	call   80104260 <sleep>
  }
8010439b:	eb 97                	jmp    80104334 <wait+0x14>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
8010439d:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
801043a0:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801043a3:	89 04 24             	mov    %eax,(%esp)
801043a6:	e8 35 df ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
801043ab:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
801043ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801043b5:	89 04 24             	mov    %eax,(%esp)
801043b8:	e8 d3 2e 00 00       	call   80107290 <freevm>
        p->cpu_share = 0;
        p->stride = 0;
        p->stride_count= 0;

        p->state = UNUSED;
        release(&ptable.lock);
801043bd:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
801043c4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801043cb:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801043d2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801043d6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)

        // Design document 1-1-2-2 and 1-2-2-2.
        p->tick_used = 0;
801043dd:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        p->time_quantum_used= 0;
801043e4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801043eb:	00 00 00 
        p->level_of_MLFQ = 0;
801043ee:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801043f5:	00 00 00 
        p->cpu_share = 0;
801043f8:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
801043ff:	00 00 00 
        p->stride = 0;
80104402:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80104409:	00 00 00 
        p->stride_count= 0;
8010440c:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80104413:	00 00 00 

        p->state = UNUSED;
80104416:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010441d:	e8 fe 05 00 00       	call   80104a20 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104422:	83 c4 10             	add    $0x10,%esp
        p->stride = 0;
        p->stride_count= 0;

        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80104425:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104427:	5b                   	pop    %ebx
80104428:	5e                   	pop    %esi
80104429:	5d                   	pop    %ebp
8010442a:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
8010442b:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104432:	e8 e9 05 00 00       	call   80104a20 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104437:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
8010443a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010443f:	5b                   	pop    %ebx
80104440:	5e                   	pop    %esi
80104441:	5d                   	pop    %ebp
80104442:	c3                   	ret    
80104443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104450 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 14             	sub    $0x14,%esp
80104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010445a:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104461:	e8 8a 04 00 00       	call   801048f0 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104466:	b8 d4 3d 11 80       	mov    $0x80113dd4,%eax
8010446b:	eb 0f                	jmp    8010447c <wakeup+0x2c>
8010446d:	8d 76 00             	lea    0x0(%esi),%esi
80104470:	05 94 00 00 00       	add    $0x94,%eax
80104475:	3d d4 62 11 80       	cmp    $0x801162d4,%eax
8010447a:	74 24                	je     801044a0 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
8010447c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104480:	75 ee                	jne    80104470 <wakeup+0x20>
80104482:	3b 58 20             	cmp    0x20(%eax),%ebx
80104485:	75 e9                	jne    80104470 <wakeup+0x20>
      p->state = RUNNABLE;
80104487:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010448e:	05 94 00 00 00       	add    $0x94,%eax
80104493:	3d d4 62 11 80       	cmp    $0x801162d4,%eax
80104498:	75 e2                	jne    8010447c <wakeup+0x2c>
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801044a0:	c7 45 08 a0 3d 11 80 	movl   $0x80113da0,0x8(%ebp)
}
801044a7:	83 c4 14             	add    $0x14,%esp
801044aa:	5b                   	pop    %ebx
801044ab:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801044ac:	e9 6f 05 00 00       	jmp    80104a20 <release>
801044b1:	eb 0d                	jmp    801044c0 <kill>
801044b3:	90                   	nop
801044b4:	90                   	nop
801044b5:	90                   	nop
801044b6:	90                   	nop
801044b7:	90                   	nop
801044b8:	90                   	nop
801044b9:	90                   	nop
801044ba:	90                   	nop
801044bb:	90                   	nop
801044bc:	90                   	nop
801044bd:	90                   	nop
801044be:	90                   	nop
801044bf:	90                   	nop

801044c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 14             	sub    $0x14,%esp
801044c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044ca:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801044d1:	e8 1a 04 00 00       	call   801048f0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044d6:	b8 d4 3d 11 80       	mov    $0x80113dd4,%eax
801044db:	eb 0f                	jmp    801044ec <kill+0x2c>
801044dd:	8d 76 00             	lea    0x0(%esi),%esi
801044e0:	05 94 00 00 00       	add    $0x94,%eax
801044e5:	3d d4 62 11 80       	cmp    $0x801162d4,%eax
801044ea:	74 3c                	je     80104528 <kill+0x68>
    if(p->pid == pid){
801044ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801044ef:	75 ef                	jne    801044e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044f1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801044f5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044fc:	74 1a                	je     80104518 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801044fe:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104505:	e8 16 05 00 00       	call   80104a20 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010450a:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
8010450d:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010450f:	5b                   	pop    %ebx
80104510:	5d                   	pop    %ebp
80104511:	c3                   	ret    
80104512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104518:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010451f:	eb dd                	jmp    801044fe <kill+0x3e>
80104521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104528:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010452f:	e8 ec 04 00 00       	call   80104a20 <release>
  return -1;
}
80104534:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80104537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010453c:	5b                   	pop    %ebx
8010453d:	5d                   	pop    %ebp
8010453e:	c3                   	ret    
8010453f:	90                   	nop

80104540 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	56                   	push   %esi
80104545:	53                   	push   %ebx
80104546:	bb 40 3e 11 80       	mov    $0x80113e40,%ebx
8010454b:	83 ec 4c             	sub    $0x4c,%esp
8010454e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104551:	eb 23                	jmp    80104576 <procdump+0x36>
80104553:	90                   	nop
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104558:	c7 04 24 06 7b 10 80 	movl   $0x80107b06,(%esp)
8010455f:	e8 ec c0 ff ff       	call   80100650 <cprintf>
80104564:	81 c3 94 00 00 00    	add    $0x94,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010456a:	81 fb 40 63 11 80    	cmp    $0x80116340,%ebx
80104570:	0f 84 8a 00 00 00    	je     80104600 <procdump+0xc0>
    if(p->state == UNUSED)
80104576:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104579:	85 c0                	test   %eax,%eax
8010457b:	74 e7                	je     80104564 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010457d:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104580:	ba c8 7b 10 80       	mov    $0x80107bc8,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104585:	77 11                	ja     80104598 <procdump+0x58>
80104587:	8b 14 85 44 7c 10 80 	mov    -0x7fef83bc(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010458e:	b8 c8 7b 10 80       	mov    $0x80107bc8,%eax
80104593:	85 d2                	test   %edx,%edx
80104595:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104598:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010459b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010459f:	89 54 24 08          	mov    %edx,0x8(%esp)
801045a3:	c7 04 24 cc 7b 10 80 	movl   $0x80107bcc,(%esp)
801045aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801045ae:	e8 9d c0 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
801045b3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801045b7:	75 9f                	jne    80104558 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801045b9:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801045c0:	8b 43 b0             	mov    -0x50(%ebx),%eax
801045c3:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045c6:	8b 40 0c             	mov    0xc(%eax),%eax
801045c9:	83 c0 08             	add    $0x8,%eax
801045cc:	89 04 24             	mov    %eax,(%esp)
801045cf:	e8 bc 02 00 00       	call   80104890 <getcallerpcs>
801045d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801045d8:	8b 17                	mov    (%edi),%edx
801045da:	85 d2                	test   %edx,%edx
801045dc:	0f 84 76 ff ff ff    	je     80104558 <procdump+0x18>
        cprintf(" %p", pc[i]);
801045e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801045e6:	83 c7 04             	add    $0x4,%edi
801045e9:	c7 04 24 29 76 10 80 	movl   $0x80107629,(%esp)
801045f0:	e8 5b c0 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801045f5:	39 f7                	cmp    %esi,%edi
801045f7:	75 df                	jne    801045d8 <procdump+0x98>
801045f9:	e9 5a ff ff ff       	jmp    80104558 <procdump+0x18>
801045fe:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104600:	83 c4 4c             	add    $0x4c,%esp
80104603:	5b                   	pop    %ebx
80104604:	5e                   	pop    %esi
80104605:	5f                   	pop    %edi
80104606:	5d                   	pop    %ebp
80104607:	c3                   	ret    
80104608:	90                   	nop
80104609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104610 <priority_boost>:

// Design Document 1-1-2-5. priority_boost()
void
priority_boost(void) {
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  
  cprintf("[do boosting!]\n");
80104616:	c7 04 24 d5 7b 10 80 	movl   $0x80107bd5,(%esp)
8010461d:	e8 2e c0 ff ff       	call   80100650 <cprintf>

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104622:	b8 d4 3d 11 80       	mov    $0x80113dd4,%eax
80104627:	90                   	nop
    p->level_of_MLFQ = 0;
80104628:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010462f:	00 00 00 
priority_boost(void) {
  struct proc *p;
  
  cprintf("[do boosting!]\n");

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104632:	05 94 00 00 00       	add    $0x94,%eax
    p->level_of_MLFQ = 0;
    p->tick_used = 0;
80104637:	c7 40 e8 00 00 00 00 	movl   $0x0,-0x18(%eax)
    //
    // Design Docuemtn 1-1-2-2. Reinitializing time_quantum_used
    p->time_quantum_used = 0;
8010463e:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
priority_boost(void) {
  struct proc *p;
  
  cprintf("[do boosting!]\n");

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104645:	3d d4 62 11 80       	cmp    $0x801162d4,%eax
    //
    // Design Docuemtn 1-1-2-2. Reinitializing time_quantum_used
    p->time_quantum_used = 0;


    ptable.MLFQ_tick_used = 0;
8010464a:	c7 05 e0 62 11 80 00 	movl   $0x0,0x801162e0
80104651:	00 00 00 
priority_boost(void) {
  struct proc *p;
  
  cprintf("[do boosting!]\n");

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104654:	75 d2                	jne    80104628 <priority_boost+0x18>
    p->time_quantum_used = 0;


    ptable.MLFQ_tick_used = 0;
  }
}
80104656:	c9                   	leave  
80104657:	c3                   	ret    
80104658:	90                   	nop
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104660 <set_cpu_share>:

// Design Document 1-1-2-4
int
set_cpu_share(int required) 
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104666:	56                   	push   %esi
80104667:	53                   	push   %ebx
  const int MAX_CPU_SHARE = 80;
  int is_new;
  int idx;

  // function argument is not valid
  if ( ! (MIN_CPU_SHARE <= required && required <= MAX_CPU_SHARE) ) 
80104668:	8d 41 ff             	lea    -0x1(%ecx),%eax
8010466b:	83 f8 4f             	cmp    $0x4f,%eax
8010466e:	0f 87 9c 00 00 00    	ja     80104710 <set_cpu_share+0xb0>
    goto exception;
  
  // Check whether a process is already in the stride queue
  cpu_share_already_set = proc->cpu_share;
80104674:	65 8b 1d 04 00 00 00 	mov    %gs:0x4,%ebx
    is_new = 1;
  } else {
    is_new = 0;
  }

  desired_sum_cpu_share = ptable.sum_cpu_share - cpu_share_already_set + required;
8010467b:	89 c8                	mov    %ecx,%eax
  // function argument is not valid
  if ( ! (MIN_CPU_SHARE <= required && required <= MAX_CPU_SHARE) ) 
    goto exception;
  
  // Check whether a process is already in the stride queue
  cpu_share_already_set = proc->cpu_share;
8010467d:	8b b3 88 00 00 00    	mov    0x88(%ebx),%esi
    is_new = 1;
  } else {
    is_new = 0;
  }

  desired_sum_cpu_share = ptable.sum_cpu_share - cpu_share_already_set + required;
80104683:	29 f0                	sub    %esi,%eax
80104685:	03 05 f0 63 11 80    	add    0x801163f0,%eax
  // If a required cpu share is too much, an exception occurs.
  if (desired_sum_cpu_share > MAX_CPU_SHARE )
8010468b:	83 f8 50             	cmp    $0x50,%eax
8010468e:	0f 8f 7c 00 00 00    	jg     80104710 <set_cpu_share+0xb0>
    goto exception;

  // It is okay to set cpu_share
  ptable.sum_cpu_share = desired_sum_cpu_share;
80104694:	a3 f0 63 11 80       	mov    %eax,0x801163f0
  proc->cpu_share = required;
  proc->stride = NSTRIDE / required;
80104699:	b8 10 27 00 00       	mov    $0x2710,%eax
8010469e:	99                   	cltd   
8010469f:	f7 f9                	idiv   %ecx
  if (desired_sum_cpu_share > MAX_CPU_SHARE )
    goto exception;

  // It is okay to set cpu_share
  ptable.sum_cpu_share = desired_sum_cpu_share;
  proc->cpu_share = required;
801046a1:	89 8b 88 00 00 00    	mov    %ecx,0x88(%ebx)
  proc->stride = NSTRIDE / required;
801046a7:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
    ptable.stride_queue[idx] = proc;
  } else {
    // if a process is already in the stride queue,
    // do nothing.
  }
  return 0;
801046ad:	31 c0                	xor    %eax,%eax
  // It is okay to set cpu_share
  ptable.sum_cpu_share = desired_sum_cpu_share;
  proc->cpu_share = required;
  proc->stride = NSTRIDE / required;

  if(is_new) {
801046af:	85 f6                	test   %esi,%esi
801046b1:	75 53                	jne    80104706 <set_cpu_share+0xa6>
    // Priority Queue Push
    // We do not need to check whether the stride queue is full because process cannot be generated more than 64

    // new process's stride_count should be minimum of a stride_count in the queue for preventing schuelder from being monopolized.
    if(ptable.stride_queue[1]) {
801046b3:	a1 f0 62 11 80       	mov    0x801162f0,%eax
801046b8:	85 c0                	test   %eax,%eax
801046ba:	74 0c                	je     801046c8 <set_cpu_share+0x68>
      proc->stride_count = ptable.stride_queue[1]->stride_count;
801046bc:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801046c2:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
801046c8:	a1 f4 63 11 80       	mov    0x801163f4,%eax
801046cd:	8d 50 01             	lea    0x1(%eax),%edx
    while(idx != 1) {
801046d0:	83 fa 01             	cmp    $0x1,%edx
    if(ptable.stride_queue[1]) {
      proc->stride_count = ptable.stride_queue[1]->stride_count;
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
801046d3:	89 15 f4 63 11 80    	mov    %edx,0x801163f4
    while(idx != 1) {
801046d9:	75 07                	jne    801046e2 <set_cpu_share+0x82>
801046db:	eb 21                	jmp    801046fe <set_cpu_share+0x9e>
801046dd:	8d 76 00             	lea    0x0(%esi),%esi
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
      idx /= 2;
801046e0:	89 c2                	mov    %eax,%edx
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
    while(idx != 1) {
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
801046e2:	89 d0                	mov    %edx,%eax
801046e4:	c1 e8 1f             	shr    $0x1f,%eax
801046e7:	01 d0                	add    %edx,%eax
801046e9:	d1 f8                	sar    %eax
801046eb:	8b 0c 85 ec 62 11 80 	mov    -0x7fee9d14(,%eax,4),%ecx
      proc->stride_count = ptable.stride_queue[1]->stride_count;
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
    while(idx != 1) {
801046f2:	83 f8 01             	cmp    $0x1,%eax
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
801046f5:	89 0c 95 ec 62 11 80 	mov    %ecx,-0x7fee9d14(,%edx,4)
      proc->stride_count = ptable.stride_queue[1]->stride_count;
    }

    // Heapify. Inserted process should be root of the queue because its stride_count is minium among processes in the stride queue.
    idx = ++ptable.stride_queue_size;
    while(idx != 1) {
801046fc:	75 e2                	jne    801046e0 <set_cpu_share+0x80>
      ptable.stride_queue[idx] = ptable.stride_queue[idx/2];
      idx /= 2;
    }
    ptable.stride_queue[idx] = proc;
801046fe:	89 1d f0 62 11 80    	mov    %ebx,0x801162f0
  } else {
    // if a process is already in the stride queue,
    // do nothing.
  }
  return 0;
80104704:	31 c0                	xor    %eax,%eax

exception:
  return -1;
}
80104706:	5b                   	pop    %ebx
80104707:	5e                   	pop    %esi
80104708:	5d                   	pop    %ebp
80104709:	c3                   	ret    
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    // do nothing.
  }
  return 0;

exception:
  return -1;
80104710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104715:	eb ef                	jmp    80104706 <set_cpu_share+0xa6>
80104717:	89 f6                	mov    %esi,%esi
80104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104720 <sys_set_cpu_share>:
}

int
sys_set_cpu_share(void) 
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	83 ec 28             	sub    $0x28,%esp
  int required;
  //Decode argument using argint

  if (argint(0, &required) < 0) {
80104726:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104729:	89 44 24 04          	mov    %eax,0x4(%esp)
8010472d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104734:	e8 07 06 00 00       	call   80104d40 <argint>
80104739:	85 c0                	test   %eax,%eax
8010473b:	78 13                	js     80104750 <sys_set_cpu_share+0x30>
    return -1;
  }

  return set_cpu_share(required);
8010473d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104740:	89 04 24             	mov    %eax,(%esp)
80104743:	e8 18 ff ff ff       	call   80104660 <set_cpu_share>
}
80104748:	c9                   	leave  
80104749:	c3                   	ret    
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int required;
  //Decode argument using argint

  if (argint(0, &required) < 0) {
    return -1;
80104750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  return set_cpu_share(required);
}
80104755:	c9                   	leave  
80104756:	c3                   	ret    
80104757:	66 90                	xchg   %ax,%ax
80104759:	66 90                	xchg   %ax,%ax
8010475b:	66 90                	xchg   %ax,%ax
8010475d:	66 90                	xchg   %ax,%ax
8010475f:	90                   	nop

80104760 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	53                   	push   %ebx
80104764:	83 ec 14             	sub    $0x14,%esp
80104767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010476a:	c7 44 24 04 5c 7c 10 	movl   $0x80107c5c,0x4(%esp)
80104771:	80 
80104772:	8d 43 04             	lea    0x4(%ebx),%eax
80104775:	89 04 24             	mov    %eax,(%esp)
80104778:	e8 f3 00 00 00       	call   80104870 <initlock>
  lk->name = name;
8010477d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104780:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104786:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010478d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104790:	83 c4 14             	add    $0x14,%esp
80104793:	5b                   	pop    %ebx
80104794:	5d                   	pop    %ebp
80104795:	c3                   	ret    
80104796:	8d 76 00             	lea    0x0(%esi),%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
801047a5:	83 ec 10             	sub    $0x10,%esp
801047a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047ab:	8d 73 04             	lea    0x4(%ebx),%esi
801047ae:	89 34 24             	mov    %esi,(%esp)
801047b1:	e8 3a 01 00 00       	call   801048f0 <acquire>
  while (lk->locked) {
801047b6:	8b 13                	mov    (%ebx),%edx
801047b8:	85 d2                	test   %edx,%edx
801047ba:	74 16                	je     801047d2 <acquiresleep+0x32>
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801047c0:	89 74 24 04          	mov    %esi,0x4(%esp)
801047c4:	89 1c 24             	mov    %ebx,(%esp)
801047c7:	e8 94 fa ff ff       	call   80104260 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801047cc:	8b 03                	mov    (%ebx),%eax
801047ce:	85 c0                	test   %eax,%eax
801047d0:	75 ee                	jne    801047c0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801047d2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = proc->pid;
801047d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047de:	8b 40 10             	mov    0x10(%eax),%eax
801047e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801047e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801047e7:	83 c4 10             	add    $0x10,%esp
801047ea:	5b                   	pop    %ebx
801047eb:	5e                   	pop    %esi
801047ec:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = proc->pid;
  release(&lk->lk);
801047ed:	e9 2e 02 00 00       	jmp    80104a20 <release>
801047f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	83 ec 10             	sub    $0x10,%esp
80104808:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010480b:	8d 73 04             	lea    0x4(%ebx),%esi
8010480e:	89 34 24             	mov    %esi,(%esp)
80104811:	e8 da 00 00 00       	call   801048f0 <acquire>
  lk->locked = 0;
80104816:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010481c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104823:	89 1c 24             	mov    %ebx,(%esp)
80104826:	e8 25 fc ff ff       	call   80104450 <wakeup>
  release(&lk->lk);
8010482b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010482e:	83 c4 10             	add    $0x10,%esp
80104831:	5b                   	pop    %ebx
80104832:	5e                   	pop    %esi
80104833:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104834:	e9 e7 01 00 00       	jmp    80104a20 <release>
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104840 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
80104845:	83 ec 10             	sub    $0x10,%esp
80104848:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010484b:	8d 73 04             	lea    0x4(%ebx),%esi
8010484e:	89 34 24             	mov    %esi,(%esp)
80104851:	e8 9a 00 00 00       	call   801048f0 <acquire>
  r = lk->locked;
80104856:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104858:	89 34 24             	mov    %esi,(%esp)
8010485b:	e8 c0 01 00 00       	call   80104a20 <release>
  return r;
}
80104860:	83 c4 10             	add    $0x10,%esp
80104863:	89 d8                	mov    %ebx,%eax
80104865:	5b                   	pop    %ebx
80104866:	5e                   	pop    %esi
80104867:	5d                   	pop    %ebp
80104868:	c3                   	ret    
80104869:	66 90                	xchg   %ax,%ax
8010486b:	66 90                	xchg   %ax,%ax
8010486d:	66 90                	xchg   %ax,%ax
8010486f:	90                   	nop

80104870 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104876:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104879:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010487f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104882:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    
8010488b:	90                   	nop
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104890 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104893:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104896:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104899:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010489a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010489d:	31 c0                	xor    %eax,%eax
8010489f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048ac:	77 1a                	ja     801048c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801048ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801048b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048b4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801048b7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048b9:	83 f8 0a             	cmp    $0xa,%eax
801048bc:	75 e2                	jne    801048a0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801048be:	5b                   	pop    %ebx
801048bf:	5d                   	pop    %ebp
801048c0:	c3                   	ret    
801048c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801048c8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801048cf:	83 c0 01             	add    $0x1,%eax
801048d2:	83 f8 0a             	cmp    $0xa,%eax
801048d5:	74 e7                	je     801048be <getcallerpcs+0x2e>
    pcs[i] = 0;
801048d7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801048de:	83 c0 01             	add    $0x1,%eax
801048e1:	83 f8 0a             	cmp    $0xa,%eax
801048e4:	75 e2                	jne    801048c8 <getcallerpcs+0x38>
801048e6:	eb d6                	jmp    801048be <getcallerpcs+0x2e>
801048e8:	90                   	nop
801048e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048f0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	83 ec 18             	sub    $0x18,%esp
801048f6:	9c                   	pushf  
801048f7:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801048f8:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801048f9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801048ff:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104905:	85 d2                	test   %edx,%edx
80104907:	75 0c                	jne    80104915 <acquire+0x25>
    cpu->intena = eflags & FL_IF;
80104909:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010490f:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
80104915:	83 c2 01             	add    $0x1,%edx
80104918:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
8010491e:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104921:	8b 0a                	mov    (%edx),%ecx
80104923:	85 c9                	test   %ecx,%ecx
80104925:	74 05                	je     8010492c <acquire+0x3c>
80104927:	3b 42 08             	cmp    0x8(%edx),%eax
8010492a:	74 3e                	je     8010496a <acquire+0x7a>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010492c:	b9 01 00 00 00       	mov    $0x1,%ecx
80104931:	eb 08                	jmp    8010493b <acquire+0x4b>
80104933:	90                   	nop
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104938:	8b 55 08             	mov    0x8(%ebp),%edx
8010493b:	89 c8                	mov    %ecx,%eax
8010493d:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104940:	85 c0                	test   %eax,%eax
80104942:	75 f4                	jne    80104938 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104944:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104949:	8b 45 08             	mov    0x8(%ebp),%eax
8010494c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
  getcallerpcs(&lk, lk->pcs);
80104953:	83 c0 0c             	add    $0xc,%eax
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104956:	89 50 fc             	mov    %edx,-0x4(%eax)
  getcallerpcs(&lk, lk->pcs);
80104959:	89 44 24 04          	mov    %eax,0x4(%esp)
8010495d:	8d 45 08             	lea    0x8(%ebp),%eax
80104960:	89 04 24             	mov    %eax,(%esp)
80104963:	e8 28 ff ff ff       	call   80104890 <getcallerpcs>
}
80104968:	c9                   	leave  
80104969:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
8010496a:	c7 04 24 67 7c 10 80 	movl   $0x80107c67,(%esp)
80104971:	e8 ea b9 ff ff       	call   80100360 <panic>
80104976:	8d 76 00             	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104980:	55                   	push   %ebp
  return lock->locked && lock->cpu == cpu;
80104981:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104983:	89 e5                	mov    %esp,%ebp
80104985:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104988:	8b 0a                	mov    (%edx),%ecx
8010498a:	85 c9                	test   %ecx,%ecx
8010498c:	74 0f                	je     8010499d <holding+0x1d>
8010498e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104994:	39 42 08             	cmp    %eax,0x8(%edx)
80104997:	0f 94 c0             	sete   %al
8010499a:	0f b6 c0             	movzbl %al,%eax
}
8010499d:	5d                   	pop    %ebp
8010499e:	c3                   	ret    
8010499f:	90                   	nop

801049a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049a3:	9c                   	pushf  
801049a4:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801049a5:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801049a6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801049ac:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801049b2:	85 d2                	test   %edx,%edx
801049b4:	75 0c                	jne    801049c2 <pushcli+0x22>
    cpu->intena = eflags & FL_IF;
801049b6:	81 e1 00 02 00 00    	and    $0x200,%ecx
801049bc:	89 88 b0 00 00 00    	mov    %ecx,0xb0(%eax)
  cpu->ncli += 1;
801049c2:	83 c2 01             	add    $0x1,%edx
801049c5:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
}
801049cb:	5d                   	pop    %ebp
801049cc:	c3                   	ret    
801049cd:	8d 76 00             	lea    0x0(%esi),%esi

801049d0 <popcli>:

void
popcli(void)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049d6:	9c                   	pushf  
801049d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801049d8:	f6 c4 02             	test   $0x2,%ah
801049db:	75 34                	jne    80104a11 <popcli+0x41>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
801049dd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801049e3:	8b 88 ac 00 00 00    	mov    0xac(%eax),%ecx
801049e9:	8d 51 ff             	lea    -0x1(%ecx),%edx
801049ec:	85 d2                	test   %edx,%edx
801049ee:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801049f4:	78 0f                	js     80104a05 <popcli+0x35>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
801049f6:	75 0b                	jne    80104a03 <popcli+0x33>
801049f8:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801049fe:	85 c0                	test   %eax,%eax
80104a00:	74 01                	je     80104a03 <popcli+0x33>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104a02:	fb                   	sti    
    sti();
}
80104a03:	c9                   	leave  
80104a04:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
80104a05:	c7 04 24 86 7c 10 80 	movl   $0x80107c86,(%esp)
80104a0c:	e8 4f b9 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104a11:	c7 04 24 6f 7c 10 80 	movl   $0x80107c6f,(%esp)
80104a18:	e8 43 b9 ff ff       	call   80100360 <panic>
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi

80104a20 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	83 ec 18             	sub    $0x18,%esp
80104a26:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104a29:	8b 10                	mov    (%eax),%edx
80104a2b:	85 d2                	test   %edx,%edx
80104a2d:	74 0c                	je     80104a3b <release+0x1b>
80104a2f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104a36:	39 50 08             	cmp    %edx,0x8(%eax)
80104a39:	74 0d                	je     80104a48 <release+0x28>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104a3b:	c7 04 24 8d 7c 10 80 	movl   $0x80107c8d,(%esp)
80104a42:	e8 19 b9 ff ff       	call   80100360 <panic>
80104a47:	90                   	nop

  lk->pcs[0] = 0;
80104a48:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104a4f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104a56:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80104a61:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104a62:	e9 69 ff ff ff       	jmp    801049d0 <popcli>
80104a67:	66 90                	xchg   %ax,%ax
80104a69:	66 90                	xchg   %ax,%ax
80104a6b:	66 90                	xchg   %ax,%ax
80104a6d:	66 90                	xchg   %ax,%ax
80104a6f:	90                   	nop

80104a70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	8b 55 08             	mov    0x8(%ebp),%edx
80104a76:	57                   	push   %edi
80104a77:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a7a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a7b:	f6 c2 03             	test   $0x3,%dl
80104a7e:	75 05                	jne    80104a85 <memset+0x15>
80104a80:	f6 c1 03             	test   $0x3,%cl
80104a83:	74 13                	je     80104a98 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104a85:	89 d7                	mov    %edx,%edi
80104a87:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a8a:	fc                   	cld    
80104a8b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a8d:	5b                   	pop    %ebx
80104a8e:	89 d0                	mov    %edx,%eax
80104a90:	5f                   	pop    %edi
80104a91:	5d                   	pop    %ebp
80104a92:	c3                   	ret    
80104a93:	90                   	nop
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104a98:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a9c:	c1 e9 02             	shr    $0x2,%ecx
80104a9f:	89 f8                	mov    %edi,%eax
80104aa1:	89 fb                	mov    %edi,%ebx
80104aa3:	c1 e0 18             	shl    $0x18,%eax
80104aa6:	c1 e3 10             	shl    $0x10,%ebx
80104aa9:	09 d8                	or     %ebx,%eax
80104aab:	09 f8                	or     %edi,%eax
80104aad:	c1 e7 08             	shl    $0x8,%edi
80104ab0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104ab2:	89 d7                	mov    %edx,%edi
80104ab4:	fc                   	cld    
80104ab5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104ab7:	5b                   	pop    %ebx
80104ab8:	89 d0                	mov    %edx,%eax
80104aba:	5f                   	pop    %edi
80104abb:	5d                   	pop    %ebp
80104abc:	c3                   	ret    
80104abd:	8d 76 00             	lea    0x0(%esi),%esi

80104ac0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	8b 45 10             	mov    0x10(%ebp),%eax
80104ac6:	57                   	push   %edi
80104ac7:	56                   	push   %esi
80104ac8:	8b 75 0c             	mov    0xc(%ebp),%esi
80104acb:	53                   	push   %ebx
80104acc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104acf:	85 c0                	test   %eax,%eax
80104ad1:	8d 78 ff             	lea    -0x1(%eax),%edi
80104ad4:	74 26                	je     80104afc <memcmp+0x3c>
    if(*s1 != *s2)
80104ad6:	0f b6 03             	movzbl (%ebx),%eax
80104ad9:	31 d2                	xor    %edx,%edx
80104adb:	0f b6 0e             	movzbl (%esi),%ecx
80104ade:	38 c8                	cmp    %cl,%al
80104ae0:	74 16                	je     80104af8 <memcmp+0x38>
80104ae2:	eb 24                	jmp    80104b08 <memcmp+0x48>
80104ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ae8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
80104aed:	83 c2 01             	add    $0x1,%edx
80104af0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104af4:	38 c8                	cmp    %cl,%al
80104af6:	75 10                	jne    80104b08 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104af8:	39 fa                	cmp    %edi,%edx
80104afa:	75 ec                	jne    80104ae8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104afc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104afd:	31 c0                	xor    %eax,%eax
}
80104aff:	5e                   	pop    %esi
80104b00:	5f                   	pop    %edi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	90                   	nop
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b08:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104b09:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104b0b:	5e                   	pop    %esi
80104b0c:	5f                   	pop    %edi
80104b0d:	5d                   	pop    %ebp
80104b0e:	c3                   	ret    
80104b0f:	90                   	nop

80104b10 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	8b 45 08             	mov    0x8(%ebp),%eax
80104b17:	56                   	push   %esi
80104b18:	8b 75 0c             	mov    0xc(%ebp),%esi
80104b1b:	53                   	push   %ebx
80104b1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b1f:	39 c6                	cmp    %eax,%esi
80104b21:	73 35                	jae    80104b58 <memmove+0x48>
80104b23:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104b26:	39 c8                	cmp    %ecx,%eax
80104b28:	73 2e                	jae    80104b58 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
80104b2a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
80104b2c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
80104b2f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104b32:	74 1b                	je     80104b4f <memmove+0x3f>
80104b34:	f7 db                	neg    %ebx
80104b36:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104b39:	01 fb                	add    %edi,%ebx
80104b3b:	90                   	nop
80104b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104b40:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104b44:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104b47:	83 ea 01             	sub    $0x1,%edx
80104b4a:	83 fa ff             	cmp    $0xffffffff,%edx
80104b4d:	75 f1                	jne    80104b40 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b4f:	5b                   	pop    %ebx
80104b50:	5e                   	pop    %esi
80104b51:	5f                   	pop    %edi
80104b52:	5d                   	pop    %ebp
80104b53:	c3                   	ret    
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104b58:	31 d2                	xor    %edx,%edx
80104b5a:	85 db                	test   %ebx,%ebx
80104b5c:	74 f1                	je     80104b4f <memmove+0x3f>
80104b5e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104b60:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104b64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b67:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104b6a:	39 da                	cmp    %ebx,%edx
80104b6c:	75 f2                	jne    80104b60 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104b6e:	5b                   	pop    %ebx
80104b6f:	5e                   	pop    %esi
80104b70:	5f                   	pop    %edi
80104b71:	5d                   	pop    %ebp
80104b72:	c3                   	ret    
80104b73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104b83:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104b84:	e9 87 ff ff ff       	jmp    80104b10 <memmove>
80104b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b90 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	8b 75 10             	mov    0x10(%ebp),%esi
80104b97:	53                   	push   %ebx
80104b98:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
80104b9e:	85 f6                	test   %esi,%esi
80104ba0:	74 30                	je     80104bd2 <strncmp+0x42>
80104ba2:	0f b6 01             	movzbl (%ecx),%eax
80104ba5:	84 c0                	test   %al,%al
80104ba7:	74 2f                	je     80104bd8 <strncmp+0x48>
80104ba9:	0f b6 13             	movzbl (%ebx),%edx
80104bac:	38 d0                	cmp    %dl,%al
80104bae:	75 46                	jne    80104bf6 <strncmp+0x66>
80104bb0:	8d 51 01             	lea    0x1(%ecx),%edx
80104bb3:	01 ce                	add    %ecx,%esi
80104bb5:	eb 14                	jmp    80104bcb <strncmp+0x3b>
80104bb7:	90                   	nop
80104bb8:	0f b6 02             	movzbl (%edx),%eax
80104bbb:	84 c0                	test   %al,%al
80104bbd:	74 31                	je     80104bf0 <strncmp+0x60>
80104bbf:	0f b6 19             	movzbl (%ecx),%ebx
80104bc2:	83 c2 01             	add    $0x1,%edx
80104bc5:	38 d8                	cmp    %bl,%al
80104bc7:	75 17                	jne    80104be0 <strncmp+0x50>
    n--, p++, q++;
80104bc9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104bcb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
80104bcd:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104bd0:	75 e6                	jne    80104bb8 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104bd2:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104bd3:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104bd5:	5e                   	pop    %esi
80104bd6:	5d                   	pop    %ebp
80104bd7:	c3                   	ret    
80104bd8:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104bdb:	31 c0                	xor    %eax,%eax
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104be0:	0f b6 d3             	movzbl %bl,%edx
80104be3:	29 d0                	sub    %edx,%eax
}
80104be5:	5b                   	pop    %ebx
80104be6:	5e                   	pop    %esi
80104be7:	5d                   	pop    %ebp
80104be8:	c3                   	ret    
80104be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bf0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104bf4:	eb ea                	jmp    80104be0 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104bf6:	89 d3                	mov    %edx,%ebx
80104bf8:	eb e6                	jmp    80104be0 <strncmp+0x50>
80104bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c00 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	8b 45 08             	mov    0x8(%ebp),%eax
80104c06:	56                   	push   %esi
80104c07:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c0a:	53                   	push   %ebx
80104c0b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c0e:	89 c2                	mov    %eax,%edx
80104c10:	eb 19                	jmp    80104c2b <strncpy+0x2b>
80104c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c18:	83 c3 01             	add    $0x1,%ebx
80104c1b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c1f:	83 c2 01             	add    $0x1,%edx
80104c22:	84 c9                	test   %cl,%cl
80104c24:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c27:	74 09                	je     80104c32 <strncpy+0x32>
80104c29:	89 f1                	mov    %esi,%ecx
80104c2b:	85 c9                	test   %ecx,%ecx
80104c2d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c30:	7f e6                	jg     80104c18 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c32:	31 c9                	xor    %ecx,%ecx
80104c34:	85 f6                	test   %esi,%esi
80104c36:	7e 0f                	jle    80104c47 <strncpy+0x47>
    *s++ = 0;
80104c38:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c3c:	89 f3                	mov    %esi,%ebx
80104c3e:	83 c1 01             	add    $0x1,%ecx
80104c41:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104c43:	85 db                	test   %ebx,%ebx
80104c45:	7f f1                	jg     80104c38 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104c47:	5b                   	pop    %ebx
80104c48:	5e                   	pop    %esi
80104c49:	5d                   	pop    %ebp
80104c4a:	c3                   	ret    
80104c4b:	90                   	nop
80104c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c56:	56                   	push   %esi
80104c57:	8b 45 08             	mov    0x8(%ebp),%eax
80104c5a:	53                   	push   %ebx
80104c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c5e:	85 c9                	test   %ecx,%ecx
80104c60:	7e 26                	jle    80104c88 <safestrcpy+0x38>
80104c62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c66:	89 c1                	mov    %eax,%ecx
80104c68:	eb 17                	jmp    80104c81 <safestrcpy+0x31>
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c70:	83 c2 01             	add    $0x1,%edx
80104c73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c77:	83 c1 01             	add    $0x1,%ecx
80104c7a:	84 db                	test   %bl,%bl
80104c7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c7f:	74 04                	je     80104c85 <safestrcpy+0x35>
80104c81:	39 f2                	cmp    %esi,%edx
80104c83:	75 eb                	jne    80104c70 <safestrcpy+0x20>
    ;
  *s = 0;
80104c85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104c88:	5b                   	pop    %ebx
80104c89:	5e                   	pop    %esi
80104c8a:	5d                   	pop    %ebp
80104c8b:	c3                   	ret    
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c90 <strlen>:

int
strlen(const char *s)
{
80104c90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c91:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104c93:	89 e5                	mov    %esp,%ebp
80104c95:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104c98:	80 3a 00             	cmpb   $0x0,(%edx)
80104c9b:	74 0c                	je     80104ca9 <strlen+0x19>
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ca0:	83 c0 01             	add    $0x1,%eax
80104ca3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ca7:	75 f7                	jne    80104ca0 <strlen+0x10>
    ;
  return n;
}
80104ca9:	5d                   	pop    %ebp
80104caa:	c3                   	ret    

80104cab <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax # esp는 return address를 가리키고 있다(old). 아직 스택에 아무것도 push가 안됐으므로, return address를 가리킨다.
80104cab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx # new
80104caf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  # 아래 push하는 레지스터들은 convention에 따른다.
  # eip는 push하지 않는다. esp를 그냥 eip로 삼겠다는 것.
  pushl %ebp
80104cb3:	55                   	push   %ebp
  pushl %ebx
80104cb4:	53                   	push   %ebx
  pushl %esi
80104cb5:	56                   	push   %esi
  pushl %edi
80104cb6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax) # esp의 값을 eax가 가리키고 있는 주소에 넣는다. eax는 old. old가 edi를 가리키게 된다. 즉 old는 old context를 가리키게 된다.
80104cb7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp # edx는 new가 있다. esp에 edx를 넣는다는 것은 새로운 스택을 쓰겠다는 것. 여기서 하나씩 뺴면 new context의 값을 cpu register에 넣는다.
80104cb9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104cbb:	5f                   	pop    %edi
  popl %esi
80104cbc:	5e                   	pop    %esi
  popl %ebx
80104cbd:	5b                   	pop    %ebx
  popl %ebp
80104cbe:	5d                   	pop    %ebp
  ret # eip를 빼는 것. ret는 call과 쌍이다. call에서 return address를 넣는다. 맞나? ret를 실행함으로써 eip를 리턴한다? 뺀다?
80104cbf:	c3                   	ret    

80104cc0 <fetchint>:

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104cc0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104cc7:	55                   	push   %ebp
80104cc8:	89 e5                	mov    %esp,%ebp
80104cca:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
80104ccd:	8b 12                	mov    (%edx),%edx
80104ccf:	39 c2                	cmp    %eax,%edx
80104cd1:	76 15                	jbe    80104ce8 <fetchint+0x28>
80104cd3:	8d 48 04             	lea    0x4(%eax),%ecx
80104cd6:	39 ca                	cmp    %ecx,%edx
80104cd8:	72 0e                	jb     80104ce8 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
80104cda:	8b 10                	mov    (%eax),%edx
80104cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cdf:	89 10                	mov    %edx,(%eax)
  return 0;
80104ce1:	31 c0                	xor    %eax,%eax
}
80104ce3:	5d                   	pop    %ebp
80104ce4:	c3                   	ret    
80104ce5:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104ce8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
80104ced:	5d                   	pop    %ebp
80104cee:	c3                   	ret    
80104cef:	90                   	nop

80104cf0 <fetchstr>:
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104cf0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104cf6:	55                   	push   %ebp
80104cf7:	89 e5                	mov    %esp,%ebp
80104cf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
80104cfc:	39 08                	cmp    %ecx,(%eax)
80104cfe:	76 2c                	jbe    80104d2c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d00:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d03:	89 c8                	mov    %ecx,%eax
80104d05:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104d07:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d0e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104d10:	39 d1                	cmp    %edx,%ecx
80104d12:	73 18                	jae    80104d2c <fetchstr+0x3c>
    if(*s == 0)
80104d14:	80 39 00             	cmpb   $0x0,(%ecx)
80104d17:	75 0c                	jne    80104d25 <fetchstr+0x35>
80104d19:	eb 1d                	jmp    80104d38 <fetchstr+0x48>
80104d1b:	90                   	nop
80104d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d20:	80 38 00             	cmpb   $0x0,(%eax)
80104d23:	74 13                	je     80104d38 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104d25:	83 c0 01             	add    $0x1,%eax
80104d28:	39 c2                	cmp    %eax,%edx
80104d2a:	77 f4                	ja     80104d20 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
80104d2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104d31:	5d                   	pop    %ebp
80104d32:	c3                   	ret    
80104d33:	90                   	nop
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104d38:	29 c8                	sub    %ecx,%eax
  return -1;
}
80104d3a:	5d                   	pop    %ebp
80104d3b:	c3                   	ret    
80104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d40:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d47:	55                   	push   %ebp
80104d48:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d4d:	8b 42 18             	mov    0x18(%edx),%eax

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104d50:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d52:	8b 40 44             	mov    0x44(%eax),%eax
80104d55:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104d58:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104d5b:	39 d1                	cmp    %edx,%ecx
80104d5d:	73 19                	jae    80104d78 <argint+0x38>
80104d5f:	8d 48 08             	lea    0x8(%eax),%ecx
80104d62:	39 ca                	cmp    %ecx,%edx
80104d64:	72 12                	jb     80104d78 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104d66:	8b 50 04             	mov    0x4(%eax),%edx
80104d69:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d6c:	89 10                	mov    %edx,(%eax)
  return 0;
80104d6e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104d70:	5d                   	pop    %ebp
80104d71:	c3                   	ret    
80104d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104d78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104d7d:	5d                   	pop    %ebp
80104d7e:	c3                   	ret    
80104d7f:	90                   	nop

80104d80 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d86:	55                   	push   %ebp
80104d87:	89 e5                	mov    %esp,%ebp
80104d89:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d8d:	8b 50 18             	mov    0x18(%eax),%edx
80104d90:	8b 52 44             	mov    0x44(%edx),%edx
80104d93:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104d96:	8b 10                	mov    (%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
80104d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104d9d:	8d 59 04             	lea    0x4(%ecx),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104da0:	39 d3                	cmp    %edx,%ebx
80104da2:	73 25                	jae    80104dc9 <argptr+0x49>
80104da4:	8d 59 08             	lea    0x8(%ecx),%ebx
80104da7:	39 da                	cmp    %ebx,%edx
80104da9:	72 1e                	jb     80104dc9 <argptr+0x49>
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104dab:	8b 5d 10             	mov    0x10(%ebp),%ebx
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104dae:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= proc->sz || (uint)i+size > proc->sz)
80104db1:	85 db                	test   %ebx,%ebx
80104db3:	78 14                	js     80104dc9 <argptr+0x49>
80104db5:	39 d1                	cmp    %edx,%ecx
80104db7:	73 10                	jae    80104dc9 <argptr+0x49>
80104db9:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104dbc:	01 cb                	add    %ecx,%ebx
80104dbe:	39 d3                	cmp    %edx,%ebx
80104dc0:	77 07                	ja     80104dc9 <argptr+0x49>
    return -1;
  *pp = (char*)i;
80104dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dc5:	89 08                	mov    %ecx,(%eax)
  return 0;
80104dc7:	31 c0                	xor    %eax,%eax
}
80104dc9:	5b                   	pop    %ebx
80104dca:	5d                   	pop    %ebp
80104dcb:	c3                   	ret    
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104dd0 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104dd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104dd6:	55                   	push   %ebp
80104dd7:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104dd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ddc:	8b 50 18             	mov    0x18(%eax),%edx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104ddf:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104de1:	8b 52 44             	mov    0x44(%edx),%edx
80104de4:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104de7:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104dea:	39 c1                	cmp    %eax,%ecx
80104dec:	73 07                	jae    80104df5 <argstr+0x25>
80104dee:	8d 4a 08             	lea    0x8(%edx),%ecx
80104df1:	39 c8                	cmp    %ecx,%eax
80104df3:	73 0b                	jae    80104e00 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104dfa:	5d                   	pop    %ebp
80104dfb:	c3                   	ret    
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104e00:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104e03:	39 c1                	cmp    %eax,%ecx
80104e05:	73 ee                	jae    80104df5 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
80104e07:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e0a:	89 c8                	mov    %ecx,%eax
80104e0c:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104e0e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e15:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104e17:	39 d1                	cmp    %edx,%ecx
80104e19:	73 da                	jae    80104df5 <argstr+0x25>
    if(*s == 0)
80104e1b:	80 39 00             	cmpb   $0x0,(%ecx)
80104e1e:	75 12                	jne    80104e32 <argstr+0x62>
80104e20:	eb 1e                	jmp    80104e40 <argstr+0x70>
80104e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e28:	80 38 00             	cmpb   $0x0,(%eax)
80104e2b:	90                   	nop
80104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e30:	74 0e                	je     80104e40 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104e32:	83 c0 01             	add    $0x1,%eax
80104e35:	39 c2                	cmp    %eax,%edx
80104e37:	77 ef                	ja     80104e28 <argstr+0x58>
80104e39:	eb ba                	jmp    80104df5 <argstr+0x25>
80104e3b:	90                   	nop
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(*s == 0)
      return s - *pp;
80104e40:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104e42:	5d                   	pop    %ebp
80104e43:	c3                   	ret    
80104e44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e50 <syscall>:
[SYS_set_cpu_share]  sys_set_cpu_share,
};

void
syscall(void)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	53                   	push   %ebx
80104e54:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80104e57:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e5e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104e61:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e64:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104e67:	83 f9 19             	cmp    $0x19,%ecx
80104e6a:	77 1c                	ja     80104e88 <syscall+0x38>
80104e6c:	8b 0c 85 c0 7c 10 80 	mov    -0x7fef8340(,%eax,4),%ecx
80104e73:	85 c9                	test   %ecx,%ecx
80104e75:	74 11                	je     80104e88 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104e77:	ff d1                	call   *%ecx
80104e79:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
80104e7c:	83 c4 14             	add    $0x14,%esp
80104e7f:	5b                   	pop    %ebx
80104e80:	5d                   	pop    %ebp
80104e81:	c3                   	ret    
80104e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104e88:	89 44 24 0c          	mov    %eax,0xc(%esp)
            proc->pid, proc->name, num);
80104e8c:	8d 42 6c             	lea    0x6c(%edx),%eax
80104e8f:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104e93:	8b 42 10             	mov    0x10(%edx),%eax
80104e96:	c7 04 24 95 7c 10 80 	movl   $0x80107c95,(%esp)
80104e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ea1:	e8 aa b7 ff ff       	call   80100650 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80104ea6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eac:	8b 40 18             	mov    0x18(%eax),%eax
80104eaf:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104eb6:	83 c4 14             	add    $0x14,%esp
80104eb9:	5b                   	pop    %ebx
80104eba:	5d                   	pop    %ebp
80104ebb:	c3                   	ret    
80104ebc:	66 90                	xchg   %ax,%ax
80104ebe:	66 90                	xchg   %ax,%ax

80104ec0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	56                   	push   %esi
80104ec5:	53                   	push   %ebx
80104ec6:	83 ec 4c             	sub    $0x4c,%esp
80104ec9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104ecc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ecf:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104ed2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104ed6:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ed9:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104edc:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104edf:	e8 1c d0 ff ff       	call   80101f00 <nameiparent>
80104ee4:	85 c0                	test   %eax,%eax
80104ee6:	89 c7                	mov    %eax,%edi
80104ee8:	0f 84 da 00 00 00    	je     80104fc8 <create+0x108>
    return 0;
  ilock(dp);
80104eee:	89 04 24             	mov    %eax,(%esp)
80104ef1:	e8 ba c7 ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104ef6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104ef9:	89 44 24 08          	mov    %eax,0x8(%esp)
80104efd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104f01:	89 3c 24             	mov    %edi,(%esp)
80104f04:	e8 97 cc ff ff       	call   80101ba0 <dirlookup>
80104f09:	85 c0                	test   %eax,%eax
80104f0b:	89 c6                	mov    %eax,%esi
80104f0d:	74 41                	je     80104f50 <create+0x90>
    iunlockput(dp);
80104f0f:	89 3c 24             	mov    %edi,(%esp)
80104f12:	e8 d9 c9 ff ff       	call   801018f0 <iunlockput>
    ilock(ip);
80104f17:	89 34 24             	mov    %esi,(%esp)
80104f1a:	e8 91 c7 ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f1f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104f24:	75 12                	jne    80104f38 <create+0x78>
80104f26:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104f2b:	89 f0                	mov    %esi,%eax
80104f2d:	75 09                	jne    80104f38 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f2f:	83 c4 4c             	add    $0x4c,%esp
80104f32:	5b                   	pop    %ebx
80104f33:	5e                   	pop    %esi
80104f34:	5f                   	pop    %edi
80104f35:	5d                   	pop    %ebp
80104f36:	c3                   	ret    
80104f37:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104f38:	89 34 24             	mov    %esi,(%esp)
80104f3b:	e8 b0 c9 ff ff       	call   801018f0 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f40:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104f43:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f45:	5b                   	pop    %ebx
80104f46:	5e                   	pop    %esi
80104f47:	5f                   	pop    %edi
80104f48:	5d                   	pop    %ebp
80104f49:	c3                   	ret    
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104f50:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104f54:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f58:	8b 07                	mov    (%edi),%eax
80104f5a:	89 04 24             	mov    %eax,(%esp)
80104f5d:	e8 be c5 ff ff       	call   80101520 <ialloc>
80104f62:	85 c0                	test   %eax,%eax
80104f64:	89 c6                	mov    %eax,%esi
80104f66:	0f 84 bf 00 00 00    	je     8010502b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
80104f6c:	89 04 24             	mov    %eax,(%esp)
80104f6f:	e8 3c c7 ff ff       	call   801016b0 <ilock>
  ip->major = major;
80104f74:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104f78:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104f7c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104f80:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104f84:	b8 01 00 00 00       	mov    $0x1,%eax
80104f89:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104f8d:	89 34 24             	mov    %esi,(%esp)
80104f90:	e8 5b c6 ff ff       	call   801015f0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104f95:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104f9a:	74 34                	je     80104fd0 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104f9c:	8b 46 04             	mov    0x4(%esi),%eax
80104f9f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104fa3:	89 3c 24             	mov    %edi,(%esp)
80104fa6:	89 44 24 08          	mov    %eax,0x8(%esp)
80104faa:	e8 51 ce ff ff       	call   80101e00 <dirlink>
80104faf:	85 c0                	test   %eax,%eax
80104fb1:	78 6c                	js     8010501f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104fb3:	89 3c 24             	mov    %edi,(%esp)
80104fb6:	e8 35 c9 ff ff       	call   801018f0 <iunlockput>

  return ip;
}
80104fbb:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104fbe:	89 f0                	mov    %esi,%eax
}
80104fc0:	5b                   	pop    %ebx
80104fc1:	5e                   	pop    %esi
80104fc2:	5f                   	pop    %edi
80104fc3:	5d                   	pop    %ebp
80104fc4:	c3                   	ret    
80104fc5:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104fc8:	31 c0                	xor    %eax,%eax
80104fca:	e9 60 ff ff ff       	jmp    80104f2f <create+0x6f>
80104fcf:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104fd0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104fd5:	89 3c 24             	mov    %edi,(%esp)
80104fd8:	e8 13 c6 ff ff       	call   801015f0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104fdd:	8b 46 04             	mov    0x4(%esi),%eax
80104fe0:	c7 44 24 04 48 7d 10 	movl   $0x80107d48,0x4(%esp)
80104fe7:	80 
80104fe8:	89 34 24             	mov    %esi,(%esp)
80104feb:	89 44 24 08          	mov    %eax,0x8(%esp)
80104fef:	e8 0c ce ff ff       	call   80101e00 <dirlink>
80104ff4:	85 c0                	test   %eax,%eax
80104ff6:	78 1b                	js     80105013 <create+0x153>
80104ff8:	8b 47 04             	mov    0x4(%edi),%eax
80104ffb:	c7 44 24 04 47 7d 10 	movl   $0x80107d47,0x4(%esp)
80105002:	80 
80105003:	89 34 24             	mov    %esi,(%esp)
80105006:	89 44 24 08          	mov    %eax,0x8(%esp)
8010500a:	e8 f1 cd ff ff       	call   80101e00 <dirlink>
8010500f:	85 c0                	test   %eax,%eax
80105011:	79 89                	jns    80104f9c <create+0xdc>
      panic("create dots");
80105013:	c7 04 24 3b 7d 10 80 	movl   $0x80107d3b,(%esp)
8010501a:	e8 41 b3 ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010501f:	c7 04 24 4a 7d 10 80 	movl   $0x80107d4a,(%esp)
80105026:	e8 35 b3 ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
8010502b:	c7 04 24 2c 7d 10 80 	movl   $0x80107d2c,(%esp)
80105032:	e8 29 b3 ff ff       	call   80100360 <panic>
80105037:	89 f6                	mov    %esi,%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105040 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	89 c6                	mov    %eax,%esi
80105046:	53                   	push   %ebx
80105047:	89 d3                	mov    %edx,%ebx
80105049:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010504c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010504f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105053:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010505a:	e8 e1 fc ff ff       	call   80104d40 <argint>
8010505f:	85 c0                	test   %eax,%eax
80105061:	78 35                	js     80105098 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105063:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105066:	83 f9 0f             	cmp    $0xf,%ecx
80105069:	77 2d                	ja     80105098 <argfd.constprop.0+0x58>
8010506b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105071:	8b 44 88 28          	mov    0x28(%eax,%ecx,4),%eax
80105075:	85 c0                	test   %eax,%eax
80105077:	74 1f                	je     80105098 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80105079:	85 f6                	test   %esi,%esi
8010507b:	74 02                	je     8010507f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010507d:	89 0e                	mov    %ecx,(%esi)
  if(pf)
8010507f:	85 db                	test   %ebx,%ebx
80105081:	74 0d                	je     80105090 <argfd.constprop.0+0x50>
    *pf = f;
80105083:	89 03                	mov    %eax,(%ebx)
  return 0;
80105085:	31 c0                	xor    %eax,%eax
}
80105087:	83 c4 20             	add    $0x20,%esp
8010508a:	5b                   	pop    %ebx
8010508b:	5e                   	pop    %esi
8010508c:	5d                   	pop    %ebp
8010508d:	c3                   	ret    
8010508e:	66 90                	xchg   %ax,%ax
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105090:	31 c0                	xor    %eax,%eax
80105092:	eb f3                	jmp    80105087 <argfd.constprop.0+0x47>
80105094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb e8                	jmp    80105087 <argfd.constprop.0+0x47>
8010509f:	90                   	nop

801050a0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801050a0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801050a1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	53                   	push   %ebx
801050a6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801050a9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801050ac:	e8 8f ff ff ff       	call   80105040 <argfd.constprop.0>
801050b1:	85 c0                	test   %eax,%eax
801050b3:	78 1b                	js     801050d0 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
801050b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801050b8:	31 db                	xor    %ebx,%ebx
801050ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    if(proc->ofile[fd] == 0){
801050c0:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
801050c4:	85 c9                	test   %ecx,%ecx
801050c6:	74 18                	je     801050e0 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801050c8:	83 c3 01             	add    $0x1,%ebx
801050cb:	83 fb 10             	cmp    $0x10,%ebx
801050ce:	75 f0                	jne    801050c0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801050d0:	83 c4 24             	add    $0x24,%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
801050d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801050d8:	5b                   	pop    %ebx
801050d9:	5d                   	pop    %ebp
801050da:	c3                   	ret    
801050db:	90                   	nop
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801050e0:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
801050e4:	89 14 24             	mov    %edx,(%esp)
801050e7:	e8 e4 bc ff ff       	call   80100dd0 <filedup>
  return fd;
}
801050ec:	83 c4 24             	add    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
801050ef:	89 d8                	mov    %ebx,%eax
}
801050f1:	5b                   	pop    %ebx
801050f2:	5d                   	pop    %ebp
801050f3:	c3                   	ret    
801050f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105100 <sys_read>:

int
sys_read(void)
{
80105100:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105101:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105103:	89 e5                	mov    %esp,%ebp
80105105:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105108:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010510b:	e8 30 ff ff ff       	call   80105040 <argfd.constprop.0>
80105110:	85 c0                	test   %eax,%eax
80105112:	78 54                	js     80105168 <sys_read+0x68>
80105114:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105117:	89 44 24 04          	mov    %eax,0x4(%esp)
8010511b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105122:	e8 19 fc ff ff       	call   80104d40 <argint>
80105127:	85 c0                	test   %eax,%eax
80105129:	78 3d                	js     80105168 <sys_read+0x68>
8010512b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010512e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105135:	89 44 24 08          	mov    %eax,0x8(%esp)
80105139:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010513c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105140:	e8 3b fc ff ff       	call   80104d80 <argptr>
80105145:	85 c0                	test   %eax,%eax
80105147:	78 1f                	js     80105168 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80105149:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010514c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105153:	89 44 24 04          	mov    %eax,0x4(%esp)
80105157:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010515a:	89 04 24             	mov    %eax,(%esp)
8010515d:	e8 ce bd ff ff       	call   80100f30 <fileread>
}
80105162:	c9                   	leave  
80105163:	c3                   	ret    
80105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
8010516d:	c9                   	leave  
8010516e:	c3                   	ret    
8010516f:	90                   	nop

80105170 <sys_write>:

int
sys_write(void)
{
80105170:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105171:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105173:	89 e5                	mov    %esp,%ebp
80105175:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105178:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010517b:	e8 c0 fe ff ff       	call   80105040 <argfd.constprop.0>
80105180:	85 c0                	test   %eax,%eax
80105182:	78 54                	js     801051d8 <sys_write+0x68>
80105184:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105187:	89 44 24 04          	mov    %eax,0x4(%esp)
8010518b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105192:	e8 a9 fb ff ff       	call   80104d40 <argint>
80105197:	85 c0                	test   %eax,%eax
80105199:	78 3d                	js     801051d8 <sys_write+0x68>
8010519b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010519e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051a5:	89 44 24 08          	mov    %eax,0x8(%esp)
801051a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801051b0:	e8 cb fb ff ff       	call   80104d80 <argptr>
801051b5:	85 c0                	test   %eax,%eax
801051b7:	78 1f                	js     801051d8 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
801051b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051bc:	89 44 24 08          	mov    %eax,0x8(%esp)
801051c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801051c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051ca:	89 04 24             	mov    %eax,(%esp)
801051cd:	e8 fe bd ff ff       	call   80100fd0 <filewrite>
}
801051d2:	c9                   	leave  
801051d3:	c3                   	ret    
801051d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801051d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
801051dd:	c9                   	leave  
801051de:	c3                   	ret    
801051df:	90                   	nop

801051e0 <sys_close>:

int
sys_close(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801051e6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801051e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051ec:	e8 4f fe ff ff       	call   80105040 <argfd.constprop.0>
801051f1:	85 c0                	test   %eax,%eax
801051f3:	78 23                	js     80105218 <sys_close+0x38>
    return -1;
  proc->ofile[fd] = 0;
801051f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051fe:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105205:	00 
  fileclose(f);
80105206:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105209:	89 04 24             	mov    %eax,(%esp)
8010520c:	e8 0f bc ff ff       	call   80100e20 <fileclose>
  return 0;
80105211:	31 c0                	xor    %eax,%eax
}
80105213:	c9                   	leave  
80105214:	c3                   	ret    
80105215:	8d 76 00             	lea    0x0(%esi),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
8010521d:	c9                   	leave  
8010521e:	c3                   	ret    
8010521f:	90                   	nop

80105220 <sys_fstat>:

int
sys_fstat(void)
{
80105220:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105221:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105223:	89 e5                	mov    %esp,%ebp
80105225:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105228:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010522b:	e8 10 fe ff ff       	call   80105040 <argfd.constprop.0>
80105230:	85 c0                	test   %eax,%eax
80105232:	78 34                	js     80105268 <sys_fstat+0x48>
80105234:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105237:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010523e:	00 
8010523f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105243:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010524a:	e8 31 fb ff ff       	call   80104d80 <argptr>
8010524f:	85 c0                	test   %eax,%eax
80105251:	78 15                	js     80105268 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80105253:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105256:	89 44 24 04          	mov    %eax,0x4(%esp)
8010525a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010525d:	89 04 24             	mov    %eax,(%esp)
80105260:	e8 7b bc ff ff       	call   80100ee0 <filestat>
}
80105265:	c9                   	leave  
80105266:	c3                   	ret    
80105267:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
8010526d:	c9                   	leave  
8010526e:	c3                   	ret    
8010526f:	90                   	nop

80105270 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	57                   	push   %edi
80105274:	56                   	push   %esi
80105275:	53                   	push   %ebx
80105276:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105279:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010527c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105280:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105287:	e8 44 fb ff ff       	call   80104dd0 <argstr>
8010528c:	85 c0                	test   %eax,%eax
8010528e:	0f 88 e6 00 00 00    	js     8010537a <sys_link+0x10a>
80105294:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105297:	89 44 24 04          	mov    %eax,0x4(%esp)
8010529b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801052a2:	e8 29 fb ff ff       	call   80104dd0 <argstr>
801052a7:	85 c0                	test   %eax,%eax
801052a9:	0f 88 cb 00 00 00    	js     8010537a <sys_link+0x10a>
    return -1;

  begin_op();
801052af:	e8 cc d8 ff ff       	call   80102b80 <begin_op>
  if((ip = namei(old)) == 0){
801052b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801052b7:	89 04 24             	mov    %eax,(%esp)
801052ba:	e8 21 cc ff ff       	call   80101ee0 <namei>
801052bf:	85 c0                	test   %eax,%eax
801052c1:	89 c3                	mov    %eax,%ebx
801052c3:	0f 84 ac 00 00 00    	je     80105375 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
801052c9:	89 04 24             	mov    %eax,(%esp)
801052cc:	e8 df c3 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
801052d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052d6:	0f 84 91 00 00 00    	je     8010536d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801052dc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801052e1:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801052e4:	89 1c 24             	mov    %ebx,(%esp)
801052e7:	e8 04 c3 ff ff       	call   801015f0 <iupdate>
  iunlock(ip);
801052ec:	89 1c 24             	mov    %ebx,(%esp)
801052ef:	e8 8c c4 ff ff       	call   80101780 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801052f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
801052f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
801052fb:	89 04 24             	mov    %eax,(%esp)
801052fe:	e8 fd cb ff ff       	call   80101f00 <nameiparent>
80105303:	85 c0                	test   %eax,%eax
80105305:	89 c6                	mov    %eax,%esi
80105307:	74 4f                	je     80105358 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80105309:	89 04 24             	mov    %eax,(%esp)
8010530c:	e8 9f c3 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105311:	8b 03                	mov    (%ebx),%eax
80105313:	39 06                	cmp    %eax,(%esi)
80105315:	75 39                	jne    80105350 <sys_link+0xe0>
80105317:	8b 43 04             	mov    0x4(%ebx),%eax
8010531a:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010531e:	89 34 24             	mov    %esi,(%esp)
80105321:	89 44 24 08          	mov    %eax,0x8(%esp)
80105325:	e8 d6 ca ff ff       	call   80101e00 <dirlink>
8010532a:	85 c0                	test   %eax,%eax
8010532c:	78 22                	js     80105350 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010532e:	89 34 24             	mov    %esi,(%esp)
80105331:	e8 ba c5 ff ff       	call   801018f0 <iunlockput>
  iput(ip);
80105336:	89 1c 24             	mov    %ebx,(%esp)
80105339:	e8 82 c4 ff ff       	call   801017c0 <iput>

  end_op();
8010533e:	e8 ad d8 ff ff       	call   80102bf0 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105343:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80105346:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105348:	5b                   	pop    %ebx
80105349:	5e                   	pop    %esi
8010534a:	5f                   	pop    %edi
8010534b:	5d                   	pop    %ebp
8010534c:	c3                   	ret    
8010534d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105350:	89 34 24             	mov    %esi,(%esp)
80105353:	e8 98 c5 ff ff       	call   801018f0 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80105358:	89 1c 24             	mov    %ebx,(%esp)
8010535b:	e8 50 c3 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
80105360:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105365:	89 1c 24             	mov    %ebx,(%esp)
80105368:	e8 83 c2 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
8010536d:	89 1c 24             	mov    %ebx,(%esp)
80105370:	e8 7b c5 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105375:	e8 76 d8 ff ff       	call   80102bf0 <end_op>
  return -1;
}
8010537a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010537d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105382:	5b                   	pop    %ebx
80105383:	5e                   	pop    %esi
80105384:	5f                   	pop    %edi
80105385:	5d                   	pop    %ebp
80105386:	c3                   	ret    
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
80105395:	53                   	push   %ebx
80105396:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105399:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010539c:	89 44 24 04          	mov    %eax,0x4(%esp)
801053a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053a7:	e8 24 fa ff ff       	call   80104dd0 <argstr>
801053ac:	85 c0                	test   %eax,%eax
801053ae:	0f 88 76 01 00 00    	js     8010552a <sys_unlink+0x19a>
    return -1;

  begin_op();
801053b4:	e8 c7 d7 ff ff       	call   80102b80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053b9:	8b 45 c0             	mov    -0x40(%ebp),%eax
801053bc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801053bf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801053c3:	89 04 24             	mov    %eax,(%esp)
801053c6:	e8 35 cb ff ff       	call   80101f00 <nameiparent>
801053cb:	85 c0                	test   %eax,%eax
801053cd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801053d0:	0f 84 4f 01 00 00    	je     80105525 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
801053d6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
801053d9:	89 34 24             	mov    %esi,(%esp)
801053dc:	e8 cf c2 ff ff       	call   801016b0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053e1:	c7 44 24 04 48 7d 10 	movl   $0x80107d48,0x4(%esp)
801053e8:	80 
801053e9:	89 1c 24             	mov    %ebx,(%esp)
801053ec:	e8 7f c7 ff ff       	call   80101b70 <namecmp>
801053f1:	85 c0                	test   %eax,%eax
801053f3:	0f 84 21 01 00 00    	je     8010551a <sys_unlink+0x18a>
801053f9:	c7 44 24 04 47 7d 10 	movl   $0x80107d47,0x4(%esp)
80105400:	80 
80105401:	89 1c 24             	mov    %ebx,(%esp)
80105404:	e8 67 c7 ff ff       	call   80101b70 <namecmp>
80105409:	85 c0                	test   %eax,%eax
8010540b:	0f 84 09 01 00 00    	je     8010551a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105411:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105414:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105418:	89 44 24 08          	mov    %eax,0x8(%esp)
8010541c:	89 34 24             	mov    %esi,(%esp)
8010541f:	e8 7c c7 ff ff       	call   80101ba0 <dirlookup>
80105424:	85 c0                	test   %eax,%eax
80105426:	89 c3                	mov    %eax,%ebx
80105428:	0f 84 ec 00 00 00    	je     8010551a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
8010542e:	89 04 24             	mov    %eax,(%esp)
80105431:	e8 7a c2 ff ff       	call   801016b0 <ilock>

  if(ip->nlink < 1)
80105436:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010543b:	0f 8e 24 01 00 00    	jle    80105565 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105441:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105446:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105449:	74 7d                	je     801054c8 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010544b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105452:	00 
80105453:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010545a:	00 
8010545b:	89 34 24             	mov    %esi,(%esp)
8010545e:	e8 0d f6 ff ff       	call   80104a70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105463:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105466:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010546d:	00 
8010546e:	89 74 24 04          	mov    %esi,0x4(%esp)
80105472:	89 44 24 08          	mov    %eax,0x8(%esp)
80105476:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105479:	89 04 24             	mov    %eax,(%esp)
8010547c:	e8 bf c5 ff ff       	call   80101a40 <writei>
80105481:	83 f8 10             	cmp    $0x10,%eax
80105484:	0f 85 cf 00 00 00    	jne    80105559 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010548a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010548f:	0f 84 a3 00 00 00    	je     80105538 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105495:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105498:	89 04 24             	mov    %eax,(%esp)
8010549b:	e8 50 c4 ff ff       	call   801018f0 <iunlockput>

  ip->nlink--;
801054a0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054a5:	89 1c 24             	mov    %ebx,(%esp)
801054a8:	e8 43 c1 ff ff       	call   801015f0 <iupdate>
  iunlockput(ip);
801054ad:	89 1c 24             	mov    %ebx,(%esp)
801054b0:	e8 3b c4 ff ff       	call   801018f0 <iunlockput>

  end_op();
801054b5:	e8 36 d7 ff ff       	call   80102bf0 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801054ba:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
801054bd:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801054bf:	5b                   	pop    %ebx
801054c0:	5e                   	pop    %esi
801054c1:	5f                   	pop    %edi
801054c2:	5d                   	pop    %ebp
801054c3:	c3                   	ret    
801054c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054c8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801054cc:	0f 86 79 ff ff ff    	jbe    8010544b <sys_unlink+0xbb>
801054d2:	bf 20 00 00 00       	mov    $0x20,%edi
801054d7:	eb 15                	jmp    801054ee <sys_unlink+0x15e>
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054e0:	8d 57 10             	lea    0x10(%edi),%edx
801054e3:	3b 53 58             	cmp    0x58(%ebx),%edx
801054e6:	0f 83 5f ff ff ff    	jae    8010544b <sys_unlink+0xbb>
801054ec:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054ee:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801054f5:	00 
801054f6:	89 7c 24 08          	mov    %edi,0x8(%esp)
801054fa:	89 74 24 04          	mov    %esi,0x4(%esp)
801054fe:	89 1c 24             	mov    %ebx,(%esp)
80105501:	e8 3a c4 ff ff       	call   80101940 <readi>
80105506:	83 f8 10             	cmp    $0x10,%eax
80105509:	75 42                	jne    8010554d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010550b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105510:	74 ce                	je     801054e0 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105512:	89 1c 24             	mov    %ebx,(%esp)
80105515:	e8 d6 c3 ff ff       	call   801018f0 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
8010551a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010551d:	89 04 24             	mov    %eax,(%esp)
80105520:	e8 cb c3 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105525:	e8 c6 d6 ff ff       	call   80102bf0 <end_op>
  return -1;
}
8010552a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
8010552d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105532:	5b                   	pop    %ebx
80105533:	5e                   	pop    %esi
80105534:	5f                   	pop    %edi
80105535:	5d                   	pop    %ebp
80105536:	c3                   	ret    
80105537:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105538:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010553b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105540:	89 04 24             	mov    %eax,(%esp)
80105543:	e8 a8 c0 ff ff       	call   801015f0 <iupdate>
80105548:	e9 48 ff ff ff       	jmp    80105495 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010554d:	c7 04 24 6c 7d 10 80 	movl   $0x80107d6c,(%esp)
80105554:	e8 07 ae ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105559:	c7 04 24 7e 7d 10 80 	movl   $0x80107d7e,(%esp)
80105560:	e8 fb ad ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105565:	c7 04 24 5a 7d 10 80 	movl   $0x80107d5a,(%esp)
8010556c:	e8 ef ad ff ff       	call   80100360 <panic>
80105571:	eb 0d                	jmp    80105580 <sys_open>
80105573:	90                   	nop
80105574:	90                   	nop
80105575:	90                   	nop
80105576:	90                   	nop
80105577:	90                   	nop
80105578:	90                   	nop
80105579:	90                   	nop
8010557a:	90                   	nop
8010557b:	90                   	nop
8010557c:	90                   	nop
8010557d:	90                   	nop
8010557e:	90                   	nop
8010557f:	90                   	nop

80105580 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
80105585:	53                   	push   %ebx
80105586:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105589:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010558c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105590:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105597:	e8 34 f8 ff ff       	call   80104dd0 <argstr>
8010559c:	85 c0                	test   %eax,%eax
8010559e:	0f 88 81 00 00 00    	js     80105625 <sys_open+0xa5>
801055a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055b2:	e8 89 f7 ff ff       	call   80104d40 <argint>
801055b7:	85 c0                	test   %eax,%eax
801055b9:	78 6a                	js     80105625 <sys_open+0xa5>
    return -1;

  begin_op();
801055bb:	e8 c0 d5 ff ff       	call   80102b80 <begin_op>

  if(omode & O_CREATE){
801055c0:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801055c4:	75 72                	jne    80105638 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801055c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055c9:	89 04 24             	mov    %eax,(%esp)
801055cc:	e8 0f c9 ff ff       	call   80101ee0 <namei>
801055d1:	85 c0                	test   %eax,%eax
801055d3:	89 c7                	mov    %eax,%edi
801055d5:	74 49                	je     80105620 <sys_open+0xa0>
      end_op();
      return -1;
    }
    ilock(ip);
801055d7:	89 04 24             	mov    %eax,(%esp)
801055da:	e8 d1 c0 ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055df:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
801055e4:	0f 84 ae 00 00 00    	je     80105698 <sys_open+0x118>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055ea:	e8 71 b7 ff ff       	call   80100d60 <filealloc>
801055ef:	85 c0                	test   %eax,%eax
801055f1:	89 c6                	mov    %eax,%esi
801055f3:	74 23                	je     80105618 <sys_open+0x98>
801055f5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801055fc:	31 db                	xor    %ebx,%ebx
801055fe:	66 90                	xchg   %ax,%ax
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105600:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
80105604:	85 c0                	test   %eax,%eax
80105606:	74 50                	je     80105658 <sys_open+0xd8>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105608:	83 c3 01             	add    $0x1,%ebx
8010560b:	83 fb 10             	cmp    $0x10,%ebx
8010560e:	75 f0                	jne    80105600 <sys_open+0x80>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105610:	89 34 24             	mov    %esi,(%esp)
80105613:	e8 08 b8 ff ff       	call   80100e20 <fileclose>
    iunlockput(ip);
80105618:	89 3c 24             	mov    %edi,(%esp)
8010561b:	e8 d0 c2 ff ff       	call   801018f0 <iunlockput>
    end_op();
80105620:	e8 cb d5 ff ff       	call   80102bf0 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105625:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010562d:	5b                   	pop    %ebx
8010562e:	5e                   	pop    %esi
8010562f:	5f                   	pop    %edi
80105630:	5d                   	pop    %ebp
80105631:	c3                   	ret    
80105632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105638:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010563b:	31 c9                	xor    %ecx,%ecx
8010563d:	ba 02 00 00 00       	mov    $0x2,%edx
80105642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105649:	e8 72 f8 ff ff       	call   80104ec0 <create>
    if(ip == 0){
8010564e:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105650:	89 c7                	mov    %eax,%edi
    if(ip == 0){
80105652:	75 96                	jne    801055ea <sys_open+0x6a>
80105654:	eb ca                	jmp    80105620 <sys_open+0xa0>
80105656:	66 90                	xchg   %ax,%ax
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105658:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010565c:	89 3c 24             	mov    %edi,(%esp)
8010565f:	e8 1c c1 ff ff       	call   80101780 <iunlock>
  end_op();
80105664:	e8 87 d5 ff ff       	call   80102bf0 <end_op>

  f->type = FD_INODE;
80105669:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010566f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105672:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80105675:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
8010567c:	89 d0                	mov    %edx,%eax
8010567e:	83 e0 01             	and    $0x1,%eax
80105681:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105684:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105687:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
8010568a:	89 d8                	mov    %ebx,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010568c:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
}
80105690:	83 c4 2c             	add    $0x2c,%esp
80105693:	5b                   	pop    %ebx
80105694:	5e                   	pop    %esi
80105695:	5f                   	pop    %edi
80105696:	5d                   	pop    %ebp
80105697:	c3                   	ret    
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105698:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010569b:	85 d2                	test   %edx,%edx
8010569d:	0f 84 47 ff ff ff    	je     801055ea <sys_open+0x6a>
801056a3:	e9 70 ff ff ff       	jmp    80105618 <sys_open+0x98>
801056a8:	90                   	nop
801056a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056b0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056b6:	e8 c5 d4 ff ff       	call   80102b80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056be:	89 44 24 04          	mov    %eax,0x4(%esp)
801056c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056c9:	e8 02 f7 ff ff       	call   80104dd0 <argstr>
801056ce:	85 c0                	test   %eax,%eax
801056d0:	78 2e                	js     80105700 <sys_mkdir+0x50>
801056d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d5:	31 c9                	xor    %ecx,%ecx
801056d7:	ba 01 00 00 00       	mov    $0x1,%edx
801056dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056e3:	e8 d8 f7 ff ff       	call   80104ec0 <create>
801056e8:	85 c0                	test   %eax,%eax
801056ea:	74 14                	je     80105700 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056ec:	89 04 24             	mov    %eax,(%esp)
801056ef:	e8 fc c1 ff ff       	call   801018f0 <iunlockput>
  end_op();
801056f4:	e8 f7 d4 ff ff       	call   80102bf0 <end_op>
  return 0;
801056f9:	31 c0                	xor    %eax,%eax
}
801056fb:	c9                   	leave  
801056fc:	c3                   	ret    
801056fd:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105700:	e8 eb d4 ff ff       	call   80102bf0 <end_op>
    return -1;
80105705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010570a:	c9                   	leave  
8010570b:	c3                   	ret    
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_mknod>:

int
sys_mknod(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105716:	e8 65 d4 ff ff       	call   80102b80 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010571b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010571e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105722:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105729:	e8 a2 f6 ff ff       	call   80104dd0 <argstr>
8010572e:	85 c0                	test   %eax,%eax
80105730:	78 5e                	js     80105790 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105732:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105735:	89 44 24 04          	mov    %eax,0x4(%esp)
80105739:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105740:	e8 fb f5 ff ff       	call   80104d40 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105745:	85 c0                	test   %eax,%eax
80105747:	78 47                	js     80105790 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105749:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010574c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105750:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105757:	e8 e4 f5 ff ff       	call   80104d40 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010575c:	85 c0                	test   %eax,%eax
8010575e:	78 30                	js     80105790 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105760:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105764:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105769:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010576d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105770:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105773:	e8 48 f7 ff ff       	call   80104ec0 <create>
80105778:	85 c0                	test   %eax,%eax
8010577a:	74 14                	je     80105790 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010577c:	89 04 24             	mov    %eax,(%esp)
8010577f:	e8 6c c1 ff ff       	call   801018f0 <iunlockput>
  end_op();
80105784:	e8 67 d4 ff ff       	call   80102bf0 <end_op>
  return 0;
80105789:	31 c0                	xor    %eax,%eax
}
8010578b:	c9                   	leave  
8010578c:	c3                   	ret    
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105790:	e8 5b d4 ff ff       	call   80102bf0 <end_op>
    return -1;
80105795:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010579a:	c9                   	leave  
8010579b:	c3                   	ret    
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_chdir>:

int
sys_chdir(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	53                   	push   %ebx
801057a4:	83 ec 24             	sub    $0x24,%esp
  char *path;
  struct inode *ip;

  begin_op();
801057a7:	e8 d4 d3 ff ff       	call   80102b80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057af:	89 44 24 04          	mov    %eax,0x4(%esp)
801057b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057ba:	e8 11 f6 ff ff       	call   80104dd0 <argstr>
801057bf:	85 c0                	test   %eax,%eax
801057c1:	78 5a                	js     8010581d <sys_chdir+0x7d>
801057c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c6:	89 04 24             	mov    %eax,(%esp)
801057c9:	e8 12 c7 ff ff       	call   80101ee0 <namei>
801057ce:	85 c0                	test   %eax,%eax
801057d0:	89 c3                	mov    %eax,%ebx
801057d2:	74 49                	je     8010581d <sys_chdir+0x7d>
    end_op();
    return -1;
  }
  ilock(ip);
801057d4:	89 04 24             	mov    %eax,(%esp)
801057d7:	e8 d4 be ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
801057dc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
801057e1:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
801057e4:	75 32                	jne    80105818 <sys_chdir+0x78>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057e6:	e8 95 bf ff ff       	call   80101780 <iunlock>
  iput(proc->cwd);
801057eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057f1:	8b 40 68             	mov    0x68(%eax),%eax
801057f4:	89 04 24             	mov    %eax,(%esp)
801057f7:	e8 c4 bf ff ff       	call   801017c0 <iput>
  end_op();
801057fc:	e8 ef d3 ff ff       	call   80102bf0 <end_op>
  proc->cwd = ip;
80105801:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105807:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
}
8010580a:	83 c4 24             	add    $0x24,%esp
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
8010580d:	31 c0                	xor    %eax,%eax
}
8010580f:	5b                   	pop    %ebx
80105810:	5d                   	pop    %ebp
80105811:	c3                   	ret    
80105812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105818:	e8 d3 c0 ff ff       	call   801018f0 <iunlockput>
    end_op();
8010581d:	e8 ce d3 ff ff       	call   80102bf0 <end_op>
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
80105822:	83 c4 24             	add    $0x24,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
80105825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
  return 0;
}
8010582a:	5b                   	pop    %ebx
8010582b:	5d                   	pop    %ebp
8010582c:	c3                   	ret    
8010582d:	8d 76 00             	lea    0x0(%esi),%esi

80105830 <sys_exec>:

int
sys_exec(void)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	57                   	push   %edi
80105834:	56                   	push   %esi
80105835:	53                   	push   %ebx
80105836:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010583c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105842:	89 44 24 04          	mov    %eax,0x4(%esp)
80105846:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010584d:	e8 7e f5 ff ff       	call   80104dd0 <argstr>
80105852:	85 c0                	test   %eax,%eax
80105854:	0f 88 84 00 00 00    	js     801058de <sys_exec+0xae>
8010585a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105860:	89 44 24 04          	mov    %eax,0x4(%esp)
80105864:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010586b:	e8 d0 f4 ff ff       	call   80104d40 <argint>
80105870:	85 c0                	test   %eax,%eax
80105872:	78 6a                	js     801058de <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105874:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010587a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010587c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105883:	00 
80105884:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010588a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105891:	00 
80105892:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105898:	89 04 24             	mov    %eax,(%esp)
8010589b:	e8 d0 f1 ff ff       	call   80104a70 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058a0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801058aa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801058ad:	89 04 24             	mov    %eax,(%esp)
801058b0:	e8 0b f4 ff ff       	call   80104cc0 <fetchint>
801058b5:	85 c0                	test   %eax,%eax
801058b7:	78 25                	js     801058de <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801058b9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058bf:	85 c0                	test   %eax,%eax
801058c1:	74 2d                	je     801058f0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058c3:	89 74 24 04          	mov    %esi,0x4(%esp)
801058c7:	89 04 24             	mov    %eax,(%esp)
801058ca:	e8 21 f4 ff ff       	call   80104cf0 <fetchstr>
801058cf:	85 c0                	test   %eax,%eax
801058d1:	78 0b                	js     801058de <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801058d3:	83 c3 01             	add    $0x1,%ebx
801058d6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801058d9:	83 fb 20             	cmp    $0x20,%ebx
801058dc:	75 c2                	jne    801058a0 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801058de:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801058e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801058e9:	5b                   	pop    %ebx
801058ea:	5e                   	pop    %esi
801058eb:	5f                   	pop    %edi
801058ec:	5d                   	pop    %ebp
801058ed:	c3                   	ret    
801058ee:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801058f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801058f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801058fa:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105900:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105907:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010590b:	89 04 24             	mov    %eax,(%esp)
8010590e:	e8 9d b0 ff ff       	call   801009b0 <exec>
}
80105913:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105919:	5b                   	pop    %ebx
8010591a:	5e                   	pop    %esi
8010591b:	5f                   	pop    %edi
8010591c:	5d                   	pop    %ebp
8010591d:	c3                   	ret    
8010591e:	66 90                	xchg   %ax,%ax

80105920 <sys_pipe>:

int
sys_pipe(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	57                   	push   %edi
80105924:	56                   	push   %esi
80105925:	53                   	push   %ebx
80105926:	83 ec 2c             	sub    $0x2c,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105929:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010592c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105933:	00 
80105934:	89 44 24 04          	mov    %eax,0x4(%esp)
80105938:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010593f:	e8 3c f4 ff ff       	call   80104d80 <argptr>
80105944:	85 c0                	test   %eax,%eax
80105946:	78 7a                	js     801059c2 <sys_pipe+0xa2>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105948:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010594b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010594f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105952:	89 04 24             	mov    %eax,(%esp)
80105955:	e8 56 d9 ff ff       	call   801032b0 <pipealloc>
8010595a:	85 c0                	test   %eax,%eax
8010595c:	78 64                	js     801059c2 <sys_pipe+0xa2>
8010595e:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105965:	31 c0                	xor    %eax,%eax
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105967:	8b 5d e0             	mov    -0x20(%ebp),%ebx
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
8010596a:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
8010596e:	85 d2                	test   %edx,%edx
80105970:	74 16                	je     80105988 <sys_pipe+0x68>
80105972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105978:	83 c0 01             	add    $0x1,%eax
8010597b:	83 f8 10             	cmp    $0x10,%eax
8010597e:	74 2f                	je     801059af <sys_pipe+0x8f>
    if(proc->ofile[fd] == 0){
80105980:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105984:	85 d2                	test   %edx,%edx
80105986:	75 f0                	jne    80105978 <sys_pipe+0x58>
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105988:	8b 7d e4             	mov    -0x1c(%ebp),%edi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
8010598b:	8d 70 08             	lea    0x8(%eax),%esi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010598e:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105990:	89 5c b1 08          	mov    %ebx,0x8(%ecx,%esi,4)
80105994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105998:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
8010599d:	74 31                	je     801059d0 <sys_pipe+0xb0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010599f:	83 c2 01             	add    $0x1,%edx
801059a2:	83 fa 10             	cmp    $0x10,%edx
801059a5:	75 f1                	jne    80105998 <sys_pipe+0x78>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
801059a7:	c7 44 b1 08 00 00 00 	movl   $0x0,0x8(%ecx,%esi,4)
801059ae:	00 
    fileclose(rf);
801059af:	89 1c 24             	mov    %ebx,(%esp)
801059b2:	e8 69 b4 ff ff       	call   80100e20 <fileclose>
    fileclose(wf);
801059b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801059ba:	89 04 24             	mov    %eax,(%esp)
801059bd:	e8 5e b4 ff ff       	call   80100e20 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801059c2:	83 c4 2c             	add    $0x2c,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801059c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801059ca:	5b                   	pop    %ebx
801059cb:	5e                   	pop    %esi
801059cc:	5f                   	pop    %edi
801059cd:	5d                   	pop    %ebp
801059ce:	c3                   	ret    
801059cf:	90                   	nop
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801059d0:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801059d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
801059d7:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
801059d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059dc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801059df:	83 c4 2c             	add    $0x2c,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801059e2:	31 c0                	xor    %eax,%eax
}
801059e4:	5b                   	pop    %ebx
801059e5:	5e                   	pop    %esi
801059e6:	5f                   	pop    %edi
801059e7:	5d                   	pop    %ebp
801059e8:	c3                   	ret    
801059e9:	66 90                	xchg   %ax,%ax
801059eb:	66 90                	xchg   %ax,%ax
801059ed:	66 90                	xchg   %ax,%ax
801059ef:	90                   	nop

801059f0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801059f3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801059f4:	e9 c7 e0 ff ff       	jmp    80103ac0 <fork>
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a00 <sys_exit>:
}

int
sys_exit(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a06:	e8 b5 e5 ff ff       	call   80103fc0 <exit>
  return 0;  // not reached
}
80105a0b:	31 c0                	xor    %eax,%eax
80105a0d:	c9                   	leave  
80105a0e:	c3                   	ret    
80105a0f:	90                   	nop

80105a10 <sys_wait>:

int
sys_wait(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105a13:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105a14:	e9 07 e9 ff ff       	jmp    80104320 <wait>
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_kill>:
}

int
sys_kill(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a29:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a34:	e8 07 f3 ff ff       	call   80104d40 <argint>
80105a39:	85 c0                	test   %eax,%eax
80105a3b:	78 13                	js     80105a50 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a40:	89 04 24             	mov    %eax,(%esp)
80105a43:	e8 78 ea ff ff       	call   801044c0 <kill>
}
80105a48:	c9                   	leave  
80105a49:	c3                   	ret    
80105a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105a55:	c9                   	leave  
80105a56:	c3                   	ret    
80105a57:	89 f6                	mov    %esi,%esi
80105a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a60 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105a60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105a66:	55                   	push   %ebp
80105a67:	89 e5                	mov    %esp,%ebp
  return proc->pid;
}
80105a69:	5d                   	pop    %ebp
}

int
sys_getpid(void)
{
  return proc->pid;
80105a6a:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a6d:	c3                   	ret    
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	53                   	push   %ebx
80105a74:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a77:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a7a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a85:	e8 b6 f2 ff ff       	call   80104d40 <argint>
80105a8a:	85 c0                	test   %eax,%eax
80105a8c:	78 22                	js     80105ab0 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
80105a8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
80105a94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
80105a97:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a99:	89 14 24             	mov    %edx,(%esp)
80105a9c:	e8 9f df ff ff       	call   80103a40 <growproc>
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	78 0b                	js     80105ab0 <sys_sbrk+0x40>
    return -1;
  return addr;
80105aa5:	89 d8                	mov    %ebx,%eax
}
80105aa7:	83 c4 24             	add    $0x24,%esp
80105aaa:	5b                   	pop    %ebx
80105aab:	5d                   	pop    %ebp
80105aac:	c3                   	ret    
80105aad:	8d 76 00             	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab5:	eb f0                	jmp    80105aa7 <sys_sbrk+0x37>
80105ab7:	89 f6                	mov    %esi,%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ac0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	53                   	push   %ebx
80105ac4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ac7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105aca:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ace:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ad5:	e8 66 f2 ff ff       	call   80104d40 <argint>
80105ada:	85 c0                	test   %eax,%eax
80105adc:	78 7e                	js     80105b5c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
80105ade:	c7 04 24 00 64 11 80 	movl   $0x80116400,(%esp)
80105ae5:	e8 06 ee ff ff       	call   801048f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105aea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105aed:	8b 1d 40 6c 11 80    	mov    0x80116c40,%ebx
  while(ticks - ticks0 < n){
80105af3:	85 d2                	test   %edx,%edx
80105af5:	75 29                	jne    80105b20 <sys_sleep+0x60>
80105af7:	eb 4f                	jmp    80105b48 <sys_sleep+0x88>
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b00:	c7 44 24 04 00 64 11 	movl   $0x80116400,0x4(%esp)
80105b07:	80 
80105b08:	c7 04 24 40 6c 11 80 	movl   $0x80116c40,(%esp)
80105b0f:	e8 4c e7 ff ff       	call   80104260 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b14:	a1 40 6c 11 80       	mov    0x80116c40,%eax
80105b19:	29 d8                	sub    %ebx,%eax
80105b1b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b1e:	73 28                	jae    80105b48 <sys_sleep+0x88>
    if(proc->killed){
80105b20:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b26:	8b 40 24             	mov    0x24(%eax),%eax
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	74 d3                	je     80105b00 <sys_sleep+0x40>
      release(&tickslock);
80105b2d:	c7 04 24 00 64 11 80 	movl   $0x80116400,(%esp)
80105b34:	e8 e7 ee ff ff       	call   80104a20 <release>
      return -1;
80105b39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105b3e:	83 c4 24             	add    $0x24,%esp
80105b41:	5b                   	pop    %ebx
80105b42:	5d                   	pop    %ebp
80105b43:	c3                   	ret    
80105b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105b48:	c7 04 24 00 64 11 80 	movl   $0x80116400,(%esp)
80105b4f:	e8 cc ee ff ff       	call   80104a20 <release>
  return 0;
}
80105b54:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
80105b57:	31 c0                	xor    %eax,%eax
}
80105b59:	5b                   	pop    %ebx
80105b5a:	5d                   	pop    %ebp
80105b5b:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105b5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b61:	eb db                	jmp    80105b3e <sys_sleep+0x7e>
80105b63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b70 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	53                   	push   %ebx
80105b74:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105b77:	c7 04 24 00 64 11 80 	movl   $0x80116400,(%esp)
80105b7e:	e8 6d ed ff ff       	call   801048f0 <acquire>
  xticks = ticks;
80105b83:	8b 1d 40 6c 11 80    	mov    0x80116c40,%ebx
  release(&tickslock);
80105b89:	c7 04 24 00 64 11 80 	movl   $0x80116400,(%esp)
80105b90:	e8 8b ee ff ff       	call   80104a20 <release>
  return xticks;
}
80105b95:	83 c4 14             	add    $0x14,%esp
80105b98:	89 d8                	mov    %ebx,%eax
80105b9a:	5b                   	pop    %ebx
80105b9b:	5d                   	pop    %ebp
80105b9c:	c3                   	ret    
80105b9d:	66 90                	xchg   %ax,%ax
80105b9f:	90                   	nop

80105ba0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80105ba0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ba1:	ba 43 00 00 00       	mov    $0x43,%edx
80105ba6:	89 e5                	mov    %esp,%ebp
80105ba8:	b8 34 00 00 00       	mov    $0x34,%eax
80105bad:	83 ec 18             	sub    $0x18,%esp
80105bb0:	ee                   	out    %al,(%dx)
80105bb1:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
80105bb6:	b2 40                	mov    $0x40,%dl
80105bb8:	ee                   	out    %al,(%dx)
80105bb9:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105bbe:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105bbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105bc6:	e8 25 d6 ff ff       	call   801031f0 <picenable>
}
80105bcb:	c9                   	leave  
80105bcc:	c3                   	ret    

80105bcd <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105bcd:	1e                   	push   %ds
  pushl %es
80105bce:	06                   	push   %es
  pushl %fs
80105bcf:	0f a0                	push   %fs
  pushl %gs
80105bd1:	0f a8                	push   %gs
  pushal
80105bd3:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105bd4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105bd8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105bda:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80105bdc:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105be0:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105be2:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105be4:	54                   	push   %esp
  call trap
80105be5:	e8 16 01 00 00       	call   80105d00 <trap>
  addl $4, %esp
80105bea:	83 c4 04             	add    $0x4,%esp

80105bed <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105bed:	61                   	popa   
  popl %gs
80105bee:	0f a9                	pop    %gs
  popl %fs
80105bf0:	0f a1                	pop    %fs
  popl %es
80105bf2:	07                   	pop    %es
  popl %ds
80105bf3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bf4:	83 c4 08             	add    $0x8,%esp
  iret
80105bf7:	cf                   	iret   
80105bf8:	66 90                	xchg   %ax,%ax
80105bfa:	66 90                	xchg   %ax,%ax
80105bfc:	66 90                	xchg   %ax,%ax
80105bfe:	66 90                	xchg   %ax,%ax

80105c00 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105c00:	31 c0                	xor    %eax,%eax
80105c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c08:	8b 14 85 10 b0 10 80 	mov    -0x7fef4ff0(,%eax,4),%edx
80105c0f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105c14:	66 89 0c c5 42 64 11 	mov    %cx,-0x7fee9bbe(,%eax,8)
80105c1b:	80 
80105c1c:	c6 04 c5 44 64 11 80 	movb   $0x0,-0x7fee9bbc(,%eax,8)
80105c23:	00 
80105c24:	c6 04 c5 45 64 11 80 	movb   $0x8e,-0x7fee9bbb(,%eax,8)
80105c2b:	8e 
80105c2c:	66 89 14 c5 40 64 11 	mov    %dx,-0x7fee9bc0(,%eax,8)
80105c33:	80 
80105c34:	c1 ea 10             	shr    $0x10,%edx
80105c37:	66 89 14 c5 46 64 11 	mov    %dx,-0x7fee9bba(,%eax,8)
80105c3e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105c3f:	83 c0 01             	add    $0x1,%eax
80105c42:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c47:	75 bf                	jne    80105c08 <tvinit+0x8>
extern void increase_MLFQ_tick_used(void);    // in proc.c
extern void increase_stride_tick_used(void);  // in proc.c

void
tvinit(void)
{
80105c49:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c4a:	ba 08 00 00 00       	mov    $0x8,%edx
extern void increase_MLFQ_tick_used(void);    // in proc.c
extern void increase_stride_tick_used(void);  // in proc.c

void
tvinit(void)
{
80105c4f:	89 e5                	mov    %esp,%ebp
80105c51:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c54:	a1 10 b1 10 80       	mov    0x8010b110,%eax
  SETGATE(idt[T_USER_INT], 1, SEG_KCODE<<3, vectors[T_USER_INT], DPL_USER);
80105c59:	b9 08 00 00 00       	mov    $0x8,%ecx

  initlock(&tickslock, "time");
80105c5e:	c7 44 24 04 8d 7d 10 	movl   $0x80107d8d,0x4(%esp)
80105c65:	80 
80105c66:	c7 04 24 00 64 11 80 	movl   $0x80116400,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c6d:	66 a3 40 66 11 80    	mov    %ax,0x80116640
80105c73:	c1 e8 10             	shr    $0x10,%eax
80105c76:	66 a3 46 66 11 80    	mov    %ax,0x80116646
  SETGATE(idt[T_USER_INT], 1, SEG_KCODE<<3, vectors[T_USER_INT], DPL_USER);
80105c7c:	a1 10 b2 10 80       	mov    0x8010b210,%eax
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c81:	66 89 15 42 66 11 80 	mov    %dx,0x80116642
80105c88:	c6 05 44 66 11 80 00 	movb   $0x0,0x80116644
80105c8f:	c6 05 45 66 11 80 ef 	movb   $0xef,0x80116645
  SETGATE(idt[T_USER_INT], 1, SEG_KCODE<<3, vectors[T_USER_INT], DPL_USER);
80105c96:	66 a3 40 68 11 80    	mov    %ax,0x80116840
80105c9c:	c1 e8 10             	shr    $0x10,%eax
80105c9f:	66 89 0d 42 68 11 80 	mov    %cx,0x80116842
80105ca6:	c6 05 44 68 11 80 00 	movb   $0x0,0x80116844
80105cad:	c6 05 45 68 11 80 ef 	movb   $0xef,0x80116845
80105cb4:	66 a3 46 68 11 80    	mov    %ax,0x80116846

  initlock(&tickslock, "time");
80105cba:	e8 b1 eb ff ff       	call   80104870 <initlock>
}
80105cbf:	c9                   	leave  
80105cc0:	c3                   	ret    
80105cc1:	eb 0d                	jmp    80105cd0 <idtinit>
80105cc3:	90                   	nop
80105cc4:	90                   	nop
80105cc5:	90                   	nop
80105cc6:	90                   	nop
80105cc7:	90                   	nop
80105cc8:	90                   	nop
80105cc9:	90                   	nop
80105cca:	90                   	nop
80105ccb:	90                   	nop
80105ccc:	90                   	nop
80105ccd:	90                   	nop
80105cce:	90                   	nop
80105ccf:	90                   	nop

80105cd0 <idtinit>:

void
idtinit(void)
{
80105cd0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105cd1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105cd6:	89 e5                	mov    %esp,%ebp
80105cd8:	83 ec 10             	sub    $0x10,%esp
80105cdb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cdf:	b8 40 64 11 80       	mov    $0x80116440,%eax
80105ce4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ce8:	c1 e8 10             	shr    $0x10,%eax
80105ceb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105cef:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105cf2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105cf5:	c9                   	leave  
80105cf6:	c3                   	ret    
80105cf7:	89 f6                	mov    %esi,%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d00 <trap>:
  * } */

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	57                   	push   %edi
80105d04:	56                   	push   %esi
80105d05:	53                   	push   %ebx
80105d06:	83 ec 2c             	sub    $0x2c,%esp
80105d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105d0c:	8b 43 30             	mov    0x30(%ebx),%eax
80105d0f:	83 f8 40             	cmp    $0x40,%eax
80105d12:	74 1c                	je     80105d30 <trap+0x30>
    if(proc->killed)
      exit();
    return;
  }

  if(tf->trapno == T_USER_INT){
80105d14:	3d 80 00 00 00       	cmp    $0x80,%eax
80105d19:	74 45                	je     80105d60 <trap+0x60>
      cprintf("user interrupt 128 called!\n");
      exit();
    return;
  }

  switch(tf->trapno){
80105d1b:	83 e8 20             	sub    $0x20,%eax
80105d1e:	83 f8 1f             	cmp    $0x1f,%eax
80105d21:	0f 87 49 01 00 00    	ja     80105e70 <trap+0x170>
80105d27:	ff 24 85 50 7e 10 80 	jmp    *-0x7fef81b0(,%eax,4)
80105d2e:	66 90                	xchg   %ax,%ax
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105d30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d36:	8b 50 24             	mov    0x24(%eax),%edx
80105d39:	85 d2                	test   %edx,%edx
80105d3b:	0f 85 1f 01 00 00    	jne    80105e60 <trap+0x160>
      exit();
    proc->tf = tf;
80105d41:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d44:	e8 07 f1 ff ff       	call   80104e50 <syscall>
    if(proc->killed)
80105d49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d4f:	8b 78 24             	mov    0x24(%eax),%edi
80105d52:	85 ff                	test   %edi,%edi
80105d54:	75 16                	jne    80105d6c <trap+0x6c>
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105d56:	83 c4 2c             	add    $0x2c,%esp
80105d59:	5b                   	pop    %ebx
80105d5a:	5e                   	pop    %esi
80105d5b:	5f                   	pop    %edi
80105d5c:	5d                   	pop    %ebp
80105d5d:	c3                   	ret    
80105d5e:	66 90                	xchg   %ax,%ax
      exit();
    return;
  }

  if(tf->trapno == T_USER_INT){
      cprintf("user interrupt 128 called!\n");
80105d60:	c7 04 24 92 7d 10 80 	movl   $0x80107d92,(%esp)
80105d67:	e8 e4 a8 ff ff       	call   80100650 <cprintf>
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105d6c:	83 c4 2c             	add    $0x2c,%esp
80105d6f:	5b                   	pop    %ebx
80105d70:	5e                   	pop    %esi
80105d71:	5f                   	pop    %edi
80105d72:	5d                   	pop    %ebp
    return;
  }

  if(tf->trapno == T_USER_INT){
      cprintf("user interrupt 128 called!\n");
      exit();
80105d73:	e9 48 e2 ff ff       	jmp    80103fc0 <exit>
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105d78:	e8 d3 c9 ff ff       	call   80102750 <cpunum>
80105d7d:	85 c0                	test   %eax,%eax
80105d7f:	0f 84 fb 01 00 00    	je     80105f80 <trap+0x280>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105d85:	e8 66 ca ff ff       	call   801027f0 <lapiceoi>
80105d8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105d90:	85 c0                	test   %eax,%eax
80105d92:	74 0b                	je     80105d9f <trap+0x9f>
80105d94:	8b 48 24             	mov    0x24(%eax),%ecx
80105d97:	85 c9                	test   %ecx,%ecx
80105d99:	0f 85 3d 01 00 00    	jne    80105edc <trap+0x1dc>
  // If interrupts were on while locks held, would need to check nlock.



  // Design Document 1-1-2-5. Priority boost
  if (get_MLFQ_tick_used() >= 100) {
80105d9f:	e8 bc da ff ff       	call   80103860 <get_MLFQ_tick_used>
80105da4:	83 f8 63             	cmp    $0x63,%eax
80105da7:	0f 8f 4b 01 00 00    	jg     80105ef8 <trap+0x1f8>
#endif
    priority_boost();
  }


  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
80105dad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105db3:	85 c0                	test   %eax,%eax
80105db5:	74 9f                	je     80105d56 <trap+0x56>
80105db7:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105dbb:	0f 84 4f 01 00 00    	je     80105f10 <trap+0x210>
      yield();
    }
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105dc1:	8b 40 24             	mov    0x24(%eax),%eax
80105dc4:	85 c0                	test   %eax,%eax
80105dc6:	74 8e                	je     80105d56 <trap+0x56>
80105dc8:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105dcc:	83 e0 03             	and    $0x3,%eax
80105dcf:	66 83 f8 03          	cmp    $0x3,%ax
80105dd3:	74 97                	je     80105d6c <trap+0x6c>
    exit();
}
80105dd5:	83 c4 2c             	add    $0x2c,%esp
80105dd8:	5b                   	pop    %ebx
80105dd9:	5e                   	pop    %esi
80105dda:	5f                   	pop    %edi
80105ddb:	5d                   	pop    %ebp
80105ddc:	c3                   	ret    
80105ddd:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105de0:	e8 db c7 ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
80105de5:	e8 06 ca ff ff       	call   801027f0 <lapiceoi>
80105dea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105df0:	eb 9e                	jmp    80105d90 <trap+0x90>
80105df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105df8:	e8 33 03 00 00       	call   80106130 <uartintr>
    lapiceoi();
80105dfd:	e8 ee c9 ff ff       	call   801027f0 <lapiceoi>
80105e02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105e08:	eb 86                	jmp    80105d90 <trap+0x90>
80105e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e10:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e13:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e17:	e8 34 c9 ff ff       	call   80102750 <cpunum>
80105e1c:	c7 04 24 b4 7d 10 80 	movl   $0x80107db4,(%esp)
80105e23:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105e27:	89 74 24 08          	mov    %esi,0x8(%esp)
80105e2b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e2f:	e8 1c a8 ff ff       	call   80100650 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80105e34:	e8 b7 c9 ff ff       	call   801027f0 <lapiceoi>
80105e39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105e3f:	e9 4c ff ff ff       	jmp    80105d90 <trap+0x90>
80105e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105e48:	e8 23 c2 ff ff       	call   80102070 <ideintr>
    lapiceoi();
80105e4d:	e8 9e c9 ff ff       	call   801027f0 <lapiceoi>
80105e52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    break;
80105e58:	e9 33 ff ff ff       	jmp    80105d90 <trap+0x90>
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105e60:	e8 5b e1 ff ff       	call   80103fc0 <exit>
80105e65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e6b:	e9 d1 fe ff ff       	jmp    80105d41 <trap+0x41>
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80105e70:	65 8b 35 04 00 00 00 	mov    %gs:0x4,%esi
80105e77:	85 f6                	test   %esi,%esi
80105e79:	0f 84 46 01 00 00    	je     80105fc5 <trap+0x2c5>
80105e7f:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105e83:	0f 84 3c 01 00 00    	je     80105fc5 <trap+0x2c5>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e89:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e8c:	8b 73 38             	mov    0x38(%ebx),%esi
80105e8f:	e8 bc c8 ff ff       	call   80102750 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105e94:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e9b:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
80105e9f:	89 74 24 18          	mov    %esi,0x18(%esp)
80105ea3:	89 44 24 14          	mov    %eax,0x14(%esp)
80105ea7:	8b 43 34             	mov    0x34(%ebx),%eax
80105eaa:	89 44 24 10          	mov    %eax,0x10(%esp)
80105eae:	8b 43 30             	mov    0x30(%ebx),%eax
80105eb1:	89 44 24 0c          	mov    %eax,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
80105eb5:	8d 42 6c             	lea    0x6c(%edx),%eax
80105eb8:	89 44 24 08          	mov    %eax,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ebc:	8b 42 10             	mov    0x10(%edx),%eax
80105ebf:	c7 04 24 0c 7e 10 80 	movl   $0x80107e0c,(%esp)
80105ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eca:	e8 81 a7 ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
80105ecf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ed5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105edc:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ee0:	83 e0 03             	and    $0x3,%eax
80105ee3:	66 83 f8 03          	cmp    $0x3,%ax
80105ee7:	0f 85 b2 fe ff ff    	jne    80105d9f <trap+0x9f>
    exit();
80105eed:	e8 ce e0 ff ff       	call   80103fc0 <exit>
80105ef2:	e9 a8 fe ff ff       	jmp    80105d9f <trap+0x9f>
80105ef7:	90                   	nop
80105ef8:	90                   	nop
80105ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  // Design Document 1-1-2-5. Priority boost
  if (get_MLFQ_tick_used() >= 100) {
#ifdef MJ_DEBUGGING
    cprintf("\n\n*** Priority Boost ***\n\n");
#endif
    priority_boost();
80105f00:	e8 0b e7 ff ff       	call   80104610 <priority_boost>
80105f05:	e9 a3 fe ff ff       	jmp    80105dad <trap+0xad>
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }


  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
80105f10:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105f14:	0f 85 a7 fe ff ff    	jne    80105dc1 <trap+0xc1>
    // Design Document 1-1-2-2.
    proc->tick_used++;
    proc->time_quantum_used++;

    if(proc->cpu_share == 0) {
80105f1a:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
  }


  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER) {
    // Design Document 1-1-2-2.
    proc->tick_used++;
80105f20:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
    proc->time_quantum_used++;
80105f24:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)

    if(proc->cpu_share == 0) {
80105f2b:	85 d2                	test   %edx,%edx
80105f2d:	0f 85 7d 00 00 00    	jne    80105fb0 <trap+0x2b0>
      increase_MLFQ_tick_used();
80105f33:	e8 38 d9 ff ff       	call   80103870 <increase_MLFQ_tick_used>
          tick_used: %d\n\
          time_quantum_used: %d\n",proc->pid, tf->trapno, ticks,get_MLFQ_tick_used() ,proc->tick_used, proc->time_quantum_used);
#endif

    // yield if it uses whole time quantum
    if(proc->time_quantum_used >= get_time_quantum()) {
80105f38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f3e:	8b b0 80 00 00 00    	mov    0x80(%eax),%esi
80105f44:	e8 e7 d8 ff ff       	call   80103830 <get_time_quantum>
80105f49:	39 c6                	cmp    %eax,%esi
80105f4b:	7c 20                	jl     80105f6d <trap+0x26d>
      cprintf("**********************************\n");
#endif
      

      // Design Document 1-1-2-5. Moving a process to the lower level
      if (proc->level_of_MLFQ < NMLFQ - 1) {
80105f4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f53:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80105f59:	83 fa 01             	cmp    $0x1,%edx
80105f5c:	7e 5c                	jle    80105fba <trap+0x2ba>
        proc->level_of_MLFQ++;
      }

      // Design Document 1-1-2-2
      proc->time_quantum_used = 0;
80105f5e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80105f65:	00 00 00 
      yield();
80105f68:	e8 a3 e2 ff ff       	call   80104210 <yield>
    }
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105f6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105f73:	85 c0                	test   %eax,%eax
80105f75:	0f 85 46 fe ff ff    	jne    80105dc1 <trap+0xc1>
80105f7b:	e9 d6 fd ff ff       	jmp    80105d56 <trap+0x56>
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105f80:	c7 04 24 00 64 11 80 	movl   $0x80116400,(%esp)
80105f87:	e8 64 e9 ff ff       	call   801048f0 <acquire>
      ticks++;
      wakeup(&ticks);
80105f8c:	c7 04 24 40 6c 11 80 	movl   $0x80116c40,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80105f93:	83 05 40 6c 11 80 01 	addl   $0x1,0x80116c40
      wakeup(&ticks);
80105f9a:	e8 b1 e4 ff ff       	call   80104450 <wakeup>
      release(&tickslock);
80105f9f:	c7 04 24 00 64 11 80 	movl   $0x80116400,(%esp)
80105fa6:	e8 75 ea ff ff       	call   80104a20 <release>
80105fab:	e9 d5 fd ff ff       	jmp    80105d85 <trap+0x85>
    proc->time_quantum_used++;

    if(proc->cpu_share == 0) {
      increase_MLFQ_tick_used();
    } else {
      increase_stride_tick_used();
80105fb0:	e8 cb d8 ff ff       	call   80103880 <increase_stride_tick_used>
80105fb5:	e9 7e ff ff ff       	jmp    80105f38 <trap+0x238>
#endif
      

      // Design Document 1-1-2-5. Moving a process to the lower level
      if (proc->level_of_MLFQ < NMLFQ - 1) {
        proc->level_of_MLFQ++;
80105fba:	83 c2 01             	add    $0x1,%edx
80105fbd:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
80105fc3:	eb 99                	jmp    80105f5e <trap+0x25e>
80105fc5:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105fc8:	8b 73 38             	mov    0x38(%ebx),%esi
80105fcb:	e8 80 c7 ff ff       	call   80102750 <cpunum>
80105fd0:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105fd4:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105fd8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fdc:	8b 43 30             	mov    0x30(%ebx),%eax
80105fdf:	c7 04 24 d8 7d 10 80 	movl   $0x80107dd8,(%esp)
80105fe6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fea:	e8 61 a6 ff ff       	call   80100650 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105fef:	c7 04 24 ae 7d 10 80 	movl   $0x80107dae,(%esp)
80105ff6:	e8 65 a3 ff ff       	call   80100360 <panic>
80105ffb:	66 90                	xchg   %ax,%ax
80105ffd:	66 90                	xchg   %ax,%ax
80105fff:	90                   	nop

80106000 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106000:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106005:	55                   	push   %ebp
80106006:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106008:	85 c0                	test   %eax,%eax
8010600a:	74 14                	je     80106020 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010600c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106011:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106012:	a8 01                	test   $0x1,%al
80106014:	74 0a                	je     80106020 <uartgetc+0x20>
80106016:	b2 f8                	mov    $0xf8,%dl
80106018:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106019:	0f b6 c0             	movzbl %al,%eax
}
8010601c:	5d                   	pop    %ebp
8010601d:	c3                   	ret    
8010601e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80106025:	5d                   	pop    %ebp
80106026:	c3                   	ret    
80106027:	89 f6                	mov    %esi,%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106030 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106030:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80106035:	85 c0                	test   %eax,%eax
80106037:	74 3f                	je     80106078 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80106039:	55                   	push   %ebp
8010603a:	89 e5                	mov    %esp,%ebp
8010603c:	56                   	push   %esi
8010603d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106042:	53                   	push   %ebx
  int i;

  if(!uart)
80106043:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80106048:	83 ec 10             	sub    $0x10,%esp
8010604b:	eb 14                	jmp    80106061 <uartputc+0x31>
8010604d:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106050:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106057:	e8 b4 c7 ff ff       	call   80102810 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010605c:	83 eb 01             	sub    $0x1,%ebx
8010605f:	74 07                	je     80106068 <uartputc+0x38>
80106061:	89 f2                	mov    %esi,%edx
80106063:	ec                   	in     (%dx),%al
80106064:	a8 20                	test   $0x20,%al
80106066:	74 e8                	je     80106050 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80106068:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010606c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106071:	ee                   	out    %al,(%dx)
}
80106072:	83 c4 10             	add    $0x10,%esp
80106075:	5b                   	pop    %ebx
80106076:	5e                   	pop    %esi
80106077:	5d                   	pop    %ebp
80106078:	f3 c3                	repz ret 
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106080 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106080:	55                   	push   %ebp
80106081:	31 c9                	xor    %ecx,%ecx
80106083:	89 e5                	mov    %esp,%ebp
80106085:	89 c8                	mov    %ecx,%eax
80106087:	57                   	push   %edi
80106088:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010608d:	56                   	push   %esi
8010608e:	89 fa                	mov    %edi,%edx
80106090:	53                   	push   %ebx
80106091:	83 ec 1c             	sub    $0x1c,%esp
80106094:	ee                   	out    %al,(%dx)
80106095:	be fb 03 00 00       	mov    $0x3fb,%esi
8010609a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010609f:	89 f2                	mov    %esi,%edx
801060a1:	ee                   	out    %al,(%dx)
801060a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060a7:	b2 f8                	mov    $0xf8,%dl
801060a9:	ee                   	out    %al,(%dx)
801060aa:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801060af:	89 c8                	mov    %ecx,%eax
801060b1:	89 da                	mov    %ebx,%edx
801060b3:	ee                   	out    %al,(%dx)
801060b4:	b8 03 00 00 00       	mov    $0x3,%eax
801060b9:	89 f2                	mov    %esi,%edx
801060bb:	ee                   	out    %al,(%dx)
801060bc:	b2 fc                	mov    $0xfc,%dl
801060be:	89 c8                	mov    %ecx,%eax
801060c0:	ee                   	out    %al,(%dx)
801060c1:	b8 01 00 00 00       	mov    $0x1,%eax
801060c6:	89 da                	mov    %ebx,%edx
801060c8:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060c9:	b2 fd                	mov    $0xfd,%dl
801060cb:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801060cc:	3c ff                	cmp    $0xff,%al
801060ce:	74 52                	je     80106122 <uartinit+0xa2>
    return;
  uart = 1;
801060d0:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801060d7:	00 00 00 
801060da:	89 fa                	mov    %edi,%edx
801060dc:	ec                   	in     (%dx),%al
801060dd:	b2 f8                	mov    $0xf8,%dl
801060df:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
801060e0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801060e7:	bb d0 7e 10 80       	mov    $0x80107ed0,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
801060ec:	e8 ff d0 ff ff       	call   801031f0 <picenable>
  ioapicenable(IRQ_COM1, 0);
801060f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801060f8:	00 
801060f9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106100:	e8 9b c1 ff ff       	call   801022a0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106105:	b8 78 00 00 00       	mov    $0x78,%eax
8010610a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc(*p);
80106110:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106113:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80106116:	e8 15 ff ff ff       	call   80106030 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010611b:	0f be 03             	movsbl (%ebx),%eax
8010611e:	84 c0                	test   %al,%al
80106120:	75 ee                	jne    80106110 <uartinit+0x90>
    uartputc(*p);
}
80106122:	83 c4 1c             	add    $0x1c,%esp
80106125:	5b                   	pop    %ebx
80106126:	5e                   	pop    %esi
80106127:	5f                   	pop    %edi
80106128:	5d                   	pop    %ebp
80106129:	c3                   	ret    
8010612a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106130 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106136:	c7 04 24 00 60 10 80 	movl   $0x80106000,(%esp)
8010613d:	e8 6e a6 ff ff       	call   801007b0 <consoleintr>
}
80106142:	c9                   	leave  
80106143:	c3                   	ret    

80106144 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106144:	6a 00                	push   $0x0
  pushl $0
80106146:	6a 00                	push   $0x0
  jmp alltraps
80106148:	e9 80 fa ff ff       	jmp    80105bcd <alltraps>

8010614d <vector1>:
.globl vector1
vector1:
  pushl $0
8010614d:	6a 00                	push   $0x0
  pushl $1
8010614f:	6a 01                	push   $0x1
  jmp alltraps
80106151:	e9 77 fa ff ff       	jmp    80105bcd <alltraps>

80106156 <vector2>:
.globl vector2
vector2:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $2
80106158:	6a 02                	push   $0x2
  jmp alltraps
8010615a:	e9 6e fa ff ff       	jmp    80105bcd <alltraps>

8010615f <vector3>:
.globl vector3
vector3:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $3
80106161:	6a 03                	push   $0x3
  jmp alltraps
80106163:	e9 65 fa ff ff       	jmp    80105bcd <alltraps>

80106168 <vector4>:
.globl vector4
vector4:
  pushl $0
80106168:	6a 00                	push   $0x0
  pushl $4
8010616a:	6a 04                	push   $0x4
  jmp alltraps
8010616c:	e9 5c fa ff ff       	jmp    80105bcd <alltraps>

80106171 <vector5>:
.globl vector5
vector5:
  pushl $0
80106171:	6a 00                	push   $0x0
  pushl $5
80106173:	6a 05                	push   $0x5
  jmp alltraps
80106175:	e9 53 fa ff ff       	jmp    80105bcd <alltraps>

8010617a <vector6>:
.globl vector6
vector6:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $6
8010617c:	6a 06                	push   $0x6
  jmp alltraps
8010617e:	e9 4a fa ff ff       	jmp    80105bcd <alltraps>

80106183 <vector7>:
.globl vector7
vector7:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $7
80106185:	6a 07                	push   $0x7
  jmp alltraps
80106187:	e9 41 fa ff ff       	jmp    80105bcd <alltraps>

8010618c <vector8>:
.globl vector8
vector8:
  pushl $8
8010618c:	6a 08                	push   $0x8
  jmp alltraps
8010618e:	e9 3a fa ff ff       	jmp    80105bcd <alltraps>

80106193 <vector9>:
.globl vector9
vector9:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $9
80106195:	6a 09                	push   $0x9
  jmp alltraps
80106197:	e9 31 fa ff ff       	jmp    80105bcd <alltraps>

8010619c <vector10>:
.globl vector10
vector10:
  pushl $10
8010619c:	6a 0a                	push   $0xa
  jmp alltraps
8010619e:	e9 2a fa ff ff       	jmp    80105bcd <alltraps>

801061a3 <vector11>:
.globl vector11
vector11:
  pushl $11
801061a3:	6a 0b                	push   $0xb
  jmp alltraps
801061a5:	e9 23 fa ff ff       	jmp    80105bcd <alltraps>

801061aa <vector12>:
.globl vector12
vector12:
  pushl $12
801061aa:	6a 0c                	push   $0xc
  jmp alltraps
801061ac:	e9 1c fa ff ff       	jmp    80105bcd <alltraps>

801061b1 <vector13>:
.globl vector13
vector13:
  pushl $13
801061b1:	6a 0d                	push   $0xd
  jmp alltraps
801061b3:	e9 15 fa ff ff       	jmp    80105bcd <alltraps>

801061b8 <vector14>:
.globl vector14
vector14:
  pushl $14
801061b8:	6a 0e                	push   $0xe
  jmp alltraps
801061ba:	e9 0e fa ff ff       	jmp    80105bcd <alltraps>

801061bf <vector15>:
.globl vector15
vector15:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $15
801061c1:	6a 0f                	push   $0xf
  jmp alltraps
801061c3:	e9 05 fa ff ff       	jmp    80105bcd <alltraps>

801061c8 <vector16>:
.globl vector16
vector16:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $16
801061ca:	6a 10                	push   $0x10
  jmp alltraps
801061cc:	e9 fc f9 ff ff       	jmp    80105bcd <alltraps>

801061d1 <vector17>:
.globl vector17
vector17:
  pushl $17
801061d1:	6a 11                	push   $0x11
  jmp alltraps
801061d3:	e9 f5 f9 ff ff       	jmp    80105bcd <alltraps>

801061d8 <vector18>:
.globl vector18
vector18:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $18
801061da:	6a 12                	push   $0x12
  jmp alltraps
801061dc:	e9 ec f9 ff ff       	jmp    80105bcd <alltraps>

801061e1 <vector19>:
.globl vector19
vector19:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $19
801061e3:	6a 13                	push   $0x13
  jmp alltraps
801061e5:	e9 e3 f9 ff ff       	jmp    80105bcd <alltraps>

801061ea <vector20>:
.globl vector20
vector20:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $20
801061ec:	6a 14                	push   $0x14
  jmp alltraps
801061ee:	e9 da f9 ff ff       	jmp    80105bcd <alltraps>

801061f3 <vector21>:
.globl vector21
vector21:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $21
801061f5:	6a 15                	push   $0x15
  jmp alltraps
801061f7:	e9 d1 f9 ff ff       	jmp    80105bcd <alltraps>

801061fc <vector22>:
.globl vector22
vector22:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $22
801061fe:	6a 16                	push   $0x16
  jmp alltraps
80106200:	e9 c8 f9 ff ff       	jmp    80105bcd <alltraps>

80106205 <vector23>:
.globl vector23
vector23:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $23
80106207:	6a 17                	push   $0x17
  jmp alltraps
80106209:	e9 bf f9 ff ff       	jmp    80105bcd <alltraps>

8010620e <vector24>:
.globl vector24
vector24:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $24
80106210:	6a 18                	push   $0x18
  jmp alltraps
80106212:	e9 b6 f9 ff ff       	jmp    80105bcd <alltraps>

80106217 <vector25>:
.globl vector25
vector25:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $25
80106219:	6a 19                	push   $0x19
  jmp alltraps
8010621b:	e9 ad f9 ff ff       	jmp    80105bcd <alltraps>

80106220 <vector26>:
.globl vector26
vector26:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $26
80106222:	6a 1a                	push   $0x1a
  jmp alltraps
80106224:	e9 a4 f9 ff ff       	jmp    80105bcd <alltraps>

80106229 <vector27>:
.globl vector27
vector27:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $27
8010622b:	6a 1b                	push   $0x1b
  jmp alltraps
8010622d:	e9 9b f9 ff ff       	jmp    80105bcd <alltraps>

80106232 <vector28>:
.globl vector28
vector28:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $28
80106234:	6a 1c                	push   $0x1c
  jmp alltraps
80106236:	e9 92 f9 ff ff       	jmp    80105bcd <alltraps>

8010623b <vector29>:
.globl vector29
vector29:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $29
8010623d:	6a 1d                	push   $0x1d
  jmp alltraps
8010623f:	e9 89 f9 ff ff       	jmp    80105bcd <alltraps>

80106244 <vector30>:
.globl vector30
vector30:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $30
80106246:	6a 1e                	push   $0x1e
  jmp alltraps
80106248:	e9 80 f9 ff ff       	jmp    80105bcd <alltraps>

8010624d <vector31>:
.globl vector31
vector31:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $31
8010624f:	6a 1f                	push   $0x1f
  jmp alltraps
80106251:	e9 77 f9 ff ff       	jmp    80105bcd <alltraps>

80106256 <vector32>:
.globl vector32
vector32:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $32
80106258:	6a 20                	push   $0x20
  jmp alltraps
8010625a:	e9 6e f9 ff ff       	jmp    80105bcd <alltraps>

8010625f <vector33>:
.globl vector33
vector33:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $33
80106261:	6a 21                	push   $0x21
  jmp alltraps
80106263:	e9 65 f9 ff ff       	jmp    80105bcd <alltraps>

80106268 <vector34>:
.globl vector34
vector34:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $34
8010626a:	6a 22                	push   $0x22
  jmp alltraps
8010626c:	e9 5c f9 ff ff       	jmp    80105bcd <alltraps>

80106271 <vector35>:
.globl vector35
vector35:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $35
80106273:	6a 23                	push   $0x23
  jmp alltraps
80106275:	e9 53 f9 ff ff       	jmp    80105bcd <alltraps>

8010627a <vector36>:
.globl vector36
vector36:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $36
8010627c:	6a 24                	push   $0x24
  jmp alltraps
8010627e:	e9 4a f9 ff ff       	jmp    80105bcd <alltraps>

80106283 <vector37>:
.globl vector37
vector37:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $37
80106285:	6a 25                	push   $0x25
  jmp alltraps
80106287:	e9 41 f9 ff ff       	jmp    80105bcd <alltraps>

8010628c <vector38>:
.globl vector38
vector38:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $38
8010628e:	6a 26                	push   $0x26
  jmp alltraps
80106290:	e9 38 f9 ff ff       	jmp    80105bcd <alltraps>

80106295 <vector39>:
.globl vector39
vector39:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $39
80106297:	6a 27                	push   $0x27
  jmp alltraps
80106299:	e9 2f f9 ff ff       	jmp    80105bcd <alltraps>

8010629e <vector40>:
.globl vector40
vector40:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $40
801062a0:	6a 28                	push   $0x28
  jmp alltraps
801062a2:	e9 26 f9 ff ff       	jmp    80105bcd <alltraps>

801062a7 <vector41>:
.globl vector41
vector41:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $41
801062a9:	6a 29                	push   $0x29
  jmp alltraps
801062ab:	e9 1d f9 ff ff       	jmp    80105bcd <alltraps>

801062b0 <vector42>:
.globl vector42
vector42:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $42
801062b2:	6a 2a                	push   $0x2a
  jmp alltraps
801062b4:	e9 14 f9 ff ff       	jmp    80105bcd <alltraps>

801062b9 <vector43>:
.globl vector43
vector43:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $43
801062bb:	6a 2b                	push   $0x2b
  jmp alltraps
801062bd:	e9 0b f9 ff ff       	jmp    80105bcd <alltraps>

801062c2 <vector44>:
.globl vector44
vector44:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $44
801062c4:	6a 2c                	push   $0x2c
  jmp alltraps
801062c6:	e9 02 f9 ff ff       	jmp    80105bcd <alltraps>

801062cb <vector45>:
.globl vector45
vector45:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $45
801062cd:	6a 2d                	push   $0x2d
  jmp alltraps
801062cf:	e9 f9 f8 ff ff       	jmp    80105bcd <alltraps>

801062d4 <vector46>:
.globl vector46
vector46:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $46
801062d6:	6a 2e                	push   $0x2e
  jmp alltraps
801062d8:	e9 f0 f8 ff ff       	jmp    80105bcd <alltraps>

801062dd <vector47>:
.globl vector47
vector47:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $47
801062df:	6a 2f                	push   $0x2f
  jmp alltraps
801062e1:	e9 e7 f8 ff ff       	jmp    80105bcd <alltraps>

801062e6 <vector48>:
.globl vector48
vector48:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $48
801062e8:	6a 30                	push   $0x30
  jmp alltraps
801062ea:	e9 de f8 ff ff       	jmp    80105bcd <alltraps>

801062ef <vector49>:
.globl vector49
vector49:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $49
801062f1:	6a 31                	push   $0x31
  jmp alltraps
801062f3:	e9 d5 f8 ff ff       	jmp    80105bcd <alltraps>

801062f8 <vector50>:
.globl vector50
vector50:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $50
801062fa:	6a 32                	push   $0x32
  jmp alltraps
801062fc:	e9 cc f8 ff ff       	jmp    80105bcd <alltraps>

80106301 <vector51>:
.globl vector51
vector51:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $51
80106303:	6a 33                	push   $0x33
  jmp alltraps
80106305:	e9 c3 f8 ff ff       	jmp    80105bcd <alltraps>

8010630a <vector52>:
.globl vector52
vector52:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $52
8010630c:	6a 34                	push   $0x34
  jmp alltraps
8010630e:	e9 ba f8 ff ff       	jmp    80105bcd <alltraps>

80106313 <vector53>:
.globl vector53
vector53:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $53
80106315:	6a 35                	push   $0x35
  jmp alltraps
80106317:	e9 b1 f8 ff ff       	jmp    80105bcd <alltraps>

8010631c <vector54>:
.globl vector54
vector54:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $54
8010631e:	6a 36                	push   $0x36
  jmp alltraps
80106320:	e9 a8 f8 ff ff       	jmp    80105bcd <alltraps>

80106325 <vector55>:
.globl vector55
vector55:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $55
80106327:	6a 37                	push   $0x37
  jmp alltraps
80106329:	e9 9f f8 ff ff       	jmp    80105bcd <alltraps>

8010632e <vector56>:
.globl vector56
vector56:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $56
80106330:	6a 38                	push   $0x38
  jmp alltraps
80106332:	e9 96 f8 ff ff       	jmp    80105bcd <alltraps>

80106337 <vector57>:
.globl vector57
vector57:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $57
80106339:	6a 39                	push   $0x39
  jmp alltraps
8010633b:	e9 8d f8 ff ff       	jmp    80105bcd <alltraps>

80106340 <vector58>:
.globl vector58
vector58:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $58
80106342:	6a 3a                	push   $0x3a
  jmp alltraps
80106344:	e9 84 f8 ff ff       	jmp    80105bcd <alltraps>

80106349 <vector59>:
.globl vector59
vector59:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $59
8010634b:	6a 3b                	push   $0x3b
  jmp alltraps
8010634d:	e9 7b f8 ff ff       	jmp    80105bcd <alltraps>

80106352 <vector60>:
.globl vector60
vector60:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $60
80106354:	6a 3c                	push   $0x3c
  jmp alltraps
80106356:	e9 72 f8 ff ff       	jmp    80105bcd <alltraps>

8010635b <vector61>:
.globl vector61
vector61:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $61
8010635d:	6a 3d                	push   $0x3d
  jmp alltraps
8010635f:	e9 69 f8 ff ff       	jmp    80105bcd <alltraps>

80106364 <vector62>:
.globl vector62
vector62:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $62
80106366:	6a 3e                	push   $0x3e
  jmp alltraps
80106368:	e9 60 f8 ff ff       	jmp    80105bcd <alltraps>

8010636d <vector63>:
.globl vector63
vector63:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $63
8010636f:	6a 3f                	push   $0x3f
  jmp alltraps
80106371:	e9 57 f8 ff ff       	jmp    80105bcd <alltraps>

80106376 <vector64>:
.globl vector64
vector64:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $64
80106378:	6a 40                	push   $0x40
  jmp alltraps
8010637a:	e9 4e f8 ff ff       	jmp    80105bcd <alltraps>

8010637f <vector65>:
.globl vector65
vector65:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $65
80106381:	6a 41                	push   $0x41
  jmp alltraps
80106383:	e9 45 f8 ff ff       	jmp    80105bcd <alltraps>

80106388 <vector66>:
.globl vector66
vector66:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $66
8010638a:	6a 42                	push   $0x42
  jmp alltraps
8010638c:	e9 3c f8 ff ff       	jmp    80105bcd <alltraps>

80106391 <vector67>:
.globl vector67
vector67:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $67
80106393:	6a 43                	push   $0x43
  jmp alltraps
80106395:	e9 33 f8 ff ff       	jmp    80105bcd <alltraps>

8010639a <vector68>:
.globl vector68
vector68:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $68
8010639c:	6a 44                	push   $0x44
  jmp alltraps
8010639e:	e9 2a f8 ff ff       	jmp    80105bcd <alltraps>

801063a3 <vector69>:
.globl vector69
vector69:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $69
801063a5:	6a 45                	push   $0x45
  jmp alltraps
801063a7:	e9 21 f8 ff ff       	jmp    80105bcd <alltraps>

801063ac <vector70>:
.globl vector70
vector70:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $70
801063ae:	6a 46                	push   $0x46
  jmp alltraps
801063b0:	e9 18 f8 ff ff       	jmp    80105bcd <alltraps>

801063b5 <vector71>:
.globl vector71
vector71:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $71
801063b7:	6a 47                	push   $0x47
  jmp alltraps
801063b9:	e9 0f f8 ff ff       	jmp    80105bcd <alltraps>

801063be <vector72>:
.globl vector72
vector72:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $72
801063c0:	6a 48                	push   $0x48
  jmp alltraps
801063c2:	e9 06 f8 ff ff       	jmp    80105bcd <alltraps>

801063c7 <vector73>:
.globl vector73
vector73:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $73
801063c9:	6a 49                	push   $0x49
  jmp alltraps
801063cb:	e9 fd f7 ff ff       	jmp    80105bcd <alltraps>

801063d0 <vector74>:
.globl vector74
vector74:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $74
801063d2:	6a 4a                	push   $0x4a
  jmp alltraps
801063d4:	e9 f4 f7 ff ff       	jmp    80105bcd <alltraps>

801063d9 <vector75>:
.globl vector75
vector75:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $75
801063db:	6a 4b                	push   $0x4b
  jmp alltraps
801063dd:	e9 eb f7 ff ff       	jmp    80105bcd <alltraps>

801063e2 <vector76>:
.globl vector76
vector76:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $76
801063e4:	6a 4c                	push   $0x4c
  jmp alltraps
801063e6:	e9 e2 f7 ff ff       	jmp    80105bcd <alltraps>

801063eb <vector77>:
.globl vector77
vector77:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $77
801063ed:	6a 4d                	push   $0x4d
  jmp alltraps
801063ef:	e9 d9 f7 ff ff       	jmp    80105bcd <alltraps>

801063f4 <vector78>:
.globl vector78
vector78:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $78
801063f6:	6a 4e                	push   $0x4e
  jmp alltraps
801063f8:	e9 d0 f7 ff ff       	jmp    80105bcd <alltraps>

801063fd <vector79>:
.globl vector79
vector79:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $79
801063ff:	6a 4f                	push   $0x4f
  jmp alltraps
80106401:	e9 c7 f7 ff ff       	jmp    80105bcd <alltraps>

80106406 <vector80>:
.globl vector80
vector80:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $80
80106408:	6a 50                	push   $0x50
  jmp alltraps
8010640a:	e9 be f7 ff ff       	jmp    80105bcd <alltraps>

8010640f <vector81>:
.globl vector81
vector81:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $81
80106411:	6a 51                	push   $0x51
  jmp alltraps
80106413:	e9 b5 f7 ff ff       	jmp    80105bcd <alltraps>

80106418 <vector82>:
.globl vector82
vector82:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $82
8010641a:	6a 52                	push   $0x52
  jmp alltraps
8010641c:	e9 ac f7 ff ff       	jmp    80105bcd <alltraps>

80106421 <vector83>:
.globl vector83
vector83:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $83
80106423:	6a 53                	push   $0x53
  jmp alltraps
80106425:	e9 a3 f7 ff ff       	jmp    80105bcd <alltraps>

8010642a <vector84>:
.globl vector84
vector84:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $84
8010642c:	6a 54                	push   $0x54
  jmp alltraps
8010642e:	e9 9a f7 ff ff       	jmp    80105bcd <alltraps>

80106433 <vector85>:
.globl vector85
vector85:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $85
80106435:	6a 55                	push   $0x55
  jmp alltraps
80106437:	e9 91 f7 ff ff       	jmp    80105bcd <alltraps>

8010643c <vector86>:
.globl vector86
vector86:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $86
8010643e:	6a 56                	push   $0x56
  jmp alltraps
80106440:	e9 88 f7 ff ff       	jmp    80105bcd <alltraps>

80106445 <vector87>:
.globl vector87
vector87:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $87
80106447:	6a 57                	push   $0x57
  jmp alltraps
80106449:	e9 7f f7 ff ff       	jmp    80105bcd <alltraps>

8010644e <vector88>:
.globl vector88
vector88:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $88
80106450:	6a 58                	push   $0x58
  jmp alltraps
80106452:	e9 76 f7 ff ff       	jmp    80105bcd <alltraps>

80106457 <vector89>:
.globl vector89
vector89:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $89
80106459:	6a 59                	push   $0x59
  jmp alltraps
8010645b:	e9 6d f7 ff ff       	jmp    80105bcd <alltraps>

80106460 <vector90>:
.globl vector90
vector90:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $90
80106462:	6a 5a                	push   $0x5a
  jmp alltraps
80106464:	e9 64 f7 ff ff       	jmp    80105bcd <alltraps>

80106469 <vector91>:
.globl vector91
vector91:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $91
8010646b:	6a 5b                	push   $0x5b
  jmp alltraps
8010646d:	e9 5b f7 ff ff       	jmp    80105bcd <alltraps>

80106472 <vector92>:
.globl vector92
vector92:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $92
80106474:	6a 5c                	push   $0x5c
  jmp alltraps
80106476:	e9 52 f7 ff ff       	jmp    80105bcd <alltraps>

8010647b <vector93>:
.globl vector93
vector93:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $93
8010647d:	6a 5d                	push   $0x5d
  jmp alltraps
8010647f:	e9 49 f7 ff ff       	jmp    80105bcd <alltraps>

80106484 <vector94>:
.globl vector94
vector94:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $94
80106486:	6a 5e                	push   $0x5e
  jmp alltraps
80106488:	e9 40 f7 ff ff       	jmp    80105bcd <alltraps>

8010648d <vector95>:
.globl vector95
vector95:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $95
8010648f:	6a 5f                	push   $0x5f
  jmp alltraps
80106491:	e9 37 f7 ff ff       	jmp    80105bcd <alltraps>

80106496 <vector96>:
.globl vector96
vector96:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $96
80106498:	6a 60                	push   $0x60
  jmp alltraps
8010649a:	e9 2e f7 ff ff       	jmp    80105bcd <alltraps>

8010649f <vector97>:
.globl vector97
vector97:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $97
801064a1:	6a 61                	push   $0x61
  jmp alltraps
801064a3:	e9 25 f7 ff ff       	jmp    80105bcd <alltraps>

801064a8 <vector98>:
.globl vector98
vector98:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $98
801064aa:	6a 62                	push   $0x62
  jmp alltraps
801064ac:	e9 1c f7 ff ff       	jmp    80105bcd <alltraps>

801064b1 <vector99>:
.globl vector99
vector99:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $99
801064b3:	6a 63                	push   $0x63
  jmp alltraps
801064b5:	e9 13 f7 ff ff       	jmp    80105bcd <alltraps>

801064ba <vector100>:
.globl vector100
vector100:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $100
801064bc:	6a 64                	push   $0x64
  jmp alltraps
801064be:	e9 0a f7 ff ff       	jmp    80105bcd <alltraps>

801064c3 <vector101>:
.globl vector101
vector101:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $101
801064c5:	6a 65                	push   $0x65
  jmp alltraps
801064c7:	e9 01 f7 ff ff       	jmp    80105bcd <alltraps>

801064cc <vector102>:
.globl vector102
vector102:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $102
801064ce:	6a 66                	push   $0x66
  jmp alltraps
801064d0:	e9 f8 f6 ff ff       	jmp    80105bcd <alltraps>

801064d5 <vector103>:
.globl vector103
vector103:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $103
801064d7:	6a 67                	push   $0x67
  jmp alltraps
801064d9:	e9 ef f6 ff ff       	jmp    80105bcd <alltraps>

801064de <vector104>:
.globl vector104
vector104:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $104
801064e0:	6a 68                	push   $0x68
  jmp alltraps
801064e2:	e9 e6 f6 ff ff       	jmp    80105bcd <alltraps>

801064e7 <vector105>:
.globl vector105
vector105:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $105
801064e9:	6a 69                	push   $0x69
  jmp alltraps
801064eb:	e9 dd f6 ff ff       	jmp    80105bcd <alltraps>

801064f0 <vector106>:
.globl vector106
vector106:
  pushl $0
801064f0:	6a 00                	push   $0x0
  pushl $106
801064f2:	6a 6a                	push   $0x6a
  jmp alltraps
801064f4:	e9 d4 f6 ff ff       	jmp    80105bcd <alltraps>

801064f9 <vector107>:
.globl vector107
vector107:
  pushl $0
801064f9:	6a 00                	push   $0x0
  pushl $107
801064fb:	6a 6b                	push   $0x6b
  jmp alltraps
801064fd:	e9 cb f6 ff ff       	jmp    80105bcd <alltraps>

80106502 <vector108>:
.globl vector108
vector108:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $108
80106504:	6a 6c                	push   $0x6c
  jmp alltraps
80106506:	e9 c2 f6 ff ff       	jmp    80105bcd <alltraps>

8010650b <vector109>:
.globl vector109
vector109:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $109
8010650d:	6a 6d                	push   $0x6d
  jmp alltraps
8010650f:	e9 b9 f6 ff ff       	jmp    80105bcd <alltraps>

80106514 <vector110>:
.globl vector110
vector110:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $110
80106516:	6a 6e                	push   $0x6e
  jmp alltraps
80106518:	e9 b0 f6 ff ff       	jmp    80105bcd <alltraps>

8010651d <vector111>:
.globl vector111
vector111:
  pushl $0
8010651d:	6a 00                	push   $0x0
  pushl $111
8010651f:	6a 6f                	push   $0x6f
  jmp alltraps
80106521:	e9 a7 f6 ff ff       	jmp    80105bcd <alltraps>

80106526 <vector112>:
.globl vector112
vector112:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $112
80106528:	6a 70                	push   $0x70
  jmp alltraps
8010652a:	e9 9e f6 ff ff       	jmp    80105bcd <alltraps>

8010652f <vector113>:
.globl vector113
vector113:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $113
80106531:	6a 71                	push   $0x71
  jmp alltraps
80106533:	e9 95 f6 ff ff       	jmp    80105bcd <alltraps>

80106538 <vector114>:
.globl vector114
vector114:
  pushl $0
80106538:	6a 00                	push   $0x0
  pushl $114
8010653a:	6a 72                	push   $0x72
  jmp alltraps
8010653c:	e9 8c f6 ff ff       	jmp    80105bcd <alltraps>

80106541 <vector115>:
.globl vector115
vector115:
  pushl $0
80106541:	6a 00                	push   $0x0
  pushl $115
80106543:	6a 73                	push   $0x73
  jmp alltraps
80106545:	e9 83 f6 ff ff       	jmp    80105bcd <alltraps>

8010654a <vector116>:
.globl vector116
vector116:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $116
8010654c:	6a 74                	push   $0x74
  jmp alltraps
8010654e:	e9 7a f6 ff ff       	jmp    80105bcd <alltraps>

80106553 <vector117>:
.globl vector117
vector117:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $117
80106555:	6a 75                	push   $0x75
  jmp alltraps
80106557:	e9 71 f6 ff ff       	jmp    80105bcd <alltraps>

8010655c <vector118>:
.globl vector118
vector118:
  pushl $0
8010655c:	6a 00                	push   $0x0
  pushl $118
8010655e:	6a 76                	push   $0x76
  jmp alltraps
80106560:	e9 68 f6 ff ff       	jmp    80105bcd <alltraps>

80106565 <vector119>:
.globl vector119
vector119:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $119
80106567:	6a 77                	push   $0x77
  jmp alltraps
80106569:	e9 5f f6 ff ff       	jmp    80105bcd <alltraps>

8010656e <vector120>:
.globl vector120
vector120:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $120
80106570:	6a 78                	push   $0x78
  jmp alltraps
80106572:	e9 56 f6 ff ff       	jmp    80105bcd <alltraps>

80106577 <vector121>:
.globl vector121
vector121:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $121
80106579:	6a 79                	push   $0x79
  jmp alltraps
8010657b:	e9 4d f6 ff ff       	jmp    80105bcd <alltraps>

80106580 <vector122>:
.globl vector122
vector122:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $122
80106582:	6a 7a                	push   $0x7a
  jmp alltraps
80106584:	e9 44 f6 ff ff       	jmp    80105bcd <alltraps>

80106589 <vector123>:
.globl vector123
vector123:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $123
8010658b:	6a 7b                	push   $0x7b
  jmp alltraps
8010658d:	e9 3b f6 ff ff       	jmp    80105bcd <alltraps>

80106592 <vector124>:
.globl vector124
vector124:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $124
80106594:	6a 7c                	push   $0x7c
  jmp alltraps
80106596:	e9 32 f6 ff ff       	jmp    80105bcd <alltraps>

8010659b <vector125>:
.globl vector125
vector125:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $125
8010659d:	6a 7d                	push   $0x7d
  jmp alltraps
8010659f:	e9 29 f6 ff ff       	jmp    80105bcd <alltraps>

801065a4 <vector126>:
.globl vector126
vector126:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $126
801065a6:	6a 7e                	push   $0x7e
  jmp alltraps
801065a8:	e9 20 f6 ff ff       	jmp    80105bcd <alltraps>

801065ad <vector127>:
.globl vector127
vector127:
  pushl $0
801065ad:	6a 00                	push   $0x0
  pushl $127
801065af:	6a 7f                	push   $0x7f
  jmp alltraps
801065b1:	e9 17 f6 ff ff       	jmp    80105bcd <alltraps>

801065b6 <vector128>:
.globl vector128
vector128:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $128
801065b8:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065bd:	e9 0b f6 ff ff       	jmp    80105bcd <alltraps>

801065c2 <vector129>:
.globl vector129
vector129:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $129
801065c4:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065c9:	e9 ff f5 ff ff       	jmp    80105bcd <alltraps>

801065ce <vector130>:
.globl vector130
vector130:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $130
801065d0:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065d5:	e9 f3 f5 ff ff       	jmp    80105bcd <alltraps>

801065da <vector131>:
.globl vector131
vector131:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $131
801065dc:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065e1:	e9 e7 f5 ff ff       	jmp    80105bcd <alltraps>

801065e6 <vector132>:
.globl vector132
vector132:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $132
801065e8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065ed:	e9 db f5 ff ff       	jmp    80105bcd <alltraps>

801065f2 <vector133>:
.globl vector133
vector133:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $133
801065f4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065f9:	e9 cf f5 ff ff       	jmp    80105bcd <alltraps>

801065fe <vector134>:
.globl vector134
vector134:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $134
80106600:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106605:	e9 c3 f5 ff ff       	jmp    80105bcd <alltraps>

8010660a <vector135>:
.globl vector135
vector135:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $135
8010660c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106611:	e9 b7 f5 ff ff       	jmp    80105bcd <alltraps>

80106616 <vector136>:
.globl vector136
vector136:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $136
80106618:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010661d:	e9 ab f5 ff ff       	jmp    80105bcd <alltraps>

80106622 <vector137>:
.globl vector137
vector137:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $137
80106624:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106629:	e9 9f f5 ff ff       	jmp    80105bcd <alltraps>

8010662e <vector138>:
.globl vector138
vector138:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $138
80106630:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106635:	e9 93 f5 ff ff       	jmp    80105bcd <alltraps>

8010663a <vector139>:
.globl vector139
vector139:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $139
8010663c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106641:	e9 87 f5 ff ff       	jmp    80105bcd <alltraps>

80106646 <vector140>:
.globl vector140
vector140:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $140
80106648:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010664d:	e9 7b f5 ff ff       	jmp    80105bcd <alltraps>

80106652 <vector141>:
.globl vector141
vector141:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $141
80106654:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106659:	e9 6f f5 ff ff       	jmp    80105bcd <alltraps>

8010665e <vector142>:
.globl vector142
vector142:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $142
80106660:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106665:	e9 63 f5 ff ff       	jmp    80105bcd <alltraps>

8010666a <vector143>:
.globl vector143
vector143:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $143
8010666c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106671:	e9 57 f5 ff ff       	jmp    80105bcd <alltraps>

80106676 <vector144>:
.globl vector144
vector144:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $144
80106678:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010667d:	e9 4b f5 ff ff       	jmp    80105bcd <alltraps>

80106682 <vector145>:
.globl vector145
vector145:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $145
80106684:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106689:	e9 3f f5 ff ff       	jmp    80105bcd <alltraps>

8010668e <vector146>:
.globl vector146
vector146:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $146
80106690:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106695:	e9 33 f5 ff ff       	jmp    80105bcd <alltraps>

8010669a <vector147>:
.globl vector147
vector147:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $147
8010669c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066a1:	e9 27 f5 ff ff       	jmp    80105bcd <alltraps>

801066a6 <vector148>:
.globl vector148
vector148:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $148
801066a8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066ad:	e9 1b f5 ff ff       	jmp    80105bcd <alltraps>

801066b2 <vector149>:
.globl vector149
vector149:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $149
801066b4:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066b9:	e9 0f f5 ff ff       	jmp    80105bcd <alltraps>

801066be <vector150>:
.globl vector150
vector150:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $150
801066c0:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066c5:	e9 03 f5 ff ff       	jmp    80105bcd <alltraps>

801066ca <vector151>:
.globl vector151
vector151:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $151
801066cc:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066d1:	e9 f7 f4 ff ff       	jmp    80105bcd <alltraps>

801066d6 <vector152>:
.globl vector152
vector152:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $152
801066d8:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066dd:	e9 eb f4 ff ff       	jmp    80105bcd <alltraps>

801066e2 <vector153>:
.globl vector153
vector153:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $153
801066e4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066e9:	e9 df f4 ff ff       	jmp    80105bcd <alltraps>

801066ee <vector154>:
.globl vector154
vector154:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $154
801066f0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066f5:	e9 d3 f4 ff ff       	jmp    80105bcd <alltraps>

801066fa <vector155>:
.globl vector155
vector155:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $155
801066fc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106701:	e9 c7 f4 ff ff       	jmp    80105bcd <alltraps>

80106706 <vector156>:
.globl vector156
vector156:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $156
80106708:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010670d:	e9 bb f4 ff ff       	jmp    80105bcd <alltraps>

80106712 <vector157>:
.globl vector157
vector157:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $157
80106714:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106719:	e9 af f4 ff ff       	jmp    80105bcd <alltraps>

8010671e <vector158>:
.globl vector158
vector158:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $158
80106720:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106725:	e9 a3 f4 ff ff       	jmp    80105bcd <alltraps>

8010672a <vector159>:
.globl vector159
vector159:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $159
8010672c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106731:	e9 97 f4 ff ff       	jmp    80105bcd <alltraps>

80106736 <vector160>:
.globl vector160
vector160:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $160
80106738:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010673d:	e9 8b f4 ff ff       	jmp    80105bcd <alltraps>

80106742 <vector161>:
.globl vector161
vector161:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $161
80106744:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106749:	e9 7f f4 ff ff       	jmp    80105bcd <alltraps>

8010674e <vector162>:
.globl vector162
vector162:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $162
80106750:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106755:	e9 73 f4 ff ff       	jmp    80105bcd <alltraps>

8010675a <vector163>:
.globl vector163
vector163:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $163
8010675c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106761:	e9 67 f4 ff ff       	jmp    80105bcd <alltraps>

80106766 <vector164>:
.globl vector164
vector164:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $164
80106768:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010676d:	e9 5b f4 ff ff       	jmp    80105bcd <alltraps>

80106772 <vector165>:
.globl vector165
vector165:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $165
80106774:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106779:	e9 4f f4 ff ff       	jmp    80105bcd <alltraps>

8010677e <vector166>:
.globl vector166
vector166:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $166
80106780:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106785:	e9 43 f4 ff ff       	jmp    80105bcd <alltraps>

8010678a <vector167>:
.globl vector167
vector167:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $167
8010678c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106791:	e9 37 f4 ff ff       	jmp    80105bcd <alltraps>

80106796 <vector168>:
.globl vector168
vector168:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $168
80106798:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010679d:	e9 2b f4 ff ff       	jmp    80105bcd <alltraps>

801067a2 <vector169>:
.globl vector169
vector169:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $169
801067a4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067a9:	e9 1f f4 ff ff       	jmp    80105bcd <alltraps>

801067ae <vector170>:
.globl vector170
vector170:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $170
801067b0:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067b5:	e9 13 f4 ff ff       	jmp    80105bcd <alltraps>

801067ba <vector171>:
.globl vector171
vector171:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $171
801067bc:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067c1:	e9 07 f4 ff ff       	jmp    80105bcd <alltraps>

801067c6 <vector172>:
.globl vector172
vector172:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $172
801067c8:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067cd:	e9 fb f3 ff ff       	jmp    80105bcd <alltraps>

801067d2 <vector173>:
.globl vector173
vector173:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $173
801067d4:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067d9:	e9 ef f3 ff ff       	jmp    80105bcd <alltraps>

801067de <vector174>:
.globl vector174
vector174:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $174
801067e0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067e5:	e9 e3 f3 ff ff       	jmp    80105bcd <alltraps>

801067ea <vector175>:
.globl vector175
vector175:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $175
801067ec:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067f1:	e9 d7 f3 ff ff       	jmp    80105bcd <alltraps>

801067f6 <vector176>:
.globl vector176
vector176:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $176
801067f8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067fd:	e9 cb f3 ff ff       	jmp    80105bcd <alltraps>

80106802 <vector177>:
.globl vector177
vector177:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $177
80106804:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106809:	e9 bf f3 ff ff       	jmp    80105bcd <alltraps>

8010680e <vector178>:
.globl vector178
vector178:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $178
80106810:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106815:	e9 b3 f3 ff ff       	jmp    80105bcd <alltraps>

8010681a <vector179>:
.globl vector179
vector179:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $179
8010681c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106821:	e9 a7 f3 ff ff       	jmp    80105bcd <alltraps>

80106826 <vector180>:
.globl vector180
vector180:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $180
80106828:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010682d:	e9 9b f3 ff ff       	jmp    80105bcd <alltraps>

80106832 <vector181>:
.globl vector181
vector181:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $181
80106834:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106839:	e9 8f f3 ff ff       	jmp    80105bcd <alltraps>

8010683e <vector182>:
.globl vector182
vector182:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $182
80106840:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106845:	e9 83 f3 ff ff       	jmp    80105bcd <alltraps>

8010684a <vector183>:
.globl vector183
vector183:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $183
8010684c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106851:	e9 77 f3 ff ff       	jmp    80105bcd <alltraps>

80106856 <vector184>:
.globl vector184
vector184:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $184
80106858:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010685d:	e9 6b f3 ff ff       	jmp    80105bcd <alltraps>

80106862 <vector185>:
.globl vector185
vector185:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $185
80106864:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106869:	e9 5f f3 ff ff       	jmp    80105bcd <alltraps>

8010686e <vector186>:
.globl vector186
vector186:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $186
80106870:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106875:	e9 53 f3 ff ff       	jmp    80105bcd <alltraps>

8010687a <vector187>:
.globl vector187
vector187:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $187
8010687c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106881:	e9 47 f3 ff ff       	jmp    80105bcd <alltraps>

80106886 <vector188>:
.globl vector188
vector188:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $188
80106888:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010688d:	e9 3b f3 ff ff       	jmp    80105bcd <alltraps>

80106892 <vector189>:
.globl vector189
vector189:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $189
80106894:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106899:	e9 2f f3 ff ff       	jmp    80105bcd <alltraps>

8010689e <vector190>:
.globl vector190
vector190:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $190
801068a0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068a5:	e9 23 f3 ff ff       	jmp    80105bcd <alltraps>

801068aa <vector191>:
.globl vector191
vector191:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $191
801068ac:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068b1:	e9 17 f3 ff ff       	jmp    80105bcd <alltraps>

801068b6 <vector192>:
.globl vector192
vector192:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $192
801068b8:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068bd:	e9 0b f3 ff ff       	jmp    80105bcd <alltraps>

801068c2 <vector193>:
.globl vector193
vector193:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $193
801068c4:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068c9:	e9 ff f2 ff ff       	jmp    80105bcd <alltraps>

801068ce <vector194>:
.globl vector194
vector194:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $194
801068d0:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068d5:	e9 f3 f2 ff ff       	jmp    80105bcd <alltraps>

801068da <vector195>:
.globl vector195
vector195:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $195
801068dc:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068e1:	e9 e7 f2 ff ff       	jmp    80105bcd <alltraps>

801068e6 <vector196>:
.globl vector196
vector196:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $196
801068e8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068ed:	e9 db f2 ff ff       	jmp    80105bcd <alltraps>

801068f2 <vector197>:
.globl vector197
vector197:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $197
801068f4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068f9:	e9 cf f2 ff ff       	jmp    80105bcd <alltraps>

801068fe <vector198>:
.globl vector198
vector198:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $198
80106900:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106905:	e9 c3 f2 ff ff       	jmp    80105bcd <alltraps>

8010690a <vector199>:
.globl vector199
vector199:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $199
8010690c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106911:	e9 b7 f2 ff ff       	jmp    80105bcd <alltraps>

80106916 <vector200>:
.globl vector200
vector200:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $200
80106918:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010691d:	e9 ab f2 ff ff       	jmp    80105bcd <alltraps>

80106922 <vector201>:
.globl vector201
vector201:
  pushl $0
80106922:	6a 00                	push   $0x0
  pushl $201
80106924:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106929:	e9 9f f2 ff ff       	jmp    80105bcd <alltraps>

8010692e <vector202>:
.globl vector202
vector202:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $202
80106930:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106935:	e9 93 f2 ff ff       	jmp    80105bcd <alltraps>

8010693a <vector203>:
.globl vector203
vector203:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $203
8010693c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106941:	e9 87 f2 ff ff       	jmp    80105bcd <alltraps>

80106946 <vector204>:
.globl vector204
vector204:
  pushl $0
80106946:	6a 00                	push   $0x0
  pushl $204
80106948:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010694d:	e9 7b f2 ff ff       	jmp    80105bcd <alltraps>

80106952 <vector205>:
.globl vector205
vector205:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $205
80106954:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106959:	e9 6f f2 ff ff       	jmp    80105bcd <alltraps>

8010695e <vector206>:
.globl vector206
vector206:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $206
80106960:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106965:	e9 63 f2 ff ff       	jmp    80105bcd <alltraps>

8010696a <vector207>:
.globl vector207
vector207:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $207
8010696c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106971:	e9 57 f2 ff ff       	jmp    80105bcd <alltraps>

80106976 <vector208>:
.globl vector208
vector208:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $208
80106978:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010697d:	e9 4b f2 ff ff       	jmp    80105bcd <alltraps>

80106982 <vector209>:
.globl vector209
vector209:
  pushl $0
80106982:	6a 00                	push   $0x0
  pushl $209
80106984:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106989:	e9 3f f2 ff ff       	jmp    80105bcd <alltraps>

8010698e <vector210>:
.globl vector210
vector210:
  pushl $0
8010698e:	6a 00                	push   $0x0
  pushl $210
80106990:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106995:	e9 33 f2 ff ff       	jmp    80105bcd <alltraps>

8010699a <vector211>:
.globl vector211
vector211:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $211
8010699c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069a1:	e9 27 f2 ff ff       	jmp    80105bcd <alltraps>

801069a6 <vector212>:
.globl vector212
vector212:
  pushl $0
801069a6:	6a 00                	push   $0x0
  pushl $212
801069a8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069ad:	e9 1b f2 ff ff       	jmp    80105bcd <alltraps>

801069b2 <vector213>:
.globl vector213
vector213:
  pushl $0
801069b2:	6a 00                	push   $0x0
  pushl $213
801069b4:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069b9:	e9 0f f2 ff ff       	jmp    80105bcd <alltraps>

801069be <vector214>:
.globl vector214
vector214:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $214
801069c0:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069c5:	e9 03 f2 ff ff       	jmp    80105bcd <alltraps>

801069ca <vector215>:
.globl vector215
vector215:
  pushl $0
801069ca:	6a 00                	push   $0x0
  pushl $215
801069cc:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069d1:	e9 f7 f1 ff ff       	jmp    80105bcd <alltraps>

801069d6 <vector216>:
.globl vector216
vector216:
  pushl $0
801069d6:	6a 00                	push   $0x0
  pushl $216
801069d8:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069dd:	e9 eb f1 ff ff       	jmp    80105bcd <alltraps>

801069e2 <vector217>:
.globl vector217
vector217:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $217
801069e4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069e9:	e9 df f1 ff ff       	jmp    80105bcd <alltraps>

801069ee <vector218>:
.globl vector218
vector218:
  pushl $0
801069ee:	6a 00                	push   $0x0
  pushl $218
801069f0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069f5:	e9 d3 f1 ff ff       	jmp    80105bcd <alltraps>

801069fa <vector219>:
.globl vector219
vector219:
  pushl $0
801069fa:	6a 00                	push   $0x0
  pushl $219
801069fc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a01:	e9 c7 f1 ff ff       	jmp    80105bcd <alltraps>

80106a06 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $220
80106a08:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a0d:	e9 bb f1 ff ff       	jmp    80105bcd <alltraps>

80106a12 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a12:	6a 00                	push   $0x0
  pushl $221
80106a14:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a19:	e9 af f1 ff ff       	jmp    80105bcd <alltraps>

80106a1e <vector222>:
.globl vector222
vector222:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $222
80106a20:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a25:	e9 a3 f1 ff ff       	jmp    80105bcd <alltraps>

80106a2a <vector223>:
.globl vector223
vector223:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $223
80106a2c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a31:	e9 97 f1 ff ff       	jmp    80105bcd <alltraps>

80106a36 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a36:	6a 00                	push   $0x0
  pushl $224
80106a38:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a3d:	e9 8b f1 ff ff       	jmp    80105bcd <alltraps>

80106a42 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $225
80106a44:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a49:	e9 7f f1 ff ff       	jmp    80105bcd <alltraps>

80106a4e <vector226>:
.globl vector226
vector226:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $226
80106a50:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a55:	e9 73 f1 ff ff       	jmp    80105bcd <alltraps>

80106a5a <vector227>:
.globl vector227
vector227:
  pushl $0
80106a5a:	6a 00                	push   $0x0
  pushl $227
80106a5c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a61:	e9 67 f1 ff ff       	jmp    80105bcd <alltraps>

80106a66 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a66:	6a 00                	push   $0x0
  pushl $228
80106a68:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a6d:	e9 5b f1 ff ff       	jmp    80105bcd <alltraps>

80106a72 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $229
80106a74:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a79:	e9 4f f1 ff ff       	jmp    80105bcd <alltraps>

80106a7e <vector230>:
.globl vector230
vector230:
  pushl $0
80106a7e:	6a 00                	push   $0x0
  pushl $230
80106a80:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a85:	e9 43 f1 ff ff       	jmp    80105bcd <alltraps>

80106a8a <vector231>:
.globl vector231
vector231:
  pushl $0
80106a8a:	6a 00                	push   $0x0
  pushl $231
80106a8c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a91:	e9 37 f1 ff ff       	jmp    80105bcd <alltraps>

80106a96 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a96:	6a 00                	push   $0x0
  pushl $232
80106a98:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a9d:	e9 2b f1 ff ff       	jmp    80105bcd <alltraps>

80106aa2 <vector233>:
.globl vector233
vector233:
  pushl $0
80106aa2:	6a 00                	push   $0x0
  pushl $233
80106aa4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106aa9:	e9 1f f1 ff ff       	jmp    80105bcd <alltraps>

80106aae <vector234>:
.globl vector234
vector234:
  pushl $0
80106aae:	6a 00                	push   $0x0
  pushl $234
80106ab0:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ab5:	e9 13 f1 ff ff       	jmp    80105bcd <alltraps>

80106aba <vector235>:
.globl vector235
vector235:
  pushl $0
80106aba:	6a 00                	push   $0x0
  pushl $235
80106abc:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ac1:	e9 07 f1 ff ff       	jmp    80105bcd <alltraps>

80106ac6 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ac6:	6a 00                	push   $0x0
  pushl $236
80106ac8:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106acd:	e9 fb f0 ff ff       	jmp    80105bcd <alltraps>

80106ad2 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ad2:	6a 00                	push   $0x0
  pushl $237
80106ad4:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106ad9:	e9 ef f0 ff ff       	jmp    80105bcd <alltraps>

80106ade <vector238>:
.globl vector238
vector238:
  pushl $0
80106ade:	6a 00                	push   $0x0
  pushl $238
80106ae0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ae5:	e9 e3 f0 ff ff       	jmp    80105bcd <alltraps>

80106aea <vector239>:
.globl vector239
vector239:
  pushl $0
80106aea:	6a 00                	push   $0x0
  pushl $239
80106aec:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106af1:	e9 d7 f0 ff ff       	jmp    80105bcd <alltraps>

80106af6 <vector240>:
.globl vector240
vector240:
  pushl $0
80106af6:	6a 00                	push   $0x0
  pushl $240
80106af8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106afd:	e9 cb f0 ff ff       	jmp    80105bcd <alltraps>

80106b02 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b02:	6a 00                	push   $0x0
  pushl $241
80106b04:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b09:	e9 bf f0 ff ff       	jmp    80105bcd <alltraps>

80106b0e <vector242>:
.globl vector242
vector242:
  pushl $0
80106b0e:	6a 00                	push   $0x0
  pushl $242
80106b10:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b15:	e9 b3 f0 ff ff       	jmp    80105bcd <alltraps>

80106b1a <vector243>:
.globl vector243
vector243:
  pushl $0
80106b1a:	6a 00                	push   $0x0
  pushl $243
80106b1c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b21:	e9 a7 f0 ff ff       	jmp    80105bcd <alltraps>

80106b26 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b26:	6a 00                	push   $0x0
  pushl $244
80106b28:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b2d:	e9 9b f0 ff ff       	jmp    80105bcd <alltraps>

80106b32 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b32:	6a 00                	push   $0x0
  pushl $245
80106b34:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b39:	e9 8f f0 ff ff       	jmp    80105bcd <alltraps>

80106b3e <vector246>:
.globl vector246
vector246:
  pushl $0
80106b3e:	6a 00                	push   $0x0
  pushl $246
80106b40:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b45:	e9 83 f0 ff ff       	jmp    80105bcd <alltraps>

80106b4a <vector247>:
.globl vector247
vector247:
  pushl $0
80106b4a:	6a 00                	push   $0x0
  pushl $247
80106b4c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b51:	e9 77 f0 ff ff       	jmp    80105bcd <alltraps>

80106b56 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b56:	6a 00                	push   $0x0
  pushl $248
80106b58:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b5d:	e9 6b f0 ff ff       	jmp    80105bcd <alltraps>

80106b62 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b62:	6a 00                	push   $0x0
  pushl $249
80106b64:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b69:	e9 5f f0 ff ff       	jmp    80105bcd <alltraps>

80106b6e <vector250>:
.globl vector250
vector250:
  pushl $0
80106b6e:	6a 00                	push   $0x0
  pushl $250
80106b70:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b75:	e9 53 f0 ff ff       	jmp    80105bcd <alltraps>

80106b7a <vector251>:
.globl vector251
vector251:
  pushl $0
80106b7a:	6a 00                	push   $0x0
  pushl $251
80106b7c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b81:	e9 47 f0 ff ff       	jmp    80105bcd <alltraps>

80106b86 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b86:	6a 00                	push   $0x0
  pushl $252
80106b88:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b8d:	e9 3b f0 ff ff       	jmp    80105bcd <alltraps>

80106b92 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b92:	6a 00                	push   $0x0
  pushl $253
80106b94:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b99:	e9 2f f0 ff ff       	jmp    80105bcd <alltraps>

80106b9e <vector254>:
.globl vector254
vector254:
  pushl $0
80106b9e:	6a 00                	push   $0x0
  pushl $254
80106ba0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ba5:	e9 23 f0 ff ff       	jmp    80105bcd <alltraps>

80106baa <vector255>:
.globl vector255
vector255:
  pushl $0
80106baa:	6a 00                	push   $0x0
  pushl $255
80106bac:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106bb1:	e9 17 f0 ff ff       	jmp    80105bcd <alltraps>
80106bb6:	66 90                	xchg   %ax,%ax
80106bb8:	66 90                	xchg   %ax,%ax
80106bba:	66 90                	xchg   %ax,%ax
80106bbc:	66 90                	xchg   %ax,%ax
80106bbe:	66 90                	xchg   %ax,%ax

80106bc0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106bc7:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106bca:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106bcb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106bce:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106bd1:	8b 1f                	mov    (%edi),%ebx
80106bd3:	f6 c3 01             	test   $0x1,%bl
80106bd6:	74 28                	je     80106c00 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bd8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106bde:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106be4:	c1 ee 0a             	shr    $0xa,%esi
}
80106be7:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106bea:	89 f2                	mov    %esi,%edx
80106bec:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bf2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106bf5:	5b                   	pop    %ebx
80106bf6:	5e                   	pop    %esi
80106bf7:	5f                   	pop    %edi
80106bf8:	5d                   	pop    %ebp
80106bf9:	c3                   	ret    
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c00:	85 c9                	test   %ecx,%ecx
80106c02:	74 34                	je     80106c38 <walkpgdir+0x78>
80106c04:	e8 87 b8 ff ff       	call   80102490 <kalloc>
80106c09:	85 c0                	test   %eax,%eax
80106c0b:	89 c3                	mov    %eax,%ebx
80106c0d:	74 29                	je     80106c38 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106c0f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c16:	00 
80106c17:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c1e:	00 
80106c1f:	89 04 24             	mov    %eax,(%esp)
80106c22:	e8 49 de ff ff       	call   80104a70 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c27:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c2d:	83 c8 07             	or     $0x7,%eax
80106c30:	89 07                	mov    %eax,(%edi)
80106c32:	eb b0                	jmp    80106be4 <walkpgdir+0x24>
80106c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
80106c38:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106c3b:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106c3d:	5b                   	pop    %ebx
80106c3e:	5e                   	pop    %esi
80106c3f:	5f                   	pop    %edi
80106c40:	5d                   	pop    %ebp
80106c41:	c3                   	ret    
80106c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c50 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c56:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c58:	83 ec 1c             	sub    $0x1c,%esp
80106c5b:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c5e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c64:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c67:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c6e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c72:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106c79:	29 df                	sub    %ebx,%edi
80106c7b:	eb 18                	jmp    80106c95 <mappages+0x45>
80106c7d:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106c80:	f6 00 01             	testb  $0x1,(%eax)
80106c83:	75 3d                	jne    80106cc2 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c85:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106c88:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c8b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c8d:	74 29                	je     80106cb8 <mappages+0x68>
      break;
    a += PGSIZE;
80106c8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c98:	b9 01 00 00 00       	mov    $0x1,%ecx
80106c9d:	89 da                	mov    %ebx,%edx
80106c9f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106ca2:	e8 19 ff ff ff       	call   80106bc0 <walkpgdir>
80106ca7:	85 c0                	test   %eax,%eax
80106ca9:	75 d5                	jne    80106c80 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106cab:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106cae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106cb3:	5b                   	pop    %ebx
80106cb4:	5e                   	pop    %esi
80106cb5:	5f                   	pop    %edi
80106cb6:	5d                   	pop    %ebp
80106cb7:	c3                   	ret    
80106cb8:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106cbb:	31 c0                	xor    %eax,%eax
}
80106cbd:	5b                   	pop    %ebx
80106cbe:	5e                   	pop    %esi
80106cbf:	5f                   	pop    %edi
80106cc0:	5d                   	pop    %ebp
80106cc1:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106cc2:	c7 04 24 d8 7e 10 80 	movl   $0x80107ed8,(%esp)
80106cc9:	e8 92 96 ff ff       	call   80100360 <panic>
80106cce:	66 90                	xchg   %ax,%ax

80106cd0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	89 c7                	mov    %eax,%edi
80106cd6:	56                   	push   %esi
80106cd7:	89 d6                	mov    %edx,%esi
80106cd9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106cda:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ce0:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ce3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106ce9:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ceb:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106cee:	72 3b                	jb     80106d2b <deallocuvm.part.0+0x5b>
80106cf0:	eb 5e                	jmp    80106d50 <deallocuvm.part.0+0x80>
80106cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106cf8:	8b 10                	mov    (%eax),%edx
80106cfa:	f6 c2 01             	test   $0x1,%dl
80106cfd:	74 22                	je     80106d21 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106cff:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d05:	74 54                	je     80106d5b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106d07:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106d0d:	89 14 24             	mov    %edx,(%esp)
80106d10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d13:	e8 c8 b5 ff ff       	call   801022e0 <kfree>
      *pte = 0;
80106d18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106d21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d27:	39 f3                	cmp    %esi,%ebx
80106d29:	73 25                	jae    80106d50 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106d2b:	31 c9                	xor    %ecx,%ecx
80106d2d:	89 da                	mov    %ebx,%edx
80106d2f:	89 f8                	mov    %edi,%eax
80106d31:	e8 8a fe ff ff       	call   80106bc0 <walkpgdir>
    if(!pte)
80106d36:	85 c0                	test   %eax,%eax
80106d38:	75 be                	jne    80106cf8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d3a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106d40:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106d46:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d4c:	39 f3                	cmp    %esi,%ebx
80106d4e:	72 db                	jb     80106d2b <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d53:	83 c4 1c             	add    $0x1c,%esp
80106d56:	5b                   	pop    %ebx
80106d57:	5e                   	pop    %esi
80106d58:	5f                   	pop    %edi
80106d59:	5d                   	pop    %ebp
80106d5a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106d5b:	c7 04 24 32 78 10 80 	movl   $0x80107832,(%esp)
80106d62:	e8 f9 95 ff ff       	call   80100360 <panic>
80106d67:	89 f6                	mov    %esi,%esi
80106d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d70 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106d76:	e8 d5 b9 ff ff       	call   80102750 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d7b:	31 c9                	xor    %ecx,%ecx
80106d7d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106d82:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106d88:	05 a0 37 11 80       	add    $0x801137a0,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d8d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d91:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d96:	66 89 48 7a          	mov    %cx,0x7a(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d9a:	31 c9                	xor    %ecx,%ecx
80106d9c:	66 89 90 80 00 00 00 	mov    %dx,0x80(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106da3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106da8:	66 89 88 82 00 00 00 	mov    %cx,0x82(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106daf:	31 c9                	xor    %ecx,%ecx
80106db1:	66 89 90 90 00 00 00 	mov    %dx,0x90(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106db8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106dbd:	66 89 88 92 00 00 00 	mov    %cx,0x92(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106dc4:	31 c9                	xor    %ecx,%ecx
80106dc6:	66 89 90 98 00 00 00 	mov    %dx,0x98(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106dcd:	8d 90 b4 00 00 00    	lea    0xb4(%eax),%edx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106dd3:	66 89 88 9a 00 00 00 	mov    %cx,0x9a(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106dda:	31 c9                	xor    %ecx,%ecx
80106ddc:	66 89 88 88 00 00 00 	mov    %cx,0x88(%eax)
80106de3:	89 d1                	mov    %edx,%ecx
80106de5:	c1 e9 10             	shr    $0x10,%ecx
80106de8:	66 89 90 8a 00 00 00 	mov    %dx,0x8a(%eax)
80106def:	c1 ea 18             	shr    $0x18,%edx
80106df2:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106df8:	b9 37 00 00 00       	mov    $0x37,%ecx
80106dfd:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80106e03:	8d 50 70             	lea    0x70(%eax),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e06:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
80106e0a:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e0e:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
80106e15:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e1c:	c6 80 95 00 00 00 fa 	movb   $0xfa,0x95(%eax)
80106e23:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e2a:	c6 80 9d 00 00 00 f2 	movb   $0xf2,0x9d(%eax)
80106e31:	c6 80 9e 00 00 00 cf 	movb   $0xcf,0x9e(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106e38:	c6 80 8d 00 00 00 92 	movb   $0x92,0x8d(%eax)
80106e3f:	c6 80 8e 00 00 00 c0 	movb   $0xc0,0x8e(%eax)
80106e46:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  pd[1] = (uint)p;
80106e4a:	66 89 55 f4          	mov    %dx,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e4e:	c1 ea 10             	shr    $0x10,%edx
80106e51:	66 89 55 f6          	mov    %dx,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106e55:	8d 55 f2             	lea    -0xe(%ebp),%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e58:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80106e5c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e60:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80106e67:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e6e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80106e75:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e7c:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80106e83:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)
80106e8a:	0f 01 12             	lgdtl  (%edx)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106e8d:	ba 18 00 00 00       	mov    $0x18,%edx
80106e92:	8e ea                	mov    %edx,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80106e94:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106e9b:	00 00 00 00 

  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
80106e9f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
}
80106ea5:	c9                   	leave  
80106ea6:	c3                   	ret    
80106ea7:	89 f6                	mov    %esi,%esi
80106ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106eb0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	56                   	push   %esi
80106eb4:	53                   	push   %ebx
80106eb5:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106eb8:	e8 d3 b5 ff ff       	call   80102490 <kalloc>
80106ebd:	85 c0                	test   %eax,%eax
80106ebf:	89 c6                	mov    %eax,%esi
80106ec1:	74 55                	je     80106f18 <setupkvm+0x68>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106ec3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106eca:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ecb:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106ed0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ed7:	00 
80106ed8:	89 04 24             	mov    %eax,(%esp)
80106edb:	e8 90 db ff ff       	call   80104a70 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ee0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106ee3:	8b 43 04             	mov    0x4(%ebx),%eax
80106ee6:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ee9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106eed:	8b 13                	mov    (%ebx),%edx
80106eef:	89 04 24             	mov    %eax,(%esp)
80106ef2:	29 c1                	sub    %eax,%ecx
80106ef4:	89 f0                	mov    %esi,%eax
80106ef6:	e8 55 fd ff ff       	call   80106c50 <mappages>
80106efb:	85 c0                	test   %eax,%eax
80106efd:	78 19                	js     80106f18 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106eff:	83 c3 10             	add    $0x10,%ebx
80106f02:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80106f08:	72 d6                	jb     80106ee0 <setupkvm+0x30>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106f0a:	83 c4 10             	add    $0x10,%esp
80106f0d:	89 f0                	mov    %esi,%eax
80106f0f:	5b                   	pop    %ebx
80106f10:	5e                   	pop    %esi
80106f11:	5d                   	pop    %ebp
80106f12:	c3                   	ret    
80106f13:	90                   	nop
80106f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f18:	83 c4 10             	add    $0x10,%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106f1b:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106f1d:	5b                   	pop    %ebx
80106f1e:	5e                   	pop    %esi
80106f1f:	5d                   	pop    %ebp
80106f20:	c3                   	ret    
80106f21:	eb 0d                	jmp    80106f30 <kvmalloc>
80106f23:	90                   	nop
80106f24:	90                   	nop
80106f25:	90                   	nop
80106f26:	90                   	nop
80106f27:	90                   	nop
80106f28:	90                   	nop
80106f29:	90                   	nop
80106f2a:	90                   	nop
80106f2b:	90                   	nop
80106f2c:	90                   	nop
80106f2d:	90                   	nop
80106f2e:	90                   	nop
80106f2f:	90                   	nop

80106f30 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f36:	e8 75 ff ff ff       	call   80106eb0 <setupkvm>
80106f3b:	a3 44 6c 11 80       	mov    %eax,0x80116c44
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f40:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f45:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106f48:	c9                   	leave  
80106f49:	c3                   	ret    
80106f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f50 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f50:	a1 44 6c 11 80       	mov    0x80116c44,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106f55:	55                   	push   %ebp
80106f56:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f58:	05 00 00 00 80       	add    $0x80000000,%eax
80106f5d:	0f 22 d8             	mov    %eax,%cr3
}
80106f60:	5d                   	pop    %ebp
80106f61:	c3                   	ret    
80106f62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f70 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	53                   	push   %ebx
80106f74:	83 ec 14             	sub    $0x14,%esp
80106f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106f7a:	85 db                	test   %ebx,%ebx
80106f7c:	0f 84 94 00 00 00    	je     80107016 <switchuvm+0xa6>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106f82:	8b 43 08             	mov    0x8(%ebx),%eax
80106f85:	85 c0                	test   %eax,%eax
80106f87:	0f 84 a1 00 00 00    	je     8010702e <switchuvm+0xbe>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106f8d:	8b 43 04             	mov    0x4(%ebx),%eax
80106f90:	85 c0                	test   %eax,%eax
80106f92:	0f 84 8a 00 00 00    	je     80107022 <switchuvm+0xb2>
    panic("switchuvm: no pgdir");

  pushcli();
80106f98:	e8 03 da ff ff       	call   801049a0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106f9d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106fa3:	b9 67 00 00 00       	mov    $0x67,%ecx
80106fa8:	8d 50 08             	lea    0x8(%eax),%edx
80106fab:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106fb2:	89 d1                	mov    %edx,%ecx
80106fb4:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106fbb:	c1 ea 18             	shr    $0x18,%edx
80106fbe:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
80106fc4:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106fc7:	ba 10 00 00 00       	mov    $0x10,%edx
80106fcc:	66 89 50 10          	mov    %dx,0x10(%eax)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106fd0:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80106fd6:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80106fdd:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106fe4:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106fe7:	8d 91 00 10 00 00    	lea    0x1000(%ecx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106fed:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx

  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ff2:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106ff5:	66 89 48 6e          	mov    %cx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106ff9:	b8 30 00 00 00       	mov    $0x30,%eax
80106ffe:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107001:	8b 43 04             	mov    0x4(%ebx),%eax
80107004:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107009:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
8010700c:	83 c4 14             	add    $0x14,%esp
8010700f:	5b                   	pop    %ebx
80107010:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80107011:	e9 ba d9 ff ff       	jmp    801049d0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107016:	c7 04 24 de 7e 10 80 	movl   $0x80107ede,(%esp)
8010701d:	e8 3e 93 ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80107022:	c7 04 24 09 7f 10 80 	movl   $0x80107f09,(%esp)
80107029:	e8 32 93 ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010702e:	c7 04 24 f4 7e 10 80 	movl   $0x80107ef4,(%esp)
80107035:	e8 26 93 ff ff       	call   80100360 <panic>
8010703a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107040 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 1c             	sub    $0x1c,%esp
80107049:	8b 75 10             	mov    0x10(%ebp),%esi
8010704c:	8b 45 08             	mov    0x8(%ebp),%eax
8010704f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107052:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107058:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010705b:	77 54                	ja     801070b1 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
8010705d:	e8 2e b4 ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
80107062:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107069:	00 
8010706a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107071:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107072:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107074:	89 04 24             	mov    %eax,(%esp)
80107077:	e8 f4 d9 ff ff       	call   80104a70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010707c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107082:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107087:	89 04 24             	mov    %eax,(%esp)
8010708a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010708d:	31 d2                	xor    %edx,%edx
8010708f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80107096:	00 
80107097:	e8 b4 fb ff ff       	call   80106c50 <mappages>
  memmove(mem, init, sz);
8010709c:	89 75 10             	mov    %esi,0x10(%ebp)
8010709f:	89 7d 0c             	mov    %edi,0xc(%ebp)
801070a2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801070a5:	83 c4 1c             	add    $0x1c,%esp
801070a8:	5b                   	pop    %ebx
801070a9:	5e                   	pop    %esi
801070aa:	5f                   	pop    %edi
801070ab:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801070ac:	e9 5f da ff ff       	jmp    80104b10 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801070b1:	c7 04 24 1d 7f 10 80 	movl   $0x80107f1d,(%esp)
801070b8:	e8 a3 92 ff ff       	call   80100360 <panic>
801070bd:	8d 76 00             	lea    0x0(%esi),%esi

801070c0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801070c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801070d0:	0f 85 98 00 00 00    	jne    8010716e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801070d6:	8b 75 18             	mov    0x18(%ebp),%esi
801070d9:	31 db                	xor    %ebx,%ebx
801070db:	85 f6                	test   %esi,%esi
801070dd:	75 1a                	jne    801070f9 <loaduvm+0x39>
801070df:	eb 77                	jmp    80107158 <loaduvm+0x98>
801070e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801070f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801070f7:	76 5f                	jbe    80107158 <loaduvm+0x98>
801070f9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070fc:	31 c9                	xor    %ecx,%ecx
801070fe:	8b 45 08             	mov    0x8(%ebp),%eax
80107101:	01 da                	add    %ebx,%edx
80107103:	e8 b8 fa ff ff       	call   80106bc0 <walkpgdir>
80107108:	85 c0                	test   %eax,%eax
8010710a:	74 56                	je     80107162 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010710c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010710e:	bf 00 10 00 00       	mov    $0x1000,%edi
80107113:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107116:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010711b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80107121:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107124:	05 00 00 00 80       	add    $0x80000000,%eax
80107129:	89 44 24 04          	mov    %eax,0x4(%esp)
8010712d:	8b 45 10             	mov    0x10(%ebp),%eax
80107130:	01 d9                	add    %ebx,%ecx
80107132:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80107136:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010713a:	89 04 24             	mov    %eax,(%esp)
8010713d:	e8 fe a7 ff ff       	call   80101940 <readi>
80107142:	39 f8                	cmp    %edi,%eax
80107144:	74 a2                	je     801070e8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107146:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107149:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
8010714e:	5b                   	pop    %ebx
8010714f:	5e                   	pop    %esi
80107150:	5f                   	pop    %edi
80107151:	5d                   	pop    %ebp
80107152:	c3                   	ret    
80107153:	90                   	nop
80107154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107158:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010715b:	31 c0                	xor    %eax,%eax
}
8010715d:	5b                   	pop    %ebx
8010715e:	5e                   	pop    %esi
8010715f:	5f                   	pop    %edi
80107160:	5d                   	pop    %ebp
80107161:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80107162:	c7 04 24 37 7f 10 80 	movl   $0x80107f37,(%esp)
80107169:	e8 f2 91 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
8010716e:	c7 04 24 d8 7f 10 80 	movl   $0x80107fd8,(%esp)
80107175:	e8 e6 91 ff ff       	call   80100360 <panic>
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107180 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 1c             	sub    $0x1c,%esp
80107189:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010718c:	85 ff                	test   %edi,%edi
8010718e:	0f 88 7e 00 00 00    	js     80107212 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80107194:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107197:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010719a:	72 78                	jb     80107214 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
8010719c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801071a2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801071a8:	39 df                	cmp    %ebx,%edi
801071aa:	77 4a                	ja     801071f6 <allocuvm+0x76>
801071ac:	eb 72                	jmp    80107220 <allocuvm+0xa0>
801071ae:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
801071b0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801071b7:	00 
801071b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801071bf:	00 
801071c0:	89 04 24             	mov    %eax,(%esp)
801071c3:	e8 a8 d8 ff ff       	call   80104a70 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801071c8:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801071ce:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071d3:	89 04 24             	mov    %eax,(%esp)
801071d6:	8b 45 08             	mov    0x8(%ebp),%eax
801071d9:	89 da                	mov    %ebx,%edx
801071db:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801071e2:	00 
801071e3:	e8 68 fa ff ff       	call   80106c50 <mappages>
801071e8:	85 c0                	test   %eax,%eax
801071ea:	78 44                	js     80107230 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801071ec:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071f2:	39 df                	cmp    %ebx,%edi
801071f4:	76 2a                	jbe    80107220 <allocuvm+0xa0>
    mem = kalloc();
801071f6:	e8 95 b2 ff ff       	call   80102490 <kalloc>
    if(mem == 0){
801071fb:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
801071fd:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801071ff:	75 af                	jne    801071b0 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80107201:	c7 04 24 55 7f 10 80 	movl   $0x80107f55,(%esp)
80107208:	e8 43 94 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010720d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107210:	77 48                	ja     8010725a <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107212:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107214:	83 c4 1c             	add    $0x1c,%esp
80107217:	5b                   	pop    %ebx
80107218:	5e                   	pop    %esi
80107219:	5f                   	pop    %edi
8010721a:	5d                   	pop    %ebp
8010721b:	c3                   	ret    
8010721c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107220:	83 c4 1c             	add    $0x1c,%esp
80107223:	89 f8                	mov    %edi,%eax
80107225:	5b                   	pop    %ebx
80107226:	5e                   	pop    %esi
80107227:	5f                   	pop    %edi
80107228:	5d                   	pop    %ebp
80107229:	c3                   	ret    
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107230:	c7 04 24 6d 7f 10 80 	movl   $0x80107f6d,(%esp)
80107237:	e8 14 94 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010723c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010723f:	76 0d                	jbe    8010724e <allocuvm+0xce>
80107241:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107244:	89 fa                	mov    %edi,%edx
80107246:	8b 45 08             	mov    0x8(%ebp),%eax
80107249:	e8 82 fa ff ff       	call   80106cd0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
8010724e:	89 34 24             	mov    %esi,(%esp)
80107251:	e8 8a b0 ff ff       	call   801022e0 <kfree>
      return 0;
80107256:	31 c0                	xor    %eax,%eax
80107258:	eb ba                	jmp    80107214 <allocuvm+0x94>
8010725a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010725d:	89 fa                	mov    %edi,%edx
8010725f:	8b 45 08             	mov    0x8(%ebp),%eax
80107262:	e8 69 fa ff ff       	call   80106cd0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107267:	31 c0                	xor    %eax,%eax
80107269:	eb a9                	jmp    80107214 <allocuvm+0x94>
8010726b:	90                   	nop
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107270 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	8b 55 0c             	mov    0xc(%ebp),%edx
80107276:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107279:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010727c:	39 d1                	cmp    %edx,%ecx
8010727e:	73 08                	jae    80107288 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107280:	5d                   	pop    %ebp
80107281:	e9 4a fa ff ff       	jmp    80106cd0 <deallocuvm.part.0>
80107286:	66 90                	xchg   %ax,%ax
80107288:	89 d0                	mov    %edx,%eax
8010728a:	5d                   	pop    %ebp
8010728b:	c3                   	ret    
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107290 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	56                   	push   %esi
80107294:	53                   	push   %ebx
80107295:	83 ec 10             	sub    $0x10,%esp
80107298:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010729b:	85 f6                	test   %esi,%esi
8010729d:	74 59                	je     801072f8 <freevm+0x68>
8010729f:	31 c9                	xor    %ecx,%ecx
801072a1:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072a6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072a8:	31 db                	xor    %ebx,%ebx
801072aa:	e8 21 fa ff ff       	call   80106cd0 <deallocuvm.part.0>
801072af:	eb 12                	jmp    801072c3 <freevm+0x33>
801072b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072b8:	83 c3 01             	add    $0x1,%ebx
801072bb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801072c1:	74 27                	je     801072ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072c3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
801072c6:	f6 c2 01             	test   $0x1,%dl
801072c9:	74 ed                	je     801072b8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072cb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072d1:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072d4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801072da:	89 14 24             	mov    %edx,(%esp)
801072dd:	e8 fe af ff ff       	call   801022e0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072e2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801072e8:	75 d9                	jne    801072c3 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801072ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801072ed:	83 c4 10             	add    $0x10,%esp
801072f0:	5b                   	pop    %ebx
801072f1:	5e                   	pop    %esi
801072f2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801072f3:	e9 e8 af ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801072f8:	c7 04 24 89 7f 10 80 	movl   $0x80107f89,(%esp)
801072ff:	e8 5c 90 ff ff       	call   80100360 <panic>
80107304:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010730a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107310 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107310:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107311:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107313:	89 e5                	mov    %esp,%ebp
80107315:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107318:	8b 55 0c             	mov    0xc(%ebp),%edx
8010731b:	8b 45 08             	mov    0x8(%ebp),%eax
8010731e:	e8 9d f8 ff ff       	call   80106bc0 <walkpgdir>
  if(pte == 0)
80107323:	85 c0                	test   %eax,%eax
80107325:	74 05                	je     8010732c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107327:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010732a:	c9                   	leave  
8010732b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010732c:	c7 04 24 9a 7f 10 80 	movl   $0x80107f9a,(%esp)
80107333:	e8 28 90 ff ff       	call   80100360 <panic>
80107338:	90                   	nop
80107339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107340 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107349:	e8 62 fb ff ff       	call   80106eb0 <setupkvm>
8010734e:	85 c0                	test   %eax,%eax
80107350:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107353:	0f 84 b2 00 00 00    	je     8010740b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107359:	8b 45 0c             	mov    0xc(%ebp),%eax
8010735c:	85 c0                	test   %eax,%eax
8010735e:	0f 84 9c 00 00 00    	je     80107400 <copyuvm+0xc0>
80107364:	31 db                	xor    %ebx,%ebx
80107366:	eb 48                	jmp    801073b0 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107368:	81 c7 00 00 00 80    	add    $0x80000000,%edi
8010736e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107375:	00 
80107376:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010737a:	89 04 24             	mov    %eax,(%esp)
8010737d:	e8 8e d7 ff ff       	call   80104b10 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107385:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
8010738b:	89 14 24             	mov    %edx,(%esp)
8010738e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107393:	89 da                	mov    %ebx,%edx
80107395:	89 44 24 04          	mov    %eax,0x4(%esp)
80107399:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010739c:	e8 af f8 ff ff       	call   80106c50 <mappages>
801073a1:	85 c0                	test   %eax,%eax
801073a3:	78 41                	js     801073e6 <copyuvm+0xa6>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801073a5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073ab:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801073ae:	76 50                	jbe    80107400 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801073b0:	8b 45 08             	mov    0x8(%ebp),%eax
801073b3:	31 c9                	xor    %ecx,%ecx
801073b5:	89 da                	mov    %ebx,%edx
801073b7:	e8 04 f8 ff ff       	call   80106bc0 <walkpgdir>
801073bc:	85 c0                	test   %eax,%eax
801073be:	74 5b                	je     8010741b <copyuvm+0xdb>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801073c0:	8b 30                	mov    (%eax),%esi
801073c2:	f7 c6 01 00 00 00    	test   $0x1,%esi
801073c8:	74 45                	je     8010740f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801073ca:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
801073cc:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
801073d2:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801073d5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
801073db:	e8 b0 b0 ff ff       	call   80102490 <kalloc>
801073e0:	85 c0                	test   %eax,%eax
801073e2:	89 c6                	mov    %eax,%esi
801073e4:	75 82                	jne    80107368 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801073e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073e9:	89 04 24             	mov    %eax,(%esp)
801073ec:	e8 9f fe ff ff       	call   80107290 <freevm>
  return 0;
801073f1:	31 c0                	xor    %eax,%eax
}
801073f3:	83 c4 2c             	add    $0x2c,%esp
801073f6:	5b                   	pop    %ebx
801073f7:	5e                   	pop    %esi
801073f8:	5f                   	pop    %edi
801073f9:	5d                   	pop    %ebp
801073fa:	c3                   	ret    
801073fb:	90                   	nop
801073fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107400:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107403:	83 c4 2c             	add    $0x2c,%esp
80107406:	5b                   	pop    %ebx
80107407:	5e                   	pop    %esi
80107408:	5f                   	pop    %edi
80107409:	5d                   	pop    %ebp
8010740a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010740b:	31 c0                	xor    %eax,%eax
8010740d:	eb e4                	jmp    801073f3 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
8010740f:	c7 04 24 be 7f 10 80 	movl   $0x80107fbe,(%esp)
80107416:	e8 45 8f ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010741b:	c7 04 24 a4 7f 10 80 	movl   $0x80107fa4,(%esp)
80107422:	e8 39 8f ff ff       	call   80100360 <panic>
80107427:	89 f6                	mov    %esi,%esi
80107429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107430 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107430:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107431:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107433:	89 e5                	mov    %esp,%ebp
80107435:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107438:	8b 55 0c             	mov    0xc(%ebp),%edx
8010743b:	8b 45 08             	mov    0x8(%ebp),%eax
8010743e:	e8 7d f7 ff ff       	call   80106bc0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107443:	8b 00                	mov    (%eax),%eax
80107445:	89 c2                	mov    %eax,%edx
80107447:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
8010744a:	83 fa 05             	cmp    $0x5,%edx
8010744d:	75 11                	jne    80107460 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010744f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107454:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107459:	c9                   	leave  
8010745a:	c3                   	ret    
8010745b:	90                   	nop
8010745c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107460:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107462:	c9                   	leave  
80107463:	c3                   	ret    
80107464:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010746a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107470 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	57                   	push   %edi
80107474:	56                   	push   %esi
80107475:	53                   	push   %ebx
80107476:	83 ec 1c             	sub    $0x1c,%esp
80107479:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010747c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010747f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107482:	85 db                	test   %ebx,%ebx
80107484:	75 3a                	jne    801074c0 <copyout+0x50>
80107486:	eb 68                	jmp    801074f0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107488:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010748b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010748d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107491:	29 ca                	sub    %ecx,%edx
80107493:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107499:	39 da                	cmp    %ebx,%edx
8010749b:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010749e:	29 f1                	sub    %esi,%ecx
801074a0:	01 c8                	add    %ecx,%eax
801074a2:	89 54 24 08          	mov    %edx,0x8(%esp)
801074a6:	89 04 24             	mov    %eax,(%esp)
801074a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801074ac:	e8 5f d6 ff ff       	call   80104b10 <memmove>
    len -= n;
    buf += n;
801074b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
801074b4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
801074ba:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801074bc:	29 d3                	sub    %edx,%ebx
801074be:	74 30                	je     801074f0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
801074c0:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801074c3:	89 ce                	mov    %ecx,%esi
801074c5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801074cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801074cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801074d2:	89 04 24             	mov    %eax,(%esp)
801074d5:	e8 56 ff ff ff       	call   80107430 <uva2ka>
    if(pa0 == 0)
801074da:	85 c0                	test   %eax,%eax
801074dc:	75 aa                	jne    80107488 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801074de:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
801074e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
801074e6:	5b                   	pop    %ebx
801074e7:	5e                   	pop    %esi
801074e8:	5f                   	pop    %edi
801074e9:	5d                   	pop    %ebp
801074ea:	c3                   	ret    
801074eb:	90                   	nop
801074ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074f0:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801074f3:	31 c0                	xor    %eax,%eax
}
801074f5:	5b                   	pop    %ebx
801074f6:	5e                   	pop    %esi
801074f7:	5f                   	pop    %edi
801074f8:	5d                   	pop    %ebp
801074f9:	c3                   	ret    
801074fa:	66 90                	xchg   %ax,%ax
801074fc:	66 90                	xchg   %ax,%ax
801074fe:	66 90                	xchg   %ax,%ax

80107500 <my_syscall>:
#include "types.h"
#include "defs.h"

int
my_syscall(char *str) 
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s\n", str);
80107506:	8b 45 08             	mov    0x8(%ebp),%eax
80107509:	c7 04 24 fc 7f 10 80 	movl   $0x80107ffc,(%esp)
80107510:	89 44 24 04          	mov    %eax,0x4(%esp)
80107514:	e8 37 91 ff ff       	call   80100650 <cprintf>
    return 0xABCDABCD;
}
80107519:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
8010751e:	c9                   	leave  
8010751f:	c3                   	ret    

80107520 <sys_my_syscall>:

int
sys_my_syscall(void) 
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	83 ec 28             	sub    $0x28,%esp
    char *str;
    if (argstr(0, &str) < 0) // wrapper 함수. 커널 내부에 reference가 호출 되고, argument가 user영역에 있는지 체크해주는 함수.
80107526:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107529:	89 44 24 04          	mov    %eax,0x4(%esp)
8010752d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80107534:	e8 97 d8 ff ff       	call   80104dd0 <argstr>
        return -1;
80107539:	ba ff ff ff ff       	mov    $0xffffffff,%edx

int
sys_my_syscall(void) 
{
    char *str;
    if (argstr(0, &str) < 0) // wrapper 함수. 커널 내부에 reference가 호출 되고, argument가 user영역에 있는지 체크해주는 함수.
8010753e:	85 c0                	test   %eax,%eax
80107540:	78 18                	js     8010755a <sys_my_syscall+0x3a>
#include "defs.h"

int
my_syscall(char *str) 
{
    cprintf("%s\n", str);
80107542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107545:	c7 04 24 fc 7f 10 80 	movl   $0x80107ffc,(%esp)
8010754c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107550:	e8 fb 90 ff ff       	call   80100650 <cprintf>
sys_my_syscall(void) 
{
    char *str;
    if (argstr(0, &str) < 0) // wrapper 함수. 커널 내부에 reference가 호출 되고, argument가 user영역에 있는지 체크해주는 함수.
        return -1;
    return my_syscall(str);
80107555:	ba cd ab cd ab       	mov    $0xabcdabcd,%edx
}
8010755a:	89 d0                	mov    %edx,%eax
8010755c:	c9                   	leave  
8010755d:	c3                   	ret    
8010755e:	66 90                	xchg   %ax,%ax

80107560 <getppid>:
#include "syscall.h"

int
getppid(void)
{
    return proc->parent->pid;
80107560:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
#include "x86.h"
#include "syscall.h"

int
getppid(void)
{
80107566:	55                   	push   %ebp
80107567:	89 e5                	mov    %esp,%ebp
    return proc->parent->pid;
}
80107569:	5d                   	pop    %ebp
#include "syscall.h"

int
getppid(void)
{
    return proc->parent->pid;
8010756a:	8b 40 14             	mov    0x14(%eax),%eax
8010756d:	8b 40 10             	mov    0x10(%eax),%eax
}
80107570:	c3                   	ret    
80107571:	eb 0d                	jmp    80107580 <sys_getppid>
80107573:	90                   	nop
80107574:	90                   	nop
80107575:	90                   	nop
80107576:	90                   	nop
80107577:	90                   	nop
80107578:	90                   	nop
80107579:	90                   	nop
8010757a:	90                   	nop
8010757b:	90                   	nop
8010757c:	90                   	nop
8010757d:	90                   	nop
8010757e:	90                   	nop
8010757f:	90                   	nop

80107580 <sys_getppid>:
#include "syscall.h"

int
getppid(void)
{
    return proc->parent->pid;
80107580:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
}

//Wrapper for getppid
int
sys_getppid(void)
{
80107586:	55                   	push   %ebp
80107587:	89 e5                	mov    %esp,%ebp
    return getppid();
}
80107589:	5d                   	pop    %ebp
#include "syscall.h"

int
getppid(void)
{
    return proc->parent->pid;
8010758a:	8b 40 14             	mov    0x14(%eax),%eax

//Wrapper for getppid
int
sys_getppid(void)
{
    return getppid();
8010758d:	8b 40 10             	mov    0x10(%eax),%eax
}
80107590:	c3                   	ret    
80107591:	66 90                	xchg   %ax,%ax
80107593:	66 90                	xchg   %ax,%ax
80107595:	66 90                	xchg   %ax,%ax
80107597:	66 90                	xchg   %ax,%ax
80107599:	66 90                	xchg   %ax,%ax
8010759b:	66 90                	xchg   %ax,%ax
8010759d:	66 90                	xchg   %ax,%ax
8010759f:	90                   	nop

801075a0 <getlev>:

// Design Document 1-1-2-3.
int
getlev(void)
{
    return proc->level_of_MLFQ;
801075a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
#include "proc.h"

// Design Document 1-1-2-3.
int
getlev(void)
{
801075a6:	55                   	push   %ebp
801075a7:	89 e5                	mov    %esp,%ebp
    return proc->level_of_MLFQ;
}
801075a9:	5d                   	pop    %ebp

// Design Document 1-1-2-3.
int
getlev(void)
{
    return proc->level_of_MLFQ;
801075aa:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
801075b0:	c3                   	ret    
801075b1:	eb 0d                	jmp    801075c0 <sys_getlev>
801075b3:	90                   	nop
801075b4:	90                   	nop
801075b5:	90                   	nop
801075b6:	90                   	nop
801075b7:	90                   	nop
801075b8:	90                   	nop
801075b9:	90                   	nop
801075ba:	90                   	nop
801075bb:	90                   	nop
801075bc:	90                   	nop
801075bd:	90                   	nop
801075be:	90                   	nop
801075bf:	90                   	nop

801075c0 <sys_getlev>:

// Design Document 1-1-2-3.
int
getlev(void)
{
    return proc->level_of_MLFQ;
801075c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
}

//Wrapper
int
sys_getlev(void)
{
801075c6:	55                   	push   %ebp
801075c7:	89 e5                	mov    %esp,%ebp
    return getlev();
}
801075c9:	5d                   	pop    %ebp

//Wrapper
int
sys_getlev(void)
{
    return getlev();
801075ca:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
801075d0:	c3                   	ret    

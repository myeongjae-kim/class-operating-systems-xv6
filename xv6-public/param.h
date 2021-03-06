#define NPROC        64  // maximum number of processes
#define KSTACKSIZE 4096  // size of per-process kernel stack
#define NCPU          8  // maximum number of CPUs
#define NOFILE       16  // open files per process
#define NFILE       100  // open files per system
#define NINODE       50  // maximum number of active i-nodes
#define NDEV         10  // maximum major device number
#define ROOTDEV       1  // device number of file system root disk
#define MAXARG       32  // max exec arguments
#define MAXOPBLOCKS  10  // max # of blocks any FS op writes
#define LOGSIZE      (MAXOPBLOCKS*3)  // max data blocks in on-disk log
#define NBUF         (MAXOPBLOCKS*3)  // size of disk block cache
// #define FSSIZE       1000  // size of file system in blocks
#define FSSIZE       2000// size of file system in blocks

// #define MJ_DEBUGGING       // just define. for debugging code
// #define STRIDE_DEBUGGING       // just define. for debugging code
// #define THREAD_DEBUGGING// just define. for debugging code
// #define TEMP_BUG// just define. for debugging code
// #define STRIDE2// just define. for debugging code
// #define FS_DEBUGGING// just define. for debugging code
// #define FS2// just define. for debugging code
#define NMLFQ         3  // the number of queues in MLFQ
#define NSTRIDE   100000  // Design Document 1-2-2-1. It will be divided by required cpu share.
#define NSTRIDE_QUEUE ( (NPROC) + (1) )  // the stride_queue_size
#define MIN_CPU_SHARE 1
#define MAX_CPU_SHARE 800

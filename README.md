# Subject: Operating Systems

This repository is a result of projects which I designed and implemented in Operating System class at Hanyang University. Most of the projects was adding new features to [xv6](https://github.com/mit-pdos/xv6-public), which is maintained by MIT. It was great time to understand operating systems which had seemed just like magic.

## Table of Contents

* [Project 0: Simple Unix Shell](#project-0-simple-unix-shell)
* [Project 1: MLFQ and Stride scheduling](#project-1-mlfq-and-stride-scheduling)
  * [MLFQ(Multi Level Feedback Queue)](#mlfqmulti-level-feedback-queue)
  * [Stride Scheduling](#stride-scheduling)
* [Project 2: Light\-weight Process (thread)](#project-2-light-weight-process-thread)
* [Project 3: File system](#project-3-file-system)

## [Project 0: Simple Unix Shell](#table-of-contents)

[Wiki](https://github.com/hrzon/Class_OperatingSystems_xv6/wiki/shell)

[Codes](https://github.com/hrzon/Class_OperatingSystems_xv6/blob/master/proj_shell/shell.c)

It was warming-up project. Mimicking simple unix shell taught me how programs are executed through system calls.

## [Project 1: MLFQ and Stride scheduling](#table-of-contents)

[Wiki](https://github.com/hrzon/Class_OperatingSystems_xv6/wiki/mlfqStride)

[Codes](https://github.com/hrzon/Class_OperatingSystems_xv6/tree/master/xv6-public)

By this project, I could understand common problem of scheduling. These knowledge can help me in any situation about distributing finite resources.

### [MLFQ(Multi Level Feedback Queue)](#table-of-contents)

MLFQ is an algorithm for scheduling processes. There are finite ticks at every queue. If a process uses all of the ticks, the process goes to the next level. Ticks of next level queue is larger than before level. If a process yield cpu resources before using all of the ticks, the process stays in current level queue.

Higher level queue has higher priority. If there are processes in higher level queues, processes in the lower level queues cannot be run.

To prevent starvation, priority boost function is called regularly. Priority boost is that every process is moved to lowest level.

### [Stride Scheduling](#table-of-contents)

Stride scheduling is invented to overcome unfairness of lottery scheduling.

Both stride and lottery scheduling are proportional-share resource management algorithms. Each process has a needing amount of cpu resource. Process will receive cpu resource by their needing amount.

In lottery algorithm, it is a remainder, which is a result of modulo operation about dividing arbitrary big number by random number, for selecting a process to be run. Because it uses rand() function, the algorithm is non-deterministic. There is a possibility of process starvation.

Stride scheduling overcomes this problem. 'Stride' is a number which is quotient of dividing arbitary big number by a process' CPU needing amount. If a cpu needs large amount of CPU resources, it has small 'stride'. If a cpu needs small amount of CPU resources, it has large 'stride'.

'Pass value' is sum of 'stide'. If a process is chosen to be run, 'pass value' incrases by the value of 'stride'. A 'pass value' of a process whose needing amount of CPU is small increases slowly. A 'pass value' of a process whose needing amount of CPU is large increases rapidly.

The scheduler chooses a process who has **smallest 'pass value'**; this algorithm operates like lottery algorithm without worry of starvation.

## [Project 2: Light-weight Process (thread)](#table-of-contents)

[Wiki](https://github.com/hrzon/Class_OperatingSystems_xv6/wiki/thread)

[Codes](https://github.com/hrzon/Class_OperatingSystems_xv6/tree/master/xv6-public)

There is a situation that concurrent processing shortens working time, but adding a new process is quite expensive. We can decrease the cost of adding a new process by using same virutal memory space between parent process and child process. A child process that is using same virtual memory space with parent process is called '**light-weight process**', or '**thread**'.

By implementing light-weight process in xv6, I learned how an operating system can provide an illusion to every process that they use whole hardware resources alone. Also recognized the advantages of using light-weight process than using a new process.

## [Project 3: File system](#table-of-contents)

[Wiki](https://github.com/hrzon/Class_OperatingSystems_xv6/wiki/filesystem)

[Codes](https://github.com/hrzon/Class_OperatingSystems_xv6/tree/master/xv6-public)

File is an abstraction of byte arrays in physical storage. 'inode' is the implementation of file. To control byte arrays of a files, there are direct pointers and indirect pointers in inode structure. What I did in this project is adding double indirect pointers to increase file's maximum size.

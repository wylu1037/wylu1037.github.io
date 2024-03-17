---
title: 🧑🏽‍💻 Interview
date: 2024-03-02T11:17:45+08:00
width: full
weight: 99
---

{{< callout >}}
{{< font type="yellow" text="面试系列" >}}
{{< /callout >}}

## Go

{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
Go 是一种静态类型、编译型的编程语言，Go 提供了垃圾收集、类型安全、动态接口等现代编程语言的特性，同时保持了高效的编译和执行速度。
{{< /hextra/hero-subtitle >}}
{{< cards >}}
{{< card link="/docs/interview/go/quiz-cahnnel" title="channel" subtitle= "gooutine是由go运行时管理的轻量级线程。通道是在程序之间进行通信的方式。" icon="go" >}}
{{< card link="/docs/interview/go/quiz-context" title="context" subtitle= "上下文是一种用于跟踪请求的数据结构，它可以在多个goroutine之间传递请求相关的数据、取消信号和截止时间等信息。上下文可以通过WithCancel、WithTimeout、WithDeadline等方法创建，可以用来控制goroutine的生命周期，实现超时处理、取消操作等。" icon="chat-alt-2" >}}
{{< card link="/docs/interview/go/quiz-defer" title="defer" subtitle= "defer关键字用于延迟执行函数调用，即在函数执行结束时执行某个函数，无论函数是正常返回还是发生了异常。defer通常用于资源的释放、文件的关闭、锁的释放等清理操作，可以确保这些清理操作在函数执行结束时一定会被执行，从而避免了资源泄露和错误处理的疏忽。" icon="clock" >}}
{{< card link="/docs/interview/go/quiz-string" title="string" subtitle= "string是一种表示文本数据的类型，用于存储字符串值。字符串是一系列Unicode字符（符文）的序列，可以包含任意Unicode字符，包括字母、数字、符号和控制字符等。在Go中，字符串是不可变的，即一旦创建就不能被修改。" icon="minus" >}}
{{< card link="/docs/interview/go/quiz-slice" title="slice" subtitle= "slice是一种灵活的、动态的数据结构，它可以实现类似于数组的操作，但是长度可以动态调整。Slice本质上是一个数组的视图，它提供了一种方便的方式来访问数组的部分元素，并且可以动态地增加或减少元素的数量。" icon="cards" >}}
{{< card link="/docs/interview/go/quiz-memory-alignment" title="memory alignment" subtitle= "内存对齐是一种优化策略，它可以提高内存访问效率和CPU性能。内存对齐是指在分配内存时，将变量的起始地址对齐到某个边界的过程。这个边界通常是变量的大小或者CPU的缓存行大小。" icon="chip" >}}
{{< card link="/docs/interview/go/quiz-map" title="map" subtitle= "map是一种用于存储键值对的数据结构，也被称为字典或关联数组。它提供了一种高效的方式来存储和检索数据，类似于其他编程语言中的哈希表。" icon="table" >}}
{{< card link="/docs/interview/go/quiz-closure" title="closure" subtitle= "闭包是一种非常灵活和强大的编程概念，在Go语言中被广泛应用于实现各种功能和模式。通过闭包，可以实现状态封装、延迟执行、函数式编程等功能，从而使得代码更加简洁、灵活和可复用。" icon="archive" >}}
{{< card link="/docs/interview/go/quiz-panic-and-recover" title="panic and recover" subtitle= "panic用于表示程序发生了严重的错误，导致程序无法继续执行。recover用于从panic异常中恢复程序的执行。在defer语句中调用recover函数可以捕获当前函数的panic异常，并阻止其向上传播。" icon="play" >}}
{{< card link="/docs/interview/go/quiz-reflect" title="reflect" subtitle= "反射是一种在运行时检查和操作程序结构、类型和变量的机制。通过反射，我们可以动态地检查变量的类型、获取变量的值、调用函数、修改结构体字段等操作，而不需要在编译时知道这些信息。" icon="banknotes" >}}
{{< card link="/docs/interview/go/quiz-generic" title="generic" subtitle= "泛型是一种编程范式，它允许在编写代码时不指定具体的数据类型，而是使用参数化的方式来处理不同类型的数据。在Go语言中，泛型可以提高代码的复用性、灵活性和安全性，让程序员能够更轻松地编写通用的数据结构和算法。" icon="selector" >}}
{{< card link="/docs/interview/go/quiz-type-assertion" title="type assertion" subtitle= "类型断言用于判断接口值的实际类型，并将其转换为对应的具体类型。类型断言的作用在于使得程序能够在运行时动态地确定接口值的具体类型，并且在需要时将其转换为指定的类型进行操作。" icon="terminal" >}}
{{< card link="/docs/interview/go/quiz-interface" title="interface" subtitle= "接口是一种定义对象行为的方式，它定义了一组方法的集合，而不是字段。接口提供了一种抽象的方式来描述对象的行为，而不关心具体的类型。通过接口，可以实现多态性，使得不同类型的对象可以以相同的方式进行处理，从而提高了代码的灵活性和可复用性。" icon="api" >}}
{{< card link="/docs/interview/go/quiz-mutex" title="mutex" subtitle= "互斥锁是一种用于保护共享资源的并发控制机制。Mutex可以确保在同一时刻只有一个goroutine能够访问共享资源，从而避免了多个goroutine同时访问共享资源时可能出现的竞态条件和数据竞争问题。" icon="lock-closed" >}}
{{< card link="/docs/interview/go/quiz-memory-escape" title="memory escape" subtitle= "内存逃逸是编译器在编译阶段进行的一种优化技术，用于确定变量的分配位置（栈上还是堆上）。当一个变量在函数内部被声明时，编译器会根据变量的生命周期和使用方式来决定将其分配到栈上还是堆上。" icon="logout" >}}
{{< card link="/docs/interview/go/quiz-gc" title="GC" subtitle= "垃圾回收（Garbage Collection）是一种自动内存管理机制，用于检测和回收不再使用的内存对象，以防止内存泄漏和提高程序的性能和稳定性。" icon="trash" >}}
{{< /cards >}}

## Network

{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
TCP & HTTP & IP
{{< /hextra/hero-subtitle >}}

{{< cards >}}
{{< card link="/docs/interview/network/proficient-in-http" title="精通HTTP" subtitle= "HTTP代表超文本传输协议。它是用于在万维网上发送和接收信息的应用层协议。HTTP是web上数据通信的基础，是网站和web应用程序运行的基本协议。" icon="endpoints" >}}
{{< card link="/docs/interview/network/proficient-in-tcp" title="精通TCP" subtitle= "TCP在网络上的两个设备之间提供可靠的、面向连接、基于字节流的通信。TCP代表传输控制协议。它是Internet协议(IP)套件中的主要协议之一，在OSI模型的传输层(第4层)运行。" icon="tcp-ip-service" >}}
{{< card link="/docs/interview/network/proficient-in-ip" title="精通 IP" subtitle= "IP（Internet Protocol）地址是一个用于标识网络中设备位置的数字标签。在互联网上，IP 地址允许数据从源传输到目的地，确保网络上的设备，比如计算机、移动设备、服务器等能够彼此通信。IP 地址是互联网工作的基础之一，它分为两个主要版本：IPv4 和 IPv6。" icon="network" >}}
{{< /cards >}}

## OS

{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
操作系统的主要功能包括管理计算机的硬件资源（如 CPU、内存、存储设备和输入输出设备）、管理文件系统、提供用户界面和执行软件应用程序。
{{< /hextra/hero-subtitle >}}

{{< cards >}}
{{< card link="" title="硬件结构" subtitle="硬件结构通常包括以下几个主要部分：中央处理器（CPU）、内存（RAM）、硬盘（磁盘）、输入/输出设备（I/O设备）、总线（Bus）。" icon="table" >}}
{{< card link="" title="操作系统结构" subtitle="操作系统（OS）的结构通常分为四个主要组成部分：内核（Kernel）、进程管理（Process Management）、内存管理（Memory Management）、文件系统（File System）。" icon="linux" >}}
{{< card link="" title="内存管理" subtitle="操作系统的内存管理是指操作系统对计算机内存资源的有效利用和管理。它包括以下几个方面：内存分配、内存保护、内存映射、虚拟内存、内存回收。" icon="memory" >}}
{{< card link="" title="进程管理" subtitle="操作系统的进程管理是指操作系统对进程的创建、调度、同步、通信、销毁等管理工作。" icon="terminal" >}}
{{< card link="" title="调度算法" subtitle="操作系统的调度算法是指操作系统内核根据不同的调度策略，决定如何安排和分配CPU资源给各个进程或线程。常见的调度算法包括以下几种：先来先服务（First Come, First Served，FCFS）、短作业优先（Shortest Job First，SJF）、优先级调度（Priority Scheduling）、轮转调度（Round Robin）、多级反馈队列调度（Multilevel Feedback Queue，MLFQ）、最高响应比优先调度（Highest Response Ratio Next，HRRN）、最短剩余时间优先（Shortest Remaining Time First，SRTF）。" icon="key" >}}
{{< card link="" title="文件系统" subtitle="操作系统的文件系统是一种组织和管理计算机存储数据的机制。它通常包含以下几个重要的部分：文件和目录结构、文件访问方式、存储管理、文件系统类型、文件系统操作。" icon="folder" >}}
{{< card link="" title="设备管理" subtitle="操作系统的设备管理是指操作系统对计算机系统中各种硬件设备的管理和控制。它涉及到设备的初始化、分配、调度、中断处理、驱动程序等方面，以确保各种硬件设备能够协调工作，为应用程序提供所需的服务。" icon="server" >}}
{{< card link="" title="网络系统" subtitle="操作系统的网络系统是指操作系统提供的网络通信功能和管理网络资源的部分。它包括了操作系统中的网络协议栈、网络设备驱动程序、网络连接管理、数据传输控制等功能。" icon="network" >}}
{{< card link="" title="Linux命令" subtitle="Linux操作系统提供了丰富的命令行工具，用于执行各种系统管理和操作任务。" icon="code" >}}
{{< /cards >}}

## Database

{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
数据库
{{< /hextra/hero-subtitle >}}
{{< cards >}}
{{< card link="" title="MySql" subtitle="10分钟了解硬件结构" icon="table" >}}
{{< card link="" title="PostgreSQL" subtitle="10分钟了解硬件结构" icon="table" >}}
{{< card link="" title="Redis" subtitle="10分钟了解硬件结构" icon="table" >}}
{{< /cards >}}

## Middleware

{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
中间件
{{< /hextra/hero-subtitle >}}
{{< cards >}}
{{< card link="" title="消息队列" subtitle="10分钟了解硬件结构" icon="table" >}}
{{< card link="" title="Nginx" subtitle="10分钟了解硬件结构" icon="table" >}}
{{< card link="" title="API网关" subtitle="10分钟了解硬件结构" icon="table" >}}
{{< /cards >}}

## System Design

https://github.com/Sairyss/system-design-patterns?tab=readme-ov-file#system-design-patterns

https://github.com/donnemartin/system-design-primer

## System Architecture

{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
🎯 建设中
{{< /hextra/hero-subtitle >}}

## DevOps

{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
Interview questions about DevOps
{{< /hextra/hero-subtitle >}}
{{< cards >}}
{{< card link="" title="Kubernetes" subtitle= "A goroutine is a lightweight thread managed by the Go runtime. Channels is how you communicate between routines." icon="kubernetes" >}}
{{< card link="https://kuboard.cn/" title="Kuboard for K8S" subtitle= "A goroutine is a lightweight thread managed by the Go runtime. Channels is how you communicate between routines." icon="kubernetes" >}}
{{< card link="https://github.com/derailed/k9s" title="K9S" subtitle= "A goroutine is a lightweight thread managed by the Go runtime. Channels is how you communicate between routines." icon="kubernetes" >}}
{{< /cards >}}

---
title: 定位内存泄露
date: 2024-03-30T20:35:27+08:00
categories: [java]
tags: [java, memory, leak]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

在故障定位(尤其是 `out of memory` )和性能分析的时候，经常会用到一些文件辅助我们排除代码问题。这些文件记录了 `JVM` 运行期间的内存占用、线程执行等情况，这就是常说的 `dump` 文件。常用的有 `heap dump` 和 `thread dump`（也叫 `javacore`，或 `java dump`）。可以这么理解：`heap dump` 记录内存信息的，`thread dump` 记录 `CPU` 信息。

`heap dump`： `heap dump` 文件是一个二进制文件，它保存了某一时刻 `JVM` 堆中对象使用情况。`HeapDump` 文件是指定时刻的 `Java` 堆栈的快照，是一种镜像文件。

## 什么是内存溢出

{{< image "/images/blog/java/jvm内存.webp" "内存管理架构" >}}

`JVM` 根据 `generation`<sub> 代 </sub>来进行 `GC`，根据上图所示，一共被分为 `young generation`<sub> 年轻代</sub>、`tenured generation`<sub> 老年代</sub>。

{{< image "/images/blog/java/jvm三代分配.webp" "比例分配" >}}

绝大多数的对象都在 `young generation` 被分配，也在 `young generation` 被收回，当 `young generation` 的空间被填满，GC 会进行 `minor collection` <sub>次回收</sub>，速度非常快。其中，`young generation` 中未被回收的对象被转移到 `tenured generation`，当 `tenured generation` 被填满时，即触发 `major collection` <sub>FULL GC 主回收</sub>，整个应用程序都会停止下来直到回收完成。

## 解决

### 第一种

{{< steps >}}

<h5></h5>
`jstat` 命令查看虚拟机中内存区域的使用情况和GC情况
<h5></h5>
`dump` 当前内存
<h5></h5>
MAT 工具分析内存（或者在线的jmap）
{{< /steps >}}

### arthas

- 观察内存使用情况：`dashboard`；
- 查看内存 Dump：`jmap`；
- 分析内存 Dump
- 查看 GC 日志：`gc`

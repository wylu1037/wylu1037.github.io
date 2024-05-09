---
title: 基础篇
date: 2024-04-14T21:51:58+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 1
---

## 1.MySql 执行流程

{{< image "/images/docs/interview/database/mysql/mysql查询流程.webp" "MySql执行流程图" >}}

**_MySQL_** 的架构共分为两层：**Server** 层和 **存储引擎** 层：

- {{< font "blue" "Server 层负责建立连接、分析和执行 SQL。" >}}MySQL 大多数的核心功能模块都在这实现，主要包括连接器，查询缓存、解析器、预处理器、优化器、执行器等。另外，所有的内置函数（如日期、时间、数学和加密函数等）和所有跨存储引擎的功能（如存储过程、触发器、视图等。）都在 Server 层实现。
- {{< font "blue" "存储引擎层负责数据的存储和提取。" >}}支持 InnoDB、MyISAM、Memory 等多个存储引擎，不同的存储引擎共用一个 Server 层。现在最常用的存储引擎是 InnoDB，从 MySQL 5.5 版本开始， InnoDB 成为了 MySQL 的默认存储引擎。常说的索引数据结构，就是由存储引擎层实现的，不同的存储引擎支持的索引类型也不相同，比如 InnoDB 支持索引类型是 `B+` 树 ，且是默认使用，也就是说在数据表中创建的主键索引和二级索引默认使用的是 `B+` 树索引。

## 2.如何存储一行记录

### 2.1 表空间文件的结构

表空间由 **段<sub> segment</sub>**、**区<sub> extent</sub>**、**页<sub> page</sub>**、**行<sub> row</sub>** 组成，InnoDB 存储引擎的逻辑存储结构大致如下图：
{{< image "/images/docs/interview/database/mysql/表空间结构.webp" "表空间结构">}}

{{< tabs items="行,页,区,段">}}

{{< tab >}}
数据库表中的记录都是按行 <sub>**row**</sub> 进行存放的，每行记录根据不同的行格式，有不同的存储结构。
{{< /tab >}}

{{< tab >}}
记录是按照行来存储的，但是数据库的读取并不以 `行` 为单位，否则一次读取（也就是一次 `I/O` 操作）只能处理一行数据，效率会非常低。因此，`InnoDB` 的数据是按 `页` 为单位来读写的，也就是说，当需要读一条记录的时候，并不是将这个行记录从磁盘读出来，而是以页为单位，将其整体读入内存。默认每个页的大小为 **_16KB_**，也就是最多能保证 **_16KB_** 的连续存储空间。

页是 `InnoDB` 存储引擎磁盘管理的最小单元，意味着数据库每次读写都是以 **_16KB_** 为单位的，一次最少从磁盘中读取 **_16K_** 的内容到内存中，一次最少把内存中的 **_16K_** 内容刷新到磁盘中。

页的类型有很多，常见的有数据页、undo 日志页、溢出页等等。数据表中的行记录是用 **数据页** 来管理的，数据页的结构这里我就不讲细说了，之前文章有说过，感兴趣的可以去看这篇文章：换一个角度看 B+ 树

总之知道表中的记录存储在「数据页」里面就行。

{{< /tab >}}

{{< tab >}}
`InnoDB` 存储引擎是用 `B+` 树来组织数据的。`B+`树中每一层都是通过双向链表连接起来的，如果是以页为单位来分配存储空间，那么链表中相邻的两个页之间的物理位置并不是连续的，可能离得非常远，那么磁盘查询时就会有大量的随机`I/O`，随机 `I/O` 是非常慢的。

解决这个问题也很简单，就是让链表中相邻的页的物理位置也相邻，这样就可以使用顺序 `I/O` 了，那么在范围查询（扫描叶子节点）的时候性能就会很高。

<br/>
{{< font "blue" "即在表中数据量大的时候，为某个索引分配空间的时候就不再按照页为单位分配了，而是按照区（extent）为单位分配。每个区的大小为 1MB，对于 16KB 的页来说，连续的 64 个页会被划为一个区，这样就使得链表中相邻的页的物理位置也相邻，就能使用顺序 I/O 了。">}}
{{< /tab >}}

{{< tab >}}
表空间是由各个段（segment）组成的，段是由多个区（extent）组成的。段一般分为数据段、索引段和回滚段等。

- 索引段：存放 B + 树的非叶子节点的区的集合；
- 数据段：存放 B + 树的叶子节点的区的集合；
- 回滚段：存放的是回滚数据的区的集合，之前讲事务隔离 (opens new window)的时候就介绍到了 MVCC 利用了回滚段实现了多版本查询数据。
  {{< /tab >}}

{{< /tabs>}}

### 2.2 InnoDB 行格式

行格式就是一条记录的存储结构。InnoDB 提供了 4 种行格式，分别是 **_Redundant_**、**_Compact_**、**_Dynamic_** 和 **_Compressed_** 行格式。

### 2.3 COMPACT 行格式

{{< image "/images/docs/interview/database/mysql/COMPACT.webp" "Compact行格式" >}}

#### 2.3.1 额外数据

##### 2.3.1.1 变长字段长度列表

##### 2.3.1.2 NULL 值列表

表中的某些列可能会存储 `NULL` 值，如果把这些 `NULL` 值都放到记录的真实数据中会比较浪费空间，所以 Compact 行格式把这些值为 `NULL` 的列存储到 `NULL` 值列表中。

如果存在允许 NULL 值的列，则每个列对应一个二进制位（bit），二进制位按照列的顺序{{< font "orange" "逆序排列" >}}。

- 二进制位的值为 **1** 时，代表该列的值为 NULL。
- 二进制位的值为 **0** 时，代表该列的值不为 NULL。

{{< callout >}}
另外，NULL 值列表必须用整数个字节的位表示（1 字节 8 位），如果使用的二进制位个数不足整数个字节，则在字节的高位补 0。
{{< /callout >}}

以 user 表的这三条记录作为例子：
{{< image "/images/docs/interview/database/mysql/t_user表.webp" "User表" >}}

{{< tabs items="第一行数据Null值列表,第二行数据Null值列表,第三行数据Null值列表" >}}
{{< tab >}}
{{< image "/images/docs/interview/database/mysql/user表第一条数据null值列表.webp" "第一条数据null值列表" >}}
{{< /tab >}}

{{< tab >}}
{{< image "/images/docs/interview/database/mysql/user表第二条数据null值列表.webp" "第二条数据null值列表" >}}
{{< /tab >}}

{{< tab >}}
{{< image "/images/docs/interview/database/mysql/user表第三条数据null值列表.webp" "第三条数据null值列表" >}}
{{< /tab >}}

{{< /tabs >}}

表行格式如下：
{{< image "/images/docs/interview/database/mysql/user表Null值列表行格式.webp" "user表Null值列表行格式" >}}

当数据表的字段都定义成 `NOT NULL` 的时候，这时候表里的行格式就不会有 `NULL` 值列表了。

#### 2.3.2 真实数据

### 2.4 varchar(n)

### 2.5 行溢出

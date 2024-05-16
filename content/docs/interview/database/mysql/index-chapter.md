---
title: 索引篇
date: 2024-04-14T21:53:04+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 2
---

## 1.面试

### 1.1 索引的分类

| 依据     | 分类                                       |
| -------- | ------------------------------------------ |
| 数据结构 | B+tree 索引、Hash 索引、Full-text 索引     |
| 物理存储 | 聚簇索引（主键索引）、二级索引（辅助索引） |
| 字段特性 | 主键索引、唯一索引、普通索引、前缀索引     |
| 字段个数 | 单列索引、联合索引                         |

### 1.2 创建索引

### 1.3 索引优化

## 2.B+树

### 2.1 InnoDB 如何存储数据

记录是按 **行** 来存储的，但是数据库的读取并不以 行 为单位，因此 InnoDB 的数据是按 **数据页** 为单位来读写的。数据库的 I/O 操作的最小单位是页，InnoDB 数据页的默认大小是 **_16_** KB。
{{< image "/images/docs/interview/database/mysql/数据页结构.webp" "数据页" >}}

| 名称               | 说明                                                               |
| ------------------ | ------------------------------------------------------------------ |
| File Header        | 文件头：表示页的信息                                               |
| Page Header        | 页头：表示页的状态信息                                             |
| Infimum + Supremum | 最小和最大记录：两个虚拟的伪记录，分别表示页中的最小记录和最大记录 |
| User Records       | 用户记录：存储行记录内容                                           |
| Free Space         | 空闲空间：页中还没被使用的空间                                     |
| Page Directory     | 页目录：存储用户记录的相对位置，对记录起到索引作用                 |
| File Tailer        | 文件尾：校验页是否完整                                             |

在 **File Header** 中有两个指针，分别指向上一个数据页和下一个数据页，连接起来的页相当于一个双向的链表，如下图所示：

{{< image "/images/docs/interview/database/mysql/FileHeader的指针.webp" "FileHeader的指针" >}}

采用链表的结构是让数据页之间不需要是物理上的连续的，而是逻辑上的连续。

数据页中的记录按照 **主键** 顺序组成单向链表，单向链表检索效率低。因此，数据页中有一个页目录，起到记录的索引作用。

{{< image "/images/docs/interview/database/mysql/页目录与记录.webp" "页目录与记录" >}}

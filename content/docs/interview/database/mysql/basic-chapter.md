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

 ***MySQL*** 的架构共分为两层：**Server** 层和 **存储引擎** 层：

+ {{< font "blue" "Server 层负责建立连接、分析和执行 SQL。" >}}MySQL 大多数的核心功能模块都在这实现，主要包括连接器，查询缓存、解析器、预处理器、优化器、执行器等。另外，所有的内置函数（如日期、时间、数学和加密函数等）和所有跨存储引擎的功能（如存储过程、触发器、视图等。）都在 Server 层实现。
+ {{< font "blue" "存储引擎层负责数据的存储和提取。" >}}支持 InnoDB、MyISAM、Memory 等多个存储引擎，不同的存储引擎共用一个 Server 层。现在最常用的存储引擎是 InnoDB，从 MySQL 5.5 版本开始， InnoDB 成为了 MySQL 的默认存储引擎。常说的索引数据结构，就是由存储引擎层实现的，不同的存储引擎支持的索引类型也不相同，比如 InnoDB 支持索引类型是 `B+` 树 ，且是默认使用，也就是说在数据表中创建的主键索引和二级索引默认使用的是 `B+` 树索引。


## 2.如何存储一行记录

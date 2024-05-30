---
title: 面试篇
date: 2024-04-14T21:58:16+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 1
---

**Redis** 是一种基于内存的数据库，对数据的读写操作都是在内存中完成，因此 {{< font "blue" "读写速度非常快" >}}，常用于 <u>缓存</u>，<u>消息队列</u>、<u>分布式锁</u>等场景。

**Redis** 提供了多种数据类型来支持不同的业务场景，比如 String <sub>字符串</sub>、Hash <sub>哈希</sub>、 List <sub>列表</sub>、Set <sub>集合</sub>、Zset <sub>有序集合</sub>、Bitmaps <sub>位图</sub>、HyperLogLog <sub>基数统计</sub>、GEO <sub>地理信息</sub>、Stream <sub>流</sub>，并且对数据类型的操作都是原子性的，因为执行命令由 **单线程** 负责的，不存在并发竞争的问题。

除此之外，**Redis** 还支持{{< font "blue" "事务" >}}、{{< font "blue" "持久化" >}}、{{< font "blue" "Lua 脚本" >}}、{{< font "blue" "多种集群方案" >}} <sub>**1.主从复制模式**、**2.哨兵模式**、**3.切片机群模式**</sub>、{{< font "blue" "发布/订阅模式" >}}，{{< font "blue" "内存淘汰机制" >}}、{{< font "blue" "过期删除机制" >}}等等。

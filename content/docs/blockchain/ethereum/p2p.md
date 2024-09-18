---
title: p2p网络
date: 2024-03-30T18:10:14+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

https://github.com/ethereum/devp2p?tab=readme-ov-file


## 1.Kad 算法
`Kademlia` 算法，一种分布式哈希表(DHT，Distributed Hash Table)的实现。DHT 技术是去中心化 P2P 网络中最核心的一种路由寻址技术，可以在无中心服务器（trackerless）的情况下，在网络中快速找到目标节点。Kademlia算法为DHT的一种实现，应用于 `IPFS`、`eMule`、`BitTorrent` 等。

### 1.1 什么是分布式哈希表
哈希表可看作一个kv数据库，分布式哈希表就是不同的kv在不同的机器上。下文称存储部分kv的一台机器为一个节点。

对于一个DHT，最基础的是要提供两个功能：1、存储一个kv；2、输入一个key，返回对应的value。

### 1.2 关键部分
+ **Node ID**：在 P2P 网络中， 节点是通过唯一 ID 来进行标识的，在原始的 Kad 算法中，使用 `160 bit` 哈希空间来作为 Node ID。
+ **Node Distance**： 每个节点保存着自己附近（nearest）节点的信息，但是在 Kademlia 中，这个距离不是指物理距离，而是指一种逻辑距离，通过异或运算得知。
+ **XOR**：异或运算，XOR 是一种位运算，用于计算两个节点之间距离的远近。把两个节点的 Node ID 进行 XOR 运算，XOR 的结果越小，表示距离越近。
+ **K-Bucket**：用一个 Bucket 来保存与当前节点距离在某个范围内的所有节点列表，比如 bucket0, bucket1, bucket2 ... bucketN 分别记录[1, 2), [2, 4), [4, 8), ... [2^i, 2^(i+1)) 范围内的节点列表；
+ **Bucket 分裂**：如果初始 bucket 数量不够，则需要分裂（和实现有关）。
+ **Routing Table**： 记录所有 buckets，每个 bucket 限制最多保存 k 个节点，如下图：
+ **Update**： 在节点 bootstrap 过程中，需要把连接上的 peer 节点更新到自己的 Routing table 中对应的 bucket 中；
+ **LookUp**：查找目标节点，找到与目标节点最近（nearest/closest）的 bucket，如果已在 bucket 中，则直接返回，否则向该 bucket 中的节点发送查询请求，这些节点继续迭代查找；
+ **收敛 & 时间复杂度**：查找会最终收敛至目标节点，整个查询过程复杂度是 Log N；

## 2.Discv4
以太坊早期版本采用了一种基于Kademlia改进的节点发现协议，通常称为Discv4。这个协议允许节点通过交换一种特殊的标识符（节点ID）来发现和建立与其他节点的连接。

## 3.Discv5(ENR)
随着时间和技术的发展，以太坊社区开始着手开发并测试Discv5协议，这是一个全新的节点发现协议，基于Ethereum Node Records (ENR)。ENR引入了更先进的加密身份认证和安全机制，增强了节点之间的隐私保护和网络的安全性。

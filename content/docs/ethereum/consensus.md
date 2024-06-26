---
title: 共识算法
date: 2024-03-20T09:07:21+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

{{< cards >}}

<div style="grid-column: 1 / span 3">
{{< card link="https://www.sciencedirect.com/science/article/pii/S240595951930164X" title="Analysis of the main consensus protocols of blockchain" subtitle= "Blockchain is the core technology of many cryptocurrencies. Blockchain as a distributed ledger technology has received extensive research attention. In addition to cryptography and P2P (peer-to-peer) technology, consensus protocols are also a fundamental part of the blockchain technology. A good consensus protocol can guarantee the fault tolerance and security of the blockchain systems. The consensus protocols currently used in most blockchain systems can be broadly divided into two categories: the probabilistic-finality consensus protocols and the absolute-finality consensus protocols. This paper introduces some of the main consensus protocols of these two categories, and analyzes their strengths and weaknesses as well as the applicable blockchain types." icon="academic-cap" >}}
</div>
{{< /cards >}}

## 1.PoW

工作量证明 PoW（Proof of Work），通过算力的比拼来选取一个节点，由该节点决定下一轮共识的区块内容（记账权）。PoW 要求节点消耗自身算力尝试不同的随机数（nonce），从而寻找符合算力难度要求的哈希值，不断重复尝试不同随机数直到找到符合要求为止，此过程称为“挖矿”。具体的流程如下图：
{{< image "/images/docs/eth/pow-ethash.webp" "PoW Ethash算法" >}}
第一个找到合适的 nonce 的节点获得记账权。节点生成新区块后广播给其他节点，其他节点对此区块进行验证，若通过验证则接受该区块，完成本轮共识，否则拒绝该区块，继续寻找合适的 nonce。

挖矿难度（Difficulty）决定了矿工需要找到一个有效区块哈希所要求的最低难度阈值（也称为目标值，Target）。难度会根据网络算力的变化自动调整，以维持平均每15秒产生一个新区块的目标速率。具体来说：

{{< callout >}}
**难度调整算法**
- 以太坊使用了一种递归式难度调整算法（ Dagger-Hashimoto 算法的组成部分），这种算法根据最近的出块时间来动态调整难度。
- 如果过去一段时间内的出块速度过快（即区块产生的平均时间小于15秒），难度将会增加，使得矿工需要更高的计算能力才能找到满足条件的哈希值。
- 反之，如果出块速度过慢，则难度会适当降低，以便矿工更容易找到下一个区块，从而加快出块速度。

**目标值（Target）**
+ 目标值是一个特定的数值，矿工需要找到一个低于此目标值的区块头哈希，以此证明他们完成了足够的工作量。
+ 难度越高，对应的目标值就越小，意味着矿工需要寻找的哈希值范围越窄，因此找到有效哈希的难度也就越大。
{{< /callout >}}

随着以太坊过渡到了以太坊2.0（Eth2）和权益证明（Proof-of-Stake, PoS）机制，出块时间的控制方式发生了变化。在PoS系统中，验证者不再通过计算哈希而是通过质押ETH来竞争创建新区块的权利，出块时间和难度调整由 {{< font "blue" "信标链（Beacon Chain）" >}} 的内置算法来管理，该算法设计也有利于保持稳定的出块时间间隔。

## 2.PoS

PoW 要求所有的节点消耗大量的算力来争夺记账权，但在每一轮共识中，只有一个节点的工作量有效，意味着有大量的资源被浪费，因此，权益证明机制 Proof of Stake（PoS）在 2013 年被提出并首次应用在 PeerCoin 系统中，目的是解决资源浪费的问题。
在 PoS (Proof-of-Stake) 共识中，节点争夺记账权依靠的不是算力而是权益（代币）。PoS 同样需要计算哈希值，但与 PoW 不同的是，不需要持续暴力计算寻找 nonce 值，具体流程如下：
{{< image "/images/docs/eth/pos.webp" "PoS" >}}
每个节点在每一轮共识中只需要计算一次 Hash，当拥有的权益越多，满足 Hash 目标的机会越大，获得记账权的机会越大。可以说，PoS 是一个资源节省的共识协议。PeerCoin 定义的权益除了与代币数量有关，引入了币龄（Coin Age），100 个代币持有两天，币龄为 200，因此持有的代币数量越多，时间越长，获得记账权的机会越大。

## 3.DPoS

委托权益证明 Delegate Proof of Stake（DPoS）， 是由 PoS 演化而来的。持币用户通过抵押代币获得选票，以投票的方式选出若干的节点作为区块生产者，代表持币用户履行产生区块的义务。DPoS 与公司董事会制度相似，让持币用户将生产区块的工作委托给更有能力胜任的专业人士去完成，同时也能享受参与出块获得的奖励。
{{< image "/images/docs/eth/dpos.webp" "DPoS" >}}
用户投票最多的若干节点成为出块节点，以 EOS 为代表是 21 个节点。在每一轮共识中，轮流选出一个出块节点产生区块，并广播给其他的出块节点进行验证。若节点在规定时间内无完成出块，或产生无效区块，会被取消资格，取而代之的是重新投票选取新的出块节点。

值得一提的是，EOS 初期的 DPoS 的共识方法才采用的是最长链共识，意味着与 PoW 一样区块没有绝对的最终性，交易的不可逆需要等待多个区块确认。在 18 年时，EOS 使用拜占庭共识代替最长链共识，名为 BFT-DPoS。

## 4.BFT
Byzantine Fault Tolerance
拜占庭将军问题

## 5.PBFT
实用拜占庭容错算法（Practical Byzantine Fault Tolerance），

## 6.FBFT

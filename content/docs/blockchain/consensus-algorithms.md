---
title: 共识算法
date: 2024-09-18T09:26:23+08:00
weight: 5
---

## 2.CFT类共识算法
非拜占庭容错通常指能够容忍部分区块链节点出现宕机错误，但不容忍出现不可预料的恶意行为导致的系统故障。常见的CFT共识算法有Paxos、Raft等。

## 3.BFT类共识算法
拜占庭容错强调的是能够容忍部分区块链节点由于硬件错误、网络拥塞或断开以及遭到恶意攻击等情况出现的不可预料的行为。BFT系列算法是典型的拜占庭容错算法，比如PBFT、HotStuff等。

### 3.1 RBFT
RBFT（Redundant Byzantine Fault Tolerance）是属于BFT（拜占庭容错）类算法。它扩展了传统BFT算法，通过引入冗余机制来提高系统的性能和可靠性，即使在存在一部分节点故障或恶意行为时，仍能确保达成一致性。RBFT 强调在处理拜占庭故障时的高效性和稳健性。

#### 日志同步
{{< image "/images/docs/blockchain/Raft-synclog.webp" "日志同步" >}}

{{% steps %}}
<h5></h5>
Client将transaction发给任意一个节点；
<h5></h5>
节点接收到的transaction后，将其封装在一个Propose提案中，并抛给Leader节点；
<h5></h5>
Leader节点收到新区块的提案消息后，将提案信息（即log entry）append到自己的log日志集中，并广播对应的log entry给Follower节点；
<h5></h5>
Follower节点接收到Leader节点的 log entry消息后，将其append到自己的log中，并向Leader发送append response消息，表明自己已经收到该log entry并同意其排序；
<h5></h5>
Leader节点收到n/2+1个append response消息后，该 log entry达到committed状态（此时Leader可apply log entry中的transaction并写入区块）；
<h5></h5>
Leader节点再次广播append 消息给Follower节点，通知其他节点该log entry已经是committed状态；
<h5></h5>
Follower节点接收到Leader节点的append消息后，该log entry达到committed状态，随后可apply该log entry中的transaction并写入区块。
<h5></h5>
继续处理下一次Request。
{{% /steps %}}

#### 3.1.1 共识流程
{{< image "/images/docs/blockchain/RBFT-consensus-process.png" "共识流程" >}}
{{% steps %}}
<h5></h5>
客户端Client将交易发送到区块链中的任意节点；
<h5></h5>
Replica节点接收到交易之后转发给Primary节点，Primary自身也能直接接收交易消息；
<h5></h5>
Primary会将收到的交易进行打包，生成batch进行验证，剔除其中的非法交易；
<h5></h5>
<strong style="color: #1d4ed8;">三阶段第一阶段</strong>：Primary将验证通过的batch构造PrePrepare消息广播给其他节点，这里只广播批量交易的哈希值；
<h5></h5>
<strong style="color: #1d4ed8;">三阶段第二阶段</strong>：Replica接收来自Primary的PrePrepare消息之后构造Prepare消息发送给其他Replica节点，表明该节点接收到来自主节点的PrePrepare消息并认可主节点的batch排序；
<h5></h5>
<strong style="color: #1d4ed8;">三阶段第三阶段</strong>：Replica接收到2f个节点的Prepare消息之后对batch的消息进行合法性验证，验证通过之后向其他节点广播Commit消息，表示自己同意了Primary节点的验证结果；
<h5></h5>
Replica节点接收到2f+1个Commit之后执行batch中的交易并同主节点的执行结果进行验证，验证通过将会写入本地账本，并通过checkpoint检查点来进行结果校验的步骤，检查点规则可配置。
{{% /steps %}}

#### 3.1.2 视图切换
{{< image "/images/docs/blockchain/RBFT-viewchange.png" "视图切换" >}}
{{% steps %}}
<h5></h5>
Replica节点检测到主节点有以上异常情况或者接收来自其他f+1个节点的ViewChange消息之后会向全网广播ViewChange消息；
<h5></h5>
当新主节点收到N-f个ViewChange消息时，会发送NewView消息；
<h5></h5>
Replica节点接收到NewView消息之后进行消息的验证和对比，验证View的切换信息相同之后正式更换ViewChange并打印FinishVC消息，从而完成整个ViewChange流程。
{{% /steps %}}

#### 3.1.3 节点增删
{{< image "/images/docs/blockchain/RBFT-addnode.png" "增加节点" >}}

{{% steps %}}
<h5></h5>
首先，新的节点需要得到证书颁发机构颁发的证书，然后向联盟中的所有节点发送请求；

<h5></h5>
各个节点确认同意后会向联盟中的其他节点进行全网广播，当一个节点得到2f+1个同意加入的回复后会与新的节点建立连接；

<h5></h5>
随后，当新的节点和N-f（N为区块链联盟节点总数）个节点建立连接后就可以执行主动恢复算法，同步区块链联盟成员的最新状态；

<h5></h5>
随后，新节点再向主节点请求加入常规共识流程。最后，主节点确认过新节点的请求后会定义在哪个块号后需要改变节点总数N来共识（确保新节点的加入不会影响原有的共识，因为新节点的加入会导致全网共识N的改变，意味着f值可能改变）。

{{% /steps %}}

### 3.2 PBFT
PBFT（Practical Byzantine Fault Tolerance）是属于BFT（拜占庭容错）类算法。它用于在分布式系统中，即使存在恶意节点，也能可靠地达成共识。PBFT通过使用多个阶段的消息传递和验证来确保一致性，并且优化了传统拜占庭共识算法在实际应用中的效率和可扩展性。

缺点：
+ PBFT算法不支持节点的动态增删
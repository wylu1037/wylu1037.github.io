---
title: Getting Started
date: 2024-03-31T17:33:47+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---


<h5>实体和值对象有什么区别呢？</h5>

{{< callout >}}
**实体**：当一个对象由其标识（而不是属性）区分时，这种对象称为实体（***Entity***）。

例：最简单的，公安系统的身份信息录入，对于人的模拟，即认为是实体，因为每个人是独一无二的，且其具有唯一标识（如公安系统分发的身份证号码）。

<br>

---

**值对象**：当一个对象用于对事务进行描述而没有唯一标识时，它被称作值对象（***Value Objec***t）。

例：比如颜色信息，我们只需要知道`{"name":"黑色"，"css":"#000000"}`这样的值信息就能够满足要求了，这避免了我们对标识追踪带来的系统复杂性。
{{< /callout >}}


## 1.Domain
DDD全称是 **「领域驱动设计」**，那什么是 **「领域」** 呢？指的就是一块业务范围。

​具体来讲，每个组织都有它自己的业务范围和做事方式，这个业务范围以及在其中所进行的活动便是领域。如果你为某个组织开发软件时，你面对的就是这个组织的领域。

那为什么需要划分子域和限界上下文呢？因为想要试图创建一个全功能的领域模型是非常困难的，并且很容易导致失败。大家都知道，宇宙包含万事万物，但并不是每个系统都可以用一个大而全的**「宇宙」**这样一个模型来承载所有的业务行为。

业务范围可能也很大，所以需要把这个大的业务范围拆开。如果把这个范围看成是一个空间的话，那它同时存在**「问题空间」**和**「解决方案空间」**。**问题空间是从业务需求方面来看，而解决方案空间是从实现软件方面来看**。两者是有一些细微的区别的，最终**用子域来划分问题空间，用限界上下文来划分解决方案空间**。

### Domain Event
两个限界上下文除了通过使用防腐层直接调用，更多的时候是通过领域事件来进行解耦。并不是所有领域中发生的事情都需要被建模为领域事件，只关注有业务价值的事情。领域事件是领域专家所关心的（需要跟踪的、希望被通知的、会引起其他模型对象改变状态的）发生在领域中的一些事情。

## 2.Aggregation、Repository、Factory
### 2.1 聚合
#### 2.1.1 什么是聚合
表达的是真实世界中整体与部分的关系，如订单与订单明细，在DDD的设计中，以聚合的形式进行设计，将订单明细作为订单中的一个属性。代码示例如下：
```java
public class Order {
    private Set<Items> items;

    public void setItems(Set<Item> items){

          this.items = items;

    }

    public Set<Item> getItems(){

          return this.items;

    }

    ……
}
```
#### 2.1.2 聚合根
有了聚合关系，部分就会被封装在整体里面，这时就会形成一种约束，即外部程序不能跳过整体去操作部分，对部分的操作都必须要通过整体。这时，整体就成了**外部访问的唯一入口**，被称为==聚合根==。

​一旦将对象间的关系设计成了聚合，那么外部程序只能访问聚合根，而不能访问聚合中的其他对象。这样带来的好处就是，当聚合内部的业务逻辑发生变更时，只与聚合内部有关，只需要对聚合内部进行更新，与外部程序无关，从而有效降低了变更的维护成本，提高了系统的设计质量。

​然而，这样的设计有时是有效的，但并非都有效。譬如，在管理订单时，对订单进行增删改，聚合是有效的。但是，如果要统计销量、分析销售趋势、销售占比时，则需要对大量的订单明细进行汇总、进行统计；如果每次对订单明细的汇总与统计都必须经过订单的查询，必然使得查询统计变得效率极低而无法使用。

​因此，领域驱动设计通常适用于增删改的业务操作，但不适用于分析统计。在一个系统中，**增删改的业务可以采用领域驱动的设计，但在非增删改的分析汇总场景中，则不必采用领域驱动的设计，直接 SQL 查询就好了，也就不必再遵循聚合的约束了。**

## 3.Bounded Context & Subdomain

## 4.Anti-corruption layer

## DDD中的模式

## 5.后端开发者实践

## 6.DDD编码实践

## 7.事件驱动架构

## 8.CQRS编码实践

## FAQ
### 子域划分

| 域     | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| 核心域 | 决定产品和公司核心竞争力的子域是核心域，它是业务成功的主要因素和公司的核心竞争力。 |
| 通用域 | 没有太多个性化诉求，同时被多个子域使用的通用功能子域是通用域。比如认证、权限等，这类应用很容易买到，没有企业特点限制，无需太多定制化。 |
| 支撑域 | 既不包含决定产品和公司核心竞争力的功能，也不包含通用功能的子域，但又是必需的支撑域。支撑域具有企业特性，但不具通用性，例如数据代码类的数据字典等系统。 |

### 包结构
{{< tabs items="模块的组织,模块内的组织结构" >}}
{{< tab >}}
```
import com.company.team.bussiness.lottery.*;//抽奖上下文
import com.company.team.bussiness.riskcontrol.*;//风控上下文
import com.company.team.bussiness.counter.*;//计数上下文
import com.company.team.bussiness.condition.*;//活动准入上下文
import com.company.team.bussiness.stock.*;//库存上下文
```
{{< /tab >}}

{{< tab >}}
```
import com.company.team.bussiness.lottery.domain.valobj.*;//领域对象-值对象
import com.company.team.bussiness.lottery.domain.entity.*;//领域对象-实体
import com.company.team.bussiness.lottery.domain.aggregate.*;//领域对象-聚合根
import com.company.team.bussiness.lottery.service.*;//领域服务
import com.company.team.bussiness.lottery.repo.*;//领域资源库
import com.company.team.bussiness.lottery.facade.*;//领域防腐层
```
{{< /tab >}}
{{< /tabs >}}

## Reference

+ [领域驱动设计在互联网业务开发中的实践](https://tech.meituan.com/2017/12/22/ddd-in-practice.html)
+ [UML设计软件](https://staruml.io/)
+ [画事件风暴图的软件](https://www.mural.co/)
+ <a href="https://learn.lianglianglee.com/%e4%b8%93%e6%a0%8f/DDD%20%e5%be%ae%e6%9c%8d%e5%8a%a1%e8%90%bd%e5%9c%b0%e5%ae%9e%e6%88%98/00%20%e5%bc%80%e7%af%87%e8%af%8d%20%20%e8%ae%a9%e6%88%91%e4%bb%ac%e6%8a%8a%20DDD%20%e7%9a%84%e6%80%9d%e6%83%b3%e7%9c%9f%e6%ad%a3%e8%90%bd%e5%9c%b0.md">Click Me</a>


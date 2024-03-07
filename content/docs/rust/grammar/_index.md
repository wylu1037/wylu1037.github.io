---
title: Grammar
date: 2024-03-07T21:21:47+08:00
width: full
---

<br>
{{< hextra/hero-subtitle >}}
  Rust 程序设计语言：https://rustwiki.org/zh-CN/book/
{{< /hextra/hero-subtitle >}}
<br>

{{< cards >}}
  {{< card link="" title="入门指南" subtitle="让我们开始 Rust 之旅吧！有很多内容需要学习，但每次旅程总有起点。" icon="arrow-circle-right" >}}
  {{< card link="" title="通用编程概念" subtitle="本章几乎涵盖了每种编程语言都出现的概念，并介绍它们在 Rust 中的工作原理。许多编程语言的核心部分都有很多共同点。本章提到的概念都不是 Rust 特有的，我们将在 Rust 的背景下讨论它们，并解释使用这些概念的约定。" icon="adjustments-horizontal" >}}
  {{< card link="" title="认识所有权" subtitle="所有权（系统）是 Rust 最为与众不同的特性，它让 Rust 无需垃圾回收器（garbage collector）即可保证内存安全。因此，理解 Rust 中所有权的运作方式非常重要。在本章中，我们将讨论所有权以及相关功能：借用、slice 以及 Rust 如何在内存中存放数据。" icon="api" >}}
  {{< card link="" title="使用结构体组织相关联的数据" subtitle="struct，或者 structure，是一个自定义数据类型，允许你命名和包装多个相关的值，从而形成一个有意义的组合。如果你熟悉一门面向对象语言，struct 就像对象中的数据属性。" icon="arrow-down-tray" >}}
  {{< card link="" title="枚举和模式匹配" subtitle="枚举（enumerations），也被称作 enums。枚举允许你通过列举可能的 成员（variants） 来定义一个类型。" icon="arrow-path" >}}
  {{< card link="" title="使用包、Crate和模块管理不断增长的项目" subtitle="Rust 有许多功能可以让你管理代码的组织，包括哪些内容可以被公开，哪些内容作为私有部分，以及程序每个作用域中的名字。" icon="arrow-trending-up" >}}
  {{< card link="" title="常见集合" subtitle="Rust 标准库中包含一系列被称为 集合（collections）的非常有用的数据结构。大部分其他数据类型都代表一个特定的值，不过集合可以包含多个值。不同于内建的数组和元组类型，这些集合指向的数据是储存在堆上的，这意味着数据的数量不必在编译时就已知，并且还可以随着程序的运行增长或缩小。每种集合都有着不同功能和成本，而根据当前情况选择合适的集合，这是一项应当逐渐掌握的技能。" icon="arrow-up-on-square-stack" >}}
  {{< card link="" title="错误处理" subtitle="Rust 将错误组合成两个主要类别：可恢复错误（recoverable）和 不可恢复错误（unrecoverable）。可恢复错误通常代表向用户报告错误和重试操作是合理的情况，比如未找到文件。不可恢复错误通常是 bug 的同义词，比如尝试访问超过数组结尾的位置。" icon="banknotes" >}}
  {{< card link="" title="泛型、trait 和生命周期" subtitle="每一个编程语言都有高效处理重复概念的工具。在 Rust 中其工具之一就是 泛型（generics）。 trait是一个定义泛型行为的方法。生命周期（lifetimes）是一类允许我们向编译器提供引用如何相互关联的泛型。" icon="bell" >}}
  {{< card link="" title="编写自动化测试" subtitle="会讲到编写测试时会用到的标注和宏，运行测试的默认行为和选项，以及如何将测试组织成单元测试和集成测试。" icon="bookmark-square" >}}
  {{< card link="" title="一个 I/O 项目：构建一个命令行程序" subtitle="本章既是一个目前所学的很多技能的概括，也是一个更多标准库功能的探索。我们将构建一个与文件和命令行输入/输出交互的命令行工具来练习现在一些你已经掌握的 Rust 技能。" icon="bubbles" >}}
  {{< card link="" title="Rust 中的函数式语言功能：迭代器与闭包" subtitle="Rust 的设计灵感来源于很多现存的语言和技术。其中一个显著的影响就是 函数式编程（functional programming）。函数式编程风格通常包含将函数作为参数值或其他函数的返回值、将函数赋值给变量以供之后执行等等。" icon="building-library" >}}
  {{< card link="" title="进一步认识 Cargo 和 Crates.io" subtitle="本章会讨论 Cargo 其他一些更为高级的功能，我们将展示如何：使用发布配置来自定义构建；将库发布到 crates.io；使用工作空间来组织更大的项目；从 crates.io 安装二进制文件；使用自定义的命令来扩展 Cargo" icon="chart-bar-square" >}}
  {{< card link="" title="智能指针" subtitle="智能指针（smart pointers）是一类数据结构，它们的表现类似指针，但是也拥有额外的元数据和功能。智能指针的概念并非 Rust 独有：其起源于 C++，也存在于其他语言中。Rust 标准库中不同的智能指针提供了多于引用的额外功能。本章将会探索的一个例子便是 引用计数 （reference counting）智能指针类型，其允许数据有多个所有者。引用计数智能指针记录总共有多少个所有者，并当没有任何所有者时负责清理数据。" icon="checklist" >}}
  {{< card link="" title="无畏并发" subtitle="安全且高效的处理并发编程是 Rust 的另一个主要目标。并发编程（Concurrent programming），代表程序的不同部分相互独立的执行，而 并行编程（parallel programming）代表程序不同部分于同时执行，这两个概念随着计算机越来越多的利用多处理器的优势时显得愈发重要。" icon="circle-stack" >}}
  {{< card link="" title="Rust 的面向对象特性" subtitle="面向对象编程（Object-Oriented Programming，OOP）是一种模式化编程方式。对象（Object）来源于 20 世纪 60 年代的 Simula 编程语言。这些对象影响了 Alan Kay 的编程架构中对象之间的消息传递。他在 1967 年创造了 面向对象编程 这个术语来描述这种架构。关于 OOP 是什么有很多相互矛盾的定义；在一些定义下，Rust 是面向对象的；在其他定义下，Rust 不是。" icon="cloud-arrow-up" >}}
  {{< card link="" title="模式和匹配" subtitle="模式是 Rust 中特殊的语法，它用来匹配类型中的结构，无论类型是简单还是复杂。结合使用模式和 match 表达式以及其他结构可以提供更多对程序控制流的支配权。" icon="code-bracket" >}}
  {{< card link="" title="高级特征" subtitle="高级特征" icon="cog-6-tooth" >}}
  {{< card link="" title="最后的项目: 构建多线程 Web 服务器" subtitle="这是一次漫长的旅途，不过我们到达了本书的结束。在本章中，我们将一同构建另一个项目，来展示最后几章所学，同时复习更早的章节。" icon="command-line" >}}
  {{< card link="" title="附录" subtitle="附录部分包含一些在你的 Rust 之旅中可能用到的参考资料。" icon="cursor-arrow-ripple" >}}
{{< /cards >}}

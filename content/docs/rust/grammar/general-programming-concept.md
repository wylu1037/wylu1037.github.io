---
title: 通用编程概念
date: 2024-03-30T14:02:45+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 2
---

## 1.变量和可变性

### 1.1 常量

### 1.2 遮蔽
```rust {hl_lines=[4]}
fn main() {
    let x = 5;

    let x = x + 1;

    {
        let x = x * 2;
        println!("The value of x in the inner scope is: {}", x);
    }

    println!("The value of x is: {}", x);
}
```

## 2.数据类型

### 2.1 标量类型
标量（scalar）类型表示单个值。Rust 有 4 个基本的标量类型：整型、浮点型、布尔型和字符。

### 2.2 复合类型
复合类型（compound type）可以将多个值组合成一个类型。Rust 有两种基本的复合类型：元组（tuple）和数组（array）。



## 3.函数

## 4.注释

## 5.控制流

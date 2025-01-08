---
title: 泛型、trait 与生命周期
date: 2024-03-30T14:19:37+08:00
authors:
    - name: wylu
      link: https://github.com/wylu1037
      image: https://github.com/wylu1037.png?size=40
weight: 9
---

## 1.泛型数据类型

泛型参数分为三类：

-   生命周期参数
-   类型参数
-   常量参数

常量泛型参数

```rust
impl<const N: usize> Tokenizable for [u8; N]
```

## 2.trait

### 2.1 Copy

如果一个类型实现了 `copy trait`，使用它的变量不会发生所有权转移，而是直接复制值。在赋值给另一个变量之后，他仍然有效。基本数据类型默认实现了 `copy trait`。

```rust
let x: i32 = 8;
let y: i32 = x;

print!("x = {}", x);
```

> 如果类型或其属性实现了 `drop trait`，则不允许实现 `copy trait`。

### 2.2 Drop

### 2.3 Clone
> Clone 继承了 Sized，这意味着只能为大小在编译时已知的类型实现 Clone。
```rust
pub trait Clone: Sized {
    fn clone(&self) -> Self;
    fn clone_from(&mut self, source: &Self) {
        *self = source.clone();
    }
}
```
当一个类型实现了 Clone 特性后，可以通过调用 clone 方法显式地创建一个新的独立副本，而不会影响原始值。

Clone 和 Copy 的区别

| 特性   | Clone       | Copy        |
|------|-------------|-------------|
| 拷贝方式 | 显示调用clone() | 隐式浅拷贝（按位复制） |
| 深浅拷贝 | 深拷贝或自定义拷贝逻辑 | 浅拷贝         |
| 自动派生 | 可自动派生       | 可自动派生       |
| 适用范围 | 任务类型        | 简单类型（大小固定）  |

自动派生
```rust
#[derive(Clone)]
struct MyStruct {
    a: i32,
    b: String,
}
```

自定义clone
```rust
struct Point {
    x: i32,
    y: i32,
}

impl Clone for Point {
    fn clone(&self) -> Self {
        println!("Cloning Point...");
        Point { x: self.x, y: self.y }
    }
}

fn main() {
    let p1 = Point { x: 1, y: 2 };
    let p2 = p1.clone();
    println!("p1: ({}, {}), p2: ({}, {})", p1.x, p1.y, p2.x, p2.y);
}
```

### PartialEq

### Eq
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

### copy

如果一个类型实现了 `copy trait`，使用它的变量不会移动，而是简单的复制。在赋值给另一个变量之后，他仍然有效。

```rust
let x: i32 = 8;
let y: i32 = x;

print!("x = {}", x);
```

> 如果类型或其属性实现了 `drop trait`，则不允许实现 `copy trait`。

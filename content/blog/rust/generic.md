---
title: 泛型
date: 2024-09-23T10:54:13+08:00
---

在 **Rust** 中，泛型提供了一种用于编写函数、结构体、枚举和定义通用代码的方法。这样可以在不同类型上复用逻辑，提高代码的灵活性和可重用性。以下是泛型的核心概念和使用方法。

## 泛型函数

泛型函数允许你编写对多种类型都适用的函数。泛型参数通常采用大写字母：

```rust
fn largest<T: PartialOrd>(list: &[T]) -> &T {
    let mut largest = &list[0];
    for item in list.iter() {
        if item > largest {
            largest = item;
        }
    }
    largest
}

fn main() {
    let numbers = vec![1, 2, 3, 4, 5];
    println!("The largest number is {}", largest(&numbers));
}
```

## 泛型结构体

结构体也可以使用泛型来定义其字段的类型：

```rust
struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    let integer_point = Point { x: 5, y: 10 };
    let float_point = Point { x: 1.0, y: 4.0 };
}
```

## 泛型枚举

枚举同样可以使用泛型：

```rust
enum Option<T> {
    Some(T),
    None,
}
```

这种方式使得枚举在 Rust 标准库中非常普遍。

## 泛型方法

可以在结构体和枚举上定义泛型方法：

```rust
impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}
```

## Trait Bounds

为了在泛型上施加约束，使用 trait bounds 确保泛型类型实现了特定的 trait：

```rust
fn print_info<T: std::fmt::Display>(item: T) {
    println!("{}", item);
}
```

## 多重约束

可以在泛型中同时设定多个约束：

```rust
fn compare_and_display<T: PartialOrd + std::fmt::Display>(a: T, b: T) {
    if a > b {
        println!("{} is greater than {}", a, b);
    } else {
        println!("{} is not greater than {}", a, b);
    }
}
```

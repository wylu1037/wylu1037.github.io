---
title: 闭包
date: 2024-06-02T21:25:14+08:00
---

闭包（Closures）是一种可以捕获其环境的匿名函数。闭包可以存储在变量中，作为参数传递给其他函数，或者从其他函数中返回。它们可以捕获上下文中的变量，使其在闭包体内使用。
Rust 提供了三种类型的闭包，分别是 `Fn`、`FnMut` 和 `FnOnce`。

闭包语法如下：
```
|参数列表| 表达式
```

示例：
```rust
let add = |x, y| x + y;
let result = add(2, 3);
```

## 带有类型注解的闭包
可以显式地为闭包的参数和返回类型添加类型注解。
```rust
let add = |x: i32, y: i32| -> i32 { x + y };
let result = add(2, 3);
```

## 💢 闭包捕获环境
闭包可以捕获其定义所在作用域的变量，有三种方式：

1. **按引用捕获（Fn）**：闭包以不可变引用的方式捕获变量。
2. **按可变引用捕获（FnMut）**：闭包以可变引用的方式捕获变量。
3. **按值捕获（FnOnce）**：闭包获取变量的所有权，只能使用一次。

**示例**：
```rust
fn main() {
    let x = 10;

    // 按引用捕获
    let add_to_x = |y: i32| x + y;
    println!("10 + 5 = {}", add_to_x(5));

    let mut z = 10;

    // 按可变引用捕获
    let mut add_to_z = |y: i32| z += y;
    add_to_z(5);
    println!("10 + 5 = {}", z);

    // 按值捕获
    let move_z = move |y: i32| z + y;
    println!("15 + 5 = {}", move_z(5));
}
```

## 闭包作为函数参数
闭包可以作为函数的参数，可以使用 Fn、FnMut 或 FnOnce 进行限定：
```rust
fn apply_to_3<F>(f: F) -> i32
where
    F: Fn(i32) -> i32,
{
    f(3)
}

fn main() {
    let double = |x| x * 2;
    let result = apply_to_3(double);
    println!("3 * 2 = {}", result);
}
```

## 闭包作为返回值
函数也可以返回闭包，这需要使用 `impl Trait` 或者盒装（Boxed）闭包：
```rust
fn returns_closure() -> impl Fn(i32) -> i32 {
    |x| x + 1
}

fn main() {
    let closure = returns_closure();
    println!("4 + 1 = {}", closure(4));
}
```

或者使用盒装闭包：
```rust
fn returns_closure() -> Box<dyn Fn(i32) -> i32> {
    Box::new(|x| x + 1)
}

fn main() {
    let closure = returns_closure();
    println!("4 + 1 = {}", closure(4));
}
```

## 🤖 面试
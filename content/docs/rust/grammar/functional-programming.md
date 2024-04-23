---
title: 函数式编程
date: 2024-04-23T16:54:10+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 11
---

函数式编程（functional programming）风格通常包含将函数作为参数值或其他函数的返回值、将函数赋值给变量以供之后执行等等。

- **闭包**（Closures），一个可以储存在变量里的类似函数的结构；
- **迭代器**（Iterators），一种处理元素序列的方式；

## 1.闭包

`Rust` 的 **闭包**（closures）是可以保存进变量或作为参数传递给其他函数的匿名函数。可以在一个地方创建闭包，然后在不同的上下文中执行闭包运算。不同于函数，闭包允许捕获调用者作用域中的值。

### 1.1 使用闭包创建行为的抽象

涉及闭包的语法、类型推断和 `trait`。

```rust
use std::thread;
use std::time::Duration;

fn simulated_expensive_calculation(intensity: u32) -> u32 {
    println!("calculating slowly...");
    thread::sleep(Duration::from_secs(2));
    intensity
}
```

<p align="center" style="color:#9ca3af;">一个用来代替假定计算的函数，它大约会执行两秒钟</p>

```rust
use std::thread;
use std::time::Duration;

fn simulated_expensive_calculation(num: u32) -> u32 {
    println!("calculating slowly...");
    thread::sleep(Duration::from_secs(2));
    num
}

fn generate_workout(intensity: u32, random_number: u32) {
    if intensity < 25 {
        println!(
            "Today, do {} pushups!",
            simulated_expensive_calculation(intensity)
        );
        println!(
            "Next, do {} situps!",
            simulated_expensive_calculation(intensity)
        );
    } else {
        if random_number == 3 {
            println!("Take a break today! Remember to stay hydrated!");
        } else {
            println!(
                "Today, run for {} minutes!",
                simulated_expensive_calculation(intensity)
            );
        }
    }
}
```

<p align="center" style="color:#9ca3af;">程序的业务逻辑，它根据输入并调用 simulated_expensive_calculation 函数来打印出健身计划</p>

### 1.2 使用函数重构

将重复的 `simulated_expensive_calculation` 函数调用提取到一个变量中。

```rust {hl_lines=[12]}
use std::thread;
use std::time::Duration;

fn simulated_expensive_calculation(num: u32) -> u32 {
    println!("calculating slowly...");
    thread::sleep(Duration::from_secs(2));
    num
}

fn generate_workout(intensity: u32, random_number: u32) {
    // 将函数提取到变量中
    let expensive_result = simulated_expensive_calculation(intensity);

    if intensity < 25 {
        println!(
            "Today, do {} pushups!",
            expensive_result
        );
        println!(
            "Next, do {} situps!",
            expensive_result
        );
    } else {
        if random_number == 3 {
            println!("Take a break today! Remember to stay hydrated!");
        } else {
            println!(
                "Today, run for {} minutes!",
                expensive_result
            );
        }
    }
}
```

### 1.3 使用闭包储存代码

```rust {hl_lines=[2,3,4,5,6]}
fn generate_workout(intensity: u32, random_number: u32) {
    let expensive_closure = |num| {
        println!("calculating slowly...");
        thread::sleep(Duration::from_secs(2));
        num
    };

    if intensity < 25 {
        println!(
            "Today, do {} pushups!",
            expensive_closure(intensity)
        );
        println!(
            "Next, do {} situps!",
            expensive_closure(intensity)
        );
    } else {
        if random_number == 3 {
            println!("Take a break today! Remember to stay hydrated!");
        } else {
            println!(
                "Today, run for {} minutes!",
                expensive_closure(intensity)
            );
        }
    }
}
```

<p align="center" style="color:#9ca3af;">定义一个闭包并储存到变量 expensive_closure 中</p>

### 1.4 闭包类型推断和标准

闭包不要求像 `fn` 函数那样在参数和返回值上注明类型。

## 2.迭代器

## 3.性能比较

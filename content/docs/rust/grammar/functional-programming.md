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

```rust
let example_closure = |x| x + 1;
```

### 1.5 带有泛型和 Fn trait 的闭包

`Fn` 系列 trait 由标准库提供。所有的闭包都实现了 trait `Fn`、`FnMut` 或 `FnOnce` 中的一个。

```rust {hl_lines=[2]}
struct Cacher<T>
    where T: Fn(u32) -> u32
{
    calculation: T,
    value: Option<u32>,
}
```

<p align="center" style="color:#9ca3af;">定义一个 Cacher 结构体来在 calculation 中存放闭包并在 value 中存放 Option 值</p>

结构体 `Cacher` 有一个泛型 `T` 的字段 `calculation`。`T` 的 `trait bound` 指定了 `T` 是一个使用 `Fn` 的闭包。任何希望储存到 `Cacher` 实例的 `calculation` 字段的闭包必须有一个 `u32` 参数（由 `Fn` 之后的括号的内容指定）并必须返回一个 `u32`（由 `->` 之后的内容）。

字段 value 是 Option<u32> 类型的。在执行闭包之前，value 将是 None。如果使用 Cacher 的代码请求闭包的结果，这时会执行闭包并将结果储存在 value 字段的 Some 成员中。接着如果代码再次请求闭包的结果，这时不再执行闭包，而是会返回存放在 Some 成员中的结果。

```rust
struct Cacher<T>
    where T: Fn(u32) -> u32
{
    calculation: T,
    value: Option<u32>,
}

impl<T> Cacher<T>
    where T: Fn(u32) -> u32
{
    fn new(calculation: T) -> Cacher<T> {
        Cacher {
            calculation,
            value: None,
        }
    }

    fn value(&mut self, arg: u32) -> u32 {
        match self.value {
            Some(v) => v,
            None => {
                let v = (self.calculation)(arg);
                self.value = Some(v);
                v
            },
        }
    }
}
```

<p align="center" style="color:#9ca3af;">Cacher 的缓存逻辑</p>

```rust
fn generate_workout(intensity: u32, random_number: u32) {
    let mut expensive_result = Cacher::new(|num| {
        println!("calculating slowly...");
        thread::sleep(Duration::from_secs(2));
        num
    });

    if intensity < 25 {
        println!(
            "Today, do {} pushups!",
            expensive_result.value(intensity)
        );
        println!(
            "Next, do {} situps!",
            expensive_result.value(intensity)
        );
    } else {
        if random_number == 3 {
            println!("Take a break today! Remember to stay hydrated!");
        } else {
            println!(
                "Today, run for {} minutes!",
                expensive_result.value(intensity)
            );
        }
    }
}
```

<p align="center" style="color:#9ca3af;">在 generate_workout 函数中利用 Cacher 结构体来抽象出缓存逻辑</p>

### 1.6 Cacher 实现的限制

第一个问题是 `Cacher` 实例假设对于 `value` 方法的任何 `arg` 参数值总是会返回相同的值。也就是说，这个 `Cacher` 的测试会失败：

```rust {hl_lines=[5]}
fn call_with_different_values() {
    let mut c = Cacher::new(|a| a);

    let v1 = c.value(1);
    let v2 = c.value(2);

    assert_eq!(v2, 2);
}
```

这里的问题是第一次使用 **1** 调用 `c.value`，`Cacher` 实例将 `Some(1)` 保存进 `self.value`。在这之后，无论传递什么值调用 `value`，它总是会返回 **1**。

{{< callout >}}
尝试修改 Cacher 存放一个哈希 map 而不是单独一个值。哈希 map 的 key 将是传递进来的 arg 值，而 value 则是对应 key 调用闭包的结果值。相比之前检查 self.value 直接是 Some 还是 None 值，现在 value 函数会在哈希 map 中寻找 arg，如果找到的话就返回其对应的值。如果不存在，Cacher 会调用闭包并将结果值保存在哈希 map 对应 arg 值的位置。
{{< /callout >}}

当前 `Cacher` 实现的第二个问题是它的应用被限制为只接受获取一个 `u32` 值并返回一个 `u32` 值的闭包。比如说，我们可能需要能够缓存一个获取字符串 `slice` 并返回 `usize` 值的闭包的结果。

```rust
todo
```

<p align="center" style="color:#9ca3af;">使用泛型参数来增加 Cacher 功能的灵活性</p>

### 1.7 闭包捕获环境

```rust {hl_lines=[4]}
fn main() {
    let x = 4;

    let equal_to_x = |z| z == x;

    let y = 4;

    assert!(equal_to_x(y));
}
```

<p align="center" style="color:#9ca3af;">一个引用了其周围作用域中变量的闭包示例</p>

当闭包从环境中捕获一个值，闭包会在闭包体中储存这个值以供使用。这会使用内存并产生额外的开销，在更一般的场景中，当我们不需要闭包来捕获环境时，我们不希望产生这些开销。因为 **函数** 从未允许捕获环境，定义和使用函数也就从不会有这些额外开销。

闭包可以通过三种方式捕获其环境，他们直接对应函数的三种获取参数的方式：**获取所有权**，**可变借用** 和 **不可变借用**。这三种捕获值的方式被编码为如下三个 `Fn` trait：

- **_FnOnce_** 消费从周围作用域捕获的变量，闭包周围的作用域被称为其 <u>环境</u><sub> **environment**</sub>。为了消费捕获到的变量，闭包{{< font "blue" "必须获取其所有权" >}}并在定义闭包时将其**移动**进闭包。其名称的 `Once` 部分代表了闭包不能多次获取相同变量的所有权的事实，所以它<u>只能被调用一次</u>。
- **_FnMut_** 获取**可变**的借用值，所以可以改变其环境。
- **_Fn_** 从其环境获取**不可变**的借用值。

由于所有闭包都可以被调用至少一次，所以所有闭包都实现了 `FnOnce` 。那些并没有移动被捕获变量的所有权到闭包内的闭包也实现了 `FnMut` ，而不需要对被捕获的变量进行可变访问的闭包则也实现了 `Fn` 。

如果希望强制闭包获取其使用的环境值的所有权，可以在参数列表前使用 `move` 关键字。这个技巧在将闭包传递给新线程以便将数据移动到新线程中时最为实用。

## 2.迭代器

## 3.性能比较

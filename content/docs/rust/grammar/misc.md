---
title: 杂项
date: 2024-03-11T19:51:29+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 99
---

## 1.匿名函数

使用闭包`closure`来创建匿名函数。
创建一个不带参数的匿名闭包：

```rust
fn main() {
    let x = 10;
    let print_x = || {
        println!("Value of x: {}", x); // 闭包可以访问外部变量 x
    };

    print_x(); // 输出：Value of x: 10

}
```

## 2.宏

在 Rust 中，宏是一种强大的特性，允许你编写可在编译时展开的代码片段。Rust 宏通过抽象和生成代码来减少重复，提高代码的灵活性和可重用性。理解宏的最佳方式是将它们看作是代码生成代码的手段。

{{< tabs items="声明式宏,过程宏">}}
{{< tab >}}
通常通过 `macro_rules!` 宏来定义。这种宏让你可以匹配不同的模式，并根据匹配到的模式展开为不同的代码。它们主要用于减少重复代码。

```rust
macro_rules! create_function {
    ($func_name:ident) => {
        fn $func_name() {
            println!("Function {:?} is called", stringify!($func_name));
        }
    };
}

create_function!(foo);
create_function!(bar);

fn main() {
    foo();
    bar();
}
```

{{< /tab >}}

{{< tab >}}
过程宏更加强大，因为它们可以访问和修改编译器的抽象语法树（AST）。这意味着你可以根据复杂的规则生成代码，甚至在编译时执行一些检查。过程宏分为三类：

- **自定义派生宏**：允许为结构体或枚举自动实现特定的 `trait`；
- **属性宏**：可以附加到模块、`crate` 或项上，类似于内置的 `#[derive]` 宏，但更加强大；
- **函数宏**：看起来和调用普通函数相似，但在编译时展开为更复杂的代码；

{{< /tab >}}
{{< /tabs >}}

### 2.1 include_str!

Includes a UTF-8 encoded file as a string.
The file is located relative to the current file (similarly to how modules are found). The provided path is interpreted in a platform-specific way at compile time. So, for instance, an invocation with a Windows path containing backslashes would not compile correctly on Unix.
This macro will yield an expression of type &'static str which is the contents of the file.

### 2.2 assert!

#### 2.2.1 assert_eq!

判断两个表达式返回的值是否相等。

```rust
fn main() {
    let a = 3;
    let b = 1 + 2;
    assert_eq!(a, b);
    // assert_eq!(a, b, "我们在测试两个数之和{} + {}，这是额外的错误信息", a, b);
}
```

#### 2.2.2 assert_ne!

判断两个表达式返回的值是否不相等。

```rust
fn main() {
    let a = 3;
    let b = 1 + 3;
    assert_ne!(a, b);
    // assert_ne!(a, b, "我们在测试两个数之和{} + {}，这是额外的错误信息", a, b);
}
```

#### 2.2.3 assert!

判断传入的布尔表达式是否为`true`。

#### 2.2.4 debug_assert!

`debug_assert!`, `debug_assert_eq!`, `debug_assert_ne!`只能在 Debug 模式下输出。

```rust
fn main() {
    let a = 3;
    let b = 1 + 3;
    debug_assert_eq!(a, b, "我们在测试两个数之和{} + {}，这是额外的错误信息", a, b);
}
```

在 Release 模式下没有任何输出。

```shell
cargo run --release
```

## 3.Re-exports

```rust
pub use ethers_core::abi;
pub use ethers_core::types;
pub use ethers_core::utils;
```

`Re-export`（重导出）是指在一个模块中重新声明并公开另一个模块已经导出的项（比如函数、结构体、枚举、trait、模块等），使得这些项可以通过新的路径被外部模块访问。通过 re-export，你可以隐藏原始模块细节，同时保持其功能对使用者可用，或者将多个来源的功能整合在一起提供统一的接口。

```rust
// 模块A.rs
pub mod inner {
    pub fn function_a() {
        println!("Function A from module A");
    }
}

// 模块B.rs
pub mod outer {
    // Re-exporting 'function_a' from module A's inner module
    pub use crate::A::inner::function_a;
}

// main.rs
mod A;
mod B;

fn main() {
    // 直接使用A模块内部的函数
    A::inner::function_a();

    // 通过B模块re-exported的方式使用函数
    B::outer::function_a();
}
```

## 4.Box

`Box` 是一种非常有用的**智能指针**，允许你再**堆**上分配内存，而不是在**栈**上。

1. 处理大量数据：
2. 递归类型
3. 确保类型大小一致

```rust {hl_lines=[2,6]}
fn main() {
    let b = Box::new(10); // 在堆上分配一个整数
    println!("b = {}", b); // 使用 *b 来访问它的值

    // 使用Box存储一个大数组，这可能会超出栈的容量
    let large_array = Box::new([0u8; 10000]);
    println!("large array size = {}", large_array.len());
}
```

- **所有权**：`Box` 拥有其所指向的数据。当 `Box` 被销毁时，它的析构函数会自动释放其堆内存；
- **不可变与可变借用**

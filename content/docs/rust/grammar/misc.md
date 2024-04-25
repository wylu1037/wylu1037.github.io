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

`include_str!` 宏用于在编译时将指定文件的内容作为字符串字面量包含到你的程序中。这对于想要在程序中硬编码文件内容，比如读取配置文件、内联文本资源等场景非常有用。下面是一个简单的使用示例：

假设有一个名为 `example.txt` 的文件，内容如下：

```{filename=example.txt}
Hello, world!
This is an example file included using include_str! macro.
```

使用 `include_str!` 来包含这个文件的内容：

```rust
fn main() {
    // 使用 include_str! 宏将 example.txt 文件的内容读取为一个字符串
    let file_content = include_str!("example.txt");

    // 打印出文件内容
    println!("{}", file_content);
}
```

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

### 2.3 format!

`format!` 宏在 **_Rust_** 中是非常强大的一个工具，用于构建格式化的字符串。它的用法类似于其他编程语言中的 `printf` 或 `String.format`，但更加类型安全且灵活。`format!` 宏能够自动处理不同类型的变量，并按照指定的格式插入到字符串中。

```rust
let num = 42;
let pi = 3.14159;
println!("Number: {} and Pi: {:.3}", num, pi); // 数字和Pi的值
println!("Debug: {:?}", (num, pi)); // 调试输出
println!("Hex: {:x}, Octal: {:o}, Binary: {:b}", num, num, num); // 不同基数
println!("Width: |{:>5}| Center: |{:^5}| Left: |{:<5}|", num, num, num); // 对齐方式
```

<h5>占位符</h5>

1. **基本占位符 `{}`**

   - 插入实现了 `Display` 特质的值。这是最通用的形式，用于输出用户可见的格式。

2. **调试占位符 `{:?}`**

   - 插入实现了 `Debug` 特质的值。用于调试输出，通常提供更多的内部结构信息。

3. **格式说明符 `{fmt}`**

   > 其中 fmt 是一个格式字符串，可以控制输出的细节。例如：

   - `{:.2}` 对浮点数保留两位小数。
   - `{:x}` 将整数转换为十六进制表示。
   - `{:<10}` 左对齐并在前面填充空格至总宽度 10。
   - `{:0>5}` 右对齐并在后面填充零至总宽度 5。
   - `{:^5}` 居中对齐并在两边填充空格至总宽度 5。
   - 更多组合如：`{:+05}` 表示带符号的整数右对齐，前面填充零至总宽度 5。

4. **命名参数 `{name}` 和 `{name:fmt}`**

   - 使用命名参数可以避免按顺序传递参数，提高代码可读性。name 对应变量名，fmt 是可选的格式说明符。

5. **特殊格式**

   - `{:#?}` 提供更详细的调试格式，对于结构体和枚举，会增加缩进和换行。
   - `{:.width$}` 控制字符串宽度，`.width$` 中的 `width` 是期望的最小宽度。

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

`Box` 是一种非常有用的**智能指针**，允许你在**堆**上分配内存，而不是在**栈**上。

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

## 5.关联类型

`Rust` 中的关联类型是一种特殊机制，它允许在 `traits` 中定义类型占位符，这些类型将在 `trait` 实现时被具体指定。关联类型提供了灵活的泛型抽象能力，使得 `trait` 可以更加抽象和通用。

**定义关联类型**：在 trait 定义中，可以声明一个或多个关联类型。这通常用于表示 trait 方法返回或接收的类型，而这些类型与实现该 trait 的具体类型有关。关联类型声明看起来像这样：

```rust {hl_lines=[3]}
trait MyTrait {
    // ItemType 是关联类型
    type ItemType;

    fn do_something(&self) -> Self::ItemType;
}
```

**实现关联类型**：当实现一个包含关联类型的 `trait` 时，需要为这些关联类型指定实际的类型。例如：

```rust
struct MyStruct {
    // ...
}

impl MyTrait for MyStruct {
    type ItemType = String;

    fn do_something(&self) -> Self::ItemType {
        // 实现细节
        String::from("Something")
    }
}
```

### 5.1 与泛型参数的区别

泛型参数是在定义函数、结构体、枚举或特质时用来表示一种待指定的类型。泛型参数**在使用时**需要明确指定所有相关的类型。

```rust
trait Container<T> {
    fn get(&self, index: usize) -> Option<&T>;
}

// 实现这个特质的具体结构体
struct MyContainer<T> {
    items: Vec<T>,
}

impl<T> Container<T> for MyContainer<T> {
    fn get(&self, index: usize) -> Option<&T> {
        self.items.get(index)
    }
}
```

## 6.字面量标记

### 6.1 原始标识符

在 Rust 中，`r#` 是一种原始（raw）**字符串字面量** 的标记，它允许你编写包含特殊字符（如引号、反斜杠等）的字符串，而无需对这些字符进行转义。当你在一个字符串中需要多次使用通常需要转义的字符，或者字符串中包含大量的特殊字符时，原始字符串字面量特别有用。

```rust
let abi_str: &str = r#"[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint64","name":"number","type":"uint64"}],"name":"MyEvent","type":"event"},{"inputs":[],"name":"greet","outputs":[],"stateMutability":"nonpayable","type":"function"}]"#
```

### 6.2 字节字符串

用 `b"..."` 来表示。这将创建一个字节字符串，内容是 ASCII 字符的字节序列。非 ASCII 字符必须使用转义序列。

```rust
let b: &[u8; 5] = b"hello";
```

### 6.3 原始字节字符串

用 `br"..."` 或 `br#"..."#` 等形式表示。这结合了原始字符串和字节字符串的特性，允许你创建不需要转义的字节序列。

```rust
let raw_bytestring = br"\xFF\0";
println!("{:?}", raw_bytestring);

// 输出： [92, 120, 70, 70, 92, 48]
```

## 7.unsafe

在 **Rust** 中，`unsafe` 关键字用于标记一段代码或一个函数为不安全的。这意味着这段代码可以违反 **Rust** 的安全保证，比如解引用裸指针、调用不安全的函数等。使用 `unsafe` 时，开发者必须确保他们遵循了内存安全和其他 **Rust** 安全规则，因为编译器不会进行自动检查。

### 7.1 解引用裸指针

**Rust** 默认使用智能指针来管理内存，这些指针包括 `Box`, `Rc`, 和 `Arc` 等，它们保证了内存安全。然而，**Rust** 同时支持使用裸指针 `*const T` 和 `*mut T`，它们类似于 **_C/C++_** 中的指针，但是在 **Rust** 中，对这些指针的解引用需要在 `unsafe` 块中完成：

```rust
let mut x = 10;
let ptr = &mut x as *mut i32;

unsafe {
    // (*ptr): i32
    *ptr += 1;
}
```

### 7.2 调用不安全的函数或方法

有些系统级的函数调用是不安全的，比如直接与操作系统底层 API 交互的函数。这些函数需要在 `unsafe` 块中调用：

```rust
unsafe {
    libc::puts("Hello, world!".as_ptr() as *const _);
}
```

### 7.3 访问或修改可变静态变量

在 **Rust** 中，全局变量被定义为静态变量，对静态可变变量的访问需要在 `unsafe` 块中进行，因为它可能导致数据竞争：

```rust
static mut COUNTER: i32 = 0;

unsafe {
    COUNTER += 1;
}
```

### 7.4 实现不安全的 trait

有时候，某些 `trait` 的实现本身就是不安全的，因为它们需要满足某些内存安全的约束条件，这需要在 `unsafe` 块中实现：

```rust
unsafe trait UnsafeTrait {}

unsafe impl UnsafeTrait for i32 {}
```

### 7.5 使用原则

使用 `unsafe` 代码时，需要格外小心，确保这部分代码不会引入内存不安全的问题，比如悬垂指针、越界访问、数据竞争等。通常建议将 `unsafe` 代码封装在安全的 API 中，让大部分代码仍然保持 **Rust** 的安全特性。在实际开发中，应尽可能减少 `unsafe` 代码的使用，以利用 **Rust** 的内存安全保证。

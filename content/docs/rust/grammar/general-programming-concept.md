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

在 Rust 中，变量默认是不可变的（immutable）。这是 Rust 推动你以充分利用 Rust 提供的安全性和简单并发性来编写代码的很多助推器之一。

### 1.1 变量不可变性
```rust
fn main() {
    let x = 5;
    println!("The value of x is: {}", x);
    // x = 6; // 编译错误：cannot assign twice to immutable variable
}
```

### 1.2 可变变量
当变量是可变的，可以使用 `mut` 关键字：
```rust
fn main() {
    let mut x = 5;
    println!("The value of x is: {}", x);
    x = 6;
    println!("The value of x is: {}", x);
}
```

### 1.3 常量
常量（constant）是绑定到一个名称的不允许改变的值，但是常量与变量还是有一些区别：

1. **不允许对常量使用 `mut`**：常量不光默认不能变，它总是不能变
2. **声明常量使用 `const` 关键字而不是 `let`**，并且必须注明值的类型
3. **常量可以在任何作用域中声明**，包括全局作用域
4. **常量只能被设置为常量表达式**，而不能是函数调用的结果，或任何其他只能在运行时计算出的值

```rust
const THREE_HOURS_IN_SECONDS: u32 = 60 * 60 * 3;

fn main() {
    println!("Three hours in seconds: {}", THREE_HOURS_IN_SECONDS);
}
```

常量的命名约定是在单词之间使用下划线将其全部设置为大写。编译器能够在编译时计算一组有限的操作，这使我们可以选择以更容易理解和验证的方式写出此值，而不是将此常量设置为值 10,800。

### 1.4 遮蔽（Shadowing）
你可以定义一个与之前变量同名的新变量，而新变量会**遮蔽**之前的变量。Rust 称之为第一个变量被第二个**遮蔽**了：

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

遮蔽与将变量标记为 `mut` 是有区别的：
1. **重新使用 `let` 时，实际上创建了一个新变量**，我们可以改变值的类型，并且复用这个名字
2. **使用 `mut` 时，不能改变变量的类型**

```rust
// 遮蔽允许类型转换
let spaces = "   ";
let spaces = spaces.len();

// 以下代码会编译错误
let mut spaces = "   ";
// spaces = spaces.len(); // 错误：类型不匹配
```

## 2.数据类型

Rust 是**静态类型**（statically typed）语言，也就是说在编译时就必须知道所有变量的类型。根据值及其使用方式，编译器通常可以推断出我们想要用的类型。当多种类型均有可能时，必须增加类型注解。

### 2.1 标量类型
标量（scalar）类型表示单个值。Rust 有 4 个基本的标量类型：整型、浮点型、布尔型和字符。

#### 2.1.1 整型
整型是没有小数部分的数字。

| 长度 | 有符号 | 无符号 |
|------|--------|--------|
| 8-bit | i8 | u8 |
| 16-bit | i16 | u16 |
| 32-bit | i32 | u32 |
| 64-bit | i64 | u64 |
| 128-bit | i128 | u128 |
| arch | isize | usize |

有符号和无符号代表数字能否为负值：
- **有符号数**：存储从 -(2^n - 1) 到 2^n - 1 - 1 的数字（其中 n 是位数）
- **无符号数**：存储从 0 到 2^n - 1 的数字

`isize` 和 `usize` 类型依赖运行程序的计算机架构：64 位架构上它们是 64 位的，32 位架构上它们是 32 位的。

**整型字面值**：
```rust
fn main() {
    let decimal = 98_222;        // 十进制
    let hex = 0xff;              // 十六进制
    let octal = 0o77;            // 八进制
    let binary = 0b1111_0000;    // 二进制
    let byte = b'A';             // 字节（仅限 u8）
}
```

#### 2.1.2 浮点型
Rust 有两个原生的浮点数类型，它们是带小数点的数字：

```rust
fn main() {
    let x = 2.0;        // f64，默认类型
    let y: f32 = 3.0;   // f32
}
```

- `f32` 是单精度浮点数
- `f64` 是双精度浮点数，默认类型，因为在现代 CPU 中它与 `f32` 速度几乎一样，不过精度更高

#### 2.1.3 数值运算
Rust 中的所有数字类型都支持基本数学运算：

```rust
fn main() {
    // 加法
    let sum = 5 + 10;

    // 减法
    let difference = 95.5 - 4.3;

    // 乘法
    let product = 4 * 30;

    // 除法
    let quotient = 56.7 / 32.2;
    let floored = 2 / 3; // 结果为 0

    // 取余
    let remainder = 43 % 5;
}
```

#### 2.1.4 布尔型
Rust 中的布尔类型有两个可能的值：`true` 和 `false`。Rust 中的布尔类型使用 `bool` 表示：

```rust
fn main() {
    let t = true;
    let f: bool = false; // 显式指定类型注释
}
```

#### 2.1.5 字符类型
Rust 的 `char` 类型是最原生的字母类型：

```rust
fn main() {
    let c = 'z';
    let z = 'ℤ';
    let heart_eyed_cat = '😻';
}
```

注意，我们用单引号声明 `char` 字面量，而与之相反的是，使用双引号声明字符串字面量。Rust 的 `char` 类型的大小为四个字节（four bytes），并代表了一个 Unicode 标量值（Unicode Scalar Value）。

### 2.2 复合类型
复合类型（compound type）可以将多个值组合成一个类型。Rust 有两种基本的复合类型：元组（tuple）和数组（array）。

#### 2.2.1 元组类型
元组是一个将多个其他类型的值组合进一个复合类型的主要方式。元组长度固定：一旦声明，其长度不会增大或缩小。

**创建元组**：
```rust
fn main() {
    let tup: (i32, f64, u8) = (500, 6.4, 1);
}
```

**解构元组**：
```rust
fn main() {
    let tup = (500, 6.4, 1);
    let (x, y, z) = tup;
    println!("The value of y is: {}", y);
}
```

**使用索引访问元组元素**：
```rust
fn main() {
    let x: (i32, f64, u8) = (500, 6.4, 1);
    let five_hundred = x.0;
    let six_point_four = x.1;
    let one = x.2;
}
```

不带任何值的元组 `()` 是一种特殊的类型，只有一个值，也写成 `()`。该类型被称为 **单元类型**（unit type），而该值被称为 **单元值**（unit value）。

#### 2.2.2 数组类型
与元组不同，数组中的每个元素的类型必须相同。Rust 中的数组与一些其他语言中的数组不同，Rust 中的数组长度是固定的。

**创建数组**：
```rust
fn main() {
    let a = [1, 2, 3, 4, 5];
    let months = ["January", "February", "March", "April", "May", "June", "July",
                  "August", "September", "October", "November", "December"];
}
```

**显式指定数组类型和长度**：
```rust
fn main() {
    let a: [i32; 5] = [1, 2, 3, 4, 5];
}
```

**创建包含相同值的数组**：
```rust
fn main() {
    let a = [3; 5]; // 等价于 let a = [3, 3, 3, 3, 3];
}
```

**访问数组元素**：
```rust
fn main() {
    let a = [1, 2, 3, 4, 5];
    let first = a[0];
    let second = a[1];
}
```

**数组边界检查**：
```rust
use std::io;

fn main() {
    let a = [1, 2, 3, 4, 5];

    println!("Please enter an array index.");

    let mut index = String::new();
    io::stdin()
        .read_line(&mut index)
        .expect("Failed to read line");

    let index: usize = index
        .trim()
        .parse()
        .expect("Index entered was not a number");

    let element = a[index]; // 如果索引超出边界，程序会 panic

    println!("The value of the element at index {} is: {}", index, element);
}
```

当你尝试用索引访问一个元素时，Rust 会检查指定的索引是否小于数组的长度。如果索引超出了数组长度，Rust 会 **panic**，这是 Rust 术语，它意味着程序因为错误而退出。



## 3.函数

函数在 Rust 代码中很普遍。你已经见过语言中最重要的函数之一：`main` 函数，它是很多程序的入口点。你也见过 `fn` 关键字，它用来声明新函数。

### 3.1 函数定义
Rust 代码中的函数定义以 `fn` 开始并在函数名后跟一对圆括号。大括号告诉编译器哪里是函数体的开始和结尾。

```rust
fn main() {
    println!("Hello, world!");
    another_function();
}

fn another_function() {
    println!("Another function.");
}
```

Rust 不关心函数定义所在的位置，只要函数被调用时出现在调用之处可见的作用域内就行。

### 3.2 参数
我们可以定义为拥有**参数**（parameters）的函数，参数是特殊变量，是函数签名的一部分。当函数拥有参数（形参）时，可以为这些参数提供具体的值（实参）。

```rust
fn main() {
    another_function(5);
}

fn another_function(x: i32) {
    println!("The value of x is: {}", x);
}
```

在函数签名中，**必须**声明每个参数的类型。这是 Rust 设计中一个经过慎重考虑的决定：要求在函数定义中提供类型注解，意味着编译器不需要你在其他地方注明类型就能知道你的意图。

### 3.3 包含多个参数的函数
```rust
fn main() {
    print_labeled_measurement(5, 'h');
}

fn print_labeled_measurement(value: i32, unit_label: char) {
    println!("The measurement is: {}{}", value, unit_label);
}
```

### 3.4 语句和表达式
函数体由一系列的**语句**和一个可选的结尾**表达式**构成。目前为止，我们只介绍了没有结尾表达式的函数，不过你已经见过作为语句一部分的表达式。因为 Rust 是一门基于表达式（expression-based）的语言，这个区别很重要。

- **语句**（Statements）是执行一些操作但不返回值的指令
- **表达式**（Expressions）计算并产生一个值

```rust
fn main() {
    let y = 6; // 这是一个语句

    // 表达式示例
    let y = {
        let x = 3;
        x + 1  // 注意：这里没有分号，这是一个表达式
    };

    println!("The value of y is: {}", y);
}
```

表达式可以是语句的一部分。表达式的结尾没有分号。如果在表达式的结尾加上分号，它就变成了语句，而语句不会返回值。

### 3.5 具有返回值的函数
函数可以向调用它的代码返回值。我们不对返回值命名，但要在箭头（`->`）后声明它的类型。在 Rust 中，函数的返回值等同于函数体最后一个表达式的值。

```rust
fn five() -> i32 {
    5
}

fn main() {
    let x = five();
    println!("The value of x is: {}", x);
}
```

### 3.6 提前返回
你可以使用 `return` 关键字和一个值，来从函数中提前返回；但大部分函数隐式地返回最后的表达式。

```rust
fn plus_one(x: i32) -> i32 {
    x + 1
}

fn main() {
    let x = plus_one(5);
    println!("The value of x is: {}", x);
}
```

如果我们在包含 `x + 1` 的行尾加上一个分号，把它从表达式变成语句，我们将看到一个错误：

```rust
fn plus_one(x: i32) -> i32 {
    x + 1; // 错误：函数应该返回 i32，但这里返回的是 ()
}
```

## 4.注释

所有程序员都力求使其代码易于理解，不过有时还需要额外的解释。在这种情况下，程序员在源码中留下**注释**（comments），编译器会忽略它们，不过阅读代码的人可能觉得有用。

### 4.1 行注释
在 Rust 中，惯用的注释样式是以两个斜杠开始注释，并持续到本行的结尾：

```rust
fn main() {
    // hello, world
    println!("Hello, world!");
}
```

对于超过一行的注释，需要在每一行前都加上 `//`：

```rust
// So we're doing something complicated here, long enough that we need
// multiple lines of comments to do it! Whew! Hopefully, this comment will
// explain what's going on.
```

注释也可以在包含代码的行的末尾：

```rust
fn main() {
    let lucky_number = 7; // 我很幸运
}
```

### 4.2 文档注释
Rust 也有另一种注释，称为**文档注释**（documentation comment），这类注释会生成 HTML 文档。这些 HTML 展示公有 API 文档注释的内容，它们意在让对库感兴趣的程序员了解如何**使用**这个 crate，而不是它是如何被**实现**的。

文档注释使用三斜杠 `///` 而不是两斜杠以及支持 Markdown 标记来格式化文本：

```rust
/// Adds one to the number given.
///
/// # Examples
///
/// ```
/// let arg = 5;
/// let answer = my_crate::add_one(arg);
///
/// assert_eq!(6, answer);
/// ```
pub fn add_one(x: i32) -> i32 {
    x + 1
}
```

### 4.3 包含项的文档注释
还有另一种风格的文档注释，`//!`，这为包含注释的项，而不是注释之后的项增加文档。这通常用于 crate 根文件（通常是 src/lib.rs）或模块的根文件为 crate 或模块整体提供文档：

```rust
//! # My Crate
//!
//! `my_crate` is a collection of utilities to make performing certain
//! calculations more convenient.

/// Adds one to the number given.
// --snip--
```

## 5.控制流

根据条件是否为真来决定是否执行某些代码，或根据条件是否为真来重复运行代码，是大部分编程语言的基本组成部分。Rust 代码中最常见的用来控制执行流的结构是 `if` 表达式和循环。

### 5.1 if 表达式
`if` 表达式允许根据条件执行不同的代码分支。你提供一个条件并表示 "如果条件满足，运行这段代码；如果条件不满足，不运行这段代码。"

```rust
fn main() {
    let number = 3;

    if number < 5 {
        println!("condition was true");
    } else {
        println!("condition was false");
    }
}
```

#### 5.1.1 使用 else if 处理多重条件
```rust
fn main() {
    let number = 6;

    if number % 4 == 0 {
        println!("number is divisible by 4");
    } else if number % 3 == 0 {
        println!("number is divisible by 3");
    } else if number % 2 == 0 {
        println!("number is divisible by 2");
    } else {
        println!("number is not divisible by 4, 3, or 2");
    }
}
```

#### 5.1.2 在 let 语句中使用 if
因为 `if` 是一个表达式，我们可以在 `let` 语句的右侧使用它：

```rust
fn main() {
    let condition = true;
    let number = if condition { 5 } else { 6 };

    println!("The value of number is: {}", number);
}
```

记住，代码块的值是其最后一个表达式的值，而数字本身就是一个表达式。在这个例子中，整个 `if` 表达式的值取决于哪个代码块被执行。这意味着 `if` 的每个分支的可能的返回值都必须是相同类型。

### 5.2 循环
多次执行同一段代码是很常用的。为了这个功能，Rust 提供了几种**循环**（loops）。一个循环执行循环体中的代码直到结尾并紧接着回到开头继续执行。

#### 5.2.1 使用 loop 重复执行代码
`loop` 关键字告诉 Rust 一遍又一遍地执行一段代码直到你明确要求停止。

```rust
fn main() {
    loop {
        println!("again!");
    }
}
```

#### 5.2.2 从循环返回值
`loop` 的一个用例是重试可能会失败的操作，比如检查线程是否完成了任务。然而你可能会需要将操作的结果传递给其它的代码。如果将返回值加入你用来停止循环的 `break` 表达式，它会被停止的循环返回：

```rust
fn main() {
    let mut counter = 0;

    let result = loop {
        counter += 1;

        if counter == 10 {
            break counter * 2;
        }
    };

    println!("The result is {}", result);
}
```

#### 5.2.3 循环标签来消除多个循环间的歧义
如果存在嵌套循环，`break` 和 `continue` 应用于此时最内层的循环。你可以选择在一个循环上指定一个**循环标签**（loop label），然后将标签与 `break` 或 `continue` 一起使用，使这些关键字应用于已标记的循环而不是最内层的循环。

```rust
fn main() {
    let mut count = 0;
    'counting_up: loop {
        println!("count = {}", count);
        let mut remaining = 10;

        loop {
            println!("remaining = {}", remaining);
            if remaining == 9 {
                break;
            }
            if count == 2 {
                break 'counting_up;
            }
            remaining -= 1;
        }

        count += 1;
    }
    println!("End count = {}", count);
}
```

#### 5.2.4 while 条件循环
在程序中计算循环的条件也很常见。当条件为真，执行循环。当条件不再为真，调用 `break` 停止循环。这个循环类型可以通过组合 `loop`、`if`、`else` 和 `break` 来实现；然而，这个模式太常用了，Rust 为此内置了一个语言结构，它被称为 `while` 循环。

```rust
fn main() {
    let mut number = 3;

    while number != 0 {
        println!("{}!", number);

        number -= 1;
    }

    println!("LIFTOFF!!!");
}
```

#### 5.2.5 使用 for 遍历集合
可以使用 `while` 结构来遍历集合中的元素，比如数组。然而，这个过程很容易出错；如果索引长度不正确会导致程序 panic。这也使程序更慢，因为编译器增加了运行时代码来对每次循环的每个元素进行条件检查。

```rust
fn main() {
    let a = [10, 20, 30, 40, 50];

    for element in a {
        println!("the value is: {}", element);
    }
}
```

#### 5.2.6 使用 Range
可以使用 Range 来生成所有数字的序列，这是标准库提供的类型，它生成从一个数字开始到另一个数字之前结束的所有数字的序列。

```rust
fn main() {
    for number in (1..4).rev() {
        println!("{}!", number);
    }
    println!("LIFTOFF!!!");
}
```

这段代码看起来更帅气不是吗？

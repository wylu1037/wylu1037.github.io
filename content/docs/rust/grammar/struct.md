---
title: 结构体
date: 2024-03-11T19:49:53+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 4
---

## 1.定义并实例化结构体

### 1.1 定义结构体

```rust
struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}
```

### 1.2 实例化结构体

```rust
fn main() {
    let user1 = User {
        email: String::from("someone@example.com"),
        username: String::from("jack"),
        active: true,
        sign_in_count: 1,
    };
}
```

### 1.3 结构体更新语法

使用旧实例的大部分值但改变其部分值来创建一个新的结构体实例通常很有用。这可以通过结构体更新语法（struct update syntax）实现。

```rust
fn main() {

    let user1 = User {
        email: String::from("someone@example.com"),
        username: String::from("someusername123"),
        active: true,
        sign_in_count: 1,
    };

    let user2 = User {
        email: String::from("another@example.com"),
        ..user1
    };
}
```

> 在创建 user2 后不能再使用 user1，因为 user1 的 username 字段中的 String 被移到 user2 中。如果给 user2 的 email 和 username 都赋予新的 String 值，从而只使用 user1 的 active 和 sign_in_count 值，那么 user1 在创建 user2 后仍然有效。active 和 sign_in_count 的类型是实现 Copy trait 的类型。

### 1.4 使用没有命名字段的元祖结构体

#### 1.4.1 元祖结构体 tuple struct

```rust
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

fn main() {
    let black = Color(0, 0, 0);
    let origin = Point(0, 0, 0);
}
```

#### 1.4.2 类单元结构体

类单元结构体（_unit-like structs_）没有任何字段的结构体。

```rust
struct AlwaysEqual;

fn main() {
    let subject = AlwaysEqual;
}
```

### 1.5 结构体数据的所有权

可以使结构体存储被其它对象拥有数据的引用，需要用上生命周期（lifetime）。生命周期确保结构体引用的数据有效性跟结构体本身保持一致。

```rust
struct User {
    active: bool,
    username: &str, // expected named lifetime parameter
    email: &str, // expected named lifetime parameter
    sign_in_count: u64,
}

fn main() {
    let user1 = User {
        email: "someone@example.com",
        username: "jack",
        active: true,
        sign_in_count: 1,
    };
}
```

## 2.使用结构体

### 2.1 计算面积

```rust
fn main() {
    let width1 = 30;
    let height1 = 50;

    println!(
        "The area of the rectangle is {} square pixels.",
        area(width1, height1)
    );
}

fn area(width: u32, height: u32) -> u32 {
    width * height
}
```

### 2.2 通过 trait 增加功能

在 `println!("rect1 is {:?}", rect1);` 中加入 `:?` 指示符告诉 `println!` 要使用叫做 `Debug` 的输出格式。

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let rect1 = Rectangle {
        width: 30,
        height: 50,
    };

    println!("rect1 is {:?}", rect1);
}
```

另一种使用 Debug 格式打印数值的方法是使用 dbg! 宏。dbg! 宏接收一个表达式的所有权，打印出代码中调用 dbg! 宏时所在的文件和行号，以及该表达式的结果值，并返回该值的所有权。

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let scale = 2;
    let rect1 = Rectangle {
        width: dbg!(30 * scale),
        height: 50,
    };

    dbg!(&rect1);
}
```

## 3.方法语法

方法与函数类似，使用关键字`fn`关键字和名称声明，不同的是方法是在结构体的上下文中被定义（或者是枚举或 trait 对象的上下文），并且方法的第一个参数总是`&self`，表示调用该方法的结构体实例。

### 3.1 定义方法

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}

fn main() {
    let rect1 = Rectangle {
        width: 30,
        height: 50,
    };

    println!(
        "The area of the rectangle is {} square pixels.",
        rect1.area()
    );
}
```

在 area 的签名中，使用 &self 来替代 rectangle: &Rectangle，&self 实际上是 self: &Self 的缩写。在一个 impl 块中，Self 类型是 impl 块的类型的别名。方法的第一个参数必须有一个名为 self 的 Self 类型的参数，所以 Rust 让你在第一个参数位置上只用 self 这个名字来缩写。注意，仍然需要在 self 前面使用 & 来表示这个方法借用了 Self 实例，就像在 rectangle: &Rectangle 中做的那样。方法可以选择获得 self 的所有权，或者像这里一样不可变地借用 self，或者可变地借用 self，就跟其他参数一样。

### 3.2 自动引用和解引用

当使用 object.something() 调用方法时，Rust 会自动为 object 添加 &、&mut 或 \* 以便使 object 与方法签名匹配。

```rust
p1.distance(&p2);
(&p1).distance(&p2);
```

这种自动引用的行为之所以有效，是因为方法有一个明确的接收者 ———— self 的类型。在给出接收者和方法名的前提下，Rust 可以明确地计算出方法是仅仅读取（&self），做出修改（&mut self）或者是获取所有权（self）。事实上，Rust 对方法接收者的隐式借用让所有权在实践中更友好。

### 3.3 带更多参数的方法

```rust
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}
```

### 3.4 关联函数

不是方法。
关联函数经常被用作返回一个结构体新实例的构造函数。

```rust
impl Rectangle {
    fn square(size: u32) -> Rectangle {
        Rectangle {
            width: size,
            height: size,
        }
    }
}
```

### 3.5 多个 impl 块

每个结构体都允许拥有多个 `impl` 块。

```rust
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}

impl Rectangle {
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}
```

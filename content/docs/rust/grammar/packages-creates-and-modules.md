---
title: 使用包、crate和模块
date: 2024-03-11T19:50:39+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 6
---

## 1.包和crate
### 1.1 crate
crate是一个二进制项（Binary Application）或者库（Library）。crate root是一个源文件，`Rust`编译器以它为起始点，并构成crate的根模块。

### 1.2 包
包（package）是提供一系列功能的一个或者多个 crate。一个包会包含有一个 Cargo.toml 文件，阐述如何去构建这些 crate。

包中所包含的内容由以下规则确认：
+ 一个包中至多 只能 包含一个库 crate（library crate）；
+ 包中可以包含任意多个二进制 crate（binary crate）；
+ 包中至少包含一个 crate，无论是库的还是二进制的。

### 1.3 cargo new project-name
`Cargo`遵循一个约定，`src/mian.rs`就是一个与包同名的二进制`crate`。如果一个包同时含有`src/main.rs`和`src/lib.rs`，则它有两个`crate`：一个库和一个二进制项，且名字都与包相同。通过将文件放在`src/bin`目录下，一个包可以拥有多个二进制`crate`：每个`src/bin`下的文件都会被编译成一个独立的二进制`crate`。

一个`crate`会将一个作用域内的相关功能分组到一起，使得该功能可以很方便地在多个项目之间共享。如`rand` crate提供了生成随机数的功能，通过将`rand` crate加入到项目的作用域中，即可在自己的项目中使用该功能。`rand` crate提供的所有功能都可以通过该crate的名字`rand`进行访问。

## 2.定义模块
+ 路径`paths`
+ 将路径引入作用域`use`
+ 使项变为公有`pub`
+ `as`关键字
+ 外部包
+ `glob`运算符

模块可以将一个crate中的代码进行分组；控制项的私有性（即项是可以被外部代码使用的 public；还是作为一个内部实现的内容，不能被外部代码使用 private）

### 2.1 创建库
创建一个新的名为 restaurant 的库，然后将下面罗列出来的代码放入`src/lib.rs`中，来定义一些模块和函数。
```shell
cargo new --lib restaurant
```

```rust
mod front_of_house {
    mod hosting {
        fn add_to_waitlist() {}

        fn seat_at_table() {}
    }

    mod serving {
        fn take_order() {}

        fn serve_order() {}

        fn take_payment() {}
    }
}
```
使用关键字`mod`定义一个模块并指定模块名称，使用大括号包围模块的主体。

### 2.2 crate根
`src/main.rs`和`src/lib.rs`被称为`crate`根的原因是，这两个文件中任意一个的内容会构成名为 crate 的模块，且该模块位于 crate 的被称为 模块树 的模块结构的根部（"at the root of the crate’s module structure"）。

模块树
```shell
crate
 └── front_of_house
     ├── hosting
     │   ├── add_to_waitlist
     │   └── seat_at_table
     └── serving
         ├── take_order
         ├── serve_order
         └── take_payment
```

## 3.路径
为了在 Rust 的模块树中找到某个项，需要使用路径的方式，就像在文件系统使用路径一样。如果想要调用一个函数，需要知道它的路径。

路径有两种形式：
+ **绝对路径（absolute path）**：从 crate 根开始，以 crate 名或者字面值 `crate` 开头。
+ **相对路径（relative path）**：从当前模块开始，以 `self`、`super` 或当前模块的标识符开头。

### 3.1 绝对路径和相对路径
```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub fn eat_at_restaurant() {
    // 绝对路径
    crate::front_of_house::hosting::add_to_waitlist();

    // 相对路径
    front_of_house::hosting::add_to_waitlist();
}
```

### 3.2 使用 pub 关键字暴露路径
模块不仅对于组织代码很有用。它们还定义了 Rust 的 **私有性边界**（privacy boundary）：这条界线不允许外部代码了解、调用和依赖被封装的实现细节。所以，如果你希望创建一个库或二进制项的某一部分是私有的，可以将其放入模块。

Rust 中默认所有项（函数、方法、结构体、枚举、模块和常量）都是私有的。父模块中的项不能使用子模块中的私有项，但是子模块中的项可以使用他们父模块中的项。

### 3.3 使用 super 起始的相对路径
还可以使用 `super` 开头来构建从父模块开始的相对路径。这么做类似于文件系统中以 `..` 开头的语法。

```rust
fn serve_order() {}

mod back_of_house {
    fn fix_incorrect_order() {
        cook_order();
        super::serve_order();
    }

    fn cook_order() {}
}
```

## 4.使用use
使用 `use` 关键字可以将路径一次性引入作用域，然后调用该路径中的项，就如同它们是本地项一样。

### 4.1 基本用法
```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```

### 4.2 使用 use 的习惯用法
对于函数来说，我们习惯是指定到父模块，然后在调用时指定父模块，这样可以清晰地表明函数不是在本地定义的。

对于结构体、枚举和其他项，习惯是指定它们的完整路径：
```rust
use std::collections::HashMap;

fn main() {
    let mut map = HashMap::new();
    map.insert(1, 2);
}
```

### 4.3 使用 as 关键字提供新的名称
```rust
use std::fmt::Result;
use std::io::Result as IoResult;

fn function1() -> Result {
    // --snip--
    Ok(())
}

fn function2() -> IoResult<()> {
    // --snip--
    Ok(())
}
```

### 4.4 使用 pub use 重导出名称
当使用 `use` 关键字将名称导入作用域时，在新作用域中可用的名称是私有的。如果为了让调用你编写的代码的代码能够像在自己的作用域内引用这些类型，可以结合 `pub` 和 `use`。这个技术被称为 **重导出**（re-exporting）：

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
}
```

### 4.5 使用外部包
在 `Cargo.toml` 中加入依赖：
```toml
[dependencies]
rand = "0.8.3"
```

然后在代码中使用：
```rust
use rand::Rng;

fn main() {
    let secret_number = rand::thread_rng().gen_range(1..101);
}
```

### 4.6 嵌套路径来消除大量的 use 行
当需要引入很多定义于相同包或相同模块的项时，为每一项单独列出一行会占用源码很大的纵向空间。可以使用嵌套路径：

```rust
// 替代这样：
// use std::cmp::Ordering;
// use std::io;

use std::{cmp::Ordering, io};
```

```rust
// 替代这样：
// use std::io;
// use std::io::Write;

use std::io::{self, Write};
```

### 4.7 通过 glob 运算符将所有的公有定义引入作用域
如果希望将一个路径下所有公有项引入作用域，可以指定路径后跟 `*`，glob 运算符：

```rust
use std::collections::*;
```

**注意**：这个操作应该谨慎使用！Glob 会使得我们难以推导作用域中有什么名称和它们是在何处定义的。

## 5.分割模块到不同文件
当模块变得更大时，你可能想要将它们的定义移动到单独的文件中，从而使代码更容易阅读。

### 5.1 将模块移动到文件中
以 `front_of_house` 模块为例，将模块移动到各自的文件中：

**src/lib.rs**
```rust
mod front_of_house;

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```

**src/front_of_house.rs**
```rust
pub mod hosting;
```

**src/front_of_house/hosting.rs**
```rust
pub fn add_to_waitlist() {
    println!("Adding to waitlist...");
}
```

### 5.2 模块文件系统的规则
+ 如果一个名为 `foo` 的模块没有子模块，应该将 `foo` 的声明放在叫做 `foo.rs` 的文件中。
+ 如果一个名为 `foo` 的模块有子模块，应该将 `foo` 的声明放在叫做 `foo/mod.rs` 的文件中。

### 5.3 现代文件组织方式
在较新的 Rust 版本中，也可以使用这种文件组织方式：

```
src/
├── lib.rs
├── front_of_house.rs
└── front_of_house/
    ├── hosting.rs
    └── serving.rs
```

这样的话，`src/front_of_house.rs` 内容为：
```rust
pub mod hosting;
pub mod serving;
```

### 5.4 完整示例
这是一个完整的模块分离示例：

**项目结构：**
```
restaurant/
├── Cargo.toml
└── src/
    ├── lib.rs
    ├── front_of_house.rs
    └── front_of_house/
        ├── hosting.rs
        └── serving.rs
```

**src/lib.rs**
```rust
mod front_of_house;

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
}
```

**src/front_of_house.rs**
```rust
pub mod hosting;
pub mod serving;
```

**src/front_of_house/hosting.rs**
```rust
pub fn add_to_waitlist() {
    println!("Adding to waitlist...");
}

pub fn seat_at_table() {
    println!("Seating at table...");
}
```

**src/front_of_house/serving.rs**
```rust
pub fn take_order() {
    println!("Taking order...");
}

pub fn serve_order() {
    println!("Serving order...");
}

pub fn take_payment() {
    println!("Taking payment...");
}
```

这种方式让代码组织更加清晰，每个模块都有自己的文件，便于维护和理解。

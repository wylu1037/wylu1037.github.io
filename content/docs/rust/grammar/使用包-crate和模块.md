---
title: 使用包、crate和模块
date: 2024-03-11T19:50:39+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
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

## 4.使用use

## 5.分割模块

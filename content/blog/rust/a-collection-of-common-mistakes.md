---
title: 常见错误集锦
date: 2024-06-19T12:23:39+08:00
---

## Value used after being moved [E0382]
在Rust中，错误 **E0382** 表示你尝试使用一个已经被移动（moved）的值。在Rust里，当一个值被移动到另一个变量时，原来的变量就不能再被使用了，因为它的所有权（ownership）已经转移。这是Rust独特的所有权系统的一部分，旨在防止数据竞争和无效引用。

这个错误通常发生在以下情况：

1. 当一个非`Copy`类型的值被赋值给另一个变量时。
2. 当一个值被作为参数传递给函数时，这个值的所有权被转移给了函数的参数。

下面是一个具体的示例，展示了如何触发这个错误：

```rust
fn take_ownership(s: String) {
    println!("I own the String: {}", s);
}

fn main() {
    let s1 = String::from("hello");
    take_ownership(s1); // `s1` 的所有权被移动到函数 `take_ownership`

    println!("Can I use s1? {}", s1); // 错误！尝试使用已经被移动的值 `s1`
}
```

在这个例子中，`s1` 是一个`String`类型的值，它不是`Copy`类型。当我们调用`take_ownership(s1)`时，`s1`的所有权被移动到函数参数`s`中。在这之后，`s1`就不能再被使用了，因为它已经不再拥有那个`String`值。尝试在`take_ownership`函数调用之后打印`s1`会导致编译器报错 **E0382**。

要解决这个问题，你可以选择：

- 不在`take_ownership`之后使用`s1`。
- 使用引用传递，这样所有权不会被移动。
- 如果类型实现了`Clone` trait，可以克隆（clone）`s1`并传递克隆的值。


## temporary value dropped while borrowed [E0716]
```shell
error[E0716]: temporary value dropped while borrowed
  --> lattice/src/builder.rs:94:26
   |
94 |                 let sk = HexString::new("0x00a50da54a1987bf5ddd773e9c151bd40aa5d1281b8936dbdec93a9d0a04e4ca").decode().to_vec().as_slice();
   |                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^           - temporary value is freed at the end of this statement
   |                          |
   |                          creates a temporary value which is freed while still in use
95 |                 let (pow, signature) = transaction.sign(1, sk, Cryptography::Sm2p256v1);
   |                                                            -- borrow later used here
   |
   = note: consider using a `let` binding to create a longer lived value
```
### 临时值的定义
> 在Rust中，临时值（temporary values）是在表达式求值过程中创建的，但不会被绑定到变量上的值。这些值通常在表达式结束后立即被销毁。临时值的生命周期通常很短，它们存在的时间只足以完成当前的操作。

示例：
```rust
fn create_vec() -> Vec<i32> {
    vec![1, 2, 3]
}

fn main() {
    let _temporary = create_vec(); // `create_vec()` 返回的 Vec<i32> 是一个临时值
    // `_temporary` 现在拥有这个临时值，所以它不会立即被销毁
}
```

```rust
fn main() {
    let _reference_to_temporary = &10; // `10` 是一个临时值，`_reference_to_temporary` 是对它的引用

    struct Point { x: i32, y: i32 }

    let _reference_to_temporary_struct = &Point { x: 1, y: 2 }; // `Point { x: 1, y: 2 }` 是一个临时值
    // `_reference_to_temporary_struct` 是对这个临时结构体实例的引用
}
```
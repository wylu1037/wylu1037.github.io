---
title: 常见错误集锦
date: 2024-06-19T12:23:39+08:00
categories: [rust]
tags: [error]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
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

```rust {hl_lines=[4,6]}
fn get_sk(&self) -> String {
    let credentials = &self.credentials;
    return if credentials.sk.is_empty() {
        let file_key = credentials.file_key.clone().expect("FileKey不能为空").as_str();
        let file_key = FileKey::new(file_key);
        let passphrase = credentials.passphrase.clone().expect("身份密码不能为空").as_str();
        let result = file_key.decrypt(passphrase);
        let sk = result.unwrap().secret_key.to_str_radix(16);
        sk
    } else {
        credentials.sk.to_string()
    };
}
```
> + `credentials.file_key.clone()` 创建了一个临时的 Option<String> 值。
> + `expect("FileKey不能为空")` 取出了这个临时 Option<String> 的值，并返回一个 String。
> + `as_str()` 方法返回一个对这个 String 的临时借用，这个借用在语句结束时就无效了。

### 什么时候会创建临时值
#### 1.方法调用链
当你在方法链中调用方法时，每个方法调用都可能创建一个临时值，尤其是在处理返回引用的方法时。比如：
```rust
let s = String::from("hello");
let slice = s.to_uppercase().as_str(); // `to_uppercase()` 创建了一个新的 `String`，`as_str()` 返回对它的引用
```
> 在这段代码中，`to_uppercase()` 创建了一个临时的 `String`，而 `as_str()` 则尝试借用这个临时值。在语句结束时，这个临时值会被丢弃，导致引用失效。

#### 2.方法返回值是 Option 或 Result
当你调用一个返回 Option 或 Result 的方法，并紧接着调用方法获取内部值时，也会创建临时值：
```rust
let value = some_option.unwrap().as_str();
```
> 在这段代码中，`unwrap()` 会从 `Option<String>` 中获取一个临时的 `String`，`as_str()` 则返回对这个临时 `String` 的引用。此引用在语句结束时可能变得无效。

#### 3.临时变量绑定
当你在代码中进行复杂的表达式计算时，Rust 可能会在中间步骤中创建临时变量。例如：
```rust
let x = &vec![1, 2, 3][0];
```
> 在这段代码中，`vec![1, 2, 3]` 创建了一个临时的 `Vec`，然后对第一个元素的引用被绑定到 `x` 上。这个临时 `Vec` 会在语句结束时被丢弃，导致 `x` 变得无效。

#### 4.结构体字段的临时引用
当你通过访问结构体的字段并获取其引用时，Rust 会创建一个临时的字段值。例如：
```rust
struct Foo {
    field: String,
}

let foo = Foo { field: String::from("Hello") };
let field_ref = foo.field.as_str();
```
> 这里 `foo.field` 是一个 `String`，`as_str()` 返回它的引用。如果没有将 `foo.field` 绑定到一个变量，Rust 会创建一个临时的 `String` 值，该值会在语句结束时被丢弃。

#### 5.闭包或迭代器中间值
闭包或迭代器中间的计算结果也可能创建临时值：
```rust
let sum = vec![1, 2, 3].iter().map(|x| x + 1).sum::<i32>();
```
> 在这段代码中，`iter()` 和 `map()` 都会返回临时值（迭代器对象），这些临时值在整个链条结束后被丢弃。

#### 6.隐式 into() 转换
当你在需要特定类型的地方提供了一个可以被隐式转换的类型时，Rust 会创建一个临时值来完成类型转换。例如：

```rust
let s: String = "hello".into();
```
> 这里 "hello" 是一个 &str，调用 `into()` 后会创建一个临时的 `String`。
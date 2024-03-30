---
title: 错误处理
date: 2024-03-30T14:17:53+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 8
---

## 1.panic!与不可恢复错误

## 2.Result与可恢复错误

`Result` 枚举，它定义有如下两个成员，`Ok` 和 `Err`：
```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```
> `T` 和 `E` 是泛型类型参数，`T` 代表成功时返回的 `Ok` 成员中的数据的类型，而 `E` 代表失败时返回的 `Err` 成员中的错误的类型。

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt");
}
```
<p align="center" style="color:#9ca3af;">打开文件</p>

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt");

    let f = match f {
        Ok(file) => file,
        Err(error) => {
            panic!("Problem opening the file: {:?}", error)
        },
    };
}
```
<p align="center" style="color:#9ca3af;">使用 match 表达式处理可能会返回的 Result 成员</p>

### 2.1 匹配不同错误
```rust
use std::fs::File;
use std::io::ErrorKind;

fn main() {
    let f = File::open("hello.txt");

    let f = match f {
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create("hello.txt") {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            other_error => panic!("Problem opening the file: {:?}", other_error),
        },
    };
}
```
<p align="center" style="color:#9ca3af;">使用不同的方式处理不同类型的错误</p>

### 2.2 unwrap 和 expect

`Result<T, E>` 类型定义了很多辅助方法来处理各种情况。其中之一叫做 `unwrap`，如果 `Result` 值是成员 `Ok`，`unwrap` 会返回 `Ok` 中的值。如果 `Result` 是成员 `Err`，`unwrap` 会为我们调用 `panic!`。
```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt").unwrap();
}
```

还有另一个类似于 `unwrap` 的方法，它还允许我们选择 `panic!` 的错误信息：`expect`。使用 `expect` 而不是 `unwrap` 并提供一个好的错误信息可以表明你的意图并更易于追踪 `panic` 的根源。
```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt").expect("Failed to open hello.txt");
}
```

### 2.3 传播错误
当编写一个需要先调用一些可能会失败的操作的函数时，除了在这个函数中处理错误外，还可以选择让调用者知道这个错误并决定该如何处理。这被称为 传播（propagating）错误，这样能更好地控制代码调用，因为比起你代码所拥有的上下文，调用者可能拥有更多信息或逻辑来决定应该如何处理错误。

```rust {hl_lines=[8,9,10,11]}
use std::io;
use std::io::Read;
use std::fs::File;

fn read_username_from_file() -> Result<String, io::Error> {
    let f = File::open("hello.txt");

    let mut f = match f {
        Ok(file) => file,
        Err(e) => return Err(e),
    };

    let mut s = String::new();

    match f.read_to_string(&mut s) {
        Ok(_) => Ok(s),
        Err(e) => Err(e),
    }
}
```

```rust {hl_lines=[6]}
use std::io;
use std::io::Read;
use std::fs::File;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut f = File::open("hello.txt")?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}
```
<p align="center" style="color:#9ca3af;">一个使用 ? 运算符向调用者返回错误的函数</p>

`?` 运算符消除了大量样板代码并使得函数的实现更简单。我们甚至可以在 `?` 之后直接使用链式方法调用来进一步缩短代码。
```rust {hl_lines=[8]}
use std::io;
use std::io::Read;
use std::fs::File;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut s = String::new();

    File::open("hello.txt")?.read_to_string(&mut s)?;

    Ok(s)
}
```

## 3.何时panic!

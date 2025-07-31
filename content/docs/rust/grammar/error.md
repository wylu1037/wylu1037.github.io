---
title: 错误处理
date: 2024-03-30T14:17:53+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 8
---

在 Rust 中，错误处理主要分为两大类：**不可恢复错误（Unrecoverable Errors）** 和 **可恢复错误（Recoverable Errors）**。

## 1. `panic!` 与不可恢复错误

当程序遇到不可恢复的错误时，会触发 `panic!`。`panic!` 宏执行时，程序会打印出一条错误信息，**展开调用栈（unwind the stack）** 并清理它遇到的每个函数中的数据，最后退出。

{{< callout >}}
##### **栈展开（Unwinding）与终止（Aborting）**

-   **展开 (Unwinding)**：这是默认行为。Rust 会回溯调用栈，并清理每个函数的数据。这保证了内存安全，但会涉及较多的工作。
-   **终止 (Aborting)**：程序立即退出，不进行任何清理。内存将由操作系统回收。这种方式产生的二进制文件更小。

你可以在 `Cargo.toml` 中配置 `panic` 行为。例如，在发布构建（release build）中设置为 `abort` 以获得性能优势：

```toml
[profile.release]
panic = 'abort'
```
{{< /callout >}}

## 2. `Result` 与可恢复错误

对于可恢复的错误，例如“文件未找到”或“网络请求失败”，Rust 提供了 `Result<T, E>` 枚举。

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

-   `T`：操作成功时，`Ok` 成员中返回值的类型。
-   `E`：操作失败时，`Err` 成员中错误的类型。

```rust
use std::fs::File;

// File::open 返回一个 Result<std::fs::File, std::io::Error>
let f = File::open("hello.txt");
```

我们可以使用 `match` 表达式来处理 `Result`：

```rust
use std::fs::File;

let f = File::open("hello.txt");

let f = match f {
    Ok(file) => file,
    Err(error) => {
        panic!("Problem opening the file: {:?}", error);
    },
};
```

<p align="center" style="color:#9ca3af;">使用 `match` 表达式处理 `Result`</p>

### 2.1 匹配不同类型的错误

`match` 表达式的强大之处在于可以根据不同的错误类型执行不同的逻辑。

```rust
use std::fs::File;
use std::io::ErrorKind;

let f = File::open("hello.txt");

let f = match f {
    Ok(file) => file,
    Err(error) => match error.kind() {
        // 如果是“文件未找到”错误，则尝试创建它
        ErrorKind::NotFound => match File::create("hello.txt") {
            Ok(fc) => fc,
            Err(e) => panic!("Problem creating the file: {:?}", e),
        },
        // 对于其他所有错误，直接 panic
        other_error => {
            panic!("Problem opening the file: {:?}", other_error);
        }
    },
};
```

<p align="center" style="color:#9ca3af;">根据 `ErrorKind` 执行不同的错误处理逻辑</p>

### 2.2 `unwrap` 和 `expect`

`Result<T, E>` 提供了两个便捷方法，用于在假定操作不会失败的场景下简化代码：

-   `unwrap()`：如果 `Result` 是 `Ok(T)`，它返回 `T`。如果是 `Err(E)`，它会调用 `panic!`。
-   `expect(message: &str)`：与 `unwrap` 类似，但在 `panic` 时会显示你提供的自定义错误信息，这使得追踪 `panic` 的来源更加容易。

```rust
use std::fs::File;

// 如果文件不存在，程序会 panic 并显示自定义消息
let f = File::open("hello.txt").expect("Failed to open hello.txt");
```

> **注意**：在生产代码中应谨慎使用 `unwrap` 和 `expect`。它们主要用于示例、原型开发或你确信 `Result` 不可能是 `Err` 的情况。

### 2.3 传播错误与 `?` 运算符

当函数内部发生错误时，通常更好的做法是将错误**传播（propagate）**给调用者，让调用者决定如何处理。

最初，这需要冗长的 `match` 表达式：

```rust
use std::io;
use std::fs::File;
use std::io::Read;

fn read_username_from_file() -> Result<String, io::Error> {
    let f = File::open("hello.txt");

    let mut f = match f {
        Ok(file) => file,
        Err(e) => return Err(e), // 提前返回错误
    };

    let mut s = String::new();

    match f.read_to_string(&mut s) {
        Ok(_) => Ok(s),
        Err(e) => Err(e),
    }
}
```

为了简化这个模式，Rust 提供了 `?` 运算符。它等同于一个 `match` 表达式：如果结果是 `Ok(T)`，它会提取 `T`；如果是 `Err(E)`，它会立即从当前函数返回 `Err(E)`。

```rust
use std::io;
use std::fs::File;
use std::io::Read;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut f = File::open("hello.txt")?; // 如果失败，立即返回 Err
    let mut s = String::new();
    f.read_to_string(&mut s)?; // 如果失败，立即返回 Err
    Ok(s)
}
```

<p align="center" style="color:#9ca3af;">使用 `?` 运算符传播错误</p>

`?` 运算符可以链式调用，使代码更加简洁：

```rust
use std::io;
use std::fs::File;
use std::io::Read;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut s = String::new();
    File::open("hello.txt")?.read_to_string(&mut s)?;
    Ok(s)
}
```

> **核心要求**：`?` 运算符只能在返回类型为 `Result<T, E>`、`Option<T>` 或其他实现了 `Try` trait 的类型的函数中使用。

## 3. 何时应该 `panic!`

在 Rust 中，如何决定何时 `panic!`，何时返回 `Result`，是构建健壮软件的关键。其指导原则是：**这个错误是否代表了程序进入了一个无法安全恢复的状态？**

#### 场景一：返回 `Result` —— 可预期的、可恢复的错误

当错误是可预期的、并且调用者有能力处理时，应该返回 `Result`。这是绝大部分情况下的首选。

-   **用户输入验证失败**：例如，用户提供了一个无效的 URL。
-   **外部服务交互失败**：例如，文件未找到 (`io::Error`)、网络连接中断、数据库查询失败。
-   **操作本身可能失败**：例如，将一个字符串解析为数字。

在这些情况下，失败是程序正常功能的一部分。调用者应该收到一个 `Err`，并决定是重试、提示用户还是以其他方式处理。**作为库的作者，你应该总是倾向于返回 `Result`**，将错误处理的最终决定权交给库的使用者。

#### 场景二：调用 `panic!` —— 不可恢复的、违反程序约定的错误

当程序进入一个它无法恢复的无效状态时，`panic!` 是合适的。在这种情况下，继续执行可能是不安全的，甚至会导致更严重的问题。

-   **违反程序不变量（Invariants）**：当代码的某个基本假设或约定被打破时。例如，一个本应只包含已排序数据的函数，却接收到了未排序的数据。
-   **无法修复的逻辑错误（Bug）**：当程序的状态表明存在一个 Bug，并且没有明确的方法来安全地处理它。例如，访问一个无效的数组索引 `my_vec[99]`（当 `my_vec` 只有 10 个元素时）。这种访问违反了内存安全的基本前提。
-   **原型代码和测试**：在编写示例代码、原型或测试时，使用 `unwrap()` 或 `expect()` 来快速处理错误是方便的。如果这些操作失败，它会直接 `panic!`，这能立即指出测试中的问题或原型中的逻辑错误。

    ```rust
    // 示例：解析一个硬编码的、已知有效的 IP 地址
    // 如果这里失败，说明程序员犯了错，而不是发生了可恢复的运行时错误
    use std::net::IpAddr;
    let home: IpAddr = "127.0.0.1".parse().expect("Hardcoded IP address should be valid");
    ```

**总结**

| 操作 | 适用场景 | 核心思想 |
| :--- | :--- | :--- |
| **返回 `Result`** | 预期的、可处理的失败（如文件未找到） | 错误是程序正常功能的一部分，将处理权交给调用者。 |
| **调用 `panic!`** | 意外的、不可恢复的失败（如 Bug、违反不变量） | 程序进入了无效状态，继续执行是不安全的。 |



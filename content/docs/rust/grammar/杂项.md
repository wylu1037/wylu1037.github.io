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

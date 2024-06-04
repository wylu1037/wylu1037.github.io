---
title: trait
date: 2024-06-04T08:08:11+08:00
---

## 1.trait
在 **Rust** 中，`trait` 是一种定义共享行为的方式。它类似于其他编程语言中的接口或者抽象基类，用于定义一组方法，这些方法可以在多个类型上实现。通过 `trait`，可以实现多态，并且可以为不同的类型提供统一的接口。

### 1.1 定义
```rust
trait Summary {
    fn summarize(&self) -> String;
}
```

### 1.2 默认实现
`trait` 方法可以提供默认实现。例如：
```rust
trait Summary {
    fn summarize(&self) -> String {
        String::from("(Read more...)")
    }
}
```

### 1.3 实现
```rust
struct Article {
    headline: String,
    content: String,
}

impl Summary for Article {
    fn summarize(&self) -> String {
        format!("{} - {}", self.headline, self.content)
    }
}
```

### 1.4 使用
#### 1.4.1 作为函数参数
可以使用 `trait` 作为函数参数，来接受任何实现了该 `trait` 的类型。例如：
```rust
fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}
```
或者使用更通用的方式：
```rust
fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```

#### 1.4.2 返回trait
可以定义函数返回实现某个 `trait` 的类型。例如：
```rust
fn returns_summarizable() -> impl Summary {
    Article {
        headline: String::from("Headline"),
        content: String::from("Content"),
    }
}
```

#### 1.4.3 trait 对象
`trait` 对象允许你在运行时处理不同类型的值，而不是在编译时。例如，使用 `dyn` 关键字：
```rust
fn notify(item: &dyn Summary) {
    println!("Breaking news! {}", item.summarize());
}
```
这种方式可以用于需要动态分发的情况，例如存储不同类型的对象集合。

### 1.5 继承
`trait` 也可以继承其他 `trait`，类似于类的继承。例如：
```rust
trait Display {
    fn display(&self) -> String;
}

trait Printable: Display {
    fn print(&self) {
        println!("{}", self.display());
    }
}
```

### 1.6 多重约束
可以对类型参数施加多个 `trait` 约束。例如：
```rust
fn notify<T: Summary + Display>(item: &T) {
    println!("Summary: {}", item.summarize());
    println!("Display: {}", item.display());
}
```
在这里，**T** 类型必须同时实现 `Summary` 和 `Display`。

## 2.Send

在 **Rust** 编程语言中，`Send` 是一个标记（marker）trait，它用于指示一个类型的值可以安全地在线程间传递。这个 trait 是 **Rust** 并发模型的一部分，确保数据在不同线程间传递时不会导致数据竞争和不安全的行为。

基本概念
`Send` Trait：任何实现了 `Send` trait 的类型都可以安全地在线程间传递。Rust 编译器会自动为大多数类型实现 `Send`，但如果一个类型包含了非 `Send` 类型的数据，那么这个类型也将不是 `Send`。

对于自定义类型，如果所有字段都是 `Send` 类型，那么编译器会自动为它实现 `Send` trait。
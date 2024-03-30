---
title: 常见集合
date: 2024-03-30T14:16:34+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 7
---

## 1.vector
### 1.1 新建vector
为了创建一个新的空 `vector`，可以调用 `Vec::new` 函数。
```rust
fn main() {
    let v: Vec<i32> = Vec::new();
}
```
<p align="center" style="color:#9ca3af;">新建一个空的 vector 来储存 i32 类型的值</p>

```rust
fn main() {
    let v = vec![1, 2, 3];
}
```
<p align="center" style="color:#9ca3af;">新建一个包含初值的 vector</p>

> 因为提供了 i32 类型的初始值，Rust 可以推断出 v 的类型是 Vec<i32>，因此类型标注就不是必须的。

### 1.2 更新vector
对于新建一个 vector 并向其增加元素，可以使用 push 方法。
```rust
fn main() {
    let mut v = Vec::new();

    v.push(5);
    v.push(6);
    v.push(7);
    v.push(8);
}
```

<p align="center" style="color:#9ca3af;">使用 push 方法向 vector 增加值</p>

### 1.3 丢弃vector
类似于任何其他的 struct，vector 在其离开作用域时会被释放。当 vector 被丢弃时，所有其内容也会被丢弃，这意味着这里它包含的整数将被清理。
```rust
fn main() {
    {
        let v = vec![1, 2, 3, 4];

        // 处理变量 v

    } // <- 这里 v 离开作用域并被丢弃
}
```
<p align="center" style="color:#9ca3af;">展示 vector 和其元素于何处被丢弃</p>

### 1.4 读取vector
```rust
fn main() {
    let v = vec![1, 2, 3, 4, 5];

    let third: &i32 = &v[2];
    println!("The third element is {}", third);

    match v.get(2) {
        Some(third) => println!("The third element is {}", third),
        None => println!("There is no third element."),
    }
}
```

<p align="center" style="color:#9ca3af;">使用索引语法或 get 方法来访问 vector 中的项</p>

### 1.5 遍历vector
```rust
fn main() {
    let v = vec![100, 32, 57];
    for i in &v {
        println!("{}", i);
    }
}
```
<p align="center" style="color:#9ca3af;">通过 for 循环遍历 vector 的元素并打印</p>


为了修改可变引用所指向的值，在使用 += 运算符之前必须使用解引用运算符（*）获取 i 中的值。
```rust
fn main() {
    let mut v = vec![100, 32, 57];
    for i in &mut v {
        *i += 50;
    }
}
```
<p align="center" style="color:#9ca3af;">遍历 vector 中元素的可变引用</p>

### 1.6 vector存储不同类型值
Rust 在编译时就必须准确的知道 vector 中类型的原因在于它需要知道储存每个元素到底需要多少内存。第二个好处是可以准确的知道这个 vector 中允许什么类型。如果 Rust 允许 vector 存放任意类型，那么当对 vector 元素执行操作时一个或多个类型的值就有可能会造成错误。使用枚举外加 match 意味着 Rust 能在编译时就保证总是会处理所有可能的情况。
```rust
enum SpreadsheetCell {
    Int(i32),
    Float(f64),
    Text(String),
}

let row = vec![
    SpreadsheetCell::Int(3),
    SpreadsheetCell::Text(String::from("blue")),
    SpreadsheetCell::Float(10.12),
];
```
<p align="center" style="color:#9ca3af;">定义一个枚举，以便能在 vector 中存放不同类型的数据</p>

## 2.字符串
Rust有两种字符串类型：str和String。其中str是String的切片类型，也就是说，str类型的字符串值是String类型的字符串值的一部分或全部。

```rust
fn main(){
  let s: &str = "junmajinlong.com";
  println!("{}", s);
}
```
<p align="center" style="color:#9ca3af;">字符串字面量</p>

String类型的字符串没有对应的字面量构建方式，只能通过Rust提供的方法来构建。
```rust
fn main(){
  // 类型自动推导为: String
  let s = String::from("junmajinlong.com");
  let s1 = "junmajinlong".to_string();
  println!("{},{}", s, s1);
}
```
<p align="center" style="color:#9ca3af;">String类型的字符串</p>

## 3.map
### 3.1 新建一个map
可以使用 `new` 创建一个空的 `HashMap`，并使用 `insert` 增加元素。
```rust
fn main() {
    use std::collections::HashMap;

    let mut scores = HashMap::new();

    scores.insert(String::from("Blue"), 10);
    scores.insert(String::from("Yellow"), 50);
}
```
<p align="center" style="color:#9ca3af;">新建一个哈希 map 并插入一些键值对</p>

### 3.2 map和所有权

<p align="center" style="color:#9ca3af;"></p>

### 3.3 访问map

<p align="center" style="color:#9ca3af;"></p>

### 3.4 更新map

<p align="center" style="color:#9ca3af;"></p>

### 3.5 哈希函数

<p align="center" style="color:#9ca3af;"></p>
<p align="center" style="color:#9ca3af;"></p>

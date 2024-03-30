---
title: 所有权
date: 2024-03-09T15:19:12+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 3
---

## 1.什么是所有权
### 1.1 所有权规则
+ `Rust` 中的每一个值都有一个被称为其 **所有者**(*owner*) 的变量；
+ 值在任一时刻有且只有一个所有者；
+ 当所有者（变量）离开作用域，这个值将被丢弃。

### 1.2 变量作用域
```rust
fn main() {
    {                      // s 在这里无效, 它尚未声明
        let s = "hello";   // 从此处起，s 开始有效

        // 使用 s
    }                      // 此作用域已结束，s 不再有效
}
```
<div style="text-align: center;">示例：一个变量和其有效的作用域</div>

### 1.3String类型
String类型管理被分配到<font style="color:orange;font-weight:bold">堆</font>上的数据，能够存储在编译期间未知大小的文本。
```rust

#![allow(unused)]
fn main() {
    let s = String::from("hello");
}
```
可以修改此类字符串。
```rust
fn main() {
    let mut s = String::from("hello");

    s.push_str(", world!"); // push_str() 在字符串后追加字面值

    println!("{}", s); // 将打印 `hello, world!`
}
```
> `String`与字符串字面量`&str`对内存的处理上有区别：
> + `String`分配在堆上；
> + 字符串字面量`&str`是静态的，大小在编译期间已知，通常存储在程序的只读内存段（常量区）中。`&str`是一个借用，是对已有字符串数据的引用。

### 1.4借用和引用
借用（Borrowing）：借用是指通过引用来临时地获取对数据的访问权限，而不获取所有权。借用分为不可变借用和可变借用两种类型。在进行借用时，原始数据的所有权仍然保持在借出数据的所有者手中，借用者只是暂时地获取对数据的引用，可以对其进行读取操作，但不能修改数据本身。
+ 不可变借用（Immutable Borrow）
  + 使用不可变引用（&T）来借用数据时，允许借用者读取数据，但不允许修改数据；
  + 不可变引用可以同时存在多个，并行地访问相同的数据，因为它们只是读取数据，不会造成数据竞争；
  + 借用者只能对数据进行只读操作，不能进行修改。
+ 可变借用（Mutable Borrow）
  + 使用可变引用（&mut T）来借用数据时，允许借用者对数据进行读写操作；
  + 可变引用在特定作用域内只能存在一个，并且不可同时存在不可变引用。这是为了防止数据竞争和不安全的并发访问；
  + 借用者可以修改数据，但在特定作用域内只能有一个可变引用，以确保数据的安全性。

引用（Reference）：引用是 Rust 中的一种数据类型，用于创建指向其他数据的指针。引用以 & 符号开头，可以是不可变引用 &T 或可变引用 &mut T。它们允许在不获取所有权的情况下访问数据。不可变引用允许读取数据，但不允许修改数据，而可变引用则允许对数据进行读写操作，但在特定作用域内只能有一个可变引用，以避免数据竞争。


### 1.5 内存与分配
#### 1.5.1 移动
`String`由三部分组成：一个指向存放字符串内容内存的指针，一个长度，和一个容量，这一组数据存储在栈上。右侧则是堆上存放内容的内存部分。
```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1;
}
```
{{< image "/images/docs/rust/grammar/String的内存结构组成.svg" "将值 hello 绑定给 s1 的 String 在内存中的表现形式" >}}

当将 s1 赋值给 s2，String 的数据被复制了，这意味着从栈上拷贝了它的指针、长度和容量，并没有复制指针指向的堆上数据。

{{< image "/images/docs/rust/grammar/String所有权move.svg" "变量 s2 的内存表现，它有一份 s1 指针、长度和容量的拷贝" >}}

> 当变量离开作用域之后，`Rust`会自动调用`drop`函数并清理变量的 **<u>堆</u>** 内存。<br>
> 
> 🙋当 s1 和 s2 离开作用域时，都会尝试释放相同的内存，是否会引发**二次释放**（*double free*）的错误。<br>
> 🧑‍🏫在 let s2 = s1 之后，Rust 认为 s1 不再有效，因此 Rust 不需要在 s1 离开作用域后清理任何东西。这个操作被称为 **移动**（*move*）。

#### 1.5.2 克隆
使用`clone`函数深度复制`String`中堆上的数据，不仅仅是栈上的数据。
```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1.clone();

    println!("s1 = {}, s2 = {}", s1, s2);
}
```
{{< image "/images/docs/rust/grammar/String克隆.svg" "String克隆" >}}

#### 1.5.3 只在栈上的数据：拷贝
```rust
fn main() {
    let x = 5;
    let y = x;

    println!("x = {}, y = {}", x, y);
}
```
> 像整型这样的在编译期间已知大小的类型被整个存储在栈上，所以拷贝其实际的值是快速的。在创建变量 y 后没有使 x 无效。

`Rust` 有一个叫做 `Copy trait` 的特殊标注，可以用在类似整型这样的存储在栈上的类型上。如果一个类型实现了 `Copy trait`，那么一个旧的变量在将其赋值给其它变量后仍然可用。`Rust` 不允许自身或其任何部分实现了 `Drop trait` 的类型使用 `Copy trait`。 如果对其值离开作用域时需要特殊处理的类型使用 `Copy` 标注，将会出现一个编译时错误。

任何一组简单标量值的组合都可以实现 `Copy`，任何不需要分配内存或某种形式资源的类型都可以实现 `Copy` 。如下是一些 `Copy` 的类型：
+ 所有整数类型，比如 u32。 
+ 布尔类型，bool，它的值是 true 和 false。 
+ 所有浮点数类型，比如 f64。 
+ 字符类型，char。 
+ 元组，当且仅当其包含的类型也都实现 Copy 的时候。比如，(i32, i32) 实现了 Copy，但 (i32, String) 就没有。

### 1.6 所有权与函数
将值传递给函数在语义上与给变量赋值相似，值可能会移动或者复制，就像赋值语句一样。
```rust
fn main() {
  let s = String::from("hello");  // s 进入作用域

  takes_ownership(s);             // s 的值移动到函数里 ...
                                  // ... 所以到这里不再有效

  let x :i32 = 5;                      // x 进入作用域

  makes_copy(x);                  // x 应该移动函数里，
                                  // 但 i32 是 Copy 的，所以在后面可继续使用 x

} // 这里, x 先移出了作用域，然后是 s。但因为 s 的值已被移走，
  // 所以不会有特殊操作

fn takes_ownership(some_string: String) { // some_string 进入作用域
  println!("{}", some_string);
} // 这里，some_string 移出作用域并调用 `drop` 方法。占用的内存被释放

fn makes_copy(some_integer: i32) { // some_integer 进入作用域
  println!("{}", some_integer);
} // 这里，some_integer 移出作用域。不会有特殊操作
```
当尝试在调用 `takes_ownership` 后使用 `s` 时，`Rust` 会抛出一个编译时错误。

### 1.7 返回值与作用域
返回值也可以转移所有权。
```rust
fn main() {
  let s1 = gives_ownership();         // gives_ownership 将返回值
                                      // 移给 s1

  let s2 = String::from("hello");     // s2 进入作用域

  let s3 = takes_and_gives_back(s2);  // s2 被移动到
                                      // takes_and_gives_back 中,
                                      // 它也将返回值移给 s3
} // 这里, s3 移出作用域并被丢弃。s2 也移出作用域，但已被移走，
  // 所以什么也不会发生。s1 移出作用域并被丢弃

fn gives_ownership() -> String {           // gives_ownership 将返回值移动给
                                           // 调用它的函数

  let some_string = String::from("yours"); // some_string 进入作用域

  some_string                              // 返回 some_string 并移出给调用的函数
}

// takes_and_gives_back 将传入字符串并返回该值
fn takes_and_gives_back(a_string: String) -> String { // a_string 进入作用域

  a_string  // 返回 a_string 并移出给调用的函数
}
```

变量的所有权总是遵循相同的模式：将值赋给另一个变量时 **<u>移动</u>** 它。当持有堆中数据值的变量离开作用域时，其值将通过 drop 被清理掉，除非数据被移动为另一个变量所有。

如果想要函数使用一个值但不获取所有权该怎么办呢（**引用** *references*）？

使用元组来返回多个值。
```rust
fn main() {
    let s1 = String::from("hello");

    let (s2, len) = calculate_length(s1);

    println!("The length of '{}' is {}.", s2, len);
}

fn calculate_length(s: String) -> (String, usize) {
    let length = s.len(); // len() 返回字符串的长度

    (s, length)
}
```

##  2.引用与借用
以一个对象的引用作为参数而不是获取值的所有权：
```rust
fn main() {
    let s1 = String::from("hello");

    let len = calculate_length(&s1);

    println!("The length of '{}' is {}.", s1, len);
}

fn calculate_length(s: &String) -> usize { // s 是对 String 的引用
  s.len()
} // 这里，s 离开了作用域。但因为它并不拥有引用值的所有权，
// 所以什么也不会发生
```
`&`符号是 **引用**，它允许你使用值但不获取其所有权。`&s1` 语法创建一个 指向值 `s1` 的引用，但是并不拥有它。因为并不拥有这个值，所以当引用停止使用时，它所指向的值也不会被 **<u>丢弃</u>**。

在`calculate_length`函数中变量 `s` 有效的作用域与函数参数的作用域一样，不过当引用停止使用时并不丢弃它指向的数据，因为没有所有权。当函数使用引用而不是实际值作为参数，无需返回值来交还所有权，因为就不曾拥有所有权。

{{< image "/images/docs/rust/grammar/String引用.svg" "&String s 指向 String s1 示意图" >}}

> 与使用 & 引用相反的操作是 **解引用** *dereferencing*，它使用解引用运算符`*`。

创建一个引用的行为称为 **借用**（*borrowing*）。尝试修改借用的变量（因为默认是不可变引用）是行不通的。

### 2.1 可变引用
```rust
fn main() {
    let mut s = String::from("hello");

    change(&mut s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```
可变引用有一个很大的限制：在同一时间，只能有 **一个** 对某一特定数据的可变引用，尝试创建两个可变引用的代码将会失败。

这个限制的好处是可以在编译时就避免数据竞争。数据竞争（*data race*）类似于竞态条件，它由这三个行为造成：
+ 两个或更多指针同时访问同一数据；
+ 至少有一个指针被用来写入数据；
+ 没有同步数据访问的机制。
> 📝 以上三个行为同时发生才会造成数据竞争，而不是单一行为。
```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &mut s; // first mutable borrow occurs here
    let r2 = &mut s; // cannot borrow `s` as mutable more than once at a time

    println!("{}, {}", r1, r2);
}
```
可以使用大括号来创建一个新的作用域，以允许拥有多个可变引用，只是不能 同时 拥有：
```rust
fn main() {
    let mut s = String::from("hello");

    {
        let r1 = &mut s;
    } // r1 在这里离开了作用域，所以完全可以创建一个新的引用

    let r2 = &mut s;
}
```

⚠️ 不可以同时使用可变引用和不可变引用
```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &s; // 没问题
    let r2 = &s; // 没问题
    let r3 = &mut s; // 大问题，cannot borrow `s` as mutable because it is also borrowed as immutable

    println!("{}, {}, and {}", r1, r2, r3);
}
```
⚠️ 一个引用的作用域从声明的地方开始一直持续到最后一次使用为止。
```rust
fn main() {
    let mut s = String::from("hello");

    let r1 = &s; // 没问题
    let r2 = &s; // 没问题
    println!("{} and {}", r1, r2);
    // 此位置之后 r1 和 r2 不再使用

    let r3 = &mut s; // 没问题
    println!("{}", r3);
}
```
### 2.2 垂悬引用 • Dangling References
```rust
fn main() {
  let reference_to_nothing = dangle();
}

fn dangle() -> &String { // dangle 返回一个字符串的引用

  let s = String::from("hello"); // s 是一个新字符串

  &s // 返回字符串 s 的引用
} // 这里 s 离开作用域并被丢弃。其内存被释放。
// 危险！
```
因为 s 是在 dangle 函数内创建的，当 dangle 的代码执行完毕后，s 将被释放。尝试返回它的引用，这意味着这个引用会指向一个无效的 String。

这里的解决方法是直接返回 String：
```rust
fn main() {
    let string = no_dangle();
}

fn no_dangle() -> String {
    let s = String::from("hello");

    s
}
```
> 所有权被移动出去，所以没有值被释放。

### 2.3 引用的规则
+ 在任意给定时间，要么 只能有一个可变引用，要么 只能有多个不可变引用；
+ 引用必须总是有效的。


## 3.切片 slice
除了实现`Copy trait`的类型、引用没有所有权，切片slice也没有所有权。slice 允许你引用集合中一段连续的元素序列，而不用引用整个集合。

### 3.1 字符串 slice
字符串 slice是`String`中一部分值的引用。
```rust
fn main() {
    let s = String::from("hello world");

    let hello = &s[0..5];
    let world = &s[6..11];
}
```

{{< image "/images/docs/rust/grammar/引用部分String的字符串slice.svg" "引用了部分 String 的字符串 slice" >}}

获取第一个单词
```rust
fn first_word(s: &String) -> &str {
  let bytes = s.as_bytes();

  for (i, &item) in bytes.iter().enumerate() {
    if item == b' ' { // 寻找第一个出现的空格
      return &s[0..i];
    }
  }

  &s[..]
}
```
**借用规则**：当拥有某值的不可变引用时，就不能再获取一个可变引用。因为 `clear` 需要清空 `String`，它尝试获取一个可变引用。
```rust
fn main() {
    let mut s = String::from("hello world");

    let word = first_word(&s); // immutable borrow occurs here

    s.clear(); // error! mutable borrow occurs here

    println!("the first word is: {}", word); // immutable borrow later used here
}
```

### 3.2 字符串字面量是 slice
正确理解字符串字面量。
```rust
fn main() {
    let s = "Hello, world!";
}
```
这里的 s 的类型是 `&str`，它是一个指向二进制程序特定位置的 `slice`。这也就是为什么字符串字面量是不可变的，因为 `&str` 是一个不可变引用。

### 3.3 字符串 slice 作为参数
修改函数`first_word`的签名，使得入参可以对 `String` 和 `&str` 都适用。
```rust
fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }

    &s[..]
}

fn main() {
    let my_string = String::from("hello world");

    // `first_word` 接受 `String` 的切片，无论是部分还是全部
    let word = first_word(&my_string[0..6]);
    let word = first_word(&my_string[..]);
    // `first_word` 也接受 `String` 的引用，
    // 这等同于 `String` 的全部切片
    let word = first_word(&my_string);

    let my_string_literal = "hello world";

    // `first_word` 接受字符串字面量的切片，无论是部分还是全部
    let word = first_word(&my_string_literal[0..6]);
    let word = first_word(&my_string_literal[..]);

    // 因为字符串字面值**就是**字符串 slice，
    // 这样写也可以，即不使用 slice 语法！
    let word = first_word(my_string_literal);
}
```

### 3.4 其它类型的 slice
```rust
fn main() {
    let a = [1, 2, 3, 4, 5];

    let slice = &a[1..3]; // slice 的类型是 &[i32]
}
```

---
title: 智能指针
date: 2024-04-23T16:40:00+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 12
---

智能指针（smart pointers）是一类数据结构，它们的表现类似指针，但是也拥有额外的元数据和功能。

**引用计数** （reference counting）智能指针类型，其允许数据有多个所有者。引用计数智能指针记录总共有多少个所有者，并当没有任何所有者时负责清理数据。

在 `Rust` 中，普通引用 和 智能指针 的一个额外的区别是引用是一类只借用数据的指针；相反，在大部分情况下，智能指针 拥有 它们指向的数据。

智能指针通常使用 **结构体** 实现。智能指针区别于常规结构体的显著特性在于其实现了 `Deref` 和 ` Drop trait`。`Deref trait` 允许智能指针结构体实例表现的像引用一样，这样就可以编写既用于引用、又用于智能指针的代码。Drop trait` 允许自定义当智能指针离开作用域时运行的代码。

常用的一些智能指针：

- `Box<T>`，用于在堆上分配值；
- `Rc<T>`，一个引用计数类型，其数据可以有多个所有者；
- `Ref<T>` 和 `RefMut<T>`，通过 `RefCell<T>` 访问（ `RefCell<T>` 是一个在运行时而不是在编译时执行借用规则的类型）；

还会涉及 **内部可变性**（interior mutability）模式，这是不可变类型暴露出改变其内部值的 API。也会涉及 **引用循环**（reference cycles）会如何泄漏内存，以及如何避免。

## 1.Box<T> 用于在堆上分配数据

`Box<T>` 是最简单直接的智能指针，它允许你在堆上存储数据而不是栈上。Box 没有性能损失，不过也没有很多额外的功能。

### 1.1 Box<T> 的使用场景

Box 最适用于如下场景：

1. **当有一个在编译时未知大小的类型**，而又想要在需要确切大小的上下文中使用这个类型值的时候
2. **当有大量数据并希望在确保数据不被拷贝的情况下转移所有权**的时候
3. **当希望拥有一个值并只关心它是否实现了特定 trait 而不是具体类型**的时候

### 1.2 基本使用

```rust
fn main() {
    let b = Box::new(5);
    println!("b = {}", b);
}
```

### 1.3 使用 Box<T> 赋能递归类型

在编译时，Rust 需要知道类型占用多少空间。一种无法在编译时知道大小的类型是**递归类型**（recursive type），其值的一部分可能是相同类型的另一个值。

#### 1.3.1 cons list 数据结构

**cons list** 是来源于 Lisp 编程语言及其方言的一种数据结构。在 cons list 中，每一项都包含两个元素：当前项的值和下一项。其最后一项值包含一个叫做 `Nil` 的值且没有下一项。

```rust
enum List {
    Cons(i32, List),
    Nil,
}

use crate::List::{Cons, Nil};

fn main() {
    let list = Cons(1, Cons(2, Cons(3, Nil)));
}
```

上述代码会导致编译错误，因为 Rust 无法计算出要为 `List` 值分配多少空间。

#### 1.3.2 使用 Box<T> 解决递归类型问题

```rust
enum List {
    Cons(i32, Box<List>),
    Nil,
}

use crate::List::{Cons, Nil};

fn main() {
    let list = Cons(1, Box::new(Cons(2, Box::new(Cons(3, Box::new(Nil))))));
}
```

`Cons` 成员将会需要一个 `i32` 的大小加上储存 box 指针数据的空间。`Nil` 成员不储存值，所以它比 `Cons` 成员需要更少的空间。现在我们知道了任何 `List` 值最多需要一个 `i32` 加上 box 指针数据的大小。

### 1.4 Box<T> 的内存布局

```rust
fn main() {
    let x = 5;                    // 在栈上
    let y = Box::new(x);          // x 被复制到堆上
    
    println!("x = {}", x);        // 仍然可以使用 x
    println!("y = {}", y);        // y 指向堆上的数据
}
```

当 `y` 离开作用域时，box 指针（栈上）和其指向的数据（堆上）都会被清理。

### 1.5 Box<T> 的性能特性

- **零成本抽象**：Box 本身没有运行时开销
- **移动语义**：Box 遵循 Rust 的所有权规则
- **自动内存管理**：当 Box 离开作用域时自动释放堆内存

```rust
fn main() {
    let large_data = Box::new([0; 1000000]); // 大数组在堆上分配
    let moved_data = large_data;             // 移动 Box，不复制数据
    // large_data 现在不能再使用
    println!("Data moved successfully");
}
```

## 2.通过 Deref trait 将智能指针当作常规引用处理

实现 `Deref` trait 允许我们重载**解引用运算符**（dereference operator）`*`。通过这种方式实现 `Deref` trait 的智能指针可以被当作常规引用来对待，可以编写操作引用的代码并用于智能指针。

### 2.1 通过解引用运算符追踪指针的值

常规引用是一种指针，而指针是一个包含内存地址的变量。这个地址指向存储在其他地方的数据。

```rust
fn main() {
    let x = 5;
    let y = &x;

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

### 2.2 像引用一样使用 Box<T>

可以使用 `Box<T>` 代替引用来重写上面的代码，解引用运算符也一样能工作：

```rust
fn main() {
    let x = 5;
    let y = Box::new(x);

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

### 2.3 自定义智能指针

为了更好地理解 `Box<T>` 如何工作，让我们定义自己的智能指针：

```rust
struct MyBox<T>(T);

impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}
```

### 2.4 通过实现 Deref trait 将某类型像引用一样处理

```rust
use std::ops::Deref;

struct MyBox<T>(T);

impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}

impl<T> Deref for MyBox<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

fn main() {
    let x = 5;
    let y = MyBox::new(x);

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

`type Target = T;` 语法定义了用于此 trait 的**关联类型**。`deref` 方法返回值的引用，这样调用者就能够通过 `*` 运算符访问值。

### 2.5 函数和方法的隐式解引用强制转换

**解引用强制转换**（deref coercion）是 Rust 在函数或方法传参上的一种便利操作。解引用强制转换将实现了 `Deref` trait 的类型的引用转换为另一种类型的引用。

```rust
use std::ops::Deref;

struct MyBox<T>(T);

impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}

impl<T> Deref for MyBox<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

fn hello(name: &str) {
    println!("Hello, {}!", name);
}

fn main() {
    let m = MyBox::new(String::from("Rust"));
    hello(&m);
}
```

这里我们使用 `&m` 调用 `hello` 函数，其为 `MyBox<String>` 值的引用。因为在 `MyBox<T>` 上实现了 `Deref` trait，Rust 可以通过 `deref` 调用将 `&MyBox<String>` 变为 `&String`。

### 2.6 解引用强制转换如何与可变性交互

类似于如何使用 `Deref` trait 重载不可变引用的 `*` 运算符，Rust 提供了 `DerefMut` trait 用于重载可变引用的 `*` 运算符。

Rust 在发现类型和 trait 实现满足三种情况时会进行解引用强制转换：

- 当 `T: Deref<Target=U>` 时从 `&T` 到 `&U`
- 当 `T: DerefMut<Target=U>` 时从 `&mut T` 到 `&mut U`
- 当 `T: Deref<Target=U>` 时从 `&mut T` 到 `&U`

第三个情况有些微妙：Rust 也会将可变引用强制转换为不可变引用。但是反之是**不可能**的：不可变引用永远也不能强制转换为可变引用。

## 3.通过 Drop Trait 运行清理代码

对于智能指针模式来说第二个重要的 trait 是 `Drop`，其允许我们在值要离开作用域时执行一些代码。可以为任何类型提供 `Drop` trait 的实现，同时所指定的代码被用于释放类似于文件或网络连接的资源。

### 3.1 Drop trait 的定义

`Drop` trait 要求实现一个叫做 `drop` 的方法，它获取一个 `self` 的可变引用：

```rust
struct CustomSmartPointer {
    data: String,
}

impl Drop for CustomSmartPointer {
    fn drop(&mut self) {
        println!("Dropping CustomSmartPointer with data `{}`!", self.data);
    }
}

fn main() {
    let c = CustomSmartPointer {
        data: String::from("my stuff"),
    };
    let d = CustomSmartPointer {
        data: String::from("other stuff"),
    };
    println!("CustomSmartPointers created.");
}
```

当程序离开作用域时，Rust 会自动调用 `drop`，变量以被创建时相反的顺序被丢弃。

### 3.2 通过 std::mem::drop 提早丢弃值

有时你可能需要提早清理某个值。一个例子是当使用智能指针管理锁时；你可能希望强制运行 `drop` 方法来释放锁以便作用域中的其他代码可以获取锁。

```rust
struct CustomSmartPointer {
    data: String,
}

impl Drop for CustomSmartPointer {
    fn drop(&mut self) {
        println!("Dropping CustomSmartPointer with data `{}`!", self.data);
    }
}

fn main() {
    let c = CustomSmartPointer {
        data: String::from("some data"),
    };
    println!("CustomSmartPointer created.");
    drop(c);
    println!("CustomSmartPointer dropped before the end of main.");
}
```

不能直接调用 `Drop` trait 的 `drop` 方法。相反需要调用标准库提供的 `std::mem::drop` 函数。

### 3.3 Drop trait 的自动调用

`Drop` trait 的功能是提供一种当值离开作用域时执行代码的方式。智能指针使用这个功能来进行重要的清理工作，比如释放堆内存或者递减引用计数。

```rust
use std::rc::Rc;

fn main() {
    let a = Rc::new(5);
    {
        let b = Rc::clone(&a);
        println!("Reference count after creating b: {}", Rc::strong_count(&a));
    } // b 在这里离开作用域，引用计数递减
    println!("Reference count after b goes out of scope: {}", Rc::strong_count(&a));
}
```

### 3.4 Drop 检查（Drop Check）

Rust 有一个称为 **drop check** 的机制来确保引用的生命周期足够长，这样 drop 函数就不会访问已经被销毁的数据：

```rust
struct Inspector<'a>(&'a u8);

impl<'a> Drop for Inspector<'a> {
    fn drop(&mut self) {
        println!("I was only {} days from retirement!", self.0);
    }
}

fn main() {
    let (inspector, days);
    days = Box::new(1);
    inspector = Inspector(&days);
    // `days` 不能在 `inspector` 之前被销毁
}
```

## 4.Rc<T> 引用计数智能指针

大部分情况下所有权是很明确的：可以准确地知道哪个变量拥有某个值。然而，有些情况单个值可能会有多个所有者。为了启用多所有权，Rust 有一个叫做 `Rc<T>` 的类型。

### 4.1 使用 Rc<T> 共享数据

`Rc<T>` 用于当我们希望在堆上分配一些内存供程序的多个部分读取，而且无法在编译时确定程序的哪一部分会最后结束使用它的时候。

**注意** `Rc<T>` 只能用于单线程场景。

```rust
enum List {
    Cons(i32, Rc<List>),
    Nil,
}

use crate::List::{Cons, Nil};
use std::rc::Rc;

fn main() {
    let a = Rc::new(Cons(5, Rc::new(Cons(10, Rc::new(Nil)))));
    let b = Cons(3, Rc::clone(&a));
    let c = Cons(4, Rc::clone(&a));
}
```

### 4.2 克隆 Rc<T> 会增加引用计数

每次调用 `Rc::clone`，`Rc<List>` 中数据的引用计数都会增加，直到有零个引用之前其数据都不会被清理。

```rust
enum List {
    Cons(i32, Rc<List>),
    Nil,
}

use crate::List::{Cons, Nil};
use std::rc::Rc;

fn main() {
    let a = Rc::new(Cons(5, Rc::new(Cons(10, Rc::new(Nil)))));
    println!("count after creating a = {}", Rc::strong_count(&a));
    let b = Cons(3, Rc::clone(&a));
    println!("count after creating b = {}", Rc::strong_count(&a));
    {
        let c = Cons(4, Rc::clone(&a));
        println!("count after creating c = {}", Rc::strong_count(&a));
    }
    println!("count after c goes out of scope = {}", Rc::strong_count(&a));
}
```

### 4.3 Rc<T> 的内部实现

`Rc<T>` 通过不可变引用使你可以在程序的多个部分之间只读地共享数据。如果 `Rc<T>` 也允许多个可变引用，则会违反借用规则之一：相同位置的多个可变借用可能造成数据竞争和不一致。

```rust
use std::rc::Rc;

fn main() {
    let data = Rc::new(vec![1, 2, 3]);
    let data1 = Rc::clone(&data);
    let data2 = Rc::clone(&data);
    
    // 所有的引用都是不可变的
    println!("data: {:?}", data);
    println!("data1: {:?}", data1);
    println!("data2: {:?}", data2);
    
    println!("Reference count: {}", Rc::strong_count(&data));
}
```

### 4.4 Rc<T> 的性能考虑

- **时间复杂度**：克隆 `Rc<T>` 只是增加引用计数，是 O(1) 操作
- **空间开销**：除了数据本身，还需要存储引用计数
- **线程安全**：`Rc<T>` 不是线程安全的，多线程环境需要使用 `Arc<T>`

```rust
use std::rc::Rc;
use std::time::Instant;

fn main() {
    let data = Rc::new(vec![0; 1000000]);
    
    let start = Instant::now();
    let _clones: Vec<_> = (0..1000)
        .map(|_| Rc::clone(&data))
        .collect();
    let duration = start.elapsed();
    
    println!("Cloning 1000 Rc<T> took: {:?}", duration);
    println!("Reference count: {}", Rc::strong_count(&data));
}
```

## 5.RefCell<T> 和内部可变性模式

**内部可变性**（Interior mutability）是 Rust 中的一个设计模式，它允许你即使在有不可变引用时也可以改变数据，这通常是借用规则所不允许的。为了改变数据，该模式在数据结构中使用 `unsafe` 代码来模糊 Rust 通常的可变性和借用规则。

### 5.1 通过 RefCell<T> 在运行时检查借用规则

不同于 `Rc<T>`，`RefCell<T>` 代表其数据的唯一所有权。对于引用和 `Box<T>`，借用规则的不变性作用于编译时。对于 `RefCell<T>`，这些不变性作用于**运行时**。

```rust
use std::cell::RefCell;

fn main() {
    let data = RefCell::new(5);
    
    let borrowed_data = data.borrow();
    println!("data: {}", borrowed_data);
    // borrowed_data 在这里离开作用域
    
    let mut mutable_borrow = data.borrow_mut();
    *mutable_borrow += 1;
    println!("modified data: {}", mutable_borrow);
}
```

### 5.2 内部可变性：不可变值的可变借用

内部可变性的一个用例是当你确信代码遵循借用规则，但编译器不能理解和确定的时候。

```rust
pub trait Messenger {
    fn send(&self, msg: &str);
}

pub struct LimitTracker<'a, T: Messenger> {
    messenger: &'a T,
    value: usize,
    max: usize,
}

impl<'a, T> LimitTracker<'a, T>
where
    T: Messenger,
{
    pub fn new(messenger: &T, max: usize) -> LimitTracker<T> {
        LimitTracker {
            messenger,
            value: 0,
            max,
        }
    }

    pub fn set_value(&mut self, value: usize) {
        self.value = value;

        let percentage_of_max = self.value as f64 / self.max as f64;

        if percentage_of_max >= 1.0 {
            self.messenger.send("Error: You are over your quota!");
        } else if percentage_of_max >= 0.9 {
            self.messenger
                .send("Urgent warning: You've used up over 90% of your quota!");
        } else if percentage_of_max >= 0.75 {
            self.messenger
                .send("Warning: You've used up over 75% of your quota!");
        }
    }
}
```

### 5.3 使用 RefCell<T> 实现内部可变性

```rust
use std::cell::RefCell;

pub trait Messenger {
    fn send(&self, msg: &str);
}

struct MockMessenger {
    sent_messages: RefCell<Vec<String>>,
}

impl MockMessenger {
    fn new() -> MockMessenger {
        MockMessenger {
            sent_messages: RefCell::new(vec![]),
        }
    }
}

impl Messenger for MockMessenger {
    fn send(&self, message: &str) {
        self.sent_messages.borrow_mut().push(String::from(message));
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_sends_an_over_75_percent_warning_message() {
        let mock_messenger = MockMessenger::new();
        let mut limit_tracker = LimitTracker::new(&mock_messenger, 100);

        limit_tracker.set_value(80);

        assert_eq!(mock_messenger.sent_messages.borrow().len(), 1);
    }
}
```

### 5.4 结合 Rc<T> 和 RefCell<T> 来拥有多个可变数据所有者

`Rc<T>` 允许相同数据有多个所有者；`RefCell<T>` 提供内部可变性。结合它们，就可以有一个有多个所有者且可以修改的值。

```rust
use std::cell::RefCell;
use std::rc::Rc;

#[derive(Debug)]
enum List {
    Cons(Rc<RefCell<i32>>, Rc<List>),
    Nil,
}

use crate::List::{Cons, Nil};

fn main() {
    let value = Rc::new(RefCell::new(5));

    let a = Rc::new(Cons(Rc::clone(&value), Rc::new(Nil)));

    let b = Cons(Rc::new(RefCell::new(3)), Rc::clone(&a));
    let c = Cons(Rc::new(RefCell::new(4)), Rc::clone(&a));

    *value.borrow_mut() += 10;

    println!("a after = {:?}", a);
    println!("b after = {:?}", b);
    println!("c after = {:?}", c);
}
```

### 5.5 RefCell<T> 的运行时成本

`RefCell<T>` 的运行时借用检查意味着存在一定的性能开销：

```rust
use std::cell::RefCell;
use std::time::Instant;

fn main() {
    let data = RefCell::new(0);
    
    let start = Instant::now();
    for i in 0..1000000 {
        *data.borrow_mut() = i;
    }
    let duration = start.elapsed();
    
    println!("RefCell operations took: {:?}", duration);
}
```

### 5.6 运行时借用规则违反

如果违反借用规则，`RefCell<T>` 会在运行时 panic：

```rust
use std::cell::RefCell;

fn main() {
    let data = RefCell::new(5);
    
    let _borrow1 = data.borrow_mut();
    let _borrow2 = data.borrow_mut(); // 这会 panic！
}
```

## 6.引用循环与内存泄漏

Rust 的内存安全性保证使其难以意外地制造永远也不会被清理的内存（被称为**内存泄漏**，memory leak），但并不是不可能。与在编译时拒绝数据竞争不同，Rust 并不保证完全地避免内存泄漏，这意味着内存泄漏在 Rust 被认为是内存安全的。

### 6.1 制造引用循环

```rust
use crate::List::{Cons, Nil};
use std::cell::RefCell;
use std::rc::Rc;

#[derive(Debug)]
enum List {
    Cons(i32, RefCell<Rc<List>>),
    Nil,
}

impl List {
    fn tail(&self) -> Option<&RefCell<Rc<List>>> {
        match self {
            Cons(_, item) => Some(item),
            Nil => None,
        }
    }
}

fn main() {
    let a = Rc::new(Cons(5, RefCell::new(Rc::new(Nil))));

    println!("a initial rc count = {}", Rc::strong_count(&a));
    println!("a next item = {:?}", a.tail());

    let b = Rc::new(Cons(10, RefCell::new(Rc::clone(&a))));

    println!("a rc count after b creation = {}", Rc::strong_count(&a));
    println!("b initial rc count = {}", Rc::strong_count(&b));
    println!("b next item = {:?}", b.tail());

    if let Some(link) = a.tail() {
        *link.borrow_mut() = Rc::clone(&b);
    }

    println!("b rc count after changing a = {}", Rc::strong_count(&b));
    println!("a rc count after changing a = {}", Rc::strong_count(&a));

    // 下面这行会导致栈溢出
    // println!("a next item = {:?}", a.tail());
}
```

### 6.2 避免引用循环：将 Rc<T> 变为 Weak<T>

到目前为止，我们已经展示了调用 `Rc::clone` 会增加 `Rc<T>` 实例的 `strong_count`，和只在其 `strong_count` 为 0 时才会被清理的 `Rc<T>` 实例。你也可以通过调用 `Rc::downgrade` 并传递 `Rc<T>` 实例的引用来创建其值的**弱引用**（weak reference）。

```rust
use std::cell::RefCell;
use std::rc::{Rc, Weak};

#[derive(Debug)]
struct Node {
    value: i32,
    parent: RefCell<Weak<Node>>,
    children: RefCell<Vec<Rc<Node>>>,
}

fn main() {
    let leaf = Rc::new(Node {
        value: 3,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![]),
    });

    println!("leaf parent = {:?}", leaf.parent.borrow().upgrade());

    let branch = Rc::new(Node {
        value: 5,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![Rc::clone(&leaf)]),
    });

    *leaf.parent.borrow_mut() = Rc::downgrade(&branch);

    println!("leaf parent = {:?}", leaf.parent.borrow().upgrade());
}
```

### 6.3 可视化 strong_count 和 weak_count 的改变

```rust
use std::cell::RefCell;
use std::rc::{Rc, Weak};

#[derive(Debug)]
struct Node {
    value: i32,
    parent: RefCell<Weak<Node>>,
    children: RefCell<Vec<Rc<Node>>>,
}

fn main() {
    let leaf = Rc::new(Node {
        value: 3,
        parent: RefCell::new(Weak::new()),
        children: RefCell::new(vec![]),
    });

    println!(
        "leaf strong = {}, weak = {}",
        Rc::strong_count(&leaf),
        Rc::weak_count(&leaf),
    );

    {
        let branch = Rc::new(Node {
            value: 5,
            parent: RefCell::new(Weak::new()),
            children: RefCell::new(vec![Rc::clone(&leaf)]),
        });

        *leaf.parent.borrow_mut() = Rc::downgrade(&branch);

        println!(
            "branch strong = {}, weak = {}",
            Rc::strong_count(&branch),
            Rc::weak_count(&branch),
        );

        println!(
            "leaf strong = {}, weak = {}",
            Rc::strong_count(&leaf),
            Rc::weak_count(&leaf),
        );
    }

    println!("leaf parent = {:?}", leaf.parent.borrow().upgrade());
    println!(
        "leaf strong = {}, weak = {}",
        Rc::strong_count(&leaf),
        Rc::weak_count(&leaf),
    );
}
```

### 6.4 Weak<T> 的实际应用

`Weak<T>` 在以下场景中特别有用：

1. **父子关系**：子节点应该知道其父节点，但父节点不应该拥有其子节点
2. **观察者模式**：观察者不应该影响被观察对象的生命周期
3. **缓存**：缓存项不应该阻止其引用对象的清理

```rust
use std::cell::RefCell;
use std::rc::{Rc, Weak};

struct Observer {
    id: usize,
}

struct Subject {
    observers: RefCell<Vec<Weak<Observer>>>,
}

impl Subject {
    fn new() -> Self {
        Subject {
            observers: RefCell::new(Vec::new()),
        }
    }

    fn add_observer(&self, observer: &Rc<Observer>) {
        self.observers.borrow_mut().push(Rc::downgrade(observer));
    }

    fn notify(&self) {
        let mut observers = self.observers.borrow_mut();
        observers.retain(|weak_ref| {
            if let Some(observer) = weak_ref.upgrade() {
                println!("Notifying observer {}", observer.id);
                true
            } else {
                false // 移除已经被清理的观察者
            }
        });
    }
}

fn main() {
    let subject = Subject::new();
    
    {
        let observer1 = Rc::new(Observer { id: 1 });
        let observer2 = Rc::new(Observer { id: 2 });
        
        subject.add_observer(&observer1);
        subject.add_observer(&observer2);
        
        subject.notify(); // 通知两个观察者
    } // observer1 和 observer2 在这里被清理
    
    subject.notify(); // 不会通知任何观察者，因为它们已被清理
}
```

## 7.智能指针选择指南和最佳实践

### 7.1 智能指针选择矩阵

| 需求场景 | 推荐智能指针 | 原因 |
|---------|-------------|------|
| 堆上分配大型数据 | `Box<T>` | 简单高效，避免栈溢出 |
| 递归数据结构 | `Box<T>` | 编译时已知大小 |
| 多个只读所有者 | `Rc<T>` | 引用计数，自动清理 |
| 需要内部可变性 | `RefCell<T>` | 运行时借用检查 |
| 多所有者+可变性 | `Rc<RefCell<T>>` | 结合两者优势 |
| 避免循环引用 | `Weak<T>` | 不影响引用计数 |
| 多线程共享 | `Arc<T>` | 原子引用计数 |
| 多线程+可变性 | `Arc<Mutex<T>>` | 线程安全的可变性 |

### 7.2 性能考虑和基准测试

```rust
use std::cell::RefCell;
use std::rc::Rc;
use std::time::Instant;

fn benchmark_smart_pointers() {
    const N: usize = 1_000_000;
    
    // Box<T> 基准测试
    let start = Instant::now();
    let mut boxes = Vec::new();
    for i in 0..N {
        boxes.push(Box::new(i));
    }
    println!("Box<T> creation: {:?}", start.elapsed());
    
    // Rc<T> 基准测试
    let start = Instant::now();
    let data = Rc::new(42);
    let mut clones = Vec::new();
    for _ in 0..N {
        clones.push(Rc::clone(&data));
    }
    println!("Rc<T> cloning: {:?}", start.elapsed());
    
    // RefCell<T> 基准测试
    let start = Instant::now();
    let cell = RefCell::new(0);
    for i in 0..N {
        *cell.borrow_mut() = i;
    }
    println!("RefCell<T> mutations: {:?}", start.elapsed());
}

fn main() {
    benchmark_smart_pointers();
}
```

### 7.3 常见陷阱和避免方法

#### 7.3.1 引用循环检测工具

```rust
use std::cell::RefCell;
use std::rc::{Rc, Weak};

#[derive(Debug)]
struct Node {
    value: i32,
    children: RefCell<Vec<Rc<Node>>>,
    parent: RefCell<Weak<Node>>,
}

impl Node {
    fn new(value: i32) -> Rc<Self> {
        Rc::new(Node {
            value,
            children: RefCell::new(Vec::new()),
            parent: RefCell::new(Weak::new()),
        })
    }
    
    fn add_child(parent: &Rc<Node>, child: Rc<Node>) {
        *child.parent.borrow_mut() = Rc::downgrade(parent);
        parent.children.borrow_mut().push(child);
    }
    
    // 检测是否存在循环引用的辅助函数
    fn check_cycles(&self, visited: &mut std::collections::HashSet<*const Node>) -> bool {
        let self_ptr = self as *const Node;
        if visited.contains(&self_ptr) {
            return true; // 发现循环
        }
        visited.insert(self_ptr);
        
        for child in self.children.borrow().iter() {
            if child.check_cycles(visited) {
                return true;
            }
        }
        
        visited.remove(&self_ptr);
        false
    }
}
```

#### 7.3.2 内存泄漏检测

```rust
use std::sync::atomic::{AtomicUsize, Ordering};

static ALLOCATION_COUNT: AtomicUsize = AtomicUsize::new(0);

struct TrackedBox<T> {
    data: Box<T>,
}

impl<T> TrackedBox<T> {
    fn new(data: T) -> Self {
        ALLOCATION_COUNT.fetch_add(1, Ordering::Relaxed);
        TrackedBox {
            data: Box::new(data),
        }
    }
}

impl<T> Drop for TrackedBox<T> {
    fn drop(&mut self) {
        ALLOCATION_COUNT.fetch_sub(1, Ordering::Relaxed);
    }
}

fn main() {
    {
        let _box1 = TrackedBox::new(42);
        let _box2 = TrackedBox::new(84);
        println!("Active allocations: {}", ALLOCATION_COUNT.load(Ordering::Relaxed));
    }
    
    println!("Active allocations after scope: {}", ALLOCATION_COUNT.load(Ordering::Relaxed));
}
```

### 7.4 实际项目中的使用模式

#### 7.4.1 树形数据结构的标准实现

```rust
use std::cell::RefCell;
use std::rc::{Rc, Weak};

type TreeNodeRef<T> = Rc<RefCell<TreeNode<T>>>;
type WeakTreeNodeRef<T> = Weak<RefCell<TreeNode<T>>>;

#[derive(Debug)]
pub struct TreeNode<T> {
    pub value: T,
    pub children: Vec<TreeNodeRef<T>>,
    pub parent: Option<WeakTreeNodeRef<T>>,
}

impl<T> TreeNode<T> {
    pub fn new(value: T) -> TreeNodeRef<T> {
        Rc::new(RefCell::new(TreeNode {
            value,
            children: Vec::new(),
            parent: None,
        }))
    }
    
    pub fn add_child(parent: &TreeNodeRef<T>, child: TreeNodeRef<T>) {
        child.borrow_mut().parent = Some(Rc::downgrade(parent));
        parent.borrow_mut().children.push(child);
    }
    
    pub fn remove_from_parent(node: &TreeNodeRef<T>) {
        if let Some(parent_weak) = &node.borrow().parent {
            if let Some(parent) = parent_weak.upgrade() {
                parent.borrow_mut().children.retain(|child| {
                    !Rc::ptr_eq(child, node)
                });
                node.borrow_mut().parent = None;
            }
        }
    }
}
```

#### 7.4.2 事件系统的实现

```rust
use std::cell::RefCell;
use std::collections::HashMap;
use std::rc::{Rc, Weak};

pub trait EventHandler<T> {
    fn handle(&self, event: &T);
}

pub struct EventSystem<T> {
    handlers: RefCell<HashMap<String, Vec<Weak<dyn EventHandler<T>>>>>,
}

impl<T> EventSystem<T> {
    pub fn new() -> Self {
        EventSystem {
            handlers: RefCell::new(HashMap::new()),
        }
    }
    
    pub fn subscribe<H>(&self, event_type: String, handler: &Rc<H>)
    where
        H: EventHandler<T> + 'static,
    {
        let mut handlers = self.handlers.borrow_mut();
        let handler_list = handlers.entry(event_type).or_insert_with(Vec::new);
        handler_list.push(Rc::downgrade(handler) as Weak<dyn EventHandler<T>>);
    }
    
    pub fn emit(&self, event_type: &str, event: &T) {
        let mut handlers = self.handlers.borrow_mut();
        if let Some(handler_list) = handlers.get_mut(event_type) {
            handler_list.retain(|weak_handler| {
                if let Some(handler) = weak_handler.upgrade() {
                    handler.handle(event);
                    true
                } else {
                    false // 移除已经被清理的处理器
                }
            });
        }
    }
}
```

### 7.5 最佳实践总结

1. **优先使用 `Box<T>`**：对于简单的堆分配需求
2. **谨慎使用 `Rc<T>`**：只在确实需要多所有权时使用
3. **避免 `RefCell<T>` 滥用**：运行时检查有性能开销
4. **及时使用 `Weak<T>`**：在可能出现循环引用的场景中
5. **性能测试**：在性能敏感的场景中进行基准测试
6. **内存监控**：在长期运行的程序中监控内存使用情况
7. **文档化选择**：在代码中说明选择特定智能指针的原因

通过合理选择和使用智能指针，可以在保证内存安全的同时，实现灵活高效的数据管理。

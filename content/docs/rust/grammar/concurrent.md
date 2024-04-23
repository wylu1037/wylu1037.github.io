---
title: 并发
date: 2024-04-12T13:34:34+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 10
---

- 如何创建线程来同时运行多段代码。
- **消息传递**（Message passing）并发，其中**通道**（channel）被用来在线程间传递消息。
- **共享状态**（Shared state）并发，其中多个线程可以访问同一片数据。
- `Sync` 和 `Send trait`，将 Rust 的并发保证扩展到用户定义的以及标准库提供的类型中。

## 1.使用线程

### 1.1 使用 spawn 创建新线程

为了创建一个新线程，需要调用 `thread::spawn` 函数并传递一个闭包，并在其中包含希望在新线程运行的代码。

```rust {filename="src/main.rs"}
use std::thread;
use std::time::Duration;

fn main() {
    thread::spawn(|| {
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("hi number {} from the main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }
}
```

### 1.2 使用 join 等待所有线程结束

可以通过将 `thread::spawn` 的返回值储存在变量中来修复新建线程部分没有执行或者完全没有执行的问题。`thread::spawn` 的返回值类型是 `JoinHandle`。`JoinHandle` 是一个拥有所有权的值，当对其调用 jo`in 方法时，它会等待其线程结束。

```rust {filename="src/main.rs"}
use std::thread;
use std::time::Duration;

fn main() {
    let handle = thread::spawn(|| {
        for i in 1..10 {
            println!("hi number {} from the spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("hi number {} from the main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }

    handle.join().unwrap();
}
```

### 1.3 线程与 move 闭包

`move` 闭包经常与 `thread::spawn` 一起使用，因为它允许我们在一个线程中使用另一个线程的数据。可以在参数列表前使用 `move` 关键字强制闭包获取其使用的环境值的所有权，示例如下：

```rust
fn main() {
    let my_string = "Hello".to_string();
    let my_vec = vec![1, 2, 3];

    // 使用 move 关键字，闭包获得 my_string 和 my_vec 的所有权
    let consume = move || {
        println!("String: {}", my_string); // 这里使用了 my_string
        println!("Vector: {:?}", my_vec); // 这里使用了 my_vec
    };

    // 调用闭包
    consume();

    // 下面的代码将会报错，因为 my_string 和 my_vec 的所有权已经被闭包获得
    // println!("String: {}", my_string); // 错误：value borrowed here after move
    // println!("Vector: {:?}", my_vec); // 错误：value borrowed here after move
}
```

使用 `move` 关键字强制获取它使用的值的所有权。

```rust {filename="src/main.rs"}
use std::thread;

fn main() {
    let v = vec![1, 2, 3];

    let handle = thread::spawn(move || {
        println!("Here's a vector: {:?}", v);
    });

    handle.join().unwrap();
}
```

## 2.线程间的消息传递

`Rust` 中一个实现消息传递并发的主要工具是 通道 <sub>**_channel_**</sub>

```rust
use std::thread;
use std::sync::mpsc;

fn main() {
    // 创建一个通道，并将其两端赋值给 tx 和 rx
    let (tx, rx) = mpsc::channel();

    // 将 tx 移动到一个新建的线程中并发送 “hi”
    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
    });

    // 在主线程中接收并打印内容 “hi”
    let received = rx.recv().unwrap();
    println!("Got: {}", received);
}

```

这里使用 `mpsc::channel` 函数创建一个新的通道；`mpsc` 是 多个生产者，单个消费者<sub> **multiple producer, single consumer** </sub>的缩写。简而言之，`Rust` 标准库实现通道的方式意味着一个通道可以有多个产生值的 发送<sub> **sending** </sub>端，但只能有一个消费这些值的 接收<sub> **receiving** </sub>端。

通道的接收端有两个有用的方法：`recv` 和 `try_recv`。

`recv` 会阻塞主线程执行直到从通道中接收一个值。一旦发送了一个值，`recv` 会在一个 `Result<T, E>` 中返回它。当通道发送端关闭，`recv` 会返回一个错误表明不会再有新的值到来了。

`try_recv` 不会阻塞，相反它立刻返回一个 `Result<T, E>`：Ok 值包含可用的信息，而 `Err` 值代表此时没有任何消息。如果线程在等待消息过程中还有其他工作时使用 `try_recv` 很有用：可以编写一个循环来频繁调用 `try_recv`，在有可用消息时进行处理，其余时候则处理一会其他工作直到再次检查。

### 2.1 通道与所有权转移

```rust {hl_lines=[11]}
use std::thread;
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
        // use of moved value: `val`
        println!("val is {}", val);
    });

    let received = rx.recv().unwrap();
    println!("Got: {}", received);
}
```

高亮代码部分的报错：use of moved value: `val`。一旦将值发送到另一个线程后，那个线程可能会在我们再次使用它之前就将其修改或者丢弃。其他线程对值可能的修改会由于不一致或不存在的数据而导致错误或意外的结果。

### 2.2 发送多个值

```rust
use std::thread;
use std::sync::mpsc;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        let vals = vec![
            String::from("hi"),
            String::from("from"),
            String::from("the"),
            String::from("thread"),
        ];

        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    for received in rx {
        println!("Got: {}", received);
    }
}
```

输出：

```
Got: hi
Got: from
Got: the
Got: thread
```

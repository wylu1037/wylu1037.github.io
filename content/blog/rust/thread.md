---
title: 线程
date: 2024-06-02T21:14:26+08:00
---

## std::thread::spawn

`std::thread::spawn` 创建一个操作系统级的线程，这些线程在操作系统层面进行调度。它适用于 **CPU** 密集型任务或者需要与外部库进行 **同步操作** 的任务。

**示例代码**
```rust
use std::thread;

fn main() {
    let handle = thread::spawn(|| {
        // 在新的线程中执行
        for i in 1..10 {
            println!("在新线程中：{}", i);
            std::thread::sleep(std::time::Duration::from_millis(1));
        }
    });

    // 在主线程中执行
    for i in 1..5 {
        println!("在主线程中：{}", i);
        std::thread::sleep(std::time::Duration::from_millis(1));
    }

    handle.join().unwrap();
}
```

{{< callout >}}
spawn 接收一个闭包参数。

{{< /callout >}}

## tokio::spawn
`tokio::spawn` 创建一个异步任务，这些任务在 Tokio 运行时中进行调度。它适用于 **I/O** 密集型任务或者需要与其他 **异步操作** 进行协作的任务。

**示例代码**
```rust
use tokio::time::{sleep, Duration};

#[tokio::main]
async fn main() {
    let handle = tokio::spawn(async {
        // 在新的异步任务中执行
        for i in 1..10 {
            println!("在新异步任务中：{}", i);
            sleep(Duration::from_millis(1)).await;
        }
    });

    // 在主异步任务中执行
    for i in 1..5 {
        println!("在主异步任务中：{}", i);
        sleep(Duration::from_millis(1)).await;
    }

    handle.await.unwrap();
}
```

### async & await
`async` 和 `await` 是用于编写异步代码的关键字，它们与 Tokio 一起使用。

可以使用 `async` 关键字定义一个异步函数。异步函数在调用时不会立即执行，而是返回一个实现了 `Future` 特性的对象。这个 `Future` 可以被 `.await` 调用，以等待它的完成。

```rust
async fn say_hello() {
    println!("Hello, world!");
}
```

`await` 关键字用于等待异步操作完成。当一个 `Future` 被 `.await` 调用时，当前任务将被挂起，直到 `Future` 完成。这使得程序可以在等待期间执行其他任务，从而实现高效的并发。

```rust
async fn main() {
    say_hello().await;
}
```

### Future

`join!` 宏用于并行执行多个异步任务并等待它们完成。

```rust
use tokio::time::{sleep, Duration};

async fn task1() {
    sleep(Duration::from_secs(2)).await;
    println!("Task 1 completed");
}

async fn task2() {
    sleep(Duration::from_secs(3)).await;
    println!("Task 2 completed");
}

#[tokio::main]
async fn main() {
    tokio::join!(task1(), task2());
    println!("Both tasks completed");
}
```

## 🤖 面试
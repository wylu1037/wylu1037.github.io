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

## 🤖 面试
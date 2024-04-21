---
title: 互斥锁
date: 2024-03-15T08:06:31+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

```go
type Mutex struct {
	state int32
	sema  uint32
}
```

state
8 个字节
第 1 个：mutexLocked

CAS
sema 信号量

等待队列
正常模式
饥饿模式

## 信号量

自旋锁获取失败后将当前线程挂起（调度器对象，操作系统提供的线程间同步原语），同步原语是由内核提供的，直接与系统调度器交互，能够挂起和唤醒**线程**。但是会发生系统调用

那么 golang 中协程要等待一个锁时，如何休眠、等待和唤醒呢？

semaphore

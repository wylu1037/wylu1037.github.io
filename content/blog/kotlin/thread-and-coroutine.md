---
title: 线程与协程
date: 2024-09-12T20:23:30+08:00
---

## 1.线程
> 使用 `lambda` 创建线程。
```kotlin
fun main() {
    val thread = Thread {
        println("Hello from thread!")
    }
    thread.start()
    println("Hello from main thread!")
}
```

## 2.协程
<br/>
{{< font "blue" "引入依赖">}}

```groovy
implementation "org.jetbrains.kotlinx:kotlinx-coroutines-core"
```

### 2.1 suspend
`suspend` 是 **_Kotlin_** 中用于定义挂起函数（`suspend functions`）的关键字。挂起函数是可以被挂起和恢复的函数，它们只能在协程或另一个挂起函数中调用。

**特点**：
+ **非阻塞的异步执行**：挂起函数可以在协程中暂停其执行，并在需要时恢复执行，而不阻塞当前线程。这使得异步编程更加简单和直观。
+ **只能在协程或挂起函数中调用**：挂起函数不能直接在普通函数中调用，必须在协程上下文中调用。

**示例**：
```kotlin
import kotlinx.coroutines.*

suspend fun performTask() {
    delay(1000L)  // 挂起1秒
    println("Task completed")
}

fun main() = runBlocking {
    println("Starting task...")
    performTask()  // 调用挂起函数
    println("Task finished")
}
```
> `performTask` 是一个挂起函数，通过 `delay` 模拟了异步任务的执行。它不会阻塞线程，而是挂起并在 1 秒后恢复执行。

### 2.2 runBlocking

`runBlocking` 是一种用于启动协程并阻塞当前线程的函数。它通常用于非协程环境中（如主函数或测试代码）来启动协程，并等待其完成后再继续执行后续代码。

**特点**：
+ **阻塞当前线程**：runBlocking 会阻塞当前线程，直到它内部的协程执行完成。这与协程的轻量异步并发处理理念有所不同。
+ **常用于主线程或测试环境**：在需要从非协程代码（如 `main` 函数）中调用协程时，使用 `runBlocking` 来启动协程并等待其完成。

**示例**：
```kotlin
import kotlinx.coroutines.*

fun main() = runBlocking {
    // 启动协程
    launch {
        delay(1000L)
        println("Coroutine finished")
    }
    println("Main function continues...")
}
```

> `runBlocking` 会阻塞主线程，直到内部的协程完成。在上面代码中，虽然主线程被阻塞了，但协程会异步运行。

### 2.3 async and await

- **作用**: async 是一个协程构建器，它可以用于启动一个新的协程，而不会阻塞当前线程，并返回一个 Deferred 对象，这个对象代表了协程的最终结果。你可以在需要结果的时候调用 Deferred 的 await 方法，这将会暂停当前协程直到 async 协程完成，并返回结果。
- **应用场景**: 当你有多个并行运行的任务，并且想要在它们都完成后获取结果时，可以使用 async 和 await。

```kotlin
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.awaitAll

fun main() = runBlocking {
    val deferredResult1 = async { // 在后台启动一个新的协程并继续
        delay(1000L) // 模拟一个长时间的运算
        "Result1" // 返回结果
    }
    val deferredResult2 = async {
        delay(2000L) // 另一个长时间的运算
        "Result2" // 返回结果
    }
    // 等待所有的协程完成，并获取结果
    val results = awaitAll(deferredResult1, deferredResult2)
    println("Got results: $results")
}
```


### 2.4 withContext

- 作用: withContext 函数可以切换协程的执行上下文（比如从主线程切换到 IO 线程），并在新的上下文中执行一个代码块，完成后返回结果。withContext 在内部会暂停当前协程，直到代码块执行完成。
- 应用场景: 当你需要执行一个耗时操作，并希望在操作完成后继续执行当前协程的其他部分时，可以使用 withContext。

```kotlin
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext
import kotlinx.coroutines.Dispatchers

fun main() = runBlocking {
    val result = withContext(Dispatchers.IO) { // 切换到IO线程执行
        // 执行一些IO操作
        "Result from IO"
    }
    println(result)
}
```

### 2.5 join
- 作用: 当你启动了一个或多个协程，并想等待它们全部完成时，可以调用每个协程的 Job 对象的 join 方法。join 会暂停当前协程直到对应的协程执行完毕。
- 应用场景: 当你启动多个任务协程，并希望在它们全部执行完毕后继续执行当前协程的其他部分时，可以使用 join。

```kotlin
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

fun main() = runBlocking {
    val job1 = launch {
        delay(1000L)
        println("Task 1 completed")
    }
    val job2 = launch {
        delay(2000L)
        println("Task 2 completed")
    }
    // 等待任务完成
    job1.join()
    job2.join()
    println("All tasks completed.")
}
```

### 2.6 coroutineScope

- 作用: coroutineScope 是一个挂起函数，它会创建一个新的协程作用域，并在所有在这个作用域中启动的协程完成之前挂起当前协程。coroutineScope 只有当所有协程执行完毕后才返回。
- 应用场景: 当你需要确保所有启动的协程都完成后才继续执行时，可以使用 coroutineScope。

```kotlin
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

fun main() = runBlocking {
    coroutineScope { // 创建一个协程作用域
        launch {
            delay(1000L)
            println("Task 1 completed")
        }
        launch {
            delay(2000L)
            println("Task 2 completed")
        }
    }
    // 在所有任务完成后执行
    println("All tasks completed in scope.")
}
```

### 2.7 select

+ **作用**: select 表达式可以在多个协程操作中选择第一个完成的操作并执行。这可以用于实现复杂的并发等待逻辑，比如超时机制。
+ **应用场景**: 当你需要从多个并发操作中选择一个最先完成的结果进行处理时，可以使用 select。

```kotlin
import kotlinx.coroutines.*
import kotlinx.coroutines.selects.select

suspend fun task1(): String {
    delay(1000L) // 模拟耗时任务
    return "Result1"
}

suspend fun task2(): String {
    delay(200L) // 模拟较短耗时任务
    return "Result2"
}

fun main() = runBlocking {
    val result = select<String> { // 选择第一个完成的协程
        async { task1() }.onAwait { it }
        async { task2() }.onAwait { it }
    }
    println("First result is '$result'")
}
```

### 2.8 launch
在 Kotlin 中，launch 是协程构建器，用于启动一个新的协程。它是 Kotlin 协程库的一部分，通常用于异步编程。以下是一些关键点：

#### 特点
+ **不会阻塞线程**: launch 启动的协程可以异步执行，不会阻塞启动协程的线程。
+ **返回值**: 返回一个 Job 对象，该对象可以用于管理协程的生命周期（如取消协程）。
+ **适用场景**: 适合用于启动不需要返回结果的后台任务。

#### 使用示例

```kotlin
import kotlinx.coroutines.*

fun main() = runBlocking {
    val job = launch {
        // 在这里运行一些异步代码
        delay(1000L)
        println("协程完成")
    }

    println("等待协程完成")
    job.join()  // 等待协程完成
    println("完成")
}
```

#### 关键点
+ **上下文**: launch 可以指定协程上下文和调度器（如 Dispatchers.IO、Dispatchers.Main）。
+ **取消**: 可以通过调用 job.cancel() 来取消协程。
+ **异常处理**: 可以在 launch 块中使用 try-catch 处理异常，或者为 Job 添加异常处理器。

#### 调度器示例
```kotlin
launch(Dispatchers.IO) {
    // 在IO线程池中执行
}

launch(Dispatchers.Main) {
    // 在主线程中执行（通常在Android中使用）
}
```
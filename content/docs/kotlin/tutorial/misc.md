---
title: Misc
date: 2024-03-14T15:03:09+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## 伴生对象

在 Kotlin 中，伴生对象（Companion Object）是一种特殊的对象声明，其目的是在没有类实例的情况下访问类的成员，类似于 Java 中的静态成员。每个类可以声明一个伴生对象，这个对象被视为类的一个静态成员。通过伴生对象，你可以访问类的静态属性和方法，而不需要创建类的实例。

### 伴生对象的特点

- 静态成员：伴生对象中声明的属性和方法可以通过类名直接访问，无需类实例。
- 初始化：伴生对象的初始化发生在类被加载时，这与静态初始化块相似。
- 单例：每个类只能有一个伴生对象，它在类内部被声明，并且伴生对象本身也遵循单例模式。
- 实例化：虽然伴生对象的成员看起来像静态成员，但实际上伴生对象是一个真正的对象实例，它支持实现接口和继承其他类。

### 使用伴生对象的示例

```kotlin
class MyClass {
    companion object Factory {
        fun create(): MyClass = MyClass()
    }
}

fun main() {
    val instance = MyClass.create()  // 通过伴生对象访问创建类实例的方法
}
```

### 注意事项

- 伴生对象的名字（如上例中的 Factory）不是必须的；如果省略，可以通过默认的 Companion 引用它。
- 尽管伴生对象的成员看起来像是 Java 中的静态成员，但在运行时它们仍然是实例成员。因此，如果需要完全的静态方法，应该使用包级函数或 Java 静态方法。
- 伴生对象可以包含初始化代码块，这些代码块在类加载时执行。

```kotlin
class MyClass {
    companion object {
        val allBooks = mutableListOf<String>()

        // 伴生对象的初始化代码块
        init {
            // 初始化逻辑，例如添加默认数据
            allBooks.add("Kotlin Programming")
            allBooks.add("Advanced Kotlin")
        }

        fun listBooks(): List<String> = allBooks
    }
}

fun main() {
    // 访问伴生对象的成员，触发伴生对象的初始化
    println(MyClass.listBooks())  // 输出初始化时添加的书籍列表
}
```

## data class vs inline class

### Data Class（数据类）

- 目的：主要用于存储数据。Kotlin 中的 data class 提供了一种简洁的方式来创建存储数据的类，自动为类生成了 equals(), hashCode(), toString() 等方法，以及 componentN() 方法和 copy() 方法。这些自动生成的函数使得 data class 非常适合用作不可变的值对象。

- 特性：
  - 必须至少有一个参数；
  - 所有的主构造器参数自动声明为属性；
  - 自动生成 equals(), hashCode(), toString(), componentN() 以及 copy() 方法。
- 用途：适用于传递数据和实现简单的值对象，如用户信息、网络响应等。

### Inline Class（内联类）

- 目的：Kotlin 1.3 引入了内联类的概念，目的是为了提供一种无开销的抽象，即在运行时不会创建额外的对象，但在编译时提供更严格的类型检查和更丰富的语义。一个内联类必须有且只有一个属性在主构造函数中初始化。

- 特性：
  - 在运行时，内联类的实例会被其唯一的属性所代替，不会创建额外的对象；
  - 可以拥有自己的属性和方法；
  - 提供了类型安全的包装，但不引入运行时的性能开销；
  - 不能有 init 块；
  - 不能含有幕后字段。
- 用途：适用于类型安全的包装基本类型或其他类的场景，比如可以用来避免混淆多个同类型的参数或返回值，强调某个值的特定含义或属性，例如，将一个 String 类型的 ID 包装为一个更具语义的类型。

### 区别总结

- 目的和用途：data class 旨在简化数据持有类的创建，而 inline class 旨在无运行时开销地提供类型安全的包装。
- 内存和性能：data class 会像普通类一样在 JVM 上存在为对象，而 inline class 在编译后通常会被优化为使用其单一属性的底层类型，不会产生额外的对象。
- 功能和约束：data class 自动生成多个实用的方法，适用于数据传输对象；inline class 提供了无开销的抽象，有严格的约束，比如只能有一个主构造函数参数。

  在选择使用哪一个时，应根据实际需要考虑它们的特点和适用场景。

## let, with, run, apply, also

在 Kotlin 中，let, with, run, apply, also 是标准库中定义的一组扩展函数，通常用于作用域控制、对象配置、以及非空执行等。

### let

let 函数通常用于在其闭包内对对象执行操作，并返回闭包的结果。它非常有用，特别是当你需要对一个可空对象进行一系列操作时。let 使用对象调用它，并将该对象作为参数传递给闭包。

```kotlin
val str: String? = "Hello"
str?.let {
    // 在这个作用域内，it 指向 str
    println(it.length) // 使用 it 访问 str 的属性
}
```

### with

with 函数不是扩展函数，它接受一个对象和一个扩展函数作为参数。with 的主要用途是对一个对象进行多个操作而不需要重复引用该对象。

```kotlin
val builder = StringBuilder()
with(builder) {
    append("Hello, ")
    append("world!")
    toString() // 这个表达式的结果（即最终的字符串）被 `with` 返回
}
```

### run

run 函数类似于 with，但它是作为对象的扩展函数调用的。它在对象的上下文中执行一个代码块，并返回代码块的最后一个表达式的值。

```kotlin
val result = "Hello".run {
    length // 返回字符串长度
}
```

### apply

apply 函数与 run 非常相似，但不同之处在于它总是返回对象本身而不是闭包的最后一个表达式的值。这使得 apply 非常适合进行对象的配置。

```kotlin
val list = mutableListOf(1, 2, 3).apply {
    add(4) // 添加元素到列表
}
// list 变量持有已经被配置的 MutableList
```

### also

also 与 let 类似，因为它也是通过对象调用并将对象作为参数传递给闭包。不同之处在于 also 返回对象本身，这使得它在需要对对象进行额外操作时非常有用。

```kotlin
val numbers = mutableListOf("one", "two", "three").also {
    println("The list elements before adding new one: $it")
}.apply {
    add("four")
}
```

## thread

```kotlin
fun sendTransactionWithGettingReceipt(transaction: Transaction, password: String): Receipt {
    val tBlockHash = this.sendTBlock(transaction, password)
    val tryGetReceipt: suspend () -> Receipt = {
        try {
            this.getReceipt(tBlockHash)
        } catch (e: Error) {
            delay(1000)
            Receipt()
        }
    }

    var receipt = Receipt()
    runBlocking {
        var times = 0
        while (times < 10) {
            receipt = tryGetReceipt()
            if (receipt.tblockHash.isBlank()) times++ else break
        }
    }
    if (receipt.tblockHash.isBlank()) receipt.tblockHash = tBlockHash
    return receipt
}
```

### suspend

- 作用: suspend 关键字用于标记一个函数可以挂起。挂起函数可以在协程中调用，并且它们可以在不阻塞当前线程的情况下暂停和恢复执行。挂起函数通常用于执行长时间运行的操作，如网络请求或数据库操作。
- 在示例中的应用: 在 sendTransactionWithGettingReceipt 函数内部，tryGetReceipt 被定义为一个挂起的 lambda 表达式。这意味着它可以进行可能耗时的操作（比如网络调用来获取收据），并且在等待网络响应时，不会阻塞当前线程。在此期间，协程可以被挂起，允许其他协程在同一线程上运行。

### runBlocking

- 作用: runBlocking 是一个协程构建器，用于在当前线程启动一个新的协程，并阻塞当前线程直到协程执行完毕。它主要用于桥接阻塞代码和挂起函数，或者在测试中。
- 在示例中的应用: runBlocking 用于启动一个协程以循环尝试获取交易收据。因为 tryGetReceipt 是一个挂起函数，它需要在协程中调用。这段代码在协程中循环，尝试最多 10 次获取非空 receipt.tblockHash 的收据。如果在 10 次尝试之后仍然获取不到有效的收据，它会使用 tBlockHash 作为默认值。runBlocking 在这里确保了整个获取收据的过程是同步的，即使它内部调用了挂起函数。

### 使用 async 和 await

- 作用: async 是一个协程构建器，它可以用于启动一个新的协程，而不会阻塞当前线程，并返回一个 Deferred 对象，这个对象代表了协程的最终结果。你可以在需要结果的时候调用 Deferred 的 await 方法，这将会暂停当前协程直到 async 协程完成，并返回结果。
- 应用场景: 当你有多个并行运行的任务，并且想要在它们都完成后获取结果时，可以使用 async 和 await。

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

### 使用 withContext

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

### 使用 join

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

### 使用 coroutineScope

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

### 使用 select

作用: select 表达式可以在多个协程操作中选择第一个完成的操作并执行。这可以用于实现复杂的并发等待逻辑，比如超时机制。
应用场景: 当你需要从多个并发操作中选择一个最先完成的结果进行处理时，可以使用 select。

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

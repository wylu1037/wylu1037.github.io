---
title: 探索Kotlin扩展函数
date: 2024-09-12T19:44:12+08:00
categories: [kotlin]
tags: [kotlin, extension]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## 1.builtin extension function
+ `let`: 用于处理可能为 null 的对象，并且仅当对象非 null 时才执行 Lambda。
+ `with`: 提供一个上下文对象来简化对对象成员的访问。
+ `run`: 结合了 with 和 let 的功能，可以用于 null 对象，并返回 Lambda 的结果。
+ `apply`: 用于对象的初始化，返回对象本身。
+ `also`: 执行副作用操作，返回对象本身。
+ `takeIf`/`takeUnless`: 根据条件反对对象或null

### 1.1 let
+ **用法**: 常用于安全调用（例如处理可空类型）。
+ **返回值**: lambda 表达式的结果。
+ **this指代**: 作为 `it` 传递。
+ **示例**:
```kotlin
val name: String? = "Kotlin"
name?.let {
    println("Length: ${it.length}")
}
```

### 1.2 with
+ **用法**: 适用于对同一个对象进行多次操作。
+ **返回值**: lambda 表达式的结果。
+ **this指代**: 直接作为 `this` 使用。
+ **示例**:
```kotlin
val builder = StringBuilder()
val result = with(builder) {
    append("Hello, ")
    append("World!")
    toString()
}
```

### 1.3 run
+ **用法**: 用于执行一个lambda表达式，类似于 let，也常用于对象配置。
+ **返回值**: lambda 表达式的结果。
+ **this指代**: 直接作为 `this` 使用。
+ **示例**:
```kotlin
val greeting = "Hello".run {
    this + " World"
}
```

### 1.4 apply
+ **用法**: 用于配置对象，通过调用进行初始化。
+ **返回值**: 原始对象。
+ **this指代**: 直接作为 `this` 使用。
+ **示例**:
```kotlin
val person = Person().apply {
    name = "John"
    age = 30
}
```
> 返回的是 `Person` 对象

### 1.5 also
+ **用法**: 用于执行一些需要更新或处理对象但返回对象本身的操作。
+ **返回值**: 原始对象。
+ **this指代**: 作为 `it` 传递。
+ **示例**:
```kotlin
val number = 5.also {
    println("Processing number: $it")
}
```
> 返回的是 `5`

### 1.6 takeIf
+ **用法**: 如果给定的谓词（条件）为 true，则返回对象本身；否则返回 null。
+ **示例**:
```kotlin
val number = 10
val result = number.takeIf { it > 5 }  // 如果条件为 true，返回 10；否则返回 null
println(result)  // 输出: 10

val smallNumber = 3
val smallResult = smallNumber.takeIf { it > 5 }
println(smallResult)  // 输出: null
```

### 1.7 takeUnless
+ **用法**: 如果给定的谓词（条件）为 false，则返回对象本身；否则返回 null。这是 takeIf 的反义函数。
+ **示例**:
```kotlin
val number = 10
val result = number.takeUnless { it < 5 }  // 如果条件为 false，返回 10；否则返回 null
println(result)  // 输出: 10

val smallNumber = 3
val smallResult = smallNumber.takeUnless { it < 5 }
println(smallResult)  // 输出: null
```
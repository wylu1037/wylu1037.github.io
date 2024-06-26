---
title: 枚举和模式匹配
date: 2024-03-11T19:50:20+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 5
---

## 1.枚举
### 1.1 定义枚举
```rust
fn main() {
    enum Message {
        Quit, // 没有关联任何数据
        Move { x: i32, y: i32 }, // 包含一个匿名结构体
        Write(String), // 包含单独一个 String
        ChangeColor(i32, i32, i32), // 包含三个 i32
    }
}
```

使用struct定义👆枚举中的成员
```rust
fn main() {
    struct QuitMessage; // 类单元结构体
    struct MoveMessage {
        x: i32,
        y: i32,
    }
    struct WriteMessage(String); // 元组结构体
    struct ChangeColorMessage(i32, i32, i32); // 元组结构体
}
```

### 1.2 为枚举定义方法
```rust
fn main() {
    enum Message {
        Quit,
        Move { x: i32, y: i32 },
        Write(String),
        ChangeColor(i32, i32, i32),
    }
    
    impl Message {
        fn call(&self) {
            // 在这里定义方法体
        }
    }
    
    let m = Message::Write(String::from("hello"));
    m.call();
}
```

### 1.3 Option
定义在标准库如下：
```rust
enum Option<T> {
    Some(T),
    None,
}
```

使用Option
```rust
fn main() {
    let some_number = Some(5);
    let some_string = Some("a string");
    
    let absent_number: Option<i32> = None;
}
```


## 2.match 控制流
```rust
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}
```

### 2.1 绑定值的模式
匹配分支的另一个功能是可以绑定匹配模式的部分值，即从枚举成员中提取值。
```rust
#[derive(Debug)] // 这样可以立刻看到州的名称
enum UsState {
    Alabama,
    Alaska,
    // --snip--
}

enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter(UsState),
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter(state) => {
            println!("State quarter from {:?}!", state);
            25
        }
    }
}
```

### 2.2 匹配`Option<T>`
```rust
fn main() {
    fn plus_one(x: Option<i32>) -> Option<i32> {
        match x {
            None => None,
            Some(i) => Some(i + 1),
        }
    }

    let five = Some(5);
    let six = plus_one(five);
    let none = plus_one(None);
}
```

### 2.3 ⚠️ 匹配是穷尽的
```rust
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x { // error[E0004]: non-exhaustive patterns: `None` not covered
        Some(i) => Some(i + 1),
    }
}
```
没有处理`None`的情况，会造成`bug`。

### 2.4 通配模式和`_`占位符
对一些特定的值采取特殊操作，而对其它值采取默认操作。
```rust
fn main() {
    let dice_roll = 9;
    match dice_roll {
        3 => add_fancy_hat(),
        7 => remove_fancy_hat(),
        other => move_player(other),
    }

    fn add_fancy_hat() {}
    fn remove_fancy_hat() {}
    fn move_player(num_spaces: u8) {}
}
```
当不想使用通配模式获取值时，使用`_`，可以匹配任意值而不绑定到该值，告诉`Rust`不会使用这个值。
```rust
fn main() {
    let dice_roll = 9;
    match dice_roll {
        3 => add_fancy_hat(),
        7 => remove_fancy_hat(),
        _ => (), // 不会使用与前面模式不匹配的值，并且不想运行任何代码。
    }

    fn add_fancy_hat() {}
    fn remove_fancy_hat() {}
}
```

## 3.if let 控制流
处理匹配一个模式的值而忽略其它模式的情况。
```rust
fn main() {
    let some_u8_value = Some(0u8);
    match some_u8_value {
        Some(3) => println!("three"),
        _ => (),
    }
}
```
修改为
```rust
fn main() {
    let some_u8_value = Some(0u8);
    if let Some(3) = some_u8_value {
        println!("three");
    }
}
```
可以认为`if let`是`match`的一个语法糖，它当值匹配某一模式时执行代码而忽略所有其他值。

可以在`if let`中包含一个`else`。`else`块中的代码与`match`表达式中的`_`分支块中的代码相同，这样的`match`表达式就等同于`if let`和`else`。
```rust
fn main() {
    let mut count = 0;
    if let Coin::Quarter(state) = coin {
        println!("State quarter from {:?}!", state);
    } else {
        count += 1;
    }
}
```

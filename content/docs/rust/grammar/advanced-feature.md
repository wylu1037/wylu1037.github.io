---
title: 高级特征
date: 2024-04-21T09:52:47+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 7
---

## 宏
### 语法
#### Designators
宏的参数以美元符号$为前缀，并以指示符注释类型：
```rust
macro_rules! create_function {
    // This macro takes an argument of designator `ident` and
    // creates a function named `$func_name`.
    // The `ident` designator is used for variable/function names.
    ($func_name:ident) => {
        fn $func_name() {
            // The `stringify!` macro converts an `ident` into a string.
            println!("You called {:?}()",
                     stringify!($func_name));
        }
    };
}

// Create functions named `foo` and `bar` with the above macro.
create_function!(foo);
create_function!(bar);

macro_rules! print_result {
    // This macro takes an expression of type `expr` and prints
    // it as a string along with its result.
    // The `expr` designator is used for expressions.
    ($expression:expr) => {
        // `stringify!` will convert the expression *as it is* into a string.
        println!("{:?} = {:?}",
                 stringify!($expression),
                 $expression);
    };
}

fn main() {
    foo();
    bar();

    print_result!(1u32 + 1);

    // Recall that blocks are expressions too!
    print_result!({
        let x = 1u32;

        x * x + 2 * x - 1
    });
}
```
> You called "foo"()
> 
> You called "bar"()
> 
> "1u32 + 1" = 2
> 
>"{ let x = 1u32; x * x + 2 * x - 1 }" = 2


以下是一些可用的指示符：
+ `block`
+ `expr` is used for expressions
+ `ident` is used for variable/function names
+ `item`
+ `literal` is used for literal constants
+ `pat` (pattern)
+ `path`
+ `stmt` (statement)
+ `tt` (token tree)
+ `ty` (type)
+ `vis` (visibility qualifier)

#### Overload
可以重载宏以接受不同的参数组合。在这方面，`macro_rules!` 可以类似于 `match` 块：
```rust
// `test!` will compare `$left` and `$right`
// in different ways depending on how you invoke it:
macro_rules! test {
    // Arguments don't need to be separated by a comma.
    // Any template can be used!
    ($left:expr; and $right:expr) => {
        println!("{:?} and {:?} is {:?}",
                 stringify!($left),
                 stringify!($right),
                 $left && $right)
    };
    // ^ each arm must end with a semicolon.
    ($left:expr; or $right:expr) => {
        println!("{:?} or {:?} is {:?}",
                 stringify!($left),
                 stringify!($right),
                 $left || $right)
    };
}

fn main() {
    test!(1i32 + 1 == 2i32; and 2i32 * 2 == 4i32);
    test!(true; or false);
}
```
> "1i32 + 1 == 2i32" and "2i32 * 2 == 4i32" is true
> 
> "true" or "false" is true

#### Repeat
宏可以在参数列表中使用 `+` 来表示参数至少可以重复一次，或者使用 `*` 来表示参数可以重复零次或多次。

在下面的示例中，在匹配器周围加上 `$(…)`，`+` 将匹配一个或多个以逗号分隔的表达式。还要注意，分号在最后一种情况下是可选的。
```rust
// `find_min!` will calculate the minimum of any number of arguments.
macro_rules! find_min {
    // Base case:
    ($x:expr) => ($x);
    // `$x` followed by at least one `$y,`
    ($x:expr, $($y:expr),+) => (
        // Call `find_min!` on the tail `$y`
        std::cmp::min($x, find_min!($($y),+))
    )
}

fn main() {
    println!("{}", find_min!(1));
    println!("{}", find_min!(1 + 2, 2));
    println!("{}", find_min!(5, 2 * 3, 4));
}
```
> 1
>
> 2
>
> 4


### DRY
Don't Repeat Yourself



### DSL

```rust
macro_rules! calculate {
    (eval $e:expr) => {
        {
            let val: usize = $e; // Force types to be unsigned integers
            println!("{} = {}", stringify!{$e}, val);
        }
    };
}

fn main() {
    calculate! {
        eval 1 + 2 // hehehe `eval` is _not_ a Rust keyword!
    }

    calculate! {
        eval (1 + 2) * (3 / 4)
    }
}
```


### Variadic
可变接口接受任意数量的参数。例如，`println!` 可以接受任意数量的参数，由格式字符串决定。

我们可以扩展我们的 `calculate!` 将上一节中的宏设置为可变的:

```rust
macro_rules! calculate {
    // The pattern for a single `eval`
    (eval $e:expr) => {
        {
            let val: usize = $e; // Force types to be integers
            println!("{} = {}", stringify!{$e}, val);
        }
    };

    // Decompose multiple `eval`s recursively
    (eval $e:expr, $(eval $es:expr),+) => {{
        calculate! { eval $e }
        calculate! { $(eval $es),+ }
    }};
}

fn main() {
    calculate! { // Look ma! Variadic `calculate!`!
        eval 1 + 2,
        eval 3 + 4,
        eval (2 * 3) + 1
    }
}
```

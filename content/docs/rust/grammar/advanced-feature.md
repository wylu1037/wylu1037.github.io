---
title: 高级特征
date: 2024-04-21T09:52:47+08:00
authors:
    - name: wylu
      link: https://github.com/wylu1037
      image: https://github.com/wylu1037.png?size=40
weight: 7
---

## 1.宏

### 1.1 语法

#### 1.1.1 Designators

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
> "{ let x = 1u32; x _ x + 2 _ x - 1 }" = 2

以下是一些可用的指示符：

##### block

表示一个代码块

```rust
macro_rules! repeat_block {
    ($count:expr, $block:block) => {
        {
            for _ in 0..$count {
                $block
            }
        }
    };
}

fn main() {
    repeat_block!(3, {
        println!("Hello, world!");
    });
}
```

##### expr

表示一个表达式。

```rust
macro_rules! square {
    ($x:expr) => {
        $x * $x
    };
}

fn main() {
    let num = 5;
    let result = square!(num);
    println!("Square of {} is {}", num, result);
}
```

##### ident

表示标识符（变量名或函数名）

```rust
macro_rules! create_function {
    ($func_name:ident) => {
        fn $func_name() {
            println!("Hello from {}!", stringify!($func_name));
        }
    };
}

create_function!(greet);

fn main() {
    greet();
}
```

is used for variable/function names

##### item

用于匹配和传递任何有效的 Rust 代码项（item），比如函数、结构体、枚举、trait 实现等。

```rust
macro_rules! create_test {
    ($func:item) => {
        #[test]
        $func
    };
}

create_test! {
    fn it_works() {
        assert_eq!(2 + 2, 4);
    }
}

```

##### literal

表示字面常量。

```rust
macro_rules! print_literal {
    ($lit:literal) => {
        println!("Literal value: {}", $lit);
    };
}

fn main() {
    print_literal!("Hello, world!");
    print_literal!(42);
}
```

##### pat

用于模式。

```rust
macro_rules! match_enum {
    ($e:expr, $p:pat) => {
        match $e {
            $p => println!("Matched pattern: {:?}", $p),
            _ => println!("Did not match"),
        }
    };
}

fn main() {
    enum Number {
        Zero,
        One,
        Two,
    }

    let num = Number::One;
    match_enum!(num, Number::One);
}
```

##### path

用于匹配 Rust 中的路径（path）。路径通常指的是类型、函数、模块、宏或其他项的名称，可能包括多个标识符和双冒号（::），例如 std::collections::HashMap。

```rust
macro_rules! call_function {
    ($func:path) => {
        $func();
    };
}

mod greetings {
    pub fn hello() {
        println!("Hello, world!");
    }
}

fn main() {
    call_function!(greetings::hello);
}

```

##### stmt

用于匹配语句（statement）。语句是执行某些操作的指令，比如变量声明、表达式（包括赋值表达式和函数调用）等。

```rust
macro_rules! with_logging {
    ($($stmt:stmt)*) => {
        {
            println!("Starting block");
            $($stmt)*
            println!("Ending block");
        }
    };
}

fn main() {
    with_logging! {
        let x = 3;
        println!("The value of x is: {}", x);
    }
}
```

##### tt

用于标记树（token tree）。用于匹配几乎任何 Rust 语法结构。它可以匹配单个标记（token），也可以匹配由括号、方括号或花括号及其内容组成的结构。

```rust
macro_rules! echo {
    ($($tts:tt)*) => {
        $($tts)*
    };
}

fn main() {
    echo! {
        let x = 3;
        println!("x is {}", x);
    }
}

```

##### ty

用于匹配 Rust 中的类型（type）。当你在宏中使用 $variable:ty 时，你可以将任何有效的 Rust 类型作为参数传递给宏。

```rust
macro_rules! create_struct {
    ($name:ident, $field:ident: $ftype:ty) => {
        struct $name {
            $field: $ftype,
        }
    };
}

create_struct!(Point, x: i32, y: i32);

```

##### vis

用于匹配项（item）的可见性修饰符。这允许你在宏中指定项的可见性，例如 pub 或 pub(crate)，以控制项在模块外的可见性。

```rust
macro_rules! create_function {
    ($vis:vis $name:ident) => {
        $vis fn $name() {
            println!("Function {} is called", stringify!($name));
        }
    };
}

create_function!(pub hello);
create_function!(pub(crate) goodbye);
```

##### lifetime

用于生命周期标记。

```rust
macro_rules! impl_lifetime_trait {
    ($type:ty, $lifetime:lifetime) => {
        impl<$lifetime> MyTrait<$lifetime> for $type {
            // 实现细节
        }
    };
}

struct MyStruct<'a> {
    // 结构体定义
}

// 使用宏为 MyStruct 实现 MyTrait
impl_lifetime_trait!(MyStruct<'a>, 'a);

```

#### 1.1.2 Overload

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

> "1i32 + 1 == 2i32" and "2i32 \* 2 == 4i32" is true
>
> "true" or "false" is true

#### 1.1.3 Repeat

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

### 1.2 DRY

Don't Repeat Yourself

### 1.3 DSL

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

### 1.4 Variadic

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

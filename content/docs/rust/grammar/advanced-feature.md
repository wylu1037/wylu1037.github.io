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
宏有两种：

- `macro_rules!`：声明式宏
- `macro`：过程宏


### 1.1 Designators

宏的参数以美元符号 `$` 为前缀，并以指示符注释类型。

```rust {hl_lines=[1,18]}
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


#### 1.1.1 block

表示一个代码块，专门匹配由花括号`{}`包围的代码块。

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

#### 1.1.2 expr

表示一个表达式：
+ 数学运算
+ 函数调用
+ 代码块表达式
+ 字面量
+ 变量

> `expr` 在某种程序上包含了 `block`。

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

#### 1.1.3 ident

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

#### 1.1.4 item

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

#### 1.1.5 literal

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

#### 1.1.6 pat

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

#### 1.1.7 path

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

#### 1.1.8 stmt

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

#### 1.1.9 tt

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

#### 1.1.10 ty

用于匹配 Rust 中的类型（type）。当你在宏中使用 `$variable:ty` 时，你可以将任何有效的 Rust 类型作为参数传递给宏。

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

#### 1.1.11 vis

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

#### 1.1.12 lifetime

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

### 1.2 Overload

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

### 1.3 Repeat

- `+` 来表示参数可以重复**一次或多次**（至少可以重复一次）
- `*` 来表示参数可以重复**零次或多次**（可以不重复）

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

### 1.4 DRY（不要重复你自己）

宏能够通过抽象来减少代码重复。通过编写一次代码并让宏处理重复的部分，我们可以保持代码的 DRY 原则：

```rust
macro_rules! impl_op_ex {
    ($($t:ty)*) => ($(impl OpEx for $t { })*);
}

impl_op_ex! { i8 i16 i32 i64 isize u8 u16 u32 u64 usize f32 f64 }
```

### 1.5 DSL（领域特定语言）

宏使得创建领域特定语言成为可能，这些语言在特定问题域中提供更自然的语法：

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

### 1.6 可变参数宏（Variadic Macros）

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

### 1.7 过程宏（Procedural Macros）

过程宏允许你在编译时运行代码来操作 Rust 语法树，比声明式宏更强大但也更复杂。

#### 1.7.1 派生宏（Derive Macros）
派生宏用于为结构体和枚举自动实现 trait：

```rust
use proc_macro::TokenStream;
use quote::quote;
use syn;

#[proc_macro_derive(HelloMacro)]
pub fn hello_macro_derive(input: TokenStream) -> TokenStream {
    // 构建 Rust 代码所代表的语法树
    let ast = syn::parse(input).unwrap();

    // 构建 impl
    impl_hello_macro(&ast)
}

fn impl_hello_macro(ast: &syn::DeriveInput) -> TokenStream {
    let name = &ast.ident;
    let gen = quote! {
        impl HelloMacro for #name {
            fn hello_macro() {
                println!("Hello, Macro! My name is {}!", stringify!(#name));
            }
        }
    };
    gen.into()
}
```

#### 1.7.2 类属性宏（Attribute-like Macros）
创建新属性的宏：

```rust
#[proc_macro_attribute]
pub fn route(attr: TokenStream, item: TokenStream) -> TokenStream {
    // 实现逻辑
}
```

#### 1.7.3 类函数宏（Function-like Macros）
看起来像函数调用的过程宏：

```rust
#[proc_macro]
pub fn sql(input: TokenStream) -> TokenStream {
    // 实现逻辑
}
```

## 2.不安全 Rust（Unsafe Rust）

Rust 的内存安全保证是通过静态分析来实现的，但有时这些保证会过于保守。在这些情况下，可以使用 `unsafe` 来告诉编译器你知道自己在做什么。

### 2.1 不安全的超能力

在 `unsafe` 块中，你可以进行五种不安全的操作：

1. **解引用原生指针**
2. **调用不安全的函数或方法**
3. **访问或修改可变静态变量**
4. **实现不安全 trait**
5. **访问 `union` 的字段**

### 2.2 解引用原生指针

原生指针有两种类型：`*const T` 和 `*mut T`。它们不实现自动清理功能。

```rust
fn main() {
    let mut num = 5;

    let r1 = &num as *const i32;
    let r2 = &mut num as *mut i32;

    unsafe {
        println!("r1 is: {}", *r1);
        println!("r2 is: {}", *r2);
    }
}
```

### 2.3 调用不安全函数或方法

```rust
unsafe fn dangerous() {
    println!("This is dangerous!");
}

fn main() {
    unsafe {
        dangerous();
    }
}
```

### 2.4 创建不安全代码的安全抽象

```rust
use std::slice;

fn split_at_mut(slice: &mut [i32], mid: usize) -> (&mut [i32], &mut [i32]) {
    let len = slice.len();
    let ptr = slice.as_mut_ptr();

    assert!(mid <= len);

    unsafe {
        (
            slice::from_raw_parts_mut(ptr, mid),
            slice::from_raw_parts_mut(ptr.add(mid), len - mid),
        )
    }
}
```

### 2.5 使用 extern 函数调用外部代码

```rust
extern "C" {
    fn abs(input: i32) -> i32;
}

fn main() {
    unsafe {
        println!("Absolute value of -3 according to C: {}", abs(-3));
    }
}
```

## 3.高级 trait

### 3.1 关联类型在 trait 定义中指定占位符类型

**关联类型**（associated types）是一个将类型占位符与 trait 相关联的方式，这样 trait 的方法签名中就可以使用这些占位符类型。

```rust
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;
}

struct Counter {
    current: usize,
    max: usize,
}

impl Iterator for Counter {
    type Item = usize;

    fn next(&mut self) -> Option<Self::Item> {
        if self.current < self.max {
            let current = self.current;
            self.current += 1;
            Some(current)
        } else {
            None
        }
    }
}
```

### 3.2 默认泛型类型参数和运算符重载

```rust
use std::ops::Add;

#[derive(Debug, PartialEq)]
struct Point {
    x: i32,
    y: i32,
}

impl Add for Point {
    type Output = Point;

    fn add(self, other: Point) -> Point {
        Point {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

fn main() {
    assert_eq!(
        Point { x: 1, y: 0 } + Point { x: 2, y: 3 },
        Point { x: 3, y: 3 }
    );
}
```

### 3.3 完全限定语法与消歧义

```rust
trait Pilot {
    fn fly(&self);
}

trait Wizard {
    fn fly(&self);
}

struct Human;

impl Pilot for Human {
    fn fly(&self) {
        println!("This is your captain speaking.");
    }
}

impl Wizard for Human {
    fn fly(&self) {
        println!("Up!");
    }
}

impl Human {
    fn fly(&self) {
        println!("*waving arms furiously*");
    }
}

fn main() {
    let person = Human;
    Pilot::fly(&person);
    Wizard::fly(&person);
    person.fly();
}
```

### 3.4 父 trait 用于在另一个 trait 中使用某 trait 的功能

```rust
use std::fmt;

trait OutlinePrint: fmt::Display {
    fn outline_print(&self) {
        let output = self.to_string();
        let len = output.len();
        println!("{}", "*".repeat(len + 4));
        println!("*{}*", " ".repeat(len + 2));
        println!("* {} *", output);
        println!("*{}*", " ".repeat(len + 2));
        println!("{}", "*".repeat(len + 4));
    }
}

struct Point {
    x: i32,
    y: i32,
}

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

impl OutlinePrint for Point {}
```

### 3.5 newtype 模式用以在外部类型上实现外部 trait

```rust
use std::fmt;

struct Wrapper(Vec<String>);

impl fmt::Display for Wrapper {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "[{}]", self.0.join(", "))
    }
}

fn main() {
    let w = Wrapper(vec![String::from("hello"), String::from("world")]);
    println!("w = {}", w);
}
```

## 4.高级类型

### 4.1 为了类型安全和抽象而使用 newtype 模式

newtype 模式可以用于：
1. **类型安全**：确保值不会混淆
2. **抽象**：隐藏内部实现

```rust
struct Millimeters(u32);
struct Meters(u32);

impl Millimeters {
    fn to_meters(&self) -> Meters {
        Meters(self.0 / 1000)
    }
}
```

### 4.2 类型别名用来创建类型同名

```rust
type Kilometers = i32;

let x: i32 = 5;
let y: Kilometers = 5;

println!("x + y = {}", x + y);
```

### 4.3 从不返回的 never type

```rust
fn bar() -> ! {
    panic!("This function never returns!");
}

let guess: u32 = match guess.trim().parse() {
    Ok(num) => num,
    Err(_) => continue, // continue 的类型是 !
};
```

### 4.4 动态大小类型和 Sized trait

Rust 需要知道类型占用多少空间，但**动态大小类型**（DST）的大小只能在运行时确定：

```rust
// str 是 DST，所以我们不能直接使用
// let s1: str = "Hello there!"; // 错误

// 必须使用 &str
let s1: &str = "Hello there!";

// 或者使用 Box<str>
let s2: Box<str> = "Hello there!".into();
```

## 5.高级函数与闭包

### 5.1 函数指针

```rust
fn add_one(x: i32) -> i32 {
    x + 1
}

fn do_twice(f: fn(i32) -> i32, arg: i32) -> i32 {
    f(arg) + f(arg)
}

fn main() {
    let answer = do_twice(add_one, 5);
    println!("The answer is: {}", answer);
}
```

### 5.2 返回闭包

```rust
fn returns_closure() -> Box<dyn Fn(i32) -> i32> {
    Box::new(|x| x + 1)
}

fn main() {
    let f = returns_closure();
    println!("{}", f(1));
}
```

### 5.3 函数指针与闭包的区别

```rust
let list_of_numbers = vec![1, 2, 3];
let list_of_strings: Vec<String> =
    list_of_numbers.iter().map(|i| i.to_string()).collect();

// 也可以使用函数指针
let list_of_strings: Vec<String> =
    list_of_numbers.iter().map(ToString::to_string).collect();
```

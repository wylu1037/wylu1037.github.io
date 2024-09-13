---
title: 语法篇
date: 2024-09-13T19:31:45+08:00
width: full
weight: 1
---

{{< cards >}}
    {{< card link="" title="入门指南" subtitle="轻松掌握Python基础：从零开始编写高效代码" icon="arrow-circle-right" >}}
{{< /cards >}}


## 1.推导式
### 1.1 列表推导式

语法
```python
new_list = [expression for item in iterable if condition]
```

其中：
+ `expression`：对 item 进行计算的表达式。
+ `item`：从 iterable 中取出的每个元素。
+ `iterable`：可以迭代的对象，如列表、元组、集合、字符串等。
+ `condition`<sub> 可选</sub>：一个布尔表达式，用于过滤 iterable 中的元素。

### 1.2 字典推导式
语法
```python
new_dict = {key_expression: value_expression for item in iterable if condition}
```
其中：
+ `key_expression`：生成字典键的表达式。
+ `value_expression`：生成字典值的表达式。
+ `item`：从 iterable 中取出的每个元素。
+ `iterable`：可以迭代的对象，如列表、元组、集合等。
+ `condition`<sub> 可选</sub>：一个布尔表达式，用于过滤 iterable 中的元素。

示例：

```python
numbers = [1, 2, 3, 4, 5]
squares_dict = {x: x**2 for x in numbers}
print(squares_dict)  # 输出：{1: 1, 2: 4, 3: 9, 4: 16, 5: 25}
```
> 从列表创建一个新的字典。

```python
even_squares_dict = {x: x**2 for x in numbers if x % 2 == 0}
print(even_squares_dict)  # 输出：{2: 4, 4: 16}
```
> 只保留偶数的平方。

### 1.3 集合推导式

语法：
```python
new_set = {expression for item in iterable if condition}
```
其中：
+ `expression`：生成集合元素的表达式。
+ `item`：从 iterable 中取出的每个元素。
+ `iterable`：可以迭代的对象，如列表、元组、集合等。
+ `condition`<sub> 可选</sub>：一个布尔表达式，用于过滤 iterable 中的元素。

示例：
```python
numbers = [1, 2, 3, 4, 5]
squares_set = {x**2 for x in numbers}
print(squares_set)  # 输出：{1, 4, 9, 16, 25}
```
> 创建一个新的集合。

```python
even_squares_set = {x**2 for x in numbers if x % 2 == 0}
print(even_squares_set)  # 输出：{4, 16}
```
> 只保留偶数的平方。

### 1.4 生成器表达式

语法：
```python
generator = (expression for item in iterable if condition)
```

其中：
+ `expression`：生成生成器元素的表达式。
+ `item`：从 iterable 中取出的每个元素。
+ `iterable`：可以迭代的对象，如列表、元组、集合等。
+ `condition`<sub> 可选</sub>：一个布尔表达式，用于过滤 iterable 中的元素。

示例：
```python
numbers = [1, 2, 3, 4, 5]
squares_gen = (x**2 for x in numbers)
print(list(squares_gen))  # 输出：[1, 4, 9, 16, 25]
```
> 创建一个生成器，其中包含每个元素的平方。

```python
even_squares_gen = (x**2 for x in numbers if x % 2 == 0)
print(list(even_squares_gen))  # 输出：[4, 16]
```
> 只保留偶数的平方。

## **

### 幂运算符
```python
# 计算 2 的 3 次方
result = 2 ** 3
print(result)  # 输出 8
```

### 字典参数解包
`**` 可以用于函数调用时 解包字典，将字典中的键值对作为命名参数传递给函数。
```python
def greet(name, age):
    print(f"Hello, my name is {name} and I am {age} years old.")

# 使用字典解包
person_info = {"name": "Alice", "age": 25}
greet(**person_info)
# 输出：Hello, my name is Alice and I am 25 years old.
```

### 定义函数时的关键字参数
在定义函数时，`**kwargs` 表示可以接受任意数量的关键字参数，并将它们打包成一个字典。
```python
def my_function(**kwargs):
    for key, value in kwargs.items():
        print(f"{key} = {value}")

my_function(name="Alice", age=25, city="New York")
# 输出：
# name = Alice
# age = 25
# city = New York
```

## 定义枚举和常量

### 枚举
```python
from enum import Enum

class Color(Enum):
    RED = 1
    GREEN = 2
    BLUE = 3

# 访问枚举成员
print(Color.RED)        # 输出 Color.RED
print(Color.RED.name)   # 输出 'RED'
print(Color.RED.value)  # 输出 1
```
+ 枚举的成员是常量，值可以是整数、字符串等。
+ 可以通过 `name` 属性获取枚举成员的名称，通过 `value` 属性获取枚举成员的值。

遍历枚举
```python
for color in Color:
    print(color)
```

枚举比较
```python
if Color.RED == Color.RED:
    print("匹配")  # 输出 '匹配'
```

使用 `auto` 自动赋值
```python
from enum import Enum, auto

class Color(Enum):
    RED = auto()
    GREEN = auto()
    BLUE = auto()

print(Color.RED.value)   # 输出 1
print(Color.GREEN.value) # 输出 2
```

### 常量

Python 没有专门的语法定义常量，通常通过约定使用 全大写变量名 来表示常量。这种方式约定程序员不修改这些值，但 Python 并不会强制要求常量的不可变性。

```python
# 定义常量
PI = 3.14159
GRAVITY = 9.8
SPEED_OF_LIGHT = 299792458  # 光速，单位为米/秒

# 使用常量
print(PI)  # 输出 3.14159
```

## 访问权限

### public
在 Python 中，所有未添加特殊前缀的变量或方法默认是 public（公共） 的，意味着它们可以被类外部访问。
```python
class MyClass:
    def __init__(self):
        self.name = "Public Name"  # 公共属性

    def public_method(self):
        return "This is a public method"  # 公共方法

obj = MyClass()
print(obj.name)  # 可以直接访问公共属性
print(obj.public_method())  # 可以直接调用公共方法
```

### private
Python 中的私有成员是通过 命名约定 实现的。虽然 Python 不能像某些语言一样完全限制私有成员的访问，但通过在变量或方法名前加 双下划线 `__`，可以启用名称改写（name mangling），使得类外部无法直接访问这些成员。
```python
class MyClass:
    def __init__(self):
        self.__secret = "Private Name"  # 私有属性

    def __private_method(self):
        return "This is a private method"  # 私有方法

obj = MyClass()
# print(obj.__secret)  # 会报错，无法直接访问私有属性
# print(obj.__private_method())  # 会报错，无法直接调用私有方法
```

Python 实现私有属性的一种方式是将变量名自动改写为 `_类名__变量名`，因此虽然类外无法直接访问，但可以通过这种改写后的名字访问到。
```python
print(obj._MyClass__secret)  # 正确访问
print(obj._MyClass__private_method())  # 正确调用
```

### protected
在 Python 中，没有真正的 protected 关键字，但通过 单下划线 `_` 作为前缀表示 受保护成员。这是一种约定，表明该成员是受保护的，不应该 从类外部直接访问，但它可以在子类中被访问和使用。
```python
class MyClass:
    def __init__(self):
        self._protected = "Protected Name"  # 受保护属性

    def _protected_method(self):
        return "This is a protected method"  # 受保护方法

class SubClass(MyClass):
    def access_protected(self):
        return self._protected  # 子类可以访问受保护成员

obj = SubClass()
print(obj._protected)  # 可以访问，但不推荐
print(obj.access_protected())  # 子类可以正确访问受保护属性
```

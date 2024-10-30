---
title: 🔌 TypeScript
date: 2024-09-23T17:26:02+08:00
width: full
weight: 7
---

{{< callout type="info" >}}
如何直接运行 `ts` 文件呢？
{{< /callout >}}

{{% steps %}}

<h5>安装 ts-node：</h5>
npm install -g ts-node

<h5>直接运行 TypeScript 文件：</h5>
ts-node example.ts

{{% /steps %}}

`TypeScript` 是 `JavaScript` 的超集，它为 `JavaScript` 添加了静态类型检查和其他一些特性，使开发者在大型项目中能更好地维护代码的稳定性和可读性。`TypeScript` 最终会被编译成纯 `JavaScript` 运行在浏览器或 `Node.js` 中。下面是 `TypeScript` 的一些主要语法特性：

## 1. 主要语法特性

### 1.1 基本类型

TypeScript 增加了静态类型，可以在变量声明时指定类型：

```typescript
let isDone: boolean = false;
let age: number = 30;
let username: string = "Wenyang";
let numbers: number[] = [1, 2, 3];
let tuple: [string, number] = ["hello", 10]; // 元组类型
```

### 1.2 类型推断

即使不显式声明类型，TypeScript 也可以自动推断类型：

```typescript
let message = "Hello, TypeScript!"; // TypeScript 自动推断为 string
```

### 1.3 接口 (Interfaces)

TypeScript 允许你定义对象的形状（结构）：

```typescript
interface Person {
  name: string;
  age: number;
  greet(): void;
}

let person: Person = {
  name: "Wenyang",
  age: 28,
  greet() {
    console.log("Hello, I'm Wenyang!");
  },
};
```

### 1.4 函数类型

你可以给函数参数和返回值指定类型：

```typescript
function add(x: number, y: number): number {
  return x + y;
}

let myAdd: (x: number, y: number) => number = function (x, y) {
  return x + y;
};
```

### 1.5 可选参数与默认参数

可以定义可选参数和带有默认值的参数：

```typescript
function greet(name: string, greeting: string = "Hello"): void {
  console.log(`${greeting}, ${name}!`);
}

greet("Wenyang"); // 输出：Hello, Wenyang!
```

### 1.6 联合类型 (Union Types)

变量可以有多个类型，称为联合类型：

```typescript
let id: number | string;
id = 101; // 可以是数字
id = "202"; // 也可以是字符串
```

### 1.7 类型别名 (Type Aliases)

你可以为复杂的类型定义一个别名：

```typescript
type ID = number | string;
let userId: ID;
userId = 123;
userId = "abc123";
```

### 1.8 类 (Classes)

TypeScript 增强了面向对象编程的支持，可以使用类、继承、访问修饰符等：

```typescript
class Animal {
  public name: string;
  private age: number;

  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }

  public speak() {
    console.log(`${this.name} makes a sound.`);
  }
}

class Dog extends Animal {
  constructor(name: string, age: number) {
    super(name, age);
  }

  public speak() {
    console.log(`${this.name} barks.`);
  }
}

let dog = new Dog("Buddy", 4);
dog.speak(); // Buddy barks.
```

### 1.9 泛型 (Generics)

TypeScript 支持泛型，可以让你编写更灵活的代码：

```typescript
function identity<T>(arg: T): T {
  return arg;
}

let output = identity<string>("Hello"); // 使用泛型
let output2 = identity<number>(123); // 使用泛型
```

### 1.10 枚举 (Enums)

枚举用于定义一组命名常量：

```typescript
enum Direction {
  Up,
  Down,
  Left,
  Right,
}

let dir: Direction = Direction.Up;
console.log(dir); // 输出：0
```

### 1.11 类型断言 (Type Assertions)

类型断言用于告诉编译器将某一变量当作某种类型来处理：

```typescript
let someValue: any = "this is a string";
let strLength: number = (someValue as string).length;
```

### 1.12 模块 (Modules)

在 TypeScript 中，模块化依赖于 JavaScript 的模块系统，它基于 `import` 和 `export` 关键字。TypeScript 中的模块化可以使用两种形式：

- **ES Modules (ESM)**：即 ECMAScript 标准的模块系统，使用 `import/export`。
- **CommonJS**：Node.js 中使用的模块系统，使用 `require/module.exports`。

<h4>ES Modules</h4>

- TypeScript 模块依赖 JavaScript 运行时（如 Node.js、浏览器等）。
- 模块通过**文件系统**组织，每个 .ts 文件可以作为一个独立的模块。
- TypeScript 允许通过不同的模块解析策略（moduleResolution）来适应不同环境（如 Node.js 或浏览器）。
- 支持动态导入，可以在运行时按需加载模块。

```typescript
// 导出
export class Person {
  constructor(public name: string) {}
}

// 导入
import { Person } from "./person";
let p = new Person("Wenyang");
```

### 1.13 装饰器 (Decorators)

装饰器是一种特殊的声明，可以附加在类、方法、访问器等上面，用于修改它们的行为。装饰器功能依赖于编译器选项 `experimentalDecorators`：

```typescript
function log(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
  const originalMethod = descriptor.value;
  descriptor.value = function (...args: any[]) {
    console.log(`Calling ${propertyKey} with`, args);
    return originalMethod.apply(this, args);
  };
  return descriptor;
}

class Calculator {
  @log
  add(a: number, b: number): number {
    return a + b;
  }
}

let calc = new Calculator();
calc.add(2, 3); // Console: Calling add with [2, 3]
```

这些是 TypeScript 的一些核心语法特性，它在 JavaScript 的基础上增加了类型系统和面向对象的增强功能，使代码更加健壮和易于维护。如果你有更多具体的语法问题，随时可以提问！

## 2.面向对象

### 2.1 多态

{{< callout type="info" >}}
使用接口实现多态。
{{< /callout >}}

```typescript
interface Animal {
  speak(): void;
}

class Dog implements Animal {
  speak() {
    console.log("Woof!");
  }
}

class Cat implements Animal {
  speak() {
    console.log("Meow!");
  }
}

function makeAnimalSpeak(animal: Animal) {
  animal.speak();
}

const dog = new Dog();
const cat = new Cat();

makeAnimalSpeak(dog); // 输出: Woof!
makeAnimalSpeak(cat); // 输出: Meow!
```

{{< callout type="info" >}}
使用类继承实现多态。
{{< /callout >}}

```typescript
class Vehicle {
  move() {
    console.log("The vehicle moves.");
  }
}

class Car extends Vehicle {
  move() {
    console.log("The car drives.");
  }
}

class Bicycle extends Vehicle {
  move() {
    console.log("The bicycle pedals.");
  }
}

function moveVehicle(vehicle: Vehicle) {
  vehicle.move();
}

const car = new Car();
const bicycle = new Bicycle();

moveVehicle(car); // 输出: The car drives.
moveVehicle(bicycle); // 输出: The bicycle pedals.
```

{{< callout type="info" >}}
抽象类与多态
{{< /callout >}}

```typescript
abstract class Shape {
  abstract area(): number;
}

class Circle extends Shape {
  constructor(private radius: number) {
    super();
  }

  area(): number {
    return Math.PI * this.radius ** 2;
  }
}

class Rectangle extends Shape {
  constructor(private width: number, private height: number) {
    super();
  }

  area(): number {
    return this.width * this.height;
  }
}

function printArea(shape: Shape) {
  console.log(`Area: ${shape.area()}`);
}

const circle = new Circle(5);
const rectangle = new Rectangle(4, 6);

printArea(circle); // 输出: Area: 78.53981633974483
printArea(rectangle); // 输出: Area: 24
```

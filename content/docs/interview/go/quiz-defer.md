---
title: defer
date: 2024-03-14T20:00:26+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## 1.注意事项和细节

### 1.1 调用顺序

{{< tabs items="题目,答案" >}}

{{< tab>}}
代码输出结果是什么？

```go
func main() {
    for i := 0; i < 10; i++ {
        defer fmt.Println(i)
    }
}
```

{{< /tab>}}

{{< tab>}}

```shell
9
8
7
6
5
4
3
2
1
0
```

{{< callout >}}
多个 defer 语句和栈一样，即"先进后出"特性，越后面的 defer 表达式越先被调用。
{{< /callout >}}
{{< /tab>}}

{{< /tabs>}}

### 1.2 defer 拷贝

{{< tabs items="题目,答案" >}}

{{< tab>}}
代码输出结果是什么？

```go
func main() {
    fmt.Println(Sum(1, 2))
}

func Sum(num1, num2 int) int {
    defer fmt.Println("num1:", num1)
    defer fmt.Println("num2:", num2)
    num1++
    num2++
    return num1 + num2
}
```

{{< /tab>}}

{{< tab>}}

```shell
1
2
```

{{< callout >}}
正确的答案是 num1 为 1,num2 为 2，这两个变量并不受 num1++、num2++的影响，因为 defer 将语句放入到栈中时，也会将相关的值拷贝同时入栈。
{{< /callout >}}
{{< /tab>}}

{{< /tabs>}}

### 1.3 defer 与 return 的返回时机

<br>
{{< font "red" "return的返回步骤" >}}

{{% steps %}}

<h5></h5>
函数在返回时，首先函数返回时会自动创建一个返回变量假设为 ret (如果是命名返回值的函数则不会创建)，函数返回时要将变量 i 赋值给 ret，即有 ret = i；
<h5></h5>
然后检查函数中是否有 defer 存在，若有则执行 defer 中部分；
<h5></h5>
最后返回 ret；
{{% /steps %}}

{{< tabs items="题目,答案" >}}

{{< tab>}}
匿名返回值函数

```go
func Anonymous() int {
    var i int
    defer func() {
        i++
        fmt.Println("defer2 value is ", i)
    }()

    defer func() {
        i++
        fmt.Println("defer1 in value is ", i)
    }()

    return i
}
```

{{< /tab>}}

{{< tab>}}

```shell
0
```

{{< /tab>}}

{{< /tabs>}}

<br>
{{< tabs items="题目,答案" >}}

{{< tab>}}
命名返回值的函数

```go
func HasName() (j int) {
    defer func() {
        j++
        fmt.Println("defer2 in value", j)
    }()

    defer func() {
        j++
        fmt.Println("defer1 in value", j)
    }()

    return j
}
```

{{< /tab>}}

{{< tab>}}

```shell
2
```

{{< /tab>}}

{{< /tabs>}}

## 2.六大原则

- `defer` 后面跟的必须是函数或者方法调用，`defer` 后面的表达式不能加括号；
- 被 `defer` 的函数或方法的参数的值在定义 `defer` 语句的时候就被确定下来了；
- 被 `defer` 的函数或者方法如果存在多级调用，只有最后一个函数或方法会被 `defer` 到函数 return 或者 panic 之前执行；
- 被 `defer` 的函数执行顺序满足 LIFO 原则，后 `defer` 的先执行；
- 被 `defer` 的函数可以对`defer`语句所在的函数的命名返回值做读取和修改操作；
- {{< font "blue" "即使 defer 语句执行了，被 defer 的函数不一定会执行；" >}}

## 3.源码
```go
// A _defer holds an entry on the list of deferred calls.
// If you add a field here, add code to clear it in deferProcStack.
// This struct must match the code in cmd/compile/internal/ssagen/ssa.go:deferstruct
// and cmd/compile/internal/ssagen/ssa.go:(*state).call.
// Some defers will be allocated on the stack and some on the heap.
// All defers are logically part of the stack, so write barriers to
// initialize them are not required. All defers must be manually scanned,
// and for heap defers, marked.
type _defer struct {
	started bool //标记是否开始执行defer
	heap    bool
	// openDefer indicates that this _defer is for a frame with open-coded
	// defers. We have only one defer record for the entire frame (which may
	// currently have 0, 1, or more defers active).
	openDefer bool
	sp        uintptr // sp at time of defer
	pc        uintptr // pc at time of defer
	fn        func()  // can be nil for open-coded defers
	_panic    *_panic // panic that is running defer，指向当前执行的panic
	link      *_defer // next defer on G; can point to either heap or stack!

	// If openDefer is true, the fields below record values about the stack
	// frame and associated function that has the open-coded defer(s). sp
	// above will be the sp for the frame, and pc will be address of the
	// deferreturn call in the function.
	fd   unsafe.Pointer // funcdata for the function associated with the frame
	varp uintptr        // value of varp for the stack frame
	// framepc is the current pc associated with the stack frame. Together,
	// with sp above (which is the sp associated with the stack frame),
	// framepc/sp can be used as pc/sp pair to continue a stack trace via
	// gentraceback().
	framepc uintptr
}
```

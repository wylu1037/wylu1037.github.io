---
title: Golang
date: 2024-03-11T20:16:50+08:00
weight: 3
---

{{< cards >}}
{{< card link="https://draveness.me/golang/" title="Go 语言设计与实现" subtitle= "Go 语言设计与实现" icon="mdbook" >}}
{{< /cards >}}

## 1.数据结构

### 1.1 数组和切片的区别

| 区别项     | 数组                                     | slice                                                  |
| ---------- | ---------------------------------------- | ------------------------------------------------------ |
| 长度和容量 | 长度固定，创建后不可更改                 | 长度不固定，可以动态改变大小，其容量基于底层数组的大小 |
| 内存分配   | 声明时一次性分配足够的内存               |                                                        |
| 赋值和传递 | 数组赋值或作为函数传递时，会拷贝整个数组 | slice 仅传递切片的结构，不改变指向的底层数组           |
| 扩容       | 不会扩容                                 | 支持扩容                                               |

> 对于数组[3]int，其类型和长度都是维护在类型信息中，不需要像 slice 有一个结构体去维护长度 和 元素类型 信息。因此[2]int 和[3]int 是不同的类型。

slice 结构体如下：

```go
type slice struct {
	array unsafe.Pointer //  存储的是底层数组的指针
	len   int
	cap   int
}
```

当 slice 发生扩容时会发生：

- **新数组分配**：如果当前切片的容量（cap）不足以容纳新增的元素，Go 会创建一个新的更大的底层数组；
- **元素复制**：Go 会将当前切片引用的底层数组中的元素复制到新分配的数组中；
- **指针更新**：切片的指针会更新为新数组的地址，原有的底层数组如果没有其他引用，将会被垃圾回收。

### 1.2 谈一下 rune 类型

先看下 rune 在源码中长什么样子。

```go
// rune is an alias for int32 and is equivalent to int32 in all ways. It is
// used, by convention, to distinguish character values from integer values.
type rune = int32
```

> 翻译下英文： Rune 是 int32 的别名，在所有方面都等同于 int32。按照惯例，它被用来区分字符值和整数值。

rune 主要用来表示一个 Unicode 码点，在 UTF-8 编码规则下可能对应 1~4 个 byte。

```go
func main() {
	func main() {
	var s = "go算法"
	fmt.Println(len(s)) // 长度为 8，g 和 o 分别占用一个长度，算 和 法 分别占用一个长度
    fmt.Println(len([]rune(s))) // 长度为 4，因为rune是把 算 和 法 当成一个字符整体去统计的
	for _, v := range s {
		fmt.Println(v) // 103对应`g`、111对应`o`、31639对应`算`、27861对应`法`
	}
}
```

## 2.语言基础

### 2.1 函数调用时的参数传递是值传递还是引用传递？

go 语言中只有值传递。这意味着当一个函数接受一个参数时，它会接收到原始值的一个副本。

**非引用类型**：int、string、struct 等

```go {hl_lines=[3,8]}
func main() {
	var num int = 8
	fmt.Printf("原始参数地址：%p\n", &num) // 0xc00001c0a8
	printNum(num)
}

func printNum(n int) {
	fmt.Printf("函数接收的参数地址：%p\n", &n) // 0xc00001c0d0
}
```

{{< callout >}}
上述代码演示的是非引用类型的值传递。在调用 printNum 函数时，将实参 8 传递给函数的形参 n 时，是将值 8 拷贝了一份，num 和 n 自己的地址 和 地址指向的值 都是独立的一份。
{{< /callout >}}

**引用类型**：指针、map、slice、chan

```go {hl_lines=[3,8,9]}
func main() {
	var num int = 8
	fmt.Printf("原始参数地址：%p\n", &num) // 0xc00001c0a8
	printNum(&num)
}

func printNum(n *int) {
	fmt.Printf("函数接收的参数地址：%p\n", &n) // 0xc00000a030
	fmt.Println(n) // 0xc00001c0a8
}
```

{{< callout >}}
上述代码演示的是引用类型的值传递。这里调用 printNum 函数时，传递的值是实参 num 的地址，形参因为是一个指针类型，所以 n 接收的值是 num 的地址。因此 n 有自己的地址 `0xc00000a030`，且 n 的值是 `0xc00001c0a8`。`0xc00001c0a8` 指向的是 num 的值 8。
{{< /callout >}}

> 总结来说，Go 语言在形式上是值传递，但对于引用类型，由于传递的是对底层数据结构的引用（或者说指针），在实际效果上类似于某些其他语言中的引用传递。

## 3.关键字

### 3.1 defer

结构体

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
	started bool
	heap    bool
	// openDefer indicates that this _defer is for a frame with open-coded
	// defers. We have only one defer record for the entire frame (which may
	// currently have 0, 1, or more defers active).
	openDefer bool
	sp        uintptr // sp at time of defer
	pc        uintptr // pc at time of defer
	fn        func()  // can be nil for open-coded defers
	_panic    *_panic // panic that is running defer
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

- defer 后面跟的必须是函数或者方法调用，defer 后面的表达式不能加括号；
- 被 defer 的函数或方法的参数的值在定义 defer 语句的时候就被确定下来了；
- 被 defer 的函数或者方法如果存在多级调用，只有最后一个函数或方法会被 defer 到函数 return 或者 panic 之前执行；
- 被 defer 的函数执行顺序满足 LIFO 原则，后 defer 的先执行；
- 被 defer 的函数可以对 defer 语句所在的函数的命名返回值做读取和修改操作；

## 4.并发编程

### 4.1 聊一下 channel

### 4.2 聊一下 context

**Context 的结构体**

```go
// Context's methods may be called by multiple goroutines simultaneously.
type Context interface {
	// Deadline returns the time when work done on behalf of this context
	// should be canceled. Deadline returns ok==false when no deadline is
	// set. Successive calls to Deadline return the same results.
	Deadline() (deadline time.Time, ok bool)

	Done() <-chan struct{}

	// If Done is not yet closed, Err returns nil.
	// If Done is closed, Err returns a non-nil error explaining why:
	// Canceled if the context was canceled
	// or DeadlineExceeded if the context's deadline passed.
	// After Err returns a non-nil error, successive calls to Err return the same error.
	Err() error

	Value(key any) any
}
```

{{< image "/images/docs/interview/go/context-method.png" "Context 方法" >}}

**Context 设计原理**

在 Goroutine 构成的树形结构中对信号进行同步以减少计算资源的浪费是 context.Context 的最大作用。
{{< tabs items="Context与Goroutine树,不使用Context同步信号,使用Context同步信号" >}}
{{< tab >}}
{{< image "/images/docs/interview/go/Context与Goroutine树.png" "Context与Goroutine树" >}}
{{< /tab >}}
{{< tab >}}
{{< image "/images/docs/interview/go/不使用Context同步信号.png" "不使用Context同步信号" >}}
{{< /tab >}}
{{< tab >}}
{{< image "/images/docs/interview/go/使用Context同步信号.png" "使用Context同步信号" >}}
{{< /tab >}}
{{< /tabs >}}

**在 Go 语言中，context.Context 对象设计的目的之一就是在并发环境下进行高效的请求取消通知、超时控制及携带请求级上下文信息。** 之所以需要在多个 goroutine 中传递 context.Context，主要有以下几个原因：

1. 取消通知（Cancellation Signal）： 当请求应该被取消时（比如用户请求取消、超时或者其他高层级逻辑要求停止请求处理），父 goroutine 可以通过调用 context.CancelFunc 取消关联的 context.Context。所有正在执行的依赖于该 context.Context 的 goroutine 可以通过定期检查 ctx.Done()通道来检测取消信号，从而及时终止自己的执行。

2. 资源释放与清理： 通过 context.Context，可以在请求结束时确保所有分配的资源（如数据库连接、网络连接等）都被正确关闭和释放，避免资源泄露。

3. 上下文传递： 在分布式系统或微服务架构中，context.Context 可以携带请求级的上下文信息（如请求 ID、用户认证信息等），这些信息在请求处理过程中，需要跨越多个 goroutine 或服务之间的边界时，通过传递 context.Context 可以保证这些上下文信息的连贯性。

4. 当一个 goroutine 启动了其他 goroutine 进行异步任务时，传递 context.Context 可以将顶层请求的控制信号传递到所有子 goroutine 中，从而实现细粒度的控制，确保整个请求生命周期的行为一致性。

因此，context.Context 通过在多个 goroutine 之间传递，可以实现 **请求的上下文传播**、**取消控制** 以及 **资源管理的同步**，增强了 Go 语言在并发和分布式系统中的健壮性和可控制性。

**针对跨服务的调用传递 context 是如何实现的**

```go {hl_lines=[3,11]}
func (l *GetUserInfoLogic) GetUserInfo(req *types.UserInfoReq) (resp *types.UserInfoResp, err error) {
	d := new(depositservice.DepositRequest)
	context := metadata.NewOutgoingContext(l.ctx, metadata.Pairs("user", url.QueryEscape("葫芦娃")))
	deposit, err := l.svcCtx.DepositServiceRpc.Deposit(context, d)
	fmt.Println(deposit)
	return nil, errors.New("中国人")
}

func (s *DepositServiceServer) Deposit(ctx context.Context, in *mock.DepositRequest) (*mock.DepositResponse, error) {
	a, b := logic.NewAwsMsgLogic(ctx, s.svcCtx).GetById("0001e67c-a610-4a73-9404-9ca223e67cc5")
	md, ok := metadata.FromIncomingContext(ctx)
	if ok {
		fmt.Println(url.QueryUnescape(md["user"][0]))
	}

	fmt.Println(a, b)
	return &mock.DepositResponse{}, nil
}
```

## 5.内存管理

## 6.元编程

### 6.1 聊一聊结构体标记（结构体注释）

是一种对 Go 结构体中的字段进行元数据附加的机制，在编译时被解析并保留在编译后的结构体元数据中。这些标记是用反引号(`)包裹起来的键值对，可以在 **运行时** 通过反射机制获取并处理。

{{< callout >}}
结构体元数据 会在编译时嵌入到可执行文件中，并不会存储在内存中的数据段。

在计算机系统中，当用户启动一个可执行文件时，操作系统会负责将可执行文件从非易失性存储介质（如硬盘）加载到内存中。这个过程被称为程序加载或者进程映射
{{< /callout >}}

```go
type User struct {
    Name  string `json:"name"`
    Email string `json:"email" bson:"email,omitempty"`
}

field := reflect.TypeOf(User{}).Field(0)
tag := field.Tag.Get("json") // 获取json tag的值
```

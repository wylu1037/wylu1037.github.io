---
title: closure
date: 2024-03-15T08:04:28+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

函数是头等对象，可以做参数传递，可以做函数返回值，也可以绑定到变量。这样的参数、返回值或变量为 `function value`。

function value 本质上是一个指针，不直接指向函数指令入口，而是指向一个 `runtime.funcval` 结构体。
```go
type funcval struct {
    fn uintptr // 函数指令的入口地址
}
```

```go {hl_lines=[2]}
func create() func() int {
    c := 2 // c 是闭包的捕获变量
    return func() int {
        return c
    }
}

func main() {
    f1 := create()
    f2 := create()
    fmt.Println(f1())
    fmt.Println(f1())
}
```
闭包导致的局部变量堆分配1

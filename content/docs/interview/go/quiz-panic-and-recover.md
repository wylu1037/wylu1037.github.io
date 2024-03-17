---
title: "Quiz Panic and Recover"
date: 2024-03-15T08:05:02+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## panic
```go
// A _panic holds information about an active panic.
//
// A _panic value must only ever live on the stack.
//
// The argp and link fields are stack pointers, but don't need special
// handling during stack growth: because they are pointer-typed and
// _panic values only live on the stack, regular stack pointer
// adjustment takes care of them.
type _panic struct {
  // defer 的参数空间地址
	argp      unsafe.Pointer // pointer to arguments of deferred call run during panic; cannot move - known to liblink
	// panic 的参数
  arg       any            // argument to panic
	link      *_panic        // link to earlier panic
	pc        uintptr        // where to return to in runtime if this panic is bypassed
	sp        unsafe.Pointer // where to return to in runtime if this panic is bypassed
	recovered bool           // whether this panic is over
	aborted   bool           // the panic was aborted
	goexit    bool
}
```

## recover
recover 只做一件事，把当前执行的 panic 置为已恢复，即把 recovered 字段值置为 true，移除并跳出当前 panic。
```go
fucn A() {
  defer A1()
  defer A2()
  // ......
  panic("panicA")
  // ......
}

func A2() {
  p := recover()
  fmt.Println(p)
}
```

recover 后会保存_defer.sp、_defer.pc。
sp 和 pc 是注册 defer 函数时保存的
```go
func A() {
  r = runtime.deferproc(0, A1)
  if r > 0 {
    goto ret
  }

  r = runtime.deferproc(0, A2)
  if r > 0 {
    goto ret
  }
  // code to do something

  ret:
    runtime.deferreturn()
}
```
sp 是函数 A 的栈指针
pc 是调用 deferproc 函数的返回地址

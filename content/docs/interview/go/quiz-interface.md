---
title: Quiz Interface
date: 2024-03-15T08:06:08+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

interface{} 可以接收任意类型的数据

## 1.eface vs iface

### 1.1 eface

{{< callout >}}

- 不包含任何方法的 interface{} 类型在底层其实就是 eface 结构体
- 由于 interface{} 类型不包含任何方法，所以它的结构也相对来说比较简单，只包含指向底层数据和类型的两个指针
- 任意的类型都可以转换成 interface{} 类型。

{{< /callout >}}

```go
type eface struct {
	_type *_type //指向接口的动态类型元数据
	data  unsafe.Pointer //指向接口的动态值
}
```

### 1.2 iface

- 另一个用于表示接口 interface 类型的结构体是 iface
- 在这个结构体中也有指向原始数据的指针 data
- 在这个结构体中更重要的其实是 itab 类型的 tab 字段
  - itab 结构体是接口类型的核心组成部分，每一个 itab 都占 32 字节的空间。

```go
type iface struct {
	tab  *itab//指向itab结构体
	data unsafe.Pointer //指向接口的动态值 即给该接口变量赋了一个值，data存储该值所在的内存地址
}

type itab struct {
	inter *interfacetype //接口本身的类型元数据地址
	_type *_type //实现该接口的动态类型的元数据地址
	hash  uint32 //是对 _type.hash 的拷贝，它会在从interface到具体类型的切换时用于快速判断目标类型和接口中类型是否一致
	_     [4]byte
	fun   [1]uintptr // 动态类型实现的接口的方法地址
}

type interfacetype struct {
	typ     _type
	pkgpath name //表示接口类型被定义在哪个包中
	mhdr    []imethod //接口声明的方法列表
}

type imethod struct {
	name nameOff //方法名的偏移
	ityp typeOff //类型元数据的偏移，以ityp为起点，可以找到方法的参数列表、返回值列表以及每个参数的类型信息
}
```

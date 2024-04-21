---
title: 切片
date: 2024-03-15T08:02:46+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 2
---

## 动态数组

{{< image "/images/docs/interview/go/slice-struct.png" "切片结构" >}}

## 数据结构

```go
type slice struct {
	array unsafe.Pointer
	len   int
	cap   int
}
```

## 面试题

### slice 是如何扩容的？

切片扩容的具体策略如下：
{{< steps >}}

<h5></h5>

如果切片当前容量小于 <font style="font-weight:bold;font-style:italic;">1024</font>（或在 Go 1.18 及更高版本中是 256），扩容时会将容量翻倍，即新容量等于原容量的 <font style="font-weight:bold;font-style:italic;">2</font> 倍；

<h5></h5>

当切片当前容量大于等于 <font style="font-weight:bold;font-style:italic;">1024</font>s（或在 Go 1.18 及更高版本中为 256），扩容时会将容量增大大约 <font style="font-weight:bold;font-style:italic;">25%</font>；

{{< /steps >}}

### slice 的内存分配？

切片（slice）的内存分配涉及到底层数组的分配和切片结构本身的创建。
{{< callout >}}
**底层数组的内存分配：**

{{< /callout >}}

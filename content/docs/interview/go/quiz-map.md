---
title: map
date: 2024-03-15T08:04:15+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 4
---
## 1.数据结构
`runtime.hmap` 是最核心的结构体，先了解一下该结构体的内部字段：
```go {hl_lines=[9]}
type hmap struct {
	count     int // 记录已经存储的键值对数目
	flags     uint8
	B         uint8
	noverflow uint16
	hash0     uint32

	buckets    unsafe.Pointer
	oldbuckets unsafe.Pointer // 扩容时记录旧桶的位置
	nevacuate  uintptr // 记录下一个要迁移的旧桶编号

	extra *mapextra
}

type mapextra struct {
	overflow    *[]*bmap // 已经使用的溢出桶
	oldoverflow *[]*bmap  // 扩容阶段旧桶使用到的溢出桶
	nextOverflow *bmap // 下一个空闲溢出桶
}
```
{{< callout >}}
+ count 表示当前哈希表中的元素数量；
+ B 表示当前哈希表持有的 buckets 数量，但是因为哈希表中桶的数量都 2 的倍数，所以该字段会存储对数，也就是 len(buckets) == 2^B；
+ hash0 是哈希的种子，它能为哈希函数的结果引入随机性，这个值在创建哈希表时确定，并在调用哈希函数时作为参数传入；
+ oldbuckets 是哈希在扩容时用于保存之前 buckets 的字段，它的大小是当前 buckets 的一半；
{{< /callout >}}
{{< image "/images/docs/interview/go/hmap-and-buckets.png" "哈希表的数据结构" >}}

哈希表 runtime.hmap 的桶是 runtime.bmap。每一个 runtime.bmap 都能存储 8 个键值对，当哈希表中存储的数据过多，单个桶已经装满时就会使用 extra.nextOverflow 中桶存储溢出的数据。

上述两种不同的桶在内存中是连续存储的，在这里将它们分别称为正常桶和溢出桶，上图中黄色的 runtime.bmap 就是正常桶，绿色的 runtime.bmap 是溢出桶，溢出桶是在 Go 语言还使用 C 语言实现时使用的设计3，由于它能够减少扩容的频率所以一直使用至今。

桶的结构体 runtime.bmap 在 Go 语言源代码中的定义只包含一个简单的 tophash 字段，tophash 存储了键的哈希的高 8 位，通过比较不同键的哈希的高 8 位可以减少访问键值对次数以提高性能：
```go
type bmap struct {
	tophash [bucketCnt]uint8
}
```
## 2.哈希函数
{{< image "/images/docs/interview/go/perfect-hash-function.png" "完美哈希函数" >}}

{{< image "/images/docs/interview/go/bad-hash-function.png" "不均匀哈希函数" >}}


## 3.哈希冲突
### 3.1 开放地址法
如果发生了冲突，就会将键值对写入到下一个索引不为空的位置：
{{< image "/images/docs/interview/go/open-addressing-and-set.png" "开放地址法写入数据" >}}
{{< image "/images/docs/interview/go/open-addressing-and-get.png" "开放地址法读取数据" >}}

### 3.2 拉链法
与开放地址法相比，拉链法是哈希表最常见的实现方法，大多数的编程语言都用拉链法实现哈希表，它的实现比较开放地址法稍微复杂一些，但是平均查找的长度也比较短，各个用于存储节点的内存都是动态申请的，可以节省比较多的存储空间。

实现拉链法一般会使用数组加上链表，不过一些编程语言会在拉链法的哈希中引入红黑树以优化性能，拉链法会使用链表数组作为哈希底层的数据结构：
{{< image "/images/docs/interview/go/separate-chaing-and-set.png" "拉链法写入数据" >}}
{{< image "/images/docs/interview/go/separate-chaing-and-get.png" "拉链法读取数据" >}}

## 4.扩容
负载因子 := 存储键值对的数目 ÷ 桶数目


{{< image "/images/docs/interview/go/hashmap-hashgrow.png" "哈希表触发扩容" >}}


{{< image "/images/docs/interview/go/hashmap-evacuate-destination.png" "哈希表扩容目的" >}}


{{< image "/images/docs/interview/go/hashmap-bucket-evacuate.png" "哈希表桶数据的分流" >}}

### 4.1 渐进式扩容

---
title: Quiz String
date: 2024-03-15T08:02:25+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## 1.如何存储字符
计算机只能识别二进制码，对于十进制数字可以转成二进制数字存储。保存字符串则需要使用到 **字符集**，字符集是所有字符编号组成的总和。

### 1.1 字符集
|字符集|全称|中文|位数|字符数|缺陷|
|---|---|--|---|---|---|
|ASCII| American Standard Code for Information Interchange|美国信息交换标准代码|7 bit|128 个字符|没有涵盖西文字母之外的字符|
|ASCII| American Standard Code for Information Interchange|美国信息交换标准代码|8 bit|256 个字符|没有涵盖西文字母之外的字符|
|GBK||||||
|Unicode|Universal Multiple-ctet Coded Character Set|统一字符编码标准||60000|

> 字符统一成Unicode编码，乱码问题从此消失了。 但是Unicode只是一个字符集。字符集只是给所有的字符一个唯一编号，但是却没有规定如何存储`。 Unicode最常用的是用两个字节表示一个字符，如果你写的文本基本上全部是英文的话，用Unicode编码比ASCII编码需要多一倍的存储空间，在存储和传输上就十分不划算。所以又引入了 字符编码。

### 1.2 字符编码

{{< callout >}}
**Unicode和UTF-8之间有啥关系？**

UTF（Unicode Transformation Format）可译成Unicode格式转换，即怎样把Unicode对应的数字转换成程序数据。
{{< /callout >}}

Unicode 和 Ascii 是字符集。UTF-8、UTF-16、UTF-32 等是编码规则。 可以通过编码规则将字符集的字符表示成程序中的数据。
```shell
例如：“汉字” 对应不同编码的程序数据是：
char      data_utf8[]  =  {0xE6,0xB1,0x89,0xE5,0xAD,0x97};    //UTF-8编码
char16_t data_utf16[]  =  {0x6C49,0x5B57};                    //UTF-16编码
char32_t data_utf32[]  =  {0x00006C49,0x00005B57};            //UTF-32编码
```

#### UTF-8
UTF-8 是一套以8位为一个编码单位的 {{< font "blue" "可变长编码" >}}。比如： 一个编号为65的字符，只需要一个字节就可以存下，但是编号40657的字符需要两个字节的空间才可以装下，而更靠后的字符可能会需要三个甚至四个字节的空间。
```shell
Unicode编码　          UTF-8字节流
U+ 0000 ~ U+ 007F:    0XXXXXXX
U+ 0080 ~ U+ 07FF:    110XXXXX 10XXXXXX
U+ 0800 ~ U+ FFFF:    1110XXXX 10XXXXXX 10XXXXXX
U+10000 ~ U+1FFFF:    11110XXX 10XXXXXX 10XXXXXX 10XXXXXX
```

将 Unicode 按照 UTF-8 编码为字节序列
```shell
汉字：                      知
Unicode码：                 30693
Unicode码的十六进制表示为：   0x77E5

根据utf-8的上表中的编码规则,「知」字的码位U+77E5属于第三行的范围:所以需要3个字节(byte)

       7    7    E    5    
    0111 0111 1110 0101    77E5对应的二进制的 
--------------------------
1110XXXX 10XXXXXX 10XXXXXX 模版（由77E5范围,取上表第三行）
    0111   011111   100101 根据模板格式调整77E5二进制的结构
11100111 10011111 10100101 代入模版
   E   7    9   F    A   5 转化回16进制
   
这就是将 U+77E5 按照 UTF-8 编码为字节序列 E79FA5 的过程。反之亦然。
```
## 2.源码
```go {filename="runtime/string.go"}
type stringStruct struct {
	str unsafe.Pointer // 指向一个 [len]byte 的数组
	len int // 长度
}
```

## 3.常用函数

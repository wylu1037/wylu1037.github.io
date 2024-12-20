---
title: Linux 筛选日志
date: 2024-09-14T08:30:01+08:00
categories: [linux]
tags: [linux, log]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
description: Linux filter log
---

## tail

+ `tail -n 10 test.log`：查询日志尾部最后的10行日志；
+ `tail -n +10 test.log`：查询10行之后的所有日志；



## head

+ `head -n 10 test.log`：查询日志文件中的头10行日志；
+ `head -n -10 test.log`：查询日志文件除了最后10行的其它日志；



## cat

**作用**：匹配符合筛选条件的日志，并显示行号

**命令**：

```shell
cat -n businessserver-deployment-57845d757-74kng.info.log | grep '支付下单'
```



### 练习

**场景**：根据匹配到的行号，查询指定行号之后的所有日志

**命令**：

```shell
tail +n 行号 日志文件名
```



**场景**：根据匹配到的行号，查询指定行号前后的日志

**命令**：

```shell

```





**场景**：查询92行之后的日志，在之前的筛选结果基础上再查询前20条记录。

**命令**：

```shell
cat -n test.log | tail -n +92 | head -n 20
```



## grep

### 语法
```shell
grep [选项] 模式 文件
```

### 选项：
+ `-i`：忽略大小写差异。
+ `-v`：反转匹配，即显示不匹配模式的行。
+ `-n`：显示匹配行的行号。
+ `-l`：仅列出包含匹配项的文件名，不显示具体的行。
+ `-r`：递归搜索目录中的所有文件。
+ `-A num`：显示匹配行{{< font "blue" "之后" >}}的 num 行。
+ `-B num`：显示匹配行{{< font "blue" "之前" >}}的 num 行。
+ `-C num`：显示匹配行{{< font "blue" "前后" >}}各 num 行。
+ `--color`：高亮显示匹配的部分。
+ `-E`：启用扩展正则表达式。
+ `-f file`：从文件中读取模式。
+ `-h`：处理多个文件时不打印文件名




### 示例

```bash
grep -C 10 '2' ***.log

# 打印匹配内容的前后5行
grep -5
```



## more

**参数说明**：

- `Enter`：向下n行，需要自定义，默认一行；
- `Space`：向下滚动一屏；
- `Ctrl + B`：返回上一屏；
- `=`：输出当前行的行号；
- `V`：调用vi编辑器，支持vi中的关键字定位操作；
  - `Esc` + `:` + `q`：不保存修改内容退出vi模式；
  - `Esc` + `:` + `wq`：保存写入内容退出vi模式；
  - `/`：输入查找内容进行搜索；
- `!`：调用shell，并执行命令；
- `q`：退出more；








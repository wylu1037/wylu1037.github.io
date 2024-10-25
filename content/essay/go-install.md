---
title: 安装go
date: 2024-08-29T14:16:25+08:00
categories: [go]
tags: [go,install]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## 1 下载
[官网](https://go.dev/doc/install)

```shell
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
```

## 2 配置
移除之前的安装版本
```shell
 rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
```
添加环境

```shell
vim /etc/profile
# or
vim $HOME/.profile

export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
```

```shell
source /etc/profile
# or
source $HOME/.profile
```

查看版本
```shell
go version
```

设置代理
```shell
go env -w GOPROXY=https://goproxy.cn,direct
```

## 3 go版本管理器
[gvm](https://github.com/moovweb/gvm)
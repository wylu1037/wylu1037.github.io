---
title: Nacos
date: 2022-03-21 12:35:48
tags:
  - Nacos
  - Spring Boot
  - Spring Cloud
categories:
  - Spring Cloud
  - Micro Service
cover: https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRifrdSe-oyWZb0aRK10r_gyhMP3BKQTmAUDA&usqp=CAU 
---

## 1.前言

:::tip

官方文档：https://nacos.io/zh-cn/docs/what-is-nacos.html

:::

Nacos 致力于发现、配置和管理微服务。Nacos 提供了一组简单易用的特性集，可快速实现动态服务发现、服务配置、服务元数据及流量管理。

Nacos 帮助您更敏捷和容易地构建、交付和管理微服务平台。 Nacos 是构建以“服务”为中心的现代应用架构 (例如微服务范式、云原生范式) 的服务基础设施。



### 1.1 下载

***Windows***: [点我开始下载](https://github.com/alibaba/nacos/releases)，`nacos-server-$version.zip` 包。

解压后，文件目录如下：

```
.
|--bin
|	|--logs
|	|--work
|	|--shutdown.cmd
|	|--shutdosn.sh
|	|--startup.cmd
|	└--startup.sh
|--conf
|--data
|--logs
|--target
|--LICENSE
└--NOTICE
```

编辑 `startup.cmd`，修改配置项 MODE 值：

```bash
# before
set MODE="cluster"

# after
set MODE="standalone"
```

运行如下命令：

```bash
cmd startup.cmd -m standalone
```

启动成功后访问服务端页面：http://localhost:8848/nacos



---

## 2.Nacos Spring Boot







---

## 3.Nacos Spring Cloud







---

## 4.Nacos Docker







---

## 5.Nacos k8s







---

## 6.Nacos Sync







---

## 7.运维指南

:::tip

文档：https://nacos.io/zh-cn/docs/deployment.html

:::

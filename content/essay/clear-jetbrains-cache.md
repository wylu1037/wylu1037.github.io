---
title: 清理Jetbrains安装的软件缓存
date: 2024-02-28T12:28:17+08:00
categories: [jetbrains]
tags: [jetbrains, ide]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
description: icons preview
excludeSearch: true
---

<font style="font-style:italic;font-weight:bold;">Jetbrains</font> 的缓存目录分为两类：配置文件目录和临时文件目录。配置文件目录保存诸如快捷键、颜色主题、30天试用授权证书、自定义 jbr 运行时参数等等的 ide 用户配置信息，所以不能随意删除。删除后会重置程序初始安装状态。。临时文件目录可以随意删除，其中包含缓存、本地文件修改修改、用于工程加速的 index 文件，这些文件的用途在于优化 ide 的速度，删除后ide 会根据需要重建的。


{{< tabs items="配置文件, 临时文件">}}
  {{< tab >}}
    以 `产品名年份.版本号` 格式来命名配置文件目录。如 GoLand 2023.3 的配置文件目录名称为 <font style="font-weight:bold;color:#fe5e2c;font-style:italic;">GoLand2023.3</font>。
    不同操作系统平台，目录如下所示：
    {{< icon name="windows" >}}
    {{< icon name="apple" >}}
    |OS|Directory|
    |---|---|
    |Windows|<font style="font-weight:bold;color:#fe5e2c;font-style:italic;">%userprofile/AppData/Roaming/Jetbrains</font>|
    |Mac|<font style="font-weight:bold;color:#fe5e2c;font-style:italic;">~/Library/Application Support/Jetbrains</font>|

  {{< /tab >}}

  {{< tab >}}
    与配置文件目录类似。目录如下所示：
    {{< icon name="windows" >}}
    {{< icon name="apple" >}}
    |OS|Directory|
    |---|---|
    |Windows|<font style="font-weight:bold;color:#fe5e2c;font-style:italic;">%userprofile/AppData/Local/Jetbrains</font>|
    |Mac|<font style="font-weight:bold;color:#fe5e2c;font-style:italic;">~/Library/Caches/Jetbrains</font>|
  {{< /tab >}}
{{< /tabs >}}


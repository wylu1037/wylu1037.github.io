---
title: 配置npm和yarn镜像
date: 2024-03-03T16:26:56+08:00
categories: [npm-yarn]
tags: [yarn, npm]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

{{< tabs items="🎉 npm, 🎊 yarn">}}
  {{< tab >}}
    {{< font type="orange" text="1.查看所有配置：" >}}

    ```shell
    npm config list --json
    ```
    {{< font type="yellow" text="2.查看 registry：" >}}

    ```shell
    npm config get registry
    # https://registry.npmjs.org/
    ```
    {{< font type="blue" text="3.配置 registry：" >}}

    ```shell
    # 淘宝镜像源
    npm config set registry https://registry.npmmirror.com
    ```

  {{< /tab >}}

  {{< tab >}}
    {{< font type="orange" text="1.查看所有配置：" >}}

    ```shell
    yarn config list --json
    ```
    {{< font type="yellow" text="2.查看 registry：" >}}

    ```shell
    yarn config get registry
    # https://registry.yarnpkg.com
    ```
    {{< font type="blue" text="3.配置 registry：" >}}

    ```shell
    # 淘宝镜像源
    yarn config set registry https://registry.npmmirror.com
    ```

    {{< font type="blue" text="4.yarn镜像管理工具 yrm：" >}}

    ```shell
    yarn global add yrm

    yrm ls

    npm ---------- https://registry.npmjs.org/
    * yarn --------- https://registry.yarnpkg.com/
    tencent ------ https://mirrors.cloud.tencent.com/npm/
    cnpm --------- https://r.cnpmjs.org/
    taobao ------- https://registry.nlark.com/
    npmMirror ---- https://skimdb.npmjs.com/registry/

    yrm use taobao
    ```
  {{< /tab >}}
{{< /tabs >}}

---
title: Git配置
date: 2024-03-06T14:49:17+08:00
tags: [git, github, gitlab, SSH Keys]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
description: 
---

## 多git仓库配置
``` {filename=".ssh/config"}
Host github.com
HostName github.com
User yourname@gmail.com
IdentityFile ~/.ssh/id_ed25519_github

Host gitee.com
HostName gitee.com
User yourname@qq.com
IdentityFile ~/.ssh/id_ed25519_gitee

Host gitlab.com
HostName gitlab.com
User yourname@gmail.com@qq.com
IdentityFile ~/.ssh/id_ed25519_gitlab
```
{{< tabs items="Github, Gitlab">}}
  {{< tab >}}
{{% steps %}}

### 生成ssh key

密钥类型使用 `ED25519`，其它类型包括 `RSA`、`ECDSA_SK`、`ED25519_SK`等等。
```shell
ssh-keygen -t ed25519 -C "<comment>"
```

### 添加到 `~/.ssh/config` 中

```
Host github.com
HostName github.com
User yourname@gmail.com
IdentityFile ~/.ssh/id_ed25519_github
```

### github绑定id_ed25519_github.pub

### 验证

```shell
ssh -T git@github.com
```

{{% /steps %}}
  {{< /tab >}}

  {{< tab >}}
{{% steps %}}

### 生成ssh key

```shell
# ED25519
ssh-keygen -t ed25519 -C "<comment>"

# 2048 位 RSA
ssh-keygen -t rsa -b 2048 -C "<comment>"
```

### 添加到 `~/.ssh/config` 中

```
Host gitlab.com
HostName gitlab.com
User yourname@gmail.com@qq.com
IdentityFile ~/.ssh/id_ed25519_gitlab
```

### gitlab绑定id_ed25519_gitlab.pub

### 验证

```shell
ssh -T git@gitlab.com
```

{{% /steps %}}
  {{< /tab >}}
{{< /tabs >}}

## 配置git的name和email

{{< tabs items="🌍 全局, 🏠 特定仓库">}}
  {{< tab >}}
    查看
    ```shell
    git config --global user.name
    git config --global user.email
    ```
    配置
    ```shell
    git config --global user.name "你的用户名"
    git config --global user.email "你的邮箱地址"
    ```
  {{< /tab >}}

  {{< tab >}}
    为特定的Git仓库设置不同的用户名和电子邮件地址，可以在当前仓库目录下运行命令。

    设置
    ```shell
    git config user.name "其他用户名"
    git config user.email "其他邮箱地址"
    ```
    > 这会在当前仓库的配置文件 `.git/config` 中设置用户名和电子邮件地址，只会影响到该仓库的提交。
  {{< /tab >}}
{{< /tabs >}}

---
title: Git中合并与变基的区别
date: 2024-09-19T10:43:38+08:00
categories: [git]
tags: [git, merge, rebase]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
description: 
---

{{< image "/images/essay/git-checkout-branch-from-master.png" "从 master 拉取一个 feature 分支" >}}

{{< image "/images/essay/git-multiple-branch-conflict.png" "分支冲突" >}}

在 `feature` 分支进行了两次提交，此时其它人也进行了两次提交，并且合并到了 `master` 分支，此时是无法push到远程仓库的，需要进行分支合并。

## Merge
将两个分支合并，将分支的历史记录合并在一起。并创建一个新的合并提交 {{< font "blue" "merge commit" >}}。

{{< image "/images/essay/git-merge.png" "git merge" >}}

## Rebase
将一个分支上的提交应用到另一个分支的基础上，重新排列提交历史。不会创建新的合并提交，而是将提交重新放置，使分支历史看起来像是线性的一条直线。

{{< image "/images/essay/git-rebase.png" "git rebase" >}}

**示例**
> 将 `develop` 分支的最新变更应用到 `release` 分支上。
```shell
# 切换到 release 分支上
git rebase develop
# Successfully rebased and updated refs/heads/release.
```
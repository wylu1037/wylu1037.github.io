---
title: 使用 Docker Compose 部署 Airflow
date: 2025-12-09T09:35:00+08:00
categories: [airflow]
tags: [airflow, docker, deploy]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

本教程基于 Apache Airflow 官方文档，介绍如何使用 Docker Compose 快速部署 Airflow 环境。该环境主要用于测试和开发目的。

## 1. 前置准备

在开始之前，请确保已经安装了以下工具：

- **Docker Community Edition (CE)**: 确保 Docker 引擎已运行。
  - 内存配置注意：Docker 至少需要分配 4GB 内存（建议 8GB），否则 Webserver 可能会不断重启。
- **Docker Compose**: v2.14.0 或更高版本。

## 2. 获取 docker-compose.yaml

创建一个部署目录，并下载官方提供的 `docker-compose.yaml` 文件。

```shell
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/3.1.3/docker-compose.yaml'
```

> **注意**: 如果你需要特定版本的 Airflow，请修改 URL 中的版本号。该文件定义了以下服务：
>
> - `airflow-scheduler`: 调度器
> - `airflow-webserver`: 网页服务 (端口 8080)
> - `airflow-worker`: 执行任务的 worker
> - `airflow-triggerer`: 用于 deferrable 任务
> - `airflow-init`: 初始化服务
> - `postgres`: 数据库
> - `redis`: 消息代理

## 3. 初始化环境

### 3.1 创建必须的目录

Airflow 需要一些本地目录映射到容器中：

```shell
mkdir -p ./dags ./logs ./plugins ./config
```

### 3.2 配置用户 ID (Linux 用户必须)

在 Linux 上，需要设置 `AIRFLOW_UID` 环境变量，以避免权限问题。MacOS 和 Windows 用户可以跳过此步或为了消除警告也设置它。

```shell
echo -e "AIRFLOW_UID=$(id -u)" > .env
```

### 3.3 初始化数据库和用户

运行初始化容器来执行数据库迁移并创建默认用户：

```shell
docker compose up airflow-init
```

等待命令执行完成，直到看到类似 `airflow-init-1 exited with code 0` 的输出。
此过程会创建一个默认的管理员账号：

- **Username**: `airflow`
- **Password**: `airflow`

## 4. 启动 Airflow

初始化完成后，启动所有服务：

```shell
docker compose up -d
```

使用 `docker ps` 检查容器状态，确保所有容器都处于 `healthy` 状态。

## 5. 访问 Airflow

所有服务启动后，可以通过以下方式访问：

- **Web 界面**: 访问 [http://localhost:8080](http://localhost:8080)。
  - 登录账号密码均为 `airflow`。
- **CLI**: 可以通过 `docker compose run` 执行 Airflow 命令。

```shell
docker compose run airflow-worker airflow info
```

## 6. 使用 Helper 脚本 (可选)

为了更方便地运行 Airflow 命令，可以下载官方提供的 wrapper 脚本：

```shell
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/3.1.3/airflow.sh'
chmod +x airflow.sh
```

现在可以使用更简短的命令：

```shell
./airflow.sh info
./airflow.sh bash  # 进入容器 shell
./airflow.sh python # 进入 python shell
```

## 7. 清理环境

如果需要彻底清理环境（包括数据卷）：

```shell
docker compose down --volumes --remove-orphans
```

该命令会停止容器并删除所有相关的数据卷，数据库中的数据将会丢失。

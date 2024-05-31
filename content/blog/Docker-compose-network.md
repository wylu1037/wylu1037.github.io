---
title: docker-compose 网络
date: 2024-02-27T10:47:42+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## Default network

默认情况下，**_Compose_** 会创建一个网络，服务的每个容器都会加入该网络中，这样容器就可被网络中的其它容器访问。容器还能以服务名称作为`hostname`被其它容器访问。

​ 应用程序的网络名称基于 **_Compose_** 的工程名称，而项目名称基于`docker-compose.yml`所在目录名称。如需修改工程名称，可使用 `--project-name` 标识或 `COMPOSE_PORJECT_NAME` 环境变量。

```yaml {filename="docker-compose.yml"}
# 位于software目录下
version: "2"
services:
  web:
    build: .
    ports:
      - "8000:8000"
  db:
    image: postgres
```

当执行`docker-compose up`指令时，将会分为一下几步：

- 创建一个名为`software_default`的网络；
- 使用 **_web_** 服务的配置创建容器，并以*web*名称加入上述创建的网络；
- 使用 **_db_** 服务的配置创建容器，并以*db*名称加入网络；

> 容器间可以使用服务名称（**_web_** 或 **_db_**）作为 hostname 互相访问。例：**_web_** 服务可通过 `postgres://db:5432`访问 **_db_** 容器。

## Custom network

一些场景下，默认的网络配置无法满足使用需求，可通过 `networks` 命令自定义网络。还可以使用 `networks` 将服务连接到不是由 **_Compose_** 管理的、外部创建的网络。

```yaml {filename="docker-compose.yml"}
version: "2"

services:
  proxy:
    build: ./proxy
    networks:
      - front
  app:
    build: ./app
    networks:
      - front
      - back
  db:
    image: postgres
    networks:
      - back

networks:
  front:
    # Use a custom driver
    driver: custom-driver-1
  back:
    # Use a custom driver which takes special options
    driver: custom-driver-2
    driver_opts:
      foo: "1"
      bar: "2"
```

其中，**_proxy_** 服务与 **_db_** 服务隔离，两者分别使用自己的网络，**_app_** 服务可与两者通信。使用`networks`命令，即可方便实现服务间的网络隔离与连接。

## 配置默认网络

```yaml {filename="docker-compose.yml,hl_lines=[1,2]"}
version: "2"

services:
  web:
    build: .
    ports:
      - "8000:8000"
  db:
    image: postgres

networks:
  default:
    # Use a custom driver
    driver: custom-driver-1
```

### links

服务之间可以使用服务名称互相访问。_**links**_ 允许定义一个别名，从而使用该别名访问服务。

```yaml {filename="docker-compose.yml"}
version: "2"
services:
  web:
    build: .
    links:
      - "db:database"
  db:
    image: postgres
```

> web 服务可以使用 db 或 database(alias)作为 hostname 访问 db 服务。

## network_mode
### bridge（默认模式）

这是 Docker 的默认网络模式。每个容器在 Docker 内部的桥接网络上运行，并通过 NAT 访问外部网络。

```yaml
version: '2'
services:
  node-manager-web:
    image: harborbaas.zkjg.com:4443/baas/web:latest
    user: root
    network_mode: bridge
    ports:
      - "3000:80"
    volumes:
      - $PWD/web/nginx.conf:/etc/nginx/nginx.conf
```

### host

容器将与主机共享网络栈。这种模式适用于需要高性能或需要直接访问主机网络的场景。

```yaml
version: '2'
services:
  node-manager-web:
    image: harborbaas.zkjg.com:4443/baas/web:latest
    user: root
    network_mode: host
    volumes:
      - $PWD/web/nginx.conf:/etc/nginx/nginx.conf
```

### none
容器将没有任何网络连接。这种模式适用于不需要网络连接的容器。

### container:<name|id>
容器将与指定的另一个容器共享网络栈。两个容器之间可以直接通信。

```yaml
version: '2'
services:
  node-manager-web:
    image: harborbaas.zkjg.com:4443/baas/web:latest
    user: root
    network_mode: "container:another_container"
    volumes:
      - $PWD/web/nginx.conf:/etc/nginx/nginx.conf
```

### 自定义网络名称
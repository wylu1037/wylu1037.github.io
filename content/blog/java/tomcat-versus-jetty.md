---
title: Tomcat vs Jetty
date: 2024-03-30T21:27:08+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## Tomcat

- 适合处理少数非常繁忙的链接，当链接生命周期非常短的话 tomcat 的总体性能较高。
- 默认采用 BIO 处理 I/O 请求，在处理静态资源时，性能较差。
- 架构是基于容器设计的，进行扩展需要了解 tomcat 的整体设计结构，不易扩展。

```yaml
server:
  tomcat:
    threads:
      min-spare: 10 # 最少的工作线程数，默认值10
      max: 200 # 最多的工作线程数，默认200，决定了web容器可以同时处理多少个请求
    max-connections: 8192 # 最大连接数，默认8192
    accept-count: 100 # 最大等待数
```

{{< callout >}}
`server.tomcat.threads.min-spare`: 设定 **Tomcat** 工作线程池中的最小空闲线程数，即即使这些线程没有正在处理请求，也会保持在池中待命，以便快速响应新的请求。默认值是 **_10_**。

`server.tomcat.threads.max`: 设定 **Tomcat** 工作线程池中的最大线程数，也就是 Tomcat 能够同时处理请求的最大并发数。一旦达到这个数值，新的请求就需要等待线程池中有线程释放出来。默认值是 200。

`server.tomcat.max-connections`: 设定 **Tomcat** 服务器在任何时候可以接受并保持的最大的并发连接数。超过这个数目时，新的连接请求将被拒绝或放入等待队列（如果 **_accept-count_** 设置有效的话）。默认值是 **_8192_**。

`server.tomcat.accept-count`: 当所有工作线程都在忙碌，并且 **_max-connections_** 已经达到上限时，还可以有多少个等待连接的请求排队。超过这个数目，新的连接请求将被服务器直接拒绝。默认值根据 **Tomcat** 版本不同可能有所变化，此处设置为 **_100_**。
{{< /callout >}}

## Jetty

- 架构是基于 **_Handler_** 来实现的，主要的功能都可以用 **_Handler_** 来实现，扩展简单；
- 可以同时处理大量连接而且可以长时间保持连接，适合于 **web** 聊天应用；
- 架构简单，因此作为服务器，jetty 可以按需加载组件，减少不需要的组件，减少了服务器的内存开销，从而提高服务器性能；
- 默认采用 **_NIO_** 结束在处理 I/O 请求上更占优势，在处理静态资源时，性能较高。

```yaml
server:
  jetty:
    acceptors: 2 # Jetty的接受器线程数
    selectors: 4 # Jetty的Selector线程数（仅在NIO Connector中适用）
    threadPool:
      minThreads: 10 # Jetty线程池的最小线程数
      maxThreads: 200 # Jetty线程池的最大线程数
      idleTimeout: 30000 # 线程空闲超时时限（毫秒）
    acceptQueueSize: 100 # 接受队列大小（连接请求等待队列）

# 注意：Jetty的maxConnections配置可能需要通过创建自定义JettyServerCustomizer bean来设置
```

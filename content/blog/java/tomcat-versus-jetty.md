---
title: Tomcat Versus Jetty
date: 2024-03-30T21:27:08+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## Tomcat
+ tomcat适合处理少数非常繁忙的链接，当链接生命周期非常短的话tomcat的总体性能较高。
+ tomcat默认采用BIO处理I/O请求，在处理静态资源时，性能较差。
+ tomcat的架构是基于容器设计的，进行扩展需要了解tomcat的整体设计结构，不易扩展。
```yaml
server:
  tomcat:
    threads:
      min-spare: 10 # 最少的工作线程数，默认值10
      max: 200 # 最多的工作线程数，默认200，决定了web容器可以同时处理多少个请求
    max-connections: 8192 # 最大连接数，默认8192
    accept-count: 100 # 最大等待数
```

## Jetty
+ jetty的架构是基于Handler来实现的，主要的功能都可以用Handler来实现，扩展简单。
+ jetty可以同时处理大量连接而且可以长时间保持连接，适合于web聊天应用。
+ jetty的架构简单，因此作为服务器，jetty可以按需加载组件，减少不需要的组件，减少了服务器的内存开销，从而提高服务 器性能
+ jetty默认采用NIO结束在处理I/O请求上更占优势，在处理静态资源时，性能较高。

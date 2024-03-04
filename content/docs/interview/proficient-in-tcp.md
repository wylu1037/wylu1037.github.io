---
title: 🥳 Proficient in Tcp
date: 2024-03-04T08:29:44+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---
{{< cards >}}
  {{< card link="https://xiaolincoding.com/network/3_tcp/tcp_interview.html" title="原文出处" subtitle="Get ready to deploy and app in 5 minutes" icon="academic-cap" >}}
{{< /cards >}}

本文将深入探讨TCP/IP协议中的高级特性和行为，从三次握手与四次挥手的基本概念，到TCP重传、滑动窗口、流量控制及拥塞控制等复杂机制。我们将解析TCP抓包技术，讨论TCP半连接队列和全连接队列的区别，以及如何优化TCP性能。文章还将探讨面向字节流的TCP协议特性，包括建立连接时的初始化序列号，以及在特定情况下如何处理SYN报文和FIN包。

此外，我们将讨论在已建立的TCP连接中接收到SYN报文的行为，TIME_WAIT状态下收到SYN的处理，以及TCP连接在一端断电或进程崩溃时的差异。我们还将考虑拔掉网线后TCP连接的状态，探讨tcp_tw_reuse设置的意义，比较HTTPS中TLS与TCP同时握手的可能性，以及TCP Keepalive和HTTP Keep-Alive的区别。

最后，文章将探讨TCP协议的潜在缺陷，如何基于UDP实现可靠传输，TCP和UDP是否可以共用一个端口，未监听和未接受连接的TCP行为，TCP协议的数据保证，以及TCP四次挥手是否可以简化为三次，还有TCP序列号和确认号的变化机制。通过这些讨论，读者将获得对TCP/IP协议更深入、全面的理解。

## 1.三次握手与四次握手

## 2.TCP重传、滑动窗口、流量控制、拥塞控制

## 3.TCP抓包

## 4.TCP半连接队列和全连接队列

## 5.优化TCP

## 6.面向字节流协议的TCP

## 7.建立链接时的初始化序列号

## 8.何时丢弃SYN报文

## 9.TCP已建立连接时收到SYN的行为

## 10.四次挥手中收到乱序的 FIN 包会如何处理？

## 11.在 TIME_WAIT 状态的 TCP 连接，收到 SYN 后会发生什么？

## 12.TCP 连接，一端断电和进程崩溃有什么区别？

## 13.拔掉网线后， 原本的 TCP 连接还存在吗？

## 14.tcp_tw_reuse 为什么默认是关闭的？

## 15.HTTPS 中 TLS 和 TCP 能同时握手吗？

## 16.TCP Keepalive 和 HTTP Keep-Alive 是一个东西吗？

## 17.TCP 协议有什么缺陷？

## 18.如何基于 UDP 协议实现可靠传输？

## 19.TCP 和 UDP 可以使用同一个端口吗？

## 20.服务端没有 listen，客户端发起连接建立，会发生什么？

## 21.没有 accept，能建立 TCP 连接吗？

## 22.用了 TCP 协议，数据一定不会丢吗？

## 23.TCP 四次挥手，可以变成三次吗？

## 24.TCP 序列号和确认号是如何变化的？
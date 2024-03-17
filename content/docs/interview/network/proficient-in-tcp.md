---
title: 🥳 Proficient in Tcp
date: 2024-03-04T08:29:44+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

{{< cards >}}
{{< card link="https://xiaolincoding.com/network/3_tcp/tcp_interview.html" title="原文出处" subtitle="小林coding图解网络系列之TCP篇" icon="academic-cap" >}}
{{< card link="https://honey-yogurt.github.io/cs/network/handwave/" title="治国优选" subtitle="二次加工版本" icon="bookmark-square" >}}
{{< /cards >}}

本文将深入探讨 TCP/IP 协议中的高级特性和行为，从三次握手与四次挥手的基本概念，到 TCP 重传、滑动窗口、流量控制及拥塞控制等复杂机制。我们将解析 TCP 抓包技术，讨论 TCP 半连接队列和全连接队列的区别，以及如何优化 TCP 性能。文章还将探讨面向字节流的 TCP 协议特性，包括建立连接时的初始化序列号，以及在特定情况下如何处理 SYN 报文和 FIN 包。

此外，我们将讨论在已建立的 TCP 连接中接收到 SYN 报文的行为，TIME_WAIT 状态下收到 SYN 的处理，以及 TCP 连接在一端断电或进程崩溃时的差异。我们还将考虑拔掉网线后 TCP 连接的状态，探讨 tcp_tw_reuse 设置的意义，比较 HTTPS 中 TLS 与 TCP 同时握手的可能性，以及 TCP Keepalive 和 HTTP Keep-Alive 的区别。

最后，文章将探讨 TCP 协议的潜在缺陷，如何基于 UDP 实现可靠传输，TCP 和 UDP 是否可以共用一个端口，未监听和未接受连接的 TCP 行为，TCP 协议的数据保证，以及 TCP 四次挥手是否可以简化为三次，还有 TCP 序列号和确认号的变化机制。通过这些讨论，读者将获得对 TCP/IP 协议更深入、全面的理解。

## 1.三次握手与四次握手

### 1.1 TCP基本认识
{{< image "/images/docs/interview/network/tcp/tcp头部.webp" "TCP 头部" >}}

+ **序列号**：在建立连接时由计算机生成的随机数作为其初始值，通过 SYN 包传给接收端主机，每发送一次数据，就「累加」一次该「数据字节数」的大小。用来 {{< font "blue" "解决网络包乱序" >}} 问题。
+ **确认应答号**：指下一次「期望」收到的数据的序列号，发送端收到这个确认应答以后可以认为在这个序号以前的数据都已经被正常接收。用来 {{< font "blue" "解决丢包" >}} 问题。
+ **控制位**：
  + ACK：该位为 1 时，「确认应答」的字段变为有效，TCP 规定除了最初建立连接时的 SYN 包之外该位必须设置为 1 。
  + RST：该位为 1 时，表示 TCP 连接中出现异常必须强制断开连接。
  + SYN：该位为 1 时，表示希望建立连接，并在其「序列号」的字段进行序列号初始值的设定。
  + FIN：该位为 1 时，表示今后不会再有数据发送，希望断开连接。当通信结束希望断开连接时，通信双方的主机之间就可以相互交换 FIN 位为 1 的 TCP 段。


#### UDP 与 TCP 的区别
{{< image "/images/docs/interview/network/tcp/udp头部.webp" "UDP 头部" >}}

### 1.2 TCP连接建立

### 1.3 TCP连接断开


### 1.4 Socket编程
## 2.TCP 重传、滑动窗口、流量控制、拥塞控制

## 3.TCP 抓包

## 4.TCP 半连接队列和全连接队列

## 5.优化 TCP

## 6.面向字节流协议的 TCP

## 7.建立链接时的初始化序列号

## 8.何时丢弃 SYN 报文

## 9.TCP 已建立连接时收到 SYN 的行为

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

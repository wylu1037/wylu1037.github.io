---
title: 😇 Proficient in Ip
date: 2024-03-14T09:13:24+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## 1.IP 基本认识

## 2.IP 地址的基础认识

## 3.IP 协议相关技术

| 协议             | 作用               |
| ---------------- | ------------------ |
| DNS              | 域名解析           |
| ARP 与 RARP 协议 |                    |
| DHCP             | 动态获取 IP 地址   |
| NAT              | 网络地址转换       |
| ICMP             | 互联网控制报文协议 |
| IGMP             | 因特网组管理协议   |

### 3.1 DNS

浏览器首先看一下自己的缓存里有没有，如果没有就向操作系统的缓存要，还没有就检查本机域名解析文件 hosts，如果还是没有，就会 DNS 服务器进行查询，查询的过程如下：

{{% steps %}}

<h5></h5>

客户端首先会发出一个 DNS 请求，问 www.server.com 的 IP 是啥，并发给本地 DNS 服务器（也就是客户端的 TCP/IP 设置中填写的 DNS 服务器地址）。

<h5></h5>

本地域名服务器收到客户端的请求后，如果缓存里的表格能找到 www.server.com，则它直接返回 IP 地址。如果没有，本地 DNS 会去问它的根域名服务器：“老大， 能告诉我 www.server.com 的 IP 地址吗？” 根域名服务器是最高层次的，它不直接用于域名解析，但能指明一条道路。

<h5></h5>

根 DNS 收到来自本地 DNS 的请求后，发现后置是 .com，说：“www.server.com 这个域名归 .com 区域管理”，我给你 .com 顶级域名服务器地址给你，你去问问它吧。”

<h5></h5>

本地 DNS 收到顶级域名服务器的地址后，发起请求问“老二， 你能告诉我 www.server.com 的 IP 地址吗？”

<h5></h5>

顶级域名服务器说：“我给你负责 www.server.com 区域的权威 DNS 服务器的地址，你去问它应该能问到”。

<h5></h5>

本地 DNS 于是转向问权威 DNS 服务器：“老三，www.server.com对应的IP是啥呀？” server.com 的权威 DNS 服务器，它是域名解析结果的原出处。为啥叫权威呢？就是我的域名我做主。

<h5></h5>

权威 DNS 服务器查询后将对应的 IP 地址 X.X.X.X 告诉本地 DNS。

<h5></h5>

本地 DNS 再将 IP 地址返回客户端，客户端和目标建立连接。
{{% /steps %}}

{{< image "/images/docs/interview/network/dns-lookup.webp" "DNS 解析" >}}

### 3.2 ARP

### 3.3 DHCP

### 3.4 NAT

### 3.5 ICMP

### 3.6 IGMP

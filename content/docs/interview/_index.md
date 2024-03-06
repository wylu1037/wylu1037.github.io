---
title: 🧑🏽‍💻 Interview
date: 2024-03-02T11:17:45+08:00
---

{{< callout >}}
  {{< font type="yellow" text="Interview series" >}}
{{< /callout >}}

## Go
{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
  Interview questions about Go
{{< /hextra/hero-subtitle >}}
{{< cards >}}
  {{< card link="" title="Context" subtitle= "A goroutine is a lightweight thread managed by the Go runtime. Channels is how you communicate between routines." icon="go" >}}
{{< /cards >}}

## Network
{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
  Interview questions about TCP & HTTP
{{< /hextra/hero-subtitle >}}
{{< cards >}}
  {{< card link="/docs/interview/proficient-in-http" title="Proficient in http" subtitle= "HTTP stands for Hypertext Transfer Protocol. It is an application layer protocol used for transmitting and receiving information on the World Wide Web. HTTP is the foundation of data communication on the web and is an essential protocol for the functioning of websites and web applications." icon="academic-cap" >}}
  {{< card link="/docs/interview/proficient-in-tcp" title="Proficient in tcp" subtitle= "TCP provides reliable, connection-oriented communication between two devices over a network. TCP stands for Transmission Control Protocol. It is one of the main protocols in the Internet Protocol (IP) suite and operates at the transport layer (Layer 4) of the OSI model." icon="banknotes" >}}
{{< /cards >}}

## DevOps
{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
  Interview questions about DevOps
{{< /hextra/hero-subtitle >}}
{{< cards >}}
  {{< card link="" title="Kubernetes" subtitle= "A goroutine is a lightweight thread managed by the Go runtime. Channels is how you communicate between routines." icon="kubernetes" >}}
{{< /cards >}}

## Proficient in http
<br>
HTTPS是应用层协议，需要先完成 TCP 连接建立，然后走 TLS 握手过程后，才能建立通信安全的连接。

事实上，不同的密钥交换算法，TLS 的握手过程可能会有一些区别。

先简单介绍下密钥交换算法，考虑到性能的问题，双方在加密应用信息时使用的是 **对称加密密钥**，而对称加密密钥是不能被泄漏的，为了保证对称加密密钥的安全性，使用非对称加密的方式来保护对称加密密钥的协商，这个工作就是 **密钥交换算法** 负责的。

以最简单的 {{< hl "RSA">}} 密钥交换算法，看它的 {{<hl "TLS">}} 握手过程。

### RSA握手过程
传统的 TLS 握手基本都是使用 RSA 算法来实现密钥交换的，在将 TLS 证书部署**服务端**时，证书文件其实就是服务端的公钥，会在 TLS 握手阶段传递给客户端，而服务端的私钥则一直留在服务端，一定要确保私钥不能被窃取。

在 RSA 密钥协商算法中，客户端会生成 {{<hl 随机密钥>}}，并使用服务端的公钥加密后再传给服务端。根据非对称加密算法，公钥加密的消息仅能通过私钥解密，这样服务端解密后，双方就得到了相同的密钥，再用它加密应用消息。

使用 **Wireshark** 工具抓取了用 RSA 密钥交换的 TLS 握手过程，可以从下面看到，一共经历了四次握手：
{{< image "/images/docs/interview/tls四次握手.webp" "tls四次握手">}}

对应 Wireshark 的抓包，下图可以很清晰地看到该过程：
{{< image "/images/docs/interview/https_rsa.webp" "https rsa">}}

#### TLS 第一次握手
客户端首先会发送一个 {{< font type="blue" text="Client Hello" >}} 消息向服务器打招呼。

{{< image "/images/docs/interview/tls第一次握手.webp" "Client Hello">}}

消息里面有客户端使用的 TLS 版本号、支持的密码套件列表，以及生成的{{< font type="orange" text="随机数（Client Random）" >}}，这个随机数会被服务端保留，它是生成对称加密密钥的材料之一。

#### TLS 第二次握手
当服务端收到客户端的 {{< font type="blue" text="Client Hello" >}} 消息后，会确认 TLS 版本号是否支持，和从密码套件列表中选择一个密码套件，以及生成随机数（Server Random）。

接着，返回{{< font type="blue" text="Server Hello" >}} 消息，消息里面有服务器确认的 TLS 版本号，也给出了随机数（Server Random），然后从客户端的密码套件列表选择了一个合适的密码套件。

{{< image "/images/docs/interview/tls第二次握手.webp" "Server Hello">}}

密码套件的基本形式是 {{< hl "密钥交换算法 + 签名算法 + 对称加密算法 + 摘要算法" >}}， 一般 WITH 单词前面有两个单词，第一个单词是约定密钥交换的算法，第二个单词是约定证书的验证算法。比如刚才的密码套件的意思就是：
+ 由于 WITH 单词只有一个 RSA，则说明握手时密钥交换算法和签名算法都是使用 RSA；
+ 握手后的通信使用 AES 对称算法，密钥长度 128 位，分组模式是 GCM；
+ 摘要算法 SHA256 用于消息认证和产生随机数；

#### 客户端验证证书

#### TLS 第三次握手


#### TLS 第四次握手


### RSA 算法的{{< font type="red" text="缺陷" >}}

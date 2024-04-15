---
title: 精通 HTTP
date: 2024-03-04T08:29:52+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
width: wide
weight: 2
---

{{< cards >}}
{{< bg-blur >}}

<div style="grid-column: 2">
{{< card
            link="https://xiaolincoding.com/network/2_http/http_interview.html#http-%E5%9F%BA%E6%9C%AC%E6%A6%82%E5%BF%B5"
            title="原文出处"
            image="images/docs/interview/http.jpeg"
            subtitle="Http面试、优化、协议解析、RPC、Websocket等等。"
            method="Resize" >}}
</div>
{{< bg-blur color="blue" >}}
{{< /cards >}}

本文旨在全面解析 HTTP 协议及其在现代网络通信中的应用，涵盖了从基本概念、GET 与 POST 请求的差异，到 HTTP 缓存技术和协议特性的深入探讨。文章进一步深入到 HTTP1.1 的优化技术，解析 HTTPS 中 RSA 和 ECDHE 握手过程的细节，以及如何在 HTTPS 环境下进行性能优化。随着网络技术的发展，本文也探讨了 HTTP2 和 HTTP3 这两个协议版本的新特性和改进点，为读者提供了对这些先进协议的深入理解。

此外，文章比较了 HTTP 与 RPC（远程过程调用）以及 HTTP 与 Websocket 协议的不同应用场景和优缺点，为读者在选择适合自己项目的网络通信协议提供了专业的指导。通过对这些关键技术点的分析和讨论，读者将能够精通 HTTP 协议及其在现代 Web 开发中的应用，从而设计出更高效、安全的网络应用。

## 1.HTTP 面试题

### 1.1 HTTP 基本概念

### 1.2 GET 与 POST

### 1.3 HTTP 缓存技术

### 1.4 HTTP 特性

## 2.HTTP<font style="color:#f59e0b;">1.1</font> 优化

👨🏻‍🏫 如何优化 HTTP<font style="color:#f59e0b;">1.1</font>
{{< tabs items="🤔避免发送HTTP请求, 🧐 减少请求次数, 🤯 减小响应数据大小">}}
{{< tab >}}
{{< font "red" "缓存" >}}

在请求静态文件的时候，由于这些文件不经常变化，因此把静态文件储起来是一种优化用户浏览体验的方法，同时也可以释放链路资源，缓解网络压力。客户端会把第一次请求以及响应的数据保存在本地磁盘上，其中将请求的 URL 作为 key，而响应作为 value，两者形成映射关系。确认缓存的有效时间通常是通过响应头的`Expires`、`Cache-Control`、`Last-Modified / If-Modified-Since`、`Etag / If-None-Match`来控制。

**1.Expires**

Expires 指定文件缓存的过期时间，是一个绝对时间。

```
Expires: Mon, 1 Aug 2016 22:43:02 GMT
```

**2.Cache-Control**

Cache-Control 是 http/1.1 中引入的，指定缓存过期的相对时间，可以防止客户端的系统时间被客户修改，导致设置的 Expires 时间失效。

```
Cache-Control: max-age=3600
```

上面设置缓存的有效期为 3600 秒。客户端收到带有 max-age 指令的响应后，会将该资源及其接收时间记录下来。在后续请求相同资源时，客户端会检查本地缓存中的资源是否仍在 max-age 定义的新鲜时间内。如果是，客户端会直接使用缓存中的资源，而不是向服务器发送请求。

> 同时存在 Expires 和 Cache-Control 时，浏览器会优先以 Cache-Control 为主。

**3.Last-Modified / If-Modified-Since**

服务端某个文件可能会发生更新，希望客户端时不时请求服务端获取这个文件的过期状态。没有过期，不返回数据给浏览器，只返回 304 状态码，告诉浏览器缓存还没过期。
这个实现就是条件请求。

- Last-Modified (response header)
- If-Modified-Since (request header)
  首次请求时，服务端返回携带响应头：

```
Last-Modified:Mon, 01 Aug 2016 13:48:44 GMT
```

下次请求时（没有设置 Expires 和 Cache-Control），请求携带头：

```
If-Modified-Since:Mon, 01 Aug 2016 13:48:44 GMT
```

服务端对比文件的最后修改时间和 If-Modified-Since 的时间，没有修改返回 304，否则返回 200 并携带新的资源内容。

**4.Etag / If-None-Match**

条件请求的另一种实现，使用 Etag。首次请求服务响应头携带`Etag`作为时间标签，下次请求时携带 key 为`If-None-Match`，value 为`Etag`的请求头。
服务器对比`If-None-Match`的值，没有修改返回 304，否则返回 200 并携带新的资源内容。

**示例**

Response Headers

```yaml
Cache-Control:private, max-age=10
Connection:keep-alive
Content-Encoding:gzip
Content-Type:text/html; charset=utf-8
Date:Mon, 01 Aug 2016 13:48:44 GMT
Expires:Mon, 01 Aug 2016 13:48:54 GMT
Last-Modified:Mon, 01 Aug 2016 13:48:44 GMT
Transfer-Encoding:chunked
Vary:Accept-Encoding
X-UA-Compatible:IE=10
```

- 第 1 行的 Cache-Control:private, max-age=10，表示有效时间为 10s，且其优先级高于 Expires。响应头中出现了 private，其作用是通知浏览器只针对单个用户进行缓存，且可以具体指定某个字段，如 private–"username"。
- 第 2 行的 Keep-Alive 功能使客户端到服务器端的连接持续有效。当出现对服务器的后继请求时，Keep-Alive 功能避免了重新建立连接，即认为之前的连接还是有效的。
- 第 3 行表示响应的压缩方式，压缩后再传输可以提高效率。
- 第 4 行表示响应的文件类型和字符编码方式。
- 第 5 行的 Date 表示生成文件的绝对时间。
- 第 6 行 Expires 表示文件过期的绝对时间。同时上面也提到了，其优先级低于 Cache-Control。
- 第 7 行的 Last-Modified 是服务器告诉浏览器该文件的最后修改时间。
- 综上可以看出，该页面的缓存有效时间是 10 秒。如果不清空缓存，在 2016.08.01 的 13:48:44~13:48:54 这个时间段中再次访问服务器，则不会再得到新的页面，而是直接呈现本地缓存。

{{< /tab >}}

{{< tab >}}
{{< font "red" "减少请求次数" >}}

- 减少重定向次数
- 合并请求
- 延迟发送请求

{{< /tab >}}

{{< tab >}}
{{< font "red" "压缩" >}} + 无损压缩 + 有损压缩  
 {{< /tab >}}
{{< /tabs >}}

## 3.HTTP<font style="color:#f59e0b;">S</font> RSA 握手解析

### 3.1 TLS 握手过程

http 是明文传输（客户端与服务端通信的信息都是肉眼可见的，可通过抓包工具截获通信的内容），存在以下风险：

- {{< font type="red" text="窃听风险" >}}：比如通信链路上可以获取通信内容；
- {{< font type="red" text="篡改风险" >}}：比如强制植入垃圾广告，视觉污染；
- {{< font type="red" text="冒充风险" >}}：比如冒充淘宝网站；

{{< image "/images/docs/interview/http/HTTPS与HTTP.png" "HTTPS Versus HTTP" >}}

> HTTPS 在 HTTP 与 TCP 层之间加入了 TLS 协议，来解决上述的风险。

### 3.2 RSA 握手过程

HTTPS 在进行通信前，需要先进行 TLS 握手。握手过程如下：
{{% details title="查看图片" closed="true" %}}
{{< image "/images/docs/interview/http/tls握手.png" "TLS之RSA算法握手过程" >}}
{{% /details %}}

上图简要概述了 TLS 的握手过程，其中每一个「框」都是一个记录（record），记录是 TLS 收发数据的基本单位，类似于 TCP 里的 segment。多个记录可以组合成一个 TCP 包发送，所以通常经过「四个消息」就可以完成 TLS 握手，也就是需要 2 个 RTT(Round Trip Time) 的时延，然后就可以在安全的通信环境里发送 HTTP 报文，实现 HTTPS 协议。

<br>
HTTPS是应用层协议，需要先完成 TCP 连接建立，然后走 TLS 握手过程后，才能建立通信安全的连接。

事实上，不同的密钥交换算法，TLS 的握手过程可能会有一些区别。

先简单介绍下密钥交换算法，考虑到性能的问题，双方在加密应用信息时使用的是 **对称加密密钥**，而对称加密密钥是不能被泄漏的，为了保证对称加密密钥的安全性，使用非对称加密的方式来保护对称加密密钥的协商，这个工作就是 **密钥交换算法** 负责的。

以最简单的 {{< hl "RSA">}} 密钥交换算法，看它的 {{<hl "TLS">}} 握手过程。

传统的 TLS 握手基本都是使用 RSA 算法来实现密钥交换的，在将 TLS 证书部署**服务端**时，证书文件其实就是服务端的公钥，会在 TLS 握手阶段传递给客户端，而服务端的私钥则一直留在服务端，一定要确保私钥不能被窃取。

在 RSA 密钥协商算法中，客户端会生成 {{<hl 随机密钥>}}，并使用服务端的公钥加密后再传给服务端。根据非对称加密算法，公钥加密的消息仅能通过私钥解密，这样服务端解密后，双方就得到了相同的密钥，再用它加密应用消息。

使用 **Wireshark** 工具抓取了用 RSA 密钥交换的 TLS 握手过程，可以从下面看到，一共经历了四次握手：
{{< image "/images/docs/interview/http/tls四次握手.webp" "tls四次握手">}}

| 过程       | 数据数量 | 数据发送主体 | 数据                                                                       |
| ---------- | -------- | ------------ | -------------------------------------------------------------------------- |
| 第一次握手 | 1        | 客户端       | `Client Hello`                                                             |
| 第二次握手 | 3        | 服务端       | `Server Hello`、`Certificate`、`Server Hello Done`                         |
| 第三次握手 | 3        | 客户端       | `Client Key Exchange`、`Change Cipher Spec`、`Encrypted Handshake Message` |
| 第四次握手 | 2        | 服务端       | `Change Cipher Spec`、`Encrypted Handshake Message`                        |

对应 Wireshark 的抓包，下图可以很清晰地看到该过程：

{{% details title="查看图片" closed="true" %}}
{{< image "/images/docs/interview/http/https_rsa.webp" "https rsa">}}
{{% /details %}}

#### 3.2.1 TLS 第一次握手

客户端首先会发送一个 {{< font type="blue" text="Client Hello" >}} 消息向服务器打招呼。

{{< image "/images/docs/interview/http/tls第一次握手.webp" "Client Hello">}}

消息里面有客户端使用的 TLS 版本号、支持的密码套件列表，以及生成的{{< font type="orange" text="随机数（Client Random）" >}}，这个随机数会被服务端保留，它是生成对称加密密钥的材料之一。

#### 3.2.2 TLS 第二次握手

当服务端收到客户端的 {{< font type="blue" text="Client Hello" >}} 消息后，会确认 TLS 版本号是否支持，和从密码套件列表中选择一个密码套件，以及生成随机数（Server Random）。

接着，返回{{< font type="blue" text="Server Hello" >}} 消息，消息里面有服务器确认的 TLS 版本号，也给出了随机数（Server Random），然后从客户端的密码套件列表选择了一个合适的密码套件。

{{< image "/images/docs/interview/http/tls第二次握手.webp" "Server Hello">}}

密码套件的基本形式是 {{< hl "密钥交换算法 + 签名算法 + 对称加密算法 + 摘要算法" >}}， 一般 WITH 单词前面有两个单词，第一个单词是约定密钥交换的算法，第二个单词是约定证书的验证算法。比如刚才的密码套件的意思就是：

- 由于 WITH 单词只有一个 RSA，则说明握手时密钥交换算法和签名算法都是使用 RSA；
- 握手后的通信使用 AES 对称算法，密钥长度 128 位，分组模式是 GCM；
- 摘要算法 SHA256 用于消息认证和产生随机数；

前两次握手，客户端和服务端已经确认了 TLS 版本和使用的密码套件，客户端和服务端各自生成一个随机数，并且把随机数传递给对方。随机数是作为生成「会话密钥」的条件，所谓的会话密钥就是数据传输时，所使用的对称加密密钥。

然后，服务端为了证明自己的身份，会发送「Server Certificate」给客户端，这个消息里含有数字证书。
{{< image "/images/docs/interview/http/服务端发送certificate.webp" "服务端发送certificate">}}

随后，服务端发了「Server Hello Done」消息，目的是告诉客户端，我已经把该给你的东西都给你了，本次打招呼完毕。
{{< image "/images/docs/interview/http/serverhellodone.webp" "Server Hello Done">}}

#### 3.2.3 客户端验证证书

客户端拿到了服务端的数字证书后，如何校验该数字证书是真实有效的呢？

##### 3.2.3.1 数字证书和 CA 机构

数字证书通常包含了：

- 公钥；
- 持有者信息；
- 证书认证机构（CA）的信息；
- CA 对这份文件的数字签名及使用的算法；
- 证书有效期；
- 还有一些其他额外信息。

数字证书是用来认证公钥持有者的身份，以防止第三方进行冒充。就是用来告诉客户端，该服务端是否是合法的，因为只有证书合法，才代表服务端身份是可信的。{{< font type="red" text="用证书来认证公钥持有者的身份（服务端的身份）" >}}。

为了让服务端的公钥被大家信任，服务端的证书都是由 CA （Certificate Authority，证书认证机构）签名的，CA 就是网络世界里的公安局、公证中心，具有极高的可信度，所以由它来给各个公钥签名，信任的一方签发的证书，那必然证书也是被信任的。之所以要签名，是因为签名的作用可以避免中间人在获取证书时对证书内容的篡改。

##### 3.2.3.2 数字证书签发和验证流程

{{< image "/images/docs/interview/http/证书的校验.webp" "数字证书签发和验证流程">}}

{{< tabs items="CA 签发证书的过程,客户端校验服务端的数字证书的过程" >}}

{{< tab >}}
如上图左边部分：

- 首先 CA 会把持有者的公钥、用途、颁发者、有效时间等信息打成一个包，然后对这些信息进行 Hash 计算，得到一个 Hash 值；
- 然后 CA 会使用自己的私钥将该 Hash 值加密，生成 Certificate Signature，也就是 CA 对证书做了签名；
- 最后将 Certificate Signature 添加在文件证书上，形成数字证书；
  {{< /tab >}}

{{< tab >}}
如上图右边部分：

- 首先客户端会使用同样的 Hash 算法获取该证书的 Hash 值 H1；
- 通常浏览器和操作系统中集成了 CA 的公钥信息，浏览器收到证书后可以使用 CA 的公钥解密 Certificate Signature 内容，得到一个 Hash 值 H2 ；
- 最后比较 H1 和 H2，如果值相同，则为可信赖的证书，否则则认为证书不可信。

{{< /tab >}}
{{< /tabs >}}

##### 3.2.3.3 证书链

但事实上，证书的验证过程中还存在一个证书信任链的问题，因为向 CA 申请的证书一般不是根证书签发的，而是由中间证书签发的，比如百度的证书，从下图你可以看到，证书的层级有三级：
{{< image "/images/docs/interview/http/baidu证书.webp" "baidu证书">}}

对于这种三级层级关系的证书的验证过程如下：

{{% steps %}}

<h5>第一步</h5>

客户端收到 baidu.com 的证书后，发现这个证书的签发者不是根证书，就无法根据本地已有的根证书中的公钥去验证 baidu.com 证书是否可信。于是，客户端根据 baidu.com 证书中的签发者，找到该证书的颁发机构是 “GlobalSign Organization Validation CA - SHA256 - G2”，然后向 CA 请求该中间证书。

<h5>第二步</h5>

请求到证书后发现 “GlobalSign Organization Validation CA - SHA256 - G2” 证书是由 “GlobalSign Root CA” 签发的，由于 “GlobalSign Root CA” 没有再上级签发机构，说明它是根证书，也就是自签证书。应用软件会检查此证书有否已预载于根证书清单上，如果有，则可以利用根证书中的公钥去验证 “GlobalSign Organization Validation CA - SHA256 - G2” 证书，如果发现验证通过，就认为该中间证书是可信的。

<h5>第三步</h5>

“GlobalSign Organization Validation CA - SHA256 - G2” 证书被信任后，可以使用 “GlobalSign Organization Validation CA - SHA256 - G2” 证书中的公钥去验证 baidu.com 证书的可信性，如果验证通过，就可以信任 baidu.com 证书。

{{% /steps %}}

总括来说，由于用户信任 GlobalSign，所以由 GlobalSign 所担保的 baidu.com 可以被信任，另外由于用户信任操作系统或浏览器的软件商，所以由软件商预载了根证书的 GlobalSign 都可被信任。

这样的一层层地验证就构成了一条信任链路，整个证书信任链验证流程如下图所示：
{{< image "/images/docs/interview/http/证书链.webp" "证书链">}}

{{< callout type="warning" >}}
**为什么需要证书链这么麻烦的流程？Root CA 为什么不直接颁发证书，而是要搞那么多中间层级呢？**

这是为了确保根证书的绝对安全性，将根证书隔离地越严格越好，不然根证书如果失守了，那么整个信任链都会有问题。
{{< /callout >}}

#### 3.2.4 TLS 第三次握手

客户端验证完证书后，认为可信则继续往下走。

接着，客户端就会生成一个新的随机数 (pre-master)，用服务器的 RSA 公钥加密该随机数，通过「Client Key Exchange」消息传给服务端。

{{< image "/images/docs/interview/http/clietnkeyexchange.webp" "Clietn Key Exchange:pre-master">}}

服务端收到后，用 RSA 私钥解密，得到客户端发来的随机数 (pre-master)。至此，客户端和服务端双方都共享了三个随机数，分别是 Client Random、Server Random、pre-master。于是，双方根据已经得到的三个随机数，生成会话密钥（Master Secret），它是对称密钥，用于对后续的 HTTP 请求/响应的数据加解密。

生成「会话密钥」后，然后客户端发送一个「Change Cipher Spec」，告诉服务端开始使用加密方式发送消息。

{{< image "/images/docs/interview/http/cipherspecmessage.webp" "Change Cipher Spec">}}

然后，客户端再发一个 **Encrypted Handshake Message（Finishd）** 消息，把之前所有发送的数据做个摘要，再用会话密钥（master secret）加密一下，让服务器做个验证，验证加密通信 **是否可用** 和 **之前握手信息是否有被中途篡改过**。

{{< image "/images/docs/interview/http/encryptd-handshake-message.webp" "Encryptd Handshake Message">}}

{{< callout type="info" >}}
可以发现，**_Change Cipher Spec_** 之前传输的 TLS 握手数据都是明文，之后都是对称密钥加密的密文。
{{< /callout >}}

#### 3.2.5 TLS 第四次握手

服务器也是同样的操作，发 **Change Cipher Spec** 和 **Encrypted Handshake Message** 消息，如果双方都验证加密和解密没问题，那么握手正式完成。最后，就用 {{< hl "会话密钥">}} 加解密 HTTP 请求和响应了。

### 3.3 RSA 算法的缺陷

{{< font type="blue" text="使用 RSA 密钥协商算法的最大问题是不支持前向保密。" >}}

> 前向保密（Forward Secrecy，也称作完全前向保密）是一种通过加密协议确保会话密钥的安全性的方法，即使长期密钥被泄露，也不会危及过去的通信记录。在使用前向保密的系统中，通信双方每次建立连接时都会生成一个独一无二的会话密钥用于该次会话的加密，而且这个会话密钥是在不泄露长期密钥的情况下生成的。一旦会话结束，该会话密钥就会被丢弃。这样，即使攻击者未来某一时刻获得了服务端的私钥，也无法解密之前拦截的加密通信，因为他们没有那一次通信的会话密钥。

因为客户端传递随机数（用于生成对称加密密钥的条件之一）给服务端时使用的是公钥加密的，服务端收到后，会用私钥解密得到随机数。所以一旦服务端的私钥泄漏了，过去被第三方截获的所有 TLS 通讯密文都会被破解。
为了解决这个问题，后面就出现了 ECDHE 密钥协商算法，现在大多数网站使用的正是 ECDHE 密钥协商算法。

## 4.HTTP<font style="color:#f59e0b;">S</font> ECDHE 握手解析

HTTPS 常用的密钥交换算法有两种，分别是 RSA 和 ECDHE 算法。

### 4.1 离散对数

### 4.2 DH 算法

### 4.3 ECDHE 算法

### 4.4 ECDHE 握手过程

#### 4.4.1 TLS 第一次握手

#### 4.4.2 TLS 第二次握手

#### 4.4.3 TLS 第三次握手

#### 4.4.4 TLS 第四次握手

### 4.5 总结

## 5.HTTP<font style="color:#f59e0b;">S</font>优化

明文数据传输的 HTTP 相对于 加密数据传输的 HTTPS，提高安全性的同时也带来了性能消耗。因为 HTTPS 相比 HTTP 协议多一个 TLS 协议握手过程，目的是为了通过非对称加密握手协商或者交换出对称加密密钥，这个过程最长可以花费掉 2 RTT，接着后续传输的应用数据都得使用对称加密密钥来加密/解密。

### 5.1 分析性能损耗

产生性能消耗的两个环节：

{{< tabs items="TLS 协议握手过程,握手后的对称加密报文传输" >}}
{{< tab>}}
TLS 协议握手过程不仅增加了网络延时（最长可以花费掉 2 RTT），而且握手过程中的一些步骤也会产生性能损耗，比如： + 对于 ECDHE 密钥协商算法，握手过程中会客户端和服务端都需要临时生成椭圆曲线公私钥； + 客户端验证证书时，会访问 CA 获取 CRL 或者 OCSP，目的是验证服务器的证书是否有被吊销； + 双方计算 Pre-Master，也就是对称加密密钥；

    {{< details title="查看TLS性能损耗图" closed="true" >}}
      {{< image "/images/docs/interview/http/tls性能损耗.webp" "TLS性能损耗">}}
    {{< /details >}}

{{< /tab>}}

{{< tab>}}
{{< /tab>}}
{{< /tabs >}}

### 5.2 硬件优化

如果要优化 HTTPS 优化，最直接的方式就是花钱买性能参数更牛逼的硬件。HTTPS 协议是计算密集型，而不是 I/O 密集型，所以不能把钱花在网卡、硬盘等地方，应该花在 CPU 上。一个好的 CPU，可以提高计算性能，因为 HTTPS 连接过程中就有大量需要计算密钥的过程，所以这样可以加速 TLS 握手过程。

另外，如果可以，应该选择可以支持 AES-NI 特性的 CPU，因为这种款式的 CPU 能在指令级别优化了 AES 算法，这样便加速了数据的加解密传输过程。如果你的服务器是 Linux 系统，那么你可以使用下面这行命令查看 CPU 是否支持 AES-NI 指令集：

```shell
$ sort -u /proc/crypto | grep module | grep aes
```

> 输出 `moduel : aesni_intel`

如果 CPU 支持 AES-NI 特性，那么对于对称加密的算法应该选择 AES 算法。否则可以选择 ChaCha20 对称加密算法，因为 ChaCha20 算法的运算指令相比 AES 算法会对 CPU 更友好一点。

### 5.3 软件优化

软件的优化方向可以分层两种，一个是软件升级，一个是协议优化。**软件升级**，软件升级就是将正在使用的软件升级到最新版本，因为最新版本不仅提供了最新的特性，也优化了以前软件的问题或性能。比如：

- 将 Linux 内核从 2.x 升级到 4.x；
- 将 OpenSSL 从 1.0.1 升级到 1.1.1；
- ...

协议优化是现有的环节下，通过较小的改动，来进行优化。

### 5.4 协议优化

协议的优化就是对{{< font type="orange" text="密钥交换过程" >}}进行优化。

#### 5.4.1 密钥交换算法优化

TLS 1.2 版本如果使用的是 RSA 密钥交换算法，那么需要 4 次握手，也就是要花费 2 RTT，才可以进行应用数据的传输，而且 RSA 密钥交换算法不具备 {{< font "orange" "前向安全性" >}}。总之使用 RSA 密钥交换算法的 TLS 握手过程，不仅慢，而且安全性也不高

因此如果可以，尽量选用 ECDHE 密钥交换算法替换 RSA 算法，因为该算法由于支持 {{< font "orange" "False Start" >}}（抢跑），客户端可以在 TLS 协议的第 3 次握手后，第 4 次握手前，发送加密的应用数据，以此将 TLS 握手的消息往返由 2 RTT 减少到 1 RTT，而且安全性也高，具备前向安全性。

ECDHE 算法是基于椭圆曲线实现的，不同的椭圆曲线性能也不同，应该尽量选择 {{< font "blue" "x25519" >}} 曲线，该曲线是目前最快的椭圆曲线。

{{< tabs items="Nginx" >}}
{{< tab >}}
Nginx 上，可以使用 ssl_ecdh_curve 指令配置想使用的**椭圆曲线**，把优先使用的放在前面：

```yaml
.ssl_ecdh_curve X25519:secp384r1;
```

对于**对称加密算法**方面，如果对安全性不是特别高的要求，可以选用 AES_128_GCM，它比 AES_256_GCM 快一些，因为密钥的长度短一些。

Nginx 上，可以使用 ssl_ciphers 指令配置想使用的非对称加密算法和对称加密算法，也就是密钥套件，而且把性能最快最安全的算法放在最前面：

```yaml
ssl_ciphers 'EECDH+ECDSA+AES128+SHA:RSA+AES128+SHA';
```

{{< /tab >}}
{{< /tabs >}}

#### 5.4.2 TLS 升级

如果可以直接把 TLS" 1.2 升级成 TLS 1.3，TLS 1.3 大幅度简化了握手的步骤，完成 TLS 握手只要 1 RTT，而且安全性更高。
{{< callout type="info" >}}
Linux 查看 TLS 版本：`openssl s_client -connect tailwindcss.com:443`
{{< /callout >}}

在 TLS 1.2 的握手中，一般是需要 4 次握手，先要通过 Client Hello （第 1 次握手）和 Server Hello（第 2 次握手） 消息协商出后续使用的加密算法，再互相交换公钥（第 3 和 第 4 次握手），然后计算出最终的会话密钥，下图的左边部分就是 TLS 1.2 的握手过程：
{{< image "/images/docs/interview/http/tls1.2and1.3.webp" "TLS1.2 VS TLS1.3" >}}

上图的右边部分就是 TLS 1.3 的握手过程，可以发现 TLS 1.3 把 Hello 和公钥交换这两个消息合并成了一个消息，于是这样就减少到只需 1 RTT 就能完成 TLS 握手。

**TLS 1.3 怎么合并的呢？**

- 客户端在 Client Hello 消息里带上了支持的椭圆曲线，以及这些椭圆曲线对应的公钥；
- 服务端收到后，选定一个椭圆曲线等参数，然后返回消息时，带上服务端这边的公钥。经过 1 个 RTT，双方手上已经有生成会话密钥的材料了，于是客户端计算出会话密钥，就可以进行应用数据的加密传输了。

{{< callout >}}
TLS1.3 对密码套件进行了“减肥”。
对于密钥交换算法，废除了不支持前向安全性的 RSA 和 DH 算法，只支持 ECDHE 算法。
对于对称加密和签名算法，只支持目前最安全的几个密码套件，比如 openssl 中仅支持下面 5 种密码套件：

- TLS_AES_256_GCM_SHA384
- TLS_CHACHA20_POLY1305_SHA256
- TLS_AES_128_GCM_SHA256
- TLS_AES_128_CCM_8_SHA256
- TLS_AES_128_CCM_SHA256
  {{< /callout >}}

### 5.5 证书优化

为了验证的服务器的身份，服务器会在 TLS 握手过程中，把自己的证书发给客户端，以此证明自己身份是可信的。对于证书的优化，可以有两个方向：{{< font "blue" "证书传输" >}} 和 {{< font "red" "证书验证" >}}。

#### 5.5.1 证书传输优化

要让证书更便于传输，那必然是减少证书的大小，这样可以节约带宽，也能减少客户端的运算量。所以，对于服务器的证书应该选择椭圆曲线（ECDSA）证书，而不是 RSA 证书，因为在相同安全强度下， ECC 密钥长度比 RSA 短的多。

#### 5.5.2 证书验证优化

客户端在验证证书时，是个复杂的过程，会走证书链逐级验证，验证的过程不仅需要 {{< font "blue" "用 CA 公钥解密证书" >}} 以及 {{< font "orange" "用签名算法验证证书的完整性" >}}，而且为了知道证书是否被 CA 吊销，客户端有时还会再去访问 CA， 下载 **_CRL_** 或者 **_OCSP_** 数据，以此确认证书的有效性。

> 这个访问过程是 HTTP 访问，因此又会产生一系列网络通信的开销，如 DNS 查询、建立连接、收发数据等。

##### CRL

CRL 称为证书吊销列表（Certificate Revocation List），这个列表是由 CA 定期更新，列表内容都是被撤销信任的证书序号，如果服务器的证书在此列表，就认为证书已经失效，不在的话，则认为证书是有效的。
{{< image "/images/docs/interview/http/crl-certificate-revocation-status.webp" "CRL检查证书是否吊销" >}}

{{< callout type="error" >}}
但是 CRL 存在两个问题：

- 由于 CRL 列表是由 CA 维护的，定期更新，如果一个证书刚被吊销后，客户端在更新 CRL 之前还是会信任这个证书，实时性较差；
- 随着吊销证书的增多，列表会越来越大，下载的速度就会越慢，下载完客户端还得遍历这么大的列表，那么就会导致客户端在校验证书这一环节的延时很大，进而拖慢了 HTTPS 连接。
  {{< /callout >}}

##### OCSP

因此，现在基本都是使用 OCSP ，名为在线证书状态协议（Online Certificate Status Protocol）来查询证书的有效性，它的工作方式是向 CA 发送查询请求，让 CA 返回证书的有效状态。
{{< image "/images/docs/interview/http/ocsp-certificate-revocation-status.webp" "在线检查证书是否吊销" >}}

不必像 CRL 方式客户端需要下载大大的列表，还要从列表查询，同时因为可以实时查询每一张证书的有效性，解决了 CRL 的实时性问题。OCSP 需要向 CA 查询，因此也是要发生网络请求，而且还得看 CA 服务器的“脸色”，如果网络状态不好，或者 CA 服务器繁忙，也会导致客户端在校验证书这一环节的延时变大。

##### OCSP Stapling

于是为了解决这一个网络开销，就出现了 OCSP Stapling，其原理是：服务器向 CA 周期性地查询证书状态，获得一个带有时间戳和签名的响应结果并缓存它。
{{< image "/images/docs/interview/http/opscp-stapling.webp" "opscp stapling" >}}

当有客户端发起连接请求时，<u>**服务器**</u> 会把这个 {{< font "red" "响应结果" >}} 在 TLS 握手过程中发给客户端。由于有签名的存在，服务器无法篡改，因此客户端就能得知证书是否已被吊销了，这样客户端就不需要再去查询。

### 5.6 会话复用

TLS 握手的目的就是为了协商出会话密钥，也就是对称加密密钥，如果能够把首次 TLS 握手协商的对称加密密钥缓存起来，待下次需要建立 HTTPS 连接时，直接 <u>**复用**</u> 这个密钥，就可以减少 TLS 握手的性能损耗了。这种方式就是会话复用（_TLS session resumption_），会话复用分为两种：{{< font "orange" "Session ID" >}} 和 {{< font "red" "Session Ticket" >}}。

#### 5.6.1 Session ID

Session ID 的工作原理是，客户端和服务器首次 TLS 握手连接后，双方会在内存缓存会话密钥，并用唯一的 Session ID 来标识，Session ID 和会话密钥相当于 key-value 的关系。

当客户端再次连接时，hello 消息里会带上 Session ID，服务器收到后就会从内存找，如果找到就直接用该会话密钥恢复会话状态，跳过其余的过程，只用一个消息往返就可以建立安全通信。当然为了安全性，内存中的会话密钥会定期失效。

{{< image "/images/docs/interview/http/session-id.webp" "Session ID" >}}

{{< callout type="warning" >}}
但是它有两个缺点：

- 服务器必须保持每一个客户端的会话密钥，随着客户端的增多，服务器的内存压力也会越大；
- 现在网站服务一般是由多台服务器通过负载均衡提供服务的，客户端再次连接不一定会命中上次访问过的服务器，于是还要走完整的 TLS 握手过程；
  {{< /callout >}}

#### 5.6.2 Session Ticket

为了解决 Session ID 的问题，就出现了 Session Ticket，<u>服务器不再缓存每个客户端的会话密钥，而是把缓存的工作交给了客户端</u>，类似于 HTTP 的 Cookie。

客户端与服务器首次建立连接时，服务器会加密 <u>会话密钥</u> 作为 Ticket 发给客户端，交给客户端缓存该 Ticket。

客户端再次连接服务器时，客户端会发送 Ticket，服务器解密后就可以获取上一次的会话密钥，然后验证有效期，如果没问题，就可以恢复会话了，开始加密通信。

{{< image "/images/docs/interview/http/session-ticket.webp" "Session Ticket" >}}

- 对于集群服务器的话，要确保每台服务器加密 **会话密钥** 的密钥是一致的，这样客户端携带 Ticket 访问任意一台服务器时，都能恢复会话；
- Session ID 和 Session Ticket 都不具备前向安全性，因为一旦加密 **会话密钥** 的密钥被破解或者服务器泄漏 **会话密钥**，前面劫持的通信密文都会被破解；
- 同时应对重放攻击也很困难；

重放攻击的危险之处在于，如果中间人截获了某个客户端的 Session ID 或 Session Ticket 以及 POST 报文，而一般 POST 请求会改变数据库的数据，中间人就可以利用此截获的报文，不断向服务器发送该报文，这样就会导致数据库的数据被中间人改变了，而客户是不知情的。

避免重放攻击的方式就是需要对会话密钥设定一个合理的过期时间。

#### 5.6.3 Pre-shared Key

Session ID 和 Session Ticket 方式都需要在 1 RTT 才能恢复会话。对于重连 TLS1.3 只需要 0 RTT，原理和 Ticket 类似，只不过在重连时，客户端会把 Ticket 和 HTTP 请求一同发送给服务端，这种方式叫 Pre-shared Key。
{{< image "/images/docs/interview/http/preshared-key.webp" "Pre-shared Key">}}

同样的，Pre-shared Key 也有重放攻击的危险。
{{< image "/images/docs/interview/http/preshared-key-attack.webp" "Pre-shared Ket Attack" >}}

假设中间人通过某种方式，截获了客户端使用会话重用技术的 POST 请求，通常 POST 请求是会改变数据库的数据，然后中间人就可以把截获的这个报文发送给服务器，服务器收到后，也认为是合法的，于是就恢复会话，致使数据库的数据又被更改，但是此时用户是不知情的。

所以，应对重放攻击可以给会话密钥设定一个合理的过期时间，以及只针对安全的 HTTP 请求如 GET/HEAD 使用会话重用。

### 5.7 总结

## 6.HTTP<font style="color:#f59e0b;">2</font>的优势

- HTTP/1.1 协议的性能问题
- 兼容 HTTP/1.1
- 头部压缩
- 二进制帧
- 并发传输
- 服务器主动推送资源

### 6.1 HTTP/1.1 协议的性能问题

现在的站点相比以前变化太多了，比如：

- 消息的大小变大了，从几 KB 大小的消息，到几 MB 大小的消息；
- 页面资源变多了，从每个页面不到 10 个的资源，到每页超 100 多个资源；
- 内容形式变多样了，从单纯到文本内容，到图片、视频、音频等内容；
- 实时性要求变高了，对页面的实时性要求的应用越来越多；

这些变化带来的最大性能问题就是 HTTP/1.1 的高延迟，延迟高必然影响的就是用户体验。主要原因如下几个：

- 延迟难以下降，虽然现在网络的「带宽」相比以前变多了，但是延迟降到一定幅度后，就很难再下降了，说白了就是到达了延迟的下限；
- 并发连接有限，谷歌浏览器与每台主机最大并发连接数是 6 个，而且每一个连接都要经过 TCP 和 TLS 握手耗时，以及 TCP 慢启动过程给流量带来的影响；
- 队头阻塞问题，同一连接只能在完成一个 HTTP 事务（请求和响应）后，才能处理下一个事务；
- HTTP 头部巨大且重复，由于 HTTP 协议是无状态的，每一个请求都得携带 HTTP 头部，特别是对于有携带 Cookie 的头部，而 Cookie 的大小通常很大；
- 不支持服务器推送消息，因此当客户端需要获取通知时，只能通过定时器不断地拉取消息，这无疑浪费大量了带宽和服务器资源。

一些关键的地方是没法优化的，比如`请求-响应模型`、`头部巨大且重复`、`并发连接耗时`、`服务器不能主动推送`等，要改变这些必须重新设计 HTTP 协议，于是 HTTP/2 就出来了！

### 6.2 兼容 HTTP/1.1

HTTP/2 出来的目的是为了改善 HTTP 的性能。协议升级有一个很重要的地方，就是要兼容老版本的协议，否则新协议推广起来就相当困难，所幸 HTTP/2 做到了兼容 HTTP/1.1。
HTTP/2 是怎么做的呢？

{{% steps %}}

<h5>第一步</h5>

HTTP/2 没有在 URI 里引入新的协议名，仍然用 **_http://_** 表示明文协议，用 **_https://_** 表示加密协议，于是只需要 <u>浏览器</u> 和 <u>服务器</u> 在背后自动升级协议，这样可以让用户意识不到协议的升级，很好的实现了协议的平滑升级。

<h5>第二步</h5>

只在应用层做了改变，还是基于 TCP 协议传输，应用层方面为了保持功能上的兼容，HTTP/2 把 HTTP 分解成了 **语义** 和 **语法** 两个部分，**语义** 层不做改动，与 HTTP/1.1 完全一致，比如请求方法、状态码、头字段等规则保留不变。
{{% /steps %}}

{{< callout type="warning" >}}
但是，HTTP/2 在 **语法** 层面做了很多改造，基本改变了 HTTP 报文的传输格式。
{{< /callout >}}

### 6.3 头部压缩

HTTP 协议的报文是由 `Header` + `Body` 构成的，对于 **Body** 部分，HTTP/1.1 协议可以使用头字段 **_Content-Encoding_** 指定 Body 的压缩方式，比如用 {{< font "green" "gzip">}} 压缩，这样可以节约带宽，但报文中的另外一部分 Header，是没有针对它的优化手段。

HTTP/1.1 报文中 Header 部分存在的问题：
{{< tabs items="😪 问题1,😮‍💨 问题2,🥱 问题3">}}
{{< tab >}}
含很多固定的字段，比如 `Cookie`、`User Agent`、`Accept` 等，这些字段加起来也高达几百字节甚至上千字节，所以有必要压缩；
{{< /tab >}}

{{< tab >}}
大量的请求和响应的报文里有很多字段值都是重复的，这样会使得大量带宽被这些冗余的数据占用了，所以有必须要避免重复性；
{{< /tab >}}

{{< tab >}}
字段是 ASCII 编码的，虽然易于人类观察，但效率低，所以有必要改成二进制编码；
{{< /tab >}}
{{< /tabs>}}

{{< callout type="info" >}}
HTTP/2 对 **_Header_** 部分做了大改造，把以上的问题都解决了。
{{< /callout >}}

HTTP/2 没使用常见的 {{< font "red" "gzip">}} 压缩方式来压缩头部，而是开发了 {{< font "green" "HPACK">}} 算法，HPACK 算法主要包含三个组成部分：
{{< font "orange" "静态字典">}}、
{{< font "red" "动态字典">}}、
{{< font "green" "Huffman 编码（压缩算法）">}}；

客户端和服务器两端都会建立和维护 {{< font type="blue" text="字典">}}，用长度较小的索引号表示重复的字符串，再用 Huffman 编码压缩数据，{{< font type="blue" text="可达到 50%~90% 的高压缩率。">}}

#### 6.3.1 静态表编码

HTTP/2 为高频出现在头部的字符串和字段建立了一张 {{< font type="blue" text="静态表" >}}，它是写入到 HTTP/2 框架里的，不会变化的，静态表里共有 61 组，如下图：
|Index|Header Name|Header Value|
|---|---|---|
|1|:authority||
|2|:method|GET|
|3|:method|POST|
|4|:path|/|
|5|:path|/index.html|
|6|:scheme|http|
|7|:scheme|https|
|8|:status|200|
|...|...|...|
|54|server||
|55|set-cookie||
|56|strict-transport-security|
|57|transfer-encoding|
|58|user-agent||
|59|vary||
|60|via||
|61|www-authenticate||

表中的 Index 表示索引（Key），Header Value 表示索引对应的 Value，Header Name 表示字段的名字，比如 Index 为 2 代表 GET，Index 为 8 代表状态码 200。

{{< callout type="error" >}}
表中有的 Index 没有对应的 Header Value，这是因为这些 Value 并不是固定的而是变化的，这些 Value 都会经过 Huffman 编码后，才会发送出去。
{{< /callout >}}

以 server 头部字段为例，在 HTTP/1.1 的形式如下：

```yaml
server: nghttpx\r\n
```

算上冒号空格和末尾的\r\n，共占用了 **17** 字节，而 {{< font type="blue" text="使用了静态表和 Huffman 编码，可以将它压缩成 8 字节，压缩率大概 47%。" >}}

抓了个 HTTP/2 协议的网络包，从下图看到，高亮部分就是 server 头部字段，只用了 8 个字节来表示 server 头部数据。

{{< image "/images/docs/interview/http/http2协议网络包.webp" "http2协议网络包">}}

根据 **RFC7541** 规范，如果头部字段属于静态表范围，并且 Value 是变化，那么它的 HTTP/2 头部前 2 位固定为 01，所以整个头部格式如下图：

{{< image "/images/docs/interview/http/http2头部字段静态范围格式.webp" "http2头部字段静态范围格式" >}}

HTTP/2 头部由于基于二进制编码，就不需要冒号空格和末尾的\r\n 作为分隔符，于是改用表示字符串长度（Value Length）来分割 Index 和 Value。

{{< callout type="info" >}}
**为什么基于二进制编码就不需要冒号空格和末尾的\r\n 作为分隔符？**

Http1.1 头部采用 `冒号空格` 和 `\r\n` 来分割不同的 key-value 以及正确读取 key 和 value，而在 Http2 中改用 Value Length 来分割 Index 和 Value，可以根据 Index 去静态表 或者 动态表检索到 key，根据 Value Length 可以读取指定长度的 value。
{{< /callout >}}

接下来，根据这个头部格式来分析上面抓包的 server 头部的二进制数据。

{{< callout >}}

- 首先，从静态表中能查到 server 头部字段的 Index 为 54，二进制为 110110，再加上固定 01，头部格式第 1 个字节就是 01110110，这正是上面抓包标注的红色部分的二进制数据。
- 然后，第二个字节的首个比特位表示 Value 是否经过 Huffman 编码，剩余的 7 位表示 Value 的长度，比如这次例子的第二个字节为 10000110，首位比特位为 1 就代表 Value 字符串是经过 Huffman 编码的，<u>经过 Huffman 编码的 Value 长度为 **6**</u>。
- 最后，字符串 nghttpx 经过 Huffman 编码后压缩成了 6 个字节，Huffman 编码的原理是将高频出现的信息用 <u>**较短**</u> 的编码表示，从而缩减字符串长度。
  {{< /callout>}}

于是，在统计大量的 HTTP 头部后，HTTP/2 根据出现频率将 ASCII 码编码为了 Huffman 编码表，可以在 RFC7541 文档找到这张静态 Huffman 表，就不把表的全部内容列出来了，只列出字符串 nghttpx 中每个字符对应的 Huffman 编码，如下图：
|原字符|Huffman 编码|
|---|---|
|n|101010|
|g|100110|
|h|100111|
|t|01001|
|p|101011|
|x|1111001|

通过查表后，字符串 nghttpx 的 Huffman 编码在下图看到，共 6 个字节，每一个字符的 Huffman 编码，用相同的颜色将他们对应起来了，最后的 7 位是补位的。
{{< image "/images/docs/interview/http/nghttpx-huffman.webp" "nghttpx huffman编码" >}}

最终，server 头部的二进制数据对应的静态头部格式如下：
{{< image "/images/docs/interview/http/nghttpx-server-header.webp" "nghttpx-server-header" >}}

#### 6.3.2 动态表编码

静态表只包含了 61 种高频出现在头部的字符串，不在静态表范围内的头部字符串就要自行构建 **动态表**，它的 Index 从 62 起步，会在编码解码的时候随时更新。

比如，第一次发送时头部中的 **User-Agent** 字段数据有上百个字节，经过 Huffman 编码发送出去后，客户端和服务器双方都会更新自己的动态表，添加一个新的 Index 号 62。那么在下一次发送的时候，就不用重复发这个字段的数据了，只用发 1 个字节的 Index 号就好了，因为双方都可以根据自己的动态表获取到字段的数据。

所以，使得动态表生效有一个前提：必须同一个连接上，重复传输完全相同的 HTTP 头部。如果消息字段在 1 个连接上只发送了 1 次，或者重复传输时，字段总是略有变化，动态表就无法被充分利用了。因此，随着在同一 HTTP/2 连接上发送的报文越来越多，客户端和服务器双方的「字典」积累的越来越多，理论上最终每个头部字段都会变成 1 个字节的 Index，这样便避免了大量的冗余数据的传输，大大节约了带宽。

理想很美好，现实很骨感。动态表越大，占用的内存也就越大，如果占用了太多内存，是会影响服务器性能的，因此 Web 服务器都会提供类似 http2_max_requests 的配置，用于限制一个连接上能够传输的请求数量，避免动态表无限增大，请求数量到达上限后，就会关闭 HTTP/2 连接来释放内存。

综上，HTTP/2 头部的编码通过「静态表、动态表、Huffman 编码」共同完成的。
{{< image "/images/docs/interview/http/http2-动态表.webp" "Http2 动态表" >}}

### 6.4 二进制帧

HTTP/2 厉害的地方在于将 HTTP/1 的文本格式改成二进制格式传输数据，极大提高了 HTTP 传输效率，而且二进制数据使用位运算能高效解析。
{{< image "/images/docs/interview/http/http1-vs-http2-response.webp" "HTTP/1.1 响应和 HTTP/2 的区别" >}}

HTTP/2 把响应报文划分成了两类帧（Frame），图中的 **HEADERS**（首部）和 **DATA**（消息负载） 是帧的类型，也就是说一条 HTTP 响应，划分成了两类帧来传输，并且采用二进制来编码。

比如状态码 200 ，在 HTTP/1.1 是用 '2''0''0' 三个字符来表示（二进制：00110010 00110000 00110000），共用了 3 个字节，如下图
{{< image "/images/docs/interview/http/http1-状态码.webp" "Http1 状态码" >}}

在 HTTP/2 对于状态码 200 的二进制编码是 10001000，只用了 1 字节就能表示，相比于 HTTP/1.1 节省了 2 个字节，如下图：
{{< image "/images/docs/interview/http/http2-状态码.webp" "Http2 状态码" >}}

Header: :status: 200 OK 的编码内容为：1000 1000，那么表达的含义是什么呢？
{{< image "/images/docs/interview/http/http2-status-二进制编码.webp" "Http2 Status-200 二进制编码" >}}

> - 最前面的 1 标识该 Header 是静态表中已经存在的 KV。
> - 回顾一下之前的静态表内容，“:status: 200 OK”其静态表编码是 8，即 1000。

因此，整体加起来就是 1000 1000。

{{< image "/images/docs/interview/http/HTTP-2二进制帧的结构.webp" "HTTP/2二进制帧的结构图" >}}

帧头（Frame Header）很小，只有 9 个字节，帧开头的前 3 个字节表示帧数据（Frame Playload）的长度。
{{< callout >}}
🙋 **为什么需要用 3 个字节表示帧数据（Frame Playload）的长度？**

🧑‍🏫

- **兼顾灵活性与资源节约**：3 个字节为帧长度提供了足够的表示空间，能够支持的最大帧长度为 16,777,215 字节（即 2^24 - 1 字节）。这对于大多数应用场景来说已经是一个非常大的容量了，能够满足传输大型数据帧的需求。同时，与使用 4 个字节相比，这种设计在不牺牲太多表示能力的前提下，减少了协议的开销，尤其是在网络条件较差或者数据传输需要高效率时更为显著。
- **性能考虑**：在网络通信中，每个字节的开销都是需要被考虑的。使用 3 个字节而非更多字节可以减少每个帧的额外负载，从而提高传输效率。特别是对于那些小数据包的传输，能有效降低整体的带宽消耗。
- **未来扩展性与兼容性**：虽然目前大部分应用可能不需要如此大的帧长度，但预留足够的空间可以为未来潜在的需求或者协议扩展提供支持。同时，这种设计考虑到了向后兼容性，使得 HTTP/2 能够在未来发展过程中，更加灵活地适应新的技术和需求变化。
- **优化解析与处理速度**：在实际的网络协议实现中，处理字节数据的效率至关重要。3 个字节长度的选择，既保证了足够的数据容量，又能够被快速地解析处理，这有助于提升整个协议的执行效率，尤其是在高性能的服务器和客户端应用中。

{{< /callout >}}

帧长度后面的一个字节是表示帧的类型，HTTP/2 总共定义了 10 种类型的帧，一般分为数据帧和控制帧两类，如下表格：
{{< image "/images/docs/interview/http/帧的类型.webp" "帧的类型" >}}

帧类型后面的一个字节是 {{< font "blue" "标志位" >}}，可以保存 8 个标志位，用于携带简单的控制信息，比如：

- {{< font "blue" "END_HEADERS" >}}：表示头数据结束标志，相当于 HTTP/1 里头后的空行（“\r\n”）；
- {{< font "blue" "END_Stream" >}}：表示单方向数据发送结束，后续不会再有数据帧。
- {{< font "blue" "PRIORITY" >}}：表示流的优先级；

帧头的最后 4 个字节是 {{< font "blue" "流标识符" >}}（Stream ID），但最高位被保留不用，只有 31 位可以使用，因此流标识符的最大值是 2^31，大约是 21 亿，它的作用是用来标识该 Frame 属于哪个 Stream，接收方可以根据这个信息从乱序的帧里找到相同 Stream ID 的帧，从而有序组装信息。

最后面就是 {{< font "blue" "帧数据" >}} 了，它存放的是通过 {{< font "blue" "HPACK 算法" >}} 压缩过的 HTTP 头部和包体。

### 6.5 并发传输

HTTP/1.1 的实现是基于`请求-响应模型`的。同一个连接中，HTTP 完成一个事务（请求与响应），才能处理下一个事务，也就是说在发出请求等待响应的过程中，是没办法做其他事情的，如果响应迟迟不来，那么后续的请求是无法发送的，也造成了 {{< font "blue" "队头阻塞" >}} 的问题。

而 HTTP/2 通过 Stream 的设计，多个 Stream 复用一条 TCP 连接，达到并发的效果，解决了 HTTP/1.1 队头阻塞的问题，提高了 HTTP 传输的吞吐量。

先来理解
{{< image "/images/docs/interview/http/http2-stream-message-frame.webp" "HTTP/2 中的 Stream、Message、Frame 这 3 个概念" >}}

可以从上图中看到：

- 1 个 TCP 连接包含一个或者多个 Stream，Stream 是 HTTP/2 并发的关键技术；
- Stream 里可以包含 1 个或多个 Message，Message 对应 HTTP/1 中的请求或响应，由 HTTP 头部和包体构成；
- Message 里包含一条或者多个 Frame，Frame 是 HTTP/2 最小单位，以二进制压缩格式存放 HTTP/1 中的内容（头部和包体）；

因此，可以得出个结论：多个 Stream 跑在一条 TCP 连接，同一个 HTTP 请求与响应是跑在同一个 Stream 中，HTTP 消息可以由多个 Frame 构成， 一个 Frame 可以由多个 TCP 报文构成。
{{< image "/images/docs/interview/http/http2-stream-parallel.webp" "http2-stream-parallel" >}}

在 HTTP/2 连接上，{{< font "orange" "不同 Stream 的帧是可以乱序发送的" >}}（因此可以并发不同的 Stream ），因为每个帧的头部会携带 Stream ID 信息，所以接收端可以通过 Stream ID 有序组装成 HTTP 消息，而{{< font "orange" "同一 Stream 内部的帧必须是严格有序的" >}}。

如下图，服务端并行交错地发送了两个响应： Stream 1 和 Stream 3，这两个 Stream 都是跑在一个 TCP 连接上，客户端收到后，会根据相同的 Stream ID 有序组装成 HTTP 消息。
{{< image "/images/docs/interview/http/http2多路复用.webp" "http2多路复用" >}}

客户端和服务器双方都可以建立 Stream，因为服务端可以主动推送资源给客户端， {{< font "blue" "客户端" >}}建立的 Stream 必须是**奇数号**，而{{< font "green" "服务器" >}}建立的 Stream 必须是**偶数号**。

如下图，Stream 1 是客户端向服务端请求的资源，属于客户端建立的 Stream，所以该 Stream 的 ID 是奇数（数字 1）；Stream 2 和 4 都是服务端主动向客户端推送的资源，属于服务端建立的 Stream，所以这两个 Stream 的 ID 是偶数（数字 2 和 4）。

{{< image "/images/docs/interview/http/http2-stream-server-push.webp" "http2-stream-exhaust" >}}

同一个连接中的 Stream ID 是不能复用的，只能顺序递增，所以当 Stream ID 耗尽时，需要发一个控制帧 `GOAWAY`，用来关闭 TCP 连接。

在 Nginx 中，可以通过 http2_max_concurrent_Streams 配置来设置 Stream 的上限，默认是 128 个。

HTTP/2 通过 Stream 实现的并发，比 HTTP/1.1 通过 TCP 连接实现并发要好的多，因为当 HTTP/2 实现 100 个并发 Stream 时，只需要建立一次 TCP 连接，而 HTTP/1.1 需要建立 100 个 TCP 连接，每个 TCP 连接都要经过 TCP 握手、慢启动以及 TLS 握手过程，这些都是很耗时的。

HTTP/2 还可以对每个 Stream 设置不同 {{< font "blue" "优先级" >}}，帧头中的 {{< font "red" "标志位" >}} 可以设置优先级，比如客户端访问 HTML/CSS 和图片资源时，希望服务器先传递 HTML/CSS，再传图片，那么就可以通过设置 Stream 的优先级来实现，以此提高用户体验。

### 6.6 服务器主动推送资源

HTTP/1.1 不支持服务器主动推送资源给客户端，都是由客户端向服务器发起请求后，才能获取到服务器响应的资源。

比如，客户端通过 HTTP/1.1 请求从服务器那获取到了 HTML 文件，而 HTML 可能还需要依赖 CSS 来渲染页面，这时客户端还要再发起获取 CSS 文件的请求，需要两次消息往返，如下图左边部分：

{{< image "/images/docs/interview/http/http1.1-get-static-resource.webp" "Http1.1 versus Http2 When Get Resource" >}}

如上图右边部分，在 HTTP/2 中，客户端在访问 HTML 时，服务器可以直接主动推送 CSS 文件，减少了消息传递的次数。
在 Nginx 中，如果你希望客户端访问 /test.html 时，服务器直接推送 /test.css，可以这么配置：

```
location /test.html {
  http2_push /test.css;
}
```

<h5>HTTP/2 的推送是怎么实现的？</h5>

客户端发起的请求，必须使用的是奇数号 Stream，服务器主动的推送，使用的是偶数号 Stream。服务器在推送资源时，会通过 PUSH_PROMISE 帧传输 HTTP 头部，并通过帧中的 Promised Stream ID 字段告知客户端，接下来会在哪个偶数号 Stream 中发送包体。
{{< image "/images/docs/interview/http/http2-server-push-resource.webp" "http2-server-push-resource" >}}
如上图，在 Stream 1 中通知客户端 CSS 资源即将到来，然后在 Stream 2 中发送 CSS 资源，{{< font "blue" "注意 Stream 1 和 2 是可以并发的" >}}。

### 6.7 总结

HTTP/2 协议还有很多内容，比如流控制、流状态、依赖关系等等。

{{% steps %}}

<h5>第一点</h5>

对于常见的 HTTP 头部通过 <font style="color:blue;font-weight:bold;">静态表和 Huffman 编码</font> 的方式，将体积压缩了近一半，而且针对后续的请求头部，还可以建立 <font style="color:blue;font-weight:bold;">动态表</font>，将体积压缩近 90%，大大提高了编码效率，同时节约了带宽资源。

不过，动态表并非可以无限增大， 因为动态表是会占用内存的，动态表越大，内存也越大，容易影响服务器总体的并发能力，因此服务器需要限制 HTTP/2 连接时长或者请求次数。

<h5>第二点</h5>

<font style="color:blue;font-weight:bold;">HTTP/2 实现了 Stream 并发</font>，多个 Stream 只需复用 1 个 TCP 连接，节约了 TCP 和 TLS 握手时间，以及减少了 TCP 慢启动阶段对流量的影响。不同的 Stream ID 可以并发，即使乱序发送帧也没问题，比如发送 `A 请求帧 1` ➡️ `B 请求帧 1` ➡️ `A 请求帧 2` ➡️ `B 请求帧 2`，但是同一个 Stream 里的帧必须严格有序。

另外，可以根据资源的渲染顺序来设置 Stream 的 <font style="color:blue;font-weight:bold;">优先级</font>，从而提高用户体验。

<h5>第三点</h5>

<font style="color:blue;font-weight:bold;">服务器支持主动推送资源</font>，大大提升了消息的传输性能，服务器推送资源时，会先发送 PUSH_PROMISE 帧，告诉客户端接下来在哪个 Stream 发送资源，然后用偶数号 Stream 发送资源给客户端。

{{% /steps %}}

HTTP/2 通过 Stream 的并发能力，解决了 HTTP/1 队头阻塞的问题，看似很完美了，但是 HTTP/2 还是存在“队头阻塞”的问题，只不过问题不是在 HTTP 这一层面，而是在 TCP 这一层。

**HTTP/2 是基于 TCP 协议来传输数据的，TCP 是字节流协议，TCP 层必须保证收到的字节数据是完整且连续的，这样内核才会将缓冲区里的数据返回给 HTTP 应用，那么当 <u>前 1 个字节数据</u> 没有到达时，后收到的字节数据只能存放在内核缓冲区里，只有等到这 1 个字节数据到达时，HTTP/2 应用层才能从内核中拿到数据，这就是 HTTP/2 队头阻塞问题。**

有没有什么解决方案呢？既然是 TCP 协议自身的问题，那干脆放弃 TCP 协议，转而使用 UDP 协议作为传输层协议，这个大胆的决定，HTTP/3 协议做了！

{{< image "/images/docs/interview/http/http1.1-https-http2-http3.webp" "Http1.1 vs Https vs Http2 vs Http3" >}}

## 7.HTTP<font style="color:#f59e0b;">3</font>

HTTP/3 现在（2022 年 5 月）还没正式推出，不过自 2017 年起，HTTP/3 已经更新到 34 个草案了，基本的特性已经确定下来了，对于包格式可能后续会有变化。所以，这次介绍只涉及特性。
{{< image "/images/docs/interview/http/http3特性.webp" "Http3特性" >}}

### 7.1 美中不足的 HTTP<font style="color:#f59e0b;">2</font>

HTTP/2 通过头部压缩、二进制编码、多路复用、服务器推送等新特性大幅度提升了 HTTP/1.1 的性能，而美中不足的是 HTTP/2 协议是基于 TCP 实现的，于是存在的缺陷有三个。

- 队头阻塞；
- TCP 与 TLS 的握手时延迟；
- 网络迁移需要重新连接；

#### 7.1.1 队头阻塞

HTTP/2 多个请求是跑在一个 TCP 连接中的，那么当 TCP 丢包时，整个 TCP 都要等待重传，那么就会阻塞该 TCP 连接中的所有请求。

如下图，Stream 2 有一个 TCP 报文丢失了，那么即使收到了 Stream 3 和 Stream 4 的 TCP 报文，应用层也是无法读取的，相当于阻塞了 Stream 3 和 Stream 4 请求。
{{< image "/images/docs/interview/http/http2-队头阻塞.webp" "http2-队头阻塞" >}}

因为 TCP 是字节流协议，TCP 层必须保证收到的字节数据是完整且有序的，如果序列号较低的 TCP 段在网络传输中丢失了，即使序列号较高的 TCP 段已经被接收了，应用层也无法从内核中读取到这部分数据，从 HTTP 视角看，就是请求被阻塞了。

举个例子，如下图：
{{< image "/images/docs/interview/http/http2-队头阻塞示例.webp" "http2-队头阻塞示例" >}}

图中发送方发送了很多个 Packet，每个 Packet 都有自己的序号，你可以认为是 TCP 的序列号，其中 Packet 3 在网络中丢失了，即使 Packet 4-6 被接收方收到后，由于内核中的 TCP 数据不是连续的，于是接收方的应用层就无法从内核中读取到，只有等到 Packet 3 重传后，接收方的应用层才可以从内核中读取到数据，这就是 HTTP/2 的队头阻塞问题，是在 TCP 层面发生的。

#### 7.1.2 TCP 与 TLS 的握手延迟

发起 HTTP 请求时，需要经过 TCP 三次握手和 TLS 四次握手（TLS 1.2）的过程，因此共需要 3 个 RTT 的时延才能发出请求数据。
{{< image "/images/docs/interview/http/tcp与tls的握手延迟.webp" "tcp与tls的握手延迟" >}}
另外，TCP 由于具有 {{< font "orange" "拥塞控制" >}} 的特性，所以刚建立连接的 TCP 会有个{{< font "red" "慢启动" >}} 的过程，它会对 TCP 连接产生 <u>减速</u> 效果。

#### 7.1.2 网络迁移需要重新链接

一个 TCP 连接是由四元组（源 IP 地址，源端口，目标 IP 地址，目标端口）确定的，这意味着如果 IP 地址或者端口变动了，就会导致需要 TCP 与 TLS 重新握手，这不利于移动设备切换网络的场景，比如 4G 网络环境切换成 WiFi。

这些问题都是 TCP 协议固有的问题，无论应用层的 HTTP/2 在怎么设计都无法逃脱。要解决这个问题，就必须 {{< font "blue" "把传输层协议替换成 UDP" >}}，这个大胆的决定，HTTP/3 做了！

### 7.2 QUIC 协议的特点

UDP 是一个简单、不可靠的传输协议，而且是 UDP 包之间是无序的，也没有依赖关系。而且，UDP 是不需要连接的，也就不需要握手和挥手的过程，所以天然的就比 TCP 快。

当然，HTTP/3 不仅仅只是简单将传输协议替换成了 UDP，还基于 UDP 协议在 **应用层** 实现了 QUIC 协议，它具有类似 TCP 的连接管理、拥塞窗口、流量控制的网络特性，相当于将不可靠传输的 UDP 协议变成“可靠”的了，所以不用担心数据包丢失的问题。

{{< callout >}}
QUIC 协议的优点有很多，比如：

- 无队头阻塞；
- 更快的连接建立；
- 连接迁移；
  {{< /callout >}}

#### 7.2.1 无队头阻塞

QUIC 协议也有类似 HTTP/2 Stream 与多路复用的概念，也是可以在同一条连接上并发传输多个 Stream，Stream 可以认为就是一条 HTTP 请求。

由于 QUIC 使用的传输协议是 UDP，UDP 不关心数据包的顺序，如果数据包丢失，UDP 也不关心。不过 QUIC 协议会保证数据包的可靠性，每个数据包都有一个序号唯一标识。当某个流中的一个数据包丢失了，即使该流的其他数据包到达了，数据也无法被 HTTP/3 读取，直到 QUIC 重传丢失的报文，数据才会交给 HTTP/3。

而其他流的数据报文只要被完整接收，HTTP/3 就可以读取到数据。这与 HTTP/2 不同，HTTP/2 只要某个流中的数据包丢失了，其他流也会因此受影响。所以，QUIC 连接上的多个 Stream 之间并没有依赖，都是独立的，某个流发生丢包了，只会影响该流，其他流不受影响。
{{< image "/images/docs/interview/http/http3-无队头阻塞.webp" "Http3 无队头阻塞" >}}

#### 7.2.2 更快的连接建立

对于 HTTP/1 和 HTTP/2 协议，TCP 和 TLS 是分层的，分别属于内核实现的传输层、OpenSSL 库实现的表示层，因此它们难以合并在一起，需要分批次来握手，先 TCP 握手，再 TLS 握手。

HTTP/3 在传输数据前虽然需要 QUIC 协议握手，这个握手过程只需要 1 RTT，握手的目的是为确认双方的 **连接 ID**，连接迁移就是基于连接 ID 实现的。

但是 HTTP/3 的 QUIC 协议并不是与 TLS 分层，而是 <u>QUIC 内部包含了 TLS，它在自己的帧会携带 TLS 里的“记录”，再加上 QUIC 使用的是 TLS 1.3，因此仅需 1 个 RTT 就可以 **同时** 完成建立连接与密钥协商，甚至在第二次连接的时候，应用数据包可以和 QUIC 握手信息（连接信息 + TLS 信息）一起发送，达到 0-RTT 的效果。</u>

如下图右边部分，HTTP/3 当会话恢复时，有效负载数据与第一个数据包一起发送，可以做到 0-RTT：
{{< image "/images/docs/interview/http/http3-quic.gif" "Http3 建立连接" >}}

#### 7.2.3 连接迁移

前面提到，基于 TCP 传输协议的 HTTP 协议，由于是通过 **四元组**（源 IP、源端口、目的 IP、目的端口）确定一条 TCP 连接。

那么当移动设备的网络从 4G 切换到 WiFi 时，意味着 IP 地址变化了，那么就必须要断开连接，然后重新建立连接，而建立连接的过程包含 TCP 三次握手和 TLS 四次握手的时延，以及 TCP 慢启动的减速过程，给用户的感觉就是网络突然卡顿了一下，因此连接的迁移成本是很高的。

而 QUIC 协议没有用四元组的方式来“绑定”连接，而是通过连接 ID 来标记通信的两个端点，客户端和服务器可以各自选择一组 ID 来标记自己，因此即使移动设备的网络变化后，导致 IP 地址变化了，只要仍保有上下文信息（比如连接 ID、TLS 密钥等），就可以“无缝”地复用原连接，消除重连的成本，没有丝毫卡顿感，达到了连接迁移的功能

### 7.3 HTTP<font style="color:#f59e0b;">/3 协议</font>

HTTP/3 同 HTTP/2 一样采用二进制帧的结构，不同的地方在于 HTTP/2 的二进制帧里需要定义 Stream，而 HTTP/3 自身不需要再定义 Stream，直接使用 QUIC 里的 Stream，于是 HTTP/3 的帧的结构也变简单了。
{{< image "/images/docs/interview/http/http2-vs-http3-帧格式.webp" "Http2 vs Http3 帧格式" >}}
HTTP/3 帧头只有两个字段：类型和长度。根据帧类型的不同，大体上分为数据帧和控制帧两大类，Headers 帧（HTTP 头部）和 DATA 帧（HTTP 包体）属于数据帧。

HTTP/3 在头部压缩算法这一方面也做了升级，升级成了 QPACK。与 HTTP/2 中的 HPACK 编码方式相似，HTTP/3 中的 QPACK 也采用了静态表、动态表及 Huffman 编码。

对于静态表的变化，HTTP/2 中的 HPACK 的静态表只有 61 项，而 HTTP/3 中的 QPACK 的静态表扩大到 91 项。

HTTP/2 和 HTTP/3 的 Huffman 编码并没有多大不同，但是动态表编解码方式不同。所谓的动态表，在首次请求-响应后，双方会将未包含在静态表中的 Header 项更新各自的动态表，接着后续传输时仅用 1 个数字表示，然后对方可以根据这 1 个数字从动态表查到对应的数据，就不必每次都传输长长的数据，大大提升了编码效率。

可以看到，动态表是具有时序性的，如果首次出现的请求发生了丢包，后续的收到请求，对方就无法解码出 HPACK 头部，因为对方还没建立好动态表，因此后续的请求解码会阻塞到首次请求中丢失的数据包重传过来。

HTTP/3 的 QPACK 解决了这一问题，那它是如何解决的呢？

QUIC 会有两个特殊的单向流，所谓的单向流只有一端可以发送消息，双向则指两端都可以发送消息，传输 HTTP 消息时用的是双向流，这两个单向流的用法：

- 一个叫 QPACK Encoder Stream，用于将一个字典（Key-Value）传递给对方，比如面对不属于静态表的 HTTP 请求头部，客户端可以通过这个 Stream 发送字典；
- 一个叫 QPACK Decoder Stream，用于响应对方，告诉它刚发的字典已经更新到自己的本地动态表了，后续就可以使用这个字典来编码了。

这两个特殊的单向流是用来同步双方的动态表，编码方收到解码方更新确认的通知后，才使用动态表编码 HTTP 头部。

### 7.4 总结

{{< tabs items="🧐 HTTP/2缺陷,🤪 QUIC协议特点" >}}
{{< tab >}}
HTTP/2 虽然具有多个流并发传输的能力，但是传输层是 TCP 协议，于是存在以下缺陷：

- <font style="color:blue;font-weight:bold;">队头阻塞</font>，HTTP/2 多个请求跑在一个 TCP 连接中，如果序列号较低的 TCP 段在网络传输中丢失了，即使序列号较高的 TCP 段已经被接收了，应用层也无法从内核中读取到这部分数据，从 HTTP 视角看，就是多个请求被阻塞了；
- <font style="color:blue;font-weight:bold;">TCP 和 TLS 握手时延</font>，TCP 三次握手和 TLS 四次握手，共有 3-RTT 的时延；
- <font style="color:blue;font-weight:bold;">连接迁移需要重新连接</font>，移动设备从 4G 网络环境切换到 WiFi 时，由于 TCP 是基于四元组来确认一条 TCP 连接的，那么网络环境变化后，就会导致 IP 地址或端口变化，于是 TCP 只能断开连接，然后再重新建立连接，切换网络环境的成本高；

HTTP/3 就将传输层从 TCP 替换成了 UDP，并在 UDP 协议上开发了 QUIC 协议，来保证数据的可靠传输。
{{< /tab >}}

{{< tab >}}
QUIC 协议的特点：

- <font style="color:blue;font-weight:bold;">无队头阻塞</font>，QUIC 连接上的多个 Stream 之间并没有依赖，都是独立的，也不会有底层协议限制，某个流发生丢包了，只会影响该流，其他流不受影响；
- <font style="color:blue;font-weight:bold;">建立连接速度快</font>，因为 QUIC 内部包含 TLS 1.3，因此仅需 1 个 RTT 就可以「同时」完成建立连接与 TLS 密钥协商，甚至在第二次连接的时候，应用数据包可以和 QUIC 握手信息（连接信息 + TLS 信息）一起发送，达到 0-RTT 的效果。
- <font style="color:blue;font-weight:bold;">连接迁移</font>，QUIC 协议没有用四元组的方式来“绑定”连接，而是通过「连接 ID 」来标记通信的两个端点，客户端和服务器可以各自选择一组 ID 来标记自己，因此即使移动设备的网络变化后，导致 IP 地址变化了，只要仍保有上下文信息（比如连接 ID、TLS 密钥等），就可以“无缝”地复用原连接，消除重连的成本；

另外 HTTP/3 的 QPACK 通过两个特殊的单向流来同步双方的动态表，解决了 HTTP/2 的 HPACK 队头阻塞问题。
{{< /tab >}}
{{< /tabs >}}

## 8.HTTP Versus <font style="color:#f59e0b;">RPC</font>

### 8.1 TCP

作为一个程序员，假设我们需要在 A 电脑的进程发一段数据到 B 电脑的进程，我们一般会在代码里使用 Socket 进行编程。可选项一般也就 TCP 和 UDP 二选一。TCP 可靠，UDP 不可靠。

类似下面这样

```c
fd = socket(AF_INET,SOCK_STREAM,0);
```

其中 SOCK_STREAM，是指使用字节流传输数据，说白了就是 TCP 协议。在定义了 Socket 之后，就可以愉快的对这个 Socket 进行操作，比如用 `bind()` 绑定 IP 端口，用 `connect()` 发起建连。
{{< image "/images/docs/interview/http/tcp-build-connection-process.gif" "TCP 建立连接过程" >}}

在连接建立之后，就可以使用 send() 发送数据，recv() 接收数据。光这样一个纯裸的 TCP 连接，就可以做到收发数据了，那是不是就够了？不行，这么用会有问题。

### 8.2 裸 TCP 的问题

TCP 是有三个特点，面向连接、可靠、基于字节流。

{{< image "/images/docs/interview/http/tcp-features.webp" "TCP 特点" >}}

字节流可以理解为一个双向的通道里流淌的数据，这个数据其实就是我们常说的二进制数据，简单来说就是一大堆 01 串。纯裸 TCP 收发的这些 01 串之间是没有任何边界的，根本不知道到哪个地方才算一条完整消息。
{{< image "/images/docs/interview/http/binary-byte-stream.webp" "二进制字节流" >}}

正因为这个没有任何边界的特点，所以当使用 TCP 发送"夏洛"和"特烦恼"的时候，接收端收到的就是"夏洛特烦恼"，这时候接收端没发区分你是想要表达"夏洛"+"特烦恼"还是"夏洛特"+"烦恼"。
这就是所谓的粘包问题，这里有<a href="https://xiaolincoding.com/network/3_tcp/tcp_stream.html">文章</a>介绍。

纯裸 TCP 是不能直接拿来用的，需要在这个基础上加入一些自定义的规则，用于区分消息边界。于是我们会把每条要发送的数据都包装一下，比如加入消息头，消息头里写清楚一个完整的包长度是多少，根据这个长度可以继续接收数据，截取出来后它们就是真正要传输的消息体。

{{< font "blue" "消息头" >}} 还可以放各种东西，比如消息体是否被压缩过和消息体格式之类的，只要上下游都约定好了，互相都认就可以了，这就是所谓的 {{< font "blue" "协议" >}}。

每个使用 TCP 的项目都可能会定义一套类似这样的协议解析标准，他们可能有区别，但原理都类似。于是基于 TCP，就衍生了非常多的协议，比如 **HTTP** 和 **RPC**。

### 8.3 HTTP 和 RPC

{{< image "/images/docs/interview/http/http-and-rpc.webp" "Http协议 RPC协议" >}}

TCP 是传输层的协议，而基于 TCP 造出来的 HTTP 和各类 RPC 协议，它们都只是定义了不同消息格式的应用层协议而已。

{{< tabs items="HTTP,RPC" >}}
{{< tab >}}

HTTP 协议（Hyper Text Transfer Protocol），又叫做超文本传输协议，用的比较多，平时上网在浏览器上敲个网址就能访问网页，这里用到的就是 HTTP 协议。
{{< image "/images/docs/interview/http/http-invoke.webp" "HTTP 调用" >}}

{{< /tab >}}

{{< tab >}}

RPC（Remote Procedure Call），又叫做远程过程调用。它本身并不是一个具体的协议，而是一种调用方式。

远端服务器暴露出来一个方法 `remoteFunc`，如果能像调用本地方法那样去调用它，这样就可以屏蔽掉一些网络细节，用起来更方便。

```c
res = remoteFunc(req)
```

{{< image "/images/docs/interview/http/rpc-invoke.webp" "RPC 调用" >}}

基于这个思路，出现了非常多款式的 RPC 协议，比如比较有名的 gRPC，thrift。值得注意的是，虽然大部分 RPC 协议底层使用 TCP，但实际上它们不一定非得使用 TCP，改用 UDP 或者 HTTP，其实也可以做到类似的功能。
{{< /tab >}}

{{< /tabs >}}

#### 8.3.1 既然有 HTTP 协议，为什么还要有 RPC

TCP 是 70 年代出来的协议，而 HTTP 是 90 年代才开始流行的。而直接使用裸 TCP 会有问题，可想而知，这中间这么多年有多少自定义的协议，而这里面就有 80 年代出来的 RPC。

所以该问的不是既然有 HTTP 协议为什么要有 RPC，而是为什么有 RPC 还要有 HTTP 协议。

#### 8.3.2 既然有 RPC 协议，为什么还要有 HTTP

现在电脑上装的各种联网软件，比如 xx 管家，xx 卫士，它们都作为客户端（Client）需要跟服务端（Server）建立连接收发消息，此时都会用到应用层协议，在这种 Client/Server (C/S) 架构下，它们可以使用自家造的 RPC 协议，因为它只管连自己公司的服务器就 ok 了。

但有个软件不同，浏览器（Browser），不管是 Chrome 还是 IE，它们不仅要能访问自家公司的服务器（Server），还需要访问其他公司的网站服务器，因此它们需要有个统一的标准，不然大家没法交流。于是，HTTP 就是那个时代用于统一 Browser/Server (B/S) 的协议。

也就是说在多年以前，HTTP 主要用于 B/S 架构，而 RPC 更多用于 C/S 架构。但现在其实已经没分那么清了，B/S 和 C/S 在慢慢融合。很多软件同时支持多端，比如某度云盘，既要支持网页版，还要支持手机端和 PC 端，如果通信协议都用 HTTP 的话，那服务器只用同一套就够了。而 RPC 就开始退居幕后，一般用于公司内部集群里，各个微服务之间的通讯。

<u>**如此，都用 HTTP 还用什么 RPC？**</u>

### 8.4 HTTP 和 RPC 的区别

#### 8.4.1 服务发现

首先要向某个服务器发起请求，你得先建立连接，而建立连接的前提是，你得知道 <font style="color:blue;font-weight:bold;">IP 地址和端口</font>。这个找到服务对应的 IP 端口的过程，其实就是<font style="color:blue;font-weight:bold;">服务发现</font>。

在 <font style="color:blue;font-weight:bold;">HTTP</font> 中，你知道服务的域名，就可以通过 <font style="color:blue;font-weight:bold;">DNS 服务</font>去解析得到它背后的 IP 地址，默认 80 端口。

而 <font style="color:blue;font-weight:bold;">RPC</font> 的话，就有些区别，一般会有专门的<font style="color:blue;font-weight:bold;">中间服务</font>去保存服务名和 IP 信息，比如 <font style="color:blue;font-weight:bold;">Consul 或者 Etcd，甚至是 Redis</font>。想要访问某个服务，就去这些中间服务去获得 IP 和端口信息。由于 DNS 也是服务发现的一种，所以也有基于 DNS 去做服务发现的组件，比如 <font style="color:blue;font-weight:bold;">CoreDNS</font>。

可以看出服务发现这一块，两者是有些区别，但不太能分高低。

#### 8.4.2 底层连接形式

以主流的 <font style="color:blue;font-weight:bold;">HTTP/1.1</font> 协议为例，其默认在建立底层 TCP 连接之后会一直保持这个连接（<font style="color:blue;font-weight:bold;">Keep Alive</font>），之后的请求和响应都会复用这条连接。

而 <font style="color:blue;font-weight:bold;">RPC</font> 协议，也跟 HTTP 类似，也是通过建立 TCP 长链接进行数据交互，但不同的地方在于，RPC 协议一般还会再建个<font style="color:blue;font-weight:bold;">连接池</font>，在请求量大的时候，建立多条连接放在池内，要发数据的时候就从池里取一条连接出来，<font style="color:blue;font-weight:bold;">用完放回去，下次再复用</font>，可以说非常环保。

{{< image "/images/docs/interview/http/rpc-connection-pool.webp" "RPC 连接池" >}}

由于连接池有利于提升网络请求性能，所以不少编程语言的网络库里都会给 HTTP 加个连接池，比如 Go 就是这么干的。

可以看出这一块两者也没太大区别，所以也不是关键。

#### 8.4.3 传输的内容

基于 TCP 传输的消息，说到底，无非都是<font style="color:blue;font-weight:bold;">消息头 Header 和消息体 Body</font>。

<font style="color:blue;font-weight:bold;">Header</font> 是用于标记一些特殊信息，其中最重要的是<font style="color:blue;font-weight:bold;">消息体长度</font>。

<font style="color:blue;font-weight:bold;">Body</font> 则是放我们真正需要传输的内容，而这些内容只能是二进制 01 串，毕竟计算机只认识这玩意。所以 TCP 传字符串和数字都问题不大，因为字符串可以转成编码再变成 01 串，而数字本身也能直接转为二进制。但结构体呢，我们得想个办法将它也转为二进制 01 串，这样的方案现在也有很多现成的，比如 <font style="color:blue;font-weight:bold;">Json，Protobuf</font>。

这个将结构体转为二进制数组的过程就叫<font style="color:blue;font-weight:bold;">序列化</font>，反过来将二进制数组复原成结构体的过程叫<font style="color:blue;font-weight:bold;">反序列化</font>。
{{< image "/images/docs/interview/http/struct-serialization.webp" "结构体序列化" >}}

对于主流的 HTTP/1.1，虽然它现在叫<font style="color:blue;font-weight:bold;">超文本</font>协议，支持音频视频，但 HTTP 设计初是用于做网页<font style="color:blue;font-weight:bold;">文本</font>展示的，所以它传的内容以字符串为主。Header 和 Body 都是如此。在 Body 这块，它使用 <font style="color:blue;font-weight:bold;">Json</font> 来<font style="color:blue;font-weight:bold;">序列化</font>结构体数据。

{{< image "/images/docs/interview/http/http-json-message-example.webp" "Http消息示例">}}

可以看到这里面的内容非常多的<font style="color:blue;font-weight:bold;">冗余</font>，显得<font style="color:blue;font-weight:bold;">非常啰嗦</font>。最明显的，像 Header 里的那些信息，其实如果约定好头部的第几位是 Content-Type，就<font style="color:blue;font-weight:bold;">不需要每次都真的把"Content-Type"这个字段都传过来</font>，类似的情况其实在 body 的 Json 结构里也特别明显。

而 RPC，因为它定制化程度更高，可以采用体积更小的 Protobuf 或其他序列化协议去保存结构体数据，同时也不需要像 HTTP 那样考虑各种浏览器行为，比如 302 重定向跳转啥的。<font style="color:blue;font-weight:bold;">因此性能也会更好一些，这也是在公司内部微服务中抛弃 HTTP，选择使用 RPC 的最主要原因。</font>

{{< image "/images/docs/interview/http/http-invoke-flow-diagram.webp" "HTTP" >}}
{{< image "/images/docs/interview/http/rpc-invoke-flow-diagram.webp" "RPC" >}}

当然上面说的 HTTP，其实<font style="color:blue;font-weight:bold;">特指的是现在主流使用的 HTTP/1.1</font>，HTTP/2 在前者的基础上做了很多改进，所以<font style="color:blue;font-weight:bold;">性能可能比很多 RPC 协议还要好</font>，甚至连 gRPC 底层都直接用的 HTTP/2。

### 8.5 总结

{{% steps %}}

<h5></h5>

纯裸 TCP 是能收发数据，但它是个<font style="color:blue;font-weight:bold;">无边界</font>的数据流，上层需要定义<font style="color:blue;font-weight:bold;">消息格式</font>用于定义<font style="color:blue;font-weight:bold;">消息边界</font>。于是就有了各种协议，HTTP 和各类 RPC 协议就是在 TCP 之上定义的应用层协议。

<h5></h5>

<font style="color:blue;font-weight:bold;">RPC 本质上不算是协议，而是一种调用方式</font>，而像 gRPC 和 Thrift 这样的具体实现，才是协议，它们是实现了 RPC 调用的协议。目的是希望程序员能像调用本地方法那样去调用远端的服务方法。同时 RPC 有很多种实现方式，<font style="color:blue;font-weight:bold;">不一定非得基于 TCP 协议。</font>

<h5></h5>

从发展历史来说，<font style="color:blue;font-weight:bold;">HTTP 主要用于 B/S 架构，而 RPC 更多用于 C/S 架构。但现在其实已经没分那么清了，B/S 和 C/S 在慢慢融合。</font>很多软件同时支持多端，所以对外一般用 HTTP 协议，而内部集群的微服务之间则采用 RPC 协议进行通讯。

<h5></h5>

RPC 其实比 HTTP 出现的要早，且比目前主流的 HTTP/1.1 <font style="color:blue;font-weight:bold;">性能</font> 要更好，所以大部分公司内部都还在使用 RPC。

<h5></h5>

<font style="color:blue;font-weight:bold;">HTTP/2.0</font> 在 <font style="color:blue;font-weight:bold;">HTTP/1.1</font> 的基础上做了优化，性能可能比很多 RPC 协议都要好，但由于是这几年才出来的，所以也不太可能取代掉 RPC。

{{% /steps %}}

## 9.HTTP Versus <font style="color:#f59e0b;">Websocket</font>

### 9.1 使用 HTTP 不断轮询

### 9.2 长轮询

### 9.3 什么是 WebSocket

TCP 连接的两端，同一时间里，双方都可以主动向对方发送数据。这就是所谓的全双工。

而现在使用最广泛的 HTTP/1.1，也是基于 TCP 协议的，同一时间里，客户端和服务器只能有一方主动发数据，这就是所谓的半双工。

这是由于 HTTP 协议设计之初，考虑的是看看网页文本的场景，能做到客户端发起请求再由服务器响应，就够了，根本就没考虑网页游戏这种，客户端和服务器之间都要互相主动发大量数据的场景。

所以，为了更好的支持这样的场景，需要另外一个基于 TCP 的新协议。于是新的应用层协议 WebSocket 就被设计出来了。

#### 9.3.1 建立 WebSocket 连接

平时刷网页，一般都是在浏览器上刷的，一会刷刷图文，这时候用的是 HTTP 协议，一会打开网页游戏，这时候就得切换成 WebSocket 协议。

为了兼容这些使用场景。浏览器在 TCP 三次握手建立连接之后，都统一使用 HTTP 协议先进行一次通信。

- 如果此时是普通的 HTTP 请求，那后续双方就还是老样子继续用普通 HTTP 协议进行交互，这点没啥疑问。
- 如果这时候是想建立 WebSocket 连接，就会在 HTTP 请求里带上一些特殊的 header 头，如下：

```yaml
Connection: Upgrade
Upgrade: WebSocket
Sec-WebSocket-Key: T2a6wZlAwhgQNqruZ2YUyg==\r\n
```

这些 header 头的意思是，浏览器想升级协议（Connection: Upgrade），并且想升级成 WebSocket 协议（Upgrade: WebSocket）。同时带上一段随机生成的 base64 码（Sec-WebSocket-Key），发给服务器。

如果服务器正好支持升级成 WebSocket 协议。就会走 WebSocket 握手流程，同时根据客户端生成的 base64 码，用某个公开的算法变成另一段字符串，放在 HTTP 响应的 Sec-WebSocket-Accept 头里，同时带上 101 状态码，发回给浏览器。HTTP 的响应如下：

```
HTTP/1.1 101 Switching Protocols\r\n
Sec-WebSocket-Accept: iBJKv/ALIW2DobfoA4dmr3JHBCY=\r\n
Upgrade: WebSocket\r\n
Connection: Upgrade\r\n
```

> HTTP 状态码=200（正常响应）的情况，大家见得多了。101 确实不常见，它其实是指协议切换。

#### 9.3.2 WebSocket 抓包

#### 9.3.3 WebSocket 的消息格式

数据包在 WebSocket 中被叫做帧，我们来看下它的数据格式长什么样子。
{{< image "/images/docs/interview/http/websocket-data.webp" "WebSocket数据格式" >}}

#### 9.3.4 WebSocket 的使用场景

WebSocket 完美继承了 TCP 协议的全双工能力，并且还贴心的提供了解决粘包的方案。

它适用于需要服务器和客户端（浏览器）频繁交互的大部分场景，比如网页/小程序游戏，网页聊天室，以及一些类似飞书这样的网页协同办公软件。

在使用 WebSocket 协议的网页游戏里，怪物移动以及攻击玩家的行为是服务器逻辑产生的，对玩家产生的伤害等数据，都需要由服务器主动发送给客户端，客户端获得数据后展示对应的效果。
{{< image "/images/docs/interview/http/websocket-in-games.webp" "游戏中的WebSocket" >}}

### 9.4 总结

{{% steps %}}

<h5></h5>

TCP 协议本身是<font style="color:blue;font-weight:bold;">全双工</font>的，但我们最常用的 HTTP/1.1，虽然是基于 TCP 的协议，但它是<font style="color:blue;font-weight:bold;">半双工</font>的，对于大部分需要服务器主动推送数据到客户端的场景，都不太友好，因此我们需要使用支持全双工的 WebSocket 协议。

<h5></h5>

在 HTTP/1.1 里，只要客户端不问，服务端就不答。基于这样的特点，对于登录页面这样的简单场景，可以使用<font style="color:blue;font-weight:bold;">定时轮询</font>或者<font style="color:blue;font-weight:bold;">长轮询</font>的方式实现<font style="color:blue;font-weight:bold;">服务器推送</font>(comet)的效果。

<h5></h5>

对于客户端和服务端之间需要频繁交互的复杂场景，比如网页游戏，都可以考虑使用 WebSocket 协议。

<h5></h5>

WebSocket 和 socket 几乎没有任何关系，只是叫法相似。

<h5></h5>

正因为各个浏览器都支持 HTTP 协 议，所以 WebSocket 会先利用 HTTP 协议加上一些特殊的 header 头进行握手升级操作，升级成功后就跟 HTTP 没有任何关系了，之后就用 WebSocket 的数据格式进行收发数据。
{{% /steps %}}

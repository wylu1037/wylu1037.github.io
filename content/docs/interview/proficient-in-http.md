---
title: 🤩 Proficient in Http
date: 2024-03-04T08:29:52+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
width: wide
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


本文旨在全面解析HTTP协议及其在现代网络通信中的应用，涵盖了从基本概念、GET与POST请求的差异，到HTTP缓存技术和协议特性的深入探讨。文章进一步深入到HTTP1.1的优化技术，解析HTTPS中RSA和ECDHE握手过程的细节，以及如何在HTTPS环境下进行性能优化。随着网络技术的发展，本文也探讨了HTTP2和HTTP3这两个协议版本的新特性和改进点，为读者提供了对这些先进协议的深入理解。

此外，文章比较了HTTP与RPC（远程过程调用）以及HTTP与Websocket协议的不同应用场景和优缺点，为读者在选择适合自己项目的网络通信协议提供了专业的指导。通过对这些关键技术点的分析和讨论，读者将能够精通HTTP协议及其在现代Web开发中的应用，从而设计出更高效、安全的网络应用。

## 1.HTTP面试题
### 1.1 HTTP基本概念

### 1.2 GET与POST

### 1.3 HTTP缓存技术

### 1.4 HTTP特性

## 2.HTTP<font style="color:#f59e0b;">1.1</font> 优化
👨🏻‍🏫 如何优化HTTP<font style="color:#f59e0b;">1.1</font>
{{< tabs items="🤔避免发送HTTP请求, 🧐 减少请求次数, 🤯 减小响应数据大小">}}
  {{< tab >}}
    ### 缓存

    在请求静态文件的时候，由于这些文件不经常变化，因此把静态文件储起来是一种优化用户浏览体验的方法，同时也可以释放链路资源，缓解网络压力。客户端会把第一次请求以及响应的数据保存在本地磁盘上，其中将请求的 URL 作为 key，而响应作为 value，两者形成映射关系。确认缓存的有效时间通常是通过响应头的`Expires`、`Cache-Control`、`Last-Modified / If-Modified-Since`、`Etag / If-None-Match`来控制。

    #### 1.Expires

    Expires指定文件缓存的过期时间，是一个绝对时间。
    ```
    Expires: Mon, 1 Aug 2016 22:43:02 GMT
    ```

    #### 2.Cache-Control

    Cache-Control是http/1.1中引入的，指定缓存过期的相对时间，可以防止客户端的系统时间被客户修改，导致设置的 Expires 时间失效。
    ```
    Cache-Control: max-age=3600
    ```
    上面设置缓存的有效期为3600秒。客户端收到带有max-age指令的响应后，会将该资源及其接收时间记录下来。在后续请求相同资源时，客户端会检查本地缓存中的资源是否仍在max-age定义的新鲜时间内。如果是，客户端会直接使用缓存中的资源，而不是向服务器发送请求。

    > 同时存在Expires和Cache-Control时，浏览器会优先以Cache-Control为主。

    #### 3.Last-Modified / If-Modified-Since

    服务端某个文件可能会发生更新，希望客户端时不时请求服务端获取这个文件的过期状态。没有过期，不返回数据给浏览器，只返回304状态码，告诉浏览器缓存还没过期。
    这个实现就是条件请求。
    + Last-Modified (response header)
    + If-Modified-Since (request header)
    首次请求时，服务端返回携带响应头：
    ```
    Last-Modified:Mon, 01 Aug 2016 13:48:44 GMT
    ```
    下次请求时（没有设置Expires和Cache-Control），请求携带头：
    ```
    If-Modified-Since:Mon, 01 Aug 2016 13:48:44 GMT
    ```
    服务端对比文件的最后修改时间和If-Modified-Since的时间，没有修改返回304，否则返回200并携带新的资源内容。

    #### 4.Etag / If-None-Match

    条件请求的另一种实现，使用Etag。首次请求服务响应头携带`Etag`作为时间标签，下次请求时携带key为`If-None-Match`，value为`Etag`的请求头。
    服务器对比`If-None-Match`的值，没有修改返回304，否则返回200并携带新的资源内容。
  {{< /tab >}}

  {{< tab >}}
    ### 减少请求次数

    + 减少重定向次数
    + 合并请求
    + 延迟发送请求
  {{< /tab >}}

  {{< tab >}}
    ### 压缩
    + 无损压缩
    + 有损压缩  
  {{< /tab >}}
{{< /tabs >}}

## 3.HTTP<font style="color:#f59e0b;">S</font> RSA握手解析

### 3.1 TLS握手过程
http是明文传输（客户端与服务端通信的信息都是肉眼可见的，可通过抓包工具截获通信的内容），存在以下风险：
+ {{< font type="red" text="窃听风险" >}}：比如通信链路上可以获取通信内容；
+ {{< font type="red" text="篡改风险" >}}：比如强制植入垃圾广告，视觉污染；
+ {{< font type="red" text="冒充风险" >}}：比如冒充淘宝网站；


{{< image "/images/docs/interview/http/HTTPS与HTTP.png" "HTTPS Versus HTTP" >}}
> HTTPS 在 HTTP 与 TCP 层之间加入了 TLS 协议，来解决上述的风险。

### 3.2 RSA握手过程
HTTPS在进行通信前，需要先进行TLS握手。握手过程如下：
{{% details title="查看图片" closed="true" %}}
  {{< image "/images/docs/interview/http/tls握手.png" "TLS之RSA算法握手过程" >}}
{{% /details %}}

上图简要概述了 TLS 的握手过程，其中每一个「框」都是一个记录（record），记录是 TLS 收发数据的基本单位，类似于 TCP 里的 segment。多个记录可以组合成一个 TCP 包发送，所以通常经过「四个消息」就可以完成 TLS 握手，也就是需要 2个 RTT(Round Trip Time) 的时延，然后就可以在安全的通信环境里发送 HTTP 报文，实现 HTTPS 协议。


<br>
HTTPS是应用层协议，需要先完成 TCP 连接建立，然后走 TLS 握手过程后，才能建立通信安全的连接。

事实上，不同的密钥交换算法，TLS 的握手过程可能会有一些区别。

先简单介绍下密钥交换算法，考虑到性能的问题，双方在加密应用信息时使用的是 **对称加密密钥**，而对称加密密钥是不能被泄漏的，为了保证对称加密密钥的安全性，使用非对称加密的方式来保护对称加密密钥的协商，这个工作就是 **密钥交换算法** 负责的。

以最简单的 {{< hl "RSA">}} 密钥交换算法，看它的 {{<hl "TLS">}} 握手过程。

传统的 TLS 握手基本都是使用 RSA 算法来实现密钥交换的，在将 TLS 证书部署**服务端**时，证书文件其实就是服务端的公钥，会在 TLS 握手阶段传递给客户端，而服务端的私钥则一直留在服务端，一定要确保私钥不能被窃取。

在 RSA 密钥协商算法中，客户端会生成 {{<hl 随机密钥>}}，并使用服务端的公钥加密后再传给服务端。根据非对称加密算法，公钥加密的消息仅能通过私钥解密，这样服务端解密后，双方就得到了相同的密钥，再用它加密应用消息。

使用 **Wireshark** 工具抓取了用 RSA 密钥交换的 TLS 握手过程，可以从下面看到，一共经历了四次握手：
{{< image "/images/docs/interview/http/tls四次握手.webp" "tls四次握手">}}

|过程|数据数量|数据发送主体|数据|
|---|---|---|---|
|第一次握手|1|客户端|`Client Hello`|
|第二次握手|3|服务端|`Server Hello`、`Certificate`、`Server Hello Done`|
|第三次握手|3|客户端|`Client Key Exchange`、`Change Cipher Spec`、`Encrypted Handshake Message`|
|第四次握手|2|服务端|`Change Cipher Spec`、`Encrypted Handshake Message`|

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
+ 由于 WITH 单词只有一个 RSA，则说明握手时密钥交换算法和签名算法都是使用 RSA；
+ 握手后的通信使用 AES 对称算法，密钥长度 128 位，分组模式是 GCM；
+ 摘要算法 SHA256 用于消息认证和产生随机数；

前两次握手，客户端和服务端已经确认了TLS版本和使用的密码套件，客户端和服务端各自生成一个随机数，并且把随机数传递给对方。随机数是作为生成「会话密钥」的条件，所谓的会话密钥就是数据传输时，所使用的对称加密密钥。

然后，服务端为了证明自己的身份，会发送「Server Certificate」给客户端，这个消息里含有数字证书。
{{< image "/images/docs/interview/http/服务端发送certificate.webp" "服务端发送certificate">}}

随后，服务端发了「Server Hello Done」消息，目的是告诉客户端，我已经把该给你的东西都给你了，本次打招呼完毕。
{{< image "/images/docs/interview/http/serverhellodone.webp" "Server Hello Done">}}

#### 3.2.3 客户端验证证书
客户端拿到了服务端的数字证书后，如何校验该数字证书是真实有效的呢？

##### 3.2.3.1 数字证书和 CA 机构
数字证书通常包含了：
+ 公钥；
+ 持有者信息；
+ 证书认证机构（CA）的信息；
+ CA 对这份文件的数字签名及使用的算法；
+ 证书有效期；
+ 还有一些其他额外信息。

数字证书是用来认证公钥持有者的身份，以防止第三方进行冒充。就是用来告诉客户端，该服务端是否是合法的，因为只有证书合法，才代表服务端身份是可信的。{{< font type="red" text="用证书来认证公钥持有者的身份（服务端的身份）" >}}。

为了让服务端的公钥被大家信任，服务端的证书都是由 CA （Certificate Authority，证书认证机构）签名的，CA 就是网络世界里的公安局、公证中心，具有极高的可信度，所以由它来给各个公钥签名，信任的一方签发的证书，那必然证书也是被信任的。之所以要签名，是因为签名的作用可以避免中间人在获取证书时对证书内容的篡改。

##### 3.2.3.2 数字证书签发和验证流程

{{< image "/images/docs/interview/http/证书的校验.webp" "数字证书签发和验证流程">}}

{{< tabs items="CA 签发证书的过程,客户端校验服务端的数字证书的过程" >}}

  {{< tab >}}
    如上图左边部分：
  + 首先 CA 会把持有者的公钥、用途、颁发者、有效时间等信息打成一个包，然后对这些信息进行 Hash 计算，得到一个 Hash 值；
  + 然后 CA 会使用自己的私钥将该 Hash 值加密，生成 Certificate Signature，也就是 CA 对证书做了签名；
  + 最后将 Certificate Signature 添加在文件证书上，形成数字证书；
  {{< /tab >}}

  {{< tab >}}
    如上图右边部分：
    + 首先客户端会使用同样的 Hash 算法获取该证书的 Hash 值 H1；
    + 通常浏览器和操作系统中集成了 CA 的公钥信息，浏览器收到证书后可以使用 CA 的公钥解密 Certificate Signature 内容，得到一个 Hash 值 H2 ；
    + 最后比较 H1 和 H2，如果值相同，则为可信赖的证书，否则则认为证书不可信。
  {{< /tab >}}
{{< /tabs >}}

##### 3.2.3.3 证书链
但事实上，证书的验证过程中还存在一个证书信任链的问题，因为向 CA 申请的证书一般不是根证书签发的，而是由中间证书签发的，比如百度的证书，从下图你可以看到，证书的层级有三级：
{{< image "/images/docs/interview/http/baidu证书.webp" "baidu证书">}}

对于这种三级层级关系的证书的验证过程如下：

{{< tabs items="第一步,第二步,第三步" >}}
  {{< tab >}}
    客户端收到 baidu.com 的证书后，发现这个证书的签发者不是根证书，就无法根据本地已有的根证书中的公钥去验证 baidu.com 证书是否可信。于是，客户端根据 baidu.com 证书中的签发者，找到该证书的颁发机构是 “GlobalSign Organization Validation CA - SHA256 - G2”，然后向 CA 请求该中间证书。
  {{< /tab >}}

  {{< tab >}}
    请求到证书后发现 “GlobalSign Organization Validation CA - SHA256 - G2” 证书是由 “GlobalSign Root CA” 签发的，由于 “GlobalSign Root CA” 没有再上级签发机构，说明它是根证书，也就是自签证书。应用软件会检查此证书有否已预载于根证书清单上，如果有，则可以利用根证书中的公钥去验证 “GlobalSign Organization Validation CA - SHA256 - G2” 证书，如果发现验证通过，就认为该中间证书是可信的。
  {{< /tab >}}
  
  {{< tab >}}
    “GlobalSign Organization Validation CA - SHA256 - G2” 证书被信任后，可以使用 “GlobalSign Organization Validation CA - SHA256 - G2” 证书中的公钥去验证 baidu.com 证书的可信性，如果验证通过，就可以信任 baidu.com 证书。
  {{< /tab >}}
{{< /tabs >}}

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
  可以发现，***Change Cipher Spec*** 之前传输的 TLS 握手数据都是明文，之后都是对称密钥加密的密文。
{{< /callout >}}

#### 3.2.5 TLS 第四次握手
服务器也是同样的操作，发 **Change Cipher Spec** 和 **Encrypted Handshake Message** 消息，如果双方都验证加密和解密没问题，那么握手正式完成。最后，就用 {{< hl "会话密钥">}} 加解密 HTTP 请求和响应了。

### 3.3 RSA 算法的缺陷

{{< font type="blue" text="使用 RSA 密钥协商算法的最大问题是不支持前向保密。" >}}

> 前向保密（Forward Secrecy，也称作完全前向保密）是一种通过加密协议确保会话密钥的安全性的方法，即使长期密钥被泄露，也不会危及过去的通信记录。在使用前向保密的系统中，通信双方每次建立连接时都会生成一个独一无二的会话密钥用于该次会话的加密，而且这个会话密钥是在不泄露长期密钥的情况下生成的。一旦会话结束，该会话密钥就会被丢弃。这样，即使攻击者未来某一时刻获得了服务端的私钥，也无法解密之前拦截的加密通信，因为他们没有那一次通信的会话密钥。



因为客户端传递随机数（用于生成对称加密密钥的条件之一）给服务端时使用的是公钥加密的，服务端收到后，会用私钥解密得到随机数。所以一旦服务端的私钥泄漏了，过去被第三方截获的所有 TLS 通讯密文都会被破解。
为了解决这个问题，后面就出现了 ECDHE 密钥协商算法，现在大多数网站使用的正是 ECDHE 密钥协商算法。

## 4.HTTP<font style="color:#f59e0b;">S</font> ECDHE握手解析
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

### 5.2 硬件优化

### 5.3 软件优化

### 5.4 协议优化
#### 5.4.1 密钥交换算法优化
#### 5.4.2 TLS 升级

### 5.5 证书优化
#### 5.5.1 证书传输优化
#### 5.5.2 证书验证优化

### 5.6 会话复用
#### 5.6.1 Session ID 
#### 5.6.2 Session Ticket
#### 5.6.3 Pre-shared Key

### 5.7 总结

## 6.HTTP<font style="color:#f59e0b;">2</font>的优势

## 7.HTTP<font style="color:#f59e0b;">3</font>

## 8.HTTP Versus <font style="color:#f59e0b;">RPC</font>

## 9.HTTP Versus <font style="color:#f59e0b;">Websocket</font>
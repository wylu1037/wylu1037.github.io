---
title: 🤩 Proficient in Http
date: 2024-03-04T08:29:52+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
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
    ### 减少请求次数
    + 减少重定向次数
    + 合并请求
    + 延迟发送请求

  {{< tab >}}
    
  {{< /tab >}}
    + 无损压缩
    + 有损压缩
  {{< tab >}}
    
  {{< /tab >}}
{{< /tabs >}}

## 3.HTTP<font style="color:#f59e0b;">S</font> RSA握手解析

## 4.HTTP<font style="color:#f59e0b;">S</font> ECDHE握手解析

## 5.HTTP<font style="color:#f59e0b;">S</font>优化

## 6.HTTP<font style="color:#f59e0b;">2</font>

## 7.HTTP<font style="color:#f59e0b;">3</font>

## 8.HTTP Versus <font style="color:#f59e0b;">RPC</font>

## 9.HTTP Versus <font style="color:#f59e0b;">Websocket</font>
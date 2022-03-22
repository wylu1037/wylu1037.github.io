---
title: Nacos
date: 2022-03-21 12:35:48
tags:
  - Nacos
  - Spring Boot
  - Spring Cloud
categories:
  - Spring Cloud
  - Micro Service
cover: https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRifrdSe-oyWZb0aRK10r_gyhMP3BKQTmAUDA&usqp=CAU 
---

## 1.前言

:::tip

官方文档：https://nacos.io/zh-cn/docs/what-is-nacos.html

:::

Nacos 致力于发现、配置和管理微服务。Nacos 提供了一组简单易用的特性集，可快速实现动态服务发现、服务配置、服务元数据及流量管理。

Nacos 帮助您更敏捷和容易地构建、交付和管理微服务平台。 Nacos 是构建以“服务”为中心的现代应用架构 (例如微服务范式、云原生范式) 的服务基础设施。



### 1.1 下载

***Windows***: [点我开始下载](https://github.com/alibaba/nacos/releases)，`nacos-server-$version.zip` 包。

解压后，文件目录如下：

```
.
|──bin
|	|──logs
|	|──work
|	|──shutdown.cmd
|	|──shutdosn.sh
|	|──startup.cmd
|	└──startup.sh
|──conf
|──data
|──logs
|──target
|──LICENSE
└──NOTICE
```

编辑 `startup.cmd`，修改配置项 MODE 值：

```bash
# before
set MODE="cluster"

# after
set MODE="standalone"
```

运行如下命令：

```bash
cmd startup.cmd -m standalone
```

启动成功后访问服务端页面：http://localhost:8848/nacos



---

## 2.Nacos Spring Boot

### 2.1 启动配置管理

#### 2.1.1 添加依赖

+ ***Maven***

```xml
<dependency>
    <groupId>com.alibaba.boot</groupId>
    <artifactId>nacos-config-spring-boot-starter</artifactId>
    <version>${latest.version}</version>
</dependency>
```

+ ***Gradle***

```groovy
implementation 'com.alibaba.boot:nacos-config-spring-boot-starter:0.2.10'
```



#### 2.1.2 application.yaml

在 `application.yaml` 中配置 Nacos server 的地址：

```yaml
nacos:
  config:
    server-addr: 127.0.0.1:8848
```



#### 2.1.3 配置启动类

添加注解：使用 `@NacosPropertySource` 加载 `dataId` 为 `example` 的配置源，并开启自动更新：

```java
@SpringBootApplication
@NacosPropertySource(dataId = "example", autoRefreshed = true)
public class NacosConfigApplication {

    public static void main(String[] args) {
        SpringApplication.run(NacosConfigApplication.class, args);
    }
}
```



#### 2.1.4 配置值

+ 界面

<img src="/images/nacos/releaseConfiguration.png" alt="Nacos配置值"/>

+ curl

```bash
curl -X POST "http://127.0.0.1:8848/nacos/v1/cs/configs?dataId=example&group=DEFAULT_GROUP&content=message=Hello"
```



#### 2.1.5 读取值

通过 Nacos 的 `@NacosValue` 注解设置属性值。

```java
@Slf4j
@RestController
@RequestMapping(value = "/user")
@RequiredArgsConstructor(onConstructor = @__(@Autowired))
public class UserController {
    @NacosValue(value = "${message:Hello}", autoRefreshed = true)
    private String message;

    @GetMapping("getNacos")
    public BaseResult<Object> getNacosConfigHandler() {
        BaseResult<Object> baseResult = new BaseResult<>(false);
        try {
            baseResult.setSuccess(true);
            baseResult.setCode(200);
            baseResult.setData(message);
        } catch (Exception e) {
            log.error("[UserController] getNacosConfigHandler() occurred exception! ", e);
        }
        return baseResult;
    }
}
```



---

### 2.2 启动服务发现

:::tip

官方代码参考：[nacos-spring-boot-discovery-example](https://github.com/nacos-group/nacos-examples/tree/master/nacos-spring-boot-example/nacos-spring-boot-discovery-example)

:::



#### 2.2.1 添加依赖

+ ***Maven***:

```xml
<dependency>
    <groupId>com.alibaba.boot</groupId>
    <artifactId>nacos-discovery-spring-boot-starter</artifactId>
    <version>${latest.version}</version>
</dependency>
```

+ ***Gradle***:

```groovy
// https://mvnrepository.com/artifact/com.alibaba.boot/nacos-discovery-spring-boot-starter
implementation 'com.alibaba.boot:nacos-discovery-spring-boot-starter:0.2.10'
```



#### 2.2.2 application.yaml

在 `application.yaml` 中配置 Nacos server 的地址：

```yaml
nacos:
	discovery:
		server-addr: 127.0.0.1:8848
```



#### 2.2.3 注入实例

使用 `@NacosInjected` 注入 Nacos 的 `NamingService` 实例：

```java
@Controller
@RequestMapping("discovery")
public class DiscoveryController {

    @NacosInjected
    private NamingService namingService;

    @RequestMapping(value = "/get", method = GET)
    @ResponseBody
    public List<Instance> get(@RequestParam String serviceName) throws NacosException {
        return namingService.getAllInstances(serviceName);
    }
}

@SpringBootApplication
public class NacosDiscoveryApplication {

    public static void main(String[] args) {
        SpringApplication.run(NacosDiscoveryApplication.class, args);
    }
}
```



#### 2.2.4 注册服务

通过调用 [Nacos Open API](https://nacos.io/zh-cn/docs/open-api.html) 向 Nacos server 注册一个名称为 `example` 服务

```bash
curl -X PUT 'http://127.0.0.1:8848/nacos/v1/ns/instance?serviceName=example&ip=127.0.0.1&port=8080'
```



#### 2.2.5 调用接口

访问 `curl http://localhost:8080/discovery/get?serviceName=example`，此时返回内容为：

```json
[
  {
    "instanceId": "127.0.0.1-8080-DEFAULT-example",
    "ip": "127.0.0.1",
    "port": 8080,
    "weight": 1.0,
    "healthy": true,
    "cluster": {
      "serviceName": null,
      "name": "",
      "healthChecker": {
        "type": "TCP"
      },
      "defaultPort": 80,
      "defaultCheckPort": 80,
      "useIPPort4Check": true,
      "metadata": {}
    },
    "service": null,
    "metadata": {}
  }
]
```



---

## 3.Nacos Spring Cloud







---

## 4.Nacos Docker







---

## 5.Nacos Dubbo





---

## 6.Nacos k8s







---

## 7.Nacos Sync







---

## 8.运维指南

:::tip

文档：https://nacos.io/zh-cn/docs/deployment.html

:::

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

### 5.1 添加依赖

+ ***Maven***

```xml
<dependencies>

    ...

    <!-- Dubbo dependency -->
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>dubbo</artifactId>
        <version>[latest version]</version>
    </dependency>
    
    <!-- 使用Spring装配方式时可选: -->
    <dependency>
        <groupId>com.alibaba.spring</groupId>
        <artifactId>spring-context-support</artifactId>
        <version>[latest version]</version>
    </dependency>

    ...
    
</dependencies>
```



+ ***Gradle***

```groovy
// https://mvnrepository.com/artifact/com.alibaba/dubbo
implementation 'com.alibaba:dubbo:2.6.12'
```



:::tip

dubbo 与 nacos 存在版本兼容问题，各依赖最终版本如下所示，仅做参考：

+ [Nacos server](https://github.com/alibaba/nacos/releases/tag/2.0.0-bugfix): `2.0.1-bugfix(Mar 30th, 2021)`
+ nacos-config-spring-boot-starter: `0.2.1`
+ nacos-config-spring-boot-actuator: `0.2.1`
+ dubbo: `2.6.5`
+ dubbo-registry-nacos: `2.6.7`
+ nacos-client: `1.1.3`

:::



### 5.2 配置注册中心

>Dubbo官方文档：https://dubbo.apache.org/zh/docs/

采用 Dubbo Spring 外部化配置，需要是 `Dubbo 2.5.8` 之后的版本。通过 Spring Environment 属性自动地生成并绑定 Dubbo 配置 Bean，实现配置简化，并且降低微服务开发门槛。



#### 5.2.1 application.yaml

```yaml
dubbo:
  # 指定应用名称，一般为项目名
  application:
    name: kec-dubbo
  # 指定注册中心地址
  registry:
    address: nacos://192.168.1.79:8848
```



dubbo application配置项说明

应用信息配置。对应的配置类：`org.apache.dubbo.config.ApplicationConfig`

| 属性         | 对应URL参数         | 类型   | 是否必填 | 缺省值    | 作用     | 描述                                                         | 兼容性         |
| ------------ | ------------------- | ------ | -------- | --------- | -------- | ------------------------------------------------------------ | -------------- |
| name         | application         | string | **必填** |           | 服务治理 | 当前应用名称，用于注册中心计算应用间依赖关系，注意：消费者和提供者应用名不要一样，此参数不是匹配条件，你当前项目叫什么名字就填什么，和提供者消费者角色无关，比如：kylin应用调用了morgan应用的服务，则kylin项目配成kylin，morgan项目配成morgan，可能kylin也提供其它服务给别人使用，但kylin项目永远配成kylin，这样注册中心将显示kylin依赖于morgan | 1.0.16以上版本 |
| version      | application.version | string | 可选     |           | 服务治理 | 当前应用的版本                                               | 2.2.0以上版本  |
| owner        | owner               | string | 可选     |           | 服务治理 | 应用负责人，用于服务治理，请填写负责人公司邮箱前缀           | 2.0.5以上版本  |
| organization | organization        | string | 可选     |           | 服务治理 | 组织名称(BU或部门)，用于注册中心区分服务来源，此配置项建议不要使用autoconfig，直接写死在配置中，比如china,intl,itu,crm,asc,dw,aliexpress等 | 2.0.0以上版本  |
| architecture | architecture        | string | 可选     |           | 服务治理 | 用于服务分层对应的架构。如，intl、china。不同的架构使用不同的分层。 | 2.0.7以上版本  |
| environment  | environment         | string | 可选     |           | 服务治理 | 应用环境，如：develop/test/product，不同环境使用不同的缺省值，以及作为只用于开发测试功能的限制条件 | 2.0.0以上版本  |
| compiler     | compiler            | string | 可选     | javassist | 性能优化 | Java字节码编译器，用于动态类的生成，可选：jdk或javassist     | 2.1.0以上版本  |
| logger       | logger              | string | 可选     | slf4j     | 性能优化 | 日志输出方式，可选：slf4j,jcl,log4j,log4j2,jdk               | 2.2.0以上版本  |

#### 5.2.2 示例

[点击](http://localhost:8848/nacos)去服务端查看详情：

<img src="/images/nacos/serviceList.png" alt="服务列表" />
<br/>

<img src="/images/nacos/ServiceInfoDetails.png" alt="服务详情" />



### 5.3 注解使用



---

## 6.Nacos k8s







---

## 7.Nacos Sync







---

## 8.运维指南

:::tip

文档：https://nacos.io/zh-cn/docs/deployment.html

:::

---
title: Nexus3搭建与配置
date: 2022-05-27 12:29:39
tags:
  - Nexus
  - Maven
categories:
  - Maven Repository
cover: https://huongdanjava.com/wp-content/uploads/2018/12/nexus-banner-1.png
---





:::tip

官方网站：https://www.sonatype.com/products/repository-oss-download

:::

## 1.部署

Nexus全称是 Nexus Repository Manager，是Sonatype公司的一个产品。它是一个强大的仓库管理器，极大地简化了内部仓库的维护和外部仓库的访问。

Nexus不仅可以用来做 maven 的私服，还可作为nuget、docker、npm、bower、pypi、rubygems、git lfs、yum、go、apt等的私有仓库。



### 1.1 Docker部署

+ 查找镜像版本：https://hub.docker.com/r/sonatype/nexus3/

+ 拉取镜像：`docker pull sonatype/nexus3:3.35.0`

+ 编写docker-compose.yml文件

  ```yaml
  nexus_hust:
      image: sonatype/nexus3:3.35.0
      restart: always
      container_name: nexus_3.35.0
      user: root
      privileged: true
      volumes:
        - $PWD/nexus/data:/nexus-data
      environment:
        TZ: Asia/Shanghai
        INSTALL4J_ADD_VM_PARAMS: -Xms512m -Xmx512m -XX:MaxDirectMemorySize=1G -Djava.util.prefs.userRoot=/nexus-data/javaprefs
      ports:
        - 8081:8081
  ```

  + user：指定docker内启动的用户为root，nexus镜像默认用户为 nexus
  + privileged：
  + environment：指定时区，指定启动的资源大小

+ 启动：`docker-compose up -d`
+ 停止：`docker stop nexus_3.35.0 && docker rm nexus_3.3.5.0`



### 1.2 其它部署

:::tip

后续补充

:::



---

## 2.maven配置

### 2.1 settings.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0 https://maven.apache.org/xsd/settings-1.2.0.xsd">

    <!-- 指定本次仓库位置 -->
    <localRepository>D:/JetBrains Codes/repository/.java</localRepository>

    <!-- 默认值true，表示是否需要和用户交互获取输入 -->
    <interactiveMode>true</interactiveMode>

    <!-- 默认false，表示是否需要使用plugin-registry.xml文件来管理插件版本 -->
    <usePluginRegistry>false</usePluginRegistry>

    <!-- 默认false，是否在离线模式下使用 -->
    <offline>false</offline>

    <!-- <pluginGroups>
    <pluginGroup>com.your.plugins</pluginGroup>
  </pluginGroups> -->

    <!-- 配置不同的代理 -->
    <proxies>
        <!-- proxy
     | Specification for one proxy, to be used in connecting to the network.
     |
    <proxy>
      <id>optional</id>
      <active>true</active>
      <protocol>http</protocol>
      <username>proxyuser</username>
      <password>proxypass</password>
      <host>proxy.host.net</host>
      <port>80</port>
      <nonProxyHosts>local.net|some.host.com</nonProxyHosts>
    </proxy>
    -->
    </proxies>

    <!-- 服务端配置 -->
    <servers>
        <!-- 以下两个配置给pom文件中的distributionManagement中repository使用 -->
        <server>
            <!-- 此id与pom文件中distributionManagement中的id一致 -->
            <id>maven-releases</id>
            <!-- 鉴权用户名 -->
            <username>admin</username>
            <!-- 鉴权密码 -->
            <password>ahhfzkjg123</password>
        </server>
        <server>
            <id>maven-snapshots</id>
            <username>admin</username>
            <password>admin123</password>
        </server>

        <!-- id与下面profile >>> repositories >>> repository的id相同 -->
        <server>
            <id>nexus-zkjg</id>
            <username>admin</username>
            <password>admin123</password>
        </server>
    </servers>

    <!-- 为仓库列表配置的下载镜像列表，配置多个mirror时只有第一个会生效 -->
    <mirrors>
        <!-- 配置私服镜像 -->
        <mirror>
            <!-- 镜像唯一标识符 -->
            <id>nexus-zkjg</id>
            <!-- 镜像名称 -->
            <name>nexus-zkjg</name>
            <!-- 
          作用：被镜像的服务器(repository)id
          1. * 匹配所有
          2. external:* 除本地缓存后的所有仓库
          3. repo,repo1 repo 或者 repo1 指的是仓库id
          4. *,!repo1 除repo1的所有仓库
       -->
            <mirrorOf>nexus-zkjg</mirrorOf>
            <url>http://localhost:8081/repository/maven-public/</url>
        </mirror>

        <!-- 配置阿里云镜像 -->
        <mirror>
            <id>nexus-aliyun</id>
            <mirrorOf>nexus-aliyun</mirrorOf>
            <name>Nexus aliyun</name>
            <url>http://maven.aliyun.com/nexus/content/groups/public</url>
        </mirror>
    </mirrors>

    <profiles>
        <profile>
            <!-- 该配置的唯一标识符 -->
            <id>nexus-default</id>

            <!-- 远程仓库列表，下载项目依赖文件的maven仓库地址; -->
            <repositories>
                <repository>
                    <!-- 远程仓库唯一标识 -->
                    <id>nexus-zkjg</id>
                    <!-- 远程仓库名称 -->
                    <name>maven-public</name>
                    <url>http://localhost:8081/repository/maven-public/</url>
                    <!-- 处理远程仓库发布版本下载的策略 -->
                    <releases>
                        <enabled>true</enabled>
                        <!-- 
                        1.always：一直
                        2.daily：默认值，每日
                        3.interval:X (X代表以分钟为单位的时间间隔)
                        4.never：从不
                        -->
                        <updatePolicy>always</updatePolicy>
                        <!-- 
                            作用：当maven验证构件校验文件失败时怎么做
                            1.ignore：忽略
                            2.fail：失败
                            3.warn：警告
                         -->
                        <checksumPolicy>warn</checksumPolicy>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                        <updatePolicy>always</updatePolicy>
                    </snapshots>
                </repository>

                <repository>
                    <id>nexus-aliyun</id>
                    <url>http://maven.aliyun.com/nexus/content/groups/public</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
            </repositories>

            <!-- 每个pluginRepository元素指定一个从maven用来寻找新插件的远程地址 -->
            <pluginRepositories>
                <pluginRepository>
                    <id>nexus-local</id>
                    <url>http://localhost:8081/repository/maven-public/</url>
                    <releases>
                        <enabled>true</enabled>
                        <updatePolicy>always</updatePolicy>
                        <checksumPolicy>warn</checksumPolicy>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                        <updatePolicy>always</updatePolicy>
                        <checksumPolicy>warn</checksumPolicy>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>
    </profiles>

    <!-- 定义激活的profiles -->
    <activeProfiles>
        <activeProfile>nexus-default</activeProfile>
    </activeProfiles>
</settings>
```



### 2.2 pom.xml

依赖发布配置

```xml
<distributionManagement>
    <repository>
        <id>nexus-releases</id>
        <name>nexus-releases</name>
        <url>http://localhost:8081/repository/maven-releases/</url>
    </repository>
    <snapshotRepository>
        <id>nexus-snapshots</id>
        <name>nexus-snapshots</name>
        <url>http://localhost:8081/repository/maven-snapshots/</url>
    </snapshotRepository>
</distributionManagement>
```



---

## 3.Nexus管理

### 3.1 repository

Nexus的常用仓库如下所示：

| Name           | Type   | Description                                                |
| -------------- | ------ | ---------------------------------------------------------- |
| maven-central  | proxy  | 代理仓库，配置阿里镜像                                     |
| maven-release  | hosted |                                                            |
| maven-snapshot | hosted |                                                            |
| maven-public   | group  | 分组仓库，包括maven-central、maven-release、maven-snapshot |



### 3.2 用户管理


---
title: Build-Project-With-Gradle
date: 2022-11-12 11:32:36
tags:
  - Gradle
categories:
	- Build Tool
cover: https://cdn.hackersandslackers.com/2022/06/_retina/java-gradle-intro@2x.jpg
feature: true
---

Gradle是一个基于Apache Ant和Apache Maven概念的项目自动化建构工具。Gradle 构建脚本使用的是 Groovy 或 Kotlin 的特定领域语言来编写的，而不是传统的XML。当前官方支持的语言为Java、Groovy、Scala、C++、Swift、JavaScript等以及Spring框架。

## 📖Intro

依赖构建工具。



### 配置镜像源

在gradle/wrapper/gradle-wrapper.properties中修改配置。

```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-7.2-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
```

使用阿里云的地址加速，https://mirrors.aliyun.com/macports/distfiles/gradle

```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://mirrors.aliyun.com/macports/distfiles/gradle/gradle-7.2-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
```

使用腾讯云地址加速：https://mirrors.cloud.tencent.com/gradle

```properties
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://mirrors.cloud.tencent.com/gradle/gradle-7.2-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
```

## Creating Executable JAR File

### 使用SpringBoot插件

示例

```groovy
project(':baas-admin') {
    jar {
        enabled = false
    }
    bootJar {
        enabled = true
        mainClassName = 'com.zkjg.baas.admin.BaasAdminApplication'
        excludes = ["servlet-api-${rootProject.lib.servlet}.jar"]
    }
}
```

或者使用以下写法指定mainClass

```groovy
bootJar {
    manifest {
    	attributes 'Start-Class': 'com.zkjg.baas.admin.BaasAdminApplication'
    }
}
```







---

## 🪶Example

### 🍃onolithic

单体



### 🍂Multi_Service

微服务







---

## 🐳Dockerfile







---

## 🎓FAQ

### Q:plugins与apply plugin的区别

A: [stackoverflow](https://stackoverflow.com/questions/32352816/what-the-difference-in-applying-gradle-plugin)

plugins是DSL新用法，要求plugin是[Gradle plugin repository](https://plugins.gradle.org/)里面的。不支持多项目配置「subProjects、allProjects中不支持使用plugins语法，支持使用apply plugin语法」，支持构建子项目。

`apply plugin`是老用法，比较灵活。




---
title: Liquibase and Flyway
date: 2022-03-19 18:03:32
tags:
    - database
    - liquibase
    - flyway
categories:
	- 后端
cover: http://n.sinaimg.cn/translate/20170808/dGoi-fyitapp2615360.jpg
feature: true
---

## 1.概述

​[Liquibase](https://liquibase.org/get-started/quickstart) 是一个用于跟踪，管理和应用数据库变化的开源的数据库重构工具。它将所有数据库的变化(包括结构和数据) 都保存在XML文件中，便于版本控制。

:::details Click to see more

Liquibase helps teams release software faster by bringing DevOps to the database.

+ Get database code into version control: Easily order and track changes through version control. Always know when, where, and how database changes are deployed.
+ Build quality into your process early: Check database code quality before developers commit, when it’s much cheaper and easier to fix problems.
+ Work faster with the tools you already use: Collaborate efficiently with tools you already use, enabling true CI/CD for the database.

:::


## 2.特性

- 不依赖于特定的数据库，目前支持包括Oracle/Sql Server/DB2/MySql/Sybase/PostgreSQL/Caché等12种数据库，这样在数据库的部署和升级环节可帮助应用系统支持多数据库；
- 提供数据库比较功能，比较结果保存在XML中，基于该XML你可用Liquibase轻松部署或升级数据库；
- 以XML存储数据库变化，其中以作者和ID唯一标识一个变化（ChangSet），支持数据库变化的合并，因此支持多开发人员同时工作；
- 在数据库中保存数据库修改历史（DatabaseChangeHistory），在数据库升级时自动跳过已应用的变化（ChangSet）；
- 提供变化应用的回滚功能，可按时间、数量或标签（tag）回滚已应用的变化。通过这种方式，开发人员可轻易的还原数据库在任何时间点的状态；
- 可生成数据库修改文档（HTML格式）；
- 提供数据重构的独立的IDE和Eclipse插件；



## 3.整合SpringBoot

### 3.1 依赖

```xml
<dependency>
    <groupId>org.liquibase</groupId>
    <artifactId>liquibase-core</artifactId>
    <version>4.3.3</version>
</dependency>
```



### 3.2 配置类

```java
@Configuration
public class LiquibaseConfig {

    private String changeLogLocation = "classpath:liquibase/db.changelog-master.yaml";

    @Bean
    public SpringLiquibase liquibase(@Qualifier("masterDataSource") DataSource dataSource) {
        SpringLiquibase liquibase = new SpringLiquibase();
        liquibase.setDataSource(dataSource);
        //指定changelog的位置，这里使用的一个master文件引用其他文件的方式
        liquibase.setChangeLog(changeLogLocation);
        //liquibase.setContexts("development,test,production");
        liquibase.setShouldRun(true); //设置为true才会执行sql
        return liquibase;
    }
}
```



### 3.3 db.changelog-master.yml

```yaml
databaseChangeLog:
  - include:
      file: classpath:liquibase/changelog/0.1.0.release/db.changelog-0.1.0.yaml
  - include:
      file: classpath:liquibase/changelog/0.1.0.release/changelog-0.1.0.yml
```



### 3.4 db.changelog-0.1.0.yml

```yaml
databaseChangeLog:
  - changeSet:
      id: 20210714-113700
      author: luwenyang
      comment: "删除表department"
      changes:
        - sqlFile:
            encoding: utf8
            path: classpath:liquibase/changelog/0.1.0.release/deteleDepartmentTable.sql
  - changeSet:
      id: 20210714-183000
      author: luwenyang
      comment: "测试使用sql"
      changes:
        - sql:
            sql: update business set businessName = '711便利店金融港店' where businessID = 1 and deleteFlag = 0;
            rollback: update business set businessName = '金融港711便利店' where businessID = 1 and deleteFlag = 0;
```



## 4.使用

### 4.1 changelog

​changelog 是 Liquibase 进行版本管理的核心文件，Liquibase依据这个变更日志来审计数据库，并执行任何还没有应用到目标数据库的变更操作。表 `databasechangelog` 会记录已经执行的 changelog 信息，已经执行的 changelog 不会再次执行。表 `databasechangeloglock`用来加锁，保证同一时刻下只有一台服务器执行 changelog，避免多台服务器（多副本部署）执行了同一个 changelog 带来的问题。

​changelog 支持的格式包括：sql、xml、json、yaml 等。



#### 4.1.1 xml格式

```xml
<?xml version="1.0" encoding="UTF-8"?>  
 
<databaseChangeLog  
        xmlns="http://www.liquibase.org/xml/ns/dbchangelog"  
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
        xmlns:ext="http://www.liquibase.org/xml/ns/dbchangelog-ext"  
        xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-3.8.xsd
        http://www.liquibase.org/xml/ns/dbchangelog-ext http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-ext.xsd">  
 
    <!-- master文件中引用其它需要执行的sql脚本 -->
  	<include file="liquibase/changelog/init-table.xml" relativeToChangelogFile="false"/>
    
    <!--配置文件中指定程序运行时读取改文件，管理表 -->
    <changeSet id="20210714-113000" author="luwenyang">
        <comment>新增表department</comment>
        <createTable tableName="department">
            <column name="dID" type="int">
                <constraints primaryKey="true" nullable="false"></constraints>
            </column>
            <column name="dName" type="varchar(50)">
                <constraints nullable="false"></constraints>
            </column>
            <column name="address" type="varchar(255)">
                <constraints nullable="true"></constraints>
            </column>
        </createTable>
    </changeSet>
    
    <changeSet id="20210714-182500" author="luwenyang">
        <comment>删除表tcPageConfig</comment>
        <sql>
            drop table tcPageConfig;
        </sql>
        <rollback>
            create table tcPageConfig
            (
            pageId    varchar(32)  not null,
            pageTitle  varchar(128) not null,
            pageConfig text         null,
            groupName  varchar(256) null,
            primary key (pageId)
            ) engine = InnoDB
            default charset = utf8
            row_format = dynamic comment '页面配置表';
        </rollback>
    </changeSet>
</databaseChangeLog>
```



#### 4.1.2 yaml格式

```yaml
databaseChangeLog:  
  -  changeSet:  
      id:  1  
      author:  nvoxland  
      changes:  
        -  createTable:  
            tableName:  person  
            columns:  
              -  column:  
                  name:  id  
                  type:  int  
                  autoIncrement:  true  
                  constraints:  
                    primaryKey:  true  
                    nullable:  false  
              -  column:  
                  name:  firstname  
                  type:  varchar(50)  
              -  column:  
                  name:  lastname  
                  type:  varchar(50)  
                  constraints:  
                    nullable:  false  
              -  column:  
                  name:  state  
                  type:  char(2)
```



#### 4.1.3 嵌套元素

changelog 可用的嵌套元素共5类：

- preConditions：执行 changelog 的前置条件；
- property：用于设置属性的值；
- changeSet：执行的变更集；
- include：引用其他包含要执行的 changeSet 文件；
- context：changSet 上下文；



## 5.拓展

​[Flyway](https://flywaydb.org/documentation/) 是一个能对数据库变更进行版本控制的工具。

​Welcome to **Flyway**, database migrations made easy. ***Flyway*** provide 7 basic commands： [Migrate](https://flywaydb.org/documentation/command/migrate), [Clean](https://flywaydb.org/documentation/command/clean), [Info](https://flywaydb.org/documentation/command/info), [Validate](https://flywaydb.org/documentation/command/validate), [Undo](https://flywaydb.org/documentation/command/undo), [Baseline](https://flywaydb.org/documentation/command/baseline) and [Repair](https://flywaydb.org/documentation/command/repair). 

​It has a [Command-line client](https://flywaydb.org/documentation/usage/commandline). If you are on the JVM, we recommend using the [Java API](https://flywaydb.org/documentation/usage/api) for migrating the database on application startup. Alternatively, you can also use the [Maven plugin](https://flywaydb.org/documentation/usage/maven) or [Gradle plugin](https://flywaydb.org/documentation/usage/gradle).

​And if that's not enough, there are [plugins](https://flywaydb.org/documentation/plugins) available for Spring Boot, Dropwizard, Grails, Play, SBT, Ant, Griffon, Grunt, Ninja and more!



**优点**：

+ 基本指令，方便数据迁移；
+ 提供基于 Maven Plugin and Gradle Plugin；
+ there are [plugins](https://flywaydb.org/documentation/plugins) available for Spring Boot,
+ 支持多种数据库：Oracle、SQL Server、DB2、MySQL、PostgreSQL、H2；


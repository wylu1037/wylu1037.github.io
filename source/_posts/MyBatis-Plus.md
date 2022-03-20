---
title: MyBatis-Plus
date: 2022-03-20 20:09:15
tags:
    - dao
    - MyBatis
    - MP
categories: 数据库
cover: https://img.sqnjy.com/2022/03/e63f1bf3221601c492cc.jpg
---

## 1.简介

 [MyBatis-Plus (opens new window)](https://github.com/baomidou/mybatis-plus)（简称 MP）是一个 [MyBatis (opens new window)](https://www.mybatis.org/mybatis-3/)的增强工具，在 MyBatis 的基础上只做增强不做改变，为简化开发、提高效率而生。 

> MyBatis-Plus官方文档：https://baomidou.com/
>
> 仓库地址：
>
> + https://gitee.com/baomidou/mybatis-plus
> + https://github.com/baomidou/mybatis-plus

### 1.1 优点&特性

相较于 ***MyBatis***，MP **<u>优点</u>：**

+ 只做增强不做改，引入后不会对现有的过程产生影响，如丝般润滑；
+ 只需简单配置，即可快速进行单表 `CRUD` 操作，节省大量时间；
+ 代码生成、自动分页、逻辑删除、自动填充等功能一应俱全；

 

**<u>特性</u>：**

- **无侵入**：只做增强不做改变，引入它不会对现有工程产生影响，如丝般顺滑；
- **损耗小**：启动即会自动注入基本 CURD，性能基本无损耗，直接面向对象操作；
- **强大的 CRUD 操作**：内置通用 Mapper、通用 Service，仅仅通过少量配置即可实现单表大部分 CRUD 操作，更有强大的条件构造器，满足各类使用需求；
- **支持 Lambda 形式调用**：通过 Lambda 表达式，方便的编写各类查询条件，无需再担心字段写错；
- **支持主键自动生成**：支持多达 4 种主键策略（内含分布式唯一 ID 生成器 - Sequence），可自由配置，完美解决主键问题；
- **支持 ActiveRecord 模式**：支持 ActiveRecord 形式调用，实体类只需继承 Model 类即可进行强大的 CRUD 操作；
- **支持自定义全局通用操作**：支持全局通用方法注入（ Write once, use anywhere ）；
- **内置代码生成器**：采用代码或者 Maven 插件可快速生成 Mapper 、 Model 、 Service 、 Controller 层代码，支持模板引擎，更有超多自定义配置等您来使用；
- **内置分页插件**：基于 MyBatis 物理分页，开发者无需关心具体操作，配置好插件之后，写分页等同于普通 List 查询；
- **分页插件支持多种数据库**：支持 MySQL、MariaDB、Oracle、DB2、H2、HSQL、SQLite、Postgre、SQLServer 等多种数据库；
- **内置性能分析插件**：可输出 SQL 语句以及其执行时间，建议开发测试时启用该功能，能快速揪出慢查询；
- **内置全局拦截插件**：提供全表 delete 、 update 操作智能分析阻断，也可自定义拦截规则，预防误操作；



### 1.2 支持数据库

> 任何能使用 `MyBatis` 进行 CRUD，并且支持标准 SQL 的数据库，具体支持情况如下

- MySQL，Oracle，DB2，H2，HSQL，SQLite，PostgreSQL，SQLServer，Phoenix，Gauss ，ClickHouse，Sybase，OceanBase，Firebird，Cubrid，Goldilocks，csiidb；
- 达梦数据库，虚谷数据库，人大金仓数据库，南大通用(华库)数据库，南大通用数据库，神通数据库，瀚高数据库；



### 1.3 依赖引入

:::warning
 引入 `MyBatis-Plus` 之后请不要再次引入 `MyBatis` 以及 `MyBatis-Spring`，以避免因版本差异导致的问题。
:::

#### 1.3.1 SpringBoot

***Maven***：

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus</artifactId>
    <version>3.5.1</version>
</dependency>
```



***Gradle***：

```groovy
implementation 'com.baomidou:mybatis-plus:3.5.1'
```



#### 1.3.2 Spring

***Maven***：

```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus</artifactId>
    <version>3.5.1</version>
</dependency>
```



***Gradle***：

```groovy
compile group: 'com.baomidou', name: 'mybatis-plus', version: '3.5.1'
```



### 1.3 苞米生态圈

- [MybatisX (opens new window)](https://github.com/baomidou/MybatisX)- 一款全免费且强大的 IDEA 插件，支持跳转，自动补全生成 SQL，代码生成。
- [Mybatis-Mate (opens new window)](https://gitee.com/baomidou/mybatis-mate-examples)- 为 MyBatis-Plus 企业级模块，支持分库分表、数据审计、字段加密、数据绑定、数据权限、表结构自动生成 SQL 维护等高级特性。
- [Dynamic-Datasource (opens new window)](https://dynamic-datasource.com/)- 基于 SpringBoot 的多数据源组件，功能强悍，支持 Seata 分布式事务。
- [Shuan (opens new window)](https://gitee.com/baomidou/shaun)- 基于 Pac4J-JWT 的 WEB 安全组件, 快速集成。
- [Kisso (opens new window)](https://github.com/baomidou/kisso)- 基于 Cookie 的单点登录组件。
- [Lock4j (opens new window)](https://gitee.com/baomidou/lock4j)- 基于 SpringBoot 同时支持 RedisTemplate、Redission、Zookeeper 的分布式锁组件。
- [Kaptcha (opens new window)](https://gitee.com/baomidou/kaptcha-spring-boot-starter)- 基于 SpringBoot 和 Google Kaptcha 的简单验证码组件，简单验证码就选它。
- [Aizuda 爱组搭 (opens new window)](https://gitee.com/aizuda)- 低代码开发平台组件库。



---

## 2.快速入门

:::tip
前提：已熟悉 ***MyBatis*** 框架的使用流程。
:::

### 2.1 整合SpringBoot

引入 SpringBoot Starter 父工程：

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.6.4</version>
    <relativePath/>
</parent>
```

引入相关依赖：

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jdbc</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>com.baomidou</groupId>
        <artifactId>mybatis-plus-boot-starter</artifactId>
        <version>3.5.1</version>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
    </dependency>
</dependencies>
```



### 2.2 配置

 在 `application.yml` 配置文件中添加 *MySQL* 数据库的相关配置： 

```yaml
spring:
  # 数据库连接信息
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/javashop?serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=utf-8&zeroDateTimeBehavior=convertToNull
    username: root
    password: 123456
    driver-class-name: com.mysql.cj.jdbc.Driver
```

 在 *Spring Boot* 启动类中添加 `@MapperScan` 注解，扫描 *Mapper* 文件夹： 

```java
@SpringBootApplication
@MapperScan("com.baomidou.mybatisplus.samples.quickstart.mapper")
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

配置类：

```java
@Configuration
public class MybatisPlusConfig {

    private String mapperLocations= "classpath*:mappers/*.xml";

    private String typeAliasBasePackage = "cn.com.egova.*.model";

    @Bean("mybatisPlusInterceptor")
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        PaginationInnerInterceptor page = new PaginationInnerInterceptor();
        // 设置数据库类型
        page.setDbType(DbType.MYSQL);
        page.setDialect(new MySqlDialect());
        interceptor.addInnerInterceptor(page);
        return interceptor;
    }


    // 配置MybatisPlus的sqlSessionFactory
    @Bean("sqlSessionFactory")
    public SqlSessionFactory sqlSessionFactoryBean(@Qualifier("masterDataSource") DataSource dataSource,
        @Qualifier("mybatisPlusInterceptor") MybatisPlusInterceptor mybatisPlusInterceptor) throws Exception {
        MybatisSqlSessionFactoryBean sessionFactory = new MybatisSqlSessionFactoryBean ();
        sessionFactory.setDataSource(dataSource);

        MybatisConfiguration configuration = new MybatisConfiguration();
        // configuration.setDefaultScriptingLanguage(MybatisXMLLanguageDriver.class);
        configuration.setJdbcTypeForNull(JdbcType.NULL);
        configuration.setCacheEnabled(true);
        configuration.setMapUnderscoreToCamelCase(false);
        configuration.setCallSettersOnNulls(true);
        // 正式环境需要屏蔽：MybatisPlus执行SQL时，将其打印出来
        configuration.setLogImpl(org.apache.ibatis.logging.stdout.StdOutImpl.class);
        sessionFactory.setConfiguration(configuration);

        // 更新策略：update语句中避免字段为空不更新
        GlobalConfig globalConfig = GlobalConfigUtils.defaults();
        globalConfig.getDbConfig().setUpdateStrategy(FieldStrategy.IGNORED);
        sessionFactory.setGlobalConfig(globalConfig);

        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        sessionFactory.setMapperLocations(resolver.getResources(mapperLocations));

        sessionFactory.setTypeAliasesPackage(typeAliasBasePackage);

        // 设置分页插件
        sessionFactory.setPlugins(mybatisPlusInterceptor);

        return sessionFactory.getObject();
    }
}
```



### 2.3 编码

 编写实体类 `User.java` 

```java
@Data
public class User {
    private Long id;
    private String name;
    private Integer age;
    private String email;
}
```

 编写 Mapper 包下的 `UserMapper`接口 

```java
public interface UserMapper extends BaseMapper<User> {

}
```



### 2.4 使用

#### 2.4.1 注解



#### 2.4.2 单表api



### 2.5 分页








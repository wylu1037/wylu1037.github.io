---
title: Go 函数式选项模式：优雅地处理可选参数
date: 2024-11-12T09:42:52+08:00
categories: [go]
tags: [functional options pattern, design pattern, api design]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## 1.什么是函数式选项模式

函数式选项模式（Functional Options Pattern）是 Go 语言中一种优雅的 API 设计模式，用于处理**具有多个可选参数的函数**。它通过使用函数作为参数来配置对象，既保持了 API 的简洁性，又提供了极大的灵活性。

## 2.为什么需要这个模式

### 2.1 传统方案的问题

假设我们要创建一个服务器，需要配置多个可选参数：

```go
// 方案1：多个构造函数 - 组合爆炸
func NewServer() *Server
func NewServerWithTLS() *Server  
func NewServerWithMaxConn(maxConn int) *Server
func NewServerWithTLSAndMaxConn(maxConn int) *Server // 😱

// 方案2：配置结构体 - 零值歧义
func NewServer(config Config) *Server
// 问题：无法区分用户设置的零值和未设置的零值
```

### 2.2 函数式选项模式的优势

1. **API 简洁**：只需要一个构造函数
2. **高度灵活**：可以任意组合选项
3. **向后兼容**：添加新选项不会破坏现有代码
4. **自描述性**：选项名称清晰表达意图
5. **零值友好**：明确区分设置和未设置

## 3.YouTube 教程

{{< youtube "MDy7JQN5MN4" >}}

## 4.完整实现示例

```go
package main

import "fmt"

// 选项函数类型
type OptFunc func(*Opts)

// 配置结构体
type Opts struct {
	maxConn int
	id      string
	tls     bool
	timeout int
}

// 默认配置
func defaultOpts() Opts {
	return Opts{
		maxConn: 100,
		id:      "default",
		tls:     false,
		timeout: 30,
	}
}

// 选项函数：启用 TLS
func WithTLS() OptFunc {
	return func(opts *Opts) {
		opts.tls = true
	}
}

// 选项函数：设置最大连接数
func WithMaxConn(maxConn int) OptFunc {
	return func(opts *Opts) {
		opts.maxConn = maxConn
	}
}

// 选项函数：设置服务器 ID
func WithID(id string) OptFunc {
	return func(opts *Opts) {
		opts.id = id
	}
}

// 选项函数：设置超时时间
func WithTimeout(timeout int) OptFunc {
	return func(opts *Opts) {
		opts.timeout = timeout
	}
}

// 服务器结构体
type Server struct {
	Opts
}

// 构造函数：接受可变数量的选项
func NewServer(opts ...OptFunc) *Server {
	o := defaultOpts()
	for _, fn := range opts {
		fn(&o)
	}
	return &Server{Opts: o}
}

func (s *Server) String() string {
	return fmt.Sprintf("Server{maxConn: %d, id: %s, tls: %t, timeout: %d}",
		s.maxConn, s.id, s.tls, s.timeout)
}
```

## 5.使用示例

```go
func main() {
	// 使用默认配置
	server1 := NewServer()
	fmt.Println("默认配置:", server1)

	// 启用 TLS
	server2 := NewServer(WithTLS())
	fmt.Println("启用 TLS:", server2)

	// 组合多个选项
	server3 := NewServer(
		WithTLS(),
		WithMaxConn(500),
		WithID("web-server"),
		WithTimeout(60),
	)
	fmt.Println("完整配置:", server3)

	// 部分配置
	server4 := NewServer(WithMaxConn(200), WithID("api-server"))
	fmt.Println("部分配置:", server4)
}
```

输出：
```
默认配置: Server{maxConn: 100, id: default, tls: false, timeout: 30}
启用 TLS: Server{maxConn: 100, id: default, tls: true, timeout: 30}
完整配置: Server{maxConn: 500, id: web-server, tls: true, timeout: 60}
部分配置: Server{maxConn: 200, id: api-server, tls: false, timeout: 30}
```

## 6.高级用法

### 6.1 条件选项

```go
func WithTLSIf(condition bool) OptFunc {
	return func(opts *Opts) {
		if condition {
			opts.tls = true
		}
	}
}

// 使用
server := NewServer(WithTLSIf(os.Getenv("ENV") == "production"))
```

### 6.2 选项验证

```go
func WithMaxConn(maxConn int) OptFunc {
	return func(opts *Opts) {
		if maxConn <= 0 {
			panic("maxConn must be positive")
		}
		opts.maxConn = maxConn
	}
}
```

### 6.3 选项组合

```go
func WithProductionDefaults() OptFunc {
	return func(opts *Opts) {
		WithTLS()(opts)
		WithMaxConn(1000)(opts)
		WithTimeout(60)(opts)
	}
}
```

## 7.最佳实践

### ✅ 推荐做法

1. **统一命名**：选项函数使用 `With` 前缀
2. **提供默认值**：确保不传递选项时有合理的默认行为
3. **选项幂等**：多次应用同一选项应该是安全的
4. **文档说明**：为每个选项函数添加清晰的注释

### ❌ 避免的陷阱

1. **过度使用**：不是所有场景都适合，简单配置直接用参数
2. **选项冲突**：设计时避免选项之间的逻辑冲突
3. **性能考虑**：避免在选项函数中执行昂贵操作

## 8.适用场景

- **库/框架的 API 设计**：需要灵活配置的公共接口
- **配置复杂的对象**：有多个可选参数的构造函数
- **需要向后兼容**：API 需要频繁添加新配置选项
- **用户体验优先**：希望提供简洁直观的 API

## 9.与其他模式对比

| 模式 | 优点 | 缺点 | 适用场景 |
|------|------|------|----------|
| 函数式选项 | 灵活、可读性好、向后兼容 | 略微复杂 | 公共 API，多可选参数 |
| 构建者模式 | 类型安全、链式调用 | 代码量大 | 复杂对象构建 |
| 配置结构体 | 简单直接 | 零值歧义 | 内部 API，配置明确 |

函数式选项模式是 Go 语言中处理可选参数的最优雅方案，它平衡了简洁性、灵活性和可维护性，是每个 Go 开发者都应该掌握的重要模式。


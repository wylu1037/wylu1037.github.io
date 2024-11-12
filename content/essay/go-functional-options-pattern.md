---
title: 函数式选项模式
date: 2024-11-12T09:42:52+08:00
categories: [go]
tags: [functional options pattern]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## YouTube

{{< youtube "MDy7JQN5MN4" >}}

## 示例
```go

type OptFunc func(*Opts)

type Opts struct {
	maxConn   int
	id        string
	tls       bool
}

func defaultOpts() Opts {
	return Opts{
		maxConn: 100,
		id:      "default",
		tls:     false,
	}
}

func withTLS(opts *Opts) {
	opts.tls = true
}

func withMaxConn(maxConn int) OptFunc {
	return func(opts *Opts) {
		opts.maxConn = maxConn
	}
}

type Server struct {
	Opts
}

func NewServer(opts ...OptFunc) *Server {
	o := defaultOpts()
	for _, fn := range opts {
		fn(&o)
	}
	return &Server{Opts: o}
}
```

```go
server := NewServer(withTLS, withMaxConn(10))
```


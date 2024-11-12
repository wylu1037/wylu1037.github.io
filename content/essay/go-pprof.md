---
title: pprof
date: 2024-07-31T09:53:42+08:00
categories: [go]
tags: [pprof]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---
引入依赖
```go
import _ "net/http/pprof"
```

分析内存
```shell
go tool pprof http://localhost:8081/debug/pprof/heap
```

分析CPU
```shell
go tool pprof http://localhost:8081/debug/pprof/profile
```


```shell
File: ___3go_build_lattice_manager_grpc_cmd_server
Type: cpu
Time: Jul 31, 2024 at 10:15am (CST)
Duration: 30.10s, Total samples = 100ms ( 0.33%)
Entering interactive mode (type "help" for commands, "o" for options)
(pprof) top
Showing nodes accounting for 100ms, 100% of 100ms total
Showing top 10 nodes out of 125
      flat  flat%   sum%        cum   cum%
      20ms 20.00% 20.00%       20ms 20.00%  runtime.kevent
      20ms 20.00% 40.00%       20ms 20.00%  syscall.syscall
      10ms 10.00% 50.00%       10ms 10.00%  buf.build/gen/go/bufbuild/protovalidate/protocolbuffers/go/buf/validate.(*FloatRules).ProtoReflect
      10ms 10.00% 60.00%       10ms 10.00%  google.golang.org/protobuf/internal/filedesc.(*Enum).lazyInit
      10ms 10.00% 70.00%       10ms 10.00%  runtime.(*mspan).base
      10ms 10.00% 80.00%       10ms 10.00%  runtime.madvise
      10ms 10.00% 90.00%       10ms 10.00%  runtime.pthread_cond_wait
      10ms 10.00%   100%       10ms 10.00%  runtime/internal/atomic.casPointer
         0     0%   100%       10ms 10.00%  bufio.(*Writer).Flush
         0     0%   100%       10ms 10.00%  crypto/ecdsa.GenerateKey
```

1. **flat**: This column shows the amount of time (in milliseconds) spent in this function alone, not counting time spent in functions that it calls. For example, 20ms means that the function runtime.kevent consumed 20 milliseconds of CPU time by itself. 
2. **flat%**: This represents the percentage of the total recorded CPU time that was spent in this function alone. For instance, 20.00% indicates that the function consumed 20% of the total profiling time. 
3. **sum%**: This column accumulates the percentages from the top of the list down to the current function, showing a cumulative percentage. This helps in understanding the cumulative impact of the functions up to the current row. 
4. **cum**: This shows the cumulative time (in milliseconds) spent in the function itself and all functions it calls (i.e., inclusive time). For example, 20ms under the runtime.kevent row means that runtime.kevent and all the functions it calls directly or indirectly together took 20 milliseconds. 
5. **cum%**: This represents the percentage of the total recorded CPU time that includes the time spent in the function itself and all its callees. It indicates the cumulative percentage of total time accounted for up to this function. 
6. **Function Name**: This is the name of the function where the time was spent. It can include package names and sometimes full paths, especially if the function belongs to a third-party library or is generated.



| 路由                     | 处理器           | 作用                    |
|------------------------|---------------|-----------------------|
| "/debug/pprof/"        | pprof.Index   | 显示所有可用的pprof分析工具的索引页面 |
| "/debug/pprof/heap"    | pprof.Index   | 内存堆分析                 |
| "/debug/pprof/cmdline" | pprof.Cmdline | 显示程序启动时的命令行参数         |
| "/debug/pprof/profile" | pprof.Profile | 用于CPU分析               |
| "/debug/pprof/symbol"  | pprof.Symbol  | 用于符号解析                |
| "/debug/pprof/trace"   | pprof.Trace   | 用于获取程序的执行跟踪信息         |

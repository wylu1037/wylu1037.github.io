---
title: 😀 CGO
date: 2024-02-19T13:35:53+08:00
tags:
  - go
  - cgo
draft: false
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
description: CGO
---

## 启用CGO特性
```go
package main

import "C"

func main() {
    //
}
```
> + 通过`import "C"`启用 CGO 特性，在`go build`时在编译和连接阶段启动 gcc 编译器。
> + CGO 会将`import "C"`语句上一行代码所处注释块的内容视为 C 代码块，被称为序文（preamble）。

## Go 调用 C
```go {filename="qkd.go",hl_lines=[1,2,3]}
/*
#cgo CFLAGS: -I./include
#cgo LDFLAGS: -L/app/lib -lkeyout -lstdc++ -lm
#include "KeyReadAPI.h"

void callbackFunc(uint32_t command, void *data); // 定义的 C 函数
*/
import "C"
```
{{< callout type="info">}}
1. `#cgo CFLAGS: -I./include`: 编译参数，主要是头文件的检索路径。
2. `#cgo LDFLAGS: -L/app/lib -lkeyout -lstdc++ -lm`: 链接参数：指定要链接库（静态库`.a文件`或动态库`.so文件`）的检索目录和要链接库的名字（注意是否区分大小写），不支持相对路径。
3. `#include "KeyReadAPI.h"`: 包含的头文件，查找位置通过 `cgo CFLAGS: -I./include`指定
{{< /callout >}}

{{% details title="查看KeyReadAPI.h" closed="true" %}}

```c {filename="KeyReadAPI.h"}
int auth_login(const char *config_path);

void register_data_func(pfunc_process_data p_user_function);

int read_key(uint32_t peer_dev_info,uint32_t key_read_id, uint32_t key_apply_len,
              uint8_t *quantum_key,uint32_t *quantum_key_len);
              
typedef void (*pfunc_process_data)(uint32_t command, void *data); // 定义的回调函数，register_data_func注册该回调函数
```

{{% /details %}}

`void callbackFunc(uint32_t command, void *data)`中`void *data`对应的 c++ 中定义的结构体。
```c++ {filename=" KeyReadAPI.h"}
typedef struct
{
    uint32_t key_read_id;                     //密钥读取标示
    uint32_t key_len; 						  //本次输出的密钥量
    uint8_t  key_data[512*1024];              //密钥数据
} st_key_push_data;
```

{{< icon "go" >}}定义接口
```go {filename="qkd.go"}
type QkdService interface {
	// AuthLogin 设备入网
	AuthLogin() error
	// RegisterDataFunc 被动端用户函数注册
	RegisterDataFunc()
	// ReadKey 主动端密钥申请
	ReadKey() error
}
```

{{< icon "go" >}}定义结构体，实现接口并通过`C.`调用C代码
```go {filename="qkd.go",hl_lines=[34,36,48,59]}
type qkdService struct {
	config *config.Config
}

const configPath = "/app/KeyOutLibConfig.xml"
const (
	keyBufferLen = 0    // 量子密钥缓存实际长度
	keyApplyLen  = 1024 // 一次请求的密钥量，单位Byte，只支持1024的整数倍，上限512*1024
)

var keyQueue = &KeyQueue{
	key: make([]string, 0),
}

type KeyQueue struct {
	key []string
}

func (k *KeyQueue) Enqueue(key string) {
	log.Debug().Msgf("Qkd密钥入队列，key is %s", key)
	k.key = append(k.key, key)
}

func (k *KeyQueue) Dequeue() (key string, err error) {
	if len(k.key) == 0 {
		return "", errors.New("")
	}
	key = k.key[0]
	k.key = k.key[1:]
	return key, nil
}

func (svc *qkdService) AuthLogin() error {
	path := C.CString(configPath)
	//defer C.free(unsafe.Pointer(path))
	code := int(C.auth_login(path))
	if code == Success {
		return nil
	}
	errMsg, ok := qkdErrMsgGroup[qkdErrorCode(code)]
	if ok {
		return errors.New(errMsg)
	}
	return errors.New("QKD Auth Login接口未知异常")
}

func (svc *qkdService) RegisterDataFunc() {
	C.register_data_func(C.pfunc_process_data(C.callbackFunc))
}

func (svc *qkdService) ReadKey() error {
	var peerDevId = svc.config.Qkd.DevId // 被动端应用设备ID，配置文件值KSP ID
	var keyReadId = rand.Uint32()        // 密钥读取标示，可用于标识读取次数，每次密钥申请此参数不能重复。
	keyBuffer := make([]uint8, 512*1024) // 量子密钥数据缓存
	cKeyBuffer := (*C.uint8_t)(unsafe.Pointer(&keyBuffer[0]))
	cKeyBufferLen := new(uint32)
	*cKeyBufferLen = 0
	cKeyBufferLenPtr := (*C.uint32_t)(unsafe.Pointer(cKeyBufferLen))
	code := int(C.read_key(C.uint32_t(peerDevId), C.uint32_t(keyReadId), C.uint32_t(keyApplyLen), cKeyBuffer, cKeyBufferLenPtr))

	if code != 0 {
		msg, ok := qkdErrMsgGroup[qkdErrorCode(code)]
		if ok {
			return errors.New(msg)
		} else {
			return errors.New("未知异常")
		}
	}
	return nil
}
```

## C 调用 Go
### C references to Go
Go functions can be exported for use by C code in the following way:
```go
//export MyFunction
func MyFunction(arg1, arg2 int, arg3 string) int64 {...}

//export MyFunction2
func MyFunction2(arg1, arg2 int, arg3 string) (int64, *C.char) {...}
```

They will be available in the C code as:
```c
extern GoInt64 MyFunction(int arg1, int arg2, GoString arg3);
extern struct MyFunction2_return MyFunction2(int arg1, int arg2, GoString arg3);
```

Not all Go types can be mapped to C types in a useful way. Go struct types are not supported; use a C struct type. Go array types are not supported; use a C pointer.




## 编译选项
目录结构
{{< filetree/container >}}
  {{< filetree/folder name="qkd" >}}
    {{< filetree/file name="qkd.go" >}}
    {{< filetree/folder name="include" >}}
      {{< filetree/file name="KeyReadAPI.h" >}}
    {{< /filetree/folder >}}
  {{< /filetree/folder >}}
  {{< filetree/folder name="app" >}}
    {{< filetree/folder name="lib" >}}
      {{< filetree/file name="libkeyout.a" >}}
    {{< /filetree/folder >}}
  {{< /filetree/folder >}}
{{< /filetree/container >}}

`qkd.go`代码
```go {filename="qkd.go"}
/*
#cgo CFLAGS: -I./include
#cgo LDFLAGS: -L/app/lib -lkeyout -lstdc++ -lm
#include "KeyReadAPI.h"

void callbackFunc(uint32_t command, void *data); // 定义的 C 函数
*/
import "C"
```
> + `-lstdc++`表示链接 C++ 标准库；
> + `-lm`表示链接数学库（libm.a 或 libm.so）；




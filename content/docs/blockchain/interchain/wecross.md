---
title: WeCross
date: 2024-04-03T10:47:50+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## 前言

- **跨链路由（WeCross Router）**
  - 与链对接，对链上的资源进行抽象
  - 向外暴露统一的接口
  - 将调用请求路由至对应的区块链
- **账户服务（WeCross Account Manager）**
  - 管理跨链账户
  - Router 连接所属机构的 Account Manager
  - 用户在 Router 上登录，以跨链账户的身份发交易
- **控制台（WeCross Console）**
  - 命令行式的交互
  - 查询跨链信息，发送调用请求，操作跨链事务
- **网页管理平台**
  - 可视化操作界面
  - 查询跨链信息，发送调用请求，操作跨链事务
- **跨链 SDK（WeCross Java SDK）**
  - WeCross 开发工具包，供开发者调用 WeCross
  - 集成于各种跨链 APP 中，提供统一的调用接口
  - 与跨链路由建立连接，调用跨链路由
- **跨链资源（Resource）**
  - 各种区块链上内容的抽象
  - 包括：合约、资产、信道、数据表
- **跨链适配器（Stub）**
  - 跨链路由中对接入的区块链的抽象
  - 跨链路由通过配置 Stub 与相应的区块链对接
  - FISCO BCOS 需配置 FISCO BCOS Stub、Fabric 需配置 Fabric Stub
- **IPath（Interchain Path）**
  - 跨链资源的唯一标识
  - 跨链路由根据 IPath 将请求路由至相应区块链上
  - 在代码和文档中将 IPath 简称为 path
- **跨链分区**
  - 多条链通过跨链路由相连，形成跨链分区
  - 跨链分区有唯一标识，即 IPath 中的第一项（payment.stub3.resource-d 的 payment）

{{< image "/images/docs/blockchain/interchain/wecross-framework.svg" "framework" >}}

## 跨链事务

### 两阶段事务

两阶段事务是分布式数据库和分布式系统中常见的事务模型，两阶段事务的架构中包含事务管理器和资源管理器等多个角色。

{{< image "/images/docs/blockchain/interchain/两阶段事务.webp" "两阶段事务" >}}

在 WeCross 事务模型中，代理合约负责管理事务状态以及对资源的读写控制，事务管理器则由跨链路由实现。用户通过使用 WeCross SDK，可以让多个跨链路由和多个链上的资源参与事务，以保障对各个资源操作的原子性。

{{< image "/images/docs/blockchain/interchain/wecross-两阶段事务.webp" "两阶段事务" >}}

无论何种智能合约或链码，参与基本的两阶段事务流程时不需要提前做修改。但如果要支持两阶段事务的回滚操作，参与事务的资源接口必须实现对应的逆向接口。

{{< tabs items="正向接口示例,逆向接口示例" >}}
{{< tab >}}

```solidity
function transfer(string memory from, string memory to, int balance) public {
    // balance check...
    balances[from] -= balance;
    balances[to] += balance;
}
```

{{< /tab>}}

{{< tab >}}
为了支持回滚，需实现一个逆向接口。逆向接口的参数与原交易接口相同，函数名增加\_revert 的后缀，表明这是一个用于两阶段事务回滚的接口。当两阶段事务需要回滚时，WeCross 会自动执行 Solidity 合约的逆向接口。

```solidity
function transfer_revert(string memory from, string memory to, int balance) public {
  // balance check...
  balance[from] += balance;
  balance[to] -= balance;
}
```

{{< /tab>}}
{{< /tabs >}}

### 哈希时间锁合约

{{< image "/images/docs/blockchain/interchain/哈希锁定跨链.jpeg" "哈希时间锁定合约" >}}

流程

## 合约跨链调用(Interchain)

WeCross 支持由合约发起跨链调用，即可在源链的智能合约中发起对其它链资源的调用。

### 原理解析

WeCross 提供了两个系统合约，分别是 **代理合约** 和 **桥接合约**。代理合约是 WeCross 调用链上其它合约的统一入口，桥接合约则负责保存链上的跨链调用请求。跨链路由通过轮询桥接合约的任务队列，获取跨链调用请求，然后完成请求的转发和处理。

合约跨链调用具体流程如下：

{{< steps >}}

<h5></h5>
源链的业务合约调用源链的桥接合约，注册跨链请求以及回调接口
<h5></h5>
源链的跨链路由轮询源链的桥接合约，获取跨链请求
<h5></h5>
源链的跨链路由解析跨链请求，完成对目标链的调用
<h5></h5>
源链的跨链路由将目标链返回的结果作为参数，调用源链的回调接口
<h5></h5>
源链的跨链路由将回调接口的调用结果注册到源链的桥接合约
{{< /steps >}}

{{< image "/images/docs/blockchain/interchain/wecross-interchain.png" "framework" >}}

### 桥接合约

{{< tabs items="Solidity,Golang" >}}
{{< tab >}}

[Github](https://github.com/WeBankBlockchain/WeCross-BCOS2-Stub/blob/master/src/main/resources/WeCrossHub.sol)

```solidity
/** 供业务合约调用，注册跨链调用请求
 *
 *  @param _path     目标链合约的路径
 *  @param _method   调用方法名
 *  @param _args     调用参数列表
 *  @param _callbackPath   回调的合约路径
 *  @param _callbackMethod 回调方法名
 *  @return 跨链请求的唯一ID
 */
function interchainInvoke(
        string memory _path,
        string memory _method,
        string[] memory _args,
        string memory _callbackPath,
        string memory _callbackMethod
) public returns(string memory uid)

/** 供用户调用，查询回调的调用结果
 *
 *  @param _uid   跨链请求的唯一ID
 *  @return       字符串数组: [事务ID, 事务Seq, 错误码, 错误消息, 回调调用结果的JSON序列化]
 */
function selectCallbackResult(
    string memory _uid
) public view returns(string[] memory)
```

{{< /tab >}}

{{< tab >}}
[Github](https://github.com/WeBankBlockchain/WeCross-Fabric1-Stub/blob/dev/src/main/resources/chaincode/WeCrossHub/hub.go)

```go
/**
 *  @param [path, method, args, callbackPath, callbackMethod]
 *  @return 跨链请求的唯一ID
 */
func (h *Hub) interchainInvoke(
    stub shim.ChaincodeStubInterface,
    args []string
) peer.Response

/**
 *  @param  uid
 *  @return 字符串数组: [事务ID, 事务Seq, 错误码, 错误消息, 回调调用结果的JSON序列化]
 */
func (h *Hub) selectCallbackResult(
    stub shim.ChaincodeStubInterface,
    args []string
) peer.Response
```

{{< /tab >}}
{{< /tabs >}}

### 业务合约

{{< callout >}}

- 调用的目标链的接口定义必须匹配: string[] func(string[] args)
- 回调函数的接口定义必须匹配: string[] func(bool state, string[] result)，state 表示调用目标链是否成功，result 是调用结果

{{< /callout >}}

<h5>实现跨链调用的业务合约编写规范可参考示例合约</h5>

- `init()`: 传入本链的桥接合约地址进行初始化；
- `interchain()`: 跨链调用的发起接口，其内部调用了桥接合约的 interchainInvoke 接口；
- `get()`: 获取 data；
- `set()`: 更新 data；
- `callback()`: 使用跨链调用的结果更新 data；

**两个示例合约联动过程**：A 链的示例合约发起一个跨链调用，调用 B 链的示例合约的 set 接口，更新 B 链的 data，然后触发回调，调用 A 链的 callback 接口并更新 A 链的 data。

{{< tabs items="Solidity,Golang" >}}
{{< tab >}}

```solidity
pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

import "./WeCrossHub.sol";


contract InterchainSample {
    WeCrossHub hub;

    string[] data = ["Talk is cheap, show me the code."];

    function init(address _hub) public
    {
        hub = WeCrossHub(_hub);
    }

    function interchain(string memory _path, string memory _method, string memory _args, string memory _callbackPath, string memory _callbackMethod) public
    returns(string memory)
    {
        string[] memory args = new string[](1);
        args[0] = _args;

        return hub.interchainInvoke(_path, _method, args, _callbackPath, _callbackMethod);
    }

    function callback(bool state, string[] memory _result) public
    returns(string[] memory)
    {
        if(state) {
            data = _result;
        }

        return _result;
    }

    function get() public view
    returns(string[] memory)
    {
        return data;
    }

    function set(string[] memory _data) public
    returns(string[] memory)
    {
        data = _data;
        return data;
    }

}
```

{{< /tab >}}

{{< tab >}}

```go
package main

import (
	"encoding/json"
	"fmt"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

const (
	ChannelKey = "channel"
	HubNameKey = "hub_name"
	DataKey    = "data"
)

type Interchain struct {
}

func (i *Interchain) Init(stub shim.ChaincodeStubInterface) (res peer.Response) {
	defer func() {
		if r := recover(); r != nil {
			res = shim.Error(fmt.Sprintf("%v", r))
		}
	}()

	data := []string{"Talk is cheap, show me the code."}
	dataBytes, err := json.Marshal(data)
	checkError(err)

	err = stub.PutState(DataKey, dataBytes)
	checkError(err)

	return shim.Success(nil)
}

func (i *Interchain) Invoke(stub shim.ChaincodeStubInterface) (res peer.Response) {
	defer func() {
		if r := recover(); r != nil {
			res = shim.Error(fmt.Sprintf("%v", r))
		}
	}()

	fcn, args := stub.GetFunctionAndParameters()

	switch fcn {
	case "init":
		res = i.init(stub, args)
	case "interchain":
		res = i.interchain(stub, args)
	case "callback":
		res = i.callback(stub, args)
	case "get":
		res = i.get(stub)
	case "set":
		res = i.set(stub, args)
	default:
		res = shim.Error("invalid function name")
	}

	return
}

/*
 * @args channel || hub
 */
func (i *Interchain) init(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	if len(args) != 2 {
		return shim.Error("incorrect number of arguments, expecting 2")
	}

	err := stub.PutState(ChannelKey, []byte(args[0]))
	checkError(err)

	err = stub.PutState(HubNameKey, []byte(args[1]))
	checkError(err)

	return shim.Success(nil)
}

/*
 * invoke other chain
 * @args path || method || args || callbackPath || callbackMethod
 */
func (i *Interchain) interchain(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	if len(args) != 5 {
		return shim.Error("incorrect number of arguments, expecting 5")
	}

	channel, err := stub.GetState(ChannelKey)
	checkError(err)

	hub, err := stub.GetState(HubNameKey)
	checkError(err)

	var trans [][]byte
	trans = append(trans, []byte("interchainInvoke"))
	trans = append(trans, []byte(args[0]))
	trans = append(trans, []byte(args[1]))

	input := []string{args[2]}
	inputData, err := json.Marshal(input)
	checkError(err)
	trans = append(trans, inputData)

	trans = append(trans, []byte(args[3]))
	trans = append(trans, []byte(args[4]))

	return stub.InvokeChaincode(string(hub), trans, string(channel))
}

/*
 * @args state || result
 * result is json form of string array
 */
func (i *Interchain) callback(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	if len(args) != 2 {
		return shim.Error("incorrect number of arguments, expecting 2")
	}

	if "true" == args[0] {
		err := stub.PutState(DataKey, []byte(args[1]))
		checkError(err)
	}
	return shim.Success([]byte(args[1]))
}

func (i *Interchain) get(stub shim.ChaincodeStubInterface) peer.Response {
	data, err := stub.GetState(DataKey)
	checkError(err)
	return shim.Success(data)
}

func (i *Interchain) set(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	if len(args) != 1 {
		return shim.Error("incorrect number of arguments, expecting 1")
	}

	err := stub.PutState(DataKey, []byte(args[0]))
	checkError(err)

	return shim.Success([]byte(args[0]))
}

func checkError(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	err := shim.Start(new(Interchain))
	if err != nil {
		fmt.Printf("Error: %s", err)
	}
}
```

{{< /tab >}}
{{< /tabs >}}

## 区块链接入开发(Stub)

开发语言为 Java，需要实现一个区块链的 `WeCross Stub`插件，通过插件接入 `WeCross`。

### Stub 开发

`stub` 开发分为两个部分：系统合约 和 Java 插件。

系统合约包括代理合约(WeCrossProxy)和桥接合约(WeCrossHub)，代理合约是 WeCross 调用该链其它合约的统一入口，桥接合约用于记录跨链调用请求，以配合跨链路由实现合约跨链调用。

{{< tabs items="代理合约,桥接合约" >}}
{{< tab >}}
功能点：

- 合约调用入口
- 事务管理

```solidity
/** 读接口，调用业务合约（不需要脏读，即无事务ID，读事务中资源）
 *
 *  @param _XATransactionID  事务ID
 *  @param _path   目标资源路径
 *  @param _func   调用方法
 *  @param _args   调用参数
 *  @return 调用结果
 */
function constantCall(
    string memory _XATransactionID,
    string memory _path,
    string memory _func,
    bytes memory _args
) public returns(bytes memory)


/** 写接口，调用业务合约
 *
 *  @param _uid  交易ID，用于去重
 *  @param _XATransactionID  事务ID
 *  @param _XATransactionSeq  事务序列号
 *  @param _path   目标资源路径
 *  @param _func   调用方法
 *  @param _args   调用参数
 *  @return 调用结果
 */
function sendTransaction(
    string memory _uid,
    string memory _XATransactionID,
    uint256 _XATransactionSeq,
    string memory _path,
    string memory _func,
    bytes memory _args
) public returns(bytes memory)


/** 开启事务
 *
 *  @param _XATransactionID  事务ID
 *  @param _selfPaths  参与事务的己链资源列表
 *  @param _otherPaths 参与事务的它链资源列表
 *  @return 执行结果
 */
function startXATransaction(
    string memory _xaTransactionID,
    string[] memory _selfPaths,
    string[] memory _otherPaths
) public returns(string memory)


/** 提交事务
 *
 *  @param _XATransactionID  事务ID
 *  @return 执行结果
 */
function commitXATransaction(
    string memory _xaTransactionID
) public returns(string memory)


/** 回滚事务
 *
 *  @param _XATransactionID  事务ID
 *  @return 执行结果
 */
function rollbackXATransaction(
  string memory _xaTransactionID
) public returns(string memory)


/** 获取事务列表
 *
 *  @param _index 下标
 *  @param _size  数量
 *  @return 事务列表详情，JSON格式
 */
function listXATransactions(
    string memory _index,
    uint256 _size
) public view returns (string memory)


/** 获取事务详情
 *
 *  @param _xaTransactionID 事务ID
 *  @return 事务详情，JSON格式
 */
function getXATransaction(
    string memory _xaTransactionID
) public view returns(string memory)
```

{{< /tab >}}

{{< tab >}}
功能点：

- 注册跨链调用请求
- 查询跨链调用回调结果

```solidity
/** 供业务合约调用，注册跨链调用请求
 *
 *  @param _path     目标链合约的路径
 *  @param _method   调用方法名
 *  @param _args     调用参数列表
 *  @param _callbackPath   回调的合约路径
 *  @param _callbackMethod 回调方法名
 *  @return 跨链请求的唯一ID
 */
function interchainInvoke(
        string memory _path,
        string memory _method,
        string[] memory _args,
        string memory _callbackPath,
        string memory _callbackMethod
) public returns(string memory uid)


/** 供跨链路由调用，获取跨链调用请求
 *
 *  @param _num   获取数量
 *  @return       请求列表，JSON格式
 */
function getInterchainRequests(
    uint256 _num
) public view returns(string memory)


/** 供跨链路由调用，更新跨链任务处理进度
 *
 *  @param _index  新下标
 */
function updateCurrentRequestIndex(uint256 _index) public


/** 供跨链路由调用，注册回调结果
 *
 *  @param _uid  跨链请求的唯一ID
 *  @param _tid  事务ID
 *  @param _seq  事务序列号
 *  @param _errorCode 回调错误码
 *  @param _errorMsg  回调错误详情
 *  @param _result    回调结果
 */
function registerCallbackResult(
    string memory _uid,
    string memory _tid,
    string memory _seq,
    string memory _errorCode,
    string memory _errorMsg,
    string[] memory _result
) public


/** 供用户调用，查询回调的调用结果
 *
 *  @param _uid   跨链请求的唯一ID
 *  @return       字符串数组: [事务ID, 事务Seq, 错误码, 错误消息, 回调调用结果的JSON序列化]
 */
function selectCallbackResult(
    string memory _uid
) public view returns(string[] memory)
```

{{< /tab >}}
{{< /tabs >}}

### Java 插件

[开发指南](https://wecross.readthedocs.io/zh-cn/latest/docs/dev/stub.html)

- StubFactory
  - 组件实例化工厂类
- Account
  - 区块链账户，用于交易签名
- Connection
  - 调用区块链 SDK 接口，与区块链交互
- Driver
  - 交易、交易回执、区块等与区块链相关数据的编解码
  - 实现 Stub 的基础接口
  - 调用 Connection 对象的发送入口与区块链交互

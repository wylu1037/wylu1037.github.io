---
title: Go语言协程与通道
date: 2024-03-01T09:10:06+08:00
categories: [go]
tags: [goroutines, channels]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

{{< callout >}}
  {{< font type="orange" text="A goroutine is a lightweight thread managed by the Go runtime. Channels is how you communicate between routines.">}}
{{< /callout >}}

## 1.Goroutines

### Concurrency, what's the benefit
Concurrency is the task of running and managing the multiple computations at the same time. While parallelism is the task of running multiple computations simultaneously.

So what are some benefits:

+ {{< font type="green" index="0" text="Faster processing.">}} The benefit is getting tasks done faster. Imagine that you are searching a computer for files, or processing data, if it’s possible to work on these workloads in parallel, you end up getting the response back faster.
+ {{< font type="blue" text="Responsive apps Another benefit is getting more responsive apps." >}} If you have an app with a UI, imagine it would be great if you can perform some background work without interrupting the responsiveness of the UI.

## 2.Channel
A channel is how we can communicate cross go routines but also between go routines and the part of our code not using a go routine.
The idea is to send a value to a channel, and have part of our code listen to values from a channel.

Go语言的并发模型是CSP（Communicating Sequential Processes），提倡通过通信共享内存而不是通过共享内存而实现通信。channel是go携程之间通信的载体，可以连接不同的go携程，是让一个go携程发送特定值到另一个go携程的通信机制。

```go {filename="chan.go"}
type hchan struct {
	qcount   uint           // total data in the queue
	dataqsiz uint           // size of the circular queue
	buf      unsafe.Pointer // points to an array of dataqsiz elements
	elemsize uint16
	closed   uint32
	elemtype *_type // element type
	sendx    uint   // send index
	recvx    uint   // receive index
	recvq    waitq  // list of recv waiters
	sendq    waitq  // list of send waiters

	// lock protects all fields in hchan, as well as several
	// fields in sudogs blocked on this channel.
	//
	// Do not change another G's status while holding this lock
	// (in particular, do not ready a G), as this can deadlock
	// with stack shrinking.
	lock mutex
}
```

### Creating a channel
To create a channel, you need the keyword {{< font "orange" "chan">}} and the data type of the messages you are about to send into it. Here’s an example:
```go
ch := make(chan int)
```

### Sending a value to a channel
To send to a channel, you need to use this operator `<-`, it look like a left pointing arrow and is meant to be read as the direction something is sent. Here’s an example of sending a message to a channel:
```go
ch <- 2
```
{{< callout type="info" emoji="📘" >}}
  + No cahce channel will be execute only when the receiver are ready.
  + A cached channel and space of cache has rest, the send action also will be execute.
  + Program will occur run-time panic when send data to the closed channel.
  + Program will be block when send data to the channel that is nil.
{{< /callout >}}

### Listening to a channel
To listen to a channel, you again use the arrow `<-`, but this time you need a receiving variable on the left side and the channel on the right side, like so:
```go
value := <- ch
```
{{< callout emoji="📒" >}}
  + 从一个nil channel中接收数据会一直被block；
  + 从一个被close的channel中接收数据不会被阻塞，而是立即返回，接收完已发送的数据后会返回元素类型的零值(zero value)。
{{< /callout >}}

### Matching sending and receiving
{{< tabs items="for range, select {}">}}
  {{< tab >}}
    `range ch` 产生的迭代值为 ***channel*** 中发送的值，它会一直迭代直到 ***channel*** 被关闭。上面的例子中如果把 `close(ch)` 注释掉，程序会一直阻塞在 `for …… range` 行。

    ```go {hl_lines=[7,9,10,11]}
    func main(){
        ch := make(chan int)
        go func() {
            for i := 0; i < 10; i = i + 1 {
                ch <- i
            }
            close(ch)
        }()
        for v := range ch {
            fmt.Println(v)
        }
        fmt.Println("Finished")
    }
    ```
  {{< /tab >}}

  {{< tab >}}
    如果同时有多个 channel 可以接收数据，go {{< icon go>}} 会伪随机选择一个 case 处理（pseudo-random）。如果没有 case 需要处理，则会选择 default 去处理。如果 default case 不存在，则 select 会阻塞直到某个 case 需要处理。
    select 不是循环，只会选择一个 case 处理，需要一直处理 channel，需要一个无限 for 循环。

    ```go
    func main() {
        c1 := make(chan string, 1)
        go func() {
            time.Sleep(time.Second * 2)
            c1 <- "result 1"
        }()
        select {
        case res := <-c1:
            fmt.Println(res)
        case <-time.After(time.Second * 1):
            fmt.Println("timeout 1")
        }
    }
    ```
    > `time.After` 返回一个 `<-chan Time` 的单向 channel，在指定的时间发送一个当前时间到 channel 中。
  {{< /tab >}}
{{< /tabs >}}

Let’s say you have the following code:
```go
package main

import "fmt"

func produceResults(ch chan int) {
    ch <- 1
    ch <- 2
}

func main() {
    ch := make(chan int)
    go produceResults(ch)

    var result int
    result = <-ch
    fmt.Println(result)
    result = <-ch
    fmt.Println(result)
}
```
> {{< font "orange" "Output" >}}<br>
> 1<br>
> 2<br>

<br>
So what happends if you produce more values than you receive like so?

```go
func produceResults(ch chan int) {
    ch <- 1
    ch <- 2
    ch <- 3
}
```
> Answer: you will miss out on the extra value.

What if it’s the opposite, you try to receive one more value than you actually get?
```go
func main() {
    ch := make(chan int)
    go produceResults(ch)

    var result int
    result = <-ch
    fmt.Println(result)
    result = <-ch
    fmt.Println(result)
    esult = <-ch
    fmt.Println(result)
    result = <-ch
    fmt.Println(result)
    esult = <-ch
    fmt.Println(result)
    result = <-ch
    fmt.Println(result)
}
```
> At this point, your code will deadlock, like so: {{< font "ornage" "fatal error: all goroutines are asleep - deadlock!">}}. Your code will never finish as that value will never arrive.

There’s another way to receive values, and that’s by using a select like so:
```go
for i := 0; i < 2; i++ {
    select {
        case x, ok := <-ch:
        if ok {
            fmt.Println(x)
        } else {
            panic(errors.New("channel is closed."))
        }
    }
 }
 ```

Now, we might have more long running tasks, at which point we need to sit and wait until the channel tells us it closed. Here’s code to handle that:

```go
label:
for {
    select {
        case x, ok := <-ch:
        if ok {
            fmt.Println(x)
        } else {
            fmt.Println("channel closed")
            break label
        }
    }
}
```
What’s happening here is that we set up a for loop that runs forever, until closed. To ensure we break out of the for loop and not just the select, we add label.

### Closing a channel
A channel is open until you close it. You can actively close it by calling `close()` with the channel as an input parameter:
```go
close(ch)
```

### Channel types
#### Block channel(No cache)
```go
func main() {
    ch := make(chan int)
    ch <- 5
    fmt.Println("发送成功")
}
```
{{< callout type="error" emoji="🧑🏽‍💻">}}
  执行时报错：{{< font type="red" text="fatal error: all goroutines are asleep - deadlock!" >}}
{{< /callout >}}

无缓存的channel只有在有人接收值时才能发送值。

可以启用一个goroutines去接收值：
```go
func recv(ch chan int) {
    ret := <-ch
    fmt.Println("接收成功", ret)
}

func main() {
    ch := make(chan int)
    go recv()
    ch <- 5
    fmt.Println("发送成功")
}
```

> 无缓冲通道上的发送操作会阻塞，直到另一个goroutines在该通道上执行接收操作，值才会发送成功🏅。如果接收操作先执行，接收方的goroutines将阻塞，直到另一个goroutines在该通道上发送一个值。
> 使用无缓冲通道进行通行将导致发送和接收的goroutines同步化。因此，无缓冲通道也被称为同步通道。

#### Non block channel
```go
func main(){
    ch := make(chan int ,1)  // 创建一个容量为 1 的有缓冲区的通道
    ch <- 10
    fmt.Println("发送成功")
}
```

#### One-way channel
限制channel在函数中只能发送或者接收。
```go
// 单向发送 out 通道
func cter(out chan <- int){
    for i := 0; i < 10; i++ {
        out <- i
    }
    close(out)
}

// 单向发送 out 通道， 单向接收 in 通道
func sqer(out chan <- int , in <- chan int){
    for i := range in{
        out <- i * i
    }
    close(out)
}

// 单向接收 in 通道
func prter(in <-chan int){
    for i := range in {
        fmt.Println(i)
    }
}

func main(){
    out := make(chan int)
    in := make(chan int)
    go cter(out)
    go sqer(out, in)
    prter(in)
}
```

#### Timer & Ticker
{{< tabs items="🫐 Timer, 🍑 Ticker">}}
  {{< tab >}}
    Timer 是一个定时器，代表未来的一个单一事件。time.NewTimer会接收一个时间，返回一个 channel。

    ```go
    t := time.NewTimer(2*time.Second)
    <-t.C
    fmt.Println("Elapsed 2 seconds, Timer expired")
    stoped := t.Stop // 停止计时器 ⏱️
    if (stopped) {
        fmt.Println("Timer already stopped")
    }
    ```
  {{< /tab >}}

  {{< tab >}}
    Ticker 是一个定时触发的计时器，以一个间隔往 channel 中发送一个当前时间，接收者以固定的时间间隔从 channel 中接收。

    ```go
    ticker := time.NewTicker(time.Millisecond * 500)
    go func() {
        for t := range ticker.C {
            fmt.Println("Tick at", t)
        }
    }()
    ```
  {{< /tab >}}
{{< /tabs >}}

#### Channel errors
|chan|receiver|sender|closed|
|---|---|---|---|
|nil|阻塞|阻塞|panic|
|Empty|阻塞|发送值|关闭成功|
|Non empty|接收值|发送值|关闭成功，接收数据|
|Full|接收值|阻塞|关闭成功，接收数据|
|Not full|接收值|发送值|关闭成功，接收数据|

### Channel source code
{{% details title="chan.go source code" closed="true" %}}
```go {filename="runtime/chan.go"}
// Copyright 2014 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package runtime

// This file contains the implementation of Go channels.

// Invariants:
//  At least one of c.sendq and c.recvq is empty,
//  except for the case of an unbuffered channel with a single goroutine
//  blocked on it for both sending and receiving using a select statement,
//  in which case the length of c.sendq and c.recvq is limited only by the
//  size of the select statement.
//
// For buffered channels, also:
//  c.qcount > 0 implies that c.recvq is empty.
//  c.qcount < c.dataqsiz implies that c.sendq is empty.

import (
	"internal/abi"
	"runtime/internal/atomic"
	"runtime/internal/math"
	"unsafe"
)

const (
	maxAlign  = 8
	hchanSize = unsafe.Sizeof(hchan{}) + uintptr(-int(unsafe.Sizeof(hchan{}))&(maxAlign-1))
	debugChan = false
)

type hchan struct {
	qcount   uint           // total data in the queue
	dataqsiz uint           // size of the circular queue
	buf      unsafe.Pointer // points to an array of dataqsiz elements
	elemsize uint16
	closed   uint32
	elemtype *_type // element type
	sendx    uint   // send index
	recvx    uint   // receive index
	recvq    waitq  // list of recv waiters
	sendq    waitq  // list of send waiters

	// lock protects all fields in hchan, as well as several
	// fields in sudogs blocked on this channel.
	//
	// Do not change another G's status while holding this lock
	// (in particular, do not ready a G), as this can deadlock
	// with stack shrinking.
	lock mutex
}

type waitq struct {
	first *sudog
	last  *sudog
}

//go:linkname reflect_makechan reflect.makechan
func reflect_makechan(t *chantype, size int) *hchan {
	return makechan(t, size)
}

func makechan64(t *chantype, size int64) *hchan {
	if int64(int(size)) != size {
		panic(plainError("makechan: size out of range"))
	}

	return makechan(t, int(size))
}

func makechan(t *chantype, size int) *hchan {
	elem := t.Elem

	// compiler checks this but be safe.
	if elem.Size_ >= 1<<16 {
		throw("makechan: invalid channel element type")
	}
	if hchanSize%maxAlign != 0 || elem.Align_ > maxAlign {
		throw("makechan: bad alignment")
	}

	mem, overflow := math.MulUintptr(elem.Size_, uintptr(size))
	if overflow || mem > maxAlloc-hchanSize || size < 0 {
		panic(plainError("makechan: size out of range"))
	}

	// Hchan does not contain pointers interesting for GC when elements stored in buf do not contain pointers.
	// buf points into the same allocation, elemtype is persistent.
	// SudoG's are referenced from their owning thread so they can't be collected.
	// TODO(dvyukov,rlh): Rethink when collector can move allocated objects.
	var c *hchan
	switch {
	case mem == 0:
		// Queue or element size is zero.
		c = (*hchan)(mallocgc(hchanSize, nil, true))
		// Race detector uses this location for synchronization.
		c.buf = c.raceaddr()
	case elem.PtrBytes == 0:
		// Elements do not contain pointers.
		// Allocate hchan and buf in one call.
		c = (*hchan)(mallocgc(hchanSize+mem, nil, true))
		c.buf = add(unsafe.Pointer(c), hchanSize)
	default:
		// Elements contain pointers.
		c = new(hchan)
		c.buf = mallocgc(mem, elem, true)
	}

	c.elemsize = uint16(elem.Size_)
	c.elemtype = elem
	c.dataqsiz = uint(size)
	lockInit(&c.lock, lockRankHchan)

	if debugChan {
		print("makechan: chan=", c, "; elemsize=", elem.Size_, "; dataqsiz=", size, "\n")
	}
	return c
}

// chanbuf(c, i) is pointer to the i'th slot in the buffer.
func chanbuf(c *hchan, i uint) unsafe.Pointer {
	return add(c.buf, uintptr(i)*uintptr(c.elemsize))
}

// full reports whether a send on c would block (that is, the channel is full).
// It uses a single word-sized read of mutable state, so although
// the answer is instantaneously true, the correct answer may have changed
// by the time the calling function receives the return value.
func full(c *hchan) bool {
	// c.dataqsiz is immutable (never written after the channel is created)
	// so it is safe to read at any time during channel operation.
	if c.dataqsiz == 0 {
		// Assumes that a pointer read is relaxed-atomic.
		return c.recvq.first == nil
	}
	// Assumes that a uint read is relaxed-atomic.
	return c.qcount == c.dataqsiz
}

// entry point for c <- x from compiled code.
//
//go:nosplit
func chansend1(c *hchan, elem unsafe.Pointer) {
	chansend(c, elem, true, getcallerpc())
}

/*
 * generic single channel send/recv
 * If block is not nil,
 * then the protocol will not
 * sleep but return if it could
 * not complete.
 *
 * sleep can wake up with g.param == nil
 * when a channel involved in the sleep has
 * been closed.  it is easiest to loop and re-run
 * the operation; we'll see that it's now closed.
 */
func chansend(c *hchan, ep unsafe.Pointer, block bool, callerpc uintptr) bool {
	if c == nil {
		if !block {
			return false
		}
		gopark(nil, nil, waitReasonChanSendNilChan, traceBlockForever, 2)
		throw("unreachable")
	}

	if debugChan {
		print("chansend: chan=", c, "\n")
	}

	if raceenabled {
		racereadpc(c.raceaddr(), callerpc, abi.FuncPCABIInternal(chansend))
	}

	// Fast path: check for failed non-blocking operation without acquiring the lock.
	//
	// After observing that the channel is not closed, we observe that the channel is
	// not ready for sending. Each of these observations is a single word-sized read
	// (first c.closed and second full()).
	// Because a closed channel cannot transition from 'ready for sending' to
	// 'not ready for sending', even if the channel is closed between the two observations,
	// they imply a moment between the two when the channel was both not yet closed
	// and not ready for sending. We behave as if we observed the channel at that moment,
	// and report that the send cannot proceed.
	//
	// It is okay if the reads are reordered here: if we observe that the channel is not
	// ready for sending and then observe that it is not closed, that implies that the
	// channel wasn't closed during the first observation. However, nothing here
	// guarantees forward progress. We rely on the side effects of lock release in
	// chanrecv() and closechan() to update this thread's view of c.closed and full().
	if !block && c.closed == 0 && full(c) {
		return false
	}

	var t0 int64
	if blockprofilerate > 0 {
		t0 = cputicks()
	}

	lock(&c.lock)

	if c.closed != 0 {
		unlock(&c.lock)
		panic(plainError("send on closed channel"))
	}

	if sg := c.recvq.dequeue(); sg != nil {
		// Found a waiting receiver. We pass the value we want to send
		// directly to the receiver, bypassing the channel buffer (if any).
		send(c, sg, ep, func() { unlock(&c.lock) }, 3)
		return true
	}

	if c.qcount < c.dataqsiz {
		// Space is available in the channel buffer. Enqueue the element to send.
		qp := chanbuf(c, c.sendx)
		if raceenabled {
			racenotify(c, c.sendx, nil)
		}
		typedmemmove(c.elemtype, qp, ep)
		c.sendx++
		if c.sendx == c.dataqsiz {
			c.sendx = 0
		}
		c.qcount++
		unlock(&c.lock)
		return true
	}

	if !block {
		unlock(&c.lock)
		return false
	}

	// Block on the channel. Some receiver will complete our operation for us.
	gp := getg()
	mysg := acquireSudog()
	mysg.releasetime = 0
	if t0 != 0 {
		mysg.releasetime = -1
	}
	// No stack splits between assigning elem and enqueuing mysg
	// on gp.waiting where copystack can find it.
	mysg.elem = ep
	mysg.waitlink = nil
	mysg.g = gp
	mysg.isSelect = false
	mysg.c = c
	gp.waiting = mysg
	gp.param = nil
	c.sendq.enqueue(mysg)
	// Signal to anyone trying to shrink our stack that we're about
	// to park on a channel. The window between when this G's status
	// changes and when we set gp.activeStackChans is not safe for
	// stack shrinking.
	gp.parkingOnChan.Store(true)
	gopark(chanparkcommit, unsafe.Pointer(&c.lock), waitReasonChanSend, traceBlockChanSend, 2)
	// Ensure the value being sent is kept alive until the
	// receiver copies it out. The sudog has a pointer to the
	// stack object, but sudogs aren't considered as roots of the
	// stack tracer.
	KeepAlive(ep)

	// someone woke us up.
	if mysg != gp.waiting {
		throw("G waiting list is corrupted")
	}
	gp.waiting = nil
	gp.activeStackChans = false
	closed := !mysg.success
	gp.param = nil
	if mysg.releasetime > 0 {
		blockevent(mysg.releasetime-t0, 2)
	}
	mysg.c = nil
	releaseSudog(mysg)
	if closed {
		if c.closed == 0 {
			throw("chansend: spurious wakeup")
		}
		panic(plainError("send on closed channel"))
	}
	return true
}

// send processes a send operation on an empty channel c.
// The value ep sent by the sender is copied to the receiver sg.
// The receiver is then woken up to go on its merry way.
// Channel c must be empty and locked.  send unlocks c with unlockf.
// sg must already be dequeued from c.
// ep must be non-nil and point to the heap or the caller's stack.
func send(c *hchan, sg *sudog, ep unsafe.Pointer, unlockf func(), skip int) {
	if raceenabled {
		if c.dataqsiz == 0 {
			racesync(c, sg)
		} else {
			// Pretend we go through the buffer, even though
			// we copy directly. Note that we need to increment
			// the head/tail locations only when raceenabled.
			racenotify(c, c.recvx, nil)
			racenotify(c, c.recvx, sg)
			c.recvx++
			if c.recvx == c.dataqsiz {
				c.recvx = 0
			}
			c.sendx = c.recvx // c.sendx = (c.sendx+1) % c.dataqsiz
		}
	}
	if sg.elem != nil {
		sendDirect(c.elemtype, sg, ep)
		sg.elem = nil
	}
	gp := sg.g
	unlockf()
	gp.param = unsafe.Pointer(sg)
	sg.success = true
	if sg.releasetime != 0 {
		sg.releasetime = cputicks()
	}
	goready(gp, skip+1)
}

// Sends and receives on unbuffered or empty-buffered channels are the
// only operations where one running goroutine writes to the stack of
// another running goroutine. The GC assumes that stack writes only
// happen when the goroutine is running and are only done by that
// goroutine. Using a write barrier is sufficient to make up for
// violating that assumption, but the write barrier has to work.
// typedmemmove will call bulkBarrierPreWrite, but the target bytes
// are not in the heap, so that will not help. We arrange to call
// memmove and typeBitsBulkBarrier instead.

func sendDirect(t *_type, sg *sudog, src unsafe.Pointer) {
	// src is on our stack, dst is a slot on another stack.

	// Once we read sg.elem out of sg, it will no longer
	// be updated if the destination's stack gets copied (shrunk).
	// So make sure that no preemption points can happen between read & use.
	dst := sg.elem
	typeBitsBulkBarrier(t, uintptr(dst), uintptr(src), t.Size_)
	// No need for cgo write barrier checks because dst is always
	// Go memory.
	memmove(dst, src, t.Size_)
}

func recvDirect(t *_type, sg *sudog, dst unsafe.Pointer) {
	// dst is on our stack or the heap, src is on another stack.
	// The channel is locked, so src will not move during this
	// operation.
	src := sg.elem
	typeBitsBulkBarrier(t, uintptr(dst), uintptr(src), t.Size_)
	memmove(dst, src, t.Size_)
}

func closechan(c *hchan) {
	if c == nil {
		panic(plainError("close of nil channel"))
	}

	lock(&c.lock)
	if c.closed != 0 {
		unlock(&c.lock)
		panic(plainError("close of closed channel"))
	}

	if raceenabled {
		callerpc := getcallerpc()
		racewritepc(c.raceaddr(), callerpc, abi.FuncPCABIInternal(closechan))
		racerelease(c.raceaddr())
	}

	c.closed = 1

	var glist gList

	// release all readers
	for {
		sg := c.recvq.dequeue()
		if sg == nil {
			break
		}
		if sg.elem != nil {
			typedmemclr(c.elemtype, sg.elem)
			sg.elem = nil
		}
		if sg.releasetime != 0 {
			sg.releasetime = cputicks()
		}
		gp := sg.g
		gp.param = unsafe.Pointer(sg)
		sg.success = false
		if raceenabled {
			raceacquireg(gp, c.raceaddr())
		}
		glist.push(gp)
	}

	// release all writers (they will panic)
	for {
		sg := c.sendq.dequeue()
		if sg == nil {
			break
		}
		sg.elem = nil
		if sg.releasetime != 0 {
			sg.releasetime = cputicks()
		}
		gp := sg.g
		gp.param = unsafe.Pointer(sg)
		sg.success = false
		if raceenabled {
			raceacquireg(gp, c.raceaddr())
		}
		glist.push(gp)
	}
	unlock(&c.lock)

	// Ready all Gs now that we've dropped the channel lock.
	for !glist.empty() {
		gp := glist.pop()
		gp.schedlink = 0
		goready(gp, 3)
	}
}

// empty reports whether a read from c would block (that is, the channel is
// empty).  It uses a single atomic read of mutable state.
func empty(c *hchan) bool {
	// c.dataqsiz is immutable.
	if c.dataqsiz == 0 {
		return atomic.Loadp(unsafe.Pointer(&c.sendq.first)) == nil
	}
	return atomic.Loaduint(&c.qcount) == 0
}

// entry points for <- c from compiled code.
//
//go:nosplit
func chanrecv1(c *hchan, elem unsafe.Pointer) {
	chanrecv(c, elem, true)
}

//go:nosplit
func chanrecv2(c *hchan, elem unsafe.Pointer) (received bool) {
	_, received = chanrecv(c, elem, true)
	return
}

// chanrecv receives on channel c and writes the received data to ep.
// ep may be nil, in which case received data is ignored.
// If block == false and no elements are available, returns (false, false).
// Otherwise, if c is closed, zeros *ep and returns (true, false).
// Otherwise, fills in *ep with an element and returns (true, true).
// A non-nil ep must point to the heap or the caller's stack.
func chanrecv(c *hchan, ep unsafe.Pointer, block bool) (selected, received bool) {
	// raceenabled: don't need to check ep, as it is always on the stack
	// or is new memory allocated by reflect.

	if debugChan {
		print("chanrecv: chan=", c, "\n")
	}

	if c == nil {
		if !block {
			return
		}
		gopark(nil, nil, waitReasonChanReceiveNilChan, traceBlockForever, 2)
		throw("unreachable")
	}

	// Fast path: check for failed non-blocking operation without acquiring the lock.
	if !block && empty(c) {
		// After observing that the channel is not ready for receiving, we observe whether the
		// channel is closed.
		//
		// Reordering of these checks could lead to incorrect behavior when racing with a close.
		// For example, if the channel was open and not empty, was closed, and then drained,
		// reordered reads could incorrectly indicate "open and empty". To prevent reordering,
		// we use atomic loads for both checks, and rely on emptying and closing to happen in
		// separate critical sections under the same lock.  This assumption fails when closing
		// an unbuffered channel with a blocked send, but that is an error condition anyway.
		if atomic.Load(&c.closed) == 0 {
			// Because a channel cannot be reopened, the later observation of the channel
			// being not closed implies that it was also not closed at the moment of the
			// first observation. We behave as if we observed the channel at that moment
			// and report that the receive cannot proceed.
			return
		}
		// The channel is irreversibly closed. Re-check whether the channel has any pending data
		// to receive, which could have arrived between the empty and closed checks above.
		// Sequential consistency is also required here, when racing with such a send.
		if empty(c) {
			// The channel is irreversibly closed and empty.
			if raceenabled {
				raceacquire(c.raceaddr())
			}
			if ep != nil {
				typedmemclr(c.elemtype, ep)
			}
			return true, false
		}
	}

	var t0 int64
	if blockprofilerate > 0 {
		t0 = cputicks()
	}

	lock(&c.lock)

	if c.closed != 0 {
		if c.qcount == 0 {
			if raceenabled {
				raceacquire(c.raceaddr())
			}
			unlock(&c.lock)
			if ep != nil {
				typedmemclr(c.elemtype, ep)
			}
			return true, false
		}
		// The channel has been closed, but the channel's buffer have data.
	} else {
		// Just found waiting sender with not closed.
		if sg := c.sendq.dequeue(); sg != nil {
			// Found a waiting sender. If buffer is size 0, receive value
			// directly from sender. Otherwise, receive from head of queue
			// and add sender's value to the tail of the queue (both map to
			// the same buffer slot because the queue is full).
			recv(c, sg, ep, func() { unlock(&c.lock) }, 3)
			return true, true
		}
	}

	if c.qcount > 0 {
		// Receive directly from queue
		qp := chanbuf(c, c.recvx)
		if raceenabled {
			racenotify(c, c.recvx, nil)
		}
		if ep != nil {
			typedmemmove(c.elemtype, ep, qp)
		}
		typedmemclr(c.elemtype, qp)
		c.recvx++
		if c.recvx == c.dataqsiz {
			c.recvx = 0
		}
		c.qcount--
		unlock(&c.lock)
		return true, true
	}

	if !block {
		unlock(&c.lock)
		return false, false
	}

	// no sender available: block on this channel.
	gp := getg()
	mysg := acquireSudog()
	mysg.releasetime = 0
	if t0 != 0 {
		mysg.releasetime = -1
	}
	// No stack splits between assigning elem and enqueuing mysg
	// on gp.waiting where copystack can find it.
	mysg.elem = ep
	mysg.waitlink = nil
	gp.waiting = mysg
	mysg.g = gp
	mysg.isSelect = false
	mysg.c = c
	gp.param = nil
	c.recvq.enqueue(mysg)
	// Signal to anyone trying to shrink our stack that we're about
	// to park on a channel. The window between when this G's status
	// changes and when we set gp.activeStackChans is not safe for
	// stack shrinking.
	gp.parkingOnChan.Store(true)
	gopark(chanparkcommit, unsafe.Pointer(&c.lock), waitReasonChanReceive, traceBlockChanRecv, 2)

	// someone woke us up
	if mysg != gp.waiting {
		throw("G waiting list is corrupted")
	}
	gp.waiting = nil
	gp.activeStackChans = false
	if mysg.releasetime > 0 {
		blockevent(mysg.releasetime-t0, 2)
	}
	success := mysg.success
	gp.param = nil
	mysg.c = nil
	releaseSudog(mysg)
	return true, success
}

// recv processes a receive operation on a full channel c.
// There are 2 parts:
//  1. The value sent by the sender sg is put into the channel
//     and the sender is woken up to go on its merry way.
//  2. The value received by the receiver (the current G) is
//     written to ep.
//
// For synchronous channels, both values are the same.
// For asynchronous channels, the receiver gets its data from
// the channel buffer and the sender's data is put in the
// channel buffer.
// Channel c must be full and locked. recv unlocks c with unlockf.
// sg must already be dequeued from c.
// A non-nil ep must point to the heap or the caller's stack.
func recv(c *hchan, sg *sudog, ep unsafe.Pointer, unlockf func(), skip int) {
	if c.dataqsiz == 0 {
		if raceenabled {
			racesync(c, sg)
		}
		if ep != nil {
			// copy data from sender
			recvDirect(c.elemtype, sg, ep)
		}
	} else {
		// Queue is full. Take the item at the
		// head of the queue. Make the sender enqueue
		// its item at the tail of the queue. Since the
		// queue is full, those are both the same slot.
		qp := chanbuf(c, c.recvx)
		if raceenabled {
			racenotify(c, c.recvx, nil)
			racenotify(c, c.recvx, sg)
		}
		// copy data from queue to receiver
		if ep != nil {
			typedmemmove(c.elemtype, ep, qp)
		}
		// copy data from sender to queue
		typedmemmove(c.elemtype, qp, sg.elem)
		c.recvx++
		if c.recvx == c.dataqsiz {
			c.recvx = 0
		}
		c.sendx = c.recvx // c.sendx = (c.sendx+1) % c.dataqsiz
	}
	sg.elem = nil
	gp := sg.g
	unlockf()
	gp.param = unsafe.Pointer(sg)
	sg.success = true
	if sg.releasetime != 0 {
		sg.releasetime = cputicks()
	}
	goready(gp, skip+1)
}

func chanparkcommit(gp *g, chanLock unsafe.Pointer) bool {
	// There are unlocked sudogs that point into gp's stack. Stack
	// copying must lock the channels of those sudogs.
	// Set activeStackChans here instead of before we try parking
	// because we could self-deadlock in stack growth on the
	// channel lock.
	gp.activeStackChans = true
	// Mark that it's safe for stack shrinking to occur now,
	// because any thread acquiring this G's stack for shrinking
	// is guaranteed to observe activeStackChans after this store.
	gp.parkingOnChan.Store(false)
	// Make sure we unlock after setting activeStackChans and
	// unsetting parkingOnChan. The moment we unlock chanLock
	// we risk gp getting readied by a channel operation and
	// so gp could continue running before everything before
	// the unlock is visible (even to gp itself).
	unlock((*mutex)(chanLock))
	return true
}

// compiler implements
//
//	select {
//	case c <- v:
//		... foo
//	default:
//		... bar
//	}
//
// as
//
//	if selectnbsend(c, v) {
//		... foo
//	} else {
//		... bar
//	}
func selectnbsend(c *hchan, elem unsafe.Pointer) (selected bool) {
	return chansend(c, elem, false, getcallerpc())
}

// compiler implements
//
//	select {
//	case v, ok = <-c:
//		... foo
//	default:
//		... bar
//	}
//
// as
//
//	if selected, ok = selectnbrecv(&v, c); selected {
//		... foo
//	} else {
//		... bar
//	}
func selectnbrecv(elem unsafe.Pointer, c *hchan) (selected, received bool) {
	return chanrecv(c, elem, false)
}

//go:linkname reflect_chansend reflect.chansend0
func reflect_chansend(c *hchan, elem unsafe.Pointer, nb bool) (selected bool) {
	return chansend(c, elem, !nb, getcallerpc())
}

//go:linkname reflect_chanrecv reflect.chanrecv
func reflect_chanrecv(c *hchan, nb bool, elem unsafe.Pointer) (selected bool, received bool) {
	return chanrecv(c, elem, !nb)
}

//go:linkname reflect_chanlen reflect.chanlen
func reflect_chanlen(c *hchan) int {
	if c == nil {
		return 0
	}
	return int(c.qcount)
}

//go:linkname reflectlite_chanlen internal/reflectlite.chanlen
func reflectlite_chanlen(c *hchan) int {
	if c == nil {
		return 0
	}
	return int(c.qcount)
}

//go:linkname reflect_chancap reflect.chancap
func reflect_chancap(c *hchan) int {
	if c == nil {
		return 0
	}
	return int(c.dataqsiz)
}

//go:linkname reflect_chanclose reflect.chanclose
func reflect_chanclose(c *hchan) {
	closechan(c)
}

func (q *waitq) enqueue(sgp *sudog) {
	sgp.next = nil
	x := q.last
	if x == nil {
		sgp.prev = nil
		q.first = sgp
		q.last = sgp
		return
	}
	sgp.prev = x
	x.next = sgp
	q.last = sgp
}

func (q *waitq) dequeue() *sudog {
	for {
		sgp := q.first
		if sgp == nil {
			return nil
		}
		y := sgp.next
		if y == nil {
			q.first = nil
			q.last = nil
		} else {
			y.prev = nil
			q.first = y
			sgp.next = nil // mark as removed (see dequeueSudoG)
		}

		// if a goroutine was put on this queue because of a
		// select, there is a small window between the goroutine
		// being woken up by a different case and it grabbing the
		// channel locks. Once it has the lock
		// it removes itself from the queue, so we won't see it after that.
		// We use a flag in the G struct to tell us when someone
		// else has won the race to signal this goroutine but the goroutine
		// hasn't removed itself from the queue yet.
		if sgp.isSelect && !sgp.g.selectDone.CompareAndSwap(0, 1) {
			continue
		}

		return sgp
	}
}

func (c *hchan) raceaddr() unsafe.Pointer {
	// Treat read-like and write-like operations on the channel to
	// happen at this address. Avoid using the address of qcount
	// or dataqsiz, because the len() and cap() builtins read
	// those addresses, and we don't want them racing with
	// operations like close().
	return unsafe.Pointer(&c.buf)
}

func racesync(c *hchan, sg *sudog) {
	racerelease(chanbuf(c, 0))
	raceacquireg(sg.g, chanbuf(c, 0))
	racereleaseg(sg.g, chanbuf(c, 0))
	raceacquire(chanbuf(c, 0))
}

// Notify the race detector of a send or receive involving buffer entry idx
// and a channel c or its communicating partner sg.
// This function handles the special case of c.elemsize==0.
func racenotify(c *hchan, idx uint, sg *sudog) {
	// We could have passed the unsafe.Pointer corresponding to entry idx
	// instead of idx itself.  However, in a future version of this function,
	// we can use idx to better handle the case of elemsize==0.
	// A future improvement to the detector is to call TSan with c and idx:
	// this way, Go will continue to not allocating buffer entries for channels
	// of elemsize==0, yet the race detector can be made to handle multiple
	// sync objects underneath the hood (one sync object per idx)
	qp := chanbuf(c, idx)
	// When elemsize==0, we don't allocate a full buffer for the channel.
	// Instead of individual buffer entries, the race detector uses the
	// c.buf as the only buffer entry.  This simplification prevents us from
	// following the memory model's happens-before rules (rules that are
	// implemented in racereleaseacquire).  Instead, we accumulate happens-before
	// information in the synchronization object associated with c.buf.
	if c.elemsize == 0 {
		if sg == nil {
			raceacquire(qp)
			racerelease(qp)
		} else {
			raceacquireg(sg.g, qp)
			racereleaseg(sg.g, qp)
		}
	} else {
		if sg == nil {
			racereleaseacquire(qp)
		} else {
			racereleaseacquireg(sg.g, qp)
		}
	}
}
```
{{% /details %}}

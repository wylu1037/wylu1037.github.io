---
title: React
date: 2024-03-03T11:18:19+08:00
width: full
weight: 1
---

## 1.Context

在 `React` 中，`Context` 是用于共享一些在组件树中被认为是「全局」的数据，比如当前的用户信息、主题或首选语言。

### 1.1 创建 Context

```tsx
import React, { createContext } from "react";

const MyContext = createContext<string>("defaultValue");
```

> defaultValue 是在没有匹配到 **Provider** 时的默认值。

### 1.2 创建 Provider

**Provider** 组件用于将 `Context` 的值传递给组件树中的子组件。

```tsx
import React from "react";

const MyProvider = ({ children }) => {
  const value = {
    /* some values */
  };

  return <MyContext.Provider value={value}>{children}</MyContext.Provider>;
};
```

### 1.3 使用 Consumer 或 useContext Hook

有两种方法来使用 Context 的值：`Consumer` 组件和 `useContext` Hook。

#### 1.3.1 Consumer 组件

使用 `MyContext.Consumer` 来访问 Context 的值。

```tsx
<MyContext.Consumer>
  {(value) => <div>{/* 根据value渲染UI */}</div>}
</MyContext.Consumer>
```

#### 1.3.2 useContext Hook

在函数组件中，可以使用 `useContext` 来更简便地访问值。

```tsx
import React, { useContext } from "react";

const MyComponent = () => {
  const value = useContext(MyContext);

  return <div>{/* 根据value渲染UI */}</div>;
};
```

## 2.State

{{< components/shell-card command="npm" args="install zustand@latest" >}}

## 3.Hook

`Hook` 是 `React 16.8` 引入的新特性，允许你在不编写 class 的情况下使用 state 以及其他的 React 特性。

在 React 中，所有的自定义 `Hook` 函数名都应该以 "use" 开头。这是一个约定，让 React 知道这个函数是一个 `Hook`。

### 3.1 useState

用于在函数组件中添加状态

```tsx
import React, { useState } from "react";

function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>你点击了 {count} 次</p>
      <button onClick={() => setCount(count + 1)}>点击我</button>
    </div>
  );
}
```

### 3.2 useEffect

用于处理副作用，如数据获取、订阅或手动更改 DOM。

#### 3.2.1 基本语法

```tsx
import React, { useEffect } from 'react';

function ExampleComponent() {
  useEffect(() => {
    // 副作用代码
    return () => {
      // 清理函数（可选）
    };
  }, [/* 依赖数组 */]);

  return (
    // 组件JSX
  );
}
```

#### 3.2.2 示例

{{< font "blue" "组件每次渲染后都会执行" >}}

```tsx
useEffect(() => {
  console.log("组件渲染了");
});
```

{{< font "blue" "仅在组件挂载时执行一次" >}}

```tsx
useEffect(() => {
  console.log("组件挂载了");
}, []);
```

{{< font "blue" "当依赖项变化时执行" >}}

```tsx
const [count, setCount] = useState(0);

useEffect(() => {
  document.title = `点击了 ${count} 次`;
}, [count]);
```

{{< font "blue" "组件卸载时执行" >}}

```tsx
useEffect(() => {
  const timer = setInterval(() => {
    console.log("定时器运行中");
  }, 1000);

  return () => {
    clearInterval(timer);
  };
}, []);
```

### 3.3 useContext

用于访问 React 的 Context

```tsx
import React, { useContext } from "react";

const ThemeContext = React.createContext("light");

function ThemedButton() {
  const theme = useContext(ThemeContext);
  return <button style={{ background: theme }}>我是主题按钮</button>;
}
```

### 3.4 useRef

用于创建一个可变的 `ref` 对象。

```tsx
import React, { useRef, useEffect } from "react";

function FocusInput() {
  const inputRef = useRef(null);

  useEffect(() => {
    inputRef.current.focus();
  }, []);

  return <input ref={inputRef} />;
}
```

> inputRef.current 可以获取到 input 元素的引用，指向实际的 `<input>` DOM 元素。

### 3.5 useMemo

用于性能优化，缓存计算结果

```tsx
import React, { useMemo, useState } from "react";

function ExpensiveComputation({ a, b }) {
  const result = useMemo(() => {
    // 假设这是一个耗时的计算
    return a * b * 1000000000;
  }, [a, b]); // 只有当 a 或 b 改变时才重新计算

  return <div>结果: {result}</div>;
}
```

### 3.6 useCallback

用于性能优化，缓存函数

```tsx
import React, { useCallback, useState } from "react";

function ParentComponent() {
  const [count, setCount] = useState(0);

  const increment = useCallback(() => {
    setCount((c) => c + 1);
  }, []); // 空数组意味着这个函数永远不会改变

  return (
    <div>
      <ChildComponent onIncrement={increment} />
      <p>计数: {count}</p>
    </div>
  );
}
```

### 3.7 自定义 Hook

自定义 Hook 是一个函数，它以"use"开头，并可以调用其他的 Hook。自定义 Hook 可以用于在组件之间共享逻辑。

使用自定义 Hook 的一些注意事项：

1. 自定义 Hook 可以使用其他 Hook，如 useState、useEffect 等。
2. 自定义 Hook 应该始终以"use"开头，这是一个约定，也便于 React 的 lint 规则识别。
3. 自定义 Hook 可以接受参数并返回任何你需要的值。
4. 多个组件使用同一个自定义 Hook 时，每个组件都会获得其独立的状态。
   自定义 Hook 是一种共享逻辑的方式，不是共享状态的方式。

创建自定义 Hook：

自定义 Hook 是一个以"use"开头的 JavaScript 函数。例如：

```tsx
import { useState, useEffect } from "react";

function useCustomHook(initialValue) {
  const [value, setValue] = useState(initialValue);

  useEffect(() => {
    // 一些副作用逻辑
  }, [value]);

  const updateValue = (newValue) => {
    setValue(newValue);
  };

  return [value, updateValue];
}

export default useCustomHook;
```

在组件中使用自定义 Hook：

```tsx
import React from "react";
import useCustomHook from "../hooks/useCustomHook";

function MyComponent() {
  const [value, updateValue] = useCustomHook("初始值");

  return (
    <div>
      <p>当前值: {value}</p>
      <button onClick={() => updateValue("新值")}>更新值</button>
    </div>
  );
}

export default MyComponent;
```

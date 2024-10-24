---
title: 💻 React
date: 2024-03-03T11:18:19+08:00
width: full
weight: 1
---

## Context

在 `React` 中，`Context` 是用于共享一些在组件树中被认为是「全局」的数据，比如当前的用户信息、主题或首选语言。

### 创建 Context

```tsx
import React, { createContext } from "react";

const MyContext = createContext<string>("defaultValue");
```

> defaultValue 是在没有匹配到 **Provider** 时的默认值。

### 创建 Provider

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

### 使用 Consumer 或 useContext Hook

有两种方法来使用 Context 的值：`Consumer` 组件和 `useContext` Hook。

#### Consumer 组件

使用 `MyContext.Consumer` 来访问 Context 的值。

```tsx
<MyContext.Consumer>
  {(value) => <div>{/* 根据value渲染UI */}</div>}
</MyContext.Consumer>
```

#### useContext Hook

在函数组件中，可以使用 `useContext` 来更简便地访问值。

```tsx
import React, { useContext } from "react";

const MyComponent = () => {
  const value = useContext(MyContext);

  return <div>{/* 根据value渲染UI */}</div>;
};
```

## State

{{< shell-card command="npm" args="install zustand@latest" >}}


## Hook
Hook是React 16.8引入的新特性，允许你在不编写class的情况下使用state以及其他的React特性。

在React中，所有的自定义Hook函数名都应该以"use"开头。这是一个约定，让React知道这个函数是一个Hook。

### useState 
用于在函数组件中添加状态

```tsx
import React, { useState } from 'react';

function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>你点击了 {count} 次</p>
      <button onClick={() => setCount(count + 1)}>
        点击我
      </button>
    </div>
  );
}
```

### useEffect
用于处理副作用，如数据获取、订阅或手动更改 DOM
```tsx
import React, { useState, useEffect } from 'react';

function DataFetcher() {
  const [data, setData] = useState(null);

  useEffect(() => {
    fetch('https://api.example.com/data')
      .then(response => response.json())
      .then(data => setData(data));
  }, []); // 空数组表示只在组件挂载时运行

  return (
    <div>
      {data ? <p>数据: {JSON.stringify(data)}</p> : <p>加载中...</p>}
    </div>
  );
}
```

### useContext
用于访问 React 的 Context

```tsx
import React, { useContext } from 'react';

const ThemeContext = React.createContext('light');

function ThemedButton() {
  const theme = useContext(ThemeContext);
  return <button style={{ background: theme }}>我是主题按钮</button>;
}
```

### useRef
用于创建一个可变的 ref 对象

```tsx
import React, { useRef, useEffect } from 'react';

function FocusInput() {
  const inputRef = useRef(null);

  useEffect(() => {
    inputRef.current.focus();
  }, []);

  return <input ref={inputRef} />;
}
```

### useMemo
用于性能优化，缓存计算结果
```tsx
import React, { useMemo, useState } from 'react';

function ExpensiveComputation({ a, b }) {
  const result = useMemo(() => {
    // 假设这是一个耗时的计算
    return a * b * 1000000000;
  }, [a, b]); // 只有当 a 或 b 改变时才重新计算

  return <div>结果: {result}</div>;
}
```

### useCallback
用于性能优化，缓存函数
```tsx
import React, { useCallback, useState } from 'react';

function ParentComponent() {
  const [count, setCount] = useState(0);

  const increment = useCallback(() => {
    setCount(c => c + 1);
  }, []); // 空数组意味着这个函数永远不会改变

  return (
    <div>
      <ChildComponent onIncrement={increment} />
      <p>计数: {count}</p>
    </div>
  );
}
```

### 自定义Hook
自定义Hook是一个函数，它以"use"开头，并可以调用其他的Hook。自定义Hook可以用于在组件之间共享逻辑。

使用自定义Hook的一些注意事项：
1. 自定义Hook可以使用其他Hook，如useState、useEffect等。
2. 自定义Hook应该始终以"use"开头，这是一个约定，也便于React的lint规则识别。
3. 自定义Hook可以接受参数并返回任何你需要的值。
4. 多个组件使用同一个自定义Hook时，每个组件都会获得其独立的状态。
自定义Hook是一种共享逻辑的方式，不是共享状态的方式。

创建自定义Hook：
自定义Hook是一个以"use"开头的JavaScript函数。例如：
```tsx
import { useState, useEffect } from 'react';

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

在组件中使用自定义Hook：
```tsx
import React from 'react';
import useCustomHook from '../hooks/useCustomHook';

function MyComponent() {
  const [value, updateValue] = useCustomHook('初始值');

  return (
    <div>
      <p>当前值: {value}</p>
      <button onClick={() => updateValue('新值')}>更新值</button>
    </div>
  );
}

export default MyComponent;
```
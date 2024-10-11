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

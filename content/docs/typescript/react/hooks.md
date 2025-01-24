---
title: Hooks
date: 2024-11-12T23:39:25+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

{{< cards >}}
{{< card link="https://github.com/TanStack/query" title="Query" subtitle="Powerful asynchronous state management, server-state utilities and data fetching for the web. TS/JS, React Query, Solid Query, Svelte Query and Vue Query." icon="js" >}}
{{< card link="https://github.com/vercel/swr" title="SWR" subtitle="React Hooks for Data Fetching" icon="js" >}}
{{< /cards >}}

## 1. useState
管理组件内部状态。
```jsx
const [count, setCount] = useState(0);
```

## 2. useEffect
处理副作用（如数据获取、DOM 操作）。
```jsx
useEffect(() => {
    // 副作用逻辑（组件挂载/更新时执行）
    return () => {
        // 清理逻辑（组件卸载/下次effect执行前执行）
    };
}, [dependencies]); // 依赖数组
```

### 1.1 组件挂载初始化
```javascript
useEffect(() => {
  fetchData().then(data => setData(data));
}, []); // 空数组表示只运行一次
```

### 1.2 监听状态变化
```javascript
useEffect(() => {
  document.title = `Count: ${count}`;
}, [count]); // count变化时触发
```

### 1.3 清理资源
```javascript
useEffect(() => {
  const timer = setInterval(() => {}, 1000);
  return () => clearInterval(timer); // 清理定时器
}, []);
```

### 1.4 注意事项
依赖数组的三种状态：

+ 空数组 []：仅在挂载和卸载时运行
+ 有依赖 [a, b]：当 a 或 b 变化时运行
+ 无依赖：每次渲染都运行

## 3. useContext
主要作用是跨组件层级传递数据，避免 prop drilling。
```javascript
const value = useContext(MyContext);
```

> + 上下文变化会触发所有消费者组件重新渲染
> + 复杂场景建议结合 useReducer

### 3.1 主题切换
```jsx
// 创建上下文
const ThemeContext = createContext('light');

// 父组件提供值
<ThemeContext.Provider value="dark">
  <ChildComponent />
</ThemeContext.Provider>

// 子组件消费值
function Child() {
  const theme = useContext(ThemeContext);
  return <div className={theme}>当前主题: {theme}</div>;
}
```

### 3.2 全局状态管理
```jsx
// 用户上下文
const UserContext = createContext(null);

// 注入用户数据
<UserContext.Provider value={{ name: "Alice" }}>
  <App />
</UserContext.Provider>

// 任意子组件获取用户
const user = useContext(UserContext);
```

## 4. useReducer

## 5. useCallback

cache a function between renders.

### 5.1 General Usage

```jsx
const memoizedCallback = useCallback(
  () => {
    // function body
  },
  [dependencies] // dependency array
);
```

{{< callout type="info" >}}
Only re-create the function if one of the dependencies has changed.
If no dependencies are provided, the function is created only once during the initial render, and will never be recreated.
{{< /callout >}}

### 5.2 Example

假设有一个父组件，包含一个按钮点击事件和一个子组件，子组件会接收一个 `onClick` 函数作为 `props`。

```jsx
import React, { useState, useCallback } from "react";

// Child component
const Child = React.memo(({ onClick }) => {
  console.log("Child re-rendered");
  return <button onClick={onClick}>Click Me</button>;
});

const Parent = () => {
  const [count, setCount] = useState(0);

  const handleClick = useCallback(() => {
    setCount((prevCount) => prevCount + 1);
  }, []); // dependency array is empty, the function is created only once during the initial render

  return (
    <div>
      <p>Count: {count}</p>
      <Child onClick={handleClick} />
    </div>
  );
};

export default Parent;
```

## 6. useMemo
核心作用是缓存计算结果，避免重复计算。
cache the result of a calculation between renders.

### 6.1 复杂计算优化
```jsx
const heavyResult = useMemo(() => {
  return data.filter(item => item.active)
            .sort((a, b) => a.id - b.id);
}, [data]); // data变化时重新计算
```

### 6.2 避免子组件不必要渲染
```jsx
const config = useMemo(() => ({
  color: 'red',
  size: 12
}), []); // 空依赖表示只计算一次

return <Child config={config} />;
```

## 7. useRef

## 8. useLayoutEffect

synchronize a component with some external system, _before_ the browser paints the screen.

## 9. useAnything

part of what makes hooks so composable is you can create your own hooks which leverage React hooks or other custom hooks.

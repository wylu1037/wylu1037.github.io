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

## 2. useEffect

## 3. useContext

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

cache the result of a calculation between renders.

## 7. useRef

## 8. useLayoutEffect

synchronize a component with some external system, _before_ the browser paints the screen.

## 9. useAnything

part of what makes hooks so composable is you can create your own hooks which leverage React hooks or other custom hooks.

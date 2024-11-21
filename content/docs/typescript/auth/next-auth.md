---
title: NextAuth.js
date: 2024-11-21T17:31:15+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

{{< button/docs text="Auth.js Docs" link="https://authjs.dev/getting-started/migrating-to-v5" >}}

## 1. Installation

```shell
npm install next-auth@beta
```

## 2. Authentication


## 3. Configuration


### 3.1 providers.authorize

执行时机：用户登陆时执行。

```typescript
const authorize = (db: DB) => async (
  credentials: Record<"email" | "password", string> | undefined
) => {
  // 验证登录凭证
  const user = await db.user.findUnique({
    where: { email: credentials?.email }
  });
  
  if (!user || !credentials?.password) return null;
  
  const isValid = await bcrypt.compare(credentials.password, user.password);
  return isValid ? user : null;
}
```

### 3.2 callbacks.authorized

+ **执行时机**：用户已登录后，访问受保护路由时执行。

+ **使用场景**：
  - 验证用户角色权限
  - 检查用户订阅状态
  - 实现基于路由的访问控制

> 如何配置受保护路由？


{{< callout type="info" >}}

使用中间件，在项目的根目录下创建 middleware.ts 文件，并添加以下代码：

{{< /callout >}}

```typescript
callbacks: {
  authorized: async ({ auth, request }) => {
    // 检查用户是否有权访问特定路由
    const path = request.nextUrl?.pathname;
    if (path?.startsWith('/admin')) {
      return auth?.user?.role === 'ADMIN';
    }
    return !!auth;
  }
}
```

## 4. Database

### Models

#### User

#### Account
The Account model is for information about accounts associated with a `User`. A single `User` can have multiple `Account(s)`, but each `Account` can only have one `User`.
> For Example: use different OAuth providers to login, the account will be different.

#### Session

The Session model is used for database sessions and it can store arbitrary data for an active user session. A single `User` can have multiple `Session(s)`, each `Session` can only have one `User`.
> For Example: use different devices(app, web, etc.) to login, the session will be different.


#### VerificationToken
The VerificationToken model is used to store tokens for email-based **magic-link** sign in.


## 5. Session Management

### Session Strategies
Auth.js supports 2 main session strategies, the JWT-based session and Database session.
```
optional strategy: "jwt" | "database";
```

### 5.3 Protecting Resources

#### Pages

Protecting routes can be done generally by checking for the session and taking an action if an active session is not found, like redirecting the user to the login page or simply returning a 401: Unauthenticated response.

{{< tabs items="Next.js,Next.js(Client)" >}}
{{< tab >}}
You can use the `auth` function returned from `NextAuth()` and exported from your `auth.ts` or `auth.js` configuration file to get the session object.

```tsx {filename="app/server/page.tsx", hl_lines=[4]}
import { auth } from "@/auth"
 
export default async function Page() {
  const session = await auth()
  if (!session) return <div>Not authenticated</div>
 
  return (
    <div>
      <pre>{JSON.stringify(session, null, 2)}</pre>
    </div>
  )
}
```
{{< /tab >}}
{{< tab >}}
{{< /tab >}}
{{< /tabs >}}

#### API Routes
{{< tabs items="Next.js,Next.js(Client)" >}}
{{< tab >}}
```tsx {filename="app/api/admin/route.ts", hl_lines=[4]}
import { auth } from "@/auth"
import { NextResponse } from "next/server"
 
export const GET = auth(function GET(req) {
  if (req.auth) return NextResponse.json(req.auth)
  return NextResponse.json({ message: "Not authenticated" }, { status: 401 })
})
```
{{< /tab >}}
{{< tab >}}
{{< /tab >}}
{{< /tabs >}}

#### Next.js Middleware
With Next.js 12+, the easiest way to protect a set of pages is using the middleware file. You can create a `middleware.ts` file in your root pages directory with the following contents.

```typescript {filename="middleware.ts", hl_lines=[1]}
export { auth as middleware } from "@/auth"

```

Then define `authorized` callback in your `auth.ts` file. For more details check out the [reference docs](https://authjs.dev/reference/nextjs#authorized).

```typescript {filename="auth.ts"}
import NextAuth from "next-auth"
 
export const { auth, handlers } = NextAuth({
  callbacks: {
    authorized: async ({ auth }) => {
      // Logged in users are authenticated, otherwise redirect to login page
      return !!auth
    },
  },
})
```

You can also use the `auth` method as a wrapper if you’d like to implement more logic inside the middleware.

```typescript {filename="middleware.ts"}
import { auth } from "@/auth"
 
export default auth((req) => {
  if (!req.auth && req.nextUrl.pathname !== "/login") {
    const newUrl = new URL("/login", req.nextUrl.origin)
    return Response.redirect(newUrl)
  }
})
```

You can also use a regex to match multiple routes or you can negate certain routes in order to protect all remaining routes. The following example avoids running the middleware on paths such as the favicon or static images.

```typescript {filename="middleware.ts"}
export const config = {
  matcher: ["/((?!api|_next/static|_next/image|favicon.ico).*)"],
}
```

Middleware will protect pages as defined by the `matcher` config export. For more details about the matcher, check out the [Next.js docs](https://nextjs.org/docs/pages/building-your-application/routing/middleware#matching-paths).

## 6. Providers

### 6.1 GitHub,

### 6.2 Google

## 7. Adapters
### 7.1 Prisma

### 7.2 Drizzle



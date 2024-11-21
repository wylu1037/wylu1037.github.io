---
title: NextAuth.js
date: 2024-11-21T17:31:15+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## 1. Installation

```shell
npm install next-auth@beta
```

## 2. Authentication


## 3. Configuration

```typescript {filename="auth.ts", hl_lines=[8,39,40,41,42]}
export const authConfig = {
  providers: [
    CredentialsProvider({
      credentials: {
        email: { type: "email" },
        password: { type: "password" },
      },
      authorize: authorize(db),
    }),
    /**
     * ...add more providers here.
     *
     * Most other providers require a bit more work than the Discord provider. For example, the
     * GitHub provider requires you to add the `refresh_token_expires_in` field to the Account
     * model. Refer to the NextAuth.js docs for the provider you want to use. Example:
     *
     * @see https://next-auth.js.org/providers/github
     */
  ],
  adapter: PrismaAdapter(db),
  session: {
    strategy: "jwt",
  },
  callbacks: {
    jwt({ token, user }) {
      if (user && "role" in user) token.role = user.role;
      return token;
    },
    session({ session, token }) {
      return {
        ...session,
        user: {
          ...session.user,
          id: token.sub!,
          role: token.role,
        },
      };
    },
    authorized: async ({ auth }) => {
      // Logged in users are authorized, otherwise redirect to login page
      return !!auth;
    },
  },
} satisfies NextAuthConfig;
```

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
```typescript {filename="middleware.ts"}
//export { auth as middleware } from "@/server/auth";

import { NextRequest, NextResponse } from "next/server";
import { getToken } from "next-auth/jwt";

export async function middleware(request: NextRequest) {
  console.log("middleware", request);

  const token = await getToken({ req: request });
  if (!token) {
    return NextResponse.redirect(new URL("/signin", request.url));
  }
  return NextResponse.next();
}

export const config = {
  matcher: [
    "/app/dashboard/:path*",
    "/api/dashboard/:path*",
    "/api/trpc/:path*",
  ],
};
```

```typescript
import { withAuth } from "next-auth/middleware";

export default withAuth({
  // 自定义配置
  callbacks: {
    authorized: ({ token }) => {
      return !!token; // 只允许登录用户访问
    },
  },
});

// 配置需要保护的路由
export const config = {
  matcher: [
    "/dashboard/:path*",
    "/admin/:path*",
    // 排除特定路径
    "/((?!api|_next/static|_next/image|favicon.ico).*)",
  ],
};
```

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


## 5. Session


## 6. Providers


## 7. Adapters

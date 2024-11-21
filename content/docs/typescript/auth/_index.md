---
title: Auth
date: 2024-11-18T10:16:45+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

## middleware
+ API 路由保护
+ 请求/响应修改
+ 复杂的路由规则
+ 通用的请求处理

在项目的根目录下面创建 `middleware.ts` 文件，并添加以下内容：

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

## auth/config.ts
- 简单的页面访问控制
- 与 NextAuth 紧密相关的权限
- 基于角色的访问控制
    
### 简单的登陆验证

```typescript {filename="auth/config.ts", hl_lines=[39,40,41,42]}
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

### 基于角色的权限控制
```typescript
authorized: async ({ auth }) => {
  // 检查用户角色
  return auth?.user?.role === "ADMIN";
}
```

### 复杂的权限逻辑
```typescript
authorized: async ({ auth, request }) => {
  if (!auth) return false;

  // 获取当前路径
  const pathname = request.nextUrl?.pathname;
  
  // 不同路径的权限控制
  if (pathname?.startsWith('/admin')) {
    return auth.user.role === 'ADMIN';
  }
  
  if (pathname?.startsWith('/dashboard')) {
    return ['ADMIN', 'USER'].includes(auth.user.role);
  }
  
  return true;
}
```
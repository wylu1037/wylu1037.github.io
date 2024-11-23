---
title: Create T3 App
date: 2024-11-23T10:56:09+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

{{< button/docs text="Create T3 App Docs" link="https://create.t3.gg/en/introduction" >}}

## 1.Quick Start
```bash
bun create t3-app@latest my-app
```

### 1.1 Project Structure
```
.
├─ public
│  └─ favicon.ico
├─ src
│  ├─ app
│  │  ├─ _components
│  │  │  └─ post.tsx
│  │  ├─ api
│  │  │  ├─ auth
│  │  │  │  └─ [...nextauth]
│  │  │  │     └─ route.ts
│  │  │  └─ trpc
│  │  │     └─ [trpc]
│  │  │        └─ route.ts
│  │  ├─ layout.tsx
│  │  └─ page.tsx
│  ├─ server
│  │  ├─ auth.ts
│  │  ├─ db
│  │  │  ├─ index.ts
│  │  │  └─ schema.ts
│  │  └─ api
│  │     ├─ routers
│  │     │  └─ example.ts
│  │     ├─ trpc.ts
│  │     └─ root.ts
│  ├─ styles
│  │  └─ globals.css
│  ├─ env.js
│  └─ trpc
│     ├─ query-client.ts
│     ├─ react.tsx
│     └─ server.ts
├─ .env
├─ .env.example
├─ .eslintrc.cjs
├─ .gitignore
├─ db.sqlite (after `db:push`, sqlite only)
├─ drizzle.config.ts
├─ next-env.d.ts
├─ next.config.js
├─ package.json
├─ postcss.config.js
├─ prettier.config.js
├─ README.md
├─ start-database.sh (mysql or postgres only)
├─ tailwind.config.ts
└─ tsconfig.json

```

### 1.2 Tech Stack

{{< components/stack items="Next.js,NextAuth.js,ZenStack,PostgreSQL,Prisma,TailwindCSS,Shadcn,tRPC" >}}

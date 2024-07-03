---
title: Rails 入门
date: 2024-02-20T12:54:59+08:00
draft: false
---

{{< cards >}}
    {{< card link="https://guides.rubyonrails.org/" title="Getting Started" subtitle="Ruby on Rails Guides (v7.1.3)" icon="arrow-circle-right" >}}
{{< /cards >}}

## 1.项目结构

## 2.Controller
### 2.1 Action
+ `index`：用于显示资源的列表。
+ `show`：用于显示单个资源的详细信息。
+ `new`：用于显示创建新资源的表单。
+ `create`：用于处理新资源的创建。
+ `edit`：用于显示编辑现有资源的表单。
+ `update`：用于处理现有资源的更新。
+ `destroy`：用于处理现有资源的删除。

`:new` 表示视图模版的名称

### 2.2 处理请求响应
#### redirect_to
`redirect_to` 方法用于重定向用户的请求到另一个 **_URL_**。这通常在执行某个操作（如创建或更新资源）后使用，通知浏览器进行新的请求。

1.重定向到指定的路径：
```ruby
redirect_to '/articles'
```

2.重定向到命名路由：
```ruby
redirect_to articles_path
```

3.重定向到特定资源：
```ruby
@article = Article.find(params[:id])
redirect_to @article
```

4.传递闪现消息：
```ruby
redirect_to @article, notice: 'Article was successfully created.'
```

#### render
`render` 方法用于渲染视图模板或返回特定的内容。这通常在操作未成功时使用，或者需要显示特定视图而不进行重定向。

1.渲染特定视图模板：
```ruby
render :edit
```

2.渲染带有格式的内容：
```ruby
render json: @article
```

3.渲染带有状态码的内容：
```ruby
render :new, status: :unprocessable_entity
```

4.渲染局部视图：
```ruby
render partial: 'form'
```

## 3.Model

## 4.View
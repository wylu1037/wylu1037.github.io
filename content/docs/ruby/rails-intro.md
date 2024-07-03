---
title: Rails 入门
date: 2024-02-20T12:54:59+08:00
draft: false
---

{{< cards >}}
    {{< card link="https://guides.rubyonrails.org/" title="Getting Started" subtitle="Ruby on Rails Guides (v7.1.3)" icon="arrow-circle-right" >}}
{{< /cards >}}

## 1.项目结构
{{< filetree/container >}}

{{< filetree/folder name=".ruby-lsp" state="closed" >}}
{{< filetree/file name=".gitignore" >}}
{{< filetree/file name="Gemfile" >}}
{{< filetree/file name="Gemfile.lock" >}}
{{< filetree/file name="last_updated" >}}
{{< filetree/file name="main_lockfile_hash" >}}
{{< /filetree/folder >}}

{{< filetree/folder name="app" state="closed" >}}
    {{< filetree/folder name="assets" >}}
    {{< /filetree/folder >}}
    {{< filetree/folder name="channels" >}}
    {{< /filetree/folder >}}
    {{< filetree/folder name="controllers" >}}
    {{< /filetree/folder >}}
    {{< filetree/folder name="helpers" >}}
    {{< /filetree/folder >}}
    {{< filetree/folder name="javascript" >}}
    {{< /filetree/folder >}}
    {{< filetree/folder name="jobs" >}}
    {{< /filetree/folder >}}
    {{< filetree/folder name="mailers" >}}
    {{< /filetree/folder >}}
    {{< filetree/folder name="models" >}}
    {{< /filetree/folder >}}
    {{< filetree/folder name="views" >}}
    {{< /filetree/folder >}}
{{< /filetree/folder >}}

{{< filetree/folder name="bin" state="closed" >}}
    {{< filetree/file name="bundle" >}}
    {{< filetree/file name="dev" >}}
    {{< filetree/file name="docker-entrypoint" >}}
    {{< filetree/file name="importmap" >}}
    {{< filetree/file name="rails" >}}
    {{< filetree/file name="rake" >}}
    {{< filetree/file name="setup" >}}
{{< /filetree/folder >}}

{{< filetree/folder name="config" >}}
{{< /filetree/folder >}}

{{< filetree/folder name="db" >}}
{{< /filetree/folder >}}

{{< filetree/folder name="lib" >}}
{{< /filetree/folder >}}

{{< filetree/folder name="log" >}}
{{< /filetree/folder >}}

{{< filetree/folder name="public" >}}
{{< /filetree/folder >}}

{{< filetree/folder name="storage" >}}
{{< /filetree/folder >}}

{{< filetree/folder name="test" >}}
{{< /filetree/folder >}}

{{< filetree/folder name="tmp" >}}
{{< /filetree/folder >}}

{{< filetree/folder name="vendor" >}}
{{< /filetree/folder >}}

{{< filetree/file name=".dockerignore" >}}
{{< filetree/file name=".gitattributes" >}}
{{< filetree/file name=".gitignore" >}}
{{< filetree/file name=".ruby-version" >}}
{{< filetree/file name="config.ru" >}}
{{< filetree/file name="Dockerfile" >}}
{{< filetree/file name="Gemfile" >}}
{{< filetree/file name="Gemfile.lock" >}}
{{< filetree/file name="Procfile.dev" >}}
{{< filetree/file name="Rakefile" >}}
{{< filetree/file name="README.md" >}}

{{< /filetree/container >}}

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
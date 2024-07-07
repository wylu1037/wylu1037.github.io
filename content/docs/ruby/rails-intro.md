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

## 5.命令
### 创建新项目
```shell
rails new myapp
```

```shell
Usage:
  rails new APP_PATH [options]

Options:
                 [--skip-namespace], [--no-skip-namespace]              # Skip namespace (affects only isolated engines)
                                                                        # Default: false
                 [--skip-collision-check], [--no-skip-collision-check]  # Skip collision check
                                                                        # Default: false
  -r,            [--ruby=PATH]                                          # Path to the Ruby binary of your choice
                                                                        # Default: /Users/wenyanglu/.rbenv/versions/3.3.0/bin/ruby
  -n,            [--name=NAME]                                          # Name of the app
  -m,            [--template=TEMPLATE]                                  # Path to some application template (can be a filesystem path or URL)
  -d,            [--database=DATABASE]                                  # Preconfigure for selected database (options: mysql/trilogy/postgresql/sqlite3/oracle/sqlserver/jdbcmysql/jdbcsqlite3/jdbcpostgresql/jdbc)
                                                                        # Default: sqlite3
  -G,            [--skip-git], [--no-skip-git]                          # Skip git init, .gitignore and .gitattributes
                 [--skip-docker], [--no-skip-docker]                    # Skip Dockerfile, .dockerignore and bin/docker-entrypoint
                 [--skip-keeps], [--no-skip-keeps]                      # Skip source control .keep files
  -M,            [--skip-action-mailer], [--no-skip-action-mailer]      # Skip Action Mailer files
                 [--skip-action-mailbox], [--no-skip-action-mailbox]    # Skip Action Mailbox gem
                 [--skip-action-text], [--no-skip-action-text]          # Skip Action Text gem
  -O,            [--skip-active-record], [--no-skip-active-record]      # Skip Active Record files
                 [--skip-active-job], [--no-skip-active-job]            # Skip Active Job
                 [--skip-active-storage], [--no-skip-active-storage]    # Skip Active Storage files
  -C,            [--skip-action-cable], [--no-skip-action-cable]        # Skip Action Cable files
  -A,            [--skip-asset-pipeline], [--no-skip-asset-pipeline]    # Indicates when to generate skip asset pipeline
  -a,            [--asset-pipeline=ASSET_PIPELINE]                      # Choose your asset pipeline [options: sprockets (default), propshaft]
                                                                        # Default: sprockets
  -J, --skip-js, [--skip-javascript], [--no-skip-javascript]            # Skip JavaScript files
                 [--skip-hotwire], [--no-skip-hotwire]                  # Skip Hotwire integration
                 [--skip-jbuilder], [--no-skip-jbuilder]                # Skip jbuilder gem
  -T,            [--skip-test], [--no-skip-test]                        # Skip test files
                 [--skip-system-test], [--no-skip-system-test]          # Skip system test files
                 [--skip-bootsnap], [--no-skip-bootsnap]                # Skip bootsnap gem
                 [--skip-dev-gems], [--no-skip-dev-gems]                # Skip development gems (e.g., web-console)
                 [--dev], [--no-dev]                                    # Set up the application with Gemfile pointing to your Rails checkout
                 [--edge], [--no-edge]                                  # Set up the application with a Gemfile pointing to the 7-1-stable branch on the Rails repository
  --master,      [--main], [--no-main]                                  # Set up the application with Gemfile pointing to Rails repository main branch
                 [--rc=RC]                                              # Path to file containing extra configuration options for rails command
                 [--no-rc]                                              # Skip loading of extra configuration options from .railsrc file
                 [--api], [--no-api]                                    # Preconfigure smaller stack for API only apps
                                                                        # Default: false
                 [--minimal], [--no-minimal]                            # Preconfigure a minimal rails app
  -j, --js,      [--javascript=JAVASCRIPT]                              # Choose JavaScript approach [options: importmap (default), bun, webpack, esbuild, rollup]
                                                                        # Default: importmap
  -c,            [--css=CSS]                                            # Choose CSS processor [options: tailwind, bootstrap, bulma, postcss, sass] check https://github.com/rails/cssbundling-rails for more options
  -B,            [--skip-bundle], [--no-skip-bundle]                    # Don't run bundle install
                 [--skip-decrypted-diffs], [--no-skip-decrypted-diffs]  # Don't configure git to show decrypted diffs of encrypted credentials

Runtime options:
  -f, [--force]                    # Overwrite files that already exist
  -p, [--pretend], [--no-pretend]  # Run but do not make any changes
  -q, [--quiet], [--no-quiet]      # Suppress status output
  -s, [--skip], [--no-skip]        # Skip files that already exist

Rails options:
  -h, [--help], [--no-help]        # Show this help message and quit
  -v, [--version], [--no-version]  # Show Rails version number and quit

Description:
    The `rails new` command creates a new Rails application with a default
    directory structure and configuration at the path you specify.

    You can specify extra command-line arguments to be used every time
    `rails new` runs in the .railsrc configuration file in your home directory,
    or in $XDG_CONFIG_HOME/rails/railsrc if XDG_CONFIG_HOME is set.

    Note that the arguments specified in the .railsrc file don't affect the
    default values shown above in this help message.

    You can specify which version to use when creating a new rails application 
    using `rails _<version>_ new`.

Examples:
    `rails new ~/Code/Ruby/weblog`

    This generates a new Rails app in ~/Code/Ruby/weblog.

    `rails _<version>_ new weblog`

    This generates a new Rails app with the provided version in ./weblog.

    `rails new weblog --api`

    This generates a new Rails app in API mode in ./weblog.

    `rails new weblog --skip-action-mailer`

    This generates a new Rails app without Action Mailer in ./weblog.
    Any part of Rails can be skipped during app generation.

```

### 启动服务器
```shell
rails server
```
Or 
```shell
rails s
```

### 数据库操作
rails db:create：创建数据库。
+ `rails db:drop`：删除数据库。
+ `rails db:migrate`：运行数据库迁移。
+ `rails db:rollback`：回滚上一个迁移。
+ `rails db:seed`：加载种子数据。
+ `rails db:schema:load`：加载数据库架构。

### 生成器
+ `rails generate` 或 `rails g`：使用生成器生成代码（如控制器、模型、迁移等）。

常见生成器示例：

+ `rails generate model User name:string email:string`：生成一个 User 模型以及相应的迁移文件。
+ `rails generate controller Welcome index`：生成一个 Welcome 控制器和一个 index 动作。
+ `rails generate migration AddAgeToUsers age:integer`：生成一个迁移文件，用于向 users 表添加 age 列。

### 控制台
+ `rails console` 或 `rails c` 启动 Rails 控制台，可以在其中与应用程序的上下文进行交互。

### 测试
+ `rails test`：运行测试（适用于 MiniTest）。
+ `rails spec`：运行测试（适用于 RSpec，如果你使用了该库）。

### 任务管理
+ `rails runner 'SomeModel.some_method'`：运行任意的 Rails 代码。

### 清理
+ `rails db:schema:dump`：将当前数据库架构转储到 db/schema.rb 文件中。
+ `rails db:test:prepare`：为测试环境准备数据库。

### 其他命令
+ `rails routes`：列出所有的路由。
+ `rails dbconsole`：启动数据库控制台（如 psql、sqlite3、mysql）。
+ `rails about`：显示应用程序的环境信息。
+ `rails stats`：显示代码统计信息。


## Rails stack

### Puma
默认的 web 服务器，支持多线程和多进程，适合高并发环境。

### Turbo
Hotwire 的一部分，提供快速、无刷新页面更新功能。

### Sidekiq
后台任务处理工具，用于处理异步任务和队列。

### Importmap
Rails 7 引入的工具，用于管理 JavaScript 依赖，不需要 Webpack 等打包工具。

### Stimulus
Hotwire 的另一部分，轻量级 JavaScript 框架，用于增强 HTML 的交互性。


### Devise
用户认证解决方案，提供注册、登录、密码恢复等功能。

### Pundit
授权解决方案，管理用户权限和访问控制。
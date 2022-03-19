---
title: Aurora主题博客搭建
date: 2022-03-19 11:56:19
tags:
	- hexo
	- aurora
categories:
	- 博客
cover: http://puui.qpic.cn/vcover_hz_pic/0/mzc00200gw2ez0b1627357509889/0
feature: true
---

## 1.准备环境

### 1.1 建站

:::tip

基于Hexo搭建主题为Aurora的博客，依赖环境如下：
+ Hexo 5.4+
+ Yarn or NPM installed

:::

安装 Hexo 完成后，请执行下列命令，Hexo 将会在指定文件夹中新建所需要的文件。 

```bash
$ hexo init <folder>
$ cd <folder>
$ npm install
```

新建完成后，指定文件夹的目录如下：

```
.
├── _config.yml
├── package.json
├── scaffolds
├── source
|   ├── _drafts
|   └── _posts
└── themes
```

### 1.2 配置

可以在 `_config.yml` 中修改大部分的配置。 

#### 1.2.1 网站

| 参数          | 描述                                                         |
| :------------ | :----------------------------------------------------------- |
| `title`       | 网站标题                                                     |
| `subtitle`    | 网站副标题                                                   |
| `description` | 网站描述                                                     |
| `keywords`    | 网站的关键词。支持多个关键词。                               |
| `author`      | 您的名字                                                     |
| `language`    | 网站使用的语言。对于简体中文用户来说，使用不同的主题可能需要设置成不同的值，请参考你的主题的文档自行设置，常见的有 `zh-Hans`和 `zh-CN`。 |
| `timezone`    | 网站时区。Hexo 默认使用您电脑的时区。请参考 [时区列表](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) 进行设置，如 `America/New_York`, `Japan`, 和 `UTC` 。一般的，对于中国大陆地区可以使用 `Asia/Shanghai`。 |

其中，`description`主要用于SEO，告诉搜索引擎一个关于您站点的简单描述，通常建议在其中包含您网站的关键词。`author`参数用于主题显示文章的作者。



#### 1.2.2 网址

| 参数                         | 描述                                                         | 默认值                      |
| :--------------------------- | :----------------------------------------------------------- | :-------------------------- |
| `url`                        | 网址, 必须以 `http://` 或 `https://` 开头                    |                             |
| `root`                       | 网站根目录                                                   | `url's pathname`            |
| `permalink`                  | 文章的 [永久链接](https://hexo.io/zh-cn/docs/permalinks) 格式 | `:year/:month/:day/:title/` |
| `permalink_defaults`         | 永久链接中各部分的默认值                                     |                             |
| `pretty_urls`                | 改写 [`permalink`](https://hexo.io/zh-cn/docs/variables) 的值来美化 URL |                             |
| `pretty_urls.trailing_index` | 是否在永久链接中保留尾部的 `index.html`，设置为 `false` 时去除 | `true`                      |
| `pretty_urls.trailing_html`  | 是否在永久链接中保留尾部的 `.html`, 设置为 `false` 时去除 (*对尾部的 `index.html`无效*) | `true`                      |



#### 1.2.3 目录

|                |                                                              |                  |
| :------------- | :----------------------------------------------------------- | :--------------- |
| 参数           | 描述                                                         | 默认值           |
| `source_dir`   | 资源文件夹，这个文件夹用来存放内容。                         | `source`         |
| `public_dir`   | 公共文件夹，这个文件夹用于存放生成的站点文件。               | `public`         |
| `tag_dir`      | 标签文件夹                                                   | `tags`           |
| `archive_dir`  | 归档文件夹                                                   | `archives`       |
| `category_dir` | 分类文件夹                                                   | `categories`     |
| `code_dir`     | Include code 文件夹，`source_dir` 下的子目录                 | `downloads/code` |
| `i18n_dir`     | 国际化（i18n）文件夹                                         | `:lang`          |
| `skip_render`  | 跳过指定文件的渲染。匹配到的文件将会被不做改动地复制到 `public` 目录中。您可使用 [glob 表达式](https://github.com/micromatch/micromatch#extended-globbing)来匹配路径。 |                  |



#### 1.2.4 文章

| 参数                    | 描述                                                         | 默认值    |
| :---------------------- | :----------------------------------------------------------- | :-------- |
| `new_post_name`         | 新文章的文件名称                                             | :title.md |
| `default_layout`        | 预设布局                                                     | post      |
| `auto_spacing`          | 在中文和英文之间加入空格                                     | false     |
| `titlecase`             | 把标题转换为 title case                                      | false     |
| `external_link`         | 在新标签中打开链接                                           | true      |
| `external_link.enable`  | 在新标签中打开链接                                           | `true`    |
| `external_link.field`   | 对整个网站（`site`）生效或仅对文章（`post`）生效             | `site`    |
| `external_link.exclude` | 需要排除的域名。主域名和子域名如 `www` 需分别配置            | `[]`      |
| `filename_case`         | 把文件名称转换为 (1) 小写或 (2) 大写                         | 0         |
| `render_drafts`         | 显示草稿                                                     | false     |
| `post_asset_folder`     | 启动 [Asset 文件夹](https://hexo.io/zh-cn/docs/asset-folders) | false     |
| `relative_link`         | 把链接改为与根目录的相对位址                                 | false     |
| `future`                | 显示未来的文章                                               | true      |
| `highlight`             | 代码块的设置, 请参考 [Highlight.js](https://hexo.io/docs/syntax-highlight#Highlight-js) 进行设置 |           |
| `prismjs`               | 代码块的设置, 请参考 [PrismJS](https://hexo.io/docs/syntax-highlight#PrismJS) 进行设置 |           |



## 2.使用aurora主题

### 2.1 安装主题包

> 在控制台中，进入 Hexo 项目的根目录，然后运行以下命令安装主题

```npm
npm install hexo-theme-aurora --save
```



### 2.2 生成主题配置

> **因为主题是使用 NPM 或者 Yarn 安装的，而不是 clone 到 themes 文件夹的。所以需要自己创建一个配置文件。只需要在 Hexo 博客的根目录下创建一个 `_config.aurora.yml` 配置文件来配置主题。** 

+ 想获取一个默认的主题配置模版，可以执行以下命令
+ 但是这个命令只能在 Linux 或者 MacOS 下执行，如果用的是 Windows 系统，可以自行在 node_modules 中找到对应目录复制过来

```bash
cp -rf ./node_modules/hexo-theme-aurora/_config.yml ./_config.aurora.yml
```



### 2.3 设置permalink

>  **因为使用了 Vue-router，Hexo 默认生成的页面和文章的 permalink 与我们 Vue router 中的 path 是不相符的，那么就会出现无法访问的问题。所以我们需要修改 Hexo 默认配置文件里面的 `permalink` 参数。** 

+  修改 Hexo 根目录下的 `_config.yml` 的 `permalink` 参数为 `/post/:title.html` 

```yaml
# URL
## Set your site url here. For example, if you use GitHub Page, set url as 'https://username.github.io/project'
url: https://tridiamond.tech
permalink: /post/:title.html
permalink_defaults:
pretty_urls:
  trailing_index: true # Set to false to remove trailing 'index.html' from permalinks
  trailing_html: true # Set to false to remove trailing '.html' from permalinks
```

+ 设置代码高亮
  + 把 `highlight` 的启用改为`false`
  + 把 `prismjs` 的启用改为`true`
  + 把 `prismjs` 下的 `preprocess` 改为 `false`

> **最后主题是使用 `Prismjs` 来实现代码高亮显示，但 Hexo 默认是使用 `highlightjs`，因此需要更改 Hexo 配置来使用 `Prismjs`:** 

```yaml
highlight:
  enable: false
  line_number: true
  auto_detect: false
  tab_replace: ''
  wrap: true
  hljs: false
prismjs:
  enable: true
  preprocess: true
  line_number: true
  tab_replace: ''
```



### 2.4 重新生成与本地服务器

```bash
hexo clean & hexo g & hexo server

```

:::warning

改变了任何配置都需要重新生成 Hexo 的静态文件！

:::

当文件都生成完毕之后，就可以通过 [https://localhost:4000在新窗口打开](https://localhost:4000/) 访问博客了。 



## 3.aurora配置

:::tips

链接：https://aurora.tridiamond.tech/zh/guide/configuration.html

:::

## 4.部署到GitLab Pages

:::tips

链接：https://hexo.io/zh-cn/docs/gitlab-pages

:::

+ 新建一个 repository。如果希望站点能通过 `<GitLab 用户名>.gitlab.io` 域名访问，repository 应该直接命名为 `<GitLab 用户名>.gitlab.io`。
+ 将 Hexo 站点文件夹推送到 repository 中。默认情况下 `public` 目录将不会（并且不应该）被推送到 repository 中，建议检查 `.gitignore` 文件中是否包含 `public` 一行，如果没有请加上。
+ 在站点文件夹中新建 `.gitlab-ci.yml` 文件：

```yaml
image: node:12.22.5

cache:
  paths:
    - node_modules/

before_script:
  - npm install hexo-cli -g
  - test -e package.json && npm install
  - hexo generate

pages:
  script:
    - hexo generate
  artifacts:
    paths:
      - public
  only:
    - main
```

+ GitLab CI 应该会自动开始运行，构建成功以后可以在 `https://<GitLab 用户名>.gitlab.io` 查看网站。
+ 如果你需要查看生成的文件，可以在 [job artifact](https://docs.gitlab.com/ee/user/project/pipelines/job_artifacts.html) 中找到。

> 在 GitLab.com 上，GitLab CI 是默认启用的。如果使用的是自托管的 GitLab，可能需要在 `Settings -> CI / CD -> Shared Runners` 启用 GitLab CI。


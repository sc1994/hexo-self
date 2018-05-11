---
title: Hexo基础
date: 2018-04-19 17:53:21
tags: 备忘
---

### 基础
- 依赖
    - node.js
    - git
    - nginx
- 安装
```
npm install -g hexo-cli #全局安装
```
- 初始化
```
hexo init [folder] # 在当前目录下的创建初始化文件
```
- 文件结构
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
- 安装依赖
```
cd [folder]
npm i
```
- _config.yml（网站基本信息配置）[详细](https://hexo.io/zh-cn/docs/configuration.html)

参数 | 描述
---|---
title   |	网站标题
subtitle   |	网站副标题
description   |	网站描述
author   |	您的名字
language   |	网站使用的语言
timezone   |	网站时区。Hexo 默认使用您电脑的时区。时区列表。比如说：America/New_York, Japan, 和 UTC 。
- 新建文章
```
hexo new [layout] <title>
# 创建的文章在 hexo 的初始化目录下的 source/_posts
```
新建一篇文章。如果没有设置 layout 的话，默认使用 _config.yml 中的 default_layout 参数代替。如果标题包含空格的话，请使用引号括起来。
- 构建
```
hexo g
```
    - 或者
```
hexo generate
```
参数 | 描述
---|---
-d, --deploy |	文件生成后立即部署网站
-w, --watch	| 监视文件变动

- 预览
```
hexo server
```
参数 | 描述
---|---
-p, --port |	重设端口 ，默认 4000
-s, --static |	只使用静态文件
-l, --log |	启动日记记录，使用覆盖记录格式
- 发布到静态文件

- 

- [主题](http://theme-next.iissnan.com/)
    - [主题预览](https://github.com/iissnan/hexo-theme-next/blob/master/README.cn.md)
- 参考
    - [官网](https://hexo.io/)
---
title:
date: 2024-02-18T16:23:00+08:00
draft: false
type: docs
---

<!-- 太阳 -->
<div>
    <style>
        .container {
            width: 250px;
            height: 250px;
            padding: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .cloud {
            width: 250px;
        }
        .front {
            padding-top: 45px;
            margin-left: 25px;
            display: inline;
            position: absolute;
            z-index: 11;
            animation: clouds 8s infinite;
            animation-timing-function: ease-in-out;
        }
        .back {
            margin-top: -30px;
            margin-left: 150px;
            z-index: 12;
            animation: clouds 12s infinite;
            animation-timing-function: ease-in-out;
        }
        .right-front {
            width: 45px;
            height: 45px;
            border-radius: 50% 50% 50% 0%;
            background-color: #4c9beb;
            display: inline-block;
            margin-left: -25px;
            z-index: 5;
        }
        .left-front {
            width: 65px;
            height: 65px;
            border-radius: 50% 50% 0% 50%;
            background-color: #4c9beb;
            display: inline-block;
            z-index: 5;
        }
        .right-back {
            width: 50px;
            height: 50px;
            border-radius: 50% 50% 50% 0%;
            background-color: #4c9beb;
            display: inline-block;
            margin-left: -20px;
            z-index: 5;
        }
        .left-back {
            width: 30px;
            height: 30px;
            border-radius: 50% 50% 0% 50%;
            background-color: #4c9beb;
            display: inline-block;
            z-index: 5;
        }
        .sun {
            width: 120px;
            height: 120px;
            background: -webkit-linear-gradient(to right, #fcbb04, #fffc00);
            background: linear-gradient(to right, #fcbb04, #fffc00);
            border-radius: 60px;
            display: inline;
            position: absolute;
        }
        .sunshine {
            animation: sunshines 2s infinite;
        }
        @keyframes sunshines {
        0% {
            transform: scale(1);
            opacity: 0.6;
        }
        100% {
            transform: scale(1.4);
            opacity: 0;
        }
        }
        @keyframes clouds {
        0% {
            transform: translateX(15px);
        }
        50% {
            transform: translateX(0px);
        }
        100% {
            transform: translateX(15px);
        }
        }
    </style>
    <!---->
    <div class="container">
    <div class="cloud front">
        <span class="left-front"></span>
        <span class="right-front"></span>
    </div>
    <span class="sun sunshine"></span>
    <span class="sun"></span>
    <div class="cloud back">
        <span class="left-back"></span>
        <span class="right-back"></span>
    </div>
    </div>
</div>

## Frameworks

{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
  Step by steps guides to deploy your favorite framework on Clever Cloud
{{< /hextra/hero-subtitle >}}

{{< cards >}}
  {{< card link="/guides/python-django-sample" title="Django" subtitle= "Configure your Django application to run on Clever Cloud" icon="django" >}}
  {{< card link="/guides/tutorial-drupal" title="Drupal" subtitle= "Deploy a Drupal-based website on Clever Cloud" icon="drupal" >}}
  {{< card link="/guides/ekg-statsd-haskell-metrics/" title="ekg-statsd" subtitle= "How to configure ekg-statsd package in your Haskell application" icon="haskell" >}}
  {{< card link="/guides/fluentd/" title="Fluentd" subtitle= "How to deploy Fluentd using Docker on Clever Cloud" icon="fluentd" >}}
  {{< card link="/guides/tutorial-laravel" title="Laravel" subtitle= "Deploy a Laravel app on Clever Cloud" icon="laravel" >}}
  {{< card link="/guides/node-statsd-nodejs-metrics" title="node-statsd" subtitle= "Configure node-statsd package on your Node.js application to push custom metrics" icon="node" >}}
  {{< card link="/guides/play-framework-1" title="Play 1 x Scala" subtitle= "Set up your Play 1 + Scala application to run on Clever Cloud" icon="play" >}}
  {{< card link="/guides/play-framework-2" title="Play 2 x Scala" subtitle= "Set up your Play 2 + Scala application to run on Clever Cloud" icon="play" >}}
  {{< card link="/guides/ruby-on-rails" title="Ruby On Rails" subtitle= "How to deploy Ruby on Rails framework" icon="ruby" >}}
  {{< card link="/guides/ruby-rack" title="Ruby Rack" subtitle= "Set up a Ruby Rack application and deploy on Clever Cloud" icon="ruby" >}}
  {{< card link="/guides/tutorial-symfony" title="Symfony" subtitle= "Deploy a Symfony application on Clever Cloud" icon="symfony" >}}
  {{< card link="/guides/tutorial-wordpress" title="WordPress" subtitle= "Deploy WordPress on Clever Cloud" icon="wordpress" >}}
   {{< card link="/guides/moodle" title="Moodle" subtitle="Full Moodle installation and configuration guide" icon="moodle" >}}
  
{{< /cards >}}

## Static Site Generator (SSG)

<br>
<div class="mb-12">
{{< hextra/hero-subtitle >}}
  Use Clever Cloud as a runner to build an efficient static website and host it in minutes!&nbsp;<br class="sm:block hidden" />
{{< /hextra/hero-subtitle >}}
</div>{{< cards >}}
 {{< card link="/guides/astro" title="Astro" subtitle= "Build and deploy a static Astro based website on Clever Cloud" icon="astro" >}}
  {{< card link="/guides/docusaurus" title="Docusaurus" subtitle= "Build and deploy a static Docusaurus based website on Clever Cloud" icon="docusaurus" >}}
  {{< card link="/guides/eleventy" title="Eleventy (11ty)" subtitle= "Build and deploy a static Eleventy (11ty) based website on Clever Cloud" icon="11ty" >}}
 {{< card link="/guides/hexo" title="Hexo" subtitle= "Build and deploy a static Hexo based website on Clever Cloud" icon="hexo" >}}
 {{< card link="/guides/hugo" title="Hugo" subtitle= "Build and deploy a static Hugo based website on Clever Cloud" icon="hugo" >}}
  {{< card link="/guides/lume-deno" title="Lume (Deno)" subtitle= "Build and deploy a static Lume (Deno) based website on Clever Cloud" icon="deno" >}}
  {{< card link="/guides/mkdocs" title="MkDocs" subtitle= "Build and deploy a static MkDocs based website on Clever Cloud" icon="docs" >}}
  {{< card link="/guides/mdbook" title="mdBook" subtitle= "Build and deploy a static mbBook based website on Clever Cloud" icon="mdbook" >}}
  {{< card link="/guides/nuxt" title="Nuxt" subtitle= "Build and deploy a static Nuxt based website on Clever Cloud" icon="nuxt" >}}
{{< /cards >}}

## Starter Tutorials

{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
  Tutorials to learn the basis of app configuration and deployments
{{< /hextra/hero-subtitle >}}

{{< cards >}}
 {{< card link="/guides/node-js-mongo-db" title="Node.js + MongoDB starter" subtitle= "Starter tutorial to deploy a Node.js + MongoDB application on Clever Cloud" icon="node" >}}
 {{< card link="/guides/ruby-rack-app-tutorial" title="Ruby Rack" subtitle= "Write a hello world web application using Rack and deploy it on Clever Cloud" icon="ruby" >}}
{{< /cards >}}

## Level Up your Add-ons

{{< hextra/hero-subtitle style="margin:.3rem 0 2rem 0">}}
  Take your dependencies to the next level
{{< /hextra/hero-subtitle >}}

{{< cards >}}
 {{< card link="/guides/kibana" title="Customize Kibana" subtitle= "Deploy and customize a Kibana server on Clever Cloud" icon="kibana" >}}
 {{< card link="/guides/pgpool" title="Pgpool-II" subtitle= "How to configure and use Pgpool-II for PostgreSQL add-ons" icon="pg" >}}
 {{< card link="/guides/proxysql" title="ProxySQL" subtitle= "Configure and use ProxySQL for MySQL add-ons" icon="mysql" >}}
{{< /cards >}}
---
title: ""
date: 2024-02-18T14:30:52+08:00
toc: false
width: full
---

{{< animation type="main">}}

<font style="font-size:50px;font-weight:bold;line-height:1.2;">使用 Markdown & Hugo<br> 搭建的个人网站<br></font>

<font style="font-size:20px;font-weight:270">Fast, batteries-included Hugo theme<br>
for creating beautiful static websites<br></font>

<div>
    <style>
        .btn-container {
            margin-top: 50px;
            margin-bottom: 50px;
        }
        .btn-container .btn {
            display: inline-block;
            margin: 8px 3px;
        }
        .primary-button {
            width: 150px;
            height: 60px;
            color: #315cfd;
            border: 3px solid #315cfd;
            border-radius: 33px;
            transition: all 0.3s;
            cursor: pointer;
            background: white;
            font-size: 1.2em;
            font-weight: 550;
            font-family: 'Montserrat', sans-serif;
        }
        .primary-button:hover {
            background: #315cfd;
            color: white;
            font-size: 1.3em;
        }
        /**/
        .second-button {
            width: 150px;
            height: 60px;
            color: #86198f;
            border: 3px solid #86198f;
            border-radius: 33px;
            transition: all 0.3s;
            cursor: pointer;
            background: white;
            font-size: 1.2em;
            font-weight: 550;
            font-family: 'Montserrat', sans-serif;
        }
        .second-button:hover {
            background: #86198f;
            color: white;
            font-size: 1.3em;
        }
        /**/
        /**/
        .third-button {
            width: 150px;
            height: 60px;
            color: #047857;
            border: 3px solid #047857;
            border-radius: 33px;
            transition: all 0.3s;
            cursor: pointer;
            background: white;
            font-size: 1.2em;
            font-weight: 550;
            font-family: 'Montserrat', sans-serif;
        }
        .third-button:hover {
            background: #047857;
            color: white;
            font-size: 1.3em;
        }
        /**/
        .fourth-button {
            width: 150px;
            height: 60px;
            color: #ea580c;
            border: 3px solid #ea580c;
            border-radius: 33px;
            transition: all 0.3s;
            cursor: pointer;
            background: white;
            font-size: 1.2em;
            font-weight: 550;
            font-family: 'Montserrat', sans-serif;
        }
        .fourth-button:hover {
            background: #ea580c;
            color: white;
            font-size: 1.3em;
        }
        /**/
    </style>
    <div class="btn-container">
        <div class="btn"><button class="primary-button" onclick="skip('docs')">查看文档</button></div>
        <div class="btn"><button class="second-button" onclick="skip('blog')">查看博客</button></div>
        <div class="btn"><button class="third-button" onclick="skip('essay')">查看随笔</button></div>
        <div class="btn"><button class="fourth-button" onclick="skip('about')">查看关于</button></div>
    </div>
    <script>
        function skip(path) {
            window.location.href = "/" + path
        }
    </script>
</div>

<!--
{{< cards >}}
    {{< card link="/" title="Travel" image="https://source.unsplash.com/featured/800x600?travel" subtitle="Embark on a visual journey around the globe with this category, as photographers capture the essence of exploration and wanderlust. Through vibrant street scenes and immersive cultural experiences, the Travel category showcases the beauty and diversity of destinations near and far." >}}
    {{< card link="/" title="Nature" image="https://source.unsplash.com/featured/800x600?nature" subtitle="Nature's wonders take center stage in this category, where photographers capture the breathtaking landscapes, diverse flora and fauna, and mesmerizing natural phenomena that adorn our planet. From grand vistas to macro shots, these images transport viewers into the heart of the great outdoors." >}}
    {{< card link="/" title="Animals" image="https://source.unsplash.com/featured/800x600?animals" subtitle="This category pays homage to the fascinating world of animals. Photographers capture the diversity, behavior, and beauty of creatures from across the globe, bringing the animal kingdom closer to the viewer's heart and lens." >}}
    {{< card link="/" title="People" image="https://source.unsplash.com/featured/800x600?people" subtitle="People are the focal point of this category, where photographers skillfully depict the human experience. From candid moments to formal portraits, this category showcases the myriad emotions, cultures, and stories that define us." >}}
    {{< card link="/" title="Food" image="https://source.unsplash.com/featured/800x600?food" subtitle="From simple home-cooked dinners at home, to tasting new dishes while traveling — food connects us all. This category examines the world of food photography, with shots of everything from summer picnics in the park to decadent deserts." >}}
    {{< card link="/" title="Sports" image="https://source.unsplash.com/featured/800x600?sports" subtitle="From adrenaline-fueled moments of victory to the camaraderie among athletes, this category celebrates the captivating world of sports photography. Showcasing both intensity and emotion, photographers freeze-frame the essence of competition, highlighting the dedication and spirit that define sports worldwide." >}}
{{< /cards >}}
-->

<!--
{{< feature-grid >}}
  {{< feature-card
    title="Environment Variables"
    subtitle="Environment variables are a simple way of configuring your applications, their deployment and their behaviour."
    link="/doc/reference/reference-environment-variables"
    class="aspect-auto md:aspect-[1.1/1] max-md:min-h-[340px]"
    image="/images/icons.png"
    imageClass="top-[40%] left-[24px] w-[180%] sm:w-[110%] dark:opacity-80"
    style="background: radial-gradient(ellipse at 50% 80%,rgba(58, 56, 113, 0.1),hsla(0,0%,100%,0));"
  >}}
  {{< feature-card
    title="API"
    subtitle="The Clever Cloud API reference."
    link="/api"
    class="aspect-auto md:aspect-[1.1/1] max-lg:min-h-[340px]"
    image="/images/metrics-home.png"
    imageClass="top-[40%] left-[36px] w-[180%] sm:w-[110%] dark:opacity-80"
    style="background: radial-gradient(ellipse at 50% 80%,rgba(203, 28, 66, 0.1),hsla(0,0%,100%,0));"
  >}}
  {{< feature-card
    title="The CLI Clever Tools"
    subtitle="An official Command Line Interface for Clever Cloud."
    link="/doc/cli"
    class="aspect-auto md:aspect-[1.1/1] max-md:min-h-[340px]"
    image="/images/brand.png"
    imageClass="top-[40%] left-[36px] w-[110%] sm:w-[110%] dark:opacity-80"
    style="background: radial-gradient(ellipse at 50% 80%,rgba(245, 116, 97, 0.1),hsla(0,0%,100%,0));"
  >}}

  {{< feature-card
    title="Steps by Steps Guides"
    subtitle="Find detailed tutorials to deploy your favorite framework on Clever Cloud"
    link="/guides"
    style="text-decoration: none;"
  >}}
  {{< feature-card
    title="Deploy an application"
    subtitle="See supported languages and how to configure your app to deploy successfully"
    link="/doc/applications"
    style="text-decoration: none;"
  >}}
  {{< feature-card
    title="Connect your application to dependencies"
    subtitle="See our available add-ons such as MySQL, PostgreSQL, Redis, Mongo, Elastic..."
    link="/doc/addons"
    style="text-decoration: none;"
  >}}

{{< /feature-grid >}}
-->

<br>
<!-- {{< icon "hugo-full" >}} -->

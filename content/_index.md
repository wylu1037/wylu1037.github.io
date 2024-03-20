---
title: ""
date: 2024-02-18T14:30:52+08:00
toc: false
width: full
---

{{< animation type="main">}}

<div style="display:grid; grid-template-columns: 4fr 3fr;">
    <div>
        <font style="font-size:50px;font-weight:bold;line-height:1.2;">使用 Markdown & Hugo<br> 搭建的个人网站<br></font>
        <br>
        <font style="font-size:20px;font-weight:270;">Fast, batteries-included Hugo theme<br>for creating beautiful static websites<br></font>
        <div style="margin-top: 130px;">
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
                    width: 220px;
                    height: 42px;
                    color: white;
                    border-radius: 6px;
                    transition: all 0.3s;
                    cursor: pointer;
                    background: #315cfd;
                    font-size: 1.2em;
                    font-weight: 470;
                    font-family: 'Montserrat', sans-serif;
                    font-size: 1.0em;
                }
                .primary-button:hover {
                    background: #3b82f6;
                    color: white;
                    font-size: 1.1em;
                }
                /**/
                .second-button {
                    width: 220px;
                    height: 42px;
                    color: #315cfd;
                    border-radius: 6px;
                    transition: all 0.3s;
                    cursor: pointer;
                    background: white;
                    font-size: 1.2em;
                    font-weight: 470;
                    font-family: 'Montserrat', sans-serif;
                    font-size: 1.0em;
                }
                .second-button:hover {
                    background: #eff6ff;
                    color: #315cfd;
                    font-size: 1.1em;
                }
            </style>
            <div class="btn-container">
                <div class="btn">
                    <button class="primary-button" onclick="skip('docs')">查看文档</button>
                </div>
                <div class="btn"><button class="second-button" onclick="skip('blog')">探索我的博客</button></div>
            </div>
            <script>
                function skip(path) {
                    window.location.href = "/" + path
                }
            </script>
        </div>
    </div>
     <div>
        <image src="/images/brand.png" />
    </div>
</div>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Infinite Scroll</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="main" style="margin-top:30px">
        <p align="center" style="color: #6b7280;font-weight:500;font-size:30px">我的技术栈</p>
        <div class="tech-container" style="display:grid;grid-template-columns: repeat(5, 1fr);grid-template-rows: repeat(3, auto);gap: 10px;">
            <div class="tech">
                <img src="/images/scroll-animation/html.png" alt="">
            </div>
            <div class="tech">
                <img src="/images/scroll-animation/css.png" alt="">
            </div>
            <div class="tech">
                <img src="/images/scroll-animation/js.png" alt="">
            </div>
            <div class="tech">
                <img src="/images/scroll-animation/React.png" alt="">
            </div>
            <div class="tech">
                <img src="/images/scroll-animation/angular.png" alt="">
            </div>
            <div class="tech">
                <img src="/images/scroll-animation/figma.png" alt="">
            </div>
            <div class="tech">
                <img src="/images/scroll-animation/photoshop.png" alt="">
            </div>
            <div class="tech">
                <img src="/images/scroll-animation/mui.png" alt="">
            </div>
            <div class="tech">
                <img src="/images/scroll-animation/tailwind.png" alt="">
            </div>
            <div class="tech">
                <img src="/images/scroll-animation/premierePro.png" alt="">
            </div>
        </div>
    </div>
    <style>
        .tech-container {
            margin: 20px auto;
        }
        .tech {
            max-width: 50px;
            font-size: 20px;
            margin: 0 auto;
        }
    </style>

</body>
</html>

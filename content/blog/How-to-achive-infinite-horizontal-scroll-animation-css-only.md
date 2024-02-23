---
title: 🥳 Infinite horizontal scroll animation
date: 2024-02-23T21:42:14+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
width: wide
---

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Infinite Scroll</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="main">
        <div class="scroll" style="--time:20s">
            <div>
                <span>HTML</span>
                <span>CSS</span>
                <span>JavaScript</span>
                <span>ReactJS</span>
                <span>Figma</span>
                <span>Photoshop</span>
                <span>Premiere Pro</span>
                <span>Figma</span>
                <span>Angular</span>
                <span>Node JS</span>
            </div>
            <div>
                <span>HTML</span>
                <span>CSS</span>
                <span>JavaScript</span>
                <span>ReactJS</span>
                <span>Figma</span>
                <span>Photoshop</span>
                <span>Premiere Pro</span>
                <span>Figma</span>
                <span>Angular</span>
                <span>Node JS</span>
            </div>
        </div>
        <div class="scroll" style="--time:30s">
            <div>
                <span>HTML</span>
                <span>CSS</span>
                <span>JavaScript</span>
                <span>ReactJS</span>
                <span>Figma</span>
                <span>Photoshop</span>
                <span>Premiere Pro</span>
                <span>Figma</span>
                <span>Angular</span>
                <span>Node JS</span>
            </div>
            <div>
                <span>HTML</span>
                <span>CSS</span>
                <span>JavaScript</span>
                <span>ReactJS</span>
                <span>Figma</span>
                <span>Photoshop</span>
                <span>Premiere Pro</span>
                <span>Figma</span>
                <span>Angular</span>
                <span>Node JS</span>
            </div>
        </div>
        <div class="scroll" style="--time:25s">
            <div>
                <span>HTML</span>
                <span>CSS</span>
                <span>JavaScript</span>
                <span>ReactJS</span>
                <span>Figma</span>
                <span>Photoshop</span>
                <span>Premiere Pro</span>
                <span>Figma</span>
                <span>Angular</span>
                <span>Node JS</span>
            </div>
            <div>
                <span>HTML</span>
                <span>CSS</span>
                <span>JavaScript</span>
                <span>ReactJS</span>
                <span>Figma</span>
                <span>Photoshop</span>
                <span>Premiere Pro</span>
                <span>Figma</span>
                <span>Angular</span>
                <span>Node JS</span>
            </div>
        </div>
        <div class="scroll" style="--time:40s">
            <div>
                <span>HTML</span>
                <span>CSS</span>
                <span>JavaScript</span>
                <span>ReactJS</span>
                <span>Figma</span>
                <span>Photoshop</span>
                <span>Premiere Pro</span>
                <span>Figma</span>
                <span>Angular</span>
                <span>Node JS</span>
            </div>
            <div>
                <span>HTML</span>
                <span>CSS</span>
                <span>JavaScript</span>
                <span>ReactJS</span>
                <span>Figma</span>
                <span>Photoshop</span>
                <span>Premiere Pro</span>
                <span>Figma</span>
                <span>Angular</span>
                <span>Node JS</span>
            </div>
        </div>
        <div class="scroll imgBox" style="--time:25s">
            <div>
                <img src="/images/scroll-animation/html.png" alt="">
                <img src="/images/scroll-animation/css.png" alt="">
                <img src="/images/scroll-animation/js.png" alt="">
                <img src="/images/scroll-animation/React.png" alt="">
                <img src="/images/scroll-animation/angular.png" alt="">
                <img src="/images/scroll-animation/figma.png" alt="">
                <img src="/images/scroll-animation/photoshop.png" alt="">
                <img src="/images/scroll-animation/mui.png" alt="">
                <img src="/images/scroll-animation/tailwind.png" alt="">
                <img src="/images/scroll-animation/premierePro.png" alt="">
            </div>
            <div>
                <img src="/images/scroll-animation/html.png" alt="">
                <img src="/images/scroll-animation/css.png" alt="">
                <img src="/images/scroll-animation/js.png" alt="">
                <img src="/images/scroll-animation/React.png" alt="">
                <img src="/images/scroll-animation/angular.png" alt="">
                <img src="/images/scroll-animation/figma.png" alt="">
                <img src="/images/scroll-animation/photoshop.png" alt="">
                <img src="/images/scroll-animation/mui.png" alt="">
                <img src="/images/scroll-animation/tailwind.png" alt="">
                <img src="/images/scroll-animation/premierePro.png" alt="">
            </div>
        </div>
    </div>
    <style>
        div.main {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            margin-bottom: 50px;
        }
        .scroll {
            position: relative;
            display: flex;
            width: 100%;
            min-width: 200px;
            max-width: 750px;
            overflow: hidden;
            -webkit-mask-image: linear-gradient(90deg, transparent, #fff 20%, #fff 80%, transparent)
        }
        .scroll div {
            white-space: nowrap;
            animation: scroll var(--time) linear infinite;
            animation-delay: calc(var(--time)*-1);
        }
        .scroll div:nth-child(2) {
            animation: scroll2 var(--time) linear infinite;
            animation-delay: calc(var(--time)/-2);
        }
        @keyframes scroll {
            0% {
                transform: translateX(100%);
            }
            100% {
                transform: translateX(-100%);
            }
        }
        @keyframes scroll2 {
            0% {
                transform: translateX(0);
            }
            100% {
                transform: translateX(-200%);
            }
        }
        .scroll div span {
            display: inline-flex;
            margin: 10px;
            letter-spacing: 0.2em;
            background: #333;
            color: #fff;
            padding: 5px 10px;
            border-radius: 5px;
            transition: 0.5s;
        }
        .scroll div span:hover {
            background: #3fd2f9;
            cursor: pointer;
        }
        .imgBox div {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .imgBox img {
            max-width: 100px;
            scale: 0.8;
        }
    </style>
</body>
</html>

Are you prepare to creating an impressive infinite horizontal scroll animation using only CSS? Ok, you have come to the right place. Above is the display effect. Next, i will show you the code directly.

{{% details title="Click me to see the full code" closed="true" %}}

```html {filename="index.html"}
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Infinite Scroll</title>
    <link rel="stylesheet" href="styles.css">
</head>

<body>
    <div class="scroll" style="--time:20s">
        <div>
            <span>HTML</span>
            <span>CSS</span>
            <span>JavaScript</span>
            <span>ReactJS</span>
            <span>Figma</span>
            <span>Photoshop</span>
            <span>Premiere Pro</span>
            <span>Figma</span>
            <span>Angular</span>
            <span>Node JS</span>
        </div>
        <div>
            <span>HTML</span>
            <span>CSS</span>
            <span>JavaScript</span>
            <span>ReactJS</span>
            <span>Figma</span>
            <span>Photoshop</span>
            <span>Premiere Pro</span>
            <span>Figma</span>
            <span>Angular</span>
            <span>Node JS</span>
        </div>
    </div>
    <div class="scroll" style="--time:30s">
        <div>
            <span>HTML</span>
            <span>CSS</span>
            <span>JavaScript</span>
            <span>ReactJS</span>
            <span>Figma</span>
            <span>Photoshop</span>
            <span>Premiere Pro</span>
            <span>Figma</span>
            <span>Angular</span>
            <span>Node JS</span>
        </div>
        <div>
            <span>HTML</span>
            <span>CSS</span>
            <span>JavaScript</span>
            <span>ReactJS</span>
            <span>Figma</span>
            <span>Photoshop</span>
            <span>Premiere Pro</span>
            <span>Figma</span>
            <span>Angular</span>
            <span>Node JS</span>
        </div>
    </div>
    <div class="scroll" style="--time:25s">
        <div>
            <span>HTML</span>
            <span>CSS</span>
            <span>JavaScript</span>
            <span>ReactJS</span>
            <span>Figma</span>
            <span>Photoshop</span>
            <span>Premiere Pro</span>
            <span>Figma</span>
            <span>Angular</span>
            <span>Node JS</span>
        </div>
        <div>
            <span>HTML</span>
            <span>CSS</span>
            <span>JavaScript</span>
            <span>ReactJS</span>
            <span>Figma</span>
            <span>Photoshop</span>
            <span>Premiere Pro</span>
            <span>Figma</span>
            <span>Angular</span>
            <span>Node JS</span>
        </div>
    </div>
    <div class="scroll" style="--time:40s">
        <div>
            <span>HTML</span>
            <span>CSS</span>
            <span>JavaScript</span>
            <span>ReactJS</span>
            <span>Figma</span>
            <span>Photoshop</span>
            <span>Premiere Pro</span>
            <span>Figma</span>
            <span>Angular</span>
            <span>Node JS</span>
        </div>
        <div>
            <span>HTML</span>
            <span>CSS</span>
            <span>JavaScript</span>
            <span>ReactJS</span>
            <span>Figma</span>
            <span>Photoshop</span>
            <span>Premiere Pro</span>
            <span>Figma</span>
            <span>Angular</span>
            <span>Node JS</span>
        </div>
    </div>

    <div class="scroll imgBox" style="--time:25s">
        <div>
            <img src="./images/html.png" alt="">
            <img src="./images/css.png" alt="">
            <img src="./images/js.png" alt="">
            <img src="./images/React.png" alt="">
            <img src="./images/angular.png" alt="">
            <img src="./images/figma.png" alt="">
            <img src="./images/photoshop.png" alt="">
            <img src="./images/mui.png" alt="">
            <img src="./images/tailwind.png" alt="">
            <img src="./images/premierePro.png" alt="">
        </div>
        <div>
            <img src="./images/html.png" alt="">
            <img src="./images/css.png" alt="">
            <img src="./images/js.png" alt="">
            <img src="./images/React.png" alt="">
            <img src="./images/angular.png" alt="">
            <img src="./images/figma.png" alt="">
            <img src="./images/photoshop.png" alt="">
            <img src="./images/mui.png" alt="">
            <img src="./images/tailwind.png" alt="">
            <img src="./images/premierePro.png" alt="">
        </div>
    </div>

<style>
    * {
        margin: 0;
        padding: 0;
        font-family: "Poppins", sans-serif;
        box-sizing: border-box;
    }

    body {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        background: #000;
        flex-direction: column;
    }

    .scroll {
        position: relative;
        display: flex;
        width: 700px;
        overflow: hidden;
        -webkit-mask-image: linear-gradient(90deg, transparent, #fff 20%, #fff 80%, transparent)
    }

    .scroll div {
        white-space: nowrap;
        animation: scroll var(--time) linear infinite;
        animation-delay: calc(var(--time)*-1);

    }

    .scroll div:nth-child(2) {
        animation: scroll2 var(--time) linear infinite;
        animation-delay: calc(var(--time)/-2);
    }

    @keyframes scroll {
        0% {
            transform: translateX(100%);
        }

        100% {
            transform: translateX(-100%);
        }
    }

    @keyframes scroll2 {
        0% {
            transform: translateX(0);
        }

        100% {
            transform: translateX(-200%);
        }
    }

    .scroll div span {
        display: inline-flex;
        margin: 10px;
        letter-spacing: 0.2em;
        background: #333;
        color: #fff;
        padding: 5px 10px;
        border-radius: 5px;
        transition: 0.5s;
    }

    .scroll div span:hover {
        background: #3fd2f9;
        cursor: pointer;
    }

    .imgBox div {
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .imgBox img {
        max-width: 100px;
        scale: 0.8;
    }
</style>
</body>
</html>
```

{{% /details %}}

🚀 You also can watch the video to get this skill that infinite horizontal scroll animation.
<div style="margin-top: 20px; margin-bottom: 20px;">
    {{< youtube 0QI4ymWwpG0 >}}
</div>
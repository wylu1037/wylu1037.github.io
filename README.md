<h1 align="center">Personal blog</h1>
<p align="center">
  <a href="#Tech stack">🪂 Tech stack</a> &#xa0; | &#xa0;
  <a href="#Website">🕸️ Website</a> &#xa0; | &#xa0;
  <a href="https://github.com/wylu1037" target="_blank">🧑🏽‍💻 Author</a>
</p>

<div style="display: flex; justify-content: center; margin-top: 30px; margin-bottom: 30px">
    <style>
        .face {
            position: relative;
            width: 180px;
            height: 180px;
            border-radius: 50%;
            outline: 10px solid #333;
            background: repeating-radial-gradient(circle at 50% 50%, 
            rgba(200,200,200,.2) 0%, rgba(200,200,200,.2) 2%, 
            transparent 2%, transparent 3%, rgba(200,200,200,.2) 3%, 
            transparent 3%), conic-gradient(white 0%, silver 10%, 
            white 35%, silver 45%, white 60%, silver 70%, 
            white 80%, silver 95%, white 100%);
            box-shadow: inset 0 0 20px #0007;
        }
        .hour {
            position: absolute;
            width: 5px;
            height: 60px;
            background: #aaa;
            left: 87.5px;
            top: 43px;
            border-radius: 3px 3px 1px 1px;
            transform-origin: 2px 47px;
            box-shadow: 0 0 5px #0005,inset 1.5px 3px 0px #333, inset -1.5px -3px 0px #333;
            z-index: 1;
            animation: watch 43200s linear infinite;
        }
        .minute {
            position: absolute;
            width: 4px;
            height: 78px;
            background: #aaa;
            left: 88px;
            top: 25px;
            border-radius: 3px 3px 1px 1px;
            transform-origin: 2px 65px;
            box-shadow: 0 0 5px #0005, inset 1.5px 3px 0px #333, inset -1.5px -3px 0px #333;
            z-index: 2;
            animation: watch 3600s linear infinite;
        }
        .second {
            position: absolute;
            width: 10px;
            height: 10px;
            background: red;
            left: 85px;
            top: 85px;
            border-radius: 50%;
            border: 1px solid #eee;
            z-index: 3;
            animation: watch 60s steps(60, end) 0s infinite;
        }
        .second::before {
            content: "";
            position: absolute;
            width: 1px;
            height: 85px;
            left: 3px;
            bottom: -10px;
            background: red;
            border-radius: 2px;
            box-shadow: 5px 0 2px rgba(128, 128, 128, 0.2);
        }
        .second::after {
            content: "";
            position: absolute;
            width: 4px;
            height: 4px;
            left: 2px;
            top: 2px;
            background: #555;
            border-radius: 50%;
        }
        .v-index {
            position: absolute;
            color: #333;
            font-size: 24px;
            left: 83.5px;
            top: -3px;
            text-shadow: 0 157px 0 #333;
            z-index: 1
        }
        .h-index {
            position: absolute;
            color: #333;
            font-size: 24px;
            top: 72px;
            left: 5px;
            transform: rotate(-90deg);
            text-shadow: 0 158px 0 #333;
            z-index: 1;
        }
        @keyframes watch {
        0% {
            transform: rotate(0deg);
        }
        100% {
            transform: rotate(360deg);
        }
        }
    </style>
    <div class="face">
        <p class="v-index">II
        </p>
        <p class="h-index">II
        </p>
        <div class="hand">
            <div class="hand">
                <div class="hour"></div>
                <div class="minute"></div>
                <div class="second"></div>
            </div>
        </div>
    </div>
</div>

## 🪂 Tech stack

+ [Hugo: The world’s fastest framework for building websites](https://gohugo.io/)
+ [Theme: hextra](https://imfing.github.io/hextra/)

## 🕸️ Website

[Click me to view blog](https://wylu1037.github.io/)
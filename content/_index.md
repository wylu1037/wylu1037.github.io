+++
title = ''
date = 2024-02-18T14:30:52+08:00
draft = false
toc = false
+++

<div style="margin-top: 70px; margin-bottom: 80px">
    <style>
        .boxes {
            --size: 32px;
            --duration: 800ms;
            height: calc(var(--size) * 2);
            width: calc(var(--size) * 3);
            position: relative;
            transform-style: preserve-3d;
            transform-origin: 50% 50%;
            margin-top: calc(var(--size) * 1.5 * -1);
            transform: rotateX(60deg) rotateZ(45deg) rotateY(0deg) translateZ(0px);
        }
        .boxes .box {
            width: var(--size);
            height: var(--size);
            top: 0;
            left: 0;
            position: absolute;
            transform-style: preserve-3d;
        }
        .boxes .box:nth-child(1) {
            transform: translate(100%, 0);
            -webkit-animation: box1 var(--duration) linear infinite;
            animation: box1 var(--duration) linear infinite;
        }
        .boxes .box:nth-child(2) {
            transform: translate(0, 100%);
            -webkit-animation: box2 var(--duration) linear infinite;
            animation: box2 var(--duration) linear infinite;
        }
        .boxes .box:nth-child(3) {
            transform: translate(100%, 100%);
            -webkit-animation: box3 var(--duration) linear infinite;
            animation: box3 var(--duration) linear infinite;
        }
        .boxes .box:nth-child(4) {
            transform: translate(200%, 0);
            -webkit-animation: box4 var(--duration) linear infinite;
            animation: box4 var(--duration) linear infinite;
        }
        .boxes .box > div {
            --background: #5C8DF6;
            --top: auto;
            --right: auto;
            --bottom: auto;
            --left: auto;
            --translateZ: calc(var(--size) / 2);
            --rotateY: 0deg;
            --rotateX: 0deg;
            position: absolute;
            width: 100%;
            height: 100%;
            background: var(--background);
            top: var(--top);
            right: var(--right);
            bottom: var(--bottom);
            left: var(--left);
            transform: rotateY(var(--rotateY)) rotateX(var(--rotateX)) translateZ(var(--translateZ));
        }
        .boxes .box > div:nth-child(1) {
            --top: 0;
            --left: 0;
        }
        .boxes .box > div:nth-child(2) {
            --background: #145af2;
            --right: 0;
            --rotateY: 90deg;
        }
        .boxes .box > div:nth-child(3) {
            --background: #447cf5;
            --rotateX: -90deg;
        }
        .boxes .box > div:nth-child(4) {
            --background: #DBE3F4;
            --top: 0;
            --left: 0;
            --translateZ: calc(var(--size) * 3 * -1);
        }
        @-webkit-keyframes box1 {
        0%, 50% {
            transform: translate(100%, 0);
        }
        100% {
            transform: translate(200%, 0);
        }
        }
        @keyframes box1 {
        0%, 50% {
            transform: translate(100%, 0);
        }
        100% {
            transform: translate(200%, 0);
        }
        }
        @-webkit-keyframes box2 {
        0% {
            transform: translate(0, 100%);
        }
        50% {
            transform: translate(0, 0);
        }
        100% {
            transform: translate(100%, 0);
        }
        }
        @keyframes box2 {
        0% {
            transform: translate(0, 100%);
        }
        50% {
            transform: translate(0, 0);
        }
        100% {
            transform: translate(100%, 0);
        }
        }
        @-webkit-keyframes box3 {
        0%, 50% {
            transform: translate(100%, 100%);
        }
        100% {
            transform: translate(0, 100%);
        }
        }
        @keyframes box3 {
        0%, 50% {
            transform: translate(100%, 100%);
        }
        100% {
            transform: translate(0, 100%);
        }
        }
        @-webkit-keyframes box4 {
        0% {
            transform: translate(200%, 0);
        }
        50% {
            transform: translate(200%, 100%);
        }
        100% {
            transform: translate(100%, 100%);
        }
        }
        @keyframes box4 {
        0% {
            transform: translate(200%, 0);
        }
        50% {
            transform: translate(200%, 100%);
        }
        100% {
            transform: translate(100%, 100%);
        }
        }
    </style>
    <!-- div -->
    <div class="boxes">
        <div class="box">
            <div></div>
            <div></div>
            <div></div>
            <div></div>
        </div>
        <div class="box">
            <div></div>
            <div></div>
            <div></div>
            <div></div>
        </div>
        <div class="box">
            <div></div>
            <div></div>
            <div></div>
            <div></div>
        </div>
        <div class="box">
            <div></div>
            <div></div>
            <div></div>
            <div></div>
        </div>
    </div>
</div>

<font style="font-size:50px;font-weight:bold;line-height:1.2;">Build modern websites<br> with Markdown and Hugo<br></font>

<font style="font-size:20px;font-weight:270">Fast, batteries-included Hugo theme<br>
for creating beautiful static websites<br></font>

<div>
    <style>
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
            margin-top: 50px;
            margin-bottom: 50px;
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
            margin-left: 8px;
            margin-right: 8px;
            margin-top: 50px;
            margin-bottom: 50px;
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
            margin-top: 50px;
            margin-bottom: 50px;
        }
        .third-button:hover {
            background: #047857;
            color: white;
            font-size: 1.3em;
        }
        /**/
    </style>
    <div>
        <button class="primary-button" onclick="skip('blog')">View Blog</button>
        <button class="second-button" onclick="skip('docs')">View Docs</button>
        <button class="third-button" onclick="skip('about')">View About</button>
    </div>
    <script>
        function skip(path) {
            window.location.href = "/" + path
        }
    </script>
</div>

{{< cards >}}
{{< card link="/" title="Landscape" image="https://source.unsplash.com/featured/800x600?landscape" subtitle="Unsplash Landscape" >}}
{{< card link="/" title="Nature" image="https://source.unsplash.com/featured/800x600?nature" subtitle="Unsplash Nature" >}}
{{< card link="/" title="Animals" image="https://source.unsplash.com/featured/800x600?animals" subtitle="Unsplash Animals" >}}
{{< card link="/" title="People" image="https://source.unsplash.com/featured/800x600?people" subtitle="Unsplash People" >}}
{{< card link="/" title="Food" image="https://source.unsplash.com/featured/800x600?food" subtitle="Unsplash Food" >}}
{{< card link="/" title="Drink" image="https://source.unsplash.com/featured/800x600?drink" subtitle="Unsplash Drink" >}}
{{< /cards >}}

<br>
<!-- {{< icon "hugo-full" >}} -->

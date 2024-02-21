---
title: ''
date: 2024-02-18T14:30:52+08:00
draft: false
toc: false
---

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

<font style="font-size:50px;font-weight:bold;line-height:1.2;">Record personal blog<br> use Markdown and Hugo<br></font>

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
        <div class="btn"><button class="primary-button" onclick="skip('docs')">View Docs</button></div>
        <div class="btn"><button class="second-button" onclick="skip('blog')">View Blog</button></div>
        <div class="btn"><button class="third-button" onclick="skip('essay')">View Essay</button></div>
        <div class="btn"><button class="fourth-button" onclick="skip('about')">View About</button></div>
    </div>
    <script>
        function skip(path) {
            window.location.href = "/" + path
        }
    </script>
</div>

{{< cards >}}
{{< card link="/" title="Travel" image="https://source.unsplash.com/featured/800x600?travel" subtitle="Embark on a visual journey around the globe with this category, as photographers capture the essence of exploration and wanderlust. Through vibrant street scenes and immersive cultural experiences, the Travel category showcases the beauty and diversity of destinations near and far." >}}
{{< card link="/" title="Nature" image="https://source.unsplash.com/featured/800x600?nature" subtitle="Nature's wonders take center stage in this category, where photographers capture the breathtaking landscapes, diverse flora and fauna, and mesmerizing natural phenomena that adorn our planet. From grand vistas to macro shots, these images transport viewers into the heart of the great outdoors." >}}
{{< card link="/" title="Animals" image="https://source.unsplash.com/featured/800x600?animals" subtitle="This category pays homage to the fascinating world of animals. Photographers capture the diversity, behavior, and beauty of creatures from across the globe, bringing the animal kingdom closer to the viewer's heart and lens." >}}
{{< card link="/" title="People" image="https://source.unsplash.com/featured/800x600?people" subtitle="People are the focal point of this category, where photographers skillfully depict the human experience. From candid moments to formal portraits, this category showcases the myriad emotions, cultures, and stories that define us." >}}
{{< card link="/" title="Food" image="https://source.unsplash.com/featured/800x600?food" subtitle="From simple home-cooked dinners at home, to tasting new dishes while traveling — food connects us all. This category examines the world of food photography, with shots of everything from summer picnics in the park to decadent deserts." >}}
{{< card link="/" title="Sports" image="https://source.unsplash.com/featured/800x600?sports" subtitle="From adrenaline-fueled moments of victory to the camaraderie among athletes, this category celebrates the captivating world of sports photography. Showcasing both intensity and emotion, photographers freeze-frame the essence of competition, highlighting the dedication and spirit that define sports worldwide." >}}
{{< /cards >}}

<br>
<!-- {{< icon "hugo-full" >}} -->

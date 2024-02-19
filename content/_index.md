+++
title = ''
date = 2024-02-18T14:30:52+08:00
draft = false
toc = false
+++

<!--
<div>
    <style>
        .loader {
            --duration: 3s;
            --primary: rgba(39, 94, 254, 1);
            --primary-light: #2f71ff;
            --primary-rgba: rgba(39, 94, 254, 0);
            width: 200px;
            height: 320px;
            position: relative;
            transform-style: preserve-3d;
        }
        @media (max-width: 480px) {
        .loader {
            zoom: 0.44;
        }
        }
        .loader:before, .loader:after {
            --r: 20.5deg;
            content: "";
            width: 320px;
            height: 140px;
            position: absolute;
            right: 32%;
            bottom: -11px;
            /* change the back groung color on switching from light to dark mood */
            background: #e8e8e8;
            transform: translateZ(200px) rotate(var(--r));
            -webkit-animation: mask var(--duration) linear forwards infinite;
            animation: mask var(--duration) linear forwards infinite;
        }
        .loader:after {
            --r: -20.5deg;
            right: auto;
            left: 32%;
        }
        .loader .ground {
            position: absolute;
            left: -50px;
            bottom: -120px;
            transform-style: preserve-3d;
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        .loader .ground div {
            transform: rotateX(90deg) rotateY(0deg) translate(-48px, -120px) translateZ(100px) scale(0);
            width: 200px;
            height: 200px;
            background: var(--primary);
            background: linear-gradient(45deg, var(--primary) 0%, var(--primary) 50%, var(--primary-light) 50%, var(--primary-light) 100%);
            transform-style: preserve-3d;
            -webkit-animation: ground var(--duration) linear forwards infinite;
            animation: ground var(--duration) linear forwards infinite;
        }
        .loader .ground div:before, .loader .ground div:after {
            --rx: 90deg;
            --ry: 0deg;
            --x: 44px;
            --y: 162px;
            --z: -50px;
            content: "";
            width: 156px;
            height: 300px;
            opacity: 0;
            background: linear-gradient(var(--primary), var(--primary-rgba));
            position: absolute;
            transform: rotateX(var(--rx)) rotateY(var(--ry)) translate(var(--x), var(--y)) translateZ(var(--z));
            -webkit-animation: ground-shine var(--duration) linear forwards infinite;
            animation: ground-shine var(--duration) linear forwards infinite;
        }
        .loader .ground div:after {
            --rx: 90deg;
            --ry: 90deg;
            --x: 0;
            --y: 177px;
            --z: 150px;
        }
        .loader .box {
            --x: 0;
            --y: 0;
            position: absolute;
            -webkit-animation: var(--duration) linear forwards infinite;
            animation: var(--duration) linear forwards infinite;
            transform: translate(var(--x), var(--y));
        }
        .loader .box div {
            background-color: var(--primary);
            width: 48px;
            height: 48px;
            position: relative;
            transform-style: preserve-3d;
            -webkit-animation: var(--duration) ease forwards infinite;
            animation: var(--duration) ease forwards infinite;
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        .loader .box div:before, .loader .box div:after {
            --rx: 90deg;
            --ry: 0deg;
            --z: 24px;
            --y: -24px;
            --x: 0;
            content: "";
            position: absolute;
            background-color: inherit;
            width: inherit;
            height: inherit;
            transform: rotateX(var(--rx)) rotateY(var(--ry)) translate(var(--x), var(--y)) translateZ(var(--z));
            filter: brightness(var(--b, 1.2));
        }
        .loader .box div:after {
            --rx: 0deg;
            --ry: 90deg;
            --x: 24px;
            --y: 0;
            --b: 1.4;
        }
        .loader .box.box0 {
            --x: -220px;
            --y: -120px;
            left: 58px;
            top: 108px;
        }
        .loader .box.box1 {
            --x: -260px;
            --y: 120px;
            left: 25px;
            top: 120px;
        }
        .loader .box.box2 {
            --x: 120px;
            --y: -190px;
            left: 58px;
            top: 64px;
        }
        .loader .box.box3 {
            --x: 280px;
            --y: -40px;
            left: 91px;
            top: 120px;
        }
        .loader .box.box4 {
            --x: 60px;
            --y: 200px;
            left: 58px;
            top: 132px;
        }
        .loader .box.box5 {
            --x: -220px;
            --y: -120px;
            left: 25px;
            top: 76px;
        }
        .loader .box.box6 {
            --x: -260px;
            --y: 120px;
            left: 91px;
            top: 76px;
        }
        .loader .box.box7 {
            --x: -240px;
            --y: 200px;
            left: 58px;
            top: 87px;
        }
        .loader .box0 {
            -webkit-animation-name: box-move0;
            animation-name: box-move0;
        }
        .loader .box0 div {
            -webkit-animation-name: box-scale0;
            animation-name: box-scale0;
        }
        .loader .box1 {
            -webkit-animation-name: box-move1;
            animation-name: box-move1;
        }
        .loader .box1 div {
            -webkit-animation-name: box-scale1;
            animation-name: box-scale1;
        }
        .loader .box2 {
            -webkit-animation-name: box-move2;
            animation-name: box-move2;
        }
        .loader .box2 div {
        -webkit-animation-name: box-scale2;
        animation-name: box-scale2;
        }
        .loader .box3 {
        -webkit-animation-name: box-move3;
        animation-name: box-move3;
        }
        .loader .box3 div {
        -webkit-animation-name: box-scale3;
        animation-name: box-scale3;
        }
        .loader .box4 {
        -webkit-animation-name: box-move4;
        animation-name: box-move4;
        }
        .loader .box4 div {
        -webkit-animation-name: box-scale4;
        animation-name: box-scale4;
        }
        .loader .box5 {
        -webkit-animation-name: box-move5;
        animation-name: box-move5;
        }
        .loader .box5 div {
        -webkit-animation-name: box-scale5;
        animation-name: box-scale5;
        }
        .loader .box6 {
        -webkit-animation-name: box-move6;
        animation-name: box-move6;
        }
        .loader .box6 div {
        -webkit-animation-name: box-scale6;
        animation-name: box-scale6;
        }
        .loader .box7 {
        -webkit-animation-name: box-move7;
        animation-name: box-move7;
        }
        .loader .box7 div {
        -webkit-animation-name: box-scale7;
        animation-name: box-scale7;
        }
        @-webkit-keyframes box-move0 {
        12% {
            transform: translate(var(--x), var(--y));
        }
        25%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @keyframes box-move0 {
        12% {
            transform: translate(var(--x), var(--y));
        }
        25%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @-webkit-keyframes box-scale0 {
        6% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        14%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @keyframes box-scale0 {
        6% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        14%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @-webkit-keyframes box-move1 {
        16% {
            transform: translate(var(--x), var(--y));
        }
        29%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @keyframes box-move1 {
        16% {
            transform: translate(var(--x), var(--y));
        }
        29%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @-webkit-keyframes box-scale1 {
        10% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        18%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @keyframes box-scale1 {
        10% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        18%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @-webkit-keyframes box-move2 {
        20% {
            transform: translate(var(--x), var(--y));
        }
        33%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @keyframes box-move2 {
        20% {
            transform: translate(var(--x), var(--y));
        }
        33%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @-webkit-keyframes box-scale2 {
        14% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        22%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @keyframes box-scale2 {
        14% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        22%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @-webkit-keyframes box-move3 {
        24% {
            transform: translate(var(--x), var(--y));
        }
        37%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @keyframes box-move3 {
        24% {
            transform: translate(var(--x), var(--y));
        }
        37%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @-webkit-keyframes box-scale3 {
        18% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        26%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @keyframes box-scale3 {
        18% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        26%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @-webkit-keyframes box-move4 {
        28% {
            transform: translate(var(--x), var(--y));
        }
        41%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @keyframes box-move4 {
        28% {
            transform: translate(var(--x), var(--y));
        }
        41%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @-webkit-keyframes box-scale4 {
        22% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        30%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @keyframes box-scale4 {
        22% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        30%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @-webkit-keyframes box-move5 {
        32% {
            transform: translate(var(--x), var(--y));
        }
        45%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @keyframes box-move5 {
        32% {
            transform: translate(var(--x), var(--y));
        }
        45%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @-webkit-keyframes box-scale5 {
        26% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        34%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @keyframes box-scale5 {
        26% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        34%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @-webkit-keyframes box-move6 {
        36% {
            transform: translate(var(--x), var(--y));
        }
        49%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @keyframes box-move6 {
        36% {
            transform: translate(var(--x), var(--y));
        }
        49%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @-webkit-keyframes box-scale6 {
        30% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        38%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @keyframes box-scale6 {
        30% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        38%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @-webkit-keyframes box-move7 {
        40% {
            transform: translate(var(--x), var(--y));
        }
        53%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @keyframes box-move7 {
        40% {
            transform: translate(var(--x), var(--y));
        }
        53%, 52% {
            transform: translate(0, 0);
        }
        80% {
            transform: translate(0, -32px);
        }
        90%, 100% {
            transform: translate(0, 188px);
        }
        }
        @-webkit-keyframes box-scale7 {
        34% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        42%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @keyframes box-scale7 {
        34% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(0);
        }
        42%, 100% {
            transform: rotateY(-47deg) rotateX(-15deg) rotateZ(15deg) scale(1);
        }
        }
        @-webkit-keyframes ground {
        0%, 65% {
            transform: rotateX(90deg) rotateY(0deg) translate(-48px, -120px) translateZ(100px) scale(0);
        }
        75%, 90% {
            transform: rotateX(90deg) rotateY(0deg) translate(-48px, -120px) translateZ(100px) scale(1);
        }
        100% {
            transform: rotateX(90deg) rotateY(0deg) translate(-48px, -120px) translateZ(100px) scale(0);
        }
        }
        @keyframes ground {
        0%, 65% {
            transform: rotateX(90deg) rotateY(0deg) translate(-48px, -120px) translateZ(100px) scale(0);
        }
        75%, 90% {
            transform: rotateX(90deg) rotateY(0deg) translate(-48px, -120px) translateZ(100px) scale(1);
        }
        100% {
            transform: rotateX(90deg) rotateY(0deg) translate(-48px, -120px) translateZ(100px) scale(0);
        }
        }
        @-webkit-keyframes ground-shine {
        0%, 70% {
            opacity: 0;
        }
        75%, 87% {
            opacity: 0.2;
        }
        100% {
            opacity: 0;
        }
        }
        @keyframes ground-shine {
        0%, 70% {
            opacity: 0;
        }
        75%, 87% {
            opacity: 0.2;
        }
        100% {
            opacity: 0;
        }
        }
        @-webkit-keyframes mask {
            0%, 65% {
                opacity: 0;
            }
            66%, 100% {
                opacity: 1;
            }
            }
            @keyframes mask {
            0%, 65% {
                opacity: 0;
            }
            66%, 100% {
                opacity: 1;
            }
        }
    </style>
    <div class="loader">
        <div class="box box0">
            <div></div>
        </div>
        <div class="box box1">
            <div></div>
        </div>
        <div class="box box2">
            <div></div>
        </div>
        <div class="box box3">
            <div></div>
        </div>
        <div class="box box4">
            <div></div>
        </div>
        <div class="box box5">
            <div></div>
        </div>
        <div class="box box6">
            <div></div>
        </div>
        <div class="box box7">
            <div></div>
        </div>
        <div class="ground">
            <div></div>
        </div>
    </div>
</div>
-->

<!--
<div>
    <style>
        .wheel-and-hamster {
        --dur: 1s;
        position: relative;
        width: 12em;
        height: 12em;
        font-size: 14px;
        }
        .wheel,
        .hamster,
        .hamster div,
        .spoke {
        position: absolute;
        }
        .wheel,
        .spoke {
        border-radius: 50%;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        }
        .wheel {
        background: radial-gradient(100% 100% at center,hsla(0,0%,60%,0) 47.8%,hsl(0,0%,60%) 48%);
        z-index: 2;
        }
        .hamster {
        animation: hamster var(--dur) ease-in-out infinite;
        top: 50%;
        left: calc(50% - 3.5em);
        width: 7em;
        height: 3.75em;
        transform: rotate(4deg) translate(-0.8em,1.85em);
        transform-origin: 50% 0;
        z-index: 1;
        }
        .hamster__head {
        animation: hamsterHead var(--dur) ease-in-out infinite;
        background: hsl(30,90%,55%);
        border-radius: 70% 30% 0 100% / 40% 25% 25% 60%;
        box-shadow: 0 -0.25em 0 hsl(30,90%,80%) inset,
                0.75em -1.55em 0 hsl(30,90%,90%) inset;
        top: 0;
        left: -2em;
        width: 2.75em;
        height: 2.5em;
        transform-origin: 100% 50%;
        }
        .hamster__ear {
        animation: hamsterEar var(--dur) ease-in-out infinite;
        background: hsl(0,90%,85%);
        border-radius: 50%;
        box-shadow: -0.25em 0 hsl(30,90%,55%) inset;
        top: -0.25em;
        right: -0.25em;
        width: 0.75em;
        height: 0.75em;
        transform-origin: 50% 75%;
        }
        .hamster__eye {
        animation: hamsterEye var(--dur) linear infinite;
        background-color: hsl(0,0%,0%);
        border-radius: 50%;
        top: 0.375em;
        left: 1.25em;
        width: 0.5em;
        height: 0.5em;
        }
        .hamster__nose {
        background: hsl(0,90%,75%);
        border-radius: 35% 65% 85% 15% / 70% 50% 50% 30%;
        top: 0.75em;
        left: 0;
        width: 0.2em;
        height: 0.25em;
        }
        .hamster__body {
        animation: hamsterBody var(--dur) ease-in-out infinite;
        background: hsl(30,90%,90%);
        border-radius: 50% 30% 50% 30% / 15% 60% 40% 40%;
        box-shadow: 0.1em 0.75em 0 hsl(30,90%,55%) inset,
                0.15em -0.5em 0 hsl(30,90%,80%) inset;
        top: 0.25em;
        left: 2em;
        width: 4.5em;
        height: 3em;
        transform-origin: 17% 50%;
        transform-style: preserve-3d;
        }
        .hamster__limb--fr,
        .hamster__limb--fl {
        clip-path: polygon(0 0,100% 0,70% 80%,60% 100%,0% 100%,40% 80%);
        top: 2em;
        left: 0.5em;
        width: 1em;
        height: 1.5em;
        transform-origin: 50% 0;
        }
        .hamster__limb--fr {
        animation: hamsterFRLimb var(--dur) linear infinite;
        background: linear-gradient(hsl(30,90%,80%) 80%,hsl(0,90%,75%) 80%);
        transform: rotate(15deg) translateZ(-1px);
        }
        .hamster__limb--fl {
        animation: hamsterFLLimb var(--dur) linear infinite;
        background: linear-gradient(hsl(30,90%,90%) 80%,hsl(0,90%,85%) 80%);
        transform: rotate(15deg);
        }
        .hamster__limb--br,
        .hamster__limb--bl {
        border-radius: 0.75em 0.75em 0 0;
        clip-path: polygon(0 0,100% 0,100% 30%,70% 90%,70% 100%,30% 100%,40% 90%,0% 30%);
        top: 1em;
        left: 2.8em;
        width: 1.5em;
        height: 2.5em;
        transform-origin: 50% 30%;
        }
        .hamster__limb--br {
        animation: hamsterBRLimb var(--dur) linear infinite;
        background: linear-gradient(hsl(30,90%,80%) 90%,hsl(0,90%,75%) 90%);
        transform: rotate(-25deg) translateZ(-1px);
        }
        .hamster__limb--bl {
        animation: hamsterBLLimb var(--dur) linear infinite;
        background: linear-gradient(hsl(30,90%,90%) 90%,hsl(0,90%,85%) 90%);
        transform: rotate(-25deg);
        }
        .hamster__tail {
        animation: hamsterTail var(--dur) linear infinite;
        background: hsl(0,90%,85%);
        border-radius: 0.25em 50% 50% 0.25em;
        box-shadow: 0 -0.2em 0 hsl(0,90%,75%) inset;
        top: 1.5em;
        right: -0.5em;
        width: 1em;
        height: 0.5em;
        transform: rotate(30deg) translateZ(-1px);
        transform-origin: 0.25em 0.25em;
        }
        .spoke {
        animation: spoke var(--dur) linear infinite;
        background: radial-gradient(100% 100% at center,hsl(0,0%,60%) 4.8%,hsla(0,0%,60%,0) 5%),
                linear-gradient(hsla(0,0%,55%,0) 46.9%,hsl(0,0%,65%) 47% 52.9%,hsla(0,0%,65%,0) 53%) 50% 50% / 99% 99% no-repeat;
        }
        /* Animations */
        @keyframes hamster {
        from, to {
            transform: rotate(4deg) translate(-0.8em,1.85em);
        }
        50% {
            transform: rotate(0) translate(-0.8em,1.85em);
        }
        }
        @keyframes hamsterHead {
        from, 25%, 50%, 75%, to {
            transform: rotate(0);
        }
        12.5%, 37.5%, 62.5%, 87.5% {
            transform: rotate(8deg);
        }
        }
        @keyframes hamsterEye {
        from, 90%, to {
            transform: scaleY(1);
        }
        95% {
            transform: scaleY(0);
        }
        }
        @keyframes hamsterEar {
        from, 25%, 50%, 75%, to {
            transform: rotate(0);
        }
        12.5%, 37.5%, 62.5%, 87.5% {
            transform: rotate(12deg);
        }
        }
        @keyframes hamsterBody {
        from, 25%, 50%, 75%, to {
            transform: rotate(0);
        }
        12.5%, 37.5%, 62.5%, 87.5% {
            transform: rotate(-2deg);
        }
        }
        @keyframes hamsterFRLimb {
        from, 25%, 50%, 75%, to {
            transform: rotate(50deg) translateZ(-1px);
        }
        12.5%, 37.5%, 62.5%, 87.5% {
            transform: rotate(-30deg) translateZ(-1px);
        }
        }
        @keyframes hamsterFLLimb {
        from, 25%, 50%, 75%, to {
            transform: rotate(-30deg);
        }
        12.5%, 37.5%, 62.5%, 87.5% {
            transform: rotate(50deg);
        }
        }
        @keyframes hamsterBRLimb {
        from, 25%, 50%, 75%, to {
            transform: rotate(-60deg) translateZ(-1px);
        }
        12.5%, 37.5%, 62.5%, 87.5% {
            transform: rotate(20deg) translateZ(-1px);
        }
        }
        @keyframes hamsterBLLimb {
        from, 25%, 50%, 75%, to {
            transform: rotate(20deg);
        }
        12.5%, 37.5%, 62.5%, 87.5% {
            transform: rotate(-60deg);
        }
        }
        @keyframes hamsterTail {
        from, 25%, 50%, 75%, to {
            transform: rotate(30deg) translateZ(-1px);
        }
        12.5%, 37.5%, 62.5%, 87.5% {
            transform: rotate(10deg) translateZ(-1px);
        }
        }
        @keyframes spoke {
        from {
            transform: rotate(0);
        }
        to {
            transform: rotate(-1turn);
        }
        }
    </style>
    <div aria-label="Orange and tan hamster running in a metal wheel" role="img" class="wheel-and-hamster">
        <div class="wheel"></div>
        <div class="hamster">
            <div class="hamster__body">
                <div class="hamster__head">
                    <div class="hamster__ear"></div>
                    <div class="hamster__eye"></div>
                    <div class="hamster__nose"></div>
                </div>
                <div class="hamster__limb hamster__limb--fr"></div>
                <div class="hamster__limb hamster__limb--fl"></div>
                <div class="hamster__limb hamster__limb--br"></div>
                <div class="hamster__limb hamster__limb--bl"></div>
                <div class="hamster__tail"></div>
            </div>
        </div>
        <div class="spoke"></div>
    </div>
</div>
-->

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
            border: 3px solid #315cfd;
            border-radius: 45px;
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
    </style>
    <button class="primary-button" onclick="skip()">Get Started</button>
    <script>
        function skip() {
            window.location.href = "/blog"
        }
    </script>
</div>

{{< cards >}}
{{< card link="/" title="Image Card" image="https://source.unsplash.com/featured/800x600?landscape" subtitle="Unsplash Landscape" >}}
{{< card link="/" title="Local Image" image="/images/meebits.png" subtitle="Raw image under static directory." >}}
{{< card link="/" title="Image Card" image="https://source.unsplash.com/featured/800x600?landscape" subtitle="Unsplash Landscape" >}}
{{< card link="/" title="Image Card" image="https://source.unsplash.com/featured/800x600?landscape" subtitle="Unsplash Landscape" >}}
{{< card link="/" title="Image Card" image="https://source.unsplash.com/featured/800x600?landscape" subtitle="Unsplash Landscape" >}}
{{< card link="/" title="Image Card" image="https://source.unsplash.com/featured/800x600?landscape" subtitle="Unsplash Landscape" >}}
{{< /cards >}}

<br>
<h1>All icons</h1>

{{< icon "github" >}}
{{< icon "codeberg" >}}
{{< icon "gitlab" >}}
{{< icon "hextra" >}}
{{< icon "hugo" >}}

{{< icon "hugo-full" >}}

{{< icon "warning" >}}
{{< icon "one" >}}
{{< icon "cards" >}}
{{< icon "copy" >}}
{{< icon "hamburger-menu" >}}
{{< icon "markdown" >}}
{{< icon "folder-tree" >}}

{{< icon "academic-cap" >}}
{{< icon "adjustments" >}}
{{< icon "annotation" >}}
{{< icon "archive" >}}
{{< icon "arrow-circle-left" >}}
{{< icon "clock" >}}
{{< icon "zoom-in" >}}

Social
{{< icon "instagram" >}}
{{< icon "facebook" >}}
{{< icon "discord" >}}
{{< icon "twitter" >}}
{{< icon "mastodon" >}}
{{< icon "youtube" >}}
{{< icon "x-twitter" >}}
{{< icon "linkedin" >}}

---
title: 🦋 Interactive Hexagon Grid
date: 2024-02-24T10:18:14+08:00
draft: true
---

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hexagon Grid</title>
</head>

<style>
    body {
        min-height: 100vh;
        overflow-x: hidden;
    }

    .container {
        background: #2b2b2b;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        position: relative;
    }

    #hex-grid {
        height: 100vh;
        background: #000;
    }

    #hex-grid .grid {
        position: absolute;
        top: 0;
        left: 0;
        background: url(/images/interactive-hexagon-grid/grid.svg)repeat;
        width: 100%;
        height: 100%;
        z-index: 1;
        background-size: 500px;
    }

    #hex-grid .light {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 15em;
        height: 15em;
        filter: blur(15px);
        background: linear-gradient(90deg, #335bf4 0%, #2ae9c9 100%);
        z-index: 0;
    }
</style>

<body>
    <div class="container">
        <div id="hex-grid">
            <div class="light"></div>
            <div class="grid"></div>
        </div>
    </div>
</body>

<script defer>
    const light = document.querySelector(".light");
    const grid = document.querySelector("#hex-grid");
    const content = document.querySelector(".grid");
    const rect = content.getBoundingClientRect();

    grid.addEventListener("mousemove", function (e) {
        light.style.left = `${e.clientX - 1*light.offsetWidth}px`;
        light.style.top = `${e.clientY - 1*light.offsetHeight}px`;
    })
</script>
</html>

The Interactive Hexagon Grid, crafted with HTML, CSS, and JavaScript, features a captivating dynamic where a light source moves in response to mouse movements behind the hexagonal grid. As the user interacts, the light source dynamically influences the appearance of the hexagons, creating an immersive visual effect. This interactive grid is not only visually engaging but also responsive to user input, offering a modern and interactive element for diverse applications, from creative displays to dynamic data visualizations. The combination of HTML, CSS, and JavaScript enables the seamless integration of this visually appealing and interactive feature into web applications.


{{% details title="Click me to see the full code" closed="true" %}}

```html {filename="index.html"}
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hexagon Grid</title>
</head>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        min-height: 100vh;
        overflow-x: hidden;
    }

    .container {
        position: relative;
        background: #2b2b2b;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
    }

    #hex-grid {
        height: 100vh;
        background: #000;
    }

    #hex-grid .grid {
        position: absolute;
        top: 0;
        left: 0;
        background: url(./images/grid.svg)repeat;
        width: 100%;
        height: 100%;
        z-index: 1;
        background-size: 500px;
    }

    #hex-grid .light {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 15em;
        height: 15em;
        filter: blur(15px);
        background: linear-gradient(90deg, #335bf4 0%, #2ae9c9 100%);
        z-index: 0;
    }
</style>

<body>
    <div class="container">
        <div id="hex-grid">
            <div class="light"></div>
            <div class="grid"></div>
        </div>
    </div>
</body>

<script defer>
    const light = document.querySelector(".light");
    const grid = document.querySelector("#hex-grid");
    const container = document.querySelector(".container");
    copnst rect = container.getBoundingClientRect();

    grid.addEventListener("mousemove", function (e) {
        light.style.left = `${e.clientX - rect.left}px`;
        light.style.top = `${e.clientY - rect.top}px`;
    })
</script>

</html>
```

{{% /details %}}

🚀 You also can watch the video to get this skill.
<div style="margin-top: 20px; margin-bottom: 20px;">
    {{< youtube 9x6bjKpJ_ag >}}
</div>
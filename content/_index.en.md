---
title: ''
date: 2024-02-18T14:30:52+08:00
toc: false
width: full
---

{{< animation type="main">}}

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

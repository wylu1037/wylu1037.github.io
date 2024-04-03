---
title: 🛡️ Ethereum
date: 2024-03-19T16:22:12+08:00
weight: 7
---

<div class="card-container">
    <div class="card">
    <svg class="img" xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="100%" height="100%" version="1.1" shape-rendering="geometricPrecision" text-rendering="geometricPrecision" image-rendering="optimizeQuality" fill-rule="evenodd" clip-rule="evenodd" viewBox="0 0 784.37 1277.39" xmlns:xlink="http://www.w3.org/1999/xlink">
    <g id="Layer_x0020_1">
    <metadata id="CorelCorpID_0Corel-Layer"></metadata>
    <g id="_1421394342400">
    <g>
        <polygon fill="#343434" fill-rule="nonzero" points="392.07,0 383.5,29.11 383.5,873.74 392.07,882.29 784.13,650.54"></polygon>
        <polygon fill="#8C8C8C" fill-rule="nonzero" points="392.07,0 -0,650.54 392.07,882.29 392.07,472.33"></polygon>
        <polygon fill="#3C3C3B" fill-rule="nonzero" points="392.07,956.52 387.24,962.41 387.24,1263.28 392.07,1277.38 784.37,724.89"></polygon>
        <polygon fill="#8C8C8C" fill-rule="nonzero" points="392.07,1277.38 392.07,956.52 -0,724.89"></polygon>
        <polygon fill="#141414" fill-rule="nonzero" points="392.07,882.29 784.13,650.54 392.07,472.33"></polygon>
        <polygon fill="#393939" fill-rule="nonzero" points="0,650.54 392.07,882.29 392.07,472.33"></polygon>
    </g>
    </g>
    </g>
    </svg>
    <div class="textBox">
        <p class="text head">Ethereum</p>
        <span>Cryptocurrency</span>
        <p class="text price">1.654,34€</p>
    </div>
    </div>
<style>
.card-container {
    display: flex;
    margin: 30px auto;
    justify-content: center;
}
.card {
  width: 195px;
  height: 285px;
  background: #313131;
  border-radius: 20px;
  ;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: white;
  transition: 0.2s ease-in-out;
}
.img {
  height: 30%;
  position: absolute;
  transition: 0.2s ease-in-out;
  z-index: 1;
}
.textBox {
  opacity: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 15px;
  transition: 0.2s ease-in-out;
  z-index: 2;
}
.textBox > .text {
  font-weight: bold;
}
.textBox > .head {
  font-size: 20px;
}
.textBox > .price {
  font-size: 17px;
}
.textBox > span {
  font-size: 12px;
  color: lightgrey;
}
.card > .textBox {
  opacity: 1;
}
.card > .img {
  height: 65%;
  filter: blur(7px);
  animation: anim 3s infinite;
}
@keyframes anim {
  0% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-20px);
  }
  100% {
    transform: translateY(0);
  }
}
.card {
  transform: scale(1.04) rotate(-1deg);
}
</style>
</div>

{{< cards >}}
{{< card link="https://ethereum.org/zh/developers/docs/intro-to-ethereum/" title="以太坊开发文档" subtitle="本文档旨在帮助你构建以太坊。 它介绍了以太坊概念，解释了以太坊技术栈，并记录了以太坊更复杂的应用和使用案例的高级主题。" icon="arrow-narrow-right" >}}
{{< /cards >}}

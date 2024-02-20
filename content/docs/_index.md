---
title: 
date: 2024-02-18T14:30:52+08:00
draft: false
type: docs
---

<div>
<style>
    @keyframes stageBackground {
  0%, 10%, 90%, 100% {
    background-color: #00B6BB;
  }
  25%, 75% {
    background-color: #0094bd;
  }
}
@keyframes earthRotation {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
@keyframes sunrise {
  0%, 10%, 90%, 100% {
    box-shadow: 0 0 0 25px #5ad6bd, 0 0 0 40px #4acead, 0 0 0 60px rgba(74, 206, 173, 0.6), 0 0 0 90px rgba(74, 206, 173, 0.3);
  }
  25%, 75% {
    box-shadow: 0 0 0 0 #5ad6bd, 0 0 0 0 #4acead, 0 0 0 0 rgba(74, 206, 173, 0.6), 0 0 0 0 rgba(74, 206, 173, 0.3);
  }
}
@keyframes moonOrbit {
  25% {
    transform: rotate(-60deg);
  }
  50% {
    transform: rotate(-60deg);
  }
  75% {
    transform: rotate(-120deg);
  }
  0%, 100% {
    transform: rotate(-180deg);
  }
}
@keyframes nightTime {
  0%, 90% {
    opacity: 0;
  }
  50%, 75% {
    opacity: 1;
  }
}
@keyframes hotPan {
  0%, 90% {
    background-color: #74667e;
  }
  50%, 75% {
    background-color: #b2241c;
  }
}
@keyframes heat {
  0%, 90% {
    box-shadow: inset 0 0 0 0 rgba(255, 255, 255, 0.3);
  }
  50%, 75% {
    box-shadow: inset 0 -2px 0 0 white;
  }
}
@keyframes smoke {
  0%, 50%, 90%, 100% {
    opacity: 0;
  }
  50%, 75% {
    opacity: 0.7;
  }
}
@keyframes fire {
  0%, 90%, 100% {
    opacity: 0;
  }
  50%, 75% {
    opacity: 1;
  }
}
@keyframes treeShake {
  0% {
    transform: rotate(0deg);
  }
  25% {
    transform: rotate(-2deg);
  }
  40% {
    transform: rotate(4deg);
  }
  50% {
    transform: rotate(-4deg);
  }
  60% {
    transform: rotate(6deg);
  }
  75% {
    transform: rotate(-6deg);
  }
  100% {
    transform: rotate(0deg);
  }
}
@keyframes fireParticles {
  0% {
    height: 30%;
    opacity: 1;
    top: 75%;
  }
  25% {
    height: 25%;
    opacity: 0.8;
    top: 40%;
  }
  50% {
    height: 15%;
    opacity: 0.6;
    top: 20%;
  }
  75% {
    height: 10%;
    opacity: 0.3;
    top: 0;
  }
  100% {
    opacity: 0;
  }
}
@keyframes fireLines {
  0%, 25%, 75%, 100% {
    bottom: 0;
  }
  50% {
    bottom: 5%;
  }
}
.scene {
  display: flex;
  margin: 0 auto 80px auto;
  justify-content: center;
  align-items: flex-end;
  width: 400px;
  height: 300px;
  position: relative;
}
.forest {
  display: flex;
  width: 75%;
  height: 90%;
  position: relative;
}
.tree {
  display: block;
  width: 50%;
  position: absolute;
  bottom: 0;
  opacity: 0.4;
}
.tree .branch {
  width: 80%;
  height: 0;
  margin: 0 auto;
  padding-left: 40%;
  padding-bottom: 50%;
  overflow: hidden;
}
.tree .branch:before {
  content: "";
  display: block;
  width: 0;
  height: 0;
  margin-left: -600px;
  border-left: 600px solid transparent;
  border-right: 600px solid transparent;
  border-bottom: 950px solid #000;
}
.tree .branch.branch-top {
  transform-origin: 50% 100%;
  animation: treeShake 0.5s linear infinite;
}
.tree .branch.branch-middle {
  width: 90%;
  padding-left: 45%;
  padding-bottom: 65%;
  margin: 0 auto;
  margin-top: -25%;
}
.tree .branch.branch-bottom {
  width: 100%;
  padding-left: 50%;
  padding-bottom: 80%;
  margin: 0 auto;
  margin-top: -40%;
}
.tree1 {
  width: 31%;
}
.tree1 .branch-top {
  transition-delay: 0.3s;
}
.tree2 {
  width: 39%;
  left: 9%;
}
.tree2 .branch-top {
  transition-delay: 0.4s;
}
.tree3 {
  width: 32%;
  left: 24%;
}
.tree3 .branch-top {
  transition-delay: 0.5s;
}
.tree4 {
  width: 37%;
  left: 34%;
}
.tree4 .branch-top {
  transition-delay: 0.6s;
}
.tree5 {
  width: 44%;
  left: 44%;
}
.tree5 .branch-top {
  transition-delay: 0.7s;
}
.tree6 {
  width: 34%;
  left: 61%;
}
.tree6 .branch-top {
  transition-delay: 0.2s;
}
.tree7 {
  width: 24%;
  left: 76%;
}
.tree7 .branch-top {
  transition-delay: 0.1s;
}
.tent {
  width: 60%;
  height: 25%;
  position: absolute;
  bottom: -0.5%;
  right: 15%;
  z-index: 1;
  text-align: right;
}
.roof {
  display: inline-block;
  width: 45%;
  height: 100%;
  margin-right: 10%;
  position: relative;
  /*bottom: 0;
  right: 9%;*/
  z-index: 1;
  border-top: 4px solid #4D4454;
  border-right: 4px solid #4D4454;
  border-left: 4px solid #4D4454;
  border-top-right-radius: 6px;
  transform: skew(30deg);
  box-shadow: inset -3px 3px 0px 0px #F7B563;
  /*background: linear-gradient(
    to bottom, 
    rgba(246,212,132,1) 0%,
    rgba(246,212,132,1) 24%,
    rgba(#F0B656,1) 25%,
    rgba(#F0B656,1) 74%,
    rgba(235,151,53,1) 75%,
    rgba(235,151,53,1) 100%
  );*/
  background: #f6d484;
}
.roof:before {
  content: "";
  width: 70%;
  height: 70%;
  position: absolute;
  top: 15%;
  left: 15%;
  z-index: 0;
  border-radius: 10%;
  background-color: #E78C20;
}
.roof:after {
  content: "";
  height: 75%;
  width: 100%;
  position: absolute;
  bottom: 0;
  right: 0;
  z-index: 1;
  background: linear-gradient(to bottom, rgba(231, 140, 32, 0.4) 0%, rgba(231, 140, 32, 0.4) 64%, rgba(231, 140, 32, 0.8) 65%, rgba(231, 140, 32, 0.8) 100%);
}
.roof-border-left {
  display: flex;
  justify-content: space-between;
  flex-direction: column;
  width: 1%;
  height: 125%;
  position: absolute;
  top: 0;
  left: 35.7%;
  z-index: 1;
  transform-origin: 50% 0%;
  transform: rotate(35deg);
}
.roof-border-left .roof-border {
  display: block;
  width: 100%;
  border-radius: 2px;
  border: 2px solid #4D4454;
}
.roof-border-left .roof-border1 {
  height: 40%;
}
.roof-border-left .roof-border2 {
  height: 10%;
}
.roof-border-left .roof-border3 {
  height: 40%;
}
.door {
  width: 55px;
  height: 92px;
  position: absolute;
  bottom: 2%;
  overflow: hidden;
  z-index: 0;
  transform-origin: 0 105%;
}
.left-door {
  transform: rotate(35deg);
  position: absolute;
  left: 13.5%;
  bottom: -3%;
  z-index: 0;
}
.left-door .left-door-inner {
  width: 100%;
  height: 100%;
  transform-origin: 0 105%;
  transform: rotate(-35deg);
  position: absolute;
  top: 0;
  overflow: hidden;
  background-color: #EDDDC2;
}
.left-door .left-door-inner:before {
  content: "";
  width: 15%;
  height: 100%;
  position: absolute;
  top: 0;
  right: 0;
  background: repeating-linear-gradient(#D4BC8B, #D4BC8B 4%, #E0D2A8 5%, #E0D2A8 10%);
}
.left-door .left-door-inner:after {
  content: "";
  width: 50%;
  height: 100%;
  position: absolute;
  top: 15%;
  left: 10%;
  transform: rotate(25deg);
  background-color: #fff;
}
.right-door {
  height: 89px;
  right: 21%;
  transform-origin: 0 105%;
  transform: rotate(-30deg) scaleX(-1);
  position: absolute;
  bottom: -3%;
  z-index: 0;
}
.right-door .right-door-inner {
  width: 100%;
  height: 100%;
  transform-origin: 0 120%;
  transform: rotate(-30deg);
  position: absolute;
  bottom: 0px;
  overflow: hidden;
  background-color: #EFE7CF;
}
.right-door .right-door-inner:before {
  content: "";
  width: 50%;
  height: 100%;
  position: absolute;
  top: 15%;
  right: -28%;
  z-index: 1;
  transform: rotate(15deg);
  background-color: #524A5A;
}
.right-door .right-door-inner:after {
  content: "";
  width: 50%;
  height: 100%;
  position: absolute;
  top: 15%;
  right: -20%;
  transform: rotate(20deg);
  background-color: #fff;
}
.floor {
  width: 80%;
  position: absolute;
  right: 10%;
  bottom: 0;
  z-index: 1;
}
.floor .ground {
  position: absolute;
  border-radius: 2px;
  border: 2px solid #4D4454;
}
.floor .ground.ground1 {
  width: 65%;
  left: 0;
}
.floor .ground.ground2 {
  width: 30%;
  right: 0;
}
.fireplace {
  display: block;
  width: 24%;
  height: 20%;
  position: absolute;
  left: 5%;
}
.fireplace:before {
  content: "";
  display: block;
  width: 8%;
  position: absolute;
  bottom: -4px;
  left: 2%;
  border-radius: 2px;
  border: 2px solid #4D4454;
  background: #4D4454;
}
.fireplace .support {
  display: block;
  height: 105%;
  width: 2px;
  position: absolute;
  bottom: -5%;
  left: 10%;
  border: 2px solid #4D4454;
}
.fireplace .support:before {
  content: "";
  width: 100%;
  height: 15%;
  position: absolute;
  top: -18%;
  left: -4px;
  border-radius: 2px;
  border: 2px solid #4D4454;
  transform-origin: 100% 100%;
  transform: rotate(45deg);
}
.fireplace .support:after {
  content: "";
  width: 100%;
  height: 15%;
  position: absolute;
  top: -18%;
  left: 0px;
  border-radius: 2px;
  border: 2px solid #4D4454;
  transform-origin: 0 100%;
  transform: rotate(-45deg);
}
.fireplace .support:nth-child(1) {
  left: 85%;
}
.fireplace .bar {
  width: 100%;
  height: 2px;
  border-radius: 2px;
  border: 2px solid #4D4454;
}
.fireplace .hanger {
  display: block;
  width: 2px;
  height: 25%;
  margin-left: -4px;
  position: absolute;
  left: 50%;
  border: 2px solid #4D4454;
}
.fireplace .pan {
  display: block;
  width: 25%;
  height: 50%;
  border-radius: 50%;
  border: 4px solid #4D4454;
  position: absolute;
  top: 25%;
  left: 35%;
  overflow: hidden;
  animation: heat 5s linear infinite;
}
.fireplace .pan:before {
  content: "";
  display: block;
  height: 53%;
  width: 100%;
  position: absolute;
  bottom: 0;
  z-index: -1;
  border-top: 4px solid #4D4454;
  background-color: #74667e;
  animation: hotPan 5s linear infinite;
}
.fireplace .smoke {
  display: block;
  width: 20%;
  height: 25%;
  position: absolute;
  top: 25%;
  left: 37%;
  background-color: white;
  filter: blur(5px);
  animation: smoke 5s linear infinite;
}
.fireplace .fire {
  display: block;
  width: 25%;
  height: 120%;
  position: absolute;
  bottom: 0;
  left: 33%;
  z-index: 1;
  animation: fire 5s linear infinite;
}
.fireplace .fire:before {
  content: "";
  display: block;
  width: 100%;
  height: 2px;
  position: absolute;
  bottom: -4px;
  z-index: 1;
  border-radius: 2px;
  border: 1px solid #efb54a;
  background-color: #efb54a;
}
.fireplace .fire .line {
  display: block;
  width: 2px;
  height: 100%;
  position: absolute;
  bottom: 0;
  animation: fireLines 1s linear infinite;
}
.fireplace .fire .line2 {
  left: 50%;
  margin-left: -1px;
  animation-delay: 0.3s;
}
.fireplace .fire .line3 {
  right: 0;
  animation-delay: 0.5s;
}
.fireplace .fire .line .particle {
  height: 10%;
  position: absolute;
  top: 100%;
  z-index: 1;
  border-radius: 2px;
  border: 2px solid #efb54a;
  animation: fireParticles 0.5s linear infinite;
}
.fireplace .fire .line .particle1 {
  animation-delay: 0.1s;
}
.fireplace .fire .line .particle2 {
  animation-delay: 0.3s;
}
.fireplace .fire .line .particle3 {
  animation-delay: 0.6s;
}
.fireplace .fire .line .particle4 {
  animation-delay: 0.9s;
}
.time-wrapper {
  display: block;
  width: 100%;
  height: 100%;
  position: absolute;
  overflow: hidden;
}
.time {
  display: block;
  width: 100%;
  height: 200%;
  position: absolute;
  transform-origin: 50% 50%;
  transform: rotate(270deg);
  animation: earthRotation 5s linear infinite;
}
.time .day {
  display: block;
  width: 20px;
  height: 20px;
  position: absolute;
  top: 20%;
  left: 40%;
  border-radius: 50%;
  box-shadow: 0 0 0 25px #5ad6bd, 0 0 0 40px #4acead, 0 0 0 60px rgba(74, 206, 173, 0.6), 0 0 0 90px rgba(74, 206, 173, 0.3);
  animation: sunrise 5s ease-in-out infinite;
  background-color: #ef9431;
}
.time .night {
  animation: nightTime 5s ease-in-out infinite;
}
.time .night .star {
  display: block;
  width: 4px;
  height: 4px;
  position: absolute;
  bottom: 10%;
  border-radius: 50%;
  background-color: #fff;
}
.time .night .star-big {
  width: 6px;
  height: 6px;
}
.time .night .star1 {
  right: 23%;
  bottom: 25%;
}
.time .night .star2 {
  right: 35%;
  bottom: 18%;
}
.time .night .star3 {
  right: 47%;
  bottom: 25%;
}
.time .night .star4 {
  right: 22%;
  bottom: 20%;
}
.time .night .star5 {
  right: 18%;
  bottom: 30%;
}
.time .night .star6 {
  right: 60%;
  bottom: 20%;
}
.time .night .star7 {
  right: 70%;
  bottom: 23%;
}
.time .night .moon {
  display: block;
  width: 25px;
  height: 25px;
  position: absolute;
  bottom: 22%;
  right: 33%;
  border-radius: 50%;
  transform: rotate(-60deg);
  box-shadow: 9px 9px 3px 0 white;
  filter: blur(1px);
  animation: moonOrbit 5s ease-in-out infinite;
}
.time .night .moon:before {
  content: "";
  display: block;
  width: 100%;
  height: 100%;
  position: absolute;
  bottom: -9px;
  left: 9px;
  border-radius: 50%;
  box-shadow: 0 0 0 5px rgba(255, 255, 255, 0.05), 0 0 0 15px rgba(255, 255, 255, 0.05), 0 0 0 25px rgba(255, 255, 255, 0.05), 0 0 0 35px rgba(255, 255, 255, 0.05);
  background-color: rgba(255, 255, 255, 0.2);
}
</style>
<div class="scene">
  <div class="forest">
    <div class="tree tree1">
      <div class="branch branch-top"></div>
      <div class="branch branch-middle"></div>
    </div>
    <div class="tree tree2">
      <div class="branch branch-top"></div>
      <div class="branch branch-middle"></div>
      <div class="branch branch-bottom"></div>
    </div>
    <div class="tree tree3">
      <div class="branch branch-top"></div>
      <div class="branch branch-middle"></div>
      <div class="branch branch-bottom"></div>
    </div>
    <div class="tree tree4">
      <div class="branch branch-top"></div>
      <div class="branch branch-middle"></div>
      <div class="branch branch-bottom"></div>
    </div>
    <div class="tree tree5">
      <div class="branch branch-top"></div>
      <div class="branch branch-middle"></div>
      <div class="branch branch-bottom"></div>
    </div>
    <div class="tree tree6">
      <div class="branch branch-top"></div>
      <div class="branch branch-middle"></div>
      <div class="branch branch-bottom"></div>
    </div>
    <div class="tree tree7">
      <div class="branch branch-top"></div>
      <div class="branch branch-middle"></div>
      <div class="branch branch-bottom"></div>
    </div>
  </div>
  <div class="tent">
      <div class="roof"></div>
      <div class="roof-border-left">
        <div class="roof-border roof-border1"></div>
        <div class="roof-border roof-border2"></div>
        <div class="roof-border roof-border3"></div>
      </div>
      <div class="entrance">
        <div class="door left-door">
          <div class="left-door-inner"></div>
        </div>
        <div class="door right-door">
          <div class="right-door-inner"></div>
        </div>
      </div>
    </div>
  <div class="floor">
      <div class="ground ground1"></div>
      <div class="ground ground2"></div>
    </div>
  <div class="fireplace">
    <div class="support"></div>
    <div class="support"></div>
    <div class="bar"></div>
    <div class="hanger"></div>
    <div class="smoke"></div>
    <div class="pan"></div>
    <div class="fire">
      <div class="line line1">
        <div class="particle particle1"></div>
        <div class="particle particle2"></div>
        <div class="particle particle3"></div>
        <div class="particle particle4"></div>
      </div>
      <div class="line line2">
        <div class="particle particle1"></div>
        <div class="particle particle2"></div>
        <div class="particle particle3"></div>
        <div class="particle particle4"></div>
      </div>
      <div class="line line3">
        <div class="particle particle1"></div>
        <div class="particle particle2"></div>
        <div class="particle particle3"></div>
        <div class="particle particle4"></div>
      </div>
    </div>
  </div>
  <div class="time-wrapper">
    <div class="time">
      <div class="day"></div>
      <div class="night">
        <div class="moon"></div>
        <div class="star star1 star-big"></div>
        <div class="star star2 star-big"></div>
        <div class="star star3 star-big"></div>
        <div class="star star4"></div>
        <div class="star star5"></div>
        <div class="star star6"></div>
        <div class="star star7"></div>
      </div>
    </div>
  </div>
</div>
</div>


{{< hextra/hero-subtitle >}}
  Everything you need to know for your Clever Cloud journey
{{< /hextra/hero-subtitle >}}

{{< cards >}}
  {{< card link="/doc/quickstart" title="Getting Started" subtitle="Get ready to deploy and app in 5 minutes" icon="arrow-circle-right" >}}
  {{< card link="../doc/develop" title="Develop" subtitle="Best practices on Cloud deployments, sheduling jobs, etc." icon="code" >}}
  {{< card link="../doc/administrate" title="Administrate" subtitle="Access metrics, logs, manage domains, set up scalability..." icon="library" >}}
  {{< card link="../doc/applications" title="Deploy" subtitle="Deploy any app on Clever Cloud." icon="arrow-circle-right" >}}
   {{< card link="../doc/addons" title="Connect an add-on" subtitle="Connect a managed database and set up cloud storage." icon="arrow-circle-right" >}}
  {{< card link="../doc/find-help" title="Find help" subtitle="Lost? See how to get help." icon="support" >}}
  {{< card link="../doc/extend" title="Extend" subtitle="Access Clever Cloud API, collect add-ons logs... " icon="puzzle" >}}
   {{< card link="../doc/cli" title="Clever Tools CLI" subtitle="Deploy and manage your applications and dependencies from your terminal." icon="arrow-circle-right" >}}
  {{< card link="../doc/reference" title="References" subtitle="List of environment variables your can use on Clever Clever Cloud, common configuration an all instances... " icon="collection" >}}
  {{< card link="../doc/account" title="User Account" subtitle="Set up your account, collaborate and manage permissions." icon="user-circle" >}}
  {{< card link="../doc/billing" title="Billing" subtitle="Find invoices, analyse consumption and understand pricing." icon="credit-card" >}}
  {{< card link="../doc/contribute" title="Contribute" subtitle="See how to contribute to this documentation." icon="pencil-alt" >}}
{{< /cards >}}

{{< hextra/hero-subtitle style="margin:20px 0">}}
  See our step by step tutorials
{{< /hextra/hero-subtitle >}}

{{< feature-grid >}}
  {{< feature-card
    title="Find your framework"
    subtitle="Deploy your favorite framework with our step by step guides."
    link="/guides"
    style="background: radial-gradient(ellipse at 50% 80%,rgba(203, 28, 66, 0.15),hsla(0,0%,100%,0));"
  >}}
  {{< feature-card
    title="Starter tutorials"
    subtitle="Make a starter app and deploy it on Clever Cloud."
    link="/guides/#starter-tutorials"
    style="background: radial-gradient(ellipse at 50% 80%,rgba(58, 56, 113, 0.15),hsla(0,0%,100%,0));"
  >}}
  {{< feature-card
    title="Add-ons guides"
    subtitle="Take your dependencies management to the next level."
    link="/guides/#level-up-your-add-ons"
    style="background: radial-gradient(ellipse at 50% 80%,rgba(165, 16, 80, 0.15),hsla(0,0%,100%,0));"
  >}}
  
{{< /feature-grid >}}
---
title: 数学公式
date: 2024-06-25T12:17:25+08:00
tags: [mathematics]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
description: Mathematics
params:
  math: true
---

## 1.展示
### 1.1 行内公式
\(a^*=x-b^*\)

\(\Large\varsigma_2\)

\(H_s\)

\(P(H)_{H_s}\)

\( H^{'}_{i} \)

### 1.2 块级公式

$$
D(H)=
\begin{cases}
D_0, & \text {if }H_i = 0 \\
max(D_0,P(H)_{H_d}+x\times\varsigma_2)+\large\epsilon, &\text {otherwise}
\end{cases}
$$

$$
\large x\equiv {\bigg\lfloor} \large\frac{P(H)_{H_d}}{2048} {\bigg\rfloor}
$$

$$
\varsigma_2 \equiv max\bigg(y-\bigg\lfloor \frac{H_s-P(H)_{H_s}}{9} \bigg\rfloor, -99 \bigg)
$$

$$
y-\bigg\lfloor \frac{H_s-P(H)_{H_s}}{9} \bigg\rfloor
$$

$$
\huge H_{i}^{'} \equiv max(H_i - 3000000,0)
$$

$$
\begin{aligned}
KL(\hat{y} || y) &= \sum_{c=1}^{M}\hat{y}_c \log{\frac{\hat{y}_c}{y_c}} \\
JS(\hat{y} || y) &= \frac{1}{2}(KL(y||\frac{y+\hat{y}}{2}) + KL(\hat{y}||\frac{y+\hat{y}}{2}))
\end{aligned}
$$

## 2.语法
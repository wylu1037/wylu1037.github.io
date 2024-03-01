---
title: "🌱 Arm64 Aarch64 Amd64 x86_64: What's the Difference?"
date: 2024-03-01T20:05:09+08:00
categories: new
tags: [arm64, aarch64, amd64, x86_64, linux]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
---

{{< tabs items="🍋 arm64 & 🍓 aarch64, 🫐 amd64 & 🍑 x86_64">}}
  {{< tab >}}
    ARM处理器实现的是精简指令集计算机（Reduced Instruction Set Computer，RISC）架构。

    <font style="background: linear-gradient(45deg, #ff8a00, #e52e71);font-weight: bolder;background-clip: text;color: transparent;">`AArch64` and `ARM64` refer to the same thing.</font>
    

    **AArch64** is the 64-bit state introduced in the Armv8-A architecture. The 32-bit state which is backwards compatible with Armv7-A and previous 32-bit Arm architectures is referred to as AArch32. Therefore the GNU triplet for the 64-bit ISA is aarch64. 
    <u>The Linux kernel community chose to call their port of the kernel to this architecture arm64 rather than aarch64, so that's where some of the arm64 usage comes from.</u>

    The Apple-developed backend for AArch64 was called `ARM64` whereas the LLVM community-developed backend was called `AArch64` (as it is the canonical name for the 64-bit ISA). The two were merged in 2014 and the backend now is called `AArch64`.
  {{< /tab >}}

  {{< tab >}}
    <font style="background: linear-gradient(45deg, #ff8a00, #e52e71);font-weight: bolder;background-clip: text;color: transparent;">They are the same.</font>

    **AMD** was the first to create 64-bit extensions to the x86 instruction set. (Intel at the moment decided to go a different path, developing IA64 with HP, practically co-opting HP’s PA-RISC CPUs to become Itanium CPUs).

    The Open Source community appreciates AMD’s breakthrough and decided to give the code name of “amd64” to the extensions (to prevent confusion with Intel’s 64-bit instruction set `ia64`).

    Intel naturally doesn’t like this situation and ‘gently’ ‘suggested’ an alternative, more vendor-neutral moniker of `x86_64`. Some Open Source community took the bait and changed the moniker. Others don’t see the need to change and keep using the `amd64` moniker.

    But for all practical purposes with no exceptions, the two monikers — `x86_64` and `amd64` — are exactly the same.
  {{< /tab >}}
{{< /tabs >}}


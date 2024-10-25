---
title: screen命令
date: 2024-06-05T09:15:53+08:00
categories: [linux]
tags: [screen, daemon, linux]
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
description: screen command
excludeSearch: true
---

## Syntax
```shell
screen [-opts] [cmd [args]]
```

## Options

+ -a: It force all capabilities into each window’s termcap.
+ -A -[r|R]: It adapt all windows to the new display width & height.
+ -c file: It read configuration file instead of ‘.screenrc’.
+ -d (-r): It detach the elsewhere running screen (and reattach here).
+ -dmS name: It start as daemon: Screen session in detached mode.
+ -D (-r): It detach and logout remote (and reattach here).
+ -D -RR: It do whatever is needed to get a screen session.
+ -e xy: It change the command characters.
+ -f: It make the flow control on, -fn = off, -fa = auto.
+ -h lines: It set the size of the scrollback history buffer.
+ -i: It interrupt output sooner when flow control is on.
+ -l: It make the login mode on (update /var/run/utmp), -ln = off.
+ -ls [match]: It display all the attached screens.
+ -L: It turn on output logging.
+ -m: It ignore $STY variable, do create a new screen session.
+ -O: It choose optimal output rather than exact vt100 emulation.
+ -p window: It preselect the named window if it exists.
+ -q: It quiet startup. Exits with non-zero return code if unsuccessful.
+ -Q: It commands will send the response to the stdout of the querying process.
+ -r [session]: It reattach to a detached screen process.
+ {{< font "blue" "-R: It reattach if possible, otherwise start a new session." >}}
+ {{< font "blue" "-S sockname: It name this session .sockname instead of …" >}}
+ -t title: It set title. (window’s name).
+ -T term: It use term as $TERM for windows, rather than “screen”.
+ -U: It tell screen to use UTF-8 encoding.
+ -v: It print “Screen version 4.06.02 (GNU) 23-Oct-17”.
+ -x: It attach to a not detached screen. (Multi display mode).
+ {{< font "blue" "-X: It execute as a screen command in the specified session." >}}

## Example
创建或重新连接会话
```shell
screen -S go_backend_session
```

停止
```shell
screen -X -S go_backend_session quit
```

回到指定的会话
```shell
screen -R go_backend_session
```

退出会话
```shell
ctrl A
ctrl D
```
---
title: 递归
date: 2024-03-24T16:09:04+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 3
---

## 所有字符编码

{{< tabs items="🧑‍🏫 Q,🧑‍🎓 A" >}}
{{< tab >}}
有一种将字母编码成数字的方式：`a->1`, `b->2`, ... , `z->26`。现在给一串数字（数字长度不超过20），请返回所有可能的译码结果，比如：

+ 输入：`"11"`，返回值：`"aa"、"k"`；
+ 输入：`"113"`，返回值：`"aac"、"kc"、"am"`。
{{< /tab >}}

{{< tab >}}
```go
func recursive(str string) []string {
	// 递归的终止条件
	if len(str) == 0 {
		return []string{""}
	}

	// 考虑是选择一个字符
	res := make([]string, 0)
	first, _ := strconv.Atoi(str[:1])
	for _, v := range recursive(str[1:]) {
		res = append(res, string(rune('a'+first-1))+v)
	}

	// 选择两个字符
	if len(str) > 1 {
		two, _ := strconv.Atoi(str[:2])
		if two > 0 && two <= 26 {
			for _, v := range recursive(str[2:]) {
				res = append(res, string(rune('a'+two-1))+v)
			}
		}
	}

	return res
}
```
{{< /tab >}}

{{< /tabs >}}


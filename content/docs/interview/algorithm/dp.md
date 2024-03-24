---
title: 动态规划
date: 2024-03-24T11:27:47+08:00
authors:
  - name: wylu
    link: https://github.com/wylu1037
    image: https://github.com/wylu1037.png?size=40
weight: 2
---

## 收割地块最大收益


{{< tabs items="🧑‍🏫 Q,🧑‍🎓 A" >}}
{{< tab >}}
一台收割机收割给不同地块收割获得的钱不同，同时耗费的油量也不同，以下是6 个地块的耗油量和收益的列表`[(1, 1), (7, 9), (6, 10), (2, 4), (3, 5), (6, 10)]`，请问收割机在给定油量 n=10 （n≥1）的情况下，如何尽可能赚到更多的钱？
{{< callout >}}
提示：

+ 使用动态规划，从第一个地块开始计算油量 dp[1]获得最多收益，再一次计算油量dp[n]的最多收益。
+ 上述答案为 16 。
{{< /callout>}}
{{< /tab >}}

{{< tab >}}
```go
func main() {
	fuel := []int{1, 7, 6, 2, 3, 6}
	profit := []int{1, 9, 10, 4, 5, 10}
	total := 10

	maxProfit := dp(fuel, profit, total)
	fmt.Println(maxProfit)
}

func dp(fuel, profit []int, total int) int {
	// 首先初始化一个二维数组
	dp := make([][]int, len(fuel)+1)
	for i := range dp {
		dp[i] = make([]int, total+1)
	}

	// 状态转移方程
	for i := 1; i <= len(fuel); i++ {
		for j := 1; j <= total; j++ {
			// 不选择收割当前地块
			noChoose := dp[i-1][j]

			// 选择收割当前地块
			choose := 0
			if j >= fuel[i-1] {
				choose = profit[i-1] + dp[i-1][j-fuel[i-1]]
			}

			dp[i][j] = max(noChoose, choose)
		}
	}
	return dp[len(fuel)][total]
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
```
{{< /tab >}}

{{< /tabs >}}

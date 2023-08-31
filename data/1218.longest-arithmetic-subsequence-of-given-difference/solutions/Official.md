## [1218.最长定差子序列 中文官方题解](https://leetcode.cn/problems/longest-arithmetic-subsequence-of-given-difference/solutions/100000/zui-chang-ding-chai-zi-xu-lie-by-leetcod-xkua)

#### 方法一：动态规划

下文为方便叙述将 $\textit{difference}$ 简写成 $d$。

我们从左往右遍历 $\textit{arr}$，并计算出以 $\textit{arr}[i]$ 为结尾的最长的等差子序列的长度，取所有长度的最大值，即为答案。

令 $\textit{dp}[i]$ 表示以 $\textit{arr}[i]$ 为结尾的最长的等差子序列的长度，我们可以在 $\textit{arr}[i]$ 左侧找到满足 $\textit{arr}[j]=\textit{arr}[i]-d$ 的元素，将 $\textit{arr}[i]$ 加到以 $\textit{arr}[j]$ 为结尾的最长的等差子序列的末尾，这样可以递推地从 $dp[j]$ 计算出 $dp[i]$。由于我们是从左往右遍历 $\textit{arr}$ 的，对于两个**相同**的元素，下标较大的元素对应的 $\textit{dp}$ 值不会小于下标较小的元素对应的 $\textit{dp}$ 值，因此下标 $j$ 可以取满足 $j<i$ 且 $\textit{arr}[j]=\textit{arr}[i]-d$ 的所有下标的最大值。故有转移方程

$$
\textit{dp}[i] = \textit{dp}[j] + 1
$$

由于我们总是在左侧找一个最近的等于 $\textit{arr}[i]-d$ 元素并取其对应 $\textit{dp}$ 值，因此我们直接用 $\textit{dp}[v]$ 表示以 $v$ 为结尾的最长的等差子序列的长度，这样 $\textit{dp}[v-d]$ 就是我们要找的左侧元素对应的最长的等差子序列的长度，因此转移方程可以改为

$$
\textit{dp}[v] = \textit{dp}[v-d] + 1
$$

最后答案为 $\max\{\textit{dp}\}$。

```Python [sol1-Python3]
class Solution:
    def longestSubsequence(self, arr: List[int], difference: int) -> int:
        dp = defaultdict(int)
        for v in arr:
            dp[v] = dp[v - difference] + 1
        return max(dp.values())
```

```C++ [sol1-C++]
class Solution {
public:
    int longestSubsequence(vector<int> &arr, int difference) {
        int ans = 0;
        unordered_map<int, int> dp;
        for (int v: arr) {
            dp[v] = dp[v - difference] + 1;
            ans = max(ans, dp[v]);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int longestSubsequence(int[] arr, int difference) {
        int ans = 0;
        Map<Integer, Integer> dp = new HashMap<Integer, Integer>();
        for (int v : arr) {
            dp.put(v, dp.getOrDefault(v - difference, 0) + 1);
            ans = Math.max(ans, dp.get(v));
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LongestSubsequence(int[] arr, int difference) {
        int ans = 0;
        Dictionary<int, int> dp = new Dictionary<int, int>();
        foreach (int v in arr) {
            int prev = dp.ContainsKey(v - difference) ? dp[v - difference] : 0;
            if (dp.ContainsKey(v)) {
                dp[v] = prev + 1;
            } else {
                dp.Add(v, prev + 1);
            }
            ans = Math.Max(ans, dp[v]);
        }
        return ans;
    }
}
```

```go [sol1-Golang]
func longestSubsequence(arr []int, difference int) (ans int) {
    dp := map[int]int{}
    for _, v := range arr {
        dp[v] = dp[v-difference] + 1
        if dp[v] > ans {
            ans = dp[v]
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var longestSubsequence = function(arr, difference) {
    let ans = 0;
    const dp = new Map();
    for (const v of arr) {
        dp.set(v, (dp.get(v - difference) || 0) + 1);
        ans = Math.max(ans, dp.get(v));
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{arr}$ 的长度。

- 空间复杂度：$O(n)$。哈希表需要 $O(n)$ 的空间。
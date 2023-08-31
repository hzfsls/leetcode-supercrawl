## [1035.不相交的线 中文官方题解](https://leetcode.cn/problems/uncrossed-lines/solutions/100000/bu-xiang-jiao-de-xian-by-leetcode-soluti-6tqz)
#### 方法一：动态规划

给定两个数组 $\textit{nums}_1$ 和 $\textit{nums}_2$，当 $\textit{nums}_1[i]=\textit{nums}_2[j]$ 时，可以用一条直线连接 $\textit{nums}_1[i]$ 和 $\textit{nums}_2[j]$。假设一共绘制了 $k$ 条互不相交的直线，其中第 $x$ 条直线连接 $\textit{nums}_1[i_x]$ 和 $\textit{nums}_2[j_x]$，则对于任意 $1 \le x \le k$ 都有 $\textit{nums}_1[i_x]=\textit{nums}_2[j_x]$，其中 $i_1<i_2<\ldots<i_k$，$j_1<j_2<\ldots<j_k$。

上述 $k$ 条互不相交的直线分别连接了数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的 $k$ 对相等的元素，而且这 $k$ 对相等的元素在两个数组中的相对顺序是一致的，因此，这 $k$ 对相等的元素组成的序列即为数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的公共子序列。要计算可以绘制的最大连线数，即为计算数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的最长公共子序列的长度。最长公共子序列问题是典型的二维动态规划问题。

假设数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度分别为 $m$ 和 $n$，创建 $m+1$ 行 $n+1$ 列的二维数组 $\textit{dp}$，其中 $\textit{dp}[i][j]$ 表示 $\textit{nums}_1[0:i]$ 和 $\textit{nums}_2[0:j]$ 的最长公共子序列的长度。

> 上述表示中，$\textit{nums}_1[0:i]$ 表示数组 $\textit{nums}_1$ 的长度为 $i$ 的前缀，$\textit{nums}_2[0:j]$ 表示数组 $\textit{nums}_2$ 的长度为 $j$ 的前缀。

考虑动态规划的边界情况：

- 当 $i=0$ 时，$\textit{nums}_1[0:i]$ 为空，空数组和任何数组的最长公共子序列的长度都是 $0$，因此对任意 $0 \le j \le n$，有 $\textit{dp}[0][j]=0$；

- 当 $j=0$ 时，$\textit{nums}_2[0:j]$ 为空，同理可得，对任意 $0 \le i \le m$，有 $\textit{dp}[i][0]=0$。

因此动态规划的边界情况是：当 $i=0$ 或 $j=0$ 时，$\textit{dp}[i][j]=0$。

当 $i>0$ 且 $j>0$ 时，考虑 $\textit{dp}[i][j]$ 的计算：

- 当 $\textit{nums}_1[i-1]=\textit{nums}_2[j-1]$ 时，将这两个相同的元素称为公共元素，考虑 $\textit{nums}_1[0:i-1]$ 和 $\textit{nums}_2[0:j-1]$ 的最长公共子序列，再增加一个元素（即公共元素）即可得到 $\textit{nums}_1[0:i]$ 和 $\textit{nums}_2[0:j]$ 的最长公共子序列，因此 $\textit{dp}[i][j]=\textit{dp}[i-1][j-1]+1$。

- 当 $\textit{nums}_1[i-1] \ne \textit{nums}_2[j-1]$ 时，考虑以下两项：

   - $\textit{nums}_1[0:i-1]$ 和 $\textit{nums}_2[0:j]$ 的最长公共子序列；

   - $\textit{nums}_1[0:i]$ 和 $\textit{nums}_2[0:j-1]$ 的最长公共子序列。

   要得到 $\textit{nums}_1[0:i]$ 和 $\textit{nums}_2[0:j]$ 的最长公共子序列，应取两项中的长度较大的一项，因此 $\textit{dp}[i][j]=\max(\textit{dp}[i-1][j],\textit{dp}[i][j-1])$。

由此可以得到如下状态转移方程：

$$
\textit{dp}[i][j] = \begin{cases}
\textit{dp}[i-1][j-1]+1, & \textit{nums}_1[i-1]=\textit{nums}_2[j-1] \\
\max(\textit{dp}[i-1][j],\textit{dp}[i][j-1]), & \textit{nums}_1[i-1] \ne \textit{nums}_2[j-1]
\end{cases}
$$

最终计算得到 $\textit{dp}[m][n]$ 即为数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的最长公共子序列的长度，即可以绘制的最大连线数。

![fig1](https://assets.leetcode-cn.com/solution-static/1035/1.png){:width="80%"}

```Java [sol1-Java]
class Solution {
    public int maxUncrossedLines(int[] nums1, int[] nums2) {
        int m = nums1.length, n = nums2.length;
        int[][] dp = new int[m + 1][n + 1];
        for (int i = 1; i <= m; i++) {
            int num1 = nums1[i - 1];
            for (int j = 1; j <= n; j++) {
                int num2 = nums2[j - 1];
                if (num1 == num2) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[m][n];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxUncrossedLines(int[] nums1, int[] nums2) {
        int m = nums1.Length, n = nums2.Length;
        int[,] dp = new int[m + 1, n + 1];
        for (int i = 1; i <= m; i++) {
            int num1 = nums1[i - 1];
            for (int j = 1; j <= n; j++) {
                int num2 = nums2[j - 1];
                if (num1 == num2) {
                    dp[i, j] = dp[i - 1, j - 1] + 1;
                } else {
                    dp[i, j] = Math.Max(dp[i - 1, j], dp[i, j - 1]);
                }
            }
        }
        return dp[m, n];
    }
}
```

```JavaScript [sol1-JavaScript]
var maxUncrossedLines = function(nums1, nums2) {
    const m = nums1.length, n = nums2.length;
    const dp = new Array(m + 1).fill(0).map(() => new Array(n + 1).fill(0));
    for (let i = 1; i <= m; i++) {
        const num1 = nums1[i - 1];
        for (let j = 1; j <= n; j++) {
            const num2 = nums2[j - 1];
            if (num1 === num2) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }
    return dp[m][n];
};
```

```go [sol1-Golang]
func maxUncrossedLines(nums1, nums2 []int) int {
    m, n := len(nums1), len(nums2)
    dp := make([][]int, m+1)
    for i := range dp {
        dp[i] = make([]int, n+1)
    }
    for i, v := range nums1 {
        for j, w := range nums2 {
            if v == w {
                dp[i+1][j+1] = dp[i][j] + 1
            } else {
                dp[i+1][j+1] = max(dp[i][j+1], dp[i+1][j])
            }
        }
    }
    return dp[m][n]
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol1-Python3]
class Solution:
    def maxUncrossedLines(self, nums1: List[int], nums2: List[int]) -> int:
        m, n = len(nums1), len(nums2)
        dp = [[0] * (n + 1) for _ in range(m + 1)]

        for i, num1 in enumerate(nums1):
            for j, num2 in enumerate(nums2):
                if num1 == num2:
                    dp[i + 1][j + 1] = dp[i][j] + 1
                else:
                    dp[i + 1][j + 1] = max(dp[i][j + 1], dp[i + 1][j])
        
        return dp[m][n]
```

```C++ [sol1-C++]
class Solution {
public:
    int maxUncrossedLines(vector<int>& nums1, vector<int>& nums2) {
        int m = nums1.size(), n = nums2.size();
        vector<vector<int>> dp(m + 1, vector<int>(n + 1));
        for (int i = 1; i <= m; i++) {
            int num1 = nums1[i - 1];
            for (int j = 1; j <= n; j++) {
                int num2 = nums2[j - 1];
                if (num1 == num2) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[m][n];
    }
};
```

```C [sol1-C]
int maxUncrossedLines(int* nums1, int nums1Size, int* nums2, int nums2Size) {
    int m = nums1Size, n = nums2Size;
    int dp[m + 1][n + 1];
    memset(dp, 0, sizeof(dp));
    for (int i = 1; i <= m; i++) {
        int num1 = nums1[i - 1];
        for (int j = 1; j <= n; j++) {
            int num2 = nums2[j - 1];
            if (num1 == num2) {
                dp[i][j] = dp[i - 1][j - 1] + 1;
            } else {
                dp[i][j] = fmax(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }
    return dp[m][n];
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度。二维数组 $\textit{dp}$ 有 $m+1$ 行和 $n+1$ 列，需要对 $\textit{dp}$ 中的每个元素进行计算。

- 空间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是数组 $\textit{nums}_1$ 和 $\textit{nums}_2$ 的长度。创建了 $m+1$ 行 $n+1$ 列的二维数组 $\textit{dp}$。


---
## ✨扣友帮帮团 - 互动答疑

[![讨论.jpg](https://pic.leetcode-cn.com/1621178600-MKHFrl-%E8%AE%A8%E8%AE%BA.jpg){:width=260px}](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)


即日起 - 5 月 30 日，点击 [这里](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/) 前往「[扣友帮帮团](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)」活动页，把你遇到的问题大胆地提出来，让扣友为你解答～

### 🎁 奖励规则
被采纳数量排名 1～3 名：「力扣极客套装」 *1 并将获得「力扣神秘应援团」内测资格
被采纳数量排名 4～10 名：「力扣鼠标垫」 *1 并将获得「力扣神秘应援团」内测资格
「诲人不倦」：活动期间「解惑者」只要有 1 个回答被采纳，即可获得 20 LeetCoins 奖励！
「求知若渴」：活动期间「求知者」在活动页发起一次符合要求的疑问帖并至少采纳一次「解惑者」的回答，即可获得 20 LeetCoins 奖励！

活动详情猛戳链接了解更多：[🐞 你有 BUG 我来帮 - 力扣互动答疑季](https://leetcode-cn.com/circle/discuss/xtliW6/)
## [813.最大平均值和的分组 中文官方题解](https://leetcode.cn/problems/largest-sum-of-averages/solutions/100000/zui-da-ping-jun-zhi-he-de-fen-zu-by-leet-09xt)

#### 方法一：动态规划

命题：平均值和最大的分组的子数组数目必定是 $k$。

> 证明：假设一种分组的子数组数目小于 $k$，那么它必然有一个子数组的元素数目 $c > 1$，即仍然可以进行切分。设该子数组的平均值为 $m$，左侧第一个元素为 $x$，那么将该子数组第一个元素切分之后，平均值和为 $\dfrac{m \times c - x}{c - 1} + x = \dfrac{c}{c - 1} \times m + \dfrac{c-2}{c-1} \times x > m$，因此再次切分后平均值和会增加，所以平均值和最大的分组的子数组数目必定是 $k$。

为了方便计算子数组的平均值，我们使用一个数组 $\textit{prefix}$ 来保存数组 $\textit{nums}$ 的前缀和。我们使用 $\textit{dp}[i][j]$ 表示 $\textit{nums}$ 在区间 $[0, i-1]$ 被切分成 $j$ 个子数组的最大平均值和，显然 $i \ge j$，计算分两种情况讨论：

+ 当 $j = 1$ 时，$\textit{dp}[i][j]$ 是对应区间 $[0, i - 1]$ 的平均值；

+ 当 $j > 1$ 时，我们将可以将区间 $[0, i - 1]$ 分成 $[0, x - 1]$ 和 $[x, i - 1]$ 两个部分，其中 $x \ge j-1$，那么 $\textit{dp}[i][j]$ 等于所有这些合法的切分方式的平均值和的最大值。

因此转移方程为：

$$
\textit{dp}[i][j] = 
\begin{cases}
\dfrac{\sum_{r = 0}^{i - 1}\textit{nums}[r]}{i}, & j = 1 \\
\max\limits_{x \ge j - 1} \{dp[x][j - 1] + \dfrac{\sum_{r = x}^{i - 1}\textit{nums}[r]}{i - x}\}, & j > 1
\end{cases}
$$

假设数组 $\textit{nums}$ 的长度为 $n$，那么 $\textit{dp}[n][k]$ 表示数组 $\textit{nums}$ 分成 $k$ 个子数组后的最大平均值和，即最大分数。

```Python [sol1-Python3]
class Solution:
    def largestSumOfAverages(self, nums: List[int], k: int) -> float:
        n = len(nums)
        prefix = list(accumulate(nums, initial=0))
        dp = [[0.0] * (k + 1) for _ in range(n + 1)]
        for i in range(1, n + 1):
            dp[i][1] = prefix[i] / i
        for j in range(2, k + 1):
            for i in range(j, n + 1):
                for x in range(j - 1, i):
                    dp[i][j] = max(dp[i][j], dp[x][j - 1] + (prefix[i] - prefix[x]) / (i - x))
        return dp[n][k]
```

```C++ [sol1-C++]
class Solution {
public:
    double largestSumOfAverages(vector<int>& nums, int k) {
        int n = nums.size();
        vector<double> prefix(n + 1);
        for (int i = 0; i < n; i++) {
            prefix[i + 1] = prefix[i] + nums[i];
        }
        vector<vector<double>> dp(n + 1, vector<double>(k + 1));
        for (int i = 1; i <= n; i++) {
            dp[i][1] = prefix[i] / i;
        }
        for (int j = 2; j <= k; j++) {
            for (int i = j; i <= n; i++) {
                for (int x = j - 1; x < i; x++) {
                    dp[i][j] = max(dp[i][j], dp[x][j - 1] + (prefix[i] - prefix[x]) / (i - x));
                }
            }
        }
        return dp[n][k];
    }
};
```

```Java [sol1-Java]
class Solution {
    public double largestSumOfAverages(int[] nums, int k) {
        int n = nums.length;
        double[] prefix = new double[n + 1];
        for (int i = 0; i < n; i++) {
            prefix[i + 1] = prefix[i] + nums[i];
        }
        double[][] dp = new double[n + 1][k + 1];
        for (int i = 1; i <= n; i++) {
            dp[i][1] = prefix[i] / i;
        }
        for (int j = 2; j <= k; j++) {
            for (int i = j; i <= n; i++) {
                for (int x = j - 1; x < i; x++) {
                    dp[i][j] = Math.max(dp[i][j], dp[x][j - 1] + (prefix[i] - prefix[x]) / (i - x));
                }
            }
        }
        return dp[n][k];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public double LargestSumOfAverages(int[] nums, int k) {
        int n = nums.Length;
        double[] prefix = new double[n + 1];
        for (int i = 0; i < n; i++) {
            prefix[i + 1] = prefix[i] + nums[i];
        }
        double[][] dp = new double[n + 1][];
        for (int i = 0; i <= n; i++) {
            dp[i] = new double[k + 1];
        }
        for (int i = 1; i <= n; i++) {
            dp[i][1] = prefix[i] / i;
        }
        for (int j = 2; j <= k; j++) {
            for (int i = j; i <= n; i++) {
                for (int x = j - 1; x < i; x++) {
                    dp[i][j] = Math.Max(dp[i][j], dp[x][j - 1] + (prefix[i] - prefix[x]) / (i - x));
                }
            }
        }
        return dp[n][k];
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

double largestSumOfAverages(int* nums, int numsSize, int k) {
    double prefix[numsSize + 1];
    prefix[0] = 0.0;
    for (int i = 0; i < numsSize; i++) {
        prefix[i + 1] = prefix[i] + nums[i];
    }
    double dp[numsSize + 1][k + 1];
    for (int i = 1; i <= numsSize; i++) {
        dp[i][1] = prefix[i] / i;
    }
    for (int j = 2; j <= k; j++) {
        for (int i = j; i <= numsSize; i++) {
            dp[i][j] = 0.0;
            for (int x = j - 1; x < i; x++) {
                dp[i][j] = MAX(dp[i][j], dp[x][j - 1] + (prefix[i] - prefix[x]) / (i - x));
            }
        }
    }
    return dp[numsSize][k];
}
```

```JavaScript [sol1-JavaScript]
var largestSumOfAverages = function(nums, k) {
    const n = nums.length;
    const prefix = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) {
        prefix[i + 1] = prefix[i] + nums[i];
    }
    const dp = new Array(n + 1).fill(0).map(() => new Array(k + 1).fill(0));
    for (let i = 1; i <= n; i++) {
        dp[i][1] = prefix[i] / i;
    }
    for (let j = 2; j <= k; j++) {
        for (let i = j; i <= n; i++) {
            for (let x = j - 1; x < i; x++) {
                dp[i][j] = Math.max(dp[i][j], dp[x][j - 1] + (prefix[i] - prefix[x]) / (i - x));
            }
        }
    }
    return dp[n][k];
};
```

```go [sol1-Golang]
func largestSumOfAverages(nums []int, k int) float64 {
    n := len(nums)
    prefix := make([]float64, n+1)
    for i, x := range nums {
        prefix[i+1] = prefix[i] + float64(x)
    }
    dp := make([][]float64, n+1)
    for i := range dp {
        dp[i] = make([]float64, k+1)
    }
    for i := 1; i <= n; i++ {
        dp[i][1] = prefix[i] / float64(i)
    }
    for j := 2; j <= k; j++ {
        for i := j; i <= n; i++ {
            for x := j - 1; x < i; x++ {
                dp[i][j] = math.Max(dp[i][j], dp[x][j-1]+(prefix[i]-prefix[x])/float64(i-x))
            }
        }
    }
    return dp[n][k]
}
```

由于 $\textit{dp}[i][j]$ 的计算只利用到 $j-1$ 的数据，因此也可以使用一维数组对 $\textit{dp}[i][j]$ 进行计算，在计算过程中，要注意对 $i$ 进行逆序遍历。

```Python [sol2-Python3]
class Solution:
    def largestSumOfAverages(self, nums: List[int], k: int) -> float:
        n = len(nums)
        prefix = list(accumulate(nums, initial=0))
        dp = [0.0] * (n + 1)
        for i in range(1, n + 1):
            dp[i] = prefix[i] / i
        for j in range(2, k + 1):
            for i in range(n, j - 1, -1):
                for x in range(j - 1, i):
                    dp[i] = max(dp[i], dp[x] + (prefix[i] - prefix[x]) / (i - x))
        return dp[n]
```

```C++ [sol2-C++]
class Solution {
public:
    double largestSumOfAverages(vector<int>& nums, int k) {
        int n = nums.size();
        vector<double> prefix(n + 1);
        for (int i = 0; i < n; i++) {
            prefix[i + 1] = prefix[i] + nums[i];
        }
        vector<double> dp(n + 1);
        for (int i = 1; i <= n; i++) {
            dp[i] = prefix[i] / i;
        }
        for (int j = 2; j <= k; j++) {
            for (int i = n; i >= j; i--) {
                for (int x = j - 1; x < i; x++) {
                    dp[i] = max(dp[i], dp[x] + (prefix[i] - prefix[x]) / (i - x));
                }
            }
        }
        return dp[n];
    }
};
```

```Java [sol2-Java]
class Solution {
    public double largestSumOfAverages(int[] nums, int k) {
        int n = nums.length;
        double[] prefix = new double[n + 1];
        for (int i = 0; i < n; i++) {
            prefix[i + 1] = prefix[i] + nums[i];
        }
        double[] dp = new double[n + 1];
        for (int i = 1; i <= n; i++) {
            dp[i] = prefix[i] / i;
        }
        for (int j = 2; j <= k; j++) {
            for (int i = n; i >= j; i--) {
                for (int x = j - 1; x < i; x++) {
                    dp[i] = Math.max(dp[i], dp[x] + (prefix[i] - prefix[x]) / (i - x));
                }
            }
        }
        return dp[n];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public double LargestSumOfAverages(int[] nums, int k) {
        int n = nums.Length;
        double[] prefix = new double[n + 1];
        for (int i = 0; i < n; i++) {
            prefix[i + 1] = prefix[i] + nums[i];
        }
        double[] dp = new double[n + 1];
        for (int i = 1; i <= n; i++) {
            dp[i] = prefix[i] / i;
        }
        for (int j = 2; j <= k; j++) {
            for (int i = n; i >= j; i--) {
                for (int x = j - 1; x < i; x++) {
                    dp[i] = Math.Max(dp[i], dp[x] + (prefix[i] - prefix[x]) / (i - x));
                }
            }
        }
        return dp[n];
    }
}
```

```C [sol2-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

double largestSumOfAverages(int* nums, int numsSize, int k) {
    double prefix[numsSize + 1];
    prefix[0] = 0.0;
    for (int i = 0; i < numsSize; i++) {
        prefix[i + 1] = prefix[i] + nums[i];
    }
    double dp[numsSize + 1];
    for (int i = 1; i <= numsSize; i++) {
        dp[i] = prefix[i] / i;
    }
    for (int j = 2; j <= k; j++) {
        for (int i = numsSize; i >= j; i--) {
            for (int x = j - 1; x < i; x++) {
                dp[i] = MAX(dp[i], dp[x] + (prefix[i] - prefix[x]) / (i - x));
            }
        }
    }
    return dp[numsSize];
}
```

```JavaScript [sol2-JavaScript]
var largestSumOfAverages = function(nums, k) {
    const n = nums.length;
    const prefix = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) {
        prefix[i + 1] = prefix[i] + nums[i];
    }
    const dp = new Array(n + 1).fill(0);
    for (let i = 1; i <= n; i++) {
        dp[i] = prefix[i] / i;
    }
    for (let j = 2; j <= k; j++) {
        for (let i = n; i >= j; i--) {
            for (let x = j - 1; x < i; x++) {
                dp[i] = Math.max(dp[i], dp[x] + (prefix[i] - prefix[x]) / (i - x));
            }
        }
    }
    return dp[n];
};
```

```go [sol2-Golang]
func largestSumOfAverages(nums []int, k int) float64 {
    n := len(nums)
    prefix := make([]float64, n+1)
    for i, x := range nums {
        prefix[i+1] = prefix[i] + float64(x)
    }
    dp := make([]float64, n+1)
    for i := 1; i <= n; i++ {
        dp[i] = prefix[i] / float64(i)
    }
    for j := 2; j <= k; j++ {
        for i := n; i >= j; i-- {
            for x := j - 1; x < i; x++ {
                dp[i] = math.Max(dp[i], dp[x]+(prefix[i]-prefix[x])/float64(i-x))
            }
        }
    }
    return dp[n]
}
```

**复杂度分析**

+ 时间复杂度：$O(k \times n^2)$，其中 $k$ 是分组的最大子数组数目，$n$ 是数组 $\textit{nums}$ 的长度。计算前缀和需要 $O(n)$ 的时间，动态规划需要计算 $O(k \times n)$ 个状态，每个状态的计算时间是 $O(n)$。

+ 空间复杂度：$O(k \times n)$ 或 $O(n)$，其中 $k$ 是分组的最大子数组数目，$n$ 是数组 $\textit{nums}$ 的长度。二维数组实现的空间复杂度是 $O(k \times n)$，一维数组实现的空间复杂度是 $O(n)$。
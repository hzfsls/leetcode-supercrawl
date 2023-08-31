## [1388.3n 块披萨 中文官方题解](https://leetcode.cn/problems/pizza-with-3n-slices/solutions/100000/3n-kuai-pi-sa-by-leetcode-solution)

#### 前言

本题可以转化成如下问题：

> 给一个长度为 $3n$ 的环状序列，你可以在其中选择 $n$ 个数，并且任意两个数不能相邻，求这 $n$ 个数的最大值。

为什么可以这样转化呢？我们只需要证明，对于任意一种在长度为 $3n$ 的环状序列上选择 $n$ 个不相邻数的方法，都等价于一种题目中挑选披萨的方法。我们使用数学归纳法，证明如下：

- 当 $n=1$ 时，我们在 $3$ 个数中任选 $1$ 个，由于这是一个环状序列，因此选取其中的任意一个数，剩余的两个数都会在选取的数的两侧，即如果有 $3$ 块披萨，我们可以选取其中的任意一块；

- 当 $n \geq 2$ 时，一定存在一个数 $x$，使得 $x$ 的某一侧有连续两个数没有被选择（假设所有选中不相邻数的间隔为 
$1$，即中间只有一个数没有被选择，那么总数为 $2n$，与总数为 $3n$ 矛盾）。不失一般性，我们设 $x$ 的左侧有连续两个数没有被选择，并且 $x$ 的右侧至少有一个数没有没选择（否则 $x$ 和其右侧的数就相邻了），即：

    $\cdots, ?, 0, 0, x, 0 ?, \cdots$
    
    其中 $0$ 表示这个数没有被选择，$?$ 表示这个数选择的情况未知（即我们不需要考虑，它可能被选择，也可能没有被选择）。我们删去 $x$ 以及左右两侧的数，得到：

    $\cdots, ?, 0, ?, \cdots$

    将长度为 $3n$ 的环状序列变成了长度为 $3(n-1)$ 的环状序列，并且该环状序列中有 $n-1$ 个数被选取，且任意两个被选取的数不相邻。对应到披萨上，相当于我们挑选了数 $x$ 对应未知的披萨，而 Alice 和 Bob 挑选了相邻的两块披萨。这样我们将问题的规模从 $n$ 减小至 $n-1$，通过数学归纳法得证。

    同时，经过观察可发现，原方法选出的披萨一定都不相邻。结合上面的证明，命题的充分必要性得证。

因此，我们需要设计算法，在长度为 $3n$ 的环状序列中选择 $n$ 个不相邻的数，使得这 $n$ 个数的和最大。

#### 方法一：动态规划

动态规划的解决方法和 [213. 打家劫舍 II](https://leetcode.cn/problems/house-robber-ii/description/) 较为相似。

我们首先考虑该序列不是环状时的解决方法，即给定的是长度为 $3n$ 的普通序列。我们可以用 $\textit{dp}[i][j]$ 表示在前 $i$ 个数中选择了 $j$ 个不相邻的数的最大和：

+ 当 $i \lt 2$ 或 $j = 0$ 时：

    $$\textit{dp} = \begin{cases}
    0, & j = 0 \\
    \textit{slices}[0], & i = 0, j = 1 \\
    \max(\textit{slices}[0], \textit{slices}[1]), & i = 1, j = 1 \\
    -\infty, & i \lt 2,j \ge 2
    \end{cases}
    $$

+ 当 $i \ge 2$ 且 $j \gt 0$ 时，$\textit{dp}[i][j]$ 可以从两个位置转移而来：

    - 如果我们选择了第 $i$ 个数，那么第 $i - 1$ 个数不能被选择，相当于需要在前 $i - 2$ 个数中选择 $j - 1$ 个，即 $\textit{dp}[i][j] = \textit{dp}[i - 2][j - 1] + \textit{slices}[i]$。

    - 如果我们没有选择第 $i$ 个数，那么需要在前 $i - 1$ 个数中选择 $j$ 个，即 $\textit{dp}[i][j] = \textit{dp}[i - 1][j]$。

    取两者的最大值即为状态转移方程：

    $$
    \textit{dp}[i][j] = \max(\textit{dp}[i - 2][j - 1] + \textit{slices}[i], \textit{dp}[i - 1][j])
    $$

当该序列是环状序列时，我们应该如何求解呢？我们可以发现，环状序列相较于普通序列，相当于添加了一个限制：普通序列中的第一个和最后一个数不能同时选。这样一来，我们只需要对普通序列进行两遍动态即可得到答案，第一遍动态规划中我们删去普通序列中的第一个数，表示我们不会选第一个数；第二遍动态规划中我们删去普通序列中的最后一个数，表示我们不会选最后一个数。将这两遍动态规划得到的结果去较大值，即为在环状序列上的答案。

```C++ [sol1-C++]
class Solution {
public:
    int calculate(const vector<int>& slices) {
        int N = slices.size(), n = (N + 1) / 3;
        vector<vector<int>> dp(N, vector<int>(n + 1, INT_MIN));
        dp[0][0] = 0;
        dp[0][1] = slices[0];
        dp[1][0] = 0;
        dp[1][1] = max(slices[0], slices[1]);
        for (int i = 2; i < N; i++) {
            dp[i][0] = 0;
            for (int j = 1; j <= n; j++) {
                dp[i][j] = max(dp[i - 1][j], dp[i - 2][j - 1] + slices[i]);
            }
        }
        return dp[N - 1][n];
    }

    int maxSizeSlices(vector<int>& slices) {
        vector<int> v1(slices.begin() + 1, slices.end());
        vector<int> v2(slices.begin(), slices.end() - 1);
        int ans1 = calculate(v1);
        int ans2 = calculate(v2);
        return max(ans1, ans2);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxSizeSlices(int[] slices) {
        int[] v1 = new int[slices.length - 1];
        int[] v2 = new int[slices.length - 1];
        System.arraycopy(slices, 1, v1, 0, slices.length - 1);
        System.arraycopy(slices, 0, v2, 0, slices.length - 1);
        int ans1 = calculate(v1);
        int ans2 = calculate(v2);
        return Math.max(ans1, ans2);
    }

    public int calculate(int[] slices) {
        int N = slices.length, n = (N + 1) / 3;
        int[][] dp = new int[N][n + 1];
        for (int i = 0; i < N; i++) {
            Arrays.fill(dp[i], Integer.MIN_VALUE);
        }
        dp[0][0] = 0;
        dp[0][1] = slices[0];
        dp[1][0] = 0;
        dp[1][1] = Math.max(slices[0], slices[1]);
        for (int i = 2; i < N; i++) {
            dp[i][0] = 0;
            for (int j = 1; j <= n; j++) {
                dp[i][j] = Math.max(dp[i - 1][j], dp[i - 2][j - 1] + slices[i]);
            }
        }
        return dp[N - 1][n];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxSizeSlices(int[] slices) {
        int[] v1 = new int[slices.Length - 1];
        int[] v2 = new int[slices.Length - 1];
        Array.Copy(slices, 1, v1, 0, slices.Length - 1);
        Array.Copy(slices, 0, v2, 0, slices.Length - 1);
        int ans1 = Calculate(v1);
        int ans2 = Calculate(v2);
        return Math.Max(ans1, ans2);
    }

    public int Calculate(int[] slices) {
        int N = slices.Length, n = (N + 1) / 3;
        int[][] dp = new int[N][];
        for (int i = 0; i < N; i++) {
            dp[i] = new int[n + 1];
            Array.Fill(dp[i], int.MinValue);
        }
        dp[0][0] = 0;
        dp[0][1] = slices[0];
        dp[1][0] = 0;
        dp[1][1] = Math.Max(slices[0], slices[1]);
        for (int i = 2; i < N; i++) {
            dp[i][0] = 0;
            for (int j = 1; j <= n; j++) {
                dp[i][j] = Math.Max(dp[i - 1][j], dp[i - 2][j - 1] + slices[i]);
            }
        }
        return dp[N - 1][n];
    }
}
```

```Golang [sol1-Golang]
func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func calculate(slices []int) int {
    N, n := len(slices), (len(slices) + 1) / 3
    dp := make([][]int, N)
    for i := 0; i < N; i++ {
        dp[i] = make([]int, n + 1)
        for j := 0; j <= n; j++ {
            dp[i][j] = -0x3f3f3f3f
        }
    }
    dp[0][0], dp[0][1], dp[1][0], dp[1][1] = 0, slices[0], 0, max(slices[0], slices[1])
    for i := 2; i < N; i++ {
        dp[i][0] = 0
        for j := 1; j <= n; j++ {
            dp[i][j] = max(dp[i - 1][j], dp[i - 2][j - 1] + slices[i])
        }
    }
    return dp[N - 1][n]
}

func maxSizeSlices(slices []int) int {
    return max(calculate(slices[1:]), calculate(slices[:len(slices) - 1]))
}
```

```C [sol1-C]
int calculate(const int* slices, int slicesSize) {
    int N = slicesSize;
    int n = (N + 1) / 3;
    int dp[N][n + 1];
    for (int i = 0; i < N; i++) {
        for (int j = 0; j <= n; j++) {
            dp[i][j] = INT_MIN;
        }
    }
    dp[0][0] = 0;
    dp[0][1] = slices[0];
    dp[1][0] = 0;
    dp[1][1] = fmax(slices[0], slices[1]);
    for (int i = 2; i < N; i++) {
        dp[i][0] = 0;
        for (int j = 1; j <= n; j++) {
            dp[i][j] = fmax(dp[i - 1][j], dp[i - 2][j - 1] + slices[i]);
        }
    }
    return dp[N - 1][n];
}

int maxSizeSlices(int* slices, int slicesSize) {
    int ans1 = calculate(slices + 1, slicesSize - 1);
    int ans2 = calculate(slices, slicesSize - 1);
    return fmax(ans1, ans2);
}
```

```Python [sol1-Python3]
class Solution:
    def maxSizeSlices(self, slices: List[int]) -> int:
        def calculate(slices):
            N, n = len(slices), (len(slices) + 1) // 3
            dp = [[-10**9 for i in range(n + 1)] for j in range(N)]
            dp[0][0], dp[0][1] = 0, slices[0]
            dp[1][0], dp[1][1] = 0, max(slices[0], slices[1])
            for i in range(2, N, 1):
                dp[i][0] = 0
                for j in range(1, n + 1, 1):
                    dp[i][j] = max(dp[i - 1][j], dp[i - 2][j - 1] + slices[i])
            return dp[N - 1][n]
        v1 = slices[1:]
        v2 = slices[0:-1]
        ans1 = calculate(v1)
        ans2 = calculate(v2)
        return max(ans1, ans2)
```

```JavaScript [sol1-JavaScript]
var maxSizeSlices = function(slices) {
    const v1 = slices.slice(1);
    const v2 = slices.slice(0, slices.length - 1);     
    const ans1 = calculate(v1);
    const ans2 = calculate(v2);
    return Math.max(ans1, ans2);
};

const calculate = (slices) => {
    const N = slices.length;
    const n = Math.floor((slices.length + 1) / 3);
    const dp = new Array(N).fill(0).map(() => new Array(n + 1).fill(-Infinity));
    dp[0][0] = 0, dp[0][1] = slices[0];
    dp[1][0] = 0, dp[1][1] = Math.max(slices[0], slices[1]);
    for (let i = 2; i < N; i++) {
        dp[i][0] = 0;
        for (let j = 1; j <= n; j++) {
            dp[i][j] = Math.max(dp[i - 1][j], dp[i - 2][j - 1] + slices[i]);
        }
    }
    return dp[N - 1][n];
};
```

**复杂度分析**

- 时间复杂度：$O(N^2)$，其中 $N$ 是数组 $\textit{slices}$ 的长度。

- 空间复杂度：$O(N^2)$，即存储动态规划计算的状态需要使用的空间。在状态转移方程中，$\textit{dp}[i][..]$ 只与 $\textit{dp}[i-1][..]$ 和 $\textit{dp}[i-2][..]$ 有关，$\textit{dp}[..][j]$ 只与 $\textit{dp}[..][j-1]$ 有关，因此我们可以：

    - 用三个一维数组分别存储 $\textit{dp}[i][..]$，$\textit{dp}[i-1][..]$ 和 $\textit{dp}[i-2][..]$，并在每次 $i$ 值增加时适当地交换它们；

    - 用两个一维数组分别存储 $\textit{dp}[..][j-1]$ 和 $\textit{dp}[..][j]$，将计算动态规划的二重循环改为 $j$ 在外层而 $i$ 在内层，并在每次 $j$ 值增加时适当地交换它们。

    这两种方法都可以将空间复杂度降低至 $O(N)$。
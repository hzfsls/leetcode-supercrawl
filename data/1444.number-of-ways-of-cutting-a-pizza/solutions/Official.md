#### 方法一：动态规划

**思路与算法**

题目给一个 $m\times n$ 大小的矩形披萨和一个整数 $k$，需要把披萨切成 $k$ 块并且每一块都有苹果，问所有的切割方式。

因为需要方便地知道，切割后的两块披萨是否含有苹果，我们对披萨进行一步预处理，每一个坐标右下方矩形中的苹果数量。由容斥原理可以得到关系式：

$$\textit{apples}[i][j] = (\textit{pizza}[i][j] == \textit{A}) + \textit{apples}[i+1][j] + \textit{apples}[i][j+1] - \textit{apples}[i+1][j+1]$$


因为切割一刀后，大披萨的问题转化为求小披萨的切割方案数，我们考虑用动态规划的方式来解答。 $\textit{dp}[k][i][j]$ 表示把坐标 $(i, j)$ 右下方的披萨切割成 $k$ 块披萨的方案数量，
如果 $\textit{apples}[i][j]$ 大于零，则初始化 $\textit{dp}[1][i][j] = 1$，表示当前坐标右下方的披萨符合题目条件，否则为零。

根据题目要求，切一刀将披萨一分为二，每块披萨上都有苹果，所以大披萨的苹果数量，要严格大于小披萨苹果数量，小披萨的苹果数量，要严格大于零。由此我们可以得到动态规划的方程:

$$\textit{dp}[k][i][j] = \sum_{i^{'}=i+1}^m(\textit{dp}[k-1][i^{'}][j]) + \sum_{j^{'}=j+1}^n(\textit{dp}[k-1][i][j^{'}])$$

其中 $i^{'}$ 和 $j^{'}$ 满足
$$\textit{apples}[i][j] > \textit{apples}[i^{'}][j], \textit{apples}[i][j] > \textit{apples}[i][j^{'}]$$

我们依次遍历求得所有 $\textit{dp}$ 的结果，最后返回 $\textit{dp}[k][0][0]$ 为最终答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int ways(vector<string>& pizza, int k) {
        int m = pizza.size(), n = pizza[0].size(), mod = 1e9 + 7;
        vector<vector<int>> apples(m + 1, vector<int>(n + 1));
        vector<vector<vector<int>>> dp(k + 1, vector<vector<int>>(m + 1, vector<int>(n + 1)));

        // 预处理
        for (int i = m - 1; i >= 0; i--) {
            for (int j = n - 1; j >= 0; j--) {
                apples[i][j] = apples[i][j + 1] + apples[i + 1][j] - apples[i + 1][j + 1] + (pizza[i][j] == 'A');
                dp[1][i][j] = apples[i][j] > 0;
            }
        }

        for (int ki = 2; ki <= k; ki++) {
            for (int i = 0; i < m; i++) {
                for (int j = 0; j < n; j++) {
                    // 水平方向切
                    for (int i2 = i + 1; i2 < m; i2++) {
                        if (apples[i][j] > apples[i2][j]) {
                            dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i2][j]) % mod;
                        }
                    }
                    // 垂直方向切
                    for (int j2 = j + 1; j2 < n; j2++) {
                        if (apples[i][j] > apples[i][j2]) {
                            dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i][j2]) % mod;
                        }
                    }
                }
            }
        }
        return dp[k][0][0];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int ways(String[] pizza, int k) {
        int m = pizza.length, n = pizza[0].length(), mod = 1_000_000_007;
        int[][] apples = new int[m + 1][n + 1];
        int[][][] dp = new int[k + 1][m + 1][n + 1];

        // 预处理
        for (int i = m - 1; i >= 0; i--) {
            for (int j = n - 1; j >= 0; j--) {
                apples[i][j] = apples[i][j + 1] + apples[i + 1][j] - apples[i + 1][j + 1] + (pizza[i].charAt(j) == 'A' ? 1 : 0);
                dp[1][i][j] = apples[i][j] > 0 ? 1 : 0;
            }
        }

        for (int ki = 2; ki <= k; ki++) {
            for (int i = 0; i < m; i++) {
                for (int j = 0; j < n; j++) {
                    // 水平方向切
                    for (int i2 = i + 1; i2 < m; i2++) {
                        if (apples[i][j] > apples[i2][j]) {
                            dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i2][j]) % mod;
                        }
                    }
                    // 垂直方向切
                    for (int j2 = j + 1; j2 < n; j2++) {
                        if (apples[i][j] > apples[i][j2]) {
                            dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i][j2]) % mod;
                        }
                    }
                }
            }
        }
        return dp[k][0][0];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int Ways(string[] pizza, int k) {
        int m = pizza.Length, n = pizza[0].Length, mod = 1_000_000_007;
        int[][] apples = new int[m + 1][];
        for (int i = 0; i <= m; i++) {
            apples[i] = new int[n + 1];
        }
        int[][][] dp = new int[k + 1][][];
        for (int i = 0; i <= k; i++) {
            dp[i] = new int[m + 1][];
            for (int j = 0; j <= m; j++) {
                dp[i][j] = new int[n + 1];
            }
        }

        // 预处理
        for (int i = m - 1; i >= 0; i--) {
            for (int j = n - 1; j >= 0; j--) {
                apples[i][j] = apples[i][j + 1] + apples[i + 1][j] - apples[i + 1][j + 1] + (pizza[i][j] == 'A' ? 1 : 0);
                dp[1][i][j] = apples[i][j] > 0 ? 1 : 0;
            }
        }

        for (int ki = 2; ki <= k; ki++) {
            for (int i = 0; i < m; i++) {
                for (int j = 0; j < n; j++) {
                    // 水平方向切
                    for (int i2 = i + 1; i2 < m; i2++) {
                        if (apples[i][j] > apples[i2][j]) {
                            dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i2][j]) % mod;
                        }
                    }
                    // 垂直方向切
                    for (int j2 = j + 1; j2 < n; j2++) {
                        if (apples[i][j] > apples[i][j2]) {
                            dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i][j2]) % mod;
                        }
                    }
                }
            }
        }
        return dp[k][0][0];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def ways(self, pizza: List[str], k: int) -> int:
        m, n, mod = len(pizza), len(pizza[0]), 10 ** 9 + 7
        apples = [[0] * (n + 1) for _ in range(m + 1)]
        dp = [[[0 for j in range(n)] for i in range(m)] for _ in range(k + 1)]

        # 预处理
        for i in range(m - 1, -1, -1):
            for j in range(n - 1, -1, -1):
                apples[i][j] = apples[i][j + 1] + apples[i + 1][j] - apples[i + 1][j + 1] + (pizza[i][j] == 'A')
                dp[1][i][j] = 1 if apples[i][j] > 0 else 0

        for k in range(1, k + 1):
            for i in range(m):
                for j in range(n):
                    # 水平方向切
                    for i2 in range(i + 1, m):
                        if apples[i][j] > apples[i2][j]:
                            dp[k][i][j] = (dp[k][i][j] + dp[k - 1][i2][j]) % mod
                    # 垂直方向切
                    for j2 in range(j + 1, n):
                        if apples[i][j] > apples[i][j2]:
                            dp[k][i][j] = (dp[k][i][j] + dp[k - 1][i][j2]) % mod
        return dp[k][0][0]
```

```JavaScript [sol1-JavaScript]
var ways = function(pizza, k) {
    const m = pizza.length, n = pizza[0].length, mod = 1_000_000_007;
    const apples = Array(m + 1).fill(0).map(() => Array(n + 1).fill(0));
    const dp = Array(k + 1).fill(0).map(() => Array(m + 1).fill(0).map(() => Array(n + 1).fill(0)));
    for (let i = m - 1; i >= 0; i--) {
        for (let j = n - 1; j >= 0; j--) {
            apples[i][j] = apples[i][j + 1] + apples[i + 1][j] - apples[i + 1][j + 1] + (pizza[i].charAt(j) == 'A' ? 1 : 0);
            dp[1][i][j] = apples[i][j] > 0 ? 1 : 0;
        }
    }

    // 预处理
    for (let i = m - 1; i >= 0; i--) {
        for (let j = n - 1; j >= 0; j--) {
            apples[i][j] = apples[i][j + 1] + apples[i + 1][j] - apples[i + 1][j + 1] + (pizza[i].charAt(j) == 'A' ? 1 : 0);
            dp[1][i][j] = apples[i][j] > 0 ? 1 : 0;
        }
    }

    for (let ki = 2; ki <= k; ki++) {
        for (let i = 0; i < m; i++) {
            for (let j = 0; j < n; j++) {
                // 水平方向切
                for (let i2 = i + 1; i2 < m; i2++) {
                    if (apples[i][j] > apples[i2][j]) {
                        dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i2][j]) % mod;
                    }
                }
                // 垂直方向切
                for (let j2 = j + 1; j2 < n; j2++) {
                    if (apples[i][j] > apples[i][j2]) {
                        dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i][j2]) % mod;
                    }
                }
            }
        }
    }
    return dp[k][0][0];
};
```

```Go [sol1-Go]
func ways(pizza []string, k int) int {
    m := len(pizza)
    n := len(pizza[0])
    mod := 1_000_000_007
    apples := make([][]int, m + 1)
    for i := range apples {
        apples[i] = make([]int, n + 1)
    }
    dp := make([][][]int, k + 1)
    for i := range dp {
        dp[i] = make([][]int, m + 1)
        for j := range dp[i] {
            dp[i][j] = make([]int, n + 1)
        }
    }

    // 预处理
    for i := m - 1; i >= 0; i-- {
        for j := n - 1; j >= 0; j-- {
            apples[i][j] = apples[i + 1][j] + apples[i][j + 1] - apples[i+1][j + 1]
            if pizza[i][j] == 'A' {
                apples[i][j] += 1
            }
            if apples[i][j] > 0 {
                dp[1][i][j] = 1
            }
        }
    }

    for ki := 2; ki <= k; ki++ {
        for i := 0; i < m; i++ {
            for j := 0; j < n; j++ {
                // 水平方向切
                for i2 := i + 1; i2 < m; i2++ {
                    if apples[i][j] > apples[i2][j] {
                        dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i2][j]) % mod
                    }
                }
                // 垂直方向切
                for j2 := j + 1; j2 < n; j2++ {
                    if apples[i][j] > apples[i][j2] {
                        dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i][j2]) % mod
                    }
                }
            }
        }
    }
    return dp[k][0][0]
}
```

```C [sol1-C]
int ways(char ** pizza, int pizzaSize, int k){
    int m = pizzaSize, n = strlen(pizza[0]), mod = 1e9 + 7;
    int apples[m + 1][n + 1];
    int dp[k + 1][m + 1][n + 1];
    memset(apples, 0, sizeof(apples));
    memset(dp, 0, sizeof(dp));

    // 预处理
    for (int i = m - 1; i >= 0; i--) {
        for (int j = n - 1; j >= 0; j--) {
            apples[i][j] = apples[i][j + 1] + apples[i + 1][j] - apples[i + 1][j + 1] + (pizza[i][j] == 'A');
            dp[1][i][j] = (apples[i][j] > 0) ? 1 : 0;
        }
    }

    for (int ki = 2; ki <= k; ki++) {
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                dp[ki][i][j] = 0;
                // 水平方向切
                for (int i2 = i + 1; i2 < m; i2++) {
                    if (apples[i][j] > apples[i2][j]) {
                        dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i2][j]) % mod;
                    }
                }
                // 垂直方向切
                for (int j2 = j + 1; j2 < n; j2++) {
                    if (apples[i][j] > apples[i][j2]) {
                        dp[ki][i][j] = (dp[ki][i][j] + dp[ki - 1][i][j2]) % mod;
                    }
                }
            }
        }
    }
    return dp[k][0][0];
}
```

**复杂度分析**

- 时间复杂度：$O(kmn(n + m))$，其中 $n$ 和 $m$ 是矩形的行数和列数，$k$ 是披萨的切割数量。

- 空间复杂度：$O(kmn)$，其中 $n$ 和 $m$ 是矩形的行数和列数，$k$ 是披萨的切割数量。
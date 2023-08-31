## [1595.连通两组点的最小成本 中文官方题解](https://leetcode.cn/problems/minimum-cost-to-connect-two-groups-of-points/solutions/100000/lian-tong-liang-zu-dian-de-zui-xiao-chen-6qoj)
#### 方法一：状态压缩 + 动态规划

记第一组点数为 $\textit{size}_1$，第二组点数为 $\textit{size}_2$。根据数据范围，我们可以使用二进制数 $s$ 来表示一个点集，$s$ 的第 $k$ 位为 $1$ 表示第 $k$ 个点在点集 $s$ 中，$s$ 的第 $k$ 位为 $0$ 表示第 $k$ 个点不在点集 $s$ 中。使用 $\textit{dp}[i][s]$ 表示第一组的前 $i$ 个点（前 $i$ 个点指第 $0, 1, 2, ..., i - 1$ 个点）与第二组的点集 $s$ 的最小连通成本（因为 $\textit{size}_1 \ge \textit{size}_2$，所以将第二组作为点集），有四种情况：

+ $i = 0$ 且 $s = 0$：

    两组点都为空，因此最小连通成本为 $\textit{dp}[0][0] = 0$。

+ $i = 0$ 且 $s \ne 0$：

    第一组的点为空，第二组的点不为空，因此无法连通，令 $\textit{dp}[0][s] = \infty$。

+ $i \ne 0$ 且 $s = 0$：

    第一组的点不为空，第二组的点为空，因此无法连通，令 $\textit{dp}[i][0] = \infty$。

+ $i \ne 0$ 且 $s \ne 0$：

    考虑第一组第 $i - 1$ 个点与第二组点集 $s$ 的第 $k$ 个点连接，使用 $s_{-k}$ 表示点集 $s$ 去除第 $k$ 个点后的剩余点集，那么连通成本 $c$ 有三种情况：

    + 第二组点集 $s$ 的第 $k$ 个点不再与其他点连接，那么 $c = \textit{dp}[i][s_{-k}] + \textit{cost}[i - 1][k]$；

    + 第一组第 $i - 1$ 个点不再与其他点连接，那么 $c = \textit{dp}[i - 1][s] + \textit{cost}[i - 1][k]$；

    + 第一组第 $i - 1$ 个点和第二组点集 $s$ 的第 $k$ 个点都不再与其他点连接，那么 $c = \textit{dp}[i - 1][s_{-k}] + \textit{cost}[i - 1][k]$。

    枚举第一组第 $i - 1$ 个点与第二组点集 $s$ 中任一 $k \in s$ 的点连接，那么状态转移方程如下：

$$
\textit{dp}[i][s] = \min_{k \in s} \big \{ {\min { \{ \textit{dp}[i][s_{-k}], \textit{dp}[i - 1][s], \textit{dp}[i - 1][s_{-k}] \} } + \textit{cost}[i - 1][k]} \big \}
$$

```C++ [sol1-C++]
class Solution {
public:
    int connectTwoGroups(vector<vector<int>>& cost) {
        int size1 = cost.size(), size2 = cost[0].size(), m = 1 << size2;
        vector<vector<int>> dp(size1 + 1, vector<int>(m, INT_MAX / 2));
        dp[0][0] = 0;
        for (int i = 1; i <= size1; i++) {
            for (int s = 0; s < m; s++) {
                for (int k = 0; k < size2; k++) {
                    if ((s & (1 << k)) == 0) {
                        continue;
                    }
                    dp[i][s] = min(dp[i][s], dp[i][s ^ (1 << k)] + cost[i - 1][k]);
                    dp[i][s] = min(dp[i][s], dp[i - 1][s] + cost[i - 1][k]);
                    dp[i][s] = min(dp[i][s], dp[i - 1][s ^ (1 << k)] + cost[i - 1][k]);
                }
            }
        }
        return dp[size1][m - 1];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int connectTwoGroups(List<List<Integer>> cost) {
        int size1 = cost.size(), size2 = cost.get(0).size(), m = 1 << size2;
        int[][] dp = new int[size1 + 1][m];
        for (int i = 0; i <= size1; i++) {
            Arrays.fill(dp[i], Integer.MAX_VALUE / 2);
        }
        dp[0][0] = 0;
        for (int i = 1; i <= size1; i++) {
            for (int s = 0; s < m; s++) {
                for (int k = 0; k < size2; k++) {
                    if ((s & (1 << k)) == 0) {
                        continue;
                    }
                    dp[i][s] = Math.min(dp[i][s], dp[i][s ^ (1 << k)] + cost.get(i - 1).get(k));
                    dp[i][s] = Math.min(dp[i][s], dp[i - 1][s] + cost.get(i - 1).get(k));
                    dp[i][s] = Math.min(dp[i][s], dp[i - 1][s ^ (1 << k)] + cost.get(i - 1).get(k));
                }
            }
        }
        return dp[size1][m - 1];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ConnectTwoGroups(IList<IList<int>> cost) {
        int size1 = cost.Count, size2 = cost[0].Count, m = 1 << size2;
        int[][] dp = new int[size1 + 1][];
        for (int i = 0; i <= size1; i++) {
            dp[i] = new int[m];
            Array.Fill(dp[i], int.MaxValue / 2);
        }
        dp[0][0] = 0;
        for (int i = 1; i <= size1; i++) {
            for (int s = 0; s < m; s++) {
                for (int k = 0; k < size2; k++) {
                    if ((s & (1 << k)) == 0) {
                        continue;
                    }
                    dp[i][s] = Math.Min(dp[i][s], dp[i][s ^ (1 << k)] + cost[i - 1][k]);
                    dp[i][s] = Math.Min(dp[i][s], dp[i - 1][s] + cost[i - 1][k]);
                    dp[i][s] = Math.Min(dp[i][s], dp[i - 1][s ^ (1 << k)] + cost[i - 1][k]);
                }
            }
        }
        return dp[size1][m - 1];
    }
}
```

```Golang [sol1-Golang]
func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func connectTwoGroups(cost [][]int) int {
    size1, size2, m := len(cost), len(cost[0]), 1 << len(cost[0])
    dp := make([][]int, size1 + 1)
    for i := 0; i <= size1; i++ {
        dp[i] = make([]int, m)
    }
    for s := 1; s < m; s++ {
        dp[0][s] = 0x3f3f3f3f
    }
    for i := 1; i <= size1; i++ {
        for s := 0; s < m; s++ {
            dp[i][s] = 0x3f3f3f3f
            for k := 0; k < size2; k++ {
                if (s & (1 << k)) == 0 {
                    continue
                }
                dp[i][s] = min(dp[i][s], dp[i][s ^ (1 << k)] + cost[i - 1][k])
                dp[i][s] = min(dp[i][s], dp[i - 1][s] + cost[i - 1][k])
                dp[i][s] = min(dp[i][s], dp[i - 1][s ^ (1 << k)] + cost[i - 1][k])
            }
        }
    }
    return dp[size1][m - 1]
}
```

```C [sol1-C]
int connectTwoGroups(int** cost, int costSize, int* costColSize) {
    int size1 = costSize, size2 = costColSize[0], m = 1 << size2; 
    int dp[size1 + 1][m];
    memset(dp, 0x3f, sizeof(dp));
    dp[0][0] = 0;
    for (int i = 1; i <= size1; i++) {
        for (int s = 0; s < m; s++) {
            for (int k = 0; k < size2; k++) {
                if ((s & (1 << k)) == 0) {
                    continue;
                }
                dp[i][s] = fmin(dp[i][s], dp[i][s ^ (1 << k)] + cost[i - 1][k]);
                dp[i][s] = fmin(dp[i][s], dp[i - 1][s] + cost[i - 1][k]);
                dp[i][s] = fmin(dp[i][s], dp[i - 1][s ^ (1 << k)] + cost[i - 1][k]);
            }
        }
    }
    return dp[size1][m - 1];
}
```

```Python [sol1-Python3]
class Solution:
    def connectTwoGroups(self, cost: List[List[int]]) -> int:
        size1, size2 = len(cost), len(cost[0])
        m = 1 << size2
        dp = [[float("inf")] * m for _ in range(size1 + 1)]
        dp[0][0] = 0

        for i in range(1, size1 + 1):
            for s in range(m):
                for k in range(size2):
                    if (s & (1 << k)) == 0:
                        continue
                    dp[i][s] = min(dp[i][s], dp[i][s ^ (1 << k)] + cost[i - 1][k])
                    dp[i][s] = min(dp[i][s], dp[i - 1][s] + cost[i - 1][k])
                    dp[i][s] = min(dp[i][s], dp[i - 1][s ^ (1 << k)] + cost[i - 1][k])
        
        return dp[size1][m - 1]
```

```JavaScript [sol1-JavaScript]
var connectTwoGroups = function(cost) {
    const size1 = cost.length;
    const size2 = cost[0].length;
    const m = 1 << size2;
    const dp = Array.from(Array(size1 + 1), () => new Array(m).fill(Number.MAX_SAFE_INTEGER / 2));

    dp[0][0] = 0;

    for (let i = 1; i <= size1; i++) {
        for (let s = 0; s < m; s++) {
        for (let k = 0; k < size2; k++) {
            if ((s & (1 << k)) === 0) {
            continue;
            }
            dp[i][s] = Math.min(dp[i][s], dp[i][s ^ (1 << k)] + cost[i - 1][k]);
            dp[i][s] = Math.min(dp[i][s], dp[i - 1][s] + cost[i - 1][k]);
            dp[i][s] = Math.min(dp[i][s], dp[i - 1][s ^ (1 << k)] + cost[i - 1][k]);
        }
        }
    }

    return dp[size1][m - 1];
};
```

转移方程的 $dp[i][*]$ 计算只与 $dp[i - 1][*]$ 和 $dp[i][*]$ 相关，因此我们可以只使用一维数组来保存，从而节省空间。

```C++ [sol2-C++]
class Solution {
public:
    int connectTwoGroups(vector<vector<int>>& cost) {
        int size1 = cost.size(), size2 = cost[0].size(), m = 1 << size2;
        vector<int> dp1(m, INT_MAX / 2), dp2(m);
        dp1[0] = 0;
        for (int i = 1; i <= size1; i++) {
            for (int s = 0; s < m; s++) {
                dp2[s] = INT_MAX / 2;
                for (int k = 0; k < size2; k++) {
                    if ((s & (1 << k)) == 0) {
                        continue;
                    }
                    dp2[s] = min(dp2[s], dp2[s ^ (1 << k)] + cost[i - 1][k]);
                    dp2[s] = min(dp2[s], dp1[s] + cost[i - 1][k]);
                    dp2[s] = min(dp2[s], dp1[s ^ (1 << k)] + cost[i - 1][k]);
                }
            }
            dp1.swap(dp2);
        }
        return dp1[m - 1];
    }
};
```

```Java [sol2-Java]
class Solution {
    public int connectTwoGroups(List<List<Integer>> cost) {
        int size1 = cost.size(), size2 = cost.get(0).size(), m = 1 << size2;
        int[] dp1 = new int[m];
        Arrays.fill(dp1, Integer.MAX_VALUE / 2);
        int[] dp2 = new int[m];
        dp1[0] = 0;
        for (int i = 1; i <= size1; i++) {
            for (int s = 0; s < m; s++) {
                dp2[s] = Integer.MAX_VALUE / 2;
                for (int k = 0; k < size2; k++) {
                    if ((s & (1 << k)) == 0) {
                        continue;
                    }
                    dp2[s] = Math.min(dp2[s], dp2[s ^ (1 << k)] + cost.get(i - 1).get(k));
                    dp2[s] = Math.min(dp2[s], dp1[s] + cost.get(i - 1).get(k));
                    dp2[s] = Math.min(dp2[s], dp1[s ^ (1 << k)] + cost.get(i - 1).get(k));
                }
            }
            System.arraycopy(dp2, 0, dp1, 0, m);
        }
        return dp1[m - 1];
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ConnectTwoGroups(IList<IList<int>> cost) {
        int size1 = cost.Count, size2 = cost[0].Count, m = 1 << size2;
        int[] dp1 = new int[m];
        Array.Fill(dp1, int.MaxValue / 2);
        int[] dp2 = new int[m];
        dp1[0] = 0;
        for (int i = 1; i <= size1; i++) {
            for (int s = 0; s < m; s++) {
                dp2[s] = int.MaxValue / 2;
                for (int k = 0; k < size2; k++) {
                    if ((s & (1 << k)) == 0) {
                        continue;
                    }
                    dp2[s] = Math.Min(dp2[s], dp2[s ^ (1 << k)] + cost[i - 1][k]);
                    dp2[s] = Math.Min(dp2[s], dp1[s] + cost[i - 1][k]);
                    dp2[s] = Math.Min(dp2[s], dp1[s ^ (1 << k)] + cost[i - 1][k]);
                }
            }
            Array.Copy(dp2, 0, dp1, 0, m);
        }
        return dp1[m - 1];
    }
}
```

```Golang [sol2-Golang]
func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func connectTwoGroups(cost [][]int) int {
    size1, size2, m := len(cost), len(cost[0]), 1 << len(cost[0])
    dp1, dp2 := make([]int, m), make([]int, m)
    for s := 1; s < m; s++ {
        dp1[s] = 0x3f3f3f3f
    }
    for i := 1; i <= size1; i++ {
        for s := 0; s < m; s++ {
            dp2[s] = 0x3f3f3f3f
            for k := 0; k < size2; k++ {
                if (s & (1 << k)) == 0 {
                    continue
                }
                dp2[s] = min(dp2[s], dp2[s ^ (1 << k)] + cost[i - 1][k])
                dp2[s] = min(dp2[s], dp1[s] + cost[i - 1][k])
                dp2[s] = min(dp2[s], dp1[s ^ (1 << k)] + cost[i - 1][k])
            }
        }
        dp1, dp2 = dp2, dp1
    }
    return dp1[m - 1]
}
```

```C [sol2-C]
int connectTwoGroups(int** cost, int costSize, int* costColSize) {
    int size1 = costSize, size2 = costColSize[0], m = 1 << size2;
    int dp1[m], dp2[m];
    memset(dp1, 0x3f, sizeof(dp1));
    dp1[0] = 0;
    for (int i = 1; i <= size1; i++) {
        for (int s = 0; s < m; s++) {
            dp2[s] = INT_MAX / 2;
            for (int k = 0; k < size2; k++) {
                if ((s & (1 << k)) == 0) {
                    continue;
                }
                dp2[s] = fmin(dp2[s], dp2[s ^ (1 << k)] + cost[i - 1][k]);
                dp2[s] = fmin(dp2[s], dp1[s] + cost[i - 1][k]);
                dp2[s] = fmin(dp2[s], dp1[s ^ (1 << k)] + cost[i - 1][k]);
            }
        }
        memcpy(dp1, dp2, sizeof(dp2));
    }
    return dp1[m - 1];
}
```

```Python [sol2-Python3]
class Solution:
    def connectTwoGroups(self, cost: List[List[int]]) -> int:
        size1, size2 = len(cost), len(cost[0])
        m = 1 << size2
        dp1, dp2 = [float("inf")] * m, [0] * m
        dp1[0] = 0

        for i in range(1, size1 + 1):
            for s in range(m):
                dp2[s] = float("inf")
                for k in range(size2):
                    if (s & (1 << k)) == 0:
                        continue
                    dp2[s] = min(dp2[s], dp2[s ^ (1 << k)] + cost[i - 1][k])
                    dp2[s] = min(dp2[s], dp1[s] + cost[i - 1][k])
                    dp2[s] = min(dp2[s], dp1[s ^ (1 << k)] + cost[i - 1][k])
            dp1 = dp2[:]
        
        return dp1[m - 1]
```

```JavaScript [sol2-JavaScript]
var connectTwoGroups = function(cost) {
    const size1 = cost.length;
    const size2 = cost[0].length;
    const m = 1 << size2;
    const dp1 = new Array(m).fill(Number.MAX_SAFE_INTEGER / 2);
    const dp2 = new Array(m);
    
    dp1[0] = 0;

    for (let i = 1; i <= size1; i++) {
        for (let s = 0; s < m; s++) {
        dp2[s] = Number.MAX_SAFE_INTEGER / 2;
        for (let k = 0; k < size2; k++) {
            if ((s & (1 << k)) === 0) {
            continue;
            }
            dp2[s] = Math.min(dp2[s], dp2[s ^ (1 << k)] + cost[i - 1][k]);
            dp2[s] = Math.min(dp2[s], dp1[s] + cost[i - 1][k]);
            dp2[s] = Math.min(dp2[s], dp1[s ^ (1 << k)] + cost[i - 1][k]);
        }
        }
        dp1.splice(0, m, ...dp2);
    }

    return dp1[m - 1];
};
```

**复杂度分析**

+ 时间复杂度：$O(\textit{size}_1 \times \textit{size}_2 \times 2^{\textit{size}_2})$，其中 $\textit{size}_1$ 是第一组点数，$\textit{size}_2$ 是第二组点数。

+ 空间复杂度：$O(\textit{size}_1 \times 2^{\textit{size}_2})$ 或 $O(2^{\textit{size}_2})$。
#### 前言

为了叙述方便，我们令所有的变量都从 $0$ 开始编号，即：

- 房子的编号为 $[0, m-1]$；
- 颜色的编号为 $[0, n-1]$，如果房子没有涂上颜色，那么记为 $-1$；
- 街区的编号为 $[0, \textit{target}-1]$。

#### 方法一：动态规划

**思路与算法**

我们可以使用动态规划解决本题。

设 $\textit{dp}(i,j,k)$ 表示将 $[0, i]$ 的房子都涂上颜色，最末尾的第 $i$ 个房子的颜色为 $j$，并且它属于第 $k$ 个街区时，需要的最少花费。

在进行状态转移时，我们需要考虑「第 $i-1$ 个房子的颜色」，这关系到「花费」以及「街区数量」的计算，因此我们还需要对其进行枚举。

设第 $i-1$ 个房子的颜色为 $j_0$，我们可以分类讨论出不同情况下的状态转移方程：

- 如果 $\textit{houses}[i] \neq -1$，说明第 $i$ 个房子已经涂过颜色了。由于我们不能重复涂色，那么必须有 $\textit{houses}[i] = j$。我们可以写出在 $\textit{houses}[i] \neq j$ 时的状态转移方程：

    $$
    \textit{dp}(i, j, k) = \infty, \quad 如果~\textit{houses}[i] \neq -1~并且~\textit{houses}[i] \neq j
    $$

    这里我们用极大值 $\infty$ 表示不满足要求的状态，由于我们需要求出的是最少花费，因此极大值不会对状态转移产生影响。

    当 $\textit{houses}[i] = j$ 时，如果 $j=j_0$，那么第 $i-1$ 个房子和第 $i$ 个房子属于同一个街区，状态转移方程为：

    $$
    \textit{dp}(i, j, k) = \textit{dp}(i-1, j, k), \quad 如果~ \textit{houses}[i] = j
    $$

    如果 $j \neq j_0$，那么它们属于不同的街区，状态转移方程为：

    $$
    \textit{dp}(i, j, k) = \min_{j_0 \neq j} \textit{dp}(i-1,j_0, k-1), \quad 如果~ \textit{houses}[i] = j
    $$

- 如果 $\textit{houses}[i] = -1$，说明我们需要将第 $i$ 个房子涂成颜色 $j$，花费为 $\textit{cost}[i][j]$。

    此外的状态转移与上一类情况类似。如果 $j = j_0$，那么状态转移方程为：

    $$
    \textit{dp}(i, j, k) = \textit{dp}(i-1, j, k) + \textit{cost}[i][j], \quad 如果~\textit{houses}[i]=-1
    $$

    如果 $j \neq j_0$，那么状态转移方程为：

    $$
    \textit{dp}(i, j, k) = \min_{j_0 \neq j} \textit{dp}(i-1,j_0, k-1) + \textit{cost}[i][j], \quad 如果~\textit{houses}[i]=-1
    $$

最终的答案即为 $\min\limits_{j} \textit{dp}(m-1, j, \textit{target} - 1)$。

**细节**

以下的细节有助于写出更简洁的代码：

- 我们可以将所有的状态初始化为 $\infty$。在进行状态转移时，我们是选择转移中的最小值，因此 $\infty$ 不会产生影响；

- 两类情况下的状态转移方程十分类似，因此我们可以先不去管 $\textit{cost}[i][j]$ 的部分，在求出 $\textit{dp}(i, j, k)$ 的最小值之后，如果发现 $\textit{houses}[i]=-1$，再加上 $\textit{cost}[i][j]$ 即可；

- 当 $k=0$ 时，不能从包含 $k-1$ 的状态转移而来；

- 当 $i=0$ 时，第 $0$ 个房子之前没有房子，因此 $k$ 也必须为 $0$。此时状态转移方程为：

    $$
    \textit{dp}(0, j, 0) = \left\{ \begin{aligned}
    & \infty, && 如果~\textit{houses}[i] \neq -1 ~并且~\textit{houses}[i] \neq j \\
    & 0, && 如果~\textit{houses}[i] \neq -1 ~并且~\textit{houses}[i] = j \\
    & \textit{cost}[i][j], && 如果~\textit{houses}[i]=-1
    \end{aligned} \right.
    $$

    当 $i=0$ 且 $k \neq 0$ 时，$\textit{dp}(0, j, k) = \infty$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    // 极大值
    // 选择 INT_MAX / 2 的原因是防止整数相加溢出
    static constexpr int INFTY = INT_MAX / 2;

public:
    int minCost(vector<int>& houses, vector<vector<int>>& cost, int m, int n, int target) {
        // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
        for (int& c: houses) {
            --c;
        }

        // dp 所有元素初始化为极大值
        vector<vector<vector<int>>> dp(m, vector<vector<int>>(n, vector<int>(target, INFTY)));

        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (houses[i] != -1 && houses[i] != j) {
                    continue;
                }
                
                for (int k = 0; k < target; ++k) {
                    for (int j0 = 0; j0 < n; ++j0) {
                        if (j == j0) {
                            if (i == 0) {
                                if (k == 0) {
                                    dp[i][j][k] = 0;
                                }
                            }
                            else {
                                dp[i][j][k] = min(dp[i][j][k], dp[i - 1][j][k]);
                            }
                        }
                        else if (i > 0 && k > 0) {
                            dp[i][j][k] = min(dp[i][j][k], dp[i - 1][j0][k - 1]);
                        }
                    }

                    if (dp[i][j][k] != INFTY && houses[i] == -1) {
                        dp[i][j][k] += cost[i][j];
                    }
                }
            }
        }

        int ans = INFTY;
        for (int j = 0; j < n; ++j) {
            ans = min(ans, dp[m - 1][j][target - 1]);
        }
        return ans == INFTY ? -1 : ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    // 极大值
    // 选择 Integer.MAX_VALUE / 2 的原因是防止整数相加溢出
    static final int INFTY = Integer.MAX_VALUE / 2;

    public int minCost(int[] houses, int[][] cost, int m, int n, int target) {
        // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
        for (int i = 0; i < m; ++i) {
            --houses[i];
        }

        // dp 所有元素初始化为极大值
        int[][][] dp = new int[m][n][target];
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                Arrays.fill(dp[i][j], INFTY);
            }
        }

        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (houses[i] != -1 && houses[i] != j) {
                    continue;
                }
                
                for (int k = 0; k < target; ++k) {
                    for (int j0 = 0; j0 < n; ++j0) {
                        if (j == j0) {
                            if (i == 0) {
                                if (k == 0) {
                                    dp[i][j][k] = 0;
                                }
                            } else {
                                dp[i][j][k] = Math.min(dp[i][j][k], dp[i - 1][j][k]);
                            }
                        } else if (i > 0 && k > 0) {
                            dp[i][j][k] = Math.min(dp[i][j][k], dp[i - 1][j0][k - 1]);
                        }
                    }

                    if (dp[i][j][k] != INFTY && houses[i] == -1) {
                        dp[i][j][k] += cost[i][j];
                    }
                }
            }
        }

        int ans = INFTY;
        for (int j = 0; j < n; ++j) {
            ans = Math.min(ans, dp[m - 1][j][target - 1]);
        }
        return ans == INFTY ? -1 : ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    // 极大值
    // 选择 int.MaxValue / 2 的原因是防止整数相加溢出
    const int INFTY = int.MaxValue / 2;

    public int MinCost(int[] houses, int[][] cost, int m, int n, int target) {
        // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
        for (int i = 0; i < m; ++i) {
            --houses[i];
        }

        // dp 所有元素初始化为极大值
        int[,,] dp = new int[m, n, target];
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                for (int k = 0; k < target; ++k) {
                    dp[i, j, k] = INFTY;
                }
            }
        }

        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (houses[i] != -1 && houses[i] != j) {
                    continue;
                }
                
                for (int k = 0; k < target; ++k) {
                    for (int j0 = 0; j0 < n; ++j0) {
                        if (j == j0) {
                            if (i == 0) {
                                if (k == 0) {
                                    dp[i, j, k] = 0;
                                }
                            } else {
                                dp[i, j, k] = Math.Min(dp[i, j, k], dp[i - 1, j, k]);
                            }
                        } else if (i > 0 && k > 0) {
                            dp[i, j, k] = Math.Min(dp[i, j, k], dp[i - 1, j0, k - 1]);
                        }
                    }

                    if (dp[i, j, k] != INFTY && houses[i] == -1) {
                        dp[i, j, k] += cost[i][j];
                    }
                }
            }
        }

        int ans = INFTY;
        for (int j = 0; j < n; ++j) {
            ans = Math.Min(ans, dp[m - 1, j, target - 1]);
        }
        return ans == INFTY ? -1 : ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minCost(self, houses: List[int], cost: List[List[int]], m: int, n: int, target: int) -> int:
        # 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
        houses = [c - 1 for c in houses]

        # dp 所有元素初始化为极大值
        dp = [[[float("inf")] * target for _ in range(n)] for _ in range(m)]

        for i in range(m):
            for j in range(n):
                if houses[i] != -1 and houses[i] != j:
                    continue
                
                for k in range(target):
                    for j0 in range(n):
                        if j == j0:
                            if i == 0:
                                if k == 0:
                                    dp[i][j][k] = 0
                            else:
                                dp[i][j][k] = min(dp[i][j][k], dp[i - 1][j][k])
                        elif i > 0 and k > 0:
                            dp[i][j][k] = min(dp[i][j][k], dp[i - 1][j0][k - 1])

                    if dp[i][j][k] != float("inf") and houses[i] == -1:
                        dp[i][j][k] += cost[i][j]

        ans = min(dp[m - 1][j][target - 1] for j in range(n))
        return -1 if ans == float("inf") else ans
```

```JavaScript [sol1-JavaScript]
var minCost = function(houses, cost, m, n, target) {
    // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
    houses = houses.map(c => --c);
    const dp = new Array(m).fill(0)
                           .map(() => new Array(n).fill(0)
                           .map(() => new Array(target).fill(Number.MAX_VALUE)));
    
    // dp 所有元素初始化为极大值
    for (let i = 0; i < m; ++i) {
        for (let j = 0; j < n; ++j) {
            if (houses[i] !== -1 && houses[i] !== j) {
                continue;
            }
            
            for (let k = 0; k < target; ++k) {
                for (let j0 = 0; j0 < n; ++j0) {
                    if (j === j0) {
                        if (i === 0) {
                            if (k === 0) {
                                dp[i][j][k] = 0;
                            }
                        } else {
                            dp[i][j][k] = Math.min(dp[i][j][k], dp[i - 1][j][k]);
                        }
                    } else if (i > 0 && k > 0) {
                        dp[i][j][k] = Math.min(dp[i][j][k], dp[i - 1][j0][k - 1]);
                    }
                }

                if (dp[i][j][k] !== Number.MAX_VALUE && houses[i] === -1) {
                    dp[i][j][k] += cost[i][j];
                }
            }
        }
    }
    
    let ans = Number.MAX_VALUE;
    for (let j = 0; j < n; ++j) {
        ans = Math.min(ans, dp[m - 1][j][target - 1]);
    }
    return ans === Number.MAX_VALUE ? -1 : ans;
};
```

```go [sol1-Golang]
func minCost(houses []int, cost [][]int, m, n, target int) int {
    const inf = math.MaxInt64 / 2 // 防止整数相加溢出

    // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
    for i := range houses {
        houses[i]--
    }

    // dp 所有元素初始化为极大值
    dp := make([][][]int, m)
    for i := range dp {
        dp[i] = make([][]int, n)
        for j := range dp[i] {
            dp[i][j] = make([]int, target)
            for k := range dp[i][j] {
                dp[i][j][k] = inf
            }
        }
    }

    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if houses[i] != -1 && houses[i] != j {
                continue
            }

            for k := 0; k < target; k++ {
                for j0 := 0; j0 < n; j0++ {
                    if j == j0 {
                        if i == 0 {
                            if k == 0 {
                                dp[i][j][k] = 0
                            }
                        } else {
                            dp[i][j][k] = min(dp[i][j][k], dp[i-1][j][k])
                        }
                    } else if i > 0 && k > 0 {
                        dp[i][j][k] = min(dp[i][j][k], dp[i-1][j0][k-1])
                    }
                }

                if dp[i][j][k] != inf && houses[i] == -1 {
                    dp[i][j][k] += cost[i][j]
                }
            }
        }
    }

    ans := inf
    for _, res := range dp[m-1] {
        ans = min(ans, res[target-1])
    }
    if ans == inf {
        return -1
    }
    return ans
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```C [sol1-C]
// 极大值
// 选择 INT_MAX / 2 的原因是防止整数相加溢出
const int INFTY = 0x3f3f3f3f;

int minCost(int* houses, int housesSize, int** cost, int costSize, int* costColSize, int m, int n, int target) {
    // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
    for (int i = 0; i < housesSize; ++i) {
        houses[i]--;
    }

    // dp 所有元素初始化为极大值
    int dp[m][n][target];
    memset(dp, 0x3f, sizeof(dp));

    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            if (houses[i] != -1 && houses[i] != j) {
                continue;
            }

            for (int k = 0; k < target; ++k) {
                for (int j0 = 0; j0 < n; ++j0) {
                    if (j == j0) {
                        if (i == 0) {
                            if (k == 0) {
                                dp[i][j][k] = 0;
                            }
                        } else {
                            dp[i][j][k] = fmin(dp[i][j][k], dp[i - 1][j][k]);
                        }
                    } else if (i > 0 && k > 0) {
                        dp[i][j][k] = fmin(dp[i][j][k], dp[i - 1][j0][k - 1]);
                    }
                }

                if (dp[i][j][k] != INFTY && houses[i] == -1) {
                    dp[i][j][k] += cost[i][j];
                }
            }
        }
    }

    int ans = INFTY;
    for (int j = 0; j < n; ++j) {
        ans = fmin(ans, dp[m - 1][j][target - 1]);
    }
    return ans == INFTY ? -1 : ans;
}
```

**复杂度分析**

- 时间复杂度：$O(m\cdot n^2\cdot \textit{target})$。状态的数量为 $O(m\cdot n\cdot \textit{target})$，每个状态需要 $O(n)$ 的时间枚举 $j_0$，因此总时间复杂度为 $O(m\cdot n^2\cdot \textit{target})$。

- 空间复杂度：$O(m \cdot n \cdot \textit{target})$，即为状态的数量。

    注意到 $\textit{dp}(i,j,k)$ 只会从 $\textit{dp}(i-1, \cdots, \cdots)$ 转移而来，因此我们可以使用滚动数组对空间复杂度进行优化，即使用两个大小为 $n \cdot \textit{target}$ 的数组 $\textit{dp}_1$, $\textit{dp}_2$，将 $dp(0,j,k)$ 的值存储在 $\textit{dp}_1$ 中，将 $dp(1,j,k)$ 的值存储在 $\textit{dp}_2$ 中，将 $dp(2,j,k)$ 的值存储在 $\textit{dp}_1$ 中，将 $dp(3,j,k)$ 的值存储在 $\textit{dp}_2$ 中，以此类推。这样优化后的空间复杂度为 $O(n\cdot \textit{target})$。


#### 方法二：动态规划 + 优化

**思路与算法**

在方法一中，我们分类讨论出了五种不同的状态转移方程，其中有三种是可以在 $O(1)$ 的时间进行状态转移的，而剩余的两种需要枚举 $j_0$，只能在 $O(n)$ 的时间进行转移，即：

$$
\textit{dp}(i, j, k) = \min_{j_0 \neq j} \textit{dp}(i-1,j_0, k-1), \quad 如果~ \textit{houses}[i] = j
$$

以及：

$$
\textit{dp}(i, j, k) = \min_{j_0 \neq j} \textit{dp}(i-1,j_0, k-1) + \textit{cost}[i][j], \quad 如果~\textit{houses}[i]=-1
$$

如果我们能将它们优化至 $O(1)$，那么整个动态规划的时间复杂度也可以从 $O(m\cdot n^2\cdot \textit{target})$ 优化至 $O(m \cdot n \cdot \textit{target})$。

我们可以令 $\textit{best}(i, k) = (\textit{first}, \textit{first\_idx}, \textit{second})$，表示所有的状态 $dp(i, j, k)$ 中的最小值为 $\textit{first}$，取到最小值对应的 $j$ 值为 $\textit{first\_idx}$，次小值为 $\textit{second}$。这里 $j$ 可以在 $[0, n)$ 中任意选择，但我们只记录最大值和次大值，以及最大值对应的 $j$。

这样做的好处在于我们可以快速地求出原先需要 $O(n)$ 的时间才能求出的：

$$
\min_{j_0 \neq j} \textit{dp}(i-1,j_0, k-1)
$$

这一项。即：

- 我们取出 $\textit{best}(i - 1, k - 1)$，它包含的三个值为 $(\textit{first}, \textit{first\_idx}, \textit{second})$；

- 如果 $j = \textit{first\_idx}$，那么 $\textit{dp}(i, j, k) = \textit{second}$；

- 如果 $j \neq \textit{first\_idx}$，那么 $\textit{dp}(i, j, k) = \textit{first}$。

这样做的正确性通过 $\min\limits_{j_0 \neq j} \textit{dp}(i-1,j_0, k-1)$ 本身的定义就能体现。

那么如何求出 $\textit{best}(i, k)$ 呢？我们可以给每一个 $\textit{best}(i, k)$ 赋予初始值 $(\infty, -1, \infty)$，每次我们计算出 $\textit{dp}(i, j, k)$ 时，使用其更新 $\textit{best}(i, k)$ 即可。

**代码**

方法二的代码较为复杂，主要的原因在于我们需要将方法一中的 $O(n)$ 枚举 $j_0$ 的循环删除，并且需要保持方法一中的边界条件不变。

```C++ [sol2-C++]
class Solution {
private:
    // 极大值
    // 选择 INT_MAX / 2 的原因是防止整数相加溢出
    static constexpr int INFTY = INT_MAX / 2;

    using TIII = tuple<int, int, int>;

public:
    int minCost(vector<int>& houses, vector<vector<int>>& cost, int m, int n, int target) {
        // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
        for (int& c: houses) {
            --c;
        }

        // dp 所有元素初始化为极大值
        vector<vector<vector<int>>> dp(m, vector<vector<int>>(n, vector<int>(target, INFTY)));
        vector<vector<TIII>> best(m, vector<TIII>(target, {INFTY, -1, INFTY}));

        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (houses[i] != -1 && houses[i] != j) {
                    continue;
                }
                
                for (int k = 0; k < target; ++k) {
                    if (i == 0) {
                        if (k == 0) {
                            dp[i][j][k] = 0;
                        }
                    }
                    else {
                        dp[i][j][k] = dp[i - 1][j][k];
                        if (k > 0) {
                            // 使用 best(i-1,k-1) 直接得到 dp(i,j,k) 的值
                            auto&& [first, first_idx, second] = best[i - 1][k - 1];
                            dp[i][j][k] = min(dp[i][j][k], (j == first_idx ? second : first));
                        }
                    }

                    if (dp[i][j][k] != INFTY && houses[i] == -1) {
                        dp[i][j][k] += cost[i][j];
                    }

                    // 用 dp(i,j,k) 更新 best(i,k)
                    auto&& [first, first_idx, second] = best[i][k];
                    if (dp[i][j][k] < first) {
                        second = first;
                        first = dp[i][j][k];
                        first_idx = j;
                    }
                    else if (dp[i][j][k] < second) {
                        second = dp[i][j][k];
                    }
                }
            }
        }

        int ans = INFTY;
        for (int j = 0; j < n; ++j) {
            ans = min(ans, dp[m - 1][j][target - 1]);
        }
        return ans == INFTY ? -1 : ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    // 极大值
    // 选择 Integer.MAX_VALUE / 2 的原因是防止整数相加溢出
    static final int INFTY = Integer.MAX_VALUE / 2;

    public int minCost(int[] houses, int[][] cost, int m, int n, int target) {
        // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
        for (int i = 0; i < m; ++i) {
            --houses[i];
        }

        // dp 所有元素初始化为极大值
        int[][][] dp = new int[m][n][target];
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                Arrays.fill(dp[i][j], INFTY);
            }
        }
        int[][][] best = new int[m][target][3];
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < target; ++j) {
                best[i][j][0] = best[i][j][2] = INFTY;
                best[i][j][1] = -1;
            }
        }

        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (houses[i] != -1 && houses[i] != j) {
                    continue;
                }
                
                for (int k = 0; k < target; ++k) {
                    if (i == 0) {
                        if (k == 0) {
                            dp[i][j][k] = 0;
                        }
                    } else {
                        dp[i][j][k] = dp[i - 1][j][k];
                        if (k > 0) {
                            // 使用 best(i-1,k-1) 直接得到 dp(i,j,k) 的值
                            int first = best[i - 1][k - 1][0];
                            int firstIdx = best[i - 1][k - 1][1];
                            int second = best[i - 1][k - 1][2];
                            dp[i][j][k] = Math.min(dp[i][j][k], (j == firstIdx ? second : first));
                        }
                    }

                    if (dp[i][j][k] != INFTY && houses[i] == -1) {
                        dp[i][j][k] += cost[i][j];
                    }

                    // 用 dp(i,j,k) 更新 best(i,k)
                    int first = best[i][k][0];
                    int firstIdx = best[i][k][1];
                    int second = best[i][k][2];
                    if (dp[i][j][k] < first) {
                        best[i][k][2] = first;
                        best[i][k][0] = dp[i][j][k];
                        best[i][k][1] = j;
                    } else if (dp[i][j][k] < second) {
                        best[i][k][2] = dp[i][j][k];
                    }
                }
            }
        }

        int ans = INFTY;
        for (int j = 0; j < n; ++j) {
            ans = Math.min(ans, dp[m - 1][j][target - 1]);
        }
        return ans == INFTY ? -1 : ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    // 极大值
    // 选择 int.MaxValue / 2 的原因是防止整数相加溢出
    const int INFTY = int.MaxValue / 2;

    public int MinCost(int[] houses, int[][] cost, int m, int n, int target) {
        // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
        for (int i = 0; i < m; ++i) {
            --houses[i];
        }

        // dp 所有元素初始化为极大值
        int[,,] dp = new int[m, n, target];
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                for (int k = 0; k < target; ++k) {
                    dp[i, j, k] = INFTY;
                }
            }
        }
        int[,,] best = new int[m, target, 3];
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < target; ++j) {
                best[i, j, 0] = best[i, j, 2] = INFTY;
                best[i, j, 1] = -1;
            }
        }

        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                if (houses[i] != -1 && houses[i] != j) {
                    continue;
                }
                
                for (int k = 0; k < target; ++k) {
                    if (i == 0) {
                        if (k == 0) {
                            dp[i, j, k] = 0;
                        }
                    } else {
                        dp[i, j, k] = dp[i - 1, j, k];
                        if (k > 0) {
                            // 使用 best(i-1,k-1) 直接得到 dp(i,j,k) 的值
                            dp[i, j, k] = Math.Min(dp[i, j, k], (j == best[i - 1, k - 1, 1] ? best[i - 1, k - 1, 2] : best[i - 1, k - 1, 0]));
                        }
                    }

                    if (dp[i, j, k] != INFTY && houses[i] == -1) {
                        dp[i, j, k] += cost[i][j];
                    }

                    // 用 dp(i,j,k) 更新 best(i,k)
                    int first = best[i, k, 0];
                    int firstIdx = best[i, k, 1];
                    int second = best[i, k, 2];
                    if (dp[i, j, k] < first) {
                        best[i, k, 2] = first;
                        best[i, k, 0] = dp[i, j, k];
                        best[i, k, 1] = j;
                    } else if (dp[i, j, k] < second) {
                        best[i, k, 2] = dp[i, j, k];
                    }
                }
            }
        }

        int ans = INFTY;
        for (int j = 0; j < n; ++j) {
            ans = Math.Min(ans, dp[m - 1, j, target - 1]);
        }
        return ans == INFTY ? -1 : ans;
    }
}
```

```Python [sol2-Python3]
class Entry:
    def __init__(self):
        self.first = float("inf")
        self.first_idx = -1
        self.second = float("inf")

class Solution:
    def minCost(self, houses: List[int], cost: List[List[int]], m: int, n: int, target: int) -> int:
        # 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
        houses = [c - 1 for c in houses]

        # dp 所有元素初始化为极大值
        dp = [[[float("inf")] * target for _ in range(n)] for _ in range(m)]
        best = [[Entry() for _ in range(target)] for _ in range(m)]

        for i in range(m):
            for j in range(n):
                if houses[i] != -1 and houses[i] != j:
                    continue
                
                for k in range(target):
                    if i == 0:
                        if k == 0:
                            dp[i][j][k] = 0
                    else:
                        dp[i][j][k] = dp[i - 1][j][k]
                        if k > 0:
                            # 使用 best(i-1,k-1) 直接得到 dp(i,j,k) 的值
                            info = best[i - 1][k - 1]
                            dp[i][j][k] = min(dp[i][j][k], (info.second if j == info.first_idx else info.first))

                    if dp[i][j][k] != float("inf") and houses[i] == -1:
                        dp[i][j][k] += cost[i][j]
                    
                    # 用 dp(i,j,k) 更新 best(i,k)
                    info = best[i][k]
                    if dp[i][j][k] < info.first:
                        info.second = info.first
                        info.first = dp[i][j][k]
                        info.first_idx = j
                    elif dp[i][j][k] < info.second:
                        info.second = dp[i][j][k]

        ans = min(dp[m - 1][j][target - 1] for j in range(n))
        return -1 if ans == float("inf") else ans
```

```go [sol2-Golang]
type entry struct {
    first, firstIdx, second int
}

func minCost(houses []int, cost [][]int, m, n, target int) int {
    const inf = math.MaxInt64 / 2 // 防止整数相加溢出

    // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
    for i := range houses {
        houses[i]--
    }

    // dp 所有元素初始化为极大值
    dp := make([][][]int, m)
    for i := range dp {
        dp[i] = make([][]int, n)
        for j := range dp[i] {
            dp[i][j] = make([]int, target)
            for k := range dp[i][j] {
                dp[i][j][k] = inf
            }
        }
    }
    best := make([][]entry, m)
    for i := range best {
        best[i] = make([]entry, target)
        for j := range best[i] {
            best[i][j] = entry{inf, -1, inf}
        }
    }

    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            if houses[i] != -1 && houses[i] != j {
                continue
            }

            for k := 0; k < target; k++ {
                if i == 0 {
                    if k == 0 {
                        dp[i][j][k] = 0
                    }
                } else {
                    dp[i][j][k] = dp[i-1][j][k]
                    if k > 0 {
                        // 使用 best(i-1,k-1) 直接得到 dp(i,j,k) 的值
                        if b := best[i-1][k-1]; j == b.firstIdx {
                            dp[i][j][k] = min(dp[i][j][k], b.second)
                        } else {
                            dp[i][j][k] = min(dp[i][j][k], b.first)
                        }
                    }
                }

                if dp[i][j][k] != inf && houses[i] == -1 {
                    dp[i][j][k] += cost[i][j]
                }

                // 用 dp(i,j,k) 更新 best(i,k)
                if b := &best[i][k]; dp[i][j][k] < b.first {
                    b.second = b.first
                    b.first = dp[i][j][k]
                    b.firstIdx = j
                } else if dp[i][j][k] < b.second {
                    b.second = dp[i][j][k]
                }
            }
        }
    }

    ans := inf
    for _, res := range dp[m-1] {
        ans = min(ans, res[target-1])
    }
    if ans == inf {
        return -1
    }
    return ans
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```C [sol2-C]
struct TIII {
    int first, first_idx, second;
};

// 极大值
// 选择 INT_MAX / 2 的原因是防止整数相加溢出
const int INFTY = 0x3f3f3f3f;

int minCost(int* houses, int housesSize, int** cost, int costSize, int* costColSize, int m, int n, int target) {
    // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
    for (int i = 0; i < housesSize; ++i) {
        houses[i]--;
    }

    // dp 所有元素初始化为极大值
    int dp[m][n][target];
    memset(dp, 0x3f, sizeof(dp));
    struct TIII best[m][target];
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < target; j++) {
            best[i][j] = (struct TIII){INFTY, -1, INFTY};
        }
    }

    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            if (houses[i] != -1 && houses[i] != j) {
                continue;
            }

            for (int k = 0; k < target; ++k) {
                if (i == 0) {
                    if (k == 0) {
                        dp[i][j][k] = 0;
                    }
                } else {
                    dp[i][j][k] = dp[i - 1][j][k];
                    if (k > 0) {
                        // 使用 best(i-1,k-1) 直接得到 dp(i,j,k) 的值
                        struct TIII* tmp = &best[i - 1][k - 1];
                        dp[i][j][k] = fmin(dp[i][j][k], (j == tmp->first_idx ? tmp->second : tmp->first));
                    }
                }

                if (dp[i][j][k] != INFTY && houses[i] == -1) {
                    dp[i][j][k] += cost[i][j];
                }

                // 用 dp(i,j,k) 更新 best(i,k)
                struct TIII* tmp = &best[i][k];
                if (dp[i][j][k] < tmp->first) {
                    tmp->second = tmp->first;
                    tmp->first = dp[i][j][k];
                    tmp->first_idx = j;
                } else if (dp[i][j][k] < tmp->second) {
                    tmp->second = dp[i][j][k];
                }
            }
        }
    }

    int ans = INFTY;
    for (int j = 0; j < n; ++j) {
        ans = fmin(ans, dp[m - 1][j][target - 1]);
    }
    return ans == INFTY ? -1 : ans;
}
```

```JavaScript [sol2-JavaScript]
var minCost = function(houses, cost, m, n, target) {
    const INFTY = Number.MAX_VALUE;

    // 将颜色调整为从 0 开始编号，没有被涂色标记为 -1
    for (let i = 0; i < m; ++i) {
        --houses[i];
    }

    // dp 所有元素初始化为极大值
    const dp = new Array(m).fill(0).map(() => new Array(n).fill(0).map(() => new Array(target).fill(INFTY)));
    const best = new Array(m).fill(0).map(() => new Array(target).fill(0).map(() => new Array(3).fill(INFTY)));
    for (let i = 0; i < m; ++i) {
        for (let j = 0; j < target; ++j) {
            // best[i][j][0] = best[i][j][2] = INFTY;
            best[i][j][1] = -1;
        }
    }

    for (let i = 0; i < m; ++i) {
        for (let j = 0; j < n; ++j) {
            if (houses[i] !== -1 && houses[i] !== j) {
                continue;
            }

            for (let k = 0; k < target; ++k) {
                if (i === 0) {
                    if (k === 0) {
                        dp[i][j][k] = 0;
                    }
                } else {
                    dp[i][j][k] = dp[i - 1][j][k];
                    if (k > 0) {
                        // 使用 best(i-1,k-1) 直接得到 dp(i,j,k) 的值
                        const first = best[i - 1][k - 1][0];
                        const firstIdx = best[i - 1][k - 1][1];
                        const second = best[i - 1][k - 1][2];
                        dp[i][j][k] = Math.min(dp[i][j][k], (j === firstIdx ? second : first));
                    }
                }

                if (dp[i][j][k] !== INFTY && houses[i] === -1) {
                    dp[i][j][k] += cost[i][j];
                }

                // 用 dp(i,j,k) 更新 best(i,k)
                const first = best[i][k][0];
                const firstIdx = best[i][k][1];
                const second = best[i][k][2];
                if (dp[i][j][k] < first) {
                    best[i][k][2] = first;
                    best[i][k][0] = dp[i][j][k];
                    best[i][k][1] = j;
                } else if (dp[i][j][k] < second) {
                    best[i][k][2] = dp[i][j][k];
                }
            }
        }
    }
    let ans = INFTY;
    for (let j = 0; j < n; ++j) {
        ans = Math.min(ans, dp[m - 1][j][target - 1]);
    }
    return ans === INFTY ? -1 : ans;
};
```

**复杂度分析**

- 时间复杂度：$O(m\cdot n\cdot \textit{target})$。状态的数量为 $O(m\cdot n\cdot \textit{target})$，每个状态只需要 $O(1)$ 的时间进行计算，同时需要 $O(1)$ 的时间来更新 $\textit{best}$，因此总时间复杂度为 $O(m\cdot n\cdot \textit{target})$。

- 空间复杂度：$O(m\cdot n \cdot \textit{target})$，即为状态的数量。除此之外，我们需要 $O(m \cdot \textit{target})$ 的空间存储 $\textit{best}$，但其在渐进意义下小于前者，因此可以忽略。

    与方法一相同，我们也可以将空间复杂度优化至 $O(n\cdot \textit{target})$。
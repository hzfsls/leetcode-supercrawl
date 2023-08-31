## [265.粉刷房子 II 中文官方题解](https://leetcode.cn/problems/paint-house-ii/solutions/100000/fen-shua-fang-zi-ii-by-leetcode-solution-jz9b)
#### 方法一：动态规划

这道题是「[256. 粉刷房子](https://leetcode.cn/problems/paint-house/)」的进阶，每个房子可以被粉刷成 $k$ 种颜色中的一种。和第 256 题相似，这道题可以使用动态规划计算最小花费成本。

用 $\textit{dp}[i][j]$ 表示粉刷第 $0$ 号房子到第 $i$ 号房子且第 $i$ 号房子被粉刷成第 $j$ 种颜色时的最小花费成本。由于一共有 $n$ 个房子和 $k$ 种颜色，因此 $0 \le i < n$，$0 \le j < k$。

当只有第 $0$ 号房子被粉刷时，对于每一种颜色，总花费成本即为将第 $0$ 号房子粉刷成该颜色的花费成本，因此边界条件是：对于任意 $0 \le j < k$，$\textit{dp}[0][j] = \textit{costs}[0][j]$。

对于 $1 \le i < n$，第 $i$ 号房子和第 $i - 1$ 号房子的颜色必须不同，因此当第 $i$ 号房子被粉刷成某一种颜色时，第 $i - 1$ 号房子只能被粉刷成另外 $k - 1$ 种颜色之一。对于 $1 \le i < n$ 和 $0 \le j < k$，状态转移方程如下：

$$
\textit{dp}[i][j] = \min_{0 \le t < k, t \ne j}(\textit{dp}[i - 1][t]) + \textit{costs}[i][j]
$$

计算结束时，$\textit{dp}[n - 1]$ 中的最小值即为粉刷所有房子的最小花费成本。

当 $i \ge 1$ 时，由于 $\textit{dp}[i]$ 的计算只和 $\textit{dp}[i - 1]$ 有关，因此可以使用滚动数组优化空间，将空间复杂度降低到 $O(k)$。

```Python [sol1-Python3]
class Solution:
    def minCostII(self, costs: List[List[int]]) -> int:
        k = len(costs[0])
        dp = costs[0]
        for i in range(1, len(costs)):
            dp = [min(dp[j - t] for t in range(1, k)) + c for j, c in enumerate(costs[i])]
        return min(dp)
```

```Java [sol1-Java]
class Solution {
    public int minCostII(int[][] costs) {
        int n = costs.length, k = costs[0].length;
        int[] dp = new int[k];
        for (int j = 0; j < k; j++) {
            dp[j] = costs[0][j];
        }
        for (int i = 1; i < n; i++) {
            int[] dpNew = new int[k];
            for (int j = 0; j < k; j++) {
                int prevMin = Integer.MAX_VALUE;
                for (int t = 0; t < k; t++) {
                    if (t != j) {
                        prevMin = Math.min(prevMin, dp[t]);
                    }
                }
                dpNew[j] = prevMin + costs[i][j];
            }
            dp = dpNew;
        }
        return Arrays.stream(dp).min().getAsInt();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinCostII(int[][] costs) {
        int n = costs.Length, k = costs[0].Length;
        int[] dp = new int[k];
        for (int j = 0; j < k; j++) {
            dp[j] = costs[0][j];
        }
        for (int i = 1; i < n; i++) {
            int[] dpNew = new int[k];
            for (int j = 0; j < k; j++) {
                int prevMin = int.MaxValue;
                for (int t = 0; t < k; t++) {
                    if (t != j) {
                        prevMin = Math.Min(prevMin, dp[t]);
                    }
                }
                dpNew[j] = prevMin + costs[i][j];
            }
            dp = dpNew;
        }
        return dp.Min();
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minCostII(vector<vector<int>>& costs) {
        int n = costs.size(), k = costs[0].size();
        vector<int> dp = costs[0];
        for (int i = 1; i < n; i++) {
            vector<int> dpNew(k);
            for (int j = 0; j < k; j++) {
                int prevMin = INT_MAX;
                for (int t = 0; t < k; t++) {
                    if (t != j) {
                        prevMin = min(prevMin, dp[t]);
                    }
                }
                dpNew[j] = prevMin + costs[i][j];
            }
            dp = move(dpNew);
        }
        return *min_element(dp.begin(), dp.end());
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minCostII(int** costs, int costsSize, int* costsColSize){
    int n = costsSize, k = costsColSize[0];
    int *dp = (int *)malloc(sizeof(int) * k);
    int *dpNew = (int *)malloc(sizeof(int) * k);
    memcpy(dp, costs[0], sizeof(int) * k);
    for (int i = 1; i < n; i++) {
        for (int j = 0; j < k; j++) {
            int prevMin = INT_MAX;
            for (int t = 0; t < k; t++) {
                if (t != j) {
                    prevMin = MIN(prevMin, dp[t]);
                }
            }
            dpNew[j] = prevMin + costs[i][j];
        }
        memcpy(dp, dpNew, sizeof(int) * k);
    }
    int res = INT_MAX;
    for (int i = 0; i < k; i++) {
        res = MIN(res, dp[i]);
    }
    free(dp);
    free(dpNew);
    return res;
}
```

```JavaScript [sol1-JavaScript]
var minCostII = function(costs) {
    const n = costs.length, k = costs[0].length;
    let dp = new Array(k).fill(0);
    for (let j = 0; j < k; j++) {
        dp[j] = costs[0][j];
    }
    for (let i = 1; i < n; i++) {
        let dpNew = new Array(k).fill(0);
        for (let j = 0; j < k; j++) {
            let prevMin = Number.MAX_VALUE;
            for (let t = 0; t < k; t++) {
                if (t !== j) {
                    prevMin = Math.min(prevMin, dp[t]);
                }
            }
            dpNew[j] = prevMin + costs[i][j];
        }
        dp = dpNew;
    }
    return parseInt(_.min(dp));
}
```

```go [sol1-Golang]
func minCostII(costs [][]int) int {
    k := len(costs[0])
    dp := costs[0]
    for _, cost := range costs[1:] {
        dpNew := make([]int, k)
        for j, c := range cost {
            prevMin := math.MaxInt32
            for t, v := range dp {
                if t != j {
                    prevMin = min(prevMin, v)
                }
            }
            dpNew[j] = prevMin + c
        }
        dp = dpNew
    }
    ans := dp[0]
    for _, v := range dp[1:] {
        ans = min(ans, v)
    }
    return ans
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(nk^2)$，其中 $n$ 是房子个数，$k$ 是颜色数量。需要遍历全部房子一次，对于每个房子分别需要计算该房子被粉刷成每一种颜色时的最小花费成本，由于对一种颜色计算最小花费成本需要 $O(k)$ 的时间，因此总时间复杂度是 $O(k \times nk) = O(nk^2)$。

- 空间复杂度：$O(k)$，其中 $k$ 是颜色数量。使用空间优化的方法，只需要维护一个长度为 $k$ 的数组，空间复杂度是 $O(k)$。

#### 方法二：优化的动态规划

方法一的时间复杂度较高，因为计算每个状态值的时候遍历了上一个位置的 $k$ 个状态寻找最小值，计算每个状态需要 $O(k)$ 的时间。可以换一种做法，遍历到每个位置时维护该位置的状态值中的最小值和次小值，则不需要遍历上一个位置的 $k$ 个状态寻找最小状态值，计算每个状态的时间即可降低到 $O(1)$。

当 $i > 0$ 时，用 $\textit{first}$ 和 $\textit{second}$ 分别表示 $\textit{dp}[i - 1]$ 中的最小值和次小值，$\textit{first}$ 和 $\textit{second}$ 可能相等，则对于 $0 \le j < k$，计算 $\textit{dp}[i][j]$ 时即可直接得到 $\textit{dp}[i - 1]$ 中除了 $\textit{dp}[i - 1][j]$ 以外的最小值，并得到新的状态转移方程：

- 如果 $\textit{dp}[i - 1][j] \ne \textit{first}$，则 $\textit{first}$ 为 $\textit{dp}[i - 1]$ 中除了 $\textit{dp}[i - 1][j]$ 以外的最小值，$\textit{dp}[i][j] = \textit{first} + \textit{costs}[i][j]$；

- 如果 $\textit{dp}[i - 1][j] = \textit{first}$，则 $\textit{second}$ 为 $\textit{dp}[i - 1]$ 中除了 $\textit{dp}[i - 1][j]$ 以外的最小值，$\textit{dp}[i][j] = \textit{second} + \textit{costs}[i][j]$，该结论对于 $\textit{first} = \textit{second}$ 和 $\textit{first} \ne \textit{second}$ 都成立。

利用新的状态转移方程，计算每个状态的时间降低到 $O(1)$，总时间复杂度降低到 $O(nk)$。

当 $i \ge 1$ 时，由于 $\textit{dp}[i]$ 的计算只和 $\textit{dp}[i - 1]$ 有关，因此可以使用滚动数组优化空间，将空间复杂度降低到 $O(k)$。

```Python [sol2-Python3]
class Solution:
    def minCostII(self, costs: List[List[int]]) -> int:
        k = len(costs[0])
        dp = costs[0]
        first, second = inf, inf
        for v in dp:
            if v < first:
                first, second = v, first
            elif v < second:
                second = v
        for i in range(1, len(costs)):
            dpNew = [0] * k
            firstNew, secondNew = inf, inf
            for j, c in enumerate(costs[i]):
                prevMin = second if dp[j] == first else first
                dpNew[j] = prevMin + c
                if dpNew[j] < firstNew:
                    firstNew, secondNew = dpNew[j], firstNew
                elif dpNew[j] < secondNew:
                    secondNew = dpNew[j]
            dp, first, second = dpNew, firstNew, secondNew
        return min(dp)
```

```Java [sol2-Java]
class Solution {
    public int minCostII(int[][] costs) {
        int n = costs.length, k = costs[0].length;
        int[] dp = new int[k];
        int first = Integer.MAX_VALUE, second = Integer.MAX_VALUE;
        for (int j = 0; j < k; j++) {
            dp[j] = costs[0][j];
            if (dp[j] < first) {
                second = first;
                first = dp[j];
            } else if (dp[j] < second) {
                second = dp[j];
            }
        }
        for (int i = 1; i < n; i++) {
            int[] dpNew = new int[k];
            int firstNew = Integer.MAX_VALUE, secondNew = Integer.MAX_VALUE;
            for (int j = 0; j < k; j++) {
                int prevMin = dp[j] != first ? first : second;
                dpNew[j] = prevMin + costs[i][j];
                if (dpNew[j] < firstNew) {
                    secondNew = firstNew;
                    firstNew = dpNew[j];
                } else if (dpNew[j] < secondNew) {
                    secondNew = dpNew[j];
                }
            }
            dp = dpNew;
            first = firstNew;
            second = secondNew;
        }
        return Arrays.stream(dp).min().getAsInt();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinCostII(int[][] costs) {
        int n = costs.Length, k = costs[0].Length;
        int[] dp = new int[k];
        int first = int.MaxValue, second = int.MaxValue;
        for (int j = 0; j < k; j++) {
            dp[j] = costs[0][j];
            if (dp[j] < first) {
                second = first;
                first = dp[j];
            } else if (dp[j] < second) {
                second = dp[j];
            }
        }
        for (int i = 1; i < n; i++) {
            int[] dpNew = new int[k];
            int firstNew = int.MaxValue, secondNew = int.MaxValue;
            for (int j = 0; j < k; j++) {
                int prevMin = dp[j] != first ? first : second;
                dpNew[j] = prevMin + costs[i][j];
                if (dpNew[j] < firstNew) {
                    secondNew = firstNew;
                    firstNew = dpNew[j];
                } else if (dpNew[j] < secondNew) {
                    secondNew = dpNew[j];
                }
            }
            dp = dpNew;
            first = firstNew;
            second = secondNew;
        }
        return dp.Min();
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int minCostII(vector<vector<int>>& costs) {
        int n = costs.size(), k = costs[0].size();
        vector<int> dp(k);
        int first = INT_MAX, second = INT_MAX;
        for (int j = 0; j < k; j++) {
            dp[j] = costs[0][j];
            if (dp[j] < first) {
                second = first;
                first = dp[j];
            } else if (dp[j] < second) {
                second = dp[j];
            }
        }
        for (int i = 1; i < n; i++) {
            vector<int> dpNew(k);
            int firstNew = INT_MAX, secondNew = INT_MAX;
            for (int j = 0; j < k; j++) {
                int prevMin = dp[j] != first ? first : second;
                dpNew[j] = prevMin + costs[i][j];
                if (dpNew[j] < firstNew) {
                    secondNew = firstNew;
                    firstNew = dpNew[j];
                } else if (dpNew[j] < secondNew) {
                    secondNew = dpNew[j];
                }
            }
            dp = move(dpNew);
            first = firstNew;
            second = secondNew;
        }
        return *min_element(dp.begin(), dp.end());
    }
};
```

```C [sol2-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minCostII(int** costs, int costsSize, int* costsColSize) {
    int n = costsSize, k = costsColSize[0];
    int *dp = (int *)malloc(sizeof(int) * k);
    int *dpNew = (int *)malloc(sizeof(int) * k);
    int first = INT_MAX, second = INT_MAX;
    for (int j = 0; j < k; j++) {
        dp[j] = costs[0][j];
        if (dp[j] < first) {
            second = first;
            first = dp[j];
        } else if (dp[j] < second) {
            second = dp[j];
        }
    }
    for (int i = 1; i < n; i++) {
        int firstNew = INT_MAX, secondNew = INT_MAX;
        for (int j = 0; j < k; j++) {
            int prevMin = dp[j] != first ? first : second;
            dpNew[j] = prevMin + costs[i][j];
            if (dpNew[j] < firstNew) {
                secondNew = firstNew;
                firstNew = dpNew[j];
            } else if (dpNew[j] < secondNew) {
                secondNew = dpNew[j];
            }
        }
        memcpy(dp, dpNew, sizeof(int) * k);
        first = firstNew;
        second = secondNew;
    }
    int res = INT_MAX;
    for (int i = 0; i < k; i++) {
        res = MIN(res, dp[i]);
    }
    free(dp);
    free(dpNew);
    return res;
}
```

```JavaScript [sol2-JavaScript]
var minCostII = function(costs) {
    const n = costs.length, k = costs[0].length;
    let dp = new Array(k).fill(0);
    let first = Number.MAX_VALUE, second = Number.MAX_VALUE;
    for (let j = 0; j < k; j++) {
        dp[j] = costs[0][j];
        if (dp[j] < first) {
            second = first;
            first = dp[j];
        } else if (dp[j] < second) {
            second = dp[j];
        }
    }
    for (let i = 1; i < n; i++) {
        let dpNew = new Array(k).fill(0);
        let firstNew = Number.MAX_VALUE, secondNew = Number.MAX_VALUE;
        for (let j = 0; j < k; j++) {
            const prevMin = dp[j] !== first ? first : second;
            dpNew[j] = prevMin + costs[i][j];
            if (dpNew[j] < firstNew) {
                secondNew = firstNew;
                firstNew = dpNew[j];
            } else if (dpNew[j] < secondNew) {
                secondNew = dpNew[j];
            }
        }
        dp = dpNew;
        first = firstNew;
        second = secondNew;
    }
    return parseInt(_.min(dp));
}
```

```go [sol2-Golang]
func minCostII(costs [][]int) int {
    k := len(costs[0])
    first, second := math.MaxInt32, math.MaxInt32
    dp := costs[0]
    for _, v := range dp {
        if v < first {
            first, second = v, first
        } else if v < second {
            second = v
        }
    }
    for _, cost := range costs[1:] {
        dpNew := make([]int, k)
        firstNew, secondNew := math.MaxInt32, math.MaxInt32
        for j, c := range cost {
            prevMin := first
            if dp[j] == first {
                prevMin = second
            }
            dpNew[j] = prevMin + c
            if dpNew[j] < firstNew {
                firstNew, secondNew = dpNew[j], firstNew
            } else if dpNew[j] < secondNew {
                secondNew = dpNew[j]
            }
        }
        dp, first, second = dpNew, firstNew, secondNew
    }
    ans := dp[0]
    for _, v := range dp[1:] {
        ans = min(ans, v)
    }
    return ans
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(nk)$，其中 $n$ 是房子个数，$k$ 是颜色数量。需要遍历全部房子一次，对于每个房子分别需要计算该房子被粉刷成每一种颜色时的最小花费成本，由于对一种颜色计算最小花费成本需要 $O(1)$ 的时间，因此总时间复杂度是 $O(nk)$。

- 空间复杂度：$O(k)$，其中 $k$ 是颜色数量。使用空间优化的方法，只需要维护一个长度为 $k$ 的数组，空间复杂度是 $O(k)$。
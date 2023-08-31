## [787.K 站中转内最便宜的航班 中文官方题解](https://leetcode.cn/problems/cheapest-flights-within-k-stops/solutions/100000/k-zhan-zhong-zhuan-nei-zui-bian-yi-de-ha-abzi)
### 📺 视频题解  
![36. leetcode 787.mp4](99bb4429-7e71-4b20-9651-8abb74f8400b)

### 📖 文字题解
#### 前言

本题和[「1928. 规定时间内到达终点的最小花费」](https://leetcode-cn.com/problems/minimum-cost-to-reach-destination-in-time/)是类似的题。读者在解决本题后，可以尝试解决该题。

#### 方法一：动态规划

**思路与算法**

我们用 $f[t][i]$ 表示通过恰好 $t$ 次航班，从出发城市 $\textit{src}$ 到达城市 $i$ 需要的最小花费。在进行状态转移时，我们可以枚举最后一次航班的起点 $j$，即：

$$
f[t][i] = \min_{(j, i) \in \textit{flights}} \big\{ f[t-1][j] + \textit{cost}(j, i) \big\}
$$

其中 $(j, i) \in \textit{flights}$ 表示在给定的航班数组 $\textit{flights}$ 中存在从城市 $j$ 出发到达城市 $i$ 的航班，$\textit{cost}(j, i)$ 表示该航班的花费。该状态转移方程的意义在于，枚举最后一次航班的起点 $j$，那么前 $t-1$ 次航班的最小花费为 $f[t-1][j]$ 加上最后一次航班的花费 $\textit{cost}(j, i)$ 中的最小值，即为 $f[t][i]$。

由于我们最多只能中转 $k$ 次，也就是最多搭乘 $k+1$ 次航班，最终的答案即为

$$
f[1][\textit{dst}], f[2][\textit{dst}], \cdots, f[k+1][\textit{dst}]
$$
中的最小值。

**细节**

当 $t=0$ 时，状态 $f[t][i]$ 表示不搭乘航班到达城市 $i$ 的最小花费，因此有：

$$
f[t][i] = \begin{cases}
0, & i = \textit{src} \\
\infty, & i \neq \textit{src}
\end{cases}
$$

也就是说，如果 $i$ 是出发城市 $\textit{src}$，那么花费为 $0$；否则 $f[0][i]$ 不是一个合法的状态，由于在状态转移方程中我们需要求出的是最小值，因此可以将不合法的状态置为极大值 $\infty$。根据题目中给出的数据范围，航班的花费不超过 $10^4$，最多搭乘航班的次数 $k+1$ 不超过 $101$，那么在实际的代码编写中，我们只要使得极大值大于 $10^4 \times 101$，就可以将表示不合法状态的极大值与合法状态的花费进行区分。

在状态转移中，我们需要使用二重循环枚举 $t$ 和 $i$，随后枚举所有满足 $(j, i) \in \textit{flights}$ 的 $j$，这样做的劣势在于没有很好地利用数组 $\textit{flights}$，为了保证时间复杂度较优，需要将 $\textit{flights}$ 中的所有航班存储在一个新的邻接表中。一种可行的解决方法是，我们只需要使用一重循环枚举 $t$，随后枚举 $\textit{flights}$ 中的每一个航班 $(j, i, \textit{cost})$，并用 $f[t-1][j] + \textit{cost}$ 更新 $f[t][i]$，这样就免去了邻接表的使用。

注意到 $f[t][i]$ 只会从 $f[t-1][..]$ 转移而来，因此我们也可以使用两个长度为 $n$ 的一维数组进行状态转移，减少空间的使用。

**代码**

下面的代码使用二维数组进行状态转移。

```C++ [sol11-C++]
class Solution {
private:
    static constexpr int INF = 10000 * 101 + 1;

public:
    int findCheapestPrice(int n, vector<vector<int>>& flights, int src, int dst, int k) {
        vector<vector<int>> f(k + 2, vector<int>(n, INF));
        f[0][src] = 0;
        for (int t = 1; t <= k + 1; ++t) {
            for (auto&& flight: flights) {
                int j = flight[0], i = flight[1], cost = flight[2];
                f[t][i] = min(f[t][i], f[t - 1][j] + cost);
            }
        }
        int ans = INF;
        for (int t = 1; t <= k + 1; ++t) {
            ans = min(ans, f[t][dst]);
        }
        return (ans == INF ? -1 : ans);
    }
};
```

```Java [sol11-Java]
class Solution {
    public int findCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
        final int INF = 10000 * 101 + 1;
        int[][] f = new int[k + 2][n];
        for (int i = 0; i < k + 2; ++i) {
            Arrays.fill(f[i], INF);
        }
        f[0][src] = 0;
        for (int t = 1; t <= k + 1; ++t) {
            for (int[] flight : flights) {
                int j = flight[0], i = flight[1], cost = flight[2];
                f[t][i] = Math.min(f[t][i], f[t - 1][j] + cost);
            }
        }
        int ans = INF;
        for (int t = 1; t <= k + 1; ++t) {
            ans = Math.min(ans, f[t][dst]);
        }
        return ans == INF ? -1 : ans;
    }
}
```

```C# [sol11-C#]
public class Solution {
    public int FindCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
        const int INF = 10000 * 101 + 1;
        int[,] f = new int[k + 2, n];
        for (int i = 0; i < k + 2; ++i) {
            for (int j = 0; j < n; ++j) {
                f[i, j] = INF;
            }
        }
        f[0, src] = 0;
        for (int t = 1; t <= k + 1; ++t) {
            foreach (int[] flight in flights) {
                int j = flight[0], i = flight[1], cost = flight[2];
                f[t, i] = Math.Min(f[t, i], f[t - 1, j] + cost);
            }
        }
        int ans = INF;
        for (int t = 1; t <= k + 1; ++t) {
            ans = Math.Min(ans, f[t, dst]);
        }
        return ans == INF ? -1 : ans;
    }
}
```

```Python [sol11-Python3]
class Solution:
    def findCheapestPrice(self, n: int, flights: List[List[int]], src: int, dst: int, k: int) -> int:
        f = [[float("inf")] * n for _ in range(k + 2)]
        f[0][src] = 0
        for t in range(1, k + 2):
            for j, i, cost in flights:
                f[t][i] = min(f[t][i], f[t - 1][j] + cost)
        
        ans = min(f[t][dst] for t in range(1, k + 2))
        return -1 if ans == float("inf") else ans
```

```JavaScript [sol11-JavaScript]
var findCheapestPrice = function(n, flights, src, dst, k) {
    const INF = 10000 * 101 + 1;
    const f = new Array(k + 2).fill(0).map(() => new Array(n).fill(INF));
    f[0][src] = 0;
    for (let t = 1; t <= k + 1; ++t) {
        for (const flight of flights) {
            const j = flight[0], i = flight[1], cost = flight[2];
            f[t][i] = Math.min(f[t][i], f[t - 1][j] + cost);
        }
    }
    let ans = INF;
    for (let t = 1; t <= k + 1; ++t) {
        ans = Math.min(ans, f[t][dst]);
    }
    return ans == INF ? -1 : ans;
};
```

```go [sol11-Golang]
func findCheapestPrice(n int, flights [][]int, src int, dst int, k int) int {
    const inf = 10000*101 + 1
    f := make([][]int, k+2)
    for i := range f {
        f[i] = make([]int, n)
        for j := range f[i] {
            f[i][j] = inf
        }
    }
    f[0][src] = 0
    for t := 1; t <= k+1; t++ {
        for _, flight := range flights {
            j, i, cost := flight[0], flight[1], flight[2]
            f[t][i] = min(f[t][i], f[t-1][j]+cost)
        }
    }
    ans := inf
    for t := 1; t <= k+1; t++ {
        ans = min(ans, f[t][dst])
    }
    if ans == inf {
        ans = -1
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

```C [sol11-C]
int findCheapestPrice(int n, int** flights, int flightsSize, int* flightsColSize, int src, int dst, int k) {
    int f[k + 2][n];
    memset(f, 0x3f, sizeof(f));
    f[0][src] = 0;
    for (int t = 1; t <= k + 1; ++t) {
        for (int k = 0; k < flightsSize; k++) {
            int j = flights[k][0], i = flights[k][1], cost = flights[k][2];
            f[t][i] = fmin(f[t][i], f[t - 1][j] + cost);
        }
    }
    int ans = 0x3f3f3f3f;
    for (int t = 1; t <= k + 1; ++t) {
        ans = fmin(ans, f[t][dst]);
    }
    return (ans == 0x3f3f3f3f ? -1 : ans);
}
```

下面的代码使用两个一维数组进行状态转移。

```C++ [sol12-C++]
class Solution {
private:
    static constexpr int INF = 10000 * 101 + 1;

public:
    int findCheapestPrice(int n, vector<vector<int>>& flights, int src, int dst, int k) {
        vector<int> f(n, INF);
        f[src] = 0;
        int ans = INF;
        for (int t = 1; t <= k + 1; ++t) {
            vector<int> g(n, INF);
            for (auto&& flight: flights) {
                int j = flight[0], i = flight[1], cost = flight[2];
                g[i] = min(g[i], f[j] + cost);
            }
            f = move(g);
            ans = min(ans, f[dst]);
        }
        return (ans == INF ? -1 : ans);
    }
};
```

```Java [sol12-Java]
class Solution {
    public int findCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
        final int INF = 10000 * 101 + 1;
        int[] f = new int[n];
        Arrays.fill(f, INF);
        f[src] = 0;
        int ans = INF;
        for (int t = 1; t <= k + 1; ++t) {
            int[] g = new int[n];
            Arrays.fill(g, INF);
            for (int[] flight : flights) {
                int j = flight[0], i = flight[1], cost = flight[2];
                g[i] = Math.min(g[i], f[j] + cost);
            }
            f = g;
            ans = Math.min(ans, f[dst]);
        }
        return ans == INF ? -1 : ans;
    }
}
```

```C# [sol12-C#]
public class Solution {
    public int FindCheapestPrice(int n, int[][] flights, int src, int dst, int k) {
        const int INF = 10000 * 101 + 1;
        int[] f = new int[n];
        Array.Fill(f, INF);
        f[src] = 0;
        int ans = INF;
        for (int t = 1; t <= k + 1; ++t) {
            int[] g = new int[n];
            Array.Fill(g, INF);
            foreach (int[] flight in flights) {
                int j = flight[0], i = flight[1], cost = flight[2];
                g[i] = Math.Min(g[i], f[j] + cost);
            }
            f = g;
            ans = Math.Min(ans, f[dst]);
        }
        return ans == INF ? -1 : ans;
    }
}
```

```Python [sol12-Python3]
class Solution:
    def findCheapestPrice(self, n: int, flights: List[List[int]], src: int, dst: int, k: int) -> int:
        f = [float("inf")] * n
        f[src] = 0
        ans = float("inf")
        for t in range(1, k + 2):
            g = [float("inf")] * n
            for j, i, cost in flights:
                g[i] = min(g[i], f[j] + cost)
            f = g
            ans = min(ans, f[dst])
        
        return -1 if ans == float("inf") else ans
```

```JavaScript [sol12-JavaScript]
var findCheapestPrice = function(n, flights, src, dst, k) {
    const INF = 10000 * 101 + 1;
    let f = new Array(n).fill(INF);
    f[src] = 0;
    let ans = INF;
    for (let t = 1; t <= k + 1; ++t) {
        const g = new Array(n).fill(INF);
        for (const flight of flights) {
            const j = flight[0], i = flight[1], cost = flight[2];
            g[i] = Math.min(g[i], f[j] + cost);
        }
        f = g;
        ans = Math.min(ans, f[dst]);
    }
    return ans == INF ? -1 : ans;
};
```

```go [sol12-Golang]
func findCheapestPrice(n int, flights [][]int, src int, dst int, k int) int {
    const inf = 10000*101 + 1
    f := make([]int, n)
    for i := range f {
        f[i] = inf
    }
    f[src] = 0
    ans := inf
    for t := 1; t <= k+1; t++ {
        g := make([]int, n)
        for i := range g {
            g[i] = inf
        }
        for _, flight := range flights {
            j, i, cost := flight[0], flight[1], flight[2]
            g[i] = min(g[i], f[j]+cost)
        }
        f = g
        ans = min(ans, f[dst])
    }
    if ans == inf {
        ans = -1
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

```C [sol12-C]
int findCheapestPrice(int n, int** flights, int flightsSize, int* flightsColSize, int src, int dst, int k) {
    int f[n];
    memset(f, 0x3f, sizeof(f));
    f[src] = 0;
    int ans = 0x3f3f3f3f;
    for (int t = 1; t <= k + 1; ++t) {
        int g[n];
        memset(g, 0x3f, sizeof(g));
        for (int k = 0; k < flightsSize; k++) {
            int j = flights[k][0], i = flights[k][1], cost = flights[k][2];
            g[i] = fmin(g[i], f[j] + cost);
        }
        memcpy(f, g, sizeof(f));
        ans = fmin(ans, f[dst]);
    }
    return (ans == 0x3f3f3f3f ? -1 : ans);
}
```

**复杂度分析**

- 时间复杂度：$O((m+n)k)$，其中 $m$ 是数组 $\textit{flights}$ 的长度。状态的数量为 $O(nk)$，对于固定的 $t$，我们需要 $O(m)$ 的时间计算出所有 $f[t][..]$ 的值，因此总时间复杂度为 $O((m+n)k)$。

- 空间复杂度：$O(nk)$ 或 $O(n)$，即为存储状态需要的空间。

---
视频题解看不够？还想了解更多图论相关扩展知识？就现在，点击图片立刻前往 LeetBook，打牢基础，冲刺秋招！

[![image.png](https://pic.leetcode-cn.com/1626759288-qtqMJf-image.png){:style="max-height:150px"}](https://leetcode-cn.com/leetbook/detail/graph/)
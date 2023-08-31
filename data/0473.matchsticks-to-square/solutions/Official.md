## [473.火柴拼正方形 中文官方题解](https://leetcode.cn/problems/matchsticks-to-square/solutions/100000/huo-chai-pin-zheng-fang-xing-by-leetcode-szdp)

#### 方法一：回溯

首先计算所有火柴的总长度 $\textit{totalLen}$，如果 $\textit{totalLen}$ 不是 $4$ 的倍数，那么不可能拼成正方形，返回 $\text{false}$。当 $\textit{totalLen}$ 是 $4$ 的倍数时，每条边的边长为 $\textit{len} = \dfrac{\textit{totalLen}}{4}$，用 $\textit{edges}$ 来记录 $4$ 条边已经放入的火柴总长度。对于第 $\textit{index}$ 火柴，尝试把它放入其中一条边内且满足放入后该边的火柴总长度不超过 $\textit{len}$，然后继续枚举第 $\textit{index} + 1$ 根火柴的放置情况，如果所有火柴都已经被放置，那么说明可以拼成正方形。

为了减少搜索量，需要对火柴长度从大到小进行排序。

```Python [sol1-Python3]
class Solution:
    def makesquare(self, matchsticks: List[int]) -> bool:
        totalLen = sum(matchsticks)
        if totalLen % 4:
            return False
        matchsticks.sort(reverse=True)

        edges = [0] * 4
        def dfs(idx: int) -> bool:
            if idx == len(matchsticks):
                return True
            for i in range(4):
                edges[i] += matchsticks[idx]
                if edges[i] <= totalLen // 4 and dfs(idx + 1):
                    return True
                edges[i] -= matchsticks[idx]
            return False
        return dfs(0)
```

```C++ [sol1-C++]
class Solution {
public:
    bool dfs(int index, vector<int> &matchsticks, vector<int> &edges, int len) {
        if (index == matchsticks.size()) {
            return true;
        }
        for (int i = 0; i < edges.size(); i++) {
            edges[i] += matchsticks[index];
            if (edges[i] <= len && dfs(index + 1, matchsticks, edges, len)) {
                return true;
            }
            edges[i] -= matchsticks[index];
        }
        return false;
    }

    bool makesquare(vector<int> &matchsticks) {
        int totalLen = accumulate(matchsticks.begin(), matchsticks.end(), 0);
        if (totalLen % 4 != 0) {
            return false;
        }
        sort(matchsticks.begin(), matchsticks.end(), greater<int>()); // 减少搜索量

        vector<int> edges(4);
        return dfs(0, matchsticks, edges, totalLen / 4);
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean makesquare(int[] matchsticks) {
        int totalLen = Arrays.stream(matchsticks).sum();
        if (totalLen % 4 != 0) {
            return false;
        }
        Arrays.sort(matchsticks);
        for (int i = 0, j = matchsticks.length - 1; i < j; i++, j--) {
            int temp = matchsticks[i];
            matchsticks[i] = matchsticks[j];
            matchsticks[j] = temp;
        }

        int[] edges = new int[4];
        return dfs(0, matchsticks, edges, totalLen / 4);
    }

    public boolean dfs(int index, int[] matchsticks, int[] edges, int len) {
        if (index == matchsticks.length) {
            return true;
        }
        for (int i = 0; i < edges.length; i++) {
            edges[i] += matchsticks[index];
            if (edges[i] <= len && dfs(index + 1, matchsticks, edges, len)) {
                return true;
            }
            edges[i] -= matchsticks[index];
        }
        return false;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool Makesquare(int[] matchsticks) {
        int totalLen = matchsticks.Sum();
        if (totalLen % 4 != 0) {
            return false;
        }
        Array.Sort(matchsticks);
        for (int i = 0, j = matchsticks.Length - 1; i < j; i++, j--) {
            int temp = matchsticks[i];
            matchsticks[i] = matchsticks[j];
            matchsticks[j] = temp;
        }

        int[] edges = new int[4];
        return DFS(0, matchsticks, edges, totalLen / 4);
    }

    public bool DFS(int index, int[] matchsticks, int[] edges, int len) {
        if (index == matchsticks.Length) {
            return true;
        }
        for (int i = 0; i < edges.Length; i++) {
            edges[i] += matchsticks[index];
            if (edges[i] <= len && DFS(index + 1, matchsticks, edges, len)) {
                return true;
            }
            edges[i] -= matchsticks[index];
        }
        return false;
    }
}
```

```C [sol1-C]
static bool dfs(int index, int *matchsticks, int matchsticksSize, int *edges, int len) {
    if (index == matchsticksSize) {
        return true;
    }
    for (int i = 0; i < 4; i++) {
        edges[i] += matchsticks[index];
        if (edges[i] <= len && dfs(index + 1, matchsticks, matchsticksSize, edges, len)) {
            return true;
        }
        edges[i] -= matchsticks[index];
    }
    return false;
}

static int cmp(const void *pa, const void *pb) {
    return *(int *)pb - *(int *)pa;
}

bool makesquare(int* matchsticks, int matchsticksSize) {
    int totalLen = 0;
    for (int i = 0; i < matchsticksSize; i++) {
        totalLen += matchsticks[i];
    }
    if (totalLen % 4 != 0) {
        return false;
    }
    qsort(matchsticks, matchsticksSize, sizeof(int), cmp);
    int edges[4] = {0, 0, 0, 0};
    return dfs(0, matchsticks, matchsticksSize, edges, totalLen / 4);
}
```

```JavaScript [sol1-JavaScript]
var makesquare = function(matchsticks) {
    const totalLen = _.sum(matchsticks);
    if (totalLen % 4 !== 0) {
        return false;
    }
    matchsticks.sort((a, b) => a - b);
    for (let i = 0, j = matchsticks.length - 1; i < j; i++, j--) {
        const temp = matchsticks[i];
        matchsticks[i] = matchsticks[j];
        matchsticks[j] = temp;
    }

    const edges = new Array(4).fill(0);
    return dfs(0, matchsticks, edges, Math.floor(totalLen / 4));
}

const dfs = (index, matchsticks, edges, len) => {
    if (index === matchsticks.length) {
        return true;
    }
    for (let i = 0; i < edges.length; i++) {
        edges[i] += matchsticks[index];
        if (edges[i] <= len && dfs(index + 1, matchsticks, edges, len)) {
            return true;
        }
        edges[i] -= matchsticks[index];
    }
    return false;
};
```

```go [sol1-Golang]
func makesquare(matchsticks []int) bool {
    totalLen := 0
    for _, l := range matchsticks {
        totalLen += l
    }
    if totalLen%4 != 0 {
        return false
    }
    sort.Sort(sort.Reverse(sort.IntSlice(matchsticks))) // 减少搜索量

    edges := [4]int{}
    var dfs func(int) bool
    dfs = func(idx int) bool {
        if idx == len(matchsticks) {
            return true
        }
        for i := range edges {
            edges[i] += matchsticks[idx]
            if edges[i] <= totalLen/4 && dfs(idx+1) {
                return true
            }
            edges[i] -= matchsticks[idx]
        }
        return false
    }
    return dfs(0)
}
```

**复杂度分析**

+ 时间复杂度：$O(4^n)$，其中 $n$ 是火柴的数目。每根火柴都可以选择放在 $4$ 条边上，因此时间复杂度为 $O(4^n)$。

+ 空间复杂度：$O(n)$。递归栈需要占用 $O(n)$ 的空间。

#### 方法二：状态压缩 + 动态规划

计算所有火柴的总长度 $\textit{totalLen}$，如果 $\textit{totalLen}$ 不是 $4$ 的倍数，那么不可能拼成正方形，返回 $\text{false}$。当 $\textit{totalLen}$ 是 $4$ 的倍数时，每条边的边长为 $\textit{len} = \dfrac{\textit{totalLen}}{4}$。我们给正方形的四条边进行编号，分别为 $1$，$2$，$3$ 和 $4$。按照编号顺序依次将火柴放入正方形的四条边，只有前一条边被放满后，才能将火柴放入后一条边。

用状态 $s$ 记录哪些火柴已经被放入（$s$ 的第 $k$ 位为 $1$ 表示第 $k$ 根火柴已经被放入），$\textit{dp}[s]$ 表示正方形未放满的边的当前长度，计算如下：

+ 当 $s = 0$ 时，没有火柴被放入，因此 $\textit{dp}[0] = 0$。

+ 当 $s \ne 0$ 时，如果去掉它的第 $k$ 根火柴得到的状态 $s_1$ 满足 $\textit{dp}[s_1] \ge 0$ 且 $\textit{dp}[s_1] + \textit{matchsticks}[k] \le \textit{len}$，那么 $\textit{dp}[s] = (\textit{dp}[s_1] + \textit{matchsticks}[k]) \bmod \textit{len}$（因为放满前一条边后，我们开始放后一条边，此时未放满的边的长度为 $0$，所以需要对 $\textit{len}$ 取余）；否则 $\textit{dp}[s] = -1$，表示状态 $s$ 对应的火柴集合不可能按上述规则放入正方形的边。

令 $s_\textit{all}$ 表示所有火柴都已经被放入时的状态，如果 $\textit{dp}[s_\textit{all}] = 0$ 成立，那么可以拼成正方形，否则不可以拼成正方形。

```Python [sol2-Python3]
class Solution:
    def makesquare(self, matchsticks: List[int]) -> bool:
        totalLen = sum(matchsticks)
        if totalLen % 4:
            return False
        tLen = totalLen // 4

        dp = [-1] * (1 << len(matchsticks))
        dp[0] = 0
        for s in range(1, len(dp)):
            for k, v in enumerate(matchsticks):
                if s & (1 << k) == 0:
                    continue
                s1 = s & ~(1 << k)
                if dp[s1] >= 0 and dp[s1] + v <= tLen:
                    dp[s] = (dp[s1] + v) % tLen
                    break
        return dp[-1] == 0
```

```C++ [sol2-C++]
class Solution {
public:
    bool makesquare(vector<int>& matchsticks) {
        int totalLen = accumulate(matchsticks.begin(), matchsticks.end(), 0);
        if (totalLen % 4 != 0) {
            return false;
        }
        int len = totalLen / 4, n = matchsticks.size();
        vector<int> dp(1 << n, -1);
        dp[0] = 0;
        for (int s = 1; s < (1 << n); s++) {
            for (int k = 0; k < n; k++) {
                if ((s & (1 << k)) == 0) {
                    continue;
                }
                int s1 = s & ~(1 << k);
                if (dp[s1] >= 0 && dp[s1] + matchsticks[k] <= len) {
                    dp[s] = (dp[s1] + matchsticks[k]) % len;
                    break;
                }
            }
        }
        return dp[(1 << n) - 1] == 0;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean makesquare(int[] matchsticks) {
        int totalLen = Arrays.stream(matchsticks).sum();
        if (totalLen % 4 != 0) {
            return false;
        }
        int len = totalLen / 4, n = matchsticks.length;
        int[] dp = new int[1 << n];
        Arrays.fill(dp, -1);
        dp[0] = 0;
        for (int s = 1; s < (1 << n); s++) {
            for (int k = 0; k < n; k++) {
                if ((s & (1 << k)) == 0) {
                    continue;
                }
                int s1 = s & ~(1 << k);
                if (dp[s1] >= 0 && dp[s1] + matchsticks[k] <= len) {
                    dp[s] = (dp[s1] + matchsticks[k]) % len;
                    break;
                }
            }
        }
        return dp[(1 << n) - 1] == 0;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool Makesquare(int[] matchsticks) {
        int totalLen = matchsticks.Sum();
        if (totalLen % 4 != 0) {
            return false;
        }
        int len = totalLen / 4, n = matchsticks.Length;
        int[] dp = new int[1 << n];
        Array.Fill(dp, -1);
        dp[0] = 0;
        for (int s = 1; s < (1 << n); s++) {
            for (int k = 0; k < n; k++) {
                if ((s & (1 << k)) == 0) {
                    continue;
                }
                int s1 = s & ~(1 << k);
                if (dp[s1] >= 0 && dp[s1] + matchsticks[k] <= len) {
                    dp[s] = (dp[s1] + matchsticks[k]) % len;
                    break;
                }
            }
        }
        return dp[(1 << n) - 1] == 0;
    }
}
```

```C [sol2-C]
bool makesquare(int* matchsticks, int matchsticksSize) {
    int totalLen = 0;
    for (int i = 0; i < matchsticksSize; i++) {
        totalLen += matchsticks[i];
    }
    if (totalLen % 4 != 0) {
        return false;
    }
    int len = totalLen / 4, n = matchsticksSize;
    int *dp = (int *)malloc(sizeof(int) * (1 << n));
    memset(dp, -1, sizeof(int) * (1 << n));
    dp[0] = 0;
    for (int s = 1; s < (1 << n); s++) {
        for (int k = 0; k < n; k++) {
            if ((s & (1 << k)) == 0) {
                continue;
            }
            int s1 = s & ~(1 << k);
            if (dp[s1] >= 0 && dp[s1] + matchsticks[k] <= len) {
                dp[s] = (dp[s1] + matchsticks[k]) % len;
                break;
            }
        }
    }
    bool res = dp[(1 << n) - 1] == 0;
    free(dp);
    return res;
}
```

```JavaScript [sol2-JavaScript]
var makesquare = function(matchsticks) {
    const totalLen = _.sum(matchsticks);
    if (totalLen % 4 !== 0) {
        return false;
    }
    const len = Math.floor(totalLen / 4), n = matchsticks.length;
    const dp = new Array(1 << n).fill(-1);
    dp[0] = 0;
    for (let s = 1; s < (1 << n); s++) {
        for (let k = 0; k < n; k++) {
            if ((s & (1 << k)) === 0) {
                continue;
            }
            const s1 = s & ~(1 << k);
            if (dp[s1] >= 0 && dp[s1] + matchsticks[k] <= len) {
                dp[s] = (dp[s1] + matchsticks[k]) % len;
                break;
            }
        }
    }
    return dp[(1 << n) - 1] === 0;
}
```

```go [sol2-Golang]
func makesquare(matchsticks []int) bool {
    totalLen := 0
    for _, l := range matchsticks {
        totalLen += l
    }
    if totalLen%4 != 0 {
        return false
    }

    tLen := totalLen / 4
    dp := make([]int, 1<<len(matchsticks))
    for i := 1; i < len(dp); i++ {
        dp[i] = -1
    }
    for s := 1; s < len(dp); s++ {
        for k, v := range matchsticks {
            if s>>k&1 == 0 {
                continue
            }
            s1 := s &^ (1 << k)
            if dp[s1] >= 0 && dp[s1]+v <= tLen {
                dp[s] = (dp[s1] + v) % tLen
                break
            }
        }
    }
    return dp[len(dp)-1] == 0
}
```

**复杂度分析**

+ 时间复杂度：$O(n \times 2^n)$，其中 $n$ 是火柴的数目。总共有 $2^n$ 个状态，计算每个状态都需要 $O(n)$。

+ 空间复杂度：$O(2^n)$。保存数组 $\textit{dp}$ 需要 $O(2^n)$ 的空间。
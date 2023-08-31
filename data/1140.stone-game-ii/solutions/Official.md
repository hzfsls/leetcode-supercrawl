## [1140.石子游戏 II 中文官方题解](https://leetcode.cn/problems/stone-game-ii/solutions/100000/shi-zi-you-xi-ii-by-leetcode-solution-3pwv)
#### 方法一：记忆化搜索

**思路**

要求出爱丽丝可以得到的最大数量的石头，可以先求出爱丽丝最多比鲍勃多拿的石头数量，再经过计算得到爱丽丝最多可以得到的石头数量。而在两方都采取最优策略的情况下，求其中一方的得分，这种情况可以用记忆化搜索来解题。

令数组 $\textit{piles}$ 的长度为 $n$。令 $\textit{dfs}(i, m)$ 表示前 $i$ 堆石头已经被取走，当前的 $M = m$ 的情况下，接下去取石头的玩家可以比另一方多取的石头数。边界情况为 $i = n$ 时，当前玩家没有石头可以取，状态值为 $0$。其他情况下，需要遍历当前玩家取 $x = 1\sim 2m$ 堆石头，并减去对方玩家多取的石头数，挑选出最大值来作为最优策略，从而进行状态转移，即 $\textit{dfs}(i,m) = \max(\sum_{j=i}^{i+x-1}\textit{piles}[j] - \textit{dfs}(i+x, \max(x,m))),x \in [1,2\times m]$。这里数组求和可以使用前缀和来降低时间复杂度。而刚开局时，爱丽丝执先手，她比鲍勃多拿的石头数即为 $\textit{dfs}(0,1)$。记石头总数为 $\textit{sum}$，她最多拿的石头数即为 $\dfrac{\textit{dfs}(0,1) + \textit{sum}}{2}$。

**代码**

```Python [sol1-Python3]
class Solution:
    def stoneGameII(self, piles: List[int]) -> int:
        
        prefixSum = [0]
        for a in piles:
            prefixSum.append(prefixSum[-1] + a)
        
        @lru_cache(None)
        def dp(i, m):
            if i == len(piles):
                return 0
            mx = -inf
            for x in range(1, 2 * m + 1):                
                if i+x > len(piles):
                    break
                mx = max(mx, prefixSum[i + x] - prefixSum[i] - dp(i + x, max(m, x)))
            return mx
            
        return (prefixSum[-1]+dp(0, 1)) // 2
```

```Java [sol1-Java]
class Solution {
    public int stoneGameII(int[] piles) {
        int[] prefixSum = new int[piles.length + 1];
        for (int i = 0; i < piles.length; i++) {
            prefixSum[i + 1] = prefixSum[i] + piles[i];
        }

        Map<Integer, Integer> memo = new HashMap<Integer, Integer>();
        return (prefixSum[piles.length] + dp(memo, piles, prefixSum, 0, 1)) / 2;
    }

    public int dp(Map<Integer, Integer> memo, int[] piles, int[] prefixSum, int i, int m) {
        if (i == piles.length) {
            return 0;
        }
        int key = i * 201 + m;
        if (!memo.containsKey(key)) {
            int maxVal = Integer.MIN_VALUE;
            for (int x = 1; x <= 2 * m; x++) {
                if (i + x > piles.length) {
                    break;
                }
                maxVal = Math.max(maxVal, prefixSum[i + x] - prefixSum[i] - dp(memo, piles, prefixSum, i + x, Math.max(m, x)));
            }
            memo.put(key, maxVal);
        }
        return memo.get(key);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int StoneGameII(int[] piles) {
        int[] prefixSum = new int[piles.Length + 1];
        for (int i = 0; i < piles.Length; i++) {
            prefixSum[i + 1] = prefixSum[i] + piles[i];
        }

        IDictionary<int, int> memo = new Dictionary<int, int>();
        return (prefixSum[piles.Length] + DP(memo, piles, prefixSum, 0, 1)) / 2;
    }

    public int DP(IDictionary<int, int> memo, int[] piles, int[] prefixSum, int i, int m) {
        if (i == piles.Length) {
            return 0;
        }
        int key = i * 201 + m;
        if (!memo.ContainsKey(key)) {
            int maxVal = int.MinValue;
            for (int x = 1; x <= 2 * m; x++) {
                if (i + x > piles.Length) {
                    break;
                }
                maxVal = Math.Max(maxVal, prefixSum[i + x] - prefixSum[i] - DP(memo, piles, prefixSum, i + x, Math.Max(m, x)));
            }
            memo.Add(key, maxVal);
        }
        return memo[key];
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int stoneGameII(vector<int>& piles) {
        int n = piles.size();
        vector<vector<int>> dp(n + 1, vector<int>(n + 1, INT_MIN));
        for (int i = n; i >= 0; i--) {
            for (int m = 1; m <= n; m++) {
                if (i == n) {
                    dp[i][m] = 0;
                } else {
                    int sum = 0;
                    for (int x = 1; x <= 2 * m; x++) {
                        if (i + x > n) {
                            break;
                        }
                        sum += piles[i + x - 1];
                        dp[i][m] = max(dp[i][m], sum - dp[i + x][min(n, max(m, x))]);
                    }
                }
            }
        }
        return (dp[0][1] + accumulate(piles.begin(), piles.end(), 0)) / 2;
    }
};
```

```C [sol1-C]
static inline int max(int a, int b) {
    return a > b ? a : b;
}

static inline int min(int a, int b) {
    return a < b ? a : b;
}

int stoneGameII(int* piles, int pilesSize) {
    int n = pilesSize;
    int dp[n + 1][n + 1];
    for (int i = 0; i <= n; i++) {
        for (int j = 0; j <= n; j++) {
            dp[i][j] = INT_MIN;
        }
    }
    for (int i = n; i >= 0; i--) {
        for (int m = 1; m <= n; m++) {
            if (i == n) {
                dp[i][m] = 0;
            } else {
                int sum = 0;
                for (int x = 1; x <= 2 * m; x++) {
                    if (i + x > n) {
                        break;
                    }
                    sum += piles[i + x - 1];
                    dp[i][m] = max(dp[i][m], sum - dp[i + x][min(n, max(m, x))]);
                }
            }
        }
    }
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += piles[i];
    }
    return (dp[0][1] + sum) / 2;
}
```

```JavaScript [sol1-JavaScript]
var stoneGameII = function(piles) {
    const prefixSum = new Array(piles.length + 1).fill(0);
    for (let i = 0; i < piles.length; i++) {
        prefixSum[i + 1] = prefixSum[i] + piles[i];
    }

    const memo = new Map();
    return Math.floor((prefixSum[piles.length] + dp(memo, piles, prefixSum, 0, 1)) / 2);
}

const dp = (memo, piles, prefixSum, i, m) => {
    if (i === piles.length) {
        return 0;
    }
    const key = i * 201 + m;
    if (!memo.has(key)) {
        let maxVal = -Number.MAX_VALUE;
        for (let x = 1; x <= 2 * m; x++) {
            if (i + x > piles.length) {
                break;
            }
            maxVal = Math.max(maxVal, prefixSum[i + x] - prefixSum[i] - dp(memo, piles, prefixSum, i + x, Math.max(m, x)));
        }
        memo.set(key, maxVal);
    }
    return memo.get(key);
};
```

```go [sol1-Golang]
func stoneGameII(piles []int) int {
    prefixSum := make([]int, len(piles)+1)
    for i, v := range piles {
        prefixSum[i+1] = prefixSum[i] + v
    }
    type pair struct{ i, m int }
    dp := map[pair]int{}
    var f func(int, int) int
    f = func(i int, m int) int {
        if i == len(piles) {
            return 0
        }
        if v, ok := dp[pair{i, m}]; ok {
            return v
        }
        maxVal := math.MinInt
        for x := 1; x <= 2*m; x++ {
            if i+x > len(piles) {
                break
            }
            maxVal = max(maxVal, prefixSum[i+x]-prefixSum[i]-f(i+x, max(m, x)))
        }
        dp[pair{i, m}] = maxVal
        return maxVal
    }
    return (prefixSum[len(piles)] + f(0, 1)) / 2
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 是数组 $\textit{piles}$ 的长度。记忆化搜索的状态数为 $O(n^2)$，每个状态消耗 $O(n)$ 求解。

- 空间复杂度：$O(n^2)$，记忆化搜索的状态保存消耗 $O(n^2)$。
#### 方法一：动态规划

若两个整数位数不同，位数更多的整数必然大于位数小的整数。因此我们需要先计算出可以得到的整数的最大位数。

该问题可以看作是**恰好**装满背包容量为 $\textit{target}$，物品重量为 $\textit{cost}[i]$，价值为 $1$ 的完全背包问题。

对于该问题，定义二维数组 $\textit{dp}$，其中 $\textit{dp}[i+1][j]$ 表示使用前 $i$ 个数位且花费总成本**恰好**为 $j$ 时的最大位数，若花费总成本无法为 $j$，则规定其为 $-\infty$。特别地，$\textit{dp}[0][]$ 为不选任何数位的状态，因此除了 $\textit{dp}[0][0]$ 为 $0$，其余 $\textit{dp}[0][j]$ 全为 $-\infty$。

对于第 $i$ 个数位，考虑花费总成本恰好为 $j$ 时的状态转移：

- 若 $j<\textit{cost}[i]$，则无法选第 $i$ 个数位，此时有 $\textit{dp}[i+1][j]=\textit{dp}[i][j]$；
- 若 $j\ge \textit{cost}[i]$，存在选或不选两种决策，不选时有 $\textit{dp}[i+1][j]=\textit{dp}[i][j]$，选时由于第 $i$ 个数位可以重复选择，可以从使用前 $i$ 个数位且花费总成本恰好为 $j-\textit{cost}[i]$ 的状态转移过来，即 $\textit{dp}[i+1][j]=\textit{dp}[i+1][j-\textit{cost}[i]]+1$。取这两种决策的最大值。
      
因此状态转移方程为：

$$
\textit{dp}[i+1][j]=
\begin{cases}
\textit{dp}[i][j],& j<\textit{cost}[i] \\
\max(\textit{dp}[i][j],\textit{dp}[i+1][j-\textit{cost}[i]]+1), & j\ge \textit{cost}[i]
\end{cases}
$$

$\textit{dp}[9][target]$ 即为可以得到的整数的最大位数，若其小于 $0$ 则说明我们无法得到满足要求的整数，返回 $\texttt{"0"}$。否则，我们需要生成一个整数，其位数为 $\textit{dp}[9][target]$ 且数值最大。

为了生成该整数，我们可以用一个额外的二维数组 $\textit{from}$，在状态转移时记录转移来源。这样我们可以从最终状态 $\textit{dp}[9][target]$ 顺着 $\textit{from}$ 不断倒退，直至达到起始状态 $\textit{dp}[0][0]$。在倒退状态时，若转移来源是 $\textit{dp}[i+1][j-\textit{cost}[i]]$ 则说明我们选取了第 $i$ 个数位。

根据转移方程：

- 若 $j<\textit{cost}[i]$，有 $\textit{from}[i+1][j]=j$；
- 若 $j\ge \textit{cost}[i]$，当 $\textit{dp}[i][j]>\textit{dp}[i+1][j-\textit{cost}[i]]+1$ 时有 $\textit{from}[i+1][j]=j$，否则有 $\textit{from}[i+1][j]=j-\textit{cost}[i]$。

注意我们并没有记录转移来源是 $i$ 还是 $i+1$，这是因为若 $\textit{from}[i+1][j]$ 的值为 $j$，则必定从 $i$ 转移过来，否则必定从 $i+1$ 转移过来。

此外，由于我们是从最大的数位向最小的数位倒退，为使生成的整数尽可能地大，对于当前数位应尽可能多地选取，所以当 $\textit{dp}[i][j]$ 与 $\textit{dp}[i+1][j-\textit{cost}[i]]+1$ 相等时，我们选择从后者转移过来。

这样我们就得到了每个数位的选择次数，为使生成的整数尽可能地大，我们应按照从大到小的顺序填入各个数位。由于该顺序与倒退状态的顺序一致，我们可以在倒退状态时，将当前数位直接加入生成的整数末尾。

代码实现时，$-\infty$ 可以用一个非常小的负数表示，保证转移时对于值为 $-\infty$ 的状态，其 $+1$ 之后仍然为负数。

```C++ [sol1-C++]
class Solution {
public:
    string largestNumber(vector<int> &cost, int target) {
        vector<vector<int>> dp(10, vector<int>(target + 1, INT_MIN));
        vector<vector<int>> from(10, vector<int>(target + 1));
        dp[0][0] = 0;
        for (int i = 0; i < 9; ++i) {
            int c = cost[i];
            for (int j = 0; j <= target; ++j) {
                if (j < c) {
                    dp[i + 1][j] = dp[i][j];
                    from[i + 1][j] = j;
                } else {
                    if (dp[i][j] > dp[i + 1][j - c] + 1) {
                        dp[i + 1][j] = dp[i][j];
                        from[i + 1][j] = j;
                    } else {
                        dp[i + 1][j] = dp[i + 1][j - c] + 1;
                        from[i + 1][j] = j - c;
                    }
                }
            }
        }
        if (dp[9][target] < 0) {
            return "0";
        }
        string ans;
        int i = 9, j = target;
        while (i > 0) {
            if (j == from[i][j]) {
                --i;
            } else {
                ans += '0' + i;
                j = from[i][j];
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String largestNumber(int[] cost, int target) {
        int[][] dp = new int[10][target + 1];
        for (int i = 0; i < 10; ++i) {
            Arrays.fill(dp[i], Integer.MIN_VALUE);
        }
        int[][] from = new int[10][target + 1];
        dp[0][0] = 0;
        for (int i = 0; i < 9; ++i) {
            int c = cost[i];
            for (int j = 0; j <= target; ++j) {
                if (j < c) {
                    dp[i + 1][j] = dp[i][j];
                    from[i + 1][j] = j;
                } else {
                    if (dp[i][j] > dp[i + 1][j - c] + 1) {
                        dp[i + 1][j] = dp[i][j];
                        from[i + 1][j] = j;
                    } else {
                        dp[i + 1][j] = dp[i + 1][j - c] + 1;
                        from[i + 1][j] = j - c;
                    }
                }
            }
        }
        if (dp[9][target] < 0) {
            return "0";
        }
        StringBuffer sb = new StringBuffer();
        int i = 9, j = target;
        while (i > 0) {
            if (j == from[i][j]) {
                --i;
            } else {
                sb.append(i);
                j = from[i][j];
            }
        }
        return sb.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string LargestNumber(int[] cost, int target) {
        int[,] dp = new int[10, target + 1];
        for (int i = 0; i < 10; ++i) {
            for (int j = 0; j <= target; ++j) {
                dp[i, j] = int.MinValue;
            }
        }
        int[,] from = new int[10, target + 1];
        dp[0, 0] = 0;
        for (int i = 0; i < 9; ++i) {
            int c = cost[i];
            for (int j = 0; j <= target; ++j) {
                if (j < c) {
                    dp[i + 1, j] = dp[i, j];
                    from[i + 1, j] = j;
                } else {
                    if (dp[i, j] > dp[i + 1, j - c] + 1) {
                        dp[i + 1, j] = dp[i, j];
                        from[i + 1, j] = j;
                    } else {
                        dp[i + 1, j] = dp[i + 1, j - c] + 1;
                        from[i + 1, j] = j - c;
                    }
                }
            }
        }
        if (dp[9, target] < 0) {
            return "0";
        }
        StringBuilder sb = new StringBuilder();
        int curr = 9, next = target;
        while (curr > 0) {
            if (next == from[curr, next]) {
                --curr;
            } else {
                sb.Append(curr);
                next = from[curr, next];
            }
        }
        return sb.ToString();
    }
}
```

```go [sol1-Golang]
func largestNumber(cost []int, target int) string {
    dp := make([][]int, 10)
    from := make([][]int, 10)
    for i := range dp {
        dp[i] = make([]int, target+1)
        for j := range dp[i] {
            dp[i][j] = math.MinInt32
        }
        from[i] = make([]int, target+1)
    }
    dp[0][0] = 0
    for i, c := range cost {
        for j := 0; j <= target; j++ {
            if j < c {
                dp[i+1][j] = dp[i][j]
                from[i+1][j] = j
            } else {
                if dp[i][j] > dp[i+1][j-c]+1 {
                    dp[i+1][j] = dp[i][j]
                    from[i+1][j] = j
                } else {
                    dp[i+1][j] = dp[i+1][j-c] + 1
                    from[i+1][j] = j - c
                }
            }
        }
    }
    if dp[9][target] < 0 {
        return "0"
    }
    ans := make([]byte, 0, dp[9][target])
    i, j := 9, target
    for i > 0 {
        if j == from[i][j] {
            i--
        } else {
            ans = append(ans, '0'+byte(i))
            j = from[i][j]
        }
    }
    return string(ans)
}
```

```JavaScript [sol1-JavaScript]
var largestNumber = function(cost, target) {
    const dp = new Array(10).fill(0).map(() => new Array(target + 1).fill(-Number.MAX_VALUE));
    const from = new Array(10).fill(0).map(() => new Array(target + 1).fill(0));
    dp[0][0] = 0;
    for (let i = 0; i < 9; ++i) {
        const c = cost[i];
        for (let j = 0; j <= target; ++j) {
            if (j < c) {
                dp[i + 1][j] = dp[i][j];
                from[i + 1][j] = j;
            } else {
                if (dp[i][j] > dp[i + 1][j - c] + 1) {
                    dp[i + 1][j] = dp[i][j];
                    from[i + 1][j] = j;
                } else {
                    dp[i + 1][j] = dp[i + 1][j - c] + 1;
                    from[i + 1][j] = j - c;
                }
            }
        }
    }
    if (dp[9][target] < 0) {
        return "0";
    }
    const sb = [];
    let i = 9, j = target;
    while (i > 0) {
        if (j === from[i][j]) {
            --i;
        } else {
            sb.push(i);
            j = from[i][j];
        }
    }
    return sb.join('');
};
```

```C [sol1-C]
char* largestNumber(int* cost, int costSize, int target) {
    int dp[10][target + 1];
    memset(dp, 0x80, sizeof(dp));
    dp[0][0] = 0;
    int from[10][target + 1];
    memset(from, 0, sizeof(from));
    for (int i = 0; i < 9; ++i) {
        int c = cost[i];
        for (int j = 0; j <= target; ++j) {
            if (j < c) {
                dp[i + 1][j] = dp[i][j];
                from[i + 1][j] = j;
            } else {
                if (dp[i][j] > dp[i + 1][j - c] + 1) {
                    dp[i + 1][j] = dp[i][j];
                    from[i + 1][j] = j;
                } else {
                    dp[i + 1][j] = dp[i + 1][j - c] + 1;
                    from[i + 1][j] = j - c;
                }
            }
        }
    }
    if (dp[9][target] < 0) {
        return "0";
    }
    char* ans = malloc(sizeof(char) * (target + 1));
    int ansSize = 0;
    int i = 9, j = target;
    while (i > 0) {
        if (j == from[i][j]) {
            --i;
        } else {
            ans[ansSize++] = '0' + i;
            j = from[i][j];
        }
    }
    ans[ansSize] = 0;
    return ans;
}
```

```Python [sol1-Python3]
class Solution:
    def largestNumber(self, cost: List[int], target: int) -> str:
        dp = [[float("-inf")] * (target + 1) for _ in range(10)]
        where = [[0] * (target + 1) for _ in range(10)]
        dp[0][0] = 0

        for i, c in enumerate(cost):
            for j in range(target + 1):
                if j < c:
                    dp[i + 1][j] = dp[i][j]
                    where[i + 1][j] = j
                else:
                    if dp[i][j] > dp[i + 1][j - c] + 1:
                        dp[i + 1][j] = dp[i][j]
                        where[i + 1][j] = j
                    else:
                        dp[i + 1][j] = dp[i + 1][j - c] + 1
                        where[i + 1][j] = j - c
        
        if dp[9][target] < 0:
            return "0"
        
        ans = list()
        i, j = 9, target
        while i > 0:
            if j == where[i][j]:
                i -= 1
            else:
                ans.append(str(i))
                j = where[i][j]
        
        return "".join(ans)
```

上述代码有两处空间优化：

其一是滚动数组优化。由于 $\textit{dp}[i+1][]$ 每个元素值的计算只与 $\textit{dp}[i+1][]$ 和 $\textit{dp}[i][]$ 的元素值有关，因此可以使用滚动数组的方式，去掉 $\textit{dp}$ 的第一个维度。

其二是去掉 $\textit{from}$ 数组。在状态倒退时，直接根据 $\textit{dp}[j]$ 与 $\textit{dp}[j-\textit{cost}[i]]+1$ 是否相等来判断，若二者相等则说明是从 $\textit{dp}[j-\textit{cost}[i]]$ 转移而来，即选择了第 $i$ 个数位。

```C++ [sol2-C++]
class Solution {
public:
    string largestNumber(vector<int> &cost, int target) {
        vector<int> dp(target + 1, INT_MIN);
        dp[0] = 0;
        for (int c : cost) {
            for (int j = c; j <= target; ++j) {
                dp[j] = max(dp[j], dp[j - c] + 1);
            }
        }
        if (dp[target] < 0) {
            return "0";
        }
        string ans;
        for (int i = 8, j = target; i >= 0; i--) {
            for (int c = cost[i]; j >= c && dp[j] == dp[j - c] + 1; j -= c) {
                ans += '1' + i;
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public String largestNumber(int[] cost, int target) {
        int[] dp = new int[target + 1];
        Arrays.fill(dp, Integer.MIN_VALUE);
        dp[0] = 0;
        for (int c : cost) {
            for (int j = c; j <= target; ++j) {
                dp[j] = Math.max(dp[j], dp[j - c] + 1);
            }
        }
        if (dp[target] < 0) {
            return "0";
        }
        StringBuffer sb = new StringBuffer();
        for (int i = 8, j = target; i >= 0; i--) {
            for (int c = cost[i]; j >= c && dp[j] == dp[j - c] + 1; j -= c) {
                sb.append(i + 1);
            }
        }
        return sb.toString();
    }
}
```

```C# [sol2-C#]
public class Solution {
    public string LargestNumber(int[] cost, int target) {
        int[] dp = new int[target + 1];
        Array.Fill(dp, int.MinValue);
        dp[0] = 0;
        foreach (int c in cost) {
            for (int j = c; j <= target; ++j) {
                dp[j] = Math.Max(dp[j], dp[j - c] + 1);
            }
        }
        if (dp[target] < 0) {
            return "0";
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 8, j = target; i >= 0; i--) {
            for (int c = cost[i]; j >= c && dp[j] == dp[j - c] + 1; j -= c) {
                sb.Append(i + 1);
            }
        }
        return sb.ToString();
    }
}
```

```go [sol2-Golang]
func largestNumber(cost []int, target int) string {
    dp := make([]int, target+1)
    for i := range dp {
        dp[i] = math.MinInt32
    }
    dp[0] = 0
    for _, c := range cost {
        for j := c; j <= target; j++ {
            dp[j] = max(dp[j], dp[j-c]+1)
        }
    }
    if dp[target] < 0 {
        return "0"
    }
    ans := make([]byte, 0, dp[target])
    for i, j := 8, target; i >= 0; i-- {
        for c := cost[i]; j >= c && dp[j] == dp[j-c]+1; j -= c {
            ans = append(ans, byte('1'+i))
        }
    }
    return string(ans)
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol2-JavaScript]
var largestNumber = function(cost, target) {
    const dp = new Array(target + 1).fill(-Number.MAX_VALUE);
    dp[0] = 0;
    for (const c of cost) {
        for (let j = c; j <= target; ++j) {
            dp[j] = Math.max(dp[j], dp[j - c] + 1);
        }
    }
    if (dp[target] < 0) {
        return '0';
    }
    const ans = [];
    for (let i = 8, j = target; i >= 0; i--) {
        for (let c = cost[i]; j >= c && dp[j] === dp[j - c] + 1; j -= c) {
            ans.push(String.fromCharCode('1'.charCodeAt() + i));
        }
    }
    return ans.join('');
};
```

```C [sol2-C]
char* largestNumber(int* cost, int costSize, int target) {
    int dp[target + 1];
    memset(dp, 0x80, sizeof(dp));
    dp[0] = 0;
    for (int i = 0; i < costSize; ++i) {
        for (int j = cost[i]; j <= target; ++j) {
            dp[j] = fmax(dp[j], dp[j - cost[i]] + 1);
        }
    }
    if (dp[target] < 0) {
        return "0";
    }
    char* ans = malloc(sizeof(char) * (target + 1));
    int ansSize = 0;
    for (int i = 8, j = target; i >= 0; i--) {
        for (int c = cost[i]; j >= c && dp[j] == dp[j - c] + 1; j -= c) {
            ans[ansSize++] = '1' + i;
        }
    }
    ans[ansSize] = 0;
    return ans;
}
```

```Python [sol2-Python3]
class Solution:
    def largestNumber(self, cost: List[int], target: int) -> str:
        dp = [float("-inf")] * (target + 1)
        dp[0] = 0

        for c in cost:
            for j in range(c, target + 1):
                dp[j] = max(dp[j], dp[j - c] + 1)
        
        if dp[target] < 0:
            return "0"
        
        ans = list()
        j = target
        for i in range(8, -1, -1):
            c = cost[i]
            while j >= c and dp[j] == dp[j - c] + 1:
                ans.append(str(i + 1))
                j -= c

        return "".join(ans)
```

**复杂度分析**

- 时间复杂度：$O(n\cdot\textit{target})$。其中 $n$ 是数组 $\textit{cost}$ 的长度。

- 空间复杂度：$O(\textit{target})$。
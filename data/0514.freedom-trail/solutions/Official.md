#### 方法一：动态规划

定义 $\textit{dp}[i][j]$ 表示从前往后拼写出 $\textit{key}$ 的第 $i$ 个字符， $\textit{ring}$ 的第 $j$ 个字符与 $12:00$ 方向对齐的最少步数（下标均从 $0$ 开始）。

显然，只有当字符串 $\textit{ring}$ 的第 $j$ 个字符需要和 $\textit{key}$ 的第 $i$ 个字符相同时才能拼写出 $\textit{key}$ 的第 $i$ 个字符，因此对于 $\textit{key}$ 的第 $i$ 个字符，需要考虑计算的 $\textit{ring}$ 的第 $j$ 个字符只有 $\textit{key}[i]$ 在 $\textit{ring}$ 中出现的下标集合。我们对每个字符维护一个位置数组 $\textit{pos}[i]$，表示字符 $i$ 在 $\textit{ring}$ 中出现的位置集合，用来加速计算转移的过程。

对于状态 $\textit{dp}[i][j]$，需要枚举上一次与 $12:00$ 方向对齐的位置 $k$，因此可以列出如下的转移方程：
$$
\textit{dp}[i][j]=\min_{k \in pos[key[i-1]]}\{dp[i-1][k]+\min\{\text{abs}(j-k),n-\text{abs}(j-k)\}+1\}
$$
其中 $\min\{\text{abs}(j-k),n-\text{abs}(j-k)\}+1$ 表示在当前第 $k$ 个字符与 $12:00$ 方向对齐时第 $j$ 个字符旋转到 $12:00$ 方向并按下拼写的最少步数。

最后答案即为 $\min_{i=0}^{n-1}\{\textit{dp}[m-1][i]\}$。

这样的做法需要开辟 $O(mn)$ 的空间来存放 $\textit{dp}$ 值。考虑到每次转移状态 $\textit{dp}[i][]$ 只会从 $\textit{dp}[i-1][]$ 转移过来，因此我们可以利用滚动数组优化**第一维**的空间复杂度，有能力的读者可以尝试实现。下面只给出最朴素的 $O(mn)$ 空间复杂度的实现。

```C++ [sol1-C++]
class Solution {
public:
    int findRotateSteps(string ring, string key) {
        int n = ring.size(), m = key.size();
        vector<int> pos[26];
        for (int i = 0; i < n; ++i) {
            pos[ring[i] - 'a'].push_back(i);
        }
        vector<vector<int>> dp(m, vector<int>(n, 0x3f3f3f3f));
        for (auto& i: pos[key[0] - 'a']) {
            dp[0][i] = min(i, n - i) + 1;
        }
        for (int i = 1; i < m; ++i) {
            for (auto& j: pos[key[i] - 'a']) {
                for (auto& k: pos[key[i - 1] - 'a']) {
                    dp[i][j] = min(dp[i][j], dp[i - 1][k] + min(abs(j - k), n - abs(j - k)) + 1);
                }
            }
        }
        return *min_element(dp[m - 1].begin(), dp[m - 1].end());
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findRotateSteps(String ring, String key) {
        int n = ring.length(), m = key.length();
        List<Integer>[] pos = new List[26];
        for (int i = 0; i < 26; ++i) {
            pos[i] = new ArrayList<Integer>();
        }
        for (int i = 0; i < n; ++i) {
            pos[ring.charAt(i) - 'a'].add(i);
        }
        int[][] dp = new int[m][n];
        for (int i = 0; i < m; ++i) {
            Arrays.fill(dp[i], 0x3f3f3f);
        }
        for (int i : pos[key.charAt(0) - 'a']) {
            dp[0][i] = Math.min(i, n - i) + 1;
        }
        for (int i = 1; i < m; ++i) {
            for (int j : pos[key.charAt(i) - 'a']) {
                for (int k : pos[key.charAt(i - 1) - 'a']) {
                    dp[i][j] = Math.min(dp[i][j], dp[i - 1][k] + Math.min(Math.abs(j - k), n - Math.abs(j - k)) + 1);
                }
            }
        }
        return Arrays.stream(dp[m - 1]).min().getAsInt();
    }
}
```

```JavaScript [sol1-JavaScript]
const getIdx = (str, v) => str.codePointAt(v) - 'a'.codePointAt(0);
var findRotateSteps = function(ring, key) {
    const n = ring.length, m = key.length;
    const pos = new Array(26).fill(0).map(v => []);
    for (let i = 0; i < n; ++i) {
        pos[getIdx(ring, i)].push(i);
    }
    const dp = new Array(m).fill(0).map(v => new Array(n).fill(Number.MAX_SAFE_INTEGER));
    for (const i of pos[getIdx(key, 0)]) {
        dp[0][i] = Math.min(i, n - i) + 1;
    }
    for (let i = 1; i < m; ++i) {
        for (const j of pos[getIdx(key, i)]) {
            for (const k of pos[getIdx(key, i - 1)]) {
                dp[i][j] = Math.min(dp[i][j], dp[i - 1][k] + Math.min(Math.abs(j - k), n - Math.abs(j - k)) + 1);
            }
        }
    }
    return dp[m - 1].reduce((pre, cur) => Math.min(pre, cur), Number.MAX_SAFE_INTEGER);
};
```

```Golang [sol1-Golang]
func findRotateSteps(ring string, key string) int {
    const inf = math.MaxInt64 / 2
    n, m := len(ring), len(key)
    pos := [26][]int{}
    for i, c := range ring {
        pos[c-'a'] = append(pos[c-'a'], i)
    }
    dp := make([][]int, m)
    for i := range dp {
        dp[i] = make([]int, n)
        for j := range dp[i] {
            dp[i][j] = inf
        }
    }
    for _, p := range pos[key[0]-'a'] {
        dp[0][p] = min(p, n-p) + 1
    }
    for i := 1; i < m; i++ {
        for _, j := range pos[key[i]-'a'] {
            for _, k := range pos[key[i-1]-'a'] {
                dp[i][j] = min(dp[i][j], dp[i-1][k]+min(abs(j-k), n-abs(j-k))+1)
            }
        }
    }
    return min(dp[m-1]...)
}

func min(a ...int) int {
    res := a[0]
    for _, v := range a[1:] {
        if v < res {
            res = v
        }
    }
    return res
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}
```

```C [sol1-C]
int findRotateSteps(char* ring, char* key) {
    int n = strlen(ring), m = strlen(key);
    int pos[26][n], posSize[26];
    memset(posSize, 0, sizeof(posSize));
    for (int i = 0; i < n; ++i) {
        int x = ring[i] - 'a';
        pos[x][posSize[x]++] = i;
    }
    int dp[m][n];
    memset(dp, 0x3f3f3f3f, sizeof(dp));
    for (int i = 0; i < posSize[key[0] - 'a']; i++) {
        int x = pos[key[0] - 'a'][i];
        dp[0][x] = fmin(x, n - x) + 1;
    }
    for (int i = 1; i < m; ++i) {
        for (int j = 0; j < posSize[key[i] - 'a']; ++j) {
            int x = pos[key[i] - 'a'][j];
            for (int k = 0; k < posSize[key[i - 1] - 'a']; ++k) {
                int y = pos[key[i - 1] - 'a'][k];
                dp[i][x] = fmin(dp[i][x], dp[i - 1][y] + fmin(abs(x - y), n - abs(x - y)) + 1);
            }
        }
    }
    int ret = dp[m - 1][0];
    for (int i = 1; i < n; ++i) {
        ret = fmin(ret, dp[m - 1][i]);
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(mn^2)$，其中 $m$ 为字符串 $\textit{key}$ 的长度，$n$ 为字符串 $\textit{ring}$ 的长度。一共有 $O(mn)$ 个状态要计算，每次转移的时间复杂度为 $O(n)$，因此时间复杂度为 $O(mn^2)$。
  由于维护了位置数组 $\textit{pos}$ 加速了状态的计算与转移，因此 $O(mn^2)$ 是一个较松的上界，很多情况下的时间复杂度都会低于 $O(mn^2)$。

- 空间复杂度：$O(mn)$。需要使用 $O(mn)$ 的空间来存放 $\textit{dp}$ 数组，以及使用 $O(n)$ 的空间来存放 $\textit{pos}$ 数组，因此总空间复杂度为 $O(mn)$。如果利用滚动数组，则可以将 $\textit{dp}$ 数组的空间复杂度降低到 $O(n)$，总空间复杂度降低到 $O(n)$。
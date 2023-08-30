#### 前言

本题给定 $n$ 堆石头，每次合并连续的$k$堆，合并的成本是这 $k$ 堆石头的总数，问最终把所有石头合并为一堆的最低成本。

我们从最简单的情况入手，当 $k$ 等于 $2$ 时，每次选择相邻的两堆进行合并。在最后一次合并之前，$n$ 堆石头经过若干次合并变为两堆石头，假设 $[0, p]$ 合并为一堆，$[p+1,n-1]$ 合并为一堆，然后我们再将这两堆合并成新的一堆，这次操作的成本是 $n$ 堆石头的总数。

注意到，将 $[0, p]$ 合并为一堆以及将 $[p + 1, n - 1]$ 合并为一堆都是问题规模较小的子问题，可以递归求解。我们设 $d[l][r]$ 是 $[l, r]$ 合并为一堆石头的最低成本，然后用记忆化搜索或者递推的方式来求解。我们用初态、转移方程和目标来描述求解过程：

- 初态：对于所有的 $d[i][i]$，初始化为 $0$，其他状态初始值设置为正无穷。
- 转移方程：$d[l][r] = \min\{d[l][p] + d[p + 1][r]\}$，其中 $l \le p \lt r$。
- 目标：$d[0][n-1]$。

以上就是 $k=2$ 时的求解思路，在这种情况下，该题目为经典的[区间动态规划问题](https://oi-wiki.org/dp/interval/)。

#### 方法一：动态规划

**思路与算法**

接下来我们思考当 $k$ 为其他数字时如何求解。

$n$ 大于 $1$ 时若想将 $n$ 堆石子合并为 $1$ 堆，我们首先准备好不同的 $k$ 堆，因此可以用 $d[l][r][t]$ 描述这个状态，表示将 $[l, r]$ 合并为 $t~(1\le t \le k)$ 堆的最低成本。与 $k=2$ 时的思考方式一致，我们考虑一个分界点 $p~(l \le p \lt r)$，令 $[l, p]$ 合并为 $1$ 堆，再令 $[p + 1, r]$ 合并为 $t - 1$ 堆，这样就可以将问题拆分为两个子问题进行求解。

- 初态：对于所有的 $d[i][i][1]$，初始化为 $0$，其他状态设置为正无穷。
- 转移方程：
  - 当 $t = 1$时，$d[l][r][t] = d[l][r][k] + sum[l][r]$，其中 $sum[l][r]$是本次合并的成本，区间内石头的总数。
  - 否则，$d[l][r][t] = \min\{d[l][p][1] + d[p+1][r][t-1]\}$，其中 $l \le p \lt r$。
- 目标：$d[0][n-1][1]$。

> 在转移过程中，我们只考虑了将 $[l, p]$ 合并为 $1$ 堆的子问题，倘若将 $d[l][r][t]$ 拆分为 $d[l][p][2] + d[p + 1][r][t - 2]$ 是否可行？答案是可行的，但是会重复求解。递归求解 $d[l][p][2]$ 时，我们会再枚举一个 $p_1~(l \le p_1 \lt p)$ 来求解 $d[l][p_1][1]$。所以我们只需要考虑拆分左边区间 $[l, p]$ 合并为一堆的子问题即可，可以不重不漏的遍历所有子问题。
> 
> 为什么只考虑 $t \le k$ 的情况？因为我们在状态转移时不需要这样的子状态，如果 $t \gt k$，我们希望子问题能够把它合并到小于 $k$ 堆的状态。
>
> 那么什么情况会无解？每一次合并将 $k$ 堆石头变为 $1$ 堆，堆数减少 $k-1$，如果合并若干次要使得 $n$ 堆变为 $1$ 堆，就需要 $n - 1$ 是 $k - 1$ 的倍数。只要满足这个条件，$d[0][n-1][k]$ 一定有解，否则无解。在求解过程中，一些中间状态也有可能无解，我们可以直接用正无穷这个数字来表征它无解。
>
> 最后来看一下是否有优化点，在拆分子问题 $d[l][p][1]$ 时，我们提前知道了当 $p-l$ 是 $k-1$ 的倍数时才会有解，因此从 $l$ 开始枚举 $p$，每次递增 $k - 1$。这样可以避免很多无解状态的枚举。


**代码**

记忆化搜索代码如下

```C++ [sol1_1-C++]
class Solution {
    static constexpr int inf = 0x3f3f3f3f;
    vector<vector<vector<int>>> d;
    vector<int> sum;
    int k;
public:
    int get(int l, int r, int t) {
        // 若 d[l][r][t] 不为 -1，表示已经在之前的递归被求解过，直接返回答案
        if (d[l][r][t] != -1) {
            return d[l][r][t];
        }
        // 当石头堆数小于 t 时，一定无解
        if (t > r - l + 1) {
            return inf;
        }
        if (t == 1) {
            int res = get(l, r, k);
            if (res == inf) {
                return d[l][r][t] = inf;
            }
            return d[l][r][t] = res + (sum[r] - (l == 0 ? 0 : sum[l - 1]));
        }
        int val = inf;
        for (int p = l; p < r; p += (k - 1)) {
            val = min(val, get(l, p, 1) + get(p + 1, r, t - 1));
        }
        return d[l][r][t] = val;
    }
    int mergeStones(vector<int>& stones, int k) {
        int n = stones.size();
        if ((n - 1) % (k - 1) != 0) {
            return -1;
        }
        this->k = k;
        d = vector(n, vector(n, vector<int>(k + 1, -1)));
        sum = vector<int>(n, 0);

        // 初始化
        for (int i = 0, s = 0; i < n; i++) {
            d[i][i][1] = 0;
            s += stones[i];
            sum[i] = s;
        }
        int res = get(0, n - 1, 1);
        return res;
    }
};
```

```Java [sol1_1-Java]
class Solution {
    static final int INF = 0x3f3f3f3f;
    int[][][] d;
    int[] sum;
    int k;

    public int mergeStones(int[] stones, int k) {
        int n = stones.length;
        if ((n - 1) % (k - 1) != 0) {
            return -1;
        }
        this.k = k;
        d = new int[n][n][k + 1];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                Arrays.fill(d[i][j], -1);
            }
        }
        sum = new int[n];

        // 初始化
        for (int i = 0, s = 0; i < n; i++) {
            d[i][i][1] = 0;
            s += stones[i];
            sum[i] = s;
        }
        int res = get(0, n - 1, 1);
        return res;
    }

    public int get(int l, int r, int t) {
        // 若 d[l][r][t] 不为 -1，表示已经在之前的递归被求解过，直接返回答案
        if (d[l][r][t] != -1) {
            return d[l][r][t];
        }
        // 当石头堆数小于 t 时，一定无解
        if (t > r - l + 1) {
            return INF;
        }
        if (t == 1) {
            int res = get(l, r, k);
            if (res == INF) {
                return d[l][r][t] = INF;
            }
            return d[l][r][t] = res + (sum[r] - (l == 0 ? 0 : sum[l - 1]));
        }
        int val = INF;
        for (int p = l; p < r; p += (k - 1)) {
            val = Math.min(val, get(l, p, 1) + get(p + 1, r, t - 1));
        }
        return d[l][r][t] = val;
    }
}
```

```C# [sol1_1-C#]
public class Solution {
    const int INF = 0x3f3f3f3f;
    int[][][] d;
    int[] sum;
    int k;

    public int MergeStones(int[] stones, int k) {
        int n = stones.Length;
        if ((n - 1) % (k - 1) != 0) {
            return -1;
        }
        this.k = k;
        d = new int[n][][];
        for (int i = 0; i < n; i++) {
            d[i] = new int[n][];
            for (int j = 0; j < n; j++) {
                d[i][j] = new int[k + 1];
                Array.Fill(d[i][j], -1);
            }
        }
        sum = new int[n];

        // 初始化
        for (int i = 0, s = 0; i < n; i++) {
            d[i][i][1] = 0;
            s += stones[i];
            sum[i] = s;
        }
        int res = Get(0, n - 1, 1);
        return res;
    }

    public int Get(int l, int r, int t) {
        // 若 d[l][r][t] 不为 -1，表示已经在之前的递归被求解过，直接返回答案
        if (d[l][r][t] != -1) {
            return d[l][r][t];
        }
        // 当石头堆数小于 t 时，一定无解
        if (t > r - l + 1) {
            return INF;
        }
        if (t == 1) {
            int res = Get(l, r, k);
            if (res == INF) {
                return d[l][r][t] = INF;
            }
            return d[l][r][t] = res + (sum[r] - (l == 0 ? 0 : sum[l - 1]));
        }
        int val = INF;
        for (int p = l; p < r; p += (k - 1)) {
            val = Math.Min(val, Get(l, p, 1) + Get(p + 1, r, t - 1));
        }
        return d[l][r][t] = val;
    }
}
```

```C [sol1_1-C]
static int inf = 0x3f3f3f3f;
    
int min(int a, int b) {
    return a < b ? a : b;
}

int get(int l, int r, int t, int ***d, int *sum, int k) {
    // 若 d[l][r][t] 不为 -1，表示已经在之前的递归被求解过，直接返回答案
    if (d[l][r][t] != -1) {
        return d[l][r][t];
    }
    // 当石头堆数小于 t 时，一定无解
    if (t > r - l + 1) {
        return inf;
    }
    if (t == 1) {
        int res = get(l, r, k, d, sum, k);
        if (res == inf) {
            return d[l][r][t] = inf;
        }
        return d[l][r][t] = res + (sum[r] - (l == 0 ? 0 : sum[l - 1]));
    }
    int val = inf;
    for (int p = l; p < r; p += (k - 1)) {
        val = min(val, get(l, p, 1, d, sum, k) + get(p + 1, r, t - 1, d, sum, k));
    }
    return d[l][r][t] = val;
}

int mergeStones(int* stones, int stonesSize, int k) {
    int n = stonesSize;
    if ((n - 1) % (k - 1) != 0) {
        return -1;
    }
    int sum[n];
    int ***d = (int ***)malloc(sizeof(int **) * n);
    memset(sum, 0, sizeof(sum));
    for (int i = 0; i < n; i++) {
        d[i] = (int **)malloc(sizeof(int *) * n);
        for (int j = 0; j < n; j++) {
            d[i][j] = (int *)malloc(sizeof(int) * (k + 1));
            memset(d[i][j], 0xff, sizeof(int) * (k + 1));
        }
    }

    // 初始化
    for (int i = 0, s = 0; i < n; i++) {
        d[i][i][1] = 0;
        s += stones[i];
        sum[i] = s;
    }
    int res = get(0, n - 1, 1, d, sum, k);
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            free(d[i][j]);
        }
        free(d[i]);
    }
    return res;
}
```

```JavaScript [sol1_1-JavaScript]
const INF = 0x3f3f3f3f;
var mergeStones = function(stones, k) {
    const n = stones.length;
    if ((n - 1) % (k - 1) !== 0) {
        return -1;
    }
    const d = new Array(n).fill(0).map(() => new Array(n).fill(0).map(() => new Array(k + 1).fill(-1)));
    const sum = new Array(n).fill(0);
    // 初始化
    for (let i = 0, s = 0; i < n; i++) {
        d[i][i][1] = 0;
        s += stones[i];
        sum[i] = s;
    }

    const get = (l, r, t) => {
        // 若 d[l][r][t] 不为 -1，表示已经在之前的递归被求解过，直接返回答案
        if (d[l][r][t] !== -1) {
            return d[l][r][t];
        }
        // 当石头堆数小于 t 时，一定无解
        if (t > r - l + 1) {
            return INF;
        }
        if (t === 1) {
            const res = get(l, r, k);
            if (res === INF) {
                return d[l][r][t] = INF;
            }
            return d[l][r][t] = res + (sum[r] - (l === 0 ? 0 : sum[l - 1]));
        }
        let val = INF;
        for (let p = l; p < r; p += (k - 1)) {
            val = Math.min(val, get(l, p, 1) + get(p + 1, r, t - 1));
        }
        return d[l][r][t] = val;
    }

    const res = get(0, n - 1, 1);
    return res;
};
```

递推代码如下

```C++ [sol1_2-C++]
class Solution {
    static constexpr int inf = 0x3f3f3f3f;
public:
    int mergeStones(vector<int>& stones, int k) {
        int n = stones.size();
        if ((n - 1) % (k - 1) != 0) {
            return -1;
        }

        vector d(n, vector(n, vector<int>(k + 1, inf)));
        vector<int> sum(n, 0);

        for (int i = 0, s = 0; i < n; i++) {
            d[i][i][1] = 0;
            s += stones[i];
            sum[i] = s;
        }

        for (int len = 2; len <= n; len++) {
            for (int l = 0; l < n && l + len - 1 < n; l++) {
                int r = l + len - 1;
                for (int t = 2; t <= k; t++) {
                    for (int p = l; p < r; p += k - 1) {
                        d[l][r][t] = min(d[l][r][t], d[l][p][1] + d[p + 1][r][t - 1]);
                    }
                }
                d[l][r][1] = min(d[l][r][1], d[l][r][k] + 
                                sum[r] - (l == 0 ? 0 : sum[l - 1]));
            }
        }
        return d[0][n - 1][1];
    }
};
```

```Java [sol1_2-Java]
class Solution {
    static final int INF = 0x3f3f3f3f;

    public int mergeStones(int[] stones, int k) {
        int n = stones.length;
        if ((n - 1) % (k - 1) != 0) {
            return -1;
        }

        int[][][] d = new int[n][n][k + 1];
        int[] sum = new int[n];

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                Arrays.fill(d[i][j], INF);
            }
        }

        for (int i = 0, s = 0; i < n; i++) {
            d[i][i][1] = 0;
            s += stones[i];
            sum[i] = s;
        }

        for (int len = 2; len <= n; len++) {
            for (int l = 0; l < n && l + len - 1 < n; l++) {
                int r = l + len - 1;
                for (int t = 2; t <= k; t++) {
                    for (int p = l; p < r; p += k - 1) {
                        d[l][r][t] = Math.min(d[l][r][t], d[l][p][1] + d[p + 1][r][t - 1]);
                    }
                }
                d[l][r][1] = Math.min(d[l][r][1], d[l][r][k] + sum[r] - (l == 0 ? 0 : sum[l - 1]));
            }
        }
        return d[0][n - 1][1];
    }
}
```

```C# [sol1_2-C#]
public class Solution {
    const int INF = 0x3f3f3f3f;

    public int MergeStones(int[] stones, int k) {
        int n = stones.Length;
        if ((n - 1) % (k - 1) != 0) {
            return -1;
        }

        int[][][] d = new int[n][][];
        int[] sum = new int[n];

        for (int i = 0; i < n; i++) {
            d[i] = new int[n][];
            for (int j = 0; j < n; j++) {
                d[i][j] = new int[k + 1];
                Array.Fill(d[i][j], INF);
            }
        }

        for (int i = 0, s = 0; i < n; i++) {
            d[i][i][1] = 0;
            s += stones[i];
            sum[i] = s;
        }

        for (int len = 2; len <= n; len++) {
            for (int l = 0; l < n && l + len - 1 < n; l++) {
                int r = l + len - 1;
                for (int t = 2; t <= k; t++) {
                    for (int p = l; p < r; p += k - 1) {
                        d[l][r][t] = Math.Min(d[l][r][t], d[l][p][1] + d[p + 1][r][t - 1]);
                    }
                }
                d[l][r][1] = Math.Min(d[l][r][1], d[l][r][k] + sum[r] - (l == 0 ? 0 : sum[l - 1]));
            }
        }
        return d[0][n - 1][1];
    }
}
```

```C [sol1_2-C]
const int inf = 0x3f3f3f3f;

int min(int a, int b) {
    return a < b ? a : b;
}

int mergeStones(int* stones, int stonesSize, int k) {
    int n = stonesSize;
    if ((n - 1) % (k - 1) != 0) {
        return -1;
    }
    int sum[n];
    int d[n][n][k + 1];
    memset(sum, 0, sizeof(sum));
    memset(d, 0x3f, sizeof(d));

    for (int i = 0, s = 0; i < n; i++) {
        d[i][i][1] = 0;
        s += stones[i];
        sum[i] = s;
    }
    for (int len = 2; len <= n; len++) {
        for (int l = 0; l < n && l + len - 1 < n; l++) {
            int r = l + len - 1;
            for (int t = 2; t <= k; t++) {
                for (int p = l; p < r; p += k - 1) {
                    d[l][r][t] = min(d[l][r][t], d[l][p][1] + d[p + 1][r][t - 1]);
                }
            }
            d[l][r][1] = min(d[l][r][1], d[l][r][k] + 
                            sum[r] - (l == 0 ? 0 : sum[l - 1]));
        }
    }
    return d[0][n - 1][1];
}
```

```Python [sol1_2-Python3]
class Solution:
    def mergeStones(self, stones: List[int], k: int) -> int:
        n = len(stones)
        if (n - 1) % (k - 1) != 0:
            return -1

        d = [[[inf] * (k + 1) for _ in range(n)] for _ in range(n)]
        sum = [0] * n
        s = 0
        for i in range(n):
            d[i][i][1] = 0
            s += stones[i]
            sum[i] = s

        for L in range(2, n + 1):
            for l in range(n - L + 1):
                r = l + L - 1
                for t in range(2, k + 1):
                    for p in range(l, r, k - 1):
                        d[l][r][t] = min(d[l][r][t], d[l][p][1] + d[p + 1][r][t - 1])
                d[l][r][1] = min(d[l][r][1], d[l][r][k] + (sum[r] - (0 if l == 0 else sum[l - 1])))
        return d[0][n - 1][1]
```

```JavaScript [sol1_2-JavaScript]
const INF = 0x3f3f3f3f;
var mergeStones = function(stones, k) {
    const n = stones.length;
    if ((n - 1) % (k - 1) !== 0) {
        return -1;
    }

    const d = new Array(n).fill(0).map(() => new Array(n).fill(0).map(() => new Array(k + 1).fill(INF)));
    const sum = new Array(n).fill(0);

    for (let i = 0, s = 0; i < n; i++) {
        d[i][i][1] = 0;
        s += stones[i];
        sum[i] = s;
    }

    for (let len = 2; len <= n; len++) {
        for (let l = 0; l < n && l + len - 1 < n; l++) {
            let r = l + len - 1;
            for (let t = 2; t <= k; t++) {
                for (let p = l; p < r; p += k - 1) {
                    d[l][r][t] = Math.min(d[l][r][t], d[l][p][1] + d[p + 1][r][t - 1]);
                }
            }
            d[l][r][1] = Math.min(d[l][r][1], d[l][r][k] + sum[r] - (l === 0 ? 0 : sum[l - 1]));
        }
    }
    return d[0][n - 1][1];
};
```

```go [sol1_2-Golang]
func mergeStones(stones []int, k int) int {
    n := len(stones)
    if (n-1)%(k-1) != 0 {
        return -1
    }

    d := make([][][]int, n)
    for i := range d {
        d[i] = make([][]int, n)
        for j := range d[i] {
            d[i][j] = make([]int, k+1)
            for k := range d[i][j] {
                d[i][j][k] = 1e9
            }
        }
    }
    sum := make([]int, n+1)
    for i, s := 0, 0; i < n; i++ {
        d[i][i][1] = 0
        s += stones[i]
        sum[i+1] = s
    }

    for len := 2; len <= n; len++ {
        for l := 0; l < n && l+len-1 < n; l++ {
            r := l + len - 1
            for t := 2; t <= k; t++ {
                for p := l; p < r; p += k - 1 {
                    d[l][r][t] = min(d[l][r][t], d[l][p][1]+d[p+1][r][t-1])
                }
            }
            d[l][r][1] = min(d[l][r][1], d[l][r][k]+sum[r+1]-sum[l])
        }
    }
    return d[0][n-1][1]
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n^3k)$，其中 $n$ 是 $\textit{stones}$ 的长度。

- 空间复杂度：$O(n^2k)$，其中 $n$ 是 $\textit{stones}$ 的长度。

#### 方法二：状态优化

在方法一中，我们用 $d[l][r][t]$ 表示将区间 $[l,r]$ 的石头堆合并为 $t$ 堆的最小成本，这里 $t$ 的范围是 $[1,k]$。事实上，对于一个固定的区间 $[l,r]$，最终合并到小于 $k$ 堆时的堆数是固定的。

我们每次合并都会减小 $k - 1$ 堆，初始时 $[l,r]$ 的堆数是 $r - l + 1$，合并到不能合并时的堆数为 $(r - l) \mod (k - 1) + 1$。所以我们可以直接用 $d[l][r]$ 表示将区间 $[l,r]$ 合并到不能为止时的最小成本。它本质上是通过忽略方法一中一定无解的状态，加快求解。

- 初态：对于所有的 $d[i][i]$，初始化为 $0$，其他状态设置为正无穷。
- 转移方程：
  - $d[l][r] = \min\{d[l][p] + d[p+1][r]\}$，其中 $l \le p \lt r$。
  - 如果 $(r - l) \mod (k - 1) = 0$ 则还需加上 $sum[l][r]$。
- 目标：$d[0][n-1]$。

```C++ [sol2-C++]
class Solution {
    static constexpr int inf = 0x3f3f3f3f;
public:
    int mergeStones(vector<int>& stones, int k) {
        int n = stones.size();
        if ((n - 1) % (k - 1) != 0) {
            return -1;
        }

        vector d(n, vector<int>(n, inf));
        vector<int> sum(n, 0);

        for (int i = 0, s = 0; i < n; i++) {
            d[i][i] = 0;
            s += stones[i];
            sum[i] = s;
        }

        for (int len = 2; len <= n; len++) {
            for (int l = 0; l < n && l + len - 1 < n; l++) {
                int r = l + len - 1;
                for (int p = l; p < r; p += k - 1) {
                    d[l][r] = min(d[l][r], d[l][p] + d[p + 1][r]);
                }
                if ((r - l) % (k - 1) == 0) {
                    d[l][r] += sum[r] - (l == 0 ? 0 : sum[l - 1]);
                }
            }
        }
        return d[0][n - 1];
    }
};
```

```Java [sol2-Java]
class Solution {
    static final int INF = 0x3f3f3f3f;

    public int mergeStones(int[] stones, int k) {
        int n = stones.length;
        if ((n - 1) % (k - 1) != 0) {
            return -1;
        }

        int[][] d = new int[n][n];
        for (int i = 0; i < n; i++) {
            Arrays.fill(d[i], INF);
        }
        int[] sum = new int[n];

        for (int i = 0, s = 0; i < n; i++) {
            d[i][i] = 0;
            s += stones[i];
            sum[i] = s;
        }

        for (int len = 2; len <= n; len++) {
            for (int l = 0; l < n && l + len - 1 < n; l++) {
                int r = l + len - 1;
                for (int p = l; p < r; p += k - 1) {
                    d[l][r] = Math.min(d[l][r], d[l][p] + d[p + 1][r]);
                }
                if ((r - l) % (k - 1) == 0) {
                    d[l][r] += sum[r] - (l == 0 ? 0 : sum[l - 1]);
                }
            }
        }
        return d[0][n - 1];
    }
}
```

```C# [sol2-C#]
public class Solution {
    const int INF = 0x3f3f3f3f;

    public int MergeStones(int[] stones, int k) {
        int n = stones.Length;
        if ((n - 1) % (k - 1) != 0) {
            return -1;
        }

        int[][] d = new int[n][];
        for (int i = 0; i < n; i++) {
            d[i] = new int[n];
            Array.Fill(d[i], INF);
        }
        int[] sum = new int[n];

        for (int i = 0, s = 0; i < n; i++) {
            d[i][i] = 0;
            s += stones[i];
            sum[i] = s;
        }

        for (int len = 2; len <= n; len++) {
            for (int l = 0; l < n && l + len - 1 < n; l++) {
                int r = l + len - 1;
                for (int p = l; p < r; p += k - 1) {
                    d[l][r] = Math.Min(d[l][r], d[l][p] + d[p + 1][r]);
                }
                if ((r - l) % (k - 1) == 0) {
                    d[l][r] += sum[r] - (l == 0 ? 0 : sum[l - 1]);
                }
            }
        }
        return d[0][n - 1];
    }
}
```

```C [sol2-C]
const int inf = 0x3f3f3f3f;

int min(int a, int b) {
    return a < b ? a : b;
}

int mergeStones(int* stones, int stonesSize, int k) {
    int n = stonesSize;
    if ((n - 1) % (k - 1) != 0) {
        return -1;
    }

    int d[n][n];
    int sum[n];
    memset(d, 0x3f, sizeof(d));
    memset(sum, 0, sizeof(sum));

    for (int i = 0, s = 0; i < n; i++) {
        d[i][i] = 0;
        s += stones[i];
        sum[i] = s;
    }

    for (int len = 2; len <= n; len++) {
        for (int l = 0; l < n && l + len - 1 < n; l++) {
            int r = l + len - 1;
            for (int p = l; p < r; p += k - 1) {
                d[l][r] = min(d[l][r], d[l][p] + d[p + 1][r]);
            }
            if ((r - l) % (k - 1) == 0) {
                d[l][r] += sum[r] - (l == 0 ? 0 : sum[l - 1]);
            }
        }
    }
    return d[0][n - 1];
}
```

```Python [sol2-Python3]
class Solution:
    def mergeStones(self, stones: List[int], k: int) -> int:
        n = len(stones)
        if (n - 1) % (k - 1) != 0:
            return -1

        d = [[inf] * n for _ in range(n)]
        sum = [0] * n
        s = 0
        for i in range(n):
            d[i][i] = 0
            s += stones[i]
            sum[i] = s

        for L in range(2, n + 1):
            for l in range(n - L + 1):
                r = l + L - 1
                for p in range(l, r, k - 1):
                    d[l][r] = min(d[l][r], d[l][p] + d[p + 1][r])
                if (r - l) % (k - 1) == 0:
                    d[l][r] += (sum[r] - (0 if l == 0 else sum[l - 1]))
        return d[0][n - 1]
```

```JavaScript [sol2-JavaScript]
const INF = 0x3f3f3f3f;
var mergeStones = function(stones, k) {
    const n = stones.length;
    if ((n - 1) % (k - 1) !== 0) {
        return -1;
    }

    const d = new Array(n).fill(0).map(() => new Array(n).fill(INF));
    const sum = new Array(n).fill(0);

    for (let i = 0, s = 0; i < n; i++) {
        d[i][i] = 0;
        s += stones[i];
        sum[i] = s;
    }

    for (let len = 2; len <= n; len++) {
        for (let l = 0; l < n && l + len - 1 < n; l++) {
            let r = l + len - 1;
            for (let p = l; p < r; p += k - 1) {
                d[l][r] = Math.min(d[l][r], d[l][p] + d[p + 1][r]);
            }
            if ((r - l) % (k - 1) === 0) {
                d[l][r] += sum[r] - (l === 0 ? 0 : sum[l - 1]);
            }
        }
    }
    return d[0][n - 1];
};
```

```go [sol2-Golang]
func mergeStones(stones []int, k int) int {
    n := len(stones)
    if (n-1)%(k-1) != 0 {
        return -1
    }

    d := make([][]int, n)
    for i := range d {
        d[i] = make([]int, n)
        for j := range d[i] {
            d[i][j] = 1e9
        }
    }
    sum := make([]int, n+1)
    for i, s := 0, 0; i < n; i++ {
        d[i][i] = 0
        s += stones[i]
        sum[i+1] = s
    }

    for len := 2; len <= n; len++ {
        for l := 0; l < n && l+len-1 < n; l++ {
            r := l + len - 1
            for p := l; p < r; p += k - 1 {
                d[l][r] = min(d[l][r], d[l][p]+d[p+1][r])
            }
            if (r-l)%(k-1) == 0 {
                d[l][r] += sum[r+1] - sum[l]
            }
        }
    }
    return d[0][n-1]
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 是 $\textit{stones}$ 的长度。

- 空间复杂度：$O(n^2)$，其中 $n$ 是 $\textit{stones}$ 的长度。
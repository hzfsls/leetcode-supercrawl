## [1659.最大化网格幸福感 中文官方题解](https://leetcode.cn/problems/maximize-grid-happiness/solutions/100000/zui-da-hua-wang-ge-xing-fu-gan-by-leetco-0flf)
#### 方法一：状态压缩+动态规划

**思路与算法**

为了方便描述，我们用 $\textit{iv}$ 和 $\textit{ev}$ 分别代表内向和外向的人数，并使用分数代指幸福感。

题目要求将 $\textit{ev} + \textit{iv}$ 个人分配到 $m \times n$ 的网格中，如果要考虑使用暴力搜索的方法遍历每一种可能，我们需要对搜索空间有一个初步的了解。在最差的情况下，需要将 $6$ 个内向的人和 $6$ 个外向的人分配到 $5\times 5 = 25$ 的网格中，按照组合数学的计算方法，我们首先从 $25$ 个位置中选出 $6$ 个分配给内向的人，然后再从 $25 - 6 = 19$ 个位置中选出 $6$ 个分配给外向的人，总方案数为：

$${25 \choose 6}{19 \choose 6} \approx 4.8 \times 10^9 $$

由此可见，暴力搜索的方法很容易超时，我们需要寻求其他方法。注意到每个网格只有三种状态：空置、内向、外向，将它们编码为 $0,1,2$，并对每一行的状态使用长度为 $n$ 的三进制数进行编码。这样一来，就可以使用基于状态压缩的动态规划了。

我们定义状态 $d(\textit{row}, \textit{premask}, \textit{iv}, \textit{ev})$ 表示第 $\textit{row} - 1$ 行的状态是 $\textit{premask}$，并且 $\textit{row}\sim m - 1$ 行最多还可以放置 $\textit{iv}$ 个内向的人和 $\textit{ev}$ 个外向的人时的分数。在转移过程中，我们需要考虑两部分的答案计算：

1. 行内分数：每一行内部，一个内向的人 $120$ 分，一个外向的人 $40$ 分，如果有相邻的人，再计算邻居间的得分。两个内向的相邻得分 $-60$，两个外向的相邻得分 $40$，其余相邻情况得分为 $-10$，如果有空置的位置得分一律为 $0$。
2. 行间分数：每两行之间，邻居间的得分，计算方法同上。

我们可以在开始求解之前，预先计算出所有状态的行内分数以及所有状态间的行间分数。具体来说，遍历所有长度为 $n$ 的三进制数 $\textit{mask}$，计算行内分数以及 $\textit{mask}$ 中内向的个数 $\textit{iv\_count}[\textit{mask}]$ 和外向的个数 $\textit{ev\_count}[\textit{mask}]$，过程中顺便将 $\textit{mask}$ 的每一位预先存储到 $\textit{mask\_bits}[mask]$ ，便于后续计算行间分数。

转移时，遍历 $\textit{row}$ 行的状态 $\textit{mask}$，有如下转移方程：

$$
\begin{aligned}
& d(\textit{row}, \textit{premask}, \textit{iv}, \textit{ev}) = \max \big\{ \\
& \qquad d(\textit{row} + 1, \textit{mask}, \textit{iv} - \textit{iv\_count}[\textit{mask}], \textit{ev} - \textit{ev\_count}[\textit{mask}]) \\
& \qquad + \textit{inner\_score}[\textit{mask}] + \textit{inter\_score}[\textit{mask}][\textit{premask}] \\
\big\}
\end{aligned}
$$

其中 $\textit{inner\_score}[\textit{mask}]$ 表示 $\textit{mask}$ 的行内分数，$\textit{inter\_score}[\textit{mask}][\textit{premask}]$ 表示 $\textit{mask}$ 和 $\textit{premask}$ 的行间分数。

我们使用记忆化搜索的方式去实现，从 $d(0, 0, \textit{iv}, \textit{ev})$ 开始求解，假设第 $0$ 行的 $premask$ 为 $0$，这样做可行的原因是状态为 $0$ 的行对分数没有贡献。当状态满足以下条件时，可以直接返回答案：

1. 当 $\textit{row} = m$ 时，已经遍历完所有的行，**由于题目并不要求将所有的人都安排到网格中**，所以该状态合法，分数为 $0$。
2. 当 $\textit{iv} = \textit{ev} = 0$，表示后续已经没有人可以放置，该状态合法，分数为 $0$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int T = 243, N = 5, M = 6;
    int n, m, tot;
    int mask_bits[T][N];
    int iv_count[T], ev_count[T];
    int inner_score[T], inter_score[T][T];
    int d[N][T][M + 1][M + 1];

    // 邻居间的分数
    static constexpr int score[3][3] = {
        {0, 0, 0},
        {0, -60, -10},
        {0, -10, 40}
    };

public:
    void init_data() {
        // 计算行内分数
        for (int mask = 0; mask < tot; mask++) {
            int mask_tmp = mask;
            for (int i = 0; i < n; i++) {
                int x = mask_tmp % 3;
                mask_bits[mask][i] = x;
                mask_tmp /= 3;
                if (x == 1) {
                    iv_count[mask]++;
                    inner_score[mask] += 120;
                } else if (x == 2) {
                    ev_count[mask]++;
                    inner_score[mask] += 40;
                }
                if (i > 0) {
                    inner_score[mask] += score[x][mask_bits[mask][i - 1]];
                }
            }
        }
        // 计算行间分数
        for (int i = 0; i < tot; i++) {
            for (int j = 0; j < tot; j++) {
                inter_score[i][j] = 0;
                for (int k = 0; k < n; k++) {
                    inter_score[i][j] += score[mask_bits[i][k]][mask_bits[j][k]];
                }
            }
        }
    }

    int getMaxGridHappiness(int m, int n, int introvertsCount, int extrovertsCount) {
        this->n = n;
        this->m = m;
        // 状态总数为 3^n
        this->tot = pow(3, n);

        init_data();
        // 记忆化搜索数组，初始化为 -1，表示未赋值
        memset(d, -1, sizeof d);
        return dfs(0, 0, introvertsCount, extrovertsCount);
    }

    int dfs(int row, int premask, int iv, int ev) {
        if (row == m || (iv == 0 && ev == 0)) {
            return 0;
        }
        // 如果该状态已经计算过答案，则直接返回
        if (d[row][premask][iv][ev] != -1) {
            return d[row][premask][iv][ev];
        }
        // 使用引用，简化代码
        int& res = d[row][premask][iv][ev];
        // 合法状态，初始值为 0
        res = 0;
        for (int mask = 0; mask < tot; mask++) {
            // mask 包含的内向人数不能超过 iv ，外向人数不能超过 ev
            if (iv_count[mask] > iv || ev_count[mask] > ev) {
                continue;
            }
            res = max(res, dfs(row + 1, mask, iv - iv_count[mask], ev - ev_count[mask]) 
                            + inner_score[mask] 
                            + inter_score[premask][mask]);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int T = 243, N = 5, M = 6;
    int n, m, tot;
    int[][] maskBits;
    int[] ivCount;
    int[] evCount;
    int[] innerScore;
    int[][] interScore;
    int[][][][] d;
    // 邻居间的分数
    static int[][] score = {
        {0, 0, 0},
        {0, -60, -10},
        {0, -10, 40}
    };

    public int getMaxGridHappiness(int m, int n, int introvertsCount, int extrovertsCount) {
        this.n = n;
        this.m = m;
        // 状态总数为 3^n
        this.tot = (int) Math.pow(3, n);
        this.maskBits = new int[T][N];
        this.ivCount = new int[T];
        this.evCount = new int[T];
        this.innerScore = new int[T];
        this.interScore = new int[T][T];
        this.d = new int[N][T][M + 1][M + 1];

        initData();
        // 记忆化搜索数组，初始化为 -1，表示未赋值
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < T; j++) {
                for (int k = 0; k <= M; k++) {
                    Arrays.fill(d[i][j][k], -1);
                }
            }
        }
        return dfs(0, 0, introvertsCount, extrovertsCount);
    }

    public void initData() {
        // 计算行内分数
        for (int mask = 0; mask < tot; mask++) {
            int maskTmp = mask;
            for (int i = 0; i < n; i++) {
                int x = maskTmp % 3;
                maskBits[mask][i] = x;
                maskTmp /= 3;
                if (x == 1) {
                    ivCount[mask]++;
                    innerScore[mask] += 120;
                } else if (x == 2) {
                    evCount[mask]++;
                    innerScore[mask] += 40;
                }
                if (i > 0) {
                    innerScore[mask] += score[x][maskBits[mask][i - 1]];
                }
            }
        }
        // 计算行间分数
        for (int i = 0; i < tot; i++) {
            for (int j = 0; j < tot; j++) {
                interScore[i][j] = 0;
                for (int k = 0; k < n; k++) {
                    interScore[i][j] += score[maskBits[i][k]][maskBits[j][k]];
                }
            }
        }
    }

    public int dfs(int row, int premask, int iv, int ev) {
        if (row == m || (iv == 0 && ev == 0)) {
            return 0;
        }
        // 如果该状态已经计算过答案，则直接返回
        if (d[row][premask][iv][ev] != -1) {
            return d[row][premask][iv][ev];
        }
        // 合法状态，初始值为 0
        int res = 0;
        for (int mask = 0; mask < tot; mask++) {
            // mask 包含的内向人数不能超过 iv ，外向人数不能超过 ev
            if (ivCount[mask] > iv || evCount[mask] > ev) {
                continue;
            }
            res = Math.max(res, dfs(row + 1, mask, iv - ivCount[mask], ev - evCount[mask]) 
                            + innerScore[mask] 
                            + interScore[premask][mask]);
        }
        d[row][premask][iv][ev] = res;
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    const int T = 243, N = 5, M = 6;
    int n, m, tot;
    int[][] maskBits;
    int[] ivCount;
    int[] evCount;
    int[] innerScore;
    int[][] interScore;
    int[][][][] d;
    // 邻居间的分数
    static int[][] score = {
        new int[]{0, 0, 0},
        new int[]{0, -60, -10},
        new int[]{0, -10, 40}
    };

    public int GetMaxGridHappiness(int m, int n, int introvertsCount, int extrovertsCount) {
        this.n = n;
        this.m = m;
        // 状态总数为 3^n
        this.tot = (int) Math.Pow(3, n);
        this.maskBits = new int[T][];
        for (int i = 0; i < T; i++) {
            this.maskBits[i] = new int[N];
        }
        this.ivCount = new int[T];
        this.evCount = new int[T];
        this.innerScore = new int[T];
        this.interScore = new int[T][];
        for (int i = 0; i < T; i++) {
            this.interScore[i] = new int[T];
        }
        this.d = new int[N][][][];

        InitData();
        // 记忆化搜索数组，初始化为 -1，表示未赋值
        for (int i = 0; i < N; i++) {
            d[i] = new int[T][][];
            for (int j = 0; j < T; j++) {
                d[i][j] = new int[M + 1][];
                for (int k = 0; k <= M; k++) {
                    d[i][j][k] = new int[M + 1];
                    Array.Fill(d[i][j][k], -1);
                }
            }
        }
        return DFS(0, 0, introvertsCount, extrovertsCount);
    }

    public void InitData() {
        // 计算行内分数
        for (int mask = 0; mask < tot; mask++) {
            int maskTmp = mask;
            for (int i = 0; i < n; i++) {
                int x = maskTmp % 3;
                maskBits[mask][i] = x;
                maskTmp /= 3;
                if (x == 1) {
                    ivCount[mask]++;
                    innerScore[mask] += 120;
                } else if (x == 2) {
                    evCount[mask]++;
                    innerScore[mask] += 40;
                }
                if (i > 0) {
                    innerScore[mask] += score[x][maskBits[mask][i - 1]];
                }
            }
        }
        // 计算行间分数
        for (int i = 0; i < tot; i++) {
            for (int j = 0; j < tot; j++) {
                interScore[i][j] = 0;
                for (int k = 0; k < n; k++) {
                    interScore[i][j] += score[maskBits[i][k]][maskBits[j][k]];
                }
            }
        }
    }

    public int DFS(int row, int premask, int iv, int ev) {
        if (row == m || (iv == 0 && ev == 0)) {
            return 0;
        }
        // 如果该状态已经计算过答案，则直接返回
        if (d[row][premask][iv][ev] != -1) {
            return d[row][premask][iv][ev];
        }
        // 合法状态，初始值为 0
        int res = 0;
        for (int mask = 0; mask < tot; mask++) {
            // mask 包含的内向人数不能超过 iv ，外向人数不能超过 ev
            if (ivCount[mask] > iv || evCount[mask] > ev) {
                continue;
            }
            res = Math.Max(res, DFS(row + 1, mask, iv - ivCount[mask], ev - evCount[mask]) 
                            + innerScore[mask] 
                            + interScore[premask][mask]);
        }
        d[row][premask][iv][ev] = res;
        return res;
    }
}
```

```C [sol1-C]
#define T 243
#define N 5
#define M 6

int mask_bits[T][N];
int iv_count[T], ev_count[T];
int inner_score[T], inter_score[T][T];
int d[N][T][M + 1][M + 1];

// 邻居间的分数
const int score[3][3] = {
    {0, 0, 0},
    {0, -60, -10},
    {0, -10, 40}
};

int dfs(int row, int premask, int iv, int ev, int m, int tot) {
    if (row == m || (iv == 0 && ev == 0)) {
        return 0;
    }
    // 如果该状态已经计算过答案，则直接返回
    if (d[row][premask][iv][ev] != -1) {
        return d[row][premask][iv][ev];
    }
    // 使用引用，简化代码
    int *res = &d[row][premask][iv][ev];
    // 合法状态，初始值为 0
    *res = 0;
    for (int mask = 0; mask < tot; mask++) {
        // mask 包含的内向人数不能超过 iv ，外向人数不能超过 ev
        if (iv_count[mask] > iv || ev_count[mask] > ev) {
            continue;
        }
        *res = fmax(*res, dfs(row + 1, mask, iv - iv_count[mask], ev - ev_count[mask], m, tot) 
                        + inner_score[mask] 
                        + inter_score[premask][mask]);
    }
    return *res;
}

void init_data(int m, int n, int tot) {
    memset(mask_bits, 0, sizeof(mask_bits));
    memset(iv_count, 0, sizeof(iv_count));
    memset(ev_count, 0, sizeof(ev_count));
    memset(inner_score, 0, sizeof(inner_score));
    memset(inter_score, 0, sizeof(inter_score));

    // 计算行内分数
    for (int mask = 0; mask < tot; mask++) {
        int mask_tmp = mask;
        for (int i = 0; i < n; i++) {
            int x = mask_tmp % 3;
            mask_bits[mask][i] = x;
            mask_tmp /= 3;
            if (x == 1) {
                iv_count[mask]++;
                inner_score[mask] += 120;
            } else if (x == 2) {
                ev_count[mask]++;
                inner_score[mask] += 40;
            }
            if (i > 0) {
                inner_score[mask] += score[x][mask_bits[mask][i - 1]];
            }
        }
    }
    // 计算行间分数
    for (int i = 0; i < tot; i++) {
        for (int j = 0; j < tot; j++) {
            inter_score[i][j] = 0;
            for (int k = 0; k < n; k++) {
                inter_score[i][j] += score[mask_bits[i][k]][mask_bits[j][k]];
            }
        }
    }
}

int getMaxGridHappiness(int m, int n, int introvertsCount, int extrovertsCount) {
    int tot = pow(3, n);
    init_data(m, n, tot);
    // 记忆化搜索数组，初始化为 -1，表示未赋值
    memset(d, -1, sizeof(d));
    return dfs(0, 0, introvertsCount, extrovertsCount, m, tot);
}
```

```JavaScript [sol1-JavaScript]
const T = 243;
const N = 5;
const M = 6;

const score = [
    [0, 0, 0],
    [0, -60, -10],
    [0, -10, 40]
];

function getMaxGridHappiness(m, n, introvertsCount, extrovertsCount) {
    let tot = Math.pow(3, n);
    let maskBits = new Array(T).fill(0).map(() => new Array(N).fill(0));
    let ivCount = new Array(T).fill(0);
    let evCount = new Array(T).fill(0);
    let innerScore = new Array(T).fill(0);
    let interScore = new Array(T).fill(0).map(() => new Array(T).fill(0));
    let d = new Array(N).fill(0).map(() => new Array(T).fill(0).map(() => new Array(M + 1).fill(0).map(() => new Array(M + 1).fill(-1))));

    initData();

    for (let i = 0; i < N; i++) {
        for (let j = 0; j < T; j++) {
            for (let k = 0; k <= M; k++) {
                d[i][j][k].fill(-1);
            }
        }
    }

    return dfs(0, 0, introvertsCount, extrovertsCount);

    function initData() {
        for (let mask = 0; mask < tot; mask++) {
            let maskTmp = mask;
            for (let i = 0; i < n; i++) {
                let x = maskTmp % 3;
                maskBits[mask][i] = x;
                maskTmp = Math.floor(maskTmp / 3);
                if (x === 1) {
                    ivCount[mask]++;
                    innerScore[mask] += 120;
                } else if (x === 2) {
                    evCount[mask]++;
                    innerScore[mask] += 40;
                }
                if (i > 0) {
                    innerScore[mask] += score[x][maskBits[mask][i - 1]];
                }
            }
        }

        for (let i = 0; i < tot; i++) {
            for (let j = 0; j < tot; j++) {
                interScore[i][j] = 0;
                for (let k = 0; k < n; k++) {
                    interScore[i][j] += score[maskBits[i][k]][maskBits[j][k]];
                }
            }
        }
    }

    function dfs(row, premask, iv, ev) {
        if (row === m || (iv === 0 && ev === 0)) {
            return 0;
        }

        if (d[row][premask][iv][ev] !== -1) {
            return d[row][premask][iv][ev];
        }

        let res = 0;
        for (let mask = 0; mask < tot; mask++) {
            if (ivCount[mask] > iv || evCount[mask] > ev) {
                continue;
            }

            res = Math.max(
                res,
                dfs(row + 1, mask, iv - ivCount[mask], ev - evCount[mask]) +
                innerScore[mask] +
                interScore[premask][mask]
            );
        }

        d[row][premask][iv][ev] = res;
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def getMaxGridHappiness(self, m: int, n: int, introvertsCount: int, extrovertsCount: int) -> int:
        T, N, M = 243, 5, 6
        # 邻居间的分数
        score = [
            [0, 0, 0],
            [0, -60, -10],
            [0, -10, 40],
        ]

        tot = 3**n
        mask_bits = [[0] * N for _ in range(T)]
        iv_count, ev_count = [0] * T, [0] * T
        inner_score = [0] * T
        inter_score = [[0] * T for _ in range(T)]
    
        def init_data() -> None:
            # 计算行内分数
            for mask in range(tot):
                mask_tmp = mask
                for i in range(n):
                    x = mask_tmp % 3
                    mask_bits[mask][i] = x
                    mask_tmp //= 3
                    if x == 1:
                        iv_count[mask] += 1
                        inner_score[mask] += 120
                    elif x == 2:
                        ev_count[mask] += 1
                        inner_score[mask] += 40
                    if i > 0:
                        inner_score[mask] += score[x][mask_bits[mask][i - 1]]
            # 计算行间分数
            for i in range(tot):
                for j in range(tot):
                    for k in range(n):
                        inter_score[i][j] += score[mask_bits[i][k]][mask_bits[j][k]]
        
        @cache
        def dfs(row: int, premask: int, iv: int, ev: int) -> int:
            if row == m or (iv == 0 and ev == 0):
                return 0
            
            res = 0
            for mask in range(tot):
                # mask 包含的内向人数不能超过 iv ，外向人数不能超过 ev
                if iv_count[mask] > iv or ev_count[mask] > ev:
                    continue
                res = max(res, dfs(row + 1, mask, iv - iv_count[mask], ev - ev_count[mask]) + inner_score[mask] + inter_score[premask][mask])
            return res

        init_data()
        return dfs(0, 0, introvertsCount, extrovertsCount)
```

**复杂度分析**

- 时间复杂度：$O((m\times \textit{iv} \times \textit{ev} + n) \times 3^{2n})$，其中 $m$ 是行数，$n$ 是列数，$iv$ 是内向的人数，$ev$ 是外向的人数。时间复杂度可以分为以下几个部分计算：
  - 预处理部分：计算行内分数时，遍历每一种状态的每一位，时间复杂度为 $O(n3^n)$。计算行间分数时，遍历每两种状态的每一位，时间复杂度为 $O(n3^{2n})$。因此这一部分的时间复杂度为 $O(n3^{2n})$。
  - 记忆化搜索部分：状态总数为 $O(m\times \textit{iv} \times \textit{ev} \times 3^n)$，每一次转移需枚举 $O(3^n)$ 次，转移的时间复杂度为 $O(1)$。因此这一部分的时间复杂度为 $O(m\times \textit{iv} \times \textit{ev} \times 3^{2n})$。
- 空间复杂度：$O(m\times \textit{iv} \times \textit{ev} \times 3^n + 3^{2n})$。可分为以下几个部分计算：
  - 预处理部分：存储三进制的每一位需要的空间为 $O(n3^n)$，存储行内分数、状态内内向的人的个数以及外向的人的个数需要的空间为 $O(3^n)$，存储行间分数需要的空间为 $O(3^{2n})$。这一部分的空间复杂度为 $O(3^{2n})$。
  - 记忆化搜索部分：搜索空间大小为 $O(m\times \textit{iv} \times \textit{ev} \times 3^n)$，即为递归和记忆化所需的空间。

#### 方法二：基于轮廓线的动态规划

方法一中我们按行进行枚举，每一次需要枚举 $3^n$ 种状态进行转移。假如可以按位置进行枚举，只需考虑 $3$ 种状态。

如下图所示，假设 $n=5$, 我们目前枚举到了位置 $(x, y)$，其中 $0 \le x \lt m, 0 \le y \le n$，令 $\textit{pos} = x \times n + y$。我们约定相邻元素之间的分数由下侧和右侧的元素负责计算，那么 $\textit{pos}$ 需要计算其左侧 $\textit{pos} - 1$ 和上侧 $\textit{pos} - 5$ 处的相邻分数。接着继续遍历 $pos + 1$，需要计算它与 $\textit{pos}$ 和 $\textit{pos} - 4$ 之间的相邻分数，因此我们需要保留完整的一层状态（即完整的一个轮廓线，处于不同列的 $n$ 个元素），才可以保证后续的状态可以推算出具体代价。

![pic1](https://assets.leetcode-cn.com/solution-static/1659/1659.png)


与方法一类似的，我们定义 $d(\textit{pos}, \textit{mask}, \textit{iv}, \textit{ev})$ 为枚举到第 $\textit{pos}$ 个位置，轮廓线状态为 $\textit{mask}$，还有 $\textit{iv}$ 个内向的人和 $\textit{ev}$ 个外向的人未放置时的最大分数。其中，位置 $\textit{pos}$ 编号从 $0$ 开始，到 $n \times m - 1$ 结束。$\textit{mask}$ 的最低位表示 $\textit{pos} - 1$ 的元素，最高位表示 $\textit{pos} - n$ 的元素，如果在 $\textit{pos}$ 位置上放置一个内向的人，轮廓线状态 $mask$ 将变为：$\textit{mask}~\%~3^{n - 1} \times 3 + 1$。

我们从 $d(0, 0, \textit{iv}, \textit{ev})$ 进行搜索，当 $\textit{pos} = n \times m$ 或者 $\textit{iv} = \textit{ev} = 0$ 时可以直接返回 $0$。转移过程中，还需要注意第 $0$ 行上方没有元素以及第 $0$ 列左侧没有元素的特殊情况，在本题中我们可以直接用 $0$ 表示没有元素。

**代码**

```C++ [sol2-C++]
class Solution {
private:
    static constexpr int T = 243, N = 5, M = 6;
    int n, m, tot;
    int p[N];
    int d[N * N][T][M + 1][M + 1];

    // 邻居间的分数
    static constexpr int score[3][3] = {
        {0, 0, 0},
        {0, -60, -10},
        {0, -10, 40}
    };

public:
    int getMaxGridHappiness(int m, int n, int introvertsCount, int extrovertsCount) {
        this->n = n;
        this->m = m;
        // 状态总数为 3^n
        this->tot = pow(3, n);
        p[0] = 1;
        for (int i = 1; i < n; i++) {
            p[i] = p[i - 1] * 3;
        }
        
        // 记忆化搜索数组，初始化为 -1，表示未赋值
        memset(d, -1, sizeof d);
        return dfs(0, 0, introvertsCount, extrovertsCount);
    }

    int dfs(int pos, int mask, int iv, int ev) {
        if (pos == n * m || (iv == 0 && ev == 0)) {
            return 0;
        }
        int& res = d[pos][mask][iv][ev];
        if (res != -1) {
            return res;
        }
        res = 0;
        int up = mask / p[n - 1], left = mask % 3;
        // 若处于第一列，则左侧没有元素，将 left 置为 0
        if (pos % n == 0) {
            left = 0;
        }
        for (int i = 0; i < 3; i++) {
            if ((i == 1 && iv == 0) || (i == 2 && ev == 0)) {
                continue;
            }
            int next_mask = mask % p[n - 1] * 3 + i;
            int score_sum = dfs(pos + 1, next_mask, iv - (i == 1), ev - (i == 2))
                            + score[up][i]
                            + score[left][i];
            if (i == 1) {
                score_sum += 120;
            } else if (i == 2) {
                score_sum += 40;
            }
            res = max(res, score_sum);
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    static final int T = 243, N = 5, M = 6;
    int n, m, tot;
    int[] p;
    int[][][][] d;
    // 邻居间的分数
    static int[][] score = {
        {0, 0, 0},
        {0, -60, -10},
        {0, -10, 40}
    };

    public int getMaxGridHappiness(int m, int n, int introvertsCount, int extrovertsCount) {
        this.n = n;
        this.m = m;
        // 状态总数为 3^n
        this.tot = (int) Math.pow(3, n);
        this.p = new int[N];
        p[0] = 1;
        for (int i = 1; i < n; i++) {
            p[i] = p[i - 1] * 3;
        }
        this.d = new int[N * N][T][M + 1][M + 1];

        // 记忆化搜索数组，初始化为 -1，表示未赋值
        for (int i = 0; i < N * N; i++) {
            for (int j = 0; j < T; j++) {
                for (int k = 0; k <= M; k++) {
                    Arrays.fill(d[i][j][k], -1);
                }
            }
        }
        return dfs(0, 0, introvertsCount, extrovertsCount);
    }

    public int dfs(int pos, int mask, int iv, int ev) {
        if (pos == n * m || (iv == 0 && ev == 0)) {
            return 0;
        }
        int res = d[pos][mask][iv][ev];
        if (res != -1) {
            return res;
        }
        res = 0;
        int up = mask / p[n - 1], left = mask % 3;
        // 若处于第一列，则左侧没有元素，将 left 置为 0
        if (pos % n == 0) {
            left = 0;
        }
        for (int i = 0; i < 3; i++) {
            if ((i == 1 && iv == 0) || (i == 2 && ev == 0)) {
                continue;
            }
            int nextMask = mask % p[n - 1] * 3 + i;
            int scoreSum = dfs(pos + 1, nextMask, iv - (i == 1 ? 1 : 0), ev - (i == 2 ? 1 : 0))
                            + score[up][i]
                            + score[left][i];
            if (i == 1) {
                scoreSum += 120;
            } else if (i == 2) {
                scoreSum += 40;
            }
            res = Math.max(res, scoreSum);
        }
        d[pos][mask][iv][ev] = res;
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    const int T = 243, N = 5, M = 6;
    int n, m, tot;
    int[] p;
    int[][][][] d;
    // 邻居间的分数
    static int[][] score = {
        new int[]{0, 0, 0},
        new int[]{0, -60, -10},
        new int[]{0, -10, 40}
    };

    public int GetMaxGridHappiness(int m, int n, int introvertsCount, int extrovertsCount) {
        this.n = n;
        this.m = m;
        // 状态总数为 3^n
        this.tot = (int) Math.Pow(3, n);
        this.p = new int[N];
        p[0] = 1;
        for (int i = 1; i < n; i++) {
            p[i] = p[i - 1] * 3;
        }
        this.d = new int[N * N][][][];

        // 记忆化搜索数组，初始化为 -1，表示未赋值
        for (int i = 0; i < N * N; i++) {
            d[i] = new int[T][][];
            for (int j = 0; j < T; j++) {
                d[i][j] = new int[M + 1][];
                for (int k = 0; k <= M; k++) {
                    d[i][j][k] = new int[M + 1];
                    Array.Fill(d[i][j][k], -1);
                }
            }
        }
        return DFS(0, 0, introvertsCount, extrovertsCount);
    }

    public int DFS(int pos, int mask, int iv, int ev) {
        if (pos == n * m || (iv == 0 && ev == 0)) {
            return 0;
        }
        int res = d[pos][mask][iv][ev];
        if (res != -1) {
            return res;
        }
        res = 0;
        int up = mask / p[n - 1], left = mask % 3;
        // 若处于第一列，则左侧没有元素，将 left 置为 0
        if (pos % n == 0) {
            left = 0;
        }
        for (int i = 0; i < 3; i++) {
            if ((i == 1 && iv == 0) || (i == 2 && ev == 0)) {
                continue;
            }
            int nextMask = mask % p[n - 1] * 3 + i;
            int scoreSum = DFS(pos + 1, nextMask, iv - (i == 1 ? 1 : 0), ev - (i == 2 ? 1 : 0))
                            + score[up][i]
                            + score[left][i];
            if (i == 1) {
                scoreSum += 120;
            } else if (i == 2) {
                scoreSum += 40;
            }
            res = Math.Max(res, scoreSum);
        }
        d[pos][mask][iv][ev] = res;
        return res;
    }
}
```

```C [sol2-C]
#define T 243
#define N 5
#define M 6

int p[N];
int d[N * N][T][M + 1][M + 1];

// 邻居间的分数
const int score[3][3] = {
    {0, 0, 0},
    {0, -60, -10},
    {0, -10, 40}
};

int dfs(int pos, int mask, int iv, int ev, int m, int n) {
    if (pos == n * m || (iv == 0 && ev == 0)) {
        return 0;
    }
    int* res = &d[pos][mask][iv][ev];
    if (*res != -1) {
        return *res;
    }
    *res = 0;
    int up = mask / p[n - 1], left = mask % 3;
    // 若处于第一列，则左侧没有元素，将 left 置为 0
    if (pos % n == 0) {
        left = 0;
    }
    for (int i = 0; i < 3; i++) {
        if ((i == 1 && iv == 0) || (i == 2 && ev == 0)) {
            continue;
        }
        int next_mask = mask % p[n - 1] * 3 + i;
        int score_sum = dfs(pos + 1, next_mask, iv - (i == 1), ev - (i == 2), m, n)
                        + score[up][i]
                        + score[left][i];
        if (i == 1) {
            score_sum += 120;
        } else if (i == 2) {
            score_sum += 40;
        }
        *res = fmax(*res, score_sum);
    }
    return *res;
}

int getMaxGridHappiness(int m, int n, int introvertsCount, int extrovertsCount){
    p[0] = 1;
    for (int i = 1; i < n; i++) {
        p[i] = p[i - 1] * 3;
    }
    
    // 记忆化搜索数组，初始化为 -1，表示未赋值
    memset(d, -1, sizeof d);
    return dfs(0, 0, introvertsCount, extrovertsCount, m, n);
}
```

```JavaScript [sol2-JavaScript]
const T = 243;
const N = 5;
const M = 6;

const score = [
    [0, 0, 0],
    [0, -60, -10],
    [0, -10, 40]
];

function getMaxGridHappiness(m, n, introvertsCount, extrovertsCount) {
    let tot = Math.pow(3, n);
    let p = new Array(N).fill(0);
    p[0] = 1;
    for (let i = 1; i < n; i++) {
        p[i] = p[i - 1] * 3;
    }
    let d = new Array(N * N).fill(0).map(() => new Array(T).fill(0).map(() => new Array(M + 1).fill(0).map(() => new Array(M + 1).fill(-1))));

    for (let i = 0; i < N * N; i++) {
        for (let j = 0; j < T; j++) {
            for (let k = 0; k <= M; k++) {
                d[i][j][k].fill(-1);
            }
        }
    }

    return dfs(0, 0, introvertsCount, extrovertsCount);

    function dfs(pos, mask, iv, ev) {
        if (pos === n * m || (iv === 0 && ev === 0)) {
            return 0;
        }

        let res = d[pos][mask][iv][ev];
        if (res !== -1) {
            return res;
        }

        res = 0;
        let up = Math.floor(mask / p[n - 1]);
        let left = mask % 3;

        if (pos % n === 0) {
            left = 0;
        }

        for (let i = 0; i < 3; i++) {
            if ((i === 1 && iv === 0) || (i === 2 && ev === 0)) {
                continue;
            }

            let nextMask = (mask % p[n - 1]) * 3 + i;
            let scoreSum = dfs(pos + 1, nextMask, iv - (i === 1 ? 1 : 0), ev - (i === 2 ? 1 : 0)) +
                score[up][i] +
                score[left][i];

            if (i === 1) {
                scoreSum += 120;
            } else if (i === 2) {
                scoreSum += 40;
            }

            res = Math.max(res, scoreSum);
        }

        d[pos][mask][iv][ev] = res;
        return res;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def getMaxGridHappiness(self, m: int, n: int, introvertsCount: int, extrovertsCount: int) -> int:
        T, N, M = 243, 5, 6
        # 邻居间的分数
        score = [
            [0, 0, 0],
            [0, -60, -10],
            [0, -10, 40],
        ]

        tot = 3**n
        p = [1]
        for i in range(1, n):
            p.append(p[-1] * 3)
        
        @cache
        def dfs(pos: int, mask: int, iv: int, ev: int) -> int:
            if pos == n * m or (iv == 0 and ev == 0):
                return 0
            
            res = 0
            up, left = mask // p[n - 1], mask % 3
            if pos % n == 0:
                left = 0
            
            for i in range(3):
                if (i == 1 and iv == 0) or (i == 2 and ev == 0):
                    continue
                
                next_mask = mask % p[n - 1] * 3 + i
                score_sum = dfs(pos + 1, next_mask, iv - (i == 1), ev - (i == 2)) + score[up][i] + score[left][i]
                if i == 1:
                    score_sum += 120
                elif i == 2:
                    score_sum += 40
                res = max(res, score_sum)

            return res

        return dfs(0, 0, introvertsCount, extrovertsCount)
```

**复杂度分析**

- 时间复杂度：$O(m \times n \times \textit{iv} \times \textit{ev} \times 3^n)$，其中 $m$ 是行数，$n$ 是列数，$iv$ 是内向的人数，$ev$ 是外向的人数。预处理部分的时间复杂度为 $O(n)$，记忆化搜索的状态总数为 $O(m \times n \times \textit{iv} \times \textit{ev} \times 3^n)$，转移时需要枚举 $3$ 个状态，转移的时间复杂度为 $O(1)$，因此总体时间复杂度为 $O(m \times n \times \textit{iv} \times \textit{ev} \times 3^n)$。

- 空间复杂度：$O(m \times n \times \textit{iv} \times \textit{ev} \times 3^n)$。预处理部分的空间复杂度为 $O(n)$，记忆化搜索部分的空间复杂度为 $O(m \times n \times \textit{iv} \times \textit{ev} \times 3^n)$，因此总体空间复杂度为 $O(m \times n \times \textit{iv} \times \textit{ev} \times 3^n)$。
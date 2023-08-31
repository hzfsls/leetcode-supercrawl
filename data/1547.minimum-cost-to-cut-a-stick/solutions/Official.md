## [1547.切棍子的最小成本 中文官方题解](https://leetcode.cn/problems/minimum-cost-to-cut-a-stick/solutions/100000/qie-gun-zi-de-zui-xiao-cheng-ben-by-leetcode-solut)

#### 前言

本题和 [312. 戳气球](https://leetcode-cn.com/problems/burst-balloons/) 较为相似，都是经典的区间动态规划题。

#### 方法一：动态规划

**思路与算法**

在我们任意一次切割时，待切割木棍的左端点要么是原始木棍的左端点 $0$，要么是之前某一次切割的位置；同理，待切割木棍的右端点要么是原始木棍的右端点 $n$，要么是之前某一次切割的位置。

因此，如果我们将切割位置数组 $\textit{cuts}$ 进行排序，并在左侧添加 $0$，右侧添加 $n$，那么待切割的木棍就对应着数组中一段连续的区间。这样一来，我们就可以用动态规划来解决本题。

我们用数组 $\textit{cuts}[1..m]$ 表示题目中给定的数组 $\textit{cuts}$ 按照升序排序后的结果，其中 $m$ 是数组 $\textit{cuts}$ 的长度，并令 $cuts[0] = 0$，$cuts[m+1] = n$。同时，我们用 $f[i][j]$ 表示在当前待切割的木棍的左端点为 $\textit{cuts}[i-1]$，右端点为 $\textit{cuts}[j+1]$ 时，将木棍**全部切开**的最小总成本。

> 这里**全部切开的意思是**，木棍中有 $j-i+1$ 个切割位置 $\textit{cuts}[i], \cdots, \textit{cuts}[j]$，我们需要将木棍根据这些位置，切割成 $j-i+2$ 段。

为了得到最小总成本，我们可以枚举第一刀的位置。如果第一刀的位置为 $\textit{cuts}[k]$，其中 $k \in [i, j]$，那么我们会将待切割的木棍分成两部分，左侧部分的木棍为 $\textit{cuts}[i-1..k]$，对应的可以继续切割的位置为 $\textit{cuts}[i..k-1]$；右侧部分的木棍为 $\textit{cuts}[k..j+1]$，对应的可以继续切割的位置为 $\textit{cuts}[k+1..j]$。由于左右两侧均为规模较小的子问题，因此我们可以得到状态转移方程：

$$
f[i][j] = \min_{k \in [i,j]} \{ f[i][k-1] + f[k+1][j] \} + (\textit{cuts}[j+1] - \textit{cuts}[i-1])
$$

即我们无论在哪里切第一刀，这一刀的成本都是木棍的长度 $\textit{cuts}[j+1] - \textit{cuts}[i-1]$。

状态转移方程的边界条件为：

$$
f[i][j] = 0, ~其中~ i > j
$$

也就是说，如果没有可以切割的位置，那么它要么是一根无法再切割的木棍（此时 $i=j+1$），要么根本就不是一根木棍（此时 $i>j+1$）。无论是哪一种情况，对应的最小总成本都是 $0$。

最后的答案即为 $f[1][m]$。

**细节**

在区间动态规划中，我们要注意状态计算的顺序，即在计算 $f[i][j]$ 时，所有满足 $k \in [i, j]$ 的 $f[i][k]$ 和 $f[k][j]$ 都需要已经被计算过。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minCost(int n, vector<int>& cuts) {
        int m = cuts.size();
        sort(cuts.begin(), cuts.end());
        cuts.insert(cuts.begin(), 0);
        cuts.push_back(n);
        vector<vector<int>> f(m + 2, vector<int>(m + 2));
        for (int i = m; i >= 1; --i) {
            for (int j = i; j <= m; ++j) {
                f[i][j] = (i == j ? 0 : INT_MAX);
                for (int k = i; k <= j; ++k) {
                    f[i][j] = min(f[i][j], f[i][k - 1] + f[k + 1][j]);
                }
                f[i][j] += cuts[j + 1] - cuts[i - 1];
            }
        }
        return f[1][m];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minCost(int n, int[] cuts) {
        int m = cuts.length;
        Arrays.sort(cuts);
        int[] newCuts = new int[m + 2];
        newCuts[0] = 0;
        for (int i = 1; i <= m; ++i) {
            newCuts[i] = cuts[i - 1];
        }
        newCuts[m + 1] = n;
        int[][] f = new int[m + 2][m + 2];
        for (int i = m; i >= 1; --i) {
            for (int j = i; j <= m; ++j) {
                f[i][j] = i == j ? 0 : Integer.MAX_VALUE;
                for (int k = i; k <= j; ++k) {
                    f[i][j] = Math.min(f[i][j], f[i][k - 1] + f[k + 1][j]);
                }
                f[i][j] += newCuts[j + 1] - newCuts[i - 1];
            }
        }
        return f[1][m];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minCost(self, n: int, cuts: List[int]) -> int:
        m = len(cuts)
        cuts = [0] + sorted(cuts) + [n]
        f = [[0] * (m + 2) for _ in range(m + 2)]

        for i in range(m, 0, -1):
            for j in range(i, m + 1):
                f[i][j] = 0 if i == j else \
                    min(f[i][k - 1] + f[k + 1][j] for k in range(i, j + 1))
                f[i][j] += cuts[j + 1] - cuts[i - 1]
        
        return f[1][m]
```

```C [sol1-C]
int comp(const void* a, const void* b) {
    return *(int*)a - *(int*)b;
}

int minCost(int n, int* cuts, int cutsSize) {
    qsort(cuts, cutsSize, sizeof(int), comp);
    int* tmp = malloc(sizeof(int) * (cutsSize + 2));
    for (int i = 0; i < cutsSize; i++) {
        tmp[i + 1] = cuts[i];
    }
    tmp[0] = 0, tmp[cutsSize + 1] = n;
    int f[cutsSize + 2][cutsSize + 2];
    memset(f, 0, sizeof(f));
    for (int i = cutsSize; i >= 1; --i) {
        for (int j = i; j <= cutsSize; ++j) {
            f[i][j] = (i == j ? 0 : INT_MAX);
            for (int k = i; k <= j; ++k) {
                f[i][j] = fmin(f[i][j], f[i][k - 1] + f[k + 1][j]);
            }
            f[i][j] += tmp[j + 1] - tmp[i - 1];
        }
    }
    free(tmp);
    return f[1][cutsSize];
}
```

**复杂度分析**

- 时间复杂度：$O(m^3)$，其中 $m$ 是数组 $\textit{cuts}$ 的长度。状态的数量为 $O(m^2)$，转移的时间复杂度为 $O(m)$，相乘即可得到总时间复杂度。此外，将数组 $\textit{cuts}$ 进行排序的时间复杂度以及插入 $0$ 和 $n$ 的时间复杂度在渐进意义下小于 $O(m^3)$，因此可以忽略不计。

- 空间复杂度：$O(m^2)$，即为存储所有状态需要的空间。
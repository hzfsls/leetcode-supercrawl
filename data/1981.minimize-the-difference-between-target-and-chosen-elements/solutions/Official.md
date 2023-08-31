## [1981.最小化目标值与所选元素的差 中文官方题解](https://leetcode.cn/problems/minimize-the-difference-between-target-and-chosen-elements/solutions/100000/zui-xiao-hua-mu-biao-zhi-yu-suo-xuan-yua-mlym)

#### 方法一：背包型动态规划

**思路与算法**

我们用 $f[i][j]$ 表示在矩阵 $\textit{mat}$ 的第 $0, 1, \cdots, i$ 行分别选择一个整数，是否存在一种和为 $j$ 的方案。在进行状态转移时，我们枚举第 $i$ 行的每一个数 $x$，那么除去第 $i$ 行的和即为 $j-x$，因此有状态转移方程：

$$
f[i][j] \leftarrow f[i-1][j-x]
$$

这里的 $\leftarrow$ 表示转移方向。由于 $f[i][j]$ 表示的是「存在性」，因此如果 $f[i-1][j-x]$ 的值为 $\text{true}$，那么将 $f[i][j]$ 更新为 $\text{true}$，否则 $f[i][j]$ 保持不变。换句话说，也就是：

$$
f[i][j] = f[i][j] \vee f[i-1][j-x]
$$

这里的 $\vee$ 表示逻辑或运算。

在动态规划完成后，我们遍历所有的 $f[m-1][..]$，如果其中的某一项 $f[m-1][j]$ 的值为 $\textit{true}$，那么说明存在一种和为 $j$ 的方案，我们用 $|j - \textit{target}|$ 更新最终的答案即可。

**细节**

这里的细节较多，希望读者认真阅读和思考。

首先我们要确定在动态规划时 $j$ 的枚举范围。在对第 $i$ 行进行动态规划时，我们可以使用一个变量 $\textit{maxsum}$ 存储第 $0, 1, \cdots, i-1$ 行的每一行的最大值之和。这样一来，对于第 $i$ 行的数 $x$，$j$ 的枚举范围就是 $[x, \textit{maxsum} + x]$。

在状态转移方程中，我们发现 $f[i][j]$ 只会从 $f[i-1][..]$ 转移而来，因此我们可以使用两个一维数组代替该二维数组进行动态规划。需要注意的是，在对第 $i$ 行进行动态规划时，表示第 $i-1$ 行的数组至少需要长度 $\textit{maxsum} + 1$，而表示第 $i$ 行的数组在此基础上需要额外的「第 $i$ 行的最大值」的长度，这样才能使得到第 $i-1$ 行为止以及到第 $i$ 行为止的最大值之和都不超过数组的边界。

当然，我们也可以直接将数组的长度固定为 $4900$。题目中 $m$ 的最大值和数组元素的最大值均为 $70$，因此最大值之和不会超过 $4900$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimizeTheDifference(vector<vector<int>>& mat, int target) {
        int m = mat.size(), n = mat[0].size();
        int maxsum = 0;
        // 什么都不选时和为 0
        vector<int> f = {1};
        for (int i = 0; i < m; ++i) {
            int best = *max_element(mat[i].begin(), mat[i].end());
            vector<int> g(maxsum + best + 1);
            for (int x: mat[i]) {
                for (int j = x; j <= maxsum + x; ++j) {
                    g[j] |= f[j - x];
                }
            }
            f = move(g);
            maxsum += best;
        }
        int ans = INT_MAX;
        for (int i = 0; i <= maxsum; ++i) {
            if (f[i] && abs(i - target) < ans) {
                ans = abs(i - target);
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minimizeTheDifference(self, mat: List[List[int]], target: int) -> int:
        m, n = len(mat), len(mat[0])
        # 什么都不选时和为 0
        f = {0}
        for i in range(m):
            best = max(mat[i])
            g = set()
            for x in mat[i]:
                for j in f:
                    g.add(j + x)
            f = g
        
        ans = float("inf")
        for x in f:
            ans = min(ans, abs(x - target))
        return ans
```

**复杂度分析**

- 时间复杂度：$O(m^2nC)$，其中 $C$ 是数组 $\textit{mat}$ 中的元素最大值。这个时间复杂度很容易超出时间限制（特别是对于一些解释性语言）。因此可以考虑将动态规划的数组换成哈希表，具体可以参考上面的 $\texttt{Python}$ 代码。

- 空间复杂度：$O(mC)$，即为动态规划中数组（或哈希表）需要的空间。

#### 方法二：使用 $\textit{target}$ 进行优化

**思路与算法**

方法一没有很好地利用题目中 $\textit{target}$ 范围的限制。$\textit{target}$ 的最大值为 $800$，而全部的 $m$ 行的最大值之和最大为 $4900$，远远大于前者。这样就造成了许多不必要的状态转移。

由于我们的目标是最小化「和」与 $\textit{target}$ 的差值的「绝对值」，因此当「和」已经大于等于 $\textit{target}$ 时，我们再增大「和」显然是没有必要的。

因此，在状态转移的过程中，我们只需要使用长度为 $\textit{target}$ 的数组存储所有小于 $\textit{target}$ 的和，此外再使用一个变量 $\textit{large}$ 存储**最小的**大于等于 $\textit{target}$ 的和。这样一来，我们就可以更快速地进行状态转移。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int minimizeTheDifference(vector<vector<int>>& mat, int target) {
        int m = mat.size(), n = mat[0].size();
        vector<int> f(target, 0);
        // 什么都不选时和为 0
        f[0] = true;
        // 最小的大于等于 target 的和
        int large = INT_MAX;
        for (int i = 0; i < m; ++i) {
            vector<int> g(target);
            int next_large = INT_MAX;
            for (int x: mat[i]) {
                for (int j = 0; j < target; ++j) {
                    if (f[j]) {
                        if (j + x >= target) {
                            next_large = min(next_large, j + x);
                        }
                        else {
                            g[j + x] = true;
                        }
                    }
                }
                if (large != INT_MAX) {
                    next_large = min(next_large, large + x);
                }
            }
            f = move(g);
            large = next_large;
        }

        int ans = abs(large - target);
        for (int i = target - 1; i >= 0; --i) {
            if (f[i]) {
                ans = min(ans, target - i);
                break;
            }
        }
        return ans;
    }
};
```

```Python [sol2-Python3]
class Solution:
    def minimizeTheDifference(self, mat: List[List[int]], target: int) -> int:
        m, n = len(mat), len(mat[0])
        # 什么都不选时和为 0
        f = {0}
        # 最小的大于等于 target 的和
        large = float("inf")
        for i in range(m):
            g = set()
            next_large = float("inf")
            for x in mat[i]:
                for j in f:
                    if j + x >= target:
                        next_large = min(next_large, j + x)
                    else:
                        g.add(j + x)
                next_large = min(next_large, large + x)
            f = g
            large = next_large
        
        ans = abs(large - target)
        for x in f:
            ans = min(ans, abs(x - target))
        return ans
```

**复杂度分析**

- 时间复杂度：$O(mn \cdot \textit{target})$。

- 空间复杂度：$O(\textit{target})$，即为动态规划中数组（或哈希表）需要使用的空间。
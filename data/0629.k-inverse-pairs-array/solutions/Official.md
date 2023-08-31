## [629.K 个逆序对数组 中文官方题解](https://leetcode.cn/problems/k-inverse-pairs-array/solutions/100000/kge-ni-xu-dui-shu-zu-by-leetcode-solutio-0hkr)
#### 方法一：动态规划

**思路与算法**

我们可以用动态规划的方法来解决本题。

设 $f[i][j]$ 表示我们使用数字 $1, 2, \cdots, i$ 的排列构成长度为 $i$ 的数组，并且恰好包含 $j$ 个逆序对的方案数。在进行状态转移时，我们可以考虑第 $i$ 个元素选取了 $1, 2, \cdots, i$ 中的哪个数字。

假设我们选取了数字 $k$，那么数组的前 $i-1$ 个元素由 $1, \cdots, k-1$ 以及 $k+1, \cdots, i$ 的某个排列构成。数组中的逆序对的个数可以看成如下的两部分之和：

- 数字 $k$ 与前 $i-1$ 个元素产生的逆序对的个数；

- 前 $i-1$ 个元素「内部」产生的逆序对个数。

对于第一部分而言，我们可以求出：数字 $k$ 会贡献 $i-k$ 个逆序对，即 $k+1, \cdots, i$ 与 $k$ 分别产生一个逆序对。

对于第二部分而言，我们希望它能够有 $j - (i-k)$ 个逆序对，这样才能一共有 $j$ 个逆序对。由于我们关心的是前 $i-1$ 个元素「内部」产生的逆序对个数，而逆序对只和元素的「相对大小」有关，因此我们可以：

- $1, \cdots, k-1$ 这些元素保持不变；

- $k+1, \cdots, i$ 这些元素均减少 $1$，变成 $k, \cdots, i-1$。

使得前 $i-1$ 个元素中，任意两个元素的相对大小都不发生变化。此时，我们的目标变成了「对于 $1, 2, \cdots, i-1$，希望它能够有 $j-(i-k)$ 个逆序对」，这就是动态规划中的子任务 $f[i-1][j-(i-k)]$。

因此，我们就可以通过枚举 $k$ 得到状态转移方程：

$$
f[i][j] = \sum_{k=1}^i f[i-1][j-(i-k)] = \sum_{k=0}^{i-1} f[i-1][j-k]
$$

边界条件为：

- $f[0][0] = 1$，即不用任何数字可以构成一个空数组，它包含 $0$ 个逆序对；

- $f[i][j < 0] = 0$，由于逆序对的数量一定是非负整数，因此所有 $j < 0$ 的状态的值都为 $0$。我们不需要显式地存储这些状态，只需要在进行状态转移遇到这样的项时，注意特殊判断即可。

最终的答案即为 $f[n][k]$。

**优化**

上述动态规划的状态数量为 $O(nk)$，而求出每一个 $f[i][j]$ 需要 $O(n)$ 的时间复杂度，因此总时间复杂度为 $O(n^2k)$，会超出时间限制，我们必须要进行优化。

我们考虑 $f[i][j-1]$ 和 $f[i][j]$ 的状态转移方程：

$$
\left\{
\begin{aligned}
    & f[i][j-1] && = && \sum_{k=0}^{i-1} f[i-1][j-1-k] \\
    & f[i][j] && = && \sum_{k=0}^{i-1} f[i-1][j-k]
\end{aligned}
\right.
$$

可以得到从 $f[i][j-1]$ 到 $f[i][j]$ 的递推式：

$$
f[i][j] = f[i][j-1] - f[i-1][j-i] + f[i-1][j]
$$

这样我们就可以在 $O(1)$ 的时间计算出每个 $f[i][j]$，总时间复杂度降低为 $O(nk)$。

此外，由于 $f[i][j]$ 只会从第 $f[i-1][..]$ 和 $f[i][..]$ 转移而来，因此我们可以对动态规划使用的空间进行优化，即使用两个一维数组交替地进行状态转移，空间复杂度从 $O(nk)$ 降低为 $O(k)$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int mod = 1000000007;

public:
    int kInversePairs(int n, int k) {
        vector<vector<int>> f(2, vector<int>(k + 1));
        f[0][0] = 1;
        for (int i = 1; i <= n; ++i) {
            for (int j = 0; j <= k; ++j) {
                int cur = i & 1, prev = cur ^ 1;
                f[cur][j] = (j - 1 >= 0 ? f[cur][j - 1] : 0) - (j - i >= 0 ? f[prev][j - i] : 0) + f[prev][j];
                if (f[cur][j] >= mod) {
                    f[cur][j] -= mod;
                }
                else if (f[cur][j] < 0) {
                    f[cur][j] += mod;
                }
            }
        }
        return f[n & 1][k];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int kInversePairs(int n, int k) {
        final int MOD = 1000000007;
        int[][] f = new int[2][k + 1];
        f[0][0] = 1;
        for (int i = 1; i <= n; ++i) {
            for (int j = 0; j <= k; ++j) {
                int cur = i & 1, prev = cur ^ 1;
                f[cur][j] = (j - 1 >= 0 ? f[cur][j - 1] : 0) - (j - i >= 0 ? f[prev][j - i] : 0) + f[prev][j];
                if (f[cur][j] >= MOD) {
                    f[cur][j] -= MOD;
                } else if (f[cur][j] < 0) {
                    f[cur][j] += MOD;
                }
            }
        }
        return f[n & 1][k];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int KInversePairs(int n, int k) {
        const int MOD = 1000000007;
        int[,] f = new int[2, k + 1];
        f[0, 0] = 1;
        for (int i = 1; i <= n; ++i) {
            for (int j = 0; j <= k; ++j) {
                int cur = i & 1, prev = cur ^ 1;
                f[cur, j] = (j - 1 >= 0 ? f[cur, j - 1] : 0) - (j - i >= 0 ? f[prev, j - i] : 0) + f[prev, j];
                if (f[cur, j] >= MOD) {
                    f[cur, j] -= MOD;
                } else if (f[cur, j] < 0) {
                    f[cur, j] += MOD;
                }
            }
        }
        return f[n & 1, k];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def kInversePairs(self, n: int, k: int) -> int:
        mod = 10**9 + 7
        
        f = [1] + [0] * k
        for i in range(1, n + 1):
            g = [0] * (k + 1)
            for j in range(k + 1):
                g[j] = (g[j - 1] if j - 1 >= 0 else 0) - (f[j - i] if j - i >= 0 else 0) + f[j]
                g[j] %= mod
            f = g
        
        return f[k]
```

```go [sol1-Golang]
func kInversePairs(n, k int) int {
    const mod int = 1e9 + 7
    f := [2][]int{make([]int, k+1), make([]int, k+1)}
    f[0][0] = 1
    for i := 1; i <= n; i++ {
        for j := 0; j <= k; j++ {
            cur := i & 1
            prev := cur ^ 1
            f[cur][j] = 0
            if j > 0 {
                f[cur][j] = f[cur][j-1]
            }
            if j >= i {
                f[cur][j] -= f[prev][j-i]
            }
            f[cur][j] += f[prev][j]
            if f[cur][j] >= mod {
                f[cur][j] -= mod
            } else if f[cur][j] < 0 {
                f[cur][j] += mod
            }
        }
    }
    return f[n&1][k]
}
```

```JavaScript [sol1-JavaScript]
var kInversePairs = function(n, k) {
    const MOD = 1000000007;
    const f = new Array(2).fill(0).map(() => new Array(k + 1).fill(0));
    f[0][0] = 1;
    for (let i = 1; i <= n; ++i) {
        for (let j = 0; j <= k; ++j) {
            const cur = i & 1, prev = cur ^ 1;
            f[cur][j] = (j - 1 >= 0 ? f[cur][j - 1] : 0) - (j - i >= 0 ? f[prev][j - i] : 0) + f[prev][j];
            if (f[cur][j] >= MOD) {
                f[cur][j] -= MOD;
            } else if (f[cur][j] < 0) {
                f[cur][j] += MOD;
            }
        }
    }
    return f[n & 1][k];
};
```

**复杂度分析**

- 时间复杂度：$O(nk)$。

- 空间复杂度：$O(k)$。
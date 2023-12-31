## [1866.恰有 K 根木棍可以看到的排列数目 中文官方题解](https://leetcode.cn/problems/number-of-ways-to-rearrange-sticks-with-k-sticks-visible/solutions/100000/qia-you-k-gen-mu-gun-ke-yi-kan-dao-de-pa-0c3g)

#### 方法一：动态规划

**思路与算法**

我们用 $f(i, j)$ 表示长度为 $1, 2, \cdots, i$ 的木棍且可以可以看到其中的 $j$ 根木棍的方案数。

在进行状态转移的时候，我们可以考虑最后一根木棍是否可以被看到：

- 如果可以被看到，那么最后一根木棍的长度一定为 $i$，因此前 $i-1$ 根木棍的长度恰好为 $1, 2, \cdots i-1$ 的一个排列，并且可以看到其中的 $j-1$ 根木棍。这样就有状态转移方程：

    $$
    f(i, j) = f(i - 1, j - 1)
    $$

- 如果不可以被看到，那么最后一根木棍的长度为 $[1, i-1]$ 中的某个值。假设这个值为 $x$，那么前 $i-1$ 根木棍的长度为 $1, \cdots, x-1, x+1, \cdots, i$ 的一个排列，并且可以看到其中的 $j$ 根木棍。

    由于一根木棍能否被看到只与它和它左侧木棍的「相对高度关系」有关，而与「绝对高度关系」无关。因此如果我们将长度：

    $$
    1, \cdots, x-1, x+1, \cdots, i
    $$

    按照顺序重新分配为：

    $$
    1, 2, \cdots, i-1
    $$

    那么任意两根木棍的「相对高度关系」都保持不变，即我们仍然可以看到 $j$ 根木棍，满足要求的排列数为 $f(i-1, j)$，与 $x$ 的取值无关。这样就有状态转移方程：

    $$
    f(i, j) = (i-1) \cdot f(i-1, j)
    $$

将上面的两种情况求和，即可得到最终的状态转移方程：

$$
f(i, j) = f(i - 1, j - 1) + (i-1) \cdot f(i-1, j)
$$

最终的答案即为 $f(n, k)$。

**细节**

当 $i=0$ 时，我们没有使用任何木棍，所以看不到任何木棍，$f(i, 0)$ 的值为 $1$，除此之外的 $f(i, j)$ 的值为 $0$。

注意到状态转移方程中，$f(i, ..)$ 只会从 $f(i-1, ..)$ 转移而来，因此我们可以使用两个长度为 $k+1$ 的一维数组代替二维数组，交替地进行状态转移。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int mod = 1000000007;
    
public:
    int rearrangeSticks(int n, int k) {
        vector<int> f(k + 1);
        f[0] = 1;
        for (int i = 1; i <= n; ++i) {
            vector<int> g(k + 1);
            for (int j = 1; j <= k; ++j) {
                g[j] = ((long long)f[j] * (i - 1) % mod + f[j - 1]) % mod;
            }
            f = move(g);
        }
        return f[k];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def rearrangeSticks(self, n: int, k: int) -> int:
        mod = 10**9 + 7

        f = [1] + [0] * k
        for i in range(1, n + 1):
            g = [0] * (k + 1)
            for j in range(1, k + 1):
                g[j] = (f[j] * (i - 1) + f[j - 1]) % mod
            f = g
        
        return f[k]
```

**复杂度分析**

- 时间复杂度：$O(nk)$。

- 空间复杂度：$O(k)$，即为两个一维数组需要使用的空间。
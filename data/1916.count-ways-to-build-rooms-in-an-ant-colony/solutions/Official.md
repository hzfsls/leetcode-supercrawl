#### 前言

读者需要掌握如下进阶知识点才能解决本题：

- 排列数计算。假设有 $a_0$ 个物品 $0$，$a_1$ 个物品 $1$，...，$a_{n-1}$ 个物品 $n-1$，我们需要将它们排成一排，那么方案数为

    $$
    \frac{(a_0 + a_1 + \cdots + a_{n-1})!}{a_0! \cdot a_1! \cdot \cdots \cdot a_{n-1}!}
    $$

- 乘法逆元。如果需要计算 $\dfrac{b}{a}$ 对 $m$ 取模的值，$b$ 和 $a$ 均为表达式（例如上面排列数的分子与分母）并且它们实际的值非常大，无法直接进行计算，那么我们可以求出 $a$ 在模 $m$ 意义下的乘法逆元 $a^{-1}$，此时有

    $$
    \frac{b}{a} \equiv b \cdot a^{-1} \quad (\bmod ~m)
    $$

    这样将除法运算转化为乘法运算，就可以在计算的过程中进行取模了。
    乘法逆元的具体计算方法可以参考题解的最后一节「进阶知识点：乘法逆元」。

#### 方法一：动态规划

**提示 $1$**

由于除了 $0$ 号房间以外的每一个房间 $i$ 都有唯一的 $\textit{prevRoom}[i]$，而 $0$ 号房间没有 $\textit{prevRoom}[i]$，并且我们可以从 $0$ 号房间到达每个房间，即任意两个房间都是可以相互到达的，因此：

> 如果我们把所有的 $n$ 间房间看成 $n$ 个节点，任意的第 $i(i>0)$ 号房间与 $\textit{prevRoom}[i]$ 号房间之间连接一条有向边，从 $\textit{prevRoom}[i]$ 指向 $i$，那么它们就组成了一棵以 $0$ 号房间为根节点的树，并且树上的每条有向边总是从父节点指向子节点。

**提示 $2$**

根据题目要求，对于任意的 $i > 0$，我们必须先构筑 $\textit{prevRoom}[i]$，再构筑 $i$，而我们根据提示 $1$ 构造的树中恰好有一条从 $\textit{prevRoom}[i]$ 指向 $i$ 的边，因此：

> 题目中的要求与拓扑排序的要求是等价的。

也就是说，构筑所有房间的不同顺序的数目，等于**我们构造的树的不同拓扑排序的方案数**。

**思路与算法**

我们可以使用动态规划的方法求出方案数。

设 $f[i]$ 表示以节点 $i$ 为根的子树的拓扑排序方案数，那么：

- 任意一种拓扑排序中的第一个节点一定是节点 $i$；

- 假设节点 $i$ 有子节点 $\textit{ch}_{i, 0}, \textit{ch}_{i, 1}, \cdots, \textit{ch}_{i, k}$，那么以 $\textit{ch}_{i, 0}, \textit{ch}_{i, 1}, \cdots, \textit{ch}_{i, k}$ 为根的这 $k+1$ 棵子树，它们均有若干种拓扑排序的方案。如果我们希望把这些子树的拓扑排序方案「简单地」合并到一起，可以使用乘法原理，即方案数为：

    $$
    f[\textit{ch}_{i, 0}] \times f[\textit{ch}_{i, 1}] \times \cdots \times f[\textit{ch}_{i, k}]
    $$

    乘法原理会忽略**子树之间**拓扑排序的顺序，所以我们还需要考虑这一层关系。记 $\textit{cnt}[i]$ 表示以节点 $i$ 为根的子树中节点的个数，那么除了拓扑排序中第一个节点为 $i$ 以外，还剩余 $\textit{cnt}[i] - 1$ 个位置。我们需要在 $\textit{cnt}[i]-1$ 个位置中，分配 $\textit{cnt}[\textit{ch}_{i, 0}]$ 个给以 $\textit{ch}_{i, 0}$ 为根的子树，放置该子树的一种拓扑排序；分配 $\textit{cnt}[\textit{ch}_{i, 1}]$ 个给以 $\textit{ch}_{i, 1}$ 为根的子树，放置该子树的一种拓扑排序。以此类推，分配的方案数乘以上述乘法原理得到的方案数，即为 $f[i]$。根据「前言」部分，我们知道分配的方案数为：

    $$
    \frac{(\textit{cnt}[i]-1)!}{\textit{cnt}[\textit{ch}_{i, 0}]! \times \textit{cnt}[\textit{ch}_{i, 1}]! \times \cdots \times \textit{cnt}[\textit{ch}_{i, k}]!}
    $$

因此，我们就可以得到状态转移方程：

$$
f[i] = \left( \prod_{\textit{ch}} f[\textit{ch}] \right) \times \frac{(\textit{cnt}[i] - 1)!}{\prod_{\textit{ch}} \textit{cnt}[\textit{ch}]!}
$$

**细节**

当节点 $i$ 为叶节点时，它没有子节点，因此对应着 $1$ 种拓扑排序的方案，即 $f[i] = 1$。

状态转移方程中存在除法，因此我们需要使用「前言」部分的乘法逆元将其转换为除法。

观察状态转移方程，它包含一些阶乘以及阶乘的乘法逆元，因此我们可以将它们全部预处理出来，这样就可以均摊 $O(1)$ 的时间在一对「父-子」节点之间进行状态转移。

具体的实现可以参考下面的代码。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int mod = 1000000007;
    using LL = long long;

public:
    int waysToBuildRooms(vector<int>& prevRoom) {
        
        // 快速幂计算 x^y
        auto quickmul = [&](int x, int y) {
            int ret = 1, cur = x;
            while (y) {
                if (y & 1) {
                    ret = (LL)ret * cur % mod;
                }
                cur = (LL)cur * cur % mod;
                y >>= 1;
            }
            return ret;
        };
        
        int n = prevRoom.size();
        // fac[i] 表示 i!
        // inv[i] 表示 i! 的乘法逆元
        vector<int> fac(n), inv(n);
        fac[0] = inv[0] = 1;
        for (int i = 1; i < n; ++i) {
            fac[i] = (LL)fac[i - 1] * i % mod;
            // 使用费马小定理计算乘法逆元
            inv[i] = quickmul(fac[i], mod - 2);
        }
        
        // 构造树
        vector<vector<int>> edges(n);
        for (int i = 1; i < n; ++i) {
            edges[prevRoom[i]].push_back(i);
        }
        
        vector<int> f(n), cnt(n);
        function<void(int)> dfs = [&](int u) {
            f[u] = 1;
            for (int v: edges[u]) {
                dfs(v);
                // 乘以左侧的 f[ch] 以及右侧分母中 cnt[ch] 的乘法逆元
                f[u] = (LL)f[u] * f[v] % mod * inv[cnt[v]] % mod;
                cnt[u] += cnt[v];
            }
            // 乘以右侧分子中的 (cnt[i] - 1)!
            f[u] = (LL)f[u] * fac[cnt[u]] % mod;
            ++cnt[u];
        };
        
        dfs(0);
        return f[0];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def waysToBuildRooms(self, prevRoom: List[int]) -> int:
        mod = 10**9 + 7
        
        n = len(prevRoom)
        # fac[i] 表示 i!
        # inv[i] 表示 i! 的乘法逆元
        fac, inv = [0] * n, [0] * n
        fac[0] = inv[0] = 1
        for i in range(1, n):
            fac[i] = fac[i - 1] * i % mod
            # 使用费马小定理计算乘法逆元
            inv[i] = pow(fac[i], mod - 2, mod)
        
        # 构造树
        edges = defaultdict(list)
        for i in range(1, n):
            edges[prevRoom[i]].append(i)
        
        f, cnt = [0] * n, [0] * n
        
        def dfs(u: int) -> None:
            f[u] = 1
            for v in edges[u]:
                dfs(v)
                # 乘以左侧的 f[ch] 以及右侧分母中 cnt[ch] 的乘法逆元
                f[u] = f[u] * f[v] * inv[cnt[v]] % mod
                cnt[u] += cnt[v]
            # 乘以右侧分子中的 (cnt[i] - 1)!
            f[u] = f[u] * fac[cnt[u]] % mod
            cnt[u] += 1
        
        dfs(0)
        return f[0]
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$。

    - 预处理阶乘以及阶乘的乘法逆元需要的时间为 $O(n \log n)$。这一步可以优化成 $O(n)$，感兴趣的读者可以查阅「线性逆元」的相关资料进行学习，这里不展开讨论。

    - 动态规划需要的时间为 $O(n)$，其本质就是对树进行了一遍深度优先搜索，按照后序遍历的顺序计算 $f$ 值。

- 空间复杂度：$O(n)$。我们需要 $O(n)$ 的空间存储阶乘、阶乘的乘法逆元、动态规划求出的方案数和以每个节点为根的子树包含的节点数。此外我们还需要 $O(n)$ 的栈空间进行深度优先搜索。

#### 进阶知识点：乘法逆元

设模数为 $m$（在本题中 $m=10^9+7$），对于一个整数 $a$，如果存在另一个整数 $a^{-1}~(0 < a^{-1} < m)$，满足

$$
a a^{-1} \equiv 1 ~ (\bmod ~ m)
$$

那么我们称 $a^{-1}$ 是 $a$ 的「乘法逆元」。

当 $a$ 是 $m$ 的倍数时，显然 $a^{-1}$ 不存在。而当 $a$ 不是 $m$ 的倍数时，根据上式可得

$$
aa^{-1} = km + 1, \quad k \in \mathbb{N}
$$

整理得

$$
a^{-1} \cdot a - k \cdot m = 1
$$

**若 $m$ 为质数**，根据「裴蜀定理」，$\text{gcd}(a, m) = 1$，因此必存在整数 $a^{-1}$ 和 $k$ 使得上式成立。

如果 $(a^{-1}_0, k_0)$ 是一组解，那么

$$
(a^{-1}_0 + cm, k_0 + ca), \quad c \in \mathbb{Z}
$$

都是上式的解。因此必然存在一组解中的 $a_0^{-1}$ 满足 $0 < a_0^{-1} < m$，即为我们所求的 $a^{-1}$。

那么如何求出 $a^{-1}$ 呢？**当 $m$ 为质数时**，一种简单的方法是使用「费马小定理」，即

$$
a^{m-1} \equiv 1 ~ (\bmod ~ m)
$$

那么有

$$
\left.
\begin{aligned}
& a^{m-1} a^{-1} \equiv a^{-1} \\
\Leftrightarrow ~ & a^{m-2} a a^{-1} \equiv a^{-1} \\
\Leftrightarrow ~ & a^{m-2} \equiv a^{-1}
\end{aligned}
\right. \quad (\bmod ~ m)
$$

因此，$a^{-1}$ 就等于 $a^{m-2}$ 对 $m$ 取模的结果。而计算 $a^{m-2}$ 的方法相对简单，我们可以使用「快速幂」，时间复杂度为 $O(\log m)$，具体可以参考「[50. Pow(x, n) 的官方题解](https://leetcode-cn.com/problems/powx-n/solution/powx-n-by-leetcode-solution/)」。

**当 $m$ 不为质数时**，我们可以使用「[扩展欧几里得算法](https://baike.baidu.com/item/%E6%89%A9%E5%B1%95%E6%AC%A7%E5%87%A0%E9%87%8C%E5%BE%97%E7%AE%97%E6%B3%95)」求出乘法逆元，但该知识点与本题无关，这里不再赘述。

乘法逆元可以使得我们在取模的意义下，化除法为乘法。例如当我们需要求出 $\dfrac{b}{a}$ 对 $m$ 取模的结果，那么可以使用乘法逆元

$$
\frac{b}{a} \equiv b \cdot a^{-1} ~ (\bmod ~ m)
$$

帮助我们进行求解。由于**乘法在取模的意义下满足分配律**，即

$$
(a \times b) \bmod m = \big((a \bmod m) \times (b \bmod m)\big) \bmod m
$$

而除法在取模的意义下并不满足分配律。因此当 $a$ 和 $b$ 的求解过程中本身就包含取模运算时，我们仍然可以得到正确的 $\dfrac{b}{a}$ 对 $m$ 取模的结果。
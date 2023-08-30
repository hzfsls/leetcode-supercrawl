#### 方法一：动态规划

**提示 $1$**

在任意一名玩家进行操作之后，**剩余的所有石子的价值总和不会发生变化**。

对于每一步操作，玩家可以把「最左侧」的 $x$ 枚石子进行「价值合并」，并获得与「价值」等价的分数。因此，**最左侧的石子的价值一定是 $\textit{stones}$ 的某一个前缀和**，即**玩家在每一轮获得的分数一定是初始数组 $\textit{stones}$ 的某一个前缀和。**

**提示 $2$**

根据提示 $1$，我们可以将题目中的游戏转化成如下等价的形式：

- 我们求出 $\textit{stones}$ 的前缀和数组 $\textit{pre}$，其中：

    $$
    \textit{pre}[i] = \sum_{j=0}^i \textit{stones}[j]
    $$

- $\text{Alice}$ 和 $\text{Bob}$ 依次在数组 $\textit{pre}$ 上进行操作，并且 $\text{Alice}$ 先手。在一次操作中，当前玩家可以选择一个下标 $u$，获得 $\textit{pre}[u]$ 的分数：

    - 如果当前玩家是 $\text{Alice}$ 并且是首次操作，那么 $u$ 不能为 $0$。对应到题目中的游戏规则，即为「选择的石子数量 $x$ 必须大于 $1$」；

    - 对于其余的情况，如果对手的上一次操作选择的下标是 $v$，那么必须有 $u > v$。对应到题目中的游戏规则，即为「对手上一次操作合并了若干枚石子，使得最左侧的石子的价值为 $\textit{pre}[v]$」，同时「当前玩家合并了从最左侧的石子开始，到原本在数组 $\textit{stones}$ 中下标为 $u$ 的石子为止的所有石子，使得最左侧的石子的价值为 $\textit{pre}[u]$」。

- 设数组 $\textit{stones}$ 和 $\textit{pre}$ 的长度为 $n$。如果当前玩家选择了下标 $n-1$，那么它就会合并剩余的所有石子，游戏结束。

**思路与算法**

我们可以使用基于博弈思想的动态规划解决提示 $2$ 中的游戏。

设 $f(i)$ 表示当 $\text{Alice}$ 可以选择的下标 $u$ 在 $[i, n)$ 范围内时，$\text{Alice}$ 与 $\text{Bob}$ 分数的最大差值。在进行状态转移时，我们可以考虑 $\text{Alice}$ 是否选择了 $i$ 作为下标 $u$；

- 如果 $\text{Alice}$ 没有选择 $i$ 作为下标 $u$，那么她需要在 $[i+1, n)$ 的范围内进行选择，因此有状态转移方程：

    $$
    f[i] = f[i+1]
    $$

- 如果 $\text{Alice}$ 选择了 $i$ 作为下标 $u$，那么她获得了 $\textit{pre}[i]$ 的分数，并且轮到 $\text{Bob}$ 在剩余的范围 $[i+1, n)$ 中进行选择。由于 $\text{Bob}$ 会采用最优策略，因此在 $[i+1, n)$ 的范围内，$\text{Bob}$ 与 $\text{Alice}$ 分数的最大差值就为 $f[i+1]$，因此有状态转移方程：

    $$
    f[i] = \textit{pre}[i] - f[i+1]
    $$

由于 $\text{Alice}$ 会采用最优策略，因此状态转移选择二者中的较大值：

$$
f[i] = \max ( f[i+1], \textit{pre}[i] - f[i+1] )
$$

我们从 $i=n-1$ 开始倒序地计算所有的状态，最终的答案即为 $f[1]$。

**细节**

当 $i=n-1$ 时，$f[i+1]$ 不是一个合法的状态，因此我们可以将此时的 $i$ 作为边界情况进行考虑，即：

$$
f[i] = \textit{pre}[i]
$$

然后从 $i=n-2$ 开始倒序计算所有的状态即可。

**思考**

为什么最终的答案是 $f[1]$ 而不是 $f[0]$？

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int stoneGameVIII(vector<int>& stones) {
        int n = stones.size();
        vector<int> pre;
        partial_sum(stones.begin(), stones.end(), back_inserter(pre));
        vector<int> f(n);
        f[n - 1] = pre[n - 1];
        for (int i = n - 2; i >= 1; --i) {
            f[i] = max(f[i + 1], pre[i] - f[i + 1]);
        }
        return f[1];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def stoneGameVIII(self, stones: List[int]) -> int:
        n = len(stones)
        pre = list(accumulate(stones))
        f = [0] * n
        f[n - 1] = pre[n - 1]
        for i in range(n - 2, 0, -1):
            f[i] = max(f[i + 1], pre[i] - f[i + 1])
        return f[1]

```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(n)$，即为数组 $\textit{pre}$ 和 $f$ 需要的空间。
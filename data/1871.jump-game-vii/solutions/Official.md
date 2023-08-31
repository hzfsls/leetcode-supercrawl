## [1871.跳跃游戏 VII 中文官方题解](https://leetcode.cn/problems/jump-game-vii/solutions/100000/tiao-yue-you-xi-vii-by-leetcode-solution-rsyv)
#### 方法一：动态规划 + 前缀和优化

**提示 $1$**

我们用 $f(i)$ 表示能否从位置 $0$ 按照给定的规则跳到位置 $i$。

如果 $s[i]$ 为 $1$，我们无法跳到位置 $i$，此时 $f(i) = \text{False}$。

如果 $s[i]$ 为 $0$，我们可以枚举位置 $j$，表示最后一步是从位置 $j$ 跳到位置 $i$ 的。位置 $j$ 需要满足 $j \in [i - \textit{maxJump}, i - \textit{minJump}]$ 并且 $j \geq 0$，只要存在一个 $j$ 满足 $f(j)=\text{True}$，那么 $f(i)$ 就为 $\text{True}$。因此我们可以写出状态转移方程：

$$
f(i) = \text{any}\big(f(j)\big), \quad 其中 ~ j \in [i - \textit{maxJump}, i - \textit{minJump}] ~并且~ j \geq 0
$$

如果字符串 $s$ 的长度为 $n$，我们按照上述状态转移方程进行动态规划后，最终的答案即为 $f(n-1)$。

然而该状态转移方程的转移时间为 $O(n)$，即动态规划的总时间复杂度为 $O(n^2)$，会超出时间限制，因此我们需要进行优化。

**提示 $2$**

为了叙述方便，我们用 $\textit{left}_i$ 和 $\textit{right}_i$ 表示位置 $i$ 在状态转移中对应的 $j$ 的区间。在大部分情况下，有：

$$
[\textit{left}_i, \textit{right}_i] = [i - \textit{maxJump}, i - \textit{minJump}]
$$

但由于有 $j \geq 0$ 的限制，可能需要对该区间进行一些处理，具体的处理方法可以参考代码部分。

根据提示 $1$，$f(i)$ 的值为 $\text{True}$，当且仅当 $s[i]$ 为 $0$，并且区间 $[\textit{left}_i, \textit{right}_i]$ 中存在一个位置作为下标对应的 $f$ 值也为 $\text{True}$。如果我们将 $\text{True}$ 看成 $1$，$\text{False}$ 看成 $0$，那么其等价于：

- $f(i)$ 的值为 $\text{True}$，当且仅当 $s[i]$ 为 $0$，并且 $\sum\limits_{j=\textit{left}_i}^{\textit{right}_i} f(j)$ 的值不为 $0$。

由于 $\sum\limits_{j=\textit{left}_i}^{\textit{right}_i} f(j)$ 是数组 $f$ 的一段连续区间的求和，因此我们可以在动态规划的同时维护数组 $f$ 的前缀和数组 $\textit{pre}$，其中：

$$
\textit{pre}(i) = \sum_{j=0}^{i} f(i)
$$

这样就可以通过：

$$
\sum_{j=\textit{left}_i}^{\textit{right}_i} f(j) = \textit{pre}(\textit{right}_i) - \textit{pre}(\textit{left}_i - 1)
$$

在 $O(1)$ 的时间快速地进行状态转移了，使得动态规划的总时间减少为 $O(n)$。这里同样需要注意处理 $\textit{left}_i \leq 0$ 的情况，可以参考代码部分。

**细节**

动态规划的边界条件为 $f(0) = \text{True}$。在进行状态转移时，我们可以从 $i = \textit{minJump}$ 开始，保证 $\textit{right}_i$ 恒大于等于 $0$，这样就只需要特殊处理 $\textit{left}_i$ 了。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool canReach(string s, int minJump, int maxJump) {
        int n = s.size();
        vector<int> f(n), pre(n);
        f[0] = 1;
        // 由于我们从 i=minJump 开始动态规划，因此需要将 [0,minJump) 这部分的前缀和预处理出来
        for (int i = 0; i < minJump; ++i) {
            pre[i] = 1;
        }
        for (int i = minJump; i < n; ++i) {
            int left = i - maxJump, right = i - minJump;
            if (s[i] == '0') {
                int total = pre[right] - (left <= 0 ? 0 : pre[left - 1]);
                f[i] = (total != 0);
            }
            pre[i] = pre[i - 1] + f[i];
        }
        return f[n - 1];
    }
};
```

```Python [sol1-Python3]
class Solution:
    def canReach(self, s: str, minJump: int, maxJump: int) -> bool:
        n = len(s)
        f, pre = [0] * n, [0] * n
        f[0] = 1
        # 由于我们从 i=minJump 开始动态规划，因此需要将 [0,minJump) 这部分的前缀和预处理出来
        for i in range(minJump):
            pre[i] = 1
        for i in range(minJump, n):
            left, right = i - maxJump, i - minJump
            if s[i] == "0":
                total = pre[right] - (0 if left <= 0 else pre[left - 1])
                f[i] = int(total != 0)
            pre[i] = pre[i - 1] + f[i]

        return bool(f[n - 1])
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(n)$，即为数组 $f$ 和 $\textit{pre}$ 需要使用的空间。
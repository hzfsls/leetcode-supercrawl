#### 方法一：分析本质不同的站位情况 + 记忆化搜索

**前言**

**本题思维难度较大**。其中的有些技巧可能在其它的题目中很少出现。

读者在第一次阅读本题解时，可以多去思考「怎么做」，而尽量不要去思考「为什么要这么做」。

**思路与算法**

我们可以用 $F(n, f, s)$ 表示还剩余 $n$ 个人，并且两名最佳运动员分别是一排中从左往右数的第 $f$ 和 $s$ 名运动员时，他们比拼的最早回合数。

同理，我们用 $G(n, f, s)$ 表示他们比拼的最晚回合数。

那么如何进行状态转移呢？

**只考虑本质不同的站位情况**

如果我们单纯地用 $F(n, f, s)$ 来进行状态转移，会使得设计出的算法和编写出的代码都相当复杂。例如我们需要考虑 $f$ 是在左侧（即从前往后数）、中间（即轮空）还是右侧（即从后往前数），对于 $s$ 也需要考虑那么多情况，这样状态转移方程就相当麻烦。

我们可以考虑分析出**本质不同的站位情况**，得到下面的表格：

| | $s$ 在左侧 | $s$ 在中间 | $s$ 在右侧 |
| :-: | :-: | :-: | :-: |
| $f$ 在左侧 | 保持不变 | 保持不变 | 保持不变 |
| $f$ 在中间 | 等价于「$f$ 在左侧，$s$ 在中间」| 不存在这种情况 | 等价于「$f$ 在左侧，$s$ 在中间」|
| $f$ 在右侧 | 等价于「$f$ 在左侧，$s$ 在右侧」| 等价于「$f$ 在左侧，$s$ 在中间」 | 等价于「$f$ 在左侧，$s$ 在左侧」|

其正确性在于：

- $F(n, f, s) = F(n, s, f)$ 恒成立。即我们交换两名最佳运动员的位置，结果不会发生变化；

- $F(n, f, s) = F(n, n+1-s, n+1-f)$ 恒成立。因为我们会让从前往后数的第 $i$ 运动员与从后往前数的第 $i$ 名运动员进行比拼，那么我们将所有的运动员看成一个整体，整体翻转一下，结果同样不会发生变化。

我们使用这两条变换规则，就可以保证在 $F(n, f, s)$ 中，$f$ 一定小于 $s$，那么 $f$ 一定在左侧，而 $s$ 可以在左侧、中间或者右侧。这样我们就将原本的 $8$ 种情况减少到了 $3$ 种情况。

对于 $G(n, f, s)$，其做法是完全相同的。

**状态转移方程的设计**

既然我们知道了 $f$ 一定在左侧，那么我们就可以根据 $s$ 在左侧、中间还是右侧，分别设计状态转移方程了。

![fig1](https://assets.leetcode-cn.com/solution-static/5787/5787_1.png)

如果 $s$ 在左侧，如上图所示：

- $f$ 左侧有 $f-1$ 名运动员，它们会与右侧对应的运动员进行比拼，因此剩下 $[0, f-1]$ 名运动员；

- $f$ 与 $s$ 中间有 $s-f-1$ 名运动员，它们会与右侧对应的运动员进行比拼，因此剩下 $[0, s-f-1]$ 名运动员。

如果 $f-1$ 名运动员中剩下了 $i$ 名，而 $s-f-1$ 名运动员中剩下了 $j$ 名，那么在下一回合中，两名最佳运动员分别位于位置 $i+1$ 和位置 $i+j+2$，而剩余的运动员总数为 $\lfloor \dfrac{n+1}{2} \rfloor$，其中 $\lfloor x \rfloor$ 表示对 $x$ 向下取整。因此我们可以得到状态转移方程：

$$
F(n, f, s) = \left( \min_{i\in [0,f-1], j \in [0, s-f-1]} F(\lfloor \frac{n+1}{2} \rfloor, i + 1, i + j + 2) \right) + 1
$$

![fig2](https://assets.leetcode-cn.com/solution-static/5787/5787_2.png)

如果 $s$ 在中间，如上图所示，我们可以发现状态转移方程与 $s$ 在左侧的情况是完全相同的。


如果 $s$ 在右侧，那么情况会较为麻烦，会有三种情况：

- 最简单的情况就是 $f$ 和 $s$ 恰好比拼，即 $f+s=n+1$，那么 $F(n, f, s)=1$；

- 此外，设这一回合与 $s$ 比拼的是 $s'=n+1-s$，那么 $f < s'$ 是一种情况，$f > s'$ 是另一种情况。

![fig3](https://assets.leetcode-cn.com/solution-static/5787/5787_3.png)

然而我们可以知道，根据类似上一节「本质不同的站位情况」的分析，我们将 $f$ 变为 $n+1-s$，$s$ 变为 $n+1-f$，这样 $f$ 仍然小于 $s$，并且 $f$ 也小于 $s'$ 了。因此我们只需要考虑 $f < s'$ 的情况，如上图所示：

- $f$ 左侧有 $f-1$ 名运动员，它们会与右侧对应的运动员进行比拼，因此剩下 $[0, f-1]$ 名运动员；

- $f$ 与 $s'$ 中间有 $s'-f-1$ 名运动员，它们会与右侧对应的运动员进行比拼，因此剩下 $[0, s'-f-1]$ 名运动员；

- $s'$ 一定会输给 $s$；

- $s'$ 与 $s$ 中间有 $n - 2s'$ 名运动员。如果 $n-2s'$ 是偶数，那么他们两两之间比拼，剩下 $\dfrac{n-2s'}{2}$ 名运动员；如果 $n-2s'$ 是奇数，那么其中一人轮空，剩余两两之间比拼，剩下 $\dfrac{n-2s'+1}{2}$ 名运动员。因此，无论 $n-2s'$ 是奇数还是偶数，$s'$ 与 $s$ 中间一定会有 $\lfloor \dfrac{n-2s'+1}{2} \rfloor$ 名运动员。

如果 $f-1$ 名运动员中剩下了 $i$ 名，而 $s'-f-1$ 名运动员中剩下了 $j$ 名，那么在下一回合中，两名最佳运动员分别位于位置 $i+1$ 和位置 $i+j+\lfloor \dfrac{n-2s'+1}{2} \rfloor+2$。因此我们可以得到状态转移方程：

$$
F(n, f, s) = \left( \min_{i\in [0,f-1], j \in [0, s'-f-1]} F(\lfloor \frac{n+1}{2} \rfloor, i + 1, i+j+\lfloor \dfrac{n-2s'+1}{2} \rfloor+2) \right) + 1
$$

这样我们就得到了所有关于 $F$ 的状态转移方程。而关于 $G$ 的状态转移方程，我们只需要把所有的 $\min$ 改为 $\max$ 即可。

**细节**

在「本质不同的站位情况」一节中，我们提到了两种变换规则。那么我们具体应当在 $n, f, s$ 满足什么关系（而不是抽象的「左侧」「中间」「右侧」）时使用其中的哪些规则呢？

这里有很多种设计方法，我们介绍一种较为简单的，题解代码中使用的方法：

- 首先我们使用自顶向下的记忆化搜索代替动态规划进行状态转移，这样写更加简洁直观，并且无需考虑状态的求值顺序；

- 记忆化搜索的入口为 $F(n, \textit{firstPlayer}, \textit{secondPlayer})$。我们在开始记忆化搜索之前，先通过变换规则 $F(n, f, s) = F(n, s, f)$ 使得 $\textit{firstPlayer}$ 一定小于 $\textit{secondPlayer}$，这样一来，由于另一条变换规则 $F(n, f, s) = F(n, n+1-s, n+1-f)$ 不会改变 $f$ 与 $s$ 间的大小关系，因此在接下来的记忆化搜索中，$f < s$ 是恒成立的，我们也就无需使用变换规则 $F(n, f, s) = F(n, s, f)$ 了；

- 在之前表格中，我们需要变换的情况有 $5$ 种，分别是：「$f$ 在中间，$s$ 在左侧」「$f$ 在中间，$s$ 在右侧」「$f$ 在右侧，$s$ 在左侧」「$f$ 在右侧，$s$ 在中间」「$f$ 在右侧，$s$ 在右侧」。由于我们已经保证了 $f < s$ 恒成立，因此这 $5$ 种情况中只剩下 $2$ 种是需要处理的，即：「$f$ 在中间，$s$ 在右侧」和「$f$ 在右侧，$s$ 在右侧」。此外，我们在「状态转移方程的设计」一节中还发现了一种需要处理的情况，即「$f$ 在左侧，$s$ 在右侧，并且 $f>s'=n+1-s$」。

    那么这 $3$ 种情况是否可以统一呢？对于最后一种情况，我们有 $f+s > n+1$，而「$f$ 在中间，$s$ 在右侧」和「$f$ 在右侧，$s$ 在右侧」也恰好满足 $f+s > n+1$，并且所有不需要变换的情况都不满足 $f+s > n+1$。因此我们只需要在 $f+s > n+1$ 时，使用一次变换规则 $F(n, f, s) = F(n, n+1-s, n+1-f)$ 就行了。

**代码**

由于 $\texttt{Python}$ 中可以很方便地使用 $\texttt{@cache}$ 进行记忆化搜索，因此在下面 $\texttt{Python}$ 的代码中，我们无需显式地定义 $F$ 和 $G$，函数 $\textit{dp}(n, f, s)$ 返回的二元组即为 $F(n, f, s)$ 和 $G(n, f, s)$。

```C++ [sol1-C++]
class Solution {
private:
    int F[30][30][30], G[30][30][30];

public:
    pair<int, int> dp(int n, int f, int s) {
        if (F[n][f][s]) {
            return {F[n][f][s], G[n][f][s]};
        }
        if (f + s == n + 1) {
            return {1, 1};
        }

        // F(n,f,s)=F(n,n+1-s,n+1-f)
        if (f + s > n + 1) {
            tie(F[n][f][s], G[n][f][s]) = dp(n, n + 1 - s, n + 1 - f);
            return {F[n][f][s], G[n][f][s]};
        }

        int earlist = INT_MAX, latest = INT_MIN;
        int n_half = (n + 1) / 2;

        if (s <= n_half) {
            // 在左侧或者中间
            for (int i = 0; i < f; ++i) {
                for (int j = 0; j < s - f; ++j) {
                    auto [x, y] = dp(n_half, i + 1, i + j + 2);
                    earlist = min(earlist, x);
                    latest = max(latest, y);
                }
            }
        }
        else {
            // s 在右侧
            // s'
            int s_prime = n + 1 - s;
            int mid = (n - 2 * s_prime + 1) / 2;
            for (int i = 0; i < f; ++i) {
                for (int j = 0; j < s_prime - f; ++j) {
                    auto [x, y] = dp(n_half, i + 1, i + j + mid + 2);
                    earlist = min(earlist, x);
                    latest = max(latest, y);
                }
            }
        }

        return {F[n][f][s] = earlist + 1, G[n][f][s] = latest + 1};
    }

    vector<int> earliestAndLatest(int n, int firstPlayer, int secondPlayer) {
        memset(F, 0, sizeof(F));
        memset(G, 0, sizeof(G));

        // F(n,f,s) = F(n,s,f)
        if (firstPlayer > secondPlayer) {
            swap(firstPlayer, secondPlayer);
        }

        auto [earlist, latest] = dp(n, firstPlayer, secondPlayer);
        return {earlist, latest};
    }
};
```

```Python [sol1-Python3]
class Solution:
    def earliestAndLatest(self, n: int, firstPlayer: int, secondPlayer: int) -> List[int]:
        @cache
        def dp(n: int, f: int, s: int) -> (int, int):
            if f + s == n + 1:
                return (1, 1)
            
            # F(n,f,s)=F(n,n+1-s,n+1-f)
            if f + s > n + 1:
                return dp(n, n + 1 - s, n + 1 - f)
            
            earliest, latest = float("inf"), float("-inf")
            n_half = (n + 1) // 2

            if s <= n_half:
                # s 在左侧或者中间
                for i in range(f):
                    for j in range(s - f):
                        x, y = dp(n_half, i + 1, i + j + 2)
                        earliest = min(earliest, x)
                        latest = max(latest, y)
            else:
                # s 在右侧
                # s'
                s_prime = n + 1 - s
                mid = (n - 2 * s_prime + 1) // 2
                for i in range(f):
                    for j in range(s_prime - f):
                        x, y = dp(n_half, i + 1, i + j + mid + 2)
                        earliest = min(earliest, x)
                        latest = max(latest, y)
            
            return (earliest + 1, latest + 1)

        # F(n,f,s) = F(n,s,f)
        if firstPlayer > secondPlayer:
            firstPlayer, secondPlayer = secondPlayer, firstPlayer
        
        earliest, latest = dp(n, firstPlayer, secondPlayer)
        dp.cache_clear()
        return [earliest, latest]
```

**复杂度分析**

- 时间复杂度：$O(n^4 \log n)$。在状态 $F(n, f, s)$ 中（$G(n, f, s)$ 同理），每一维的范围都是 $O(n)$，而每一个状态需要 $O(n^2)$ 的时间枚举所有可以转移而来的状态，因此整个算法的时间复杂度为 $O(n^5)$。

    然而我们可以发现，$F(n, f, s)$ 中的 $n$ 的取值个数是有限的，在记忆化搜索的过程中，$n$ 会变成 $\lfloor \dfrac{n+1}{2} \rfloor$ 后继续向下递归，因此 $n$ 的取值个数只有 $O(\log n)$ 种，即总时间复杂度为 $O(n^4 \log n)$。

- 空间复杂度：$O(n^2 \log n)$ 或 $O(n^3)$，即为存储所有状态需要的空间。在 $\texttt{C++}$ 代码中，我们使用数组存储所有状态，即使 $n$ 的取值个数只有 $O(\log n)$ 种，我们还是需要对第一维开辟 $O(n)$ 的空间。而在 $\texttt{Python}$ 代码中，$\texttt{@cache}$ 使用元组 $\texttt{tuple}$ 作为字典 $\texttt{dict}$ 的键来存储所有状态的值，状态的数量为 $O(n^2 \log n)$，那么使用的空间也为 $O(n^2 \log n)$。

此外，由于力扣平台上对于运行时间的计算是取所有测试数据的运行时间总和，所有的测试数据会在一次运行中全部测试完成，**而本题中记忆化存储的结果在不同的测试数据之间是可以共享的**。因此，代码中清空记忆化结果的命令（例如 $\texttt{C++}$ 中的 $\texttt{memset}$ 或者 $\texttt{Python}$ 中的 $\texttt{cache\_clear}$）是可以省略的。
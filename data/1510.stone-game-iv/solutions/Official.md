#### 方法一：动态规划

我们用 $f[i]$ 表示先手在面对 $i$ 颗石子时是否处于必胜态（会赢得比赛）。由于先手和后手都采取最优策略，那么 $f[i]$ 为必胜态，当且仅当存在某个 $f[i - k^2]$ 为必败态。也就是说，当先手在面对 $i$ 颗石子时，可以选择取走 $k^2$ 颗，剩余的 $i-k^2$ 颗对于后手来说是必败态，因此先手会获胜。

我们可以写出状态转移方程：

$$
f[i] = \begin{cases}
\text{true}, & \text{any~} f[i-k^2] \text{~is false where~} 1 \leq k^2 \leq i \\
\text{false}, & \text{otherwise}
\end{cases}
$$

边界条件为 $f[0]=\text{false}$，即没有石子时，先手会输掉游戏。

最终的答案即为 $f[n]$。

```C++ [sol1-C++]
class Solution {
public:
    bool winnerSquareGame(int n) {
        vector<int> f(n + 1);
        for (int i = 1; i <= n; ++i) {
            for (int k = 1; k * k <= i; ++k) {
                if (!f[i - k * k]) {
                    f[i] = true;
                    break;
                }
            }
        }
        
        return f[n];
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean winnerSquareGame(int n) {
        boolean[] f = new boolean[n + 1];
        for (int i = 1; i <= n; ++i) {
            for (int k = 1; k * k <= i; ++k) {
                if (!f[i - k * k]) {
                    f[i] = true;
                    break;
                }
            }
        }
        
        return f[n];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def winnerSquareGame(self, n: int) -> bool:
        f = [False] * (n + 1)
        for i in range(1, n + 1):
            k = 1
            while k * k <= i:
                if not f[i - k * k]:
                    f[i] = True
                    break
                k += 1
        
        return f[n]
```

```C [sol1-C]
bool winnerSquareGame(int n) {
    int f[n + 1];
    memset(f, 0, sizeof(f));
    for (int i = 1; i <= n; ++i) {
        for (int k = 1; k * k <= i; ++k) {
            if (!f[i - k * k]) {
                f[i] = true;
                break;
            }
        }
    }

    return f[n];
}
```

**复杂度分析**

- 时间复杂度：$O(n \sqrt n)$。对于每一个数 $i$，$k$ 的枚举上限不超过 $\sqrt i$，所以总时间复杂度为 $O(\sum_{i=1}^n \sqrt i) = O(n \sqrt n)$。

- 空间复杂度：$O(n)$，即为存储所有状态需要的空间。
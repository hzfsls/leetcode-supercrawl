#### 方法一：反向操作 + 贪心

**思路与算法**

我们可以反过来考虑这个游戏：

- 目标是将给定的整数 $\textit{target}$ 变为 $1$；

- 可以进行**递减**操作，将当前整数的值减 $1$；

- 可以进行**折半**操作，将当前整数的值除以 $2$，前提是当前整数为偶数。

上述游戏和题目描述中的游戏是等价的。但不同的是，题目描述中的游戏在每一次行动中，我们并不能知道是进行**递增**还是**加倍**操作。而在上述游戏中，如果当前整数为奇数，那么我们必须只能执行**递减**操作；如果当前整数为偶数，那么可以执行任意操作。

由于我们的目标是将整数变为 $1$，因此在当前整数为偶数时，我们应当贪心地执行**折半**操作。这也是可以证明的：

> 如果我们选择执行**递减**操作，那么有两种情况：
> - 我们不断执行**递减**操作直到整数变为 $1$；
> - 我们执行了 $k$ 次**递减**操作，随后再执行**折半**操作。
>
> 对于第一种情况。我们可以先执行一次**折半**操作，这样后续的**递减**操作至少会减少一次；对于第二种情况，我们可以先执行一次**折半**操作，再执行 $k/2$ 次**递减**操作，可以得到相同的结果，但操作次数减少了 $k/2$ 次。

因此如果当前整数为偶数，并且还有剩余的**折半**操作次数，我们就执行**折半**操作，否则执行**递减**操作。

**优化**

在最坏的情况下，如果初始的**折半**操作次数为 $0$，那么我们会执行 $\textit{target} - 1$ 次递减操作，时间复杂度为 $O(\textit{target})$，会超出时间限制。一种可行的优化方法是，任意时刻当**折半**操作次数为 $0$ 时，剩余的操作只能为**递减操作**，我们直接返回之前使用的操作次数加上当前 $\textit{target}$ 的值减去 $1$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minMoves(int target, int maxDoubles) {
        int ans = 0;
        while (maxDoubles && target != 1) {
            ++ans;
            if (target % 2 == 1) {
                --target;
            }
            else {
                --maxDoubles;
                target /= 2;
            }
        }
        ans += (target - 1);
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minMoves(self, target: int, maxDoubles: int) -> int:
        ans = 0
        while maxDoubles and target != 1:
            ans += 1
            if target % 2 == 1:
                target -= 1
            else:
                maxDoubles -= 1
                target //= 2
        ans += (target - 1)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(\min(\log \textit{target}, \textit{maxDoubles}))$。在上述代码的循环中，每两次循环就至少会有一次**折半**操作，而 $\textit{target}$ 最多可以被**折半** $O(\log \textit{target})$ 次。并且**折半**操作有次数限制，不能超过 $\textit{maxDoubles}$，因此时间复杂度为 $O(\min(\log \textit{target}, \textit{maxDoubles}))$。

- 空间复杂度：$O(1)$。
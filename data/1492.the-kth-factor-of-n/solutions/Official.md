## [1492.n 的第 k 个因子 中文官方题解](https://leetcode.cn/problems/the-kth-factor-of-n/solutions/100000/n-de-di-k-ge-yin-zi-by-leetcode-solution)
#### 方法一：枚举

我们可以从小到大枚举所有在 $[1, n]$ 范围内的数，并判断是否为 $n$ 的因子。

```C++ [sol1-C++]
class Solution {
public:
    int kthFactor(int n, int k) {
        int count = 0;
        for (int factor = 1; factor <= n; ++factor) {
            if (n % factor == 0) {
                ++count;
                if (count == k) {
                    return factor;
                }
            }
        }
        return -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int kthFactor(int n, int k) {
        int count = 0;
        for (int factor = 1; factor <= n; ++factor) {
            if (n % factor == 0) {
                ++count;
                if (count == k) {
                    return factor;
                }
            }
        }
        return -1;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def kthFactor(self, n: int, k: int) -> int:
        count = 0
        for factor in range(1, n+1):
            if n % factor == 0:
                count += 1
                if count == k:
                    return factor
        return -1
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$。

#### 方法二：枚举优化

方法一中的枚举时间复杂度较高，直观地来说，如果 $n=1000$，那么从 $501$ 开始到 $999$ 结束，这些数都不是 $n$ 的因子，但我们却要将这些数全部枚举一遍。可以发现，如果 $n$ 有一个因子 $k$，那么它必然有一个因子 $n/k$，这两个因子中至少有一个是小于等于 $\sqrt n$ 的。

> 如何证明？我们使用反证法，假设 $k > \sqrt n$ 且 $n/k > \sqrt n$，那么我们有：
> $$
> n = k * (n / k) > \sqrt n * \sqrt n = n
> $$
> 产生了矛盾！

因此我们只要在 $[1, \lfloor \sqrt n \rfloor]$ 的范围内枚举 $n$ 的因子 $x$（这里 $\lfloor a \rfloor$ 表示对 $a$ 进行下取整），这些因子都小于等于 $\sqrt n$。在这之后，我们倒过来在 $[\lfloor \sqrt n \rfloor, 1]$ 的范围内枚举 $n$ 的因子 $x$，但我们真正的用到的因子是 $n/x$。这样一来，我们就从小到大枚举出了 $n$ 的所有因子。

最后需要注意一种特殊情况：如果 $n$ 是完全平方数，那么满足 $x^2 = n$ 的因子 $x$ 被枚举了两次，需要忽略其中的一次。

```C++ [sol2-C++]
class Solution {
public:
    int kthFactor(int n, int k) {
        int count = 0, factor;
        for (factor = 1; factor * factor <= n; ++factor) {
            if (n % factor == 0) {
                ++count;
                if (count == k) {
                    return factor;
                }
            }
        }
        --factor;
        if (factor * factor == n) {
            --factor;
        }
        for (; factor > 0; --factor) {
            if (n % factor == 0) {
                ++count;
                if (count == k) {
                    return n / factor;
                }
            }
        }
        return -1;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int kthFactor(int n, int k) {
        int count = 0, factor;
        for (factor = 1; factor * factor <= n; ++factor) {
            if (n % factor == 0) {
                ++count;
                if (count == k) {
                    return factor;
                }
            }
        }
        --factor;
        if (factor * factor == n) {
            --factor;
        }
        for (; factor > 0; --factor) {
            if (n % factor == 0) {
                ++count;
                if (count == k) {
                    return n / factor;
                }
            }
        }
        return -1;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def kthFactor(self, n: int, k: int) -> int:
        count = 0
        factor = 1
        while factor * factor <= n:
            if n % factor == 0:
                count += 1
                if count == k:
                    return factor
            factor += 1
        factor -= 1
        if factor * factor == n:
            factor -= 1
        while factor > 0:
            if n % factor == 0:
                count += 1
                if count == k:
                    return n // factor
            factor -= 1
        return -1
```

**复杂度分析**

- 时间复杂度：$O(\sqrt n)$。

- 空间复杂度：$O(1)$。
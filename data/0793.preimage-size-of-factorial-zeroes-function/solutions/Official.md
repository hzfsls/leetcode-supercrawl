## [793.阶乘函数后 K 个零 中文官方题解](https://leetcode.cn/problems/preimage-size-of-factorial-zeroes-function/solutions/100000/jie-cheng-han-shu-hou-k-ge-ling-by-leetc-n6vj)
#### 方法一：二分查找

**思路与算法**

首先我们令 $\textit{zeta}(x)$ 为 $x!$ 末尾零的个数。根据[「172. 阶乘后的零」的官方题解](https://leetcode.cn/problems/factorial-trailing-zeroes/solution/jie-cheng-hou-de-ling-by-leetcode-soluti-1egk/)，有

$$\textit{zeta}(x) = \sum_{k = 1}^{\infty}\left\lfloor{\frac{x}{5^k}}\right\rfloor$$

记 $n_{x}$ 表示 $x!$ 末尾零的个数**不小于** $x$ 的最小数，那么题目等价于求解 $n_{k + 1} - n_k$。
 
由于 $\textit{zeta}(x)$ 为**单调不减函数**，因此 $n_{k + 1}$ 和 $n_k$ 可以通过「二分查找」来求解。

又因为

$$
\textit{zeta}(x) = \sum_{k = 1}^{\infty}\left\lfloor{\frac{x}{5^k}}\right\rfloor 
\ge \left\lfloor{\frac{x}{5}}\right\rfloor
$$

得

$$\textit{zeta}(5x) \ge x$$

所以当二分求解 $n_{x}$ 时，我们可以将二分的初始右边界 $r$ 设置为 $5x$。

**代码**

```Python [sol1-Python3]
class Solution:
    def preimageSizeFZF(self, k: int) -> int:
        def zeta(n: int) -> int:
            res = 0
            while n:
                n //= 5
                res += n
            return res

        def nx(k: int) -> int:
            return bisect_left(range(5 * k), k, key=zeta)

        return nx(k + 1) - nx(k)
```

```C++ [sol1-C++]
class Solution {
public:
    int zeta(long x) {
        int res = 0;
        while (x) {
            res += x / 5;
            x /= 5;
        }
        return res;
    }

    long long help(int k) {
        long long r = 5LL * k;
        long long l = 0;
        while (l <= r) {
            long long mid = (l + r) / 2;
            if (zeta(mid) < k) {
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
        return r + 1;
    }

    int preimageSizeFZF(int k) {
        return help(k + 1) - help(k);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int preimageSizeFZF(int k) {
        return (int) (help(k + 1) - help(k));
    }

    public long help(int k) {
        long r = 5L * k;
        long l = 0;
        while (l <= r) {
            long mid = (l + r) / 2;
            if (zeta(mid) < k) {
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
        return r + 1;
    }

    public long zeta(long x) {
        long res = 0;
        while (x != 0) {
            res += x / 5;
            x /= 5;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int PreimageSizeFZF(int k) {
        return (int) (Help(k + 1) - Help(k));
    }

    public long Help(int k) {
        long r = 5L * k;
        long l = 0;
        while (l <= r) {
            long mid = (l + r) / 2;
            if (Zeta(mid) < k) {
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
        return r + 1;
    }

    public long Zeta(long x) {
        long res = 0;
        while (x != 0) {
            res += x / 5;
            x /= 5;
        }
        return res;
    }
}
```

```C [sol1-C]
long long zeta(long x) {
    long long res = 0;
    while (x != 0) {
        res += x / 5;
        x /= 5;
    }
    return res;
}

long long help(int k) {
    long long r = 5LL * k;
    long long l = 0;
    while (l <= r) {
        long mid = (l + r) / 2;
        if (zeta(mid) < k) {
            l = mid + 1;
        } else {
            r = mid - 1;
        }
    }
    return r + 1;
}

int preimageSizeFZF(int k){
    return help(k + 1) - help(k);
}
```

```JavaScript [sol1-JavaScript]
var preimageSizeFZF = function(k) {
    return help(k + 1) - help(k);
}

const help = (k) => {
    let r = 5 * k;
    let l = 0;
    while (l <= r) {
        const mid = Math.floor((l + r) / 2);
        if (zeta(mid) < k) {
            l = mid + 1;
        } else {
            r = mid - 1;
        }
    }
    return r + 1;
}

const zeta = (x) => {
    let res = 0;
    while (x != 0) {
        res += Math.floor(x / 5);
        x = Math.floor(x / 5);
    }
    return res;
};
```

```go [sol1-Golang]
func zeta(n int) (res int) {
    for n > 0 {
        n /= 5
        res += n
    }
    return
}

func nx(k int) int {
    return sort.Search(5*k, func(x int) bool { return zeta(x) >= k })
}

func preimageSizeFZF(k int) int {
    return nx(k+1) - nx(k)
}
```

**复杂度分析**

- 时间复杂度：$O(\log^2 k)$，其中 $k$ 为题目给定数字，二分查找 $n_{k + 1}, n_k$ 的时间复杂度为 $O(\log k)$，其中每一步计算 $\textit{zeta}(x)$ 的时间复杂度为 $O(\log k)$。
- 空间复杂度：$O(1)$，$\textit{zeta}(x)$ 仅为常量空间开销。
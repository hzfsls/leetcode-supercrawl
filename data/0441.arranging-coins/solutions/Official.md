#### 方法一：二分查找

**思路和算法**

根据等差数列求和公式可知，前 $k$ 个完整阶梯行所需的硬币数量为

$$
\textit{total} = \frac{k \times (k+1)}{2}
$$

因此，可以通过二分查找计算 $n$ 枚硬币可形成的完整阶梯行的总行数。

因为 $1 \le n \le 2^{31} -1$，所以 $n$ 枚硬币至少可以组成 $1$ 个完整阶梯行，至多可以组成 $n$ 个完整阶梯行（在 $n = 1$ 时得到）。

**代码**

```Python [sol1-Python3]
class Solution:
    def arrangeCoins(self, n: int) -> int:
        left, right = 1, n
        while left < right:
            mid = (left + right + 1) // 2
            if mid * (mid + 1) <= 2 * n:
                left = mid
            else:
                right = mid - 1
        return left
```

```Java [sol1-Java]
class Solution {
    public int arrangeCoins(int n) {
        int left = 1, right = n;
        while (left < right) {
            int mid = (right - left + 1) / 2 + left;
            if ((long) mid * (mid + 1) <= (long) 2 * n) {
                left = mid;
            } else {
                right = mid - 1;
            }
        }
        return left;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ArrangeCoins(int n) {
        int left = 1, right = n;
        while (left < right) {
            int mid = (right - left + 1) / 2 + left;
            if ((long) mid * (mid + 1) <= (long) 2 * n) {
                left = mid;
            } else {
                right = mid - 1;
            }
        }
        return left;
    }
}
```

```JavaScript [sol1-JavaScript]
var arrangeCoins = function(n) {
    let left = 1, right = n;
    while (left < right) {
        const mid = Math.floor((right - left + 1) / 2) + left;
        if (mid * (mid + 1) <= 2 * n) {
            left = mid;
        } else {
            right = mid - 1;
        }
    }
    return left;
};
```

```C++ [sol1-C++]
class Solution {
public:
    int arrangeCoins(int n) {
        int left = 1, right = n;
        while (left < right) {
            int mid = (right - left + 1) / 2 + left;
            if ((long long) mid * (mid + 1) <= (long long) 2 * n) {
                left = mid;
            } else {
                right = mid - 1;
            }
        }
        return left;
    }
};
```

```go [sol1-Golang]
func arrangeCoins(n int) int {
    return sort.Search(n, func(k int) bool { k++; return k*(k+1) > 2*n })
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。

- 空间复杂度：$O(1)$。

#### 方法二：数学

**思路和算法**

考虑直接通过求解方程来计算 $n$ 枚硬币可形成的完整阶梯行的总行数。不妨设可以形成的行数为 $x$，则有

$$
\frac{(x+1) \times x}{2} = n
$$

整理得一元二次方程

$$
x^2 + x - 2n = 0
$$

因为 $n \ge 1$ ，所以判别式

$$
\Delta = b^2 - 4ac = 8n + 1 > 0
$$

解得

$$
x_1 = \frac{-1 - \sqrt{8n+1}}{2}, \hspace{1em} x_2 = \frac{-1 + \sqrt{8n+1}}{2}
$$

因为 $x_1 < 0$，故舍去。此时 $x_2$ 即为硬币可以排列成的行数，可以完整排列的行数即 $\lfloor x_2 \rfloor$，其中符号 $\lfloor x \rfloor$ 表示 $x$ 的向下取整。

**代码**

```Python [sol2-Python3]
class Solution:
    def arrangeCoins(self, n: int) -> int:
        return int((pow(8 * n + 1, 0.5) - 1) / 2)
```

```Java [sol2-Java]
class Solution {
    public int arrangeCoins(int n) {
        return (int) ((Math.sqrt((long) 8 * n + 1) - 1) / 2);
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ArrangeCoins(int n) {
        return (int) ((Math.Sqrt((long) 8 * n + 1) - 1) / 2);
    }
}
```

```JavaScript [sol2-JavaScript]
var arrangeCoins = function(n) {
    return Math.floor((Math.sqrt(8 * n + 1) - 1) / 2);
};
```

```C++ [sol2-C++]
class Solution {
public:
    int arrangeCoins(int n) {
        return (int) ((sqrt((long long) 8 * n + 1) - 1) / 2);
    }
};
```

```go [sol2-Golang]
func arrangeCoins(n int) int {
    return int((math.Sqrt(float64(8*n+1)) - 1) / 2)
}
```

**复杂度分析**

代码中使用的 $\texttt{pow}$ 函数的时空复杂度与 CPU 支持的指令集相关，这里不深入分析。
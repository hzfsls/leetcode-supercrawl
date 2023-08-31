## [1739.放置盒子 中文官方题解](https://leetcode.cn/problems/building-boxes/solutions/100000/fang-zhi-he-zi-by-leetcode-solution-7ah2)
#### 方法一：找规律

**思路与算法**

为了方便画图找规律，我们将立体图转换为平面图来表示：

![fig1](https://assets.leetcode-cn.com/solution-static/1739/1739_1.png)

根据贪心思想，接触地面的盒子构成的总体形状应该是一个左上三角，这样才可以使得内部的盒子垒起来的高度更高，以保证接触地面盒子数量最小的情况下容纳更多的盒子。我们画出前四层的盒子增长情况，来试探一下有什么规律存在：

![fig2](https://assets.leetcode-cn.com/solution-static/1739/1739_2.png)

由上图可知，第 $i$ 层最多可以增加 $i$ 个接触地面的盒子，所带来的收益（即增加的盒子放置数）是 $(1 + 2 + \cdots + i) = \frac{i \times (i + 1)}{2}$。随着 $i$ 的增加，成平方级增长。

要放置 $n$ 个盒子，我们需要完整的放满 $i - 1$ 层，然后剩余的盒子用第 $i$ 层的 $j$ 个（接触地面的盒子）来填充。即找到最小的 $i$ 和 $j$ 满足：

$$
\begin{align*}
n &\le (1) + (1 + 2) + (1 + 2 + 3) + \cdots + (1 + 2 + \cdots + i - 1) + (1 + 2 + \cdots + j) \\
  &= \frac{1\times 2}{2} + \frac{2\times 3}{2} + \frac{3\times 4}{2} + \cdots + \frac{(i - 1)\times i}{2} + \frac{j\times (j + 1)}{2}
\end{align*}
$$

代码中，我们维护一个 $\textit{cur}$ 表示第 $i$ 层最多可以增加多少个可放置的盒子，如果当前 $n \gt \textit{cur}$，将 $n$ 减去它，然后递增 $i$，否则当前的 $i$ 就是我们最终要找的 $i$。每次 $i$ 递增时，首先令 $i = i + 1$，然后更新 $\textit{cur} = \textit{cur} + i$。

然后我们找 $j$，维护变量 $\textit{cur}$ 表示在第 $i$ 层中再添加一个接触地面的盒子时可以增加多少个可放置的盒子，如果当前 $n \gt \textit{cur}$，则将 $n$ 减去它，然后递增 $j$，否则当前的 $j$ 就是我们最终要找的 $j$。每次递增 $j$ 时，首先令 $j = j + 1$, 然后更新 $\textit{cur} = \textit{cur}+ 1$。

最终我们完整的放满了前 $i - 1$ 层，并且在第 $i$ 层放置了 $j$ 个接触地面的盒子，因此答案应该为 $1 + 2 + \cdots + (i - 1) + j = \frac{(i - 1) \times i}{2} + j$。

**代码**

```Python [sol1-Python3]
class Solution:
    def minimumBoxes(self, n: int) -> int:
        cur = i = j = 1
        while n > cur:
            n -= cur
            i += 1
            cur += i
        cur = 1
        while n > cur:
            n -= cur
            j += 1
            cur += 1
        return (i - 1) * i // 2 + j
```

```C++ [sol1-C++]
class Solution {
public:
    int minimumBoxes(int n) {
        int cur = 1, i = 1, j = 1;
        while (n > cur) {
            n -= cur;
            i++;
            cur += i;
        }
        cur = 1;
        while (n > cur) {
            n -= cur;
            j++;
            cur++;
        }
        return (i - 1) * i / 2 + j;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minimumBoxes(int n) {
        int cur = 1, i = 1, j = 1;
        while (n > cur) {
            n -= cur;
            i++;
            cur += i;
        }
        cur = 1;
        while (n > cur) {
            n -= cur;
            j++;
            cur++;
        }
        return (i - 1) * i / 2 + j;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumBoxes(int n) {
        int cur = 1, i = 1, j = 1;
        while (n > cur) {
            n -= cur;
            i++;
            cur += i;
        }
        cur = 1;
        while (n > cur) {
            n -= cur;
            j++;
            cur++;
        }
        return (i - 1) * i / 2 + j;
    }
}
```

```go [sol1-Golang]
func minimumBoxes(n int) int {
	cur, i, j := 1, 1, 1
	for n > cur {
		n -= cur
		i++
		cur += i
	}
	cur = 1
	for n > cur {
		n -= cur
		j++
		cur++
	}
	return (i-1)*i/2 + j
}
```

```JavaScript [sol1-JavaScript]
var minimumBoxes = function(n) {
    let cur = 1, i = 1, j = 1;
    while (n > cur) {
        n -= cur;
        i++;
        cur += i;
    }
    cur = 1;
    while (n > cur) {
        n -= cur;
        j++;
        cur++;
    }
    return (i - 1) * i / 2 + j;
};
```

```C [sol1-C]
int minimumBoxes(int n) {
    int cur = 1, i = 1, j = 1;
    while (n > cur) {
        n -= cur;
        i++;
        cur += i;
    }
    cur = 1;
    while (n > cur) {
        n -= cur;
        j++;
        cur++;
    }
    return (i - 1) * i / 2 + j;
}
```

**复杂度分析**

- 时间复杂度：$O(\sqrt[3]{n})$，其中 $n$ 是盒子数。需要遍历每一层计算盒子数，层数 $i$ 与 $n$ 的关系是 $i = O(\sqrt[3]{n})$。

- 空间复杂度：$O(1)$。

#### 方法二：二分查找

**思路与算法**

为了方便描述，我们设 $f(x) = \frac{x \times (x + 1)}{2}$ 表示在同一层中连续放置 $x$ 个接触地面的盒子时，总共可以增加多少个可放置盒子。由于第 $i$ 层最多可以放置 $i$ 个接触地面的盒子，所以第 $i$ 层放满可以增加 $f(i)$ 个可放置盒子。

因此，前 $i$ 层可以放置的盒子总数为 $g(i) = \sum_{k=1}^i f(k) = \frac{i \times (i + 1) \times (i + 2)}{6}$。

由于 $g(i)$ 具有单调性，我们可以通过二分查找来找到 $i$，使得前 $i$ 层的数量足够容纳 $n$ 个盒子。与方法一中描述的一样，我们将 $n$ 分解为完整的 $i - 1$ 层和可能不完整的第 $i$ 层。因此，需要找到一个最小的 $i$ 使得：$g(i) \ge n$。

然后由于 $f(j)$ 也具有单调性，对于 $j$ 的求解仍然可以使用二分查找，我们要找到最小的 $j$ 使得 $f(j) \ge n - g(i - 1)$。

得到正确的 $i$ 和 $j$ 之后，答案为 $\frac{(i - 1) \times i}{2} + j$。

需要注意在选取二分查找初始边界时，左边界可以选 $1$，右边界为了防止计算溢出，可以选择 $\min(n, 100000)$ 作为一个保守值。因为 $n \le 10^9$，答案不会超过 $100000$。

有关二分查找的内容，读者同学可以参考：[「在排序数组中查找元素的第一个和最后一个位置」](https://leetcode.cn/problems/find-first-and-last-position-of-element-in-sorted-array/solutions/504484/zai-pai-xu-shu-zu-zhong-cha-zhao-yuan-su-de-di-3-4/)。

```C++ [sol2-C++]
class Solution {
public:
    int minimumBoxes(int n) {
        int i = 0, j = 0;
        int low = 1, high = min(n, 100000);
        while (low < high) {
            int mid = (low + high) >> 1;
            long long sum = (long long) mid * (mid + 1) * (mid + 2) / 6;
            if (sum >= n) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        i = low;
        n -= (long long) (i - 1) * i * (i + 1) / 6;
        low = 1, high = i;
        while (low < high) {
            int mid = (low + high) >> 1;
            long long sum = (long long) mid * (mid + 1) / 2;
            if (sum >= n) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        j = low;
        return (i - 1) * i / 2 + j;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minimumBoxes(int n) {
        int i = 0, j = 0;
        int low = 1, high = Math.min(n, 100000);
        while (low < high) {
            int mid = (low + high) >> 1;
            long sum = (long) mid * (mid + 1) * (mid + 2) / 6;
            if (sum >= n) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        i = low;
        n -= (long) (i - 1) * i * (i + 1) / 6;
        low = 1;
        high = i;
        while (low < high) {
            int mid = (low + high) >> 1;
            long sum = (long) mid * (mid + 1) / 2;
            if (sum >= n) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        j = low;
        return (i - 1) * i / 2 + j;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int MinimumBoxes(int n) {
        int i = 0, j = 0;
        int low = 1, high = Math.Min(n, 100000);
        while (low < high) {
            int mid = (low + high) >> 1;
            long sum = (long) mid * (mid + 1) * (mid + 2) / 6;
            if (sum >= n) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        i = low;
        n = (int) (n - (long) (i - 1) * i * (i + 1) / 6);
        low = 1;
        high = i;
        while (low < high) {
            int mid = (low + high) >> 1;
            long sum = (long) mid * (mid + 1) / 2;
            if (sum >= n) {
                high = mid;
            } else {
                low = mid + 1;
            }
        }
        j = low;
        return (i - 1) * i / 2 + j;
    }
}
```

```C [sol2-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int minimumBoxes(int n) {
    int i = 0, j = 0;
    int low = 1, high = MIN(n, 100000);
    while (low < high) {
        int mid = (low + high) >> 1;
        long long sum = (long long) mid * (mid + 1) * (mid + 2) / 6;
        if (sum >= n) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    i = low;
    n -= (long long) (i - 1) * i * (i + 1) / 6;
    low = 1, high = i;
    while (low < high) {
        int mid = (low + high) >> 1;
        long long sum = (long long) mid * (mid + 1) / 2;
        if (sum >= n) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    j = low;
    return (i - 1) * i / 2 + j;
}
```

```JavaScript [sol2-JavaScript]
var minimumBoxes = function(n) {
    let i = 0, j = 0;
    let low = 1, high = Math.min(n, 100000);
    while (low < high) {
        const mid = (low + high) >> 1;
        const sum = mid * (mid + 1) * (mid + 2) / 6;
        if (sum >= n) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    i = low;
    n -= (i - 1) * i * (i + 1) / 6;
    low = 1;
    high = i;
    while (low < high) {
        const mid = (low + high) >> 1;
        const sum = mid * (mid + 1) / 2;
        if (sum >= n) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }
    j = low;
    return (i - 1) * i / 2 + j;
};
```

**复杂度分析**

- 时间复杂度：$O(\log n)$，其中 $n$ 是盒子数。

- 空间复杂度：$O(1)$。

#### 方法三：解方程

**思路与算法**

由方法二可知，我们要找到最小的 $i$ 满足 $g(i) \ge n$，其中 $g(i) = \frac{i \times (i + 1) \times (i + 2)}{6}$。因为有 $i^3 \lt i \times (i + 1) \times (i + 2) \lt (i + 1)^3$ 成立，
所以有 $\frac{i^3}{6} \lt g(i) \lt \frac{(i + 1)^3}{6}$。

因此，我们先求得 $i = \lfloor \sqrt[3]{6 \times n} \rfloor$，如果 $g(i) \lt n$，则将 $i$ 加一后就是我们要求的 $i$。

将 $n$ 减去 $g(i - 1)$，然后求解 $j$：

$$
f(j) = \frac{j \times (j + 1)}{2} \ge n
$$

化解后可得 $j \ge \lceil \frac{\sqrt{8\times n + 1} - 1}{2} \rceil$。

得到正确的 $i$ 和 $j$ 之后，答案为 $\frac{(i - 1) \times i}{2} + j$。

```C++ [sol3-C++]
class Solution {
public:
    int g(int x) {
        return (long long) x * (x + 1) * (x + 2) / 6;
    }

    int minimumBoxes(int n) {
        int i = pow(6.0 * n, 1.0 / 3);
        if (g(i) < n) {
            i++;
        }
        n -= g(i - 1);
        int j = ceil(1.0 * (sqrt((long long) 8 * n + 1) - 1) / 2);
        return (i - 1) * i / 2 + j;
    }
};
```

```Java [sol3-Java]
class Solution {
    public int minimumBoxes(int n) {
        int i = (int) Math.pow(6.0 * n, 1.0 / 3);
        if (g(i) < n) {
            i++;
        }
        n -= g(i - 1);
        int j = (int) Math.ceil(1.0 * (Math.sqrt((long) 8 * n + 1) - 1) / 2);
        return (i - 1) * i / 2 + j;
    }

    public long g(int x) {
        return (long) x * (x + 1) * (x + 2) / 6;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int MinimumBoxes(int n) {
        int i = (int) Math.Pow(6.0 * n, 1.0 / 3);
        if (G(i) < n) {
            i++;
        }
        n = (int) (n - G(i - 1));
        int j = (int) Math.Ceiling(1.0 * (Math.Sqrt((long) 8 * n + 1) - 1) / 2);
        return (i - 1) * i / 2 + j;
    }

    public long G(int x) {
        return (long) x * (x + 1) * (x + 2) / 6;
    }
}
```

```C [sol3-C]
int g(int x) {
    return (long long) x * (x + 1) * (x + 2) / 6;
}

int minimumBoxes(int n) {
    int i = pow(6.0 * n, 1.0 / 3);
    if (g(i) < n) {
        i++;
    }
    n -= g(i - 1);
    int j = ceil(1.0 * (sqrt((long long) 8 * n + 1) - 1) / 2);
    return (i - 1) * i / 2 + j;
}
```

```JavaScript [sol3-JavaScript]
var minimumBoxes = function(n) {
    let i = Math.floor(Math.pow(6.0 * n, 1.0 / 3));
    if (g(i) < n) {
        i++;
    }
    n -= g(i - 1);
    const j = Math.floor(Math.ceil(1.0 * (Math.sqrt(8 * n + 1) - 1) / 2));
    return (i - 1) * i / 2 + j;
}

const g = (x) => {
    return x * (x + 1) * (x + 2) / 6;
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
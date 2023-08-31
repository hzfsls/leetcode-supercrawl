## [1551.使数组中所有元素相等的最小操作数 中文官方题解](https://leetcode.cn/problems/minimum-operations-to-make-array-equal/solutions/100000/shi-shu-zu-zhong-suo-you-yuan-su-xiang-deng-de-z-4)
#### 写在前面

注意到本题给定的操作并不会使数组中所有元素之和变化，且题目要求让所有元素相等，那么数组中所有元素的平均值即为最后数组中每一个元素的值。

又题目中给定了数组中每一个元素的大小，由公式：

$$
\begin{aligned}
总和 \quad \textit{SUM} &= \sum_{i = 0}^{n - 1} 2 \times i + 1 = n \times n \\ \\
平均值 \quad \textit{AVG} &= \frac{\textit{SUM}}{n} = n
\end{aligned}
$$

可得本题数组中所有元素的平均值即为给定的 $n$。

最直接的做法是考虑每一个元素：

- 如果该元素大于平均值，则不断地将其减一，并找到一个比平均值小的数，让它加一。直到它等于平均值为止；

- 如果该元素小于平均值，则不断地将其加一，并找到一个比平均值大的数，让它减一。直到它等于平均值为止；

- 如果该元素等于平均值，则不作处理。

但是这种做法时间复杂度过高，我们考虑对其进行优化。

#### 方法一：贪心

**思路及算法**

注意到每次我们进行操作时都同时进行了「加」操作和「减」操作，这样我们只需要记录「减」操作的数量即可知道我们操作了多少次。

对于每一个大于 $n$ 的数，其与 $n$ 的差值即为该元素需要进行的「减」操作的数量。我们只要统计所有大于 $n$ 的数与 $n$ 的差值，就能计算出我们操作了多少次。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minOperations(int n) {
        int ret = 0, avg = n;
        for (int i = 0; i < n; i++) {
            int x = 2 * i + 1;
            if (x > n) {
                ret += x - n;
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minOperations(int n) {
        int ret = 0, avg = n;
        for (int i = 0; i < n; i++) {
            int x = 2 * i + 1;
            if (x > n) {
                ret += x - n;
            }
        }
        return ret;
    }
}
```

```C [sol1-C]
int minOperations(int n) {
    int ret = 0, avg = n;
    for (int i = 0; i < n; i++) {
        int x = 2 * i + 1;
        if (x > n) {
            ret += x - n;
        }
    }
    return ret;
}
```

```Python [sol1-Python3]
class Solution:
    def minOperations(self, n: int) -> int:
        return sum(x - n for i in range(n) if (x := 2 * i + 1) > n)
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(1)$。

#### 方法二：数学

**思路及算法**

由方法一中的公式，我们可以得到：

$$
\begin{aligned}
\textit{ANS} &= \sum_{i = 0}^{n - 1} \max(a_i - n, 0) \\
&= \sum_{i = 0}^{n - 1} \max(2 \times i + 1 - n, 0) \\
&= \sum_{i = \lfloor n/2 \rfloor}^{n - 1} (2 \times i + 1 - n)
\end{aligned}
$$

我们对 $n$ 分奇偶进行讨论。

- 当 $n$ 为奇数时：
  $$
  \begin{aligned}
  \textit{ANS} &= \sum_{i = \frac{n - 1}{2}}^{n - 1} (2 \times i + 1 - n) \\
  &= (1 - n) \times (n - 1 - \frac{n - 1}{2} + 1) + 2 \times \sum_{i = \frac{n - 1}{2}}^{n - 1} i \\
  &= \frac{(1 - n) \times (n + 1)}{2} + 2 \times \frac{(n + 1) \times (3 \times n - 3)}{8}\\
  &= \frac{n^2 - 1}{4}
  \end{aligned}
  $$

- 当 $n$ 为偶数时：
  $$
  \begin{aligned}
  \textit{ANS} &= \sum_{i = \frac{n}{2}}^{n - 1} (2 \times i + 1 - n) \\
  &= (1 - n) \times (n - 1 - \frac{n}{2} + 1) + 2 \times \sum_{i = \frac{n}{2}}^{n - 1} i \\
  &= \frac{(1 - n) \times n}{2} + 2 \times \frac{n \times (3 \times n - 2)}{8}\\
  &= \frac{n^2}{4}
  \end{aligned}
  $$

注意到 $\frac{n^2 - 1}{4}=\lfloor \frac{n^2}{4}\rfloor$，我们可以直接用整除来算出结果。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int minOperations(int n) {
        return n * n / 4;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int minOperations(int n) {
        return n * n / 4;
    }
}
```

```C [sol2-C]
int minOperations(int n) {
    return n * n / 4;
}
```

```Python [sol2-Python3]
class Solution:
    def minOperations(self, n: int) -> int:
        return n * n // 4
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
## [668.乘法表中第k小的数 中文官方题解](https://leetcode.cn/problems/kth-smallest-number-in-multiplication-table/solutions/100000/cheng-fa-biao-zhong-di-kxiao-de-shu-by-l-521a)

#### 方法一：二分查找

由于 $m$ 和 $n$ 很大，直接求出所有数字然后找到第 $k$ 小会超出时间限制。不妨考虑一个反向问题：对于乘法表中的数字 $x$，它是乘法表中第几小的数字？

求第几小等价于求有多少数字不超过 $x$。我们可以遍历乘法表的每一行，对于乘法表的第 $i$ 行，其数字均为 $i$ 的倍数，因此不超过 $x$ 的数字有 $\min(\Big\lfloor\dfrac{x}{i}\Big\rfloor,n)$ 个，所以整个乘法表不超过 $x$ 的数字个数为

$$
\sum_{i=1}^{m} \min(\Big\lfloor\dfrac{x}{i}\Big\rfloor,n)
$$

由于 $i\le \Big\lfloor\dfrac{x}{n}\Big\rfloor$ 时 $\Big\lfloor\dfrac{x}{i}\Big\rfloor \ge n$，上式可化简为

$$
\Big\lfloor\dfrac{x}{n}\Big\rfloor\cdot n + \sum_{i=\Big\lfloor\dfrac{x}{n}\Big\rfloor+1}^{m} \Big\lfloor\dfrac{x}{i}\Big\rfloor
$$

由于 $x$ 越大上式越大，$x$ 越小上式越小，因此我们可以二分 $x$ 找到答案，二分的初始边界为乘法表的元素范围，即 $[1,mn]$。

```Python [sol1-Python3]
class Solution:
    def findKthNumber(self, m: int, n: int, k: int) -> int:
        return bisect_left(range(m * n), k, key=lambda x: x // n * n + sum(x // i for i in range(x // n + 1, m + 1)))
```

```C++ [sol1-C++]
class Solution {
public:
    int findKthNumber(int m, int n, int k) {
        int left = 1, right = m * n;
        while (left < right) {
            int x = left + (right - left) / 2;
            int count = x / n * n;
            for (int i = x / n + 1; i <= m; ++i) {
                count += x / i;
            }
            if (count >= k) {
                right = x;
            } else {
                left = x + 1;
            }
        }
        return left;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findKthNumber(int m, int n, int k) {
        int left = 1, right = m * n;
        while (left < right) {
            int x = left + (right - left) / 2;
            int count = x / n * n;
            for (int i = x / n + 1; i <= m; ++i) {
                count += x / i;
            }
            if (count >= k) {
                right = x;
            } else {
                left = x + 1;
            }
        }
        return left;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindKthNumber(int m, int n, int k) {
        int left = 1, right = m * n;
        while (left < right) {
            int x = left + (right - left) / 2;
            int count = x / n * n;
            for (int i = x / n + 1; i <= m; ++i) {
                count += x / i;
            }
            if (count >= k) {
                right = x;
            } else {
                left = x + 1;
            }
        }
        return left;
    }
}
```

```go [sol1-Golang]
func findKthNumber(m, n, k int) int {
    return sort.Search(m*n, func(x int) bool {
        count := x / n * n
        for i := x / n + 1; i <= m; i++ {
            count += x / i
        }
        return count >= k
    })
}
```

```C [sol1-C]
int findKthNumber(int m, int n, int k){
    int left = 1, right = m * n;
    while (left < right) {
        int x = left + (right - left) / 2;
        int count = x / n * n;
        for (int i = x / n + 1; i <= m; ++i) {
            count += x / i;
        }
        if (count >= k) {
            right = x;
        } else {
            left = x + 1;
        }
    }
    return left;
}
```

```JavaScript [sol1-JavaScript]
var findKthNumber = function(m, n, k) {
    let left = 1, right = m * n;
    while (left < right) {
        const x = left + Math.floor((right - left) / 2);
        let count = Math.floor(x / n) * n;
        for (let i = Math.floor(x / n) + 1; i <= m; ++i) {
            count += Math.floor(x / i);
        }
        if (count >= k) {
            right = x;
        } else {
            left = x + 1;
        }
    }
    return left;
};
```

**复杂度分析**

- 时间复杂度：$O(m\log mn)$。二分的次数为 $O(\log mn)$，每次二分需要 $O(m)$ 的时间计算。

- 空间复杂度：$O(1)$。只需要常数的空间存放若干变量。
## [357.统计各位数字都不同的数字个数 中文官方题解](https://leetcode.cn/problems/count-numbers-with-unique-digits/solutions/100000/tong-ji-ge-wei-shu-zi-du-bu-tong-de-shu-iqbfn)

#### 方法一：排列组合

**思路**

首先考虑两种边界情况：

- 当 $n = 0$ 时，$0 \le x \lt 1$，$x$ 只有 $1$ 种选择，即 $0$。

- 当 $n = 1$ 时，$0 \le x \lt 10$，$x$ 有 $10$ 种选择，即 $0 \sim 9$。

当 $n = 2$ 时，$0 \le x \lt 100$，$x$ 的选择可以由两部分构成：只有一位数的 $x$ 和有两位数的 $x$。只有一位数的 $x$ 可以由上述的边界情况计算。有两位数的 $x$ 可以由组合数学进行计算：第一位的选择有 $9$ 种，即 $1 \sim 9$，第二位的选择也有 $9$ 种，即 $0 \sim 9$ 中除去第一位的选择。

更一般地，含有 $d$ （$2 \le d \le 10$）位数的各位数字都不同的数字 $x$ 的个数可以由公式 $9 \times A_9^{d-1}$ 计算。再加上含有小于 $d$ 位数的各位数字都不同的数字 $x$ 的个数，即可得到答案。

**代码**

```Python [sol1-Python3]
class Solution:
    def countNumbersWithUniqueDigits(self, n: int) -> int:
        if n == 0:
            return 1
        if n == 1:
            return 10
        res, cur = 10, 9
        for i in range(n - 1):
            cur *= 9 - i
            res += cur
        return res
```

```C++ [sol1-C++]
class Solution {
public:
    int countNumbersWithUniqueDigits(int n) {
        if (n == 0) {
            return 1;
        }
        if (n == 1) {
            return 10;
        }
        int ans = 10, cur = 9;
        for (int i = 0; i < n - 1; ++i) {
            cur *= 9 - i;
            ans += cur;
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countNumbersWithUniqueDigits(int n) {
        if (n == 0) {
            return 1;
        }
        if (n == 1) {
            return 10;
        }
        int res = 10, cur = 9;
        for (int i = 0; i < n - 1; i++) {
            cur *= 9 - i;
            res += cur;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountNumbersWithUniqueDigits(int n) {
        if (n == 0) {
            return 1;
        }
        if (n == 1) {
            return 10;
        }
        int res = 10, cur = 9;
        for (int i = 0; i < n - 1; i++) {
            cur *= 9 - i;
            res += cur;
        }
        return res;
    }
}
```

```go [sol1-Golang]
func countNumbersWithUniqueDigits(n int) int {
    if n == 0 {
        return 1
    }
    if n == 1 {
        return 10
    }
    ans, cur := 10, 9
    for i := 0; i < n-1; i++ {
        cur *= 9 - i
        ans += cur
    }
    return ans
}
```

```C [sol1-C]
int countNumbersWithUniqueDigits(int n) {
    if (n == 0) {
        return 1;
    }
    if (n == 1) {
        return 10;
    }
    int ans = 10, cur = 9;
    for (int i = 0; i < n - 1; ++i) {
        cur *= 9 - i;
        ans += cur;
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var countNumbersWithUniqueDigits = function(n) {
    if (n === 0) {
        return 1;
    }
    if (n === 1) {
        return 10;
    }
    let res = 10, cur = 9;
    for (let i = 0; i < n - 1; i++) {
        cur *= 9 - i;
        res += cur;
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$。仅使用一个循环。

- 空间复杂度：$O(1)$。仅使用常数空间。
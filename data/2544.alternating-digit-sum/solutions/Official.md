## [2544.交替数字和 中文官方题解](https://leetcode.cn/problems/alternating-digit-sum/solutions/100000/jiao-ti-shu-zi-he-by-leetcode-solution-uz50)

#### 方法一：数学

**思路与算法**

给你一个正整数 $n$，要求计算 $n$ 的数字交替和。

我们用 $\textit{sign}$ 来表示数字的正负，并初始化为 $1$。每一步中，我们将 $n$ 对 $10$ 取模，得到个位数字，把它和 $\textit{sign}$ 相乘求和，将 $\textit{sign}$ 取相反数，再把 $n$ 除以 $10$。 不断重复这一步骤，直到 $n$ 为零。这样我们就得到了数字交替和。

最后，因为最高有效位上的数字分配到正号，我们将结果乘以 $-\textit{sign}$ 后返回。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int alternateDigitSum(int n) {
        int res = 0, sign = 1;
        while (n > 0) {
            res += n % 10 * sign;
            sign = -sign;
            n /= 10;
        }
        return -sign * res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int alternateDigitSum(int n) {
        int res = 0, sign = 1;
        while (n > 0) {
            res += n % 10 * sign;
            sign = -sign;
            n /= 10;
        }
        return -sign * res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def alternateDigitSum(self, n: int) -> int:
        res, sign = 0, 1
        while n:
            res += n % 10 * sign
            sign = -sign
            n //= 10
        return -sign * res
```

```Go [sol1-Go]
func alternateDigitSum(n int) int {
    res, sign := 0, 1
    for n > 0 {
        res += n % 10 * sign
        sign = -sign
        n /= 10
    }
    return -sign * res
}
```

```JavaScript [sol1-JavaScript]
var alternateDigitSum = function(n) {
    let res = 0, sign = 1;
    while (n > 0) {
        res += n % 10 * sign;
        sign = -sign;
        n = Math.floor(n / 10);
    }
    return -sign * res;
};
```

```C# [sol1-C#]
public class Solution {
    public int AlternateDigitSum(int n) {
        int res = 0, sign = 1;
        while (n > 0) {
            res += n % 10 * sign;
            sign = -sign;
            n /= 10;
        }
        return res * -sign;
    }
}
```

```C [sol1-C]
int alternateDigitSum(int n){
    int res = 0, sign = 1;
    while (n > 0) {
        res += n % 10 * sign;
        sign = -sign;
        n /= 10;
    }
    return -sign * res;
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。取决于 $n$ 的数字位数。

- 空间复杂度：$O(1)$。
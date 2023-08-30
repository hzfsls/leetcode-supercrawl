#### 方法一：暴力枚举

枚举位于区间 $[1, \textit{num}]$ 内的所有正整数，如果正整数的各位数字之和为偶数，那么将结果加 $1$，最后返回结果。

```Python [sol1-Python3]
class Solution:
    def countEven(self, num: int) -> int:
        ans = 0
        for x in range(1, num + 1):
            s = 0
            while x:
                s += x % 10
                x //= 10
            ans += s % 2 == 0
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int countEven(int num) {
        int res = 0;
        for (int i = 1; i <= num; i++) {
            int x = i, sum = 0;
            while (x) {
                sum += x % 10;
                x /= 10;
            }
            if (sum % 2 == 0) {
                res++;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countEven(int num) {
        int res = 0;
        for (int i = 1; i <= num; i++) {
            int x = i, sum = 0;
            while (x != 0) {
                sum += x % 10;
                x /= 10;
            }
            if (sum % 2 == 0) {
                res++;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountEven(int num) {
        int res = 0;
        for (int i = 1; i <= num; i++) {
            int x = i, sum = 0;
            while (x != 0) {
                sum += x % 10;
                x /= 10;
            }
            if (sum % 2 == 0) {
                res++;
            }
        }
        return res;
    }
}
```

```C [sol1-C]
int countEven(int num) {
    int res = 0;
    for (int i = 1; i <= num; i++) {
        int x = i, sum = 0;
        while (x) {
            sum += x % 10;
            x /= 10;
        }
        if (sum % 2 == 0) {
            res++;
        }
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var countEven = function(num) {
    let res = 0;
    for (let i = 1; i <= num; i++) {
        let x = i, sum = 0;
        while (x !== 0) {
            sum += x % 10;
            x = Math.floor(x / 10);
        }
        if (sum % 2 === 0) {
            res++;
        }
    }
    return res;
};
```

```go [sol1-Golang]
func countEven(num int) (ans int) {
    for i := 1; i <= num; i++ {
        sum := 0
        for x := i; x > 0; x /= 10 {
            sum += x % 10
        }
        if sum%2 == 0 {
            ans++
        }
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(\textit{num} \times \log \textit{num})$。我们总共需要枚举 $\textit{num}$ 个正整数，而判断每个正整数的各位数字之和是否为偶数需要 $O(\log \textit{num})$ 的时间复杂度。

+ 空间复杂度：$O(1)$。

#### 方法二：数学

首先有两个简单的数学结论：

+ 给定 $0 \le x \lt 10$，位于区间 $[0, x]$ 内的偶数个数为 $\left\lfloor \dfrac{x}{2} \right\rfloor + 1$，位于区间 $[0, x]$ 内的奇数个数为 $\left\lceil \dfrac{x}{2} \right\rceil$。

+ 位于区间 $[0, 10)$ 的奇数和偶数的个数都是 $5$ 个。

我们将 $\textit{num}$ 表示为 $10 \times y + x$ 的形式，其中 $0 \le x \lt 10$ 且 $y \ge 0$，那么位于区间 $[0, \textit{num}]$ 的整数可以分为两个部分：

+ 区间 $[10 \times y + 0, 10 \times y + x]$：

    - 如果 $y$ 的各位数字之和为偶数，那么该区间内各位数字之和为偶数的整数个数为 $\left\lfloor \dfrac{x}{2} \right\rfloor + 1$；

    - 如果 $y$ 的各位数字之和为奇数，那么该区间内各位数字之和为偶数的整数个数为 $\left\lceil \dfrac{x}{2} \right\rceil$。

+ 区间 $[0, 10 \times y + 0)$：

    注意到该区间的数可以表示为 $10 \times t + g$ 的形式，其中 $0 \le t \lt y$ 且 $0 \le g \lt 10$。固定住 $t$ 时，如果 $t$ 的各位数字之和为偶数，那么 $g$ 为偶数的取值数目为 $5$，奇数时类似，因此该区间内的各位数字之和为偶数的整数个数为 $y \times 5$。

注意到上述区间中我们多计入了整数 $0$，因此结果应该是位于上述区间且各位数字之和为偶数的个数减 $1$。

```Python [sol2-Python3]
class Solution:
    def countEven(self, num: int) -> int:
        y, x = divmod(num, 10)
        ans = y * 5
        y_sum = 0
        while y:
            y_sum += y % 10
            y //= 10
        return ans + ((x + 1) // 2 - 1 if y_sum % 2 else x // 2)
```

```C++ [sol2-C++]
class Solution {
public:
    int countEven(int num) {
        int y = num / 10, x = num % 10;
        int res = y * 5, ySum = 0;
        while (y) {
            ySum += y % 10;
            y /= 10;
        }
        if (ySum % 2 == 0) {
            res += x / 2 + 1;
        } else {
            res += (x + 1) / 2;
        }
        return res - 1;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int countEven(int num) {
        int y = num / 10, x = num % 10;
        int res = y * 5, ySum = 0;
        while (y != 0) {
            ySum += y % 10;
            y /= 10;
        }
        if (ySum % 2 == 0) {
            res += x / 2 + 1;
        } else {
            res += (x + 1) / 2;
        }
        return res - 1;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int CountEven(int num) {
        int y = num / 10, x = num % 10;
        int res = y * 5, ySum = 0;
        while (y != 0) {
            ySum += y % 10;
            y /= 10;
        }
        if (ySum % 2 == 0) {
            res += x / 2 + 1;
        } else {
            res += (x + 1) / 2;
        }
        return res - 1;
    }
}
```

```C [sol2-C]
int countEven(int num) {
    int y = num / 10, x = num % 10;
    int res = y * 5, ySum = 0;
    while (y) {
        ySum += y % 10;
        y /= 10;
    }
    if (ySum % 2 == 0) {
        res += x / 2 + 1;
    } else {
        res += (x + 1) / 2;
    }
    return res - 1;
}
```

```JavaScript [sol2-JavaScript]
var countEven = function(num) {
    let y = Math.floor(num / 10), x = num % 10;
    let res = y * 5, ySum = 0;
    while (y !== 0) {
        ySum += y % 10;
        y = Math.floor(y / 10);
    }
    if (ySum % 2 === 0) {
        res += Math.floor(x / 2) + 1;
    } else {
        res += Math.floor((x + 1) / 2);
    }
    return res - 1;
};
```

```go [sol2-Golang]
func countEven(num int) int {
    y, x := num/10, num%10
    ans := y * 5
    ySum := 0
    for ; y > 0; y /= 10 {
        ySum += y % 10
    }
    if ySum%2 == 0 {
        ans += x / 2
    } else {
        ans += (x+1)/2 - 1
    }
    return ans
}
```

**复杂度分析**

+ 时间复杂度：$O(\log \textit{num})$。

+ 空间复杂度：$O(1)$。
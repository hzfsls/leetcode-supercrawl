## [258.各位相加 中文官方题解](https://leetcode.cn/problems/add-digits/solutions/100000/ge-wei-xiang-jia-by-leetcode-solution-u4kj)

#### 前言

这道题的本质是计算自然数 $\textit{num}$ 的数根。

数根又称数字根（$\text{Digital root}$），是自然数的一种性质，每个自然数都有一个数根。对于给定的自然数，反复将各个位上的数字相加，直到结果为一位数，则该一位数即为原自然数的数根。

计算数根的最直观的方法是模拟计算各位相加的过程，直到剩下的数字是一位数。利用自然数的性质，则能在 $O(1)$ 的时间内计算数根。

#### 方法一：模拟

**思路和算法**

最直观的方法是模拟各位相加的过程，直到剩下的数字是一位数。

计算一个整数的各位相加的做法是，每次计算当前整数除以 $10$ 的余数得到最低位数，将最低位数加到总和中，然后将当前整数除以 $10$。重复上述操作直到当前整数变成 $0$，此时的总和即为原整数各位相加的结果。

**代码**

```Java [sol1-Java]
class Solution {
    public int addDigits(int num) {
        while (num >= 10) {
            int sum = 0;
            while (num > 0) {
                sum += num % 10;
                num /= 10;
            }
            num = sum;
        }
        return num;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int AddDigits(int num) {
        while (num >= 10) {
            int sum = 0;
            while (num > 0) {
                sum += num % 10;
                num /= 10;
            }
            num = sum;
        }
        return num;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int addDigits(int num) {
        while (num >= 10) {
            int sum = 0;
            while (num > 0) {
                sum += num % 10;
                num /= 10;
            }
            num = sum;
        }
        return num;
    }
};
```

```C [sol1-C]
int addDigits(int num){
    while (num >= 10) {
        int sum = 0;
        while (num > 0) {
            sum += num % 10;
            num /= 10;
        }
        num = sum;
    }
    return num;
}
```

```JavaScript [sol1-JavaScript]
var addDigits = function(num) {
    while (num >= 10) {
        let sum = 0;
        while (num > 0) {
            sum += num % 10;
            num = Math.floor(num / 10);
        }
        num = sum;
    }
    return num;
};
```

```Python [sol1-Python3]
class Solution:
    def addDigits(self, num: int) -> int:
        while num >= 10:
            sum = 0
            while num:
                sum += num % 10
                num //= 10
            num = sum
        return num
```

```go [sol1-Golang]
func addDigits(num int) int {
    for num >= 10 {
        sum := 0
        for ; num > 0; num /= 10 {
            sum += num % 10
        }
        num = sum
    }
    return num
}
```

**复杂度分析**

- 时间复杂度：$O(\log \textit{num})$，其中 $\textit{num}$ 是给定的整数。对于 $\textit{num}$ 计算一次各位相加需要 $O(\log \textit{num})$ 的时间，由于 $\textit{num} \le 2^{31} - 1$，因此对于 $\textit{num}$ 计算一次各位相加的最大可能结果是 $82$，对于任意两位数最多只需要计算两次各位相加的结果即可得到一位数。

- 空间复杂度：$O(1)$。

#### 方法二：数学

**思路和算法**

假设整数 $\textit{num}$ 的十进制表示有 $n$ 位，从最低位到最高位依次是 $a_0$ 到 $a_{n - 1}$，则 $\textit{num}$ 可以写成如下形式：

$$
\begin{aligned}
\textit{num} &= \sum_{i = 0}^{n - 1} a_i \times 10^i \\
&= \sum_{i = 0}^{n - 1} a_i \times (10^i - 1 + 1) \\
&= \sum_{i = 0}^{n - 1} a_i \times (10^i - 1) + \sum_{i = 0}^{n - 1} a_i
\end{aligned}
$$

当 $i = 0$ 时，$10^i - 1 = 0$ 是 $9$ 的倍数；当 $i$ 是正整数时，$10^i - 1$ 是由 $i$ 位 $9$ 组成的整数，也是 $9$ 的倍数。因此对于任意非负整数 $i$，$10^i - 1$ 都是 $9$ 的倍数。由此可得 $\textit{num}$ 与其各位相加的结果模 $9$ 同余。重复计算各位相加的结果直到结果为一位数时，该一位数即为 $\textit{num}$ 的数根，$\textit{num}$ 与其数根模 $9$ 同余。

我们对 $\textit{num}$ 分类讨论：

- $\textit{num}$ 不是 $9$ 的倍数时，其数根即为 $\textit{num}$ 除以 $9$ 的余数。

- $\textit{num}$ 是 $9$ 的倍数时：

  - 如果 $\textit{num} = 0$，则其数根是 $0$；

  - 如果 $\textit{num} > 0$，则各位相加的结果大于 $0$，其数根也大于 $0$，因此其数根是 $9$。

**细节**

根据上述分析可知，当 $\textit{num} > 0$ 时，其数根的结果在范围 $[1, 9]$ 内，因此可以想到计算 $\textit{num} - 1$ 除以 $9$ 的余数然后加 $1$。由于当 $\textit{num} > 0$ 时，$\textit{num} - 1 \ge 0$，非负数除以 $9$ 的余数一定也是非负数，因此计算 $\textit{num} - 1$ 除以 $9$ 的余数然后加 $1$ 的结果是正确的。

当 $\textit{num} = 0$ 时，$\textit{num} - 1 = -1 < 0$，负数对 $9$ 取余或取模的结果的正负在不同语言中有所不同。

- 对于取余的语言，结果的正负和左操作数相同，则 $\textit{num} - 1$ 对 $9$ 取余的结果为 $-1$，加 $1$ 后得到结果 $0$，可以得到正确的结果；

- 对于取模的语言，结果的正负和右操作数相同，则 $\textit{num} - 1$ 对 $9$ 取模的结果为 $8$，加 $1$ 后得到结果 $9$，无法得到正确的结果，此时需要对 $\textit{num} = 0$ 的情况专门做处理。

**代码**

```Java [sol2-Java]
class Solution {
    public int addDigits(int num) {
        return (num - 1) % 9 + 1;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int AddDigits(int num) {
        return (num - 1) % 9 + 1;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int addDigits(int num) {
        return (num - 1) % 9 + 1;
    }
};
```

```C [sol2-C]
int addDigits(int num){
    return (num - 1) % 9 + 1;
}
```

```JavaScript [sol2-JavaScript]
var addDigits = function(num) {
    return (num - 1) % 9 + 1;
};
```

```Python [sol2-Python3]
class Solution:
    def addDigits(self, num: int) -> int:
        return (num - 1) % 9 + 1 if num else 0
```

```go [sol2-Golang]
func addDigits(num int) int {
    return (num-1)%9 + 1
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。
## [231.2 的幂 中文官方题解](https://leetcode.cn/problems/power-of-two/solutions/100000/2de-mi-by-leetcode-solution-rny3)
#### 方法一：二进制表示

**思路与算法**

一个数 $n$ 是 $2$ 的幂，当且仅当 $n$ 是正整数，并且 $n$ 的二进制表示中仅包含 $1$ 个 $1$。

因此我们可以考虑使用位运算，将 $n$ 的二进制表示中最低位的那个 $1$ 提取出来，再判断剩余的数值是否为 $0$ 即可。下面介绍两种常见的与「二进制表示中最低位」相关的位运算技巧。

第一个技巧是

$$
\texttt{n \& (n - 1)}
$$

其中 $\texttt{\&}$ 表示按位与运算。该位运算技巧可以直接将 $n$ 二进制表示的最低位 $1$ 移除，它的原理如下：

> 假设 $n$ 的二进制表示为 $(a 10\cdots 0)_2$，其中 $a$ 表示若干个高位，$1$ 表示最低位的那个 $1$，$0\cdots 0$ 表示后面的若干个 $0$，那么 $n-1$ 的二进制表示为：
>
> $$
> (a 01\cdots1)_2
> $$
>
> 我们将 $(a 10\cdots 0)_2$ 与 $(a 01\cdots1)_2$ 进行按位与运算，高位 $a$ 不变，在这之后的所有位都会变为 $0$，这样我们就将最低位的那个 $1$ 移除了。

因此，如果 $n$ 是正整数并且 $\texttt{n \& (n - 1) = 0}$，那么 $n$ 就是 $2$ 的幂。

第二个技巧是

$$
\texttt{n \& (-n)}
$$

其中 $-n$ 是 $n$ 的相反数，是一个负数。该位运算技巧可以直接获取 $n$ 二进制表示的最低位的 $1$。

由于负数是按照补码规则在计算机中存储的，$-n$ 的二进制表示为 $n$ 的二进制表示的每一位取反再加上 $1$，因此它的原理如下：

> 假设 $n$ 的二进制表示为 $(a 10\cdots 0)_2$，其中 $a$ 表示若干个高位，$1$ 表示最低位的那个 $1$，$0\cdots 0$ 表示后面的若干个 $0$，那么 $-n$ 的二进制表示为：
>
> $$
> (\bar{a} 01\cdots1)_2 + (1)_2 = (\bar{a} 10\cdots0)_2
> $$
>
> 其中 $\bar{a}$ 表示将 $a$ 每一位取反。我们将 $(a 10\cdots 0)_2$ 与 $(\bar{a} 10\cdots0)_2$ 进行按位与运算，高位全部变为 $0$，最低位的 $1$ 以及之后的所有 $0$ 不变，这样我们就获取了 $n$ 二进制表示的最低位的 $1$。

因此，如果 $n$ 是正整数并且 $\texttt{n \& (-n) = n}$，那么 $n$ 就是 $2$ 的幂。

**代码**

下面分别给出两种位运算技巧对应的代码。
**在一些语言中，位运算的优先级较低，需要注意运算顺序**。

```C++ [sol11-C++]
class Solution {
public:
    bool isPowerOfTwo(int n) {
        return n > 0 && (n & (n - 1)) == 0;
    }
};
```

```Java [sol11-Java]
class Solution {
    public boolean isPowerOfTwo(int n) {
        return n > 0 && (n & (n - 1)) == 0;
    }
}
```

```C# [sol11-C#]
public class Solution {
    public bool IsPowerOfTwo(int n) {
        return n > 0 && (n & (n - 1)) == 0;
    }
}
```

```Python [sol11-Python3]
class Solution:
    def isPowerOfTwo(self, n: int) -> bool:
        return n > 0 and (n & (n - 1)) == 0
```

```JavaScript [sol11-JavaScript]
var isPowerOfTwo = function(n) {
    return n > 0 && (n & (n - 1)) === 0;
};
```

```go [sol11-Golang]
func isPowerOfTwo(n int) bool {
    return n > 0 && n&(n-1) == 0
}
```

```C [sol11-C]
bool isPowerOfTwo(int n) {
    return n > 0 && (n & (n - 1)) == 0;
}
```

```C++ [sol12-C++]
class Solution {
public:
    bool isPowerOfTwo(int n) {
        return n > 0 && (n & -n) == n;
    }
};
```

```Java [sol12-Java]
class Solution {
    public boolean isPowerOfTwo(int n) {
        return n > 0 && (n & -n) == n;
    }
}
```

```C# [sol12-C#]
public class Solution {
    public bool IsPowerOfTwo(int n) {
        return n > 0 && (n & -n) == n;
    }
}
```

```Python [sol12-Python3]
class Solution:
    def isPowerOfTwo(self, n: int) -> bool:
        return n > 0 and (n & -n) == n
```

```JavaScript [sol12-JavaScript]
var isPowerOfTwo = function(n) {
    return n > 0 && (n & -n) === n;
};
```

```go [sol12-Golang]
func isPowerOfTwo(n int) bool {
    return n > 0 && n&-n == n
}
```

```C [sol12-C]
bool isPowerOfTwo(int n) {
    return n > 0 && (n & -n) == n;
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。

#### 方法二：判断是否为最大 $2$ 的幂的约数

**思路与算法**

除了使用二进制表示判断之外，还有一种较为取巧的做法。

在题目给定的 $32$ 位有符号整数的范围内，最大的 $2$ 的幂为 $2^{30} = 1073741824$。我们只需要判断 $n$ 是否是 $2^{30}$ 的约数即可。

**代码**

```C++ [sol2-C++]
class Solution {
private:
    static constexpr int BIG = 1 << 30;

public:
    bool isPowerOfTwo(int n) {
        return n > 0 && BIG % n == 0;
    }
};
```

```Java [sol2-Java]
class Solution {
    static final int BIG = 1 << 30;

    public boolean isPowerOfTwo(int n) {
        return n > 0 && BIG % n == 0;
    }
}
```

```C# [sol2-C#]
public class Solution {
    const int BIG = 1 << 30;

    public bool IsPowerOfTwo(int n) {
        return n > 0 && BIG % n == 0;
    }
}
```

```Python [sol2-Python3]
class Solution:

    BIG = 2**30

    def isPowerOfTwo(self, n: int) -> bool:
        return n > 0 and Solution.BIG % n == 0
```

```JavaScript [sol2-JavaScript]
var isPowerOfTwo = function(n) {
    const BIG = 1 << 30;
    return n > 0 && BIG % n === 0;
};
```

```go [sol2-Golang]
func isPowerOfTwo(n int) bool {
    const big = 1 << 30
    return n > 0 && big%n == 0
}
```

```C [sol2-C]
const int BIG = 1 << 30;

bool isPowerOfTwo(int n) {
    return n > 0 && BIG % n == 0;
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。

- 空间复杂度：$O(1)$。


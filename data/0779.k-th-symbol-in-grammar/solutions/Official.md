#### 方法一：递归

**思路与算法**

首先题目给出一个 $n$ 行的表（索引从 $1$ 开始）。并给出表的构造规则为：第一行仅有一个 $0$，然后接下来的每一行可以由上一行中 $0$ 替换为 $01$，$1$ 替换为 $10$ 来生成。

- 比如当 $n = 3$ 时，第 $1$ 行是 $0$，第 $2$ 行是 $01$，第 $3$ 行是 $0110$。

现在要求表第 $n$ 行中第 $k$ 个数字，$1 \le k \le 2 ^ n$。首先我们可以看到第 $i$ 行中会有 $2^{i-1}$ 个数字，$1 \le i \le n$，且其中第 $j$ 个数字按照构造规则会生第 $i + 1$ 行中的第 $2*j - 1$ 和 $2*j$ 个数字，$1 \le j \le 2^{i-1}$。即对于第 $i + 1$ 行中的第 $x$ 个数字 $\textit{num}_1$，$1 \le x \le 2^i$，会被第 $i$ 行中第 $\lfloor \frac{x + 1}{2} \rfloor$ 个数字 $\textit{num}_2$ 生成。且满足规则：

- 当 $\textit{num}_2 = 0$ 时，$\textit{num}_2$ 会生成 $01$：

$$
\textit{num}_1 = \begin{cases}
0, & x \equiv 1 \pmod{2} \\
1, & x \equiv 0 \pmod{2} \\
\end{cases}
$$

- 当 $num_2 = 1$ 时，$\textit{num}_2$ 会生成 $10$：

$$
\textit{num}_1 = \begin{cases}
1, & x \equiv 1 \pmod{2} \\
0, & x \equiv 0 \pmod{2} \\
\end{cases}
$$

并且进一步总结我们可以得到：$\textit{num}_1 = (x \And 1) \oplus 1 \oplus \textit{num}_2$，其中 $\And$ 为「与」运算符， $\oplus$ 为「异或」运算符。那么我们从第 $n$ 不断往上递归求解，并且当在第一行时只有一个数字，直接返回 $0$ 即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def kthGrammar(self, n: int, k: int) -> int:
        if n == 1:
            return 0
        return (k & 1) ^ 1 ^ self.kthGrammar(n - 1, (k + 1) // 2)
```

```Java [sol1-Java]
class Solution {
    public int kthGrammar(int n, int k) {
        if (n == 1) {
            return 0;
        }
        return (k & 1) ^ 1 ^ kthGrammar(n - 1, (k + 1) / 2);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int KthGrammar(int n, int k) {
        if (n == 1) {
            return 0;
        }
        return (k & 1) ^ 1 ^ KthGrammar(n - 1, (k + 1) / 2);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int kthGrammar(int n, int k) {
        if (n == 1) {
            return 0;
        }
        return (k & 1) ^ 1 ^ kthGrammar(n - 1, (k + 1) / 2);
    }
};
```

```C [sol1-C]
int kthGrammar(int n, int k){
    if (n == 1) {
        return 0;
    }
    return (k & 1) ^ 1 ^ kthGrammar(n - 1, (k + 1) / 2);
}
```

```JavaScript [sol1-JavaScript]
var kthGrammar = function(n, k) {
    if (n === 1) {
        return 0;
    }
    return (k & 1) ^ 1 ^ kthGrammar(n - 1, (k + 1) / 2);
};
```

```go [sol1-Golang]
func kthGrammar(n, k int) int {
    if n == 1 {
        return 0
    }
    return k&1 ^ 1 ^ kthGrammar(n-1, (k+1)/2)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为题目给定表的行数，递归深度为 $n$。
- 空间复杂度：$O(n)$，其中 $n$ 为题目给定表的行数，主要为递归的空间开销。

#### 方法二：找规律 + 递归

**思路与算法**

按照方法一，我们可以尝试写表中的前几行：

- $0$
- $01$
- $0110$
- $01101001$
- $\cdots$

我们可以注意到规律：每一行的后半部分正好为前半部分的“翻转”——前半部分是 $0$ 后半部分变为 $1$，前半部分是 $1$，后半部分变为 $0$。且每一行的前半部分和上一行相同。我们可以通过「数学归纳法」来进行证明。

有了这个性质，那么我们再次思考原问题：对于查询某一个行第 $k$ 个数字，如果 $k$ 在后半部分，那么原问题就可以转化为求解该行前半部分的对应位置的“翻转”数字，又因为该行前半部分与上一行相同，所以又转化为上一行对应对应的“翻转”数字。那么按照这样一直递归下去，并在第一行时返回数字 $0$ 即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def kthGrammar(self, n: int, k: int) -> int:
        if k == 1:
            return 0
        if k > (1 << (n - 2)):
            return 1 ^ self.kthGrammar(n - 1, k - (1 << (n - 2)))
        return self.kthGrammar(n - 1, k)
```

```Java [sol2-Java]
class Solution {
    public int kthGrammar(int n, int k) {
        if (k == 1) {
            return 0;
        }
        if (k > (1 << (n - 2))) {
            return 1 ^ kthGrammar(n - 1, k - (1 << (n - 2)));
        }
        return kthGrammar(n - 1, k);
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int KthGrammar(int n, int k) {
        if (k == 1) {
            return 0;
        }
        if (k > (1 << (n - 2))) {
            return 1 ^ KthGrammar(n - 1, k - (1 << (n - 2)));
        }
        return KthGrammar(n - 1, k);
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int kthGrammar(int n, int k) {
        if (k == 1) {
            return 0;
        }
        if (k > (1 << (n - 2))) {
            return 1 ^ kthGrammar(n - 1, k - (1 << (n - 2)));
        }
        return kthGrammar(n - 1, k);
    }
};
```

```C [sol2-C]
int kthGrammar(int n, int k){
    if (k == 1) {
        return 0;
    }
    if (k > (1 << (n - 2))) {
        return 1 ^ kthGrammar(n - 1, k - (1 << (n - 2)));
    }
    return kthGrammar(n - 1, k);
}
```

```JavaScript [sol2-JavaScript]
var kthGrammar = function(n, k) {
    if (k === 1) {
        return 0;
    }
    if (k > (1 << (n - 2))) {
        return 1 ^ kthGrammar(n - 1, k - (1 << (n - 2)));
    }
    return kthGrammar(n - 1, k);
};
```

```go [sol2-Golang]
func kthGrammar(n, k int) int {
    if k == 1 {
        return 0
    }
    if k > 1<<(n-2) {
        return 1 ^ kthGrammar(n-1, k-1<<(n-2))
    }
    return kthGrammar(n-1, k)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为题目给定表的行数。
- 空间复杂度：$O(n)$，其中 $n$ 为题目给定表的行数，主要为递归的空间开销。

#### 方法三：找规律 + 位运算

**思路与算法**

在「方法二」的基础上，我们来进行优化，本质上我们其实只需要求在过程中的“翻转”总次数，如果“翻转”为偶数次则原问题求解为 $0$，否则为 $1$。

首先我们修改行的索引从 $0$ 开始，此时原先第 $p$ 行的索引现在为 $p - 1$ 行，第 $i$ 行有 $2 ^ i$ 位。那么对于某一行 $i$ 中下标为 $x$ 的数字，如果 $x < 2^{i - 1}$ 那么等价于求 $i - 1$ 中下标为 $x$ 的数字，否则 $x$ 的二进制位的从右往左第 $i + 1$ 位为 $1$，此时需要减去该位（“翻转”一次），然后递归求解即可。所以我们可以看到最后“翻转”的总次数只和初始状态下的下标 $x$ 二进制表示中 $1$ 的个数有关。因此原问题中求“翻转”的总次数就等价于求 $k - 1$ 的二进制表示中 $1$ 的个数，求解方法具体可以参考题库题目[「191. 位1的个数」的官方题解](https://leetcode.cn/problems/number-of-1-bits/solution/wei-1de-ge-shu-by-leetcode-solution-jnwf/) 来更进一步学习求解。

**代码**

```Python [sol3-Python3]
class Solution:
    def kthGrammar(self, n: int, k: int) -> int:
        # return (k - 1).bit_count() & 1
        k -= 1
        res = 0
        while k:
            k &= k - 1
            res ^= 1
        return res
```

```Java [sol3-Java]
class Solution {
    public int kthGrammar(int n, int k) {
        // return Integer.bitCount(k - 1) & 1;
        k--;
        int res = 0;
        while (k > 0) {
            k &= k - 1;
            res ^= 1;
        }
        return res;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int KthGrammar(int n, int k) {
        k--;
        int res = 0;
        while (k > 0) {
            k &= k - 1;
            res ^= 1;
        }
        return res;
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    int kthGrammar(int n, int k) {
        // return __builtin_popcount(k - 1) & 1;
        k--;
        int res = 0;
        while (k > 0) {
            k &= k - 1;
            res ^= 1;
        }
        return res;
    }
};
```

```C [sol3-C]
int kthGrammar(int n, int k){
    k--;
    int res = 0;
    while (k > 0) {
        k &= k - 1;
        res ^= 1;
    }
    return res;
}
```

```JavaScript [sol3-JavaScript]
var kthGrammar = function(n, k) {
    k--;
    let res = 0;
    while (k > 0) {
        k &= k - 1;
        res ^= 1;
    }
    return res;
};
```

```go [sol3-Golang]
func kthGrammar(n, k int) (ans int) {
    // return bits.OnesCount(uint(k-1)) & 1
    for k--; k > 0; k &= k - 1 {
        ans ^= 1
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(\log k)$，其中 $k$ 为题目给定查询的下标。
- 空间复杂度：$O(1)$，仅使用常量变量。
#### 前言

本题是「[91. 解码方法](https://leetcode-cn.com/problems/decode-ways/)」的进阶题目。

#### 方法一：动态规划

**思路与算法**

对于给定的字符串 $s$，设它的长度为 $n$，其中的字符从左到右依次为 $s[1], s[2], \cdots, s[n]$。我们可以使用动态规划的方法计算出字符串 $s$ 的解码方法数。

具体地，设 $f_i$ 表示字符串 $s$ 的前 $i$ 个字符 $s[1..i]$ 的解码方法数。在进行状态转移时，我们可以考虑最后一次解码使用了 $s$ 中的哪些字符，那么会有下面的两种情况：

- 第一种情况是我们使用了一个字符，即 $s[i]$ 进行解码，那么：

    - 如果 $s[i]$ 为 $*$，那么它对应着 $[1, 9]$ 中的任意一种编码，有 $9$ 种方案。因此状态转移方程为：

    $$
    f_i = 9 \times f_{i-1}
    $$

    - 如果 $s[i]$ 为 $0$，那么它无法被解码。因此状态转移方程为：

    $$
    f_i = 0
    $$

    - 对于其它的情况，$s[i] \in [1, 9]$，分别对应一种编码。因此状态转移方程为：
    
    $$
    f_i = f_{i-1}
    $$

- 第二种情况是我们使用了两个字符，即 $s[i-1]$ 和 $s[i]$ 进行编码。与第一种情况类似，我们需要进行分类讨论：

    - 如果 $s[i-1]$ 和 $s[i]$ 均为 $*$，那么它们对应着 $[11,19]$ 以及 $[21, 26]$ 中的任意一种编码，有 $15$ 种方案。因此状态转移方程为：

    $$
    f_i = 15 \times f_{i-2}
    $$

    - 如果仅有 $s[i-1]$ 为 $*$，那么当 $s[i] \in [0, 6]$ 时，$s[i-1]$ 可以选择 $1$ 和 $2$；当 $s[i] \in [7, 9]$ 时，$s[i-1]$ 只能选择 $1$。因此状态转移方程为：

    $$
    f_i = \begin{cases}
    2 \times f_{i-2}, & \quad s[i-1] \in [1, 6] \\
    f_{i-2}, & \quad s[i-1] \in [7, 9]
    \end{cases}
    $$

    - 如果仅有 $s[i]$ 为 $*$，那么当 $s[i-1]$ 为 $1$ 时，$s[i]$ 可以在 $[1, 9]$ 中进行选择；当 $s[i-1]$ 为 $2$ 时，$s[i]$ 可以在 $[1, 6]$ 中进行选择；对于其余情况，它们无法被解码。因此状态转移方程为：

    $$
    f_i = \begin{cases}
    9 \times f_{i-2}, & \quad s[i] = 1 \\
    6 \times f_{i-2}, & \quad s[i] = 2 \\
    0, & \quad \text{otherwise}
    \end{cases}
    $$

    - 如果 $s[i-1]$ 和 $s[i]$ 均不为 $*$，那么只有 $s[i-1]$ 不为 $0$ 并且 $s[i-1]$ 和 $s[i]$ 组成的数字小于等于 $26$ 时，它们才能被解码。因此状态转移方程为：

    $$
    f_i = \begin{cases}
    f_{i-2}, & \quad s[i-1] \neq 0 \wedge \overline{s[i-1]s[i]} \leq 26 \\
    0, & \quad \text{otherwise}
    \end{cases}
    $$

将上面的两种状态转移方程在对应的条件满足时进行累加，即可得到 $f_i$ 的值。在动态规划完成后，最终的答案即为 $f_n$。

**细节**

动态规划的边界条件为：

$$
f_0 = 1
$$

即**空字符串可以有 $1$ 种解码方法，解码出一个空字符串**。

同时，由于在大部分语言中，字符串的下标是从 $0$ 而不是 $1$ 开始的，因此在代码的编写过程中，我们需要将所有字符串的下标减去 $1$，与使用的语言保持一致。

最终的状态转移方程可以写成：

$$
f_i = \alpha \times f_{i-1} + \beta \times f_{i-2}
$$

的形式。为了使得代码更加易读，我们可以使用两个辅助函数，给定对应的一个或两个字符，分别计算出 $\alpha$ 和 $\beta$ 的值。

注意到在状态转移方程中，$f_i$ 的值仅与 $f_{i-1}$ 和 $f_{i-2}$ 有关，因此我们可以使用三个变量进行状态转移，省去数组的空间。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    static constexpr int mod = 1000000007;

public:
    int numDecodings(string s) {
        auto check1digit = [](char ch) -> int {
            if (ch == '0') {
                return 0;
            }
            return ch == '*' ? 9 : 1;
        };

        auto check2digits = [](char c0, char c1) -> int {
            if (c0 == '*' && c1 == '*') {
                return 15;
            }
            if (c0 == '*') {
                return c1 <= '6' ? 2 : 1;
            }
            if (c1 == '*') {
                if (c0 == '1') {
                    return 9;
                }
                if (c0 == '2') {
                    return 6;
                }
                return 0;
            }
            return c0 != '0' && (c0 - '0') * 10 + (c1 - '0') <= 26;
        };

        int n = s.size();
        // a = f[i-2], b = f[i-1], c = f[i]
        int a = 0, b = 1, c = 0;
        for (int i = 1; i <= n; ++i) {
            c = (long long)b * check1digit(s[i - 1]) % mod;
            if (i > 1) {
                c = (c + (long long)a * check2digits(s[i - 2], s[i - 1])) % mod;
            }
            a = b;
            b = c;
        }
        return c;
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int MOD = 1000000007;

    public int numDecodings(String s) {
        int n = s.length();
        // a = f[i-2], b = f[i-1], c = f[i]
        long a = 0, b = 1, c = 0;
        for (int i = 1; i <= n; ++i) {
            c = b * check1digit(s.charAt(i - 1)) % MOD;
            if (i > 1) {
                c = (c + a * check2digits(s.charAt(i - 2), s.charAt(i - 1))) % MOD;
            }
            a = b;
            b = c;
        }
        return (int) c;
    }

    public int check1digit(char ch) {
        if (ch == '0') {
            return 0;
        }
        return ch == '*' ? 9 : 1;
    }

    public int check2digits(char c0, char c1) {
        if (c0 == '*' && c1 == '*') {
            return 15;
        }
        if (c0 == '*') {
            return c1 <= '6' ? 2 : 1;
        }
        if (c1 == '*') {
            if (c0 == '1') {
                return 9;
            }
            if (c0 == '2') {
                return 6;
            }
            return 0;
        }
        return (c0 != '0' && (c0 - '0') * 10 + (c1 - '0') <= 26) ? 1 : 0;
    }
}
```

```C# [sol1-C#]
public class Solution {
    const int MOD = 1000000007;

    public int NumDecodings(string s) {
        int n = s.Length;
        // a = f[i-2], b = f[i-1], c = f[i]
        long a = 0, b = 1, c = 0;
        for (int i = 1; i <= n; ++i) {
            c = b * Check1digit(s[i - 1]) % MOD;
            if (i > 1) {
                c = (c + a * Check2digits(s[i - 2], s[i - 1])) % MOD;
            }
            a = b;
            b = c;
        }
        return (int) c;
    }

    public int Check1digit(char ch) {
        if (ch == '0') {
            return 0;
        }
        return ch == '*' ? 9 : 1;
    }

    public int Check2digits(char c0, char c1) {
        if (c0 == '*' && c1 == '*') {
            return 15;
        }
        if (c0 == '*') {
            return c1 <= '6' ? 2 : 1;
        }
        if (c1 == '*') {
            if (c0 == '1') {
                return 9;
            }
            if (c0 == '2') {
                return 6;
            }
            return 0;
        }
        return (c0 != '0' && (c0 - '0') * 10 + (c1 - '0') <= 26) ? 1 : 0;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def numDecodings(self, s: str) -> int:
        mod = 10**9 + 7
        
        def check1digit(ch: str) -> int:
            if ch == "0":
                return 0
            return 9 if ch == "*" else 1
        
        def check2digits(c0: str, c1: str) -> int:
            if c0 == c1 == "*":
                return 15
            if c0 == "*":
                return 2 if c1 <= "6" else 1
            if c1 == "*":
                return 9 if c0 == "1" else (6 if c0 == "2" else 0)
            return int(c0 != "0" and int(c0) * 10 + int(c1) <= 26)

        n = len(s)
        # a = f[i-2], b = f[i-1], c = f[i]
        a, b, c = 0, 1, 0
        for i in range(1, n + 1):
            c = b * check1digit(s[i - 1])
            if i > 1:
                c += a * check2digits(s[i - 2], s[i - 1])
            c %= mod
            a = b
            b = c
        
        return c
```

```JavaScript [sol1-JavaScript]
var numDecodings = function(s) {
    const MOD = 1000000007;
    const n = s.length;
    // a = f[i-2], b = f[i-1], c = f[i]
    let a = 0, b = 1, c = 0;
    for (let i = 1; i <= n; ++i) {
        c = b * check1digit(s[i - 1]) % MOD;
        if (i > 1) {
            c = (c + a * check2digits(s[i - 2], s[i - 1])) % MOD;
        }
        a = b;
        b = c;
    }
    return c;
}

const check1digit = (ch) => {
    if (ch === '0') {
        return 0;
    }
    return ch === '*' ? 9 : 1;
}

const check2digits = (c0, c1) => {
    if (c0 === '*' && c1 === '*') {
        return 15;
    }
    if (c0 === '*') {
        return c1.charCodeAt() <= '6'.charCodeAt() ? 2 : 1;
    }
    if (c1 === '*') {
        if (c0 === '1') {
            return 9;
        }
        if (c0 === '2') {
            return 6;
        }
        return 0;
    }
    return (c0 !== '0' && (c0.charCodeAt() - '0'.charCodeAt()) * 10 + (c1.charCodeAt() - '0'.charCodeAt()) <= 26) ? 1 : 0;
}
```

```go [sol1-Golang]
func check1digit(ch byte) int {
    if ch == '*' {
        return 9
    }
    if ch == '0' {
        return 0
    }
    return 1
}

func check2digits(c0, c1 byte) int {
    if c0 == '*' && c1 == '*' {
        return 15
    }
    if c0 == '*' {
        if c1 <= '6' {
            return 2
        }
        return 1
    }
    if c1 == '*' {
        if c0 == '1' {
            return 9
        }
        if c0 == '2' {
            return 6
        }
        return 0
    }
    if c0 != '0' && (c0-'0')*10+(c1-'0') <= 26 {
        return 1
    }
    return 0
}

func numDecodings(s string) int {
    const mod int = 1e9 + 7
    a, b, c := 0, 1, 0
    for i := range s {
        c = b * check1digit(s[i]) % mod
        if i > 0 {
            c = (c + a*check2digits(s[i-1], s[i])) % mod
        }
        a, b = b, c
    }
    return c
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(1)$。
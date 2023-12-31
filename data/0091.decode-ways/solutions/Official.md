## [91.解码方法 中文官方题解](https://leetcode.cn/problems/decode-ways/solutions/100000/jie-ma-fang-fa-by-leetcode-solution-p8np)

#### 方法一：动态规划

**思路与算法**

对于给定的字符串 $s$，设它的长度为 $n$，其中的字符从左到右依次为 $s[1], s[2], \cdots, s[n]$。我们可以使用动态规划的方法计算出字符串 $s$ 的解码方法数。

具体地，设 $f_i$ 表示字符串 $s$ 的前 $i$ 个字符 $s[1..i]$ 的解码方法数。在进行状态转移时，我们可以考虑最后一次解码使用了 $s$ 中的哪些字符，那么会有下面的两种情况：

- 第一种情况是我们使用了一个字符，即 $s[i]$ 进行解码，那么只要 $s[i] \neq 0$，它就可以被解码成 $\text{A} \sim \text{I}$ 中的某个字母。由于剩余的前 $i-1$ 个字符的解码方法数为 $f_{i-1}$，因此我们可以写出状态转移方程：

    $$
    f_i = f_{i-1}, \quad 其中 ~ s[i] \neq 0
    $$

- 第二种情况是我们使用了两个字符，即 $s[i-1]$ 和 $s[i]$ 进行编码。与第一种情况类似，$s[i-1]$ 不能等于 $0$，并且 $s[i-1]$ 和 $s[i]$ 组成的整数必须小于等于 $26$，这样它们就可以被解码成 $\text{J} \sim \text{Z}$ 中的某个字母。由于剩余的前 $i-2$ 个字符的解码方法数为 $f_{i-2}$，因此我们可以写出状态转移方程：

    $$
    f_i = f_{i-2}, \quad 其中 ~ s[i-1] \neq 0 ~并且~ 10\cdot s[i-1]+s[i] \leq 26
    $$

    需要注意的是，只有当 $i>1$ 时才能进行转移，否则 $s[i-1]$ 不存在。

将上面的两种状态转移方程在对应的条件满足时进行累加，即可得到 $f_i$ 的值。在动态规划完成后，最终的答案即为 $f_n$。

**细节**

动态规划的边界条件为：

$$
f_0 = 1
$$

即**空字符串可以有 $1$ 种解码方法，解码出一个空字符串**。

同时，由于在大部分语言中，字符串的下标是从 $0$ 而不是 $1$ 开始的，因此在代码的编写过程中，我们需要将所有字符串的下标减去 $1$，与使用的语言保持一致。

**代码**

```C++ [sol11-C++]
class Solution {
public:
    int numDecodings(string s) {
        int n = s.size();
        vector<int> f(n + 1);
        f[0] = 1;
        for (int i = 1; i <= n; ++i) {
            if (s[i - 1] != '0') {
                f[i] += f[i - 1];
            }
            if (i > 1 && s[i - 2] != '0' && ((s[i - 2] - '0') * 10 + (s[i - 1] - '0') <= 26)) {
                f[i] += f[i - 2];
            }
        }
        return f[n];
    }
};
```

```Java [sol11-Java]
class Solution {
    public int numDecodings(String s) {
        int n = s.length();
        int[] f = new int[n + 1];
        f[0] = 1;
        for (int i = 1; i <= n; ++i) {
            if (s.charAt(i - 1) != '0') {
                f[i] += f[i - 1];
            }
            if (i > 1 && s.charAt(i - 2) != '0' && ((s.charAt(i - 2) - '0') * 10 + (s.charAt(i - 1) - '0') <= 26)) {
                f[i] += f[i - 2];
            }
        }
        return f[n];
    }
}
```

```Python [sol11-Python3]
class Solution:
    def numDecodings(self, s: str) -> int:
        n = len(s)
        f = [1] + [0] * n
        for i in range(1, n + 1):
            if s[i - 1] != '0':
                f[i] += f[i - 1]
            if i > 1 and s[i - 2] != '0' and int(s[i-2:i]) <= 26:
                f[i] += f[i - 2]
        return f[n]
```

```JavaScript [sol11-JavaScript]
var numDecodings = function(s) {
    const n = s.length;
    const f = new Array(n + 1).fill(0);
    f[0] = 1;
    for (let i = 1; i <= n; ++i) {
        if (s[i - 1] !== '0') {
            f[i] += f[i - 1];
        }
        if (i > 1 && s[i - 2] != '0' && ((s[i - 2] - '0') * 10 + (s[i - 1] - '0') <= 26)) {
            f[i] += f[i - 2];
        }
    }
    return f[n];
};
```

```go [sol11-Golang]
func numDecodings(s string) int {
    n := len(s)
    f := make([]int, n+1)
    f[0] = 1
    for i := 1; i <= n; i++ {
        if s[i-1] != '0' {
            f[i] += f[i-1]
        }
        if i > 1 && s[i-2] != '0' && ((s[i-2]-'0')*10+(s[i-1]-'0') <= 26) {
            f[i] += f[i-2]
        }
    }
    return f[n]
}
```

```C [sol11-C]
int numDecodings(char* s) {
    int n = strlen(s);
    int f[n + 1];
    memset(f, 0, sizeof(f));
    f[0] = 1;
    for (int i = 1; i <= n; ++i) {
        if (s[i - 1] != '0') {
            f[i] += f[i - 1];
        }
        if (i > 1 && s[i - 2] != '0' && ((s[i - 2] - '0') * 10 + (s[i - 1] - '0') <= 26)) {
            f[i] += f[i - 2];
        }
    }
    return f[n];
}
```

注意到在状态转移方程中，$f_i$ 的值仅与 $f_{i-1}$ 和 $f_{i-2}$ 有关，因此我们可以使用三个变量进行状态转移，省去数组的空间。

```C++ [sol12-C++]
class Solution {
public:
    int numDecodings(string s) {
        int n = s.size();
        // a = f[i-2], b = f[i-1], c = f[i]
        int a = 0, b = 1, c;
        for (int i = 1; i <= n; ++i) {
            c = 0;
            if (s[i - 1] != '0') {
                c += b;
            }
            if (i > 1 && s[i - 2] != '0' && ((s[i - 2] - '0') * 10 + (s[i - 1] - '0') <= 26)) {
                c += a;
            }
            tie(a, b) = {b, c};
        }
        return c;
    }
};
```

```Java [sol12-Java]
class Solution {
    public int numDecodings(String s) {
        int n = s.length();
        // a = f[i-2], b = f[i-1], c=f[i]
        int a = 0, b = 1, c = 0;
        for (int i = 1; i <= n; ++i) {
            c = 0;
            if (s.charAt(i - 1) != '0') {
                c += b;
            }
            if (i > 1 && s.charAt(i - 2) != '0' && ((s.charAt(i - 2) - '0') * 10 + (s.charAt(i - 1) - '0') <= 26)) {
                c += a;
            }
            a = b;
            b = c;
        }
        return c;
    }
}
```

```Python [sol12-Python3]
class Solution:
    def numDecodings(self, s: str) -> int:
        n = len(s)
        # a = f[i-2], b = f[i-1], c = f[i]
        a, b, c = 0, 1, 0
        for i in range(1, n + 1):
            c = 0
            if s[i - 1] != '0':
                c += b
            if i > 1 and s[i - 2] != '0' and int(s[i-2:i]) <= 26:
                c += a
            a, b = b, c
        return c
```

```JavaScript [sol12-JavaScript]
var numDecodings = function(s) {
    const n = s.length;
    // a = f[i-2], b = f[i-1], c = f[i]
    let a = 0, b = 1, c = 0;
    for (let i = 1; i <= n; ++i) {
        c = 0;
        if (s[i - 1] !== '0') {
            c += b;
        }
        if (i > 1 && s[i - 2] != '0' && ((s[i - 2] - '0') * 10 + (s[i - 1] - '0') <= 26)) {
            c += a;
        }
        a = b;
        b = c;
    }
    return c;
};
```

```go [sol12-Golang]
func numDecodings(s string) int {
    n := len(s)
    // a = f[i-2], b = f[i-1], c = f[i]
    a, b, c := 0, 1, 0
    for i := 1; i <= n; i++ {
        c = 0
        if s[i-1] != '0' {
            c += b
        }
        if i > 1 && s[i-2] != '0' && ((s[i-2]-'0')*10+(s[i-1]-'0') <= 26) {
            c += a
        }
        a, b = b, c
    }
    return c
}
```

```C [sol12-C]
int numDecodings(char* s) {
    int n = strlen(s);
    // a = f[i-2], b = f[i-1], c = f[i]
    int a = 0, b = 1, c;
    for (int i = 1; i <= n; ++i) {
        c = 0;
        if (s[i - 1] != '0') {
            c += b;
        }
        if (i > 1 && s[i - 2] != '0' && ((s[i - 2] - '0') * 10 + (s[i - 1] - '0') <= 26)) {
            c += a;
        }
        a = b, b = c;
    }
    return c;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(n)$ 或 $O(1)$。如果使用数组进行状态转移，空间复杂度为 $O(n)$；如果仅使用三个变量，空间复杂度为 $O(1)$。
#### 前言

关于数位 DP 的详细介绍可以参考「[数位DP(OI Wiki)](https://oi-wiki.org/dp/number/)」，类似题目有「[233. 数字 1 的个数](https://leetcode.cn/problems/number-of-digit-one/)」、「[600. 不含连续1的非负整数](https://leetcode.cn/problems/non-negative-integers-without-consecutive-ones/)」等。

#### 方法一：记忆化搜索

由互斥原理可知，至少有 $1$ 位重复的数字的正整数个数等于总个数减去没有重复数字的正整数个数。为了方便计算，我们首先求出在整数区间 $[0, n]$ 之间的没有重复数字的正整数个数 $x$，那么结果等于 $n+1-x$。

我们从最高位开始填入各个数字，使用整数掩码 $\textit{mask}$ 记录前面已经填入过的数字（注意前缀 $0$ 不计入已填入的数字）。假设当前填入第 $i$ 位，如果前面填入的数字与 $n$ 对应位置的数字相同，那么可选的填入数字小于等于 $n$ 在第 $i$ 位的数字，否则可填入全部数字。

记可填入的最大数字为 $t$，依次尝试填入数字 $k \in [0, t]$，如果 $k$ 已经出现在 $\textit{mask}$ 中，那么说明填入数字 $k$ 不合法，否则说明可以填入数字 $k$，那么尝试填入第 $i+1$ 位的数字。

在填入第 $i+1$ 位的数字时，如果掩码 $\textit{mask}_i = 0$ 且 $k=0$ 成立，那么说明前面都是前缀 $0$，掩码 $\textit{mask}_{i+1}$ 为 $0$，否则 $\textit{mask}_{i+1}$ 等于 $\textit{mask}_i$ 在第 $k$ 位设为一后的值。如果在填入第 $i$ 位时，前面填入的数字与 $n$ 对应位置的数字相同，且在第 $i$ 位填入的数字为 $t$，那么填入第 $i+1$ 位时，前面填入的数字也与 $n$ 对应位置的数字相同。

注意到，假设当前需要填入第 $i$ 位，且前面填入的数字与 $n$ 对应位置的数字不相同，那么需要求得的不重复数字的正整数个数只与 $\textit{mask}$ 相关，我们可以使用备忘录 $\textit{dp}$ 记录该结果，避免重复计算。

```Python [sol1-Python3]
class Solution:
    def numDupDigitsAtMostN(self, n: int) -> int:
        A = list(map(int, str(n)))
        N = len(A)
        @cache
        def f(i, tight, mask, hasDup):
            if i >= N:
                if hasDup:
                    return 1
                return 0
            upperLimit = A[i] if tight else 9
            ans = 0
            for d in range(upperLimit + 1):
                tight2 = tight and d == upperLimit
                mask2 = mask if mask == 0 and d == 0 else mask | (1 << d)
                hasDup2 = hasDup or (mask & (1 << d))
                ans += f(i + 1, tight2, mask2, hasDup2)
            return ans
        return f(0, True, 0, False)
```

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> dp;

    int f(int mask, const string &sn, int i, bool same) {
        if (i == sn.size()) {
            return 1;
        }
        if (!same && dp[i][mask] >= 0) {
            return dp[i][mask];
        }
        int res = 0, t = same ? (sn[i] - '0') : 9;
        for (int k = 0; k <= t; k++) {
            if (mask & (1 << k)) {
                continue;
            }
            res += f(mask == 0 && k == 0 ? mask : mask | (1 << k), sn, i + 1, same && k == t);
        }
        if (!same) {
            dp[i][mask] = res;
        }
        return res;
    }

    int numDupDigitsAtMostN(int n) {
        string sn = to_string(n);
        dp.resize(sn.size(), vector<int>(1 << 10, -1));
        return n + 1 - f(0, sn, 0, true);
    }
};
```

```Java [sol1-Java]
class Solution {
    int[][] dp;

    public int numDupDigitsAtMostN(int n) {
        String sn = String.valueOf(n);
        dp = new int[sn.length()][1 << 10];
        for (int i = 0; i < sn.length(); i++) {
            Arrays.fill(dp[i], -1);
        }
        return n + 1 - f(0, sn, 0, true);
    }

    public int f(int mask, String sn, int i, boolean same) {
        if (i == sn.length()) {
            return 1;
        }
        if (!same && dp[i][mask] >= 0) {
            return dp[i][mask];
        }
        int res = 0, t = same ? (sn.charAt(i) - '0') : 9;
        for (int k = 0; k <= t; k++) {
            if ((mask & (1 << k)) != 0) {
                continue;
            }
            res += f(mask == 0 && k == 0 ? mask : mask | (1 << k), sn, i + 1, same && k == t);
        }
        if (!same) {
            dp[i][mask] = res;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    int[][] dp;

    public int NumDupDigitsAtMostN(int n) {
        string sn = n.ToString();
        dp = new int[sn.Length][];
        for (int i = 0; i < sn.Length; i++) {
            dp[i] = new int[1 << 10];
            Array.Fill(dp[i], -1);
        }
        return n + 1 - F(0, sn, 0, true);
    }

    public int F(int mask, string sn, int i, bool same) {
        if (i == sn.Length) {
            return 1;
        }
        if (!same && dp[i][mask] >= 0) {
            return dp[i][mask];
        }
        int res = 0, t = same ? (sn[i] - '0') : 9;
        for (int k = 0; k <= t; k++) {
            if ((mask & (1 << k)) != 0) {
                continue;
            }
            res += F(mask == 0 && k == 0 ? mask : mask | (1 << k), sn, i + 1, same && k == t);
        }
        if (!same) {
            dp[i][mask] = res;
        }
        return res;
    }
}
```

```C [sol1-C]
int f(int mask, const char *sn, int i, bool same, int **dp) {
    if (sn[i] == '\0') {
        return 1;
    }
    if (!same && dp[i][mask] >= 0) {
        return dp[i][mask];
    }
    int res = 0, t = same ? (sn[i] - '0') : 9;
    for (int k = 0; k <= t; k++) {
        if (mask & (1 << k)) {
            continue;
        }
        res += f(mask == 0 && k == 0 ? mask : mask | (1 << k), sn, i + 1, same && k == t, dp);
    }
    if (!same) {
        dp[i][mask] = res;
    }
    return res;
}

int numDupDigitsAtMostN(int n) {
    char sn[32];
    sprintf(sn, "%d", n);
    int len = strlen(sn);
    int *dp[len];
    for (int i = 0; i < len; i++) {
        dp[i] = (int *)malloc(sizeof(int) * (1 << 10));
        memset(dp[i], 0xff, sizeof(int) * (1 << 10));
    }
    int ret = n + 1 - f(0, sn, 0, true, dp);
    for (int i = 0; i < len; i++) {
        free(dp[i]);
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var numDupDigitsAtMostN = function(n) {
    const sn = '' + n;
    dp = new Array(sn.length).fill(0).map(() => new Array(1 << 10).fill(-1));
    const f = (mask, sn, i, same) => {
        if (i === sn.length) {
            return 1;
        }
        if (!same && dp[i][mask] >= 0) {
            return dp[i][mask];
        }
        let res = 0, t = same ? (sn[i].charCodeAt() - '0'.charCodeAt()) : 9;
        for (let k = 0; k <= t; k++) {
            if ((mask & (1 << k)) !== 0) {
                continue;
            }
            res += f(mask === 0 && k === 0 ? mask : mask | (1 << k), sn, i + 1, same && k === t);
        }
        if (!same) {
            dp[i][mask] = res;
        }
        return res;
    };
    return n + 1 - f(0, sn, 0, true);
}
```

**复杂度分析**

+ 时间复杂度：$O(m \times w \times 2^w)$，其中 $m$ 是整数 $n$ 的十进制位数，$w=10$ 表示十进制数的数字类型数目。最多计算 $m \times 2^w$ 个状态，单个状态需要 $O(w)$ 的时间。

+ 空间复杂度：$O(m \times 2^w)$。保存 $\textit{dp}$ 需要 $O(m \times 2^w)$ 的空间。

#### 方法二：组合数学

方法一只有两种情况需要继续进入搜索：

+ 前面填入的数字与 $n$ 对应位置的数字相同，且当前填入的数字为 $t$；

+ 前面填入的数字都是 $0$，即前缀 $0$，并且当前填入的数字也为 $0$。

其他情况可以直接利用组合数学进行计算，当前填入第 $i$ 位，那么剩余 $m - 1 - i$ 位待填入，记已经填入的数字数目为 $c$，那么可选的数字数目为 $10-c$，那么剩余的不重复数字的正整数个数等于组合数 $A^{m - 1 - i}_{10-c}$（$n$ 的数据范围保证了组合数合法）。

```Python [sol2-Python3]
class Solution:
    def numDupDigitsAtMostN(self, N: int) -> int:
        limit, s = list(map(int, str(N + 1))), set()
        n, res = len(limit), sum(9 * perm(9, i) for i in range(len(limit) - 1))
        for i, x in enumerate(limit):
            for y in range(i == 0, x):
                if y not in s:
                    res += perm(9 - i, n - i - 1)
            if x in s: 
                break
            s.add(x)
        return N - res
```

```C++ [sol2-C++]
class Solution {
public:
    int A(int x, int y) {
        int res = 1;
        for (int i = 0; i < x; i++) {
            res *= y--;
        }
        return res;
    }

    int f(int mask, const string &sn, int i, bool same) {
        if (i == sn.size()) {
            return 1;
        }
        int t = same ? sn[i] - '0' : 9, res = 0, c = __builtin_popcount(mask) + 1;
        for (int k = 0; k <= t; k++) {
            if (mask & (1 << k)) {
                continue;
            }
            if (same && k == t) {
                res += f(mask | (1 << t), sn, i + 1, true);
            } else if (mask == 0 && k == 0) {
                res += f(0, sn, i + 1, false);
            } else {
                res += A(sn.size() - 1 - i, 10 - c);
            }
        }
        return res;
    }

    int numDupDigitsAtMostN(int n) {
        string sn = to_string(n);
        return n + 1 - f(0, sn, 0, true);
    }
};
```

```Java [sol2-Java]
class Solution {
    public int numDupDigitsAtMostN(int n) {
        String sn = String.valueOf(n);
        return n + 1 - f(0, sn, 0, true);
    }

    public int f(int mask, String sn, int i, boolean same) {
        if (i == sn.length()) {
            return 1;
        }
        int t = same ? sn.charAt(i) - '0' : 9, res = 0, c = Integer.bitCount(mask) + 1;
        for (int k = 0; k <= t; k++) {
            if ((mask & (1 << k)) != 0) {
                continue;
            }
            if (same && k == t) {
                res += f(mask | (1 << t), sn, i + 1, true);
            } else if (mask == 0 && k == 0) {
                res += f(0, sn, i + 1, false);
            } else {
                res += A(sn.length() - 1 - i, 10 - c);
            }
        }
        return res;
    }

    public int A(int x, int y) {
        int res = 1;
        for (int i = 0; i < x; i++) {
            res *= y--;
        }
        return res;
    }
}
```

```C [sol2-C]
int A(int x, int y) {
    int res = 1;
    for (int i = 0; i < x; i++) {
        res *= y--;
    }
    return res;
}

int f(int mask, const char *sn, int i, bool same) {
    if (sn[i] == '\0') {
        return 1;
    }
    int t = same ? sn[i] - '0' : 9, res = 0, c = __builtin_popcount(mask) + 1;
    for (int k = 0; k <= t; k++) {
        if (mask & (1 << k)) {
            continue;
        }
        if (same && k == t) {
            res += f(mask | (1 << t), sn, i + 1, true);
        } else if (mask == 0 && k == 0) {
            res += f(0, sn, i + 1, false);
        } else {
            res += A(strlen(sn) - 1 - i, 10 - c);
        }
    }
    return res;
}

int numDupDigitsAtMostN(int n){
    char sn[32];
    sprintf(sn, "%d", n);
    return n + 1 - f(0, sn, 0, true);
}
```

```JavaScript [sol2-JavaScript]
var numDupDigitsAtMostN = function(n) {
    const sn = '' + n;
    const f = (mask, sn, i, same) => {
        if (i === sn.length) {
            return 1;
        }
        let t = same ? sn[i].charCodeAt() - '0'.charCodeAt() : 9, res = 0, c = bitCount(mask) + 1;
        for (let k = 0; k <= t; k++) {
            if ((mask & (1 << k)) !== 0) {
                continue;
            }
            if (same && k === t) {
                res += f(mask | (1 << t), sn, i + 1, true);
            } else if (mask === 0 && k === 0) {
                res += f(0, sn, i + 1, false);
            } else {
                res += A(sn.length - 1 - i, 10 - c);
            }
        }
        return res;
    }
    return n + 1 - f(0, sn, 0, true);
}

const A = (x, y) => {
    let res = 1;
    for (let i = 0; i < x; i++) {
        res *= y--;
    }
    return res;
}

const bitCount = (n) => {
    return n.toString(2).split('0').join('').length;
}
```

**复杂度分析**

+ 时间复杂度：$O(m \times w^2)$，其中 $m$ 是整数 $n$ 的十进制位数，$w=10$ 表示十进制数的数字类型数目。计算组合数需要 $O(w)$ 的时间，而前面提到的两种情况互斥，因此搜索过程最多只出现一种情况，搜索层数为 $m$ 层，因此总时间复杂度为 $O(m \times w^2)$。

+ 空间复杂度：$O(m)$。递归需要 $O(m)$ 的栈空间。
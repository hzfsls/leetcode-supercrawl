## [878.第 N 个神奇数字 中文官方题解](https://leetcode.cn/problems/nth-magical-number/solutions/100000/di-n-ge-shen-qi-shu-zi-by-leetcode-solut-6vyy)
#### 方法一：容斥原理 + 二分查找

**思路与算法**

题目给出三个数字 $n$，$a$，$b$，满足 $1 \le n \le 10^9$，$2 \le a, b \le 4 \times 10^4$，并给出「神奇数字」的定义：若一个正整数能被 $a$ 和 $b$ 整除，那么它就是「神奇」的。现在需要求出对于给定 $a$ 和 $b$ 的第 $n$ 个「神奇数字」。设 $f(x)$ 表示为小于等于 $x$ 的「神奇数字」个数，因为小于等于 $x$ 中能被 $a$ 整除的数的个数为 $\lfloor \frac{x}{a} \rfloor$，小于等于 $x$ 中能被 $b$ 整除的个数为 $\lfloor \frac{x}{b} \rfloor$，小于等于 $x$ 中同时能被 $a$ 和 $b$ 整除的个数为 $\lfloor \frac{x}{c} \rfloor$，其中 $c$ 为 $a$ 和 $b$ 的最小公倍数，所以 $f(x)$ 的表达式为：

$$f(x) = \lfloor \frac{x}{a} \rfloor + \lfloor \frac{x}{b} \rfloor - \lfloor \frac{x}{c} \rfloor$$

即$f(x)$ 是一个随着 $x$ 递增单调不减函数。那么我们可以通过「二分查找」来进行查找第 $n$ 个「神奇数字」。

**代码**

```Python [sol1-Python3]
class Solution:
    def nthMagicalNumber(self, n: int, a: int, b: int) -> int:
        MOD = 10 ** 9 + 7
        l = min(a, b)
        r = n * min(a, b)
        c = lcm(a, b)
        while l <= r:
            mid = (l + r) // 2
            cnt = mid // a + mid // b - mid // c
            if cnt >= n:
                r = mid - 1
            else:
                l = mid + 1
        return (r + 1) % MOD
```

```C++ [sol1-C++]
class Solution {
public:
    const int MOD = 1e9 + 7;
    int nthMagicalNumber(int n, int a, int b) {
        long long l = min(a, b);
        long long r = (long long) n * min(a, b);
        int c = lcm(a, b);
        while (l <= r) {
            long long mid = (l + r) / 2;
            long long cnt = mid / a + mid / b - mid / c;
            if (cnt >= n) {
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return (r + 1) % MOD;
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int MOD = 1000000007;

    public int nthMagicalNumber(int n, int a, int b) {
        long l = Math.min(a, b);
        long r = (long) n * Math.min(a, b);
        int c = lcm(a, b);
        while (l <= r) {
            long mid = (l + r) / 2;
            long cnt = mid / a + mid / b - mid / c;
            if (cnt >= n) {
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return (int) ((r + 1) % MOD);
    }

    public int lcm(int a, int b) {
        return a * b / gcd(a, b);
    }

    public int gcd(int a, int b) {
        return b != 0 ? gcd(b, a % b) : a;
    }
}
```

```C# [sol1-C#]
public class Solution {
    const int MOD = 1000000007;

    public int NthMagicalNumber(int n, int a, int b) {
        long l = Math.Min(a, b);
        long r = (long) n * Math.Min(a, b);
        int c = LCM(a, b);
        while (l <= r) {
            long mid = (l + r) / 2;
            long cnt = mid / a + mid / b - mid / c;
            if (cnt >= n) {
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return (int) ((r + 1) % MOD);
    }

    public int LCM(int a, int b) {
        return a * b / GCD(a, b);
    }

    public int GCD(int a, int b) {
        return b != 0 ? GCD(b, a % b) : a;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))
const int MOD = 1e9 + 7;

int gcd(int a, int b) {
    return b != 0 ? gcd(b, a % b) : a;
}

int lcm(int a, int b) {
    return a * b / gcd(a, b);
}

int nthMagicalNumber(int n, int a, int b) {
    long long l = MIN(a, b);
    long long r = (long long) n * MIN(a, b);
    int c = lcm(a, b);
    while (l <= r) {
        long long mid = (l + r) / 2;
        long long cnt = mid / a + mid / b - mid / c;
        if (cnt >= n) {
            r = mid - 1;
        } else {
            l = mid + 1;
        }
    }
    return (r + 1) % MOD;
}
```

```JavaScript [sol1-JavaScript]
const MOD = 1000000007;
var nthMagicalNumber = function(n, a, b) {
    let l = Math.min(a, b);
    let r = n * Math.min(a, b);
    const c = lcm(a, b);
    while (l <= r) {
        const mid = Math.floor((l + r) / 2);
        const cnt = Math.floor(mid / a) + Math.floor(mid / b) - Math.floor(mid / c);
        if (cnt >= n) {
            r = mid - 1;
        } else {
            l = mid + 1;
        }
    }
    return (r + 1) % MOD;
}

const lcm = (a, b) => {
    return Math.floor(a * b / gcd(a, b));
}

const gcd = (a, b) => {
    return b !== 0 ? gcd(b, a % b) : a;
};
```

```go [sol1-Golang]
const mod int = 1e9 + 7

func nthMagicalNumber(n, a, b int) int {
    l := min(a, b)
    r := n * min(a, b)
    c := a / gcd(a, b) * b
    for l <= r {
        mid := (l + r) / 2
        cnt := mid/a + mid/b - mid/c
        if cnt >= n {
            r = mid - 1
        } else {
            l = mid + 1
        }
    }
    return (r + 1) % mod
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func gcd(a, b int) int {
    if b != 0 {
        return gcd(b, a%b)
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(\log(n \times \max(a, b)))$，其中 $n$，$b$，$c$ 为题目给定的数字。
- 空间复杂度：$O(1)$，仅使用常量空间开销。

#### 方法二：找规律

**思路与算法**

通过「方法一」我们也可以知道小于等于 $x \times c$ 的「神奇数字」个数 $f(x \times c) = q \times f(c) = x \times (\frac{c}{a} + \frac{c}{b} - 1)$ 个，其中 $c$ 为 $a$ 和 $b$ 的最小公倍数，$x$ 为非负整数。令 $m = f(c)$，$n = q * m + r$，其中 $0 \le r < m$，$q$ 为非负整数。因为不大于 $c \times q$ 的「神奇数字」个数为 $q * m$，所以我们只需要从 $c \times q$ 往后搜第 $r$ 个「神奇数字」即可。又因为对于 $c \times q$ 的之后的「神奇数字」只能是 $c \times q + a, c \times q + 2 \times a, \cdots$ 和 $c \times q + b, c \times q + 2 \times b, \cdots$，那么我们从小到大来搜索到第 $r$ 个「神奇数字」即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def nthMagicalNumber(self, n: int, a: int, b: int) -> int:
        MOD = 10 ** 9 + 7
        c = lcm(a, b)
        m = c // a + c // b - 1
        r = n % m
        res = c * (n // m) % MOD
        if r == 0:
            return res
        addA = a
        addB = b
        for _ in range(r - 1):
            if addA < addB:
                addA += a
            else:
                addB += b
        return (res + min(addA, addB) % MOD) % MOD
```

```C++ [sol2-C++]
class Solution {
public:
    const int MOD = 1e9 + 7;
    int nthMagicalNumber(int n, int a, int b) {
        int c = lcm(a, b);
        int m = c / a + c / b - 1;
        int r = n % m;
        int res = (long long) c * (n / m) % MOD;
        if (r == 0) {
            return res;
        }
        int addA = a, addB = b;
        for (int i = 0; i <  r - 1; ++i) {
            if (addA < addB) {
                addA += a;
            } else {
                addB += b;
            }
        }
        return (res + min(addA, addB) % MOD) % MOD;
    }
};
```

```Java [sol2-Java]
class Solution {
    static final int MOD = 1000000007;

    public int nthMagicalNumber(int n, int a, int b) {
        int c = lcm(a, b);
        int m = c / a + c / b - 1;
        int r = n % m;
        int res = (int) ((long) c * (n / m) % MOD);
        if (r == 0) {
            return res;
        }
        int addA = a, addB = b;
        for (int i = 0; i <  r - 1; ++i) {
            if (addA < addB) {
                addA += a;
            } else {
                addB += b;
            }
        }
        return (res + Math.min(addA, addB) % MOD) % MOD;
    }

    public int lcm(int a, int b) {
        return a * b / gcd(a, b);
    }

    public int gcd(int a, int b) {
        return b != 0 ? gcd(b, a % b) : a;
    }
}
```

```C# [sol2-C#]
public class Solution {
    const int MOD = 1000000007;

    public int NthMagicalNumber(int n, int a, int b) {
        int c = LCM(a, b);
        int m = c / a + c / b - 1;
        int r = n % m;
        int res = (int) ((long) c * (n / m) % MOD);
        if (r == 0) {
            return res;
        }
        int addA = a, addB = b;
        for (int i = 0; i <  r - 1; ++i) {
            if (addA < addB) {
                addA += a;
            } else {
                addB += b;
            }
        }
        return (res + Math.Min(addA, addB) % MOD) % MOD;
    }

    public int LCM(int a, int b) {
        return a * b / GCD(a, b);
    }

    public int GCD(int a, int b) {
        return b != 0 ? GCD(b, a % b) : a;
    }
}
```

```C [sol2-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))
const int MOD = 1e9 + 7;

int gcd(int a, int b) {
    return b != 0 ? gcd(b, a % b) : a;
}

int lcm(int a, int b) {
    return a * b / gcd(a, b);
}

int nthMagicalNumber(int n, int a, int b) {
    int c = lcm(a, b);
    int m = c / a + c / b - 1;
    int r = n % m;
    int res = (long long) c * (n / m) % MOD;
    if (r == 0) {
        return res;
    }
    int addA = a, addB = b;
    for (int i = 0; i <  r - 1; ++i) {
        if (addA < addB) {
            addA += a;
        } else {
            addB += b;
        }
    }
    return (res + MIN(addA, addB) % MOD) % MOD;
}
```

```JavaScript [sol2-JavaScript]
const MOD = 1000000007;
var nthMagicalNumber = function(n, a, b) {
    const c = lcm(a, b);
    const m = Math.floor(c / a) + Math.floor(c / b) - 1;
    const r = n % m;
    const res = c * Math.floor(n / m) % MOD;
    if (r === 0) {
        return res;
    }
    let addA = a, addB = b;
    for (let i = 0; i <  r - 1; ++i) {
        if (addA < addB) {
            addA += a;
        } else {
            addB += b;
        }
    }
    return (res + Math.min(addA, addB) % MOD) % MOD;
}

const lcm = (a, b) => {
    return Math.floor(a * b / gcd(a, b));
}

const gcd = (a, b) => {
    return b !== 0 ? gcd(b, a % b) : a;
};
```

```go [sol2-Golang]
const mod int = 1e9 + 7

func nthMagicalNumber(n, a, b int) int {
    c := a / gcd(a, b) * b
    m := c/a + c/b - 1
    r := n % m
    res := c * (n / m) % mod
    if r == 0 {
        return res
    }
    addA := a
    addB := b
    for i := 0; i < r-1; i++ {
        if addA < addB {
            addA += a
        } else {
            addB += b
        }
    }
    return (res + min(addA, addB)%mod) % mod
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func gcd(a, b int) int {
    if b != 0 {
        return gcd(b, a%b)
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(a + b)$，其中 $n$，$b$，$c$ 为题目给定的数字。
- 空间复杂度：$O(1)$，仅使用常量空间开销。
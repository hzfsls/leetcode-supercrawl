## [372.超级次方 中文官方题解](https://leetcode.cn/problems/super-pow/solutions/100000/chao-ji-ci-fang-by-leetcode-solution-ow8j)
#### 前置知识

在阅读本文前，读者需要掌握快速幂这一算法，具体可以见「[50. Pow(x, n) 的官方题解](https://leetcode-cn.com/problems/powx-n/solution/powx-n-by-leetcode-solution/)」。

此外，乘法在取模的意义下满足分配律，即

$$
(a \cdot b) \bmod m = [(a \bmod m) \cdot (b \bmod m)] \bmod m
$$

#### 方法一：倒序遍历

设 $a$ 的幂次为 $n$。根据题意，$n$ 从最高位到最低位的所有数位构成了数组 $b$。记数组 $b$ 的长度为 $m$，有

$$
n=\sum\limits_{i=0}^{m-1} 10^{m-1-i} \cdot b_i
$$

由于 $a^{x+y}=a^x\cdot a^y$ 以及 $a^{x\cdot y} = (a^x)^y$，得

$$
a^n = \prod\limits_{i=0}^{m-1} a^{10^{m-1-i} \cdot b_i} = \prod\limits_{i=0}^{m-1} \Big(a^{10^{m-1-i}}\Big)^{b_i}
$$

可以根据如下等式计算上式括号内的部分：

$$
a^{10^k} = a^{10^{k-1}\cdot 10} = \Big(a^{10^{k-1}}\Big)^{10}
$$

我们可以从 $a^1$ 开始，递推地计算出 $a^{10^k}$。

代码实现时，可以从 $b_{m-1}$ 开始倒序计算，在计算的过程中同时递推计算出 $a^{10^k}$。

```Python [sol1-Python3]
class Solution:
    def superPow(self, a: int, b: List[int]) -> int:
        MOD = 1337
        ans = 1
        for e in reversed(b):
            ans = ans * pow(a, e, MOD) % MOD
            a = pow(a, 10, MOD)
        return ans
```

```C++ [sol1-C++]
class Solution {
    const int MOD = 1337;

    int pow(int x, int n) {
        int res = 1;
        while (n) {
            if (n % 2) {
                res = (long) res * x % MOD;
            }
            x = (long) x * x % MOD;
            n /= 2;
        }
        return res;
    }

public:
    int superPow(int a, vector<int> &b) {
        int ans = 1;
        for (int i = b.size() - 1; i >= 0; --i) {
            ans = (long) ans * pow(a, b[i]) % MOD;
            a = pow(a, 10);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    static final int MOD = 1337;

    public int superPow(int a, int[] b) {
        int ans = 1;
        for (int i = b.length - 1; i >= 0; --i) {
            ans = (int) ((long) ans * pow(a, b[i]) % MOD);
            a = pow(a, 10);
        }
        return ans;
    }

    public int pow(int x, int n) {
        int res = 1;
        while (n != 0) {
            if (n % 2 != 0) {
                res = (int) ((long) res * x % MOD);
            }
            x = (int) ((long) x * x % MOD);
            n /= 2;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    const int MOD = 1337;

    public int SuperPow(int a, int[] b) {
        int ans = 1;
        for (int i = b.Length - 1; i >= 0; --i) {
            ans = (int) ((long) ans * Pow(a, b[i]) % MOD);
            a = Pow(a, 10);
        }
        return ans;
    }

    public int Pow(int x, int n) {
        int res = 1;
        while (n != 0) {
            if (n % 2 != 0) {
                res = (int) ((long) res * x % MOD);
            }
            x = (int) ((long) x * x % MOD);
            n /= 2;
        }
        return res;
    }
}
```

```go [sol1-Golang]
const mod = 1337

func pow(x, n int) int {
    res := 1
    for ; n > 0; n /= 2 {
        if n&1 > 0 {
            res = res * x % mod
        }
        x = x * x % mod
    }
    return res
}

func superPow(a int, b []int) int {
    ans := 1
    for i := len(b)-1; i >= 0; i-- {
        ans = ans * pow(a, b[i]) % mod
        a = pow(a, 10)
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
const MOD = BigInt(1337);

var superPow = function(a, b) {
    let ans = BigInt(1);
    for (let i = b.length - 1; i >= 0; --i) {
        ans = ans * pow(BigInt(a), b[i]) % MOD;
        a = pow(BigInt(a), 10);
    }
    return ans;
};

const pow = (x, n) => {
    let res = BigInt(1);
    while (n !== 0) {
        if (n % 2 !== 0) {
            res = res * BigInt(x) % MOD;
        }
        x = x * x % MOD;
        n = Math.floor(n / 2);
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(\sum\limits_{i=0}^{m-1} \log b_i)$，其中 $m$ 是数组 $b$ 的长度。对每个 $b_i$ 计算快速幂的时间为 $O(\log b_i)$。

- 空间复杂度：$O(1)$，只需要常数的空间存放若干变量。

#### 方法二：秦九韶算法（正序遍历）

由于

$$
n = \sum\limits_{i=0}^{m-1} 10^{m-1-i} \cdot b_i = \Big(\sum\limits_{i=0}^{m-2} 10^{m-2-i} \cdot b_i\Big)\cdot 10 + b_{m-1}
$$

记 $n'=\sum\limits_{i=0}^{m-2} 10^{m-2-i} \cdot b_i$，有

$$
a^n = a^{n'\cdot 10 + b_{m-1}} = (a^{n'})^{10}\cdot a^{b_{m-1}}
$$

根据该式，可以得到如下递推式：

$$
\textit{superPow}(a,b) =
\begin{cases} 
1,&m=0\\
\textit{superPow}(a,b')^{10}\cdot a^{b_{m-1}},&m\ge 1
\end{cases}
$$

其中 $b'$ 为 $b$ 去掉末尾元素后的部分。

```Python [sol2-Python3]
class Solution:
    def superPow(self, a: int, b: List[int]) -> int:
        MOD = 1337
        ans = 1
        for e in b:
            ans = pow(ans, 10, MOD) * pow(a, e, MOD) % MOD
        return ans
```

```C++ [sol2-C++]
class Solution {
    const int MOD = 1337;

    int pow(int x, int n) {
        int res = 1;
        while (n) {
            if (n % 2) {
                res = (long) res * x % MOD;
            }
            x = (long) x * x % MOD;
            n /= 2;
        }
        return res;
    }

public:
    int superPow(int a, vector<int> &b) {
        int ans = 1;
        for (int e: b) {
            ans = (long) pow(ans, 10) * pow(a, e) % MOD;
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    static final int MOD = 1337;

    public int superPow(int a, int[] b) {
        int ans = 1;
        for (int e : b) {
            ans = (int) ((long) pow(ans, 10) * pow(a, e) % MOD);
        }
        return ans;
    }

    public int pow(int x, int n) {
        int res = 1;
        while (n != 0) {
            if (n % 2 != 0) {
                res = (int) ((long) res * x % MOD);
            }
            x = (int) ((long) x * x % MOD);
            n /= 2;
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    const int MOD = 1337;

    public int SuperPow(int a, int[] b) {
        int ans = 1;
        foreach (int e in b) {
            ans = (int) ((long) Pow(ans, 10) * Pow(a, e) % MOD);
        }
        return ans;
    }

    public int Pow(int x, int n) {
        int res = 1;
        while (n != 0) {
            if (n % 2 != 0) {
                res = (int) ((long) res * x % MOD);
            }
            x = (int) ((long) x * x % MOD);
            n /= 2;
        }
        return res;
    }
}
```

```go [sol2-Golang]
const mod = 1337

func pow(x, n int) int {
    res := 1
    for ; n > 0; n /= 2 {
        if n&1 > 0 {
            res = res * x % mod
        }
        x = x * x % mod
    }
    return res
}

func superPow(a int, b []int) int {
    ans := 1
    for _, e := range b {
        ans = pow(ans, 10) * pow(a, e) % mod
    }
    return ans
}
```

```JavaScript [sol2-JavaScript]
const MOD = BigInt(1337);

var superPow = function(a, b) {
    let ans = 1;
    for (const e of b) {
        ans = pow(BigInt(ans), 10) * pow(BigInt(a), e) % MOD;
    }
    return ans;
};

const pow = (x, n) => {
    let res = BigInt(1);
    while (n !== 0) {
        if (n % 2 !== 0) {
            res = res * BigInt(x) % MOD;
        }
        x = x * x % MOD;
        n = Math.floor(n / 2);
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(\sum\limits_{i=0}^{m-1} \log b_i)$，其中 $m$ 是数组 $b$ 的长度。对每个 $b_i$ 计算快速幂的时间为 $O(\log b_i)$。

- 空间复杂度：$O(1)$，只需要常数的空间存放若干变量。
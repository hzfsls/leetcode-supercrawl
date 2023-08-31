## [1486.数组异或操作 中文官方题解](https://leetcode.cn/problems/xor-operation-in-an-array/solutions/100000/shu-zu-yi-huo-cao-zuo-by-leetcode-solution)

#### 方法一：模拟

**思路**

按照题意模拟即可：

1. 初始化 $\textit{ans} = 0$；
2. 遍历区间 $[0, n - 1]$ 中的每一个整数 $i$，令 $\textit{ans}$ 与每一个 $\textit{start} + 2 \times i$ 做异或运算；
3. 最终返回 $\textit{ans}$，即我们需要的答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int xorOperation(int n, int start) {
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            ans ^= (start + i * 2);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int xorOperation(int n, int start) {
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            ans ^= (start + i * 2);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int XorOperation(int n, int start) {
        int ans = 0;
        for (int i = 0; i < n; ++i) {
            ans ^= (start + i * 2);
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def xorOperation(self, n: int, start: int) -> int:
        ans = 0
        for i in range(n):
            ans ^= (start + i * 2)
        return ans
```

```JavaScript [sol1-JavaScript]
var xorOperation = function(n, start) {
    let ans = 0;
    for (let i = 0; i < n; ++i) {
        ans ^= (start + i * 2);
    }
    return ans;
};
```

```go [sol1-Golang]
func xorOperation(n, start int) (ans int) {
    for i := 0; i < n; i++ {
        ans ^= start + i*2
    }
    return
}
```

```C [sol1-C]
int xorOperation(int n, int start) {
    int ans = 0;
    for (int i = 0; i < n; ++i) {
        ans ^= (start + i * 2);
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。这里用一重循环对 $n$ 个数字进行异或。

- 空间复杂度：$O(1)$。这里只是用了常量级别的辅助空间。

#### 方法二：数学

记 $\oplus$ 为异或运算，异或运算满足以下性质：

1. $x \oplus x = 0$；
2. $x \oplus y = y \oplus x$（交换律）；
3. $(x \oplus y) \oplus z = x \oplus (y \oplus z)$（结合律）；
4. $x \oplus y \oplus y = x$（自反性）；
5. $\forall i \in Z$，有 $4i \oplus (4i+1) \oplus (4i+2) \oplus (4i+3) = 0$。

在本题中，我们需要计算 $\textit{start} \oplus (\textit{start}+2i) \oplus (\textit{start}+4i) \oplus \dots \oplus (\textit{start}+2(n-1))$。

观察公式可以知道，这些数的奇偶性质相同，因此它们的二进制表示中的最低位或者均为 $1$，或者均为 $0$。于是我们可以把参与运算的数的二进制位的最低位提取出来单独处理。当且仅当 $\textit{start}$ 为奇数，且 $n$ 也为奇数时，结果的二进制位的最低位才为 $1$。

此时我们可以将公式转化为 $(s \oplus (s+1) \oplus (s+2) \oplus \dots \oplus (s+n-1))\times 2 + e$，其中 $s=\lfloor \frac{\textit{start}}{2} \rfloor$，$e$ 表示运算结果的最低位。即我们单独处理最低位，而舍去最低位后的数列恰成为一串连续的整数。

这样我们可以描述一个函数 $\text{sumXor}(x)$，表示 $0 \oplus 1 \oplus 2 \oplus \dots \oplus x$。利用异或运算的性质 $5$，我们可以将计算该函数的复杂度降低到 $O(1)$，因为以 $4i$ 为开头的连续四个整数异或的结果为 $0$，所以 $\text{sumXor}(x)$ 可以被表示为：

$$
\text{sumXor}(x)=
\begin{cases}
x,& x=4k,k\in Z\\
(x-1) \oplus x,& x=4k+1,k\in Z\\
(x-2) \oplus (x-1) \oplus x,& x=4k+2,k\in Z\\
(x-3) \oplus (x-2) \oplus (x-1) \oplus x,& x=4k+3,k\in Z\\
\end{cases}
$$

我们可以进一步化简该式：

$$
\text{sumXor}(x)=
\begin{cases}
x,& x=4k,k\in Z\\
1,& x=4k+1,k\in Z\\
x+1,& x=4k+2,k\in Z\\
0,& x=4k+3,k\in Z\\
\end{cases}
$$

这样最后的结果即可表示为 $(\text{sumXor}(s-1) \oplus \text{sumXor}(s+n-1))\times 2 + e$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int sumXor(int x) {
        if (x % 4 == 0) {
            return x;
        }
        if (x % 4 == 1) {
            return 1;
        }
        if (x % 4 == 2) {
            return x + 1;
        }
        return 0;
    }

    int xorOperation(int n, int start) {
        int s = start >> 1, e = n & start & 1;
        int ret = sumXor(s - 1) ^ sumXor(s + n - 1);
        return ret << 1 | e;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int xorOperation(int n, int start) {
        int s = start >> 1, e = n & start & 1;
        int ret = sumXor(s - 1) ^ sumXor(s + n - 1);
        return ret << 1 | e;
    }

    public int sumXor(int x) {
        if (x % 4 == 0) {
            return x;
        }
        if (x % 4 == 1) {
            return 1;
        }
        if (x % 4 == 2) {
            return x + 1;
        }
        return 0;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int XorOperation(int n, int start) {
        int s = start >> 1, e = n & start & 1;
        int ret = SumXor(s - 1) ^ SumXor(s + n - 1);
        return ret << 1 | e;
    }

    public int SumXor(int x) {
        if (x % 4 == 0) {
            return x;
        }
        if (x % 4 == 1) {
            return 1;
        }
        if (x % 4 == 2) {
            return x + 1;
        }
        return 0;
    }
}
```

```JavaScript [sol2-JavaScript]
var xorOperation = function(n, start) {
    let s = start >> 1, e = n & start & 1;
    let ret = sumXor(s - 1) ^ sumXor(s + n - 1);
    return ret << 1 | e;
};

const sumXor = (x) => {
    if (x % 4 === 0) {
        return x;
    }
    if (x % 4 === 1) {
        return 1;
    }
    if (x % 4 === 2) {
        return x + 1;
    }
    return 0;
}
```

```go [sol2-Golang]
func sumXor(x int) int {
    switch x % 4 {
    case 0:
        return x
    case 1:
        return 1
    case 2:
        return x + 1
    default:
        return 0
    }
}

func xorOperation(n, start int) (ans int) {
    s, e := start>>1, n&start&1
    ret := sumXor(s-1) ^ sumXor(s+n-1)
    return ret<<1 | e
}
```

```C [sol2-C]
int sumXor(int x) {
    if (x % 4 == 0) {
        return x;
    }
    if (x % 4 == 1) {
        return 1;
    }
    if (x % 4 == 2) {
        return x + 1;
    }
    return 0;
}

int xorOperation(int n, int start) {
    int s = start >> 1, e = n & start & 1;
    int ret = sumXor(s - 1) ^ sumXor(s + n - 1);
    return ret << 1 | e;
}
```

**复杂度分析**

- 时间复杂度：$O(1)$。我们只需要常数的时间计算出结果。

- 空间复杂度：$O(1)$。我们只需要常数的空间保存若干变量。
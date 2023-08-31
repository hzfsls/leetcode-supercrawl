## [693.交替位二进制数 中文官方题解](https://leetcode.cn/problems/binary-number-with-alternating-bits/solutions/100000/jiao-ti-wei-er-jin-zhi-shu-by-leetcode-s-bmxd)
#### 方法一：模拟

**思路**

从最低位至最高位，我们用对 $2$ 取模再除以 $2$ 的方法，依次求出输入的二进制表示的每一位，并与前一位进行比较。如果相同，则不符合条件；如果每次比较都不相同，则符合条件。

**代码**

```Python [sol1-Python3]
class Solution:
    def hasAlternatingBits(self, n: int) -> bool:
        prev = 2
        while n:
            cur = n % 2
            if cur == prev:
                return False
            prev = cur
            n //= 2
        return True
```

```Java [sol1-Java]
class Solution {
    public boolean hasAlternatingBits(int n) {
        int prev = 2;
        while (n != 0) {
            int cur = n % 2;
            if (cur == prev) {
                return false;
            }
            prev = cur;
            n /= 2;
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool HasAlternatingBits(int n) {
        int prev = 2;
        while (n != 0) {
            int cur = n % 2;
            if (cur == prev) {
                return false;
            }
            prev = cur;
            n /= 2;
        }
        return true;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool hasAlternatingBits(int n) {
        int prev = 2;
        while (n != 0) {
            int cur = n % 2;
            if (cur == prev) {
                return false;
            }
            prev = cur;
            n /= 2;
        }
        return true;
    }
};
```

```C [sol1-C]
bool hasAlternatingBits(int n) {
    int prev = 2;
    while (n != 0) {
        int cur = n % 2;
        if (cur == prev) {
            return false;
        }
        prev = cur;
        n /= 2;
    }
    return true;
} 
```

```go [sol1-Golang]
func hasAlternatingBits(n int) bool {
    for pre := 2; n != 0; n /= 2 {
        cur := n % 2
        if cur == pre {
            return false
        }
        pre = cur
    }
    return true
}
```

```JavaScript [sol1-JavaScript]
var hasAlternatingBits = function(n) {
    let prev = 2;
    while (n !== 0) {
        const cur = n % 2;
        if (cur === prev) {
            return false;
        }
        prev = cur;
        n = Math.floor(n / 2);
    }
    return true;
};
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。输入 $n$ 的二进制表示最多有 $O(\log n)$ 位。

- 空间复杂度：$O(1)$。使用了常数空间来存储中间变量。

#### 方法二：位运算

**思路**

对输入 $n$ 的二进制表示右移一位后，得到的数字再与 $n$ 按位异或得到 $a$。当且仅当输入 $n$ 为交替位二进制数时，$a$ 的二进制表示全为 $1$（不包括前导 $0$）。这里进行简单证明：当 $a$ 的某一位为 $1$ 时，当且仅当 $n$ 的对应位和其前一位相异。当 $a$ 的每一位为 $1$ 时，当且仅当 $n$ 的所有相邻位相异，即 $n$ 为交替位二进制数。

将 $a$ 与 $a + 1$ 按位与，当且仅当 $a$ 的二进制表示全为 $1$ 时，结果为 $0$。这里进行简单证明：当且仅当 $a$ 的二进制表示全为 $1$ 时，$a + 1$ 可以进位，并将原最高位置为 $0$，按位与的结果为 $0$。否则，不会产生进位，两个最高位都为 $1$，相与结果不为 $0$。

结合上述两步，可以判断输入是否为交替位二进制数。

**代码**

```Python [sol2-Python3]
class Solution:
    def hasAlternatingBits(self, n: int) -> bool:
        a = n ^ (n >> 1)
        return a & (a + 1) == 0
```

```Java [sol2-Java]
class Solution {
    public boolean hasAlternatingBits(int n) {
        int a = n ^ (n >> 1);
        return (a & (a + 1)) == 0;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool HasAlternatingBits(int n) {
        int a = n ^ (n >> 1);
        return (a & (a + 1)) == 0;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    bool hasAlternatingBits(int n) {
        long a = n ^ (n >> 1);
        return (a & (a + 1)) == 0;
    }
};
```

```C [sol2-C]
bool hasAlternatingBits(int n) {
    long a = n ^ (n >> 1);
    return (a & (a + 1)) == 0;
}
```

```go [sol2-Golang]
func hasAlternatingBits(n int) bool {
    a := n ^ n>>1
    return a&(a+1) == 0
}
```

```JavaScript [sol2-JavaScript]
var hasAlternatingBits = function(n) {
    const a = n ^ (n >> 1);
    return (a & (a + 1)) === 0;
};
```

**复杂度分析**

- 时间复杂度：$O(1)$。仅使用了常数时间来计算。

- 空间复杂度：$O(1)$。使用了常数空间来存储中间变量。
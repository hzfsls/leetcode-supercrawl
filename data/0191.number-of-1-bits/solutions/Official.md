## [191.位1的个数 中文官方题解](https://leetcode.cn/problems/number-of-1-bits/solutions/100000/wei-1de-ge-shu-by-leetcode-solution-jnwf)

#### 方法一：循环检查二进制位

**思路及解法**

我们可以直接循环检查给定整数 $n$ 的二进制位的每一位是否为 $1$。

具体代码中，当检查第 $i$ 位时，我们可以让 $n$ 与 $2^i$ 进行与运算，当且仅当 $n$ 的第 $i$ 位为 $1$ 时，运算结果不为 $0$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int hammingWeight(uint32_t n) {
        int ret = 0;
        for (int i = 0; i < 32; i++) {
            if (n & (1 << i)) {
                ret++;
            }
        }
        return ret;
    }
};
```

```Java [sol1-Java]
public class Solution {
    public int hammingWeight(int n) {
        int ret = 0;
        for (int i = 0; i < 32; i++) {
            if ((n & (1 << i)) != 0) {
                ret++;
            }
        }
        return ret;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def hammingWeight(self, n: int) -> int:
        ret = sum(1 for i in range(32) if n & (1 << i)) 
        return ret
```

```go [sol1-Golang]
func hammingWeight(num uint32) (ones int) {
    for i := 0; i < 32; i++ {
        if 1<<i&num > 0 {
            ones++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var hammingWeight = function(n) {
    let ret = 0;
    for (let i = 0; i < 32; i++) {
        if ((n & (1 << i)) !== 0) {
            ret++;
        }
    }
    return ret;
};
```

```C [sol1-C]
int hammingWeight(uint32_t n) {
    int ret = 0;
    for (int i = 0; i < 32; i++) {
        if (n & (1u << i)) {
            ret++;
        }
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(k)$，其中 $k$ 是 $\texttt{int}$ 型的二进制位数，$k=32$。我们需要检查 $n$ 的二进制位的每一位，一共需要检查 $32$ 位。

- 空间复杂度：$O(1)$，我们只需要常数的空间保存若干变量。

#### 方法二：位运算优化

**思路及解法**

观察这个运算：$n~\&~(n - 1)$，其运算结果恰为把 $n$ 的二进制位中的最低位的 $1$ 变为 $0$ 之后的结果。

如：$6~\&~(6-1) = 4, 6 = (110)_2, 4 = (100)_2$，运算结果 $4$ 即为把 $6$ 的二进制位中的最低位的 $1$ 变为 $0$ 之后的结果。

这样我们可以利用这个位运算的性质加速我们的检查过程，在实际代码中，我们不断让当前的 $n$ 与 $n - 1$ 做与运算，直到 $n$ 变为 $0$ 即可。因为每次运算会使得 $n$ 的最低位的 $1$ 被翻转，因此运算次数就等于 $n$ 的二进制位中 $1$ 的个数。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int hammingWeight(uint32_t n) {
        int ret = 0;
        while (n) {
            n &= n - 1;
            ret++;
        }
        return ret;
    }
};
```

```Java [sol2-Java]
public class Solution {
    public int hammingWeight(int n) {
        int ret = 0;
        while (n != 0) {
            n &= n - 1;
            ret++;
        }
        return ret;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def hammingWeight(self, n: int) -> int:
        ret = 0
        while n:
            n &= n - 1
            ret += 1
        return ret
```

```go [sol2-Golang]
func hammingWeight(num uint32) (ones int) {
    for ; num > 0; num &= num - 1 {
        ones++
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var hammingWeight = function(n) {
    let ret = 0;
    while (n) {
        n &= n - 1;
        ret++;
    }
    return ret;
};
```

```C [sol2-C]
int hammingWeight(uint32_t n) {
    int ret = 0;
    while (n) {
        n &= n - 1;
        ret++;
    }
    return ret;
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。循环次数等于 $n$ 的二进制位中 $1$ 的个数，最坏情况下 $n$ 的二进制位全部为 $1$。我们需要循环 $\log n$ 次。

- 空间复杂度：$O(1)$，我们只需要常数的空间保存若干变量。
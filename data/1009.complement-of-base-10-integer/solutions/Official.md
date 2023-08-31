## [1009.十进制整数的反码 中文官方题解](https://leetcode.cn/problems/complement-of-base-10-integer/solutions/100000/shi-jin-zhi-zheng-shu-de-fan-ma-by-leetc-vofe)

#### 方法一：位运算

**思路与算法**

根据题目的要求，我们需要将 $n$ 二进制表示的每一位取反。然而在计算机存储整数时，并不会仅仅存储有效的二进制位。例如当 $n = 5$ 时，它的二进制表示为 $(101)_2$，而使用 $32$ 位整数存储时的结果为：

$$
(0000~0000~0000~0000~0000~0000~0000~0101)_2
$$

因此我们需要首先找到 $n$ 二进制表示最高位的那个 $1$，再将这个 $1$ 以及更低的位进行取反。

如果 $n$ 二进制表示最高位的 $1$ 是第 $i~(0 \leq i \leq 30)$ 位，那么一定有：

$$
2^i \leq n < 2^{i+1}
$$

因此我们可以使用一次遍历，在 $[0, 30]$ 中找出 $i$ 的值。

在这之后，我们就可以遍历 $n$ 的第 $0 \sim i$ 个二进制位，将它们依次进行取反。我们也可以用更高效的方式，构造掩码 $\textit{mask} = 2^{i+1} - 1$，它是一个 $i+1$ 位的二进制数，并且每一位都是 $1$。我们将 $n$ 与 $\textit{mask}$ 进行异或运算，即可得到答案。

**细节**

当 $i=30$ 时，构造 $\textit{mask} = 2^{i+1} - 1$ 的过程中需要保证不会产生整数溢出。下面部分语言的代码中对该情况进行了特殊判断。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int bitwiseComplement(int n) {
        int highbit = 0;
        for (int i = 1; i <= 30; ++i) {
            if (n >= (1 << i)) {
                highbit = i;
            }
            else {
                break;
            }            
        }
        int mask = (highbit == 30 ? 0x7fffffff : (1 << (highbit + 1)) - 1);
        return n ^ mask;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int bitwiseComplement(int n) {
        int highbit = 0;
        for (int i = 1; i <= 30; ++i) {
            if (n >= 1 << i) {
                highbit = i;
            } else {
                break;
            }            
        }
        int mask = highbit == 30 ? 0x7fffffff : (1 << (highbit + 1)) - 1;
        return n ^ mask;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int BitwiseComplement(int n) {
        int highbit = 0;
        for (int i = 1; i <= 30; ++i) {
            if (n >= 1 << i) {
                highbit = i;
            } else {
                break;
            }            
        }
        int mask = highbit == 30 ? 0x7fffffff : (1 << (highbit + 1)) - 1;
        return n ^ mask;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def bitwiseComplement(self, n: int) -> int:
        highbit = 0
        for i in range(1, 30 + 1):
            if n >= (1 << i):
                highbit = i
            else:
                break
        
        mask = (1 << (highbit + 1)) - 1
        return n ^ mask
```

```JavaScript [sol1-JavaScript]
var bitwiseComplement = function(n) {
    let highbit = 0;
    for (let i = 1; i <= 30; ++i) {
        if (n >= 1 << i) {
            highbit = i;
        } else {
            break;
        }            
    }
    const mask = highbit == 30 ? 0x7fffffff : (1 << (highbit + 1)) - 1;
    return n ^ mask;
};
```

```go [sol1-Golang]
func bitwiseComplement(n int) int {
    highBit := 0
    for i := 1; i <= 30; i++ {
        if n < 1<<i {
            break
        }
        highBit = i
    }
    mask := 1<<(highBit+1) - 1
    return n ^ mask
}
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。找出 $n$ 二进制表示最高位的 $1$ 需要的时间为 $O(\log n)$。

- 空间复杂度：$O(1)$。
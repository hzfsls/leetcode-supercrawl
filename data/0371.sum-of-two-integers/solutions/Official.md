## [371.两整数之和 中文官方题解](https://leetcode.cn/problems/sum-of-two-integers/solutions/100000/liang-zheng-shu-zhi-he-by-leetcode-solut-c1s3)
### 📺 视频题解  
![371.两整数之和-仲耀晖.mp4](2c177210-86d6-46ef-a3c3-4779c339d456)

### 📖 文字题解
#### 方法一：位运算

**预备知识**

有符号整数通常用补码来表示和存储，补码具有如下特征：

- 正整数的补码与原码相同；负整数的补码为其原码除符号位外的所有位取反后加 $1$。

- 可以将减法运算转化为补码的加法运算来实现。

- 符号位与数值位可以一起参与运算。

**思路和算法**

虽然题目只要求了不能使用运算符 $\texttt{+}$ 和 $\texttt{-}$，但是原则上来说也不宜使用类似的运算符 $\texttt{+=}$ 和 $\texttt{-=}$ 以及 $\texttt{sum}$ 等方法。于是，我们使用位运算来处理这个问题。

首先，考虑两个二进制位相加的四种情况如下：

```
0 + 0 = 0
0 + 1 = 1
1 + 0 = 1
1 + 1 = 0 (进位)
```

可以发现，对于整数 $a$ 和 $b$：

- 在不考虑进位的情况下，其**无进位加法结果**为 $\texttt{a} \oplus \texttt{b}$。

- 而所有需要进位的位为 $\texttt{a \& b}$，进位后的**进位结果**为 $\texttt{(a \& b) << 1}$。

于是，我们可以将整数 $a$ 和 $b$ 的和，拆分为 $a$ 和 $b$ 的**无进位加法结果**与**进位结果**的和。因为每一次拆分都可以让需要进位的最低位至少左移一位，又因为 $a$ 和 $b$ 可以取到负数，所以我们最多需要 $\log (max\_int)$ 次拆分即可完成运算。

因为有符号整数用补码来表示，所以以上算法也可以推广到 $0$ 和负数。

**实现**

在 $\texttt{C++}$ 的实现中，当我们赋给带符号类型一个超出它表示范围的值时，结果是 $\text{undefined}$；而当我们赋给无符号类型一个超出它表示范围的值时，结果是初始值对无符号类型表示数值总数取模的余数。因此，我们可以使用无符号类型来防止溢出。

在 $\texttt{Python}$ 的实现中，因为 $\texttt{Python}$ 的整数类型为是无限长的，所以无论怎样左移位都不会溢出。因此，我们需要对 $\texttt{Python}$ 中的整数进行额外处理，以模拟用补码表示的 $32$ 位有符号整数类型。具体地，我们将整数对 $2^{32}$ 取模，从而使第 $33$ 位及更高位均为 $0$；因为此时最终结果为用补码表示的包含符号位的 $32$ 位整数，所以我们还需要再次将其换算为 $\texttt{Python}$ 的整数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int getSum(int a, int b) {
        while (b != 0) {
            unsigned int carry = (unsigned int)(a & b) << 1;
            a = a ^ b;
            b = carry;
        }
        return a;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int getSum(int a, int b) {
        while (b != 0) {
            int carry = (a & b) << 1;
            a = a ^ b;
            b = carry;
        }
        return a;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int GetSum(int a, int b) {
        while (b != 0) {
            int carry = (a & b) << 1;
            a = a ^ b;
            b = carry;
        }
        return a;
    }
}
```

```Python [sol1-Python3]
MASK1 = 4294967296  # 2^32
MASK2 = 2147483648  # 2^31
MASK3 = 2147483647  # 2^31-1

class Solution:
    def getSum(self, a: int, b: int) -> int:
        a %= MASK1
        b %= MASK1
        while b != 0:
            carry = ((a & b) << 1) % MASK1
            a = (a ^ b) % MASK1
            b = carry
        if a & MASK2:  # 负数
            return ~((a ^ MASK2) ^ MASK3)
        else:  # 正数
            return a
```

```JavaScript [sol1-JavaScript]
var getSum = function(a, b) {
    while (b != 0) {
        const carry = (a & b) << 1;
        a = a ^ b;
        b = carry;
    }
    return a;
};
```

```go [sol1-Golang]
func getSum(a, b int) int {
    for b != 0 {
        carry := uint(a&b) << 1
        a ^= b
        b = int(carry)
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(\log (max\_int))$，其中我们将执行位运算视作原子操作。

- 空间复杂度：$O(1)$。
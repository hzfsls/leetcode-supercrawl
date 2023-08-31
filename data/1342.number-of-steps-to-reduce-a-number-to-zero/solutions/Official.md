## [1342.将数字变成 0 的操作次数 中文官方题解](https://leetcode.cn/problems/number-of-steps-to-reduce-a-number-to-zero/solutions/100000/jiang-shu-zi-bian-cheng-0-de-cao-zuo-ci-ucaa4)

#### 方法一：模拟

**思路与算法**

将 $\textit{num}$ 与 $1$ 进行位运算来判断 $\textit{num}$ 的奇偶性。

记录操作次数时：

* 如果 $\textit{num}$ 是奇数，我们需要加上一次减 $1$ 的操作。

* 如果 $\textit{num} > 1$，我们需要加上一次除以 $2$ 的操作。

然后使 $\textit{num}$ 的值变成 $\Big\lfloor\dfrac{\textit{num}}{2}\Big\rfloor$。重复以上操作直到 $\textit{num} = 0$ 时结束操作。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int numberOfSteps(int num) {
        int ret = 0;
        while (num) {
            ret += (num > 1 ? 1 : 0) + (num & 0x01);
            num >>= 1;
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numberOfSteps(int num) {
        int ret = 0;
        while (num > 0) {
            ret += (num > 1 ? 1 : 0) + (num & 0x01);
            num >>= 1;
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumberOfSteps(int num) {
        int ret = 0;
        while (num > 0) {
            ret += (num > 1 ? 1 : 0) + (num & 0x01);
            num >>= 1;
        }
        return ret;
    }
}
```

```C [sol1-C]
int numberOfSteps(int num) {
    int ret = 0;
    while (num) {
        ret += (num > 1 ? 1 : 0) + (num & 0x01);
        num >>= 1;
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var numberOfSteps = function(num) {
    let ret = 0;
    while (num > 0) {
        ret += (num > 1 ? 1 : 0) + (num & 0x01);
        num >>= 1;
    }
    return ret;
};
```

```go [sol1-Golang]
func numberOfSteps(num int) (ans int) {
    for ; num > 0; num >>= 1 {
        ans += num & 1
        if num > 1 {
            ans++
        }
    }
    return
}
```

```Python [sol1-Python3]
class Solution:
    def numberOfSteps(self, num: int) -> int:
        ans = 0
        while num:
            ans += num & 1
            if num > 1:
                ans += 1
            num >>= 1
        return ans
```

**复杂度分析**

+ 时间复杂度：$O(\log \textit{num})$，其中 $\textit{num}$ 是输入数值。每次循环都将 $num$ 的数值减半，因此时间复杂度为 $O(\log \textit{num})$。

+ 空间复杂度：$O(1)$。只需要常数空间。

#### 方法二：直接计算

**思路与算法**

由方法一的步骤可知，当 $\textit{num} > 0$ 时，总操作次数等于总减 $1$ 的操作数与总除以 $2$ 的操作数之和。总减 $1$ 的操作数等于 $\textit{num}$ 二进制位 $1$ 的个数，总除以 $2$ 的操作数等于 $\textit{num}$ 二进制数长度减 $1$，即最高位右移到最低位的距离。

二进制数长度 $\textit{len}$ 可以通过前导零数目 $\textit{clz}$ 间接求解，即 $\textit{len} = W - clz$，其中 $W = 32$ 是 $\texttt{int}$ 类型的位数。

C++ 等语言可以用 `__builtin_clz` 和 `__builtin_popcount` 这类函数来求出二进制前导零数目和二进制位 $1$ 的个数，下面介绍其原理及实现。

使用二分法加速求解前导零数目，算法如下：

> 首先判断 $\textit{num}$ 前半部分是否全为零，如果是，则将 $\textit{clz}$ 加上前半部分的长度，然后将后半部分作为处理对象，否则将前半部分作为处理对象。重复以上操作直到处理的对象长度为 $1$，直接判断是否有零，有则将 $\textit{clz}$ 加 $1$。

使用分治法来加速求解二进制数位 $1$ 的个数，算法如下：

> 对二进制数 $\textit{num}$，它的位 $1$ 的个数等于所有位的值相加的结果，比如 $10110101_{(2)} = 1 + 0 + 1 + 1 + 0 + 1 + 0 + 1$。我们可以将 $8$ 个位的求和分解成 $4$ 个相邻的位的求和，然后将 $4$ 个中间结果分解成 $2$ 个相邻的求和，即 $10110101_{(2)} = (1 + 0) + (1 + 1) + (0 + 1) + (0 + 1) = ((1 + 0) + (1 + 1)) + ((0 + 1) + (0 + 1)) = 5$。$32$ 位数的求解过程同理。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int length(uint num) {
        uint clz = 0;
        if ((num >> 16) == 0) {
            clz += 16;
            num <<= 16;
        }
        if ((num >> 24) == 0) {
            clz += 8;
            num <<= 8;
        }
        if ((num >> 28) == 0) {
            clz += 4;
            num <<= 4;
        }
        if ((num >> 30) == 0) {
            clz += 2;
            num <<= 2;
        }
        if ((num >> 31) == 0) {
            clz += 1;
        }
        return 32 - clz;
    }

    int count(int num) {
        num = (num & 0x55555555) + ((num >> 1) & 0x55555555);
        num = (num & 0x33333333) + ((num >> 2) & 0x33333333);
        num = (num & 0x0F0F0F0F) + ((num >> 4) & 0x0F0F0F0F);
        num = (num & 0x00FF00FF) + ((num >> 8) & 0x00FF00FF);
        num = (num & 0x0000FFFF) + ((num >> 16) & 0x0000FFFF);
        return num;
    }

    int numberOfSteps(int num) {
        return num == 0 ? 0 : length(num) - 1 + count(num);
    }
};
```

```Java [sol2-Java]
class Solution {
    public int numberOfSteps(int num) {
        return num == 0 ? 0 : length(num) - 1 + count(num);
    }

    public int length(int num) {
        int clz = 0;
        if ((num >> 16) == 0) {
            clz += 16;
            num <<= 16;
        }
        if ((num >> 24) == 0) {
            clz += 8;
            num <<= 8;
        }
        if ((num >> 28) == 0) {
            clz += 4;
            num <<= 4;
        }
        if ((num >> 30) == 0) {
            clz += 2;
            num <<= 2;
        }
        if ((num >> 31) == 0) {
            clz += 1;
        }
        return 32 - clz;
    }

    public int count(int num) { 
        num = (num & 0x55555555) + ((num >> 1) & 0x55555555);
        num = (num & 0x33333333) + ((num >> 2) & 0x33333333);
        num = (num & 0x0F0F0F0F) + ((num >> 4) & 0x0F0F0F0F);
        num = (num & 0x00FF00FF) + ((num >> 8) & 0x00FF00FF);
        num = (num & 0x0000FFFF) + ((num >> 16) & 0x0000FFFF);
        return num;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int NumberOfSteps(int num) {
        return num == 0 ? 0 : Length(num) - 1 + Count(num);
    }

    public int Length(int num) {
        int clz = 0;
        if ((num >> 16) == 0) {
            clz += 16;
            num <<= 16;
        }
        if ((num >> 24) == 0) {
            clz += 8;
            num <<= 8;
        }
        if ((num >> 28) == 0) {
            clz += 4;
            num <<= 4;
        }
        if ((num >> 30) == 0) {
            clz += 2;
            num <<= 2;
        }
        if ((num >> 31) == 0) {
            clz += 1;
        }
        return 32 - clz;
    }

    public int Count(int num) { 
        num = (num & 0x55555555) + ((num >> 1) & 0x55555555);
        num = (num & 0x33333333) + ((num >> 2) & 0x33333333);
        num = (num & 0x0F0F0F0F) + ((num >> 4) & 0x0F0F0F0F);
        num = (num & 0x00FF00FF) + ((num >> 8) & 0x00FF00FF);
        num = (num & 0x0000FFFF) + ((num >> 16) & 0x0000FFFF);
        return num;
    }
}
```

```C [sol2-C]
int length(uint num) {
    uint clz = 0;
    if ((num >> 16) == 0) {
        clz += 16;
        num <<= 16;
    }
    if ((num >> 24) == 0) {
        clz += 8;
        num <<= 8;
    }
    if ((num >> 28) == 0) {
        clz += 4;
        num <<= 4;
    }
    if ((num >> 30) == 0) {
        clz += 2;
        num <<= 2;
    }
    if ((num >> 31) == 0) {
        clz += 1;
    }
    return 32 - clz;
}

int count(int num) {
    num = (num & 0x55555555) + ((num >> 1) & 0x55555555);
    num = (num & 0x33333333) + ((num >> 2) & 0x33333333);
    num = (num & 0x0F0F0F0F) + ((num >> 4) & 0x0F0F0F0F);
    num = (num & 0x00FF00FF) + ((num >> 8) & 0x00FF00FF);
    num = (num & 0x0000FFFF) + ((num >> 16) & 0x0000FFFF);
    return num;
}

int numberOfSteps(int num) {
    return num == 0 ? 0 : length(num) - 1 + count(num);
}
```

```go [sol2-Golang]
func bitsLen(x uint) int {
    clz := 0
    if x>>16 == 0 {
        clz += 16
        x <<= 16
    }
    if x>>24 == 0 {
        clz += 8
        x <<= 8
    }
    if x>>28 == 0 {
        clz += 4
        x <<= 4
    }
    if x>>30 == 0 {
        clz += 2
        x <<= 2
    }
    if x>>31 == 0 {
        clz++
    }
    return 32 - clz
}

func onesCount(num uint) int {
    num = num&0x55555555 + num>>1&0x55555555
    num = num&0x33333333 + num>>2&0x33333333
    num = num&0x0F0F0F0F + num>>4&0x0F0F0F0F
    num = num&0x00FF00FF + num>>8&0x00FF00FF
    num = num&0x0000FFFF + num>>16&0x0000FFFF
    return int(num)
}

func numberOfSteps(num int) (ans int) {
    if num == 0 {
        return 0
    }
    return bitsLen(uint(num)) - 1 + onesCount(uint(num))
}
```

```Python [sol2-Python3]
def length(num: int) -> int:
    clz = 0
    if (num >> 16) == 0:
        clz += 16
        num <<= 16
    if (num >> 24) == 0:
        clz += 8
        num <<= 8
    if (num >> 28) == 0:
        clz += 4
        num <<= 4
    if (num >> 30) == 0:
        clz += 2
        num <<= 2
    if (num >> 31) == 0:
        clz += 1
    return 32 - clz

def count(num: int) -> int:
    num = (num & 0x55555555) + ((num >> 1) & 0x55555555)
    num = (num & 0x33333333) + ((num >> 2) & 0x33333333)
    num = (num & 0x0F0F0F0F) + ((num >> 4) & 0x0F0F0F0F)
    num = (num & 0x00FF00FF) + ((num >> 8) & 0x00FF00FF)
    num = (num & 0x0000FFFF) + ((num >> 16) & 0x0000FFFF)
    return num

class Solution:
    def numberOfSteps(self, num: int) -> int:
        return length(num) - 1 + count(num) if num else 0
```

**复杂度分析**

+ 时间复杂度：$O(\log W)$，其中 $W = 32$ 是 $\texttt{int}$ 类型的位数。计算二进制长度算法的时间复杂度为 $O(\log W)$；统计二进制数位 $1$ 的个数算法的时间复杂度为 $O(\log W)$。

+ 空间复杂度：$O(1)$。只需要常数空间。
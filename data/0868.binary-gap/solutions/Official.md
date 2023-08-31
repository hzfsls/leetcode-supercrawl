## [868.二进制间距 中文官方题解](https://leetcode.cn/problems/binary-gap/solutions/100000/er-jin-zhi-jian-ju-by-leetcode-solution-dh2q)

#### 方法一：位运算

**思路与算法**

我们可以使用一个循环从 $n$ 二进制表示的低位开始进行遍历，并找出所有的 $1$。我们用一个变量 $\textit{last}$ 记录上一个找到的 $1$ 的位置。如果当前在第 $i$ 位找到了 $1$，那么就用 $i - \textit{last}$ 更新答案，再将 $\textit{last}$ 更新为 $i$ 即可。

在循环的每一步中，我们可以使用位运算 $\texttt{n \& 1}$ 获取 $n$ 的最低位，判断其是否为 $1$。在这之后，我们将 $n$ 右移一位：$\texttt{n = n >> 1}$，这样在第 $i$ 步时，$\texttt{n \& 1}$ 得到的就是初始 $n$ 的第 $i$ 个二进制位。

**代码**

```Python [sol1-Python3]
class Solution:
    def binaryGap(self, n: int) -> int:
        last, ans, i = -1, 0, 0
        while n:
            if n & 1:
                if last != -1:
                    ans = max(ans, i - last)
                last = i
            n >>= 1
            i += 1
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int binaryGap(int n) {
        int last = -1, ans = 0;
        for (int i = 0; n; ++i) {
            if (n & 1) {
                if (last != -1) {
                    ans = max(ans, i - last);
                }
                last = i;
            }
            n >>= 1;
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int binaryGap(int n) {
        int last = -1, ans = 0;
        for (int i = 0; n != 0; ++i) {
            if ((n & 1) == 1) {
                if (last != -1) {
                    ans = Math.max(ans, i - last);
                }
                last = i;
            }
            n >>= 1;
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int BinaryGap(int n) {
        int last = -1, ans = 0;
        for (int i = 0; n != 0; ++i) {
            if ((n & 1) == 1) {
                if (last != -1) {
                    ans = Math.Max(ans, i - last);
                }
                last = i;
            }
            n >>= 1;
        }
        return ans;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int binaryGap(int n) {
    int last = -1, ans = 0;
    for (int i = 0; n; ++i) {
        if (n & 1) {
            if (last != -1) {
                ans = MAX(ans, i - last);
            }
            last = i;
        }
        n >>= 1;
    }
    return ans;
}
```

```go [sol1-Golang]
func binaryGap(n int) (ans int) {
    for i, last := 0, -1; n > 0; i++ {
        if n&1 == 1 {
            if last != -1 {
                ans = max(ans, i-last)
            }
            last = i
        }
        n >>= 1
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var binaryGap = function(n) {
    let last = -1, ans = 0;
    for (let i = 0; n != 0; ++i) {
        if ((n & 1) === 1) {
            if (last !== -1) {
                ans = Math.max(ans, i - last);
            }
            last = i;
        }
        n >>= 1;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(\log n)$。循环中的每一步 $n$ 会减少一半，因此需要 $O(\log n)$ 次循环。

- 空间复杂度：$O(1)$。
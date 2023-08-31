## [1864.构成交替字符串需要的最小交换次数 中文官方题解](https://leetcode.cn/problems/minimum-number-of-swaps-to-make-the-binary-string-alternating/solutions/100000/minimum-number-of-swaps-to-make-the-bina-z0qy)
#### 方法一：枚举目标字符串的形式

**提示 $1$**

符合要求的交替字符串的形式只有两种：

1. 形如 $\texttt{"1010..."}$ 的字符串，奇数位为 $\texttt{`0'}$，偶数位为 $\texttt{`1'}$；

2. 形如 $\texttt{"0101..."}$ 的字符串，奇数位为 $\texttt{`1'}$，偶数位为 $\texttt{`0'}$。

**提示 $2$**

二进制源字符串 $s_1$ 和目标字符串 $s_2$ 可以通过交换操作互相转化，当且仅当两个字符串中 $\texttt{`0'}$ 和 $\texttt{`1'}$ 的个数均相等。

**提示 $3$**

假设 $s_1$ 和 $s_2$ 可以通过交换操作互相转化，且它们有 $k$ 个位置不同，那么最小的交换次数为 $k/2$。

**提示 $3$ 解释**

首先，交换 $k$ 个字符使得新结果与原结果**不同**的下界为 $k/2$。下面我们证明这个下界是可以达到的。

不妨假设 $s_1$ 与 $s_2$ 中 $\texttt{`0'}$ 和 $\texttt{`1'}$ 的个数为 $n_0$ 与 $n_1$，对应下标字符分别为 $i$ 和 $j$ 的下标数量为 $n_{ij}$。那么我们有

$$
n_{00} + n_{01} = n_{00} + n_{10} = n_0,
$$

$$
n_{10} + n_{11} = n_{01} + n_{11} = n_1,
$$

也就是说

$$
n_{10} = n_{01} = \frac{k}{2}.
$$

那么，为了使 $s_1$ 与 $s_2$ 一致，我们只需要将 $s_1$ 中对应的 $n_{10}$ 个 $\texttt{`1'}$ 与 $n_{01}$ 个 $\texttt{`0'}$ 两两交换即可。此时所需的交换次数最少，为 $k/2$。 

**思路与算法**

根据 **提示 $1$**，我们枚举两种交替字符串的形式，并根据 **提示 $2$** 判断 $\texttt{`0'}$ 和 $\texttt{`1'}$ 的个数是否相等。如果相等，我们可以计算出 $s$ 与上述目标字符串不同的位数 $\texttt{diff}_1$ 和 $\texttt{diff}_2$。此时根据 **提示 $3$**，对应的最少交换次数即为 $\texttt{diff}_1 / 2$ 和 $\texttt{diff}_2 / 2$。

最终，我们取两种情况的较小值作为答案返回；若两种情况均不满足，则返回 $-1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minSwaps(string s) {
        int n = s.size();
        int n0 = count(s.begin(), s.end(), '0');
        int n1 = count(s.begin(), s.end(), '1');
        int res = INT_MAX;
        // "1010..."
        if (n1 == (n + 1) / 2 && n0 == n / 2){   // 不同字符个数相等
            int diff1 = 0;
            for (int i = 0; i < n; ++i){
                if (s[i] - '0' == i % 2){   // 对应位数不同
                    ++diff1;
                }
            }
            res = min(res, diff1 / 2);
        }
        // "0101..."
        if (n0 == (n + 1) / 2 && n1 == n / 2){   // 不同字符个数相等
            int diff2 = 0;
            for (int i = 0; i < n; ++i){
                if (s[i] - '0' != i % 2){   // 对应位数不同
                    ++diff2;
                }
            }
            res = min(res, diff2 / 2);
        }
        if (res == INT_MAX){
            return -1;   // 不存在
        }
        else {
            return res;
        }
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minSwaps(self, s: str) -> int:
        n = len(s)
        n0, n1 = s.count('0'), s.count('1')
        res = float("INF")
        # "1010..."
        if n1 == (n + 1) // 2 and n0 == n // 2:   # 不同字符个数相等
            diff1 = 0
            for i in range(n):
                if int(s[i]) == i % 2:   # 对应位数不同
                    diff1 += 1
            res = min(res, diff1 // 2)
        # "0101..."
        if n0 == (n + 1) // 2 and n1 == n // 2:   # 不同字符个数相等
            diff2 = 0
            for i in range(n):
                if int(s[i]) != i % 2:   # 对应位数不同
                    diff2 += 1
            res = min(res, diff2 // 2)
        if res == float("INF"):
            return -1   # 不存在
        else:
            return res
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $s$ 的长度。计算 $n_0$ 与 $n_1$ 的时间复杂度为 $O(n)$；每次枚举目标字符串并计算可能交换次数的时间复杂度也为 $O(n)$，而目标字符串共有两种。

- 空间复杂度：$O(1)$，我们只使用了常数个额外变量。
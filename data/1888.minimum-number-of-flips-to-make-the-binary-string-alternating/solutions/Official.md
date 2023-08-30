#### 方法一：分析 + 前缀和 + 后缀和

**提示 $1$**

我们可以将所有类型 $2$ 的操作安排在类型 $1$ 的操作之前。

**提示 $1$ 解释**

由于类型 $2$ 的操作是反转任意一个字符，而类型 $1$ 的操作只会改变字符的相对顺序，不会改变字符的值。因此如果我们想要修改某个字符，随时都可以修改。这样我们就可以把所有类型 $2$ 的操作安排到最前面。

**提示 $2$**

设字符串 $s$ 的长度为 $n$。

如果 $n$ 是偶数，那么在所有类型 $2$ 的操作完成后，$s$ 已经是一个交替字符串了。

**提示 $2$ 解释**

当 $n$ 是偶数时，交替字符串只可能为 $0101\cdots 01$ 或者 $1010 \cdots 10$ 的形式。对这两个字符串进行类型 $2$ 的操作，只会在它们之间相互转换。

类型 $2$ 的操作是可逆的，这说明交替字符串只可能由交替字符串通过类型 $2$ 的操作得来。因此，在所有类型 $2$ 的操作完成后，$s$ 必须是一个交替字符串。

**提示 $3$**

如果 $n$ 是奇数，那么交替字符串为 $0101 \cdots 010$ 或者 $1010 \cdots 101$ 的形式。

我们首先考虑 $0101 \cdots 010$，如果在所有类型 $2$ 的操作完成后，$s$ 可以通过类型 $2$ 的操作得到该字符串，那么：

- 要么 $s$ 就是 $0101 \cdots 010$；

- 要么 $s$ 是 $01 \cdots 010 | 01 \cdots 01$ 的形式，或者是 $10 \cdots 10|01 \cdots 010$ 的形式。这里我们用竖线 $|$ 标注了类型 $2$ 的操作，在 $|$ 左侧的字符通过类型 $2$ 的操作被移动到字符串的末尾，最终可以得到 $0101 \cdots 010$。

因此，$s$ 要么是一个交替字符串（即 $0101 \cdots 010$），要么由两个交替字符串拼接而成，其中左侧的交替字符串以 $0$ 结尾，右侧的交替字符串以 $0$ 开头。

同理，如果我们考虑 $1010 \cdots 101$，那么 $s$ 要么就是 $1010 \cdots 101$，要么由两个交替字符串拼接而成，其中左侧的交替字符串以 $1$ 结尾，右侧的交替字符串以 $1$ 开头。

**思路与算法**

我们用 $\textit{pre}[i][j]$ 表示对于字符串的前缀 $s[0..i]$，如果我们希望通过类型 $2$ 的操作修改成「以 $j$ 结尾的交替字符串」，那么**最少**需要的操作次数。这里 $j$ 的取值为 $0$ 或 $1$。根据定义，有递推式：

$$
\begin{cases}
\textit{pre}[i][0] = \textit{pre}[i-1][1] + \mathbb{I}(s[i], 1) \\
\textit{pre}[i][1] = \textit{pre}[i-1][0] + \mathbb{I}(s[i], 0)
\end{cases}
$$

其中 $\mathbb{I}(x, y)$ 为示性函数，如果 $x=y$，那么函数值为 $1$，否则为 $0$。例如 $\mathbb{I}(s[i], 1)$ 就表示：如果 $s[i]$ 为 $1$，那么我们需要通过类型 $2$ 的操作将其修改为 $0$，否则无需操作。

同理，我们用 $\textit{suf}[i][j]$ 表示对于字符串的后缀 $s[i..n-1]$，如果我们希望通过类型 $2$ 的操作修改成「以 $j$ 开头的交替字符串」，那么**最少**需要的操作次数。这里 $j$ 的取值为 $0$ 或 $1$，同样有递推式：

$$
\begin{cases}
\textit{suf}[i][0] = \textit{suf}[i+1][1] + \mathbb{I}(s[i], 1) \\
\textit{suf}[i][1] = \textit{suf}[i+1][0] + \mathbb{I}(s[i], 0)
\end{cases}
$$

在求解完数组 $\textit{pre}$ 和 $\textit{suf}$ 后：

- 答案可以为 $\textit{pre}[n-1][0]$ 或者 $\textit{pre}[n-1][1]$，对应着将 $s$ 本身变为一个交替字符串；

- 如果 $n$ 是奇数，那么答案还可以为 $\textit{pre}[i][0] + \textit{suf}[i+1][0]$ 以及 $\textit{pre}[i][1] + \textit{suf}[i+1][1]$，对应着将 $s$ 变为两个交替字符串的拼接。

所有可供选择的答案中的最小值即为类型 $2$ 的操作的最少次数。

**细节**

如果 $n$ 是偶数，我们无需求出 $\textit{suf}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minFlips(string s) {
        // 示性函数
        auto I = [](char ch, int x) -> int {
            return ch - '0' == x;
        };
        
        int n = s.size();
        vector<vector<int>> pre(n, vector<int>(2));
        // 注意 i=0 的边界情况
        for (int i = 0; i < n; ++i) {
            pre[i][0] = (i == 0 ? 0 : pre[i - 1][1]) + I(s[i], 1);
            pre[i][1] = (i == 0 ? 0 : pre[i - 1][0]) + I(s[i], 0);
        }
        
        int ans = min(pre[n - 1][0], pre[n - 1][1]);
        if (n % 2 == 1) {
            // 如果 n 是奇数，还需要求出 suf
            vector<vector<int>> suf(n, vector<int>(2));
            // 注意 i=n-1 的边界情况
            for (int i = n - 1; i >= 0; --i) {
                suf[i][0] = (i == n - 1 ? 0 : suf[i + 1][1]) + I(s[i], 1);
                suf[i][1] = (i == n - 1 ? 0 : suf[i + 1][0]) + I(s[i], 0);
            }
            for (int i = 0; i + 1 < n; ++i) {
                ans = min(ans, pre[i][0] + suf[i + 1][0]);
                ans = min(ans, pre[i][1] + suf[i + 1][1]);
            }
        }
        
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minFlips(self, s: str) -> int:
        # 示性函数
        I = lambda ch, x: int(ord(ch) - ord("0") == x)
        
        n = len(s)
        pre = [[0, 0] for _ in range(n)]
        # 注意 i=0 的边界情况
        for i in range(n):
            pre[i][0] = (0 if i == 0 else pre[i - 1][1]) + I(s[i], 1)
            pre[i][1] = (0 if i == 0 else pre[i - 1][0]) + I(s[i], 0)
        
        ans = min(pre[n - 1][0], pre[n - 1][1])
        if n % 2 == 1:
            # 如果 n 是奇数，还需要求出 suf
            suf = [[0, 0] for _ in range(n)]
            # 注意 i=n-1 的边界情况
            for i in range(n - 1, -1, -1):
                suf[i][0] = (0 if i == n - 1 else suf[i + 1][1]) + I(s[i], 1)
                suf[i][1] = (0 if i == n - 1 else suf[i + 1][0]) + I(s[i], 0)
            
            for i in range(n - 1):
                ans = min(ans, pre[i][0] + suf[i + 1][0])
                ans = min(ans, pre[i][1] + suf[i + 1][1])
        
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(n)$，即为数组 $\textit{pre}$ 和 $\textit{suf}$ 需要使用的空间。我们可以将空间复杂度优化至 $O(1)$，但这样写出的代码并不直观，因此本题解中不给出空间复杂度最优的写法。
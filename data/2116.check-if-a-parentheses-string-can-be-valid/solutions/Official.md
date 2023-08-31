## [2116.判断一个括号字符串是否有效 中文官方题解](https://leetcode.cn/problems/check-if-a-parentheses-string-can-be-valid/solutions/100000/pan-duan-yi-ge-gua-hao-zi-fu-chuan-shi-f-0s47)

#### 方法一：数学

**思路与算法**

我们可以如下定义并计算一个括号字符串的「分数」：

> 考虑一个初值为 $0$ 的整数，遍历该字符串，如果遇到左括号，则将该整数加上 $1$，如果遇到右括号，则将该整数减去 $1$。最终得到的数值即为括号字符串的分数。

那么，根据有效括号字符串的定义，我们可以利用「分数」的概念给出该定义的**等价条件**：

> 该字符串的分数为 $0$，且该字符串**任意前缀**的分数均大于等于 $0$。

读者可以自行尝试证明上述两个条件的等价性。

我们同样可以用「分数」的概念判断一个部分可变的括号字符串 $s$ 能否变为有效字符串。

为叙述方便，我们首先给出「有效前缀」的定义：

> 如果括号字符串的某个前缀字符串满足它本身及它的所有前缀的分数均大于等于 $0$，则称该前缀为有效前缀。

可以看出，一个有效括号字符串的任意前缀均为「有效前缀」。

我们可以对字符串 $s$，定义对应的最大分数数组 $\textit{mx}$ 和最小有效分数数组 $\textit{mn}$。具体地：

- $\textit{mx}[i + 1]$ 代表前缀 $s[0..i]$ **可以达到的最大分数**；

- $\textit{mn}[i + 1]$ 为前缀 $s[0..i]$ **可以达到的最小分数**及**作为有效前缀所需的最小分数**两者的**较大值**。

  其中「作为有效前缀所需的最小分数」的取值，由于字符串分数的奇偶性一定与字符串长度的**奇偶性相同**，因此取值会有以下两种情况：

    - $i$ 为偶数，此时最小分数为 $0$;

    - $i$ 为奇数，此时最小分数为 $1$。

  用公式表达，即为 $(i + 1) \bmod 2$。

对于 $i = 0$ 的情况，有 $\textit{mx}[0] = \textit{mn}[0] = 0$。

我们从左至右遍历字符串 $s$，并相应维护 $\textit{mx}$ 和 $\textit{mn}$ 数组。具体地，当遍历到下标 $i$ 时，根据 $\textit{locked}[i]$ 的不同取值，会有以下两种情况：

- $\textit{locked}[i] = 1$，此时 $s[i]$ 的取值无法更改。因此 $\textit{mx}[i + 1] = \textit{mx}[i] + \textit{diff}$，其中 $\textit{diff}$ 为 $s[i]$ 的分数。同理，$\textit{mn}[i + 1] = \max(\textit{mn}[i] + \textit{diff}, (i + 1) \bmod 2)$。

- $\textit{locked}[i] = 0$，此时 $s[i]$ 的取值可以更改。因此 $\textit{mx}[i + 1] = \textit{mx}[i] + 1$，且 $\textit{mn}[i + 1] = \max(\textit{mn}[i] - 1, (i + 1) \bmod 2)$。

在遍历的过程中，如果对于某一下标 $i$，有 $\textit{mx}[i] < \textit{mn}[i]$，那么 $s[0..i]$ 无法通过变换成为有效前缀，也就是说 $s$ **无法通过变换成为有效字符串**，此时直接返回 $\texttt{false}$。

当遍历完成后，我们只需要确定 $s$ 是否可以通过变换使得分数为 $0$ 即可。假设 $s$ 的长度为 $n$，这等价于判断 $\textit{mn}[n]$ 是否为 $0$。如果 $\textit{mn}[n] = 0$，则 $s$ 可以通过变换成为有效括号字符串，我们应返回 $\texttt{true}$；反之则不能，应返回 $\texttt{false}$。


**细节**

由上述的推导过程，我们容易发现，在计算 $\textit{mx}[i + 1]$ 与 $\textit{mn}[i + 1]$ 时，我们**并不**需要用到整个 $\textit{mx}$ 和 $\textit{mn}$ 数组，只需要 $\textit{mx}[i]$ 与 $\textit{mn}[i]$ 的取值。因此，我们可以用**两个同名整数来替代** $\textit{mx}$ 和 $\textit{mn}$ 数组。具体转移如下：

- $\textit{mx}$ 和 $\textit{mn}$ 的初值为 $0$；

- $\textit{locked}[i] = 1$ 时，有 $\textit{mx} = \textit{mx} + \textit{diff}$，$\textit{mn} = \max(\textit{mn} + \textit{diff}, (i + 1) \bmod 2)$；

- $\textit{locked}[i] = 0$ 时，有 $\textit{mx} = \textit{mx} + 1$，$\textit{mn} = \max(\textit{mn} - 1, (i + 1) \bmod 2)$；

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool canBeValid(string s, string locked) {
        int n = s.size();
        int mx = 0;   // 可以达到的最大分数
        int mn = 0;   // 可以达到的最小分数 与 最小有效前缀对应分数 的较大值
        for (int i = 0; i < n; ++i) {
            if (locked[i] == '1') {
                // 此时对应字符无法更改
                int diff;
                if (s[i] == '(') {
                    diff = 1;
                }
                else {
                    diff = -1;
                }
                mx += diff;
                mn = max(mn + diff, (i + 1) % 2);
            }
            else {
                // 此时对应字符可以更改
                ++mx;
                mn = max(mn - 1, (i + 1) % 2);
            }
            if (mx < mn) {
                // 此时该前缀无法变为有效前缀
                return false;
            }
        }
        // 最终确定 s 能否通过变换使得分数为 0（成为有效字符串）
        return mn == 0;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def canBeValid(self, s: str, locked: str) -> bool:
        n = len(s)
        mx = 0   # 可以达到的最大分数
        mn = 0   # 可以达到的最小分数 与 最小有效前缀对应分数 的较大值
        for i in range(n):
            if locked[i] == '1':
                # 此时对应字符无法更改
                if s[i] == '(':
                    diff = 1
                else:
                    diff = -1
                mx += diff
                mn = max(mn + diff, (i + 1) % 2)
            else:
                # 此时对应字符可以更改
                mx += 1
                mn = max(mn - 1, (i + 1) % 2)
            if mx < mn:
                # 此时该前缀无法变为有效前缀
                return False
        # 最终确定 s 能否通过变换使得分数为 0（成为有效字符串）
        return mn == 0
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $s$ 的长度。即为遍历字符串维护 $\textit{mx}$ 和 $\textit{mn}$ 并判断 $s$ 能否变为有效字符串的时间复杂度。

- 空间复杂度：$O(1)$。
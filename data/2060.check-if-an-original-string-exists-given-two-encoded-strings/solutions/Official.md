## [2060.同源字符串检测 中文官方题解](https://leetcode.cn/problems/check-if-an-original-string-exists-given-two-encoded-strings/solutions/100000/tong-yuan-zi-fu-chuan-jian-ce-by-leetcod-mwva)

#### 方法一：动态规划

**思路与算法**

我们可以使用动态规划来解决本题。

记 $f[i][j][\textit{which}][\textit{rest}]$ 表示是否存在一种解码方案，使得字符串 $s_1$ 的第 $0, 1, \cdots, i$ 个字符可以与 $s_2$ 的第 $0, 1, \cdots, j$ 个字符相匹配，并且：

- 如果 $\textit{which} = 0$，那么字符串 $s_1$ 还多出了 $\textit{rest}$ 个任意字符；

- 如果 $\textit{which} = 1$，那么字符串 $s_2$ 还多出了 $\textit{rest}$ 个任意字符。

这里的任意字符指的是：当遇到字符串中的数字时，我们先将对应的数量存下来，便于进行后续的匹配。

在进行状态转移时，我们可以考虑 $\textit{which} = 0$ 时的若干种情况：

- 如果 $\textit{rest} = 0$ 并且 $s_1[i+1]$ 和 $s_2[j+1]$ 都是字母，那么必须有 $s_1[i+1] = s_2[j+1]$，即：

$$
f[i][j][0][0] \to f[i+1][j+1][0][0], \quad s_1[i+1] = s_2[j+1]
$$

- 如果 $s_2[j+1]$ 是字母（但 $\textit{rest} = 0$ 和 $s_2[j+1]$ 是字母不同时满足），那么需要分 $\textit{rest} \geq 1$ 和 $\textit{rest} = 0$ 两种情况进行讨论：

    - 如果 $\textit{rest} \geq 1$，那么 $s_2[j+1]$ 会消耗一个 $s_1$ 多出的任意字符，即：

    $$
    f[i][j][0][\textit{rest}] \to f[i][j+1][0][\textit{rest}-1]
    $$
    
    - 如果 $\textit{rest} = 0$，那么 $s_2[j+1]$ 需要未来 $s_1$ 的一个任意字符去匹配，即：

    $$
    f[i][j][0][0] \to f[i][j+1][1][0]
    $$

- 如果 $s_2[j+1]$ 是数字，那么我们取出 $s_2[j+1]$ 到 $s_2[j+k]$ 所表示的数（根据题目描述，$1 \leq k \leq 3$），记为 $x$，那么需要分 $\textit{rest} \geq x$ 和 $\textit{rest} < x$ 两种情况进行讨论：

    - 如果 $\textit{rest} \geq x$，那么 $s_2[j+1]$ 到 $s_2[j+k]$ 会消耗 $x$ 个多出的任意字符，即：

    $$
    f[i][j][0][\textit{rest}] \to f[i][j+k+1][0][\textit{rest}-x]
    $$

    - 如果 $\textit{rest} < x$，那么在消耗完 $x$ 个多出的任意字符后，$s_2[j+1]$ 到 $s_2[j+k]$ 还需要未来 $s_1$ 的 $x - \textit{rest}$ 个任意字符去匹配，即：

    $$
    f[i][j][0][\textit{rest}] \to f[i][j+k+1][1][x-\textit{rest}]
    $$

- 如果 $j = |s_2| - 1$，即 $s_2$ 中的所有字符均已解码完成，那么 $\textit{rest}$ 必须为 $0$ 并且 $i = |s_1| - 1$，否则 $s_1$ 中剩余的每一个字符至少能解码出一个字符，$s_1$ 和 $s_2$ 就不可能匹配了，即：

    $$
    f[i][|s_2|-1][0][\textit{rest}] = \begin{cases}
    \text{True}, & \quad i=|s_1|-1 \text{~and~} \textit{rest} = 0 \\
    \text{False}, & \quad \text{otherwise}
    \end{cases}
    $$

我们发现，当 $\textit{which} = 0$ 时，除了 $s_1[i+1]$ 和 $s_2[j+1]$ 均为字母的情况外，我们只会在字符串 $s_2$ 中选择从位置 $j+1$ 开始的若干字符进行匹配，而暂不考虑 $s_1$。这样做的好处在于，我们总是选择「当前解码长度较小的字符串」，由于连续的数字最多可以对应 $999$ 个字符，那么 $\textit{rest}$ 的值也永远不会超过 $999$。

当 $\textit{which} = 1$ 时，我们考虑的若干种情况是类似的。

**细节**

我们可以根据上述状态转移方程编写自顶向下的记忆化搜索的代码，从初始状态 $f[-1][-1][0][0]$ 开始搜索，比普通的动态规划更加直观。由于大部分语言中并不能将负数 $-1$ 作为数组的索引，因此下面的代码中将 $i$ 和 $j$ 对应的索引全部增加 $1$。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    int f[41][41][2][1000];

public:
    bool possiblyEquals(string s1, string s2) {
        memset(f, -1, sizeof(f));
        int m = s1.size(), n = s2.size();

        function<bool(int, int, int, int)> dfs = [&](int i, int j, int which, int rest) -> bool {
            // 记忆化
            if (f[i][j][which][rest] != -1) {
                return f[i][j][which][rest];
            }

            if (which == 0) {
                if (j == n) {
                    return f[i][j][which][rest] = (i == m && !rest);
                }
                else if (isalpha(s2[j])) {
                    if (!rest && i != m && isalpha(s1[i])) {
                        return f[i][j][which][rest] = (s1[i] == s2[j] ? dfs(i + 1, j + 1, 0, 0) : false);
                    }
                    else {
                        return f[i][j][which][rest] = (rest >= 1 ? dfs(i, j + 1, 0, rest - 1) : dfs(i, j + 1, 1, 1));
                    }
                }
                else {
                    int x = 0, k = j;
                    while (k < n && isdigit(s2[k])) {
                        x = x * 10 + (s2[k] - '0');
                        if ((rest >= x && dfs(i, k + 1, 0, rest - x)) || (rest < x && dfs(i, k + 1, 1, x - rest))) {
                            return f[i][j][which][rest] = true;
                        }
                        ++k;
                    }
                    return f[i][j][which][rest] = false;
                }
            }
            else {
                if (i == m) {
                    return f[i][j][which][rest] = (j == n && !rest);
                }
                else if (isalpha(s1[i])) {
                    if (!rest && j != n && isalpha(s2[j])) {
                        return f[i][j][which][rest] = (s1[i] == s2[j] ? dfs(i + 1, j + 1, 0, 0) : false);
                    }
                    else {
                        return f[i][j][which][rest] = (rest >= 1 ? dfs(i + 1, j, 1, rest - 1) : dfs(i + 1, j, 0, 1));
                    }
                }
                else {
                    int x = 0, k = i;
                    while (k < m && isdigit(s1[k])) {
                        x = x * 10 + (s1[k] - '0');
                        if ((rest >= x && dfs(k + 1, j, 1, rest - x)) || (rest < x && dfs(k + 1, j, 0, x - rest))) {
                            return f[i][j][which][rest] = true;
                        }
                        ++k;
                    }
                    return f[i][j][which][rest] = false;
                }
            }
        };

        return dfs(0, 0, 0, 0);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def possiblyEquals(self, s1: str, s2: str) -> bool:
        m, n = len(s1), len(s2)
        
        @cache
        def dfs(i: int, j: int, which: int, rest: int) -> bool:
            if which == 0:
                if j == n:
                    return i == m and rest == 0
                elif s2[j].isalpha():
                    if rest == 0 and i != m and s1[i].isalpha():
                        return (dfs(i + 1, j + 1, 0, 0) if s1[i] == s2[j] else False)
                    else:
                        return (dfs(i, j + 1, 0, rest - 1) if rest >= 1 else dfs(i, j + 1, 1, 1))
                else:
                    x, k = 0, j
                    while k < n and s2[k].isdigit():
                        x = x * 10 + int(s2[k])
                        if (rest >= x and dfs(i, k + 1, 0, rest - x)) or (rest < x and dfs(i, k + 1, 1, x - rest)):
                            return True
                        k += 1
                    return False
            else:
                if i == m:
                    return j == n and rest == 0
                elif s1[i].isalpha():
                    if rest == 0 and j != n and s2[j].isalpha():
                        return (dfs(i + 1, j + 1, 0, 0) if s1[i] == s2[j] else False)
                    else:
                        return (dfs(i + 1, j, 1, rest - 1) if rest >= 1 else dfs(i + 1, j, 0, 1))
                else:
                    x, k = 0, i
                    while k < m and s1[k].isdigit():
                        x = x * 10 + int(s1[k])
                        if (rest >= x and dfs(k + 1, j, 1, rest - x)) or (rest < x and dfs(k + 1, j, 0, x - rest)):
                            return True
                        k += 1
                    return False

        ans = dfs(0, 0, 0, 0)
        dfs.cache_clear()
        return ans
```

**复杂度分析**

- 时间复杂度：$O(mnd \cdot 10^d)$，其中 $m$ 是字符串 $s_1$ 的长度，$n$ 是字符串 $s_2$ 的长度，$d$ 是连续数字的最大位数，本题中 $d=3$。动态规划中的状态一共有 $i, j, \textit{which}, \textit{rest}$ 四个维度，它们的范围分别为 $O(m), O(n), O(1), O(10^d)$，而每个状态 $f[i][j][\textit{which}][\textit{rest}]$ 需要 $O(d)$ 的时间进行计算，因此总时间复杂度为 $O(mnd \cdot 10^d)$。

- 空间复杂度：$O(mn \cdot 10^d)$，记为动态规划中存储所有状态 $f$ 需要的空间。
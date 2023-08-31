## [44.通配符匹配 中文官方题解](https://leetcode.cn/problems/wildcard-matching/solutions/100000/tong-pei-fu-pi-pei-by-leetcode-solution)
#### 前言

本题与「[10. 正则表达式匹配](https://leetcode-cn.com/problems/regular-expression-matching/)」非常类似，但相比较而言，本题稍微容易一些。因为在本题中，模式 $p$ 中的任意一个字符都是**独立**的，即不会和前后的字符互相关联，形成一个新的匹配模式。因此，本题的状态转移方程需要考虑的情况会少一些。

#### 方法一：动态规划

**思路与算法**

在给定的模式 $p$ 中，只会有三种类型的字符出现：

- 小写字母 $a-z$，可以匹配对应的一个小写字母；

- 问号 $?$，可以匹配任意一个小写字母；

- 星号 $*$，可以匹配任意字符串，可以为空，也就是匹配零或任意多个小写字母。

其中「小写字母」和「问号」的匹配是**确定**的，而「星号」的匹配是**不确定**的，因此我们需要枚举所有的匹配情况。为了减少重复枚举，我们可以使用动态规划来解决本题。

我们用 $\textit{dp}[i][j]$ 表示字符串 $s$ 的前 $i$ 个字符和模式 $p$ 的前 $j$ 个字符是否能匹配。在进行状态转移时，我们可以考虑模式 $p$ 的第 $j$ 个字符 $p_j$，与之对应的是字符串 $s$ 中的第 $i$ 个字符 $s_i$：

- 如果 $p_j$ 是小写字母，那么 $s_i$ 必须也为相同的小写字母，状态转移方程为：

    $$
    \textit{dp}[i][j] = (s_i~与~p_j~相同) \wedge \textit{dp}[i-1][j-1]
    $$

    其中 $\wedge$ 表示逻辑与运算。也就是说，$\textit{dp}[i][j]$ 为真，当且仅当 $\textit{dp}[i-1][j-1]$ 为真，并且 $s_i$ 与 $p_j$ 相同。

- 如果 $p_j$ 是问号，那么对 $s_i$ 没有任何要求，状态转移方程为：

    $$
    \textit{dp}[i][j] = \textit{dp}[i-1][j-1]
    $$

- 如果 $p_j$ 是星号，那么同样对 $s_i$ 没有任何要求，但是星号可以匹配零或任意多个小写字母，因此状态转移方程分为两种情况，即使用或不使用这个星号：

    $$
    \textit{dp}[i][j] = \textit{dp}[i][j-1] \vee \textit{dp}[i-1][j]
    $$

    其中 $\vee$ 表示逻辑或运算。如果我们不使用这个星号，那么就会从 $\textit{dp}[i][j-1]$ 转移而来；如果我们使用这个星号，那么就会从 $\textit{dp}[i-1][j]$ 转移而来。

最终的状态转移方程如下：

$$
\textit{dp}[i][j] = \begin{cases}
    (s_i~与~p_j~相同) \wedge \textit{dp}[i-1][j-1], & p_j~是小写字母 \\
    \textit{dp}[i-1][j-1], & p_j~是问号 \\
    \textit{dp}[i][j-1] \vee \textit{dp}[i-1][j], & p_j~是星号
\end{cases}
$$

我们也可以将前两种转移进行归纳：

$$
\textit{dp}[i][j] = \begin{cases}
    \textit{dp}[i-1][j-1], & s_i~与~p_j~相同或者~p_j~是问号 \\
    \textit{dp}[i][j-1] \vee \textit{dp}[i-1][j], & p_j~是星号 \\
    \text{False}, & 其它情况
\end{cases}
$$

**细节**

只有确定了边界条件，才能进行动态规划。在上述的状态转移方程中，由于 $\textit{dp}[i][j]$ 对应着 $s$ 的前 $i$ 个字符和模式 $p$ 的前 $j$ 个字符，因此所有的 $\textit{dp}[0][j]$ 和 $\textit{dp}[i][0]$ 都是边界条件，因为它们涉及到空字符串或者空模式的情况，这是我们在状态转移方程中没有考虑到的：

- $\textit{dp}[0][0] = \text{True}$，即当字符串 $s$ 和模式 $p$ 均为空时，匹配成功；

- $\textit{dp}[i][0] = \text{False}$，即空模式无法匹配非空字符串；

- $\textit{dp}[0][j]$ 需要分情况讨论：因为星号才能匹配空字符串，所以只有当模式 $p$ 的前 $j$ 个字符均为星号时，$\textit{dp}[0][j]$ 才为真。

我们可以发现，$\textit{dp}[i][0]$ 的值恒为假，$\textit{dp}[0][j]$ 在 $j$ 大于模式 $p$ 的开头出现的星号字符个数之后，值也恒为假，而 $\textit{dp}[i][j]$ 的默认值（其它情况）也为假，因此在对动态规划的数组初始化时，我们就可以将所有的状态初始化为 $\text{False}$，减少状态转移的代码编写难度。

最终的答案即为 $\textit{dp}[m][n]$，其中 $m$ 和 $n$ 分别是字符串 $s$ 和模式 $p$ 的长度。需要注意的是，由于大部分语言中字符串的下标从 $0$ 开始，因此 $s_i$ 和 $p_j$ 分别对应着 $s[i-1]$ 和 $p[j-1]$。

```C++ [sol1-C++]
class Solution {
public:
    bool isMatch(string s, string p) {
        int m = s.size();
        int n = p.size();
        vector<vector<int>> dp(m + 1, vector<int>(n + 1));
        dp[0][0] = true;
        for (int i = 1; i <= n; ++i) {
            if (p[i - 1] == '*') {
                dp[0][i] = true;
            }
            else {
                break;
            }
        }
        for (int i = 1; i <= m; ++i) {
            for (int j = 1; j <= n; ++j) {
                if (p[j - 1] == '*') {
                    dp[i][j] = dp[i][j - 1] | dp[i - 1][j];
                }
                else if (p[j - 1] == '?' || s[i - 1] == p[j - 1]) {
                    dp[i][j] = dp[i - 1][j - 1];
                }
            }
        }
        return dp[m][n];
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isMatch(String s, String p) {
        int m = s.length();
        int n = p.length();
        boolean[][] dp = new boolean[m + 1][n + 1];
        dp[0][0] = true;
        for (int i = 1; i <= n; ++i) {
            if (p.charAt(i - 1) == '*') {
                dp[0][i] = true;
            } else {
                break;
            }
        }
        for (int i = 1; i <= m; ++i) {
            for (int j = 1; j <= n; ++j) {
                if (p.charAt(j - 1) == '*') {
                    dp[i][j] = dp[i][j - 1] || dp[i - 1][j];
                } else if (p.charAt(j - 1) == '?' || s.charAt(i - 1) == p.charAt(j - 1)) {
                    dp[i][j] = dp[i - 1][j - 1];
                }
            }
        }
        return dp[m][n];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isMatch(self, s: str, p: str) -> bool:
        m, n = len(s), len(p)

        dp = [[False] * (n + 1) for _ in range(m + 1)]
        dp[0][0] = True
        for i in range(1, n + 1):
            if p[i - 1] == '*':
                dp[0][i] = True
            else:
                break
        
        for i in range(1, m + 1):
            for j in range(1, n + 1):
                if p[j - 1] == '*':
                    dp[i][j] = dp[i][j - 1] | dp[i - 1][j]
                elif p[j - 1] == '?' or s[i - 1] == p[j - 1]:
                    dp[i][j] = dp[i - 1][j - 1]
                
        return dp[m][n]
```

```golang [sol1-Golang]
func isMatch(s string, p string) bool {
    m, n := len(s), len(p)
    dp := make([][]bool, m + 1)
    for i := 0; i <= m; i++ {
        dp[i] = make([]bool, n + 1)
    }
    dp[0][0] = true
    for i := 1; i <= n; i++ {
        if p[i-1] == '*' {
            dp[0][i] = true
        } else {
            break
        }
    }
    for i := 1; i <= m; i++ {
        for j := 1; j <= n; j++ {
            if p[j-1] == '*' {
                dp[i][j] = dp[i][j-1] || dp[i-1][j]
            } else if p[j-1] == '?' || s[i-1] == p[j-1] {
                dp[i][j] = dp[i-1][j-1]
            }
        }
    }
    return dp[m][n]
}
```

```C [sol1-C]
bool isMatch(char* s, char* p) {
    int m = strlen(s);
    int n = strlen(p);
    int dp[m + 1][n + 1];
    memset(dp, 0, sizeof(dp));
    dp[0][0] = true;
    for (int i = 1; i <= n; ++i) {
        if (p[i - 1] == '*') {
            dp[0][i] = true;
        } else {
            break;
        }
    }
    for (int i = 1; i <= m; ++i) {
        for (int j = 1; j <= n; ++j) {
            if (p[j - 1] == '*') {
                dp[i][j] = dp[i][j - 1] | dp[i - 1][j];
            } else if (p[j - 1] == '?' || s[i - 1] == p[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1];
            }
        }
    }
    return dp[m][n];
}
```

**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $s$ 和模式 $p$ 的长度。

- 空间复杂度：$O(mn)$，即为存储所有 $(m+1)(n+1)$ 个状态需要的空间。此外，在状态转移方程中，由于 $\textit{dp}[i][j]$ 只会从 $\textit{dp}[i][..]$ 以及 $\textit{dp}[i - 1][..]$ 转移而来，因此我们可以使用滚动数组对空间进行优化，即用两个长度为 $n+1$ 的一维数组代替整个二维数组进行状态转移，空间复杂度为 $O(n)$。

#### 方法二：贪心算法

方法一的瓶颈在于对星号 $*$ 的处理方式：使用动态规划枚举所有的情况。由于星号是「万能」的匹配字符，连续的多个星号和单个星号实际上是等价的，那么不连续的多个星号呢？

我们以 $p = *~\text{abcd}~*$ 为例，$p$ 可以匹配**所有包含子串 $\text{abcd}$ 的字符串**，也就是说，我们只需要暴力地枚举字符串 $s$ 中的每个位置作为起始位置，并判断对应的子串是否为 $\text{abcd}$ 即可。这种暴力方法的时间复杂度为 $O(mn)$，与动态规划一致，但不需要额外的空间。

如果 $p = *~\text{abcd}*\text{efgh}*\text{i}~*$ 呢？显然，$p$ 可以匹配所有依次出现子串 $\text{abcd}$、$\text{efgh}$、$\text{i}$ 的字符串。此时，对于任意一个字符串 $s$，我们首先暴力找到最早出现的 $\text{abcd}$，随后从下一个位置开始暴力找到最早出现的 $\text{efgh}$，最后找出 $\text{i}$，就可以判断 $s$ 是否可以与 $p$ 匹配。这样「贪心地」找到最早出现的子串是比较直观的，因为如果 $s$ 中多次出现了某个子串，那么我们选择最早出现的位置，可以使得后续子串能被找到的机会更大。

因此，如果模式 $p$ 的形式为 $*~u_1*u_2*u_3~*\cdots*u_x~*$，即字符串（可以为空）和星号交替出现，并且首尾字符均为星号，那么我们就可以设计出下面这个基于贪心的暴力匹配算法。算法的本质是：如果在字符串 $s$ 中首先找到 $u_1$，再找到 $u_2, u_3, \cdots, u_x$，那么 $s$ 就可以与模式 $p$ 匹配，伪代码如下：

```
// 我们用 sIndex 和 pIndex 表示当前遍历到 s 和 p 的位置
// 此时我们正在 s 中寻找某个 u_i
// 其在 s 和 p 中的起始位置为 sRecord 和 pRecord

// sIndex 和 sRecord 的初始值为 0
// 即我们从字符串 s 的首位开始匹配
sIndex = sRecord = 0

// pIndex 和 pRecord 的初始值为 1
// 这是因为模式 p 的首位是星号，那么 u_1 的起始位置为 1
pIndex = pRecord = 1

while sIndex < s.length and pIndex < p.length do
    if p[pIndex] == '*' then
        // 如果遇到星号，说明找到了 u_i，开始寻找 u_i+1
        pIndex += 1
        // 记录下起始位置
        sRecord = sIndex
        pRecord = pIndex
    else if match(s[sIndex], p[pIndex]) then
        // 如果两个字符可以匹配，就继续寻找 u_i 的下一个字符
        sIndex += 1
        pIndex += 1
    else if sRecord + 1 < s.length then
        // 如果两个字符不匹配，那么需要重新寻找 u_i
        // 枚举下一个 s 中的起始位置
        sRecord += 1
        sIndex = sRecord
        pIndex = pRecord
    else
        // 如果不匹配并且下一个起始位置不存在，那么匹配失败
        return False
    end if
end while

// 由于 p 的最后一个字符是星号，那么 s 未匹配完，那么没有关系
// 但如果 p 没有匹配完，那么 p 剩余的字符必须都是星号
return all(p[pIndex] ~ p[p.length - 1] == '*')
```

然而模式 $p$ 并不一定是 $*~u_1*u_2*u_3~*\cdots*u_x~*$ 的形式：

- 模式 $p$ 的开头字符不是星号；

- 模式 $p$ 的结尾字符不是星号。

第二种情况处理起来并不复杂。如果模式 $p$ 的结尾字符不是星号，那么就必须与字符串 $s$ 的结尾字符匹配。那么我们不断地匹配 $s$ 和 $p$ 的结尾字符，直到 $p$ 为空或者 $p$ 的结尾字符是星号为止。在这个过程中，如果匹配失败，或者最后 $p$ 为空但 $s$ 不为空，那么需要返回 $\text{False}$。

第一种情况的处理也很类似，我们可以不断地匹配 $s$ 和 $p$ 的开头字符。下面的代码中给出了另一种处理方法，即修改 $\textit{sRecord}$ 和 $\textit{tRecord}$ 的初始值为 $-1$，表示模式 $p$ 的开头字符不是星号，并且在匹配失败时进行判断，如果它们的值仍然为 $-1$，说明没有「反悔」重新进行匹配的机会。

```C++ [sol2-C++]
class Solution {
public:
    bool isMatch(string s, string p) {
        auto allStars = [](const string& str, int left, int right) {
            for (int i = left; i < right; ++i) {
                if (str[i] != '*') {
                    return false;
                }
            }
            return true;
        };
        auto charMatch = [](char u, char v) {
            return u == v || v == '?';
        };

        while (s.size() && p.size() && p.back() != '*') {
            if (charMatch(s.back(), p.back())) {
                s.pop_back();
                p.pop_back();
            }
            else {
                return false;
            }
        }
        if (p.empty()) {
            return s.empty();
        }

        int sIndex = 0, pIndex = 0;
        int sRecord = -1, pRecord = -1;
        while (sIndex < s.size() && pIndex < p.size()) {
            if (p[pIndex] == '*') {
                ++pIndex;
                sRecord = sIndex;
                pRecord = pIndex;
            }
            else if (charMatch(s[sIndex], p[pIndex])) {
                ++sIndex;
                ++pIndex;
            }
            else if (sRecord != -1 && sRecord + 1 < s.size()) {
                ++sRecord;
                sIndex = sRecord;
                pIndex = pRecord;
            }
            else {
                return false;
            }
        }
        return allStars(p, pIndex, p.size());
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean isMatch(String s, String p) {
        int sRight = s.length(), pRight = p.length();
        while (sRight > 0 && pRight > 0 && p.charAt(pRight - 1) != '*') {
            if (charMatch(s.charAt(sRight - 1), p.charAt(pRight - 1))) {
                --sRight;
                --pRight;
            } else {
                return false;
            }
        }

        if (pRight == 0) {
            return sRight == 0;
        }

        int sIndex = 0, pIndex = 0;
        int sRecord = -1, pRecord = -1;
        
        while (sIndex < sRight && pIndex < pRight) {
            if (p.charAt(pIndex) == '*') {
                ++pIndex;
                sRecord = sIndex;
                pRecord = pIndex;
            } else if (charMatch(s.charAt(sIndex), p.charAt(pIndex))) {
                ++sIndex;
                ++pIndex;
            } else if (sRecord != -1 && sRecord + 1 < sRight) {
                ++sRecord;
                sIndex = sRecord;
                pIndex = pRecord;
            } else {
                return false;
            }
        }

        return allStars(p, pIndex, pRight);
    }

    public boolean allStars(String str, int left, int right) {
        for (int i = left; i < right; ++i) {
            if (str.charAt(i) != '*') {
                return false;
            }
        }
        return true;
    }

    public boolean charMatch(char u, char v) {
        return u == v || v == '?';
    }
}
```

```Python [sol2-Python3]
class Solution:
    def isMatch(self, s: str, p: str) -> bool:
        def allStars(st: str, left: int, right: int) -> bool:
            return all(st[i] == '*' for i in range(left, right))
        
        def charMatch(u: str, v: str) -> bool:
            return u == v or v == '?'

        sRight, pRight = len(s), len(p)
        while sRight > 0 and pRight > 0 and p[pRight - 1] != '*':
            if charMatch(s[sRight - 1], p[pRight - 1]):
                sRight -= 1
                pRight -= 1
            else:
                return False
        
        if pRight == 0:
            return sRight == 0
        
        sIndex, pIndex = 0, 0
        sRecord, pRecord = -1, -1
        while sIndex < sRight and pIndex < pRight:
            if p[pIndex] == '*':
                pIndex += 1
                sRecord, pRecord = sIndex, pIndex
            elif charMatch(s[sIndex], p[pIndex]):
                sIndex += 1
                pIndex += 1
            elif sRecord != -1 and sRecord + 1 < sRight:
                sRecord += 1
                sIndex, pIndex = sRecord, pRecord
            else:
                return False

        return allStars(p, pIndex, pRight)
```

```golang [sol2-Golang]
func isMatch(s string, p string) bool {
    for len(s) > 0 && len(p) > 0 && p[len(p)-1] != '*' {
        if charMatch(s[len(s)-1], p[len(p)-1]) {
            s = s[:len(s)-1]
            p = p[:len(p)-1]
        } else {
            return false
        }
    }
    if len(p) == 0 {
        return len(s) == 0
    }
    sIndex, pIndex := 0, 0
    sRecord, pRecord := -1, -1
    for sIndex < len(s) && pRecord < len(p) {
        if p[pIndex] == '*' {
            pIndex++
            sRecord, pRecord = sIndex, pIndex
        } else if charMatch(s[sIndex], p[pIndex]) {
            sIndex++
            pIndex++
        } else if sRecord != -1 && sRecord + 1 < len(s) {
            sRecord++
            sIndex, pIndex = sRecord, pRecord
        } else {
            return false
        }
    }
    return allStars(p, pIndex, len(p))
}

func allStars(str string, left, right int) bool {
    for i := left; i < right; i++ {
        if str[i] != '*' {
            return false
        }
    }
    return true
}

func charMatch(u, v byte) bool {
    return u == v || v == '?'
}
```

```C [sol2-C]
bool allStars(char* str, int left, int right) {
    for (int i = left; i < right; ++i) {
        if (str[i] != '*') {
            return false;
        }
    }
    return true;
}
bool charMatch(char u, char v) { return u == v || v == '?'; };

bool isMatch(char* s, char* p) {
    int len_s = strlen(s), len_p = strlen(p);
    while (len_s && len_p && p[len_p - 1] != '*') {
        if (charMatch(s[len_s - 1], p[len_p - 1])) {
            len_s--;
            len_p--;
        } else {
            return false;
        }
    }
    if (len_p == 0) {
        return len_s == 0;
    }

    int sIndex = 0, pIndex = 0;
    int sRecord = -1, pRecord = -1;
    while (sIndex < len_s && pIndex < len_p) {
        if (p[pIndex] == '*') {
            ++pIndex;
            sRecord = sIndex;
            pRecord = pIndex;
        } else if (charMatch(s[sIndex], p[pIndex])) {
            ++sIndex;
            ++pIndex;
        } else if (sRecord != -1 && sRecord + 1 < len_s) {
            ++sRecord;
            sIndex = sRecord;
            pIndex = pRecord;
        } else {
            return false;
        }
    }
    return allStars(p, pIndex, len_p);
}
```

**复杂度分析**

- 时间复杂度：

    - 渐进复杂度：$O(mn)$，其中 $m$ 和 $n$ 分别是字符串 $s$ 和模式 $p$ 的长度。从代码中可以看出，$s[\textit{sIndex}]$ 和 $p[\textit{pIndex}]$ 至多只会被匹配（判断）一次，因此渐进时间复杂度为 $O(mn)$。
    
    - 最坏情况的例子：$s=\text{aaa}\cdots\text{aaab}$，$p=*~\text{ab}~*$。

    - 平均复杂度：$O(m \log n)$。直观上来看，如果 $s$ 和 $p$ 是随机字符串，那么暴力算法的效率会非常高，因为大部分情况下只需要匹配常数次就可以成功匹配 $u_i$ 或者枚举下一个常数位置。具体的分析可以参考论文 [On the Average-case Complexity of Pattern Matching with Wildcards](https://arxiv.org/abs/1407.0950)，注意论文中的分析是对于每一个 $u_i$ 而言的，即模式中只包含小写字母和问号，本题相当于多个连续模式的情况。由于超出了面试难度。这里不再赘述。

- 空间复杂度：$O(1)$。

#### 结语

在方法二中，对于每一个被星号分隔的、只包含小写字符和问号的子模式 $u_i$，我们在原串中使用的是暴力匹配的方法。然而这里是可以继续进行优化的，即使用 [AC 自动机](https://baike.baidu.com/item/AC%E8%87%AA%E5%8A%A8%E6%9C%BA) 代替暴力方法进行匹配。由于 AC 自动机本身已经是竞赛难度的知识点，而本题还需要在 AC 自动机中额外存储一些内容才能完成匹配，因此这种做法远远超过了面试难度。这里只给出参考讲义 [Set Matching and Aho-Corasick Algorithm](http://www.cs.cmu.edu/~ab/CMU/Week%2010-%20Strings%20Search/print04.pdf)：

- 讲义的前 $6$ 页介绍了字典树 Trie；

- 讲义的 $7-19$ 页介绍了 AC 自动机，它是以字典树为基础的；

- 讲义的 $20-23$ 页介绍了基于 AC 自动机的一种 wildcard matching 算法，其中的 wildcard $\phi$ 就是本题中的问号。

感兴趣的读者可以尝试进行学习。
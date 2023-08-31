## [524.通过删除字母匹配到字典里最长单词 中文官方题解](https://leetcode.cn/problems/longest-word-in-dictionary-through-deleting/solutions/100000/tong-guo-shan-chu-zi-mu-pi-pei-dao-zi-di-at66)
#### 方法一：双指针

**思路和算法**

根据题意，我们需要解决两个问题：

- 如何判断 $\textit{dictionary}$ 中的字符串 $t$ 是否可以通过删除 $s$ 中的某些字符得到；

- 如何找到长度最长且字典序最小的字符串。

第 $1$ 个问题实际上就是判断 $t$ 是否是 $s$ 的子序列。因此只要能找到任意一种 $t$ 在 $s$ 中出现的方式，即可认为 $t$ 是 $s$ 的子序列。而当我们从前往后匹配时，可以发现每次贪心地匹配最靠前的字符是最优决策。

> 假定当前需要匹配字符 $c$，而字符 $c$ 在 $s$ 中的位置 $x_1$ 和 $x_2$ 出现（$x_1 < x_2$），那么贪心取 $x_1$ 是最优解，因为 $x_2$ 后面能取到的字符，$x_1$ 也都能取到，并且通过 $x_1$ 与 $x_2$ 之间的可选字符，更有希望能匹配成功。

这样，我们初始化两个指针 $i$ 和 $j$，分别指向 $t$ 和 $s$ 的初始位置。每次贪心地匹配，匹配成功则 $i$ 和 $j$ 同时右移，匹配 $t$ 的下一个位置，匹配失败则 $j$ 右移，$i$ 不变，尝试用 $s$ 的下一个字符匹配 $t$。

最终如果 $i$ 移动到 $t$ 的末尾，则说明 $t$ 是 $s$ 的子序列。

第 $2$ 个问题可以通过遍历 $\textit{dictionary}$ 中的字符串，并维护当前长度最长且字典序最小的字符串来找到。

**代码**

```Python [sol1-Python3]
class Solution:
    def findLongestWord(self, s: str, dictionary: List[str]) -> str:
        res = ""
        for t in dictionary:
            i = j = 0
            while i < len(t) and j < len(s):
                if t[i] == s[j]:
                    i += 1
                j += 1
            if i == len(t):
                if len(t) > len(res) or (len(t) == len(res) and t < res):
                    res = t
        return res
```

```Java [sol1-Java]
class Solution {
    public String findLongestWord(String s, List<String> dictionary) {
        String res = "";
        for (String t : dictionary) {
            int i = 0, j = 0;
            while (i < t.length() && j < s.length()) {
                if (t.charAt(i) == s.charAt(j)) {
                    ++i;
                }
                ++j;
            }
            if (i == t.length()) {
                if (t.length() > res.length() || (t.length() == res.length() && t.compareTo(res) < 0)) {
                    res = t;
                }
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string FindLongestWord(string s, IList<string> dictionary) {
        string res = "";
        foreach (string t in dictionary) {
            int i = 0, j = 0;
            while (i < t.Length && j < s.Length) {
                if (t[i] == s[j]) {
                    ++i;
                }
                ++j;
            }
            if (i == t.Length) {
                if (t.Length > res.Length || (t.Length == res.Length && t.CompareTo(res) < 0)) {
                    res = t;
                }
            }
        }
        return res;
    }
}
```

```go [sol1-Golang]
func findLongestWord(s string, dictionary []string) (ans string) {
    for _, t := range dictionary {
        i := 0
        for j := range s {
            if s[j] == t[i] {
                i++
                if i == len(t) {
                    if len(t) > len(ans) || len(t) == len(ans) && t < ans {
                        ans = t
                    }
                    break
                }
            }
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var findLongestWord = function(s, dictionary) {
    let res = "";
    for (const t of dictionary) {
        let i = 0, j = 0;
        while (i < t.length && j < s.length) {
            if (t[i] === s[j]) {
                ++i;
            }
            ++j;
        }
        if (i === t.length) {
            if (t.length > res.length || (t.length === res.length && t < res)) {
                res = t;
            }
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(d \times (m+n))$，其中 $d$ 表示 $\textit{dictionary}$ 的长度，$m$ 表示 $s$ 的长度，$n$ 表示 $\textit{dictionary}$ 中字符串的平均长度。我们需要遍历 $\textit{dictionary}$ 中的 $d$ 个字符串，每个字符串需要 $O(n+m)$ 的时间复杂度来判断该字符串是否为 $s$ 的子序列。

- 空间复杂度：$O(1)$。

#### 方法二：排序

**思路和算法**

在方法一的基础上，我们尝试通过对 $\textit{dictionary}$ 的预处理，来优化第 $2$ 个问题的处理。

我们可以先将 $\textit{dictionary}$ 依据字符串长度的降序和字典序的升序进行排序，然后从前向后找到第一个符合条件的字符串直接返回即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def findLongestWord(self, s: str, dictionary: List[str]) -> str:
        dictionary.sort(key=lambda x: (-len(x), x))
        for t in dictionary:
            i = j = 0
            while i < len(t) and j < len(s):
                if t[i] == s[j]:
                    i += 1
                j += 1
            if i == len(t):
                return t
        return ""
```

```Java [sol2-Java]
class Solution {
    public String findLongestWord(String s, List<String> dictionary) {
        Collections.sort(dictionary, new Comparator<String>() {
            public int compare(String word1, String word2) {
                if (word1.length() != word2.length()) {
                    return word2.length() - word1.length();
                } else {
                    return word1.compareTo(word2);
                }
            }
        });
        for (String t : dictionary) {
            int i = 0, j = 0;
            while (i < t.length() && j < s.length()) {
                if (t.charAt(i) == s.charAt(j)) {
                    ++i;
                }
                ++j;
            }
            if (i == t.length()) {
                return t;
            }
        }
        return "";
    }
}
```

```go [sol2-Golang]
func findLongestWord(s string, dictionary []string) string {
    sort.Slice(dictionary, func(i, j int) bool {
        a, b := dictionary[i], dictionary[j]
        return len(a) > len(b) || len(a) == len(b) && a < b
    })
    for _, t := range dictionary {
        i := 0
        for j := range s {
            if s[j] == t[i] {
                i++
                if i == len(t) {
                    return t
                }
            }
        }
    }
    return ""
}
```

```JavaScript [sol2-JavaScript]
var findLongestWord = function(s, dictionary) {
    dictionary.sort((word1, word2) => {
        if (word1.length !== word2.length) {
            return word2.length - word1.length;
        } else {
            return word1.localeCompare(word2);
        }
    });
    console.log(dictionary)

    for (const t of dictionary) {
        let i = 0, j = 0;
        while (i < t.length && j < s.length) {
            if (t[i] === s[j]) {
                ++i;
            }
            ++j;
        }
        if (i === t.length) {
            return t;
        }
    }
    return "";
};
```

**复杂度分析**

- 时间复杂度：$O(d \times m \times \log d + d \times (m+n))$，其中 $d$ 表示 $\textit{dictionary}$ 的长度，$m$ 表示 $s$ 的长度，$n$ 表示 $\textit{dictionary}$ 中字符串的平均长度。我们需要 $O(d \times m \times \log d)$ 的时间来排序 $\textit{dictionary}$；在最坏的情况下，我们需要 $O(d \times (m+n))$ 来找到第一个符合条件的字符串。

- 空间复杂度：$O(d \times m)$，为排序的开销。

#### 方法三：动态规划

**思路和算法**

在方法一的基础上，我们考虑通过对字符串 $s$ 的预处理，来优化第 $1$ 个问题的处理。

考虑前面的双指针的做法，我们注意到我们有大量的时间用于在 $s$ 中找到下一个匹配字符。

这样我们通过预处理，得到：对于 $s$ 的每一个位置，从该位置开始往后每一个字符第一次出现的位置。

我们可以使用动态规划的方法实现预处理，令 $f[i][j]$ 表示字符串 $s$ 中从位置 $i$ 开始往后字符 $j$ 第一次出现的位置。在进行状态转移时，如果 $s$ 中位置 $i$ 的字符就是 $j$，那么 $f[i][j]=i$，否则 $j$ 出现在位置 $i+1$ 开始往后，即 $f[i][j]=f[i+1][j]$；因此我们要倒过来进行动态规划，从后往前枚举 $i$。

这样我们可以写出状态转移方程：
$$
f[i][j]=
\begin{cases}
i, & s[i]=j \\
f[i+1][j], & s[i] \ne j
\end{cases}
$$
假定下标从 $0$ 开始，那么 $f[i][j]$ 中有 $0 \leq i \leq m-1$ ，对于边界状态 $f[m-1][..]$，我们置 $f[m][..]$ 为 $m$，让 $f[m-1][..]$ 正常进行转移。这样如果 $f[i][j]=m$，则表示从位置 $i$ 开始往后不存在字符 $j$。

这样，我们可以利用 $f$ 数组，每次 $O(1)$ 地跳转到下一个位置，直到位置变为 $m$ 或 $t$ 中的每一个字符都匹配成功。

**代码**

```Python [sol3-Python3]
class Solution:
    def findLongestWord(self, s: str, dictionary: List[str]) -> str:
        m = len(s)
        f = [[0] * 26 for _ in range(m)]
        f.append([m] * 26)

        for i in range(m - 1, -1, -1):
            for j in range(26):
                if ord(s[i]) == j + 97:
                    f[i][j] = i
                else:
                    f[i][j] = f[i + 1][j]

        res = ""
        for t in dictionary:
            match = True
            j = 0
            for i in range(len(t)):
                if f[j][ord(t[i]) - 97] == m:
                    match = False
                    break
                j = f[j][ord(t[i]) - 97] + 1
            if match:
                if len(t) > len(res) or (len(t) == len(res) and t < res):
                    res = t
        return res
```

```Java [sol3-Java]
class Solution {
    public String findLongestWord(String s, List<String> dictionary) {
        int m = s.length();
        int[][] f = new int[m + 1][26];
        Arrays.fill(f[m], m);

        for (int i = m - 1; i >= 0; --i) {
            for (int j = 0; j < 26; ++j) {
                if (s.charAt(i) == (char) ('a' + j)) {
                    f[i][j] = i;
                } else {
                    f[i][j] = f[i + 1][j];
                }
            }
        }
        String res = "";
        for (String t : dictionary) {
            boolean match = true;
            int j = 0;
            for (int i = 0; i < t.length(); ++i) {
                if (f[j][t.charAt(i) - 'a'] == m) {
                    match = false;
                    break;
                }
                j = f[j][t.charAt(i) - 'a'] + 1;
            }
            if (match) {
                if (t.length() > res.length() ||  (t.length() == res.length() && t.compareTo(res) < 0)) {
                    res = t;
                }
            }
        }
        return res;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public string FindLongestWord(string s, IList<string> dictionary) {
        int m = s.Length;
        int[,] f = new int[m + 1, 26];
        for (int j = 0; j < 26; ++j) {
            f[m, j] = m;
        }

        for (int i = m - 1; i >= 0; --i) {
            for (int j = 0; j < 26; j++) {
                if (s[i] == (char) ('a' + j)) {
                    f[i, j] = i;
                } else {
                    f[i, j] = f[i + 1, j];
                }
            }
        }
        string res = "";
        foreach (string t in dictionary) {
            bool match = true;
            int j = 0;
            for (int i = 0; i < t.Length; ++i) {
                if (f[j, t[i] - 'a'] == m) {
                    match = false;
                    break;
                }
                j = f[j, t[i] - 'a'] + 1;
            }
            if (match) {
                if (t.Length > res.Length ||  (t.Length == res.Length && t.CompareTo(res) < 0)) {
                    res = t;
                }
            }
        }
        return res;
    }
}
```

```go [sol3-Golang]
func findLongestWord(s string, dictionary []string) (ans string) {
    m := len(s)
    f := make([][26]int, m+1)
    for i := range f[m] {
        f[m][i] = m
    }
    for i := m - 1; i >= 0; i-- {
        f[i] = f[i+1]
        f[i][s[i]-'a'] = i
    }

outer:
    for _, t := range dictionary {
        j := 0
        for _, ch := range t {
            if f[j][ch-'a'] == m {
                continue outer
            }
            j = f[j][ch-'a'] + 1
        }
        if len(t) > len(ans) || len(t) == len(ans) && t < ans {
            ans = t
        }
    }
    return
}
```

```JavaScript [sol3-JavaScript]
var findLongestWord = function(s, dictionary) {
    const m = s.length;
    const f = new Array(m + 1).fill(0).map(() => new Array(26).fill(m));

    for (let i = m - 1; i >= 0; --i) {
        for (let j = 0; j < 26; ++j) {
            if (s[i] === String.fromCharCode('a'.charCodeAt() + j)) {
                f[i][j] = i;
            } else {
                f[i][j] = f[i + 1][j];
            }
        }
    }
    let res = "";
    for (const t of dictionary) {
        let match = true;
        let j = 0;
        for (let i = 0; i < t.length; ++i) {
            if (f[j][t[i].charCodeAt() - 'a'.charCodeAt()] === m) {
                match = false;
                break;
            }
            j = f[j][t[i].charCodeAt() - 'a'.charCodeAt()] + 1;
        }
        if (match) {
            if (t.length > res.length ||  (t.length === res.length && t.localeCompare(res) < 0)) {
                res = t;
            }
        }
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(m \times |\Sigma|+d \times n)$，其中 $d$ 表示 $\textit{dictionary}$ 的长度，$\Sigma$ 为字符集，在本题中字符串只包含英文小写字母，故 $|\Sigma|=26$；$m$ 表示字符串 $s$ 的长度，$n$ 表示 $\textit{dictionary}$ 中字符串的平均长度。预处理的时间复杂度为 $O(m \times |\Sigma|)$；判断 $d$ 个字符串是否为 $s$ 的子序列的事件复杂度为 $O(d \times n)$。

- 空间复杂度：$O(m \times |\Sigma|)$，为动态规划数组的开销。
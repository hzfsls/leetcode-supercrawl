## [1763.最长的美好子字符串 中文官方题解](https://leetcode.cn/problems/longest-nice-substring/solutions/100000/zui-chang-de-mei-hao-zi-zi-fu-chuan-by-l-4l1t)

#### 方法一：枚举

**思路**

题目要求找到最长的美好子字符串，题目中给定的字符串 $s$ 的长度 $\textit{length}$ 范围为 $1 \le \textit{length} \le 100$。由于字符串的长度比较小，因此可以枚举所有可能的子字符串，然后检测该字符串是否为美好的字符串，并得到长度最长的美好字符串。

+ 题目关于美好字符串的定义为: 字符串中的每个字母的大写和小写形式同时出现在该字符串中。检测时，由于英文字母 $\texttt{`a'}-\texttt{`z'}$ 最多只有 $26$ 个, 因此可以利用二进制位来进行标记，$\textit{lower}$ 标记字符中出现过小写英文字母，$\textit{upper}$ 标记字符中出现过大写英文字母。如果满足 $\textit{lower} = \textit{upper}$ ，我们则认为字符串中所有的字符都满足大小写形式同时出现，则认定该字符串为美好字符串。

+ 题目要求如果有多个答案，返回在字符串中最早出现的那个。此时，只需要首先检测从以字符串索引 $0$ 为起始的子字符串。

**代码**

```Java [sol1-Java]
class Solution {
    public String longestNiceSubstring(String s) {
        int n = s.length();
        int maxPos = 0;
        int maxLen = 0;
        for (int i = 0; i < n; ++i) {
            int lower = 0;
            int upper = 0;
            for (int j = i; j < n; ++j) {
                if (Character.isLowerCase(s.charAt(j))) {
                    lower |= 1 << (s.charAt(j) - 'a');
                } else {
                    upper |= 1 << (s.charAt(j) - 'A');
                }
                if (lower == upper && j - i + 1 > maxLen) {
                    maxPos = i;
                    maxLen = j - i + 1;
                }
            }
        }
        return s.substring(maxPos, maxPos + maxLen);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    string longestNiceSubstring(string s) {
        int n = s.size();
        int maxPos = 0;
        int maxLen = 0;
        for (int i = 0; i < n; ++i) {
            int lower = 0;
            int upper = 0;
            for (int j = i; j < n; ++j) {
                if (islower(s[j])) {
                    lower |= 1 << (s[j] - 'a');
                } else {
                    upper |= 1 << (s[j] - 'A');
                }
                if (lower == upper && j - i + 1 > maxLen) {
                    maxPos = i;
                    maxLen = j - i + 1;
                }
            }
        }
        return s.substr(maxPos, maxLen);
    }
};
```

```C# [sol1-C#]
public class Solution {
    public string LongestNiceSubstring(string s) {
        int n = s.Length;
        int maxPos = 0;
        int maxLen = 0;
        for (int i = 0; i < n; ++i) {
            int lower = 0;
            int upper = 0;
            for (int j = i; j < n; ++j) {
                if (char.IsLower(s[j])) {
                    lower |= 1 << (s[j] - 'a');
                } else {
                    upper |= 1 << (s[j] - 'A');
                }
                if (lower == upper && j - i + 1 > maxLen) {
                    maxPos = i;
                    maxLen = j - i + 1;
                }
            }
        }
        return s.Substring(maxPos, maxLen);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def longestNiceSubstring(self, s: str) -> str:
        n = len(s)
        maxPos, maxLen = 0, 0
        for i in range(n):
            lower, upper = 0, 0
            for j in range(i, n):
                if s[j].islower():
                    lower |= 1 << (ord(s[j]) - ord('a'))
                else:
                    upper |= 1 << (ord(s[j]) - ord('A'))
                if lower == upper and j - i + 1 > maxLen:
                    maxPos = i
                    maxLen = j - i + 1
        return s[maxPos: maxPos + maxLen]
```

```C [sol1-C]
char * longestNiceSubstring(char * s){
    int n = strlen(s);
    int maxPos = 0;
    int maxLen = 0;
    for (int i = 0; i < n; ++i) {
        int lower = 0;
        int upper = 0;
        for (int j = i; j < n; ++j) {
            if (islower(s[j])) {
                lower |= 1 << (s[j] - 'a');
            } else {
                upper |= 1 << (s[j] - 'A');
            }
            if (lower == upper && j - i + 1 > maxLen) {
                maxPos = i;
                maxLen = j - i + 1;
            }
        }
    }
    char * ans = (char *)malloc(sizeof(char) * (maxLen + 1));
    strncpy(ans, s + maxPos, maxLen);
    ans[maxLen] = '\0';
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var longestNiceSubstring = function(s) {
    const n = s.length;
    let maxPos = 0;
    let maxLen = 0;
    for (let i = 0; i < n; ++i) {
        let lower = 0;
        let upper = 0;
        for (let j = i; j < n; ++j) {
            if ('a' <= s[j] && s[j] <= 'z') {
                lower |= 1 << (s[j].charCodeAt() - 'a'.charCodeAt());
            } else {
                upper |= 1 << (s[j].charCodeAt() - 'A'.charCodeAt());
            }
            if (lower === upper && j - i + 1 > maxLen) {
                maxPos = i;
                maxLen = j - i + 1;
            }
        }
    }
    return s.slice(maxPos, maxPos + maxLen);
};
```

```go [sol1-Golang]
func longestNiceSubstring(s string) (ans string) {
    for i := range s {
        lower, upper := 0, 0
        for j := i; j < len(s); j++ {
            if unicode.IsLower(rune(s[j])) {
                lower |= 1 << (s[j] - 'a')
            } else {
                upper |= 1 << (s[j] - 'A')
            }
            if lower == upper && j-i+1 > len(ans) {
                ans = s[i : j+1]
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为字符串的长度。需要枚举所有可能的子字符串，因此需要双重循环遍历字符串，总共可能有 $n^2$ 个连续的子字符串。

- 空间复杂度：$O(1)$。由于返回值不需要计算空间复杂度，除了需要两个整数变量用来标记以外不需要额外的空间。

#### 方法二：分治

**思路**

分治思想来源于「[395. 至少有K个重复字符的最长子串](https://leetcode-cn.com/problems/longest-substring-with-at-least-k-repeating-characters/)」，详细的解法与其相似。题目要求找到最长的美好子字符串，如果字符串本身即合法的美好字符串，此时最长的完美字符串即为字符串本身。由于字符串中含有部分字符 $\textit{ch}$ 只出现大写或者小写形式，如果字符串包含这些字符 $\textit{ch}$ 时，可以判定该字符串肯定不为完美字符串。一个字符串为美好字符串的必要条件是不包含这些非法字符。因此我们可以利用分治的思想，将字符串从这些非法的字符处切分成若干段，则满足要求的最长子串一定出现在某个被切分的段内，而不能跨越一个或多个段。

+ 递归时，$\textit{maxPos}$ 用来记录最长完美字符串的起始索引，$\textit{maxLen}$ 用来记录最长完美字符串的长度。

+ 每次检查区间 $[\textit{start}, \textit{end}]$ 中的子字符串是否为完美字符串，如果当前的字符串为合法的完美字符串，则将当前区间的字符串的长度与 $\textit{maxLen}$ 进行比较和替换；否则我们依次对当前字符串进行切分，然后递归检测切分后的字符串。

**代码**

```Java [sol2-Java]
class Solution {
    private int maxPos;
    private int maxLen;

    public String longestNiceSubstring(String s) {
        this.maxPos = 0;
        this.maxLen = 0;
        dfs(s, 0, s.length() - 1);
        return s.substring(maxPos, maxPos + maxLen);
    }

    public void dfs(String s, int start, int end) {
        if (start >= end) {
            return;
        }
        int lower = 0, upper = 0;
        for (int i = start; i <= end; ++i) {
            if (Character.isLowerCase(s.charAt(i))) {
                lower |= 1 << (s.charAt(i) - 'a');
            } else {
                upper |= 1 << (s.charAt(i) - 'A');
            }
        }
        if (lower == upper) {
            if (end - start + 1 > maxLen) {
                maxPos = start;
                maxLen = end - start + 1;
            }
            return;
        } 
        int valid = lower & upper;
        int pos = start;
        while (pos <= end) {
            start = pos;
            while (pos <= end && (valid & (1 << Character.toLowerCase(s.charAt(pos)) - 'a')) != 0) {
                ++pos;
            }
            dfs(s, start, pos - 1);
            ++pos;
        }
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    void dfs(const string & s, int start, int end, int & maxPos, int & maxLen) {
        if (start >= end) {
            return;
        }
        int lower = 0, upper = 0;
        for (int i = start; i <= end; ++i) {
            if (islower(s[i])) {
                lower |= 1 << (s[i] - 'a');
            } else {
                upper |= 1 << (s[i] - 'A');
            }
        }
        if (lower == upper) {
            if (end - start + 1 > maxLen) {
                maxPos = start;
                maxLen = end - start + 1;
            }
            return;
        } 
        int valid = lower & upper;
        int pos = start;
        while (pos <= end) {
            start = pos;
            while (pos <= end && valid & (1 << (tolower(s[pos]) - 'a'))) {
                ++pos;
            }
            dfs(s, start, pos - 1, maxPos, maxLen);
            ++pos;
        }
    }

    string longestNiceSubstring(string s) {
        int maxPos = 0, maxLen = 0;
        dfs(s, 0, s.size() - 1, maxPos, maxLen);
        return s.substr(maxPos, maxLen);
    }
};
```

```C# [sol2-C#]
public class Solution {
    private int maxPos;
    private int maxLen;

    public string LongestNiceSubstring(string s) {
        this.maxPos = 0;
        this.maxLen = 0;
        DFS(s, 0, s.Length - 1);
        return s.Substring(maxPos, maxLen);
    }

    public void DFS(String s, int start, int end) {
        if (start >= end) {
            return;
        }
        int lower = 0, upper = 0;
        for (int i = start; i <= end; ++i) {
            if (char.IsLower(s[i])) {
                lower |= 1 << (s[i] - 'a');
            } else {
                upper |= 1 << (s[i] - 'A');
            }
        }
        if (lower == upper) {
            if (end - start + 1 > maxLen) {
                maxPos = start;
                maxLen = end - start + 1;
            }
            return;
        } 
        int valid = lower & upper;
        int pos = start;
        while (pos <= end) {
            start = pos;
            while (pos <= end && (valid & (1 << char.ToLower(s[pos]) - 'a')) != 0) {
                ++pos;
            }
            DFS(s, start, pos - 1);
            ++pos;
        }
    }
}
```

```Python [sol2-Python3]
class Solution:
    def longestNiceSubstring(self, s: str) -> str:
        maxPos, maxLen = 0, 0
        def dfs(start, end):
            nonlocal maxPos, maxLen
            if start >= end:
                return
            lower, upper = 0, 0
            for i in range(start, end + 1):
                if s[i].islower():
                    lower|= 1 << (ord(s[i]) - ord('a'))
                else:
                    upper|= 1 << (ord(s[i]) - ord('A'))
            if lower == upper:
                if end - start + 1 > maxLen:
                    maxPos, maxLen = start, end - start + 1
                return
            pos, valid = start, lower & upper
            while pos <= end:
                start = pos
                while pos <= end and valid & (1 << (ord(s[pos].lower()) - ord('a'))):
                    pos += 1
                dfs(start, pos - 1)
                pos += 1
        dfs(0, len(s) - 1)
        return s[maxPos : maxPos + maxLen]
```

```C [sol2-C]
void dfs(const char * s, int start, int end, int * maxPos, int * maxLen) {
    if (start >= end) {
        return;
    }
    int lower = 0, upper = 0;
    for (int i = start; i <= end; ++i) {
        if (islower(s[i])) {
            lower |= 1 << (s[i] - 'a');
        } else {
            upper |= 1 << (s[i] - 'A');
        }
    }
    if (lower == upper) {
        if (end - start + 1 > *maxLen ) {
            *maxPos = start;
            *maxLen = end - start + 1;
        }
        return;
    } 
    int valid = lower & upper;
    int pos = start;
    while (pos <= end) {
        start = pos;
        while (pos <= end && valid & (1 << (tolower(s[pos]) - 'a'))) {
            ++pos;
        }
        dfs(s, start, pos - 1, maxPos, maxLen);
        ++pos;
    }
}

char * longestNiceSubstring(char * s){
    int maxPos = 0, maxLen = 0;
    dfs(s, 0, strlen(s) - 1, &maxPos, &maxLen);
    s[maxPos + maxLen] = '\0';
    return s + maxPos;
}
```

```go [sol2-Golang]
func longestNiceSubstring(s string) (ans string) {
    if s == "" {
        return
    }
    lower, upper := 0, 0
    for _, ch := range s {
        if unicode.IsLower(ch) {
            lower |= 1 << (ch - 'a')
        } else {
            upper |= 1 << (ch - 'A')
        }
    }
    if lower == upper {
        return s
    }
    valid := lower & upper
    for i := 0; i < len(s); i++ {
        start := i
        for i < len(s) && valid>>(unicode.ToLower(rune(s[i]))-'a')&1 == 1 {
            i++
        }
        if t := longestNiceSubstring(s[start:i]); len(t) > len(ans) {
            ans = t
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n \cdot |\Sigma|)$，其中 $n$ 为字符串的长度，$|\Sigma|$ 为字符集的大小，本题中字符串仅包含英文大小写字母，因此 $|\Sigma| = 52$。本题使用了递归，由于字符集最多只有 $\dfrac{|\Sigma|}{2}$ 个不同的英文字母，每次递归都会去掉一个英文字母的所有大小写形式，因此递归深度最多为 $\dfrac{|\Sigma|}{2}$。

- 空间复杂度：$O(|\Sigma|)$。由于递归深度最多为 $|\Sigma|$，因此需要使用 $O(|\Sigma|)$ 的递归栈空间。

#### 方法三：滑动窗口

**思路**

滑动窗口的解法同样参考「[395. 至少有K个重复字符的最长子串](https://leetcode-cn.com/problems/longest-substring-with-at-least-k-repeating-characters/)」。
我们枚举最长子串中的字符种类数目，它最小为 $1$，最大为 $\dfrac{|\Sigma|}{2}$，其中同一个字符的大小写形式视为同一种字符。

对于给定的字符种类数量 $\textit{typeNum}$，我们维护滑动窗口的左右边界 $l,r$、滑动窗口内部大小字符出现的次数 $\textit{upperCnt}, \textit{lowerCnt}$，以及滑动窗口内的字符种类数目 $\textit{total}$。当 $\textit{total} > \textit{typeNum}$ 时，我们不断地右移左边界 $l$，并对应地更新 $\textit{upperCnt}, \textit{lowerCnt}$ 以及 $\textit{total}$，直到 $\textit{total} \le \textit{typeNum}$ 为止。这样，对于任何一个右边界 $r$，我们都能找到最小的 $l$（记为 $l_{min}$，使得 $s[l_{min}...r]$ 之间的字符种类数目不多于 $\textit{typeNum}$。

完美字符串定义为所有的字符同时出现大写和小写形式，最长的完美字符串一定出现在某个窗口中。对于任何一组 $l_{min}, r$ 而言，我们需要判断当前 $s[l_{min}...r]$ 是否为完美字符串，检测方法如下：

+ 当前字符串中的字符种类数量为 $\textit{typeNum}$，当前字符串中同时出现大小写的字符的种类数量为 $\textit{cnt}$，只有满足 $\textit{cnt}$ 等于 $\textit{typeNum}$ 时，我们可以判定字符串为完美字符串。

+ 遍历 $\textit{upperCnt}, \textit{lowerCnt}$ 两个数组，第 $i$ 个字符同时满足 $\textit{upperCnt}[i] > 0, \textit{lowerCnt}[i] > 0$ 时，则认为第 $i$ 个字符的大小写形式同时出现。

根据上面的结论，当限定字符种类数目为 $\textit{typeNum}$ 时，满足题意的最长子串，就一定出自某个 $s[l_{min}...r]$。因此，在滑动窗口的维护过程中，就可以直接得到最长子串的大小。

最后，还剩下一个细节：如何在滑动窗口的同时高效地维护 $\textit{total}$ 和 $\textit{cnt}$。

+ 右移右边界 $r$ 时，假设 $s[r]$ 对应的字符的索引为 $\textit{idx}$，当满足 $\textit{upperCnt}[r] + \textit{lowerCnt}[r] = 1$ 时，则我们认为此时新增了一种字符，将 $\textit{total}$ 加 $1$。

+ 右移右边界 $r$ 时，假设 $s[r]$ 对应的字符的索引为 $\textit{idx}$，如果 $s[r]$ 为小写字母，右移右边界后，当满足 $\textit{lowerCnt}[idx] = 1$ 且 $\textit{upperCnt}[idx] > 0$ 时，则我们认为此时新增了一种大小写同时存在的字符，将 $\textit{cnt}$ 加 $1$；如果 $s[r]$ 为大写字母，右移右边界后，当满足 $\textit{upperCnt}[idx] = 1$ 且 $\textit{lowerCnt}[idx] > 0$ 时，则我们认为此时新增了一种大小写同时存在的字符，将 $\textit{cnt}$ 加 $1$。

+ 右移左边界 $l$ 时，假设 $s[l]$ 对应的字符的索引为 $\textit{idx}$，当满足 $\textit{upperCnt}[idx] + \textit{lowerCnt}[idx] = 1$ 时，右移左边界后则我们认为此时将减少一种字符，将 $\textit{total}$ 减 $1$。

+ 右移左边界 $l$ 时，假设 $s[l]$ 对应的字符的索引为 $\textit{idx}$，如果 $s[l]$ 为小写字母，右移左边界后，当满足 $\textit{lowerCnt}[idx] = 0$ 且 $\textit{upperCnt}[idx] > 0$ 时，则我们认为此时减少了一种大小写同时存在的字符，将 $\textit{cnt}$ 减 $1$；如果 $s[l]$ 为大写字母，右移左边界后，当满足 $\textit{upperCnt}[idx] = 0$ 且 $\textit{lowerCnt}[idx] > 0$ 时，则我们认为此时减少了一种大小写同时存在的字符，将 $\textit{cnt}$ 减 $1$。


**代码**

```Java [sol3-Java]
class Solution {
    private int maxPos;
    private int maxLen;

    public String longestNiceSubstring(String s) {
        this.maxPos = 0;
        this.maxLen = 0;
        
        int types = 0;
        for (int i = 0; i < s.length(); ++i) {
            types |= 1 << (Character.toLowerCase(s.charAt(i)) - 'a');
        }
        types = Integer.bitCount(types);
        for (int i = 1; i <= types; ++i) {
            check(s, i);
        }
        return s.substring(maxPos, maxPos + maxLen);
    }

    public void check(String s, int typeNum) {
        int[] lowerCnt = new int[26];
        int[] upperCnt = new int[26]; 
        int cnt = 0;
        for (int l = 0, r = 0, total = 0; r < s.length(); ++r) {
            int idx = Character.toLowerCase(s.charAt(r)) - 'a';
            if (Character.isLowerCase(s.charAt(r))) {
                ++lowerCnt[idx];
                if (lowerCnt[idx] == 1 && upperCnt[idx] > 0) {
                    ++cnt;
                }
            } else {
                ++upperCnt[idx];
                if (upperCnt[idx] == 1 && lowerCnt[idx] > 0) {
                    ++cnt;
                }
            }
            total += (lowerCnt[idx] + upperCnt[idx]) == 1 ? 1 : 0;
            while (total > typeNum) {
                idx = Character.toLowerCase(s.charAt(l)) - 'a';
                total -= (lowerCnt[idx] + upperCnt[idx]) == 1 ? 1 : 0;
                if (Character.isLowerCase(s.charAt(l))) {
                    --lowerCnt[idx];
                    if (lowerCnt[idx] == 0 && upperCnt[idx] > 0) {
                        --cnt;
                    }
                } else {
                    --upperCnt[idx];
                    if (upperCnt[idx] == 0 && lowerCnt[idx] > 0) {
                        --cnt;
                    }
                }
                ++l;
            }
            if (cnt == typeNum && r - l + 1 > maxLen) {
                maxPos = l;
                maxLen = r - l + 1;
            }
        }
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    string longestNiceSubstring(string s) {
        int maxPos = 0, maxLen = 0;
        auto check = [&](int typeNum) {
            vector<int> lowerCnt(26);
            vector<int> upperCnt(26);
            int cnt = 0;
            for (int l = 0, r = 0, total = 0; r < s.size(); ++r) {
                int idx = tolower(s[r]) - 'a';
                if (islower(s[r])) {
                    ++lowerCnt[idx];
                    if (lowerCnt[idx] == 1 && upperCnt[idx] > 0) {
                        ++cnt;
                    }
                } else {
                    ++upperCnt[idx];
                    if (upperCnt[idx] == 1 && lowerCnt[idx] > 0) {
                        ++cnt;
                    }
                }
                total += (lowerCnt[idx] + upperCnt[idx]) == 1 ? 1 : 0;

                while (total > typeNum) {
                    idx = tolower(s[l]) - 'a';
                    total -= (lowerCnt[idx] + upperCnt[idx]) == 1 ? 1 : 0;
                    if (islower(s[l])) {
                        --lowerCnt[idx];
                        if (lowerCnt[idx] == 0 && upperCnt[idx] > 0) {
                            --cnt;
                        }
                    } else {
                        --upperCnt[idx];
                        if (upperCnt[idx] == 0 && lowerCnt[idx] > 0) {
                            --cnt;
                        }
                    }
                    ++l;
                }
                if (cnt == typeNum && r - l + 1 > maxLen) {
                    maxPos = l;
                    maxLen = r - l + 1;
                }
            }
        };

        int mask = 0;
        for (char & ch : s) {
            mask |= 1 << (tolower(ch) - 'a');
        }
        int types = __builtin_popcount(mask);
        for (int i = 1; i <= types; ++i) {
            check(i);
        }
        return s.substr(maxPos, maxLen);
    }
};
```

```C# [sol3-C#]
public class Solution {
    private int maxPos;
    private int maxLen;

    public string LongestNiceSubstring(string s) {
        this.maxPos = 0;
        this.maxLen = 0;
        
        int types = 0;
        for (int i = 0; i < s.Length; ++i) {
            types |= 1 << (char.ToLower(s[i]) - 'a');
        }
        types = Count((uint) types);
        for (int i = 1; i <= types; ++i) {
            Check(s, i);
        }
        return s.Substring(maxPos, maxLen);
    }

    public void Check(string s, int typeNum) {
        int[] lowerCnt = new int[26];
        int[] upperCnt = new int[26];
        int cnt = 0;
        for (int l = 0, r = 0, total = 0; r < s.Length; ++r) {
            int idx = char.ToLower(s[r]) - 'a';
            if (char.IsLower(s[r])) {
                ++lowerCnt[idx];
                if (lowerCnt[idx] == 1 && upperCnt[idx] > 0) {
                    ++cnt;
                }
            } else {
                ++upperCnt[idx];
                if (upperCnt[idx] == 1 && lowerCnt[idx] > 0) {
                    ++cnt;
                }
            }
            total += (lowerCnt[idx] + upperCnt[idx]) == 1 ? 1 : 0;

            while (total > typeNum) {
                idx = char.ToLower(s[l]) - 'a';
                total -= (lowerCnt[idx] + upperCnt[idx]) == 1 ? 1 : 0;
                if (char.IsLower(s[l])) {
                    --lowerCnt[idx];
                    if (lowerCnt[idx] == 0 && upperCnt[idx] > 0) {
                        --cnt;
                    }
                } else {
                    --upperCnt[idx];
                    if (upperCnt[idx] == 0 && lowerCnt[idx] > 0) {
                        --cnt;
                    }
                }
                ++l;
            }
            if (cnt == typeNum && r - l + 1 > maxLen) {
                maxPos = l;
                maxLen = r - l + 1;
            }
        }
    }

    public static int Count(uint x) {
        x = x - ((x >> 1) & 0x55555555);
        x = (x & 0x33333333) + ((x >> 2) & 0x33333333);
        x = (x + (x >> 4)) & 0x0f0f0f0f;
        x = x + (x >> 8);
        x = x + (x >> 16);
        return (int) x & 0x3f;
    }
}
```

```Python [sol3-Python3]
class Solution:
    def longestNiceSubstring(self, s: str) -> str:
        def check(typeNum):
            nonlocal maxPos, maxLen
            lowerCnt = [0] * 26
            upperCnt = [0] * 26
            l, r, total, cnt = 0, 0, 0, 0
            while r < len(s):
                idx = ord(s[r].lower()) - ord('a')
                if s[r].islower():
                    lowerCnt[idx] += 1
                    if lowerCnt[idx] == 1 and upperCnt[idx] > 0:
                        cnt += 1
                else:
                    upperCnt[idx] += 1
                    if upperCnt[idx] == 1 and lowerCnt[idx] > 0:
                        cnt += 1
                if lowerCnt[idx] + upperCnt[idx] == 1:
                    total += 1

                while total > typeNum :
                    idx = ord(s[l].lower()) - ord('a')
                    if lowerCnt[idx] + upperCnt[idx] == 1:
                        total -= 1
                    if s[l].islower():
                        lowerCnt[idx] -= 1
                        if lowerCnt[idx] == 0 and upperCnt[idx] > 0:
                            cnt -= 1
                    else:
                        upperCnt[idx] -= 1
                        if upperCnt[idx] == 0 and lowerCnt[idx] > 0:
                            cnt -= 1
                    l += 1
                if cnt == typeNum and r - l + 1 > maxLen:
                    maxPos, maxLen = l, r - l + 1
                r += 1
        
        maxPos, maxLen = 0, 0
        types = len(set(s.lower()))
        for i in range(1, types + 1):
            check(i)
        return s[maxPos: maxPos + maxLen]
```

```C [sol3-C]
void check(const char * s, int typeNum, int * maxPos, int * maxLen) {
    int lowerCnt[26], upperCnt[26];
    memset(lowerCnt, 0, sizeof(lowerCnt));
    memset(upperCnt, 0, sizeof(upperCnt));
    int n = strlen(s);
    int cnt = 0;
    for (int l = 0, r = 0, total = 0; r < n; ++r) {
        int idx = tolower(s[r]) - 'a';
        if (islower(s[r])) {
            ++lowerCnt[idx];
            if (lowerCnt[idx] == 1 && upperCnt[idx] > 0) {
                ++cnt;
            }
        } else {
            ++upperCnt[idx];
            if (upperCnt[idx] == 1 && lowerCnt[idx] > 0) {
                ++cnt;
            }
        }
        total += (lowerCnt[idx] + upperCnt[idx]) == 1 ? 1 : 0;
        
        while (total > typeNum) {
            int idx = tolower(s[l]) - 'a';
            total -= (lowerCnt[idx] + upperCnt[idx]) == 1 ? 1 : 0;
            if (islower(s[l])) {
                --lowerCnt[idx];
                if (lowerCnt[idx] == 0 && upperCnt[idx] > 0) {
                    --cnt;
                }
            } else {
                --upperCnt[idx];
                if (upperCnt[idx] == 0 && lowerCnt[idx] > 0) {
                    --cnt;
                }
            }
            ++l;
        }
        if (cnt == typeNum && r - l + 1 > *maxLen) {
            *maxPos = l;
            *maxLen = r - l + 1;
        }
    }
}

char * longestNiceSubstring(char * s){
    int maxPos = 0, maxLen = 0;
    int mask = 0;
    int n = strlen(s);
    for (int i = 0; i < n; ++i) {
        mask |= 1 << (tolower(s[i]) - 'a');
    }
    int types = __builtin_popcount(mask);
    for (int i = 1; i <= types; ++i) {
        check(s, i, &maxPos, &maxLen);
    }
    s[maxPos + maxLen] = '\0';
    return s + maxPos;
}
```

```JavaScript [sol3-JavaScript]
var longestNiceSubstring = function(s) {
    this.maxPos = 0;
    this.maxLen = 0;
    
    let types = 0;
    for (let i = 0; i < s.length; ++i) {
        types |= 1 << (s[i].toLowerCase().charCodeAt() - 'a'.charCodeAt());
    }
    types = bitCount(types);
    for (let i = 1; i <= types; ++i) {
        check(s, i);
    }
    return s.slice(maxPos, maxPos + maxLen);
};

const check = (s, typeNum) => {
    const lowerCnt = new Array(26).fill(0);
    const upperCnt = new Array(26).fill(0);
    let cnt = 0;
    for (let l = 0, r = 0, total = 0; r < s.length; ++r) {
        let idx = s[r].toLowerCase().charCodeAt() - 'a'.charCodeAt();
        if ('a' <= s[r] && s[r] <= 'z') {
            ++lowerCnt[idx];
            if (lowerCnt[idx] === 1 && upperCnt[idx] > 0) {
                ++cnt;
            }
        } else {
            ++upperCnt[idx];
            if (upperCnt[idx] === 1 && lowerCnt[idx] > 0) {
                ++cnt;
            }
        }
        total += (lowerCnt[idx] + upperCnt[idx]) === 1 ? 1 : 0;
        while (total > typeNum) {
            idx = s[l].toLowerCase().charCodeAt() - 'a'.charCodeAt();
            total -= (lowerCnt[idx] + upperCnt[idx]) === 1 ? 1 : 0;
            if ('a' <= s[l] && s[l] <= 'z') {
                --lowerCnt[idx];
                if (lowerCnt[idx] === 0 && upperCnt[idx] > 0) {
                    --cnt;
                }
            } else {
                --upperCnt[idx];
                if (upperCnt[idx] === 0 && lowerCnt[idx] > 0) {
                    --cnt;
                }
            }
            ++l;
        }
        if (cnt === typeNum && r - l + 1 > maxLen) {
            maxPos = l;
            maxLen = r - l + 1;
        }
    }
}

var bitCount = function(n) {
    let ret = 0;
    while (n) {
        n &= n - 1;
        ret++;
    }
    return ret;
};
```

```go [sol3-Golang]
func longestNiceSubstring(s string) (ans string) {
    mask := uint(0)
    for _, ch := range s {
        mask |= 1 << (unicode.ToLower(ch) - 'a')
    }
    maxTypeNum := bits.OnesCount(mask)

    for typeNum := 1; typeNum <= maxTypeNum; typeNum++ {
        var lowerCnt, upperCnt [26]int
        var total, cnt, l int
        for r, ch := range s {
            idx := unicode.ToLower(ch) - 'a'
            if unicode.IsLower(ch) {
                lowerCnt[idx]++
                if lowerCnt[idx] == 1 && upperCnt[idx] > 0 {
                    cnt++
                }
            } else {
                upperCnt[idx]++
                if upperCnt[idx] == 1 && lowerCnt[idx] > 0 {
                    cnt++
                }
            }
            if lowerCnt[idx]+upperCnt[idx] == 1 {
                total++
            }

            for total > typeNum {
                idx := unicode.ToLower(rune(s[l])) - 'a'
                if lowerCnt[idx]+upperCnt[idx] == 1 {
                    total--
                }
                if unicode.IsLower(rune(s[l])) {
                    lowerCnt[idx]--
                    if lowerCnt[idx] == 0 && upperCnt[idx] > 0 {
                        cnt--
                    }
                } else {
                    upperCnt[idx]--
                    if upperCnt[idx] == 0 && lowerCnt[idx] > 0 {
                        cnt--
                    }
                }
                l++
            }

            if cnt == typeNum && r-l+1 > len(ans) {
                ans = s[l : r+1]
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(N \cdot |\Sigma|)$，其中 $N$ 为字符串的长度，$|\Sigma|$ 为字符集的大小，本题中字符集限定为大小写英文字母，$|\Sigma| = 52$。我们需要遍历所有可能的字符种类数量，共 $\dfrac{|\Sigma|}{2}$ 种可能性，内层循环中滑动窗口的复杂度为 $O(2N)$，因此总的时间复杂度为 $O(N \cdot |\Sigma|)$ 。

- 空间复杂度：$O(|\Sigma|)$。需要 $O(|\Sigma|)$ 存储所有大小写字母的计数。
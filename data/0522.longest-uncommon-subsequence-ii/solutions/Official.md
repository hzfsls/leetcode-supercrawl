## [522.最长特殊序列 II 中文官方题解](https://leetcode.cn/problems/longest-uncommon-subsequence-ii/solutions/100000/zui-chang-te-shu-xu-lie-ii-by-leetcode-s-bo2e)

#### 方法一：枚举每个字符串

**思路与算法**

对于给定的某个字符串 $\textit{str}[i]$，如果它的一个子序列 $\textit{sub}$ 是「特殊序列」，那么 $\textit{str}[i]$ 本身也是一个「特殊序列」。

> 这是因为如果 $\textit{sub}$ 没有在除了 $\textit{str}[i]$ 之外的字符串中以子序列的形式出现过，那么给 $\textit{sub}$ 不断地添加字符，它也不会出现。而 $\textit{str}[i]$ 就是 $\textit{sub}$ 添加若干个（可以为零个）字符得到的结果。

因此我们只需要使用一个双重循环，外层枚举每一个字符串 $\textit{str}[i]$ 作为特殊序列，内层枚举每一个字符串 $\textit{str}[j]~(i \neq j)$，判断 $\textit{str}[i]$ 是否不为 $\textit{str}[j]$ 的子序列即可。

要想判断 $\textit{str}[i]$ 是否为 $\textit{str}[j]$ 的子序列，我们可以使用贪心 + 双指针的方法：即初始时指针 $\textit{pt}_i$ 和 $\textit{pt}_j$ 分别指向两个字符串的首字符。如果两个字符相同，那么两个指针都往右移动一个位置，表示匹配成功；否则只往右移动指针 $\textit{pt}_j$，表示匹配失败。如果 $\textit{pt}_i$ 遍历完了整个字符串，就说明 $\textit{str}[i]$ 是 $\textit{str}[j]$ 的子序列。

在所有满足要求的 $\textit{str}[i]$ 中，我们选出最长的那个，返回其长度作为答案。如果不存在满足要求的字符串，那么返回 $-1$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int findLUSlength(vector<string>& strs) {
        auto is_subseq = [](const string& s, const string& t) -> bool {
            int pt_s = 0, pt_t = 0;
            while (pt_s < s.size() && pt_t < t.size()) {
                if (s[pt_s] == t[pt_t]) {
                    ++pt_s;
                }
                ++pt_t;
            }
            return pt_s == s.size();
        };

        int n = strs.size();
        int ans = -1;
        for (int i = 0; i < n; ++i) {
            bool check = true;
            for (int j = 0; j < n; ++j) {
                if (i != j && is_subseq(strs[i], strs[j])) {
                    check = false;
                    break;
                }
            }
            if (check) {
                ans = max(ans, static_cast<int>(strs[i].size()));
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int findLUSlength(String[] strs) {
        int n = strs.length;
        int ans = -1;
        for (int i = 0; i < n; ++i) {
            boolean check = true;
            for (int j = 0; j < n; ++j) {
                if (i != j && isSubseq(strs[i], strs[j])) {
                    check = false;
                    break;
                }
            }
            if (check) {
                ans = Math.max(ans, strs[i].length());
            }
        }
        return ans;
    }

    public boolean isSubseq(String s, String t) {
        int ptS = 0, ptT = 0;
        while (ptS < s.length() && ptT < t.length()) {
            if (s.charAt(ptS) == t.charAt(ptT)) {
                ++ptS;
            }
            ++ptT;
        }
        return ptS == s.length();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int FindLUSlength(string[] strs) {
        int n = strs.Length;
        int ans = -1;
        for (int i = 0; i < n; ++i) {
            bool check = true;
            for (int j = 0; j < n; ++j) {
                if (i != j && IsSubseq(strs[i], strs[j])) {
                    check = false;
                    break;
                }
            }
            if (check) {
                ans = Math.Max(ans, strs[i].Length);
            }
        }
        return ans;
    }

    public bool IsSubseq(string s, string t) {
        int ptS = 0, ptT = 0;
        while (ptS < s.Length && ptT < t.Length) {
            if (s[ptS] == t[ptT]) {
                ++ptS;
            }
            ++ptT;
        }
        return ptS == s.Length;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findLUSlength(self, strs: List[str]) -> int:
        def is_subseq(s: str, t: str) -> bool:
            pt_s = pt_t = 0
            while pt_s < len(s) and pt_t < len(t):
                if s[pt_s] == t[pt_t]:
                    pt_s += 1
                pt_t += 1
            return pt_s == len(s)
        
        ans = -1
        for i, s in enumerate(strs):
            check = True
            for j, t in enumerate(strs):
                if i != j and is_subseq(s, t):
                    check = False
                    break
            if check:
                ans = max(ans, len(s))
        
        return ans
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

bool is_subseq(const char *s, const char *t) {
    int pt_s = 0, pt_t = 0;
    int len_s = strlen(s), len_t = strlen(t);
    while (pt_s < len_s && pt_t < len_t) {
        if (s[pt_s] == t[pt_t]) {
            ++pt_s;
        }
        ++pt_t;
    }
    return pt_s == len_s;
}

int findLUSlength(char ** strs, int strsSize){
    int ans = -1;
    for (int i = 0; i < strsSize; ++i) {
        bool check = true;
        for (int j = 0; j < strsSize; ++j) {
            if (i != j && is_subseq(strs[i], strs[j])) {
                check = false;
                break;
            }
        }
        if (check) {
            ans = MAX(ans, (int)strlen(strs[i]));
        }
    }
    return ans;
}
```

```go [sol1-Golang]
func isSubseq(s, t string) bool {
    ptS := 0
    for ptT := range t {
        if s[ptS] == t[ptT] {
            if ptS++; ptS == len(s) {
                return true
            }
        }
    }
    return false
}

func findLUSlength(strs []string) int {
    ans := -1
next:
    for i, s := range strs {
        for j, t := range strs {
            if i != j && isSubseq(s, t) {
                continue next
            }
        }
        if len(s) > ans {
            ans = len(s)
        }
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var findLUSlength = function(strs) {
    const n = strs.length;
    let ans = -1;
    for (let i = 0; i < n; ++i) {
        let check = true;
        for (let j = 0; j < n; ++j) {
            if (i !== j && isSubseq(strs[i], strs[j])) {
                check = false;
                break;
            }
        }
        if (check) {
            ans = Math.max(ans, strs[i].length);
        }
    }
    return ans;
};

const isSubseq = (s, t) => {
    let ptS = 0, ptT = 0;
    while (ptS < s.length && ptT < t.length) {
        if (s[ptS] === t[ptT]) {
            ++ptS;
        }
        ++ptT;
    }
    return ptS === s.length;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2 \cdot l)$，其中 $n$ 是数组 $\textit{strs}$ 的长度，$l$ 是字符串的平均长度。

- 空间复杂度：$O(1)$。
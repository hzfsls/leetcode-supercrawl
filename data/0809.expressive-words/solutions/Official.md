#### 方法一：双指针

**思路与算法**

我们可以依次判断数组 $\textit{words}$ 中的每一个字符串是否可以扩张成给定的字符串 $s$。

假设我们需要判断 $t$ 是否可以扩张成 $s$，我们可以使用双指针来解决这个问题。两个指针 $i$ 和 $j$ 初始时分别指向字符串 $s$ 和 $t$ 的首个位置。在双指针遍历的过程中：

- 首先我们需要保证 $s[i] = t[j]$，否则这两部分不是相同的字母，无法进行扩张；

- 随后我们不断地向右移动两个指针，直到移动到与之前不同的字母，或者超出字符串的边界。假设字符串 $s$ 有 $\textit{cnt}_i$ 个相同的字母，$t$ 有 $\textit{cnt}_j$ 个相同的字母，那么我们必须保证 $\textit{cnt}_i \geq \textit{cnt}_j$，因为扩张不可能减少字符的数量。当 $\textit{cnt}_i = \textit{cnt}_j$ 时，我们无需进行扩张，这样也是满足要求的；$\textit{cnt}_i > \textit{cnt}_j$，由于扩张至少会达到长度 $3$ 及以上，因此需要保证 $\textit{cnt}_i \geq 3$ 即可。

当某一个指针超出边界时，我们就可以退出上述的遍历过程。此时，如果另一个指针也超出边界，说明两个字符串同时遍历完成，即 $t$ 可以扩张成 $s$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int expressiveWords(string s, vector<string>& words) {
        int ans = 0;
        for (const string& word: words) {
            if (expand(s, word)) {
                ++ans;
            }
        }
        return ans;
    }

private:
    bool expand(const string& s, const string& t) {
        int i = 0, j = 0;
        while (i < s.size() && j < t.size()) {
            if (s[i] != t[j]) {
                return false;
            }
            char ch = s[i];
            int cnti = 0;
            while (i < s.size() && s[i] == ch) {
                ++cnti;
                ++i;
            }
            int cntj = 0;
            while (j < t.size() && t[j] == ch) {
                ++cntj;
                ++j;
            }
            if (cnti < cntj) {
                return false;
            }
            if (cnti != cntj && cnti < 3) {
                return false;
            }
        }
        return i == s.size() && j == t.size();
    }
};
```

```Java [sol1-Java]
class Solution {
    public int expressiveWords(String s, String[] words) {
        int ans = 0;
        for (String word : words) {
            if (expand(s, word)) {
                ++ans;
            }
        }
        return ans;
    }

    private boolean expand(String s, String t) {
        int i = 0, j = 0;
        while (i < s.length() && j < t.length()) {
            if (s.charAt(i) != t.charAt(j)) {
                return false;
            }
            char ch = s.charAt(i);
            int cnti = 0;
            while (i < s.length() && s.charAt(i) == ch) {
                ++cnti;
                ++i;
            }
            int cntj = 0;
            while (j < t.length() && t.charAt(j) == ch) {
                ++cntj;
                ++j;
            }
            if (cnti < cntj) {
                return false;
            }
            if (cnti != cntj && cnti < 3) {
                return false;
            }
        }
        return i == s.length() && j == t.length();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int ExpressiveWords(string s, string[] words) {
        int ans = 0;
        foreach (string word in words) {
            if (Expand(s, word)) {
                ++ans;
            }
        }
        return ans;
    }

    private bool Expand(string s, string t) {
        int i = 0, j = 0;
        while (i < s.Length && j < t.Length) {
            if (s[i] != t[j]) {
                return false;
            }
            char ch = s[i];
            int cnti = 0;
            while (i < s.Length && s[i] == ch) {
                ++cnti;
                ++i;
            }
            int cntj = 0;
            while (j < t.Length && t[j] == ch) {
                ++cntj;
                ++j;
            }
            if (cnti < cntj) {
                return false;
            }
            if (cnti != cntj && cnti < 3) {
                return false;
            }
        }
        return i == s.Length && j == t.Length;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def expressiveWords(self, s: str, words: List[str]) -> int:
        def expand(s: str, t: str) -> bool:
            i = j = 0
            while i < len(s) and j < len(t):
                if s[i] != t[j]:
                    return False
                ch = s[i]
                cnti = 0
                while i < len(s) and s[i] == ch:
                    cnti += 1
                    i += 1
                cntj = 0
                while j < len(t) and t[j] == ch:
                    cntj += 1
                    j += 1
                
                if cnti < cntj:
                    return False
                if cnti != cntj and cnti < 3:
                    return False
            
            return i == len(s) and j == len(t)
        
        return sum(int(expand(s, word)) for word in words)
```

```C [sol1-C]
bool expand(const char *s, const char *t) {
    int i = 0, j = 0;
    while (s[i] != '\0' && t[j] != '\0') {
        if (s[i] != t[j]) {
            return false;
        }
        char ch = s[i];
        int cnti = 0;
        while (s[i] != '\0' && s[i] == ch) {
            ++cnti;
            ++i;
        }
        int cntj = 0;
        while (t[j] != '\0' && t[j] == ch) {
            ++cntj;
            ++j;
        }
        if (cnti < cntj) {
            return false;
        }
        if (cnti != cntj && cnti < 3) {
            return false;
        }
    }
    return s[i] == '\0' && t[j] == '\0';
}

int expressiveWords(char * s, char ** words, int wordsSize){
    int ans = 0;
    for (int i = 0; i < wordsSize; i++) {
        if (expand(s, words[i])) {
            ++ans;
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var expressiveWords = function(s, words) {
    let ans = 0;
    for (const word of words) {
        if (expand(s, word)) {
            ++ans;
        }
    }
    return ans;
}

const expand = (s, t) => {
    let i = 0, j = 0;
    while (i < s.length && j < t.length) {
        if (s[i] !== t[j]) {
            return false;
        }
        const ch = s[i];
        let cnti = 0;
        while (i < s.length && s[i] === ch) {
            ++cnti;
            ++i;
        }
        let cntj = 0;
        while (j < t.length && t[j] === ch) {
            ++cntj;
            ++j;
        }
        if (cnti < cntj) {
            return false;
        }
        if (cnti !== cntj && cnti < 3) {
            return false;
        }
    }
    return i === s.length && j === t.length;
};
```

```go [sol1-Golang]
func expand(s, t string) bool {
    n, m := len(s), len(t)
    i, j := 0, 0
    for i < n && j < m {
        if s[i] != t[j] {
            return false
        }
        ch := s[i]
        cntI := 0
        for i < n && s[i] == ch {
            cntI++
            i++
        }
        cntJ := 0
        for j < m && t[j] == ch {
            cntJ++
            j++
        }
        if cntI < cntJ || cntI > cntJ && cntI < 3 {
            return false
        }
    }
    return i == n && j == m
}

func expressiveWords(s string, words []string) (ans int) {
    for _, word := range words {
        if expand(s, word) {
            ans++
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n|s| + \sum_i |\textit{words}_i|)$，其中 $n$ 是数组 $\textit{words}$ 的长度，$|s|$ 和 $\textit{words}_i$ 分别是字符串 $s$ 和数组 $\textit{words}$ 中第 $i$ 个字符串的长度。

- 空间复杂度：$O(1)$。
## [953.验证外星语词典 中文官方题解](https://leetcode.cn/problems/verifying-an-alien-dictionary/solutions/100000/yan-zheng-wai-xing-yu-ci-dian-by-leetcod-jew7)

#### 方法一：直接遍历

**思路与算法**

题目要求按照给定的字母表 $\textit{order}$ 的顺序，检测给定的字符串数组是否按照 $\textit{order}$ 的字典升序排列，我们只需要依次检测 $\textit{strs}$ 中的字符串前一个字符串和后一个字符串在给定的字母表下的字典序即可。具体检测如下：

+ 首先将给定的 $\textit{order}$ 转化为字典序索引 $\textit{index}$，$\textit{index}[i]$ 表示字符 $i$ 在字母表 $\textit{order}$ 的排序索引，$\textit{index}[i] > \textit{index}[j]$ 即表示字符 $i$ 在字母表中的字典序比字符 $j$ 的字典序大，$\textit{index}[i] < \textit{index}[j]$ 即表示字符 $i$ 在字母表中的字典序比字符 $j$ 的字典序小。

+ 依次检测第 $i$ 个单词 $\textit{strs}[i]$ 与第 $i-1$ 个单词 $\textit{strs}[i-1]$ 的字典序大小，我们可以依次判断两个单词中从左到右每个字符的字典序大小，当第一次出现两个字符的字典序不同时，即可判断两个字符串的字典序的大小。

+ 特殊情况需要处理，设 $\textit{strs}[i]$ 的长度为 $m$，$\textit{strs}[i]$ 的长度小于 $\textit{strs}[i-1]$ 的长度且 $\textit{strs}[i]$ 的前 $m$ 个字符与 $\textit{strs}[i-1]$ 的前 $m$ 个字符相等，此时 $\textit{strs}[i-1]$ 的字典序大于 $\textit{strs}[i]$ 的字典序。

**代码**

```Python [sol1-Python3]
class Solution:
    def isAlienSorted(self, words: List[str], order: str) -> bool:
        index = {c: i for i, c in enumerate(order)}
        return all(s <= t for s, t in pairwise([index[c] for c in word] for word in words))
```

```Java [sol1-Java]
class Solution {
    public boolean isAlienSorted(String[] words, String order) {
        int[] index = new int[26];
        for (int i = 0; i < order.length(); ++i) {
            index[order.charAt(i) - 'a'] = i;
        }
        for (int i = 1; i < words.length; i++) {
            boolean valid = false;
            for (int j = 0; j < words[i - 1].length() && j < words[i].length(); j++) {
                int prev = index[words[i - 1].charAt(j) - 'a'];
                int curr = index[words[i].charAt(j) - 'a'];
                if (prev < curr) {
                    valid = true;
                    break;
                } else if (prev > curr) {
                    return false;
                }
            }
            if (!valid) {
                /* 比较两个字符串的长度 */
                if (words[i - 1].length() > words[i].length()) {
                    return false;
                }
            }
        }
        return true;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool isAlienSorted(vector<string>& words, string order) {
        vector<int> index(26);
        for (int i = 0; i < order.size(); i++) {
            index[order[i] - 'a'] = i;
        }
        for (int i = 1; i < words.size(); i++) {
            bool valid = false;
            for (int j = 0; j < words[i - 1].size() && j < words[i].size(); j++) {
                int prev = index[words[i - 1][j] - 'a'];
                int curr = index[words[i][j] - 'a'];
                if (prev < curr) {
                    valid = true;
                    break;
                } else if (prev > curr) {
                    return false;
                }
            }
            if (!valid) {
                /* 比较两个字符串的长度 */
                if (words[i - 1].size() > words[i].size()) {
                    return false;
                }
            }
        }
        return true;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public bool IsAlienSorted(string[] words, string order) {
        int[] index = new int[26];
        for (int i = 0; i < order.Length; ++i) {
            index[order[i] - 'a'] = i;
        }
        for (int i = 1; i < words.Length; i++) {
            bool valid = false;
            for (int j = 0; j < words[i - 1].Length && j < words[i].Length; j++) {
                int prev = index[words[i - 1][j] - 'a'];
                int curr = index[words[i][j] - 'a'];
                if (prev < curr) {
                    valid = true;
                    break;
                } else if (prev > curr) {
                    return false;
                }
            }
            if (!valid) {
                /* 比较两个字符串的长度 */
                if (words[i - 1].Length > words[i].Length) {
                    return false;
                }
            }
        }
        return true;
    }
}
```

```C [sol1-C]
bool isAlienSorted(char ** words, int wordsSize, char * order){
    int index[26];
    int len = strlen(order);
    for (int i = 0; i < len; i++) {
        index[order[i] - 'a'] = i;
    }
    for (int i = 1; i < wordsSize; i++) {
        bool valid = false;
        int l1 = strlen(words[i - 1]);
        int l2 = strlen(words[i]);
        int n = l1 < l2 ? l1 : l2;
        for (int j = 0; j < n; j++) {
            int prev = index[words[i - 1][j] - 'a'];
            int curr = index[words[i][j] - 'a'];
            if (prev < curr) {
                valid = true;
                break;
            } else if (prev > curr) {
                return false;
            }
        }
        if (!valid) {
            /* 比较两个字符串的长度 */
            if (l1 > l2) {
                return false;
            }
        }
    }
    return true;
}
```

```JavaScript [sol1-JavaScript]
var isAlienSorted = function(words, order) {
    const index = new Array(26).fill(0);
    for (let i = 0; i < order.length; ++i) {
        index[order[i].charCodeAt() - 'a'.charCodeAt()] = i;
    }
    for (let i = 1; i < words.length; i++) {
        let valid = false;
        for (let j = 0; j < words[i - 1].length && j < words[i].length; j++) {
            let prev = index[words[i - 1][j].charCodeAt() - 'a'.charCodeAt()];
            let curr = index[words[i][j].charCodeAt() - 'a'.charCodeAt()];
            if (prev < curr) {
                valid = true;
                break;
            } else if (prev > curr) {
                return false;
            }
        }
        if (!valid) {
            /* 比较两个字符串的长度 */
            if (words[i - 1].length > words[i].length) {
                return false;
            }
        }
    }
    return true;
};
```

```go [sol1-Golang]
func isAlienSorted(words []string, order string) bool {
    index := [26]int{}
    for i, c := range order {
        index[c-'a'] = i
    }
next:
    for i := 1; i < len(words); i++ {
        for j := 0; j < len(words[i-1]) && j < len(words[i]); j++ {
            pre, cur := index[words[i-1][j]-'a'], index[words[i][j]-'a']
            if pre > cur {
                return false
            }
            if pre < cur {
                continue next
            }
        }
        if len(words[i-1]) > len(words[i]) {
            return false
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(m \times n)$，其中 $m$ 为字符串数组的长度，$n$ 为数组中字符串的平均长度，每个字符串需要前一个字符串进行比较，因此时间复杂度为 $O(m \times n)$。

- 空间复杂度：$O(C)$。其中 $C$ 表示字母表的长度，需要存储字母表 $\textit{order}$ 每个字符的字典序索引，题目中给定的字母表的长度为 $C = 26$。
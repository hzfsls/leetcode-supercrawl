## [1813.句子相似性 III 中文官方题解](https://leetcode.cn/problems/sentence-similarity-iii/solutions/100000/ju-zi-xiang-si-xing-iii-by-leetcode-solu-vjy7)
#### 方法一：字符串按空格分割 + 双指针

**思路**

根据题意，两个句子 $\textit{sentence}_1$ 和 $\textit{sentence}_2$，如果是相似的，那么这两个句子按空格分割得到的字符串数组 $\textit{words}_1$ 和 $\textit{words}_2$，一定能通过往其中一个字符串数组中插入某个字符串数组（可以为空），得到另一个字符串数组。这个验证可以通过双指针完成。$i$ 表示两个字符串数组从左开始，最多有 $i$ 个字符串相同。$j$ 表示剩下的字符串数组从右开始，最多有 $j$ 个字符串相同。如果 $i+j$ 正好是某个字符串数组的长度，那么原字符串就是相似的。

**代码**

```Python [sol1-Python3]
class Solution:
    def areSentencesSimilar(self, sentence1: str, sentence2: str) -> bool:
        words1 = sentence1.split()
        words2 = sentence2.split()
        i, j = 0, 0
        while i < len(words1) and i < len(words2) and words1[i] == words2[i]:
            i += 1
        while j < len(words1) - i and j < len(words2) - i and words1[-j - 1] == words2[-j - 1]:
            j += 1
        return i + j == min(len(words1), len(words2))
```

```Java [sol1-Java]
class Solution {
    public boolean areSentencesSimilar(String sentence1, String sentence2) {
        String[] words1 = sentence1.split(" ");
        String[] words2 = sentence2.split(" ");
        int i = 0, j = 0;
        while (i < words1.length && i < words2.length && words1[i].equals(words2[i])) {
            i++;
        }
        while (j < words1.length - i && j < words2.length - i && words1[words1.length - j - 1].equals(words2[words2.length - j - 1])) {
            j++;
        }
        return i + j == Math.min(words1.length, words2.length);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool AreSentencesSimilar(string sentence1, string sentence2) {
        string[] words1 = sentence1.Split(new char[]{' '});
        string[] words2 = sentence2.Split(new char[]{' '});
        int i = 0, j = 0;
        while (i < words1.Length && i < words2.Length && words1[i].Equals(words2[i])) {
            i++;
        }
        while (j < words1.Length - i && j < words2.Length - i && words1[words1.Length - j - 1].Equals(words2[words2.Length - j - 1])) {
            j++;
        }
        return i + j == Math.Min(words1.Length, words2.Length);
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string_view> split(const string & str, char target) {
        vector<string_view> res;
        string_view s(str);
        int pos = 0;
        while (pos < s.size()) {
            while (pos < s.size() && s[pos] == target) {
                pos++;
            }
            int start = pos;
            while (pos < s.size() && s[pos] != target) {
                pos++;
            }
            if (pos > start) {
                res.emplace_back(s.substr(start, pos - start));
            }
        }
        return res;
    }

    bool areSentencesSimilar(string sentence1, string sentence2) {
        vector<string_view> words1 = split(sentence1, ' ');
        vector<string_view> words2 = split(sentence2, ' ');
        int i = 0, j = 0;
        while (i < words1.size() && i < words2.size() && words1[i] == words2[i]) {
            i++;
        }
        while (j < words1.size() - i && j < words2.size() - i && words1[words1.size() - j - 1] == (words2[words2.size() - j - 1])) {
            j++;
        }
        return i + j == min(words1.size(), words2.size());
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

bool areSentencesSimilar(char * sentence1, char * sentence2) {
    int len1 = strlen(sentence1), len2 = strlen(sentence2);
    char *words1[len1], *words2[len2];
    int words1Size = 0, words2Size = 0;
    char *p = strtok(sentence1, " ");
    while (p != NULL) {
        words1[words1Size++] = p;
        p = strtok(NULL, " ");
    }
    p = strtok(sentence2, " ");
    while (p != NULL) {
        words2[words2Size++] = p;
        p = strtok(NULL, " ");
    }
    int i = 0, j = 0;
    while (i < words1Size && i < words2Size && strcmp(words1[i], words2[i]) == 0) {
        i++;
    }
    while (j < words1Size - i && j < words2Size - i && strcmp(words1[words1Size - j - 1], words2[words2Size - j - 1]) == 0) {
        j++;
    }
    return i + j == MIN(words1Size, words2Size);
}
```

```go [sol1-Golang]
func areSentencesSimilar(sentence1, sentence2 string) bool {
    words1 := strings.Split(sentence1, " ")
    words2 := strings.Split(sentence2, " ")
    i, n := 0, len(words1)
    j, m := 0, len(words2)
    for i < n && i < m && words1[i] == words2[i] {
        i++
    }
    for j < n-i && j < m-i && words1[n-j-1] == words2[m-j-1] {
        j++
    }
    return i+j == min(n, m)
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
var areSentencesSimilar = function(sentence1, sentence2) {
    const words1 = sentence1.split(" ");
    const words2 = sentence2.split(" ");
    let i = 0, j = 0;
    while (i < words1.length && i < words2.length && words1[i] === words2[i]) {
        i++;
    }
    while (j < words1.length - i && j < words2.length - i && words1[words1.length - j - 1] === words2[words2.length - j - 1]) {
        j++;
    }
    return i + j == Math.min(words1.length, words2.length);
};
```

**复杂度分析**

- 时间复杂度：$O(m+n)$，其中 $m$ 是 $\textit{sentence}_1$ 的长度，$n$ 是 $\textit{sentence}_2$ 的长度。字符串分割和双指针判断操作都需要遍历 $O(m+n)$ 个字符。

- 空间复杂度：$O(m+n)$。字符串分割需要 $O(m+n)$ 的空间，双指针消耗 $O(1)$ 空间。
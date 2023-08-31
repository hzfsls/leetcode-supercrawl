## [290.单词规律 中文官方题解](https://leetcode.cn/problems/word-pattern/solutions/100000/dan-ci-gui-lu-by-leetcode-solution-6vqv)
#### 方法一：哈希表

**思路及解法**

在本题中，我们需要判断字符与字符串之间是否恰好一一对应。即任意一个字符都对应着唯一的字符串，任意一个字符串也只被唯一的一个字符对应。在集合论中，这种关系被称为「双射」。

想要解决本题，我们可以利用哈希表记录每一个字符对应的字符串，以及每一个字符串对应的字符。然后我们枚举每一对字符与字符串的配对过程，不断更新哈希表，如果发生了冲突，则说明给定的输入不满足双射关系。

在实际代码中，我们枚举 $\textit{pattern}$ 中的每一个字符，利用双指针来均摊线性地找到该字符在 $\textit{str}$ 中对应的字符串。每次确定一个字符与字符串的组合，我们就检查是否出现冲突，最后我们再检查两字符串是否比较完毕即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool wordPattern(string pattern, string str) {
        unordered_map<string, char> str2ch;
        unordered_map<char, string> ch2str;
        int m = str.length();
        int i = 0;
        for (auto ch : pattern) {
            if (i >= m) {
                return false;
            }
            int j = i;
            while (j < m && str[j] != ' ') j++;
            const string &tmp = str.substr(i, j - i);
            if (str2ch.count(tmp) && str2ch[tmp] != ch) {
                return false;
            }
            if (ch2str.count(ch) && ch2str[ch] != tmp) {
                return false;
            }
            str2ch[tmp] = ch;
            ch2str[ch] = tmp;
            i = j + 1;
        }
        return i >= m;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean wordPattern(String pattern, String str) {
        Map<String, Character> str2ch = new HashMap<String, Character>();
        Map<Character, String> ch2str = new HashMap<Character, String>();
        int m = str.length();
        int i = 0;
        for (int p = 0; p < pattern.length(); ++p) {
            char ch = pattern.charAt(p);
            if (i >= m) {
                return false;
            }
            int j = i;
            while (j < m && str.charAt(j) != ' ') {
                j++;
            }
            String tmp = str.substring(i, j);
            if (str2ch.containsKey(tmp) && str2ch.get(tmp) != ch) {
                return false;
            }
            if (ch2str.containsKey(ch) && !tmp.equals(ch2str.get(ch))) {
                return false;
            }
            str2ch.put(tmp, ch);
            ch2str.put(ch, tmp);
            i = j + 1;
        }
        return i >= m;
    }
}
```

```Golang [sol1-Golang]
func wordPattern(pattern string, s string) bool {
    word2ch := map[string]byte{}
    ch2word := map[byte]string{}
    words := strings.Split(s, " ")
    if len(pattern) != len(words) {
        return false
    }
    for i, word := range words {
        ch := pattern[i]
        if word2ch[word] > 0 && word2ch[word] != ch || ch2word[ch] != "" && ch2word[ch] != word {
            return false
        }
        word2ch[word] = ch
        ch2word[ch] = word
    }
    return true
}
```

```JavaScript [sol1-JavaScript]
var wordPattern = function(pattern, s) {
    const word2ch = new Map();
    const ch2word = new Map();
    const words = s.split(' ');
    if (pattern.length !== words.length) {
        return false;
    }
    for (const [i, word] of words.entries()) {
        const ch = pattern[i];
        if (word2ch.has(word) && word2ch.get(word) != ch || ch2word.has(ch) && ch2word.get(ch) !== word) {
            return false;
        }
        word2ch.set(word, ch);
        ch2word.set(ch, word);
    }
    return true;
};
```

```Python [sol1-Python3]
class Solution:
    def wordPattern(self, pattern: str, s: str) -> bool:
        word2ch = dict()
        ch2word = dict()
        words = s.split()
        if len(pattern) != len(words):
            return False
        
        for ch, word in zip(pattern, words):
            if (word in word2ch and word2ch[word] != ch) or (ch in ch2word and ch2word[ch] != word):
                return False
            word2ch[word] = ch
            ch2word[ch] = word
    
        return True
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 为 $\textit{pattern}$ 的长度，$m$ 为 $\textit{str}$ 的长度。插入和查询哈希表的均摊时间复杂度均为 $O(n + m)$。每一个字符至多只被遍历一次。

- 空间复杂度：$O(n + m)$，其中 $n$ 为 $\textit{pattern}$ 的长度，$m$ 为 $\textit{str}$ 的长度。最坏情况下，我们需要存储 $\textit{pattern}$ 中的每一个字符和 $\textit{str}$ 中的每一个字符串。
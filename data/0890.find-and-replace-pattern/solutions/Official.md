## [890.查找和替换模式 中文官方题解](https://leetcode.cn/problems/find-and-replace-pattern/solutions/100000/cha-zhao-he-ti-huan-mo-shi-by-leetcode-s-fyyg)

#### 方法一：构造双射

我们可以逐个判断 $\textit{words}$ 中的每个单词 $\textit{word}$ 是否与 $\textit{pattern}$ 匹配。

根据题意，我们需要构造从字母到字母的双射，即 $\textit{word}$ 的每个字母需要映射到 $\textit{pattern}$ 的对应字母，并且 $\textit{pattern}$ 的每个字母也需要映射到 $\textit{word}$ 的对应字母。

我们可以编写一个函数 $\text{match}(\textit{word},\textit{pattern})$，仅当 $\textit{word}$ 中相同字母映射到 $\textit{pattern}$ 中的相同字母时返回 $\texttt{true}$。我们可以在遍历这两个字符串的同时，用一个哈希表记录 $\textit{word}$ 的每个字母 $x$ 需要映射到 $\textit{pattern}$ 的哪个字母上，如果 $x$ 已有映射，则需要检查对应字母是否相同。

如果 $\text{match}(\textit{word},\textit{pattern})$ 和 $\text{match}(\textit{pattern},\textit{word})$ 均为 $\texttt{true}$，则表示 $\textit{word}$ 与 $\textit{pattern}$ 匹配。

```Python [sol1-Python3]
class Solution:
    def findAndReplacePattern(self, words: List[str], pattern: str) -> List[str]:
        def match(word: str, pattern: str) -> bool:
            mp = {}
            for x, y in zip(word, pattern):
                if x not in mp:
                    mp[x] = y
                elif mp[x] != y:  # word 中的同一字母必须映射到 pattern 中的同一字母上
                    return False
            return True
        return [word for word in words if match(word, pattern) and match(pattern, word)]
```

```C++ [sol1-C++]
class Solution {
    bool match(string &word, string &pattern) {
        unordered_map<char, char> mp;
        for (int i = 0; i < word.length(); ++i) {
            char x = word[i], y = pattern[i];
            if (!mp.count(x)) {
                mp[x] = y;
            } else if (mp[x] != y) { // word 中的同一字母必须映射到 pattern 中的同一字母上
                return false;
            }
        }
        return true;
    }

public:
    vector<string> findAndReplacePattern(vector<string> &words, string &pattern) {
        vector<string> ans;
        for (auto &word: words) {
            if (match(word, pattern) && match(pattern, word)) {
                ans.emplace_back(word);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<String> findAndReplacePattern(String[] words, String pattern) {
        List<String> ans = new ArrayList<String>();
        for (String word : words) {
            if (match(word, pattern) && match(pattern, word)) {
                ans.add(word);
            }
        }
        return ans;
    }

    public boolean match(String word, String pattern) {
        Map<Character, Character> map = new HashMap<Character, Character>();
        for (int i = 0; i < word.length(); ++i) {
            char x = word.charAt(i), y = pattern.charAt(i);
            if (!map.containsKey(x)) {
                map.put(x, y);
            } else if (map.get(x) != y) { // word 中的同一字母必须映射到 pattern 中的同一字母上
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<string> FindAndReplacePattern(string[] words, string pattern) {
        IList<string> ans = new List<string>();
        foreach (string word in words) {
            if (Match(word, pattern) && Match(pattern, word)) {
                ans.Add(word);
            }
        }
        return ans;
    }

    public bool Match(String word, String pattern) {
        Dictionary<char, char> dic = new Dictionary<char, char>();
        for (int i = 0; i < word.Length; ++i) {
            char x = word[i], y = pattern[i];
            if (!dic.ContainsKey(x)) {
                dic.Add(x, y);
            } else if (dic[x] != y) { // word 中的同一字母必须映射到 pattern 中的同一字母上
                return false;
            }
        }
        return true;
    }
}
```

```go [sol1-Golang]
func match(word, pattern string) bool {
    mp := map[rune]byte{}
    for i, x := range word {
        y := pattern[i]
        if mp[x] == 0 {
            mp[x] = y
        } else if mp[x] != y { // word 中的同一字母必须映射到 pattern 中的同一字母上
            return false
        }
    }
    return true
}

func findAndReplacePattern(words []string, pattern string) (ans []string) {
    for _, word := range words {
        if match(word, pattern) && match(pattern, word) {
            ans = append(ans, word)
        }
    }
    return
}
```

```C [sol1-C]
bool match(const char* word, const char* pattern) {
    char mp[256];
    memset(mp, 0, sizeof(mp));
    int len = strlen(word);
    for (int i = 0; i < len; ++i) {
        char x = word[i], y = pattern[i];
        if (!mp[x]) {
            mp[x] = y;
        } else if (mp[x] != y) { // word 中的同一字母必须映射到 pattern 中的同一字母上
            return false;
        }
    }
    return true;
}

char ** findAndReplacePattern(char ** words, int wordsSize, char * pattern, int* returnSize){
    char **ans = (char **)malloc(sizeof(char *) * wordsSize);
    int pos = 0;
    for (int i = 0; i < wordsSize; i++) {
        if (match(words[i], pattern) && match(pattern, words[i])) {
            ans[pos++] = words[i];
        }
    }
    *returnSize = pos;
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var findAndReplacePattern = function(words, pattern) {
    const ans = [];
    for (const word of words) {
        if (match(word, pattern) && match(pattern, word)) {
            ans.push(word);
        }
    }
    return ans;
};

const match = (word, pattern) => {
    const map = new Map();
    for (let i = 0; i < word.length; ++i) {
        const x = word[i], y = pattern[i];
        if (!map.has(x)) {
            map.set(x, y);
        } else if (map.get(x) !== y) { // word 中的同一字母必须映射到 pattern 中的同一字母上
            return false;
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(nm)$，其中 $n$ 是数组 $\textit{words}$ 的长度，$m$ 是 $\textit{pattern}$ 的长度。对于每个 $\textit{word}$ 需要 $O(m)$ 的时间检查其是否与 $\textit{pattern}$ 匹配。

- 空间复杂度：$O(m)$。哈希表需要 $O(m)$ 的空间。
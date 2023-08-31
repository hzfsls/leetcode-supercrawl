## [500.键盘行 中文官方题解](https://leetcode.cn/problems/keyboard-row/solutions/100000/jian-pan-xing-by-leetcode-solution-bj5e)
#### 方法一：遍历

我们为每一个英文字母标记其对应键盘上的行号，然后检测字符串中所有字符对应的行号是否相同。

- 我们可以预处理计算出每个字符对应的行号。

- 遍历字符串时，统一将大写字母转化为小写字母方便计算。

```C++ [sol1-C++]
class Solution {
public:
    vector<string> findWords(vector<string>& words) {
        vector<string> ans;
        string rowIdx = "12210111011122000010020202";
        for (auto & word : words) {
            bool isValid = true;
            char idx = rowIdx[tolower(word[0]) - 'a'];
            for (int i = 1; i < word.size(); ++i) {
                if(rowIdx[tolower(word[i]) - 'a'] != idx) {
                    isValid = false;
                    break;
                }
            }
            if (isValid) {
                ans.emplace_back(word);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {    
    public String[] findWords(String[] words) {
        List<String> list = new ArrayList<String>();
        String rowIdx = "12210111011122000010020202";
        for (String word : words) {
            boolean isValid = true;
            char idx = rowIdx.charAt(Character.toLowerCase(word.charAt(0)) - 'a');
            for (int i = 1; i < word.length(); ++i) {
                if (rowIdx.charAt(Character.toLowerCase(word.charAt(i)) - 'a') != idx) {
                    isValid = false;
                    break;
                }
            }
            if (isValid) {
                list.add(word);
            }
        }
        String[] ans = new String[list.size()];
        for (int i = 0; i < list.size(); ++i) {
            ans[i] = list.get(i);
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string[] FindWords(string[] words) {
        IList<string> list = new List<string>();
        string rowIdx = "12210111011122000010020202";
        foreach (string word in words) {
            bool isValid = true;
            char idx = rowIdx[char.ToLower(word[0]) - 'a'];
            for (int i = 1; i < word.Length; ++i) {
                if (rowIdx[char.ToLower(word[i]) - 'a'] != idx) {
                    isValid = false;
                    break;
                }
            }
            if (isValid) {
                list.Add(word);
            }
        }

        string[] ans = new string[list.Count];
        for (int i = 0; i < list.Count; ++i) {
            ans[i] = list[i];
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def findWords(self, words: List[str]) -> List[str]:
        ans = []
        rowIdx = "12210111011122000010020202"
        for word in words:
            idx = rowIdx[ord(word[0].lower()) - ord('a')]
            if all(rowIdx[ord(ch.lower()) - ord('a')] == idx for ch in word):
                ans.append(word)
        return ans
```

```JavaScript [sol1-JavaScript]
var findWords = function(words) {
    const list = [];
    const rowIdx = "12210111011122000010020202";
    for (const word of words) {
        let isValid = true;
        const idx = rowIdx[word[0].toLowerCase().charCodeAt() - 'a'.charCodeAt()];
        for (let i = 1; i < word.length; ++i) {
            if (rowIdx[word[i].toLowerCase().charCodeAt() - 'a'.charCodeAt()] !== idx) {
                isValid = false;
                break;
            }
        }
        if (isValid) {
            list.push(word);
        }
    }
    return list;
};
```

```TypeScript [sol1-TypeScript]
function findWords(words: string[]): string[] {
    const list: string[] = [];
    const rowIdx: string = "12210111011122000010020202";
    for (const word of words) {
        let isValid: boolean = true;
        const idx: string = rowIdx[word[0].toLowerCase().charCodeAt(0) - 'a'.charCodeAt(0)];
        for (let i = 1; i < word.length; ++i) {
            if (rowIdx[word[i].toLowerCase().charCodeAt(0) - 'a'.charCodeAt(0)] !== idx) {
                isValid = false;
                break;
            }
        }
        if (isValid) {
            list.push(word);
        }
    }
    return list;
};
```

```go [sol1-Golang]
func findWords(words []string) (ans []string) {
    const rowIdx = "12210111011122000010020202"
next:
    for _, word := range words {
        idx := rowIdx[unicode.ToLower(rune(word[0]))-'a']
        for _, ch := range word[1:] {
            if rowIdx[unicode.ToLower(ch)-'a'] != idx {
                continue next
            }
        }
        ans = append(ans, word)
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(L)$，其中 $L$ 表示 $\textit{words}$ 中所有字符串的长度之和。

- 空间复杂度：$O(C)$，其中 $C$ 表示英文字母的个数，在本题中英文字母的个数为 $26$。注意返回值不计入空间复杂度。
## [1592.重新排列单词间的空格 中文官方题解](https://leetcode.cn/problems/rearrange-spaces-between-words/solutions/100000/zhong-xin-pai-lie-dan-ci-jian-de-kong-ge-5kln)
#### 方法一：模拟

**思路与算法**

题目给定字符串 $\textit{text}$，首先我们按照空格分割，得到单词集合，并统计空格数。

1. 如果单词数为 $1$，则将全部的空格拼接到这个单词后面即可。
2. 否则先计算出单词间的间隔，并按照单词及间隔来进行拼接，若拼接后仍有多余的空格，则将剩下的空格拼接在末尾即可。

**代码**

```Python [sol1-Python3]
class Solution:
    def reorderSpaces(self, text: str) -> str:
        words = text.split()
        space = text.count(' ')
        if len(words) == 1:
            return words[0] + ' ' * space
        per_space, rest_space = divmod(space, len(words) - 1)
        return (' ' * per_space).join(words) + ' ' * rest_space
```

```Java [sol1-Java]
class Solution {
    public String reorderSpaces(String text) {
        int length = text.length();
        String[] words = text.trim().split("\\s+");
        int cntSpace = length;
        for (String word : words) {
            cntSpace -= word.length();
        }
        StringBuilder sb = new StringBuilder();
        if (words.length == 1) {
            sb.append(words[0]);
            for (int i = 0; i < cntSpace; i++) {
                sb.append(' ');
            }
            return sb.toString();
        }
        int perSpace = cntSpace / (words.length - 1);
        int restSpace = cntSpace % (words.length - 1);
        for (int i = 0; i < words.length; i++) {
            if (i > 0) {
                for (int j = 0; j < perSpace; j++) {
                    sb.append(' ');
                }
            }
            sb.append(words[i]);
        }
        for (int i = 0; i < restSpace; i++) {
            sb.append(' ');
        }
        return sb.toString();
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ReorderSpaces(string text) {
        int length = text.Length;
        string[] words = text.Trim().Split(" ");
        int cntSpace = length;
        int wordCount = 0;
        foreach (string word in words) {
            if (word.Length > 0) {
                cntSpace -= word.Length;
                wordCount++;
            }
        }
        StringBuilder sb = new StringBuilder();
        if (words.Length == 1) {
            sb.Append(words[0]);
            for (int i = 0; i < cntSpace; i++) {
                sb.Append(' ');
            }
            return sb.ToString();
        }
        int perSpace = cntSpace / (wordCount - 1);
        int restSpace = cntSpace % (wordCount - 1);
        for (int i = 0; i < words.Length; i++) {
            if (words[i].Length == 0) {
                continue;
            }
            if (sb.Length > 0) {
                for (int j = 0; j < perSpace; j++) {
                    sb.Append(' ');
                }
            }
            sb.Append(words[i]);
        }
        for (int i = 0; i < restSpace; i++) {
            sb.Append(' ');
        }
        return sb.ToString();
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<string_view> split(const string_view &str, char trim) {
        int n = str.size();
        vector<string_view> res;
        int pos = 0;
        while (pos < n) {
            while(pos < n && str[pos] == trim) {
                pos++;
            }
            if (pos < n) {
                int curr = pos;
                while(pos < n && str[pos] != trim) {
                    pos++;
                }
                res.emplace_back(str.substr(curr, pos - curr));
            }
        }
        return res;
    }

    string reorderSpaces(string text) {
        int length = text.size();
        vector<string_view> words = split(text, ' ');
        int cntSpace = length;
        int wordCount = 0;
        for (auto &word : words) {
            if (word.size() > 0) {
                cntSpace -= word.size();
                wordCount++;
            }
        }

        string ans;
        if (words.size() == 1) {
            ans.append(words[0]);
            for (int i = 0; i < cntSpace; i++) {
                ans.push_back(' ');
            }
            return ans;
        }
        int perSpace = cntSpace / (wordCount - 1);
        int restSpace = cntSpace % (wordCount - 1);
        for (int i = 0; i < words.size(); i++) {
            if (words[i].size() == 0) {
                continue;
            }
            if (ans.size() > 0) {
                for (int j = 0; j < perSpace; j++) {
                    ans.push_back(' ');
                }
            }
            ans.append(words[i]);
        }
        for (int i = 0; i < restSpace; i++) {
            ans.push_back(' ');
        }
        return ans;
    }
};
```

```C [sol1-C]
char** split(const char *str, char trim, int *returnSize) {
    int n = strlen(str);
    char **words = (char **)malloc(sizeof(char *) * n);
    int wordsSize = 0, pos = 0;
    while (pos < n) {
        while(pos < n && str[pos] == trim) {
            pos++;
        }
        if (pos < n) {
            int curr = pos;
            while(pos < n && str[pos] != trim) {
                pos++;
            }
            words[wordsSize] = (char *)malloc(sizeof(char) * (pos - curr + 1));
            strncpy(words[wordsSize], str + curr, pos - curr);
            words[wordsSize++][pos - curr] = '\0';
        }
    }
    *returnSize = wordsSize;
    return words;
}


char * reorderSpaces(char * text){
    int length = strlen(text);
    int wordsSize = 0;
    char **words = split(text, ' ', &wordsSize);
    int cntSpace = length;
    int wordCount = 0;
    for (int i = 0; i < wordsSize; i++) {
        int len = strlen(words[i]);
        if (len > 0) {
            cntSpace -= len;
            wordCount++;
        }
    }

    char *ans = (char *)malloc(sizeof(char) * (length + 1));
    int pos = 0;
    if (wordsSize == 1) {
        pos += sprintf(ans + pos, "%s", words[0]);
        for (int i = 0; i < cntSpace; i++) {
            ans[pos++] = ' ';
        }
        ans[pos] = '\0';
        free(words[0]);
        free(words);
        return ans;
    }
    int perSpace = cntSpace / (wordCount - 1);
    int restSpace = cntSpace % (wordCount - 1);
    for (int i = 0; i < wordsSize; i++) {
        if (strlen(words[i]) == 0) {
            continue;
        }
        if (pos > 0) {
            for (int j = 0; j < perSpace; j++) {
                ans[pos++] = ' ';
            }
        }
        pos += sprintf(ans + pos, "%s", words[i]);
    }
    for (int i = 0; i < restSpace; i++) {
        ans[pos++] = ' ';
    }
    ans[pos] = '\0';
    for (int i = 0; i < wordsSize; i++) {
        free(words[i]);
    }
    free(words);
    return ans;  
}
```

```JavaScript [sol1-JavaScript]
var reorderSpaces = function(text) {
    const length = text.length;
    const words = [];
    text.split(' ').forEach(e => {
        if (e.length > 0) {
            words.push(e);
        }
    });
    let cntSpace = length;
    for (const word of words) {
        if (word.length) {
            cntSpace -= word.length;
        }
    }
    let sb = '';
    if (words.length === 1) {
        sb += words[0];
        for (let i = 0; i < cntSpace; i++) {
            sb += ' ';
        }
        return sb;
    }
    const perSpace = Math.floor(cntSpace / (words.length - 1));
    const restSpace = cntSpace % (words.length - 1);
    for (let i = 0; i < words.length; i++) {
        if (i > 0) {
            for (let j = 0; j < perSpace; j++) {
                sb += ' ';
            }
        }
        sb += words[i];
    }
    for (let i = 0; i < restSpace; i++) {
        sb += ' ';
    }
    return sb;
};
```

```go [sol1-Golang]
func reorderSpaces(s string) (ans string) {
    words := strings.Fields(s)
    space := strings.Count(s, " ")
    lw := len(words) - 1
    if lw == 0 {
        return words[0] + strings.Repeat(" ", space)
    }
    return strings.Join(words, strings.Repeat(" ", space/lw)) + strings.Repeat(" ", space%lw)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $\textit{text}$ 的长度。
- 空间复杂度：$O(n)$，其中 $n$ 为字符串 $\textit{text}$ 的长度，主要为返回的字符串空间开销。
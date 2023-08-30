#### 方法一：双指针

使用 $\textit{start}$ 记录单词的起始，$\textit{end}$ 记录单词结尾的下一个位置。我们遍历字符串 $\textit{sentence}$ 并不断地分割单词，对于区间 $[\textit{start}, \textit{end})$ 对应的单词，判断它是否存在某一前缀等于 $\textit{searchWord}$，如果存在直接返回该单词对应的下标 $\textit{index}$；如果遍历完所有单词都不符合条件，返回 $-1$。

```Python [sol1-Python3]
class Solution:
    def isPrefixOfWord(self, sentence: str, searchWord: str) -> int:
        i, index, n = 0, 1, len(sentence)
        while i < n:
            start = i
            while i < n and sentence[i] != ' ':
                i += 1
            end = i
            if sentence[start:end].startswith(searchWord):
                return index
            index += 1
            i += 1
        return -1
```

```C++ [sol1-C++]
class Solution {
public:
    bool isPrefix(const string &sentence, int start, int end, const string &searchWord) {
        for (int i = 0; i < searchWord.size(); i++) {
            if (start + i >= end || sentence[start + i] != searchWord[i]) {
                return false;
            }
        }
        return true;
    }

    int isPrefixOfWord(string sentence, string searchWord) {
        int n = sentence.size(), index = 1, start = 0, end = 0;
        while (start < n) {
            while (end < n && sentence[end] != ' ') {
                end++;
            }
            if (isPrefix(sentence, start, end, searchWord)) {
                return index;
            }

            index++;
            end++;
            start = end;
        }
        return -1;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int isPrefixOfWord(String sentence, String searchWord) {
        int n = sentence.length(), index = 1, start = 0, end = 0;
        while (start < n) {
            while (end < n && sentence.charAt(end) != ' ') {
                end++;
            }
            if (isPrefix(sentence, start, end, searchWord)) {
                return index;
            }

            index++;
            end++;
            start = end;
        }
        return -1;
    }

    public boolean isPrefix(String sentence, int start, int end, String searchWord) {
        for (int i = 0; i < searchWord.length(); i++) {
            if (start + i >= end || sentence.charAt(start + i) != searchWord.charAt(i)) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int IsPrefixOfWord(string sentence, string searchWord) {
        int n = sentence.Length, index = 1, start = 0, end = 0;
        while (start < n) {
            while (end < n && sentence[end] != ' ') {
                end++;
            }
            if (IsPrefix(sentence, start, end, searchWord)) {
                return index;
            }

            index++;
            end++;
            start = end;
        }
        return -1;
    }

    public bool IsPrefix(string sentence, int start, int end, string searchWord) {
        for (int i = 0; i < searchWord.Length; i++) {
            if (start + i >= end || sentence[start + i] != searchWord[i]) {
                return false;
            }
        }
        return true;
    }
}
```

```C [sol1-C]
bool isPrefix(const char* sentence, int start, int end, const char* searchWord) {
    int len = strlen(searchWord);
    for (int i = 0; i < len; i++) {
        if (start + i >= end || sentence[start + i] != searchWord[i]) {
            return false;
        }
    }
    return true;
}

int isPrefixOfWord(char * sentence, char * searchWord){
    int n = strlen(sentence), index = 1, start = 0, end = 0;
    while (start < n) {
        while (end < n && sentence[end] != ' ') {
            end++;
        }
        if (isPrefix(sentence, start, end, searchWord)) {
            return index;
        }
        index++;
        end++;
        start = end;
    }
    return -1;
}
```

```JavaScript [sol1-JavaScript]
var isPrefixOfWord = function(sentence, searchWord) {
    let n = sentence.length, index = 1, start = 0, end = 0;
    while (start < n) {
        while (end < n && sentence[end] !== ' ') {
            end++;
        }
        if (isPrefix(sentence, start, end, searchWord)) {
            return index;
        }

        index++;
        end++;
        start = end;
    }
    return -1;
}

const isPrefix = (sentence, start, end, searchWord) => {
    for (let i = 0; i < searchWord.length; i++) {
        if (start + i >= end || sentence[start + i] !== searchWord[i]) {
            return false;
        }
    }
    return true;
};
```

```go [sol1-Golang]
func isPrefixOfWord(sentence, searchWord string) int {
    for i, index, n := 0, 1, len(sentence); i < n; i++ {
        start := i
        for i < n && sentence[i] != ' ' {
            i++
        }
        end := i
        if strings.HasPrefix(sentence[start:end], searchWord) {
            return index
        }
        index++
    }
    return -1
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是 $\textit{sentence}$ 的长度。遍历字符串 $\textit{sentence}$ 需要 $O(n)$，前缀判断函数 $\text{isPrefix}$ 的总时间复杂度为 $O(n)$。

+ 空间复杂度：$O(1)$，只需要额外的常数级别的空间。
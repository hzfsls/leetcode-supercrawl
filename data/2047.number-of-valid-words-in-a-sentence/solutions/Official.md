#### 方法一：遍历

**思路与算法**

首先将句子按空格分隔成单词，然后判断单词是否有效。由题意知，单词不有效的条件为以下其中之一：

* 单词中包含数字；

* 单词中包含两个以上连字符；

* 连字符在单词头部或者单词末尾；

* 连字符的左/右边字符不是小写字母；

* 单词中的标点符号不在单词的末尾。

记录有效的单词的个数，即为答案。

**代码**

```Python [sol1-Python3]
class Solution:
    def countValidWords(self, sentence: str) -> int:
        def valid(s: str) -> bool:
            hasHyphens = False
            for i, ch in enumerate(s):
                if ch.isdigit() or ch in "!.," and i < len(s) - 1:
                    return False
                if ch == '-':
                    if hasHyphens or i == 0 or i == len(s) - 1 or not s[i - 1].islower() or not s[i + 1].islower():
                        return False
                    hasHyphens = True
            return True

        return sum(valid(s) for s in sentence.split())
```

```C++ [sol1-C++]
class Solution {
public:
    int countValidWords(string sentence) {
        int n = sentence.length();
        int l = 0, r = 0;
        int ret = 0;
        string_view slice(sentence);
        while (true) {
            while (l < n && sentence[l] == ' ') {
                l++;
            }
            if (l >= n) {
                break;
            }
            r = l + 1;
            while (r < n && sentence[r] != ' ') {
                r++;
            }
            if (isValid(slice.substr(l, r - l))) { // 判断根据空格分解出来的 token 是否有效
                ret++;
            }
            l = r + 1;
        }
        return ret;
    }

    bool isValid(const string_view &word) {
        int n = word.length();
        bool has_hyphens = false;
        for (int i = 0; i < n; i++) {
            if (word[i] >= '0' && word[i] <= '9') {
                return false;
            } else if (word[i] == '-') {
                if (has_hyphens == true || i == 0 || i == n - 1 || !islower(word[i - 1]) || !islower(word[i + 1])) {
                    return false;
                }
                has_hyphens = true;
            } else if (word[i] == '!' || word[i] == '.' || word[i] == ',') {
                if (i != n - 1) {
                    return false;
                }
            }
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countValidWords(String sentence) {
        int n = sentence.length();
        int l = 0, r = 0;
        int ret = 0;
        while (true) {
            while (l < n && sentence.charAt(l) == ' ') {
                l++;
            }
            if (l >= n) {
                break;
            }
            r = l + 1;
            while (r < n && sentence.charAt(r) != ' ') {
                r++;
            }
            if (isValid(sentence.substring(l, r))) { // 判断根据空格分解出来的 token 是否有效
                ret++;
            }
            l = r + 1;
        }
        return ret;
    }

    public boolean isValid(String word) {
        int n = word.length();
        boolean hasHyphens = false;
        for (int i = 0; i < n; i++) {
            if (Character.isDigit(word.charAt(i))) {
                return false;
            } else if (word.charAt(i) == '-') {
                if (hasHyphens == true || i == 0 || i == n - 1 || !Character.isLetter(word.charAt(i - 1)) || !Character.isLetter(word.charAt(i + 1))) {
                    return false;
                }
                hasHyphens = true;
            } else if (word.charAt(i) == '!' || word.charAt(i) == '.' || word.charAt(i) == ',') {
                if (i != n - 1) {
                    return false;
                }
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountValidWords(string sentence) {
        int n = sentence.Length;
        int l = 0, r = 0;
        int ret = 0;
        while (true) {
            while (l < n && sentence[l] == ' ') {
                l++;
            }
            if (l >= n) {
                break;
            }
            r = l + 1;
            while (r < n && sentence[r] != ' ') {
                r++;
            }
            if (isValid(sentence.Substring(l, r - l))) { // 判断根据空格分解出来的 token 是否有效
                ret++;
            }
            l = r + 1;
        }
        return ret;
    }

    public bool isValid(string word) {
        int n = word.Length;
        bool hasHyphens = false;
        for (int i = 0; i < n; i++) {
            if (char.IsDigit(word[i])) {
                return false;
            } else if (word[i] == '-') {
                if (hasHyphens == true || i == 0 || i == n - 1 || !char.IsLetter(word[i - 1]) || !char.IsLetter(word[i + 1])) {
                    return false;
                }
                hasHyphens = true;
            } else if (word[i] == '!' || word[i] == '.' || word[i] == ',') {
                if (i != n - 1) {
                    return false;
                }
            }
        }
        return true;
    }
}
```

```C [sol1-C]
bool isValid(char *word, int n) {
    int has_hyphens = 0;
    for (int i = 0; i < n; i++) {
        if (word[i] >= '0' && word[i] <= '9') {
            return false;
        } else if (word[i] == '-') {
            if (has_hyphens == 1 || i == 0 || i == n - 1 || !islower(word[i - 1]) || !islower(word[i + 1])) {
                return false;
            }
            has_hyphens = 1;
        } else if (word[i] == '!' || word[i] == '.' || word[i] == ',') {
            if (i != n - 1) {
                return false;
            }
        }
    }
    return true;
}

int countValidWords(char * sentence){
    int n = strlen(sentence);
    int l = 0, r = 0;
    int ret = 0;
    while (true) {
        while (l < n && sentence[l] == ' ') {
            l++;
        }
        if (l >= n) {
            break;
        }
        r = l + 1;
        while (r < n && sentence[r] != ' ') {
            r++;
        }
        if (isValid(sentence + l, r - l)) { // 判断根据空格分解出来的 token 是否有效
            ret++;
        }
        l = r + 1;
    }
    return ret;
}
```

```go [sol1-Golang]
func valid(s string) bool {
    hasHyphens := false
    for i, ch := range s {
        if unicode.IsDigit(ch) || strings.ContainsRune("!.,", ch) && i < len(s)-1 {
            return false
        }
        if ch == '-' {
            if hasHyphens || i == 0 || i == len(s)-1 || !unicode.IsLower(rune(s[i-1])) || !unicode.IsLower(rune(s[i+1])) {
                return false
            }
            hasHyphens = true
        }
    }
    return true
}

func countValidWords(sentence string) (ans int) {
    for _, s := range strings.Fields(sentence) { // 按照空格分割
        if valid(s) {
            ans++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var countValidWords = function(sentence) {
    const n = sentence.length;
    let l = 0, r = 0;
    let ret = 0;
    while (true) {
        while (l < n && sentence[l] === ' ') {
            l++;
        }
        if (l >= n) {
            break;
        }
        r = l + 1;
        while (r < n && sentence[r] != ' ') {
            r++;
        }
        if (isValid(sentence.slice(l, r))) { // 判断根据空格分解出来的 token 是否有效
            ret++;
        }
        l = r + 1;
    }
    return ret;
};

const isValid = (word) => {
    const n = word.length;
    let hasHyphens = false;
    for (let i = 0; i < n; i++) {
        if (word[i] >= '0' && word[i] <= '9') {
            return false;
        } else if (word[i] === '-') {
            if (hasHyphens === true || i === 0 || i === n - 1 || !isLetter(word[i - 1]) || !isLetter(word[i + 1])) {
                return false;
            }
            hasHyphens = true;
        } else if (word[i] === '!' || word[i] === '.' || word[i] === ',') {
            if (i !== n - 1) {
                return false;
            }
        }
    }
    return true;
}

const isLetter = (ch) => {
    if (ch >= 'a' && ch <= 'z' || ch >= 'A' && ch <= 'Z') {
        return true;
    }
    return false;
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是句子的长度。切分整个句子，并处理单词需要 $O(n)$。

+ 空间复杂度：$O(1)$。只需要常数空间保存变量。
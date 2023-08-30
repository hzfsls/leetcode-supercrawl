#### 方法一：根据题目要求实现

**思路和算法**

根据题目要求，若单词的大写用法正确，则需要满足：

- 若第 $1$ 个字母为大写，则其他字母必须均为大写或均为小写，即其他字母必须与第 $2$ 个字母的大小写相同；

- 若第 $1$ 个字母为小写，则其他字母必须均为小写。

根据以上规则，可以整理得到以下更简单的判断规则：

- 无论第 $1$ 个字母是否大写，其他字母必须与第 $2$ 个字母的大小写相同；

- 若第 $1$ 个字母为小写，则需额外判断第 $2$ 个字母是否为小写。

**代码**

```Python [sol1-Python3]
class Solution:
    def detectCapitalUse(self, word: str) -> bool:
        # 若第 1 个字母为小写，则需额外判断第 2 个字母是否为小写
        if len(word) >= 2 and word[0].islower() and word[1].isupper():
            return False
        
        # 无论第 1 个字母是否大写，其他字母必须与第 2 个字母的大小写相同
        return all(word[i].islower() == word[1].islower() for i in range(2, len(word)))
```

```Java [sol1-Java]
class Solution {
    public boolean detectCapitalUse(String word) {
        // 若第 1 个字母为小写，则需额外判断第 2 个字母是否为小写
        if (word.length() >= 2 && Character.isLowerCase(word.charAt(0)) && Character.isUpperCase(word.charAt(1))) {
            return false;
        }
        
        // 无论第 1 个字母是否大写，其他字母必须与第 2 个字母的大小写相同
        for (int i = 2; i < word.length(); ++i) {
            if (Character.isLowerCase(word.charAt(i)) ^ Character.isLowerCase(word.charAt(1))) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool DetectCapitalUse(string word) {
        // 若第 1 个字母为小写，则需额外判断第 2 个字母是否为小写
        if (word.Length >= 2 && char.IsLower(word[0]) && char.IsUpper(word[1])) {
            return false;
        }
        
        // 无论第 1 个字母是否大写，其他字母必须与第 2 个字母的大小写相同
        for (int i = 2; i < word.Length; ++i) {
            if (char.IsLower(word[i]) ^ char.IsLower(word[1])) {
                return false;
            }
        }
        return true;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool detectCapitalUse(string word) {
        // 若第 1 个字母为小写，则需额外判断第 2 个字母是否为小写
        if (word.size() >= 2 && islower(word[0]) && isupper(word[1])) {
            return false;
        }
        
        // 无论第 1 个字母是否大写，其他字母必须与第 2 个字母的大小写相同
        for (int i = 2; i < word.size(); ++i) {
            if (islower(word[i]) ^ islower(word[1])) {
                return false;
            }
        }
        return true;
    }
};
```

```go [sol1-Golang]
func detectCapitalUse(word string) bool {
    // 若第 1 个字母为小写，则需额外判断第 2 个字母是否为小写
    if len(word) >= 2 && unicode.IsLower(rune(word[0])) && unicode.IsUpper(rune(word[1])) {
        return false
    }

    // 无论第 1 个字母是否大写，其他字母必须与第 2 个字母的大小写相同
    for i := 2; i < len(word); i++ {
        if unicode.IsLower(rune(word[i])) != unicode.IsLower(rune(word[1])) {
            return false
        }
    }
    return true
}
```

```JavaScript [sol1-JavaScript]
var detectCapitalUse = function(word) {
    // 若第 1 个字母为小写，则需额外判断第 2 个字母是否为小写
    if (word.length >= 2 && word[0] === word[0].toLowerCase() && word[1] === word[1].toUpperCase()) {
        return false;
    }
    
    // 无论第 1 个字母是否大写，其他字母必须与第 2 个字母的大小写相同
    for (let i = 2; i < word.length; ++i) {
        if (word[i] === word[i].toLowerCase() ^ word[1] === word[1].toLowerCase()) {
            return false;
        }
    }
    return true;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串的长度。我们需要遍历字符串中的每个字符。

- 空间复杂度：$O(1)$。
## [2490.回环句 中文官方题解](https://leetcode.cn/problems/circular-sentence/solutions/100000/hui-huan-ju-by-leetcode-solution-h853)
#### 方法一：遍历

**思路与算法**

题目保证单词仅有单个空格隔开，并且没有前导或者尾随空格，因此满足以下两个条件的字符串一定是回环句：

1. $\textit{sentence}[0] = \textit{sentence}[n - 1]$，其中 $n$ 为 $\textit{sentence}$ 的长度。
2. 若 $\textit{sentence}[i]$ 是空格，则 $\textit{sentence}[i - 1] = \textit{sentence}[i + 1]$ 一定成立。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool isCircularSentence(string sentence) {
        if (sentence.back() != sentence.front()) {
            return false;
        }
        for (int i = 0; i < sentence.size(); i++) {
            if (sentence[i] == ' ' && sentence[i + 1] != sentence[i - 1]) {
                return false;
            } 
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean isCircularSentence(String sentence) {
        if (sentence.charAt(sentence.length() - 1) != sentence.charAt(0)) {
            return false;
        }
        for (int i = 0; i < sentence.length(); i++) {
            if (sentence.charAt(i) == ' ' && sentence.charAt(i + 1) != sentence.charAt(i - 1)) {
                return false;
            } 
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsCircularSentence(string sentence) {
        if (sentence[sentence.Length - 1] != sentence[0]) {
            return false;
        }
        for (int i = 0; i < sentence.Length; i++) {
            if (sentence[i] == ' ' && sentence[i + 1] != sentence[i - 1]) {
                return false;
            } 
        }
        return true;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isCircularSentence(self, sentence: str) -> bool:
        n = len(sentence)
        if sentence[n - 1] != sentence[0]:
            return False
        for i in range(n):
            if sentence[i] == ' ' and sentence[i + 1] != sentence[i - 1]:
                return False
        return True
```

```Go [sol1-Go]
func isCircularSentence(sentence string) bool {
    n := len(sentence)
    if sentence[n-1] != sentence[0] {
        return false
    }
    for i := 0; i < n; i++ {
        if sentence[i] == ' ' && sentence[i + 1] != sentence[i - 1] {
            return false
        }
    }
    return true
}
```

```JavaScript [sol1-JavaScript]
var isCircularSentence = function(sentence) {
    const n = sentence.length;
    if (sentence[n - 1] !== sentence[0]) {
        return false;
    }
    for (let i = 0; i < n; i++) {
        if (sentence[i] === ' ' && sentence[i + 1] !== sentence[i - 1]) {
            return false;
        }
    }
    return true;
};
```

```C [sol1-C]
bool isCircularSentence(char * sentence) {
    int n = strlen(sentence);
    if (sentence[n - 1] != sentence[0]) {
        return false;
    }
    for (int i = 0; i < n; i++) {
        if (sentence[i] == ' ' && sentence[i + 1] != sentence[i - 1]) {
            return false;
        } 
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{sentence}$ 的长度。

- 空间复杂度：$O(1)$。
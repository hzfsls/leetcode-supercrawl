## [58.最后一个单词的长度 中文官方题解](https://leetcode.cn/problems/length-of-last-word/solutions/100000/zui-hou-yi-ge-dan-ci-de-chang-du-by-leet-51ih)
#### 方法一：反向遍历

题目要求得到字符串中最后一个单词的长度，可以反向遍历字符串，寻找最后一个单词并计算其长度。

由于字符串中至少存在一个单词，因此字符串中一定有字母。首先找到字符串中的最后一个字母，该字母即为最后一个单词的最后一个字母。

从最后一个字母开始继续反向遍历字符串，直到遇到空格或者到达字符串的起始位置。遍历到的每个字母都是最后一个单词中的字母，因此遍历到的字母数量即为最后一个单词的长度。

```Java [sol1-Java]
class Solution {
    public int lengthOfLastWord(String s) {
        int index = s.length() - 1;
        while (s.charAt(index) == ' ') {
            index--;
        }
        int wordLength = 0;
        while (index >= 0 && s.charAt(index) != ' ') {
            wordLength++;
            index--;
        }
        return wordLength;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int LengthOfLastWord(string s) {
        int index = s.Length - 1;
        while (s[index] == ' ') {
            index--;
        }
        int wordLength = 0;
        while (index >= 0 && s[index] != ' ') {
            wordLength++;
            index--;
        }
        return wordLength;
    }
}
```

```JavaScript [sol1-JavaScript]
var lengthOfLastWord = function(s) {
    let index = s.length - 1;
    while (s[index] === ' ') {
        index--;
    }
    let wordLength = 0;
    while (index >= 0 && s[index] !== ' ') {
        wordLength++;
        index--;
    }
    return wordLength;
};
```

```C++ [sol1-C++]
class Solution {
public:
    int lengthOfLastWord(string s) {
        int index = s.size() - 1;

        while (s[index] == ' ') {
            index--;
        }
        int wordLength = 0;
        while (index >= 0 && s[index] != ' ') {
            wordLength++;
            index--;
        }

        return wordLength;
    }
};
```

```go [sol1-Golang]
func lengthOfLastWord(s string) (ans int) {
    index := len(s) - 1
    for s[index] == ' ' {
        index--
    }
    for index >= 0 && s[index] != ' ' {
        ans++
        index--
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串的长度。最多需要反向遍历字符串一次。

- 空间复杂度：$O(1)$。
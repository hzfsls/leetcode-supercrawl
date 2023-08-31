## [434.字符串中的单词数 中文官方题解](https://leetcode.cn/problems/number-of-segments-in-a-string/solutions/100000/zi-fu-chuan-zhong-de-dan-ci-shu-by-leetc-igfb)
#### 方法一：原地法

**思路与算法**

计算字符串中单词的数量，就等同于计数单词的第一个下标的个数。因此，我们只需要遍历整个字符串，统计每个单词的第一个下标的数目即可。

满足单词的第一个下标有以下两个条件：

+ 该下标对应的字符不为空格；

+ 该下标为初始下标或者该下标的前下标对应的字符为空格；

另一种方法直接使用语言内置的 $\texttt{split}$ 函数可直接分离出字符串中的每个单词，在此我们不再详细展开。

```C++ [sol1-C++]
class Solution {
public:
    int countSegments(string s) {
        int segmentCount = 0;

        for (int i = 0; i < s.size(); i++) {
            if ((i == 0 || s[i - 1] == ' ') && s[i] != ' ') {
                segmentCount++;
            }
        }

        return segmentCount;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countSegments(String s) {
        int segmentCount = 0;

        for (int i = 0; i < s.length(); i++) {
            if ((i == 0 || s.charAt(i - 1) == ' ') && s.charAt(i) != ' ') {
                segmentCount++;
            }
        }

        return segmentCount;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountSegments(string s) {
        int segmentCount = 0;

        for (int i = 0; i < s.Length; i++) {
            if ((i == 0 || s[i - 1] == ' ') && s[i] != ' ') {
                segmentCount++;
            }
        }

        return segmentCount;
    }
}
```

```Python [sol1-Python]
class Solution:
    def countSegments(self, s):
        segment_count = 0

        for i in range(len(s)):
            if (i == 0 or s[i - 1] == ' ') and s[i] != ' ':
                segment_count += 1

        return segment_count
```

```JavaScript [sol1-JavaScript]
var countSegments = function(s) {
    let segmentCount = 0;

    for (let i = 0; i < s.length; i++) {
        if ((i === 0 || s[i - 1] === ' ') && s[i] !== ' ') {
            segmentCount++;
        }
    }

    return segmentCount;
};
```

```go [sol1-Golang]
func countSegments(s string) (ans int) {
    for i, ch := range s {
        if (i == 0 || s[i-1] == ' ') && ch != ' ' {
            ans++
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，只需要遍历一遍字符串检测每个下标即可。

- 空间复杂度：$O(1)$。
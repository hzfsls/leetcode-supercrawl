## [2000.反转单词前缀 中文官方题解](https://leetcode.cn/problems/reverse-prefix-of-word/solutions/100000/fan-zhuan-dan-ci-qian-zhui-by-leetcode-s-ruaj)
#### 方法一：直接反转

**思路与算法**

首先查找 $\textit{ch}$ 在字符串 $\textit{word}$ 的位置，如果找到，则将字符串从下标 $0$ 开始，到查找到的 $\textit{ch}$ 所在位置为止的那段字符串进行反转，否则直接返回原字符串。

**代码**

```Python [sol1-Python3]
class Solution:
    def reversePrefix(self, word: str, ch: str) -> str:
        i = word.find(ch) + 1
        return word[:i][::-1] + word[i:]
```

```C++ [sol1-C++]
class Solution {
public:
    string reversePrefix(string word, char ch) {
        int index = word.find(ch);
        if (index != string::npos) {
            reverse(word.begin(), word.begin() + index + 1);
        }
        return word;
    }
};
```

```Java [sol1-Java]
class Solution {
    public String reversePrefix(String word, char ch) {
        int index = word.indexOf(ch);
        if (index >= 0) {
            char[] arr = word.toCharArray();
            int left = 0, right = index;
            while (left < right) {
                char temp = arr[left];
                arr[left] = arr[right];
                arr[right] = temp;
                left++;
                right--;
            }
            word = new String(arr);
        }
        return word;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public string ReversePrefix(string word, char ch) {
        int index = word.IndexOf(ch);
        if (index >= 0) {
            char[] arr = word.ToCharArray();
            int left = 0, right = index;
            while (left < right) {
                char temp = arr[left];
                arr[left] = arr[right];
                arr[right] = temp;
                left++;
                right--;
            }
            word = new string(arr);
        }
        return word;
    }
}
```

```C [sol1-C]
char * reversePrefix(char * word, char ch){
    char *p2 = strchr(word, ch);
    if (p2 != NULL) {
        char *p1 = word;
        while (p1 < p2) {
            char tmp = *p1;
            *p1 = *p2;
            *p2 = tmp;
            p1++;
            p2--;
        }
    }
    return word;
}
```

```go [sol1-Golang]
func reversePrefix(word string, ch byte) string {
    right := strings.IndexByte(word, ch)
    if right < 0 {
        return word
    }
    s := []byte(word)
    for left := 0; left < right; left++ {
        s[left], s[right] = s[right], s[left]
        right--
    }
    return string(s)
}
```

```JavaScript [sol1-JavaScript]
var reversePrefix = function(word, ch) {
    const index = word.indexOf(ch);
    if (index >= 0) {
        const arr = [...word];
        let left = 0, right = index;
        while (left < right) {
            const temp = arr[left];
            arr[left] = arr[right];
            arr[right] = temp;
            left++;
            right--;
        }
        word = arr.join('');
    }
    return word;
};
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{word}$ 的长度。查找和反转都需要 $O(n)$。

+ 空间复杂度：$O(1)$ 或 $O(n)$。取决于语言实现，对于字符串不可变的语言，空间复杂度为 $O(n)$。
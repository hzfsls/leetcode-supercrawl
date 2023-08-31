## [1684.统计一致字符串的数目 中文官方题解](https://leetcode.cn/problems/count-the-number-of-consistent-strings/solutions/100000/tong-ji-yi-zhi-zi-fu-chuan-de-shu-mu-by-38356)
#### 方法一：遍历

由题意可知，字符串 $\textit{allowed}$ 和字符串数组 $\textit{words}$ 中的所有字符串都只包含小写字母，因此我们可以用一个 $32$ 位整数来表示一个字符串出现的字母集合。如果一个字母出现了，那么将对应整数的位设为 $1$。使用 $\textit{mask}$ 表示字符串 $\textit{allowed}$ 出现的字母集合。依次遍历字符串数组 $\textit{words}$，假设第 $i$ 个字符串 $\textit{words}[i]$ 对应出现的字母集合为 $\textit{mask}_1$，那么 $\textit{words}[i]$ 是一致字符串等价于 $\textit{mask}_1$ 是 $\textit{mask}$ 的子集，即 $\textit{mask}_1 \cup \textit{mask} = \textit{mask}$。统计一致字符串的数目并返回结果。

```Python [sol1-Python3]
class Solution:
    def countConsistentStrings(self, allowed: str, words: List[str]) -> int:
        mask = 0
        for c in allowed:
            mask |= 1 << (ord(c) - ord('a'))
        res = 0
        for word in words:
            mask1 = 0
            for c in word:
                mask1 |= 1 << (ord(c) - ord('a'))
            res += (mask1 | mask) == mask
        return res
```

```C++ [sol1-C++]
class Solution {
public:
    int countConsistentStrings(string allowed, vector<string>& words) {
        int mask = 0;
        for (auto c : allowed) {
            mask |= 1 << (c - 'a');
        }
        int res = 0;
        for (auto &&word : words) {
            int mask1 = 0;
            for (auto c : word) {
                mask1 |= 1 << (c - 'a');
            }
            if ((mask1 | mask) == mask) {
                res++;
            }
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int countConsistentStrings(String allowed, String[] words) {
        int mask = 0;
        for (int i = 0; i < allowed.length(); i++) {
            char c = allowed.charAt(i);
            mask |= 1 << (c - 'a');
        }
        int res = 0;
        for (String word : words) {
            int mask1 = 0;
            for (int i = 0; i < word.length(); i++) {
                char c = word.charAt(i);
                mask1 |= 1 << (c - 'a');
            }
            if ((mask1 | mask) == mask) {
                res++;
            }
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int CountConsistentStrings(string allowed, string[] words) {
        int mask = 0;
        foreach (char c in allowed) {
            mask |= 1 << (c - 'a');
        }
        int res = 0;
        foreach (string word in words) {
            int mask1 = 0;
            foreach (char c in word) {
                mask1 |= 1 << (c - 'a');
            }
            if ((mask1 | mask) == mask) {
                res++;
            }
        }
        return res;
    }
}
```

```C [sol1-C]
int countConsistentStrings(char * allowed, char ** words, int wordsSize){
    int mask = 0;
    for (int i = 0; allowed[i] != '\0'; i++) {
        mask |= 1 << (allowed[i] - 'a');
    }
    int res = 0;
    for (int i = 0; i <wordsSize; i++) {
        int mask1 = 0;
        for (int j = 0; words[i][j] != '\0'; j++) {
            mask1 |= 1 << (words[i][j] - 'a');
        }
        if ((mask1 | mask) == mask) {
            res++;
        }
    }
    return res;
}
```

```go [sol1-Golang]
func countConsistentStrings(allowed string, words []string) (res int) {
    mask := 0
    for _, c := range allowed {
        mask |= 1 << (c - 'a')
    }
    for _, word := range words {
        mask1 := 0
        for _, c := range word {
            mask1 |= 1 << (c - 'a')
        }
        if mask1|mask == mask {
            res++
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var countConsistentStrings = function(allowed, words) {
    let mask = 0;
    for (let i = 0; i < allowed.length; i++) {
        const c = allowed[i];
        mask |= 1 << (c.charCodeAt() - 'a'.charCodeAt());
    }
    let res = 0;
    for (const word of words) {
        let mask1 = 0;
        for (let i = 0; i < word.length; i++) {
            const c = word[i];
            mask1 |= 1 << (c.charCodeAt() - 'a'.charCodeAt());
        }
        if ((mask1 | mask) === mask) {
            res++;
        }
    }
    return res;
};
```

**复杂度分析**

+ 时间复杂度：$O(n + \sum m_i)$，其中 $n$ 是字符串 $\textit{allowed}$ 的长度，$m_i$ 是字符串 $\textit{words}[i]$ 的长度。

+ 空间复杂度：$O(1)$。
## [2062.统计字符串中的元音子字符串 中文官方题解](https://leetcode.cn/problems/count-vowel-substrings-of-a-string/solutions/100000/tong-ji-zi-fu-chuan-zhong-de-yuan-yin-zi-evp9)
#### 方法一：枚举 + 哈希集合

**思路与算法**

为了统计字符串中元音子字符串的数量，我们需要枚举字符串的所有子串，同时判断这些子串是否仅包含且全部包含所有元音。

我们可以先用哈希集合存储所有的元音字符，对于每个子串，我们只要判断它的所有字符组成的哈希集合是否和预处理生成的元音字符集相等即可。

而对于枚举子串，我们可以首先枚举字符串的**左端点**，然后自左端点开始**从左至右**枚举**右端点**，在枚举的同时将新加入的字符加入子串的哈希集合中，并与所有元音对应的哈希集合进行比较。与此同时，我们维护元音子字符串的数量，如果当前子串字符的哈希集合和所有元音的哈希集合相等，则当前子串为元音子串，我们将计数加上 $1$；反之则当前子串不为元音子串，计数不变。最终，我们返回该计数作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countVowelSubstrings(string word) {
        int n = word.size();
        int res = 0;
        unordered_set<char> vowelset = {'a', 'e', 'i', 'o', 'u'};   // 所有元音对应的哈希集合
        for (int i = 0; i < n; ++i){
            // 枚举左端点
            unordered_set<char> charset;   // 子串对应的哈希集合
            for (int j = i; j < n; ++j){
                // 按顺序枚举右端点并更新子串哈希集合及比较
                charset.insert(word[j]);
                if (charset == vowelset){
                    ++res;
                }
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countVowelSubstrings(self, word: str) -> int:
        n = len(word)
        res = 0
        vowelset = set("aeiou")   # 所有元音对应的哈希集合
        for i in range(n):
            # 枚举左端点
            charset = set()   # 子串对应的哈希集合
            for j in range(i, n):
                # 按顺序枚举右端点并更新子串哈希集合及比较
                charset.add(word[j])
                if charset == vowelset:
                    res += 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 为 $\textit{word}$ 的长度。即为枚举子串并判断是否为元音子字符串的时间复杂度。

- 空间复杂度：$O(|\Sigma|)$，其中 $|\Sigma|$ 为字符集的大小。即为哈希集合的空间复杂度。
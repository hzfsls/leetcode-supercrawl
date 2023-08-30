#### 方法一：对偶性质

**思路与算法**

对于给定的字符串 $\textit{word}$，要想求出「所有子串中的元音的总数」，其实就是求出「对于每个出现的元音，包含它的子串个数」的和。

因此，我们遍历 $\textit{word}$ 中的每个字符。对于第 $i$ 个字符，如果它是元音，那么包含它的子串的左端点可以选择 $0, 1, \cdots, i$ 一共 $i+1$ 种，右端点可以选择 $i, i+1, \cdots, n-1$ 一共 $n-i$ 种（其中 $n$ 是字符串 $\textit{word}$ 的长度），因此包含它的子串个数为：

$$
(i+1)(n-i)
$$

我们统计上式的和即可得到答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long countVowels(string word) {
        int n = word.size();
        unordered_set<char> vowels = {'a', 'e', 'i', 'o', 'u'};
        long long ans = 0;
        for (int i = 0; i < n; ++i) {
            if (vowels.count(word[i])) {
                ans += (long long)(i + 1) * (n - i);
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def countVowels(self, word: str) -> int:
        n = len(word)
        vowels = {"a", "e", "i", "o", "u"}
        ans = 0
        for i, ch in enumerate(word):
            if ch in vowels:
                ans += (i + 1) * (n - i)
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $\textit{word}$ 的长度。

- 空间复杂度：$O(1)$。
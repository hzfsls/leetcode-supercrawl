## [2068.检查两个字符串是否几乎相等 中文官方题解](https://leetcode.cn/problems/check-whether-two-strings-are-almost-equivalent/solutions/100000/jian-cha-liang-ge-zi-fu-chuan-shi-fou-ji-59go)

#### 方法一：哈希表

**思路与算法**

我们可以用一个哈希表来维护两个字符串中每个字符的**频数之差**。哈希表中每个字符对应的默认值为 $0$。

首先我们遍历字符串 $\textit{word1}$，对于其中的每个字符，我们将哈希表中该元素对应值**加上 $1$**；随后我们遍历字符串 $\textit{word2}$，对于其中的每个字符，我们将哈希表中该元素对应值**减去 $1$**。最终，哈希表中每个字符的值即为该字符在 $\textit{word1}$ 中的频数与该字符在 $\textit{word2}$ 中的频数之差。

我们判断该哈希表中每个字符的值的绝对值是否小于等于 $3$：如果是，则说明两个字符串几乎相等，此时我们返回 $\texttt{true}$；反之则说明两个字符串并不几乎相等，此时返回 $\texttt{false}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool checkAlmostEquivalent(string word1, string word2) {
        unordered_map<char, int> freq;   // 频数差哈希表
        for (auto ch: word1){
            ++freq[ch];
        }
        for (auto ch: word2){
            --freq[ch];
        }
        // 判断每个字符频数差是否均小于等于 3
        return all_of(freq.cbegin(), freq.cend(), [](auto&& x) { return abs(x.second) <= 3; });
    }
};
```


```Python [sol1-Python3]
class Solution:
    def checkAlmostEquivalent(self, word1: str, word2: str) -> bool:
        freq = defaultdict(int)   # 频数差哈希表
        for ch in word1:
            freq[ch] += 1
        for ch in word2:
            freq[ch] -= 1
        # 判断每个字符频数差是否均小于等于 3
        return all(abs(x) <= 3 for x in freq.values())
```


**复杂度分析**

- 时间复杂度：$O(n + |\Sigma|)$，其中 $n$ 为 $\textit{word1}$ 的长度，$|\Sigma|$ 为字符串 $\textit{word1}$ 和 $\textit{word2}$ 的字符集大小。遍历字符串维护频数差哈希表的时间复杂度为 $O(n)$，遍历频数差哈希表判断两字符串是否几乎相等的时间复杂度为 $O(|\Sigma|)$。

- 空间复杂度：$O(|\Sigma|)$，即为频数差哈希表的空间开销。
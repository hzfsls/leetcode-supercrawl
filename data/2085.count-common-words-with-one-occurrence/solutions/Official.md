#### 方法一：哈希表

**思路与算法**

我们用两个哈希表分别统计 $\textit{word1}$ 与 $\textit{word2}$ 中字符串的出现次数。

随后，我们遍历第一个哈希表中的字符串，检查它在 $\textit{word1}$ 与 $\textit{word2}$ 中的出现次数是否均为 $1$。与此同时，我们统计出现过一次的公共字符串个数，如果某个字符串在两个数组中均只出现一次，那么我们将个数加 $1$。最终，我们返回该个数作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countWords(vector<string>& words1, vector<string>& words2) {
        unordered_map<string, int> freq1, freq2;   // words1 和 words2 中字符串的出现次数
        for (const string& word1: words1){
            ++freq1[word1];
        }
        for (const string& word2: words2){
            ++freq2[word2];
        }
        int res = 0;   // 出现过一次的公共字符串个数
        for (const auto& [word1, cnt1] : freq1){
            // 遍历 words1 出现的字符并判断是否满足要求
            if (cnt1 == 1 && freq2[word1] == 1){
                ++res;
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countWords(self, words1: List[str], words2: List[str]) -> int:
        freq1 = Counter(words1)   # words1 中字符串的出现次数
        freq2 = Counter(words2)   # words2 中字符串的出现次数
        res = 0   # 出现过一次的公共字符串个数
        for word1 in freq1.keys():
            # 遍历 words1 出现的字符并判断是否满足要求
            if freq1[word1] == 1 and freq2[word1] == 1:
                res += 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(m + n)$，其中 $m$ 为 $\textit{word1}$ 中**所有字符串的长度之和**，$n$ 为 $\textit{word2}$ 中所有字符串的总长度。即为维护哈希表和遍历统计出现过一次的公共字符串数量的时间复杂度。

- 空间复杂度：$O(m + n)$，即为哈希表的空间开销。
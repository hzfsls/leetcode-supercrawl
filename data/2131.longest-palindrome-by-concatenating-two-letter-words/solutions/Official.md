## [2131.连接两字母单词得到的最长回文串 中文官方题解](https://leetcode.cn/problems/longest-palindrome-by-concatenating-two-letter-words/solutions/100000/lian-jie-liang-zi-mu-dan-ci-de-dao-de-zu-vs99)

#### 方法一：贪心 + 哈希表

**思路与算法**

根据回文串的定义，回文串可以由奇数或者偶数个 $\textit{words}$ 中的单词拼接而成，但必须满足以下条件：

- 如果数量为奇数，那么位于**正中间**的单词必须是**回文字符串**（即两个字符相等）；

- 每个单词和反转后对应位置的单词必须**互为反转字符串**。

根据上面的两个条件，我们可以得出构造最长回文串的规则：

- 对于两个字符**不同**的单词，需要尽可能多的**成对选择**它和它的反转字符串（如有）；

- 对于两个字符**相同**的单词，需要尽可能多的**成对选择**该单词；

- 如果按照上述条件挑选后，仍然存在**未被选择**的两个字符相同的单词（此时该字符串只可能有**一个**未被选择，且该字符串一定在 $\textit{words}$ 中出现**奇数次**），我们可以**任意选择一个**。

因此，我们用哈希表统计 $\textit{words}$ 中每个单词的出现次数。随后，我们遍历哈希表的所有元素，并用 $\textit{res}$ 维护可能构成回文字符串的最长长度，同时用初值为 $\texttt{false}$ 的布尔变量 $\textit{mid}$ 判断是否存在可以作为中心单词的、出现奇数次的回文单词。在遍历到字符串 $\textit{word}$ 时，我们首先求出它反转后的字符串 $\textit{rev}$，此时根据 $\textit{word}$ 与 $\textit{rev}$ 的关系，有以下两种情况：

- $\textit{word} \not = \textit{rev}$，此时我们需要统计两者在 $\textit{words}$ 出现次数的最小值，即为成对选择的最多数目。假设此时对数为 $n$，则其对最长回文字符串贡献的字符长度为 $4n$，我们将 $\textit{res}$ 加上对应值；

- $\textit{word} = \textit{rev}$，此时可以构成的对数为 $\lfloor m / 2 \rfloor$，即对最长回文字符串贡献的字符长度为 $4\lfloor m / 2 \rfloor$，我们同样将 $\textit{res}$ 加上对应值。除此以外，我们还需要判断 $\textit{word}$ 的出现次数 $m$ 是否为奇数：

    - 如果 $m$ 为奇数，则存在可以作为中心单词的剩余回文单词，我们将 $\textit{mid}$ 置为 $\texttt{true}$；
    
    - 如果 $m$ 为偶数，则不存在可以作为中心单词的剩余回文单词，我们不改变 $\textit{mid}$ 的取值。

最后，我们根据 $\textit{mid}$ 的取值，判断最长回文串是否含有中心单词。如果 $\textit{mid}$ 为 $\texttt{true}$，则代表含有，我们将 $\textit{res}$ 加上 $2$；反之则没有，我们不进行任何操作。

最后，我们返回 $\textit{res}$ 作为最长回文串的长度。

**细节**

在遍历哈希表中的每个单词时，为了避免重复计算成对选择的单词，我们只在 $\textit{word}$ 的**字典序大于等于** $\textit{rev}$ 时更新 $\textit{res}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int longestPalindrome(vector<string>& words) {
        unordered_map<string, int> freq;   // 单词出现次数
        for (const string& word: words) {
            ++freq[word];
        }
        int res = 0;   // 最长回文串长度
        bool mid = false;   // 是否含有中心单词
        for (const auto& [word, cnt]: freq) {
            // 遍历出现的单词，并更新长度
            string rev = string(1, word[1]) + word[0];   // 反转后的单词
            if (word == rev) {
                if (cnt % 2 == 1) {
                    mid = true;
                }
                res += 2 * (cnt / 2 * 2);
            }
            else if (word > rev) {   // 避免重复遍历
                res += 4 * min(freq[word], freq[rev]);
            }
        }
        if (mid) {
            // 含有中心单词，更新长度
            res += 2;
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def longestPalindrome(self, words: List[str]) -> int:
        freq = Counter(words)   # 单词出现次数
        res = 0   # 最长回文串长度
        mid = False   # 是否含有中心单词
        for word, cnt in freq.items():
            # 遍历出现的单词，并更新长度
            rev = word[1] + word[0]   # 反转后的单词
            if word == rev:
                if cnt % 2 == 1:
                    mid = True
                res += 2 * (cnt // 2 * 2)
            elif word > rev:   # 避免重复遍历
                res += 4 * min(freq[word], freq[rev])
        if mid:
            # 含有中心单词，更新长度
            res += 2
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{words}$ 的长度。即为遍历统计数组各个元素的出现次数以及遍历哈希表计算最长回文串长度的时间复杂度。

- 空间复杂度：$O(\min(n, |\Sigma|^2))$，即为哈希表的空间开销。哈希表的大小受到两方面限制：
    - 哈希表的大小小于等于两字母单词的数量，即 $O(|\Sigma|^2)$；
    - 哈希表的大小小于等于 $\textit{words}$ 中单词数量，即 $O(n)$。
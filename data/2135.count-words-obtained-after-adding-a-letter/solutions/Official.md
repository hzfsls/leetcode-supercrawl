## [2135.统计追加字母可以获得的单词数 中文官方题解](https://leetcode.cn/problems/count-words-obtained-after-adding-a-letter/solutions/100000/tong-ji-zhui-jia-zi-mu-ke-yi-huo-de-de-d-9ivl)
#### 方法一：维护所有可构成的状态

**思路与算法**

由于每个字符串仅含有**互不重复**的小写英文字母，且转换操作包含**任意顺序的重排**，因此「目标字符串是否可以获得」与「起始字符串是否可以构成目标字符串」仅取决于对应字符串**含有哪些英文字母**。

我们可以用一个 $26$ 位的二进制整数维护每个单词含有哪些英文字母。具体地，整数的第 $i$ 位为 $1$ 代表该字符串含有第 $i$ 个英文字母；反之亦然。那么，我们只需要用哈希集合维护 $\textit{startWords}$ 中每个字符串在转换操作后的所有可能状态，并计算 $\textit{startWords}$ 中有多少字符串对应的状态包含在该哈希表中即可。

具体地，我们用函数 $\textit{mask}(\textit{word})$ 来计算字符串 $\textit{word}$ 对应的状态值，其中我们用整数 $\textit{res}$ 来维护这一状态：在遍历 $\textit{word}$ 时，碰到字母表中第 $i$ 个字符，我们就对 $\textit{res}$ **从低到高的第 $i$ 位对 $1$ 取或**，即 $\textit{res} = \textit{res} | (1 << i)$。最终，我们返回 $\textit{res}$ 作为字符串 $\textit{word}$ 包含英文字母的状态。

进一步地，我们用哈希集合 $\textit{masks}$ 来维护 $\textit{startWords}$ 中每个字符串在转换操作后的所有可能状态，对于 $\textit{startWords}$ 每个字符串的状态 $\textit{msk}$，我们遍历它的所有二进制位，如果从低到高第 $i$ 个二进制位为 $0$，则说明它不含有第 $i$ 个字母，我们可以将该字母添加进字符串中，并将新的状态 $\textit{msk} | (1 << i)$ 添加进哈希集合 $\textit{masks}$ 中作为可以获得的状态；如果该二进制位为 $1$，则我们无法将对应英文字母添加进该字符串中，因此我们不进行任何操作。

最终，我们遍历 $\textit{startWords}$ 中的字符串，计算它对应的包含字母状态，并检查其是否存在于 $\textit{masks}$ 中。在遍历的过程中，我们统计状态位于 $\textit{masks}$ 中的字符串数量，并返回该数量作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int wordCount(vector<string>& startWords, vector<string>& targetWords) {
        // 将 word 转化为表示包含字母状态的二进制整数
        auto mask = [](const string& word) -> int {
            int res = 0;
            for (char ch: word) {
                res |= 1 << (ch - 'a');
            }
            return res;
        };
        
        unordered_set<int> masks;   // 所有可以获得的状态
        for (const string& start: startWords) {
            // 遍历初始单词，根据其状态值构造所有可以获得的状态
            int msk = mask(start);
            for (int i = 0; i < 26; ++i) {
                if (((msk >> i) & 1) == 0) {
                    masks.insert(msk | (1 << i));
                }
            }
        }
        int cnt = 0;   // 可以获得的单词数
        for (const string& target: targetWords) {
            if (masks.count(mask(target))) {
                ++cnt;
            }
        }
        return cnt;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def wordCount(self, startWords: List[str], targetWords: List[str]) -> int:
        # 将 word 转化为表示包含字母状态的二进制整数
        def mask(word: str) -> int:
            res = 0
            for ch in word:
                res |= 1 << (ord(ch) - ord('a'))
            return res
        
        masks = set()   # 所有可以获得的状态
        for start in startWords:
            # 遍历初始单词，根据其状态值构造所有可以获得的状态
            msk = mask(start)
            for i in range(26):
                if ((msk >> i) & 1) == 0:
                    masks.add(msk | (1 << i))
        cnt = 0   # 可以获得的单词数
        for target in targetWords:
            if mask(target) in masks:
                cnt += 1
        return cnt
```


**复杂度分析**

- 时间复杂度：$O(n|\Sigma| + m)$，其中 $n$ 为数组 $\textit{startWords}$ 的长度，$m$ 为数组 $\textit{targetWords}$ 的长度，$|\Sigma|$ 为字符集的大小。其中，维护所有可能状态的哈希集合的时间复杂度为 $O(n|\Sigma|)$，维护可构成目标字符串数量的时间复杂度为 $O(m)$。

- 空间复杂度：$O(n|\Sigma|)$，即为存储所有可构成状态的哈希集合的空间开销。
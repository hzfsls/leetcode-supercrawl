## [2273.移除字母异位词后的结果数组 中文官方题解](https://leetcode.cn/problems/find-resultant-array-after-removing-anagrams/solutions/100000/yi-chu-zi-mu-yi-wei-ci-hou-de-jie-guo-sh-xi48)

#### 方法一：逐个判断

**思路与算法**

由于「字母异位词」具有等价性和传递性，因此对于 $\textit{words}$ 中出现的多个连续字母异位词，我们只需要保留最前面的即可。

因此，我们可以采用如下的方式实现移除操作：

我们用 $\textit{res}$ 来表示结果数组，$\textit{res}$ 中初始含有 $\textit{words}[0]$。我们**按顺序**遍历 $\textit{words}$ 的剩余单词，每当遍历到一个新的单词时，我们检查该单词与 $\textit{words}$ 中它的**前一个**单词是否为字母异位词：如果是，则该单词需要被删除，我们不进行任何操作；反之则将该单词添加至 $\textit{res}$ 末尾。

关于如何判断两个单词 $\textit{word}_1$ 与 $\textit{word}_2$ 是否为字母异位词，我们用函数 $\textit{compare}(\textit{word}_1, \textit{word}_2)$ 实现判断。具体地，我们用长度为英文字符数量（$26$）的频率数组 $\textit{freq}$ 统计每个字符的出现次数，当我们遍历 $\textit{word}_1$ 的每个字符时，我们将 $\textit{freq}$ 对应下标的元素加上 $1$；当我们遍历 $\textit{word}_2$ 的每个字符时，我们将 $\textit{freq}$ 对应下标的元素减去 $1$。最终，如果 $\textit{freq}$ 数组的全部元素均为 $0$，则说明两个单词为字母异位词，我们返回 $\texttt{true}$；反之则不是，我们返回 $\texttt{false}$。

最终 $\textit{res}$ 即为移除字母异位词之后的结果数组，我们返回该数组作为答案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<string> removeAnagrams(vector<string>& words) {
        vector<string> res = {words[0]};   // 结果数组
        int n = words.size();
        // 判断两个单词是否为字母异位词
        auto compare = [](const string& word1, const string& word2) -> bool {
            vector<int> freq(26);
            for (char ch: word1) {
                ++freq[ch-'a'];
            }
            for (char ch: word2) {
                --freq[ch-'a'];
            }
            return all_of(freq.begin(), freq.end(), [](int x) { return x == 0; });
        };

        for (int i = 1; i < n; ++i) {
            if (compare(words[i], words[i-1])) {
                continue;
            }
            res.push_back(words[i]);
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def removeAnagrams(self, words: List[str]) -> List[str]:
        res = [words[0]]   # 结果数组
        n = len(words)
        # 判断两个单词是否为字母异位词
        def compare(word1: str, word2: str) -> bool:
            freq = [0] * 26
            for ch in word1:
                freq[ord(ch)-ord('a')] += 1
            for ch in word2:
                freq[ord(ch)-ord('a')] -= 1
            return all(x == 0 for x in freq)
        
        for i in range(1, n):
            if compare(words[i], words[i-1]):
                continue
            res.append(words[i])
        return res
```


**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $n$ 为 $\textit{words}$ 的长度, $m$ 为 $\textit{words}$ 中单词的长度。即为遍历 $\textit{words}$ 数组并判断每个元素是否需要移除的时间复杂度。

- 空间复杂度：$O(|\Sigma|)$，其中 $|\Sigma|$ 为字符集的大小。即为字符出现次数数组的空间开销。
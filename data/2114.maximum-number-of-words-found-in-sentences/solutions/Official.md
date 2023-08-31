## [2114.句子中的最多单词数 中文官方题解](https://leetcode.cn/problems/maximum-number-of-words-found-in-sentences/solutions/100000/ju-zi-zhong-de-zui-duo-dan-ci-shu-by-lee-c1in)

#### 方法一：计算空格数量

**思路与算法**

由于一个句子开头结尾均不含空格，且单词之间均只含一个空格，因此一个句子中的**单词数一定等于空格数加上 $1$**。

那么我们可以遍历句子数组，通过统计每个句子的空格数量来计算它的单词数量，同时维护这些句子单词数量的最大值。当遍历完成后，我们返回该最大值作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int mostWordsFound(vector<string>& sentences) {
        int res = 0;
        for (const string& sentence: sentences) {
            // 单词数 = 空格数 + 1
            int cnt = count(sentence.begin(), sentence.end(), ' ') + 1;
            res = max(res, cnt);
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def mostWordsFound(self, sentences: List[str]) -> int:
        res = 0
        for sentence in sentences:
            #  单词数 = 空格数 + 1
            cnt = sentence.count(' ') + 1
            res = max(res, cnt)
        return res
```


**复杂度分析**

- 时间复杂度：$O(\sum_i n_i)$，其中 $n_i$ 为 $\textit{sentences}[i]$ 的长度。即为遍历字符串统计单词数并维护最大值的时间复杂度。

- 空间复杂度：$O(n)$。
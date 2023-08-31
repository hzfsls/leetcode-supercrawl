## [2255.统计是给定字符串前缀的字符串数目 中文官方题解](https://leetcode.cn/problems/count-prefixes-of-a-given-string/solutions/100000/tong-ji-shi-gei-ding-zi-fu-chuan-qian-zh-vpyg)

#### 方法一：遍历判断

**思路与算法**

我们可以遍历 $\textit{words}$ 数组，并判断每个字符串 $\textit{word}$ 是否是 $s$ 的前缀。与此同时，我们用 $\textit{res}$ 来维护包含前缀字符串的数量。如果 $\textit{word}$ 是 $s$ 的前缀，则我们将 $\textit{res}$ 加上 $1$。最终，我们返回 $\textit{res}$ 作为答案。

关于判断 $\textit{word}$ 是否为 $\textit{s}$ 的前缀，某些语言如 $\texttt{Python}$ 有字符串对应的 $\texttt{startswith()}$ 方法。对于没有类似方法的语言，我们也可以手动实现以达到相似的效果。

具体地，我们用函数 $\textit{isPrefix}(\textit{word})$ 来实现这一判断。首先当 $s$ 的长度小于 $\textit{word}$ 时，$\textit{word}$ 一定不可能是 $s$ 的前缀，此时返回 $\texttt{false}$。随后，我们从头开始逐字符判断 $\textit{word}$ 和 $\textit{s}$ 的对应字符是否相等。如果某个字符不相等，同样返回 $\texttt{false}$。如果遍历完成 $\textit{word}$ 后所有字符均相等，则返回 $\texttt{true}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int countPrefixes(vector<string>& words, string s) {
        int res = 0;   // 符合要求字符串个数
        // 判断 word 是否是 s 的前缀
        auto isPrefix = [&](const string& word) -> bool {
            if (s.size() < word.size()) {
                return false;
            }
            for (int i = 0; i < word.size(); ++i) {
                if (word[i] != s[i]) {
                    return false;
                }
            }
            return true;
        };
        
        for (const string& word: words) {
            if (isPrefix(word)) {
                ++res;
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def countPrefixes(self, words: List[str], s: str) -> int:
        res = 0   # 符合要求字符串个数
        for word in words:
            if s.startswith(word):
                res += 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(mn)$，其中 $m$ 为 $\textit{words}$ 数组的长度，$n$ 为字符串 $s$ 的长度。每判断 $\textit{words}$ 中一个字符串的时间复杂度为 $O(n)$，我们总共需要判断 $m$ 次。

- 空间复杂度：O(1)。
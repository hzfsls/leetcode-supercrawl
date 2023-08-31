## [1974.使用特殊打字机键入单词的最少时间 中文官方题解](https://leetcode.cn/problems/minimum-time-to-type-word-using-special-typewriter/solutions/100000/shi-yong-te-shu-da-zi-ji-jian-ru-dan-ci-54xfk)
#### 方法一：模拟

**思路与算法**

我们遍历字符串 $\textit{word}$ 来模拟键入单词的过程。在键入每个字符时，我们首先需要将指针移动至该字符，然后键入相应的字符。

移动的过程中，为了使得耗时最短，我们应当将指针始终往相同方向移动，直至到目标字符。那么该过程的最短耗时即为顺时针或逆时针移动耗时的最小值。

为了计算方便，我们可以将字符按照字典序映射到 $0$ 与 $25$ 之间的整数，上述两种移动方式可以按照指针是否跨过 $0$ 与 $25$ 的**边界线**进行分类。我们设当前字符对应整数为 $\textit{prev}$，目标字符对应整数为 $\textit{curr}$，那么两种移动方式对应的耗时即为（其中 $|\dots|$ 表示绝对值）：

- 不跨过边界线，耗时为 $|\textit{curr} - \textit{prev}|$;

- 跨过边界线，耗时为 $26 - |\textit{curr} - \textit{prev}|$。

那么移动耗时即为上述两者的最小值，键入字符的总耗时即为移动耗时加上键入耗时 $1$。

在遍历字符串时，我们维护当前字符对应的整数 $\textit{prev}$（初值为 $0$），并统计键入每个字符的最小耗时总和。最终，我们返回该总和作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minTimeToType(string word) {
        int res = 0;
        int prev = 0;   // 当前位置
        for (char ch : word){
            // 计算键入每个字符的最小耗时并更新当前位置
            int curr = ch - 'a';
            res += 1 + min(abs(curr - prev), 26 - abs(curr - prev));
            prev = curr;
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def minTimeToType(self, word: str) -> int:
        prev = 0
        res = 0   # 当前位置
        for ch in word:
            # 计算键入每个字符的最小耗时并更新当前位置
            curr = ord(ch) - ord('a')
            res += 1 + min(abs(curr - prev), 26 - abs(curr - prev))
            prev = curr
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{word}$ 的长度。即为遍历 $\textit{word}$ 计算最小总耗时的时间复杂度。

- 空间复杂度：$O(1)$。
## [2278.字母在字符串中的百分比 中文官方题解](https://leetcode.cn/problems/percentage-of-letter-in-string/solutions/100000/zi-mu-zai-zi-fu-chuan-zhong-de-bai-fen-b-6jm6)
#### 方法一：遍历统计

**思路与算法**

我们用 $n$ 表示字符串 $s$ 的长度。首先我们遍历字符串，并用 $\textit{cnt}$ 统计字母 $\textit{letter}$ 在 $s$ 中的出现次数。那么，$s$ 中 $\textit{letter}$ 所占的**百分比**即为 $100 \times \textit{cnt} / s$，**向下取整**后的值即为 $\lfloor 100 \times \textit{cnt} / s \rfloor$（其中 $\lfloor \dots \rfloor$ 代表向下取整）。我们计算上式的值，并作为答案返回即可。 

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int percentageLetter(string s, char letter) {
        int n = s.size();
        int cnt = 0;
        for (char ch: s) {
            if (ch == letter) {
                ++cnt;
            }
        }
        return 100 * cnt / n;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def percentageLetter(self, s: str, letter: str) -> int:
        n = len(s)
        cnt = 0
        for ch in s:
            if ch == letter:
                cnt += 1
        return 100 * cnt // n
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $s$ 的长度。即为遍历计算字符出现次数的时间复杂度。

- 空间复杂度：$O(1)$。
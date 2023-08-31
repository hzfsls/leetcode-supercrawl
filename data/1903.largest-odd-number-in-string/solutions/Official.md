## [1903.字符串中的最大奇数 中文官方题解](https://leetcode.cn/problems/largest-odd-number-in-string/solutions/100000/zi-fu-chuan-zhong-de-zui-da-qi-shu-by-le-xggo)
#### 方法一：贪心


**思路与算法**

首先，如果 $\textit{num}$ 中不含有值为奇数的字符，那么 $\textit{num}$ 的任何子串的值都不可能是奇数，此时应返回空字符串 $\texttt{""}$。

下面考虑 $\textit{num}$ 中含有值为奇数的字符的情况。假设 $\textit{num}[j]$ 的数值是奇数，那么所有以 $\textit{num}[j]$ 结尾的子串的数值都是奇数。由于 $\textit{num}$ **不含前导零**，且在子串中前缀 $\textit{num}[0..j+1]$ 的**长度最长**，因此这些子串中数值最大的为 $\textit{num}[0..j+1]$。

我们假设 $\textit{num}$ 中**最后一个**值为奇数的字符的下标为 $j_0$，那么对于任意值为奇数的下标 $j$，一定有 $j \le j_0$，即 $\textit{num}[0..j_0+1]$ 的长度一定大于等于 $\textit{num}[0..j_0+1]$ 的长度。同时，上述两个子串均不含前导零。那么，$\textit{num}$ 中值为奇数且值最大的子字符串即为 $\textit{num}[0..j_0+1]$。

我们**从右到左**遍历 $\textit{num}$ 中的字符，当遍历到第一个值为奇数的字符时，我们假设它的下标为 $i$，此时子字符串 $\textit{num}[0..i+1]$ 即为值为奇数且值最大的子字符串，我们返回该子字符串作为答案。而如果 $\textit{num}$ 中不存在值为奇数的字符，我们则返回空字符串 $\texttt{""}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string largestOddNumber(string num) {
        int n = num.size();
        for (int i = n - 1; i >= 0; --i){
            if ((num[i] - '0') % 2 == 1){
                // 找到第一个值为奇数的字符，返回 num[0:i+1]
                return num.substr(0, i + 1);
            }
        }
        // 未找到值为奇数的字符，返回空字符串
        return "";
    }
};
```

```Python [sol1-Python3]
class Solution:
    def largestOddNumber(self, num: str) -> str:
        n = len(num)
        for i in range(n - 1, -1, -1):
            if int(num[i]) % 2 == 1:
                # 找到第一个值为奇数的字符，返回 num[0:i+1]
                return num[:i+1]
        # 未找到值为奇数的字符，返回空字符串
        return ""
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{num}$ 的长度。遍历字符串和返回符合要求子串的时间复杂度均为 $O(n)$。

- 空间复杂度：$O(1)$，输出字符串不计入空间复杂度。
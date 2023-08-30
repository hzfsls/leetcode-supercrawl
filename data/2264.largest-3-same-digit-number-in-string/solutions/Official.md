#### 方法一：枚举

**思路与算法**

为了找到最大的优质整数，我们可以枚举字符串 $\textit{num}$ 中所有长度为 $3$ 的子串，并记录符合要求且对应数值最大的子串。

具体地，我们用初值为空的字符串 $\textit{res}$ 来维护数值最大的符合要求子串，同时从左至右遍历长度为 $3$ 子串的**起始下标** $i$，每遍历到一个新的下标 $i$，我们判断以子串 $\textit{num}[i..i + 2]$ 是否由相同的字符构成：如果是则该子串符合要求，我们将 $\textit{res}$ 更新为 $\textit{res}$ 和该子串的较大值（此处字符串字典序的大小关系与对应整数的大小关系一致）；如果不是则不进行任何操作。

最终，如果存在符合要求的子串，则 $\textit{res}$ 即为对应数值最大的子串；如果不存在，则 $\textit{res}$ 为空字符串。因此我们返回 $\textit{res}$ 作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string largestGoodInteger(string num) {
        int n = num.size();
        string res;
        for (int i = 0; i < n - 2; ++i) {
            if (num[i] == num[i+1] && num[i+1] == num[i+2]) {
                res = max(res, num.substr(i, 3));
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def largestGoodInteger(self, num: str) -> str:
        n = len(num)
        res = ""
        for i in range(n - 2):
            if num[i] == num[i+1] == num[i+2]:
                res = max(res, num[i:i+3])
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{num}$ 的长度。即为枚举所有长度为 $3$ 子串的时间复杂度。

- 空间复杂度：$O(1)$。
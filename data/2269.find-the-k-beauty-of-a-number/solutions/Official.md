#### 方法一：枚举

**思路与算法**

为了方便起见，我们用 $s$ 表示 $\textit{num}$ 对应十进制表示的字符串。我们可以从左至右枚举 $s$ 中长度为 $k$ 的字符串，并判断该子串对应的整数能否被 $\textit{num}$ 整除。与此同时，我们用 $\textit{res}$ 统计能被 $\textit{num}$ 整除的子串数量，如果某个子串能被 $\textit{num}$ 整除，则我们将 $\textit{res}$ 加上 $1$。最终，$\textit{res}$ 即为 $\textit{num}$ 的 $k$ 美丽值，我们返回 $\textit{res}$ 作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int divisorSubstrings(int num, int k) {
        string s = to_string(num);   // num 十进制表示字符串
        int n = s.size();
        int res = 0;
        for (int i = 0; i <= n - k; ++i) {
            // 枚举所有长度为 k 的子串
            int tmp = stoi(s.substr(i, k));
            if (tmp && num % tmp == 0) {
                ++res;
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def divisorSubstrings(self, num: int, k: int) -> int:
        s = str(num)   # num 十进制表示字符串
        n = len(s)
        res = 0
        for i in range(n - k + 1):
            # 枚举所有长度为 k 的子串
            tmp = int(s[i:i+k])
            if tmp != 0 and num % tmp == 0:
                res += 1
        return res
```


**复杂度分析**

- 时间复杂度：$O(nk)$，其中 $n$ 为 $\textit{num}$ 的位数, $k$ 为子串的长度。我们总共需要枚举 $O(n)$ 个子串，其中判断每个子串都需要 $O(k)$ 的时间复杂度。

- 空间复杂度：$O(n)$，即为辅助字符串的空间开销。
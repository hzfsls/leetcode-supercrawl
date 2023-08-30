#### 方法一：寻找每一组的起始下标

**思路与算法**

我们假设字符串 $s$ 的长度为 $n$。由于分组后的字符串，除了最后一组以外，每一组的长度为 $k$，因此我们可以确定每一组字符串的起始下标，其中第 $i$ 组的起始下标为 $k\times i$；基于此，我们就可以确定每一组的字符串对应 $s$ 中的下标范围，即 $[k\times i, \min((k + 1)\times i, n) - 1]$ 闭区间。

具体地，我们用数组 $\textit{res}$ 来保存每组字符串，并用 $\textit{curr}$ 维护当前组的起始下标。$\textit{curr}$ 的初值为 $0$，当 $\textit{curr}$ 为合法下标时，说明当前组字符串存在，我们将该组对应的子串 $s[k\times i..\min((k + 1)\times i, n) - 1]$ 加入 $\textit{res}$ 的尾部，同时将 $\textit{curr}$ 加上 $k$ 作为可能存在的下一组的起始下标。

最终，数组 $\textit{res}$ 的最后一个元素即为最后一组字符串，我们需要按要求使用填充字符 $\textit{fill}$ 将其长度补充至 $k$。上述操作完成后，我们返回 $\textit{res}$ 数组作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<string> divideString(string s, int k, char fill) {
        vector<string> res;   // 分组后的字符串
        int n = s.size();
        int curr = 0;   // 每个分组的起始下标
        // 拆分字符串
        while (curr < n) {
            res.push_back(s.substr(curr, k));
            curr += k;
        }
        // 尝试填充最后一组
        res.back() += string(k - res.back().length(), fill);
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def divideString(self, s: str, k: int, fill: str) -> List[str]:
        res = []   # 分组后的字符串
        n = len(s)
        curr = 0   # 每个分组的起始下标
        # 拆分字符串
        while curr < n:
            res.append(s[curr:curr+k])
            curr += k
        # 尝试填充最后一组
        res[-1] += fill * (k - len(res[-1]))
        return res
```


**复杂度分析**

- 时间复杂度：$O(\max(n, k))$，其中 $n$ 为字符串 $s$ 的长度。即为对字符串分组并填充的时间复杂度。

- 空间复杂度：$O(1)$，输出数组不计入空间复杂度。
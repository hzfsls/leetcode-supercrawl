## [1957.删除字符使字符串变好 中文官方题解](https://leetcode.cn/problems/delete-characters-to-make-fancy-string/solutions/100000/shan-chu-zi-fu-shi-zi-fu-chuan-bian-hao-12ovq)
#### 方法一：模拟

**思路与算法**

如果想使得好字符串对应的删除字符数量最少，那么最佳的删除策略是：对于 $s$ 中每一个长度为 $k (k \ge 3)$ 的连续相同字符子串，删去其中任意 $k - 2$ 个字符。

我们可以用一个新字符串 $\textit{res}$ 来维护删除最少字符后得到的好字符串，并从左至右遍历字符串 $s$ 模拟删除过程。每当遍历至一个新的字符时，我们检查 $\textit{res}$ 中的最后两个字符（如有）是否均等于当前字符：

- 如果是，则该字符应被删除，我们不将该字符添加进 $\textit{res}$；

- 如果不是，则不需要删除该字符，我们应当将该字符添加进 $\textit{res}$。

当遍历完成 $s$ 后，$\textit{res}$ 即为删除最少字符后得到的好字符串，我们返回 $\textit{res}$ 作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    string makeFancyString(string s) {
        string res;   // 删除后的字符串
        // 遍历 s 模拟删除过程
        for (char ch : s){
            int n = res.size();
            if (n >= 2 && res[n-1] == ch && res[n-2] == ch){
                // 如果 res 最后两个字符与当前字符均相等，则不添加
                continue;
            }
            // 反之则添加
            res.push_back(ch);
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def makeFancyString(self, s: str) -> str:
        res = []   # 删除后的字符串
        # 遍历 s 模拟删除过程
        for ch in s:
            if len(res) >= 2 and res[-1] == res[-2] == ch:
                # 如果 res 最后两个字符与当前字符均相等，则不添加
                continue
            # 反之则添加
            res.append(ch)
        return "".join(res)
```


**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：由于不同语言的字符串实现与方法不同，空间复杂度也有所不同。对于 $\texttt{C++}$ 解法，空间复杂度为 $O(1)$；而对于 $\texttt{Python}$ 解法，空间复杂度为 $O(n)$。
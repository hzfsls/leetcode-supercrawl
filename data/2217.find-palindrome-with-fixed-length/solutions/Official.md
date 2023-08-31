## [2217.找到指定长度的回文数 中文官方题解](https://leetcode.cn/problems/find-palindrome-with-fixed-length/solutions/100000/zhao-dao-zhi-ding-chang-du-de-hui-wen-sh-6i6j)

#### 方法一：数学

**思路与算法**

对于一个长度为 $n$ 的回文数，我们一定可以由它的前 $l = \lfloor (n + 1) / 2 \rfloor$ （其中 $\lfloor (n + 1) / 2 \rfloor$ 为向下取整）位整数唯一确定该数。与此同时，当 $n$ 确定时，回文数数值的大小也与这个 $l$ 位（**无前导零**）整数的大小**正相关**。因此，一个第 $k$ 小（从 $1$ 开始计算）的长度为 $n$ 的回文数，它的前 $l$ 位一定是第 $k$ 小的 $l$ 位**无前导零**整数，即 $10^{l - 1} + k - 1$。

在计算出第 $k$ 小的 $l$ 位整数 $\textit{num}$ 后，我们就可以反推得到对应的回文数。我们用函数 $\textit{recover}(\textit{num})$ 来实现这一过程。

具体地，我们首先将 $\textit{num}$ 转化为字符串 $s$，并基于此拼接出 $n$ 位的回文字符串。根据 $n$ 的奇偶性不同，拼接方法也不同，具体而言：

- $n$ 为偶数，此时我们有 $n = 2 \times i$，我们只需要将 $s$ 反转后的字符串拼接在 $s$ 的尾部即可;

- $n$ 为奇数，此时我们有 $n = 2 \times i - 1$，我们需要将 $s[0..l-2]$，即将 $s$ **去掉最后一个字符**的剩余部分反转并拼接在 $s$ 尾部。

最终，我们将拼接完成的字符串转化为整数并返回。

我们用数组 $\textit{res}$ 依次存储每次询问的答案，在处理每次询问 $\textit{query}$ 时，我们首先判断第 $\textit{query}$ 个 $n$ 位回文数**是否存在**，这等价于第 $\textit{query}$ 个 $l$ 位无前导零整数是否存在，即 $10^{l - 1} \textit{query} k - 1 < 10^l$。如果该式不成立，则回文数不存在，我们应当将 $-1$ 加入 $\textit{res}$ 数组；如果该式成立，则我们利用上文的方式计算出对应的回文数并加入数组。最终，$\textit{res}$ 数组即为所有询问的答案，我们返回该数组作为答案。 


**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<long long> kthPalindrome(vector<int>& queries, int intLength) {
        int l = (intLength + 1) / 2;   // 可以唯一确定回文数的前半部分的长度
        int start = (int) pow(10, l - 1) - 1;   // start + k 即为第 k 个 l 位无前导零整数
        int limit = (int) pow(10, l) - 1;   // l 位无前导零整数的上界
        vector<long long> res;
        // 将前半部分恢复为对应的回文数
        auto recover = [&](int num) -> long long {
            string s = to_string(num);
            if (intLength % 2 == 0) {
                for (int i = l - 1; i >= 0; --i) {
                    s.push_back(s[i]);
                }
            } else {
                for (int i = l - 2; i >= 0; --i) {
                    s.push_back(s[i]);
                }
            }
            return stoll(s);
        };
        
        // 依次处理询问
        for (int query: queries) {
            if (start + query > limit) {
                // 不存在
                res.push_back(-1);
                continue;
            }
            res.push_back(recover(start + query));
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def kthPalindrome(self, queries: List[int], intLength: int) -> List[int]:
        l = (intLength + 1) // 2   # 可以唯一确定回文数的前半部分的长度
        start = 10 ** (l - 1) - 1   # start + k 即为第 k 个 l 位无前导零整数
        limit = 10 ** l - 1   # l 位无前导零整数的上界
        res = []
        # 将前半部分恢复为对应的回文数
        def recover(num: int) -> int:
            if intLength % 2 == 0:
                return int(str(num) + str(num)[::-1])
            else:
                return int(str(num)[:-1] + str(num)[::-1])

        # 依次处理询问
        for query in queries:
            if start + query > limit:
                # 不存在
                res.append(-1)
                continue
            res.append(recover(start + query))
        return res
```


**复杂度分析**

- 时间复杂度：$O(qn)$，其中 $q$ 为数组 $\textit{queries}$ 的长度，即询问的次数；$n = \textit{intLength}$ 即回文数的长度。我们总共需要处理 $O(q)$ 次询问，每次需要 $O(n)$ 的时间构造对应的回文数。

- 空间复杂度：$O(q)$，即为构造回文数时辅助字符串的空间开销。
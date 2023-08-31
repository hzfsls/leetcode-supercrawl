## [2222.选择建筑的方案数 中文官方题解](https://leetcode.cn/problems/number-of-ways-to-select-buildings/solutions/100000/xuan-ze-jian-zhu-de-fang-an-shu-by-leetc-jhup)

#### 方法一：枚举中间元素

**思路与算法**

由于不允许相邻被选择建筑是同一类型，因此选择的长度为 $3$ 子序列只可能有两种情况，即 $\texttt{"010"}$ 与 $\texttt{"101"}$，那么有效方案数即为字符串 $s$ 中子序列 $\texttt{"010"}$ 与 $\texttt{"101"}$ 的种类数之和。

我们不妨以子序列 $\texttt{"101"}$ 为例，为了计算该子序列的种类数，我们可以遍历字符串 $s$ 枚举子序列的**中间元素**（此处为 $\texttt{`1'}$）。

为了表达方便，我们用 $n$ 表示字符串 $s$ 的长度，并用 $\textit{cnt}_1(i, j)$ 表示子串 $s[i..j]$（包含两端）中 $\texttt{`1'}$ 的个数。具体地，如果 $s$ 中下标为 $i$ 的元素 $s[i]$ 为 $\texttt{`1'}$，那么由该字符为中间元素组成的 $\texttt{"101"}$ 子序列个数即为 $\textit{cnt}_1(0, i - 1) \times \textit{cnt}_1(i + 1, n - 1)$。

如果我们对于每一个符合要求的下标都通过遍历暴力计算 $\textit{cnt}_1(0, i - 1)$ 以及 $\textit{cnt}_1(i + 1, n - 1)$，那么每一次计算的时间复杂度即为 $O(n)$，总复杂度不符合数据范围要求，因此我们需要对上式的计算进行一定的优化。

由于我们在枚举中间元素时是按照下标顺序对 $s$ 进行遍历，因此在遍历的过程中，我们可以用 $\textit{cnt}$ 来维护 $[0, i - 1]$ **闭区间**内 $\texttt{`1'}$ 的个数，即 $\textit{cnt}_1(0, i - 1)$；而如果我们**事先遍历** $s$ 计算出 $s$ 中 $\texttt{`1'}$ 的总个数 $\textit{n}_1$，那么就有 $\textit{cnt}_1(i + 1, n - 1) = n_1 - \textit{cnt}$（由于 $s[i]$ **一定为 $\texttt{`0'}$**）。即由 $s[i]$ 为中间元素组成的 $\texttt{"101"}$ 子序列个数为：

$$
\textit{cnt} \times (n_1 - \textit{cnt}).
$$

我们可以在遍历中间元素的下标时，维护 $\textit{cnt}$，并使用 $\textit{res}$ 维护 $\texttt{"101"}$ 的种类数总和，即对于所有元素为 $\texttt{`0'}$ 的下标，我们计算上式并将对应的数值加在 $\textit{res}$ 上即可。

类似地，我们也可以在遍历字符串的同时计算 $\texttt{"010"}$ 的种类数总和并同样加在 $\textit{res}$ 上。具体地，当遍历到 $\texttt{`1'}$ 时，我们计算以该下标 $i$ 为中间元素时 $\texttt{"010"}$ 的种类数总和：

$$
(i - \textit{cnt}) \times ((n - n_1) - (i - \textit{cnt})).
$$

其中乘号左边代表 $[0, i - 1]$ **闭区间**内 $\texttt{`0'}$ 的个数，右边代表 $[i + 1, n - 1]$ **闭区间**内 $\texttt{`0'}$ 的个数。

综上所述，我们需要**首先遍历**一遍字符串 $s$ 计算出 $s$ 中 $\texttt{`1'}$ 的总个数 $\textit{n}_1$，随后**再次遍历**字符串，按照上文的方式维护已经遍历过 $\texttt{`1'}$ 的个数 $\textit{cnt}$ 与符合要求子串种数总和 $\textit{res}$。当遍历完成后，我们返回 $\textit{res}$ 即可。

**细节**

对于 $\texttt{C++}$ 等语言，在计算上面两个中间值时，数值有可能超过 $32$ 位有符号整数的上界，因此我们需要在乘法操作前将任一乘数转化为 $64$ 位整数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long numberOfWays(string s) {
        int n = s.size();
        int n1 = count(s.begin(), s.end(), '1');   // s 中 '1' 的个数
        long long res = 0;   // 两种子序列的个数总和
        int cnt = 0;   // 遍历到目前为止 '1' 的个数
        for (int i = 0; i < n; ++i) {
            if (s[i] == '1') {
                res += (long long) (i - cnt) * (n - n1 - i + cnt);
                ++cnt;
            } else {
                res += (long long) cnt * (n1 - cnt);
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def numberOfWays(self, s: str) -> int:
        n = len(s)
        n1 = s.count('1')   # s 中 '1' 的个数
        res = 0   # 两种子序列的个数总和
        cnt = 0   # 遍历到目前为止 '1' 的个数
        for i in range(n):
            if s[i] == '1':
                res += (i - cnt) * (n - n1 - i + cnt)
                cnt += 1
            else:
                res += cnt * (n1 - cnt)
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为字符串 $s$ 的长度，即为遍历计算字符串中 $1$ 的数量以及计算方案总数的时间复杂度。

- 空间复杂度：$O(1)$。
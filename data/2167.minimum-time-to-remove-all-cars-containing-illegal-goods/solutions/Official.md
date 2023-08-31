## [2167.移除所有载有违禁货物车厢所需的最少时间 中文官方题解](https://leetcode.cn/problems/minimum-time-to-remove-all-cars-containing-illegal-goods/solutions/100000/yi-chu-suo-you-zai-you-wei-jin-huo-wu-ch-qinx)

#### 方法一：前缀和

**思路与算法**

对于字符串 $s$ 中的每一个 $1$，记它的下标为 $i$，那么根据题目要求，要想将其移除，必须满足以下三个条件之一：

- 从左侧开始，将 $[0, i]$ 范围内的车厢全部移除，用去 $i+1$ 单位时间；

- 直接从中间进行移除，用去 $2$ 单位时间；

- 从右侧开始，将 $[i, n)$ 范围内的车厢全部移除，用去 $n-i$ 单位时间，其中 $n$ 是字符串 $s$ 的长度。

如果我们把 $s$ 中的每一个 $1$ 满足的条件全部进行合并，那么最终的移除方法必然为以下二者之一：

- 字符串中所有的字符都被移除，用去 $n$ 单位时间；

- 存在一个区间 $[i, j]$，区间左侧的字符 $[0, i)$ 全部被移除，区间右侧的字符 $(j, n)$ 全部被移除，区间内的 $1$ 全部被移除，一共用去：

    $$
    (i) + (n-j-1) + 2 \cdot \text{Count}(i, j)
    $$

    单位时间。其中 $\text{Count}(i, j)$ 表示 $s[i..j]$ 中 $1$ 的个数。如果我们预处理出字符串 $s$ 的前缀和（将字符 $0/1$ 看成对应的数字）$\textit{pre}$，那么 $\text{Count}(i, j)$ 就可以写成 $\textit{pre}[j] - \textit{pre}[i-1]$。

因此我们的目的就是求出：

$$
(i) + (n-j-1) + 2 \cdot (\textit{pre}[j] - \textit{pre}[i-1]) \tag{1}
$$

的最小值，其中 $i \leq j$。

我们可以把 $(1)$ 式拆分成三部分：与 $i$ 有关的项，与 $j$ 有关的项，以及常数项。即为：

$$
\big( i - 2 \cdot \textit{pre}[i-1] \big) + \big(2 \cdot \textit{pre}[j] - j\big) + \big(n-1 \big) \tag{2}
$$

因此我们通过一次遍历就可以求出 $(2)$ 式的最小值：

- 我们从小到大枚举 $j$，并使用变量 $\textit{prebest}$ 记录 $i - 2 \cdot \textit{pre}[i-1]$ 的最小值；

- 对于当前的 $j$，我们先用 $j - 2 \cdot \textit{pre}[j-1]$ 更新 $\textit{prebest}$，再用 $\textit{prebest}$ 加上 $2 \cdot \textit{pre}[j] - j$ 更新答案；

- 在遍历完成后，将答案加上 $n-1$，即为最少需要的时间。

**细节**

注意到当我们枚举 $j$ 时，使用到的前缀和项实际上只有 $\textit{pre}[j-1]$ 和 $\textit{pre}[j]$。因此我们使用一个变量记录前缀和即可，而不需要使用一整个数组。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumTime(string s) {
        int n = s.size();
        int ans = INT_MAX;
        int presum = 0, prebest = 0;
        for (int j = 0; j < n; ++j) {
            prebest = min(prebest, j - 2 * presum);
            presum += (s[j] - '0');
            ans = min(ans, prebest + 2 * presum - j);
        }
        return min(ans + n - 1, n);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def minimumTime(self, s: str) -> int:
        n = len(s)
        ans = float("inf")
        presum = prebest = 0

        for j, ch in enumerate(s):
            prebest = min(prebest, j - 2 * presum)
            presum += int(s[j])
            ans = min(ans, prebest + 2 * presum - j)
        
        return min(ans + n - 1, n)
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是字符串 $s$ 的长度。

- 空间复杂度：$O(1)$。
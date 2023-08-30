#### 方法一：二分查找

**思路与算法**

假设最多可以运行 $k$ 分钟，那么我们就可以画一个 $k$ 行 $n$ 列的表 $A$，其中位置 $(i, j)$ 需要填写一个在 $[0, m)$ 范围内的数（这里 $m$ 表示数组 $\textit{batteries}$ 的长度），表示第 $j$ 台电脑在第 $i$ 分钟使用了电池 $A(i, j)$。

根据题目的要求，这个表有如下的限制：

- 同一行的元素必须互不相同。即在某一分钟内，所有的 $n$ 台电脑使用的电池都不相同；

- 每一个在 $[0, m)$ 范围内的数 $x$ 的出现次数都不能超过对应的 $\textit{batteries}[x]$。

同时，第一个限制间接地要求了 $x$ 的出现次数不能超过 $k$。也就是说，$x$ 的出现次数不能超过：

$$
\min(\textit{batteries}[x], k)
$$

$k$ 是可以通过二分查找确定的。因为如果可以运行 $k$ 分钟，那么也一定可以运行 $k-1, k-2, \cdots$ 分钟。因此一定存在一个 $k'$，使得我们可以运行 $\leq k'$ 分钟，但不能运行 $> k'$ 分钟，此时 $k'$ 就是我们需要求出的答案。

在二分查找的每一步中，设当前需要进行判定的分钟数为 $\textit{mid}$，那么每一个 $x$ 的出现次数不能超过 $\textit{occ}(x) = \min(\textit{batteries}[x], \textit{mid})$。如果所有 $\textit{occ}(x)$ 的和没有超过 $\textit{mid} \times n$，那么我们甚至都找不到 $\textit{mid} \times n$ 个数来填表，因此一定没有办法满足要求；而如果所有 $\textit{occ}(x)$ 的和大于等于 $\textit{mid} \times n$，那么我们可以断定，一定是可以根据限制来填表的。

这是因为我们只要按照**列优先**的顺序，将这些数按照从小到达的顺序填入表中即可，其中数 $x$ 连续地填写 $\textit{occ}(x)$ 次。显然第二个限制一定是满足要求的，因为 $\textit{occ}(x) \leq \textit{batteries}[x]$。而第一个限制同样是满足要求的，因为 $\textit{occ}(x) \leq \textit{mid}$，并且我们是按照**列优先**的顺序连续填写 $x$ 的，而一共有 $\textit{mid}$ 行，因此不会有某一行出现超过一个 $x$。

这样一来，我们只需要判断所有 $\textit{occ}(x)$ 的和与 $\textit{mid} \times n$ 的大小关系，就可以在二分查找的过程中调整区间的边界了。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    long long maxRunTime(int n, vector<int>& batteries) {
        long long left = 0, right = accumulate(batteries.begin(), batteries.end(), 0LL) / n, ans = 0;
        while (left <= right) {
            long long mid = (left + right) / 2;
            long long total = 0;
            for (int cap: batteries) {
                total += min(static_cast<long long>(cap), mid);
            }
            if (total >= n * mid) {
                ans = mid;
                left = mid + 1;
            }
            else {
                right = mid - 1;
            }
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxRunTime(self, n: int, batteries: List[int]) -> int:
        left, right, ans = 0, sum(batteries) // n, 0
        while left <= right:
            mid = (left + right) // 2
            total = 0
            for cap in batteries:
                total += min(cap, mid)
            if total >= n * mid:
                ans = mid
                left = mid + 1
            else:
                right = mid - 1
        return ans
```

**复杂度分析**

- 时间复杂度：$O(n \log C)$。其中 $C$ 是数组 $\textit{batteries}$ 中所有元素的和，在本题中 $C$ 不超过 $10^5 \times 10^9 = 10^{14}$。

- 空间复杂度：$O(1)$。
## [2226.每个小孩最多能分到多少糖果 中文官方题解](https://leetcode.cn/problems/maximum-candies-allocated-to-k-children/solutions/100000/mei-ge-xiao-hai-zui-duo-neng-fen-dao-duo-2717)
#### 方法一：二分查找转化为判定问题

**提示 $1$**

当每个小孩拿走的糖果数目增大时，现有糖果可以满足的小孩数目**不会增大**。

**思路与算法**

根据 **提示 $1$**，如果 $k$ 个小孩每人可以按要求拿到 $i$ 个糖果，那么它们一定可以按要求拿到闭区间 $[0, i]$ 内任一整数数量的糖果。这也就说明「$k$ 个小孩每人能否按要求拿到 $i$ 个糖果」这一**判定问题**对于 $i$ 具有**二值性**。因此我们可以通过二分查找确定使得该判定问题成立的**最大**的 $i$。

我们可以引入辅助函数 $\textit{check}(i)$ 来判断对应的判定问题是否成立。具体地，我们用 $\textit{res}$ 来维护最多可以按要求拿到 $i$ 个糖果的小孩数目。我们遍历 $\textit{candies}$ 数组，对于数组的每个元素 $c$，对应数量该堆糖果最多可以分给 $\lfloor c / i \rfloor$ 个小孩（其中 $\lfloor \dots \rfloor$ 代表向下取整），则我们将 $\textit{res}$ 加上该数值。最终，我们通过判断 $\textit{res}$ 是否大于等于 $k$ 来判断对应的判定问题是否成立。

而对于二分查找的上界，我们可以通过糖果数量进行估计。具体地，由于每个小孩至多可以拿走一堆糖果，因此每个小孩可以拿走的糖果数目不会超过最多一堆糖果的数量。

**细节**

对于二分查找的下界，如果设置为 $0$，则在上文的未经修改的 $\textit{check}(i)$ 函数中，会出现除数为零的问题。此时我们有两种解决方案：

1. 将二分查找下界设置为 $1$，通过二分查找计算**最小的无法满足需求**的 $i$，此时每个小孩可分到的最大糖果数目即为 $i - 1$；

2. 由于 $i = 0$ 时一定可以满足 $k$ 个小孩的要求，因此我们直接对于此种情况返回 $\texttt{true}$ 即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximumCandies(vector<int>& candies, long long k) {
        // 判断每个小孩分到 i 个糖果时是否可以满足要求
        auto check = [&](int i) -> bool {
            long long res = 0;
            for (int c: candies) {
                res += c / i;
            }
            return res >= k;
        };

        // 二分查找
        int l = 1;
        int r = 1 + *max_element(candies.begin(), candies.end());
        while (l < r) {
            int mid = l + (r - l) / 2;
            if (check(mid)) {
                l = mid + 1;
            } else {
                r = mid;
            }
        }
        return l - 1;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def maximumCandies(self, candies: List[int], k: int) -> int:
        # 判断每个小孩分到 i 个糖果时是否可以满足要求
        def check(i: int) -> bool:
            res = 0
            for c in candies:
                res += c // i
            return res >= k

        # 二分查找
        l = 1
        r = max(candies) + 1
        while l < r:
            mid = l + (r - l) // 2
            if check(mid):
                l = mid + 1
            else:
                r = mid
        return l - 1
```


**复杂度分析**

- 时间复杂度：$O(n \log M)$，其中 $n$ 为数组 $\textit{candies}$ 的长度，$M = \max(\textit{candies})$，即二分查找的上界。我们总共需要 $O(\log M)$ 次二分查找，每次需要 $O(n)$ 的时间计算每人的糖果数量是否符合要求。

- 空间复杂度：$O(1)$。
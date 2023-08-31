## [2144.打折购买糖果的最小开销 中文官方题解](https://leetcode.cn/problems/minimum-cost-of-buying-candies-with-discount/solutions/100000/da-zhe-gou-mai-tang-guo-de-zui-xiao-kai-yns06)

#### 方法一：贪心

**提示 $1$**

我们采用如下的策略，可以使得购买糖果的总开销最小：

将糖果价格**从高到低**排序，然后按照每 $3$ 个分成一组，花钱购买前两个，赠送第三个。

**提示 $1$ 解释**

我们假设糖果数量为 $n$，那么最多可以赠送的糖果数量为 $\lfloor n / 3 \rfloor$，**提示 $1$** 的方法中，赠送糖果的数量与这个上界相等。那么，我们可以将证明分为两部分：

1. 开销最小的购买方案一定是赠送数量最多的方案；
2. **提示 $1$** 的购买方案一定是赠送数量最多的方案中最优的。

对于第一部分，任意一个赠送糖果数量少于 $\lfloor n / 3 \rfloor$ 的方案，都一定可以找到**至少三个**未被分组的糖果，对于这三个糖果，一定可以使得价格最低的糖果免费。因此命题 $1$ 成立。

对于第二部分，我们不妨假设 $\textit{cost}$ 数组已经按照价格降序排序，根据定义，免费获得糖果中**价格最高的一定不大于 $\textit{cost}[2]$**（假设该下标存在，下同）。类似地，我们可以得出，价格第 $k (0 \le k \le \lfloor n / 3 \rfloor)$ 高的糖果的价格一定不大于 $\textit{cost}[3k+2]$。

而**提示 $1$** 的方案中，所有的不等式均取了等号，同时考虑到免费糖果数量一定，因此命题 $2$ 成立。

综上，我们可以得出，**提示 $1$** 的购买方案是开销最小的。

**思路与算法**

根据 **提示 $1$**，我们首先将糖果价格数组 $\textit{cost}$ **从高到低**排序，此时**免费获得所有下标模 $3$ 余 $2$ 的糖果**的方案开销最小。随后我们遍历数组计算总开销，在计算时我们需要跳过这些免费获得的糖果。最终，我们将总开销返回作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumCost(vector<int>& cost) {
        sort(cost.begin(), cost.end(), greater<int>());
        int res = 0;
        int n = cost.size();
        for (int i = 0; i < n; ++i) {
            if (i % 3 != 2) {
                res += cost[i];
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def minimumCost(self, cost: List[int]) -> int:
        cost.sort(key = lambda x: -x)
        res = 0
        n = len(cost)
        for i in range(n):
            if i % 3 != 2:
                res += cost[i]
        return res
```


**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为 $\textit{cost}$ 的长度。即为对糖果按照价格排序的时间复杂度。

- 空间复杂度：$O(\log n)$，即为排序的栈空间开销。
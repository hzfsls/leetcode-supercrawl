## [1962.移除石子使总数最小 中文官方题解](https://leetcode.cn/problems/remove-stones-to-minimize-the-total/solutions/100000/yi-chu-shi-zi-shi-zong-shu-zui-xiao-by-l-9lsg)
#### 方法一：最大堆（优先队列）

**提示 $1$**

为了使得操作后剩下的石头最小，我们需要在每次操作时尽可能多地移除石子，即选择石子数量**最多**的一堆进行操作。

**提示 $1$ 解释**

我们假设某一步操作没有选择石子数量最多的一堆（记为第 $\textit{opt}$ 堆）进行操作，而是选择了第 $i$ 堆，那么后续可能有两种情况：

- 第一种，如果后续的某一步中选择了第 $\textit{opt}$ 堆，那么我们可以交换这两步的操作，最终剩余的石子数目不变；

- 第二种，如果后续没有移除过第 $\textit{opt}$ 堆的石子，那么将从当前开始到结束为止所有选择第 $i$ 堆的操作全部换成第 $\textit{opt}$ 堆，总移除的石子数目也不会减少。

因此，每次选择石子数量最多的一堆进行操作是最优的。

**思路与算法**

根据 **提示 $1$**，每一次「移除石子」的操作可以被拆分为两个部分：

- 从石子堆中**寻找到**最大值；

- 将该值进行修改。

假设石子堆**数组** $\textit{piles}$ 的长度为 $n$，那么单次操作的时间复杂度为 $O(n)$，无法通过本题。因此我们可以将「移除石子」操作的两个部分进行如下修改：

- 从石子堆中**记录并弹出**最大值；

- 将该值进行修改，并**重新添加**至石子堆中。

同时寻找一个可以在较好的时间复杂度下实现「查询并移除最大值」与「插入元素」的数据结构。

我们可以用一个**最大堆**实现的优先队列来维护石子堆数组 $\textit{piles}$，它可以在 $O(\log n)$ 的时间复杂度下实现「查询并移除最大值」与「插入元素」这两个操作。

每一次操作时，我们首先记录并弹出 $\textit{piles}$ 中的最大值 $\textit{tmp}$，随后从中减去 $\lfloor \textit{tmp} / 2 \rfloor$（其中 $\lfloor \dots \rfloor$代表向下取整），并将修改后的值添加进 $\textit{piles}$ 中。当进行 $k$ 次操作后，我们计算 $\textit{piles}$ 中各元素之和，并返回作为答案。

需要注意的是，$\texttt{C++}$ 的二叉堆默认为**最大堆**，但$\texttt{Python}$ 的二叉堆默认为**最小堆**，因此我们需要将 $\textit{piles}$ 中的每个元素取相反数然后进行操作，并对求和后的结果再次取相反数作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minStoneSum(vector<int>& piles, int k) {
        // 生成最大堆
        make_heap(piles.begin(), piles.end());
        for (int i = 0; i < k; ++i){
            // 单次操作：记录并弹出最大值，修改后重新添加进堆
            pop_heap(piles.begin(), piles.end());
            piles.back() -= piles.back() / 2;
            push_heap(piles.begin(), piles.end());
        }
        return accumulate(piles.begin(), piles.end(), 0);
    }
};
```


```Python [sol1-Python3]
import heapq

class Solution:
    def minStoneSum(self, piles: List[int], k: int) -> int:
        n = len(piles)
        # 生成最大堆
        for i in range(n):
            piles[i] = -piles[i]
        heapq.heapify(piles)
        for i in range(k):
            # 单次操作：记录并弹出最大值，修改后重新添加进堆
            tmp = heapq.heappop(piles)
            heapq.heappush(piles, tmp + (-tmp) // 2)
        return -sum(piles)
```


**复杂度分析**

- 时间复杂度：$O(n + k\log n)$，其中 $n$ 为 $\textit{piles}$ 的长度。建堆与计算结果的复杂度为 $O(n)$；每次弹出最大值与添加新值的时间复杂度为 $O(\log n)$，共需进行 $k$ 次。

- 空间复杂度：$O(1)$。
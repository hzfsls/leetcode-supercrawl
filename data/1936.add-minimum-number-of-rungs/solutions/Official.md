## [1936.新增的最少台阶数 中文官方题解](https://leetcode.cn/problems/add-minimum-number-of-rungs/solutions/100000/xin-zeng-de-zui-shao-tai-jie-shu-by-leet-y0de)

#### 方法一：模拟 + 贪心

**思路与算法**

我们可以模拟爬台阶的过程。

每当计划爬上新一级台阶时，需要增设的台阶数目可以表示为当前位置与新一级台阶位置（目标位置）的高度差的函数。假设高度差为 $d\ (> 0)$，可直接到达的两个台阶的**最大间隔**为 $\textit{dist}$。此时我们可以判断 $d$ 与 $\textit{dist}$ 的大小来判断是否需要新增台阶。

如果 $d \le \textit{dist}$，此时无需新增台阶。如果 $d > \textit{dist}$，此时无法直接到达，我们可以每隔 $\textit{dist}$ 高度插入新台阶，直至新台阶与目标位置的间隔不大于$\textit{dist}$。显然，这种方案所需增设台阶数目最小，对应的需要增设台阶数目为 

$$
\left\lfloor \frac{d - 1}{\textit{dist}} \right\rfloor.
$$

上式当 $0 < d \le \textit{dist}$ 时为 $0$，与对应情况相符，因此实际计算时无需额外讨论 $d$ 与 $\textit{dist}$ 的大小关系。

由于台阶数组 $\textit{rungs}$ 严格递增，因此我们将当前高度初值设为 $0$，并按顺序遍历 $\textit{rungs}$ 数组以模拟爬台阶的过程。每当遍历到新一级台阶时，我们计算与当前位置的高度差，进而计算最少需要增设的台阶数目，并将当前高度更新为新一级台阶的高度。我们维护这些台阶数目的总和，并最终返回作为答案。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    int addRungs(vector<int>& rungs, int dist) {
        int res = 0;   // 需要增设的梯子数目
        int curr = 0;   // 当前高度
        for (int h: rungs){
            // 遍历数组计算高度差和最少添加数目，并更新当前高度
            int d = h - curr;
            res += (d - 1) / dist;
            curr = h;
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def addRungs(self, rungs: List[int], dist: int) -> int:
        res = 0   # 需要增设的梯子数目
        curr = 0   # 当前高度
        for h in rungs:
            # 遍历数组计算高度差和最少添加数目，并更新当前高度
            d = h - curr
            res += (h - curr - 1) // dist
            curr = h
        return res
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{rungs}$ 的长度。即为遍历数组计算需要增设台阶数目的时间复杂度。

- 空间复杂度：$O(1)$。
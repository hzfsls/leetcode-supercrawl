## [1887.使数组元素相等的减少操作次数 中文官方题解](https://leetcode.cn/problems/reduction-operations-to-make-the-array-elements-equal/solutions/100000/shi-shu-zu-yuan-su-xiang-deng-de-jian-sh-lt55)
#### 方法一：排序

**提示 $1$**

为了使得 $\textit{nums}$ 中所有元素相等，对于 $\textit{nums}$ 中的任意元素 $x$，在整个过程中它所需的操作次数等于**严格小于**它的**不同**值的数量。

**提示 $1$ 解释**

首先，为了使得 $\textit{nums}$ 中所有元素相等，我们需要将 $\textit{nums}$ 中的任意元素都变为 $\textit{nums}$ 中的**最小值**。

其次，考虑 $\textit{nums}$ 中的任意元素 $x$，每次操作（如有）只能将它变成严格小于它的元素中的最大值。为了将 $x$ 变为 $\textit{nums}$ 中的最小值，需要的操作次数即为**严格小于**它的**不同**值的数量。

**思路与算法**

我们用 $\textit{cnt}$ 统计每个元素所需的操作次数。根据 **提示 $1$**，$\textit{cnt}$ 等于严格小于每个元素的不同值的数量。为了方便统计，我们将 $\textit{nums}$ 升序排序，并从下标 $1$ 开始顺序遍历（$\textit{nums}[0]$ 一定为最小值故无需操作）。

我们将 $\textit{cnt}$ 的初值设置为 $0$，当遍历至下标 $i$ 时，我们比较 $\textit{nums}[i]$ 与 $\textit{nums}[i-1]$ 的大小关系，并更新 $\textit{cnt}$。此时有两种情况：

- 如果 $\textit{nums}[i] = \textit{nums}[i-1]$，此时 $\textit{nums}[i]$ 的操作次数与 $\textit{nums}[i-1]$ 相同，故 $\textit{cnt}$ 不变；

- 如果 $\textit{nums}[i] > \textit{nums}[i-1]$，此时 $\textit{nums}[i]$ 需要首先变为 $\textit{nums}[i-1]$ 才能进行后续操作，因此我们将 $\textit{cnt}$ 增加 $1$。

在遍历的同时，我们维护数组中每个元素的 $cnt$ 之和。遍历结束后，我们返回该值，即为使数组所有元素相等所需的总操作次数。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int reductionOperations(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        int n = nums.size();
        int res = 0;   // 总操作次数
        int cnt = 0;   // 每个元素操作次数
        for (int i = 1; i < n; ++i) {
            if (nums[i] != nums[i-1]){
                ++cnt;
            }
            res += cnt;
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def reductionOperations(self, nums: List[int]) -> int:
        nums.sort()
        n = len(nums)
        res = 0   # 总操作次数
        cnt = 0   # 每个元素操作次数
        for i in range(1, n):
            if nums[i] != nums[i-1]:
                cnt += 1
            res += cnt
        return res
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。排序数组的时间复杂度为 $O(n\log n)$，遍历数组维护操作次数与总操作次数的时间复杂度为 $O(n)$。

- 空间复杂度：$O(\log n)$，即为排序的栈空间开销。
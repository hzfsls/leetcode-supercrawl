## [2099.找到和最大的长度为 K 的子序列 中文官方题解](https://leetcode.cn/problems/find-subsequence-of-length-k-with-the-largest-sum/solutions/100000/zhao-dao-he-zui-da-de-chang-du-wei-k-de-01ike)

#### 方法一：排序

**思路与算法**

数组 $\textit{nums}$ 中和最大的长度为 $K$ 的子序列一定是由 $\textit{nums}$ 中最大的 $K$ 个数组成的。为了使得排序寻找最大的 $K$ 个数后，还能按照它们在原数组  $\textit{nums}$ 中的顺序组成目标子序列，我们建立辅助数组 $\textit{vals}$，它的第 $i$ 个元素 $(i, \textit{nums}[i])$ 包含**下标** $i$ 本身，以及数组中的对应**数值** $\textit{nums}[i]$。

首先，我们将辅助数组按照原数组中的**数值** $\textit{nums}[i]$ 为关键字**降序**排序，排序后的前 $K$ 个元素对应原数组的数值即为原数组 $\textit{nums}$ 中最大的 $K$ 个数，对应的下标即为它们在 $\textit{nums}$ 中的下标。随后，我们将这 $K$ 个元素按照**下标** $i$ 为关键字**升序**排序，排序后的 $K$ 个数值保持了它们在原数组中的顺序，我们用新的数组顺序记录这些数值，该数组即为 $\textit{nums}$ 中和最大的长度为 $K$ 的子序列。我们返回该数组作为答案。


**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> maxSubsequence(vector<int>& nums, int k) {
        int n = nums.size();
        vector<pair<int, int>> vals;   // 辅助数组
        for (int i = 0; i < n; ++i) {
            vals.emplace_back(i, nums[i]);
        }
        // 按照数值降序排序
        sort(vals.begin(), vals.end(), [&](auto x1, auto x2) {
            return x1.second > x2.second;
        });
        // 取前 k 个并按照下标升序排序
        sort(vals.begin(), vals.begin() + k);
        vector<int> res;   // 目标子序列
        for (int i = 0; i < k; ++i) {
            res.push_back(vals[i].second);
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def maxSubsequence(self, nums: List[int], k: int) -> List[int]:
        n = len(nums)
        vals = [[i, nums[i]] for i in range(n)]   # 辅助数组
        # 按照数值降序排序
        vals.sort(key = lambda x: -x[1])
        # 取前 k 个并按照下标升序排序
        vals = sorted(vals[:k])
        res = [val for idx, val in vals]   # 目标子序列
        return res
```


**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为 $\textit{nums}$ 的长度。即为对辅助数组排序的时间复杂度。

- 空间复杂度：$O(n)$，即为辅助数组的空间开销。
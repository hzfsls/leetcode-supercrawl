## [1968.构造元素不等于两相邻元素平均值的数组 中文官方题解](https://leetcode.cn/problems/array-with-elements-not-equal-to-average-of-neighbors/solutions/100000/gou-zao-yuan-su-bu-deng-yu-liang-xiang-l-u6vz)
#### 方法一：排序

**思路与算法**

假设 $\textit{nums}$ 的长度为 $n$，由于 $\textit{nums}$ 中不含有数值相同的元素，因此我们一定可以将 $\textit{nums}$ 分成长度为 $m = \lfloor (n + 1) / 2 \rfloor$ 与长度为 $n - m$ 的两部分，其中第一部分的任何一个元素一定**小于**第二部分的任意一个元素。这也意味着，第一部分任意两个元素的平均值一定不会等于第二部分的任意一个元素，反之亦然。

那么，我们可以将数值较小的第一部分的元素放入重排数组的**偶数**下标（包含 $0$），并将数值较大的第二部分的元素放入重排数组的**奇数**下标，这样重排后的数组一定满足题目的要求。

本文中，我们将 $\textit{nums}$ 升序排序，然后依次将第一部分和第二部分的元素放入重排数组中，最终返回重排后的数组作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> rearrangeArray(vector<int>& nums) {
        // 将数组排序
        sort(nums.begin(), nums.end());
        int n = nums.size();
        int m = (n + 1) / 2;
        vector<int> res;
        for (int i = 0; i < m; ++i){
            // 放入数值较小的第一部分元素
            res.push_back(nums[i]);
            if (i + m < n){
                // （如果有）放入数值较大的第二部分元素
                res.push_back(nums[i + m]);
            }
        }
        return res;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def rearrangeArray(self, nums: List[int]) -> List[int]:
        # 将数组排序
        nums.sort()
        n = len(nums)
        m = (n + 1) // 2
        res = []
        for i in range(m):
            # 放入数值较小的第一部分元素
            res.append(nums[i])
            if i + m < n:
                # （如果有）放入数值较大的第二部分元素
                res.append(nums[i + m])
        return res
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 为 $\textit{nums}$ 的长度。即为排序数组的时间复杂度。

- 空间复杂度：$O(1)$，输出数组不计入空间复杂度。
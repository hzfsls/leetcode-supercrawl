## [1913.两个数对之间的最大乘积差 中文官方题解](https://leetcode.cn/problems/maximum-product-difference-between-two-pairs/solutions/100000/liang-ge-shu-dui-zhi-jian-de-zui-da-chen-1ksh)
#### 方法一：贪心

**思路与算法**

由于 $\textit{nums}$ 中的元素均为正整数，因此任意数对的乘积均为正整数。那么 $\textit{nums}$ 中的最大数对乘积即为数组中最大两个元素 $\textit{mx}_1$ 与 $\textit{mx}_2$ 的乘积；同理，最小数对乘积即为数组中最小两个元素 $\textit{mn}_1$ 与 $\textit{mn}_2$ 的乘积。

同时，由于 $\textit{nums}$ 中的元素个数大于等于 $4$ 个，因此这四个元素的下标一定互不相同。那么，$\textit{nums}$ 中两个数对之间的乘积差最大值即为 $(\textit{mx}_1 \times \textit{mx}_2) - (\textit{mn}_1 \times \textit{mn}_2)$。

我们可以通过对数组 $\textit{nums}$ 的一次遍历，找到对应的四个元素，进而计算出两个数对之间的乘积差最大值。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxProductDifference(vector<int>& nums) {
        int n = nums.size();
        // 数组中最大的两个值
        int mx1 = max(nums[0], nums[1]);
        int mx2 = min(nums[0], nums[1]);
        // 数组中最小的两个值
        int mn1 = min(nums[0], nums[1]);
        int mn2 = max(nums[0], nums[1]);
        for (int i = 2; i < n; ++i){
            int tmp = nums[i];
            if (tmp > mx1){
                mx2 = mx1;
                mx1 = tmp;
            }
            else if (tmp > mx2){
                mx2 = tmp;
            }
            if (tmp < mn1){
                mn2 = mn1;
                mn1 = tmp;
            }
            else if (tmp < mn2){
                mn2 = tmp;
            }
        }
        return (mx1 * mx2) - (mn1 * mn2);
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxProductDifference(self, nums: List[int]) -> int:
        n = len(nums)
        # 数组中最大的两个值
        mx1, mx2 = max(nums[0], nums[1]), min(nums[0], nums[1])
        # 数组中最小的两个值
        mn1, mn2 = min(nums[0], nums[1]), max(nums[0], nums[1])
        for i in range(2, n):
            tmp = nums[i]
            if tmp > mx1:
                mx1, mx2 = tmp, mx1
            elif tmp > mx2:
                mx2 = tmp
            if tmp < mn1:
                mn1, mn2 = tmp, mn1
            elif tmp < mn2:
                mn2 = tmp
        return (mx1 * mx2) - (mn1 * mn2)
```

**复杂度分析**

- 时间复杂度：$O(n)$，即为遍历 $\textit{nums}$ 寻找四个目标值的时间复杂度。

- 空间复杂度：$O(1)$。
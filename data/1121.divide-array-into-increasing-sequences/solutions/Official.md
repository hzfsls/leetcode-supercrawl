## [1121.将数组分成几个递增序列 中文官方题解](https://leetcode.cn/problems/divide-array-into-increasing-sequences/solutions/100000/jiang-shu-zu-fen-cheng-ji-ge-di-zeng-xu-lie-by-lee)
#### 方法一：最大值

**思路**

题目要求将数组分成一个或几个长度至少为 `k` 的不相交的递增子序列。

首先假设将数组分成 `n` 个子序列，每个子序列的长度为 `k`。根据题意，每一个子序列都是严格递增的，也就是说每个子序列没有相同的数字，所以需要统计每个数字的个数并找到最多的那一个的个数 `t`。需要把这 `t` 个数字分配到 `n` 个子序列中且不能分配到相同的子序列，所以 `n >= t`。

其次因为所有数字出现次数最多为 `t`，其他数字出现的次数一定小于等于 `t`。那么他们一定可以分配到 `n` 个不同的子序列中。如果 `n` 无限大很有可能每个子序列的数量小于 `k`，所以 `n` 应该越小越好。当 `n = t` 的时候可以取到最小值，又因为题目要求长度至少为 `k`，此时长度的总和为 `t * k`，此时只需要保证这个长度小于等于整个数组的长度，就能满足题目的要求。

**时空间优化**

当需要统计每个数组的个数的时候，很自然的就会想到使用哈希表，又快又方便。但是本题还有一个信息我们没有用到，那就是**非递减的正整数数组**，所以我们完全不需要使用哈希表。根据非递减的特性，我们可以使用一个 `pre` 变量记录上一个值并记录 `pre` 对应的值的个数。当 `pre != nums[i]` 时，说明上一个数统计完了，就可以进行比较了。所以只需要一次遍历并且不需要额外的空间记录没用的数据。

**代码**

```Golang [sol1-Golang]
func canDivideIntoSubsequences(nums []int, k int) bool {
    if k == 1 {
        return true
    }
    pre := nums[0]
    cnt := 0
    for i := 0; i < len(nums); i++ {
        if pre == nums[i] {
            cnt++
        } else {
            if cnt * k > len(nums) {
                return false
            }
            pre = nums[i]
            cnt = 1
        }
    }
    return cnt * k <= len(nums)
}
```

```Python [sol1-Python3]
class Solution:
    def canDivideIntoSubsequences(self, nums: List[int], k: int) -> bool:
        pre = nums[0]
        cnt = 0
        for n in nums:
            if pre == n:
                cnt += 1
            else:
                pre = n
                cnt = 1
            if cnt * k > len(nums):
                return False
        return True
```

```C++ [sol1-C++]
class Solution {
public:
    bool canDivideIntoSubsequences(vector<int>& nums, int k) {
        int pre = nums[0], cnt = 0;
        for (int n : nums) {
            if (n == pre)
                ++cnt;
            else {
                pre = n;
                cnt = 1;
            }
            if (cnt * k > nums.size())
                return false;
        }
        return true;
    }
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，最慢遍历一次数组。其中 $n$ 为数组 `nums` 的长度。

- 空间复杂度：$O(1)$，没有使用额外的空间。
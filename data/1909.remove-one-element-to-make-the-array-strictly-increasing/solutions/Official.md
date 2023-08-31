## [1909.删除一个元素使数组严格递增 中文官方题解](https://leetcode.cn/problems/remove-one-element-to-make-the-array-strictly-increasing/solutions/100000/shan-chu-yi-ge-yuan-su-shi-shu-zu-yan-ge-tnr7)

#### 方法一：寻找非递增相邻下标对

**思路与算法**

数组 $\textit{nums}$ 严格递增的**充分必要条件**是对于任意两个相邻下标对 $(i - 1, i)$ 均有 $\textit{nums}[i] > \textit{nums}[i-1]$。换言之，如果存在下标 $i$ 有 $\textit{nums}[i] \le \textit{nums}[i-1]$，那么 $\textit{nums}$ 并非严格递增。

因此，我们可以从左至右遍历寻找非递增的相邻下标对。假设对于某个下标对 $(i - 1, i)$ 有 $\textit{nums}[i] \le \textit{nums}[i-1]$，如果我们想使得 $\textit{nums}$ 在删除一个元素后严格递增，那么必须至少删除下标对 $(i - 1, i)$ 对应的元素之一。

我们可以用 $\textit{check}(\textit{idx})$ 函数来检查数组 $\textit{nums}$ 删去下标为 $\textit{idx}$ 的元素后是否严格递增。具体地，我们对 $\textit{nums}$ 进行一次遍历，在遍历的过程中记录上一个元素的下标，并与当前遍历到的元素进行比较。需要注意的是，下标为 $\textit{idx}$ 的元素需要被跳过。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool canBeIncreasing(vector<int>& nums) {
        int n = nums.size();
        // 检查数组 nums 在删去下标为 idx 的元素后是否严格递增
        auto check = [&](const int idx) -> bool{
            for (int i = 1; i < n - 1; ++i){
                int prev = i - 1;
                if (prev >= idx){
                    ++prev;
                }
                int curr = i;
                if (curr >= idx){
                    ++curr;
                }
                if (nums[curr] <= nums[prev]){
                    return false;
                }
            }
            return true;
        };

        for (int i = 1; i < n; ++i){
            // 寻找非递增相邻下标对
            if (nums[i] <= nums[i-1]){
                return check(i - 1) || check(i);
            }
        }
        return true;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def canBeIncreasing(self, nums: List[int]) -> bool:
        n = len(nums)
        # 检查数组 nums 在删去下标为 idx 的元素后是否严格递增
        def check(idx: int) -> bool:
            for i in range(1, n - 1):
                prev, curr = i - 1, i
                if prev >= idx:
                    prev += 1
                if curr >= idx:
                    curr += 1
                if nums[curr] <= nums[prev]:
                    return False
            return True
        
        for i in range(1, n):
            # 寻找非递增相邻下标对
            if nums[i] <= nums[i-1]:
                return check(i) or check(i - 1)
        return True
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度。遍历数组寻找非递增下标对的最坏时间复杂度为 $O(n)$，执行一次 $\textit{check}(\textit{idx})$ 函数的时间复杂度为 $O(n)$，而我们至多会执行两次 $\textit{check}(\textit{idx})$ 函数。

- 空间复杂度：$O(1)$。
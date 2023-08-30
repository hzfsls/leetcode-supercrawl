**方法一：二分查找**

假设我们选择了除数 `d`，当 `d` 增加时，正整数数组 `nums` 中的每个数 `num[i]` 除以 `d` 的结果 `num[i] / d` 单调递减，它们的和 `total` 同样也单调递减。

根据上述的单调性，我们就可以使用二分查找的方法，找出满足 `total <= threshold` 的最小除数 `d`。具体地，假设我们当前在二分查找的区间 `[l, r]` 中选择了除数 `d'`，并计算出了对应的 `total'`，此时会出现两种情况：

- 如果 `total' > threshold`，那就说明我们选择的 `d'` 不满足要求。根据单调性，减小 `d'` 的值会增大 `total'` 的值，那么区间 `[l, d']` 中不可能存在满足要求的除数，因此我们可以在区间 `(d', r]` 中继续进行二分查找。

- 如果 `total' <= threshold`，那就说明我们选择的 `d'` 满足要求。由于题目中要求除数尽可能小，因此我们可以忽略区间 `(d', r]`，而在区间 `[l, d')` 中继续进行二分查找。

这样我们就可以方便地使用二分查找得出最优解。

那么如何确定二分查找的上下限呢？显然，二分查找的下限是 `1`，这是最小的正整数。而二分查找的上限可以设置为数组 `nums` 中的最大值 `M`，这是因为当除数 `d >= M` 时，数组 `nums` 中的每个数除以 `d` 的结果均为 `1`，`total` 的值恒等于数组 `nums` 的长度。由于题目中要求除数尽可能小，那么选择除数 `d = M` 一定比 `d > M` 更优。因此，将二分查找的上限设置为 `M`，可以保证不遗漏最优解。

```C++ [sol1]
class Solution {
public:
    int smallestDivisor(vector<int>& nums, int threshold) {
        int l = 1, r = *max_element(nums.begin(), nums.end());
        int ans = -1;
        while (l <= r) {
            int mid = (l + r) / 2;
            int total = 0;
            for (int num: nums) {
                total += (num - 1) / mid + 1;
            }
            if (total <= threshold) {
                ans = mid;
                r = mid - 1;
            }
            else {
                l = mid + 1;
            }
        }
        return ans;
    }
};
```

```Python [sol1]
class Solution:
    def smallestDivisor(self, nums: List[int], threshold: int) -> int:
        l, r, ans = 1, max(nums) + 1, -1
        while l <= r:
            mid = (l + r) // 2
            total = sum((x - 1) // mid + 1 for x in nums)
            if total <= threshold:
                ans = mid
                r = mid - 1
            else:
                l = mid + 1
        return ans
```

**复杂度分析**

- 时间复杂度：$O(N\log C)$，其中 $C$ 是一个常数，为二分查找的上下限之差。在本题给定的数据范围的限制下，$C$ 不会超过 $10^6$。

- 空间复杂度：$O(1)$。
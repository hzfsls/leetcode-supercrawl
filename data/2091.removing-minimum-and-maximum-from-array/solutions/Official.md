#### 方法一：分类讨论

**思路与算法**

我们首先遍历数组，寻找到最大值与最小值对应的下标。为了方便起见，我们将两个下标中较小的记为 $l$，较大的记为 $r$。假设数组长度为 $n$，这两个下标将数组 $\textit{nums}$ 的其余部分分割成了三个互不相交的子数组（可能包含空数组），它们分别是 $\textit{nums}[0..l-1], \textit{nums}[l+1..r-1], \textit{nums}[r+1..n-1]$ （其中 $[a..b]$ 为闭区间）。

由于我们只能从数组首尾移除元素，因此移除最大值和最小值后的子数组一定为上述三块中某一块的**子数组**。因此如果想使得删除次数最小，那么移除完成后的子数组一定**恰好为上述三个子数组之一**，对应的删除次数即为数组长度 $n$ 减去该子数组长度的差值。具体地：

- 移除完成后的子数组为 $\textit{nums}[0..l-1]$，此时删除次数为 $n - l$；

- 移除完成后的子数组为 $\textit{nums}[l+1..r-1]$，此时删除次数为 $l + 1 + n - r$；

- 移除完成后的子数组为 $\textit{nums}[r+1..n-1]$，此时删除次数为 $r + 1$。

而这三个差值的最小值即为最小的删除次数。我们返回该值作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumDeletions(vector<int>& nums) {
        int n = nums.size();
        int minidx = min_element(nums.begin(), nums.end()) - nums.begin();
        int maxidx = max_element(nums.begin(), nums.end()) - nums.begin();
        int l = min(minidx, maxidx);   // 最值下标中的较小值
        int r = max(minidx, maxidx);   // 最值下标中的较大值
        return min({r + 1, n - l, l + 1 + n - r});   // 计算三种情况下删除次数的最小值
    }
};
```


```Python [sol1-Python3]
class Solution:
    def minimumDeletions(self, nums: List[int]) -> int:
        minidx = nums.index(min(nums))
        maxidx = nums.index(max(nums))
        l = min(minidx, maxidx)   # 最值下标中的较小值
        r = max(minidx, maxidx)   # 最值下标中的较大值
        n = len(nums)
        return min(r + 1, n - l, l + 1 + n - r)   # 计算三种情况下删除次数的最小值
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为 $\textit{nums}$ 的长度。即为计算最小删除次数的时间复杂度。

- 空间复杂度：$O(1)$。
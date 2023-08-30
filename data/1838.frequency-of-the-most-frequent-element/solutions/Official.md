#### 方法一：排序 + 滑动窗口

**提示 $1$**

操作后的最高频元素必定可以是数组中已有的某一个元素。

**提示 $1$ 解释**

我们用 $x_i$ 来表示 $nums$ 数组中下标为 $i$ 的元素。

如果可以将数组内的一系列元素 ${x_i}_1,\dots,{x_i}_k$ 全部变为 $y$，假设这些元素中的最大值为 $x$，那么我们一定可以将这些数全部变成 $x$，此时频数不变且操作次数更少。

**提示 $2$**

优先操作距离目标值最近的（小于目标值的）元素。

**提示 $2$ 解释**

假设目标值为 $y$，对于数组内任意两个小于 $y$ 的元素 $x_i < x_j$，将较大者（$x_j$）变为 $y$ 所需要的操作数为 $y - x_j$，而对应改变较小者（$x_i$）做需要的操作数为 $y - x_i$，显然有 $y - x_j < y - x_i$。

**提示 $3$**

遍历数组中的每个元素作为目标值并进行尝试。此处是否存在一些可以用于优化算法的性质？

**思路与算法**

我们可以按照提示 $1$ 与提示 $2$ 的贪心策略进行操作。

将数组排序，遍历排序后数组每个元素 $x_r$ 作为目标值，并求出此时按贪心策略可以改变至目标值的元素左边界。

此时考虑到数据范围为 $10^5$，朴素的线性查找显然会超时，因此需要寻找可以优化的性质。

我们可以枚举 $x_r$ 作为目标值。假设 $x_r$ 对应的答案左边界为 $x_l$，定义 $\Delta(l, r)$ 为将 $x_l,\dots,x_r$ 全部变为 $x_r$ 所需要的操作次数：

$$
\Delta(l, r) =  \sum_{i = l}^{r} (x_r - x_i) = (r - l)x_r - \sum_{i = l}^{r-1} x_i.
$$

考虑右边界 $r$ 右移至 $r + 1$ 的过程，此时：

$$
\Delta(l, r + 1) - \Delta(l, r) = (x_{r + 1} - x_{r})\cdot(r - l + 1) \ge 0.
$$

操作数有可能超过限制 $k$，因此在超过限制的情况下，我们需要移动左边界 $l$。同样考虑左边界 $l$ 右移至 $l + 1$ 的过程，此时:

$$
\Delta(l + 1, r + 1) - \Delta(l, r + 1) = -(x_{r + 1} - x_{l}) \le 0.
$$

这说明右移左边界会使得答案减小，因此我们需要移动左边界直至对应的 $\Delta(l', r + 1)$ 不大于 $k$。

我们使用 $l$ 与 $r$ 作为执行操作的左右边界（闭区间），同时用 $\textit{total}$ 来维护将 $[l, r]$ 区间全部变为末尾元素的操作次数。在顺序枚举目标值（右边界）的同时，我们更新对应的左边界，并用 $\textit{res}$ 来维护满足限制的最大区间元素数量即可。

另外要注意，此处 $\textit{total}$ 有可能会超过 $32$ 位整数的范围，因此在 $\texttt{C++}$ 等语言中需要使用更高位数的整型变量（$\texttt{long long}$ 等）。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maxFrequency(vector<int>& nums, int k) {
        sort(nums.begin(), nums.end());
        int n = nums.size();
        long long total = 0;
        int l = 0, res = 1;
        for (int r = 1; r < n; ++r) {
            total += (long long)(nums[r] - nums[r - 1]) * (r - l);
            while (total > k) {
                total -= nums[r] - nums[l];
                ++l;
            }
            res = max(res, r - l + 1);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxFrequency(int[] nums, int k) {
        Arrays.sort(nums);
        int n = nums.length;
        long total = 0;
        int l = 0, res = 1;
        for (int r = 1; r < n; ++r) {
            total += (long) (nums[r] - nums[r - 1]) * (r - l);
            while (total > k) {
                total -= nums[r] - nums[l];
                ++l;
            }
            res = Math.max(res, r - l + 1);
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxFrequency(int[] nums, int k) {
        Array.Sort(nums);
        int n = nums.Length;
        long total = 0;
        int l = 0, res = 1;
        for (int r = 1; r < n; ++r) {
            total += (long) (nums[r] - nums[r - 1]) * (r - l);
            while (total > k) {
                total -= nums[r] - nums[l];
                ++l;
            }
            res = Math.Max(res, r - l + 1);
        }
        return res;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxFrequency(self, nums: List[int], k: int) -> int:
        nums.sort()
        n = len(nums)
        l = 0
        total = 0
        res = 1
        for r in range(1, n):
            total += (nums[r] - nums[r - 1]) * (r - l)
            while total > k:
                total -= nums[r] - nums[l]
                l += 1
            res = max(res, r - l + 1)
        return res
```

```JavaScript [sol1-JavaScript]
var maxFrequency = function(nums, k) {
    nums.sort((a, b) => a - b);
    const n = nums.length;
    let total = 0, res = 1, l = 0;

    for (let r = 1; r < n; r++) {
        total += (nums[r] - nums[r - 1]) * (r - l);
        while (total > k) {
            total -= nums[r] - nums[l];
            l += 1;
        }
        res = Math.max(res, r - l + 1);
    }
    return res;
};
```

```go [sol1-Golang]
func maxFrequency(nums []int, k int) int {
    sort.Ints(nums)
    ans := 1
    for l, r, total := 0, 1, 0; r < len(nums); r++ {
        total += (nums[r] - nums[r-1]) * (r - l)
        for total > k {
            total -= nums[r] - nums[l]
            l++
        }
        ans = max(ans, r-l+1)
    }
    return ans
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol1-C]
int cmp(int *a, int *b) {
    return *a - *b;
}

int maxFrequency(int *nums, int numsSize, int k) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int n = numsSize;
    long long total = 0;
    int l = 0, res = 1;
    for (int r = 1; r < n; ++r) {
        total += (long long)(nums[r] - nums[r - 1]) * (r - l);
        while (total > k) {
            total -= nums[r] - nums[l];
            ++l;
        }
        res = fmax(res, r - l + 1);
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n\log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。排序数组的时间复杂度为 $O(n\log n)$，使用滑动窗口遍历目标值的时间复杂度为 $O(n)$。

- 空间复杂度：$O(\log n)$，即为排序数组需要使用的栈空间。
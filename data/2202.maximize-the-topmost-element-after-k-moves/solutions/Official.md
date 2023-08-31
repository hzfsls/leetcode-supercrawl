## [2202.K 次操作后最大化顶端元素 中文官方题解](https://leetcode.cn/problems/maximize-the-topmost-element-after-k-moves/solutions/100000/k-ci-cao-zuo-hou-zui-da-hua-ding-duan-yu-s80c)

#### 方法一：枚举

**思路与算法**

我们不妨假设栈中初始元素的数量为 $n$。由于在每次操作中，我们可以弹出元素（非空），或在 $1$ 个或多个被弹出元素（如有）中任选一个重新添加回栈顶，我们可以对 $n$ 的大小分类讨论：

- $n = 1$，此时，我们每一步的操作是**确定的**，即奇数次操作将唯一的元素弹出栈，偶数次再加回。那么，当 $k$ 为偶数时，栈顶元素的最大值即为栈中唯一元素的数值，即 $\textit{nums}[0]$，我们返回该值作为答案；而当 $k$ 为奇数时，操作完栈为空，此时应返回 $-1$。

- $n > 1$，此时由操作方式不确定，因此枚举操作方式是不现实的，不过我们依旧可以分类讨论来枚举最终的栈顶元素。此时根据操作的类型又可以分为两种情况讨论：
  - 每次操作均**弹出**元素（此时要求 $n \ge k$），最终当取等号时栈为空，取大于号时，栈顶为 $\textit{nums}[k]$。
  - **至少有一次添加**操作，亦即至多 $k - 1$ 次弹出操作。由于越晚添加，理论可选的元素越多，因此我们**不妨假设最后一次为添加操作**。此时，下标位于 $[0, min(n - 1, k - 2)]$ 闭区间的元素都可以作为最终的栈顶元素在最后一次操作时被添加进栈。
  
  综上，这种情况下，在 $[0, k]$ 闭区间内除了 $k - 1$ 以外的所有**合法下标**都可以成为栈顶的元素。此时我们只需要计算这些元素的最大值并返回即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximumTop(vector<int>& nums, int k) {
        int n = nums.size();
        int res = -1;   // 最大的栈顶元素
        if (n == 1) {
            // n = 1 时若 k 为奇数则栈最终为空，此时返回 -1
            if (k % 2 == 0) {
                res = nums[0];
            }
        } else {
            for (int i = 0; i < min(n, k + 1); ++i) {
                if (i != k - 1) {
                    res = max(res, nums[i]);
                }
            }
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def maximumTop(self, nums: List[int], k: int) -> int:
        n = len(nums)
        res = -1   # 最大的栈顶元素
        if n == 1:
            # n = 1 时若 k 为奇数则栈最终为空，此时返回 -1
            if k % 2 == 0:
                return nums[0]
        else:
            for i in range(min(n, k + 1)):
                if i != k - 1:
                    res = max(res, nums[i])
        return res
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。即为枚举所有可能的栈顶元素并计算最大值的时间复杂度。

- 空间复杂度：$O(1)$。
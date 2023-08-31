## [1856.子数组最小乘积的最大值 中文官方题解](https://leetcode.cn/problems/maximum-subarray-min-product/solutions/100000/zi-shu-zu-zui-xiao-cheng-ji-de-zui-da-zh-rq8r)
#### 方法一：单调栈

**提示 $1$**

「最小乘积」的定义为「最小值」乘以「和」，由于「和」较难进行枚举，我们可以考虑枚举「最小值」。

**提示 $2$**

我们可以枚举数组中的每个元素 $\textit{nums}_i$ 作为最小值。

由于数组中的元素均为正数，那么我们选择的包含 $\textit{nums}_i$ 的子数组是越长越好的。

**提示 $2$ 解释**

我们选择子数组的限制只有一点，那就是「$\textit{nums}_i$ 必须是子数组中的最小值」。那么我们应当找到：

- 在 $\textit{nums}_i$「之前」且严格小于 $\textit{nums}_i$ 的元素，并且它离 $\textit{nums}_i$ 最近，该元素的下标记为 $\textit{left}_i$；

- 在 $\textit{nums}_i$「之后」且严格小于 $\textit{nums}_i$ 的元素，并且它离 $\textit{nums}_i$ 最近，该元素的下标记为 $\textit{right}_i$。

如果不存在这样的元素，那么对应的 $\textit{left}_i = -1$ 或 $\textit{right}_i = n$，其中 $n$ 是数组 $\textit{nums}$ 的长度。

此时，闭区间 $[\textit{left}_i+1, \textit{right}_i-1]$ 即为包含 $\textit{nums}_i$ 作为最小值且最长的子数组。

**提示 $3$**

我们可以使用单调栈来找出提示 $2$ 中每一个 $\textit{nums}_i$ 对应的 $\textit{left}_i$ 以及 $\textit{right}_i$。如果读者对「单调栈」不熟悉，或者不了解如何使用单调栈来求出这些值，可以先去尝试下面的两道题目：

- [496. 下一个更大元素 I](https://leetcode-cn.com/problems/next-greater-element-i/)
- [503. 下一个更大元素 II](https://leetcode-cn.com/problems/next-greater-element-ii/)

**提示 $4$**

最终的答案即为

$$
\max_{i=0}^{n-1} \left( \textit{nums}_i \times  \sum_{j=\textit{left}_i+1}^{\textit{right}_i-1} \textit{nums}_j \right)
$$

其中的求和项可以通过预处理 $\textit{nums}_j$ 的前缀和数组来快速求出。

**细节**

下面的代码部分与上面的叙述有一些小差异：

- 代码中的数组 $\textit{left}$ 和 $\textit{right}$ 存放的是所有的 $\textit{left}_i+1$ 以及 $\textit{right}_i-1$，这样做的目的是在使用前缀和时的代码更加易读；

- 我们可以使用两次单调栈分别求出严格遵守定义的 $\textit{left}_i$ 和 $\textit{right}_i$。而下面的代码中只使用了一次单调栈，其中 $\textit{left}_i$ 是严格遵守定义的，而 $\textit{right}_i$ 是「在 $\textit{nums}_i$ 之后且**小于等于** $\textit{nums}_i$ 并且离 $\textit{nums}_i$ 最近」的元素下标。
    这样的修改对答案是不会造成影响的：在严格遵守定义的条件下，答案对应的子数组中，每一个最小的元素都对应着正确的答案；而在 $\textit{right}_i$ 不严格遵守定义的条件下，答案对应的子数组中，只有最后一次出现的最小的元素对应着正确的答案。
    由于我们需要求出的是「最大值」，因此只要有一个位置对应着正确的答案，就是没有问题的。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    using LL = long long;
    static constexpr int mod = 1000000007;

public:
    int maxSumMinProduct(vector<int>& nums) {
        int n = nums.size();
        // 数组 left 初始化为 0，数组 right 初始化为 n-1
        // 设置为元素不存在时的特殊值
        vector<int> left(n), right(n, n - 1);
        // 单调栈
        stack<int> s;
        for (int i = 0; i < n; ++i) {
            while (!s.empty() && nums[s.top()] >= nums[i]) {
                // 这里的 right 是非严格定义的，right[i] 是右侧最近的小于等于 nums[i] 的元素下标
                right[s.top()] = i - 1;
                s.pop();
            }
            if (!s.empty()) {
                // 这里的 left 是严格定义的，left[i] 是左侧最近的严格小于 nums[i] 的元素下标
                left[i] = s.top() + 1;
            }
            s.push(i);
        }
        
        // 前缀和
        vector<LL> pre(n + 1);
        for (int i = 1; i <= n; ++i) {
            pre[i] = pre[i - 1] + nums[i - 1];
        }
        
        LL best = 0;
        for (int i = 0; i < n; ++i) {
            best = max(best, (pre[right[i] + 1] - pre[left[i]]) * nums[i]);
        }
        return best % mod;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maxSumMinProduct(self, nums: List[int]) -> int:
        mod = 10**9 + 7

        n = len(nums)
        # 数组 left 初始化为 0，数组 right 初始化为 n-1
        # 设置为元素不存在时的特殊值
        left, right = [0] * n, [n - 1] * n
        # 单调栈
        s = list()
        for i, num in enumerate(nums):
            while s and nums[s[-1]] >= num:
                # 这里的 right 是非严格定义的，right[i] 是右侧最近的小于等于 nums[i] 的元素下标
                right[s[-1]] = i - 1
                s.pop()
            if s:
                # 这里的 left 是严格定义的，left[i] 是左侧最近的严格小于 nums[i] 的元素下标
                left[i] = s[-1] + 1
            s.append(i)
        
        # 前缀和
        pre = [0]
        for i, num in enumerate(nums):
            pre.append(pre[-1] + num)
        
        best = max((pre[right[i] + 1] - pre[left[i]]) * num for i, num in enumerate(nums))
        return best % mod
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。计算数组 $\textit{left}$ 和 $\textit{right}$、前缀和以及答案都需要 $O(n)$ 的时间。

- 空间复杂度：$O(n)$，即为单调栈和前缀和数组需要使用的空间。
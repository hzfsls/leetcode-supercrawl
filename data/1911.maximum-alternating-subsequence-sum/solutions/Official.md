## [1911.最大子序列交替和 中文官方题解](https://leetcode.cn/problems/maximum-alternating-subsequence-sum/solutions/100000/zui-da-zi-xu-lie-jiao-ti-he-by-leetcode-epqrk)

#### 方法一：动态规划

**思路与算法**

我们将题目给出大小为 $n$ 的数组 $\textit{nums}$。现在我们需要返回 $\textit{nums}$ 中任意子序列的「最大交替和」，其中「最大交替和」定义为该序列偶数下标元素和减去奇数下标元素和（序列的下标从 $0$ 开始）。

设 $\textit{dp}[i][0]$ 和 $\textit{dp}[i][1]$ 分别为在 $\textit{nums}$ 的前缀 $\textit{nums}[0], \textit{nums}[1], \dots, \textit{nums}[i]$ 中选择一个子序列，并且选择的子序列的最后一个元素的下标为偶数和奇数的「最大交替和」。现在我们来思考如何进行状态转移。

- 对于 $\textit{dp}[i][0]$ 为以下两者中的较大值：
  - 若 $\textit{nums}[i]$ 被选择：$\textit{dp}[i][0] = \textit{dp}[i - 1][1] + \textit{nums}[i]$。
  - 否则：$\textit{dp}[i][0] = \textit{dp}[i - 1][0]$。
- 对于 $\textit{dp}[i][1]$ 为以下两者中的较大值：
  - 若 $\textit{nums}[i]$ 被选择：$\textit{dp}[i][1] = \textit{dp}[i - 1][0] - \textit{nums}[i]$。
  - 否则：$\textit{dp}[i][1] = \textit{dp}[i - 1][1]$。

以上的讨论都在 $i > 0$ 的基础上，当 $i = 0$ 时：$\textit{dp}[0][0] = \textit{nums}[0]$，$\textit{dp}[0][1] = 0$。
最终我们返回 $\textit{dp}[n - 1][0]$ 和 $\textit{dp}[n - 1][1]$ 中的较大值即可，又因为可以分析得到「最大交替和」一定不会为 $\textit{dp}[n - 1][1]$，因为最终选择的序列最后一个元素一定不可能位于奇数下标（因为奇数下标对应着减去该元素的值，我们可以不选择该元素）。所以最终返回 $\textit{dp}[n - 1][0]$ 即可。

因为 $\textit{dp}[i]$ 的求解只与 $\textit{dp}[i - 1]$ 有关，所以在实现的过程中我们可以通过「滚动数组」的方式来进行空间优化。

**代码**

```Python [sol1-Python3]
class Solution:
    def maxAlternatingSum(self, nums: List[int]) -> int:
        even, odd = nums[0], 0
        for i in range(1, len(nums)):
            even, odd = max(even, odd + nums[i]), max(odd, even - nums[i])
        return even
```

```Java [sol1-Java]
class Solution {
    public long maxAlternatingSum(int[] nums) {
        long even = nums[0], odd = 0;
        for (int i = 1; i < nums.length; i++) {
            even = Math.max(even, odd + nums[i]);
            odd = Math.max(odd, even - nums[i]);
        }
        return even;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    long long maxAlternatingSum(vector<int>& nums) {
        long long even = nums[0], odd = 0;
        for (int i = 1; i < nums.size(); i++) {
            even = max(even, odd + nums[i]);
            odd = max(odd, even - nums[i]);
        }
        return even;
    }
};
```

```C# [sol1-C#]
public class Solution {
    public long MaxAlternatingSum(int[] nums) {
        long even = nums[0], odd = 0;
        for (int i = 1; i < nums.Length; i++) {
            even = Math.Max(even, odd + nums[i]);
            odd = Math.Max(odd, even - nums[i]);
        }
        return even;
    }
}
```

```JavaScript [sol1-JavaScript]
var maxAlternatingSum = function(nums) {
    let even = nums[0], odd = 0;
    for (let i = 1; i < nums.length; i++) {
        even = Math.max(even, odd + nums[i]);
        odd = Math.max(odd, even - nums[i]);
    }
    return even;
};
```

```Go [sol1-Go]
func maxAlternatingSum(nums []int) int64 {
    even, odd := nums[0], 0
    for i := 1; i < len(nums); i++ {
        even = max(even, odd + nums[i])
        odd = max(odd, even - nums[i])
    }
    return int64(even)
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```C [sol1-C]
long long maxAlternatingSum(int* nums, int numsSize){
    long long even = nums[0], odd = 0;
    for (int i = 1; i < numsSize; i++) {
        even = fmax(even, odd + nums[i]);
        odd = fmax(odd, even - nums[i]);
    }
    return even;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。
- 空间复杂度：$O(1)$，在使用「滚动数组」优化后仅使用常量空间。
## [1749.任意子数组和的绝对值的最大值 中文官方题解](https://leetcode.cn/problems/maximum-absolute-sum-of-any-subarray/solutions/100000/ren-yi-zi-shu-zu-he-de-jue-dui-zhi-de-zu-qerr)
#### 方法一：动态规划 + 分情况讨论

**思路**

一个变量绝对值的最大值，可能是这个变量的最大值的绝对值，也可能是这个变量的最小值的绝对值。题目要求任意子数组和的绝对值的最大值，可以分别求出子数组和的最大值 $\textit{positiveMax}$ 和子数组和的最小值 $\textit{negativeMin}$，因为子数组可以为空，所以 $\textit{positiveMax} \geq 0 $，$\textit{negativeMin} \leq 0 $。最后返回 $\max(\textit{positiveMax}, -\textit{negativeMin})$ 即为任意子数组和的绝对值的最大值。

而求子数组和的最大值，可以参照[「53. 最大子数组和」](https://leetcode.cn/problems/maximum-subarray/)的解法，运用动态规划求解。而求子数组和的最小值，也是类似的思路，遍历时记录全局最小值 $\textit{negativeMin}$ 和当前子数组负数和并更新，遍历完即可得到子数组和的最小值。

**代码**

```Python [sol1-Python3]
class Solution:
    def maxAbsoluteSum(self, nums: List[int]) -> int:
        positiveMax, negativeMin = 0, 0
        positiveSum, negativeSum = 0, 0
        for n in nums:
            positiveSum += n
            positiveMax = max(positiveMax, positiveSum)
            positiveSum = max(0, positiveSum)
        
            negativeSum += n
            negativeMin = min(negativeMin, negativeSum)
            negativeSum = min(0, negativeSum)
        
        return max(positiveMax, -negativeMin)
```

```C++ [sol1-C++]
class Solution {
public:
    int maxAbsoluteSum(vector<int>& nums) {
        int positiveMax = 0, negativeMin = 0;
        int positiveSum = 0, negativeSum = 0;
        for (int num : nums) {
            positiveSum += num;
            positiveMax = max(positiveMax, positiveSum);
            positiveSum = max(0, positiveSum);
            negativeSum += num;
            negativeMin = min(negativeMin, negativeSum);
            negativeSum = min(0, negativeSum);
        }
        return max(positiveMax, -negativeMin);
    }
};
```

```C [sol1-C]
int maxAbsoluteSum(int* nums, int numsSize) {
    int positiveMax = 0, negativeMin = 0;
    int positiveSum = 0, negativeSum = 0;
    for (int i = 0; i < numsSize; i++) {
        positiveSum += nums[i];
        positiveMax = fmax(positiveMax, positiveSum);
        positiveSum = fmax(0, positiveSum);
        negativeSum += nums[i];
        negativeMin = fmin(negativeMin, negativeSum);
        negativeSum = fmin(0, negativeSum);
    }
    return fmax(positiveMax, -negativeMin);
}
```

```Java [sol1-Java]
class Solution {
    public int maxAbsoluteSum(int[] nums) {
        int positiveMax = 0, negativeMin = 0;
        int positiveSum = 0, negativeSum = 0;
        for (int num : nums) {
            positiveSum += num;
            positiveMax = Math.max(positiveMax, positiveSum);
            positiveSum = Math.max(0, positiveSum);
            negativeSum += num;
            negativeMin = Math.min(negativeMin, negativeSum);
            negativeSum = Math.min(0, negativeSum);
        }
        return Math.max(positiveMax, -negativeMin);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxAbsoluteSum(int[] nums) {
        int positiveMax = 0, negativeMin = 0;
        int positiveSum = 0, negativeSum = 0;
        foreach (int num in nums) {
            positiveSum += num;
            positiveMax = Math.Max(positiveMax, positiveSum);
            positiveSum = Math.Max(0, positiveSum);
            negativeSum += num;
            negativeMin = Math.Min(negativeMin, negativeSum);
            negativeSum = Math.Min(0, negativeSum);
        }
        return Math.Max(positiveMax, -negativeMin);
    }
}
```

```Go [sol1-Go]
func maxAbsoluteSum(nums []int) int {
    positiveMax, negativeMin := 0, 0
    positiveSum, negativeSum := 0, 0
    for _, num := range nums {
        positiveSum += num
        positiveMax = max(positiveMax, positiveSum)
        positiveSum = max(0, positiveSum)
        negativeSum += num
        negativeMin = min(negativeMin, negativeSum)
        negativeSum = min(0, negativeSum)
    }
    return max(positiveMax, -negativeMin)
}

func max(a int, b int) int {
    if a > b {
        return a
    }
    return b
}

func min(a int, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var maxAbsoluteSum = function(nums) {
    let positiveMax = 0, negativeMin = 0;
    let positiveSum = 0, negativeSum = 0;
    for (let num of nums) {
        positiveSum += num
        positiveMax = Math.max(positiveMax, positiveSum)
        positiveSum = Math.max(0, positiveSum)
        negativeSum += num
        negativeMin = Math.min(negativeMin, negativeSum)
        negativeSum = Math.min(0, negativeSum)
    }
    return Math.max(positiveMax, -negativeMin)
};
```

**复杂度分析**

- 时间复杂度：$O(n)$。只需要遍历数组一遍。

- 空间复杂度：$O(1)$。仅使用常数空间。
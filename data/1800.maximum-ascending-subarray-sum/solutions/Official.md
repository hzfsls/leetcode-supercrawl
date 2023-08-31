## [1800.最大升序子数组和 中文官方题解](https://leetcode.cn/problems/maximum-ascending-subarray-sum/solutions/100000/zui-da-sheng-xu-zi-shu-zu-he-by-leetcode-0q6v)

#### 方法一：动态规划

**思路与算法**

题目给定了一个长度为 $n$ 的正整数数组 $\textit{nums}$，现在要求一个升序的子数组最大可能的元素和。那么我们设 $\textit{dp}[i]$ 表示以 $\textit{nums}[i]$ 结尾的的最长升序子数组的元素和。那么我们考虑如何求解每一个状态：

1. 当 $\textit{nums}[i] > \textit{nums}[i - 1]$ 时：
   $$\textit{dp}[i] = \textit{dp}[i - 1] + \textit{nums}[i]$$
2. 当 $\textit{nums}[i] \le \textit{nums}[i - 1]$ 时：
   $$\textit{dp}[i] = \textit{nums}[i]$$

以上的讨论是建立在 $i > 0$ 的情况，我们还需要考虑动态规划的边界条件，即 $i = 0$ 的情况：此时 $\textit{nums}[0]$ 前面没有元素，本身可以构成一个长度为 $1$ 的子数组，即 $\textit{dp}[0] = \textit{nums}[0]$。

又因为求解状态的过程只和前一个状态有关， 所以可以用「滚动数组」的方法来进行空间优化。

**代码**

```Python [sol1-Python3]
class Solution:
    def maxAscendingSum(self, nums: List[int]) -> int:
        ans = 0
        i, n = 0, len(nums)
        while i < n:
            s = nums[i]
            i += 1
            while i < n and nums[i] > nums[i - 1]:
                s += nums[i]
                i += 1
            ans = max(ans, s)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int maxAscendingSum(vector<int>& nums) {
        int res = 0;
        int l = 0;
        while (l < nums.size()) {
            int cursum = nums[l++];
            while (l < nums.size() && nums[l] > nums[l - 1]) {
                cursum += nums[l++];
            }
            res = max(res, cursum);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maxAscendingSum(int[] nums) {
        int res = 0;
        int l = 0;
        while (l < nums.length) {
            int cursum = nums[l++];
            while (l < nums.length && nums[l] > nums[l - 1]) {
                cursum += nums[l++];
            }
            res = Math.max(res, cursum);
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxAscendingSum(int[] nums) {
        int res = 0;
        int l = 0;
        while (l < nums.Length) {
            int cursum = nums[l++];
            while (l < nums.Length && nums[l] > nums[l - 1]) {
                cursum += nums[l++];
            }
            res = Math.Max(res, cursum);
        }
        return res;
    }
}
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxAscendingSum(int* nums, int numsSize){
    int res = 0;
    int l = 0;
    while (l < numsSize) {
        int cursum = nums[l++];
        while (l < numsSize && nums[l] > nums[l - 1]) {
            cursum += nums[l++];
        }
        res = MAX(res, cursum);
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var maxAscendingSum = function(nums) {
    let res = 0;
    let l = 0;
    while (l < nums.length) {
        let cursum = nums[l++];
        while (l < nums.length && nums[l] > nums[l - 1]) {
            cursum += nums[l++];
        }
        res = Math.max(res, cursum);
    }
    return res;
};
```

```go [sol1-Golang]
func maxAscendingSum(nums []int) (ans int) {
    for i, n := 0, len(nums); i < n; {
        sum := nums[i]
        for i++; i < n && nums[i] > nums[i-1]; i++ {
            sum += nums[i]
        }
        if sum > ans {
            ans = sum
        }
    }
    return ans
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。
- 空间复杂度：$O(1)$，仅使用常量空间。
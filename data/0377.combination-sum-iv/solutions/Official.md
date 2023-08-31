## [377.组合总和 Ⅳ 中文官方题解](https://leetcode.cn/problems/combination-sum-iv/solutions/100000/zu-he-zong-he-iv-by-leetcode-solution-q8zv)
#### 方法一：动态规划

这道题中，给定数组 $\textit{nums}$ 和目标值 $\textit{target}$，要求计算从 $\textit{nums}$ 中选取若干个元素，使得它们的和等于 $\textit{target}$ 的方案数。其中，$\textit{nums}$ 的每个元素可以选取多次，且需要考虑选取元素的顺序。由于需要考虑选取元素的顺序，因此这道题需要计算的是选取元素的**排列**数。

可以通过动态规划的方法计算可能的方案数。用 $\textit{dp}[x]$ 表示选取的元素之和等于 $x$ 的方案数，目标是求 $\textit{dp}[\textit{target}]$。

动态规划的边界是 $\textit{dp}[0]=1$。只有当不选取任何元素时，元素之和才为 $0$，因此只有 $1$ 种方案。

当 $1 \le i \le \textit{target}$ 时，如果存在一种排列，其中的元素之和等于 $i$，则该排列的最后一个元素一定是数组 $\textit{nums}$ 中的一个元素。假设该排列的最后一个元素是 $\textit{num}$，则一定有 $\textit{num} \le i$，对于元素之和等于 $i - \textit{num}$ 的每一种排列，在最后添加 $\textit{num}$ 之后即可得到一个元素之和等于 $i$ 的排列，因此在计算 $\textit{dp}[i]$ 时，应该计算所有的 $\textit{dp}[i-\textit{num}]$ 之和。

由此可以得到动态规划的做法：

- 初始化 $\textit{dp}[0]=1$；

- 遍历 $i$ 从 $1$ 到 $\textit{target}$，对于每个 $i$，进行如下操作：

   - 遍历数组 $\textit{nums}$ 中的每个元素 $\textit{num}$，当 $\textit{num} \le i$ 时，将 $\textit{dp}[i - \textit{num}]$ 的值加到 $\textit{dp}[i]$。

- 最终得到 $\textit{dp}[\textit{target}]$ 的值即为答案。

上述做法是否考虑到选取元素的顺序？答案是肯定的。因为外层循环是遍历从 $1$ 到 $\textit{target}$ 的值，内层循环是遍历数组 $\textit{nums}$ 的值，在计算 $\textit{dp}[i]$ 的值时，$\textit{nums}$ 中的每个小于等于 $i$ 的元素都可能作为元素之和等于 $i$ 的排列的最后一个元素。例如，$1$ 和 $3$ 都在数组 $\textit{nums}$ 中，计算 $\textit{dp}[4]$ 的时候，排列的最后一个元素可以是 $1$ 也可以是 $3$，因此 $\textit{dp}[1]$ 和 $\textit{dp}[3]$ 都会被考虑到，即不同的顺序都会被考虑到。

```Java [sol1-Java]
class Solution {
    public int combinationSum4(int[] nums, int target) {
        int[] dp = new int[target + 1];
        dp[0] = 1;
        for (int i = 1; i <= target; i++) {
            for (int num : nums) {
                if (num <= i) {
                    dp[i] += dp[i - num];
                }
            }
        }
        return dp[target];
    }
}
```

```JavaScript [sol1-JavaScript]
var combinationSum4 = function(nums, target) {
    const dp = new Array(target + 1).fill(0);
    dp[0] = 1;
    for (let i = 1; i <= target; i++) {
        for (const num of nums) {
            if (num <= i) {
                dp[i] += dp[i - num];
            }
        }
    }
    return dp[target];
};
```

```go [sol1-Golang]
func combinationSum4(nums []int, target int) int {
    dp := make([]int, target+1)
    dp[0] = 1
    for i := 1; i <= target; i++ {
        for _, num := range nums {
            if num <= i {
                dp[i] += dp[i-num]
            }
        }
    }
    return dp[target]
}
```

```Python [sol1-Python3]
class Solution:
    def combinationSum4(self, nums: List[int], target: int) -> int:
        dp = [1] + [0] * target
        for i in range(1, target + 1):
            for num in nums:
                if num <= i:
                    dp[i] += dp[i - num]
        
        return dp[target]
```

```C++ [sol1-C++]
class Solution {
public:
    int combinationSum4(vector<int>& nums, int target) {
        vector<int> dp(target + 1);
        dp[0] = 1;
        for (int i = 1; i <= target; i++) {
            for (int& num : nums) {
                if (num <= i && dp[i - num] < INT_MAX - dp[i]) {
                    dp[i] += dp[i - num];
                }
            }
        }
        return dp[target];
    }
};
```

```C [sol1-C]
int combinationSum4(int* nums, int numsSize, int target) {
    int dp[target + 1];
    memset(dp, 0, sizeof(dp));
    dp[0] = 1;
    for (int i = 1; i <= target; i++) {
        for (int j = 0; j < numsSize; j++) {
            if (nums[j] <= i && dp[i - nums[j]] < INT_MAX - dp[i]) {
                dp[i] += dp[i - nums[j]];
            }
        }
    }
    return dp[target];
}
```

**复杂度分析**

- 时间复杂度：$O(\textit{target} \times n)$，其中 $\textit{target}$ 是目标值，$n$ 是数组 $\textit{nums}$ 的长度。需要计算长度为 $\textit{target}+1$ 的数组 $\textit{dp}$ 的每个元素的值，对于每个元素，需要遍历数组 $\textit{nums}$ 之后计算元素值。

- 空间复杂度：$O(\textit{target})$。需要创建长度为 $\textit{target}+1$ 的数组 $\textit{dp}$。

#### 进阶问题

如果给定的数组中含有负数，则会导致出现无限长度的排列。

例如，假设数组 $\textit{nums}$ 中含有正整数 $a$ 和负整数 $-b$（其中 $a>0,b>0,-b<0$），则有 $a \times b + (-b) \times a=0$，对于任意一个元素之和等于 $\textit{target}$ 的排列，在该排列的后面添加 $b$ 个 $a$ 和 $a$ 个 $-b$ 之后，得到的新排列的元素之和仍然等于 $\textit{target}$，而且还可以在新排列的后面继续 $b$ 个 $a$ 和 $a$ 个 $-b$。因此只要存在元素之和等于 $\textit{target}$ 的排列，就能构造出无限长度的排列。

如果允许负数出现，则必须限制排列的最大长度，避免出现无限长度的排列，才能计算排列数。

---
# [📚 好读书？读好书！让时间更有价值| 世界读书日](https://leetcode-cn.com/circle/discuss/12QtuI/)
4 月 22 日至 4 月 28 日，进入「[学习](https://leetcode-cn.com/leetbook/)」，完成页面右上角的「让时间更有价值」限时阅读任务，可获得「2021 读书日纪念勋章」。更多活动详情戳上方标题了解更多👆
#### 今日学习任务：
- 学习 shell 中的的算术操作
[完成阅读 6.1 在 shell 脚本中执行算术操作](https://leetcode-cn.com/leetbook/read/bash-cookbook/rxjqwm/)
- 学习 shell 中的条件分支
[完成阅读 6.2 条件分支](https://leetcode-cn.com/leetbook/read/bash-cookbook/rxftn1/)
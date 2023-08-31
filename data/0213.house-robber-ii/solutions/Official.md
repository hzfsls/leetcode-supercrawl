## [213.打家劫舍 II 中文官方题解](https://leetcode.cn/problems/house-robber-ii/solutions/100000/da-jia-jie-she-ii-by-leetcode-solution-bwja)
#### 前言

这道题是「[198. 打家劫舍](https://leetcode-cn.com/problems/house-robber)」的进阶，和第 198 题的不同之处是，这道题中的房屋是首尾相连的，第一间房屋和最后一间房屋相邻，因此第一间房屋和最后一间房屋不能在同一晚上偷窃。

和第 198 题相似，这道题也可以使用动态规划解决。建议读者首先阅读「[198. 打家劫舍的官方题解](https://leetcode-cn.com/problems/house-robber/solution/da-jia-jie-she-by-leetcode-solution)」，了解动态规划的思想。

#### 方法一：动态规划

首先考虑最简单的情况。如果只有一间房屋，则偷窃该房屋，可以偷窃到最高总金额。如果只有两间房屋，则由于两间房屋相邻，不能同时偷窃，只能偷窃其中的一间房屋，因此选择其中金额较高的房屋进行偷窃，可以偷窃到最高总金额。

注意到当房屋数量不超过两间时，最多只能偷窃一间房屋，因此不需要考虑首尾相连的问题。如果房屋数量大于两间，就必须考虑首尾相连的问题，第一间房屋和最后一间房屋不能同时偷窃。

如何才能保证第一间房屋和最后一间房屋不同时偷窃呢？如果偷窃了第一间房屋，则不能偷窃最后一间房屋，因此偷窃房屋的范围是第一间房屋到最后第二间房屋；如果偷窃了最后一间房屋，则不能偷窃第一间房屋，因此偷窃房屋的范围是第二间房屋到最后一间房屋。

假设数组 $\textit{nums}$ 的长度为 $n$。如果不偷窃最后一间房屋，则偷窃房屋的下标范围是 $[0, n-2]$；如果不偷窃第一间房屋，则偷窃房屋的下标范围是 $[1, n-1]$。在确定偷窃房屋的下标范围之后，即可用第 198 题的方法解决。对于两段下标范围分别计算可以偷窃到的最高总金额，其中的最大值即为在 $n$ 间房屋中可以偷窃到的最高总金额。

假设偷窃房屋的下标范围是 $[\textit{start},\textit{end}]$，用 $\textit{dp}[i]$ 表示在下标范围 $[\textit{start},i]$ 内可以偷窃到的最高总金额，那么就有如下的状态转移方程：

$$
\textit{dp}[i] = \max(\textit{dp}[i-2]+\textit{nums}[i], \textit{dp}[i-1])
$$

边界条件为：

$$
\begin{cases}
\textit{dp}[\textit{start}] = \textit{nums}[\textit{start}] & 只有一间房屋，则偷窃该房屋 \\
\textit{dp}[\textit{start}+1] = \max(\textit{nums}[\textit{start}], \textit{nums}[\textit{start}+1]) & 只有两间房屋，偷窃其中金额较高的房屋
\end{cases}
$$

计算得到 $\textit{dp}[\textit{end}]$ 即为下标范围 $[\textit{start},\textit{end}]$ 内可以偷窃到的最高总金额。

分别取 $(\textit{start},\textit{end})=(0,n-2)$ 和 $(\textit{start},\textit{end})=(1,n-1)$ 进行计算，取两个 $\textit{dp}[\textit{end}]$ 中的最大值，即可得到最终结果。

根据上述思路，可以得到时间复杂度 $O(n)$ 和空间复杂度 $O(n)$ 的实现。考虑到每间房屋的最高总金额只和该房屋的前两间房屋的最高总金额相关，因此可以使用滚动数组，在每个时刻只需要存储前两间房屋的最高总金额，将空间复杂度降到 $O(1)$。

<![fig1](https://assets.leetcode-cn.com/solution-static/213/1.PNG),![fig2](https://assets.leetcode-cn.com/solution-static/213/2.PNG),![fig3](https://assets.leetcode-cn.com/solution-static/213/3.PNG),![fig4](https://assets.leetcode-cn.com/solution-static/213/4.PNG),![fig5](https://assets.leetcode-cn.com/solution-static/213/5.PNG),![fig6](https://assets.leetcode-cn.com/solution-static/213/6.PNG),![fig7](https://assets.leetcode-cn.com/solution-static/213/7.PNG),![fig8](https://assets.leetcode-cn.com/solution-static/213/8.PNG),![fig9](https://assets.leetcode-cn.com/solution-static/213/9.PNG)>

```Java [sol1-Java]
class Solution {
    public int rob(int[] nums) {
        int length = nums.length;
        if (length == 1) {
            return nums[0];
        } else if (length == 2) {
            return Math.max(nums[0], nums[1]);
        }
        return Math.max(robRange(nums, 0, length - 2), robRange(nums, 1, length - 1));
    }

    public int robRange(int[] nums, int start, int end) {
        int first = nums[start], second = Math.max(nums[start], nums[start + 1]);
        for (int i = start + 2; i <= end; i++) {
            int temp = second;
            second = Math.max(first + nums[i], second);
            first = temp;
        }
        return second;
    }
}
```

```JavaScript [sol1-JavaScript]
var rob = function(nums) {
    const length = nums.length;
    if (length === 1) {
        return nums[0];
    } else if (length === 2) {
        return Math.max(nums[0], nums[1]);
    }
    return Math.max(robRange(nums, 0, length - 2), robRange(nums, 1, length - 1));
};

const robRange = (nums, start, end) => {
    let first = nums[start], second = Math.max(nums[start], nums[start + 1]);
    for (let i = start + 2; i <= end; i++) {
        const temp = second;
        second = Math.max(first + nums[i], second);
        first = temp;
    }
    return second;
}
```

```go [sol1-Golang]
func _rob(nums []int) int {
    first, second := nums[0], max(nums[0], nums[1])
    for _, v := range nums[2:] {
        first, second = second, max(first+v, second)
    }
    return second
}

func rob(nums []int) int {
    n := len(nums)
    if n == 1 {
        return nums[0]
    }
    if n == 2 {
        return max(nums[0], nums[1])
    }
    return max(_rob(nums[:n-1]), _rob(nums[1:]))
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```Python [sol1-Python3]
class Solution:
    def rob(self, nums: List[int]) -> int:
        def robRange(start: int, end: int) -> int:
            first = nums[start]
            second = max(nums[start], nums[start + 1])
            for i in range(start + 2, end + 1):
                first, second = second, max(first + nums[i], second)
            return second
        
        length = len(nums)
        if length == 1:
            return nums[0]
        elif length == 2:
            return max(nums[0], nums[1])
        else:
            return max(robRange(0, length - 2), robRange(1, length - 1))
```

```C++ [sol1-C++]
class Solution {
public:
    int robRange(vector<int>& nums, int start, int end) {
        int first = nums[start], second = max(nums[start], nums[start + 1]);
        for (int i = start + 2; i <= end; i++) {
            int temp = second;
            second = max(first + nums[i], second);
            first = temp;
        }
        return second;
    }

    int rob(vector<int>& nums) {
        int length = nums.size();
        if (length == 1) {
            return nums[0];
        } else if (length == 2) {
            return max(nums[0], nums[1]);
        }
        return max(robRange(nums, 0, length - 2), robRange(nums, 1, length - 1));
    }
};
```

```C [sol1-C]
int robRange(int* nums, int start, int end) {
    int first = nums[start], second = fmax(nums[start], nums[start + 1]);
    for (int i = start + 2; i <= end; i++) {
        int temp = second;
        second = fmax(first + nums[i], second);
        first = temp;
    }
    return second;
}

int rob(int* nums, int numsSize) {
    if (numsSize == 1) {
        return nums[0];
    } else if (numsSize == 2) {
        return fmax(nums[0], nums[1]);
    }
    return fmax(robRange(nums, 0, numsSize - 2), robRange(nums, 1, numsSize - 1));
}
```

**复杂度分析**

* 时间复杂度：$O(n)$，其中 $n$ 是数组长度。需要对数组遍历两次，计算可以偷窃到的最高总金额。

* 空间复杂度：$O(1)$。
## [1827.最少操作使数组递增 中文官方题解](https://leetcode.cn/problems/minimum-operations-to-make-the-array-increasing/solutions/100000/zui-shao-cao-zuo-shi-shu-zu-di-zeng-by-l-sjr6)
#### 方法一：贪心

**思路与算法**

题目给出一个长度为 $n$ 的整数数组 $\textit{nums}$（下标从 $0$ 开始）。每一次我们可以进行一次操作：选择数组中的一个元素，并将它增加 $1$。现在我们需要求使 $\textit{nums}$ **严格递增**的最少操作次数（其中长度为 $1$ 的数组为严格递增数组的一种情况）。那么我们从左到右来依次确认每一个位置的数，我们不妨设现在 $\textit{nums}[i]$ 已经确定 $0 < i < n - 1$，则现在对于 $\textit{nums}[i + 1]$ 需要满足 $\textit{nums}[i + 1] \ge \max\{\textit{nums}[i] + 1, \textit{nums}[i + 1]\}$。即我们可以知道对于增加 $\textit{nums}[i]$ 并不能使 $\textit{nums}[i + 1]$ 的取值下限降低，因此为了使最终使 $\textit{nums}$ 严格递增，我们只需要从左到右使每一个数取到其对应的下限即可，其中当 $i = 0$ 时，其下限为 $\textit{nums}[0]$。

**代码**

```Python [sol1-Python3]
class Solution:
    def minOperations(self, nums: List[int]) -> int:
        pre = nums[0] - 1
        res = 0
        for i in nums:
            pre = max(pre + 1, i)
            res += pre - i
        return res
```

```Java [sol1-Java]
class Solution {
    public int minOperations(int[] nums) {
        int pre = nums[0] - 1, res = 0;
        for (int num : nums) {
            pre = Math.max(pre + 1, num);
            res += pre - num;
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinOperations(int[] nums) {
        int pre = nums[0] - 1, res = 0;
        foreach (int num in nums) {
            pre = Math.Max(pre + 1, num);
            res += pre - num;
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minOperations(vector<int>& nums) {
        int pre = nums[0] - 1, res = 0;
        for (int num : nums) {
            pre = max(pre + 1, num);
            res += pre - num;
        }
        return res;
    }
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int minOperations(int* nums, int numsSize){
    int pre = nums[0] - 1, res = 0;
    for (int i = 0; i < numsSize; i++) {
        pre = MAX(pre + 1, nums[i]);
        res += pre - nums[i];
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var minOperations = function(nums) {
    let pre = nums[0] - 1, res = 0;
    for (const num of nums) {
        pre = Math.max(pre + 1, num);
        res += pre - num;
    }
    return res;
};
```

```go [sol1-Golang]
func minOperations(nums []int) (ans int) {
    pre := nums[0] - 1
    for _, x := range nums {
        pre = max(pre+1, x)
        ans += pre - x
    }
    return
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。
- 空间复杂度：$O(1)$，仅使用常量空间。
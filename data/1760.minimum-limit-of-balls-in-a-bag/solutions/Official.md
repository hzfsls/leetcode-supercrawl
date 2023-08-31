## [1760.袋子里最少数目的球 中文官方题解](https://leetcode.cn/problems/minimum-limit-of-balls-in-a-bag/solutions/100000/dai-zi-li-zui-shao-shu-mu-de-qiu-by-leet-boay)
#### 方法一：二分查找

**思路与算法**

我们可以将题目中的要求转换成判定问题，即：

> 给定 $\textit{maxOperations}$ 次操作次数，能否可以使得单个袋子里球数目的**最大值**不超过 $y$。

如果 $y = y_0$ 是一个满足要求的答案，那么所有大于 $y_0$ 的 $y$ 同样也是满足要求的。因此存在一个 $y = y_\textit{opt}$，使得当 $y \geq y_\textit{opt}$ 时都是满足要求的，当 $y < y_\textit{opt}$ 时都是不满足要求的。这个 $y_\textit{opt}$ 就是最终的答案。

因此，我们可以通过二分查找的方式得到答案。二分查找的下界为 $1$，上界为数组 $\textit{nums}$ 中的最大值，即单个袋子中最多的球数。

当我们二分查找到 $y$ 时，对于第 $i$ 个袋子，其中有 $\textit{nums}[i]$ 个球，那么需要的操作次数为：

$$
\lfloor \frac{\textit{nums}[i]-1}{y} \rfloor
$$

其中 $\lfloor x \rfloor$ 表示将 $x$ 进行下取整。它的含义为：

- 当 $\textit{nums}[i] \leq y$ 时，我们无需进行操作；
- 当 $y < \textit{nums}[i] \leq 2y$ 时，我们需要进行 $1$ 次操作；
- 当 $2y < \textit{nums}[i] \leq 3y$ 时，我们需要进行 $2$ 次操作；
- $\cdots$

那么总操作次数即为：

$$
P = \sum_{i} \lfloor \frac{\textit{nums}[i]-1}{y} \rfloor
$$

当 $P \leq \textit{maxOperations}$ 时，我们调整二分查找的上界，否则调整二分查找的下界。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int minimumSize(vector<int>& nums, int maxOperations) {
        int left = 1, right = *max_element(nums.begin(), nums.end());
        int ans = 0;
        while (left <= right) {
            int y = (left + right) / 2;
            long long ops = 0;
            for (int x: nums) {
                ops += (x - 1) / y;
            }
            if (ops <= maxOperations) {
                ans = y;
                right = y - 1;
            }
            else {
                left = y + 1;
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int minimumSize(int[] nums, int maxOperations) {
        int left = 1, right = Arrays.stream(nums).max().getAsInt();
        int ans = 0;
        while (left <= right) {
            int y = (left + right) / 2;
            long ops = 0;
            for (int x : nums) {
                ops += (x - 1) / y;
            }
            if (ops <= maxOperations) {
                ans = y;
                right = y - 1;
            } else {
                left = y + 1;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumSize(int[] nums, int maxOperations) {
        int left = 1, right = nums.Max();
        int ans = 0;
        while (left <= right) {
            int y = (left + right) / 2;
            long ops = 0;
            foreach (int x in nums) {
                ops += (x - 1) / y;
            }
            if (ops <= maxOperations) {
                ans = y;
                right = y - 1;
            } else {
                left = y + 1;
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def minimumSize(self, nums: List[int], maxOperations: int) -> int:
        left, right, ans = 1, max(nums), 0
        while left <= right:
            y = (left + right) // 2
            ops = sum((x - 1) // y for x in nums)
            if ops <= maxOperations:
                ans = y
                right = y - 1
            else:
                left = y + 1
        
        return ans
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int minimumSize(int* nums, int numsSize, int maxOperations) {
    int left = 1, right = nums[0];
    for (int i = 1; i < numsSize; i++) {
        right = MAX(right, nums[i]);
    }
    int ans = 0;
    while (left <= right) {
        int y = (left + right) / 2;
        long long ops = 0;
        for (int i = 0; i < numsSize; i++) {
            ops += (nums[i] - 1) / y;
        }
        if (ops <= maxOperations) {
            ans = y;
            right = y - 1;
        }
        else {
            left = y + 1;
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var minimumSize = function(nums, maxOperations) {
    let left = 1, right = _.max(nums);
    let ans = 0;
    while (left <= right) {
        const y = Math.floor((left + right) / 2);
        let ops = 0;
        for (const x of nums) {
            ops += Math.floor((x - 1) / y);
        }
        if (ops <= maxOperations) {
            ans = y;
            right = y - 1;
        } else {
            left = y + 1;
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func minimumSize(nums []int, maxOperations int) int {
	max := 0
	for _, x := range nums {
		if x > max {
			max = x
		}
	}
	return sort.Search(max, func(y int) bool {
		if y == 0 {
			return false
		}
		ops := 0
		for _, x := range nums {
			ops += (x - 1) / y
		}
		return ops <= maxOperations
	})
}
```

**复杂度分析**

- 时间复杂度：$O(n \log C)$，其中 $n$ 是数组 $\textit{nums}$ 的长度，$C$ 是数组 $\textit{nums}$ 中的最大值，不超过 $10^9$。

- 空间复杂度：$O(1)$。
#### 方法一：前缀最小值

**思路与算法**

当我们固定 $j$ 时，选择的下标 $i$ 一定是满足 $0 \leq i < j$ 并且 $\textit{nums}[i]$ 最小的那个 $i$。因此我们可以使用循环对 $j$ 进行遍历，同时维护 $\textit{nums}[0..j-1]$ 的**前缀最小值**，记为 $\textit{premin}$。这样一来：

- 如果 $\textit{nums}[i] > \textit{premin}$，那么就用 $\textit{nums}[i] - \textit{premin}$ 对答案进行更新；

- 否则，用 $\textit{nums}[i]$ 来更新前缀最小值 $\textit{premin}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximumDifference(vector<int>& nums) {
        int n = nums.size();
        int ans = -1, premin = nums[0];
        for (int i = 1; i < n; ++i) {
            if (nums[i] > premin) {
                ans = max(ans, nums[i] - premin);
            } else {
                premin = nums[i];
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int maximumDifference(int[] nums) {
        int n = nums.length;
        int ans = -1, premin = nums[0];
        for (int i = 1; i < n; ++i) {
            if (nums[i] > premin) {
                ans = Math.max(ans, nums[i] - premin);
            } else {
                premin = nums[i];
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaximumDifference(int[] nums) {
        int n = nums.Length;
        int ans = -1, premin = nums[0];
        for (int i = 1; i < n; ++i) {
            if (nums[i] > premin) {
                ans = Math.Max(ans, nums[i] - premin);
            } else {
                premin = nums[i];
            }
        }
        return ans;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maximumDifference(self, nums: List[int]) -> int:
        n = len(nums)
        ans, premin = -1, nums[0]

        for i in range(1, n):
            if nums[i] > premin:
                ans = max(ans, nums[i] - premin)
            else:
                premin = nums[i]
        
        return ans
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maximumDifference(int* nums, int numsSize){
    int ans = -1, premin = nums[0];
    for (int i = 1; i < numsSize; ++i) {
        if (nums[i] > premin) {
            ans = MAX(ans, nums[i] - premin);
        } else {
            premin = nums[i];
        }
    }
    return ans;
}
```

```JavaScript [sol1-JavaScript]
var maximumDifference = function(nums) {
    const n = nums.length;
    let ans = -1, premin = nums[0];
    for (let i = 1; i < n; ++i) {
        if (nums[i] > premin) {
            ans = Math.max(ans, nums[i] - premin);
        } else {
            premin = nums[i];
        }
    }
    return ans;
};
```

```go [sol1-Golang]
func maximumDifference(nums []int) int {
    ans := -1
    for i, preMin := 1, nums[0]; i < len(nums); i++ {
        if nums[i] > preMin {
            ans = max(ans, nums[i]-preMin)
        } else {
            preMin = nums[i]
        }
    }
    return ans
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。我们只需要对数组 $\textit{nums}$ 进行一次遍历。

- 空间复杂度：$O(1)$。
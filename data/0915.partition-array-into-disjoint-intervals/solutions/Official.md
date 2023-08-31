## [915.分割数组 中文官方题解](https://leetcode.cn/problems/partition-array-into-disjoint-intervals/solutions/100000/fen-ge-shu-zu-by-leetcode-solution-t4pm)

#### 方法一：两次遍历

**思路和算法**

题目要求将数组 $\textit{nums}$ 划分为非空的两个连续子数组 $\textit{left}$ 和 $\textit{right}$，并且需要满足 $\textit{left}$ 中的每个元素都小于等于 $\textit{right}$ 中的每个元素，同时 $\textit{left}$ 的长度要尽可能的小。

$\textit{left}$ 中的每个元素都小于或等于 $\textit{right}$ 中的每个元素，等价于 $\textit{left}$ 中的最大值小于等于 $\textit{right}$ 中的最小值。我们可以维护一个数组 $\textit{minRight}$，设 $\textit{nums}$ 的长度为 $n$，那么 $\textit{minRight}[i] = \min\limits_{i}^{n-1}\textit{nums}[i]$。

然后我们从小到大去遍历 $i$，过程中维护一个变量 $\textit{maxLeft}$，它的值等于 $\max\limits_{0}^{i}\textit{nums}[i]$。找到第一个满足 $\textit{maxLeft} \le \textit{minRight}[i+1]$ 的 $i$ 即为答案，此时 $\textit{left}$ 的长度为 $i + 1$，因此答案需返回 $i + 1$。

注意，由于 $\textit{left}$ 和 $\textit{right}$ 都是非空子数组，$i$ 的遍历范围应当是 $[0, n-2]$。但因为题目保证有解，所以 $i$ 在遍历到 $n - 1$ 之前一定可以找到答案。

```Python
class Solution:
    def partitionDisjoint(self, nums: List[int]) -> int:
        n = len(nums)
        min_right = [0] * n
        min_right[-1] = nums[-1]
        for i in range(n - 2, 0, -1):
            min_right[i] = min(min_right[i + 1], nums[i])

        max_left = nums[0]
        for i in range(1, n):
            if max_left <= min_right[i]:
                return i
            max_left = max(max_left, nums[i])
```

```C++
class Solution {
public:
    int partitionDisjoint(vector<int>& nums) {
        int n = nums.size();
        vector<int> minRight(n);
        minRight[n - 1] = nums[n - 1];
        for (int i = n - 2; i >= 0; i--) {
            minRight[i] = min(nums[i], minRight[i + 1]);
        }

        int maxLeft = 0;
        for (int i = 0; i < n - 1; i++) {
            maxLeft = max(maxLeft, nums[i]);
            if (maxLeft <= minRight[i + 1]) {
                return i + 1;
            }
        }
        return n - 1;
    }
};
```

```Java
class Solution {
    public int partitionDisjoint(int[] nums) {
        int n = nums.length;
        int[] minRight = new int[n];
        minRight[n - 1] = nums[n - 1];
        for (int i = n - 2; i >= 0; i--) {
            minRight[i] = Math.min(nums[i], minRight[i + 1]);
        }

        int maxLeft = 0;
        for (int i = 0; i < n - 1; i++) {
            maxLeft = Math.max(maxLeft, nums[i]);
            if (maxLeft <= minRight[i + 1]) {
                return i + 1;
            }
        }
        return n - 1;
    }
}
```

```C#
public class Solution {
    public int PartitionDisjoint(int[] nums) {
        int n = nums.Length;
        int[] minRight = new int[n];
        minRight[n - 1] = nums[n - 1];
        for (int i = n - 2; i >= 0; i--) {
            minRight[i] = Math.Min(nums[i], minRight[i + 1]);
        }

        int maxLeft = 0;
        for (int i = 0; i < n - 1; i++) {
            maxLeft = Math.Max(maxLeft, nums[i]);
            if (maxLeft <= minRight[i + 1]) {
                return i + 1;
            }
        }
        return n - 1;
    }
}
```

```C
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int partitionDisjoint(int* nums, int numsSize) {
    int minRight[numsSize];
    minRight[numsSize - 1] = nums[numsSize - 1];
    for (int i = numsSize - 2; i >= 0; i--) {
        minRight[i] = MIN(nums[i], minRight[i + 1]);
    }

    int maxLeft = 0;
    for (int i = 0; i < numsSize - 1; i++) {
        maxLeft = MAX(maxLeft, nums[i]);
        if (maxLeft <= minRight[i + 1]) {
            return i + 1;
        }
    }
    return numsSize - 1;
}
```

```JavaScript
var partitionDisjoint = function(nums) {
    const n = nums.length;
    const minRight = new Array(n).fill(0);
    minRight[n - 1] = nums[n - 1];
    for (let i = n - 2; i >= 0; i--) {
        minRight[i] = Math.min(nums[i], minRight[i + 1]);
    }

    let maxLeft = 0;
    for (let i = 0; i < n - 1; i++) {
        maxLeft = Math.max(maxLeft, nums[i]);
        if (maxLeft <= minRight[i + 1]) {
            return i + 1;
        }
    }
    return n - 1;
};
```

```go
func partitionDisjoint(nums []int) int {
    n := len(nums)
    minRight := make([]int, n)
    minRight[n-1] = nums[n-1]
    for i := n - 2; i > 0; i-- {
        minRight[i] = min(minRight[i+1], nums[i])
    }

    maxLeft := nums[0]
    for i := 1; ; i++ {
        if maxLeft <= minRight[i] {
            return i
        }
        maxLeft = max(maxLeft, nums[i])
    }
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

-   时间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。求解 $\textit{minRight}$ 的时间复杂度是 $O(n)$，从前到后遍历 $i$ 的时间复杂度也为 $O(n)$。

-   空间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。使用辅助数组 $\textit{minRight}$ 的空间开销为 $O(n)$。

#### 方法二：一次遍历

**思路和算法**

假设我们预先规定了一个 $\textit{left}$ 的划分，其最大值为 $\textit{maxLeft}$，划分位置为 $\textit{leftPos}$，表示 $\textit{nums}[0,\textit{leftPos}]$ 都属于 $\textit{left}$。如果 $\textit{leftPos}$ 右侧所有元素都大于等于它，那么该划分方案是合法的。

但如果我们找到 $\textit{nums}[i]$，其中 $i\gt \textit{leftPos}$，并且 $\textit{nums}[i] \lt \textit{maxLeft}$，那么意味着 $\textit{leftPos}$ 作为划分位置是非法的，需要更新 $\textit{leftPos} = i$，以及 $\textit{maxLeft} = \max\limits_{0}^{i}\textit{nums}[i]$。

因此，我们首先初始化 $\textit{maxLeft} = \textit{nums}[0]$，$\textit{leftPos} = 0$，然后在 $[1,n-2]$ 范围内从小到大遍历 $i$，过程中维护一个变量 $\textit{curMax}$，它的值是 $\max\limits_{0}^{i}\textit{nums}[i]$。此时如果有 $\textit{nums}[i] \lt \textit{maxLeft}$，就按照上述方法更新。最终遍历结束时，答案就是 $\textit{leftPos} + 1$。

```Python
class Solution:
    def partitionDisjoint(self, nums: List[int]) -> int:
        n = len(nums)
        cur_max = left_max = nums[0]
        left_pos = 0
        for i in range(1, n - 1):
            cur_max = max(cur_max, nums[i])
            if nums[i] < left_max:
                left_max, left_pos = cur_max, i
        return left_pos + 1
```

```C++
class Solution {
public:
    int partitionDisjoint(vector<int>& nums) {
        int n = nums.size();
        int leftMax = nums[0], leftPos = 0, curMax = nums[0];
        for (int i = 1; i < n - 1; i++) {
            curMax = max(curMax, nums[i]);
            if (nums[i] < leftMax) {
                leftMax = curMax;
                leftPos = i;
            }
        }
        return leftPos + 1;
    }
};
```

```Java
class Solution {
    public int partitionDisjoint(int[] nums) {
        int n = nums.length;
        int leftMax = nums[0], leftPos = 0, curMax = nums[0];
        for (int i = 1; i < n - 1; i++) {
            curMax = Math.max(curMax, nums[i]);
            if (nums[i] < leftMax) {
                leftMax = curMax;
                leftPos = i;
            }
        }
        return leftPos + 1;
    }
}
```

```C#
public class Solution {
    public int PartitionDisjoint(int[] nums) {
        int n = nums.Length;
        int leftMax = nums[0], leftPos = 0, curMax = nums[0];
        for (int i = 1; i < n - 1; i++) {
            curMax = Math.Max(curMax, nums[i]);
            if (nums[i] < leftMax) {
                leftMax = curMax;
                leftPos = i;
            }
        }
        return leftPos + 1;
    }
}
```

```C
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int partitionDisjoint(int* nums, int numsSize) {
    int leftMax = nums[0], leftPos = 0, curMax = nums[0];
    for (int i = 1; i < numsSize - 1; i++) {
        curMax = MAX(curMax, nums[i]);
        if (nums[i] < leftMax) {
            leftMax = curMax;
            leftPos = i;
        }
    }
    return leftPos + 1;
}
```

```JavaScript
var partitionDisjoint = function(nums) {
    const n = nums.length;
    let leftMax = nums[0], leftPos = 0, curMax = nums[0];
    for (let i = 1; i < n - 1; i++) {
        curMax = Math.max(curMax, nums[i]);
        if (nums[i] < leftMax) {
            leftMax = curMax;
            leftPos = i;
        }
    }
    return leftPos + 1;
};
```

```go
func partitionDisjoint(nums []int) int {
    n := len(nums)
    leftMax, leftPos, curMax := nums[0], 0, nums[0]
    for i := 1; i < n-1; i++ {
        curMax = max(curMax, nums[i])
        if nums[i] < leftMax {
            leftMax = curMax
            leftPos = i
        }
    }
    return leftPos + 1
}

func max(a, b int) int {
    if b > a {
        return b
    }
    return a
}
```

**复杂度分析**

-   时间复杂度：$O(n)$，其中 $n$ 是 $\textit{nums}$ 的长度。从前到后遍历 $i$ 的时间复杂度为 $O(n)$。

-   空间复杂度：$O(1)$。算法只使用了常数个变量。

## [334.递增的三元子序列 中文官方题解](https://leetcode.cn/problems/increasing-triplet-subsequence/solutions/100000/di-zeng-de-san-yuan-zi-xu-lie-by-leetcod-dp2r)
#### 方法一：双向遍历

如果数组 $\textit{nums}$ 中存在一个下标 $i$ 满足 $1 \le i < n - 1$，使得在 $\textit{nums}[i]$ 的左边存在一个元素小于 $\textit{nums}[i]$ 且在 $\textit{nums}[i]$ 的右边存在一个元素大于 $\textit{nums}[i]$，则数组 $\textit{nums}$ 中存在递增的三元子序列。

在 $\textit{nums}[i]$ 的左边存在一个元素小于 $\textit{nums}[i]$ 等价于在 $\textit{nums}[i]$ 的左边的最小元素小于 $\textit{nums}[i]$，在 $\textit{nums}[i]$ 的右边存在一个元素大于 $\textit{nums}[i]$ 等价于在 $\textit{nums}[i]$ 的右边的最大元素大于 $\textit{nums}[i]$，因此可以维护数组 $\textit{nums}$ 中的每个元素左边的最小值和右边的最大值。

创建两个长度为 $n$ 的数组 $\textit{leftMin}$ 和 $\textit{rightMax}$，对于 $0 \le i < n$，$\textit{leftMin}[i]$ 表示 $\textit{nums}[0]$ 到 $\textit{nums}[i]$ 中的最小值，$\textit{rightMax}[i]$ 表示 $\textit{nums}[i]$ 到 $\textit{nums}[n - 1]$ 中的最大值。

数组 $\textit{leftMin}$ 的计算方式如下：

- $\textit{leftMin}[0] = \textit{nums}[0]$；

- 从左到右遍历数组 $\textit{nums}$，对于 $1 \le i < n$，$\textit{leftMin}[i] = \min(\textit{leftMin}[i - 1], \textit{nums}[i])$。

数组 $\textit{rightMax}$ 的计算方式如下：

- $\textit{rightMax}[n - 1] = \textit{nums}[n - 1]$；

- 从右到左遍历数组 $\textit{nums}$，对于 $0 \le i < n - 1$，$\textit{rightMax}[i] = \max(\textit{rightMax}[i + 1], \textit{nums}[i])$。

得到数组 $\textit{leftMin}$ 和 $\textit{rightMax}$ 之后，遍历 $1 \le i < n - 1$ 的每个下标 $i$，如果存在一个下标 $i$ 满足 $\textit{leftMin}[i - 1] < \textit{nums}[i] < \textit{rightMax}[i + 1]$，则返回 $\text{true}$，如果不存在这样的下标 $i$，则返回 $\text{false}$。

```Java [sol1-Java]
class Solution {
    public boolean increasingTriplet(int[] nums) {
        int n = nums.length;
        if (n < 3) {
            return false;
        }
        int[] leftMin = new int[n];
        leftMin[0] = nums[0];
        for (int i = 1; i < n; i++) {
            leftMin[i] = Math.min(leftMin[i - 1], nums[i]);
        }
        int[] rightMax = new int[n];
        rightMax[n - 1] = nums[n - 1];
        for (int i = n - 2; i >= 0; i--) {
            rightMax[i] = Math.max(rightMax[i + 1], nums[i]);
        }
        for (int i = 1; i < n - 1; i++) {
            if (nums[i] > leftMin[i - 1] && nums[i] < rightMax[i + 1]) {
                return true;
            }
        }
        return false;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IncreasingTriplet(int[] nums) {
        int n = nums.Length;
        if (n < 3) {
            return false;
        }
        int[] leftMin = new int[n];
        leftMin[0] = nums[0];
        for (int i = 1; i < n; i++) {
            leftMin[i] = Math.Min(leftMin[i - 1], nums[i]);
        }
        int[] rightMax = new int[n];
        rightMax[n - 1] = nums[n - 1];
        for (int i = n - 2; i >= 0; i--) {
            rightMax[i] = Math.Max(rightMax[i + 1], nums[i]);
        }
        for (int i = 1; i < n - 1; i++) {
            if (nums[i] > leftMin[i - 1] && nums[i] < rightMax[i + 1]) {
                return true;
            }
        }
        return false;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool increasingTriplet(vector<int>& nums) {
        int n = nums.size();
        if (n < 3) {
            return false;
        }
        vector<int> leftMin(n);
        leftMin[0] = nums[0];
        for (int i = 1; i < n; i++) {
            leftMin[i] = min(leftMin[i - 1], nums[i]);
        }
        vector<int> rightMax(n);
        rightMax[n - 1] = nums[n - 1];
        for (int i = n - 2; i >= 0; i--) {
            rightMax[i] = max(rightMax[i + 1], nums[i]);
        }
        for (int i = 1; i < n - 1; i++) {
            if (nums[i] > leftMin[i - 1] && nums[i] < rightMax[i + 1]) {
                return true;
            }
        }
        return false;
    }
};
```

```C [sol1-C]
#define MIN(a, b) ((a) > (b) ? (b) : (a))
#define MAX(a, b) ((a) < (b) ? (b) : (a))

bool increasingTriplet(int* nums, int numsSize){
    if (numsSize < 3) {
        return false;
    }
    int * leftMin = (int *)malloc(sizeof(int) * numsSize);
    int * rightMax = (int *)malloc(sizeof(int) * numsSize);
    leftMin[0] = nums[0];
    for (int i = 1; i < numsSize; i++) {
        leftMin[i] = MIN(leftMin[i - 1], nums[i]);
    }
    rightMax[numsSize - 1] = nums[numsSize - 1];
    for (int i = numsSize - 2; i >= 0; i--) {
        rightMax[i] = MAX(rightMax[i + 1], nums[i]);
    }
    for (int i = 1; i < numsSize - 1; i++) {
        if (nums[i] > leftMin[i - 1] && nums[i] < rightMax[i + 1]) {
            return true;
        }
    }
    free(leftMin);
    free(rightMax);
    return false;
}
```

```go [sol1-Golang]
func increasingTriplet(nums []int) bool {
    n := len(nums)
    if n < 3 {
        return false
    }
    leftMin := make([]int, n)
    leftMin[0] = nums[0]
    for i := 1; i < n; i++ {
        leftMin[i] = min(leftMin[i-1], nums[i])
    }
    rightMax := make([]int, n)
    rightMax[n-1] = nums[n-1]
    for i := n - 2; i >= 0; i-- {
        rightMax[i] = max(rightMax[i+1], nums[i])
    }
    for i := 1; i < n-1; i++ {
        if nums[i] > leftMin[i-1] && nums[i] < rightMax[i+1] {
            return true
        }
    }
    return false
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

```Python [sol1-Python3]
class Solution:
    def increasingTriplet(self, nums: List[int]) -> bool:
        n = len(nums)
        if n < 3:
            return False
        leftMin = [0] * n
        leftMin[0] = nums[0]
        for i in range(1, n):
            leftMin[i] = min(leftMin[i - 1], nums[i])
        rightMax = [0] * n
        rightMax[n - 1] = nums[n - 1]
        for i in range(n - 2, -1, -1):
            rightMax[i] = max(rightMax[i + 1], nums[i])
        for i in range(1, n - 1):
            if leftMin[i - 1] < nums[i] < rightMax[i + 1]:
                return True
        return False
```

```JavaScript [sol1-JavaScript]
var increasingTriplet = function(nums) {
    const n = nums.length;
    if (n < 3) {
        return false;
    }
    const leftMin = new Array(n).fill(0);
    leftMin[0] = nums[0];
    for (let i = 1; i < n; i++) {
        leftMin[i] = Math.min(leftMin[i - 1], nums[i]);
    }
    const rightMax = new Array(n).fill(0);
    rightMax[n - 1] = nums[n - 1];
    for (let i = n - 2; i >= 0; i--) {
        rightMax[i] = Math.max(rightMax[i + 1], nums[i]);
    }
    for (let i = 1; i < n - 1; i++) {
        if (nums[i] > leftMin[i - 1] && nums[i] < rightMax[i + 1]) {
            return true;
        }
    }
    return false;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要遍历数组三次。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要创建两个长度为 $n$ 的数组 $\textit{leftMin}$ 和 $\textit{rightMax}$。

#### 方法二：贪心

可以使用贪心的方法将空间复杂度降到 $O(1)$。从左到右遍历数组 $\textit{nums}$，遍历过程中维护两个变量 $\textit{first}$ 和 $\textit{second}$，分别表示递增的三元子序列中的第一个数和第二个数，任何时候都有 $\textit{first} < \textit{second}$。

初始时，$\textit{first} = \textit{nums}[0]$，$\textit{second} = +\infty$。对于 $1 \le i < n$，当遍历到下标 $i$ 时，令 $\textit{num} = \textit{nums}[i]$，进行如下操作：

1. 如果 $\textit{num} > \textit{second}$，则找到了一个递增的三元子序列，返回 $\text{true}$；

2. 否则，如果 $\textit{num} > \textit{first}$，则将 $\textit{second}$ 的值更新为 $\textit{num}$；

3. 否则，将 $\textit{first}$ 的值更新为 $\textit{num}$。

如果遍历结束时没有找到递增的三元子序列，返回 $\text{false}$。

上述做法的贪心思想是：为了找到递增的三元子序列，$\textit{first}$ 和 $\textit{second}$ 应该尽可能地小，此时找到递增的三元子序列的可能性更大。

假设 $(\textit{first}, \textit{second}, \textit{num})$ 是一个递增的三元子序列，如果存在 $\textit{second'}$ 满足 $\textit{first} < \textit{second'} < \textit{second}$ 且 $\textit{second'}$ 的下标位于 $\textit{first}$ 的下标和 $\textit{num}$ 的下标之间，则 $(\textit{first}, \textit{second'}, \textit{num})$ 也是一个递增的三元子序列。但是当 $(\textit{first}, \textit{second'}, \textit{num})$ 是递增的三元子序列时，由于 $\textit{num}$ 不一定大于 $\textit{second}$，因此 $(\textit{first}, \textit{second}, \textit{num})$ 未必是递增的三元子序列。由此可见，为了使找到递增的三元子序列的可能性更大，三元子序列的第二个数应该尽可能地小，将 $\textit{second'}$ 作为三元子序列的第二个数优于将 $\textit{second}$ 作为三元子序列的第二个数。

同理可得，三元子序列的第一个数也应该尽可能地小。

如果遍历过程中遇到的所有元素都大于 $\textit{first}$，则当遇到 $\textit{num} > \textit{second}$ 时，$\textit{first}$ 一定出现在 $\textit{second}$ 的前面，$\textit{second}$ 一定出现在 $\textit{num}$ 的前面，$(\textit{first}, \textit{second}, \textit{num})$ 即为递增的三元子序列。

如果遍历过程中遇到小于 $\textit{first}$ 的元素，则会用该元素更新 $\textit{first}$，虽然更新后的 $\textit{first}$ 出现在 $\textit{second}$ 的后面，但是在 $\textit{second}$ 的前面一定存在一个元素 $\textit{first'}$ 小于 $\textit{second}$，因此当遇到 $\textit{num} > \textit{second}$ 时，$(\textit{first'}, \textit{second}, \textit{num})$ 即为递增的三元子序列。

根据上述分析可知，当遇到 $\textit{num} > \textit{second}$ 时，一定存在一个递增的三元子序列，该三元子序列的第二个数和第三个数分别是 $\textit{second}$ 和 $\textit{num}$，因此返回 $\text{true}$。

```Java [sol2-Java]
class Solution {
    public boolean increasingTriplet(int[] nums) {
        int n = nums.length;
        if (n < 3) {
            return false;
        }
        int first = nums[0], second = Integer.MAX_VALUE;
        for (int i = 1; i < n; i++) {
            int num = nums[i];
            if (num > second) {
                return true;
            } else if (num > first) {
                second = num;
            } else {
                first = num;
            }
        }
        return false;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool IncreasingTriplet(int[] nums) {
        int n = nums.Length;
        if (n < 3) {
            return false;
        }
        int first = nums[0], second = int.MaxValue;
        for (int i = 1; i < n; i++) {
            int num = nums[i];
            if (num > second) {
                return true;
            } else if (num > first) {
                second = num;
            } else {
                first = num;
            }
        }
        return false;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    bool increasingTriplet(vector<int>& nums) {
        int n = nums.size();
        if (n < 3) {
            return false;
        }
        int first = nums[0], second = INT_MAX;
        for (int i = 1; i < n; i++) {
            int num = nums[i];
            if (num > second) {
                return true;
            } else if (num > first) {
                second = num;
            } else {
                first = num;
            }
        }
        return false;
    }
};
```

```C [sol2-C]
bool increasingTriplet(int* nums, int numsSize){
    if (numsSize < 3) {
        return false;
    }
    int first = nums[0], second = INT_MAX;
    for (int i = 1; i < numsSize; i++) {
        int num = nums[i];
        if (num > second) {
            return true;
        } else if (num > first) {
            second = num;
        } else {
            first = num;
        }
    }
    return false;
}
```

```go [sol2-Golang]
func increasingTriplet(nums []int) bool {
    n := len(nums)
    if n < 3 {
        return false
    }
    first, second := nums[0], math.MaxInt32
    for i := 1; i < n; i++ {
        num := nums[i]
        if num > second {
            return true
        } else if num > first {
            second = num
        } else {
            first = num
        }
    }
    return false
}
```

```Python [sol2-Python3]
class Solution:
    def increasingTriplet(self, nums: List[int]) -> bool:
        n = len(nums)
        if n < 3:
            return False
        first, second = nums[0], float('inf')
        for i in range(1, n):
            num = nums[i]
            if num > second:
                return True
            if num > first:
                second = num
            else:
                first = num
        return False
```

```JavaScript [sol2-JavaScript]
var increasingTriplet = function(nums) {
    const n = nums.length;
    if (n < 3) {
        return false;
    }
    let first = nums[0], second = Number.MAX_VALUE;
    for (let i = 1; i < n; i++) {
        const num = nums[i];
        if (num > second) {
            return true;
        } else if (num > first) {
            second = num;
        } else {
            first = num;
        }
    }
    return false;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要遍历数组一次。

- 空间复杂度：$O(1)$。
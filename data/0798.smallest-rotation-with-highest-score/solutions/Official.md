## [798.得分最高的最小轮调 中文官方题解](https://leetcode.cn/problems/smallest-rotation-with-highest-score/solutions/100000/de-fen-zui-gao-de-zui-xiao-lun-diao-by-l-hbtd)

#### 方法一：差分数组

**思路和算法**

最简单的做法是遍历每个可能的 $k$，计算轮调 $k$ 个位置之后的数组得分。假设数组的长度是 $n$，则有 $n$ 种可能的轮调，对于每种轮调都需要 $O(n)$ 的时间计算得分，总时间复杂度是 $O(n^2)$，对于 $n \le 10^5$ 的数据范围会超出时间限制，因此需要优化。

对于数组 $\textit{nums}$ 中的元素 $x$，当 $x$ 所在下标大于或等于 $x$ 时，元素 $x$ 会记 $1$ 分。因此元素 $x$ 记 $1$ 分的下标范围是 $[x, n - 1]$，有 $n - x$ 个下标，元素 $x$ 不计分的下标范围是 $[0, x - 1]$，有 $x$ 个下标。

假设元素 $x$ 的初始下标为 $i$，则当轮调下标为 $k$ 时，元素 $x$ 位于下标 $(i - k + n) \bmod n$。如果元素 $x$ 记 $1$ 分，则有 $(i - k + n) \bmod n \ge x$，等价于 $k \le (i - x + n) \bmod n$。由于元素 $x$ 记 $1$ 分的下标有 $n - x$ 个，因此有 $k \ge (i + 1) \bmod n$。

将取模运算去掉之后，可以得到 $k$ 的实际取值范围：

- 当 $i < x$ 时，$i + 1 \le k \le i - x + n$；

- 当 $i \ge x$ 时，$k \ge i + 1$ 或 $k \le i - x$。

对于数组 $\textit{nums}$ 中的每个元素，都可以根据元素值与元素所在下标计算该元素记 $1$ 分的轮调下标范围。遍历所有元素之后，即可得到每个轮调下标对应的计 $1$ 分的元素个数，计 $1$ 分的元素个数最多的轮调下标即为得分最高的轮调下标。如果存在多个得分最高的轮调下标，则取其中最小的轮调下标。

创建长度为 $n$ 的数组 $\textit{points}$，其中 $\textit{points}[k]$ 表示轮调下标为 $k$ 时的得分。对于数组 $\textit{nums}$ 中的每个元素，得到该元素记 $1$ 分的轮调下标范围，然后将数组 $\textit{points}$ 的该下标范围内的所有元素加 $1$。当数组 $\textit{points}$ 中的元素值确定后，找到最大元素的最小下标。该做法的时间复杂度仍然是 $O(n^2)$，为了降低时间复杂度，需要利用差分数组。

假设元素 $x$ 的初始下标为 $i$。当 $i < x$ 时应将 $\textit{points}$ 的下标范围 $[i + 1, i - x + n]$ 内的所有元素加 $1$，当 $i \ge x$ 时应将 $\textit{points}$ 的下标范围 $[0, i - x]$ 和 $[i + 1, n - 1]$ 内的所有元素加 $1$。由于是将一段或两段连续下标范围内的元素加 $1$，因此可以使用差分数组实现。定义长度为 $n$ 的差分数组 $\textit{diffs}$，其中 $\textit{diffs}[k] = \textit{points}[k] - \textit{points}[k - 1]$（特别地，$\textit{points}[-1] = 0$），具体做法是：令 $\textit{low} = (i + 1) \bmod n$，$\textit{high} = (i - x + n + 1) \bmod n$，将 $\textit{diffs}[\textit{low}]$ 的值加 $1$，将 $\textit{diffs}[\textit{high}]$ 的值减 $1$，如果 $\textit{low} \ge \textit{high}$ 则将 $\textit{diffs}[0]$ 的值加 $1$。

遍历数组 $\textit{nums}$ 的所有元素并更新差分数组之后，遍历数组 $\textit{diffs}$ 并计算前缀和，则每个下标处的前缀和表示当前轮调下标处的得分。在遍历过程中维护最大得分和最大得分的最小轮调下标，遍历结束之后即可得到结果。

实现方面，不需要显性创建数组 $\textit{points}$，只需要创建差分数组 $\textit{diffs}$，遍历数组 $\textit{diffs}$ 时即可根据前缀和得到数组 $\textit{points}$ 中的每个元素值。

**证明**

差分数组做法的正确性证明需要考虑 $\textit{low}$ 和 $\textit{high}$ 的不同情况。

1. 如果 $\textit{low} \le \textit{high} - 1 < n - 1$，则有 $\textit{low} < \textit{high} < n$，更新 $\textit{diffs}$ 等价于将数组 $\textit{points}$ 的下标范围 $[\textit{low}, \textit{high} - 1]$ 内的所有元素加 $1$。

2. 如果 $\textit{low} \le \textit{high} + n - 1 = n - 1$，则有 $0 = \textit{high} \le \textit{low}$，更新 $\textit{diffs}$ 等价于将数组 $\textit{points}$ 的下标范围 $[\textit{low}, n - 1]$ 内的所有元素加 $1$，$\textit{diffs}[0]$ 先减 $1$ 后加 $1$ 因此 $\textit{diffs}[0]$ 没有变化，同第 1 种情况。

3. 如果 $\textit{low} \ge \textit{high} \ne 0$，则需要将 $\textit{diffs}[0]$ 加 $1$，更新 $\textit{diffs}$ 等价于将数组 $\textit{points}$ 的下标范围 $[\textit{low}, n - 1]$ 和 $[0, \textit{high} - 1]$ 内的所有元素加 $1$。

上述三种情况对应的更新数组 $\textit{points}$ 的效果都符合预期，因此差分数组的做法可以得到正确的结果。

**代码**

```Java [sol1-Java]
class Solution {
    public int bestRotation(int[] nums) {
        int n = nums.length;
        int[] diffs = new int[n];
        for (int i = 0; i < n; i++) {
            int low = (i + 1) % n;
            int high = (i - nums[i] + n + 1) % n;
            diffs[low]++;
            diffs[high]--;
            if (low >= high) {
                diffs[0]++;
            }
        }
        int bestIndex = 0;
        int maxScore = 0;
        int score = 0;
        for (int i = 0; i < n; i++) {
            score += diffs[i];
            if (score > maxScore) {
                bestIndex = i;
                maxScore = score;
            }
        }
        return bestIndex;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int BestRotation(int[] nums) {
        int n = nums.Length;
        int[] diffs = new int[n];
        for (int i = 0; i < n; i++) {
            int low = (i + 1) % n;
            int high = (i - nums[i] + n + 1) % n;
            diffs[low]++;
            diffs[high]--;
            if (low >= high) {
                diffs[0]++;
            }
        }
        int bestIndex = 0;
        int maxScore = 0;
        int score = 0;
        for (int i = 0; i < n; i++) {
            score += diffs[i];
            if (score > maxScore) {
                bestIndex = i;
                maxScore = score;
            }
        }
        return bestIndex;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int bestRotation(vector<int>& nums) {
        int n = nums.size();
        vector<int> diffs(n);
        for (int i = 0; i < n; i++) {
            int low = (i + 1) % n;
            int high = (i - nums[i] + n + 1) % n;
            diffs[low]++;
            diffs[high]--;
            if (low >= high) {
                diffs[0]++;
            }
        }
        int bestIndex = 0;
        int maxScore = 0;
        int score = 0;
        for (int i = 0; i < n; i++) {
            score += diffs[i];
            if (score > maxScore) {
                bestIndex = i;
                maxScore = score;
            }
        }
        return bestIndex;
    }
};
```

```C [sol1-C]
int bestRotation(int* nums, int numsSize){
    int * diffs = (int *)malloc(sizeof(int) * numsSize);
    memset(diffs, 0, sizeof(int) * numsSize);
    for (int i = 0; i < numsSize; i++) {
        int low = (i + 1) % numsSize;
        int high = (i - nums[i] + numsSize + 1) % numsSize;
        diffs[low]++;
        diffs[high]--;
        if (low >= high) {
            diffs[0]++;
        }
    }
    int bestIndex = 0;
    int maxScore = 0;
    int score = 0;
    for (int i = 0; i < numsSize; i++) {
        score += diffs[i];
        if (score > maxScore) {
            bestIndex = i;
            maxScore = score;
        }
    }
    free(diffs);
    return bestIndex;
}
```

```Python [sol1-Python3]
class Solution:
    def bestRotation(self, nums: List[int]) -> int:
        n = len(nums)
        diffs = [0] * n
        for i, num in enumerate(nums):
            low = (i + 1) % n
            high = (i - num + n + 1) % n
            diffs[low] += 1
            diffs[high] -= 1
            if low >= high:
                diffs[0] += 1
        score, maxScore, idx = 0, 0, 0
        for i, diff in enumerate(diffs):
            score += diff
            if score > maxScore:
                maxScore, idx = score, i
        return idx
```

```go [sol1-Golang]
func bestRotation(nums []int) int {
    n := len(nums)
    diffs := make([]int, n)
    for i, num := range nums {
        low := (i + 1) % n
        high := (i - num + n + 1) % n
        diffs[low]++
        diffs[high]--
        if low >= high {
            diffs[0]++
        }
    }
    score, maxScore, idx := 0, 0, 0
    for i, diff := range diffs {
        score += diff
        if score > maxScore {
            maxScore, idx = score, i
        }
    }
    return idx
}
```

```JavaScript [sol1-JavaScript]
var bestRotation = function(nums) {
    const n = nums.length;
    const diffs = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        const low = (i + 1) % n;
        const high = (i - nums[i] + n + 1) % n;
        diffs[low]++;
        diffs[high]--;
        if (low >= high) {
            diffs[0]++;
        }
    }
    let bestIndex = 0;
    let maxScore = 0;
    let score = 0;
    for (let i = 0; i < n; i++) {
        score += diffs[i];
        if (score > maxScore) {
            bestIndex = i;
            maxScore = score;
        }
    }
    return bestIndex;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要遍历数组 $\textit{nums}$ 两次。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。需要创建长度为 $n$ 的数组 $\textit{diffs}$。
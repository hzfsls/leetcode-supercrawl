#### 方法一：滑动窗口

由于规定了子数组的长度为 $k$，因此可以通过寻找子数组的最大元素和的方式寻找子数组的最大平均数，元素和最大的子数组对应的平均数也是最大的。证明如下：

> 假设两个不同的子数组的长度都是 $k$，这两个子数组的元素和分别是 $x$ 和 $y$，则这两个子数组的平均数分别是 $x/k$ 和 $y/k$。如果 $x \ge y$，则有 $x/k \ge y/k$，即如果一个子数组的元素和更大，则该子数组的平均数也更大。

为了找到子数组的最大元素和，需要对数组中的每个长度为 $k$ 的子数组分别计算元素和。对于长度为 $n$ 的数组，当 $k \le n$ 时，有 $n-k+1$ 个长度为 $k$ 的子数组。如果直接计算每个子数组的元素和，则时间复杂度过高，无法通过全部测试用例，因此需要使用时间复杂度更低的方法计算每个子数组的元素和。

用 $\textit{sum}_i$ 表示数组 $\textit{nums}$ 以下标 $i$ 结尾的长度为 $k$ 的子数组的元素和，其中 $i \ge k-1$，则 $\textit{sum}_i$ 的计算方法如下：

$$
\textit{sum}_i=\sum\limits_{j=i-k+1}^i \textit{nums}[j]
$$

当 $i>k-1$ 时，将上式的 $i$ 替换成 $i-1$，可以得到以下算式：

$$
\textit{sum}_{i-1}=\sum\limits_{j=i-k}^{i-1} \textit{nums}[j]
$$

将上述两个算式相减，可以得到如下关系：

$$
\textit{sum}_i-\textit{sum}_{i-1}=\textit{nums}[i]-\textit{nums}[i-k]
$$

整理得到：

$$
\textit{sum}_i=\textit{sum}_{i-1}-\textit{nums}[i-k]+\textit{nums}[i]
$$

上述过程可以看成维护一个长度为 $k$ 的滑动窗口。当滑动窗口从下标范围 $[i-k,i-1]$ 移动到下标范围 $[i-k+1,i]$ 时，$\textit{nums}[i-k]$ 从窗口中移出，$\textit{nums}[i]$ 进入到窗口内。

利用上述关系，可以在 $O(1)$ 的时间内通过 $\textit{sum}_{i-1}$ 得到 $\textit{sum}_i$。

第一个子数组的元素和 $\textit{sum}_{k-1}$ 需要通过计算 $\textit{nums}$ 的前 $k$ 个元素之和得到，从 $\textit{sum}_k$ 到 $\textit{sum}_{n-1}$ 的值则可利用上述关系快速计算得到。只需要遍历数组 $\textit{nums}$ 一次即可得到每个长度为 $k$ 的子数组的元素和，时间复杂度是 $O(n)$。

在上述过程中维护最大的子数组元素和，记为 $\textit{maxSum}$，子数组的最大平均数即为 $\textit{maxSum}/k$。需要注意返回值是浮点型，因此计算除法时需要进行数据类型转换。

<![ppt1](https://assets.leetcode-cn.com/solution-static/643/1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/643/2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/643/3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/643/4.png),![ppt5](https://assets.leetcode-cn.com/solution-static/643/5.png),![ppt6](https://assets.leetcode-cn.com/solution-static/643/6.png)>

```Java [sol1-Java]
class Solution {
    public double findMaxAverage(int[] nums, int k) {
        int sum = 0;
        int n = nums.length;
        for (int i = 0; i < k; i++) {
            sum += nums[i];
        }
        int maxSum = sum;
        for (int i = k; i < n; i++) {
            sum = sum - nums[i - k] + nums[i];
            maxSum = Math.max(maxSum, sum);
        }
        return 1.0 * maxSum / k;
    }
}
```

```JavaScript [sol1-JavaScript]
var findMaxAverage = function(nums, k) {
    let sum = 0;
    const n = nums.length;
    for (let i = 0; i < k; i++) {
        sum += nums[i];
    }
    let maxSum = sum;
    for (let i = k; i < n; i++) {
        sum = sum - nums[i - k] + nums[i];
        maxSum = Math.max(maxSum, sum);
    }
    return maxSum / k;
};
```

```C++ [sol1-C++]
class Solution {
public:
    double findMaxAverage(vector<int>& nums, int k) {
        int sum = 0;
        int n = nums.size();
        for (int i = 0; i < k; i++) {
            sum += nums[i];
        }
        int maxSum = sum;
        for (int i = k; i < n; i++) {
            sum = sum - nums[i - k] + nums[i];
            maxSum = max(maxSum, sum);
        }
        return static_cast<double>(maxSum) / k;
    }
};
```

```go [sol1-Golang]
func findMaxAverage(nums []int, k int) float64 {
    sum := 0
    for _, v := range nums[:k] {
        sum += v
    }
    maxSum := sum
    for i := k; i < len(nums); i++ {
        sum = sum - nums[i-k] + nums[i]
        maxSum = max(maxSum, sum)
    }
    return float64(maxSum) / float64(k)
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
    def findMaxAverage(self, nums: List[int], k: int) -> float:
        maxTotal = total = sum(nums[:k])
        n = len(nums)

        for i in range(k, n):
            total = total - nums[i - k] + nums[i]
            maxTotal = max(maxTotal, total)
        
        return maxTotal / k
```

```C [sol1-C]
double findMaxAverage(int* nums, int numsSize, int k) {
    int sum = 0;
    for (int i = 0; i < k; i++) {
        sum += nums[i];
    }
    int maxSum = sum;
    for (int i = k; i < numsSize; i++) {
        sum = sum - nums[i - k] + nums[i];
        maxSum = fmax(maxSum, sum);
    }
    return (double)(maxSum) / k;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。遍历数组一次。

- 空间复杂度：$O(1)$。
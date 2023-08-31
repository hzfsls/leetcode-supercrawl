## [396.旋转函数 中文官方题解](https://leetcode.cn/problems/rotate-function/solutions/100000/xuan-zhuan-shu-zu-by-leetcode-solution-s0wd)

#### 方法一：迭代

**思路**

记数组 $\textit{nums}$ 的元素之和为 $\textit{numSum}$。根据公式，可以得到：

- $F(0) = 0 \times \textit{nums}[0] + 1 \times \textit{nums}[1] + \ldots + (n-1) \times \textit{nums}[n-1]$
- $F(1) = 1 \times \textit{nums}[0] + 2 \times \textit{nums}[1] + \ldots + 0 \times \textit{nums}[n-1] = F(0) + \textit{numSum} - n \times \textit{nums}[n-1]$

更一般地，当 $1 \le k \lt n$ 时，$F(k) = F(k-1) + \textit{numSum} - n \times \textit{nums}[n-k]$。我们可以不停迭代计算出不同的 $F(k)$，并求出最大值。

**代码**

```Python [sol1-Python3]
class Solution:
    def maxRotateFunction(self, nums: List[int]) -> int:
        f, n, numSum = 0, len(nums), sum(nums)
        for i, num in enumerate(nums):
            f += i * num
        res = f
        for i in range(n - 1, 0, -1):
            f = f + numSum - n * nums[i]
            res = max(res, f)
        return res
```

```Java [sol1-Java]
class Solution {
    public int maxRotateFunction(int[] nums) {
        int f = 0, n = nums.length, numSum = Arrays.stream(nums).sum();
        for (int i = 0; i < n; i++) {
            f += i * nums[i];
        }
        int res = f;
        for (int i = n - 1; i > 0; i--) {
            f += numSum - n * nums[i];
            res = Math.max(res, f);
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MaxRotateFunction(int[] nums) {
        int f = 0, n = nums.Length, numSum = nums.Sum();
        for (int i = 0; i < n; i++) {
            f += i * nums[i];
        }
        int res = f;
        for (int i = n - 1; i > 0; i--) {
            f += numSum - n * nums[i];
            res = Math.Max(res, f);
        }
        return res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int maxRotateFunction(vector<int>& nums) {
        int f = 0, n = nums.size();
        int numSum = accumulate(nums.begin(), nums.end(), 0);
        for (int i = 0; i < n; i++) {
            f += i * nums[i];
        }
        int res = f;
        for (int i = n - 1; i > 0; i--) {
            f += numSum - n * nums[i];
            res = max(res, f);
        }
        return res;
    }
};
```

```C [sol1-C]
#define MAX(a, b) ((a) > (b) ? (a) : (b))

int maxRotateFunction(int* nums, int numsSize){
    int f = 0, numSum = 0;
    for (int i = 0; i < numsSize; i++) {
        f += i * nums[i];
        numSum += nums[i];
    }
    int res = f;
    for (int i = numsSize - 1; i > 0; i--) {
        f += numSum - numsSize * nums[i];
        res = MAX(res, f);
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var maxRotateFunction = function(nums) {
    let f = 0, n = nums.length, numSum = _.sum(nums);
    for (let i = 0; i < n; i++) {
        f += i * nums[i];
    }
    let res = f;
    for (let i = n - 1; i > 0; i--) {
        f += numSum - n * nums[i];
        res = Math.max(res, f);
    }
    return res;
};
```

```go [sol1-Golang]
func maxRotateFunction(nums []int) int {
    numSum := 0
    for _, v := range nums {
        numSum += v
    }
    f := 0
    for i, num := range nums {
        f += i * num
    }
    ans := f
    for i := len(nums) - 1; i > 0; i-- {
        f += numSum - len(nums)*nums[i]
        ans = max(ans, f)
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

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。计算 $\textit{numSum}$ 和第一个 $f$ 消耗 $O(n)$ 时间，后续迭代 $n-1$ 次 $f$ 消耗 $O(n)$ 时间。

- 空间复杂度：$O(1)$。仅使用常数空间。
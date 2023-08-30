#### 方法一：数学

根据子序列的定义，我们可以知道数组元素的顺序对最终结果无影响，因此我们首先对数组从小到大进行排序。对于两个元素 $\textit{nums}[i]$ 和 $\textit{nums}[j]$，其中 $i \lt j$，以 $\textit{nums}[i]$ 和 $\textit{nums}[j]$ 为最小值和最大值的子序列数目（两个元素相等时，我们以下标大小判断元素大小）为 $2^{j-i-1}$。那么所有以 $\textit{nums}[j]$ 为最大值的子序列宽度之和为（长度为 $1$ 的子序列对结果无影响）：

$$
\begin{aligned}
B_j &= \sum_{i \lt j} {(\textit{nums}[j] - \textit{nums}[i]) \times 2^{j-i-1}} \\
&= \sum_{i \lt j}{\textit{nums}[j] \times 2^{j-i-1}} - \sum_{i \lt j}{\textit{nums}[i] \times 2^{j-i-1}} \\
&= \textit{nums}[j] \times (2^j - 1) - \sum_{i \lt j}{\textit{nums}[i] \times 2^{j-i-1}}
\end{aligned}
$$

记 $x_j = \sum_{i \lt j}{\textit{nums}[i] \times 2^{j-i-1}}$，那么：
$$
\begin{aligned}
x_{j+1} &= \sum_{i \lt j+1}{\textit{nums}[i] \times 2^{j-i}} \\
&= \sum_{i \lt j}{\textit{nums}[i] \times 2^{j-i}} + \textit{nums}[j] \\
&= 2 \times x_j + \textit{nums}[j]
\end{aligned}
$$

因此 $B_{j+1}$ 的结果可以利用计算 $B_j$ 时的部分数据来计算，记 $y_j = 2^j$，那么 $B_j=\textit{nums}[j] \times (y_j-1) - x_j$，$B_{j+1}=\textit{nums}[j+1] \times (y_{j+1}-1) - x_{j+1}$，由上面的推导可知 $y_{j+1}=2 \times y_j$，$x_{j+1}=2\times x_j + \textit{nums}[j]$。所有子序列的宽度之和就是所有 $B_j$ 的和。

```Python [sol1-Python3]
class Solution:
    def sumSubseqWidths(self, nums: List[int]) -> int:
        nums.sort()
        res = 0
        MOD = 10 ** 9 + 7
        x, y = nums[0], 2
        for j in range(1, len(nums)):
            res = (res + nums[j] * (y - 1) - x) % MOD
            x = (x * 2 + nums[j]) % MOD
            y = y * 2 % MOD
        return (res + MOD) % MOD
```

```C++ [sol1-C++]
class Solution {
public:
    int sumSubseqWidths(vector<int>& nums) {
        sort(nums.begin(), nums.end());
        long long res = 0, mod = 1e9 + 7;
        long long x = nums[0], y = 2;
        for (int j = 1; j < nums.size(); j++) {
            res = (res + nums[j] * (y - 1) - x) % mod;
            x = (x * 2 + nums[j]) % mod;
            y = y * 2 % mod;
        }
        return (res + mod) % mod;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int sumSubseqWidths(int[] nums) {
        final int MOD = 1000000007;
        Arrays.sort(nums);
        long res = 0;
        long x = nums[0], y = 2;
        for (int j = 1; j < nums.length; j++) {
            res = (res + nums[j] * (y - 1) - x) % MOD;
            x = (x * 2 + nums[j]) % MOD;
            y = y * 2 % MOD;
        }
        return (int) ((res + MOD) % MOD);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int SumSubseqWidths(int[] nums) {
        const int MOD = 1000000007;
        Array.Sort(nums);
        long res = 0;
        long x = nums[0], y = 2;
        for (int j = 1; j < nums.Length; j++) {
            res = (res + nums[j] * (y - 1) - x) % MOD;
            x = (x * 2 + nums[j]) % MOD;
            y = y * 2 % MOD;
        }
        return (int) ((res + MOD) % MOD);
    }
}
```

```C [sol1-C]
static int cmp(const void *pa, const void *pb) {
    return *(int *)pa - *(int *)pb;
}

int sumSubseqWidths(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    long long res = 0, mod = 1e9 + 7;
    long long x = nums[0], y = 2;
    for (int j = 1; j < numsSize; j++) {
        res = (res + nums[j] * (y - 1) - x) % mod;
        x = (x * 2 + nums[j]) % mod;
        y = y * 2 % mod;
    }
    return (res + mod) % mod;
}
```

```JavaScript [sol1-JavaScript]
var sumSubseqWidths = function(nums) {
    const MOD = 1000000007;
    nums.sort((a, b) => a - b);
    let res = 0;
    let x = nums[0], y = 2;
    for (let j = 1; j < nums.length; j++) {
        res = (res + nums[j] * (y - 1) - x) % MOD;
        x = (x * 2 + nums[j]) % MOD;
        y = y * 2 % MOD;
    }
    return (res + MOD) % MOD;
};
```

```go [sol1-Golang]
func sumSubseqWidths(nums []int) int {
    const mod int = 1e9 + 7
    sort.Ints(nums)
    res, x, y := 0, nums[0], 2
    for _, num := range nums[1:] {
        res = (res + num*(y-1) - x) % mod
        x = (x*2 + num) % mod
        y = y * 2 % mod
    }
    return (res + mod) % mod
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。排序需要 $O(n \log n)$，求解所有 $B_j$ 需要 $O(n)$。

+ 空间复杂度：$O(\log n)$。排序需要 $O(\log n)$ 的栈空间。
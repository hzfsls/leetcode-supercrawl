## [713.乘积小于 K 的子数组 中文官方题解](https://leetcode.cn/problems/subarray-product-less-than-k/solutions/100000/cheng-ji-xiao-yu-k-de-zi-shu-zu-by-leetc-92wl)
#### 方法一：二分查找

**思路与算法**

子数组 $[i, j]$ 的元素乘积小于 $k$，即 $\prod_{l=i}^{j} \textit{nums}[l] \lt k$。

+ $k = 0$

    由于元素均为正数，所有子数组乘积均大于 $0$，因此乘积小于 $0$ 的子数组的数目为 $0$。

+ $k > 0$

    我们在计算子数组 $[i, j]$ 的元素乘积 $\prod_{l=i}^{j} \textit{nums}[l]$ 时，会出现整型溢出的情况。为了避免整型溢出，我们将不等式两边取对数得 $\log \prod_{l=i}^{j} \textit{nums}[l] = \sum_{l=i}^{j} \log \textit{nums}[l] \lt \log k$，因此「子数组 $[i, j]$ 的元素乘积小于 $k$」等价于「子数组 $[i, j]$ 的元素对数和小于 $\log k$」。

    我们预处理出数组的元素对数前缀和 $\textit{logPrefix}$，即 $\textit{logPrefix}[i + 1] = \sum_{l=0}^{i} \log \textit{nums}[l]$。因为 $\textit{nums}$ 是正整数数组，所以 $\textit{logPrefix}$ 是非递减的。

    枚举子数组的右端点 $j$，在 $\textit{logPrefix}$ 的区间 $[0, j]$ 内二分查找满足 $\textit{logPrefix}[j + 1] - \textit{logPrefix}[l] \lt \log k$ 即 $\textit{logPrefix}[l] \gt \textit{logPrefix}[j + 1] - \log k$ 的最小下标 $l$，那么以 $j$ 为右端点且元素乘积小于 $k$ 的子数组数目为 $j + 1 - l$。返回所有数目之和。

    > $\texttt{double}$ 类型只能保证 $15$ 位有效数字是精确的。为了避免计算带来的误差，我们将不等式 $\textit{logPrefix}[l] \gt \textit{logPrefix}[j + 1] - \log k$ 的右边加上 $10^{-10}$（题目中的 $\texttt{double}$ 数值整数部分的数字不超过 $5$ 个），即 $\textit{logPrefix}[l] \gt \textit{logPrefix}[j + 1] - \log k + 10^{-10}$，从而防止不等式两边数值相等却被判定为大于的情况。

**代码**

```Python [sol1-Python3]
class Solution:
    def numSubarrayProductLessThanK(self, nums: List[int], k: int) -> int:
        if k == 0:
            return 0
        ans, n = 0, len(nums)
        logPrefix = [0] * (n + 1)
        for i, num in enumerate(nums):
            logPrefix[i + 1] = logPrefix[i] + log(num)
        logK = log(k)
        for j in range(1, n + 1):
            l = bisect_right(logPrefix, logPrefix[j] - logK + 1e-10, 0, j)
            ans += j - l
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    int numSubarrayProductLessThanK(vector<int>& nums, int k) {
        if (k == 0) {
            return 0;
        }
        int n = nums.size();
        vector<double> logPrefix(n + 1);
        for (int i = 0; i < n; i++) {
            logPrefix[i + 1] = logPrefix[i] + log(nums[i]);
        }
        double logk = log(k);
        int ret = 0;
        for (int j = 0; j < n; j++) {
            int l = upper_bound(logPrefix.begin(), logPrefix.begin() + j + 1, logPrefix[j + 1] - log(k) + 1e-10) - logPrefix.begin();
            ret += j + 1 - l;
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int numSubarrayProductLessThanK(int[] nums, int k) {
        if (k == 0) {
            return 0;
        }
        int n = nums.length;
        double[] logPrefix = new double[n + 1];
        for (int i = 0; i < n; i++) {
            logPrefix[i + 1] = logPrefix[i] + Math.log(nums[i]);
        }
        double logk = Math.log(k);
        int ret = 0;
        for (int j = 0; j < n; j++) {
            int l = 0;
            int r = j + 1;
            int idx = j + 1;
            double val = logPrefix[j + 1] - logk + 1e-10;
            while (l <= r) {
                int mid = (l + r) / 2;
                if (logPrefix[mid] > val) {
                    idx = mid;
                    r = mid - 1;
                } else {
                    l = mid + 1;
                }
            }
            ret += j + 1 - idx;
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumSubarrayProductLessThanK(int[] nums, int k) {
        if (k == 0) {
            return 0;
        }
        int n = nums.Length;
        double[] logPrefix = new double[n + 1];
        for (int i = 0; i < n; i++) {
            logPrefix[i + 1] = logPrefix[i] + Math.Log(nums[i]);
        }
        double logk = Math.Log(k);
        int ret = 0;
        for (int j = 0; j < n; j++) {
            int l = 0;
            int r = j + 1;
            int idx = j + 1;
            double val = logPrefix[j + 1] - logk + 1e-10;
            while (l <= r) {
                int mid = (l + r) / 2;
                if (logPrefix[mid] > val) {
                    idx = mid;
                    r = mid - 1;
                } else {
                    l = mid + 1;
                }
            }
            ret += j + 1 - idx;
        }
        return ret;
    }
}
```

```C [sol1-C]
int numSubarrayProductLessThanK(int* nums, int numsSize, int k){
    if (k == 0) {
        return 0;
    }
    double *logPrefix = (double *)malloc(sizeof(double) * (numsSize + 1));
    for (int i = 0; i < numsSize; i++) {
        logPrefix[i + 1] = logPrefix[i] + log(nums[i]);
    }
    double logk = log(k);
    int ret = 0;
    for (int j = 0; j < numsSize; j++) {
        int l = 0;
        int r = j + 1;
        int idx = j + 1;
        double val = logPrefix[j + 1] - logk + 1e-10;
        while (l <= r) {
            int mid = (l + r) / 2;
            if (logPrefix[mid] > val) {
                idx = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        ret += j + 1 - idx;
    }
    free(logPrefix);
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var numSubarrayProductLessThanK = function(nums, k) {
    if (k === 0) {
        return 0;
    }
    const n = nums.length;
    const logPrefix = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) {
        logPrefix[i + 1] = logPrefix[i] + Math.log(nums[i]);
    }
    const logk = Math.log(k);
    let ret = 0;
    for (let j = 0; j < n; j++) {
        let l = 0;
        let r = j + 1;
        let idx = j + 1;
        const val = logPrefix[j + 1] - logk + 1e-10;
        while (l <= r) {
            const mid = Math.floor((l + r) / 2);
            if (logPrefix[mid] > val) {
                idx = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        ret += j + 1 - idx;
    }
    return ret;
};
```

```go [sol1-Golang]
func numSubarrayProductLessThanK(nums []int, k int) (ans int) {
    if k == 0 {
        return
    }
    n := len(nums)
    logPrefix := make([]float64, n+1)
    for i, num := range nums {
        logPrefix[i+1] = logPrefix[i] + math.Log(float64(num))
    }
    logK := math.Log(float64(k))
    for j := 1; j <= n; j++ {
        l := sort.SearchFloat64s(logPrefix[:j], logPrefix[j]-logK+1e-10)
        ans += j - l
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(n \log n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。预处理数组 $\textit{logPrefix}$ 需要 $O(n)$，枚举加二分查找需要 $O(n \log n)$。

+ 空间复杂度：$O(n)$。保存数组 $\textit{logPrefix}$ 需要 $O(n)$ 的空间。

#### 方法二：滑动窗口

**思路与算法**

我们固定子数组 $[i, j]$ 的右端点 $j$ 时，显然左端点 $i$ 越大，子数组元素乘积越小。对于子数组 $[i, j]$，当左端点 $i \ge l_1$ 时，所有子数组的元素乘积都小于 $k$，当左端点 $i \lt l_1$ 时，所有子数组的元素乘积都大于等于 $k$。那么对于右端点为 $j + 1$ 的所有子数组，它的左端点 $i$ 就不需要从 $0$ 开始枚举，因为对于所有 $i \lt l_1$ 的子数组，它们的元素乘积都大于等于 $k$。我们只要从 $i = l_1$ 处开始枚举，直到子数组 $i = l_2$ 时子数组 $[l_2, j + 1]$ 的元素乘积小于 $k$，那么左端点 $i \ge l_2$ 所有子数组的元素乘积都小于 $k$。

根据上面的分析，我们枚举子数组的右端点 $j$，并且左端点从 $i = 0$ 开始，用 $\textit{prod}$ 记录子数组 $[i, j]$ 的元素乘积。每枚举一个右端点 $j$，如果当前子数组元素乘积 $\textit{prod}$ 大于等于 $k$，那么我们右移左端点 $i$ 直到满足当前子数组元素乘积小于 $k$ 或者 $i > j$，那么元素乘积小于 $k$ 的子数组数目为 $j - i + 1$。返回所有数目之和。

> $\textit{prod}$ 的值始终不超过 $k \times \max_l \{\textit{nums}[l] \}$，因此无需担心整型溢出的问题。

**代码**

```Python [sol2-Python3]
class Solution:
    def numSubarrayProductLessThanK(self, nums: List[int], k: int) -> int:
        ans, prod, i = 0, 1, 0
        for j, num in enumerate(nums):
            prod *= num
            while i <= j and prod >= k:
                prod //= nums[i]
                i += 1
            ans += j - i + 1
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int numSubarrayProductLessThanK(vector<int>& nums, int k) {
        int n = nums.size(), ret = 0;
        int prod = 1, i = 0;
        for (int j = 0; j < n; j++) {
            prod *= nums[j];
            while (i <= j && prod >= k) {
                prod /= nums[i];
                i++;
            }
            ret += j - i + 1;
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int numSubarrayProductLessThanK(int[] nums, int k) {
        int n = nums.length, ret = 0;
        int prod = 1, i = 0;
        for (int j = 0; j < n; j++) {
            prod *= nums[j];
            while (i <= j && prod >= k) {
                prod /= nums[i];
                i++;
            }
            ret += j - i + 1;
        }
        return ret;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int NumSubarrayProductLessThanK(int[] nums, int k) {
        int n = nums.Length, ret = 0;
        int prod = 1, i = 0;
        for (int j = 0; j < n; j++) {
            prod *= nums[j];
            while (i <= j && prod >= k) {
                prod /= nums[i];
                i++;
            }
            ret += j - i + 1;
        }
        return ret;
    }
}
```

```C [sol2-C]
int numSubarrayProductLessThanK(int* nums, int numsSize, int k){
    int ret = 0;
    int prod = 1, i = 0;
    for (int j = 0; j < numsSize; j++) {
        prod *= nums[j];
        while (i <= j && prod >= k) {
            prod /= nums[i];
            i++;
        }
        ret += j - i + 1;
    }
    return ret;
}
```

```JavaScript [sol2-JavaScript]
var numSubarrayProductLessThanK = function(nums, k) {
    let n = nums.length, ret = 0;
    let prod = 1, i = 0;
    for (let j = 0; j < n; j++) {
        prod *= nums[j];
        while (i <= j && prod >= k) {
            prod /= nums[i];
            i++;
        }
        ret += j - i + 1;
    }
    return ret;
};
```

```go [sol2-Golang]
func numSubarrayProductLessThanK(nums []int, k int) (ans int) {
    prod, i := 1, 0
    for j, num := range nums {
        prod *= num
        for ; i <= j && prod >= k; i++ {
            prod /= nums[i]
        }
        ans += j - i + 1
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{nums}$ 的长度。两个端点 $i$ 和 $j$ 的增加次数都不超过 $n$。

+ 空间复杂度：$O(1)$。
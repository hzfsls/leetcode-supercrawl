## [2681.英雄的力量 中文官方题解](https://leetcode.cn/problems/power-of-heroes/solutions/100000/ying-xiong-de-li-liang-by-leetcode-solut-9k1g)

#### 方法一：动态规划 + 前缀和

**思路与算法**

题目给出一个长度为 $n$ 的数组 $\textit{nums}$，我们需要求出所有可能的非空子序列的「英雄组的力量」之和。因为我们的目标是全部子序列的「英雄组的力量」之和，并且「英雄组的力量」与给定的自序列中的最小值和最大值有关，所以我们不妨将给定的数组 $\textit{nums}$ 进行排序。

现在我们考虑如何计算以某一个 $\textit{nums}[i]$，$0 < i < n$（排序后，下同）结尾的全部子序列的「英雄组的力量」之和。由于以 $\textit{nums}[i]$ 结尾的子序列的最大值一定是 $\textit{nums}[i]$，所以我们只用考虑全部子序列中的最小值之和。我们用 $\textit{dp}[j]$ 表示以 $\textit{nums}[j]$ 结尾的子序列的最小值之和，由于以 $\textit{nums}[i]$ 结尾的子序列可以由以 $\textit{nums}[0], \dots, \textit{nums}[i - 1]$ 结尾的子序列最后加上 $\textit{nums}[i]$，以及单独一个 $\textit{nums}[i]$ 得到，有

$$\textit{dp}[i] = \textit{nums}[i] + \sum_{j = 0}^{i - 1}\textit{dp}[j] \tag{1}$$

那么以 $\textit{nums}[i]$ 结尾的全部子序列的「英雄组的力量」之和为

$$\textit{nums}[i] \times \textit{nums}[i] \times \textit{dp}[i] \tag{2}$$

最后 $(\sum_{i = 0}^{n - 1} \textit{nums}[i] \times \textit{nums}[i] \times \textit{dp}[i]) \bmod (10^9 + 7)$ 即为答案。

以上在 $(1)$ 中计算 $\textit{dp}[i]$ 需要 $O(n)$ 的时间复杂度，总的复杂度会达到 $O(n^2)$，将会超时，我们可以考虑用「前缀和」进行优化：我们用 $\textit{pre\_sum}[i + 1]$ 来表示 $\sum_{j = 0}^{i}\textit{dp}[j]$，特殊地记 $\textit{pre\_sum}[0] = 0$，有

$$\textit{pre\_sum}[i + 1] = \textit{pre\_sum}[i] + \textit{dp}[i] \tag{3}$$

进一步 $(1)$ 可以优化为

$$\textit{dp}[i] = \textit{nums}[i] + \textit{pre\_sum}[i] \tag{4}$$

由 $(3)$ 和 $(4)$ 我们就可以在 $O(1)$ 的时间完成对 $\textit{pre\_sum}[i + 1]$ 和 $\textit{dp}[i]$ 的计算。又因为 $\textit{dp}[i]$ 和 $\textit{pre\_sum}[i]$ 的计算只与前一个状态有关，所以在代码实现的过程中，我们可以用「滚动数组」的方式来进行空间优化。

**代码**

未空间优化版

```Python [sol11-Python3]
class Solution:
    def sumOfPower(self, nums: List[int]) -> int:
        nums.sort()
        dp = [0 for i in range(len(nums))]
        pre_sum = [0 for i in range(len(nums) + 1)]
        res, mod = 0, 10 ** 9 + 7
        for i in range(len(nums)):
            dp[i] = (nums[i] + pre_sum[i]) % mod
            pre_sum[i + 1] = (pre_sum[i] + dp[i]) % mod
            res = (res + nums[i] * nums[i] * dp[i]) % mod
        return res
```

```Java [sol11-Java]
class Solution {
    public int sumOfPower(int[] nums) {
        Arrays.sort(nums);
        int[] dp = new int[nums.length];
        int[] preSum = new int[nums.length + 1];
        int res = 0, mod = 1000000007;
        for (int i = 0; i < nums.length; i++) {
            dp[i] = (nums[i] + preSum[i]) % mod;
            preSum[i + 1] = (preSum[i] + dp[i]) % mod;
            res = (int) ((res + (long) nums[i] * nums[i] % mod * dp[i]) % mod);
            if (res < 0) {
                res += mod;
            }
        }
        return res;
    }
}
```

```C# [sol11-C#]
public class Solution {
    public int SumOfPower(int[] nums) {
        Array.Sort(nums);
        int[] dp = new int[nums.Length];
        int[] preSum = new int[nums.Length + 1];
        int res = 0, mod = 1000000007;
        for (int i = 0; i < nums.Length; i++) {
            dp[i] = (nums[i] + preSum[i]) % mod;
            preSum[i + 1] = (preSum[i] + dp[i]) % mod;
            res = (int) ((res + (long) nums[i] * nums[i] % mod * dp[i]) % mod);
            if (res < 0) {
                res += mod;
            }
        }
        return res;
    }
}
```

```C++ [sol11-C++]
class Solution {
public:
    int sumOfPower(vector<int>& nums) {
        int n = nums.size();
        sort(nums.begin(), nums.end());
        vector<int> dp(n);
        vector<int> preSum(n + 1);
        int res = 0, mod = 1e9 + 7;
        for (int i = 0; i < n; i++) {
            dp[i] = (nums[i] + preSum[i]) % mod;
            preSum[i + 1] = (preSum[i] + dp[i]) % mod;
            res = (int) ((res + (long long) nums[i] * nums[i] % mod * dp[i]) % mod);
            if (res < 0) {
                res += mod;
            }
        }
        return res;
    }
};
```

```C [sol11-C]
static int cmp(const void *a, const void *b) {
    return *(int *)a - *(int *)b;
}

int sumOfPower(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int dp[numsSize], preSum[numsSize + 1];
    memset(preSum, 0, sizeof(preSum));
    int res = 0, mod = 1e9 + 7;
    for (int i = 0; i < numsSize; i++) {
        dp[i] = (nums[i] + preSum[i]) % mod;
        preSum[i + 1] = (preSum[i] + dp[i]) % mod;
        res = (int) ((res + (long long) nums[i] * nums[i] % mod * dp[i]) % mod);
        if (res < 0) {
            res += mod;
        }
    }
    return res;
}
```

```Go [sol11-Go]
func sumOfPower(nums []int) int {
    n := len(nums)
    sort.Ints(nums)
    dp := make([]int, n)
    preSum := make([]int, n + 1)
    res := 0
    mod := int(1e9 + 7)
    for i := 0; i < n; i++ {
        dp[i] = (nums[i] + preSum[i]) % mod
        preSum[i+1] = (preSum[i] + dp[i]) % mod
        res = (res + (nums[i] * nums[i] % mod * dp[i]) % mod) % mod
    }
    return res
}
```

```JavaScript [sol11-JavaScript]
var sumOfPower = function(nums) {
    let n = nums.length, res = 0;
    nums.sort((a, b) => a - b);
    const mod = Math.pow(10, 9) + 7;
    let dp = new Array(n).fill(0);
    let preSum = new Array(n + 1).fill(0);
    for (let i = 0; i < n; i++) {
        dp[i] = (nums[i] + preSum[i]) % mod;
        preSum[i + 1] = (preSum[i] + dp[i]) % mod;
        res = (res + Number(BigInt(nums[i]) * BigInt(nums[i]) * BigInt(dp[i]) % BigInt(mod))) % mod;
    }
    return res;
};
```

「滚动数组」空间优化版

```Python [sol12-Python3]
class Solution:
    def sumOfPower(self, nums: List[int]) -> int:
        nums.sort()
        dp, pre_sum = 0, 0
        res, mod = 0, 10 ** 9 + 7
        for i in range(len(nums)):
            dp = (nums[i] + pre_sum) % mod
            pre_sum = (pre_sum + dp) % mod
            res = (res + nums[i] * nums[i] * dp) % mod
        return res
```

```Java [sol12-Java]
class Solution {
    public int sumOfPower(int[] nums) {
        Arrays.sort(nums);
        int dp = 0, preSum = 0;
        int res = 0, mod = 1000000007;
        for (int i = 0; i < nums.length; i++) {
            dp = (nums[i] + preSum) % mod;
            preSum = (preSum + dp) % mod;
            res = (int) ((res + (long) nums[i] * nums[i] % mod * dp) % mod);
            if (res < 0) {
                res += mod;
            }
        }
        return res;
    }
}
```

```C# [sol12-C#]
public class Solution {
    public int SumOfPower(int[] nums) {
        Array.Sort(nums);
        int dp = 0, preSum = 0;
        int res = 0, mod = 1000000007;
        for (int i = 0; i < nums.Length; i++) {
            dp = (nums[i] + preSum) % mod;
            preSum = (preSum + dp) % mod;
            res = (int) ((res + (long) nums[i] * nums[i] % mod * dp) % mod);
            if (res < 0) {
                res += mod;
            }
        }
        return res;
    }
}
```

```C++ [sol12-C++]
class Solution {
public:
    int sumOfPower(vector<int>& nums) {
        int n = nums.size();
        sort(nums.begin(), nums.end());
        int dp = 0, preSum = 0; 
        int res = 0, mod = 1e9 + 7;
        for (int i = 0; i < n; i++) {
            dp = (nums[i] + preSum) % mod;
            preSum = (preSum + dp) % mod;
            res = (int) ((res + (long long) nums[i] * nums[i] % mod * dp) % mod);
            if (res < 0) {
                res += mod;
            }
        }
        return res;
    }
};
```

```C [sol12-C]
static int cmp(const void *a, const void *b) {
    return *(int *)a - *(int *)b;
}

int sumOfPower(int* nums, int numsSize) {
    qsort(nums, numsSize, sizeof(int), cmp);
    int dp = 0, preSum = 0;
    int res = 0, mod = 1e9 + 7;
    for (int i = 0; i < numsSize; i++) {
        dp = (nums[i] + preSum) % mod;
        preSum = (preSum + dp) % mod;
        res = (int) ((res + (long long) nums[i] * nums[i] % mod * dp) % mod);
        if (res < 0) {
            res += mod;
        }
    }
    return res;
}
```

```Go [sol12-Go]
func sumOfPower(nums []int) int {
    n := len(nums)
    sort.Ints(nums)
    dp := 0
    preSum := 0
    res := 0
    mod := int(1e9 + 7)
    for i := 0; i < n; i++ {
        dp = (nums[i] + preSum) % mod
        preSum = (preSum + dp) % mod
        res = (res + (nums[i] * nums[i] % mod * dp) % mod) % mod
    }
    return res
}
```

```JavaScript [sol12-JavaScript]
var sumOfPower = function(nums) {
    let n = nums.length;
    nums.sort((a, b) => a - b);
    let dp = 0, preSum = 0;
    let res = 0, mod = 1e9 + 7;
    for (let i = 0; i < n; i++) {
        dp = (nums[i] + preSum) % mod;
        preSum = (preSum + dp) % mod;
        res = (res + Number(BigInt(nums[i]) * BigInt(nums[i]) * BigInt(dp) % BigInt(mod))) % mod;
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。排序需要 $O(n \log n)$ 的时间，动态规划需要 $O(n)$ 的时间。
- 空间复杂度：$O(\log n)$，其中 $n$ 为数组 $\textit{nums}$ 的长度。排序需要 $O(\log n)$ 的递归调用栈空间，动态规划通过「滚动数组」优化后仅使用常量空间。
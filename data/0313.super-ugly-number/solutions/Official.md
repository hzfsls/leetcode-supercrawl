#### 前言

这道题和「[264. 丑数 II](https://leetcode-cn.com/problems/ugly-number-ii)」相似，区别在于，第 264 题规定丑数是只包含质因数 $2$、$3$ 和 $5$ 的正整数，这道题规定超级丑数是只包含数组 $\textit{primes}$ 中的质因数的正整数。

第 264 题的方法包括最小堆和动态规划。由于这道题的数据规模较大，因此最小堆的解法会超时，此处只提供动态规划的解法。

#### 方法一：动态规划

定义数组 $\textit{dp}$，其中 $\textit{dp}[i]$ 表示第 $i$ 个超级丑数，第 $n$ 个超级丑数即为 $\textit{dp}[n]$。

由于最小的超级丑数是 $1$，因此 $\textit{dp}[1]=1$。

如何得到其余的超级丑数呢？创建与数组 $\textit{primes}$ 相同长度的数组 $\textit{pointers}$，表示下一个超级丑数是当前指针指向的超级丑数乘以对应的质因数。初始时，数组 $\textit{pointers}$ 的元素值都是 $1$。

当 $2 \le i \le n$ 时，令 $\textit{dp}[i]=\underset{0 \le j < m}{\min} \{\textit{dp}[\textit{pointers}[j]] \times \textit{primes}[j]\}$，然后对于每个 $0 \le j < m$，分别比较 $\textit{dp}[i]$ 和 $\textit{dp}[\textit{pointers}[j]] \times \textit{primes}[j]$ 是否相等，如果相等则将 $\textit{pointers}[j]$ 加 $1$。

**正确性证明**

对于 $i>1$，在计算 $\textit{dp}[i]$ 时，指针 $\textit{pointers}[j](0 \le j < m)$ 的含义是使得 $\textit{dp}[k] \times \textit{primes}[j] > \textit{dp}[i-1]$ 的最小的下标 $k$，即当 $k \ge \textit{pointers}[j]$ 时 $\textit{dp}[k] \times \textit{primes}[j] > \textit{dp}[i-1]$，当 $k<\textit{pointers}[j]$ 时 $\textit{dp}[k] \times \textit{primes}[j] \le \textit{dp}[i-1]$。

因此，对于 $i>1$，在计算 $\textit{dp}[i]$ 时，对任意 $0 \le j < m$，$\textit{dp}[\textit{pointers}[j]] \times \textit{primes}[j]$ 都大于 $\textit{dp}[i-1]$，$\textit{dp}[\textit{pointers}[j]-1] \times \textit{primes}[j]$ 都小于或等于 $\textit{dp}[i-1]$。令 $\textit{dp}[i]=\underset{0 \le j < m}{\min} \{\textit{dp}[\textit{pointers}[j]] \times \textit{primes}[j]\}$，则 $\textit{dp}[i]>\textit{dp}[i-1]$ 且 $\textit{dp}[i]$ 是大于 $\textit{dp}[i-1]$ 的最小的超级丑数。

在计算 $\textit{dp}[i]$ 之后，会更新数组 $\textit{pointers}$ 中的指针，更新之后的指针将用于计算 $\textit{dp}[i+1]$，同样满足 $\textit{dp}[i+1]>\textit{dp}[i]$ 且 $\textit{dp}[i+1]$ 是大于 $\textit{dp}[i]$ 的最小的超级丑数。

<![figp1](https://assets.leetcode-cn.com/solution-static/313/p1.png),![figp2](https://assets.leetcode-cn.com/solution-static/313/p2.png),![figp3](https://assets.leetcode-cn.com/solution-static/313/p3.png),![figp4](https://assets.leetcode-cn.com/solution-static/313/p4.png),![figp5](https://assets.leetcode-cn.com/solution-static/313/p5.png),![figp6](https://assets.leetcode-cn.com/solution-static/313/p6.png),![figp7](https://assets.leetcode-cn.com/solution-static/313/p7.png),![figp8](https://assets.leetcode-cn.com/solution-static/313/p8.png),![figp9](https://assets.leetcode-cn.com/solution-static/313/p9.png)>

```Java [sol1-Java]
class Solution {
    public int nthSuperUglyNumber(int n, int[] primes) {
        int[] dp = new int[n + 1];
        int m = primes.length;
        int[] pointers = new int[m];
        int[] nums = new int[m];
        Arrays.fill(nums, 1);
        for (int i = 1; i <= n; i++) {
            int minNum = Arrays.stream(nums).min().getAsInt();
            dp[i] = minNum;
            for (int j = 0; j < m; j++) {
                if (nums[j] == minNum) {
                    pointers[j]++;
                    nums[j] = dp[pointers[j]] * primes[j];
                }
            }
        }
        return dp[n];
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NthSuperUglyNumber(int n, int[] primes) {
        int[] dp = new int[n + 1];
        int m = primes.Length;
        int[] pointers = new int[m];
        int[] nums = new int[m];
        Array.Fill(nums, 1);
        for (int i = 1; i <= n; i++) {
            int minNum = nums.Min();
            dp[i] = minNum;
            for (int j = 0; j < m; j++) {
                if (nums[j] == minNum) {
                    pointers[j]++;
                    nums[j] = dp[pointers[j]] * primes[j];
                }
            }
        }
        return dp[n];
    }
}
```

```JavaScript [sol1-JavaScript]
var nthSuperUglyNumber = function(n, primes) {
    const dp = new Array(n + 1).fill(0);
    const m = primes.length;
    const pointers = new Array(m).fill(0);
    const nums = new Array(m).fill(1);
    for (let i = 1; i <= n; i++) {
        let minNum = Number.MAX_SAFE_INTEGER;
        for (let j = 0; j < m; j++) {
            minNum = Math.min(minNum, nums[j]);
        }
        dp[i] = minNum;
        for (let j = 0; j < m; j++) {
            if (nums[j] == minNum) {
                pointers[j]++;
                nums[j] = dp[pointers[j]] * primes[j];
            }
        }
    }
    return dp[n];
};
```

```Python [sol1-Python3]
class Solution:
    def nthSuperUglyNumber(self, n: int, primes: List[int]) -> int:
        dp = [0] * (n + 1)
        m = len(primes)
        pointers = [0] * m
        nums = [1] * m

        for i in range(1, n + 1):
            min_num = min(nums)
            dp[i] = min_num
            for j in range(m):
                if nums[j] == min_num:
                    pointers[j] += 1
                    nums[j] = dp[pointers[j]] * primes[j]
        
        return dp[n]
```

```C++ [sol1-C++]
class Solution {
public:
    int nthSuperUglyNumber(int n, vector<int>& primes) {
        vector<long> dp(n + 1);
        int m = primes.size();
        vector<int> pointers(m, 0);
        vector<long> nums(m, 1);
        for (int i = 1; i <= n; i++) {
            long minNum = INT_MAX;
            for (int j = 0; j < m; j++) {
                minNum = min(minNum, nums[j]);
            }
            dp[i] = minNum;
            for (int j = 0; j < m; j++) {
                if (nums[j] == minNum) {
                    pointers[j]++;
                    nums[j] = dp[pointers[j]] * primes[j];
                }
            }
        }
        return dp[n];
    }
};
```

```C [sol1-C]
int nthSuperUglyNumber(int n, int* primes, int primesSize) {
    long dp[n + 1];
    int pointers[primesSize];
    for (int i = 0; i < primesSize; i++) {
        pointers[i] = 0;
    }
    long nums[primesSize];
    for (int i = 0; i < primesSize; i++) {
        nums[i] = 1;
    }
    for (int i = 1; i <= n; i++) {
        long minNum = INT_MAX;
        for (int j = 0; j < primesSize; j++) {
            minNum = fmin(minNum, nums[j]);
        }
        dp[i] = minNum;
        for (int j = 0; j < primesSize; j++) {
            if (nums[j] == minNum) {
                pointers[j]++;
                nums[j] = dp[pointers[j]] * primes[j];
            }
        }
    }
    return dp[n];
}
```

```go [sol1-Golang]
func nthSuperUglyNumber(n int, primes []int) int {
    dp := make([]int, n+1)
    m := len(primes)
    pointers := make([]int, m)
    nums := make([]int, m)
    for i := range nums {
        nums[i] = 1
    }
    for i := 1; i <= n; i++ {
        minNum := math.MaxInt64
        for j := range pointers {
            minNum = min(minNum, nums[j])
        }
        dp[i] = minNum
        for j := range nums {
            if nums[j] == minNum {
                pointers[j]++
                nums[j] = dp[pointers[j]] * primes[j]
            }
        }
    }
    return dp[n]
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

**复杂度分析**

- 时间复杂度：$O(nm)$，其中 $n$ 是待求的超级丑数的编号，$m$ 是数组 $\textit{primes}$ 的长度。需要计算数组 $\textit{dp}$ 中的 $n$ 个元素，每个元素的计算都需要 $O(m)$ 的时间。

- 空间复杂度：$O(n+m)$，其中 $n$ 是待求的超级丑数的编号，$m$ 是数组 $\textit{primes}$ 的长度。需要创建数组 $\textit{dp}$、数组 $\textit{pointers}$ 和数组 $\textit{nums}$，空间分别是 $O(n)$、$O(m) 和 $O(m)$。
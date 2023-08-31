## [410.分割数组的最大值 中文官方题解](https://leetcode.cn/problems/split-array-largest-sum/solutions/100000/fen-ge-shu-zu-de-zui-da-zhi-by-leetcode-solution)
#### 方法一：动态规划

**思路与算法**

「将数组分割为 $m$ 段，求……」是动态规划题目常见的问法。

本题中，我们可以令 $f[i][j]$ 表示将数组的前 $i$ 个数分割为 $j$ 段所能得到的最大连续子数组和的最小值。在进行状态转移时，我们可以考虑第 $j$ 段的具体范围，即我们可以枚举 $k$，其中前 $k$ 个数被分割为 $j-1$ 段，而第 $k+1$ 到第 $i$ 个数为第 $j$ 段。此时，这 $j$ 段子数组中和的最大值，就等于 $f[k][j-1]$ 与 $\textit{sub}(k+1, i)$ 中的较大值，其中 $\textit{sub}(i,j)$ 表示数组 $\textit{nums}$ 中下标落在区间 $[i,j]$ 内的数的和。

由于我们要使得子数组中和的最大值最小，因此可以列出如下的状态转移方程：

$$
f[i][j] = \min_{k=0}^{i-1} \Big\{ \max(f[k][j-1], \textit{sub}(k+1,i)) \Big\}
$$

对于状态 $f[i][j]$，由于我们不能分出空的子数组，因此合法的状态必须有 $i \geq j$。对于不合法（$i < j$）的状态，由于我们的目标是求出最小值，因此可以将这些状态全部初始化为一个很大的数。在上述的状态转移方程中，一旦我们尝试从不合法的状态 $f[k][j-1]$ 进行转移，那么 $\max(\cdots)$ 将会是一个很大的数，就不会对最外层的 $\min\{\cdots\}$ 产生任何影响。

此外，我们还需要将 $f[0][0]$ 的值初始化为 $0$。在上述的状态转移方程中，当 $j=1$ 时，唯一的可能性就是前 $i$ 个数被分成了一段。如果枚举的 $k=0$，那么就代表着这种情况；如果 $k \neq 0$，对应的状态 $f[k][0]$ 是一个不合法的状态，无法进行转移。因此我们需要令 $f[0][0] = 0$。

最终的答案即为 $f[n][m]$。

```C++ [sol1-C++]
class Solution {
public:
    int splitArray(vector<int>& nums, int m) {
        int n = nums.size();
        vector<vector<long long>> f(n + 1, vector<long long>(m + 1, LLONG_MAX));
        vector<long long> sub(n + 1, 0);
        for (int i = 0; i < n; i++) {
            sub[i + 1] = sub[i] + nums[i];
        }
        f[0][0] = 0;
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= min(i, m); j++) {
                for (int k = 0; k < i; k++) {
                    f[i][j] = min(f[i][j], max(f[k][j - 1], sub[i] - sub[k]));
                }
            }
        }
        return (int)f[n][m];
    }
};
```

```Java [sol1-Java]
class Solution {
    public int splitArray(int[] nums, int m) {
        int n = nums.length;
        int[][] f = new int[n + 1][m + 1];
        for (int i = 0; i <= n; i++) {
            Arrays.fill(f[i], Integer.MAX_VALUE);
        }
        int[] sub = new int[n + 1];
        for (int i = 0; i < n; i++) {
            sub[i + 1] = sub[i] + nums[i];
        }
        f[0][0] = 0;
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= Math.min(i, m); j++) {
                for (int k = 0; k < i; k++) {
                    f[i][j] = Math.min(f[i][j], Math.max(f[k][j - 1], sub[i] - sub[k]));
                }
            }
        }
        return f[n][m];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def splitArray(self, nums: List[int], m: int) -> int:
        n = len(nums)
        f = [[10**18] * (m + 1) for _ in range(n + 1)]
        sub = [0]
        for elem in nums:
            sub.append(sub[-1] + elem)
        
        f[0][0] = 0
        for i in range(1, n + 1):
            for j in range(1, min(i, m) + 1):
                for k in range(i):
                    f[i][j] = min(f[i][j], max(f[k][j - 1], sub[i] - sub[k]))
        
        return f[n][m]
```

```C [sol1-C]
int splitArray(int* nums, int numsSize, int m) {
    long long f[numsSize + 1][m + 1];
    memset(f, 0x3f, sizeof(f));
    long long sub[numsSize + 1];
    memset(sub, 0, sizeof(sub));
    for (int i = 0; i < numsSize; i++) {
        sub[i + 1] = sub[i] + nums[i];
    }
    f[0][0] = 0;
    for (int i = 1; i <= numsSize; i++) {
        for (int j = 1; j <= fmin(i, m); j++) {
            for (int k = 0; k < i; k++) {
                f[i][j] = fmin(f[i][j], fmax(f[k][j - 1], sub[i] - sub[k]));
            }
        }
    }
    return (int)f[numsSize][m];
}
```

```golang [sol1-Golang]
func splitArray(nums []int, m int) int {
    n := len(nums)
    f := make([][]int, n + 1)
    sub := make([]int, n + 1)
    for i := 0; i < len(f); i++ {
        f[i] = make([]int, m + 1)
        for j := 0; j < len(f[i]); j++ {
            f[i][j] = math.MaxInt32
        }
    }
    for i := 0; i < n; i++ {
        sub[i + 1] = sub[i] + nums[i]
    }
    f[0][0] = 0
    for i := 1; i <= n; i++ {
        for j := 1; j <= min(i, m); j++ {
            for k := 0; k < i; k++ {
                f[i][j] = min(f[i][j], max(f[k][j - 1], sub[i] - sub[k]))
            }
        }
    }
    return f[n][m]
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

**复杂度分析**

* 时间复杂度：$O(n^2 \times m)$，其中 $n$ 是数组的长度，$m$ 是分成的非空的连续子数组的个数。总状态数为 $O(n \times m)$，状态转移时间复杂度 $O(n)$，所以总时间复杂度为 $O(n^2 \times m)$。

* 空间复杂度：$O(n \times m)$，为动态规划数组的开销。

#### 方法二：二分查找 + 贪心

**思路及算法**

「使……最大值尽可能小」是二分搜索题目常见的问法。

本题中，我们注意到：当我们选定一个值 $x$，我们可以线性地验证是否存在一种分割方案，满足其最大分割子数组和不超过 $x$。策略如下：

> 贪心地模拟分割的过程，从前到后遍历数组，用 $\textit{sum}$ 表示当前分割子数组的和，$\textit{cnt}$ 表示已经分割出的子数组的数量（包括当前子数组），那么每当 $\textit{sum}$ 加上当前值超过了 $x$，我们就把当前取的值作为新的一段分割子数组的开头，并将 $\textit{cnt}$ 加 $1$。遍历结束后验证是否 $\textit{cnt}$ 不超过 $m$。

这样我们可以用二分查找来解决。二分的上界为数组 $\textit{nums}$ 中所有元素的和，下界为数组 $\textit{nums}$ 中所有元素的最大值。通过二分查找，我们可以得到最小的最大分割子数组和，这样就可以得到最终的答案了。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    bool check(vector<int>& nums, int x, int m) {
        long long sum = 0;
        int cnt = 1;
        for (int i = 0; i < nums.size(); i++) {
            if (sum + nums[i] > x) {
                cnt++;
                sum = nums[i];
            } else {
                sum += nums[i];
            }
        }
        return cnt <= m;
    }

    int splitArray(vector<int>& nums, int m) {
        long long left = 0, right = 0;
        for (int i = 0; i < nums.size(); i++) {
            right += nums[i];
            if (left < nums[i]) {
                left = nums[i];
            }
        }
        while (left < right) {
            long long mid = (left + right) >> 1;
            if (check(nums, mid, m)) {
                right = mid;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int splitArray(int[] nums, int m) {
        int left = 0, right = 0;
        for (int i = 0; i < nums.length; i++) {
            right += nums[i];
            if (left < nums[i]) {
                left = nums[i];
            }
        }
        while (left < right) {
            int mid = (right - left) / 2 + left;
            if (check(nums, mid, m)) {
                right = mid;
            } else {
                left = mid + 1;
            }
        }
        return left;
    }

    public boolean check(int[] nums, int x, int m) {
        int sum = 0;
        int cnt = 1;
        for (int i = 0; i < nums.length; i++) {
            if (sum + nums[i] > x) {
                cnt++;
                sum = nums[i];
            } else {
                sum += nums[i];
            }
        }
        return cnt <= m;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def splitArray(self, nums: List[int], m: int) -> int:
        def check(x: int) -> bool:
            total, cnt = 0, 1
            for num in nums:
                if total + num > x:
                    cnt += 1
                    total = num
                else:
                    total += num
            return cnt <= m


        left = max(nums)
        right = sum(nums)
        while left < right:
            mid = (left + right) // 2
            if check(mid):
                right = mid
            else:
                left = mid + 1

        return left
```

```C [sol2-C]
bool check(int* nums, int numsSize, int m, int x) {
    long long sum = 0;
    int cnt = 1;
    for (int i = 0; i < numsSize; i++) {
        if (sum + nums[i] > x) {
            cnt++;
            sum = nums[i];
        } else {
            sum += nums[i];
        }
    }
    return cnt <= m;
}

int splitArray(int* nums, int numsSize, int m) {
    long long left = 0, right = 0;
    for (int i = 0; i < numsSize; i++) {
        right += nums[i];
        if (left < nums[i]) {
            left = nums[i];
        }
    }
    while (left < right) {
        long long mid = (left + right) >> 1;
        if (check(nums, numsSize, m, mid)) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }
    return left;
}
```

```golang [sol2-Golang]
func splitArray(nums []int, m int) int {
    left, right := 0, 0
    for i := 0; i < len(nums); i++ {
        right += nums[i]
        if left < nums[i] {
            left = nums[i]
        }
    }
    for left < right {
        mid := (right - left) / 2 + left
        if check(nums, mid, m) {
            right = mid
        } else {
            left = mid + 1
        }
    }
    return left
}

func check(nums []int, x, m int) bool {
    sum, cnt := 0, 1
    for i := 0; i < len(nums); i++ {
        if sum + nums[i] > x {
            cnt++
            sum = nums[i]
        } else {
            sum += nums[i]
        }
    }
    return cnt <= m
}
```

**复杂度分析**

* 时间复杂度：$O(n \times \log(\textit{sum}-\textit{maxn}))$，其中 $\textit{sum}$ 表示数组 $\textit{nums}$ 中所有元素的和，$\textit{maxn}$ 表示数组所有元素的最大值。每次二分查找时，需要对数组进行一次遍历，时间复杂度为 $O(n)$，因此总时间复杂度是 $O(n \times \log(\textit{sum}-\textit{maxn}))$。

* 空间复杂度：$O(1)$。
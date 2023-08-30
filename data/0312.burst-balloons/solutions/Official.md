#### 前言

为了方便处理，我们对 $\textit{nums}$ 数组稍作处理，将其两边各加上题目中假设存在的 $\textit{nums}[-1]$ 和 $\textit{nums}[n]$ ，并保存在 $\textit{val}$ 数组中，即 $\textit{val}[i]=\textit{nums}[i-1]$ 。之所以这样处理是为了处理 $\textit{nums}[-1]$ ，防止下标越界。

下文中的区间均指数组 $\textit{val}$ 上的区间。

#### 方法一：记忆化搜索

**思路及算法**

我们观察戳气球的操作，发现这会导致两个气球从不相邻变成相邻，使得后续操作难以处理。于是我们倒过来看这些操作，将全过程看作是每次添加一个气球。

我们定义方法 $\textit{solve}$，令 $\textit{solve}(i,j)$ 表示将开区间 $(i,j)$ 内的位置全部填满气球能够得到的最多硬币数。由于是开区间，因此区间两端的气球的编号就是 $i$ 和 $j$，对应着 $\textit{val}[i]$ 和 $\textit{val}[j]$。

* 当 $i \geq j-1$ 时，开区间中没有气球，$\textit{solve}(i,j)$ 的值为 $0$；

* 当 $i < j-1$ 时，我们枚举开区间 $(i,j)$ 内的全部位置 $\textit{mid}$，令 $\textit{mid}$ 为当前区间第一个添加的气球，该操作能得到的硬币数为 $\textit{val}[i] \times \textit{val}[\textit{mid}] \times val[j]$。同时我们递归地计算分割出的两区间对 $\textit{solve}(i,j)$ 的贡献，这三项之和的最大值，即为 $\textit{solve}(i,j)$ 的值。这样问题就转化为求 $\textit{solve}(i,\textit{mid})$ 和 $\textit{solve}(\textit{mid},j)$ ，可以写出方程：

$$
\textit{solve}(i,j)=
\begin{cases}{}
\displaystyle \max_{\textit{mid} = i + 1}^{j - 1}val[i] \times \textit{val}[\textit{mid}] \times \textit{val}[j] + \textit{solve}(i, \textit{mid}) + \textit{solve}(\textit{mid}, j) ,&i < j - 1 \\
0, & i \geq j - 1
\end{cases}
$$

为了防止重复计算，我们存储 $\textit{solve}$ 的结果，使用记忆化搜索的方法优化时间复杂度。

<![fig1](https://assets.leetcode-cn.com/solution-static/312/1.png),![fig2](https://assets.leetcode-cn.com/solution-static/312/2.png),![fig3](https://assets.leetcode-cn.com/solution-static/312/3.png),![fig4](https://assets.leetcode-cn.com/solution-static/312/4.png),![fig5](https://assets.leetcode-cn.com/solution-static/312/5.png),![fig6](https://assets.leetcode-cn.com/solution-static/312/6.png)>

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> rec;
    vector<int> val;

public:
    int solve(int left, int right) {
        if (left >= right - 1) {
            return 0;
        }
        if (rec[left][right] != -1) {
            return rec[left][right];
        }
        for (int i = left + 1; i < right; i++) {
            int sum = val[left] * val[i] * val[right];
            sum += solve(left, i) + solve(i, right);
            rec[left][right] = max(rec[left][right], sum);
        }
        return rec[left][right];
    }

    int maxCoins(vector<int>& nums) {
        int n = nums.size();
        val.resize(n + 2);
        for (int i = 1; i <= n; i++) {
            val[i] = nums[i - 1];
        }
        val[0] = val[n + 1] = 1;
        rec.resize(n + 2, vector<int>(n + 2, -1));
        return solve(0, n + 1);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[][] rec;
    public int[] val;

    public int maxCoins(int[] nums) {
        int n = nums.length;
        val = new int[n + 2];
        for (int i = 1; i <= n; i++) {
            val[i] = nums[i - 1];
        }
        val[0] = val[n + 1] = 1;
        rec = new int[n + 2][n + 2];
        for (int i = 0; i <= n + 1; i++) {
            Arrays.fill(rec[i], -1);
        }
        return solve(0, n + 1);
    }

    public int solve(int left, int right) {
        if (left >= right - 1) {
            return 0;
        }
        if (rec[left][right] != -1) {
            return rec[left][right];
        }
        for (int i = left + 1; i < right; i++) {
            int sum = val[left] * val[i] * val[right];
            sum += solve(left, i) + solve(i, right);
            rec[left][right] = Math.max(rec[left][right], sum);
        }
        return rec[left][right];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def maxCoins(self, nums: List[int]) -> int:
        n = len(nums)
        val = [1] + nums + [1]
        
        @lru_cache(None)
        def solve(left: int, right: int) -> int:
            if left >= right - 1:
                return 0
            
            best = 0
            for i in range(left + 1, right):
                total = val[left] * val[i] * val[right]
                total += solve(left, i) + solve(i, right)
                best = max(best, total)
            
            return best

        return solve(0, n + 1)
```

```golang [sol1-Golang]
func maxCoins(nums []int) int {
    n := len(nums)
    val := make([]int, n + 2)
    for i := 1; i <= n; i++ {
        val[i] = nums[i - 1]
    }
    val[0], val[n+1] = 1, 1
    rec := make([][]int, n + 2)
    for i := 0; i < len(rec); i++ {
        rec[i] = make([]int, n + 2)
        for j := 0; j < len(rec[i]); j++ {
            rec[i][j] = -1
        }
    }
    return solve(0, n + 1, val, rec)
}

func solve(left, right int, val []int, rec [][]int) int {
    if left >= right - 1 {
        return 0
    }
    if rec[left][right] != -1 {
        return rec[left][right]
    }
    for i := left + 1; i < right; i++ {
        sum := val[left] * val[i] * val[right]
        sum += solve(left, i, val, rec) + solve(i, right, val, rec)
        rec[left][right] = max(rec[left][right], sum)
    }
    return rec[left][right]
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

```C [sol1-C]
int rec[502][502];
int val[502];
int solve(int left, int right) {
    if (left >= right - 1) {
        return 0;
    }
    if (rec[left][right] != -1) {
        return rec[left][right];
    }
    for (int i = left + 1; i < right; i++) {
        int sum = val[left] * val[i] * val[right];
        sum += solve(left, i) + solve(i, right);
        rec[left][right] = fmax(rec[left][right], sum);
    }
    return rec[left][right];
}

int maxCoins(int* nums, int numsSize) {
    memset(rec, -1, sizeof(rec));
    val[0] = val[numsSize + 1] = 1;
    for (int i = 1; i <= numsSize; i++) {
        val[i] = nums[i - 1];
    }

    return solve(0, numsSize + 1);
}
```

**复杂度分析**

* 时间复杂度：$O(n^3)$，其中 $n$ 是气球数量。区间数为 $n^2$，区间迭代复杂度为 $O(n)$，最终复杂度为 $O(n^2 \times n) = O(n^3)$。

* 空间复杂度：$O(n^2)$，其中 $n$ 是气球数量。缓存大小为区间的个数。

#### 方法二：动态规划

**思路及算法**

按照方法一的思路，我们发现我们可以通过变换计算顺序，从「自顶向下」的记忆化搜索变为「自底向上」的动态规划。

令 $dp[i][j]$ 表示填满开区间 $(i,j)$ 能得到的最多硬币数，那么边界条件是 $i \geq j-1$，此时有 $dp[i][j]=0$。

可以写出状态转移方程：

$$
dp[i][j]=
\begin{cases}{}
\displaystyle \max_{k = i + 1}^{j - 1}val[i] \times val[k] \times val[j] + dp[i][k] + dp[k][j] ,&i < j - 1 \\
0, & i \geq j - 1
\end{cases}
$$

最终答案即为 $dp[0][n+1]$。实现时要注意到动态规划的次序。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    int maxCoins(vector<int>& nums) {
        int n = nums.size();
        vector<vector<int>> rec(n + 2, vector<int>(n + 2));
        vector<int> val(n + 2);
        val[0] = val[n + 1] = 1;
        for (int i = 1; i <= n; i++) {
            val[i] = nums[i - 1];
        }
        for (int i = n - 1; i >= 0; i--) {
            for (int j = i + 2; j <= n + 1; j++) {
                for (int k = i + 1; k < j; k++) {
                    int sum = val[i] * val[k] * val[j];
                    sum += rec[i][k] + rec[k][j];
                    rec[i][j] = max(rec[i][j], sum);
                }
            }
        }
        return rec[0][n + 1];
    }
};
```

```Java [sol2-Java]
class Solution {
    public int maxCoins(int[] nums) {
        int n = nums.length;
        int[][] rec = new int[n + 2][n + 2];
        int[] val = new int[n + 2];
        val[0] = val[n + 1] = 1;
        for (int i = 1; i <= n; i++) {
            val[i] = nums[i - 1];
        }
        for (int i = n - 1; i >= 0; i--) {
            for (int j = i + 2; j <= n + 1; j++) {
                for (int k = i + 1; k < j; k++) {
                    int sum = val[i] * val[k] * val[j];
                    sum += rec[i][k] + rec[k][j];
                    rec[i][j] = Math.max(rec[i][j], sum);
                }
            }
        }
        return rec[0][n + 1];
    }
}
```

```Python [sol2-Python3]
class Solution:
    def maxCoins(self, nums: List[int]) -> int:
        n = len(nums)
        rec = [[0] * (n + 2) for _ in range(n + 2)]
        val = [1] + nums + [1]

        for i in range(n - 1, -1, -1):
            for j in range(i + 2, n + 2):
                for k in range(i + 1, j):
                    total = val[i] * val[k] * val[j]
                    total += rec[i][k] + rec[k][j]
                    rec[i][j] = max(rec[i][j], total)
        
        return rec[0][n + 1]
```

```golang [sol2-Golang]
func maxCoins(nums []int) int {
    n := len(nums)
    rec := make([][]int, n + 2)
    for i := 0; i < n + 2; i++ {
        rec[i] = make([]int, n + 2)
    }
    val := make([]int, n + 2)
    val[0], val[n+1] = 1, 1
    for i := 1; i <= n; i++ {
        val[i] = nums[i-1]
    }
    for i := n - 1; i >= 0; i-- {
        for j := i + 2; j <= n + 1; j++ {
            for k := i + 1; k < j; k++ {
                sum := val[i] * val[k] * val[j]
                sum += rec[i][k] + rec[k][j]
                rec[i][j] = max(rec[i][j], sum)
            }
        }
    }
    return rec[0][n+1]
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

```C [sol2-C]
int maxCoins(int* nums, int numsSize) {
    int rec[numsSize + 2][numsSize + 2];
    memset(rec, 0, sizeof(rec));
    int val[numsSize + 2];
    val[0] = val[numsSize + 1] = 1;
    for (int i = 1; i <= numsSize; i++) {
        val[i] = nums[i - 1];
    }
    for (int i = numsSize - 1; i >= 0; i--) {
        for (int j = i + 2; j <= numsSize + 1; j++) {
            for (int k = i + 1; k < j; k++) {
                int sum = val[i] * val[k] * val[j];
                sum += rec[i][k] + rec[k][j];
                rec[i][j] = fmax(rec[i][j], sum);
            }
        }
    }
    return rec[0][numsSize + 1];
}
```

**复杂度分析**

* 时间复杂度：$O(n^3)$，其中 $n$ 是气球数量。状态数为 $n^2$，状态转移复杂度为 $O(n)$，最终复杂度为 $O(n^2 \times n) = O(n^3)$。

* 空间复杂度：$O(n^2)$，其中 $n$ 是气球数量。
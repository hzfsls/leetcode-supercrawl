## [486.预测赢家 中文官方题解](https://leetcode.cn/problems/predict-the-winner/solutions/100000/yu-ce-ying-jia-by-leetcode-solution)

#### 方法一：递归

为了判断哪个玩家可以获胜，需要计算一个总分，即先手得分与后手得分之差。当数组中的所有数字都被拿取时，如果总分大于或等于 $0$，则先手获胜，反之则后手获胜。

由于每次只能从数组的任意一端拿取数字，因此可以保证数组中剩下的部分一定是连续的。假设数组当前剩下的部分为下标 $\textit{start}$ 到下标 $\textit{end}$，其中 $0 \le \textit{start} \le \textit{end} < \textit{nums}.\text{length}$。如果 $\textit{start}=\textit{end}$，则只剩一个数字，当前玩家只能拿取这个数字。如果 $\textit{start}<\textit{end}$，则当前玩家可以选择 $\textit{nums}[\textit{start}]$ 或 $\textit{nums}[\textit{end}]$，然后轮到另一个玩家在数组剩下的部分选取数字。这是一个递归的过程。

计算总分时，需要记录当前玩家是先手还是后手，判断当前玩家的得分应该记为正还是负。当数组中剩下的数字多于 $1$ 个时，当前玩家会选择最优的方案，使得自己的分数最大化，因此对两种方案分别计算当前玩家可以得到的分数，其中的最大值为当前玩家最多可以得到的分数。

![fig1](https://assets.leetcode-cn.com/solution-static/486/486_fig1.png)

```Java [sol1-Java]
class Solution {
    public boolean PredictTheWinner(int[] nums) {
        return total(nums, 0, nums.length - 1, 1) >= 0;
    }

    public int total(int[] nums, int start, int end, int turn) {
        if (start == end) {
            return nums[start] * turn;
        }
        int scoreStart = nums[start] * turn + total(nums, start + 1, end, -turn);
        int scoreEnd = nums[end] * turn + total(nums, start, end - 1, -turn);
        return Math.max(scoreStart * turn, scoreEnd * turn) * turn;
    }
}
```

```C [sol1-C]
int total(int* nums, int start, int end, int turn) {
    if (start == end) {
        return nums[start] * turn;
    }
    int scoreStart = nums[start] * turn + total(nums, start + 1, end, -turn);
    int scoreEnd = nums[end] * turn + total(nums, start, end - 1, -turn);
    return fmax(scoreStart * turn, scoreEnd * turn) * turn;
}

bool PredictTheWinner(int* nums, int numsSize) {
    return total(nums, 0, numsSize - 1, 1) >= 0;
}
```

```cpp [sol1-C++]
class Solution {
public:
    bool PredictTheWinner(vector<int>& nums) {
        return total(nums, 0, nums.size() - 1, 1) >= 0;
    }

    int total(vector<int>& nums, int start, int end, int turn) {
        if (start == end) {
            return nums[start] * turn;
        }
        int scoreStart = nums[start] * turn + total(nums, start + 1, end, -turn);
        int scoreEnd = nums[end] * turn + total(nums, start, end - 1, -turn);
        return max(scoreStart * turn, scoreEnd * turn) * turn;
    }
};
```

```golang [sol1-Golang]
func PredictTheWinner(nums []int) bool {
    return total(nums, 0, len(nums) - 1, 1) >= 0
}

func total(nums []int, start, end int, turn int) int {
    if start == end {
        return nums[start] * turn
    }
    scoreStart := nums[start] * turn + total(nums, start + 1, end, -turn)
    scoreEnd := nums[end] * turn + total(nums, start, end - 1, -turn)
    return max(scoreStart * turn, scoreEnd * turn) * turn
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

```Python [sol1-Python3]
class Solution:
    def PredictTheWinner(self, nums: List[int]) -> bool:
        def total(start: int, end: int, turn: int) -> int:
            if start == end:
                return nums[start] * turn
            scoreStart = nums[start] * turn + total(start + 1, end, -turn)
            scoreEnd = nums[end] * turn + total(start, end - 1, -turn)
            return max(scoreStart * turn, scoreEnd * turn) * turn
        
        return total(0, len(nums) - 1, 1) >= 0
```

**复杂度分析**

- 时间复杂度：$O(2^n)$，其中 $n$ 是数组的长度。

- 空间复杂度：$O(n)$，其中 $n$ 是数组的长度。空间复杂度取决于递归使用的栈空间。

#### 方法二：动态规划

方法一使用递归，存在大量重复计算，因此时间复杂度很高。由于存在重复子问题，因此可以使用动态规划降低时间复杂度。

定义二维数组 $\textit{dp}$，其行数和列数都等于数组的长度，$\textit{dp}[i][j]$ 表示当数组剩下的部分为下标 $i$ 到下标 $j$ 时，即在下标范围 $[i, j]$ 中，当前玩家与另一个玩家的分数之差的最大值，注意当前玩家不一定是先手。

只有当 $i \le j$ 时，数组剩下的部分才有意义，因此当 $i>j$ 时，$\textit{dp}[i][j]=0$。

当 $i=j$ 时，只剩一个数字，当前玩家只能拿取这个数字，因此对于所有 $0 \le i < \textit{nums}.\text{length}$，都有 $\textit{dp}[i][i]=\textit{nums}[i]$。

当 $i<j$ 时，当前玩家可以选择 $\textit{nums}[i]$ 或 $\textit{nums}[j]$，然后轮到另一个玩家在数组剩下的部分选取数字。在两种方案中，当前玩家会选择最优的方案，使得自己的分数最大化。因此可以得到如下状态转移方程：

$$
\textit{dp}[i][j]=\max(\textit{nums}[i] - \textit{dp}[i + 1][j], \textit{nums}[j] - \textit{dp}[i][j - 1])
$$

最后判断 $\textit{dp}[0][\textit{nums}.\text{length}-1]$ 的值，如果大于或等于 $0$，则先手得分大于或等于后手得分，因此先手成为赢家，否则后手成为赢家。

<![fig1](https://assets.leetcode-cn.com/solution-static/486/1.png),![fig2](https://assets.leetcode-cn.com/solution-static/486/2.png),![fig3](https://assets.leetcode-cn.com/solution-static/486/3.png),![fig4](https://assets.leetcode-cn.com/solution-static/486/4.png),![fig5](https://assets.leetcode-cn.com/solution-static/486/5.png),![fig6](https://assets.leetcode-cn.com/solution-static/486/6.png),![fig7](https://assets.leetcode-cn.com/solution-static/486/7.png),![fig8](https://assets.leetcode-cn.com/solution-static/486/8.png),![fig9](https://assets.leetcode-cn.com/solution-static/486/9.png),![fig10](https://assets.leetcode-cn.com/solution-static/486/10.png),![fig11](https://assets.leetcode-cn.com/solution-static/486/11.png),![fig12](https://assets.leetcode-cn.com/solution-static/486/12.png),![fig13](https://assets.leetcode-cn.com/solution-static/486/13.png),![fig14](https://assets.leetcode-cn.com/solution-static/486/14.png),![fig15](https://assets.leetcode-cn.com/solution-static/486/15.png),![fig16](https://assets.leetcode-cn.com/solution-static/486/16.png),![fig17](https://assets.leetcode-cn.com/solution-static/486/17.png)>

```Java [sol2-Java]
class Solution {
    public boolean PredictTheWinner(int[] nums) {
        int length = nums.length;
        int[][] dp = new int[length][length];
        for (int i = 0; i < length; i++) {
            dp[i][i] = nums[i];
        }
        for (int i = length - 2; i >= 0; i--) {
            for (int j = i + 1; j < length; j++) {
                dp[i][j] = Math.max(nums[i] - dp[i + 1][j], nums[j] - dp[i][j - 1]);
            }
        }
        return dp[0][length - 1] >= 0;
    }
}
```

```C [sol2-C]
bool PredictTheWinner(int* nums, int numsSize) {
    int dp[numsSize][numsSize];
    for (int i = 0; i < numsSize; i++) {
        dp[i][i] = nums[i];
    }
    for (int i = numsSize - 2; i >= 0; i--) {
        for (int j = i + 1; j < numsSize; j++) {
            dp[i][j] = fmax(nums[i] - dp[i + 1][j], nums[j] - dp[i][j - 1]);
        }
    }
    return dp[0][numsSize - 1] >= 0;
}
```

```cpp [sol2-C++]
class Solution {
public:
    bool PredictTheWinner(vector<int>& nums) {
        int length = nums.size();
        auto dp = vector<vector<int>> (length, vector<int>(length));
        for (int i = 0; i < length; i++) {
            dp[i][i] = nums[i];
        }
        for (int i = length - 2; i >= 0; i--) {
            for (int j = i + 1; j < length; j++) {
                dp[i][j] = max(nums[i] - dp[i + 1][j], nums[j] - dp[i][j - 1]);
            }
        }
        return dp[0][length - 1] >= 0;
    }
};
```

```golang [sol2-Golang]
func PredictTheWinner(nums []int) bool {
    length := len(nums)
    dp := make([][]int, length)
    for i := 0; i < length; i++ {
        dp[i] = make([]int, length)
        dp[i][i] = nums[i]
    }
    for i := length - 2; i >= 0; i-- {
        for j := i + 1; j < length; j++ {
            dp[i][j] = max(nums[i] - dp[i + 1][j], nums[j] - dp[i][j - 1])
        }
    }
    return dp[0][length - 1] >= 0
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

```Python [sol2-Python3]
class Solution:
    def PredictTheWinner(self, nums: List[int]) -> bool:
        length = len(nums)
        dp = [[0] * length for _ in range(length)]
        for i, num in enumerate(nums):
            dp[i][i] = num
        for i in range(length - 2, -1, -1):
            for j in range(i + 1, length):
                dp[i][j] = max(nums[i] - dp[i + 1][j], nums[j] - dp[i][j - 1])
        return dp[0][length - 1] >= 0
```

上述代码中使用了二维数组 $\textit{dp}$。分析状态转移方程可以看到，$\textit{dp}[i][j]$ 的值只和 $\textit{dp}[i + 1][j]$ 与 $\textit{dp}[i][j - 1]$ 有关，即在计算 $\textit{dp}$ 的第 $i$ 行的值时，只需要使用到 $\textit{dp}$ 的第 $i$ 行和第 $i+1$ 行的值，因此可以使用一维数组代替二维数组，对空间进行优化。

```Java [sol3-Java]
class Solution {
    public boolean PredictTheWinner(int[] nums) {
        int length = nums.length;
        int[] dp = new int[length];
        for (int i = 0; i < length; i++) {
            dp[i] = nums[i];
        }
        for (int i = length - 2; i >= 0; i--) {
            for (int j = i + 1; j < length; j++) {
                dp[j] = Math.max(nums[i] - dp[j], nums[j] - dp[j - 1]);
            }
        }
        return dp[length - 1] >= 0;
    }
}
```

```C [sol3-C]
bool PredictTheWinner(int* nums, int numsSize) {
    int dp[numsSize];
    for (int i = 0; i < numsSize; i++) {
        dp[i] = nums[i];
    }
    for (int i = numsSize - 2; i >= 0; i--) {
        for (int j = i + 1; j < numsSize; j++) {
            dp[j] = fmax(nums[i] - dp[j], nums[j] - dp[j - 1]);
        }
    }
    return dp[numsSize - 1] >= 0;
}
```

```cpp [sol3-C++]
class Solution {
public:
    bool PredictTheWinner(vector<int>& nums) {
        int length = nums.size();
        auto dp = vector<int>(length);
        for (int i = 0; i < length; i++) {
            dp[i] = nums[i];
        }
        for (int i = length - 2; i >= 0; i--) {
            for (int j = i + 1; j < length; j++) {
                dp[j] = max(nums[i] - dp[j], nums[j] - dp[j - 1]);
            }
        }
        return dp[length - 1] >= 0;
    }
};
```

```golang [sol3-Golang]
func PredictTheWinner(nums []int) bool {
    length := len(nums)
    dp := make([]int, length)
    for i := 0; i < length; i++ {
        dp[i] = nums[i]
    }
    for i := length - 2; i >= 0; i-- {
        for j := i + 1; j < length; j++ {
            dp[j] = max(nums[i] - dp[j], nums[j] - dp[j - 1])
        }
    }
    return dp[length - 1] >= 0
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

```Python [sol3-Python3]
class Solution:
    def PredictTheWinner(self, nums: List[int]) -> bool:
        length = len(nums)
        dp = [0] * length
        for i, num in enumerate(nums):
            dp[i] = num
        for i in range(length - 2, -1, -1):
            for j in range(i + 1, length):
                dp[j] = max(nums[i] - dp[j], nums[j] - dp[j - 1])
        return dp[length - 1] >= 0
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是数组的长度。需要计算每个子数组对应的 $\textit{dp}$ 的值，共有 $\frac{n(n+1)}{2}$ 个子数组。

- 空间复杂度：$O(n)$，其中 $n$ 是数组的长度。空间复杂度取决于额外创建的数组 $\textit{dp}$，如果不优化空间，则空间复杂度是 $O(n^2)$，使用一维数组优化之后空间复杂度可以降至 $O(n)$。

#### 拓展练习

读者在做完这道题之后，可以做另一道类似的题：「[877. 石子游戏](https://leetcode-cn.com/problems/stone-game)」。和这道题相比，第 877 题增加了两个限制条件：

- 数组的长度是偶数；

- 数组的元素之和是奇数，所以没有平局。

对于第 877 题，除了使用这道题的解法以外，能否利用上述两个限制条件进行求解？
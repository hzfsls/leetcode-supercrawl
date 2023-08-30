### 📺 视频题解 
![983. 最低票价.mp4](571c1009-3b14-47e2-b768-c04f2aa99f2d)

### 📖 文字题解

#### 方法一：记忆化搜索（日期变量型）

**思路和算法**

我们用 $\textit{dp}(i)$ 来表示从第 $i$ 天开始到一年的结束，我们需要花的钱。考虑到一张通行证可以让我们在「接下来」的若干天进行旅行，所以我们「从后往前」倒着进行动态规划。

对于一年中的任意一天：

- 如果这一天不是必须出行的日期，那我们可以贪心地选择不买。这是因为如果今天不用出行，那么也不必购买通行证，并且通行证越晚买越好。所以有 $\textit{dp}(i) = \textit{dp}(i + 1)$；

- 如果这一天是必须出行的日期，我们可以选择买 $1$，$7$ 或 $30$ 天的通行证。若我们购买了 $j$ 天的通行证，那么接下来的 $j - 1$ 天，我们都不再需要购买通行证，只需要考虑第 $i + j$ 天及以后即可。因此，我们有

  $$
  \textit{dp}(i) = \min\{\textit{cost}(j) + \textit{dp}(i + j)\}, \quad j \in \{1, 7, 30\}
  $$

  其中 $\textit{cost}(j)$ 表示 $j$ 天通行证的价格。为什么我们只需要考虑第 $i+j$ 天及以后呢？这里和第一条的贪心思路是一样的，如果我们需要购买通行证，那么一定越晚买越好，在握着一张有效的通行证的时候购买其它的通行证显然是不划算的。

由于我们是倒着进行动态规划的，因此我们可以使用记忆化搜索，减少代码的编写难度。我们使用一个长度为 $366$ 的数组（因为天数是 $[1, 365]$，而数组的下标是从 $0$ 开始的）存储所有的动态规划结果，这样所有的 $\textit{dp}(i)$ 只会被计算一次（和普通的动态规划相同），时间复杂度不会增大。

最终的答案记为 $\textit{dp}(1)$。

```Java [sol1-Java]
class Solution {
    int[] costs;
    Integer[] memo;
    Set<Integer> dayset;

    public int mincostTickets(int[] days, int[] costs) {
        this.costs = costs;
        memo = new Integer[366];
        dayset = new HashSet();
        for (int d: days) {
            dayset.add(d);
        }
        return dp(1);
    }

    public int dp(int i) {
        if (i > 365) {
            return 0;
        }
        if (memo[i] != null) {
            return memo[i];
        }
        if (dayset.contains(i)) {
            memo[i] = Math.min(Math.min(dp(i + 1) + costs[0], dp(i + 7) + costs[1]), dp(i + 30) + costs[2]);
        } else {
            memo[i] = dp(i + 1);
        }
        return memo[i];
    }
}
```

```Python [sol1-Python3]
class Solution:
    def mincostTickets(self, days: List[int], costs: List[int]) -> int:
        dayset = set(days)
        durations = [1, 7, 30]

        @lru_cache(None)
        def dp(i):
            if i > 365:
                return 0
            elif i in dayset:
                return min(dp(i + d) + c for c, d in zip(costs, durations))
            else:
                return dp(i + 1)

        return dp(1)
```

```C++ [sol1-C++]
class Solution {
    unordered_set<int> dayset;
    vector<int> costs;
    int memo[366] = {0};

public:
    int mincostTickets(vector<int>& days, vector<int>& costs) {
        this->costs = costs;
        for (int d: days) {
            dayset.insert(d);
        }
        memset(memo, -1, sizeof(memo));
        return dp(1);
    }

    int dp(int i) {
        if (i > 365) {
            return 0;
        }
        if (memo[i] != -1) {
            return memo[i];
        }
        if (dayset.count(i)) {
            memo[i] = min(min(dp(i + 1) + costs[0], dp(i + 7) + costs[1]), dp(i + 30) + costs[2]);
        } else {
            memo[i] = dp(i + 1);
        }
        return memo[i];
    }
};
```

```golang [sol1-Golang]
func mincostTickets(days []int, costs []int) int {
    memo := [366]int{}
    dayM := map[int]bool{}
    for _, d := range days {
        dayM[d] = true
    }

    var dp func(day int) int 
    dp = func(day int) int {
        if day > 365 {
            return 0
        }
        if memo[day] > 0 {
            return memo[day]
        }
        if dayM[day] {
            memo[day] = min(min(dp(day + 1) + costs[0], dp(day + 7) + costs[1]), dp(day + 30) + costs[2])
        } else {
            memo[day] = dp(day + 1)
        }
        return memo[day]
    }
    return dp(1)
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```

**复杂度分析**

* 时间复杂度：$O(W)$，其中 $W = 365$ 是旅行计划中日期的最大值，我们需要计算 $W$ 个解，而每个解最多需要查询 $3$ 个其他的解，因此计算量为 $O(3 * W)=O(W)$。

* 空间复杂度：$O(W)$，我们需要长度为 $O(W)$ 的数组来存储所有的解。

#### 方法二：记忆化搜索（窗口变量型）

**思路**

方法一需要遍历一年中所有的天数，无论 $\textit{days}$ 的长度是多少。

但是观察方法一的递推式，我们可以看到，如果我们查询 $\textit{dp}(i)$，而第 $i$ 天我们又不需要出行的话，那么 $\textit{dp}$ 函数会一直向后计算 $\textit{dp}(i + 1) = \textit{dp}(i + 2) = \textit{dp}(i + 3)$ 一直到一年结束或者有一天我们需要出行为止。那么我们其实可以直接跳过这些不需要出行的日期，直接找到下一个需要出行的日期。

**算法**

现在，我们令 $\textit{dp}(i)$ 表示能够完成从第 $\textit{days}[i]$ 天到最后的旅行计划的最小花费（注意，不再是第 $i$ 天到最后的最小花费）。令 $j_1$ 是满足 $\textit{days}[j_1] >= \textit{days}[i] + 1$ 的最小下标，$j_7$ 是满足 $\textit{days}[j_7] >= \textit{days}[i] + 7$ 的最小下标， $j_{30}$ 是满足 $\textit{days}[j_{30}] >= \textit{days}[i] + 30$ 的最小下标，那么就有：

$$
\textit{dp}(i) = \min(\textit{dp}(j_1) + \textit{costs}[0], \textit{dp}(j_7) + \textit{costs}[1], \textit{dp}(j_{30}) + \textit{costs}[2])
$$

```Java [sol2-Java]
class Solution {
    int[] days, costs;
    Integer[] memo;
    int[] durations = new int[]{1, 7, 30};

    public int mincostTickets(int[] days, int[] costs) {
        this.days = days;
        this.costs = costs;
        memo = new Integer[days.length];
        return dp(0);
    }

    public int dp(int i) {
        if (i >= days.length) {
            return 0;
        }
        if (memo[i] != null) {
            return memo[i];
        }
        memo[i] = Integer.MAX_VALUE;
        int j = i;
        for (int k = 0; k < 3; ++k) {
            while (j < days.length && days[j] < days[i] + durations[k]) {
                j++;
            }
            memo[i] = Math.min(memo[i], dp(j) + costs[k]);
        }
        return memo[i];
    }
}
```

```Python [sol2-Python3]
class Solution:
    def mincostTickets(self, days: List[int], costs: List[int]) -> int:
        N = len(days)
        durations = [1, 7, 30]

        @lru_cache(None)
        def dp(i):
            if i >= N:
                return 0
            ans = 10**9
            j = i
            for c, d in zip(costs, durations):
                while j < N and days[j] < days[i] + d:
                    j += 1
                ans = min(ans, dp(j) + c)
            return ans

        return dp(0)
```

```C++ [sol2-C++]
class Solution {
private:
    vector<int> days, costs;
    vector<int> memo;
    int durations[3] = {1, 7, 30};
    
public:
    int mincostTickets(vector<int>& days, vector<int>& costs) {
        this->days = days;
        this->costs = costs;
        memo.assign(days.size(), -1);
        return dp(0);
    }

    int dp(int i) {
        if (i >= days.size()) {
            return 0;
        }
        if (memo[i] != -1) {
            return memo[i];
        }
        memo[i] = INT_MAX;
        int j = i;
        for (int k = 0; k < 3; ++k) {
            while (j < days.size() && days[j] < days[i] + durations[k]) {
                ++j;
            }
            memo[i] = min(memo[i], dp(j) + costs[k]);
        }
        return memo[i];
    }
};
```

```golang [sol2-Golang]
func mincostTickets(days []int, costs []int) int {
    memo := [366]int{}
    durations := []int{1, 7, 30}

    var dp func(idx int) int 
    dp = func(idx int) int {
        if idx >= len(days) {
            return 0
        }
        if memo[idx] > 0 {
            return memo[idx]
        }
        memo[idx] = math.MaxInt32
        j := idx
        for i := 0; i < 3; i++ {
            for ; j < len(days) && days[j] < days[idx] + durations[i]; j++ { }
            memo[idx] = min(memo[idx], dp(j) + costs[i])
        }
        return memo[idx]
    }
    return dp(0)
}

func min(x, y int) int {
    if x < y {
        return x
    }
    return y
}
```

**复杂度分析**

* 时间复杂度：$O(N)$，其中 $N$ 是出行日期的数量，我们需要计算 $N$ 个解，而计算每个解的过程中最多将指针挪动 $30$ 步，计算量为 $O(30 * N)=O(N)$。

* 空间复杂度：$O(N)$，我们需要长度为 $O(N)$ 的数组来存储所有的解。
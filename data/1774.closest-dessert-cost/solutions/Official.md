#### 方法一：回溯

**思路与算法**

首先题目给出长度分别为 $n$ 的冰淇淋基料数组 $\textit{baseCosts}$ 和长度为 $m$ 的配料数组 $\textit{toppingCosts}$，其中 $\textit{baseCosts}[i]$ 表示第 $i$ 种冰淇淋基料的价格，$\textit{toppingCosts}[j]$ 表示一份第 $j$ 种冰淇淋配料的价格，以及一个整数 $\textit{target}$ 表示我们需要制作甜点的目标价格。现在在制作甜品上我们需要遵守以下三条规则：

- 必须选择**一种**冰淇淋基料；
- 可以添加**一种或多种**配料，也可以不添加任何配料；
- 每种配料**最多两份**。

我们希望做的甜点总成本尽可能接近目标价格 $\textit{target}$，那么我们现在按照规则对于每一种冰淇淋基料用回溯的方式来针对它进行甜品制作。又因为每一种配料都是正整数，所以在回溯的过程中总开销只能只增不减，当回溯过程中当前开销大于目标价格 $\textit{target}$ 后，继续往下搜索只能使开销与 $\textit{target}$ 的差值更大，所以如果此时差值已经大于等于我们已有最优方案的差值，我们可以停止继续往下搜索，及时回溯。

**代码**

```Python [sol1-Python3]
class Solution:
    def closestCost(self, baseCosts: List[int], toppingCosts: List[int], target: int) -> int:
        ans = min(baseCosts)
        def dfs(p: int, cur_cost: int) -> None:
            nonlocal ans
            if abs(ans - target) < cur_cost - target:
                return
            if abs(ans - target) >= abs(cur_cost - target):
                if abs(ans - target) > abs(cur_cost - target):
                    ans = cur_cost
                else:
                    ans = min(ans, cur_cost)
            if p == len(toppingCosts):
                return
            dfs(p + 1, cur_cost + toppingCosts[p] * 2)
            dfs(p + 1, cur_cost + toppingCosts[p])
            dfs(p + 1, cur_cost)
        for c in baseCosts:
            dfs(0, c)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    void dfs(const vector<int>& toppingCosts, int p, int curCost, int& res, const int& target) {
        if (abs(res - target) < curCost - target) {
            return;
        } else if (abs(res - target) >= abs(curCost - target)) {
            if (abs(res - target) > abs(curCost - target)) {
                res = curCost;
            } else {
                res = min(res, curCost);
            }
        }
        if (p == toppingCosts.size()) {
            return;
        }
        dfs(toppingCosts, p + 1, curCost + toppingCosts[p] * 2, res, target);
        dfs(toppingCosts, p + 1, curCost + toppingCosts[p], res, target);
        dfs(toppingCosts, p + 1, curCost, res, target);
    }

    int closestCost(vector<int>& baseCosts, vector<int>& toppingCosts, int target) {
        int res = *min_element(baseCosts.begin(), baseCosts.end());
        for (auto& b : baseCosts) {
            dfs(toppingCosts, 0, b, res, target);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    int res;

    public int closestCost(int[] baseCosts, int[] toppingCosts, int target) {
        res = Arrays.stream(baseCosts).min().getAsInt();
        for (int b : baseCosts) {
            dfs(toppingCosts, 0, b, target);
        }
        return res;
    }

    public void dfs(int[] toppingCosts, int p, int curCost, int target) {
        if (Math.abs(res - target) < curCost - target) {
            return;
        } else if (Math.abs(res - target) >= Math.abs(curCost - target)) {
            if (Math.abs(res - target) > Math.abs(curCost - target)) {
                res = curCost;
            } else {
                res = Math.min(res, curCost);
            }
        }
        if (p == toppingCosts.length) {
            return;
        }
        dfs(toppingCosts, p + 1, curCost + toppingCosts[p] * 2, target);
        dfs(toppingCosts, p + 1, curCost + toppingCosts[p], target);
        dfs(toppingCosts, p + 1, curCost, target);
    }
}
```

```C# [sol1-C#]
public class Solution {
    int res;

    public int ClosestCost(int[] baseCosts, int[] toppingCosts, int target) {
        res = baseCosts.Min();
        foreach (int b in baseCosts) {
            DFS(toppingCosts, 0, b, target);
        }
        return res;
    }

    public void DFS(int[] toppingCosts, int p, int curCost, int target) {
        if (Math.Abs(res - target) < curCost - target) {
            return;
        } else if (Math.Abs(res - target) >= Math.Abs(curCost - target)) {
            if (Math.Abs(res - target) > Math.Abs(curCost - target)) {
                res = curCost;
            } else {
                res = Math.Min(res, curCost);
            }
        }
        if (p == toppingCosts.Length) {
            return;
        }
        DFS(toppingCosts, p + 1, curCost + toppingCosts[p] * 2, target);
        DFS(toppingCosts, p + 1, curCost + toppingCosts[p], target);
        DFS(toppingCosts, p + 1, curCost, target);
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

void dfs(const int *toppingCosts, int toppingCostsSize, int p, int curCost, int *res, const int target) {
    if (abs(*res - target) < curCost - target) {
        return;
    } else if (abs(*res - target) >= abs(curCost - target)) {
        if (abs(*res - target) > abs(curCost - target)) {
            *res = curCost;
        } else {
            *res = MIN(*res, curCost);
        }
    }
    if (p == toppingCostsSize) {
        return;
    }
    dfs(toppingCosts, toppingCostsSize, p + 1, curCost + toppingCosts[p] * 2, res, target);
    dfs(toppingCosts, toppingCostsSize, p + 1, curCost + toppingCosts[p], res, target);
    dfs(toppingCosts, toppingCostsSize, p + 1, curCost, res, target);
}

int closestCost(int* baseCosts, int baseCostsSize, int* toppingCosts, int toppingCostsSize, int target) {
    int res = INT_MAX;
    for (int i = 0; i < baseCostsSize; i++) {
        res = MIN(res, baseCosts[i]);
    }
    for (int i = 0; i < baseCostsSize; i++) {
        dfs(toppingCosts, toppingCostsSize, 0, baseCosts[i], &res, target);
    }
    return res;
}
```

```JavaScript [sol1-JavaScript]
var closestCost = function(baseCosts, toppingCosts, target) {
    let res = _.min(baseCosts);
    const dfs = (toppingCosts, p, curCost, target) => {
        if (Math.abs(res - target) < curCost - target) {
            return;
        } else if (Math.abs(res - target) >= Math.abs(curCost - target)) {
            if (Math.abs(res - target) > Math.abs(curCost - target)) {
                res = curCost;
            } else {
                res = Math.min(res, curCost);
            }
        }
        if (p === toppingCosts.length) {
            return;
        }
        dfs(toppingCosts, p + 1, curCost + toppingCosts[p] * 2, target);
        dfs(toppingCosts, p + 1, curCost + toppingCosts[p], target);
        dfs(toppingCosts, p + 1, curCost, target);
    };
    for (const b of baseCosts) {
        dfs(toppingCosts, 0, b, target);
    }
    return res;
}
```

```go [sol1-Golang]
func closestCost(baseCosts []int, toppingCosts []int, target int) int {
    ans := baseCosts[0]
    for _, c := range baseCosts {
        ans = min(ans, c)
    }
    var dfs func(int, int)
    dfs = func(p, curCost int) {
        if abs(ans-target) < curCost-target {
            return
        } else if abs(ans-target) >= abs(curCost-target) {
            if abs(ans-target) > abs(curCost-target) {
                ans = curCost
            } else {
                ans = min(ans, curCost)
            }
        }
        if p == len(toppingCosts) {
            return
        }
        dfs(p+1, curCost+toppingCosts[p]*2)
        dfs(p+1, curCost+toppingCosts[p])
        dfs(p+1, curCost)
    }
    for _, c := range baseCosts {
        dfs(0, c)
    }
    return ans
}

func abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(n \times 3^m)$，其中 $n$，$m$ 分别为数组 $\textit{baseCosts}$，$\textit{toppingCosts}$ 的长度。
- 空间复杂度：$O(m)$，主要为回溯递归的空间开销。

#### 方法二：动态规划

**思路与算法**

我们可以将问题转化为对于某一个开销是否存在甜品制作方案问题，然后我们选择与目标价格最接近的合法甜品制作方案即可，那么问题就转化为了「01 背包」问题（关于「01 背包」的概念可见 [百度百科](https://baike.baidu.com/item/01%E8%83%8C%E5%8C%85/4301245)）。这样我们就可以把问题求解从指数级别降到多项式级别了。对于「01 背包」的求解我们可以用「动态规划」来解决。

设最小的基料开销为 $x$。若 $x \ge \textit{target}$，则无论我们是否添加配料都不会使甜品制作的开销与目标价格 $\textit{target}$ 的距离缩小，所以此时直接返回此最小的基料开销即可。当最小的基料开销小于 $\textit{target}$ 时，我们可以对超过 $\textit{target}$ 的制作开销方案只保存其最小的一份即可，并可以初始化为 $2 \times \textit{target} - x$，因为大于该开销的方案与目标价格 $\textit{target}$ 的距离一定大于仅选最小基料的情况，所以一定不会是最优解。将背包的容量 $\textit{MAXC}$ 设置为 $\textit{target}$。然后我们按「01 背包」的方法来依次枚举配料来进行放置。

我们设 $\textit{can}[i]$ 表示对于甜品制作开销为 $i$ 是否存在合法方案，如果存在则其等于 $\text{true}$，否则为 $\text{false}$，初始为 $\text{false}$。因为单独选择一种基料的情况是合法的，所以我们对 $\textit{can}$ 进行初始化：

$$\textit{can}[x] = \text{true}, \forall x \in \textit{baseCosts} \And x < \textit{MAXC}$$

然后我们按「01 背包」的方法来依次枚举配料来进行放置，因为每种配料我们最多只能选两份，所以我们可以直接将每种配料变为两个，然后对于两个配料都进行放置即可。因为任意一个合法方案加上一份配料一定也为合法制作方案。所以当要放置的配料开销为 $y$ 时，对于开销为 $c, c > y$ 的转移方程为：

$$\textit{can}[c] = \textit{can}[c - y] ~|~ \textit{can}[c], c > y$$

因为每一个状态的求解只和前面的状态有关，所以我们可以从后往前来更新每一个状态。然后当配料全部放置后，我们可以从目标价格 $\textit{target}$ 往左搜索找到最接近 $\textit{target}$ 的合法方案并与大于 $\textit{target}$ 的方案做比较返回与 $\textit{target}$ 更接近的方案即可。

**代码**

```Python [sol2-Python3]
class Solution:
    def closestCost(self, baseCosts: List[int], toppingCosts: List[int], target: int) -> int:
        x = min(baseCosts)
        if x > target:
            return x
        can = [False] * (target + 1)
        ans = 2 * target - x
        for c in baseCosts:
            if c <= target:
                can[c] = True
            else:
                ans = min(ans, c)
        for c in toppingCosts:
            for count in range(2):
                for i in range(target, 0, -1):
                    if can[i] and i + c > target:
                        ans = min(ans, i + c)
                    if i - c > 0 and not can[i]:
                        can[i] = can[i - c]
        for i in range(ans - target + 1):
            if can[target - i]:
                return target - i
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int closestCost(vector<int>& baseCosts, vector<int>& toppingCosts, int target) {
        int x = *min_element(baseCosts.begin(), baseCosts.end());
        if (x >= target) {
            return x;
        }
        vector<bool> can(target + 1, false);
        int res = 2 * target - x;
        for (auto& b : baseCosts) {
            if (b <= target) {
                can[b] = true;
            } else {
                res = min(res, b);
            }
        }
        for (auto& t : toppingCosts) {
            for (int count = 0; count < 2; ++count) {
                for (int i = target; i; --i) {
                    if (can[i] && i + t > target) {
                        res = min(res, i + t);
                    }
                    if (i - t > 0) {
                        can[i] = can[i] | can[i - t];
                    }
                }
            }
        }
        for (int i = 0; i <= res - target; ++i) {
            if (can[target - i]) {
                return target - i;
            }
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int closestCost(int[] baseCosts, int[] toppingCosts, int target) {
        int x = Arrays.stream(baseCosts).min().getAsInt();
        if (x >= target) {
            return x;
        }
        boolean[] can = new boolean[target + 1];
        int res = 2 * target - x;
        for (int b : baseCosts) {
            if (b <= target) {
                can[b] = true;
            } else {
                res = Math.min(res, b);
            }
        }
        for (int t : toppingCosts) {
            for (int count = 0; count < 2; ++count) {
                for (int i = target; i > 0; --i) {
                    if (can[i] && i + t > target) {
                        res = Math.min(res, i + t);
                    }
                    if (i - t > 0) {
                        can[i] = can[i] | can[i - t];
                    }
                }
            }
        }
        for (int i = 0; i <= res - target; ++i) {
            if (can[target - i]) {
                return target - i;
            }
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int ClosestCost(int[] baseCosts, int[] toppingCosts, int target) {
        int x = baseCosts.Min();
        if (x >= target) {
            return x;
        }
        bool[] can = new bool[target + 1];
        int res = 2 * target - x;
        foreach (int b in baseCosts) {
            if (b <= target) {
                can[b] = true;
            } else {
                res = Math.Min(res, b);
            }
        }
        foreach (int t in toppingCosts) {
            for (int count = 0; count < 2; ++count) {
                for (int i = target; i > 0; --i) {
                    if (can[i] && i + t > target) {
                        res = Math.Min(res, i + t);
                    }
                    if (i - t > 0) {
                        can[i] = can[i] | can[i - t];
                    }
                }
            }
        }
        for (int i = 0; i <= res - target; ++i) {
            if (can[target - i]) {
                return target - i;
            }
        }
        return res;
    }
}
```

```C [sol2-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

int closestCost(int* baseCosts, int baseCostsSize, int* toppingCosts, int toppingCostsSize, int target) {
    int x = INT_MAX;
    for (int i = 0; i < baseCostsSize; i++) {
        x = MIN(x, baseCosts[i]);
    }
    if (x >= target) {
        return x;
    }
    bool can[target + 1];
    memset(can, 0, sizeof(can));
    int res = 2 * target - x;
    for (int i = 0; i < baseCostsSize; i++) {
        if (baseCosts[i] <= target) {
            can[baseCosts[i]] = true;
        } else {
            res = MIN(res, baseCosts[i]);
        }
    }
    for (int j = 0; j < toppingCostsSize; j++) {
        for (int count = 0; count < 2; ++count) {
            for (int i = target; i > 0; --i) {
                if (can[i] && i + toppingCosts[j] > target) {
                    res = MIN(res, i + toppingCosts[j]);
                }
                if (i - toppingCosts[j] > 0) {
                    can[i] = can[i] | can[i - toppingCosts[j]];
                }
            }
        }
    }
    for (int i = 0; i <= res - target; ++i) {
        if (can[target - i]) {
            return target - i;
        }
    }
    return res;
}
```

```JavaScript [sol2-JavaScript]
var closestCost = function(baseCosts, toppingCosts, target) {
    const x = _.min(baseCosts);
    if (x >= target) {
        return x;
    }
    const can = new Array(target + 1).fill(0);
    let res = 2 * target - x;
    for (const b of baseCosts) {
        if (b <= target) {
            can[b] = true;
        } else {
            res = Math.min(res, b);
        }
    }
    for (const t of toppingCosts) {
        for (let count = 0; count < 2; ++count) {
            for (let i = target; i > 0; --i) {
                if (can[i] && i + t > target) {
                    res = Math.min(res, i + t);
                }
                if (i - t > 0) {
                    can[i] = can[i] | can[i - t];
                }
            }
        }
    }
    for (let i = 0; i <= res - target; ++i) {
        if (can[target - i]) {
            return target - i;
        }
    }
    return res;
}
```

```go [sol2-Golang]
func closestCost(baseCosts []int, toppingCosts []int, target int) int {
    x := baseCosts[0]
    for _, c := range baseCosts {
        x = min(x, c)
    }
    if x > target {
        return x
    }
    can := make([]bool, target+1)
    ans := 2*target - x
    for _, c := range baseCosts {
        if c <= target {
            can[c] = true
        } else {
            ans = min(ans, c)
        }
    }
    for _, c := range toppingCosts {
        for count := 0; count < 2; count++ {
            for i := target; i > 0; i-- {
                if can[i] && i+c > target {
                    ans = min(ans, i+c)
                }
                if i-c > 0 {
                    can[i] = can[i] || can[i-c]
                }
            }
        }
    }
    for i := 0; i <= ans-target; i++ {
        if can[target-i] {
            return target - i
        }
    }
    return ans
}

func min(a, b int) int {
    if a > b {
        return b
    }
    return a
}
```

**复杂度分析**

- 时间复杂度：$O(\textit{target} \times m)$，其中 $m$ 为数组 $\textit{toppingCosts}$ 的长度，$\textit{target}$ 为目标值。动态规划的时间复杂度是 $O(\textit{MAXC} \times m)$，由于 $\textit{MAXC} = \textit{target}$，因此时间复杂度是 $O(\textit{target} \times m)$。
- 空间复杂度：$O(\textit{target})$，其中 $\textit{target}$ 为目标值。需要创建长度为 $\textit{target} + 1$ 的数组 $\textit{can}$。
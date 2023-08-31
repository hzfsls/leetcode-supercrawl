## [403.青蛙过河 中文官方题解](https://leetcode.cn/problems/frog-jump/solutions/100000/qing-wa-guo-he-by-leetcode-solution-mbuo)

#### 方法一：记忆化搜索 + 二分查找

**思路及算法**

最直接的想法是使用深度优先搜索的方式尝试所有跳跃方案，直到我们找到一组可行解为止。但是不加优化的该算法的时间复杂度在最坏情况下是指数级的，因此考虑优化。

注意到当青蛙每次能够跳跃的距离仅取决于青蛙的「上一次跳跃距离」。而青蛙此后能否到达终点，只和它「现在所处的石子编号」以及「上一次跳跃距离」有关。因此我们可以将这两个维度综合记录为一个状态。使用记忆化搜索的方式优化时间复杂度。

具体地，当青蛙位于第 $i$ 个石子，上次跳跃距离为 $\textit{lastDis}$ 时，它当前能够跳跃的距离范围为 $[\textit{lastDis}-1,\textit{lastDis}+1]$。我们需要分别判断这三个距离对应的三个位置是否存在石子。注意到给定的石子列表为升序，所以我们可以利用二分查找来优化查找石子的时间复杂度。每次我们找到了符合要求的位置，我们就尝试进行一次递归搜索即可。

为了优化编码，我们可以认为青蛙的初始状态为：「现在所处的石子编号」为 $0$（石子从 $0$ 开始编号），「上一次跳跃距离」为 $0$（这样可以保证青蛙的第一次跳跃距离为 $1$）。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<unordered_map<int, int>> rec;

    bool dfs(vector<int>& stones, int i, int lastDis) {
        if (i == stones.size() - 1) {
            return true;
        }
        if (rec[i].count(lastDis)) {
            return rec[i][lastDis];
        }
        for (int curDis = lastDis - 1; curDis <= lastDis + 1; curDis++) {
            if (curDis > 0) {
                int j = lower_bound(stones.begin(), stones.end(), curDis + stones[i]) - stones.begin();
                if (j != stones.size() && stones[j] == curDis + stones[i] && dfs(stones, j, curDis)) {
                    return rec[i][lastDis] = true;
                }
            }
        }
        return rec[i][lastDis] = false;
    }

    bool canCross(vector<int>& stones) {
        int n = stones.size();
        rec.resize(n);
        return dfs(stones, 0, 0);
    }
};
```

```Java [sol1-Java]
class Solution {
    private Boolean[][] rec;

    public boolean canCross(int[] stones) {
        int n = stones.length;
        rec = new Boolean[n][n];
        return dfs(stones, 0, 0);
    }

    private boolean dfs(int[] stones, int i, int lastDis) {
        if (i == stones.length - 1) {
            return true;
        }
        if (rec[i][lastDis] != null) {
            return rec[i][lastDis];
        }

        for (int curDis = lastDis - 1; curDis <= lastDis + 1; curDis++) {
            if (curDis > 0) {
                int j = Arrays.binarySearch(stones, i + 1, stones.length, curDis + stones[i]);
                if (j >= 0 && dfs(stones, j, curDis)) {
                    return rec[i][lastDis] = true;
                }
            }
        }
        return rec[i][lastDis] = false;
    }
}
```

```JavaScript [sol1-JavaScript]
var canCross = function(stones) {
    const n = stones.length;
    rec = new Array(n).fill(0).map(() => new Map());

    const dfs = (stones, i, lastDis) => {
        if (i === stones.length - 1) {
            return true;
        }
        if (rec[i].has(lastDis)) {
            return rec[i].get(lastDis);
        }
        for (let curDis = lastDis - 1; curDis <= lastDis + 1; curDis++) {
            if (curDis > 0) {
                const j = lower_bound(stones, curDis + stones[i]);
                if (j !== stones.length && stones[j] === curDis + stones[i] && dfs(stones, j, curDis)) {
                    rec[i].set(lastDis, true);
                    return rec[i].get(lastDis);
                }
            }
        }
        rec[i].set(lastDis, false);
        return rec[i].get(lastDis);
    }

    return dfs(stones, 0, 0);
};

function lower_bound(nums, target) {
    let lo = 0, hi = nums.length;

    while (lo < hi) {
        const mid = lo + Math.floor((hi - lo) / 2);

        if (nums[mid] >= target) {
            hi = mid;
        } else {
            lo = mid + 1;
        }
    }
    return lo;
}
```

```go [sol1-Golang]
func canCross(stones []int) bool {
    n := len(stones)
    dp := make([]map[int]bool, n-1)
    for i := range dp {
        dp[i] = map[int]bool{}
    }
    var dfs func(int, int) bool
    dfs = func(i, lastDis int) (res bool) {
        if i == n-1 {
            return true
        }
        if res, has := dp[i][lastDis]; has {
            return res
        }
        defer func() { dp[i][lastDis] = res }()
        for curDis := lastDis - 1; curDis <= lastDis+1; curDis++ {
            if curDis > 0 {
                j := sort.SearchInts(stones, curDis+stones[i])
                if j != n && stones[j] == curDis+stones[i] && dfs(j, curDis) {
                    return true
                }
            }
        }
        return false
    }
    return dfs(0, 0)
}
```

```C [sol1-C]
struct HashTable {
    int key, val;
    UT_hash_handle hh;
};

struct HashTable** rec;

bool count(struct HashTable** hashTable, int ikey) {
    struct HashTable* tmp;
    HASH_FIND_INT(*hashTable, &ikey, tmp);
    return tmp != NULL;
}

int modify(struct HashTable** hashTable, int ikey, int ival) {
    struct HashTable* tmp;
    HASH_FIND_INT(*hashTable, &ikey, tmp);
    if (tmp == NULL) {
        tmp = malloc(sizeof(struct HashTable));
        tmp->key = ikey, tmp->val = ival;
        HASH_ADD_INT(*hashTable, key, tmp);
    } else {
        tmp->val = ival;
    }
    return ival;
}

int query(struct HashTable** hashTable, int ikey) {
    struct HashTable* tmp;
    HASH_FIND_INT(*hashTable, &ikey, tmp);
    return tmp->val;
}

int lower_bound(int* stones, int stonesSize, int target) {
    int left = 0, right = stonesSize;
    while (left < right) {
        int mid = (left + right) >> 1;
        if (stones[mid] < target) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }
    return left;
}

bool dfs(int* stones, int stonesSize, int i, int lastDis) {
    if (i == stonesSize - 1) {
        return true;
    }
    if (count(&rec[i], lastDis)) {
        return query(&rec[i], lastDis);
    }
    for (int curDis = lastDis - 1; curDis <= lastDis + 1; curDis++) {
        if (curDis > 0) {
            int j = lower_bound(stones, stonesSize, curDis + stones[i]);
            if (j != stonesSize && stones[j] == curDis + stones[i] && dfs(stones, stonesSize, j, curDis)) {
                return modify(&rec[i], lastDis, true);
            }
        }
    }
    return modify(&rec[i], lastDis, false);
}

bool canCross(int* stones, int stonesSize) {
    rec = malloc(sizeof(struct HashTable*) * stonesSize);
    memset(rec, 0, sizeof(struct HashTable*) * stonesSize);
    return dfs(stones, stonesSize, 0, 0);
}
```

**复杂度分析**

- 时间复杂度：$O(n^2\log n)$，其中 $n$ 是石子的数量。因为青蛙仅能在石子间跳跃，且不能向后方（起点的方向）跳跃，而第 $i$ 个石子后方只有 $i-1$ 个石子，因此在任意位置，青蛙的「上一次跳跃距离」至多只有 $O(n)$ 种，状态总数为 $O(n^2)$。最坏情况下我们要遍历每一个状态，每次我们需要 $O(\log n)$ 的时间查找指定位置的石子是否存在，相乘即可得到最终时间复杂度。

- 空间复杂度：$O(n^2)$，其中 $n$ 是石子的数量。最坏情况下我们需要记录全部 $O(n^2)$ 个状态。

#### 方法二：动态规划

**思路及算法**

我们也可以使用动态规划的方法，令 $\textit{dp}[i][k]$ 表示青蛙能否达到「现在所处的石子编号」为 $i$ 且「上一次跳跃距离」为 $k$ 的状态。

这样我们可以写出状态转移方程：

$$\textit{dp}[i][k] = \textit{dp}[j][k - 1] \bigvee \textit{dp}[j][k] \bigvee \textit{dp}[j][k + 1]$$ 

式中 $j$ 代表了青蛙的「上一次所在的石子编号」，满足 $stones[i] - stones[j] = k$。

和方法一相同，状态转移的初始条件为 $\textit{dp}[0][0] = \text{true}$，表示：「现在所处的石子编号」为 $0$（石子从 $0$ 开始编号），「上一次跳跃距离」为 $0$（这样可以保证青蛙的第一次跳跃距离为 $1$）。当我们找到一个 $\textit{dp}[n-1][k]$ 为真时，我们就知道青蛙可以到达终点（第 $n-1$ 个石子）。

具体地，对于第 $i$ 个石子，我们首先枚举所有的 $j$（即上一次所在的石子编号），那么「上一次跳跃距离」$k$ 即为 $stones[i] - stones[j]$。如果在第 $j$ 个石子上，青蛙的「上一次跳跃距离」可以为 $k-1,k,k+1$ 三者之一，那么我们此时的方案即为合法方案。因此我们只需要检查 $\textit{dp}[j][k - 1], \textit{dp}[j][k], \textit{dp}[j][k + 1]$ 是否有至少一个为真即可。

**优化**

为了优化程序运行速度，我们还将推出两个结论，并做出优化：

1. 「现在所处的石子编号」为 $i$ 时，「上一次跳跃距离」$k$ 必定满足 $k \leq i$。
   - 当青蛙位于第 $0$ 个石子上时，青蛙的上一次跳跃距离限定为 $0$，之后每次跳跃，青蛙所在的石子编号至少增加 $1$，而每次跳跃距离至多增加 $1$。
   - 跳跃 $m$ 次后，青蛙「现在所处的石子编号」$i \geq m$，「上一次跳跃距离」$k \leq m$，因此 $k\leq i$。
   - 这样我们可以将状态数约束在 $O(n^2)$。
   - 我们可以从后向前枚举「上一次所在的石子编号」$j$，当「上一次跳跃距离」$k$ 超过了 $j+1$ 时，我们即可以停止跳跃，因为在第 $j$ 个石子上我们至多只能跳出 $j+1$ 的距离。
2. 当第 $i$ 个石子与第 $i-1$ 个石子距离超过 $i$ 时，青蛙必定无法到达终点。
   - 由结论 $1$ 可知，当青蛙到达第 $i-1$ 个石子时，它的「上一次跳跃距离」至多为 $i-1$，因此青蛙在第 $i$ 个石子上最远只能跳出 $i$ 的距离。
   - 而距离第 $i-1$ 个石子最近的石子即为第 $i$ 个石子，它们的距离超过了青蛙当前能跳出的最远距离，因此青蛙无路可跳。
   - 因此我们可以提前检查是否有相邻的石子不满足条件，如果有，我们可以提前返回 $\text{false}$。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    bool canCross(vector<int>& stones) {
        int n = stones.size();
        vector<vector<int>> dp(n, vector<int>(n));
        dp[0][0] = true;
        for (int i = 1; i < n; ++i) {
            if (stones[i] - stones[i - 1] > i) {
                return false;
            }
        }
        for (int i = 1; i < n; ++i) {
            for (int j = i - 1; j >= 0; --j) {
                int k = stones[i] - stones[j];
                if (k > j + 1) {
                    break;
                }
                dp[i][k] = dp[j][k - 1] || dp[j][k] || dp[j][k + 1];
                if (i == n - 1 && dp[i][k]) {
                    return true;
                }
            }
        }
        return false;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean canCross(int[] stones) {
        int n = stones.length;
        boolean[][] dp = new boolean[n][n];
        dp[0][0] = true;
        for (int i = 1; i < n; ++i) {
            if (stones[i] - stones[i - 1] > i) {
                return false;
            }
        }
        for (int i = 1; i < n; ++i) {
            for (int j = i - 1; j >= 0; --j) {
                int k = stones[i] - stones[j];
                if (k > j + 1) {
                    break;
                }
                dp[i][k] = dp[j][k - 1] || dp[j][k] || dp[j][k + 1];
                if (i == n - 1 && dp[i][k]) {
                    return true;
                }
            }
        }
        return false;
    }
}
```

```JavaScript [sol2-JavaScript]
var canCross = function(stones) {
    const n = stones.length;
    const dp = new Array(n).fill(0).map(() => new Array(n).fill(0));
    dp[0][0] = true;
    for (let i = 1; i < n; ++i) {
        if (stones[i] - stones[i - 1] > i) {
            return false;
        }
    }
    for (let i = 1; i < n; ++i) {
        for (let j = i - 1; j >= 0; --j) {
            const k = stones[i] - stones[j];
            if (k > j + 1) {
                break;
            }
            dp[i][k] = dp[j][k - 1] || dp[j][k] || dp[j][k + 1];
            if (i === n - 1 && dp[i][k]) {
                return true;
            }
        }
    }
    return false;
};
```

```go [sol2-Golang]
func canCross(stones []int) bool {
    n := len(stones)
    dp := make([][]bool, n)
    for i := range dp {
        dp[i] = make([]bool, n)
    }
    dp[0][0] = true
    for i := 1; i < n; i++ {
        if stones[i]-stones[i-1] > i {
            return false
        }
    }
    for i := 1; i < n; i++ {
        for j := i - 1; j >= 0; j-- {
            k := stones[i] - stones[j]
            if k > j+1 {
                break
            }
            dp[i][k] = dp[j][k-1] || dp[j][k] || dp[j][k+1]
            if i == n-1 && dp[i][k] {
                return true
            }
        }
    }
    return false
}
```

```C [sol2-C]
bool canCross(int* stones, int stonesSize) {
    int dp[stonesSize][stonesSize];
    memset(dp, 0, sizeof(dp));
    dp[0][0] = true;
    for (int i = 1; i < stonesSize; ++i) {
        if (stones[i] - stones[i - 1] > i) {
            return false;
        }
    }
    for (int i = 1; i < stonesSize; ++i) {
        for (int j = i - 1; j >= 0; --j) {
            int k = stones[i] - stones[j];
            if (k > j + 1) {
                break;
            }
            dp[i][k] = dp[j][k - 1] || dp[j][k] || dp[j][k + 1];
            if (i == stonesSize - 1 && dp[i][k]) {
                return true;
            }
        }
    }
    return false;
}
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是石子的数量。因为青蛙仅能在石子间跳跃，且不能向后方（起点的方向）跳跃，而第 $i$ 个石子后方只有 $i-1$ 个石子，因此在任意位置，青蛙的「上一次跳跃距离」至多只有 $n$ 种，状态总数为 $n^2$。最坏情况下我们要遍历每一个状态，每次我们只需要 $O(1)$ 的时间计算当前状态是否可达，相乘即可得到最终时间复杂度。

- 空间复杂度：$O(n^2)$，其中 $n$ 是石子的数量。我们需要记录全部 $n^2$ 个状态。
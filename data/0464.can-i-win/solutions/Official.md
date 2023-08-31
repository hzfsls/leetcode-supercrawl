## [464.我能赢吗 中文官方题解](https://leetcode.cn/problems/can-i-win/solutions/100000/wo-neng-ying-ma-by-leetcode-solution-ef5v)

#### 方法一：记忆化搜索 + 状态压缩

**思路**

考虑边界情况，当所有数字选完仍无法到达 $\textit{desiredTotal}$ 时，两人都无法获胜，返回 $\text{false}$。当所有数字的和大于等于 $\textit{desiredTotal}$ 时，其中一方能获得胜利，需要通过搜索来判断获胜方。

在游戏中途，假设已经被使用的数字的集合为 $\textit{usedNumbers}$，这些数字的和为 $\textit{currentTotal}$。当某方行动时，如果他能在未选择的数字中选出一个 $i$，使得 $i + \textit{currentTotal} \geq \textit{desiredTotal}$，则他能获胜。否则，需要继续通过搜索来判断获胜方。在剩下的数字中，如果他能选择一个 $i$，使得对方在接下来的局面中无法获胜，则他会获胜。否则，他会失败。

根据这个思想设计搜索函数 $\textit{dfs}$，其中 $\textit{usedNumbers}$ 可以用一个整数来表示，从低位到高位，第 $i$ 位为 $1$ 则表示数字 $i$ 已经被使用，为 $0$ 则表示数字 $i$ 未被使用。如果当前玩家获胜，则返回 $\text{true}$，否则返回 $\text{false}$。为了避免重复计算，需要使用记忆化的操作来降低时间复杂度。

**代码**

```Python [sol1-Python3]
class Solution:
    def canIWin(self, maxChoosableInteger: int, desiredTotal: int) -> bool:
        @cache
        def dfs(usedNumbers: int, currentTotal: int) -> bool:
            for i in range(maxChoosableInteger):
                if (usedNumbers >> i) & 1 == 0:
                    if currentTotal + i + 1 >= desiredTotal or not dfs(usedNumbers | (1 << i), currentTotal + i + 1):
                        return True
            return False

        return (1 + maxChoosableInteger) * maxChoosableInteger // 2 >= desiredTotal and dfs(0, 0)
```

```Java [sol1-Java]
class Solution {
    Map<Integer, Boolean> memo = new HashMap<Integer, Boolean>();

    public boolean canIWin(int maxChoosableInteger, int desiredTotal) {
        if ((1 + maxChoosableInteger) * (maxChoosableInteger) / 2 < desiredTotal) {
            return false;
        }
        return dfs(maxChoosableInteger, 0, desiredTotal, 0);
    }

    public boolean dfs(int maxChoosableInteger, int usedNumbers, int desiredTotal, int currentTotal) {
        if (!memo.containsKey(usedNumbers)) {
            boolean res = false;
            for (int i = 0; i < maxChoosableInteger; i++) {
                if (((usedNumbers >> i) & 1) == 0) {
                    if (i + 1 + currentTotal >= desiredTotal) {
                        res = true;
                        break;
                    }
                    if (!dfs(maxChoosableInteger, usedNumbers | (1 << i), desiredTotal, currentTotal + i + 1)) {
                        res = true;
                        break;
                    }
                }
            }
            memo.put(usedNumbers, res);
        }
        return memo.get(usedNumbers);
    }
}
```

```C# [sol1-C#]
public class Solution {
    Dictionary<int, bool> memo = new Dictionary<int, bool>();

    public bool CanIWin(int maxChoosableInteger, int desiredTotal) {
        if ((1 + maxChoosableInteger) * (maxChoosableInteger) / 2 < desiredTotal) {
            return false;
        }
        return DFS(maxChoosableInteger, 0, desiredTotal, 0);
    }

    public bool DFS(int maxChoosableInteger, int usedNumbers, int desiredTotal, int currentTotal) {
        if (!memo.ContainsKey(usedNumbers)) {
            bool res = false;
            for (int i = 0; i < maxChoosableInteger; i++) {
                if (((usedNumbers >> i) & 1) == 0) {
                    if (i + 1 + currentTotal >= desiredTotal) {
                        res = true;
                        break;
                    }
                    if (!DFS(maxChoosableInteger, usedNumbers | (1 << i), desiredTotal, currentTotal + i + 1)) {
                        res = true;
                        break;
                    }
                }
            }
            memo.Add(usedNumbers, res);
        }
        return memo[usedNumbers];
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    unordered_map<int, bool> memo;

    bool canIWin(int maxChoosableInteger, int desiredTotal) {
        if ((1 + maxChoosableInteger) * (maxChoosableInteger) / 2 < desiredTotal) {
            return false;
        }
        return dfs(maxChoosableInteger, 0, desiredTotal, 0);
    }

    bool dfs(int maxChoosableInteger, int usedNumbers, int desiredTotal, int currentTotal) {
        if (!memo.count(usedNumbers)) {
            bool res = false;
            for (int i = 0; i < maxChoosableInteger; i++) {
                if (((usedNumbers >> i) & 1) == 0) {
                    if (i + 1 + currentTotal >= desiredTotal) {
                        res = true;
                        break;
                    }
                    if (!dfs(maxChoosableInteger, usedNumbers | (1 << i), desiredTotal, currentTotal + i + 1)) {
                        res = true;
                        break;
                    }
                }
            }
            memo[usedNumbers] = res;
        }
        return memo[usedNumbers];
    }
};
```

```C [sol1-C]
typedef struct HashItem {
    int key;
    bool val;
    UT_hash_handle hh;
} HashItem;

bool dfs(int maxChoosableInteger, int usedNumbers, int desiredTotal, int currentTotal, HashItem **memo) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*memo, &usedNumbers, pEntry);
    if (NULL == pEntry) {
        bool res = false;
        for (int i = 0; i < maxChoosableInteger; i++) {
            if (((usedNumbers >> i) & 1) == 0) {
                if (i + 1 + currentTotal >= desiredTotal) {
                    res = true;
                    break;
                }
                if (!dfs(maxChoosableInteger, usedNumbers | (1 << i), desiredTotal, currentTotal + i + 1, memo)) {
                    res = true;
                    break;
                }
            }
        }
        pEntry = (HashItem *)malloc(sizeof(HashItem));
        pEntry->key = usedNumbers;
        pEntry->val = res;
        HASH_ADD_INT(*memo, key, pEntry);
    }
    return pEntry->val;
}

bool canIWin(int maxChoosableInteger, int desiredTotal) {
    HashItem *memo = NULL;
    if ((1 + maxChoosableInteger) * (maxChoosableInteger) / 2 < desiredTotal) {
        return false;
    }
    return dfs(maxChoosableInteger, 0, desiredTotal, 0, &memo);
}
```

```go [sol1-Golang]
func canIWin(maxChoosableInteger, desiredTotal int) bool {
    if (1+maxChoosableInteger)*maxChoosableInteger/2 < desiredTotal {
        return false
    }

    dp := make([]int8, 1<<maxChoosableInteger)
    for i := range dp {
        dp[i] = -1
    }
    var dfs func(int, int) int8
    dfs = func(usedNum, curTot int) (res int8) {
        dv := &dp[usedNum]
        if *dv != -1 {
            return *dv
        }
        defer func() { *dv = res }()
        for i := 0; i < maxChoosableInteger; i++ {
            if usedNum>>i&1 == 0 && (curTot+i+1 >= desiredTotal || dfs(usedNum|1<<i, curTot+i+1) == 0) {
                return 1
            }
        }
        return
    }
    return dfs(0, 0) == 1
}
```

```JavaScript [sol1-JavaScript]
var canIWin = function(maxChoosableInteger, desiredTotal) {
    const memo = new Map();
    const dfs = (maxChoosableInteger, usedNumbers, desiredTotal, currentTotal) => {
        if (!memo.has(usedNumbers)) {
            let res = false;
            for (let i = 0; i < maxChoosableInteger; i++) {
                if (((usedNumbers >> i) & 1) === 0) {
                    if (i + 1 + currentTotal >= desiredTotal) {
                        res = true;
                        break;
                    }
                    if (!dfs(maxChoosableInteger, usedNumbers | (1 << i), desiredTotal, currentTotal + i + 1)) {
                        res = true;
                        break;
                    }
                }
            }
            memo.set(usedNumbers, res);
        }
        return memo.get(usedNumbers);
    }
    if ((1 + maxChoosableInteger) * (maxChoosableInteger) / 2 < desiredTotal) {
        return false;
    }
    return dfs(maxChoosableInteger, 0, desiredTotal, 0);
};
```

**复杂度分析**

- 时间复杂度：$O(2 ^ n \times n)$，其中 $n = \textit{maxChoosableInteger}$。记忆化后，函数 $\textit{dfs}$ 最多调用 $O(2 ^ n)$ 次，每次消耗 $O(n)$ 时间，总时间复杂度为 $O(2 ^ n \times n)$。 

- 空间复杂度：$O(2 ^ n)$，其中 $n = \textit{maxChoosableInteger}$。搜索的状态有 $O(2 ^ n)$ 种，需要消耗空间记忆化。
#### 方法一：记忆化搜索

**思路**

要求出完成所有课程的最少月份数，可以求出每门课程的最少月份数，然后求出最大值。首先根据 $\textit{relations}$，构建先修课邻接表 $\textit{prev}$，$\textit{prev}[i]$ 就表示课程 $i$ 的所有的先修课。定义函数 $\textit{dp}$，输入参数为 $i$，返回完成课程 $i$ 所需的最少月份数。
- 如果一门课程 $i$ 没有先修课要求，那么完成它的最少月份数就是 $\textit{time}[i-1]$。
- 如果一门课有先修课时，完成它的最少月份数就是在它的所有先修课的最少完成月份的最大值的基础上，再加上 $\textit{time}[i-1]$，即 $\textit{dp}[i] = \textit{max}(dp[j])+\textit{time}[i-1], j\in \textit{prev}[i]$。

可以运用记忆化搜索的技巧，求出每门课的最少完成月份数。因为运用了记忆化搜索，每门课的最少完成月份数最多只会被计算一次。

**代码**

```Python [sol1-Python3]
class Solution:
    def minimumTime(self, n: int, relations: List[List[int]], time: List[int]) -> int:
        mx = 0
        prev = [[] for _ in range(n + 1)]
        for x, y in relations:
            prev[y].append(x)
        
        @lru_cache(None)
        def dp(i: int) -> int:
            cur = 0
            for p in prev[i]:
                cur = max(cur, dp(p))
            cur += time[i - 1]
            return cur
            
        for i in range(1, n + 1):
            mx = max(mx, dp(i))
        return mx
```

```Java [sol1-Java]
class Solution {
    public int minimumTime(int n, int[][] relations, int[] time) {
        int mx = 0;
        List<Integer>[] prev = new List[n + 1];
        for (int i = 0; i <= n; i++) {
            prev[i] = new ArrayList<Integer>();
        }
        for (int[] relation : relations) {
            int x = relation[0], y = relation[1];
            prev[y].add(x);
        }
        Map<Integer, Integer> memo = new HashMap<Integer, Integer>();
        for (int i = 1; i <= n; i++) {
            mx = Math.max(mx, dp(i, time, prev, memo));
        }
        return mx;
    }

    public int dp(int i, int[] time, List<Integer>[] prev, Map<Integer, Integer> memo) {
        if (!memo.containsKey(i)) {
            int cur = 0;
            for (int p : prev[i]) {
                cur = Math.max(cur, dp(p, time, prev, memo));
            }
            cur += time[i - 1];
            memo.put(i, cur);
        }
        return memo.get(i);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinimumTime(int n, int[][] relations, int[] time) {
        int mx = 0;
        IList<int>[] prev = new IList<int>[n + 1];
        for (int i = 0; i <= n; i++) {
            prev[i] = new List<int>();
        }
        foreach (int[] relation in relations) {
            int x = relation[0], y = relation[1];
            prev[y].Add(x);
        }
        IDictionary<int, int> memo = new Dictionary<int, int>();
        for (int i = 1; i <= n; i++) {
            mx = Math.Max(mx, DP(i, time, prev, memo));
        }
        return mx;
    }

    public int DP(int i, int[] time, IList<int>[] prev, IDictionary<int, int> memo) {
        if (!memo.ContainsKey(i)) {
            int cur = 0;
            foreach (int p in prev[i]) {
                cur = Math.Max(cur, DP(p, time, prev, memo));
            }
            cur += time[i - 1];
            memo.Add(i, cur);
        }
        return memo[i];
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minimumTime(int n, vector<vector<int>>& relations, vector<int>& time) {
        int mx = 0;
        vector<vector<int>> prev(n + 1);
        for (auto &relation : relations) {
            int x = relation[0], y = relation[1];
            prev[y].emplace_back(x);
        }
        unordered_map<int, int> memo;
        function<int(int)> dp = [&](int i) -> int {
            if (!memo.count(i)) {
                int cur = 0;
                for (int p : prev[i]) {
                    cur = max(cur, dp(p));
                }
                cur += time[i - 1];
                memo[i] = cur;
            }
            return memo[i];
        };

        for (int i = 1; i <= n; i++) {
            mx = max(mx, dp(i));
        }
        return mx;
    }
};
```

```Go [sol1-Go]
func minimumTime(n int, relations [][]int, time []int) int {
    res := 0
    prev := make([][]int, n+1)
    for i := 0; i <= n; i++ {
        prev[i] = make([]int, 0)
    }
    for _, relation := range relations {
        x := relation[0]
        y := relation[1]
        prev[y] = append(prev[y], x)
    }
    memo := make(map[int]int)
    for i := 1; i <= n; i++ {
        res = max(res, dp(i, time, prev, memo))
    }
    return res
}

func dp(i int, time []int, prev [][]int, memo map[int]int) int {
    if _, ok := memo[i]; !ok {
        cur := 0
        for _, p := range prev[i] {
            cur = max(cur, dp(p, time, prev, memo))
        }
        cur += time[i-1]
        memo[i] = cur
    }
    return memo[i]
}

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

```

```JavaScript [sol1-JavaScript]
var minimumTime = function(n, relations, time) {
    let res = 0;
    let prev = Array(n + 1).fill(0);
    for (let i = 0; i <= n; i++) {
        prev[i] = [];
    }
    for (var relation of relations) {
        let x = relation[0], y = relation[1];
        prev[y].push(x);
    }
    let memo = {};
    for (let i = 1; i <= n; i++) {
        res = Math.max(res, dp(i, time, prev, memo));
    }
    return res;
};

function dp(i, time, prev, memo) {
    if (!memo[i]) {
        let cur = 0;
        for (let p of prev[i]) {
            cur = Math.max(cur, dp(p, time, prev, memo));
        }
        cur += time[i - 1];
        memo[i] = cur;
    }
    return memo[i];
}
```

```C [sol1-C]
typedef struct {
    int key;
    int val;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

bool hashSetItem(HashItem **obj, int key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

int hashGetItem(HashItem **obj, int key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);
    }
}

struct ListNode *creatListNode(int val) {
    struct ListNode *obj = (struct ListNode *)malloc(sizeof(struct ListNode));
    obj->val = val;
    obj->next = NULL;
    return obj;
}

int dp(int i, const int *time, struct ListNode **prev, HashItem **memo) {
    if (!hashFindItem(memo, i)) {
        int cur = 0;
        for (struct ListNode *node = prev[i]; node != NULL; node = node->next) {
            int p = node->val;
            cur = fmax(cur, dp(p, time, prev, memo));
        }
        cur += time[i - 1];
        hashAddItem(memo, i, cur);
    }
    return hashGetItem(memo, i, 0);
}

int minimumTime(int n, int** relations, int relationsSize, int* relationsColSize, int* time, int timeSize) {
    int mx = 0;
    struct ListNode *prev[n + 1];
    for (int i = 0; i <= n; i++) {
        prev[i] = NULL;
    }
    for (int i = 0; i < relationsSize; i++) {
        int x = relations[i][0], y = relations[i][1];
        struct ListNode *node = creatListNode(x);
        node->next = prev[y];
        prev[y] = node;
    }
    HashItem *memo = NULL;
    for (int i = 1; i <= n; i++) {
        mx = fmax(mx, dp(i, time, prev, &memo));
    }
    hashFree(&memo);
    for (int i = 0; i <= n; i++) {
        struct ListNode *node = prev[i];
        while (node) {
            struct ListNode *cur = node;
            node = node->next;
            free(cur);
        }
    }
    return mx;
}
```

**复杂度分析**

- 时间复杂度：$O(m+n)$，其中 $m$ 是数组 $\textit{relations}$ 长度。需要构建先修课邻接表，并且计算每个课程的最少月份数。因为每个课程只会被计算一次，因此相当于是每个 $\textit{relation}$ 会被遍历一次。

- 空间复杂度：$O(m+n)$，先修课邻接表的空间复杂度是 $O(m+n)$，记忆化搜索的空间复杂度是 $O(n)$。
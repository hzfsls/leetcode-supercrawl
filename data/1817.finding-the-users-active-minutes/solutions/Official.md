## [1817.查找用户活跃分钟数 中文官方题解](https://leetcode.cn/problems/finding-the-users-active-minutes/solutions/100000/cha-zhao-yong-hu-huo-yue-fen-zhong-shu-b-p5f6)

#### 方法一：哈希表

这道题要求对于 $1 \le j \le k$ 的每个 $j$ 计算用户活跃分钟数等于 $j$ 的用户数。需要首先得到每个用户的用户活跃分钟数，然后计算用户活跃分钟数等于特定值的用户数。

由于同一个用户的每次执行操作的时间不重复计算，因此需要使用哈希表记录每个用户的执行操作的时间，哈希表的关键字是用户编号，哈希表的值是存储执行操作的分钟的哈希集合，使用哈希集合可以确保同一个用户执行操作的同一分钟只会计算一次，不会重复计算。

首先遍历操作日志数组 $\textit{logs}$ 得到每个用户对应的执行操作的时间并存入哈希表，然后遍历哈希表并更新答案数组。由于这道题只需要知道用户活跃分钟数等于特定值的用户数，不需要知道具体的用户编号，因此只需要遍历哈希表中每条记录的值即可。哈希表中的每条记录的值都是一个哈希集合，哈希集合的元素个数等于当前用户的用户活跃分钟数，将答案数组中的对应元素值加 $1$。遍历哈希表中每条记录的值之后，即可得到答案数组。

由于答案数组的下标从 $1$ 开始，因此在更新答案数组时需要注意将下标做转换。

```Python [sol1-Python3]
class Solution:
    def findingUsersActiveMinutes(self, logs: List[List[int]], k: int) -> List[int]:
        mp = defaultdict(set)
        for i, t in logs:
            mp[i].add(t)
        ans = [0] * k
        for s in mp.values():
            ans[len(s) - 1] += 1
        return ans
```

```Java [sol1-Java]
class Solution {
    public int[] findingUsersActiveMinutes(int[][] logs, int k) {
        Map<Integer, Set<Integer>> activeMinutes = new HashMap<Integer, Set<Integer>>();
        for (int[] log : logs) {
            int id = log[0], time = log[1];
            activeMinutes.putIfAbsent(id, new HashSet<Integer>());
            activeMinutes.get(id).add(time);
        }
        int[] answer = new int[k];
        for (Set<Integer> minutes : activeMinutes.values()) {
            int activeCount = minutes.size();
            answer[activeCount - 1]++;
        }
        return answer;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] FindingUsersActiveMinutes(int[][] logs, int k) {
        IDictionary<int, ISet<int>> activeMinutes = new Dictionary<int, ISet<int>>();
        foreach (int[] log in logs) {
            int id = log[0], time = log[1];
            activeMinutes.TryAdd(id, new HashSet<int>());
            activeMinutes[id].Add(time);
        }
        int[] answer = new int[k];
        foreach (ISet<int> minutes in activeMinutes.Values) {
            int activeCount = minutes.Count;
            answer[activeCount - 1]++;
        }
        return answer;
    }
}
```

```JavaScript [sol1-JavaScript]
var findingUsersActiveMinutes = function(logs, k) {
    const activeMinutes = new Map();
    for (const [id, time] of logs) {
        if (!activeMinutes.has(id)) {
            activeMinutes.set(id, new Set());
        }
        activeMinutes.get(id).add(time);
    }
    const answer = new Array(k).fill(0);
    for (const minutes of activeMinutes.values()) {
        const activeCount = minutes.size;
        answer[activeCount - 1]++;
    }
    return answer;
};
```

```go [sol1-Golang]
func findingUsersActiveMinutes(logs [][]int, k int) []int {
    mp := map[int]map[int]bool{}
    for _, p := range logs {
        id, t := p[0], p[1]
        if mp[id] == nil {
            mp[id] = map[int]bool{}
        }
        mp[id][t] = true
    }
    ans := make([]int, k+1)
    for _, m := range mp {
        ans[len(m)]++
    }
    return ans[1:]
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> findingUsersActiveMinutes(vector<vector<int>>& logs, int k) {
        unordered_map<int, unordered_set<int>> activeMinutes;
        for (auto &&log : logs) {
            int id = log[0], time = log[1];
            activeMinutes[id].emplace(time);
        }
        vector<int> answer(k);
        for (auto &&[_, minutes] : activeMinutes) {
            int activeCount = minutes.size();
            answer[activeCount - 1]++;
        }
        return answer;
    }
};
```

```C [sol1-C]
typedef struct {
    int key;
    UT_hash_handle hh;
} HashSetItem; 

typedef struct {
    int key;
    HashSetItem *val;
    UT_hash_handle hh;
} HashMapItem; 

void hashSetFree(HashSetItem **obj) {
    HashSetItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

void hashMapFree(HashMapItem **obj) {
    HashMapItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);
        hashSetFree(&curr->val);  
        free(curr);             
    }
}

int* findingUsersActiveMinutes(int** logs, int logsSize, int* logsColSize, int k, int* returnSize) {
    HashMapItem *activeMinutes = NULL;
    for (int i = 0; i < logsSize; i++) {
        int id = logs[i][0], time = logs[i][1];
        HashMapItem *pMapEntry = NULL;
        HASH_FIND_INT(activeMinutes, &id, pMapEntry);
        if (NULL == pMapEntry) {
            pMapEntry = (HashMapItem *)malloc(sizeof(HashMapItem));
            pMapEntry->key = id;
            pMapEntry->val = NULL;
            HASH_ADD_INT(activeMinutes, key, pMapEntry);
        }
        HashSetItem *pSetEntry = NULL;
        HASH_FIND_INT(pMapEntry->val, &time, pSetEntry);
        if (NULL == pSetEntry) {
            pSetEntry = (HashSetItem *)malloc(sizeof(HashSetItem));
            pSetEntry->key = time;
            HASH_ADD_INT(pMapEntry->val, key, pSetEntry);
        }
    }
    int *answer = (int *)malloc(sizeof(int) * k);
    memset(answer, 0, sizeof(int) * k);
    for (HashMapItem *pEntry = activeMinutes; pEntry != NULL; pEntry = pEntry->hh.next) {
        int activeCount = HASH_COUNT(pEntry->val);
        answer[activeCount - 1]++;
    }
    *returnSize = k;
    hashMapFree(&activeMinutes);
    return answer;
}
```

**复杂度分析**

- 时间复杂度：$O(n + k)$，其中 $n$ 是数组 $\textit{logs}$ 的长度，$k$ 是给定的整数。遍历数组 $\textit{logs}$ 并使用哈希表记录每个用户的活跃分钟需要 $O(n)$ 的时间，创建答案数组和遍历哈希表更新答案数组需要 $O(n + k)$ 的时间，因此时间复杂度是 $O(n + k)$。

- 空间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{logs}$ 的长度。哈希表需要 $O(n)$ 的空间。注意返回值不计入空间复杂度。
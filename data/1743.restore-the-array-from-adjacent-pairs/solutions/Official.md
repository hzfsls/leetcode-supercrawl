#### 方法一：哈希表

**思路及算法**

对于一维数组 $\textit{nums}$ 中的元素 $\textit{nums}[i]$，若其为数组的第一个或最后一个元素，则该元素有且仅有一个元素与其相邻；若其为数组的中间元素，则该元素有且仅有两个元素与其相邻。

我们可以对每个元素记录与它相邻的元素有哪些，然后依次检查每个元素的相邻元素数量，即可找到原数组的第一个元素和最后一个元素。由于我们可以返回任意一个满足条件的数组，故指定这两个元素中的一个为原数组的第一个元素，然后根据相邻元素信息确定数组的第二个、第三个元素……直到确定最后一个元素为止。

具体地，我们使用哈希表记录每一个的元素的相邻元素有哪些，然后我们遍历哈希表，找到有且仅有一个相邻元素的元素 $e_1$ 作为原数组的第一个元素。那么与 $e_1$ 唯一相邻的元素 $e_2$ 即为原数组的第二个元素。此时排除掉与 $e_2$ 相邻的 $e_1$ 后，可以确认与 $e_2$ 相邻的 $e_3$ 即为原数组的第三个元素……以此类推，我们可以将原数组完整推断出来。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> restoreArray(vector<vector<int>>& adjacentPairs) {
        unordered_map<int, vector<int>> mp;
        for (auto& adjacentPair : adjacentPairs) {
            mp[adjacentPair[0]].push_back(adjacentPair[1]);
            mp[adjacentPair[1]].push_back(adjacentPair[0]);
        }

        int n = adjacentPairs.size() + 1;
        vector<int> ret(n);
        for (auto& [e, adj] : mp) {
            if (adj.size() == 1) {
                ret[0] = e;
                break;
            }
        }

        ret[1] = mp[ret[0]][0];
        for (int i = 2; i < n; i++) {
            auto& adj = mp[ret[i - 1]];
            ret[i] = ret[i - 2] == adj[0] ? adj[1] : adj[0];
        }
        return ret;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] restoreArray(int[][] adjacentPairs) {
        Map<Integer, List<Integer>> map = new HashMap<Integer, List<Integer>>();
        for (int[] adjacentPair : adjacentPairs) {
            map.putIfAbsent(adjacentPair[0], new ArrayList<Integer>());
            map.putIfAbsent(adjacentPair[1], new ArrayList<Integer>());
            map.get(adjacentPair[0]).add(adjacentPair[1]);
            map.get(adjacentPair[1]).add(adjacentPair[0]);
        }

        int n = adjacentPairs.length + 1;
        int[] ret = new int[n];
        for (Map.Entry<Integer, List<Integer>> entry : map.entrySet()) {
            int e = entry.getKey();
            List<Integer> adj = entry.getValue();
            if (adj.size() == 1) {
                ret[0] = e;
                break;
            }
        }

        ret[1] = map.get(ret[0]).get(0);
        for (int i = 2; i < n; i++) {
            List<Integer> adj = map.get(ret[i - 1]);
            ret[i] = ret[i - 2] == adj.get(0) ? adj.get(1) : adj.get(0);
        }
        return ret;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] RestoreArray(int[][] adjacentPairs) {
        Dictionary<int, IList<int>> dictionary = new Dictionary<int, IList<int>>();
        foreach (int[] adjacentPair in adjacentPairs) {
            if (!dictionary.ContainsKey(adjacentPair[0])) {
                dictionary.Add(adjacentPair[0], new List<int>());
            }
            if (!dictionary.ContainsKey(adjacentPair[1])) {
                dictionary.Add(adjacentPair[1], new List<int>());
            }
            dictionary[adjacentPair[0]].Add(adjacentPair[1]);
            dictionary[adjacentPair[1]].Add(adjacentPair[0]);
        }

        int n = adjacentPairs.Length + 1;
        int[] ret = new int[n];
        foreach (KeyValuePair<int, IList<int>> pair in dictionary) {
            int e = pair.Key;
            IList<int> adj = pair.Value;
            if (adj.Count == 1) {
                ret[0] = e;
                break;
            }
        }

        ret[1] = dictionary[ret[0]][0];
        for (int i = 2; i < n; i++) {
            IList<int> adj = dictionary[ret[i - 1]];
            ret[i] = ret[i - 2] == adj[0] ? adj[1] : adj[0];
        }
        return ret;
    }
}
```

```go [sol1-Golang]
func restoreArray(adjacentPairs [][]int) []int {
    n := len(adjacentPairs) + 1
    g := make(map[int][]int, n)
    for _, p := range adjacentPairs {
        v, w := p[0], p[1]
        g[v] = append(g[v], w)
        g[w] = append(g[w], v)
    }

    ans := make([]int, n)
    for e, adj := range g {
        if len(adj) == 1 {
            ans[0] = e
            break
        }
    }

    ans[1] = g[ans[0]][0]
    for i := 2; i < n; i++ {
        adj := g[ans[i-1]]
        if ans[i-2] == adj[0] {
            ans[i] = adj[1]
        } else {
            ans[i] = adj[0]
        }
    }
    return ans
}
```

```C [sol1-C]
struct HashTable {
    int key;
    int arr[2];
    UT_hash_handle hh;
};

void push(struct HashTable** hashTable, int x, int y) {
    struct HashTable* tmp;
    HASH_FIND_INT(*hashTable, &x, tmp);
    if (tmp == NULL) {
        tmp = (struct HashTable*)malloc(sizeof(struct HashTable));
        tmp->key = x, tmp->arr[0] = y, tmp->arr[1] = INT_MAX;
        HASH_ADD_INT(*hashTable, key, tmp);
    } else {
        tmp->arr[1] = y;
    }
}

struct HashTable* query(struct HashTable** hashTable, int x) {
    struct HashTable* tmp;
    HASH_FIND_INT(*hashTable, &x, tmp);
    return tmp;
}

int* restoreArray(int** adjacentPairs, int adjacentPairsSize, int* adjacentPairsColSize, int* returnSize) {
    struct HashTable* hashTable = NULL;
    for (int i = 0; i < adjacentPairsSize; i++) {
        push(&hashTable, adjacentPairs[i][0], adjacentPairs[i][1]);
        push(&hashTable, adjacentPairs[i][1], adjacentPairs[i][0]);
    }

    int n = adjacentPairsSize + 1;
    int* ret = (int*)malloc(sizeof(int) * n);
    *returnSize = n;
    struct HashTable *iter, *tmp;
    HASH_ITER(hh, hashTable, iter, tmp) {
        if (iter->arr[1] == INT_MAX) {
            ret[0] = iter->key;
        }
    }
    ret[1] = query(&hashTable, ret[0])->arr[0];
    for (int i = 2; i < n; i++) {
        int* adj = query(&hashTable, ret[i - 1])->arr;
        ret[i] = ret[i - 2] == adj[0] ? adj[1] : adj[0];
    }
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var restoreArray = function(adjacentPairs) {
    const map = new Map();
    for (const adjacentPair of adjacentPairs) {
        map.get(adjacentPair[0]) ? map.get(adjacentPair[0]).push(adjacentPair[1]) : map.set(adjacentPair[0], [adjacentPair[1]]);
        map.get(adjacentPair[1]) ? map.get(adjacentPair[1]).push(adjacentPair[0]) : map.set(adjacentPair[1], [adjacentPair[0]]);
    }

    const n = adjacentPairs.length + 1;
    const ret = new Array(n).fill(0);
    for (const [e, adj] of map.entries()) {
        if (adj.length === 1) {
            ret[0] = e;
            break;
        }
    }

    ret[1] = map.get(ret[0])[0];
    for (let i = 2; i < n; i++) {
        const adj = map.get(ret[i - 1]);
        ret[i] = ret[i - 2] == adj[0] ? adj[1] : adj[0];
    }
    return ret;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是原数组的长度。我们只需要遍历每一个元素一次。

- 空间复杂度：$O(n)$，其中 $n$ 是原数组的长度。主要为哈希表的开销。
#### 方法一: 二分查找

**思路与算法**

根据题意可知，每次查询时给定的 $\textit{queries}[j]$，需要统计满足如下条件的点对 $(a, b)$ 的数目：
+ $a < b$；
+ 对于每次查询 $\textit{queries}[j]$，与节点 $a$ 或者节点 $b$ 相连的边的数目之和严格大于 $\textit{queries}[j]$。

设节点 $x$ 的度为 $\textit{degree}[x]$，我们知道与节点 $a$ 相连的边的数目即为 $a$ 的度数 $\textit{degree}[a]$，与节点 $b$ 相连的边的数目即节点 $b$ 的度数 $\textit{degree}[b]$，如果此时节点 $a$ 与节点 $b$ 之间不存在相连的边，则此时与点对 $(a,b)$ 相连的边的数目即为 $\textit{degree}[a] + \textit{degree}[b]$。

+ 需要注意的与节点 $a$ 或者节点 $b$ 相连的边的数目之和则不一定等于 $a$ 的度数与 $b$ 的度数之和，这是因为 $a$ 与 $b$ 之间可能存在相连的边，假设 $a$ 与 $b$ 之间相连边的数目为 $\textit{cnt}(a, b)$，则此时与点对 $(a,b)$ 相连的边的数目即为 $\textit{degree}[a] + \textit{degree}[b] - \textit{cnt}(a, b)$，这是由于 $\textit{cnt}(a, b)$ 被计算了两次。

根据以上分析，对于每次查询时，假设当前给定边的查询值为 $\textit{queries}[i]$，此时最直接的做法是使用双层循环遍历所有的点对 $(a,b)$，然后找到所有满足的点对即可，但此时时间复杂度为 $O(n^2)$，按照题目给定的数量会超时。假设给定点 $a$，则此时点对的另一节点 $b$ 的度数应该大于 $\textit{queries}[i] - \textit{degree}[b]$，因此可以考虑利用二分查找在 $O(\log n)$ 的时间复杂度找到满足要求的点 $b$ 的数目，同时还需处理 $a,b$ 存在共边的问题，可以分两步进行：
+ 此时首先找到所有满足 $\textit{degree}[a] + \textit{degree}[b] > \textit{queries}[i]$ 的点对数量。二分查找的思路非常简单，假设当前的点 $a$ 的度为 $\textit{degree}[a]$，则利用二分查找在数组中查找当前度数大于 $\textit{queries}[i] - \textit{degree}[a]$ 的节点数量，为了方便计算，需要将 $\textit{degree}$ 按照从小到大的顺序进行排列即可，利用二分查找大于 $\textit{queries}[i] - \textit{degree}[a]$ 的索引为 $j$，则此时可以与 $a$ 构成符合要求的节点数量为 $n - j$，按照上述方法找到所有满足要求的点对数量为 $\textit{total}$；
+ 其次需要处理 $(a,b)$ 存在共边的问题，即减去重复计算的部分。我们用哈希存储表 $\textit{cnt}$ 存储不同边的数量，由于所有的边均为无向边，因此边 $\vec{ab}$ 与 边 $\vec{ba}$ 为同样的边，此时为了方便处理可以将边 $\vec{ab}$ 映射到一个整数 $a\times n + b, (a < b)$。遍历所有的边 $\vec{ab}$，此时点对 $(a,b)$ 中重复计算边的数目即为 $\textit{cnt}(a, b)$。此时如果点对 $(a,b)$ 减去重复部分后相连边的数目小于等于 $queries[i]$，则认为该点对不满足要求，即从当点对 $(a,b)$ 满足：
$$\textit{degree}[a] + \textit{degree}[b] - \textit{cnt}(a, b) \le queries[i]$$ 
$\textit{total}$ 的记数减 $1$，最终得到的 $\textit{total}$ 即可本次的查询结果；

根据以上方法找到每次查询的点对数量，并返回结果即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<int> countPairs(int n, vector<vector<int>>& edges, vector<int>& queries) {
        vector<int> degree(n);
        unordered_map<int, int> cnt;
        for (auto edge : edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            if (x > y) {
                swap(x, y);
            }
            degree[x]++;
            degree[y]++;
            cnt[x * n + y]++;
        }

        vector<int> arr = degree;
        vector<int> ans;
        sort(arr.begin(), arr.end());
        for (int bound : queries) {
            int total = 0;
            for (int i = 0; i < n; i++) {
                int j = upper_bound(arr.begin() + i + 1, arr.end(), bound - arr[i]) - arr.begin();
                total += n - j;
            }
            for (auto &[val, freq] : cnt) {
                int x = val / n;
                int y = val % n;
                if (degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound) {
                    total--;
                }
            }
            ans.emplace_back(total);
        }

        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] countPairs(int n, int[][] edges, int[] queries) {
        int[] degree = new int[n];
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (int[] edge : edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            if (x > y) {
                int temp = x;
                x = y;
                y = temp;
            }
            degree[x]++;
            degree[y]++;
            cnt.put(x * n + y, cnt.getOrDefault(x * n + y, 0) + 1);
        }

        int[] arr = Arrays.copyOf(degree, n);
        int[] ans = new int[queries.length];
        Arrays.sort(arr);
        for (int k = 0; k < queries.length; k++) {
            int bound = queries[k], total = 0;
            for (int i = 0; i < n; i++) {
                int j = binarySearch(arr, i + 1, n - 1, bound - arr[i]);
                total += n - j;
            }
            for (Map.Entry<Integer, Integer> entry : cnt.entrySet()) {
                int val = entry.getKey(), freq = entry.getValue();
                int x = val / n, y = val % n;
                if (degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound) {
                    total--;
                }
            }
            ans[k] = total;
        }

        return ans;
    }

    public int binarySearch(int[] arr, int left, int right, int target) {
        int ans = right + 1;
        while (left <= right) {
            int mid = (left + right) >> 1;
            if (arr[mid] <= target) {
                left = mid + 1;
            } else {
                right = mid - 1;
                ans = mid;
            }
        }
        return ans;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] CountPairs(int n, int[][] edges, int[] queries) {
        int[] degree = new int[n];
        IDictionary<int, int> cnt = new Dictionary<int, int>();
        foreach (int[] edge in edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            if (x > y) {
                int temp = x;
                x = y;
                y = temp;
            }
            degree[x]++;
            degree[y]++;
            cnt.TryAdd(x * n + y, 0);
            cnt[x * n + y]++;
        }

        int[] arr = new int[n];
        Array.Copy(degree, 0, arr, 0, n);
        int[] ans = new int[queries.Length];
        Array.Sort(arr);
        for (int k = 0; k < queries.Length; k++) {
            int bound = queries[k], total = 0;
            for (int i = 0; i < n; i++) {
                int j = BinarySearch(arr, i + 1, n - 1, bound - arr[i]);
                total += n - j;
            }
            foreach (KeyValuePair<int, int> pair in cnt) {
                int val = pair.Key, freq = pair.Value;
                int x = val / n, y = val % n;
                if (degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound) {
                    total--;
                }
            }
            ans[k] = total;
        }

        return ans;
    }

    public int BinarySearch(int[] arr, int left, int right, int target) {
        int ans = right + 1;
        while (left <= right) {
            int mid = (left + right) >> 1;
            if (arr[mid] <= target) {
                left = mid + 1;
            } else {
                right = mid - 1;
                ans = mid;
            }
        }
        return ans;
    }
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

static inline int cmp(const void *a, const void *b) {
    return *(int *)a - *(int *)b;
}

int binarySearch(const int *arr, int left, int right, int target) {
    int ans = right + 1;
    while (left <= right) {
        int mid = (left + right) >> 1;
        if (arr[mid] <= target) {
            left = mid + 1;
        } else {
            right = mid - 1;
            ans = mid;
        }
    }
    return ans;
}

int* countPairs(int n, int** edges, int edgesSize, int* edgesColSize, int* queries, int queriesSize, int* returnSize) {
    int degree[n];
    HashItem *cnt = NULL;
    memset(degree, 0, sizeof(degree));
    for (int i = 0; i < edgesSize; i++) {
        int x = edges[i][0] - 1, y = edges[i][1] - 1;
        if (x > y) {
            int tmp = x;
            x = y;
            y = tmp;
        }
        degree[x]++;
        degree[y]++;
        hashSetItem(&cnt, x * n + y, hashGetItem(&cnt, x * n + y, 0) + 1);
    }

    int arr[n];
    int *ans = (int *)malloc(sizeof(int) * queriesSize);
    int pos = 0;
    memcpy(arr, degree, sizeof(degree));
    qsort(arr, n, sizeof(int), cmp);
    for (int k = 0; k < queriesSize; k++) {
        int bound = queries[k];
        int total = 0;
        for (int i = 0; i < n; i++) {
            int j = binarySearch(arr, i + 1, n - 1, bound - arr[i]);
            total += n - j;
        }
        for (HashItem *pEntry = cnt; pEntry; pEntry = pEntry->hh.next) {
            int val = pEntry->key;
            int freq = pEntry->val;
            int x = val / n;
            int y = val % n;
            if (degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound) {
                total--;
            }
        }
        ans[k] = total;
    }
    hashFree(&cnt);
    *returnSize = queriesSize;
    return ans;
}
```

```Python [sol1-Python3]
class Solution:
    def countPairs(self, n: int, edges: List[List[int]], queries: List[int]) -> List[int]:
        degree = [0 for _ in range(n)]
        cnt = collections.defaultdict(int)
        for edge in edges:
            x, y = edge[0] - 1, edge[1] - 1
            if x > y:
                x, y = y, x
            degree[x] += 1
            degree[y] += 1
            cnt[x * n + y] += 1

        arr = sorted(degree)
        ans = []
        for bound in queries:
            total = 0
            for i in range(n):
                j = bisect_right(arr, bound - arr[i], i + 1)
                total += n - j
            for val, freq in cnt.items():
                x, y = val // n, val % n
                if degree[x] + degree[y] > bound and degree[x] + degree[y] - freq <= bound:
                    total -= 1
            ans.append(total)
        return ans
```

```Go [sol1-Go]
func countPairs(n int, edges [][]int, queries []int) []int {
    degree := make([]int, n)
    cnt := map[int]int{}
    for _, edge := range edges {
        x, y := edge[0] - 1, edge[1] - 1
        if x > y {
            x, y = y, x
        }
        degree[x]++
        degree[y]++
        cnt[x * n + y]++
    }
    
    arr := make([]int, n)
    copy(arr, degree)
    sort.Ints(arr)
    ans := []int{}
    for _, bound :=  range queries {
        total := 0
        for i := 0; i < n; i++ {
            j := sort.SearchInts(arr, bound - arr[i] + 1)
            total += n - max(i + 1, j)
        }
        for val, freq := range cnt {
            x, y := val / n, val % n
            if degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound {
                total--
            }
        }
        ans = append(ans, total)
    }
    return ans
}

func max(a int, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol1-JavaScript]
var countPairs = function(n, edges, queries) {
    const degree = new Array(n).fill(0);
    const cnt = new Map();
    for (var edge of edges) {
        let x = edge[0] - 1;
        let y = edge[1] - 1;
        if (x > y) {
            let tmp = x;
            x = y;
            y = tmp; 
        }
        degree[x]++;
        degree[y]++;
        const key = x * n + y;
        cnt.set(key, cnt.has(key) ? cnt.get(key) + 1 : 1);
    }
    const arr = Array.from(degree);
    const ans = new Array(queries.length);
    arr.sort((a, b) => a - b);
    for (let k = 0; k < queries.length; k++) {
        const bound = queries[k]; 
        let total = 0;
        for (let i = 0; i < n; i++) {
            let j = binarySearch(arr, i + 1, n - 1, bound - arr[i]);
            total += n - j;
        }
        for (var [val, freq] of cnt.entries()) {
            let x = Math.floor(val / n);
            let y = val % n;
            if (degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound) {
                total--;
            }
        }
        ans[k] = total;
    }
    return ans;
};

const binarySearch = (arr, low, high, target) => {
    let ans = high + 1;
    while (low <= high) {
        const mid = Math.floor((high - low + 1) / 2) + low;
        if (arr[mid] <= target) {
            low = mid + 1;
        } else {
            high = mid - 1;
            ans = mid;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(q \times (n \log n + m))$，其中 $q$ 表示查询数组 $\textit{queries}$ 的铲毒，$n$ 表示给定的节点的数目，$m$ 表示边 $\textit{edges}$ 的长度。对所有的点的度数排序时需要的时间复杂度为 $O(n \log n)$，每次查询时需要二分查找找到所有符合要求的点对，并同时遍历所有的边，需要的时间为 $O(n\log n + m)$，一共有 $q$ 次查询，因此总的时间复杂度为 $O(n \log n + q \times (n \log n + m)) = O(q \times (n \log n + m))$。

- 空间复杂度：$O(n + m)$，其中 $n$ 表示给定的节点的数目，$m$ 表示边 $\textit{edges}$ 的数目。我们需要存储每个点的度数，需要的空间为 $O(n)$，还需统计每条边出现的次数，需要的空间为 $O(m)$，因此总的空间复杂度为 $O(n + m)$。

#### 方法二: 双指针

**思路与算法**

方法二的解法思路跟方法一基本一致，唯一需要特殊处理的是找满足 $\textit{degree}[a] + \textit{degree}[b] > \textit{bound}$ 的点对时可以利用双指针来处理：
+ 假设当前从小到大第 $i$ 节点 $a$ 的度为 $\textit{degree}[a]$，我们从后往前找到第一个满足小于等于 $\textit{bound} - \textit{degree}[a]$ 的节点索引为 $j$，则此时 $b \in [j+1,n-1]$ 均满足 $\textit{degree}[a] + \textit{degree}[b] > \textit{queries}[i]$，则此时与 $a$ 构成满足要求的节点的数目位 $n - 1 - j$，为了防止重复计算，此时只取大于 $i$ 且大于 $j$ 的索引，则此时 $b \in [\max(i+1,j+1),n-1]$ 区间内的索引即可；

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<int> countPairs(int n, vector<vector<int>>& edges, vector<int>& queries) {
        vector<int> degree(n);
        unordered_map<int, int> cnt;
        for (auto edge : edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            if (x > y) {
                swap(x, y);
            }
            degree[x]++;
            degree[y]++;
            cnt[x * n + y]++;
        }

        vector<int> arr = degree;
        vector<int> ans;
        sort(arr.begin(), arr.end());
        for (int bound : queries) {
            int total = 0;
            for (int i = 0, j = n - 1; i < n; i++) {
                while (j > i && arr[i] + arr[j] > bound) {
                    j--;
                }
                total += n - 1 - max(i, j);
            }
            for (auto &[val, freq] : cnt) {
                int x = val / n;
                int y = val % n;
                if (degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound) {
                    total--;
                }
            }
            ans.emplace_back(total);
        }

        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] countPairs(int n, int[][] edges, int[] queries) {
        int[] degree = new int[n];
        Map<Integer, Integer> cnt = new HashMap<Integer, Integer>();
        for (int[] edge : edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            if (x > y) {
                int temp = x;
                x = y;
                y = temp;
            }
            degree[x]++;
            degree[y]++;
            cnt.put(x * n + y, cnt.getOrDefault(x * n + y, 0) + 1);
        }

        int[] arr = Arrays.copyOf(degree, n);
        int[] ans = new int[queries.length];
        Arrays.sort(arr);
        for (int k = 0; k < queries.length; k++) {
            int bound = queries[k], total = 0;
            for (int i = 0, j = n - 1; i < n; i++) {
                while (j > i && arr[i] + arr[j] > bound) {
                    j--;
                }
                total += n - 1 - Math.max(i, j);
            }
            for (Map.Entry<Integer, Integer> entry : cnt.entrySet()) {
                int val = entry.getKey(), freq = entry.getValue();
                int x = val / n, y = val % n;
                if (degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound) {
                    total--;
                }
            }
            ans[k] = total;
        }

        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int[] CountPairs(int n, int[][] edges, int[] queries) {
        int[] degree = new int[n];
        IDictionary<int, int> cnt = new Dictionary<int, int>();
        foreach (int[] edge in edges) {
            int x = edge[0] - 1, y = edge[1] - 1;
            if (x > y) {
                int temp = x;
                x = y;
                y = temp;
            }
            degree[x]++;
            degree[y]++;
            cnt.TryAdd(x * n + y, 0);
            cnt[x * n + y]++;
        }

        int[] arr = new int[n];
        Array.Copy(degree, 0, arr, 0, n);
        int[] ans = new int[queries.Length];
        Array.Sort(arr);
        for (int k = 0; k < queries.Length; k++) {
            int bound = queries[k], total = 0;
            for (int i = 0, j = n - 1; i < n; i++) {
                while (j > i && arr[i] + arr[j] > bound) {
                    j--;
                }
                total += n - 1 - Math.Max(i, j);
            }
            foreach (KeyValuePair<int, int> pair in cnt) {
                int val = pair.Key, freq = pair.Value;
                int x = val / n, y = val % n;
                if (degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound) {
                    total--;
                }
            }
            ans[k] = total;
        }

        return ans;
    }
}
```

```C [sol2-C]
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

static inline int cmp(const void *a, const void *b) {
    return *(int *)a - *(int *)b;
}

int* countPairs(int n, int** edges, int edgesSize, int* edgesColSize, int* queries, int queriesSize, int* returnSize) {
    int degree[n];
    HashItem *cnt = NULL;
    memset(degree, 0, sizeof(degree));
    for (int i = 0; i < edgesSize; i++) {
        int x = edges[i][0] - 1, y = edges[i][1] - 1;
        if (x > y) {
            int tmp = x;
            x = y;
            y = tmp;
        }
        degree[x]++;
        degree[y]++;
        hashSetItem(&cnt, x * n + y, hashGetItem(&cnt, x * n + y, 0) + 1);
    }

    int arr[n];
    int *ans = (int *)malloc(sizeof(int) * queriesSize);
    int pos = 0;
    memcpy(arr, degree, sizeof(degree));
    qsort(arr, n, sizeof(int), cmp);
    for (int k = 0; k < queriesSize; k++) {
        int bound = queries[k];
        int total = 0;
        for (int i = 0, j = n - 1; i < n; i++) {
            while (j > i && arr[i] + arr[j] > bound) {
                j--;
            }
            total += n - 1 - fmax(i, j);
        }
        for (HashItem *pEntry = cnt; pEntry; pEntry = pEntry->hh.next) {
            int val = pEntry->key;
            int freq = pEntry->val;
            int x = val / n;
            int y = val % n;
            if (degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound) {
                total--;
            }
        }
        ans[k] = total;
    }
    hashFree(&cnt);
    *returnSize = queriesSize;
    return ans;
}
```

```Python [sol2-Python3]
class Solution:
    def countPairs(self, n: int, edges: List[List[int]], queries: List[int]) -> List[int]:
        degree = [0 for _ in range(n)]
        cnt = collections.defaultdict(int)
        for edge in edges:
            x, y = edge[0] - 1, edge[1] - 1
            if x > y:
                x, y = y, x
            degree[x] += 1
            degree[y] += 1
            cnt[x * n + y] += 1

        arr = sorted(degree)
        ans = []
        for bound in queries:
            total = 0
            j = n - 1
            for i in range(n):
                while j > i and arr[i] + arr[j] > bound:
                    j -= 1
                total += n - 1 - max(i, j)
            for val, freq in cnt.items():
                x, y = val // n, val % n
                if degree[x] + degree[y] > bound and degree[x] + degree[y] - freq <= bound:
                    total -= 1
            ans.append(total)
        return ans
```

```Go [sol2-Go]
func countPairs(n int, edges [][]int, queries []int) []int {
    degree := make([]int, n)
    cnt := map[int]int{}
    for _, edge := range edges {
        x, y := edge[0] - 1, edge[1] - 1
        if x > y {
            x, y = y, x
        }
        degree[x]++
        degree[y]++
        cnt[x * n + y]++
    }
    
    arr := make([]int, n)
    copy(arr, degree)
    sort.Ints(arr)
    ans := []int{}
    for _, bound :=  range queries {
        total := 0
        for i, j := 0, n - 1; i < n; i++ {
            for j > i && arr[i] + arr[j] > bound {
                j--
            }
            total += n - 1 - max(i, j)
        }
        for val, freq := range cnt {
            x, y := val / n, val % n
            if degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound {
                total--
            }
        }
        ans = append(ans, total)
    }
    return ans
}

func max(a int, b int) int {
    if a > b {
        return a
    }
    return b
}
```

```JavaScript [sol2-JavaScript]
var countPairs = function(n, edges, queries) {
    const degree = new Array(n).fill(0);
    const cnt = new Map();
    for (var edge of edges) {
        let x = edge[0] - 1;
        let y = edge[1] - 1;
        if (x > y) {
            let tmp = x;
            x = y;
            y = tmp; 
        }
        degree[x]++;
        degree[y]++;
        const key = x * n + y;
        cnt.set(key, cnt.has(key) ? cnt.get(key) + 1 : 1);
    }
    const arr = Array.from(degree);
    const ans = new Array(queries.length);
    arr.sort((a, b) => a - b);
    for (let k = 0; k < queries.length; k++) {
        const bound = queries[k]; 
        let total = 0;
        for (let i = 0, j = n - 1; i < n; i++) {
            while (j > i && arr[i] + arr[j] > bound) {
                j--;
            }
            total += n - 1 - Math.max(i, j);
        }
        for (var [val, freq] of cnt.entries()) {
            let x = Math.floor(val / n);
            let y = val % n;
            if (degree[x] + degree[y] > bound && degree[x] + degree[y] - freq <= bound) {
                total--;
            }
        }
        ans[k] = total;
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n \log n + q \times (n + m))$，其中 $q$ 表示查询数组 $\textit{queries}$ 的铲毒，$n$ 表示给定的节点的数目，$m$ 表示边 $\textit{edges}$ 的长度。对所有的点的度数排序时需要的时间复杂度为 $O(n \log n)$，每次查询时需要遍历所有点的度数，并同时遍历所有的边，需要的时间为 $O(n + m)$，一共有 $q$ 次查询，因此总的时间复杂度为 $O(n \log n + q \times (n + m))$。

- 空间复杂度：$O(n + m)$，其中 $n$ 表示给定的节点的数目，$m$ 表示边 $\textit{edges}$ 的数目。我们需要存储每个点的度数，需要的空间为 $O(n)$，还需统计每条边出现的次数，需要的空间为 $O(m)$，因此总的空间复杂度为 $O(n + m)$。
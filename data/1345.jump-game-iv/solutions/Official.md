## [1345.跳跃游戏 IV 中文官方题解](https://leetcode.cn/problems/jump-game-iv/solutions/100000/tiao-yue-you-xi-iv-by-leetcode-solution-zsix)
#### 方法一：广度优先搜索

**思路**

记数组 $\textit{arr}$ 的长度为 $n$。题目描述的数组可以抽象为一个无向图，数组元素为图的顶点，相邻下标的元素之间有一条无向边相连，所有值相同元素之间也有无向边相连。每条边的权重都为 $1$，即此图为无权图。求从第一个元素到最后一个元素的最少操作数，即求从第一个元素到最后一个元素的最短路径长度。求无权图两点间的最短路可以用广度优先搜索来解，时间复杂度为 $O(V+E)$，其中 $V$ 为图的顶点数，$E$ 为图的边数。

在此题中，$V = n$，而 $E$ 可达 $O(n^2)$ 数量级，按照常规方法使用广度优先搜索会超时。造成超时的主要原因是所有值相同的元素构成了一个稠密子图，普通的广度优先搜索方法会对这个稠密子图中的所有边都访问一次。但对于无权图的最短路问题，这样的访问是不必要的。在第一次访问到这个子图中的某个节点时，即会将这个子图的所有其他未在队列中的节点都放入队列。在第二次访问到这个子图中的节点时，就不需要去考虑这个子图中的其他节点了，因为所有其他节点都已经在队列中或者已经被访问过了。因此，在用广度优先搜索解决此题时，先需要找出所有的值相同的子图，用一个哈希表 $\textit{idxSameValue}$ 保存。在第一次把这个子图的所有节点放入队列后，把该子图清空，就不会重复访问该子图的其他边了。

**代码**

```Python [sol1-Python3]
class Solution:
    def minJumps(self, arr: List[int]) -> int:
        idxSameValue = defaultdict(list)
        for i, a in enumerate(arr):
            idxSameValue[a].append(i)
        visitedIndex = set()
        q = deque()
        q.append([0, 0])
        visitedIndex.add(0)
        while q:
            idx, step = q.popleft()
            if idx == len(arr) - 1:
                return step
            v = arr[idx]
            step += 1
            for i in idxSameValue[v]:
                if i not in visitedIndex:
                    visitedIndex.add(i)
                    q.append([i, step])
            del idxSameValue[v]
            if idx + 1 < len(arr) and (idx + 1) not in visitedIndex:
                visitedIndex.add(idx + 1)
                q.append([idx+1, step])
            if idx - 1 >= 0 and (idx - 1) not in visitedIndex:
                visitedIndex.add(idx - 1)
                q.append([idx-1, step])
```

```Java [sol1-Java]
class Solution {
    public int minJumps(int[] arr) {
        Map<Integer, List<Integer>> idxSameValue = new HashMap<Integer, List<Integer>>();
        for (int i = 0; i < arr.length; i++) {
            idxSameValue.putIfAbsent(arr[i], new ArrayList<Integer>());
            idxSameValue.get(arr[i]).add(i);
        }
        Set<Integer> visitedIndex = new HashSet<Integer>();
        Queue<int[]> queue = new ArrayDeque<int[]>();
        queue.offer(new int[]{0, 0});
        visitedIndex.add(0);
        while (!queue.isEmpty()) {
            int[] idxStep = queue.poll();
            int idx = idxStep[0], step = idxStep[1];
            if (idx == arr.length - 1) {
                return step;
            }
            int v = arr[idx];
            step++;
            if (idxSameValue.containsKey(v)) {
                for (int i : idxSameValue.get(v)) {
                    if (visitedIndex.add(i)) {
                        queue.offer(new int[]{i, step});
                    }
                }
                idxSameValue.remove(v);
            }
            if (idx + 1 < arr.length && visitedIndex.add(idx + 1)) {
                queue.offer(new int[]{idx + 1, step});
            }
            if (idx - 1 >= 0 && visitedIndex.add(idx - 1)) {
                queue.offer(new int[]{idx - 1, step});
            }
        }
        return -1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int MinJumps(int[] arr) {
        Dictionary<int, IList<int>> idxSameValue = new Dictionary<int, IList<int>>();
        for (int i = 0; i < arr.Length; i++) {
            if (!idxSameValue.ContainsKey(arr[i])) {
                idxSameValue.Add(arr[i], new List<int>());
            }
            idxSameValue[arr[i]].Add(i);
        }
        ISet<int> visitedIndex = new HashSet<int>();
        Queue<int[]> queue = new Queue<int[]>();
        queue.Enqueue(new int[]{0, 0});
        visitedIndex.Add(0);
        while (queue.Count > 0) {
            int[] idxStep = queue.Dequeue();
            int idx = idxStep[0], step = idxStep[1];
            if (idx == arr.Length - 1) {
                return step;
            }
            int v = arr[idx];
            step++;
            if (idxSameValue.ContainsKey(v)) {
                foreach (int i in idxSameValue[v]) {
                    if (visitedIndex.Add(i)) {
                        queue.Enqueue(new int[]{i, step});
                    }
                }
                idxSameValue.Remove(v);
            }
            if (idx + 1 < arr.Length && visitedIndex.Add(idx + 1)) {
                queue.Enqueue(new int[]{idx + 1, step});
            }
            if (idx - 1 >= 0 && visitedIndex.Add(idx - 1)) {
                queue.Enqueue(new int[]{idx - 1, step});
            }
        }
        return 0;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int minJumps(vector<int>& arr) {
        unordered_map<int, vector<int>> idxSameValue;
        for (int i = 0; i < arr.size(); i++) {
            idxSameValue[arr[i]].push_back(i);
        }
        unordered_set<int> visitedIndex;
        queue<pair<int, int>> q;
        q.emplace(0, 0);
        visitedIndex.emplace(0);
        while (!q.empty()) {
            auto [idx, step] = q.front();
            q.pop();
            if (idx == arr.size() - 1) {
                return step;
            }
            int v = arr[idx];
            step++;
            if (idxSameValue.count(v)) {
                for (auto & i : idxSameValue[v]) {
                    if (!visitedIndex.count(i)) {
                        visitedIndex.emplace(i);
                        q.emplace(i, step);
                    }
                }
                idxSameValue.erase(v);
            }
            if (idx + 1 < arr.size() && !visitedIndex.count(idx + 1)) {
                visitedIndex.emplace(idx + 1);
                q.emplace(idx + 1, step);
            }
            if (idx - 1 >= 0 && !visitedIndex.count(idx - 1)) {
                visitedIndex.emplace(idx - 1);
                q.emplace(idx - 1, step);
            }
        }
        return -1;
    }
};
```

```C [sol1-C]
typedef struct IdxHashEntry {
    int key;               
    struct ListNode * head;
    UT_hash_handle hh;         
}IdxHashEntry;

typedef struct SetHashEntry {
    int key; 
    UT_hash_handle hh;         
}SetHashEntry;

typedef struct Pair {
    int idx;
    int step;
}Pair;

void hashAddIdxItem(struct IdxHashEntry **obj, int key, int val) {
    struct IdxHashEntry *pEntry = NULL;
    struct ListNode * node = (struct ListNode *)malloc(sizeof(struct ListNode));
    node->val = val;
    node->next = NULL;

    HASH_FIND(hh, *obj, &key, sizeof(key), pEntry);
    if (NULL == pEntry) {
        pEntry = (struct IdxHashEntry *)malloc(sizeof(struct IdxHashEntry));
        pEntry->key = key;
        pEntry->head = node;
        HASH_ADD(hh, *obj, key, sizeof(int), pEntry);
    } else {
        node->next = pEntry->head;
        pEntry->head = node;
    }
} 

struct IdxHashEntry *hashFindIdxItem(struct IdxHashEntry **obj, int key)
{
    struct IdxHashEntry *pEntry = NULL;
    HASH_FIND(hh, *obj, &key, sizeof(int), pEntry);
    return pEntry;
}

void hashFreeIdxAll(struct IdxHashEntry **obj)
{
    struct IdxHashEntry *curr = NULL, *next = NULL;
    HASH_ITER(hh, *obj, curr, next)
    {
        HASH_DEL(*obj, curr);  
        free(curr);      
    }
}

void hashAddSetItem(struct SetHashEntry **obj, int key) {
    struct SetHashEntry *pEntry = NULL;
    HASH_FIND(hh, *obj, &key, sizeof(key), pEntry);
    if (pEntry == NULL) {
        pEntry = malloc(sizeof(struct SetHashEntry));
        pEntry->key = key;
        HASH_ADD(hh, *obj, key, sizeof(int), pEntry);
    }
} 

struct SetHashEntry *hashFindSetItem(struct SetHashEntry **obj, int key)
{
    struct SetHashEntry *pEntry = NULL;
    HASH_FIND(hh, *obj, &key, sizeof(int), pEntry);
    return pEntry;
}

void hashFreeSetAll(struct SetHashEntry **obj)
{
    struct SetHashEntry *curr = NULL, *next = NULL;
    HASH_ITER(hh, *obj, curr, next)
    {
        HASH_DEL(*obj, curr);  
        free(curr);      
    }
}

int minJumps(int* arr, int arrSize){
    struct IdxHashEntry * idxSameValue = NULL;
    for (int i = 0; i < arrSize; i++) {
        hashAddIdxItem(&idxSameValue, arr[i], i);
    }
    
    struct SetHashEntry * visitedIndex = NULL;
    struct Pair * queue = (struct Pair *)malloc(sizeof(struct Pair) * arrSize * 2);
    int head = 0;
    int tail = 0;
    queue[tail].idx = 0;
    queue[tail].step = 0;
    tail++;
    hashAddSetItem(&visitedIndex, 0);
    while (head != tail) {
        int idx = queue[head].idx;
        int step = queue[head].step;
        head++;
        if (idx + 1 == arrSize) {
            hashFreeIdxAll(&idxSameValue);
            hashFreeSetAll(&visitedIndex);
            free(queue);
            return step;
        }
        int v = arr[idx];
        step++;
        struct IdxHashEntry * pEntry = hashFindIdxItem(&idxSameValue, v);
        if (NULL != pEntry) {
            for (struct ListNode * node = pEntry->head; node; node = node->next) {
                if (NULL == hashFindSetItem(&visitedIndex, node->val)) {
                    hashAddSetItem(&visitedIndex, node->val);
                    queue[tail].idx = node->val;
                    queue[tail].step = step;
                    tail++;
                }
            }
            HASH_DEL(idxSameValue, pEntry);
        }
        if (idx + 1 < arrSize && NULL == hashFindSetItem(&visitedIndex, idx + 1)) {
            hashAddSetItem(&visitedIndex, idx + 1);
            queue[tail].idx = idx + 1;
            queue[tail].step = step;
            tail++;
        }
        if (idx - 1 >= 0 && NULL == hashFindSetItem(&visitedIndex, idx - 1)) {
            hashAddSetItem(&visitedIndex, idx - 1);
            queue[tail].idx = idx - 1;
            queue[tail].step = step;
            tail++;
        }
    }
    hashFreeIdxAll(&idxSameValue);
    hashFreeSetAll(&visitedIndex);
    free(queue);
    return -1;
}
```

```go [sol1-Golang]
func minJumps(arr []int) int {
    n := len(arr)
    idx := map[int][]int{}
    for i, v := range arr {
        idx[v] = append(idx[v], i)
    }
    vis := map[int]bool{0: true}
    type pair struct{ idx, step int }
    q := []pair{{}}
    for {
        p := q[0]
        q = q[1:]
        i, step := p.idx, p.step
        if i == n-1 {
            return step
        }
        for _, j := range idx[arr[i]] {
            if !vis[j] {
                vis[j] = true
                q = append(q, pair{j, step + 1})
            }
        }
        delete(idx, arr[i])
        if !vis[i+1] {
            vis[i+1] = true
            q = append(q, pair{i + 1, step + 1})
        }
        if i > 0 && !vis[i-1] {
            vis[i-1] = true
            q = append(q, pair{i - 1, step + 1})
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{arr}$ 的长度。每个元素最多只进入队列一次，最多被判断是否需要进入队列三次。

- 空间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{arr}$ 的长度。队列，哈希表和哈希集合均最多存储 $n$ 个元素。
## [1376.通知所有员工所需的时间 中文官方题解](https://leetcode.cn/problems/time-needed-to-inform-all-employees/solutions/100000/tong-zhi-suo-you-yuan-gong-suo-xu-de-shi-503h)
### 问题提示

* 如何用代码表示员工之间的从属关系？
* 如何在代码中表示树形结构，并遍历整棵树？
* 如何优化遍历的效率，避免重复计算通知时间？

### 前置知识

* 树的遍历，包括深度优先遍历（DFS）和广度优先遍历（BFS）；
* 递归思想，包括递归函数的定义、调用、返回等；
* 一些基本的数据结构，例如数组、哈希表等。

### 解题思路

#### 方法一：深度优先搜索

**思路与算法**

题目保证员工的从属关系可以用树结构显示，所以我们可以根据数组 $\textit{manager}$ 来构建树模型，其中每一个员工为一个节点，每一个员工的上司为其父节点，总负责人为根节点。我们存储每一个节点的子节点，然后我们可以通过「自顶向下」的方式，从根节点开始往下「深度优先搜索」来传递信息传递的过程，计算从每一个节点往下传递信息的所需要的最大时间。

**代码**

```Python [sol1-Python3]
class Solution:
    def numOfMinutes(self, n: int, headID: int, manager: List[int], informTime: List[int]) -> int:
        # 使用 defaultdict 来构建图
        g = collections.defaultdict(list)
        for i in range(n):
            g[manager[i]].append(i)
        
        def dfs(cur):
            res = 0
            # 遍历当前节点的邻居节点
            for ne in g[cur]:
                res = max(res, dfs(ne))
            # 返回当前节点被通知需要的时间以及所有邻居节点被通知所需的最大时间
            return informTime[cur] + res
        
        # 从根节点开始进行 DFS 并返回总时间
        return dfs(headID)
```

```Java [sol1-Java]
class Solution {
    public int numOfMinutes(int n, int headID, int[] manager, int[] informTime) {
        // 使用 HashMap 来构建图
        Map<Integer, List<Integer>> g = new HashMap<Integer, List<Integer>>();
        for (int i = 0; i < n; i++) {
            g.putIfAbsent(manager[i], new ArrayList<Integer>());
            g.get(manager[i]).add(i);
        }
        // 从根节点开始进行 DFS 并返回总时间
        return dfs(headID, informTime, g);
    }

    public int dfs(int cur, int[] informTime, Map<Integer, List<Integer>> g) {
        int res = 0;
        // 遍历当前节点的邻居节点
        for (int neighbor : g.getOrDefault(cur, new ArrayList<Integer>())) {
            res = Math.max(res, dfs(neighbor, informTime, g));
        }
        // 返回当前节点被通知需要的时间以及所有邻居节点被通知所需的最大时间
        return informTime[cur] + res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int NumOfMinutes(int n, int headID, int[] manager, int[] informTime) {
        // 使用 Dictionary 来构建图
        IDictionary<int, IList<int>> g = new Dictionary<int, IList<int>>();
        for (int i = 0; i < n; i++) {
            g.TryAdd(manager[i], new List<int>());
            g[manager[i]].Add(i);
        }
        // 从根节点开始进行 DFS 并返回总时间
        return DFS(headID, informTime, g);
    }

    public int DFS(int cur, int[] informTime, IDictionary<int, IList<int>> g) {
        int res = 0;
        if (g.ContainsKey(cur)) {
            // 遍历当前节点的邻居节点
            foreach (int neighbor in g[cur]) {
                res = Math.Max(res, DFS(neighbor, informTime, g));
            }
        }
        // 返回当前节点被通知需要的时间以及所有邻居节点被通知所需的最大时间
        return informTime[cur] + res;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int numOfMinutes(int n, int headID, vector<int>& manager, vector<int>& informTime) {
        // 建立一个从 manager[i] 到 i 的有向图
        unordered_map<int, vector<int>> g;
        for (int i = 0; i < n; i++) {
            g[manager[i]].emplace_back(i);
        }
        // 定义一个 dfs 函数，遍历从 headID 开始的子树
        function<int(int)> dfs = [&](int cur) -> int {
            int res = 0;
            // 遍历当前节点的所有子节点，计算从子节点到当前节点的时间
            for (int neighbor : g[cur]) {
                res = max(res, dfs(neighbor));
            }
            // 加上当前节点到其上级节点的时间
            return informTime[cur] + res;
        };
        // 返回从 headID 到其所有子节点的最大时间
        return dfs(headID);
    }
};
```

```C [sol1-C]
//定义哈希表元素结构
typedef struct {
    int key;  //键值为经理的编号
    struct ListNode *list; //指向经理下属的链表头结点
    UT_hash_handle hh;  //哈希表处理器
} HashItem;

//返回两个整数中的较大值
static int max(int a, int b) {
    return a > b ? a : b;
}

//创建新的链表结点
struct ListNode *listNodeCreat(int val) {
    struct ListNode *obj = (struct ListNode *)malloc(sizeof(struct ListNode));
    obj->val = val;
    obj->next = NULL;
    return obj;
}

//释放链表内存
void listFree(struct ListNode *head) {
    while (head) {
        struct ListNode *cur = head;
        head = head->next;
        free(cur);
    }
}

//在哈希表中查找元素
HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

//添加元素到哈希表中
bool hashAddItem(HashItem **obj, int key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (pEntry != NULL) { //如果经理已存在于哈希表中
        struct ListNode *cur = listNodeCreat(val); //创建一个链表结点
        cur->next = pEntry->list; //将新的结点插入链表中
        pEntry->list = cur;
    } else { //如果经理不存在于哈希表中
        pEntry = (HashItem *)malloc(sizeof(HashItem)); //创建新的哈希表元素
        pEntry->key = key; //设置键值
        pEntry->list = listNodeCreat(val); //创建链表头结点
        HASH_ADD_INT(*obj, key, pEntry); //将元素添加到哈希表中
    }
    return true;
}

//获取哈希表元素
struct ListNode * hashGetItem(HashItem **obj, int key) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return NULL;
    } else {
        return pEntry->list;
    }
}

//释放哈希表内存
void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  //从哈希表中删除当前元素
        listFree(curr->list);  //释放当前元素中链表的内存
        free(curr);             //释放当前元素的内存
    }
}

//深度优先遍历
int dfs(int cur, const int* informTime, HashItem **g) {
    int res = 0;
    HashItem *pEntry = hashFindItem(g, cur);
    if (pEntry) {
        for (struct ListNode *node = pEntry->list; node; node = node->next) {
            int neighbor = node->val;
            res = max(res, dfs(neighbor, informTime, g)); //遍历经理的下属
        }
    }
    return informTime[cur] + res;
}

int numOfMinutes(int n, int headID, int* manager, int managerSize, int* informTime, int informTimeSize) {
    HashItem *g = NULL;
    for (int i = 0; i < n; i++) {
        hashAddItem(&g, manager[i], i);
    }
    int ret = dfs(headID, informTime, &g);
    return ret;
}
```

```JavaScript [sol1-JavaScript]
var numOfMinutes = function(n, headID, manager, informTime) {
    // 构建树的邻接表，使用 Map 存储
    const g = new Map();

    // 定义深度优先遍历函数
    const dfs = (cur, informTime, g) => {
        // res 存储当前节点的所有下属中，最大的通知时间
        let res = 0;

        // 遍历当前节点的每个下属
        for (const neighbor of g.get(cur) || []) {
            // 递归计算下属的通知时间，并更新 res
            res = Math.max(res, dfs(neighbor, informTime, g));
        }

        // 返回当前节点的通知时间（加上下属中最大的通知时间）
        return informTime[cur] + res;
    };

    // 遍历每个员工，将其加入其直接负责人的下属列表
    for (let i = 0; i < n; i++) {
        if (!g.has(manager[i])) {
            g.set(manager[i], []);
        }
        g.get(manager[i]).push(i);
    }

    // 从总负责人开始遍历整棵树，并计算总通知时间
    return dfs(headID, informTime, g);
}
```

```go [sol1-Golang]
func numOfMinutes(n int, headID int, manager []int, informTime []int) int {
    g := map[int][]int{}
    for i, m := range manager {
        g[m] = append(g[m], i)
    }
    var dfs func(int) int
    dfs = func(cur int) (res int) {
        for _, neighbor := range g[cur] {
            res1 := dfs(neighbor)
            if res1 > res {
                res = res1
            }
        }
        return informTime[cur] + res
    }
    return dfs(headID)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。
- 空间复杂度：$O(n)$，主要为建图的空间开销。

#### 方法二：广度优先搜索

**思路与算法**

同样我们可以用「广度优先搜索」来实现「方法一」中信息传递的过程。每一个员工看作一个节点，总负责人为根节点，队列中存放二元组 $(\textit{node}, \textit{time})$，其中 $node$ 表示当前员工，$\textit{time}$ 为信息传递到该员工的时间。最初我们将二元组 $(\textit{headID}, 0)$ 放入队列，每一个叶子节点的最大时间即为答案。

**代码**

```Python [sol2-Python3]
import queue
class Solution:
    def numOfMinutes(self, n: int, headID: int, manager: List[int], informTime: List[int]) -> int:
        # 使用 defaultdict 来方便地构建邻接表
        g = collections.defaultdict(list)
        for i in range(n):
            g[manager[i]].append(i)
        q = queue.Queue()
        # 将起点放入队列
        q.put((headID, 0))
        res = 0
        while not q.empty():
            tmp_id, val = q.get()
            # 如果当前节点没有下属，说明到达了叶子节点，更新结果
            if len(g[tmp_id]) == 0:
                res = max(res, val)
            else:   
                # 将当前节点的下属加入队列，更新时间
                for ne in g[tmp_id]:
                    q.put((ne, val + informTime[tmp_id]))
        return res
```

```Java [sol2-Java]
class Solution {
    public int numOfMinutes(int n, int headID, int[] manager, int[] informTime) {
        Map<Integer, List<Integer>> g = new HashMap<Integer, List<Integer>>();
        // 构建邻接表
        for (int i = 0; i < n; i++) {
            g.putIfAbsent(manager[i], new ArrayList<Integer>());
            g.get(manager[i]).add(i);
        }
        Queue<int[]> queue = new ArrayDeque<int[]>();
        // 将起点放入队列
        queue.offer(new int[]{headID, 0});
        int res = 0;
        while (!queue.isEmpty()) {
            int[] arr = queue.poll();
            int tmpId = arr[0], val = arr[1];
            // 如果当前节点没有下属，说明到达了叶子节点，更新结果
            if (!g.containsKey(tmpId)) {
                res = Math.max(res, val);
            } else {
                // 将当前节点的下属加入队列，更新时间
                for (int ne : g.get(tmpId)) {
                    queue.offer(new int[]{ne, val + informTime[tmpId]});
                }
            }
        }
        return res;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int NumOfMinutes(int n, int headID, int[] manager, int[] informTime) {
        IDictionary<int, IList<int>> g = new Dictionary<int, IList<int>>();
        // 构建邻接表
        for (int i = 0; i < n; i++) {
            g.TryAdd(manager[i], new List<int>());
            g[manager[i]].Add(i);
        }
        Queue<int[]> queue = new Queue<int[]>();
        // 将起点放入队列
        queue.Enqueue(new int[]{headID, 0});
        int res = 0;
        while (queue.Count > 0) {
            int[] arr = queue.Dequeue();
            int tmpId = arr[0], val = arr[1];
            // 如果当前节点没有下属，说明到达了叶子节点，更新结果
            if (!g.ContainsKey(tmpId)) {
                res = Math.Max(res, val);
            } else {
                // 将当前节点的下属加入队列，更新时间
                foreach (int ne in g[tmpId]) {
                    queue.Enqueue(new int[]{ne, val + informTime[tmpId]});
                }
            }
        }
        return res;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int numOfMinutes(int n, int headID, vector<int>& manager, vector<int>& informTime) {
        // 创建一个无序哈希表，键是管理者ID，值是直接汇报给他的员工的列表。
        unordered_map<int, vector<int>> g;
        // 将所有员工添加到各自的管理者的值（列表）中。
        for (int i = 0; i < n; i++) {
            g[manager[i]].emplace_back(i);
        }
        // 创建一个队列，第一个元素是员工ID，第二个元素是从头节点到这个员工的总时间。
        queue<pair<int, int>> q;
        // 添加第一个元素到队列中。
        q.emplace(headID, 0);
        // 保存最长时间。
        int res = 0;
        while (!q.empty()) {
            auto [tmp_id, val] = q.front();
            q.pop();
            // 如果这个员工没有管理其他员工，它就是公司最后一个员工，将总时间与结果中的最大值比较并更新结果。
            if (!g.count(tmp_id)) {
                res = max(res, val);
            } else {
                // 如果这个员工管理其他员工，将直接报告给它的员工加入到队列中。
                for (int neighbor : g[tmp_id]) {
                    q.emplace(neighbor, val + informTime[tmp_id]);
                }
            }
        }
        return res;
    }
};
```

```C [sol2-C]
typedef struct {
    int key; // 节点的 id
    struct ListNode *list; // 节点的下属列表
    UT_hash_handle hh; // 宏定义，用于哈希表操作
} HashItem; 

// 比较两个整数的大小，返回较大值
static int max(int a, int b) {
    return a > b ? a : b;
}

// 创建一个链表节点，返回节点指针
struct ListNode *listNodeCreat(int val) {
    struct ListNode *obj = (struct ListNode *)malloc(sizeof(struct ListNode));
    obj->val = val;
    obj->next = NULL;
    return obj;
}

// 释放一个链表的内存空间
void listFree(struct ListNode *head) {
    while (head) {
        struct ListNode *cur = head;
        head = head->next;
        free(cur);
    }
}

// 在哈希表中查找指定 key 对应的节点，返回节点指针
HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry); // UT_hash 中的宏定义
    return pEntry;
}

// 将指定 key 和 val 的节点加入到哈希表中，返回是否添加成功
bool hashAddItem(HashItem **obj, int key, int val) {
    HashItem *pEntry = hashFindItem(obj, key); // 先在哈希表中查找是否已经有相同的 key
    if (pEntry != NULL) { // 如果已经有相同的 key，则将 val 添加到原有节点的下属列表中
        struct ListNode *cur = listNodeCreat(val);
        cur->next = pEntry->list;
        pEntry->list = cur;
    } else { // 如果没有相同的 key，则新建一个节点，并将节点添加到哈希表中
        pEntry = (HashItem *)malloc(sizeof(HashItem));
        pEntry->key = key;
        pEntry->list = listNodeCreat(val);
        HASH_ADD_INT(*obj, key, pEntry); // UT_hash 中的宏定义
    }
    return true;
}

// 获取哈希表中指定 key 对应的节点的下属列表
struct ListNode * hashGetItem(HashItem **obj, int key) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return NULL;
    } else {
        return pEntry->list;
    }
}

// 释放哈希表的内存空间
void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) { // UT_hash 中的宏定义
        HASH_DEL(*obj, curr); // UT_hash 中的宏定义
        listFree(curr->list);
        free(curr);             
    }
}

// 计算从 headID 开始的传递时间
int numOfMinutes(int n, int headID, int* manager, int managerSize, int* informTime, int informTimeSize) {
    HashItem *g = NULL; // 哈希表，用于存储每个节点的下属

    // 遍历所有员工，将他们的下属添加到哈希表中
    for (int i = 0; i < n; i++) {
        hashAddItem(&g, manager[i], i);
    }

    int queue[n][2]; // 用数组实现队列
    int head = 0, tail = 0; // 队列头和尾的指针
    queue[tail][0] = headID; // 将起点加入队列
    queue[tail][1] = 0; // 起点的传递时间为0
    tail++;

    int res = 0; // 最终结果，即传递给所有员工所需的最短时间
    while (head != tail) {
        int tmp_id = queue[head][0]; // 取出队头员工的ID
        int val = queue[head][1]; // 取出队头员工接到信息所需的时间
        head++; // 出队

        HashItem *pEntry = hashFindItem(&g, tmp_id); // 查找该员工的下属
        if (pEntry) {
            // 遍历该员工的所有下属
            for (struct ListNode *node = pEntry->list; node; node = node->next) {
                int neighbor = node->val; // 取出下属的ID
                queue[tail][0] = neighbor; // 下属入队
                queue[tail][1] = val + informTime[tmp_id]; // 下属接到信息的时间为当前员工接到信息的时间加上传递时间
                tail++; // 队尾指针后移
            }
        } else {
            res = max(res, val); // 如果该员工没有下属，说明信息传递到该员工的时间已经确定，更新结果
        }
    }

    hashFree(&g); // 释放哈希表内存
    return res;
}
```

```JavaScript [sol2-JavaScript]
var numOfMinutes = function(n, headID, manager, informTime) {
    // 初始化哈希表
    const g = new Map();
    for (let i = 0; i < n; i++) {
        if (!g.has(manager[i])) {
            g.set(manager[i], []);
        }
        g.get(manager[i]).push(i);
    }
    // 初始化队列
    const queue = [];
    queue.push([headID, 0]);

    // 初始化结果
    let res = 0;

    // BFS
    while (queue.length) {
        const arr = queue.shift();
        const tmpId = arr[0], val = arr[1];
        if (!g.has(tmpId)) {
            // 如果当前节点没有下属，更新结果
            res = Math.max(res, val);
        } else {
            // 遍历当前节点的下属，将其加入队列
            for (const ne of g.get(tmpId)) {
                queue.push([ne, val + informTime[tmpId]]);
            }
        }
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。
- 空间复杂度：$O(n)$，主要为建图的空间开销。

#### 方法三：记忆化搜索

**思路与算法**

上述「方法一」和「方法二」都是「自顶向下」的实现方式。同样我们可以通过「自底向上」的方式，从每一个员工开始往上进行搜索，记录每一个员工到根节点（员工总负责人）所需要的时间，其中所需要的最大时间即为答案。由于每一个员工到根节点的路径唯一，且每一个员工可能有多个下属，所以为了避免重复计算，我们可以通过「记忆化」的方式来进行处理。

**代码**

```Python [sol3-Python3]
class Solution:
    def numOfMinutes(self, n: int, headID: int, manager: List[int], informTime: List[int]) -> int:
        # 使用缓存，存储每个节点到根节点的最长时间
        @cache
        def dfs(cur):
            if cur == headID:  # 当前节点为根节点
                return 0
            # 递归遍历当前节点的直属上级节点，返回时间和
            # 由于 informTime 存储的是当前节点通知下属所需时间，所以使用 manager[cur] 获取上级节点
            return dfs(manager[cur]) + informTime[manager[cur]]
        # 对所有节点遍历，返回最长时间
        return max(dfs(i) for i in range(n))
```

```Java [sol3-Java]
class Solution {
    int headID;  // 公司总负责人 ID
    int[] manager;  // manager[i] 表示第 i 名员工的直属负责人
    int[] informTime;  // informTime[i] 表示第 i 名员工通知直属下属所需时间
    Map<Integer, Integer> memo = new HashMap<Integer, Integer>();  // 记忆化搜索缓存

    public int numOfMinutes(int n, int headID, int[] manager, int[] informTime) {
        this.headID = headID;
        this.manager = manager;
        this.informTime = informTime;
        int res = 0;  // 记录最长时间
        for (int i = 0; i < n; i++) {
            res = Math.max(res, dfs(i));  // 对每个员工遍历，更新最长时间
        }
        return res;
    }

    public int dfs(int cur) {
        if (cur == headID) {  // 当前节点为根节点
            return 0;
        }
        if (!memo.containsKey(cur)) {  // 检查缓存中是否已经存在当前节点的时间
            int res = dfs(manager[cur]) + informTime[manager[cur]];  // 递归遍历当前节点的直属上级节点，返回时间和
            memo.put(cur, res);  // 将当前节点到根节点的时间加入缓存中
        }
        return memo.get(cur);  // 返回当前节点到根节点的时间
    }
}
```

```C# [sol3-C#]
public class Solution {
    int headID;
    int[] manager;
    int[] informTime;
    IDictionary<int, int> memo = new Dictionary<int, int>();

    public int NumOfMinutes(int n, int headID, int[] manager, int[] informTime) {
        this.headID = headID;
        this.manager = manager;
        this.informTime = informTime;
        int res = 0;
        for (int i = 0; i < n; i++) {
            res = Math.Max(res, DFS(i));
        }
        return res;
    }

    public int DFS(int cur) {
        if (cur == headID) {
            return 0;
        }
        if (!memo.ContainsKey(cur)) {
            int res = DFS(manager[cur]) + informTime[manager[cur]];
            memo.Add(cur, res);
        }
        return memo[cur];
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    int numOfMinutes(int n, int headID, vector<int>& manager, vector<int>& informTime) {
        unordered_map<int, int> memo;
        function<int(int)> dfs = [&](int cur) -> int {
            if (cur == headID) {
                return 0;
            }
            if (memo.count(cur)) {
                return memo[cur];
            }
            int res = dfs(manager[cur]) + informTime[manager[cur]];
            memo[cur] = res;
            return res;
        };
        int res = 0;
        for (int i = 0; i < n; i++) {
            res = max(res, dfs(i));
        }
        return res;
    }
};
```

```C [sol3-C]
typedef struct {
    int key;        // key
    int val;        // value
    UT_hash_handle hh;  // 用于散列表的哈希句柄
} HashItem;

// 在散列表中查找特定的 key，返回对应的结构体指针，如果不存在则返回 NULL
HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

// 在散列表中添加一个 key-value 对，如果 key 已经存在，返回 false，否则添加成功并返回 true
bool hashAddItem(HashItem **obj, int key, int val) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem)); // 分配新结构体的内存
    pEntry->key = key;
    pEntry->val = val;
    HASH_ADD_INT(*obj, key, pEntry);  // 添加到散列表中
    return true;
}

// 更新散列表中指定 key 对应的 value，如果 key 不存在，则添加一个新的 key-value 对
bool hashSetItem(HashItem **obj, int key, int val) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        hashAddItem(obj, key, val);
    } else {
        pEntry->val = val;
    }
    return true;
}

// 在散列表中查找指定 key 对应的 value，如果 key 不存在，返回默认值 defaultVal
int hashGetItem(HashItem **obj, int key, int defaultVal) {
    HashItem *pEntry = hashFindItem(obj, key);
    if (!pEntry) {
        return defaultVal;
    }
    return pEntry->val;
}

// 释放整个散列表占用的内存
void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  // 从散列表中删除
        free(curr);             // 释放结构体占用的内存
    }
}

// 求解从 cur 到 headID 的路径所需时间
int dfs(int cur, int headID, HashItem **memo, const int* manager, const int* informTime) {
    if (cur == headID) {
        return 0;
    }
    if (hashFindItem(memo, cur) != NULL) {  // 如果 memo 中已经有了 cur 的结果，直接返回
        return hashGetItem(memo, cur, 0);
    }
    int res = dfs(manager[cur], headID, memo, manager, informTime) + informTime[manager[cur]];
    hashAddItem(memo, cur, res);  // 记录结果到 memo 中
    return res;
}

// 求解整个组织机构中，从各个节点到 headID 的路径所需时间中的最大值
int numOfMinutes(int n, int headID, int* manager, int managerSize, int* informTime, int informTimeSize) {
    HashItem *memo = NULL;  // memo 存储已经求解过的路径长度
    int res = 0;
    for (int i = 0; i < n; i++) {
        res = max(res, dfs(i, headID, &memo, manager, informTime));
    }
    hashFree(&memo);
    return res;
}
```

```JavaScript [sol3-JavaScript]
// 定义函数，输入为公司总人数 n，领导的 ID headID，每个员工的直接领导的 ID 数组 manager，员工被通知所需时间的数组 informTime
var numOfMinutes = function(n, headID, manager, informTime) {
    // 定义初始值为 0 的结果变量 res 和空 Map memo，用于存储已经计算过的员工所需时间
    let res = 0;
    const memo = new Map();
    // 定义 dfs 函数，参数为当前员工的 ID cur
    const dfs = (cur) => {
        // 若当前员工为领导，返回 0
        if (cur === headID) {
            return 0;
        }
        // 若 memo 中不存在当前员工的计算结果，进行 DFS 计算
        if (!memo.has(cur)) {
            const res = dfs(manager[cur]) + informTime[manager[cur]];
            // 将当前员工的计算结果存入 memo 中
            memo.set(cur, res);
        }
        // 返回 memo 中当前员工的计算结果
        return memo.get(cur);
    }
    // 遍历每个员工，计算其所需时间，并更新结果变量 res
    for (let i = 0; i < n; i++) {
        res = Math.max(res, dfs(i));
    }
    // 返回结果变量 res
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(n)$，主要为对记忆化的空间开销。

### 练习题目推荐
- [员工的重要性](https://leetcode-cn.com/problems/employee-importance/)
- [树的中心](https://leetcode-cn.com/problems/find-center-of-star-graph/)
- [二叉树的最大深度](https://leetcode-cn.com/problems/maximum-depth-of-binary-tree/)
- [二叉树的直径](https://leetcode-cn.com/problems/diameter-of-binary-tree/)
- [填充每个节点的下一个右侧节点指针](https://leetcode-cn.com/problems/populating-next-right-pointers-in-each-node/)

### 拓展思考
本题中每个人的信息处理时间都是一样的，如果不同的人处理时间不一样，能否用类似的算法解决问题呢？

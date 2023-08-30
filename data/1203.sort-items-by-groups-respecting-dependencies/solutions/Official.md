#### 方法一：拓扑排序

**思路与算法**

做出这道题首先需要了解「拓扑排序」的相关知识。

拓扑排序简单来说，是对于一张有向图 $G$，我们需要将 $G$ 的 $n$ 个点排列成一组序列，使得图中任意一对顶点 $<u,v>$，如果图中存在一条 $u\rightarrow v$ 的边，那么 $u$ 在序列中需要出现在 $v$ 的前面。整个算法的具体过程这里不再展开赘述。如果对相关的知识还不是很熟悉，可以参考「[207. 课程表的官方题解](https://leetcode-cn.com/problems/course-schedule/solution/ke-cheng-biao-by-leetcode-solution/)」。

回到题目中，我们可以将项目抽象成点，项目间依赖关系的抽象成边，即如果进行项目 $i$ 前需要完成项目 $j$，那么就存在一条 $j\rightarrow i$ 的边。然后判断图中是否可以拓扑排序。

但这样的方法忽略了题目中的一个关键条件：「同一小组的项目，排序后在列表中彼此相邻」。这意味着**组与组之间也存在依赖关系**，故还要解决组之间的拓扑排序。基于此，解决这道题其实可以分成两步：

- 首先解决组与组的依赖关系。我们将组抽象成点，组与组的关系抽象成边，建图后判断是否存在一个拓扑排序。
- 如果存在拓扑顺序 $\textit{groupTopSort}$，我们只要再确定组内的依赖关系。遍历组间的拓扑序 $\textit{groupTopSort}$，对于任意的组 $g$，对所有属于组 $g$ 的点再进行拓扑排序。如果能够拓扑排序，则将组 $g$ 内部的拓扑序按顺序放入答案数组即可。

**实现细节**

注意到某些项目存在无人接手的情况，由于这些 $\textit{groupId}$ 都为 $-1$，为了编码方便，我们重新将其编号。由于已有的小组编号不会超过 $m-1$，因此可以将这些项目从 $m$ 开始正序编号，这样能保证不会与已存在的小组编号冲突。

为了减少编码的复杂度，我们可以将拓扑排序抽成一个函数进行复用，定义 `topSort(deg, graph, items)` 表示当前待拓扑排序的点集为 $\textit{items}$，点的入度数组为 $\textit{deg}$，点的连边关系为 $\textit{graph}$，$\textit{graph}[i]$ 表示点 $i$ 连出点组成的集合，如果不存在冲突，返回拓扑排序后的数组，否则返回一个空数组。

在建图的过程中，如果发现两个项目属于不同的项目组，则在组间的关系图中添加对应的边，否则在组内的关系图中添加对应的边。编码细节请看下面的代码。

**代码**

```JavaScript [sol1-JavaScript]
const topSort = (deg, graph, items) => {
    const Q = [];
    for (const item of items) {
        if (deg[item] === 0) {
            Q.push(item);
        }
    }
    const res = [];
    while (Q.length) {
        const u = Q.shift(); 
        res.push(u);
        for (let i = 0; i < graph[u].length; ++i) {
            const v = graph[u][i];
            if (--deg[v] === 0) {
                Q.push(v);
            }
        }
    }
    return res.length == items.length ? res : [];
}

var sortItems = function(n, m, group, beforeItems) {
    const groupItem = new Array(n + m).fill(0).map(() => []);

    // 组间和组内依赖图
    const groupGraph = new Array(n + m).fill(0).map(() => []);
    const itemGraph = new Array(n).fill(0).map(() => []);

    // 组间和组内入度数组
    const groupDegree = new Array(n + m).fill(0);
    const itemDegree = new Array(n).fill(0);
    
    const id = new Array(n + m).fill(0).map((v, index) => index);

    let leftId = m;
    // 给未分配的 item 分配一个 groupId
    for (let i = 0; i < n; ++i) {
        if (group[i] === -1) {
            group[i] = leftId;
            leftId += 1;
        }
        groupItem[group[i]].push(i);
    }
    // 依赖关系建图
    for (let i = 0; i < n; ++i) {
        const curGroupId = group[i];
        for (const item of beforeItems[i]) {
            const beforeGroupId = group[item];
            if (beforeGroupId === curGroupId) {
                itemDegree[i] += 1;
                itemGraph[item].push(i);   
            } else {
                groupDegree[curGroupId] += 1;
                groupGraph[beforeGroupId].push(curGroupId);
            }
        }
    }

    // 组间拓扑关系排序
    const groupTopSort = topSort(groupDegree, groupGraph, id); 
    if (groupTopSort.length == 0) {
        return [];
    } 
    const ans = [];
    // 组内拓扑关系排序
    for (const curGroupId of groupTopSort) {
        const size = groupItem[curGroupId].length;
        if (size == 0) {
            continue;
        }
        const res = topSort(itemDegree, itemGraph, groupItem[curGroupId]);
        if (res.length === 0) {
            return [];
        }
        for (const item of res) {
            ans.push(item);
        }
    }
    return ans;
};
```

```Java [sol1-Java]
class Solution {
    public int[] sortItems(int n, int m, int[] group, List<List<Integer>> beforeItems) {
        List<List<Integer>> groupItem = new ArrayList<List<Integer>>();
        for (int i = 0; i < n + m; ++i) {
            groupItem.add(new ArrayList<Integer>());
        }

        // 组间和组内依赖图
        List<List<Integer>> groupGraph = new ArrayList<List<Integer>>();
        for (int i = 0; i < n + m; ++i) {
            groupGraph.add(new ArrayList<Integer>());
        }
        List<List<Integer>> itemGraph = new ArrayList<List<Integer>>();
        for (int i = 0; i < n; ++i) {
            itemGraph.add(new ArrayList<Integer>());
        }

        // 组间和组内入度数组
        int[] groupDegree = new int[n + m];
        int[] itemDegree = new int[n];
        
        List<Integer> id = new ArrayList<Integer>();
        for (int i = 0; i < n + m; ++i) {
            id.add(i);
        }

        int leftId = m;
        // 给未分配的 item 分配一个 groupId
        for (int i = 0; i < n; ++i) {
            if (group[i] == -1) {
                group[i] = leftId;
                leftId += 1;
            }
            groupItem.get(group[i]).add(i);
        }
        // 依赖关系建图
        for (int i = 0; i < n; ++i) {
            int curGroupId = group[i];
            for (int item : beforeItems.get(i)) {
                int beforeGroupId = group[item];
                if (beforeGroupId == curGroupId) {
                    itemDegree[i] += 1;
                    itemGraph.get(item).add(i);   
                } else {
                    groupDegree[curGroupId] += 1;
                    groupGraph.get(beforeGroupId).add(curGroupId);
                }
            }
        }

        // 组间拓扑关系排序
        List<Integer> groupTopSort = topSort(groupDegree, groupGraph, id); 
        if (groupTopSort.size() == 0) {
            return new int[0];
        }
        int[] ans = new int[n];
        int index = 0;
        // 组内拓扑关系排序
        for (int curGroupId : groupTopSort) {
            int size = groupItem.get(curGroupId).size();
            if (size == 0) {
                continue;
            }
            List<Integer> res = topSort(itemDegree, itemGraph, groupItem.get(curGroupId));
            if (res.size() == 0) {
                return new int[0];
            }
            for (int item : res) {
                ans[index++] = item;
            }
        }
        return ans;
    }

    public List<Integer> topSort(int[] deg, List<List<Integer>> graph, List<Integer> items) {
        Queue<Integer> queue = new LinkedList<Integer>();
        for (int item : items) {
            if (deg[item] == 0) {
                queue.offer(item);
            }
        }
        List<Integer> res = new ArrayList<Integer>();
        while (!queue.isEmpty()) {
            int u = queue.poll(); 
            res.add(u);
            for (int v : graph.get(u)) {
                if (--deg[v] == 0) {
                    queue.offer(v);
                }
            }
        }
        return res.size() == items.size() ? res : new ArrayList<Integer>();
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> topSort(vector<int>& deg, vector<vector<int>>& graph, vector<int>& items) {
        queue<int> Q;
        for (auto& item: items) {
            if (deg[item] == 0) {
                Q.push(item);
            }
        }
        vector<int> res;
        while (!Q.empty()) {
            int u = Q.front(); 
            Q.pop();
            res.emplace_back(u);
            for (auto& v: graph[u]) {
                if (--deg[v] == 0) {
                    Q.push(v);
                }
            }
        }
        return res.size() == items.size() ? res : vector<int>{};
    }

    vector<int> sortItems(int n, int m, vector<int>& group, vector<vector<int>>& beforeItems) {
        vector<vector<int>> groupItem(n + m);

        // 组间和组内依赖图
        vector<vector<int>> groupGraph(n + m);
        vector<vector<int>> itemGraph(n);

        // 组间和组内入度数组
        vector<int> groupDegree(n + m, 0);
        vector<int> itemDegree(n, 0);
        
        vector<int> id;
        for (int i = 0; i < n + m; ++i) {
            id.emplace_back(i);
        }

        int leftId = m;
        // 给未分配的 item 分配一个 groupId
        for (int i = 0; i < n; ++i) {
            if (group[i] == -1) {
                group[i] = leftId;
                leftId += 1;
            }
            groupItem[group[i]].emplace_back(i);
        }
        // 依赖关系建图
        for (int i = 0; i < n; ++i) {
            int curGroupId = group[i];
            for (auto& item: beforeItems[i]) {
                int beforeGroupId = group[item];
                if (beforeGroupId == curGroupId) {
                    itemDegree[i] += 1;
                    itemGraph[item].emplace_back(i);   
                } else {
                    groupDegree[curGroupId] += 1;
                    groupGraph[beforeGroupId].emplace_back(curGroupId);
                }
            }
        }

        // 组间拓扑关系排序
        vector<int> groupTopSort = topSort(groupDegree, groupGraph, id); 
        if (groupTopSort.size() == 0) {
            return vector<int>{};
        } 
        vector<int> ans;
        // 组内拓扑关系排序
        for (auto& curGroupId: groupTopSort) {
            int size = groupItem[curGroupId].size();
            if (size == 0) {
                continue;
            }
            vector<int> res = topSort(itemDegree, itemGraph, groupItem[curGroupId]);
            if (res.size() == 0) {
                return vector<int>{};
            }
            for (auto& item: res) {
                ans.emplace_back(item);
            }
        }
        return ans;
    }
};
```

```go [sol1-Golang]
func topSort(graph [][]int, deg, items []int) (orders []int) {
    q := []int{}
    for _, i := range items {
        if deg[i] == 0 {
            q = append(q, i)
        }
    }
    for len(q) > 0 {
        from := q[0]
        q = q[1:]
        orders = append(orders, from)
        for _, to := range graph[from] {
            deg[to]--
            if deg[to] == 0 {
                q = append(q, to)
            }
        }
    }
    return
}

func sortItems(n, m int, group []int, beforeItems [][]int) (ans []int) {
    groupItems := make([][]int, m+n) // groupItems[i] 表示第 i 个组负责的项目列表
    for i := range group {
        if group[i] == -1 {
            group[i] = m + i // 给不属于任何组的项目分配一个组
        }
        groupItems[group[i]] = append(groupItems[group[i]], i)
    }

    groupGraph := make([][]int, m+n) // 组间依赖关系
    groupDegree := make([]int, m+n)
    itemGraph := make([][]int, n) // 组内依赖关系
    itemDegree := make([]int, n)
    for cur, items := range beforeItems {
        curGroupID := group[cur]
        for _, pre := range items {
            preGroupID := group[pre]
            if preGroupID != curGroupID { // 不同组项目，确定组间依赖关系
                groupGraph[preGroupID] = append(groupGraph[preGroupID], curGroupID)
                groupDegree[curGroupID]++
            } else { // 同组项目，确定组内依赖关系
                itemGraph[pre] = append(itemGraph[pre], cur)
                itemDegree[cur]++
            }
        }
    }

    // 组间拓扑序
    items := make([]int, m+n)
    for i := range items {
        items[i] = i
    }
    groupOrders := topSort(groupGraph, groupDegree, items)
    if len(groupOrders) < len(items) {
        return nil
    }

    // 按照组间的拓扑序，依次求得各个组的组内拓扑序，构成答案
    for _, groupID := range groupOrders {
        items := groupItems[groupID]
        orders := topSort(itemGraph, itemDegree, items)
        if len(orders) < len(items) {
            return nil
        }
        ans = append(ans, orders...)
    }
    return
}
```

```C [sol1-C]
int* topSort(int* returnSize, int* deg, int** graph, int* graphColSize, int* items, int itemsSize) {
    *returnSize = 0;
    int Q[itemsSize];
    int left = 0, right = 0;
    for (int i = 0; i < itemsSize; i++) {
        if (deg[items[i]] == 0) {
            Q[right++] = items[i];
        }
    }
    int* res = malloc(sizeof(int) * itemsSize);
    while (left < right) {
        int u = Q[left++];
        res[(*returnSize)++] = u;
        for (int i = 0; i < graphColSize[u]; i++) {
            int v = graph[u][i];
            if (--deg[v] == 0) {
                Q[right++] = v;
            }
        }
    }
    if (*returnSize == itemsSize) {
        return res;
    }
    *returnSize = 0;
    return NULL;
}

int* sortItems(int n, int m, int* group, int groupSize, int** beforeItems, int beforeItemsSize, int* beforeItemsColSize, int* returnSize) {
    int* groupItem[n + m];
    int groupItemColSize[n + m];
    int groupItemColCapacity[n + m];
    for (int i = 0; i < n + m; i++) {
        groupItem[i] = malloc(sizeof(int));
        groupItemColSize[i] = 0;
        groupItemColCapacity[i] = 0;
    }

    // 组间和组内依赖图
    int* groupGraph[n + m];
    int groupGraphColSize[n + m];
    int groupGraphColCapacity[n + m];
    for (int i = 0; i < n + m; i++) {
        groupGraph[i] = malloc(sizeof(int));
        groupGraphColSize[i] = 0;
        groupGraphColCapacity[i] = 0;
    }
    int* itemGraph[n];
    int itemGraphColSize[n];
    int itemGraphColCapacity[n];
    for (int i = 0; i < n; i++) {
        itemGraph[i] = malloc(sizeof(int));
        itemGraphColSize[i] = 0;
        itemGraphColCapacity[i] = 0;
    }

    // 组间和组内入度数组
    int groupDegree[n + m];
    memset(groupDegree, 0, sizeof(groupDegree));
    int itemDegree[n];
    memset(itemDegree, 0, sizeof(itemDegree));

    int id[n + m];
    for (int i = 0; i < n + m; ++i) {
        id[i] = i;
    }

    int leftId = m;
    // 给未分配的 item 分配一个 groupId
    for (int i = 0; i < n; ++i) {
        if (group[i] == -1) {
            group[i] = leftId++;
        }
        if (groupItemColSize[group[i]] == groupItemColCapacity[group[i]]) {
            int* x = &groupItemColCapacity[group[i]];
            *x = (*x) ? (*x) * 2 : 1;
            groupItem[group[i]] = realloc(groupItem[group[i]], sizeof(int) * (*x));
        }
        groupItem[group[i]][groupItemColSize[group[i]]++] = i;
    }
    // 依赖关系建图
    for (int i = 0; i < n; ++i) {
        int curGroupId = group[i];
        for (int j = 0; j < beforeItemsColSize[i]; j++) {
            int item = beforeItems[i][j];
            int beforeGroupId = group[item];
            if (beforeGroupId == curGroupId) {
                itemDegree[i]++;
                if (itemGraphColSize[item] == itemGraphColCapacity[item]) {
                    int* x = &itemGraphColCapacity[item];
                    (*x) = (*x) ? (*x) * 2 : 1;
                    itemGraph[item] = realloc(itemGraph[item], sizeof(int) * (*x));
                }
                itemGraph[item][itemGraphColSize[item]++] = i;
            } else {
                groupDegree[curGroupId]++;
                if (groupGraphColSize[beforeGroupId] == groupGraphColCapacity[beforeGroupId]) {
                    int* x = &groupGraphColCapacity[beforeGroupId];
                    (*x) = (*x) ? (*x) * 2 : 1;
                    groupGraph[beforeGroupId] = realloc(groupGraph[beforeGroupId], sizeof(int) * (*x));
                }
                groupGraph[beforeGroupId][groupGraphColSize[beforeGroupId]++] = curGroupId;
            }
        }
    }

    // 组间拓扑关系排序
    int groupTopSortSize;
    int* groupTopSort = topSort(&groupTopSortSize, groupDegree, groupGraph, groupGraphColSize, id, n + m);
    if (groupTopSortSize == 0) {
        *returnSize = 0;
        return NULL;
    }
    int* ans = malloc(sizeof(int) * groupTopSortSize);
    *returnSize = 0;
    // 组内拓扑关系排序
    for (int i = 0; i < groupTopSortSize; i++) {
        int curGroupId = groupTopSort[i];
        int size = groupItemColSize[curGroupId];
        if (size == 0) {
            continue;
        }
        int resSize;
        int* res = topSort(&resSize, itemDegree, itemGraph, itemGraphColSize, groupItem[curGroupId], groupItemColSize[curGroupId]);
        if (resSize == 0) {
            *returnSize = 0;
            return NULL;
        }
        for (int j = 0; j < resSize; j++) {
            ans[(*returnSize)++] = res[j];
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $n$ 为点数，$m$ 为边数。拓扑排序时间复杂度为 $O(n+m)$。

- 空间复杂度：$O(n+m)$。空间复杂度主要取决于存储组间和组内依赖图数组以及存储组间和组内入度数组，存储组间依赖图和入度数组的空间复杂度取决于点数和边数，空间复杂度为 $O(n+m)$，存储组内依赖图和入度数组的空间复杂度取决于点数和边数，空间复杂度为 $O(n)$。因此空间复杂度为 $O(n+m)$。
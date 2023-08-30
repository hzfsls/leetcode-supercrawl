#### 方法一：深度优先搜索 + 三色标记法

根据题意，若起始节点位于一个环内，或者能到达一个环，则该节点不是安全的。否则，该节点是安全的。

我们可以使用深度优先搜索来找环，并在深度优先搜索时，用三种颜色对节点进行标记，标记的规则如下：

- 白色（用 $0$ 表示）：该节点尚未被访问；
- 灰色（用 $1$ 表示）：该节点位于递归栈中，或者在某个环上；
- 黑色（用 $2$ 表示）：该节点搜索完毕，是一个安全节点。

当我们首次访问一个节点时，将其标记为灰色，并继续搜索与其相连的节点。

如果在搜索过程中遇到了一个灰色节点，则说明找到了一个环，此时退出搜索，栈中的节点仍保持为灰色，这一做法可以将「找到了环」这一信息传递到栈中的所有节点上。

如果搜索过程中没有遇到灰色节点，则说明没有遇到环，那么递归返回前，我们将其标记由灰色改为黑色，即表示它是一个安全的节点。

```Python [sol1-Python3]
class Solution:
    def eventualSafeNodes(self, graph: List[List[int]]) -> List[int]:
        n = len(graph)
        color = [0] * n

        def safe(x: int) -> bool:
            if color[x] > 0:
                return color[x] == 2
            color[x] = 1
            for y in graph[x]:
                if not safe(y):
                    return False
            color[x] = 2
            return True

        return [i for i in range(n) if safe(i)]
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> eventualSafeNodes(vector<vector<int>> &graph) {
        int n = graph.size();
        vector<int> color(n);

        function<bool(int)> safe = [&](int x) {
            if (color[x] > 0) {
                return color[x] == 2;
            }
            color[x] = 1;
            for (int y : graph[x]) {
                if (!safe(y)) {
                    return false;
                }
            }
            color[x] = 2;
            return true;
        };

        vector<int> ans;
        for (int i = 0; i < n; ++i) {
            if (safe(i)) {
                ans.push_back(i);
            }
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> eventualSafeNodes(int[][] graph) {
        int n = graph.length;
        int[] color = new int[n];
        List<Integer> ans = new ArrayList<Integer>();
        for (int i = 0; i < n; ++i) {
            if (safe(graph, color, i)) {
                ans.add(i);
            }
        }
        return ans;
    }

    public boolean safe(int[][] graph, int[] color, int x) {
        if (color[x] > 0) {
            return color[x] == 2;
        }
        color[x] = 1;
        for (int y : graph[x]) {
            if (!safe(graph, color, y)) {
                return false;
            }
        }
        color[x] = 2;
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<int> EventualSafeNodes(int[][] graph) {
        int n = graph.Length;
        int[] color = new int[n];
        IList<int> ans = new List<int>();
        for (int i = 0; i < n; ++i) {
            if (Safe(graph, color, i)) {
                ans.Add(i);
            }
        }
        return ans;
    }

    public bool Safe(int[][] graph, int[] color, int x) {
        if (color[x] > 0) {
            return color[x] == 2;
        }
        color[x] = 1;
        foreach (int y in graph[x]) {
            if (!Safe(graph, color, y)) {
                return false;
            }
        }
        color[x] = 2;
        return true;
    }
}
```

```go [sol1-Golang]
func eventualSafeNodes(graph [][]int) (ans []int) {
    n := len(graph)
    color := make([]int, n)
    var safe func(int) bool
    safe = func(x int) bool {
        if color[x] > 0 {
            return color[x] == 2
        }
        color[x] = 1
        for _, y := range graph[x] {
            if !safe(y) {
                return false
            }
        }
        color[x] = 2
        return true
    }
    for i := 0; i < n; i++ {
        if safe(i) {
            ans = append(ans, i)
        }
    }
    return
}
```

```JavaScript [sol1-JavaScript]
var eventualSafeNodes = function(graph) {
    const n = graph.length;
    const color = new Array(n).fill(0);
    const ans = [];
    for (let i = 0; i < n; ++i) {
        if (safe(graph, color, i)) {
            ans.push(i);
        }
    }
    return ans;
};

const safe = (graph, color, x) => {
    if (color[x] > 0) {
        return color[x] === 2;
    }
    color[x] = 1;
    for (const y of graph[x]) {
        if (!safe(graph, color, y)) {
            return false;
        }
    }
    color[x] = 2;
    return true;
}
```

```C [sol1-C]
int color[10000];

bool safe(int** graph, int graphSize, int* graphColSize, int x) {
    if (color[x] > 0) {
        return color[x] == 2;
    }
    color[x] = 1;
    for (int i = 0; i < graphColSize[x]; i++){
        if (!safe(graph, graphSize, graphColSize, graph[x][i])) {
            return false;
        }
    }
    color[x] = 2;
    return true;
}

int* eventualSafeNodes(int** graph, int graphSize, int* graphColSize, int* returnSize) {
    memset(color, 0, sizeof(int) * graphSize);
    int* ans = malloc(sizeof(int) * graphSize);
    *returnSize = 0;
    for (int i = 0; i < graphSize; ++i) {
        if (safe(graph, graphSize, graphColSize, i)) {
            ans[(*returnSize)++] = i;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $n$ 是图中的点数，$m$ 是图中的边数。

- 空间复杂度：$O(n)$。存储节点颜色以及递归栈的开销均为 $O(n)$。

#### 方法二：拓扑排序

根据题意，若一个节点没有出边，则该节点是安全的；若一个节点出边相连的点都是安全的，则该节点也是安全的。

根据这一性质，我们可以将图中所有边反向，得到一个反图，然后在反图上运行拓扑排序。

具体来说，首先得到反图 $\textit{rg}$ 及其入度数组 $\textit{inDeg}$。将所有入度为 $0$ 的点加入队列，然后不断取出队首元素，将其出边相连的点的入度减一，若该点入度减一后为 $0$，则将该点加入队列，如此循环直至队列为空。循环结束后，所有入度为 $0$ 的节点均为安全的。我们遍历入度数组，并将入度为 $0$ 的点加入答案列表。

```Python [sol2-Python3]
class Solution:
    def eventualSafeNodes(self, graph: List[List[int]]) -> List[int]:
        rg = [[] for _ in graph]
        for x, ys in enumerate(graph):
            for y in ys:
                rg[y].append(x)
        in_deg = [len(ys) for ys in graph]

        q = deque([i for i, d in enumerate(in_deg) if d == 0])
        while q:
            for x in rg[q.popleft()]:
                in_deg[x] -= 1
                if in_deg[x] == 0:
                    q.append(x)

        return [i for i, d in enumerate(in_deg) if d == 0]
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> eventualSafeNodes(vector<vector<int>> &graph) {
        int n = graph.size();
        vector<vector<int>> rg(n);
        vector<int> inDeg(n);
        for (int x = 0; x < n; ++x) {
            for (int y : graph[x]) {
                rg[y].push_back(x);
            }
            inDeg[x] = graph[x].size();
        }

        queue<int> q;
        for (int i = 0; i < n; ++i) {
            if (inDeg[i] == 0) {
                q.push(i);
            }
        }
        while (!q.empty()) {
            int y = q.front();
            q.pop();
            for (int x : rg[y]) {
                if (--inDeg[x] == 0) {
                    q.push(x);
                }
            }
        }

        vector<int> ans;
        for (int i = 0; i < n; ++i) {
            if (inDeg[i] == 0) {
                ans.push_back(i);
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> eventualSafeNodes(int[][] graph) {
        int n = graph.length;
        List<List<Integer>> rg = new ArrayList<List<Integer>>();
        for (int i = 0; i < n; ++i) {
            rg.add(new ArrayList<Integer>());
        }
        int[] inDeg = new int[n];
        for (int x = 0; x < n; ++x) {
            for (int y : graph[x]) {
                rg.get(y).add(x);
            }
            inDeg[x] = graph[x].length;
        }

        Queue<Integer> queue = new LinkedList<Integer>();
        for (int i = 0; i < n; ++i) {
            if (inDeg[i] == 0) {
                queue.offer(i);
            }
        }
        while (!queue.isEmpty()) {
            int y = queue.poll();
            for (int x : rg.get(y)) {
                if (--inDeg[x] == 0) {
                    queue.offer(x);
                }
            }
        }

        List<Integer> ans = new ArrayList<Integer>();
        for (int i = 0; i < n; ++i) {
            if (inDeg[i] == 0) {
                ans.add(i);
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<int> EventualSafeNodes(int[][] graph) {
        int n = graph.Length;
        IList<IList<int>> rg = new List<IList<int>>();
        for (int i = 0; i < n; ++i) {
            rg.Add(new List<int>());
        }
        int[] inDeg = new int[n];
        for (int x = 0; x < n; ++x) {
            foreach (int y in graph[x]) {
                rg[y].Add(x);
            }
            inDeg[x] = graph[x].Length;
        }

        Queue<int> queue = new Queue<int>();
        for (int i = 0; i < n; ++i) {
            if (inDeg[i] == 0) {
                queue.Enqueue(i);
            }
        }
        while (queue.Count > 0) {
            int y = queue.Dequeue();
            foreach (int x in rg[y]) {
                if (--inDeg[x] == 0) {
                    queue.Enqueue(x);
                }
            }
        }

        IList<int> ans = new List<int>();
        for (int i = 0; i < n; ++i) {
            if (inDeg[i] == 0) {
                ans.Add(i);
            }
        }
        return ans;
    }
}
```

```go [sol2-Golang]
func eventualSafeNodes(graph [][]int) (ans []int) {
    n := len(graph)
    rg := make([][]int, n)
    inDeg := make([]int, n)
    for x, ys := range graph {
        for _, y := range ys {
            rg[y] = append(rg[y], x)
        }
        inDeg[x] = len(ys)
    }

    q := []int{}
    for i, d := range inDeg {
        if d == 0 {
            q = append(q, i)
        }
    }
    for len(q) > 0 {
        y := q[0]
        q = q[1:]
        for _, x := range rg[y] {
            inDeg[x]--
            if inDeg[x] == 0 {
                q = append(q, x)
            }
        }
    }

    for i, d := range inDeg {
        if d == 0 {
            ans = append(ans, i)
        }
    }
    return
}
```

```JavaScript [sol2-JavaScript]
var eventualSafeNodes = function(graph) {
    const n = graph.length;
    const rg = new Array(n).fill(0).map(() => new Array());
    const inDeg = new Array(n).fill(0);
    for (let x = 0; x < n; ++x) {
        for (let y of graph[x]) {
            rg[y].push(x);
        }
        inDeg[x] = graph[x].length;
    }

    const queue = [];
    for (let i = 0; i < n; ++i) {
        if (inDeg[i] === 0) {
            queue.push(i);
        }
    }
    while (queue.length) {
        const y = queue.shift();
        for (const x of rg[y]) {
            if (--inDeg[x] === 0) {
                queue.push(x);
            }
        }
    }

    const ans = [];
    for (let i = 0; i < n; ++i) {
        if (inDeg[i] === 0) {
            ans.push(i);
        }
    }
    return ans;
};
```

```C [sol2-C]
int* eventualSafeNodes(int** graph, int graphSize, int* graphColSize, int* returnSize) {
    int n = graphSize;
    int* rg[n];
    int rgCol[n];
    memset(rgCol, 0, sizeof(rgCol));
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < graphColSize[i]; j++) {
            rgCol[graph[i][j]]++;
        }
    }
    for (int i = 0; i < n; i++) {
        rg[i] = malloc(sizeof(int) * rgCol[i]);
        rgCol[i] = 0;
    }
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < graphColSize[i]; j++) {
            rg[graph[i][j]][rgCol[graph[i][j]]++] = i;
        }
    }
    int inDeg[n];
    memcpy(inDeg, graphColSize, sizeof(int) * n);

    int que[10000];
    int left = 0, right = 0;
    for (int i = 0; i < n; ++i) {
        if (inDeg[i] == 0) {
            que[right++] = i;
        }
    }
    while (left < right) {
        int y = que[left++];
        for (int i = 0; i < rgCol[y]; i++){
            if (--inDeg[rg[y][i]] == 0) {
                que[right++] = rg[y][i];
            }
        }
    }

    int *ans = malloc(sizeof(int) * n);
    *returnSize = 0;
    for (int i = 0; i < n; ++i) {
        if (inDeg[i] == 0) {
            ans[(*returnSize)++] = i;
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $n$ 是图中的点数，$m$ 是图中的边数。

- 空间复杂度：$O(n+m)$。需要 $O(n+m)$ 的空间记录反图。
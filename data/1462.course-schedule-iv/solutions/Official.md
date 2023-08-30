#### 方法一：广度优先搜索 + 拓扑排序

**思路与算法**

题目给出 $\textit{numCourses}$ 门课（编号从 $0$ 开始），并给出了一个长度为 $n$ 的课程之间的制约关系数组 $\textit{prerequisite}$，其中 $\textit{prerequisite}[i] = [a_i, b_i]$ 表示在学习课程 $b_i$ 之前必须要完成课程 $a_i$ 的学习，即课程 $a_i$ 为 $b_i$ 的先决条件。我们可以将上述条件构建一张有向图——将每一个课程看作一个点（课程编号即为点的编号），每一个制约关系 $\textit{prerequisite}[i] = [a_i, b_i]$ 对应一条从点 $a_i$ 指向 $b_i$ 的有向边，并且题目保证了这样构建出来的图不存在环。

现在有 $m$ 个查询 $\textit{queries}$，其中对于第 $i$ 个查询 $\textit{queries}[i] = [u_i, v_i]$，我们需要判断课程 $u_i$ 是否是课程 $v_i$ 的直接或间接先决条件。我们创建一个 $\textit{numCourses} \times \textit{numCourses}$ 的矩阵 $\textit{isPre}$，其中 $\textit{isPre}[x][y]$ 表示课程 $x$ 是否是课程 $y$ 的直接或间接先决条件，若是则 $\textit{isPre}[x][y] = \text{True}$，否则 $\textit{isPre}[x][y] = \text{False}$。在完成 $\textit{isPre}$ 计算后，我们对于每一个查询就可以在 $O(1)$ 时间得到结果。对于 $\textit{isPre}$ 的计算，我们可以通过「广度优先搜索」+「拓扑排序」来对矩阵 $\textit{isPre}$ 进行计算：

首先我们需要计算有向图中每一个节点的入度，并对入度为 $0$ 的节点加入队列。然后只要队列非空，就进行以下操作：

- 取出队列队首元素，同时，将这个节点及其所有前置条件节点设置为所有后续节点的前置条件节点，然后对每一个后续节点入度进行 $-1$ 操作，若操作后的节点入度为 $0$，则继续将该节点加入队列。

「拓扑排序」结束后，矩阵 $\textit{isPre}$ 计算完毕，然后我们遍历每一个查询，根据矩阵 $\textit{isPre}$ 即可得到每一个查询的结果。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<bool> checkIfPrerequisite(int numCourses, vector<vector<int>>& prerequisites, vector<vector<int>>& queries) {
        vector<vector<int>> g(numCourses);
        vector<int> indgree(numCourses, 0);
        vector<vector<bool>> isPre(numCourses, vector<bool>(numCourses, false));
        for (auto& p : prerequisites) {
            ++indgree[p[1]];
            g[p[0]].push_back(p[1]);
        }
        queue<int> q;
        for (int i = 0; i < numCourses; ++i) {
            if (indgree[i] == 0) {
                q.push(i);
            }
        }
        while (!q.empty()) {
            auto cur = q.front();
            q.pop();
            for (auto& ne : g[cur]) {
                isPre[cur][ne] = true;
                for (int i = 0; i < numCourses; ++i) {
                    isPre[i][ne] = isPre[i][ne] | isPre[i][cur];
                }
                --indgree[ne];
                if (indgree[ne] == 0) {
                    q.push(ne);
                }
            }
        }
        vector<bool> res;
        for (auto& query : queries) {
            res.push_back(isPre[query[0]][query[1]]);
        }
        return res;
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<Boolean> checkIfPrerequisite(int numCourses, int[][] prerequisites, int[][] queries) {
        List<Integer>[] g = new List[numCourses];
        for (int i = 0; i < numCourses; i++) {
            g[i] = new ArrayList<Integer>();
        }
        int[] indgree = new int[numCourses];
        boolean[][] isPre = new boolean[numCourses][numCourses];
        for (int[] p : prerequisites) {
            ++indgree[p[1]];
            g[p[0]].add(p[1]);
        }
        Queue<Integer> queue = new ArrayDeque<Integer>();
        for (int i = 0; i < numCourses; ++i) {
            if (indgree[i] == 0) {
                queue.offer(i);
            }
        }
        while (!queue.isEmpty()) {
            int cur = queue.poll();
            for (int ne : g[cur]) {
                isPre[cur][ne] = true;
                for (int i = 0; i < numCourses; ++i) {
                    isPre[i][ne] = isPre[i][ne] | isPre[i][cur];
                }
                --indgree[ne];
                if (indgree[ne] == 0) {
                    queue.offer(ne);
                }
            }
        }
        List<Boolean> res = new ArrayList<Boolean>();
        for (int[] query : queries) {
            res.add(isPre[query[0]][query[1]]);
        }
        return res;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public IList<bool> CheckIfPrerequisite(int numCourses, int[][] prerequisites, int[][] queries) {
        IList<int>[] g = new IList<int>[numCourses];
        for (int i = 0; i < numCourses; i++) {
            g[i] = new List<int>();
        }
        int[] indgree = new int[numCourses];
        bool[][] isPre = new bool[numCourses][];
        for (int i = 0; i < numCourses; i++) {
            isPre[i] = new bool[numCourses];
        }
        foreach (int[] p in prerequisites) {
            ++indgree[p[1]];
            g[p[0]].Add(p[1]);
        }
        Queue<int> queue = new Queue<int>();
        for (int i = 0; i < numCourses; ++i) {
            if (indgree[i] == 0) {
                queue.Enqueue(i);
            }
        }
        while (queue.Count > 0) {
            int cur = queue.Dequeue();
            foreach (int ne in g[cur]) {
                isPre[cur][ne] = true;
                for (int i = 0; i < numCourses; ++i) {
                    isPre[i][ne] = isPre[i][ne] | isPre[i][cur];
                }
                --indgree[ne];
                if (indgree[ne] == 0) {
                    queue.Enqueue(ne);
                }
            }
        }
        IList<bool> res = new List<bool>();
        foreach (int[] query in queries) {
            res.Add(isPre[query[0]][query[1]]);
        }
        return res;
    }
}
```

```C [sol1-C]
bool* checkIfPrerequisite(int numCourses, int** prerequisites, int prerequisitesSize, int* prerequisitesColSize, int** queries, int queriesSize, int* queriesColSize, int* returnSize) {
    int g[numCourses][numCourses];
    int gColSize[numCourses], indgree[numCourses];
    bool isPre[numCourses][numCourses];
    memset(gColSize, 0, sizeof(gColSize));
    memset(indgree, 0, sizeof(indgree));
    memset(isPre, 0, sizeof(isPre));
    for (int i = 0; i < prerequisitesSize; i++) {
        int *p = prerequisites[i];
        ++indgree[p[1]];
        g[p[0]][gColSize[p[0]]++] = p[1];
    }

    int queue[numCourses];
    int head = 0, tail = 0;
    for (int i = 0; i < numCourses; ++i) {
        if (indgree[i] == 0) {
            queue[tail++] = i;
        }
    }
    while (head != tail) {
        int cur = queue[head];
        head++;
        for (int j = 0; j < gColSize[cur]; j++) {
            int ne = g[cur][j];
            isPre[cur][ne] = true;
            for (int i = 0; i < numCourses; ++i) {
                isPre[i][ne] = isPre[i][ne] | isPre[i][cur];
            }
            --indgree[ne];
            if (indgree[ne] == 0) {
                queue[tail++] = ne;
            }
        }
    }

    bool *res = (bool *)malloc(sizeof(char) * queriesSize);
    for (int i = 0; i < queriesSize; i++) {
        int *query = queries[i];
        res[i] = isPre[query[0]][query[1]];
    }
    *returnSize = queriesSize;
    return res;
}
```

```Python [sol1-Python3]
class Solution:
    def checkIfPrerequisite(self, numCourses: int, prerequisites: List[List[int]], queries: List[List[int]]) -> List[bool]:
        g = [[] for _ in range(numCourses)]
        indgree = [0] * numCourses
        isPre = [[False] * numCourses for _ in range(numCourses)]
        for p in prerequisites:
            indgree[p[1]] += 1
            g[p[0]].append(p[1])

        q = []
        for i in range(numCourses):
            if indgree[i] == 0:
                q.append(i)
        while len(q) > 0:
            cur = q[0]
            q.pop(0)
            for ne in g[cur]:
                isPre[cur][ne] = True
                for i in range(numCourses):
                    isPre[i][ne] = isPre[i][ne] or isPre[i][cur]
                indgree[ne] -= 1
                if indgree[ne] == 0:
                    q.append(ne)
        res = []
        for query in queries:
            res.append(isPre[query[0]][query[1]])
        return res
```

```Go [sol1-Go]
func checkIfPrerequisite(numCourses int, prerequisites [][]int, queries [][]int) []bool {
    g := make([][]int, numCourses)
    indgree := make([]int, numCourses)
    isPre := make([][]bool, numCourses)
    for i, _ := range isPre {
        isPre[i] = make([]bool, numCourses)
        g[i] = []int{}
    }
    for _, p := range prerequisites {
        indgree[p[1]]++
        g[p[0]] = append(g[p[0]], p[1])
    }

    q := []int{}
    for i := 0; i < numCourses; i++ {
        if indgree[i] == 0 {
            q = append(q, i)
        }
    }
            
    for len(q) > 0 {
        cur := q[0]
        q = q[1:]
        for _, ne:= range g[cur] {
            isPre[cur][ne] = true
            for i := 0; i < numCourses; i++ {
                isPre[i][ne] = isPre[i][ne] || isPre[i][cur]
            }
            indgree[ne]--
            if indgree[ne] == 0 {
                q = append(q, ne)
            }
        }
    }
    res := []bool{}
    for _, query := range queries {
        res = append(res, isPre[query[0]][query[1]])
    }
    return res
}
```

```JavaScript [sol1-JavaScript]
var checkIfPrerequisite = function(numCourses, prerequisites, queries) {
    let g = new Array(numCourses).fill(0).map(() => new Array());
    let indgree = new Array(numCourses).fill(0); 
    let isPre = new Array(numCourses).fill(0).map(() => new Array(numCourses).fill(false));
    for (let p of prerequisites) {
        ++indgree[p[1]];
        g[p[0]].push(p[1]);
    }
    let q = [];
    for (let i = 0; i < numCourses; ++i) {
        if (indgree[i] == 0) {
            q.push(i);
        }
    }

    while (q.length) {
        let cur = q.shift();
        for (let ne of g[cur]) {
            isPre[cur][ne] = true;
            for (let i = 0; i < numCourses; ++i) {
                isPre[i][ne] = isPre[i][ne] || isPre[i][cur];
            }
            --indgree[ne];
            if (indgree[ne] == 0) {
                q.push(ne);
            }
        }
    }
    res = [];
    for (let query of queries) {
        res.push(isPre[query[0]][query[1]]);
    }
    return res;
};
```

**复杂度分析**

- 时间复杂度：$O(\textit{numCourses}^2  + n + m)$，其中 $\textit{numCourses}$ 为课程数，$n$ 为题目给出的先决条件的数目，$m$ 为题目给出的查询数，其中通过计算矩阵 $\textit{isPre}$ 的时间复杂度为 $O(\textit{numCourses}^2)$，构建有向图的复杂度为 $O(\textit{numCourses} + n)$，处理每一个查询的复杂度为 $O(1)$，共有 $m$ 个查询，所以总的查询时间复杂度为 $O(m)$。
- 空间复杂度：$O(\textit{numCourses}^2 + n)$，其中 $\textit{numCourses}$ 为课程数，$n$ 为题目给出的先决条件的数目，主要为构建有向图和矩阵 $\textit{isPre}$ 的空间开销。注意返回值不计入空间复杂度。

#### 方法二：深度优先搜索 + 拓扑排序

**思路与算法**

「方法一」中「拓扑排序」的实现同样可以通过「深度优先搜索」来实现。与「广度优先搜索」计入每一个点的出度不同，通过「深度优先搜索」需要记录每一个点是否被访问，我们用 $\textit{vi}[x]$ 来表示课程 $x$ 是否被访问，初始时为 $\text{False}$。

我们从编号小到大遍历全部节点，若节点 $i$ 未被访问，则进入「深度优先搜索」流程：

- 若当前节点 $x$ 已被访问，则直接返回。
- 若当前节点 $x$ 未被访问，将访问状态设为已访问，然后继续对其全部后继节点递归进行「深度优先搜索」流程。将节点 $x$ 置为其每一个后继节点 $y$ 的先决条件，有 $\textit{isPre}[x][y] = \text{True}$，以及对于每一个以 $y$ 为先决条件的节点 $t$，节点 $x$ 同样为 $t$ 的先决条件，有 $\textit{isPre}[x][t] = \text{True}$。

遍历完成后，「拓扑排序」完成，矩阵 $\textit{isPre}$ 计算完毕，然后我们遍历每一个查询，根据矩阵 $\textit{isPre}$ 即可得到每一个查询的结果。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    void dfs(vector<vector<int>>& g, vector<vector<bool>>& isPre, vector<bool>& vi, int cur) {
        if (vi[cur]) {
            return;
        }
        vi[cur] = true;
        for (auto& ne : g[cur]) {
            dfs(g, isPre, vi, ne);
            isPre[cur][ne] = true;
            for (int i = 0; i < isPre.size(); ++i) {
                isPre[cur][i] = isPre[cur][i] | isPre[ne][i];
            }
        }
    }

    vector<bool> checkIfPrerequisite(int numCourses, vector<vector<int>>& prerequisites, vector<vector<int>>& queries) {
        vector<vector<int>> g(numCourses);
        vector<bool> vi(numCourses, false);
        vector<vector<bool>> isPre(numCourses, vector<bool>(numCourses, false));
        for (auto& p : prerequisites) {
            g[p[0]].push_back(p[1]);
        }
        for (int i = 0; i < numCourses; ++i) {
            dfs(g, isPre, vi, i);
        }
        vector<bool> res;
        for (auto& query : queries) {
            res.push_back(isPre[query[0]][query[1]]);
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Boolean> checkIfPrerequisite(int numCourses, int[][] prerequisites, int[][] queries) {
        List<Integer>[] g = new List[numCourses];
        for (int i = 0; i < numCourses; i++) {
            g[i] = new ArrayList<Integer>();
        }
        boolean[] vi = new boolean[numCourses];
        boolean[][] isPre = new boolean[numCourses][numCourses];
        for (int[] p : prerequisites) {
            g[p[0]].add(p[1]);
        }
        for (int i = 0; i < numCourses; ++i) {
            dfs(g, isPre, vi, i);
        }
        List<Boolean> res = new ArrayList<Boolean>();
        for (int[] query : queries) {
            res.add(isPre[query[0]][query[1]]);
        }
        return res;
    }

    public void dfs(List<Integer>[] g, boolean[][] isPre, boolean[] vi, int cur) {
        if (vi[cur]) {
            return;
        }
        vi[cur] = true;
        for (int ne : g[cur]) {
            dfs(g, isPre, vi, ne);
            isPre[cur][ne] = true;
            for (int i = 0; i < isPre.length; ++i) {
                isPre[cur][i] = isPre[cur][i] | isPre[ne][i];
            }
        }
    }
}
```

```C# [sol2-C#]
public class Solution {
    public IList<bool> CheckIfPrerequisite(int numCourses, int[][] prerequisites, int[][] queries) {
        IList<int>[] g = new IList<int>[numCourses];
        for (int i = 0; i < numCourses; i++) {
            g[i] = new List<int>();
        }
        bool[] vi = new bool[numCourses];
        bool[][] isPre = new bool[numCourses][];
        for (int i = 0; i < numCourses; i++) {
            isPre[i] = new bool[numCourses];
        }
        foreach (int[] p in prerequisites) {
            g[p[0]].Add(p[1]);
        }
        for (int i = 0; i < numCourses; ++i) {
            DFS(g, isPre, vi, i);
        }
        IList<bool> res = new List<bool>();
        foreach (int[] query in queries) {
            res.Add(isPre[query[0]][query[1]]);
        }
        return res;
    }

    public void DFS(IList<int>[] g, bool[][] isPre, bool[] vi, int cur) {
        if (vi[cur]) {
            return;
        }
        vi[cur] = true;
        foreach (int ne in g[cur]) {
            DFS(g, isPre, vi, ne);
            isPre[cur][ne] = true;
            for (int i = 0; i < isPre.Length; ++i) {
                isPre[cur][i] = isPre[cur][i] | isPre[ne][i];
            }
        }
    }
}
```

```C [sol2-C]
void dfs(const int** g, const int* gColSize, bool** isPre, bool* vi, int cur, int numCourses) {
    if (vi[cur]) {
        return;
    }
    vi[cur] = true;
    for (int j = 0; j < gColSize[cur]; j++) {
        int ne = g[cur][j];
        dfs(g, gColSize, isPre, vi, ne, numCourses);
        isPre[cur][ne] = true;
        for (int i = 0; i < numCourses; ++i) {
            isPre[cur][i] = isPre[cur][i] | isPre[ne][i];
        }
    }
}

bool* checkIfPrerequisite(int numCourses, int** prerequisites, int prerequisitesSize, int* prerequisitesColSize, int** queries, int queriesSize, int* queriesColSize, int* returnSize) {
    int *g[numCourses], gColSize[numCourses];
    bool vi[numCourses];
    bool *isPre[numCourses];

    memset(gColSize, 0, sizeof(gColSize));
    memset(vi, 0, sizeof(vi));
    for (int i = 0; i < numCourses; i++) {
        g[i] = (int *)calloc(numCourses, sizeof(int));
        isPre[i] = (bool *)calloc(numCourses, sizeof(bool));
    }
    for (int i = 0; i < prerequisitesSize; i++) {
        int *p = prerequisites[i];
        g[p[0]][gColSize[p[0]]++] = p[1];
    }
    for (int i = 0; i < numCourses; ++i) {
        dfs(g, gColSize, isPre, vi, i, numCourses);
    }
    bool *res = (bool *)malloc(sizeof(bool) * queriesSize);
    for (int i = 0; i < queriesSize; i++) {
        int *query = queries[i];
        res[i] = isPre[query[0]][query[1]];
    }
    for (int i = 0; i < numCourses; i++) {
        free(g[i]);
        free(isPre[i]);
    }
    *returnSize = queriesSize;
    return res;
}
```

```Python [sol2-Python3]
class Solution:
    def checkIfPrerequisite(self, numCourses: int, prerequisites: List[List[int]], queries: List[List[int]]) -> List[bool]:
        g = [[] for _ in range(numCourses)]
        vi = [False] * numCourses
        isPre = [[False] * numCourses for _ in range(numCourses)]
        for p in prerequisites:
            g[p[0]].append(p[1])

        def dfs(cur):
            if vi[cur]:
                return
            vi[cur] = True
            for ne in g[cur]:
                dfs(ne)
                isPre[cur][ne] = True
                for i in range(numCourses):
                    isPre[cur][i] = isPre[cur][i] | isPre[ne][i]

        for i in range(numCourses):
            dfs(i)
        res = []
        for query in queries:
            res.append(isPre[query[0]][query[1]])
        return res
        
```

```Go [sol2-Go]
func checkIfPrerequisite(numCourses int, prerequisites [][]int, queries [][]int) []bool {
    g := make([][]int, numCourses)
    vi := make([]bool, numCourses)
    isPre := make([][]bool, numCourses)
    for i := 0; i < numCourses; i++ {
        isPre[i] = make([]bool, numCourses)
        g[i] = []int{}
    }
    for _, p := range prerequisites {
        g[p[0]] = append(g[p[0]], p[1])
    }

    for i := 0; i < numCourses; i++ {
        dfs(g, isPre, vi, i)
    }
    res := []bool{}
    for _, query := range queries {
        res = append(res, isPre[query[0]][query[1]])
    }
    return res
}

func dfs(g [][]int, isPre [][]bool, vi []bool, cur int) {
    if vi[cur] {
        return
    }
    vi[cur] = true
    for _, ne := range g[cur] {
        dfs(g, isPre, vi, ne)
        isPre[cur][ne] = true
        for i := 0; i < len(isPre); i++ {
            isPre[cur][i] = isPre[cur][i] || isPre[ne][i]
        }
    }
}
```

```JavaScript [sol2-JavaScript]
var checkIfPrerequisite = function(numCourses, prerequisites, queries) {
    let g = new Array(numCourses).fill(0).map(() => new Array());
    let vi = new Array(numCourses).fill(false); 
    let isPre = new Array(numCourses).fill(0).map(() => new Array(numCourses).fill(false));
    for (let p of prerequisites) {
        g[p[0]].push(p[1]);
    }
    for (let i = 0; i < numCourses; ++i) {
        dfs(g, isPre, vi, i);
    }
    res = [];
    for (let query of queries) {
        res.push(isPre[query[0]][query[1]]);
    }
    return res;
};

var dfs = function(g, isPre, vi, cur) {
    if (vi[cur]) {
        return;
    }
    vi[cur] = true;
    for (let ne of g[cur]) {
        dfs(g, isPre, vi, ne);
        isPre[cur][ne] = true;
        for (let i = 0; i < isPre.length; ++i) {
            isPre[cur][i] = isPre[cur][i] | isPre[ne][i];
        }
    }
}
```

**复杂度分析**

- 时间复杂度：$O(\textit{numCourses}^2  + n + m)$，其中 $\textit{numCourses}$ 为课程数，$n$ 为题目给出的先决条件的数目，$m$ 为题目给出的查询数，其中计算矩阵 $\textit{isPre}$ 的时间复杂度为 $O(\textit{numCourses}^2)$，构建有向图的复杂度为 $O(\textit{numCourses} + n)$，处理每一个查询的复杂度为 $O(1)$，共有 $m$ 个查询，所以总的查询时间复杂度为 $O(m)$。
- 空间复杂度：$O(\textit{numCourses}^2 + n)$，其中 $\textit{numCourses}$ 为课程数，$n$ 为题目给出的先决条件的数目，主要为构建有向图和矩阵 $\textit{isPre}$ 的空间开销。注意返回值不计入空间复杂度。
#### 方法一：深度优先搜索

**思路与算法**

首先题目给定 $n$ 个人为一组（编号为 $1, 2, \dots, n$），其中 $n$ 为偶数，并给出数组 $\textit{dislike}$，其中 $\textit{dislike}[i] = \{a_i, b_i\}$ 表示编号 $a_i$ 的用户不喜欢用户 $b_i$，$1 \le a_i < b_i \le n$。现在判断是否能将 $n$ 个人分成两组，并满足当一个人不喜欢某一个人时，该两人不在同一组中出现。

我们可以尝试用「染色法」来解决问题：假设第一组中的人是红色，第二组中的人为蓝色。我们依次遍历每一个人，如果当前的人没有被分组，就将其分到第一组（即染为红色），那么这个人不喜欢的人必须分到第二组中（染为蓝色）。然后任何新被分到第二组中的人，其不喜欢的人必须被分到第一组，依此类推。如果在染色的过程中存在冲突，就表示这个任务是不可能完成的，否则说明染色的过程有效（即存在合法的分组方案）。

**代码**

```Python [sol1-Python3]
class Solution:
    def possibleBipartition(self, n: int, dislikes: List[List[int]]) -> bool:
        g = [[] for _ in range(n)]
        for x, y in dislikes:
            g[x - 1].append(y - 1)
            g[y - 1].append(x - 1)
        color = [0] * n  # color[x] = 0 表示未访问节点 x
        def dfs(x: int, c: int) -> bool:
            color[x] = c
            return all(color[y] != c and (color[y] or dfs(y, -c)) for y in g[x])
        return all(c or dfs(i, 1) for i, c in enumerate(color))
```

```C++ [sol1-C++]
class Solution {
public:
    bool dfs(int curnode, int nowcolor, vector<int>& color, const vector<vector<int>>& g) {
        color[curnode] = nowcolor;
        for (auto& nextnode : g[curnode]) {
            if (color[nextnode] && color[nextnode] == color[curnode]) {
                return false;
            }
            if (!color[nextnode] && !dfs(nextnode, 3 ^ nowcolor, color, g)) {
                return false;
            }
        }
        return true;
    }

    bool possibleBipartition(int n, vector<vector<int>>& dislikes) {
        vector<int> color(n + 1, 0);
        vector<vector<int>> g(n + 1);
        for (auto& p : dislikes) {
            g[p[0]].push_back(p[1]);
            g[p[1]].push_back(p[0]);
        }
        for (int i = 1; i <= n; ++i) {
            if (color[i] == 0 && !dfs(i, 1, color, g)) {
                return false;
            }
        }
        return true;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean possibleBipartition(int n, int[][] dislikes) {
        int[] color = new int[n + 1];
        List<Integer>[] g = new List[n + 1];
        for (int i = 0; i <= n; ++i) {
            g[i] = new ArrayList<Integer>();
        }
        for (int[] p : dislikes) {
            g[p[0]].add(p[1]);
            g[p[1]].add(p[0]);
        }
        for (int i = 1; i <= n; ++i) {
            if (color[i] == 0 && !dfs(i, 1, color, g)) {
                return false;
            }
        }
        return true;
    }

    public boolean dfs(int curnode, int nowcolor, int[] color, List<Integer>[] g) {
        color[curnode] = nowcolor;
        for (int nextnode : g[curnode]) {
            if (color[nextnode] != 0 && color[nextnode] == color[curnode]) {
                return false;
            }
            if (color[nextnode] == 0 && !dfs(nextnode, 3 ^ nowcolor, color, g)) {
                return false;
            }
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool PossibleBipartition(int n, int[][] dislikes) {
        int[] color = new int[n + 1];
        IList<int>[] g = new IList<int>[n + 1];
        for (int i = 0; i <= n; ++i) {
            g[i] = new List<int>();
        }
        foreach (int[] p in dislikes) {
            g[p[0]].Add(p[1]);
            g[p[1]].Add(p[0]);
        }
        for (int i = 1; i <= n; ++i) {
            if (color[i] == 0 && !DFS(i, 1, color, g)) {
                return false;
            }
        }
        return true;
    }

    public bool DFS(int curnode, int nowcolor, int[] color, IList<int>[] g) {
        color[curnode] = nowcolor;
        foreach (int nextnode in g[curnode]) {
            if (color[nextnode] != 0 && color[nextnode] == color[curnode]) {
                return false;
            }
            if (color[nextnode] == 0 && !DFS(nextnode, 3 ^ nowcolor, color, g)) {
                return false;
            }
        }
        return true;
    }
}
```

```C [sol1-C]
bool dfs(int curnode, int nowcolor, int *color, struct ListNode **g) {
    color[curnode] = nowcolor;
    for (struct ListNode *nextnode = g[curnode]; nextnode; nextnode = nextnode->next) {
        if (color[nextnode->val] && color[nextnode->val] == color[curnode]) {
            return false;
        }
        if (!color[nextnode->val] && !dfs(nextnode->val, 3 ^ nowcolor, color, g)) {
            return false;
        }
    }
    return true;
}

bool possibleBipartition(int n, int** dislikes, int dislikesSize, int* dislikesColSize) {
    int color[n + 1];
    struct ListNode *g[n + 1];
    for (int i = 0; i <= n; i++) {
        color[i] = 0;
        g[i] = NULL;
    }
    for (int i = 0; i < dislikesSize; i++) {
        int a = dislikes[i][0], b = dislikes[i][1];
        struct ListNode *node = (struct ListNode *)malloc(sizeof(struct ListNode));
        node->val = a;
        node->next = g[b];
        g[b] = node;
        node = (struct ListNode *)malloc(sizeof(struct ListNode));
        node->val = b;
        node->next = g[a];
        g[a] = node;
    }
    for (int i = 1; i <= n; ++i) {
        if (color[i] == 0 && !dfs(i, 1, color, g)) {
            for (int j = 0; j <= n; j++) {
                struct ListNode * node = g[j];
                while (node) {
                    struct ListNode * prev = node;
                    node = node->next;
                    free(prev);
                }
            }
            return false;
        }
    }
    for (int j = 0; j <= n; j++) {
        struct ListNode * node = g[j];
        while (node) {
            struct ListNode * prev = node;
            node = node->next;
            free(prev);
        }
    }
    return true;
}
```

```JavaScript [sol1-JavaScript]
var possibleBipartition = function(n, dislikes) {
    const dfs = (curnode, nowcolor, color, g) => {
        color[curnode] = nowcolor;
        for (const nextnode of g[curnode]) {
            if (color[nextnode] !== 0 && color[nextnode] === color[curnode]) {
                return false;
            }
            if (color[nextnode] === 0 && !dfs(nextnode, 3 ^ nowcolor, color, g)) {
                return false;
            }
        }
        return true;
    }
    const color = new Array(n + 1).fill(0);
    const g = new Array(n + 1).fill(0);
    for (let i = 0; i <= n; ++i) {
        g[i] = [];
    }
    for (const p of dislikes) {
        g[p[0]].push(p[1]);
        g[p[1]].push(p[0]);
    }
    for (let i = 1; i <= n; ++i) {
        if (color[i] === 0 && !dfs(i, 1, color, g)) {
            return false;
        }
    }
    return true;
};
```

```go [sol1-Golang]
func possibleBipartition(n int, dislikes [][]int) bool {
    g := make([][]int, n)
    for _, d := range dislikes {
        x, y := d[0]-1, d[1]-1
        g[x] = append(g[x], y)
        g[y] = append(g[y], x)
    }
    color := make([]int, n) // color[x] = 0 表示未访问节点 x
    var dfs func(int, int) bool
    dfs = func(x, c int) bool {
        color[x] = c
        for _, y := range g[x] {
            if color[y] == c || color[y] == 0 && !dfs(y, 3^c) {
                return false
            }
        }
        return true
    }
    for i, c := range color {
        if c == 0 && !dfs(i, 1) {
            return false
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 题目给定的人数，$m$ 为给定的 $\textit{dislike}$ 数组的大小。
- 空间复杂度：$O(n + m)$，其中 $n$ 题目给定的人数，$m$ 为给定的 $\textit{dislike}$ 数组的大小。

#### 方法二：广度优先搜索

**思路与算法**

同样我们也可以通过「广度优先搜索」来实现「方法一」中「染色法」的过程。

**代码**

```Python [sol2-Python3]
class Solution:
    def possibleBipartition(self, n: int, dislikes: List[List[int]]) -> bool:
        g = [[] for _ in range(n)]
        for x, y in dislikes:
            g[x - 1].append(y - 1)
            g[y - 1].append(x - 1)
        color = [0] * n  # color[x] = 0 表示未访问节点 x
        for i, c in enumerate(color):
            if c == 0:
                q = deque([i])
                color[i] = 1
                while q:
                    x = q.popleft()
                    for y in g[x]:
                        if color[y] == color[x]:
                            return False
                        if color[y] == 0:
                            color[y] = -color[x]
                            q.append(y)
        return True
```

```C++ [sol2-C++]
class Solution {
public:
    bool possibleBipartition(int n, vector<vector<int>>& dislikes) {
        vector<int> color(n + 1, 0);
        vector<vector<int>> g(n + 1);
        for (auto& p : dislikes) {
            g[p[0]].push_back(p[1]);
            g[p[1]].push_back(p[0]);
        }
        for (int i = 1; i <= n; ++i) {
            if (color[i] == 0) {
                queue<int> q;
                q.push(i);
                color[i] = 1;
                while (!q.empty()) {
                    auto t = q.front();
                    q.pop();
                    for (auto& next : g[t]) {
                        if (color[next] > 0 && color[next] == color[t]) {
                            return false;
                        }
                        if (color[next] == 0) {
                            color[next] = 3 ^ color[t];
                            q.push(next);
                        }
                    }
                }
            }
        }
        return true;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean possibleBipartition(int n, int[][] dislikes) {
        int[] color = new int[n + 1];
        List<Integer>[] g = new List[n + 1];
        for (int i = 0; i <= n; ++i) {
            g[i] = new ArrayList<Integer>();
        }
        for (int[] p : dislikes) {
            g[p[0]].add(p[1]);
            g[p[1]].add(p[0]);
        }
        for (int i = 1; i <= n; ++i) {
            if (color[i] == 0) {
                Queue<Integer> queue = new ArrayDeque<Integer>();
                queue.offer(i);
                color[i] = 1;
                while (!queue.isEmpty()) {
                    int t = queue.poll();
                    for (int next : g[t]) {
                        if (color[next] > 0 && color[next] == color[t]) {
                            return false;
                        }
                        if (color[next] == 0) {
                            color[next] = 3 ^ color[t];
                            queue.offer(next);
                        }
                    }
                }
            }
        }
        return true;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool PossibleBipartition(int n, int[][] dislikes) {
        int[] color = new int[n + 1];
        IList<int>[] g = new IList<int>[n + 1];
        for (int i = 0; i <= n; ++i) {
            g[i] = new List<int>();
        }
        foreach (int[] p in dislikes) {
            g[p[0]].Add(p[1]);
            g[p[1]].Add(p[0]);
        }
        for (int i = 1; i <= n; ++i) {
            if (color[i] == 0) {
                Queue<int> queue = new Queue<int>();
                queue.Enqueue(i);
                color[i] = 1;
                while (queue.Count > 0) {
                    int t = queue.Dequeue();
                    foreach (int next in g[t]) {
                        if (color[next] > 0 && color[next] == color[t]) {
                            return false;
                        }
                        if (color[next] == 0) {
                            color[next] = 3 ^ color[t];
                            queue.Enqueue(next);
                        }
                    }
                }
            }
        }
        return true;
    }
}
```

```C [sol2-C]
bool possibleBipartition(int n, int** dislikes, int dislikesSize, int* dislikesColSize) {
    int color[n + 1];
    struct ListNode *g[n + 1];
    for (int i = 0; i <= n; i++) {
        color[i] = 0;
        g[i] = NULL;
    }
    for (int i = 0; i < dislikesSize; i++) {
        int a = dislikes[i][0], b = dislikes[i][1];
        struct ListNode *node = (struct ListNode *)malloc(sizeof(struct ListNode));
        node->val = a;
        node->next = g[b];
        g[b] = node;
        node = (struct ListNode *)malloc(sizeof(struct ListNode));
        node->val = b;
        node->next = g[a];
        g[a] = node;
    }
    for (int i = 1; i <= n; ++i) {
        if (color[i] == 0) {
            int queue[n];
            int head = 0, tail = 0;
            queue[tail++] = i;
            color[i] = 1;
            while (head != tail) {
                int t = queue[head++];
                for (struct ListNode *nextNode = g[t]; nextNode; nextNode = nextNode->next) {
                    int next = nextNode->val;
                    if (color[next] > 0 && color[next] == color[t]) {
                        for (int j = 0; j <= n; j++) {
                            struct ListNode * node = g[j];
                            while (node) {
                                struct ListNode * prev = node;
                                node = node->next;
                                free(prev);
                            }
                        }
                        return false;
                    }
                    if (color[next] == 0) {
                        color[next] = 3 ^ color[t];
                        queue[tail++] = next;
                    }
                }
            }
        }
    }
    for (int j = 0; j <= n; j++) {
        struct ListNode * node = g[j];
        while (node) {
            struct ListNode * prev = node;
            node = node->next;
            free(prev);
        }
    }
    return true;
}
```

```JavaScript [sol2-JavaScript]
var possibleBipartition = function(n, dislikes) {
    const color = new Array(n + 1).fill(0);
    const g = new Array(n + 1).fill(0);
    for (let i = 0; i <= n; ++i) {
        g[i] = [];
    }
    for (const p of dislikes) {
        g[p[0]].push(p[1]);
        g[p[1]].push(p[0]);
    }
    for (let i = 1; i <= n; ++i) {
        if (color[i] === 0) {
            const queue = [i];
            color[i] = 1;
            while (queue.length !== 0) {
                const t = queue.shift();
                for (const next of g[t]) {
                    if (color[next] > 0 && color[next] === color[t]) {
                        return false;
                    }
                    if (color[next] === 0) {
                        color[next] = 3 ^ color[t];
                        queue.push(next);
                    }
                }
            }
        }
    }
    return true;
};
```

```go [sol2-Golang]
func possibleBipartition(n int, dislikes [][]int) bool {
    g := make([][]int, n)
    for _, d := range dislikes {
        x, y := d[0]-1, d[1]-1
        g[x] = append(g[x], y)
        g[y] = append(g[y], x)
    }
    color := make([]int, n) // 0 表示未访问该节点
    for i, c := range color {
        if c == 0 {
            q := []int{i}
            color[i] = 1
            for len(q) > 0 {
                x := q[0]
                q = q[1:]
                for _, y := range g[x] {
                    if color[y] == color[x] {
                        return false
                    }
                    if color[y] == 0 {
                        color[y] = -color[x]
                        q = append(q, y)
                    }
                }
            }
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n + m)$，其中 $n$ 题目给定的人数，$m$ 为给定的 $\textit{dislike}$ 数组的大小。
- 空间复杂度：$O(n + m)$，其中 $n$ 题目给定的人数，$m$ 为给定的 $\textit{dislike}$ 数组的大小。

#### 方法三：并查集

**思路与算法**

同样我们也可以用「并查集」来进行分组判断：由于最后只有两组，所以某一个人全部不喜欢人一定会在同一个组中，我们可以用「并查集」进行连接，并判断这个人是否与他不喜欢的人相连，如果相连则表示存在冲突，否则说明此人和他不喜欢的人在当前可以进行合法分组。

**代码**

```Python [sol3-Python3]
class UnionFind:
    def __init__(self, n: int):
        self.fa = list(range(n))
        self.rank = [1] * n

    def find(self, x: int) -> int:
        if self.fa[x] != x:
            self.fa[x] = self.find(self.fa[x])
        return self.fa[x]

    def union(self, x: int, y: int) -> None:
        fx, fy = self.find(x), self.find(y)
        if fx == fy:
            return
        if self.rank[fx] < self.rank[fy]:
            fx, fy = fy, fx
        self.rank[fx] += self.rank[fy]
        self.fa[fy] = fx

    def is_connected(self, x: int, y: int) -> bool:
        return self.find(x) == self.find(y)

class Solution:
    def possibleBipartition(self, n: int, dislikes: List[List[int]]) -> bool:
        g = [[] for _ in range(n)]
        for x, y in dislikes:
            g[x - 1].append(y - 1)
            g[y - 1].append(x - 1)
        uf = UnionFind(n)
        for x, nodes in enumerate(g):
            for y in nodes:
                uf.union(nodes[0], y)
                if uf.is_connected(x, y):
                    return False
        return True
```

```C++ [sol3-C++]
class Solution {
public:
    int findFa(int x, vector<int>& fa) {
        return fa[x] < 0 ? x : fa[x] = findFa(fa[x], fa);
    }

    void unit(int x, int y, vector<int>& fa) {
        x = findFa(x, fa);
        y = findFa(y, fa);
        if (x == y) {
            return ;
        }
        if (fa[x] < fa[y]) {
            swap(x, y);
        }
        fa[x] += fa[y];
        fa[y] = x;
    }

    bool isconnect(int x, int y, vector<int>& fa) {
        x = findFa(x, fa);
        y = findFa(y, fa);
        return x == y;
    }

    bool possibleBipartition(int n, vector<vector<int>>& dislikes) {
        vector<int> fa(n + 1, -1);
        vector<vector<int>> g(n + 1);
        for (auto& p : dislikes) {
            g[p[0]].push_back(p[1]);
            g[p[1]].push_back(p[0]);
        }
        for (int i = 1; i <= n; ++i) {
            for (int j = 0; j < g[i].size(); ++j) {
                unit(g[i][0], g[i][j], fa);
                if (isconnect(i, g[i][j], fa)) {
                    return false;
                }
            }
        }
        return true;
    }
};
```

```Java [sol3-Java]
class Solution {
    public boolean possibleBipartition(int n, int[][] dislikes) {
        int[] fa = new int[n + 1];
        Arrays.fill(fa, -1);
        List<Integer>[] g = new List[n + 1];
        for (int i = 0; i <= n; ++i) {
            g[i] = new ArrayList<Integer>();
        }
        for (int[] p : dislikes) {
            g[p[0]].add(p[1]);
            g[p[1]].add(p[0]);
        }
        for (int i = 1; i <= n; ++i) {
            for (int j = 0; j < g[i].size(); ++j) {
                unit(g[i].get(0), g[i].get(j), fa);
                if (isconnect(i, g[i].get(j), fa)) {
                    return false;
                }
            }
        }
        return true;
    }

    public void unit(int x, int y, int[] fa) {
        x = findFa(x, fa);
        y = findFa(y, fa);
        if (x == y) {
            return ;
        }
        if (fa[x] < fa[y]) {
            int temp = x;
            x = y;
            y = temp;
        }
        fa[x] += fa[y];
        fa[y] = x;
    }

    public boolean isconnect(int x, int y, int[] fa) {
        x = findFa(x, fa);
        y = findFa(y, fa);
        return x == y;
    }

    public int findFa(int x, int[] fa) {
        return fa[x] < 0 ? x : (fa[x] = findFa(fa[x], fa));
    }
}
```

```C# [sol3-C#]
public class Solution {
    public bool PossibleBipartition(int n, int[][] dislikes) {
        int[] fa = new int[n + 1];
        Array.Fill(fa, -1);
        IList<int>[] g = new IList<int>[n + 1];
        for (int i = 0; i <= n; ++i) {
            g[i] = new List<int>();
        }
        foreach (int[] p in dislikes) {
            g[p[0]].Add(p[1]);
            g[p[1]].Add(p[0]);
        }
        for (int i = 1; i <= n; ++i) {
            for (int j = 0; j < g[i].Count; ++j) {
                Unit(g[i][0], g[i][j], fa);
                if (Isconnect(i, g[i][j], fa)) {
                    return false;
                }
            }
        }
        return true;
    }

    public void Unit(int x, int y, int[] fa) {
        x = FindFa(x, fa);
        y = FindFa(y, fa);
        if (x == y) {
            return ;
        }
        if (fa[x] < fa[y]) {
            int temp = x;
            x = y;
            y = temp;
        }
        fa[x] += fa[y];
        fa[y] = x;
    }

    public bool Isconnect(int x, int y, int[] fa) {
        x = FindFa(x, fa);
        y = FindFa(y, fa);
        return x == y;
    }

    public int FindFa(int x, int[] fa) {
        return fa[x] < 0 ? x : (fa[x] = FindFa(fa[x], fa));
    }
}
```

```C [sol3-C]
int findFa(int x, int* fa) {
    return fa[x] < 0 ? x : (fa[x] = findFa(fa[x], fa));
}

void swap(int *a, int *b) {
    int c = *a;
    *a = *b;
    *b = c;
}

void unit(int x, int y, int* fa) {
    x = findFa(x, fa);
    y = findFa(y, fa);
    if (x == y) {
        return ;
    }
    if (fa[x] < fa[y]) {
        swap(&x, &y);
    }
    fa[x] += fa[y];
    fa[y] = x;
}

bool isconnect(int x, int y, int* fa) {
    x = findFa(x, fa);
    y = findFa(y, fa);
    return x == y;
}

bool possibleBipartition(int n, int** dislikes, int dislikesSize, int* dislikesColSize) {
    int color[n + 1], fa[n + 1];
    struct ListNode *g[n + 1];
    for (int i = 0; i <= n; i++) {
        color[i] = 0, fa[i] = -1;
        g[i] = NULL;
    }
    for (int i = 0; i < dislikesSize; i++) {
        int a = dislikes[i][0], b = dislikes[i][1];
        struct ListNode *node = (struct ListNode *)malloc(sizeof(struct ListNode));
        node->val = a;
        node->next = g[b];
        g[b] = node;
        node = (struct ListNode *)malloc(sizeof(struct ListNode));
        node->val = b;
        node->next = g[a];
        g[a] = node;
    }
    for (int i = 1; i <= n; ++i) {
        for (struct ListNode *node = g[i]; node; node = node->next) {
            unit(g[i]->val, node->val, fa);
            if (isconnect(i, node->val, fa)) {
                for (int j = 0; j <= n; j++) {
                    struct ListNode * node = g[j];
                    while (node) {
                        struct ListNode * prev = node;
                        node = node->next;
                        free(prev);
                    }
                }
                return false;
            }
        }
    }
    for (int j = 0; j <= n; j++) {
        struct ListNode * node = g[j];
        while (node) {
            struct ListNode * prev = node;
            node = node->next;
            free(prev);
        }
    }
    return true;
}
```

```JavaScript [sol3-JavaScript]
var possibleBipartition = function(n, dislikes) {
    const fa = new Array(n + 1).fill(-1);
    const g = new Array(n + 1).fill(0);
    for (let i = 0; i <= n; ++i) {
        g[i] = [];
    }
    for (const p of dislikes) {
        g[p[0]].push(p[1]);
        g[p[1]].push(p[0]);
    }
    for (let i = 1; i <= n; ++i) {
        for (let j = 0; j < g[i].length; ++j) {
            unit(g[i][0], g[i][j], fa);
            if (isconnect(i, g[i][j], fa)) {
                return false;
            }
        }
    }
    return true;
}

const unit = (x, y, fa) => {
    x = findFa(x, fa);
    y = findFa(y, fa);
    if (x === y) {
        return ;
    }
    if (fa[x] < fa[y]) {
        const temp = x;
        x = y;
        y = temp;
    }
    fa[x] += fa[y];
    fa[y] = x;
}

const isconnect = (x, y, fa) => {
    x = findFa(x, fa);
    y = findFa(y, fa);
    return x === y;
}

const findFa = (x, fa) => {
    return fa[x] < 0 ? x : (fa[x] = findFa(fa[x], fa));
}
```

```go [sol3-Golang]
type unionFind struct {
    parent, rank []int
}

func newUnionFind(n int) unionFind {
    parent := make([]int, n)
    for i := range parent {
        parent[i] = i
    }
    return unionFind{parent, make([]int, n)}
}

func (uf unionFind) find(x int) int {
    if uf.parent[x] != x {
        uf.parent[x] = uf.find(uf.parent[x])
    }
    return uf.parent[x]
}

func (uf unionFind) union(x, y int) {
    x, y = uf.find(x), uf.find(y)
    if x == y {
        return
    }
    if uf.rank[x] > uf.rank[y] {
        uf.parent[y] = x
    } else if uf.rank[x] < uf.rank[y] {
        uf.parent[x] = y
    } else {
        uf.parent[y] = x
        uf.rank[x]++
    }
}

func (uf unionFind) isConnected(x, y int) bool {
    return uf.find(x) == uf.find(y)
}

func possibleBipartition(n int, dislikes [][]int) bool {
    g := make([][]int, n)
    for _, d := range dislikes {
        x, y := d[0]-1, d[1]-1
        g[x] = append(g[x], y)
        g[y] = append(g[y], x)
    }
    uf := newUnionFind(n)
    for x, nodes := range g {
        for _, y := range nodes {
            uf.union(nodes[0], y)
            if uf.isConnected(x, y) {
                return false
            }
        }
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n + m\alpha(n))$，其中 $n$ 题目给定的人数，$m$ 为给定的 $\textit{dislike}$ 数组的大小，$\alpha$ 是反 $\text{Ackerman}$ 函数。
- 空间复杂度：$O(n + m)$，其中 $n$ 题目给定的人数，$m$ 为给定的 $\textit{dislike}$ 数组的大小。
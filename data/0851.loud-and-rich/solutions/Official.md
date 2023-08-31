## [851.喧闹和富有 中文官方题解](https://leetcode.cn/problems/loud-and-rich/solutions/100000/xuan-nao-he-fu-you-by-leetcode-solution-jnzm)
#### 方法一：深度优先搜索

我们可以根据 $\textit{richer}$ 构建一张有向图：把人看成点，如果 $a_i$ 比 $b_i$ 更有钱，那么就从 $b_i$ 向 $a_i$ 连一条有向边。由于题目保证 $\textit{richer}$ 中所给出的数据逻辑自恰，我们得到的是一张有向无环图。

因此我们从图上任意一点（设为 $x$）出发，沿着有向边所能访问到的点，都比 $x$ 更有钱。

题目需要计算拥有的钱肯定不少于 $x$ 的人中，最安静的人。我们可以分为拥有的钱肯定与 $x$ 相等，以及拥有的钱肯定比 $x$ 多两种情况。对于前者，根据题目所给信息，我们只知道 $x$ 拥有的钱肯定与自己相等，无法知道是否有其他人拥有的钱肯定与 $x$ 相等；对于后者，我们可以先计算出 $x$ 的邻居的 $\textit{answer}$ 值，再取这些 $\textit{answer}$ 值中的最小值为结果，这是因为从 $x$ 的邻居出发所能访问到的点，并上 $x$ 的邻居后所得到的点集，就是从 $x$ 出发所能访问到的点。总的来说，最安静的人要么是 $x$ 自己，要么是 $x$ 的邻居的 $\textit{answer}$ 中最安静的人。

计算 $x$ 的每个邻居的 $\textit{answer}$ 值是一个递归的过程，我们可以用深度优先搜索来实现。为避免重复运算，在已经计算出 $\textit{answer}[x]$ 的情况下可以直接返回。

```Python [sol1-Python3]
class Solution:
    def loudAndRich(self, richer: List[List[int]], quiet: List[int]) -> List[int]:
        n = len(quiet)
        g = [[] for _ in range(n)]
        for r in richer:
            g[r[1]].append(r[0])

        ans = [-1] * n
        def dfs(x: int):
            if ans[x] != -1:
                return
            ans[x] = x
            for y in g[x]:
                dfs(y)
                if quiet[ans[y]] < quiet[ans[x]]:
                    ans[x] = ans[y]
        for i in range(n):
            dfs(i)
        return ans
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> loudAndRich(vector<vector<int>> &richer, vector<int> &quiet) {
        int n = quiet.size();
        vector<vector<int>> g(n);
        for (auto &r : richer) {
            g[r[1]].emplace_back(r[0]);
        }

        vector<int> ans(n, -1);
        function<void(int)> dfs = [&](int x) {
            if (ans[x] != -1) {
                return;
            }
            ans[x] = x;
            for (int y : g[x]) {
                dfs(y);
                if (quiet[ans[y]] < quiet[ans[x]]) {
                    ans[x] = ans[y];
                }
            }
        };
        for (int i = 0; i < n; ++i) {
            dfs(i);
        }
        return ans;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] loudAndRich(int[][] richer, int[] quiet) {
        int n = quiet.length;
        List<Integer>[] g = new List[n];
        for (int i = 0; i < n; ++i) {
            g[i] = new ArrayList<Integer>();
        }
        for (int[] r : richer) {
            g[r[1]].add(r[0]);
        }

        int[] ans = new int[n];
        Arrays.fill(ans, -1);
        for (int i = 0; i < n; ++i) {
            dfs(i, quiet, g, ans);
        }
        return ans;
    }

    public void dfs(int x, int[] quiet, List<Integer>[] g, int[] ans) {
        if (ans[x] != -1) {
            return;
        }
        ans[x] = x;
        for (int y : g[x]) {
            dfs(y, quiet, g, ans);
            if (quiet[ans[y]] < quiet[ans[x]]) {
                ans[x] = ans[y];
            }
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] LoudAndRich(int[][] richer, int[] quiet) {
        int n = quiet.Length;
        IList<int>[] g = new List<int>[n];
        for (int i = 0; i < n; ++i) {
            g[i] = new List<int>();
        }
        foreach (int[] r in richer) {
            g[r[1]].Add(r[0]);
        }

        int[] ans = new int[n];
        Array.Fill(ans, -1);
        for (int i = 0; i < n; ++i) {
            DFS(i, quiet, g, ans);
        }
        return ans;
    }

    public void DFS(int x, int[] quiet, IList<int>[] g, int[] ans) {
        if (ans[x] != -1) {
            return;
        }
        ans[x] = x;
        foreach (int y in g[x]) {
            DFS(y, quiet, g, ans);
            if (quiet[ans[y]] < quiet[ans[x]]) {
                ans[x] = ans[y];
            }
        }
    }
}
```

```go [sol1-Golang]
func loudAndRich(richer [][]int, quiet []int) []int {
    n := len(quiet)
    g := make([][]int, n)
    for _, r := range richer {
        g[r[1]] = append(g[r[1]], r[0])
    }

    ans := make([]int, n)
    for i := range ans {
        ans[i] = -1
    }
    var dfs func(int)
    dfs = func(x int) {
        if ans[x] != -1 {
            return
        }
        ans[x] = x
        for _, y := range g[x] {
            dfs(y)
            if quiet[ans[y]] < quiet[ans[x]] {
                ans[x] = ans[y]
            }
        }
    }
    for i := 0; i < n; i++ {
        dfs(i)
    }
    return ans
}
```

```JavaScript [sol1-JavaScript]
var loudAndRich = function(richer, quiet) {
    const n = quiet.length;
    const g = new Array(n).fill(0);
    for (let i = 0; i < n; ++i) {
        g[i] = [];
    }
    for (const r of richer) {
        g[r[1]].push(r[0]);
    }

    const ans = new Array(n).fill(-1);
    for (let i = 0; i < n; ++i) {
        dfs(i, quiet, g, ans);
    }
    return ans;
};

const dfs = (x, quiet, g, ans) => {
    if (ans[x] !== -1) {
        return;
    }
    ans[x] = x;
    for (const y of g[x]) {
        dfs(y, quiet, g, ans);
        if (quiet[ans[y]] < quiet[ans[x]]) {
            ans[x] = ans[y];
        }
    }
}
```

```C [sol1-C]
void dfs(int x, const int* quiet, const int** graph, const int* graphColSize, int* ans) {
    if (ans[x] != -1) {
        return;
    }
    ans[x] = x;
    for (int i = 0; i < graphColSize[x]; ++i) {
        int y = graph[x][i];
        dfs(y, quiet, graph, graphColSize, ans);
        if (quiet[ans[y]] < quiet[ans[x]]) {
            ans[x] = ans[y];
        }
    }
}

int* loudAndRich(int** richer, int richerSize, int* richerColSize, int* quiet, int quietSize, int* returnSize){
    int** graph = (int **)malloc(sizeof(int *) * quietSize);
    int* graphColSize = (int *)malloc(sizeof(int) * quietSize);
    int* ans = (int *)malloc(sizeof(int) * quietSize);

    for (int i = 0; i < quietSize; ++i) {
        graph[i] = (int *)malloc(sizeof(int) * quietSize);
        ans[i] = -1;
        graphColSize[i] = 0; 
    }
    for (int i = 0; i < richerSize; ++i) {
        int x = richer[i][0];
        int y = richer[i][1];
        graph[y][graphColSize[y]] = x;
        graphColSize[y]++;
    }
    for (int i = 0; i < quietSize; ++i) {
        dfs(i, quiet, graph, graphColSize, ans);
    }
    for (int i = 0; i < quietSize; ++i) {
        free(graph[i]);
    }
    free(graphColSize);
    *returnSize = quietSize;
    return ans;
}
```


**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $n$ 是数组 $\textit{quiet}$ 的长度，$m$ 是数组 $\textit{richer}$ 的长度。建图和 DFS 的时间复杂度均为 $O(n+m)$。

- 空间复杂度：$O(n+m)$。我们需要 $O(n+m)$ 的空间来记录图中所有的点和边。

#### 方法二：拓扑排序

我们可以将方法一中的图的边全部反向，即如果 $a_i$ 比 $b_i$ 更有钱，我们从 $a_i$ 向 $b_i$ 连一条有向边。

这同样得到的是一张有向无环图，因此我们从图上任意一点（设为 $x$）出发，沿着有向边所能访问到的点，拥有的钱都比 $x$ 少。这意味着我们可以在计算出 $\textit{answer}[x]$ 后，用 $\textit{answer}[x]$ 去更新 $x$ 所能访问到的点的 $\textit{answer}$ 值。

要实现这一算法，我们可以将每个 $\textit{answer}[x]$ 初始化为 $x$，然后对这张图执行一遍拓扑排序，并按照拓扑序去更新 $x$ 的邻居的 $\textit{answer}$ 值。通过这一方式我们就能将 $\textit{answer}[x]$ 的值「传播」到 $x$ 所能访问到的点上。

```Python [sol2-Python3]
class Solution:
    def loudAndRich(self, richer: List[List[int]], quiet: List[int]) -> List[int]:
        n = len(quiet)
        g = [[] for _ in range(n)]
        inDeg = [0] * n
        for r in richer:
            g[r[0]].append(r[1])
            inDeg[r[1]] += 1

        ans = list(range(n))
        q = deque(i for i, deg in enumerate(inDeg) if deg == 0)
        while q:
            x = q.popleft()
            for y in g[x]:
                if quiet[ans[x]] < quiet[ans[y]]:
                    ans[y] = ans[x]  # 更新 x 的邻居的答案
                inDeg[y] -= 1
                if inDeg[y] == 0:
                    q.append(y)
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    vector<int> loudAndRich(vector<vector<int>> &richer, vector<int> &quiet) {
        int n = quiet.size();
        vector<vector<int>> g(n);
        vector<int> inDeg(n);
        for (auto &r : richer) {
            g[r[0]].emplace_back(r[1]);
            ++inDeg[r[1]];
        }

        vector<int> ans(n);
        iota(ans.begin(), ans.end(), 0);
        queue<int> q;
        for (int i = 0; i < n; ++i) {
            if (inDeg[i] == 0) {
                q.emplace(i);
            }
        }
        while (!q.empty()) {
            int x = q.front();
            q.pop();
            for (int y : g[x]) {
                if (quiet[ans[x]] < quiet[ans[y]]) {
                    ans[y] = ans[x]; // 更新 x 的邻居的答案
                }
                if (--inDeg[y] == 0) {
                    q.emplace(y);
                }
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int[] loudAndRich(int[][] richer, int[] quiet) {
        int n = quiet.length;
        List<Integer>[] g = new List[n];
        for (int i = 0; i < n; ++i) {
            g[i] = new ArrayList<Integer>();
        }
        int[] inDeg = new int[n];
        for (int[] r : richer) {
            g[r[0]].add(r[1]);
            ++inDeg[r[1]];
        }

        int[] ans = new int[n];
        for (int i = 0; i < n; ++i) {
            ans[i] = i;
        }
        Queue<Integer> q = new ArrayDeque<Integer>();
        for (int i = 0; i < n; ++i) {
            if (inDeg[i] == 0) {
                q.offer(i);
            }
        }
        while (!q.isEmpty()) {
            int x = q.poll();
            for (int y : g[x]) {
                if (quiet[ans[x]] < quiet[ans[y]]) {
                    ans[y] = ans[x]; // 更新 x 的邻居的答案
                }
                if (--inDeg[y] == 0) {
                    q.offer(y);
                }
            }
        }
        return ans;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int[] LoudAndRich(int[][] richer, int[] quiet) {
        int n = quiet.Length;
        IList<int>[] g = new List<int>[n];
        for (int i = 0; i < n; ++i) {
            g[i] = new List<int>();
        }
        int[] inDeg = new int[n];
        foreach (int[] r in richer) {
            g[r[0]].Add(r[1]);
            ++inDeg[r[1]];
        }

        int[] ans = new int[n];
        for (int i = 0; i < n; ++i) {
            ans[i] = i;
        }
        Queue<int> q = new Queue<int>();
        for (int i = 0; i < n; ++i) {
            if (inDeg[i] == 0) {
                q.Enqueue(i);
            }
        }
        while (q.Count > 0) {
            int x = q.Dequeue();
            foreach (int y in g[x]) {
                if (quiet[ans[x]] < quiet[ans[y]]) {
                    ans[y] = ans[x]; // 更新 x 的邻居的答案
                }
                if (--inDeg[y] == 0) {
                    q.Enqueue(y);
                }
            }
        }
        return ans;
    }
}
```

```go [sol2-Golang]
func loudAndRich(richer [][]int, quiet []int) []int {
    n := len(quiet)
    g := make([][]int, n)
    inDeg := make([]int, n)
    for _, r := range richer {
        g[r[0]] = append(g[r[0]], r[1])
        inDeg[r[1]]++
    }

    ans := make([]int, n)
    for i := range ans {
        ans[i] = i
    }
    q := make([]int, 0, n)
    for i, deg := range inDeg {
        if deg == 0 {
            q = append(q, i)
        }
    }
    for len(q) > 0 {
        x := q[0]
        q = q[1:]
        for _, y := range g[x] {
            if quiet[ans[x]] < quiet[ans[y]] {
                ans[y] = ans[x] // 更新 x 的邻居的答案
            }
            inDeg[y]--
            if inDeg[y] == 0 {
                q = append(q, y)
            }
        }
    }
    return ans
}
```

```JavaScript [sol2-JavaScript]
var loudAndRich = function(richer, quiet) {
    const n = quiet.length;
    const g = new Array(n).fill(0);
    for (let i = 0; i < n; ++i) {
        g[i] = [];
    }
    const inDeg = new Array(n).fill(0);
    for (const r of richer) {
        g[r[0]].push(r[1]);
        ++inDeg[r[1]];
    }

    const ans = new Array(n).fill(0);
    for (let i = 0; i < n; ++i) {
        ans[i] = i;
    }
    const q = [];
    for (let i = 0; i < n; ++i) {
        if (inDeg[i] === 0) {
            q.push(i);
        }
    }
    while (q.length) {
        const x = q.shift();
        for (const y of g[x]) {
            if (quiet[ans[x]] < quiet[ans[y]]) {
                ans[y] = ans[x]; // 更新 x 的邻居的答案
            }
            if (--inDeg[y] === 0) {
                q.push(y);
            }
        }
    }
    return ans;
};
```

**复杂度分析**

- 时间复杂度：$O(n+m)$，其中 $n$ 是数组 $\textit{quiet}$ 的长度，$m$ 是数组 $\textit{richer}$ 的长度。建图和拓扑排序的时间复杂度均为 $O(n+m)$。

- 空间复杂度：$O(n+m)$。我们需要 $O(n+m)$ 的空间来记录图中所有的点和边。
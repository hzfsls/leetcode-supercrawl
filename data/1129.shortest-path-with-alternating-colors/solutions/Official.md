## [1129.颜色交替的最短路径 中文官方题解](https://leetcode.cn/problems/shortest-path-with-alternating-colors/solutions/100000/yan-se-jiao-ti-de-zui-duan-lu-jing-by-le-vnuu)

#### 方法一：广度优先搜索

使用 $0$ 表示红色，$1$ 表示蓝色，对于某一节点 $x$，从节点 $0$ 到节点 $x$ 的红色边和蓝色边交替出现的路径有两种类型：

+ 类型 $0$：路径最终到节点 $x$ 的有向边为红色；

+ 类型 $1$：路径最终到节点 $x$ 的有向边为蓝色。

如果存在从节点 $0$ 到节点 $x$ 的类型 $0$ 的颜色交替路径，并且从节点 $x$ 到节点 $y$ 的有向边为蓝色，那么该路径加上该有向边组成了从节点 $0$ 到节点 $y$ 的类型 $1$ 的颜色交替路径。类似地，如果存在从节点 $0$ 到节点 $x$ 的类型 $1$ 的颜色交替路径，并且从节点 $x$ 到节点 $y$ 的有向边为红色，那么该路径加上该有向边组成了从节点 $0$ 到节点 $y$ 的类型 $0$ 的颜色交替路径。

使用广度优先搜索获取从节点 $0$ 到某一节点的两种类型的颜色交替最短路径的长度，广度优先搜索的队列元素由节点编号和节点路径类型组成，初始时节点 $0$ 到节点 $0$ 的两种类型的颜色交替最短路径的长度都是 $0$，将两个初始值入队。对于某一个队列元素，节点编号为 $x$，节点路径类型为 $t$，那么根据类型 $t$ 选择颜色为 $1-t$ 的相邻有向边，如果有向边的终点节点 $y$ 对应类型 $1-t$ 没有被访问过，那么更新节点 $y$ 的类型 $1-t$ 的颜色交替最短路径的长度为节点 $x$ 的类型 $t$ 的颜色交替最短路径的长度加 $1$，并且将它入队。

从节点 $0$ 到某一节点的颜色交替最短路径的长度为两种类型的颜色交替最短路径长度的最小值。

```Python [sol1-Python3]
class Solution:
    def shortestAlternatingPaths(self, n: int, redEdges: List[List[int]], blueEdges: List[List[int]]) -> List[int]:
        g = [[] for _ in range(n)]
        for x, y in redEdges:
            g[x].append((y, 0))
        for x, y in blueEdges:
            g[x].append((y, 1))

        dis = [-1] * n
        vis = {(0, 0), (0, 1)}
        q = [(0, 0), (0, 1)]
        level = 0
        while q:
            tmp = q
            q = []
            for x, color in tmp:
                if dis[x] == -1:
                    dis[x] = level
                for p in g[x]:
                    if p[1] != color and p not in vis:
                        vis.add(p)
                        q.append(p)
            level += 1
        return dis
```

```C++ [sol1-C++]
class Solution {
public:
    vector<int> shortestAlternatingPaths(int n, vector<vector<int>>& redEdges, vector<vector<int>>& blueEdges) {
        vector<vector<vector<int>>> next(2, vector<vector<int>>(n));
        for (auto &e : redEdges) {
            next[0][e[0]].push_back(e[1]);
        }
        for (auto &e : blueEdges) {
            next[1][e[0]].push_back(e[1]);
        }

        vector<vector<int>> dist(2, vector<int>(n, INT_MAX)); // 两种类型的颜色最短路径的长度
        queue<pair<int, int>> q;
        dist[0][0] = 0;
        dist[1][0] = 0;
        q.push({0, 0});
        q.push({0, 1});
        while (!q.empty()) {
            auto [x, t] = q.front();
            q.pop();
            for (auto y : next[1 - t][x]) {
                if (dist[1 - t][y] != INT_MAX) {
                    continue;
                }
                dist[1 - t][y] = dist[t][x] + 1;
                q.push({y, 1 - t});
            }
        }
        vector<int> answer(n);
        for (int i = 0; i < n; i++) {
            answer[i] = min(dist[0][i], dist[1][i]);
            if (answer[i] == INT_MAX) {
                answer[i] = -1;
            }
        }
        return answer;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int[] shortestAlternatingPaths(int n, int[][] redEdges, int[][] blueEdges) {
        List<Integer>[][] next = new List[2][n];
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < n; j++) {
                next[i][j] = new ArrayList<Integer>();
            }
        }
        for (int[] edge : redEdges) {
            next[0][edge[0]].add(edge[1]);
        }
        for (int[] edge : blueEdges) {
            next[1][edge[0]].add(edge[1]);
        }
        int[][] dist = new int[2][n]; // 两种类型的颜色最短路径的长度
        for (int i = 0; i < 2; i++) {
            Arrays.fill(dist[i], Integer.MAX_VALUE);
        }
        Queue<int[]> queue = new ArrayDeque<int[]>();
        dist[0][0] = 0;
        dist[1][0] = 0;
        queue.offer(new int[]{0, 0});
        queue.offer(new int[]{0, 1});
        while (!queue.isEmpty()) {
            int[] pair = queue.poll();
            int x = pair[0], t = pair[1];
            for (int y : next[1 - t][x]) {
                if (dist[1 - t][y] != Integer.MAX_VALUE) {
                    continue;
                }
                dist[1 - t][y] = dist[t][x] + 1;
                queue.offer(new int[]{y, 1 - t});
            }
        }
        int[] answer = new int[n];
        for (int i = 0; i < n; i++) {
            answer[i] = Math.min(dist[0][i], dist[1][i]);
            if (answer[i] == Integer.MAX_VALUE) {
                answer[i] = -1;
            }
        }
        return answer;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int[] ShortestAlternatingPaths(int n, int[][] redEdges, int[][] blueEdges) {
        IList<int>[][] next = new IList<int>[2][];
        for (int i = 0; i < 2; i++) {
            next[i] = new IList<int>[n];
            for (int j = 0; j < n; j++) {
                next[i][j] = new List<int>();
            }
        }
        foreach (int[] edge in redEdges) {
            next[0][edge[0]].Add(edge[1]);
        }
        foreach (int[] edge in blueEdges) {
            next[1][edge[0]].Add(edge[1]);
        }
        int[][] dist = new int[2][]; // 两种类型的颜色最短路径的长度
        for (int i = 0; i < 2; i++) {
            dist[i] = new int[n];
            Array.Fill(dist[i], int.MaxValue);
        }
        Queue<Tuple<int, int>> queue = new Queue<Tuple<int, int>>();
        dist[0][0] = 0;
        dist[1][0] = 0;
        queue.Enqueue(new Tuple<int, int>(0, 0));
        queue.Enqueue(new Tuple<int, int>(0, 1));
        while (queue.Count > 0) {
            Tuple<int, int> pair = queue.Dequeue();
            int x = pair.Item1, t = pair.Item2;
            foreach (int y in next[1 - t][x]) {
                if (dist[1 - t][y] != int.MaxValue) {
                    continue;
                }
                dist[1 - t][y] = dist[t][x] + 1;
                queue.Enqueue(new Tuple<int, int>(y, 1 - t));
            }
        }
        int[] answer = new int[n];
        for (int i = 0; i < n; i++) {
            answer[i] = Math.Min(dist[0][i], dist[1][i]);
            if (answer[i] == int.MaxValue) {
                answer[i] = -1;
            }
        }
        return answer;
    }
}
```

```C [sol1-C]
#define MIN(a, b) ((a) < (b) ? (a) : (b))

struct ListNode *createListNode(int val) {
    struct ListNode *obj = (struct ListNode *)malloc(sizeof(struct ListNode));
    obj->val = val;
    obj->next = NULL;
    return obj;
}

void freeList(struct ListNode *list) {
    while(list) {
        struct ListNode * cur = list;
        list = list->next;
        free(cur);
    }
}

int* shortestAlternatingPaths(int n, int** redEdges, int redEdgesSize, int* redEdgesColSize, int** blueEdges, int blueEdgesSize, int* blueEdgesColSize, int* returnSize) {
    struct ListNode *next[2][n];
    for (int i = 0; i < n; i++) {
        next[0][i] = NULL;
        next[1][i] = NULL;
    }
    for (int i = 0; i < redEdgesSize; i++) {
        struct ListNode *node = createListNode(redEdges[i][1]);
        node->next = next[0][redEdges[i][0]];
        next[0][redEdges[i][0]] = node;
    }
    for (int i = 0; i < blueEdgesSize; i++) {
        struct ListNode *node = createListNode(blueEdges[i][1]);
        node->next = next[1][blueEdges[i][0]];
        next[1][blueEdges[i][0]] = node;
    }

    int dist[2][n]; // 两种类型的颜色最短路径的长度
    for (int i = 0; i < n; i++) {
        dist[0][i] = dist[1][i] = INT_MAX;
    }
    
    dist[0][0] = 0;
    dist[1][0] = 0;
    int queue[n * 2][2];
    int head = 0, tail = 0;
    queue[tail][0] = 0, queue[tail++][1] = 0;
    queue[tail][0] = 0, queue[tail++][1] = 1;
    while (head != tail) {
        int x = queue[head][0], t = queue[head][1];
        head++;
        for (struct ListNode *node = next[1 - t][x]; node != NULL; node = node->next) {
            int y = node->val;
            if (dist[1 - t][y] != INT_MAX) {
                continue;
            }
            dist[1 - t][y] = dist[t][x] + 1;
            queue[tail][0] = y, queue[tail++][1] = 1- t;
        }
    }
    int *answer = (int *)malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) {
        answer[i] = MIN(dist[0][i], dist[1][i]);
        if (answer[i] == INT_MAX) {
            answer[i] = -1;
        }
    }
    *returnSize = n;
    for (int i = 0; i < n; i++) {
        freeList(next[0][i]);
        freeList(next[1][i]);
    }
    return answer;
}
```

```JavaScript [sol1-JavaScript]
var shortestAlternatingPaths = function(n, redEdges, blueEdges) {
    const next = new Array(2).fill(0).map(() => new Array(n).fill(0).map(() => new Array()));
    for (const edge of redEdges) {
        next[0][edge[0]].push(edge[1]);
    }
    for (const edge of blueEdges) {
        next[1][edge[0]].push(edge[1]);
    }
    const dist = new Array(2).fill(0).map(() => new Array(n).fill(Number.MAX_VALUE)); // 两种类型的颜色最短路径的长度
    const queue = [];
    dist[0][0] = 0;
    dist[1][0] = 0;
    queue.push([0, 0]);
    queue.push([0, 1]);
    while (queue.length) {
        const pair = queue.shift();
        let x = pair[0], t = pair[1];
        for (const y of next[1 - t][x]) {
            if (dist[1 - t][y] !== Number.MAX_VALUE) {
                continue;
            }
            dist[1 - t][y] = dist[t][x] + 1;
            queue.push([y, 1 - t]);
        }
    }
    const answer = new Array(n).fill(0);
    for (let i = 0; i < n; i++) {
        answer[i] = Math.min(dist[0][i], dist[1][i]);
        if (answer[i] === Number.MAX_VALUE) {
            answer[i] = -1;
        }
    }
    return answer;
};
```

```go [sol1-Golang]
func shortestAlternatingPaths(n int, redEdges, blueEdges [][]int) []int {
    type pair struct{ x, color int }
    g := make([][]pair, n)
    for _, e := range redEdges {
        g[e[0]] = append(g[e[0]], pair{e[1], 0})
    }
    for _, e := range blueEdges {
        g[e[0]] = append(g[e[0]], pair{e[1], 1})
    }

    dis := make([]int, n)
    for i := range dis {
        dis[i] = -1
    }
    vis := make([][2]bool, n)
    vis[0] = [2]bool{true, true}
    q := []pair{{0, 0}, {0, 1}}
    for level := 0; len(q) > 0; level++ {
        tmp := q
        q = nil
        for _, p := range tmp {
            x := p.x
            if dis[x] < 0 {
                dis[x] = level
            }
            for _, to := range g[x] {
                if to.color != p.color && !vis[to.x][to.color] {
                    vis[to.x][to.color] = true
                    q = append(q, to)
                }
            }
        }
    }
    return dis
}
```

**复杂度分析**

+ 时间复杂度：$O(n + r + b)$，其中 $n$ 是节点数，$r$ 是红色边的数目，$b$ 是蓝色边的数目。广度优先搜索最多访问一个节点两次，最多访问一条边一次，因此时间复杂度为 $O(n + r + b)$。

+ 空间复杂度：$O(n + r + b)$。队列中最多有 $2n$ 个元素，保存 $\textit{next}$ 需要 $O(r+b)$ 的空间，保存 $\textit{dist}$ 需要 $O(n)$ 的空间。
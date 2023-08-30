#### 方法一：广度优先搜索

**思路与算法**

为了判断炸弹 $u$ 能否引爆炸弹 $v$，我们需要将两个炸弹之间的距离与炸弹 $u$ 的引爆范围 $r_u$ 进行比较。假设两个炸弹之间横向距离为 $d_x$，纵向距离为 $d_y$，则 $u$ 可以引爆炸弹 $v$ 的 **充要条件**为：

$$
r_u \ge \sqrt{d_x^2 + d_y^2}.
$$

为了避免开方运算导致的精度问题影响计算结果，我们可以对上式两边取平方，即：

$$
r_u^2 \ge d_x^2 + d_y^2.
$$

我们可以以炸弹为节点，炸弹之间的引爆关系为边建立一个**有向图**，假设炸弹 $u$ 可以引爆炸弹 $v$，即炸弹 $v$ 在炸弹 $u$ 的引爆范围，那么我们就在有向图中连一条 $u \rightarrow v$ 的有向边。我们遍历所有互不相同的 $u, v$，计算引爆关系，并用邻接表 $\textit{edges}$ 表示有向图。

随后，我们遍历每个炸弹，计算每个炸弹可以引爆的炸弹数量，并维护这些数量的最大值。一种可行的计算方法是广度优先搜索。具体地，我们用 $\textit{cnt}$ 表示炸弹爆炸的数量，并用布尔数组 $\textit{visited}$ 表示每个炸弹是否被遍历到。

我们首先将最初引爆的炸弹对应下标 $i$ 加入队列，并修改 $\textit{visited}[i]$ 为 $\texttt{True}$，同时将 $\textit{cnt}$ 置为 $1$。当遍历至下标为 $\textit{cidx}$ 的炸弹时，我们在 $\textit{edges}[\textit{cidx}]$ 枚举它所有可以引爆炸弹的下标 $\textit{nidx}$，如果该炸弹未被遍历过，则我们将 $\textit{nidx}$ 加入队列，并修改 $\textit{visited}[\textit{nidx}]$ 为 $\texttt{True}$，同时将 $\textit{cnt}$ 加上 $1$。当广度优先搜索完成后， $\textit{cnt}$ 即为炸弹 $i$ 可以引爆的炸弹数目。我们维护这些数量的最大值，并返回该最大值作为答案。


**细节**

在判断引爆关系时，$r_u^2$ 或 $d_x^2 + d_y^2$ 的取值很可能超过 $32$ 位有符号整数的上界，因此我们需要使用 $64$ 位整数进行计算与比较。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximumDetonation(vector<vector<int>>& bombs) {
        int n = bombs.size();
        // 判断炸弹 u 能否引爆炸弹 v
        auto isConnected = [&](int u, int v) -> bool {
            long long dx = bombs[u][0] - bombs[v][0];
            long long dy = bombs[u][1] - bombs[v][1];
            return (long long)bombs[u][2] * bombs[u][2] >= dx * dx + dy * dy;
        };
        
        // 维护引爆关系有向图
        unordered_map<int, vector<int>> edges;
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                if (i != j && isConnected(i, j)) {
                    edges[i].push_back(j);
                }
            }
        }
        int res = 0;   // 最多引爆数量
        for (int i = 0; i < n; ++i) {
            // 遍历每个炸弹，广度优先搜索计算该炸弹可引爆的数量，并维护最大值
            vector<int> visited(n);
            int cnt = 1;
            queue<int> q;
            q.push(i);
            visited[i] = 1;
            while (!q.empty()) {
                int cidx = q.front();
                q.pop();
                for (const int nidx: edges[cidx]) {
                    if (visited[nidx]) {
                        continue;
                    }
                    ++cnt;
                    q.push(nidx);
                    visited[nidx] = 1;
                }
            }
            res = max(res, cnt);
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def maximumDetonation(self, bombs: List[List[int]]) -> int:
        n = len(bombs)
        # 判断炸弹 u 能否引爆炸弹 v
        def isConnected(u: int, v: int) -> bool:
            dx = bombs[u][0] - bombs[v][0]
            dy = bombs[u][1] - bombs[v][1]
            return bombs[u][2] ** 2 >= dx ** 2 + dy ** 2
        
        # 维护引爆关系有向图
        edges = defaultdict(list)
        for i in range(n):
            for j in range(n):
                if i != j and isConnected(i, j):
                    edges[i].append(j)
        res = 0   # 最多引爆数量
        for i in range(n):
            # 遍历每个炸弹，广度优先搜索计算该炸弹可引爆的数量，并维护最大值
            visited = [False] * n
            cnt = 1
            q = deque([i])
            visited[i] = True
            while q:
                cidx = q.popleft()
                for nidx in edges[cidx]:
                    if visited[nidx]:
                        continue
                    cnt += 1
                    q.append(nidx)
                    visited[nidx] = True
            res = max(res, cnt)
        return res
```


**复杂度分析**

- 时间复杂度：$O(n^3)$，其中 $n$ 为 $\textit{bombs}$ 的长度。建立有向图的时间复杂度为 $O(n^2)$，对于每个炸弹进行广度优先搜索确定可引爆数量的时间复杂度为 $O(n^2)$，我们需要对每个炸弹进行一次广度优先搜索。

- 空间复杂度：$O(n^2)$，即为邻接表的空间开销。
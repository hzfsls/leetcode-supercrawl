#### 方法一：拓扑排序

**提示 $1$**

有向无环图中，每个节点的所有祖先节点集合即为该节点所有父节点（即有一条**直接**指向该节点的有向边的节点）的**本身及其祖先节点**组成集合的**并集**。

**思路与算法**

根据 **提示 $1$**，如果我们按照拓扑排序的顺序来遍历每个节点并计算祖先节点集合，那么遍历到某个节点时，其所有父节点的祖先节点集合都已计算完成，我们就可以直接对这些集合加上父节点本身取并集得到该节点的所有祖先节点。这一「取并集」的过程等价于在拓扑排序的过程中用每个节点的祖先集合更新每个节点所有子节点的祖先集合。

具体地，我们用哈希表数组 $\textit{anc}$ 来表示每个节点的祖先节点集合，用 $e$ 以**邻接表**形式存储每个节点的所有**出边**，并用数组 $\textit{indeg}$ 来计算每个结点的入度。

我们可以用广度优先搜索的方法求解拓扑排序。首先我们遍历 $\textit{edges}$ 数组预处理邻接表 $e$ 和入度表 $\textit{indeg}$，并将所有入度为 $0$ 的节点加入广度优先搜索队列 $q$。此时队列里的元素对应的祖先节点集合均为空集，且都已经更新完成。

在遍历到节点 $u$ 时，我们首先遍历所有通过出边相邻的子节点 $v$，此时根据定义 $u$ 一定是 $v$ 的父节点，且根据拓扑序，$u$ 的祖先节点集合 $\textit{anc}[u]$ 已经更新完毕。因此我们将 $\textit{anc}[u]$ 的所有元素和 $u$ 加入至 $\textit{anc}[v]$ 中，并将 $v$ 的入度 $\textit{indeg}[v]$ 减去 $1$。此时，如果 $\textit{indeg}[v] = 0$，则说明 $\textit{anc}[v]$ 已经更新完成，此时我们将 $v$ 加入队列。

最终，我们需要利用嵌套数组 $\textit{res}$ 将 $\textit{anc}$ 中的每个哈希集合对应地转化为升序排序后的数组，此时 $\textit{res}$ 即为待求的升序排序的每个节点的所有祖先。我们返回 $\textit{res}$ 作为答案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> getAncestors(int n, vector<vector<int>>& edges) {
        vector<unordered_set<int>> anc(n);   // 存储每个节点祖先的辅助数组
        vector<vector<int>> e(n);   // 邻接表
        vector<int> indeg(n);   // 入度表
        // 预处理
        for (const auto& edge: edges) {
            e[edge[0]].push_back(edge[1]);
            ++indeg[edge[1]];
        }
        // 广度优先搜索求解拓扑排序
        queue<int> q;
        for (int i = 0; i < n; ++i) {
            if (!indeg[i]) {
                q.push(i);
            }
        }
        while (!q.empty()) {
            int u = q.front();
            q.pop();
            for (int v: e[u]) {
                // 更新子节点的祖先哈希表
                anc[v].insert(u);
                for (int i: anc[u]) {
                    anc[v].insert(i);
                }
                --indeg[v];
                if (!indeg[v]) {
                    q.push(v);
                }
            }
        }
        // 转化为答案数组
        vector<vector<int>> res(n);
        for (int i = 0; i < n; ++i) {
            for (int j: anc[i]) {
                res[i].push_back(j);
            }
            sort(res[i].begin(), res[i].end());
        }
        return res;
    }
};
```


```Python [sol1-Python3]
class Solution:
    def getAncestors(self, n: int, edges: List[List[int]]) -> List[List[int]]:
        anc = [set() for _ in range(n)]   # 存储每个节点祖先的辅助数组
        e = [[] for _ in range(n)] # 邻接表
        indeg = [0] * n   # 入度表
        # 预处理
        for u, v in edges:
            e[u].append(v)
            indeg[v] += 1
        # 广度优先搜索求解拓扑排序
        q = deque()
        for i in range(n):
            if indeg[i] == 0:
                q.append(i)
        while q:
            u = q.popleft()
            for v in e[u]:
                # 更新子节点的祖先哈希表
                anc[v].add(u)
                anc[v].update(anc[u])
                indeg[v] -= 1
                if indeg[v] == 0:
                    q.append(v)
        # 转化为答案数组
        res = [sorted(anc[i]) for i in range(n)]        
        return res
```


**复杂度分析**

- 时间复杂度：$O(VE + V^2 \log V)$，其中 $V = n$ 为节点数量；$E$ 为边的数量，即 $\textit{edges}$ 的长度。其中广度优先搜索的时间复杂度为 $O(VE)$，对辅助数组排序生成答案数组的时间复杂度为 $O(V^2 \log V)$。

- 空间复杂度：$O(V^2)$，即为存储每个节点祖先的辅助数组的空间开销。
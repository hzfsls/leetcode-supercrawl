## [2065.最大化一张图中的路径价值 中文官方题解](https://leetcode.cn/problems/maximum-path-quality-of-a-graph/solutions/100000/zui-da-hua-yi-zhang-tu-zhong-de-lu-jing-yim5i)

#### 方法一：枚举所有可能的路径

**思路与算法**

仔细阅读题目描述我们可以发现，$\textit{time}_j$ 的最小值为 $10$，而 $\textit{maxTime}$ 的最大值为 $100$。这说明我们**至多**只会经过图上的 $10$ 条边。由于图中每个节点的度数都不超过 $4$，因此我们可以枚举所有从节点 $0$ 开始的路径。

我们可以使用递归 + 回溯的方法进行枚举。递归函数记录当前所在的节点编号，已经过的路径的总时间以及节点的价值之和。如果当前在节点 $u$，我们可以枚举与 $u$ 直接相连的节点 $v$ 进行递归搜索。在搜索的过程中，如果我们回到了节点 $0$，就可以对答案进行更新；如果总时间超过了 $\textit{maxTime}$，我们需要停止搜索，进行回溯。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int maximalPathQuality(vector<int>& values, vector<vector<int>>& edges, int maxTime) {
        int n = values.size();
        vector<vector<pair<int, int>>> g(n);
        for (const auto& edge: edges) {
            g[edge[0]].emplace_back(edge[1], edge[2]);
            g[edge[1]].emplace_back(edge[0], edge[2]);
        }
        
        vector<int> visited(n);
        visited[0] = true;
        int ans = 0;
        
        function<void(int, int, int)> dfs = [&](int u, int time, int value) {
            if (u == 0) {
                ans = max(ans, value);
            }
            for (const auto& [v, dist]: g[u]) {
                if (time + dist <= maxTime) {
                    if (!visited[v]) {
                        visited[v] = true;
                        dfs(v, time + dist, value + values[v]);
                        visited[v] = false;
                    }
                    else {
                        dfs(v, time + dist, value);
                    }
                }
            }
        };
        
        dfs(0, 0, values[0]);
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def maximalPathQuality(self, values: List[int], edges: List[List[int]], maxTime: int) -> int:
        g = defaultdict(list)
        for x, y, z in edges:
            g[x].append((y, z))
            g[y].append((x, z))
        
        visited = {0}
        ans = 0
        
        def dfs(u: int, time: int, value: int) -> None:
            if u == 0:
                nonlocal ans
                ans = max(ans, value)
            for v, dist in g[u]:
                if time + dist <= maxTime:
                    if v not in visited:
                        visited.add(v)
                        dfs(v, time + dist, value + values[v])
                        visited.discard(v)
                    else:
                        dfs(v, time + dist, value)
        
        dfs(0, 0, values[0])
        return ans

```

**复杂度分析**

- 时间复杂度：$O(n + m + d^k)$，其中 $m$ 是数组 $\textit{edges}$ 的长度，$d$ 是图中每个点度数的最大值，$k$ 是最多经过的边的数量，在本题中 $d = 4, k = 10$。
    
    - 将 $\textit{edges}$ 存储成邻接表的形式需要的时间为 $O(n + m)$。

    - 搜索需要的时间为 $O(d^k)$。

- 空间复杂度：$O(n + m + k)$。

    - 邻接表需要的空间为 $O(n + m)$。

    - 记录每个节点是否访问过的数组需要的空间为 $O(n)$。

    - 搜索中栈需要的空间为 $O(k)$。
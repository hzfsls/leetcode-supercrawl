#### 方法一：有向图的欧拉通路

**思路与算法**

如果我们把数组 $\textit{pairs}$ 中出现的每个数看成一个节点，$(\textit{start}_i, \textit{end}_i)$ 看成从 $\textit{start}_i$ 到 $\textit{end}_i$ 的一条有向边，那么 $\textit{pairs}$ 的一个合法排列就对应着：

- 从节点 $\textit{pairs}[0][0]$ 开始；

- 依次经过 $\textit{pairs}[0][1], \textit{pairs}[1][1], \cdots, \textit{pairs}[n-1][1]$；

的一条路径，其中 $n$ 是数组 $\textit{pairs}$ 的长度。这条路径经过了图上的每一条边恰好一次，是一条「欧拉通路」，因此我们的目标就是找出图上的任意一条欧拉通路。

求解欧拉通路可以使用深度优先搜索，这里对算法本身不再赘述，感兴趣的读者可以参考[「OI Wiki — 欧拉图」](https://oi-wiki.org/graph/euler/) 或其它资料，我们一般使用 $\text{Hierholzer}$ 算法求解欧拉通路，在力扣平台上还有如下与欧拉回路或欧拉通路有关的题目：

- [「332. 重新安排行程」](https://leetcode-cn.com/problems/reconstruct-itinerary/)

- [「753. 破解保险箱」](https://leetcode-cn.com/problems/cracking-the-safe/)

对于本题而言，我们首先需要找到欧拉通路的起始节点：如果图中所有节点的入度和出度都相等，那么从任意节点开始都存在欧拉通路；如果图中存在一个节点的出度比入度恰好多 $1$，另一个节点的入度恰好比出度多 $1$，那么欧拉通路必须从前一个节点开始，到后一个节点结束。除此之外的有向图都不存在欧拉通路，本体保证了至少存在一个合法排列，因此图已经是上述的两种情况之一。

当我们确定起始节点后，就可以使用深度优先搜索求解欧拉通路了。如果我们得到的欧拉通路为：

$$
v_1, v_2, v_3, \cdots, v_n, v_{n+1}
$$

那么 $[[v_1, v_2], [v_2, v_3], \cdots, [v_n, v_{n+1}]]$ 就是一个合法排列。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    vector<vector<int>> validArrangement(vector<vector<int>>& pairs) {
        // 存储图
        unordered_map<int, vector<int>> edges;
        // 存储入度和出度
        unordered_map<int, int> indeg, outdeg;
        for (const auto& p: pairs) {
            int x = p[0], y = p[1];
            edges[x].push_back(y);
            ++indeg[y];
            ++outdeg[x];
        }
        
        // 寻找起始节点
        int start = pairs[0][0];
        for (const auto& [x, occ]: outdeg) {
            // 如果有节点出度比入度恰好多 1，那么只有它才能是起始节点
            if (occ == indeg[x] + 1) {
                start = x;
                break;
            }
        }
        
        vector<vector<int>> ans;
        
        // 深度优先搜索（Hierholzer 算法）求解欧拉通路
        function<void(int)> dfs = [&](int u) {
            while (!edges[u].empty()) {
                int v = edges[u].back();
                edges[u].pop_back();
                dfs(v);
                ans.push_back({u, v});
            }
        };
        
        dfs(start);
        reverse(ans.begin(), ans.end());
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def validArrangement(self, pairs: List[List[int]]) -> List[List[int]]:
        # 存储图
        edges = defaultdict(list)
        # 存储入度和出度
        indeg, outdeg = Counter(), Counter()
        for x, y in pairs:
            edges[x].append(y)
            indeg[y] += 1
            outdeg[x] += 1
        
        # 寻找起始节点
        start = pairs[0][0]
        for x in outdeg:
            # 如果有节点出度比入度恰好多 1，那么只有它才能是起始节点
            if outdeg[x] == indeg[x] + 1:
                start = x
                break
        
        ans = list()
        
        # 深度优先搜索（Hierholzer 算法）求解欧拉通路
        def dfs(u: int) -> None:
            while edges[u]:
                v = edges[u].pop()
                dfs(v)
                ans.append([u, v])
        
        dfs(start)
        return ans[::-1]
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是数组 $\textit{pairs}$ 的长度。图中有不超过 $n+1$ 个节点和 $n$ 条边，因此求解欧拉通路需要的时间为 $O(n)$。

- 空间复杂度：$O(n)$，即为存储图需要使用的空间。
#### 方法一：深度优先搜索

这道题中，树的表示方法是一个连通的**无环无向图**。树中包含编号从 $0$ 到 $n-1$ 的 $n$ 个节点，其中根节点为节点 $0$，以及 $n-1$ 条**无向**边。由于给出的边是无向的，因此不能直接从边的节点先后顺序判断父节点和子节点。

虽然给出的边是无向的，但是由于根节点已知，因此从根节点开始搜索，对每个访问到的节点标记为已访问，即可根据节点是否被访问过的信息知道相邻节点的父子关系。除了打访问标记外，还有一个办法可以解决这个问题，即在深度优先搜索的时候，把父节点当参数传入，即 `depthFirstSearch(now, pre, ...)` 的形式，其中 `now` 为当前节点，`pre` 为它的父节点，这样当邻接表中存的是无向图时，我们只要在拓展节点的时候判断 `now` 拓展到的节点等不等于 `pre`，即可避免再次拓展到父节点。下面 `Java` 代码中，给出前者的实现；`C++` 和 `Python` 代码中，给出后者的实现。

这道题需要求出每个节点的子树中与该节点标签相同的节点数，即该节点的子树中，该节点标签出现的次数。由于一个节点的子树中可能包含任意的标签，因此需要对每个节点记录该节点的子树中的所有标签的出现次数。又由于标签一定是小写字母，因此只需要对每个节点维护一个长度为 $26$ 的数组即可。

显然，一个节点的子树中的每个标签出现的次数，由该节点的左右子树中的每个标签出现的次数以及该节点自身的标签决定，因此可以使用深度优先搜索，递归地计算每个节点的子树中的每个标签出现的次数。

当得到一个节点的子树中的每个标签出现的次数之后，即可根据该节点的标签，得到子树中与该节点标签相同的节点数。

```Java [sol1-Java]
class Solution {
    public int[] countSubTrees(int n, int[][] edges, String labels) {
        Map<Integer, List<Integer>> edgesMap = new HashMap<Integer, List<Integer>>();
        for (int[] edge : edges) {
            int node0 = edge[0], node1 = edge[1];
            List<Integer> list0 = edgesMap.getOrDefault(node0, new ArrayList<Integer>());
            List<Integer> list1 = edgesMap.getOrDefault(node1, new ArrayList<Integer>());
            list0.add(node1);
            list1.add(node0);
            edgesMap.put(node0, list0);
            edgesMap.put(node1, list1);
        }
        int[] counts = new int[n];
        boolean[] visited = new boolean[n];
        depthFirstSearch(0, counts, visited, edgesMap, labels);
        return counts;
    }

    public int[] depthFirstSearch(int node, int[] counts, boolean[] visited, Map<Integer, List<Integer>> edgesMap, String labels) {
        visited[node] = true;
        int[] curCounts = new int[26];
        curCounts[labels.charAt(node) - 'a']++;
        List<Integer> nodesList = edgesMap.get(node);
        for (int nextNode : nodesList) {
            if (!visited[nextNode]) {
                int[] childCounts = depthFirstSearch(nextNode, counts, visited, edgesMap, labels);
                for (int i = 0; i < 26; i++) {
                    curCounts[i] += childCounts[i];
                }
            }
        }
        counts[node] = curCounts[labels.charAt(node) - 'a'];
        return curCounts;
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    vector<vector<int>> g;
    vector<vector<int>> f; 
    
    void dfs(int o, int pre, const string &labels) {
        f[o][labels[o] - 'a'] = 1;
        for (const auto &nex: g[o]) {
            if (nex == pre) {
                continue;
            } 
            dfs(nex, o, labels);
            for (int i = 0; i < 26; ++i) {
                f[o][i] += f[nex][i];
            }
        }
    }
    
    vector<int> countSubTrees(int n, vector<vector<int>>& edges, string labels) {
        g.resize(n);
        for (const auto &edge: edges) {
            g[edge[0]].push_back(edge[1]);
            g[edge[1]].push_back(edge[0]);
        }
        f.assign(n, vector<int>(26));
        dfs(0, -1, labels);
        vector<int> ans;
        for (int i = 0; i < n; ++i) {
            ans.push_back(f[i][labels[i] - 'a']);
        }
        return ans;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def countSubTrees(self, n: int, edges: List[List[int]], labels: str) -> List[int]:
        g = collections.defaultdict(list)
        for x, y in edges:
            g[x].append(y)
            g[y].append(x)
        
        def dfs(o: int, pre: int):
            f[o][ord(labels[o]) - ord("a")] = 1
            for nex in g[o]:
                if nex != pre:
                    dfs(nex, o)
                    for i in range(26):
                        f[o][i] += f[nex][i]

        f = [[0] * 26 for _ in range(n)]
        dfs(0, -1)

        ans = [f[i][ord(labels[i]) - ord("a")] for i in range(n)]
        return ans
```

**复杂度分析**

- 时间复杂度：$O(nc)$，其中 $n$ 是树中的节点数，$c$ 是字符集大小，此处 $c = 26$。深度优先搜索需要对树中的每个节点访问一次，对每个节点都需要更新所有可能的标签出现的次数，由于标签都是小写字母，需要对 $26$ 个字母都进行一次讨论。

- 空间复杂度：$O(nc)$，其中 $n$ 是树中的节点数。空间复杂度主要取决于递归栈的调用深度，递归栈的调用深度不会超过 $n$。
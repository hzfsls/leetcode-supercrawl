## [323.无向图中连通分量的数目 中文官方题解](https://leetcode.cn/problems/number-of-connected-components-in-an-undirected-graph/solutions/100000/wu-xiang-tu-zhong-lian-tong-fen-liang-de-jzlu)
[TOC]

 ## 解决方案

---

 #### 方法 1：深度优先搜索 (DFS)



 **概述**



 在无向图中，连通分量是一个子图，其中每对顶点都通过一条路径连接。因此，本质上，连通分量中的所有顶点都是相互可以到达的。
 让我们看看如何使用 DFS 来解决这个问题。如果我们从一个特定的顶点开始运行 DFS，它将继续深度优先访问顶点，直到没有更多的相邻顶点可以访问为止。因此，它将访问包含起始顶点的连通分量中的所有顶点。每次我们完成一个连通分量的探索，我们可以找到一个 _还未被访问过的_ 顶点，并从那里开始新的 DFS。开始新的 DFS 的次数就是连通分量的数量。
 下面是一个示例来说明这个方法。  

 ![image.png](https://pic.leetcode.cn/1692176588-ORwprN-image.png){:width=800}

 *图1.演示 DFS 方法的示例。*

 **算法**



 1. 创建一个邻接列表，使得 `adj[v]` 包含所有顶点 `v` 的相邻顶点。
 2. 初始化一个 hashmap 或数组 `visited`，来跟踪已经访问过的顶点。
 3. 定义一个 `counter` 变量，并将其初始化为零。
 4. 在 `edges` 中的每个顶点上循环，如果该顶点还未在 `visited` 中，那么从它开始进行 DFS。将 DFS 中访问过的每个顶点都加入到 `visited` 中。
 5. 每次开始一个新的 DFS 时，将 `counter` 变量增加 1。
 6. 最后，`counter` 变量将包含无向图中的连通分量的数量。

 ```C++ [slu1]
 class Solution {
public:
    void dfs(vector<int> adjList[], vector<int> &visited, int src) {
        visited[src] = 1;
        
        for (int i = 0; i < adjList[src].size(); i++) {
            if (visited[adjList[src][i]] == 0) {
                dfs(adjList, visited, adjList[src][i]);
            }
        }
    }
    
    int countComponents(int n, vector<vector<int>>& edges) {
        if (n == 0) return 0;
      
        int components = 0;
        vector<int> visited(n, 0);
        vector<int> adjList[n];
    
        for (int i = 0; i < edges.size(); i++) {
            adjList[edges[i][0]].push_back(edges[i][1]);
            adjList[edges[i][1]].push_back(edges[i][0]);
        }
        
        for (int i = 0; i < n; i++) {
            if (visited[i] == 0) {
                components++;
                dfs(adjList, visited, i);
            }
        }
        return components;
    }
};
 ```

 ```Java [slu1]
 class Solution {
    
     private void dfs(List<Integer>[] adjList, int[] visited, int startNode) {
        visited[startNode] = 1;
         
        for (int i = 0; i < adjList[startNode].size(); i++) {
            if (visited[adjList[startNode].get(i)] == 0) {
                dfs(adjList, visited, adjList[startNode].get(i));
            }
        }
    }
    
    public int countComponents(int n, int[][] edges) {
        int components = 0;
        int[] visited = new int[n];
        
        List<Integer>[] adjList = new ArrayList[n]; 
        for (int i = 0; i < n; i++) {
            adjList[i] = new ArrayList<Integer>();
        }
        
        for (int i = 0; i < edges.length; i++) {
            adjList[edges[i][0]].add(edges[i][1]);
            adjList[edges[i][1]].add(edges[i][0]);
        }
        
        for (int i = 0; i < n; i++) {
            if (visited[i] == 0) {
                components++;
                dfs(adjList, visited, i);
            }
        }
        return components;
    }
}
 ```

 **复杂度分析**



 设 E 为边的数量，V 为顶点的数量。

 * 时间复杂度：${O}(E + V)$。
    建立邻接列表将花费 O(E) 的操作，这是因为我们一次遍历边的列表，将每条边插入两个列表中。
    在DFS遍历中，每个顶点只会被访问一次。这是因为我们在看到每个顶点时就将其标记为已访问，然后我们只访问那些没有被标记为已访问的顶点。同时，当我们在每个顶点的边列表上迭代时，我们会看一遍每条边。这总共需要 ${O}(E + V)$ 的开销。
 * 空间复杂度：${O}(E + V)$。
    构建邻接列表将会使用 O(E) 的空间。要跟踪已经访问过的顶点，我们需要一个大小为 O(V) 的数组。此外，DFS 的运行时栈会使用 O(V) 的空间。

---

 #### 方法 2：不相交集合并查集 (DSU)



 假设我们有一个包含 `N` 个顶点和 `0` 条边的图。那么这个图中连通分量的数量就是 `N`。

 ![image.png](https://pic.leetcode.cn/1692176838-hiTbxC-image.png){:width=400}

 现在，让我们添加一个从顶点 1 到顶点 2 的边。这将把连通分量的数量减少 1。这是因为顶点 1 和顶点 2 现在在同一个组件中。

 ![image.png](https://pic.leetcode.cn/1692176840-KDEwYl-image.png){:width=400}

 然后，当我们添加一个从顶点 2 到顶点 3 的边时，连通分量的数量会再次减少 1。

 ![image.png](https://pic.leetcode.cn/1692176843-JoAZOK-image.png){:width=400}

 然而，当我们添加一个从顶点 1 到顶点 3 的边时，这种模式就不会继续了。连通分量的数量不会改变，因为顶点 1，2 和 3 已经在同一个组件中了。

 ![image.png](https://pic.leetcode.cn/1692176845-CeadBJ-image.png){:width=400}

 以上的观察是 DSU 方法背后的主要思路。

 **算法**



 1. 用输入中的顶点数量初始化一个变量 `count`。
 2. 一个一个的遍历所有的边，对每条边执行并查集的 `combine` 方法。如果端点已经在同一个集合中，那么继续遍历。如果不是，那么将 `count` 减 1。
 3. 遍历所有的 `边` 后，变量 `count` 将包含图中的组件数量。

 ```C++ [slu2]
 class Solution {
public:
    int find(vector<int> &representative, int vertex) {
        if (vertex == representative[vertex]) {
            return vertex;
        }
        
        return representative[vertex] = find(representative, representative[vertex]);
    }
    
    int combine(vector<int> &representative, vector<int> &size, int vertex1, int vertex2) {
        vertex1 = find(representative, vertex1);
        vertex2 = find(representative, vertex2);
        
        if (vertex1 == vertex2) {
            return 0;
        } else {
            
            if (size[vertex1] > size[vertex2]) {
                size[vertex1] += size[vertex2];
                representative[vertex2] = vertex1;
            } else {
                size[vertex2] += size[vertex1];
                representative[vertex1] = vertex2;
            }
            return 1;
        }
    }

    int countComponents(int n, vector<vector<int>>& edges) {
        vector<int> representative(n), size(n);
        
        for (int i = 0; i < n; i++) {
            representative[i] = i;
            size[i] = 1;
        }
        
        int components = n;
        for (int i = 0; i < edges.size(); i++) {
            components -= combine(representative, size, edges[i][0], edges[i][1]);
        }

        return components;
    }
};
 ```

 ```Java [slu2]
 public class Solution {

    private int find(int[] representative, int vertex) {
        if (vertex == representative[vertex]) {
            return vertex;
        }
        
        return representative[vertex] = find(representative, representative[vertex]);
    }
    
    private int combine(int[] representative, int[] size, int vertex1, int vertex2) {
        vertex1 = find(representative, vertex1);
        vertex2 = find(representative, vertex2);
        
        if (vertex1 == vertex2) {
            return 0;
        } else {
            if (size[vertex1] > size[vertex2]) {
                size[vertex1] += size[vertex2];
                representative[vertex2] = vertex1;
            } else {
                size[vertex2] += size[vertex1];
                representative[vertex1] = vertex2;
            }
            return 1;
        }
    }

    public int countComponents(int n, int[][] edges) {
        int[] representative = new int[n];
        int[] size = new int[n];
        
        for (int i = 0; i < n; i++) {
            representative[i] = i;
            size[i] = 1;
        }
        
        int components = n;
        for (int i = 0; i < edges.length; i++) { 
            components -= combine(representative, size, edges[i][0], edges[i][1]);
        }

        return components;
    }
}
 ```

 **复杂度分析**



 设 E 为边的数量，V 为顶点的数量。

 * 时间复杂度：$O(V + E\cdotα(n))$。
    遍历每一条边需要 O(E) 的操作，并且对于每一个操作，我们都在执行 ‘combine’ 方法，其时间复杂度为 O(α(n))，其中 α(n) 为反 Ackermann 函数。我们还需要 O(V) 的时间来初始化 DSU 数组。
 * 空间复杂度：$O(V)$。
    存储每个顶点的代表或直接父节点需要 O(V) 的空间。此外，存储组件的大小也需要 O(V) 的空间。

---
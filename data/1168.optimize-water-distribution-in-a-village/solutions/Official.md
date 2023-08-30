[TOC]

## 解决方案

---

### 预备知识

[**最小生成树**](https://baike.baidu.com/item/最小生成树)
图的生成树是一棵含有其所有的顶点的无环联通子图，一幅加权图的**最小生成树（ MST ）** 是它的一颗权值（树中所有边的权值之和）最小的生成树。

[**并查集**](https://baike.baidu.com/item/并查集)
并查集是一种树型的数据结构，用于处理一些不相交集合的合并及查询问题。在使用中常常以森林来表示。并查集支持两种操作：

- `Find`：确定元素属于哪一个子集。它可以被用来确定两个元素是否属于同一子集。
- `Union`：将两个子集合并成同一个集合。

### 概述

 由于问题描述涉及到连接房子（顶点）使用管道（边），我们可以确定这个问题与图论问题有关。本题要求**为所有房子都供水的最低总成本**，我们把房子看成是图的节点，管道看成是图的边，那么这题很显然就是最小生成树的问题。唯一的区别是可以直接在房子内造水井。

 关于 MST 问题，存在几种经典的算法。 特别地，我们将展示其中的两种，即 Prim 的算法和 Kruskal 的算法，这两种算法可以说是最受欢迎的，并且在面试中可行。

 **简单介绍**
 首先，让我们介绍最小生成树的问题。

 >给定一个 _连通_、 _边加权_ 的 _无向_ 图，最小生成树是一组 **_子集_** 的边，它连接所有的顶点，同时这些边的总权重在所有可能的子集中是最小的。

 我们可以从上述定义和我们这里的问题中找到一些相似性。 具体来说，我们可以将每个房子视为图中的一个顶点，而房子之间的管道视为图中的边。
 然而，它们之间有一个主要的 **差异**。 在我们的问题中，每个顶点和每个边都有一个成本。 而在 MST 的设置中，只有边与成本相关联。

 >为了弥合这个 **_差距_**，就如提示所建议的，技巧是在现有图中添加 **一个虚拟顶点**。随着顶点的增加，我们还在虚拟顶点和其余顶点之间添加了边。 最后，我们将每个顶点的成本重新分配给对应的新增边。

 下面是一个示意图，显示了我们如何使用上述技巧转换示例中的图。

 ![image.png](https://pic.leetcode.cn/1691727476-wojEQW-image.png){:width=400}

 有了转换后的图，我们就可以通过额外的边将顶点的成本考虑在内。 我们可以完全关注在选择适当的边以创建一个 MST。 因此，我们的问题简化为从一列加权边创建一个 MST。

 ![image.png](https://pic.leetcode.cn/1691727480-TjAsjI-image.png){:width=400}

 在上图中，我们展示了我们在解决 MST 问题后会找到的解决方案，我们可以将其解释为 _""""为了最小化成本，我们应该在索引为 `1` 的房子中挖一个井（由索引 `1` 和 `0` 之间的边表示），然后向其余的房子供水。""""_

---

 #### 方法 1：堆实现的 Prim 算法

 **概述**

 Prim的 (也被称为 Jarník) 算法是一种 **_贪心_** 算法，用于在 _加权_ 和 _无向_ 图中找到最小生成树。

 >该算法通过一次构建一个顶点，从一个任意的起始顶点开始，每一步都添加树中到不在树中的顶点的 **_最便宜_** 可能连接方式。

 ![PrimAlgDemo.gif](https://pic.leetcode.cn/1691720735-gOCzXd-PrimAlgDemo.gif){:width=400}

 上面的图描绘了 Prim 算法的工作方式。 从一个任意顶点开始，Prim 算法通过每次添加一个顶点到树中 **_增长_** 最小生成树。 顶点的选择基于 **_贪婪_** 策略，_即_ 添加新的顶点会产生最小的成本。
 **算法**
 要实现 Prim 算法，我们主要需要以下三种数据结构：

- **邻接表**：我们需要此结构来表示图，_即_ 顶点和边。邻接表可以是列表列表或者列表字典。
- **集合**：我们需要一个集合来维护已经添加到最终最小生成树中的所有顶点，在构建树的过程中。 通过集合的帮助，我们可以确定一个顶点是否已经被添加。
- **堆**：由于贪婪策略的性质，在每一步，我们可以基于它将添加到树中的成本来确定最佳的要添加的边。堆(也被称为优先队列)是一种数据结构，它允许我们在常数时间内检索最小的元素，并在对数时间内删除最小的元素。这完全符合我们反复找到最低成本边的需求。

**代码实现**
 通过应用上述三种数据结构，可以使用以下步骤来实现 Prim 的算法。

- 首先，根据给定的输入，我们需要使用邻接表构建一个图表示。  
  - 注意，由于图是无向的(_i.e._ 双向的)，对于每个管道，我们需要在邻接表中添加两个条目，每个管道的一端都作为开始顶点。  
  - 此外，为了将我们的问题转换为 MST 问题，我们需要添加一个虚拟顶点（我们将其索引为 `0`），并在每个房屋中添加额外的 `n` 条边。
- 到这里已结束背景介绍，现在要开始的是：从虚拟顶点开始，我们通过添加一个顶点来 **_迭代_** 构建 MST 。  
  - 注意，当使用 Prim 算法时，我们可以使用任何顶点作为起始点。这里，为了方便，我们从新添加的虚拟顶点开始。
- 建立 MST 的过程包括以下子步骤的循环：
- 每次迭代，我们从堆中弹出一个元素。此元素包含一个顶点，以及与将顶点连接到树的边相关联的成本。如果顶点尚未在树中，那么就选择此顶点。我们知道这个顶点的成本在所有选择中是最小的，因为它是从堆中弹出的。
- 一旦添加了顶点，我们那么就检查其邻接的顶点。特别地，我们将这些顶点及其边添加到堆中作为下一轮选择的候选。
- 当我们将图中的所有顶点添加进MST后，循环**终止**。

 ```Java [slu1]
 class Solution {
    public int minCostToSupplyWater(int n, int[] wells, int[][] pipes) {
        // 最小堆，以维护要访问的边的顺序。
        PriorityQueue<Pair<Integer, Integer>> edgesHeap =
                new PriorityQueue<>(n, (a, b) -> (a.getKey() - b.getKey()));

        // 图在邻接表中的表示
        List<List<Pair<Integer, Integer>>> graph = new ArrayList<>(n + 1);
        for (int i = 0; i < n + 1; ++i) {
            graph.add(new ArrayList<Pair<Integer, Integer>>());
        }

        // 添加索引为0的虚拟顶点，
        // 然后在每一栋房子上加一条边，按成本加权
        for (int i = 0; i < wells.length; ++i) {
            Pair<Integer, Integer> virtualEdge = new Pair<>(wells[i], i + 1);
            graph.get(0).add(virtualEdge);
            // 使用来自虚拟顶点的边初始化堆。
            edgesHeap.add(virtualEdge);
        }

        // 将双向边添加到图中
        for (int i = 0; i < pipes.length; ++i) {
            int house1 = pipes[i][0];
            int house2 = pipes[i][1];
            int cost = pipes[i][2];
            graph.get(house1).add(new Pair<Integer, Integer>(cost, house2));
            graph.get(house2).add(new Pair<Integer, Integer>(cost, house1));
        }

        // 从虚拟顶点0开始探索
        Set<Integer> mstSet = new HashSet<>();
        mstSet.add(0);

        int totalCost = 0;
        while (mstSet.size() < n + 1) {
            Pair<Integer, Integer> edge = edgesHeap.poll();
            int cost = edge.getKey();
            int nextHouse = edge.getValue();
            if (mstSet.contains(nextHouse)) {
                continue;
            }

            // 将新顶点添加到集合中
            mstSet.add(nextHouse);
            totalCost += cost;

            // 扩大下一轮优势候选人的选择范围
            for (Pair<Integer, Integer> neighborEdge : graph.get(nextHouse)) {
                if (!mstSet.contains(neighborEdge.getValue())) {
                    edgesHeap.add(neighborEdge);
                }
            }
        }

        return totalCost;
    }
}
 ```

 ```Python3 [slu1]
 class Solution:
    def minCostToSupplyWater(self, n: int, wells: List[int], pipes: List[List[int]]) -> int:

        # 邻接表表示的双向图
        graph = defaultdict(list)

        # 添加索引为0的虚拟顶点。
        # 然后在每一栋房子上加一条边，按成本加权
        for index, cost in enumerate(wells):
            graph[0].append((cost, index + 1))

        # 将双向边添加到图中
        for house_1, house_2, cost in pipes:
            graph[house_1].append((cost, house_2))
            graph[house_2].append((cost, house_1))

        # 用于维护已添加到的所有顶点的集合
        # 最终的 MST(最小生成树)从顶点 0 开始。
        mst_set = set([0])

        # 堆维护要访问的边的顺序，
        # 从起源于顶点0的边开始。
        # 注意：我们能够从任意节点开始。
        heapq.heapify(graph[0])
        edges_heap = graph[0]

        total_cost = 0
        while len(mst_set) < n + 1:
            cost, next_house = heapq.heappop(edges_heap)
            if next_house not in mst_set:
                # 将新顶点添加到集合中
                mst_set.add(next_house)
                total_cost += cost
                # 在下一轮扩大候选边的选择范围
                for new_cost, neighbor_house in graph[next_house]:
                    if neighbor_house not in mst_set:
                        heapq.heappush(edges_heap, (new_cost, neighbor_house))

        return total_cost
 ```

 **复杂度分析**
 设 $N$ 为房子的数目，$M$ 为输入的管道的数目。

- 时间复杂度: $O\big( (N+M) \cdot \log(N+M) \big)$
  - 构建图，我们迭代了输入的房屋和管道，这需要 $O(N + M)$ 的时间。
  - 当构建 MST 时，在最坏的情况下，我们可能需要迭代图中的所有边，总数为 $N + M$ 。  对于每个边，它最多进入和退出堆数据结构一次。把边放入堆中(_i.e._ `push` 操作)需要 $\log(N+M)$ 的时间，而退出边(_i.e._ `pop` 操作)需要一个常数时间。  因此，MST 构建过程的时间复杂度是 $O\big( (N+M) \cdot \log(N+M) \big)$。
  - 总的来说，算法的总体时间复杂度是 $O\big( (N+M) \cdot \log(N+M) \big)$。

- 空间复杂度: $O(N+M)$
  - 我们按照需要在算法中使用的三个主要数据结构来分解分析。
  - 我们构建的图包括 $N+1$ 个顶点和 $2 \cdot M$ 条边（_i.e._管道是双向的）。  因此，图的空间复杂度是 $O(N + 1 + 2 \cdot M) = O(N + M)$。
  - 用于保存 MST 中顶点的集合的空间复杂度为 $O(N)$。
  - 最后，在最坏的情况下，我们的堆可能会持有图中的所有边，即 $(N+M)$。
  - 总的来说，算法的总体空间复杂度是 $O(N+M)$。

---

 #### 方法 2：并查集实现的 Kruskal 算法

 **概述**

 另一个解决 MST 问题的典型算法被称为 Kruskal 算法。

 >与 Prim 的算法类似，Kruskal 的算法应用了 **_贪婪_** 策略，以 **_递增_** 方式将新边添加到最终解决方案中。

 ![KruskalDemo.gif](https://pic.leetcode.cn/1691720735-tQrtiJ-KruskalDemo.gif){:width=400}

 上述动画展示了 Kruskal 的算法如何 **_扩展_** 最小生成树。

 >他们之间的一个主要区别是， 在 Prim 的算法中， MST(最小生成树) 在整个过程中始终保持 **_连接_**，而在 Kruskal 的算法中，树是通过 _合并_ **_不相交的部分_** 来形成的。

 **算法**
 相较于在 Prim 算法中添加顶点，Kruskal 算法更注重添加边。 此外，在 Kruskal 的算法中，我们一次考虑 **_所有的边_**，并根据他们的成本进行排序，而在 Prim 算法中，虽然边在堆或优先队列中是根据成本排序的，但在每次迭代中，我们只探索 **_与已在 MST 中的顶点相连的边_**。

 >Kruskal 算法的总体思路是，我们 **_迭代_** 所有 _有序_ 的边。对于每条边，我们决定是否将它加入最终的 MST。决定的依据是这个新添加是否有助于 **_连接_** 更多的点（_即_ 顶点）。

 ![image.png](https://pic.leetcode.cn/1691727760-klqkYH-image.png){:width=400}

 _添加还是不添加？_

 上面的图显示了三个示例场景，对于每个场景，它都指定了是否应添加一条新边。实线边已经被添加到 MST 中，而虚线边尚未决定。

- 在左边的例子中，我们应该添加新的边，因为边 **_桥接_** 了两个不相交的组件之间的空白。
- 在中间的例子中，我们还应该添加新的边，因为它 **_连接_** 到一个看不见的顶点（_即_连接更多的点）。
- 在右边的例子中，我们 **不能** 添加新边。因为它并不帮助我们使当前的 MST 更 **_具有连通性_**，因为所有的顶点已经连通了。

 >在 Kruskal 的算法中，确定我们是否应该添加一条新边的更简洁的 **_标准_** 是该边的两端是否属于同一组。

 1. 将直接在房子内建造水井变成房子到水库的边加入到图中。
 2. 将所有的边按照权重从小到大排序。
 3. 取一条权重最小的边。
 4. 使用并查集（union-find）数据结构来判断加入这条边后是否会形成 环。若不会构成环，则将这条边加入最小生成树中。
 5. 检查所有的结点是否已经全部联通，这一点可以通过目前已经加入的边的数量来判断。若全部联通，则结束算法；否则返回步骤 3。

 **代码实现**

 为了确定一组元素的归属关系，我们通常会应用称为不相交集合的数据结构，也称为 **并查集** 数据结构。
 基本上，并查集数据结构提供了两个接口：

- `find(a)`：该函数返回元素`a`所属组的id。
- `union(a, b)`：该函数将元素 `a` 和 `b` 所属的两个组合并。如果他们已经属于同一组，那么函数不做任何事情。

 我们使用 kruskal 算法，按照边的权重顺序（从小到大）处理所有的边，将边加入到最小生成树中，使用并查集保证加入的边不会与已经加入的边构成环，直到树中含有 `N - 1` 条边为止。

另外，为了优化时间复杂度，我们实现并查集时使用了[路径压缩](https://oi-wiki.org/ds/dsu/#_3)技术，简单地说，就是在查询操作时，将在路径上的每个节点都直接连接到根上，这样就可以节省下次查询的所需的时间。

 如果你想了解更多关于并查集数据结构的工作方式，你可以参考 [323. 无向图中连通分量的数目](https://leetcode.cn/problems/number-of-connected-components-in-an-undirected-graph/) 问题的解决方案，以及普林斯顿大学的 [教程](https://www.cs.princeton.edu/~wayne/kleinberg-tardos/pdf/UnionFind.pdf)。
 有了并查集数据结构，我们可以用以下两个步骤来实现 Kruskal 的算法：

- 首先，我们对所有的边进行排序，包括与虚拟顶点添加的边。
- 然后，我们 **迭代** _排序后_ 的边。对于每条边，如果边的两端属于不同的组，我们就使用并查集数据结构，将此边添加到最终的 MST。

 ```C++ [slu2]
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

 ```Java [slu2]
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

 **注意：**
 在上述实现中，我们 **微调** 了 `union(a, b)` 以使代码更有效和简洁。
 在大多数并查集数据结构的实现中，我们不会为 `union(a, b)` 函数返回任何东西。然而，在我们的案例中，我们返回一个标志，表示在函数中是否真正发生了联合。有了这个微调，我们只需要在迭代中调用 `union(a,b)` 函数，而不是另外调用 `find(a) == find(b)` 函数。

 **复杂度分析**
 由于我们在算法中应用了并查集数据结构，让我们先对数据结构的时间复杂度做一个说明：

 >如果将 $K$ 次操作，无论是 Union 还是 Find，应用于 $L$ 个元素，那么总的运行时间是 $O(K⋅log * L)$，其中 $log∗$ 是迭代对数。

 可以参考并查集复杂度的证明和来自普林斯顿大学的 [教程](https://www.cs.princeton.edu/~wayne/kleinberg-tardos/pdf/UnionFind.pdf) 获取更多的细节。

 设 $N$ 是房子的数量，$M$ 是管道的数量。

- 时间复杂度: $O\big((N+M) \cdot \log(N+M) \big)$
  - 首先，我们构建一个边的列表，这需要 $O(N + M)$ 的时间。
  - 然后我们对边的列表进行排序，这需要 $O\big((N+M) \cdot \log(N+M) \big)$ 的时间。
  - 最后我们对排序后的边进行迭代。对于每次迭代，我们调用了一次并查集操作。因此，迭代的时间复杂度为 $O\big( (N+M) *\log^{*}(N) \big)$。
  - 总的来说，算法的总体时间复杂度为 $O\big((N+M) \cdot \log(N+M) \big)$，排序步骤占主导地位。

- 空间复杂度: $O(N+M)$
  - 我们的 并查集 数据结构的空间复杂度为 $O(N)$。
  - 边列表所需的空间为 $O(N+M)$。
  - 最后,排序算法的空间复杂度取决于每个编程语言的实现。例如，Python 中的 `list.sort()` 函数使用了 Timsort 算法，其空间复杂度为 $\mathcal{O}(n)$，其中 $n$ 是元素的数量。而在 Java 中，[Collections.sort()](https://docs.oracle.com/javase/7/docs/api/java/util/Collections.html#sort(java.util.List)) 实现了一个快速排序的变型，其空间复杂度为 $\mathcal{O}(\log{n})$。
  - 总的来说，算法的总体空间复杂度为 $O(N+M)$，边列表占主导地位。
[TOC]

## 解决方案

---

#### 综述

在这个问题中，我们需要以最快的速度学完所有课程。我们在一个学期内可以学习的课程数量是无限的，唯一的限制是先修课程关系：我们只能学习那些已经满足先修课程要求的课程。

这个问题是拓扑排序的一个应用，主要有两种不同的解决方案：广度优先搜索（Breadth-First Search，简称 BFS）和深度优先搜索（Depth-First Search，简称 DFS）。

在这篇文章中，我们将介绍三种方法：

 1. _广度优先搜索（Kahn's 算法）_

 2. _深度优先搜索：检查循环 + 寻找最长路径_

 3. _深度优先搜索：结合前两种_

总的来说，我们推荐 _方法 1_ 和 _方法 3_，因为它们都是高效且易于实现的。我们包括 _方法 2_ 是为了更好地理解 _方法 3_。（因此，建议在阅读 _方法 3_ 之前先阅读 _方法 2_。）

完成这个问题后，你可以尝试挑战后续问题 [1494. 并行课程 II](https://leetcode.com/problems/parallel-courses-ii/)。

<br/>

---

#### 方法 1: 广度优先搜索（Kahn's 算法）

**概述**

我们可以将问题看作有向**图**问题（课程是节点，先修课程关系是边）。我们需要做的就是以某种方式遍历图中的所有节点。

对于遍历，我们可以采用 BFS 或 DFS。我们在这个方法中介绍 BFS，在接下来的方法中介绍 DFS。

为了达到最快的学习速度，我们的策略是：

> 在每个学期学习**所有**可供学习的课程。

这很直观。即使我们刻意选择不学习一个可用的课程，我们在以后的学期中仍然需要学习它。现在学习没有任何害处。另外，如果我们晚点再学习，那么我们就必须推迟所有以该课程为先修课程的课程。

现在，第一个问题是：

> 从哪里开始？（哪些课程是可供学习的？）

我们不能从有先修课程的课程开始学习。

> 我们从**没有先修课程**的节点开始。

例如，在这个图中，第一个学期我们可以学习哪些课程？

![image.png](https://pic.leetcode.cn/1691740760-nYQMFe-image.png){:width=400}

是的，标记为黄色的那些课程可以在第一个学期被学习。

![image.png](https://pic.leetcode.cn/1691740763-hRqERN-image.png){:width=400}

现在，我们已经学过这些课程，接下来我们应该学什么呢？

![image.png](https://pic.leetcode.cn/1691741554-gyWfEd-image.png){:width=400}

是的，新的黄色课程可以被学习，因为它们的先修课程已经被满足：

![image.png](https://pic.leetcode.cn/1691741566-NFSVMS-image.png){:width=400}

一直进行下去，直到没有可学的课程为止。

通过使用这种策略来分配课程到学期，我们可以保证最小化所需要的学期数量。这是因为在每个学期中，我们都在学习每一个不被先修课程"锁定"的课程，所以没有可能更快的方法。

让我们用广度优先搜索来完成这个例子：

<![image.png](https://pic.leetcode.cn/1691741606-sfuqYe-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691741611-zzKBHo-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691741613-GEnslP-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691741616-MrXoaF-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691741618-nAKSqS-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691741621-CExtXU-image.png){:width=400}>

在一些其他情况下，我们不能学完所有节点。如果我们已经访问过的节点数量严格小于总节点数量，那么我们就无法学完所有课程，只能返回 `-1`。

例如，在这个包含循环的图中，我们不能学完所有课程：

<![image.png](https://pic.leetcode.cn/1691741917-xpiFzB-image.png){:width=400},![image.png](https://pic.leetcode.cn/1691741920-OXeRry-image.png){:width=400}>

> 这种方法也被称为 Kahn's 算法（作了一些修改以适应这个问题）。

**算法步骤**

_步骤 1:_ 从 `relations` 构建一个有向图。

_步骤 2:_ 记录每个节点的入度。（即，朝向节点的边的数量）

_步骤 3:_ 初始化一个队列，`queue`。把入度为 `0` 的节点放入 `queue`。初始化 `step = 0`， `visited_count = 0`。

_步骤 4:_ 开始 BFS：循环直到 `queue` 为空：

 1. 初始化一个队列 `next_queue` 来记录下一次迭代需要的节点。 
 2. `step` +1。 
 3. 对 `queue` 中的每个 `node`：
    1. `visitedCount` +1
    2. 对从 `node` 可到达的每个 `end_node`：
       1. 减小 `end_node` 的入度
       2. 如果 `end_node` 的入度减小到0，将其加入 `next_queue` 
 4. 将 `queue` 赋值为 `next_queue`

 _步骤 5:_ 如果 `visited_count == N`，返回 `step`。否则，返回 `-1`。

 **代码实现**

 ```C++ [slu1]
 class Solution {
 public:
    int minimumSemesters(int N, vector<vector<int>>& relations) {
        vector<int> inCount(N + 1, 0);  // 或者入度
        vector<vector<int>> graph(N + 1);
        for (auto& relation : relations) {
            graph[relation[0]].push_back(relation[1]);
            inCount[relation[1]]++;
        }
        int step = 0;
        int studiedCount = 0;
        vector<int> bfsQueue;
        for (int node = 1; node < N + 1; node++) {
            if (inCount[node] == 0) {
                bfsQueue.push_back(node);
            }
        }
        // 开始使用 BFS 学习
        while (!bfsQueue.empty()) {
            // 开始一个新学期
            step++;
            vector<int> nextQueue;
            for (auto& node : bfsQueue) {
                studiedCount++;
                for (auto& endNode : graph[node]) {
                    inCount[endNode]--;
                    // 如果所有先修课程都已经学习
                    if (inCount[endNode] == 0) {
                        nextQueue.push_back(endNode);
                    }
                }
            }
            bfsQueue = nextQueue;
        }

        // 检查是否学习所有课程
        return studiedCount == N ? step : -1;
    }
};
 ```

 ```Java [slu1]
 class Solution {
    public int minimumSemesters(int N, int[][] relations) {
        int[] inCount = new int[N + 1]; // 或者入度
        List<List<Integer>> graph = new ArrayList<>(N + 1);
        for (int i = 0; i < N + 1; ++i) {
            graph.add(new ArrayList<Integer>());
        }
        for (int[] relation : relations) {
            graph.get(relation[0]).add(relation[1]);
            inCount[relation[1]]++;
        }
        int step = 0;
        int studiedCount = 0;
        List<Integer> bfsQueue = new ArrayList<>();
        for (int node = 1; node < N + 1; node++) {
            if (inCount[node] == 0) {
                bfsQueue.add(node);
            }
        }
        // 开始使用 BFS 学习
        while (!bfsQueue.isEmpty()) {
            // 开始一个新学期
            step++;
            List<Integer> nextQueue = new ArrayList<>();
            for (int node : bfsQueue) {
                studiedCount++;
                for (int endNode : graph.get(node)) {
                    inCount[endNode]--;
                    // 如果所有先修课程都已经学习
                    if (inCount[endNode] == 0) {
                        nextQueue.add(endNode);
                    }
                }
            }
            bfsQueue = nextQueue;
        }

        // 检查是否学习所有课程
        return studiedCount == N ? step : -1;
    }
}
 ```

```Python3 [slu1]
class Solution:
    def minimumSemesters(self, N: int, relations: List[List[int]]) -> int:
        graph = {i: [] for i in range(1, N + 1)}
        in_count = {i: 0 for i in range(1, N + 1)}  # 或者入度
        for start_node, end_node in relations:
            graph[start_node].append(end_node)
            in_count[end_node] += 1

        queue = []
        # 我们使用 list 因为我们
        # 在这份代码中不会弹出前面的元素
        for node in graph:
            if in_count[node] == 0:
                queue.append(node)

        step = 0
        studied_count = 0
        # 开始使用BFS学习
        while queue:
            # 开始一个新学期
            step += 1
            next_queue = []
            for node in queue:
                studied_count += 1
                end_nodes = graph[node]
                for end_node in end_nodes:
                    in_count[end_node] -= 1
                    # 如果所有先修课程都已经学习
                    if in_count[end_node] == 0:
                        next_queue.append(end_node)
            queue = next_queue

        return step if studied_count == N else -1
```

**复杂度分析**

设 $E$ 为 `relations` 的长度。$N$ 是课程的数量，如问题描述中所述。

- 时间复杂度：$\mathcal{O}(N+E)$. 对于构建图，我们花费 $\mathcal{O}(N)$ 来初始化图，并花费 $\mathcal{O}(E)$ 来添加边，因为我们要遍历一次 `relations`。对于 BFS，我们花费 $\mathcal{O}(N+E)$，因为在最坏的情况下，我们需要在 BFS 中访问每个节点和边一次。

- 空间复杂度：$\mathcal{O}(N+E)$. 对于图，我们花费 $\mathcal{O}(N+E)$，因为我们有 $\mathcal{O}(N)$ 个键和 $\mathcal{O}(E)$ 个值。对于 BFS，我们花费 $\mathcal{O}(N)$，因为在最坏的情况下，我们需要在同一时间添加所有节点到队列中。

<br/>

---
#### 方法 2: 深度优先搜索：检查循环 + 寻找最长路径

**概述**

有一个重要的见解：

> 所需的学期数量等于图中**最长路径**的长度。

例如，下图中的最长路径长度为 `5`，所以需要的学期数量是 `5`：

![image.png](https://pic.leetcode.cn/1691742259-dycvHD-image.png){:width=500}

为什么？将路径视为一系列的先修关系，对于每一个先修关系，我们都需要花费一个学期才能进到下一个节点。

但是有一个问题：如果图中有循环，那么最长路径就会变成无限长。

![image.png](https://pic.leetcode.cn/1691742261-cCxExg-image.png){:width=500}

所以首先，我们需要检查图是否有循环。如果有的话，我们可以直接返回 `-1`，因为我们永远无法完成所有的课程。

现在我们将问题分成两部分：

 1. 检查图是否有循环
 2. 计算图中最长路径的长度

 这两部分都可以使用 DFS 来完成。在 _方法 3_ 中，我们将展示如何在一个单独的 DFS 中同时完成这两部分。然而，在这个方法中，为了更好的理解，我们将这两部分拆分成两个单独的 DFS 遍历。

_检查图是否有循环_

每个节点有三种状态：未访问、正在访问和已访问。

在执行 DFS 之前，我们需要把图中所有的节点都初始化为未访问状态。

在执行 DFS 不断深入时，我们将当前节点标记为正在访问，直到我们检查完从当前节点出发的所有路径。如果我们遇到一个正在访问的节点，那么它必然来自上游路径，所以我们发现了一个循环。

如果 DFS 结束了，并且所有的节点都被标记为已访问，那么图中就没有循环。

_计算最长路径的长度_

DFS 函数应该返回它的子节点的递归调用结果中的最大值，再加上它自己（长度为1）。

为了防止重复计算，我们需要存储已经计算过的结果。这是动态规划的一个例子，因为我们储存了子问题的结果。

**算法步骤**

_步骤 1:_ 从 `relations` 构建一个有向图。

_步骤 2:_ 实现一个函数 `dfsCheckCycle` 来检查图是否含有循环。

_步骤 3:_ 实现一个函数 `dfsMaxPath` 来计算图中最长路径的长度。

_步骤 4:_ 调用 `dfsCheckCycle`，如果图中含有循环就返回 `-1`。

_步骤 5:_ 否则，调用 `dfsMaxPath`。返回图中最长路径的长度。

 **实现**

```C++ [slu2]
class Solution {
public:
    int minimumSemesters(int N, vector<vector<int>>& relations) {
        vector<vector<int>> graph(N + 1);
        for (auto& relation : relations) {
            graph[relation[0]].push_back(relation[1]);
        }
        // 检查图中是否有环
        vector<int> visited(N + 1, 0);
        for (int node = 1; node < N + 1; node++) {
            // if has cycle, return -1
            if (dfsCheckCycle(node, graph, visited) == -1) {
                return -1;
            }
        }

        // 如果没有环，返回最长路
        vector<int> visitedLength(N + 1, 0);
        int maxLength = 1;
        for (int node = 1; node < N + 1; node++) {
            int length = dfsMaxPath(node, graph, visitedLength);
            maxLength = max(length, maxLength);
        }
        return maxLength;
    }

private:
    int dfsCheckCycle(int node, vector<vector<int>>& graph,
                      vector<int>& visited) {
        // 如果有环则返回 -1
        // 如果无环则返回 1
        if (visited[node] != 0) {
            return visited[node];
        } else {
            // 标记为正在访问
            visited[node] = -1;
        }
        for (auto& endNode : graph[node]) {
            if (dfsCheckCycle(endNode, graph, visited) == -1) {
                // 我们遇到了一个环！
                return -1;
            }
        }
        // 标记为已经访问过
        visited[node] = 1;
        return 1;
    }

    int dfsMaxPath(int node, vector<vector<int>>& graph,
                   vector<int>& visitedLength) {
        // 返回最长路（含）
        if (visitedLength[node] != 0) {
            return visitedLength[node];
        }
        int maxLength = 1;
        for (auto& endNode : graph[node]) {
            int length = dfsMaxPath(endNode, graph, visitedLength);
            maxLength = max(length + 1, maxLength);
        }
        // 储存
        visitedLength[node] = maxLength;
        return maxLength;
    }
};
```

```Java [slu2]
class Solution {
    public int minimumSemesters(int N, int[][] relations) {
        List<List<Integer>> graph = new ArrayList<>(N + 1);
        for (int i = 0; i < N + 1; ++i) {
            graph.add(new ArrayList<Integer>());
        }
        for (int[] relation : relations) {
            graph.get(relation[0]).add(relation[1]);
        }
        // 检查图中是否有环
        int[] visited = new int[N + 1];
        for (int node = 1; node < N + 1; node++) {
            // if has cycle, return -1
            if (dfsCheckCycle(node, graph, visited) == -1) {
                return -1;
            }
        }

        // 如果没有环，返回最长路
        int[] visitedLength = new int[N + 1];
        int maxLength = 1;
        for (int node = 1; node < N + 1; node++) {
            int length = dfsMaxPath(node, graph, visitedLength);
            maxLength = Math.max(length, maxLength);
        }
        return maxLength;
    }

    private int dfsCheckCycle(int node, List<List<Integer>> graph, int[] visited) {
        // 如果有环则返回 -1
        // 如果无环则返回 1
        if (visited[node] != 0) {
            return visited[node];
        } else {
            // 标记为正在访问
            visited[node] = -1;
        }
        for (int endNode : graph.get(node)) {
            if (dfsCheckCycle(endNode, graph, visited) == -1) {
                // 我们遇到了一个环！
                return -1;
            }
        }
        // 标记为已经访问过
        visited[node] = 1;
        return 1;
    }

    private int dfsMaxPath(int node, List<List<Integer>> graph, int[] visitedLength) {
        // 返回最长路（含）
        if (visitedLength[node] != 0) {
            return visitedLength[node];
        }
        int maxLength = 1;
        for (int endNode : graph.get(node)) {
            int length = dfsMaxPath(endNode, graph, visitedLength);
            maxLength = Math.max(length + 1, maxLength);
        }
        // 储存
        visitedLength[node] = maxLength;
        return maxLength;
    }
}
```

```Python3 [slu2]
class Solution:
    def minimumSemesters(self, N: int, relations: List[List[int]]) -> int:
        graph = {i: [] for i in range(1, N + 1)}
        for start_node, end_node in relations:
            graph[start_node].append(end_node)

        # 检查图中是否有环
        visited = {}

        def dfs_check_cycle(node: int) -> bool:
            # return True if graph has a cycle
            if node in visited:
                return visited[node]
            else:
                # 标记为正在访问
                visited[node] = -1
            for end_node in graph[node]:
                if dfs_check_cycle(end_node):
                    # 我们遇到了一个环！
                    return True
            # 标记为已经访问过
            visited[node] = False
            return False

        # if has cycle, return -1
        for node in graph.keys():
            if dfs_check_cycle(node):
                return -1

        # 如果没有环，返回最长路
        visited_length = {}

        def dfs_max_path(node: int) -> int:
            # 返回最长路（含）
            if node in visited_length:
                return visited_length[node]
            max_length = 1
            for end_node in graph[node]:
                length = dfs_max_path(end_node)
                max_length = max(length+1, max_length)
            # 储存
            visited_length[node] = max_length
            return max_length

        return max(dfs_max_path(node)for node in graph.keys())
```

**复杂度分析**

设 $E$ 为 `relations` 的长度。

- 时间复杂度：$\mathcal{O}(N+E)$. 对于构建图，我们花费 $\mathcal{O}(N)$ 来初始化图，并花费 $\mathcal{O}(E)$ 来添加边，因为我们要遍历一次 `relations`。对于 DFS，我们花费 $\mathcal{O}(N+E)$，因为在最坏的情况下，我们需要在 DFS 中访问每个节点和边一次。

- 空间复杂度：$\mathcal{O}(N+E)$. 对于图，我们花费 $\mathcal{O}(N+E)$，因为我们有 $\mathcal{O}(N)$ 个键和 $\mathcal{O}(E)$ 个值。对于 DFS，我们花费 $\mathcal{O}(N)$，因为在最坏的情况下，我们需要在栈中添加所有节点以递归调用 DFS。另外，我们运行了两次 DFS。

<br/>

---

#### 方法 3: 深度优先搜索：合并

**概述**

> 这个方法是 _方法 2_ 的改进版。建议确保你完全理解了 _方法 2_ 后再继续阅读这个最终方案。

在这里，我们将 _方法 2_ 中的两个函数 `dfsCheckCycle` 和 `dfsMaxPath` 合并成一个单独的函数，`dfs`。

> 新的 `dfs` 在检测到循环时应返回 `-1`，否则返回最长路径的长度。

在 `dfsCheckCycle` 上做一些简单的修改即可：

回忆一下在 `dfsCheckCycle` 中，每个节点有三种状态：未访问、正在访问和已访问。

我们可以把**已访问**状态改为从当前节点开始的**最长长度**，并让 dfs 返回从当前节点开始的最长长度。

伪代码如下：

```
set states of all nodes to unvisited

def dfs(node):
    if the state of node is visiting:
        # detects cycles
        return -1
    else if the state of node is visited:
        return the state of node # the longest length

    set the state of node to visiting

    max_length = 1
    for child_node in child_nodes:
        child_answer = dfs(child_node)
        # if detects cycles in child_node
        if child_answer == -1:
            return -1
        else:
            max_length = max(max_length, child_answer + 1)

    set the state of node to max_length
    return max_length
```

**算法步骤**

_步骤 1:_ 从 `relations` 构建一个有向图。

_步骤 2:_ 实现一个函数 `dfs` 来检查图是否含有循环并计算图中最长路径的长度。

_步骤 3:_ 调用 `dfs`，如果图中含有循环就返回 `-1`。否则，返回图中最长路径的长度。

**实现**

```C++ [slu3]
class Solution {
public:
    int minimumSemesters(int N, vector<vector<int>>& relations) {
        vector<vector<int>> graph(N + 1);
        for (auto& relation : relations) {
            graph[relation[0]].push_back(relation[1]);
        }

        vector<int> visited(N + 1, 0);
        int maxLength = 1;
        for (int node = 1; node < N + 1; node++) {
            int length = dfs(node, graph, visited);
            // 我们遇到了一个环！
            if (length == -1) {
                return -1;
            }
            maxLength = max(length, maxLength);
        }
        return maxLength;
    }

private:
    int dfs(int node, vector<vector<int>>& graph, vector<int>& visited) {
        // 返回最长路（含）
        if (visited[node] != 0) {
            return visited[node];
        } else {
            // 标记为正在访问
            visited[node] = -1;
        }
        int maxLength = 1;
        for (auto& endNode : graph[node]) {
            int length = dfs(endNode, graph, visited);
            // 我们遇到了一个环！
            if (length == -1) {
                return -1;
            }
            maxLength = max(length + 1, maxLength);
        }
        // 标记为已经访问过
        visited[node] = maxLength;
        return maxLength;
    }
};
```

```Java [slu3]
class Solution {
    public int minimumSemesters(int N, int[][] relations) {
        List<List<Integer>> graph = new ArrayList<>(N + 1);
        for (int i = 0; i < N + 1; ++i) {
            graph.add(new ArrayList<Integer>());
        }
        for (int[] relation : relations) {
            graph.get(relation[0]).add(relation[1]);
        }
        int[] visited = new int[N + 1];

        int maxLength = 1;
        for (int node = 1; node < N + 1; node++) {
            int length = dfs(node, graph, visited);
            // 我们遇到了一个环！
            if (length == -1) {
                return -1;
            }
            maxLength = Math.max(length, maxLength);
        }
        return maxLength;
    }

    private int dfs(int node, List<List<Integer>> graph, int[] visited) {
        // 返回最长路（含）
        if (visited[node] != 0) {
            return visited[node];
        } else {
            // 标记为正在访问
            visited[node] = -1;
        }
        int maxLength = 1;
        for (int endNode : graph.get(node)) {
            int length = dfs(endNode, graph, visited);
            // 我们遇到了一个环！
            if (length == -1) {
                return -1;
            }
            maxLength = Math.max(length + 1, maxLength);
        }
        // 标记为已经访问过
        visited[node] = maxLength;
        return maxLength;
    }
}
```

```Python3 [slu3]
class Solution:
    def minimumSemesters(self, N: int, relations: List[List[int]]) -> int:
        graph = {i: [] for i in range(1, N + 1)}
        for start_node, end_node in relations:
            graph[start_node].append(end_node)

        visited = {}

        def dfs(node: int) -> int:
            # 返回最长路（含）
            if node in visited:
                return visited[node]
            else:
                # 标记为正在访问
                visited[node] = -1

            max_length = 1
            for end_node in graph[node]:
                length = dfs(end_node)
                # 我们遇到了一个环！
                if length == -1:
                    return -1
                else:
                    max_length = max(length+1, max_length)
            # 标记为已经访问过
            visited[node] = max_length
            return max_length

        max_length = -1
        for node in graph.keys():
            length = dfs(node)
            # 我们遇到了一个环！
            if length == -1:
                return -1
            else:
                max_length = max(length, max_length)
        return max_length
```

**复杂度分析**

设 $E$ 为 `relations` 的长度。

- 时间复杂度：$\mathcal{O}(N+E)$. 对于构建图，我们花费 $\mathcal{O}(N)$ 来初始化图，并花费 $\mathcal{O}(E)$ 来添加边，因为我们要遍历一次 `relations`。对于 DFS，我们花费 $\mathcal{O}(N+E)$，因为在最坏的情况下，我们需要在 DFS 中访问每个节点和边一次。

- 空间复杂度：$\mathcal{O}(N+E)$. 对于图，我们花费 $\mathcal{O}(N+E)$，因为我们有 $\mathcal{O}(N)$ 个键和 $\mathcal{O}(E)$ 个值。对于 DFS，我们花费 $\mathcal{O}(N)$，因为在最坏的情况下，我们需要在栈中添加所有节点以递归调用 DFS。
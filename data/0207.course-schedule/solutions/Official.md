## [207.课程表 中文官方题解](https://leetcode.cn/problems/course-schedule/solutions/100000/ke-cheng-biao-by-leetcode-solution)

### 📺 视频题解  
![207.课程表 2.mp4](29da2f01-af1a-45a6-bb69-aea71f42900f)

### 📖 文字题解

#### 前言

> 本题和 [210. 课程表 II](https://leetcode-cn.com/problems/course-schedule-ii/) 是几乎一样的题目。如果在过去完成过该题，那么只要将代码中的返回值从「非空数组 / 空数组」修改成「$\text{True}$ / $\text{False}$」就可以通过本题。

本题是一道经典的「拓扑排序」问题。

给定一个包含 $n$ 个节点的有向图 $G$，我们给出它的节点编号的一种排列，如果满足：

> 对于图 $G$ 中的任意一条有向边 $(u, v)$，$u$ 在排列中都出现在 $v$ 的前面。

那么称该排列是图 $G$ 的「拓扑排序」。根据上述的定义，我们可以得出两个结论：

- 如果图 $G$ 中存在环（即图 $G$ 不是「有向无环图」），那么图 $G$ 不存在拓扑排序。这是因为假设图中存在环 $x_1, x_2, \cdots, x_n, x_1$，那么 $x_1$ 在排列中必须出现在 $x_n$ 的前面，但 $x_n$ 同时也必须出现在 $x_1$ 的前面，因此不存在一个满足要求的排列，也就不存在拓扑排序；

- 如果图 $G$ 是有向无环图，那么它的拓扑排序可能不止一种。举一个最极端的例子，如果图 $G$ 值包含 $n$ 个节点却没有任何边，那么任意一种编号的排列都可以作为拓扑排序。

有了上述的简单分析，我们就可以将本题建模成一个求拓扑排序的问题了：

- 我们将每一门课看成一个节点；

- 如果想要学习课程 $A$ 之前必须完成课程 $B$，那么我们从 $B$ 到 $A$ 连接一条有向边。这样以来，在拓扑排序中，$B$ 一定出现在 $A$ 的前面。

求出该图是否存在拓扑排序，就可以判断是否有一种符合要求的课程学习顺序。事实上，**由于求出一种拓扑排序方法的最优时间复杂度为 $O(n+m)$，其中 $n$ 和 $m$ 分别是有向图 $G$ 的节点数和边数，方法见 [210. 课程表 II 的官方题解](https://leetcode-cn.com/problems/course-schedule-ii/solution/ke-cheng-biao-ii-by-leetcode-solution/)。而判断图 $G$ 是否存在拓扑排序，至少也要对其进行一次完整的遍历，时间复杂度也为 $O(n+m)$。因此不可能存在一种仅判断图是否存在拓扑排序的方法，它的时间复杂度在渐进意义上严格优于 $O(n+m)$**。这样一来，我们使用和 [210. 课程表 II](https://leetcode-cn.com/problems/course-schedule-ii/) 完全相同的方法，但无需使用数据结构记录实际的拓扑排序。为了叙述的完整性，下面的两种方法与 [210. 课程表 II 的官方题解](https://leetcode-cn.com/problems/course-schedule-ii/solution/ke-cheng-biao-ii-by-leetcode-solution/) 完全相同，但在「算法」部分后的「优化」部分说明了如何省去对应的数据结构。

#### 方法一：深度优先搜索

**思路**

我们可以将深度优先搜索的流程与拓扑排序的求解联系起来，用一个栈来存储所有**已经搜索完成的节点**。

> 对于一个节点 $u$，如果它的所有相邻节点都已经搜索完成，那么在搜索回溯到 $u$ 的时候，$u$ 本身也会变成一个已经搜索完成的节点。这里的「相邻节点」指的是从 $u$ 出发通过一条有向边可以到达的所有节点。

假设我们当前搜索到了节点 $u$，如果它的所有相邻节点都已经搜索完成，那么这些节点都已经在栈中了，此时我们就可以把 $u$ 入栈。可以发现，如果我们从栈顶往栈底的顺序看，由于 $u$ 处于栈顶的位置，那么 $u$ 出现在所有 $u$ 的相邻节点的前面。因此对于 $u$ 这个节点而言，它是满足拓扑排序的要求的。

这样以来，我们对图进行一遍深度优先搜索。当每个节点进行回溯的时候，我们把该节点放入栈中。最终从栈顶到栈底的序列就是一种拓扑排序。

**算法**

对于图中的任意一个节点，它在搜索的过程中有三种状态，即：

- 「未搜索」：我们还没有搜索到这个节点；

- 「搜索中」：我们搜索过这个节点，但还没有回溯到该节点，即该节点还没有入栈，还有相邻的节点没有搜索完成）；

- 「已完成」：我们搜索过并且回溯过这个节点，即该节点已经入栈，并且所有该节点的相邻节点都出现在栈的更底部的位置，满足拓扑排序的要求。

通过上述的三种状态，我们就可以给出使用深度优先搜索得到拓扑排序的算法流程，在每一轮的搜索搜索开始时，我们任取一个「未搜索」的节点开始进行深度优先搜索。

- 我们将当前搜索的节点 $u$ 标记为「搜索中」，遍历该节点的每一个相邻节点 $v$：

    - 如果 $v$ 为「未搜索」，那么我们开始搜索 $v$，待搜索完成回溯到 $u$；

    - 如果 $v$ 为「搜索中」，那么我们就找到了图中的一个环，因此是不存在拓扑排序的；

    - 如果 $v$ 为「已完成」，那么说明 $v$ 已经在栈中了，而 $u$ 还不在栈中，因此 $u$ 无论何时入栈都不会影响到 $(u, v)$ 之前的拓扑关系，以及不用进行任何操作。

- 当 $u$ 的所有相邻节点都为「已完成」时，我们将 $u$ 放入栈中，并将其标记为「已完成」。

在整个深度优先搜索的过程结束后，如果我们没有找到图中的环，那么栈中存储这所有的 $n$ 个节点，从栈顶到栈底的顺序即为一种拓扑排序。

下面的幻灯片给出了深度优先搜索的可视化流程。图中的「白色」「黄色」「绿色」节点分别表示「未搜索」「搜索中」「已完成」的状态。

<![DFS1](https://assets.leetcode-cn.com/solution-static/207/1.png),![DFS2](https://assets.leetcode-cn.com/solution-static/207/2.png),![DFS3](https://assets.leetcode-cn.com/solution-static/207/3.png),![DFS4](https://assets.leetcode-cn.com/solution-static/207/4.png),![DFS5](https://assets.leetcode-cn.com/solution-static/207/5.png),![DFS6](https://assets.leetcode-cn.com/solution-static/207/6.png),![DFS7](https://assets.leetcode-cn.com/solution-static/207/7.png),![DFS8](https://assets.leetcode-cn.com/solution-static/207/8.png),![DFS9](https://assets.leetcode-cn.com/solution-static/207/9.png),![DFS10](https://assets.leetcode-cn.com/solution-static/207/10.png),![DFS11](https://assets.leetcode-cn.com/solution-static/207/11.png),![DFS12](https://assets.leetcode-cn.com/solution-static/207/12.png),![DFS13](https://assets.leetcode-cn.com/solution-static/207/13.png),![DFS14](https://assets.leetcode-cn.com/solution-static/207/14.png),![DFS15](https://assets.leetcode-cn.com/solution-static/207/15.png),![DFS16](https://assets.leetcode-cn.com/solution-static/207/16.png),![DFS17](https://assets.leetcode-cn.com/solution-static/207/17.png),![DFS18](https://assets.leetcode-cn.com/solution-static/207/18.png),![DFS19](https://assets.leetcode-cn.com/solution-static/207/19.png),![DFS20](https://assets.leetcode-cn.com/solution-static/207/20.png)>

**优化**

由于我们只需要判断是否存在一种拓扑排序，而栈的作用仅仅是存放最终的拓扑排序结果，因此我们可以只记录每个节点的状态，而省去对应的栈。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    vector<vector<int>> edges;
    vector<int> visited;
    bool valid = true;

public:
    void dfs(int u) {
        visited[u] = 1;
        for (int v: edges[u]) {
            if (visited[v] == 0) {
                dfs(v);
                if (!valid) {
                    return;
                }
            }
            else if (visited[v] == 1) {
                valid = false;
                return;
            }
        }
        visited[u] = 2;
    }

    bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
        edges.resize(numCourses);
        visited.resize(numCourses);
        for (const auto& info: prerequisites) {
            edges[info[1]].push_back(info[0]);
        }
        for (int i = 0; i < numCourses && valid; ++i) {
            if (!visited[i]) {
                dfs(i);
            }
        }
        return valid;
    }
};
```

```Java [sol1-Java]
class Solution {
    List<List<Integer>> edges;
    int[] visited;
    boolean valid = true;

    public boolean canFinish(int numCourses, int[][] prerequisites) {
        edges = new ArrayList<List<Integer>>();
        for (int i = 0; i < numCourses; ++i) {
            edges.add(new ArrayList<Integer>());
        }
        visited = new int[numCourses];
        for (int[] info : prerequisites) {
            edges.get(info[1]).add(info[0]);
        }
        for (int i = 0; i < numCourses && valid; ++i) {
            if (visited[i] == 0) {
                dfs(i);
            }
        }
        return valid;
    }

    public void dfs(int u) {
        visited[u] = 1;
        for (int v: edges.get(u)) {
            if (visited[v] == 0) {
                dfs(v);
                if (!valid) {
                    return;
                }
            } else if (visited[v] == 1) {
                valid = false;
                return;
            }
        }
        visited[u] = 2;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        edges = collections.defaultdict(list)
        visited = [0] * numCourses
        result = list()
        valid = True

        for info in prerequisites:
            edges[info[1]].append(info[0])
        
        def dfs(u: int):
            nonlocal valid
            visited[u] = 1
            for v in edges[u]:
                if visited[v] == 0:
                    dfs(v)
                    if not valid:
                        return
                elif visited[v] == 1:
                    valid = False
                    return
            visited[u] = 2
            result.append(u)
        
        for i in range(numCourses):
            if valid and not visited[i]:
                dfs(i)
        
        return valid
```

```C [sol1-C]
int** edges;
int* edgeColSize;
int* visited;
bool valid;

void dfs(int u) {
    visited[u] = 1;
    for (int i = 0; i < edgeColSize[u]; ++i) {
        if (visited[edges[u][i]] == 0) {
            dfs(edges[u][i]);
            if (!valid) {
                return;
            }
        } else if (visited[edges[u][i]] == 1) {
            valid = false;
            return;
        }
    }
    visited[u] = 2;
}

bool canFinish(int numCourses, int** prerequisites, int prerequisitesSize, int* prerequisitesColSize) {
    valid = true;
    edges = (int**)malloc(sizeof(int*) * numCourses);
    for (int i = 0; i < numCourses; i++) {
        edges[i] = (int*)malloc(0);
    }
    edgeColSize = (int*)malloc(sizeof(int) * numCourses);
    memset(edgeColSize, 0, sizeof(int) * numCourses);
    visited = (int*)malloc(sizeof(int) * numCourses);
    memset(visited, 0, sizeof(int) * numCourses);
    for (int i = 0; i < prerequisitesSize; ++i) {
        int a = prerequisites[i][1], b = prerequisites[i][0];
        edgeColSize[a]++;
        edges[a] = (int*)realloc(edges[a], sizeof(int) * edgeColSize[a]);
        edges[a][edgeColSize[a] - 1] = b;
    }
    for (int i = 0; i < numCourses && valid; ++i) {
        if (!visited[i]) {
            dfs(i);
        }
    }
    for (int i = 0; i < numCourses; i++) {
        free(edges[i]);
    }
    free(edges);
    free(edgeColSize);
    free(visited);
    return valid;
}
```

```golang [sol1-Golang]
func canFinish(numCourses int, prerequisites [][]int) bool {
    var (
        edges = make([][]int, numCourses)
        visited = make([]int, numCourses)
        result []int
        valid = true
        dfs func(u int)
    )

    dfs = func(u int) {
        visited[u] = 1
        for _, v := range edges[u] {
            if visited[v] == 0 {
                dfs(v)
                if !valid {
                    return
                }
            } else if visited[v] == 1 {
                valid = false
                return
            }
        }
        visited[u] = 2
        result = append(result, u)
    }

    for _, info := range prerequisites {
        edges[info[1]] = append(edges[info[1]], info[0])
    }

    for i := 0; i < numCourses && valid; i++ {
        if visited[i] == 0 {
            dfs(i)
        }
    }
    return valid
}
```

**复杂度分析**

- 时间复杂度: $O(n+m)$，其中 $n$ 为课程数，$m$ 为先修课程的要求数。这其实就是对图进行深度优先搜索的时间复杂度。

- 空间复杂度: $O(n+m)$。题目中是以列表形式给出的先修课程关系，为了对图进行深度优先搜索，我们需要存储成邻接表的形式，空间复杂度为 $O(n+m)$。在深度优先搜索的过程中，我们需要最多 $O(n)$ 的栈空间（递归）进行深度优先搜索，因此总空间复杂度为 $O(n+m)$。

#### 方法二: 广度优先搜索

**思路**

方法一的深度优先搜索是一种「逆向思维」：最先被放入栈中的节点是在拓扑排序中最后面的节点。我们也可以使用正向思维，顺序地生成拓扑排序，这种方法也更加直观。

我们考虑拓扑排序中最前面的节点，该节点一定不会有任何入边，也就是它没有任何的先修课程要求。当我们将一个节点加入答案中后，我们就可以移除它的所有出边，代表着它的相邻节点**少了一门先修课程的要求**。如果某个相邻节点变成了「没有任何入边的节点」，那么就代表着这门课可以开始学习了。按照这样的流程，我们不断地将没有入边的节点加入答案，直到答案中包含所有的节点（得到了一种拓扑排序）或者不存在没有入边的节点（图中包含环）。

上面的想法类似于广度优先搜索，因此我们可以将广度优先搜索的流程与拓扑排序的求解联系起来。

**算法**

我们使用一个队列来进行广度优先搜索。初始时，所有入度为 $0$ 的节点都被放入队列中，它们就是可以作为拓扑排序最前面的节点，并且它们之间的相对顺序是无关紧要的。

在广度优先搜索的每一步中，我们取出队首的节点 $u$：

- 我们将 $u$ 放入答案中；

- 我们移除 $u$ 的所有出边，也就是将 $u$ 的所有相邻节点的入度减少 $1$。如果某个相邻节点 $v$ 的入度变为 $0$，那么我们就将 $v$ 放入队列中。

在广度优先搜索的过程结束后。如果答案中包含了这 $n$ 个节点，那么我们就找到了一种拓扑排序，否则说明图中存在环，也就不存在拓扑排序了。

下面的幻灯片给出了广度优先搜索的可视化流程。

<![BFS1](https://assets.leetcode-cn.com/solution-static/207/fig1.png),![BFS2](https://assets.leetcode-cn.com/solution-static/207/fig2.png),![BFS3](https://assets.leetcode-cn.com/solution-static/207/fig3.png),![BFS4](https://assets.leetcode-cn.com/solution-static/207/fig4.png),![BFS5](https://assets.leetcode-cn.com/solution-static/207/fig5.png),![BFS6](https://assets.leetcode-cn.com/solution-static/207/fig6.png),![BFS7](https://assets.leetcode-cn.com/solution-static/207/fig7.png),![BFS8](https://assets.leetcode-cn.com/solution-static/207/fig8.png),![BFS9](https://assets.leetcode-cn.com/solution-static/207/fig9.png),![BFS10](https://assets.leetcode-cn.com/solution-static/207/fig10.png),![BFS11](https://assets.leetcode-cn.com/solution-static/207/fig11.png),![BFS12](https://assets.leetcode-cn.com/solution-static/207/fig12.png),![BFS13](https://assets.leetcode-cn.com/solution-static/207/fig13.png),![BFS14](https://assets.leetcode-cn.com/solution-static/207/fig14.png)>

**优化**

由于我们只需要判断是否存在一种拓扑排序，因此我们省去存放答案数组，而是只用一个变量记录被放入答案数组的节点个数。在广度优先搜索结束之后，我们判断该变量的值是否等于课程数，就能知道是否存在一种拓扑排序。

**代码**

```C++ [sol2-C++]
class Solution {
private:
    vector<vector<int>> edges;
    vector<int> indeg;

public:
    bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
        edges.resize(numCourses);
        indeg.resize(numCourses);
        for (const auto& info: prerequisites) {
            edges[info[1]].push_back(info[0]);
            ++indeg[info[0]];
        }

        queue<int> q;
        for (int i = 0; i < numCourses; ++i) {
            if (indeg[i] == 0) {
                q.push(i);
            }
        }

        int visited = 0;
        while (!q.empty()) {
            ++visited;
            int u = q.front();
            q.pop();
            for (int v: edges[u]) {
                --indeg[v];
                if (indeg[v] == 0) {
                    q.push(v);
                }
            }
        }

        return visited == numCourses;
    }
};
```

```Java [sol2-Java]
class Solution {
    List<List<Integer>> edges;
    int[] indeg;

    public boolean canFinish(int numCourses, int[][] prerequisites) {
        edges = new ArrayList<List<Integer>>();
        for (int i = 0; i < numCourses; ++i) {
            edges.add(new ArrayList<Integer>());
        }
        indeg = new int[numCourses];
        for (int[] info : prerequisites) {
            edges.get(info[1]).add(info[0]);
            ++indeg[info[0]];
        }

        Queue<Integer> queue = new LinkedList<Integer>();
        for (int i = 0; i < numCourses; ++i) {
            if (indeg[i] == 0) {
                queue.offer(i);
            }
        }

        int visited = 0;
        while (!queue.isEmpty()) {
            ++visited;
            int u = queue.poll();
            for (int v: edges.get(u)) {
                --indeg[v];
                if (indeg[v] == 0) {
                    queue.offer(v);
                }
            }
        }

        return visited == numCourses;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def canFinish(self, numCourses: int, prerequisites: List[List[int]]) -> bool:
        edges = collections.defaultdict(list)
        indeg = [0] * numCourses

        for info in prerequisites:
            edges[info[1]].append(info[0])
            indeg[info[0]] += 1
        
        q = collections.deque([u for u in range(numCourses) if indeg[u] == 0])
        visited = 0

        while q:
            visited += 1
            u = q.popleft()
            for v in edges[u]:
                indeg[v] -= 1
                if indeg[v] == 0:
                    q.append(v)

        return visited == numCourses
```

```C [sol2-C]
bool canFinish(int numCourses, int** prerequisites, int prerequisitesSize, int* prerequisitesColSize) {
    int** edges = (int**)malloc(sizeof(int*) * numCourses);
    for (int i = 0; i < numCourses; i++) {
        edges[i] = (int*)malloc(0);
    }
    int edgeColSize[numCourses];
    memset(edgeColSize, 0, sizeof(edgeColSize));
    int indeg[numCourses];
    memset(indeg, 0, sizeof(indeg));
    for (int i = 0; i < prerequisitesSize; ++i) {
        int a = prerequisites[i][1], b = prerequisites[i][0];
        edgeColSize[a]++;
        edges[a] = (int*)realloc(edges[a], sizeof(int) * edgeColSize[a]);
        edges[a][edgeColSize[a] - 1] = b;
        ++indeg[b];
    }

    int q[numCourses];
    int l = 0, r = -1;
    for (int i = 0; i < numCourses; ++i) {
        if (indeg[i] == 0) {
            q[++r] = i;
        }
    }

    int visited = 0;
    while (l <= r) {
        ++visited;
        int u = q[l++];
        for (int i = 0; i < edgeColSize[u]; ++i) {
            --indeg[edges[u][i]];
            if (indeg[edges[u][i]] == 0) {
                q[++r] = edges[u][i];
            }
        }
    }
    for (int i = 0; i < numCourses; i++) {
        free(edges[i]);
    }
    free(edges);
    return visited == numCourses;
}

```

```golang [sol2-Golang]
func canFinish(numCourses int, prerequisites [][]int) bool {
    var (
        edges = make([][]int, numCourses)
        indeg = make([]int, numCourses)
        result []int
    )

    for _, info := range prerequisites {
        edges[info[1]] = append(edges[info[1]], info[0])
        indeg[info[0]]++
    }

    q := []int{}
    for i := 0; i < numCourses; i++ {
        if indeg[i] == 0 {
            q = append(q, i)
        }
    }

    for len(q) > 0 {
        u := q[0]
        q = q[1:]
        result = append(result, u)
        for _, v := range edges[u] {
            indeg[v]--
            if indeg[v] == 0 {
                q = append(q, v)
            }
        }
    }
    return len(result) == numCourses
}
```

**复杂度分析**

- 时间复杂度: $O(n+m)$，其中 $n$ 为课程数，$m$ 为先修课程的要求数。这其实就是对图进行广度优先搜索的时间复杂度。

- 空间复杂度: $O(n+m)$。题目中是以列表形式给出的先修课程关系，为了对图进行广度优先搜索，我们需要存储成邻接表的形式，空间复杂度为 $O(n+m)$。在广度优先搜索的过程中，我们需要最多 $O(n)$ 的队列空间（迭代）进行广度优先搜索。因此总空间复杂度为 $O(n+m)$。
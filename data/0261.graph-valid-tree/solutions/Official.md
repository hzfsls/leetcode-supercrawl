## 解决方案

___

对于本文，我们假设您已经学习了图论的基础知识，以及如何执行简单的深度优先搜索。大多数关于算法或离散数学的教科书都有一个关于它的章节。

有很多不同的方法来解决这个问题，但不可能涵盖所有的方法。出于这个原因，我尝试将这些方法分成几个通用的方法，然后针对每个方法讨论几个额外的变体。方法 1 中涵盖的一些想法可能也适用于方法 2。

  

___

#### 方法 1: 图论 + 迭代深度优先搜索

**概述**

_注意这个方法对于递归深度优先搜索和迭代宽度优先搜索也同样适用。我们将在算法步骤部分简单看看。_

回想一下，图 `G` **是树当且仅当** 满足以下两个条件：

1.  `G` 完全连通。换句话说，对于 `G` 中的每一对点，都有一条路径连接彼此。
2.  `G` 不包含环。换句话说，对于 `G` 中的每一对点只有一条路径连接彼此。

**深度优先搜索** 是一个经典的图遍历算法能够用于检查下面的这些条件：

1.  `G` 是全连通的，当且仅当我们从单个的源点开始深度优先搜索并且在此期间找到了 `G` 中的所有节点。
2.  `G` 不包含环当且仅当深度优先搜索从不回到一个已经搜索过的点。但我们需要注意的是，不要计算大多数无向边实现中出现的形式为 `A → B → A` 的琐碎循环。

深度优先搜索需要能够查看给定点 _相邻的_(直接邻居)。然而，像许多图访问问题一样，我们得到的输入格式不允许我们快速获得节点的邻居。因此，我们的第一步是将输入转换为 **邻接列表**。回想一下，**邻接列表** 是我们具有子列表的列表，其中每个子列表是第 i 个节点的直接邻居的列表。

```Java
// 创建一个新的列表的列表。
List<List<Integer>> adjacencyList = new ArrayList<>();
// 为每个节点初始化一个空列表。
for (int i = 0; i < n; i++) {
    adjacencyList.add(new ArrayList<>());
}
// 浏览边列表，填充邻接列表。
for (int[] edge : edges) {
    adjacencyList.get(edge[0]).add(edge[1]);
    adjacencyList.get(edge[1]).add(edge[0]);
}
```

在我们开始实际执行深度优先搜索之前，让我们快速地向自己确保，**邻接表** 是这个问题的最佳图形表示。另外两个选项是 **邻接矩阵** 或 **链表表示**。

-   对于这个问题，一个 **邻接矩阵** 将是一个可以接受的表示，尽管不是很理想。通常，只有当我们知道边数大大高于节点数时，我们才会使用邻接矩阵。我们没有理由相信情况就是这样。方法 2 也将对此提供一些有用的见解。
-   将实际节点作为对象的 **链表表示法** 是一种过于复杂的表示法，可能会向面试官暗示您对邻接列表和邻接矩阵的了解有限。它们在面试问题中并不常用。

无论如何，让我们从 **深度优先搜索** 开始。回想一下，大多数深度优先搜索遵循如下模板进行 **迭代深度优先搜索**。注意，这个_还没有解决确定输入图是否为树的问题_--我们只是使用它作为构建解决方案的一个步骤。

```Java
// 使用一个栈来维护未访问的节点。
Stack<Integer> stack = new Stack<>();
stack.push(0);
// 使用一个集合来维护已经访问的节点来避免无限循环。
Set<Integer> seen = new HashSet<>();
seen.add(0);

// 当栈上有剩余的节点
while (!stack.isEmpty()) {
    int node = stack.pop(); // 取一个来访问
    // 检查这个节点的未访问邻居
    for (int neighbour : adjacencyList.get(node)) {
        if (seen.contains(neighbour)) {
            continue; // 已经访问了这个节点
        }
        // 否则把这个邻居加入到栈
        // 并记录它已经访问过。
        stack.push(neighbour);
        seen.add(neighbour);
    }
}
```

现在，让我们了解如何修改基本深度优先搜索模板以执行所需的两个检查。

第一个检查很简单。**如果图是完全连通的**，那么每个节点肯定都被访问了。这意味着所有节点必须在末尾的 `seen` 集合中。因为集合删除了重复项，并且唯一进入其中的值是有效的节点号，所以我们知道该图是完全连通的 _当且仅当_ `seen` 集合最后包含 `n` 个值

```Java
// 如果深度优先搜索遍历了所有节点，则返回 true。
return seen.size() == n;
```

对于第二次检查，您可能会想：难道我们不能只修改上面的算法，以便在访问已经访问过的邻居时返回 `false` 吗？

```Java
if (seen.contains(neighbour)) {
    return false;
}
```

然而，这只适用于有向图。在无向图上，就像我们正在处理的图一样，将检测到微小的“环”。例如，如果节点 `A` 和节点 `B` 之间存在无向边，则检测到的环将包括 `A→B→A`。这是因为无向边实际上是邻接列表中的 _2_ 条边，因此形成了一个平凡环 。

![image.png](https://pic.leetcode.cn/1692690488-ECfKkV-image.png){:width=400}

有几种策略可以检测无向图是否包含环，同时排除平凡环。大多数依赖于这样的想法，即深度优先搜索应该只沿每个边 _一次_，因此只在 _一_ 个方向上。这意味着当我们沿着一条边走时，我们应该做一些事情来确保我们以后不会沿着相反的方向返回。以下是实现这一点的几种方法。

第一种策略是简单地从邻接列表中删除相反方向的边。换句话说，当我们经过一条边 `A→B` 时，我们应该查找B的邻接表并从其中删除 `A`，有效地移除了`B→A` 的相对边。

```Java
// 当栈上还有剩余的节点
while (!stack.isEmpty()) {
    int node = stack.pop(); // 取一个来访问
    // 检查这个节点的未访问邻居
    for (int neighbour : adjacencyList.get(node)) {
        // 检查我们是否已经访问过这个节点。
        if (seen.contains(neighbour)) {
            return false;
        }
        // 否则，把这个邻居加入栈
        // 并记录它已经被访问
        stack.push(neighbour);
        seen.add(neighbour);
        // 移除它的对向边
        adjacencyList.get(neighbour).remove(node);
    }
}
```

第二种策略不是使用 `seen` 集合，而是使用 `seen` _map_，它还跟踪我们从中获得节点的“父”节点。我们称这个 map 为 `parent`。然后，当我们遍历节点的邻居节点时，我们忽略“父”节点，否则它将被检测为平凡环(而且我们知道父节点无论如何都已经被这个点访问过)。起始节点(在本实现中为 `0`)没有父节点，所以将其设置为 `-1`。

起初，人们更难理解为什么这一策略会奏效。思考它的一个好方法是记住，像第一个方法一样，我们只是想避免沿着我们已经在上面的边走(在相反的方向上)。父链接防止了这种情况，因为每个节点只被遍历一次。所以，想象一下，你正在穿过一座迷宫，条件是你不能沿着你已经走过的任何一条小路返回。如果你仍然以某种方式停在了你以前所在的地方，那一定是一个环！

```Java
// 使用一个 map 记录我们如何进入每一个节点
Map<Integer, Integer> parent = new HashMap<>();
parent.put(0, -1);

// 当栈上还有剩余的节点
while (!stack.isEmpty()) {
    int node = stack.pop(); // 取一个来访问
    // 检查这个节点的未访问邻居
    for (int neighbour : adjacencyList.get(node)) {
        // 不要遍历平凡环
        if (parent.get(node) == neighbour) {
            continue;
        }
        // 检查我们是否已经访问过这个节点。
        if (parent.containsKey(neighbour)) {
            return false; // There must be a cycle.
        }
        // 否则，把这个邻居加入栈
        // 并记录它已经被访问
        stack.push(neighbour);
        parent.put(neighbour, node);
    }
}
```

解决此问题的最佳策略可能是第二种策略，因为它不需要修改邻接列表。不过，对于更复杂的图形问题，第一种策略可能很有用。

**算法步骤**

在这个例子中，我们使用 _迭代深度优先搜索_。下面是完整代码。

```Java [slu1]
public boolean validTree(int n, int[][] edges) {
            
    List<List<Integer>> adjacencyList = new ArrayList<>();
    for (int i = 0; i < n; i++) {
        adjacencyList.add(new ArrayList<>());
    }
    for (int[] edge : edges) {
        adjacencyList.get(edge[0]).add(edge[1]);
        adjacencyList.get(edge[1]).add(edge[0]);
    }
    
    Map<Integer, Integer> parent = new HashMap<>();
    parent.put(0, -1);
    Stack<Integer> stack = new Stack<>();
    stack.push(0);

    while (!stack.isEmpty()) {
        int node = stack.pop();
        for (int neighbour : adjacencyList.get(node)) {
            if (parent.get(node) == neighbour) {
                continue;
            }
            if (parent.containsKey(neighbour)) {
                return false;
            }
            stack.push(neighbour);
            parent.put(neighbour, node);
        }
    }
    
    return parent.size() == n;   
}
```

```Python [slu1]
def validTree(self, n: int, edges: List[List[int]]) -> bool:
    
    if len(edges) != n - 1: return False
    
    adj_list = [[] for _ in range(n)]
    for A, B in edges:
        adj_list[A].append(B)
        adj_list[B].append(A)
    
    parent = {0: -1}
    stack = [0]
    
    while stack:
        node = stack.pop()
        for neighbour in adj_list[node]:
            if neighbour == parent[node]:
                continue
            if neighbour in parent:
                return False
            parent[neighbour] = node
            stack.append(neighbour)
    
    return len(parent) == n
```

或者，您也可以使用递归，只要您对它相当有信心。递归方法更优雅，但在某些编程语言中被认为不如迭代版本。这是因为运行时堆栈使用的空间因编程语言而异。

从好的方面来说，我们可以使用一个简单的 `seen` 集，只传递一个 `parent` 参数。这使得代码变得更简单了！

```Java [slu2]
class Solution {
    
    private List<List<Integer>> adjacencyList = new ArrayList<>();
    private Set<Integer> seen = new HashSet<>();
    
    
    public boolean validTree(int n, int[][] edges) {
        
        if (edges.length != n - 1) return false;
        
        for (int i = 0; i < n; i++) {
            adjacencyList.add(new ArrayList<>());
        }
        for (int[] edge : edges) {
            adjacencyList.get(edge[0]).add(edge[1]);
            adjacencyList.get(edge[1]).add(edge[0]);
        }
        
        // 我们返回 true 当且仅当没有发现环
        // 并且到达了整个图
        return dfs(0, -1) && seen.size() == n;   
    }
    
    public boolean dfs(int node, int parent) {
        if (seen.contains(node)) return false;
        seen.add(node);
        for (int neighbour : adjacencyList.get(node)) {
            if (parent != neighbour) {
                boolean result = dfs(neighbour, node);
                if (!result) return false;
            }
        }
        return true;
    }
}
```

```Python [slu2]
def validTree(self, n: int, edges: List[List[int]]) -> bool:
    
    if len(edges) != n - 1: return False
    
    adj_list = [[] for _ in range(n)]
    for A, B in edges:
        adj_list[A].append(B)
        adj_list[B].append(A)
    
    seen = set()
    
    def dfs(node, parent):
        if node in seen: return;
        seen.add(node)
        for neighbour in adj_list[node]:
            if neighbour == parent:
                continue
            if neighbour in seen:
                return False
            result = dfs(neighbour, node)
            if not result: return False
        return True
    
    # 我们返回 true 当且仅当没有发现环
    # 并且到达了整个图
    return dfs(0, -1) and len(seen) == n
```

另一种变体是使用迭代广度优先搜索。回想一下，广度优先搜索和深度优先搜索几乎是相同的算法，只是数据结构不同。

```Java [slu3]
public boolean validTree(int n, int[][] edges) {
            
    List<List<Integer>> adjacencyList = new ArrayList<>();
    for (int i = 0; i < n; i++) {
        adjacencyList.add(new ArrayList<>());
    }
    for (int[] edge : edges) {
        adjacencyList.get(edge[0]).add(edge[1]);
        adjacencyList.get(edge[1]).add(edge[0]);
    }
    
    Map<Integer, Integer> parent = new HashMap<>();
    parent.put(0, -1);
    Queue<Integer> queue = new LinkedList<>();
    queue.offer(0);

    while (!queue.isEmpty()) {
        int node = queue.poll();
        for (int neighbour : adjacencyList.get(node)) {
            if (parent.get(node) == neighbour) {
                continue;
            }
            if (parent.containsKey(neighbour)) {
                return false;
            }
            queue.offer(neighbour);
            parent.put(neighbour, node);
        }
    }
    
    return parent.size() == n;   
}
```

```Python [slu3]
def validTree(self, n: int, edges: List[List[int]]) -> bool:
    
    if len(edges) != n - 1: return False
    
    adj_list = [[] for _ in range(n)]
    for A, B in edges:
        adj_list[A].append(B)
        adj_list[B].append(A)
    
    parent = {0: -1}
    queue = collections.deque([0])
    
    while queue:
        node = queue.popleft()
        for neighbour in adj_list[node]:
            if neighbour == parent[node]:
                continue
            if neighbour in parent:
                return False
            parent[neighbour] = node
            queue.append(neighbour)
    
    return len(parent) == ndef validTree(self, n: int, edges: List[List[int]]) -> bool:
    
    if len(edges) != n - 1: return False
    
    adj_list = [[] for _ in range(n)]
    for A, B in edges:
        adj_list[A].append(B)
        adj_list[B].append(A)
    
    parent = {0: -1}
    queue = collections.deque([0])
    
    while queue:
        node = queue.popleft()
        for neighbour in adj_list[node]:
            if neighbour == parent[node]:
                continue
            if neighbour in parent:
                return False
            parent[neighbour] = node
            queue.append(neighbour)
    
    return len(parent) == ndef validTree(self, n: int, edges: List[List[int]]) -> bool:
    
    if len(edges) != n - 1: return False
    
    adj_list = [[] for _ in range(n)]
    for A, B in edges:
        adj_list[A].append(B)
        adj_list[B].append(A)
    
    parent = {0: -1}
    queue = collections.deque([0])
    
    while queue:
        node = queue.popleft()
        for neighbour in adj_list[node]:
            if neighbour == parent[node]:
                continue
            if neighbour in parent:
                return False
            parent[neighbour] = node
            queue.append(neighbour)
    
    return len(parent) == n
```

**复杂度分析**

让 $E$ 表示边的数量，$N$ 表示节点数量。

-   时间复杂度 : $O(N + E)$
    
    创建邻接列表需要初始化长度为 $N$ 的列表，成本为 $O(N)$，然后迭代并插入 $E$ 条边，成本为 $O(E)$。这就是 $O(E)+O(N)=O(N+E)$。
    
    每个节点都被添加到数据结构中 _一次_。这意味着外部循环将运行 $N$ 次。对于 $N$ 个节点的每一个，其相邻边迭代一次。总而言之，这意味着所有 $E$ 条边都由内部循环迭代一次。因此，这给出了 $O(N+E)$ 的总时间复杂性。
    
    由于这两个部分是相同的，我们得到了 $O(N+E)$ 的最终时间复杂度。
    
-   空间复杂度 : $O(N + E)$
    
    邻接列表是长度为 $N$ 的列表，其内部列表的长度加起来总计为 $E$。这给出了总的 $O(N+E)$ 空间。
    
    在最坏的情况下，堆栈/队列将同时拥有所有 $N$ 个节点，总共有 $O(N)$ 个空间。
    
    总共是 $O(E + N)$ 的空间。

___

#### 方法 2: 进阶图论 + 迭代深度优先搜索

**概述**

根据您对图论的了解程度，有一个更好的定义来确定给定的图是否为树。

要使该图成为有效的树，它必须有 _恰好_ `n-1` 条边。再少一点，它就不可能完全连接在一起。再多一些，它就必须包含环。此外，如果图是完全连通的，并且恰好包含 `n-1` 条边，则它不可能包含环，因此一定是树！

这些事实很容易证明。我们不会在这里探讨为什么它们是正确的，但如果你不熟悉这些事实，那么我们建议阅读图论。要想通过一家顶尖科技公司的面试，对图论充满信心是非常重要的。

按照这个定义，我们的算法需要做以下工作：

1.  检查是否有 `n-1` 条边。如果没有，则返回 `false`。
2.  检查该图是否完全连通。如果是，则返回 `true`，否则返回 `false`。

回想一下，方法 1 最复杂的部分是检查图是否包含环。这是因为在无向图中，我们需要注意平凡环。检查图是否完全连接很简单--我们只需检查从单个节点开始的搜索是否可以到达所有节点。

和以前一样，我们可以使用递归深度优先搜索、迭代深度优先搜索或迭代广度优先搜索来检查连接性。如果确实存在环，我们仍然需要使用 `seen` 集合来防止算法陷入无限循环(并防止平凡环上的循环)。

**算法步骤**

同样，我们提供了所有三种变体的代码。

迭代深度优先搜索。

```Java [slu]
public boolean validTree(int n, int[][] edges) {
        
    if (edges.length != n - 1) return false;
    
    // 创建邻接列表
    List<List<Integer>> adjacencyList = new ArrayList<>();
    for (int i = 0; i < n; i++) {
        adjacencyList.add(new ArrayList<>());
    }
    for (int[] edge : edges) {
        adjacencyList.get(edge[0]).add(edge[1]);
        adjacencyList.get(edge[1]).add(edge[0]);
    }
    
    Stack<Integer> stack = new Stack<>();
    Set<Integer> seen = new HashSet<>();
    stack.push(0);
    seen.add(0);
    
    while (!stack.isEmpty()) {
        int node = stack.pop();
        for (int neighbour : adjacencyList.get(node)) {
            if (seen.contains(neighbour)) continue;
            seen.add(neighbour);
            stack.push(neighbour);
        }
    }
    
    return seen.size() == n;   
}
```

```Python [slu]
def validTree(self, n: int, edges: List[List[int]]) -> bool:
    
    if len(edges) != n - 1: return False
    
    # 创建邻接列表
    adj_list = [[] for _ in range(n)]
    for A, B in edges:
        adj_list[A].append(B)
        adj_list[B].append(A)
    
    # 我们仍需要一个 seen 集合以防止无限循环
    # 如果有环 (以及在平凡环上)！
    seen = {0}
    stack = [0]
    
    while stack:
        node = stack.pop()
        for neighbour in adj_list[node]:
            if neighbour in seen:
                continue
            seen.add(neighbour)
            stack.append(neighbour)
    
    return len(seen) == n
```

递归深度优先搜索。

```Java [slu]
class Solution {
    
    private List<List<Integer>> adjacencyList = new ArrayList<>();
    private Set<Integer> seen = new HashSet<>();
    
    
    public boolean validTree(int n, int[][] edges) {
        
        if (edges.length != n - 1) return false;
        
        // 创建邻接列表
        for (int i = 0; i < n; i++) {
            adjacencyList.add(new ArrayList<>());
        }
        for (int[] edge : edges) {
            adjacencyList.get(edge[0]).add(edge[1]);
            adjacencyList.get(edge[1]).add(edge[0]);
        }
        
        // 开展深度优先搜索。
        dfs(0);
        // 检查结果，并返回判断。
        return seen.size() == n;   
    }
    
    public void dfs(int node) {
        if (seen.contains(node)) return;
        seen.add(node);
        for (int neighbour : adjacencyList.get(node)) {
            dfs(neighbour);
        }
    }
}
```

```Python [slu]
def validTree(self, n: int, edges: List[List[int]]) -> bool:
    
    if len(edges) != n - 1: return False
    
    # 创建邻接列表
    adj_list = [[] for _ in range(n)]
    for A, B in edges:
        adj_list[A].append(B)
        adj_list[B].append(A)
    
    # 我们仍需要一个 seen 集合以防止无限循环
    # 如果有环 (以及在平凡环上)！
    seen = set()

    def dfs(node):
        if node in seen: return
        seen.add(node)
        for neighbour in adj_list[node]:
            dfs(neighbour)

    dfs(0)
    return len(seen) == n
```

迭代宽度优先搜索。

```Java [slu]
public boolean validTree(int n, int[][] edges) {
    
    if (edges.length != n - 1) return false;
    
    // 创建邻接列表
    List<List<Integer>> adjacencyList = new ArrayList<>();
    for (int i = 0; i < n; i++) {
        adjacencyList.add(new ArrayList<>());
    }
    for (int[] edge : edges) {
        adjacencyList.get(edge[0]).add(edge[1]);
        adjacencyList.get(edge[1]).add(edge[0]);
    }
    
    Queue<Integer> queue = new LinkedList<>();
    Set<Integer> seen = new HashSet<>();
    queue.offer(0);
    seen.add(0);
    
    while (!queue.isEmpty()) {
        int node = queue.poll();
        for (int neighbour : adjacencyList.get(node)) {
            if (seen.contains(neighbour)) continue;
            seen.add(neighbour);
            queue.offer(neighbour);
        }
    }
    
    return seen.size() == n;   
}
```

```Python [slu]
def validTree(self, n: int, edges: List[List[int]]) -> bool:
    
    if len(edges) != n - 1: return False
    
    # 创建邻接列表
    adj_list = [[] for _ in range(n)]
    for A, B in edges:
        adj_list[A].append(B)
        adj_list[B].append(A)
    
    # 我们仍需要一个 seen 集合以防止无限循环
    # 如果有环 (以及在平凡环上)！
    seen = {0}
    queue = collections.deque([0])
    
    while queue:
        node = queue.popleft()
        for neighbour in adj_list[node]:
            if neighbour in seen:
                continue
            seen.add(neighbour)
            queue.append(neighbour)
    
    return len(seen) == n
```

**复杂度分析**

让 $E$ 表示边的数量，$N$ 表示节点数量。

-   时间复杂度 : $O(N)$。
    
    当 $E \neq N - 1$，我们直接返回 `false`。因此，最坏情况是当 $E = N - 1$ 时。由于 $E$ 与 $N$ 成正比，为了简化分析，我们假定 $E=N$。
    
    如上所述，创建邻接列表的时间复杂度为 $O(N + E)$。因为 $E$ 现在由 $N$ 限定，所以我们可以将其略微简化为 $O(N+N)=O(N)$。
    
    迭代宽度优先搜索和深度优先搜索几乎完全相同。每个节点都放进队列/栈 _一次_，由 `seen` 集合保证。因此，内部“邻居”循环为每个节点运行一次。在所有节点上，此循环执行的周期数与边数相同，即 $N$。因此，这两种算法的时间复杂度为 $O(N)$。
    
    递归深度优先搜索的“邻居”循环对每个节点只运行一次。因此，该函数总共为每条边调用一次。因此，它被调用 $E=N$ 次，而在这些次数中，它实际上进入了“邻居”循环。总的来说，“邻居”循环的总迭代次数是 $E=N$。因此，我们需要 $O(N)$，因为所有这些都简单地加在一起。
    
-   空间复杂度 : $O(N)$。
    
    以前，我们确定邻接表占用 $O(E+N)$ 空间。我们现在知道它仅仅是 $O(N)$。
    
    在最坏的情况下，搜索算法将需要额外的 $O(N)$ 空间；这是如果 _所有_ 节点同时在堆栈/队列上的话。
    
    所以总共需要 $O(N)$。
    
___

#### 方法 3: 进阶图论 + 并查集

**概述**

在方法 2 中，我们使用了树的如下定义：

> 一个图如果是合法的树，它必须有 _正好_ `n-1` 条边。再少一点，它就不可能完全连接在一起。再多一些，它就必须包含环。此外，如果图是完全连通的，并且恰好包含 `n-1` 条边，则它不可能包含环，因此一定是树！

这个定义将问题简化为检查图是否完全连接。如果它是，而且如果它包含 `n-1` 个边，那么我们就知道它是一个树。在之前的方法中，我们使用图搜索算法从单个源节点开始检查是否所有节点都可达。

我们可以解决问题的另一种方法是将每个连通分量视为一组节点。将一条边放置在两个单独的连通分量之间时，它们将合并为单个连通分量。 我们将使用 `n = 6` 和 `edges = [(0, 5), (4, 0), (1, 2), (4, 5), (3, 2)]` 作为例子。在我们查看边之前，我们有 `6` 个集合。

![6_sets.png](https://pic.leetcode.cn/1692690566-wKiNtU-6_sets.png){:width=400}

然后我们可以遍历边列表，并将集合合并在一起。例如，因为第一条边是 `(0，5)`，所以我们将集合 `0` 和 `5` 合并。这意味着我们现在有五个连通分量。

![5_sets.png](https://pic.leetcode.cn/1692690582-ucrMrj-5_sets.png){:width=400}

下一条边是 `(4, 0)`。因此我们合并 `{0, 5}` 和 `{4}` (记住因为 `0` 和 `5` 已经连接，并且 `4` 和 `0` 已经连接，这意味着 `4` 和 `5` 也一定已经连接)。

![4_sets.png](https://pic.leetcode.cn/1692690593-WGqrzt-4_sets.png){:width=400}

我们可以继续这个过程，直到我们遍历了所有的边。这是一个动画，展示了这一点。

<![Slide1.PNG](https://pic.leetcode.cn/1692690863-Cnaulo-Slide1.PNG){:width=400},![Slide2.PNG](https://pic.leetcode.cn/1692690863-lGTmTi-Slide2.PNG){:width=400},![Slide3.PNG](https://pic.leetcode.cn/1692690863-PrjOiv-Slide3.PNG){:width=400},![Slide4.PNG](https://pic.leetcode.cn/1692690863-MWZtTc-Slide4.PNG){:width=400},![Slide5.PNG](https://pic.leetcode.cn/1692690863-nufuhI-Slide5.PNG){:width=400},![Slide6.PNG](https://pic.leetcode.cn/1692690863-jlMSCg-Slide6.PNG){:width=400},![Slide7.PNG](https://pic.leetcode.cn/1692690863-AqXIuF-Slide7.PNG){:width=400},![Slide8.PNG](https://pic.leetcode.cn/1692690863-tttOaj-Slide8.PNG){:width=400},![Slide9.PNG](https://pic.leetcode.cn/1692690863-yOPDiS-Slide9.PNG){:width=400},![Slide10.PNG](https://pic.leetcode.cn/1692690863-DYgOdE-Slide10.PNG){:width=400},![Slide11.PNG](https://pic.leetcode.cn/1692690863-UKShNa-Slide11.PNG){:width=400}>

对于这个例子，我们可以得出的结论是，边不在单个连通分量中，因此肯定包含一个环。该算法应返回 `false`。

这是另一个边 _确实_ 形成单个连通分量的例子。

<![Slide1.PNG](https://pic.leetcode.cn/1692690924-Edofjy-Slide1.PNG){:width=400},![Slide2.PNG](https://pic.leetcode.cn/1692690924-tMcfZj-Slide2.PNG){:width=400},![Slide3.PNG](https://pic.leetcode.cn/1692690924-YpKBou-Slide3.PNG){:width=400},![Slide4.PNG](https://pic.leetcode.cn/1692690924-RzcqEl-Slide4.PNG){:width=400},![Slide5.PNG](https://pic.leetcode.cn/1692690924-dzjyGS-Slide5.PNG){:width=400},![Slide6.PNG](https://pic.leetcode.cn/1692690924-bfcIEX-Slide6.PNG){:width=400},![Slide7.PNG](https://pic.leetcode.cn/1692690924-sLPOZd-Slide7.PNG){:width=400},![Slide8.PNG](https://pic.leetcode.cn/1692690924-bYaNcJ-Slide8.PNG){:width=400},![Slide9.PNG](https://pic.leetcode.cn/1692690924-rmtraZ-Slide9.PNG){:width=400},![Slide10.PNG](https://pic.leetcode.cn/1692690924-aFvzYg-Slide10.PNG){:width=400},![Slide11.PNG](https://pic.leetcode.cn/1692690924-YwnMHP-Slide11.PNG){:width=400},![Slide12.PNG](https://pic.leetcode.cn/1692690924-SZLtWf-Slide12.PNG){:width=400}>

您是否注意到，在第二个动画中，每条边都会导致合并操作，但在第一个动画中，有些边不会？这是因为图中有环。每次没有合并，都是因为我们在已经通过路径连接的两个节点之间添加了一条边。这意味着现在在它们之间有了一条额外的路径--这就是环的定义。因此，_一旦发生这种情况，我们就可以终止算法并返回 `false`。

现在，我们应该如何实施这一点呢？那么，我们可以创建一个 `Set` 列表，然后像在动画中那样执行算法。然而，还有一种更好的方法；一种非常聪明的算法，我们称之为 **并查集**。我将在这里简要介绍算法，但是，如果你不熟悉它，我强烈建议从一本好的算法教科书中阅读它。并查集是一个非常有用的算法，可以用来解决许多图问题。

并查集将每个集合表示为有向树，边指向根节点。例如，考虑上面第一个示例中的图表(不是有效树的图表)。

![image.png](https://pic.leetcode.cn/1692690675-QxDril-image.png){:width=400}

其连通分量可由并查集表示的一种方式如下：

![image.png](https://pic.leetcode.cn/1692690750-PiqVvI-image.png){:width=400}

并查集是一个有 3 个方法的 **数据结构**; `makeset(A)`, `find(A)` 和 `union(A, B)`.

-   `makeset(A)` 方法是最简单的。它创建了一个大小为 size-1 的新集合，只包含元素 `A`。
    
-   `find(A)` 方法从 `A` 开始，并跟踪父级链接，直到找到 `A` 的根。然后，它返回根 ID。位于同一连通分量中的两个节点具有相同的根。如果它们位于不同的连接组件中，则它们将具有不同的根。在上面的例子中，`find(0)`、`find(4)` 和 `find(5)` 都会返回 `5`。而 `find(1)`、`find(2)` 和 `find(3)`都会返回 `1`。这个方法可以用来检查两个元素是否在相同的连通分量中，并且也被 `union(A，B)` 方法使用，正如我们将要看到的。
    
-   `union(A，B)` 方法的工作原理是使用 `find(...)` 操作找到 `A` 的根和 `B` 的根。然后，它将 `B` 的父亲设置为 `A`，从而将两个树合并。例如，如果我们在上面的示例中添加边 `(4，3)`，算法会发现 `4` 的根是 `5`，`3` 的根是 `1`，并将这些子树合并。完成后，所有节点都有相同的根 `5`，因此我们知道它们都属于同一个连通分量。
    

![image.png](https://pic.leetcode.cn/1692690784-UHicrT-image.png){:width=400}

我们不需要使用链表来表示该结构；我们只需维护一个父指针数组。例如，上面的树是如何表示为数组的。

![parent_pointers.png](https://pic.leetcode.cn/1692690800-ypdOTC-parent_pointers.png){:width=400}

注意 `5` 是如何简单地指向自己的，因为它是根。`find(...)` 操作沿着父链路向上运行，直到找到指向其自身的节点。

这个算法可能看起来不是很高效，毕竟，在最坏的情况下，`find(...)` 操作可能是 $O(N)$。然而，我们可以应用两个简单的优化，使 `union(...)` 和 `find(...)` 的平摊时间复杂度接近 $O(1)$。

1.  跟踪每一组的大小；这有助于确保树深度最小化，因为我们可以确保较小的组连接到较大的组，而不是相反。对此的修改位于 `union(...)` 方法中。
    
2.  当执行 `find(...)` 时，跟踪路径上的所有节点，以便之后我们可以使每个指针直接指向根，以便下次搜索这些节点中的任何一个时，它是 $O(1)$。对此的修改都在 `find(...)` 方法中。
    
它们的变种也存在，导致相同的总体时间复杂性。

**算法步骤**

首先，这里是没有 _优化_ 的代码。下面，我还包括了优化后的代码。如果您是并查集的新手，那么我建议您先阅读没有优化的代码，因为它更容易理解！

```Java [slu]
class UnionFind {
    
    private int[] parent;
    
    // 为了效率，我们不使用 makeset，而是
    // 在构造函数同时产生所有集合
    public UnionFind(int n) {
        parent = new int[n];
        for (int node = 0; node < n; node++) {
            parent[node] = node;
        }
    }
    
    // 未进行任何优化的 find 方法。它会追踪到父连接
    // 直到找到 A 的根节点，并返回那个根节点。
    public int find(int A) {
        while (parent[A] != A) {
            A = parent[A];
        }
        return A;
    }

    // 未进行优化的 union 方法。 
    // 如果发生合并它返回 true，否则返回 false
    public boolean union(int A, int B) {
        // 找到 A 和 B 的根
        int rootA = find(A);
        int rootB = find(B);
        // 检查 A 和 B 是否已经在同一个集合中
        if (rootA == rootB) {
            return false;
        }
        // 合并包含 A 和 B 的集合
        parent[rootA] = rootB;
        return true;
    } 
}

class Solution {
    
    public boolean validTree(int n, int[][] edges) {
        
        // 情况 1: 图必须包含 n - 1 条边。
        if (edges.length != n - 1) return false;
        
        // 
        // 
        UnionFind unionFind = new UnionFind(n);
        // 添加每一条边。检查是否发生合并，
        // 因为如果它没有，就一定有环
        for (int[] edge : edges) {
            int A = edge[0];
            int B = edge[1];
            if (!unionFind.union(A, B)) {
                return false;
            }
        }
        
        // 如果我们走到这一步，就没有环了！
        return true;
    }
    
}
```

```Python [slu]
class UnionFind:
    
    # 为了效率，我们不使用 makeset，而是
    # 在构造函数同时产生所有集合
    def __init__(self, n):
        self.parent = [node for node in range(n)]
        
    # 未进行任何优化的 find 方法。它会追踪到父连接
    # 直到找到 A 的根节点，并返回那个根节点。
    def find(self, A):
        while A != self.parent[A]:
            A = self.parent[A]
        return A
        
    # 未进行优化的 union 方法。 
    # 如果发生合并它返回 true，否则返回 false
    def union(self, A, B):
        # 找到 A 和 B 的根
        root_A = self.find(A)
        root_B = self.find(B)
        # 检查 A 和 B 是否已经在同一个集合中
        if root_A == root_B:
            return False
        # 合并包含 A 和 B 的集合
        self.parent[root_A] = root_B
        return True

class Solution:
    def validTree(self, n: int, edges: List[List[int]]) -> bool:
        # 情况 1: 图必须包含 n - 1 条边。
        if len(edges) != n - 1: return False
        
        # 情况 2: 图必须包含单个连通分量
        # 创建一个包含 n 个节点的新并查集对象。
        unionFind = UnionFind(n)
        # 添加每一条边。检查是否发生合并，
        # 因为如果它没有，就一定有环
        for A, B in edges:
            if not unionFind.union(A, B):
                return False
        # 如果我们走到这一步，就没有环了！
        return True
        
```

下面是使用了 _路径压缩_ 与 _按秩合并_ 优化的解决方案。

```Java [slu]
class UnionFind {
    
    private int[] parent;
    private int[] size; // 我们使用这个维护每个集合的大小
    
    // 为了效率，我们不使用 makeset，而是
    // 在构造函数同时产生所有集合
    public UnionFind(int n) {
        parent = new int[n];
        size = new int[n];
        for (int node = 0; node < n; node++) {
            parent[node] = node;
            size[node] = 1;
        }
    }
    
    // 使用路径压缩的 find 方法。存在优雅的使用递归的实现，
    // 但迭代方法更适合大多数人理解！
    public int find(int A) {
        // 步骤 1:找到根
        int root = A;
        while (parent[root] != root) {
            root = parent[root];
        }
        // 步骤 2: 执行第二次遍历，这一次在执行过程中
        // 将每个节点设置为直接指向 A。
        while (A != root) {
            int oldRoot = parent[A];
            parent[A] = root;
            A = oldRoot;
        }
        return root;
    }

    // 使用按秩合并优化的 union 方法。当合并发生时它返回 True，
    // 否则返回 False。
    public boolean union(int A, int B) {
        // 找到 A 和 B 的根
        int rootA = find(A);
        int rootB = find(B);
        // 检查 A 和 B 是否已经在同一个集合中
        if (rootA == rootB) {
            return false;
        }
        // 我们希望确保更大的一组仍然是根。
        if (size[rootA] < size[rootB]) {
            // 将 root_B 设置为总的根。
            parent[rootA] = rootB;
            // 以 B 为根的集合的大小是两者之和
            size[rootB] += size[rootA];
        }
        else {
            // 将 root_A 设置为总的根。
            parent[rootB] = rootA;
            // 以 A 为根的集合的大小是两者之和
            size[rootA] += size[rootB];
        }
        return true;
    } 
}

class Solution {
    
    public boolean validTree(int n, int[][] edges) {
        
        // 条件 1：图必须包含 n - 1 条边。
        if (edges.length != n - 1) return false;
        
        // 条件 2：图必须包含单个连通分量
        // 创建一个包含 n 个节点的新并查集对象。
        UnionFind unionFind = new UnionFind(n);
        // 添加每一条边。检查是否发生合并，
        // 因为如果它没有，就一定有环
        for (int[] edge : edges) {
            int A = edge[0];
            int B = edge[1];
            if (!unionFind.union(A, B)) {
                return false;
            }
        }
        
        // 如果我们走到这一步，就没有环了！
        return true;
    }
    
}
```

```Python [slu]
class UnionFind:
    
    # 为了效率，我们不使用 makeset，而是
    # 在构造函数同时产生所有集合
    def __init__(self, n):
        self.parent = [node for node in range(n)]
        # 我们使用这个维护每个集合的大小
        self.size = [1] * n
        
    # 使用路径压缩的 find 方法。存在优雅的使用递归的实现
    # 但迭代方法更适合大多数人理解！
    def find(self, A):
        # 步骤 1:找到根
        root = A
        while root != self.parent[root]:
            root = self.parent[root]
        # 步骤 2: 执行第二次遍历，这一次在执行过程中
        # 将每个节点设置为直接指向 A。
        while A != root:
            old_root = self.parent[A]
            self.parent[A] = root
            A = old_root
        return root
        
    # 使用按秩合并优化的 union 方法。当合并发生时它返回 True，
    # 否则返回 False。
    def union(self, A, B):
        # 找到 A 和 B 的根
        root_A = self.find(A)
        root_B = self.find(B)
        # 检查 A 和 B 是否已经在同一个集合中
        if root_A == root_B:
            return False
        # 我们希望确保更大的一组仍然是根。
        if self.size[root_A] < self.size[root_B]:
            # 将 root_B 设置为总的根。
            self.parent[root_A] = root_B
            # 以 B 为根的集合的大小是两者之和
            self.size[root_B] += self.size[root_A]
        else:
            # 将 root_A 设置为总的根。
            self.parent[root_B] = root_A
            # 以 A 为根的集合的大小是两者之和
            self.size[root_A] += self.size[root_B]
        return True

class Solution:
    def validTree(self, n: int, edges: List[List[int]]) -> bool:
        # 条件 1：图必须包含 n - 1 条边。
        if len(edges) != n - 1: return False
        
        # 创建一个包含 n 个节点的新并查集对象。
        unionFind = UnionFind(n)
        
        # 添加每一条边。检查是否发生合并，
        # 因为如果它没有，就一定有环
        for A, B in edges:
            if not unionFind.union(A, B):
                return False
        
        # 如果我们走到这一步，就没有环了！
        return True
```

**复杂度分析**

让 $E$ 表示边的数量，$N$ 表示节点数量。

$α(N)$ 是反阿克曼函数。

-   时间复杂度 : $O(N \cdot α(N))$。
    
    当 $E \neq N-1$ 时，我们只返回 `false`。因此，最坏的情况是 $E=N−1$。由于 $E$ 与 $N$ 成正比，为了简化分析，我们假设 $E=N$。
    
    我们使用 `union(...)` 方法将 $N$ 条边的每一条放入 `并查集` 数据结构中。`union(...)` 方法本身没有循环或递归，因此调用它的整个开销取决于它调用的 `find(...)` 方法的开销。
    
    `find(...)` 的开销取决于正在搜索的节点离根有多远。使用并查集的简单实现，这个深度可能是 $N$。如果所有调用都是这种情况，我们的最终成本将为 $O(N^2)$。
    
    然而，还记得我们所做的那些优化吗？这使树的深度保持在非常浅的水平。结果表明，`find(...)` 将 _平摊_ 为 $O(α(N))$，其中 α 是逆阿克曼函数。这个函数令人难以置信的是，它增长得如此之慢，以至于在我们所知的宇宙中，$N$ 永远不会超过4！因此，在“实践”中，它实际上是 $O(1)$，而在“理论”中，它不是。
    
    事实上，证明深度的上限是一个非常高级的证明，我当然希望你在面试中永远不需要这样做！如果你感兴趣，我建议你去看看好的算法课本或论文。
    
    无论如何，我们总共需要 $N \cdot O(α(N))=O(N \cdot α(N))$。
    
-   空间复杂度 : $O(N)$。
    
    并查集数据结构需要 $O(N)$ 空间来储存它需要的数组。
    

_所以为什么这比方法 2 更好?_

复杂性分析忽略常量。例如，$O(10 \cdot N)=O(N)$。甚至是 $O(10000 \cdot N)=O(N)$。有时，我们在分析中忽略的常量在实践中仍然会对运行时产生很大影响。

方法 2 甚至需要在开始深度优先搜索之前创建与边的邻接列表，这带来了大量开销。这一切都被视为一个常量，因为它最终具有与深度优先搜索本身相同的时间复杂性。

方法 3 不需要更改输入格式，它可以直接确定是否存在循环。此外，使其保持恒定的 α(N)的值永远不会大于 4。因此，在实践中，它也表现为一个常量--而且是一个小得多的常量！

在权衡解决问题的不同算法的优缺点时，最好将并查集的运算视为 $O(1)$，以获得公平和准确的比较。
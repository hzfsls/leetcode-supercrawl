## [133.克隆图 中文官方题解](https://leetcode.cn/problems/clone-graph/solutions/100000/ke-long-tu-by-leetcode-solution)
#### 方法一：深度优先搜索

**思路**

对于本题而言，我们需要明确**图的深拷贝**是在做什么，对于一张图而言，它的**深拷贝**即构建一张与原图结构，值均一样的图，但是其中的节点**不再是原来图节点的引用**。因此，为了深拷贝出整张图，我们需要知道整张图的结构以及对应节点的值。

由于题目只给了我们一个节点的引用，因此为了知道整张图的结构以及对应节点的值，我们需要从给定的节点出发，进行「图的遍历」，并在遍历的过程中完成**图的深拷贝**。

为了避免在深拷贝时陷入死循环，我们需要理解图的结构。对于一张无向图，任何给定的无向边都可以表示为**两个有向边**，即如果节点 `A` 和节点 `B` 之间存在无向边，则表示该图具有从节点 `A` 到节点 `B` 的有向边和从节点 `B` 到节点 `A` 的有向边。

![fig1](https://assets.leetcode-cn.com/solution-static/133/1.png)

为了防止多次遍历同一个节点，陷入死循环，我们需要用一种数据结构记录已经被克隆过的节点。

**算法**

1. 使用一个哈希表存储所有已被访问和克隆的节点。哈希表中的 `key` 是原始图中的节点，`value` 是克隆图中的对应节点。

2. 从给定节点开始遍历图。如果某个节点已经被访问过，则返回其克隆图中的对应节点。

    如下图，我们给定无向边边 `A - B`，表示 `A` 能连接到 `B`，且 `B` 能连接到 `A`。如果不对访问过的节点做标记，则会陷入死循环中。

![fig2](https://assets.leetcode-cn.com/solution-static/133/2.png)

3. 如果当前访问的节点不在哈希表中，则创建它的克隆节点并存储在哈希表中。注意：在进入递归之前，必须先创建克隆节点并保存在哈希表中。如果不保证这种顺序，可能会在递归中再次遇到同一个节点，再次遍历该节点时，陷入死循环。
   

![fig3](https://assets.leetcode-cn.com/solution-static/133/3.png)
    
4. 递归调用每个节点的邻接点。每个节点递归调用的次数等于邻接点的数量，每一次调用返回其对应邻接点的克隆节点，最终返回这些克隆邻接点的列表，将其放入对应克隆节点的邻接表中。这样就可以克隆给定的节点和其邻接点。

```java [sol1-Java]
class Solution {
    private HashMap <Node, Node> visited = new HashMap <> ();
    public Node cloneGraph(Node node) {
        if (node == null) {
            return node;
        }

        // 如果该节点已经被访问过了，则直接从哈希表中取出对应的克隆节点返回
        if (visited.containsKey(node)) {
            return visited.get(node);
        }

        // 克隆节点，注意到为了深拷贝我们不会克隆它的邻居的列表
        Node cloneNode = new Node(node.val, new ArrayList());
        // 哈希表存储
        visited.put(node, cloneNode);

        // 遍历该节点的邻居并更新克隆节点的邻居列表
        for (Node neighbor: node.neighbors) {
            cloneNode.neighbors.add(cloneGraph(neighbor));
        }
        return cloneNode;
    }
}
```

```python [sol1-Python]
class Solution(object):

    def __init__(self):
        self.visited = {}

    def cloneGraph(self, node):
        """
        :type node: Node
        :rtype: Node
        """
        if not node:
            return node

        # 如果该节点已经被访问过了，则直接从哈希表中取出对应的克隆节点返回
        if node in self.visited:
            return self.visited[node]

        # 克隆节点，注意到为了深拷贝我们不会克隆它的邻居的列表
        clone_node = Node(node.val, [])

        # 哈希表存储
        self.visited[node] = clone_node

        # 遍历该节点的邻居并更新克隆节点的邻居列表
        if node.neighbors:
            clone_node.neighbors = [self.cloneGraph(n) for n in node.neighbors]

        return clone_node
```

```C++ [sol1-C++]
class Solution {
public:
    unordered_map<Node*, Node*> visited;
    Node* cloneGraph(Node* node) {
        if (node == nullptr) {
            return node;
        }

        // 如果该节点已经被访问过了，则直接从哈希表中取出对应的克隆节点返回
        if (visited.find(node) != visited.end()) {
            return visited[node];
        }

        // 克隆节点，注意到为了深拷贝我们不会克隆它的邻居的列表
        Node* cloneNode = new Node(node->val);
        // 哈希表存储
        visited[node] = cloneNode;

        // 遍历该节点的邻居并更新克隆节点的邻居列表
        for (auto& neighbor: node->neighbors) {
            cloneNode->neighbors.emplace_back(cloneGraph(neighbor));
        }
        return cloneNode;
    }
};
```

```C [sol1-C]
struct Node** visited;

struct Node* dfs(struct Node* s) {
    if (s == NULL) {
        return NULL;
    }

    // 如果该节点已经被访问过了，则直接从哈希表中取出对应的克隆节点返回
    if (visited[s->val]) {
        return visited[s->val];
    }

    // 克隆节点，注意到为了深拷贝我们不会克隆它的邻居的列表
    struct Node* cloneNode = (struct Node*)malloc(sizeof(struct Node));
    cloneNode->val = s->val;
    cloneNode->numNeighbors = s->numNeighbors;

    // 哈希表存储
    visited[cloneNode->val] = cloneNode;
    cloneNode->neighbors = (struct Node**)malloc(sizeof(struct Node*) * cloneNode->numNeighbors);

    // 遍历该节点的邻居并更新克隆节点的邻居列表
    for (int i = 0; i < cloneNode->numNeighbors; i++) {
        cloneNode->neighbors[i] = dfs(s->neighbors[i]);
    }
    return cloneNode;
}

struct Node* cloneGraph(struct Node* s) {
    visited = (struct Node**)malloc(sizeof(struct Node*) * 101);
    memset(visited, 0, sizeof(struct Node*) * 101);
    return dfs(s);
}
```

```golang [sol1-Golang]
func cloneGraph(node *Node) *Node {
    visited := map[*Node]*Node{}
    var cg func(node *Node) *Node
    cg = func(node *Node) *Node {
        if node == nil {
            return node
        }

        // 如果该节点已经被访问过了，则直接从哈希表中取出对应的克隆节点返回
        if _, ok := visited[node]; ok {
            return visited[node]
        }

        // 克隆节点，注意到为了深拷贝我们不会克隆它的邻居的列表
        cloneNode := &Node{node.Val, []*Node{}}
        // 哈希表存储
        visited[node] = cloneNode

        // 遍历该节点的邻居并更新克隆节点的邻居列表
        for _, n := range node.Neighbors {
            cloneNode.Neighbors = append(cloneNode.Neighbors, cg(n))
        }
        return cloneNode
    }
    return cg(node)
}
```

**复杂度分析**

* 时间复杂度：$O(N)$，其中 $N$ 表示节点数量。深度优先搜索遍历图的过程中每个节点只会被访问一次。

* 空间复杂度：$O(N)$。存储克隆节点和原节点的哈希表需要 $O(N)$ 的空间，递归调用栈需要 $O(H)$ 的空间，其中 $H$ 是图的深度，经过放缩可以得到 $O(H) = O(N)$，因此总体空间复杂度为 $O(N)$。


#### 方法二：广度优先遍历

**思路**

同样，我们也可以用广度优先搜索来进行「图的遍历」。

![fig4](https://assets.leetcode-cn.com/solution-static/133/4.png)

方法一与方法二的区别仅在于搜索的方式。深度优先搜索以深度优先，广度优先搜索以广度优先。这两种方法都需要借助哈希表记录被克隆过的节点来避免陷入死循环。

**算法**

1. 使用一个哈希表 `visited` 存储所有已被访问和克隆的节点。哈希表中的 `key` 是原始图中的节点，`value` 是克隆图中的对应节点。

2. 将题目给定的节点添加到队列。克隆该节点并存储到哈希表中。

3. 每次从队列首部取出一个节点，遍历该节点的所有邻接点。如果某个邻接点已被访问，则该邻接点一定在 `visited` 中，那么从 `visited` 获得该邻接点，否则创建一个新的节点存储在 `visited` 中，并将邻接点添加到队列。将克隆的邻接点添加到克隆图对应节点的邻接表中。重复上述操作直到队列为空，则整个图遍历结束。

```java [sol2-Java]
class Solution {
    public Node cloneGraph(Node node) {
        if (node == null) {
            return node;
        }

        HashMap<Node, Node> visited = new HashMap();

        // 将题目给定的节点添加到队列
        LinkedList<Node> queue = new LinkedList<Node> ();
        queue.add(node);
        // 克隆第一个节点并存储到哈希表中
        visited.put(node, new Node(node.val, new ArrayList()));

        // 广度优先搜索
        while (!queue.isEmpty()) {
            // 取出队列的头节点
            Node n = queue.remove();
            // 遍历该节点的邻居
            for (Node neighbor: n.neighbors) {
                if (!visited.containsKey(neighbor)) {
                    // 如果没有被访问过，就克隆并存储在哈希表中
                    visited.put(neighbor, new Node(neighbor.val, new ArrayList()));
                    // 将邻居节点加入队列中
                    queue.add(neighbor);
                }
                // 更新当前节点的邻居列表
                visited.get(n).neighbors.add(visited.get(neighbor));
            }
        }

        return visited.get(node);
    }
}
```

```python [sol2-Python]
from collections import deque
class Solution(object):

    def cloneGraph(self, node):
        """
        :type node: Node
        :rtype: Node
        """

        if not node:
            return node

        visited = {}

        # 将题目给定的节点添加到队列
        queue = deque([node])
        # 克隆第一个节点并存储到哈希表中
        visited[node] = Node(node.val, [])

        # 广度优先搜索
        while queue:
            # 取出队列的头节点
            n = queue.popleft()
            # 遍历该节点的邻居
            for neighbor in n.neighbors:
                if neighbor not in visited:
                    # 如果没有被访问过，就克隆并存储在哈希表中
                    visited[neighbor] = Node(neighbor.val, [])
                    # 将邻居节点加入队列中
                    queue.append(neighbor)
                # 更新当前节点的邻居列表
                visited[n].neighbors.append(visited[neighbor])

        return visited[node]
```

```C++ [sol2-C++]
class Solution {
public:
    Node* cloneGraph(Node* node) {
        if (node == nullptr) {
            return node;
        }

        unordered_map<Node*, Node*> visited;

        // 将题目给定的节点添加到队列
        queue<Node*> Q;
        Q.push(node);
        // 克隆第一个节点并存储到哈希表中
        visited[node] = new Node(node->val);

        // 广度优先搜索
        while (!Q.empty()) {
            // 取出队列的头节点
            auto n = Q.front();
            Q.pop();
            // 遍历该节点的邻居
            for (auto& neighbor: n->neighbors) {
                if (visited.find(neighbor) == visited.end()) {
                    // 如果没有被访问过，就克隆并存储在哈希表中
                    visited[neighbor] = new Node(neighbor->val);
                    // 将邻居节点加入队列中
                    Q.push(neighbor);
                }
                // 更新当前节点的邻居列表
                visited[n]->neighbors.emplace_back(visited[neighbor]);
            }
        }

        return visited[node];
    }
};
```

```C [sol2-C]
struct Node** visited;
int* state;  //数组存放结点状态 0：结点未创建 1：仅创建结点 2：结点已创建并已填入所有内容

void bfs(struct Node* s) {
    if (visited[s->val] && state[s->val] == 2) {
        return;
    }
    struct Node* neighbor;
    if (visited[s->val]) {
        neighbor = visited[s->val];
        neighbor->val = s->val;
        neighbor->numNeighbors = s->numNeighbors;
        neighbor->neighbors = (struct Node**)malloc(sizeof(struct Node*) * neighbor->numNeighbors);
    } else {
        // 如果没有被访问过，就克隆并存储在哈希表中
        neighbor = (struct Node*)malloc(sizeof(struct Node));
        neighbor->val = s->val;
        neighbor->numNeighbors = s->numNeighbors;
        neighbor->neighbors = (struct Node**)malloc(sizeof(struct Node*) * neighbor->numNeighbors);
        visited[s->val] = neighbor;
    }
    for (int i = 0; i < neighbor->numNeighbors; i++) {
        if (visited[s->neighbors[i]->val]) {
            neighbor->neighbors[i] = visited[s->neighbors[i]->val];
        } else {
            visited[s->neighbors[i]->val] = (struct Node*)malloc(sizeof(struct Node));
            state[s->neighbors[i]->val] = 1;
            neighbor->neighbors[i] = visited[s->neighbors[i]->val];
        }
    }
    state[neighbor->val] = 2;
}

struct Node* cloneGraph(struct Node* s) {
    if (s == NULL) {
        return NULL;
    }

    // 将题目给定的节点添加到队列
    struct Node *QUEUE[101], *p;
    int head = -1, eneighbor = -1, i, flag[101];

    visited = (struct Node**)malloc(sizeof(struct Node*) * 101);
    memset(visited, 0, sizeof(struct Node*) * 101);
    state = (int*)malloc(sizeof(int) * 101);
    memset(state, 0, sizeof(int) * 101);
    memset(flag, 0, sizeof(int) * 101);

    // 克隆第一个节点并存储到哈希表中
    QUEUE[++eneighbor] = s;

    // 广度优先搜索
    while (head != eneighbor) {
        // 取出队列的头节点
        p = QUEUE[++head];
        // 遍历该节点的邻居
        bfs(p);
        for (i = 0; i < p->numNeighbors; i++) {
            if (!flag[p->neighbors[i]->val]) {
                // 将邻居节点加入队列中
                QUEUE[++eneighbor] = p->neighbors[i];
                flag[p->neighbors[i]->val] = 1;
            }
        }
    }

    return visited[s->val];
}
```

```golang [sol2-Golang]
func cloneGraph(node *Node) *Node {
    if node == nil {
        return node
    }
    visited := map[*Node]*Node{}

    // 将题目给定的节点添加到队列
    queue := []*Node{node}
    // 克隆第一个节点并存储到哈希表中
    visited[node] = &Node{node.Val, []*Node{}}

    // 广度优先搜索
    for len(queue) > 0 {
        // 取出队列的头节点
        n := queue[0]
        // 遍历该节点的邻居
        queue = queue[1:]
        for _, neighbor := range n.Neighbors {
            if _, ok := visited[neighbor]; !ok {
                // 如果没有被访问过，就克隆并存储在哈希表中
                visited[neighbor] = &Node{neighbor.Val, []*Node{}}
                // 将邻居节点加入队列中
                queue = append(queue, neighbor)
            }
            // 更新当前节点的邻居列表
            visited[n].Neighbors = append(visited[n].Neighbors, visited[neighbor])
        }
    }
    return visited[node]
}
```

**复杂度分析**

* 时间复杂度：$O(N)$，其中 $N$ 表示节点数量。广度优先搜索遍历图的过程中每个节点只会被访问一次。

* 空间复杂度：$O(N)$。哈希表使用 $O(N)$ 的空间。广度优先搜索中的队列在最坏情况下会达到 $O(N)$ 的空间复杂度，因此总体空间复杂度为 $O(N)$。
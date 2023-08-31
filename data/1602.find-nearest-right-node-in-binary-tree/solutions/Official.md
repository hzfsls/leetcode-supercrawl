## [1602.找到二叉树中最近的右侧节点 中文官方题解](https://leetcode.cn/problems/find-nearest-right-node-in-binary-tree/solutions/100000/zhao-dao-er-cha-shu-zhong-zui-jin-de-you-nhad)
[TOC]


## 解决方案

---

#### 总览

 **DFS vs. BFS**

 对树进行遍历有两种方式：DFS（深度优先搜索）和 BFS（广度优先搜索）。以下是一个小总结

 ![image.png](https://pic.leetcode.cn/1692073704-AQJWzK-image.png){:width=800}

 BFS 按级遍历，而 DFS 则先遍历到叶子节点。

 ![dfs_bfs2.png](https://pic.leetcode.cn/1692073734-RQGmcd-dfs_bfs2.png){:width=800}

 > 要选择哪种方法，BFS 还是 DFS？

- 该问题是返回在同一级别的 `u` 右侧的最近节点， 所以在这里实现 BFS 是更自然的选择。
- DFS 和 BFS 的时间复杂度都是 $\mathcal{O}(N)$， 因为要访问所有节点。
- DFS 的空间复杂度是 $\mathcal{O}(H)$，BFS 的空间复杂度是 $\mathcal{O}(D)$， 其中 $H$ 是树的高度，$D$ 是树的直径。它们在最坏的情况下都导致 $\mathcal{O}(N)$ 的空间 （对于 DFS 来说是偏斜的树，对于 BFS 来说是完全二叉树）。

 这是个机会可以 熟悉用队列实现的三种不同的 BFS，方法 1 - 方法 3。

 如果你更倾向于在面试中使用 DFS，请查看方法 4。

 **BFS 实现**

 所有三种实现都用到了队列进行常规的 BFS ：

- 将根节点压入队列。
- 从 _左_ 弹出一个节点。
- 将 _左_ 子节点压入队列，然后将 _右_ 子节点压入。

 ![image.png](https://pic.leetcode.cn/1692077649-ReqsuO-image.png){:width=800}

 **三种 BFS 方法**

 区别是如何标识级别结束：

- 两个队列，一个用于前一级别，一个用于当前级别。
- 一个队列加一个哨兵来标记该级别的结束。
- 一个队列 + 测量级别大小。

---

#### 方法 1：BFS：两个队列

 让我们使用两个队列：一个用于当前级别，一个用于下一级。思想是一个接一个地从当前级别弹出节点，并将其子节点压入到下一级队列中。

 ![levels.png](https://pic.leetcode.cn/1692077686-eXHzsi-levels.png){:width=800}

 **算法**

- 初始化两个队列：一个用于当前级别，一个用于下一级。将 `root` 加入 `nextLevel` 队列。
- 当 `nextLevel` 队列不为空时：
  - 初始化当前级别：`currLevel = nextLevel`，并清空下一级 `nextLevel`。
  - 当当前级别队列不为空时：
    - 从当前级别队列中弹出一个节点。
    - 如果该节点是 `u`，则返回队列中的下一个节点。如果 `nextLevel` 队列中没有更多的节点，返回 `null`。
    - 将 _左_ 子节点和 _右_子节点按顺序添加到 `nextLevel` 队列中。

 **实现**

 ```C++ [slu1]
 class Solution {
public:
    TreeNode* findNearestRightNode(TreeNode* root, TreeNode* u) {
        if (root == nullptr) {
            return nullptr;
        }
        // 注意这里我们使用 deque 代替 queue
        // 因为 deque 提供了 clear() 方法，而 queue 没有
        deque<TreeNode*> next_level;
        next_level.push_back(root);

        while (!next_level.empty()) {
            // 为下一层准备
            deque<TreeNode*> curr_level(next_level);
            next_level.clear();

            while (!curr_level.empty()) {
                TreeNode* node = curr_level.front();
                curr_level.pop_front();

                if (node == u) {
                    return (curr_level.empty() ? nullptr : curr_level.front());
                }

                // 将当前级别的子节点添加到下一级别队列中
                if (node->left != nullptr) {
                    next_level.push_back(node->left);
                }
                if (node->right != nullptr) {
                    next_level.push_back(node->right);
                }
            }
        }
        return nullptr;
    }
};
 ```

 ```Java [slu1]
 class Solution {
    public TreeNode findNearestRightNode(TreeNode root, TreeNode u) {
        if (root == null) return null;

        ArrayDeque<TreeNode> nextLevel = new ArrayDeque() {{ offer(root); }};
        ArrayDeque<TreeNode> currLevel = new ArrayDeque();

        TreeNode node = null;
        while (!nextLevel.isEmpty()) {
            // 为下一层准备
            currLevel = nextLevel.clone();
            nextLevel.clear();

            while (!currLevel.isEmpty()) {
                node = currLevel.poll();

                if (node == u)
                    return currLevel.poll();

                // 将当前级别的子节点添加到下一级别队列中
                if (node.left != null)
                    nextLevel.offer(node.left);
                if (node.right != null)
                    nextLevel.offer(node.right);
            }
        }
        return null;
    }
}
 ```

 ```Python3 [slu1]
 class Solution:
    def findNearestRightNode(self, root: TreeNode, u: TreeNode) -> TreeNode:
        if root is None:
            return []

        next_level = deque([root,])
        while next_level:
            # prepare for the next level
            curr_level = next_level
            next_level = deque()

            while curr_level:
                node = curr_level.popleft()

                if node == u:
                    return curr_level.popleft() if curr_level else None
                # add child nodes of the current level
                # in the queue for the next level
                if node.left:
                    next_level.append(node.left)
                if node.right:
                    next_level.append(node.right)
 ```

 **时间复杂度分析**

 * 时间复杂度: $\mathcal{O}(N)$，因为需要访问每个节点。
 * 空间复杂度: $\mathcal{O}(D)$，用于保存队列，其中 $D$ 是树的直径。我们可以借用最后一级来估计队列的大小。这一级可能包含了达到 $N/2$ 的树节点，例如[完全二叉树](https://leetcode.cn/problems/count-complete-tree-nodes/)。

---

 #### 方法 2：BFS：一个队列+哨兵
 另一种方法是将所有节点压入一个队列中，并使用哨兵节点来分隔各级。一般来说，我们可以使用 `null` 作为哨兵节点。

 ![image.png](https://pic.leetcode.cn/1692077743-cohxqH-image.png){:width=400}

 首先初始化第一级：`root` + `null` 作为哨兵。一旦完成，就继续从左侧一个接一个地弹出节点，并将其子节点压入右侧。每次当前节点是 `null` 时就停止，因为这意味着我们达到了当前级别的结束。每停止一次，就有一个机会在队列中压入 null 节点作为哨兵，标记下一级的结束。

 **算法**

- 初始化队列，加入根节点。添加 `null` 哨兵节点来标记第一级别的结束。
- 初始化当前节点为 `root`。
- 当队列不为空时：
- 从队列中弹出当前节点 `curr = queue.poll()`。
- 如果此节点是 `u`，则返回队列中的下一个节点。如果队列中没有更多的节点，返回 `null`。
- 如果当前节点不为 `null`：
- 将 _左_ 子节点和 _右_ 子节点依次添加到队列中。
- 更新当前节点：`curr = queue.poll()`。
- 现在，当前节点是 null，即我们到达了当前级别的结束。  如果队列不为空，将 null 节点作为哨兵压入队列，用以标记下一级别的结束。

 **实现**

 注意 Java 中的 `ArrayDeque` 不支持 null 元素，因此在这里要使用的数据结构是 `LinkedList`。

 ```C++ [slu2]
 class Solution {
public:
    TreeNode* findNearestRightNode(TreeNode* root, TreeNode* u) {
        if (root == nullptr) {
            return nullptr;
        }

        queue<TreeNode*> q;
        q.push(root);
        q.push(nullptr);

        while (!q.empty()) {
            TreeNode* curr = q.front();
            q.pop();

            if (curr != nullptr) {
                // 如果是给定的节点
                if (curr == u) {
                    return q.front();
                }

                // 把孩子节点添加到队列中
                if (curr->left != nullptr) {
                    q.push(curr->left);
                }
                if (curr->right != nullptr) {
                    q.push(curr->right);
                }
            } else {
                // 添加一个哨兵表示一层的结束
                if (!q.empty()) {
                    q.push(nullptr);
                }
            }
        }
        return nullptr;
    }
};
 ```

 ```Java [slu2]
 class Solution {
    public TreeNode findNearestRightNode(TreeNode root, TreeNode u) {
        if (root == null) return null;

        Queue<TreeNode> queue = new LinkedList(){{ offer(root); offer(null); }};
        TreeNode curr = null;

        while (!queue.isEmpty()) {
            curr = queue.poll();

            if (curr != null) {
                // 如果是给定的节点
                if (curr == u)
                    return queue.poll();

                // 把孩子节点添加到队列中
                if (curr.left != null) {
                    queue.offer(curr.left);
                }
                if (curr.right != null) {
                    queue.offer(curr.right);
                }
            } else {
                // 添加一个哨兵表示一层的结束
                if (!queue.isEmpty())
                    queue.offer(null);
            }
        }
        return null;
    }
}
 ```

 ```Python3 [slu2]
 class Solution:
    def findNearestRightNode(self, root: TreeNode, u: TreeNode) -> TreeNode:
        if root is None:
            return None

        queue = deque([root, None,])
        while queue:
            curr = queue.popleft()

            # 如果是给定的节点
            if curr == u:
                return queue.popleft()

            if curr:
                # 把孩子节点添加到队列中
                if curr.left:
                    queue.append(curr.left)
                if curr.right:
                    queue.append(curr.right)
            else:
                # 添加一个哨兵表示一层的结束
                if queue:
                    queue.append(None)
 ```

 **时间复杂度分析**

 * 时间复杂度: $\mathcal{O}(N)$，因为需要访问每个节点。
 * 空间复杂度: $\mathcal{O}(D)$，用于保存队列，其中 $D$ 是树的直径。我们可以借用最后一级来估计队列的大小。这一级可能包含了达到 $N/2$ 的树节点，例如[完全二叉树](https://leetcode.cn/problems/count-complete-tree-nodes/)。 

---

 #### 方法 3：BFS：一个队列+级别大小测量

 而不是使用哨兵，我们可以记下当前级别的长度。

 ![image.png](https://pic.leetcode.cn/1692077796-rjvHJt-image.png){:width=400}

 **算法**

- 初始化队列，向其中添加根节点。
- 当队列不为空时：
- 写下当前级别的长度：`levelLength = queue.size()`。
- 对 `i` 迭代从 `0` 到 `level_length - 1` ：
- 从队列中弹出当前节点：`node = queue.poll()`。
- 如果该节点是 `u`，则返回队列中的下一个节点。  确认下一个节点在同一级别：`i != levelLength - 1`，否则返回 `null`。
- 将 _左_ 子节点和 _右_ 子节点依次添加到队列中。

 **实现**

 ```C++ [slu3]
 class Solution {
public:
    TreeNode* findNearestRightNode(TreeNode* root, TreeNode* u) {
        queue<TreeNode*> q;
        q.push(root);

        while (!q.empty()) {
            size_t level_size = q.size();
            for (size_t i = 0; i < level_size; i++) {
                TreeNode* curr = q.front();
                q.pop();
                // 如果是给定的点
                if (curr == u) {
                    if (i == level_size - 1) {
                        return nullptr;
                    } else {
                        return q.front();
                    }
                }

                if (curr->left != nullptr) {
                    q.push(curr->left);
                }
                if (curr->right != nullptr) {
                    q.push(curr->right);
                }
            }
        }
        return nullptr;
    }
};
 ```

 ```Java [slu3]
 class Solution {
    public TreeNode findNearestRightNode(TreeNode root, TreeNode u) {
        if (root == null) return null;

        Queue<TreeNode> queue = new LinkedList<>();
        queue.offer(root);

        while (!queue.isEmpty()) {
            int levelSize = queue.size();
            for (int i = 0; i < levelSize; i++) {
                TreeNode curr = queue.poll();
                // 如果是给定的点
                if (curr == u) {
                    if (i == levelSize - 1) {
                        return null;
                    }
                    else {
                        return queue.poll();
                    }
                }

                if (curr.left != null) queue.offer(curr.left);
                if (curr.right != null) queue.offer(curr.right);
            }
        }
        return null;
    }
}
 ```

 ```Python3 [slu3]
 class Solution:
    def findNearestRightNode(self, root: TreeNode, u: TreeNode) -> TreeNode:
        if root is None:
            return None

        queue = deque([root,])
        while queue:
            level_length = len(queue)

            for i in range(level_length):
                node = queue.popleft()
                # 如果是给定的点
                if node == u:
                    return queue.popleft() if i != level_length - 1 else None

                # 把孩子节点加入队列
                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)
 ```
 **时间复杂度分析**

 * 时间复杂度: $\mathcal{O}(N)$，因为需要访问每个节点。
 * 空间复杂度: $\mathcal{O}(D)$，用于保存队列，其中 $D$ 是树的直径。我们可以借用最后一级来估计队列的大小。这一级可能包含了达到 $N/2$ 的树节点，例如[完全二叉树](https://leetcode.cn/problems/count-complete-tree-nodes/)。

---

 #### 方法 4：递归 DFS：前序遍历

 每个人都喜欢递归 DFS，因为它的简单明了，下面我们也用 DFS 来实现一次。思路直截了当：从最左侧的子节点开始执行标准的前序遍历。

 **实现**

 ```C++ [slu4]
 class Solution {
private:
    int u_depth;
    TreeNode* next_node;
    TreeNode* target_node;

public:
    TreeNode* findNearestRightNode(TreeNode* root, TreeNode* u) {
        this->u_depth = -1;
        this->target_node = u;
        this->next_node = nullptr;
        dfs(root, 0);
        return this->next_node;
    }

    void dfs(TreeNode* curr_node, int depth) {
        // 标识要寻找下一个节点的深度
        if (curr_node == this->target_node) {
            this->u_depth = depth;
            return;
        }

        // 我们已经到了寻找下一个节点的层次
        if (depth == this->u_depth) {
            if (this->next_node == nullptr) {
                this->next_node = curr_node;
            }
            return;
        }

        // 继续遍历树
        if (curr_node->left != nullptr) {
            dfs(curr_node->left, depth + 1);
        }
        if (curr_node->right != nullptr) {
            dfs(curr_node->right, depth + 1);
        }
    }
};
 ```

 ```Java [slu4]
 class Solution {

    private int uDepth;
    private TreeNode nextNode, targetNode;

    public TreeNode findNearestRightNode(TreeNode root, TreeNode u) {
        uDepth = - 1;
        targetNode = u;
        nextNode = null;
        dfs(root, 0);
        return nextNode;
    }

    public void dfs(TreeNode currNode, int depth) {
        // 标识要寻找下一个节点的深度
        if (currNode == targetNode) {
            uDepth = depth;
            return;
        }

        // 我们已经到了寻找下一个节点的层次
        if (depth == uDepth) {
            if (nextNode == null) nextNode = currNode;
            return;
        }

        // 继续遍历树
        if (currNode.left != null) dfs(currNode.left, depth + 1);
        if (currNode.right != null) dfs(currNode.right, depth + 1);
    }
}
 ```

```Python3 [slu4]
class Solution:
    def findNearestRightNode(self, root: TreeNode, u: TreeNode) -> TreeNode:
        def dfs(current_node, depth):
            nonlocal u_depth, next_node
            # 标识要寻找下一个节点的深度
            if current_node == u:
                u_depth = depth
                return
            # 我们已经到了寻找下一个节点的层次
            if depth == u_depth:
                # if this next node is not identified yet
                if next_node is None:
                    next_node = current_node
                return
            # 继续遍历树
            if current_node.left:
                dfs(current_node.left, depth + 1)
            if current_node.right:
                dfs(current_node.right, depth + 1)

        u_depth, next_node = -1, None
        dfs(root, 0)
        return next_node
```

 **时间复杂度分析**

 * 时间复杂度: $\mathcal{O}(N)$，因为需要访问每个节点。
 * 空间复杂度: $\mathcal{O}(H)$，用于保存递归栈，其中 $H$ 是树的高度。最坏的情况是倾斜的树，即 $H = N$。
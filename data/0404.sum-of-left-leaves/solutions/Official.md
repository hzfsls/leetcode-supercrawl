## [404.左叶子之和 中文官方题解](https://leetcode.cn/problems/sum-of-left-leaves/solutions/100000/zuo-xie-zi-zhi-he-by-leetcode-solution)
#### 前言

一个节点为「左叶子」节点，当且仅当它是某个节点的左子节点，并且它是一个叶子结点。因此我们可以考虑对整棵树进行遍历，当我们遍历到节点 $\textit{node}$ 时，如果它的左子节点是一个叶子结点，那么就将它的左子节点的值累加计入答案。

遍历整棵树的方法有深度优先搜索和广度优先搜索，下面分别给出了实现代码。

#### 方法一：深度优先搜索

```C++ [sol1-C++]
class Solution {
public:
    bool isLeafNode(TreeNode* node) {
        return !node->left && !node->right;
    }

    int dfs(TreeNode* node) {
        int ans = 0;
        if (node->left) {
            ans += isLeafNode(node->left) ? node->left->val : dfs(node->left);
        }
        if (node->right && !isLeafNode(node->right)) {
            ans += dfs(node->right);
        }
        return ans;
    }

    int sumOfLeftLeaves(TreeNode* root) {
        return root ? dfs(root) : 0;
    }
};
```

```Java [sol1-Java]
class Solution {
    public int sumOfLeftLeaves(TreeNode root) {
        return root != null ? dfs(root) : 0;
    }

    public int dfs(TreeNode node) {
        int ans = 0;
        if (node.left != null) {
            ans += isLeafNode(node.left) ? node.left.val : dfs(node.left);
        }
        if (node.right != null && !isLeafNode(node.right)) {
            ans += dfs(node.right);
        }
        return ans;
    }

    public boolean isLeafNode(TreeNode node) {
        return node.left == null && node.right == null;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def sumOfLeftLeaves(self, root: TreeNode) -> int:
        isLeafNode = lambda node: not node.left and not node.right

        def dfs(node: TreeNode) -> int:
            ans = 0
            if node.left:
                ans += node.left.val if isLeafNode(node.left) else dfs(node.left)
            if node.right and not isLeafNode(node.right):
                ans += dfs(node.right)
            return ans
        
        return dfs(root) if root else 0
```

```Golang [sol1-Golang]
func isLeafNode(node *TreeNode) bool {
    return node.Left == nil && node.Right == nil
}

func dfs(node *TreeNode) (ans int) {
    if node.Left != nil {
        if isLeafNode(node.Left) {
            ans += node.Left.Val
        } else {
            ans += dfs(node.Left)
        }
    }
    if node.Right != nil && !isLeafNode(node.Right) {
        ans += dfs(node.Right)
    }
    return
}

func sumOfLeftLeaves(root *TreeNode) int {
    if root == nil {
        return 0
    }
    return dfs(root)
}
```

```C [sol1-C]
bool isLeafNode(struct TreeNode *node) {
    return !node->left && !node->right;
}

int dfs(struct TreeNode *node) {
    int ans = 0;
    if (node->left) {
        ans += isLeafNode(node->left) ? node->left->val : dfs(node->left);
    }
    if (node->right && !isLeafNode(node->right)) {
        ans += dfs(node->right);
    }
    return ans;
}

int sumOfLeftLeaves(struct TreeNode *root) {
    return root ? dfs(root) : 0;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是树中的节点个数。

- 空间复杂度：$O(n)$。空间复杂度与深度优先搜索使用的栈的最大深度相关。在最坏的情况下，树呈现链式结构，深度为 $O(n)$，对应的空间复杂度也为 $O(n)$。

#### 方法二：广度优先搜索

```C++ [sol2-C++]
class Solution {
public:
    bool isLeafNode(TreeNode* node) {
        return !node->left && !node->right;
    }

    int sumOfLeftLeaves(TreeNode* root) {
        if (!root) {
            return 0;
        }

        queue<TreeNode*> q;
        q.push(root);
        int ans = 0;
        while (!q.empty()) {
            TreeNode* node = q.front();
            q.pop();
            if (node->left) {
                if (isLeafNode(node->left)) {
                    ans += node->left->val;
                }
                else {
                    q.push(node->left);
                }
            }
            if (node->right) {
                if (!isLeafNode(node->right)) {
                    q.push(node->right);
                }
            }
        }
        return ans;
    }
};
```

```C++ [sol2-C++17]
class Solution {
public:
    bool isLeafNode(TreeNode* node) {
        return !node->left && !node->right;
    }

    int sumOfLeftLeaves(TreeNode* root) {
        if (!root) {
            return 0;
        }

        queue q{deque{root}};
        int ans = 0;
        while (!q.empty()) {
            TreeNode* node = q.front();
            q.pop();
            if (node->left) {
                if (isLeafNode(node->left)) {
                    ans += node->left->val;
                }
                else {
                    q.push(node->left);
                }
            }
            if (node->right) {
                if (!isLeafNode(node->right)) {
                    q.push(node->right);
                }
            }
        }
        return ans;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int sumOfLeftLeaves(TreeNode root) {
        if (root == null) {
            return 0;
        }

        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        queue.offer(root);
        int ans = 0;
        while (!queue.isEmpty()) {
            TreeNode node = queue.poll();
            if (node.left != null) {
                if (isLeafNode(node.left)) {
                    ans += node.left.val;
                } else {
                    queue.offer(node.left);
                }
            }
            if (node.right != null) {
                if (!isLeafNode(node.right)) {
                    queue.offer(node.right);
                }
            }
        }
        return ans;
    }

    public boolean isLeafNode(TreeNode node) {
        return node.left == null && node.right == null;
    }
}
```

```Python [sol2-Python3]
class Solution:
    def sumOfLeftLeaves(self, root: TreeNode) -> int:
        if not root:
            return 0
        
        isLeafNode = lambda node: not node.left and not node.right
        q = collections.deque([root])
        ans = 0

        while q:
            node = q.popleft()
            if node.left:
                if isLeafNode(node.left):
                    ans += node.left.val
                else:
                    q.append(node.left)
            if node.right:
                if not isLeafNode(node.right):
                    q.append(node.right)
        
        return ans
```

```Golang [sol2-Golang]
func isLeafNode(node *TreeNode) bool {
    return node.Left == nil && node.Right == nil
}

func sumOfLeftLeaves(root *TreeNode) (ans int) {
    if root == nil {
        return
    }
    q := []*TreeNode{root}
    for len(q) > 0 {
        node := q[0]
        q = q[1:]
        if node.Left != nil {
            if isLeafNode(node.Left) {
                ans += node.Left.Val
            } else {
                q = append(q, node.Left)
            }
        }
        if node.Right != nil && !isLeafNode(node.Right) {
            q = append(q, node.Right)
        }
    }
    return
}
```

```C [sol2-C]
bool isLeafNode(struct TreeNode *node) {
    return !node->left && !node->right;
}

int sumOfLeftLeaves(struct TreeNode *root) {
    if (!root) {
        return 0;
    }
    struct TreeNode **q = malloc(sizeof(struct TreeNode *) * 2001);
    int left = 0, right = 0;
    q[right++] = root;
    int ans = 0;
    while (left < right) {
        struct TreeNode *node = q[left++];
        if (node->left) {
            if (isLeafNode(node->left)) {
                ans += node->left->val;
            } else {
                q[right++] = node->left;
            }
        }
        if (node->right) {
            if (!isLeafNode(node->right)) {
                q[right++] = node->right;
            }
        }
    }
    return ans;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是树中的节点个数。

- 空间复杂度：$O(n)$。空间复杂度与广度优先搜索使用的队列需要的容量相关，为 $O(n)$。
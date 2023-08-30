#### 方法一：深度优先搜索

可以使用深度优先搜索合并两个二叉树。从根节点开始同时遍历两个二叉树，并将对应的节点进行合并。

两个二叉树的对应节点可能存在以下三种情况，对于每种情况使用不同的合并方式。

- 如果两个二叉树的对应节点都为空，则合并后的二叉树的对应节点也为空；

- 如果两个二叉树的对应节点只有一个为空，则合并后的二叉树的对应节点为其中的非空节点；

- 如果两个二叉树的对应节点都不为空，则合并后的二叉树的对应节点的值为两个二叉树的对应节点的值之和，此时需要显性合并两个节点。

对一个节点进行合并之后，还要对该节点的左右子树分别进行合并。这是一个递归的过程。

<![ppt1](https://assets.leetcode-cn.com/solution-static/617/1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/617/2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/617/3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/617/4.png),![ppt5](https://assets.leetcode-cn.com/solution-static/617/5.png),![ppt6](https://assets.leetcode-cn.com/solution-static/617/6.png),![ppt7](https://assets.leetcode-cn.com/solution-static/617/7.png),![ppt8](https://assets.leetcode-cn.com/solution-static/617/8.png),![ppt9](https://assets.leetcode-cn.com/solution-static/617/9.png),![ppt10](https://assets.leetcode-cn.com/solution-static/617/10.png),![ppt11](https://assets.leetcode-cn.com/solution-static/617/11.png),![ppt12](https://assets.leetcode-cn.com/solution-static/617/12.png),![ppt13](https://assets.leetcode-cn.com/solution-static/617/13.png),![ppt14](https://assets.leetcode-cn.com/solution-static/617/14.png),![ppt15](https://assets.leetcode-cn.com/solution-static/617/15.png)>

```Java [sol1-Java]
class Solution {
    public TreeNode mergeTrees(TreeNode t1, TreeNode t2) {
        if (t1 == null) {
            return t2;
        }
        if (t2 == null) {
            return t1;
        }
        TreeNode merged = new TreeNode(t1.val + t2.val);
        merged.left = mergeTrees(t1.left, t2.left);
        merged.right = mergeTrees(t1.right, t2.right);
        return merged;
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    TreeNode* mergeTrees(TreeNode* t1, TreeNode* t2) {
        if (t1 == nullptr) {
            return t2;
        }
        if (t2 == nullptr) {
            return t1;
        }
        auto merged = new TreeNode(t1->val + t2->val);
        merged->left = mergeTrees(t1->left, t2->left);
        merged->right = mergeTrees(t1->right, t2->right);
        return merged;
    }
};
```

```Golang [sol1-Golang]
func mergeTrees(t1, t2 *TreeNode) *TreeNode {
    if t1 == nil {
        return t2
    }
    if t2 == nil {
        return t1
    }
    t1.Val += t2.Val
    t1.Left = mergeTrees(t1.Left, t2.Left)
    t1.Right = mergeTrees(t1.Right, t2.Right)
    return t1
}
```

```C [sol1-C]
struct TreeNode* mergeTrees(struct TreeNode* t1, struct TreeNode* t2) {
    if (t1 == NULL) {
        return t2;
    }
    if (t2 == NULL) {
        return t1;
    }
    struct TreeNode* merged = malloc(sizeof(struct TreeNode));
    merged->val = t1->val + t2->val;
    merged->left = mergeTrees(t1->left, t2->left);
    merged->right = mergeTrees(t1->right, t2->right);
    return merged;
}
```

```Python [sol1-Python3]
class Solution:
    def mergeTrees(self, t1: TreeNode, t2: TreeNode) -> TreeNode:
        if not t1:
            return t2
        if not t2:
            return t1
        
        merged = TreeNode(t1.val + t2.val)
        merged.left = self.mergeTrees(t1.left, t2.left)
        merged.right = self.mergeTrees(t1.right, t2.right)
        return merged
```

**复杂度分析**

- 时间复杂度：$O(\min(m,n))$，其中 $m$ 和 $n$ 分别是两个二叉树的节点个数。对两个二叉树同时进行深度优先搜索，只有当两个二叉树中的对应节点都不为空时才会对该节点进行显性合并操作，因此被访问到的节点数不会超过较小的二叉树的节点数。

- 空间复杂度：$O(\min(m,n))$，其中 $m$ 和 $n$ 分别是两个二叉树的节点个数。空间复杂度取决于递归调用的层数，递归调用的层数不会超过较小的二叉树的最大高度，最坏情况下，二叉树的高度等于节点数。

#### 方法二：广度优先搜索

也可以使用广度优先搜索合并两个二叉树。首先判断两个二叉树是否为空，如果两个二叉树都为空，则合并后的二叉树也为空，如果只有一个二叉树为空，则合并后的二叉树为另一个非空的二叉树。

如果两个二叉树都不为空，则首先计算合并后的根节点的值，然后从合并后的二叉树与两个原始二叉树的根节点开始广度优先搜索，从根节点开始同时遍历每个二叉树，并将对应的节点进行合并。

使用三个队列分别存储合并后的二叉树的节点以及两个原始二叉树的节点。初始时将每个二叉树的根节点分别加入相应的队列。每次从每个队列中取出一个节点，判断两个原始二叉树的节点的左右子节点是否为空。如果两个原始二叉树的当前节点中至少有一个节点的左子节点不为空，则合并后的二叉树的对应节点的左子节点也不为空。对于右子节点同理。

如果合并后的二叉树的左子节点不为空，则需要根据两个原始二叉树的左子节点计算合并后的二叉树的左子节点以及整个左子树。考虑以下两种情况：

- 如果两个原始二叉树的左子节点都不为空，则合并后的二叉树的左子节点的值为两个原始二叉树的左子节点的值之和，在创建合并后的二叉树的左子节点之后，将每个二叉树中的左子节点都加入相应的队列；

- 如果两个原始二叉树的左子节点有一个为空，即有一个原始二叉树的左子树为空，则合并后的二叉树的左子树即为另一个原始二叉树的左子树，此时也不需要对非空左子树继续遍历，因此不需要将左子节点加入队列。

对于右子节点和右子树，处理方法与左子节点和左子树相同。

<![fig1](https://assets.leetcode-cn.com/solution-static/617/2_1.png),![fig2](https://assets.leetcode-cn.com/solution-static/617/2_2.png),![fig3](https://assets.leetcode-cn.com/solution-static/617/2_3.png),![fig4](https://assets.leetcode-cn.com/solution-static/617/2_4.png),![fig5](https://assets.leetcode-cn.com/solution-static/617/2_5.png),![fig6](https://assets.leetcode-cn.com/solution-static/617/2_6.png),![fig7](https://assets.leetcode-cn.com/solution-static/617/2_7.png),![fig8](https://assets.leetcode-cn.com/solution-static/617/2_8.png),![fig9](https://assets.leetcode-cn.com/solution-static/617/2_9.png),![fig10](https://assets.leetcode-cn.com/solution-static/617/2_10.png),![fig11](https://assets.leetcode-cn.com/solution-static/617/2_11.png),![fig12](https://assets.leetcode-cn.com/solution-static/617/2_12.png),![fig13](https://assets.leetcode-cn.com/solution-static/617/2_13.png)>

```Java [sol2-Java]
class Solution {
    public TreeNode mergeTrees(TreeNode t1, TreeNode t2) {
        if (t1 == null) {
            return t2;
        }
        if (t2 == null) {
            return t1;
        }
        TreeNode merged = new TreeNode(t1.val + t2.val);
        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        Queue<TreeNode> queue1 = new LinkedList<TreeNode>();
        Queue<TreeNode> queue2 = new LinkedList<TreeNode>();
        queue.offer(merged);
        queue1.offer(t1);
        queue2.offer(t2);
        while (!queue1.isEmpty() && !queue2.isEmpty()) {
            TreeNode node = queue.poll(), node1 = queue1.poll(), node2 = queue2.poll();
            TreeNode left1 = node1.left, left2 = node2.left, right1 = node1.right, right2 = node2.right;
            if (left1 != null || left2 != null) {
                if (left1 != null && left2 != null) {
                    TreeNode left = new TreeNode(left1.val + left2.val);
                    node.left = left;
                    queue.offer(left);
                    queue1.offer(left1);
                    queue2.offer(left2);
                } else if (left1 != null) {
                    node.left = left1;
                } else if (left2 != null) {
                    node.left = left2;
                }
            }
            if (right1 != null || right2 != null) {
                if (right1 != null && right2 != null) {
                    TreeNode right = new TreeNode(right1.val + right2.val);
                    node.right = right;
                    queue.offer(right);
                    queue1.offer(right1);
                    queue2.offer(right2);
                } else if (right1 != null) {
                    node.right = right1;
                } else {
                    node.right = right2;
                }
            }
        }
        return merged;
    }
}
```

```cpp [sol2-C++]
class Solution {
public:
    TreeNode* mergeTrees(TreeNode* t1, TreeNode* t2) {
        if (t1 == nullptr) {
            return t2;
        }
        if (t2 == nullptr) {
            return t1;
        }
        auto merged = new TreeNode(t1->val + t2->val);
        auto q = queue<TreeNode*>();
        auto queue1 = queue<TreeNode*>();
        auto queue2 = queue<TreeNode*>();
        q.push(merged);
        queue1.push(t1);
        queue2.push(t2);
        while (!queue1.empty() && !queue2.empty()) {
            auto node = q.front(), node1 = queue1.front(), node2 = queue2.front();
            q.pop();
            queue1.pop();
            queue2.pop();
            auto left1 = node1->left, left2 = node2->left, right1 = node1->right, right2 = node2->right;
            if (left1 != nullptr || left2 != nullptr) {
                if (left1 != nullptr && left2 != nullptr) {
                    auto left = new TreeNode(left1->val + left2->val);
                    node->left = left;
                    q.push(left);
                    queue1.push(left1);
                    queue2.push(left2);
                } else if (left1 != nullptr) {
                    node->left = left1;
                } else if (left2 != nullptr) {
                    node->left = left2;
                }
            }
            if (right1 != nullptr || right2 != nullptr) {
                if (right1 != nullptr && right2 != nullptr) {
                    auto right = new TreeNode(right1->val + right2->val);
                    node->right = right;
                    q.push(right);
                    queue1.push(right1);
                    queue2.push(right2);
                } else if (right1 != nullptr) {
                    node->right = right1;
                } else {
                    node->right = right2;
                }
            }
        }
        return merged;
    }
};
```

```Golang [sol2-Golang]
func mergeTrees(t1, t2 *TreeNode) *TreeNode {
    if t1 == nil {
        return t2
    }
    if t2 == nil {
        return t1
    }
    merged := &TreeNode{Val: t1.Val + t2.Val}
    queue := []*TreeNode{merged}
    queue1 := []*TreeNode{t1}
    queue2 := []*TreeNode{t2}
    for len(queue1) > 0 && len(queue2) > 0 {
        node := queue[0]
        queue = queue[1:]
        node1 := queue1[0]
        queue1 = queue1[1:]
        node2 := queue2[0]
        queue2 = queue2[1:]
        left1, right1 := node1.Left, node1.Right
        left2, right2 := node2.Left, node2.Right
        if left1 != nil || left2 != nil {
            if left1 != nil && left2 != nil {
                left := &TreeNode{Val: left1.Val + left2.Val}
                node.Left = left
                queue = append(queue, left)
                queue1 = append(queue1, left1)
                queue2 = append(queue2, left2)
            } else if left1 != nil {
                node.Left = left1
            } else { // left2 != nil
                node.Left = left2
            }
        }
        if right1 != nil || right2 != nil {
            if right1 != nil && right2 != nil {
                right := &TreeNode{Val: right1.Val + right2.Val}
                node.Right = right
                queue = append(queue, right)
                queue1 = append(queue1, right1)
                queue2 = append(queue2, right2)
            } else if right1 != nil {
                node.Right = right1
            } else { // right2 != nil
                node.Right = right2
            }
        }
    }
    return merged
}
```

```C [sol2-C]
struct TreeNode* mergeTrees(struct TreeNode* t1, struct TreeNode* t2) {
    if (t1 == NULL) {
        return t2;
    }
    if (t2 == NULL) {
        return t1;
    }
    struct TreeNode* merged = malloc(sizeof(struct TreeNode));
    merged->val = t1->val + t2->val;
    struct TreeNode** q = malloc(sizeof(struct TreeNode*) * 2001);
    struct TreeNode** queue1 = malloc(sizeof(struct TreeNode*) * 2001);
    struct TreeNode** queue2 = malloc(sizeof(struct TreeNode*) * 2001);
    int qleft = 0, qright = 0;
    q[qright] = merged;
    queue1[qright] = t1;
    queue2[qright] = t2;
    qright++;
    while (qleft < qright) {
        struct TreeNode *node = q[qleft], *node1 = queue1[qleft], *node2 = queue2[qleft];
        qleft++;
        struct TreeNode *left1 = node1->left, *left2 = node2->left, *right1 = node1->right, *right2 = node2->right;
        if (left1 != NULL || left2 != NULL) {
            if (left1 != NULL && left2 != NULL) {
                struct TreeNode* left = malloc(sizeof(struct TreeNode));
                left->val = left1->val + left2->val;
                node->left = left;
                q[qright] = left;
                queue1[qright] = left1;
                queue2[qright] = left2;
                qright++;
            } else if (left1 != NULL) {
                node->left = left1;
            } else if (left2 != NULL) {
                node->left = left2;
            }
        } else {
            node->left = NULL;
        }
        if (right1 != NULL || right2 != NULL) {
            if (right1 != NULL && right2 != NULL) {
                struct TreeNode* right = malloc(sizeof(struct TreeNode));
                right->val = right1->val + right2->val;
                node->right = right;
                q[qright] = right;
                queue1[qright] = right1;
                queue2[qright] = right2;
                qright++;
            } else if (right1 != NULL) {
                node->right = right1;
            } else {
                node->right = right2;
            }
        } else {
            node->right = NULL;
        }
    }
    return merged;
}
```

```Python [sol2-Python3]
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def mergeTrees(self, t1: TreeNode, t2: TreeNode) -> TreeNode:
        if not t1:
            return t2
        if not t2:
            return t1
        
        merged = TreeNode(t1.val + t2.val)
        queue = collections.deque([merged])
        queue1 = collections.deque([t1])
        queue2 = collections.deque([t2])

        while queue1 and queue2:
            node = queue.popleft()
            node1 = queue1.popleft()
            node2 = queue2.popleft()
            left1, right1 = node1.left, node1.right
            left2, right2 = node2.left, node2.right
            if left1 or left2:
                if left1 and left2:
                    left = TreeNode(left1.val + left2.val)
                    node.left = left
                    queue.append(left)
                    queue1.append(left1)
                    queue2.append(left2)
                elif left1:
                    node.left = left1
                elif left2:
                    node.left = left2
            if right1 or right2:
                if right1 and right2:
                    right = TreeNode(right1.val + right2.val)
                    node.right = right
                    queue.append(right)
                    queue1.append(right1)
                    queue2.append(right2)
                elif right1:
                    node.right = right1
                elif right2:
                    node.right = right2
        
        return merged
```

**复杂度分析**

- 时间复杂度：$O(\min(m,n))$，其中 $m$ 和 $n$ 分别是两个二叉树的节点个数。对两个二叉树同时进行广度优先搜索，只有当两个二叉树中的对应节点都不为空时才会访问到该节点，因此被访问到的节点数不会超过较小的二叉树的节点数。

- 空间复杂度：$O(\min(m,n))$，其中 $m$ 和 $n$ 分别是两个二叉树的节点个数。空间复杂度取决于队列中的元素个数，队列中的元素个数不会超过较小的二叉树的节点数。
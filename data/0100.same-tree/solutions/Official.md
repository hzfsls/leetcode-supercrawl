## [100.相同的树 中文官方题解](https://leetcode.cn/problems/same-tree/solutions/100000/xiang-tong-de-shu-by-leetcode-solution)
#### 前言

两个二叉树相同，当且仅当两个二叉树的结构完全相同，且所有对应节点的值相同。因此，可以通过搜索的方式判断两个二叉树是否相同。

#### 方法一：深度优先搜索

如果两个二叉树都为空，则两个二叉树相同。如果两个二叉树中有且只有一个为空，则两个二叉树一定不相同。

如果两个二叉树都不为空，那么首先判断它们的根节点的值是否相同，若不相同则两个二叉树一定不同，若相同，再分别判断两个二叉树的左子树是否相同以及右子树是否相同。这是一个递归的过程，因此可以使用深度优先搜索，递归地判断两个二叉树是否相同。

<![fig1](https://assets.leetcode-cn.com/solution-static/100/1.png),![fig2](https://assets.leetcode-cn.com/solution-static/100/2.png),![fig3](https://assets.leetcode-cn.com/solution-static/100/3.png),![fig4](https://assets.leetcode-cn.com/solution-static/100/4.png),![fig5](https://assets.leetcode-cn.com/solution-static/100/5.png),![fig6](https://assets.leetcode-cn.com/solution-static/100/6.png)>

```Java [sol1-Java]
class Solution {
    public boolean isSameTree(TreeNode p, TreeNode q) {
        if (p == null && q == null) {
            return true;
        } else if (p == null || q == null) {
            return false;
        } else if (p.val != q.val) {
            return false;
        } else {
            return isSameTree(p.left, q.left) && isSameTree(p.right, q.right);
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isSameTree(self, p: TreeNode, q: TreeNode) -> bool:
        if not p and not q:
            return True
        elif not p or not q:
            return False
        elif p.val != q.val:
            return False
        else:
            return self.isSameTree(p.left, q.left) and self.isSameTree(p.right, q.right)
```

```cpp [sol1-C++]
class Solution {
public:
    bool isSameTree(TreeNode* p, TreeNode* q) {
        if (p == nullptr && q == nullptr) {
            return true;
        } else if (p == nullptr || q == nullptr) {
            return false;
        } else if (p->val != q->val) {
            return false;
        } else {
            return isSameTree(p->left, q->left) && isSameTree(p->right, q->right);
        }
    }
};
```

```C [sol1-C]
bool isSameTree(struct TreeNode* p, struct TreeNode* q) {
    if (p == NULL && q == NULL) {
        return true;
    } else if (p == NULL || q == NULL) {
        return false;
    } else if (p->val != q->val) {
        return false;
    } else {
        return isSameTree(p->left, q->left) && isSameTree(p->right, q->right);
    }
}
```

```golang [sol1-Golang]
func isSameTree(p *TreeNode, q *TreeNode) bool {
    if p == nil && q == nil {
        return true
    }
    if p == nil || q == nil {
        return false
    }
    if p.Val != q.Val {
        return false
    }
    return isSameTree(p.Left, q.Left) && isSameTree(p.Right, q.Right)
}
```

**复杂度分析**

- 时间复杂度：$O(\min(m,n))$，其中 $m$ 和 $n$ 分别是两个二叉树的节点数。对两个二叉树同时进行深度优先搜索，只有当两个二叉树中的对应节点都不为空时才会访问到该节点，因此被访问到的节点数不会超过较小的二叉树的节点数。

- 空间复杂度：$O(\min(m,n))$，其中 $m$ 和 $n$ 分别是两个二叉树的节点数。空间复杂度取决于递归调用的层数，递归调用的层数不会超过较小的二叉树的最大高度，最坏情况下，二叉树的高度等于节点数。

#### 方法二：广度优先搜索

也可以通过广度优先搜索判断两个二叉树是否相同。同样首先判断两个二叉树是否为空，如果两个二叉树都不为空，则从两个二叉树的根节点开始广度优先搜索。

使用两个队列分别存储两个二叉树的节点。初始时将两个二叉树的根节点分别加入两个队列。每次从两个队列各取出一个节点，进行如下比较操作。

1. 比较两个节点的值，如果两个节点的值不相同则两个二叉树一定不同；

2. 如果两个节点的值相同，则判断两个节点的子节点是否为空，如果只有一个节点的左子节点为空，或者只有一个节点的右子节点为空，则两个二叉树的结构不同，因此两个二叉树一定不同；

3. 如果两个节点的子节点的结构相同，则将两个节点的非空子节点分别加入两个队列，子节点加入队列时需要注意顺序，如果左右子节点都不为空，则先加入左子节点，后加入右子节点。

如果搜索结束时两个队列同时为空，则两个二叉树相同。如果只有一个队列为空，则两个二叉树的结构不同，因此两个二叉树不同。

```Java [sol2-Java]
class Solution {
    public boolean isSameTree(TreeNode p, TreeNode q) {
        if (p == null && q == null) {
            return true;
        } else if (p == null || q == null) {
            return false;
        }
        Queue<TreeNode> queue1 = new LinkedList<TreeNode>();
        Queue<TreeNode> queue2 = new LinkedList<TreeNode>();
        queue1.offer(p);
        queue2.offer(q);
        while (!queue1.isEmpty() && !queue2.isEmpty()) {
            TreeNode node1 = queue1.poll();
            TreeNode node2 = queue2.poll();
            if (node1.val != node2.val) {
                return false;
            }
            TreeNode left1 = node1.left, right1 = node1.right, left2 = node2.left, right2 = node2.right;
            if (left1 == null ^ left2 == null) {
                return false;
            }
            if (right1 == null ^ right2 == null) {
                return false;
            }
            if (left1 != null) {
                queue1.offer(left1);
            }
            if (right1 != null) {
                queue1.offer(right1);
            }
            if (left2 != null) {
                queue2.offer(left2);
            }
            if (right2 != null) {
                queue2.offer(right2);
            }
        }
        return queue1.isEmpty() && queue2.isEmpty();
    }
}
```

```Python [sol2-Python]
class Solution:
    def isSameTree(self, p: TreeNode, q: TreeNode) -> bool:
        if not p and not q:
            return True
        if not p or not q:
            return False
        
        queue1 = collections.deque([p])
        queue2 = collections.deque([q])

        while queue1 and queue2:
            node1 = queue1.popleft()
            node2 = queue2.popleft()
            if node1.val != node2.val:
                return False
            left1, right1 = node1.left, node1.right
            left2, right2 = node2.left, node2.right
            if (not left1) ^ (not left2):
                return False
            if (not right1) ^ (not right2):
                return False
            if left1:
                queue1.append(left1)
            if right1:
                queue1.append(right1)
            if left2:
                queue2.append(left2)
            if right2:
                queue2.append(right2)

        return not queue1 and not queue2
```

```cpp [sol2-C++]
class Solution {
public:
    bool isSameTree(TreeNode* p, TreeNode* q) {
        if (p == nullptr && q == nullptr) {
            return true;
        } else if (p == nullptr || q == nullptr) {
            return false;
        }
        queue <TreeNode*> queue1, queue2;
        queue1.push(p);
        queue2.push(q);
        while (!queue1.empty() && !queue2.empty()) {
            auto node1 = queue1.front();
            queue1.pop();
            auto node2 = queue2.front();
            queue2.pop();
            if (node1->val != node2->val) {
                return false;
            }
            auto left1 = node1->left, right1 = node1->right, left2 = node2->left, right2 = node2->right;
            if ((left1 == nullptr) ^ (left2 == nullptr)) {
                return false;
            }
            if ((right1 == nullptr) ^ (right2 == nullptr)) {
                return false;
            }
            if (left1 != nullptr) {
                queue1.push(left1);
            }
            if (right1 != nullptr) {
                queue1.push(right1);
            }
            if (left2 != nullptr) {
                queue2.push(left2);
            }
            if (right2 != nullptr) {
                queue2.push(right2);
            }
        }
        return queue1.empty() && queue2.empty();
    }
};
```

```C [sol2-C]
bool isSameTree(struct TreeNode* p, struct TreeNode* q) {
    if (p == NULL && q == NULL) {
        return true;
    } else if (p == NULL || q == NULL) {
        return false;
    }
    struct TreeNode** que1 = (struct TreeNode**)malloc(sizeof(struct TreeNode*));
    struct TreeNode** que2 = (struct TreeNode**)malloc(sizeof(struct TreeNode*));
    int queleft1 = 0, queright1 = 0;
    int queleft2 = 0, queright2 = 0;
    que1[queright1++] = p;
    que2[queright2++] = q;
    while (queleft1 < queright1 && queleft2 < queright2) {
        struct TreeNode* node1 = que1[queleft1++];
        struct TreeNode* node2 = que2[queleft2++];
        if (node1->val != node2->val) {
            return false;
        }
        struct TreeNode* left1 = node1->left;
        struct TreeNode* right1 = node1->right;
        struct TreeNode* left2 = node2->left;
        struct TreeNode* right2 = node2->right;
        if ((left1 == NULL) ^ (left2 == NULL)) {
            return false;
        }
        if ((right1 == NULL) ^ (right2 == NULL)) {
            return false;
        }
        if (left1 != NULL) {
            queright1++;
            que1 = realloc(que1, sizeof(struct TreeNode*) * queright1);
            que1[queright1 - 1] = left1;
        }
        if (right1 != NULL) {
            queright1++;
            que1 = realloc(que1, sizeof(struct TreeNode*) * queright1);
            que1[queright1 - 1] = right1;
        }
        if (left2 != NULL) {
            queright2++;
            que2 = realloc(que2, sizeof(struct TreeNode*) * queright2);
            que2[queright2 - 1] = left2;
        }
        if (right2 != NULL) {
            queright2++;
            que2 = realloc(que2, sizeof(struct TreeNode*) * queright2);
            que2[queright2 - 1] = right2;
        }
    }
    return queleft1 == queright1 && queleft2 == queright2;
}
```

```golang [sol2-Golang]
func isSameTree(p *TreeNode, q *TreeNode) bool {
    if p == nil && q == nil {
        return true
    }
    if p == nil || q == nil {
        return false
    }
    queue1, queue2 := []*TreeNode{p}, []*TreeNode{q}
    for len(queue1) > 0 && len(queue2) > 0 {
        node1, node2 := queue1[0], queue2[0]
        queue1, queue2 = queue1[1:], queue2[1:]
        if node1.Val != node2.Val {
            return false
        }
        left1, right1 := node1.Left, node1.Right
        left2, right2 := node2.Left, node2.Right
        if (left1 == nil && left2 != nil) || (left1 != nil && left2 == nil) {
            return false
        }
        if (right1 == nil && right2 != nil) || (right1 != nil && right2 == nil) {
            return false
        }
        if left1 != nil {
            queue1 = append(queue1, left1)
        }
        if right1 != nil {
            queue1 = append(queue1, right1)
        }
        if left2 != nil {
            queue2 = append(queue2, left2)
        }
        if right2 != nil {
            queue2 = append(queue2, right2)
        }
    }
    return len(queue1) == 0 && len(queue2) == 0
}
```

**复杂度分析**

- 时间复杂度：$O(\min(m,n))$，其中 $m$ 和 $n$ 分别是两个二叉树的节点数。对两个二叉树同时进行广度优先搜索，只有当两个二叉树中的对应节点都不为空时才会访问到该节点，因此被访问到的节点数不会超过较小的二叉树的节点数。

- 空间复杂度：$O(\min(m,n))$，其中 $m$ 和 $n$ 分别是两个二叉树的节点数。空间复杂度取决于队列中的元素个数，队列中的元素个数不会超过较小的二叉树的节点数。
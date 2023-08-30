#### 方法一：模拟

**思路与算法**

首先回顾二叉搜索树的性质：对于任意节点 $\textit{root}$ 而言，左子树（如果存在）上所有节点的值均小于 $\textit{root.val}$，右子树（如果存在）上所有节点的值均大于 $\textit{root.val}$，且它们都是二叉搜索树。

因此，当将 $\textit{val}$ 插入到以 $\textit{root}$ 为根的子树上时，根据  $\textit{val}$ 与 $\textit{root.val}$ 的大小关系，就可以确定要将 $\textit{val}$ 插入到哪个子树中。
- 如果该子树不为空，则问题转化成了将 $\textit{val}$ 插入到对应子树上。
- 否则，在此处新建一个以 $\textit{val}$ 为值的节点，并链接到其父节点 $\textit{root}$ 上。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    TreeNode* insertIntoBST(TreeNode* root, int val) {
        if (root == nullptr) {
            return new TreeNode(val);
        }
        TreeNode* pos = root;
        while (pos != nullptr) {
            if (val < pos->val) {
                if (pos->left == nullptr) {
                    pos->left = new TreeNode(val);
                    break;
                } else {
                    pos = pos->left;
                }
            } else {
                if (pos->right == nullptr) {
                    pos->right = new TreeNode(val);
                    break;
                } else {
                    pos = pos->right;
                }
            }
        }
        return root;
    }
};
```

```Java [sol1-Java]
class Solution {
    public TreeNode insertIntoBST(TreeNode root, int val) {
        if (root == null) {
            return new TreeNode(val);
        }
        TreeNode pos = root;
        while (pos != null) {
            if (val < pos.val) {
                if (pos.left == null) {
                    pos.left = new TreeNode(val);
                    break;
                } else {
                    pos = pos.left;
                }
            } else {
                if (pos.right == null) {
                    pos.right = new TreeNode(val);
                    break;
                } else {
                    pos = pos.right;
                }
            }
        }
        return root;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def insertIntoBST(self, root: TreeNode, val: int) -> TreeNode:
        if not root:
            return TreeNode(val)
        
        pos = root
        while pos:
            if val < pos.val:
                if not pos.left:
                    pos.left = TreeNode(val)
                    break
                else:
                    pos = pos.left
            else:
                if not pos.right:
                    pos.right = TreeNode(val)
                    break
                else:
                    pos = pos.right
        
        return root
```

```JavaScript [sol1-JavaScript]
var insertIntoBST = function(root, val) {
    if (root === null) {
        return new TreeNode(val);
    }
    let pos = root;
    while (pos !== null) {
        if (val < pos.val) {
            if (pos.left === null) {
                pos.left = new TreeNode(val);
                break;
            } else {
                pos = pos.left;
            }
        } else {
            if (pos.right === null) {
                pos.right = new TreeNode(val);
                break;
            } else {
                pos = pos.right;
            }
        }
    }
    return root;
};
```

```Golang [sol1-Golang]
func insertIntoBST(root *TreeNode, val int) *TreeNode {
    if root == nil {
        return &TreeNode{Val: val}
    }
    p := root
    for p != nil {
        if val < p.Val {
            if p.Left == nil {
                p.Left = &TreeNode{Val: val}
                break
            }
            p = p.Left
        } else {
            if p.Right == nil {
                p.Right = &TreeNode{Val: val}
                break
            }
            p = p.Right
        }
    }
    return root
}
```

```C [sol1-C]
struct TreeNode* createTreeNode(int val) {
    struct TreeNode* ret = malloc(sizeof(struct TreeNode));
    ret->val = val;
    ret->left = ret->right = NULL;
    return ret;
}

struct TreeNode* insertIntoBST(struct TreeNode* root, int val) {
    if (root == NULL) {
        root = createTreeNode(val);
        return root;
    }
    struct TreeNode* pos = root;
    while (pos != NULL) {
        if (val < pos->val) {
            if (pos->left == NULL) {
                pos->left = createTreeNode(val);
                break;
            } else {
                pos = pos->left;
            }
        } else {
            if (pos->right == NULL) {
                pos->right = createTreeNode(val);
                break;
            } else {
                pos = pos->right;
            }
        }
    }
    return root;
}
```

**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 为树中节点的数目。最坏情况下，我们需要将值插入到树的最深的叶子结点上，而叶子节点最深为 $O(N)$。

- 空间复杂度：$O(1)$。我们只使用了常数大小的空间。
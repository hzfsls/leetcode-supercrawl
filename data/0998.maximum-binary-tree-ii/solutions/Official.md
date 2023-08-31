## [998.最大二叉树 II 中文官方题解](https://leetcode.cn/problems/maximum-binary-tree-ii/solutions/100000/zui-da-er-cha-shu-ii-by-leetcode-solutio-piv2)
#### 方法一：遍历右子节点

**思路与算法**

如果根节点的值小于给定的整数 $\textit{val}$，那么新的树会以 $\textit{val}$ 作为根节点，并将原来的树作为新的根节点的左子树。

否则，我们从根节点开始不断地向右子节点进行遍历。这是因为，当遍历到的节点的值大于 $\textit{val}$ 时，由于 $\textit{val}$ 是新添加的位于数组末尾的元素，那么在构造的结果中，$\textit{val}$ 一定出现在该节点的右子树中。

当我们遍历到节点 $\textit{cur}$ 以及它的父节点 $\textit{parent}$，并且 $\textit{cur}$ 节点的值小于 $\textit{val}$ 时，我们就可以停止遍历，构造一个新的节点，以 $\textit{val}$ 为值且以 $\textit{cur}$ 为左子树。我们将该节点作为 $\textit{parent}$ 的新的右节点，并返回根节点作为答案即可。

如果遍历完成之后，仍然没有找到比 $\textit{val}$ 值小的节点，那么我们构造一个新的节点，以 $\textit{val}$ 为值，将该节点作为 $\textit{parent}$ 的右节点，并返回根节点作为答案即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    TreeNode* insertIntoMaxTree(TreeNode* root, int val) {
        TreeNode* parent = nullptr;
        TreeNode* cur = root;
        while (cur) {
            if (val > cur->val) {
                if (!parent) {
                    return new TreeNode(val, root, nullptr);
                }
                TreeNode* node = new TreeNode(val, cur, nullptr);
                parent->right = node;
                return root;
            }
            else {
                parent = cur;
                cur = cur->right;
            }
        }
        parent->right = new TreeNode(val);
        return root;
    }
};
```

```Java [sol1-Java]
class Solution {
    public TreeNode insertIntoMaxTree(TreeNode root, int val) {
        TreeNode parent = null;
        TreeNode cur = root;
        while (cur != null) {
            if (val > cur.val) {
                if (parent == null) {
                    return new TreeNode(val, root, null);
                }
                TreeNode node = new TreeNode(val, cur, null);
                parent.right = node;
                return root;
            } else {
                parent = cur;
                cur = cur.right;
            }
        }
        parent.right = new TreeNode(val);
        return root;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public TreeNode InsertIntoMaxTree(TreeNode root, int val) {
        TreeNode parent = null;
        TreeNode cur = root;
        while (cur != null) {
            if (val > cur.val) {
                if (parent == null) {
                    return new TreeNode(val, root, null);
                }
                TreeNode node = new TreeNode(val, cur, null);
                parent.right = node;
                return root;
            } else {
                parent = cur;
                cur = cur.right;
            }
        }
        parent.right = new TreeNode(val);
        return root;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def insertIntoMaxTree(self, root: Optional[TreeNode], val: int) -> Optional[TreeNode]:
        parent, cur = None, root
        while cur:
            if val > cur.val:
                if not parent:
                    return TreeNode(val, root, None)
                node = TreeNode(val, cur, None)
                parent.right = node
                return root
            else:
                parent = cur
                cur = cur.right
        
        parent.right = TreeNode(val)
        return root
```

```C [sol1-C]
struct TreeNode* creatTreeNode(int val, const struct TreeNode *left, const struct TreeNode *right) {
    struct TreeNode* node = (struct TreeNode *)malloc(sizeof(struct TreeNode));
    node->val = val;
    node->left = left;
    node->right = right;
    return node;
}

struct TreeNode* insertIntoMaxTree(struct TreeNode* root, int val){
    struct TreeNode* parent = NULL;
    struct TreeNode* cur = root;
    struct TreeNode* node = NULL;
    while (cur) {
        if (val > cur->val) {
            if (!parent) {
                return creatTreeNode(val, root, NULL);
            } 
            parent->right = creatTreeNode(val, cur, NULL);
            return root;
        }
        else {
            parent = cur;
            cur = cur->right;
        }
    }
    parent->right = creatTreeNode(val, NULL, NULL);;
    return root;
}
```

```go [sol1-Golang]
func insertIntoMaxTree(root *TreeNode, val int) *TreeNode {
    var parent *TreeNode
    for cur := root; cur != nil; cur = cur.Right {
        if val > cur.Val {
            if parent == nil {
                return &TreeNode{val, root, nil}
            }
            parent.Right = &TreeNode{val, cur, nil}
            return root
        }
        parent = cur
    }
    parent.Right = &TreeNode{Val: val}
    return root
}
```

```JavaScript [sol1-JavaScript]
var insertIntoMaxTree = function(root, val) {
    let parent = null;
    let cur = root;
    while (cur) {
        if (val > cur.val) {
            if (!parent) {
                return new TreeNode(val, root, null);
            }
            let node = new TreeNode(val, cur, null);
            parent.right = node;
            return root;
        } else {
            parent = cur;
            cur = cur.right;
        }
    }
    parent.right = new TreeNode(val);
    return root;
};
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是给定的树中的节点个数。在最坏情况下，树呈现链状结构，前 $n-1$ 个节点有唯一的右子节点，并且 $\textit{val}$ 比树中任一节点的值都要小，此时需要遍历完整棵树，时间复杂度为 $O(n)$。

- 空间复杂度：$O(1)$。
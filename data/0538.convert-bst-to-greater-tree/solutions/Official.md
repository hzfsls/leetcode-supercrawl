## [538.把二叉搜索树转换为累加树 中文官方题解](https://leetcode.cn/problems/convert-bst-to-greater-tree/solutions/100000/ba-er-cha-sou-suo-shu-zhuan-huan-wei-lei-jia-sh-14)
#### 前言

二叉搜索树是一棵空树，或者是具有下列性质的二叉树：

1. 若它的左子树不空，则左子树上所有节点的值均小于它的根节点的值；
   
2. 若它的右子树不空，则右子树上所有节点的值均大于它的根节点的值；
   
3. 它的左、右子树也分别为二叉搜索树。

由这样的性质我们可以发现，二叉搜索树的中序遍历是一个单调递增的有序序列。如果我们反序地中序遍历该二叉搜索树，即可得到一个单调递减的有序序列。

#### 方法一：反序中序遍历

**思路及算法**

本题中要求我们将每个节点的值修改为原来的节点值加上所有大于它的节点值之和。这样我们只需要反序中序遍历该二叉搜索树，记录过程中的节点值之和，并不断更新当前遍历到的节点的节点值，即可得到题目要求的累加树。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    int sum = 0;

    TreeNode* convertBST(TreeNode* root) {
        if (root != nullptr) {
            convertBST(root->right);
            sum += root->val;
            root->val = sum;
            convertBST(root->left);
        }
        return root;
    }
};
```

```Java [sol1-Java]
class Solution {
    int sum = 0;

    public TreeNode convertBST(TreeNode root) {
        if (root != null) {
            convertBST(root.right);
            sum += root.val;
            root.val = sum;
            convertBST(root.left);
        }
        return root;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def convertBST(self, root: TreeNode) -> TreeNode:
        def dfs(root: TreeNode):
            nonlocal total
            if root:
                dfs(root.right)
                total += root.val
                root.val = total
                dfs(root.left)
        
        total = 0
        dfs(root)
        return root
```

```Golang [sol1-Golang]
func convertBST(root *TreeNode) *TreeNode {
    sum := 0
    var dfs func(*TreeNode)
    dfs = func(node *TreeNode) {
        if node != nil {
            dfs(node.Right)
            sum += node.Val
            node.Val = sum
            dfs(node.Left)
        }
    }
    dfs(root)
    return root
}
```

```C [sol1-C]
int sum;

struct TreeNode* dfs(struct TreeNode* root) {
    if (root != NULL) {
        dfs(root->right);
        sum += root->val;
        root->val = sum;
        dfs(root->left);
    }
    return root;
}

struct TreeNode* convertBST(struct TreeNode* root) {
    sum = 0;
    dfs(root);
    return root;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉搜索树的节点数。每一个节点恰好被遍历一次。
  
- 空间复杂度：$O(n)$，为递归过程中栈的开销，平均情况下为 $O(\log n)$，最坏情况下树呈现链状，为 $O(n)$。

#### 方法二：Morris 遍历

**思路及算法**

有一种巧妙的方法可以在线性时间内，只占用常数空间来实现中序遍历。这种方法由 J. H. Morris 在 1979 年的论文「Traversing Binary Trees Simply and Cheaply」中首次提出，因此被称为 Morris 遍历。

Morris 遍历的核心思想是利用树的大量空闲指针，实现空间开销的极限缩减。其反序中序遍历规则总结如下：

1. 如果当前节点的右子节点为空，处理当前节点，并遍历当前节点的左子节点；

2. 如果当前节点的右子节点不为空，找到当前节点右子树的最左节点（该节点为当前节点中序遍历的前驱节点）；
   
   - 如果最左节点的左指针为空，将最左节点的左指针指向当前节点，遍历当前节点的右子节点；
   
   - 如果最左节点的左指针不为空，将最左节点的左指针重新置为空（恢复树的原状），处理当前节点，并将当前节点置为其左节点；

3. 重复步骤 1 和步骤 2，直到遍历结束。

这样我们利用 Morris 遍历的方法，反序中序遍历该二叉搜索树，即可实现线性时间与常数空间的遍历。

**代码**

```C++ [sol2-C++]
class Solution {
public:
    TreeNode* getSuccessor(TreeNode* node) {
        TreeNode* succ = node->right;
        while (succ->left != nullptr && succ->left != node) {
            succ = succ->left;
        }
        return succ;
    }

    TreeNode* convertBST(TreeNode* root) {
        int sum = 0;
        TreeNode* node = root;

        while (node != nullptr) {
            if (node->right == nullptr) {
                sum += node->val;
                node->val = sum;
                node = node->left;
            } else {
                TreeNode* succ = getSuccessor(node);
                if (succ->left == nullptr) {
                    succ->left = node;
                    node = node->right;
                } else {
                    succ->left = nullptr;
                    sum += node->val;
                    node->val = sum;
                    node = node->left;
                }
            }
        }

        return root;
    }
};
```

```Java [sol2-Java]
class Solution {
    public TreeNode convertBST(TreeNode root) {
        int sum = 0;
        TreeNode node = root;

        while (node != null) {
            if (node.right == null) {
                sum += node.val;
                node.val = sum;
                node = node.left;
            } else {
                TreeNode succ = getSuccessor(node);
                if (succ.left == null) {
                    succ.left = node;
                    node = node.right;
                } else {
                    succ.left = null;
                    sum += node.val;
                    node.val = sum;
                    node = node.left;
                }
            }
        }

        return root;
    }

    public TreeNode getSuccessor(TreeNode node) {
        TreeNode succ = node.right;
        while (succ.left != null && succ.left != node) {
            succ = succ.left;
        }
        return succ;
    }
}

```

```Python [sol2-Python3]
class Solution:
    def convertBST(self, root: TreeNode) -> TreeNode:
        def getSuccessor(node: TreeNode) -> TreeNode:
            succ = node.right
            while succ.left and succ.left != node:
                succ = succ.left
            return succ
        
        total = 0
        node = root

        while node:
            if not node.right:
                total += node.val
                node.val = total
                node = node.left
            else:
                succ = getSuccessor(node)
                if not succ.left:
                    succ.left = node
                    node = node.right
                else:
                    succ.left = None
                    total += node.val
                    node.val = total
                    node = node.left

        return roota
```

```Golang [sol2-Golang]
func getSuccessor(node *TreeNode) *TreeNode {
    succ := node.Right
    for succ.Left != nil && succ.Left != node {
        succ = succ.Left
    }
    return succ
}

func convertBST(root *TreeNode) *TreeNode {
    sum := 0
    node := root
    for node != nil {
        if node.Right == nil {
            sum += node.Val
            node.Val = sum
            node = node.Left
        } else {
            succ := getSuccessor(node)
            if succ.Left == nil {
                succ.Left = node
                node = node.Right
            } else {
                succ.Left = nil
                sum += node.Val
                node.Val = sum
                node = node.Left
            }
        }
    }
    return root
}
```

```C [sol2-C]
struct TreeNode* getSuccessor(struct TreeNode* node) {
    struct TreeNode* succ = node->right;
    while (succ->left != NULL && succ->left != node) {
        succ = succ->left;
    }
    return succ;
}

struct TreeNode* convertBST(struct TreeNode* root) {
    int sum = 0;
    struct TreeNode* node = root;

    while (node != NULL) {
        if (node->right == NULL) {
            sum += node->val;
            node->val = sum;
            node = node->left;
        } else {
            struct TreeNode* succ = getSuccessor(node);
            if (succ->left == NULL) {
                succ->left = node;
                node = node->right;
            } else {
                succ->left = NULL;
                sum += node->val;
                node->val = sum;
                node = node->left;
            }
        }
    }

    return root;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉搜索树的节点数。没有左子树的节点只被访问一次，有左子树的节点被访问两次。
  
- 空间复杂度：$O(1)$。只操作已经存在的指针（树的空闲指针），因此只需要常数的额外空间。
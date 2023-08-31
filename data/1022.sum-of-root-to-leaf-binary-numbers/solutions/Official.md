## [1022.从根到叶的二进制数之和 中文官方题解](https://leetcode.cn/problems/sum-of-root-to-leaf-binary-numbers/solutions/100000/cong-gen-dao-xie-de-er-jin-zhi-shu-zhi-h-eqss)

#### 前言

关于二叉树后序遍历的详细说明请参考「[145. 二叉树的后序遍历的官方题解](https://leetcode.cn/problems/binary-tree-postorder-traversal/solution/er-cha-shu-de-hou-xu-bian-li-by-leetcode-solution/)」。

#### 方法一：递归

后序遍历的访问顺序为：左子树——右子树——根节点。我们对根节点 $\textit{root}$ 进行后序遍历：

+ 如果节点是叶子节点，返回它对应的数字 $\textit{val}$。

+ 如果节点是非叶子节点，返回它的左子树和右子树对应的结果之和。

```Python [sol1-Python3]
class Solution:
    def sumRootToLeaf(self, root: Optional[TreeNode]) -> int:
        def dfs(node: Optional[TreeNode], val: int) -> int:
            if node is None:
                return 0
            val = (val << 1) | node.val
            if node.left is None and node.right is None:
                return val
            return dfs(node.left, val) + dfs(node.right, val)
        return dfs(root, 0)
```

```C++ [sol1-C++]
class Solution {
public:
    int dfs(TreeNode *root, int val) {
        if (root == nullptr) {
            return 0;
        }
        val = (val << 1) | root->val;
        if (root->left == nullptr && root->right == nullptr) {
            return val;
        }
        return dfs(root->left, val) + dfs(root->right, val);
    }

    int sumRootToLeaf(TreeNode* root) {
        return dfs(root, 0);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int sumRootToLeaf(TreeNode root) {
        return dfs(root, 0);
    }

    public int dfs(TreeNode root, int val) {
        if (root == null) {
            return 0;
        }
        val = (val << 1) | root.val;
        if (root.left == null && root.right == null) {
            return val;
        }
        return dfs(root.left, val) + dfs(root.right, val);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int SumRootToLeaf(TreeNode root) {
        return DFS(root, 0);
    }

    public int DFS(TreeNode root, int val) {
        if (root == null) {
            return 0;
        }
        val = (val << 1) | root.val;
        if (root.left == null && root.right == null) {
            return val;
        }
        return DFS(root.left, val) + DFS(root.right, val);
    }
}
```

```C [sol1-C]
int dfs(struct TreeNode *root, int val) {
    if (root == NULL) {
        return 0;
    }
    val = (val << 1) | root->val;
    if (root->left == NULL && root->right == NULL) {
        return val;
    }
    return dfs(root->left, val) + dfs(root->right, val);
}

int sumRootToLeaf(struct TreeNode* root){
    return dfs(root, 0);
}
```

```JavaScript [sol1-JavaScript]
var sumRootToLeaf = function(root) {
    const dfs = (root, val) => {
        if (!root) {
            return 0;
        }
        val = (val << 1) | root.val;
        if (!root.left&& !root.right) {
            return val;
        }
        return dfs(root.left, val) + dfs(root.right, val);
    }
    return dfs(root, 0);
};
```

```go [sol1-Golang]
func dfs(node *TreeNode, val int) int {
    if node == nil {
        return 0
    }
    val = val<<1 | node.Val
    if node.Left == nil && node.Right == nil {
        return val
    }
    return dfs(node.Left, val) + dfs(node.Right, val)
}

func sumRootToLeaf(root *TreeNode) int {
    return dfs(root, 0)
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是节点数目。总共访问 $n$ 个节点。

+ 空间复杂度：$O(n)$。递归栈需要 $O(n)$ 的空间。

#### 方法二：迭代

我们用栈来模拟递归，同时使用一个 $\textit{prev}$ 指针来记录先前访问的节点。算法步骤如下：

1. 如果节点 $\textit{root}$ 非空，我们将不断地将它及它的左节点压入栈中。

2. 我们从栈中获取节点：

    + 该节点的右节点为空或者等于 $\textit{prev}$，说明该节点的左子树及右子树都已经被访问，我们将它出栈。如果该节点是叶子节点，我们将它对应的数字 $\textit{val}$ 加入结果中。设置 $\textit{prev}$ 为该节点，设置 $\textit{root}$ 为空指针。 

    + 该节点的右节点非空且不等于 $\textit{prev}$，我们令 $\textit{root}$ 指向该节点的右节点。 

3. 如果 $\textit{root}$ 为空指针或者栈空，中止算法，否则重复步骤 $1$。

需要注意的是，每次出入栈都需要更新 $\textit{val}$。

```Python [sol2-Python3]
class Solution:
    def sumRootToLeaf(self, root: Optional[TreeNode]) -> int:
        ans = val = 0
        st = []
        pre = None
        while root or st:
            while root:
                val = (val << 1) | root.val
                st.append(root)
                root = root.left
            root = st[-1]
            if root.right is None or root.right == pre:
                if root.left is None and root.right is None:
                    ans += val
                val >>= 1
                st.pop()
                pre = root
                root = None
            else:
                root = root.right
        return ans
```

```C++ [sol2-C++]
class Solution {
public:
    int sumRootToLeaf(TreeNode* root) {
        stack<TreeNode *> st;
        int val = 0, ret = 0;
        TreeNode *prev = nullptr;
        while (root != nullptr || !st.empty()) {
            while (root != nullptr) {
                val = (val << 1) | root->val;
                st.push(root);
                root = root->left;
            }
            root = st.top();
            if (root->right == nullptr || root->right == prev) {
                if (root->left == nullptr && root->right == nullptr) {
                    ret += val;
                }
                val >>= 1;
                st.pop();
                prev = root;
                root = nullptr;
            } else {
                root = root->right;
            }
        }
        return ret;
    }
};
```

```Java [sol2-Java]
class Solution {
    public int sumRootToLeaf(TreeNode root) {
        Deque<TreeNode> stack = new ArrayDeque<TreeNode>();
        int val = 0, ret = 0;
        TreeNode prev = null;
        while (root != null || !stack.isEmpty()) {
            while (root != null) {
                val = (val << 1) | root.val;
                stack.push(root);
                root = root.left;
            }
            root = stack.peek();
            if (root.right == null || root.right == prev) {
                if (root.left == null && root.right == null) {
                    ret += val;
                }
                val >>= 1;
                stack.pop();
                prev = root;
                root = null;
            } else {
                root = root.right;
            }
        }
        return ret;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int SumRootToLeaf(TreeNode root) {
        Stack<TreeNode> stack = new Stack<TreeNode>();
        int val = 0, ret = 0;
        TreeNode prev = null;
        while (root != null || stack.Count > 0) {
            while (root != null) {
                val = (val << 1) | root.val;
                stack.Push(root);
                root = root.left;
            }
            root = stack.Peek();
            if (root.right == null || root.right == prev) {
                if (root.left == null && root.right == null) {
                    ret += val;
                }
                val >>= 1;
                stack.Pop();
                prev = root;
                root = null;
            } else {
                root = root.right;
            }
        }
        return ret;
    }
}
```

```C [sol2-C]
#define MAX_NODE_SIZE 1000

int sumRootToLeaf(struct TreeNode* root) {
    struct TreeNode ** stack = (struct TreeNode **)malloc(sizeof(struct TreeNode *) * MAX_NODE_SIZE);
    int top = 0;
    int val = 0, ret = 0;
    struct TreeNode *prev = NULL;
    while (root != NULL || top) {
        while (root != NULL) {
            val = (val << 1) | root->val;
            stack[top++] = root;
            root = root->left;
        }
        root = stack[top - 1];
        if (root->right == NULL || root->right == prev) {
            if (root->left == NULL && root->right == NULL) {
                ret += val;
            }
            val >>= 1;
            top--;
            prev = root;
            root = NULL;
        } else {
            root = root->right;
        }
    }
    free(stack);
    return ret;
}
```

```JavaScript [sol2-JavaScript]
var sumRootToLeaf = function(root) {
    const stack = [];
    let val = 0, ret = 0;
    let prev = null;
    while (root || stack.length) {
        while (root) {
            val = (val << 1) | root.val;
            stack.push(root);
            root = root.left;
        }
        root = stack[stack.length - 1];
        if (!root.right || root.right === prev) {
            if (!root.left && !root.right) {
                ret += val;
            }
            val >>= 1;
            stack.pop();
            prev = root;
            root = null;
        } else {
            root = root.right;
        }
    }
    return ret;
};
```

```go [sol2-Golang]
func sumRootToLeaf(root *TreeNode) (ans int) {
    val, st := 0, []*TreeNode{}
    var pre *TreeNode
    for root != nil || len(st) > 0 {
        for root != nil {
            val = val<<1 | root.Val
            st = append(st, root)
            root = root.Left
        }
        root = st[len(st)-1]
        if root.Right == nil || root.Right == pre {
            if root.Left == nil && root.Right == nil {
                ans += val
            }
            val >>= 1
            st = st[:len(st)-1]
            pre = root
            root = nil
        } else {
            root = root.Right
        }
    }
    return
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$，其中 $n$ 是节点数目。总共访问 $n$ 个节点。

+ 空间复杂度：$O(n)$。栈最多压入 $n$ 个节点。
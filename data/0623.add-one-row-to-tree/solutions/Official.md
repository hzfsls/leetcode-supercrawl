## [623.在二叉树中增加一行 中文官方题解](https://leetcode.cn/problems/add-one-row-to-tree/solutions/100000/zai-er-cha-shu-zhong-zeng-jia-yi-xing-by-xcaf)
#### 方法一：深度优先搜索

**思路**

当输入 $\textit{depth}$ 为 $1$ 时，需要创建一个新的 $\textit{root}$，并将原 $\textit{root}$ 作为新 $\textit{root}$ 的左子节点。当 $\textit{depth}$ 为 $2$ 时，需要在 $\textit{root}$ 下新增两个节点 $\textit{left}$ 和 $\textit{right}$ 作为 $\textit{root}$ 的新子节点，并把原左子节点作为 $\textit{left}$ 的左子节点，把原右子节点作为 $\textit{right}$ 的右子节点。当 $\textit{depth}$ 大于 $2$ 时，需要继续递归往下层搜索，并将 $\textit{depth}$ 减去 $1$，直到搜索到 $\textit{depth}$ 为 $2$。

**代码**

```Python [sol1-Python3]
class Solution:
    def addOneRow(self, root: TreeNode, val: int, depth: int) -> TreeNode:
        if root == None:
            return
        if depth == 1:
            return TreeNode(val, root, None)
        if depth == 2:
            root.left = TreeNode(val, root.left, None)
            root.right = TreeNode(val, None, root.right)
        else:
            root.left = self.addOneRow(root.left, val, depth - 1)
            root.right = self.addOneRow(root.right, val, depth - 1)
        return root
```

```Java [sol1-Java]
class Solution {
    public TreeNode addOneRow(TreeNode root, int val, int depth) {
        if (root == null) {
            return null;
        }
        if (depth == 1) {
            return new TreeNode(val, root, null);
        }
        if (depth == 2) {
            root.left = new TreeNode(val, root.left, null);
            root.right = new TreeNode(val, null, root.right);
        } else {
            root.left = addOneRow(root.left, val, depth - 1);
            root.right = addOneRow(root.right, val, depth - 1);
        }
        return root;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public TreeNode AddOneRow(TreeNode root, int val, int depth) {
        if (root == null) {
            return null;
        }
        if (depth == 1) {
            return new TreeNode(val, root, null);
        }
        if (depth == 2) {
            root.left = new TreeNode(val, root.left, null);
            root.right = new TreeNode(val, null, root.right);
        } else {
            root.left = AddOneRow(root.left, val, depth - 1);
            root.right = AddOneRow(root.right, val, depth - 1);
        }
        return root;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    TreeNode* addOneRow(TreeNode* root, int val, int depth) {
        if (root == nullptr) {
            return nullptr;
        }
        if (depth == 1) {
            return new TreeNode(val, root, nullptr);
        }
        if (depth == 2) {
            root->left = new TreeNode(val, root->left, nullptr);
            root->right = new TreeNode(val, nullptr, root->right);
        } else {
            root->left = addOneRow(root->left, val, depth - 1);
            root->right = addOneRow(root->right, val, depth - 1);
        }
        return root;
    }
};
```

```C [sol1-C]
struct TreeNode* addOneRow(struct TreeNode* root, int val, int depth) {
    if (root == NULL) {
            return NULL;
        }
        struct TreeNode *node = (struct TreeNode *)malloc(sizeof(struct TreeNode));
        if (depth == 1) {
            node = (struct TreeNode *)malloc(sizeof(struct TreeNode));
            node->val = val;
            node->left = root;
            node->right = NULL;
            return node;
        }
        if (depth == 2) {
            node = (struct TreeNode *)malloc(sizeof(struct TreeNode));
            node->val = val;
            node->left = root->left;
            node->right = NULL;
            root->left = node;
            node = (struct TreeNode *)malloc(sizeof(struct TreeNode));
            node->val = val;
            node->left = NULL;
            node->right = root->right;
            root->right = node;
        } else {
            root->left = addOneRow(root->left, val, depth - 1);
            root->right = addOneRow(root->right, val, depth - 1);
        }
        return root;
}
```

```JavaScript [sol1-JavaScript]
var addOneRow = function(root, val, depth) {
    if (!root) {
        return null;
    }
    if (depth === 1) {
        return new TreeNode(val, root, null);
    }
    if (depth === 2) {
        root.left = new TreeNode(val, root.left, null);
        root.right = new TreeNode(val, null, root.right);
    } else {
        root.left = addOneRow(root.left, val, depth - 1);
        root.right = addOneRow(root.right, val, depth - 1);
    }
    return root;
};
```

```go [sol1-Golang]
func addOneRow(root *TreeNode, val, depth int) *TreeNode {
    if root == nil {
        return nil
    }
    if depth == 1 {
        return &TreeNode{val, root, nil}
    }
    if depth == 2 {
        root.Left = &TreeNode{val, root.Left, nil}
        root.Right = &TreeNode{val, nil, root.Right}
    } else {
        root.Left = addOneRow(root.Left, val, depth-1)
        root.Right = addOneRow(root.Right, val, depth-1)
    }
    return root
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为输入的树的节点数。最坏情况下，需要遍历整棵树。

- 空间复杂度：$O(n)$，递归的深度最多为 $O(n)$。

#### 方法二：广度优先搜索

**思路**

与深度优先搜索类似，我们用广度优先搜索找到要加的一行的上一行，然后对这一行的每个节点 $\textit{node}$，都新增两个节点 $\textit{left}$ 和 $\textit{right}$ 作为 $\textit{node}$ 的新子节点，并把原左子节点作为 $\textit{left}$ 的左子节点，把原右子节点作为 $\textit{right}$ 的右子节点。

**代码**

```Python [sol2-Python3]
class Solution:
    def addOneRow(self, root: TreeNode, val: int, depth: int) -> TreeNode:
        if depth == 1:
            return TreeNode(val, root, None)
        curLevel = [root]
        for _ in range(1, depth - 1):
            tmpt = []
            for node in curLevel:
                if node.left:
                    tmpt.append(node.left)
                if node.right:
                    tmpt.append(node.right)
            curLevel = tmpt
        for node in curLevel:
            node.left = TreeNode(val, node.left, None)
            node.right = TreeNode(val, None, node.right)
        return root
```

```Java [sol2-Java]
class Solution {
    public TreeNode addOneRow(TreeNode root, int val, int depth) {
        if (depth == 1) {
            return new TreeNode(val, root, null);
        }
        List<TreeNode> curLevel = new ArrayList<TreeNode>();
        curLevel.add(root);
        for (int i = 1; i < depth - 1; i++) {
            List<TreeNode> tmpt = new ArrayList<TreeNode>();
            for (TreeNode node : curLevel) {
                if (node.left != null) {
                    tmpt.add(node.left);
                }
                if (node.right != null) {
                    tmpt.add(node.right);
                }
            }
            curLevel = tmpt;
        }
        for (TreeNode node : curLevel) {
            node.left = new TreeNode(val, node.left, null);
            node.right = new TreeNode(val, null, node.right);
        }
        return root;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public TreeNode AddOneRow(TreeNode root, int val, int depth) {
        if (depth == 1) {
            return new TreeNode(val, root, null);
        }
        IList<TreeNode> curLevel = new List<TreeNode>();
        curLevel.Add(root);
        for (int i = 1; i < depth - 1; i++) {
            IList<TreeNode> tmpt = new List<TreeNode>();
            foreach (TreeNode node in curLevel) {
                if (node.left != null) {
                    tmpt.Add(node.left);
                }
                if (node.right != null) {
                    tmpt.Add(node.right);
                }
            }
            curLevel = tmpt;
        }
        foreach (TreeNode node in curLevel) {
            node.left = new TreeNode(val, node.left, null);
            node.right = new TreeNode(val, null, node.right);
        }
        return root;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    TreeNode* addOneRow(TreeNode* root, int val, int depth) {
        if (depth == 1) {
            return new TreeNode(val, root, nullptr);
        }
        vector<TreeNode *> curLevel(1, root);
        for (int i = 1; i < depth - 1; i++) {
            vector<TreeNode *> tmpt;
            for (auto &node : curLevel) {
                if (node->left != nullptr) {
                    tmpt.emplace_back(node->left);
                }
                if (node->right != nullptr) {
                    tmpt.emplace_back(node->right);
                }
            }
            curLevel = move(tmpt);
        }
        for (auto &node : curLevel) {
            node->left = new TreeNode(val, node->left, nullptr);
            node->right = new TreeNode(val, nullptr, node->right);
        }
        return root;
    }
};
```

```C [sol2-C]
#define MAX_NODE_SIZE 10000

struct TreeNode* addOneRow(struct TreeNode* root, int val, int depth) {
    struct TreeNode* node = NULL;
    if (depth == 1) {
        node = (struct TreeNode *)malloc(sizeof(struct TreeNode));
        node->val = val;
        node->left = root;
        node->right = NULL;
        return node;
    }
    struct TreeNode **queue = (struct TreeNode **)malloc(sizeof(struct TreeNode *) * MAX_NODE_SIZE);
    int head = 0, tail = 0;
    queue[tail++] = root;
    for (int i = 1; i < depth - 1; i++) {
        int sz = tail - head;
        for (int j = 0; j < sz; j++) {
            if (queue[head]->left != NULL) {
                queue[tail++] = queue[head]->left;
            }
            if (queue[head]->right != NULL) {
                queue[tail++] = queue[head]->right;
            }
            head++;
        }
    }
    for (; head != tail; head++) {
        node = (struct TreeNode *)malloc(sizeof(struct TreeNode));
        node->val = val;
        node->left = queue[head]->left;
        node->right = NULL;
        queue[head]->left = node;
        node = (struct TreeNode *)malloc(sizeof(struct TreeNode));
        node->val = val;
        node->left = NULL;
        node->right = queue[head]->right;
        queue[head]->right = node;
    }
    return root;
}
```

```JavaScript [sol2-JavaScript]
var addOneRow = function(root, val, depth) {
    if (depth === 1) {
        return new TreeNode(val, root, null);
    }
    let curLevel = [];
    curLevel.push(root);
    for (let i = 1; i < depth - 1; i++) {
        const tmp = [];
        for (const node of curLevel) {
            if (node.left) {
                tmp.push(node.left);
            }
            if (node.right) {
                tmp.push(node.right);
            }
        }
        curLevel = tmp;
    }
    for (const node of curLevel) {
        node.left = new TreeNode(val, node.left, null);
        node.right = new TreeNode(val, null, node.right);
    }
    return root;
};
```

```go [sol2-Golang]
func addOneRow(root *TreeNode, val, depth int) *TreeNode {
    if depth == 1 {
        return &TreeNode{val, root, nil}
    }
    nodes := []*TreeNode{root}
    for i := 1; i < depth-1; i++ {
        tmp := nodes
        nodes = nil
        for _, node := range tmp {
            if node.Left != nil {
                nodes = append(nodes, node.Left)
            }
            if node.Right != nil {
                nodes = append(nodes, node.Right)
            }
        }
    }
    for _, node := range nodes {
        node.Left = &TreeNode{val, node.Left, nil}
        node.Right = &TreeNode{val, nil, node.Right}
    }
    return root
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为输入的树的节点数。最坏情况下，需要遍历整棵树。

- 空间复杂度：$O(n)$，数组空间开销最多为 $O(n)$。
## [230.二叉搜索树中第K小的元素 中文官方题解](https://leetcode.cn/problems/kth-smallest-element-in-a-bst/solutions/100000/er-cha-sou-suo-shu-zhong-di-kxiao-de-yua-8o07)

#### 方法一：中序遍历

**预备知识**

二叉搜索树具有如下性质：

- 结点的左子树只包含**小于**当前结点的数。

- 结点的右子树只包含**大于**当前结点的数。

- 所有左子树和右子树自身必须也是二叉搜索树。

二叉树的中序遍历即按照访问左子树——根结点——右子树的方式遍历二叉树；在访问其左子树和右子树时，我们也按照同样的方式遍历；直到遍历完整棵树。

**思路和算法**

因为二叉搜索树和中序遍历的性质，所以二叉搜索树的中序遍历是按照键增加的顺序进行的。于是，我们可以通过中序遍历找到第 $k$ 个最小元素。

「二叉树的中序遍历」可以参考「[94. 二叉树的中序遍历的官方题解](https://leetcode-cn.com/problems/binary-tree-inorder-traversal/solution/er-cha-shu-de-zhong-xu-bian-li-by-leetcode-solutio/)」，具体地，我们使用迭代方法，这样可以在找到答案后停止，不需要遍历整棵树。

**代码**

```Python [sol1-Python3]
class Solution:
    def kthSmallest(self, root: TreeNode, k: int) -> int:
        stack = []
        while root or stack:
            while root:
                stack.append(root)
                root = root.left
            root = stack.pop()
            k -= 1
            if k == 0:
                return root.val
            root = root.right
```

```Java [sol1-Java]
class Solution {
    public int kthSmallest(TreeNode root, int k) {
        Deque<TreeNode> stack = new ArrayDeque<TreeNode>();
        while (root != null || !stack.isEmpty()) {
            while (root != null) {
                stack.push(root);
                root = root.left;
            }
            root = stack.pop();
            --k;
            if (k == 0) {
                break;
            }
            root = root.right;
        }
        return root.val;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public int KthSmallest(TreeNode root, int k) {
        Stack<TreeNode> stack = new Stack<TreeNode>();
        while (root != null || stack.Count > 0) {
            while (root != null) {
                stack.Push(root);
                root = root.left;
            }
            root = stack.Pop();
            --k;
            if (k == 0) {
                break;
            }
            root = root.right;
        }
        return root.val;
    }
}
```

```go [sol1-Golang]
func kthSmallest(root *TreeNode, k int) int {
    stack := []*TreeNode{}
    for {
        for root != nil {
            stack = append(stack, root)
            root = root.Left
        }
        stack, root = stack[:len(stack)-1], stack[len(stack)-1]
        k--
        if k == 0 {
            return root.Val
        }
        root = root.Right
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int kthSmallest(TreeNode* root, int k) {
        stack<TreeNode *> stack;
        while (root != nullptr || stack.size() > 0) {
            while (root != nullptr) {
                stack.push(root);
                root = root->left;
            }
            root = stack.top();
            stack.pop();
            --k;
            if (k == 0) {
                break;
            }
            root = root->right;
        }
        return root->val;
    }
};
```

```JavaScript [sol1-JavaScript]
var kthSmallest = function(root, k) {
    const stack = [];
    while (root != null || stack.length) {
        while (root != null) {
            stack.push(root);
            root = root.left;
        }
        root = stack.pop();
        --k;
        if (k === 0) {
            break;
        }
        root = root.right;
    }
    return root.val;
};
```

**复杂度分析**

- 时间复杂度：$O(H+k)$，其中 $H$ 是树的高度。在开始遍历之前，我们需要 $O(H)$ 到达叶结点。当树是平衡树时，时间复杂度取得最小值 $O(\log N + k)$；当树是线性树（树中每个结点都只有一个子结点或没有子结点）时，时间复杂度取得最大值 $O(N+k)$。

- 空间复杂度：$O(H)$，栈中最多需要存储 $H$ 个元素。当树是平衡树时，空间复杂度取得最小值 $O(\log N)$；当树是线性树时，空间复杂度取得最大值 $O(N)$。

#### 方法二：记录子树的结点数

> 如果你需要频繁地查找第 $k$ 小的值，你将如何优化算法？

**思路和算法**

在方法一中，我们之所以需要中序遍历前 $k$ 个元素，是因为我们不知道子树的结点数量，不得不通过遍历子树的方式来获知。

因此，我们可以记录下以每个结点为根结点的子树的结点数，并在查找第 $k$ 小的值时，使用如下方法搜索：

- 令 $\textit{node}$ 等于根结点，开始搜索。

- 对当前结点 $\textit{node}$ 进行如下操作：
  - 如果 $\textit{node}$ 的左子树的结点数 $\textit{left}$ 小于 $k-1$，则第 $k$ 小的元素一定在 $\textit{node}$ 的右子树中，令 $\textit{node}$ 等于其的右子结点，$k$ 等于 $k - \textit{left} - 1$，并继续搜索；
  - 如果 $\textit{node}$ 的左子树的结点数 $\textit{left}$ 等于 $k-1$，则第 $k$ 小的元素即为 $node$ ，结束搜索并返回 $\textit{node}$ 即可；
  - 如果 $\textit{node}$ 的左子树的结点数 $\textit{left}$ 大于 $k-1$，则第 $k$ 小的元素一定在 $\textit{node}$ 的左子树中，令 $\textit{node}$ 等于其左子结点，并继续搜索。

在实现中，我们既可以将以每个结点为根结点的子树的结点数存储在结点中，也可以将其记录在哈希表中。

**代码**

```Python [sol2-Python3]
class MyBst:
    def __init__(self, root: TreeNode):
        self.root = root

        # 统计以每个结点为根结点的子树的结点数，并存储在哈希表中
        self._node_num = {}
        self._count_node_num(root)

    def kth_smallest(self, k: int):
        """返回二叉搜索树中第k小的元素"""
        node = self.root
        while node:
            left = self._get_node_num(node.left)
            if left < k - 1:
                node = node.right
                k -= left + 1
            elif left == k - 1:
                return node.val
            else:
                node = node.left

    def _count_node_num(self, node) -> int:
        """统计以node为根结点的子树的结点数"""
        if not node:
            return 0
        self._node_num[node] = 1 + self._count_node_num(node.left) + self._count_node_num(node.right)
        return self._node_num[node]

    def _get_node_num(self, node) -> int:
        """获取以node为根结点的子树的结点数"""
        return self._node_num[node] if node is not None else 0


class Solution:
    def kthSmallest(self, root: TreeNode, k: int) -> int:
        bst = MyBst(root)
        return bst.kth_smallest(k)
```

```Java [sol2-Java]
class Solution {
    public int kthSmallest(TreeNode root, int k) {
        MyBst bst = new MyBst(root);
        return bst.kthSmallest(k);
    }
}

class MyBst {
    TreeNode root;
    Map<TreeNode, Integer> nodeNum;

    public MyBst(TreeNode root) {
        this.root = root;
        this.nodeNum = new HashMap<TreeNode, Integer>();
        countNodeNum(root);
    }

    // 返回二叉搜索树中第k小的元素
    public int kthSmallest(int k) {
        TreeNode node = root;
        while (node != null) {
            int left = getNodeNum(node.left);
            if (left < k - 1) {
                node = node.right;
                k -= left + 1;
            } else if (left == k - 1) {
                break;
            } else {
                node = node.left;
            }
        }
        return node.val;
    }

    // 统计以node为根结点的子树的结点数
    private int countNodeNum(TreeNode node) {
        if (node == null) {
            return 0;
        }
        nodeNum.put(node, 1 + countNodeNum(node.left) + countNodeNum(node.right));
        return nodeNum.get(node);
    }

    // 获取以node为根结点的子树的结点数
    private int getNodeNum(TreeNode node) {
        return nodeNum.getOrDefault(node, 0);
    }
}
```

```C# [sol2-C#]
public class Solution {
    public int KthSmallest(TreeNode root, int k) {
        MyBst bst = new MyBst(root);
        return bst.KthSmallest(k);
    }
}

class MyBst {
    TreeNode root;
    Dictionary<TreeNode, int> nodeNum;

    public MyBst(TreeNode root) {
        this.root = root;
        this.nodeNum = new Dictionary<TreeNode, int>();
        CountNodeNum(root);
    }

    // 返回二叉搜索树中第k小的元素
    public int KthSmallest(int k) {
        TreeNode node = root;
        while (node != null) {
            int left = GetNodeNum(node.left);
            if (left < k - 1) {
                node = node.right;
                k -= left + 1;
            } else if (left == k - 1) {
                break;
            } else {
                node = node.left;
            }
        }
        return node.val;
    }

    // 统计以node为根结点的子树的结点数
    private int CountNodeNum(TreeNode node) {
        if (node == null) {
            return 0;
        }
        nodeNum.Add(node, 1 + CountNodeNum(node.left) + CountNodeNum(node.right));
        return nodeNum[node];
    }

    // 获取以node为根结点的子树的结点数
    private int GetNodeNum(TreeNode node) {
        return node != null && nodeNum.ContainsKey(node) ? nodeNum[node] : 0;
    }
}
```

```go [sol2-Golang]
type MyBst struct {
    root    *TreeNode
    nodeNum map[*TreeNode]int // 统计以每个结点为根结点的子树的结点数，并存储在哈希表中
}

// 统计以 node 为根结点的子树的结点数
func (t *MyBst) countNodeNum(node *TreeNode) int {
    if node == nil {
        return 0
    }
    t.nodeNum[node] = 1 + t.countNodeNum(node.Left) + t.countNodeNum(node.Right)
    return t.nodeNum[node]
}

// 返回二叉搜索树中第 k 小的元素
func (t *MyBst) kthSmallest(k int) int {
    node := t.root
    for {
        leftNodeNum := t.nodeNum[node.Left]
        if leftNodeNum < k-1 {
            node = node.Right
            k -= leftNodeNum + 1
        } else if leftNodeNum == k-1 {
            return node.Val
        } else {
            node = node.Left
        }
    }
}

func kthSmallest(root *TreeNode, k int) int {
    t := &MyBst{root, map[*TreeNode]int{}}
    t.countNodeNum(root)
    return t.kthSmallest(k)
}
```

```C++ [sol2-C++]
class MyBst {
public:
    MyBst(TreeNode *root) {
        this->root = root;
        countNodeNum(root);
    }

    // 返回二叉搜索树中第k小的元素
    int kthSmallest(int k) {
        TreeNode *node = root;
        while (node != nullptr) {
            int left = getNodeNum(node->left);
            if (left < k - 1) {
                node = node->right;
                k -= left + 1;
            } else if (left == k - 1) {
                break;
            } else {
                node = node->left;
            }
        }
        return node->val;
    }

private:
    TreeNode *root;
    unordered_map<TreeNode *, int> nodeNum;

    // 统计以node为根结点的子树的结点数
    int countNodeNum(TreeNode * node) {
        if (node == nullptr) {
            return 0;
        }
        nodeNum[node] = 1 + countNodeNum(node->left) + countNodeNum(node->right);
        return nodeNum[node];
    }

    // 获取以node为根结点的子树的结点数
    int getNodeNum(TreeNode * node) {
        if (node != nullptr && nodeNum.count(node)) {
            return nodeNum[node];
        }else{
            return 0;
        }
    }
};

class Solution {
public:
    int kthSmallest(TreeNode* root, int k) {
        MyBst bst(root);
        return bst.kthSmallest(k);
    }
};
```

```JavaScript [sol2-JavaScript]
var kthSmallest = function(root, k) {
    const bst = new MyBst(root);
    return bst.kthSmallest(k);
};

class MyBst {
    constructor(root) {
        this.root = root;
        this.nodeNum = new Map();
        this.countNodeNum(root);
    }

    // 返回二叉搜索树中第k小的元素
    kthSmallest(k) {
        let node = this.root;
        while (node != null) {
            const left = this.getNodeNum(node.left);
            if (left < k - 1) {
                node = node.right;
                k -= left + 1;
            } else if (left === k - 1) {
                break;
            } else {
                node = node.left;
            }
        }
        return node.val;
    }

    // 统计以node为根结点的子树的结点数
    countNodeNum(node) {
        if (node == null) {
            return 0;
        }
        this.nodeNum.set(node, 1 + this.countNodeNum(node.left) + this.countNodeNum(node.right));
        return this.nodeNum.get(node);
    }

    // 获取以node为根结点的子树的结点数
    getNodeNum(node) {
        return this.nodeNum.get(node) || 0;
    }
}
```

**复杂度分析**

- 时间复杂度：预处理的时间复杂度为 $O(N)$，其中 $N$ 是树中结点的总数；我们需要遍历树中所有结点来统计以每个结点为根结点的子树的结点数。搜索的时间复杂度为 $O(H)$，其中 $H$ 是树的高度；当树是平衡树时，时间复杂度取得最小值 $O(\log N)$；当树是线性树时，时间复杂度取得最大值 $O(N)$。

- 空间复杂度：$O(N)$，用于存储以每个结点为根结点的子树的结点数。

#### 方法三：平衡二叉搜索树

> 如果二叉搜索树经常被修改（插入/删除操作）并且你需要频繁地查找第 $k$ 小的值，你将如何优化算法？

**预备知识**

方法三需要先掌握 **平衡二叉搜索树（AVL树）** 的知识。平衡二叉搜索树具有如下性质：

- 平衡二叉搜索树中每个结点的左子树和右子树的高度最多相差 $1$；

- 平衡二叉搜索树的子树也是平衡二叉搜索树；

- 一棵存有 $n$ 个结点的平衡二叉搜索树的高度是 $O(\log n)$。

**思路和算法**

我们注意到在方法二中搜索二叉搜索树的时间复杂度为 $O(H)$，其中 $H$ 是树的高度；当树是平衡树时，时间复杂度取得最小值 $O(\log N)$。因此，我们在记录子树的结点数的基础上，将二叉搜索树转换为平衡二叉搜索树，并在插入和删除操作中维护它的平衡状态。

其中，将二叉搜索树转换为平衡二叉搜索树，可以参考「[1382. 将二叉搜索树变平衡的官方题解](https://leetcode-cn.com/problems/balance-a-binary-search-tree/solution/jiang-er-cha-sou-suo-shu-bian-ping-heng-by-leetcod/)」。在插入和删除操作中维护平衡状态相对复杂，读者可以阅读下面的代码和注释，理解如何通过旋转和重组实现它。

**代码**

```Python [sol3-Python3]
class AVL:
    """平衡二叉搜索树（AVL树）：允许重复值"""

    class Node:
        """平衡二叉搜索树结点"""
        __slots__ = ("val", "parent", "left", "right", "size", "height")

        def __init__(self, val, parent=None, left=None, right=None):
            self.val = val
            self.parent = parent
            self.left = left
            self.right = right
            self.height = 0  # 结点高度：以node为根节点的子树的高度（高度定义：叶结点的高度是0）
            self.size = 1  # 结点元素数：以node为根节点的子树的节点总数

    def __init__(self, vals):
        self.root = self._build(vals, 0, len(vals) - 1, None) if vals else None

    def _build(self, vals, l, r, parent):
        """根据vals[l:r]构造平衡二叉搜索树 -> 返回根结点"""
        m = (l + r) // 2
        node = self.Node(vals[m], parent=parent)
        if l <= m - 1:
            node.left = self._build(vals, l, m - 1, parent=node)
        if m + 1 <= r:
            node.right = self._build(vals, m + 1, r, parent=node)
        self._recompute(node)
        return node

    def kth_smallest(self, k: int) -> int:
        """返回二叉搜索树中第k小的元素"""
        node = self.root
        while node:
            left = self._get_size(node.left)
            if left < k - 1:
                node = node.right
                k -= left + 1
            elif left == k - 1:
                return node.val
            else:
                node = node.left

    def insert(self, v):
        """插入值为v的新结点"""
        if self.root is None:
            self.root = self.Node(v)
        else:
            # 计算新结点的添加位置
            node = self._subtree_search(self.root, v)
            is_add_left = (v <= node.val)  # 是否将新结点添加到node的左子结点
            if node.val == v:  # 如果值为v的结点已存在
                if node.left:  # 值为v的结点存在左子结点，则添加到其左子树的最右侧
                    node = self._subtree_last(node.left)
                    is_add_left = False
                else:  # 值为v的结点不存在左子结点，则添加到其左子结点
                    is_add_left = True

            # 添加新结点
            leaf = self.Node(v, parent=node)
            if is_add_left:
                node.left = leaf
            else:
                node.right = leaf

            self._rebalance(leaf)

    def delete(self, v) -> bool:
        """删除值为v的结点 -> 返回是否成功删除结点"""
        if self.root is None:
            return False

        node = self._subtree_search(self.root, v)
        if node.val != v:  # 没有找到需要删除的结点
            return False

        # 处理当前结点既有左子树也有右子树的情况
        # 若左子树比右子树高度低，则将当前结点替换为右子树最左侧的结点，并移除右子树最左侧的结点
        # 若右子树比左子树高度低，则将当前结点替换为左子树最右侧的结点，并移除左子树最右侧的结点
        if node.left and node.right:
            if node.left.height <= node.right.height:
                replacement = self._subtree_first(node.right)
            else:
                replacement = self._subtree_last(node.left)
            node.val = replacement.val
            node = replacement

        parent = node.parent
        self._delete(node)
        self._rebalance(parent)
        return True

    def _delete(self, node):
        """删除结点p并用它的子结点代替它，结点p至多只能有1个子结点"""
        if node.left and node.right:
            raise ValueError('node has two children')
        child = node.left if node.left else node.right
        if child is not None:
            child.parent = node.parent
        if node is self.root:
            self.root = child
        else:
            parent = node.parent
            if node is parent.left:
                parent.left = child
            else:
                parent.right = child
        node.parent = node

    def _subtree_search(self, node, v):
        """在以node为根结点的子树中搜索值为v的结点，如果没有值为v的结点，则返回值为v的结点应该在的位置的父结点"""
        if node.val < v and node.right is not None:
            return self._subtree_search(node.right, v)
        elif node.val > v and node.left is not None:
            return self._subtree_search(node.left, v)
        else:
            return node

    def _recompute(self, node):
        """重新计算node结点的高度和元素数"""
        node.height = 1 + max(self._get_height(node.left), self._get_height(node.right))
        node.size = 1 + self._get_size(node.left) + self._get_size(node.right)

    def _rebalance(self, node):
        """从node结点开始（含node结点）逐个向上重新平衡二叉树，并更新结点高度和元素数"""
        while node is not None:
            old_height, old_size = node.height, node.size
            if not self._is_balanced(node):
                node = self._restructure(self._tall_grandchild(node))
                self._recompute(node.left)
                self._recompute(node.right)
            self._recompute(node)
            if node.height == old_height and node.size == old_size:
                node = None  # 如果结点高度和元素数都没有变化则不需要再继续向上调整
            else:
                node = node.parent

    def _is_balanced(self, node):
        """判断node结点是否平衡"""
        return abs(self._get_height(node.left) - self._get_height(node.right)) <= 1

    def _tall_child(self, node):
        """获取node结点更高的子树"""
        if self._get_height(node.left) > self._get_height(node.right):
            return node.left
        else:
            return node.right

    def _tall_grandchild(self, node):
        """获取node结点更高的子树中的更高的子树"""
        child = self._tall_child(node)
        return self._tall_child(child)

    @staticmethod
    def _relink(parent, child, is_left):
        """重新连接父结点和子结点（子结点允许为空）"""
        if is_left:
            parent.left = child
        else:
            parent.right = child
        if child is not None:
            child.parent = parent

    def _rotate(self, node):
        """旋转操作"""
        parent = node.parent
        grandparent = parent.parent
        if grandparent is None:
            self.root = node
            node.parent = None
        else:
            self._relink(grandparent, node, parent == grandparent.left)

        if node == parent.left:
            self._relink(parent, node.right, True)
            self._relink(node, parent, False)
        else:
            self._relink(parent, node.left, False)
            self._relink(node, parent, True)

    def _restructure(self, node):
        """trinode操作"""
        parent = node.parent
        grandparent = parent.parent

        if (node == parent.right) == (parent == grandparent.right):  # 处理需要一次旋转的情况
            self._rotate(parent)
            return parent
        else:  # 处理需要两次旋转的情况：第1次旋转后即成为需要一次旋转的情况
            self._rotate(node)
            self._rotate(node)
            return node

    @staticmethod
    def _subtree_first(node):
        """返回以node为根结点的子树的第1个元素"""
        while node.left is not None:
            node = node.left
        return node

    @staticmethod
    def _subtree_last(node):
        """返回以node为根结点的子树的最后1个元素"""
        while node.right is not None:
            node = node.right
        return node

    @staticmethod
    def _get_height(node) -> int:
        """获取以node为根结点的子树的高度"""
        return node.height if node is not None else 0

    @staticmethod
    def _get_size(node) -> int:
        """获取以node为根结点的子树的结点数"""
        return node.size if node is not None else 0


class Solution:
    def kthSmallest(self, root: TreeNode, k: int) -> int:
        def inorder(node):
            if node.left:
                inorder(node.left)
            inorder_lst.append(node.val)
            if node.right:
                inorder(node.right)

        # 中序遍历生成数值列表
        inorder_lst = []
        inorder(root)

        # 构造平衡二叉搜索树
        avl = AVL(inorder_lst)

        # 模拟1000次插入和删除操作
        random_nums = [random.randint(0, 10001) for _ in range(1000)]
        for num in random_nums:
            avl.insert(num)
        random.shuffle(random_nums)  # 列表乱序
        for num in random_nums:
            avl.delete(num)

        return avl.kth_smallest(k)
```

```Java [sol3-Java]
class Solution {
    public int kthSmallest(TreeNode root, int k) {
        // 中序遍历生成数值列表
        List<Integer> inorderList = new ArrayList<Integer>();
        inorder(root, inorderList);

        // 构造平衡二叉搜索树
        AVL avl = new AVL(inorderList);

        // 模拟1000次插入和删除操作
        int[] randomNums = new int[1000];
        Random random = new Random();
        for (int i = 0; i < 1000; ++i) {
            randomNums[i] = random.nextInt(10001);
            avl.insert(randomNums[i]);
        }
        shuffle(randomNums); // 列表乱序
        for (int i = 0; i < 1000; ++i) {
            avl.delete(randomNums[i]);
        }

        return avl.kthSmallest(k);
    }

    private void inorder(TreeNode node, List<Integer> inorderList) {
        if (node.left != null) {
            inorder(node.left, inorderList);
        }
        inorderList.add(node.val);
        if (node.right != null) {
            inorder(node.right, inorderList);
        }
    }

    private void shuffle(int[] arr) {
        Random random = new Random();
        int length = arr.length;
        for (int i = 0; i < length; i++) {
            int randIndex = random.nextInt(length);
            int temp = arr[i];
            arr[i] = arr[randIndex];
            arr[randIndex] = temp;
        }
    }
}

// 平衡二叉搜索树（AVL树）：允许重复值
class AVL {
    Node root;

    // 平衡二叉搜索树结点
    class Node {
        int val;
        Node parent;
        Node left;
        Node right;
        int size;
        int height;

        public Node(int val) {
            this(val, null);
        }

        public Node(int val, Node parent) {
            this(val, parent, null, null);
        }

        public Node(int val, Node parent, Node left, Node right) {
            this.val = val;
            this.parent = parent;
            this.left = left;
            this.right = right;
            this.height = 0; // 结点高度：以node为根节点的子树的高度（高度定义：叶结点的高度是0）
            this.size = 1; // 结点元素数：以node为根节点的子树的节点总数
        }
    }

    public AVL(List<Integer> vals) {
        if (vals != null) {
            this.root = build(vals, 0, vals.size() - 1, null);
        }
    }

    // 根据vals[l:r]构造平衡二叉搜索树 -> 返回根结点
    private Node build(List<Integer> vals, int l, int r, Node parent) {
        int m = (l + r) >> 1;
        Node node = new Node(vals.get(m), parent);
        if (l <= m - 1) {
            node.left = build(vals, l, m - 1, node);
        }
        if (m + 1 <= r) {
            node.right = build(vals, m + 1, r, node);
        }
        recompute(node);
        return node;
    }

    // 返回二叉搜索树中第k小的元素
    public int kthSmallest(int k) {
        Node node = root;
        while (node != null) {
            int left = getSize(node.left);
            if (left < k - 1) {
                node = node.right;
                k -= left + 1;
            } else if (left == k - 1) {
                break;
            } else {
                node = node.left;
            }
        }
        return node.val;
    }

    public void insert(int v) {
        if (root == null) {
            root = new Node(v);
        } else {
            // 计算新结点的添加位置
            Node node = subtreeSearch(root, v);
            boolean isAddLeft = v <= node.val; // 是否将新结点添加到node的左子结点
            if (node.val == v) { // 如果值为v的结点已存在
                if (node.left != null) { // 值为v的结点存在左子结点，则添加到其左子树的最右侧
                    node = subtreeLast(node.left);
                    isAddLeft = false;
                } else { // 值为v的结点不存在左子结点，则添加到其左子结点
                    isAddLeft = true;
                }
            }

            // 添加新结点
            Node leaf = new Node(v, node);
            if (isAddLeft) {
                node.left = leaf;
            } else {
                node.right = leaf;
            }

            rebalance(leaf);
        }
    }

    // 删除值为v的结点 -> 返回是否成功删除结点
    public boolean delete(int v) {
        if (root == null) {
            return false;
        }

        Node node = subtreeSearch(root, v);
        if (node.val != v) { // 没有找到需要删除的结点
            return false;
        }

        // 处理当前结点既有左子树也有右子树的情况
        // 若左子树比右子树高度低，则将当前结点替换为右子树最左侧的结点，并移除右子树最左侧的结点
        // 若右子树比左子树高度低，则将当前结点替换为左子树最右侧的结点，并移除左子树最右侧的结点
        if (node.left != null && node.right != null) {
            Node replacement = null;
            if (node.left.height <= node.right.height) {
                replacement = subtreeFirst(node.right);
            } else {
                replacement = subtreeLast(node.left);
            }
            node.val = replacement.val;
            node = replacement;
        }

        Node parent = node.parent;
        delete(node);
        rebalance(parent);
        return true;
    }

    // 删除结点p并用它的子结点代替它，结点p至多只能有1个子结点
    private void delete(Node node) {
        if (node.left != null && node.right != null) {
            return;
            // throw new Exception("Node has two children");
        }
        Node child = node.left != null ? node.left : node.right;
        if (child != null) {
            child.parent = node.parent;
        }
        if (node == root) {
            root = child;
        } else {
            Node parent = node.parent;
            if (node == parent.left) {
                parent.left = child;
            } else {
                parent.right = child;
            }
        }
        node.parent = node;
    }

    // 在以node为根结点的子树中搜索值为v的结点，如果没有值为v的结点，则返回值为v的结点应该在的位置的父结点
    private Node subtreeSearch(Node node, int v) {
        if (node.val < v && node.right != null) {
            return subtreeSearch(node.right, v);
        } else if (node.val > v && node.left != null) {
            return subtreeSearch(node.left, v);
        } else {
            return node;
        }
    }

    // 重新计算node结点的高度和元素数
    private void recompute(Node node) {
        node.height = 1 + Math.max(getHeight(node.left), getHeight(node.right));
        node.size = 1 + getSize(node.left) + getSize(node.right);
    }

    // 从node结点开始（含node结点）逐个向上重新平衡二叉树，并更新结点高度和元素数
    private void rebalance(Node node) {
        while (node != null) {
            int oldHeight = node.height, oldSize = node.size;
            if (!isBalanced(node)) {
                node = restructure(tallGrandchild(node));
                recompute(node.left);
                recompute(node.right);
            }
            recompute(node);
            if (node.height == oldHeight && node.size == oldSize) {
                node = null; // 如果结点高度和元素数都没有变化则不需要再继续向上调整
            } else {
                node = node.parent;
            }
        }
    }

    // 判断node结点是否平衡
    private boolean isBalanced(Node node) {
        return Math.abs(getHeight(node.left) - getHeight(node.right)) <= 1;
    }

    // 获取node结点更高的子树
    private Node tallChild(Node node) {
        if (getHeight(node.left) > getHeight(node.right)) {
            return node.left;
        } else {
            return node.right;
        }
    }

    // 获取node结点更高的子树中的更高的子树
    private Node tallGrandchild(Node node) {
        Node child = tallChild(node);
        return tallChild(child);
    }

    // 重新连接父结点和子结点（子结点允许为空）
    private static void relink(Node parent, Node child, boolean isLeft) {
        if (isLeft) {
            parent.left = child;
        } else {
            parent.right = child;
        }
        if (child != null) {
            child.parent = parent;
        }
    }

    // 旋转操作
    private void rotate(Node node) {
        Node parent = node.parent;
        Node grandparent = parent.parent;
        if (grandparent == null) {
            root = node;
            node.parent = null;
        } else {
            relink(grandparent, node, parent == grandparent.left);
        }

        if (node == parent.left) {
            relink(parent, node.right, true);
            relink(node, parent, false);
        } else {
            relink(parent, node.left, false);
            relink(node, parent, true);
        }
    }

    // trinode操作
    private Node restructure(Node node) {
        Node parent = node.parent;
        Node grandparent = parent.parent;

        if ((node == parent.right) == (parent == grandparent.right)) { // 处理需要一次旋转的情况
            rotate(parent);
            return parent;
        } else { // 处理需要两次旋转的情况：第1次旋转后即成为需要一次旋转的情况
            rotate(node);
            rotate(node);
            return node;
        }
    }

    // 返回以node为根结点的子树的第1个元素
    private static Node subtreeFirst(Node node) {
        while (node.left != null) {
            node = node.left;
        }
        return node;
    }

    // 返回以node为根结点的子树的最后1个元素
    private static Node subtreeLast(Node node) {
        while (node.right != null) {
            node = node.right;
        }
        return node;
    }

    // 获取以node为根结点的子树的高度
    private static int getHeight(Node node) {
        return node != null ? node.height : 0;
    }

    // 获取以node为根结点的子树的结点数
    private static int getSize(Node node) {
        return node != null ? node.size : 0;
    }
}
```

```C# [sol3-C#]
public class Solution {
    public int KthSmallest(TreeNode root, int k) {
        // 中序遍历生成数值列表
        IList<int> inorderList = new List<int>();
        Inorder(root, inorderList);

        // 构造平衡二叉搜索树
        AVL avl = new AVL(inorderList);

        // 模拟1000次插入和删除操作
        int[] randomNums = new int[1000];
        Random random = new Random();
        for (int i = 0; i < 1000; ++i) {
            randomNums[i] = random.Next(10001);
            avl.Insert(randomNums[i]);
        }
        Shuffle(randomNums); // 列表乱序
        for (int i = 0; i < 1000; ++i) {
            avl.Delete(randomNums[i]);
        }

        return avl.KthSmallest(k);
    }

    private void Inorder(TreeNode node, IList<int> inorderList) {
        if (node.left != null) {
            Inorder(node.left, inorderList);
        }
        inorderList.Add(node.val);
        if (node.right != null) {
            Inorder(node.right, inorderList);
        }
    }

    private void Shuffle(int[] arr) {
        Random random = new Random();
        int length = arr.Length;
        for (int i = 0; i < length; i++) {
            int randIndex = random.Next(length);
            int temp = arr[i];
            arr[i] = arr[randIndex];
            arr[randIndex] = temp;
        }
    }
}

// 平衡二叉搜索树（AVL树）：允许重复值
class AVL {
    Node root;

    // 平衡二叉搜索树结点
    class Node {
        public int val;
        public Node parent;
        public Node left;
        public Node right;
        public int size;
        public int height;

        public Node(int val) : this(val, null) {
        }

        public Node(int val, Node parent) : this(val, parent, null, null) {
        }

        public Node(int val, Node parent, Node left, Node right) {
            this.val = val;
            this.parent = parent;
            this.left = left;
            this.right = right;
            this.height = 0; // 结点高度：以node为根节点的子树的高度（高度定义：叶结点的高度是0）
            this.size = 1; // 结点元素数：以node为根节点的子树的节点总数
        }
    }

    public AVL(IList<int> vals) {
        if (vals != null) {
            this.root = Build(vals, 0, vals.Count - 1, null);
        }
    }

    // 根据vals[l:r]构造平衡二叉搜索树 -> 返回根结点
    private Node Build(IList<int> vals, int l, int r, Node parent) {
        int m = (l + r) >> 1;
        Node node = new Node(vals[m], parent);
        if (l <= m - 1) {
            node.left = Build(vals, l, m - 1, node);
        }
        if (m + 1 <= r) {
            node.right = Build(vals, m + 1, r, node);
        }
        Recompute(node);
        return node;
    }

    // 返回二叉搜索树中第k小的元素
    public int KthSmallest(int k) {
        Node node = root;
        while (node != null) {
            int left = GetSize(node.left);
            if (left < k - 1) {
                node = node.right;
                k -= left + 1;
            } else if (left == k - 1) {
                break;
            } else {
                node = node.left;
            }
        }
        return node.val;
    }

    public void Insert(int v) {
        if (root == null) {
            root = new Node(v);
        } else {
            // 计算新结点的添加位置
            Node node = SubtreeSearch(root, v);
            bool isAddLeft = v <= node.val; // 是否将新结点添加到node的左子结点
            if (node.val == v) { // 如果值为v的结点已存在
                if (node.left != null) { // 值为v的结点存在左子结点，则添加到其左子树的最右侧
                    node = SubtreeLast(node.left);
                    isAddLeft = false;
                } else { // 值为v的结点不存在左子结点，则添加到其左子结点
                    isAddLeft = true;
                }
            }

            // 添加新结点
            Node leaf = new Node(v, node);
            if (isAddLeft) {
                node.left = leaf;
            } else {
                node.right = leaf;
            }

            Rebalance(leaf);
        }
    }

    // 删除值为v的结点 -> 返回是否成功删除结点
    public bool Delete(int v) {
        if (root == null) {
            return false;
        }

        Node node = SubtreeSearch(root, v);
        if (node.val != v) { // 没有找到需要删除的结点
            return false;
        }

        // 处理当前结点既有左子树也有右子树的情况
        // 若左子树比右子树高度低，则将当前结点替换为右子树最左侧的结点，并移除右子树最左侧的结点
        // 若右子树比左子树高度低，则将当前结点替换为左子树最右侧的结点，并移除左子树最右侧的结点
        if (node.left != null && node.right != null) {
            Node replacement = null;
            if (node.left.height <= node.right.height) {
                replacement = SubtreeFirst(node.right);
            } else {
                replacement = SubtreeLast(node.left);
            }
            node.val = replacement.val;
            node = replacement;
        }

        Node parent = node.parent;
        Delete(node);
        Rebalance(parent);
        return true;
    }

    // 删除结点p并用它的子结点代替它，结点p至多只能有1个子结点
    private void Delete(Node node) {
        if (node.left != null && node.right != null) {
            return;
            // throw new Exception("Node has two children");
        }
        Node child = node.left != null ? node.left : node.right;
        if (child != null) {
            child.parent = node.parent;
        }
        if (node == root) {
            root = child;
        } else {
            Node parent = node.parent;
            if (node == parent.left) {
                parent.left = child;
            } else {
                parent.right = child;
            }
        }
        node.parent = node;
    }

    // 在以node为根结点的子树中搜索值为v的结点，如果没有值为v的结点，则返回值为v的结点应该在的位置的父结点
    private Node SubtreeSearch(Node node, int v) {
        if (node.val < v && node.right != null) {
            return SubtreeSearch(node.right, v);
        } else if (node.val > v && node.left != null) {
            return SubtreeSearch(node.left, v);
        } else {
            return node;
        }
    }

    // 重新计算node结点的高度和元素数
    private void Recompute(Node node) {
        node.height = 1 + Math.Max(GetHeight(node.left), GetHeight(node.right));
        node.size = 1 + GetSize(node.left) + GetSize(node.right);
    }

    // 从node结点开始（含node结点）逐个向上重新平衡二叉树，并更新结点高度和元素数
    private void Rebalance(Node node) {
        while (node != null) {
            int oldHeight = node.height, oldSize = node.size;
            if (!IsBalanced(node)) {
                node = Restructure(TallGrandchild(node));
                Recompute(node.left);
                Recompute(node.right);
            }
            Recompute(node);
            if (node.height == oldHeight && node.size == oldSize) {
                node = null; // 如果结点高度和元素数都没有变化则不需要再继续向上调整
            } else {
                node = node.parent;
            }
        }
    }

    // 判断node结点是否平衡
    private bool IsBalanced(Node node) {
        return Math.Abs(GetHeight(node.left) - GetHeight(node.right)) <= 1;
    }

    // 获取node结点更高的子树
    private Node TallChild(Node node) {
        if (GetHeight(node.left) > GetHeight(node.right)) {
            return node.left;
        } else {
            return node.right;
        }
    }

    // 获取node结点更高的子树中的更高的子树
    private Node TallGrandchild(Node node) {
        Node child = TallChild(node);
        return TallChild(child);
    }

    // 重新连接父结点和子结点（子结点允许为空）
    private static void Relink(Node parent, Node child, bool isLeft) {
        if (isLeft) {
            parent.left = child;
        } else {
            parent.right = child;
        }
        if (child != null) {
            child.parent = parent;
        }
    }

    // 旋转操作
    private void Rotate(Node node) {
        Node parent = node.parent;
        Node grandparent = parent.parent;
        if (grandparent == null) {
            root = node;
            node.parent = null;
        } else {
            Relink(grandparent, node, parent == grandparent.left);
        }

        if (node == parent.left) {
            Relink(parent, node.right, true);
            Relink(node, parent, false);
        } else {
            Relink(parent, node.left, false);
            Relink(node, parent, true);
        }
    }

    // trinode操作
    private Node Restructure(Node node) {
        Node parent = node.parent;
        Node grandparent = parent.parent;

        if ((node == parent.right) == (parent == grandparent.right)) { // 处理需要一次旋转的情况
            Rotate(parent);
            return parent;
        } else { // 处理需要两次旋转的情况：第1次旋转后即成为需要一次旋转的情况
            Rotate(node);
            Rotate(node);
            return node;
        }
    }

    // 返回以node为根结点的子树的第1个元素
    private static Node SubtreeFirst(Node node) {
        while (node.left != null) {
            node = node.left;
        }
        return node;
    }

    // 返回以node为根结点的子树的最后1个元素
    private static Node SubtreeLast(Node node) {
        while (node.right != null) {
            node = node.right;
        }
        return node;
    }

    // 获取以node为根结点的子树的高度
    private static int GetHeight(Node node) {
        return node != null ? node.height : 0;
    }

    // 获取以node为根结点的子树的结点数
    private static int GetSize(Node node) {
        return node != null ? node.size : 0;
    }
}
```

```C++ [sol3-C++]
// 平衡二叉搜索树结点
struct Node {
    int val;
    Node * parent;
    Node * left;
    Node * right;
    int size;
    int height;

    Node(int val) {
        this->val = val;
        this->parent = nullptr;
        this->left = nullptr;
        this->right = nullptr;
        this->height = 0; // 结点高度：以node为根节点的子树的高度（高度定义：叶结点的高度是0）
        this->size = 1; // 结点元素数：以node为根节点的子树的节点总数
    }

    Node(int val, Node * parent) {
        this->val = val;
        this->parent = parent;
        this->left = nullptr;
        this->right = nullptr;
        this->height = 0; // 结点高度：以node为根节点的子树的高度（高度定义：叶结点的高度是0）
        this->size = 1; // 结点元素数：以node为根节点的子树的节点总数
    }

    Node(int val, Node * parent, Node * left, Node * right) {
        this->val = val;
        this->parent = parent;
        this->left = left;
        this->right = right;
        this->height = 0; // 结点高度：以node为根节点的子树的高度（高度定义：叶结点的高度是0）
        this->size = 1; // 结点元素数：以node为根节点的子树的节点总数
    }
};


// 平衡二叉搜索树（AVL树）：允许重复值
class AVL {
public:
    AVL(vector<int> & vals) {
        if (!vals.empty()) {
            root = build(vals, 0, vals.size() - 1, nullptr);
        }
    }

    // 根据vals[l:r]构造平衡二叉搜索树 -> 返回根结点
    Node * build(vector<int> & vals, int l, int r, Node * parent) {
        int m = (l + r) >> 1;
        Node * node = new Node(vals[m], parent);
        if (l <= m - 1) {
            node->left = build(vals, l, m - 1, node);
        }
        if (m + 1 <= r) {
            node->right = build(vals, m + 1, r, node);
        }
        recompute(node);
        return node;
    }

    // 返回二叉搜索树中第k小的元素
    int kthSmallest(int k) {
        Node * node = root;
        while (node != nullptr) {
            int left = getSize(node->left);
            if (left < k - 1) {
                node = node->right;
                k -= left + 1;
            } else if (left == k - 1) {
                break;
            } else {
                node = node->left;
            }
        }
        return node->val;
    }

    void insert(int v) {
        if (root == nullptr) {
            root = new Node(v);
        } else {
            // 计算新结点的添加位置
            Node * node = subtreeSearch(root, v);
            bool isAddLeft = v <= node->val; // 是否将新结点添加到node的左子结点
            if (node->val == v) { // 如果值为v的结点已存在
                if (node->left != nullptr) { // 值为v的结点存在左子结点，则添加到其左子树的最右侧
                    node = subtreeLast(node->left);
                    isAddLeft = false;
                } else { // 值为v的结点不存在左子结点，则添加到其左子结点
                    isAddLeft = true;
                }
            }

            // 添加新结点
            Node * leaf = new Node(v, node);
            if (isAddLeft) {
                node->left = leaf;
            } else {
                node->right = leaf;
            }

            rebalance(leaf);
        }
    }

    // 删除值为v的结点 -> 返回是否成功删除结点
    bool Delete(int v) {
        if (root == nullptr) {
            return false;
        }

        Node * node = subtreeSearch(root, v);
        if (node->val != v) { // 没有找到需要删除的结点
            return false;
        }

        // 处理当前结点既有左子树也有右子树的情况
        // 若左子树比右子树高度低，则将当前结点替换为右子树最左侧的结点，并移除右子树最左侧的结点
        // 若右子树比左子树高度低，则将当前结点替换为左子树最右侧的结点，并移除左子树最右侧的结点
        if (node->left != nullptr && node->right != nullptr) {
            Node * replacement = nullptr;
            if (node->left->height <= node->right->height) {
                replacement = subtreeFirst(node->right);
            } else {
                replacement = subtreeLast(node->left);
            }
            node->val = replacement->val;
            node = replacement;
        }

        Node * parent = node->parent;
        Delete(node);
        rebalance(parent);
        return true;
    }

private:
    Node * root;

    // 删除结点p并用它的子结点代替它，结点p至多只能有1个子结点
    void Delete(Node * node) {
        if (node->left != nullptr && node->right != nullptr) {
            return;
            // throw new Exception("Node has two children");
        }
        Node * child = node->left != nullptr ? node->left : node->right;
        if (child != nullptr) {
            child->parent = node->parent;
        }
        if (node == root) {
            root = child;
        } else {
            Node * parent = node->parent;
            if (node == parent->left) {
                parent->left = child;
            } else {
                parent->right = child;
            }
        }
        node->parent = node;
    }

    // 在以node为根结点的子树中搜索值为v的结点，如果没有值为v的结点，则返回值为v的结点应该在的位置的父结点
    Node * subtreeSearch(Node * node, int v) {
        if (node->val < v && node->right != nullptr) {
            return subtreeSearch(node->right, v);
        } else if (node->val > v && node->left != nullptr) {
            return subtreeSearch(node->left, v);
        } else {
            return node;
        }
    }

    // 重新计算node结点的高度和元素数
    void recompute(Node * node) {
        node->height = 1 + max(getHeight(node->left), getHeight(node->right));
        node->size = 1 + getSize(node->left) + getSize(node->right);
    }

    // 从node结点开始（含node结点）逐个向上重新平衡二叉树，并更新结点高度和元素数
    void rebalance(Node * node) {
        while (node != nullptr) {
            int oldHeight = node->height, oldSize = node->size;
            if (!isBalanced(node)) {
                node = restructure(tallGrandchild(node));
                recompute(node->left);
                recompute(node->right);
            }
            recompute(node);
            if (node->height == oldHeight && node->size == oldSize) {
                node = nullptr; // 如果结点高度和元素数都没有变化则不需要再继续向上调整
            } else {
                node = node->parent;
            }
        }
    }

    // 判断node结点是否平衡
    bool isBalanced(Node * node) {
        return abs(getHeight(node->left) - getHeight(node->right)) <= 1;
    }

    // 获取node结点更高的子树
    Node * tallChild(Node * node) {
        if (getHeight(node->left) > getHeight(node->right)) {
            return node->left;
        } else {
            return node->right;
        }
    }

    // 获取node结点更高的子树中的更高的子树
    Node * tallGrandchild(Node * node) {
        Node * child = tallChild(node);
        return tallChild(child);
    }

    // 重新连接父结点和子结点（子结点允许为空）
    static void relink(Node * parent, Node * child, bool isLeft) {
        if (isLeft) {
            parent->left = child;
        } else {
            parent->right = child;
        }
        if (child != nullptr) {
            child->parent = parent;
        }
    }

    // 旋转操作
    void rotate(Node * node) {
        Node * parent = node->parent;
        Node * grandparent = parent->parent;
        if (grandparent == nullptr) {
            root = node;
            node->parent = nullptr;
        } else {
            relink(grandparent, node, parent == grandparent->left);
        }

        if (node == parent->left) {
            relink(parent, node->right, true);
            relink(node, parent, false);
        } else {
            relink(parent, node->left, false);
            relink(node, parent, true);
        }
    }

    // trinode操作
    Node * restructure(Node * node) {
        Node * parent = node->parent;
        Node * grandparent = parent->parent;

        if ((node == parent->right) == (parent == grandparent->right)) { // 处理需要一次旋转的情况
            rotate(parent);
            return parent;
        } else { // 处理需要两次旋转的情况：第1次旋转后即成为需要一次旋转的情况
            rotate(node);
            rotate(node);
            return node;
        }
    }

    // 返回以node为根结点的子树的第1个元素
    static Node * subtreeFirst(Node * node) {
        while (node->left != nullptr) {
            node = node->left;
        }
        return node;
    }

    // 返回以node为根结点的子树的最后1个元素
    static Node * subtreeLast(Node * node) {
        while (node->right != nullptr) {
            node = node->right;
        }
        return node;
    }

    // 获取以node为根结点的子树的高度
    static int getHeight(Node * node) {
        return node != nullptr ? node->height : 0;
    }

    // 获取以node为根结点的子树的结点数
    static int getSize(Node * node) {
        return node != nullptr ? node->size : 0;
    }
};

class Solution {
public:
    int kthSmallest(TreeNode * root, int k) {
        // 中序遍历生成数值列表
        vector<int> inorderList;
        inorder(root, inorderList);
        // 构造平衡二叉搜索树
        AVL avl(inorderList);

        // 模拟1000次插入和删除操作
        vector<int> randomNums(1000);
        std::random_device rd;
        for (int i = 0; i < 1000; ++i) {
            randomNums[i] = rd()%(10001);
            avl.insert(randomNums[i]);
        }
        shuffle(randomNums); // 列表乱序
        for (int i = 0; i < 1000; ++i) {
            avl.Delete(randomNums[i]);
        }

        return avl.kthSmallest(k);
    }

private:
    void inorder(TreeNode * node, vector<int> & inorderList) {
        if (node->left != nullptr) {
            inorder(node->left, inorderList);
        }
        inorderList.push_back(node->val);
        if (node->right != nullptr) {
            inorder(node->right, inorderList);
        }
    }

    void shuffle(vector<int> & arr) {
        std::random_device rd;
        int length = arr.size();
        for (int i = 0; i < length; i++) {
            int randIndex = rd()%length;
            swap(arr[i],arr[randIndex]);
        }
    }
};
```

**复杂度分析**

- 时间复杂度：预处理的时间复杂度为 $O(N)$，其中 $N$ 是树中结点的总数。插入、删除和搜索的时间复杂度均为 $O(\log N)$。

- 空间复杂度：$O(N)$，用于存储平衡二叉搜索树。
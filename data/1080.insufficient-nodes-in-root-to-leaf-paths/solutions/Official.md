## [1080.根到叶路径上的不足节点 中文官方题解](https://leetcode.cn/problems/insufficient-nodes-in-root-to-leaf-paths/solutions/100000/gen-dao-xie-lu-jing-shang-de-bu-zu-jie-d-f4vz)

#### 方法一：深度优先搜索

**思路与算法**

根据题意可知「不足节点」的定义为：通过节点 $\textit{node}$ 的每种可能的「根-叶」路径上值的总和全都小于给定的 $\textit{limit}$，则该节点被称之为「不足节点」。
按照上述定义可知：
+ 假设节点 $\textit{node}$ 为根的子树中所有的叶子节点均为「不足节点」，则可以推断出 $\textit{node}$ 一定也为「不足节点」，即经过该节点所有“根-叶” 路径的总和都小于 $\textit{limit}$，此时该节点需要删除；
+ 假设节点 $\textit{node}$ 为根的子树中存在叶子节点不是「不足节点」，则可以推断出 $\textit{node}$ 一定也不是「不足节点」，因为此时一定存一条从根节点到叶子节点的路径和大于等于 $\textit{limit}$，此时该节点需要保留。

根据上述的分析，我们用 $\text{checkSufficientLeaf}(\textit{node})$ 来检测 $\textit{node}$ 节点为子树是否含有叶子节点不为「不足节点」，每次进行深度优先搜索时并传入当前的路径和 $\textit{sum}$，每次检测过程如下：
+ 如果当前节点 $\textit{node}$ 为叶子节点，则当前 “根-叶” 路径和为 $\textit{sum}$ 加上 $node$ 节点的值，如果当前的路径和小于 $\textit{limit}$，则该叶子 $\textit{node}$ 一定为「不足节点」，返回 $\text{false}$，否则该节点一定不为「不足节点」，返回 $\text{true}$；
+ 依次检测 $\textit{node}$ 节点的左子树与右子树，如果当前节点 $\textit{node}$ 的左子树中的叶子节点均为「不足节点」，则左孩子需要删除，否则需要保留；如果当前节点 $\textit{node}$ 的右子树中的叶子节点均为「不足节点」，则右孩子需要删除，否则需要保留。如果当前子树中的所有叶子节点均为「不足节点」则当前节点需要删除，否则当前节点需要保留。
+ 最终检测 $\textit{root}$ 的叶子节点是否均为「不足节点」，如果是则返回 $\text{null}$，否则返回 $\textit{root}$。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    bool checkSufficientLeaf(TreeNode *node, int sum, int limit) {
        if (!node) {
            return false;
        }
        if (node->left == nullptr && node->right == nullptr) {
            return node->val + sum >= limit;
        }
        bool haveSufficientLeft = checkSufficientLeaf(node->left, sum + node->val, limit);
        bool haveSufficientRight = checkSufficientLeaf(node->right, sum + node->val, limit);
        if (!haveSufficientLeft) {
            node->left = nullptr;
        }
        if (!haveSufficientRight) {
            node->right = nullptr;
        }
        return haveSufficientLeft || haveSufficientRight;
    }

    TreeNode* sufficientSubset(TreeNode* root, int limit) {
        bool haveSufficient = checkSufficientLeaf(root, 0, limit);
        return haveSufficient ? root : nullptr;
    }
};
```

```Java [sol1-Java]
class Solution {
    public TreeNode sufficientSubset(TreeNode root, int limit) {
        boolean haveSufficient = checkSufficientLeaf(root, 0, limit);
        return haveSufficient ? root : null;
    }

    public boolean checkSufficientLeaf(TreeNode node, int sum, int limit) {
        if (node == null) {
            return false;
        }
        if (node.left == null && node.right == null) {
            return node.val + sum >= limit;
        }
        boolean haveSufficientLeft = checkSufficientLeaf(node.left, sum + node.val, limit);
        boolean haveSufficientRight = checkSufficientLeaf(node.right, sum + node.val, limit);
        if (!haveSufficientLeft) {
            node.left = null;
        }
        if (!haveSufficientRight) {
            node.right = null;
        }
        return haveSufficientLeft || haveSufficientRight;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def sufficientSubset(self, root: Optional[TreeNode], limit: int) -> Optional[TreeNode]:
        def checkSufficientLeaf(node, sum, limit):
            if node == None:
                return False
            if node.left == None and node.right == None:
                return node.val + sum >= limit
            haveSufficientLeft = checkSufficientLeaf(node.left, sum + node.val, limit)
            haveSufficientRight = checkSufficientLeaf(node.right, sum + node.val, limit)
            if not haveSufficientLeft:
                node.left = None
            if not haveSufficientRight:
                node.right = None
            return haveSufficientLeft or haveSufficientRight
        haveSufficient = checkSufficientLeaf(root, 0, limit)
        return  root if haveSufficient else None
```

```Go [sol1-Go]
func sufficientSubset(root *TreeNode, limit int) *TreeNode {
    haveSufficient := checkSufficientLeaf(root, 0, limit)
    if haveSufficient {
        return root
    } else {
        return nil
    }
}

func checkSufficientLeaf(node *TreeNode, sum int, limit int) bool {
    if node == nil {
        return false
    }
    if node.Left == nil && node.Right == nil {
        return node.Val+sum >= limit
    }
    haveSufficientLeft := checkSufficientLeaf(node.Left, sum+node.Val, limit)
    haveSufficientRight := checkSufficientLeaf(node.Right, sum+node.Val, limit)
    if !haveSufficientLeft {
        node.Left = nil
    }
    if !haveSufficientRight {
        node.Right = nil
    }
    return haveSufficientLeft || haveSufficientRight
}
```

```JavaScript [sol1-JavaScript]
var sufficientSubset = function(root, limit) {
    const haveSufficient = checkSufficientLeaf(root, 0, limit);
    return haveSufficient ? root : null;
};

var checkSufficientLeaf = function(node, sum, limit) {
    if (node == null) {
        return false;
    }
    if (node.left == null && node.right == null) {
        return node.val + sum >= limit;
    }
    const haveSufficientLeft = checkSufficientLeaf(node.left, sum + node.val, limit);
    const haveSufficientRight = checkSufficientLeaf(node.right, sum + node.val, limit);
    if (!haveSufficientLeft) {
        node.left = null;
    }
    if (!haveSufficientRight) {
        node.right = null;
    }
    return haveSufficientLeft || haveSufficientRight;
};
```

```C# [sol1-C#]
public class Solution {
    public TreeNode SufficientSubset(TreeNode root, int limit) {
        bool haveSufficient = CheckSufficientLeaf(root, 0, limit);
        return haveSufficient ? root : null;
    }

    public bool CheckSufficientLeaf(TreeNode node, int sum, int limit) {
        if (node == null) {
            return false;
        }
        if (node.left == null && node.right == null) {
            return node.val + sum >= limit;
        }
        bool haveSufficientLeft = CheckSufficientLeaf(node.left, sum + node.val, limit);
        bool haveSufficientRight = CheckSufficientLeaf(node.right, sum + node.val, limit);
        if (!haveSufficientLeft) {
            node.left = null;
        }
        if (!haveSufficientRight) {
            node.right = null;
        }
        return haveSufficientLeft || haveSufficientRight;
    }
}
```

```C [sol1-C]
bool checkSufficientLeaf(struct TreeNode *node, int sum, int limit) {
    if (!node) {
        return false;
    }
    if (node->left == NULL && node->right == NULL) {
        return node->val + sum >= limit;
    }
    bool haveSufficientLeft = checkSufficientLeaf(node->left, sum + node->val, limit);
    bool haveSufficientRight = checkSufficientLeaf(node->right, sum + node->val, limit);
    if (!haveSufficientLeft) {
        node->left = NULL;
    }
    if (!haveSufficientRight) {
        node->right = NULL;
    }
    return haveSufficientLeft || haveSufficientRight;
}

struct TreeNode* sufficientSubset(struct TreeNode* root, int limit){
    bool haveSufficient = checkSufficientLeaf(root, 0, limit);
    return haveSufficient ? root : NULL;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示树中节点的数目。对于每个节点我们只需遍历一次即可，因此需要的时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 表示树中节点的数目。由于递归需要占用空间，此时空间复杂度取决于树的高度，最优情况下树的高度为 $\log n$，此时需要的空间为 $O(\log n)$，最差情况下树的高度为 $n$，此时需要的空间为 $O(n)$，因此空间复杂度为 $O(n)$。
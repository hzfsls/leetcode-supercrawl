## [979.在二叉树中分配硬币 中文官方题解](https://leetcode.cn/problems/distribute-coins-in-binary-tree/solutions/100000/zai-er-cha-shu-zhong-fen-pei-ying-bi-by-e4poq)
#### 方法一：深度优先搜索

**思路与算法**

题目中要求求出移动步数，设 $\textit{dfs}(a)$ 表示若使得以 $a$ 为根节点的子树满足每个节点均只有一个金币时，节点 $a$ 的父节点需要从节点 $a$ 「拿走」的金币数目，我们可以定义如下：
+ 如果 $\textit{dfs}(a) > 0$，则表示节点 $a$ 需要向 $a$ 的父节点移动 $\textit{dfs}(a)$ 个金币；
+ 如果 $\textit{dfs}(a) = 0$，则表示节点 $a$ 与 $a$ 的父节点之间不需要移动；
+ 如果 $\textit{dfs}(a) < 0$，则表示节点 $a$ 的父节点需要向 $a$ 移动 $|\textit{dfs}(a)|$ 个金币；
+ 综上可知道无论哪个方向移动，节点 $a$ 与其父节点之间的金币移动此时一定为 $|\textit{dfs}(a)|$；

设 $\textit{count}(a)$ 表示当以节点 $a$ 为根节点的子树中含有的二叉树节点数目，设 $\textit{sum}(a)$ 表示以节点 $a$ 为根节点的子树中含有的二叉树节点的值之和，此时可以知道 $\textit{dfs}(a) = \textit{sum}(a) - \textit{count}(a)$，则可以按照以下几种情形分析：
+ 假设 $\textit{sum}(a) > \textit{count}(a)$，即此时子树中金币总数量大于节点的总数量，此时需要向 $a$ 的父节点移动 $\textit{sum}(a) - \textit{count}(a)$ 个金币；
+ 假设 $\textit{sum}(\textit{a}) < \textit{count}(a)$，即此时子树中金币总数量小于节点的总数量，此时需要从 $a$ 的父节点需要移动 $\textit{count}(a) - \textit{sum}(a)$ 个金币；
+ 假设 $\textit{sum}(a) = \textit{count}(a)$，即此时子树中金币总数量等于节点的总数量，此时 $a$ 的父节点与 $a$ 之间不需要移动即可，最优策略一定是 $a$ 的左子树与右子树之间的金币互相移动即可，此处不再证明；

假设当前节点为 $\textit{node}$，设 $\textit{val}(\textit{node})$ 表示节点 $\textit{node}$ 初始时的金币数目，它的左孩子为 $\textit{left}$，它的右孩子为 $\textit{right}$，则此时可以知道如下：
+ 若要使得左子树每个节点的数目均为 $1$，此时 $\textit{node}$ 需要从 $\textit{left}$「拿走」的为金币数目 $\textit{dfs}(\textit{left})$，此时 $\textit{left}$ 与 $\textit{node}$ 之间需要移动 $|\textit{dfs}(\textit{left})|$ 次金币；
+ 若要使得右子树每个节点的数目均为 $1$，此时 $\textit{node}$ 需要从 $\textit{right}$「拿走」的金币数目 $\textit{dfs}(\textit{right})$，此时 $\textit{right}$ 与 $\textit{node}$ 之间需要移动 $|\textit{dfs}(\textit{right})|$ 次金币；
+ 此时根节点的金币总数目即为 $\textit{move}(\textit{left}) + \textit{move}(\textit{right}) + \textit{val}(\textit{node})$，由于 $\textit{node}$ 本身需要保留一个金币，此时 $\textit{node}$ 的根节点需要向它「拿走」的金币数目即为 $\textit{move}(\textit{left}) + \textit{move}(\textit{right}) + \textit{val}(\textit{node}) - 1$；

综上我们采用递归，每次递归遍历节点 $\textit{node}$ 时，返回其父节点需要从 $\textit{node}$ 「拿走」的金币数目，并统计当前节点与其子节点之间的移动金币的次数，我们通过递归遍历即可求得所有节点与其父节点之间的移动金币的次数统计之和即为总的金币移动次数。
+ 由于本题中树中金币的数目与树中节点的数目相等，根据上述推论可以知道根节点 $\textit{root}$ 一定不需要再向其父节点移动金币。

**代码**

```C++ [sol1-C++]
class Solution {
public:    
    int distributeCoins(TreeNode* root) {
        int move = 0;

        function<int(const TreeNode *)> dfs = [&](const TreeNode *root) -> int {
            int moveleft = 0;
            int moveright = 0;
            if (root == nullptr) {
                return 0;
            }
            if (root->left) {
                moveleft = dfs(root->left);
            }        
            if (root->right) {
                moveright = dfs(root->right);
            }
            move += abs(moveleft) + abs(moveright);
            return moveleft + moveright + root->val - 1;
        };

        dfs(root);
        return move;
    }
};
```

```Java [sol1-Java]
class Solution {
    int move = 0;

    public int distributeCoins(TreeNode root) {
        dfs(root);
        return move;
    }

    public int dfs(TreeNode root) {
        int moveleft = 0;
        int moveright = 0;
        if (root == null) {
            return 0;
        }
        if (root.left != null) {
            moveleft = dfs(root.left);
        }        
        if (root.right != null) {
            moveright = dfs(root.right);
        }
        move += Math.abs(moveleft) + Math.abs(moveright);
        return moveleft + moveright + root.val - 1;
    }
}
```

```C# [sol1-C#]
public class Solution {
    int move = 0;

    public int DistributeCoins(TreeNode root) {
        DFS(root);
        return move;
    }

    public int DFS(TreeNode root) {
        int moveleft = 0;
        int moveright = 0;
        if (root == null) {
            return 0;
        }
        if (root.left != null) {
            moveleft = DFS(root.left);
        }        
        if (root.right != null) {
            moveright = DFS(root.right);
        }
        move += Math.Abs(moveleft) + Math.Abs(moveright);
        return moveleft + moveright + root.val - 1;
    }
}
```

```Python [sol1-Python3]
class Solution:
    move = 0

    def distributeCoins(self, root: Optional[TreeNode]) -> int:
        def dfs(root):
            moveleft = 0
            moveright = 0
            if root is None:
                return 0
            if root.left is not None:
                moveleft = dfs(root.left)
            if root.right is not None:
                moveright = dfs(root.right)
            self.move += abs(moveleft) + abs(moveright)
            return moveleft + moveright + root.val - 1

        dfs(root)
        return self.move

```

```Go [sol1-Go]
var move int

func distributeCoins(root *TreeNode) int {
    move = 0
    dfs(root)
    return move
}

func dfs(root *TreeNode) int {
    moveleft := 0
    moveright := 0
    if root == nil {
        return 0
    }
    if root.Left != nil {
         moveleft = dfs(root.Left)
    }
    if root.Right != nil {
        moveright = dfs(root.Right)
    }
    move += abs(moveleft) + abs(moveright)
    return moveleft + moveright + root.Val - 1
}

func abs(a int) int {
    if a < 0 {
        a = -a
    }
    return a
}
```

```JavaScript [sol1-JavaScript]
let move;

var distributeCoins = function(root) {
    move = 0;
    dfs(root);
    return move;
};

function dfs(root) {
    let moveleft = 0;
    let moveright = 0;
    if (root === null) {
        return 0;
    }
    if (root.left !== null) {
        moveleft = dfs(root.left);
    }
    if (root.right !== null) {
        moveright = dfs(root.right);
    }
    move += Math.abs(moveleft) + Math.abs(moveright);
    return moveleft + moveright + root.val - 1;
}
```

```C [sol1-C]
int dfs(const struct TreeNode* root, int *move) {
    int moveleft = 0;
    int moveright = 0;
    if (root == NULL) {
        return 0;
    }
    if (root->left) {
        moveleft = dfs(root->left, move);
    }        
    if (root->right) {
        moveright = dfs(root->right, move);
    }
    (*move) += abs(moveleft) + abs(moveright);
    return moveleft + moveright + root->val - 1;
}

int distributeCoins(struct TreeNode* root) {
    int move = 0;
    dfs(root, &move);
    return move;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 表示二叉树中节点的数目。只需要遍历一遍即可，因此时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 表示二叉树中节点的数目。递归深度与二叉树的深度有关，其中二叉树的深度最小值为 $\log n$，深度最大值为 $n$，递归深度最多为 $n$ 层，因此空间复杂度为 $O(n)$。
#### 方法一：动态规划

**思路与算法**

简化一下这个问题：一棵二叉树，树上的每个点都有对应的权值，每个点有两种状态（选中和不选中），问在不能同时选中有父子关系的点的情况下，能选中的点的最大权值和是多少。

我们可以用 $f(o)$ 表示选择 $o$ 节点的情况下，$o$ 节点的子树上被选择的节点的最大权值和；$g(o)$ 表示不选择 $o$ 节点的情况下，$o$ 节点的子树上被选择的节点的最大权值和；$l$ 和 $r$ 代表 $o$ 的左右孩子。

+ 当 $o$ 被选中时，$o$ 的左右孩子都不能被选中，故 $o$ 被选中情况下子树上被选中点的最大权值和为 $l$ 和 $r$ 不被选中的最大权值和相加，即 $f(o) = g(l) + g(r)$。
+ 当 $o$ 不被选中时，$o$ 的左右孩子可以被选中，也可以不被选中。对于 $o$ 的某个具体的孩子 $x$，它对 $o$ 的贡献是 $x$ 被选中和不被选中情况下权值和的较大值。故 $g(o) = \max \{ f(l) , g(l)\}+\max\{ f(r) , g(r) \}$。

至此，我们可以用哈希表来存 $f$ 和 $g$ 的函数值，用深度优先搜索的办法后序遍历这棵二叉树，我们就可以得到每一个节点的 $f$ 和 $g$。根节点的 $f$ 和 $g$ 的最大值就是我们要找的答案。

我们不难给出这样的实现：

```cpp [sol0-C++]
class Solution {
public:
    unordered_map <TreeNode*, int> f, g;

    void dfs(TreeNode* node) {
        if (!node) {
            return;
        }
        dfs(node->left);
        dfs(node->right);
        f[node] = node->val + g[node->left] + g[node->right];
        g[node] = max(f[node->left], g[node->left]) + max(f[node->right], g[node->right]);
    }

    int rob(TreeNode* root) {
        dfs(root);
        return max(f[root], g[root]);
    }
};
```

```Java [sol0-Java]
class Solution {
    Map<TreeNode, Integer> f = new HashMap<TreeNode, Integer>();
    Map<TreeNode, Integer> g = new HashMap<TreeNode, Integer>();

    public int rob(TreeNode root) {
        dfs(root);
        return Math.max(f.getOrDefault(root, 0), g.getOrDefault(root, 0));
    }

    public void dfs(TreeNode node) {
        if (node == null) {
            return;
        }
        dfs(node.left);
        dfs(node.right);
        f.put(node, node.val + g.getOrDefault(node.left, 0) + g.getOrDefault(node.right, 0));
        g.put(node, Math.max(f.getOrDefault(node.left, 0), g.getOrDefault(node.left, 0)) + Math.max(f.getOrDefault(node.right, 0), g.getOrDefault(node.right, 0)));
    }
}
```

```JavaScript [sol0-JavaScript]
var rob = function(root) {
    const f = new Map();
    const g = new Map();

    const dfs = (node) => {
        if (node === null) {
            return;
        }
        dfs(node.left);
        dfs(node.right);
        f.set(node, node.val + (g.get(node.left) || 0) + (g.get(node.right) || 0));
        g.set(node, Math.max(f.get(node.left) || 0, g.get(node.left) || 0) + Math.max(f.get(node.right) || 0, g.get(node.right) || 0));
    }
    
    dfs(root);
    return Math.max(f.get(root) || 0, g.get(root) || 0);
};
```

假设二叉树的节点个数为 $n$。

我们可以看出，以上的算法对二叉树做了一次后序遍历，时间复杂度是 $O(n)$；由于递归会使用到栈空间，空间代价是 $O(n)$，哈希表的空间代价也是 $O(n)$，故空间复杂度也是 $O(n)$。

我们可以做一个小小的优化，我们发现无论是 $f(o)$ 还是 $g(o)$，他们最终的值只和 $f(l)$、$g(l)$、$f(r)$、$g(r)$ 有关，所以对于每个节点，我们只关心它的孩子节点们的 $f$ 和 $g$ 是多少。我们可以设计一个结构，表示某个节点的 $f$ 和 $g$ 值，在每次递归返回的时候，都把这个点对应的 $f$ 和 $g$ 返回给上一级调用，这样可以省去哈希表的空间。

代码如下。

**代码**

```cpp [sol1-C++]
struct SubtreeStatus {
    int selected;
    int notSelected;
};

class Solution {
public:
    SubtreeStatus dfs(TreeNode* node) {
        if (!node) {
            return {0, 0};
        }
        auto l = dfs(node->left);
        auto r = dfs(node->right);
        int selected = node->val + l.notSelected + r.notSelected;
        int notSelected = max(l.selected, l.notSelected) + max(r.selected, r.notSelected);
        return {selected, notSelected};
    }

    int rob(TreeNode* root) {
        auto rootStatus = dfs(root);
        return max(rootStatus.selected, rootStatus.notSelected);
    }
};
```

```Java [sol1-Java]
class Solution {
    public int rob(TreeNode root) {
        int[] rootStatus = dfs(root);
        return Math.max(rootStatus[0], rootStatus[1]);
    }

    public int[] dfs(TreeNode node) {
        if (node == null) {
            return new int[]{0, 0};
        }
        int[] l = dfs(node.left);
        int[] r = dfs(node.right);
        int selected = node.val + l[1] + r[1];
        int notSelected = Math.max(l[0], l[1]) + Math.max(r[0], r[1]);
        return new int[]{selected, notSelected};
    }
}
```

```JavaScript [sol1-JavaScript]
var rob = function(root) {
    const dfs = (node) => {
        if (node === null) {
            return [0, 0];
        }
        const l = dfs(node.left);
        const r = dfs(node.right);
        const selected = node.val + l[1] + r[1];
        const notSelected = Math.max(l[0], l[1]) + Math.max(r[0], r[1]);
        return [selected, notSelected];
    }
    
    const rootStatus = dfs(root);
    return Math.max(rootStatus[0], rootStatus[1]);
}; 
```

```golang [sol1-Golang]
func rob(root *TreeNode) int {
    val := dfs(root)
    return max(val[0], val[1])
}

func dfs(node *TreeNode) []int {
    if node == nil {
        return []int{0, 0}
    }
    l, r := dfs(node.Left), dfs(node.Right)
    selected := node.Val + l[1] + r[1]
    notSelected := max(l[0], l[1]) + max(r[0], r[1])
    return []int{selected, notSelected}
}

func max(x, y int) int {
    if x > y {
        return x
    }
    return y
}
```

```C [sol1-C]
struct SubtreeStatus {
    int selected;
    int notSelected;
};

struct SubtreeStatus dfs(struct TreeNode *node) {
    if (!node) {
        return (struct SubtreeStatus){0, 0};
    }
    struct SubtreeStatus l = dfs(node->left);
    struct SubtreeStatus r = dfs(node->right);
    int selected = node->val + l.notSelected + r.notSelected;
    int notSelected = fmax(l.selected, l.notSelected) + fmax(r.selected, r.notSelected);
    return (struct SubtreeStatus){selected, notSelected};
}

int rob(struct TreeNode *root) {
    struct SubtreeStatus rootStatus = dfs(root);
    return fmax(rootStatus.selected, rootStatus.notSelected);
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$。上文中已分析。

+ 空间复杂度：$O(n)$。虽然优化过的版本省去了哈希表的空间，但是栈空间的使用代价依旧是 $O(n)$，故空间复杂度不变。
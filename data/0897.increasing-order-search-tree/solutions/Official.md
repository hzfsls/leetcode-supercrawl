## [897.递增顺序搜索树 中文官方题解](https://leetcode.cn/problems/increasing-order-search-tree/solutions/100000/di-zeng-shun-xu-cha-zhao-shu-by-leetcode-dfrr)

#### 方法一：中序遍历之后生成新的树

**算法**

题目要求我们返回按照中序遍历的结果改造而成的、只有右节点的**等价**二叉搜索树。我们可以进行如下操作：

- 先对输入的二叉搜索树执行中序遍历，将结果保存到一个列表中；

- 然后根据列表中的节点值，创建等价的只含有右节点的二叉搜索树，其过程等价于根据节点值创建一个链表。

**代码**

```Java [sol1-Java]
class Solution {
    public TreeNode increasingBST(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        inorder(root, res);

        TreeNode dummyNode = new TreeNode(-1);
        TreeNode currNode = dummyNode;
        for (int value : res) {
            currNode.right = new TreeNode(value);
            currNode = currNode.right;
        }
        return dummyNode.right;
    }

    public void inorder(TreeNode node, List<Integer> res) {
        if (node == null) {
            return;
        }
        inorder(node.left, res);
        res.add(node.val);
        inorder(node.right, res);
    }
}
```

```JavaScript [sol1-JavaScript]
var increasingBST = function(root) {
    const res = [];
    inorder(root, res);

    const dummyNode = new TreeNode(-1);
    let currNode = dummyNode;
    for (const value of res) {
        currNode.right = new TreeNode(value);
        currNode = currNode.right;
    }
    return dummyNode.right;
};

const inorder = (node, res) => {
    if (!node) {
        return;
    }
    inorder(node.left, res);
    res.push(node.val);
    inorder(node.right, res);
}
```

```go [sol1-Golang]
func increasingBST(root *TreeNode) *TreeNode {
    vals := []int{}
    var inorder func(*TreeNode)
    inorder = func(node *TreeNode) {
        if node != nil {
            inorder(node.Left)
            vals = append(vals, node.Val)
            inorder(node.Right)
        }
    }
    inorder(root)

    dummyNode := &TreeNode{}
    curNode := dummyNode
    for _, val := range vals {
        curNode.Right = &TreeNode{Val: val}
        curNode = curNode.Right
    }
    return dummyNode.Right
}
```

```C++ [sol1-C++]
class Solution {
public:
    void inorder(TreeNode *node, vector<int> &res) {
        if (node == nullptr) {
            return;
        }
        inorder(node->left, res);
        res.push_back(node->val);
        inorder(node->right, res);
    }

    TreeNode *increasingBST(TreeNode *root) {
        vector<int> res;
        inorder(root, res);

        TreeNode *dummyNode = new TreeNode(-1);
        TreeNode *currNode = dummyNode;
        for (int value : res) {
            currNode->right = new TreeNode(value);
            currNode = currNode->right;
        }
        return dummyNode->right;
    }
};
```

```C [sol1-C]
struct TreeNode* createTreeNode(int val) {
    struct TreeNode* ret = malloc(sizeof(struct TreeNode));
    ret->val = val, ret->left = ret->right = NULL;
    return ret;
}

void inorder(struct TreeNode* node, int* res, int* resSize) {
    if (node == NULL) {
        return;
    }
    inorder(node->left, res, resSize);
    res[(*resSize)++] = node->val;
    inorder(node->right, res, resSize);
}

struct TreeNode* increasingBST(struct TreeNode* root) {
    int res[100], resSize = 0;
    inorder(root, res, &resSize);

    struct TreeNode* dummyNode = createTreeNode(-1);
    struct TreeNode* currNode = dummyNode;
    for (int i = 0; i < resSize; i++) {
        currNode->right = createTreeNode(res[i]);
        currNode = currNode->right;
    }
    return dummyNode->right;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉搜索树的节点总数。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉搜索树的节点总数。需要长度为 $n$ 的列表保存二叉搜索树的所有节点的值。

#### 方法二：在中序遍历的过程中改变节点指向

**算法**

方法一需要遍历一次二叉搜索树以后，然后再创建新的等价的二叉搜索树。事实上，还可以遍历一次输入二叉搜索树，在遍历的过程中改变节点指向以满足题目的要求。

在中序遍历的时候，修改节点指向就可以实现。具体地，当我们遍历到一个节点时，把它的左孩子设为空，并将其本身作为上一个遍历到的节点的右孩子。这里需要有一些想象能力。递归遍历的过程中，由于递归函数的调用栈保存了节点的引用，因此上述操作可以实现。下面的幻灯片展示了这样的过程。

<![1.png](https://pic.leetcode-cn.com/1617605893-CYccaw-1.png),![2.png](https://pic.leetcode-cn.com/1617605893-wVIkEe-2.png),![3.png](https://pic.leetcode-cn.com/1617605893-wVNSxo-3.png),![4.png](https://pic.leetcode-cn.com/1617605893-MRrcNu-4.png),![5.png](https://pic.leetcode-cn.com/1617605893-ZaLISJ-5.png),![6.png](https://pic.leetcode-cn.com/1617605893-tdVhEG-6.png),![7.png](https://pic.leetcode-cn.com/1617605893-ljGMbE-7.png),![8.png](https://pic.leetcode-cn.com/1617605893-ObVBhn-8.png),![9.png](https://pic.leetcode-cn.com/1617605893-alyIKA-9.png),![10.png](https://pic.leetcode-cn.com/1617605893-hRHcnK-10.png),![11.png](https://pic.leetcode-cn.com/1617605893-AZbrbl-11.png),![12.png](https://pic.leetcode-cn.com/1617605893-aAIrLT-12.png),![13.png](https://pic.leetcode-cn.com/1617605893-IrZyWz-13.png),![14.png](https://pic.leetcode-cn.com/1617605893-EzRWkT-14.png),![15.png](https://pic.leetcode-cn.com/1617605893-INQjIh-15.png),![16.png](https://pic.leetcode-cn.com/1617605893-XUkntJ-16.png),![17.png](https://pic.leetcode-cn.com/1617605893-SNRECU-17.png),![18.png](https://pic.leetcode-cn.com/1617605893-MJNEuw-18.png),![19.png](https://pic.leetcode-cn.com/1617605893-APxVgX-19.png),![20.png](https://pic.leetcode-cn.com/1617605893-kncxnf-20.png),![21.png](https://pic.leetcode-cn.com/1617605893-AfojZp-21.png),![22.png](https://pic.leetcode-cn.com/1617605893-arlRwv-22.png),![23.png](https://pic.leetcode-cn.com/1617605893-dRsEXD-23.png),![24.png](https://pic.leetcode-cn.com/1617605893-mmcVcf-24.png),![25.png](https://pic.leetcode-cn.com/1617605893-PlYUtg-25.png),![26.png](https://pic.leetcode-cn.com/1617605893-oowOmh-26.png),![27.png](https://pic.leetcode-cn.com/1617605893-uzfpip-27.png)>

**代码**

```Java [sol2-Java]
class Solution {
    private TreeNode resNode;

    public TreeNode increasingBST(TreeNode root) {
        TreeNode dummyNode = new TreeNode(-1);
        resNode = dummyNode;
        inorder(root);
        return dummyNode.right;
    }

    public void inorder(TreeNode node) {
        if (node == null) {
            return;
        }
        inorder(node.left);

        // 在中序遍历的过程中修改节点指向
        resNode.right = node;
        node.left = null;
        resNode = node;

        inorder(node.right);
    }
}
```

```JavaScript [sol2-JavaScript]
var increasingBST = function(root) {
    const dummyNode = new TreeNode(-1);
    let resNode = dummyNode;
    const inorder = (node) => {
        if (!node) {
            return;
        }
        inorder(node.left);

        // 在中序遍历的过程中修改节点指向
        resNode.right = node;
        node.left = null;
        resNode = node;

        inorder(node.right);
    }
    inorder(root);
    return dummyNode.right;
};
```

```go [sol2-Golang]
func increasingBST(root *TreeNode) *TreeNode {
    dummyNode := &TreeNode{}
    resNode := dummyNode

    var inorder func(*TreeNode)
    inorder = func(node *TreeNode) {
        if node == nil {
            return
        }
        inorder(node.Left)

        // 在中序遍历的过程中修改节点指向
        resNode.Right = node
        node.Left = nil
        resNode = node

        inorder(node.Right)
    }
    inorder(root)

    return dummyNode.Right
}
```

```C++ [sol2-C++]
class Solution {
private:
    TreeNode *resNode;

public:
    void inorder(TreeNode *node) {
        if (node == nullptr) {
            return;
        }
        inorder(node->left);

        // 在中序遍历的过程中修改节点指向
        resNode->right = node;
        node->left = nullptr;
        resNode = node;

        inorder(node->right);
    }

    TreeNode *increasingBST(TreeNode *root) {
        TreeNode *dummyNode = new TreeNode(-1);
        resNode = dummyNode;
        inorder(root);
        return dummyNode->right;
    }
};
```

```C [sol2-C]
struct TreeNode* createTreeNode(int val) {
    struct TreeNode* ret = malloc(sizeof(struct TreeNode));
    ret->val = val, ret->left = ret->right = NULL;
    return ret;
}

struct TreeNode* resNode;

void inorder(struct TreeNode* node) {
    if (node == NULL) {
        return;
    }
    inorder(node->left);

    // 在中序遍历的过程中修改节点指向
    resNode->right = node;
    node->left = NULL;
    resNode = node;

    inorder(node->right);
}
struct TreeNode* increasingBST(struct TreeNode* root) {
    struct TreeNode* dummyNode = createTreeNode(-1);
    resNode = dummyNode;
    inorder(root);
    return dummyNode->right;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉搜索树的节点总数。

- 空间复杂度：$O(n)$。递归过程中的栈空间开销为 $O(n)$。

---
# [📚 好读书？读好书！让时间更有价值| 世界读书日](https://leetcode-cn.com/circle/discuss/12QtuI/)
4 月 22 日至 4 月 28 日，进入「[学习](https://leetcode-cn.com/leetbook/)」，完成页面右上角的「让时间更有价值」限时阅读任务，可获得「2021 读书日纪念勋章」。更多活动详情戳上方标题了解更多👆
#### 今日学习任务：
- 了解神经网络
[完成阅读 2.1 初识神经网络](https://leetcode-cn.com/leetbook/read/deep-learning-with-python/o8zdbj/)
- 了解回归问题
[完成阅读 3.6.1 ~ 3.6.5 节内容](https://leetcode-cn.com/leetbook/read/deep-learning-with-python/otjerd/)
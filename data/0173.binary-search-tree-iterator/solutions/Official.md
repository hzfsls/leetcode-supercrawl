#### 前言

根据二叉搜索树的性质，不难发现，原问题等价于对二叉搜索树进行中序遍历。因此，我们可以采取与「[94. 二叉树的中序遍历](https://leetcode-cn.com/problems/binary-tree-inorder-traversal)」类似的方法来解决这一问题。

下面基于「[94. 二叉树的中序遍历的官方题解](https://leetcode-cn.com/problems/binary-tree-inorder-traversal/solution/er-cha-shu-de-zhong-xu-bian-li-by-leetcode-solutio/)」，给出本题的两种解法。读者将不难发现两篇题解的代码存在诸多相似之处。

#### 方法一：扁平化

我们可以直接对二叉搜索树做一次完全的递归遍历，获取中序遍历的全部结果并保存在数组中。随后，我们利用得到的数组本身来实现迭代器。

```C++ [sol1-C++]
class BSTIterator {
private:
    void inorder(TreeNode* root, vector<int>& res) {
        if (!root) {
            return;
        }
        inorder(root->left, res);
        res.push_back(root->val);
        inorder(root->right, res);
    }
    vector<int> inorderTraversal(TreeNode* root) {
        vector<int> res;
        inorder(root, res);
        return res;
    }
    
    vector<int> arr;
    int idx;
public:
    BSTIterator(TreeNode* root): idx(0), arr(inorderTraversal(root)) {}
    
    int next() {
        return arr[idx++];
    }
    
    bool hasNext() {
        return (idx < arr.size());
    }
};
```

```Java [sol1-Java]
class BSTIterator {
    private int idx;
    private List<Integer> arr;

    public BSTIterator(TreeNode root) {
        idx = 0;
        arr = new ArrayList<Integer>();
        inorderTraversal(root, arr);
    }

    public int next() {
        return arr.get(idx++);
    }

    public boolean hasNext() {
        return idx < arr.size();
    }

    private void inorderTraversal(TreeNode root, List<Integer> arr) {
        if (root == null) {
            return;
        }
        inorderTraversal(root.left, arr);
        arr.add(root.val);
        inorderTraversal(root.right, arr);
    }
}
```

```go [sol1-Golang]
type BSTIterator struct {
    arr []int
}

func Constructor(root *TreeNode) (it BSTIterator) {
    it.inorder(root)
    return
}

func (it *BSTIterator) inorder(node *TreeNode) {
    if node == nil {
        return
    }
    it.inorder(node.Left)
    it.arr = append(it.arr, node.Val)
    it.inorder(node.Right)
}

func (it *BSTIterator) Next() int {
    val := it.arr[0]
    it.arr = it.arr[1:]
    return val
}

func (it *BSTIterator) HasNext() bool {
    return len(it.arr) > 0
}
```

```JavaScript [sol1-JavaScript]
var BSTIterator = function(root) {
    this.idx = 0;
    this.arr = [];
    this.inorderTraversal(root, this.arr);
};

BSTIterator.prototype.next = function() {
    return this.arr[this.idx++];
};

BSTIterator.prototype.hasNext = function() {
    return this.idx < this.arr.length;
};

BSTIterator.prototype.inorderTraversal = function(root, arr) {
    if (!root) {
        return;
    }
    this.inorderTraversal(root.left, arr);
    arr.push(root.val);
    this.inorderTraversal(root.right, arr);
};
```

```C [sol1-C]
typedef struct {
    int* res;
    int size;
    int idx;
} BSTIterator;

int getTreeSize(struct TreeNode* root) {
    if (root == NULL) {
        return 0;
    }
    return 1 + getTreeSize(root->left) + getTreeSize(root->right);
}

void inorder(int* ret, int* retSize, struct TreeNode* root) {
    if (root == NULL) {
        return;
    }
    inorder(ret, retSize, root->left);
    ret[(*retSize)++] = root->val;
    inorder(ret, retSize, root->right);
}

int* inorderTraversal(int* retSize, struct TreeNode* root) {
    *retSize = 0;
    int* ret = malloc(sizeof(int) * getTreeSize(root));
    inorder(ret, retSize, root);
    return ret;
}

BSTIterator* bSTIteratorCreate(struct TreeNode* root) {
    BSTIterator* ret = malloc(sizeof(BSTIterator));
    ret->res = inorderTraversal(&(ret->size), root);
    ret->idx = 0;
    return ret;
}

int bSTIteratorNext(BSTIterator* obj) {
    return obj->res[(obj->idx)++];
}

bool bSTIteratorHasNext(BSTIterator* obj) {
    return (obj->idx < obj->size);
}

void bSTIteratorFree(BSTIterator* obj) {
    free(obj->res);
    free(obj);
}
```

**复杂度分析**

- 时间复杂度：初始化需要 $O(n)$ 的时间，其中 $n$ 为树中节点的数量。随后每次调用只需要 $O(1)$ 的时间。

- 空间复杂度：$O(n)$，因为需要保存中序遍历的全部结果。

#### 方法二：迭代

除了递归的方法外，我们还可以利用栈这一数据结构，通过迭代的方式对二叉树做中序遍历。此时，我们无需预先计算出中序遍历的全部结果，只需要实时维护当前栈的情况即可。

```C++ [sol2-C++]
class BSTIterator {
private:
    TreeNode* cur;
    stack<TreeNode*> stk;
public:
    BSTIterator(TreeNode* root): cur(root) {}
    
    int next() {
        while (cur != nullptr) {
            stk.push(cur);
            cur = cur->left;
        }
        cur = stk.top();
        stk.pop();
        int ret = cur->val;
        cur = cur->right;
        return ret;
    }
    
    bool hasNext() {
        return cur != nullptr || !stk.empty();
    }
};
```

```Java [sol2-Java]
class BSTIterator {
    private TreeNode cur;
    private Deque<TreeNode> stack;

    public BSTIterator(TreeNode root) {
        cur = root;
        stack = new LinkedList<TreeNode>();
    }
    
    public int next() {
        while (cur != null) {
            stack.push(cur);
            cur = cur.left;
        }
        cur = stack.pop();
        int ret = cur.val;
        cur = cur.right;
        return ret;
    }
    
    public boolean hasNext() {
        return cur != null || !stack.isEmpty();
    }
}
```

```go [sol2-Golang]
type BSTIterator struct {
    stack []*TreeNode
    cur   *TreeNode
}

func Constructor(root *TreeNode) BSTIterator {
    return BSTIterator{cur: root}
}

func (it *BSTIterator) Next() int {
    for node := it.cur; node != nil; node = node.Left {
        it.stack = append(it.stack, node)
    }
    it.cur, it.stack = it.stack[len(it.stack)-1], it.stack[:len(it.stack)-1]
    val := it.cur.Val
    it.cur = it.cur.Right
    return val
}

func (it *BSTIterator) HasNext() bool {
    return it.cur != nil || len(it.stack) > 0
}
```

```JavaScript [sol2-JavaScript]
var BSTIterator = function(root) {
    this.cur = root;
    this.stack = [];
};

BSTIterator.prototype.next = function() {
    while (this.cur) {
        this.stack.push(this.cur);
        this.cur = this.cur.left;
    }
    this.cur = this.stack.pop();
    const ret = this.cur.val;
    this.cur = this.cur.right;
    return ret;
};

BSTIterator.prototype.hasNext = function() {
    return this.cur !== null || this.stack.length;
};
```

```C [sol2-C]
typedef struct {
    struct TreeNode* cur;
    struct StackTreeNode* stk[128];
    int stkSize;
} BSTIterator;

BSTIterator* bSTIteratorCreate(struct TreeNode* root) {
    BSTIterator* ret = malloc(sizeof(BSTIterator));
    ret->cur = root;
    ret->stkSize = 0;
    return ret;
}

int bSTIteratorNext(BSTIterator* obj) {
    while (obj->cur != NULL) {
        obj->stk[(obj->stkSize)++] = obj->cur;
        obj->cur = obj->cur->left;
    }
    obj->cur = obj->stk[--(obj->stkSize)];
    int ret = obj->cur->val;
    obj->cur = obj->cur->right;
    return ret;
}

bool bSTIteratorHasNext(BSTIterator* obj) {
    return obj->cur != NULL || obj->stkSize;
}

void bSTIteratorFree(BSTIterator* obj) {
    free(obj);
}
```

**复杂度分析**

- 时间复杂度：显然，初始化和调用 $\text{hasNext()}$ 都只需要 $O(1)$ 的时间。每次调用 $\text{next()}$ 函数**最坏情况下**需要 $O(n)$ 的时间；但考虑到 $n$ 次调用 $\text{next()}$ 函数总共会遍历全部的 $n$ 个节点，因此总的时间复杂度为 $O(n)$，因此单次调用平均下来的**均摊复杂度**为 $O(1)$。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数量。空间复杂度取决于栈深度，而栈深度在二叉树为一条链的情况下会达到 $O(n)$ 的级别。
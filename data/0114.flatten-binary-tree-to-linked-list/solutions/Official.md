#### 方法一：前序遍历

将二叉树展开为单链表之后，单链表中的节点顺序即为二叉树的前序遍历访问各节点的顺序。因此，可以对二叉树进行前序遍历，获得各节点被访问到的顺序。由于将二叉树展开为链表之后会破坏二叉树的结构，因此在前序遍历结束之后更新每个节点的左右子节点的信息，将二叉树展开为单链表。

对二叉树的前序遍历不熟悉的读者请自行练习「[144. 二叉树的前序遍历](https://leetcode-cn.com/problems/binary-tree-preorder-traversal/)」。

前序遍历可以通过递归或者迭代的方式实现。以下代码通过递归实现前序遍历。

```Java [sol0-Java]
class Solution {
    public void flatten(TreeNode root) {
        List<TreeNode> list = new ArrayList<TreeNode>();
        preorderTraversal(root, list);
        int size = list.size();
        for (int i = 1; i < size; i++) {
            TreeNode prev = list.get(i - 1), curr = list.get(i);
            prev.left = null;
            prev.right = curr;
        }
    }

    public void preorderTraversal(TreeNode root, List<TreeNode> list) {
        if (root != null) {
            list.add(root);
            preorderTraversal(root.left, list);
            preorderTraversal(root.right, list);
        }
    }
}
```

```cpp [sol0-C++]
class Solution {
public:
    void flatten(TreeNode* root) {
        vector<TreeNode*> l;
        preorderTraversal(root, l);
        int n = l.size();
        for (int i = 1; i < n; i++) {
            TreeNode *prev = l.at(i - 1), *curr = l.at(i);
            prev->left = nullptr;
            prev->right = curr;
        }
    }

    void preorderTraversal(TreeNode* root, vector<TreeNode*> &l) {
        if (root != NULL) {
            l.push_back(root);
            preorderTraversal(root->left, l);
            preorderTraversal(root->right, l);
        }
    }
};
```

```golang [sol0-Golang]
func flatten(root *TreeNode)  {
    list := preorderTraversal(root)
    for i := 1; i < len(list); i++ {
        prev, curr := list[i-1], list[i]
        prev.Left, prev.Right = nil, curr
    }
}

func preorderTraversal(root *TreeNode) []*TreeNode {
    list := []*TreeNode{}
    if root != nil {
        list = append(list, root)
        list = append(list, preorderTraversal(root.Left)...)
        list = append(list, preorderTraversal(root.Right)...)
    }
    return list
}
```

```Python [sol0-Python3]
class Solution:
    def flatten(self, root: TreeNode) -> None:
        preorderList = list()

        def preorderTraversal(root: TreeNode):
            if root:
                preorderList.append(root)
                preorderTraversal(root.left)
                preorderTraversal(root.right)
        
        preorderTraversal(root)
        size = len(preorderList)
        for i in range(1, size):
            prev, curr = preorderList[i - 1], preorderList[i]
            prev.left = None
            prev.right = curr
```

```JavaScript [sol0-JavaScript]
var flatten = function(root) {
    const list = [];
    preorderTraversal(root, list);
    const size = list.length;
    for (let i = 1; i < size; i++) {
        const prev = list[i - 1], curr = list[i];
        prev.left = null;
        prev.right = curr;
    }
};

const preorderTraversal = (root, list) => {
    if (root != null) {
        list.push(root);
        preorderTraversal(root.left, list);
        preorderTraversal(root.right, list);
    }
}
```

```C [sol0-C]
int num;

void flatten(struct TreeNode* root) {
    num = 0;
    struct TreeNode** l = (struct TreeNode**)malloc(0);
    preorderTraversal(root, &l);
    for (int i = 1; i < num; i++) {
        struct TreeNode *prev = l[i - 1], *curr = l[i];
        prev->left = NULL;
        prev->right = curr;
    }
    free(l);
}

void preorderTraversal(struct TreeNode* root, struct TreeNode*** l) {
    if (root != NULL) {
        num++;
        (*l) = (struct TreeNode**)realloc((*l), sizeof(struct TreeNode*) * num);
        (*l)[num - 1] = root;
        preorderTraversal(root->left, l);
        preorderTraversal(root->right, l);
    }
}
```

以下代码通过迭代实现前序遍历。

```Java [sol1-Java]
class Solution {
    public void flatten(TreeNode root) {
        List<TreeNode> list = new ArrayList<TreeNode>();
        Deque<TreeNode> stack = new LinkedList<TreeNode>();
        TreeNode node = root;
        while (node != null || !stack.isEmpty()) {
            while (node != null) {
                list.add(node);
                stack.push(node);
                node = node.left;
            }
            node = stack.pop();
            node = node.right;
        }
        int size = list.size();
        for (int i = 1; i < size; i++) {
            TreeNode prev = list.get(i - 1), curr = list.get(i);
            prev.left = null;
            prev.right = curr;
        }
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    void flatten(TreeNode* root) {
        auto v = vector<TreeNode*>();
        auto stk = stack<TreeNode*>();
        TreeNode *node = root;
        while (node != nullptr || !stk.empty()) {
            while (node != nullptr) {
                v.push_back(node);
                stk.push(node);
                node = node->left;
            }
            node = stk.top(); stk.pop();
            node = node->right;
        }
        int size = v.size();
        for (int i = 1; i < size; i++) {
            auto prev = v.at(i - 1), curr = v.at(i);
            prev->left = nullptr;
            prev->right = curr;
        }
    }
};
```

```golang [sol1-Golang]
func flatten(root *TreeNode)  {
    list := []*TreeNode{}
    stack := []*TreeNode{}
    node := root
    for node != nil || len(stack) > 0 {
        for node != nil {
            list = append(list, node)
            stack = append(stack, node)
            node = node.Left
        }
        node = stack[len(stack)-1]
        node = node.Right
        stack = stack[:len(stack)-1]
    }

    for i := 1; i < len(list); i++ {
        prev, curr := list[i-1], list[i]
        prev.Left, prev.Right = nil, curr
    }
}
```

```Python [sol1-Python3]
class Solution:
    def flatten(self, root: TreeNode) -> None:
        preorderList = list()
        stack = list()
        node = root

        while node or stack:
            while node:
                preorderList.append(node)
                stack.append(node)
                node = node.left
            node = stack.pop()
            node = node.right
        
        size = len(preorderList)
        for i in range(1, size):
            prev, curr = preorderList[i - 1], preorderList[i]
            prev.left = None
            prev.right = curr
```

```JavaScript [sol1-JavaScript]
var flatten = function(root) {
    const list = [];
    const stack = [];
    let node = root;
    while (node !== null || stack.length) {
        while (node !== null) {
            list.push(node);
            stack.push(node);
            node = node.left;
        }
        node = stack.pop();
        node = node.right;
    }
    const size = list.length;
    for (let i = 1; i < size; i++) {
        const prev = list[i - 1], curr = list[i];
        prev.left = null;
        prev.right = curr;
    }
};
```

```C [sol1-C]
void flatten(struct TreeNode* root) {
    struct TreeNode** stk = (struct TreeNode**)malloc(0);
    int stk_top = 0;
    struct TreeNode** vec = (struct TreeNode**)malloc(0);
    int vec_len = 0;
    struct TreeNode* node = root;
    while (node != NULL || stk_top != 0) {
        while (node != NULL) {
            vec_len++;
            vec = (struct TreeNode**)realloc(vec, sizeof(struct TreeNode*) * vec_len);
            vec[vec_len - 1] = node;
            stk_top++;
            stk = (struct TreeNode**)realloc(stk, sizeof(struct TreeNode*) * stk_top);
            stk[stk_top - 1] = node;
            node = node->left;
        }
        node = stk[--stk_top];
        node = node->right;
    }
    for (int i = 1; i < vec_len; i++) {
        struct TreeNode *prev = vec[i - 1], *curr = vec[i];
        prev->left = NULL;
        prev->right = curr;
    }
    free(stk);
    free(vec);
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数。前序遍历的时间复杂度是 $O(n)$，前序遍历之后，需要对每个节点更新左右子节点的信息，时间复杂度也是 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数。空间复杂度取决于栈（递归调用栈或者迭代中显性使用的栈）和存储前序遍历结果的列表的大小，栈内的元素个数不会超过 $n$，前序遍历列表中的元素个数是 $n$。

#### 方法二：前序遍历和展开同步进行

使用方法一的前序遍历，由于将节点展开之后会破坏二叉树的结构而丢失子节点的信息，因此前序遍历和展开为单链表分成了两步。能不能在不丢失子节点的信息的情况下，将前序遍历和展开为单链表同时进行？

之所以会在破坏二叉树的结构之后丢失子节点的信息，是因为在对左子树进行遍历时，没有存储右子节点的信息，在遍历完左子树之后才获得右子节点的信息。只要对前序遍历进行修改，在遍历左子树之前就获得左右子节点的信息，并存入栈内，子节点的信息就不会丢失，就可以将前序遍历和展开为单链表同时进行。

该做法不适用于递归实现的前序遍历，只适用于迭代实现的前序遍历。修改后的前序遍历的具体做法是，每次从栈内弹出一个节点作为当前访问的节点，获得该节点的子节点，如果子节点不为空，则依次将右子节点和左子节点压入栈内（注意入栈顺序）。

展开为单链表的做法是，维护上一个访问的节点 `prev`，每次访问一个节点时，令当前访问的节点为 `curr`，将 `prev` 的左子节点设为 `null` 以及将 `prev` 的右子节点设为 `curr`，然后将 `curr` 赋值给 `prev`，进入下一个节点的访问，直到遍历结束。需要注意的是，初始时 `prev` 为 `null`，只有在 `prev` 不为 `null` 时才能对 `prev` 的左右子节点进行更新。

```Java [sol2-Java]
class Solution {
    public void flatten(TreeNode root) {
        if (root == null) {
            return;
        }
        Deque<TreeNode> stack = new LinkedList<TreeNode>();
        stack.push(root);
        TreeNode prev = null;
        while (!stack.isEmpty()) {
            TreeNode curr = stack.pop();
            if (prev != null) {
                prev.left = null;
                prev.right = curr;
            }
            TreeNode left = curr.left, right = curr.right;
            if (right != null) {
                stack.push(right);
            }
            if (left != null) {
                stack.push(left);
            }
            prev = curr;
        }
    }
}
```

```cpp [sol2-C++]
class Solution {
public:
    void flatten(TreeNode* root) {
        if (root == nullptr) {
            return;
        }
        auto stk = stack<TreeNode*>();
        stk.push(root);
        TreeNode *prev = nullptr;
        while (!stk.empty()) {
            TreeNode *curr = stk.top(); stk.pop();
            if (prev != nullptr) {
                prev->left = nullptr;
                prev->right = curr;
            }
            TreeNode *left = curr->left, *right = curr->right;
            if (right != nullptr) {
                stk.push(right);
            }
            if (left != nullptr) {
                stk.push(left);
            }
            prev = curr;
        }
    }
};
```

```golang [sol2-Golang]
func flatten(root *TreeNode)  {
    if root == nil {
        return
    }
    stack := []*TreeNode{root}
    var prev *TreeNode
    for len(stack) > 0 {
        curr := stack[len(stack)-1]
        stack = stack[:len(stack)-1]
        if prev != nil {
            prev.Left, prev.Right = nil, curr
        }
        left, right := curr.Left, curr.Right
        if right != nil {
            stack = append(stack, right)
        }
        if left != nil {
            stack = append(stack, left)
        }
        prev = curr
    }
}
```

```Python [sol2-Python3]
class Solution:
    def flatten(self, root: TreeNode) -> None:
        if not root:
            return
        
        stack = [root]
        prev = None
        
        while stack:
            curr = stack.pop()
            if prev:
                prev.left = None
                prev.right = curr
            left, right = curr.left, curr.right
            if right:
                stack.append(right)
            if left:
                stack.append(left)
            prev = curr
```

```JavaScript [sol2-JavaScript]
var flatten = function(root) {
    if (root === null) {
        return;
    }
    const stack = [];
    stack.push(root);
    let prev = null;
    while (stack.length) {
        const curr = stack.pop();
        if (prev !== null) {
            prev.left = null;
            prev.right = curr;
        }
        const left = curr.left, right = curr.right;
        if (right !== null) {
            stack.push(right);
        }
        if (left !== null) {
            stack.push(left);
        }
        prev = curr;
    }
};
```

```C [sol2-C]
void flatten(struct TreeNode *root) {
    if (root == NULL) {
        return;
    }
    struct TreeNode **stk = (struct TreeNode **)malloc(sizeof(struct TreeNode *));
    int stk_top = 1;
    stk[0] = root;
    struct TreeNode *prev = NULL;
    while (stk_top != 0) {
        struct TreeNode *curr = stk[--stk_top];
        if (prev != NULL) {
            prev->left = NULL;
            prev->right = curr;
        }
        struct TreeNode *left = curr->left, *right = curr->right;
        if (right != NULL) {
            stk_top++;
            stk = (struct TreeNode **)realloc(stk, sizeof(struct TreeNode *) * stk_top);
            stk[stk_top - 1] = right;
        }
        if (left != NULL) {
            stk_top++;
            stk = (struct TreeNode **)realloc(stk, sizeof(struct TreeNode *) * stk_top);
            stk[stk_top - 1] = left;
        }
        prev = curr;
    }
    free(stk);
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数。前序遍历的时间复杂度是 $O(n)$，前序遍历的同时对每个节点更新左右子节点的信息，更新子节点信息的时间复杂度是 $O(1)$，因此总时间复杂度是 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数。空间复杂度取决于栈的大小，栈内的元素个数不会超过 $n$。

#### 方法三：寻找前驱节点

前两种方法都借助前序遍历，前序遍历过程中需要使用栈存储节点。有没有空间复杂度是 $O(1)$ 的做法呢？

注意到前序遍历访问各节点的顺序是根节点、左子树、右子树。如果一个节点的左子节点为空，则该节点不需要进行展开操作。如果一个节点的左子节点不为空，则该节点的左子树中的最后一个节点被访问之后，该节点的右子节点被访问。该节点的左子树中最后一个被访问的节点是左子树中的最右边的节点，也是该节点的前驱节点。因此，问题转化成寻找当前节点的前驱节点。

具体做法是，对于当前节点，如果其左子节点不为空，则在其左子树中找到最右边的节点，作为前驱节点，将当前节点的右子节点赋给前驱节点的右子节点，然后将当前节点的左子节点赋给当前节点的右子节点，并将当前节点的左子节点设为空。对当前节点处理结束后，继续处理链表中的下一个节点，直到所有节点都处理结束。

<![fig1](https://assets.leetcode-cn.com/solution-static/114/1.png),![fig2](https://assets.leetcode-cn.com/solution-static/114/2.png),![fig3](https://assets.leetcode-cn.com/solution-static/114/3.png),![fig4](https://assets.leetcode-cn.com/solution-static/114/4.png),![fig5](https://assets.leetcode-cn.com/solution-static/114/5.png),![fig6](https://assets.leetcode-cn.com/solution-static/114/6.png),![fig7](https://assets.leetcode-cn.com/solution-static/114/7.png),![fig8](https://assets.leetcode-cn.com/solution-static/114/8.png),![fig9](https://assets.leetcode-cn.com/solution-static/114/9.png),![fig10](https://assets.leetcode-cn.com/solution-static/114/10.png),![fig11](https://assets.leetcode-cn.com/solution-static/114/11.png),![fig12](https://assets.leetcode-cn.com/solution-static/114/12.png),![fig13](https://assets.leetcode-cn.com/solution-static/114/13.png),![fig14](https://assets.leetcode-cn.com/solution-static/114/14.png),![fig15](https://assets.leetcode-cn.com/solution-static/114/15.png),![fig16](https://assets.leetcode-cn.com/solution-static/114/16.png),![fig17](https://assets.leetcode-cn.com/solution-static/114/17.png),![fig18](https://assets.leetcode-cn.com/solution-static/114/18.png)>

```Java [sol3-Java]
class Solution {
    public void flatten(TreeNode root) {
        TreeNode curr = root;
        while (curr != null) {
            if (curr.left != null) {
                TreeNode next = curr.left;
                TreeNode predecessor = next;
                while (predecessor.right != null) {
                    predecessor = predecessor.right;
                }
                predecessor.right = curr.right;
                curr.left = null;
                curr.right = next;
            }
            curr = curr.right;
        }
    }
}
```

```cpp [sol3-C++]
class Solution {
public:
    void flatten(TreeNode* root) {
        TreeNode *curr = root;
        while (curr != nullptr) {
            if (curr->left != nullptr) {
                auto next = curr->left;
                auto predecessor = next;
                while (predecessor->right != nullptr) {
                    predecessor = predecessor->right;
                }
                predecessor->right = curr->right;
                curr->left = nullptr;
                curr->right = next;
            }
            curr = curr->right;
        }
    }
};
```

```golang [sol3-Golang]
func flatten(root *TreeNode)  {
    curr := root
    for curr != nil {
        if curr.Left != nil {
            next := curr.Left
            predecessor := next
            for predecessor.Right != nil {
                predecessor = predecessor.Right
            }
            predecessor.Right = curr.Right
            curr.Left, curr.Right = nil, next
        }
        curr = curr.Right
    }
}
```

```Python [sol3-Python3]
class Solution:
    def flatten(self, root: TreeNode) -> None:
        curr = root
        while curr:
            if curr.left:
                predecessor = nxt = curr.left
                while predecessor.right:
                    predecessor = predecessor.right
                predecessor.right = curr.right
                curr.left = None
                curr.right = nxt
            curr = curr.right
```

```JavaScript [sol3-JavaScript]
var flatten = function(root) {
    let curr = root;
    while (curr !== null) {
        if (curr.left !== null) {
            const next = curr.left;
            let predecessor = next;
            while (predecessor.right !== null) {
                predecessor = predecessor.right;
            }
            predecessor.right = curr.right;
            curr.left = null;
            curr.right = next;
        }
        curr = curr.right;
    }
};
```

```C [sol3-C]
void flatten(struct TreeNode* root) {
    struct TreeNode* curr = root;
    while (curr != NULL) {
        if (curr->left != NULL) {
            struct TreeNode* next = curr->left;
            struct TreeNode* predecessor = next;
            while (predecessor->right != NULL) {
                predecessor = predecessor->right;
            }
            predecessor->right = curr->right;
            curr->left = NULL;
            curr->right = next;
        }
        curr = curr->right;
    }
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数。展开为单链表的过程中，需要对每个节点访问一次，在寻找前驱节点的过程中，每个节点最多被额外访问一次。

- 空间复杂度：$O(1)$。
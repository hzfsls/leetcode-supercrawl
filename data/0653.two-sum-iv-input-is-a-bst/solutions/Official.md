## [653.两数之和 IV - 输入二叉搜索树 中文官方题解](https://leetcode.cn/problems/two-sum-iv-input-is-a-bst/solutions/100000/liang-shu-zhi-he-iv-shu-ru-bst-by-leetco-b4nl)
#### 方法一：深度优先搜索 + 哈希表

**思路和算法**

我们可以使用深度优先搜索的方式遍历整棵树，用哈希表记录遍历过的节点的值。

对于一个值为 $x$ 的节点，我们检查哈希表中是否存在 $k - x$ 即可。如果存在对应的元素，那么我们就可以在该树上找到两个节点的和为 $k$；否则，我们将 $x$ 放入到哈希表中。

如果遍历完整棵树都不存在对应的元素，那么该树上不存在两个和为 $k$ 的节点。

**代码**

```Python [sol1-Python3]
class Solution:
    def __init__(self):
        self.s = set()

    def findTarget(self, root: Optional[TreeNode], k: int) -> bool:
        if root is None:
            return False
        if k - root.val in self.s:
            return True
        self.s.add(root.val)
        return self.findTarget(root.left, k) or self.findTarget(root.right, k)
```

```C++ [sol1-C++]
class Solution {
public:
    unordered_set<int> hashTable;

    bool findTarget(TreeNode *root, int k) {
        if (root == nullptr) {
            return false;
        }
        if (hashTable.count(k - root->val)) {
            return true;
        }
        hashTable.insert(root->val);
        return findTarget(root->left, k) || findTarget(root->right, k);
    }
};
```

```Java [sol1-Java]
class Solution {
    Set<Integer> set = new HashSet<Integer>();

    public boolean findTarget(TreeNode root, int k) {
        if (root == null) {
            return false;
        }
        if (set.contains(k - root.val)) {
            return true;
        }
        set.add(root.val);
        return findTarget(root.left, k) || findTarget(root.right, k);
    }
}
```

```C# [sol1-C#]
public class Solution {
    ISet<int> set = new HashSet<int>();

    public bool FindTarget(TreeNode root, int k) {
        if (root == null) {
            return false;
        }
        if (set.Contains(k - root.val)) {
            return true;
        }
        set.Add(root.val);
        return FindTarget(root.left, k) || FindTarget(root.right, k);
    }
}
```

```C [sol1-C]
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem;

bool helper(const struct TreeNode* root, int k, HashItem ** hashTable) {
    if (root == NULL) {
        return false;
    }
    int key = k - root->val;
    HashItem * pEntry = NULL;
    HASH_FIND_INT(*hashTable, &key, pEntry);
    if (pEntry != NULL) {
        return true;
    }
    pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = root->val;
    HASH_ADD_INT(*hashTable, key, pEntry);
    return helper(root->left, k, hashTable) || helper(root->right, k, hashTable);
}

bool findTarget(struct TreeNode* root, int k){
    HashItem * hashTable = NULL;
    return helper(root, k, &hashTable);
}
```

```JavaScript [sol1-JavaScript]
var findTarget = function(root, k) {
    const set = new Set();
    const helper = (root, k) => {
        if (!root) {
            return false;
        }
        if (set.has(k - root.val)) {
            return true;
        }
        set.add(root.val);
        return helper(root.left, k) || helper(root.right, k);
    }
    return helper(root, k);
};
```

```go [sol1-Golang]
func findTarget(root *TreeNode, k int) bool {
    set := map[int]struct{}{}
    var dfs func(*TreeNode) bool
    dfs = func(node *TreeNode) bool {
        if node == nil {
            return false
        }
        if _, ok := set[k-node.Val]; ok {
            return true
        }
        set[node.Val] = struct{}{}
        return dfs(node.Left) || dfs(node.Right)
    }
    return dfs(root)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉搜索树的大小。我们需要遍历整棵树一次。

- 空间复杂度：$O(n)$，其中 $n$ 为二叉搜索树的大小。主要为哈希表的开销，最坏情况下我们需要将每个节点加入哈希表一次。

#### 方法二：广度优先搜索 + 哈希表

**思路和算法**

我们可以使用广度优先搜索的方式遍历整棵树，用哈希表记录遍历过的节点的值。

具体地，我们首先创建一个哈希表和一个队列，将根节点加入队列中，然后执行以下步骤：

1. 从队列中取出队头，假设其值为 $x$；
2. 检查哈希表中是否存在 $k - x$，如果存在，返回 $\text{True}$；
3. 否则，将该节点的左右的非空子节点加入队尾；
4. 重复以上步骤，直到队列为空；
5. 如果队列为空，说明树上不存在两个和为 $k$ 的节点，返回 $\text{False}$。

**代码**

```Python [sol2-Python3]
class Solution:
    def findTarget(self, root: Optional[TreeNode], k: int) -> bool:
        s = set()
        q = deque([root])
        while q:
            node = q.popleft()
            if k - node.val in s:
                return True
            s.add(node.val)
            if node.left:
                q.append(node.left)
            if node.right:
                q.append(node.right)
        return False
```

```C++ [sol2-C++]
class Solution {
public:
    bool findTarget(TreeNode *root, int k) {
        unordered_set<int> hashTable;
        queue<TreeNode *> que;
        que.push(root);
        while (!que.empty()) {
            TreeNode *node = que.front();
            que.pop();
            if (hashTable.count(k - node->val)) {
                return true;
            }
            hashTable.insert(node->val);
            if (node->left != nullptr) {
                que.push(node->left);
            }
            if (node->right != nullptr) {
                que.push(node->right);
            }
        }
        return false;
    }
};
```

```Java [sol2-Java]
class Solution {
    public boolean findTarget(TreeNode root, int k) {
        Set<Integer> set = new HashSet<Integer>();
        Queue<TreeNode> queue = new ArrayDeque<TreeNode>();
        queue.offer(root);
        while (!queue.isEmpty()) {
            TreeNode node = queue.poll();
            if (set.contains(k - node.val)) {
                return true;
            }
            set.add(node.val);
            if (node.left != null) {
                queue.offer(node.left);
            }
            if (node.right != null) {
                queue.offer(node.right);
            }
        }
        return false;
    }
}
```

```C# [sol2-C#]
public class Solution {
    public bool FindTarget(TreeNode root, int k) {
        ISet<int> set = new HashSet<int>();
        Queue<TreeNode> queue = new Queue<TreeNode>();
        queue.Enqueue(root);
        while (queue.Count > 0) {
            TreeNode node = queue.Dequeue();
            if (set.Contains(k - node.val)) {
                return true;
            }
            set.Add(node.val);
            if (node.left != null) {
                queue.Enqueue(node.left);
            }
            if (node.right != null) {
                queue.Enqueue(node.right);
            }
        }
        return false;
    }
}
```

```C [sol2-C]
#define MAX_NODE_SIZE 1e4

typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem;

bool findTarget(struct TreeNode* root, int k){
    HashItem * hashTable = NULL;
    struct TreeNode ** que = (struct TreeNode **)malloc(sizeof(struct TreeNode *) * MAX_NODE_SIZE);
    int head = 0, tail = 0;
    que[tail++] = root;
    while (head != tail) {
        struct TreeNode *node = que[head++];
        int key = k - node->val;
        HashItem * pEntry = NULL;
        HASH_FIND_INT(hashTable, &key, pEntry);
        if (pEntry != NULL) {
            return true;
        }
        pEntry = (HashItem *)malloc(sizeof(HashItem));
        pEntry->key = node->val;
        HASH_ADD_INT(hashTable, key, pEntry);
        if (node->left != NULL) {
            que[tail++] = node->left;
        }
        if (node->right != NULL) {
            que[tail++] = node->right;
        }
    }
    HashItem * curr = NULL, * next = NULL;
    HASH_ITER(hh, hashTable, curr, next) {
        HASH_DEL(hashTable, curr); 
        free(curr);           
    }
    return false;
}
```

```JavaScript [sol2-JavaScript]
var findTarget = function(root, k) {
    const set = new Set();
    const queue = [];
    queue.push(root);
    while (queue.length) {
        const node = queue.shift();
        if (set.has(k - node.val)) {
            return true;
        }
        set.add(node.val);
        if (node.left) {
            queue.push(node.left);
        }
        if (node.right) {
            queue.push(node.right);
        }
    }
    return false;
};
```

```go [sol2-Golang]
func findTarget(root *TreeNode, k int) bool {
    set := map[int]struct{}{}
    q := []*TreeNode{root}
    for len(q) > 0 {
        node := q[0]
        q = q[1:]
        if _, ok := set[k-node.Val]; ok {
            return true
        }
        set[node.Val] = struct{}{}
        if node.Left != nil {
            q = append(q, node.Left)
        }
        if node.Right != nil {
            q = append(q, node.Right)
        }
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉搜索树的大小。我们需要遍历整棵树一次。

- 空间复杂度：$O(n)$，其中 $n$ 为二叉搜索树的大小。主要为哈希表和队列的开销，最坏情况下我们需要将每个节点加入哈希表和队列各一次。

#### 方法三：深度优先搜索 + 中序遍历 + 双指针

**思路和算法**

注意到二叉搜索树的中序遍历是升序排列的，我们可以将该二叉搜索树的中序遍历的结果记录下来，得到一个升序数组。

这样该问题即转化为「[167. 两数之和 II - 输入有序数组](https://leetcode-cn.com/problems/two-sum-ii-input-array-is-sorted/)」。我们可以使用双指针解决它。

具体地，我们使用两个指针分别指向数组的头尾，当两个指针指向的元素之和小于 $k$ 时，让左指针右移；当两个指针指向的元素之和大于 $k$ 时，让右指针左移；当两个指针指向的元素之和等于 $k$ 时，返回 $\text{True}$。

最终，当左指针和右指针重合时，树上不存在两个和为 $k$ 的节点，返回 $\text{False}$。

**代码**

```Python [sol3-Python3]
class Solution:
    def findTarget(self, root: Optional[TreeNode], k: int) -> bool:
        arr = []
        def inorderTraversal(node: Optional[TreeNode]) -> None:
            if node:
                inorderTraversal(node.left)
                arr.append(node.val)
                inorderTraversal(node.right)
        inorderTraversal(root)

        left, right = 0, len(arr) - 1
        while left < right:
            sum = arr[left] + arr[right]
            if sum == k:
                return True
            if sum < k:
                left += 1
            else:
                right -= 1
        return False
```

```C++ [sol3-C++]
class Solution {
public:
    vector<int> vec;

    void inorderTraversal(TreeNode *node) {
        if (node == nullptr) {
            return;
        }
        inorderTraversal(node->left);
        vec.push_back(node->val);
        inorderTraversal(node->right);
    }

    bool findTarget(TreeNode *root, int k) {
        inorderTraversal(root);
        int left = 0, right = vec.size() - 1;
        while (left < right) {
            if (vec[left] + vec[right] == k) {
                return true;
            }
            if (vec[left] + vec[right] < k) {
                left++;
            } else {
                right--;
            }
        }
        return false;
    }
};
```

```Java [sol3-Java]
class Solution {
    List<Integer> list = new ArrayList<Integer>();

    public boolean findTarget(TreeNode root, int k) {
        inorderTraversal(root);
        int left = 0, right = list.size() - 1;
        while (left < right) {
            if (list.get(left) + list.get(right) == k) {
                return true;
            }
            if (list.get(left) + list.get(right) < k) {
                left++;
            } else {
                right--;
            }
        }
        return false;
    }

    public void inorderTraversal(TreeNode node) {
        if (node == null) {
            return;
        }
        inorderTraversal(node.left);
        list.add(node.val);
        inorderTraversal(node.right);
    }
}
```

```C# [sol3-C#]
public class Solution {
    IList<int> list = new List<int>();

    public bool FindTarget(TreeNode root, int k) {
        InorderTraversal(root);
        int left = 0, right = list.Count - 1;
        while (left < right) {
            if (list[left] + list[right] == k) {
                return true;
            }
            if (list[left] + list[right] < k) {
                left++;
            } else {
                right--;
            }
        }
        return false;
    }

    public void InorderTraversal(TreeNode node) {
        if (node == null) {
            return;
        }
        InorderTraversal(node.left);
        list.Add(node.val);
        InorderTraversal(node.right);
    }
}
```

```C [sol3-C]
#define MAX_NODE_SIZE 1e4

void inorderTraversal(const struct TreeNode* node, int* vec, int* pos) {
    if (node == NULL) {
        return;
    }
    inorderTraversal(node->left, vec, pos);
    vec[(*pos)++] = node->val;
    inorderTraversal(node->right, vec, pos);
}

bool findTarget(struct TreeNode* root, int k) {
    int * vec = (int *)malloc(sizeof(int) * MAX_NODE_SIZE);
    int pos = 0;
    inorderTraversal(root, vec, &pos);
    int left = 0, right = pos - 1;
    while (left < right) {
        if (vec[left] + vec[right] == k) {
            return true;
        }
        if (vec[left] + vec[right] < k) {
            left++;
        } else {
            right--;
        }
    }
    free(vec);
    return false;
}
```

```JavaScript [sol3-JavaScript]
var findTarget = function(root, k) {
    const list = [];
    const inorderTraversal = (node) => {
        if (!node) {
            return;
        }
        inorderTraversal(node.left);
        list.push(node.val);
        inorderTraversal(node.right);
    }
    inorderTraversal(root);
    let left = 0, right = list.length - 1;
    while (left < right) {
        if (list[left] + list[right] === k) {
            return true;
        }
        if (list[left] + list[right] < k) {
            left++;
        } else {
            right--;
        }
    }
    return false;
};
```

```go [sol3-Golang]
func findTarget(root *TreeNode, k int) bool {
    arr := []int{}
    var inorderTraversal func(*TreeNode)
    inorderTraversal = func(node *TreeNode) {
        if node != nil {
            inorderTraversal(node.Left)
            arr = append(arr, node.Val)
            inorderTraversal(node.Right)
        }
    }
    inorderTraversal(root)

    left, right := 0, len(arr)-1
    for left < right {
        sum := arr[left] + arr[right]
        if sum == k {
            return true
        }
        if sum < k {
            left++
        } else {
            right--
        }
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉搜索树的大小。我们需要遍历整棵树一次，并对得到的升序数组使用双指针遍历。

- 空间复杂度：$O(n)$，其中 $n$ 为二叉搜索树的大小。主要为升序数组的开销。

#### 方法四：迭代 + 中序遍历 + 双指针

**思路和算法**

在方法三中，我们是在中序遍历得到的数组上进行双指针，这样需要消耗 $O(n)$ 的空间，实际上我们可以将双指针的移动理解为在树上的遍历过程的一次移动。因为递归方法较难控制移动过程，因此我们使用迭代的方式进行遍历。

具体地，我们对于每个指针新建一个栈。初始，我们让左指针移动到树的最左端点，并将路径保存在栈中，接下来我们可以依据栈来 $O(1)$ 地计算出左指针的下一个位置。右指针也是同理。

计算下一个位置时，我们首先将位于栈顶的当前节点从栈中弹出，此时首先判断当前节点是否存在右子节点，如果存在，那么我们将右子节点的最左子树加入到栈中；否则我们就完成了当前层的遍历，无需进一步修改栈的内容，直接回溯到上一层即可。

**代码**

```Python [sol4-Python3]
class Solution:
    def findTarget(self, root: Optional[TreeNode], k: int) -> bool:
        left, right = root, root
        leftStk, rightStk = [left], [right]
        while left.left:
            left = left.left
            leftStk.append(left)
        while right.right:
            right = right.right
            rightStk.append(right)
        while left != right:
            sum = left.val + right.val
            if sum == k:
                return True
            if sum < k:
                left = leftStk.pop()
                node = left.right
                while node:
                    leftStk.append(node)
                    node = node.left
            else:
                right = rightStk.pop()
                node = right.left
                while node:
                    rightStk.append(node)
                    node = node.right
        return False
```

```C++ [sol4-C++]
class Solution {
public:
    TreeNode *getLeft(stack<TreeNode *> &stk) {
        TreeNode *root = stk.top();
        stk.pop();
        TreeNode *node = root->right;
        while (node != nullptr) {
            stk.push(node);
            node = node->left;
        }
        return root;
    }

    TreeNode *getRight(stack<TreeNode *> &stk) {
        TreeNode *root = stk.top();
        stk.pop();
        TreeNode *node = root->left;
        while (node != nullptr) {
            stk.push(node);
            node = node->right;
        }
        return root;
    }

    bool findTarget(TreeNode *root, int k) {
        TreeNode *left = root, *right = root;
        stack<TreeNode *> leftStack, rightStack;
        leftStack.push(left);
        while (left->left != nullptr) {
            leftStack.push(left->left);
            left = left->left;
        }
        rightStack.push(right);
        while (right->right != nullptr) {
            rightStack.push(right->right);
            right = right->right;
        }
        while (left != right) {
            if (left->val + right->val == k) {
                return true;
            }
            if (left->val + right->val < k) {
                left = getLeft(leftStack);
            } else {
                right = getRight(rightStack);
            }
        }
        return false;
    }
};
```

```Java [sol4-Java]
class Solution {
    public boolean findTarget(TreeNode root, int k) {
        TreeNode left = root, right = root;
        Deque<TreeNode> leftStack = new ArrayDeque<TreeNode>();
        Deque<TreeNode> rightStack = new ArrayDeque<TreeNode>();
        leftStack.push(left);
        while (left.left != null) {
            leftStack.push(left.left);
            left = left.left;
        }
        rightStack.push(right);
        while (right.right != null) {
            rightStack.push(right.right);
            right = right.right;
        }
        while (left != right) {
            if (left.val + right.val == k) {
                return true;
            }
            if (left.val + right.val < k) {
                left = getLeft(leftStack);
            } else {
                right = getRight(rightStack);
            }
        }
        return false;
    }

    public TreeNode getLeft(Deque<TreeNode> stack) {
        TreeNode root = stack.pop();
        TreeNode node = root.right;
        while (node != null) {
            stack.push(node);
            node = node.left;
        }
        return root;
    }

    public TreeNode getRight(Deque<TreeNode> stack) {
        TreeNode root = stack.pop();
        TreeNode node = root.left;
        while (node != null) {
            stack.push(node);
            node = node.right;
        }
        return root;
    }
}
```

```C# [sol4-C#]
public class Solution {
    public bool FindTarget(TreeNode root, int k) {
        TreeNode left = root, right = root;
        Stack<TreeNode> leftStack = new Stack<TreeNode>();
        Stack<TreeNode> rightStack = new Stack<TreeNode>();
        leftStack.Push(left);
        while (left.left != null) {
            leftStack.Push(left.left);
            left = left.left;
        }
        rightStack.Push(right);
        while (right.right != null) {
            rightStack.Push(right.right);
            right = right.right;
        }
        while (left != right) {
            if (left.val + right.val == k) {
                return true;
            }
            if (left.val + right.val < k) {
                left = GetLeft(leftStack);
            } else {
                right = GetRight(rightStack);
            }
        }
        return false;
    }

    public TreeNode GetLeft(Stack<TreeNode> stack) {
        TreeNode root = stack.Pop();
        TreeNode node = root.right;
        while (node != null) {
            stack.Push(node);
            node = node.left;
        }
        return root;
    }

    public TreeNode GetRight(Stack<TreeNode> stack) {
        TreeNode root = stack.Pop();
        TreeNode node = root.left;
        while (node != null) {
            stack.Push(node);
            node = node.right;
        }
        return root;
    }
}
```

```C [sol4-C]
#define MAX_NODE_SIZE 1e4 

typedef struct {
    struct TreeNode ** stBuf;
    int stTop;
    int stSize;
} Stack;

void init(Stack* obj, int stSize) {
    obj->stBuf = (struct TreeNode **)malloc(sizeof(struct TreeNode *) * stSize);
    obj->stTop = 0;
    obj->stSize = stSize;
}

bool isEmpty(const Stack* obj) {
    return obj->stTop == 0;
}

struct TreeNode * top(const Stack* obj) {
    return obj->stBuf[obj->stTop - 1];
}

bool push(Stack * obj, struct TreeNode* val) {
    if(obj->stTop == obj->stSize) {
        return false;
    }
    obj->stBuf[obj->stTop++] = val;
    return true;
}

void freeStack(Stack * obj) {
    free(obj->stBuf);
}

struct TreeNode * pop(Stack* obj) {
    if(obj->stTop == 0) {
        return NULL;
    }
    struct TreeNode *res = obj->stBuf[obj->stTop - 1];
    obj->stTop--;
    return res;
}

struct TreeNode *getLeft(Stack* stk) {
    struct TreeNode *root = pop(stk);
    struct TreeNode *node = root->right;
    while (node != NULL) {
        push(stk, node);
        node = node->left;
    }
    return root;
}

struct TreeNode *getRight(Stack* stk) {
    struct TreeNode *root = pop(stk);
    struct TreeNode *node = root->left;
    while (node != NULL) {
        push(stk, node);
        node = node->right;
    }
    return root;
}

bool findTarget(struct TreeNode* root, int k){
    struct TreeNode *left = root, *right = root;
    Stack leftStack, rightStack;
    init(&leftStack, MAX_NODE_SIZE);
    init(&rightStack, MAX_NODE_SIZE);
    push(&leftStack, left);
    while (left->left != NULL) {
        push(&leftStack, left->left);
        left = left->left;
    }
    push(&rightStack, right);
    while (right->right != NULL) {
        push(&rightStack, right->right);
        right = right->right;
    }
    while (left != right) {
        if (left->val + right->val == k) {
            freeStack(&leftStack);
            freeStack(&rightStack);
            return true;
        }
        if (left->val + right->val < k) {
            left = getLeft(&leftStack);
        } else {
            right = getRight(&rightStack);
        }
    }
    freeStack(&leftStack);
    freeStack(&rightStack);
    return false;
}
```

```JavaScript [sol4-JavaScript]
var findTarget = function(root, k) {
    const getLeft = (stack) => {
        const root = stack.pop();
        let node = root.right;
        while (node) {
            stack.push(node);
            node = node.left;
        }
        return root;
    }

    const getRight = (stack) => {
        const root = stack.pop();
        let node = root.left;
        while (node) {
            stack.push(node);
            node = node.right;
        }
        return root;
    };

    let left = root, right = root;
    const leftStack = [];
    const rightStack = [];
    leftStack.push(left);
    while (left.left) {
        leftStack.push(left.left);
        left = left.left;
    }
    rightStack.push(right);
    while (right.right) {
        rightStack.push(right.right);
        right = right.right;
    }
    while (left !== right) {
        if (left.val + right.val === k) {
            return true;
        }
        if (left.val + right.val < k) {
            left = getLeft(leftStack);
        } else {
            right = getRight(rightStack);
        }
    }
    return false;
}
```

```go [sol4-Golang]
func findTarget(root *TreeNode, k int) bool {
    left, right := root, root
    leftStk := []*TreeNode{left}
    for left.Left != nil {
        leftStk = append(leftStk, left.Left)
        left = left.Left
    }
    rightStk := []*TreeNode{right}
    for right.Right != nil {
        rightStk = append(rightStk, right.Right)
        right = right.Right
    }
    for left != right {
        sum := left.Val + right.Val
        if sum == k {
            return true
        }
        if sum < k {
            left = leftStk[len(leftStk)-1]
            leftStk = leftStk[:len(leftStk)-1]
            for node := left.Right; node != nil; node = node.Left {
                leftStk = append(leftStk, node)
            }
        } else {
            right = rightStk[len(rightStk)-1]
            rightStk = rightStk[:len(rightStk)-1]
            for node := right.Left; node != nil; node = node.Right {
                rightStk = append(rightStk, node)
            }
        }
    }
    return false
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉搜索树的大小。在双指针的过程中，我们实际上遍历了整棵树一次。

- 空间复杂度：$O(n)$，其中 $n$ 为二叉搜索树的大小。主要为栈的开销，最坏情况下二叉搜索树为一条链，需要 $O(n)$ 的栈空间。
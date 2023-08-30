#### 方法一：广度优先搜索

由于判断一棵二叉树是否为奇偶树的条件是针对同一层的节点，因此可以使用广度优先搜索，每一轮搜索访问同一层的全部节点，且只会访问这一层的节点。

使用队列存储节点。初始时，将根节点加入队列。每一轮搜索之前，队列中的节点是同一层的全部节点，记队列的大小为 $\textit{size}$，该轮搜索只访问 $\textit{size}$ 个节点，即可保证该轮搜索访问的恰好是同一层的全部节点。搜索过程中，将当前层的节点的非空子节点依次加入队列，用于下一层的搜索。

判断一棵二叉树是否为奇偶树，需要考虑两个条件，一是节点值的奇偶性，二是节点值的单调性，这两个条件都由层下标的奇偶性决定。因此，需要维护搜索到的层下标，以及对于每一层搜索都需要维护上一个节点值。

如果当前层下标是偶数，则要求当前层的所有节点的值都是奇数，且节点值从左到右严格递增。如果遇到节点值是偶数，或者当前节点值小于等于上一个节点值，则二叉树一定不是奇偶树。

如果当前层下标是奇数，则要求当前层的所有节点的值都是偶数，且节点值从左到右严格递减。如果遇到节点值是奇数，或者当前节点值大于等于上一个节点值，则二叉树一定不是奇偶树。

如果二叉树的所有节点都满足奇偶树的条件，则二叉树是奇偶树。

```Java [sol1-Java]
class Solution {
    public boolean isEvenOddTree(TreeNode root) {
        Queue<TreeNode> queue = new ArrayDeque<TreeNode>();
        queue.offer(root);
        int level = 0;
        while (!queue.isEmpty()) {
            int size = queue.size();
            int prev = level % 2 == 0 ? Integer.MIN_VALUE : Integer.MAX_VALUE;
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                int value = node.val;
                if (level % 2 == value % 2) {
                    return false;
                }
                if ((level % 2 == 0 && value <= prev) || (level % 2 == 1 && value >= prev)) {
                    return false;
                }
                prev = value;
                if (node.left != null) {
                    queue.offer(node.left);
                }
                if (node.right != null) {
                    queue.offer(node.right);
                }
            }
            level++;
        }
        return true;
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool IsEvenOddTree(TreeNode root) {
        Queue<TreeNode> queue = new Queue<TreeNode>();
        queue.Enqueue(root);
        int level = 0;
        while (queue.Count > 0) {
            int size = queue.Count;
            int prev = level % 2 == 0 ? int.MinValue : int.MaxValue;
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.Dequeue();
                int value = node.val;
                if (level % 2 == value % 2) {
                    return false;
                }
                if ((level % 2 == 0 && value <= prev) || (level % 2 == 1 && value >= prev)) {
                    return false;
                }
                prev = value;
                if (node.left != null) {
                    queue.Enqueue(node.left);
                }
                if (node.right != null) {
                    queue.Enqueue(node.right);
                }
            }
            level++;
        }
        return true;
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    bool isEvenOddTree(TreeNode* root) {
        queue<TreeNode*> qu;
        qu.push(root);
        int level = 0;
        while (!qu.empty()) {
            int size = qu.size();
            int prev = level % 2 == 0 ? INT_MIN : INT_MAX;
            for (int i = 0; i < size; i++) {
                TreeNode * node = qu.front();
                qu.pop();
                int value = node->val;
                if (level % 2 == value % 2) {
                    return false;
                }
                if ((level % 2 == 0 && value <= prev) || (level % 2 == 1 && value >= prev)) {
                    return false;
                }
                prev = value;
                if (node->left != nullptr) {
                    qu.push(node->left);
                }
                if (node->right != nullptr) {
                    qu.push(node->right);
                }
            }
            level++;
        }
        return true;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def isEvenOddTree(self, root: Optional[TreeNode]) -> bool:
        queue = [root]
        level = 0
        while queue:
            prev = float('inf') if level % 2 else 0
            nxt = []
            for node in queue:
                val = node.val
                if val % 2 == level % 2 or level % 2 == 0 and val <= prev or level % 2 == 1 and val >= prev:
                    return False
                prev = val
                if node.left:
                    nxt.append(node.left)
                if node.right:
                    nxt.append(node.right)
            queue = nxt
            level += 1
        return True
```

```JavaScript [sol1-JavaScript]
var isEvenOddTree = function(root) {
    const queue = [];
    queue.push(root);
    let level = 0;
    while (queue.length) {
        const size = queue.length;
        let prev = level % 2 == 0 ? -Number.MAX_VALUE : Number.MAX_VALUE;
        for (let i = 0; i < size; i++) {
            const node = queue.shift();
            const value = node.val;
            if (level % 2 === value % 2) {
                return false;
            }
            if ((level % 2 === 0 && value <= prev) || (level % 2 === 1 && value >= prev)) {
                return false;
            }
            prev = value;
            if (node.left) {
                queue.push(node.left);
            }
            if (node.right) {
                queue.push(node.right);
            }
        }
        level++;
    }
    return true;
};
```

```C [sol1-C]
#define MAX_SIZE 100001

bool isEvenOddTree(struct TreeNode* root){
    struct TreeNode* qu[MAX_SIZE];
    int head = 0, tail = 0;
    qu[head++] = root;
    int level = 0;
    while (tail < head) {
        int size = head - tail;
        int prev = level % 2 == 0 ? INT_MIN : INT_MAX;
        for (int i = 0; i < size; i++) {
            struct TreeNode * node = qu[tail++];
            int value = node->val;
            if (level % 2 == value % 2) {
                return false;
            }
            if ((level % 2 == 0 && value <= prev) || (level % 2 == 1 && value >= prev)) {
                return false;
            }
            prev = value;
            if (node->left != NULL) {
                qu[head++] = node->left;
            }
            if (node->right != NULL) {
                qu[head++] = node->right;
            }
        }
        level++;
    }
    return true;
}
```

```go [sol1-Golang]
func isEvenOddTree(root *TreeNode) bool {
    q := []*TreeNode{root}
    for level := 0; len(q) > 0; level++ {
        prev := 0
        if level%2 == 1 {
            prev = math.MaxInt32
        }
        size := len(q)
        for _, node := range q {
            val := node.Val
            if val%2 == level%2 || level%2 == 0 && val <= prev || level%2 == 1 && val >= prev {
                return false
            }
            prev = val
            if node.Left != nil {
                q = append(q, node.Left)
            }
            if node.Right != nil {
                q = append(q, node.Right)
            }
        }
        q = q[size:]
    }
    return true
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数。广度优先搜索会对每个节点访问一次。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树的节点数。空间复杂度主要取决于队列的开销，队列中的元素个数不会超过 $n$。
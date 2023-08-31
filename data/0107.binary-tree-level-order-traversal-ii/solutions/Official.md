## [107.二叉树的层序遍历 II 中文官方题解](https://leetcode.cn/problems/binary-tree-level-order-traversal-ii/solutions/100000/er-cha-shu-de-ceng-ci-bian-li-ii-by-leetcode-solut)
#### 前言

这道题和「[102. 二叉树的层序遍历](https://leetcode-cn.com/problems/binary-tree-level-order-traversal/)」相似，不同之处在于，第 102 题要求从上到下输出每一层的节点值，而这道题要求从下到上输出每一层的节点值。除了输出顺序不同以外，这两道题的思路是相同的，都可以使用广度优先搜索进行层次遍历。

#### 方法一：广度优先搜索

树的层次遍历可以使用广度优先搜索实现。从根节点开始搜索，每次遍历同一层的全部节点，使用一个列表存储该层的节点值。

如果要求从上到下输出每一层的节点值，做法是很直观的，在遍历完一层节点之后，将存储该层节点值的列表添加到结果列表的尾部。这道题要求从下到上输出每一层的节点值，只要对上述操作稍作修改即可：在遍历完一层节点之后，将存储该层节点值的列表添加到结果列表的头部。

为了降低在结果列表的头部添加一层节点值的列表的时间复杂度，结果列表可以使用链表的结构，在链表头部添加一层节点值的列表的时间复杂度是 $O(1)$。在 Java 中，由于我们需要返回的 `List` 是一个接口，这里可以使用链表实现；而 C++ 或 Python 中，我们需要返回一个 `vector` 或 `list`，它不方便在头部插入元素（会增加时间开销），所以我们可以先用尾部插入的方法得到从上到下的层次遍历列表，然后再进行反转。

```Java [sol1-Java]
class Solution {
    public List<List<Integer>> levelOrderBottom(TreeNode root) {
        List<List<Integer>> levelOrder = new LinkedList<List<Integer>>();
        if (root == null) {
            return levelOrder;
        }
        Queue<TreeNode> queue = new LinkedList<TreeNode>();
        queue.offer(root);
        while (!queue.isEmpty()) {
            List<Integer> level = new ArrayList<Integer>();
            int size = queue.size();
            for (int i = 0; i < size; i++) {
                TreeNode node = queue.poll();
                level.add(node.val);
                TreeNode left = node.left, right = node.right;
                if (left != null) {
                    queue.offer(left);
                }
                if (right != null) {
                    queue.offer(right);
                }
            }
            levelOrder.add(0, level);
        }
        return levelOrder;
    }
}
```

```cpp [sol1-C++]
class Solution {
public:
    vector<vector<int>> levelOrderBottom(TreeNode* root) {
        auto levelOrder = vector<vector<int>>();
        if (!root) {
            return levelOrder;
        }
        queue<TreeNode*> q;
        q.push(root);
        while (!q.empty()) {
            auto level = vector<int>();
            int size = q.size();
            for (int i = 0; i < size; ++i) {
                auto node = q.front();
                q.pop();
                level.push_back(node->val);
                if (node->left) {
                    q.push(node->left);
                }
                if (node->right) {
                    q.push(node->right);
                }
            }
            levelOrder.push_back(level);
        }
        reverse(levelOrder.begin(), levelOrder.end());
        return levelOrder;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def levelOrderBottom(self, root: TreeNode) -> List[List[int]]:
        levelOrder = list()
        if not root:
            return levelOrder
        
        q = collections.deque([root])
        while q:
            level = list()
            size = len(q)
            for _ in range(size):
                node = q.popleft()
                level.append(node.val)
                if node.left:
                    q.append(node.left)
                if node.right:
                    q.append(node.right)
            levelOrder.append(level)

        return levelOrder[::-1]
```

```C [sol1-C]
int** levelOrderBottom(struct TreeNode* root, int* returnSize, int** returnColumnSizes) {
    int** levelOrder = malloc(sizeof(int*) * 2001);
    *returnColumnSizes = malloc(sizeof(int) * 2001);
    *returnSize = 0;
    if (!root) {
        return levelOrder;
    }
    struct TreeNode** q = malloc(sizeof(struct TreeNode*) * 2001);
    int left = 0, right = 0;
    q[right++] = root;
    while (left < right) {
        int len = right - left;
        int* level = malloc(sizeof(int) * len);
        (*returnColumnSizes)[*returnSize] = len;
        for (int i = 0; i < len; ++i) {
            struct TreeNode* node = q[left++];
            level[i] = node->val;
            if (node->left != NULL) {
                q[right++] = node->left;
            }
            if (node->right != NULL) {
                q[right++] = node->right;
            }
        }
        levelOrder[(*returnSize)++] = level;
    }
    for (int i = 0; 2 * i < *returnSize; ++i) {
        int* tmp1 = levelOrder[i];
        levelOrder[i] = levelOrder[(*returnSize) - i - 1];
        levelOrder[(*returnSize) - i - 1] = tmp1;
        int tmp2 = (*returnColumnSizes)[i];
        (*returnColumnSizes)[i] = (*returnColumnSizes)[(*returnSize) - i - 1];
        (*returnColumnSizes)[(*returnSize) - i - 1] = tmp2;
    }
    return levelOrder;
}
```

```golang [sol1-Golang]
func levelOrderBottom(root *TreeNode) [][]int {
    levelOrder := [][]int{}
    if root == nil {
        return levelOrder
    }
    queue := []*TreeNode{}
    queue = append(queue, root)
    for len(queue) > 0 {
        level := []int{}
        size := len(queue)
        for i := 0; i < size; i++ {
            node := queue[0]
            queue = queue[1:]
            level = append(level, node.Val)
            if node.Left != nil {
                queue = append(queue, node.Left)
            }
            if node.Right != nil {
                queue = append(queue, node.Right)
            }
        }
        levelOrder = append(levelOrder, level)
    }
    for i := 0; i < len(levelOrder) / 2; i++ {
        levelOrder[i], levelOrder[len(levelOrder) - 1 - i] = levelOrder[len(levelOrder) - 1 - i], levelOrder[i]
    }
    return levelOrder
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树中的节点个数。每个节点访问一次，结果列表使用链表的结构时，在结果列表头部添加一层节点值的列表的时间复杂度是 $O(1)$，因此总时间复杂度是 $O(n)$。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树中的节点个数。空间复杂度取决于队列开销，队列中的节点个数不会超过 $n$。
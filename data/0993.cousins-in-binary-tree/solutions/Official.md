## [993.二叉树的堂兄弟节点 中文官方题解](https://leetcode.cn/problems/cousins-in-binary-tree/solutions/100000/er-cha-shu-de-tang-xiong-di-jie-dian-by-mfh2d)

#### 前言

要想判断两个节点 $x$ 和 $y$ 是否为堂兄弟节点，我们就需要求出这两个节点分别的「深度」以及「父节点」。

因此，我们可以从根节点开始，对树进行一次遍历，在遍历的过程中维护「深度」以及「父节点」这两个信息。当我们遍历到 $x$ 或 $y$ 节点时，就将信息记录下来；当这两个节点都遍历完成了以后，我们就可以退出遍历的过程，判断它们是否为堂兄弟节点了。

常见的遍历方法有两种：深度优先搜索和广度优先搜索。

#### 方法一：深度优先搜索

**思路与算法**

我们只需要在深度优先搜索的递归函数中增加表示「深度」以及「父节点」的两个参数即可。

**代码**

```C++ [sol1-C++]
class Solution {
private:
    // x 的信息
    int x;
    TreeNode* x_parent;
    int x_depth;
    bool x_found = false;

    // y 的信息
    int y;
    TreeNode* y_parent;
    int y_depth;
    bool y_found = false;

public:
    void dfs(TreeNode* node, int depth, TreeNode* parent) {
        if (!node) {
            return;
        }

        if (node->val == x) {
            tie(x_parent, x_depth, x_found) = tuple{parent, depth, true};
        }
        else if (node->val == y) {
            tie(y_parent, y_depth, y_found) = tuple{parent, depth, true};
        }

        // 如果两个节点都找到了，就可以提前退出遍历
        // 即使不提前退出，对最坏情况下的时间复杂度也不会有影响
        if (x_found && y_found) {
            return;
        }

        dfs(node->left, depth + 1, node);

        if (x_found && y_found) {
            return;
        }

        dfs(node->right, depth + 1, node);
    }

    bool isCousins(TreeNode* root, int x, int y) {
        this->x = x;
        this->y = y;
        dfs(root, 0, nullptr);
        return x_depth == y_depth && x_parent != y_parent;
    }
};
```

```Java [sol1-Java]
class Solution {
    // x 的信息
    int x;
    TreeNode xParent;
    int xDepth;
    boolean xFound = false;

    // y 的信息
    int y;
    TreeNode yParent;
    int yDepth;
    boolean yFound = false;

    public boolean isCousins(TreeNode root, int x, int y) {
        this.x = x;
        this.y = y;
        dfs(root, 0, null);
        return xDepth == yDepth && xParent != yParent;
    }

    public void dfs(TreeNode node, int depth, TreeNode parent) {
        if (node == null) {
            return;
        }

        if (node.val == x) {
            xParent = parent;
            xDepth = depth;
            xFound = true;
        } else if (node.val == y) {
            yParent = parent;
            yDepth = depth;
            yFound = true;
        }

        // 如果两个节点都找到了，就可以提前退出遍历
        // 即使不提前退出，对最坏情况下的时间复杂度也不会有影响
        if (xFound && yFound) {
            return;
        }

        dfs(node.left, depth + 1, node);

        if (xFound && yFound) {
            return;
        }

        dfs(node.right, depth + 1, node);
    }
}
```

```C# [sol1-C#]
public class Solution {
    // x 的信息
    int x;
    TreeNode xParent;
    int xDepth;
    bool xFound = false;

    // y 的信息
    int y;
    TreeNode yParent;
    int yDepth;
    bool yFound = false;

    public bool IsCousins(TreeNode root, int x, int y) {
        this.x = x;
        this.y = y;
        DFS(root, 0, null);
        return xDepth == yDepth && xParent != yParent;
    }

    public void DFS(TreeNode node, int depth, TreeNode parent) {
        if (node == null) {
            return;
        }

        if (node.val == x) {
            xParent = parent;
            xDepth = depth;
            xFound = true;
        } else if (node.val == y) {
            yParent = parent;
            yDepth = depth;
            yFound = true;
        }

        // 如果两个节点都找到了，就可以提前退出遍历
        // 即使不提前退出，对最坏情况下的时间复杂度也不会有影响
        if (xFound && yFound) {
            return;
        }

        DFS(node.left, depth + 1, node);

        if (xFound && yFound) {
            return;
        }

        DFS(node.right, depth + 1, node);
    }
}
```

```Python [sol1-Python3]
class Solution:
    def isCousins(self, root: TreeNode, x: int, y: int) -> bool:
        # x 的信息
        x_parent, x_depth, x_found = None, None, False
        # y 的信息
        y_parent, y_depth, y_found = None, None, False
        
        def dfs(node: TreeNode, depth: int, parent: TreeNode):
            if not node:
                return
            
            nonlocal x_parent, y_parent, x_depth, y_depth, x_found, y_found
            
            if node.val == x:
                x_parent, x_depth, x_found = parent, depth, True
            elif node.val == y:
                y_parent, y_depth, y_found = parent, depth, True

            # 如果两个节点都找到了，就可以提前退出遍历
            # 即使不提前退出，对最坏情况下的时间复杂度也不会有影响
            if x_found and y_found:
                return

            dfs(node.left, depth + 1, node)

            if x_found and y_found:
                return

            dfs(node.right, depth + 1, node)

        dfs(root, 0, None)
        return x_depth == y_depth and x_parent != y_parent
```

```JavaScript [sol1-JavaScript]
var isCousins = function(root, x, y) {
    // x 的信息
    let x_parent = null, x_depth = null, x_found = false;
    // y 的信息
    let y_parent = null, y_depth = null, y_found = false;
    
    const dfs = (node, depth, parent) => {
        if (!node) {
            return;
        }
        if (node.val === x) {
            [x_parent, x_depth, x_found] = [parent, depth, true];
        } else if (node.val === y) {
            [y_parent, y_depth, y_found] = [parent, depth, true];
        }

        // 如果两个节点都找到了，就可以提前退出遍历
        // 即使不提前退出，对最坏情况下的时间复杂度也不会有影响
        if (x_found && y_found) {
            return;
        }

        dfs(node.left, depth + 1, node);

        if (x_found && y_found) {
            return;
        }

        dfs(node.right, depth + 1, node);
    }
    dfs(root, 0, null);
    return x_depth === y_depth && x_parent !== y_parent;
};
```

```go [sol1-Golang]
func isCousins(root *TreeNode, x, y int) bool {
    var xParent, yParent *TreeNode
    var xDepth, yDepth int
    var xFound, yFound bool

    var dfs func(node, parent *TreeNode, depth int)
    dfs = func(node, parent *TreeNode, depth int) {
        if node == nil {
            return
        }

        if node.Val == x {
            xParent, xDepth, xFound = parent, depth, true
        } else if node.Val == y {
            yParent, yDepth, yFound = parent, depth, true
        }

        // 如果两个节点都找到了，就可以提前退出遍历
        // 即使不提前退出，对最坏情况下的时间复杂度也不会有影响
        if xFound && yFound {
            return
        }

        dfs(node.Left, node, depth+1)

        if xFound && yFound {
            return
        }

        dfs(node.Right, node, depth+1)
    }
    dfs(root, nil, 0)

    return xDepth == yDepth && xParent != yParent
}
```

```C [sol1-C]
// x 的信息
int x_target;
struct TreeNode* x_parent;
int x_depth;
bool x_found;

// y 的信息
int y_target;
struct TreeNode* y_parent;
int y_depth;
bool y_found;

void dfs(struct TreeNode* node, int depth, struct TreeNode* parent) {
    if (!node) {
        return;
    }

    if (node->val == x_target) {
        x_parent = parent;
        x_depth = depth;
        x_found = true;
    } else if (node->val == y_target) {
        y_parent = parent;
        y_depth = depth;
        y_found = true;
    }

    // 如果两个节点都找到了，就可以提前退出遍历
    // 即使不提前退出，对最坏情况下的时间复杂度也不会有影响
    if (x_found && y_found) {
        return;
    }

    dfs(node->left, depth + 1, node);

    if (x_found && y_found) {
        return;
    }

    dfs(node->right, depth + 1, node);
}

bool isCousins(struct TreeNode* root, int x, int y) {
    x_target = x;
    y_target = y;
    x_found = false;
    y_found = false;
    dfs(root, 0, NULL);
    return x_depth == y_depth && x_parent != y_parent;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是树中的节点个数。在最坏情况下，我们需要遍历整棵树，时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，即为深度优先搜索的过程中需要使用的栈空间。在最坏情况下，树呈现链状结构，递归的深度为 $O(n)$。

#### 方法二：广度优先搜索

**思路与算法**

在广度优先搜索的过程中，每当我们从队首取出一个节点，它就会作为「父节点」，将最多两个子节点放入队尾。因此，除了节点以外，我们只需要在队列中额外存储「深度」的信息即可。

**代码**

```C++ [sol2-C++]
class Solution {
private:
    // x 的信息
    int x;
    TreeNode* x_parent;
    int x_depth;
    bool x_found = false;

    // y 的信息
    int y;
    TreeNode* y_parent;
    int y_depth;
    bool y_found = false;

public:
    // 用来判断是否遍历到 x 或 y 的辅助函数
    void update(TreeNode* node, TreeNode* parent, int depth) {
        if (node->val == x) {
            tie(x_parent, x_depth, x_found) = tuple{parent, depth, true};
        }
        else if (node->val == y) {
            tie(y_parent, y_depth, y_found) = tuple{parent, depth, true};
        }
    }

    bool isCousins(TreeNode* root, int x, int y) {
        this->x = x;
        this->y = y;
        queue<pair<TreeNode*, int>> q;
        q.emplace(root, 0);
        update(root, nullptr, 0);

        while (!q.empty()) {
            auto&& [node, depth] = q.front();
            if (node->left) {
                q.emplace(node->left, depth + 1);
                update(node->left, node, depth + 1);
            }
            if (node->right) {
                q.emplace(node->right, depth + 1);
                update(node->right, node, depth + 1);
            }
            if (x_found && y_found) {
                break;
            }
            q.pop();
        }

        return x_depth == y_depth && x_parent != y_parent;
    }
};
```

```Java [sol2-Java]
class Solution {
    // x 的信息
    int x;
    TreeNode xParent;
    int xDepth;
    boolean xFound = false;

    // y 的信息
    int y;
    TreeNode yParent;
    int yDepth;
    boolean yFound = false;

    public boolean isCousins(TreeNode root, int x, int y) {
        this.x = x;
        this.y = y;

        Queue<TreeNode> nodeQueue = new LinkedList<TreeNode>();
        Queue<Integer> depthQueue = new LinkedList<Integer>();
        nodeQueue.offer(root);
        depthQueue.offer(0);
        update(root, null, 0);

        while (!nodeQueue.isEmpty()) {
            TreeNode node = nodeQueue.poll();
            int depth = depthQueue.poll();
            if (node.left != null) {
                nodeQueue.offer(node.left);
                depthQueue.offer(depth + 1);
                update(node.left, node, depth + 1);
            }
            if (node.right != null) {
                nodeQueue.offer(node.right);
                depthQueue.offer(depth + 1);
                update(node.right, node, depth + 1);
            }
            if (xFound && yFound) {
                break;
            }
        }

        return xDepth == yDepth && xParent != yParent;
    }

    // 用来判断是否遍历到 x 或 y 的辅助函数
    public void update(TreeNode node, TreeNode parent, int depth) {
        if (node.val == x) {
            xParent = parent;
            xDepth = depth;
            xFound = true;
        } else if (node.val == y) {
            yParent = parent;
            yDepth = depth;
            yFound = true;
        }
    }
}
```

```C# [sol2-C#]
public class Solution {
    // x 的信息
    int x;
    TreeNode xParent;
    int xDepth;
    bool xFound = false;

    // y 的信息
    int y;
    TreeNode yParent;
    int yDepth;
    bool yFound = false;

    public bool IsCousins(TreeNode root, int x, int y) {
        this.x = x;
        this.y = y;

        Queue<Tuple<TreeNode, int>> queue = new Queue<Tuple<TreeNode, int>>();
        queue.Enqueue(new Tuple<TreeNode, int>(root, 0));
        Update(root, null, 0);

        while (queue.Count > 0) {
            Tuple<TreeNode, int> tuple = queue.Dequeue();
            TreeNode node = tuple.Item1;
            int depth = tuple.Item2;
            if (node.left != null) {
                queue.Enqueue(new Tuple<TreeNode, int>(node.left, depth + 1));
                Update(node.left, node, depth + 1);
            }
            if (node.right != null) {
                queue.Enqueue(new Tuple<TreeNode, int>(node.right, depth + 1));
                Update(node.right, node, depth + 1);
            }
            if (xFound && yFound) {
                break;
            }
        }

        return xDepth == yDepth && xParent != yParent;
    }

    // 用来判断是否遍历到 x 或 y 的辅助函数
    public void Update(TreeNode node, TreeNode parent, int depth) {
        if (node.val == x) {
            xParent = parent;
            xDepth = depth;
            xFound = true;
        } else if (node.val == y) {
            yParent = parent;
            yDepth = depth;
            yFound = true;
        }
    }
}
```

```Python [sol2-Python3]
class Solution:
    def isCousins(self, root: TreeNode, x: int, y: int) -> bool:
        # x 的信息
        x_parent, x_depth, x_found = None, None, False
        # y 的信息
        y_parent, y_depth, y_found = None, None, False
        
        # 用来判断是否遍历到 x 或 y 的辅助函数
        def update(node: TreeNode, parent: TreeNode, depth: int):
            if node.val == x:
                nonlocal x_parent, x_depth, x_found
                x_parent, x_depth, x_found = parent, depth, True
            elif node.val == y:
                nonlocal y_parent, y_depth, y_found
                y_parent, y_depth, y_found = parent, depth, True

        q = collections.deque([(root, 0)])
        update(root, None, 0)

        while q:
            node, depth = q.popleft()
            if node.left:
                q.append((node.left, depth + 1))
                update(node.left, node, depth + 1)
            if node.right:
                q.append((node.right, depth + 1))
                update(node.right, node, depth + 1)
            
            if x_found and y_found:
                break

        return x_depth == y_depth and x_parent != y_parent
```

```JavaScript [sol2-JavaScript]
var isCousins = function(root, x, y) {
    // x 的信息
    let x_parent = null, x_depth = null, x_found = false;
    // y 的信息
    let y_parent = null, y_depth = null, y_found = false;
    
    // 用来判断是否遍历到 x 或 y 的辅助函数
    const update = (node, parent, depth) => {
        if (node.val === x) {
            [x_parent, x_depth, x_found] = [parent, depth, true];
        } else if (node.val === y) {
            [y_parent, y_depth, y_found] = [parent, depth, true];
        }
    }

    q = [[root, 0]];
    update(root, null, 0);

    while (q.length) {
        const [node, depth] = q.shift()
        if (node.left){
            q.push([node.left, depth + 1]);
            update(node.left, node, depth + 1);
        }
        if (node.right) {
            q.push([node.right, depth + 1]);
            update(node.right, node, depth + 1);
        }
        
        if (x_found && y_found) {
            break;
        }
    }

    return x_depth === y_depth && x_parent !== y_parent;
};
```

```go [sol2-Golang]
func isCousins(root *TreeNode, x, y int) bool {
    var xParent, yParent *TreeNode
    var xDepth, yDepth int
    var xFound, yFound bool

    // 用来判断是否遍历到 x 或 y 的辅助函数
    update := func(node, parent *TreeNode, depth int) {
        if node.Val == x {
            xParent, xDepth, xFound = parent, depth, true
        } else if node.Val == y {
            yParent, yDepth, yFound = parent, depth, true
        }
    }

    type pair struct {
        node  *TreeNode
        depth int
    }
    q := []pair{{root, 0}}
    update(root, nil, 0)
    for len(q) > 0 && (!xFound || !yFound) {
        node, depth := q[0].node, q[0].depth
        q = q[1:]
        if node.Left != nil {
            q = append(q, pair{node.Left, depth + 1})
            update(node.Left, node, depth+1)
        }
        if node.Right != nil {
            q = append(q, pair{node.Right, depth + 1})
            update(node.Right, node, depth+1)
        }
    }

    return xDepth == yDepth && xParent != yParent
}
```

```C [sol2-C]
// x 的信息
int x_target;
struct TreeNode* x_parent;
int x_depth;
bool x_found;

// y 的信息
int y_target;
struct TreeNode* y_parent;
int y_depth;
bool y_found;

// 用来判断是否遍历到 x 或 y 的辅助函数
void update(struct TreeNode* node, struct TreeNode* parent, int depth) {
    if (node->val == x_target) {
        x_parent = parent;
        x_depth = depth;
        x_found = true;
    } else if (node->val == y_target) {
        y_parent = parent;
        y_depth = depth;
        y_found = true;
    }
}

struct Node {
    struct TreeNode* node;
    int depth;
};

bool isCousins(struct TreeNode* root, int x, int y) {
    x_target = x;
    y_target = y;
    x_found = false;
    y_found = false;

    struct Node q[100];
    int left = 0, right = 0;
    q[right++] = (struct Node){root, 0};
    update(root, NULL, 0);

    while (left < right) {
        if (q[left].node->left) {
            q[right++] = (struct Node){q[left].node->left, q[left].depth + 1};
            update(q[left].node->left, q[left].node, q[left].depth + 1);
        }
        if (q[left].node->right) {
            q[right++] = (struct Node){q[left].node->right, q[left].depth + 1};
            update(q[left].node->right, q[left].node, q[left].depth + 1);
        }
        if (x_found && y_found) {
            break;
        }
        left++;
    }

    return x_depth == y_depth && x_parent != y_parent;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是树中的节点个数。在最坏情况下，我们需要遍历整棵树，时间复杂度为 $O(n)$。

- 空间复杂度：$O(n)$，即为广度优先搜索的过程中需要使用的队列空间。

---
## ✨扣友帮帮团 - 互动答疑

[![讨论.jpg](https://pic.leetcode-cn.com/1621178600-MKHFrl-%E8%AE%A8%E8%AE%BA.jpg){:width=260px}](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)


即日起 - 5 月 30 日，点击 [这里](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/) 前往「[扣友帮帮团](https://leetcode-cn.com/topic/kou-you-bang-bang-tuan/discuss/latest/)」活动页，把你遇到的问题大胆地提出来，让扣友为你解答～

### 🎁 奖励规则
被采纳数量排名 1～3 名：「力扣极客套装」 *1 并将获得「力扣神秘应援团」内测资格
被采纳数量排名 4～10 名：「力扣鼠标垫」 *1 并将获得「力扣神秘应援团」内测资格
「诲人不倦」：活动期间「解惑者」只要有 1 个回答被采纳，即可获得 20 LeetCoins 奖励！
「求知若渴」：活动期间「求知者」在活动页发起一次符合要求的疑问帖并至少采纳一次「解惑者」的回答，即可获得 20 LeetCoins 奖励！

活动详情猛戳链接了解更多：[活动｜你有 BUG 我来帮 - 力扣互动答疑季](https://leetcode-cn.com/circle/discuss/xtliW6/)
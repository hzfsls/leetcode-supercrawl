## [129.求根节点到叶节点数字之和 中文官方题解](https://leetcode.cn/problems/sum-root-to-leaf-numbers/solutions/100000/qiu-gen-dao-xie-zi-jie-dian-shu-zi-zhi-he-by-leetc)

#### 前言

这道题中，二叉树的每条从根节点到叶子节点的路径都代表一个数字。其实，每个节点都对应一个数字，等于其父节点对应的数字乘以 $10$ 再加上该节点的值（这里假设根节点的父节点对应的数字是 $0$）。只要计算出每个叶子节点对应的数字，然后计算所有叶子节点对应的数字之和，即可得到结果。可以通过深度优先搜索和广度优先搜索实现。

#### 方法一：深度优先搜索

**思路与算法**

深度优先搜索是很直观的做法。从根节点开始，遍历每个节点，如果遇到叶子节点，则将叶子节点对应的数字加到数字之和。如果当前节点不是叶子节点，则计算其子节点对应的数字，然后对子节点递归遍历。

![fig1](https://assets.leetcode-cn.com/solution-static/129/fig1.png)

**代码**

```Java [sol1-Java]
class Solution {
    public int sumNumbers(TreeNode root) {
        return dfs(root, 0);
    }

    public int dfs(TreeNode root, int prevSum) {
        if (root == null) {
            return 0;
        }
        int sum = prevSum * 10 + root.val;
        if (root.left == null && root.right == null) {
            return sum;
        } else {
            return dfs(root.left, sum) + dfs(root.right, sum);
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    int dfs(TreeNode* root, int prevSum) {
        if (root == nullptr) {
            return 0;
        }
        int sum = prevSum * 10 + root->val;
        if (root->left == nullptr && root->right == nullptr) {
            return sum;
        } else {
            return dfs(root->left, sum) + dfs(root->right, sum);
        }
    }
    int sumNumbers(TreeNode* root) {
        return dfs(root, 0);
    }
};
```

```JavaScript [sol1-JavaScript]
const dfs = (root, prevSum) => {
    if (root === null) {
        return 0;
    }
    const sum = prevSum * 10 + root.val;
    if (root.left == null && root.right == null) {
        return sum;
    } else {
        return dfs(root.left, sum) + dfs(root.right, sum);
    }
}
var sumNumbers = function(root) {
    return dfs(root, 0);
};
```

```C [sol1-C]
int dfs(struct TreeNode* root, int prevSum) {
    if (root == NULL) {
        return 0;
    }
    int sum = prevSum * 10 + root->val;
    if (root->left == NULL && root->right == NULL) {
        return sum;
    } else {
        return dfs(root->left, sum) + dfs(root->right, sum);
    }
}

int sumNumbers(struct TreeNode* root) {
    return dfs(root, 0);
}
```

```Python [sol1-Python3]
class Solution:
    def sumNumbers(self, root: TreeNode) -> int:
        def dfs(root: TreeNode, prevTotal: int) -> int:
            if not root:
                return 0
            total = prevTotal * 10 + root.val
            if not root.left and not root.right:
                return total
            else:
                return dfs(root.left, total) + dfs(root.right, total)

        return dfs(root, 0)
```

```Golang [sol1-Golang]
func dfs(root *TreeNode, prevSum int) int {
    if root == nil {
        return 0
    }
    sum := prevSum*10 + root.Val
    if root.Left == nil && root.Right == nil {
        return sum
    }
    return dfs(root.Left, sum) + dfs(root.Right, sum)
}

func sumNumbers(root *TreeNode) int {
    return dfs(root, 0)
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点个数。对每个节点访问一次。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树的节点个数。空间复杂度主要取决于递归调用的栈空间，递归栈的深度等于二叉树的高度，最坏情况下，二叉树的高度等于节点个数，空间复杂度为 $O(n)$。

#### 方法二：广度优先搜索

**思路与算法**

使用广度优先搜索，需要维护两个队列，分别存储节点和节点对应的数字。

初始时，将根节点和根节点的值分别加入两个队列。每次从两个队列分别取出一个节点和一个数字，进行如下操作：

- 如果当前节点是叶子节点，则将该节点对应的数字加到数字之和；

- 如果当前节点不是叶子节点，则获得当前节点的非空子节点，并根据当前节点对应的数字和子节点的值计算子节点对应的数字，然后将子节点和子节点对应的数字分别加入两个队列。

搜索结束后，即可得到所有叶子节点对应的数字之和。

<![ppt1](https://assets.leetcode-cn.com/solution-static/129/1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/129/2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/129/3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/129/4.png),![ppt5](https://assets.leetcode-cn.com/solution-static/129/5.png),![ppt6](https://assets.leetcode-cn.com/solution-static/129/6.png),![ppt7](https://assets.leetcode-cn.com/solution-static/129/7.png),![ppt8](https://assets.leetcode-cn.com/solution-static/129/8.png),![ppt9](https://assets.leetcode-cn.com/solution-static/129/9.png),![ppt10](https://assets.leetcode-cn.com/solution-static/129/10.png),![ppt11](https://assets.leetcode-cn.com/solution-static/129/11.png),![ppt12](https://assets.leetcode-cn.com/solution-static/129/12.png)>

**代码**

```Java [sol2-Java]
class Solution {
    public int sumNumbers(TreeNode root) {
        if (root == null) {
            return 0;
        }
        int sum = 0;
        Queue<TreeNode> nodeQueue = new LinkedList<TreeNode>();
        Queue<Integer> numQueue = new LinkedList<Integer>();
        nodeQueue.offer(root);
        numQueue.offer(root.val);
        while (!nodeQueue.isEmpty()) {
            TreeNode node = nodeQueue.poll();
            int num = numQueue.poll();
            TreeNode left = node.left, right = node.right;
            if (left == null && right == null) {
                sum += num;
            } else {
                if (left != null) {
                    nodeQueue.offer(left);
                    numQueue.offer(num * 10 + left.val);
                }
                if (right != null) {
                    nodeQueue.offer(right);
                    numQueue.offer(num * 10 + right.val);
                }
            }
        }
        return sum;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    int sumNumbers(TreeNode* root) {
        if (root == nullptr) {
            return 0;
        }
        int sum = 0;
        queue<TreeNode*> nodeQueue;
        queue<int> numQueue;
        nodeQueue.push(root);
        numQueue.push(root->val);
        while (!nodeQueue.empty()) {
            TreeNode* node = nodeQueue.front();
            int num = numQueue.front();
            nodeQueue.pop();
            numQueue.pop();
            TreeNode* left = node->left;
            TreeNode* right = node->right;
            if (left == nullptr && right == nullptr) {
                sum += num;
            } else {
                if (left != nullptr) {
                    nodeQueue.push(left);
                    numQueue.push(num * 10 + left->val);
                }
                if (right != nullptr) {
                    nodeQueue.push(right);
                    numQueue.push(num * 10 + right->val);
                }
            }
        }
        return sum;
    }
};
```

```JavaScript [sol2-JavaScript]
var sumNumbers = function(root) {
    if (root === null) {
        return 0;
    }
    let sum = 0;
    const nodeQueue = [];
    const numQueue = [];
    nodeQueue.push(root);
    numQueue.push(root.val);
    while (nodeQueue.length) {
        const node = nodeQueue.shift();
        const num = numQueue.shift();
        const left = node.left, right = node.right;
        if (left === null && right === null) {
            sum += num;
        } else {
            if (left !== null) {
                nodeQueue.push(left);
                numQueue.push(num * 10 + left.val);
            }
            if (right !== null) {
                nodeQueue.push(right);
                numQueue.push(num * 10 + right.val);
            }
        }
    }
    return sum;
};
```

```C [sol2-C]
int sumNumbers(struct TreeNode* root) {
    if (root == NULL) {
        return 0;
    }
    int sum = 0;
    struct TreeNode* nodeQueue[2000];
    int numQueue[2000];
    int leftQueue = 0, rightQueue = 0;
    nodeQueue[rightQueue] = root;
    numQueue[rightQueue++] = root->val;
    while (leftQueue < rightQueue) {
        struct TreeNode* node = nodeQueue[leftQueue];
        int num = numQueue[leftQueue++];
        struct TreeNode* left = node->left;
        struct TreeNode* right = node->right;
        if (left == NULL && right == NULL) {
            sum += num;
        } else {
            if (left != NULL) {
                nodeQueue[rightQueue] = left;
                numQueue[rightQueue++] = num * 10 + left->val;
            }
            if (right != NULL) {
                nodeQueue[rightQueue] = right;
                numQueue[rightQueue++] = num * 10 + right->val;
            }
        }
    }
    return sum;
}
```

```Python [sol2-Python3]
class Solution:
    def sumNumbers(self, root: TreeNode) -> int:
        if not root:
            return 0

        total = 0
        nodeQueue = collections.deque([root])
        numQueue = collections.deque([root.val])
        
        while nodeQueue:
            node = nodeQueue.popleft()
            num = numQueue.popleft()
            left, right = node.left, node.right
            if not left and not right:
                total += num
            else:
                if left:
                    nodeQueue.append(left)
                    numQueue.append(num * 10 + left.val)
                if right:
                    nodeQueue.append(right)
                    numQueue.append(num * 10 + right.val)

        return total
```

```Golang [sol2-Golang]
type pair struct {
    node *TreeNode
    num  int
}

func sumNumbers(root *TreeNode) (sum int) {
    if root == nil {
        return
    }
    queue := []pair{{root, root.Val}}
    for len(queue) > 0 {
        p := queue[0]
        queue = queue[1:]
        left, right, num := p.node.Left, p.node.Right, p.num
        if left == nil && right == nil {
            sum += num
        } else {
            if left != nil {
                queue = append(queue, pair{left, num*10 + left.Val})
            }
            if right != nil {
                queue = append(queue, pair{right, num*10 + right.Val})
            }
        }
    }
    return
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 是二叉树的节点个数。对每个节点访问一次。

- 空间复杂度：$O(n)$，其中 $n$ 是二叉树的节点个数。空间复杂度主要取决于队列，每个队列中的元素个数不会超过 $n$。
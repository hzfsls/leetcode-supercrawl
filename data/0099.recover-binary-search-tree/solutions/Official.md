## [99.恢复二叉搜索树 中文官方题解](https://leetcode.cn/problems/recover-binary-search-tree/solutions/100000/hui-fu-er-cha-sou-suo-shu-by-leetcode-solution)
#### 方法一：显式中序遍历

**思路与算法**

我们需要考虑两个节点被错误地交换后对原二叉搜索树造成了什么影响。对于二叉搜索树，我们知道如果对其进行中序遍历，得到的值序列是递增有序的，而如果我们错误地交换了两个节点，等价于在这个值序列中交换了两个值，破坏了值序列的递增性。

我们来看下如果在一个递增的序列中交换两个值会造成什么影响。假设有一个递增序列 $a=[1,2,3,4,5,6,7]$。如果我们交换两个不相邻的数字，例如 $2$ 和 $6$，原序列变成了 $a=[1,6,3,4,5,2,7]$，那么显然序列中有两个位置不满足 $a_i<a_{i+1}$，在这个序列中体现为 $6>3$，$5>2$，因此只要我们找到这两个位置，即可找到被错误交换的两个节点。如果我们交换两个相邻的数字，例如 $2$ 和 $3$，此时交换后的序列只有一个位置不满足 $a_i<a_{i+1}$。因此整个值序列中不满足条件的位置或者有两个，或者有一个。

至此，解题方法已经呼之欲出了：

1. 找到二叉搜索树中序遍历得到值序列的不满足条件的位置。
2. 如果有两个，我们记为 $i$ 和 $j$（$i<j$ 且 $a_i>a_{i+1}\ \&\&\ a_j>a_{j+1}$)，那么对应被错误交换的节点即为 $a_i$ 对应的节点和 $a_{j+1}$ 对应的节点，我们分别记为 $x$ 和 $y$。
3. 如果有一个，我们记为 $i$，那么对应被错误交换的节点即为 $a_i$ 对应的节点和 $a_{i+1}$ 对应的节点，我们分别记为 $x$ 和 $y$。
4. 交换 $x$ 和 $y$ 两个节点即可。

实现部分，本方法开辟一个新数组 $\textit{nums}$ 来记录中序遍历得到的值序列，然后线性遍历找到两个位置 $i$ 和 $j$，并重新遍历原二叉搜索树修改对应节点的值完成修复，具体实现可以看下面的代码。

**代码**

```Java [sol1-Java]
class Solution {
    public void recoverTree(TreeNode root) {
        List<Integer> nums = new ArrayList<Integer>();
        inorder(root, nums);
        int[] swapped = findTwoSwapped(nums);
        recover(root, 2, swapped[0], swapped[1]);
    }

    public void inorder(TreeNode root, List<Integer> nums) {
        if (root == null) {
            return;
        }
        inorder(root.left, nums);
        nums.add(root.val);
        inorder(root.right, nums);
    }

    public int[] findTwoSwapped(List<Integer> nums) {
        int n = nums.size();
        int index1 = -1, index2 = -1;
        for (int i = 0; i < n - 1; ++i) {
            if (nums.get(i + 1) < nums.get(i)) {
                index2 = i + 1;
                if (index1 == -1) {
                    index1 = i;
                } else {
                    break;
                }
            }
        }
        int x = nums.get(index1), y = nums.get(index2);
        return new int[]{x, y};
    }

    public void recover(TreeNode root, int count, int x, int y) {
        if (root != null) {
            if (root.val == x || root.val == y) {
                root.val = root.val == x ? y : x;
                if (--count == 0) {
                    return;
                }
            }
            recover(root.right, count, x, y);
            recover(root.left, count, x, y);
        }
    }
}
```

```C++ [sol1-C++]
class Solution {
public:
    void inorder(TreeNode* root, vector<int>& nums) {
        if (root == nullptr) {
            return;
        }
        inorder(root->left, nums);
        nums.push_back(root->val);
        inorder(root->right, nums);
    }

    pair<int,int> findTwoSwapped(vector<int>& nums) {
        int n = nums.size();
        int index1 = -1, index2 = -1;
        for (int i = 0; i < n - 1; ++i) {
            if (nums[i + 1] < nums[i]) {
                index2 = i + 1;
                if (index1 == -1) {
                    index1 = i;
                } else {
                    break;
                }
            }
        }
        int x = nums[index1], y = nums[index2];
        return {x, y};
    }
    
    void recover(TreeNode* r, int count, int x, int y) {
        if (r != nullptr) {
            if (r->val == x || r->val == y) {
                r->val = r->val == x ? y : x;
                if (--count == 0) {
                    return;
                }
            }
            recover(r->left, count, x, y);
            recover(r->right, count, x, y);
        }
    }

    void recoverTree(TreeNode* root) {
        vector<int> nums;
        inorder(root, nums);
        pair<int,int> swapped= findTwoSwapped(nums);
        recover(root, 2, swapped.first, swapped.second);
    }
};
```

```JavaScript [sol1-JavaScript]
const inorder = (root, nums) => {
    if (root === null) {
        return;
    }
    inorder(root.left, nums);
    nums.push(root.val);
    inorder(root.right, nums);
}

const findTwoSwapped = (nums) => {
    const n = nums.length;
    let index1 = -1, index2 = -1;
    for (let i = 0; i < n - 1; ++i) {
        if (nums[i + 1] < nums[i]) {
            index2 = i + 1;
            if (index1 === -1) {
                index1 = i;
            } else {
                break;
            }
        }
    }
    let x = nums[index1], y = nums[index2];
    return [x, y];
}

const recover = (r, count, x, y) => {
    if (r !== null) {
        if (r.val === x || r.val === y) {
            r.val = r.val === x ? y : x;
            if (--count === 0) {
                return;
            }
        }
        recover(r.left, count, x, y);
        recover(r.right, count, x, y);
    }
}

var recoverTree = function(root) {
    const nums = [];
    inorder(root, nums);
    const [first, second] = findTwoSwapped(nums);
    recover(root, 2, first, second); 
};
```

```golang [sol1-Golang]
func recoverTree(root *TreeNode)  {
    nums := []int{}
    var inorder func(node *TreeNode)
    inorder = func(node *TreeNode) {
        if node == nil {
            return
        }
        inorder(node.Left)
        nums = append(nums, node.Val)
        inorder(node.Right)
    }
    inorder(root)
    x, y := findTwoSwapped(nums)
    recover(root, 2, x, y)
}

func findTwoSwapped(nums []int) (int, int) {
    index1, index2 := -1, -1
    for i := 0; i < len(nums) - 1; i++ {
        if nums[i + 1] < nums[i] {
            index2 = i + 1
            if index1 == -1 {
                index1 = i
            } else {
                break
            }
        }
    }
    x, y := nums[index1], nums[index2]
    return x, y
}

func recover(root *TreeNode, count, x, y int) {
    if root == nil {
        return
    }
    if root.Val == x || root.Val == y {
        if root.Val == x {
            root.Val = y
        } else {
            root.Val = x
        }
        count--
        if count == 0 {
            return
        }
    }
    recover(root.Right, count, x, y)
    recover(root.Left, count, x, y)
}
```

```C [sol1-C]
int len, max_size;

void inorder(struct TreeNode* root, int** nums) {
    if (root == NULL) {
        return;
    }
    inorder(root->left, nums);
    (*nums)[len++] = root->val;
    if (len == max_size) {
        max_size <<= 1;
        (*nums) = (int*)realloc((*nums), sizeof(int) * max_size);
    }
    inorder(root->right, nums);
}

int* findTwoSwapped(int* nums) {
    int index1 = -1, index2 = -1;
    for (int i = 0; i < len - 1; ++i) {
        if (nums[i + 1] < nums[i]) {
            index2 = i + 1;
            if (index1 == -1) {
                index1 = i;
            } else {
                break;
            }
        }
    }
    int x = nums[index1], y = nums[index2];
    int* ret = (int*)malloc(sizeof(int) * 2);
    ret[0] = x, ret[1] = y;
    return ret;
}

void recover(struct TreeNode* r, int count, int x, int y) {
    if (r != NULL) {
        if (r->val == x || r->val == y) {
            r->val = r->val == x ? y : x;
            if (--count == 0) {
                return;
            }
        }
        recover(r->left, count, x, y);
        recover(r->right, count, x, y);
    }
}

void recoverTree(struct TreeNode* root) {
    len = 0, max_size = 1;
    int* nums = (int*)malloc(sizeof(int));
    inorder(root, &nums);
    int* swapped = findTwoSwapped(nums);
    recover(root, 2, swapped[0], swapped[1]);
}
```

**复杂度分析**

* 时间复杂度：$O(N)$，其中 $N$ 为二叉搜索树的节点数。中序遍历需要 $O(N)$ 的时间，判断两个交换节点在最好的情况下是 $O(1)$，在最坏的情况下是 $O(N)$，因此总时间复杂度为 $O(N)$。
* 空间复杂度：$O(N)$。我们需要用 $\textit{nums}$ 数组存储树的中序遍历列表。

#### 方法二：隐式中序遍历

**思路与算法**

方法一是显式地将中序遍历的值序列保存在一个 $\textit{nums}$ 数组中，然后再去寻找被错误交换的节点，但我们也可以隐式地在中序遍历的过程就找到被错误交换的节点 $x$ 和 $y$。

具体来说，由于我们只关心中序遍历的值序列中每个**相邻的位置的大小关系是否满足条件**，且错误交换后**最多两个位置不满足条件**，因此在中序遍历的过程我们只需要维护当前中序遍历到的最后一个节点 $\textit{pred}$，然后在遍历到下一个节点的时候，看两个节点的值是否满足前者小于后者即可，如果不满足说明找到了一个交换的节点，且在找到两次以后就可以终止遍历。

这样我们就可以在中序遍历中直接找到被错误交换的两个节点 $x$ 和 $y$，不用显式建立 $\textit{nums}$ 数组。

中序遍历的实现有迭代和递归两种等价的写法，在本方法中提供迭代实现的写法。使用迭代实现中序遍历需要手动维护栈。

<![fig1](https://assets.leetcode-cn.com/solution-static/99/1.png),![fig2](https://assets.leetcode-cn.com/solution-static/99/2.png),![fig3](https://assets.leetcode-cn.com/solution-static/99/3.png),![fig4](https://assets.leetcode-cn.com/solution-static/99/4.png),![fig5](https://assets.leetcode-cn.com/solution-static/99/5.png),![fig6](https://assets.leetcode-cn.com/solution-static/99/6.png),![fig7](https://assets.leetcode-cn.com/solution-static/99/7.png),![fig8](https://assets.leetcode-cn.com/solution-static/99/8.png),![fig9](https://assets.leetcode-cn.com/solution-static/99/9.png)>

**代码**

```Java [sol2-Java]
class Solution {
    public void recoverTree(TreeNode root) {
        Deque<TreeNode> stack = new ArrayDeque<TreeNode>();
        TreeNode x = null, y = null, pred = null;

        while (!stack.isEmpty() || root != null) {
            while (root != null) {
                stack.push(root);
                root = root.left;
            }
            root = stack.pop();
            if (pred != null && root.val < pred.val) {
                y = root;
                if (x == null) {
                    x = pred;
                } else {
                    break;
                }
            }
            pred = root;
            root = root.right;
        }

        swap(x, y);
    }

    public void swap(TreeNode x, TreeNode y) {
        int tmp = x.val;
        x.val = y.val;
        y.val = tmp;
    }
}
```

```C++ [sol2-C++]
class Solution {
public:
    void recoverTree(TreeNode* root) {
        stack<TreeNode*> stk;
        TreeNode* x = nullptr;
        TreeNode* y = nullptr;
        TreeNode* pred = nullptr;

        while (!stk.empty() || root != nullptr) {
            while (root != nullptr) {
                stk.push(root);
                root = root->left;
            }
            root = stk.top();
            stk.pop();
            if (pred != nullptr && root->val < pred->val) {
                y = root;
                if (x == nullptr) {
                    x = pred;
                }
                else break;
            }
            pred = root;
            root = root->right;
        }

        swap(x->val, y->val);
    }
};
```

```JavaScript [sol2-JavaScript]
const swap = (x, y) => {
    const temp = x.val;
    x.val = y.val;
    y.val = temp;
}

var recoverTree = function(root) {
    const stack = [];
    let x = null, y = null, pred = null;

    while (stack.length || root !== null) {
      while (root !== null) {
        stack.push(root);
        root = root.left;
      }
      root = stack.pop();
      if (pred !== null && root.val < pred.val) {
        y = root;
        if (x === null) {
            x = pred;
        }
        else break;
      }
      pred = root;
      root = root.right;
    }
    swap(x, y);
};
```

```golang [sol2-Golang]
func recoverTree(root *TreeNode)  {
    stack := []*TreeNode{}
    var x, y, pred *TreeNode
    for len(stack) > 0 || root != nil {
        for root != nil {
            stack = append(stack, root)
            root = root.Left
        }
        root = stack[len(stack)-1]
        stack = stack[:len(stack)-1]
        if pred != nil && root.Val < pred.Val {
            y = root
            if x == nil {
                x = pred
            } else {
                break
            }
        }
        pred = root
        root = root.Right
    }
    x.Val, y.Val = y.Val, x.Val
}
```

```C [sol2-C]
void recoverTree(struct TreeNode* root) {
    struct TreeNode** stk = (struct TreeNode**)malloc(0);
    int stk_top = 0;
    struct TreeNode* x = NULL;
    struct TreeNode* y = NULL;
    struct TreeNode* pred = NULL;

    while (stk_top > 0 || root != NULL) {
        while (root != NULL) {
            stk_top++;
            stk = (struct TreeNode**)realloc(stk, sizeof(struct TreeNode*) * stk_top);
            stk[stk_top - 1] = root;
            root = root->left;
        }
        root = stk[--stk_top];
        if (pred != NULL && root->val < pred->val) {
            y = root;
            if (x == NULL) {
                x = pred;
            } else
                break;
        }
        pred = root;
        root = root->right;
    }
    int t = x->val;
    x->val = y->val, y->val = t;
}
```

**复杂度分析**

* 时间复杂度：最坏情况下（即待交换节点为二叉搜索树最右侧的叶子节点）我们需要遍历整棵树，时间复杂度为 $O(N)$，其中 $N$ 为二叉搜索树的节点个数。
* 空间复杂度：$O(H)$，其中 $H$ 为二叉搜索树的高度。中序遍历的时候栈的深度取决于二叉搜索树的高度。

#### 方法三：Morris 中序遍历

**思路与算法**

方法二中我们不再显示的用数组存储中序遍历的值序列，但是我们会发现我们仍需要 $O(H)$ 的栈空间，无法满足题目的进阶要求，那么该怎么办呢？这里向大家介绍一种不同于平常递归或迭代的遍历二叉树的方法：**Morris 遍历算法**，该算法能将非递归的中序遍历空间复杂度降为 $O(1)$。

**Morris 遍历算法**整体步骤如下（假设当前遍历到的节点为 $x$）：

1. 如果 $x$ 无左孩子，则访问 $x$ 的右孩子，即 $x = x.\textit{right}$。
2. 如果 $x$ 有左孩子，则找到 $x$ 左子树上最右的节点（**即左子树中序遍历的最后一个节点，$x$ 在中序遍历中的前驱节点**），我们记为 $\textit{predecessor}$。根据 $\textit{predecessor}$ 的右孩子是否为空，进行如下操作。
   - 如果 $\textit{predecessor}$ 的右孩子为空，则将其右孩子指向 $x$，然后访问 $x$ 的左孩子，即 $x = x.\textit{left}$。
   - 如果 $\textit{predecessor}$ 的右孩子不为空，则此时其右孩子指向 $x$，说明我们已经遍历完 $x$ 的左子树，我们将 $\textit{predecessor}$ 的右孩子置空，然后访问 $x$ 的右孩子，即 $x = x.\textit{right}$。
3. 重复上述操作，直至访问完整棵树。

其实整个过程我们就多做一步：将当前节点左子树中最右边的节点指向它，这样在左子树遍历完成后我们通过这个指向走回了 $x$，且能再通过这个知晓我们已经遍历完成了左子树，而不用再通过栈来维护，省去了栈的空间复杂度。

了解完这个算法以后，其他地方与方法二并无不同，我们同样也是维护一个 $\textit{pred}$ 变量去比较即可，具体实现可以看下面的代码，这里不再赘述。

<![morris1](https://assets.leetcode-cn.com/solution-static/99/2_1.png),![morris2](https://assets.leetcode-cn.com/solution-static/99/2_2.png),![morris3](https://assets.leetcode-cn.com/solution-static/99/2_3.png),![morris4](https://assets.leetcode-cn.com/solution-static/99/2_4.png),![morris5](https://assets.leetcode-cn.com/solution-static/99/2_5.png),![morris6](https://assets.leetcode-cn.com/solution-static/99/2_6.png),![morris7](https://assets.leetcode-cn.com/solution-static/99/2_7.png),![morris8](https://assets.leetcode-cn.com/solution-static/99/2_8.png),![morris9](https://assets.leetcode-cn.com/solution-static/99/2_9.png),![morris10](https://assets.leetcode-cn.com/solution-static/99/2_10.png),![morris11](https://assets.leetcode-cn.com/solution-static/99/2_11.png)>

**代码**

```Java [sol3-Java]
class Solution {
    public void recoverTree(TreeNode root) {
        TreeNode x = null, y = null, pred = null, predecessor = null;

        while (root != null) {
            if (root.left != null) {
                // predecessor 节点就是当前 root 节点向左走一步，然后一直向右走至无法走为止
                predecessor = root.left;
                while (predecessor.right != null && predecessor.right != root) {
                    predecessor = predecessor.right;
                }
                
                // 让 predecessor 的右指针指向 root，继续遍历左子树
                if (predecessor.right == null) {
                    predecessor.right = root;
                    root = root.left;
                }
                // 说明左子树已经访问完了，我们需要断开链接
                else {
                    if (pred != null && root.val < pred.val) {
                        y = root;
                        if (x == null) {
                            x = pred;
                        }
                    }
                    pred = root;

                    predecessor.right = null;
                    root = root.right;
                }
            }
            // 如果没有左孩子，则直接访问右孩子
            else {
                if (pred != null && root.val < pred.val) {
                    y = root;
                    if (x == null) {
                        x = pred;
                    }
                }
                pred = root;
                root = root.right;
            }
        }
        swap(x, y);
    }

    public void swap(TreeNode x, TreeNode y) {
        int tmp = x.val;
        x.val = y.val;
        y.val = tmp;
    }
}
```

```C++ [sol3-C++]
class Solution {
public:
    void recoverTree(TreeNode* root) {
        TreeNode *x = nullptr, *y = nullptr, *pred = nullptr, *predecessor = nullptr;

        while (root != nullptr) {
            if (root->left != nullptr) {
                // predecessor 节点就是当前 root 节点向左走一步，然后一直向右走至无法走为止
                predecessor = root->left;
                while (predecessor->right != nullptr && predecessor->right != root) {
                    predecessor = predecessor->right;
                }
                
                // 让 predecessor 的右指针指向 root，继续遍历左子树
                if (predecessor->right == nullptr) {
                    predecessor->right = root;
                    root = root->left;
                }
                // 说明左子树已经访问完了，我们需要断开链接
                else {
                    if (pred != nullptr && root->val < pred->val) {
                        y = root;
                        if (x == nullptr) {
                            x = pred;
                        }
                    }
                    pred = root;

                    predecessor->right = nullptr;
                    root = root->right;
                }
            }
            // 如果没有左孩子，则直接访问右孩子
            else {
                if (pred != nullptr && root->val < pred->val) {
                    y = root;
                    if (x == nullptr) {
                        x = pred;
                    }
                }
                pred = root;
                root = root->right;
            }
        }
        swap(x->val, y->val);
    }
};
```

```JavaScript [sol3-JavaScript]
const swap = (x, y) => {
    const temp = x.val;
    x.val = y.val;
    y.val = temp;
}

var recoverTree = function(root) {
    let x = null, y = null, pred = null, predecessor = null;

    while (root !== null) {
      if (root.left !== null) {
        // predecessor 节点就是当前 root 节点向左走一步，然后一直向右走至无法走为止
        predecessor = root.left;
        while (predecessor.right !== null && predecessor.right !== root)
          predecessor = predecessor.right;

        // 让 predecessor 的右指针指向 root，继续遍历左子树
        if (predecessor.right === null) {
          predecessor.right = root;
          root = root.left;
        }
        // 说明左子树已经访问完了，我们需要断开链接
        else {
          if (pred !== null && root.val < pred.val) {
            y = root;
            if (x === null) {
                x = pred;
            }
          }
          pred = root;

          predecessor.right = null;
          root = root.right;
        }
      }
      // 如果没有左孩子，则直接访问右孩子
      else {
        if (pred !== null && root.val < pred.val) {
            y = root;
            if (x === null) {
                x = pred;
            }
        }
        pred = root;

        root = root.right;
      }
    }
    swap(x, y);
};
```

```golang [sol3-Golang]
func recoverTree(root *TreeNode)  {
    var x, y, pred, predecessor *TreeNode

    for root != nil {
        if root.Left != nil {
            // predecessor 节点就是当前 root 节点向左走一步，然后一直向右走至无法走为止
            predecessor = root.Left
            for predecessor.Right != nil && predecessor.Right != root {
                predecessor = predecessor.Right
            }

            // 让 predecessor 的右指针指向 root，继续遍历左子树
            if predecessor.Right == nil {
                predecessor.Right = root
                root = root.Left
            } else { // 说明左子树已经访问完了，我们需要断开链接
                if pred != nil && root.Val < pred.Val {
                    y = root
                    if x == nil {
                        x = pred
                    }
                }
                pred = root
                predecessor.Right = nil
                root = root.Right
            }
        } else { // 如果没有左孩子，则直接访问右孩子
            if pred != nil && root.Val < pred.Val {
                y = root
                if x == nil {
                    x = pred
                }
            }
            pred = root
            root = root.Right
        }
    }
    x.Val, y.Val = y.Val, x.Val
}
```

```C [sol3-C]
void recoverTree(struct TreeNode* root) {
    struct TreeNode *x = NULL, *y = NULL, *pred = NULL, *predecessor = NULL;

    while (root != NULL) {
        if (root->left != NULL) {
            // predecessor 节点就是当前 root 节点向左走一步，然后一直向右走至无法走为止
            predecessor = root->left;
            while (predecessor->right != NULL && predecessor->right != root) {
                predecessor = predecessor->right;
            }

            // 让 predecessor 的右指针指向 root，继续遍历左子树
            if (predecessor->right == NULL) {
                predecessor->right = root;
                root = root->left;
            }
            // 说明左子树已经访问完了，我们需要断开链接
            else {
                if (pred != NULL && root->val < pred->val) {
                    y = root;
                    if (x == NULL) {
                        x = pred;
                    }
                }
                pred = root;

                predecessor->right = NULL;
                root = root->right;
            }
        }
        // 如果没有左孩子，则直接访问右孩子
        else {
            if (pred != NULL && root->val < pred->val) {
                y = root;
                if (x == NULL) {
                    x = pred;
                }
            }
            pred = root;
            root = root->right;
        }
    }
    int t = x->val;
    x->val = y->val, y->val = t;
}
```

**复杂度分析**

* 时间复杂度：$O(N)$，其中 $N$ 为二叉搜索树的高度。Morris 遍历中每个节点会被访问两次，因此总时间复杂度为 $O(2N)=O(N)$。
* 空间复杂度：$O(1)$。
## [94.二叉树的中序遍历 中文官方题解](https://leetcode.cn/problems/binary-tree-inorder-traversal/solutions/100000/er-cha-shu-de-zhong-xu-bian-li-by-leetcode-solutio)
#### 方法一：递归

**思路与算法**

首先我们需要了解什么是二叉树的中序遍历：按照访问左子树——根节点——右子树的方式遍历这棵树，而在访问左子树或者右子树的时候我们按照同样的方式遍历，直到遍历完整棵树。因此整个遍历过程天然具有递归的性质，我们可以直接用递归函数来模拟这一过程。

定义 `inorder(root)` 表示当前遍历到 $\textit{root}$ 节点的答案，那么按照定义，我们只要递归调用 `inorder(root.left)` 来遍历 $\textit{root}$ 节点的左子树，然后将 $\textit{root}$ 节点的值加入答案，再递归调用`inorder(root.right)` 来遍历 $\textit{root}$ 节点的右子树即可，递归终止的条件为碰到空节点。

**代码**

```C++ [sol1-C++]
class Solution {
public:
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
};
```

```Java [sol1-Java]
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        inorder(root, res);
        return res;
    }

    public void inorder(TreeNode root, List<Integer> res) {
        if (root == null) {
            return;
        }
        inorder(root.left, res);
        res.add(root.val);
        inorder(root.right, res);
    }
}
```

```JavaScript [sol1-JavaScript]
var inorderTraversal = function(root) {
    const res = [];
    const inorder = (root) => {
        if (!root) {
            return;
        }
        inorder(root.left);
        res.push(root.val);
        inorder(root.right);
    }
    inorder(root);
    return res;
};
```

```Golang [sol1-Golang]
func inorderTraversal(root *TreeNode) (res []int) {
	var inorder func(node *TreeNode)
	inorder = func(node *TreeNode) {
		if node == nil {
			return
		}
		inorder(node.Left)
		res = append(res, node.Val)
		inorder(node.Right)
	}
	inorder(root)
	return
}
```

```C [sol1-C]
void inorder(struct TreeNode* root, int* res, int* resSize) {
    if (!root) {
        return;
    }
    inorder(root->left, res, resSize);
    res[(*resSize)++] = root->val;
    inorder(root->right, res, resSize);
}

int* inorderTraversal(struct TreeNode* root, int* returnSize) {
    int* res = malloc(sizeof(int) * 501);
    *returnSize = 0;
    inorder(root, res, returnSize);
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉树节点的个数。二叉树的遍历中每个节点会被访问一次且只会被访问一次。

- 空间复杂度：$O(n)$。空间复杂度取决于递归的栈深度，而栈深度在二叉树为一条链的情况下会达到 $O(n)$ 的级别。

#### 方法二：迭代

**思路与算法**

方法一的递归函数我们也可以用迭代的方式实现，两种方式是等价的，区别在于递归的时候隐式地维护了一个栈，而我们在迭代的时候需要显式地将这个栈模拟出来，其他都相同，具体实现可以看下面的代码。

<![fig1](https://assets.leetcode-cn.com/solution-static/94/1.png),![fig2](https://assets.leetcode-cn.com/solution-static/94/2.png),![fig3](https://assets.leetcode-cn.com/solution-static/94/3.png),![fig4](https://assets.leetcode-cn.com/solution-static/94/4.png),![fig5](https://assets.leetcode-cn.com/solution-static/94/5.png),![fig6](https://assets.leetcode-cn.com/solution-static/94/6.png),![fig7](https://assets.leetcode-cn.com/solution-static/94/7.png),![fig8](https://assets.leetcode-cn.com/solution-static/94/8.png),![fig9](https://assets.leetcode-cn.com/solution-static/94/9.png),![fig10](https://assets.leetcode-cn.com/solution-static/94/10.png),![fig11](https://assets.leetcode-cn.com/solution-static/94/11.png),![fig12](https://assets.leetcode-cn.com/solution-static/94/12.png),![fig13](https://assets.leetcode-cn.com/solution-static/94/13.png),![fig14](https://assets.leetcode-cn.com/solution-static/94/14.png)>

**代码**

```C++ [sol2-C++]
class Solution {
public:
    vector<int> inorderTraversal(TreeNode* root) {
        vector<int> res;
        stack<TreeNode*> stk;
        while (root != nullptr || !stk.empty()) {
            while (root != nullptr) {
                stk.push(root);
                root = root->left;
            }
            root = stk.top();
            stk.pop();
            res.push_back(root->val);
            root = root->right;
        }
        return res;
    }
};
```

```Java [sol2-Java]
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        Deque<TreeNode> stk = new LinkedList<TreeNode>();
        while (root != null || !stk.isEmpty()) {
            while (root != null) {
                stk.push(root);
                root = root.left;
            }
            root = stk.pop();
            res.add(root.val);
            root = root.right;
        }
        return res;
    }
}
```

```JavaScript [sol2-JavaScript]
var inorderTraversal = function(root) {
    const res = [];
    const stk = [];
    while (root || stk.length) {
        while (root) {
            stk.push(root);
            root = root.left;
        }
        root = stk.pop();
        res.push(root.val);
        root = root.right;
    }
    return res;
};
```

```Golang [sol2-Golang]
func inorderTraversal(root *TreeNode) (res []int) {
	stack := []*TreeNode{}
	for root != nil || len(stack) > 0 {
		for root != nil {
			stack = append(stack, root)
			root = root.Left
		}
		root = stack[len(stack)-1]
		stack = stack[:len(stack)-1]
		res = append(res, root.Val)
		root = root.Right
	}
	return
}
```

```C [sol2-C]
int* inorderTraversal(struct TreeNode* root, int* returnSize) {
    *returnSize = 0;
    int* res = malloc(sizeof(int) * 501);
    struct TreeNode** stk = malloc(sizeof(struct TreeNode*) * 501);
    int top = 0;
    while (root != NULL || top > 0) {
        while (root != NULL) {
            stk[top++] = root;
            root = root->left;
        }
        root = stk[--top];
        res[(*returnSize)++] = root->val;
        root = root->right;
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉树节点的个数。二叉树的遍历中每个节点会被访问一次且只会被访问一次。

- 空间复杂度：$O(n)$。空间复杂度取决于栈深度，而栈深度在二叉树为一条链的情况下会达到 $O(n)$ 的级别。

#### 方法三：Morris 中序遍历

**思路与算法**

**Morris 遍历算法**是另一种遍历二叉树的方法，它能将非递归的中序遍历空间复杂度降为 $O(1)$。

**Morris 遍历算法**整体步骤如下（假设当前遍历到的节点为 $x$）：

1. 如果 $x$ 无左孩子，先将 $x$ 的值加入答案数组，再访问 $x$ 的右孩子，即 $x = x.\textit{right}$。
2. 如果 $x$ 有左孩子，则找到 $x$ 左子树上最右的节点（**即左子树中序遍历的最后一个节点，$x$ 在中序遍历中的前驱节点**），我们记为 $\textit{predecessor}$。根据 $\textit{predecessor}$ 的右孩子是否为空，进行如下操作。
   - 如果 $\textit{predecessor}$ 的右孩子为空，则将其右孩子指向 $x$，然后访问 $x$ 的左孩子，即 $x = x.\textit{left}$。
   - 如果 $\textit{predecessor}$ 的右孩子不为空，则此时其右孩子指向 $x$，说明我们已经遍历完 $x$ 的左子树，我们将 $\textit{predecessor}$ 的右孩子置空，将 $x$ 的值加入答案数组，然后访问 $x$ 的右孩子，即 $x = x.\textit{right}$。
3. 重复上述操作，直至访问完整棵树。

<![ppt1](https://assets.leetcode-cn.com/solution-static/94/2_1.png),![ppt2](https://assets.leetcode-cn.com/solution-static/94/2_2.png),![ppt3](https://assets.leetcode-cn.com/solution-static/94/2_3.png),![ppt4](https://assets.leetcode-cn.com/solution-static/94/2_4.png),![ppt5](https://assets.leetcode-cn.com/solution-static/94/2_5.png),![ppt6](https://assets.leetcode-cn.com/solution-static/94/2_6.png),![ppt7](https://assets.leetcode-cn.com/solution-static/94/2_7.png),![ppt8](https://assets.leetcode-cn.com/solution-static/94/2_8.png),![ppt9](https://assets.leetcode-cn.com/solution-static/94/2_9.png),![ppt10](https://assets.leetcode-cn.com/solution-static/94/2_10.png),![ppt11](https://assets.leetcode-cn.com/solution-static/94/2_11.png),![ppt12](https://assets.leetcode-cn.com/solution-static/94/2_12.png),![ppt13](https://assets.leetcode-cn.com/solution-static/94/2_13.png),![ppt14](https://assets.leetcode-cn.com/solution-static/94/2_14.png),![ppt15](https://assets.leetcode-cn.com/solution-static/94/2_15.png),![ppt16](https://assets.leetcode-cn.com/solution-static/94/2_16.png),![ppt17](https://assets.leetcode-cn.com/solution-static/94/2_17.png),![ppt18](https://assets.leetcode-cn.com/solution-static/94/2_18.png),![ppt19](https://assets.leetcode-cn.com/solution-static/94/2_19.png)>

其实整个过程我们就多做一步：假设当前遍历到的节点为 $x$，将 $x$ 的左子树中最右边的节点的右孩子指向 $x$，这样在左子树遍历完成后我们通过这个指向走回了 $x$，且能通过这个指向知晓我们已经遍历完成了左子树，而不用再通过栈来维护，省去了栈的空间复杂度。

**代码**

```C++ [sol3-C++]
class Solution {
public:
    vector<int> inorderTraversal(TreeNode* root) {
        vector<int> res;
        TreeNode *predecessor = nullptr;

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
                    res.push_back(root->val);
                    predecessor->right = nullptr;
                    root = root->right;
                }
            }
            // 如果没有左孩子，则直接访问右孩子
            else {
                res.push_back(root->val);
                root = root->right;
            }
        }
        return res;
    }
};
```

```Java [sol3-Java]
class Solution {
    public List<Integer> inorderTraversal(TreeNode root) {
        List<Integer> res = new ArrayList<Integer>();
        TreeNode predecessor = null;

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
                    res.add(root.val);
                    predecessor.right = null;
                    root = root.right;
                }
            }
            // 如果没有左孩子，则直接访问右孩子
            else {
                res.add(root.val);
                root = root.right;
            }
        }
        return res;
    }
}
```

```JavaScript [sol3-JavaScript]
var inorderTraversal = function(root) {
    const res = [];
    let predecessor = null;

    while (root) {
        if (root.left) {
            // predecessor 节点就是当前 root 节点向左走一步，然后一直向右走至无法走为止
            predecessor = root.left;
            while (predecessor.right && predecessor.right !== root) {
                predecessor = predecessor.right;
            }

            // 让 predecessor 的右指针指向 root，继续遍历左子树
            if (!predecessor.right) {
                predecessor.right = root;
                root = root.left;
            }
            // 说明左子树已经访问完了，我们需要断开链接
            else {
                res.push(root.val);
                predecessor.right = null;
                root = root.right;
            }
        }
        // 如果没有左孩子，则直接访问右孩子
        else {
            res.push(root.val);
            root = root.right;
        }
    }

    return res;
};
```

```Golang [sol3-Golang]
func inorderTraversal(root *TreeNode) (res []int) {
	for root != nil {
		if root.Left != nil {
			// predecessor 节点表示当前 root 节点向左走一步，然后一直向右走至无法走为止的节点
			predecessor := root.Left
			for predecessor.Right != nil && predecessor.Right != root {
				// 有右子树且没有设置过指向 root，则继续向右走
				predecessor = predecessor.Right
			}
			if predecessor.Right == nil {
				// 将 predecessor 的右指针指向 root，这样后面遍历完左子树 root.Left 后，就能通过这个指向回到 root
				predecessor.Right = root
				// 遍历左子树
				root = root.Left
			} else { // predecessor 的右指针已经指向了 root，则表示左子树 root.Left 已经访问完了
				res = append(res, root.Val)
				// 恢复原样
				predecessor.Right = nil
				// 遍历右子树
				root = root.Right
			}
		} else { // 没有左子树
			res = append(res, root.Val)
			// 若有右子树，则遍历右子树
			// 若没有右子树，则整颗左子树已遍历完，root 会通过之前设置的指向回到这颗子树的父节点
			root = root.Right
		}
	}
	return
}
```

```C [sol3-C]
int* inorderTraversal(struct TreeNode* root, int* returnSize) {
    int* res = malloc(sizeof(int) * 501);
    *returnSize = 0;
    struct TreeNode* predecessor = NULL;

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
                res[(*returnSize)++] = root->val;
                predecessor->right = NULL;
                root = root->right;
            }
        }
        // 如果没有左孩子，则直接访问右孩子
        else {
            res[(*returnSize)++] = root->val;
            root = root->right;
        }
    }
    return res;
}
```

**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为二叉树的节点个数。Morris 遍历中每个节点会被访问两次，因此总时间复杂度为 $O(2n)=O(n)$。

- 空间复杂度：$O(1)$。
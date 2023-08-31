## [501.二叉搜索树中的众数 中文官方题解](https://leetcode.cn/problems/find-mode-in-binary-search-tree/solutions/100000/er-cha-sou-suo-shu-zhong-de-zhong-shu-by-leetcode-)
#### 方法一：中序遍历

**思路与算法**

首先我们一定能想到一个最朴素的做法：因为这棵树的中序遍历是一个有序的序列，所以我们可以先获得这棵树的中序遍历，然后从扫描这个中序遍历序列，然后用一个哈希表来统计每个数字出现的个数，这样就可以找到出现次数最多的数字。但是这样做的空间复杂度显然不是 $O(1)$ 的，原因是哈希表和保存中序遍历序列的空间代价都是 $O(n)$。

**首先，我们考虑在寻找出现次数最多的数时，不使用哈希表。** 这个优化是基于二叉搜索树中序遍历的性质：一棵二叉搜索树的中序遍历序列是一个非递减的有序序列。例如：

```
      1
    /   \
   0     2
  / \    /
-1   0  2
```

这样一颗二叉搜索树的中序遍历序列是 $\{ -1, 0, 0, 1, 2, 2 \}$。我们可以发现重复出现的数字一定是一个连续出现的，例如这里的 $0$ 和 $2$，它们都重复出现了，并且所有的 $0$ 都集中在一个连续的段内，所有的 $2$ 也集中在一个连续的段内。我们可以顺序扫描中序遍历序列，用 $\textit{base}$ 记录当前的数字，用 $\textit{count}$ 记录当前数字重复的次数，用 $\textit{maxCount}$ 来维护已经扫描过的数当中出现最多的那个数字的出现次数，用 $\textit{answer}$ 数组记录出现的众数。每次扫描到一个新的元素：

+ 首先更新 $\textit{base}$ 和 $\textit{count}$:
    + 如果该元素和 $\textit{base}$ 相等，那么 $\textit{count}$ 自增 $1$；
    + 否则将 $\textit{base}$ 更新为当前数字，$\textit{count}$ 复位为 $1$。
+ 然后更新 $\textit{maxCount}$：
    + 如果 $\textit{count} = maxCount$，那么说明当前的这个数字（$\textit{base}$）出现的次数等于当前众数出现的次数，将 $\textit{base}$ 加入 $\textit{answer}$ 数组；
    + 如果 $\textit{count} > maxCount$，那么说明当前的这个数字（$\textit{base}$）出现的次数大于当前众数出现的次数，因此，我们需要将 $\textit{maxCount}$ 更新为 $\textit{count}$，清空 $\textit{answer}$ 数组后将 $\textit{base}$ 加入 $\textit{answer}$ 数组。

我们可以把这个过程写成一个 $\text{update}$ 函数。这样我们在寻找出现次数最多的数字的时候就可以省去一个哈希表带来的空间消耗。

**然后，我们考虑不存储这个中序遍历序列。** 如果我们在递归进行中序遍历的过程中，访问当了某个点的时候直接使用上面的 $\text{update}$ 函数，就可以省去中序遍历序列的空间，代码如下。

**代码**

```cpp [sol1-C++]
class Solution {
public:
    vector<int> answer;
    int base, count, maxCount;

    void update(int x) {
        if (x == base) {
            ++count;
        } else {
            count = 1;
            base = x;
        }
        if (count == maxCount) {
            answer.push_back(base);
        }
        if (count > maxCount) {
            maxCount = count;
            answer = vector<int> {base};
        }
    }

    void dfs(TreeNode* o) {
        if (!o) {
            return;
        }
        dfs(o->left);
        update(o->val);
        dfs(o->right);
    }

    vector<int> findMode(TreeNode* root) {
        dfs(root);
        return answer;
    }
};
```

```Java [sol1-Java]
class Solution {
    List<Integer> answer = new ArrayList<Integer>();
    int base, count, maxCount;

    public int[] findMode(TreeNode root) {
        dfs(root);
        int[] mode = new int[answer.size()];
        for (int i = 0; i < answer.size(); ++i) {
            mode[i] = answer.get(i);
        }
        return mode;
    }

    public void dfs(TreeNode o) {
        if (o == null) {
            return;
        }
        dfs(o.left);
        update(o.val);
        dfs(o.right);
    }

    public void update(int x) {
        if (x == base) {
            ++count;
        } else {
            count = 1;
            base = x;
        }
        if (count == maxCount) {
            answer.add(base);
        }
        if (count > maxCount) {
            maxCount = count;
            answer.clear();
            answer.add(base);
        }
    }
}
```

```JavaScript [sol1-JavaScript]
var findMode = function(root) {
    let base = 0, count = 0, maxCount = 0;
    let answer = [];

    const update = (x) => {
        if (x === base) {
            ++count;
        } else {
            count = 1;
            base = x;
        }
        if (count === maxCount) {
            answer.push(base);
        }
        if (count > maxCount) {
            maxCount = count;
            answer = [base];
        }
    }

    const dfs = (o) => {
        if (!o) {
            return;
        }
        dfs(o.left);
        update(o.val);
        dfs(o.right);
    }

    dfs(root);
    return answer;
};
```

```Golang [sol1-Golang]
func findMode(root *TreeNode) (answer []int) {
    var base, count, maxCount int

    update := func(x int) {
        if x == base {
            count++
        } else {
            base, count = x, 1
        }
        if count == maxCount {
            answer = append(answer, base)
        } else if count > maxCount {
            maxCount = count
            answer = []int{base}
        }
    }

    var dfs func(*TreeNode)
    dfs = func(node *TreeNode) {
        if node == nil {
            return
        }
        dfs(node.Left)
        update(node.Val)
        dfs(node.Right)
    }
    dfs(root)
    return
}
```

```C [sol1-C]
int* answer;
int answerSize;
int base, count, maxCount;

void update(int x) {
    if (x == base) {
        ++count;
    } else {
        count = 1;
        base = x;
    }
    if (count == maxCount) {
        answer[answerSize++] = base;
    }
    if (count > maxCount) {
        maxCount = count;
        answerSize = 0;
        answer[answerSize++] = base;
    }
}

void dfs(struct TreeNode* o) {
    if (!o) {
        return;
    }
    dfs(o->left);
    update(o->val);
    dfs(o->right);
}

int* findMode(struct TreeNode* root, int* returnSize) {
    base = count = maxCount = 0;
    answer = malloc(sizeof(int) * 4001);
    answerSize = 0;
    dfs(root);
    *returnSize = answerSize;
    return answer;
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$。即遍历这棵树的复杂度。
+ 空间复杂度：$O(n)$。即递归的栈空间的空间代价。

#### 方法二：Morris 中序遍历

**思路与算法**

**接着上面的思路，我们用 Morris 中序遍历的方法把中序遍历的空间复杂度优化到 $O(1)$。** 我们在中序遍历的时候，一定先遍历左子树，然后遍历当前节点，最后遍历右子树。在常规方法中，我们用递归回溯或者是栈来保证遍历完左子树可以再回到当前节点，但这需要我们付出额外的空间代价。我们需要用一种巧妙地方法可以在 $O(1)$ 的空间下，遍历完左子树可以再回到当前节点。我们希望当前的节点在遍历完当前点的前驱之后被遍历，我们可以考虑修改它的前驱节点的 $\textit{right}$ 指针。当前节点的前驱节点的 $\textit{right}$ 指针可能本来就指向当前节点（前驱是当前节点的父节点），也可能是当前节点左子树最右下的节点。如果是后者，我们希望遍历完这个前驱节点之后再回到当前节点，可以将它的 $\textit{right}$ 指针指向当前节点。

Morris 中序遍历的一个重要步骤就是寻找当前节点的前驱节点，并且 Morris 中序遍历寻找下一个点始终是通过转移到 $\textit{right}$ 指针指向的位置来完成的。

+ 如果当前节点没有左子树，则遍历这个点，然后跳转到当前节点的右子树。
+ 如果当前节点有左子树，那么它的前驱节点一定在左子树上，我们可以在左子树上一直向右行走，找到当前点的前驱节点。
    + 如果前驱节点没有右子树，就将前驱节点的 $\textit{right}$ 指针指向当前节点。这一步是为了在遍历完前驱节点后能找到前驱节点的后继，也就是当前节点。
    + 如果前驱节点的右子树为当前节点，说明前驱节点已经被遍历过并被修改了 $\textit{right}$ 指针，这个时候我们重新将前驱的右孩子设置为空，遍历当前的点，然后跳转到当前节点的右子树。

因此我们可以得到这样的代码框架：

```cpp [demo-C++]
TreeNode *cur = root, *pre = nullptr;
while (cur) {
    if (!cur->left) {
        // ...遍历 cur
        cur = cur->right;
        continue;
    }
    pre = cur->left;
    while (pre->right && pre->right != cur) {
        pre = pre->right;
    }
    if (!pre->right) {
        pre->right = cur;
        cur = cur->left;
    } else {
        pre->right = nullptr;
        // ...遍历 cur
        cur = cur->right;
    }
}
```

最后我们将 `...遍历 cur` 替换成之前的 $\text{update}$ 函数即可。


**代码**

```cpp [sol2-C++]
class Solution {
public:
    int base, count, maxCount;
    vector<int> answer;

    void update(int x) {
        if (x == base) {
            ++count;
        } else {
            count = 1;
            base = x;
        }
        if (count == maxCount) {
            answer.push_back(base);
        }
        if (count > maxCount) {
            maxCount = count;
            answer = vector<int> {base};
        }
    }

    vector<int> findMode(TreeNode* root) {
        TreeNode *cur = root, *pre = nullptr;
        while (cur) {
            if (!cur->left) {
                update(cur->val);
                cur = cur->right;
                continue;
            }
            pre = cur->left;
            while (pre->right && pre->right != cur) {
                pre = pre->right;
            }
            if (!pre->right) {
                pre->right = cur;
                cur = cur->left;
            } else {
                pre->right = nullptr;
                update(cur->val);
                cur = cur->right;
            }
        }
        return answer;
    }
};
```

```Java [sol2-Java]
class Solution {
    int base, count, maxCount;
    List<Integer> answer = new ArrayList<Integer>();

    public int[] findMode(TreeNode root) {
        TreeNode cur = root, pre = null;
        while (cur != null) {
            if (cur.left == null) {
                update(cur.val);
                cur = cur.right;
                continue;
            }
            pre = cur.left;
            while (pre.right != null && pre.right != cur) {
                pre = pre.right;
            }
            if (pre.right == null) {
                pre.right = cur;
                cur = cur.left;
            } else {
                pre.right = null;
                update(cur.val);
                cur = cur.right;
            }
        }
        int[] mode = new int[answer.size()];
        for (int i = 0; i < answer.size(); ++i) {
            mode[i] = answer.get(i);
        }
        return mode;
    }

    public void update(int x) {
        if (x == base) {
            ++count;
        } else {
            count = 1;
            base = x;
        }
        if (count == maxCount) {
            answer.add(base);
        }
        if (count > maxCount) {
            maxCount = count;
            answer.clear();
            answer.add(base);
        }
    }
}
```

```JavaScript [sol2-JavaScript]
var findMode = function(root) {
    let base = 0, count = 0, maxCount = 0;
    let answer = [];

    const update = (x) => {
        if (x === base) {
            ++count;
        } else {
            count = 1;
            base = x;
        }
        if (count === maxCount) {
            answer.push(base);
        }
        if (count > maxCount) {
            maxCount = count;
            answer = [base];
        }
    }

    let cur = root, pre = null;
    while (cur !== null) {
        if (cur.left === null) {
            update(cur.val);
            cur = cur.right;
            continue;
        }
        pre = cur.left;
        while (pre.right !== null && pre.right !== cur) {
            pre = pre.right;
        }
        if (pre.right === null) {
            pre.right = cur;
            cur = cur.left;
        } else {
            pre.right = null;
            update(cur.val);
            cur = cur.right;
        }
    }
    return answer;
};
```

```Golang [sol2-Golang]
func findMode(root *TreeNode) (answer []int) {
    var base, count, maxCount int
    update := func(x int) {
        if x == base {
            count++
        } else {
            base, count = x, 1
        }
        if count == maxCount {
            answer = append(answer, base)
        } else if count > maxCount {
            maxCount = count
            answer = []int{base}
        }
    }
    cur := root
    for cur != nil {
        if cur.Left == nil {
            update(cur.Val)
            cur = cur.Right
            continue
        }
        pre := cur.Left
        for pre.Right != nil && pre.Right != cur {
            pre = pre.Right
        }
        if pre.Right == nil {
            pre.Right = cur
            cur = cur.Left
        } else {
            pre.Right = nil
            update(cur.Val)
            cur = cur.Right
        }
    }
    return
}
```

```C [sol2-C]
int base, count, maxCount;
int *answer, answerSize;

void update(int x) {
    if (x == base) {
        ++count;
    } else {
        count = 1;
        base = x;
    }
    if (count == maxCount) {
        answer[answerSize++] = base;
    }
    if (count > maxCount) {
        maxCount = count;
        answerSize = 0;
        answer[answerSize++] = base;
    }
}

int* findMode(struct TreeNode* root, int* returnSize) {
    struct TreeNode *cur = root, *pre = NULL;
    answer = malloc(sizeof(int) * 5001);
    answerSize = count = maxCount = 0;
    while (cur) {
        if (!cur->left) {
            update(cur->val);
            cur = cur->right;
            continue;
        }
        pre = cur->left;
        while (pre->right && pre->right != cur) {
            pre = pre->right;
        }
        if (!pre->right) {
            pre->right = cur;
            cur = cur->left;
        } else {
            pre->right = NULL;
            update(cur->val);
            cur = cur->right;
        }
    }
    *returnSize = answerSize;
    return answer;
}
```

**复杂度分析**

+ 时间复杂度：$O(n)$。每个点被访问的次数不会超过两次，故这里的时间复杂度是 $O(n)$。
+ 空间复杂度：$O(1)$。使用临时空间的大小和输入规模无关。
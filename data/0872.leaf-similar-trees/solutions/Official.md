## [872.叶子相似的树 中文官方题解](https://leetcode.cn/problems/leaf-similar-trees/solutions/100000/xie-zi-xiang-si-de-shu-by-leetcode-solut-z0w6)
#### 方法一：深度优先搜索

**思路与算法**

我们可以使用深度优先搜索的方法得到一棵树的「叶值序列」。

具体地，在深度优先搜索的过程中，我们总是先搜索当前节点的左子节点，再搜索当前节点的右子节点。如果我们搜索到一个叶节点，就将它的值放入序列中。

在得到了两棵树分别的「叶值序列」后，我们比较它们是否相等即可。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    void dfs(TreeNode* node, vector<int>& seq) {
        if (!node->left && !node->right) {
            seq.push_back(node->val);
        }
        else {
            if (node->left) {
                dfs(node->left, seq);
            }
            if (node->right) {
                dfs(node->right, seq);
            }
        }
    }

    bool leafSimilar(TreeNode* root1, TreeNode* root2) {
        vector<int> seq1;
        if (root1) {
            dfs(root1, seq1);
        }

        vector<int> seq2;
        if (root2) {
            dfs(root2, seq2);
        }

        return seq1 == seq2;
    }
};
```

```Java [sol1-Java]
class Solution {
    public boolean leafSimilar(TreeNode root1, TreeNode root2) {
        List<Integer> seq1 = new ArrayList<Integer>();
        if (root1 != null) {
            dfs(root1, seq1);
        }

        List<Integer> seq2 = new ArrayList<Integer>();
        if (root2 != null) {
            dfs(root2, seq2);
        }

        return seq1.equals(seq2);
    }

    public void dfs(TreeNode node, List<Integer> seq) {
        if (node.left == null && node.right == null) {
            seq.add(node.val);
        } else {
            if (node.left != null) {
                dfs(node.left, seq);
            }
            if (node.right != null) {
                dfs(node.right, seq);
            }
        }
    }
}
```

```C# [sol1-C#]
public class Solution {
    public bool LeafSimilar(TreeNode root1, TreeNode root2) {
        IList<int> seq1 = new List<int>();
        if (root1 != null) {
            DFS(root1, seq1);
        }

        IList<int> seq2 = new List<int>();
        if (root2 != null) {
            DFS(root2, seq2);
        }

        return seq1.SequenceEqual(seq2);
    }

    public void DFS(TreeNode node, IList<int> seq) {
        if (node.left == null && node.right == null) {
            seq.Add(node.val);
        } else {
            if (node.left != null) {
                DFS(node.left, seq);
            }
            if (node.right != null) {
                DFS(node.right, seq);
            }
        }
    }
}
```

```Python [sol1-Python3]
class Solution:
    def leafSimilar(self, root1: TreeNode, root2: TreeNode) -> bool:
        def dfs(node: TreeNode):
            if not node.left and not node.right:
                yield node.val
            else:
                if node.left:
                    yield from dfs(node.left)
                if node.right:
                    yield from dfs(node.right)
        
        seq1 = list(dfs(root1)) if root1 else list()
        seq2 = list(dfs(root2)) if root2 else list()
        return seq1 == seq2
```

```JavaScript [sol1-JavaScript]
var leafSimilar = function(root1, root2) {
    
    const seq1 = [];
    if (root1) {
        dfs(root1, seq1);
    }

    const seq2 = [];
    if (root2) {
        dfs(root2, seq2);
    }
    return seq1.toString() === seq2.toString();
};

const dfs = (node, seq) => {
    if (!node.left && !node.right) {
        seq.push(node.val);
    } else {
        if (node.left) {
            dfs(node.left, seq);
        }
        if (node.right) {
            dfs(node.right, seq);
        }
    }
}
```

```go [sol1-Golang]
func leafSimilar(root1, root2 *TreeNode) bool {
    vals := []int{}
    var dfs func(*TreeNode)
    dfs = func(node *TreeNode) {
        if node == nil {
            return
        }
        if node.Left == nil && node.Right == nil {
            vals = append(vals, node.Val)
            return
        }
        dfs(node.Left)
        dfs(node.Right)
    }
    dfs(root1)
    vals1 := append([]int(nil), vals...)
    vals = []int{}
    dfs(root2)
    if len(vals) != len(vals1) {
        return false
    }
    for i, v := range vals1 {
        if v != vals[i] {
            return false
        }
    }
    return true
}
```

```C [sol1-C]
void dfs(struct TreeNode* node, int* seq, int* seqSize) {
    if (!node->left && !node->right) {
        seq[(*seqSize)++] = node->val;
    } else {
        if (node->left) {
            dfs(node->left, seq, seqSize);
        }
        if (node->right) {
            dfs(node->right, seq, seqSize);
        }
    }
}

bool leafSimilar(struct TreeNode* root1, struct TreeNode* root2) {
    int seq1[200], seq1Size = 0;
    if (root1) {
        dfs(root1, seq1, &seq1Size);
    }

    int seq2[200], seq2Size = 0;
    if (root2) {
        dfs(root2, seq2, &seq2Size);
    }
    if (seq1Size != seq2Size) {
        return false;
    }
    for (int i = 0; i < seq1Size; i++) {
        if (seq1[i] != seq2[i]) {
            return false;
        }
    }
    return true;
}
```

**复杂度分析**

- 时间复杂度：$O(n_1 + n_2)$，其中 $n_1$ 和 $n_2$ 分别是两棵树的节点个数。

- 空间复杂度：$O(n_1 + n_2)$。空间复杂度主要取决于存储「叶值序列」的空间以及深度优先搜索的过程中需要使用的栈空间。
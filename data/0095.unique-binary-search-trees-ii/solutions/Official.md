## [95.不同的二叉搜索树 II 中文官方题解](https://leetcode.cn/problems/unique-binary-search-trees-ii/solutions/100000/bu-tong-de-er-cha-sou-suo-shu-ii-by-leetcode-solut)

#### 方法一：回溯

**思路与算法**

二叉搜索树关键的性质是根节点的值大于左子树所有节点的值，小于右子树所有节点的值，且左子树和右子树也同样为二叉搜索树。因此在生成所有可行的二叉搜索树的时候，假设当前序列长度为 $n$，如果我们枚举根节点的值为 $i$，那么根据二叉搜索树的性质我们可以知道左子树的节点值的集合为 $[1 \ldots i-1]$，右子树的节点值的集合为 $[i+1 \ldots n]$。而左子树和右子树的生成相较于原问题是一个序列长度缩小的子问题，因此我们可以想到用回溯的方法来解决这道题目。

我们定义 `generateTrees(start, end)` 函数表示当前值的集合为 $[\textit{start},\textit{end}]$，返回序列 $[\textit{start},\textit{end}]$ 生成的所有可行的二叉搜索树。按照上文的思路，我们考虑枚举 $[\textit{start},\textit{end}]$ 中的值 $i$ 为当前二叉搜索树的根，那么序列划分为了 $[\textit{start},i-1]$ 和 $[i+1,\textit{end}]$ 两部分。我们递归调用这两部分，即 `generateTrees(start, i - 1)` 和 `generateTrees(i + 1, end)`，获得所有可行的左子树和可行的右子树，那么最后一步我们只要从可行左子树集合中选一棵，再从可行右子树集合中选一棵拼接到根节点上，并将生成的二叉搜索树放入答案数组即可。

递归的入口即为 `generateTrees(1, n)`，出口为当 $\textit{start}>\textit{end}$ 的时候，当前二叉搜索树为空，返回空节点即可。

```C++ [sol1-C++]
class Solution {
public:
    vector<TreeNode*> generateTrees(int start, int end) {
        if (start > end) {
            return { nullptr };
        }
        vector<TreeNode*> allTrees;
        // 枚举可行根节点
        for (int i = start; i <= end; i++) {
            // 获得所有可行的左子树集合
            vector<TreeNode*> leftTrees = generateTrees(start, i - 1);

            // 获得所有可行的右子树集合
            vector<TreeNode*> rightTrees = generateTrees(i + 1, end);

            // 从左子树集合中选出一棵左子树，从右子树集合中选出一棵右子树，拼接到根节点上
            for (auto& left : leftTrees) {
                for (auto& right : rightTrees) {
                    TreeNode* currTree = new TreeNode(i);
                    currTree->left = left;
                    currTree->right = right;
                    allTrees.emplace_back(currTree);
                }
            }
        }
        return allTrees;
    }

    vector<TreeNode*> generateTrees(int n) {
        if (!n) {
            return {};
        }
        return generateTrees(1, n);
    }
};
```

```Java [sol1-Java]
class Solution {
    public List<TreeNode> generateTrees(int n) {
        if (n == 0) {
            return new LinkedList<TreeNode>();
        }
        return generateTrees(1, n);
    }

    public List<TreeNode> generateTrees(int start, int end) {
        List<TreeNode> allTrees = new LinkedList<TreeNode>();
        if (start > end) {
            allTrees.add(null);
            return allTrees;
        }

        // 枚举可行根节点
        for (int i = start; i <= end; i++) {
            // 获得所有可行的左子树集合
            List<TreeNode> leftTrees = generateTrees(start, i - 1);

            // 获得所有可行的右子树集合
            List<TreeNode> rightTrees = generateTrees(i + 1, end);

            // 从左子树集合中选出一棵左子树，从右子树集合中选出一棵右子树，拼接到根节点上
            for (TreeNode left : leftTrees) {
                for (TreeNode right : rightTrees) {
                    TreeNode currTree = new TreeNode(i);
                    currTree.left = left;
                    currTree.right = right;
                    allTrees.add(currTree);
                }
            }
        }
        return allTrees;
    }
}
```

```Python [sol1-Python3]
class Solution:
    def generateTrees(self, n: int) -> List[TreeNode]:
        def generateTrees(start, end):
            if start > end:
                return [None,]
            
            allTrees = []
            for i in range(start, end + 1):  # 枚举可行根节点
                # 获得所有可行的左子树集合
                leftTrees = generateTrees(start, i - 1)
                
                # 获得所有可行的右子树集合
                rightTrees = generateTrees(i + 1, end)
                
                # 从左子树集合中选出一棵左子树，从右子树集合中选出一棵右子树，拼接到根节点上
                for l in leftTrees:
                    for r in rightTrees:
                        currTree = TreeNode(i)
                        currTree.left = l
                        currTree.right = r
                        allTrees.append(currTree)
            
            return allTrees
        
        return generateTrees(1, n) if n else []
```

```C [sol1-C]
struct TreeNode** buildTree(int start, int end, int* returnSize) {
    if (start > end) {
        (*returnSize) = 1;
        struct TreeNode** ret = malloc(sizeof(struct TreeNode*));
        ret[0] = NULL;
        return ret;
    }
    *returnSize = 0;
    struct TreeNode** allTrees = malloc(0);
    // 枚举可行根节点
    for (int i = start; i <= end; i++) {
        // 获得所有可行的左子树集合
        int leftTreesSize;
        struct TreeNode** leftTrees = buildTree(start, i - 1, &leftTreesSize);

        // 获得所有可行的右子树集合
        int rightTreesSize;
        struct TreeNode** rightTrees = buildTree(i + 1, end, &rightTreesSize);

        // 从左子树集合中选出一棵左子树，从右子树集合中选出一棵右子树，拼接到根节点上
        for (int left = 0; left < leftTreesSize; left++) {
            for (int right = 0; right < rightTreesSize; right++) {
                struct TreeNode* currTree = malloc(sizeof(struct TreeNode));
                currTree->val = i;
                currTree->left = leftTrees[left];
                currTree->right = rightTrees[right];

                (*returnSize)++;
                allTrees = realloc(allTrees, sizeof(struct TreeNode*) * (*returnSize));
                allTrees[(*returnSize) - 1] = currTree;
            }
        }
        free(rightTrees);
        free(leftTrees);
    }
    return allTrees;
}

struct TreeNode** generateTrees(int n, int* returnSize) {
    if (!n) {
        (*returnSize) = 0;
        return NULL;
    }
    return buildTree(1, n, returnSize);
}
```

```golang [sol1-Golang]
func generateTrees(n int) []*TreeNode {
    if n == 0 {
        return nil
    }
    return helper(1, n)
}

func helper(start, end int) []*TreeNode {
    if start > end {
        return []*TreeNode{nil}
    }
    allTrees := []*TreeNode{}
    // 枚举可行根节点
    for i := start; i <= end; i++ {
        // 获得所有可行的左子树集合
        leftTrees := helper(start, i - 1)
        // 获得所有可行的右子树集合
        rightTrees := helper(i + 1, end)
        // 从左子树集合中选出一棵左子树，从右子树集合中选出一棵右子树，拼接到根节点上
        for _, left := range leftTrees {
            for _, right := range rightTrees {
                currTree := &TreeNode{i, nil, nil}
                currTree.Left = left
                currTree.Right = right
                allTrees = append(allTrees, currTree)
            }
        }
    }
    return allTrees
}
```

**复杂度分析**

- 时间复杂度：整个算法的时间复杂度取决于「可行二叉搜索树的个数」，而对于 $n$ 个点生成的二叉搜索树数量等价于数学上第 $n$ 个「卡特兰数」，用 $G_n$ 表示。卡特兰数具体的细节请读者自行查询，这里不再赘述，只给出结论。生成一棵二叉搜索树需要 $O(n)$ 的时间复杂度，一共有 $G_n$ 棵二叉搜索树，也就是 $O(nG_n)$。而卡特兰数以 $\frac{4^n}{n^{3/2}}$ 增长，因此总时间复杂度为 $O(\frac{4^n}{n^{1/2}})$。

- 空间复杂度：$n$ 个点生成的二叉搜索树有 $G_n$ 棵，每棵有 $n$ 个节点，因此存储的空间需要 $O(nG_n) = O(\frac{4^n}{n^{1/2}})$ ，递归函数需要 $O(n)$ 的栈空间，因此总空间复杂度为 $O(\frac{4^n}{n^{1/2}})$。
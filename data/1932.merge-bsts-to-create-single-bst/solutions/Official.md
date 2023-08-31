## [1932.合并多棵二叉搜索树 中文官方题解](https://leetcode.cn/problems/merge-bsts-to-create-single-bst/solutions/100000/he-bing-duo-ke-er-cha-sou-suo-shu-by-lee-m42t)
#### 方法一：构造的唯一性

**提示 $1$**

对于给定的第 $i$ 棵树 $\textit{tree}[i]$，记它根节点的值为 $\textit{root}[i]$。我们需要找到另一棵树，记为第 $j~(j \neq i)$ 棵。第 $j$ 棵树必须存在一个值为 $\textit{root}[i]$ 的叶节点，这样我们就可以把第 $i$ 棵树与第 $j$ 棵树合并。

如果不存在满足要求的第 $j$ 棵树，**那么第 $i$ 棵树的根节点就必须是合并完成后的树的根节点**。显然，这样的第 $i$ 棵树必须**恰好**有且仅有一棵。

如果存在唯一的第 $j$ 棵树，那么我们必须要将第 $i$ 棵树和第 $j$ 棵树合并。如果不这样做，合并完成后的树中就至少有两个值为 $\textit{root}[i]$ 的节点，它就一定不是二叉搜索树了。

如果存在多棵可行的第 $j$ 棵树，那么我们应当选择哪一棵呢？我们发现，由于题目保证**不存在值相同的两个根节点**，那么我们没有选择的那些树中，它们值为 $\textit{root}[i]$ 的叶节点都会被保留，而我们选择的第 $j$ 棵树与第 $i$ 棵树合并后，也会留下一个值为 $\textit{root}[i]$ 的节点。这样合并完成后的树中同样至少有两个值为 $\textit{root}[i]$ 的节点，也一定不是二叉搜索树了。

因此，如果某一棵树的根节点如果需要合并，那么合并的方案是**唯一**的。

**思路与算法**

根据提示 $1$，我们可以设计出如下的算法：

> 需要注意的是，该算法的细节较多，为了保证流畅性，在这一节中我们只会叙述算法本身，而不去解释其原因。算法中一些步骤的正确性会在下一节中阐述。

- 我们首先将每一棵树叶节点的值使用哈希集合 $\textit{leaves}$ 存储下来，随后就可以找出合并完成后的树的根节点。记包含根节点的那棵树为 $\textit{tree}[\textit{pivot}]$，则 $\textit{root}[\textit{pivot}]$ 不能在 $\textit{leaves}$ 中出现过。

    如果不存在满足要求的 $\textit{tree}[\textit{pivot}]$，那么就无法构造出一棵二叉搜索树；如果满足要求的 $\textit{tree}[\textit{pivot}]$ 不唯一，那么我们随便挑选一棵即可。

- 我们知道，一棵二叉树是二叉搜索树，当且仅当它的中序遍历的序列是严格单调递增的。因此，我们从 $\textit{tree}[\textit{pivot}]$ 的根节点开始，使用递归的方法对其进行一种特殊的中序遍历：

    - 当我们遍历到一个非叶节点时，我们按照常规的中序遍历的方法，继续进行遍历；

    - 当我们遍历到一个叶节点时，该叶节点可能会与另一棵树的根节点进行合并。设该叶节点的值为 $x$，如果存在根节点值同样为 $x$ 的树，我们就将其与该叶节点进行合并。在合并完成之后，该叶节点可能会变为非叶节点，我们需要继续按照常规的中序遍历的方法，继续进行遍历。

- 在遍历的过程中，如果我们发现遍历到的值不是严格单调递增的，说明无法构造出一棵二叉搜索树。同时，如果遍历结束，但存在某一棵树的根节点没有被遍历到，那也说明无法构造出一棵二叉搜索树。

**细节**

上一节中的给出的算法看上去非常神奇，我们针对几个具体的点进行详细的解释。

- 问：为什么如果满足要求的 $\textit{tree}[\textit{pivot}]$ 不唯一，我们可以随便挑选一棵？

- 答：假设有 $\textit{tree}[p_1]$ 和 $\textit{tree}[p_2]$ 都满足要求，不妨设我们挑选了 $\textit{tree}[p_1]$。由于 $\textit{root}[p_2]$ 没有在 $\textit{leaves}$ 中出现过，那么我们在遍历的过程中一定不会遍历到 $\textit{tree}[p_2]$ 的根节点。在遍历结束后，我们就发现无法构造出一棵二叉搜索树。

- 问：如何判断是否存在根节点值为 $x$ 的树？

- 答：我们可以使用哈希映射。由于题目保证不存在值相同的两个根节点，我们可以将树的根节点值与树本身作为键值对放入哈希映射中，这样就可以快速进行判断。

- 问：在遍历的过程中，如何保证一棵树最多只会被合并一次？

- 答：中序遍历的严格单调递增性保证了这一点。我们遍历的节点的值是严格单调递增的，那么同一棵树的根节点值最多只会被遍历到一次，这棵树也就最多只会被合并一次。

对于其余的细节，可以参考下面给出的代码。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    TreeNode* canMerge(vector<TreeNode*>& trees) {
        // 存储所有叶节点值的哈希集合
        unordered_set<int> leaves;
        // 存储 (根节点值, 树) 键值对的哈希映射
        unordered_map<int, TreeNode*> candidates;
        for (TreeNode* tree: trees) {
            if (tree->left) {
                leaves.insert(tree->left->val);
            }
            if (tree->right) {
                leaves.insert(tree->right->val);
            }
            candidates[tree->val] = tree;
        }

        // 存储中序遍历上一个遍历到的值，便于检查严格单调性
        int prev = 0;
        
        // 中序遍历，返回值表示是否有严格单调性
        function<bool(TreeNode*)> dfs = [&](TreeNode* tree) {
            if (!tree) {
                return true;
            }

            // 如果遍历到叶节点，并且存在可以合并的树，那么就进行合并
            if (!tree->left && !tree->right && candidates.count(tree->val)) {
                tree->left = candidates[tree->val]->left;
                tree->right = candidates[tree->val]->right;
                // 合并完成后，将树从哈希映射中移除，以便于在遍历结束后判断是否所有树都被遍历过
                candidates.erase(tree->val);
            }
            
            // 先遍历左子树
            if (!dfs(tree->left)) {
                return false;
            }
            // 再遍历当前节点
            if (tree->val <= prev) {
                return false;
            };
            prev = tree->val;
            // 最后遍历右子树
            return dfs(tree->right);
        };
        
        for (TreeNode* tree: trees) {
            // 寻找合并完成后的树的根节点
            if (!leaves.count(tree->val)) {
                // 将其从哈希映射中移除
                candidates.erase(tree->val);
                // 从根节点开始进行遍历
                // 如果中序遍历有严格单调性，并且所有树的根节点都被遍历到，说明可以构造二叉搜索树
                return (dfs(tree) && candidates.empty()) ? tree : nullptr;
            }
        }
        return nullptr;
    }
};
```

```Python [sol1-Python3]
class Solution:
    def canMerge(self, trees: List[TreeNode]) -> Optional[TreeNode]:
        # 存储所有叶节点值的哈希集合
        leaves = set()
        # 存储 (根节点值, 树) 键值对的哈希映射
        candidates = dict()
        for tree in trees:
            if tree.left:
                leaves.add(tree.left.val)
            if tree.right:
                leaves.add(tree.right.val)
            candidates[tree.val] = tree
        
        # 存储中序遍历上一个遍历到的值，便于检查严格单调性
        prev = float("-inf")
        
        # 中序遍历，返回值表示是否有严格单调性
        def dfs(tree: Optional[TreeNode]) -> bool:
            if not tree:
                return True
            
            # 如果遍历到叶节点，并且存在可以合并的树，那么就进行合并
            if not tree.left and not tree.right and tree.val in candidates:
                tree.left = candidates[tree.val].left
                tree.right = candidates[tree.val].right
                # 合并完成后，将树丛哈希映射中移除，以便于在遍历结束后判断是否所有树都被遍历过
                candidates.pop(tree.val)
            
            # 先遍历左子树
            if not dfs(tree.left):
                return False
            # 再遍历当前节点
            nonlocal prev
            if tree.val <= prev:
                return False
            prev = tree.val
            # 最后遍历右子树
            return dfs(tree.right)
        
        for tree in trees:
            # 寻找合并完成后的树的根节点
            if tree.val not in leaves:
                # 将其从哈希映射中移除
                candidates.pop(tree.val)
                # 从根节点开始进行遍历
                # 如果中序遍历有严格单调性，并且所有树的根节点都被遍历到，说明可以构造二叉搜索树
                return tree if dfs(tree) and not candidates else None
        
        return None
```

**复杂度分析**

- 时间复杂度：$O(n)$。

- 空间复杂度：$O(n)$。
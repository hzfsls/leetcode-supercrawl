## [2196.根据描述创建二叉树 中文官方题解](https://leetcode.cn/problems/create-binary-tree-from-descriptions/solutions/100000/gen-ju-miao-shu-chuang-jian-er-cha-shu-b-sqrk)

#### 方法一：哈希表

**思路与算法**

由于数组 $\textit{descriptions}$ 中用节点的数值表示对应节点，因此为了方便查找，我们用哈希表 $\textit{nodes}$ 来维护数值到对应节点的映射。

我们可以遍历数组 $\textit{descriptions}$ 来创建二叉树。具体地，当我们遍历到三元组 $[p, c, \textit{left}]$ 时，我们首先判断 $\textit{nodes}$ 中是否存在 $p$ 与 $c$ 对应的树节点，如果没有则我们新建一个数值为对应值的节点。随后，我们根据 $\textit{left}$ 的真假将 $p$ 对应的节点的左或右子节点设为 $c$ 对应的节点。当遍历完成后，我们就重建出了目标二叉树。

除此之外，我们还需要寻找二叉树的根节点。这个过程也可以在遍历和建树的过程中完成。我们可以同样用一个哈希表 $\textit{isRoot}$ 维护数值与是否为根节点的映射。在遍历时，我们需要将 $\textit{isRoot}[c]$ 设为 $\texttt{false}$（因为该节点有父节点）；而如果 $p$ 在 $\textit{isRoot}$ 中不存在，则说明 $p$ **暂时**没有父节点，我们可以将 $\textit{isRoot}[c]$ 设为 $\texttt{true}$。最终在遍历完成后，一定**有且仅有一个**元素 $\textit{root}$ 在 $\textit{isRoot}$ 中的数值为 $\texttt{true}$，此时对应的 $\textit{node}[i]$ 为二叉树的根节点，我们返回该节点作为答案。

**代码**

```C++ [sol1-C++]
class Solution {
public:
    TreeNode* createBinaryTree(vector<vector<int>>& descriptions) {
        unordered_map<int, bool> isRoot;   // 数值对应的节点是否为根节点的哈希表
        unordered_map<int, TreeNode*> nodes;   // 数值与对应节点的哈希表
        for (const auto& d: descriptions) {
            int p = d[0];
            int c = d[1];
            bool left = d[2];
            if (!isRoot.count(p)) {
                isRoot[p] = true;
            }
            isRoot[c] = false;
            // 创建或更新节点
            if (!nodes.count(p)) {
                nodes[p] = new TreeNode(p);
            }
            if (!nodes.count(c)) {
                nodes[c] = new TreeNode(c);
            }
            if (left) {
                nodes[p]->left = nodes[c];
            } else {
                nodes[p]->right = nodes[c];
            }
        }
        // 寻找根节点
        int root = -1;
        for (const auto& [val, r]: isRoot) {
            if (r) {
                root = val;
                break;
            }
        }
        return nodes[root];
    }
};
```


```Python [sol1-Python3]
class Solution:
    def createBinaryTree(self, descriptions: List[List[int]]) -> Optional[TreeNode]:
        isRoot = {}   # 数值对应的节点是否为根节点的哈希表
        nodes = {}   # 数值与对应节点的哈希表
        for p, c, left in descriptions:
            if p not in isRoot:
                isRoot[p] = True
            isRoot[c] = False
            # 创建或更新节点
            if p not in nodes:
                nodes[p] = TreeNode(p)
            if c not in nodes:
                nodes[c] = TreeNode(c)
            if left:
                nodes[p].left = nodes[c]
            else:
                nodes[p].right = nodes[c]
        # 寻找根节点
        root = -1
        for val, r in isRoot.items():
            if r:
                root = val
                break
        return nodes[root]
```


**复杂度分析**

- 时间复杂度：$O(n)$，其中 $n$ 为数组 $\textit{descriptions}$ 的长度。即为遍历构造二叉树并寻找根节点的时间复杂度。

- 空间复杂度：$O(n)$，即为哈希表的空间开销。
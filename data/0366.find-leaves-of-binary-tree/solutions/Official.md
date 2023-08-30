[TOC]

 ## 解决方案

---

 #### 方法 1：使用排序的深度优先搜索（DFS）

 **概述**

 最终答案中元素（节点）的收集顺序取决于这些节点的""高度""。节点的高度是从节点到最深叶子的边的数量。位于 i 高度的节点将出现在最终答案的 i 集合中。对于二叉树中的任何给定节点，高度可通过加1到任何子节点的最大高度来获取。正式来说，对于二叉树的给定节点$\text{root}$，它的高度可以表示为
 $\text{height(root)} = \text{1} + \text{max(height(root.left), height(root.right))}$
 其中 $\text{root.left}$ 和 $\text{root.right}$ 分别是根节点的左右子节点

 **算法**

 在我们的第一种方法中，我们将简单地以深度优先搜索的方式递归遍历树，使用函数 `int getHeight(node)`，它将返回二叉树中给定节点的高度。由于任何节点的高度都取决于它的子节点的高度，因此我们已经按照后序方式遍历树（即在计算给定节点的高度之前先计算子节点的高度）。此外，每当我们遇到空节点时，我们都会直接返回 -1 作为它的高度。
 接下来，我们将把所有节点的对 `(height, val)` 存储下来，后面会进行排序以获得最终答案。排序将首先考虑高度，然后是 val。因此，我们将按照给定二叉树中它们高度的递增顺序获得所有的对。

 以下是此方法的实现

 ```C++ [slu1]
 class Solution {
public:
    
    vector<pair<int, int>> pairs;
    
    int getHeight(TreeNode *root) {
        
        // 对于空节点返回 -1
        if (!root) return -1;
        
        // 首先计算左右两个孩子的高度
        int leftHeight = getHeight(root->left);
        int rightHeight = getHeight(root->right);
        
        // 根据左右子节点的高度，获取当前(父)节点的高度
        int currHeight = max(leftHeight, rightHeight) + 1;
        
        // 记录高度和值的对 -> (height, val)
        this->pairs.push_back({currHeight, root->val});
        
        // 返回当前点的高度
        return currHeight;
    }
    
    vector<vector<int>> findLeaves(TreeNode* root) {
        this->pairs.clear();
        
        getHeight(root);
        
        // 对所有 (height, val) 对排序
        sort(this->pairs.begin(), this->pairs.end());
        
        int n = this->pairs.size(), height = 0, i = 0;
        vector<vector<int>> solution;
        while (i < n) {
            vector<int> nums;
            while (i < n && this->pairs[i].first == height) {
                nums.push_back(this->pairs[i].second);
                i++;
            }
            solution.push_back(nums);
            height++;
        }
        return solution;
    }
};
 ```

 ```Java [slu1]
 class Solution {
    private List<Pair<Integer, Integer>> pairs;
    
    private int getHeight(TreeNode root) {
        
        // 对于空节点返回 -1
        if (root == null) return -1;
        
        // 首先计算左右两个孩子的高度
        int leftHeight = getHeight(root.left);
        int rightHeight = getHeight(root.right);
        
        // 根据左右子节点的高度，获取当前(父)节点的高度
        int currHeight = Math.max(leftHeight, rightHeight) + 1;

        // 记录高度和值的对 -> (height, val)
        this.pairs.add(new Pair<Integer, Integer>(currHeight, root.val));

        // 返回当前点的高度
        return currHeight;
    }
    
    public List<List<Integer>> findLeaves(TreeNode root) {
        this.pairs = new ArrayList<>();
        
        getHeight(root);
        
        // 对所有 (height, val) 对排序
        Collections.sort(this.pairs, Comparator.comparing(p -> p.getKey()));
        
        int n = this.pairs.size(), height = 0, i = 0;

        List<List<Integer>> solution = new ArrayList<>();
        
        while (i < n) {
            List<Integer> nums = new ArrayList<>();
            while (i < n && this.pairs.get(i).getKey() == height) {
                nums.add(this.pairs.get(i).getValue());
                i++;
            }
            solution.add(nums);
            height++;
        }
        return solution;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：假设 $N$ 是二叉树中节点的总数，遍历树需要 $O(N)$ 时间。根据它们的高度排序所有的对需要 $O(N \log N)$ 时间。因此，这种方法的总体时间复杂度为 $O(N \log N)$。
 * 空间复杂度：$O(N)$，由 `pairs` 和 `getHeight` 中递归调用栈所使用的空间。

---

 #### 方法 2：未排序的深度优先搜索（DFS）

 我们在方法 1 中看到，有一个额外的排序过程，使得总体的时间复杂度增加到了 $O(N \log N)$。我们能做得更好吗？为了回答这个问题，我们试图通过直接将所有值放在它们各自的位置来删除排序，即我们不是使用 `pairs` 数组来收集所有的 `(height, val)` 对，然后根据它们的高度排序，我们将直接通过将每个元素(`val`)放在解决方案数组的正确位置来获得解决方案。为了澄清，在给定的二叉树中，`[4, 3, 5]` 进入第一个位置，`[2]` 进入第二个位置，`[1]` 进入第三个位置。
 为此，我们修改我们的 `getHeight` 方法，直接将节点的值插入到解决方案数组的正确位置。一开始，解决方案数组是空的，当我们遇到递增的高度的元素时，我们就会增加解决方案数组的大小，以便容纳这些元素。例如，如果我们的解决方案数组当前是 `[[4, 3, 5]]`，我们想要在第二个位置插入 2，我们首先通过增加解决方案数组的大小来为 2 创建空间，然后将 2 插入到它的正确位置。

 * `[[4, 3, 5]] -> [[4, 3, 5], []] # 增加解决方案数组的大小`
 * `[[4, 3, 5], []] -> [[4, 3, 5], [2]] # 在其正确的位置插入 2`

 以下是上述方法的实现。

 ```C++ [slu2]
 class Solution {
private:

    vector<vector<int>> solution;

public:
    
    int getHeight(TreeNode *root) {
        
        // 对所有空节点返回 -1
        if (!root) {
            return -1;
        }

        // 首先计算左右两个孩子的高度
        int leftHeight = getHeight(root->left);
        int rightHeight = getHeight(root->right);
        
        // 根据左右子节点的高度，获取当前(父)节点的高度
        int currHeight = max(leftHeight, rightHeight) + 1;
        
        // 如果不存在位于 `currHeight` 处的节点，则为其创建空间
        if (this->solution.size() == currHeight) {
            this->solution.push_back({});
        }

        // 在解决方案数组中的正确位置插入值
        this->solution[currHeight].push_back(root->val);
        
        // 返回当前点的高度
        return currHeight;
    }
    
    vector<vector<int>> findLeaves(TreeNode* root) {
        this->solution.clear();
        
        getHeight(root);
        
        return this->solution;
    }
};
 ```

 ```Java [slu2]
 class Solution {
    
    private List<List<Integer>> solution;
    
    private int getHeight(TreeNode root) {
        
        // 对所有空节点返回 -1
        if (root == null) {
            return -1;
        }
        
        // 首先计算左右两个孩子的高度
        int leftHeight = getHeight(root.left);
        int rightHeight = getHeight(root.right);
        
        int currHeight = Math.max(leftHeight, rightHeight) + 1;
        
        if (this.solution.size() == currHeight) {
            this.solution.add(new ArrayList<>());
        }
        
        this.solution.get(currHeight).add(root.val);
        
        return currHeight;
    }
    
    public List<List<Integer>> findLeaves(TreeNode root) {
        this.solution = new ArrayList<>();
        
        getHeight(root);
        
        return this.solution;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：假设 $N$ 是二叉树中节点的总数，遍历树需要 $O(N)$ 时间，将所有的对放在正确的位置也需要 $O(N)$ 时间。因此，这种方法的总体时间复杂度为 $O(N)$。
 * 空间复杂度：$O(N)$，由递归调用栈所使用的空间。
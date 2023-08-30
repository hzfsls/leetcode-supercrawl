[TOC] 

 ## 解决方案 

---

 #### 方法 1: 后序遍历 

 **思路和步骤** 

 要计算以 `node` 为根的子树的平均值，我们需要两样东西： 

 1. `node` 子树中所有节点值的总和，我们将其称为 `ValueSum(node)`。
 2. `node` 子树中的节点数，我们将其称为 `NodeCount(node)`。

 那么，以 `node` 为根的子树的平均值将是 `ValueSum(node)/NodeCount(node)`。 
 现在，要计算以 `node` 为根的子树的这些值，我们可以从 `node` 的子节点派生它们。 

 1. `ValueSum(node) = ValueSum(node.left) + ValueSum(node.right) + Value(node)`
 2. `NodeCount(node) = NodeCount(node.left) + NodeCount(node.right) + 1` 

 此外，对于任何叶节点 `leaf`，我们知道： 

 1. `ValueSum(leaf) = node.val`
 2. `NodeCount(leaf) = 1` 

 看看这些等式，我们可以看到我们通过自下而上遍历可以为树中的每个节点计算平均值，即先访问和计算子节点的 `ValueSum` 和 `NodeCount`，然后使用这些子节点的值来解决父节点问题。这种树遍历的顺序被广泛称为后序遍历。 

 ![image.png](https://pic.leetcode.cn/1692082788-KEaLmz-image.png){:width=800}

 ```C++ [slu1]
 class Solution {
public:
    double maximumAverageSubtree(TreeNode* root) {
        return maxAverage(root).maxAverage;
    }

private:
    struct State {
        // 子树节点的数量
        int nodeCount;

        // 子树值的总和
        int valueSum;

        // 子树中的最大平均值
        double maxAverage;
    };

    State maxAverage(TreeNode* root) {
        if (!root) return {0, 0, 0};

        // 先序遍历，先解决两个子节点。
        State left = maxAverage(root->left);
        State right = maxAverage(root->right);

        // 现在为当前节点 `root` 查找 nodeCount、valueSum 和 maxAverage
        int nodeCount = left.nodeCount + right.nodeCount + 1;
        int sum = left.valueSum + right.valueSum + root->val;
        double maxAverage = max(
                (1.0 * (sum)) / nodeCount, // 当前节点的平均值
                max(right.maxAverage, left.maxAverage) // 子节点的平均值
        );

        return {nodeCount, sum, maxAverage};
    }
};
 ```

 ```Java [slu1]
 class Solution {
    // 对树上的每一个节点，我们维护三个值
    class State {
        // 子树节点的数量
        int nodeCount;

        // 子树值的总和
        int valueSum;

        // 子树中的最大平均值
        double maxAverage;

        State(int nodes, int sum, double maxAverage) {
            this.nodeCount = nodes;
            this.valueSum = sum;
            this.maxAverage = maxAverage;
        }
    }

    public double maximumAverageSubtree(TreeNode root) {
        return maxAverage(root).maxAverage;
    }

    State maxAverage(TreeNode root) {
        if (root == null) {
            return new State(0, 0, 0);
        }

        // 先序遍历，先解决两个子节点。
        State left = maxAverage(root.left);
        State right = maxAverage(root.right);

        // 现在为当前节点 `root` 查找 nodeCount、valueSum 和 maxAverage
        int nodeCount = left.nodeCount + right.nodeCount + 1;
        int sum = left.valueSum + right.valueSum + root.val;
        double maxAverage = Math.max(
                (1.0 * (sum)) / nodeCount, // 当前节点的平均值
                Math.max(right.maxAverage, left.maxAverage) // 子节点的平均值
        );

        return new State(nodeCount, sum, maxAverage);
    }
}
 ```

 **复杂度分析** 

 * 时间复杂度 : $O(N)$，其中 $N$ 是树中节点的数量。这是因为我们只访问每个节点一次，正如我们在后序遍历中所做的那样。 
 * 空间复杂度 : $O(N)$，因为我们将为树中的每个节点创建 $N$ 个状态。另外，在我们有倾斜树的情况下，我们将隐性地维护一个大小为 $N$ 的递归栈，因此，从这一点来看，空间复杂度也将为 $O(N)$。
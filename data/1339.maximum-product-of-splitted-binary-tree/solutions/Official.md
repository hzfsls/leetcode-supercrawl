#### 方法一：数学

记二叉树中所有元素的值之和为 `sum_r`。

假设我们删除的边的两个端点为 `u` 和 `v`，其中 `u` 是 `v` 的父节点，那么在这条边删除之后，其中的一棵子树以 `v` 为根节点，记其中所有元素之和为 `sum_v`；另一棵子树以原二叉树的根节点 `root` 为根节点，其中元素之和为 `sum_r - sum_v`。我们需要找到一个节点 `v`，使得 `(sum_v) * (sum_r - sum_v)` 的值最大。

那么我们如何找到这个节点呢？我们首先使用深度优先搜索计算出 `sum_r`，即遍历二叉树中的每一个节点，将其对应的元素值进行累加。随后我们再次使用深度优先搜索，通过递归的方式计算出每一个节点 `v` 对应的子树元素之和 `sum_v`，并求出所有 `(sum_v) * (sum_r - sum_v)` 中的最大值，就可以得到答案。

由于题目中需要将结果对 `10^9+7` 取模，我们需要注意的是，不能在计算 `(sum_v) * (sum_r - sum_v)` 时将其直接对 `10^9+7` 取模，这是因为原先较大的数，取模之后不一定仍然较大。这一步可以有两种解决方案：

- 我们用 64 位的整数类型（例如 `long`，`long long` 等）计算和存储 `(sum_v) * (sum_r - sum_v)` 的值，并在最后对 `10^9+7` 取模；

- 我们使用均值不等式的知识，当 `sum_r` 为定值时，`sum_v` 越接近 `sum_r` 的一半，`(sum_v) * (sum_r - sum_v)` 的值越大。我们只需要存储最接近 `sum_r` 的一半的那个 `sum_v`，在最后计算 `(sum_v) * (sum_r - sum_v)` 的值并对 `10^9+7` 取模。


```C++ [sol1-C++]
class Solution {
private:
    int sum = 0;
    int best = 0;

public:
    void dfs(TreeNode* node) {
        if (!node) {
            return;
        }
        sum += node->val;
        dfs(node->left);
        dfs(node->right);
    }

    int dfs2(TreeNode* node) {
        if (!node) {
            return 0;
        }
        int cur = dfs2(node->left) + dfs2(node->right) + node->val;
        if (abs(cur*2 - sum) < abs(best*2 - sum)) {
            best = cur;
        }
        return cur;
    }

    int maxProduct(TreeNode* root) {
        dfs(root);
        dfs2(root);
        return (long long)best * (sum - best) % 1000000007;
    }
};
```


**复杂度分析**

- 时间复杂度：$O(N)$，其中 $N$ 是二叉树的节点个数。

- 空间复杂度：$O(1)$。
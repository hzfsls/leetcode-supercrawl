## [549.二叉树中最长的连续序列 中文官方题解](https://leetcode.cn/problems/binary-tree-longest-consecutive-sequence-ii/solutions/100000/er-cha-shu-zhong-zui-chang-de-lian-xu-xu-cnbb)
[TOC] 

 ## 摘要 

 在二叉树中寻找最长的连续路径长度。该路径可以是递增或递减的，即[1,2,3,4]和[4,3,2,1]都被认为是有效的。路径可以是子节点-父节点-子节点或父节点-子节点。 

 ## 解决方案 

---

 #### 方法 1：暴力

 由于树中没有环路，所以从一个节点到另一个节点必定有一个唯一的路径。因此，可能的路径数量将等于节点对的数量 ${{N}\choose{2}}$，其中 $N$ 是节点的数量。 

 解决此问题的暴力法是找到每两个节点之间的路径并检查它是否是递增或递减的。这样我们可以找到最大长度的递增或递减序列。 

 **复杂性分析** 

 * 时间复杂度：$O(n^3)$。总共可能的路径数量为 $n^2$，每个路径检查是否是递增或递减需要 $O(n)$ 的时间。 
 * 空间复杂度：$O(n^3)$。每一个路径包含 $O(n)$ 个节点，一共有 $n^2$ 条路径。 

---

 #### 方法 2：单遍遍历 

 **算法** 

 对于每个节点，我们关联两个值/变量命名为 $inr$ 和 $dcr$，其中 $inr$ 代表包括当前节点，当前节点下面的最长递增路径长度，$dcr$ 代表包括当前节点，当前节点下面的最长递减路径长度。 

 我们使用一个递归函数 `longestPath(node)`，对于调用节点它将返回一个形式为 $[inr, dcr]$ 的数组。对于当前节点，我们开始时将 $inr$ 和 $dcr$ 都赋值为 1。这是因为节点本身总是形成长度为 1 的连续递增和递减路径。 

 然后，我们使用 `longestPath(root.left)` 得到当前节点左子节点的最长路径长度。现在，如果左子节点的值比当前节点小 1，它和当前节点构成了一个递减序列。因此，当前节点的 $dcr$ 值被存储为左子节点的 $dcr$ 值 +1。但是，如果左子节点的值比当前节点的值大 1，它和当前节点构成了一个递增序列。因此，我们更新当前节点的 $inr$ 值为 $left\_child(inr) + 1$。 

 然后，我们对右子节点做同样的处理。但是，为了得到当前节点的 $inr$ 和 $dcr$ 值，我们需要考虑从左右子节点得到的 $inr$ 和 $dcr$ 中的较大值，这是因为我们需要考虑可能的最长序列。 

 最后，在我们为节点得到了最终的 $inr$ 和 $dcr$ 值后，我们将迄今为止找到的最长连续路径的长度更新为 $maxval = \text{max}(inr + dcr - 1)$。我们减去 1 是为了不让当前节点被两次计算，因为 $inr$ 和 $dcr$ 都将当前节点包括在路径长度中。 

 以下动画将有助于说明该过程： 

 <![image.png](https://pic.leetcode.cn/1692078852-Nnolbc-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078854-qAUtFL-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078857-NHggOb-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078859-RBGadE-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078862-mICNsd-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078864-CsUQqc-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078867-zCsTFh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078870-WtyFga-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078872-qmRadm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078877-GZTTVb-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078879-krqSah-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078882-LGMOSC-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078885-DiUnzh-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078888-eEKsyi-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078890-UEDRck-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078893-xmwBoK-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078896-HuQftJ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692078899-wuvDkf-image.png){:width=400}>

 ```Java [slu2]
 public class Solution {
    int maxval = 0;
    
    public int longestConsecutive(TreeNode root) {
        longestPath(root);
        return maxval;
    }
    
    public int[] longestPath(TreeNode root) {
        if (root == null) {
            return new int[] {0,0};
        }
        
        int inr = 1, dcr = 1;
        if (root.left != null) {
            int[] left = longestPath(root.left);
            if (root.val == root.left.val + 1) {
                dcr = left[1] + 1;
            } else if (root.val == root.left.val - 1) {
                inr = left[0] + 1;
            }
        }
        
        if (root.right != null) {
            int[] right = longestPath(root.right);
            if (root.val == root.right.val + 1) {
                dcr = Math.max(dcr, right[1] + 1);
            } else if (root.val == root.right.val - 1) {
                inr = Math.max(inr, right[0] + 1);
            }
        }
        
        maxval = Math.max(maxval, dcr + inr - 1);
        return new int[] {inr, dcr};
    }
}
 ```

 ```Python3 [slu2]
 class Solution:
    def longestConsecutive(self, root: TreeNode) -> int:
                
        def longest_path(root: TreeNode) -> List[int]:
            nonlocal maxval
            
            if not root:
                return [0, 0]
            
            inr = dcr = 1
            if root.left:
                left = longest_path(root.left)
                if (root.val == root.left.val + 1):
                    dcr = left[1] + 1
                elif (root.val == root.left.val - 1):
                    inr = left[0] + 1
            
            if root.right:
                right = longest_path(root.right)
                if (root.val == root.right.val + 1):
                    dcr = max(dcr, right[1] + 1)
                elif (root.val == root.right.val - 1):
                    inr = max(inr, right[0] + 1)
                    
            maxval = max(maxval, dcr + inr - 1)
            return [inr, dcr]
        
        maxval = 0
        longest_path(root)
        return maxval
 ```

 **复杂性分析** 

 * 时间复杂度：$O(n)$。整棵树只遍历一次。
 * 空间复杂度：$O(n)$。在最坏的情况下，递归可以深入到 $n$ 的深度。
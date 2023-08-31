## [663.均匀树划分 中文官方题解](https://leetcode.cn/problems/equal-tree-partition/solutions/100000/jun-yun-shu-hua-fen-by-leetcode-solution-y1wk)
[TOC]

#### 方法 1：深度优先搜索

 **概述和算法**
 在从 `parent` 到 `child` 的某个边之后（`child` 不能是原始 `root`），以 `child` 为根的子树必须是整个树总和的一半。
 我们记录下每个子树的和。我们可以使用深度优先搜索递归地完成此操作。然后，我们应检查整棵树的一半的和是否出现在我们的记录中（并且不是来自整棵树的总和。）
 我们上述的仔细处理和分析，避免了在下面这些树的情况下出错：

```text
  0  
 / \ 
-1  1

  0 
   \ 
    0
```

 ```Java [slu1]
 class Solution {
    Stack<Integer> seen;
    public boolean checkEqualTree(TreeNode root) {
        seen = new Stack();
        int total = sum(root);
        seen.pop();
        if (total % 2 == 0)
            for (int s: seen)
                if (s == total / 2)
                    return true;
        return false;
    }

    public int sum(TreeNode node) {
        if (node == null) return 0;
        seen.push(sum(node.left) + sum(node.right) + node.val);
        return seen.peek();
    }
}
 ```

 ```Python3 [slu1]
 class Solution(object):
    def checkEqualTree(self, root):
        seen = []

        def sum_(node):
            if not node: return 0
            seen.append(sum_(node.left) + sum_(node.right) + node.val)
            return seen[-1]

        total = sum_(root)
        seen.pop()
        return total / 2.0 in seen
 ```

 **复杂性分析**

 * 时间复杂度：$O(N)$，其中 $N$ 是输入树中的节点数量。我们遍历每个节点。
 * 空间复杂度：$O(N)$，即 `seen` 的大小和我们的 DFS 中隐式调用堆栈的大小。
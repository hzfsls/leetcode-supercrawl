## [298.二叉树最长连续序列 中文官方题解](https://leetcode.cn/problems/binary-tree-longest-consecutive-sequence/solutions/100000/er-cha-shu-zui-chang-lian-xu-xu-lie-by-l-m6oh)

[TOC]

## 解决方案

---

 #### 方法 1：自顶而下深度优先搜索

 **算法**

自顶向下的方法类似于中序遍历。我们用一个变量 `length` 来存储当前连续路径的长度，并将其传递到树的下一层。在遍历过程中，我们将当前节点与其父节点进行比较，以确定它们是否连续。如果不连续，我们就重置长度。

 ```Java
private int maxLength = 0;
public int longestConsecutive(TreeNode root) {
    dfs(root, null, 0);
    return maxLength;
}

private void dfs(TreeNode p, TreeNode parent, int length) {
    if (p == null) return;
    length = (parent != null && p.val == parent.val + 1) ? length + 1 : 1;
    maxLength = Math.max(maxLength, length);
    dfs(p.left, p, length);
    dfs(p.right, p, length);
}
 ```

 另一个简洁的方法，不需要把 maxLength 作为全局变量存储。

 ```Java
public int longestConsecutive(TreeNode root) {
    return dfs(root, null, 0);
}

private int dfs(TreeNode p, TreeNode parent, int length) {
    if (p == null) return length;
    length = (parent != null && p.val == parent.val + 1) ? length + 1 : 1;
    return Math.max(length, Math.max(dfs(p.left, p, length),
                                     dfs(p.right, p, length)));
}
 ```

 **复杂性分析** 

 * 时间复杂度 : $O(n)$。 
    时间复杂度与二叉树的中序遍历相同，为 $n$ 个节点。 
 * 空间复杂度 : $O(n)$。
    额外的空间来源于递归的隐式堆栈空间。对于倾斜的二叉树，递归可能会深入到 $n$ 层。 

---

 #### 方法 2：自底而上深度优先搜索

 **算法** 

自底向下的方法类似于后序遍历。我们返回从当前节点到其父节点的连续路径长度。然后父节点可以检查其节点值是否可以包含在这个连续路径中。

 ```Java
private int maxLength = 0;
public int longestConsecutive(TreeNode root) {
    dfs(root);
    return maxLength;
}

private int dfs(TreeNode p) {
    if (p == null) return 0;
    int L = dfs(p.left) + 1;
    int R = dfs(p.right) + 1;
    if (p.left != null && p.val + 1 != p.left.val) {
        L = 1;
    }
    if (p.right != null && p.val + 1 != p.right.val) {
        R = 1;
    }
    int length = Math.max(L, R);
    maxLength = Math.max(maxLength, length);
    return length;
}
 ```

 **复杂性分析** 

 * 时间复杂度 : $O(n)$。
    时间复杂度与二叉树的后序遍历相同，为 $O(n)$。 
 * 空间复杂度 : $O(n)$。
    额外的空间来源于递归的隐式堆栈空间。对于倾斜的二叉树，递归可能会深入到 $n$ 层。
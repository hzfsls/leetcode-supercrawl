## [510.二叉搜索树中的中序后继 II 中文官方题解](https://leetcode.cn/problems/inorder-successor-in-bst-ii/solutions/100000/er-cha-sou-suo-shu-zhong-de-zhong-xu-hou-z8uq)
[TOC]

 ## 解决方案 

---

 #### 后继和前驱

 > 后继 = "后节点"，即在中序遍历中的下一个节点， 或者是当前节点的下一个最小的节点。

 > 前驱 = "前节点"，即在中序遍历中的上一个节点， 或者是当前节点的上一个最大的节点。

 ![image.png](https://pic.leetcode.cn/1692072532-BYTXjb-image.png){:width=800}

---

 #### 方法 1：迭代

 **简述** 

 这里有两种可能的情况： 

 - 节点有右子节点，因此它的后继者在树的下面某处。要找到后继者，先向右走一步，然后尽可能地向左走。 

 ![image.png](https://pic.leetcode.cn/1692072641-wZArVF-image.png){:width=800}

 - 节点没有右子节点，那么它的后继者在树的上面某处。要找到后继者，向上走，直到节点是其父节点的_左_子节点。答案是父节点。注意，在这种情况下，可能没有后继者（= null 后继者）。 

 ![image.png](https://pic.leetcode.cn/1692073085-wVYwJq-image.png){:width=800}

---

 ![image.png](https://pic.leetcode.cn/1692073206-ruafTH-image.png){:width=800}

 **算法** 

 1. 如果节点有右子节点，那么它的后继者在树的下部。向右走一步，然后尽可能地向左走。返回你最终停留的节点。 
 2. 节点没有右子节点，因此它的后继者在树的上部。向上走，直到节点是其父节点的_左_子节点。答案是父节点。 

 **实现** 

 ```C++ [slu1]
 class Solution {
public:
    Node* inorderSuccessor(Node* node) {
        // 后继位于右子树中较低的位置
        if (node->right) {
            node = node->right;
            while (node->left) node = node->left;
            return node;   
        }
        
        // 后继位于树中较高的位置
        while (node->parent && node == node->parent->right) node = node->parent;
        return node->parent;
    }
};
 ```
```Java [slu1]
class Solution {
  public Node inorderSuccessor(Node x) {
    // 后继位于右子树中较低的位置
    if (x.right != null) {
      x = x.right;
      while (x.left != null) x = x.left;
      return x;
    }

    // 后继位于树中较高的位置
    while (x.parent != null && x == x.parent.right) x = x.parent;
    return x.parent;
  }
}
```

```Python [slu1]
class Solution:
    def inorderSuccessor(self, node: 'Node') -> 'Node':
        # 后继位于右子树中较低的位置
        if node.right:
            node = node.right
            while node.left:
                node = node.left
            return node
        
        # 后继位于树中较高的位置
        while node.parent and node == node.parent.right:
            node = node.parent
        return node.parent
```

 **复杂度分析** 

 * 时间复杂度：$\mathcal{O}(H)$，其中 $H$ 为树的高度。这意味着平均情况下为 $\mathcal{O}(\log N)$，最坏情况下为 $\mathcal{O}(N)$，其中 $N$ 为树中的节点数量。 
 * 空间复杂度：$\mathcal{O}(1)$，因为在计算过程中不分配额外的空间。
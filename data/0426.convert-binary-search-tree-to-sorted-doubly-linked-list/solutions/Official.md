[TOC]

## 解决方案

---

#### 如何遍历树

 遍历树的一般策略有两种：

- *深度优先搜索* (DFS)
  在这种策略中，我们将 `深度` 作为优先级，因此我们从根节点开始，一路搜索到某个叶子节点，然后返回根节点寻找另一条分支。DFS 策略可以进一步区分为 `前序`，`中序` 和 `后序`，这取决于根节点、左节点和右节点之间的相对顺序。
- *广度优先搜索* (BFS)
  我们按照高度的顺序，从上到下扫描整棵树。高层级的节点会比低层级的节点先被访问。在下面的图像中，节点按照你访问它们的顺序进行编号，请按照 `1-2-3-4-5` 的顺序比较不同的策略。

 ![image.png](https://pic.leetcode.cn/1692260149-imNihS-image.png){:width=800}

 这个问题是以教科书递归方式实现 DFS 中序遍历，因为它要求就地（in-place）操作。

---

#### 方法 1: 递归

 **算法**
 标准的中序递归遵循 `左 -> 节点 -> 右` 的顺序，其中 `左` 和 `右` 部分是递归调用，而 `节点` 是所有处理过程的执行场所。
 处理在这里基本上是将前一个节点与当前节点相连，并记录到目前为止新双向链表中的最大节点，亦即最后一个节点。

 ![image.png](https://pic.leetcode.cn/1692259916-CWtGNL-image.png){:width=400}

 再多一个细节：需要保留第一个，即最小的节点，以封闭双向链表的环。
 这是算法的步骤：

- 初始化 `first` 和 `last` 节点为 null。
- 调用标准的中序递归 `helper(root)` ：
- 如果节点不为 null：
  - 调用左子树的递归 `helper(node.left)`。
  - 如果 `last` 节点不为 null，将 `last` 和当前 `node` 节点连接起来。
  - 若 else，则初始化 `first` 节点。
  - 将当前节点标记为最后一个节点：`last = node`。
  - 调用右子树的递归 `helper(node.right)`。
- 将首尾两个节点连接起来，封闭 DLL 环，然后返回 `first` 节点。

**实现**

 <![image.png](https://pic.leetcode.cn/1692261086-QUbeSV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692261130-KoYVAI-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692261133-CkTJsc-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692261135-TZdsYX-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692261138-APpvYm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692261141-gqxroe-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692261144-tKPNtN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692261146-SAJeEX-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692261149-fLFrWt-image.png){:width=400}>

```C++ [slu]
class Solution {
  public:
  // 最小(第一个)和最大(最后一个)节点
  Node* first = NULL;
  Node* last = NULL;

  void helper(Node* node) {
    if (node) {
      // 左子树
      helper(node->left);
      if (last) {
        // 链接前一个节点(最后一个)
        // 使用当前节点
        last->right = node;
        node->left = last;
      }
      else {
        // 保留最小的节点
        // 稍后关闭 DLL
        first = node;
      }
      last = node;
      // 右子树
      helper(node->right);
    }
  }

  Node* treeToDoublyList(Node* root) {
    if (!root) return NULL;

    helper(root);
    // 关闭 DLL
    last->right = first;
    first->left = last;
    return first;
  }
};
```

```Java [slu]
class Solution {
  // 最小(第一个)和最大(最后一个)节点
  Node first = null;
  Node last = null;

  public void helper(Node node) {
    if (node != null) {
      // 左子树
      helper(node.left);
      if (last != null) {
        // 链接前一个节点(最后一个)
        // 使用当前节点
        last.right = node;
        node.left = last;
      }
      else {
        // 保留最小的节点
        // 稍后关闭 DLL
        first = node;
      }
      last = node;
      // 右子树
      helper(node.right);
    }
  }

  public Node treeToDoublyList(Node root) {
    if (root == null) return null;

    helper(root);
    // 关闭 DLL
    last.right = first;
    first.left = last;
    return first;
  }
}
```

```Python [slu]
class Solution:
    def treeToDoublyList(self, root: 'Node') -> 'Node':
        def helper(node):
            """"""
            执行标准的序遍历:
            左->节点->右
            并将所有节点链接到DLL中
            """"""
            nonlocal last, first
            if node:
                # 左子树
                helper(node.left)
                if last:
                    # 链接前一个节点(最后一个)
                    # 使用当前节点
                    last.right = node
                    node.left = last
                else:
                    # 保留最小的节点
                    # 稍后关闭 DLL
                    first = node        
                last = node
                # 右子树
                helper(node.right)
        
        if not root:
            return None
        
        # 最小(第一个)和最大(最后一个)节点
        first, last = None, None
        helper(root)
        # 关闭 DLL
        last.right = first
        first.left = last
        return first
```

 **复杂度分析**

- 时间复杂度：$\mathcal{O}(N)$，因为每个节点只处理一次。
- 空间复杂度：$\mathcal{O}(N)$。我们需要保持一个树高程度的递归栈，对于完全平衡的树来说，最优情况为 $\mathcal{O}(\log N)$，对于完全不平衡的树来说，最坏情况为 $\mathcal{O}(N)$。
[TOC]

## 解决方案

---

#### 前言

 有多种方法可以将N叉树编码为二叉树。

 在开始的部分，我们将直观地展示这个想法，其实这个想法我们将在接下来的部分中以不同的方式实现。

 ![image.png](https://pic.leetcode.cn/1692083164-YcGwsO-image.png){:width=600}

 简单来说，这个算法可以总结为两个步骤。我们将使用上面的N叉树作为示例来演示。

 > 步骤1. 将所有**_兄弟节点_**链接在一起，形成一个单向链表。

 在原始N叉树中的每个节点将在结果二叉树中具有唯一的对应节点。

 在第一步中，我们首先将所有兄弟节点链接在一起，_即_与同一个父节点的节点。通过**链接**，我们将通过二叉树节点的`left`或`right`子节点指针来连接这些节点。在这里，我们选择使用**`right`指针**进行链接。

 ![image.png](https://pic.leetcode.cn/1692083204-mXgTzS-image.png){:width=600}

 > 步骤2. 将得到的兄弟节点列表的**_head_**与其**_parent_**节点相链接。

 现在兄弟节点已经链在一起了，我们只需将这个兄弟节点列表与它们的父节点链接就可以了。

 可以看到，我们不必将每个兄弟节点都链接到其父节点上，也不能这样做，因为在二叉树的节点中我们只有两个指针可以用。只需要选择其中一个兄弟节点即可。自然地，我们可以将列表的头部与其父节点链接起来。

 ![image.png](https://pic.leetcode.cn/1692083335-ZjjUuY-image.png){:width=600}

 _在你察觉之前，经过上述两个步骤，我们已经将N叉树转化为二叉树了！_

 以上图的形式可能并不明显。但是如果将图向顺时针旋转 45 度，会出现一个二叉树。

 ![image.png](https://pic.leetcode.cn/1692083422-kmFVXc-image.png){:width=600}

 可以想象，基于上述想法，可以创建一些变种。例如，我们可以使用 `left` 指针进行链接，而不是 `right` 指针，并且相应地，我们可以从最后一个子节点开始链接兄弟节点。下面是这个变种。

 ![image.png](https://pic.leetcode.cn/1692083610-gUTEfq-image.png){:width=600}

---

#### 方法 1：BFS（广度优先搜索）

 **概述**

 遍历树数据结构通常有两种策略: _BFS（广度优先搜索）_ 和 _DFS（深度优先搜索）_。

 根据文章开始的概述，你可能会发现这个方法非常适合 BFS 策略，因为我们按照**一层层**的方式遍历节点，即我们将处于树同一层的兄弟节点链接起来。事实上，我们可以用 BFS 策略来实现这个算法。但实际上，正如我们将在后面证明的那样，我们也可以通过 DFS 策略来实现它。

 **算法步骤**

 让我们从 BFS 中的 `encode(root)` 函数开始：

- 说到 BFS，你应该首先想到的是它本质上是通过**_队列_**数据结构实现的。确实，首先，所有兄弟节点都会按顺序推入队列。并且，队列头部的节点将首先被处理，这符合队列数据结构的原则，即 **_FIFO_**（先进先出）。
- 算法的主体由一个**_循环_**构成，该循环遍历队列，直到队列变空。在每次循环中，我们从队列头部弹出一个节点，并对其进行处理。
- 对于弹出的节点，运行另一个**_循环_**以遍历其子节点。你应该注意到，这是前一个遍历队列的循环中的一个嵌套循环。在每次**嵌套循环**中，对于每个子节点，我们做**两件事**：
  - 首先，我们将这个子节点与其前一个兄弟节点链接在一起。
  - 其次，我们将这个子节点添加到队列中，以便它有机会作为父节点来编码它自己的子节点。
- 就是这样。一个重要的注意事项是我们在遍历N叉树的同时构建所需的二叉树。因此，我们将队列中每个入口保持为一个**_对偶_**，即 `pair(n-ary_tree_node, binary_tree_node)`。
- 为了使算法更高效，我们可以在函数开始时处理输入 N 叉树为空的情况。

 <![image.png](https://pic.leetcode.cn/1692084618-CIqqsE-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692084621-rSXHfY-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692084624-TIRBPp-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692084627-iRpkkZ-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692084629-NgZbsm-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692084632-lrIovx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692084635-kVQljE-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692084637-NfbrFb-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692084641-rpoMXe-image.png){:width=400}>

 ```Java [slu1]
 /*
// Node 的定义。
class Node {
    public int val;
    public List<Node> children;

    public Node() {}

    public Node(int _val) {
        val = _val;
    }

    public Node(int _val, List<Node> _children) {
        val = _val;
        children = _children;
    }
};
*/

/*
// 二叉树节点的定义。
public class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
   TreeNode(int x) { val = x; }
}
*/

class Pair<U, V> {
  public U first;
  public V second;

  public Pair(U first, V second) {
    this.first = first;
    this.second = second;
  }
}

class Codec {

  // 将一棵 n 叉树编码为一棵二叉树
  public TreeNode encode(Node root) {
    if (root == null) {
      return null;
    }
    TreeNode newRoot = new TreeNode(root.val);
    Pair<TreeNode, Node> head = new Pair<TreeNode, Node>(newRoot, root);

    // 添加第一个元素以启动循环
    Queue<Pair<TreeNode, Node>> queue = new ArrayDeque<Pair<TreeNode, Node>>();
    queue.add(head);

    while (queue.size() > 0) {
      Pair<TreeNode, Node> pair = queue.remove();
      TreeNode bNode = pair.first;
      Node nNode = pair.second;

      // 将子节点编码为TreeNode列表。
      TreeNode prevBNode = null, headBNode = null;
      for (Node nChild : nNode.children) {
        TreeNode newBNode = new TreeNode(nChild.val);
        if (prevBNode == null) {
          headBNode = newBNode;
        } else {
          prevBNode.right = newBNode;
        }
        prevBNode = newBNode;

        Pair<TreeNode, Node> nextEntry = new Pair<TreeNode, Node>(newBNode, nChild);
        queue.add(nextEntry);
      }

      // 将子节点列表附加到左侧节点。
      bNode.left = headBNode;
    }

    return newRoot;
  }

  // 将你的二叉树解码为 n 叉树。
  public Node decode(TreeNode root) {
    if (root == null) {
      return null;
    }
    Node newRoot = new Node(root.val, new ArrayList<Node>());

    // 添加第一个元素以启动循环
    Queue<Pair<Node, TreeNode>> queue = new ArrayDeque<Pair<Node, TreeNode>>();
    Pair<Node, TreeNode> head = new Pair<Node, TreeNode>(newRoot, root);
    queue.add(head);

    while (queue.size() > 0) {
      Pair<Node, TreeNode> entry = queue.remove();
      Node nNode = entry.first;
      TreeNode bNode = entry.second;

      // 解码子列表
      TreeNode firstChild = bNode.left;
      TreeNode sibling = firstChild;
      while (sibling != null) {
        Node nChild = new Node(sibling.val, new ArrayList<Node>());
        nNode.children.add(nChild);

        // 准备解码队列中孩子的孩子
        Pair<Node, TreeNode> nextEntry = new Pair<Node, TreeNode>(nChild, sibling);
        queue.add(nextEntry);

        sibling = sibling.right;
      }
    }

    return newRoot;
  }
}

// 您的Codec对象将如下被实例化并被调用:
// Codec codec = new Codec();
// codec.decode(codec.encode(root));
 ```

 ```Python [slu1]
 """"""
# Node 的定义。
class Node(object):
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children
""""""
""""""
# 二叉树节点的定义。
class TreeNode(object):
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None
""""""
class Codec:
    def encode(self, root):
        """"""将一棵 n 叉树编码为一棵二叉树
        :type root: Node
        :rtype: TreeNode
        """"""
        if not root:
            return None

        rootNode = TreeNode(root.val)
        queue = deque([(rootNode, root)])

        while queue:
            parent, curr = queue.popleft()
            prevBNode = None
            headBNode = None
            # 逐个遍历每个孩子
            for child in curr.children:
                newBNode = TreeNode(child.val)
                if prevBNode:
                    prevBNode.right = newBNode
                else:
                    headBNode = newBNode
                prevBNode = newBNode
                queue.append((newBNode, child))

            # 使用parent的左侧节点中的第一个子节点
            parent.left = headBNode

        return rootNode


    def decode(self, data):
        """"""将你的二叉树解码为 n 叉树。
        :type data: TreeNode
        :rtype: Node
        """"""
        if not data:
            return None

        # 应将缺省值设置为[]，而不是无，
        # 否则它不会通过测试用例。
        rootNode = Node(data.val, [])

        queue = deque([(rootNode, data)])

        while queue:
            parent, curr = queue.popleft()

            firstChild = curr.left
            sibling = firstChild

            while sibling:
                # 注：孩子名单的初始值不应为None，这是线上评测机的预设。
                newNode = Node(sibling.val, [])
                parent.children.append(newNode)
                queue.append((newNode, sibling))
                sibling = sibling.right

        return rootNode
 ```

 关于 `decode(node)` 函数，类似于我们的编码函数，我们可以用 _BFS_ 的方式来实现。
 - 同样，主要的算法是围绕一个 _queue_ 数据结构组织的循环。
 - 我们从已编码的二叉树的根节点开始，将其推入队列。
 - 在每一次迭代中，我们从队列中弹出一个二叉树节点，然后取该节点的 `left` 子节点作为原始N叉树节点的对应的第一个子节点。
 - 然后我们通过跟踪二叉树节点的 `right` 指针来恢复其余的子节点。

 **复杂性分析**

- 时间复杂度: $\mathcal{O}(N)$ ，其中 $N$ 是N叉树中的节点数量。我们遍历树中的每一个节点一次且只有一次。
- 空间复杂度: $\mathcal{O}(L)$，其中 $L$ 是在同一层中的节点的最大数量。  由于在最坏的情况下， $L$ 是与 $N$ 成正比的，我们可以将空间复杂度进一步精确为 $\mathcal{O}(N)$。
- 我们使用一个队列数据结构来进行 BFS 遍历，_即_按层级访问节点。
- 在任何给定的时刻，队列中包含的节点_最多_分布在_两个级别_中。因此，假设一个级别中的最大节点数为 $L$，那么任何时候队列的大小都会小于 $2L$。
- 然后，`encode()` 和 `decode()`函数的空间复杂度都为 $\mathcal{O}(L)$。

---

 #### 方法 2：DFS（深度优先搜索）

 **概述**

 事实证明，我们也可以通过 DFS（深度优先搜索）遍历策略来实现文章开头的想法。

 通常，我们使用**_递归_**技术实现 DFS 算法，这可以极大地简化逻辑。我们不需要明确列出所有的迭代步骤，而可以借助函数本身来实现这个函数。

 > 这个想法是，当我们在 DFS 模式下_节点接节点地_遍历 N 叉树时，我们_同时_将这些节点**_串联_**在二叉树之中，遵循与前一种方法（`方法 1`）同样的编码概述。

 **算法步骤**

 再次，我们以 `encode(node)` 函数为例来说明。
 > 算法的主要想法是，对于每一个节点，我们只在乎它自身的编码，对于其每一个子节点，我们调用函数自身来对其进行编码，即 `encode(node.children[i])`。

- 在 `encode(node)` 函数的开始，我们创建一个二叉树节点，其中包含当前节点的值。
- 然后我们将 N 叉树节点的第一个子节点设定为新创建的二叉树节点的 left 节点。我们递归地调用编码函数来对第一个子节点进行编码。
- 对于N叉树节点的其余子节点，我们将它们与二叉树节点的 `right` 指针链接在一起。而且，我们递归地调用编码函数来对每一个子节点进行编码。

 ![image.png](https://pic.leetcode.cn/1692085030-nLVnqX-image.png){:width=400}

 ```Java [slu2]
 /*
// Node 的定义。
class Node {
    public int val;
    public List<Node> children;

    public Node() {}

    public Node(int _val) {
        val = _val;
    }

    public Node(int _val, List<Node> _children) {
        val = _val;
        children = _children;
    }
};
*/
/**
 * 二叉树节点的定义。
 * public class TreeNode {
 *     int val;
 *     TreeNode left;
 *     TreeNode right;
 *     TreeNode(int x) { val = x; }
 * }
 */

class Codec {

  // 将一棵 N 叉树编码为二叉树。
  public TreeNode encode(Node root) {
    if (root == null) {
      return null;
    }

    TreeNode newRoot = new TreeNode(root.val);

    // 将 N 叉树节点的第一个子节点编码到二叉树的左侧节点。
    if (root.children.size() > 0) {
      Node firstChild = root.children.get(0);
      newRoot.left = this.encode(firstChild);
    }

    // 对其余兄弟节点进行编码。
    TreeNode sibling = newRoot.left;
    for (int i = 1; i < root.children.size(); ++i) {
      sibling.right = this.encode(root.children.get(i));
      sibling = sibling.right;
    }

    return newRoot;
  }

  // 将二叉树解码为 N 叉树
  public Node decode(TreeNode root) {
    if (root == null) {
      return null;
    }

    Node newRoot = new Node(root.val, new ArrayList<Node>());

    // 对所有子节点进行解码
    TreeNode sibling = root.left;
    while (sibling != null) {
      newRoot.children.add(this.decode(sibling));
      sibling = sibling.right;
    }

    return newRoot;
  }
}

// 你的 Codec 对象将被如下实例化并调用:
// Codec codec = new Codec();
// codec.decode(codec.encode(root));
 ```

 ```Python [slu2]
 """"""
# Node 的定义。
class Node(object):
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children
""""""
""""""
# 二叉树节点的定义。
class TreeNode(object):
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None
""""""
class Codec:

    def encode(self, root):
        """"""将一棵 N 叉树编码为二叉树。
        :type root: Node
        :rtype: TreeNode
        """"""
        if not root:
            return None

        rootNode = TreeNode(root.val)
        if len(root.children) > 0:
            firstChild = root.children[0]
            rootNode.left = self.encode(firstChild)

        # 其余孩子的父母
        curr = rootNode.left

        # 对其余的孩子进行编码
        for i in range(1, len(root.children)):
            curr.right = self.encode(root.children[i])
            curr = curr.right

        return rootNode


    def decode(self, data):
        """"""将二叉树解码为 N 叉树
        :type data: TreeNode
        :rtype: Node
        """"""
        if not data:
            return None

        rootNode = Node(data.val, [])

        curr = data.left
        while curr:
            rootNode.children.append(self.decode(curr))
            curr = curr.right

        return rootNode
 ```

 **复杂度分析**

- 时间复杂度: $\mathcal{O}(N)$，其中 $N$ 是N叉树中的节点数量。我们遍历树中的每一个节点一次且只有一次。
- 空间复杂度: $\mathcal{O}(D)$，其中 $D$ 是N叉树的深度。  由于在最坏的情况下， $D$ 是与 $N$ 成正比的，我们可以将空间复杂度进一步精确为 $\mathcal{O}(N)$。
    - 不像 BFS 算法，我们在 DFS 算法中并没有使用队列数据结构。然而，由于递归函数调用，算法会隐式地消耗更多的空间。
    - 这个调用栈空间的消耗就是我们DFS算法的主要空间复杂度。正如我们可以看到的，任何时刻的调用栈的大小就是当前访问节点所在的**级别数**， _比如_ 对于根节点(级别 _0_ )，递归调用栈为空。
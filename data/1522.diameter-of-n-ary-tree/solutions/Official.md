[TOC]

 ## 解决方案

---

#### 概述

 我们被要求计算一个 N 叉树的直径，这被定义为树中任意两节点之间的**最长路径**。
 乍一看，我们可能需要枚举所有节点对，以找出最长的路径。
 然而，有一些特点可以让我们大大减少枚举的范围。

 >第一个特点是，树中的最长路径只能发生在两个**叶子**节点之间，或者在一个叶子节点和**根**节点之间。

 ![image.png](https://pic.leetcode.cn/1692085504-PUfntz-image.png){:width=600}

 >第二个特点是，每个非叶子节点都充当了其**_后代叶子_**节点之间路径的**桥梁**。如果我们选择从非叶子节点到其后代叶子节点的两个最长子路径，并将它们合并在一起，那么 resulting 的路径将是所有可能的桥接路径中最长的。

 ![image.png](https://pic.leetcode.cn/1692085722-pcdeRT-image.png){:width=600}

 如上图所示，树的最长路径将是顶部两个最长子路径中的一个，这些子路径由非叶节点（上图中的节点`2`）_桥接_。

 >通过以上特点，要找到树的直径，只需要枚举所有非叶节点，并选择每个非叶节点桥接的前两个最长子路径。

 以上想法可以借助树数据结构中的两个重要概念实现，即节点的 **高度** 和 **深度**。
 本文将分别以高度和深度的概念呈现两种算法。


---

#### 方法 1：距离高度

 **思路**

 >节点的 **_高度_** 定义为该节点至一个叶子节点的最长向下路径的长度。

 基于以上定义，叶子节点的高度为零。
 如我们在概述部分解释的，一个非叶子节点的最长桥接路径将来自于此非叶节点向下至叶子节点的两个最长 **子路径** 的组合。
 如现在可以看出，我们提到的 _子路径_ 是子节点中最大的两个 _高度_ 组成的。
 如果我们将子节点中的最大两个 _高度_ 定义为 `height(node.child_m)` 和 `height(node.child_n)`，那么此非叶子节点的最长桥接路径将为 `height(node.child_m) + height(node.child_n) + 2`。
 ![image.png](https://pic.leetcode.cn/1692085863-fxCoLV-image.png){:width=600}

 **算法**
 首先，让我们定义一个名为 `height(node)` 的函数，返回节点的高度。 该函数可以通过递归实现，基于以下公式：
 $\text{height(node)} = \max\big(\text{height(child)}\big) + 1, \space \forall \text{child} \in \text{node.children}$
 更重要的是，在 `height(node)` 函数内，我们需要选择子节点的前两个最大 _高度_，用这两个最大高度，我们计算组合路径的长度，这将作为整棵树的直径候选。
 有两种方式可以选择前两个最大高度：

 - 一种直接的方式是我们将所有子节点的高度保留在一个数组中，然后**排序**数组并选择前两个最大元素。
 - 一种常数空间的解决方案是我们只使用两个变量来分别跟踪当前最大的两个元素。当我们遍历所有高度时，我们相应地**_更新_**这两个变量。
   在以下实现中，我们选择了第二种方法。

 ```Java [solution]
class Solution {
    protected int diameter = 0;

    /**
     * 返回节点的高度
     */
    protected int height(Node node) {
        if (node.children.size() == 0)
            return 0;

        // 选择上面两个最大的高度
        int maxHeight1 = 0, maxHeight2 = 0;
        for (Node child : node.children) {
            int parentHeight = height(child) + 1;
            if (parentHeight > maxHeight1) {
                maxHeight2 = maxHeight1;
                maxHeight1 = parentHeight;
            } else if (parentHeight > maxHeight2) {
                maxHeight2 = parentHeight;
            }
            // 计算两个最远的叶节点之间的距离。
            int distance = maxHeight1 + maxHeight2;
            this.diameter = Math.max(this.diameter, distance);
        }

        return maxHeight1;
    }

    public int diameter(Node root) {
        this.diameter = 0;
        height(root);
        return diameter;
    }
}
 ```

```Python3 [solution]
""""""""""""
# 节点的定义。
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children if children is not None else []
""""""""""""
class Solution:
    def diameter(self, root: 'Node') -> int:
        diameter = 0

        def height(node):
            """""""""""" return the height of the node """"""""""""
            nonlocal diameter

            if len(node.children) == 0:
                return 0

            # 选择顶部的两个高度
            max_height_1, max_height_2 = 0, 0
            for child in node.children:
                parent_height = height(child) + 1
                if parent_height > max_height_1:
                    max_height_1, max_height_2 = parent_height, max_height_1
                elif parent_height > max_height_2:
                    max_height_2 = parent_height

            # 计算两个最远的叶节点之间的距离。
            distance = max_height_1 + max_height_2
            diameter = max(diameter, distance)

            return max_height_1

        height(root)
        return diameter
```


 **复杂度分析**
 设$N$为树中的节点数。

 - 时间复杂度：$\mathcal{O}(N)$
   - 我们通过递归一次且仅一次枚举树中的每个节点。
 - 空间复杂度：$\mathcal{O}(N)$
   - 在算法中，我们只使用了常数大小的变量。
   - 另一方面，我们使用了递归，这将在函数调用堆栈中消耗额外的内存。在最坏的情况下，所有的节点都在一条路径上链接起来，递归将叠加$N$次。
   - 因此，算法的总体空间复杂度为$\mathcal{O}(N)$。

---

#### 方法 2：距离深度

 **思路**

 >节点的**深度**是至**根**节点路径的长度。

这次我们可以通过深度的概念来计算一个非叶子节点桥接的两个叶节点之间的最长路径，而不是高度。
 如果我们知道从节点开始的两个叶节点中的前两个最大深度，即 `depth(node.leaf_m)` 和 `depth(node.leaf_n)`，那么此最长路径可以计算为前两个最大深度之和减去父节点的深度，即 `depth(node.leaf_m) + depth(node.leaf_n) - 2 * depth(node)`。
 ![image.png](https://pic.leetcode.cn/1692086108-dXlFnl-image.png){:width=400}

 **算法**
 定义一个函数 `maxDepth(node)` 返回从节点开始的叶节点的最大深度。
 同样，我们可以通过递归实现，公式如下：
 $\text{maxDepth(node)} = \max\big(\text{maxDepth(node.child)}\big), \space \forall \text{child} \in \text{node.children}$
 同样，在函数内，我们也会选择前两个最大深度。由这两个最大深度，我们将 accordingly 更新直径。

 ```Java [solution]
class Solution {
    protected int diameter = 0;

    /**
     * 返回从给定节点下降的叶子节点的最大深度
     */
    protected int maxDepth(Node node, int currDepth) {
        if (node.children.size() == 0)
            return currDepth;

        // 选择前两个最大深度
        int maxDepth1 = currDepth, maxDepth2 = 0;
        for (Node child : node.children) {
            int depth = maxDepth(child, currDepth + 1);
            if (depth > maxDepth1) {
                maxDepth2 = maxDepth1;
                maxDepth1 = depth;
            } else if (depth > maxDepth2) {
                maxDepth2 = depth;
            }
            // 计算两个最远的叶节点之间的距离。
            int distance = maxDepth1 + maxDepth2 - 2 * currDepth;
            this.diameter = Math.max(this.diameter, distance);
        }

        return maxDepth1;
    }

    public int diameter(Node root) {
        this.diameter = 0;
        maxDepth(root, 0);
        return diameter;
    }
}
 ```

```Python3 [solution]
""""""""""""
# 节点的定义
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children if children is not None else []
""""""""""""
class Solution:
    def diameter(self, root: 'Node') -> int:
        """"""""""""
        :type root: 'Node'
        :rtype: int
        """"""""""""
        diameter = 0

        def maxDepth(node, curr_depth):
            """""""""""" 
                返回从当前节点下降的叶子节点的最大深度
            """"""""""""
            nonlocal diameter

            if len(node.children) == 0:
                return curr_depth
            
            # 从它的子深度中选择前 2 个深度
            max_depth_1, max_depth_2 = curr_depth, 0
            for child in node.children:
                depth = maxDepth(child, curr_depth+1)
                if depth > max_depth_1:
                    max_depth_1, max_depth_2 = depth, max_depth_1
                elif depth > max_depth_2:
                    max_depth_2 = depth

            # 计算两个最远的叶节点之间的距离
            distance = max_depth_1 + max_depth_2 - 2 * curr_depth
            diameter = max(diameter, distance)

            return max_depth_1

        maxDepth(root, 0)
        return diameter
```


 **复杂度分析**
 设 $N$ 为树中的节点数。

 - 时间复杂度：$\mathcal{O}(N)$
   - 我们通过递归一次且仅一次枚举树中的每个节点。
 - 空间复杂度：$\mathcal{O}(N)$
   - 在算法中，我们只使用了常数大小的变量。
   - 另一方面，我们使用了递归，这将在函数调用堆栈中消耗额外的内存。在最坏的情况下，所有的节点都在一条路径上链接起来，递归将叠加$N$次。
   - 因此，算法的整体空间复杂度为$\mathcal{O}(N)$。

---
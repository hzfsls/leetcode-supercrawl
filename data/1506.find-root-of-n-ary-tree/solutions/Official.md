## [1506.找到 N 叉树的根节点 中文官方题解](https://leetcode.cn/problems/find-root-of-n-ary-tree/solutions/100000/zhao-dao-n-cha-shu-de-gen-jie-dian-by-le-2nb1)
[TOC]

## 解答方案

---

#### 方案 1：Déjà-Vu (_O(N)_ 空间)

 **简述**

 我们得到一个 N 叉树中节点的打乱列表。 然后我们要找到根节点，根节点可能位于列表的任意位置。

 给定一个节点，我们可以获取到其子节点的引用。 但是我们没有其父节点的引用。

 >根节点与其他节点的一项显著 **特征** 是，根节点没有任何父节点， 也就是说如果我们将树视为图，根节点的 **入度** 为零。

 基于上述，我们可以将问题重新描述如下： 
 >给定一个节点列表，我们要找到 **入度** 为零的节点。

 ![image.png](https://pic.leetcode.cn/1691727287-SZRgYt-image.png){:width=400}


 要完成上述任务，最直观的途径之一就是我们要 **遍历** 列表中的每一个元素，并且对于每一个元素我们访问其每一个子节点。

 任何被 **看到** 的子节点的入度都为1，因此它们都不能做根节点。

 >换句话说，如果我们访问了所有的节点和所有的 **子节点**，那么根节点将会是唯一一个没有被作为子节点看到的节点。

 **算法思路**

 基于算法简述，有几种方式可以实现这个想法。

 这里给出一种时间复杂度为 $\mathcal{O}(N)$（$N$ 是输入列表的长度）的方案。

 我们可以使用一个哈希集合（名为 `seen`）来跟踪我们访问过的所有 **子节点**，那么最后根节点是不会在这个集合中的。 我们可以使用 **两次迭代** 来找到根节点：

 - 在第一次迭代中，我们遍历输入列表中的元素。 对于每一个元素，我们将其子节点放入哈希集 `seen`。 因为每个节点的值都是唯一的，我们可以将节点本身或者简单地将其值放入哈希集。
 - 然后，我们再次遍历列表。 这次，所有的子节点都在哈希集中。 当我们遇到任何不在哈希集中的节点时，这个节点就是我们要找的根节点。


```Java [slu1]
class Solution {
    public Node findRoot(List<Node> tree) {
        // 包含所有子节点的
        HashSet<Integer> seen = new HashSet<Integer>();

        // 将所有子节点添加到集合中
        for (Node node : tree) {
            for (Node child : node.children)
                // 我们可以添加该值，也可以添加该节点本身。
                seen.add(child.val);
        }

        Node root = null;
        // 查找不在子节点集中的节点
        for (Node node : tree) {
            if (!seen.contains(node.val)) {
                root = node;
                break;
            }
        }
        return root;
    }
}
```

```Python3 [slu1]
""""""
# Definition for a Node.
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children if children is not None else []
""""""
class Solution:
    def findRoot(self, tree: List['Node']) -> 'Node':
        # 包含所有子节点
        seen = set()

        # 将所有子节点添加到集合中
        for node in tree:
            for child in node.children:
                # 我们可以添加值或者节点本身
                seen.add(child.val)

        # 查找不在子节点集中的节点
        for node in tree:
            if node.val not in seen:
                return node
```

 **复杂度分析**
 设 $N$ 是输入列表的长度，也就是N叉树中节点的数量。

 - 时间复杂度： $\mathcal{O}(N)$
   - 在第一次迭代中，我们访问每一个节点以及其子节点。  对于非根节点，它会被访问两次。  而对于根节点，它会被访问一次。  因此，这部分的时间复杂度是 $\mathcal{O}(N + N - 1) = \mathcal{O}(N) $。
   - 至于第二次迭代，在最坏的情况下，我们需要遍历整个列表来找到根节点。  因此，这部分的时间复杂度是 $\mathcal{O}(N)$。
   - 总体上，算法的时间复杂度是 $\mathcal{O}(N) + \mathcal{O}(N) = \mathcal{O}(N)$。

 - 空间复杂度： $\mathcal{O}(N)$
   - 我们使用了一个哈希集来跟踪所有的子节点。  因此，集合中包含的元素数量将会正好是 $(N-1) $。
   - 因此，算法的空间复杂度为 $\mathcal{O}(N)$。

---

#### 方案 2：YOLO (You Only Look Once)

 **简述**
 作为一个跟进问题，我们要求在 **常数** 空间复杂度和线性时间复杂度下解决这个问题。

 在上述方案中，我们已经实现了线性时间复杂度，但空间复杂度仍是线性的。

 所以现在的问题是我们如何将 *空间复杂度* 从线性降低到常数。

 事实上，我们可以基于上述方案的描述，得出如下结论： 

 >如果我们访问所有的节点和所有的 **子节点**，那么根节点将是唯一一个我们 **只访问一次** 的节点。 其他所有的节点将被访问 **两次**。

 基于上述算法简述，我们可以将问题转化为一个等价问题：

 >给定一个数字列表，其中某些数字出现两次，我们要找到只出现一次的数字。

 ![image.png](https://pic.leetcode.cn/1691727227-cboapT-image.png){:width=400}

 每个数字对应一个节点的值。每个数字的出现对应一个节点的访问。根节点的值出现一次，而其他节点的值出现两次。

 **算法**

 同样，有几种方法可以实现上述的想法。这里，我们给出一种使用加法和减法的解决方案。像你将看到的那样，你可以用 `XOR` 运算符替换加法和减法操作。

 >这个想法是我们使用一个整数（`value_sum`）来记录节点值的和。具体地说，我们将每个节点的值加到 `value_sum` 上，并从 `value_sum` 中减去每个 **子节点** 的值。 到最后，`value_sum` 就是根节点的值。

 理由是在上述的加法和减法操作中，非根节点的值被 **抵消** 了，也就是说一个非根节点的值作为父节点被加上，但作为子节点又被减去。

 这个想法的一个重要 **_条件_** 是所有节点的值都是唯一的，这是问题中给出的。

 依然地，我们可以通过两次迭代找到根节点：

 - 在第一次迭代中，我们遍历列表中的每个节点，我们将节点的值加到 `value_sum` 上。 此外，我们还要从 `value_sum` 中减去每个子节点的值。
 - 在第一次迭代结束后，`value_sum` 将会成为根节点的值，正如我们之前讨论的那样。
 - 一旦我们知道了根节点的值，也就是 `value_sum` ，我们可以运行第二次迭代在列表中找到根节点。

**代码实现**

```Java [slu2]
class Solution {
    public Node findRoot(List<Node> tree) {

        Integer valueSum = 0;

        for (Node node : tree) {
            // 该值作为父节点添加
            valueSum += node.val;
            for (Node child : node.children)
                // 该值将作为子节点扣除
                valueSum -= child.val;
        }

        Node root = null;
        // 根节点的值是 valueSum
        for (Node node : tree) {
            if (node.val == valueSum) {
                root = node;
                break;
            }
        }
        return root;
    }
}
```

```Python3 [slu2]
""""""
# 节点的定义。
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children if children is not None else []
""""""

class Solution:
    def findRoot(self, tree: List['Node']) -> 'Node':
        value_sum = 0

        for node in tree:
            # 该值作为父节点添加
            value_sum += node.val
            for child in node.children:
                # 该值将作为子节点扣除
                value_sum -= child.val

        #  根节点的值是 valueSum
        for node in tree:
            if node.val == value_sum:
                return node
```

 这里有两个关于 `XOR` 操作符的特性：

- `A XOR A = 0`
- `0 XOR A = A`

 如你所见，这些特性可以起到和加法减法操作同样的 **抵消** 效果。

 给定一个列表 `[ABA]`，其中根节点是 `B`，我们可以对每个元素执行累计的 XOR 操作以获取根节点的值，也就是 `A XOR B XOR A = B`。

 **复杂度分析**

 设 $N$ 是输入列表的长度，也就是 N 叉树中节点的数量。

 - 时间复杂度： $\mathcal{O}(N)$
   - 在第一次迭代中，我们访问每个节点以及其子节点。  因此，这部分的时间复杂度是 $\mathcal{O}(2 * N) = \mathcal{O}(N)$。
   - 至于第二次迭代，在最坏的情况下，我们要遍历整个列表来找到根节点。因此，这部分的时间复杂度是 $\mathcal{O}(N)$。
   - 总体上，算法的时间复杂度是 $\mathcal{O}(N) + \mathcal{O}(N) = \mathcal{O}(N)$。

 - 空间复杂度： $\mathcal{O}(1)$
   - 我们使用了一个变量（`value_sum`）来存储值，这是个常数空间，不论怎样输入。

---
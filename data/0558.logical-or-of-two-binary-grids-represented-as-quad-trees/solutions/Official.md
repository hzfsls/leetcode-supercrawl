## [558.四叉树交集 中文官方题解](https://leetcode.cn/problems/logical-or-of-two-binary-grids-represented-as-quad-trees/solutions/100000/si-cha-shu-jiao-ji-by-leetcode-solution-wy1u)
#### 方法一：分治

**思路与算法**

题目给出两棵「四叉树」——$\textit{quadTree}_1$，和 $\textit{quadTree}_2$，它们分别代表一个 $n \times n$ 的矩阵，且每一个子节点都是父节点对应矩阵区域的 $\dfrac{1}{4}$ 区域：

- $\textit{topLeft}$ 节点为其父节点对应的矩阵区域左上角的 $\dfrac{1}{4}$ 区域。
- $\textit{topRight}$ 节点为其父节点对应的矩阵区域右上角的 $\dfrac{1}{4}$ 区域。
- $\textit{bottomLeft}$ 节点为其父节点对应的矩阵区域左下角的 $\dfrac{1}{4}$ 区域。
- $\textit{bottomRight}$ 节点为其父节点对应的矩阵区域右下角的 $\dfrac{1}{4}$ 区域。

我们需要把这两个矩阵中的对应位置的值进行「或」操作，然后返回操作后的矩阵即可。对于 $\forall x \in \{0,1\}$，有 $0 ~|~ x = x$ 和 $1 ~|~ x = 1$ 成立。那么我们按照两棵树的对应的节点来进行合并操作，假设当前我们操作的两个节点分别为 $\textit{node}_1$ 和 $\textit{node}_2$，记节点的合并操作为 $\textit{node}_1 ~|~ \textit{node}_2$：

1. $\textit{node}_1$ 为叶子节点时：
   - 如果 $\textit{node}_1$ 的值为 $1$，那么 $\textit{node}_1 ~|~ \textit{node}_2 = \textit{node}_1$。
   - 否则 $\textit{node}_1 ~|~ \textit{node}_2 = \textit{node}_2$。
2. $\textit{node}_2$ 为叶子节点时：
   - 如果 $\textit{node}_2$ 的值为 $1$，那么 $\textit{node}_1 ~|~ \textit{node}_2 = \textit{node}_2$。
   - 否则 $\textit{node}_1 ~|~ \textit{node}_2 = \textit{node}_1$。
3. 两者都不是叶子节点时：那么分别对两者的四个子节点来进行对应的分治处理——分别进行合并操作，然后再判断合并后的四个子节点的对应区域是否都为一个全 $0$ 或者全 $1$ 区域，如果是则原节点为叶子节点，否则原节点不是叶子节点，且四个子节点为上面合并操作后的四个对应子节点。

**代码**

```Python [sol1-Python3]
class Solution:
    def intersect(self, quadTree1: 'Node', quadTree2: 'Node') -> 'Node':
        if quadTree1.isLeaf:
            return Node(True, True) if quadTree1.val else quadTree2
        if quadTree2.isLeaf:
            return self.intersect(quadTree2, quadTree1)
        o1 = self.intersect(quadTree1.topLeft, quadTree2.topLeft)
        o2 = self.intersect(quadTree1.topRight, quadTree2.topRight)
        o3 = self.intersect(quadTree1.bottomLeft, quadTree2.bottomLeft)
        o4 = self.intersect(quadTree1.bottomRight, quadTree2.bottomRight)
        if o1.isLeaf and o2.isLeaf and o3.isLeaf and o4.isLeaf and o1.val == o2.val == o3.val == o4.val:
            return Node(o1.val, True)
        return Node(False, False, o1, o2, o3, o4)
```

```C++ [sol1-C++]
class Solution {
public:
    Node* intersect(Node* quadTree1, Node* quadTree2) {
        if (quadTree1->isLeaf) {
            if (quadTree1->val) {
                return new Node(true, true);
            }
            return new Node(quadTree2->val, quadTree2->isLeaf, quadTree2->topLeft, quadTree2->topRight, quadTree2->bottomLeft, quadTree2->bottomRight);
        }
        if (quadTree2->isLeaf) {
            return intersect(quadTree2, quadTree1);
        }
        Node* o1 = intersect(quadTree1->topLeft, quadTree2->topLeft);
        Node* o2 = intersect(quadTree1->topRight, quadTree2->topRight);
        Node* o3 = intersect(quadTree1->bottomLeft, quadTree2->bottomLeft);
        Node* o4 = intersect(quadTree1->bottomRight, quadTree2->bottomRight);
        if (o1->isLeaf && o2->isLeaf && o3->isLeaf && o4->isLeaf && o1->val == o2->val && o1->val == o3->val && o1->val == o4->val) {
            return new Node(o1->val, true);
        }
        return new Node(false, false, o1, o2, o3, o4);
    }
};
```

```Java [sol1-Java]
class Solution {
    public Node intersect(Node quadTree1, Node quadTree2) {
        if (quadTree1.isLeaf) {
            if (quadTree1.val) {
                return new Node(true, true);
            }
            return new Node(quadTree2.val, quadTree2.isLeaf, quadTree2.topLeft, quadTree2.topRight, quadTree2.bottomLeft, quadTree2.bottomRight);
        }
        if (quadTree2.isLeaf) {
            return intersect(quadTree2, quadTree1);
        }
        Node o1 = intersect(quadTree1.topLeft, quadTree2.topLeft);
        Node o2 = intersect(quadTree1.topRight, quadTree2.topRight);
        Node o3 = intersect(quadTree1.bottomLeft, quadTree2.bottomLeft);
        Node o4 = intersect(quadTree1.bottomRight, quadTree2.bottomRight);
        if (o1.isLeaf && o2.isLeaf && o3.isLeaf && o4.isLeaf && o1.val == o2.val && o1.val == o3.val && o1.val == o4.val) {
            return new Node(o1.val, true);
        }
        return new Node(false, false, o1, o2, o3, o4);
    }
}
```

```C# [sol1-C#]
public class Solution {
    public Node Intersect(Node quadTree1, Node quadTree2) {
        if (quadTree1.isLeaf) {
            if (quadTree1.val) {
                return new Node(true, true);
            }
            return new Node(quadTree2.val, quadTree2.isLeaf, quadTree2.topLeft, quadTree2.topRight, quadTree2.bottomLeft, quadTree2.bottomRight);
        }
        if (quadTree2.isLeaf) {
            return Intersect(quadTree2, quadTree1);
        }
        Node o1 = Intersect(quadTree1.topLeft, quadTree2.topLeft);
        Node o2 = Intersect(quadTree1.topRight, quadTree2.topRight);
        Node o3 = Intersect(quadTree1.bottomLeft, quadTree2.bottomLeft);
        Node o4 = Intersect(quadTree1.bottomRight, quadTree2.bottomRight);
        if (o1.isLeaf && o2.isLeaf && o3.isLeaf && o4.isLeaf && o1.val == o2.val && o1.val == o3.val && o1.val == o4.val) {
            return new Node(o1.val, true);
        }
        return new Node(false, false, o1, o2, o3, o4);
    }
}
```

```go [sol1-Golang]
func intersect(quadTree1, quadTree2 *Node) *Node {
    if quadTree1.IsLeaf {
        if quadTree1.Val {
            return &Node{Val: true, IsLeaf: true}
        }
        return quadTree2
    }
    if quadTree2.IsLeaf {
        return intersect(quadTree2, quadTree1)
    }
    o1 := intersect(quadTree1.TopLeft, quadTree2.TopLeft)
    o2 := intersect(quadTree1.TopRight, quadTree2.TopRight)
    o3 := intersect(quadTree1.BottomLeft, quadTree2.BottomLeft)
    o4 := intersect(quadTree1.BottomRight, quadTree2.BottomRight)
    if o1.IsLeaf && o2.IsLeaf && o3.IsLeaf && o4.IsLeaf && o1.Val == o2.Val && o1.Val == o3.Val && o1.Val == o4.Val {
        return &Node{Val: o1.Val, IsLeaf: true}
    }
    return &Node{false, false, o1, o2, o3, o4}
}
```

```JavaScript [sol1-JavaScript]
var intersect = function(quadTree1, quadTree2) {
    if (quadTree1.isLeaf) {
        if (quadTree1.val) {
            return new Node(true, true);
        }
        return new Node(quadTree2.val, quadTree2.isLeaf, quadTree2.topLeft, quadTree2.topRight, quadTree2.bottomLeft, quadTree2.bottomRight);
    }
    if (quadTree2.isLeaf) {
        return intersect(quadTree2, quadTree1);
    }
    const o1 = intersect(quadTree1.topLeft, quadTree2.topLeft);
    const o2 = intersect(quadTree1.topRight, quadTree2.topRight);
    const o3 = intersect(quadTree1.bottomLeft, quadTree2.bottomLeft);
    const o4 = intersect(quadTree1.bottomRight, quadTree2.bottomRight);
    if (o1.isLeaf && o2.isLeaf && o3.isLeaf && o4.isLeaf && o1.val === o2.val && o1.val === o3.val && o1.val === o4.val) {
        return new Node(o1.val, true);
    }
    return new Node(false, false, o1, o2, o3, o4);
};
```

**复杂度分析**

- 时间复杂度：$O(n^2)$，其中 $n$ 是四叉树 $\textit{quadTree}_1$ 和 $\textit{quadTree}_2$ 对应矩阵的边长。最坏的情况下，整个矩阵都会被遍历。

- 空间复杂度：$O(\log n)$，其中 $n$ 是四叉树 $\textit{quadTree}_1$ 和 $\textit{quadTree}_2$ 对应矩阵的边长。空间开销主要为递归的空间开销。
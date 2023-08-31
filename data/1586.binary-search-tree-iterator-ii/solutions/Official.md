## [1586.二叉搜索树迭代器 II 中文官方题解](https://leetcode.cn/problems/binary-search-tree-iterator-ii/solutions/100000/er-cha-sou-suo-shu-die-dai-qi-ii-by-leet-3o49)

[TOC]

## 解决方案

---

#### 概述

我们被要求实现一个迭代器，也就是说，可以用来遍历容器和访问它的元素而无需深入了解容器的实现细节。

对于迭代器，有两个标准的要求，没有影响时间复杂度的不利情况下简便地使用它们：

- 提供在常数时间（或者在_平均_常数时间）内进行 `next` 和 `prev` 操作。
- 在迭代器的初始化过程中不执行任何重的操作。

 在这里，容器对象是一个 _二叉搜索树_ (BST)。对于BST，标准的要求是按升序返回元素。也就是说，`next` 运算符返回最小的大于当前的节点。`Prev` 运算符返回最大的小于当前的节点。

 ![image.png](https://pic.leetcode.cn/1691985847-jiIZCd-image.png){:width=800}

_图1. BST迭代器. `Next`运算符返回最小的节点大于当前的节点。 `Prev`运算符返回最大的节点小于当前的节点。_

 BST 的一个基本属性是 BST 的顺序遍历是升序排列的数组。 因此，顺序遍历将是解决方案的核心。作为先决条件，你可能需要查看 [恢复二叉搜索树](https://leetcode.cn/problems/recover-binary-search-tree/solution/)， 在那里所有三种类型的顺序遍历：递归，迭代和 Morris 都进行了详细的讨论。  

---

#### 方法 1：展平二叉搜索树：递归中序遍历

 让我们从迭代器的第一个要求开始：提供在常数时间内的 `next` 和 `prev` 操作。

 为此，我们可以使用递归中序遍历扁平化二叉树，然后使用一个指针来遍历元素。

 该方法的缺点是，要初始化一个迭代器，必须遍历整棵树，这需要线性时间。  

 ![image.png](https://pic.leetcode.cn/1691986166-Kvbkrf-image.png){:width=800}

_图2.方法1.展平 BST 然后用指针来遍历。_

 **算法步骤**

- 构造函数：在迭代器初始化期间将 BST 展开到 `arr` 列表中。
    递归中序遍历很简单：
    沿 `Left->Node->Right` 方向，也就是说，对于*左*子节点做递归调用，然后对节点做所有的操作（例如，添加节点值到列表中），然后对于*右*子节点做递归调用。
- 初始化列表长度 `n` 和指针 `pointer = -1`
- `hasNext`: 比较指针和列表长度：`return pointer < n - 1`。
- `next`:将指针增加一个并返回 `arr[pointer]`。
- `hasPrev`: 比较指针和零：  `return pointer > 0`。
- `prev`: 将指针减少一个并返回 `arr[pointer]`。

 **代码实现**

 ```Java [slu1]
 class BSTIterator {

    List<Integer> arr = new ArrayList();
    int pointer;
    int n;
    
    public void inorder(TreeNode r, List<Integer> arr) {
        if (r == null) return;
        inorder(r.left, arr);
        arr.add(r.val);
        inorder(r.right, arr);
    }

    public BSTIterator(TreeNode root) {
        inorder(root, arr);
        n = arr.size();
        pointer = -1;
    }
    
    public boolean hasNext() {
        return pointer < n - 1;
    }
    
    public int next() {
        ++pointer;
        return arr.get(pointer);
    }
    
    public boolean hasPrev() {
        return pointer > 0;
    }
    
    public int prev() {
        --pointer;
        return arr.get(pointer);
    }
}
 ```

 ```Python3 [slu1]
 class BSTIterator:

    def __init__(self, root: TreeNode):
        def inorder(r):
            return inorder(r.left) + [r.val] + inorder(r.right) if r else []
        self.arr = inorder(root)
        self.n = len(self.arr)
        self.pointer = -1

    def hasNext(self) -> bool:
        return self.pointer < self.n - 1

    def next(self) -> int:
        self.pointer += 1
        return self.arr[self.pointer]

    def hasPrev(self) -> bool:
        return self.pointer > 0

    def prev(self) -> int:
        self.pointer -= 1
        return self.arr[self.pointer]
 ```

 **复杂度分析**

 * 时间复杂度: 对于迭代器构造函数为 $\mathcal{O}(N)$， 对于`hasNext`, `next`, `hasPrev`, 和 `prev`为 $\mathcal{O}(1)$ 。

 * 空间复杂度: 为 $\mathcal{O}(N)$ 来存储列表 `arr`，包含 $N$ 元素。  

---

 #### 方法 2：追踪：迭代中序遍历

 方法 1 的一大缺点就是迭代器构造函数需要线性时间。对于许多实际应用，必须在常数时间内完成初始化。  

 所以，思想是在迭代器初始化过程中尽可能的少做事情，并且在每个 `next` 调用时分析最小的数据量。

 这个最小值在最坏情况下是最后一个节点的完全左子树。

 因为我们需要停止并在任何时间重启树的遍历， 我们可以在这里使用 _迭代中序遍历_。

 ![image.png](https://pic.leetcode.cn/1691986670-cmwzws-image.png){:width=600}

 _图3.最坏的情况：在 `next` 调用期间必须解析最后一个处理过的节点的左子树。_

 这使得 `next` 调用的时间复杂度为 $\mathcal{O}(N)$，因为在最坏情况下的偏斜树需要解析整个树，所有的 $N$ 个节点。

 > 然而，这里需要注意的重要的一点就是这是最差情况的时间复杂度。
 > 我们只为我们未解析过的节点做这样的调用。 
 > 我们将所有解析过的节点保存在列表中并在需要从树的已解析部分返回 `next` 的时候重新使用他们。  

 ![image.png](https://pic.leetcode.cn/1691986763-OQdNeg-image.png){:width=600}

 _图4.平均的情况：需要返回的节点在解析的区域中。_

 因此，`next` 调用的_均摊_(平均)时间复杂度仍然是 $\mathcal{O}(1)$，这对于实际应用来说是完全可以接受的。  

 **算法步骤**

- 在 $\mathcal{O}(1)$ 中的构造函数：
  - 将最后处理的节点初始化为根节点：`last = root`。
  - 初始化一个列表用来存储已经处理过的节点：`arr`。 
  - 初始化服务数据结构 `stack`，以在迭代中序遍历期间使用。
  - 初始化指针：`pointer = -1`。该指针作为我们在已解析区域中或不在的指示器。
    如果我们在解析区域中，那么 `pointer + 1 < len(arr)`。   
- `hasNext`:
  - 如果最后一个节点不为 null，或者栈不为空，
    或者我们在已解析过的区域中，那么返回 true：`pointer + 1 < len(arr)`。
- `next`:
  - 长度增加一个指针：`pointer += 1`。
  - 如果我们在树的预计算部分，解析最小子树：最后一个节点的左子树：
    - 当最后节点不为 null，一直向左走：
      - 将最后一个节点压入栈中：`stack.append(last)`。 
      - 向左走：`last = last.left`。    
    - 将最后一个节点出栈：`curr = stack.pop()`。    
    - 将这个节点的值添加到解析节点的列表中：  `arr.append(curr.val)`。    
    - 向右走一步：`last = curr.right`。    
  - 否则，返回 `arr[pointer]`。   
- `hasPrev`:     
  - 比较指针和零：`return pointer > 0`。
- `prev`: 将指针减一并返回 `arr[pointer]`。

 **实施**

 注意，[Javadoc 推荐使用 ArrayDeque，并且不是 Stack 作为栈的实现](https://docs.oracle.com/javase/8/docs/api/java/util/ArrayDeque.html)

 ```Java [slu2]
 class BSTIterator {

    Deque<TreeNode> stack;
    List<Integer> arr;
    TreeNode last;
    int pointer;

    public BSTIterator(TreeNode root) {
        last = root;
        stack = new ArrayDeque();
        arr = new ArrayList();
        pointer = -1;
    }
    
    public boolean hasNext() {
        return !stack.isEmpty() || last != null || pointer < arr.size() - 1;
    }
    
    public int next() {
        ++pointer;
        // 如果指针超出预计算范围
        if (pointer == arr.size()) {
            // 处理最后一个节点的所有前置任务：
            // 向左走到底，然后向右走一步
            while (last != null) {
                stack.push(last);
                last = last.left;                
            }
            TreeNode curr = stack.pop();
            last = curr.right;
        
            arr.add(curr.val);
        }
            
        return arr.get(pointer);
    }
    
    public boolean hasPrev() {
        return pointer > 0;
    }
    
    public int prev() {
        --pointer;
        return arr.get(pointer);
    }
}
 ```

 ```Python3 [slu2]
 class BSTIterator:

    def __init__(self, root: TreeNode):
        self.last = root
        self.stack, self.arr = [], []
        self.pointer = -1

    def hasNext(self) -> bool:
        return self.stack or self.last or self.pointer < len(self.arr) - 1

    def next(self) -> int:
        self.pointer += 1
        
        # 如果指针超出预计算范围
        if self.pointer == len(self.arr):
            # 处理最后一个节点的所有前置任务：
            # 向左走到底，然后向右走一步
            while self.last:
                self.stack.append(self.last)
                self.last = self.last.left
            curr = self.stack.pop()
            self.last = curr.right
        
            self.arr.append(curr.val)
            
        return self.arr[self.pointer]

    def hasPrev(self) -> bool:
        return self.pointer > 0

    def prev(self) -> int:
        self.pointer -= 1
        return self.arr[self.pointer]
 ```

 **复杂度分析**

 * 时间复杂度。让我们依次看一下复杂度：
    - $\mathcal{O}(1)$ 对于构造函数。
    - $\mathcal{O}(1)$ 对于 `hasPrev`。
    - $\mathcal{O}(1)$ 对于 `prev`。
    - $\mathcal{O}(1)$ 对于 `hasNext`。
    - $\mathcal{O}(N)$ 对于 `next`。


    在最坏的情况下的偏斜树需要解析整个树，所有的 $N$ 个节点。
  > 然而，这里需要注意的重要的一点就是这是最差情况的时间复杂度。
  > 我们只为我们未解析过的节点做这样的相加。
  > 我们将所有解析过的节点保存在列表中，并且在需要从树的已解析部分返回的节点重新调用他们。

  因此， `next` 调用的*均摊*(平均)时间复杂度仍然是 $\mathcal{O}(1)$。

 * 空间复杂度: $\mathcal{O}(N)$。空间被 `stack` 和 `arr` 占据。
    `stack` 包含了高达 $H$ 个元素，其中 $H$ 是树的高度，`arr` 包含高达 $N$ 个元素。


---
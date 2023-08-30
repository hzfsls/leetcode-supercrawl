[TOC]

 ## 解决方案

---

 ### 概览

 在这个问题中，我们需要实现基于经典堆栈的数据结构，并在堆栈中支持 `pop` 和 `top` 方法。实现这样一个 LIFO（后进先出）的堆栈以返回和移除 **最后添加的** 元素并不困难。然而，我们还需要额外实现 `popMax` 和 `peekMax` 来返回和移除堆栈中 **最大** 的元素，这使得需求变得更复杂。

 我们可能很容易就会想到，**分别** 跟踪最后压入的元素和当前最大的元素，这样我们可以很快地找到最后或最大的元素，对于一个 `top` 或 `peekMax` 的操作。但是，主要的挑战是找出在推送顺序跟踪和值跟踪的记录中删除指定元素的有效方法。否则，我们将无法在下一次查询方法调用中找出确切的最后值或最大值。

 因此，在这个解决方案中，我们将介绍两种解决问题的方法。第一种方法利用两个平衡树同时按两种不同的顺序排列所有元素。一旦我们得到要移除的元素，我们就可以在两个平衡树中都用可接受的时间复杂度移除它。第二种方法只记住要删除的元素的ID，而不是在每次 `pop` 或 `popMax` 请求中立即删除最后或最大的元素。我们只在后面的方法调用中碰到它们时才物理删除它们。这两种基于不同思路的方法在函数以不同的方式被调用时可能有不同的性能。您应根据具体的要求或假设选择其中一种。

---

 ### 方法 1：两个平衡树

 #### 概述

 设计的主要挑战是如何分别跟踪最大元素和最后一个元素。我们可以将所有元素都复制保留在两份堆栈中，一份是按照压入顺序排列的，另一份是按照元素的值排序的。一个平衡树非常适合 **动态地** 按某种指定的顺序保持所有元素的排序。我们可以使用两个平衡树分别跟踪压入顺序和值。一旦我们需要删除在任一平衡树中的最大元素，我们也可以很容易地在另一个平衡树中定位和删除它。

 #### 算法

 如我们在概述中讨论的，我们需要分别维护两个平衡树：前者按推送顺序(`stack`)，后者按值排序(`values`)。此外，我们还需要为每个元素打上一个独特的 `id` 标签。为确保所有元素的 `id` 都不同，我们保持一个 `cnt` 计数器，一旦一个元素被推入我们的堆栈，计数器就增加一。

 对于 `push` 操作，我们需要将元素及当前 `cnt` 同时推入 `stack` 和 `values` 两个平衡树中，分别按照 `id` 和 `val` 插入元素。然后，不要忘记增加 `cnt`。

 对于 `top` 和 `peekMax`，由于 `stack` 和 `values` 分别按推送顺序和元素值排序，我们只需要分别返回 `stack` 的最后一个元素值和 `values` 的最后一个元素值即可。

 对于 `pop` 和 `popMax`，除了我们之前所做的之外，我们还在两个平衡树中都找到并移除了返回的元素。对于 `pop`，我们先在 `stack` 中移除最后一个元素，然后在 `values` 中移除元素；对于 `popMax`，我们先在 `values` 中移除最后一个元素，然后在 `stack` 中移除元素。

 例如，让我们来看一下第 1 个例子中的输入：

 ``` 
["MaxStack", "push", "push", "push", "top", "popMax", "top", "peekMax", "pop", "top"]
[[], [5], [1], [5], [], [], [], [], [], []]
 ```

 在前三个 `push` 调用之后，我们的 `stack` 和 `values` 排序如下：

 ``` 
stack = [(id:0, val:5), (id:1, val:1), (id:2, val:5)] 
values = [(id:1, val:1), (id:0, val:5), (id:2, val:5)] 
 ```

 然后，`top` 返回 `stack` 中的最后一个元素，其值为 5；

 `popMax` 将移除 `values` 中的最后一个元素，`(id:2, val:5)`，在 `stack` 和 `values` 中都移除。所以在 `popMax` 返回 `5` 之后，两个平衡树是：

 ``` 
stack = [(id:0, val:5), (id:1, val:1)] 
values = [(id:1, val:1), (id:0, val:5)] 
 ```

 然后，`top` 返回 `stack` 中的最后一个元素，其值为 `1`；类似地，接下来的 `peekMax` 返回 `values` 中的最后一个元素，其值为 `5`。
 在调用 `pop` 后，我们移除 `(id:1, val:1)` 并返回值 `5`，所以：

 ```
stack = [(id:0, val:5)]
values = [(id:0, val:5)] 
 ```

 最后，最后一次调用的 `top` 给出了唯一的元素 `(id:0, val:5)`，其值为 `5`。

 #### 代码实现

 ```C++ [slu1]
class MaxStack {
private:
    set<pair<int, int>> stack;
    set<pair<int, int>> values;
    int cnt;

public:
    MaxStack() { cnt = 0; }

    void push(int x) {
        stack.insert({cnt, x});
        values.insert({x, cnt});
        cnt++;
    }

    int pop() {
        pair<int, int> p = *stack.rbegin();
        stack.erase(p);
        values.erase({p.second, p.first});
        return p.second;
    }

    int top() { return stack.rbegin()->second; }

    int peekMax() { return values.rbegin()->first; }

    int popMax() {
        pair<int, int> p = *values.rbegin();
        values.erase(p);
        stack.erase({p.second, p.first});
        return p.first;
    }
};
 ```

```Java [slu1]
class MaxStack {

    private TreeSet<int[]> stack;
    private TreeSet<int[]> values;
    private int cnt;

    public MaxStack() {
        Comparator<int[]> comp = (a, b) -> {
            return a[0] == b[0] ? a[1] - b[1] : a[0] - b[0];
        };
        stack = new TreeSet<>(comp);
        values = new TreeSet<>(comp);
        cnt = 0;
    }

    public void push(int x) {
        stack.add(new int[] { cnt, x });
        values.add(new int[] { x, cnt });
        cnt++;
    }

    public int pop() {
        int[] pair = stack.pollLast();
        values.remove(new int[] { pair[1], pair[0] });
        return pair[1];
    }

    public int top() {
        return stack.last()[1];
    }

    public int peekMax() {
        return values.last()[0];
    }

    public int popMax() {
        int[] pair = values.pollLast();
        stack.remove(new int[] { pair[1], pair[0] });
        return pair[0];
    }
}
```

```Python3 [slu1]
from sortedcontainers import SortedList

class MaxStack:

    def __init__(self):
        self.stack = SortedList()
        self.values = SortedList()
        self.cnt = 0

    def push(self, x: int) -> None:
        self.stack.add((self.cnt, x))
        self.values.add((x, self.cnt))
        self.cnt += 1

    def pop(self) -> int:
        idx, val = self.stack.pop()
        self.values.remove((val, idx))
        return val

    def top(self) -> int:
        return self.stack[-1][1]

    def peekMax(self) -> int:
        return self.values[-1][0]

    def popMax(self) -> int:
        val, idx = self.values.pop()
        self.stack.remove((idx, val))
        return val
```

 #### 复杂度分析

 设 $N$ 为要添加到堆栈的元素数量。

 * 时间复杂度：除初始化外，每个操作都为 $O(\log{N})$。除初始化外的所有操作都涉及到在平衡树中找到/插入/移除元素一次或两次。一般而言，它们的时间复杂度的上界是 $O(\log{N})$ 。然而，注意到 `top` 和 `peekMax` 操作只需要在平衡树中的最后一个元素，可以用 C++ 的 `set::rbegin()` 在 $O(1)$ 内完成一些特殊的处理，Python 的 `SortedList` 对最后一个元素也有一些特殊的处理。但是 Java 的 `TreeSet` 的 `last` 还没有实现类似的优化，我们必须在 $O(\log{N})$ 中获取最后一个元素。
 * 空间复杂度：$O(N)$，即两个平衡树的最大大小。

---

 ### 方法 2：堆与延迟更新

 #### 概述

 要快速查看或弹出最大元素，我们可能会想到一个堆（或优先队列）。同时，一个经典的堆栈足以快速查看或弹出最后添加的元素。如果我们同时保持两种数据结构呢？

 是的，我们可以快速弹出最大或最后一个元素。然而，当我们弹出堆或栈的顶部元素时，我们不知道如何找到在其他元素中删除的元素，除非我们从顶部到底部列举出所有项。

 因此，我们不急于删除弹出的元素。相反，我们只记下这个元素的 ID。下次，当我们准备查看或弹出堆或栈的顶部时，我们首先检查它的 ID 是否已经从其他数据结构中删除。

 #### 算法

 为了记住所有被删除元素的 ID，我们使用一个哈希集 `removed` 来存储它们。除了我们提到的堆栈(`stack`)和最大堆(`heap`)，我们还需要一个像方法一一样的计数器 `cnt` 来给每个元素打一个独特的 ID。

 每当 `push(x)` 被调用时，我们将它连同当前的计数器值一起添加到 `heap` 和 `stack` 中，然后将我们的 `cnt` 加 1。

 每当我们被请求操作 `stack` 或 `heap`（即，`top`，`pop`，`peekMax` 和 `popMax`），我们首先检查其顶部元素的 ID，如果它恰好是 `removed` 中的一个 ID，即它已经被删除，我们需要 **移除当前的顶部元素，直到其 ID 不在 `removed` 中**，以确保顶部仍然存在。之后，

 - 对于 `top`，返回 `stack` 顶部元素的值。 
 - 对于 `peekMax`，返回 `heap` 顶部元素的值。
 - 对于 `pop`，移除 `stack` 的顶部元素，将其 ID 加入 `removed`，并返回其值。
 - 对于 `popMax`，移除 `heap` 的顶部元素，将其 ID 加入 `removed`，并返回其值。

 我们可以观察到，我们只检查顶部元素的存在，并且只在顶部元素是顶部时移除元素，因为对堆栈或堆的顶部元素的删除操作要快得多。

 #### 代码实现

 ```C++ [slu2]
class MaxStack {
private:
    stack<pair<int, int>> stk;
    priority_queue<pair<int, int>> heap;
    unordered_set<int> removed;
    int cnt;

public:
    MaxStack() { cnt = 0; }

    void push(int x) {
        stk.push({x, cnt});
        heap.push({x, cnt});
        cnt++;
    }

    int pop() {
        while (removed.count(stk.top().second)) {
            stk.pop();
        }
        const pair<int, int> p = stk.top();
        stk.pop();
        removed.insert(p.second);
        return p.first;
    }

    int top() {
        while (removed.count(stk.top().second)) {
            stk.pop();
        }
        return stk.top().first;
    }

    int peekMax() {
        while (removed.count(heap.top().second)) {
            heap.pop();
        }
        return heap.top().first;
    }

    int popMax() {
        while (removed.count(heap.top().second)) {
            heap.pop();
        }
        const pair<int, int> p = heap.top();
        heap.pop();
        removed.insert(p.second);
        return p.first;
    }
};
 ```

```Java [slu2]
class MaxStack {
    private Stack<int[]> stack;
    private Queue<int[]> heap;
    private Set<Integer> removed;
    private int cnt;

    public MaxStack() {
        stack = new Stack<>();
        heap = new PriorityQueue<>((a, b) -> b[0] - a[0] == 0 ? b[1] - a[1] : b[0] - a[0]);
        removed = new HashSet<>();
    }

    public void push(int x) {
        stack.add(new int[] { x, cnt });
        heap.add(new int[] { x, cnt });
        cnt++;
    }

    public int pop() {
        while (removed.contains(stack.peek()[1])) {
            stack.pop();
        }
        int[] top = stack.pop();
        removed.add(top[1]);
        return top[0];
    }

    public int top() {
        while (removed.contains(stack.peek()[1])) {
            stack.pop();
        }
        return stack.peek()[0];
    }

    public int peekMax() {
        while (removed.contains(heap.peek()[1])) {
            heap.poll();
        }
        return heap.peek()[0];

    }

    public int popMax() {
        while (removed.contains(heap.peek()[1])) {
            heap.poll();
        }
        int[] top = heap.poll();
        removed.add(top[1]);
        return top[0];
    }
}
```

```Python3 [slu2]
import heapq


class MaxStack:

    def __init__(self):
        self.heap = []
        self.cnt = 0
        self.stack = []
        self.removed = set()

    def push(self, x: int) -> None:
        heapq.heappush(self.heap, (-x, -self.cnt))
        self.stack.append((x, self.cnt))
        self.cnt += 1

    def pop(self) -> int:-
        while self.stack and self.stack[-1][1] in self.removed:
            self.stack.pop()
        num, idx = self.stack.pop()
        self.removed.add(idx)
        return num

    def top(self) -> int:
        while self.stack and self.stack[-1][1] in self.removed:
            self.stack.pop()
        return self.stack[-1][0]

    def peekMax(self) -> int:
        while self.heap and -self.heap[0][1] in self.removed:
            heapq.heappop(self.heap)
        return -self.heap[0][0]

    def popMax(self) -> int:
        while self.heap and -self.heap[0][1] in self.removed:
            heapq.heappop(self.heap)
        num, idx = heapq.heappop(self.heap)
        self.removed.add(-idx)
        return -num
```


 #### 复杂度分析

 设 $N$ 为要添加到堆栈的元素数量。

 * 时间复杂度：   
    - `push`： $O(\log{N})$，将元素添加到 `heap` 需要 $O(\log{N})$，将元素添加到 `stack` 需要 $O(1)$。
    -  由于单个 `pop`/`popMax` 调用导致的操作的**摊销**时间复杂度为 $O(\log{N})$。对于一个 `pop` 调用，我们首先在 `stack` 中移除最后一个元素并将其 ID 加入 `removed`，可以在 $O(1)$ 内完成，并且在未来（当 `peekMax` 或 `popMax` 被调用时）会在 `heap` 中删除顶部元素，这需要 $\log{N}$ 的时间复杂度。类似地，`popMax` 立即需要 $O(\log{N})$，以及在后续操作中需要 $O(1)$。请注意，因为我们对两个数据结构进行了懒惰更新，未来的操作在某些情况下可能永远不会发生。但即使在最坏的情况下，摊销时间复杂度的上限仍然只有 $O(\log{N})$。  
    -  `top`：$O(1)$，不包括我们上面讨论的与 `popMax` 调用相关的时间成本。  
    -  `peekMax`：$O(\log{N})$，不包括我们上面讨论的与 `pop` 调用相关的时间成本。
 * 空间复杂度：$O(N)$，`heap`、`stack` 和 `removed` 的最大大小。
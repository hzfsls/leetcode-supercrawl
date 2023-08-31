## [251.展开二维向量 中文官方题解](https://leetcode.cn/problems/flatten-2d-vector/solutions/100000/zhan-kai-er-wei-xiang-liang-by-leetcode-92qxo)
[TOC]

## 解决方案

---

#### 概述

如果你对 Iterator 有一些了解的话，这个问题应该会相当直截了当。如果你对 Iterator 完全不了解，那么我们建议你尝试一下 [顶端迭代器](https://leetcode.cn/problems/peeking-iterator/)。

请注意，这个问题提到了一个叫做 `Vector` 的东西。`Vector` 只是 `Array`（数组）的另一个名称。为了与问题保持一致，我们选择在这篇文章中使用 `Vector`，而不是 `Array`（对此可能造成的混淆，对 C++ 程序员表示歉意）。

---

#### 方法 1：在构造函数中展开列表

 **概述**
 _**这个方法是一个糟糕的方法！** 我们提到它，是为了展示它长什么样，以及为什么它是糟糕的。这有助于你设计出 **优良** 的 Iterator。_
 在构造函数中，我们可以迭代 2D 输入向量，将每个整数放入一个 `List`。然后，问题简化为一个简单的 `List` Iterator。请注意，我们使用 `List` 而不是 array（向量）的原因是我们提前不知道可能有多少个整数。
 我们的分步算法如下。

```text
nums = a new List
for each innerVector in the input 2D Vector:
    for each number in innerVector:
        append number to the end of nums
```

 然后我们需要将这个 `List` 保存为我们的 Iterator 类的一个字段，因为 `next(...)` 和 `hasNext(...)` 方法需要多次访问它。通过再添加一个位置字段，我们可以跟踪 Iterator 的进度。

 **算法**

 这里显示的代码使得 `position` 字段指向需要被 `next` 返回的 _下一个元素_。因此，`hasNext()` 方法只需要检查 `position` 是否是 `nums` 的有效索引。类似的变体是让 `position` 指向返回的 _前一个_ 值。这将简化 `next()` 方法，但会让 `hasNext()` 方法变得复杂。

 ```Java [slu1]
 import java.util.NoSuchElementException;

class Vector2D {

    // 构造函数将把所有数字放入这个列表中。
    private List<Integer> nums = new ArrayList<>();
    // 跟踪迭代器的最新动态。
    private int position = 0;

    public Vector2D(int[][] v) {
        // 我们需要迭代 2D 向量，从中取出所有整数并将它们放入 nums(一个字段)中。
        for (int[] innerVector : v) {
            for (int num : innerVector) {
                nums.add(num);
            }
        }
    }

    public int next() {
        // 在 Java 中，当 next() 被调用时我们抛出了一个 NoSuchElementException 异常
        // 在越界的 Iterator 上。
        if (!hasNext()) throw new NoSuchElementException();
        // 存储我们需要返回的数字，因为我们仍然需要向前移动位置。
        int result = nums.get(position);
        // 将位置指针向前移动 1，以便为下一次调用 next 做好准备，并给出正确的 hasNext 结果。
        position++;
        return result;
    }

    public boolean hasNext() {
        // 只要位置是列表的有效索引，就会留下数字。
        return position < nums.size();
    }
}
 ```

 ```Python3 [slu1]
 class Vector2D:

    def __init__(self, v: List[List[int]]):
        # 我们需要迭代 2D 向量，从中取出所有整数并将它们放入 nums(一个字段)中。
        self.nums = []
        for inner_list in v:
            for num in inner_list:
                self.nums.append(num)
        # 我们将保持位置1落后于下一个要返回的数字。
        self.position = -1

    def next(self) -> int:
        # 向上移动到当前元素并返回它。
        self.position += 1
        return self.nums[self.position]

    def hasNext(self) -> bool:
        # 如果下一个位置是有效的数字索引，则返回 True。
        return self.position + 1 < len(self.nums)
 ```

 **复杂度分析**

 设 $N$ 是 2D 向量中的整数数量， $V$ 是内部向量的数量。

- 时间复杂度。
  - **构造函数：**$O(N + V)$。
  总的来说，我们将在 `nums` 列表中添加 $N$ 个整数。每一次添加都是 $O(1)$ 的操作。这就给出了 $O(N)$。
  需要小心的一点是，内部向量并不一定要包含整数。考虑一个测试用例 `[[], [2], [], [], []]`。对于这个测试用例，$N = 1$，因为只有一个整数。_然而_，算法必须遍历所有的空向量。检查所有向量的成本是 $O(V)$。
  因此，我们得到最终的时间复杂度为 $O(N + V)$。
  - **next():**$O(1)$。
  这种方法中的所有操作，包括获取列表中特定索引的整数，都是 $O(1)$ 的。
  - **hasNext():**$O(1)$。
  这种方法中的所有操作都是 $O(1)$ 的。
- 空间复杂度 : $O(N)$。
  我们正在创建一个新的列表，其中包含来自 2D Vector 的所有整数。注意这和时间复杂度是不同的；在 `[[], [2], [], [], []]` 的例子中，我们只存储了 `2`。我们丢弃了关于有多少个内部向量的所有信息。

**为什么这个实现是糟糕的？**

 这段代码是有效的，它在 Leetcode 上运行得很快，并且实现起来非常直接。
 然而，Iterator 的主要目的之一就是 _最小化_ 辅助空间的使用。我们应该尽可能利用现有的数据结构，只添加足够的额外空间来跟踪下一个值。在某些情况下，我们想要迭代遍历的数据结构甚至无法全部放入内存（例如文件系统）。
 在我们以上的实现中，我们可能只需要一个单独的函数 `List<Integer> getFlattenedVector(int[][] v)`，它会返回一个 `List` 整数，然后可以使用 `List` 类型自己的标准 Iterator 迭代遍历它。
 作为一条通用的规则，你应该非常谨慎地实现具有高时间复杂度的构造函数，以及 `next()` 和 `hasNext()` 方法具有非常低的时间复杂度的 Iterator。如果使用 Iterator 的代码只想要访问遍历集合的前几个元素，然后很多时间（可能还包括空间）都被浪费了！
 不难注意到，修改输入集合以任何方式都是 _糟糕_ 的设计。Iterator 只能查看，不能改变，他们被要求迭代遍历的集合。

---

#### 方法 2：双指针

 **概述**

 正如我们在上文中所说，方法 1 是糟糕的，因为它创建了一个新的数据结构，而不是简单地迭代给定的数据结构。相反，我们应该找到一个方式来一步步地遍历整数，同时跟踪我们当前在 2D 向量中的位置。每个数字的位置由 2 个索引表示；内部向量的索引，以及在其内部向量中的整数的索引。这里有一个示例 2D 向量，标记了索引。

 ![素材库_09.png](https://pic.leetcode.cn/1692167943-QmAVvt-%E7%B4%A0%E6%9D%90%E5%BA%93_09.png){:width=400}

 假设我们在以下位置：

 ![素材库_12.png](https://pic.leetcode.cn/1692169304-yKZVUC-%E7%B4%A0%E6%9D%90%E5%BA%93_12.png){:width=400}

 我们该怎么找到下一个位置呢？当前的整数后面在同一个内部向量中还有一个整数。因此，我们只需要将 `inner` 索引增加 `1`。这给出了如下图所示的下一个位置。

 ![素材库_13.png](https://pic.leetcode.cn/1692169304-sjjvPL-%E7%B4%A0%E6%9D%90%E5%BA%93_13.png){:width=400}

 现在 `inner` 已经在当前的内部向量的末尾。为了到达下一个整数，我们需要将 `outer` 增加 `1`，并将 `inner` 赋值为 `0`(因为 `0` 是新向量的第一个索引)。

 ![素材库_14.png](https://pic.leetcode.cn/1692169319-HMAEOb-%E7%B4%A0%E6%9D%90%E5%BA%93_14.png){:width=400}

 这种情况就比较棘手了，因为我们需要跳过空的向量。为了做到这一点，我们不断地增加 `outer`，直到我们找到一个不是空的内部向量（在程序中，这会是一个 `outer`，它的 `inner = 0` 是有效的）。一旦我们找到一个，我们就停止，并将 `inner` 赋值为 `0`（内部向量的第一个整数）。

 ![素材库_15.png](https://pic.leetcode.cn/1692169304-UkUvbC-%E7%B4%A0%E6%9D%90%E5%BA%93_15.png){:width=400}

 注意，当 `outer` 等于 2D 向量的长度时，这意味着没有更多的内部向量，因此也没有更多的数字。

**算法**

 在方法 1 中，我们使用了 $O(N)$ 的辅助空间并在构造函数中使用了 $O(N + V)$ 的时间。然而，在这种方法中，我们在 `hasNext()` 和 `next()` 的调用过程中逐步执行必要的工作。这就意味着，如果调用者在迭代器耗尽之前停止使用迭代器，我们就不会做任何不必要的工作。
 我们将定义一个 `advanceToNext()` 辅助方法，它检查当前的 `inner` 和 `outer` 值是否指向一个整数，如果不是，那么它会将它们向前移动，直到它们指向一个整数（如上所述）。如果 `outer == vector.length` 成立，那么该方法就结束（因为没有剩余的整数）。
 为了确保不做任何不必要的工作，_构造函数_ 不检查 `vector[0][0]` 是否指向一个整数。这是因为在输入向量的开始可能有任意数量的空的内部向量；可能需要花费到 $O(V)$ 的操作来跳过。
 `hasNext()` 和 `next()` 都以调用 `advanceToNext()` 开始，以确保 `inner` 和 `outer` 指向一个整数，**或者** `outer` 在其 "stop" 值 `outer = vector.length`。
 `next()` 返回 `vector[inner][outer]` 处的整数，然后将 `inner` 增加 `1`，以便下一次调用 `advanceToNext()` 会从我们刚刚返回的整数之后开始搜索。
 需要注意的是，调用 `hasNext()` 方法只会在它们不指向整数时使指针移动。一旦它们指向一个整数，多次调用 `hasNext()` 就不会移动它们。只有 `next()` 能够将它们从有效的整数上移开。这种设计保证了客户端代码多次调用 `hasNext()` 不会有不寻常的副作用。

 ```Java [slu2]
 import java.util.NoSuchElementException;

class Vector2D {

    private int[][] vector;
    private int inner = 0;
    private int outer = 0;

    public Vector2D(int[][] v) {
        // 我们需要存储对输入向量的引用。
        vector = v;
    }

    // 如果当前 outer 和 internal 指向一个整数，则此方法不执行任何操作。
    // 否则，内部和外部将向前推进，直到它们指向一个整数。
    // 如果没有更多的整数，则当此方法终止时，outer 将等于 vector.length。
    private void advanceToNext() {
        // 虽然 outer 仍然在向量内，但 internal 位于 outer 指向的 internal 列表的末尾，
        // 我们希望向前移动到下一个 internal 向量的起点。
        while (outer < vector.length && inner == vector[outer].length) {
            inner = 0;
            outer++;
        }
    }

    public int next() {
        // 根据 Java 规范，如果没有 next，则抛出异常。
        // 这还将确保指针指向其他整数。
        if (!hasNext()) throw new NoSuchElementException();
        // 返回当前元素并向内移动，使其位于当前元素之后。
        return vector[outer][inner++];
    }

    public boolean hasNext() {
        // 确保移动位置指针以使其指向整数，
        // 或者让 outer = vector.length.
        advanceToNext();
        // 如果 outer = vector.length 那么就没有剩下的整数了, 
        // 否则我们会在一个整数停下，也就是还有剩下的整数。
        return outer < vector.length;
    }
}
 ```

 ```Python [slu2]
 class Vector2D:

    def __init__(self, v: List[List[int]]):
        self.vector = v
        self.inner = 0
        self.outer = 0

    # 如果当前 outer 和 internal 指向一个整数，则此方法不执行任何操作。
    # 否则，内部和外部将向前推进，直到它们指向一个整数。
    # 如果没有更多的整数，则当此方法终止时，outer 将等于 vector.length。
    def advance_to_next(self):
        # 虽然 outer 仍然在向量内，但 internal 位于 outer 指向的 internal 列表的末尾，
        # 我们希望向前移动到下一个 internal 向量的起点。
        while self.outer < len(self.vector) and self.inner == len(self.vector[self.outer]):
            self.outer += 1
            self.inner = 0

    def next(self) -> int:
        # 确保移动位置指针以使其指向整数，
        # 或者让 outer = vector.length.
        self.advance_to_next()
        # 返回当前元素并向内移动，使其位于当前元素之后。
        result = self.vector[self.outer][self.inner]
        self.inner += 1
        return result


    def hasNext(self) -> bool:
        # 确保移动位置指针以使其指向整数，
        # 或者让 outer = vector.length.
        self.advance_to_next()
        # 如果 outer = vector.length 那么就没有剩下的整数了, 
        # 否则我们会在一个整数停下，也就是还有剩下的整数。
        return self.outer < len(self.vector)
 ```

 **复杂度分析**

 设 $N$ 是 2D 向量中的整数数量， $V$ 是内部向量的数量。

- 时间复杂度
  - **构造函数：**$O(1)$。
  我们只是存储了对输入向量的引用 -- 这是 $O(1)$ 的操作。
  - **advanceToNext():**$O(\dfrac{V}{N})$。
  如果迭代器完全耗尽，则所有对 `advanceToNext()` 的调用都将进行了总共 $O(N + V)$ 的操作。（就像方法 1 中一样，$V$ 来自于我们经历了所有的 $V$ 个内部向量，$N$ 来自于我们对每个整数进行了一次增量）。
  但是，因为我们进行 $N$ 次 `advanceToNext()` 操作以耗尽迭代器，所以这个操作的平摊成本就是 $\dfrac{O(N + V)}{N} = O(\dfrac{N}{N} + \dfrac{V}{N}) = O(\dfrac{V}{N})$。
  - **next() / hasNext():** $O(\dfrac{V}{N})$ 或 $O(1)$。
  这两种方法的成本依赖于它们是如何被调用的。如果我们刚从 `next()` 中获取了一个值，那么对这两种方法的下一次调用就会调用 `advanceToNext()`。在这种情况下，时间复杂度是 $O(\dfrac{V}{N})$。
  然而，如果我们调用了 `hasNext()`，那么对 `hasNext()` 的所有后续调用或对 `next()` 的下一次调用将是 $O(1)$的。这是因为 `advanceToNext()` 只会执行 $O(1)$ 的检查并立即返回。
- 空间复杂度：$O(1)$。
  我们只使用了固定的一组 $O(1)$ 的字段（记住 `vector` 是一个引用，而不是一个拷贝！）。因此，空间复杂度是 $O(1)$。
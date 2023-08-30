## 题解 

---

#### 方法：并查集 

**前言** 

这个问题涉及到实体间的关系或归属。 如果你熟悉一种叫做 **_并查集_** 的数据结构，你可能会对此产生共鸣。 实际上，这个问题是一个完美的例子，它展示了 **_并查集_** 数据结构（又称为 Disjoint-Set）的优势。 

> 并查集（又名 Disjoint-Set）是一种数据结构，它可以高效地跟踪 **_连接_** 的干涉效果。  通过并查集，我们可以快速地确定一个特定个体属于哪个群体。  此外，我们还可以通过它，快速地让两个个体以及他们所受的两个群体合并。 

顾名思义， 一般的并查集数据结构通常提供以下两个接口: 

- `find(a)`: 此函数返回个体 `a` 所属的群体 

- `union(a, b)`: 如果个体 `a` 和 `b` 分别所属的两个群体不在同一个群体中，那么该函数会合并两者。 

为了使 `union(a, b)` 函数更友好，我们可以让这个函数返回一个布尔值，以表示是否真正发生了合并。 例如， `union(a, b)` 会在 `a` 和 `b`（以及它们各自所传播的群组）合并时返回 true，当 `a` 和 `b` 已经在同一个群组里，因此不需要合并时返回 false。 

现在，假设我们已经有了上述并查集数据结构，我们可以再次过一遍这个问题，并试图使用这个数据结构来找到一个解答。 

 **算法** 

 如下所示的解决方案实际上比并查集数据结构的实现要简单得多。 

```Java [slu1]
class Solution {
    public int earliestAcq(int[][] logs, int n) {
        // 为了确保找到最早的时刻，
        // 首先，按时间顺序对事件进行排序。
        Arrays.sort(logs, new Comparator<int[]>() {
            @Override
            public int compare(int[] log1, int[] log2) {
                Integer tsp1 = new Integer(log1[0]);
                Integer tsp2 = new Integer(log2[0]);
                return tsp1.compareTo(tsp2);
            }
        });

        // 开始时，我们将每个人视为一个单独的群体
        int groupCount = n;
        UnionFind uf = new UnionFind(n);

        for (int[] log : logs) {
            int timestamp = log[0];
            int friendA = log[1];
            int friendB = log[2];
            // 我们使用这个方法合并各组。
            if (uf.union(friendA, friendB)) {
                groupCount -= 1;
            }

            // 这是所有个体相互联系的时刻
            if (groupCount == 1) {
                return timestamp;
            }
        }

        // 还剩下不止一组
        // 即不是每个人都连接
        return -1;
    }
}
```

```Python3 [slu1]
class Solution:
    def earliestAcq(self, logs: List[List[int]], n: int) -> int:
        # 为了确保找到最早的时刻
        # 首先，按时间顺序对事件进行排序
        logs.sort(key = lambda x: x[0])

        uf = UnionFind(n)
        # 开始时，我们将每个人视为一个单独的群体
        group_cnt = n

        # 我们使用这个方法合并各组
        for timestamp, friend_a, friend_b in logs:
            if uf.union(friend_a, friend_b):
                group_cnt -= 1

            # 这是所有个体相互联系的时刻
            if group_cnt == 1:
                return timestamp

        # 还剩下不止一组
        # 即不是每个人都连接
        return -1
```

  **_显而易见的是，空谈是廉价的。_** 但是，这里有一些更详细的解释来帮助你更好地理解上述代码。 

  - 为了找到最早的时刻，我们必须确保我们按照时间顺序阅读日志。由于问题描述中没有提到日志是否有序，所以我们需要先对它们 **排序**。 
  - 当日志按时间 **排序** 后，我们可以遍历它们，同时应用并查集数据结构。 
    - 对于每个日志，我们通过应用 `union(a, b)` 函数连接日志中涉及的两个个体。  
    - 每个日志都增加了个体之间的连接。如果两个个体是分开的（不相交的），连接就是 *有用的*；如果两个个体已经通过其他个体连接在一起，连接就是多余的。  
    - 最初，我们将每个个体视为一个独立的群体。随着 _有用的_ 合并操作的进行，群体的数量减少。减少到一个群体的时刻就是每个人都连通(成为朋友)的最早时刻。  

 **代码实现** 
 在上述解决方案中，我们假设并查集数据结构已经被实施。在这一节中，我们提供了一个完整的解决方案，它包含了并查集数据结构的 **_优化_** 实现。 就所谓的 _优化_ 而言，我们在 `find(a)` 接口中应用了 **路径压缩** 优化，并在 `union(a, b)` 接口中应用了 **按秩合并**。 如果你不熟悉这个数据结构，我们有一本 LB [并查集](https://leetcode.cn/leetbook/detail/disjoint-set/) 可以帮助你详细了解这个数据结构，包括这里提到的优化技术。 

```Java [slu1]
class Solution {
    public int earliestAcq(int[][] logs, int n) {

        // 首先，我们需要按时间顺序对这些事件进行排序。
        Arrays.sort(logs, new Comparator<int[]>() {
            @Override
            public int compare(int[] log1, int[] log2) {
                Integer tsp1 = new Integer(log1[0]);
                Integer tsp2 = new Integer(log2[0]);
                return tsp1.compareTo(tsp2);
            }
        });

        // 最初，我们将每个人视为一个单独的群体。
        int groupCount = n;
        UnionFind uf = new UnionFind(n);

        for (int[] log : logs) {
            int timestamp = log[0], friendA = log[1], friendB = log[2];

            // 我们使用这个方法合并各组。
            if (uf.union(friendA, friendB)) {
                groupCount -= 1;
            }

            // 这是所有个体相互联系的时刻
            if (groupCount == 1) {
                return timestamp;
            }
        }

        // 还剩下不止一组
        // 例如，不是每个人都连接
        return -1;
    }
}

class UnionFind {
    private int[] group;
    private int[] rank;

    public UnionFind(int size) {
        this.group = new int[size];
        this.rank = new int[size];
        for (int person = 0; person < size; ++person) {
            this.group[person] = person;
            this.rank[person] = 0;
        }
    }

    /** 返回该人员所属组的 id。 */
    public int find(int person) {
        if (this.group[person] != person)
            this.group[person] = this.find(this.group[person]);
        return this.group[person];
    }

    /**
     * 如果有必要合并 x 和 y 所属的两个组。
     * @return true: 如果组被合并。
     */
    public boolean union(int a, int b) {
        int groupA = this.find(a);
        int groupB = this.find(b);
        boolean isMerged = false;

        // 这两个人属于同一组。
        if (groupA == groupB)
            return isMerged;

        // 否则，合并两个组。
        isMerged = true;
        // 将低级别组合并到高级别组中。
        if (this.rank[groupA] > this.rank[groupB]) {
            this.group[groupB] = groupA;
        } else if (this.rank[groupA] < this.rank[groupB]) {
            this.group[groupA] = groupB;
        } else {
            this.group[groupA] = groupB;
            this.rank[groupB] += 1;
        }

        return isMerged;
    }
}
```

```Python3 [slu1]
class Solution:
    def earliestAcq(self, logs: List[List[int]], n: int) -> int:
        # 首先，我们需要按时间顺序对这些事件进行排序。
        logs.sort(key = lambda x: x[0])

        uf = UnionFind(n)
        # 最初，我们将每个人视为一个单独的群体。
        group_cnt = n

        # 我们使用这个方法合并各组。
        for timestamp, friend_a, friend_b in logs:
            if uf.union(friend_a, friend_b):
                group_cnt -= 1

            # 这是所有个体相互联系的时刻。
            if group_cnt == 1:
                return timestamp

        # 还剩下不止一个群体，
        # 也就是说，不是每个人都连接在一起。
        return -1


class UnionFind:

    def __init__(self, size):
        self.group = [group_id for group_id in range(size)]
        self.rank = [0] * size

    def find(self, person):
        if self.group[person] != person:
            self.group[person] = self.find(self.group[person])
        return self.group[person]

    def union(self, a, b):
        """"""""""""""""""""""""""""""""""""""""""""""""
            return: 如果 a 和 b 之前没有连接，则为 true
                    否则，将 a 与 b 连接，然后返回 false
        """"""""""""""""""""""""""""""""""""""""""""""""
        group_a = self.find(a)
        group_b = self.find(b)
        is_merged = False
        if group_a == group_b:
            return is_merged

        is_merged = True
        # 将低级别组合并到高级别组中。
        if self.rank[group_a] > self.rank[group_b]:
            self.group[group_b] = group_a
        elif self.rank[group_a] < self.rank[group_b]:
            self.group[group_a] = group_b
        else:
            self.group[group_a] = group_b
            self.rank[group_b] += 1

        return is_merged
```

 为了更好地看懂并查集算法如何工作，我们用一个例子来展示如何使用并查集算法进行 _查找_ 和 _合并_。 

 在下表中，我们列出了按时间顺序排列的日志列表，每个条目都表示两个人成为朋友的时刻。 

 ![image.png](https://pic.leetcode.cn/1691725841-YMTqML-image.png){:width=400}

 为了直观地看出最后的关系，我们画了下面的图，其中每个节点代表一个个体，节点之间的链接表示两个个体之间的友谊关系。 此外，链接顶部的标签表示两个个体成为朋友的时刻。 

 ![image.png](https://pic.leetcode.cn/1691724973-WoWxks-image.png){:width=400}

 如你所见，在时间戳 `4` 时，每个人最终都认识了对方。 注意，`3` 和 `5` 的连接并没有为朋友之间的整体连接做出贡献。 它们是我们之前讨论的 _冗余_ 连接。 为了突出它们，我们用虚线标记了这些连接。 

 现在，根据以上的例子，我们 _一步步_ 展示我们的并查集算法是如何工作的。 

 - 最初，我们有四个群体，每个个体都是一个群体。我们用一个有向链接指向个体所属的群体。我们在下图中展示了它们。 
    ![image.png](https://pic.leetcode.cn/1691725017-sgxZUY-image.png){:width=400}
 - 从第一个事件 `(1, A, B)` 开始，我们通过 `union(A, B)` 函数将 `A` 和 `B` 的群体合并在一起。通过合并，我们将 `A` 或 `B` 的群体分配给了另一个人。  结果，合并的群体 `(A, B)` 包含两个元素。群体的总数现在减少到三个。 
    ![image.png](https://pic.leetcode.cn/1691725168-UTeDmO-image.png){:width=400}
 - 使用事件 `(2, B, C)`，我们然后将 `(A, B)` 的群体与 `(C)` 的群体合并在一起。 为了优化合并操作，我们将一个较小的群体（即秩值较小的群体）合并到一个较大的群体中。 因此，我们将 `(C)` 的群体合并进 `(A, B)` 的群体。 现在的群体总数减少到两个。**注意：** 细心的观察者会注意到 `C` 实际上应该指向 `A`，因为在按秩合并的效果，但是这里的主要点是 `C` 现在已经加入了与 `A` 和 `B` 同一个群体。为了简化，我们将 `C` 指向 `B`。 

    ![image.png](https://pic.leetcode.cn/1691725257-heIDlq-image.png){:width=400}

 - 使用事件 `(3, A, C)`，结果是，个体 `A` 和 `C` 已经属于同一个群组。 因此，不需要进行合并操作。 整体保持不变。 
    ![image.png](https://pic.leetcode.cn/1691725257-heIDlq-image.png){:width=400}

 - 最后， 使用事件 `(4, C, D)`，我们将 `(D)` 的群体合并到 `(A, B, C)` 的群体中。  总群体数减少到一个。  这就是 **最早** 的时刻，每个人都成为了朋友。


   ![image.png](https://pic.leetcode.cn/1691725171-GmNkEF-image.png){:width=400}

  **复杂性分析** 
 由于我们在我们的算法中应用了并查集数据结构，我们希望首先陈述一下数据结构的时间复杂性，如下所示： 

 >**声明**：如果 $M$ 次操作，不管是 Union 还是 Find，都应用于 $N$ 个元素，总的运行时间是 $O(M \cdot \alpha(N))$，其中 $\alpha (N)$ 是反阿克曼函数。 
 >在我们的情况下， 并查集数据结构中的元素的个数等于人的个数， 并查集数据结构上的操作的个数最多等于日志的个数。 
 >假设 $N$ 是人的数量，$M$ 是日志的数量。 

 - 时间复杂度: $O(N + M \log M + M \alpha (N))$ 
   - 首先，我们按时间戳的顺序对日志进行排序。快排的时间复杂性是 $O(M \log M)$。 
   - 然后我们创建了一个并查集数据结构，它需要 $O(N)$ 时间来初始化群体 ID 数组。 
   - 我们然后遍历排序后的日志。在每次迭代中，我们都调用 `union(a, b)` 函数。根据我们之前的声明， 整个过程的加权时间复杂性是 $O(M \alpha (N))$。 
   - 总的来说，我们的算法的整体时间复杂性是 $O(N + M \log M + M \alpha (N))$。 
 - 空间复杂度: $O(N + M)$ or $O(N + \log M)$ 
   - 我们的并查集数据结构的空间复杂度是 $O(N)$，因为我们为每个个体跟踪了群体 ID。 
   - 排序算法的空间复杂度取决于每个程序语言的实现。 
   - 例如，Python 中的 `list.sort()` 函数是用 Timsort 算法实现的，其空间复杂度是 $O(M)$。  而在 Java 中，[Arrays.sort()](https://docs.oracle.com/javase/8/docs/api/java/util/Arrays.html#sort-byte:A-) 是实现为一种快速排序算法的变体，其空间复杂度是 $O(\log{M})$。 
   - 总的来说，算法的整体空间复杂度对于 Python 是 $O(N + M)$，对于 Java 是 $O(N + \log M)$。 

---
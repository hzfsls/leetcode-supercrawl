[TOC] 

 ## 解决方案

---

 #### 方法 1：深度优先搜索 

 由于输入是嵌套的，自然会考虑以递归的方式来思考问题。我们逐个遍历嵌套整数列表，同时跟踪当前的深度 $d$。如果嵌套整数是一个整数，$n$，我们计算它的和为 $n\times d$. 如果嵌套整数是一个列表，我们递归地计算这个列表的和，但深度等于 $d + 1$。 

 **实现** 

 ```C++ [slu1]
 class Solution {
public:
    int depthSum(vector<NestedInteger>& nestedList) {
        return dfs(nestedList, 1);
    }

    int dfs(vector<NestedInteger>& list, int depth) {
        int total = 0;
        for (NestedInteger nested : list) {
            if (nested.isInteger()) {
                total += nested.getInteger() * depth;
            } else {
                total += dfs(nested.getList(), depth + 1);
            }
        }
        return total;
    }
};
 ```

 ```Java [slu1]
 class Solution {

    public int depthSum(List<NestedInteger> nestedList) {
        return dfs(nestedList, 1);
    }

    private int dfs(List<NestedInteger> list, int depth) {
        int total = 0;
        for (NestedInteger nested : list) {
            if (nested.isInteger()) {
                total += nested.getInteger() * depth;
            } else {
                total += dfs(nested.getList(), depth + 1);
            }
        }
        return total;
    }
}
 ```

 ```Python3 [slu1]
 class Solution:
    def depthSum(self, nestedList: List[NestedInteger]) -> int:

        def dfs(nested_list, depth):
            total = 0
            for nested in nested_list:
                if nested.isInteger():
                    total += nested.getInteger() * depth
                else:
                    total += dfs(nested.getList(), depth + 1)
            return total

        return dfs(nestedList, 1)

 ```

 **复杂度分析** 

 假设 $N$ 为输入列表中的嵌套元素总数。例如，列表 `[[[[1]]], 2 ]` 包含 $4$ 个嵌套列表和 $2$ 个嵌套整数（$1$ 和 $2$），因此对于这种特定情况，$N = 6$。 

 * 时间复杂度：$\mathcal{O}(N)$。
  
    递归函数的分析有时会有点棘手，特别是这些函数的实现中包含循环。一种好的策略是首先确定递归函数被调用的次数，然后计算出在*所有的递归函数调用中*，循环将迭代多少次。 

    对于每个*嵌套列表*，递归函数 `dfs(...)` 会被调用 **一次**。由于 $N$ 也包括嵌套整数，我们知道递归调用的次数必定 *小于 $N$*。 

    在每个嵌套列表中，它会遍历 **直接在该列表内部**（换句话说，没有进一步嵌套）的所有嵌套元素。每个嵌套元素只能直接在 **一个** 列表中，所以每个嵌套元素只会有一次循环迭代。这是总共 $N$ 次循环迭代。 

    所以总体来看，我们最多进行 $2 \cdot N$ 次递归调用和循环迭代。我们舍去 $2$ 作为常量，剩下的时间复杂度为 $\mathcal{O}(N)$。 

 * 空间复杂度：$\mathcal{O}(N)$。 

    在空间方面，最多需要将 $O(D)$ 个递归调用放在栈上，其中 $D$ 是输入中嵌套级别的最大值。例如，对于输入 `[[1,1],2,[1,1]]`，$D=2$，对于输入 `[1,[4,[6]]]`，$D=3$。 

    在最坏的情况下，$D = N$， （例如列表 `[[[[[[]]]]]]`） 因此最坏的空间复杂度为 $O(N)$。 

---

 #### 方法 2：广度优先搜索 

 我们也可以使用广度优先搜索来解决问题。该算法在处理完每个深度之前，将其完全处理。 

 **实现** 

 ```C++ [slu2]
 class Solution {
public:
    int depthSum(vector<NestedInteger>& nestedList) {
        queue<NestedInteger> q;
        for (NestedInteger nested : nestedList) {
            q.push(nested);
        }

        int depth = 1;
        int total = 0;

        while (!q.empty()) {
            size_t size = q.size();
            for (size_t i = 0; i < size; i++) {
                NestedInteger nested = q.front();
                q.pop();
                if (nested.isInteger()) {
                    total += nested.getInteger() * depth;
                } else {
                    for (NestedInteger nested_deeper : nested.getList()) {
                        q.push(nested_deeper);
                    }
                }
            }
            depth++;
        }
        return total;
    }
};
 ```

 ```Java [slu2]
 class Solution {
    public int depthSum(List<NestedInteger> nestedList) {
        Queue<NestedInteger> queue = new LinkedList<>();
        queue.addAll(nestedList);

        int depth = 1;
        int total = 0;

        while (!queue.isEmpty()) {
            int size = queue.size();
            for (int i = 0; i < size; i++) {
                NestedInteger nested = queue.poll();
                if (nested.isInteger()) {
                    total += nested.getInteger() * depth;
                } else {
                    queue.addAll(nested.getList());
                }
            }
            depth++;
        }
        return total;
    }
}

 ```

 ```Python3 [slu2]
 class Solution:
    def depthSum(self, nestedList: List[NestedInteger]) -> int:
        queue = deque(nestedList)

        depth = 1
        total = 0

        while len(queue) > 0:
            for i in range(len(queue)):
                nested = queue.pop()
                if nested.isInteger():
                    total += nested.getInteger() * depth
                else:
                    queue.extendleft(nested.getList())
            depth += 1

        return total
 ```

 **复杂度分析** 

 * 时间复杂度：$\mathcal{O}(N)$。 

    与 DFS 方法相似。每个嵌套元素只放入队列并从队列中移除一次。 

 * 空间复杂度：$\mathcal{O}(N)$。 

    在广度优先搜索中，空间复杂度的最坏情况发生在大部分元素都在同一层的情况下，例如，一个平面列表 `[1, 2, 3, 4, 5]`，因为所有的元素都必须同时放入队列。因此，这种方法的最坏情况的空间复杂度也为 $\mathcal{O}(N)$。
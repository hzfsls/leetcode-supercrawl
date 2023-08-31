## [364.加权嵌套序列和 II 中文官方题解](https://leetcode.cn/problems/nested-list-weight-sum-ii/solutions/100000/jia-quan-qian-tao-xu-lie-he-ii-by-leetco-32xw)
[TOC] 

 ## 解决方案 

---

 #### 概述 

 这个问题是 [嵌套列表权重和](https://leetcode.cn/problems/nested-list-weight-sum) 的扩展，我们需要找到每个整数与其 `深度` 的乘积之和。这个问题的微小变化是，我们不再将每个整数乘以其 `深度`，而是将每个整数乘以其 `权重`，`权重` 等于 `maxDepth - depth + 1`。这里的 `maxDepth` 是列表中任何 **整数** 的最大深度。 
 这里的输入是用户自定义类型 `nestedList` 的列表。这个列表中的每个 `nestedList` 元素可以是一个整数，也可以是`nestedList`元素的列表。为了进一步说明，下面的嵌套列表是一个有效的 `nestedList` 元素列表的例子。 
 在嵌套列表 `[1, 2, 3, 4, [6, 7, [8]]]` 中，前四个元素是整数，最后一个是 `nestedList` 的列表，其前两个元素是整数，最后一个元素是一个只有一个整数元素的 `nestedList`。 
 同样，我们可以通过在嵌套列表中添加 `nestedList` 来不断增加嵌套层次。 
 在我们继续之前，值得注意的两件事： 
1. 像 `[1,[2,[3,[[]]]]]` 这样的输入是无效的，因为它的 `nestedList` 是空的（即它不包含一个整数或者一个 `nestedList`）。
2. 我们将在这个问题中使用 `NestedInteger` 类。因此，我们必须使用预先定义的 `getList` 和 `getInteger` 函数来访问给定的 `nestedList` 中的数据。 


---

 #### 方法 1：两次深度优先搜索（DFS） 

 **思路**
 为了计算任何整数的权重（`maxDepth - depth + 1`），我们首先要找到给定嵌套列表的最大深度。我们怎么做呢？当我们需要处理嵌套对象时，我们应该总是考虑递归地探索嵌套对象。这种递归探索可以按深度优先或广度优先的方式进行。在这个途径中，我们将选择使用深度优先搜索。 

 > 如果你不熟悉深度优先搜索，你可以在[深度优先搜索](https://leetcode.cn/leetbook/detail/dfs/)中学习。 

所以，为了找到最大深度，我们可以迭代列表中的元素，列表的最大深度将是列表中任何元素的最大深度。如果列表只包含整数，那么它的深度是1。然而，如果列表包含其他嵌套列表，那么它的深度就是1加上这些嵌套列表的最大深度。因此，我们可以递归地调用我们的`findMaxDepth`函数在任何嵌套列表上找到最大深度。 
现在我们知道了如何找到 `maxDepth` 的值，我们可以使用[嵌套列表权重和](https://leetcode.cn/problems/nested-list-weight-sum/solution/)的启示，将 `depth` 改为 `weight`。我们对 `nestedList` 的列表中的每一个元素进行一次深度优先搜索，同时记录当前的深度 `depth` 。如果列表中的元素是一个整数，`x`，我们将其与权重的乘积 `x * (maxDepth - depth + 1)` 加到 `answer` 上。如果嵌套的整数是一个列表，我们递归地在 `nestedList` 上执行相同的过程，但深度等于 `depth + 1`。 
**算法**
1. 找到 `maxDepth` 的值。递归函数 `findMaxDepth` 遍历 `NestedInteger` 并递归地探查每个嵌套列表。当前嵌套列表的深度将是当前层的深度1加上它包含的所有嵌套列表中的最大深度。如果一个嵌套列表只包含整数，则返回1。 
2. 对列表执行另一个深度优先搜索。这次，跟踪当前的深度，并对于每一个整数，将该整数与其权重 (`maxDepth - depth + 1`) 的乘积加到 `answer` 上。 

**实现**

 ```C++ [solution]
class Solution {
public:
    int depthSumInverse(vector<NestedInteger>& nestedList) {
        int maxDepth = findMaxDepth(nestedList);
        return weightedSum(nestedList, 1, maxDepth);
    }
    
    int findMaxDepth(vector<NestedInteger>& list) {
        int maxDepth = 1;
        for (NestedInteger nested : list) {
            if (!nested.isInteger()) {
                maxDepth = max(maxDepth, 1 + findMaxDepth(nested.getList()));
            }
        }
        return maxDepth;
    }
    
    int weightedSum(vector<NestedInteger>& list, int depth, int maxDepth) {
        int answer = 0;
        for (NestedInteger nested : list) {
            if (nested.isInteger()) {
                answer += nested.getInteger() * (maxDepth - depth + 1);
            } else {
                answer += weightedSum(nested.getList(), depth + 1, maxDepth);
            }
        }
        return answer;
    }
};
 ```

```Java [solution]
class Solution {
    public int depthSumInverse(List<NestedInteger> nestedList) {
        int maxDepth = findMaxDepth(nestedList);
        return weightedSum(nestedList, 1, maxDepth);
    }

    private int findMaxDepth(List<NestedInteger> list) {
        int maxDepth = 1;
        
        for (NestedInteger nested : list) {
            if (!nested.isInteger()) {
                maxDepth = Math.max(maxDepth, 1 + findMaxDepth(nested.getList()));
            }
        }
        
        return maxDepth;
    }
    
    private int weightedSum(List<NestedInteger> list, int depth, int maxDepth) {
        int answer = 0;
        for (NestedInteger nested : list) {
            if (nested.isInteger()) {
                answer += nested.getInteger() * (maxDepth - depth + 1);
            } else {
                answer += weightedSum(nested.getList(), depth + 1, maxDepth);
            }
        }
        return answer;
    }
}
```


 **复杂度分析**
 用$N$表示输入列表中的嵌套元素总数。 
 例如，列表 `[[[[[1]]]], 2]` 包含 $4$ 个嵌套列表和 $2$ 个嵌套整数（$1$ 和 $2$），所以 $N$ 是 $6$，对于列表 `[[[[1, [2]]]], [3, [4]]]`，有 $6$ 个嵌套列表和 $4$ 个整数，所以 $N$ 是 $10$。 

 * 时间复杂度: $O(N)$ 
   我们执行两次深度优先搜索：一次是找到最大深度，另一次是得到嵌套列表的加权和。在每个DFS中，我们将只访问每个元素一次。因此时间复杂度是 $O(N)$。   

* 空间复杂度: $O(N)$ 
     空间复杂度等于深度优先搜索过程中最大的活跃堆栈调用数。在最坏的情况下，比如 `[[[[[[1]]]]]]` ，调用堆栈将使用 $O(N)$ 空间。所以空间复杂度是$O(N)$。 

---

 #### 方法 2：单次深度优先搜索（DFS） 

 **思路**
 在前面的方法中，我们执行两次 DFS。我们能不能在一次遍历中完成这个任务呢？进行两次 DFS 的原因是我们需要 `maxdepth` 来找到整数的 `weight`，所以我们必须提前找到 `maxdepth` 来计算 `weight`。如果我们能够将 `maxDepth` 从 `weight` 的定义中抽取出来，作为一个独立的项，我们就可以在一次遍历中解决问题。 
 我们需要找到 $\sum_{i=1}^{N} a_{i} * weight$ 的值，其中，$a_i$ 是列表中所有的整数，`maxDepth` 是列表中整数的最大深度，$depth_i$ 是 $a_i$ 的深度。 
  $\sum_{i=1}^{N} a_{i} * weight_{i}$  
  = $\sum_{i=1}^{N} a_{i} * (maxDepth - depth_{i} + 1)$  
  = $\sum_{i=1}^{N} (a_{i} * maxDepth - a_i * depth_{i}+ a_i)$ 
  = $\sum_{i=1}^{N} a_{i} * maxDepth$ - $\sum_{i=1}^{N} a_i * depth_{i}$ + $\sum_{i=1}^{N} a_{i}$  
  = $maxDepth * \sum_{i=1}^{N} a_{i}$ - $\sum_{i=1}^{N} a_i * depth_{i}$ + $1 * \sum_{i=1}^{N} a_{i}$ 
  = $(maxDepth + 1) * \sum_{i=1}^{N} a_{i}$ - $\sum_{i=1}^{N} a_i * depth_{i}$ 
  = $(maxDepth + 1) * sumOfElements$ - $sumOfProducts$ 
 注意，`maxDepth` 现在在求和式之外了。因此，我们不需要在计算的最后一步之前使用 `maxDepth`。因此，我们可以在执行深度优先搜索找到所有 $a_{i}$ 值(`sumOfElements`)和所有 $a_{i} * depth_{i}$ 值(`sumOfProducts`)的同时找到 `maxDepth`。 
 **算法步骤**
 1. 对 `nestedInteger` 执行 DFS。 
 2. 将整数与其 `depth` 的乘积添加到 `sumOfProducts` 中，这个和将等于 $\sum_{i=1}^{N} a_i * depth_{i}$。 
 3. 对于每一个整数，将 `depth` 与 `maxDepth` 进行比较，并对其进行更新。 
 4. 将整数加到 `sumOfElements` 中。这个和将等于 $\sum_{i=1}^{N} a_{i} $。 
 5. 返回值 `(maxDepth + 1) * sumOfElements - sumOfProducts`。 

**代码实现**

 ```C++ [solution]
class WeightedSumTriplet {
public:
    int maxDepth;
    int sumOfElements;
    int sumOfProducts;
    
    WeightedSumTriplet(int maxDepth, int sumOfElements, int sumOfProducts) {
        this->maxDepth = maxDepth;
        this->sumOfElements = sumOfElements;
        this->sumOfProducts = sumOfProducts;
    }
};

class Solution {
public:
    int depthSumInverse(vector<NestedInteger>& nestedList) {
        WeightedSumTriplet weightedSumTriplet = getWeightedSumTriplet(nestedList, 1);
        int maxDepth = weightedSumTriplet.maxDepth;
        int sumOfElements = weightedSumTriplet.sumOfElements;
        int sumOfProducts = weightedSumTriplet.sumOfProducts;
        
        return (maxDepth + 1) * sumOfElements - sumOfProducts;
    }
    
    WeightedSumTriplet getWeightedSumTriplet(vector<NestedInteger>& list, int depth) {
        int sumOfProducts = 0;
        int sumOfElements = 0;
        int maxDepth = 0;
        
        for (NestedInteger nested : list) {
            if (nested.isInteger()) {
                sumOfProducts += nested.getInteger() * depth;
                sumOfElements += nested.getInteger();
                maxDepth = max(maxDepth, depth);
            } else {
                WeightedSumTriplet result = getWeightedSumTriplet(nested.getList(), depth + 1);
                sumOfProducts += result.sumOfProducts;
                sumOfElements += result.sumOfElements;
                maxDepth = max(maxDepth, result.maxDepth);
            }
        }
        return WeightedSumTriplet(maxDepth, sumOfElements, sumOfProducts);
    }
};
 ```

```Java [solution]
class WeightedSumTriplet {
    int maxDepth;
    int sumOfElements;
    int sumOfProducts;

    WeightedSumTriplet(int maxDepth, int sumOfElements, int sumOfProducts) {
        this.maxDepth = maxDepth;
        this.sumOfElements = sumOfElements;
        this.sumOfProducts = sumOfProducts;
    }
}

class Solution {
    public int depthSumInverse(List<NestedInteger> nestedList) {
        WeightedSumTriplet weightedSumTriplet = getWeightedSumTriplet(nestedList, 1);
        int maxDepth = weightedSumTriplet.maxDepth;
        int sumOfElements = weightedSumTriplet.sumOfElements;
        int sumOfProducts = weightedSumTriplet.sumOfProducts;
        
        return (maxDepth + 1) * sumOfElements - sumOfProducts;
    }

    private WeightedSumTriplet getWeightedSumTriplet(List<NestedInteger> list, int depth) {
        int sumOfProducts = 0;
        int sumOfElements = 0;
        int maxDepth = 0;
        
        for (NestedInteger nested : list) {
            if (nested.isInteger()) {
                sumOfProducts += nested.getInteger() * depth;
                sumOfElements += nested.getInteger();
                maxDepth = Math.max(maxDepth, depth);
            } else {
                WeightedSumTriplet result = getWeightedSumTriplet(nested.getList(), depth + 1);
                sumOfProducts += result.sumOfProducts;
                sumOfElements += result.sumOfElements;
                maxDepth = Math.max(maxDepth, result.maxDepth);
            }
        }
        
        return new WeightedSumTriplet(maxDepth, sumOfElements, sumOfProducts);
    }
}
```


 **复杂度分析**
 用 $N$ 表示输入列表中的嵌套元素总数。 
 例如，列表 `[[[[[1]]]], 2]` 包含 $4$ 个嵌套列表和 $2$ 个嵌套整数（ $1$ 和 $2$ ），所以 $N$ 是 $6$，对于列表 `[[[[1, [2]]]], [3, [4]]]`，有 $6$ 个嵌套列表和 $4$ 个整数，所以 $N$ 是 $10$。 

 * 时间复杂度: $O(N)$ 
   我们只执行一次深度优先搜索。在 DFS 中，我们一次遍历嵌套列表中的每个元素（即，嵌套列表和整数）。所以时间复杂度为 $O(N)$。   
 * 空间复杂度: $O(N)$ 
   空间复杂度等于深度优先搜索过程中最大的活跃堆栈调用数。在最坏的情况下，比如 `[[[[[[1]]]]]]` ，调用堆栈将使用 $O(N)$ 空间。所以空间复杂度是 $O(N)$。 

---

 #### 方法 3：单次广度优先搜索（BFS） 

 **思路**
 在前面的方法中，我们在深度优先搜索的方式下遍历了 `nestedList` 中的所有元素。我们可以以我们想要的任何方式遍历元素，只要我们能在遍历过程中确定当前深度。在这种方法中，我们将在广度优先搜索的方式下遍历 `nestedList`。 

 > 如果你对 BFS 不熟悉，可以查看我们的 [广度优先搜索](https://leetcode.cn/leetbook/detail/lc-class-bfs/) 

我们将使用先前定义的等式 `(maxDepth + 1) * sumOfElements - sumOfProducts` 来以迭代的方式找到答案。我们将按层级对列表进行遍历，如下图所示。 

![image.png](https://pic.leetcode.cn/1692167912-eCTSZw-image.png){:width=400}

与先前的方法相似，我们将在对整数进行 BFS 时找到 `sumOfElements`，`maxDepth` 和 `sumOfProducts` 的值。 
**算法步骤**
1. 通过将输入 `nestedList` 中的所有元素添加到队列中，初始化 BFS 树的第一层。 
2. 对于每一层，从队列中弹出前面的元素。 
3. 如果它是一个列表，那么将它的元素添加到队列中。否则，更新 `sumOfElements`，`maxDepth` 和 `sumOfProducts` 的值。 
4. 当队列变空时，返回 `(maxDepth + 1) * sumOfElements - sumOfProducts` 的值。 

**代码实现**
 ```C++ [solution]
class Solution {
public:
    int depthSumInverse(vector<NestedInteger>& nestedList) {
        queue<NestedInteger> Q;
        for (NestedInteger nested : nestedList) {
            Q.push(nested);
        }

        int depth = 1;
        int maxDepth = 0;
        int sumOfElements = 0;
        int sumOfProducts = 0;

        while (!Q.empty()) {
            int size = Q.size();
            maxDepth = max(maxDepth, depth);
            
            for (int i = 0; i < size; i++) {
                NestedInteger nested = Q.front(); 
                Q.pop();
                
                if (nested.isInteger()) {
                    sumOfElements += nested.getInteger();
                    sumOfProducts += nested.getInteger() * depth;
                } else {
                    for (NestedInteger nestedNextLevel : nested.getList()) {
                        Q.push(nestedNextLevel);
                    }
                }
            }
            depth++;
        }
        return (maxDepth + 1) * sumOfElements - sumOfProducts;
    }
};
 ```

```Java [solution]
class Solution {
    public int depthSumInverse(List<NestedInteger> nestedList) {
        Queue<NestedInteger> Q = new LinkedList<>();
        Q.addAll(nestedList);

        int depth = 1;
        int maxDepth = 0;
        int sumOfElements = 0;
        int sumOfProducts = 0;

        while (!Q.isEmpty()) {
            int size = Q.size();
            maxDepth = Math.max(maxDepth, depth);
            
            for (int i = 0; i < size; i++) {
                NestedInteger nested = Q.poll();
                
                if (nested.isInteger()) {
                    sumOfElements += nested.getInteger();
                    sumOfProducts += nested.getInteger() * depth;
                } else {
                    Q.addAll(nested.getList());
                }
            }
            depth++;
        }
        return (maxDepth + 1) * sumOfElements - sumOfProducts;
    }
}
```


 **复杂度分析**
 用 $N$ 表示输入列表中的嵌套元素总数。 
 例如，列表 `[[[[[1]]]], 2]` 包含 $4$ 个嵌套列表和 $2$ 个嵌套整数（$1$ 和 $2$），所以 $N$ 是 $6$，对于列表 `[[[[1, [2]]]], [3, [4]]]`，有 $6$ 个嵌套列表和 $4$ 个整数，所以 $N$ 是 $10$。 

 * 时间复杂度: $O(N)$ 
   每个嵌套元素仅被放入队列和从队列中取出一次。 
 * 空间复杂度: $O(N)$ 
   在 BFS 中，空间复杂度的最坏情况出现在大部分元素处于同一深度的情况下，因为在那个深度的所有元素都会同时在队列中。因此，最坏情况的空间复杂度是 $O(N)$。

---
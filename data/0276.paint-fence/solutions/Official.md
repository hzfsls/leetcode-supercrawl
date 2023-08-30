[TOC]

## 解决方案

---

#### 概述

 **认识到这是一个动态规划问题**

 这个问题中有两部分表明我们可以使用动态规划来解决。

 首先，问题在问"有多少种方式"来做某事。

 其次，我们需要做出可能依赖于之前做出的决策的决定。在这个问题中，我们需要决定应该给给定的柱子涂上什么颜色，这可能会根据先前的决策而改变。例如，如果我们将前两个柱子涂上相同的颜色，那么我们就不能给第三个柱子涂上相同的颜色，这两个特征都是动态规划问题的特征。

 **解决动态规划问题的框架**

 动态规划算法通常有 3 个组成部分。学习这些组成部分非常有价值，因为 **大多数动态规划问题都可以这样解决**。

 首先，我们需要某种函数或数组来表示给定状态下问题的答案。对于这个问题，假设我们有一个函数 `totalWays`，其中 `totalWays(i)` 返回涂 `i` 个柱子的方式数量。因为我们只有一个参数，所以这是一个一维的动态规划问题。

 其次，我们需要一种在状态之间进行转换的方法，例如从 `totalWays(3)` 到 `totalWays(4)` 。这称为 **递推关系**，找出它通常是使用动态规划解决问题的最难部分。我们将在下面讨论本问题的递推关系。

 第三个组成部分是建立基本案例。如果我们有一块柱子，有 `k` 种方式可以涂色。如果我们有两个柱子，那么有 `k * k` 种方式可以涂色（因为我们可以让两个连续的柱子有相同的颜色）。因此，`totalWays(1) = k, totalWays(2) = k * k`。

 **找到递推关系**

 我们知道 `totalWays(1)` 和 `totalWays(2)` 的值，现在我们需要一个公式 `totalWays(i)`，其中 `3 <= i <= n`。让我们考虑涂第 `i` 个柱子有多少种方式。我们有两个选项：

  1. 使用与前一个柱子不同的颜色。如果我们使用不同的颜色，那么我们有 `k - 1` 种颜色可以使用。这意味着有 `(k - 1) * totalWays(i - 1)` 种方式可以将第 `i` 个柱子涂成与第 `(i - 1)` 个柱子不同的颜色。
  2. 使用与前一个柱子相同的颜色。我们只有一种颜色可以使用，所以有 `1 * totalWays(i - 1)` 种方式可以将第 `i` 个柱子涂成与第 `(i - 1)` 个柱子相同的颜色。然而，我们有不被允许将三个连续的柱子涂成相同的颜色的附加限制。因此，我们只有在第 `(i - 1)` 个柱子的颜色与第 `(i - 2)` 个柱子的颜色不同的情况下，才可以将第 `i` 个柱子的颜色涂成与第 `(i - 1)` 个柱子的颜色相同的颜色。

  那么，将第 `(i - 1)` 个柱子涂成与第 `(i - 2)` 个柱子不同的颜色有多少种方式？嗯，如在第一种选项中所述，有 `(k - 1) * totalWays(i - 1)` 种方式可以将第 `i` 个柱子涂成与第 `(i - 1)` 个柱子不同的颜色，那么这就意味着有 `1 * (k - 1) * totalWays(i - 2)` 种方式可以将第 `(i - 1)` 个柱子涂成与第 `(i - 2)` 个柱子不同的颜色。

 将这两个场景添加在一起得到 `totalWays(i) = (k - 1) * totalWays(i - 1) + (k - 1) * totalWays(i - 2)` ，这可以简化为：

 `totalWays(i) = (k - 1) * (totalWays(i - 1) + totalWays(i - 2))`

 这是我们的递推关系，我们可以从基本情况开始解决这个问题。

---

#### 方法 1：自顶向下动态规划（递归+记忆化）

 **思路**

 自顶向下的动态规划从顶部开始，然后向下工作到边界条件。通常，这是通过递归实现的，然后通过记忆化来提高效率。记忆化是指存储代价昂贵的函数调用的结果，以避免重复计算——我们很快就会看到为什么这对这个问题很重要。

 我们可以像下面这样实现函数 `totalWays(i)`  ——首先，检查上面定义的边界条件 `totalWays(1) = k, totalWays(2) = k * k`。如果 `i >= 3`，使用我们的递推关系：`totalWays(i) = (k - 1) * (totalWays(i - 1) + totalWays(i - 2))`。然而，我们会遇到一个主要问题——重复计算。如果我们调用 `totalWays(5)`，那个函数调用也会调用 `totalWays(4)` 和 `totalWays(3)`。而 `totalWays(4)` 调用则会再次调用 `totalWays(3)`，如下图所示，我们计算了两次 `totalWays(3)`。

 ![image.png](https://pic.leetcode.cn/1691995289-sJvUdF-image.png){:width=400}

 对于 `i = 5` 这样的情况，这可能看起来不是什么大问题，但是想象一下，如果我们调用 `totalWays(6)`，这整个树就会有一个子节点，我们将不得不调用两次 `totalWays(4)`。随着 `n` 的增加，树的大小呈指数增长——想象一下，像 `totalWays(50)` 这样的调用会有多昂贵。这个问题可以通过记忆化来解决。当我们计算给定的 `totalWays(i)` 的值时，让我们将那个值存储在内存中。下次我们需要调用 `totalWays(i)` 时，我们可以参考存储在内存中的值，而不是再次调用函数并进行重复的计算。

 **算法步骤**

 1. 定义一个哈希映射 `memo`，其中 `memo[i]` 表示你可以涂 `i` 个柱子的方式数。
 2. 定义一个函数 `totalWays`，其中 `totalWays(i)` 将确定你可以涂 `i` 个柱子的方式数。
 3. 在函数 `totalWays` 中，首先检查基本案例。如果 `i == 1`，则 `return k`；如果 `i == 2`，则 `return k * k`。接下来，检查是否已经计算并存储在 `memo` 中的参数 `i`。如果是，`return memo[i]`。否则，使用递推关系来计算 `memo[i]`，然后返回 `memo[i]`。
 4. 只需调用并返回 `totalWays(n)`。

 **代码实现**

 ```Java [slu1]
 class Solution {
    private HashMap<Integer, Integer> memo = new HashMap<Integer, Integer>();
    
    private int totalWays(int i, int k) {
        if (i == 1) return k;
        if (i == 2) return k * k;
        
        // 检查我们是否已经计算了 totalWays(i)
        if (memo.containsKey(i)) {
            return memo.get(i);
        }
        
        // 使用递推关系计算 totalWays(i)
        memo.put(i, (k - 1) * (totalWays(i - 1, k) + totalWays(i - 2, k)));
        return memo.get(i);
    }
    
    public int numWays(int n, int k) {
        return totalWays(n, k);
    }
}
 ```

 ```Python3 [slu1]
 class Solution:
    def numWays(self, n: int, k: int) -> int:
        def total_ways(i):
            if i == 1:
                return k
            if i == 2:
                return k * k
            
            # 检查我们是否已经计算了 totalWays(i)
            if i in memo:
                return memo[i]
            
            # 使用递推关系计算 total_ways(i)
            memo[i] = (k - 1) * (total_ways(i - 1) + total_ways(i - 2))
            return memo[i]

        memo = {}
        return total_ways(n)
 ```

 **额外的说明**

 在这种方法中，我们使用哈希映射作为数据结构来记忆函数调用。我们也可以使用数组，因为对 `totalWays` 的调用非常明确（介于 1 和 `n` 之间）。然而，大多数自顶向下的动态规划解决方案都使用哈希映射，因为通常会有多个函数参数，参数可能不是整数，或者其他需要使用哈希映射而不是数组的各种原因。尽管使用数组效率稍高，但在此处使用哈希映射是一种好的实践，可以应用到其他问题上。

 在 Python 中，[functools](https://docs.python.org/3/library/functools.html)模块包含可以用来自动记忆化函数的函数。在 LeetCode 中，模块会自动导入，所以你可以在任何函数定义上添加 `@lru_cache(None)` 包装器，让它自动记忆化。

 ```Python3 [slu2]
 class Solution:
    def numWays(self, n: int, k: int) -> int:
        @lru_cache(None)
        def total_ways(i):
            if i == 1: 
                return k
            if i == 2: 
                return k * k
            
            return (k - 1) * (total_ways(i - 1) + total_ways(i - 2))
        
        return total_ways(n)
 ```

 你可以看到，去掉 @lru_cache(None) 包装器，在尝试提交后，代码会超过时间限制。

 **复杂度分析**

* 时间复杂度: $O(n)$
  `totalWays` 使用每个从 `n` 到 `3` 的索引进行调用。由于我们的记忆化，每次调用都只需要 $O(1)$ 的时间。
* 空间复杂度: $O(n)$
  此算法使用的额外空间是递归调用栈。例如，`totalWays(50)` 将调用 `totalWays(49)`，`totalWays(49)` 调用 `totalWays(48)` 等，一直到 `totalWays(1)` 和 `totalWays(2)` 的边界条件。另外，我们的哈希映射 `memo` 在结束时大小为 `n`，因为我们用从 `n` 到 `3` 的每个索引填充了它。

---

#### 方法 2：自底向上的动态规划（表格法）

 **思路**
 自底向上的动态规划也被称为 **表格法**，是以迭代的方式完成的。与自顶向下中使用的函数不同，我们在这里使用数组 `totalWays`，其中 `totalWays[i]` 表示可以涂 `i` 个柱子的方式数量。

 顾名思义，我们现在从底部开始，然后向上计算(`n`)。初始化基本案例 `totalWays[1] = k, totalWays[2] = k * k`，然后从 `3` 迭代到 `n`，使用递推关系填充 `totalWays`。

 自底向上的算法通常被认为优于自顶向下的算法。通常，自顶向下的实现会使用更多的空间，并且所需的时间比等效的自底向上方法更长。

 **算法步骤**

 1. 定义一个长度为 `n + 1` 的数组 `totalWays`，其中 `totalWays[i]` 表示你可以涂 `i` 个柱子的方式数。初始化 `totalWays[1] = k` 和 `totalWays[2] = k * k`。
 2. 从 `3` 到 `n` 迭代，使用递推关系填充 `totalWays`：`totalWays[i] = (k - 1) * (totalWays[i - 1] + totalWays[i - 2])`。
 3. 最后，返回 `totalWays[n]`。

 **实现** 

 ```Java [slu2]
 class Solution {
    public int numWays(int n, int k) {
        // 这个问题的边界条件以避免越界问题
        if (n == 1) return k;
        if (n == 2) return k * k;
        
        int totalWays[] = new int[n + 1];
        totalWays[1] = k;
        totalWays[2] = k * k;
        
        for (int i = 3; i <= n; i++) {
            totalWays[i] = (k - 1) * (totalWays[i - 1] + totalWays[i - 2]);
        }
        
        return totalWays[n];
    }
}
 ```

```Python3 [slu2]
class Solution:
    def numWays(self, n: int, k: int) -> int:
        # 这个问题的边界条件以避免越界问题
        if n == 1:
            return k
        if n == 2:
            return k * k

        total_ways = [0] * (n + 1)
        total_ways[1] = k
        total_ways[2] = k * k
        
        for i in range(3, n + 1):
            total_ways[i] = (k - 1) * (total_ways[i - 1] + total_ways[i - 2])
        
        return total_ways[n]
```

 **复杂度分析**

* 时间复杂度: $O(n)$
  我们只从 `3` 到 `n` 迭代了一次，每次迭代都需要 $O(1)$ 的时间。

* 空间复杂度: $O(n)$
  我们需要使用数组 `totalWays`，其中 `totalWays.length` 随 `n` 线性增长。

---

#### 方法 3：自底向上，常数空间

 **思路**

 你可能已经注意到，我们之前两种方法中的递推关系只关心当前步骤下面的两步。例如，如果我们试图计算 `totalWays[11]`，我们只关心`totalWays[9]` 和 `totalWays[10]`。虽然我们也需要计算 `totalWays[3]` 至 `totalWays[8]`，但在实际计算 `totalWays[11]` 时，我们不再需要关心任何先前的步骤。
 因此，我们可以将存储数组的空间复杂度从 $O(n)$ 改进到 $O(1)$，只需要使用两个变量来存储最后两步的结果。

 **算法**

 1. 初始化两个变量，`twoPostsBack` 和 `oneBackPost`，表示涂上前两个柱子的方式数。因为我们从第三个柱子开始迭代，因此 `twoPostsBack` 最初表示涂一个柱子的方式数，`oneBackPost` 最初表示涂两个柱子的方式数，它们的值分别设为 `twoPostsBack = k, oneBackPost = k * k`，因为它们等同于我们的边界条件。
 2. 迭代 `n - 2` 次。在每次迭代时，模拟一次 `i` 的上升。使用递推关系计算当前步骤的方式数，并将其存储在变量 `curr` 中。"上升"的意思是 `twoPostsBack` 现在将指向 `oneBackPost`，所以更新 `twoPostsBack = oneBackPost`。`oneBackPost` 将指向当前的步骤，所以更新 `oneBackPost = curr`。
 3.最后，返回 `oneBackPost`，因为在最后一步后的“上升”会让 `oneBackPost` 表示涂 `n` 个柱子的方式数。

 **实现** 

 ```Java [slu3]
 class Solution {
    public int numWays(int n, int k) {
        if (n == 1) return k;
        
        int twoPostsBack = k;
        int onePostBack = k * k;
        
        for (int i = 3; i <= n; i++) {
            int curr = (k - 1) * (onePostBack + twoPostsBack);
            twoPostsBack = onePostBack;
            onePostBack = curr;
        }
        
        return onePostBack;
    }
}
 ```

 ```Python3 [slu3]
 class Solution:
    def numWays(self, n: int, k: int) -> int:
        if n == 1:
            return k
        
        two_posts_back = k
        one_post_back = k * k
        
        for i in range(3, n + 1):
            curr = (k - 1) * (one_post_back + two_posts_back)
            two_posts_back = one_post_back
            one_post_back = curr

        return one_post_back
 ```

 **复杂度分析**

* 时间复杂度: $O(n)$.  
  我们只从 `3` 到 `n` 迭代了一次，每次都做了 $O(1)$ 的工作。
* 空间复杂度: $O(1)$
  我们使用的唯一额外空间是一些整数变量，它们与输入大小无关。

---

#### 结束语

如果你对动态规划是新手，希望你从这篇文章中学到了一些东西。如果你有任何问题，请在下面的评论部分发表。为了得到额外的练习，这里提供了一些类似的动态规划问题，非常适合初学者

 [70. 爬楼梯 (简单)](https://leetcode.cn/problems/climbing-stairs/)
 [198. 打家劫舍 (中等)](https://leetcode.cn/problems/house-robber/)
 [256. 粉刷房子 (中等)](https://leetcode.cn/problems/paint-house/)
 [509. 斐波那契数 (简单)](https://leetcode.cn/problems/fibonacci-number/)
 [746. 使用最小花费爬楼梯 (简单)](https://leetcode.cn/problems/min-cost-climbing-stairs/)
 [931. 下降路径最小和 (中等)](https://leetcode.cn/problems/minimum-falling-path-sum/)

---
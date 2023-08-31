## [656.金币路径 中文官方题解](https://leetcode.cn/problems/coin-path/solutions/100000/jin-bi-lu-jing-by-leetcode-solution-jcnv)

[TOC]

## 解决方案

---

 #### 方法 1：暴力法
 在这种方法中，我们使用一组大小为 $n$ 的 $next$ 数组。这里，$n$ 指的是给定 $A$ 数组的大小。数组 $nums$ 的使用方法是，$nums[i]$ 用于存储从 $i$ 指数开始跳到数组 $A$ 的尾部所需的最小硬币数量
 我们从用 -1 填充 $next$ 数组开始。然后，为了填充这个 $next$ 数组，我们使用一个递归函数 `jump(A, B, i, next)`，该函数从指数 $i$ 开始填充 $next$ 数组，其中 $A$ 为硬币数组，$B$ 为最大跳跃值
 对于当前指数 $i$，我们可以考虑从 $i+1$ 到 $i+B$ 的每一个可能的指数作为下一个需要跳跃的地方。对于每一个这样的下一个指数，$j$，只要这个地方可以跳跃，并确定从指数 $i$ 开始到达数组尾部的成本，从 $i$ 跳跃到下一个指数 $j$ 的成本，为 $A[i] + jump(A, B, j, next)$. 如果这个成本小于所需成本，那么我们就可以更新最小成本，以及 $next[i]$ 的值。
 对于每一个类似的函数调用，我们也需要返回这个最小成本。
 最后，我们从索引1开始遍历 $next$ 数组。在每一步中，我们将当前指数添加到返回的 $res$ 列表中，并跳转到 $next[i]$ 指向的指数，因为这指向了最小成本的下一个索引。我们在数组 $A$ 的尾部继续执行相同的操作。

 ```Java [slu1]
 public class Solution {
    public List < Integer > cheapestJump(int[] A, int B) {
        int[] next = new int[A.length];
        Arrays.fill(next, -1);
        jump(A, B, 0, next);
        List < Integer > res = new ArrayList();
        int i;
        for (i = 0; i < A.length && next[i] > 0; i = next[i])
            res.add(i + 1);
        if (i == A.length - 1 && A[i]>= 0)
            res.add(A.length);
        else
            return new ArrayList < Integer > ();
        return res;
    }
    public long jump(int[] A, int B, int i, int[] next) {
        if (i == A.length - 1 && A[i] >= 0)
            return A[i];
        long min_cost = Integer.MAX_VALUE;
        for (int j = i + 1; j <= i + B && j < A.length; j++) {
            if (A[j] >= 0) {
                long cost = A[i] + jump(A, B, j, next);
                if (cost < min_cost) {
                    min_cost = cost;
                    next[i] = j;
                }
            }
        }
        return min_cost;
    }
}
 ```

 **复杂度分析**

* 时间复杂度：$O(B^n)$。在最坏的情况下，递归树的大小可以达到 $O(b^n)$。这是因为，我们在每一步都有 $B$ 可能的分支。这个地方的 $B$ 指的是最大跳跃的限制，$n$ 指的是给定的 $A$ 数组的大小。
* 空间复杂度：$O(n)$。递归树的深度可以达到 $n$。$next$ 数组的大小为 $n$。

---

 #### 方法 2：使用记忆化方法

 **算法**
 在刚刚讨论的递归解决方案中，由于我们通过多个路径考虑相同的指数，所以进行了大量的重复函数调用。为了消除这种冗余，我们可以使用记忆化方法。
 我们保持一个 $memo$ 数组，使得 $memo[i]$ 用于存储达到数组 $A$ 最后的最小跳跃成本。每次为任何指数计算一次值，它就被存储在它的适当位置。因此，下一次当做同样的函数调用时，我们可以直接从这个 $memo$ 数组中返回结果，大大减少了搜索空间。

```Java [slu2]
public class Solution {
    public List < Integer > cheapestJump(int[] A, int B) {
        int[] next = new int[A.length];
        Arrays.fill(next, -1);
        long[] memo = new long[A.length];
        jump(A, B, 0, next, memo);
        List < Integer > res = new ArrayList();
        int i;
        for (i = 0; i < A.length && next[i] > 0; i = next[i])
            res.add(i + 1);
        if (i == A.length - 1 && A[i] >= 0)
            res.add(A.length);
        else
            return new ArrayList < Integer > ();
        return res;
    }
    public long jump(int[] A, int B, int i, int[] next, long[] memo) {
        if (memo[i] > 0)
            return memo[i];
        if (i == A.length - 1 && A[i] >= 0)
            return A[i];
        long min_cost = Integer.MAX_VALUE;
        for (int j = i + 1; j <= i + B && j < A.length; j++) {
            if (A[j] >= 0) {
                long cost = A[i] + jump(A, B, j, next, memo);
                if (cost < min_cost) {
                    min_cost = cost;
                    next[i] = j;
                }
            }
        }
        memo[i] = min_cost;
        return min_cost;
    }
}
```

 **复杂度分析**

 * 时间复杂度：$O(nB)$。只填充一次 $n$ 大小的 $memo$ 数组。我们也对 $next$ 数组进行遍历，最多可以走 $B$ 步。而这里的 $n$ 是指给定树的节点数。
 * 空间复杂度：$O(n)$。递归树的深度可以达到 $n$。$next$ 数组的大小为 $n$。

---

 #### 方法 3：使用动态规划 

 在上述的解决方案中，我们可以注意到，从索引 $i$ 开始跳到数组 $A$ 的尾部的成本只依赖于索引 $i$ 之后的元素，而不依赖于之前的元素。这启示我们可以使用动态规划来解决当前问题。
 我们再次使用一个 $next$ 数组来存储下一个跳跃的位置。我们也使用一个和给定的 $A$ 数组大小相同的 $dp$ 数组。$dp[i]$ 用于存储从索引 $i$ 开始直到数组 $A$ 的尾部的最小跳跃成本。我们从最后的索引作为当前索引开始，并向后进行，以填充$next$ 和 $dp$ 数组。
 对于当前索引 $i$，我们考虑所有可能的下一位置，从 $i+1$，$i+2$，...，$i+B$，并确定位置 $j$，它导致到达 $A$ 的末尾的最小花费，这是由 $A[i]+dp[j]$ 给出的。我们用这个相应的索引更新 $next[i]$。我们也更新 $dp[i]$ 以最小化成本，以便为之前索引的成本计算使用。
 最后，我们再次跳过 $next$ 数组，并将这些索引放入返回的 $res$ 数组。

 ```Java [slu3]
 public class Solution {
    public List < Integer > cheapestJump(int[] A, int B) {
        int[] next = new int[A.length];
        long[] dp = new long[A.length];
        Arrays.fill(next, -1);
        List < Integer > res = new ArrayList();
        for (int i = A.length - 2; i >= 0; i--) {
            long min_cost = Integer.MAX_VALUE;
            for (int j = i + 1; j <= i + B && j < A.length; j++) {
                if (A[j] >= 0) {
                    long cost = A[i] + dp[j];
                    if (cost < min_cost) {
                        min_cost = cost;
                        next[i] = j;
                    }
                }
            }
            dp[i] = min_cost;
        }
        int i;
        for (i = 0; i < A.length && next[i] > 0; i = next[i])
            res.add(i + 1);
        if (i == A.length - 1 && A[i] >= 0)
            res.add(A.length);
        else
            return new ArrayList < Integer > ();
        return res;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：$O(nB)$。我们需要考虑所有可能的 $B$ 位置，对于每个索引在 $A$ 数组中。这里的 $A$ 是指在 $A$ 中的元素数目。
 * 空间复杂度：$O(n)$。$dp$ 和 $next$ 数组的大小为 $n$。
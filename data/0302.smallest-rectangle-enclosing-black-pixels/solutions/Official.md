[TOC]

## 概述

 这篇文章适合中级读者阅读。它介绍了以下概念： 深度优先搜索(DFS)，广度优先搜索(BFS) 和二分查找

## 解决方案

#### 方法 1：基础线性搜索

 **概述**
 遍历全部像素，保留黑色像素坐标的最大值和最小值。
 **算法**
 我们保持四个边界，`left`，`right`，`top` 和 `bottom` 为矩形的边界。 需要注意的是 `left` 和 `top` 是包含在内，而 `right` 和 `bottom` 是不包括在内的。然后我们遍历所有的像素并相应地更新这四个边界。
 或者按照如下步骤：

* 初始化 `left`，`right`，`top` 和 `bottom` 
* 循环遍历所有 `(x, y)` 坐标
  * 如果 `image[x][y]` 是黑色
    * `left = min(left, x)`
    * `right = max(right, x + 1)`
    * `top = min(top, y)`
    * `bottom = max(bottom, y + 1)`
* 返回 `(right - left) * (bottom - top)`

 ```Java [slu1]
 public class Solution {
    public int minArea(char[][] image, int x, int y) {
        int top = x, bottom = x;
        int left = y, right = y;
        for (x = 0; x < image.length; ++x) {
            for (y = 0; y < image[0].length; ++y) {
                if (image[x][y] == '1') {
                    top = Math.min(top, x);
                    bottom = Math.max(bottom, x + 1);
                    left = Math.min(left, y);
                    right = Math.max(right, y + 1);
                }
            }
        }
        return (right - left) * (bottom - top);
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：$O(mn)$。$m$ 和 $n$ 是图像的高度和宽度。
 * 空间复杂度：$O(1)$。我们需要存储的就是这四个边界。

**附**

* 你可能会优化这个算法以提前停止算法，但是它并不会改变近似时刻的执行性。
* 这种基础方法并不是解决这个问题的最好方法，但是它提供了一个很好的入口点来解决这个问题。大多数情况下，好的算法来自于识别一个基础操作方式的重复计算。它的好处在于可以设置时间和空间复杂度的基准，因此我们可以看出其他方法是否比它更好。

---

 #### 方法 2：DFS 或 BFS

 **概述**
 从给定的像素点开始，探究所有的连续的黑色像素，并更新边界。
 **算法步骤**
 基础的方法并没有使用所有黑色像素都连续以及给出了一个黑色像素点的条件。
 一个简单的使用这些事实的方法就是从给定的像素点开始进行深度全面的搜索。由于所有的黑色像素都是连续的, 从给定的黑色像素开始，DFS 或 BFS将访问所有的黑色像素。这个想法和 [200.岛屿的数量](https://leetcode.cn/problems/number-of-islands/) 中我们做的事情类似。和包含多个岛屿不同，这里我们只有一个岛屿，并且我们知道一个像素点的位置。

 ```Java [slu2]
 public class Solution {
    private int top, bottom, left, right;
    public int minArea(char[][] image, int x, int y) {
        if(image.length == 0 || image[0].length == 0) return 0;
        top = bottom = x;
        left = right = y;
        dfs(image, x, y);
        return (right - left) * (bottom - top);
    }
    private void dfs(char[][] image, int x, int y){
        if(x < 0 || y < 0 || x >= image.length || y >= image[0].length ||
          image[x][y] == '0')
            return;
        image[x][y] = '0'; // 将访问过的黑色像素标记为白色
        top = Math.min(top, x);
        bottom = Math.max(bottom, x + 1);
        left = Math.min(left, y);
        right = Math.max(right, y + 1);
        dfs(image, x + 1, y);
        dfs(image, x - 1, y);
        dfs(image, x, y - 1);
        dfs(image, x, y + 1);
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：$O(E) = O(B) = O(mn)$。
 这里 $E$ 是遍历图中边的数量。$B$ 是黑色像素的总数。由于每个像素最多有四个边，$O(E) = O(B)$。在最坏的情况下，$O(B) = O(mn)$。
 * 空间复杂度：$O(V) = O(B) = O(mn)$。
 空间复杂度是 $O(V)$，$V$ 是遍历图中顶点的数量。在本问题 $O(V) = O(B)$。同样，在最坏的情况下，$O(B) = O(mn)$。

 **评论**

 虽然当 $B$ 明显小于 $mn$ 的时候，这个方法比基础的方法更好，但是当 $B$ 与 $mn$ 相比的时候，它和方法 1 在近似运行时刻表现相同。并且它需要花费更多的辅助空间。

---

 #### 方法 3：二分查找

 **概述**

 将 2D 图像投影到一个 1D 数组中，然后使用二分查找找到边界。

 **算法**

 ![image.png](https://pic.leetcode.cn/1692173156-hXmYyE-image.png){:width=400}

 *图 1.图像投影展示。
 假设我们有一个 $10 \times 11$ 的图像，如图 1 所示，如果我们将图像的每一列投影到行向量 `v` 的一个条目中，和以下规则：

 * 如果存在 `x` 使 `image[x][i] = 1`，则 `v[i] = 1`
 * 否则 `v[i] = 0`

 也就是说
 > 如果一列有任何黑色像素，它的投影是黑的，否则是白的。
 >  同样，我们可以对行做同样的事情，并将图像投影到一个 1D 列向量中。这两个投影向量如图 1 所示。
 >  现在，我们声明如下引理：
 >  *引理* 
 > 如果只有一个黑色像素区域，那么在投影的 1D 数组中，所有的黑色像素都是连续的。
 >  *用反证法证明* 
 > 假设在 1D 投影数组中，`i` 和 `j` (`i < j`) 有不连续的黑色像素。因此，存在一列 `k`，`k` 在 `(i, j)` 中，而 2D 数组中的列 `k` 没有黑色像素。因此，在 2D 数组中存在至少两个黑色像素区域，它们由列 `k` 分隔，这与“只有一个黑色像素区域”的条件相矛盾。因此，我们可以得出结论，所有的 1D 投影数组中的黑色像素都是连续的。
 >  有了以上的引理，我们就有了以下的算法：

 * 将 2D 数组投影到一个列数组和一个行数组中。
 * 二分查找在 `[0, y)` 中找到 `left`。
 * 二分查找在 `[y + 1, n)` 中找到 `right`。
 * 二分查找在 `[0, x)` 中找到 `top`。
 * 二分查找在 `[x + 1, m)` 中找到 `bottom`。
 * 返回 `(right - left) * (bottom - top)`

 然而，投影步骤花费了 $O(mn)$ 的时间，从而熟的整个程序。如果是这样的话，我们就和之前的方法相比没有获得任何东西。
 诀窍是我们不需要作为预处理步骤来执行投影步骤。我们可以飞在进行，也就是说，“在需要的时候再进行列/行的投影”
 回顾一下一维数组中二分查找算法，每一次我们只检查一个元素，即拴带纲的先，来决定我们下一步走相哪半路。
 在一个 2D 数组中，我们可以做到类似的事情。唯一的区别在于元素不再是数字而是向量。例如，一个 `m` 乘 `n` 的矩阵可以看作 `n` 个列向量。
 在这 `n` 个元素/向量中，我们使用二分查找找到 `left` 和 `right`。每次我们只检查一个元素/向量，拴带纲的先，以决定我们下一步走哪半路。总的来说这种检查了 $O(\log n)$ 个向量，每次检查需要 $O(m)$ (我们只是简单地遍历 pivot 向量的 `m` 个条目)。
 因此，找到 `left` 和 `right` 需要 $O(m \log n)$。相似的，找到 `top` 和 `bottom` 需要 $O(n \log m)$。整个程序的时间复杂度是 $O(m \log n + n \log m)$

 ```Java [slu3]
 public class Solution {
    public int minArea(char[][] image, int x, int y) {
        int m = image.length, n = image[0].length;
        int left = searchColumns(image, 0, y, 0, m, true);
        int right = searchColumns(image, y + 1, n, 0, m, false);
        int top = searchRows(image, 0, x, left, right, true);
        int bottom = searchRows(image, x + 1, m, left, right, false);
        return (right - left) * (bottom - top);
    }
    private int searchColumns(char[][] image, int i, int j, int top, int bottom, boolean whiteToBlack) {
        while (i != j) {
            int k = top, mid = (i + j) / 2;
            while (k < bottom && image[k][mid] == '0') ++k;
            if (k < bottom == whiteToBlack) // k < bottom 意味着 mid 列中有黑色像素
                j = mid; //在较小的一半中搜索边界
            else
                i = mid + 1; //在较大的一半中搜索边界
        }
        return i;
    }
    private int searchRows(char[][] image, int i, int j, int left, int right, boolean whiteToBlack) {
        while (i != j) {
            int k = left, mid = (i + j) / 2;
            while (k < right && image[mid][k] == '0') ++k;
            if (k < right == whiteToBlack) // k < right means 意味着 mid 行中有黑色像素
                j = mid;
            else
                i = mid + 1;
        }
        return i;
    }
}
 ```

 **复杂度分析**

 * 时间复杂度：$O(m \log n + n \log m)$。
 这里，$m$ 和 $n$ 是图像的高度和宽度。我们在每次二分查找迭代中嵌套了一个线性搜索。查看上述部分的详细内容。
 * 空间复杂度：$O(1)$。
 二分查找和线性搜索都只使用了简单常量的额外空间。
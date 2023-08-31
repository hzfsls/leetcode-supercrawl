## [1428.至少有一个 1 的最左端列 中文官方题解](https://leetcode.cn/problems/leftmost-column-with-at-least-a-one/solutions/100000/zhi-shao-you-yi-ge-1-de-zui-zuo-duan-lie-8d4b)

[TOC]

 ## 解决方案

---

 #### 方法 1：线性搜索每一行

 **思路**

 *这个方法无法通过，但我们会用它作为启发。同时，如果你只需要一个如何使用 API 的例子，但还不想看完整的解决方案，这个方法可能会对你有所帮助！*

 最左边的 `1` 是具有最低*列*索引的 `1`。

 这个问题可以分解为找到每行中第一个 `1` 的索引，然后取这些索引的最小值。

 ![linear_search.png](https://pic.leetcode.cn/1691660820-KZuyix-linear_search.png){:width=400}

 实现这个的最简单方式就是对每一行进行线性搜索。

 **代码实现**

```Java [slu1]
class Solution {
    public int leftMostColumnWithOne(BinaryMatrix binaryMatrix) {
        int rows = binaryMatrix.dimensions().get(0);
        int cols = binaryMatrix.dimensions().get(1);
        int smallestIndex = cols;
        for (int row = 0; row < rows; row++) {
            for (int col = 0; col < cols; col++) {
                if (binaryMatrix.get(row, col) == 1) {
                    smallestIndex = Math.min(smallestIndex, col);
                    break;
                }
            }
        }
        return smallestIndex == cols ? -1 : smallestIndex;    
    }
}
```
```Python3 [slu1]
class Solution:
    def leftMostColumnWithOne(self, binaryMatrix: 'BinaryMatrix') -> int:
        rows, cols = binaryMatrix.dimensions()
        smallest_index = cols
        # 检查每一行。
        for row in range(rows):
            # 线性扫描这行的第一个 1
            for col in range(cols):
                if binaryMatrix.get(row, col) == 1:
                    smallest_index = min(smallest_index, col)
                    break
        # 如果我们找到了索引，我们应该返回它。否则，返回 -1。
        return -1 if smallest_index == cols else smallest_index
```

 **复杂度分析**

 如果你运行这段代码，你会得到下面这样的错误。

 ```text
You made too many calls to BinaryMatrix.get().
 ```

 最大的网格大小是 `100 x 100`，因此其中会包含 `10000` 个单元格。在最糟糕的情况下，我们实现的线性搜索算法需要检查每一个单元格。根据问题的描述，我们的 API 调用次数只能达到 1000 次，所以其显然无法满足要求。
 设 $N$ 是行数， $M$ 是列数。

 - 时间复杂度： $O(N \cdot M)$
   我们不知道 `binaryMatrix.get()` 的时间复杂度，因为它的实现不在我们考虑的范围内。所以我们可以默认它是 $O(1)$。     在最坏的情况下，我们需要为每个 $N \cdot M$ 的单元格获取一个值。在每项操作为 $O(1)$ 的情况下，这将总共需要花费 $O(N \cdot M)$ 的时间复杂度。
 - 空间复杂度： $O(1)$。
   我们只使用了常数的额外空间。

---

 #### 方法 2：对每行进行二分查找

 **思路**

 *这并不是最优解，但它能通过，同时编写这段代码是一个练习二分查找的好机会。*

 当线性搜索的速度慢的时候，我们应该想办法使用二分查找。如果你不熟悉二分查找，[点击这里](https://leetcode.cn/leetbook/detail/binary-search/)。我们推荐你在反馈这个问题之前先做一些二分查找的问题以熟悉这个算法。

 有一个类似于本题的一道题是 [第一个错误的版本](https://leetcode.cn/problems/first-bad-version/) 是需要你试着去做的。本题和这道题只有一个区别，那就是 `0` 和 `1`。在本题用的是 `false` 和 `true`。

 就像我们在线性搜索中做的那样，我们会在每行独立应用二分查找。我们正在搜索的 *目标元素* 是 *这一行的第一个1*。

 二分查找算法的关键是它要如何决定目标元素在中间元素的左边还是右边。我们通过考虑一些例子来确定这一点。

 在下面的行中，我们已经确定中间元素是 `0`。 目标元素（第一个 `1`）必须位于哪一侧？左侧还是右侧？别忘了，*所有的 0 都在所有的 1 之前*。

 ![image.png](https://pic.leetcode.cn/1691661217-WBnZqf-image.png){:width=400}

 在这个下一个行中，中间元素是 `1`？目标元素必须位于哪侧？ 也可能是我们刚刚发现的 `1` 吗？

 ![image.png](https://pic.leetcode.cn/1691661223-jkjcsu-image.png){:width=400}

 通过第一个例子，我们可以下结论说目标元素（ *如果* 存在的话）必须在中间元素的 **右边** 。这是因为我们知道一个 `0` 的左边一定也是 `0`。

 对于第二个例子，我们可以下结论说目标元素要么是中间元素本身，要么就在 **左边** 的某个地方。我们知道 `1` 的右边一定是 `1`， 但这些 `1` 不可能比我们刚刚发现的更靠左。

 总的来说，如果中间元素是：

 - **0** ，那么目标一定在 **右边**。

 - **1**， 那么目标不是这个元素，就在 **左边**。

然后我们可以将这些信息组合在一起形成一个算法，这个算法可以找出每行中目标元素（第一个 `1`）的索引，并返回这些索引的最小值。下面是这个算法如何进行的动画。浅灰色的数字是我们可以在不需要做 API 调用的情况下能 *推断出* 的，只有帮你理解。

<![Slide1.PNG](https://pic.leetcode.cn/1691662490-IoNdGS-Slide1.PNG){:width=400},![Slide2.PNG](https://pic.leetcode.cn/1691662495-sHswzc-Slide2.PNG){:width=400},![Slide3.PNG](https://pic.leetcode.cn/1691662499-PlEcEf-Slide3.PNG){:width=400},![Slide4.PNG](https://pic.leetcode.cn/1691662502-yESMwo-Slide4.PNG){:width=400},![Slide5.PNG](https://pic.leetcode.cn/1691662506-sEjXuT-Slide5.PNG){:width=400},![Slide6.PNG](https://pic.leetcode.cn/1691662510-UZCWeh-Slide6.PNG){:width=400},![Slide7.PNG](https://pic.leetcode.cn/1691662514-QonLjc-Slide7.PNG){:width=400},![Slide8.PNG](https://pic.leetcode.cn/1691662517-BUWhEY-Slide8.PNG){:width=400},![Slide9.PNG](https://pic.leetcode.cn/1691662520-ZbqLjC-Slide9.PNG){:width=400},![Slide10.PNG](https://pic.leetcode.cn/1691662523-abahBd-Slide10.PNG){:width=400},![Slide11.PNG](https://pic.leetcode.cn/1691662527-JHTrkB-Slide11.PNG){:width=400},![Slide12.PNG](https://pic.leetcode.cn/1691662531-TMWxzj-Slide12.PNG){:width=400},![Slide13.PNG](https://pic.leetcode.cn/1691662535-OkYadY-Slide13.PNG){:width=400},![Slide14.PNG](https://pic.leetcode.cn/1691662539-XTzuTU-Slide14.PNG){:width=400},![Slide15.PNG](https://pic.leetcode.cn/1691662543-bsPCHh-Slide15.PNG){:width=400},![Slide16.PNG](https://pic.leetcode.cn/1691662547-CSWyMB-Slide16.PNG){:width=400},![Slide17.PNG](https://pic.leetcode.cn/1691662551-UvlGcD-Slide17.PNG){:width=400},![Slide18.PNG](https://pic.leetcode.cn/1691662555-KLlDjA-Slide18.PNG){:width=400},![Slide19.PNG](https://pic.leetcode.cn/1691662559-qguthG-Slide19.PNG){:width=400},![Slide20.PNG](https://pic.leetcode.cn/1691662563-GWnLfA-Slide20.PNG){:width=400},![Slide21.PNG](https://pic.leetcode.cn/1691662567-KZeHfL-Slide21.PNG){:width=400},![Slide22.PNG](https://pic.leetcode.cn/1691662571-cyKZgS-Slide22.PNG){:width=400},![Slide23.PNG](https://pic.leetcode.cn/1691662575-JUmVUQ-Slide23.PNG){:width=400},![Slide24.PNG](https://pic.leetcode.cn/1691662579-VUsOfb-Slide24.PNG){:width=400},![Slide25.PNG](https://pic.leetcode.cn/1691662583-misUbB-Slide25.PNG){:width=400},![Slide26.PNG](https://pic.leetcode.cn/1691662587-dlTQLX-Slide26.PNG){:width=400},![Slide27.PNG](https://pic.leetcode.cn/1691662592-eLZuhT-Slide27.PNG){:width=400},![Slide28.PNG](https://pic.leetcode.cn/1691662596-coVcPW-Slide28.PNG){:width=400},![Slide29.PNG](https://pic.leetcode.cn/1691662600-oYNOhb-Slide29.PNG){:width=400},![Slide30.PNG](https://pic.leetcode.cn/1691662604-QWcLTG-Slide30.PNG){:width=400},![Slide31.PNG](https://pic.leetcode.cn/1691662609-Iuwgzj-Slide31.PNG){:width=400},![Slide32.PNG](https://pic.leetcode.cn/1691662612-VjfRtt-Slide32.PNG){:width=400},![Slide33.PNG](https://pic.leetcode.cn/1691662617-OJlxaT-Slide33.PNG){:width=400}>

 **算法**

 *如果你已经很熟悉二分查找了，可以直接跳过下面的内容*。我决定添加更多细节，因为二分查找是许多人很容易觉得困扰并且很难掌握的一种算法。
 在二分查找中，我们用两个变量 `lo` 和 `hi` 总是要跟踪目标可能存在的范围：`lo` 表示它可能存在的最低索引，`hi` 标示了它可能存在的最大索引。忽略 binaryMatrix API 的细节，下面这段伪代码大概描绘出了我们的二分查找。

 ```text
define function binary_search(input_list):
    lo = the lowest possible index
    hi = the highest possible index
    while the search space contains 2 or more items:
        mid = the middle index in the remaining search space
        if the element at input_list[mid] is 0:
            lo = mid + 1 (the first 1 is *further right*, and can't be mid itself)
        else:
            hi = mid (the first 1 is either mid itself, *or is further left*)
    return the only index remaining in the search space
 ```

如同在二分查找中一样，我们还需要处理其他几个关键的实现细节：

1. 等长的查找区间有两个中间值。我们应该选择哪一个？
2. 这一行可能全是 0。

我们一项任务一项任务对这些问题进行考虑。
对于第一个问题，中间值的选择是很重要的，因为在查找空间的搜索值变为2元素时，空间大小可能会不再缩小。当查找空间不再缩小的时候，算法在下一个循环执行相同的操作，导致了无限循环。请记住，当查找空间只剩下两个元素的时候，他们是受到 `lo` 和 `hi` 指向的。这意味着低中间值等于 `lo`，高中间值等于 `hi`。所以，我们需要想清楚哪种情况会使查找空间缩小，哪种情况不会。

如果使用 *低中间值*
 - 如果这是一个 `0` ，我们设定 `lo = mid + 1` 。因为 `hi == mid + 1`, 这意味着 `lo == hi` (查找区间为1)。 - 如果这是一个 `1` ，我们设定 `hi = mid` 。因为 `mid == lo`，这意味着 `hi == lo` (查找区间为1)。

如果使用 *高中间值*
 - 如果这是一个 `0` ，那么我们设定 `lo = mid + 1`。因为 `hi = mid`，我们现在有 `hi > lo` (查找区间为零)。 - 如果这是一个 `1`，那么我们设定 `hi = mid` 。因为 `hi == mid` 相等是已经成立的，所以查找空间还是原来的大小 (查找区间去为2)。

如果我们使用 *低中间值* ，我们知道查找空间总是会收缩。如果我们使用 *高中间值*，查找空间可能不会收缩。所以，我们应该选择 *低中间值*。公式为 `mid = (low + high) / 2`。

对于第二个问题，一行所有的都是 `0`，可以通过认识到这个算法总是会缩小查找空间到一个单一元素。这应该是第一个 `1`，但是如果那不存在，那么 *必须是* `0` 。因此，我们可以通过检查查找空间中最后一个元素是否为 `1` 来检测这种情况。
细心地思考这些细节是很好的做法，这样你就可以确定并自信的写出你的二分查找算法。抵制通过置换编程的诱惑！
无论如何，把这一切放在一起，我们可以得到下面的代码。

```Java [slu2]
class Solution {
    public int leftMostColumnWithOne(BinaryMatrix binaryMatrix) {
        int rows = binaryMatrix.dimensions().get(0);
        int cols = binaryMatrix.dimensions().get(1);
        int smallestIndex = cols;
        for (int row = 0; row < rows; row++) {
            // 在这行中二分搜索第一个 1
            int lo = 0;
            int hi = cols - 1;
            while (lo < hi) {
                int mid = (lo + hi) / 2;
                if (binaryMatrix.get(row, mid) == 0) {
                    lo = mid + 1;
                }
                else {
                    hi = mid;
                }
            }
            // 如果搜索空间中的最后一个元素是 1，则此行包含 1。
            if (binaryMatrix.get(row, lo) == 1) {
                smallestIndex = Math.min(smallestIndex, lo);
            }
        }
        // 如果 smallestIndex 仍设置为 cols，则网格中没有1。
        return smallestIndex == cols ? -1 : smallestIndex;
    }
}
```

```Python3 [slu2]
class Solution:
    def leftMostColumnWithOne(self, binaryMatrix: 'BinaryMatrix') -> int:
        rows, cols = binaryMatrix.dimensions()
        smallest_index = cols
        for row in range(rows):
            # 在这行中二分搜索第一个 1
            lo = 0
            hi = cols - 1
            while lo < hi:
                mid = (lo + hi) // 2
                if binaryMatrix.get(row, mid) == 0:
                    lo = mid + 1
                else:
                    hi = mid
            # 如果搜索空间中的最后一个元素是 1，则此行包含 1。
            if binaryMatrix.get(row, lo) == 1:
                smallest_index = min(smallest_index, lo)
        # 如果 smallestIndex 仍设置为 cols，则网格中没有1。
        return -1 if smallest_index == cols else smallest_index
```

 **复杂度分析**
 设 $N$ 是行数， $M$ 是列数。

 - 时间复杂度： $O(N \, \log \, M)$。
   每行有 $M$ 个元素。因此，每次二分查找的成本会是 $O(\log \, M)$。我们进行 $N$ 次这样的二分查找，所以时间复杂度将是 $N \cdot O(\log \, M) = O(N \, \log \, M)$。
 - 空间复杂度： $O(1)$。
   我们使用了常数的额外空间。

---

 #### 方法 3：从顶部右侧开始，只向左和向下移动

 **思路**
 你在方法 2中是否注意到我们并不需要完成所有行的搜索？一个很好的例子就是动画中的第 3 行。在下图所示的情况下，很明显第 3 行 *无法战胜我们此前发现的最小值*。

 ![image.png](https://pic.leetcode.cn/1691661443-aLrYzo-image.png){:width=400}

 因此，我们可以进行优化，用来保存到目前为止发现的最小值的索引，然后在任何我们发现一个 `0` 的行上，如果该 `0` 位于最小索引或它右边，我们就终止搜索。

 我们还可以做得更好；在每次搜搜索时，我们可以设定 `hi = smallest_index - 1`，这里的 `smallest_index` 是我们到目前为止发现的最小 `1` 的索引。在大多数情况下，这都会带来实质的改善。这个方法可以工作，因为我们只有兴趣在找到在之前的索引中更小的 `1` . 这是一个带有这个优化算法的举例。在每次 API 调用时，算法都会尽量少的查找单元格。它也会首先在进入二分查找之前，检查行的最后一个单元格，然后决定如果这一行只剩下 `0` 的话，是否需要无休止的进行二分查找。

 <![Slide1.PNG](https://pic.leetcode.cn/1691720136-LVHMhg-Slide1.PNG){:width=400},![Slide2.PNG](https://pic.leetcode.cn/1691720136-Jmkpda-Slide2.PNG){:width=400},![Slide3.PNG](https://pic.leetcode.cn/1691720136-OUBnJg-Slide3.PNG){:width=400},![Slide4.PNG](https://pic.leetcode.cn/1691720136-huoSjl-Slide4.PNG){:width=400},![Slide5.PNG](https://pic.leetcode.cn/1691720136-qbFQnt-Slide5.PNG){:width=400},![Slide6.PNG](https://pic.leetcode.cn/1691720136-eFtAvo-Slide6.PNG){:width=400},![Slide7.PNG](https://pic.leetcode.cn/1691720136-gkvSzf-Slide7.PNG){:width=400},![Slide8.PNG](https://pic.leetcode.cn/1691720136-wNXaQP-Slide8.PNG){:width=400},![Slide9.PNG](https://pic.leetcode.cn/1691720136-VjCDRD-Slide9.PNG){:width=400},![Slide10.PNG](https://pic.leetcode.cn/1691720136-YYZNGG-Slide10.PNG){:width=400},![Slide11.PNG](https://pic.leetcode.cn/1691720136-weYhet-Slide11.PNG){:width=400},![Slide12.PNG](https://pic.leetcode.cn/1691720136-RoPvda-Slide12.PNG){:width=400},![Slide13.PNG](https://pic.leetcode.cn/1691720136-GXXRjX-Slide13.PNG){:width=400},![Slide14.PNG](https://pic.leetcode.cn/1691720136-eGufEJ-Slide14.PNG){:width=400},![Slide15.PNG](https://pic.leetcode.cn/1691720136-rqkZmE-Slide15.PNG){:width=400},![Slide16.PNG](https://pic.leetcode.cn/1691720136-ktLbht-Slide16.PNG){:width=400},![Slide17.PNG](https://pic.leetcode.cn/1691720136-ycrrFC-Slide17.PNG){:width=400}>

 这是这种算法最糟糕的情况。和之前一样的，它的时间复杂度仍旧是 $O(M \, \log \, N)$。

 ![optimized_binary_search_worst_case.png](https://pic.leetcode.cn/1691663266-HtOlil-optimized_binary_search_worst_case.png){:width=400}

 虽然这并不比方法 2 差，但是还有更好的方法。

 > 从顶部的右边开始，如果当前值是 `0`，向下移动。如果是 `1`，那么向左移动。

最简单的看懂这个地方的方法就是举例。下面是它的动画。

 <![Slide1.PNG](https://pic.leetcode.cn/1691720314-gNtvUj-Slide1.PNG){:width=400},![Slide2.PNG](https://pic.leetcode.cn/1691720314-bowcOH-Slide2.PNG){:width=400},![Slide3.PNG](https://pic.leetcode.cn/1691720314-qxXmUL-Slide3.PNG){:width=400},![Slide4.PNG](https://pic.leetcode.cn/1691720314-TdEiWS-Slide4.PNG){:width=400},![Slide5.PNG](https://pic.leetcode.cn/1691720314-uUzXDB-Slide5.PNG){:width=400},![Slide6.PNG](https://pic.leetcode.cn/1691720314-IABivP-Slide6.PNG){:width=400},![Slide7.PNG](https://pic.leetcode.cn/1691720314-Vvyfyh-Slide7.PNG){:width=400},![Slide8.PNG](https://pic.leetcode.cn/1691720314-hJOEWR-Slide8.PNG){:width=400},![Slide9.PNG](https://pic.leetcode.cn/1691720314-PkLvti-Slide9.PNG){:width=400},![Slide10.PNG](https://pic.leetcode.cn/1691720314-HCakKy-Slide10.PNG){:width=400},![Slide11.PNG](https://pic.leetcode.cn/1691720314-ZdZwLx-Slide11.PNG){:width=400},![Slide12.PNG](https://pic.leetcode.cn/1691720314-LarCFX-Slide12.PNG){:width=400},![Slide13.PNG](https://pic.leetcode.cn/1691720314-uSIzOW-Slide13.PNG){:width=400},![Slide14.PNG](https://pic.leetcode.cn/1691720314-xSwsJL-Slide14.PNG){:width=400},![Slide15.PNG](https://pic.leetcode.cn/1691720314-FwgNBb-Slide15.PNG){:width=400},![Slide16.PNG](https://pic.leetcode.cn/1691720314-FcbjEB-Slide16.PNG){:width=400},![Slide17.PNG](https://pic.leetcode.cn/1691720314-NuPOxo-Slide17.PNG){:width=400}>

你可能思路上就能看出，在这个动画中为什么它能执行。
- 当我们碰到一个 `0` ，我们知道最左的 `1` 不可能在它的左边。  
- 当我们遇到一个 `1` ，我们应该在那一行继续搜索（指针向左移动），以便找到一个更小的索引 。

**算法**

```Java [slu3]
class Solution {
    public int leftMostColumnWithOne(BinaryMatrix binaryMatrix) {
        int rows = binaryMatrix.dimensions().get(0);
        int cols = binaryMatrix.dimensions().get(1);

        // 设置右上角的指针
        int currentRow = 0;
        int currentCol = cols - 1;
    
        // 重复搜索直到遍历完网格
        while (currentRow < rows && currentCol >= 0) {
            if (binaryMatrix.get(currentRow, currentCol) == 0) {
                currentRow++;
            } else {
                currentCol--; 
            }
        }
    
        // 如果我们没有离开最后一栏，这是因为它里面都是 0 。
        return (currentCol == cols - 1) ? -1 : currentCol + 1;
    }
}
```
```Python3 [slu3]
class Solution:
    def leftMostColumnWithOne(self, binaryMatrix: 'BinaryMatrix') -> int:
        
        rows, cols = binaryMatrix.dimensions()
        
        # 设置右上角的指针
        current_row = 0
        current_col = cols - 1
        
        # 重复搜索直到遍历完网格
        while current_row < rows and current_col >= 0:
            if binaryMatrix.get(current_row, current_col) == 0:
                current_row += 1
            else:
                current_col -= 1
        
        # 如果我们没有离开最后一栏，这是因为它里面都是 0 。
        return current_col + 1 if current_col != cols - 1 else -1
```

 **复杂度分析**
 设 $N$ 是行数，$M$ 是列数。

 - 时间复杂度：$O(N + M)$。在每一步，我们都在向左或向下移动一步。所以，我们总是结束在查看其中的一行或一列。所以，我们会停留在表格中最多 $N + M$ 步，所以我们获得一个时间复杂度为 $O(N + M)$。
 - 空间复杂度：$O(1)$。
   我们使用了常数的额外空间。
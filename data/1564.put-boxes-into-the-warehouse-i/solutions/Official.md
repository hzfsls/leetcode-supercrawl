## [1564.把箱子放进仓库里 I 中文官方题解](https://leetcode.cn/problems/put-boxes-into-the-warehouse-i/solutions/100000/ba-xiang-zi-fang-jin-cang-ku-li-i-by-lee-kpx5)
[TOC]

## 概览

 首先，让我们通过一个比喻来思考，这可能更容易理解。假设你站在一个洞穴的前面。洞穴向地底延伸，在不同的地方变得狭窄，然后再变宽。此外，你手里有几块不同直径的石头。你的目标是尽可能多的将石头扔进洞穴。让我们考虑一下你会使用什么策略。

 首先，如果洞穴中有一个瓶颈（非常狭窄的部分），那么即使洞穴后来变得更宽，石头也会在瓶颈前堵住。所以对洞穴中的每个位置来说，我们能插入的最大的石头受到该位置前洞穴最窄部分的限制。换句话说，该位置的_可用直径_受到其前面的最小直径的限制。

 其次，提前抛一个小石头总是比后抛好，因为如果小石头卡住了，大石头肯定也会卡住，但反过来却不成立。

 因此，我们的策略应该是先把最小的石头扔进去。

 现在我们可以把石头想象成箱子，把洞穴想象成仓库，其中每个仓库房间的高度对应洞穴的直径。问题及其解决方案现在已经等同于上面的比喻。

---

#### 方法 1：将最小的箱子添加到最右边的仓库房间

 **概述**

 我们将采取贪心的方法来解决这个问题。思路是，如果每一步都遵循最优策略，那么整个箱子的布局就会是最优的。

 假设我们有一个高度为 `h` 的箱子，我们想把它推进仓库。我们从左边开始推，我们想尽可能地将其推向右边。我们能把它推到多远的限制因素将是我们遇到的 *第一个* 仓库位置有一个高度 *小于* `h`。我们无法将箱子推入这个位置，或者任何位置在它之后。

 为了使算法更高效，我们将首先预处理仓库的高度。记住每个位置的限制因素是前面的最小高度，我们更新每个位置的高度，使其不高于这个最小值。这本质上将仓库数组改变为一个 *非严格下降* 数组。

 然后我们将箱子从最短排到最长。然后，我们拿起剩下的最短的箱子，尽可能地通过仓库将它推向右边（当下一个位置比这个箱子矮的时候我们必须停止）。

 以下是展示贪心过程的幻灯片。

 <![image.png](https://pic.leetcode.cn/1692071735-FBFKQD-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692071738-cknpCe-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692071740-nFjSFI-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692071743-EVOTFV-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692071746-MxrdUi-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692071749-ARlqVt-image.png){:width=400}>

 **算法**

 由于左侧房间的低高度会阻止箱子进入右侧的房间，我们需要对仓库高度数组进行预处理，使其成为一个非增序列。 然后，我们从最小的箱子和仓库的最右边位置开始。 如果当前的箱子可以放入仓库房间，我们将计数加 1，然后继续下一个箱子。 否则，我们转到仓库的下一个房间，检查箱子是否可以放在那里。

 ```Java [slu1]
 class Solution {
    public int maxBoxesInWarehouse(int[] boxes, int[] warehouse) {
        // 对仓库房间的高度进行预处理，以获得可用高度
        for (int i = 1; i < warehouse.length; i++) {
            warehouse[i] = Math.min(warehouse[i - 1], warehouse[i]);
        }

        // 从小到大遍历方框
        Arrays.sort(boxes);

        int count = 0;

        for (int i = warehouse.length - 1; i >= 0; i--) {
            // 清点能放进当前库房的箱子
            if (count < boxes.length && boxes[count] <= warehouse[i]) {
                count++;
            }
        }

        return count;
    }
}
 ```

 ```Python3 [slu1]
 class Solution:
    def maxBoxesInWarehouse(self, boxes: List[int], warehouse: List[int]) -> int:
        # 对仓库房间的高度进行预处理，以获得可用高度
        for i in range(1, len(warehouse)):
            warehouse[i] = min(warehouse[i - 1], warehouse[i])

        # 从最小到最大遍历方框
        boxes.sort()

        count = 0

        for room in reversed(warehouse):
            # 清点能放进当前库房的箱子
            if count < len(boxes) and boxes[count] <= room:
                count += 1

        return count
 ```

 令 $n$ 为箱子数量，将 $m$ 作为仓库房间的数量。

 * 时间复杂度： $O(n \log(n) + m)$ 因为我们需要对箱子排序 ($O(n \log n)$) 并迭代仓库房间和箱子 ($O(n + m))$)。
 * 空间复杂度： $O(1)$ 因为我们使用两个指针来迭代箱子和仓库房间。 如果我们不允许修改 `warehouse` 数组，我们将需要 $O(m)$ 额外的空间。

---

 #### 方法 2：从左到右添加最大可能的箱子

 **概述**

 如果面试官要求我们使用 $O(1)$ 的空间并且不允许我们修改原始的仓库数组呢? 这个跟进请求排除了我们之前的预处理输入数组的可能性。

 我们可以采取稍微不同的贪心策略来解决这个问题。 我们从左到右迭代仓库房间，并使用另一个迭代器从最大到最小迭代箱子。对于每个位置，我们将丢弃那些太高而无法放入当前仓库房间的箱子，因为它们不会适合进一步向右的房间。我们将最高的可能的箱子放在这个房间，剩下的箱子留给进一步向右的仓库房间。

 **算法**

 对于这种方法，我们不需要计算每个仓库房间允许的最大高度。这是因为箱子按降序排序，所以高度低的房间会自动忽略所有比它高的箱子。

 我们从最大的箱子开始，以及从仓库的最左边位置开始。当箱子可以放进仓库房间时，我们将计数加1。否则，我们抛弃箱子，尝试较小的一个。

 以下是展示这种新算法的幻灯片。

 <![image.png](https://pic.leetcode.cn/1692072048-QKllqT-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692072054-HsYzzu-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692072056-oQbUtn-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692072059-bsKjoN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692072062-iPxlto-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692072064-DYVwsV-image.png){:width=400}>

 ```Java [slu2]
 class Solution {
    public int maxBoxesInWarehouse(int[] boxes, int[] warehouse) {

        int i = boxes.length - 1;
        int count = 0;
        Arrays.sort(boxes);

        for (int room : warehouse) {
            // 从最小到最大遍历方框
            // 丢弃不适合当前仓库的箱子
            while (i >= 0 && boxes[i] > room) {
                i--;
            }

            if (i == -1) return count;
            count++;
            i--;
        }

        return count;
    }
}
 ```

 ```Python3 [slu2]
 class Solution:
    def maxBoxesInWarehouse(self, boxes: List[int], warehouse: List[int]) -> int:

        i = 0
        count = 0
        boxes.sort(reverse = True)

        for room in warehouse:
            # 从最小到最大遍历方框
            # 丢弃不适合当前仓库的箱子
            while i < len(boxes) and boxes[i] > room:
                i += 1
            if i == len(boxes):
                return count
            count += 1
            i += 1

        return count
 ```

 时间和空间复杂度将与方法 1 相似。令 $n$ 为箱子数量，$m$ 为仓库中的房间数量。

 * 时间复杂度：$O(n \log(n) + m)$ 因为我们需要对箱子排序并迭代仓库房间和箱子。
 * 空间复杂度：$O(1)$ 因为我们使用两个指针来迭代箱子和仓库房间。

 一个相关的问题是 [LeetCode 1580. 把箱子放进仓库里 II](https://leetcode.cn/problems/put-boxes-into-the-warehouse-ii/)。我建议你在理解了这个问题之后尝试一下！
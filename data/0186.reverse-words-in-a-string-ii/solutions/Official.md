[TOC]

## 解决方案

---

 **概述**

 首先，让我们理解问题。

 > *"给定一个二进制数组，找出这个数组中连续 1 的最大数量 ..."*

 到目前为止很好理解。

 >*"...如果你最多可以翻转一个 0。"*


 我们把这个问题具体化。我们可以把 “如果你最多可以翻转一个 0” 重新表述为 “在连续的 1 串中允许最多有一个 0”。 这两个陈述相等，因为如果我们在连续数组中有一个 0，我们可以翻转它以满足我们的条件。 注意，我们并不会 *真正地* 去翻转 0，这样可以使我们的方法更简单。
 所以我们的新问题描述是：
 > *"给定一个二进制数组，找出这个数组中连续 1 的最大数量，允许在连续的 1 串中最多有一个 0"*

#### 方法 1：暴力解法

 **算法**

 我们先从简单的开始，然后逐渐提升。
 一个暴力解决方案通常涉及到检查所有的可能性。它的实现应该是这样的： 

 - 检查每个可能的连续序列 
 - 计算每个序列中有多少个 0
 - 如果我们的序列中一或更少的 0，检查这是否是连续 1 的 *最长* 序列。

 ```Java [slu1]
 class Solution {
    public int findMaxConsecutiveOnes(int[] nums) {
        int longestSequence = 0;
        for (int left = 0; left < nums.length; left++) {
            int numZeroes = 0;

            // 检查每个连续序列
            for (int right = left; right < nums.length; right++) {
                // 检查有多少 0
                if (nums[right] == 0) {
                    numZeroes += 1;
                }
                // 更新答案(如果有效)
                if (numZeroes <= 1) {
                    longestSequence = Math.max(longestSequence, right - left + 1);
                }
            }
        }
        return longestSequence;
    }
}
 ```

 ```Python3 [slu1]
 class Solution:
    def findMaxConsecutiveOnes(self, nums: List[int]) -> int:
        longest_sequence = 0
        for left in range(len(nums)):
            num_zeroes = 0
            for right in range(left, len(nums)):   # 检查每个连续序列
                if num_zeroes == 2:
                    break
                if nums[right] == 0:               # 检查有多少 0
                    num_zeroes += 1
                if num_zeroes <= 1:                 # 更新答案(如果有效)
                    longest_sequence = max(longest_sequence, right - left + 1)
        return longest_sequence
 ```

 > **面试提示：** 面试官通常不希望看到你编写的暴力解法。向他说出暴力解法，并询问他的期望解法。无论如何，积极地沟通是加分项。

**复杂度分析**

 令 $n$ 等于输入 `nums` 数组的长度。

* 时间复杂度： $O(n^2)$。嵌套的 `for` 循环将我们的方法变为二次方解决方案，因为对于每个索引，我们必须检查数组中的每个其它索引。
* 空间复杂度： $O(1)$。我们使用了 4 个变量：left, right, numZeroes, longestSequence。变量的数量是常数，不会随着输入的变化而变化。

---

#### 方法 2：滑动窗口

 **概述**

 虽然暴力解法有效，但面试官并不买账。让我们看看如何优化我们刚才的代码。
 暴力解决方案是 $O(n^2)$ 的时间复杂度。它的瓶颈在哪里？检查所有可能的连续序列。准确的说，我们在做重复的工作，因为序列重叠。我们是盲目地检查连续的序列。因此需要建立一些规则来向前移动我们的序列。

* 如果我们的序列有效，让我们继续扩展我们的序列（因为我们的目标是获得最大的可能序列）。
* 如果我们的序列无效，让我们停止扩展并缩小我们的序列（因为无效的序列永远不会计算进我们最大的序列里）。

 扩展/缩小序列的模式让我想到了滑动窗口。定义有效和无效状态。

* 有效状态 = 当前序列中一个或更少的 0 
* 无效状态 = 当前序列中两个 0

**算法**

如何将所有这些应用到滑动窗口？
 我们使用左指针和右指针来追踪我们的当前序列—也就是我们的窗口。让我们通过向前移动右指针来扩展我们的窗口，直到我们的窗口中有超过一个的 0。当我们达到这种无效状态时，让我们通过向前移动左指针来缩小我们的窗口，直到我们再次有一个有效的窗口。通过扩展和缩小我们的窗口，我们可以有效地遍历数组，而不需要重复的工作。
现在我们可以将这种方法分解成几个可操作的步骤：
首先要保证我们的窗口要在数组的边界内... 

 1. 向我们的窗口添加最右边的元素
 2. 检查我们的窗口是否无效。如果是，直到有效为止收缩窗口。
 3. 更新我们看到的最长序列
 4. 继续扩展我们的窗口

 看起来像这样：

 <![image.png](https://pic.leetcode.cn/1692240845-GaWlpX-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692240847-IGghjx-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692240850-AZOIaN-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692240852-bUVPGk-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692240855-mMMzde-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692240857-MYeNSv-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692240860-HwaNNj-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692240862-TpLECb-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692240864-QjDTbW-image.png){:width=400},![image.png](https://pic.leetcode.cn/1692240867-JhGMtr-image.png){:width=400}>

 **复杂度分析**

 令 $n$ 等于输入 `nums` 数组的长度。

* 时间复杂度：$O(n)$。由于两个指针都只向前移动，左和右指针遍历的最大步数为 n，因此，时间复杂度为 $O(n)$。
* 空间复杂度：$O(1)$。和前面的方法一样，我们除了变量，什么都不存储。因此，我们所使用的空间是常数，因为它与输入数组的长度无关。